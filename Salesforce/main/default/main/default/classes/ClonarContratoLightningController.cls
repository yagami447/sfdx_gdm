public without sharing class ClonarContratoLightningController {
  
    @AuraEnabled
    public static String cloneContract(String recordId) {
        Savepoint sp = Database.setSavepoint();
        Contrato__c contrato = [SELECT Id, Estado__c FROM Contrato__c WHERE Id = :recordId ];
        Contrato__c nuevoContrato;

         try {
            contrato = [
                SELECT Id, Name, Multiplicador__c, Sociedad__c, Contrato_marco__c, Nome_Fantasia__c, Safra__c,
                Region_Comercial__c, RecordTypeId, Estados_Comercializacao__c, Observacao__c, Tipo_de_registro__c, Estado__c,
				Volume_Total_Autorizado__c, Meta_Qde_Dias_de_Campo__c, Meta_Qde_comodato_de_area__c, tieneItems__c, OwnerId
                FROM Contrato__c 
                WHERE Id = :recordId 
            ];

        }
        catch (Exception e) {
                throw new AuraHandledException('não há contrato');
        }
        
        if(contrato.Estado__c != 'Chegou') {
            throw new AuraHandledException('Erro: Para clonar o aditivo o status tem que ser "Chegou"');
        }
        else {
            try {
                
                nuevoContrato = contrato.clone(false, false);
                nuevoContrato.Contrato_ant__c = contrato.Id;
                nuevoContrato.Estado__c = 'Edição';
                nuevoContrato.RecordTypeId = contrato.RecordTypeId;
                contrato.Estado__c = 'Inutilizado';
                
                insert nuevoContrato;
                update contrato;
                
                List<Item_del_Contrato__c> itemsClonados = new List<Item_del_Contrato__c>();
                List<Item_del_Contrato__c> itemsOriginales = new List<Item_del_Contrato__c>();
                    
                itemsOriginales = [
                    SELECT Name, Cultivar__c, Precio__c, Variedad__c, Volumen_Aut_Comercializacion__c, Praca__c, Tipo_de_Referencia__c, Cotacao_de_soja__c,
                    Referencia_de_Praca__c, Referencia_de_Preco__c, Contrato_de_Multiplicacao__c, Contrato_de_Multiplicacao_vol__c, Contrato_de_Multiplicacion__c,
                    Quantidade__c, RecordTypeId, Tipo_de_Evento__c, Clonado__c, Estado__c
                    FROM Item_del_Contrato__c
                    WHERE Contrato_de_Multiplicacion__c =: contrato.id
                ];
                
                for (Item_del_Contrato__c pi : itemsOriginales) {
                    Item_del_Contrato__c nuevoItem = pi.clone(false, true);
					if(pi.Contrato_de_Multiplicacao__c != null) {
						nuevoItem.Contrato_de_Multiplicacao__c = nuevoContrato.Id;
					}
					if(pi.Contrato_de_Multiplicacao_vol__c != null) {
						nuevoItem.Contrato_de_Multiplicacao_vol__c = nuevoContrato.Id;
					}
					nuevoItem.Contrato_de_Multiplicacion__c = nuevoContrato.Id;
					nuevoItem.Clonado__c = true;
                    itemsClonados.add(nuevoItem);
                }
                insert itemsClonados;
            } catch (Exception e) {
                Database.rollback(sp);
                string message = e.getMessage();
                throw new AuraHandledException(message);
            }
        
        }
        
        return nuevoContrato.Id;        
    }
}
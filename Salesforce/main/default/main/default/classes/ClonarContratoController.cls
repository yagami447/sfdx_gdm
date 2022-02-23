public class ClonarContratoController  {
    
    private ApexPages.StandardController controller {get; set;}
    private Contrato__c contrato {get;set;}
    public ID newRecordId {get;set;}
    public Contrato__c nuevoContrato {get;set;}
    public class EstadoException extends Exception {}

    public ClonarContratoController(ApexPages.StandardController controller) {
        this.controller = controller;
        contrato = (Contrato__c)controller.getRecord();
        this.nuevoContrato = new Contrato__c();
    }
    
    public PageReference cloneWithItems() {
        
        Savepoint sp = Database.setSavepoint();
        
        try {
            contrato = [
                SELECT Id, Name,Multiplicador__c, Sociedad__c, Contrato_marco__c, Nome_Fantasia__c, Safra__c,
                Region_Comercial__c, Estados_Comercializacao__c, Observacao__c, RecordTypeId, OwnerId, tieneItems__c, Estado__c
                FROM Contrato__c
                WHERE Id = :contrato.id
            ];
            if (contrato.Estado__c != 'Chegou') {
				throw new EstadoException('Erro: Para clonar o aditivo o status tem que ser "Chegou"');            
            }
            this.nuevoContrato = contrato.clone(false, false);
            this.nuevoContrato.Contrato_ant__c = contrato.Id;
            this.nuevoContrato.Estado__c = 'Edição';
            contrato.Estado__c = 'Inutilizado';
            insert nuevoContrato;
            update contrato;
            newRecordId = this.nuevoContrato.id;
            
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
			return new PageReference('/'+nuevoContrato.id+'/e?retURL=%2F'+nuevoContrato.id);

        } catch (Exception e){
            Database.rollback(sp);
            ApexPages.addMessages(e);
            System.debug(e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        
    }
}
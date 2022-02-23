/**
* @name OpportunityHelper
* @author Jhonny Peroza
* updated 29-12-2021
*/
global class OpportunityHelper {

    public static final Decimal SACOS = 83.33;

    WebService static String deactivateOpportunity(Id IdOpp) {

        String idOppCopy;
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();

        Opportunity oppOriginal = [SELECT Id, Activa__c
                                        FROM Opportunity 
                                            WHERE Id =: IdOpp];

        oppOriginal.Activa__c = false;

        try {
            upsert oppOriginal;                   
        } catch(DmlException e) {
            System.debug('DML Error message: ' + e.getMessage());
        }

        idOppCopy=cloneOpportunity(oppOriginal.Id);
        oppLineItems=cloneOpportunityLineItems(oppOriginal.Id, idOppCopy);
        saveClonedOpportunityLineItems(oppLineItems);

        return idOppCopy;

    }

    public static String cloneOpportunity(Id IdOpp) {
        
        Integer cont = 0;

        Opportunity oppOri = [SELECT Id, Name, StageName, CloseDate, Cultura__c, Safra__c, Marca__c, Region__c, AccountId, Notificado__c, RecordTypeId
                                FROM Opportunity 
                                    WHERE Id =: IdOpp];

        List<Opportunity> queryOpp = [SELECT Id, IsClon__c 
                                        FROM Opportunity 
                                            WHERE Safra__c =: oppOri.Safra__c 
                                                AND Marca__c =: oppOri.Marca__c 
                                                AND Region__c =: oppOri.Region__c
                                                AND RecordType.Name = 'PB-Comercial Milho'];
        cont = queryOpp.size() + 1;

        List<Pricebook2> queryPriceBook = [SELECT Id FROM Pricebook2];  

        oppOri.IsClon__c = true;
        oppOri.Name = oppOri.Safra__c + '-' + 'MKT' + '-' + oppOri.Marca__c + '-' + oppOri.Region__c + '-' + cont;
        oppOri.StageName = 'PB-Edicion';
        oppOri.Activa__c = true;
        oppOri.Pricebook2Id = queryPriceBook[0].Id;

        Opportunity oppUnitClone = oppOri.clone(false, false, false, false);

        try {
            insert oppUnitClone;
        } catch(DmlException e) {
            System.debug('DML Error message: ' + e.getMessage());
        }

        return oppUnitClone.Id;
    }

    public static List<OpportunityLineItem> cloneOpportunityLineItems(String IdOpp, String idOppCopy) {

        List<OpportunityLineItem> oppLineItemsList = new List<OpportunityLineItem>();

        List<OpportunityLineItem> oppLineItems = [SELECT Id, Nome__c, Quantidade__c, Quantidade_de_Sementes__c, Product2Id, Variedad__c, Embalagem__c, Tratamento__c, OpportunityId
                                                       FROM OpportunityLineItem
                                                          WHERE OpportunityId =: idOpp];

        for(OpportunityLineItem oppLineItem : oppLineItems){
            OpportunityLineItem oppLineItemMap = new OpportunityLineItem();
            oppLineItemMap.Product2Id = oppLineItem.Product2Id;
            oppLineItemMap.Nome__c = oppLineItem.Nome__c;
            oppLineItemMap.Quantidade__c = oppLineItem.Quantidade__c;
            oppLineItemMap.Quantidade_de_sementes__c = oppLineItem.Quantidade_de_Sementes__c;
            oppLineItemMap.OpportunityId = idOppCopy;
            oppLineItemMap.Variedad__c = oppLineItem.Variedad__c;
            oppLineItemMap.Embalagem__c = oppLineItem.Embalagem__c;
            oppLineItemMap.Tratamento__c = oppLineItem.Tratamento__c;
            oppLineItemMap.Quantity = 1;
            oppLineItemMap.Bls_devolucion__c = 1;
            oppLineItemMap.UnitPrice = 1.00;
            oppLineItemsList.add(oppLineItemMap);
        }

        return oppLineItemsList;
    }

    public static void saveClonedOpportunityLineItems(List<OpportunityLineItem> oppLineItems) {

        try {
            insert oppLineItems;
        } catch(DmlException e) {
            System.debug('DML Error message: ' + e.getMessage());
        }

    }

    public static void verifyOpportunity(List<Opportunity> opportunityList) {

        Integer cont = 1;

        List<Opportunity> opportunityListInsert = new List<Opportunity>();

        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> regiones = new List<String>();

        for (Opportunity opp : opportunityList){
			safras.add(opp.Safra__c);
            marcas.add(opp.Marca__c);
            regiones.add(opp.Region__c);
		}

        List<Opportunity> queryOpp = [SELECT Id, StageName, IsClon__c, Safra__c, Marca__c, Region__c 
                                        FROM Opportunity 
                                            WHERE Safra__c IN : safras 
                                                AND Marca__c IN : marcas
                                                AND Region__c IN : regiones
                                                AND IsClon__c = false
                                                AND Activa__c = true];

        if(queryOpp.size() > 0) {
            for(Opportunity query : opportunityList) {
                query.addError('Registro existente, tente mudar a safra ou marca ou região');
            }
        }
    }

    public static void updateOpportunity(List<Opportunity> opportunityList) {

        Integer cont = 1;

        List<Opportunity> opportunityListInsert = new List<Opportunity>();

        List<Pricebook2> queryPriceBook = [SELECT Id FROM Pricebook2];   

        for(Opportunity opportunityInicial : opportunityList) {
            Opportunity opportunityMap = new Opportunity();
            if(opportunityInicial.StageName == 'PB-Edicion' && opportunityInicial.IsClon__c == false) {
                opportunityMap.Id = opportunityInicial.Id;
                opportunityMap.Name = opportunityInicial.Safra__c + '-' + 'MKT' + '-' + opportunityInicial.Marca__c + '-' + opportunityInicial.Region__c + '-' + cont;
                opportunityMap.Activa__c = true;
                opportunityMap.Pricebook2Id = queryPriceBook[0].Id;
                opportunityListInsert.add(opportunityMap);
            }
            try {
                upsert opportunityListInsert;
            } catch(DmlException e) {
                System.debug('DML Error message: ' + e.getMessage());
            }
        }
    }

    public static List<OpportunityLineItem> verifyProducts(List<Opportunity> opportunityList) {

        List<OpportunityLineItem> verifyItemsList = new List<OpportunityLineItem>();

        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> regiones = new List<String>();

        for (Opportunity opp : opportunityList){
			safras.add(opp.Safra__c);
            marcas.add(opp.Marca__c);
            regiones.add(opp.Region__c);
		}

        List<Produto_de_Requisicao__c> listProdReq = [SELECT Id, Name, Variedad__c, Embalagem__c, Tratamento__c, Quantidade__c, Quantidade_de_Sementes__c, Requisicao_de_compra__r.Cultura__c
                                                        FROM Produto_de_Requisicao__c 
                                                            WHERE Tipo__c = 'Gerente Comercial' 
                                                                AND Requisicao_de_compra__r.Estado__c = 'Aprovada' 
                                                                AND Quantidade__c != 0 
                                                                AND Requisicao_de_compra__r.Safra__c IN : safras
                                                                AND Requisicao_de_compra__r.Marca__c IN : marcas
                                                                AND Requisicao_de_compra__r.Regiao_comercial__c IN : regiones];
        if(listProdReq.size() > 0) {
            
            for(Produto_de_Requisicao__c proReq : listProdReq) {
                for(Product2 product: [SELECT Id FROM Product2 WHERE Especie__c =: proReq.Requisicao_de_compra__r.Cultura__c 
                                            AND Variedade__c =: proReq.Variedad__c AND UNIDADE__c =: proReq.Embalagem__c AND IsActive = true LIMIT 1])
                {
                    OpportunityLineItem oppLineItemMap = new OpportunityLineItem();
                    oppLineItemMap.Product2Id = product.Id;
                    oppLineItemMap.Nome__c = proReq.Name;
                    oppLineItemMap.Quantidade__c = proReq.Quantidade__c;
                    oppLineItemMap.Quantidade_de_sementes__c = proReq.Quantidade_de_Sementes__c;
                    oppLineItemMap.Producto_de_requisicion__c = proReq.Id;
                    oppLineItemMap.Variedad__c = proReq.Variedad__c;
                    oppLineItemMap.Embalagem__c = proReq.Embalagem__c;
                    oppLineItemMap.Tratamento__c = proReq.Tratamento__c;
                    verifyItemsList.add(oppLineItemMap);
                }
            }

        } else {
            for (Opportunity opp : opportunityList) {
                opp.addError('Não há requisições para esta oportunidade');
            }
        }

        if(listProdReq.size() != verifyItemsList.size()) {
            for (Opportunity opp : opportunityList) {
                opp.addError('Um ou mais itens das requisições aprovadas pelo seu gerente de marca não existem no Product2, verifique e tente novamente');
            }
        }
        return verifyItemsList;
    }

    public static void saveListItems(List<OpportunityLineItem> verifyItemsList, List<Opportunity> opportunityList) {

        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();

        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> regiones = new List<String>();

        for (Opportunity opp : opportunityList){
			safras.add(opp.Safra__c);
            marcas.add(opp.Marca__c);
            regiones.add(opp.Region__c);
		}

        AggregateResult[] listProdReq = [SELECT Name, SUM(Quantidade__c) Quantity, SUM(Quantidade_de_sementes__c) Sementes
                                            FROM Produto_de_Requisicao__c 
                                                WHERE Tipo__c = 'Gerente Comercial' 
                                                    AND Requisicao_de_compra__r.Estado__c = 'Aprovada' 
                                                    AND Quantidade__c != 0 
                                                    AND Requisicao_de_compra__r.Safra__c IN : safras
                                                    AND Requisicao_de_compra__r.Marca__c IN : marcas
                                                    AND Requisicao_de_compra__r.Regiao_comercial__c IN : regiones
                                                        GROUP BY Name];

        for(Integer j = 0; j < listProdReq.size(); j++) {
            for(OpportunityLineItem verifyProduct : verifyItemsList) {
                for(Opportunity oppor : opportunityList) {
                    if(verifyProduct.get('Nome__c') == listProdReq[j].get('Name')) {
                        OpportunityLineItem oppLineItemMap = new OpportunityLineItem();
                        oppLineItemMap.OpportunityId = oppor.Id;
                        oppLineItemMap.put('Product2Id', verifyProduct.get('Product2Id'));
                        oppLineItemMap.put('Nome__c', listProdReq[j].get('Name'));
                        oppLineItemMap.put('Quantidade__c', listProdReq[j].get('Quantity'));
                        oppLineItemMap.put('Quantidade_de_sementes__c', listProdReq[j].get('Sementes'));
                        oppLineItemMap.put('Producto_de_requisicion__c', verifyProduct.get('Producto_de_requisicion__c'));
                        oppLineItemMap.put('Variedad__c', verifyProduct.get('Variedad__c'));
                        oppLineItemMap.put('Embalagem__c', verifyProduct.get('Embalagem__c'));
                        oppLineItemMap.put('Tratamento__c', verifyProduct.get('Tratamento__c'));
                        oppLineItemMap.put('Quantity', 1);
                        oppLineItemMap.put('Bls_devolucion__c', 1);
                        oppLineItemMap.put('UnitPrice', 1.00);
                        oppLineItemList.add(oppLineItemMap);
                    }
                }
            }
        }
        try {
            insert oppLineItemList;
        } catch(DmlException e) {
            System.debug('DML Error message: ' + e.getMessage());
        }
    }
 
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> selectOpportunityLineItems (String idOpp, List<String> fields) {

        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        List<OpportunityLineItem> opportunityLineItemsFinal = new List<OpportunityLineItem>();

        String query = 'SELECT Id';

        for(Object field : fields) {
            if( !query.contains( String.valueOf(field) ) ){
                query += ', ' + field;
            }
        }

        query += + ' FROM OpportunityLineItem WHERE OpportunityId = \'' + idOpp + '\'';
        
        opportunityLineItems = Database.query(query);

        if(opportunityLineItems.size()>0) {
            for(OpportunityLineItem item : opportunityLineItems) {  
                opportunityLineItemsFinal.add(item);
            }
        }
        return opportunityLineItemsFinal;
    }

    @AuraEnabled
    public static void verifyOpportunityLineItems(List<OpportunityLineItem> listUpsert, List<OpportunityLineItem> listDelete){

        List<OpportunityLineItem> listToUpsert = new List<OpportunityLineItem>();
        List<OpportunityLineItem> listToDelete = new List<OpportunityLineItem>();

        String oppId;
        String oppPricebookId;
        if( !listUpsert.isEmpty() ) {
            oppId = listUpsert[0].opportunityId;

            Opportunity parentOpp = [ SELECT Id, Pricebook2Id, Pricebook2.Name FROM Opportunity WHERE Id = :oppId ];
            
            if( parentOpp.Pricebook2Id != null ) {
                oppPricebookId = parentOpp.Pricebook2Id;
            } else {
                Throw new AuraHandledException('A oportunidade não possui um catálogo de preços'); 
            }

            Set<String> setVariedades = new Set<String>();

            for(OpportunityLineItem oppUpsert : listUpsert) {
                setVariedades.add(oppUpsert.Variedad__c);
            }

            List<PricebookEntry> pbEntries = [  SELECT Id, Product2Id, Product2.Variedade__c 
                                                FROM PricebookEntry 
                                                WHERE Pricebook2Id = :oppPricebookId 
                                                AND Product2.Variedade__c IN :setVariedades 
                                                AND Product2.IsActive = true];
                                                
            Map<String, PricebookEntry> pbEntryByVariedad = new Map<String, PricebookEntry>();
            for( PricebookEntry pbEntry : pbEntries) {
                pbEntryByVariedad.put(pbEntry.Product2.Variedade__c, pbEntry);
            }

            for(OpportunityLineItem oppUpsert : listUpsert) {
                if(oppUpsert.Id == null) {
                    if(pbEntryByVariedad.containsKey(oppUpsert.Variedad__c)) {
                        oppUpsert.Product2Id = pbEntryByVariedad.get(oppUpsert.Variedad__c).Product2Id;
                        oppUpsert.PricebookEntryId = pbEntryByVariedad.get(oppUpsert.Variedad__c).Id;
                    } else {
                        throw new AuraHandledException('Produto(s) selecionado(s) não disponível em catálogo de preços ' + parentOpp.Pricebook2.Name);
                    }
                } 
                oppUpsert.Quantity = 1;
                oppUpsert.Bls_devolucion__c = 1;
                oppUpsert.UnitPrice = 2.00;
                oppUpsert.Quantidade__c = oppUpsert.Embalagem__c == null ? oppUpsert.Quantidade_de_Sementes__c : oppUpsert.Embalagem__c == 'Bag 5 Milhões Sementes' ? (SACOS * oppUpsert.Quantidade__c).round(system.RoundingMode.CEILING) : oppUpsert.Quantidade__c;
                listToUpsert.add(oppUpsert);
            }
        }

        for(OpportunityLineItem oppDelete : listDelete) {
            listToDelete.add(oppDelete);
        }

        upsertOpportunityLineItems(listToUpsert);
        deleteOpportunityLineItems(listToDelete); 
    }

    public static void upsertOpportunityLineItems(List<OpportunityLineItem> listUpsert){
        try {
            upsert listUpsert;
        } catch(DmlException e) {
            System.debug('DML Error message: ' + e.getMessage());
        }
    }

    public static void deleteOpportunityLineItems(List<OpportunityLineItem> listDelete){
        try {
            delete listDelete;
        } catch(DmlException e) {
            System.debug('DML Error message: ' + e.getMessage());
        }
    }
    
    public static void updateOpportunityFromTransportHistory(List<TransportHistory> TransportHistories){

        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

        for(TransportHistory transportHistory : TransportHistories){
            Opportunity currentOpp = new Opportunity();
            currentOpp.Id = transportHistory.oppId;
            currentOpp.Inicio_Cargamento__c = date.valueOf(transportHistory.inicioCarreg);
            currentOpp.Inicio_Transporte__c = date.valueOf(transportHistory.inicioTransp);
            currentOpp.Fin_Transporte__c = date.valueOf(transportHistory.fimTransporte);
            opportunitiesToUpdate.add(currentOpp);
        }
        System.debug(opportunitiesToUpdate.size());
        update opportunitiesToUpdate;
    }
}
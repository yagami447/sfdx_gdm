trigger beforeInsertUpdateOppor on Opportunity (before insert, before update) {
    //BRAXUtils.actualizarOpps(Trigger.new);        
    //BRAXUtils.actualizarNombreOpps(Trigger.new);
    //BRAXUtils.controlesStockMultiplicadores(Trigger.new);   
    // Funcionalidad Saldo por Safra
    if(Trigger.isBefore && Trigger.isInsert) {
        //OpportunityTriggerXappiaHelper.asignarEmail(Trigger.new); // Agregado 18/03/2021

        OpportunityTriggerXappiaHelper.anexoIII_Validations(Trigger.new);
        OpportunityTriggerXappiaHelper.anexoIV_Validations(Trigger.new);
    }


    if(Trigger.isBefore ) {
        

        if(Trigger.isUpdate){

            Id anexoIIIRecordType = XappiaHelper.getRecordType('Opportunity', 'Anexo_III').Id;
            Id autorizadasRecordType = XappiaHelper.getRecordType('Opportunity', 'Autorizada').Id;
            Map<Id, Double> oppIdDescuento = new Map<Id, Double>();
            Set<Id> accs = new Set<Id>();
            for(Opportunity oppUnit : Trigger.new) {
                
    
                if(oppUnit.RecordTypeId == autorizadasRecordType && 
                    Trigger.oldMap.get(oppUnit.Id).RecordTypeId == anexoIIIRecordType) {
                    oppUnit.Saldo_Habilitado__c = true;
                }
                else if(oppUnit.Saldo_Habilitado__c && 
                    oppUnit.StageName == 'AU - Autorizada' &&
                    oppUnit.StageName != Trigger.oldMap.get(oppUnit.Id).StageName) {
    
                    oppIdDescuento.put(oppUnit.Id, 0);
                    accs.add(oppUnit.AccountId);
                }
                
            }
    
            List<Saldo_por_safra__c> saldos = New List<Saldo_por_safra__c>();
            if (accs.size() > 0)
                saldos = [SELECT Id, Saldo__c, Safra__c, Account__c 
                                               FROM Saldo_por_safra__c 
                                               WHERE Account__c IN :accs];
            Map<String, Saldo_por_safra__c> accIdSaldo = new Map<String, Saldo_por_safra__c>();
            for(Saldo_por_safra__c saldo : saldos) {
                saldo.Saldo__c = 0;
                accIdSaldo.put(saldo.Account__c + saldo.Safra__c , saldo);
            }
    
            List<OpportunityLineItem> items = New List<OpportunityLineItem>();
            if (oppIdDescuento.size() > 0) 
                items = [SELECT Id, Descuento_Adicional__c, OpportunityId 
                                               FROM OpportunityLineItem 
                                               WHERE OpportunityId 
                                               IN :oppIdDescuento.keySet()];
            for(OpportunityLineItem item : items) {
                if(item.Descuento_Adicional__c != null) {
                    oppIdDescuento.put(item.OpportunityId, Double.valueOf(item.Descuento_Adicional__c) + oppIdDescuento.get(item.OpportunityId));
                }
            }
    
    
            Saldo_por_safra__c saldoAux; 
            for(Id Opp : oppIdDescuento.keySet()) {
                String key = Trigger.newMap.get(Opp).AccountId + Trigger.newMap.get(Opp).Safra__c;
                if(accIdSaldo.containsKey(key)) {
                    saldoAux = accIdSaldo.get(key);
                    saldoAux.Saldo__c += oppIdDescuento.get(Opp);
                }
                else {
                    saldoAux = new Saldo_por_safra__c();
                    saldoAux.Account__c = Trigger.newMap.get(Opp).AccountId;
                    saldoAux.Saldo__c = oppIdDescuento.get(Opp);
                    saldoAux.Safra__c = Trigger.newMap.get(Opp).Safra__c;
                    accIdSaldo.put(key, saldoAux);
                }   
            }
    
            
            upsert accIdSaldo.values();
    
            for(Opportunity opp : Trigger.new) {
                String key = opp.AccountId + opp.Safra__c;
                if(accIdSaldo.containsKey(key)) {
                    opp.Saldo_por_safra__c = accIdSaldo.get(key).Id;
                }
            }
        }
    
    }
}
trigger OppSyncTrigger on Opportunity (after update) {
    /*
    Id vendaBasicaId = XappiaHelper.getRecordType('Opportunity', 'Venda_da_Basica_full').Id;
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        List<Opportunity> vendaBasicaList = new List<Opportunity>();
        for(Opportunity oppUnit : Trigger.new) {
            
            if(oppUnit.RecordTypeId == vendaBasicaId)  vendaBasicaList.add(oppUnit);
        }
        OppSyncTriggerHelper.runSyncQuote(vendaBasicaList, Trigger.oldMap);
    }    
    OppSyncTriggerHelper.firstTime = false;
    */
}
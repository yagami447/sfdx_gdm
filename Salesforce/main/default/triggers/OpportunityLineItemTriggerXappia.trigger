trigger OpportunityLineItemTriggerXappia on OpportunityLineItem (before insert, before update, after insert, after update, after delete, after undelete) {        
    
    if (Trigger.isInsert){
        
        for (OpportunityLineItem i : Trigger.New)
        if (i.Tipo_Registro__c == 'Estimativa de faturamento' || i.Tipo_Registro__c == 'Pendiente')
        return;
        
        List<OpportunityLineItem> vbOlis = OpportunityLineItemTriggerXappiaHelper.getVBRecords(Trigger.new);
        if (Trigger.isBefore){
            OpportunityLineItemTriggerXappiaHelper.ValidaProductosCVB(Trigger.new);
            OpportunityLineItemTriggerXappiaHelper.populateRequiredFields(Trigger.new);
            OpportunityLineItemTriggerXappiaHelper.setFixedPriceProducts(Trigger.new, null); // Added by irina.benitez@cloudgaia.com 14-sep-21 for US #12786

        }
        if (Trigger.isAfter){
            OpportunityLineItemTriggerXappiaHelper.OppLineSync(vbOlis,Trigger.oldMap,'isInsert');
        }
    }
    
    if (Trigger.isUpdate){
        
        for (OpportunityLineItem i : Trigger.New)
        if (i.Tipo_Registro__c == 'Estimativa de faturamento' || i.Tipo_Registro__c == 'Pendiente')
        return;
    
        if (Trigger.isBefore){
            OpportunityLineItemTriggerXappiaHelper.ValidaProductosCVB(Trigger.new);
            OpportunityLineItemTriggerXappiaHelper.setFixedPriceProducts(Trigger.new, Trigger.oldMap); // Added by irina.benitez@cloudgaia.com 14-sep-21 for US #12786

        }
        if (Trigger.isAfter){
            List<OpportunityLineItem> vbOlis = OpportunityLineItemTriggerXappiaHelper.getVBRecords(Trigger.new);
            OpportunityLineItemTriggerXappiaHelper.OppLineSync(vbOlis,Trigger.oldMap,'isUpdate');
        }   
    }
    
    if(Trigger.isAfter) {
        List<OpportunityLineItem> objects = new List<OpportunityLineItem>(); 
        if(Trigger.isDelete) {
            objects = Trigger.old;
        }else {
            String dml = trigger.isInsert ? 'isInsert' : 'isUpdate';
            
            OpportunityLineItemTriggerXappiaHelper.filterVBRecords_LREngineUpdate(Trigger.new,Trigger.oldMap,dml);
        }       
        
    }
}
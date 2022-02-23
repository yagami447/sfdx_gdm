trigger OpportunityPDFTrigger on Opportunity (after update, after insert) {
	
    private static final Map<String, Schema.RecordTypeInfo> rtMapOpportunity = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByName();
    private static final Set<Id> docusignRtIdList = new Set<Id> {
        rtMapOpportunity.get('Anexo II Rebaixamento Sacas').getRecordTypeId(),
        rtMapOpportunity.get('Reembalaje').getRecordTypeId(),
        rtMapOpportunity.get('Anexo I').getRecordTypeId()
    };
    
    for (Opportunity opportunityObject : Trigger.New){
        if(Trigger.isUpdate) {
        	if(docusignRtIdList.contains(opportunityObject.RecordTypeId)) {
                if(opportunityObject.StageName == 'Aguardando Assinatura' && System.Trigger.oldMap.get(opportunityObject.Id).StageName != 'Aguardando Assinatura') {
                	RecordType recordTypeObject = [SELECT Name FROM RecordType WHERE Id = :opportunityObject.RecordTypeId AND SObjectType = 'Opportunity' LIMIT 1];
                    Boolean lic = opportunityObject.OwnerId == '00540000001TUHM' ? true : false;
                   	try {
                    	if(!Test.isRunningTest()) {
                        	PdfGeneratorController.generateOpportunityDocusignPDFFuture(opportunityObject.Id, recordTypeObject.Name, lic);  
                        }
                    } catch(Exception e) {
                    	ExceptionManager.saveException(e, 'OpportunityPDFTrigger', 'AfterUpdate', opportunityObject.Id);
                   	}
                }
            }   
        } 
    }       
}
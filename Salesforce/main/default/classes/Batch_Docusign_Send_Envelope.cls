global class Batch_Docusign_Send_Envelope implements Database.Batchable<sObject>, Database.AllowsCallouts {

    Set<Id> opportunityFailedSet = new Set<Id>();
        
    global Database.QueryLocator start(Database.BatchableContext bc){   
        Set<Id> recordTypeIdSet = new Set<Id>{
            '01240000000M7Lv',
            '01240000000MDvB',
            '01240000000M7P4'
        };
        String stageName = 'Aguardando Assinatura';
        return Database.getQueryLocator('SELECT Id, OwnerId, RecordType.Name FROM Opportunity WHERE RecordTypeId IN :recordTypeIdSet AND StageName = :stageName');
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> opportunityObjectList) {
    	List<dfsle__EnvelopeStatus__c> envelopeStatusObjectList = [SELECT Id FROM dfsle__EnvelopeStatus__c WHERE dfsle__SourceId__c = :opportunityObjectList.get(0).Id LIMIT 1];
        if(envelopeStatusObjectList.size() == 0) {
            Boolean lic = opportunityObjectList.get(0).OwnerId == '00540000001TUHM' ? true : false;
            try {
                if(!Test.isRunningTest()) {
                	PdfGeneratorController.generateOpportunityDocusignPDF(opportunityObjectList.get(0).Id, opportunityObjectList.get(0).RecordType.Name, lic);    
                }  
            } catch(Exception e) {
                ExceptionManager.saveException(e, 'Batch_Docusign_Send_Envelope', 'execute', opportunityObjectList.get(0).Id);
            }
        }
    }
    
    global void finish(Database.BatchableContext bc) {}
}
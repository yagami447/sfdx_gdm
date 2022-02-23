@isTest
public class EnvelopeStatusTrigger_Test {

    private static final Test_Utils testUtils = Test_Utils.getInstance();
    
    static testMethod void shoudlProcessOpportunityCompleted() {        
        Opportunity opportunityObject = testUtils.createNewOpportunityAnexo2RebajaSupervisorOrGerente(null, 'Supervisor');
        opportunityObject.CoordenadorDaConta__c = UserInfo.getUserId();
        insert opportunityObject;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('coment');
        req1.setObjectId(opportunityObject.Id);
        req1.setNextApproverIds(new Id[] {opportunityObject.OwnerId});
        req1.setProcessDefinitionNameOrId('Docusign_Supervisores_v2');
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);        
        Id approvalProcessItemId = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :opportunityObject.Id ORDER BY CreatedDate DESC LIMIT 1].Id;
        
        dfsle__EnvelopeStatus__c statusObject = new dfsle__EnvelopeStatus__c();
        statusObject.dfsle__SourceId__c = opportunityObject.Id;
        statusObject.dfsle__DocuSignId__c = 'envelopeid';
        statusObject.dfsle__Status__c = 'Sent';
        insert statusObject;
        statusObject.dfsle__Status__c = 'Completed';
        
        Test.startTest();
        update statusObject;
        Test.stopTest();
    }
    
    static testMethod void shoudlProcessContratoMultiplicacaoDeclined() {        
        Opportunity opportunityObject = testUtils.createNewOpportunityAnexo2RebajaSupervisorOrGerente(null, 'Supervisor');
        insert opportunityObject;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('coment');
        req1.setObjectId(opportunityObject.Id);
        req1.setNextApproverIds(new Id[] {opportunityObject.OwnerId});
        req1.setProcessDefinitionNameOrId('Docusign_Supervisores_v2');
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);        
        Id approvalProcessItemId = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :opportunityObject.Id ORDER BY CreatedDate DESC LIMIT 1].Id;
                
        dfsle__EnvelopeStatus__c statusObject = new dfsle__EnvelopeStatus__c();
        statusObject.dfsle__SourceId__c = opportunityObject.Id;
        statusObject.dfsle__DocuSignId__c = 'envelopeid';
        statusObject.dfsle__Status__c = 'Sent';
        insert statusObject;
        statusObject.dfsle__Status__c = 'Declined';
        
        opportunityObject.Motivo_de_Rechazo__c = 'rejeitar';
        update opportunityObject;
        
        Test.startTest();
        update statusObject;
        Test.stopTest();
    }
}
@isTest
public class Batch_Docusign_Approval_Process_Test {
	
    private final static Test_Utils testUtils = Test_Utils.getInstance();
    
    static testMethod void shouldApproveOpportunity() {
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
        
        opportunityObject.StageName = 'Aguardando Assinatura';
        update opportunityObject;
        
        dfsle__EnvelopeStatus__c statusObject = new dfsle__EnvelopeStatus__c();
        statusObject.dfsle__SourceId__c = opportunityObject.Id;
        statusObject.Oportunidade__c = opportunityObject.Id;
        statusObject.dfsle__DocuSignId__c = 'envelopeid';
        statusObject.dfsle__Status__c = 'Completed';
        insert statusObject;
                
        Test.startTest();
        ID batchId = Database.executeBatch(new Batch_Docusign_Approval_Process());
        Test.stopTest();
    }
}
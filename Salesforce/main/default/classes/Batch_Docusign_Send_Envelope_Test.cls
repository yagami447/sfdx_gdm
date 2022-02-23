@isTest
public class Batch_Docusign_Send_Envelope_Test {

    private final static Test_Utils testUtils = Test_Utils.getInstance();
    
    static testMethod void shouldSendEnvelope() { 
        Opportunity opportunityObject = testUtils.createNewOpportunityAnexo2RebajaSupervisorOrGerente(null, 'Supervisor');
        opportunityObject.StageName = 'Aguardando Assinatura';
        insert opportunityObject;
        Test.startTest();
        ID batchId = Database.executeBatch(new Batch_Docusign_Send_Envelope());
        Test.stopTest();
    }
}
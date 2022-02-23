@isTest
public class OpportunityPDFTrigger_Test {
    
    private static final Test_Utils testUtils = Test_Utils.getInstance();

    public static testmethod void shouldCallPdfGeneratorController() {
        Opportunity opportunityObject = testUtils.createNewOpportunityAnexo2RebajaSupervisorOrGerente(null, 'Supervisor');
        insert opportunityObject;
        opportunityObject.StageName = 'Aguardando Assinatura';
        update opportunityObject;
    }
}
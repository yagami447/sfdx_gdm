@IsTest
private class vbCancelButtonControllerTest {
    
    @TestSetup static void setup() {
        insert new Configuracion_BMX__c(PM_Safra_Actual__c = '20/21');
        
        Account account = Build.anAccount()
            .withType('Multiplicador')
            .withMarca('BRMX')
            .build();
        
        insert account;

        Pricebook2 pricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );

        update pricebook;

        Opportunity opportunity = Build.anOpportunityCVBPendiente()
            .withStageName('PE - Pendiente')
            .withAccountId(account)
            .withPricebook2Id(pricebook)
            .build();
        
        opportunity.Nro_Pedido_SAP__c = '0000294830';
        opportunity.PE_Bajar_SAP__c = false;
        opportunity.Observaciones_Paso_a_SAP__c = 'Venda Normal Serv 294830 se ha grabado';

        insert opportunity;
    }

    @isTest static void cancelCVBPendiente() {
        String[] response = null;

        Test.startTest();
        Opportunity CVBPendiente = [SELECT Id, StageName FROM Opportunity LIMIT 1];

        response = vbCancelButtonController.sendCanceltionRequest(CVBPendiente.Id, CVBPendiente.StageName);
        Test.stopTest();

        System.assert(!response.isEmpty(), 'El response está vacío');
    }

    @isTest static void cancelCVBAutorizada() {
        String[] response = null;

        Test.startTest();
        Opportunity CVBPendiente = [SELECT Id, StageName FROM Opportunity LIMIT 1];

        CVBPendiente.StageName = 'AU - Autorizada';

        update CVBPendiente;

        response = vbCancelButtonController.sendCanceltionRequest(CVBPendiente.Id, CVBPendiente.StageName);
        Test.stopTest();

        System.assert(!response.isEmpty(), 'El response está vacío');
    }
}
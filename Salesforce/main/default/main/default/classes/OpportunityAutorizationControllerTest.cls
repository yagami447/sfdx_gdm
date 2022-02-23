@IsTest
private class OpportunityAutorizationControllerTest {

    @TestSetup
    static void setup() {
        Configuracion_BMX__c conf = new Configuracion_BMX__c(PM_Safra_Actual__c = '18/19');
        insert conf;

        Categoria__c category = Build.aCategoria().withName('BASICA').withShowPortal(true).build();
        insert category;

        Product2 product = Build.aProduct2()
            .withName('Test product2')
            .withCategoria('BASICA')
            .withFamily('Royalty x Basica')
            .withPrice(40)
            .withIsActive(true)
            .withCateg(category)       
            .build();

        insert product;

        PricebookEntry pricebookEntry = Build.aPricebookEntry()
            .withPricebook2Id(Test.getStandardPricebookId())
            .withUnitPrice(58)
            .withProduct2Id(product)
            .withIsActive(true)
            .build();

        insert pricebookEntry;

        Account account = Build.anAccount().build();
        insert account;

        Opportunity opportunity = Build.anOpportunityCVBPendiente()
            .withAccountId(account)
            .withPricebook2Id(Test.getStandardPricebookId())
            .withCloseDate(System.today())
            .withMarca('BRMX')
            .withStageName('Aberta')
            .withSafra('14/15')
            .withMes('Março')
            .build();

        insert opportunity;

        OpportunityLineItem opportunityLineItem = Build.anOpportunityLineItem() 
            .withOpportunityId(opportunity)
            .withQuantity(20)
            .withUnitPrice(10)
            .withPricebookEntryId(pricebookEntry)
            .withSementeaprovada(50)
            .withSementecomercializada(50)
            .withBasedeCalculo(40)
            .withTasas(12)
            .build();

        insert opportunityLineItem;
    }

    @IsTest static void hasOpportunityLineItem() {
        Estado__c state = new Estado__c(Name='PR');
        insert state;

        Centro_Logistico__c logisticCenter = new Centro_Logistico__c(Codigo_SAP__c='20442',Name='BA', Estado__c=state.Id); 
        insert logisticCenter;
        
        Opportunity opportunnityToValidate = [SELECT Id, Origen__c FROM Opportunity LIMIT 1];

        opportunnityToValidate.Origen__c = logisticCenter.Id;
        update opportunnityToValidate;

        delete [SELECT Id FROM OpportunityLineItem];

        opportunnityToValidate = [
            SELECT Id, RecordTypeId, StageName, HasOpportunityLineItem, Sucursal__c, Origen__c, Destinatario_de_Mercaderia__c FROM Opportunity LIMIT 1
        ];

        test.startTest();
        try {
            String result = OpportunityAutorizationController.sendAutorizationRequest(opportunnityToValidate);
        } catch (Exception e) {
            System.assertEquals('Opportunity sem Produtos', e.getMessage());
        }
        test.stopTest();
    }

    @IsTest static void oppAnulada() {
        Estado__c state = new Estado__c(Name='PR');
        insert state;

        Centro_Logistico__c logisticCenter = new Centro_Logistico__c(Codigo_SAP__c='20442',Name='BA', Estado__c=state.Id); 
        insert logisticCenter;

        Opportunity opportunnityToValidate = [
            SELECT Id, RecordTypeId, StageName, HasOpportunityLineItem, Sucursal__c, Origen__c, Destinatario_de_Mercaderia__c FROM Opportunity LIMIT 1
        ];

        opportunnityToValidate.StageName = 'AN - Anulada';
        opportunnityToValidate.Origen__c = logisticCenter.Id;
        update opportunnityToValidate;

        test.startTest();
        try {
            String result = OpportunityAutorizationController.sendAutorizationRequest(opportunnityToValidate);
        } catch (Exception e) {
            System.assertEquals('Venda da Basica Anulada', e.getMessage());
        }
        test.stopTest();
    }

    @IsTest static void originEmpty() {
        Opportunity opportunnityToValidate = [
            SELECT Id, RecordTypeId, StageName, HasOpportunityLineItem, Sucursal__c, Origen__c, Destinatario_de_Mercaderia__c FROM Opportunity LIMIT 1
        ];

        opportunnityToValidate.Origen__c = null;
        opportunnityToValidate.Sucursal__c = null;
        update opportunnityToValidate;

        test.startTest();
        try {
            String result = OpportunityAutorizationController.sendAutorizationRequest(opportunnityToValidate);
        } catch (Exception e) {
            System.assertEquals('Falta sucursal', e.getMessage());
        }
        test.stopTest();
    }

    @IsTest static void mercaderiaEmpty() {
        Estado__c state = new Estado__c(Name='PR');
        insert state;

        Centro_Logistico__c logisticCenter = new Centro_Logistico__c(Codigo_SAP__c='20442',Name='BA', Estado__c=state.Id); 
        insert logisticCenter;

        Opportunity opportunnityToValidate = [
            SELECT Id, RecordTypeId, StageName, HasOpportunityLineItem, Sucursal__c, Origen__c, Destinatario_de_Mercaderia__c FROM Opportunity LIMIT 1
        ];

        opportunnityToValidate.Origen__c = logisticCenter.Id;
        opportunnityToValidate.Destinatario_de_Mercaderia__c = null;
        update opportunnityToValidate;

        test.startTest();
        try {
            String result = OpportunityAutorizationController.sendAutorizationRequest(opportunnityToValidate);
        } catch (Exception e) {
            System.assertEquals('Falta Destinatario', e.getMessage());
        }
        test.stopTest();
    }

    @IsTest static void sendToValidarPasoVBSAP() {
        RecordType recordTypeCVBPendiente = XappiaHelper.getRecordType('Opportunity', 'CVB_Pendiente');

        Estado__c state = new Estado__c(Name='PR');
        insert state;

        Centro_Logistico__c logisticCenter = new Centro_Logistico__c(Codigo_SAP__c='20442',Name='BA', Estado__c=state.Id); 
        insert logisticCenter;

        Account anAccount = [SELECT Id FROM Account LIMIT 1];

        Contact aContact = Build.aContactDestinatarioBloqueado().withAccountId(anAccount).build();
        insert aContact;

        Opportunity opportunnityToValidate = [
            SELECT Id, RecordTypeId, StageName, HasOpportunityLineItem, Sucursal__c, Origen__c, Destinatario_de_Mercaderia__c FROM Opportunity LIMIT 1
        ];

        opportunnityToValidate.RecordTypeId = recordTypeCVBPendiente.Id;
        opportunnityToValidate.Origen__c = logisticCenter.Id;
        opportunnityToValidate.Destinatario_de_Mercaderia__c = aContact.Id;
        update opportunnityToValidate;

        test.startTest();
        String result = OpportunityAutorizationController.sendAutorizationRequest(opportunnityToValidate);
        test.stopTest();

        System.assertNotEquals(null, JSON.deserializeUntyped(result));
    }
}
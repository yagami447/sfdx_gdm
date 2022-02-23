@isTest
private class approvalButtonCRMEventoControllerTest {

    @TestSetup static void setup() {
        Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX()
        .withPMSafraActualEventos('18/19')
        .build();

        insert testConfiguracionBMX;

        Account account = Build.anAccount()
            .withName('JERE')
            .withNomefantasia('JRERE')
            .withResponsavel('061 - Fernando Frehner')
            .withType('Multiplicador')
            .build();

        insert account;

        Product2[] products = new Product2[]{
            new Product2(Name = 'Outro', Especie__c = 'SOJA', Obtentor__c = 'ADVANTA'),
            new Product2(Name = '68i69RSF IPRO', Especie__c = 'TRIGO', Obtentor__c = 'Don Mario'),
            new Product2(Name = 'SYN 1359S IPRO', Especie__c = 'SOJA', Obtentor__c = 'Syngenta')
        };

        insert products;

        Estado__c estado = new Estado__c(
            Name = 'SP',
            Mostrar_en_portal__c = true,
            Estado_de_Origem__c = true
        );

        insert estado;

        Cidade__c ciudad = new Cidade__c(
            Name = 'ADAMANTINA',
            GeoCod_municipio__c = '3500105',
            Mesorregion__c = 'PRESIDENTE PRUDENTE',
            Estado__c = estado.Id
        );

        insert ciudad;

        CRM_Calendario_de_Eventos__c crmEvento = new CRM_Calendario_de_Eventos__c(
            Data__c = Date.today(),
            Cuenta__c = account.id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Test_a_campo'].Id,
            Safra__c = '18/19',
            Marca__c = 'NEOG',
            Fase__c = 'Edição',
            Municipio__c = ciudad.Id,
            Realizado_por__c = 'Multiplicador'
        );

        insert crmEvento;

        CRM_Detalle_Calendario_de_eventos__c detalleCRMEvento = new CRM_Detalle_Calendario_de_eventos__c(
            CRM_Calendario_de_eventos__c = crmEvento.Id,
            Obtentor__c = 'ADVANTA',
            Cultivar__c = products[0].Id,
            Data_de_colheita__c = Date.today().addDays(-30),
            Data_de_plantio__c = Date.today().addDays(30),
            Area_Colhida__c = 3.5,
            Area_Plantada__c = 3.5,
            Produtividade__c = 500,
            Volume_Doado__c = 5.0,
            Populacao_de_plantas__c = 5.5,
            Espacamento__c = 5.5,
            Cultura_antecessora__c = 'Ervilhaca',
            Produto_Principal__c = true
        );

        insert detalleCRMEvento;

        ContentVersion contentVersion = new ContentVersion(
            Title = 'picture 1',
            PathOnClient = 'pic_1.jpg',
            VersionData = Blob.valueOf('Test Content 1'),
            IsMajorVersion = true
        );

        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = crmEvento.Id,
            ContentDocumentId = documents[0].Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );

        insert cdl;
    }

    @isTest static void getItemsTest() {
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id FROM CRM_Calendario_de_Eventos__c];
        List<CRM_Detalle_Calendario_de_eventos__c> result = null;

        Test.startTest();
        result = approvalButtonCRMEventoController.getItems(crmEvento.Id);
        System.assertEquals(1, result.size());

        insert new CRM_Detalle_Calendario_de_eventos__c(
            CRM_Calendario_de_eventos__c = crmEvento.Id,
            Obtentor__c = 'Don Mario',
            Cultivar__c = [SELECT Id FROM Product2 WHERE Name = '68i69RSF IPRO'].Id,
            Data_de_colheita__c = Date.today().addDays(-25),
            Data_de_plantio__c = Date.today().addDays(35),
            Area_Colhida__c = 3.3,
            Area_Plantada__c = 3.3,
            Produtividade__c = 300,
            Volume_Doado__c = 2.5,
            Populacao_de_plantas__c = 4.5,
            Espacamento__c = 4.5,
            Cultura_antecessora__c = 'Ervilhaca'
        );

        result = approvalButtonCRMEventoController.getItems(crmEvento.Id);
        System.assertEquals(2, result.size());
        Test.stopTest();
    }

    @isTest static void countNumberOfDocumentsTest() {
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id FROM CRM_Calendario_de_Eventos__c];
        AggregateResult result = null;

        Test.startTest();
        result = approvalButtonCRMEventoController.countNumberOfDocuments(crmEvento.Id);
        System.assertEquals(1, result.get('Total'));

        ContentVersion contentVersion = new ContentVersion(
            Title = 'picture 2',
            PathOnClient = 'pic_2.jpg',
            VersionData = Blob.valueOf('Test Content 2'),
            IsMajorVersion = true
        );

        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = crmEvento.Id,
            ContentDocumentId = documents[1].Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );

        insert cdl;

        result = approvalButtonCRMEventoController.countNumberOfDocuments(crmEvento.Id);
        System.assertEquals(2, result.get('Total'));
        Test.stopTest();
    }

    @isTest static void sendApprovalRequestTest() {
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id, OwnerId FROM CRM_Calendario_de_Eventos__c];

        Test.startTest();
        Boolean result = approvalButtonCRMEventoController.sendApprovalRequest(crmEvento.Id, crmEvento.OwnerId);

        System.assert(result);

        ProcessInstance[] processInstances = [SELECT Id, TargetObjectId FROM ProcessInstance WHERE TargetObjectId = :crmEvento.Id];

        System.assertEquals(1, processInstances.size());
        Test.stopTest();
    }
}
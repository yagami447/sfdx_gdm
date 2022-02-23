@isTest
private class AttachmentContentControllerTest {

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

        Estado__c estado = new Estado__c(Name = 'California');
        insert estado;

        Cidade__c ciudad = new Cidade__c(Name = 'Los Angeles', Estado__c = estado.Id);
        insert ciudad;

        CRM_Calendario_de_Eventos__c crmEvento = new CRM_Calendario_de_Eventos__c(
            Data__c = Date.today(),
            Cuenta__c = account.Id,
            Evento__c = 'Lado a Lado',
            Fase__c = 'Edição',
            Safra__c = '18/19',
            Municipio__c = ciudad.Id
        );

        insert crmEvento;

        Attachment_Content__c attContent = new Attachment_Content__c(
            CRM_Calendario_de_Eventos__c = crmEvento.Id
        );

        insert attContent;

        Attachment att = new Attachment(
            Name = 'Unit Test Attachment',
            Body = Blob.valueOf('Unit Test Attachment Body'),
            parentId = attContent.Id
        );

        insert att;
    }

    @isTest static void addAttachmentContentTest() {
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id FROM CRM_Calendario_de_Eventos__c LIMIT 1];

        Test.startTest();
        AttachmentContentController.addAttachmentContent(crmEvento.Id, 'Arquivos gerais', 'Test Attachment', 'image/jpg', 'AAABBBCCC');

        System.assertEquals(2, [SELECT Id FROM Attachment_Content__c].size());
        System.assertEquals(2, [SELECT Id FROM Attachment].size());

        try {
            AttachmentContentController.addAttachmentContent(crmEvento.Id, '', '', '', null);
        } catch (Exception e) {}
        Test.stopTest();
    }

    @isTest static void getAttachmentContentsTest() {
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id FROM CRM_Calendario_de_Eventos__c LIMIT 1];

        Test.startTest();
        List<Map<String, String>> attContents = AttachmentContentController.getAttachmentContents(crmEvento.Id);

        System.assertEquals(1, attContents.size());

        Map<String, String> attContent = attContents[0];

        System.assert(String.isNotEmpty(attContent.get('id')));
        System.assertEquals('Unit Test Attachment', attContent.get('AttachmentName'));
        Test.stopTest();
    }

    @isTest static void downloadAttachmentContentTest() {
        Attachment_Content__c attContent = [SELECT Id FROM Attachment_Content__c LIMIT 1];

        Test.startTest();
        Id attachmentId = AttachmentContentController.downloadAttachmentContent(attContent.Id);

        System.assertEquals([SELECT Id FROM Attachment LIMIT 1].Id, attachmentId);
        Test.stopTest();
    }

    @isTest static void removeAttachmentContentTest() {
        Attachment_Content__c attContent = [SELECT Id FROM Attachment_Content__c LIMIT 1];

        Test.startTest();
        AttachmentContentController.removeAttachmentContent(attContent.Id);

        System.assertEquals(0, [SELECT Id FROM Attachment_Content__c].size());
        System.assertEquals(0, [SELECT Id FROM Attachment].size());

        try {
            AttachmentContentController.removeAttachmentContent(attContent.Id);
        } catch (Exception e) {}
        Test.stopTest();
    }
}
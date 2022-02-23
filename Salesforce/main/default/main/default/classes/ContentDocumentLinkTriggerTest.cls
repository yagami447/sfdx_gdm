@isTest
public class ContentDocumentLinkTriggerTest {

    @testSetup
    static void setup() {
        Account acc = new Account(
        	Name = 'Test'
        );
        
        CRM_Calendario_de_Eventos__c crmEvento = new CRM_Calendario_de_Eventos__c(
        	Name = 'Test',
            Evento__c = 'Día de Campo',
            Cuenta__c = acc.Id,
            Safra__c = '19/20'
        );
        insert crmEvento;
        
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink(
        	ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion].ContentDocumentId,
        	LinkedEntityId = crmEvento.Id
        );
        insert cdl;
    }
    
    @isTest
    static void testInsert() {
        CRM_Calendario_de_Eventos__c crmEvento = [
            SELECT Arquivos_cont__c
            FROM CRM_Calendario_de_Eventos__c
        ];
        
        System.assertEquals(1, crmEvento.Arquivos_cont__c);
        
        Decimal arqivosCont = crmEvento.Arquivos_cont__c;
        
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink(
        	ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId,
        	LinkedEntityId = crmEvento.Id
        );
        
        Test.startTest();
        insert cdl;
        Test.stopTest();
        
        crmEvento = [
            SELECT Arquivos_cont__c
            FROM CRM_Calendario_de_Eventos__c
        ];
        
        System.assertEquals(arqivosCont + 1, crmEvento.Arquivos_cont__c);
    }
    
    @isTest
    static void testDelete() {
        CRM_Calendario_de_Eventos__c crmEvento = [
            SELECT Arquivos_cont__c
            FROM CRM_Calendario_de_Eventos__c
        ];
        
        System.assertEquals(1, crmEvento.Arquivos_cont__c);
        
        Decimal arqivosCont = crmEvento.Arquivos_cont__c;
        
        Test.startTest();
        delete [
            SELECT Id
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :crmEvento.Id
        ];
        Test.stopTest();       
        
        crmEvento = [
            SELECT Arquivos_cont__c
            FROM CRM_Calendario_de_Eventos__c
        ];
        
        System.assertEquals(arqivosCont - 1, crmEvento.Arquivos_cont__c);
    }
}
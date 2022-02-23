@isTest
public class CRMEventosUpdaterBatchTest {

    @isTest
    static void testBatch() {
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
        
        crmEvento.Arquivos_cont__c = 0;
        update crmEvento;
        
        Test.startTest();
        Database.executeBatch(new CRMEventosUpdaterBatch());
        Test.stopTest();
        
        crmEvento = [
            SELECT Arquivos_cont__c
            FROM CRM_Calendario_de_Eventos__c
        ];
        
        System.assertEquals(1, crmEvento.Arquivos_cont__c);
    }
    
}
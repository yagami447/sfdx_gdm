@isTest
public class DeleteAttachmentAPITest {

    @TestSetup
    static void makeData(){
        

        Regiao__c testRegion = new Regiao__c(Name = 'REGION 1',
                                             Region_Comercial__c = 'REGION 1'
                                            );
        insert testRegion;
        
        List<Account> accList = new List<Account>();

        Id accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta').getRecordTypeId();

        Account testAccount = new Account(Name = 'Test Account',
                                          CNPJ_CPF__c = '123456789-11',
                                          Grupo_de_Cuentas__c = 'CMEX',
                                          RecordTypeId = accountRecordType,
                                          Ativo__c = true,
                                          Cliente_de__c = 'BRASMAX',
                                          Safras__c = '20/21',
                                          Region__c = testRegion.Id
                                          );

        accList.add(testAccount);
        insert accList;             

        Categoria__c testCategory = new Categoria__c(Name = 'BASICA', Mostrar_en_portal__c = true);
        insert testCategory;

        List<Variedad__c> variedadList = new List<Variedad__c>();       
        Variedad__c testVariedad = new Variedad__c (Name = 'Variedad Test', Ativa__c = true);
        variedadList.add(testVariedad);
        insert variedadList;

        List<Product2> productList = new List<Product2>();
        Product2 testProduct =  new Product2(Name = 'Product 1 Test', 
                                             IsActive = true,
                                             Categ__c = testCategory.Id,
                                             Family = 'Royalty x Basica',
                                             Variedade__c = variedadList[0].Id,
                                             UNIDADE__c = 'Quilograma'
                                             );
         productList.add(testProduct);
         insert productList;

        List<CRM_Calendario_de_Eventos__c> eventList = TestDataFactory.createEventos(1, accList,'Test a campo');
         
        Attachment_Content__c testAttContent = new Attachment_Content__c(CRM_Calendario_de_Eventos__c = eventList[0].Id);
        insert testAttContent;
        
        List<Attachment> attachmentList = new List<Attachment>();

        Attachment testAttachment1 = new Attachment(Name = 'TestAttachment_1.txt',
                                                     ParentId = testAttContent.Id,
                                                     Body =  Blob.valueOf('Test Body')
                                                     );

        Attachment testAttachment2 = new Attachment(Name = 'TestAttachment_2.txt',
                                                     ParentId = testAttContent.Id,
                                                     Body = Blob.valueOf('Test Body')
                                                     );

        attachmentList.add(testAttachment1);
        attachmentList.add(testAttachment2);
        insert attachmentList;    
        
        List<ContentVersion> documentList = new List<ContentVersion>();
        ContentVersion version = new ContentVersion(Title = 'txt',
                                                    PathOnClient = 'testContentVersion.txt',
                                                    VersionData = Blob.valueOf('test body for contentVersion'),
                                                    IsMajorVersion = true);
        documentList.add(version);
        insert documentList;

        ContentVersion insertedDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :documentList[0].Id];

        ContentDocumentLink documentLink = new ContentDocumentLink();
        documentLink.ContentDocumentId = insertedDocument.ContentDocumentId;
        documentLink.LinkedEntityId = eventList[0].Id;

        insert documentLink;
    }

    @isTest
    public static void deleteOneAttachmentPositiveTest(){

        Attachment testAttach = [SELECT Id FROM Attachment WHERE Name = 'TestAttachment_2.txt' LIMIT 1];

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/DeleteAttachmentAPI/';
        req.addParameter('attachmentId', String.valueOf(testAttach.Id));
        req.httpMethod = 'DELETE';

        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        test.startTest();
        DeleteAttachmentAPI.deleteAttachment();
        test.stopTest();
        
        DeleteAttachmentAPI.Response result = (DeleteAttachmentAPI.response)JSON.deserialize(resp.responseBody.toString(), DeleteAttachmentAPI.Response.class);
      
        System.assertEquals(true, result.status);
        System.assertEquals(testAttach.Id, result.deleted_Attachment_Id);
        System.assertEquals(null, result.deleted_AttachmentContent_Id);
    }

    @isTest
    public static void deleteAttachmentContentPositiveTest(){

        Attachment_Content__c testAttContent = [SELECT Id FROM Attachment_Content__c LIMIT 1];

        List<Attachment> testAttachList = [SELECT Id, Parent.Type FROM Attachment WHERE ParentId = :testAttContent.Id];

        
        delete testAttachList[1];

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/DeleteAttachmentAPI/';
        req.addParameter('attachmentId', String.valueOf(testAttachList[0].Id));
        req.httpMethod = 'DELETE';

        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        test.startTest();
        DeleteAttachmentAPI.deleteAttachment();
        test.stopTest();

        DeleteAttachmentAPI.Response result = (DeleteAttachmentAPI.response)JSON.deserialize(resp.responseBody.toString(), DeleteAttachmentAPI.Response.class);
      
        System.assertEquals(true, result.status);
        System.assertEquals(testAttachList[0].Id, result.deleted_Attachment_Id);
        System.assertEquals(testAttContent.Id, result.deleted_AttachmentContent_Id);
    }

    @isTest
    public static void deleteAttachmentNoLadoaLadoEventPositiveTest(){

        List<Account> accList = [SELECT Id FROM Account WHERE Name =  'Test Account'];

        List<CRM_Calendario_de_Eventos__c> eventList2 = TestDataFactory.createEventos(1, accList,'Día de Campo');
                
        List<Attachment> attachmentList = new List<Attachment>();

        Attachment testAttachment3 = new Attachment(Name = 'TestAttachment_3.txt',
                                                     ParentId = eventList2[0].Id,
                                                     Body =  Blob.valueOf('Test Body')
                                                     );

        attachmentList.add(testAttachment3);
        insert attachmentList;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/DeleteAttachmentAPI/';
        req.addParameter('attachmentId', String.valueOf(attachmentList[0].Id));
        req.httpMethod = 'DELETE';

        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        test.startTest();
        DeleteAttachmentAPI.deleteAttachment();
        test.stopTest();
        
        DeleteAttachmentAPI.Response result = (DeleteAttachmentAPI.response)JSON.deserialize(resp.responseBody.toString(), DeleteAttachmentAPI.Response.class);
      
        System.assertEquals(true, result.status);
        System.assertEquals(attachmentList[0].Id, result.deleted_Attachment_Id);
        System.assertEquals(null, result.deleted_AttachmentContent_Id);
    }

    @isTest
    public static void deleteContentVersionPositiveTest(){

        ContentDocument document = [SELECT Id, (SELECT Id FROM ContentVersions) FROM ContentDocument LIMIT 1];

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/DeleteAttachmentAPI/';
        req.addParameter('attachmentId', String.valueOf(document.ContentVersions[0].Id));
        req.httpMethod = 'DELETE';

        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        test.startTest();
        DeleteAttachmentAPI.deleteAttachment();
        test.stopTest();

        DeleteAttachmentAPI.Response result = (DeleteAttachmentAPI.response)JSON.deserialize(resp.responseBody.toString(), DeleteAttachmentAPI.Response.class);
      
        System.assertEquals(true, result.status);
        System.assertEquals(document.Id, result.deleted_ContentDocument_Id);
        System.assertEquals(document.ContentVersions[0].Id, result.deleted_ContentVersion_Id);
    }
}
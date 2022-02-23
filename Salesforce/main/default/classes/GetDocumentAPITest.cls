/**
* @name GetDocumentAPITest
* @author Jhonny Peroza
* updated 23-11-2021
*/
@isTest
public class GetDocumentAPITest {

    @TestSetup
    static void makeData(){

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Variedad__c> varietyList = TestDataFactory.createVariety(1);
        List<Categoria__c> categoriesList = TestDataFactory.createCategory(1);
        List<Variedad__c> varietiesList = TestDataFactory.createVariety(1);
        List<Product2> productList = TestDataFactory.createProduct(1, categoriesList, varietiesList);
        List<CRM_Calendario_de_Eventos__c> calendarioEventosList = TestDataFactory.createEventos(1, accountsList, 'Treinamento Tecnico');
        TestDataFactory.createOpportunities(accountsList, 1);
        TestDataFactory.createContentVersion(1);
        TestDataFactory.createAttachmentContent(1, calendarioEventosList);

    }

    @isTest
    public static void getDocumentInContentDocumentLink() {

        GetDocumentAPI.response result;

        List<Opportunity> opportunitiesList = [SELECT Id FROM Opportunity LIMIT 1];
        List<ContentVersion> documentsList = [SELECT Id, ContentDocumentId FROM ContentVersion LIMIT 1];

        ContentDocumentLink contentDocumentLinkInsert = new ContentDocumentLink();
        contentDocumentLinkInsert.LinkedEntityId = opportunitiesList[0].Id;
        contentDocumentLinkInsert.ContentDocumentId = documentsList[0].ContentDocumentId;
        contentDocumentLinkInsert.ShareType = 'V';
        contentDocumentLinkInsert.Visibility = 'InternalUsers';
        insert contentDocumentLinkInsert;
                                                                                                     
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/GetDocumentAPI/'; 
        req.addParameter('Id', opportunitiesList[0].Id); 
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        GetDocumentAPI.getDocument();
        test.stopTest();

        result = (GetDocumentAPI.response)JSON.deserialize(resp.responseBody.toString(), GetDocumentAPI.response.class);

        System.assertEquals(true, result.status);
        System.assertEquals(result.message, Label.GetDocumentAPI_Success_Message);

    }

    @isTest
    public static void getDocumentInAttachment() {

        GetDocumentAPI.Response result;

        List<Attachment_Content__c> attachmentContentList = [SELECT Id, CRM_Calendario_de_Eventos__c FROM Attachment_Content__c LIMIT 1];
        List<CRM_Calendario_de_eventos__c> crmEventosList = [SELECT Id FROM CRM_Calendario_de_Eventos__c LIMIT 1];

        Blob bodyBlob = Blob.valueOf('Test Data');
        
        Attachment_Content__c contentInsert = new Attachment_Content__c();
        contentInsert.CRM_Calendario_de_Eventos__c = crmEventosList[0].Id;
        contentInsert.Show_File__c = true;
        insert contentInsert;
            
        Attachment attachmentInsert = new Attachment();
        attachmentInsert.ParentId = attachmentContentList[0].CRM_Calendario_de_Eventos__c;
        attachmentInsert.Name = 'CONTENT VERSION.txt';
        attachmentInsert.Body = bodyBlob;
        insert attachmentInsert;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/GetDocumentAPI/';  
        req.addParameter('Id', crmEventosList[0].Id); 
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        GetDocumentAPI.getDocument();
        test.stopTest();

        result = (GetDocumentAPI.response)JSON.deserialize(resp.responseBody.toString(), GetDocumentAPI.response.class);

        System.assertEquals(true, result.status);
        System.assertEquals(result.message, Label.GetDocumentAPI_Success_Message);

    }

    @isTest
    public static void documentNotFound() {

        GetDocumentAPI.response result;

        List<Opportunity> opportunitiesList = [SELECT Id FROM Opportunity LIMIT 1];

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/GetDocumentAPI/';  
        req.addParameter('Id', opportunitiesList[0].Id); 
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        GetDocumentAPI.getDocument();
        test.stopTest();

        result = (GetDocumentAPI.response)JSON.deserialize(resp.responseBody.toString(), GetDocumentAPI.response.class);

        System.assertEquals(false, result.status);
        System.assertEquals(result.message, Label.GetDocumentAPI_Default_Error_Message);

    }

    @isTest
    public static void getDocumentInAttachmentContent() {

        GetDocumentAPI.Response result;
        Blob bodyBlob = Blob.valueOf('Test Data');
        
        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);              

        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);              

        List<CRM_Calendario_de_Eventos__c> calendarioEventosList = TestDataFactory.createEventos(1, accountsList, 'Treinamento Tecnico');

        Attachment_Content__c atachmentContent = new Attachment_Content__c();
        atachmentContent.CRM_Calendario_de_Eventos__c = calendarioEventosList[0].Id;
        atachmentContent.Show_File__c = true;
        insert atachmentContent;
            
        Attachment attachmentInsert = new Attachment();
        attachmentInsert.ParentId = atachmentContent.Id;
        attachmentInsert.Name = 'CONTENT VERSION.txt';
        attachmentInsert.Body = bodyBlob;
        insert attachmentInsert;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/GetDocumentAPI/';  
        req.addParameter('Id', calendarioEventosList[0].Id); 
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        GetDocumentAPI.getDocument();
        test.stopTest();

        result = (GetDocumentAPI.response)JSON.deserialize(resp.responseBody.toString(), GetDocumentAPI.response.class);

        System.assertEquals(true, result.status);
        System.assertEquals(result.message, Label.GetDocumentAPI_Success_Message);

    }

}
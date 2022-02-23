@isTest
public class SaveDocumentAPITest {

    public static final String TESTACCTNAME = 'Test Account';
    public static final String TESTSAFRA = '20/21';
    public static final String TESTEVENTO = 'Emplacamento';
    public static final String TESTEVENTOLXL = 'Lado a Lado';
    public static final String TESTNAME = 'Test Text File.txt';
    public static final String TESTBODY = 'Test Content Document for Test File';
    
    

    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #13083 
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     **/ 
    @TestSetup
    static void makeData(){
        test.startTest();

        // Insert Estado__c records
        List<Estado__c> estadoList = new List<Estado__c>();
        estadoList.add( new Estado__c(Name = 'Estado 1 Test') );
        estadoList.add( new Estado__c(Name = 'Estado 2 Test') );
        insert estadoList;


        // Insert Cidade__c records
        List<Cidade__c> cidadeList = new List<Cidade__c>();
        cidadeList.add( new Cidade__c(Name = 'Cidade 1 Test', Estado__c = estadoList[0].Id) );
        cidadeList.add( new Cidade__c(Name = 'Cidade 2 Test', Estado__c = estadoList[1].Id) );
        insert cidadeList;

        // Insert Account
        List<Account> accountList = new List<Account>();
        accountList.add( new Account(Name = TESTACCTNAME) );

        insert accountList;

        // Insert CRM_Calendario_de_Eventos__c records
        List<CRM_Calendario_de_Eventos__c> eventList = new List<CRM_Calendario_de_Eventos__c>();
        eventList.add( new CRM_Calendario_de_Eventos__c(Name = 'Event 1 Test - Emplacamento', Municipio__c = cidadeList[0].Id, Cuenta__c = accountList[0].Id, Evento__c = TESTEVENTO, Safra__c = TESTSAFRA) );
        eventList.add( new CRM_Calendario_de_Eventos__c(Name = 'Event 2 Test - Lado a Lado', Municipio__c = cidadeList[1].Id, Cuenta__c = accountList[0].Id, Evento__c = TESTEVENTOLXL, Safra__c = TESTSAFRA) );
        insert eventList;

        // Insert Configuracion_BMX__c
        Configuracion_BMX__c configBMX = new Configuracion_BMX__c();
        configBMX.Name = 'Facturacion';
        configBMX.PM_Safra_Actual_Eventos__c = TESTSAFRA;
        insert configBMX;

        test.stopTest();    
    }        

    /**
     *  METHOD:         saveDocumentTestPositive 
     *  DESCRIPTION:    Test class for SaveDocumentAPI.saveDocument. Created for US #13083 
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     *  TEST CASE:      call method with valid data and parentId from a non-LxL event ==> success, inserts document
     **/ 
    @isTest
    public static void saveDocumentTestPositive() {

        CRM_Calendario_de_Eventos__c event = [SELECT Id FROM CRM_Calendario_de_Eventos__c WHERE Evento__c = :TESTEVENTO LIMIT 1];

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/SaveDocumentAPI/'; 
        req.addParameter('parentId', event.Id);
        req.addParameter('name', TESTNAME);
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(TESTBODY));

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SaveDocumentAPI.saveDocument();
        test.stopTest();

        SaveDocumentAPI.Response result = (SaveDocumentAPI.Response)JSON.deserialize(  resp.responseBody.toString(), 
                                                                                                                        SaveDocumentAPI.Response.class);

        ContentVersion createdDoc = [SELECT Id, Title, VersionData, IsLatest, ContentDocumentId FROM ContentVersion WHERE Id = :result.documentId AND IsLatest = true ];
        String contentData = createdDoc.VersionData.toString();

        List<ContentDocumentLink> documentLinks = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :createdDoc.ContentDocumentId AND LinkedEntityId = :event.Id];

        System.assert(result.status);
        System.assertEquals(Label.SaveDocumentAPI_Success_Message, result.message);
        System.assert(contentData.contains(TESTBODY));
        System.assert(!documentLinks.isEmpty());

    }


    @isTest
    public static void SaveLadoALadoEventTestPositive() {

        CRM_Calendario_de_Eventos__c eventoLadoALado = [SELECT Id FROM CRM_Calendario_de_Eventos__c WHERE Evento__c = :TESTEVENTOLXL LIMIT 1];

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/SaveDocumentAPI/'; 
        req.addParameter('parentId', eventoLadoALado.Id);
        req.addParameter('attachmentContentType', 'Termo de autorização');
        req.addParameter('name', TESTNAME);
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(TESTBODY));

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SaveDocumentAPI.saveDocument();
        test.stopTest();

        SaveDocumentAPI.Response result = (SaveDocumentAPI.Response)JSON.deserialize(  resp.responseBody.toString(),SaveDocumentAPI.Response.class);

        System.assert(result.status);
        System.assertEquals(Label.SaveDocumentAPI_Success_Message, result.message);

    }


    @isTest
    public static void SaveLadoALadoEventTestNegative() {

        CRM_Calendario_de_Eventos__c eventoLadoALado = [SELECT Id FROM CRM_Calendario_de_Eventos__c WHERE Evento__c = :TESTEVENTOLXL LIMIT 1];

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/SaveDocumentAPI/'; 
        req.addParameter('parentId', eventoLadoALado.Id);
        req.addParameter('name', TESTNAME);
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(TESTBODY));

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SaveDocumentAPI.saveDocument();
        test.stopTest();

        SaveDocumentAPI.Response result = (SaveDocumentAPI.Response)JSON.deserialize(  resp.responseBody.toString(),SaveDocumentAPI.Response.class);

        System.assert(!result.status);
        System.assertEquals(result.message.contains(Label.SaveDocumentAPI_Attachment_Content_Type_Error_Message), true);

    }

}
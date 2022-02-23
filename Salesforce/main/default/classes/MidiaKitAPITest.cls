@isTest
public class MidiaKitAPITest {
	
    @TestSetup
    static void makeData(){
        
        Account testAccount = new Account(Name = 'TestAccount');
        insert testAccount;
        
        Account testAccountNoItems = new Account(Name = 'TestAccountNoItems');
        insert testAccountNoItems;
        

        List<Midia_Kit__c> testMidiaKitsList = new List<Midia_Kit__c>();
        
        testMidiaKitsList.add( new Midia_Kit__c(Name = 'Midia Kit 1 Test', 
                                                Active__c = true, 
                                                Cuenta__c = testAccount.Id, 
                                                Marca__c = 'NEOG', 
                                                Category__c = 'Arte de Resultado de Produtividade', 
                                                URL__c = 'https://www.salesforce.com'));
        
        testMidiaKitsList.add( new Midia_Kit__c(Name = 'Midia Kit 2 Test', 
                                                Active__c = true, 
                                                Cuenta__c = testAccount.Id, 
                                                Marca__c = 'NEOG', 
                                                Category__c = 'Big Bag', 
                                                URL__c = 'https://trailhead.salesforce.com'));
        
        testMidiaKitsList.add( new Midia_Kit__c(Name = 'Midia Kit 3 Test', 
                                                Active__c = true, 
                                                Cuenta__c = testAccount.Id, 
                                                Marca__c = 'NEOG', 
                                                Category__c = 'Logos', 
                                                URL__c = 'https://trailhead.salesforce.com'));
        
        
        insert testMidiaKitsList;
    }
    
    @isTest
    public static void getMidiaKitsListTestPositive() {
        
        String accountId = [SELECT Id FROM Account WHERE Name = 'TestAccount' LIMIT 1].Id;
        String testMarca = 'NEOG';
        
        MidiaKitAPI.MidiaKitAPIResponse result;
        
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/MidiaKitAPI/';  
        req.addParameter('accountId', accountId);
        req.addParameter('marca', testMarca);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        MidiaKitAPI.listarMidiaKits();
        test.stopTest();

        result = (MidiaKitAPI.MidiaKitAPIResponse)JSON.deserialize(resp.responseBody.toString(), MidiaKitAPI.MidiaKitAPIResponse.class);
        
        System.assert(result.status);
        System.assertEquals(Label.MidiaKitAPI_Success_Message, result.message);
        System.assertEquals(3, result.midiaKits.size());
    }
    
    @isTest
    public static void getMidiaKitsListNoItemsTest() {
        
        String accountNoItemsId = [SELECT Id FROM Account WHERE Name = 'testAccountNoItems' LIMIT 1].Id;
        String testMarca = 'NEOG';
        
        MidiaKitAPI.MidiaKitAPIResponse result;
        
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/MidiaKitAPI/';  
        req.addParameter('accountId', accountNoItemsId);
        req.addParameter('marca', testMarca);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        MidiaKitAPI.listarMidiaKits();
        test.stopTest();

        result = (MidiaKitAPI.MidiaKitAPIResponse)JSON.deserialize(resp.responseBody.toString(), MidiaKitAPI.MidiaKitAPIResponse.class);
        
        System.assertEquals(false, result.status);
        System.assertEquals(Label.MidiaKitAPI_No_Items_Error_Message, result.message);
    }
    
    @isTest
    public static void getMidiaKitsListNoParametersTest() {
        
        String accountId = [SELECT Id FROM Account WHERE Name = 'TestAccount' LIMIT 1].Id;
        String testMarca = '';
        
        MidiaKitAPI.MidiaKitAPIResponse result;
        
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/MidiaKitAPI/';  
        req.addParameter('accountId', accountId);
        req.addParameter('marca', testMarca);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        MidiaKitAPI.listarMidiaKits();
        test.stopTest();

        result = (MidiaKitAPI.MidiaKitAPIResponse)JSON.deserialize(resp.responseBody.toString(), MidiaKitAPI.MidiaKitAPIResponse.class);
        
        System.assertEquals(false, result.status);
        System.assertEquals(Label.MidiaKitAPI_Validation_Error_Message, result.message);
    }
}
@isTest
public with sharing class votosRealizadosAPITest {
    
    final static String TESTMARCA = 'BRMX';
    final static String TESTSAFRA = '21/22';
    final static String TESTACCTNAME = 'Test Account';
    
    @TestSetup
    static void makeData(){
        
        test.startTest();

        Variedad__c variedad = new Variedad__c(Name = 'Variedad 2 Test', Ativa__c = true);
        
        insert variedad;
		
        Categoria__c categoria = new Categoria__c(Name = 'BASICA');
        insert categoria;

        Product2 product = new Product2(Name = 'Product 1 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedad.Id);
        insert product;
        
        Account account = new Account(Name = TESTACCTNAME);
        insert account;
        
        Votacion__c voto = new Votacion__c(Valor__c = 2, Producto__c = product.Id,
                                           Cuenta__c = account.Id, Safra__c = TESTSAFRA,
                                           Region_Comercial__c = 'SUL', Vuelta__c = 2);
        
        insert voto;
            
        test.stopTest();    
    }        

    @isTest
    public static void getMisVotosTest() {

        String accountId = [SELECT Id FROM Account WHERE Name = :TESTACCTNAME LIMIT 1].Id;
        votosRealizadosAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsA2API/';  
        req.addParameter('accountId', accountId);
        req.addParameter('vuelta', '2');
        req.addParameter('safra', TESTSAFRA);
        req.addParameter('regionCuenta', 'SUL');
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        votosRealizadosAPI.getMisVotos();
        test.stopTest();

        result = (votosRealizadosAPI.Response)JSON.deserialize(resp.responseBody.toString(), votosRealizadosAPI.Response.class);
        
		System.assertEquals(true, result.status);
            

    }
    
     @isTest
    public static void getMisVotosErrorTest() {

        String accountId = [SELECT Id FROM Account WHERE Name = :TESTACCTNAME LIMIT 1].Id;
        votosRealizadosAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsA2API/';  
        req.addParameter('accountId', accountId);
        req.addParameter('vuelta', '2');
        req.addParameter('safra', TESTSAFRA);
        req.addParameter('regionCuenta', 'ERROR');
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        votosRealizadosAPI.getMisVotos();
        test.stopTest();

        result = (votosRealizadosAPI.Response)JSON.deserialize(resp.responseBody.toString(), votosRealizadosAPI.Response.class);
        
		System.assertEquals(false, result.status);
            

    }
}
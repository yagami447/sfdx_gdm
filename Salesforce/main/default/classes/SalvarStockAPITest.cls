/**
* @name SalvarStockAPITest
* @author Jhonny Peroza
* updated 13-10-2021
*/
@isTest
public class SalvarStockAPITest {

    final static String TESTMARCA = 'BRMX';
    final static String TESTSAFRA = '20/21';
    final static String TESTCULTURA = 'Soja';
    final static String TESTACCTNAME = 'Test Account';
    final static String TESTCANTSEMAPROBADA = '3000.00';
    final static String TESTCATEGORIA = 'BASICA';
    final static String PRICEBOOKNAME = 'Lista de Básica BMX SUL';
    final static String STOCKRECTYPE = 'Stock Multiplicadores';

    
    @TestSetup
    static void makeData(){
        test.startTest();

        // Insert Categoria__c records
        List<Categoria__c> categoriaList = new List<Categoria__c>();
        categoriaList.add( new Categoria__c(Name = TESTCATEGORIA) );
        insert categoriaList;

        // Insert Variedad__c records
        List<Variedad__c> variedadList = new List<Variedad__c>();
        variedadList.add( new Variedad__c(Name = 'Variedad 1 Test', Ativa__c = true) );
        variedadList.add( new Variedad__c(Name = 'Variedad 2 Test', Ativa__c = true) );
        insert variedadList;

        // Insert Product2 records
        List<Product2> productList = new List<Product2>();
        productList.add( new Product2(Name = 'Product 1 Test', IsActive = true, Categ__c = categoriaList[0].Id, Family = 'Semilla', Variedade__c = variedadList[0].Id, CANTIDAD_SUB_UNIDAD__c = '40') );
        productList.add( new Product2(Name = 'Product 2 Test', IsActive = true, Categ__c = categoriaList[0].Id, Family = 'Semilla', Variedade__c = variedadList[1].Id, CANTIDAD_SUB_UNIDAD__c = '40') );
        insert productList;

        // Insert Standard Pricebook prices
        Id stdPriceBookId = Test.getStandardPricebookId();
        List<PricebookEntry> stdPrices = new List<PricebookEntry>();
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[0].Id, UnitPrice = 10) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[1].Id, UnitPrice = 20) );
        insert stdPrices;

        // Insert Pricebook
        Pricebook2 pbRecord = new Pricebook2(Name = PRICEBOOKNAME, IsActive = true);
        insert pbRecord;

        // Insert Pricebook Entries with Product2.Categ__c.Name = 'BASICA' && Product2.Family = 'Semilla'
        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[0].Id, UnitPrice = 10, IsActive = true) );
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[1].Id, UnitPrice = 20, IsActive = true) );
        insert pbEntries;

        // Insert Estado
        Estado__c estado = new Estado__c(Name = 'AC', Estado_de_Origem__c = false,  Mostrar_en_portal__c =  true );
        insert estado;

        // Insert Account
        List<Account> accountList = new List<Account>();
        accountList.add( new Account(Name = TESTACCTNAME) );

        insert accountList;

        // Insert SiteUser__c
        SiteUser__c siteUser = new SiteUser__c( Email__c = 'test@cloudgaia.com', Password__c = 'test-pass-cg-01', Habilitado_BRMX__c = true );
        insert siteUser;

        // Insert SiteUserAccount__c
        SiteUserAccount__c siteUserAccount = new SiteUserAccount__c( Name = 'Test Site User Account', Account__c = accountList[0].Id, SiteUser__c = siteUser.Id, Active__c = true );
        insert siteUserAccount;

        // Insert SiteUserSession__c
        SiteUserSession__c siteUserSession = new SiteUserSession__c( Marca__c = TESTMARCA, Safra__c = TESTSAFRA );
        insert siteUserSession;

        test.stopTest();    
    }


    @isTest
    public static void saveStock() {

        SalvarStockAPI.response result;

		SalvarStockAPI.Request requestBody = createTestRequest(true);

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarStockAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarStockAPI.salvarStock();
        test.stopTest();
        
        result = (SalvarStockAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarStockAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(Label.SalvarStockAPI_Success_Message, result.message);

    }

    @isTest
    public static void couldNotSaveStock() {

        SalvarStockAPI.response result;

		SalvarStockAPI.Request requestBody = createTestRequest(false);

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarStockAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarStockAPI.salvarStock();
        test.stopTest();
        
        result = (SalvarStockAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarStockAPI.response.class);
      	
        System.assertEquals(false, result.status);

    }

    @isTest 
    public static void testSalvarStockPositiveMultipleItems() {

		SalvarStockAPI.Request requestBody = createTestRequest(true);

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarStockAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarStockAPI.salvarStock();
        test.stopTest();
        
        SalvarStockAPI.response result = (SalvarStockAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarStockAPI.response.class);
      	
        System.assertEquals(true, result.status);

        List<OpportunityLineItem> insertedStockItems = [SELECT Id, Semente_aprovada__c FROM OpportunityLineItem WHERE OpportunityId = :result.id];
        for(OpportunityLineItem item : insertedStockItems) {
            System.assertEquals(TESTCANTSEMAPROBADA, String.valueOf(item.Semente_aprovada__c));
        }

    }

    private static SalvarStockAPI.Request createTestRequest(Boolean validItems) {

        SalvarStockAPI.Request requestBody = new SalvarStockAPI.Request();

        Account testAccount = [SELECT Id FROM Account WHERE Name = :TESTACCTNAME LIMIT 1];
        SiteUser__c siteUser = [SELECT Id FROM SiteUser__c LIMIT 1];

        requestBody.accId = testAccount.Id;
        requestBody.safra = TESTSAFRA;
        requestBody.marca = TESTMARCA;
        requestBody.mes = 'Outubro';
        requestBody.userId = siteUser.Id;
        requestBody.aprobacion = 'true';

        if(validItems) {
            List<aAppendix.myOppItem> items = new List<aAppendix.myOppItem>();      

            Estado__c estado = [SELECT Id FROM Estado__c LIMIT 1];
            List<Product2> testProducts =   [SELECT Id, Variedade__c, Variedade__r.Name, Categ__c, Name 
                                            FROM Product2 
                                            WHERE Family = 'Semilla' 
                                                AND Categ__r.Name = :TESTCATEGORIA
                                                AND Semilla_Tratada__c = false 
                                                AND CANTIDAD_SUB_UNIDAD__c = '40' 
                                                AND isActive = true];

            for (Product2 product : testProducts) {
                aAppendix.myOppItem item = new aAppendix.myOppItem();

                item.amount = 1.00;
                item.categoria = product.Categ__c;
                item.sem_comer = '10';
                item.variedad = product.Variedade__c;
                item.estado_comer_id = estado.Id;
                if(testProducts.indexOf(product) == 0) {
                    item.sem_aprobada = TESTCANTSEMAPROBADA;
                }

                items.add(item);
            }

            requestBody.items = items;

        } 

        return requestBody;

    }

}
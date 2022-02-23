@isTest
public class ProductsVotacionAPITest {

    final static String TESTMARCA = 'DSEM';
    final static String TESTSAFRA = '20/21';
    final static String TESTACCTNAME = 'Test Account';
    final static String EMPTYACCTNAME = 'Empty Account';

    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #13225 
     *  AUTHOR:         irina.benitez@cloudgaia.com (4-nov-21)
     * 
     *  UPDATE:         pablo.fraquia@cloudgaia.com (12-jan-22)
     *  DESCRIPTION:    Configuracion_BMX__c and Votacion_balotage__c added for show products when vuelta == 2. Updated for US #19251
     *                  parameter marca removed
     **/ 

    @TestSetup
    static void makeData(){

        test.startTest();

        // Insert Configuracion_BMX__c
        Configuracion_BMX__c testConfiguracionBMX = new Configuracion_BMX__c(Name = 'TestFacturación',
                                                                             CRM_Safra_Actual__c = TESTSAFRA,
                                                                             Votacion_nro_de_vuelta__c = 1,
                                                                             Votaci_n_fecha_hasta__c = System.today(),
                                                                             PV_Safra_Actual__c = TESTSAFRA
                                                                             );

        insert testConfiguracionBMX;
        
        // Insert Categoria__c
        Categoria__c categoria = new Categoria__c(Name = 'BASICA', Mostrar_en_portal__c = true);
        insert categoria;

        // Insert Variedad__c records
        List<Variedad__c> variedadList = new List<Variedad__c>();
        variedadList.add( new Variedad__c(Name = 'Variedad 1 Test', Ativa__c = true) );
        variedadList.add( new Variedad__c(Name = 'Variedad 2 Test', Ativa__c = true) );
        insert variedadList;

        // Insert Product2 records
        List<Product2> productList = new List<Product2>();
        productList.add( new Product2(Name = 'Product 1 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[0].Id) );
        productList.add( new Product2(Name = 'Product 2 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[1].Id) );
        insert productList;

        // Insert Standard Pricebook prices
        Id stdPriceBookId = Test.getStandardPricebookId();
        List<PricebookEntry> stdPrices = new List<PricebookEntry>();
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[0].Id, UnitPrice = 10) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[1].Id, UnitPrice = 20) );
        insert stdPrices;

        // Insert Pricebook
        Pricebook2 pbRecord = new Pricebook2(Name = 'Pricebook Test', IsActive = true);
        insert pbRecord;

        // Insert Pricebook Entries with Product2.Categ__c.Name = 'BASICA' && Product2.Family = 'Royalty x Basica'
        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[0].Id, UnitPrice = 10, IsActive = true) );
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[1].Id, UnitPrice = 20, IsActive = true) );
        insert pbEntries;

        // Insert Account
        Regiao__c testRegion = new Regiao__c(Name = 'REGION 1', Region_Comercial__c = 'REGION 1');
        insert testRegion;

        List<Account> accList = new List<Account>();
        accList.Add(new Account(Name = TESTACCTNAME, Region__c = testRegion.Id));
        accList.Add(new Account(Name = EMPTYACCTNAME, Region__c = testRegion.Id));
        insert accList;

        // Insert Contrato__c
        Id contractRecordType =  Schema.SObjectType.Contrato__c.getRecordTypeInfosByDeveloperName().get('Termo_Aditivo').getRecordTypeId();
        Contrato__c contratoMultip = new Contrato__c(   Multiplicador__c = accList[0].Id,
                                                        Sociedad__c = TESTMARCA, 
                                                        Safra__c = TESTSAFRA, 
                                                        RecordTypeId = contractRecordType, 
                                                        Chegou_na_Brasmax__c = true, 
                                                        Estado__c = 'Chegou' );
        insert contratoMultip;

        // Insert Item_del_Contrato__c
        Id contractItemRecordType =  Schema.SObjectType.Item_del_Contrato__c.getRecordTypeInfosByName().get('Volumen').getRecordTypeId();
        List<Item_del_Contrato__c> contractItemList = new List<Item_del_Contrato__c>();
        contractItemList.add( new Item_del_Contrato__c( RecordTypeId = contractItemRecordType, Contrato_de_Multiplicacion__c = contratoMultip.Id, Cultivar__c = productList[0].Id) );
        contractItemList.add( new Item_del_Contrato__c( RecordTypeId = contractItemRecordType, Contrato_de_Multiplicacion__c = contratoMultip.Id, Cultivar__c = productList[1].Id) );
        insert contractItemList;

        test.stopTest();    
    }        

    /**
     *  METHOD:         getProductsVotacionTestPositive 
     *  DESCRIPTION:    Test class for ProductsVotacionAPI.getProductsVotacion. Created for US #13225 
     *  AUTHOR:         irina.benitez@cloudgaia.com (4-nov-21)
     *  TEST CASE:      call method with valid accountId, marca and safra ==> success, returns products and maps
     * 
     *  UPDATE:         pablo.fraquia@cloudgaia.com (12-jan-22)
     *  DESCRIPTION:    parameter marca removed
     **/ 

    @isTest
    public static void getProductsVotacionTestPositive() {

        String accountId = [SELECT Id FROM Account WHERE Name = :TESTACCTNAME LIMIT 1].Id;

        ProductsVotacionAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsVotacionAPI/';  
        req.addParameter('accountId', accountId);
        req.addParameter('safra', TESTSAFRA);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsVotacionAPI.getProductsVotacion();
        test.stopTest();

        result = (ProductsVotacionAPI.Response)JSON.deserialize(resp.responseBody.toString(), ProductsVotacionAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assert(result.status);
        System.assertEquals(Label.ProductsVotacionAPI_Success_Message, result.message);
        System.assertEquals(2, result.productsVotacion.size());

    }

    /**
     *  METHOD:         getProductsVotacionTestNegative
     *  DESCRIPTION:    Test class for ProductsVotacionAPI.getProductsVotacion. Created for US #13225 
     *  AUTHOR:         irina.benitez@cloudgaia.com (4-nov-21)
     *  TEST CASE:      call method with invalid accountId  ==> returns error message with failed data
     * 
     *  UPDATE:         pablo.fraquia@cloudgaia.com (12-jan-22)
     *  DESCRIPTION:    parameter marca removed
     **/ 

    @isTest
    public static void getProductsVotacionTestNegative() {

        String emptyAccId = [SELECT Id FROM Account WHERE Name = :EMPTYACCTNAME LIMIT 1].Id;

        ProductsVotacionAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsVotacionAPI/';  
        req.addParameter('accountId', emptyAccId);
        req.addParameter('safra', TESTSAFRA);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsVotacionAPI.getProductsVotacion();
        test.stopTest();

        result = (ProductsVotacionAPI.Response)JSON.deserialize(resp.responseBody.toString(), ProductsVotacionAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assertEquals(false, result.status);
        System.assertEquals(404, resp.statusCode);
    }

    /**
     *  METHOD:         getProductsVotacionBalotageTestPositive
     *  DESCRIPTION:    Test class for ProductsVotacionAPI.getProductsVotacion. Created for US #19251
     *  AUTHOR:         pablo.fraquia@cloudgaia.com (12-jan-22)
     *  TEST CASE:      call method to show prodcuts available for second round (Balotage)  ==> returns success message, products and maps
     **/ 

    @isTest
    public static void getProductsVotacionBalotageTestPositive() {

        String accountId = [SELECT Id FROM Account WHERE Name = :TESTACCTNAME LIMIT 1].Id;

        List<Product2> testProductList = [SELECT Id FROM Product2 WHERE Name IN ('Product 1 Test','Product 2 Test') LIMIT 2];

        List<Votacion_balotage__c> productsForBalotage = new List<Votacion_balotage__c>();

        productsForBalotage.add(new Votacion_balotage__c(Name = 'Product 1', 
                                                         Producto__c = testProductList[0].Id, 
                                                         Variedad__c = 'Product 1', 
                                                         Variable__c = 'precio', 
                                                         valor1__c = 20, 
                                                         valor2__c = 10, 
                                                         Vuelta__c = '2',
                                                         Region_Comercial__c = 'SUL'));

        productsForBalotage.add(new Votacion_balotage__c(Name = 'Product 2', 
                                                         Producto__c = testProductList[1].Id, 
                                                         Variedad__c = 'Product 2', 
                                                         Variable__c = 'precio', 
                                                         valor1__c = 35, 
                                                         valor2__c = 15, 
                                                         Vuelta__c = '2',
                                                         Region_Comercial__c = 'SUL'));                                                 

        insert productsForBalotage;

        Configuracion_BMX__c testConfig = [SELECT Id, CRM_Safra_Actual__c, Votacion_nro_de_vuelta__c, Votaci_n_fecha_hasta__c, PV_Safra_Actual__c 
                                                     FROM Configuracion_BMX__c
                                                     WHERE Name = 'TestFacturación'
                                                     LIMIT 1];

        testConfig.Votacion_nro_de_vuelta__c = 2;
        testConfig.Votaci_n_fecha_hasta__c = System.today();
        
        update testConfig;

        ProductsVotacionAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsVotacionAPI/';  
        req.addParameter('accountId', accountId);
        req.addParameter('safra', TESTSAFRA);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsVotacionAPI.getProductsVotacion();
        test.stopTest();

        result = (ProductsVotacionAPI.Response)JSON.deserialize(resp.responseBody.toString(), ProductsVotacionAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assert(result.status);
        System.assertEquals(Label.ProductsVotacionAPI_Success_Message, result.message);
        System.assertEquals(2, result.productsVotacionBalotage.size());
    }
}
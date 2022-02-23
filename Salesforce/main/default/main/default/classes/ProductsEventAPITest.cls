@isTest
public class ProductsEventAPITest {

    final static String TESTEVENTOLXL = 'Lado a Lado';
    final static String TESTEVENTOAREACOMERCIAL = 'Area Comercial';
    final static String TESTEVENTOPALESTRA = 'Palestra';
    final static String TESTOBTENTOR = 'Don Mario';
    final static String TESTOBTENTORBRMX = 'Brasmax';

    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #13082 
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     **/ 
    @TestSetup
    static void makeData(){
        test.startTest();
        // Insert Categoria__c
        Categoria__c categoria = new Categoria__c(Name = 'BASICA');
        insert categoria;

        // Insert Variedad__c records
        List<Variedad__c> variedadList = new List<Variedad__c>();
        variedadList.add( new Variedad__c(Name = 'Variedad 1 Test', Ativa__c = true) );
        variedadList.add( new Variedad__c(Name = 'Variedad 2 Test', Ativa__c = true) );
        variedadList.add( new Variedad__c(Name = 'Variedad 3 Test', Ativa__c = true) );
        variedadList.add( new Variedad__c(Name = 'Variedad 4 Test', Ativa__c = true) );
        insert variedadList;

        // Insert Product2 records
        List<Product2> productList = new List<Product2>();
        productList.add( new Product2(Name = 'Product 1 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[0].Id, Portal__c = true, Obtentor__c = TESTOBTENTOR) );
        productList.add( new Product2(Name = 'Product 2 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[1].Id, Portal__c = true, Obtentor__c = TESTOBTENTOR) );
        productList.add( new Product2(Name = 'Product 1 Brasmax', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[2].Id, Portal__c = true, Obtentor__c = TESTOBTENTORBRMX) );
        productList.add( new Product2(Name = 'Product 2 Brasmax', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[3].Id, Portal__c = true, Obtentor__c = TESTOBTENTORBRMX) );
        insert productList;

        // Insert Standard Pricebook prices
        Id stdPriceBookId = Test.getStandardPricebookId();
        List<PricebookEntry> stdPrices = new List<PricebookEntry>();
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[0].Id, UnitPrice = 10) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[1].Id, UnitPrice = 20) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[2].Id, UnitPrice = 15) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[3].Id, UnitPrice = 25) );
        insert stdPrices;

        // Insert Pricebook
        Pricebook2 pbRecord = new Pricebook2(Name = 'Pricebook Test', IsActive = true);
        insert pbRecord;

        // Insert Pricebook Entries with Product2.Categ__c.Name = 'BASICA' && Product2.Family = 'Royalty x Basica'
        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[0].Id, UnitPrice = 10, IsActive = true) );
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[1].Id, UnitPrice = 20, IsActive = true) );
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[2].Id, UnitPrice = 15, IsActive = true) );
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[3].Id, UnitPrice = 25, IsActive = true) );
        insert pbEntries;


        test.stopTest();    
    }        

    /**
     *  METHOD:         getProductsEventTestPositive 
     *  DESCRIPTION:    Test class for ProductsEventAPI.getProductsEvent. Created for US #13082 
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     *  TEST CASE:      call method with valid event and available products ==> success, returns products
     **/ 
    @isTest
    public static void getProductsEventTestPositive() {

        ProductsEventAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsEventAPI/';  
        req.addParameter('event', TESTEVENTOLXL);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsEventAPI.getProductsEvent();
        test.stopTest();

        result = (ProductsEventAPI.Response)JSON.deserialize(resp.responseBody.toString(), ProductsEventAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assert(result.status);
        System.assertEquals(Label.ProductsEventAPI_Success_Message, result.message);
        System.assertEquals(4, result.productsEvent.size());

    }

        /**
     *  METHOD:         getProductsEventTestNegative
     *  DESCRIPTION:    Test class for ProductsEventAPI.getProductsEvent. Created for US #13082 
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     *  TEST CASE:      call method with valid event but no products  ==> returns generic error message
     **/ 
    @isTest
    public static void getProductsEventTestNegative() {

        ProductsEventAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsEventAPI/';  
        req.addParameter('event', TESTEVENTOPALESTRA);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsEventAPI.getProductsEvent();
        test.stopTest();

        result = (ProductsEventAPI.Response)JSON.deserialize(resp.responseBody.toString(), ProductsEventAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assertEquals(false, result.status);
        System.assertEquals(Label.ProductsEventAPI_Default_Error_Message, result.message);
        System.assertEquals(404, resp.statusCode);
    }


    /**
     *  METHOD:         productJSONConverterTestPositive 
     *  DESCRIPTION:    Test class for ProductsEventAPI.productJSONConverter. Created for US #13082 
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     *  TEST CASE:      call method with product list ==> success, returns products in JSON format
     **/ 
    @isTest
    public static void productJSONConverterTestPositive() {

        List<Product2> productList = [SELECT Id, Name, Obtentor__c FROM Product2 LIMIT 1];

        test.startTest();
        List<aSiteEventosController.item> wrapperProductList = ProductsEventAPI.productJSONConverter(productList);
        test.stopTest();

        System.assertEquals(productList.size(), wrapperProductList.size());
        System.assertEquals(productList[0].Id, wrapperProductList[0].id_producto);
        System.assertEquals(productList[0].Name, wrapperProductList[0].desc_producto);
        System.assertEquals(productList[0].Obtentor__c, wrapperProductList[0].obtentor);
    }

    /**
     *  METHOD:         productJSONConverterTestNegative 
     *  DESCRIPTION:    Test class for ProductsEventAPI.productJSONConverter. Created for US #13082 
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     *  TEST CASE:      call method with empty product list ==> returns empty list in JSON format
     **/ 
    @isTest
    public static void productJSONConverterTestNegative() {

        List<Product2> productList = new List<Product2>();

        test.startTest();
        List<aSiteEventosController.item> wrapperProductList = ProductsEventAPI.productJSONConverter(productList);
        test.stopTest();

        System.assert(wrapperProductList.isEmpty());

    }

    /**
     *  METHOD:         getProductsEventTestPositiveAreaComercial 
     *  DESCRIPTION:    Test class for ProductsEventAPI.getProductsEvent. Created for US #20642 
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     *  TEST CASE:      call method with Area Comercial event and available products ==> success, returns only Brasmax products
     **/ 
    @isTest
    public static void getProductsEventTestPositiveAreaComercial() {

        ProductsEventAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsEventAPI/';  
        req.addParameter('event', TESTEVENTOAREACOMERCIAL);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsEventAPI.getProductsEvent();
        test.stopTest();

        result = (ProductsEventAPI.Response)JSON.deserialize(resp.responseBody.toString(), ProductsEventAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assert(result.status);
        System.assertEquals(Label.ProductsEventAPI_Success_Message, result.message);
        System.assertEquals(2, result.productsEvent.size());
        
    }
}
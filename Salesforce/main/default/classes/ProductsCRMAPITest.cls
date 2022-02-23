@isTest
public class ProductsCRMAPITest {

    final static String TESTOBTENTOR1 = 'Don Mario';
    final static String TESTOBTENTOR2 = 'Bayer';

    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #14317 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
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
        insert variedadList;

        // Insert Product2 records
        List<Product2> productList = new List<Product2>();
        productList.add( new Product2(Name = 'Product 1 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[0].Id, Portal__c = true, Obtentor__c = TESTOBTENTOR1) );
        productList.add( new Product2(Name = 'Product 2 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[1].Id, Portal__c = true, Obtentor__c = TESTOBTENTOR2) );
        insert productList;

        test.stopTest();    
    }        

    /**
     *  METHOD:         getProductsCRMTestPositive 
     *  DESCRIPTION:    Test class for ProductsCRMAPI.getProductsCRM. Created for US #14317 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
     *  TEST CASE:      call method with available products ==> success, returns products
     **/ 
    @isTest
    public static void getProductsCRMTestPositive() {

        ProductsCRMAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsCRMAPI/';  
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsCRMAPI.getProductsCRM();
        test.stopTest();

        result = (ProductsCRMAPI.Response)JSON.deserialize(resp.responseBody.toString(), ProductsCRMAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assert(result.status);
        System.assertEquals(Label.ProductsCRMAPI_Success_Message, result.message);
        System.assertEquals(2, result.productsCRM.size());

    }

    /**
     *  METHOD:         getProductsCRMTestNegative
     *  DESCRIPTION:    Test class for ProductsCRMAPI.getProductsCRM. Created for US #14317 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
     *  TEST CASE:      call method with valid event but no products  ==> returns generic error message
     **/ 
    @isTest
    public static void getProductsCRMTestNegative() {

        List<Product2> products = [SELECT Id, Portal__c FROM Product2];
        for(Product2 product : products){
            product.Portal__c = false;
        }
        update products;

        ProductsCRMAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsCRMAPI/';  
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsCRMAPI.getProductsCRM();
        test.stopTest();

        result = (ProductsCRMAPI.Response)JSON.deserialize(resp.responseBody.toString(), ProductsCRMAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assertEquals(false, result.status);
        System.assertEquals(Label.ProductsCRMAPI_Default_Error_Message, result.message);
        System.assertEquals(404, resp.statusCode);
    }


    /**
     *  METHOD:         productJSONConverterTestPositive 
     *  DESCRIPTION:    Test class for ProductsCRMAPI.productJSONConverter. Created for US #14317 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
     *  TEST CASE:      call method with product list ==> success, returns products in JSON format
     **/ 
    @isTest
    public static void productJSONConverterTestPositive() {

        List<Product2> productList = [SELECT Id, Name, Obtentor__c FROM Product2 LIMIT 1];

        test.startTest();
        Map<String,List<ProductsCRMAPI.Producto>> resultMap = ProductsCRMAPI.productJSONConverter(productList);
        test.stopTest();

        System.assertEquals(productList.size(), resultMap.size());
        System.assert(resultMap.containsKey(productList[0].Obtentor__c));
        System.assertEquals(productList[0].Id, resultMap.get(productList[0].Obtentor__c)[0].id_producto);
        System.assertEquals(productList[0].Name, resultMap.get(productList[0].Obtentor__c)[0].desc_producto);
    }

    /**
     *  METHOD:         productJSONConverterTestNegative 
     *  DESCRIPTION:    Test class for ProductsCRMAPI.productJSONConverter. Created for US #14317 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
     *  TEST CASE:      call method with empty product list ==> returns empty list in JSON format
     **/ 
    @isTest
    public static void productJSONConverterTestNegative() {

        List<Product2> productList = new List<Product2>();

        test.startTest();
        Map<String,List<ProductsCRMAPI.Producto>> resultMap = ProductsCRMAPI.productJSONConverter(productList);
        test.stopTest();

        System.assert(resultMap.isEmpty());

    }

}
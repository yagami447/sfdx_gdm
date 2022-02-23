/**
* @name StockProductsAPITest
* @author Jhonny Peroza
* updated 07-10-2021
*/
@isTest
public class StockProductsAPITest {

    @isTest
    public static void getStockProducts() {

        StockProductsAPI.response result;

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Variedad__c> varietyList = TestDataFactory.createVariety(1);
        List<Opportunity> opportunitiesList = TestDataFactory.createOpportunities(accountsList, 1);
        List<Categoria__c> categoryList = TestDataFactory.createCategory(1);
        List<Product2> productList = TestDataFactory.createProduct(1, categoryList, varietyList);
        List<PricebookEntry> priceBookList = TestDataFactory.createPriceBookEntry(1, productList);
        List<OpportunityLineItem> opportunityLineItemList = TestDataFactory.createOpportunityLineItems(opportunitiesList, productList);
        
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/StockProductsAPI/';
        req.addParameter('accountId', opportunitiesList[0].AccountId);
        req.addParameter('safra', opportunitiesList[0].Safra__c);
        req.addParameter('marca', opportunitiesList[0].Marca__c);  
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        StockProductsAPI.getStockProducts();
        test.stopTest();

        result = (StockProductsAPI.response)JSON.deserialize(resp.responseBody.toString(), StockProductsAPI.response.class);

        System.assertEquals(true, result.status);
        System.assertEquals(result.message, 'Produtos encontrados em estoque');

    }

    @isTest
    public static void stockProductsNotFound() {

        StockProductsAPI.response result;

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Variedad__c> varietyList = TestDataFactory.createVariety(1);
        List<Opportunity> opportunitiesList = TestDataFactory.createOpportunities(accountsList, 1);

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/StockProductsAPI/';
        req.addParameter('accountId', opportunitiesList[0].AccountId);
        req.addParameter('safra', '21/22');
        req.addParameter('marca', 'DSEM');  
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        StockProductsAPI.getStockProducts();
        test.stopTest();

        result = (StockProductsAPI.response)JSON.deserialize(resp.responseBody.toString(), StockProductsAPI.response.class);

        System.assertEquals(false, result.status);
        System.assertEquals(result.message, 'Não há produtos em estoque');

    }

}
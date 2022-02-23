/**
* @name EstimativaProductAPITest
* @author Jhonny Peroza
* updated 04-11-2021
*/
@isTest
public class EstimativaProductAPITest {

    @isTest
    public static void estimativaProducts() {

        EstimativaProductAPI.response result;

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Variedad__c> varietyList = TestDataFactory.createVariety(1);
        List<User> userList = TestDataFactory.createUser(1);
        List<SiteUser__c> siteList = TestDataFactory.createSiteUser(1);
        List<SiteUserSession__c> sessionList = TestDataFactory.createSessionUser(1, siteList);

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EstimativaProductAPI/';
        req.addParameter('marca', 'BRMX');
        req.addParameter('accountId', accountsList[0].Id);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        EstimativaProductAPI.getEstimativaProducts();
        test.stopTest();

        result = (EstimativaProductAPI.response)JSON.deserialize(resp.responseBody.toString(), EstimativaProductAPI.response.class);

        System.assertEquals(true, result.status);
        System.assertEquals(result.message, 'Existem produtos de estimativa');

    }

    @isTest
    public static void estimativaProductsNotFound() {

        EstimativaProductAPI.response result;

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Variedad__c> varietyList = TestDataFactory.createVariety(4);
        List<User> userList = TestDataFactory.createUser(1);
        List<SiteUser__c> siteList = TestDataFactory.createSiteUser(1);
        List<SiteUserSession__c> sessionList = TestDataFactory.createSessionUser(1, siteList);

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EstimativaProductAPI/';
        req.addParameter('marca', 'NEOG');
        req.addParameter('accountId', accountsList[0].Id);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        EstimativaProductAPI.getEstimativaProducts();
        test.stopTest();

        result = (EstimativaProductAPI.response)JSON.deserialize(resp.responseBody.toString(), EstimativaProductAPI.response.class);

        System.assertEquals(false, result.status);
        System.assertEquals(result.message, 'Nenhum produto encontrado');

    }

}
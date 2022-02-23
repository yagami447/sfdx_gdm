/**
* @name AprovarRecusarVBPedidoAPITest
* @author Jhonny Peroza
* updated 09-11-2021
*/
@isTest
public class AprovarRecusarVBPedidoAPITest {

    @isTest
    public static void cambiarEstadoVBPedidoApprove() {

        AprovarRecusarVBPedidoAPI.response result;

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactory.createBusiness(accountsList);
        List<Campaign> campaignList = TestDataFactory.createCampaign(accountsList, 1);
        List<Opportunity> opportunitiesList = TestDataFactory.createPedidos(campaignList, accountsList, 1);

        AprovarRecusarVBPedidoAPI.Request requestBody = new AprovarRecusarVBPedidoAPI.Request();
                      
        requestBody.pedidoId = opportunitiesList[0].Id;
        requestBody.action = 'Approve';
        requestBody.coment = 'Test';
		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/AprovarRecusarVBPedidoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        AprovarRecusarVBPedidoAPI.cambiarEstadoVBPedido();
        test.stopTest();
        
        result = (AprovarRecusarVBPedidoAPI.response)JSON.deserialize(resp.responseBody.toString(), AprovarRecusarVBPedidoAPI.response.class);
        
        System.assertEquals(true, result.status);
        System.assertEquals(Label.AprovarRecusarVBPedidoAPI_Success_Message, result.message);
    
    }

    @isTest
    public static void cambiarEstadoVBPedidoReject() {

        AprovarRecusarVBPedidoAPI.response result;

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactory.createBusiness(accountsList);
        List<Campaign> campaignList = TestDataFactory.createCampaign(accountsList, 1);
        List<Opportunity> opportunitiesList = TestDataFactory.createPedidos(campaignList, accountsList, 1);

        AprovarRecusarVBPedidoAPI.Request requestBody = new AprovarRecusarVBPedidoAPI.Request();
                      
        requestBody.pedidoId = opportunitiesList[0].Id;
        requestBody.action = 'Reject';
        requestBody.coment = 'Test';
		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/ApprovarRecusarVBPedidoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        AprovarRecusarVBPedidoAPI.cambiarEstadoVBPedido();
        test.stopTest();
        
        result = (AprovarRecusarVBPedidoAPI.response)JSON.deserialize(resp.responseBody.toString(), AprovarRecusarVBPedidoAPI.response.class);
        
        System.assertEquals(true, result.status);
    
    }

    @isTest
    public static void cambiarEstadoVBPedidoDefault() {

        AprovarRecusarVBPedidoAPI.response result;

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactory.createBusiness(accountsList);
        List<Campaign> campaignList = TestDataFactory.createCampaign(accountsList, 1);
        List<Opportunity> opportunitiesList = TestDataFactory.createPedidos(campaignList, accountsList, 1);

        AprovarRecusarVBPedidoAPI.Request requestBody = new AprovarRecusarVBPedidoAPI.Request();
                      
        requestBody.pedidoId = opportunitiesList[0].Id;
        requestBody.action = 'ERROR';
        requestBody.coment = 'Test';
		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/AprovarRecusarVBPedidoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        AprovarRecusarVBPedidoAPI.cambiarEstadoVBPedido();
        test.stopTest();
        
        result = (AprovarRecusarVBPedidoAPI.response)JSON.deserialize(resp.responseBody.toString(), AprovarRecusarVBPedidoAPI.response.class);
        
        System.assertEquals(false, result.status);
    
    }

}
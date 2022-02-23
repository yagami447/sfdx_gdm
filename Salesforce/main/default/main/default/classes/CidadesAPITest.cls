@isTest
public class CidadesAPITest {

    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #13357 
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

        test.stopTest();    
    }        

    /**
     *  METHOD:         getCidadesTestPositive 
     *  DESCRIPTION:    Test class for CidadesAPI.getCidades. Created for US #13357 
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     *  TEST CASE:      call method with existing cidades ==> success, returns cidades
     **/ 
    @isTest
    public static void getCidadesTestPositive() {

        CidadesAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CidadesAPI/';  
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        CidadesAPI.getCidades();
        test.stopTest();

        result = (CidadesAPI.Response)JSON.deserialize(resp.responseBody.toString(), CidadesAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assert(result.status);
        System.assertEquals(Label.CidadesAPI_Success_Message, result.message);
        System.assertEquals(2, result.cidades.size());

    }

        /**
     *  METHOD:         getCidadesTestNegative
     *  DESCRIPTION:    Test class for CidadesAPI.getCidades. Created for US #13357 
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     *  TEST CASE:      call method with valid event but no products  ==> returns generic error message
     **/ 
    @isTest
    public static void getCidadesTestNegative() {

        List<Cidade__c> cidadeList = [SELECT Id FROM Cidade__c];
        delete cidadeList;

        CidadesAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CidadesAPI/';  
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        CidadesAPI.getCidades();
        test.stopTest();

        result = (CidadesAPI.Response)JSON.deserialize(resp.responseBody.toString(), CidadesAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assertEquals(false, result.status);
        System.assertEquals(Label.CidadesAPI_Default_Error_Message, result.message);
        System.assertEquals(404, resp.statusCode);
    }




}
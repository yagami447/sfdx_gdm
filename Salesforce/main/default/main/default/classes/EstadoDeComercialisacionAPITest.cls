@isTest
public with sharing class EstadoDeComercialisacionAPITest {

    @TestSetup
    static void makeData(){

        Account account = new Account();
        account.Name = 'Test Acc';
        insert account;

        Contrato__c contrato = new Contrato__c();
        contrato.Sociedad__c = 'BRMX';
        contrato.Safra__c = '19/20';
        contrato.Multiplicador__c = account.Id;
        contrato.Estado__c = 'Chegou';
        contrato.Estados_Comercializacao__c = 'AC';
        insert contrato;

        Configuracion_BMX__c configBMX = new Configuracion_BMX__c();
        configBMX.PM_Safra_Actual_A1__c = '19/20';

        insert configBMX;

    }    
   
    @isTest
    public static void testGetEstadoDeComercialisacion() {

        Account account = [SELECT Id FROM Account WHERE Name = 'Test Acc'];

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/TransportHistoryAPI'; 
        String postData = '';
        req.addParameter('marca', 'BRMX');
        req.addParameter('accountId', account.Id); 

        String JsonMsg=JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;

        Test.startTest();   
              
        EstadoDeComercialisacionAPI.getEstadoDeComercialisacion();

		Test.stopTest();
        
       
        EstadoDeComercialisacionAPITest.EstadoDeComercialisacion parsedResp = (EstadoDeComercialisacionAPITest.EstadoDeComercialisacion) JSON.deserialize( RestContext.response.responseBody.toString(), EstadoDeComercialisacionAPITest.EstadoDeComercialisacion.class);

        System.assertEquals('AC', parsedResp.estados[0]);
        System.assertEquals(200, RestContext.response.statusCode);
    }

    public class EstadoDeComercialisacion{
        
    private String message;
    private Boolean status;
    private List<String> estados;
    
    public EstadoDeComercialisacion (String message, Boolean status, List<String> estados) {

        this.message = message;
        this.status = status;
        this.estados = estados;
    }

    } 
}
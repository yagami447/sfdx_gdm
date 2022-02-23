@isTest
public class EstimativaAPITest {

    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #10309 
     *  AUTHOR:         irina.benitez@cloudgaia.com (06-sept-21)
     * 
     * UPDATED:         pablo.fraquia@cloudgaia.com (30-dic-21)
     **/ 
    @TestSetup
    static void makeData(){
        test.startTest();
        Configuracion_BMX__c configBMX = new Configuracion_BMX__c(Name = 'test config',
                                                                  Data_Inicial_Estimativa_Milho__c = '05/03',
                                                                  Data_Final_Estimativa_Milho__c = '03/09',
                                                                  Data_Inicial_Estimativa_Soja__c = '05/03',
                                                                  Data_Final_Estimativa_Soja__c = '03/09');
        insert configBMX;
        test.stopTest();    
    }        

    /**
     *  METHOD:         validateDateNewEstimativaTestPositive 
     *  DESCRIPTION:    Test class for EstimativaAPI.validateDateNewEstimativa. Created for US #10309 
     *  AUTHOR:         irina.benitez@cloudgaia.com (06-sept-21)
     *  TEST CASE:      call method with valid date (settings in setup method) ==> returns true
     **/ 
    @isTest
    public static void validateDateNewEstimativaTestPositive() {

        Date validDate = Date.newInstance( System.today().year(), 07, 12);

        // Jhonny Peroza: Agrego el campo: Cultura
        String cultura = 'Milho';

        test.startTest();
        Map<Boolean, String> mapResult = EstimativaAPI.validateDateNewEstimativa(cultura, validDate);
        List<Boolean> result = new List<Boolean>(mapResult.keySet());
        test.stopTest();

        System.assert(result[0]);
    }

    /**
     *  METHOD:         validateDateNewEstimativaTestNegative
     *  DESCRIPTION:    Test class for EstimativaAPI.validateDateNewEstimativa. Created for US #10309 
     *  AUTHOR:         irina.benitez@cloudgaia.com (06-sept-21)
     *  TEST CASE:      call method with invalid date (settings in setup method) ==> returns false
     **/ 
    @isTest
    public static void validateDateNewEstimativaTestNegative() {

        Date invalidDate = Date.newInstance( System.today().year(), 02, 04);
    
        // Jhonny Peroza: Agrego el campo: Cultura
        String cultura = 'Milho';

        test.startTest();
        Map<Boolean, String> mapResult = EstimativaAPI.validateDateNewEstimativa(cultura, invalidDate);
        List<Boolean> result = new List<Boolean>(mapResult.keySet());
        test.stopTest();

        System.assertEquals(false, result[0]);
    }

    /** Agregado por Jhonny Peroza 
     *  US-13218 VB Estimativa - Criar
     *  updated 04-11-2021
     **/

    @isTest 
    public static void validateEstimativaResponseAPINegative() {

        EstimativaAPI.response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EstimativaAPI/';
        req.addParameter('cultura', 'Soja');
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        EstimativaAPI.doGet();
        test.stopTest();

        result = (EstimativaAPI.response)JSON.deserialize(resp.responseBody.toString(), EstimativaAPI.response.class);

        System.assertEquals(false, result.status);
        System.assert(result.message.contains(EstimativaAPI.ERRORFUERADEFECHA));

    }
	   @isTest 
    public static void validateEstimativaResponseAPINegativSojaEmpty() {
		
        Configuracion_BMX__c config = [SELECT Id FROM Configuracion_BMX__c WHERE Name = 'test config'];
        delete config;
        Configuracion_BMX__c configBMX = new Configuracion_BMX__c(Name = 'test config', Data_Inicial_Estimativa_Milho__c = '05/03');
        insert configBMX;

        EstimativaAPI.response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EstimativaAPI/';
        req.addParameter('cultura', 'Milho');
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        EstimativaAPI.doGet();
        test.stopTest();

        result = (EstimativaAPI.response)JSON.deserialize(resp.responseBody.toString(), EstimativaAPI.response.class);

        System.assertEquals(false, result.status);
        System.assertEquals(result.message, EstimativaAPI.ERRORCAMPOSNULOSMILHO);

    }
    @isTest 
    public static void validateEstimativaResponseAPIPositive() {
	
        Configuracion_BMX__c config = [SELECT Id FROM Configuracion_BMX__c];
        delete config;
        Configuracion_BMX__c configBMX = new Configuracion_BMX__c(Name = 'test config',
                                                                  Data_Inicial_Estimativa_Milho__c = '01/01',
                                                                  Data_Final_Estimativa_Milho__c = '31/12',
                                                                  Data_Inicial_Estimativa_Soja__c = '01/01',
                                                                  Data_Final_Estimativa_Soja__c = '31/12');
        insert configBMX;
        
        EstimativaAPI.response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EstimativaAPI/';
        req.addParameter('cultura', 'Milho');
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        EstimativaAPI.doGet();
        test.stopTest();

        result = (EstimativaAPI.response)JSON.deserialize(resp.responseBody.toString(), EstimativaAPI.response.class);

        System.assertEquals(true, result.status);
        System.assertEquals(result.message, EstimativaAPI.SUCCESSMESSAGE);
    }
}
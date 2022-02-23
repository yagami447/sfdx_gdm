@isTest
public with sharing class CRMAPITest {

    public static final String TESTACCTNAME = 'Test Account Name';
    public static final String TESTMARCA = 'BRMX';
    public static final String TESTSAFRA = '21/22';

    @TestSetup
    static void makeData(){

        // Insert Configuacion
        Configuracion_BMX__c configBMX = new Configuracion_BMX__c();
        configBMX.Name = 'Test Configuracion';
        insert configBMX;

        // Insert Account
        List<Account> accountList = new List<Account>();
        accountList.add( new Account(Name = TESTACCTNAME) );
        insert accountList;

    }    
    
    /**
     *  METHOD:         getNewCRMIsValidTestPositive
     *  DESCRIPTION:    Test class for CRMAPI.getNewCRMIsValid. Created for US #14316 
     *  AUTHOR:         irina.benitez@cloudgaia.com (19-nov-21)
     *  TEST CASE:      call method with valid date settings ==> success, returns true
     **/ 
    @isTest
    public static void getNewCRMIsValidTestPositive() {

        Configuracion_BMX__c configuracion = [  SELECT  Data_Inicial_CRM__c, Data_Final_CRM__c
                                                FROM Configuracion_BMX__c 
                                                LIMIT 1];

        String dayInicial = String.valueOf(System.today().day() - 1);
        String dayFinal = String.valueOf(System.today().day() + 2);
        String mesInicial = (System.today().month()<10?'0'+String.valueOf(System.today().month()):String.valueOf(System.today().month()));
        String mesFinal = (System.today().month()<10?'0'+String.valueOf(System.today().month()):String.valueOf(System.today().month()));

        if (Integer.valueOf(dayInicial) == 0) {

            dayInicial= '01';
            mesInicial = (Integer.valueOf(mesInicial) -1) == 0 ? '12' : '0' +String.valueOf(Integer.valueOf(mesInicial) - 1);
        }

        if (Integer.valueOf(dayFinal) > 28) {

            dayFinal= '03';
            mesFinal = (Integer.valueOf(mesFinal) +1) > 12 ? '01' : '0' +String.valueOf(Integer.valueOf(mesFinal) + 1);
        }
        
        dayInicial = dayInicial.length() < 2 ? '0' + dayInicial : dayInicial;
        dayFinal = dayFinal.length() < 2 ? '0' + dayFinal : dayFinal;

        configuracion.Data_Inicial_CRM__c = dayInicial + '/' +mesInicial;
        configuracion.Data_Final_CRM__c = dayFinal + '/' +mesFinal;
        
        update configuracion;

        Account acct = [SELECT Id FROM Account LIMIT 1];

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CRMAPI/';  
        req.addParameter('cuenta', acct.Id);
        req.addParameter('marca', TESTMARCA);
        req.addParameter('safra', TESTSAFRA);
        //req.addParameter('campania', 'campaniaId');
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        CRMAPI.getNewCRMIsValid();
        Test.stopTest();

        CRMAPI.Response result = (CRMAPI.Response)JSON.deserialize(resp.responseBody.toString(), CRMAPI.Response.class);
        System.debug('result: ' + result);
        System.assert(result.status);
        System.assertEquals(Label.CRMAPI_Success_Message, result.message);
    }

    /**
     *  METHOD:         getNewCRMIsValidTestNegative1
     *  DESCRIPTION:    Test class for CRMAPI.getNewCRMIsValid. Created for US #14316 
     *  AUTHOR:         irina.benitez@cloudgaia.com (19-nov-21)
     *  TEST CASE:      call method with invalid date settings ==> returns false status and error message
     **/ 
    @isTest
    public static void getNewCRMIsValidTestNegative1() {

        Configuracion_BMX__c configuracion = [  SELECT  Data_Inicial_CRM__c, Data_Final_CRM__c
                                                FROM Configuracion_BMX__c 
                                                LIMIT 1];

        String dayInicial = String.valueOf(System.today().day() + 1);
        String dayFinal = String.valueOf(System.today().day() + 2);
        String mesInicial = (System.today().month()<10?'0'+String.valueOf(System.today().month()):String.valueOf(System.today().month()));
        String mesFinal = (System.today().month()<10?'0'+String.valueOf(System.today().month()):String.valueOf(System.today().month()));
                                        
        if (Integer.valueOf(dayInicial) > 28) {
                                        
            dayInicial= '01';
            mesInicial = (Integer.valueOf(mesInicial) +1) > 12 ? '01' : '0' +String.valueOf(Integer.valueOf(mesInicial) + 1);
        }
                                        
        if (Integer.valueOf(dayFinal) > 28) {
                                        
            dayFinal= '03';
            mesFinal = (Integer.valueOf(mesFinal) +1) > 12 ? '01' : '0' +String.valueOf(Integer.valueOf(mesFinal) + 1);
        }                               
        
        dayInicial = dayInicial.length() < 2 ? '0' + dayInicial : dayInicial;
        dayFinal = dayFinal.length() < 2 ? '0' + dayFinal : dayFinal;

        configuracion.Data_Inicial_CRM__c =  dayInicial + '/' +mesInicial;
        configuracion.Data_Final_CRM__c =  dayInicial + '/' +mesFinal;

        System.debug('@@@ configuracion.Data_Inicial_CRM__c:   ' +configuracion.Data_Inicial_CRM__c);
        System.debug('@@@ configuracion.Data_Final_CRM__c:   ' +configuracion.Data_Final_CRM__c);
        
        update configuracion;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CRMAPI/';  
        req.addParameter('cuenta', 'invalidcuentaId');
        req.addParameter('marca', TESTMARCA);
        req.addParameter('safra', TESTSAFRA);
        //req.addParameter('campania', 'campaniaId');
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        CRMAPI.getNewCRMIsValid();
        Test.stopTest();

        CRMAPI.Response result = (CRMAPI.Response)JSON.deserialize(resp.responseBody.toString(), CRMAPI.Response.class);
        System.debug('result: ' + result);
        System.assertEquals(false, result.status);
        System.assertEquals(Label.CRMAPI_Default_Error_Message, result.message);

    }

        /**
     *  METHOD:         getNewCRMIsValidTestNegative2
     *  DESCRIPTION:    Test class for CRMAPI.getNewCRMIsValid. Created for US #14316 
     *  AUTHOR:         irina.benitez@cloudgaia.com (19-nov-21)
     *  TEST CASE:      call method with valid date settings and existing CRM ==> returns false status and error message
     **/ 
    @isTest
    public static void getNewCRMIsValidTestNegative2() {

        Configuracion_BMX__c configuracion = [  SELECT  Data_Inicial_CRM__c, Data_Final_CRM__c
                                                FROM Configuracion_BMX__c 
                                                LIMIT 1];

        String dayInicial = String.valueOf(System.today().day() + 1);
        String dayFinal = String.valueOf(System.today().day() + 2);
        String mesInicial = (System.today().month()<10?'0'+String.valueOf(System.today().month()):String.valueOf(System.today().month()));
        String mesFinal = (System.today().month()<10?'0'+String.valueOf(System.today().month()):String.valueOf(System.today().month()));
                                                                                
        if (Integer.valueOf(dayInicial) > 28) {
                                                                                
            dayInicial= '01';
            mesInicial = (Integer.valueOf(mesInicial) +1) > 12 ? '01' : '0' +String.valueOf(Integer.valueOf(mesInicial) + 1);
        }
                                                                                
        if (Integer.valueOf(dayFinal) > 28) {
                                                                                
            dayFinal= '03';
            mesFinal = (Integer.valueOf(mesFinal) +1) > 12 ? '01' : '0' +String.valueOf(Integer.valueOf(mesFinal) + 1);
        }
                                                                                                                                                                    
           
        dayInicial = dayInicial.length() < 2 ? '0' + dayInicial : dayInicial;
        dayFinal = dayFinal.length() < 2 ? '0' + dayFinal : dayFinal;

        configuracion.Data_Inicial_CRM__c = dayInicial  + '/' +mesInicial;
        configuracion.Data_Final_CRM__c = dayFinal + '/' +mesFinal;
                                        
        update configuracion;

        Account acct = [SELECT Id FROM Account LIMIT 1];

        Resumo_da_Conta__c existingCRM = new Resumo_da_Conta__c(Multiplicador__c = acct.Id, Safra__c = TESTSAFRA, Marca__c = TESTMARCA);
        insert existingCRM;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CRMAPI/';  
        req.addParameter('cuenta', acct.Id);
        req.addParameter('marca', TESTMARCA);
        req.addParameter('safra', TESTSAFRA);
        //req.addParameter('campania', 'campaniaId');
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        CRMAPI.getNewCRMIsValid();
        Test.stopTest();

        CRMAPI.Response result = (CRMAPI.Response)JSON.deserialize(resp.responseBody.toString(), CRMAPI.Response.class);
        System.debug('result: ' + result);
        System.assertEquals(false, result.status);
        System.assertEquals(Label.CRMAPI_CRM_Created_Error_Message, result.message);

    }

        /**
     *  METHOD:         getNewCRMIsValidTestNegative3
     *  DESCRIPTION:    Test class for CRMAPI.getNewCRMIsValid. Created for US #14316 
     *  AUTHOR:         irina.benitez@cloudgaia.com (19-nov-21)
     *  TEST CASE:      call method with bad configuration date settings ==> returns false status and error message
     **/ 
    @isTest
    public static void getNewCRMIsValidTestNegative3() {

        Account acct = [SELECT Id FROM Account LIMIT 1];

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CRMAPI/';  
        req.addParameter('cuenta', acct.Id);
        req.addParameter('marca', TESTMARCA);
        req.addParameter('safra', TESTSAFRA);
        //req.addParameter('campania', 'campaniaId');
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        CRMAPI.getNewCRMIsValid();
        Test.stopTest();

        CRMAPI.Response result = (CRMAPI.Response)JSON.deserialize(resp.responseBody.toString(), CRMAPI.Response.class);
        System.debug('result: ' + result);
        System.assertEquals(false, result.status);
        System.assertEquals(Label.CRMAPI_Bad_Setting_Error_Message, result.message);
    }
}
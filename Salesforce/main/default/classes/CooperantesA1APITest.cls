@isTest
public class CooperantesA1APITest {

    static final String MAINACCTNAME = 'Test Main Account';
    static final String COOPACCTNAME = 'Test Cooperante Account';
    static final String CNPJCPFVALUE = '00.000.000/0000-00';
    static final String RENASEMVALUE = 'ZZ-XXXX/YYYY';

    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #12714 
     *  AUTHOR:         irina.benitez@cloudgaia.com (13-sept-21)
     **/ 
    @TestSetup
    static void makeData(){
        test.startTest();

        // insert Accounts
        Account mainAccount = new Account(Name = MAINACCTNAME);
        Account cooperanteAccount = new Account(Name = COOPACCTNAME, CNPJ_CPF__c = CNPJCPFVALUE, Renasem__c = RENASEMVALUE);
        List<Account> accounts = new List<Account>();
        accounts.add(mainAccount);
        accounts.add(cooperanteAccount);

        insert accounts;

        // insert Cooperante
        Cooperante__c cooperante = new Cooperante__c(Name = 'Test Cooperante', Cuenta__c = mainAccount.Id, CuentaCoop__c= cooperanteAccount.Id);
        insert cooperante;
        
        test.stopTest();    
    }        

    /**
     *  METHOD:         getCooperantesAnexo1TestPositive 
     *  DESCRIPTION:    Test class for CooperanteA1API.getCooperantesAnexo1. Created for US #12714 
     *  AUTHOR:         irina.benitez@cloudgaia.com (13-sept-21)
     *  TEST CASE:      call method with valid account id (settings in setup method) ==> success
     **/ 
    @isTest
    public static void getCooperantesAnexo1TestPositive() {

        Account mainAccount = [SELECT Id, Name FROM Account WHERE Name = :MAINACCTNAME];
        CooperantesA1API.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CooperantesA1API/' + mainAccount.Id;  
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        CooperantesA1API.getCooperantesAnexo1();
        test.stopTest();

        result = (CooperantesA1API.Response)JSON.deserialize(resp.responseBody.toString(), CooperantesA1API.Response.class);
        System.debug('result: ' + result);
        
        System.assert(result.status);
        System.assertEquals(Label.CooperantesA1API_Success_Message, result.message);
        System.assertEquals(COOPACCTNAME, result.cooperantes[0].nombre);
        System.assertEquals(CNPJCPFVALUE, result.cooperantes[0].cnpjCnp);
        System.assertEquals(RENASEMVALUE, result.cooperantes[0].renasem);
    }

    /**
     *  METHOD:         getCooperantesAnexo1TestNegative
     *  DESCRIPTION:    Test class for CooperanteA1API.getCooperantesAnexo1. Created for US #12714 
     *  AUTHOR:         irina.benitez@cloudgaia.com (13-sept-21)
     *  TEST CASE:      call method with invalid account id (settings in setup method) ==> returns error message
     **/ 
    @isTest
    public static void getCooperantesAnexo1TestNegative() {

        String invalidAccountId = 'invalidId';
        CooperantesA1API.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/CooperantesA1API/' + invalidAccountId;  
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        CooperantesA1API.getCooperantesAnexo1();
        test.stopTest();

        result = (CooperantesA1API.Response)JSON.deserialize(resp.responseBody.toString(), CooperantesA1API.Response.class);
        System.debug('result: ' + result);
        
        System.assertEquals(false, result.status);
        System.assertEquals(Label.CooperantesA1API_Default_Error_Message, result.message);
    }
    
}
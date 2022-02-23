@isTest
public with sharing class OpportunityAPITest {

    public static final String TESTMARCA = 'BRMX';
    public static final String TESTSAFRA = '19/20';
    public static final String TESTCULTURA = 'Milho';

    @TestSetup
    static void makeData(){

        Account account = new Account(Name='test');

        insert account;

        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo III').getRecordTypeId();

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'test config';
        opportunity.Accountid = account.Id;
        opportunity.Cultura__C = 'Milho';
        opportunity.Marca__C = 'BRMX';
        opportunity.Safra__C = '19/20';
        opportunity.RecordTypeId = recordTypeId;
        opportunity.StageName = 'Aprobada';
        opportunity.CloseDate = system.Today();

        insert opportunity;  

        Configuracion_BMX__c configBMX = new Configuracion_BMX__c();
        configBMX.Name = '20/21';
        configBMX.PM_Safra_Actual_A1__c = '19/20';
        configBMX.PM_Safra_Actual_A2__c = '19/20';
        configBMX.PM_Safra_Actual_A3__c = '19/20';
        configBMX.PM_Safra_Actual_A4__c = '19/20';
        configBMX.PM_Safra_Actual_A5__c = '19/20';
        configBMX.Data_Inicial_Estimativa_Milho__c = '10/11';
        configBMX.Data_Final_Estimativa_Milho__c = '19/11';
        configBMX.PM_Safra_Actual_Reembalagem__c = '19/20';
        configBMX.PM_Safra_Actual_Descarte__c = '19/20';
        configBMX.PM_Safra_Actual_Estoque__c = '19/20';
        configBMX.PM_Estoque_Dia_Desde__c = 13;
        configBMX.PM_Estoque_Dia_Hasta__c = 10;
        insert configBMX;

    }    

    @isTest
    static void getOpportunityisValidAnexoITest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/OpportunityApi'; 
        String postData = '';
        req.addParameter('accountId', '0015500001HRc3aAAD');
        req.addParameter('cultura', 'Milho');
        req.addParameter('marca', 'BRMX');  
        req.addParameter('anexo', 'Anexo I');   

        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;

        Test.startTest();
        
        OpportunityAPI.getOpportunityisValid();

        Test.stopTest();

        Map<String, String> parsedResp = (Map<String, String>) JSON.deserialize( RestContext.response.responseBody.toString(), Map<String,String>.class);
        System.assertEquals('false',  parsedResp.get('status'));
    }

    @isTest
    static void getOpportunityisValidAnexoIIInvernoTest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/OpportunityApi'; 
        String postData = '';
        req.addParameter('accountId', '0015500001HRc3aAAD');
        req.addParameter('cultura', 'Milho');
        req.addParameter('marca', 'BRMX');  
        req.addParameter('anexo', 'Anexo II Inverno');      

        String JsonMsg=JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        Test.startTest();
        OpportunityAPI.getOpportunityisValid();
        Test.stopTest();

        Map<String, String> parsedResp = (Map<String, String>) JSON.deserialize( RestContext.response.responseBody.toString(), Map<String,String>.class);
        System.assertEquals('false',  parsedResp.get('status'));
    }

    @isTest
    static void getOpportunityisValidAnexoIIVeraoTest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/OpportunityApi'; 
        String postData = '';
        req.addParameter('accountId', '0015500001HRc3aAAD');
        req.addParameter('cultura', 'Milho');
        req.addParameter('marca', 'BRMX');  
        req.addParameter('anexo', 'Anexo II Verão');      

        String JsonMsg=JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        Test.startTest();
        OpportunityAPI.getOpportunityisValid();
        Test.stopTest();

        Map<String, String> parsedResp = (Map<String, String>) JSON.deserialize( RestContext.response.responseBody.toString(), Map<String,String>.class);
        System.assertEquals('false',  parsedResp.get('status'));
    }

    @isTest
    static void getOpportunityisValidAnexoIIITest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/OpportunityApi'; 
        String postData = '';
        req.addParameter('accountId', '0015500001HRc3aAAD');
        req.addParameter('cultura', 'Milho');
        req.addParameter('marca', 'BRMX');  
        req.addParameter('anexo', 'Anexo III');      

        String JsonMsg=JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        Test.startTest();
        OpportunityAPI.getOpportunityisValid();
        Test.stopTest();

        Map<String, String> parsedResp = (Map<String, String>) JSON.deserialize( RestContext.response.responseBody.toString(), Map<String,String>.class);
        System.assertEquals('false',  parsedResp.get('status'));
    }

    @isTest
    static void getOpportunityisValidAnexoIVTest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/OpportunityApi'; 
        String postData = '';
        req.addParameter('accountId', '0015500001HRc3aAAD');
        req.addParameter('cultura', 'Milho');
        req.addParameter('marca', 'BRMX');  
        req.addParameter('anexo', 'Anexo IV');      

        String JsonMsg=JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        Test.startTest();
        OpportunityAPI.getOpportunityisValid();
        Test.stopTest();

        Map<String, String> parsedResp = (Map<String, String>) JSON.deserialize( RestContext.response.responseBody.toString(), Map<String,String>.class);
        System.assertEquals('false',  parsedResp.get('status'));
    }

    @isTest
    static void getOpportunityisValidAnexoVTest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/OpportunityApi'; 
        String postData = '';
        req.addParameter('accountId', '0015500001HRc3aAAD');
        req.addParameter('cultura', 'Milho');
        req.addParameter('marca', 'BRMX');  
        req.addParameter('anexo', 'Anexo V');      

        String JsonMsg=JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        Test.startTest();
        OpportunityAPI.getOpportunityisValid();
        Test.stopTest();

 Map<String, String> parsedResp = (Map<String, String>) JSON.deserialize( RestContext.response.responseBody.toString(), Map<String,String>.class);
        System.assertEquals('false',  parsedResp.get('status'));
    }

    @isTest
    static void getOpportunityisValidAnexoVITest() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/OpportunityApi'; 
        String postData = '';
        req.addParameter('accountId', '0015500001HRc3aAAD');
        req.addParameter('cultura', 'Milho');
        req.addParameter('marca', 'BRMX');  
        req.addParameter('anexo', 'Anexo VI');      

        String JsonMsg=JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        Test.startTest();
        OpportunityAPI.getOpportunityisValid();
        Test.stopTest();

        Map<String, String> parsedResp = (Map<String, String>) JSON.deserialize( RestContext.response.responseBody.toString(), Map<String,String>.class);
        System.assertEquals('false',  parsedResp.get('status'));
    }


    
    /**
     *  METHOD:         validateNewA2RebaixamentoTestPositive
     *  DESCRIPTION:    Test class for OpportunityAPI.validateNewA2Rebaixamento. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method with valid request data ==> success, returns true
     **/ 
    @isTest
    public static void validateNewA2RebaixamentoTestPositive() {

        Account account = [SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Name = 'test' LIMIT 1];

        delete (account.Opportunities);

        Id recordTypeIdA2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo II').getRecordTypeId();

        Opportunity approvedA2 = new Opportunity(  Name = 'Test Anexo II', 
                                                    AccountId = account.Id,
                                                    Cultura__c = TESTCULTURA,
                                                    Marca__c = TESTMARCA,
                                                    Safra__c = TESTSAFRA,
                                                    RecordTypeId = recordTypeIdA2,
                                                    StageName =  'Aprobada',
                                                    CloseDate = System.today() );

        insert approvedA2;
        
        Test.startTest();
        String result = OpportunityAPI.validateNewA2Rebaixamento(account.Id, TESTMARCA, TESTCULTURA, TESTSAFRA);
        Test.stopTest();

        System.assertEquals(Label.OpportunityAPI_General_Generic_Success_Message, result);

    }

    /**
     *  METHOD:         validateNewA2RebaixamentoTestNegative1
     *  DESCRIPTION:    Test class for OpportunityAPI.validateNewA2Rebaixamento. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method without approved Anexo II ==> returns error message
     **/ 
    @isTest
    public static void validateNewA2RebaixamentoTestNegative1() {

        Account account = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        
        Test.startTest();
        String result = OpportunityAPI.validateNewA2Rebaixamento(account.Id, TESTMARCA, TESTCULTURA, TESTSAFRA);
        Test.stopTest();

        System.assertEquals(Label.OpportunityAPI_Anexo_II_Error_Message, result);
    }

    /**
     *  METHOD:         validateNewA2RebaixamentoTestNegative2
     *  DESCRIPTION:    Test class for OpportunityAPI.validateNewA2Rebaixamento. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method with existing Anexo III ==> returns error message
     **/ 
    @isTest
    public static void validateNewA2RebaixamentoTestNegative2() {
        Account account = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        Id recordTypeIdA2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo II').getRecordTypeId();
        Id recordTypeIdA3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo III').getRecordTypeId();

        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(    new Opportunity(Name = 'Test Anexo II', 
                                                AccountId = account.Id,
                                                Cultura__c = TESTCULTURA,
                                                Marca__c = TESTMARCA,
                                                Safra__c = TESTSAFRA,
                                                RecordTypeId = recordTypeIdA2,
                                                StageName =  'Aprobada',
                                                CloseDate = System.today() ));

        insert opportunityList;

        Test.startTest();
        String result = OpportunityAPI.validateNewA2Rebaixamento(account.Id, TESTMARCA, TESTCULTURA, TESTSAFRA);
        Test.stopTest();

        System.assertEquals(Label.OpportunityAPI_Existing_Anexo_I_Error_Message, result);
    }

    
    /**
     *  METHOD:         validateNewReembalajeTestPositive
     *  DESCRIPTION:    Test class for OpportunityAPI.validateNewReembalaje. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method with valid request data ==> success, returns true
     **/ 
    @isTest
    public static void validateNewReembalajeTestPositive() {
        Account account = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        Id recordTypeIdCVB = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CVB Autorizada').getRecordTypeId();

        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(    new Opportunity(Name = 'Test CVB Aprobado', 
                                                AccountId = account.Id,
                                                Cultura__c = TESTCULTURA,
                                                Marca__c = TESTMARCA,
                                                Safra__c = TESTSAFRA,
                                                RecordTypeId = recordTypeIdCVB,
                                                StageName =  'AU - Autorizada',
                                                CloseDate = System.today() ));

        insert opportunityList;

        Test.startTest();
        String result = OpportunityAPI.validateNewReembalaje(account.Id, TESTMARCA, TESTCULTURA, TESTSAFRA);
        Test.stopTest();

        System.assertEquals(Label.OpportunityAPI_General_Generic_Success_Message, result);
    }

    /**
     *  METHOD:         validateNewReembalajeTestNegative
     *  DESCRIPTION:    Test class for OpportunityAPI.validateNewReembalaje. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method without approved CVB ==> returns error message
     **/ 
    @isTest
    public static void validateNewReembalajeTestNegative() {
        Account account = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];

        Test.startTest();
        String result = OpportunityAPI.validateNewReembalaje(account.Id, TESTMARCA, TESTCULTURA, TESTSAFRA);
        Test.stopTest();

        System.assertEquals(Label.OpportunityAPI_CVB_Approved_Error_Message, result);
    }



    /**
     *  METHOD:         validateNewDescarteTestPositive
     *  DESCRIPTION:    Test class for OpportunityAPI.validateNewDescarte. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method with valid request data ==> success, returns true
     **/ 
    @isTest
    public static void validateNewDescarteTestPositive() {
        Account account = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        Id recordTypeIdA3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo III').getRecordTypeId();

        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(    new Opportunity(Name = 'Test Anexo III Aprobado', 
                                                AccountId = account.Id,
                                                Cultura__c = TESTCULTURA,
                                                Marca__c = TESTMARCA,
                                                Safra__c = TESTSAFRA,
                                                RecordTypeId = recordTypeIdA3,
                                                StageName =  'Aprobada',
                                                CloseDate = System.today() ));

        insert opportunityList;

        Test.startTest();
        String result = OpportunityAPI.validateNewDescarte(account.Id, TESTMARCA, TESTCULTURA, TESTSAFRA);
        Test.stopTest();

        System.assertEquals(Label.OpportunityAPI_General_Generic_Success_Message, result);
    }

    /**
     *  METHOD:         validateNewDescarteTestNegative1
     *  DESCRIPTION:    Test class for OpportunityAPI.validateNewDescarte. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method without approved Anexo III ==> returns error message
     **/ 
    @isTest
    public static void validateNewDescarteTestNegative1() {
        Account account = [SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Name = 'test' LIMIT 1];

        delete (account.Opportunities);

        Test.startTest();
        String result = OpportunityAPI.validateNewDescarte(account.Id, TESTMARCA, TESTCULTURA, TESTSAFRA);
        Test.stopTest();

        System.assertEquals(Label.OpportunityAPI_Anexo_III_Error_Message, result);
    }

    /**
     *  METHOD:         validateNewDescarteTestNegative2
     *  DESCRIPTION:    Test class for OpportunityAPI.validateNewDescarte. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method with existing Anexo IV ==> returns error message
     **/ 
    @isTest
    public static void validateNewDescarteTestNegative2() {
        Account account = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        Id recordTypeIdA3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo III').getRecordTypeId();
        Id recordTypeIdA4 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo IV').getRecordTypeId();

        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(    new Opportunity(Name = 'Test Anexo III Aprobado', 
                                                AccountId = account.Id,
                                                Cultura__c = TESTCULTURA,
                                                Marca__c = TESTMARCA,
                                                Safra__c = TESTSAFRA,
                                                RecordTypeId = recordTypeIdA3,
                                                StageName =  'Aprobada',
                                                CloseDate = System.today() ));

        opportunityList.add(    new Opportunity(Name = 'Test Anexo IV Aprobado', 
                                                AccountId = account.Id,
                                                Cultura__c = TESTCULTURA,
                                                Marca__c = TESTMARCA,
                                                Safra__c = TESTSAFRA,
                                                RecordTypeId = recordTypeIdA4,
                                                StageName =  'Aprobada',
                                                CloseDate = System.today() ));

        insert opportunityList;

        Test.startTest();
        String result = OpportunityAPI.validateNewDescarte(account.Id, TESTMARCA, TESTCULTURA, TESTSAFRA);
        Test.stopTest();

        System.assertEquals(Label.OpportunityAPI_Existing_Anexo_IV_Error_Message, result);
    }

    /**
     *  METHOD:         validateNewStockTestPositive
     *  DESCRIPTION:    Test class for OpportunityAPI.validateNewStock. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method with valid request data ==> success, returns true
     **/ 
    @isTest
    public static void validateNewStockTestPositive() {
        Account account = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        Id recordTypeIdA1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo I').getRecordTypeId();

        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(    new Opportunity(Name = 'Test Anexo I Aprobado', 
                                                AccountId = account.Id,
                                                Cultura__c = TESTCULTURA,
                                                Marca__c = TESTMARCA,
                                                Safra__c = TESTSAFRA,
                                                RecordTypeId = recordTypeIdA1,
                                                StageName =  'Aprobada',
                                                CloseDate = System.today() ));

        insert opportunityList;

        Test.startTest();
        String result = OpportunityAPI.validateNewStock(account.Id, TESTMARCA, TESTCULTURA, TESTSAFRA);
        Test.stopTest();

        System.assertEquals(Label.OpportunityAPI_General_Generic_Success_Message, result);
    }

    /**
     *  METHOD:         validateNewStockTestNegative
     *  DESCRIPTION:    Test class for OpportunityAPI.validateNewStock. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method without approved Anexo I ==> returns error message
     **/ 
    @isTest
    public static void validateNewStockTestNegative() {
        Account account = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];

        Test.startTest();
        String result = OpportunityAPI.validateNewStock(account.Id, TESTMARCA, TESTCULTURA, TESTSAFRA);
        Test.stopTest();

        System.assertEquals(Label.OpportunityAPI_Anexo_I_Error_Message, result);
    }

    /**
     *  METHOD:         validateDateNewStockTestPositive
     *  DESCRIPTION:    Test class for OpportunityAPI.validateDateNewStock. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method with valid date ==> success, returns true
     **/ 
    @isTest
    public static void validateDateNewStockTestPositive() {
        Date validDate = Date.newInstance(System.today().year(), System.today().month(), 15);

        Configuracion_BMX__c config = [SELECT Id, PM_Estoque_Dia_Desde__c, PM_Estoque_Dia_Hasta__c FROM Configuracion_BMX__c LIMIT 1];

        Test.startTest();
        String result = OpportunityAPI.validateDateNewStock(validDate, config.PM_Estoque_Dia_Desde__c, config.PM_Estoque_Dia_Hasta__c);
        Test.stopTest();

        System.assertEquals(Label.OpportunityAPI_General_Generic_Success_Message, result);

    }

    /**
     *  METHOD:         validateDateNewStockTestNegative
     *  DESCRIPTION:    Test class for OpportunityAPI.validateDateNewStock. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (07-oct-21)
     *  TEST CASE:      call method with invalid date ==> returns error message
     **/ 
    @isTest
    public static void validateDateNewStockTestNegative() {
        Date invalidDate = Date.newInstance(System.today().year(), System.today().month(), 11);

        Configuracion_BMX__c config = [SELECT Id, PM_Estoque_Dia_Desde__c, PM_Estoque_Dia_Hasta__c FROM Configuracion_BMX__c LIMIT 1];

        Test.startTest();
        String result = OpportunityAPI.validateDateNewStock(invalidDate, config.PM_Estoque_Dia_Desde__c, config.PM_Estoque_Dia_Hasta__c);
        Test.stopTest();

        System.assertEquals(Label.Estoque_Val_New_Estoque, result);
    }

    /**
     *  METHOD:         getOpportunityisValidA2RebaixamentoTest
     *  DESCRIPTION:    Test class for OpportunityAPI.getOpportunityisValid. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     *  TEST CASE:      call method with valid request data for Anexo II Rebaixamento ==> success, returns true
     **/ 
    @isTest
    public static void getOpportunityisValidA2RebaixamentoTest() {

        Account account = [SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Name = 'test' LIMIT 1];

        delete (account.Opportunities);

        Id recordTypeIdA2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo II').getRecordTypeId();

        Opportunity approvedA2 = new Opportunity(  Name = 'Test Anexo II', 
                                                    AccountId = account.Id,
                                                    Cultura__c = TESTCULTURA,
                                                    Marca__c = TESTMARCA,
                                                    Safra__c = TESTSAFRA,
                                                    RecordTypeId = recordTypeIdA2,
                                                    StageName =  'Aprobada',
                                                    CloseDate = System.today() );

        insert approvedA2;

        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/OpportunityAPI/';  
        request.httpMethod = 'GET';
        request.addParameter('accountId', account.Id);
        request.addParameter('cultura', TESTCULTURA);
        request.addParameter('marca', TESTMARCA);  
        request.addParameter('anexo', 'Anexo II Rebaixamento Sacas');

        RestResponse response = new RestResponse();
        RestContext.request = request; 
        RestContext.response= response;

        Test.startTest();
        OpportunityAPI.getOpportunityisValid();
        Test.stopTest();

        Map<String, String> parsedResp = (Map<String, String>) JSON.deserialize( RestContext.response.responseBody.toString(), Map<String, String>.class);
        System.assertEquals('true',  parsedResp.get('status'));
    }

    /**
     *  METHOD:         getOpportunityisValidReembalajeTest
     *  DESCRIPTION:    Test class for OpportunityAPI.getOpportunityisValid. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     *  TEST CASE:      call method with valid request data for Reembalaje ==> success, returns true
     **/ 
    @isTest
    public static void getOpportunityisValidReembalajeTest() {

        Account account = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        Id recordTypeIdCVB = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CVB Autorizada').getRecordTypeId();

        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(    new Opportunity(Name = 'Test CVB Aprobado', 
                                                AccountId = account.Id,
                                                Cultura__c = TESTCULTURA,
                                                Marca__c = TESTMARCA,
                                                Safra__c = TESTSAFRA,
                                                RecordTypeId = recordTypeIdCVB,
                                                StageName =  'AU - Autorizada',
                                                CloseDate = System.today() ));

        insert opportunityList;

        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/OpportunityAPI/';  
        request.httpMethod = 'GET';
        request.addParameter('accountId', account.Id);
        request.addParameter('cultura', TESTCULTURA);
        request.addParameter('marca', TESTMARCA);  
        request.addParameter('anexo', 'Reembalaje');

        RestResponse response = new RestResponse();
        RestContext.request = request; 
        RestContext.response= response;

        Test.startTest();
        OpportunityAPI.getOpportunityisValid();
        Test.stopTest();

        Map<String, String> parsedResp = (Map<String, String>) JSON.deserialize( RestContext.response.responseBody.toString(), Map<String, String>.class);
        System.assertEquals('true',  parsedResp.get('status'));
    }

    /**
     *  METHOD:         getOpportunityisValidDescarteTest
     *  DESCRIPTION:    Test class for OpportunityAPI.getOpportunityisValid. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     *  TEST CASE:      call method with valid request data for Descarte ==> success, returns true
     **/ 
    @isTest
    public static void getOpportunityisValidDescarteTest() {

        Account account = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        Id recordTypeIdA3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo III').getRecordTypeId();

        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(    new Opportunity(Name = 'Test Anexo III Aprobado', 
                                                AccountId = account.Id,
                                                Cultura__c = TESTCULTURA,
                                                Marca__c = TESTMARCA,
                                                Safra__c = TESTSAFRA,
                                                RecordTypeId = recordTypeIdA3,
                                                StageName =  'Aprobada',
                                                CloseDate = System.today() ));

        insert opportunityList;

        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/OpportunityAPI/';  
        request.httpMethod = 'GET';
        request.addParameter('accountId', account.Id);
        request.addParameter('cultura', TESTCULTURA);
        request.addParameter('marca', TESTMARCA);  
        request.addParameter('anexo', 'Descarte');

        RestResponse response = new RestResponse();
        RestContext.request = request; 
        RestContext.response= response;

        Test.startTest();
        OpportunityAPI.getOpportunityisValid();
        Test.stopTest();

        Map<String, String> parsedResp = (Map<String, String>) JSON.deserialize( RestContext.response.responseBody.toString(), Map<String, String>.class);
        System.assertEquals('true',  parsedResp.get('status'));
    }

    /**
     *  METHOD:         getOpportunityisValidStockTest
     *  DESCRIPTION:    Test class for OpportunityAPI.getOpportunityisValid. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     *  TEST CASE:      call method with valid request data for Stock Multiplicadores ==> success, returns true
     **/ 
    @isTest
    public static void getOpportunityisValidStockTest() {

        Configuracion_BMX__c config = [SELECT Id, PM_Estoque_Dia_Desde__c, PM_Estoque_Dia_Hasta__c FROM Configuracion_BMX__c LIMIT 1];
        config.PM_Estoque_Dia_Desde__c = 1;
        config.PM_Estoque_Dia_Hasta__c = 31;
        update config;

        Account account = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        Id recordTypeIdA1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo I').getRecordTypeId();

        List<Opportunity> opportunityList = new List<Opportunity>();
        opportunityList.add(    new Opportunity(Name = 'Test Anexo I Aprobado', 
                                                AccountId = account.Id,
                                                Cultura__c = TESTCULTURA,
                                                Marca__c = TESTMARCA,
                                                Safra__c = TESTSAFRA,
                                                RecordTypeId = recordTypeIdA1,
                                                StageName =  'Aprobada',
                                                CloseDate = System.today() ));

        insert opportunityList;

        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/OpportunityAPI/';  
        request.httpMethod = 'GET';
        request.addParameter('accountId', account.Id);
        request.addParameter('cultura', TESTCULTURA);
        request.addParameter('marca', TESTMARCA);  
        request.addParameter('anexo', 'Stock Multiplicadores');

        RestResponse response = new RestResponse();
        RestContext.request = request; 
        RestContext.response= response;

        Test.startTest();
        OpportunityAPI.getOpportunityisValid();
        Test.stopTest();

        Map<String, String> parsedResp = (Map<String, String>) JSON.deserialize( RestContext.response.responseBody.toString(), Map<String, String>.class);
        System.assertEquals('true',  parsedResp.get('status'));
    }


}
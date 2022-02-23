@isTest
public with sharing class EventosAPITest {

    public static final String TESTEVENTOLXL = 'Lado a Lado';
    public static final String TESTEVENTOTREINAMENTO = 'Treinamento';
    public static final String TESTEVENTOPALESTRA = 'Palestra';
    public static final String TESTEVENTOOUTDOOR = 'Outdoor';
    public static final String TESTEVENTOEMPLACAMENTO = 'Emplacamento';
    public static final String TESTEVENTODIADECAMPO = 'Día de Campo';
    public static final String TESTEVENTOAREACOMERCIAL = 'Area comercial';
    public static final String TESTESTADO = 'BA';
    public static final String TESTFASEPOSITIVE = 'Plantio';
    public static final String TESTFASENEGATIVE = 'Colheita';

    @TestSetup
    static void makeData(){

        Configuracion_BMX__c configBMX = new Configuracion_BMX__c();
        configBMX.Name = 'Test Configuracion';

        insert configBMX;

        Estado__c estado = new Estado__c(Name = TESTESTADO);
        insert estado;

        String validStartDate = String.valueOf(System.today().day() - 1) + '/' + String.valueOf(System.today().month());
        String invalidStartDate = String.valueOf(System.today().day() + 1) + '/' + String.valueOf(System.today().month());
        String validEndDate = String.valueOf(System.today().day() - 2) + '/' + String.valueOf(System.today().month());

        List<Prazo_de_Lancamento__c> prazoList = new List<Prazo_de_Lancamento__c>();
        Prazo_de_Lancamento__c LxLPrazo = new Prazo_de_Lancamento__c(Estado__c = estado.Id, Configuracion_de_Marca__c = configBMX.Id, Evento__c = TESTEVENTOLXL);
        LxLPrazo.Cadastro_de_plantio__c = validStartDate;
        LxLPrazo.Cadastro_de_colheita__c = invalidStartDate;
        LxLPrazo.Termino__c = validEndDate;
        prazoList.add(LxLPrazo);
        prazoList.add( new Prazo_de_Lancamento__c(Estado__c = estado.Id, Configuracion_de_Marca__c = configBMX.Id, Evento__c = TESTEVENTOTREINAMENTO, Inicio__c = validStartDate, Termino__c = validEndDate) );
        prazoList.add( new Prazo_de_Lancamento__c(Estado__c = estado.Id, Configuracion_de_Marca__c = configBMX.Id, Evento__c = TESTEVENTOPALESTRA, Inicio__c = validStartDate, Termino__c = validEndDate) );
        prazoList.add( new Prazo_de_Lancamento__c(Estado__c = estado.Id, Configuracion_de_Marca__c = configBMX.Id, Evento__c = TESTEVENTOOUTDOOR, Inicio__c = validStartDate, Termino__c = validEndDate) );
        prazoList.add( new Prazo_de_Lancamento__c(Estado__c = estado.Id, Configuracion_de_Marca__c = configBMX.Id, Evento__c = TESTEVENTOEMPLACAMENTO, Inicio__c = validStartDate, Termino__c = validEndDate) );
        prazoList.add( new Prazo_de_Lancamento__c(Estado__c = estado.Id, Configuracion_de_Marca__c = configBMX.Id, Evento__c = TESTEVENTODIADECAMPO, Inicio__c = validStartDate, Termino__c = validEndDate) );
        prazoList.add( new Prazo_de_Lancamento__c(Estado__c = estado.Id, Configuracion_de_Marca__c = configBMX.Id, Evento__c = TESTEVENTOAREACOMERCIAL, Inicio__c = validStartDate, Termino__c = validEndDate) );
        insert prazoList;

    }    
    
    /**
     *  METHOD:         getNewEventIsValidTestPositiveLxL
     *  DESCRIPTION:    Test class for EventosAPI.getNewEventIsValid. Created for US #13074 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-ene-22)
     *  TEST CASE:      call method with valid date settings for Lado a Lado event ==> success, returns true
     **/ 
    @isTest
    public static void getNewEventIsValidTestPositiveLxL() {

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EventosAPI/';  
        req.addParameter('evento', TESTEVENTOLXL);
        req.addParameter('estado', TESTESTADO);
        req.addParameter('fase', TESTFASEPOSITIVE);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        EventosAPI.getNewEventIsValid();
        Test.stopTest();

        EventosAPI.Response result = (EventosAPI.Response)JSON.deserialize(resp.responseBody.toString(), EventosAPI.Response.class);
        System.assert(result.status);
        System.assertEquals(Label.EventosAPI_Success_Message, result.message);

    }

    /**
     *  METHOD:         getNewEventIsValidTestNegativeLxL1
     *  DESCRIPTION:    Test class for EventosAPI.getNewEventIsValid. Created for US #13074 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-ene-22)
     *  TEST CASE:      call method with invalid date settings for Lado a Lado event ==> returns false status and error message
     **/ 
    @isTest
    public static void getNewEventIsValidTestNegativeLxL1() {

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EventosAPI/';  
        req.addParameter('evento', TESTEVENTOLXL);
        req.addParameter('estado', TESTESTADO);
        req.addParameter('fase', TESTFASENEGATIVE);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        EventosAPI.getNewEventIsValid();
        Test.stopTest();

        EventosAPI.Response result = (EventosAPI.Response)JSON.deserialize(resp.responseBody.toString(), EventosAPI.Response.class);
        System.assertEquals(false, result.status);
        System.assertEquals(Label.EventosAPI_Default_Error_Message, result.message);

    }

    /**
     *  METHOD:         getNewEventIsValidTestNegativeLxL2
     *  DESCRIPTION:    Test class for EventosAPI.getNewEventIsValid. Created for US #13074 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-ene-22)
     *  TEST CASE:      call method with null fase for Lado a Lado event ==> returns false status and error message
     **/ 
    @isTest
    public static void getNewEventIsValidTestNegativeLxL2() {

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EventosAPI/';  
        req.addParameter('evento', TESTEVENTOLXL);
        req.addParameter('estado', TESTESTADO);
        req.addParameter('fase', '');
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        EventosAPI.getNewEventIsValid();
        Test.stopTest();

        EventosAPI.Response result = (EventosAPI.Response)JSON.deserialize(resp.responseBody.toString(), EventosAPI.Response.class);
        System.assertEquals(false, result.status);
        System.assertEquals(Label.EventosAPI_Fase_LXL_Error_Message, result.message);

    }

    /**
     *  METHOD:         getNewEventIsValidTestPositiveTreinamento
     *  DESCRIPTION:    Test class for EventosAPI.getNewEventIsValid. Created for US #13074 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-ene-22)
     *  TEST CASE:      call method with valid date settings for Treinamento event ==> success, returns true
     **/ 
    @isTest
    public static void getNewEventIsValidTestPositiveTreinamento() {

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EventosAPI/';  
        req.addParameter('evento', TESTEVENTOTREINAMENTO);
        req.addParameter('estado', TESTESTADO);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        EventosAPI.getNewEventIsValid();
        Test.stopTest();

        EventosAPI.Response result = (EventosAPI.Response)JSON.deserialize(resp.responseBody.toString(), EventosAPI.Response.class);
        System.assert(result.status);
        System.assertEquals(Label.EventosAPI_Success_Message, result.message);

    }

    /**
     *  METHOD:         getNewEventIsValidTestPositivePalestra
     *  DESCRIPTION:    Test class for EventosAPI.getNewEventIsValid. Created for US #13074 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-ene-22)
     *  TEST CASE:      call method with valid date settings for Palestra event ==> success, returns true
     **/ 
    @isTest
    public static void getNewEventIsValidTestPositivePalestra() {

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EventosAPI/';  
        req.addParameter('evento', TESTEVENTOPALESTRA);
        req.addParameter('estado', TESTESTADO);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        EventosAPI.getNewEventIsValid();
        Test.stopTest();

        EventosAPI.Response result = (EventosAPI.Response)JSON.deserialize(resp.responseBody.toString(), EventosAPI.Response.class);
        System.assert(result.status);
        System.assertEquals(Label.EventosAPI_Success_Message, result.message);

    }

    /**
     *  METHOD:         getNewEventIsValidTestPositiveOutdoor
     *  DESCRIPTION:    Test class for EventosAPI.getNewEventIsValid. Created for US #13074 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-ene-22)
     *  TEST CASE:      call method with valid date settings for Outdoor event ==> success, returns true
     **/ 
    @isTest
    public static void getNewEventIsValidTestPositiveOutdoor() {

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EventosAPI/';  
        req.addParameter('evento', TESTEVENTOOUTDOOR);
        req.addParameter('estado', TESTESTADO);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        EventosAPI.getNewEventIsValid();
        Test.stopTest();

        EventosAPI.Response result = (EventosAPI.Response)JSON.deserialize(resp.responseBody.toString(), EventosAPI.Response.class);
        System.assert(result.status);
        System.assertEquals(Label.EventosAPI_Success_Message, result.message);

    }

    /**
     *  METHOD:         getNewEventIsValidTestPositiveDiaDeCampo
     *  DESCRIPTION:    Test class for EventosAPI.getNewEventIsValid. Created for US #13074 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-ene-22)
     *  TEST CASE:      call method with valid date settings for Dia de Campo event ==> success, returns true
     **/ 
    @isTest
    public static void getNewEventIsValidTestPositiveDiaDeCampo() {

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EventosAPI/';  
        req.addParameter('evento', 'Dia de Campo');
        req.addParameter('estado', TESTESTADO);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        EventosAPI.getNewEventIsValid();
        Test.stopTest();

        EventosAPI.Response result = (EventosAPI.Response)JSON.deserialize(resp.responseBody.toString(), EventosAPI.Response.class);
        System.assert(result.status);
        System.assertEquals(Label.EventosAPI_Success_Message, result.message);

    }

    /**
     *  METHOD:         getNewEventIsValidTestPositiveAreaComercial
     *  DESCRIPTION:    Test class for EventosAPI.getNewEventIsValid. Created for US #20642 
     *  AUTHOR:         irina.benitez@cloudgaia.com (16-feb-22)
     *  TEST CASE:      call method with valid date settings for Area Comercial event ==> success, returns true
     **/ 
    @isTest
    public static void getNewEventIsValidTestPositiveAreaComercial() {

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EventosAPI/';  
        req.addParameter('evento', TESTEVENTOAREACOMERCIAL);
        req.addParameter('estado', TESTESTADO);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        EventosAPI.getNewEventIsValid();
        Test.stopTest();

        EventosAPI.Response result = (EventosAPI.Response)JSON.deserialize(resp.responseBody.toString(), EventosAPI.Response.class);
        System.assert(result.status);
        System.assertEquals(Label.EventosAPI_Success_Message, result.message);

    }

    /**
     *  METHOD:         getNewEventIsValidTestNegativeInvalidEvent
     *  DESCRIPTION:    Test class for EventosAPI.getNewEventIsValid. Created for US #13074 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-ene-22)
     *  TEST CASE:      call method with invalid event type ==> returns false and error message
     **/ 
    @isTest
    public static void getNewEventIsValidTestNegativeInvalidEvent() {

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EventosAPI/';  
        req.addParameter('evento', 'invalidEvento');
        req.addParameter('estado', TESTESTADO);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        EventosAPI.getNewEventIsValid();
        Test.stopTest();

        EventosAPI.Response result = (EventosAPI.Response)JSON.deserialize(resp.responseBody.toString(), EventosAPI.Response.class);
        System.assertEquals(false, result.status);
        System.assertEquals(Label.EventosAPI_Bad_Event_Error_Message, result.message);

    }

    /**
     *  METHOD:         getNewEventIsValidTestPositiveNoPrazoDeLancamento
     *  DESCRIPTION:    Test class for EventosAPI.getNewEventIsValid. Created for US #20922 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-feb-22)
     *  TEST CASE:      call method with valid event and no prazos de lancamento defined ==> success, returns true
     **/ 
    @isTest
    public static void getNewEventIsValidTestPositiveNoPrazoDeLancamento() {

        List<Prazo_de_Lancamento__c> prazosForEvent = [SELECT Id FROM Prazo_de_Lancamento__c WHERE Evento__c = :TESTEVENTOPALESTRA];
        delete prazosForEvent;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EventosAPI/';  
        req.addParameter('evento', TESTEVENTOPALESTRA);
        req.addParameter('estado', TESTESTADO);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        EventosAPI.getNewEventIsValid();
        Test.stopTest();

        EventosAPI.Response result = (EventosAPI.Response)JSON.deserialize(resp.responseBody.toString(), EventosAPI.Response.class);
        System.assert(result.status);
        System.assertEquals(Label.EventosAPI_Success_Message, result.message);

    }

    /**
     *  METHOD:         getNewEventIsValidTestNegativeNoPrazoDeLancamentoForEstado
     *  DESCRIPTION:    Test class for EventosAPI.getNewEventIsValid. Created for US #20922 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-feb-22)
     *  TEST CASE:      call method with valid event and prazos de lancamento defined but for different estado ==> fails, returns false
     **/ 
    @isTest
    public static void getNewEventIsValidTestNegativeNoPrazoDeLancamentoForEstado() {

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EventosAPI/';  
        req.addParameter('evento', TESTEVENTOPALESTRA);
        req.addParameter('estado', 'AC');
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        Test.startTest();
        EventosAPI.getNewEventIsValid();
        Test.stopTest();

        EventosAPI.Response result = (EventosAPI.Response)JSON.deserialize(resp.responseBody.toString(), EventosAPI.Response.class);
        System.assertEquals(false, result.status);
        System.assertEquals(Label.EventosAPI_Bad_Settings_Error_Message, result.message);

    }

}
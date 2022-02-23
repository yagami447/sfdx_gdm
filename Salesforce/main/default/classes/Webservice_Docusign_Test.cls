@isTest
global class Webservice_Docusign_Test { 
    
    private static final Test_Utils testUtils = Test_Utils.getInstance();
    
    global class CallingToolDocusignHTTP implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            if(req.getEndpoint().endsWith('token')) {
            	response.setBody('{"access_token":"token_test"}');     
                response.setStatusCode(200);
                response.setStatus('OK');
            } else if(req.getEndpoint().endsWith('envelopes')) {
                response.setBody('{"envelopeId":"b18406ac-e33a-4123-b053-631ef79133e4","uri":"/envelopes/b18406ac-e33a-4123-b053-631ef79133e4","statusDateTime":"2019-04-26T20:31:27.4217810Z","status":"sent"}');        
            	response.setStatusCode(200);
                response.setStatus('OK');
            } else if(req.getEndpoint().endsWith('userinfo')) {
                response.setBody('{"sub":"4799e5e9-xxxx-xxxx-xxxx-cf4713bbcacc","name":"Susan Smart","given_name":"Susan","family_name":"Smart","created":"2015-08-13T22:03:03.45","email":"susan.smart@example.com","accounts":[{"account_id":"a4ec37d6-xxxx-xxxx-xxxx-143885c220e1","is_default":true,"account_name":"Susan Smart","base_uri":"https://domain.example.com","organization":{"organization_id":"9c5fb8e1-xxxx-xxxx-xxxx-054ff8a249bf","links":[{"rel":"self","href":"https://account.domain.example.com/organizations/9c5fb8e1-xxxx-xxxx-xxxx-054ff8a249bf"}]}}]}');        
            	response.setStatusCode(200);
                response.setStatus('OK');
            } else {
                response.setStatusCode(501);
            	response.setStatus('Not Implemented');
                response.setBody('Endpoint '+req.getEndpoint()+' not implemented');
            }
            return response;
        }  
    }
    
    global class CallingToolDocusignFailHTTP implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            if(req.getEndpoint().endsWith('userinfo'))  {
                response.setStatusCode(500);
                response.setStatus('Internal Server Error');
            }
            return response;
        }
    }
    
    static testMethod void shouldGetAccessToken(){
        Test.setMock(HttpCalloutMock.class, new CallingToolDocusignHTTP());

        String accessToken = Webservice_Docusign.getAccessToken();
        System.assertEquals('token_test', accessToken);
    }
    
    public static testmethod void shouldGetUserBaseUrl() {
        Test.setMock(HttpCalloutMock.class, new CallingToolDocusignHTTP());
        
        String baseUrl = Webservice_Docusign.getUserBaseUrl();        
        System.assertEquals('https://domain.example.com', baseUrl);
    }
    
    static testMethod void shoudlNotSendDocusignBaseUrlError() {
        Test.setMock(HttpCalloutMock.class, new CallingToolDocusignFailHTTP());
        
		HttpResponse response = Webservice_Docusign.sendContractEnvelope(null, null, null, null, null);
        System.assertEquals(500, response.getStatusCode());
        System.assertEquals('Internal Server Error', response.getStatus());
        System.assertEquals('Cant get the Docusign BASE_URL for the USERNAME', response.getBody());
    }
    
    static testMethod void shoudlNotSendDocusignContractTypeNotImplementedError() {
        Test.setMock(HttpCalloutMock.class, new CallingToolDocusignHTTP());
        
        HttpResponse response = Webservice_Docusign.sendContractEnvelope(null, null, 'Teste', null, null);
        System.assertEquals(501, response.getStatusCode());
        System.assertEquals('Not Implemented', response.getStatus());
        System.assertEquals('Sent contracts for Teste RecordType is not implemented', response.getBody());
    }
    
    static testMethod void shoudlSendContractBypass() {
        Test.setMock(HttpCalloutMock.class, new CallingToolDocusignHTTP());
        
        Blob pdfContent = Blob.valueOf('Teste \\s1\\');
        
        Test.startTest();
        Webservice_Docusign.sendContractEnvelope('006000000000000000', pdfContent, null, 'TXT', 'email@teste.com');
        Test.stopTest();
        try {
        	dfsle__EnvelopeStatus__c envelopeStatusObject = [SELECT Id FROM dfsle__EnvelopeStatus__c WHERE dfsle__SourceId__c = '006000000000000000' LIMIT 1];
            System.assert(envelopeStatusObject.Id != null);
        } catch(Exception e) {
        	System.assert(false);   
        }
    }
    
    static testMethod void shoudlSendRebajaSacasSupervisor() {
        Test.setMock(HttpCalloutMock.class, new CallingToolDocusignHTTP());
        
        Opportunity opportunityObject = testUtils.createNewOpportunityAnexo2RebajaSupervisorOrGerente(new Opportunity(StageName='Pendiente de Aprobación'), 'Supervisor');
        insert opportunityObject;
        
        Blob pdfContent = Blob.valueOf('Teste \\s1\\');
        
        Test.startTest();
		Webservice_Docusign.sendContractEnvelope(opportunityObject.Id, pdfContent,'Anexo II Rebaixamento Sacas', 'TXT', null);
        Test.stopTest();
        try {
        	dfsle__EnvelopeStatus__c envelopeStatusObject = [SELECT Id FROM dfsle__EnvelopeStatus__c WHERE dfsle__SourceId__c =: opportunityObject.Id LIMIT 1];
            System.assert(envelopeStatusObject.Id != null);
        } catch(Exception e) {
        	System.assert(false);   
        }
    }
    
    static testMethod void shoudlSendTermoAditivo() {
        Test.setMock(HttpCalloutMock.class, new CallingToolDocusignHTTP());
        
        Contrato__c contratoMultiplicacaoObject = testUtils.createNewContratoMultiplicacao(null, null, null, null);
        contratoMultiplicacaoObject.OwnerId = [SELECT Id FROM User WHERE Profile.Name = 'Gerente LE' AND IsActive = true AND ManagerId != null LIMIT 1].Id;
        insert contratoMultiplicacaoObject;

        
        Blob pdfContent = Blob.valueOf('Teste \\s1\\');

        dfsle__EnvelopeStatus__c newDocusignStatus = new dfsle__EnvelopeStatus__c(Contrato_de_Multiplicacao__c = contratoMultiplicacaoObject.Id);
        insert newDocusignStatus;

        Contact newContact1 = new Contact(FirstName = 'Test', LastName = '1', Email = 'salesforce.alerts@xappia.com');
        insert newContact1;
        Contact newContact2 = new Contact(FirstName = 'Test', LastName = '2', Email = 'salesforce.alerts@xappia.com');
        insert newContact2;

        dfsle__RecipientStatus__c newRecipient1 = new dfsle__RecipientStatus__c(dfsle__EnvelopeStatus__c = newDocusignStatus.Id, Contacto__c = newContact1.Id);
        insert newRecipient1;
        dfsle__RecipientStatus__c newRecipient2 = new dfsle__RecipientStatus__c(dfsle__EnvelopeStatus__c = newDocusignStatus.Id, Contacto__c = newContact2.Id);
        insert newRecipient2;

        Test.startTest();        
        Webservice_Docusign.sendContractEnvelope(contratoMultiplicacaoObject.Id, pdfContent, 'Termo Aditivo', 'TXT', null);
        Test.stopTest();
        try {
        	dfsle__EnvelopeStatus__c envelopeStatusObject = [SELECT Id FROM dfsle__EnvelopeStatus__c WHERE dfsle__SourceId__c =: contratoMultiplicacaoObject.Id LIMIT 1];
            System.assert(envelopeStatusObject.Id != null);
        } catch(Exception e) {
        	System.assert(false);   
        }
    }
}
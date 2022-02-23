public without sharing class Webservice_Docusign {

	private static Http httpObject = new Http();    
    private static final String ACCOUNT_ID = Docusign_Config.getValueByName('Account_Id__c');
    private static final String USERNAME = Docusign_Config.getValueByName('User_Id__c');
    private static final String CLIENT_ID = Docusign_Config.getValueByName('Integration_Key__c'); //Integration Key
    private static final String AUTH_URL = Docusign_Config.getValueByName('Authentication_URL__c');
    private static final String BASE_URL = getUserBaseUrl() + '/restapi/v2';
    
    public static HttpResponse sendContractEnvelope(Id objectId, Blob file, String contractType, String fileFormat, String bypassEmail) {
        List<Signatario__c> recipientStatus = new  List<Signatario__c>();
        if(BASE_URL.contains('null')) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(500);
            response.setStatus('Internal Server Error');
            response.setBody('Cant get the Docusign BASE_URL for the USERNAME');
            return response;
        }
        String documentName, emailSubject, typeAssignature;
        User signerObject;
        emailSubject = 'GDM - Documento';
        if(bypassEmail != null) {
            signerObject = new User();
            signerObject.FirstName = 'Nome';
            signerObject.LastName = 'Bypass';
            signerObject.Email = bypassEmail;
            documentName = 'document_bypass';
        } else { 
            if(contractType == 'Termo Aditivo'  || contractType== 'Termo Aditivo Biotec') {
                Contrato__c contratoMultiplicacaoObject = [
                    SELECT Name, Multiplicador__r.Name, Sociedad__c, Safra__c, Multiplicador__r.Email__c, OwnerId 
                    FROM Contrato__c 
                    WHERE Id = :objectId 
                    LIMIT 1
                ];
                recipientStatus = [
                    SELECT Name, Contacto__c, Contacto__r.Name, Contacto__r.FirstName, 
                    Contacto__r.LastName, Contacto__r.Email 
                    FROM Signatario__c 
                    WHERE Contrato_de_Multiplicacao__c = :objectId
                ];
                documentName = contratoMultiplicacaoObject.Sociedad__c + '_' + contratoMultiplicacaoObject.Safra__c + ' ' + contratoMultiplicacaoObject.Multiplicador__r.Name;
                User ownerObject = [SELECT Id, Profile.Name, ManagerId FROM User WHERE Id = :contratoMultiplicacaoObject.OwnerId LIMIT 1];
                User diretorComercialObject;
                if(ownerObject.Profile.Name == 'Gerente LE') {
                    diretorComercialObject = [SELECT Name, Email FROM User WHERE Id = :ownerObject.ManagerId LIMIT 1];
                } else {
                    User gerenteObject = [SELECT ManagerId, Name FROM User WHERE Id = :ownerObject.ManagerId LIMIT 1];
                    diretorComercialObject = [SELECT Name, Email FROM User WHERE Id = :gerenteObject.ManagerId LIMIT 1];
                }
                signerObject = diretorComercialObject;
                emailSubject = 'GDM - Documento '+contratoMultiplicacaoObject.Name;
            } else if(contractType == 'Termo Juridico') {

                Contract contratoTermoJuridico = [
                    SELECT Name, Account.Name, Sociedad__c, Safras__c, Account.Email__c, OwnerId 
                    FROM Contract 
                    WHERE Id = :objectId 
                    LIMIT 1
                ];
                String safrasToTitle = contratoTermoJuridico.Safras__c.replaceAll(';', ', ');
                documentName = contratoTermoJuridico.Sociedad__c + '_' + safrasToTitle + ' ' + contratoTermoJuridico.Account.Name;
                User ownerObject = [SELECT Id, Profile.Name, ManagerId FROM User WHERE Id = :contratoTermoJuridico.OwnerId LIMIT 1];
                User diretorComercialObject;
                if(ownerObject.Profile.Name == 'Gerente LE') {
                    diretorComercialObject = [SELECT Name, Email FROM User WHERE Id = :ownerObject.ManagerId LIMIT 1];
                } else {
                    User gerenteObject = [SELECT ManagerId, Name FROM User WHERE Id = :ownerObject.ManagerId LIMIT 1];
                    diretorComercialObject = [SELECT Name, Email FROM User WHERE Id = :gerenteObject.ManagerId LIMIT 1];
                }
                signerObject = diretorComercialObject;
                emailSubject = 'GDM - Documento '+ contratoTermoJuridico.Name;

            }else if(contractType == 'Macro Milho') {
                System.debug('on Webservice_Docusign.sendContractEnvelope().contractType == Macro Milho');
                Contract contratoMacroMilho = [
                    SELECT ContractNumber, Account.Name, Sociedad__c, Safras__c, Account.Email__c, OwnerId 
                    FROM Contract 
                    WHERE Id = :objectId 
                    LIMIT 1
                ];
                String safrasToTitle = contratoMacroMilho.Safras__c.replaceAll(';', ', ');
                documentName = contratoMacroMilho.Sociedad__c + '_' + safrasToTitle + ' ' + contratoMacroMilho.Account.Name;
                User ownerObject = [SELECT Id, Profile.Name, ManagerId FROM User WHERE Id = :contratoMacroMilho.OwnerId LIMIT 1];
                User diretorComercialObject;
                if(ownerObject.Profile.Name == 'Gerente LE') {
                    diretorComercialObject = [SELECT Name, Email FROM User WHERE Id = :ownerObject.ManagerId LIMIT 1];
                } else {
                    User gerenteObject = [SELECT ManagerId, Name FROM User WHERE Id = :ownerObject.ManagerId LIMIT 1];
                    diretorComercialObject = [SELECT Name, Email FROM User WHERE Id = :gerenteObject.ManagerId LIMIT 1];
                }
                signerObject = diretorComercialObject;
                emailSubject = 'GDM - Documento '+ contratoMacroMilho.ContractNumber;

            } else if(contractType == 'Anexo II Rebaixamento Sacas' || contractType == 'Reembalaje' || contractType == 'Anexo I') {
                Opportunity opportunityObject = [SELECT Id, Name, Marca__c, Account.Nome_fantasia__c, OwnerId FROM Opportunity WHERE Id = :objectId LIMIT 1];
                documentName = opportunityObject.Account.Nome_fantasia__c + '_' + opportunityObject.Name + '_' + opportunityObject.Marca__c;
                User supervisorObject = [SELECT Id, Profile.Name, ManagerId FROM User WHERE Id =: opportunityObject.OwnerId LIMIT 1];
                Id gerenteId;
                if(supervisorObject.Profile.Name == 'Gerente LE') {
                    gerenteId = supervisorObject.Id;
                } else {
                    gerenteId = supervisorObject.ManagerId;
                }
                User gerenteObject = [SELECT Id, Name, Email FROM User WHERE Id = :gerenteId LIMIT 1];
                signerObject = gerenteObject;
                emailSubject = 'GDM - Documento '+opportunityObject.Name;
            } else {
                HttpResponse response = new HttpResponse();
                response.setStatusCode(501);
                response.setStatus('Not Implemented');
                response.setBody('Sent contracts for '+contractType+' RecordType is not implemented');
                return response;
            }   
        }

        Model_Docusign.Recipients recipients = new Model_Docusign.Recipients();

        List<Model_Docusign.Document> documentList = new List<Model_Docusign.Document>();
        Model_Docusign.Document document = new Model_Docusign.Document();
        document.documentId = 1;
        document.name = documentName;    
        document.fileExtension = fileFormat;
        document.documentBase64 = EncodingUtil.base64Encode(file);
        documentList.add(document);
        
        List<Model_Docusign.SignHereTab> signHereTabList = new List<Model_Docusign.SignHereTab>();
        Model_Docusign.SignHereTab signHereTab = new Model_Docusign.SignHereTab();
        signHereTab.anchorString = '\\s1\\';
        signHereTab.anchorXOffset = 0;
        signHereTab.anchorYOffset = 0;
        signHereTab.anchorIgnoreIfNotPresent = 'false';
        signHereTab.anchorUnits = 'inches';
        signHereTab.documentId = 1;
        signHereTabList.add(signHereTab);
        
        List<Model_Docusign.DateSignedTab> dateSignedTabList = new List<Model_Docusign.DateSignedTab>();
        Model_Docusign.DateSignedTab dateSignedTab = new Model_Docusign.DateSignedTab();
        dateSignedTab.anchorString = '\\signedDate\\';
        dateSignedTab.anchorXOffset = 0;
        dateSignedTab.anchorYOffset = -4;
        dateSignedTab.anchorIgnoreIfNotPresent = 'false';
        dateSignedTab.anchorUnits = 'pixels';
        dateSignedTab.documentId = 1;
        dateSignedTab.font = 'TimesNewRoman';
        dateSignedTab.fontSize = 'Size11';
        dateSignedTab.bold = 'true';
        dateSignedTabList.add(dateSignedTab);        
        
        Model_Docusign.Tabs tabs = new Model_Docusign.Tabs();
        tabs.signHereTabs = signHereTabList;
        tabs.dateSignedTabs = dateSignedTabList;
        
        if(contractType == 'Termo Aditivo'  || contractType== 'Termo Aditivo Biotec') {
            List<Model_Docusign.InitialHereTab> initialHereTabList = new List<Model_Docusign.InitialHereTab>();
            Model_Docusign.InitialHereTab initialHereTab = new Model_Docusign.InitialHereTab();
            initialHereTab.anchorString = 'Página';
            initialHereTab.anchorXOffset = -2.0;
            initialHereTab.anchorYOffset = 0.5;
            initialHereTab.anchorIgnoreIfNotPresent = 'false';
            initialHereTab.anchorUnits = 'inches';
            initialHereTab.documentId = 1;
            initialHereTabList.add(initialHereTab);
            tabs.initialHereTabs = initialHereTabList;
        }
        
        Model_Docusign.EmailNotification emailNotification = new Model_Docusign.EmailNotification();
        emailNotification.emailBody = 'Por favor, antes de assinar, verifique as informações do documento. Para acessa-lo clique no link.';
        emailNotification.emailSubject = emailSubject;
        emailNotification.supportedLanguage = 'pt_BR';
        
        List<Model_Docusign.Signer> signerList = new List<Model_Docusign.Signer>();
        Model_Docusign.Signer signer = new Model_Docusign.Signer();
        signer.name = signerObject.Name == null ? signerObject.FirstName+' '+signerObject.LastName : signerObject.Name;
        signer.email = signerObject.Email;
        signer.recipientId = 1;
        signer.routingOrder = 1;
        signer.tabs = tabs;
        signer.emailNotification = emailNotification;
        
        if(Docusign_Config.isProduction()) {
            List<Model_Docusign.RecipientSignatureProviders> recipientSignatureProvidersList = new List<Model_Docusign.RecipientSignatureProviders>();
            Model_Docusign.RecipientSignatureProviders recipientSignatureProviders = new Model_Docusign.RecipientSignatureProviders();
            recipientSignatureProviders.signatureProviderName = 'UniversalSignaturePen_ICP_SmartCard_TSP';
            recipientSignatureProvidersList.add(recipientSignatureProviders);
            signer.recipientSignatureProviders = recipientSignatureProvidersList;
        }
        
        signerList.add(signer);

        // Agregado por Jhonny Peroza

        if(contractType != 'Macro Milho') {
            integer i = 2;
            for(Signatario__c recipient : recipientStatus){
                Model_Docusign.Signer signerContact = new Model_Docusign.Signer();
                signerContact.name = recipient.Contacto__r.Name == null ? recipient.Contacto__r.FirstName+' '+recipient.Contacto__r.LastName : recipient.Contacto__r.Name;
                signerContact.email = recipient.Contacto__r.Email;
                signerContact.recipientId = i;
                tabs.signHereTabs[0].anchorString = '\\s'+i+'\\';
                signerContact.routingOrder = 2;
                signerContact.tabs = tabs;
                signerContact.emailNotification = emailNotification;
                signerList.add(signerContact);
                i++;
            }
        }

        // Agregado por Jhonny Peroza

        if(contractType == 'Macro Milho') {

            Contract type = [SELECT Tipo_de_Assinatura__c FROM Contract WHERE Id =: objectId];

            if(type.Tipo_de_Assinatura__c == 'Eletronica') {
               
                List<Signatario_do_Contrato__c> signatarios = [SELECT Id, Contacto__r.Name, Contacto__r.Email 
                                                                    FROM Signatario_do_Contrato__c 
                                                                       WHERE Contrato__c =: objectId];
                integer i = 2;

                for(Signatario_do_Contrato__c signatario : signatarios) {
        
                    signHereTabList = new List<Model_Docusign.SignHereTab>();

                    tabs = new Model_Docusign.Tabs();

                    Model_Docusign.Signer signerContract = new Model_Docusign.Signer();
                    Model_Docusign.SignHereTab signHereTabContract = new Model_Docusign.SignHereTab();

                    signHereTabContract.anchorString = '\\s'+i+'\\';

                    signHereTabList.add(signHereTabContract);
                    tabs.signHereTabs = signHereTabList;

                    signerContract.name = signatario.Contacto__r.Name;
                    signerContract.email = signatario.Contacto__r.Email;
                    signerContract.recipientId = i;
                    signerContract.routingOrder = i;
                    signerContract.tabs = tabs;
                    signerContract.emailNotification = emailNotification;
                    signerList.add(signerContract);

                    i++;

                }

            }

        }

        recipients.signers = signerList;
        
        Model_Docusign model = new Model_Docusign();
        model.status = 'sent';
		model.emailSubject = emailSubject;
        model.documents = documentList;
        model.recipients = recipients;
        
        String accessToken = getAccessToken();
        
        Map<String, String> headerParams = new Map<String, String>();
        headerParams.put('Authorization', 'Bearer ' + accessToken);
        headerParams.put('Content-Type', 'application/json');
        
        String url = BASE_URL + '/accounts/' + ACCOUNT_ID + '/envelopes';
        System.debug(JSON.serialize(model));
        System.debug(headerParams);
        HttpRequest request = createRequest('POST', url, headerParams, JSON.serialize(model));
        HttpResponse response = httpObject.send(request);
        System.debug(response.getBody());
        if(response != null && (response.getStatusCode() == 201 || response.getStatusCode() == 200)) {
            String responseBody = response.getBody();
            Map<String, String> responseDeserialized = (Map<String, String>)JSON.deserialize(responseBody, Map<String, String>.class);
            String envelopeId = responseDeserialized.get('envelopeId');
            
            dfsle__EnvelopeStatus__c statusObject = new dfsle__EnvelopeStatus__c();
            statusObject.dfsle__SourceId__c = objectId;
            statusObject.dfsle__DocuSignId__c = envelopeId;
            statusObject.Precisa_Assinar__c = signerObject.Id;
            if(!Test.isRunningTest()) {
            	if(contractType == 'Termo Aditivo'   || contractType== 'Termo Aditivo Biotec') {
                    statusObject.Contrato_de_Multiplicacao__c = objectId;
                } else if(contractType == 'Termo Juridico') {
					statusObject.Contract__c = objectId;
				} else if(contractType == 'Macro Milho') {
					statusObject.Contract__c = objectId;
				} else {
                    statusObject.Oportunidade__c = objectId;
                }   
            }
            insert statusObject;
        }
        return response;
    }
    
    @TestVisible
    public static String getUserBaseUrl() {
        String accessToken = getAccessToken();
        Map<String, String> headerParams = new Map<String, String>();
        headerParams.put('Authorization', 'Bearer ' + accessToken);
        headerParams.put('Content-Type', 'application/json');
        
        String url = 'https://'+ AUTH_URL + '/oauth/userinfo';
        
        HttpRequest request = createRequest('GET', url, headerParams, null);
        HttpResponse response = httpObject.send(request);
        System.debug(response);
        if(response != null && (response.getStatusCode() == 201 || response.getStatusCode() == 200)) {
        	Model_Docusign_UserInfo userInfoObject = (Model_Docusign_UserInfo) JSON.deserialize(response.getBody(), Model_Docusign_UserInfo.class);
            return Model_Docusign_UserInfo.getBaseUrlByAccountId(userInfoObject, !Test.isRunningTest() ? ACCOUNT_ID : 'a4ec37d6-xxxx-xxxx-xxxx-143885c220e1');
        }
		return 'null';
    }
    
    @TestVisible
    private static String getAccessToken() {        
        Map<String, String> headerParams = new Map<String, String>();
        headerParams.put('Content-Type', 'application/x-www-form-urlencoded');
        
        Map<String, String> body = new Map<String, String>();
        body.put('grant_type', 'urn:ietf:params:oauth:grant-type:jwt-bearer');
        body.put('assertion', getJWT());
        HttpRequest request = requestTemplate('POST', 'https://'+AUTH_URL+'/oauth/token', headerParams, body);
        HttpResponse response = httpObject.send(request);
        if(response != null && response.getStatusCode() == 200){
            String responseBody = response.getBody();
            Map<String, String> responseDeserialized = (Map<String, String>)JSON.deserialize(responseBody, Map<String, String>.class);
            return responseDeserialized.get('access_token');
        }
        return null;
    }
    
    private static HttpRequest createRequest(String method, String url, Map<String, String> headerParams, String body){
        HttpRequest request = new HttpRequest();
     	request.setMethod(method);
        request.setEndpoint(url);
        
        if(headerParams != null) {
            for(String param : headerParams.keySet()) {
                request.setHeader(param, headerParams.get(param));
            }
        }
        
        if(body != null) {
            if(headerParams != null && headerParams.get('Content-Type').equalsIgnoreCase('application/json')) {
                request.setBody(body);
            }
        }
        return request;
    }
    
    private static HttpRequest requestTemplate(String method, String url, Map<String, String> headerParams, Map<String, Object> body) {
        HttpRequest request = new HttpRequest();
     	request.setMethod(method);
        request.setEndpoint(url);
        
        System.debug(body);
        
        if(headerParams != null) {
            for(String param : headerParams.keySet()) {
                request.setHeader(param, headerParams.get(param));
            }
        }
        
        if(body != null) {
            if(headerParams != null && headerParams.get('Content-Type').equalsIgnoreCase('application/json')) {
                request.setBody(JSON.serialize(body));
            } else {
                String bodyString = '';
                for(String param : body.keySet()) {
                    bodyString += '&' + param + '=' + body.get(param);
                }
                request.setBody(bodyString);
            }
        }
        return request;
    }
    
    private static String getJWT(){
        JWT jwt = new JWT('RS256');
        jwt.scope = 'signature';
        jwt.iss = CLIENT_ID;
        jwt.sub = USERNAME; //API Username
        jwt.aud = AUTH_URL;
        jwt.cert = Docusign_Config.getValueByName('Certificate_Name__c');
        
        return jwt.issue();
    }
}
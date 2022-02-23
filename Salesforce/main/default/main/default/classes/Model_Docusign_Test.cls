@isTest
public class Model_Docusign_Test {

    public static String TEST_BODY = '{"status":"sent","recipients":{"signers":[{"tabs":{"signHereTabs":[{"yPosition":50,"xPosition":100,"pageNumber":1,"documentId":1,"anchorYOffset":0,"anchorXOffset":0,"anchorUnits":"inches","anchorString":"anchorString","anchorIgnoreIfNotPresent":"false"}],"initialHereTabs":[{"documentId":1,"anchorYOffset":-1,"anchorXOffset":0,"anchorUnits":"inches","anchorString":"Página","anchorIgnoreIfNotPresent":"false"}],"dateSignedTabs":[{"yPosition":null,"xPosition":null,"pageNumber":null,"fontSize":"Size12","font":"TimesNewRoman","documentId":1,"bold":"true","anchorYOffset":0,"anchorXOffset":0,"anchorUnits":"inches","anchorString":"signedDateString","anchorIgnoreIfNotPresent":"false"}]},"routingOrder":1,"recipientSignatureProviders":[{"signatureProviderName":"UniversalSignaturePen_ICP_SmartCard_TSP"}],"recipientId":1,"name":"Lucas Teste 2","emailNotification":{"supportedLanguage":"pt_BR","emailSubject":"emailSubject","emailBody":"emailBody"},"email":"lucas.villela+teste1@brainweb.com.br"}]},"emailSubject":"Contrato","documents":[{"name":"Contrato","fileExtension":"PDF","documentId":1,"documentBase64":"RG9jdW1lbnRvIGRlIHRlc3Rl"}]}';
    
    static testMethod void deserialize() {
        Model_Docusign model = (Model_Docusign) JSON.deserialize(TEST_BODY, Model_Docusign.class);
		System.assertEquals('sent', model.status);
        System.assertEquals('Contrato', model.emailSubject);
        System.assertEquals('Contrato', model.documents[0].name);
        System.assertEquals('PDF', model.documents[0].fileExtension);
        System.assertEquals(1, model.documents[0].documentId);
        System.assertEquals('RG9jdW1lbnRvIGRlIHRlc3Rl', model.documents[0].documentBase64);
        System.assertEquals(1, model.recipients.signers[0].routingOrder);
        System.assertEquals(1, model.recipients.signers[0].recipientId);
        System.assertEquals('Lucas Teste 2', model.recipients.signers[0].name);
        System.assertEquals('lucas.villela+teste1@brainweb.com.br', model.recipients.signers[0].email);
        System.assertEquals(100, model.recipients.signers[0].tabs.signHereTabs[0].xPosition);
        System.assertEquals(50, model.recipients.signers[0].tabs.signHereTabs[0].yPosition);
        System.assertEquals(1, model.recipients.signers[0].tabs.signHereTabs[0].pageNumber);
        System.assertEquals(1, model.recipients.signers[0].tabs.signHereTabs[0].documentId);
        System.assertEquals('UniversalSignaturePen_ICP_SmartCard_TSP', model.recipients.signers[0].recipientSignatureProviders[0].signatureProviderName);
        System.assertEquals('signedDateString', model.recipients.signers[0].tabs.dateSignedTabs[0].anchorString);
        System.assertEquals(0, model.recipients.signers[0].tabs.dateSignedTabs[0].anchorXOffset);
        System.assertEquals(0, model.recipients.signers[0].tabs.dateSignedTabs[0].anchorYOffset);
        System.assertEquals('false', model.recipients.signers[0].tabs.dateSignedTabs[0].anchorIgnoreIfNotPresent);
        System.assertEquals('inches', model.recipients.signers[0].tabs.dateSignedTabs[0].anchorUnits);
        System.assertEquals(1, model.recipients.signers[0].tabs.dateSignedTabs[0].documentId);
        System.assertEquals('TimesNewRoman', model.recipients.signers[0].tabs.dateSignedTabs[0].font);
        System.assertEquals('Size12', model.recipients.signers[0].tabs.dateSignedTabs[0].fontSize);
        System.assertEquals('true', model.recipients.signers[0].tabs.dateSignedTabs[0].bold);
    }
    
    static testMethod void serialize() {
        List<Model_Docusign.Document> documentList = new List<Model_Docusign.Document>();
        Model_Docusign.Document document = new Model_Docusign.Document();
        document.documentId = 1;
        document.name = 'Contrato';
        document.fileExtension = 'PDF';
        document.documentBase64 = 'RG9jdW1lbnRvIGRlIHRlc3Rl';
        documentList.add(document);
        
        List<Model_Docusign.SignHereTab> signHereTabList = new List<Model_Docusign.SignHereTab>();
        Model_Docusign.SignHereTab signHereTab = new Model_Docusign.SignHereTab();
        signHereTab.xPosition = 100;
        signHereTab.yPosition = 50;
        signHereTab.pageNumber = 1;
        signHereTab.documentId = 1;
        signHereTab.anchorXOffset = 0;
        signHereTab.anchorYOffset = 0;
        signHereTab.anchorString = 'anchorString';
        signHereTab.anchorIgnoreIfNotPresent = 'false';
        signHereTab.anchorUnits = 'inches';
        signHereTabList.add(signHereTab);
        
        List<Model_Docusign.DateSignedTab> dateSignedTabList = new List<Model_Docusign.DateSignedTab>();
        Model_Docusign.DateSignedTab dateSignedTab = new Model_Docusign.DateSignedTab();
        dateSignedTab.anchorString = 'signedDateString';
        dateSignedTab.anchorXOffset = 0;
        dateSignedTab.anchorYOffset = 0;
        dateSignedTab.anchorIgnoreIfNotPresent = 'false';
        dateSignedTab.anchorUnits = 'inches';
        dateSignedTab.documentId = 1;
        dateSignedTab.font = 'TimesNewRoman';
        dateSignedTab.fontSize = 'Size12';
        dateSignedTab.bold = 'true';
        dateSignedTabList.add(dateSignedTab);
        
        Model_Docusign.Tabs tabs = new Model_Docusign.Tabs();
        tabs.signHereTabs = signHereTabList;
        tabs.dateSignedTabs = dateSignedTabList;
        
        List<Model_Docusign.InitialHereTab> initialHereTabList = new List<Model_Docusign.InitialHereTab>();
        Model_Docusign.InitialHereTab initialHereTab = new Model_Docusign.InitialHereTab();
        initialHereTab.anchorString = 'Página';
        initialHereTab.anchorXOffset = 0;
        initialHereTab.anchorYOffset = -1;
        initialHereTab.anchorIgnoreIfNotPresent = 'false';
        initialHereTab.anchorUnits = 'inches';
        initialHereTab.documentId = 1;
        initialHereTabList.add(initialHereTab);
        tabs.initialHereTabs = initialHereTabList;
        
        Model_Docusign.EmailNotification emailNotification = new Model_Docusign.EmailNotification();
        emailNotification.emailBody = 'emailBody';
        emailNotification.emailSubject = 'emailSubject';
        emailNotification.supportedLanguage = 'pt_BR';
        
        List<Model_Docusign.RecipientSignatureProviders> recipientSignatureProvidersList = new List<Model_Docusign.RecipientSignatureProviders>();
        Model_Docusign.RecipientSignatureProviders recipientSignatureProviders = new Model_Docusign.RecipientSignatureProviders();
        recipientSignatureProviders.signatureProviderName = 'UniversalSignaturePen_ICP_SmartCard_TSP';
        recipientSignatureProvidersList.add(recipientSignatureProviders);
        
        List<Model_Docusign.Signer> signerList = new List<Model_Docusign.Signer>();
        Model_Docusign.Signer signer = new Model_Docusign.Signer();
        signer.name = 'Lucas Teste 2';
        signer.email = 'lucas.villela+teste1@brainweb.com.br';
        signer.recipientId = 1;
        signer.routingOrder = 1;
        signer.tabs = tabs;
        signer.emailNotification = emailNotification;
        signer.recipientSignatureProviders = recipientSignatureProvidersList;
        signerList.add(signer);
        
        Model_Docusign.Recipients recipients = new Model_Docusign.Recipients();
        recipients.signers = signerList;
        
        Model_Docusign model = new Model_Docusign();
        model.status = 'sent';
		model.emailSubject = 'Contrato';
        model.documents = documentList;
        model.recipients = recipients;
        System.debug(JSON.serializePretty(model));
        System.assertEquals(TEST_BODY, JSON.serialize(model));
    }
}
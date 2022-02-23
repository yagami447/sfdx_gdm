@isTest
public class SalvarDescarteAPITest {

    final static String TESTMARCA = 'BRMX';
    final static String TESTSAFRA = '20/21';
    final static String TESTCULTURA = 'Soja';
    final static String TESTACCTNAME = 'Test Account';
    final static String DESCARTERECTYPE = 'Descarte';


    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #13042 
     *  AUTHOR:         irina.benitez@cloudgaia.com (30-sept-21)
     **/ 
    @TestSetup
    static void makeData(){
        test.startTest();

        // Insert Categoria__c records
        List<Categoria__c> categoriaList = new List<Categoria__c>();
        categoriaList.add( new Categoria__c(Name = 'BASICA') );
        categoriaList.add( new Categoria__c(Name = 'REBAJA') );
        insert categoriaList;

        // Insert Variedad__c records
        List<Variedad__c> variedadList = new List<Variedad__c>();
        variedadList.add( new Variedad__c(Name = 'Variedad 1 Test', Ativa__c = true) );
        variedadList.add( new Variedad__c(Name = 'Variedad 2 Test', Ativa__c = true) );
        insert variedadList;

        // Insert Product2 records
        List<Product2> productList = new List<Product2>();
        productList.add( new Product2(Name = 'Product 1 Test', IsActive = true, Categ__c = categoriaList[0].Id, Family = 'Royalty x Basica', Variedade__c = variedadList[0].Id, UNIDADE__c = '1') );
        productList.add( new Product2(Name = 'Product 2 Test', IsActive = true, Categ__c = categoriaList[0].Id, Family = 'Royalty x Basica', Variedade__c = variedadList[1].Id, UNIDADE__c = '1') );
        insert productList;

        // Insert Standard Pricebook prices
        Id stdPriceBookId = Test.getStandardPricebookId();
        List<PricebookEntry> stdPrices = new List<PricebookEntry>();
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[0].Id, UnitPrice = 10) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[1].Id, UnitPrice = 20) );
        insert stdPrices;

        // Insert Pricebook
        Pricebook2 pbRecord = new Pricebook2(Name = 'Lista Canal Multiplicadores', IsActive = true);
        insert pbRecord;

        // Insert Pricebook Entries with Product2.Categ__c.Name = 'BASICA' && Product2.Family = 'Royalty x Basica'
        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[0].Id, UnitPrice = 10, IsActive = true) );
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[1].Id, UnitPrice = 20, IsActive = true) );
        insert pbEntries;

        // Insert Account
        List<Account> accountList = new List<Account>();
        accountList.add( new Account(Name = TESTACCTNAME) );

        insert accountList;

        // Insert Contrato__c
        Id contractRecordType =  Schema.SObjectType.Contrato__c.getRecordTypeInfosByName().get(TESTMARCA).getRecordTypeId();
        Contrato__c contratoMultip = new Contrato__c(   Multiplicador__c = accountList[0].Id, 
                                                        Sociedad__c = TESTMARCA, 
                                                        Safra__c = TESTSAFRA, 
                                                        RecordTypeId = contractRecordType, 
                                                        Chegou_na_Brasmax__c = true, 
                                                        Estado__c = 'Chegou' );
        insert contratoMultip;

        // Insert Item_del_Contrato__c
        Id contractItemRecordType =  Schema.SObjectType.Item_del_Contrato__c.getRecordTypeInfosByName().get('Metas x Cultivar').getRecordTypeId();
        List<Item_del_Contrato__c> contractItemList = new List<Item_del_Contrato__c>();
        contractItemList.add( new Item_del_Contrato__c( RecordTypeId = contractItemRecordType, Contrato_de_Multiplicacion__c = contratoMultip.Id, Cultivar__c = productList[0].Id) );
        contractItemList.add( new Item_del_Contrato__c( RecordTypeId = contractItemRecordType, Contrato_de_Multiplicacion__c = contratoMultip.Id, Cultivar__c = productList[1].Id) );
        insert contractItemList;

        // Insert Opportunity
        Id anexo3RecordType =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId();
        Opportunity opp = new Opportunity(  RecordTypeId = anexo3RecordType, 
                                            Name = 'Test Opportunity', 
                                            AccountId = accountList[0].Id, 
                                            Pricebook2Id = pbRecord.Id, 
                                            StageName = 'Aprobada', 
                                            CloseDate = System.Today(),
                                            Marca__c = TESTMARCA,
                                            Safra__c = TESTSAFRA,
                                            Cultura__c = TESTCULTURA );
        insert opp;

        // Insert OpportunityLineItems
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = productList[0].Id, PricebookEntryId = pbEntries[0].Id, Categoria__c = categoriaList[0].Id, UnitPrice = 10, Quantity = 1000, Semente_aprovada__c = 1000) );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = productList[1].Id, PricebookEntryId = pbEntries[1].Id, Categoria__c = categoriaList[0].Id, UnitPrice = 20, Quantity = 2000, Semente_aprovada__c = 2000) );
        insert oppLineItems;

        // Insert SiteUser__c
        SiteUser__c siteUser = new SiteUser__c( Email__c = 'test@cloudgaia.com', Password__c = 'test-pass-cg-01', Habilitado_BRMX__c = true );
        insert siteUser;

        // Insert SiteUserAccount__c
        SiteUserAccount__c siteUserAccount = new SiteUserAccount__c( Name = 'Test Site User Account', Account__c = accountList[0].Id, SiteUser__c = siteUser.Id, Active__c = true );
        insert siteUserAccount;

        // Insert SiteUserSession__c
        SiteUserSession__c siteUserSession = new SiteUserSession__c( Marca__c = TESTMARCA, Safra__c = TESTSAFRA );
        insert siteUserSession;

        test.stopTest();    
    }        

    /**
     *  METHOD:         saveDescarteTestPositive 
     *  DESCRIPTION:    Test class for SalvarDescarteAPI.saveDescarte. Created for US #13042 
     *  AUTHOR:         irina.benitez@cloudgaia.com (30-sept-21)
     *  TEST CASE:      call method with valid creation data ==> success, returns inserted Descarte Id
     **/ 
    @isTest
    public static void saveDescarteTestPositive() {

        SalvarDescarteAPI.Request testRequest = createTestRequest(true);

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/SalvarDescarteAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(testRequest));

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarDescarteAPI.saveDescarte();
        test.stopTest();

        SalvarDescarteAPI.Response result = (SalvarDescarteAPI.Response)JSON.deserialize(  resp.responseBody.toString(), 
                                                                                                                        SalvarDescarteAPI.Response.class);
        System.debug('result: ' + result);
        
        Opportunity newDescarte = [SELECT Id FROM Opportunity WHERE RecordType.Name = :DESCARTERECTYPE ];

        System.assert(result.status);
        System.assertEquals(Label.SalvarDescarteAPI_Success_Message, result.message);
        System.assertEquals(newDescarte.Id, result.oppDescarteId);

    }

    /**
     *  METHOD:         saveDescarteTestNegative
     *  DESCRIPTION:    Test class for SalvarDescarteAPI.saveDescarte. Created for US #13042 
     *  AUTHOR:         irina.benitez@cloudgaia.com (30-sept-21)
     *  TEST CASE:      call method with empty data  ==> returns default error message
     **/ 
    @isTest
    public static void saveDescarteTestNegative() {

        SalvarDescarteAPI.Request testRequest = createTestRequest(false);

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/SalvarDescarteAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(testRequest));

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarDescarteAPI.saveDescarte();
        test.stopTest();

        SalvarDescarteAPI.Response result = (SalvarDescarteAPI.Response)JSON.deserialize( resp.responseBody.toString(), 
                                                                                                                        SalvarDescarteAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assertEquals(false, result.status);
        System.assertEquals(400, resp.statusCode);
    }


    public static SalvarDescarteAPI.Request createTestRequest(Boolean validProducts){

        Account acct = [SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Name = :TESTACCTNAME LIMIT 1];

        SiteUser__c siteUser = [SELECT Id FROM SiteUser__c LIMIT 1];

        List<OpportunityLineItem> oppLineItemsDescarte = ProductsDescarteAPI.getProductsForNewDescarte(acct.Id, TESTMARCA, TESTSAFRA, TESTCULTURA);
        Map<String, Map<String, Double>> volumenDisponible = ProductsDescarteAPI.getSacasDisponibles(oppLineItemsDescarte, new List<OpportunityLineItem>());
        List<aAppendix.myOppItem> oppItems = ProductsDescarteAPI.oppLineItemJSONConverter(oppLineItemsDescarte, volumenDisponible);

        for(aAppendix.myOppItem item : oppItems) {
            item.unidade_nombre = 'Quilograma';
            item.unidade = '1';
            item.unidadDescarte = 1;
            item.lote_rebajado = '1';
            item.amount = 1.0;
        }

        SalvarDescarteAPI.Request testRequest = new SalvarDescarteAPI.Request();
        testRequest.accountId = acct.Id;
        testRequest.marca = TESTMARCA;
        testRequest.safra = TESTSAFRA;
        testRequest.cultura = TESTCULTURA;
        testRequest.userId = siteUser.Id;
        testRequest.comment = 'test comment';
        testRequest.aprobacion = false;
        if(validProducts) {
            testRequest.itemsToAdd = oppItems;
        } else {
            testRequest.itemsToAdd.add( new aAppendix.myOppItem() );
        }

        return testRequest;
    }


}
@isTest
public class SalvarReembalajeAPITest {

    final static String TESTMARCA = 'BRMX';
    final static String TESTSAFRA = '20/21';
    final static String TESTACCTNAME = 'Test Account';
    final static String REEMBALAJERECTYPE = 'Reembalaje';
    final static String TESTUNIDADE1 = 'Quilograma';
    final static String TESTUNIDADE40 = 'Saca 40Kg';


    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #13080 
     *  AUTHOR:         irina.benitez@cloudgaia.com (14-oct-21)
     **/ 
    @TestSetup
    static void makeData(){
        test.startTest();

        // Insert Categoria__c
        Categoria__c categoria = new Categoria__c(Name = 'BASICA', Mostrar_en_portal__c = true);
        insert categoria;

        // Insert Variedad__c records
        List<Variedad__c> variedadList = new List<Variedad__c>();
        variedadList.add( new Variedad__c(Name = 'Variedad 1 Test', Ativa__c = true) );
        variedadList.add( new Variedad__c(Name = 'Variedad 2 Test', Ativa__c = true) );
        insert variedadList;

        // Insert Product2 records
        List<Product2> productList = new List<Product2>();
        productList.add( new Product2(Name = 'Product 1 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[0].Id, UNIDADE__c = TESTUNIDADE1) );
        productList.add( new Product2(Name = 'Product 2 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[1].Id, UNIDADE__c = TESTUNIDADE40) );
        insert productList;

        // Insert Standard Pricebook prices
        Id stdPriceBookId = Test.getStandardPricebookId();
        List<PricebookEntry> stdPrices = new List<PricebookEntry>();
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[0].Id, UnitPrice = 10) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[1].Id, UnitPrice = 20) );
        insert stdPrices;

        // Insert Pricebook
        Pricebook2 pbRecord = new Pricebook2(Name = 'Test Pricebook', IsActive = true);
        insert pbRecord;

        // Insert Pricebook Entries with Product2.Categ__c.Name = 'BASICA' && Product2.Family = 'Royalty x Basica'
        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[0].Id, UnitPrice = 10, IsActive = true) );
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[1].Id, UnitPrice = 20, IsActive = true) );
        insert pbEntries;

        // Insert Estado__c
        Estado__c estado = new Estado__c(Name = 'Test Estado', Mostrar_en_portal__c = true);
        insert estado;

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
        Id cvbRecordType =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('CVB_Autorizada').getRecordTypeId();
        Opportunity opp = new Opportunity(  RecordTypeId = cvbRecordType, 
                                            Name = 'Test Opportunity', 
                                            AccountId = accountList[0].Id, 
                                            Pricebook2Id = pbRecord.Id, 
                                            StageName = 'AU - Autorizada', 
                                            CloseDate = System.Today(),
                                            Marca__c = TESTMARCA,
                                            Safra__c = TESTSAFRA );
        insert opp;

        // Insert OpportunityLineItems
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = productList[0].Id, PricebookEntryId = pbEntries[0].Id, Categoria__c = categoria.Id, UnitPrice = 10, Quantity = 1000, Semente_bruta__c = 1000, Estado_de_Comercializacion__c = estado.Id) );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = productList[1].Id, PricebookEntryId = pbEntries[1].Id, Categoria__c = categoria.Id, UnitPrice = 20, Quantity = 2000, Semente_bruta__c = 2000, Estado_de_Comercializacion__c = estado.Id) );
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
     *  METHOD:         saveReembalajeTestPositive 
     *  DESCRIPTION:    Test class for SalvarReembalajeAPI.saveReembalaje. Created for US #13080 
     *  AUTHOR:         irina.benitez@cloudgaia.com (14-oct-21)
     *  TEST CASE:      call method with valid creation data ==> success, returns inserted Reembalaje Id
     **/ 
    @isTest
    public static void saveReembalajeTestPositive() {

        SalvarReembalajeAPI.Request testRequest = createTestRequest(true);

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/SalvarReembalajeAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(testRequest));

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarReembalajeAPI.saveReembalaje();
        test.stopTest();

        SalvarReembalajeAPI.Response result = (SalvarReembalajeAPI.Response)JSON.deserialize(  resp.responseBody.toString(), 
                                                                                                                        SalvarReembalajeAPI.Response.class);
        System.debug('result: ' + result);
        
        Opportunity newReembalaje = [SELECT Id FROM Opportunity WHERE RecordType.Name = :REEMBALAJERECTYPE ];

        System.assert(result.status);
        System.assertEquals(Label.SalvarReembalajeAPI_Success_Message, result.message);
        System.assertEquals(newReembalaje.Id, result.oppReembalajeId);

    }

    /**
     *  METHOD:         saveReembalajeTestNegative
     *  DESCRIPTION:    Test class for SalvarReembalajeAPI.saveReembalaje. Created for US #13080 
     *  AUTHOR:         irina.benitez@cloudgaia.com (14-oct-21)
     *  TEST CASE:      call method with empty data  ==> returns default error message
     **/ 
    @isTest
    public static void saveReembalajeTestNegative() {

        SalvarReembalajeAPI.Request testRequest = createTestRequest(false);

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/SalvarReembalajeAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(testRequest));

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarReembalajeAPI.saveReembalaje();
        test.stopTest();

        SalvarReembalajeAPI.Response result = (SalvarReembalajeAPI.Response)JSON.deserialize( resp.responseBody.toString(), 
                                                                                                                        SalvarReembalajeAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assertEquals(false, result.status);
        System.assertEquals(400, resp.statusCode);
    }

    /**
     *  METHOD:         validateRequiredFieldsTestNegative
     *  DESCRIPTION:    Test class for SalvarReembalajeAPI.validateRequiredFields. Created for US #13080 
     *  AUTHOR:         irina.benitez@cloudgaia.com (14-oct-21)
     *  TEST CASE:      call method with empty data  ==> returns default error message
     **/ 
    @isTest
    public static void validateRequiredFieldsTestNegative() {


        Categoria__c categoria = [SELECT Id, Name FROM Categoria__c LIMIT 1];
        List<Variedad__c> variedades = [SELECT Id, Name FROM Variedad__c];

        List<aAppendix.myOppItem> itemsForValidation = new List<aAppendix.myOppItem>();
        for(Variedad__c variedad : variedades){
            aAppendix.myOppItem item = new aAppendix.myOppItem();
            item.categoria = categoria.Id;
            item.categoria_nombre = categoria.Name;
            item.variedad = variedad.Id;
            item.variedad_nombre = variedad.Name;
            itemsForValidation.add(item);
        }

        test.startTest();
        String result = SalvarReembalajeAPI.validateRequiredFields(itemsForValidation);
        test.stopTest();

        System.debug('result: ' + result);

        System.assert(result.contains(Label.SalvarReembalajeAPI_Unidade_Error_Message));
        System.assert(result.contains(Label.cantidadIgualCero));
        System.assert(result.contains(Label.ErrorLote));
    }

    public static SalvarReembalajeAPI.Request createTestRequest(Boolean validProducts){

        Account acct = [SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Name = :TESTACCTNAME LIMIT 1];

        SiteUser__c siteUser = [SELECT Id FROM SiteUser__c LIMIT 1];

        FactoryManejador factory = new FactoryManejador();
        ManejadorReembalagem manejador = (ManejadorReembalagem)factory.devuelveManejador('Reembalagem', acct.Id, TESTSAFRA, TESTMARCA);
        manejador.setearMapas();
        List<OpportunityLineItem> oppLineItemsReembalaje = manejador.listaProductos;
        List<aAppendix.myOppItem> oppItems = ProductsReembalajeAPI.oppLineItemJSONConverter(oppLineItemsReembalaje, manejador);

        for(aAppendix.myOppItem item : oppItems) {
            item.lote_rebajado = '1';
            item.amount = 1.0;
        }

        SalvarReembalajeAPI.Request testRequest = new SalvarReembalajeAPI.Request();
        testRequest.accountId = acct.Id;
        testRequest.marca = TESTMARCA;
        testRequest.safra = TESTSAFRA;
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
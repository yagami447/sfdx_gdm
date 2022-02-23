@isTest
public class SalvarA5APITest {

    final static String TESTMARCA = 'BRMX';
    final static String TESTSAFRA = '20/21';
    final static String TESTACCTNAME = 'Test Account';
    final static String EMPTYACCTNAME = 'Empty Test Account';
    final static String A5RECTYPE = 'Anexo V';


    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #12983 
     *  AUTHOR:         irina.benitez@cloudgaia.com (05-oct-21)
     **/ 
    @TestSetup
    static void makeData(){
        test.startTest();

        // Insert Categoria__c records
        List<Categoria__c> categoriaList = new List<Categoria__c>();
        categoriaList.add( new Categoria__c(Name = 'BASICA', Mostrar_en_portal__c = true) );
        categoriaList.add( new Categoria__c(Name = 'REBAJA') );
        insert categoriaList;

        // Insert Variedad__c records
        List<Variedad__c> variedadList = new List<Variedad__c>();
        variedadList.add( new Variedad__c(Name = 'Variedad 1 Test', Ativa__c = true) );
        variedadList.add( new Variedad__c(Name = 'Variedad 2 Test', Ativa__c = true) );
        insert variedadList;

        // Insert Product2 records
        List<Product2> productList = new List<Product2>();
        productList.add( new Product2(Name = 'Product 1 Test', IsActive = true, Categ__c = categoriaList[0].Id, Family = 'Royalty x Basica', Variedade__c = variedadList[0].Id) );
        productList.add( new Product2(Name = 'Product 2 Test', IsActive = true, Categ__c = categoriaList[0].Id, Family = 'Royalty x Basica', Variedade__c = variedadList[1].Id) );
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
        accountList.add( new Account(Name = EMPTYACCTNAME) );

        insert accountList;

        // Insert Estado__c
        Estado__c estadoDeComer = new Estado__c(Name = 'Test Estado', Mostrar_en_portal__c = true);
        insert estadoDeComer;

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
        Id anexo1RecordType =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId();
        Opportunity opp = new Opportunity(  RecordTypeId = anexo1RecordType, 
                                            Name = 'Test Opportunity', 
                                            AccountId = accountList[0].Id, 
                                            Pricebook2Id = pbRecord.Id, 
                                            StageName = 'Aprobada', 
                                            CloseDate = System.Today(),
                                            Marca__c = TESTMARCA,
                                            Safra__c = TESTSAFRA );
        insert opp;

        // Insert OpportunityLineItems
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = productList[0].Id, PricebookEntryId = pbEntries[0].Id, Categoria__c = categoriaList[0].Id, UnitPrice = 10, Quantity = 1000, Semente_Comercializada__c = 1000, Semente_uso_propio__c = 0, Estado_de_Comercializacion__c = estadoDeComer.Id) );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = productList[1].Id, PricebookEntryId = pbEntries[1].Id, Categoria__c = categoriaList[0].Id, UnitPrice = 20, Quantity = 2000, Semente_Comercializada__c = 2000, Semente_uso_propio__c = 0, Estado_de_Comercializacion__c = estadoDeComer.Id) );
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
     *  METHOD:         saveA5TestPositive 
     *  DESCRIPTION:    Test class for SalvarA5API.saveA5. Created for US #12983 
     *  AUTHOR:         irina.benitez@cloudgaia.com (05-oct-21)
     *  TEST CASE:      call method with valid creation data ==> success, returns inserted Anexo V Id
     **/ 
    @isTest
    public static void saveA5TestPositive() {

        SalvarA5API.Request testRequest = createTestRequest(true, true);

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/SalvarA5API/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(testRequest));

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarA5API.saveA5();
        test.stopTest();

        SalvarA5API.Response result = (SalvarA5API.Response)JSON.deserialize(resp.responseBody.toString(), SalvarA5API.Response.class);
        System.debug('result: ' + result);
        
        Opportunity newAnexo5 = [SELECT Id FROM Opportunity WHERE RecordType.Name = :A5RECTYPE ];

        System.assert(result.status);
        System.assertEquals(newAnexo5.Id, result.oppA5Id);

    }

    /**
     *  METHOD:         saveA5TestNegative
     *  DESCRIPTION:    Test class for SalvarA5API.saveA5. Created for US #12983 
     *  AUTHOR:         irina.benitez@cloudgaia.com (05-oct-21)
     *  TEST CASE:      call method with empty data  ==> returns default error message
     **/ 
    @isTest
    public static void saveA5TestNegative() {

        SalvarA5API.Request testRequest = createTestRequest(false, false);

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/SalvarA5API/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(testRequest));

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarA5API.saveA5();
        test.stopTest();

        SalvarA5API.Response result = (SalvarA5API.Response)JSON.deserialize(resp.responseBody.toString(), SalvarA5API.Response.class);
        System.debug('result: ' + result);
        
        System.assertEquals(false, result.status);
        System.assertEquals(Label.Anexo_V_Val_Existe_Anexo_IV, result.message);
        System.assertEquals(403, resp.statusCode);
    }


    public static SalvarA5API.Request createTestRequest(Boolean validAccount, Boolean validProducts){

        String accountName;
        if(validAccount) {
            accountName = TESTACCTNAME;
        } else {
            accountName = EMPTYACCTNAME;
        }

        Account acct = [SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Name = :accountName LIMIT 1];

        SiteUser__c siteUser = [SELECT Id FROM SiteUser__c LIMIT 1];

        SalvarA5API.Request testRequest = new SalvarA5API.Request();
        testRequest.accountId = acct.Id;
        testRequest.marca = TESTMARCA;
        testRequest.safra = TESTSAFRA;
        testRequest.aprobacion = false;
        testRequest.userId = siteUser.Id;
        testRequest.itemsToRemove = new List<aAppendix.myOppItem>();
        if(validAccount && validProducts) {
            List<OpportunityLineItem> oppLineItemsA3 = [SELECT  Id, 
                                                                OpportunityId, 
                                                                PricebookEntryId, 
                                                                PricebookEntry.Product2.Variedade__c, 
                                                                PricebookEntry.Product2.Variedade__r.Name,
                                                                Variedad__c, 
                                                                Variedad__r.Name, 
                                                                Categoria__c, 
                                                                Categoria__r.Name, 
                                                                Quantity, 
                                                                Estado_de_Comercializacion__c, 
                                                                UnitPrice, 
                                                                Semente_Comercializada__c, 
                                                                Semente_bruta__c, 
                                                                Semente_uso_propio__c
                                                        FROM OpportunityLineItem 
                                                        WHERE OpportunityId = :acct.Opportunities[0].Id 
                                                        AND Opportunity.RecordType.Name = 'Anexo III'];
            List<aAppendix.myOppItem> items =  new List<aAppendix.myOppItem>();
            for(OpportunityLineItem oppLineItem : oppLineItemsA3){
                aAppendix.myOppItem item = new aAppendix.myOppItem();
                item.variedad_nombre = oppLineItem.PricebookEntry.Product2.Variedade__r.Name;
                item.variedad = oppLineItem.PricebookEntry.Product2.Variedade__c;
                item.estado_comer_id = oppLineItem.Estado_de_Comercializacion__c;
                item.categoria_nombre = oppLineItem.Categoria__r.Name;
                item.categoria = oppLineItem.Categoria__c;
                item.amount = oppLineItem.Quantity;
                item.sem_comer = String.valueOf(oppLineItem.Quantity);
                System.debug('item: ' + item);
                items.add(item);
            }
            testRequest.itemsToAdd = items;
        } else {
            testRequest.itemsToAdd.add( new aAppendix.myOppItem() );
        }

        return testRequest;
    }


}
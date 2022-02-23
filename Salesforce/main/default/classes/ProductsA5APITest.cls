/**
* @name ProductsA5APITest
* @author Jhonny Peroza
* updated 06-10-2021
* updated 03-01-2022 by Pablo Fraquia pablo.fraquia@cloudgaia.com
*/
@isTest
public class ProductsA5APITest {

    final static String TESTMARCA = 'BRMX';
    final static String TESTSAFRA = '20/21';
    final static String TESTACCTNAME = 'Test Account';
    final static String EMPTYACCTNAME = 'Empty Account';

    @TestSetup
    static void makeData(){

        Categoria__c categoria = new Categoria__c(Name = 'BASICA');
        insert categoria;

        List<Variedad__c> variedadList = new List<Variedad__c>();
        variedadList.add( new Variedad__c(Name = 'Variedad 1 Test', Ativa__c = true) );
        variedadList.add( new Variedad__c(Name = 'Variedad 2 Test', Ativa__c = true) );
        insert variedadList;

        List<Product2> productList = new List<Product2>();
        productList.add( new Product2(Name = 'Product 1 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[0].Id) );
        productList.add( new Product2(Name = 'Product 2 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[1].Id) );
        insert productList;

        Id stdPriceBookId = Test.getStandardPricebookId();
        List<PricebookEntry> stdPrices = new List<PricebookEntry>();
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[0].Id, UnitPrice = 10) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[1].Id, UnitPrice = 20) );
        insert stdPrices;

        Pricebook2 pbRecord = new Pricebook2(Name = 'Pricebook Test', IsActive = true);
        insert pbRecord;

        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[0].Id, UnitPrice = 10, IsActive = true) );
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[1].Id, UnitPrice = 20, IsActive = true) );
        insert pbEntries;

        List<Account> accountList = new List<Account>();
        accountList.add( new Account(Name = TESTACCTNAME) );
        accountList.add( new Account(Name = EMPTYACCTNAME) );
        insert accountList;

        Id contractRecordType =  Schema.SObjectType.Contrato__c.getRecordTypeInfosByName().get(TESTMARCA).getRecordTypeId();
        Contrato__c contratoMultip = new Contrato__c(   Multiplicador__c = accountList[0].Id, 
                                                        Sociedad__c = TESTMARCA, 
                                                        Safra__c = TESTSAFRA, 
                                                        RecordTypeId = contractRecordType, 
                                                        Chegou_na_Brasmax__c = true, 
                                                        Estado__c = 'Chegou' );
        insert contratoMultip;

        Id contractItemRecordType =  Schema.SObjectType.Item_del_Contrato__c.getRecordTypeInfosByName().get('Metas x Cultivar').getRecordTypeId();
        List<Item_del_Contrato__c> contractItemList = new List<Item_del_Contrato__c>();
        contractItemList.add( new Item_del_Contrato__c( RecordTypeId = contractItemRecordType, Contrato_de_Multiplicacion__c = contratoMultip.Id, Cultivar__c = productList[0].Id) );
        contractItemList.add( new Item_del_Contrato__c( RecordTypeId = contractItemRecordType, Contrato_de_Multiplicacion__c = contratoMultip.Id, Cultivar__c = productList[1].Id) );
        insert contractItemList;

        Id anexo3RecordType =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId();
        Opportunity opp = new Opportunity(  RecordTypeId = anexo3RecordType, 
                                            Name = 'Test Opportunity', 
                                            AccountId = accountList[0].Id, 
                                            Pricebook2Id = pbRecord.Id, 
                                            StageName = 'Aprobada', 
                                            CloseDate = System.Today(),
                                            Marca__c = TESTMARCA,
                                            Safra__c = TESTSAFRA );
        insert opp;

        Id anexo4RecordType =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_IV').getRecordTypeId();
        Opportunity opp2 = new Opportunity(  RecordTypeId = anexo4RecordType, 
                                            Name = 'Test Opportunity 2', 
                                            AccountId = accountList[0].Id, 
                                            Pricebook2Id = pbRecord.Id, 
                                            StageName = 'Aprobada', 
                                            CloseDate = System.Today(),
                                            Marca__c = TESTMARCA,
                                            Safra__c = TESTSAFRA );
        insert opp2;

        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = productList[0].Id, PricebookEntryId = pbEntries[0].Id, Categoria__c = categoria.Id, UnitPrice = 10, Quantity = 1000) );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = productList[1].Id, PricebookEntryId = pbEntries[1].Id, Categoria__c = categoria.Id, UnitPrice = 20, Quantity = 2000) );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opp2.Id, Product2Id = productList[1].Id, PricebookEntryId = pbEntries[1].Id, Categoria__c = categoria.Id, UnitPrice = 20, Quantity = 2000) );
        insert oppLineItems;
    }

    @isTest
    public static void getAnexoVProducts() {

        Account testAccount = [SELECT Id FROM Account WHERE Name = :TESTACCTNAME LIMIT 1];

        ProductsA5API.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsA5API/';
        req.addParameter('accountId', testAccount.Id);
        req.addParameter('safra', TESTSAFRA);
        req.addParameter('marca', TESTMARCA);  
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsA5API.getProductsForAnexosV();
        test.stopTest();

        result = (ProductsA5API.Response)JSON.deserialize(resp.responseBody.toString(), ProductsA5API.Response.class);

        System.assertEquals(true, result.status);
        System.assertEquals(Label.ProductsA5API_Success_Message, result.message);   
    }

    @isTest
    public static void anexoVProductsNotFound() {

        Account testEmptyAccount = [SELECT Id FROM Account WHERE Name = :EMPTYACCTNAME LIMIT 1];

        ProductsA5API.response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsA5API/';
        req.addParameter('accountId', testEmptyAccount.Id);
        req.addParameter('safra', TESTSAFRA);
        req.addParameter('marca', TESTMARCA);  
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsA5API.getProductsForAnexosV();
        test.stopTest();

        result = (ProductsA5API.Response)JSON.deserialize(resp.responseBody.toString(), ProductsA5API.response.class);

        System.assertEquals(true, result.status);
        System.assertEquals(Label.ProductsA5API_Default_Error_Message, result.message);
    }
}
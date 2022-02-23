@isTest
public class ProductsDescarteAPITest {

    final static String TESTMARCA = 'BRMX';
    final static String TESTSAFRA = '20/21';
    final static String TESTCULTURA = 'Soja';
    final static String TESTACCTNAME = 'Test Account';
    final static String EMPTYACCTNAME = 'Empty Account';

    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #13041 
     *  AUTHOR:         irina.benitez@cloudgaia.com (30-sept-21)
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
        productList.add( new Product2(Name = 'Product 1 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[0].Id) );
        productList.add( new Product2(Name = 'Product 2 Test', IsActive = true, Categ__c = categoria.Id, Family = 'Royalty x Basica', Variedade__c = variedadList[1].Id) );
        insert productList;

        // Insert Standard Pricebook prices
        Id stdPriceBookId = Test.getStandardPricebookId();
        List<PricebookEntry> stdPrices = new List<PricebookEntry>();
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[0].Id, UnitPrice = 10) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[1].Id, UnitPrice = 20) );
        insert stdPrices;

        // Insert Pricebook
        Pricebook2 pbRecord = new Pricebook2(Name = 'Pricebook Test', IsActive = true);
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

        // Insert Opportunities
        Id anexo3RecordType =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId();
        Id descarteRecordType =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Descarte').getRecordTypeId();
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(new Opportunity(  RecordTypeId = anexo3RecordType, 
                                            Name = 'Test Opportunity A3', 
                                            AccountId = accountList[0].Id, 
                                            Pricebook2Id = pbRecord.Id, 
                                            StageName = 'Aprobada', 
                                            CloseDate = System.Today(),
                                            Marca__c = TESTMARCA,
                                            Safra__c = TESTSAFRA,
                                            Cultura__c = TESTCULTURA )
                        );
        opportunities.add(new Opportunity(  RecordTypeId = descarteRecordType, 
                                            Name = 'Test Opportunity Descarte', 
                                            AccountId = accountList[0].Id, 
                                            Pricebook2Id = pbRecord.Id, 
                                            StageName = 'Aprobada', 
                                            CloseDate = System.Today(),
                                            Marca__c = TESTMARCA,
                                            Safra__c = TESTSAFRA,
                                            Cultura__c = TESTCULTURA )
                );
        insert opportunities;

        // Insert OpportunityLineItems
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        // Anexo III products
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opportunities[0].Id, Product2Id = productList[0].Id, PricebookEntryId = pbEntries[0].Id, Categoria__c = categoria.Id, UnitPrice = 10, Quantity = 1000, Semente_aprovada__c = 100) );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opportunities[0].Id, Product2Id = productList[1].Id, PricebookEntryId = pbEntries[1].Id, Categoria__c = categoria.Id, UnitPrice = 20, Quantity = 2000, Semente_aprovada__c = 100) );
        // Descarte products
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opportunities[1].Id, Product2Id = productList[0].Id, PricebookEntryId = pbEntries[0].Id, Categoria__c = categoria.Id, UnitPrice = 20, Quantity = 1, Unidade_descarte__c = 'Tonelada') );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opportunities[1].Id, Product2Id = productList[1].Id, PricebookEntryId = pbEntries[1].Id, Categoria__c = categoria.Id, UnitPrice = 20, Quantity = 1, Unidade_descarte__c = 'Tonelada') );
        insert oppLineItems;

        test.stopTest();    
    }        

    /**
     *  METHOD:         getProductsDescarteTestPositive 
     *  DESCRIPTION:    Test class for ProductsDescarteAPI.getProductsDescarte. Created for US #13041 
     *  AUTHOR:         irina.benitez@cloudgaia.com (30-sept-21)
     *  TEST CASE:      call method with valid accountId, marca and safra ==> success, returns products and maps
     **/ 
    @isTest
    public static void getProductsDescarteTestPositive() {

        String accountId = [SELECT Id FROM Account WHERE Name = :TESTACCTNAME LIMIT 1].Id;
        ProductsDescarteAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsDescarteAPI/';  
        req.addParameter('accountId', accountId);
        req.addParameter('marca', TESTMARCA);
        req.addParameter('safra', TESTSAFRA);
        req.addParameter('cultura', TESTCULTURA);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsDescarteAPI.getProductsDescarte();
        test.stopTest();

        result = (ProductsDescarteAPI.Response)JSON.deserialize(resp.responseBody.toString(), ProductsDescarteAPI.Response.class);
        System.debug('result: ' + result);

        List<String> categorias = new List<String>(result.mapCategoriaByVariedad.keySet());
        
        System.assert(result.status);
        System.assertEquals(Label.ProductsDescarteAPI_Success_Message, result.message);
        System.assertEquals(2, result.productsDescarte.size());
        System.assertEquals(75, result.productsDescarte[0].sem_disponibles);
        System.assertEquals(2, result.mapVariedadById.size());
        System.assertEquals(1, result.mapCategoriaById.size());
        System.assertEquals(2, result.mapCategoriaByVariedad.size());
        System.assertEquals(1, result.mapCategoriaByVariedad.get(categorias[0]).size());

    }

    /**
     *  METHOD:         getProductsDescarteTestNegative
     *  DESCRIPTION:    Test class for ProductsDescarteAPI.getProductsDescarte. Created for US #13041 
     *  AUTHOR:         irina.benitez@cloudgaia.com (30-sept-21)
     *  TEST CASE:      call method with invalid accountId  ==> returns error message with failed data
     **/ 
    @isTest
    public static void getProductsDescarteTestNegative() {

        String accountId = [SELECT Id FROM Account WHERE Name = :EMPTYACCTNAME LIMIT 1].Id;
        ProductsDescarteAPI.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsDescarteAPI/';  
        req.addParameter('accountId', accountId);
        req.addParameter('marca', TESTMARCA);
        req.addParameter('safra', TESTSAFRA);
        req.addParameter('cultura', TESTCULTURA);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsDescarteAPI.getProductsDescarte();
        test.stopTest();

        result = (ProductsDescarteAPI.Response)JSON.deserialize(resp.responseBody.toString(), ProductsDescarteAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assertEquals(false, result.status);
        System.assertEquals(Label.Anexo_IV_Val_Existe_Anexo_III, result.message);
    }
}
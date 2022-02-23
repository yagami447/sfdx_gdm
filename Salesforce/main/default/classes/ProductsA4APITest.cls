@isTest
public class  ProductsA4APITest {
 
    final static String TESTMARCA = 'BRMX';
    final static String TESTSAFRA = '20/21';
    final static String TESTACCTNAME = 'Test Account';
    final static String EMPTYACCTNAME = 'Empty Account';

     @TestSetup
    static void makeData(){
        test.startTest();
        
        List<Categoria__c> categoriaList = new List<Categoria__c>();
        categoriaList.add(new Categoria__c(Name = 'BASICA'));
        categoriaList.add(new Categoria__c(Name = 'GENETICA'));
        insert categoriaList;

        List<Variedad__c> variedadList = new List<Variedad__c>();
        variedadList.add( new Variedad__c(Name = 'Variedad 1 Test', Ativa__c = true) );
        variedadList.add( new Variedad__c(Name = 'Variedad 2 Test', Ativa__c = true) );
        insert variedadList;

        List<Product2> productList = new List<Product2>();
        productList.add( new Product2(Name = 'Product A3 1 Test', IsActive = true, Categ__c = categoriaList[0].Id, Family = 'Royalty x Basica', Variedade__c = variedadList[0].Id) );
        productList.add( new Product2(Name = 'Product A3 2 Test', IsActive = true, Categ__c = categoriaList[0].Id, Family = 'Royalty x Basica', Variedade__c = variedadList[1].Id) );
        productList.add( new Product2(Name = 'Product Descarte 1 Test', IsActive = true, Categ__c = categoriaList[0].Id, Family = 'Royalty x Basica', Variedade__c = variedadList[0].Id) );
        productList.add( new Product2(Name = 'Product Descarte 2 Test', IsActive = true, Categ__c = categoriaList[1].Id, Family = 'Royalty x Basica', Variedade__c = variedadList[0].Id) );
        productList.add( new Product2(Name = 'Product Descarte 3 Test', IsActive = true, Categ__c = categoriaList[1].Id, Family = 'Royalty x Basica', Variedade__c = variedadList[1].Id) );
        insert productList;

        Id stdPriceBookId = Test.getStandardPricebookId();
        List<PricebookEntry> stdPrices = new List<PricebookEntry>();
        // Standard PricebookEntries for Anexo III Opp
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[0].Id, UnitPrice = 10) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[1].Id, UnitPrice = 20) );
        // Standard PricebookEntries for Descarte Opps
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[2].Id, UnitPrice = 15) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[3].Id, UnitPrice = 25) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[4].Id, UnitPrice = 35) );
        insert stdPrices;

        Pricebook2 pbRecord = new Pricebook2(Name = 'Pricebook Test', IsActive = true);
        insert pbRecord;

        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        // Custom PricebookEntries for Anexo III Opp
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[0].Id, UnitPrice = 10, IsActive = true) );
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[1].Id, UnitPrice = 20, IsActive = true) );
        // Custom PricebookEntries for Descarte Opps
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[2].Id, UnitPrice = 15, IsActive = true) );
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[3].Id, UnitPrice = 25, IsActive = true) );
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[4].Id, UnitPrice = 35, IsActive = true) );
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
        // Item_del_Contrato for Anexo III Opp
        contractItemList.add( new Item_del_Contrato__c( RecordTypeId = contractItemRecordType, Contrato_de_Multiplicacion__c = contratoMultip.Id, Cultivar__c = productList[0].Id) );
        contractItemList.add( new Item_del_Contrato__c( RecordTypeId = contractItemRecordType, Contrato_de_Multiplicacion__c = contratoMultip.Id, Cultivar__c = productList[1].Id) );
        // Item_del_Contrato for Descarte Opps
        contractItemList.add( new Item_del_Contrato__c( RecordTypeId = contractItemRecordType, Contrato_de_Multiplicacion__c = contratoMultip.Id, Cultivar__c = productList[2].Id) );
        contractItemList.add( new Item_del_Contrato__c( RecordTypeId = contractItemRecordType, Contrato_de_Multiplicacion__c = contratoMultip.Id, Cultivar__c = productList[3].Id) );
        contractItemList.add( new Item_del_Contrato__c( RecordTypeId = contractItemRecordType, Contrato_de_Multiplicacion__c = contratoMultip.Id, Cultivar__c = productList[4].Id) );
        insert contractItemList;

        List<Opportunity> opportunityList = new List<Opportunity>();
        Id anexo3RecordType =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId();
        Id descarteRecordType =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Descarte').getRecordTypeId();
        opportunityList.add(new Opportunity(RecordTypeId = anexo3RecordType, Name = 'Test A3 Opportunity', AccountId = accountList[0].Id, Pricebook2Id = pbRecord.Id, StageName = 'Aprobada', CloseDate = System.Today(), Marca__c = TESTMARCA, Safra__c = TESTSAFRA ));
        opportunityList.add(new Opportunity(RecordTypeId = descarteRecordType, Name = 'Test Descarte 1 Opportunity', AccountId = accountList[0].Id, Pricebook2Id = pbRecord.Id, StageName = 'Aprobada', CloseDate = System.Today(), Marca__c = TESTMARCA, Safra__c = TESTSAFRA ));
        opportunityList.add(new Opportunity(RecordTypeId = descarteRecordType, Name = 'Test Descarte 2 Opportunity', AccountId = accountList[0].Id, Pricebook2Id = pbRecord.Id, StageName = 'Aprobada', CloseDate = System.Today(), Marca__c = TESTMARCA, Safra__c = TESTSAFRA ));
        insert opportunityList;

        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        // OpportunityLineItems for Anexo III Opp
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opportunityList[0].Id, Product2Id = productList[0].Id, PricebookEntryId = pbEntries[0].Id, Categoria__c = categoriaList[0].Id, UnitPrice = 10, Quantity = 1000, Semente_bruta__c = 10, Semente_beneficiada__c = 20) );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opportunityList[0].Id, Product2Id = productList[1].Id, PricebookEntryId = pbEntries[1].Id, Categoria__c = categoriaList[0].Id, UnitPrice = 20, Quantity = 2000, Semente_bruta__c = 10, Semente_beneficiada__c = 20) );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opportunityList[0].Id, Product2Id = productList[1].Id, PricebookEntryId = pbEntries[1].Id, Categoria__c = categoriaList[0].Id, UnitPrice = 30, Quantity = 1000, Semente_bruta__c = 20, Semente_beneficiada__c = 30) );
        // OpportunityLineItems for Descarte Opps
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opportunityList[1].Id, Product2Id = productList[2].Id, PricebookEntryId = pbEntries[2].Id, Categoria__c = categoriaList[0].Id, UnitPrice = 20, Quantity = 1000, Unidade_Descarte__c = 'Saca 40Kg') );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opportunityList[1].Id, Product2Id = productList[3].Id, PricebookEntryId = pbEntries[3].Id, Categoria__c = categoriaList[1].Id, UnitPrice = 20, Quantity = 1000, Unidade_Descarte__c = 'Tonelada') );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opportunityList[2].Id, Product2Id = productList[4].Id, PricebookEntryId = pbEntries[4].Id, Categoria__c = categoriaList[1].Id, UnitPrice = 20, Quantity = 1000, Unidade_Descarte__c = 'Tonelada') );
        insert oppLineItems;

        test.stopTest();    
    }        

    @isTest
    public static void  getProductsAppendix4TestPositive() {

        String accountId = [SELECT Id FROM Account WHERE Name = :TESTACCTNAME LIMIT 1].Id;
        ProductsA4API.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsA4API/';  
        req.addParameter('accountId', accountId);
        req.addParameter('marca', TESTMARCA);
        req.addParameter('safra', TESTSAFRA);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsA4API.getProductsAppendix4();
        test.stopTest();

        result = ( ProductsA4API.Response)JSON.deserialize(resp.responseBody.toString(),  ProductsA4API.Response.class);
        System.debug('result: ' + result);
        
        System.assert(result.status);
        System.assertEquals(2, result.productsA4.size());

    }

    @isTest
    public static void  getProductsAppendix4TestNegative() {

        String accountId = [SELECT Id FROM Account WHERE Name = :EMPTYACCTNAME LIMIT 1].Id;
        ProductsA4API.Response result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsA4API/';  
        req.addParameter('accountId', accountId);
        req.addParameter('marca', TESTMARCA);
        req.addParameter('safra', TESTSAFRA);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsA4API.getProductsAppendix4();
        test.stopTest();

        result = (ProductsA4API.Response)JSON.deserialize(resp.responseBody.toString(), ProductsA4API.Response.class);

        System.assertEquals(false, result.status);
    }
    
    @isTest
    public static void  getMapDescarteByVariedadAndCategoriaTest() {

        Account testAccount = [ SELECT  Id, (SELECT Id FROM Opportunities WHERE StageName = 'Aprobada' AND RecordType.Name = 'Descarte' ORDER BY Name) 
                                FROM Account 
                                WHERE Name = :TESTACCTNAME 
                                LIMIT 1];

        String descarteOppId = testAccount.Opportunities[1].Id;
        
        OpportunityLineItem descarteItem = [SELECT Id, PricebookEntry.Product2.Variedade__c, Categoria__c, Quantity, Unidade_descarte__c 
                                            FROM OpportunityLineItem 
                                            WHERE OpportunityId = :descarteOppId
                                            LIMIT 1];

        String variedad = descarteItem.PricebookEntry.Product2.Variedade__c;
        String categoria = descarteItem.Categoria__c;
        Double sacasDescarte =  Double.valueOf((descarteItem.Quantity * ProductsDescarteAPI.MAPNAMEBYUNIDAD.get(descarteItem.Unidade_descarte__c) / 40 ));

        Map<String, Map<String, Double>> descarteByVariedadAndCategoria;                                    

        test.startTest();
        descarteByVariedadAndCategoria = ProductsA4API.getMapDescarteByVariedadAndCategoria(testAccount.Id, TESTSAFRA, TESTMARCA);
        test.stopTest();

        System.assertEquals(sacasDescarte, descarteByVariedadAndCategoria.get(variedad).get(categoria));
    }
}
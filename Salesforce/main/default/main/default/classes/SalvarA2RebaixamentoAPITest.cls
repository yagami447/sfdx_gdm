@isTest
public class SalvarA2RebaixamentoAPITest {

    final static String TESTMARCA = 'BRMX';
    final static String TESTSAFRA = '20/21';
    final static String TESTEPOCA = 'Verão';
    final static String TESTACCTNAME = 'Test Account';
    final static String A2REBAJARECTYPE = 'Anexo II Rebaixamento Sacas';


    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. Created for US #13034 
     *  AUTHOR:         irina.benitez@cloudgaia.com (23-sept-21)
     **/ 
    @TestSetup
    static void makeData(){
        test.startTest();

        // Insert Categoria__c records
        List<Categoria__c> categoriaList = new List<Categoria__c>();
        categoriaList.add( new Categoria__c(Name = 'BASICA', Mostrar_en_portal__c = true) );
        categoriaList.add( new Categoria__c(Name = 'REBAJA', Mostrar_en_portal__c = true) );
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
        Id anexo1RecordType =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoII').getRecordTypeId();
        Opportunity opp = new Opportunity(  RecordTypeId = anexo1RecordType, 
                                            Name = 'Test Opportunity', 
                                            AccountId = accountList[0].Id, 
                                            Pricebook2Id = pbRecord.Id, 
                                            StageName = 'Aprobada', 
                                            CloseDate = System.Today(),
                                            Epoca_de_Plantio__c = TESTEPOCA,
                                            Marca__c = TESTMARCA,
                                            Safra__c = TESTSAFRA );
        insert opp;

        // Insert OpportunityLineItems
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = productList[0].Id, PricebookEntryId = pbEntries[0].Id, Categoria__c = categoriaList[0].Id, UnitPrice = 10, Quantity = 1000) );
        oppLineItems.add( new OpportunityLineItem(OpportunityId = opp.Id, Product2Id = productList[1].Id, PricebookEntryId = pbEntries[1].Id, Categoria__c = categoriaList[0].Id, UnitPrice = 20, Quantity = 2000) );
        insert oppLineItems;

        test.stopTest();    
    }        

    /**
     *  METHOD:         saveA2RebaixamentoTestPositive 
     *  DESCRIPTION:    Test class for SalvarA2RebaixamentoAPI.saveA2Rebaixamento. Created for US #13034 
     *  AUTHOR:         irina.benitez@cloudgaia.com (23-sept-21)
     *  TEST CASE:      call method with valid creation data ==> success, returns inserted Anexo II Rebaja Id
     **/ 
    @isTest
    public static void saveA2RebaixamentoTestPositive() {

        SalvarA2RebaixamentoAPI.Request testRequest = createTestRequest(true);

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/SalvarA2RebaixamentoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(testRequest));

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarA2RebaixamentoAPI.saveA2Rebaixamento();
        test.stopTest();

        SalvarA2RebaixamentoAPI.Response result = (SalvarA2RebaixamentoAPI.Response)JSON.deserialize(  resp.responseBody.toString(), 
                                                                                                                        SalvarA2RebaixamentoAPI.Response.class);
        System.debug('result: ' + result);
        
        Opportunity newAnexo2Rebaja = [SELECT Id FROM Opportunity WHERE RecordType.Name = :A2REBAJARECTYPE ];

        System.assert(result.status);
        System.assertEquals(newAnexo2Rebaja.Id, result.oppA2RebId);

    }

    /**
     *  METHOD:         saveA2RebaixamentoTestNegative
     *  DESCRIPTION:    Test class for SalvarA2RebaixamentoAPI.saveA2Rebaixamento. Created for US #13034 
     *  AUTHOR:         irina.benitez@cloudgaia.com (23-sept-21)
     *  TEST CASE:      call method with empty data  ==> returns default error message
     **/ 
    @isTest
    public static void saveA2RebaixamentoTestNegative() {

        SalvarA2RebaixamentoAPI.Request testRequest = createTestRequest(false);

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/SalvarA2RebaixamentoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(testRequest));

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarA2RebaixamentoAPI.saveA2Rebaixamento();
        test.stopTest();

        SalvarA2RebaixamentoAPI.Response result = (SalvarA2RebaixamentoAPI.Response)JSON.deserialize( resp.responseBody.toString(), 
                                                                                                                        SalvarA2RebaixamentoAPI.Response.class);
        System.debug('result: ' + result);
        
        System.assertEquals(false, result.status);
        System.assertEquals(400, resp.statusCode);
    }


    public static SalvarA2RebaixamentoAPI.Request createTestRequest(Boolean validProducts){

        Account acct = [SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Name = :TESTACCTNAME LIMIT 1];

        SalvarA2RebaixamentoAPI.Request testRequest = new SalvarA2RebaixamentoAPI.Request();
        testRequest.accountId = acct.Id;
        testRequest.marca = TESTMARCA;
        testRequest.safra = TESTSAFRA;
        testRequest.a2aRebajarId = acct.Opportunities[0].Id;
        testRequest.a2aRebajarEpoca = TESTEPOCA;
        testRequest.aprobacion = true;
        if(validProducts) {
            List<Categoria__c> categorias = [SELECT Id, Name FROM Categoria__c ORDER BY Name];
            List<Variedad__c> variedades = [SELECT Id, Name FROM Variedad__c ORDER BY Name];
    
            List<aAppendix.myOppItem> oppItems = new List<aAppendix.myOppItem>();

            for(Variedad__c variedad : variedades) {
                aAppendix.myOppItem item = new aAppendix.myOppItem();
                item.variedad = variedad.Id;
                item.sem_rebajada = '10';
                item.categoria_a_rebajar_id = variedades[1].Id;
                item.categoria = variedades[0].Id;
            }

            testRequest.items = oppItems;

        } else {
            testRequest.items.add( new aAppendix.myOppItem() );
        }

        return testRequest;
    }

}
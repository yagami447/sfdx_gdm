@isTest
public class ProductsRebaixamentoAPITest 
{

    @TestSetup
    static void makeData() {
        test.startTest();
        
        // Insert Categoria__c
        Categoria__c categoria = new Categoria__c(Name = 'BASICA');
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
        pbEntries.add( new PricebookEntry(Pricebook2Id = pbRecord.Id, Product2Id = productList[1].Id, UnitPrice = 20, IsActive = true) );
        insert pbEntries;

        // Insert Account
        Account acc = new Account(Name = 'test');
        insert acc;
        
        // Insert Opportunity
        Id anexo2RecordType =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoII').getRecordTypeId();
        Opportunity opp = new Opportunity(  RecordTypeId = anexo2RecordType, 
                                            Name = 'Test Opportunity', 
                                            AccountId = acc.Id, 
                                            Pricebook2Id = pbRecord.Id, 
                                            StageName = 'Aprobada', 
                                            CloseDate = System.Today(),
                                            Epoca_de_Plantio__c = 'Inverno',
                                            Marca__c = 'BRMX',
                                            Safra__c = '19/20' );
        insert opp;
		       
        // Insert PriceBookEntry
        PriceBookEntry stdPriceBookEntry = new PriceBookEntry();
        stdPriceBookEntry.Product2Id= productList[0].Id; //Product Id
        stdPriceBookEntry.Pricebook2Id= pbRecord.Id;
        stdPriceBookEntry.UnitPrice=2000;
        stdPriceBookEntry.IsActive=true;
        
        insert stdPriceBookEntry;
        
        // Insert OpportunityLineItem
        OpportunityLineItem oppLineItem = new OpportunityLineItem( OpportunityId = opp.Id,
                                                                   Quantity = 1,
                                                                   TotalPrice = 3,
                                                                   PricebookEntryId = stdPriceBookEntry.Id);
        insert oppLineItem;
        
        test.stopTest();    
    }        

    @isTest
    public static void getProductsRebaixamentoTestPositive() {

        String opportunityId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        ProductsRebaixamentoAPI.response result;
        
        String OpportunityLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1].Id;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsRebaixamentoAPI/';
        req.addParameter('opportunityId', opportunityId);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsRebaixamentoAPI.getDataAppendix2Rebaixamento();
        test.stopTest();

        result = (ProductsRebaixamentoAPI.response)JSON.deserialize(resp.responseBody.toString(), ProductsRebaixamentoAPI.response.class);
        
        System.assertEquals(true, result.status);

    }
}
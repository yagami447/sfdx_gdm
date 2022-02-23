@IsTest
public class aAppendixTest {
	/*
    final static String TESTMARCA = 'BRMX';
    final static String TESTSAFRA = '20/21';
    final static String TESTACCTNAME = 'Test Account';
    final static String TESTOPPNAME = 'Test Opportunity';
    final static String REEMBALAJERECTYPE = 'Reembalaje';
    final static String TESTUNIDADE1 = 'Quilograma';
    final static String TESTUNIDADE40 = 'Saca 40Kg';
    
    
    @testSetup
    static void setup(){
        
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
                                            Name = TESTOPPNAME, 
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
                                
    }
    
    @isTest
    public static void armarLineItemTestPositive() {
        
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = :TESTOPPNAME LIMIT 1];
        
        OpportunityLineItem oppLineItem = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :opp.Id LIMIT 1];
        
        test.startTest();
        aAppendix.armarWrapper(oppLineItem);
        test.stopTest();
   
    }*/
}
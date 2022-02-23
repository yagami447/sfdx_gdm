@isTest
public class OpportunityLineItemTriggerXappiaTest {

    /**
     *  METHOD:         makeData 
     *  DESCRIPTION:    Test Setup for Class. 
     *  AUTHOR:         irina.benitez@cloudgaia.com (15-sept-21)
     **/ 
    @TestSetup
    static void makeData(){
        test.startTest();
        // Insert 2 Product2
        List<Product2> productList = new List<Product2>();
        productList.add( new Product2(Name = 'Product 1 Test', CANTIDAD_SUB_UNIDAD__c = '40', IsActive = true) );
        productList.add( new Product2(Name = 'Product 2 Test', CANTIDAD_SUB_UNIDAD__c = '40', IsActive = true) );
        insert productList;

        // Insert Standard Pricebook prices
        Id stdPriceBookId = Test.getStandardPricebookId();
        List<PricebookEntry> stdPrices = new List<PricebookEntry>();
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[0].Id, UnitPrice = 0) );
        stdPrices.add( new PricebookEntry(Pricebook2Id = stdPriceBookId, Product2Id = productList[1].Id, UnitPrice = 0) );
        insert stdPrices;

        // Insert Pricebook
        Pricebook2 pbRecord = new Pricebook2(Name = 'Pricebook Test', IsActive = true);
        insert pbRecord;

        // Insert Price Book Entry Fixed-Price
        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        PricebookEntry pbeFixed = new PricebookEntry();
        pbeFixed.IsActive = true;
        pbeFixed.Pricebook2Id = pbRecord.Id;
        pbeFixed.Product2Id = productList[0].Id;
        pbeFixed.UnitPrice = 10;
        pbeFixed.Fixed_Price__c = true;
        pbeFixed.First_Price__c = 10;
        pbeFixed.Second_Price__c = 9;
        pbeFixed.Third_Price__c = 8;
        pbeFixed.Fourth_Price__c = 7;
        pbeFixed.Max_Kg_First_Price__c = 20000;     // 20.000 Kg = 500 sacas
        pbeFixed.Max_Kg_Second_Price__c = 50000;    // 50.000 Kg = 1250 sacas
        pbeFixed.Max_Kg_Third_Price__c = 80000;     // 80.000 Kg = 2000 sacas
        pbEntries.add(pbeFixed);
        
        // Insert Price Book Entry non-fixed-price
        PricebookEntry pbeNonFixed = new PricebookEntry();
        pbeNonFixed.IsActive = true;
        pbeNonFixed.Pricebook2Id = pbRecord.Id;
        pbeNonFixed.Product2Id = productList[1].Id;
        pbeNonFixed.UnitPrice = 40;
        pbEntries.add(pbeNonFixed);
        insert pbEntries;

        // Insert Account
        Account acct = new Account(Name = 'Test Account' );
        insert acct;

        // Insert Opportunity
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', AccountId = acct.Id, Pricebook2Id = pbRecord.Id, StageName = 'Edición', CloseDate = System.Today() );
        insert opp;
        
        test.stopTest();    
    }        

    /**
     *  METHOD:         setFixedPriceProductsTestInsertPositive 
     *  DESCRIPTION:    Test class for OpportunityLineItemTriggerXappiaHelper.setFixedPriceProducts. Created for US #12786 
     *  AUTHOR:         irina.benitez@cloudgaia.com (15-sept-21)
     *  TEST CASE:      Add a fixed-price product to an Opportunity ==> created OppLineItem with fixed-price settings
     **/ 
    @isTest
    public static void setFixedPriceProductsTestInsertPositive() {

        Opportunity opp = [SELECT Id, Name, AccountId, Pricebook2Id FROM Opportunity WHERE Name = 'Test Opportunity'];

        Pricebook2 pricebookWithEntries  = [SELECT  Id, Name, 
                                                    (SELECT Id, Name, First_Price__c 
                                                    FROM PricebookEntries 
                                                    WHERE Fixed_Price__c = true) 
                                            FROM Pricebook2 
                                            WHERE Id = :opp.Pricebook2Id ];

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.PricebookEntryId = pricebookWithEntries.PricebookEntries[0].Id;
        oppLineItem.UnitPrice = 50;     // Price selected by user
        oppLineItem.Quantity = 250;     // 10.000 Kg --> First Price

        test.startTest();
        insert oppLineItem;
        test.stopTest();

        OpportunityLineItem result = [SELECT Id, Name, UnitPrice, Fixed_Price__c, Kg_de_Produto__c FROM OpportunityLineItem WHERE Id = :oppLineItem.Id]; 

        System.assertEquals(pricebookWithEntries.PricebookEntries[0].First_Price__c , result.UnitPrice);
        System.assertEquals(10000 , result.Kg_de_Produto__c);
        System.assert(result.Fixed_Price__c);

    }

    /**
     *  METHOD:         setFixedPriceProductsTestUpdatePositive 
     *  DESCRIPTION:    Test class for OpportunityLineItemTriggerXappiaHelper.setFixedPriceProducts. Created for US #12786 
     *  AUTHOR:         irina.benitez@cloudgaia.com (15-sept-21)
     *  TEST CASE:      update a fixed-price product to an Opportunity ==> updated OppLineItem with fixed-price settings
     **/ 
    @isTest
    public static void setFixedPriceProductsTestUpdatePositive() {

        Opportunity opp = [SELECT Id, Name, AccountId, Pricebook2Id FROM Opportunity WHERE Name = 'Test Opportunity'];

        Pricebook2 pricebookWithEntries  = [SELECT  Id, Name, 
                                                    (SELECT Id, Name, Third_Price__c 
                                                    FROM PricebookEntries 
                                                    WHERE Fixed_Price__c = true) 
                                            FROM Pricebook2 
                                            WHERE Id = :opp.Pricebook2Id ];

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.PricebookEntryId = pricebookWithEntries.PricebookEntries[0].Id;
        oppLineItem.UnitPrice = 50;     // Price selected by user
        oppLineItem.Quantity = 250;     // 10.000 Kg --> First Price
        insert oppLineItem;

        oppLineItem.Quantity = 1500;    // 60.000 Kg --> Third Price

        test.startTest();
        update oppLineItem;
        test.stopTest();

        OpportunityLineItem result = [SELECT Id, Name, UnitPrice, Fixed_Price__c, Kg_de_Produto__c FROM OpportunityLineItem WHERE Id = :oppLineItem.Id]; 

        System.assertEquals(pricebookWithEntries.PricebookEntries[0].Third_Price__c , result.UnitPrice);
        System.assertEquals(60000 , result.Kg_de_Produto__c);
        System.assert(result.Fixed_Price__c);
    }


    /**
     *  METHOD:         setFixedPriceProductsTestNegative
     *  DESCRIPTION:    Test class for OpportunityLineItemTriggerXappiaHelper.setFixedPriceProducts. Created for US #12786 
     *  AUTHOR:         irina.benitez@cloudgaia.com (15-sept-21)
     *  TEST CASE:      Add a non-fixed-price product to an Opportunity ==> created OppLineItem with price selected by user
     **/ 
    @isTest
    public static void setFixedPriceProductsTestNegative() {

        Opportunity opp = [SELECT Id, Name, AccountId, Pricebook2Id FROM Opportunity WHERE Name = 'Test Opportunity'];

        Pricebook2 pricebookWithEntries  = [SELECT  Id, Name, 
                                                    (SELECT Id, Name, First_Price__c 
                                                    FROM PricebookEntries 
                                                    WHERE Fixed_Price__c = false) 
                                            FROM Pricebook2 
                                            WHERE Id = :opp.Pricebook2Id ];

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.PricebookEntryId = pricebookWithEntries.PricebookEntries[0].Id;
        oppLineItem.UnitPrice = 50;     // Price selected by user
        oppLineItem.Quantity = 250;     

        test.startTest();
        insert oppLineItem;
        test.stopTest();

        OpportunityLineItem result = [SELECT Id, Name, UnitPrice, Fixed_Price__c, Kg_de_Produto__c FROM OpportunityLineItem WHERE Id = :oppLineItem.Id]; 

        System.assertEquals(50 , result.UnitPrice);
        System.assertEquals(10000 , result.Kg_de_Produto__c);
        System.assertEquals(false, result.Fixed_Price__c);
    }
}
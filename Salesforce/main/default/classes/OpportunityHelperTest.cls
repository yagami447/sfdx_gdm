/**
* @name OpportunityHelperTest
* @author Jhonny Peroza
* updated 02-12-2021
*/
@isTest 
public class OpportunityHelperTest {

    @isTest 
    public static void testVerifyOpportunity(){

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Requisicao_de_compra__c> requisicaoList = TestDataFactoryMilho.createRequisitions(businessList);
        List<Variedad__c> varietyList = TestDataFactoryMilho.createVariety(1);
        List<Produto_de_Requisicao__c> productRequisitionList = TestDataFactoryMilho.createRequisitionsProducts(requisicaoList, varietyList);
        List<Opportunity> opportunitiesList = TestDataFactoryMilho.createOpportunities(accountsList, 1);

        Test.startTest();
        OpportunityHelper.verifyOpportunity(opportunitiesList);
        Test.stopTest();

    }

    @isTest 
    public static void testOpportunityAndItems(){

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Requisicao_de_compra__c> requisicaoList = TestDataFactoryMilho.createRequisitionsAprovada(businessList);
        List<Categoria__c> categoryList = TestDataFactoryMilho.createCategory(1);
        List<Variedad__c> varietyList = TestDataFactoryMilho.createVariety(1);
        List<Product2> productList = TestDataFactoryMilho.createProduct(1, categoryList, varietyList);
        List<PriceBookEntry> priceBookList = TestDataFactoryMilho.createPriceBookEntry(1, productList);
        List<Produto_de_Requisicao__c> productRequisitionList = TestDataFactoryMilho.createRequisitionsProducts(requisicaoList, varietyList);
        List<Opportunity> opportunitiesList = TestDataFactoryMilho.createOpportunitiesPBComercial(1, accountsList, requisicaoList);
        List<OpportunityLineItem> opportunityLineItemList = TestDataFactoryMilho.createOpportunityLineItems(opportunitiesList, productList, productRequisitionList);

        Test.startTest();
        OpportunityHelper.verifyOpportunity(opportunitiesList);

        List<Opportunity> opportunityRows = [SELECT Id, Name
                                                FROM Opportunity];

        List<OpportunityLineItem> opportunityLineItemsRows = [SELECT Id, Quantidade_de_sementes__c
                                                                FROM OpportunityLineItem];

        Test.stopTest();

        System.assert(opportunityRows.size() > 0);
        System.assert(opportunityRows[0].Name != null);
        System.assert(opportunityLineItemsRows.size() > 0);

    }

    @isTest
    public static void testDeactivateOpportunity() {

        String result;
        Id idOpp;

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Requisicao_de_compra__c> requisicaoList = TestDataFactoryMilho.createRequisitionsAprovada(businessList);
        List<Categoria__c> categoryList = TestDataFactoryMilho.createCategory(1);
        List<Variedad__c> varietyList = TestDataFactoryMilho.createVariety(1);
        List<Product2> productList = TestDataFactoryMilho.createProduct(1, categoryList, varietyList);
        List<PriceBookEntry> priceBookList = TestDataFactoryMilho.createPriceBookEntry(1, productList);
        List<Produto_de_Requisicao__c> productRequisitionList = TestDataFactoryMilho.createRequisitionsProducts(requisicaoList, varietyList);
        List<Opportunity> opportunitiesList = TestDataFactoryMilho.createOpportunitiesPBComercial(1, accountsList, requisicaoList);
        List<OpportunityLineItem> opportunityLineItemList = TestDataFactoryMilho.createOpportunityLineItems(opportunitiesList, productList, productRequisitionList);

        idOpp = Id.valueOf(opportunitiesList[0].Id);

        Test.startTest();
        result = OpportunityHelper.deactivateOpportunity(idOpp);
        

        List<Opportunity> opportunityRows = [SELECT Id, Activa__c
                                                FROM Opportunity];

        Test.stopTest();
        System.assert(result != null);
        System.assert(opportunityRows[0].Activa__c == false);

    }

    @isTest
    public static void testSelectOpportunityLineItems() {

        Id idOpp;
        List<String> fields = new List <String> {'Variedad__c','Variedad__r.Name','Embalagem__c','Tratamento__c','Quantidade__c'}; 
        List<OpportunityLineItem> result;

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Requisicao_de_compra__c> requisicaoList = TestDataFactoryMilho.createRequisitionsAprovada(businessList);
        List<Categoria__c> categoryList = TestDataFactoryMilho.createCategory(1);
        List<Variedad__c> varietyList = TestDataFactoryMilho.createVariety(1);
        List<Product2> productList = TestDataFactoryMilho.createProduct(1, categoryList, varietyList);
        List<PriceBookEntry> priceBookList = TestDataFactoryMilho.createPriceBookEntry(1, productList);
        List<Produto_de_Requisicao__c> productRequisitionList = TestDataFactoryMilho.createRequisitionsProducts(requisicaoList, varietyList);
        List<Opportunity> opportunitiesList = TestDataFactoryMilho.createOpportunitiesPBComercial(1, accountsList, requisicaoList);
        List<OpportunityLineItem> opportunityLineItemList = TestDataFactoryMilho.createOpportunityLineItems(opportunitiesList, productList, productRequisitionList);

        idOpp = Id.valueOf(opportunitiesList[0].Id);

        Test.startTest();
        result = OpportunityHelper.selectOpportunityLineItems(idOpp, fields);
        Test.stopTest();

        System.assert(result != null);

    }

    @isTest
    public static void testVerifyOpportunityLineItemsDelete() {

        List<OpportunityLineItem> listUpsert = new List<OpportunityLineItem>();
        List<OpportunityLineItem> listDelete = new List<OpportunityLineItem>();

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Requisicao_de_compra__c> requisicaoList = TestDataFactoryMilho.createRequisitionsAprovada(businessList);
        List<Categoria__c> categoryList = TestDataFactoryMilho.createCategory(1);
        List<Variedad__c> varietyList = TestDataFactoryMilho.createVariety(1);
        List<Product2> productList = TestDataFactoryMilho.createProduct(1, categoryList, varietyList);
        List<PriceBookEntry> priceBookList = TestDataFactoryMilho.createPriceBookEntry(1, productList);
        List<Produto_de_Requisicao__c> productRequisitionList = TestDataFactoryMilho.createRequisitionsProducts(requisicaoList, varietyList);
        List<Opportunity> opportunitiesList = TestDataFactoryMilho.createOpportunitiesPBComercial(1, accountsList, requisicaoList);
        List<OpportunityLineItem> opportunityLineItemList = TestDataFactoryMilho.createOpportunityLineItems(opportunitiesList, productList, productRequisitionList);

        listDelete = opportunityLineItemList;

        Test.startTest();
        OpportunityHelper.verifyOpportunityLineItems(listUpsert, listDelete);
        Test.stopTest();

    }

    @isTest
    public static void testVerifyOpportunityLineItemsUpsert() {

        List<OpportunityLineItem> listUpsert = new List<OpportunityLineItem>();
        List<OpportunityLineItem> listDelete = new List<OpportunityLineItem>();

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Requisicao_de_compra__c> requisicaoList = TestDataFactoryMilho.createRequisitionsAprovada(businessList);
        List<Categoria__c> categoryList = TestDataFactoryMilho.createCategory(1);
        List<Variedad__c> varietyList = TestDataFactoryMilho.createVariety(1);
        List<Product2> productList = TestDataFactoryMilho.createProduct(1, categoryList, varietyList);
        List<PriceBookEntry> priceBookList = TestDataFactoryMilho.createPriceBookEntry(1, productList);
        List<Produto_de_Requisicao__c> productRequisitionList = TestDataFactoryMilho.createRequisitionsProducts(requisicaoList, varietyList);
        List<Opportunity> opportunitiesList = TestDataFactoryMilho.createOpportunitiesPBComercial(1, accountsList, requisicaoList);
        List<OpportunityLineItem> opportunityLineItemList = TestDataFactoryMilho.createOpportunityLineItems(opportunitiesList, productList, productRequisitionList);

        listUpsert = opportunityLineItemList;

        Test.startTest();
        OpportunityHelper.verifyOpportunityLineItems(listUpsert, listDelete);
        Test.stopTest();

    }

}
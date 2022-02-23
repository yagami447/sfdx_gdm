/**
* @name RequisitionProductHelperTest
* @author Jhonny Peroza
* updated 21-10-2021
*/
@isTest
public class RequisitionProductHelperTest {

    @isTest 
    public static void testUpdateRequisitionProductTypeMultiplicador(){

        List<Produto_de_Requisicao__c> newProductRequisitionList = new List<Produto_de_Requisicao__c>();

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Requisicao_de_compra__c> requisicaoList = TestDataFactoryMilho.createRequisitionsMultiplicador(businessList);
        List<Variedad__c> varietyList = TestDataFactoryMilho.createVariety(1);
        List<Produto_de_Requisicao__c> requisitionProductList = TestDataFactoryMilho.createRequisitionsProducts(requisicaoList, varietyList);

        Test.startTest();
        RequisitionProductHelper.verifyRequisitionProduct(requisitionProductList);
        Test.stopTest();

        List<Produto_de_Requisicao__c> productRequisitionRows = [SELECT Name 
                                                                     FROM Produto_de_Requisicao__c];

        System.assert(productRequisitionRows.size() > 0);
        System.assert(productRequisitionRows[0].Name != null);

    }

    @isTest 
    public static void testUpdateRequisitionProductTypeGerente(){

        List<Produto_de_Requisicao__c> newProductRequisitionList = new List<Produto_de_Requisicao__c>();

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Requisicao_de_compra__c> requisicaoList = TestDataFactoryMilho.createRequisitions(businessList);
        List<Variedad__c> varietyList = TestDataFactoryMilho.createVariety(1);
        List<Produto_de_Requisicao__c> requisitionProductList = TestDataFactoryMilho.createRequisitionsProducts(requisicaoList, varietyList);

        Test.startTest();
        RequisitionProductHelper.verifyRequisitionProduct(requisitionProductList);
        Test.stopTest();

        List<Produto_de_Requisicao__c> productRequisitionRows = [SELECT Name 
                                                                     FROM Produto_de_Requisicao__c];

        System.assert(productRequisitionRows.size() > 0);
        System.assert(productRequisitionRows[0].Name != null);

    }

}
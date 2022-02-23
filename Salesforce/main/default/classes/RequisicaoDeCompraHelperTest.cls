/**
* @name RequisicaoDeCompraHelperTest
* @author Jhonny Peroza
* updated 21-10-2021
*/
@isTest
public class RequisicaoDeCompraHelperTest {

    @isTest 
    public static void testUpdateRequisicaoDeCompra(){

        List<Requisicao_de_compra__c> newRequisicaoList = new List<Requisicao_de_compra__c>();

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Requisicao_de_compra__c> requisicaoList = TestDataFactoryMilho.createRequisitions(businessList);

        Id queryRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByName().get('Milho').getRecordTypeId();

        for(Requisicao_de_compra__c req : requisicaoList) {
            for(Negocio_por_Conta__c neg : businessList) {
                Requisicao_de_compra__c upsertRequisicao = new Requisicao_de_compra__c();
                upsertRequisicao.Id = req.Id;
                upsertRequisicao.Tipo__c = 'Gerente Comercial';
                upsertRequisicao.Marca__c = neg.Marca__c;
                upsertRequisicao.Regiao_Comercial__c = neg.Region_Comercial__c;
                upsertRequisicao.Cultura__c = neg.Cultura__c;
                upsertRequisicao.Multiplicador__c = neg.Conta__c;
                upsertRequisicao.Supervisor__c = neg.Supervidor__c;
                upsertRequisicao.OwnerId = neg.Supervidor__c;
                upsertRequisicao.Aprovador__c = neg.Supervidor__c;
                upsertRequisicao.OwnerId = UserInfo.getUserId();
                newRequisicaoList.add(upsertRequisicao);
            }
        }

        Test.startTest();
        upsert newRequisicaoList;
        Test.stopTest();

        List<Requisicao_de_compra__c> requisitionList = [SELECT Id, Cultura__c, Aprovador__c, Supervisor__c
                                                            FROM Requisicao_de_compra__c 
                                                                WHERE Id =: newRequisicaoList[0].Id];

        System.assert(requisitionList.size() > 0);
        System.assert(requisitionList[0].Cultura__c != null);
        System.assert(requisitionList[0].Aprovador__c != null);
        System.assert(requisitionList[0].Supervisor__c != null);

    }

    @isTest 
    public static void testRequisicaoDeCompraMultiplicador(){

        List<Requisicao_de_compra__c> newRequisicaoList = new List<Requisicao_de_compra__c>();

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Requisicao_de_compra__c> requisicaoList = TestDataFactoryMilho.createRequisitionsMultiplicador(businessList);
        List<User> userList = TestDataFactoryMilho.createUserRequisition(1);

        Test.startTest();
        RequisicaoDeCompraHelper.setParent(requisicaoList);
        Test.stopTest();

        List<Requisicao_de_compra__c> requisitionList = [SELECT Id, Cultura__c, Tipo__c, Responsavel_y_Tipo__c, Requisicao_de_compra__c
                                                            FROM Requisicao_de_compra__c];

        System.assert(requisitionList[0].Responsavel_y_Tipo__c != null);

    }

}
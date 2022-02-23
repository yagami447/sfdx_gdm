/**
* @name BusinessHelperTest
* @author Jhonny Peroza
* updated 21-10-2021
*/
@isTest
public class BusinessHelperTest {

    @isTest 
    public static void testUpdateBusiness(){

        List<Negocio_por_Conta__c> newBusinessList = new List<Negocio_por_Conta__c>();

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(2);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);

        for(Negocio_por_Conta__c bus : businessList) {
            Negocio_por_Conta__c upsertNegocio = new Negocio_por_Conta__c();
            upsertNegocio.Id = bus.Id;
            upsertNegocio.Region_Comercial__c = 'REGION 2';
            upsertNegocio.Marca__c = 'DSEM';
            upsertNegocio.Cultura__c = 'MILHO';
            upsertNegocio.Supervidor__c = UserInfo.getUserId();
            upsertNegocio.Name = bus.Conta__c + '-' + bus.Cultura__c + '-' + bus.Marca__c + '-' + bus.Supervidor__c;
            newBusinessList.add(upsertNegocio);
        }
    
        Test.startTest();
        upsert newBusinessList;
        Test.stopTest();

        List<Negocio_por_Conta__c> negociosList = [SELECT Name 
                                                       FROM Negocio_por_Conta__c 
                                                         WHERE Id =: newBusinessList[0].Id];

        System.assert(negociosList.size() > 0);
        System.assert(negociosList[0].Name != null);

    }

}
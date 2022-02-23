/**
* @name ContractHelperTest
* @author Jhonny Peroza
* updated 21-10-2021
*/
@isTest
public class ContractHelperTest {

    @isTest 
    public static void testUpdateContract(){

        List<Contract> newContractList = new List<Contract>();

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Contract> contractList = TestDataFactoryMilho.createContract(businessList);

        List<RecordType> queryRecord = [SELECT Id, Name 
                                            FROM RecordType 
                                               WHERE Name = 'Macro Milho' LIMIT 1];

        for(Contract con : contractList) {
            Contract upsertContract = new Contract();
            upsertContract.Id = con.Id;
            upsertContract.RecordTypeId = queryRecord[0].Id;
            upsertContract.Status = 'Pendente de Impressão';
            upsertContract.Gerenciador__c = UserInfo.getUserId();
            upsertContract.Gerenciador_Supervisor__c = UserInfo.getUserId();
            newContractList.add(upsertContract);
        }

        Test.startTest();
        upsert newContractList;
        Test.stopTest();

        List<Contract> contratoList = [SELECT Id, Status, Gerenciador__c, Gerenciador_Supervisor__c 
                                           FROM Contract 
                                              WHERE Id =: newContractList[0].Id];

        System.assert(contratoList.size() > 0);
        System.assert(contratoList[0].Gerenciador__c != null);
        System.assert(contratoList[0].Gerenciador_Supervisor__c != null);
        System.assertEquals(contratoList[0].Status, 'Pendente de Impressão');

    }

}
/**
* @name BusinessHelper
* @author Jhonny Peroza
* updated 10-09-2021
*/
public class BusinessHelper {

    // updateBusiness
    
    public static void updateBusiness(List<Negocio_por_Conta__c> businessList) {

        List<Negocio_por_Conta__c> negocioList = new List<Negocio_por_Conta__c>();
        Set<Id> contasId = new Set<Id>();

        for(Negocio_por_Conta__c negocio : businessList) {
            contasId.add(negocio.Conta__c);
        } 

        List<Account> contaList = [SELECT Id, Name
                                        FROM Account 
                                            WHERE Id IN : contasId];

        Map<String, Account> contas = new Map<String, Account>();

        for(Account conta : contaList) {
            contas.put(conta.Id, conta);
        }

        for(Negocio_por_Conta__c business : businessList) {
            Negocio_por_Conta__c negocioMap = new Negocio_por_Conta__c();
            if(contas.containsKey(business.Conta__c)) {
                negocioMap.Id = business.Id;
                negocioMap.Name = contas.get(business.Conta__c).Name + '-' + business.Cultura__c + '-' + business.Marca__c + '-' + business.Region_Comercial__c;
                negocioList.add(negocioMap);
            }
        }

        try {                       
            update negocioList;
        } catch (DmlException e) {
            System.debug('DML Error message: ' + e.getMessage());
        }
    }
}
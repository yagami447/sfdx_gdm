/**
* @name ContactsForSignatureElectronica
* @author Jhonny Peroza
* updated 02-10-2021
*/
@isTest
public class ContactsForSignatureElectronicaTest {

    @isTest 
    public static void testVerifyContatsForSignatureElectronica(){ 

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Contract> contractList = TestDataFactoryMilho.createContract(businessList);
        List<Contact> contactList = TestDataFactoryMilho.createContact(1, accountsList);
        List<Signatario_do_Contrato__c> signatarioList = TestDataFactoryMilho.createSignatario(1, contractList, contactList);

        String recordId = contractList[0].Id;

        Test.startTest();
        ContactsForSignatureElectronica.getContacts(recordId);
        Test.stopTest();

    }  
    
    @isTest 
    public static void testUpdateContatsForSignatureElectronica(){ 

        List<Regiao__c> regionsList = TestDataFactoryMilho.createRegions(1);
        List<Account> accountsList = TestDataFactoryMilho.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactoryMilho.createBusiness(accountsList);
        List<Contract> contractList = TestDataFactoryMilho.createContract(businessList);
        List<Contact> contactList = TestDataFactoryMilho.createContact(1, accountsList);
        List<Signatario_do_Contrato__c> signatarioList = TestDataFactoryMilho.createSignatario(1, contractList, contactList);

        String recordId = signatarioList[0].Id;
        String selectedRows = '[{ "Account": "ACCOUNT 1", "check": false, "contactId": "'+contactList[0].Id+'", "Email": "'+contactList[0].Email+'", "Name": "JHONNY PEROZA"}]';

        Test.startTest();
        ContactsForSignatureElectronica.updateContacts(recordId, selectedRows);
        Test.stopTest();

    } 

}
@isTest
public class seedTradeUrlControllerTest {
    @testSetup
    public static void setup(){
        Account acc = new Account(Name='Acc testing');
        insert acc;
        
        Contact ctc = new Contact();
        ctc.AccountId = acc.id;
        ctc.lastName = 'Testin ctc';
        insert ctc;
        
    }
    
    @isTest
    public static void getUserAccId(){
        Account acc = [SELECT ID,Name FROM Account WHERE Name = 'Acc testing'];
        test.startTest();
        String fetchedAccId = seedTradeUrlController.fetchUserAccountId();
        test.stopTest();
       	System.debug(fetchedAccId);
        System.assert(fetchedAccId!= null);
        
    }
}
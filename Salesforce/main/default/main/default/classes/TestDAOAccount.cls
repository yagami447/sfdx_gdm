@IsTest
public class TestDAOAccount {
    @isTest public static void testAccount(){
        Account acc = new Account(Name = 'Teste');
        insert acc;
        DAOAccount.getInstance().get(acc.Id);
        DAOAccount.getInstance().get(new List<Id>{acc.Id});
        DAOAccount.getInstance(DTOUtils.SharingMode.Without).get(acc.Id);
        DAOAccount.getInstance(DTOUtils.SharingMode.Without).get(new List<Id>{acc.Id});
    }
}
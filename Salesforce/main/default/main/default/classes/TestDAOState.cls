@isTest
public class TestDAOState {
    
    @istest public static void test(){     
        Estado__c state = new Estado__c(Name = 'test');
        insert state;
        DAOState.getInstance().getAll();
        DAOState.getInstance(DTOUtils.SharingMode.Without).getAll();
        
    }
}
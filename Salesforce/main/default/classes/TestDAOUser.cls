@isTest
public class TestDAOUser {
    
    @istest public static void test(){     
        
        DAOUser.getInstance().getAll();
        DAOUser.getInstance(DTOUtils.SharingMode.Without).getAll();
        DAOUser.getInstance().get(UserInfo.getUserId());
        DAOUser.getInstance(DTOUtils.SharingMode.Without).get(UserInfo.getUserId());
        DAOUser.getInstance().get(new Set<Id> {UserInfo.getUserId()});
        DAOUser.getInstance(DTOUtils.SharingMode.Without).get(new Set<Id> {UserInfo.getUserId()});
        
    }
    
}
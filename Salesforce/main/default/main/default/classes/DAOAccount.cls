public class DAOAccount {
    public static DAOIAccount getInstance(){
        return new DAOAccountWithSharing();
    }

    public static DAOIAccount getInstance(DTOUtils.SharingMode mode){
        switch on mode {
            when  with{
                return new DAOAccountWithSharing();
            }
            when without{
                return new DAOAccountWithoutSharing();
            }
            when inherit{
                return new DAOAccountInheritSharing();
            }
            when else {
                return new DAOAccountInheritSharing();                
            }
        }
    }

    //All methods must be declared here before implemented
    public interface DAOIAccount{
        Account get(String id);
        List<Account> get(List<Id> ids);
    }

    //This returns all the user can see
    private with sharing class DAOAccountWithSharing implements DAOIAccount{
        DAOAccountInheritSharing base = new DAOAccountInheritSharing();


        public Account get(String id){
            return base.get(id);
        }
        
        public List<Account> get(List<Id> ids){
            return base.get(ids);
        }

    }
    //This returns all the data
    private without sharing class DAOAccountWithoutSharing implements DAOIAccount{
        DAOAccountInheritSharing base = new DAOAccountInheritSharing();

       
        public Account get(String id){
            return base.get(id);
        }
        
        public List<Account> get(List<Id> ids){
            return base.get(ids);
        }
        
    }
    //This returns based on the parent sharing
    private inherited sharing class DAOAccountInheritSharing implements DAOIAccount{
       
        public Account get(String id){
            List<Account> users = get(new List<Id>{id});
            if(users.size() > 0){
                return users.get(0);
            }else{
                return null;
            }
        }
        public List<Account> get(List<Id> ids){
            return [SELECT Id
                            , Name
                            , Responsavel__c
                            , Reponsavel_DSEM__c
                            , Responsavel_NEOGEN__c
                            , Responsavel_DAGMA__c
                            , Responsavel_LICENCAS__c
                            , Region__c
                            , Region_Comercial__c
                    FROM Account WHERE Id IN :ids
            ];
        }
        
    }
}
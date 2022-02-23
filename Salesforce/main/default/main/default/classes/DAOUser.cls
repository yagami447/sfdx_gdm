/*
        @Author: Sergio Migueis - K2
        @Description: DAO for the USER

        @History:
        20/11/2019 - Creation without functions (waiting for test data)
        08/12/2019 - Deploy from scratchorg (event data inclusded)
        02/01/2020 - Added get for current user.
        03/01/2020 - Added Set<Id> get for list of users 
 */
public class DAOUser {

    public static DAOIUser getInstance(){
        return new DAOUserWithSharing();
    }

    public static DAOIUser getInstance(DTOUtils.SharingMode mode){
        switch on mode {
            when  with{
                return new DAOUserWithSharing();
            }
            when without{
                return new DAOUserWithoutSharing();
            }
            when inherit{
                return new DAOUserInheritSharing();
            }
            when else {
                return new DAOUserInheritSharing();                
            }
        }
    }

    //All methods must be declared here before implemented
    public interface DAOIUser{
        List<User> getAll();
        User get(String id);
        List<User> get(Set<Id> ids);
    }

    //This returns all the user can see
    private with sharing class DAOUserWithSharing implements DAOIUser{
        DAOUserInheritSharing base = new DAOUserInheritSharing();

        public List<User> getAll(){
            return base.getAll();
        }

        public User get(String id){
            return base.get(id);
        }
        
        public List<User> get(Set<Id> ids){
            return base.get(ids);
        }

    }
    //This returns all the data
    private without sharing class DAOUserWithoutSharing implements DAOIUser{
        DAOUserInheritSharing base = new DAOUserInheritSharing();

        public List<User> getAll(){
            return base.getAll();
        }
        public User get(String id){
            return base.get(id);
        }
        
        public List<User> get(Set<Id> ids){
            return base.get(ids);
        }
        
    }
    //This returns based on the parent sharing
    private inherited sharing class DAOUserInheritSharing implements DAOIUser{
        public List<User> getAll(){
            return [SELECT Id
                            , UserRole.Name
                            , Profile.Name
                            , Name
                            , Email
                            , ContactId
                            , Codigo_SAP__c
                            , Contact.Account.Region_Comercial__c
                            , Contact.AccountId  FROM User];
        }
        public User get(String id){
            List<User> users = get(new Set<Id>{id});
            if(users.size() > 0){
                return users.get(0);
            }else{
                return null;
            }
        }
        public List<User> get(Set<Id> ids){
            return [SELECT Id
                            , Name
                            , Email
                            , ContactId
                            , Contact.AccountId
                            , Contact.Account.Region_Comercial__c
                            , Codigo_SAP__c
                            , Profile.Name 
                    FROM User WHERE Id IN :ids
            ];
        }
        
    }
}
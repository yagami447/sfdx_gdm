/*
        @Author: Sergio Migueis - K2
        @Description: DAO for the Product2

        @History:
        20/11/2019 - Creation without functions (waiting for test data)
        08/12/2019 - Deploy from scratchorg (event data inclusded)
 */
public class DAOProduct2 {

    public static DAOIProduct2 getInstance(){
        return new DAOProduct2WithSharing();
    }

    public static DAOIProduct2 getInstance(DTOUtils.SharingMode mode){
        switch on mode {
            when  with{
                return new DAOProduct2WithSharing();
            }
            when without{
                return new DAOProduct2WithoutSharing();
            }
            when inherit{
                return new DAOProduct2InheritSharing();
            }
            when else {
                return new DAOProduct2InheritSharing();                
            }
        }
    }

    //All methods must be declared here before implemented
    public interface DAOIProduct2{
        List<Product2> getBySearchString(String search);
    }

    //This returns all the user can see
    private with sharing class DAOProduct2WithSharing implements DAOIProduct2{
        DAOProduct2InheritSharing base = new DAOProduct2InheritSharing();

        public List<Product2> getBySearchString(String search){
            return base.getBySearchString(search);
        }

    }
    //This returns all the data
    private without sharing class DAOProduct2WithoutSharing implements DAOIProduct2{
        DAOProduct2InheritSharing base = new DAOProduct2InheritSharing();

        public List<Product2> getBySearchString(String search){
            return base.getBySearchString(search);
        }
        
    }
    //This returns based on the parent sharing
    private inherited sharing class DAOProduct2InheritSharing implements DAOIProduct2{
        public List<Product2> getBySearchString(String search){
            if(search == null) search = '';
            search = '%' + search + '%';
            return [
                SELECT Id 
                ,Obtentor__c
                ,Name
                FROM Product2 
                WHERE isActive = false 
                AND Obtentor__c != null
                AND (Name LIKE :search  OR Obtentor__c LIKE  :search)
                ];
        }
        
    }
}
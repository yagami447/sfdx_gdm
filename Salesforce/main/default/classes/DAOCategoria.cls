public class DAOCategoria {
    public static DAOICategoria getInstance(){
        return new DAOCategoriaWithSharing();
    }

    public static DAOICategoria getInstance(DTOUtils.SharingMode mode){
        switch on mode {
            when  with{
                return new DAOCategoriaWithSharing();
            }
            when without{
                return new DAOCategoriaWithoutSharing();
            }
            when inherit{
                return new DAOCategoriaInheritSharing();
            }
            when else {
                return new DAOCategoriaInheritSharing();                
            }
        }
    }

    //All methods must be declared here before implemented
    public interface DAOICategoria{
        List<Categoria__c> getBasedOnNamesForOpportunity();
        List<Categoria__c> getAll();
    }

    private with sharing class DAOCategoriaWithSharing implements DAOICategoria{
        DAOCategoriaInheritSharing base = new DAOCategoriaInheritSharing();

        public List<Categoria__c> getBasedOnNamesForOpportunity(){
            return base.getBasedOnNamesForOpportunity();
        }
        public List<Categoria__c> getAll(){
            return base.getAll();
        }
    }
    private without sharing class DAOCategoriaWithoutSharing implements DAOICategoria{
        DAOCategoriaInheritSharing base = new DAOCategoriaInheritSharing();

        public List<Categoria__c> getBasedOnNamesForOpportunity(){
            return base.getBasedOnNamesForOpportunity();
        }
        public List<Categoria__c> getAll(){
            return base.getAll();
        }
    }
    //This returns based on the parent sharing
    private inherited sharing class DAOCategoriaInheritSharing implements DAOICategoria{
        public List<Categoria__c> getBasedOnNamesForOpportunity(){
            return [
                SELECT Id
                ,Name
                FROM Categoria__c 
                WHERE Name IN('BASICA', 'C1', 'C2', 'S1', 'S2')
                ORDER BY Name
            ];
        }
        public List<Categoria__c> getAll(){
            return [
                SELECT Id
                ,Name
                FROM Categoria__c 
                ORDER BY Name
            ];
        }
        
    }    
}
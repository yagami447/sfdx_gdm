public class DAOState {
    public static DAOIEstado getInstance(){
        return new DAOEstadoWithSharing();
    }

    public static DAOIEstado getInstance(DTOUtils.SharingMode mode){
        switch on mode {
            when  with{
                return new DAOEstadoWithSharing();
            }
            when without{
                return new DAOEstadoWithoutSharing();
            }
            when inherit{
                return new DAOEstadoInheritSharing();
            }
            when else {
                return new DAOEstadoInheritSharing();                
            }
        }
    }

    //All methods must be declared here before implemented
    public interface DAOIEstado{
        
        List<Estado__c> getAll();
    }

    private with sharing class DAOEstadoWithSharing implements DAOIEstado{
        DAOEstadoInheritSharing base = new DAOEstadoInheritSharing();

        public List<Estado__c> getAll(){
            return base.getAll();
        }
    }
    private without sharing class DAOEstadoWithoutSharing implements DAOIEstado{
        DAOEstadoInheritSharing base = new DAOEstadoInheritSharing();

        public List<Estado__c> getAll(){
            return base.getAll();
        }
    }
    //This returns based on the parent sharing
    private inherited sharing class DAOEstadoInheritSharing implements DAOIEstado{
        
        public List<Estado__c> getAll(){
            return [
                SELECT Id
                ,Name
                FROM Estado__c 
                ORDER BY Name
            ];
        }
        
    }
}
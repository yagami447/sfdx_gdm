/**
 * @Author: Sergio Migueis - K2
 * @Description: DAO for the CRM_Calendario_De_Eventos
 * @History:
 * 20/11/2019 - Creation without functions (waiting for test data)
 * 08/12/2019 - Deploy from scratchorg (event data inclusded)
 */
public class DAOCRMCalendarioDeEventos {

    public static DAOICRMCalendarioDeEventos getInstance() {
        return new DAOCRMCalendarioDeEventosWithSharing();
    }

    public static DAOICRMCalendarioDeEventos getInstance(DTOUtils.SharingMode mode) {
        switch on mode {
            when  with{
                return new DAOCRMCalendarioDeEventosWithSharing();
            }
            when without{
                return new DAOCRMCalendarioDeEventosWithoutSharing();
            }
            when inherit{
                return new DAOCRMCalendarioDeEventosInheritSharing();
            }
            when else {
                return new DAOCRMCalendarioDeEventosInheritSharing();                
            }
        }
    }

    //All methods must be declared here before implemented
    public interface DAOICRMCalendarioDeEventos {
        CRM_Calendario_de_Eventos__c get(String Id);
        List<CRM_Calendario_de_Eventos__c> get(List<String> Id);
    }

    //This returns all the CRMCalendarioDeEventos can see
    private with sharing class DAOCRMCalendarioDeEventosWithSharing implements DAOICRMCalendarioDeEventos {
        DAOCRMCalendarioDeEventosInheritSharing base = new DAOCRMCalendarioDeEventosInheritSharing();

        public CRM_Calendario_de_Eventos__c get(String Id) {
            return base.get(Id);
        }
        public List<CRM_Calendario_de_Eventos__c> get(List<String> Id) {
            return base.get(Id);
        }
    }

    //This returns all the data
    private without sharing class DAOCRMCalendarioDeEventosWithoutSharing implements DAOICRMCalendarioDeEventos {
        DAOCRMCalendarioDeEventosInheritSharing base = new DAOCRMCalendarioDeEventosInheritSharing();

        public CRM_Calendario_de_Eventos__c get(String Id) {
            return base.get(Id);
        }
        public List<CRM_Calendario_de_Eventos__c> get(List<String> Id) {
            return base.get(Id);
        }
    }

    //This returns based on the parent sharing
    private inherited sharing class DAOCRMCalendarioDeEventosInheritSharing implements DAOICRMCalendarioDeEventos {
        public CRM_Calendario_de_Eventos__c get(String Id) {
            return [
                SELECT Id, Name, RecordType.Name, RecordType.DeveloperName, CreatedById, OwnerId 
                FROM CRM_Calendario_de_Eventos__c
                WHERE Id = :Id
            ];
        }

        public List<CRM_Calendario_de_Eventos__c> get(List<String> Id) {
            return [
                SELECT Id, Name, RecordType.Name, RecordType.DeveloperName, CreatedById, OwnerId 
                FROM CRM_Calendario_de_Eventos__c
                WHERE Id IN :Id
            ];
        }
    }
}
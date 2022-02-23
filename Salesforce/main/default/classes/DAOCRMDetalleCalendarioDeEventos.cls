/*
        @Author: Sergio Migueis - K2
        @Description: DAO for the CRM_Detalle_Calendario_De_Eventos

        @History:
        20/11/2019 - Creation without functions (waiting for test data)
        08/12/2019 - Deploy from scratchorg (event data inclusded)
 */
public class DAOCRMDetalleCalendarioDeEventos {

    public static DAOICRMDetalleCalendarioDeEventos getInstance() {
        return new DAOCRMDetalleCalendarioDeEventosWithSharing();
    }

    public static DAOICRMDetalleCalendarioDeEventos getInstance(DTOUtils.SharingMode mode) {
        switch on mode {
            when  with{
                return new DAOCRMDetalleCalendarioDeEventosWithSharing();
            }
            when without{
                return new DAOCRMDetalleCalendarioDeEventosWithoutSharing();
            }
            when inherit{
                return new DAOCRMDetalleCalendarioDeEventosInheritSharing();
            }
            when else {
                return new DAOCRMDetalleCalendarioDeEventosInheritSharing();                
            }
        }
    }

    //All methods must be declared here before implemented
    public interface DAOICRMDetalleCalendarioDeEventos {
        List<CRM_Detalle_Calendario_de_eventos__c> getByCRMCalendarioId(String id);
    }

    //This returns all the CRMDetalleCalendarioDeEventos can see
    private with sharing class DAOCRMDetalleCalendarioDeEventosWithSharing implements DAOICRMDetalleCalendarioDeEventos {
        DAOCRMDetalleCalendarioDeEventosInheritSharing base = new DAOCRMDetalleCalendarioDeEventosInheritSharing();

        public List<CRM_Detalle_Calendario_de_eventos__c> getByCRMCalendarioId(String id) {
            return base.getByCRMCalendarioId(Id);
        }
    }

    //This returns all the data
    private without sharing class DAOCRMDetalleCalendarioDeEventosWithoutSharing implements DAOICRMDetalleCalendarioDeEventos {
        DAOCRMDetalleCalendarioDeEventosInheritSharing base = new DAOCRMDetalleCalendarioDeEventosInheritSharing();

        public List<CRM_Detalle_Calendario_de_eventos__c> getByCRMCalendarioId(String id) {
            return base.getByCRMCalendarioId(Id);
        }
    }

    //This returns based on the parent sharing
    private inherited sharing class DAOCRMDetalleCalendarioDeEventosInheritSharing implements DAOICRMDetalleCalendarioDeEventos {
        public List<CRM_Detalle_Calendario_de_eventos__c> getByCRMCalendarioId(String id) {
            return [
                SELECT Id, Name, Produto_Principal__c, Cultivar__r.Obtentor__c, Indice__c, Cultivar__r.Name, Populacao_de_plantas__c, Espacamento__c,
                    Area_plantada__c, Area_Colhida__c, Produtividade__c, Data_de_plantio__c, Data_de_colheita__c, Volume_Doado__c, Cultura_antecessora__c
                FROM CRM_Detalle_Calendario_de_eventos__c
                WHERE CRM_Calendario_de_eventos__c = :id
            ];
        }
    }
}
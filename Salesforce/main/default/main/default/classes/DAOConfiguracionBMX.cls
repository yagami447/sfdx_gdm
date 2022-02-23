public class DAOConfiguracionBMX {
    
    public static DAOIConfiguracionBMX getInstance(){
        return new DAOConfiguracionBMXWithSharing();
    }

    public static DAOIConfiguracionBMX getInstance(DTOUtils.SharingMode mode){
        switch on mode {
            when  with{
                return new DAOConfiguracionBMXWithSharing();
            }
            when without{
                return new DAOConfiguracionBMXWithoutSharing();
            }
            when inherit{
                return new DAOConfiguracionBMXInheritSharing();
            }
            when else {
                return new DAOConfiguracionBMXInheritSharing();                
            }
        }
    }

    //All methods must be declared here before implemented
    public interface DAOIConfiguracionBMX{
        Configuracion_BMX__c getFirst();
    }

    private with sharing class DAOConfiguracionBMXWithSharing implements DAOIConfiguracionBMX{
        DAOConfiguracionBMXInheritSharing base = new DAOConfiguracionBMXInheritSharing();

        public Configuracion_BMX__c getFirst(){
            return base.getFirst();
        }
    }
    private without sharing class DAOConfiguracionBMXWithoutSharing implements DAOIConfiguracionBMX{
        DAOConfiguracionBMXInheritSharing base = new DAOConfiguracionBMXInheritSharing();

        public Configuracion_BMX__c getFirst(){
            return base.getFirst();
        }
    }
    //This returns based on the parent sharing
    private inherited sharing class DAOConfiguracionBMXInheritSharing implements DAOIConfiguracionBMX{
        public Configuracion_BMX__c getFirst(){
            return [
                SELECT Id
                    ,Londrina_Tasa_COFINS__c
                    , Londrina_Tasa_ISS__c
                    , Londrina_Tasa_PIS__c
                    , Passo_Fundo_Tasa_COFINS__c
                    , Passo_Fundo_Tasa_ISS__c
                    , Passo_Fundo_Tasa_PIS__c
                    , PM_Safra_Actual__c
                    , PM_Safra_Actual_A1__c
                    , PM_Safra_Actual_A2__c
                    , PM_Safra_Actual_A3__c
                    , PM_Safra_Actual_A4__c
                    , PM_Safra_Actual_A5__c
                    , PM_Safra_Actual_Contratos__c
                    , PM_Safra_Actual_Descarte__c
                    , PM_Safra_Actual_Estoque__c
                    , PM_Safra_Actual_Eventos__c
                    , PM_Safra_Actual_Reembalagem__c
                    , PM_Estoque_Dia_Hasta__c 
                    , Mes_Stock__c 
                    , PM_Estoque_Dia_Desde__c 
                FROM Configuracion_BMX__c LIMIT 1
            ];
        }
        
    }    
}
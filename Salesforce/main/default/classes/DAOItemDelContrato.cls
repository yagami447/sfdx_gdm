public  class DAOItemDelContrato {
    public static DAOIItemDelContrato getInstance(){
        return new DAOItemDelContratoWithSharing();
    }

    public static DAOIItemDelContrato getInstance(DTOUtils.SharingMode mode){
        switch on mode {
            when  with{
                return new DAOItemDelContratoWithSharing();
            }
            when without{
                return new DAOItemDelContratoWithoutSharing();
            }
            when inherit{
                return new DAOItemDelContratoInheritSharing();
            }
            when else {
                return new DAOItemDelContratoInheritSharing();                
            }
        }
    }

    //All methods must be declared here before implemented
    public interface DAOIItemDelContrato{
        List<Item_del_Contrato__c> getByMarcaBySafraByMultiplicador(String marca, String safra, String multiplicador);
    }

    //This returns all the user can see
    private with sharing class DAOItemDelContratoWithSharing implements DAOIItemDelContrato{
        DAOItemDelContratoInheritSharing base = new DAOItemDelContratoInheritSharing();

        
        public List<Item_del_Contrato__c> getByMarcaBySafraByMultiplicador(String marca, String safra, String multiplicador){
            return base.getByMarcaBySafraByMultiplicador(marca,safra,multiplicador);
        }

    }
    //This returns all the data
    private without sharing class DAOItemDelContratoWithoutSharing implements DAOIItemDelContrato{
        DAOItemDelContratoInheritSharing base = new DAOItemDelContratoInheritSharing();

       
        
        public List<Item_del_Contrato__c> getByMarcaBySafraByMultiplicador(String marca, String safra, String multiplicador){
            return base.getByMarcaBySafraByMultiplicador(marca,safra,multiplicador);
        }
        
    }
    //This returns based on the parent sharing
    private inherited sharing class DAOItemDelContratoInheritSharing implements DAOIItemDelContrato{
       
        
        public List<Item_del_Contrato__c> getByMarcaBySafraByMultiplicador(String marca, String safra, String multiplicador){
            
            // AND (RecordType.DeveloperName = 'Termo_Aditivo' OR RecordType.DeveloperName = 'Termo_Aditivo_Lan_amentos')
            return [
                SELECT Id,Cultivar__r.Categ__c,Cultivar__r.Variedade__c
                    , Cultivar__c 
                FROM Item_del_Contrato__c 
                WHERE Contrato_de_Multiplicacion__r.Multiplicador__c = :multiplicador 
                    AND Contrato_de_Multiplicacion__r.Safra__c = :safra 
                    AND Contrato_de_Multiplicacion__r.Sociedad__c = :marca 
                    AND Cultivar__c != null 
                    AND (Contrato_de_Multiplicacion__r.Chegou_na_Brasmax__c = true OR Contrato_de_Multiplicacion__r.Estado__c = 'Chegou')
                ORDER BY CreatedDate DESC
            ];
        }
        
    }
}
public class DAOPricebookEntry {
    
    public static DAOIPricebookEntry getInstance(){
        return new DAOPricebookEntryWithSharing();
    }

    public static DAOIPricebookEntry getInstance(DTOUtils.SharingMode mode){
        switch on mode {
            when  with{
                return new DAOPricebookEntryWithSharing();
            }
            when without{
                return new DAOPricebookEntryWithoutSharing();
            }
            when inherit{
                return new DAOPricebookEntryInheritSharing();
            }
            when else {
                return new DAOPricebookEntryInheritSharing();                
            }
        }
    }

    //All methods must be declared here before implemented
    public interface DAOIPricebookEntry{
        List<PriceBookEntry> getByFiltrosForCategoria(String pbe
                                                , String variabilidade
                                                , String categoria
                                                , String unidade
                                                , Boolean tratada);
        List<PriceBookEntry> getForPricebooks(List<String> pricebooks, List<String> products);
    }

    private with sharing class DAOPricebookEntryWithSharing implements DAOIPricebookEntry{
        DAOPricebookEntryInheritSharing base = new DAOPricebookEntryInheritSharing();

        public List<PriceBookEntry> getByFiltrosForCategoria(String pbe
                                                , String variabilidade
                                                , String categoria
                                                , String unidade
                                                , Boolean tratada){
            return base.getByFiltrosForCategoria( pbe
                                                ,  variabilidade
                                                ,  categoria
                                                ,  unidade
                                                ,  tratada);
        }

        public List<PriceBookEntry> getForPricebooks(List<String> pricebooks, List<String> products){
            return base.getForPricebooks(pricebooks, products);
        }
    }
    private without sharing class DAOPricebookEntryWithoutSharing implements DAOIPricebookEntry{
        DAOPricebookEntryInheritSharing base = new DAOPricebookEntryInheritSharing();

        public List<PriceBookEntry> getByFiltrosForCategoria(String pbe
                                                , String variabilidade
                                                , String categoria
                                                , String unidade
                                                , Boolean tratada){
            return base.getByFiltrosForCategoria( pbe
                                                ,  variabilidade
                                                ,  categoria
                                                ,  unidade
                                                ,  tratada);
        }

        public List<PriceBookEntry> getForPricebooks(List<String> pricebooks, List<String> products){
            return base.getForPricebooks(pricebooks, products);
        }
    }
    //This returns based on the parent sharing
    private inherited sharing class DAOPricebookEntryInheritSharing implements DAOIPricebookEntry{
        public List<PriceBookEntry> getByFiltrosForCategoria(String pbe
                                                , String variabilidade
                                                , String categoria
                                                , String unidade
                                                , Boolean tratada){
            return [
                SELECT Id
                , Name
                , Pricebook2Id
                , IsActive
                , Product2.Name
                , Product2.Especie__c
                , Product2.Categoria__c
                , Product2.Codigo_material_SAP__c
                , Product2.IsActive
                , Product2.Description
                , Product2.Unidade__c
                , Product2.Semilla_Tratada__c
                , UnitPrice 
                , Product2.Variedade__r.Nombre_de_Registro__c
                , Product2.Variedade__r.Name
                , Product2.Categ__r.Name
                , Product2.Variedade__c
                FROM PricebookEntry 
                WHERE Pricebook2Id = :pbe
                AND Product2.Variedade__c = :variabilidade
                AND Product2.Categ__c = :categoria
                AND Product2.Unidade__c = :unidade 
                AND IsActive = true 
                AND Product2.Semilla_Tratada__c = :tratada
                limit 1];
        }

        public List<PriceBookEntry> getForPricebooks(List<String> pricebooks, List<String> products){
            return [
                SELECT Id
                , Name
                , Pricebook2Id
                , IsActive
                , Product2.Name
                , Product2.Especie__c
                , Product2.Categoria__c
                , Product2.Codigo_material_SAP__c
                , Product2.IsActive
                , Product2.Description
                , Product2.Unidade__c
                , Product2.Semilla_Tratada__c
                , UnitPrice 
                , Product2.Variedade__r.Nombre_de_Registro__c
                , Product2.Variedade__r.Name
                , Product2.Categ__r.Name
                , Product2.Variedade__c
                FROM PricebookEntry 
                WHERE Pricebook2Id IN :pricebooks
                AND Product2Id IN :products
            ];
        }
        
    }    
}
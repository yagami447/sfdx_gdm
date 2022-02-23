public class DAOOpportunity {
    
    public static DAOIOpportunity getInstance(){
        return new DAOOpportunityWithSharing();
    }

    public static DAOIOpportunity getInstance(DTOUtils.SharingMode mode){
        switch on mode {
            when  with{
                return new DAOOpportunityWithSharing();
            }
            when without{
                return new DAOOpportunityWithoutSharing();
            }
            when inherit{
                return new DAOOpportunityInheritSharing();
            }
            when else {
                return new DAOOpportunityInheritSharing();                
            }
        }
    }

    //All methods must be declared here before implemented
    public interface DAOIOpportunity{
        Opportunity         get(String recordId);
        List<Opportunity>   get(List<Id> ids);
        List<Opportunity>   getByFilter(String marca,String safra,String multiplicador,List<String> tipos,String fase);
        List<Opportunity>   getApprovedByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca);
        List<Opportunity>   getByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca);
        List<Opportunity>   getByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca, List<String> season);
        List<Opportunity>   getApprovedByAccountAndBySafraAndByType(List<Id> accountIds,List<String> safras, List<String> marca, List<String> season, List<String> types);
        List<Opportunity>   getApprovedByAccountAndBySafraAndByType(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types);
        List<Opportunity>   getApprovedByAnexo2_VendaDeBasica_Sementes(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types);
        List<Opportunity>   getApprovedByAccountAndBySafraAndByTypeNotApproved(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types);
    }

    private with sharing class DAOOpportunityWithSharing implements DAOIOpportunity{
        DAOOpportunityInheritSharing base = new DAOOpportunityInheritSharing();

        public Opportunity get(String recordId){
            return base.get(recordId);
        }
        public List<Opportunity> get(List<Id> ids){
            return base.get(ids);
        }
        public List<Opportunity> getByFilter(String marca,String safra,String multiplicador,List<String> tipos,String fase){
            return base.getByFilter(marca,safra,multiplicador,tipos,fase);
        }
        public List<Opportunity>  getApprovedByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca){
            return base.getApprovedByAccountAndBySafra(accountIds,safras, marca);
        }
        public List<Opportunity>  getByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca){
            return base.getByAccountAndBySafra(accountIds,safras, marca);
        }
        public List<Opportunity>  getByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca, List<String> season){
            return base.getByAccountAndBySafra(accountIds,safras, marca,season);
        }
        public List<Opportunity>  getApprovedByAccountAndBySafraAndByType(List<Id> accountIds,List<String> safras, List<String> marca, List<String> season, List<String> types){
            return base.getApprovedByAccountAndBySafraAndByType(accountIds,safras, marca,season, types);
        }
        public List<Opportunity>  getApprovedByAccountAndBySafraAndByType(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types){
            return base.getApprovedByAccountAndBySafraAndByType(accountIds,safras, marca, types);
        }

        public List<Opportunity>  getApprovedByAnexo2_VendaDeBasica_Sementes(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types){
            return base.getApprovedByAnexo2_VendaDeBasica_Sementes(accountIds,safras, marca, types);
        }


        public List<Opportunity>  getApprovedByAccountAndBySafraAndByTypeNotApproved(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types){
            return base.getApprovedByAccountAndBySafraAndByTypeNotApproved(accountIds,safras, marca, types);
        }
        
    }
    private without sharing class DAOOpportunityWithoutSharing implements DAOIOpportunity{
        DAOOpportunityInheritSharing base = new DAOOpportunityInheritSharing();

        public Opportunity get(String recordId){
            return base.get(recordId);
        }
        public List<Opportunity> get(List<Id> ids){
            return base.get(ids);
        }
        public List<Opportunity> getByFilter(String marca,String safra,String multiplicador,List<String> tipos,String fase){
            return base.getByFilter(marca,safra,multiplicador,tipos,fase);
        }
        public List<Opportunity>  getApprovedByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca){
            return base.getApprovedByAccountAndBySafra(accountIds,safras,marca);
        }
        public List<Opportunity>  getByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca){
            return base.getByAccountAndBySafra(accountIds,safras, marca);
        }
        public List<Opportunity>  getByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca, List<String> season){
            return base.getByAccountAndBySafra(accountIds,safras, marca,season);
        }
        public List<Opportunity>  getApprovedByAccountAndBySafraAndByType(List<Id> accountIds,List<String> safras, List<String> marca, List<String> season, List<String> types){
            return base.getApprovedByAccountAndBySafraAndByType(accountIds,safras, marca,season, types);
        }
        public List<Opportunity>  getApprovedByAccountAndBySafraAndByType(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types){
            return base.getApprovedByAccountAndBySafraAndByType(accountIds,safras, marca, types);
        }

        public List<Opportunity>  getApprovedByAnexo2_VendaDeBasica_Sementes(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types){
            return base.getApprovedByAnexo2_VendaDeBasica_Sementes(accountIds,safras, marca, types);
        }
        
        public List<Opportunity>  getApprovedByAccountAndBySafraAndByTypeNotApproved(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types){
            return base.getApprovedByAccountAndBySafraAndByTypeNotApproved(accountIds,safras, marca, types);
        }

        
    }
    //This returns based on the parent sharing
    private inherited sharing class DAOOpportunityInheritSharing implements DAOIOpportunity{
        public Opportunity get(String recordId){
            return [
                SELECT Id
                ,Name
                ,CreatedById
                ,RecordTypeId
                ,RecordType.Name
                ,RecordType.DeveloperName
                ,StageName
                ,Origen__r.Name
                ,OwnerId
                ,Owner.Name
                ,Pricebook2Id
                ,Local_de_Entrega__c
                ,AccountId
                ,Safra__c
                ,Marca__c
                ,Epoca_de_Plantio__c
                ,Anexo_Relacionado__c
                ,Mes__c
                FROM Opportunity 
                WHERE Id = :recordId
            ];
        }
        public List<Opportunity> get(List<Id> ids){
            
            return [
                SELECT Id
                ,Name
                ,CreatedById
                ,RecordTypeId
                ,RecordType.Name
                ,RecordType.DeveloperName
                ,StageName
                ,Origen__r.Name
                ,OwnerId
                ,Owner.Name
                ,Pricebook2Id
                ,Local_de_Entrega__c
                ,AccountId
                ,Safra__c
                ,Marca__c
                ,Epoca_de_Plantio__c
                ,Anexo_Relacionado__c
                ,Mes__c 
                FROM Opportunity 
                WHERE Id IN :ids
            ];
        }
        
        public List<Opportunity> getByFilter(String marca,String safra,String multiplicador,List<String> tipos,String fase){
            return [SELECT Id, AccountId, RecordType.Name, Safra__c, Marca__c,Epoca_de_Plantio__c
                        ,Mes__c      
                       FROM Opportunity WHERE 
                       AccountId = :multiplicador 
                       AND Safra__c = :safra
                       AND Marca__c = :marca
                       AND RecordType.Name IN :tipos
                       AND StageName LIKE :fase];
        }
        public List<Opportunity> getApprovedByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca){
            return [SELECT Id
                        , RecordTypeId
                        , RecordType.Name
                        , RecordType.DeveloperName 
                        , AccountId
                        , Epoca_de_Plantio__c
                        , Marca__c 
                        , Safra__c
                        , Anexo_Relacionado__c
                        ,Mes__c
                        ,Pricebook2Id     
                        FROM Opportunity 
                        WHERE AccountId IN :accountIds 
                       AND Safra__c IN :safras
                       AND Marca__c IN :marca
                       AND StageName = 'Aprobada' ];
        }
        public List<Opportunity> getByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca){
            return [SELECT Id
                        , RecordTypeId
                        , RecordType.Name
                        , RecordType.DeveloperName 
                        , AccountId
                        , Epoca_de_Plantio__c
                        , Marca__c 
                        , Safra__c
                        , Anexo_Relacionado__c
                        ,Mes__c   
                        ,Pricebook2Id  
                        FROM Opportunity 
                        WHERE AccountId IN :accountIds 
                    AND Safra__c IN :safras
                    AND Marca__c IN :marca];
        }
        public List<Opportunity> getByAccountAndBySafra(List<Id> accountIds,List<String> safras, List<String> marca, List<String> season){
            return [SELECT Id
                        , RecordTypeId
                        , RecordType.Name
                        , RecordType.DeveloperName 
                        , AccountId
                        , Epoca_de_Plantio__c
                        , Marca__c 
                        , Safra__c
                        , Anexo_Relacionado__c
                        ,Mes__c   
                        ,Pricebook2Id  
                        FROM Opportunity 
                        WHERE AccountId IN :accountIds 
                    AND Safra__c IN :safras
                    AND Marca__c IN :marca
                    AND Epoca_de_Plantio__c IN :season];
        }
        public List<Opportunity>  getApprovedByAccountAndBySafraAndByType(List<Id> accountIds,List<String> safras, List<String> marca, List<String> season, List<String> types){
            return [SELECT Id
                        , RecordTypeId
                        , RecordType.Name
                        , RecordType.DeveloperName 
                        , AccountId
                        , Epoca_de_Plantio__c
                        , Marca__c 
                        , Safra__c
                        , Anexo_Relacionado__c
                        ,Mes__c    
                        ,Pricebook2Id 
                        FROM Opportunity 
                        WHERE AccountId IN :accountIds 
                    AND Safra__c IN :safras
                    AND Marca__c IN :marca
                    AND Epoca_de_Plantio__c IN :season
                    AND StageName = 'Aprobada'
                    AND RecordTypeId IN :types
                    ORDER BY CreatedDate DESC];
        }
        public List<Opportunity>  getApprovedByAccountAndBySafraAndByType(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types){
            return [
                SELECT  Id, RecordTypeId, RecordType.Name, RecordType.DeveloperName , AccountId, 
                        Epoca_de_Plantio__c, Marca__c , Safra__c, Anexo_Relacionado__c,Mes__c ,Pricebook2Id    
                FROM Opportunity 
                WHERE AccountId IN :accountIds 
                    AND Safra__c IN :safras
                    AND Marca__c IN :marca
                    AND StageName = 'Aprobada'
                    AND RecordTypeId IN :types
                    ORDER BY CreatedDate DESC
            ];
        }

        public List<Opportunity> getApprovedByAnexo2_VendaDeBasica_Sementes(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types){
            String safraAnt = String.valueOf(Integer.valueOf(safras[0].substring(0,2)) - 1) + '/' + String.valueOf(Integer.valueOf(safras[0].substring(3,5)) - 1);
            return [
                SELECT  Id, RecordTypeId, RecordType.Name, RecordType.DeveloperName , AccountId, 
                        Epoca_de_Plantio__c, Marca__c , Safra__c, Anexo_Relacionado__c,Mes__c ,Pricebook2Id    
                FROM Opportunity 
                WHERE (
                        (
                            RecordType.Name = 'Anexo II' And 
                            Safra__c = :safraAnt And 
                            StageName = 'Aprobada'
                        ) 
                        Or 
                        (
                            (
                                (
                                    (
                                        RecordType.Name = 'VB - Autorizada' OR
                                        RecordType.Name = 'VB - Pasada SAP'
                                    )
                                    AND
                                    (
                                        StageName = 'AU - Autorizada' OR
                                        StageName = 'Aprobada'
                                    )
                                ) 
                                Or 
                                (
                                    RecordType.Name = 'Aquisição Sementes Terceiros' And 
                                    StageName = 'Aprobada'
                                )
                            ) 
                            And 
                            Safra__c IN :safras
                        )
                    ) AND AccountId IN :accountIds AND Marca__c IN :marca
                ORDER BY CreatedDate DESC
            ];
        }

        
        public List<Opportunity>  getApprovedByAccountAndBySafraAndByTypeNotApproved(List<Id> accountIds,List<String> safras, List<String> marca, List<String> types){
            return [SELECT Id
                        , RecordTypeId
                        , RecordType.Name
                        , RecordType.DeveloperName 
                        , AccountId
                        , Epoca_de_Plantio__c
                        , Marca__c 
                        , Safra__c
                        , Anexo_Relacionado__c
                        ,Mes__c    
                        ,Pricebook2Id 
                        FROM Opportunity 
                        WHERE AccountId IN :accountIds 
                    AND Safra__c IN :safras
                    AND Marca__c IN :marca
                    AND RecordTypeId IN :types
                    ORDER BY CreatedDate DESC];
        }
        
    }    
}
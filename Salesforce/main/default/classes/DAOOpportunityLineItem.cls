public class DAOOpportunityLineItem {
    public static DAOIOpportunityLineItem getInstance(){
        return new DAOOpportunityLineItemWithSharing();
    }

    public static DAOIOpportunityLineItem getInstance(DTOUtils.SharingMode mode){
        switch on mode {
            when  with{
                return new DAOOpportunityLineItemWithSharing();
            }
            when without{
                return new DAOOpportunityLineItemWithoutSharing();
            }
            when inherit{
                return new DAOOpportunityLineItemInheritSharing();
            }
            when else {
                return new DAOOpportunityLineItemInheritSharing();                
            }
        }
    }
    //All methods must be declared here before implemented
    public interface DAOIOpportunityLineItem{
        List<OpportunityLineItem> get(Set<Id> ids);
        List<OpportunityLineItem> getByOpportunityId(String recordId);
        List<OpportunityLineItem> getByOpportunityId(List<String> recordId);
        List<AggregateResult> getByFiltrosForAnexoI(String anexo
                                                    , String name
                                                    , String opportunityId);
        List<AggregateResult> getPlantadoFromA1(String marca, String safra, String multiplicador);
        List<AggregateResult> getValuesA4(String marca, String safra, String multiplicador);
        List<AggregateResult> getValuesA3(String marca, String safra, String multiplicador);
        List<AggregateResult> getValuesA2(String marca, String safra, String multiplicador);
        List<OpportunityLineItem> getAllForA3(String marca, String safra, String multiplicador);
        List<OpportunityLineItem> getAllForA4(String marca, String safra, String multiplicador);
        List<OpportunityLineItem> getAllForA2(String marca, String safra, String multiplicador);
        List<OpportunityLineItem> getAllDescarte(String marca, String safra, String multiplicador);
        List<OpportunityLineItem> getAllApprovedForAttanchmentByMarcaBySafraByAccount(String accountId, String marca, String safra);
        List<OpportunityLineItem> getOlisRebaixamento(String opp);      
        List<OpportunityLineItem> getOlisRebaixamento(List<String> opp);
    }
    private with sharing class DAOOpportunityLineItemWithSharing implements DAOIOpportunityLineItem{
        DAOOpportunityLineItemInheritSharing base = new DAOOpportunityLineItemInheritSharing();

        public List<OpportunityLineItem> get(Set<Id> ids){
            return base.get(ids);
        }
        public List<OpportunityLineItem> getByOpportunityId(String recordId){
            return base.getByOpportunityId(recordId);
        }
        public List<OpportunityLineItem> getByOpportunityId(List<String> recordId){
            return base.getByOpportunityId(recordId);
        }
        public List<AggregateResult> getByFiltrosForAnexoI(String anexo
                                                    , String name
                                                    , String opportunityId){
            return base.getByFiltrosForAnexoI(anexo,name,opportunityId);
        }
        public List<AggregateResult> getPlantadoFromA1(String marca, String safra, String multiplicador){
            
            return base.getPlantadoFromA1(marca,safra,multiplicador);
        }
        public List<AggregateResult> getValuesA4(String marca, String safra, String multiplicador){
            
            return base.getValuesA4(marca,safra,multiplicador);
        }
        public List<AggregateResult> getValuesA3(String marca, String safra, String multiplicador){
            
            return base.getValuesA3(marca,safra,multiplicador);
        }
        public List<AggregateResult> getValuesA2(String marca, String safra, String multiplicador){
            
            return base.getValuesA2(marca,safra,multiplicador);
        }
        public List<OpportunityLineItem> getAllForA4(String marca, String safra, String multiplicador){
            
            return base.getAllForA4(marca,safra,multiplicador);
        }
        public List<OpportunityLineItem> getAllForA3(String marca, String safra, String multiplicador){
            
            return base.getAllForA3(marca,safra,multiplicador);
        }
        public List<OpportunityLineItem> getAllForA2(String marca, String safra, String multiplicador){
            
            return base.getAllForA2(marca,safra,multiplicador);
        }
        public List<OpportunityLineItem> getAllDescarte(String marca, String safra, String multiplicador){
            
            return base.getAllDescarte(marca,safra,multiplicador);
        }
        public List<OpportunityLineItem> getAllApprovedForAttanchmentByMarcaBySafraByAccount(String accountId, String marca, String safra){
            return base.getAllApprovedForAttanchmentByMarcaBySafraByAccount(accountId,marca,safra);
        }

        public List<OpportunityLineItem> getOlisRebaixamento(String opp){
            return base.getOlisRebaixamento(opp);
        }

        public List<OpportunityLineItem> getOlisRebaixamento(List<String> opp){
            return base.getOlisRebaixamento(opp);
        }
    }
    private without sharing class DAOOpportunityLineItemWithoutSharing implements DAOIOpportunityLineItem{
        DAOOpportunityLineItemInheritSharing base = new DAOOpportunityLineItemInheritSharing();

        public List<OpportunityLineItem> get(Set<Id> ids){
            return base.get(ids);
        }
        public List<OpportunityLineItem> getByOpportunityId(String recordId){
            return base.getByOpportunityId(recordId);
        }
        public List<OpportunityLineItem> getByOpportunityId(List<String> recordId){
            return base.getByOpportunityId(recordId);
        }
        public List<AggregateResult> getByFiltrosForAnexoI(String anexo
                                                    , String name
                                                    , String opportunityId){
            return base.getByFiltrosForAnexoI(anexo,name,opportunityId);
        }
        public List<AggregateResult> getPlantadoFromA1(String marca, String safra, String multiplicador){
            
            return base.getPlantadoFromA1(marca,safra,multiplicador);
        }
        public List<AggregateResult> getValuesA4(String marca, String safra, String multiplicador){
            
            return base.getValuesA4(marca,safra,multiplicador);
        }
        public List<AggregateResult> getValuesA3(String marca, String safra, String multiplicador){
            
            return base.getValuesA3(marca,safra,multiplicador);
        }
        public List<AggregateResult> getValuesA2(String marca, String safra, String multiplicador){
            
            return base.getValuesA2(marca,safra,multiplicador);
        }
        public List<OpportunityLineItem> getAllForA4(String marca, String safra, String multiplicador){
            
            return base.getAllForA4(marca,safra,multiplicador);
        }
        public List<OpportunityLineItem> getAllForA3(String marca, String safra, String multiplicador){
            
            return base.getAllForA3(marca,safra,multiplicador);
        }
        public List<OpportunityLineItem> getAllForA2(String marca, String safra, String multiplicador){
            
            return base.getAllForA2(marca,safra,multiplicador);
        }
        public List<OpportunityLineItem> getAllDescarte(String marca, String safra, String multiplicador){
            
            return base.getAllDescarte(marca,safra,multiplicador);
        }
        public  List<OpportunityLineItem> getAllApprovedForAttanchmentByMarcaBySafraByAccount(String accountId, String marca, String safra){
            return base.getAllApprovedForAttanchmentByMarcaBySafraByAccount(accountId,marca,safra);
        }

        public List<OpportunityLineItem> getOlisRebaixamento(String opp){
            return base.getOlisRebaixamento(opp);
        }

        public List<OpportunityLineItem> getOlisRebaixamento(List<String> opp){
            return base.getOlisRebaixamento(opp);
        }
    }
    //This returns based on the parent sharing
    private inherited sharing class DAOOpportunityLineItemInheritSharing implements DAOIOpportunityLineItem{
        public List<OpportunityLineItem> get(Set<Id> ids){
            return [
                SELECT Id
                ,Name
                ,OpportunityId 
                FROM OpportunityLineItem 
                WHERE Id IN :ids
            ];
        }
        public List<OpportunityLineItem> getByOpportunityId(String recordId){
            return getByOpportunityId(new List<String>{recordId});
        }
        public List<OpportunityLineItem> getByOpportunityId(List<String> recordId){
            return [
                SELECT Id
                ,Name
                ,PricebookEntry.Product2.Variedade__c
                ,PriceBookEntry.Product2.Variedade__r.Name
                ,PriceBookEntry.Product2.Variedade__r.Nombre_de_Registro__c
                ,PriceBookEntry.Product2.Categ__r.Name
                ,Categoria__c
                ,categoria__r.Name
                ,PricebookEntry.Product2.UNIDADE__c
                ,Grupo_de_materiales_2__c
                ,Tratamiento_de_Semilla__c
                ,Area_Plantada__c
                ,Semente_bruta__c
                ,Semente_beneficiada__c
                ,Semente_aprovada__c
                ,Semente_uso_propio__c
                ,Semente_comercializada__c
                ,Descarte__c
                ,Categoria_a_Rebaixar__c
                ,Area__c
                ,Sem_Rebajada__c
                ,Qtde_Scs_40kg__c
                ,Lote_Rebajado__c
                ,Volume__c
                ,Expec_Prod_Bruta__c
                ,Estado_de_Comercializacion__c
                ,Local_de_Entrega__c
                ,Data__c
                ,Fecha_de_entrega__c
                ,Estado_de_Produccion__c
                ,Quantity
                ,Quantidade__c
                ,Meta__c
                ,Estimativa__c
                ,Quant_Confirmada__c
                ,Quant_Rechazada__c
                ,Quant_Pendiente__c
                ,UnitPrice
                ,Posicion_SAP_Relacionada__c
                ,Previsao__c
                ,Motivo_de_Rechazo__c
                ,PricebookEntry.Product2Id
                ,OpportunityId 
                ,Opportunity.Marca__c
                ,Opportunity.Safra__c
                ,Opportunity.AccountId
                ,Unidade_descarte__c
                FROM OpportunityLineItem 
                WHERE OpportunityId IN :recordId
                ORDER BY PriceBookEntry.Product2.Variedade__r.Name, Categoria__r.Name
            ];
        }

        public List<AggregateResult> getByFiltrosForAnexoI(String anexo
                                                    , String name
                                                    , String opportunityId){
            return [
                SELECT Id
                , Categoria_a_Rebaixar__c
                , PricebookEntry.Product2Id
                , Sum(Area__c) Area__c
                , Sum(Sem_Rebajada__c) Sem_Rebajada__c 
                From OpportunityLineItem 
                Where Opportunity.Anexo_Relacionado__c = :anexo
                AND Opportunity.RecordType.Name = :name
                AND OpportunityId != :opportunityId
                Group By Id, Categoria_a_Rebaixar__c, PricebookEntry.Product2Id 
                limit 500];
        }
        public List<AggregateResult> getPlantadoFromA1(String marca, String safra, String multiplicador){
            
            return [
                SELECT PricebookEntry.Product2Id, SUM(Area__c) 
                    FROM OpportunityLineItem
                    WHERE 
                    Opportunity.Marca__c = :marca
                    AND Opportunity.Safra__c = :safra
                    AND Opportunity.AccountId = :multiplicador
                    AND Opportunity.RecordType.Name = 'Anexo I'
                    GROUP BY PricebookEntry.Product2Id
            ];
        }
        
        public List<AggregateResult> getValuesA4(String marca, String safra, String multiplicador){
            
            return [
                SELECT PricebookEntry.Product2Id, SUM(Semente_aprovada__c) Semente_aprovada__c, SUM(Semente_comercializada__c) Semente_comercializada__c,
                    SUM(Semente_uso_propio__c) Semente_uso_propio__c
                    FROM OpportunityLineItem
                    WHERE 
                    Opportunity.Marca__c = :marca
                    AND Opportunity.Safra__c = :safra
                    AND Opportunity.AccountId = :multiplicador
                    AND (Opportunity.RecordType.Name = 'Anexo IV' OR Opportunity.RecordType.Name = 'Anexo_IV')
                    GROUP BY PricebookEntry.Product2Id
            ];
        }
        
        public List<AggregateResult> getValuesA3(String marca, String safra, String multiplicador){
            
            return [
                SELECT PricebookEntry.Product2Id, SUM(Semente_aprovada__c) Semente_aprovada__c, SUM(Semente_comercializada__c) Semente_comercializada__c,
                    SUM(Semente_uso_propio__c) Semente_uso_propio__c
                    FROM OpportunityLineItem
                    WHERE 
                    Opportunity.Marca__c = :marca
                    AND Opportunity.Safra__c = :safra
                    AND Opportunity.AccountId = :multiplicador
                    AND Opportunity.RecordType.Name = 'Anexo III'
                    GROUP BY PricebookEntry.Product2Id
            ];
        }
        
        public List<AggregateResult> getValuesA2(String marca, String safra, String multiplicador){
            
            return [
                SELECT PricebookEntry.Product2Id, SUM(Semente_comercializada__c) Semente_comercializada__c,
                    SUM(Semente_uso_propio__c) Semente_uso_propio__c
                    FROM OpportunityLineItem
                    WHERE 
                    Opportunity.Marca__c = :marca
                    AND Opportunity.Safra__c = :safra
                    AND Opportunity.AccountId = :multiplicador
                    AND Opportunity.RecordType.Name = 'Anexo II'
                    GROUP BY PricebookEntry.Product2Id
            ];
        }

        
        public List<OpportunityLineItem> getAllApprovedForAttanchmentByMarcaBySafraByAccount(String accountId, String marca, String safra){
            return [
                SELECT Id
                ,Name
                ,PricebookEntry.Product2.Variedade__c
                ,PriceBookEntry.Product2.Variedade__r.Name
                ,PriceBookEntry.Product2.Variedade__r.Nombre_de_Registro__c
                ,PriceBookEntry.Product2.Categ__r.Name
                ,Product2.UNIDADE__c
                ,PricebookEntryId
                ,Categoria__c
                ,categoria__r.Name
                ,PricebookEntry.Product2.UNIDADE__c
                ,Grupo_de_materiales_2__c
                ,Tratamiento_de_Semilla__c
                ,Area_Plantada__c
                ,Semente_bruta__c
                ,Semente_beneficiada__c
                ,Semente_aprovada__c
                ,Semente_uso_propio__c
                ,Semente_comercializada__c
                ,Descarte__c
                ,Categoria_a_Rebaixar__c
                ,Area__c
                ,Sem_Rebajada__c
                ,Qtde_Scs_40kg__c
                ,Lote_Rebajado__c
                ,Volume__c
                ,Expec_Prod_Bruta__c
                ,Estado_de_Comercializacion__c
                ,Local_de_Entrega__c
                ,Data__c
                ,Fecha_de_entrega__c
                ,Estado_de_Produccion__c
                ,Quantity
                ,Quantidade__c
                ,Meta__c
                ,Estimativa__c
                ,Quant_Confirmada__c
                ,Quant_Rechazada__c
                ,Quant_Pendiente__c
                ,UnitPrice
                ,Posicion_SAP_Relacionada__c
                ,Previsao__c
                ,Motivo_de_Rechazo__c
                ,PricebookEntry.Product2Id
                ,Opportunity.RecordType.DeveloperName
                ,Opportunity.RecordTypeId
                ,Opportunity.RecordType.Name
                ,OpportunityId 
                ,Opportunity.Marca__c
                ,Opportunity.Safra__c
                ,Opportunity.AccountId
                ,Unidade_descarte__c
                FROM OpportunityLineItem 
                WHERE Opportunity.Marca__c = :marca
                AND Opportunity.Safra__c = :safra
                AND Opportunity.AccountId = :accountId
                AND Opportunity.StageName = 'Aprobada'
                
            ];
        }

        public List<OpportunityLineItem> getOlisRebaixamento(String opp){
            return [
                SELECT Id
                ,Name
                ,PricebookEntry.Product2.Variedade__c
                ,PriceBookEntry.Product2.Variedade__r.Name
                ,PriceBookEntry.Product2.Variedade__r.Nombre_de_Registro__c
                ,PriceBookEntry.Product2.Categ__r.Name
                ,Product2.UNIDADE__c
                ,PricebookEntryId
                ,Categoria__c
                ,categoria__r.Name
                ,PricebookEntry.Product2.UNIDADE__c
                ,Grupo_de_materiales_2__c
                ,Tratamiento_de_Semilla__c
                ,Area_Plantada__c
                ,Semente_bruta__c
                ,Semente_beneficiada__c
                ,Semente_aprovada__c
                ,Semente_uso_propio__c
                ,Semente_comercializada__c
                ,Descarte__c
                ,Categoria_a_Rebaixar__c
                ,Area__c
                ,Sem_Rebajada__c
                ,Qtde_Scs_40kg__c
                ,Lote_Rebajado__c
                ,Volume__c
                ,Expec_Prod_Bruta__c
                ,Estado_de_Comercializacion__c
                ,Local_de_Entrega__c
                ,Data__c
                ,Fecha_de_entrega__c
                ,Estado_de_Produccion__c
                ,Quantity
                ,Quantidade__c
                ,Meta__c
                ,Estimativa__c
                ,Quant_Confirmada__c
                ,Quant_Rechazada__c
                ,Quant_Pendiente__c
                ,UnitPrice
                ,Posicion_SAP_Relacionada__c
                ,Previsao__c
                ,Motivo_de_Rechazo__c
                ,PricebookEntry.Product2Id
                ,Opportunity.RecordType.DeveloperName
                ,Opportunity.RecordTypeId
                ,Opportunity.RecordType.Name
                ,OpportunityId 
                ,Opportunity.Marca__c
                ,Opportunity.Safra__c
                ,Opportunity.AccountId
                ,Unidade_descarte__c
                FROM OpportunityLineItem 
                WHERE Opportunity.Anexo_Relacionado__c = :opp
                
                
            ];
        }

        public List<OpportunityLineItem> getOlisRebaixamento(List<String> opp){
            return [
                SELECT Id
                ,Name
                ,PricebookEntry.Product2.Variedade__c
                ,PriceBookEntry.Product2.Variedade__r.Name
                ,PriceBookEntry.Product2.Variedade__r.Nombre_de_Registro__c
                ,PriceBookEntry.Product2.Categ__r.Name
                ,Product2.UNIDADE__c
                ,PricebookEntryId
                ,Categoria__c
                ,categoria__r.Name
                ,PricebookEntry.Product2.UNIDADE__c
                ,Grupo_de_materiales_2__c
                ,Tratamiento_de_Semilla__c
                ,Area_Plantada__c
                ,Semente_bruta__c
                ,Semente_beneficiada__c
                ,Semente_aprovada__c
                ,Semente_uso_propio__c
                ,Semente_comercializada__c
                ,Descarte__c
                ,Categoria_a_Rebaixar__c
                ,Area__c
                ,Sem_Rebajada__c
                ,Qtde_Scs_40kg__c
                ,Lote_Rebajado__c
                ,Volume__c
                ,Expec_Prod_Bruta__c
                ,Estado_de_Comercializacion__c
                ,Local_de_Entrega__c
                ,Data__c
                ,Fecha_de_entrega__c
                ,Estado_de_Produccion__c
                ,Quantity
                ,Quantidade__c
                ,Meta__c
                ,Estimativa__c
                ,Quant_Confirmada__c
                ,Quant_Rechazada__c
                ,Quant_Pendiente__c
                ,UnitPrice
                ,Posicion_SAP_Relacionada__c
                ,Previsao__c
                ,Motivo_de_Rechazo__c
                ,PricebookEntry.Product2Id
                ,Opportunity.RecordType.DeveloperName
                ,Opportunity.RecordTypeId
                ,Opportunity.RecordType.Name
                ,OpportunityId 
                ,Opportunity.Marca__c
                ,Opportunity.Safra__c
                ,Opportunity.AccountId
                , Unidade_descarte__c
                FROM OpportunityLineItem 
                WHERE Opportunity.Anexo_Relacionado__c IN :opp
                
                
            ];
        }
        public List<OpportunityLineItem> getAllForA4(String marca, String safra, String multiplicador){
            return [
                SELECT Id
                ,Name
                ,PricebookEntry.Product2.Variedade__c
                ,PriceBookEntry.Product2.Variedade__r.Name
                ,PriceBookEntry.Product2.Variedade__r.Nombre_de_Registro__c
                ,PriceBookEntry.Product2.Categ__r.Name
                ,Product2.UNIDADE__c
                ,PricebookEntryId
                ,Categoria__c
                ,categoria__r.Name
                ,PricebookEntry.Product2.UNIDADE__c
                ,Grupo_de_materiales_2__c
                ,Tratamiento_de_Semilla__c
                ,Area_Plantada__c
                ,Semente_bruta__c
                ,Semente_beneficiada__c
                ,Semente_aprovada__c
                ,Semente_uso_propio__c
                ,Semente_comercializada__c
                ,Descarte__c
                ,Categoria_a_Rebaixar__c
                ,Area__c
                ,Sem_Rebajada__c
                ,Qtde_Scs_40kg__c
                ,Lote_Rebajado__c
                ,Volume__c
                ,Expec_Prod_Bruta__c
                ,Estado_de_Comercializacion__c
                ,Local_de_Entrega__c
                ,Data__c
                ,Fecha_de_entrega__c
                ,Estado_de_Produccion__c
                ,Quantity
                ,Quantidade__c
                ,Meta__c
                ,Estimativa__c
                ,Quant_Confirmada__c
                ,Quant_Rechazada__c
                ,Quant_Pendiente__c
                ,UnitPrice
                ,Posicion_SAP_Relacionada__c
                ,Previsao__c
                ,Motivo_de_Rechazo__c
                ,PricebookEntry.Product2Id
                ,Opportunity.RecordType.DeveloperName
                ,Opportunity.RecordTypeId
                ,Opportunity.RecordType.Name
                ,OpportunityId 
                ,Opportunity.Marca__c
                ,Opportunity.Safra__c
                ,Opportunity.AccountId
                , Unidade_descarte__c
                FROM OpportunityLineItem 
                WHERE Opportunity.Marca__c = :marca
                AND Opportunity.Safra__c = :safra
                AND Opportunity.AccountId = :multiplicador
                AND Opportunity.RecordType.DeveloperName = 'Anexo_IV'
                AND Opportunity.StageName = 'Aprobada'
                
            ];
        }
        
        
        public List<OpportunityLineItem> getAllForA3(String marca, String safra, String multiplicador){
            return [
                SELECT Id
                ,Name
                ,PricebookEntry.Product2.Variedade__c
                ,PriceBookEntry.Product2.Variedade__r.Name
                ,PriceBookEntry.Product2.Variedade__r.Nombre_de_Registro__c
                ,PriceBookEntry.Product2.Categ__r.Name
                ,Product2.UNIDADE__c
                ,PricebookEntryId
                ,Categoria__c
                ,categoria__r.Name
                ,PricebookEntry.Product2.UNIDADE__c
                ,Grupo_de_materiales_2__c
                ,Tratamiento_de_Semilla__c
                ,Area_Plantada__c
                ,Semente_bruta__c
                ,Semente_beneficiada__c
                ,Semente_aprovada__c
                ,Semente_uso_propio__c
                ,Semente_comercializada__c
                ,Descarte__c
                ,Categoria_a_Rebaixar__c
                ,Area__c
                ,Sem_Rebajada__c
                ,Qtde_Scs_40kg__c
                ,Lote_Rebajado__c
                ,Volume__c
                ,Expec_Prod_Bruta__c
                ,Estado_de_Comercializacion__c
                ,Local_de_Entrega__c
                ,Data__c
                ,Fecha_de_entrega__c
                ,Estado_de_Produccion__c
                ,Quantity
                ,Quantidade__c
                ,Meta__c
                ,Estimativa__c
                ,Quant_Confirmada__c
                ,Quant_Rechazada__c
                ,Quant_Pendiente__c
                ,UnitPrice
                ,Posicion_SAP_Relacionada__c
                ,Previsao__c
                ,Motivo_de_Rechazo__c
                ,PricebookEntry.Product2Id
                ,Opportunity.RecordType.DeveloperName
                ,Opportunity.RecordTypeId
                ,Opportunity.RecordType.Name
                ,OpportunityId 
                ,Opportunity.Marca__c
                ,Opportunity.Safra__c
                ,Opportunity.AccountId
                , Unidade_descarte__c
                FROM OpportunityLineItem 
                WHERE Opportunity.Marca__c = :marca
                AND Opportunity.Safra__c = :safra
                AND Opportunity.AccountId = :multiplicador
                AND Opportunity.RecordType.DeveloperName = 'Anexo_III'
                AND Opportunity.StageName = 'Aprobada'
                
            ];
        }
        public List<OpportunityLineItem> getAllForA2(String marca, String safra, String multiplicador){
            return [
                SELECT Id
                ,Name
                ,PricebookEntry.Product2.Variedade__c
                ,PriceBookEntry.Product2.Variedade__r.Name
                ,PriceBookEntry.Product2.Variedade__r.Nombre_de_Registro__c
                ,PriceBookEntry.Product2.Categ__r.Name
                ,Product2.UNIDADE__c
                ,PricebookEntryId
                ,Categoria__c
                ,categoria__r.Name
                ,PricebookEntry.Product2.UNIDADE__c
                ,Grupo_de_materiales_2__c
                ,Tratamiento_de_Semilla__c
                ,Area_Plantada__c
                ,Semente_bruta__c
                ,Semente_beneficiada__c
                ,Semente_aprovada__c
                ,Semente_uso_propio__c
                ,Semente_comercializada__c
                ,Descarte__c
                ,Categoria_a_Rebaixar__c
                ,Area__c
                ,Sem_Rebajada__c
                ,Qtde_Scs_40kg__c
                ,Lote_Rebajado__c
                ,Volume__c
                ,Expec_Prod_Bruta__c
                ,Estado_de_Comercializacion__c
                ,Local_de_Entrega__c
                ,Data__c
                ,Fecha_de_entrega__c
                ,Estado_de_Produccion__c
                ,Quantity
                ,Quantidade__c
                ,Meta__c
                ,Estimativa__c
                ,Quant_Confirmada__c
                ,Quant_Rechazada__c
                ,Quant_Pendiente__c
                ,UnitPrice
                ,Posicion_SAP_Relacionada__c
                ,Previsao__c
                ,Motivo_de_Rechazo__c
                ,PricebookEntry.Product2Id
                ,Opportunity.RecordType.DeveloperName
                ,Opportunity.RecordTypeId
                ,Opportunity.RecordType.Name
                ,OpportunityId 
                ,Opportunity.Marca__c
                ,Opportunity.Safra__c
                ,Opportunity.AccountId
                , Unidade_descarte__c
                FROM OpportunityLineItem 
                WHERE Opportunity.Marca__c = :marca
                AND Opportunity.Safra__c = :safra
                AND Opportunity.AccountId = :multiplicador
                AND Opportunity.RecordType.DeveloperName = 'AnexoII'
                AND Opportunity.StageName = 'Aprobada'
                
            ];
        }
        public List<OpportunityLineItem> getAllDescarte(String marca, String safra, String multiplicador){
            return [
                SELECT Id
                ,Name
                ,PricebookEntry.Product2.Variedade__c
                ,PriceBookEntry.Product2.Variedade__r.Name
                ,PriceBookEntry.Product2.Variedade__r.Nombre_de_Registro__c
                ,PriceBookEntry.Product2.Categ__r.Name
                ,Product2.UNIDADE__c
                ,PricebookEntryId
                ,Categoria__c
                ,categoria__r.Name
                ,PricebookEntry.Product2.UNIDADE__c
                ,Grupo_de_materiales_2__c
                ,Tratamiento_de_Semilla__c
                ,Area_Plantada__c
                ,Semente_bruta__c
                ,Semente_beneficiada__c
                ,Semente_aprovada__c
                ,Semente_uso_propio__c
                ,Semente_comercializada__c
                ,Descarte__c
                ,Categoria_a_Rebaixar__c
                ,Area__c
                ,Sem_Rebajada__c
                ,Qtde_Scs_40kg__c
                ,Lote_Rebajado__c
                ,Volume__c
                ,Expec_Prod_Bruta__c
                ,Estado_de_Comercializacion__c
                ,Local_de_Entrega__c
                ,Data__c
                ,Fecha_de_entrega__c
                ,Estado_de_Produccion__c
                ,Quantity
                ,Quantidade__c
                ,Meta__c
                ,Estimativa__c
                ,Quant_Confirmada__c
                ,Quant_Rechazada__c
                ,Quant_Pendiente__c
                ,UnitPrice
                ,Posicion_SAP_Relacionada__c
                ,Previsao__c
                ,Motivo_de_Rechazo__c
                ,PricebookEntry.Product2Id
                ,Opportunity.RecordType.DeveloperName
                ,Opportunity.RecordTypeId
                ,Opportunity.RecordType.Name
                ,OpportunityId 
                ,Opportunity.Marca__c
                ,Opportunity.Safra__c
                ,Opportunity.AccountId
                , Unidade_descarte__c
                FROM OpportunityLineItem 
                WHERE Opportunity.Marca__c = :marca
                AND Opportunity.Safra__c = :safra
                AND Opportunity.AccountId = :multiplicador
                AND Opportunity.RecordType.DeveloperName = 'Descarte'
                AND Opportunity.StageName = 'Aprobada'
                
            ];
        }
        
    }
}
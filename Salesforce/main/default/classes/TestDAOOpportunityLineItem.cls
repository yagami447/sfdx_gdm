@isTest
public class TestDAOOpportunityLineItem {
    @isTest public static void test(){
        Account acc = new Account(Name = 'Teste');
        Contrato__c cont = new Contrato__c();
        cont.Multiplicador__c = acc.Id;
        cont.Safra__c = '19/20';
        cont.Sociedad__c = 'NEOG';
        insert cont;
        Product2 prod = new Product2(Name = 'Test');
        prod.IsActive = true;
        insert prod;
        Item_del_Contrato__c icon = new Item_del_Contrato__c();
        icon.Cultivar__c = prod.Id;
        icon.Contrato_de_Multiplicacion__c = cont.Id;
        insert icon;
        Opportunity opp = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '18/19');
        opp.Pricebook2Id = Test.getStandardPricebookId();
        insert opp;
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 0;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.IsActive = true;
        insert pbe;

        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.PricebookEntryId = pbe.Id;
        oli.UnitPrice = 0;
        oli.Quantity = 14;
        insert oli;

        /*
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
         */

        
        DAOOpportunityLineItem.getInstance().get(new Set<Id> {oli.Id});
        DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).get(new Set<Id> {oli.Id});

        
        DAOOpportunityLineItem.getInstance().getByOpportunityId(opp.Id);
        DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(opp.Id);
        DAOOpportunityLineItem.getInstance().getByOpportunityId(new List<Id> {opp.Id});
        DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(new List<Id> {opp.Id});
        DAOOpportunityLineItem.getInstance().getPlantadoFromA1('NEOG', '18/19', acc.Id);
        DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getPlantadoFromA1('NEOG', '18/19', acc.Id);
        DAOOpportunityLineItem.getInstance().getValuesA4('NEOG', '18/19', acc.Id);
        DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getValuesA4('NEOG', '18/19', acc.Id);
        DAOOpportunityLineItem.getInstance().getValuesA3('NEOG', '18/19', acc.Id);
        DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getValuesA3('NEOG', '18/19', acc.Id);
        DAOOpportunityLineItem.getInstance().getValuesA2('NEOG', '18/19', acc.Id);
        DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getValuesA2('NEOG', '18/19', acc.Id);

        
        
      
    }
}
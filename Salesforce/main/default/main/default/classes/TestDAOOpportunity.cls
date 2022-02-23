@IsTest
public class TestDAOOpportunity {
    @isTest public static void test(){
        Account acc = new Account(Name = 'Teste');
        Contrato__c cont = new Contrato__c();
        cont.Multiplicador__c = acc.Id;
        cont.Safra__c = '19/20';
        cont.Sociedad__c = 'NEOG';
        insert cont;
        Product2 prod = new Product2(Name = 'Test');
        Item_del_Contrato__c icon = new Item_del_Contrato__c();
        icon.Cultivar__c = prod.Id;
        icon.Contrato_de_Multiplicacion__c = cont.Id;
        insert icon;
        Opportunity opp = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '18/19');
        insert opp;
        
        DAOOpportunity.getInstance().get(opp.Id);
        DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).get(opp.Id);

        DAOOpportunity.getInstance().get(opp.Id);
        DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).get(new List<Id> {opp.Id});

        
        DAOOpportunity.getInstance().getByFilter('NEOG', '19/20', acc.Id, new List<String> {'Anexo I'}, 'Edición');
        DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).getByFilter('NEOG', '19/20', acc.Id, new List<String> {'Anexo I'}, 'Edición');

        
      
    }
    
}
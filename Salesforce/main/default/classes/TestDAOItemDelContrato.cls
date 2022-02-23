@isTest
public class TestDAOItemDelContrato {
    @isTest public static void test(){
        Account acc = new Account(Name = 'Teste');
        insert acc;
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
        DAOItemDelContrato.getInstance().getByMarcaBySafraByMultiplicador('NEOG', '19/20', acc.Id);
        DAOItemDelContrato.getInstance(DTOUtils.SharingMode.Without).getByMarcaBySafraByMultiplicador('NEOG', '19/20', acc.Id);


        
    }
}
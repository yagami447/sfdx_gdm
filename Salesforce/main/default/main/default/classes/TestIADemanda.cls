@isTest
private class TestIADemanda {

    static testMethod void testTodo() {
        Analitica_DemandaVsVenta__c a = new Analitica_DemandaVsVenta__c ();
        insert a;
        a.ProductName__c = 'SACA SEM. 7166RSF IPRO BASICA X 40 KG';
        update a;
        a.ProductName__c = 'SACA SEM';
        update a;
    }
}
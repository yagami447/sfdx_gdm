@isTest
private class ScheduActualizarIATest {

   	static testmethod void test(){
		
		Product2 p = new Product2(Name='PROD',isActive=true); insert p;
		Analitica_DemandaVsVenta__c a = new Analitica_DemandaVsVenta__c(ProductName__c='PROD');
		insert a;
		
		Test.startTest();
		ScheduActualizarIADemanda act = new ScheduActualizarIADemanda();		
		String sche = '0 0 23 * * ?';
		System.schedule('Update', sche, act);
		Test.stopTest();
		
	}
	
}
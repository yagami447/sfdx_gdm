@isTest
public class opportunitySacasExtensionTest{
	@isTest(SeeAllData = true)
	static void test(){

		Map<String, Id> rt = new Map<String, Id>();
		for (RecordType reTy : [Select Id, Name
		                        From RecordType
		                        Where sObjectType = 'Opportunity'])
			rt.put(reTy.Name, reTy.Id);
		opportunitySacasExtension anexos = new opportunitySacasExtension();

		anexos.searchAnexos();
		anexos.listarAnexos();
		String a;
		anexos.setetapaAnexo(a);
		a = anexos.getetapaAnexo();
		List<SelectOption> op = new List<SelectOption>();
		op = anexos.getEtapasAnexos();
		op = anexos.getTiposAnexos();
		anexos.getResultAnexos();
		List<OpportunityLineItem> items = new List<OpportunityLineItem>();

		Categoria__c cat = [SELECT Id, Name
		                    FROM Categoria__c
		                    WHERE Name = 'BASICA'
		                    limit 1];

		Account cuenta = [Select Id
		                  From Account
		                  Where Name = 'ACME'
		                  limit 1];
		Pricebook2 pb = [Select Id, Name
		                 From Pricebook2
		                 where Name = 'Lista de Básica BMX SUL' and isActive = true
		                 limit 1];
		Opportunity prevision = new Opportunity(RecordTypeId = rt.get('Previsao'), Name = 'Previsao', AccountId = cuenta.Id, Pricebook2Id = pb.Id, CloseDate = System.today(), Marca__c = 'BRMX', StageName = 'Aberta', Safra__c = '12/13');
		//insert prevision;
		PricebookEntry pbe = [Select Id, Product2Id
		                      From PricebookEntry
		                      where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id
		                      limit 1];

		OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId = prevision.Id, Quantity = 0.01, Previsao__c = 50, TotalPrice = 10, PricebookEntryId = pbe.Id);
		//insert oi2;
	}

	@isTest(SeeAllData = true)
	static void test2(){

		Map<String, Id> rt = new Map<String, Id>();
		for (RecordType reTy : [Select Id, Name
		                        From RecordType
		                        Where sObjectType = 'Opportunity'])
			rt.put(reTy.Name, reTy.Id);
		opportunitySacasExtension anexos = new opportunitySacasExtension();

		List<OpportunityLineItem> items = new List<OpportunityLineItem>();

		Categoria__c cat = [SELECT Id, Name
		                    FROM Categoria__c
		                    WHERE Name = 'BASICA'
		                    limit 1];

		Account cuenta = [Select Id
		                  From Account
		                  Where Name = 'ACME'
		                  limit 1];
		Pricebook2 pb = [Select Id, Name
		                 From Pricebook2
		                 where Name = 'Lista de Básica BMX SUL' and isActive = true
		                 limit 1];
		Opportunity prevision = new Opportunity(RecordTypeId = rt.get('Previsao'), Name = 'Previsao', AccountId = cuenta.Id, Pricebook2Id = pb.Id, CloseDate = System.today(), Marca__c = 'BRMX', StageName = 'Aberta', Safra__c = '12/13');
		insert prevision;
		PricebookEntry pbe = [Select Id, Product2Id
		                      From PricebookEntry
		                      where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id
		                      limit 1];

		OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId = prevision.Id, Quantity = 0.01, Previsao__c = 50, TotalPrice = 10, PricebookEntryId = pbe.Id);
		insert oi2;


		ApexPages.currentPage().getParameters().put('id', prevision.Id);
		items = anexos.getItems();
		List<Schema.FieldSetMember> b = anexos.getFields();

		Opportunity prueba1 = new Opportunity(RecordTypeId = rt.get('VB - Pendiente'), Name = 'Prueba1', AccountId = cuenta.Id, Pricebook2Id = pb.Id, CloseDate = System.today(), Marca__c = 'BRMX', StageName = 'Aberta', Safra__c = '12/13');
		insert prueba1;

		OpportunityLineItem p1oi2 = new OpportunityLineItem(OpportunityId = prevision.Id, Quantity = 0.01, Previsao__c = 50, TotalPrice = 10, PricebookEntryId = pbe.Id);
		insert p1oi2;

		ApexPages.currentPage().getParameters().put('id', prueba1.Id);
		anexos.getFields();

		Opportunity prueba2 = new Opportunity(RecordTypeId = rt.get('Disponibilidade da Basica'), Name = 'Prueba2', AccountId = cuenta.Id, Pricebook2Id = pb.Id, CloseDate = System.today(), Marca__c = 'BRMX', StageName = 'Aberta', Safra__c = '12/13');
		insert prueba2;

		OpportunityLineItem p2oi2 = new OpportunityLineItem(OpportunityId = prevision.Id, Quantity = 0.01, Previsao__c = 50, TotalPrice = 10, PricebookEntryId = pbe.Id);
		Test.StartTest();
		insert p2oi2;
		Test.StopTest();

		ApexPages.currentPage().getParameters().put('id', prueba2.Id);
		anexos.getFields();

		Opportunity prueba3 = new Opportunity(RecordTypeId = rt.get('Stock Multiplicadores'), Name = 'Prueba1', AccountId = cuenta.Id, Pricebook2Id = pb.Id, CloseDate = System.today(), Marca__c = 'BRMX', StageName = 'Aberta', Safra__c = '12/13');
		insert prueba3;


		ApexPages.currentPage().getParameters().put('id', prueba3.Id);
		anexos.getFields();

		Opportunity prueba4 = new Opportunity(RecordTypeId = rt.get('Rechazada'), Name = 'Prueba1', AccountId = cuenta.Id, Pricebook2Id = pb.Id, CloseDate = System.today(), Marca__c = 'BRMX', StageName = 'Aberta', Safra__c = '12/13');
		insert prueba4;


		ApexPages.currentPage().getParameters().put('id', prueba4.Id);
		anexos.getFields();
	}
    

	@isTest(SeeAllData = true)
	static void test3(){

		Map<String, Id> rt = new Map<String, Id>();
		for (RecordType reTy : [Select Id, Name
		                        From RecordType
		                        Where sObjectType = 'Opportunity'])
			rt.put(reTy.Name, reTy.Id);
		opportunitySacasExtension anexos = new opportunitySacasExtension();

		List<OpportunityLineItem> items = new List<OpportunityLineItem>();

		Categoria__c cat = [SELECT Id, Name
		                    FROM Categoria__c
		                    WHERE Name = 'BASICA'
		                    limit 1];

		Account cuenta = [Select Id
		                  From Account
		                  Where Name = 'ACME'
		                  limit 1];
		Pricebook2 pb = [Select Id, Name
		                 From Pricebook2
		                 where Name = 'Lista de Básica BMX SUL' and isActive = true
		                 limit 1];
		Opportunity prevision = new Opportunity(RecordTypeId = rt.get('Previsao'), Name = 'Previsao', AccountId = cuenta.Id, Pricebook2Id = pb.Id, CloseDate = System.today(), Marca__c = 'BRMX', StageName = 'Aberta', Safra__c = '12/13');
		insert prevision;
		PricebookEntry pbe = [Select Id, Product2Id
		                      From PricebookEntry
		                      where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id
		                      limit 1];

		OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId = prevision.Id, Quantity = 0.01, Previsao__c = 50, TotalPrice = 10, PricebookEntryId = pbe.Id);
		insert oi2;


		ApexPages.currentPage().getParameters().put('id', prevision.Id);
		items = anexos.getItems();
		List<Schema.FieldSetMember> b = anexos.getFields();

		Opportunity prueba5 = new Opportunity(RecordTypeId = rt.get('Pendiente'), Name = 'Prueba1', AccountId = cuenta.Id, Pricebook2Id = pb.Id, CloseDate = System.today(), Marca__c = 'BRMX', StageName = 'Aberta', Safra__c = '12/13');
		insert prueba5;


		ApexPages.currentPage().getParameters().put('id', prueba5.Id);
		anexos.getFields();

		Opportunity prueba6 = new Opportunity(RecordTypeId = rt.get('Anexo V'), Name = 'Prueba1', AccountId = cuenta.Id, Pricebook2Id = pb.Id, CloseDate = System.today(), Marca__c = 'BRMX', StageName = 'Aberta', Safra__c = '12/13');
		insert prueba6;


		ApexPages.currentPage().getParameters().put('id', prueba6.Id);
		anexos.getFields();

		Opportunity prueba7 = new Opportunity(RecordTypeId = rt.get('Anexo IV'), Name = 'Prueba1', AccountId = cuenta.Id, Pricebook2Id = pb.Id, CloseDate = System.today(), Marca__c = 'BRMX', StageName = 'Aberta', Safra__c = '12/13');
		Test.StartTest();
		insert prueba7;
		Test.StopTest();


		ApexPages.currentPage().getParameters().put('id', prueba7.Id);
		anexos.getFields();

		Opportunity prueba8 = new Opportunity(RecordTypeId = rt.get('Anexo III'), Name = 'Prueba1', AccountId = cuenta.Id, Pricebook2Id = pb.Id, CloseDate = System.today(), Marca__c = 'BRMX', StageName = 'Aberta', Safra__c = '12/13');
		insert prueba8;


		ApexPages.currentPage().getParameters().put('id', prueba8.Id);
		anexos.getFields();

		anexos.anexo = 'A1';
		anexos.searchAnexos();
		anexos.anexo = 'A2';
		anexos.searchAnexos();
		anexos.anexo = 'A3';
		anexos.searchAnexos();
		anexos.anexo = 'A4';
		anexos.searchAnexos();
		anexos.anexo = 'A5';
		anexos.searchAnexos();
		anexos.anexo = 'ALL';
		anexos.searchAnexos();

		anexos.etapaAnexo = 'PEAN';
		anexos.searchAnexos();
		anexos.etapaAnexo = 'PEAP';
		anexos.searchAnexos();
		anexos.etapaAnexo = 'APR';
		anexos.searchAnexos();

		for (AggregateResult ar : [Select Max(Id)id, RecordType.Name rt
		                           From Opportunity
		                           Where RecordType.Name In ('Anexo I', 'Anexo II', 'NC - Autorizada', 'Autorizada', 'Anexo I Rebaixamento Ha', 'Anexo II Rebaixamento Sacas', 'VB - Pasada SAP', 'CVB Autorizada', 'PB-Comercial', 'Exportacion', 'Objetivo Ventas Semilla', 'Objetivo Ventas Royalties', 'Objetivo Contrato Royalties')
		                           Group By RecordType.Name]){
			apexpages.currentpage().getparameters().put('Id', String.valueOf(ar.get('id')));
			anexos.getFields();
		}
	}
}
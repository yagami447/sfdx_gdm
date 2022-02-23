@isTest
public class aSiteAppendixPrintControllerTest{
	@TestSetup
	static void makeData(){
		Account acc = new Account(Name = 'Acc');
		insert acc;

		SiteUser__c siteUser = new SiteUser__c();
		siteUser.Active__c = true;
		siteUser.Email__c = 'site@user.com';
		siteUser.Password__c = '123';
		siteUser.Address__c = 'address';
		siteUser.Name = 'site user';
		siteUser.Site__c = '';
		siteUser.Occupation__c = 'Dev';
		siteUser.Phone__c = '223';
		siteUser.MobilePhone__c = '445';
		siteUser.Habilitado_Votacion_DSEM__c = true;
		siteUser.Habilitado_Anexos__c = true;
		siteUser.Habilitado_Eventos__c = true;
		siteUser.Habilitar_Royalty__c = true;
		siteUser.Habilitar_Venda_de_Basica__c = true;
		insert siteUser;

		SiteUserSession__c session = new SiteUserSession__c();
		session.SiteUser__c = siteUser.id;
		session.Marca__c = 'BRMX';
		insert session;

		SiteUserAccount__c siteAccount = new SiteUserAccount__c();
		siteAccount.SiteUser__c = siteUser.id;
		siteAccount.Account__c = acc.id;
		siteAccount.Active__c = true;
		insert siteAccount;

		Product2 product = new Product2();
		product.name = 'product';
		insert product;
		PricebookEntry entry = new PricebookEntry();
		entry.Pricebook2Id = Test.getStandardPricebookId();
		entry.UnitPrice = 100;
		entry.Product2Id = product.id;
		entry.IsActive = true;
		insert entry;
		Opportunity opp = new Opportunity();
		opp.Name = 'Testing opp';
		opp.StageName = 'Edición';
		opp.CloseDate = System.today();
		opp.Marca__c = 'BRMX';
		insert opp;

		OpportunityLineItem oli = new OpportunityLineItem();
		oli.Item_Rebajado__c = false;
		oli.OpportunityId = opp.id;
		oli.Quantity = 1;
		oli.TotalPrice = 100;
		oli.PricebookEntryId = entry.id;
		insert oli;
	}

	@isTest
	private static void validate(){
		Opportunity opp = [SELECT id, Name
		                   FROM Opportunity];

		ApexPages.StandardController standardController;
		System.currentPageReference().getParameters().put('id', opp.id);
		System.currentPageReference().getParameters().put('token', null);
		aSiteAppendixPrintController controller = new aSiteAppendixPrintController(standardController);
		controller.validate();
	}

	@isTest
	private static void getFieldsAnexoII(){
		Opportunity opp = [SELECT id, Name
		                   FROM Opportunity];

		SiteUserSession__c session = [SELECT ID
		                              FROM SiteUserSession__c];

		ApexPages.StandardController standardController;
		System.currentPageReference().getParameters().put('id', opp.id);
		System.currentPageReference().getParameters().put('token', session.id);
		opp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo II').getRecordTypeId();
		update opp;

		aSiteAppendixPrintController controller = new aSiteAppendixPrintController(standardController);
        controller.validate();
		controller.getFields();
		
	}

   
    @isTest
	private static void getFieldsAnexoIII(){
		Opportunity opp = [SELECT id, Name
		                   FROM Opportunity];

		SiteUserSession__c session = [SELECT ID
		                              FROM SiteUserSession__c];

		ApexPages.StandardController standardController;
		System.currentPageReference().getParameters().put('id', opp.id);
		System.currentPageReference().getParameters().put('token', session.id);
		opp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo III').getRecordTypeId();
		update opp;

		aSiteAppendixPrintController controller = new aSiteAppendixPrintController(standardController);
		controller.getFields();
		
	}

    @isTest
	private static void getFieldsAnexoIV(){
		Opportunity opp = [SELECT id, Name
		                   FROM Opportunity];

		SiteUserSession__c session = [SELECT ID
		                              FROM SiteUserSession__c];

		ApexPages.StandardController standardController;
		System.currentPageReference().getParameters().put('id', opp.id);
		System.currentPageReference().getParameters().put('token', session.id);
		opp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo IV').getRecordTypeId();
		update opp;

		aSiteAppendixPrintController controller = new aSiteAppendixPrintController(standardController);
		controller.getFields();
		
	}

    @isTest
	private static void getFieldsAnexoV(){
		Opportunity opp = [SELECT id, Name
		                   FROM Opportunity];

		SiteUserSession__c session = [SELECT ID
		                              FROM SiteUserSession__c];

		ApexPages.StandardController standardController;
		System.currentPageReference().getParameters().put('id', opp.id);
		System.currentPageReference().getParameters().put('token', session.id);
		opp.RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo V').getRecordTypeId();
		update opp;

		aSiteAppendixPrintController controller = new aSiteAppendixPrintController(standardController);
		controller.getFields();
		
	}
}
@isTest
public class aSiteEstoqueControllerTest{
	@TestSetup
	static void makeData(){

		SiteUser__c siteUser = new SiteUser__c();
		siteUser.Active__c = true;
		siteUser.Email__c = 'site@user.com';
		siteUser.Password__c = '123';
		siteUser.Address__c = 'address';
		siteUser.Name = 'Site user';
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

		Product2 product = new Product2();
		product.name = 'product';
		insert product;

		Regiao__c region = new Regiao__c();
		region.Region_Comercial__c = 'REGION 1';
		insert region;
		Votacion_balotage__c balotage = new Votacion_balotage__c();
		balotage.Region_Comercial__c = 'SUL';
		balotage.Producto__c = product.id;
		balotage.Variedad__c = product.name;
		insert balotage;

		Account acc = new Account(Name = 'Acc');
		acc.Region__c = region.id;
		insert acc;

		SiteUserAccount__c siteAccount = new SiteUserAccount__c();
		siteAccount.SiteUser__c = siteUser.id;
		siteAccount.Account__c = acc.id;
		siteAccount.Active__c = true;
		insert siteAccount;


		PricebookEntry entry = new PricebookEntry();
		entry.Pricebook2Id = Test.getStandardPricebookId();
		entry.UnitPrice = 100;
		entry.Product2Id = product.id;
		entry.IsActive = true;
		insert entry;
		Opportunity opp = new Opportunity();
		opp.Name = 'Testing opp';		
		opp.CloseDate = System.today();
		opp.Marca__c = 'BRMX';
		opp.Motivo_de_Rechazo__c = 'RECHAZADO';
        opp.AccountId = acc.id;
        opp.Safra__c = aAppManager.getSafraActualByApp('Estoque');
        opp.StageName = 'Aprobada';// != anulado
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Stock_Multiplicadores').getRecordTypeId();
        opp.Mes__c = 'Fevereiro';
		insert opp;
        
        System.debug('In test setup  opp.stageName: '+opp.stageName );
		OpportunityLineItem oli = new OpportunityLineItem();
		oli.Item_Rebajado__c = false;
		oli.OpportunityId = opp.id;
		oli.Quantity = 1;
		oli.TotalPrice = 100;
		oli.PricebookEntryId = entry.id;
		insert oli;
        Configuracion_BMX__c config = new Configuracion_BMX__c(Name='Facturacion');
        config.PM_Estoque_Dia_Desde__c = 1;
        config.PM_Estoque_Dia_Hasta__c = 4;
        insert config;
        
	}

	@isTest
	private static void validateWithToken(){
		SiteUserSession__c session = [SELECT id
		                              FROM SiteUserSession__c];
		aSiteEstoqueController controller = new aSiteEstoqueController();
		Opportunity opp = [SELECT id, Name
		                   FROM Opportunity];
		System.currentPageReference().getParameters().put('token', session.id);

		System.currentPageReference().getParameters().put('e', opp.id);
		System.currentPageReference().getParameters().put('m', '');
		Test.startTest();
		PageReference ref = controller.validate();
		Test.stopTest();
        
		System.assertEquals(null, ref);
	}

    @isTest
	private static void validateWithoutToken(){
		
		aSiteEstoqueController controller = new aSiteEstoqueController();
		Opportunity opp = [SELECT id, Name
		                   FROM Opportunity];
	

		System.currentPageReference().getParameters().put('e', opp.id);
		System.currentPageReference().getParameters().put('m', '');
		Test.startTest();
		PageReference ref = controller.validate();
		Test.stopTest();

		System.assertEquals(true, ref.getUrl().containsAny('/apex/aSiteLogin'));
	}

    @isTest 
    private static void getEstoque(){
        SiteUserSession__c session = [SELECT id
		                              FROM SiteUserSession__c];
		
		Opportunity opp = [SELECT id, Name
		                   FROM Opportunity];	
        System.currentPageReference().getParameters().put('token', session.id);
		System.currentPageReference().getParameters().put('e', opp.id);
		System.currentPageReference().getParameters().put('m', '');
        aSiteEstoqueController controller = new aSiteEstoqueController();
        PageReference ref = controller.validate();       

		Test.startTest();
        controller.getEstoque();
        controller.getEstoqueItems();
		Test.stopTest();
        System.assertEquals(1, controller.relatedEstoqueItems.size());
    }

    @isTest 
    private static void saveEstoque(){
        SiteUserSession__c session = [SELECT id
		                              FROM SiteUserSession__c];
		aSiteEstoqueController controller = new aSiteEstoqueController();
		Opportunity opp = [SELECT id, Name
		                   FROM Opportunity];	
        System.currentPageReference().getParameters().put('token', session.id);
		System.currentPageReference().getParameters().put('e', opp.id);
		System.currentPageReference().getParameters().put('m', '');
        PageReference ref = controller.validate();
        aAppendix.myOppItem myOppItem = new aAppendix.myOppItem();

		Test.startTest();
        controller.getEstoque();
        controller.getEstoqueItems();
        controller.saveEstoque();
		Test.stopTest();
       
    }

    @isTest
	private static void goTo_AndEditFunctions(){
		SiteUserSession__c session = [SELECT id
		                              FROM SiteUserSession__c];
		aSiteEstoqueController controller = new aSiteEstoqueController();
		Opportunity opp = [SELECT id, Name
		                   FROM Opportunity];
		System.currentPageReference().getParameters().put('token', session.id);

		System.currentPageReference().getParameters().put('e', opp.id);
		System.currentPageReference().getParameters().put('m', 'Fevrero');
        PageReference ref = controller.validate();
		Test.startTest();
		PageReference refEdit = controller.gotoEdit();
        PageReference refNew = controller.gotoNew();
        PageReference refCancel = controller.editCancel();
        siteUser__c user = controller.getUser();
        Account acc = controller.getAccount();
        controller.getOptionMes();
		Test.stopTest();
        
		System.assertEquals(true, refEdit.getUrl().containsAny('/apex/aSiteEstoqueEdit?'));      
        System.assertEquals(true, refCancel.getUrl().containsAny('/apex/aSiteEstoque?'));
        System.assertEquals('Site user',user.Name);
        System.assertEquals('Acc',acc.Name);
	}

}
@isTest
public class aSiteVotacionControllerTest {
  
    @TestSetup
	static void makeData(){
		

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
        SiteUserSession__c session = [SELECT ID FROM SiteUserSession__c];
        aSiteVotacionController controller = new aSiteVotacionController();
        System.currentPageReference().getParameters().put('token',session.id);
        Test.startTest();
        PageReference ref = controller.validate();
        Test.stopTest();

        System.assertEquals(null,ref);
    }

    
    @isTest
    private static void validateWithoutToken(){
        SiteUserSession__c session = [SELECT ID FROM SiteUserSession__c];
        aSiteVotacionController controller = new aSiteVotacionController();
        System.currentPageReference().getParameters().put('token',null);
        Test.startTest();
        PageReference ref = controller.validate();
        Test.stopTest();

        System.assertEquals('/apex/aSiteLogin',ref.getUrl());
    }
    
    @isTest
    private static void cargarVariedades2(){
        SiteUserSession__c session = [SELECT ID FROM SiteUserSession__c];
		Product2 product = [SELECT ID,NAME FROM Product2];
        aSiteVotacionController controller = new aSiteVotacionController();
        System.currentPageReference().getParameters().put('token',session.id);
        PageReference ref = controller.validate();
        aSiteVotacionController.PieWedgeData data = new aSiteVotacionController.PieWedgeData('Name',20);
        Test.startTest();       
        controller.vuelta = 2;
		controller.cargarVariedades(); 
		controller.changeVariedad();
		       
        controller.cargarResumenVotos();
        controller.generarVotacion();
        controller.saveVotacion();
        Test.stopTest();
        System.assertEquals(null,ref);
		
	
    }

    

}
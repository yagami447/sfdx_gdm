@isTest
private class FullCalendarDemoTest {

    @TestSetup static void setup() {
		Profile profileSupervisor = [SELECT Id FROM Profile WHERE Name = 'Comercial LE' LIMIT 1];
        Profile profileGerente = [SELECT Id FROM Profile WHERE Name = 'Gerente LE' LIMIT 1];

        User supervisor = Build.anUser()
            .withFirstName('Rosa')
            .withLastName('Jorge Cristiano')
            .withAlias('jcr')
            .withEmail('jorge.rosa@asdf.com')
            .withUsername('jorge.rosa@asdf.com')
            .withProfileId(profileSupervisor)
            .withCommunityNickname('jcr')
            .build();

        User gerente = Build.anUser()
            .withFirstName('Sergio Vieira')
            .withLastName('Bertagnolli')
            .withAlias('svb')
            .withEmail('sergio.bertagnolli@asdf.com')
            .withUsername('sergio.bertagnolli@asdf.com')
            .withProfileId(profileGerente)
            .withCommunityNickname('svb')
            .build();

        User[] users = new User[]{supervisor, gerente};
        insert users;

		Account account = Build.anAccount()
            .withName('ACME INDUSTRY SRL')
            .withNomefantasia('ACME')
            .withType('Multiplicador')
            .withMultiplicador(true)
            .withAuditor(true)
			.withMarca('BRMX')
            .withSupervisor(supervisor)
            .withGerenteComercial(gerente)
            .build();

        insert account;

		SiteUser__c testSiteUser = Build.aSiteUser().
			withName('Test site user').
			withEmail('testsu@test.com').
			withPassword('test').
			withActive(true).
			withHabilitadoAnexos(true).
			build();

		insert testSiteUser;

		Estado__c estado = Build.anEstado().
			withMostrarenportal(true).
			withName('Estado test').
			build();

		insert estado;

		SiteUserAccount__c testSiteUserAccount = Build.aSiteUserAccount().
			withName('Test site user account').
			withAccount(account).
			withSiteUser(testSiteUser).
			withActive(true).
			build();

		insert testSiteUserAccount;

		SiteUserSession__c testSiteUserSession = Build.aSiteUserSession().
			withSiteUser(testSiteUser).
			withMarca('BRMX').
			withSafra('18/19').
			build();

		insert testSiteUserSession;

		Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX().build();
		insert testConfiguracionBMX;
		testConfiguracionBMX.PM_Safra_Actual_DescontoRoyalty__c = '18/19';
		update testConfiguracionBMX;

		Saldo_por_safra__c saldoPorSafra = Build.aSaldoPorSafra().
			withAccount(account).
			withSaldo(10).
			withSafra('18/19').
			build();

        insert saldoPorSafra;

		Opportunity opportunity = Build.anOpportunityAnexoI()
			.withName('Anexo I')
			.withAccountId(account)
			.withStageName('Aberta')
			.withPricebook2Id(Test.getStandardPricebookId())
			.withCloseDate(Date.today())
			.build();

        insert opportunity;

        Product2 product2Test = Build.aProduct2()
			.withName('BMX DESAFIO RR - Basica  (G)')
			.withIsActive(true)
			.withFamily('Semilla')
			.withVariedad('BMX DESAFIO RR')
			.withCategoria('BASICA')
			.withPrice(Double.valueOf(0.1))
			.withSociedad('BRMX')
			.withUnidad('KG')
			.withCantSubUnidad('1')
			.build();

        insert product2Test;

        PricebookEntry pricebookE = Build.aPricebookEntry()
			.withProduct2Id(product2Test)
			.withPricebook2Id(Test.getStandardPricebookId())
			.withUnitPrice(0.1)
			.withIsActive(true)
			.build();

        insert pricebookE;

		OpportunityLineItem[] OLIs = new OpportunityLineItem[2];

        OLIs[0] = Build.anOpportunityLineItem()
			.withOpportunityId(opportunity)
			.withPricebookEntryId(pricebookE)
			.withQuantity(10)
			.withUnitPrice(0.1)
			.build();

        OLIs[1] = Build.anOpportunityLineItem()
			.withOpportunityId(opportunity)
			.withPricebookEntryId(pricebookE)
			.withQuantity(10)
			.withUnitPrice(0.1)
			.build();

        insert OLIs;

        Plano_de_Auditoria__c plano = new Plano_de_Auditoria__c(
            Cuenta_Principal__c = account.Id,
            Safra__c = '17/18',
            Status__c = 'Não Iniciado'
        );

        insert plano;

        Calendar_Event__c visita = new Calendar_event__c(
            Plano_de_Auditoria__c = plano.Id,
            Start_Time__c = System.Today(),
            End_Time__c = System.today().addDays(1)
        );

        insert visita;

		Producto_Auditado__c[] productos = new Producto_Auditado__c[]{
			new Producto_Auditado__c(Plano_de_Auditoria__c = plano.Id),
			new Producto_Auditado__c(Plano_de_Auditoria__c = plano.Id),
			new Producto_Auditado__c(Plano_de_Auditoria__c = plano.Id)
		};

        insert productos;
    }

	@isTest static void test() {
        Plano_de_Auditoria__c plano = [SELECT Id FROM Plano_de_Auditoria__c LIMIT 1];
        Calendar_Event__c visita = [SELECT Id FROM Calendar_Event__c WHERE Plano_de_Auditoria__c = :plano.Id];

        Test.setCurrentPageReference(new PageReference('Page.FullCalendarDemo'));
        System.currentPageReference().getParameters().put('Id', plano.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(plano);

        String json = '{"Id":"' + visita.Id + '","Plano_de_Auditoria__c":"' + plano.Id + '","Name":"Este es el titulo3","Start_Time__c":1609372800000,"End_Time__c":1609459200000,"Cidade__c":"","UF__c":"","Etapa__c":"Inventário físico","Auditor__c":"","Responsavel__c":"Próprio"}';

		Test.startTest();
		FullCalendarDemo controller = new FullCalendarDemo(sc);
		FullCalendarDemo.getEvents('');
		FullCalendarDemo.getEvents('Test Account');
		controller.getAuditoresOption();
		controller.getAuditoresString();
		FullCalendarDemo.createOrUpdateEvents(json, 'Test Account');
		controller.auditarCtrl();
		controller.cancel();
		controller.clearMessages();
        Test.stopTest();
    }
}
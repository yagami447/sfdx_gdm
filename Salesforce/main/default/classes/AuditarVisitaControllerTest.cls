@isTest 
private class AuditarVisitaControllerTest {

    @isTest static void getOnePlanoWith3Products() {
        Plano_de_Auditoria__c plano = [SELECT Id FROM Plano_de_Auditoria__c LIMIT 1];        
        Test.setCurrentPageReference(new PageReference('Page.AuditarVisitaController'));
        System.currentPageReference().getParameters().put('Id', plano.Id);
        System.currentPageReference().getParameters().put('Safra', '16/17');
        ApexPages.StandardController sc = new ApexPages.StandardController(plano);
        Integer cantidadDeProductos = 0;
        Test.startTest();
		AuditarVisitaController controller = new AuditarVisitaController(sc);
		cantidadDeProductos = controller.productosDelPlano.size();
		controller.save();
		controller.goToCalendario();
		controller.goToObservaciones();
		controller.goToPlano();
		controller.generatePDF();
        Test.stopTest();
        System.assertEquals(3, cantidadDeProductos);
    }

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

		Account testAccount = Build.anAccount()
			.withName('Test account')
			.withType('Multiplicador')
			.withMultiplicador(true)
			.withMarca('BRMX')
			.withSupervisor(supervisor)
			.withGerenteComercial(gerente)
			.build();

		insert testAccount;

		SiteUser__c testSiteUser = Build.aSiteUser()
            .withName('Test site user')
            .withEmail('testsu@test.com')
            .withPassword('test')
            .withActive(true)
            .withHabilitadoAnexos(true)
            .build();

		insert testSiteUser;

		Estado__c estado = Build.anEstado()
            .withMostrarenportal(true)
            .withName('Estado test')
            .build();

		insert estado;

		SiteUserAccount__c testSiteUserAccount = Build.aSiteUserAccount()
            .withName('Test site user account')
            .withAccount(testAccount)
            .withSiteUser(testSiteUser)
            .withActive(true)
            .build();

		insert testSiteUserAccount;

		SiteUserSession__c testSiteUserSession = Build.aSiteUserSession()
            .withSiteUser(testSiteUser)
            .withMarca('BRMX')
            .withSafra('18/19')
            .build();

		insert testSiteUserSession;

		Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX().build();
		insert testConfiguracionBMX;
		testConfiguracionBMX.PM_Safra_Actual_DescontoRoyalty__c = '18/19';
		update testConfiguracionBMX;

		Saldo_por_safra__c saldoPorSafra = Build.aSaldoPorSafra()
            .withAccount(testAccount)
            .withSaldo(10)
            .withSafra('18/19')
            .build();

        insert saldoPorSafra;

        Opportunity opportunity = Build.anOpportunityAnexoI()
			.withName('Anexo 1')
			.withAccountId(testAccount)
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
            Cuenta_Principal__c = testAccount.Id,
            Safra__c = '16/17',
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
			new Producto_Auditado__c(
				Plano_de_Auditoria__c = plano.Id,
				Safra__c = '16/17'
			),
			new Producto_Auditado__c(
				Plano_de_Auditoria__c = plano.Id,
				Safra__c = '16/17'
			),
			new Producto_Auditado__c(
				Plano_de_Auditoria__c = plano.Id,
				Safra__c = '16/17'
			)
		};

        insert productos;
    }
}
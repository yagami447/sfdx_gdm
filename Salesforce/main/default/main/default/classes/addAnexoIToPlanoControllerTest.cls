@isTest
private class addAnexoIToPlanoControllerTest {

	@isTest static void test() {
        Plano_de_Auditoria__c plano = [SELECT Id FROM Plano_de_Auditoria__c LIMIT 1];
        Test.setCurrentPageReference(new PageReference('Page.addAnexoIToPlanoController'));
        System.currentPageReference().getParameters().put('Id', plano.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(plano);
        Test.startTest();
        addAnexoIToPlanoController controller = new addAnexoIToPlanoController(sc);
        controller.retrieveAnexosFromPlanoDeAuditoria();
        controller.addAnexos();
        controller.removeAnexo();
        controller.next();
        controller.previous();
        controller.getDisablePrevious();
        controller.getDisableNext();
        controller.save();
        controller.cancel();
        Test.stopTest();
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

        insert new User[]{supervisor, gerente};

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

        Plano_de_Auditoria__c auditPlan = new Plano_de_Auditoria__c(
            Cuenta_Principal__c = testAccount.Id,
            Safra__c = '16/17',
            Status__c = 'Não Iniciado'
        );

        insert auditPlan;

        Opportunity anexo1 = Build.anOpportunityAnexoI()
            .withName('Anexo 1')
            .withAccountId(testAccount)
            .withStageName('Aprobada')
            .withPricebook2Id(Test.getStandardPricebookId())
            .withPlanoDeAuditoria(auditPlan)
            .withSafra('16/17')
            .withMarca('BRMX')
            .withCloseDate(Date.today())
            .build();

        Opportunity anexo2 = Build.anOpportunityAnexoII()
            .withName('Anexo 2')
            .withAccountId(testAccount)
            .withStageName('Aprobada')
            .withPricebook2Id(Test.getStandardPricebookId())
            .withPlanoDeAuditoria(auditPlan)
            .withSafra('16/17')
            .withMarca('BRMX')
            .withCloseDate(Date.today())
            .build();

        Opportunity anexo3 = Build.anOpportunityAnexoIII()
            .withName('Anexo 3')
            .withAccountId(testAccount)
            .withStageName('Aprobada')
            .withPricebook2Id(Test.getStandardPricebookId())
            .withPlanoDeAuditoria(auditPlan)
            .withSafra('16/17')
            .withMarca('BRMX')
            .withCloseDate(Date.today())
            .build();

        Opportunity anexo4 = Build.anOpportunityAnexoIV()
            .withName('Anexo 4')
            .withAccountId(testAccount)
            .withStageName('Aberta')
            .withPricebook2Id(Test.getStandardPricebookId())
            .withPlanoDeAuditoria(auditPlan)
            .withSafra('16/17')
            .withMarca('BRMX')
            .withCloseDate(Date.today())
            .build();

        insert new Opportunity[]{anexo1, anexo2, anexo3};
        insert anexo4;

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

        OpportunityLineItem[] OLIs = new OpportunityLineItem[8];

        OLIs[0] = Build.anOpportunityLineItem()
            .withOpportunityId(anexo1)
            .withPricebookEntryId(pricebookE)
            .withQuantity(10)
            .withUnitPrice(0.1)
            .build();

        OLIs[1] = Build.anOpportunityLineItem()
            .withOpportunityId(anexo1)
            .withPricebookEntryId(pricebookE)
            .withQuantity(10)
            .withUnitPrice(0.1)
            .build();

        OLIs[2] = Build.anOpportunityLineItem()
            .withOpportunityId(anexo2)
            .withPricebookEntryId(pricebookE)
            .withQuantity(10)
            .withUnitPrice(0.1)
            .build();

        OLIs[3] = Build.anOpportunityLineItem()
            .withOpportunityId(anexo2)
            .withPricebookEntryId(pricebookE)
            .withQuantity(10)
            .withUnitPrice(0.1)
            .build();

        OLIs[4] = Build.anOpportunityLineItem()
            .withOpportunityId(anexo3)
            .withPricebookEntryId(pricebookE)
            .withQuantity(10)
            .withSementebruta(20)
            .withSementebeneficiada(20)
            .withSementeaprovada(20)
            .withSementecomercializada(20)
            .withSementeusopropio(20)
            .withUnitPrice(0.1)
            .build();

        OLIs[5] = Build.anOpportunityLineItem()
            .withOpportunityId(anexo3)
            .withPricebookEntryId(pricebookE)
            .withQuantity(10)
            .withSementebruta(20)
            .withSementebeneficiada(20)
            .withSementeaprovada(20)
            .withSementecomercializada(20)
            .withSementeusopropio(20)
            .withUnitPrice(0.1)
            .build();

        OLIs[6] = Build.anOpportunityLineItem()
            .withOpportunityId(anexo4)
            .withPricebookEntryId(pricebookE)
            .withQuantity(10)
            .withSementecomercializada(30)
            .withSementeusopropio(30)
            .withDescarte(30)
            .withUnitPrice(0.1)
            .build();

        OLIs[7] = Build.anOpportunityLineItem()
            .withOpportunityId(anexo4)
            .withPricebookEntryId(pricebookE)
            .withQuantity(10)
            .withSementecomercializada(30)
            .withSementeusopropio(30)
            .withDescarte(30)
            .withUnitPrice(0.1)
            .build();

        insert OLIs;
    }
}
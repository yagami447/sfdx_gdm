@isTest
public class aSiteCuentaCorrienteControllerTest {
    
    static{
        Test.setMock(WebServiceMock.class, new ConsultarContaCorrienteRFCMOCK.ConsultarContaCorrienteRFCSuccessfullyMOCK());
        Configuracion_BMX__c endpointConfig = Build.aConfiguracionBMX()
            .withName('Test')
            .withLinkSapQa('gdmdev.dyndns.org:8000')
            .build();

        insert endpointConfig;
	}

    @isTest
	private static void verifyWhenTokenIsNull() {
		aSiteCuentaCorrienteController aSiteCuentaCorrienteController = new aSiteCuentaCorrienteController();

		Test.setCurrentPageReference(new PageReference('Page.aSiteCuentaCorriente'));
		System.currentPageReference().getParameters().put('token', '');

		Test.startTest();
		PageReference pr = aSiteCuentaCorrienteController.validate();
		Test.stopTest();

		PageReference pageExpected = new PageReference('/apex/aSiteLogin');


		System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    @IsTest
	private static void verifyWhenUserIsCorrect() {
		SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];


		aSiteCuentaCorrienteController aSiteCuentaCorrienteController = new aSiteCuentaCorrienteController();

		Test.setCurrentPageReference(new PageReference('Page.aSiteCuentaCorriente'));
		System.currentPageReference().getParameters().put('token', testSiteUserSession.id);

		Test.startTest();
		PageReference pr = aSiteCuentaCorrienteController.validate();
		Test.stopTest();

		System.debug(pr);

		System.assertEquals(null, pr);
	}
    
    @isTest
    private static void correctFormatDecimal(){
        aSiteCuentaCorrienteController aSiteCuentaCorrienteController = new aSiteCuentaCorrienteController();
        Decimal valor = 2.66;
        
        Test.startTest();
        String valorFormateado = aSiteCuentaCorrienteController.formatDecimal(valor, 2, '.', ',');
        Test.stopTest();
        
        System.assertEquals('2,66', valorFormateado);
    }
    
    @TestSetup
	private static void IsTheSetup() {
		Profile profileIdSupervisor = [SELECT Id FROM Profile WHERE Name = 'Supervisor Administrativo' LIMIT 1];
		Profile profileIdGerente = [SELECT Id FROM Profile WHERE Name = 'Gerente Administrativo' LIMIT 1];

		User supervisor = new User(
		                           LastName = 'Rosa',
		                           FirstName = 'Jorge Cristiano',
		                           Alias = 'jcr',
		                           Email = 'jorge.rosa@asdf.com',
		                           Username = 'jorge.rosa@asdf.com',
		                           ProfileId = profileIdSupervisor.id,
		                           TimeZoneSidKey = 'GMT',
		                           LanguageLocaleKey = 'en_US',
		                           EmailEncodingKey = 'UTF-8',
		                           LocaleSidKey = 'en_US'
		);

		User gerente = new User(
		                        LastName = 'Bertagnolli',
		                        FirstName = 'Sergio Vieira',
		                        Alias = 'svb',
		                        Email = 'sergio.bertagnolli@asdf.com',
		                        Username = 'sergio.bertagnolli@asdf.com',
		                        ProfileId = profileIdGerente.id,
		                        TimeZoneSidKey = 'GMT',
		                        LanguageLocaleKey = 'en_US',
		                        EmailEncodingKey = 'UTF-8',
		                        LocaleSidKey = 'en_US'
		);

		List<User> users = new List<User> {
			supervisor, gerente
		};
		insert users;

		Account testAccount = Build.anAccount()
			.withName('Test account')
			.withType('Multiplicador')
			.withMarca('BRMX')
			.withSupervisor(supervisor)
			.withGerenteComercial(gerente)
			.build();
        testAccount.CodigoSAP__c = '6000000077';
		insert testAccount;

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
		withAccount(testAccount).
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

		Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX().
		withPMSafraActualA3('18/19').
		build();
		insert testConfiguracionBMX;
        
	}
    
}
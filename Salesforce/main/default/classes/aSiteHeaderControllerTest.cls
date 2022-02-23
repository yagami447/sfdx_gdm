@isTest
public class aSiteHeaderControllerTest {
    
    @isTest
    private static void verifyWhenTokenIsNull() {
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', '');
        
        Test.startTest();
        Boolean isValidate = aSiteHeader.validate();
        Test.stopTest();
        
        
        System.assertEquals(false, isValidate);
    }
    
    
    @IsTest
    private static void verifyWhenUserIsCorrect() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        Boolean isValid = aSiteHeader.validate();
        Test.stopTest();
        
        System.assertEquals(true, isValid);
    }
    
    
    @isTest
    private static void verifygotoSalesReport() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoSalesReport();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteSalesReport');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    
    @isTest
    private static void verifygotoProdReport() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoProdReport();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteProductionReport');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    
    
    @isTest
    private static void verifygotoDashboard() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoDashboard();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteHome');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    
    @isTest
    private static void verifygotoProfile() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoProfile();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteProfile');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    @isTest
    private static void verifygotoAppend1() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoAppend1();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteAppendix1');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    @isTest
    private static void verifygotoAppend1Rebaja() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoAppend1Rebaja();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteAppendix1Reb');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    @isTest
    private static void verifygotoAppend2() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoAppend2();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteAppendix2');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    @isTest
    private static void verifygotoAppend2Reb() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoAppend2Rebaja();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteAppendix2Reb');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    
    @isTest
    private static void verifygotoAppend3() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoAppend3();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteAppendix3');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
        
    }
    
    @isTest
    private static void verifygotoAppend4() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoAppend4();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteAppendix4');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
        
        
    }
    
    @isTest
    private static void verifygotoAppend5() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoAppend5();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteAppendix5');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
        
    }
    
    @isTest
    private static void verifygotoContract() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoContract();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteContracts');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
        
    }
    
    
    @isTest
    private static void verifygotoEventos() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoEventos();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteEventos');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
        
    }
    
    @isTest
    private static void verifygotoVotar() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoVotar();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteVotacion');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
        
    }
    
    
    @isTest
    private static void verifygotoResumenVotos() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoResumenVotos();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteVotacionResumen');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
        
    }
    
    
    @isTest
    private static void verifygotoEstoque() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoEstoque();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteEstoque');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    @isTest
    private static void verifygotoDescarte() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoDescarte();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteDescarte');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    @isTest
    private static void verifygotoReembalagem() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoReembalagem();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteReembalagem');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    
    @isTest
    private static void verifygotoSaldos() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoSaldos();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteSaldoSafra');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }
    
    @isTest
    private static void verifygotoVendaBasica() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        aSiteHeaderController aSiteHeader = new aSiteHeaderController();
        
        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        
        Test.startTest();
        PageReference pr = aSiteHeader.gotoVendaBasica();
        Test.stopTest();
        
        PageReference pageExpected = new PageReference('/apex/aSiteVendaDeBasica');
        pageExpected.getParameters().put('token', testSiteUserSession.id);
        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
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
        
        
        Saldo_por_safra__c saldoPorSafra = Build.aSaldoPorSafra().
            withAccount(testAccount).
            withSaldo(100).
            withSafra('18/19').
            
            build();
        insert saldoPorSafra;
    }
    
}
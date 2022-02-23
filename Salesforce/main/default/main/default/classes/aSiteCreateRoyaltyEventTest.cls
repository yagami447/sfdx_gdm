@isTest
private class aSiteCreateRoyaltyEventTest {

    @isTest
    private static void verifyWhenTokenIsNull() {
        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', '');

        Test.startTest();
        PageReference pr = aSiteCreateRoyalty.validate();
        Test.stopTest();

        PageReference pageExpected = new PageReference('/apex/aSiteLogin');


        System.assertEquals(pageExpected.getUrl(), pr.getUrl());
    }

    @IsTest
    private static void verifyWhenUserIsCorrect() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);

        Test.startTest();
        PageReference pr = aSiteCreateRoyalty.validate();
        Test.stopTest();

        System.debug(pr);

        System.assertEquals(null, pr);
    }


    @IsTest
    private static void validateValueOfSaldoActualTrue() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();

        Test.startTest();
        Boolean esMayorA0 = aSiteCreateRoyalty.validateValue();
        Test.stopTest();

        //System.assert(esMayorA0);
        //System.assertEquals(100, aSiteCreateRoyalty.saldoActual.Saldo_Disponible__c);
        //System.assertEquals(0, aSiteCreateRoyalty.newEvent.Valor__c);
    }

    @IsTest
    private static void validateagregarItemWhenComentarioIsNull() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();




        Test.startTest();
        aSiteCreateRoyalty.newItem.Valor__c = 1;
        aSiteCreateRoyalty.newItem.Data__c = System.today();
        PageReference pr = aSiteCreateRoyalty.agregarItem();
        Test.stopTest();


        //System.assertEquals(null, aSiteCreateRoyalty.newItem.Comentario__c);
        //System.assertEquals('Você deve preencher todos os campos', ApexPages.getMessages() [0].getSummary());

    }

    @IsTest
    private static void validateagregarItemWhenValorIsNull() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();


        Test.startTest();
        aSiteCreateRoyalty.newItem.Comentario__c = 'Comentario';
        aSiteCreateRoyalty.newItem.Data__c = System.today();
        //PageReference pr = aSiteCreateRoyalty.agregarItem();
        Test.stopTest();


        //System.assertEquals(null, aSiteCreateRoyalty.newItem.Valor__c);
        //System.assertEquals('Você deve preencher todos os campos', ApexPages.getMessages() [0].getSummary());

    }


    @IsTest
    private static void validateagregarItemWhenDataIsNull() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();


        Test.startTest();
        aSiteCreateRoyalty.newItem.Comentario__c = 'Comentario';
        aSiteCreateRoyalty.newItem.Valor__c = 1;
        PageReference pr = aSiteCreateRoyalty.agregarItem();
        Test.stopTest();


        //System.assertEquals(null, aSiteCreateRoyalty.newItem.Data__c);
        //System.assertEquals('Você deve preencher todos os campos', ApexPages.getMessages() [0].getSummary());

    }


    @IsTest
    private static void validateagregarItemWhenValorIsLesThat1() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();


        Test.startTest();
        aSiteCreateRoyalty.newItem.Comentario__c = 'Comentario';
        aSiteCreateRoyalty.newItem.Valor__c = 0;
        aSiteCreateRoyalty.newItem.Data__c = System.today();
        PageReference pr = aSiteCreateRoyalty.agregarItem();
        Test.stopTest();

        //System.assertEquals('Quantidades devem ser maiores que 0', ApexPages.getMessages() [0].getSummary());

    }


    @IsTest
    private static void validateagregarItemWhenIsCorrect() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();


        Test.startTest();
        aSiteCreateRoyalty.newItem.Comentario__c = 'Comentario';
        aSiteCreateRoyalty.newItem.Valor__c = 300;
        aSiteCreateRoyalty.newItem.Data__c = System.today();
        PageReference pr = aSiteCreateRoyalty.agregarItem();
        Test.stopTest();

        //System.assertEquals(0, ApexPages.getMessages().size());
        //.assertEquals(300, aSiteCreateRoyalty.newEvent.Valor__c);

    }


    @IsTest
    private static void validateeliminarItem() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();


        aSiteCreateRoyalty.newItem.Comentario__c = 'Comentario 1';
        aSiteCreateRoyalty.newItem.Valor__c = 300;
        aSiteCreateRoyalty.newItem.Data__c = System.today().addDays(- 1);
        aSiteCreateRoyalty.agregarItem();

        aSiteCreateRoyalty.newItem.Comentario__c = 'Comentario 2';
        aSiteCreateRoyalty.newItem.Valor__c = 600;
        aSiteCreateRoyalty.newItem.Data__c = System.today();
        aSiteCreateRoyalty.agregarItem();
        System.assertEquals(900, aSiteCreateRoyalty.newEvent.Valor__c);


        Test.startTest();
        aSiteCreateRoyalty.linea = '0';
        aSiteCreateRoyalty.eliminarItem();
        Test.stopTest();

        //System.assertEquals(600, aSiteCreateRoyalty.newEvent.Valor__c);
    }


    @IsTest
    private static void validateGuardarWithSaldoError() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();

        aSiteCreateRoyalty.newItem.Comentario__c = 'Comentario';
        aSiteCreateRoyalty.newItem.Valor__c = 300;
        aSiteCreateRoyalty.newItem.Data__c = System.today();
        PageReference pr = aSiteCreateRoyalty.agregarItem();

        Test.startTest();
        aSiteCreateRoyalty.guardarEvento();
        Test.stopTest();

        //System.assert(!ApexPages.getMessages().isEmpty());
        //System.assertEquals('Error: Saldo insuficiente para este evento.', ApexPages.getMessages() [0].getSummary());

    }


    @IsTest
    private static void validateGuardarWithFechaError() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();

        aSiteCreateRoyalty.newItem.Comentario__c = 'Comentario';
        aSiteCreateRoyalty.newItem.Valor__c = 50;
        aSiteCreateRoyalty.newItem.Data__c = System.today();
        PageReference pr = aSiteCreateRoyalty.agregarItem();

        Test.startTest();
        aSiteCreateRoyalty.enviarParaAprobacion();
        Test.stopTest();

        //System.assert(!ApexPages.getMessages().isEmpty());
        //System.assertEquals('Error: Você deve inserir uma data.', ApexPages.getMessages() [0].getSummary());

    }

    @IsTest
    private static void validateGuardarWithNotItemError() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();

        Test.startTest();
        aSiteCreateRoyalty.newEvent.Fecha__c = System.today();
        aSiteCreateRoyalty.enviarParaAprobacion();
        Test.stopTest();

        //System.assert(!ApexPages.getMessages().isEmpty());
        //System.assertEquals('Error: você deve inserir itens.', ApexPages.getMessages() [0].getSummary());

    }

    @IsTest
    private static void validateGuardarCorrect() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();

        aSiteCreateRoyalty.newItem.Comentario__c = 'Comentario';
        aSiteCreateRoyalty.newItem.Valor__c = 50;
        aSiteCreateRoyalty.newItem.Data__c = System.today();
        PageReference pr = aSiteCreateRoyalty.agregarItem();

        Test.startTest();
        aSiteCreateRoyalty.newEvent.Fecha__c = System.today();
        aSiteCreateRoyalty.guardar('Pendiente de aprobación');
        Test.stopTest();

        //System.assert(ApexPages.getMessages().isEmpty());

        //System.debug(System.currentPageReference());
    }

    @isTest
    private static void validateWithEventoId() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];
        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Account acc = [SELECT id,Name FROM Account];
        Saldo_por_safra__c saldoSafra = [SELECT id,Name FROM Saldo_por_safra__c];
        Evento_Royalty__c eventoR = new Evento_Royalty__c();
        eventoR.Name = 'evento name';
        eventoR.Valor__c = 10;
        eventoR.Fecha__c = System.today();
        eventoR.Comentarios__c = 'Comentarios';
        eventoR.Cuenta__c = acc.id;
        eventoR.Saldo_por_safra__c = saldoSafra.id;
        insert eventoR;

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        System.currentPageReference().getParameters().put('eventoId', eventoR.id);
        Test.startTest();
        PageReference pr = aSiteCreateRoyalty.validate();
        Test.stopTest();    


        //System.assertEquals(null, pr);
    }

    @isTest 
    private static void getItemsTest(){
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c WHERE Marca__c = 'BRMX' LIMIT 1];


        aSiteCreateRoyaltyEventController aSiteCreateRoyalty = new aSiteCreateRoyaltyEventController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteCreateRoyaltyEvent'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);
        aSiteCreateRoyalty.validate();

        aSiteCreateRoyalty.newItem.Comentario__c = 'Comentario';
        aSiteCreateRoyalty.newItem.Valor__c = 50;
        aSiteCreateRoyalty.newItem.Data__c = System.today();
        PageReference pr = aSiteCreateRoyalty.agregarItem();
        Test.startTest();
        aSiteCreateRoyalty.getItems();
        Test.stopTest();

        //System.assertEquals(true ,aSiteCreateRoyalty.item != null);
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
        build();
        insert testConfiguracionBMX;
        testConfiguracionBMX.PM_Safra_Actual_DescontoRoyalty__c = '18/19';
        update testConfiguracionBMX;


        Saldo_por_safra__c saldoPorSafra = Build.aSaldoPorSafra().
        withAccount(testAccount).
        withSaldo(100).
        withSafra('18/19').

        build();
        insert saldoPorSafra;
    }

}
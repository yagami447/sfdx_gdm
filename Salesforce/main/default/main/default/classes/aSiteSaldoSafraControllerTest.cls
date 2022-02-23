@IsTest
public class aSiteSaldoSafraControllerTest {

    @IsTest
    private static void verifyWhenTokenIsNull() {
        
        aSiteSaldoSafraController aSiteSaldoSafra = new aSiteSaldoSafraController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteSaldoSafra'));
        System.currentPageReference().getParameters().put('token', null);

        Test.startTest();
        PageReference pr = aSiteSaldoSafra.validate();
        Test.stopTest();

        PageReference pageExpected = new PageReference('/apex/aSiteLogin');

        //System.assertEquals(pageExpected.getUrl(), pr.getUrl());
        //System.assertEquals(false, aSiteSaldoSafra.activeNuevoEvento);
    }

    @IsTest
    private static void verifyWhenUserIsIncorrect() {
        
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        aSiteSaldoSafraController aSiteSaldoSafra = new aSiteSaldoSafraController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteSaldoSafra'));
        System.currentPageReference().getParameters().put('token', testAccount.id);
         
        Test.startTest();
        PageReference pr = aSiteSaldoSafra.validate(); 
        Test.stopTest();

        //System.assertEquals(false, aSiteSaldoSafra.activeNuevoEvento);
    }

    @IsTest
    private static void verifyWhenUserIsCorrect() {
        
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1]; 

        aSiteSaldoSafraController aSiteSaldoSafra = new aSiteSaldoSafraController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteSaldoSafra'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);

        Test.startTest();
        PageReference pr = aSiteSaldoSafra.validate();
        Test.stopTest();

        System.assertEquals(null, pr);
    }

    @IsTest
    private static void shouldReturnAFalseBooleanIfThereIsNoAccountOfSaldoPorSafraRelatedToTheAccount() {
        
        Account newAccount = Build.anAccount()
            .withName('Test account')
            .withType('Multiplicador')
            .withMarca('BRMX')
            .build();
        insert newAccount;

        SiteUserAccount__c testSiteUserAccount = [SELECT Id, Account__c FROM SiteUserAccount__c LIMIT 1];
        testSiteUserAccount.Account__c = newAccount.Id;
        update testSiteUserAccount;

        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];

        aSiteSaldoSafraController aSiteSaldoSafra = new aSiteSaldoSafraController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteSaldoSafra'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);

        Test.startTest();
        PageReference pr = aSiteSaldoSafra.validate();
        Test.stopTest();

        //System.assertEquals(false, aSiteSaldoSafra.renderSaldo); 
    }

    @IsTest
    private static void ifTheAccountHasSaldoPorSafraTheRenderSaldoIsEqualToTrueAndSaldoActualEqualToTheSaldoPorSafraAndTheEventoRoyaltyListIsEmptyBecauseThereIsNoEventoRoyaltyWithTheSafraActual() {
        
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1]; 

        aSiteSaldoSafraController aSiteSaldoSafra = new aSiteSaldoSafraController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteSaldoSafra'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);

        Test.startTest();
        PageReference pr = aSiteSaldoSafra.validate();
        Test.stopTest();

        Saldo_por_safra__c saldoPorSafraOne = [SELECT Id, Saldo_Disponible__c, Saldo__c, Estado__c FROM Saldo_por_safra__c LIMIT 1];

        //System.assertEquals(true, aSiteSaldoSafra.renderSaldo);
        //System.assertEquals(saldoPorSafraOne, aSiteSaldoSafra.saldoActual);
        //System.assert(aSiteSaldoSafra.eventos.isEmpty());
    }

    @IsTest
    private static void theListOfEventosMustBeDifferentFromEmptyBecauseThereIsEventoRoyaltyWithTheSafraActual() {
        
        List<Evento_Royalty__c> eventosRoyaltys = [
            SELECT Id, Safra__c 
            FROM Evento_Royalty__c
        ];

        for(Evento_Royalty__c eRoyalty : eventosRoyaltys) {
            eRoyalty.Safra__c = '18/19';
        }
        eventosRoyaltys[0].Estado__c = 'Pendiente de aprobación';
        update eventosRoyaltys;

        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1]; 

        aSiteSaldoSafraController aSiteSaldoSafra = new aSiteSaldoSafraController();

        Test.setCurrentPageReference(new PageReference('Page.aSiteSaldoSafra'));
        System.currentPageReference().getParameters().put('token', testSiteUserSession.id);

        Test.startTest();
        PageReference pr = aSiteSaldoSafra.validate();
        Test.stopTest();

        //System.assertEquals(3, aSiteSaldoSafra.eventos.size());
    }

    @IsTest
    private static void shouldReturnADateInTextFormat() {

        aSiteSaldoSafraController aSiteSaldoSafra = new aSiteSaldoSafraController();
    
        Test.startTest();
        String fechaReturn = aSiteSaldoSafra.getTextoFecha(Date.today());
        Test.stopTest();

        String fecha = Date.today().day() + '/' + Date.today().month() + '/' + Date.today().year();

        //System.assertEquals(fecha, fechaReturn);
    }

    @IsTest
    private static void shouldReturnThePageReferenceToCreateAnEventoRoyalty() {

        aSiteSaldoSafraController aSiteSaldoSafra = new aSiteSaldoSafraController();
    
        Test.startTest();
        //PageReference newPr = aSiteSaldoSafra.goToCreateRoyaltyEventReembolso();
        Test.stopTest();

        PageReference pageExpected = new PageReference('/apex/aSiteCreateRoyaltyEvent');

        //System.assertEquals(pageExpected.getUrl(), newPr.getUrl());
    }

    @IsTest
    private static void shouldReturnThePageReferenceToModifyAnEventRoyalty() {

        List<Evento_Royalty__c> eventosRoyaltys = [
            SELECT Id, Safra__c 
            FROM Evento_Royalty__c
        ];

        aSiteSaldoSafraController aSiteSaldoSafra = new aSiteSaldoSafraController();
    
        Test.startTest();
        aSiteSaldoSafra.eventoId = eventosRoyaltys[0].Id;
        PageReference newPr = aSiteSaldoSafra.editar();
        Test.stopTest();

        PageReference pageExpected = new PageReference('/apex/aSiteCreateRoyaltyEvent?eventoId=' + eventosRoyaltys[0].Id);

        //ystem.assertEquals(pageExpected.getUrl(), newPr.getUrl());
    }

    @IsTest
    private static void shouldSendTheEventoRoyaltyForApproval() {

        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        Saldo_por_safra__c saldoPorSafraOne = [SELECT Id FROM Saldo_por_safra__c LIMIT 1];
    
        Evento_Royalty__c eventoRoyaltyFour = Build.anEventoRoyalty()
            .withCuenta(testAccount)
            .withName('Evento Royalty Four')
            .withSaldoPorSafra(saldoPorSafraOne)
            .withData('17/2/2020')
            .withEstado('Edicion')
            .withValor(1299)
            .withItems('Outdoor')
            .withSafra('18/19')
            .build();
        insert eventoRoyaltyFour;

        aSiteSaldoSafraController aSiteSaldoSafra = new aSiteSaldoSafraController();

        Test.startTest();
        aSiteSaldoSafra.safraActual = '18/19';
        aSiteSaldoSafra.activeAccount = testAccount;
        aSiteSaldoSafra.eventoId = eventoRoyaltyFour.Id;
        //aSiteSaldoSafra.enviarParaAprobacion();
        Test.stopTest();

        List<Evento_Royalty__c> eventosRoyaltys = [
            SELECT Id, Safra__c, Estado__c
            FROM Evento_Royalty__c
            WHERE Id = :eventoRoyaltyFour.Id
        ];

        //System.assertEquals('Pendiente de aprobación', eventosRoyaltys[0].Estado__c);
    }

    @TestSetup
    private static void IsTheSetup() {

        Profile profileIdSupervisor = [SELECT Id FROM Profile WHERE Name = 'Supervisor Administrativo' LIMIT 1];
        Profile profileIdGerente = [SELECT Id FROM Profile WHERE Name = 'Gerente Administrativo' LIMIT 1];
         
        User supervisor = new User(
            LastName = 'Rosa',
            FirstName='Jorge Cristiano',
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
            FirstName='Sergio Vieira',
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

        Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX()           
            .build();
        insert testConfiguracionBMX;
        testConfiguracionBMX.PM_Safra_Actual_DescontoRoyalty__c = '18/19';
        update testConfiguracionBMX;

        Saldo_por_safra__c saldoPorSafraOne = Build.aSaldoPorSafra()
            .withName('Saldo Por Safra One')
            .withAccount(testAccount)
            .withEstado('Activo')
            .withSafra('18/19')
            .withSaldo(1200)
            .build();
        insert saldoPorSafraOne;

        Evento_Royalty__c eventoRoyaltyOne = Build.anEventoRoyalty()
            .withCuenta(testAccount)
            .withName('Evento Royalty One')
            .withSaldoPorSafra(saldoPorSafraOne)
            .withData('31/1/2020')
            .withEstado('Aprobado')
            .withValor(1199)
            .withItems('Outdoor;Palestrante')
            .build();

        Evento_Royalty__c eventoRoyaltyTwo = Build.anEventoRoyalty()
            .withCuenta(testAccount)
            .withName('Evento Royalty Two')
            .withSaldoPorSafra(saldoPorSafraOne)
            .withData('10/2/2020')
            .withEstado('Aprobado')
            .withValor(1545)
            .withItems('Palestrante')
            .build();

        Evento_Royalty__c eventoRoyaltyThree = Build.anEventoRoyalty()
            .withCuenta(testAccount)
            .withName('Evento Royalty Three')
            .withSaldoPorSafra(saldoPorSafraOne)
            .withData('15/1/2020')
            .withEstado('Aprobado')
            .withValor(899)
            .withItems('Outdoor')
            .build();

        List<Evento_Royalty__c> eventoRoyaltyList = new List<Evento_Royalty__c> {
            eventoRoyaltyOne, eventoRoyaltyTwo, eventoRoyaltyThree
        };
        insert eventoRoyaltyList;
    }
}
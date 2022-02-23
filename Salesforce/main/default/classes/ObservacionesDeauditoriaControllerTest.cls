@IsTest
public with sharing class ObservacionesDeauditoriaControllerTest {
    @TestSetup
    static void isTestSetup(){
        Final Integer CANT_CONST = 5;
        Profile profileIdSupervisor = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        Profile profileIdGerente = [SELECT Id FROM Profile WHERE Name LIKE '%Gerente%' LIMIT 1];  
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

        List<Account> accList = new List<Account> ();
        for(Integer i = 0; i < CANT_CONST; i++){

            Account a = new Account(Name = 'Test account ' + i);
                                    a.type = 'Multiplicador';
                                    a.marca__c = 'BRMX';
                                    a.Supervisor__c =  supervisor.id;
                                    a.Gerente_comercial__c = gerente.id;
                                    accList.add(a);
        }
        for(Account a : accList){
            a.Interno__c = True;
        }
        insert accList;

		Plano_de_Auditoria__c planoAuditList = new Plano_de_Auditoria__c(
            						Cuenta_Principal__c = accList[0].id, 
                                    safra__c = '19/20',
                                    status__c = 'Concluido');

        insert planoAuditList;

        Resumo_da_Conta__c CRMs = new Resumo_da_conta__c(
            			Name = 'CRM test ',
                        Multiplicador__c = planoAuditList.cuenta_principal__c,
                        safra__c = '19/20',
                        Marca__c = 'BRMX');
        insert(CRMs);
    }

    @isTest
    public static void saveTest(){
        Plano_de_Auditoria__c planoAuditTest = [
            SELECT id, Cuenta_Principal__c 
            FROM Plano_de_Auditoria__c
            LIMIT 1
        ];
        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest);        
        Pagereference actualpage = page.ObservacionesDeAuditoria;
        test.setCurrentPage(actualPage);
        System.currentPageReference().getParameters().put('Safra', '19/20');
        ObservacionesDeAuditoriaController controller = new ObservacionesDeAuditoriaController(sc);
        controller.crm.safra__c = '18/19';

        Test.startTest();
        pageReference saveCRM = controller.save();
        Test.stopTest();

        Resumo_da_Conta__c crmToTest = [
                                        SELECT id,Safra__c
                                        FROM Resumo_da_Conta__c
                                        WHERE Multiplicador__c = :planoAuditTest.cuenta_principal__c
                                        LIMIT 1
        ];

        System.assertEquals('18/19', crmToTest.safra__c, 'Los datos del CRM No se han actualizado');
        System.assertEquals('/apex/AuditarVisita', saveCRM.getUrl(), 'El metodo debe redirigir a la Page AuditarVista');
    }
    @isTest
    public static void gotoAuditarTest(){
        Plano_de_Auditoria__c planoAuditTest = [
                                    SELECT id, Cuenta_Principal__c 
                                    FROM Plano_de_Auditoria__c
            						LIMIT 1
        ];
        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest);        
        Pagereference actualpage = page.ObservacionesDeAuditoria;
        test.setCurrentPage(actualPage);
        
        Test.startTest();
        System.currentPageReference().getParameters().put('Safra', '19/20');
        ObservacionesDeAuditoriaController controller = new ObservacionesDeAuditoriaController(sc);
        Test.stopTest();
        
        pageReference gotoAuditar = controller.gotoAuditar();

        System.assertEquals('/apex/AuditarVisita?Id=' + planoAuditTest.id, gotoAuditar.getUrl(), 'El metodo debe redirigir a la Page AuditarVista del plano actual');
    }

    @isTest
    public static void gotoCalendarioTest(){
        Plano_de_Auditoria__c planoAuditTest = [
                                    SELECT id, Cuenta_Principal__c 
                                    FROM Plano_de_Auditoria__c
            						LIMIT 1
        ];
        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest);
        Pagereference actualpage = page.ObservacionesDeAuditoria;
        test.setCurrentPage(actualPage);
        
        Test.startTest();
                System.currentPageReference().getParameters().put('Safra', '19/20');
        ObservacionesDeAuditoriaController controller = new ObservacionesDeAuditoriaController(sc);
        Test.stopTest();
        
        pageReference goToCalendario = controller.goToCalendario();

        System.assertEquals('/apex/FullCalendarDemo', goToCalendario.getUrl(), 'El metodo debe redirigir a la Page FullCalendarDemo');

    }
}
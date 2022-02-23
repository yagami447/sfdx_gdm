@isTest
private class AuditManagementControllerTest {

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

        Account[] accounts = new Account[2];

        accounts[0] = Build.anAccount()
            .withName('ACME INDUSTRY SRL')
            .withNomefantasia('ACME')
            .withType('Multiplicador')
            .withMultiplicador(true)
            .withAuditor(false)
            .withSupervisor(supervisor)
            .withGerenteComercial(gerente)
            .build();

        accounts[1] = Build.anAccount()
            .withName('RAPHAEL DE MATOS OLIVEIRA')
            .withMultiplicador(false)
            .withAuditor(true)
            .build();

        insert accounts;

        Plano_de_Auditoria__c plano = new Plano_de_Auditoria__c(
            Cuenta_Principal__c = accounts[0].Id,
            Safra__c = '18/19;19/20;20/21',
            Status__c = 'Não Iniciado'
        );

        insert plano;

        Calendar_Event__c[] visitas = new Calendar_Event__c[2];

        visitas[0] = new Calendar_event__c(
            Name = 'Visita sorpresa 1',
            Plano_de_Auditoria__c = plano.Id,
            Auditor__c = accounts[1].Id,
            Cidade__c = 'São Paulo',
            UF__c = 'SP',
            Etapa__c = 'Documental',
            Responsavel__c = 'Próprio',
            Start_Time__c = System.Today(),
            End_Time__c = System.today().addDays(1),
            Safra__c = '18/19;19/20'
        );

        visitas[1] = new Calendar_event__c(
            Name = 'Visita sorpresa 2',
            Plano_de_Auditoria__c = plano.Id,
            Auditor__c = accounts[1].Id,
            Cidade__c = 'São Vicente',
            UF__c = 'SP',
            Etapa__c = 'Eventual',
            Responsavel__c = 'Próprio',
            Start_Time__c = System.Today().addDays(2),
            End_Time__c = System.today().addDays(3),
            Safra__c = '20/21'
        );

        insert visitas;

		Producto_Auditado__c[] productos = new Producto_Auditado__c[3];

        productos[0] = new Producto_Auditado__c(Plano_de_Auditoria__c = plano.Id);
        productos[1] = new Producto_Auditado__c(Plano_de_Auditoria__c = plano.Id);
        productos[2] = new Producto_Auditado__c(Plano_de_Auditoria__c = plano.Id);

        insert productos;
    }

    @isTest static void getAuditorsTest() {
        Account account = null;
        List<Map<String, String>> auditors = null;

        Test.startTest();
        account = [SELECT Id, Name FROM Account WHERE Name = 'RAPHAEL DE MATOS OLIVEIRA' LIMIT 1];
        auditors = AuditManagementController.getAuditors();
        Test.stopTest();

        System.assert(!auditors.isEmpty(), 'La lista no contiene valores');

        Map<String, String> auditor = auditors[1];

        System.assert(auditor.containsKey('value'), 'El Object no contiene el campo value');
        System.assertEquals(account.Id, auditor.get('value'), 'El value no es el esperado');
        System.assert(auditor.containsKey('label'), 'El Object no contiene el campo label');
        System.assertEquals(account.Name, auditor.get('label'), 'El label no es el esperado');
    }

    @isTest static void getAuditPlansTest() {
        Plano_de_Auditoria__c plan = null;
        Map<Id, Plano_de_Auditoria__c> plans = null;

        Test.startTest();
        plan = [SELECT Id, Name FROM Plano_de_Auditoria__c LIMIT 1];
        plans = AuditManagementController.getAuditPlans();
        Test.stopTest();

        System.assert(!plans.isEmpty(), 'El mapa no contiene valores');
        System.assert(plans.containsKey(plan.Id), 'El mapa no contiene el plano insertado en la DB');
        System.assertEquals(plan.Name, plans.get(plan.Id).Name, 'El nombre del plano no coincide con el esperado');
    }

    @isTest static void getEventsTest() {
        List<Calendar_Event__c> events = null;

        Test.startTest();
        events = AuditManagementController.getEvents(
            new Map<String, List<String>>{
                'Cidade__c' => new String[]{'São Paulo'}, 'UF__c' => new String[]{'SP'}
            }
        );
        Test.stopTest();

        System.assertEquals(1, events.size(), 'La cantidad de registros retornados no coincide con la esperada');
        System.assertEquals('Visita sorpresa 1', events[0].Name, 'El evento retornado no es el esperado');
    }

    @isTest static void getFiltersTest() {
        Map<String, List<Map<String, String>>> filters = null;

        Test.startTest();
        filters = AuditManagementController.getFilters();
        Test.stopTest();

        Set<String> keys = new Set<String>{'Cidade__c','UF__c', 'Etapa__c', 'Responsavel__c'};

        for (String key : filters.keySet()) {
            System.assert(keys.contains(key), 'El mapa de filtros no posee la categoría ' + key);
        }

        List<Map<String, String>> auxList = new List<Map<String, String>>{
            new Map<String, String>{'value' => 'São Paulo', 'label' => 'São Paulo'},
            new Map<String, String>{'value' => 'São Vicente', 'label' => 'São Vicente'}
        };

        System.assert(auxList.equals(filters.get('Cidade__c')), 'La lista de filtros Cidade__c no es la esperada');

        auxList = new List<Map<String, String>>{new Map<String, String>{'value' => 'SP', 'label' => 'SP'}};

        System.assert(auxList.equals(filters.get('UF__c')), 'La lista de filtros UF__c no es la esperada');

        auxList = new List<Map<String, String>>{
            new Map<String, String>{'value' => 'Documental', 'label' => 'Documental'},
            new Map<String, String>{'value' => 'Eventual', 'label' => 'Eventual'}
        };

        System.assert(auxList.equals(filters.get('Etapa__c')), 'La lista de filtros Etapa__c no es la esperada');

        auxList = new List<Map<String, String>>{new Map<String, String>{'value' => 'Próprio', 'label' => 'Próprio'}};

        System.assert(auxList.equals(filters.get('Responsavel__c')), 'La lista de filtros Responsavel__c no es la esperada');
    }
}
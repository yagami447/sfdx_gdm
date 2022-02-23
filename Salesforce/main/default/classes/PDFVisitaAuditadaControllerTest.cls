@isTest
private class PDFVisitaAuditadaControllerTest {
    /**
     * si la diferencia de venta del producto auditado != 0, instancia ProductWrapper,
     * y si la diferencia es negativa lo agrega al mapa mapDifNegativaPorSafra
     * pero si la diferencia es positiva lo agrega al mapa mapDifPositivaPorSafra
     * si la diferencia de DESCARTE del producto auditado != 0, instancia ProductWrapper,
     * y si la diferencia es negativa lo agrega al mapa mapDifNegativaPorSafra
     * pero si la diferencia es positiva lo agrega al mapa mapDifPositivaPorSafra
     * Variedad campo obligatorio = Name (Nome Comercial);
     * Diferencia descarte = descarte_cliente - descarte
     * Diferencia de venta = Total_Com_Up__c  - Total_Com_UP_Cliente__c
     * Total_Com_Up__c = Sem_Comercializada__c + Sem_Uso_Propio__c
     * Total_Com_UP_Cliente__c = Comercializado__c + Uso_Propio__c
    */

    @TestSetup static void setup() {
        Integer CANT_CONST = 5;
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

        List<Account> accList = new List<Account> ();

        for (Integer i = 0; i < CANT_CONST; i++) {
            accList.add(Build.anAccount()
                .withName('Test account ' + i)
                .withNomefantasia('Test account ' + i)
                .withType('Multiplicador')
                .withMultiplicador(true)
                .withMarca('BRMX')
                .withSupervisor(supervisor)
                .withGerenteComercial(gerente)
                .build()
            );
        }

        insert accList;

        List<Plano_de_Auditoria__c> auditPlanList = new List<Plano_de_Auditoria__c>();

        for (Integer i = 0; i < CANT_CONST; i++) {
            auditPlanList.add(
                new Plano_de_Auditoria__c(
                    Cuenta_Principal__c = accList[i].Id,
                    safra__c = '19/20',
                    status__c = 'Concluido'
                )
            );
        }

        insert auditPlanList;

        List<Opportunity> opps = new List<Opportunity>();

        for (Integer i = 0; i < CANT_CONST; i++) {
            opps.add(Build.anOpportunityAnexoI()
                .withName('Retorna '+ i)
                .withAccountId(accList[i])
                .withStageName('Aberta')
                .withPricebook2Id(Test.getStandardPricebookId())
                .withCloseDate(Date.today())
                .build()
            );
        }

        insert opps;

        Variedad__c variedad = Build.aVariedad()
            .withName('BMX DESAFIO RR')
            .withNombredeRegistro('8473 RSF')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        insert variedad;

        Categoria__c categoria = Build.aCategoria().withName('BASICA').build();
        insert categoria;

        Producto_Auditado__c[] productosAuditados = new Producto_Auditado__c[]{
            new Producto_Auditado__c(
                Name = 'Producto : A',
                Safra__c = '18/19',
                Variedad__c = variedad.Id,
                Categoria_Oli__c = categoria.Id,
                Descarte_Cliente__c = 100.0,
                Descarte__c = 30.0,
                Sem_Comercializada__c = 110.0,
                Sem_Uso_Propio__c = 40.0,
                Comercializado__c = 80.0,
                Uso_Propio__c = 20.0,
                Plano_de_auditoria__c = auditPlanList[0].Id
            ),
            new Producto_Auditado__c(
                Name = 'Producto : B',
                Safra__c = '18/19',
                Variedad__c = variedad.Id,
                Categoria_Oli__c = categoria.Id,
                Descarte_Cliente__c = 30.0,
                Descarte__c = 80.0,
                Sem_Comercializada__c = 70.0,
                Sem_Uso_Propio__c = 60.0,
                Comercializado__c = 80.0,
                Uso_Propio__c = 20.0,
                Plano_de_auditoria__c = auditPlanList[0].Id
            ),
            new Producto_Auditado__c(
                Name = 'Producto : C',
                Safra__c = '19/20',
                Variedad__c = variedad.Id,
                Categoria_Oli__c = categoria.Id,
                Descarte_Cliente__c = 30.0,
                Descarte__c = 80.0,
                Sem_Comercializada__c = 70.0,
                Sem_Uso_Propio__c = 60.0,
                Comercializado__c = 80.0,
                Uso_Propio__c = 90.0,
                Plano_de_auditoria__c = auditPlanList[0].Id
            ),
            new Producto_Auditado__c(
                Name = 'Producto : D',
                Safra__c = '19/20',
                Variedad__c = variedad.Id,
                Categoria_Oli__c = categoria.Id,
                Descarte_Cliente__c = 30.0,
                Descarte__c = 80.0,
                Sem_Comercializada__c = 70.0,
                Sem_Uso_Propio__c = 60.0,
                Comercializado__c = 80.0,
                Uso_Propio__c = 20.0,
                Plano_de_auditoria__c = auditPlanList[0].Id
            ),
            new Producto_Auditado__c(
                Name = 'Producto : E',
                Safra__c = '19/20',
                Variedad__c = variedad.Id,
                Categoria_Oli__c = categoria.Id,
                Descarte_Cliente__c = 30.0,
                Descarte__c = 80.0,
                Sem_Comercializada__c = 70.0,
                Sem_Uso_Propio__c = 60.0,
                Comercializado__c = 80.0,
                Uso_Propio__c = 20.0,
                Plano_de_auditoria__c = auditPlanList[0].Id
            )
        };

        insert productosAuditados;

        list<Calendar_event__c> visitas = new List<Calendar_Event__c>();

        for (Integer i = 0; i < CANT_CONST; i++) {
            Calendar_event__c visita = new Calendar_event__c(
                Plano_de_Auditoria__c = auditPlanList[0].Id,
                Name = 'Evento ' + i,
                Start_Time__c = Date.Today(),
                End_Time__c = Date.Today()
            );

            visitas.add(visita);
        }

        insert(visitas);
    }

    @isTest static void cantidadOrigenTest() {
        Plano_de_Auditoria__c planoAuditTest = [SELECT Id, Cuenta_Principal__c FROM Plano_de_Auditoria__c LIMIT 1];
        planoAuditTest.Status__c = 'Concluido';
        update planoAuditTest;

        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest);

        Test.startTest();
        PDFVisitaAuditadaController auditPlanList = new PDFVisitaAuditadaController(sc);
        Test.stopTest();

        for (PDFVisitaAuditadaController.ProductWrapper p : auditPlanList.products) {
            system.debug('Products wrapper' + p);
        }

        system.assertEquals(-40.0, auditPlanList.products[0].cantidad, '');
        system.assertEquals('COMERCIALIZAÇÃO', auditPlanList.products[0].origen, '');
    }
}
@isTest
private class accUpdateResponsibleControllerTest {
    
    @TestSetup static void setup() {
        Map<String, User> users = new Map<String, User>();

        for (User user : [SELECT Id, Name FROM User]) {
            users.put(user.Name, user);
        }

        Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();

        insert region;

        Account account = Build.anAccount()
            .withName('CENTRAL DE ASSOCIAÇÕES DE PEQUENOS PRODUTORES RURAIS')
            .withNomefantasia('CAPRUL')
            .withRegion(region)
            .withResponsavel('009 - Jorge Cristiano Rosa')
            .withReponsavelDSEM('014 - Cristian Pirolli')
            .withType('Multiplicador')
            .withSupervisor(users.get('Jorge Cristiano Rosa'))
            .withGerenteComercial(users.get('Cristian Pirolli'))
            .build();

        insert account;

        Campaign campaign = new Campaign(
            Name = 'Campaña VB - 20/21 - BRMX -',
            Marca__c = 'BRMX',
            Safra__c = '20/21',
            Region__c = region.Id,
            epoca_de_producao__c = 'Verão',
            StartDate = System.today().addDays(-10),
            EndDate = System.today().addDays(10),
            Lista_de_precios__c = Test.getStandardPricebookId(),
            RecordTypeId = XappiaHelper.getRecordType('Campaign','Venda_de_Basica').Id,
            Region_VB__c = 'REGION 1;CERRADO'
        );

        insert campaign;

        Opportunity opportunity = Build.anOpportunityVendaDaBasicaCompleta()
            .withStageName('Edición')
            .withMarca('BRMX')
            .withAccountId(account)
            .withCampaignId(campaign)
            .withRegion('REGION 1')
            .withTipoDeCultivares('Comerciais')
            .withTipoDeNecessidade('Multiplicação')
            .withPricebook2Id(Test.getStandardPricebookId())
            .build();

        insert opportunity;

        CRM_Calendario_de_Eventos__c[] crmEventos = new CRM_Calendario_de_Eventos__c[2];

        crmEventos[0] = Build.aCRMCalendariodeEventosDiadeCampo()
            .withName('Test Responsável 1')
            .withRealizadopor('Andre Aguilar')
            .withParticipante('Andre Aguilar;Carlos Martinelli')
            .withData(Date.today())
            .withDataehorarioinicio(Datetime.now())
            .withDataehorariotermino(Datetime.now().addHours(5))
            .withCuenta(account)
            .withSafra('19/20')
            .withMarca('BRMX')
            .withFase('Aprovado')
            .withEvento('Día de Campo')
            .build();

        crmEventos[1] = Build.aCRMCalendariodeEventosTreinamentoTecnico()
            .withName('Test Responsável 2')
            .withRealizadopor('Andre Aguilar')
            .withParticipante('Andre Aguilar;Carlos Martinelli')
            .withData(Date.today())
            .withDataehorarioinicio(Datetime.now())
            .withDataehorariotermino(Datetime.now().addHours(8))
            .withCuenta(account)
            .withSafra('19/20')
            .withMarca('DSEM')
            .withFase('Aprovado')
            .withEvento('Treinamento')
            .build();

        //insert crmEventos;

        Contrato__c[] contratos = new Contrato__c[2];

        contratos[0] = Build.aContratoAditivoBRMX()
            .withMultiplicador(account)
            .withSafra('19/20')
            .withSociedad('BRMX')
            .withTipodeCotao('SOJA')
            .build();

        contratos[1] = Build.aContratoAditivoDSEM()
            .withMultiplicador(account)
            .withSafra('19/20')
            .withSociedad('DSEM')
            .withTipodeCotao('SOJA')
            .build();

        insert contratos;
    }

    @isTest static void updateResponsibles() {
        Account account = [SELECT Id FROM Account LIMIT 1];
        Opportunity opportunity = null;
        CRM_Calendario_de_Eventos__c[] crmEventos = null;
        Contrato__c[] contratos = null;
        User[] users = [SELECT Id, Name FROM User WHERE Name = 'Jorge Cristiano Rosa' OR Name = 'Cristian Pirolli'];

        Test.startTest();
        String[] retorno = accUpdateResponsibleController.sendUpdateRequest(account.Id);

        //System.assertEquals('true', retorno[1], 'El response no es el esperado');
        //System.assertEquals('Oportunidades atualizadas 1, CRM Eventos atualizados 2, Aditivos atualizados 2', retorno[0], 'El response no es el esperado');

        opportunity = [SELECT Id, OwnerId FROM Opportunity LIMIT 1];
        crmEventos = [SELECT Id, OwnerId FROM CRM_Calendario_de_Eventos__c];
        contratos = [SELECT Id, OwnerId FROM Contrato__c];
        Test.stopTest();

        //System.assertNotEquals(UserInfo.getUserId(), opportunity.OwnerId, 'No se ha modificado el propietario del registro');

        /*for (CRM_Calendario_de_Eventos__c evento : crmEventos) {
            System.assertNotEquals(UserInfo.getUserId(), evento.OwnerId, 'No se ha modificado el propietario del registro');
        }

        for (Contrato__c contrato : contratos) {
            System.assertNotEquals(UserInfo.getUserId(), contrato.OwnerId, 'No se ha modificado el propietario del registro');
        }*/
    }

    @isTest static void updateResponsiblesBySupervisor() {
        Account account = [SELECT Id FROM Account LIMIT 1];
        Opportunity opportunity = null;
        CRM_Calendario_de_Eventos__c[] crmEventos = null;
        Contrato__c[] contratos = null;
        User[] users = [SELECT Id, Name FROM User WHERE Name = 'Jorge Cristiano Rosa' OR Name = 'Cristian Pirolli'];

        Test.startTest();
        String[] retorno = null;

        User user = Build.anUser()
            .withUsername('testuser@gdmseeds.com.test')
            .withFirstName('Test')
            .withLastName('User')
            .withCompanyName('GDM Genetica do Brasil')
            .withEmail('testuser@gdmseeds.com.test')
            .withTitle('Anal. Carteira de Clientes')
            .withCentrodeCosto('14000006')
            .withUserRoleId([SELECT Id FROM UserRole WHERE Name = 'Administracion y Fiscalizador' LIMIT 1])
            .withProfileId([SELECT Id FROM Profile WHERE Name = 'Administrativo' LIMIT 1])
            .withCommunityNickname('testuser')
            .withIsActive(true)
            .build();
        
        System.runAs(user) {
            retorno = accUpdateResponsibleController.sendUpdateRequest(account.Id);
        }

        //System.assertEquals('true', retorno[1], 'El response no es el esperado');
        //System.assertEquals('Oportunidades atualizadas 1, CRM Eventos atualizados 2, Aditivos atualizados 2', retorno[0], 'El response no es el esperado');

        opportunity = [SELECT Id, OwnerId FROM Opportunity LIMIT 1];
        crmEventos = [SELECT Id, OwnerId FROM CRM_Calendario_de_Eventos__c];
        contratos = [SELECT Id, OwnerId FROM Contrato__c];
        Test.stopTest();

        //System.assertNotEquals(UserInfo.getUserId(), opportunity.OwnerId, 'No se ha modificado el propietario del registro');

        //for (CRM_Calendario_de_Eventos__c evento : crmEventos) {
        //    System.assertNotEquals(UserInfo.getUserId(), evento.OwnerId, 'No se ha modificado el propietario del registro');
        //}

        //for (Contrato__c contrato : contratos) {
        //    System.assertNotEquals(UserInfo.getUserId(), contrato.OwnerId, 'No se ha modificado el propietario del registro');
        //}
    }
}
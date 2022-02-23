@isTest
private class CRMEventoHandlerTest {

    @TestSetup static void setup() {
        Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX()
            .withPMSafraActualEventos('18/19')
            .withMarca('BRMX')
            .build();

        insert testConfiguracionBMX;

        Account account = Build.anAccount()
            .withName('JERE')
            .withNomefantasia('JRERE')
            .withResponsavel('061 - Fernando Frehner')
            .withType('Multiplicador')
            .build();

        insert account;

        Estado__c[] estados = new Estado__c[]{
            new Estado__c(
                Name = 'SP',
                Mostrar_en_portal__c = true,
                Estado_de_Origem__c = true
            ),
            new Estado__c(
                Name = 'MT',
                Mostrar_en_portal__c = true,
                Estado_de_Origem__c = true
            ),
            new Estado__c(
                Name = 'PR',
                Mostrar_en_portal__c = true,
                Estado_de_Origem__c = true
            )
        };

        insert estados;

        Cidade__c[] ciudades = new Cidade__c[]{
            new Cidade__c(
                Name = 'ADAMANTINA',
                GeoCod_municipio__c = '3500105',
                Mesorregion__c = 'PRESIDENTE PRUDENTE',
                Estado__c = estados[0].Id
            ),
            new Cidade__c(
                Name = 'ADOLFO',
                GeoCod_municipio__c = '3500204',
                Mesorregion__c = 'SÃO JOSÉ DO RIO PRETO',
                Estado__c = estados[0].Id
            ),
            new Cidade__c(
                Name = 'ALTA FLORESTA',
                GeoCod_municipio__c = '5100250',
                Mesorregion__c = 'NORTE MATO-GROSSENSE',
                Estado__c = estados[1].Id
            ),
            new Cidade__c(
                Name = 'APIACÁS',
                GeoCod_municipio__c = '5100805',
                Mesorregion__c = 'NORTE MATO-GROSSENSE',
                Estado__c = estados[1].Id
            ),
            new Cidade__c(
                Name = 'PINHAIS',
                GeoCod_municipio__c = '4119152',
                Mesorregion__c = 'METROPOLITANA DE CURITIBA',
                Estado__c = estados[2].Id
            ),
            new Cidade__c(
                Name = 'RIO BRANCO DO SUL',
                GeoCod_municipio__c = '4122206',
                Mesorregion__c = 'METROPOLITANA DE CURITIBA',
                Estado__c = estados[2].Id
            )
        };

        insert ciudades;

        Prazo_de_Lancamento__c[] plazos = new Prazo_de_Lancamento__c[]{
            new Prazo_de_Lancamento__c(
                Evento__c = 'Emplacamento',
                Inicio__c = '15/11',
                Termino__c = '15/02',
                Estado__c = estados[0].Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            ),
            new Prazo_de_Lancamento__c(
                Evento__c = 'Emplacamento',
                Inicio__c = '15/11',
                Termino__c = '15/01',
                Estado__c = estados[1].Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            ),
            new Prazo_de_Lancamento__c(
                Evento__c = 'Emplacamento',
                Inicio__c = '15/11',
                Termino__c = '15/01',
                Estado__c = estados[2].Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            ),
            new Prazo_de_Lancamento__c(
                Evento__c = 'Lado a Lado',
                Cadastro_de_plantio__c = '01/10',
                Cadastro_de_colheita__c = '03/01',
                Termino__c = '30/03',
                Estado__c = estados[0].Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            ),
            new Prazo_de_Lancamento__c(
                Evento__c = 'Lado a Lado',
                Cadastro_de_plantio__c = '01/10',
                Cadastro_de_colheita__c = '03/01',
                Termino__c = '30/03',
                Estado__c = estados[1].Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            ),
            new Prazo_de_Lancamento__c(
                Evento__c = 'Lado a Lado',
                Cadastro_de_plantio__c = '01/10',
                Cadastro_de_colheita__c = '03/01',
                Termino__c = '30/03',
                Estado__c = estados[2].Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            ),
            new Prazo_de_Lancamento__c(
                Evento__c = 'Treinamento Tecnico',
                Inicio__c = '01/03',
                Termino__c = '15/07',
                Estado__c = estados[0].Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            ),
            new Prazo_de_Lancamento__c(
                Evento__c = 'Treinamento Tecnico',
                Inicio__c = '01/03',
                Termino__c = '15/06',
                Estado__c = estados[1].Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            ),
            new Prazo_de_Lancamento__c(
                Evento__c = 'Treinamento Tecnico',
                Inicio__c = '01/03',
                Termino__c = '15/06',
                Estado__c = estados[2].Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            )
        };

        insert plazos;
    }

    @isTest static void beforeInsertTest() {
        Id accountId = [SELECT Id FROM Account].Id;
        Map<String, Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByDeveloperName();

        CRM_Calendario_de_Eventos__c[] crmEventos = new CRM_Calendario_de_Eventos__c[]{
            new CRM_Calendario_de_Eventos__c(
                Data__c = Date.today(),
                Cuenta__c = accountId,
                RecordTypeId = rtMapByName.get('Emplacamento').getRecordTypeId(),
                Fase__c = 'Edição',
                Safra__c = '18/19',
                Marca__c = 'BRMX',
                Municipio__c = [SELECT Id FROM Cidade__c WHERE Name = 'ADOLFO'].Id
            ),
            new CRM_Calendario_de_Eventos__c(
                Data__c = Date.today(),
                Cuenta__c = accountId,
                RecordTypeId = rtMapByName.get('Emplacamento').getRecordTypeId(),
                Fase__c = 'Edição',
                Safra__c = '18/19',
                Marca__c = 'BRMX',
                Municipio__c = [SELECT Id FROM Cidade__c WHERE Name = 'RIO BRANCO DO SUL'].Id
            ),
            new CRM_Calendario_de_Eventos__c(
                Data__c = Date.today(),
                Cuenta__c = accountId,
                RecordTypeId = rtMapByName.get('Test_a_campo').getRecordTypeId(),
                Fase__c = 'Edição',
                Safra__c = '18/19',
                Marca__c = 'BRMX',
                Municipio__c = [SELECT Id FROM Cidade__c WHERE Name = 'APIACÁS'].Id
            ),
            new CRM_Calendario_de_Eventos__c(
                Data__c = Date.today(),
                Cuenta__c = accountId,
                RecordTypeId = rtMapByName.get('Treinamento_Tecnico').getRecordTypeId(),
                Fase__c = 'Edição',
                Safra__c = '18/19',
                Marca__c = 'BRMX',
                Municipio__c = [SELECT Id FROM Cidade__c WHERE Name = 'ALTA FLORESTA'].Id
            )
        };

        Test.startTest();
        insert crmEventos;

        crmEventos = [
            SELECT Id, Name, Prazo_de_Lancamento__c, Prazo_de_Lancamento__r.Evento__c, Prazo_de_Lancamento__r.Estado__r.Name,
                Municipio__r.Name, Municipio__r.Nombre_Estado__c
            FROM CRM_Calendario_de_Eventos__c
        ];

        for (CRM_Calendario_de_Eventos__c crm : crmEventos) {
            if (crm.Municipio__r.Name == 'ADOLFO') {
                System.assert(crm.Prazo_de_Lancamento__c != null);
                System.assertEquals('Emplacamento', crm.Prazo_de_Lancamento__r.Evento__c);
                System.assertEquals('SP', crm.Prazo_de_Lancamento__r.Estado__r.Name);
                System.assertEquals('SP', crm.Municipio__r.Nombre_Estado__c);
            } else if (crm.Municipio__r.Name == 'RIO BRANCO DO SUL') {
                System.assert(crm.Prazo_de_Lancamento__c != null);
                System.assertEquals('Emplacamento', crm.Prazo_de_Lancamento__r.Evento__c);
                System.assertEquals('PR', crm.Prazo_de_Lancamento__r.Estado__r.Name);
                System.assertEquals('PR', crm.Municipio__r.Nombre_Estado__c);
            } else if (crm.Municipio__r.Name == 'APIACÁS') {
                System.assert(crm.Prazo_de_Lancamento__c != null);
                System.assertEquals('Lado a Lado', crm.Prazo_de_Lancamento__r.Evento__c);
                System.assertEquals('MT', crm.Prazo_de_Lancamento__r.Estado__r.Name);
                System.assertEquals('MT', crm.Municipio__r.Nombre_Estado__c);
            } else {
                System.assert(crm.Prazo_de_Lancamento__c != null);
                System.assertEquals('Treinamento Tecnico', crm.Prazo_de_Lancamento__r.Evento__c);
                System.assertEquals('MT', crm.Prazo_de_Lancamento__r.Estado__r.Name);
                System.assertEquals('MT', crm.Municipio__r.Nombre_Estado__c);
            }
        }
        Test.stopTest();
    }

    @isTest static void beforeUpdateTest() {
        Id accountId = [SELECT Id FROM Account].Id;
        Map<String, Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByDeveloperName();

        CRM_Calendario_de_Eventos__c[] crmEventos = new CRM_Calendario_de_Eventos__c[]{
            new CRM_Calendario_de_Eventos__c(
                Data__c = Date.today(),
                Cuenta__c = accountId,
                RecordTypeId = rtMapByName.get('Emplacamento').getRecordTypeId(),
                Fase__c = 'Edição',
                Safra__c = '18/19',
                Marca__c = 'BRMX'
            ),
            new CRM_Calendario_de_Eventos__c(
                Data__c = Date.today(),
                Cuenta__c = accountId,
                RecordTypeId = rtMapByName.get('Emplacamento').getRecordTypeId(),
                Fase__c = 'Edição',
                Safra__c = '18/19',
                Marca__c = 'BRMX'
            ),
            new CRM_Calendario_de_Eventos__c(
                Data__c = Date.today(),
                Cuenta__c = accountId,
                RecordTypeId = rtMapByName.get('Test_a_campo').getRecordTypeId(),
                Fase__c = 'Edição',
                Safra__c = '18/19',
                Marca__c = 'BRMX'
            ),
            new CRM_Calendario_de_Eventos__c(
                Data__c = Date.today(),
                Cuenta__c = accountId,
                RecordTypeId = rtMapByName.get('Treinamento_Tecnico').getRecordTypeId(),
                Fase__c = 'Edição',
                Safra__c = '18/19',
                Marca__c = 'BRMX'
            )
        };

        Test.startTest();
        insert crmEventos;

        for (CRM_Calendario_de_Eventos__c crm : [SELECT Id, Name, Municipio__c, Prazo_de_Lancamento__c FROM CRM_Calendario_de_Eventos__c]) {
            System.assert(crm.Municipio__c == null);
            System.assert(crm.Prazo_de_Lancamento__c == null);
        }

        crmEventos[0].Municipio__c = [SELECT Id FROM Cidade__c WHERE Name = 'ADOLFO'].Id;
        crmEventos[1].Municipio__c = [SELECT Id FROM Cidade__c WHERE Name = 'RIO BRANCO DO SUL'].Id;
        crmEventos[2].Municipio__c = [SELECT Id FROM Cidade__c WHERE Name = 'APIACÁS'].Id;
        crmEventos[3].Municipio__c = [SELECT Id FROM Cidade__c WHERE Name = 'ALTA FLORESTA'].Id;

        update crmEventos;

        crmEventos = [
            SELECT Id, Name, Prazo_de_Lancamento__c, Prazo_de_Lancamento__r.Evento__c, Prazo_de_Lancamento__r.Estado__r.Name,
                Municipio__r.Name, Municipio__r.Nombre_Estado__c
            FROM CRM_Calendario_de_Eventos__c
        ];

        for (CRM_Calendario_de_Eventos__c crm : crmEventos) {
            if (crm.Municipio__r.Name == 'ADOLFO') {
                System.assert(crm.Prazo_de_Lancamento__c != null);
                System.assertEquals('Emplacamento', crm.Prazo_de_Lancamento__r.Evento__c);
                System.assertEquals('SP', crm.Prazo_de_Lancamento__r.Estado__r.Name);
                System.assertEquals('SP', crm.Municipio__r.Nombre_Estado__c);
            } else if (crm.Municipio__r.Name == 'RIO BRANCO DO SUL') {
                System.assert(crm.Prazo_de_Lancamento__c != null);
                System.assertEquals('Emplacamento', crm.Prazo_de_Lancamento__r.Evento__c);
                System.assertEquals('PR', crm.Prazo_de_Lancamento__r.Estado__r.Name);
                System.assertEquals('PR', crm.Municipio__r.Nombre_Estado__c);
            } else if (crm.Municipio__r.Name == 'APIACÁS') {
                System.assert(crm.Prazo_de_Lancamento__c != null);
                System.assertEquals('Lado a Lado', crm.Prazo_de_Lancamento__r.Evento__c);
                System.assertEquals('MT', crm.Prazo_de_Lancamento__r.Estado__r.Name);
                System.assertEquals('MT', crm.Municipio__r.Nombre_Estado__c);
            } else {
                System.assert(crm.Prazo_de_Lancamento__c != null);
                System.assertEquals('Treinamento Tecnico', crm.Prazo_de_Lancamento__r.Evento__c);
                System.assertEquals('MT', crm.Prazo_de_Lancamento__r.Estado__r.Name);
                System.assertEquals('MT', crm.Municipio__r.Nombre_Estado__c);
            }
        }
        Test.stopTest();
    }
}
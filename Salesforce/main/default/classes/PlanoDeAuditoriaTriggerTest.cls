@isTest
private class PlanoDeAuditoriaTriggerTest {

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

        List<Account> accList = new List<Account>();

        for (Integer i = 0; i < 5; i++) {
            accList.add(Build.anAccount()
                .withName('Test Account ' + i)
                .withNomefantasia('Test Account ' + i)
                .withType('Multiplicador')
                .withMultiplicador(true)
                .withMarca('BRMX')
                .withSupervisor(supervisor)
                .withGerenteComercial(gerente)
                .build()
            );
        }

        insert accList;
    }

    @isTest static void siUnaCuentaTienePlanoPendiente_NodebePermitirInsertarElNuevoPlano() {
        List<Account> accList = [SELECT Id, Name FROM Account];
        List<Plano_de_Auditoria__c> auditPlanList = new List<Plano_de_Auditoria__c>();

        Plano_de_Auditoria__c planoOld = new Plano_de_Auditoria__c(
            Cuenta_Principal__c = accList[0].Id,
            safra__c = '19/20',
            status__c = 'Não Iniciado'
        );

        insert(planoOld);

        Plano_de_Auditoria__c planoNew = new Plano_de_Auditoria__c(
            Cuenta_Principal__c = accList[0].Id,
            safra__c = '19/20',
            status__c = 'Não Iniciado'
        );

        auditPlanList.add(planoNew);
    
        Test.startTest();
        Database.SaveResult[] sr = Database.Insert(auditPlanList, false);
        Test.stopTest();

        System.assertEquals(false, sr[0].isSuccess(),'Não deve haver plano de auditoria em estado pendente com a mesma safra selecionada como conta principal.');
    }

    @isTest static void siSeinsertaUnPlanoDebeRelacionarseEsePlanoConLaCuenta() {
        List<Account> accList = [SELECT Id, Name, Plano_de_Auditoria__c FROM Account];
        List<Plano_de_Auditoria__c> auditPlanList = new List<Plano_de_Auditoria__c>();

        Plano_de_Auditoria__c planoOld = new Plano_de_Auditoria__c (
            Cuenta_Principal__c = accList[0].Id, 
            safra__c = '19/20',
            status__c = 'Concluido'
        );

        insert(planoOld);

        Plano_de_Auditoria__c planoNew = new Plano_de_Auditoria__c (
            Cuenta_Principal__c = accList[0].Id, 
            safra__c = '19/20',
            status__c = 'Não Iniciado'
        );
    
        Test.startTest();
        insert(planoNew);
        Test.stopTest();

        List<Account> accListAControlar = [SELECT Id, Name, Plano_de_Auditoria__c FROM Account];
        System.assertEquals(planoNew.Id, accListAControlar[0].Plano_de_Auditoria__c,'No Se ha relacionado la cuenta con el plano Insertado');
    }
}
@isTest
private class PlanoDeAuditoriaTriggerHelperTest {

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
                new Plano_de_Auditoria__c (
                    Cuenta_Principal__c = accList[i].Id, 
                    safra__c = '19/20',
                    status__c = 'Concluido'
                )
            );
        }

        insert auditPlanList;
    }

    @isTest static void test() {
        List<Plano_de_Auditoria__c> auditPlanList = [SELECT Id, Cuenta_Principal__c FROM Plano_de_Auditoria__c];
        List<Account> accountList = [SELECT Id, Name,Plano_de_Auditoria__c FROM Account ORDER BY Id];

        auditPlanList[2].Cuenta_Principal__c = accountList[0].Id;

        system.debug('ACC ID TEST: ' + accountList[0].Id);
        system.debug('plano ID TEST: ' + auditPlanList[2].Cuenta_Principal__c);
        system.debug('ACC.plano ID TEST: ' + accountList[0].Plano_de_Auditoria__c);
        system.debug('plano.Id ID TEST: ' + auditPlanList[2].Id);
        PlanoDeAuditoriaTriggerHelper planoTriggerHelper = new PlanoDeAuditoriaTriggerHelper();
        
        Test.startTest();
        PlanoDeAuditoriaTriggerHelper.relatedCuentaPrincipalWithPlano(auditPlanList);
        Test.stopTest();
        
        List<Account> accountListToTest = [SELECT Id, Name, Plano_de_Auditoria__c FROM Account ORDER BY Id];

        system.assertEquals(auditPlanList[2].Id, accountListToTest[0].Plano_de_Auditoria__c, 'El plano de Auditoria No se ha relacionado a la cuenta');
    }
}
@isTest
private class addAccountToPlanoControllerTest {

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

        List<Account> accList = new List<Account>();

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
    }

    @isTest static void addAcountToAddTest() {
        Plano_de_Auditoria__c planoAuditTest = [SELECT Id, Cuenta_Principal__c FROM Plano_de_Auditoria__c LIMIT 1];

        planoAuditTest.status__c = 'Concluido';
        update planoAuditTest;

        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest);
        addAccountsToPlanoController controller = new addAccountsToPlanoController(sc);

        List<Account> accList = [SELECT Id FROM Account WHERE Id != :planoAuditTest.Cuenta_Principal__c];

        Test.startTest();
        controller.getAccounts();
        controller.toAdd = accList[0].Id;
        controller.addAccount();
        controller.toAdd = accList[1].Id;
        controller.addAccount();
        controller.getDisablePrevious();
        controller.getDisableNext();
        controller.Cancel();
        Test.stopTest();

        System.assertEquals(2, controller.accountsSelected.size(), 'The amount of accounts added should be [2]' 
                                                                    + ' but it is [' + controller.accountsSelected.size() + ']');
    }

    @isTest static void removeAccountToRemoveTest() {
        List<Plano_de_Auditoria__c> planoAuditTest = [SELECT Id, Cuenta_Principal__c FROM Plano_de_Auditoria__c];

        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest[0]);
        addAccountsToPlanoController controller = new addAccountsToPlanoController(sc);

        List<Account> accList = [SELECT Id FROM Account];

        planoAuditTest[0].Status__c = 'Não Iniciado';
        accList[0].Plano_de_Auditoria__c = planoAuditTest[0].Id;
        accList[0].Multiplicador__c = true;
        accList[1].Plano_de_Auditoria__c = planoAuditTest[0].Id;
        accList[1].Multiplicador__c = true;
        accList[2].Plano_de_Auditoria__c = planoAuditTest[0].Id;
        accList[2].Multiplicador__c = true;

        planoAuditTest[1].Status__c = 'Concluido';
        accList[3].Plano_de_Auditoria__c = planoAuditTest[1].Id;
        accList[3].Multiplicador__c = true;

        planoAuditTest[2].Status__c = 'Cancelado';
        accList[4].Plano_de_Auditoria__c = planoAuditTest[2].Id;
        accList[4].Multiplicador__c = true;
        update accList;
        update planoAuditTest;
        controller.retrieveAccountsFromPlanoDeAuditoria();
       
        Test.startTest();
        controller.toRemove = accList[0].Id;
        controller.removeAccount();
        Test.stopTest();

        System.assertEquals(2, controller.accountsSelected.size(), 'The amount of accounts added should be [2]' 
                                                                + ' but it is [' + controller.accountsSelected.size() + ']');
        System.assertEquals(3, controller.accountsInDataBase.size(), 'The amount of accounts in accountsInDataBase should be [3]' 
                                                                + ' but it is [' + controller.accountsInDataBase.size() + ']');
    }

    @isTest static void retrieveAccountsFromPlanoDeAuditoriaTest() {
        List<Plano_de_Auditoria__c> planoAuditTest = [SELECT Id, Cuenta_Principal__c FROM Plano_de_Auditoria__c];

        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest[0]);
        addAccountsToPlanoController controller = new addAccountsToPlanoController(sc);

        List<Account> accList = [SELECT Id FROM Account];

        accList[0].Plano_de_Auditoria__c = controller.planoDeAuditoria;
        accList[1].Plano_de_Auditoria__c = controller.planoDeAuditoria;

        /* Plano_de_Auditoria__r.Status__c = Auditado, Multiplicador__c = true */
        accList[2].Plano_de_Auditoria__c = planoAuditTest[2].Id;
        accList[2].Multiplicador__c = true;
        planoAuditTest[2].Status__c = 'Concluido';

        /* Plano_de_Auditoria__r.Status__c = Auditado, Multiplicador__c = false */
        accList[3].Plano_de_Auditoria__c = planoAuditTest[3].Id;
        accList[3].Multiplicador__c = false;
        planoAuditTest[3].Status__c = 'Concluido';

        /* Plano_de_Auditoria__r.Status__c = Pendente, Multiplicador__c = true */
        accList[4].Plano_de_Auditoria__c = planoAuditTest[4].Id;
        accList[4].Multiplicador__c = true;
        planoAuditTest[4].Status__c = 'Não Iniciado';

        update planoAuditTest;
        update accList;

        Test.startTest();
        controller.retrieveAccountsFromPlanoDeAuditoria();
        Test.stopTest();

        System.assertEquals(2, controller.accountsSelected.size(), 'The amount of accounts added should be [2]' 
                                                                + ' but it is [' + controller.accountsSelected.size() + ']');
        System.assertEquals(1, controller.accountsInDataBase.size(), 'The amount of accounts in accountsInDataBase should be [1]' 
                                                                + ' but it is [' + controller.accountsInDataBase.size() + ']');
        System.assertEquals(accList[0].Id, controller.accountsSelected.get(accList[0].Id).Id, 'The AccountSelected[0] should be[' + accList[0].Id + ']' 
                                                                            + ' but it is [' + controller.accountsSelected.get(accList[0].Id).Id + ']');
        System.assertEquals(accList[1].Id, controller.accountsSelected.get(accList[1].Id).Id, 'The AccountSelected[1] should be[' + accList[1].Id + ']' 
                                                                            + ' but it is [' + controller.accountsSelected.get(accList[1].Id).Id + ']');
        System.assertEquals(accList[2].Id, controller.accountsInDataBase.get(accList[2].Id).Id, 'The AccountInDataBase[0] should be[' + accList[2].Id + ']' 
                                                                            + ' but it is [' + controller.accountsInDataBase.get(accList[2].Id).Id + ']');
        System.assertEquals(null, controller.accountsInDataBase.get(accList[3].Id), 'An account with Multiplicador__c = [FALSE]' 
                                                                                        + ' should not be added to AccountsInDataBase.');
        System.assertEquals(null, controller.accountsInDataBase.get(accList[4].Id), 'An account with Plano_de_Auditoria__c != Pendente' 
                                                                                        + ' should not be added to AccountsInDataBase.');
    }

    @isTest static void getAccount_With_AccountSearch_Null_Test() {
        List<Plano_de_Auditoria__c> planoAuditTest = [SELECT Id, Cuenta_Principal__c, Status__c FROM Plano_de_Auditoria__c];

        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest[0]);
        addAccountsToPlanoController controller = new addAccountsToPlanoController(sc);

        List<Account> accList = [SELECT Id, Name, Multiplicador__c, Plano_de_Auditoria__r.Status__c FROM Account];

        //agrego en accountSelected dos cuentas con plano_de_auditoria == RecordId
        accList[0].Plano_de_Auditoria__c = controller.planoDeAuditoria;
        controller.accountsSelected.put(accList[0].Id, accList[0]);
        accList[1].Plano_de_Auditoria__c = controller.planoDeAuditoria;
        controller.accountsSelected.put(accList[1].Id, accList[1]);

        /* Plano_de_Auditoria__r.Status__c = Auditado, Multiplicador__c = true */
        accList[2].Plano_de_Auditoria__c = planoAuditTest[2].Id;
        accList[2].Multiplicador__c = true;
        planoAuditTest[2].Status__c = 'Concluido';

        /* Plano_de_Auditoria__r.Status__c = Auditado, Multiplicador__c = false */
        accList[3].Plano_de_Auditoria__c = planoAuditTest[3].Id;
        accList[3].Multiplicador__c = false;
        planoAuditTest[3].Status__c = 'Concluido';

        /* Plano_de_Auditoria__r.Status__c = Pendente, Multiplicador__c = true */
        accList[4].Plano_de_Auditoria__c = planoAuditTest[4].Id;
        accList[4].Multiplicador__c = true;
        planoAuditTest[4].Status__c = 'Não Iniciado';
        update planoAuditTest;
        update accList;

        Test.startTest();
        controller.getAccounts();
        Test.stopTest();
       
        System.assertEquals(2, controller.accountsSelected.size());
        System.assertEquals(1, controller.accountsInDataBase.size());
    }

    @isTest static void getAccount_With_AccountSearch_NotNull_Test() {
        List<Plano_de_Auditoria__c> planoAuditTest = [SELECT Id, Cuenta_Principal__c FROM Plano_de_Auditoria__c];

        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest[0]);
        addAccountsToPlanoController controller = new addAccountsToPlanoController(sc);

        List<Account> accList = [SELECT Id, Name FROM Account];

        //agrego en accountSelected dos cuentas con plano_de_auditoria == RecordId
        accList[0].Plano_de_Auditoria__c = controller.planoDeAuditoria;
        controller.accountsSelected.put(accList[0].Id, accList[0]);
        accList[1].Plano_de_Auditoria__c = controller.planoDeAuditoria;
        controller.accountsSelected.put(accList[1].Id, accList[1]);

        /* Plano_de_Auditoria__r.Status__c = Auditado, Multiplicador__c = true */
        accList[2].Plano_de_Auditoria__c = planoAuditTest[2].Id;
        accList[2].Multiplicador__c = true;
        planoAuditTest[2].Status__c = 'Concluido';

        /* Plano_de_Auditoria__r.Status__c = Auditado, Multiplicador__c = false */
        accList[3].Plano_de_Auditoria__c = planoAuditTest[3].Id;
        accList[3].Multiplicador__c = false;
        planoAuditTest[3].Status__c = 'Concluido';

        /* Plano_de_Auditoria__r.Status__c = Pendente, Multiplicador__c = true */
        accList[4].Plano_de_Auditoria__c = planoAuditTest[4].Id;
        accList[4].Multiplicador__c = true;
        planoAuditTest[4].Status__c = 'Não Iniciado';

        controller.accountSearch = accList[2].Name;
        update accList;
        update planoAuditTest;

        Test.startTest();
        controller.getAccounts();
        Test.stopTest();

        System.assertEquals(2, controller.accountsSelected.size());
        System.assertEquals(1, controller.accountsInDataBase.size());
    }

    @isTest static void saveTest() {
        List<Plano_de_Auditoria__c> planoAuditTest = [SELECT Id, Cuenta_Principal__c, Status__c FROM Plano_de_Auditoria__c];

        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest[0]);
        addAccountsToPlanoController controller = new addAccountsToPlanoController(sc);

        List<Account> accList = [
            SELECT Id, Name, Plano_de_Auditoria__c, Plano_de_Auditoria__r.Status__c, Multiplicador__c FROM Account ORDER BY Name
        ];

        controller.retrieveAccountsFromPlanoDeAuditoria();

        accList[0].Multiplicador__c = true;
        accList[1].Multiplicador__c = true;
        controller.toAdd = accList[1].Id;
        controller.addAccount();
        accList[2].Multiplicador__c = true;
        controller.toAdd = accList[2].Id;
        controller.addAccount();

        controller.toRemove = accList[2].Id;
        controller.removeAccount();

        List<Opportunity> anexos = [
            SELECT Id, Name, Account.Name, RecordType.Name, Marca__c, Safra__c,
                Plano_de_Auditoria__c, Plano_de_Auditoria__r.Status__c, Plano_de_Auditoria__r.Safra__c
            FROM Opportunity ORDER BY Name
        ];

        anexos[0].RecordType.DeveloperName = 'AnexoI';
        anexos[0].Plano_de_Auditoria__c = planoAuditTest[1].Id;
        planoAuditTest[1].Status__c = 'Não Iniciado';
        anexos[0].AccountId = accList[2].Id;

        anexos[1].RecordType.DeveloperName = 'AnexoII';
        anexos[1].Plano_de_Auditoria__c = planoAuditTest[2].Id;
        planoAuditTest[2].Status__c = 'Não Iniciado';
        anexos[1].AccountId = accList[3].Id;

        update planoAuditTest;
        update anexos;

        Test.startTest();
        controller.save();
        Test.stopTest();

        List<Account> accListToVerify = [
            SELECT Id, Name, Plano_de_Auditoria__c, Plano_de_Auditoria__r.Status__c 
            FROM Account ORDER BY Name
        ];

        List<Opportunity> anexosToVerify = [
            SELECT Id, Name, Account.Name, RecordType.Name, Marca__c, Safra__c, Plano_de_Auditoria__c,
                Plano_de_Auditoria__r.Status__c, Plano_de_Auditoria__r.Safra__c
            FROM Opportunity ORDER BY Name
        ];

        System.assertEquals(controller.toRemove, accListToVerify[2].Id, 'Account to remove must be assigned to toRemove variable');
        System.assertEquals(null, accListToVerify[2].Plano_de_Auditoria__c, 'Plano_de_Auditoria in variable toRemove, must be deleted from Account');
    }

    @isTest static void nextPageTest() {
        List<Plano_de_Auditoria__c> planoAuditTest = [SELECT Id, Cuenta_Principal__c, Status__c FROM Plano_de_Auditoria__c];

        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest[0]);
        addAccountsToPlanoController controller = new addAccountsToPlanoController(sc);

        controller.OffsetSize = 0;
        controller.QueryLimit = 2;

        List<Account> accListSetup = [
            SELECT Id, Name, Plano_de_Auditoria__c, Plano_de_Auditoria__r.Status__c FROM Account ORDER BY Name
        ];

        for (Account a : accListSetup) { a.Plano_de_Auditoria__c = planoAuditTest[1].Id; }

        update accListSetup;

        controller.retrieveAccountsFromPlanoDeAuditoria();

        Test.startTest();
        controller.next();
        Test.StopTest();

        System.assertEquals(accListSetup[controller.OffsetSize].Id, controller.accountsInDataBase.values()[0].Id);
    }

    @isTest static void previusPageTest() {
        List<Plano_de_Auditoria__c> planoAuditTest = [SELECT Id, Cuenta_Principal__c, Status__c FROM Plano_de_Auditoria__c];

        ApexPages.StandardController sc = new ApexPages.standardController(planoAuditTest[0]);
        addAccountsToPlanoController controller = new addAccountsToPlanoController(sc);
        
        controller.OffsetSize = 4;
        controller.QueryLimit = 2;
        
        List<Account> accListSetup = [
            SELECT Id, Name, Plano_de_Auditoria__c, Plano_de_Auditoria__r.Status__c FROM Account ORDER BY Name
        ];

        for (Account a : accListSetup) {
            a.Plano_de_Auditoria__c = planoAuditTest[1].Id;
        }

        update accListSetup;

        controller.retrieveAccountsFromPlanoDeAuditoria();

        Test.startTest();
        controller.previous();
        Test.StopTest();

        System.assertEquals(accListSetup[controller.OffsetSize].Id, controller.accountsInDataBase.values()[0].Id);
    }
}
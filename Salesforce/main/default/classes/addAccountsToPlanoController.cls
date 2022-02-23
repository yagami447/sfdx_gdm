public without sharing class addAccountsToPlanoController {

    @TestVisible public Map<Id, Account> accountsSelected       {get; set;}
    @TestVisible public Id planoDeAuditoria                     {get; set;}
    @TestVisible public Map<Id, Account> accountsInDataBase     {get; set;}
    @TestVisible public List<SelectOption> accounts             {get; set;}
    @TestVisible public Id toAdd                                {get; set;}
    @TestVisible public Id toRemove                             {get; set;}
    @TestVisible public String accountSearch                    {get; set;}
    @TestVisible public Integer OffsetSize = 0;
    @TestVisible public Integer QueryLimit = 30;
    @TestVisible public Integer CountTotalRecords;
    @TestVisible public List<Id> accToDelete;

    public addAccountsToPlanoController(ApexPages.StandardController controller) {
        planoDeAuditoria = controller.getRecord().Id; 
        accountsSelected = new Map<Id, Account>();
        accounts = new List<SelectOption>();   
        accToDelete = new List<Id>(); 
        CountTotalRecords= [select count() from Account];
    }

    public void retrieveAccountsFromPlanoDeAuditoria() {
        List<Account> accFromPlano = [SELECT Id, Name FROM Account WHERE Plano_de_Auditoria__c = :planoDeAuditoria ORDER BY Name];

        for (Account acc : accFromPlano) {
            accountsSelected.put(acc.Id, acc);
        }

        getAccounts();
    }

    public void getAccounts() {
        List<Account> accs;

        if (String.isNotEmpty(accountSearch)) {
            accs = [
                SELECT Id, Name FROM Account
                WHERE Name LIKE :('%' + accountSearch + '%') AND Id NOT IN :accountsSelected.keySet() AND
                    Plano_de_Auditoria__r.Status__c NOT IN ('Não Iniciado', 'Em andamento') AND Multiplicador__c = true
                ORDER BY Name
            ];
        } else {
            accs = [
                SELECT Id, Name FROM Account
                WHERE Id NOT IN :accountsSelected.keySet() AND
                    Plano_de_Auditoria__r.Status__c NOT IN ('Não Iniciado', 'Em andamento') AND Multiplicador__c = true
                ORDER BY Name LIMIT :QueryLimit OFFSET :OffsetSize
            ];
        }

        accountsInDataBase = new Map<Id, Account>(accs);
    }

    public void addAccount() {
        accountsSelected.put(toAdd, accountsInDataBase.get(toAdd));
        accountsInDataBase.remove(toAdd);
    }

    public void removeAccount() {
        Account acc = accountsSelected.get(toRemove);
        accountsSelected.remove(toRemove);
        accToDelete.add(toRemove);
        getAccounts();
        accountsInDataBase.put(acc.Id, acc);
    }

    public PageReference next() {
        OffsetSize += QueryLimit;
        getAccounts();
        return null;
    }

    public PageReference previous() {
        OffsetSize -= QueryLimit;
        getAccounts();
        return null;
    }

    public Boolean getDisablePrevious() {
        return OffsetSize <= 0;
    }

    public Boolean getDisableNext() {
        return OffsetSize + QueryLimit >= countTotalRecords;
    }

    public PageReference save() {
        for (Account acc : accountsSelected.values()) {
            acc.Plano_de_Auditoria__c = planoDeAuditoria;
        }

        for (Account acc : [SELECT Id, Name, Plano_de_Auditoria__c FROM Account WHERE Id IN :accToDelete]) {
            acc.Plano_de_Auditoria__c = null;
            accountsSelected.put(acc.Id, acc); // Agrego la acc a este mapa para hacer un solo update, por mas que esta opp seria las que se desligaron del plano de auditoria.
        }

        update accountsSelected.values();

        Plano_de_Auditoria__c plano = [SELECT Id, Safra__c FROM Plano_de_Auditoria__c WHERE Id = :planoDeAuditoria];

        List<Opportunity> anexos = [
            SELECT Id, Name, Account.Name, RecordType.Name, Marca__c, Safra__c,
                Plano_de_Auditoria__c, Plano_de_Auditoria__r.Status__c, Plano_de_Auditoria__r.Safra__c
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'AnexoI' AND AccountId IN :accountsSelected.values() AND
                Plano_de_Auditoria__r.Status__c NOT IN ('Concluido', 'Cancelado') AND Safra__c IN :plano.Safra__c.split(';') AND StageName = 'Aprobada'
        ];

        for (Opportunity anexo : anexos) {
            anexo.Plano_de_Auditoria__c = planoDeAuditoria;
        }

        update anexos;
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }

    public PageReference cancel() {
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
}
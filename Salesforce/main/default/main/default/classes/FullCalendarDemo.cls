global with sharing class FullCalendarDemo {

    global List<SelectOption> planos                {get; set;}
    @TestVisible public Id planoDeAuditoria         {get; set;}
    global String PlanoId                           {get; set;}
    global Calendar_Event__c visita                 {get; set;}
    public Map<String, Account> accountsSearched    {get; set;}
    public List<SelectOption> accounts              {get; set;}
    public String accountSearch                     {get; set;}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    public String accountSelected                   {get; set;}

    public FullCalendarDemo(ApexPages.StandardController controller) {
        accountSelected ='';
        planoDeAuditoria = controller.getRecord().Id; 
        planos = new List<SelectOption>();
        accounts = new List<SelectOption>();
        List<Plano_de_Auditoria__c> planosInDB = [SELECT Id, Name, Nombre__c FROM Plano_de_Auditoria__c];

        for (Plano_de_Auditoria__c plano : planosInDB) {
            planos.add(new SelectOption(plano.Id, plano.Nombre__c));
        }

        visita = new Calendar_Event__c();
    }

    @RemoteAction
    global static List<Calendar_Event__c> getEvents(String accSearch) {
        List<Calendar_Event__c> userCalendar;

        if (String.isNotEmpty(accSearch)) {
            userCalendar = [
                SELECT Id, Name, Plano_de_Auditoria__r.Name, Plano_de_Auditoria__r.Nombre__c, Plano_de_Auditoria__r.Cuenta_Principal__c,
                    Plano_de_Auditoria__r.Cuenta_Principal__r.Name, Start_Time__c, End_Time__c, Cidade__c, UF__c, Etapa__c, Auditor__c, Auditor__r.Name, Responsavel__c
                FROM Calendar_Event__c
                WHERE Plano_de_Auditoria__c != null AND (Plano_de_Auditoria__r.Cuenta_Principal__r.Name != null AND Auditor__r.Name = :accSearch)
                LIMIT 100
            ];
        } else {
            userCalendar = [
                SELECT Id, Name, Plano_de_Auditoria__r.Name, Plano_de_Auditoria__r.Nombre__c, Plano_de_Auditoria__r.Cuenta_Principal__c,
                    Plano_de_Auditoria__r.Cuenta_Principal__r.Name, Start_Time__c, End_Time__c, Cidade__c, UF__c, Etapa__c, Auditor__c, Auditor__r.Name, Responsavel__c
                FROM Calendar_Event__c
                WHERE Plano_de_Auditoria__c != null AND Plano_de_Auditoria__r.Cuenta_Principal__r.Name != null
            ];
        }

        return userCalendar.isEmpty() ? null : userCalendar;
    }

    public void getAuditoresString() {
        accountsSearched = new Map<String, Account>();
        List<Account> accs;

        if (String.isNotEmpty(accountSearch)) {
            accs = [SELECT Id, Name FROM Account WHERE Interno__c = true AND Name LIKE :accountSearch + '%' ORDER BY Name];
        } else if (accountSearch == '') {
            accs = [SELECT Id, Name FROM Account WHERE Interno__c = true ORDER BY Name];
        }

        if (accs != null) {
            for (Account acc : accs) {
                accountsSearched.put(acc.Name, acc);
            }
        }
    }

    public List<SelectOption> getAuditoresOption() {
        List<SelectOption> auditores = new List<SelectOption>(); 
        List<Account> accs;

        if (String.isNotEmpty(accountSearch)) {
            accs = [SELECT Id, Name FROM Account WHERE Interno__c = true AND Name LIKE :accountSearch + '%' ORDER BY Name];
        } else if (accountSearch == '') {
            accs = [SELECT Id, Name FROM Account WHERE Interno__c = true ORDER BY Name];
        }

        if (accs != null) {
            for (Account acc : accs) {
                auditores.add(new SelectOption(acc.Name, acc.Name));
            }
        }

        return auditores;
    }

    @RemoteAction
    global static List<Calendar_Event__c> createOrUpdateEvents(String calendarEvent, String accSearch) {
        //Geting Calendar_Event__c object from received Json String
        System.Debug('JSON: ' + calendarEvent);
        Calendar_Event__c eventObject = ((Calendar_Event__c) JSON.deserialize(calendarEvent, Calendar_Event__c.class));
        //eventObject.Plano_de_Auditoria__c = planoDeAuditoria;
        System.Debug('Evento 1: ' + eventObject);
        if (String.valueOf(eventObject.Id) == 'nuevo') {
            eventObject.Id = null;
        }
        System.Debug('Evento 2: ' + eventObject);
        upsert eventObject;
        return getEvents(accSearch);
    }

    public PageReference cancel() {
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }

    public PageReference auditarCtrl() {
        PageReference pr = new PageReference('/apex/AuditarVisita');
        //PlanoId = apexpages.currentPage().getParameters().get('Id');
        System.debug('PlanoId :' + PlanoId);
        List<Calendar_event__c> visitasPendientesDelPlanoActual = [
            SELECT id, Plano_de_Auditoria__r.Name, status__c, Start_Time__c
            FROM Calendar_event__c 
            WHERE Plano_de_Auditoria__c = :PlanoId 
            AND status__c = 'Pendente' 
            ORDER BY Start_Time__c DESC
        ];

        if (visitasPendientesDelPlanoActual == null || visitasPendientesDelPlanoActual.size() == 0) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'O evento não tem auditorias válidas pendentes'));
            return null;
        }

        pr.getParameters().put('Id',PlanoId);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;
    }

    public void clearMessages() {
        ApexPages.getMessages().clear();
    }
}
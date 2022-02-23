@isTest
private class CRMEventoUtilsTest {

    @TestSetup
    static void makeData() {

        Estado__c newState = new Estado__c();
        newState.Name = 'ESTADO TEST';
        insert newState;

        Account newAccount = new Account();
        newAccount.Name = 'ACME';
        newAccount.Estado__c = newState.Id;
        newAccount.Supervisor__c = UserInfo.getUserId();

        newAccount.Responsavel__c = '104 - Otavio Gorni';
        newAccount.Reponsavel_DSEM__c = '014 - Cristian Pirolli';
        newAccount.Responsavel_NEOGEN__c = '020 - Eduardo L. da Silva';
        newAccount.Responsavel_DAGMA__c = '033 - Gustavo Suzano';
        newAccount.Responsavel_LICENCAS__c = '124 - Thiago Schwonka'; 
        insert newAccount;
    }

    @isTest
    static void testBRMX(){
      
      CRMEventoUtils crm = new CRMEventoUtils();
      Account cuenta = [Select Id, Estado__c From Account Where Name = 'ACME' limit 1]; 
        
      CRM_Calendario_de_Eventos__c eventos = new CRM_Calendario_de_Eventos__c();
        eventos.evento__c = 'Emplacamento';
        eventos.cuenta__c = cuenta.Id;
        eventos.Marca__c = 'BRMX';
        eventos.data__c = system.today();
        eventos.Data_e_horario_inicio__c = System.Now();
        eventos.Data_e_horario_termino__c = System.Now()+1;
        eventos.Custo__c = 32;
        eventos.safra__c = '17/18';
        insert eventos;      
        
        eventos.data__c = system.today() + 1;
        update eventos;
    }
    
    @isTest
    static void testDSEM(){      
        Account cuenta = [Select Id, Estado__c From Account Where Name = 'ACME' limit 1];
      
        CRM_Calendario_de_Eventos__c eventos = new CRM_Calendario_de_Eventos__c();
        eventos.evento__c = 'Día de Campo';
        eventos.cuenta__c = cuenta.Id;
        eventos.Marca__c = 'DSEM';
        eventos.Data_e_horario_inicio__c = System.Now();
        eventos.Data_e_horario_termino__c = System.Now()+1;
        eventos.Custo__c = 32;
        eventos.data__c = system.today();
        eventos.safra__c = '17/18';
        insert eventos;
        
        CRM_Calendario_de_Eventos__c eventos2 = new CRM_Calendario_de_Eventos__c();
        eventos2.evento__c = 'Emplacamento';
        eventos2.cuenta__c = cuenta.Id;
        eventos2.Marca__c = 'DSEM';
        eventos2.Data_e_horario_inicio__c = System.Now();
        eventos2.Data_e_horario_termino__c = System.Now()+1;        
        eventos2.data__c = system.today();
        eventos2.safra__c = '17/18';
        insert eventos2;

    }
}
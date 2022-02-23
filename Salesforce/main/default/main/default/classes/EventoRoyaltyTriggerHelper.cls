global class EventoRoyaltyTriggerHelper {
    public static void sincronizarSupervisorYGerenteComercial(List<Evento_Royalty__c> eventosConAccount){
        Map<Evento_Royalty__c,Account> mapaEventoAccount = new Map<Evento_Royalty__c,Account>();
        List<Id> idsAccounts = new List<Id>();
        List<Account> Accounts = new List<Account>();
        for(Evento_Royalty__c evento : eventosConAccount){
            System.debug('Cuenta: '+evento.Cuenta__c);
            idsAccounts.add(evento.Cuenta__c);
        }
        Accounts = [
            SELECT Id,Supervisor__c,Gerente_comercial__c
            FROM Account
            WHERE Id IN : idsAccounts
        ];
        System.debug('Cuentas en BBDD: '+Accounts);
        for(Evento_Royalty__c evento : eventosConAccount){
            for(Account cuenta : Accounts){
                if(evento.Cuenta__c == cuenta.Id){
                    evento.Supervisor__c = cuenta.Supervisor__c;
                    evento.Gerente_comercial__c = cuenta.Gerente_comercial__c;
                }
            }
        }
    }

    
}
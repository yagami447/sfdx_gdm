public class PlanoDeAuditoriaTriggerHelper {

    public static void relatedCuentaPrincipalwithPlano(List<Plano_de_Auditoria__c> planos) {
        List<Id> accs = new List<Id>();

        for (Plano_de_Auditoria__c plano : planos) {
            accs.add(plano.Cuenta_Principal__c);
        }

        List<Account> accounts = [SELECT Id, Name, Plano_de_Auditoria__c FROM Account WHERE Id IN :accs];

        for (Plano_de_Auditoria__c plano: planos) {
            for (Account acc : accounts) {
                if (plano.Cuenta_Principal__c == acc.Id) {
                    acc.Plano_de_Auditoria__c = plano.Id;
                }
            }
        }

        update accounts;
    }
}
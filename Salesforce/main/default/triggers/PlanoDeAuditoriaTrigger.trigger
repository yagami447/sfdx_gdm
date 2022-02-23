trigger PlanoDeAuditoriaTrigger on Plano_de_Auditoria__c (before insert, after insert) {

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            List<Plano_de_Auditoria__c> planos = [SELECT Id, Name, Cuenta_Principal__c, Safra__c, Status__c FROM Plano_de_Auditoria__c];
            List<String> safrasNew = new List<String>();
            List<String> safrasOld = new List<String>();

            for (Plano_de_Auditoria__c planoNew : Trigger.new) {
                for (Plano_de_Auditoria__c planoOld : planos) {                    
                    safrasNew = planoNew.Safra__c.split(';');
                    safrasOld = planoOld.Safra__c.split(';');

                    for (String safra : safrasNew) {
                        if (planoNew.Cuenta_Principal__c == planoOld.Cuenta_Principal__c && safrasOld.contains(safra) && (planoOld.Status__c == 'Não Iniciado' || planoOld.Status__c == 'Em andamento')) {
                            planoNew.addError('Não deve haver plano de auditoria em estado pendente com a mesma safra selecionada como conta principal.');
                        }
                    }                    
                }
            }
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            PlanoDeAuditoriaTriggerHelper.relatedCuentaPrincipalwithPlano(Trigger.new);
        }
    }
}
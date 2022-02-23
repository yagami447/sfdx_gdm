trigger Contrato_cTrigger on Contrato__c (before update, before insert) {

    if(Trigger.isUpdate && Trigger.isBefore) {

        Contrato_cTriggerHelper.escribirLogCambios(Trigger.new, Trigger.oldMap);
    }
}
/**
* @name BusinessTrigger
* @author Jhonny Peroza
* updated 07-09-2021
*/
trigger BusinessTrigger on Negocio_por_Conta__c (before update, after insert, after update, before insert) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) { 
            // Llamado a clase Helper
            BusinessHelper.updateBusiness(Trigger.New);                      
        }
    }
}
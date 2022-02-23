/**
* @name RequisitionProductTrigger
* @author Jhonny Peroza
* updated 07-09-2021
*/
trigger RequisitionProductTrigger on Produto_de_Requisicao__c (before update, after insert, after update, before insert) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            RequisitionProductHelper.verifyRequisitionProduct(Trigger.New);
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert) { 
            RequisitionProductHelper.updateRequisitionProduct(Trigger.New);                      
        }
    }
}
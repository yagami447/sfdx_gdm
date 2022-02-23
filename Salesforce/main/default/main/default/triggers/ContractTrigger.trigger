/**
* @name ContractTrigger
* @author Jhonny Peroza
* updated 10-09-2021
*/
trigger ContractTrigger on Contract (before update, after insert, after update, before insert) {

    public static Id milhoRecordType = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Macro_Milho').getRecordTypeId();
    List<Contract> contractList = new List<Contract>();

    if(Trigger.isAfter) {
        if(Trigger.isInsert) { 
            for (Contract contrato : Trigger.new){
                if(contrato.RecordTypeId == milhoRecordType) {
                    contractList.add(contrato);          
                }
            }
            if(contractList.size() > 0) {
                ContractHelper.afterInsert(contractList);
            }
        }    
        if(Trigger.isUpdate) { 
            Contract contrato;
            for(Contract contract : Trigger.New){
                contrato = contract;
            }
            if (contrato != null) {
                ContractHelper.generateContractPDF(contrato);
            }
        }
    }
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) { 
            ContractHelper.beforeUpdate(Trigger.New, Trigger.oldMap);
        }
    }
}
trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert) {
            List<Account> cuentasConSupervisor = new List<Account>();
            for(Account cuenta : Trigger.new){
                if(String.isNotBlank(cuenta.Responsavel__c)){
                    cuentasConSupervisor.add(cuenta);
                }
            }

            if(!cuentasConSupervisor.isEmpty()){
                AccountTriggerHelper.cargarSupervisorYGerenteComercial(cuentasConSupervisor);
            }
        }else if(Trigger.isUpdate){
            List<Account> cuentasConSupervisor = new List<Account>();
            for(Account cuenta : Trigger.new){
                if(String.isNotBlank(cuenta.Responsavel__c)){
                    cuentasConSupervisor.add(cuenta);
                }
            }
            if(!cuentasConSupervisor.isEmpty()){
                AccountTriggerHelper.cargarSupervisorYGerenteComercial(cuentasConSupervisor);
            }
            if(!cuentasConSupervisor.isEmpty()){
                AccountTriggerHelper.cargarSupervisorYGerenteComercialAEventosRoyaltys(cuentasConSupervisor,Trigger.oldMap);
            }
        }
    }
}
trigger beforeDeleteOpp on Opportunity (before delete) {
    for(Opportunity  oppDel:Trigger.old){
        if(BraxUtils.validarDelOpps(oppDel))oppDel.addError('Privilegios insuficientes');
         
        
    }
}
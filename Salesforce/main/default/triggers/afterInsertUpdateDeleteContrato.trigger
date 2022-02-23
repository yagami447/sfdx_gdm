trigger afterInsertUpdateDeleteContrato on Contrato__c (after delete, after insert, after undelete, after update) {
      BRAXUtils.actualizarMetasPerfilCuenta(Trigger.New, Trigger.Old);
      BRAXUtils.actualizarEventosPerfilCuenta2(null, null, Trigger.new, Trigger.old);      
}
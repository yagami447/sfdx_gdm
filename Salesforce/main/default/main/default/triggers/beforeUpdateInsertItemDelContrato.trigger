trigger beforeUpdateInsertItemDelContrato on Item_del_Contrato__c (before insert, before update, after delete)  {

	ItemDelContratoTriggerHelper manejador = new ItemDelContratoTriggerHelper();

	if(Trigger.isBefore && Trigger.isInsert) {
		manejador.registrarNuevosItemsEnLog(Trigger.new);
	}

	if(Trigger.isBefore && Trigger.isUpdate) {
		manejador.actualizarItemsEnLog(Trigger.new, Trigger.oldMap);
	}

	if(Trigger.isAfter && Trigger.isDelete) {
		manejador.actualizarItemsEnLogCuandoSeEliminan(Trigger.oldMap);
	}
}
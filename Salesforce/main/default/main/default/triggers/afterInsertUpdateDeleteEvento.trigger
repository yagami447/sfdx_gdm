trigger afterInsertUpdateDeleteEvento on CRM_Calendario_de_Eventos__c (before insert, after insert, before update, after update, after delete, after undelete) {

	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			CRMEventoHandler.beforeInsertCRMEventos(Trigger.new);
		} else if (Trigger.isUpdate) {
			CRMEventoHandler.beforeUpdateCRMEventos(Trigger.new, Trigger.old);
		}
	}

	if (Trigger.isAfter) {
		//try {
		//BRAXUtils.actualizarEventosPerfilCuenta(Trigger.new, Trigger.old);
		BRAXUtils.actualizarEventosPerfilCuenta2(Trigger.new, Trigger.old, null, null);
		BRAXUtils.actualizarEvent(Trigger.new, Trigger.old, Trigger.isDelete);
		if(Trigger.isInsert && Trigger.isAfter && Network.getNetworkId() != null){
			//If is community, fix the owner.
			CRMEventoHandler.ChangeOwnerInAfter(trigger.new);
			CRMEventoHandler.ShareCRMEventFromCommunity(trigger.new, trigger.oldMap);
		}
	//} catch(Exception e) {}
	}
}
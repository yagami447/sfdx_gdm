({
    loadRecord : function(component, event, helper) {
		var eventParams = event.getParams();

        if (eventParams.changeType === "LOADED") {
            if ($A.util.isEmpty(component.get("v.simpleRecord.Safra__c"))) {
                helper.showMessage("Safra");
            } else if ($A.util.isEmpty(component.get("v.simpleRecord.Nome_do_agricultor_2__c"))) {
                helper.showMessage("Nome do agricultor");
            } else if ($A.util.isEmpty(component.get("v.simpleRecord.Latitud__c"))) {
                helper.showMessage("Latitude");
            } else if ($A.util.isEmpty(component.get("v.simpleRecord.Longitud__c"))) {
                helper.showMessage("Longitude");
            } else if ($A.util.isEmpty(component.get("v.simpleRecord.Divulgar_em_nome_de__c")) && component.get("v.simpleRecord.Autorizado__c")) {
                helper.showMessage("Divulgar em nome de");
            } else {
                helper.validateItems(component);
            }
        } else if (eventParams.changeType === "ERROR") {
            helper.toastMessage(component.get("v.recordError"), "error");
            $A.get("e.force:closeQuickAction").fire();
        }
	}
})
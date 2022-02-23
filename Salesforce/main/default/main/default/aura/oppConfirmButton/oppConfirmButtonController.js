({
	loadRecord : function(component, event, helper) {
		var eventParams = event.getParams();

        if (eventParams.changeType === "LOADED") {
            var stage = component.get("v.simpleRecord.StageName");

            if (stage === "Revisão do administrador de vendas") {
                component.set("v.isReady", true);
            } else {
                helper.toastMessage("Não pode criar Confirmações em fase " + stage, "info");
                $A.get("e.force:closeQuickAction").fire();
            }
        } else if (eventParams.changeType === "ERROR") {
            helper.toastMessage(component.get("v.recordError"), "error");
            $A.get("e.force:closeQuickAction").fire();
        }
	},
    
    accept : function(component, event, helper) {
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        $A.util.addClass(component.find("message"), "slds-hide");

        component.set("v.controlButtons", true);

        if (component.get("v.simpleRecord.PE_bajar_SAP__c")) {
            helper.toastMessage("Não pode criar Confirmações. A Oferta tem mudanças pendentes de baixar a SAP.", "info");
            $A.get("e.force:closeQuickAction").fire();
        } else {
            helper.sendConfirmationRequest(component);
        }
    },
    
    cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})
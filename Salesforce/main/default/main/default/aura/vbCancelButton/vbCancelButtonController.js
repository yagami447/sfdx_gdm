({
    loadRecord : function(component, event, helper) {
        var eventParams = event.getParams();

        if (eventParams.changeType === "LOADED") {
            component.set("v.isReady", true);
        } else if (eventParams.changeType === "ERROR") {
            helper.toastMessage(component.get("v.recordError"), "error");
            $A.get("e.force:closeQuickAction").fire();
        }
	},

    accept : function(component, event, helper) {
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        $A.util.addClass(component.find("message"), "slds-hide");

        component.set("v.controlButtons", true);

        var stage = component.get("v.simpleRecord.StageName");
        var newStage = "";

        if (stage == "PE - Pendiente") {
            newStage = "RR";
        } else if (stage == "AU - Autorizada") {
            newStage = "RE";
        }

        helper.sendCancelationRequest(component, newStage);
    },
    
    cancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    }
})
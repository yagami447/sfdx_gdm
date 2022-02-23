({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.cloneContract");
        action.setParams({"recordId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            component.set("v.RecordIdCloned", clonedRecord);

            var state = response.getState();
            if(state === "SUCCESS") {
                var clonedRecord = response.getReturnValue();
                component.set("v.RecordIdCloned", clonedRecord);
                var sObjectEvent = $A.get("e.force:navigateToSObject");
                sObjectEvent.setParams({
                    "recordId": clonedRecord,
                    "slideDevName": "detail"
                });

                sObjectEvent.fire();

            }else if (state === "ERROR") {
                console.log(response.getError()[0].message);
                var toastEvent = $A.get("e.force:showToast");
               
                toastEvent.setParams({
                    title: 'Error',
                    type: 'error',
                    message: response.getError()[0].message
                });
                toastEvent.fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        $A.enqueueAction(action);
    }

})
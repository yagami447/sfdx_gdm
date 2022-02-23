({
    doInit: function (component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        var recordId = component.get("v.recordId");
        console.log('Record Id is : ' + recordId);
        var action = component.get("c.liberar_bloquear");
        action.setParams({ recordId: recordId });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue) {
                    alert('Record unlocked, please remember to lock after edition');
                } else if (!returnValue) {
                    alert('Record locked');
                }
                
            } else {
                var errors = response.getError();
                var error = errors[0].message;
                alert('Error : ' + error);
            }
        });
        $A.enqueueAction(action);
        
    }
})
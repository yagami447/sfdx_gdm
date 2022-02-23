({
    sendUpdateRequest : function (component) {
        var action = component.get('c.sendUpdateRequest');
		
        action.setParams({accId : component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
			
            if (state === "SUCCESS") {
				var retorno = response.getReturnValue();
                
                if (retorno[1] === "true") {
                    this.toastMessage(retorno[0], "success");
                } else {
                    this.toastMessage(retorno[0], "error");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.toastMessage(errors[0].message, "error");
                    }
                } else {
                    console.log("Unknown error");
                }
            }
			
			$A.get("e.force:closeQuickAction").fire();
        });
        
        $A.enqueueAction(action);
	},

	toastMessage : function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"message": message, "type": type});
        toastEvent.fire();
    }
})
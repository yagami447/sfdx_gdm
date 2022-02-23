({    oppCheck: function(component, event, helper) {       
		// in the server-side controller               
		//debugger;               Use debugger to set the debugging point and check values of //attributes while developing the code.
		var oppId = component.get("v.OpportunityId");      
		var multiplier = component.get("v.Multiplier");       
		var action = component.get("c.getAssociatedContactdetails");
    	action.setParams({"oppId" : oppId,  "multiplier" : multiplier});         
     
		action.setCallback(this, function(response)
		{            
            var state = response.getState();            //alert(“State:”+state);           
			if (state === "SUCCESS") {               
                // Alert the user with the value returned                
                // from the server               
                //alert(“From server: ” + response.getReturnValue());
                var oppInfo = response.getReturnValue();               
                // You would typically fire a event here to trigger                
                // client-side notification that the server-side                
                // action is complete               
                //alert(“From Server check result”+accountInfo );               
                if(!oppInfo || oppInfo [0] == null) {                   
                    alert("Contact Check cannot be done. Contact info system does not return any result for the same");
                } 
                else {                   
                    location.reload();               
                }               
                $A.get("e.force:closeQuickAction").fire();               
                var toastEvent = $A.get("e.force:showToast");               
                toastEvent.setParams({"title": "Success!!","message": "Contact check has been completed!!" }); 
                toastEvent.fire();               
                $A.get("e.force:refreshView").fire();
            }           
			else if (state === "INCOMPLETE") {
                // do something
            }           
			else if (state === "ERROR") { 
            	var errors = response.getError();               
                if (errors) {                   
					if (errors[0] && errors[0].message) {                        
                        console.log("Error message: " + errors[0].message);
                    }               
				}
				else {                    
                    console.log("Unknown error");
                }           
        	}       
		});
        // optionally set storable, abortable, background flag here
        // A client-side action could cause multiple events,        
// which could trigger other events and        
// other server-side action calls.       
// $A.enqueueAction adds the server-side action to the queue.        
		$A.enqueueAction(action);
}})
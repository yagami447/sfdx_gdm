({
	getVal : function(cmp, csv) {        
        var action = cmp.get('c.getArteResProdutividade');                
        action.setCallback(this, function(response) {
            var state = response.getState();	    
        if(state == "SUCCESS") {
			cmp.set("v.ArteResProdutividade", response.getReturnValue());            
	    }
        });
        $A.enqueueAction(action);
    },
    
    gotoURL : function (component, link) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": link
        });
        alert(link);
        urlEvent.fire();
    },
})
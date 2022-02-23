({
	doInit : function(component, event, helper) { 
        var artResProd = component.get("v.ArteResProdutividade");        
        if(artResProd == '') {                    
            helper.getVal(component, artResProd);
        }          
    }, 
    
    gotoURL : function(component, event, helper) {
        var ctarget = event.currentTarget;
    	var link = ctarget.dataset.value;
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": 'www.google.com'
        });
        urlEvent.fire();
        
    },
})
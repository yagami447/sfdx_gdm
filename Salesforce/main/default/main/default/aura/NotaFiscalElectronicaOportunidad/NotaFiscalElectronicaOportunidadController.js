({
     toggle : function(component, event, helper) {
         helper.getNFe(component, event, helper);
   
        
    },
    gotoURL : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/" + component.get("v.oportunidadID")
        });
        urlEvent.fire();
    },
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    createOpportunity: function(component, event, helper) {
        component.set("v.loading", true); 
        helper.save(component, event, helper);
    },
    handleChange: function(component, event, helper) {
        helper.handleChange(component, event, helper);
    }
})
({
    accept : function(component, event, helper) {
        $A.util.removeClass(component.find("spinner"), "slds-hide");
        $A.util.addClass(component.find("message"), "slds-hide");
        component.set("v.controlButtons", true);
        helper.sendUpdateRequest(component);
    },
    
    cancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})
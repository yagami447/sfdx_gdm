({
    handleClick: function(component, event, helper) {
        var isOpen = component.get("v.isOpen");
        component.set("v.isOpen", !isOpen);
    }
})
({
	 handleClick: function(component, event, helper) {
        var isOpen = component.get("v.isOpen");
        component.set("v.isOpen", !isOpen);
    },
	handleChange : function(component, event, helper) {
		var cmpEvent = component.getEvent("changeAccount");
        cmpEvent.setParams({
            "field":"quantityProduct",
            "value":component.find('quantityProduct').get('v.value'),
            "position":component.get('v.det.prod.cProd')
        });
        cmpEvent.fire();
	}

})
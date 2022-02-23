({
	consultaSapControllerHelper : function(component) {
        component.set('v.isLoading', true);
		        
		let purchaseOrder = component.find('inputPurchaseOrder');
		var action = component.get("c.consultaSapController");
        action.setParams({
            "purchaseOrder": purchaseOrder.get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data == null ) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Não existe!",
                        "message": "O número do pedido não foi encontrado", 
                        "type": "warning"
                    });
                    toastEvent.fire();
                } else if (data == 'Já existe um pedido em edição. Ative o antigo para criar um novo.')  {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Já existe um pedido em edição.",
                        "message": data, 
                        "type": "warning"
                    });
                    toastEvent.fire();
                } else {                   
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/"+data
                    });
                    urlEvent.fire();
                }
            } else {
                
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Ocorreu um erro no processo, tente novamente mais tarde ou entre em contato com o administrador.", 
                        "type": "error"
                    });
                    toastEvent.fire();
            }
            component.set("v.isLoanding", false);
        });
        $A.enqueueAction(action);
	}
})
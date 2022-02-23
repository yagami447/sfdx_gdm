({
    showMyToast : function(component, event, helper, title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'pester',
            title: title,
            message: message,
            type:type
        });
        toastEvent.fire();
	},
    getNFe : function(component, event, helper) {
        var clave = component.get("v.claveFiscal");
        
        if (clave.length == 44) {
            component.set("v.loading", true); 
            var action = component.get("c.searchNFe");            
            action.setParams({
                "NFe" : clave
            });
            action.setCallback(this, function(response) {
            var state = response.getState();
                if(state == "SUCCESS") {
                    var str = response.getReturnValue();
                    var res = "";
                    if(str.indexOf('Existe:') > -1) {
                        res = str.split("Existe:");
                    }
                    else  {
                        var toggleText = component.find("obj");
                        $A.util.removeClass(toggleText, "slds-hide");
                        component.set("v.data",JSON.parse(response.getReturnValue()));

                        component.set('v.loading', false);
                    }
                    
                    if(res != "") {
                        component.set('v.loading', false);
                        component.set("v.oportunidadID", res[1]);
                        component.set("v.isOpen", true);
                    }
                    
                } else {
                    helper.showMyToast(component, event, helper, "Error", response.getError()[0].message, "ERROR");
                    component.set('v.loading', false);
                    var toggleText = component.find("obj");
                    $A.util.addClass(toggleText, "slds-hide");
                }
            });
            $A.enqueueAction(action);
        } else {
            helper.showMyToast(component, event, helper, "Error", 'O NFe deve ter 44 dígitos.', "ERROR");
        }
        
    },
    save : function(component, event, helper) {
        
        var prods = component.get('v.data.nfeProc.NFe.infNFe.det');
        
        for (var i = 0; prods.length > i; i++) {
            
            if (prods[i].prod.quantityReal == null) {
                helper.showMyToast(component, event, helper, "Error", 'A quantidade dos produtos deve ser concluída.', "ERROR");
                component.set('v.loading', false);
                return;
            }
        }
        
        
       var action = component.get("c.saveOpportunity");
        action.setParams({
            "NFe" : JSON.stringify(component.get("v.data"))
        });
        console.log(JSON.stringify(component.get("v.data")));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS") {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": response.getReturnValue()
                });
                navEvt.fire();
                
            }
            else {
                helper.showMyToast(component, event, helper, "Error", 'Ha ocurrido un error: '+response.getError()[0].message, "ERROR");
                component.set('v.loading', false);
            }
        });
        $A.enqueueAction(action);
        
    }, 
    handleChange: function(component, event, helper) {
        if(event.getParam("field") == 'emit') {
            component.set('v.data.nfeProc.NFe.infNFe.emit.accountId', event.getParam("value"));
        }
        if(event.getParam("field") == 'dest') {
            component.set('v.data.nfeProc.NFe.infNFe.dest.accountId', event.getParam("value"));
        }
        if(event.getParam("field") == 'quantityProduct') {
            var dets = component.get('v.data.nfeProc.NFe.infNFe.det');
            var code = event.getParam("position");
            for (var i = 0; i < dets.length; i++) {
                if(code == null) adsdasdas();
                if(code == dets[i].prod.cProd) {
                    
                    dets[i].prod.quantityReal = event.getParam("value");
                    
                    component.set('v.data.nfeProc.NFe.infNFe.det', dets);
                    break;
                }
            }

            
        }
        
    },
})
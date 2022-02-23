({
    sendToApprove : function(cmp) {
        let action = cmp.get("c.sendToApproveOpportunity");
        action.setParams({ oppId : cmp.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                let result = response.getReturnValue();
                cmp.set("v.titleMessage", 'Operación exitosa');
                cmp.set("v.severityMessge", 'confirm' );
                cmp.set("v.message", 'La oportunidad se ha enviado para su aprobacion');
                $A.get('e.force:refreshView').fire();
                
            } else if (state === "ERROR") {
                let errors = response.getError();
                
                cmp.set("v.titleMessage", "ERROR")
                cmp.set("v.severityMessge", "error");
                cmp.set("v.message", "Incapaz de se enviar para aprovação : " + errors[0].message);
            }
        });
        $A.enqueueAction(action);
    }
})
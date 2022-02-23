({
	doInit: function (component, event, helper) {



        let orderId = component.get("v.recordId");
        var getDefaultValueForNewOpportunity = component.get('c.getDefaultValues');

        getDefaultValueForNewOpportunity.setParams({
            recordId : orderId
        });
        getDefaultValueForNewOpportunity.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {

                let result = response.getReturnValue();

                var createOpportunityEvent = $A.get("e.force:createRecord");
                createOpportunityEvent.setParams({
                    "entityApiName": "Opportunity",
                    "defaultFieldValues": {                
                        'Pedido_de_transporte__c' : component.get("v.recordId"),
                        'AccountId' : result.order.AccountId,
                        'RecordTypeId' : result.recordTypeId
                    }
                });
                createOpportunityEvent.fire();


            } else if (state === "ERROR") {                

                helper.showToast('Erro','error', 'Erro fatal, entre em contato com seu administrador');

                let errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " , errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        $A.enqueueAction(getDefaultValueForNewOpportunity);

    
        
	}
})
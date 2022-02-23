({
    getAuditPlans : function(component) {
        var action = component.get("c.getAuditPlans");

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                component.set("v.auditPlans", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.toastMessage(errors[0].message, "error");
                    }
                } else {
                    console.log("Unknown error");
                }
            }

            $A.get("e.force:closeQuickAction").fire();
        });

        $A.enqueueAction(action);
    },

    dispatchCalendarEvent : function(component, record) {
        var cmpEvent = component.getEvent("calEvent");

        cmpEvent.setParams({
            recordByEvent: {
                id: record.id,
                title: component.get("v.auditPlans")[record.fields["Plano_de_Auditoria__c"]["value"]].Nombre__c,
                start: record.fields["Start_Time__c"]["value"],
                end: record.fields["End_Time__c"]["value"],
                auditor: record.fields["Auditor__c"]["value"],
                name: record.fields["Name"]["value"]
            }
        });

        cmpEvent.fire();
    },

    toastMessage: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ "message": message, "type": type });
        toastEvent.fire();
    }
})
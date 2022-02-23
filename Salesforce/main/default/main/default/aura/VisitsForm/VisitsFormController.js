({
    doInit : function(component, event, helper) {
        helper.getAuditPlans(component);
    },

    setCalendarEvent : function(component, event, helper) {
        var params = event.getParam("arguments");
        component.set("v.recordId", params.recordByEvent.id);
        component.set("v.start", params.recordByEvent.start);
        component.set("v.end", params.recordByEvent.end);
        component.set("v.auditor", params.recordByEvent.auditor);
        component.set("v.isInsert", params.origin === "insert");
    },

    goToEvent : function(component, event, helper) {
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({ "recordId": component.get("v.recordId"), "slideDevName": "related" });
        navEvent.fire();
    },

    handleSubmit : function(component, event, helper) {
        component.set("v.isLoading", true);
    },

    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        helper.dispatchCalendarEvent(component, record);
        helper.toastMessage(record.fields["Name"]["value"] + " atualizado!", "success");
        component.set("v.isLoading", false);
    },

    handleError : function(component, event, helper) {
        var error = event.getParams();
        helper.toastMessage(error.message + " " + error.detail, "error");
        component.set("v.isLoading", false);
    },

    onChangeAuditPlan : function(component, event, helper) {
        var auditPlanId = event.getParam("value");

        if (!$A.util.isEmpty(auditPlanId)) {
            var auditPlanSelected = component.get("v.auditPlans")[auditPlanId];
            component.set("v.safras", auditPlanSelected.Safra__c);
        } else {
            component.set("v.safras", []);
        }
    }
})
({
    afterScriptsLoaded : function(component, event, helper) {
        helper.fetchEvents(component);
    },

    updateEvent : function(component, event, helper) {
        helper.updateEvent(component, event.getParam("arguments").recordByEvent);
    },

    onChangeAuditor : function(component, event, helper) {
        helper.filterByAuditor(component, event.getParam("value"));
    },

    addFilters : function(component, event, helper) {
        component.set("v.isLoading", true);
        helper.refetchEvents(component, event.getParam("arguments").filters);
    }
});
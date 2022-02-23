({
    doInit : function(component, event, helper) {
		helper.getAuditors(component);
	},

    handleCalendarEvent : function(component, event, helper) {
        var calEvent = event.getParams();

        if (calEvent.origin) {
            var visitsForm = component.find("form");
            visitsForm.setCalendarEvent(
                calEvent.recordByEvent,
                calEvent.origin
            );
        } else {
            var calendar = component.find("calendar");
            calendar.updateEvent(calEvent.recordByEvent);
        }
    },

    handleCalendarFiltersEvent : function(component, event, helper) {
        var filterEvent = event.getParams();
        var calendar = component.find("calendar");
        calendar.addFilters(filterEvent.filters);
    },

    togglePanelForm : function(component, event, helper) {
        var panel = component.find("panelForm");
        var button = event.getSource();

        $A.util.toggleClass(panel, "slds-is-open");

        if (button.get("v.variant") === "brand") {
            button.set("v.variant", "border");
        } else {
            button.set("v.variant", "brand");
        }
    },

    togglePanelFilters : function(component, event, helper) {
        var panel = component.find("panelFilters");
        var button = event.getSource();

        $A.util.toggleClass(panel, "slds-is-open");

        if (button.get("v.variant") === "border") {
            button.set("v.variant", "brand");
        } else {
            button.set("v.variant", "border");
        }
    },

    closePanel : function(component, event, helper) {
        var buttonName = event.getSource().get("v.name");
        var panel = buttonName === "closeFormButton" ? component.find("panelForm") : component.find("panelFilters");
        var button = buttonName === "closeFormButton" ? component.find("formButton") : component.find("filtersButton");

        $A.util.toggleClass(panel, "slds-is-open");
        button.set("v.variant", "border");
    }
})
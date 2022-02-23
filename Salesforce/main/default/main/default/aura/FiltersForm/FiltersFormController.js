({
    doInit : function(component, event, helper) {
        helper.getFilters(component);
    },

    handleClick : function(component, event, helper) {
        const button = event.getSource();
        const target = button.get("v.value");
        const dualList = component.find(target);
        $A.util.toggleClass(dualList, "slds-hide");
    },

    addFilters : function(component, event, helper) {
        const cidade = component.get("v.cidadeSelected");
        const uf = component.get("v.ufSelected");
        const etapa = component.get("v.etapaSelected");
        const responsavel = component.get("v.responsavelSelected");
        const filters = {};

        if (!$A.util.isEmpty(cidade)) { filters["Cidade__c"] = cidade }
        if (!$A.util.isEmpty(uf)) { filters["UF__c"] = uf }
        if (!$A.util.isEmpty(etapa)) { filters["Etapa__c"] = etapa }
        if (!$A.util.isEmpty(responsavel)) { filters["Responsavel__c"] = responsavel }

        var cmpEvent = component.getEvent("filtersEvent");
        cmpEvent.setParams({ filters: filters });
        cmpEvent.fire();
    },

    removeFilters : function(component, event, helper) {
        component.set("v.cidadeSelected", []);
        component.set("v.ufSelected", []);
        component.set("v.etapaSelected", []);
        component.set("v.responsavelSelected", []);
    }
})
({
    createRecord: function(component, event, helper) {
		
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
           "entityApiName": "CRM_Calendario_de_Eventos__c",
           "recordTypeId": event.getParam('id'),
           "defaultFieldValues": {
              "Name": event.getParam('name'),
              "Evento__c": event.getParam('name'),
              "Marca__c" : event.getParam('marca'), 
              "Cuenta__c": event.getParam('accountId'),
              "Safra__c": event.getParam('config'),
              "Fase__c": 'Edição'
            }
        });
        createRecordEvent.fire();
     }
})
({
    createRecord: function(component, event, helper) {
		
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
           "entityApiName": "Opportunity",
           "recordTypeId": event.getParam('id'),
           "defaultFieldValues": {
              "Name": event.getParam('name'),
              "CloseDate": event.getParam('closedate'),
              "Marca__c": event.getParam('marca'),
              "StageName": event.getParam('stage'), 
              "AccountId": event.getParam('accountId'), 
              "Safra__c": event.getParam('config'),
            }
        });
        createRecordEvent.fire();
     }
})
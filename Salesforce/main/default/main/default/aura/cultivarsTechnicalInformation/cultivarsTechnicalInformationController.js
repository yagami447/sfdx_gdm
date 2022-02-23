({
    handleEditRecord : function(component, event) {
        const recordId = event.getParam('row').Id;
        const editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({ "recordId": recordId });
        editRecordEvent.fire();
    }
})
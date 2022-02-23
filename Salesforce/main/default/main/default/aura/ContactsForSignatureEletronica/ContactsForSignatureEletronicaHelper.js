({
    getData : function(cmp) {
        var action = cmp.get('c.getContacts');
        var recordId=cmp.get('v.recordId');
        action.setParams({recordId:recordId});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                cmp.set('v.myData', data);
                var selected = [];
                for (var i = 0; i < data.length ; i++) {
                    if (data[i].check) {
                        selected.push(data[i].contactId);
                    }
                }
                cmp.find('contactDatatable').set('v.selectedRows',selected);
                console.log(data);
                console.log(selected);
                
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    onSave:function(cmp,event) {
        var selectedRows = cmp.find('contactDatatable').getSelectedRows();
        var action = cmp.get('c.updateContacts');
        
        action.setParams({ 
            selectedRows : JSON.stringify(selectedRows),
            recordId : cmp.get('v.recordId') 
        });
        

        action.setCallback(this,function(response) {
            var state=response.getState();
            console.log(response);
            if(state='SUCCESS') {
                var toastEvent=$A.get("e.force:showToast");
                toastEvent.setParams({title:'Sucesso',
                                      message:'Os signatarios foram salvos',
                                      type:'success',
                                     });
                toastEvent.fire();
            } else  {
                console.log(state);
            }
            
        });
        $A.enqueueAction(action);
    }
})
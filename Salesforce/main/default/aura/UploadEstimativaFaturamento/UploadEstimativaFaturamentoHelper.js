({
    createCSVObject : function(cmp, csv) {
        var action = cmp.get('c.getCSVObject');
        action.setParams({
            csv_str : csv
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
	    if(state == "SUCCESS") {
		cmp.set("v.csvObject", response.getReturnValue());
	    }
        });
        $A.enqueueAction(action);
    },
    
    createEstimativa : function(cmp, csvObj, safra, mes) {
        var action = cmp.get('c.crearEstimativas');        
        action.setParams({            
            'jsonString': JSON.stringify(csvObj), 
            'safra': JSON.stringify(safra), 
            'mes': JSON.stringify(mes)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
        if(state == "SUCCESS") {
		alert(response.getReturnValue());
	    }    
	    });        
        $A.enqueueAction(action);        
    },        
        
})
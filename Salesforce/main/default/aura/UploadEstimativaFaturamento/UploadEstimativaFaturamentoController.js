({
    handleUploadFinished : function(component, event, helper) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if(file) {
            console.log("UPLOADED")
            var reader = new FileReader();
            reader.readAsText(file, 'UTF-8');
            reader.onload = function(evt) {
                var csv = evt.target.result;
                component.set("v.csvString", csv);
            }
        }
    },
    
    doInit : function(component, event, helper) { 
        var s = component.get("v.safra");
        component.set("v.safra", "20/21");
        var m = component.get("v.mes");
        component.set("v.mes", "Janeiro");        
    }, 
        
    handleGetCSV : function(component, event, helper) {
        var csv = component.get("v.csvString");
        if(csv != null) {
            helper.createCSVObject(component, csv);
        }        
    },

    cleanData : function(component, event, helper) {
        component.set("v.csvString", null);
        component.set("v.csvObject", null);
    },

    importData : function(component, event, helper) {               
        var s = component.get("v.safra");
		var m = component.get("v.mes");        
        if(s == null || s == '' || s == 'Undefined'){
            alert ('Deve selecionar safra.');
            return null;
        }
        if(m == null || m == '' || m == 'Undefined'){
            alert ('Deve selecionar mes.');
            return null;
        }        
                
        var csvObj = component.get("v.csvObject");
        if(csvObj != null) {
            helper.createEstimativa(component, csvObj, s, m);
        }else{
            alert('No hay registros para importar.');
        }
        
    },
    
    waiting: function(component, event, helper) {
    	var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();                
 	},	
 
    doneWaiting: function(component, event, helper) {
    	var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire(); 
 	},
    
})
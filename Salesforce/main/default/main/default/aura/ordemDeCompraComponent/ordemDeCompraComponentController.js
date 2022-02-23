({
	doInit : function(component, event, helper) {
        
    },

    gotoURL : function(component, event, helper){
        window.history.back();
    },

    consultaSapControllerJs : function(component, event, helper){
        helper.consultaSapControllerHelper(component);
    },
})
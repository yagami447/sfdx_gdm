({
   init: function (cmp, event, helper) {
        cmp.set('v.myColumns', [
            { label: 'Contact Name', fieldName: 'name', type: 'text'},
            { label: 'CPF', fieldName: 'CPF', type: 'text'},
            { label: 'Email', fieldName: 'Email', type: 'email'},
            { label: 'Tipo de Assinatura', fieldName: 'tipoAsignatura', type: 'text'},
            { label: 'Origem Docto', fieldName: 'origemDoc', type: 'text'},
            { label: 'Vencimiento docto', fieldName: 'vencimientoDoc', type: 'date'}
        ]);
        helper.getData(cmp);
    },
    saveTable:function (cmp,event,helper){
        helper.onSave(cmp,event);
    }
    
})
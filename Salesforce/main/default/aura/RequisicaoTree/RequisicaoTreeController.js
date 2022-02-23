({
	doInit: function(component, event, helper) {
		helper.getData(component, helper);
		// var totalLabel = $A.get('$Label.c.Estimativa_Supervisor');
		// component.set('v.totalLabel', totalLabel);
		// component.set('v.gridColumns', columns);

		// var columns = [
		// 	{
		// 		label: 'Variedade',
		// 		initialWidth: 140
		// 	},
		// 	{
		// 		label: component.get('v.totalLabel'),
		// 		initialWidth: 75
		// 	},
		// 	{
		// 		label: 'Nova Estimativa',
		// 		initialWidth: 75
		// 	},
		// 	{
		// 		label: 'Nombre de Registro',
		// 		initialWidth: 70
		// 	},
		// 	{
		// 		label: 'Solicitante',
		// 		initialWidth: 140
		// 	}
		// ];

		// // var totalLabel = $A.get('$Label.c.Estimativa_Supervisor');
		// // component.set('v.totalLabel', totalLabel);
		// component.set('v.gridColumns', columns);
	},
	toggle: function(component, event, helper) {
		var items = component.get('v.PaginationList'),
			index = event.getSource().get('v.value');
		items[index].expanded = !items[index].expanded;
		component.set('v.PaginationList', items);
	},
	next: function(component, event, helper) {
		helper.next(component, event);
	},
	previous: function(component, event, helper) {
		helper.previous(component, event);
	},
	guardar: function(component, event, helper) {
		helper.guardar(component, helper);
	}
});
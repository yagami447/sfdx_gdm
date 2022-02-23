({
	getData: function(component) {
		var action = component.get('c.getProdutos');
		console.log('Id: ' + component.get('v.recordId'));

		action.setParams({
			requisitionId: component.get('v.recordId')
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var pageSize = component.get('v.pageSize');

				component.set('v.gridData', response.getReturnValue());
				component.set('v.totalRecords', component.get('v.gridData').length);
				component.set('v.startPage', 0);
				component.set('v.endPage', pageSize - 1);
				var PaginationList = [];

				let labelGerente = $A.get('$Label.c.Estimativa_Multiplicador');
				let totalLabel = $A.get('$Label.c.Estimativa_Supervisor');

				if (response.getReturnValue()[0].type === 'Gerente Comercial') {
					console.log('entro al if del label jaja saludos ');
					component.set('v.totalLabel', totalLabel);
				} else {
					component.set('v.totalLabel', labelGerente);
				}

				var columns = [
					{
						label: 'Variedade',
						initialWidth: 80
					},
					{
						label: 'Embalagem',
						initialWidth: 80
					},
					{
						label: 'Tratamento',
						initialWidth: 80
					},
					{
						label: component.get('v.totalLabel'),
						initialWidth: 70
					},
					{
						label: 'Nova Estimativa',
						initialWidth: 75
					},
					{
						label: 'Nombre de Registro',
						initialWidth: 70
					},
                    {
						label: 'Conta',
						initialWidth: 90
					},
					{
						label: 'Solicitante',
						initialWidth: 70
					}
				];
				component.set('v.gridColumns', columns);

				for (var i = 0; i < pageSize; i++) {
					if (component.get('v.gridData').length > i) {
                         
						PaginationList.push(response.getReturnValue()[i]);
					}
					component.set('v.PaginationList', PaginationList);
					component.set('v.isLoanding', false);
					component.set('v.totalPagesCount', Math.ceil(component.get('v.gridData').length / pageSize));
				}
			} else {
				alert('ERROR');
			}
		});
		$A.enqueueAction(action);
	},

	guardar: function(component, helper) {
		var action = component.get('c.save');
		console.log(component.get('v.gridData'));
		action.setParams({
			reqId: component.get('v.recordId'),
			productsWrapperJSON: JSON.stringify(component.get('v.gridData'))
		});
		component.set('v.isLoanding', true);

		action.setCallback(this, function(response) {
			var state = response.getState();
			var toastEvent = $A.get('e.force:showToast');
			if (state === 'SUCCESS') {
				toastEvent.setParams({
					title: 'Êxito!',
					message: 'Os registros foram atualizados.',
					type: 'success'
				});
				helper.getData(component);
			} else {
				toastEvent.setParams({
					title: 'Error!',
					message: 'Falha na operação, entre em contato com o administrador.',
					type: 'error'
				});
				component.set('v.isLoanding', false);
			}
			toastEvent.fire();
		});
		$A.enqueueAction(action);
	},

	next: function(component, event) {
		var sObjectList = component.get('v.gridData');
		var end = component.get('v.endPage');
		var start = component.get('v.startPage');
		var pageSize = component.get('v.pageSize');
		var Paginationlist = [];
		var currentPage = component.get('v.currentPage');
		var counter = 0;
		for (var i = end + 1; i < end + pageSize + 1; i++) {
			if (sObjectList.length > i) {
				Paginationlist.push(sObjectList[i]);
			}
			counter++;
		}
		start = start + counter;
		end = end + counter;
		currentPage++;

		component.set('v.startPage', start);
		component.set('v.endPage', end);
		component.set('v.PaginationList', Paginationlist);
		component.set('v.currentPage', currentPage);
	},
	/*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
	previous: function(component, event) {
		var sObjectList = component.get('v.gridData');
		var end = component.get('v.endPage');
		var start = component.get('v.startPage');
		var pageSize = component.get('v.pageSize');
		var Paginationlist = [];
		var currentPage = component.get('v.currentPage');
		var counter = 0;
		for (var i = start - pageSize; i < start; i++) {
			if (i > -1) {
				Paginationlist.push(sObjectList[i]);
				counter++;
			} else {
				start++;
			}
		}
		currentPage--;
		start = start - counter;
		end = end - counter;

		component.set('v.currentPage', currentPage);
		component.set('v.startPage', start);
		component.set('v.endPage', end);
		component.set('v.PaginationList', Paginationlist);
	}
});
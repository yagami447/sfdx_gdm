({
	doInit: function(cmp, event, helper) {
		helper.getData(cmp);
		cmp.set('v.isLoanding', true);
		setTimeout(() => {
			if (cmp.get('v.TipoGerente') == true) {
				console.log('entro al if de tipo gerente controller');
				cmp.set('v.gridColumns', [
					{
						label: 'Nome',
						fieldName: 'URL__c',
						type: 'url',
						sortable: true,
						typeAttributes: { label: { fieldName: 'Name' } }
					},
					{
						label: 'Supervisor',
						fieldName: 'URL_Multiplica__c',
						type: 'url',
						sortable: true,
						typeAttributes: { label: { fieldName: 'Nombre_del_multiplicador__c' } }
					},
					{ label: 'Quantidade', fieldName: 'Quantidade__c', initialWidth: 110, type: 'number' },
					{ label: 'Estado', initialWidth: 120, fieldName: 'Estado__c', type: 'text' }
				]);
			} else {
				cmp.set('v.gridColumns', [
					{
						label: 'Nome',
						fieldName: 'URL__c',
						type: 'url',
						sortable: true,
						typeAttributes: { label: { fieldName: 'Name' } }
					},
					{
						label: 'Multiplicador',
						fieldName: 'URL_Multiplica__c',
						type: 'url',
						sortable: true,
						typeAttributes: { label: { fieldName: 'Nombre_del_multiplicador__c' } }
					},
					{ label: 'Quantidade', fieldName: 'Quantidade__c', initialWidth: 110, type: 'number' },
					{ label: 'Estado', initialWidth: 120, fieldName: 'Estado__c', type: 'text' }
				]);
			}
		}, 2000);
	},

	approveHandler: function(component, event, helper) {
		helper.setStatus(component, helper, 'Approve');
	},

	rejectHandler: function(component, event, helper) {
		helper.setStatus(component, helper, 'Reject');
		component.set('v.commentModal', false);
	},

	showModal: function(component, event, helper) {
		var rows = component.find('mytree').getSelectedRows();
		var onlyRequisitions = [];
		for (var i = 0; i < rows.length; i++) {
			if (rows[i].Estado__c != null) onlyRequisitions.push(rows[0]);
		}

		if (onlyRequisitions.length > 0 && onlyRequisitions.length < 25) {
			let valor = component.get('v.commentModal');
			if (valor) {
				component.set('v.commentModal', false);
			} else {
				component.set('v.commentModal', true);
			}
		} else {
			helper.showToast(component, 'Debe elegir al menos 1 elemento ');
		}
	},

	// showError : function(component,event,helper){
	//     let valor = component.get("v.error");
	//     if(valor){
	//         component.set("v.error", false);
	//     }else{
	//         component.set("v.error", true);
	//     }
	// },

	onRowSelect: function(cmp, event, helper) {
		if (event.getName() == 'toggle') {
			console.log('Entro a toggle');
			var treeGridCmp = cmp.find('mytree');
			let oldSelectedRows = cmp.get('v.oldSelectedRows');
			console.log('oldSelectedRows: ' + oldSelectedRows);
			let reLoadRows = [];
			for (let i in oldSelectedRows) {
				console.log(i);
				console.log(oldSelectedRows[i]);
				reLoadRows.push(oldSelectedRows[i]);
				console.log(reLoadRows);
				console.log('------------------------');
			}
			console.log(reLoadRows);
			treeGridCmp.set('v.selectedRows', reLoadRows);
			console.log('f: ' + cmp.find('mytree').get('v.selectedRows'));
			// console.log(treeGridCmp);
			// console.log('en medio del toggle');

			// console.log('getCurrentExpandedRows: '+treeGridCmp.getCurrentExpandedRows());
			// console.log(treeGridCmp.getCurrentExpandedRows());
			// console.log('sale del toggle');
		}
		// else{
		console.log('Entro al click');
		var treeGridCmp = cmp.find('mytree');
		let newSelectedRows;
		if (event.getName() == 'toggle') {
			newSelectedRows = cmp.get('v.oldSelectedRows');
		} else {
			newSelectedRows = treeGridCmp.getSelectedRows();
		}
		let oldSelectedRows = cmp.get('v.oldSelectedRows');
		let evento = '';
		let data = cmp.get('v.gridData');
		var selectedRowsIds = [];
		for (let i in newSelectedRows) {
			console.log('Id: ' + newSelectedRows[i].Id);
			console.log(newSelectedRows[i].Id);
			selectedRowsIds.push(newSelectedRows[i].Id);
		}

		console.log('selectedRowsIds: ' + selectedRowsIds);
		console.log(selectedRowsIds);

		console.log('oldSelectedRows: ' + oldSelectedRows);
		console.log(oldSelectedRows);
		console.log('newSelectedRows: ' + newSelectedRows);
		console.log(newSelectedRows);

		if (newSelectedRows.length > oldSelectedRows.length) {
			evento = 'Fila Seleccionada';
			for (let i in newSelectedRows) {
				let esNuevo = true;
				for (let j in oldSelectedRows) {
					if (newSelectedRows[i].Id == oldSelectedRows[j].Id) {
						esNuevo = false;
					}
				}
				if (esNuevo) {
					cmp.set('v.selectedRow', newSelectedRows[i].Id);
					console.log('selectedRow: ' + cmp.get('v.selectedRow'));
				}
			}
		} else if (newSelectedRows.length < oldSelectedRows.length) {
			evento = 'Fila Deseleccionada';
			for (let i in oldSelectedRows) {
				let sobra = true;
				for (let j in newSelectedRows) {
					if (newSelectedRows[j].Id == oldSelectedRows[i].Id) {
						sobra = false;
					}
				}
				if (sobra) {
					cmp.set('v.deselectedRow', oldSelectedRows[i].Id);
					console.log('deselectedRow: ' + cmp.get('v.deselectedRow'));
				}
			}
		}

		if (evento == 'Fila Seleccionada') {
			console.log('Fila Seleccionada');
			for (let rowD in data) {
				if (cmp.get('v.selectedRow') == data[rowD].Id) {
					let subProductos = data[rowD]._children;
					for (let sub in subProductos) {
						if (selectedRowsIds.indexOf(subProductos[sub].Id) == -1) {
							selectedRowsIds.push(subProductos[sub].Id);
						}
					}
				} else {
					let idEncontrado = false;
					let subProductos = data[rowD]._children;
					for (let sub in subProductos) {
						if (cmp.get('v.selectedRow') == subProductos[sub].Id) {
							idEncontrado = true;
						}
					}
					if (idEncontrado) {
						console.log('indexof: ' + selectedRowsIds.indexOf(data[rowD].Id));
						console.log(selectedRowsIds.indexOf(data[rowD].Id));
						if (selectedRowsIds.indexOf(data[rowD].Id) == -1) {
							selectedRowsIds.push(data[rowD].Id);
							for (let sub in subProductos) {
								if (selectedRowsIds.indexOf(subProductos[sub].Id) == -1) {
									selectedRowsIds.push(subProductos[sub].Id);
								}
							}
						}
					}
				}
			}
			console.log('selectedRowsIds: ' + selectedRowsIds);
			console.log(selectedRowsIds);
			treeGridCmp.set('v.selectedRows', selectedRowsIds);
			cmp.set('v.oldSelectedRows', selectedRowsIds);
		} else if (evento == 'Fila Deseleccionada') {
			console.log('Fila Deseleccionada');

			treeGridCmp.set('v.selectedRows', selectedRowsIds);
			cmp.set('v.oldSelectedRows', selectedRowsIds);
		}

		console.log('termina transacción');
	}
});
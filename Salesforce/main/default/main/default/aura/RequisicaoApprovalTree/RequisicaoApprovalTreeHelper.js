({
	getData: function(cmp) {
		var action = cmp.get('c.getTreeGridData');
		action.setParams({
			requisitionId: cmp.get('v.recordId'),
			status: cmp.get('v.estado')
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var data = response.getReturnValue();
				for (var i = 0; i < data.length; i++) {
					if (data[i]['Tipo__c'] === 'Supervisor') {
						console.log('entro al if para saber si es gerente');
						cmp.set('v.TipoGerente', true);
					}
					data[i]._children = data[i]['Produtos_de_Requisicao__r'];
					delete data[i].Produtos_de_Requisicao__r;
				}
				console.log(data);
				cmp.set('v.gridData', data);
			}
			cmp.set('v.isLoanding', false);
		});
		$A.enqueueAction(action);
	},

	setStatus: function(cmp, helper, estado) {
		var rows = cmp.find('mytree').getSelectedRows();
		var onlyRequisitions = [];
		for (var i = 0; i < rows.length; i++) {
			if (rows[i].Estado__c != null) onlyRequisitions.push(rows[0]);
		}

		if (onlyRequisitions.length > 0 && onlyRequisitions.length < 25) {
			var action = cmp.get('c.processRequisitions');
			if (cmp.get('v.commentModal')) {
				console.log('entro 1: ' + cmp.get('v.commentModal'));
				console.log('entro 1: ' + cmp.find('comment').get('v.value'));
				console.log(cmp.find('comment').get('v.value'));
				action.setParams({
					JSONRequisitions: JSON.stringify(onlyRequisitions),
					action: estado,
					comment: cmp.find('comment').get('v.value')
				});
			} else {
				action.setParams({
					JSONRequisitions: JSON.stringify(onlyRequisitions),
					action: estado,
					comment: ''
				});
			}

			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === 'SUCCESS') {
					var toastEvent = $A.get('e.force:showToast');
					var resultApex = response.getReturnValue();
					if (resultApex === 'SUCCESS') {
						toastEvent.setParams({
							title: 'Êxito!',
							message: 'Os registros foram atualizados.',
							type: 'success'
						});
						toastEvent.fire();
						helper.getData(cmp);
					} else {
						toastEvent.setParams({
							title: 'Error!',
							message: resultApex,
							type: 'error'
						});
						toastEvent.fire();
					}
					cmp.set('v.isLoanding', false);
				}
			});
			$A.enqueueAction(action);
		} else {
			this.showToast(cmp, 'Debe elegir al menos 1 elemento');
		}
	},

	showToast: function(component, message) {
		var toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			title: 'Error!',
			type: 'error',
			message: message
		});
		toastEvent.fire();
	}
});
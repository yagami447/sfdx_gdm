trigger EventoRoyaltyTrigger on Evento_Royalty__c (before insert, before update, after insert, after update)  { 

	if(Trigger.isBefore) {
		if(Trigger.isInsert) {
			
			Set<Id> saldoId = new Set<Id>();
			List<Evento_Royalty__c> eventosConAccount = new List<Evento_Royalty__c>();
			for(Evento_Royalty__c evento : Trigger.new) {
				if(evento.Estado__c == 'Pendiente de aprobación') {
					saldoId.add(evento.Saldo_por_safra__c);
				}
				if(String.isNotEmpty(evento.Cuenta__c)){
					eventosConAccount.add(evento);
				}
			}

			if(!eventosConAccount.isEmpty()){
				EventoRoyaltyTriggerHelper.sincronizarSupervisorYGerenteComercial(eventosConAccount);
			}

			//List<Evento_Royalty__c> eventos = [SELECT Id, Valor__c, Saldo_por_safra__c FROM Evento_Royalty__c WHERE Saldo_por_safra__c in :saldoId];
			List<Saldo_por_safra__c> saldos = 
								[SELECT Id, Saldo_Gastado__c, Account__r.Name, Safra__c, 
										(SELECT Id, Estado__c 
										 FROM Eventos_Royalty__r) 
								 FROM Saldo_por_safra__c 
								 WHERE Id in :saldoId];
			//eventos.addAll(Trigger.new);
			
			for(Saldo_por_safra__c saldo : saldos) {
				for(Evento_Royalty__c evento : saldo.Eventos_Royalty__r) {
					if(evento.Estado__c == 'Pendiente de aprobación') {
						Trigger.new[0].addError('Ya existe evento pendiente de aprobación para saldo de cuenta ' + saldo.Account__r.Name +
						 ' con safra ' + saldo.Safra__c);
					}
				}
			}

		}else if(Trigger.isUpdate){
			List<Evento_Royalty__c> eventosConAccount = new List<Evento_Royalty__c>();
			for(Evento_Royalty__c evento : Trigger.new) {
				if(String.isNotEmpty(evento.Cuenta__c)){
					eventosConAccount.add(evento);
				}
			}

			if(!eventosConAccount.isEmpty()){
				EventoRoyaltyTriggerHelper.sincronizarSupervisorYGerenteComercial(eventosConAccount);
			}
		}
	}

}
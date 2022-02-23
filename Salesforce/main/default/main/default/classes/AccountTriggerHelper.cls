public without sharing class AccountTriggerHelper{
	public static void cargarSupervisorYGerenteComercial(List<Account> cuentasConSupervisor){
		List<String> supervisoresDeListaResponsavel_BRMX = new List<String>();
		List<User> supervisores = new List<User>();
		for (Account cuenta : cuentasConSupervisor){
			supervisoresDeListaResponsavel_BRMX.add(cuenta.Responsavel__c);
		}

		supervisores = [SELECT ID, DelegatedApproverId, Nombre_De_Lista_Respons_vel_BRMX__c
		                FROM User
		                WHERE Nombre_De_Lista_Respons_vel_BRMX__c IN :supervisoresDeListaResponsavel_BRMX];

		for (Account cuenta : cuentasConSupervisor){
			for (User supervisor : supervisores){
				if (cuenta.Responsavel__c == supervisor.Nombre_De_Lista_Respons_vel_BRMX__c){
					cuenta.Supervisor__c = supervisor.Id;
					cuenta.Gerente_comercial__c = supervisor.DelegatedApproverId;
				}
			}
		}
	}

	private static List<Account> filterAccountsToUpdateResponsables(List<Account> cuentasConSupervisor, Map<Id, Account> oldMap){
		List<Account> accsToUpdate = new List<Account>();  
		for (Account acc : cuentasConSupervisor){
			if (acc.Supervisor__c != oldMap.get(acc.id).Supervisor__c || acc.Gerente_comercial__c != oldMap.get(acc.id).Gerente_comercial__c){
				accsToUpdate.add(acc);
			}
		}
		return accsToUpdate;
	}

	public static void cargarSupervisorYGerenteComercialAEventosRoyaltys(List<Account> cuentasConSupervisor, Map<Id, Account> oldMap){

		List<Evento_Royalty__c> eventosRoyaltys = new List<Evento_Royalty__c>();
		List<Id> idsCuentasConSupervisor = new List<Id>();

		cuentasConSupervisor = filterAccountsToUpdateResponsables(cuentasConSupervisor, oldMap);

		if (!cuentasConSupervisor.isEmpty()){
			for (Account cuenta : cuentasConSupervisor){
				idsCuentasConSupervisor.add(cuenta.Id);
			}

			eventosRoyaltys = [SELECT ID, Supervisor__c, Gerente_comercial__c, Cuenta__c
			                   FROM Evento_Royalty__c
			                   WHERE Cuenta__c IN :idsCuentasConSupervisor];

			for (Account cuenta : cuentasConSupervisor){
				for (Evento_Royalty__c eventoRoyalty : eventosRoyaltys){
					if (eventoRoyalty.Cuenta__c == cuenta.id){
						eventoRoyalty.Supervisor__c = cuenta.Supervisor__c;
						eventoRoyalty.Gerente_comercial__c = cuenta.Gerente_comercial__c;
					}
				}
			}
			update eventosRoyaltys;
		}
	}
}
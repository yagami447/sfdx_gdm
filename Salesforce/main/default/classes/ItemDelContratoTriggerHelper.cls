public class ItemDelContratoTriggerHelper  {

	public void registrarNuevosItemsEnLog(List<Item_del_Contrato__c> triggerNew) {
		Map<String, Contrato__c> mapaContratosClonados = new Map<String, Contrato__c>();
		Map<String, Contrato__c> mapaContratosOriginales = new Map<String, Contrato__c>();
		Map<String, Map<String, Item_del_Contrato__c>> mapaContratosItem = new Map<String, Map<String, Item_del_Contrato__c>>();
		mapaContratosClonados = this.devuelveContratosClonados(triggerNew);
		if(mapaContratosClonados.size() == 0) {
			return;
		}
		mapaContratosOriginales = this.devuelveContratosOriginales(mapaContratosClonados);
		mapaContratosItem = this.devuelveMapaContratoItems(mapaContratosOriginales);

		List<Contrato__c> contratosParaActualizar = new List<Contrato__c>();
		for(Item_del_Contrato__c item : triggerNew) {
			Contrato__c contrato = mapaContratosClonados.get(item.Contrato_de_Multiplicacion__c);
			if(contrato.log_cambios__c == null) {
				contrato.log_cambios__c = '';
			}
			if(!mapaContratosItem.get(contrato.contrato_ant__c).containsKey(item.Id)) {
				if(item.Clonado__c) {
					continue;
				}
				//Escribimos el Log:
				if(item.Contrato_de_Multiplicacao__c != null) {
					contrato.log_cambios__c += '\n\u2022Novo objetivo: ' + item.Name+ ' de ' 
                        + (item.Variedad__r.Name == null ? '0': item.Variedad__r.Name) 
                        +  ' em ' + item.Estado__c   
                        + ' x' + Integer.valueOf((item.Quantidade__c) == null ? 0 : item.Quantidade__c);
                    
                    
				} else {
					contrato.log_cambios__c += '\n\u2022Novo cultivar: ' + item.Name;
				}
				if(!contratosParaActualizar.contains(contrato)) {
					contratosParaActualizar.add(contrato);
				}	
			}
		}
		if(contratosParaActualizar.size() > 0) {
			update contratosParaActualizar;
		}
	}

	public  void actualizarItemsEnLog( List<Item_del_Contrato__c> triggerNew, Map<Id, Item_del_Contrato__c> triggerOldMap) {
		Map<String, Contrato__c> mapaContratosClonados = new Map<String, Contrato__c>();
		mapaContratosClonados = this.devuelveContratosClonados(triggerNew);
		if(mapaContratosClonados.size() == 0) {
			return;
		}
		List<Contrato__c> listaContratosActualizar = new List<Contrato__c>();
		for(Item_del_Contrato__c item : triggerNew) {
			Contrato__c clonado = mapaContratosClonados.get(item.Contrato_de_Multiplicacion__c);
			if(clonado.log_cambios__c == null) {
				clonado.log_cambios__c = '';
			}
			Item_del_Contrato__c itemViejo = triggerOldMap.get(item.id);
			if(item == itemViejo) {
				continue;
			}
			clonado.log_cambios__c += '\n' + '\u2022' + item.Name; 
			//Revisamos uno a uno los campos del Item para ver si alguno cambio
			if(item.Quantidade__c != itemViejo.Quantidade__c) {
				clonado.log_cambios__c += ' Quantidade alterado de ' 
                    + Integer.valueOf((itemViejo.Quantidade__c) == null ? 0 : itemViejo.Quantidade__c)
                    + ' para ' 
                    + Integer.valueOf((item.Quantidade__c)  == null ? 0 : item.Quantidade__c);
			}
			if(item.Volumen_Aut_Comercializacion__c	 != itemViejo.Volumen_Aut_Comercializacion__c	) {
				clonado.log_cambios__c += ' Volume de comercialização  alterado de ' + 
                    Integer.valueOf((itemViejo.Volumen_Aut_Comercializacion__c)  == null ? 0 : itemViejo.Volumen_Aut_Comercializacion__c)
                    + ' para ' 
                    + Integer.valueOf((item.Volumen_Aut_Comercializacion__c)  == null ? 0 : item.Volumen_Aut_Comercializacion__c);
			}
			if(!listaContratosActualizar.contains(clonado)) {
				listaContratosActualizar.add(clonado);
			}
		}
		if(listaContratosActualizar.size() > 0) {
			update listaContratosActualizar;
		}
		
	}


	public void actualizarItemsEnLogCuandoSeEliminan(Map<Id,Item_del_Contrato__c> triggerOldMap) {
		Map<String, Contrato__c> mapaContratosClonados = new Map<String, Contrato__c>();
		List<Item_del_Contrato__c> listaItems = new List<Item_del_Contrato__c>();
		List<Contrato__c> listaContratosActualizar = new List<Contrato__c>();
		for(Item_del_Contrato__c item : triggerOldMap.values()) {
			listaItems.add(item);
		}
		mapaContratosClonados = this.devuelveContratosOriginalesOnDelete(listaItems);
		if(mapaContratosClonados.size() == 0) {
			return;
		}

		for(Item_del_Contrato__c item : triggerOldMap.values()) {
			Contrato__c clonado = mapaContratosClonados.get(item.Contrato_de_Multiplicacion__c);
			if(clonado.log_cambios__c == null) {
				clonado.log_cambios__c = '';
			}
			if(clonado.Contrato_ant__c != null) {
				clonado.log_cambios__c += '\n\u2022Removido: ' + item.Name;
			}
			if(!listaContratosActualizar.contains(clonado)) {
				listaContratosActualizar.add(clonado);
			}
		}
		if(listaContratosActualizar.size() > 0) {
			update listaContratosActualizar;
		}
	}









	private  Map<String, Contrato__c> devuelveContratosClonados(List<Item_del_Contrato__c> triggerNew) {
		List<Contrato__c> contratosClonados = new List<Contrato__c>();
		List<Id> idsContratos = new List<Id>();
		idsContratos = this.idsContratos(triggerNew);
		Map<String, Contrato__c> mapaContratos =  new Map<String, Contrato__c>();

		contratosClonados = [
			SELECT Id, log_cambios__c, contrato_ant__c
			FROM Contrato__c
			WHERE Id IN: idsContratos
			AND Contrato_ant__c != null
		];
		for(Contrato__c contrato : contratosClonados) {
			mapaContratos.put(contrato.Id, contrato);
		}
		return mapaContratos;
	}

	private List<Id> idsContratos(List<Item_del_Contrato__c> triggerNew) {
		List<Id> idsContratos = new List<Id>();
		for(Item_del_Contrato__c item : triggerNew) {
			idsContratos.add(item.Contrato_de_Multiplicacion__c);
		}
		return idsContratos;
	}

	private Map<String, Contrato__c> devuelveContratosOriginales(Map<String, Contrato__c> contratosClonados) {
		List<Contrato__c> contratosOriginales = new List<Contrato__c>();
		List<Id> idsContratos = new List<Id>();
		Map<String, Contrato__c> mapaContratosRetorno =  new Map<String, Contrato__c>();

		for(Contrato__c clon : contratosClonados.values()) {
			idsContratos.add(clon.contrato_ant__c);
		}
		contratosOriginales = [
			SELECT Id
			FROM Contrato__c
			WHERE ID IN: idsContratos
		];
		for(Contrato__c contrato : contratosOriginales) {
			mapaContratosRetorno.put(contrato.Id, contrato);
		}
		return mapaContratosRetorno;
	}

	private Map<String, Map<String, Item_del_Contrato__c>> devuelveMapaContratoItems(Map<String, Contrato__c> contratosOriginales) {
		Map<String, Map<String, Item_del_Contrato__c>> mapaRetorno = new Map<String, Map<String, Item_del_Contrato__c>>();
		List<Item_del_Contrato__c> listaItems = [
			SELECT Id, Contrato_de_Multiplicacao__c, Name, Contrato_de_Multiplicacion__c 
			FROM Item_del_Contrato__c
			WHERE Contrato_de_Multiplicacao__c IN: contratosOriginales.keySet()
		];
		for(Contrato__c contrato : contratosOriginales.values()) {
			Map<String, Item_del_Contrato__c> mapaItems = new Map<String, Item_del_Contrato__c>();
			for(Item_del_Contrato__c item : listaItems) {
				if(item.Contrato_de_Multiplicacion__c == contrato.Id) {
					mapaItems.put(item.Id, item);
				}
			}
			mapaRetorno.put(contrato.Id, mapaItems);
		}
		return mapaRetorno;
	}

	private Map<String, Contrato__c> devuelveContratosOriginalesOnDelete(List<Item_del_Contrato__c> listaItems) {
		Map<String, Contrato__c> retorno = new Map<String, Contrato__c>();
		List<Id> ids = new List<Id>();
		List<Contrato__c> clonados = new List<Contrato__c>();
		for(Item_del_Contrato__c item: listaItems) {
			ids.add(item.Contrato_de_Multiplicacion__c);
		}
		clonados = [
			SELECT ID, log_cambios__c, contrato_ant__c
			FROM Contrato__c
			WHERE Id IN: ids
		];
		for(Contrato__c clon : clonados) {
			retorno.put(clon.Id, clon);
		}
		return retorno;
	}
}
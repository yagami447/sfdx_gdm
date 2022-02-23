public  class Contrato_cTriggerHelper {

	public static void escribirLogCambios(List<Contrato__c> triggerNew, Map<Id, Contrato__c> triggerOld) {
		
		List<Id> idsContratosOriginales = new List<Id>();
		List<Contrato__c> listaContratosOriginales = new List<Contrato__c>();
		Map<String, Contrato__c> mapaContratosOriginales = new Map<String, Contrato__c>();
		for(Contrato__c contrato : triggerNew) {
			if(contrato.Contrato_ant__c != null ) {
				idsContratosOriginales.add(contrato.Contrato_ant__c);
			}
		}
		//Modificar la query para incluir los campos a revisar por cambios
		listaContratosOriginales = [
			SELECT Id, Sociedad__c, Estados_Comercializacao__c, Contrato_marco__c, Region_Comercial__c,
			Meta_Qde_comodato_de_area__c, Meta_Qde_Dias_de_Campo__c, Volume_Total_Autorizado__c, Estado__c
			FROM Contrato__c
			WHERE ID IN: idsContratosOriginales
		];
		if(listaContratosOriginales.size() == 0) {
			return;
		}
		for(Contrato__c contrato : listaContratosOriginales) {
			mapaContratosOriginales.put(contrato.Id, contrato);
		}
		
		for(Contrato__c contrato : triggerNew) {
			if(contrato.Contrato_ant__c != null ) {
				Contrato__c original = mapaContratosOriginales.get(contrato.Contrato_ant__c);
				Contrato__c antiguo = triggerOld.get(contrato.Id);
					if(antiguo.Estado__c == 'Edição' && (contrato.Estado__c != antiguo.Estado__c)) {
						if(contrato.log_cambios__c == null) {
							contrato.log_cambios__c = '';
						}
					//Chequeamos si cambiaron los campos
					if(original.Sociedad__c != contrato.Sociedad__c) {
						contrato.log_cambios__c += '\n\u2022Marca alterada de ' + original.Sociedad__c + ' para ' + contrato.Sociedad__c;
					}
					if(original.Estados_Comercializacao__c != contrato.Estados_Comercializacao__c) {
						contrato.log_cambios__c += '\n\u2022Estados de Comercialização alterado de ' + original.Estados_Comercializacao__c + ' para ' + contrato.Estados_Comercializacao__c;
					}

					if(original.Contrato_marco__c != contrato.Contrato_marco__c) {
						contrato.log_cambios__c += '\n\u2022Contrato Marco alterado de ' + original.Contrato_marco__c + ' para ' + contrato.Contrato_marco__c;
					}

					if(original.Region_Comercial__c != contrato.Region_Comercial__c) {
						contrato.log_cambios__c += '\n\u2022Region Comercial alterado de ' + original.Region_Comercial__c + ' para ' + contrato.Region_Comercial__c;
					}

					if(original.Meta_Qde_comodato_de_area__c != contrato.Meta_Qde_comodato_de_area__c) {
						contrato.log_cambios__c += '\n\u2022Meta Qde Comodato de Área alterado de ' 
                            + Integer.valueOf((original.Meta_Qde_comodato_de_area__c)  == null ? 0 : original.Meta_Qde_comodato_de_area__c)
                            + ' para ' 
                            +  Integer.valueOf((contrato.Meta_Qde_comodato_de_area__c)  == null ? 0 : contrato.Meta_Qde_comodato_de_area__c);

					}

					if(original.Meta_Qde_Dias_de_Campo__c != contrato.Meta_Qde_Dias_de_Campo__c) {
						contrato.log_cambios__c += '\n\u2022Meta Qde Días de Campo Sem Custo alterado de ' 
                            + Integer.valueOf((original.Meta_Qde_Dias_de_Campo__c)  == null ? 0 : original.Meta_Qde_Dias_de_Campo__c)
                            + ' para ' 
                            +  Integer.valueOf((contrato.Meta_Qde_Dias_de_Campo__c)  == null ? 0 : contrato.Meta_Qde_Dias_de_Campo__c);

					}

					if(original.Volume_Total_Autorizado__c != contrato.Volume_Total_Autorizado__c) {
						contrato.log_cambios__c += '\n\u2022Volume Total Autorizado alterado de ' 
                            + Integer.valueOf((original.Volume_Total_Autorizado__c)  == null ? 0 : original.Volume_Total_Autorizado__c)
                            + ' para ' 
                            +  Integer.valueOf((contrato.Volume_Total_Autorizado__c)  == null ? 0 : contrato.Volume_Total_Autorizado__c);
					}
				}
			}
		}

	}
}
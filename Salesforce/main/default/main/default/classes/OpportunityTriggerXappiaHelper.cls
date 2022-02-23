public without sharing class OpportunityTriggerXappiaHelper{

	public static boolean firstTime = true;
	// Agregado por Jhonny Peroza
	public static Id vbHibrido = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venda_da_Hibrido').getRecordTypeId();
	public static Id vbCompleto = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venda_da_Basica_full').getRecordTypeId();
	public static void runSyncQuote(List<Opportunity> triggerNew, Map<Id, Opportunity> triggerOldMap){

		if (firstTime){
			firstTime = false;

			if (TriggerStopper.stopOpp)
				return;
			TriggerStopper.stopOpp = true;

			Set<String> quoteFields = QuoteSyncUtil.getQuoteFields();
			List<String> oppFields = QuoteSyncUtil.getOppFields();

			String quote_fields = QuoteSyncUtil.getQuoteFieldsString();

			String opp_fields = QuoteSyncUtil.getOppFieldsString();

			Map<Id, Id> startSyncQuoteMap = new Map<Id, Id>();
			String oppIds = '';
			for (Opportunity opp : triggerNew){
				if (opp.SyncedQuoteId != triggerOldMap.get(opp.Id).SyncedQuoteId){
					if (opp.SyncedQuoteId != null){
						startSyncQuoteMap.put(opp.SyncedQuoteId, opp.Id);
					}
					continue;
				}
				if (oppIds != '')
					oppIds += ', ';
				oppIds += '\'' + opp.Id + '\'';
			}

			if (oppIds != ''){
				String oppQuery = 'select Id, SyncedQuoteId' + opp_fields + ' from Opportunity where Id in (' + oppIds + ') and SyncedQuoteId != null';
				//System.debug(oppQuery);

				List<Opportunity> opps = Database.query(oppQuery);

				String quoteIds = '';
				Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();

				for (Opportunity opp : opps){
					if (opp.SyncedQuoteId != null){
						oppMap.put(opp.Id, opp);
						if (quoteIds != '')
							quoteIds += ', ';
						quoteIds += '\'' + opp.SyncedQuoteId + '\'';
					}
				}

				if (quoteIds != ''){
					String quoteQuery = 'select Id, OpportunityId' + quote_fields + ' from Quote where Id in (' + quoteIds + ')';
					//System.debug(quoteQuery);

					List<Quote> quotes = Database.query(quoteQuery);
					List<Quote> updateQuotes = new List<Quote>();

					for (Quote quote : quotes){
						Opportunity opp = oppMap.get(quote.OpportunityId);
						boolean hasChange = false;
						for (String quoteField : quoteFields){
							String oppField = QuoteSyncUtil.getQuoteFieldMapTo(quoteField);
							Object oppValue = opp.get(oppField);
							Object quoteValue = quote.get(quoteField);
							if (oppValue != quoteValue){
								hasChange = true;
								if (oppValue == null)
									quote.put(quoteField, null);
								else
									quote.put(quoteField, oppValue);
							}
						}
						if (hasChange)
							updateQuotes.add(quote);
					}
					TriggerStopper.stopQuote = true;
					Database.update(updateQuotes);
					TriggerStopper.stopQuote = false;
				}
			}
		}
	}

	public static void cloneQuote(Map<id, opportunity> newOpps, Set<Id> OpportunitiesIds){

		Map<Id, Quote> newQuotesByOldQuoteId = new Map<Id, Quote>();

		Map<Id, opportunity> opportunityQuoteCount = new Map<Id, Opportunity>([SELECT Id, (SELECT Id
		                                                                                   FROM Quotes)
		                                                                       FROM Opportunity
		                                                                       WHERE Id IN :OpportunitiesIds]);

		List<Quote> quotes = [SELECT Id, Name, Status, TotalPrice, IsSyncing, OpportunityId, (SELECT Id, Product2.Name, TotalPrice, Quantity, PricebookEntryId, UnitPrice, Tipo_de_necessidade__c
		                                                                                      FROM QuoteLineItems)
		                      FROM Quote
		                      WHERE OpportunityId = :OpportunitiesIds AND IsSyncing = TRUE];
		Map<Id, Quote> oldQuotebyOpportunityId = new Map<Id, Quote>();

		for (Quote aQuote : quotes){
			aQuote.Status = 'Rejeitado';

			Quote newQuote = aQuote.clone();
			newQuote.Name = 'Proposta ' + String.valueOf(opportunityQuoteCount.get(aQuote.OpportunityId).Quotes.size()+1);
			newQuote.OpportunityId = aQuote.OpportunityId;
			newQuote.Status = 'Rascunho';
			oldQuotebyOpportunityId.put(aQuote.id, newQuote);
		}


		insert oldQuotebyOpportunityId.values();
		update quotes;

		List<QuoteLineItem> newQuoteLineitems = new List<QuoteLineItem>();
		Set<id> quoteIds = new Set<id>();
		for (Quote aQuote : quotes){
			quoteIds.add(oldQuotebyOpportunityId.get(aQuote.id).id);
			newQuoteLineitems.addAll(relacionarProductosALNuevoPresupuesto(aQuote, oldQuotebyOpportunityId.get(aQuote.id)));
		}
		SyncQuote(quoteIds);
		insert newQuoteLineitems;
	}

	public static List<QuoteLineItem> relacionarProductosALNuevoPresupuesto(Quote presupuestoRechazado, Quote newQuote){
		Set<Id> productId = new Set<Id>();
		List<QuoteLineItem> newPartidasDePresupuesto = new List<QuoteLineItem>();
		for (QuoteLineItem ppr : presupuestoRechazado.QuoteLineItems){
			newPartidasDePresupuesto.add(new QuoteLineItem(QuoteId = newQuote.Id, Product2Id = ppr.Product2Id, Quantity = ppr.Quantity, UnitPrice = ppr.UnitPrice, PricebookEntryId = ppr.PricebookEntryId, Tipo_de_Necessidade__c = ppr.Tipo_de_Necessidade__c));
		}
		return newPartidasDePresupuesto;
	}

	@future
	public static void SyncQuote(Set<Id> quoteIds){
		System.debug('SYNCQUOTE ');
		List<Quote> quotes = [SELECT Id, OpportunityId
		                      FROM Quote
		                      WHERE Id in :quoteIds];
		List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
		for (Quote aQuote : quotes){
			Opportunity opportunityToUpdate = new Opportunity();
			opportunityToUpdate.Id = aQuote.OpportunityId;
			opportunityToUpdate.SyncedQuoteId = aQuote.Id;
			opportunitiesToUpdate.add(opportunityToUpdate);
		}
		update opportunitiesToUpdate;
	}

	@future
	public static void SyncQuoteOpp(Set<Id> opportunitiesIds){
		List<Quote> quotes = [SELECT Id, OpportunityId// ,(
		//     SELECT Id, Product2.Name, Product2.Description, Product2.UNIDADE__c,Product2.Categoria__c,
		//     TotalPrice, Quantity, Tipo_de_necessidade__c, UnitPrice
		//     FROM QuoteLineItems
		// )
		                      FROM Quote
		                      WHERE OpportunityId IN :opportunitiesIds];

		System.debug('OPP TRIGGER HELPER -- SYNCQUOTEOPP -- QUOTES SIZE ' + quotes.size());

		Map<Id, Opportunity> opportunitesToUpdate = new Map<Id, Opportunity>();

		if (!quotes.isEmpty()){
			for (Quote aQuote : quotes){
				Opportunity opportunityToUpdate = new Opportunity();
				if (opportunitesToUpdate.containsKey(aQuote.OpportunityId))
					continue;
				opportunityToUpdate.Id = aQuote.OpportunityId;
				opportunityToUpdate.SyncedQuoteId = aQuote.Id;
				opportunitesToUpdate.put(opportunityToUpdate.Id, opportunityToUpdate);
			}
			update opportunitesToUpdate.values();
		}

	}
	
	public static void setCampaignVendaBasica(List<Opportunity> oportunidades){ 

		List<String> safras = new List<String>();
		List<String> accountsId = new List<String>();
		List<String> negociosId = new List<String>();

		for (Opportunity opp : oportunidades){
			safras.add(opp.safra__c);
			accountsId.add(opp.AccountId);

			if(opp.Negocio_por_Conta__c != null) {
				negociosId.add(opp.Negocio_por_Conta__c);
			}

		}

		List<Campaign> campanhas = [SELECT Id, Condiciones_de_Pago__c, Marca__c, Safra__c, Cultura__c, Region_VB__c, StartDate, EndDate, Lista_de_precios__c, epoca_de_producao__c, Conta__c, Status
		                            FROM Campaign
		                            WHERE Safra__c IN :safras AND Region_VB__c != NULL];

		List<Negocio_por_Conta__c> negocios = [SELECT Id, Marca__c, Cultura__c, Region_Comercial__c, Conta__c
													FROM Negocio_por_Conta__c
														WHERE Id IN :negociosId];

		Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, Region__r.Region_Comercial__c, region__c
		                                                  FROM Account
		                                                  WHERE Id IN :accountsId]);

		Map<Id, Opportunity> campIdOpp = new Map<Id, Opportunity>();
		for (Opportunity oppUnit : oportunidades){
			Boolean auxVal = false;
			String epoca = (oppUnit.Tipo_de_Cultivares__c == 'Comerciais') ? 'Verão' : 'Inverno';
			DateTime createdDate = System.today();
			boolean hasPaymentCondition = false;
			Account acc = accounts.get(oppUnit.AccountId);
			for (Campaign camp : campanhas){
				// Venda de Hibrido
				if (oppUnit.RecordTypeId == vbHibrido) {	
					for(Negocio_por_Conta__c negocio : negocios) {
						oppUnit.Negocio_por_Conta__c = negocio.Id;
						oppUnit.Marca__c = negocio.Marca__c;
						oppUnit.AccountId = negocio.Conta__c;
		
						if (CreatedDate >= camp.StartDate && CreatedDate <= camp.EndDate && oppUnit.Safra__c == camp.Safra__c && negocio.Marca__c == camp.Marca__c && (negocio.Region_Comercial__c == null || camp.Region_VB__c.contains(negocio.Region_Comercial__c)) && epoca == camp.epoca_de_producao__c && camp.Status == 'Aprovado'){
							oppUnit.CampaignId = camp.Id;
							if (camp.Lista_de_precios__c != null) {
								oppUnit.Pricebook2Id = camp.Lista_de_precios__c;
							} 
						}
					}
				} 
				// Venda de Básica completo
				if(oppUnit.RecordTypeId == vbCompleto){

					// Agregamos lógica de Campaign (Campaña) exclusiva para Account (Cuenta) | RecordType == 'Venda_da_Basica_full' (Venda de Basica)

					if(camp.Conta__c == oppUnit.AccountId && CreatedDate >= camp.StartDate && CreatedDate <= camp.EndDate && oppUnit.Safra__c == camp.Safra__c && epoca == camp.epoca_de_producao__c && camp.Status == 'Aprovado') {
						oppUnit.CampaignId = camp.Id;
						if (camp.Lista_de_precios__c != null) {	
								oppUnit.Pricebook2Id = camp.Lista_de_precios__c;
						} 
						break;
					} else {

						if (CreatedDate >= camp.StartDate && CreatedDate <= camp.EndDate && oppUnit.Safra__c == camp.Safra__c && oppUnit.Marca__c == camp.Marca__c && (acc.Region__c == null || camp.Region_VB__c.contains(acc.Region__r.Region_Comercial__c)) && epoca == camp.epoca_de_producao__c && camp.Status == 'Aprovado' && camp.Conta__c == null){						
							oppUnit.CampaignId = camp.Id;
							if (camp.Lista_de_precios__c != null) {
								oppUnit.Pricebook2Id = camp.Lista_de_precios__c;
							} 
						}
					}
				}
			}

			if (oppUnit.CampaignId == null) {
				oppUnit.addError('Não há campanha para a Venda que você deseja inserir');
			}

		}
		
	}

	public static void whenOppIsAnulada_LockRecord(List<Opportunity> opps, Map<id, Opportunity> oldMap){

		for (Opportunity op : opps){
			if (op.StageName == 'Anulada'){
				Approval.lock(op, false);

			}
		}
	}

	@TestVisible private static Boolean checkNewStock(List<Opportunity> opps){
		Boolean newStock = false;
		for (Opportunity opp : opps){
			if (opp.TipoReg__c == 'Stock Multiplicadores'){
				newStock = true;
			}
		}
		return newStock;
	}

	@TestVisible public static void validarEstoque(List<Opportunity> opps){
		if (!Test.isRunningTest()){
			Boolean procesNewStock = checkNewStock(opps);
			if (procesNewStock){
				System.debug('Validando estoque');
				List<Configuracion_BMX__c> conf = aSiteUtils.queryResults1(Configuracion_BMX__c.SObjectType, null, 'Name = :v1', 'Facturacion');
				Integer desde = 1;
				Integer hasta = 31;
				if (conf[0].PM_Estoque_Dia_Desde__c != null)
					desde = Integer.valueOf(conf[0].PM_Estoque_Dia_Desde__c);
				if (conf[0].PM_Estoque_Dia_Hasta__c != null)
					hasta = Integer.valueOf(conf[0].PM_Estoque_Dia_Hasta__c);
				Integer hoy = system.today().day();
				String inititalDate = '20/' + System.today().month();
				String endDate = '03/' + (System.today().addMonths(+1).month());
				List<Opportunity> newStockes = new List<Opportunity>();

				for (Opportunity opp : opps){
					if (opp.TipoReg__c == 'Stock Multiplicadores'){
						newStockes.add(opp);
						if (hoy <= desde && hoy > hasta){
							opp.addError('Não é permitido lançar o estoque fora do prazo.Período permitido entre os dias ' + inititalDate + ' e ' + endDate);
						}
					}
				}

			}
		}
	}

	public static void desactivateOldStock_ActivateNewStock(List<Opportunity> updatedStockes, Map<id, Opportunity> oldVersions){
	
		Map<id,Opportunity> newStocks = checkIfIsAStockTransaction(updatedStockes,oldVersions);		
		if (!newStocks.isEmpty()){
			
			List<Opportunity> accountStockes = [SELECT ID, Name, Activa__c
			                                    FROM Opportunity
			                                    WHERE AccountId = :updatedStockes[0].AccountId AND RecordType.DeveloperName = 'Stock_Multiplicadores'
			                                    order by CreatedDate desc];

			List<Opportunity> oppsToUpdate = new List<Opportunity>();

			for(Opportunity opp : accountStockes){
				System.debug('Opp stockes');
				System.debug(opp);
				if(newStocks.get(opp.id) == null){
					opp.activa__c = false;
					oppsToUpdate.add(opp);
				}
			}
			update oppsToUpdate;			
		}
	}

	private static Map<id,Opportunity> checkIfIsAStockTransaction(List<Opportunity> updatedStockes,Map<id, Opportunity> oldVersions){
		Map<id,Opportunity> updatedOppsMap = new Map<id,Opportunity>();
	
		Id stockMultiplicadoresRT_ID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Stock_Multiplicadores').getRecordTypeId();
		for (Opportunity opp : updatedStockes){			
			if (opp.RecordTypeId == stockMultiplicadoresRT_ID && (opp.activa__c == true && oldVersions.get(opp.id).activa__c == false )){
				updatedOppsMap.put(opp.id,opp);
			}
		}
		return updatedOppsMap;
	}

	public static void syncRegionAccountWithOpp(List<Opportunity> opps){
		Map<id,String> regionByAccountIdMap = new Map<id,String>();
		Set<id> accsIds = new Set<id>();
		Id stockMultiplicadoresRT_ID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Stock_Multiplicadores').getRecordTypeId();
		Boolean isNewStock = true;
		for(Opportunity opp : opps){
			if(opp.AccountId != null){
				accsIds.add(opp.AccountId);	
			}	
			if(opp.REcordTypeId != stockMultiplicadoresRT_ID){
				isNewStock = false;
			}		
		}
		if(isNewStock){
			Map<id,Account> oppsAccs = new Map<id,Account>([SELECT id,Name,Region_Comercial__c FROM Account WHERE id in : accsIds]);
		
			for(Opportunity opp : opps){
				if(oppsAccs.get(opp.AccountId) != null){
					Account thisAccount = oppsAccs.get(opp.AccountId);
					opp.Region__c = thisAccount.Region_Comercial__c;
				}
			}
		}
		
	}
}
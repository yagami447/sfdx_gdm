public class OpportunityLineItemTriggerXappiaHelper{
	public static boolean firstTime = true;

	public static void ValidaProductosCVB(List<OpportunityLineItem> olis){
		
	}

	public static void LREngineUpdate(List<OpportunityLineItem> objects){

		if (!firstTime)
			return;
		firstTime = false;


		LREngine.Context ctx = new LREngine.Context(Opportunity.SobjectType,     // parent object
		OpportunityLineItem.SobjectType,      // child object
		Schema.SObjectType.OpportunityLineItem.fields.OpportunityId // relationship field name
		);

		ctx.add(new LREngine.RollupSummaryField(Schema.SObjectType.Opportunity.fields.Total_do_primeiro_pagamento__c, Schema.SObjectType.OpportunityLineItem.fields.Total_do_primeiro_pagamento__c, LREngine.RollupOperation.Sum));
		ctx.add(new LREngine.RollupSummaryField(Schema.SObjectType.Opportunity.fields.Total_do_segundo_pagamento__c, Schema.SObjectType.OpportunityLineItem.fields.Total_do_segundo_pagamento__c, LREngine.RollupOperation.Sum));
		ctx.add(new LREngine.RollupSummaryField(Schema.SObjectType.Opportunity.fields.Total_do_terceiro_pagamento__c, Schema.SObjectType.OpportunityLineItem.fields.Total_do_terceiro_pagamento__c, LREngine.RollupOperation.Sum));
		ctx.add(new LREngine.RollupSummaryField(Schema.SObjectType.Opportunity.fields.Total_do_quarto_pagamento__c, Schema.SObjectType.OpportunityLineItem.fields.Total_do_quarto_pagamento__c, LREngine.RollupOperation.Sum));
		ctx.add(new LREngine.RollupSummaryField(Schema.SObjectType.Opportunity.fields.Total_do_quinto_pagamento__c, Schema.SObjectType.OpportunityLineItem.fields.Total_do_quinto_pagamento__c, LREngine.RollupOperation.Sum));

		ctx.add(new LREngine.RollupSummaryField(Schema.SObjectType.Opportunity.fields.Kg_de_produto__c, Schema.SObjectType.OpportunityLineItem.fields.Kg_de_produto__c, LREngine.RollupOperation.Sum));

		ctx.add(new LREngine.RollupSummaryField(Schema.SObjectType.Opportunity.fields.Total__c, Schema.SObjectType.OpportunityLineItem.fields.Total__c, LREngine.RollupOperation.Sum));
		ctx.add(new LREngine.RollupSummaryField(Schema.SObjectType.Opportunity.fields.Preco_total_sugerido_sem_juros__c, Schema.SObjectType.OpportunityLineItem.fields.Total_sugerido__c, LREngine.RollupOperation.Sum));

		Sobject[] masters = LREngine.rollUp(ctx, objects);
		update masters;
	}

	public static void populateRequiredFields(List<OpportunityLineItem> olis){
		if (QuoteSyncUtil.isRunningTest){
			for (OpportunityLineItem oli : olis){
				QuoteSyncUtil.populateRequiredFields(oli);
			}
		}
		return;
	}

	public static void OppLineSync(List<OpportunityLineItem> newOlis, Map<id, OpportunityLineItem> oldMap, String dml){
		if (newOlis.size() > 0){

			if (TriggerStopper.stopOppLine)
				return;
			Set<String> quoteLineFields = QuoteSyncUtil.getQuoteLineFields();
			List<String> oppLineFields = QuoteSyncUtil.getOppLineFields();

			String qliFields = QuoteSyncUtil.getQuoteLineFieldsString();

			String oliFields = QuoteSyncUtil.getOppLineFieldsString();

			String oliIds = '';
			for (OpportunityLineItem oli : newOlis){
				if (oliIds != '')
					oliIds += ', ';
				oliIds += '\'' + oli.Id + '\'';
			}

			String oliQuery = 'select Id, OpportunityId, PricebookEntryId, UnitPrice, Quantity, Discount, ServiceDate, SortOrder' + oliFields + ' from OpportunityLineItem where Id in (' + oliIds + ') order by OpportunityId, SortOrder ASC';
			System.debug('oliQuery FROM opportunityLineItemTriggerXappiaHelper : ' + oliQuery);

			List<OpportunityLineItem> olis = Database.query(oliQuery);

			Map<Id, List<OpportunityLineItem>> oppToOliMap = new Map<Id, List<OpportunityLineItem>>();

			for (OpportunityLineItem oli : olis){
				List<OpportunityLineItem> oliList = oppToOliMap.get(oli.OpportunityId);
				if (oliList == null){
					oliList = new List<OpportunityLineItem>();
				}
				oliList.add(oli);
				oppToOliMap.put(oli.OpportunityId, oliList);
			}

			Set<Id> oppIds = oppToOliMap.keySet();
			Map<Id, Opportunity> opps = new Map<Id, Opportunity>([select id, SyncedQuoteId
			                                                      from Opportunity
			                                                      where Id in :oppIds and SyncedQuoteId != null]);

			String quoteIds = '';
			for (Opportunity opp : opps.values()){
				if (opp.SyncedQuoteId != null){
					if (quoteIds != '')
						quoteIds += ', ';
					quoteIds += '\'' + opp.SyncedQuoteId + '\'';
				}
			}

			if (quoteIds != ''){

				String qliQuery = 'select Id, QuoteId, PricebookEntryId, UnitPrice, Quantity, Discount, ServiceDate, SortOrder' + qliFields + ' from QuoteLineItem where QuoteId in (' + quoteIds + ') order by QuoteId, SortOrder ASC';
				System.debug('qliQuery FROM opportunityLineItemTriggerXappiaHelper : ' + qliQuery);

				List<QuoteLineItem> qlis = Database.query(qliQuery);

				Map<Id, List<QuoteLineItem>> quoteToQliMap = new Map<Id, List<QuoteLineItem>>();

				for (QuoteLineItem qli : qlis){
					List<QuoteLineItem> qliList = quoteToQliMap.get(qli.QuoteId);
					if (qliList == null){
						qliList = new List<QuoteLineItem>();
					}
					qliList.add(qli);
					quoteToQliMap.put(qli.QuoteId, qliList);
				}

				Set<QuoteLineItem> updateQlis = new Set<QuoteLineItem>();
				Set<OpportunityLineItem> updateOlis = new Set<OpportunityLineItem>();

				for (Opportunity opp : opps.values()){

					List<QuoteLineItem> quotelines = quoteToQliMap.get(opp.SyncedQuoteId);

					// for opp line insert, there will not be corresponding quote line
					if (quotelines == null)
						continue;
					Set<QuoteLineItem> matchedQlis = new Set<QuoteLineItem>();

					for (OpportunityLineItem oli : oppToOliMap.get(opp.Id)){
						boolean updateQli = false;
						OpportunityLineItem oldOli = null;

						if (dml == 'isUpdate'){
							oldOli = oldMap.get(oli.Id);
							if (oli.UnitPrice == oldOli.UnitPrice && oli.Quantity == oldOli.Quantity && oli.Discount == oldOli.Discount && oli.ServiceDate == oldOli.ServiceDate && oli.SortOrder == oldOli.SortOrder)
								updateQli = true;
						}

						boolean hasChange = false;
						boolean match = false;

						for (QuoteLineItem qli : quotelines){
							if (oli.pricebookentryid == qli.pricebookentryId && oli.UnitPrice == qli.UnitPrice && oli.Quantity == qli.Quantity && oli.Discount == qli.Discount && oli.ServiceDate == qli.ServiceDate && oli.SortOrder == qli.SortOrder){

								if (updateQlis.contains(qli) || matchedQlis.contains(qli))
									continue;
								matchedQlis.add(qli);

								for (String qliField : quoteLineFields){
									String oliField = QuoteSyncUtil.getQuoteLineFieldMapTo(qliField);
									Object oliValue = oli.get(oliField);
									Object qliValue = qli.get(qliField);
									if (oliValue != qliValue){

										if (dml == 'isInsert'){
											if (qliValue == null)
												oli.put(oliField, null);
											else
												oli.put(oliField, qliValue);
											hasChange = true;

										} else if (dml == 'isUpdate' && !updateQli /*&& oldOli != null*/){
											//Object oldOliValue = oldOli.get(oliField);
											//if (oliValue == oldOliValue) {
											if (qliValue == null)
												oli.put(oliField, null);
											else
												oli.put(oliField, qliValue);
											hasChange = true;
											//}

										} else if (dml == 'isUpdate' && updateQli){
											if (oliValue == null)
												qli.put(qliField, null);
											else
												qli.put(qliField, oliValue);
											hasChange = true;
										}
									}
								}
								if (hasChange){
									if (dml == 'isInsert' || (dml == 'isUpdate' && !updateQli)){
										updateOlis.add(oli);
									} else if (dml == 'isUpdate' && updateQli){
										updateQlis.add(qli);
									}
								}

								match = true;
								break;
							}
						}

						// NOTE: this cause error when there is workflow field update that fired during record create
						//if (trigger.isUpdate && updateQli) System.assert(match, 'No matching quoteline');
					}
				}

				TriggerStopper.stopOpp = true;
				TriggerStopper.stopQuote = true;
				TriggerStopper.stopOppLine = true;
				TriggerStopper.stopQuoteLine = true;

				if (!updateOlis.isEmpty()){
					List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
					oliList.addAll(updateOlis);

					Database.update(oliList);
				}

				if (!updateQlis.isEmpty()){
					List<QuoteLineItem> qliList = new List<QuoteLineItem>();
					qliList.addAll(updateQlis);

					Database.update(qliList);
				}

                TriggerStopper.stopOpp = false;
                TriggerStopper.stopQuote = false;
                TriggerStopper.stopOppLine = false;
                TriggerStopper.stopQuoteLine = false;
            }
        }
    }
    
    public static List<OpportunityLineItem> getVBRecords(List<OpportunityLineItem> newOlis){
        List<OpportunityLineItem> vbOlis = new List<OpportunityLineItem>();
        set<Id> opportunityId = new set<Id>();
        for (OpportunityLineItem oli : newOlis) {
            opportunityId.add(oli.OpportunityId);
        }
        
        Map<Id, Opportunity> opportunityByIds = new Map<Id, Opportunity> ([
            SELECT Id, RecordTypeId
            FROM Opportunity
            WHERE Id IN :opportunityId
        ]);
        
        for (OpportunityLineItem oli : newOlis){
            if (opportunityByIds.get(oli.OpportunityId).RecordTypeId == XappiaHelper.getRecordType('Opportunity', 'Venda_da_Basica_full').Id){
                vbOlis.add(oli);
            }
        }
        return vbOlis;
    }
    
    public static void filterVBRecords_LREngineUpdate(List<OpportunityLineItem> newOlis, Map<Id, OpportunityLineItem> oldMap, String dml){
        List<OpportunityLineItem> recordsVB = new List<OpportunityLineItem>();
        for (OpportunityLineItem oli : newOlis){
            if (oli.Opportunity_Type__c == XappiaHelper.getRecordType('Opportunity', 'Venda_da_Basica_full').Id){
                if (dml == 'isInsert' || 
                    oli.Quantity != oldMap.get(oli.Id).Quantity || 
                    oli.UnitPrice != oldMap.get(oli.Id).UnitPrice || 
                    oli.Tipo_de_Necessidade__c != oldMap.get(oli.Id).Tipo_de_Necessidade__c
                   ){
                       recordsVB.add(oli);
                   }
            }
        }

		if (recordsVB.size() > 0){
			LREngineUpdate(recordsVB);
		}
	}

	public static String getCurrentEvent(Boolean isInsert,Boolean isUpdate,Boolean isDelete){
		String event = '';
		if (isInsert){
			event = 'isInsert';
		}
		if(isUpdate){
			event = 'isUpdate';
		}
		if (isDelete){
			event = 'isDelete';
		}
		return event;
	}

    /**
     *  METHOD:         setFixedPriceProducts 
     *  PARAMETERS:     Trigger.new (List of OpportunityLineItem)
     *  RETURN:         -
     *  DESCRIPTION:    Sets OppLineItem Price if the selected PricebookEntry has fixed price settings in place. Created for US #12786 
     *  AUTHOR:         irina.benitez@cloudgaia.com (14-sept-21)
     **/ 
	public static void setFixedPriceProducts(List<OpportunityLineItem> newOppLineItems, Map<Id, OpportunityLineItem> oldOppLineItemsMap) {

		Set<Id> pricebookEntryIds = new Set<Id>();

		for(OpportunityLineItem oppLineItem : newOppLineItems) {
			if(oldOppLineItemsMap == null ||
					oppLineItem.Quantity != oldOppLineItemsMap.get(oppLineItem.Id).Quantity ||
					oppLineItem.Kg_de_Produto__c != oldOppLineItemsMap.get(oppLineItem.Id).Kg_de_Produto__c ||
					oppLineItem.UnitPrice != oldOppLineItemsMap.get(oppLineItem.Id).UnitPrice ) {
				pricebookEntryIds.add(oppLineItem.PricebookEntryId);
			}
		}

		Map<Id, PricebookEntry> pbEntries = new Map<Id, PricebookEntry>([SELECT Id, 
																				Fixed_Price__c, 
																				Max_Kg_First_Price__c, 
																				Max_Kg_Second_Price__c, 
																				Max_Kg_Third_Price__c, 
																				First_Price__c, 
																				Second_Price__c, 
																				Third_Price__c, 
																				Fourth_Price__c
																		FROM PricebookEntry
																		WHERE Id IN :pricebookEntryIds
																		AND Fixed_Price__c = true]);

		for (OpportunityLineItem oppLineItem : newOppLineItems) {

			if( !pbEntries.containsKey(oppLineItem.PricebookEntryId) ) {
				continue;
			} else {
				PricebookEntry pbEntry = pbEntries.get(oppLineItem.PricebookEntryId);

				if( pbEntry.Fourth_Price__c != null && oppLineItem.Kg_de_Produto__c > pbEntry.Max_Kg_Third_Price__c ) {
					oppLineItem.UnitPrice = pbEntry.Fourth_Price__c;
				} else if ( pbEntry.Third_Price__c != null && oppLineItem.Kg_de_Produto__c > pbEntry.Max_Kg_Second_Price__c ) {
					oppLineItem.UnitPrice = pbEntry.Third_Price__c;
				} else if ( pbEntry.Second_Price__c != null && oppLineItem.Kg_de_Produto__c > pbEntry.Max_Kg_First_Price__c) {
					oppLineItem.UnitPrice = pbEntry.Second_Price__c;
				} else {
					oppLineItem.UnitPrice = pbEntry.First_Price__c;
				}
				
			}
		}
	}


}
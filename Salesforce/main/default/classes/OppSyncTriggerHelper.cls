public class OppSyncTriggerHelper {
    public static boolean firstTime = true;
    
    
    public static void runSyncQuote (List<Opportunity> triggerNew, Map<Id, Opportunity> triggerOldMap) {
        
        if (firstTime) {
            firstTime = false;
            
            if (TriggerStopper.stopOpp) return;
            
            TriggerStopper.stopOpp = true;    
            
            Set<String> quoteFields = QuoteSyncUtil.getQuoteFields();
            List<String> oppFields = QuoteSyncUtil.getOppFields();
            
            String quote_fields = QuoteSyncUtil.getQuoteFieldsString();
            
            String opp_fields = QuoteSyncUtil.getOppFieldsString();    
            
            Map<Id, Id> startSyncQuoteMap = new Map<Id, Id>();    
            String oppIds = '';
            for (Opportunity opp : triggerNew) {
                if (opp.SyncedQuoteId != triggerOldMap.get(opp.Id).SyncedQuoteId) {
                    if (opp.SyncedQuoteId  != null) {
                        startSyncQuoteMap.put(opp.SyncedQuoteId, opp.Id);
                    }                
                    continue;
                }    
                if (oppIds != '') oppIds += ', ';
                oppIds += '\'' + opp.Id + '\'';
            }
            
            if (oppIds != '') {
                String oppQuery = 'select Id, SyncedQuoteId' + opp_fields + ' from Opportunity where Id in (' + oppIds + ') and SyncedQuoteId != null';
                //System.debug(oppQuery);     
                
                List<Opportunity> opps = Database.query(oppQuery);
                
                String quoteIds = '';
                Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
                
                for (Opportunity opp : opps) {
                    if (opp.SyncedQuoteId != null) {
                        oppMap.put(opp.Id, opp);
                        if (quoteIds != '') quoteIds += ', ';
                        quoteIds += '\'' + opp.SyncedQuoteId + '\'';            
                    }
                }
                
                if (quoteIds != '') { 
                    String quoteQuery = 'select Id, OpportunityId' + quote_fields + ' from Quote where Id in (' + quoteIds + ')';
                    //System.debug(quoteQuery);
                    
                    List<Quote> quotes = Database.query(quoteQuery);
                    List<Quote> updateQuotes = new List<Quote>();
                    
                    for (Quote quote : quotes) {
                        Opportunity opp = oppMap.get(quote.OpportunityId);
                        boolean hasChange = false;
                        for (String quoteField : quoteFields) {
                            String oppField = QuoteSyncUtil.getQuoteFieldMapTo(quoteField);
                            Object oppValue = opp.get(oppField);
                            Object quoteValue = quote.get(quoteField);
                            if (oppValue != quoteValue) {
                                hasChange = true;
                                if (oppValue == null) quote.put(quoteField, null);
                                else quote.put(quoteField, oppValue);                                             
                            }                     
                        }
                        if (hasChange) updateQuotes.add(quote);                                  
                    } 
                    TriggerStopper.stopQuote = true;           
                    Database.update(updateQuotes);
                    TriggerStopper.stopQuote = false;             
                }
            }
        }
    }
    
}
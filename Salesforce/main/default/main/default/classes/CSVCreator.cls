public class CSVCreator  {

    public Opportunity opp = New Opportunity();

    private static List<String> separateCommas(String input){
        List<String> results = input.split(';');

        for(String result : results) {
            result = result.trim();
        }

        return results;
    }

    @AuraEnabled
    public static CSVObject getCSVObject(String csv_str) {
        List<String> lines_raw = csv_str.split('\n');
        List<String> headers_raw = separateCommas(lines_raw[0]);
        List<List<String>> lines = new List<List<String>>();
        List<CSVHeader> headers = new List<CSVHeader>();

        lines_raw.remove(0);

        //Handling fields with commas

        for(String line : lines_raw) {
            List<String> line_sep = separateCommas(line);
            List<String> fields = new List<String>();
            Boolean makeCompositeField = false;
            String compositeField;
            for(String field : line_sep) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    fields.add(field.trim());
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    fields.add(compositeField.trim());
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    fields.add(field.trim());
                }
            }
            lines.add(fields);
        }

        for(String header : headers_raw) {
            headers.add(new CSVHeader(header));
        }

        return new CSVObject(headers, lines);        
    }
    
    @AuraEnabled
    public static String crearEstimativas(String jsonString, String safra, String mes) {
    
        //return 'a';
        
        Savepoint sp = Database.setSavepoint();
                
        try{
        
            CSVObject csv_obj = (CSVObject)JSON.deserialize(jsonString, CSVObject.class);
            safra = safra.replace('"','');
            mes = mes.replace('"','');

            for (List<String> s : csv_obj.lines){
                if (s[8] == null || s[8] == '' || s[9] == null || s[9] == '')
                    return 'Algumas contas e / ou variedades não foram encontradas.';
            }
            
            Map<String,PricebookEntry> rPb = Opp_Utils.cargarRoyaltyPricebookEntries('Lista Canal Multiplicadores');
            Map<String, Id> rty = Opp_Utils.cargarRecordTypesOportunidades();
            String rt_Estim = rty.get('Estimativa de faturamento');  
            
            Map<String,Opportunity> mapOpps = new Map<String,Opportunity>();                  
        
            /*
            List<Opportunity> registrosActuales = New List<Opportunity>();
            registrosActuales = [Select Id From Opportunity Where RecordType.Name = 'Estimativa de faturamento' And Safra__c =: safra And Mes__c =: mes];
            if (registrosActuales.size() > 0)
                delete registrosActuales;
                
                            
            List<Opportunity> registrosActivos = New List<Opportunity>();
            registrosActivos = [Select Id, Activa__c From Opportunity Where RecordType.Name = 'Estimativa de faturamento' And Safra__c =: safra And Activa__c = true];
            if (registrosActivos.size() > 0){
                for (Opportunity o: registrosActivos)
                    o.Activa__c = false;
                    
                update registrosActivos;
            }
            */
            
            List<Opportunity> createOpps = new List<Opportunity>();
            for (List<String> s : csv_obj.lines){
                String oppUnique = String.valueOf(s[0]);
                Opportunity o = mapOpps.get(oppUnique);
                if (o == null){                    
                    o = new Opportunity();
                    o.Name = 'TMP';
                    o.Stagename = 'Aprobada'; 
                    o.CloseDate = System.today(); 
                    o.RecordTypeId = rt_Estim; 
                    o.AccountId = String.valueOf(s[0]); 
                    o.Safra__c = safra; 
                    o.Marca__c = 'BRMX'; 
                    o.Mes__c = mes; 
                    o.Activa__c = true;
                    createOpps.add(o);
                    mapOpps.put(oppUnique, o);
                }                                    
            }
            
            insert createOpps;
            
            List<OpportunityLineItem> items = new List<OpportunityLineItem>();
            for (List<String> s : csv_obj.lines){
                String oppUnique = String.valueOf(s[0]);
                Opportunity o = mapOpps.get(oppUnique);
                OpportunityLineItem i = new OpportunityLineItem();
                i.opportunityId = o.id;
                i.quantity = Double.valueOf(s[2]);
                i.Estimativa__c = Double.valueOf(s[2]);
                i.pricebookentryid = rpb.get(String.valueOf(s[1])).Id;
                i.unitprice = 0.01;      
                i.Tipo_Registro__c = 'Estimativa de faturamento';          
                items.add(i);                                     
            }
            
            insert items;
            
            Map<String, CRM_Multiplicador__c> mapMultCRM = New Map<String, CRM_Multiplicador__c>();
            for (CRM_Multiplicador__c crm : [Select Id, Cuenta__c, BR_Estim_Cumple_CRM__c, BR_Estim_Cumple_Emplacamentos__c, BR_Estim_Cumple_LxL__c, BR_Estim_Cumple_Palestras_Treinamentos__c, BR_Estim_Cumple_Stock_Mult__c From CRM_Multiplicador__c Where Safra__c =: safra])
                mapMultCRM.put(crm.Cuenta__c, crm);
                
            for (List<String> s : csv_obj.lines){
                if (mapMultCRM.containsKey(String.valueOf(s[0]))){
                    CRM_Multiplicador__c crm2 = mapMultCRM.get(String.valueOf(s[0]));
                    crm2.BR_Estim_Cumple_LxL__c = false;
                    if (Integer.valueOf(s[3]) == 1)
                        crm2.BR_Estim_Cumple_LxL__c = true;
                    crm2.BR_Estim_Cumple_Emplacamentos__c = false;
                    if (Integer.valueOf(s[4]) == 1)
                        crm2.BR_Estim_Cumple_Emplacamentos__c = true;
                    crm2.BR_Estim_Cumple_Palestras_treinamentos__c = false;
                    if (Integer.valueOf(s[5]) == 1)
                        crm2.BR_Estim_Cumple_Palestras_treinamentos__c = true;
                    crm2.BR_Estim_Cumple_CRM__c = false;
                    if (Integer.valueOf(s[6]) == 1)
                        crm2.BR_Estim_Cumple_CRM__c = true;
                    crm2.BR_Estim_Cumple_Stock_Mult__c = false;
                    if (Integer.valueOf(s[7]) == 1)
                        crm2.BR_Estim_Cumple_Stock_Mult__c = true;
                }
            }
            
            if (mapMultCRM.size() > 0)
                update mapMultCRM.values();            
                            
         }catch(Exception e){  
            Database.rollback(sp);          
            return 'ERRO ' + e.getMessage() + e.getLineNumber();
         }
                
         return 'Dados importados com sucesso.';
        
    }

}
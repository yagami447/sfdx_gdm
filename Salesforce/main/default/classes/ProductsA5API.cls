/**
* @name ProductsA5API
* @author Jhonny Peroza
* updated 06-10-2021
* updated 03/01/2022 by Developer: Pablo Fraquia pablo.fraquia@cloudgaia.com
*/
@RestResource(urlMapping='/ProductsA5API/*')
global with sharing class ProductsA5API {
    
    @HttpGet
    global static void getProductsForAnexosV() {
        
        Id accountId = RestContext.request.params.get('accountId');
        String marca = RestContext.request.params.get('marca');
        String safra = RestContext.request.params.get('safra');
        
        RestResponse response = RestContext.response;
        response.statusCode = 404;
        
        Response result = new Response();
        result.status = false;
        
        try {
            //Las variedad de Anexos 3 y Anexos 4 son iguales por lo que traemos anexos3 tal y como lo hace la logica legacy
            List<Opportunity> anexos3List = aAppManager.getAnexos3(accountId, safra, marca);
            
            if(!anexos3List.isEmpty()){
                
                Map<Id,List<aAppendix.myOppItem>> productsByOpp = new Map<Id,List<aAppendix.myOppItem>>();

                
                for(Opportunity opp: anexos3List){
                    
                    List<OpportunityLineItem> oppLineItemsList = aAppManager.getAnexosItemsByOpp(opp.Id);
                    List<aAppendix.myOppItem> itemsbyOpp = oppLineItemJSONConverter(oppLineItemsList, getTotalSacasDisponibles(accountId, safra, marca));
                    
                    if(!itemsbyOpp.isEmpty()) {
                        productsByOpp.put(opp.Id, itemsbyOpp);
                    }
                }

                result.message = Label.ProductsA5API_Success_Message;
                result.productsToShow = productsByOpp;
                                
            } else {
                
                result.message = Label.ProductsA5API_Default_Error_Message;
            }

            result.status = true;
            response.statusCode = 200;
            
        } catch (Exception e) {
            
            result.message = e.getMessage();
        }
        
        response.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    public Static Map<String, Double> getTotalSacasDisponibles(Id accountId, String safra, String marca){
          
        Map<String, Double> sacasDispByVariedad = new Map<String, Double>();
    
            String queryPlus = 'PricebookEntry.Product2.Variedade__c, Categoria__r.Name, Opportunity.Name';           
            List<OpportunityLineItem> oppLineItemsListA3A4 = aSiteUtils.queryResults6(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.RecordType.DeveloperName in :v1', new String[]{'Anexo_III', 'Anexo_IV'}, 'Opportunity.Safra__c = :v2', safra, 'Opportunity.Marca__c = :v3', marca, 'Opportunity.AccountId = :v4', accountId, 'Item_Rebajado__c = :v5', false, 'Opportunity.Estado_Anexos_Portal_Miltiplicadores__c != :v6', 'Anulado');
            if(!oppLineItemsListA3A4.isEmpty()) {
                
                for (OpportunityLineItem producto : oppLineItemsListA3A4){
                    
                    if(producto.Semente_comercializada__c == null){
                        producto.Semente_comercializada__c = 0;
                    }
                    if(producto.Semente_uso_propio__c == null){
                        producto.Semente_uso_propio__c = 0;
                    }
                    
                    if (!sacasDispByVariedad.containsKey(String.valueOf(producto.PricebookEntry.Product2.Variedade__c))){
                        
                        sacasDispByVariedad.put(String.valueOf(producto.PricebookEntry.Product2.Variedade__c), Double.valueOf(producto.Semente_comercializada__c) + Double.valueOf(producto.Semente_uso_propio__c));
                        
                    } else{
                        
                        Double sacasDisponibles = sacasDispByVariedad.get(String.valueOf(producto.PricebookEntry.Product2.Variedade__c));
                        sacasDisponibles += Double.valueOf(producto.Semente_comercializada__c) + Double.valueOf(producto.Semente_uso_propio__c);
                        sacasDispByVariedad.remove(String.valueOf(producto.PricebookEntry.Product2.Variedade__c));
                        sacasDispByVariedad.put(String.valueOf(producto.PricebookEntry.Product2.Variedade__c), sacasDisponibles);                       
                    }                  
                }
            }
       
        return sacasDispByVariedad;
    }
    
    public static List<aAppendix.myOppItem> oppLineItemJSONConverter(List<OpportunityLineItem> oppLineItemsList,  Map<String, Double> sacasDispByVariedad) {
        
        List<aAppendix.myOppItem> result = new List<aAppendix.myOppItem>();
        
        for(OpportunityLineItem oppLineItem : oppLineItemsList){
            aAppendix.myOppItem oli = new aAppendix.myOppItem();
            oli.variedad = oppLineItem.PricebookEntry.Product2.Variedade__c;
            oli.variedad_nombre = oppLineItem.Variedade_Prod__c;
            oli.variedad_registro = oppLineItem.Variedad_de_Produto__c;
            oli.registro = oppLineItem.Registro_Cultivar__c;
            oli.sem_comerci = oppLineItem.Semente_comercializada__c;
            oli.estado_comer = oppLineItem.Estado_de_Comercializacion__c;
            oli.categoria = oppLineItem.Categoria__r.Name;
            oli.categoria_id = oppLineItem.Categoria__c;
            oli.area_autorizada = String.valueOf(oppLineItem.Area__c);
            oli.area_plantada = String.valueOf(oppLineItem.Area_plantada__c);
            oli.sem_bruta = String.valueOf(oppLineItem.Semente_bruta__c);                
            oli.descarte = String.valueOf(oppLineItem.Descarte__c);
            oli.sem_beneficiada = String.valueOf(oppLineItem.Semente_beneficiada__c);                
            oli.sem_aprobada = String.valueOf(oppLineItem.Semente_aprovada__c);
            oli.sem_uso_propio = String.valueOf(oppLineItem.Semente_uso_propio__c);  
            oli.unidadDescarte = Integer.valueOf(oppLineItem.Descarte__c);
            oli.amount = Double.valueOf(oppLineItem.TotalPrice);
            oli.sacas_disponibles = String.valueOf(sacasDispByVariedad.get(oppLineItem.PricebookEntry.Product2.Variedade__c));
            
            result.add(oli);
        }
        
        return result;
    }
    
    public class Response {
        
        public Boolean status;
        public String message;
        public Map<Id,List<aAppendix.myOppItem>> productsToShow = new Map<Id,List<aAppendix.myOppItem>>();
    }
}
@RestResource(urlMapping='/ProductsA4API/*')
global with sharing class ProductsA4API {
 
    public class Response {
        public Boolean status;
        public String message;
        public List<aAppendix.myOppItem> productsA4 = new List<aAppendix.myOppItem>();
    }

    @HttpGet
    global static void getProductsAppendix4() {

        String accountId = RestContext.request.params.get('accountId');
        String safra = RestContext.request.params.get('safra');
        String marca = RestContext.request.params.get('marca');

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        Response result = new Response();
        result.status = false;
        result.message = Label.Anexo_IV_Val_Existe_Anexo_III;
        
        try {
            List<OpportunityLineItem> tmpOppItems = aAppManager.getAnexosItemsToA4(accountId, safra, marca); 
            tmpOppItems = valAnexos4_A(tmpOppItems);
            tmpOppItems = getSacasDescarteValues(accountId, safra, marca, tmpOppItems);

            result.productsA4 = oppLineItemJSONConverter(tmpOppItems);
  
        } catch (Exception exc) {
            response.statusCode = 400;
            result.message = exc.getMessage();
        }
                
        if(result.productsA4 != null && !result.productsA4.isEmpty()) {
            result.status = true;
            result.message = Label.ProductsA4API_Success_Message;
            response.statusCode = 200;
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }

    public static List<aAppendix.myOppItem> oppLineItemJSONConverter(List<OpportunityLineItem> oppLineItems) {

        
        List<aAppendix.myOppItem> result = new List<aAppendix.myOppItem>();
        
        for(OpportunityLineItem oppLineItem : oppLineItems){
            
            aAppendix.myOppItem oli = new aAppendix.myOppItem();
            oli.variedad = oppLineItem.PricebookEntry.Product2.Variedade__c;
            oli.variedad_nombre = oppLineItem.Variedade_Prod__c;
            oli.variedad_registro = oppLineItem.Variedad_de_Produto__c;
            oli.categoria = oppLineItem.Categoria__r.Name;
            oli.categoria_id = oppLineItem.Categoria__c;

            if(oppLineItem.Semente_bruta__c != null) {
                
                oli.sem_bruta_A2 = String.valueOf(oppLineItem.Semente_bruta__c);
                oli.sem_bruta = String.valueOf(oppLineItem.Semente_bruta__c);
            } 

            if(oppLineItem.Semente_beneficiada__c != null) {

                oli.sem_beneficiada = String.valueOf(oppLineItem.Semente_beneficiada__c);                
            } 

            if(oppLineItem.Semente_aprovada__c != null) {
                oli.sem_aprobada = String.valueOf(oppLineItem.Semente_aprovada__c);
                oli.sem_disponibles = Decimal.valueOf(oli.sem_aprobada);
            }
            if(oppLineItem.Semente_comercializada__c != null) {
                oli.sem_comer = String.valueOf(oppLineItem.Semente_comercializada__c);
            } 
            if(oppLineItem.Semente_uso_propio__c != null) {
                oli.sem_uso_propio = String.valueOf(oppLineItem.Semente_uso_propio__c);
         }          
            if(oppLineItem.Descarte__c != null) {
                oli.descarte = String.valueOf(oppLineItem.Descarte__c);  
            } 
            if(oppLineItem.Quantidade__c != null) {
                oli.sem_comer_up_aIII = String.valueOf(oppLineItem.Quantidade__c);
            } 

            result.add(oli);
        }
        
        return result;
    }


    //Validacion A, anexos IV
    public static List<OpportunityLineItem> valAnexos4_A(List<OpportunityLineItem> items){
        try{
            Map<String, OpportunityLineItem> mapOppApp1 = new Map<String, OpportunityLineItem>();

            for (OpportunityLineItem s : items){

                if (!mapOppApp1.containsKey(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c))){
                    mapOppApp1.put(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c), s);

                } else{
 
                    OpportunityLineItem oli = mapOppApp1.get(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));

                    if (oli != null){

                        if (s.Semente_comercializada__c == null)
                            s.Semente_comercializada__c = 0;
                        if (oli.Semente_comercializada__c == null)
                            oli.Semente_comercializada__c = 0;
                        oli.Semente_comercializada__c = oli.Semente_comercializada__c + s.Semente_comercializada__c;

                        if (s.Semente_uso_propio__c == null)
                            s.Semente_uso_propio__c = 0;
                        if (oli.Semente_uso_propio__c == null)
                            oli.Semente_uso_propio__c = 0;
                        oli.Semente_uso_propio__c = oli.Semente_uso_propio__c + s.Semente_uso_propio__c;
                    }
                }
            }

            for (OpportunityLineItem s : mapOppApp1.values()){
                if (s.Semente_aprovada__c == null)
                    s.Semente_aprovada__c = 0;
                if (s.Semente_comercializada__c == null)
                    s.Semente_comercializada__c = 0;
                if (s.Semente_uso_propio__c == null)
                    s.Semente_uso_propio__c = 0;

                s.Quantidade__c = s.Semente_comercializada__c + s.Semente_uso_propio__c;
            }

            return mapOppApp1.values();
        } catch (Exception e){
            return null;
        }
    }

    // Calcula el valor de "Descarte(Sacas)" (Descarte__c) para cada combinación de Variedad y Categoría
    public static List<OpportunityLineItem> getSacasDescarteValues(String accountId, String safra, String marca, List<OpportunityLineItem> oppLineItems) { 

        Map<String, Map<String, Double>> descarteByVariedadAndCategoria = getMapDescarteByVariedadAndCategoria(accountId, safra, marca);

        for(OpportunityLineItem oppLineItem : oppLineItems){
            String variedad = oppLineItem.PricebookEntry.Product2.Variedade__c;
            String categoria = oppLineItem.Categoria__c;
            if(descarteByVariedadAndCategoria.containsKey(variedad) 
                    && descarteByVariedadAndCategoria.get(variedad).containsKey(categoria)){
                oppLineItem.Descarte__c = descarteByVariedadAndCategoria.get(variedad).get(categoria);
            }
        }

        return oppLineItems;

    }

     // Obtiene el Mapa de Sacas Descarte segun Variedad y Categoria
     public static Map<String, Map<String, Double>> getMapDescarteByVariedadAndCategoria(String accountId, String safra, String marca) { 

        List<OpportunityLineItem> descarteProducts =    [SELECT Id, Variedade_Prod__c, Variedad_de_Produto__c, Categoria__c, Categoria__r.Name, 
                                                                PricebookEntry.Product2.Variedade__c, Quantity, Unidade_descarte__c
                                                        FROM OpportunityLineItem
                                                        WHERE Opportunity.RecordType.Name = 'Descarte'
                                                            AND Opportunity.AccountId = :accountId
                                                            AND Opportunity.Safra__c = :safra
                                                            AND Opportunity.Marca__c = :marca
                                                            AND Opportunity.StageName = 'Aprobada'];

        Map<String, Map<String, Double>> descarteByVariedadAndCategoria = new Map<String, Map<String, Double>>();
        
        for(OpportunityLineItem oppLineItem : descarteProducts) {
            String variedad = oppLineItem.PricebookEntry.Product2.Variedade__c;
            String categoria = oppLineItem.Categoria__c;
            Double sacasDescarte = 0;
            Decimal tempDecimalValue;
            if(oppLineItem.Quantity != null && oppLineItem.Unidade_descarte__c != ''){  
                Integer unidadDescarte = ProductsDescarteAPI.MAPNAMEBYUNIDAD.get(oppLineItem.Unidade_descarte__c);

                sacasDescarte = Double.valueOf((oppLineItem.Quantity * unidadDescarte) / 40);
                tempDecimalValue = Decimal.ValueOf(sacasDescarte);
                tempDecimalValue = tempDecimalValue.setScale(2);
                sacasDescarte = Double.ValueOf(tempDecimalValue);

            }
            Map<String, Double> sacasByCategoria = new Map<String, Double>();

            if(descarteByVariedadAndCategoria.containsKey(variedad)){
                if(descarteByVariedadAndCategoria.get(variedad).containsKey(categoria)){

                    Double sacas = descarteByVariedadAndCategoria.get(variedad).get(categoria) + sacasDescarte;
                    tempDecimalValue = Decimal.ValueOf(sacas);
                    tempDecimalValue = tempDecimalValue.setScale(2);
                    sacas = Double.ValueOf(tempDecimalValue);

                    descarteByVariedadAndCategoria.get(variedad).put(categoria, sacas);
                } else {
                    sacasByCategoria.put(categoria, sacasDescarte);
                    descarteByVariedadAndCategoria.get(variedad).put(categoria, sacasDescarte);
                }
            } else {
                sacasByCategoria.put(categoria, sacasDescarte);
                descarteByVariedadAndCategoria.put(variedad, sacasByCategoria);
            }
        }

        return descarteByVariedadAndCategoria;
    }
}
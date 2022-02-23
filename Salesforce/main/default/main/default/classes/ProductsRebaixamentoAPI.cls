@RestResource(urlMapping='/ProductsRebaixamentoAPI/*')
global with sharing class ProductsRebaixamentoAPI {
    
        public class response {
            
            public Boolean status;
            public String message;
            public List<ProductoRebajado> products = new List<ProductoRebajado>();
            public Map<String, String> mapCategorias;
        }
    
        @HttpGet
        global static void getDataAppendix2Rebaixamento() {
    
            String opportunityId = RestContext.request.params.get('opportunityId');
            
            RestResponse response = RestContext.response;
            response.statusCode = 404;
    
            response result = new response();
            result.status = false;
            result.message = Label.Anexo_III_Val_Existe_Anexo_II;
            List<OpportunityLineItem>  productosReb;

            try {
                
                Map<String, String> mapCategorias = new Map<String, String>();
                List<Categoria__c> categorias = aAppManager.getCategorias(); 
                if (categorias != null){
                    for (Categoria__c c : categorias){
                        mapCategorias.put(c.Id, c.Name); 
                    }
                }    

                result.mapCategorias = mapCategorias;
                productosReb = aAppManager.getAnexosItemsByOpp(opportunityId);
                result.products = parseProductos(productosReb);
                Map<String, String> mapQuantities = calculateQuantities(opportunityId);
                result.products = setQuantitiesByVariedadAndCategoria(result.products, mapQuantities);
    
            } catch (Exception exc) {
                
                response.statusCode = 400;
                result.message = exc.getMessage();
            }
                    
            if(result.products != null && !result.products.isEmpty()) {
                
                result.status = true;
                result.message = Label.ProductsRebaixamentoAPI_Success_Message;
                response.statusCode = 200;
            }
    
            response.responseBody = Blob.valueOf(JSON.serialize(result));
            response.headers.put('Content-Type', 'application/json');
            response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');           
        }

        private static List<ProductoRebajado> parseProductos(List<OpportunityLineItem> productosReb){

            List<ProductoRebajado> productos = new List<ProductoRebajado>();

            for (OpportunityLineItem prod : productosReb) {

                ProductoRebajado prodRebajado = new ProductoRebajado();

                prodRebajado.nombreComercial = prod.Variedade_Prod__c;
                prodRebajado.registroCultivar = prod.Variedad_de_Produto__c;
                prodRebajado.categoria = prod.Categoria__r.Name;
                prodRebajado.categoriaPlantada = prod.Categoria_Prod__c;
                prodRebajado.semRebaixada = prod.Sem_Rebajada__c;
                prodRebajado.lote = prod.Lote_Rebajado__c;
                prodRebajado.haPlantados =  prod.Area_plantada__c;
                prodRebajado.semBruta = prod.Semente_bruta__c; 
                prodRebajado.descarte = prod.Descarte__c;
                prodRebajado.variedad = prod.PricebookEntry.Product2.Variedade__c;
                prodRebajado.variedad_nombre = prod.Variedade_Prod__c;
                prodRebajado.variedad_registro = prod.PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c;
                prodRebajado.categoria_id = prod.Categoria__c;

                productos.add(prodRebajado);
            }

            return productos;
        }

        private static Map<String, String> calculateQuantities(String opportunityId) {

            Opportunity oppA2 = [SELECT Id, AccountId, Marca__c, Safra__c, Epoca_de_Plantio__c FROM Opportunity WHERE Id = :opportunityId];

            String epocaPlantioAII = oppA2.Epoca_de_Plantio__c;
            String marca = oppA2.Marca__c;
            String safra = oppA2.Safra__c;
            String accountId = oppA2.AccountId;
    
            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();

            String queryPlus = 'PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, Categoria__r.Name, Opportunity.Epoca_de_Plantio__c, Opportunity.Name, Opportunity.RecordType.DeveloperName';
    
            tmpOppItems = aSiteUtils.queryResults6(OpportunityLineItem.SObjectType, queryPlus, 
                                                    'Opportunity.RecordType.DeveloperName in :v1', new String[]{'AnexoII', 'Anexo_II_Rebaixamento_Sacas'}, 
                                                    'Opportunity.Safra__c = :v2', safra, 
                                                    'Opportunity.Marca__c = :v3', marca, 
                                                    'Opportunity.AccountId = :v4', accountId, 
                                                    'Item_Rebajado__c = :v5', false, 
                                                    'Opportunity.StageName in :v6', new String[] {'Aprobada', 'AU - Autorizada'});      

            Map<String, Double> mapCantidades = new Map<String, Double>();
            Map<String, Double> mapRebajamientos = new Map<String, Double>();

            for (OpportunityLineItem s : tmpOppItems){

                if (s.Opportunity.Epoca_de_Plantio__c == epocaPlantioAII){

                    if (s.Opportunity.RecordType.DeveloperName == 'AnexoII'){
           
                        if (!mapCantidades.containsKey(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.Categoria__c))){
                            mapCantidades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.Categoria__c), s.Semente_bruta__c);

                        } else{

                            Double cant = mapCantidades.get(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.Categoria__c));
                            cant += s.Semente_bruta__c;
                            mapCantidades.remove(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.Categoria__c));
                            mapCantidades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.Categoria__c),cant);
                        }
                    }

                    if (s.Opportunity.RecordType.DeveloperName == 'Anexo_II_Rebaixamento_Sacas'){
  
                        if (!mapRebajamientos.containsKey(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.Categoria_a_Rebaixar__c))){
                            mapRebajamientos.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.Categoria_a_Rebaixar__c), s.Sem_Rebajada__c);

                        } else {

                                Double cant = mapRebajamientos.get(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.Categoria_a_Rebaixar__c));
                                cant += s.Sem_Rebajada__c;
                                mapRebajamientos.remove(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.Categoria_a_Rebaixar__c));
                                mapRebajamientos.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.Categoria_a_Rebaixar__c),cant);
                            }
                        }
                }
            }

            Map<String,String> result = new Map<String,String>();
            for(String key : mapCantidades.KeySet()){
                if(mapCantidades.containsKey(key) && mapRebajamientos.containsKey(key)) {
                    Double cantidad = mapCantidades.get(key) - mapRebajamientos.get(key);
                    result.put(key, String.valueof(cantidad));
                } else if (mapCantidades.containsKey(key)) {
                    result.put(key, String.valueOf(mapCantidades.get(key)));
                }
            }
            return(result);
        }

        private static List<ProductoRebajado> setQuantitiesByVariedadAndCategoria(List<ProductoRebajado> productList, Map<String, String> mapQuantities) {

            for(ProductoRebajado product : productList)  {
                if (mapQuantities.containsKey(product.variedad + product.categoria_id)){
 
                    product.sacasDisponibles = mapQuantities.get(product.variedad + product.categoria_id);
                }
            }
 
            return productList;            
        }

        public class ProductoRebajado {
            public String nombreComercial;
            public String registroCultivar;
            public String categoria;
            public String categoria_id;
            public String categoriaPlantada;
            public double semRebaixada;
            public String lote;
            public double haPlantados;
            public double semBruta;
            public double descarte;
            public String variedad;
            public String variedad_nombre;
            public String variedad_registro;
            public String sacasDisponibles;
        }
    }
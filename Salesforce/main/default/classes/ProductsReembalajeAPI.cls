@RestResource(urlMapping='/ProductsReembalajeAPI/*')
global with sharing class ProductsReembalajeAPI {

    public static final String REEMBALAJERECTYPE = 'Reembalagem';                                                                    

    /**
     *  SUBCLASS:       Response
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Products Reembalaje API response. Created for US #13079 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public List<aAppendix.myOppItem> productsReembalaje;
        public Map<String, String> mapVariedadById;
        public Map<String, String> mapRegistroVariedadById;
        public Map<Id, String> mapCategoriaById;
        public Map<String, Set<String>> mapCategoriaByVariedad;
        public Map<String, Set<String>> mapUnidadesByProduct;
        public Map<String, Map<String, Id>> mapProductByVariedadeAndUnidade;       
    }


     /**
     *  METHOD:         getProductsReembalaje 
     *  PARAMETERS:     accountId: Id of an Account record 
     *                  safra  
     *                  marca 
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  productsReembalaje: list of available products for Reembalaje
     *                  mapVariedadById: map of Id - Name pairs for Variedades
     *                  mapCategoriaByVariedad:  map of Variedad Id - List<Categoria Name> pairs
     *  DESCRIPTION:    Return list of products for Reembalaje along with variedad and categoria maps. Created for US #13079 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     **/ 
    @HttpGet
    global static void getProductsReembalaje() {

        String accountId = RestContext.request.params.get('accountId');
        String safra = RestContext.request.params.get('safra');
        String marca = RestContext.request.params.get('marca');

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        Response result = new Response();
        result.status = false;
        result.message = Label.ProductsReembalajeAPI_Default_Error_Message;

        FactoryManejador factory = new FactoryManejador();
        ManejadorReembalagem manejador;

        
        try {

            manejador = (ManejadorReembalagem)factory.devuelveManejador(REEMBALAJERECTYPE, accountId, safra, marca);
            manejador.setearMapas();
            Map<String, String> mapQuantities = calculateQuantities(accountId, safra, marca);
            List<aAppendix.myOppItem> tmpProductsReembalaje = oppLineItemJSONConverter(manejador.listaProductos, manejador);
            result.productsReembalaje = setQuantitiesByVariedadAndUnidade(tmpProductsReembalaje, mapQuantities);
            result.mapVariedadById = manejador.nombreVariedadPorId;
            result.mapCategoriaByVariedad = manejador.categoriasPorVariedad;
            result.mapCategoriaById = getCategoriaByIdMap(manejador);
            result.mapRegistroVariedadById = manejador.nombreRegistroVariedadPorId;
            result.mapUnidadesByProduct = manejador.mapaUnidadesProductos;
            result.mapProductByVariedadeAndUnidade = manejador.productByVariedadeAndUnidade;

        } catch (Exception exc) {
            response.statusCode = 400;
            result.message = exc.getMessage();
        }
                
        if(result.productsReembalaje != null && !result.productsReembalaje.isEmpty()) {
            result.status = true;
            result.message = Label.ProductsReembalajeAPI_Success_Message;
            response.statusCode = 200;
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }


    /**
     *  METHOD:         oppLineItemJSONConverter 
     *  PARAMETERS:     oppLineItems: List of OpportunityLineItems in sObject format 
     *  RETURN:         List<aAppendix.myOppItem>: list of records in JSON format to return
     *  DESCRIPTION:    Helper method converts opportunityLineItem sObject in aAppendix.myOppItem JSON wrapper. Created for US #13079 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     **/ 
    public static List<aAppendix.myOppItem> oppLineItemJSONConverter(List<OpportunityLineItem> oppLineItems, ManejadorReembalagem manejador) {

        List<aAppendix.myOppItem> result = new List<aAppendix.myOppItem>();

        if(oppLineItems != null && oppLineItems.size() > 0) {
            for(OpportunityLineItem oppLineItem : oppLineItems) {
                aAppendix.myOppItem customOli = new aAppendix.myOppItem();
                customOli.variedad = oppLineItem.PricebookEntry.Product2.Variedade__c;
                customOli.variedad_nombre = oppLineItem.Variedade_Prod__c;
                customOli.variedad_registro = manejador.nombreRegistroVariedadPorId.get(oppLineItem.PricebookEntry.Product2.Variedade__c);
                customOli.categoria = oppLineItem.PricebookEntry.Product2.Categ__c;
                customOli.categoria_nombre = oppLineItem.PricebookEntry.Product2.Categ__r.Name;
                customOli.amount = oppLineItem.Quantity;
                customOli.unidade = oppLineItem.PricebookEntry.Product2.UNIDADE__c;
                customOli.lote_rebajado = oppLineItem.Lote_Rebajado__c;
                customOli.categoria_a_rebajar_id = oppLineItem.Categoria_a_Rebaixar__c;
                customOli.sem_bruta = String.valueOf(oppLineItem.Semente_bruta__c);
                customOli.sem_rebajada = String.valueOf(oppLineItem.Sem_Rebajada__c);
                result.add(customOli);
            }
        }

        return result;
    }

    /**
     *  METHOD:         getCategoriaByIdMap 
     *  PARAMETERS:     ManejadorReembalagem: helper manejador class for Reembalaje opps
     *  RETURN:         Map<Id, String>: map of Categoria names by Id
     *  DESCRIPTION:    Helper method converts opportunityLineItem sObject in aAppendix.myOppItem JSON wrapper. Created for US #13079 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     **/     
    public static Map<Id, String> getCategoriaByIdMap(ManejadorReembalagem manejador) {

        Map<Id, String> result = new Map<Id, String>();
        
        for( String variedad : manejador.nombreVariedadPorId.keySet() ) {
            Set<String> categoriesForSelectedVariedad = manejador.categoriasPorVariedad.get(manejador.nombreVariedadPorId.get(variedad));          
            List<Categoria__c> categoriesInDb = aAppManager.getCategorias(); 
            if (!categoriesInDb.isEmpty()) {
                for (Categoria__c tmpCategory : categoriesInDb) {
                    if (categoriesForSelectedVariedad.contains(tmpCategory.Name)) {
                        result.put(tmpCategory.Id, tmpCategory.Name);
                    }
                }
            }
        }
        
        return result;
    }

    public static Map<String, String> calculateQuantities(String accountId, String safra, String marca) {

            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();

            String queryPlus = 'PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, PricebookEntry.Product2.Categ__c, PricebookEntry.Product2.Categ__r.Name, Opportunity.TipoReg__c, Opportunity.Safra__c, Opportunity.Marca__c, Opportunity.AccountId, Opportunity.StageName';
    
            tmpOppItems = aSiteUtils.queryResults5(OpportunityLineItem.SObjectType, queryPlus, 
                                                    'Opportunity.TipoReg__c in :v1', new String[]{'CVB Autorizada', 'Reembalaje'}, 
                                                    'Opportunity.Safra__c = :v2', safra, 
                                                    'Opportunity.Marca__c = :v3', marca, 
                                                    'Opportunity.AccountId = :v4', accountId, 
                                                    'Opportunity.StageName in :v5', new String[] {'Aprobada', 'AU - Autorizada'});

            Map<String, Double> mapCantidades = new Map<String, Double>();
            Map<String, Double> mapReembalajes = new Map<String, Double>();

            for (OpportunityLineItem s : tmpOppItems) {

                if (s.Opportunity.TipoReg__c == 'CVB Autorizada') {
           
                    if (!mapCantidades.containsKey(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.UNIDADE__c) + String.valueOf(s.PricebookEntry.Product2.Categ__c))) {

                            mapCantidades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.UNIDADE__c) + String.valueOf(s.PricebookEntry.Product2.Categ__c), s.Quantity);

                    } else {

                        Double cant = mapCantidades.get(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.UNIDADE__c) + String.valueOf(s.PricebookEntry.Product2.Categ__c));
                        cant += s.Quantity;
                        mapCantidades.remove(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.UNIDADE__c) + String.valueOf(s.PricebookEntry.Product2.Categ__c));
                        mapCantidades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.UNIDADE__c) + String.valueOf(s.PricebookEntry.Product2.Categ__c), cant);
                    }
                }

                if (s.Opportunity.TipoReg__c == 'Reembalaje') {
  
                    if (!mapReembalajes.containsKey(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.UNIDADE__c) + String.valueOf(s.PricebookEntry.Product2.Categ__c))) {

                            mapReembalajes.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.UNIDADE__c) + String.valueOf(s.PricebookEntry.Product2.Categ__c), s.Quantity);

                    } else {

                        Double cant = mapReembalajes.get(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.UNIDADE__c) + String.valueOf(s.PricebookEntry.Product2.Categ__c));
                        cant += s.Quantity;
                        mapReembalajes.remove(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.UNIDADE__c) + String.valueOf(s.PricebookEntry.Product2.Categ__c));
                        mapReembalajes.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c) + String.valueOf(s.UNIDADE__c) + String.valueOf(s.PricebookEntry.Product2.Categ__c), cant);
                    }
                }
            }

            Map<String,String> result = new Map<String,String>();

            for(String key : mapCantidades.KeySet()) {

                if(mapReembalajes.containsKey(key)) {

                    Double cantidad = mapCantidades.get(key) - mapReembalajes.get(key);
                    result.put(key, String.valueof(cantidad));
                }
            }

        return result;
    }

    public static List<aAppendix.myOppItem> setQuantitiesByVariedadAndUnidade(List<aAppendix.myOppItem> productList, Map<String, String> mapQuantities) {

        for(aAppendix.myOppItem product : productList) {
            if (mapQuantities.containsKey(product.variedad + product.unidade + product.categoria)) {
 
                product.sacas_disponibles = mapQuantities.get(product.variedad + product.unidade + product.categoria);
            }
        }
 
        return productList;            
    }  
}
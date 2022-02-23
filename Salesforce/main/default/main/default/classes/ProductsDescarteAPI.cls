@RestResource(urlMapping='/ProductsDescarteAPI/*')
global with sharing class ProductsDescarteAPI {

    public static final String DESCARTERECTYPE = 'Descarte';
    public static final Map<String, Integer> MAPNAMEBYUNIDAD = new Map<String, Integer>{'Quilograma'    => 1,
                                                                                        'Saca 25Kg'     => 25,
                                                                                        'Saca 40Kg'     => 40,
                                                                                        'Tonelada'      => 1000};                                                                        

    /**
     *  SUBCLASS:       Response
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Products Descarte API response. Created for US #13041 
     *  AUTHOR:         irina.benitez@cloudgaia.com (29-sept-21)
     **/ 

    public class Response {
        public Boolean status;
        public String message;
        public List<aAppendix.myOppItem> productsDescarte;
        public Map<String, String> mapVariedadById;
        public Map<String, String> mapRegistroVariedadById;
        public Map<Id, String> mapCategoriaById;
        public Map<String, Set<String>> mapCategoriaByVariedad;
        public Map<Integer, String> mapUnidadByName = new Map<Integer, String>{ 1     => 'Quilograma',
                                                                                25    => 'Saca 25Kg',
                                                                                40    => 'Saca 40Kg',
                                                                                1000  => 'Tonelada'};
    }

     /**
     *  METHOD:         getProductsDescarte 
     *  PARAMETERS:     accountId: Id of an Account record 
     *                  safra  
     *                  marca 
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  productsDescarte: list of available products for Descarte
     *                  mapVariedadById: map of Id - Name pairs for Variedades
     *                  mapCategoriaByVariedad:  map of Variedad Id - List<Categoria Name> pairs
     *  DESCRIPTION:    Return list of products for Descarte along with variedad and categoria maps. Created for US #13041 
     *  AUTHOR:         german.diaz@cloudgaia.com (09-dec-21)
     **/ 
    @HttpGet
    global static void getProductsDescarte() {

        String accountId = RestContext.request.params.get('accountId');
        String safra = RestContext.request.params.get('safra');
        String marca = RestContext.request.params.get('marca');
        String cultura = RestContext.request.params.get('cultura');

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        Response result = new Response();
        result.status = false;
        result.message = Label.ProductsDescarteAPI_Default_Error_Message;

        FactoryManejador factory = new FactoryManejador();
        ManejadorDescarte manejador;

        
        try {

            List<OpportunityLineItem> oppItemsForDescarteCalculation = getProductsForNewDescarte(accountId, marca, safra, cultura);
            if(oppItemsForDescarteCalculation != null && !oppItemsForDescarteCalculation.isEmpty()) {
                List<OpportunityLineItem> anexo3items = new List<OpportunityLineItem>();
                List<OpportunityLineItem> descarteitems = new List<OpportunityLineItem>();
        
                for(OpportunityLineItem product : oppItemsForDescarteCalculation) {
                    if(product.Opportunity.TipoReg__c == 'Anexo III') {
                        anexo3items.add(product);
                    } else if (product.Opportunity.TipoReg__c == 'Descarte') {
                        descarteitems.add(product);
                    }
                }
                Map<String, Map<String, Double>> sacasDisponibles = getSacasDisponibles(anexo3items, descarteItems);
    
                result.productsDescarte = oppLineItemJSONConverter(anexo3items, sacasDisponibles);
                completeMapValues(result, anexo3items);
                result.mapCategoriaById = getCategoriaByIdMap(result);
            } else {
                result.message = Label.Anexo_IV_Val_Existe_Anexo_III;
            }


        } catch (Exception exc) {
            response.statusCode = 400;
            result.message = exc.getMessage();
        }
                
        if(result.productsDescarte != null && !result.productsDescarte.isEmpty()) {
            result.status = true;
            result.message = Label.ProductsDescarteAPI_Success_Message;
            response.statusCode = 200;
        }

        System.debug('result: ' + result);
        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }


    /**
     *  METHOD:         oppLineItemJSONConverter 
     *  PARAMETERS:     oppLineItems: List of OpportunityLineItems in sObject format 
     *  RETURN:         List<aAppendix.myOppItem>: list of records in JSON format to return
     *  DESCRIPTION:    Helper method converts opportunityLineItem sObject in aAppendix.myOppItem JSON wrapper. Created for US #13041 
     *  AUTHOR:         irina.benitez@cloudgaia.com (29-sept-21)
     * TO DELETE AFTER CHANGES 
     **/ 
    public static List<aAppendix.myOppItem> oppLineItemJSONConverter(List<OpportunityLineItem> oppLineItems, Map<String, Map<String, Double>> sacasDisponibles) {

        List<aAppendix.myOppItem> result = new List<aAppendix.myOppItem>();

        if(oppLineItems != null && oppLineItems.size() > 0) {

            for(OpportunityLineItem oppLineItem : oppLineItems){

                String variedad = oppLineItem.PricebookEntry.Product2.Variedade__c;
                String categoria = oppLineItem.Categoria__c;
                Double semDisponibles = sacasDisponibles.get(variedad).get(categoria);

                aAppendix.myOppItem customOli = new aAppendix.myOppItem();
                customOli.variedad = oppLineItem.PricebookEntry.Product2.Variedade__c;
                customOli.variedad_nombre = oppLineItem.Variedade_Prod__c;
                customOli.variedad_registro = oppLineItem.PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c;
                customOli.categoria = oppLineItem.Categoria__c;
                customOli.categoria_nombre = oppLineItem.Categoria__r.Name;
                customOli.amount = oppLineItem.Quantity;
                customOli.unidadDescarte = MAPNAMEBYUNIDAD.get(oppLineItem.Unidade_descarte__c);
                customOli.unidade = oppLineItem.Unidade_descarte__c;
                customOli.unidade_nombre = oppLineItem.Unidade_descarte__c;
                customOli.lote_rebajado = oppLineItem.Lote_Rebajado__c;
                customOli.categoria_a_rebajar_id = oppLineItem.Categoria_a_Rebaixar__c;
                customOli.sem_bruta = String.valueOf(oppLineItem.Semente_bruta__c);
                customOli.sem_bruta_A2 = String.valueOf(oppLineItem.Semente_bruta__c);
                customOli.sem_rebajada = String.valueOf(oppLineItem.Sem_Rebajada__c);
                CustomOli.sem_disponibles = semDisponibles;
                result.add(customOli);
            }
        }

        return result;
    }

    /**
     *  METHOD:         completeMapValues 
     *  PARAMETERS:     Response
     *  RETURN:         -
     *  DESCRIPTION:    Loops productsDescarte and completes response maps for Variedad and Categoria 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-jan-22)
     **/     
    public static void completeMapValues(Response resp, List<OpportunityLineItem> productList) {

        resp.mapVariedadById = new Map<String, String>();
        resp.mapRegistroVariedadById = new Map<String, String>();
        resp.mapCategoriaByVariedad = new Map<String, Set<String>>();
        Map<Id, String> tmpVarietyNameById = new Map<Id, String>();

        if(!productList.isEmpty()) {
            for(OpportunityLineItem oppItem : productList){
                String tmpVarietyId = oppItem.PricebookEntry.Product2.Variedade__c;
                String tmpVarietyName = oppItem.PricebookEntry.Product2.Variedade__r.Name;
                String tmpVarietyRegisterName = oppItem.PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c;
                String tmpCategoryName = oppItem.Categoria__r.Name;

                if (!tmpvarietyNameById.containsKey(tmpVarietyId)) { 

                    Set<String> categoriesForVariety  = new Set<String>();

                    categoriesForVariety.add(tmpCategoryName);
                    resp.mapCategoriaByVariedad.put(tmpVarietyName, categoriesForVariety);
                    tmpvarietyNameById.put(tmpVarietyId, tmpVarietyName);
                    resp.mapRegistroVariedadById.put(tmpVarietyId, tmpVarietyRegisterName);                 
                    resp.mapVariedadById.put(tmpVarietyId, tmpVarietyName);
                } else {
                    Set<String> categoriesForVariety = resp.mapCategoriaByVariedad.get(tmpVarietyName);
                    if (!categoriesForVariety.contains(tmpCategoryName)) {
                        categoriesForVariety.add(tmpCategoryName);
                    }
                }  
            }
        }

    }


    /**
     *  METHOD:         getCategoriaByIdMap 
     *  PARAMETERS:     Response
     *  RETURN:         Map<Id, String>: map of Categoria names by Id
     *  DESCRIPTION:    Helper method converts opportunityLineItem sObject in aAppendix.myOppItem JSON wrapper. Created for US #13041 
     *  AUTHOR:         irina.benitez@cloudgaia.com (29-sept-21)
     * TO DELETE AFTER CHANGES
     **/     
    public static Map<Id, String> getCategoriaByIdMap(Response resp) {

        Map<Id, String> result = new Map<Id, String>();
        
        for( String variedad : resp.mapVariedadById.keySet() ) {
            Set<String> categoriesForSelectedVariedad = resp.mapCategoriaByVariedad.get(resp.mapVariedadById.get(variedad));          
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

    /**
     *  METHOD:         getProductsForNewDescarte 
     *  PARAMETERS:     accountId
     *                  marca
     *                  safra
     *                  cultura
     *  RETURN:         List<OpportunityLineItem>: list of available products for a new descarte
     *  DESCRIPTION:    Queries products for approved Anexo III & Descarte opps for same accountId, marca, safra and cultura. Created for US #19174 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-jan-22)
     **/     
    public static List<OpportunityLineItem> getProductsForNewDescarte(String accountId, String marca, String safra, String cultura) {

        String queryPlus = 'PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, ' +
            'PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c, PricebookEntry.Product2.UNIDADE__c, ' +
            'PriceBookEntry.Product2.Categ__c, Categoria__r.Name, Opportunity.TipoReg__c, Categoria_a_Rebaixar__r.Name, ' +
            'PriceBookEntry.PriceBook2Id, PricebookEntry.Product2.Variedad__c, Variedad__r.Name, Estado_de_Produccion__r.Name';

        List<OpportunityLineItem> oppItems = aSiteUtils.queryResults6(  OpportunityLineItem.SObjectType, queryPlus,
                                                                        'Opportunity.AccountId = :v1', accountId, 
                                                                        'Opportunity.TipoReg__c in :v2', new String[] {'Anexo III', 'Descarte'},
                                                                        'Opportunity.Safra__c = :v3', safra,
                                                                        'Opportunity.Marca__c = :v4', marca,
                                                                        'Opportunity.Cultura__c = :v5', cultura,
                                                                        'Opportunity.StageName in :v6', new String[] {'Aprobada', 'AU - Autorizada'}
                                                                    );
        return oppItems;   
    }
    
    
    /**
     *  METHOD:         getMapA3SacasDisponibles 
     *  PARAMETERS:     List<OpportunityLineItem>: list of anexo III products to process
     *  RETURN:         Map< String, Map <String, Double>>: map with quantities by Variedad and Categoria
     *  DESCRIPTION:    Loop products for approved Anexo III  to determine Sacas Disponibles A3. Created for US #19174 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-jan-22)
     **/    
    public static Map<String, Map<String,Double>> getSacasDisponibles(List<OpportunityLineItem> anexo3items, List<OpportunityLineItem> descarteItems) {
        Map<String, Map<String,Double>> sacasDisponibles = getMapA3SacasDisponibles(anexo3items);
        sacasDisponibles = processDescarteProducts(sacasDisponibles, descarteItems);
        return sacasDisponibles;
    }

    /**
     *  METHOD:         getMapA3SacasDisponibles 
     *  PARAMETERS:     List<OpportunityLineItem>: list of anexo III products to process
     *  RETURN:         Map< String, Map <String, Double>>: map with quantities by Variedad and Categoria
     *  DESCRIPTION:    Loop products for approved Anexo III  to determine Sacas Disponibles A3. Created for US #19174 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-jan-22)
     **/     
    public static Map<String, Map<String,Double>> getMapA3SacasDisponibles(List<OpportunityLineItem> anexo3items) {

        Map<String, Map<String,Double>> sacasDisponiblesA3 = new Map<String, Map<String, Double>>();

        for(OpportunityLineItem oppItem : anexo3items) {
            String variedad = oppItem.PricebookEntry.Product2.Variedade__c;
            String categoria = oppItem.Categoria__c;
            Double disponibleSacas = oppItem.Semente_aprovada__c;
            if( !sacasDisponiblesA3.containsKey(variedad) ) {
                Map<String, Double> sacasByCategoria = new Map<String, Double>();
                sacasByCategoria.put(categoria, disponibleSacas);
                sacasDisponiblesA3.put(variedad, sacasByCategoria);
            } else {
                if(sacasDisponiblesA3.get(variedad).containsKey(categoria)) {
                    Double totalDisponible = sacasDisponiblesA3.get(variedad).get(categoria) + disponibleSacas;
                    sacasDisponiblesA3.get(variedad).put(categoria, totalDisponible);
                } else {
                    sacasDisponiblesA3.get(variedad).put(categoria, disponibleSacas);
                }
            }
        }

        return sacasDisponiblesA3;
    }

    /**
     *  METHOD:         processDescarteProducts 
     *  PARAMETERS:     Map<String, Map <String, String>>: map with sacas disponibles for A3 by Variedad and Categoria
     *                  List<OpportunityLineItem>: list of descarte products to process
     *  RETURN:         Map<String, Map <String, String>>: map with sacas disponibles by Variedad and Categoria
     *  DESCRIPTION:    Loop products for Descarte products to determine Sacas Disponibles from A3 map. Created for US #19174 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-jan-22)
     **/     
    public static Map<String, Map<String,Double>> processDescarteProducts(Map<String, Map<String,Double>> sacasDisponiblesA3, List<OpportunityLineItem> descarteItems) {

        Map<String, Map<String,Double>> sacasDisponibles = sacasDisponiblesA3;

        for(OpportunityLineItem oppItem : descarteItems) {
            String variedad = oppItem.PricebookEntry.Product2.Variedade__c;
            String categoria = oppItem.Categoria__c;

            Double descarte = (oppItem.Quantity * MAPNAMEBYUNIDAD.get(oppItem.Unidade_descarte__c)) / 40;

            if( sacasDisponibles.containsKey(variedad) && sacasDisponibles.get(variedad).containsKey(categoria) ) {
                Double cantidadRestante = sacasDisponibles.get(variedad).get(categoria) - descarte;
                sacasDisponibles.get(variedad).put(categoria, cantidadRestante);
            }
        }

        return sacasDisponibles;
    }

}
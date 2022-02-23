@RestResource(urlMapping='/SalvarDescarteAPI/*')
global with sharing class SalvarDescarteAPI {

    public static final String DESCARTERECTYPE = 'Descarte';
    public static final Map<String, String> MAPUNIDADESDESCARTE = new Map<String, String>{  '1'     => 'Quilograma',
                                                                                            '25'    => 'Saca 25Kg',
                                                                                            '40'    => 'Saca 40Kg',
                                                                                            '1000'  => 'Tonelada'};

    /**
     *  SUBCLASS:       Request
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Opportunity Descarte Request body. Created for US #13042 
     *  AUTHOR:         irina.benitez@cloudgaia.com (24-sept-21)
     **/ 
    public class Request {
        public String editId;
        public String accountId;
        public String safra;
        public String marca;
        public String cultura;
        public String userId;
        public String comment;
        public List<aAppendix.myOppItem> itemsToAdd = new List<aAppendix.myOppItem>();
        public Boolean aprobacion = false;
        public List<aAppendix.myOppItem> itemsToRemove = new List<aAppendix.myOppItem>();
    }

    /**
     *  SUBCLASS:       Response
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Save Descarte API response. Created for US #13042 
     *  AUTHOR:         irina.benitez@cloudgaia.com (24-sept-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public String oppDescarteId;
    }

     /**
     *  METHOD:         saveDescarte 
     *  PARAMETERS:     -
     *  REQUEST BODY:   SalvarDescarteAPI.Request
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  oppDescarteId: inserted opportunity Descarte Id
     *  DESCRIPTION:    Inserts/Updates an Opportunity Descarte. Created for US #13042 
     *  AUTHOR:         irina.benitez@cloudgaia.com (24-sept-21)
     **/ 
    @HttpPost
    global static void saveDescarte() {

        String requestString = RestContext.request.requestBody.toString();
        Request requestBody = (Request)JSON.deserialize(requestString, Request.class);

        RestResponse response = RestContext.response;
        response.statusCode = 400; // Default Error: Bad Request

        Response result = new Response();
        result.status = false;
        result.message = Label.SalvarDescarteAPI_Default_Error_Message;

        SiteUser__c logUser = new SiteUser__c(Id = requestBody.userId);
        FactoryManejador factory = new FactoryManejador();
        ManejadorDescarte descarte;
        Opportunity oppDescarte;
        String toApproval;
        
        Savepoint savePoint = Database.setSavepoint(); 

        try {
            System.debug('requestBody: ' + requestBody);
            descarte = (ManejadorDescarte)factory.devuelveManejador(DESCARTERECTYPE, 
                                                                    requestBody.accountId, 
                                                                    requestBody.safra, 
                                                                    requestBody.marca);
            if(requestBody.aprobacion) {
                toApproval = '1';
            }
 
            String fieldValidation = validateRequiredFields(requestBody.itemsToAdd);
            if( !fieldValidation.equals(Label.SalvarDescarteAPI_Success_Message) ) {
                result.message = fieldValidation;
            } else {
                String quantValidation = validateItemQuantityOnSave(requestBody.itemsToAdd, requestBody.accountId, requestBody.marca, requestBody.safra, requestBody.cultura);
                if( !quantValidation.equals(Label.SalvarDescarteAPI_Success_Message) ) {
                    result.message = quantValidation;
                } else {
                    descarte.crearDescarte( toApproval, 
                                            requestBody.editId, 
                                            requestBody.itemsToAdd, 
                                            requestBody.comment, 
                                            requestBody.marca, 
                                            requestBody.accountId, 
                                            requestBody.safra, 
                                            logUser, 
                                            requestBody.itemsToRemove);
                    
                    oppDescarte = [ SELECT Id 
                                    FROM Opportunity 
                                    WHERE RecordType.Name = :DESCARTERECTYPE 
                                    AND Opportunity.AccountId = :requestBody.accountId
                                    AND Opportunity.Marca__c = :requestBody.marca
                                    AND Opportunity.Safra__c = :requestBody.safra
                                    ORDER BY CreatedDate DESC LIMIT 1];

                    result.oppDescarteId = oppDescarte.Id;
                    result.status = true;
                    result.message = Label.SalvarDescarteAPI_Success_Message;
                    response.statusCode = 201; 
                }
            } 
        } catch (Exception exc) {
            result.message = exc.getMessage();
            Database.rollback(savePoint);
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }


    /**
     *  METHOD:         validateRequiredFields 
     *  PARAMETERS:     itemsToAdd: List of new Descarte products to insert/update
     *  RETURN:         String: returns either 'success' or an error message
     *  DESCRIPTION:    Validates that products have required fields. 
     *                  Method adapted from aSiteDescarteController.validateRequiredFields() for US #13042 
     *  AUTHOR:         irina.benitez@cloudgaia.com (28-sept-21)
     **/ 
    public static String validateRequiredFields(List<aAppendix.myOppItem> itemsToAdd) {
        String result = Label.SalvarDescarteAPI_Success_Message;
        String general = 'General';
        Map<String, List<String>> productErrorMap = new Map<String, List<String>>();
        productErrorMap.put( general , new List<String>() );

        for(aAppendix.myOppItem item : itemsToAdd) {

            if(item.categoria == null || item.categoria_nombre == null || item.categoria.isWhitespace() || item.categoria_nombre.isWhitespace()){
                productErrorMap.get(general).add(Label.ErrorCategoria);
            }
            if(item.variedad == null ||  item.variedad_nombre == null || item.variedad.isWhitespace() || item.variedad_nombre.isWhitespace()){
                productErrorMap.get(general).add(Label.ErrorVariedad);
            }

            if(!productErrorMap.get(general).isEmpty()) {
                result = Label.SalvarDescarteAPI_Product_Validation_Error_Message + ' ' + String.join(productErrorMap.get(general), ', ');
                return result;
            } else {

                String itemKey = item.variedad_nombre + ' - ' + item.categoria_nombre;

                if(item.lote_rebajado == null || item.lote_rebajado.isWhitespace()){
                    item.error_lote = Label.ErrorLote;
                    if( productErrorMap.containsKey(itemKey) ) {
                        productErrorMap.get(itemKey).add(Label.ErrorLote);
                    } else {
                        productErrorMap.put( itemKey, new List<String>{Label.ErrorLote} );
                    }
                }
    
                if(item.amount == null || item.amount == 0){
                    item.error_lote = Label.cantidadIgualCero;
                    if( productErrorMap.containsKey(itemKey) ) {
                        productErrorMap.get(itemKey).add(Label.cantidadIgualCero);
                    } else {
                        productErrorMap.put( itemKey, new List<String>{Label.cantidadIgualCero} );
                    }
                }

                if(item.unidade == null || item.unidade_nombre == null || item.unidadDescarte == null || 
                    item.unidadDescarte == 0 || item.unidade.isWhitespace() ||  item.unidade_nombre.isWhitespace()){
                    item.error_lote = Label.SalvarDescarteAPI_Incomplete_Units_Validation_Message;
                    if( productErrorMap.containsKey(itemKey) ) {
                        productErrorMap.get(itemKey).add(Label.SalvarDescarteAPI_Incomplete_Units_Validation_Message);
                    } else {
                        productErrorMap.put( itemKey, new List<String>{Label.SalvarDescarteAPI_Incomplete_Units_Validation_Message} );
                    }
                }

            }

        }
        productErrorMap.remove(general);
        // Process productErrorMap errors
        if( !productErrorMap.keySet().isEmpty() ) {
            result = Label.SalvarDescarteAPI_Product_Validation_Error_Message + ' ';
            
            for( String itemKey : productErrorMap.keySet() ) {
                result = result + itemKey + ': ' + String.join(productErrorMap.get(itemKey), ', ');
            }
            
        }

        return result;
    }
    
    /**
     *  METHOD:         validateItemQuantityOnSave 
     *  PARAMETERS:     itemsToAdd: List of new Descarte products to insert/update
     *                  manejadorDescarte: legacy utility class of managing Descarte opps and Products
     *  RETURN:         String: returns either 'success' or an error message
     *  DESCRIPTION:    Validates product quantity before save. 
     *                  Method adapted from aSiteDescarteController.validateItemQuantityOnSave() for US #13042 
     *  AUTHOR:         irina.benitez@cloudgaia.com (24-sept-21)
     **/ 
    public static String validateItemQuantityOnSave(List<aAppendix.myOppItem> itemsToAdd, String accountId, String marca, String safra, String cultura) {
        String result = Label.SalvarDescarteAPI_Success_Message;

        if(itemsToAdd.size() == 0) { 
            return result;
        }
        Map<String, Double> mapaCantidadDisponible = new Map<String, Double>();
        Map<String, Double> mapaCantidadIngresada = new Map<String, Double>();

        Map<String, Map<String, Double>> amountByCategoriaByVariedad;

        List<OpportunityLineItem> oppItemsForDescarteCalculation = ProductsDescarteAPI.getProductsForNewDescarte(accountId, marca, safra, cultura);
        List<OpportunityLineItem> anexo3items = new List<OpportunityLineItem>();
        List<OpportunityLineItem> descarteitems = new List<OpportunityLineItem>();

        for(OpportunityLineItem product : oppItemsForDescarteCalculation) {
            if(product.Opportunity.TipoReg__c == 'Anexo III') {
                anexo3items.add(product);
            } else if (product.Opportunity.TipoReg__c == 'Descarte') {
                descarteitems.add(product);
            }
        }
        amountByCategoriaByVariedad = ProductsDescarteAPI.getSacasDisponibles(anexo3items, descarteItems);
        for(aAppendix.myOppItem item : itemsToAdd) {

            Map<String, Double> mapaCategoria = amountByCategoriaByVariedad.get(item.variedad);
            Double cantidad = mapaCategoria.get(item.categoria);

            if(!mapaCantidadDisponible.containsKey(item.variedad + '-' + item.categoria + '-' + item.unidade)) {

                mapaCantidadDisponible.put(item.variedad + '-' + item.categoria + '-' + item.unidade, cantidad);
                mapaCantidadIngresada.put(item.variedad + '-' + item.categoria + '-' + item.unidade, 0);

            }

            Double cant = mapaCantidadIngresada.get(item.variedad + '-' + item.categoria + '-' + item.unidade);
            mapaCantidadIngresada.put(item.variedad + '-' + item.categoria + '-' + item.unidade, cant + item.amount );
        }

        for (aAppendix.myOppItem tmpOli : itemsToAdd) {
            Double disponible = mapaCantidadDisponible.get(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade);
            Double enPortal = mapaCantidadIngresada.get(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade);
            if(enPortal > disponible) {
                String errorCant = 'O quantidade total da variedade ' + tmpOli.variedad_nombre + ' categoria ' + tmpOli.categoria_nombre + ' e pela unidade ' + tmpOli.unidade_nombre + ' não deve ser maior que ' + disponible;  //QUANTITY EXCEEDS
                result = errorCant;
                break;
            } else if (disponible <= 0 || enPortal <= 0) {
                    String error = Label.cantidadIgualCero;
                tmpOli.error_msg = error;
                result = 'ERROR Variedade ' + tmpOli.variedad_nombre + ' Categoria ' + tmpOli.categoria_nombre + ': ' + Label.cantidadIgualCero ;
            }
        }
           
        return result; 
    }  
}
@RestResource(urlMapping='/SalvarReembalajeAPI/*')
global with sharing class SalvarReembalajeAPI {

    public static final String REEMBALAJERECTYPE = 'Reembalaje';
    
    /**
     *  SUBCLASS:       Request
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Opportunity Reembalaje Request body. Created for US #13080 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     **/ 
    public class Request {
        public String editId;
        public String accountId;
        public String safra;
        public String marca;
        public String userId;
        public String comment;
        public List<aAppendix.myOppItem> itemsToAdd = new List<aAppendix.myOppItem>();
        public Boolean aprobacion = false;
    }

    /**
     *  SUBCLASS:       Response
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Save Reembalaje API response. Created for US #13080 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public String oppReembalajeId;
    }

     /**
     *  METHOD:         saveReembalaje 
     *  PARAMETERS:     -
     *  REQUEST BODY:   SalvarReembalajeAPI.Request
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  oppReembalajeId: inserted opportunity Reembalaje Id
     *  DESCRIPTION:    Inserts/Updates an Opportunity Reembalaje. Created for US #13080 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     **/ 
    @HttpPost
    global static void saveReembalaje() {

        String requestString = RestContext.request.requestBody.toString();
        Request requestBody = (Request)JSON.deserialize(requestString, Request.class);

        RestResponse response = RestContext.response;
        response.statusCode = 400; // Default Error: Bad Request

        Response result = new Response();
        result.status = false;
        result.message = Label.SalvarReembalajeAPI_Default_Error_Message;

        SiteUser__c logUser = new SiteUser__c(Id = requestBody.userId);
        FactoryManejador factory = new FactoryManejador();
        ManejadorReembalagem reembalaje;
        Opportunity oppReembalaje;
        String toApproval;
        
        Savepoint savePoint = Database.setSavepoint(); 

        try {
            System.debug('requestBody: ' + requestBody);
            reembalaje = (ManejadorReembalagem)factory.devuelveManejador('Reembalagem', 
                                                                    requestBody.accountId, 
                                                                    requestBody.safra, 
                                                                    requestBody.marca);
            
            reembalaje.setearMapas();
            if(requestBody.aprobacion) {
                toApproval = '1';
            }
            String fieldValidation = validateRequiredFields(requestBody.itemsToAdd);
            if( !fieldValidation.equals(Label.SalvarReembalajeAPI_Success_Message) ) {
                result.message = fieldValidation;
            } else {
                String quantValidation = validateItemQuantityOnSave(requestBody.itemsToAdd, reembalaje);
                if( !quantValidation.equals(Label.SalvarReembalajeAPI_Success_Message) ) {
                    result.message = quantValidation;
                } else {
                    if(requestBody.editId != null && requestBody.editId != '') {

                        reembalaje.actualizarReembalagem(   requestBody.itemsToAdd, 
                                                            requestBody.editId, 
                                                            requestBody.marca, 
                                                            requestBody.comment, 
                                                            toApproval);
                    } else {
                        reembalaje.crearReembalagem(requestBody.comment, 
                                                    requestBody.marca, 
                                                    requestBody.accountId, 
                                                    requestBody.safra, 
                                                    logUser, 
                                                    requestBody.itemsToAdd, 
                                                    toApproval);
                    }

                    oppReembalaje = [ SELECT Id 
                                    FROM Opportunity 
                                    WHERE RecordType.Name = :REEMBALAJERECTYPE 
                                    AND Opportunity.AccountId = :requestBody.accountId
                                    AND Opportunity.Marca__c = :requestBody.marca
                                    AND Opportunity.Safra__c = :requestBody.safra
                                    ORDER BY CreatedDate DESC LIMIT 1];

                    result.oppReembalajeId = oppReembalaje.Id;
                    result.status = true;
                    result.message = Label.SalvarReembalajeAPI_Success_Message;
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
     *  PARAMETERS:     itemsToAdd: List of new Reembalaje products to insert/update
     *  RETURN:         String: returns either 'success' or an error message
     *  DESCRIPTION:    Validates that products have required fields. 
     *                  Method adapted from aSiteReembalagemController.validateRequiredFields() for US #13080 
     *  AUTHOR:         irina.benitez@cloudgaia.com (28-sept-21)
     **/ 
    public static String validateRequiredFields(List<aAppendix.myOppItem> itemsToAdd) {

        String result = Label.SalvarReembalajeAPI_Success_Message;
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
                result = Label.SalvarReembalajeAPI_Product_Error_Message + ' ' + String.join(productErrorMap.get(general), ', ');
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

                if(item.unidade == null || item.unidade.isWhitespace()){
                    item.error_lote = Label.SalvarReembalajeAPI_Unidade_Error_Message;
                    if( productErrorMap.containsKey(itemKey) ) {
                        productErrorMap.get(itemKey).add(Label.SalvarReembalajeAPI_Unidade_Error_Message);
                    } else {
                        productErrorMap.put( itemKey, new List<String>{Label.SalvarReembalajeAPI_Unidade_Error_Message} );
                    }
                }

            }

        }
        productErrorMap.remove(general);
        // Process productErrorMap errors
        if( !productErrorMap.keySet().isEmpty() ) {
            result = Label.SalvarReembalajeAPI_Product_Error_Message + ' ';
            
            for( String itemKey : productErrorMap.keySet() ) {
                result = result + itemKey + ': ' + String.join(productErrorMap.get(itemKey), ', ');
            }
            
        }

        return result;
    }
    
    /**
     *  METHOD:         validateItemQuantityOnSave 
     *  PARAMETERS:     itemsToAdd: List of new Reembalaje products to insert/update
     *                  ManejadorReembalagem: legacy utility class of managing Reembalaje opps and Products
     *  RETURN:         String: returns either 'success' or an error message
     *  DESCRIPTION:    Validates product quantity before save. 
     *                  Method adapted from aSiteReembalagemController.validateItemQuantityOnSave() for US #13080 
     *  AUTHOR:         irina.benitez@cloudgaia.com (12-oct-21)
     **/ 
    public static String validateItemQuantityOnSave(List<aAppendix.myOppItem> itemsToAdd, ManejadorReembalagem manejador) {

        String result = Label.SalvarReembalajeAPI_Success_Message;

		if(itemsToAdd.size() == 0) { 
			return result;
		}
		Map<String, Decimal> mapaCantidadDisponible = new Map<String, Decimal>();
		Map<String, Decimal> mapaCantidadIngresada = new Map<String, Decimal>();
		Map<String, Map<String, Map<String, Decimal>>> mapaVolumenDisponibleEnPortal = manejador.validarVolumenReembalaejem(itemsToAdd);

        for (aAppendix.myOppItem tmpOli :itemsToAdd) {
			Map<String, Map<String,Decimal>> cantidadVariedad = mapaVolumenDisponibleEnPortal.get(tmpOli.variedad);
			Map<String, Decimal> unidadPorCantidad = cantidadVariedad.get(tmpOli.categoria);
			Decimal cantidadDisponible = unidadPorCantidad.get(tmpOli.unidade);

			if(!mapaCantidadDisponible.containsKey(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade)) {
				mapaCantidadDisponible.put(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade, cantidadDisponible);
			}
			if(!mapaCantidadIngresada.containsKey(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade)) {
				mapaCantidadIngresada.put(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade, tmpOli.amount);
			}else {
				Decimal cant = mapaCantidadIngresada.get(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade);
				cant += tmpOli.amount;
				mapaCantidadIngresada.put(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade, cant);
			}
		}
		for (aAppendix.myOppItem tmpOli :itemsToAdd) {

			Decimal disponible = mapaCantidadDisponible.get(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade);
			Decimal enPortal = mapaCantidadIngresada.get(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade);

			if (enPortal> disponible) {
           		String errorCant = 'O quantidade total da variedade ' + tmpOli.variedad_nombre + ' categoria ' + tmpOli.categoria_nombre + ' e pela unidade ' + tmpOli.unidade + ' não deve ser maior que ' + disponible;  //QUANTITY EXCEEDS
				result = errorCant;
				break;

       	 	} else if (tmpOli.amount <= 0) {
           		result = Label.cantidadIgualCero;
				tmpOli.error_msg = result; 
				break;
        	}
		}        

        return result; 
    }
    
}
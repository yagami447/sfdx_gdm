@RestResource(urlMapping='/SalvarA5API/*')
global with sharing class SalvarA5API {
    
    public static final String SUCCESSMESSAGE = 'success';
    public static final String CATEGBASICA = 'Basica';
    public static final String ESTADOERROR = 'Datos obligatorios: Estado de Comercialização';

    /**
     *  SUBCLASS:       Request
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Opportunity Anexo V Request body. Created for US #12983 
     *  AUTHOR:         irina.benitez@cloudgaia.com (04-oct-21)
     **/ 
    public class Request {
        public String editId;
        public String accountId;
        public String safra;
        public String marca;
        public String userId;
        public List<aAppendix.myOppItem> itemsToAdd = new List<aAppendix.myOppItem>();
        public Boolean aprobacion = true;
        public List<aAppendix.myOppItem> itemsToRemove = new List<aAppendix.myOppItem>();
    }

    /**
     *  SUBCLASS:       Response
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Save A5 API response. Created for US #12983 
     *  AUTHOR:         irina.benitez@cloudgaia.com (04-oct-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public String oppA5Id;
    }

     /**
     *  METHOD:         saveA5 
     *  PARAMETERS:     -
     *  REQUEST BODY:   SalvarA5API.Request
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  oppA5Id: inserted opportunity Anexo V Id
     *  DESCRIPTION:    Inserts/Updates an Opportunity Anexo V. Created for US #12983 
     *  AUTHOR:         irina.benitez@cloudgaia.com (04-oct-21)
     **/ 
    @HttpPost
    global static void saveA5() {

        String requestString = RestContext.request.requestBody.toString();
        Request requestBody = (Request)JSON.deserialize(requestString, Request.class);

        RestResponse response = RestContext.response;
        response.statusCode = 403; // Default Error: Forbidden

        Response result = new Response();
        result.status = false;
        result.message = Label.Anexo_V_Val_Existe_Anexo_IV;

        aSiteUtils.retorno retorno;
        Boolean submittedForApproval = false;
        Boolean validateEstadoItems = false;
        
        Savepoint savePoint = Database.setSavepoint(); 

        try {
            System.debug('requestBody: ' + requestBody);
            Map<String, String> mapVariedades = getMapVariedadesForA5(requestBody.accountId, requestBody.safra, requestBody.marca);
            if(mapVariedades != null){

                String itemsEstadoValidation = validateOppLineItemEstado(requestBody.itemsToAdd);
                if(itemsEstadoValidation != null && itemsEstadoValidation != ''){
                    result.message = itemsEstadoValidation;
                    response.statusCode = 400;  // Bad Request
                } else  {
                    validateEstadoItems = true;
                    Map<String, String> mapCategorias = getCategoriasForA5();
                    SiteUser__c logUser = new SiteUser__c (Id = requestBody.userId);
        
                    retorno = aAppManager.saveAppend5(  requestBody.itemsToAdd,
                                                        requestBody.accountId, 
                                                        requestBody.safra,
                                                        requestBody.marca,
                                                        requestBody.editId, 
                                                        logUser,
                                                        mapCategorias, 
                                                        mapVariedades,
                                                        requestBody.itemsToRemove);
                                                            
                    if (retorno.exito == false){
                        result.message = retorno.mensaje;
                    } else if (requestBody.aprobacion) {
                        aAppManager.enviarAnexoAprobacion(retorno.id); 
                        submittedForApproval = true;
                    }
                }    
            }

        } catch (Exception exc) {
            Database.rollback(savePoint);
            result.message = exc.getMessage();
        }
                
        if(validateEstadoItems && retorno.exito && (submittedForApproval || !requestBody.aprobacion)) {
            result.status = true;
            result.oppA5Id = retorno.id;
            result.message = SUCCESSMESSAGE;
            response.statusCode = 201;  // Created
        } 

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }


    /**
     *  METHOD:         getMapVariedadesForA5 
     *  PARAMETERS:     - accountId  
     *                  - marca
     *                  - safra
     *  RETURN:         Map<String, String>: Map of Variedad__r.Id, Variedad__r.Name for provided parameters
     *  DESCRIPTION:    Helper method returns mapVariedad for provided marca, safra and account. Created for US #12983 
     *  AUTHOR:         irina.benitez@cloudgaia.com (5-oct-21)
     **/ 
    public static Map<String, String> getMapVariedadesForA5(String accountId, String safra, String marca) {
    
        Map<String, String> mapVariedades = new Map<String, String>(); 
        List<Opportunity> anexosIV = aAppManager.getAnexos3(accountId, safra, marca);

        List<String> oppAIVIds = New List<String>();
        if( !anexosIV.isEmpty() )
            for( Opportunity oppAnexoIV : anexosIV )
                oppAIVIds.add(oppAnexoIV.Id);

        if( oppAIVIds.size() > 0 ) {
            List<Variedad__c> variedades = aAppManager.getVariedadesByOpp(oppAIVIds);
            if( variedades != null){
                for (Variedad__c variedad : variedades) {
                    mapVariedades.put( variedad.Id, variedad.Name );
                    //mapVariedadesNomReg.put( variedad.Id, variedad.Nombre_de_Registro__c );
                }
            }
        }

        if(mapVariedades.isEmpty()) {
            return null;
        }

        return mapVariedades;

    }

    /**
     *  METHOD:         getCategoriasForA5 
     *  PARAMETERS:     -
     *  RETURN:         Map<String, String>: Map of Categoria__r.Id, Categoria__r.Name 
     *  DESCRIPTION:    Helper method returns mapCategorias. Created for US #12983 
     *  AUTHOR:         irina.benitez@cloudgaia.com (5-oct-21)
     **/ 
    public static Map<String, String> getCategoriasForA5() {

        Map<String, String> mapCategorias = new Map<String, String>(); 
        List<Categoria__c> categorias = aAppManager.getCategorias(); 
        if (categorias != null){
            for (Categoria__c categoria : categorias){
                if(categoria.Name == CATEGBASICA) {
                    mapCategorias.put(categoria.Id, categoria.Name); 
                }
            }
        }  

        if(mapCategorias.isEmpty()) {
            return null;
        }

        return mapCategorias;

    }

    /**
     *  METHOD:         validateOppLineItemEstado 
     *  PARAMETERS:     List<aAppendix.myOppItem> itemsToAdd: list of oppLineItems to insert
     *  RETURN:         String: Map of Variedad Name, Error for invalid items. returns null if successful
     *  DESCRIPTION:    Helper method validates oppLineItems have Estado field. Created for US #12983 
     *  AUTHOR:         irina.benitez@cloudgaia.com (5-oct-21)
     **/ 
    public static String validateOppLineItemEstado(List<aAppendix.myOppItem> itemsToAdd) {

        String mapValidacion = ''; 
        List<Categoria__c> categorias = aAppManager.getCategorias(); 
        if( !itemsToAdd.isEmpty() ){
            for( aAppendix.myOppItem item : itemsToAdd ){
                if( item.estado_comer_id == null || item.estado_comer_id.isWhitespace() ) {
                    mapValidacion += item.variedad_nombre + ': ' + ESTADOERROR + ' '; 
                }
            }
        }  
        return mapValidacion;
    }

}
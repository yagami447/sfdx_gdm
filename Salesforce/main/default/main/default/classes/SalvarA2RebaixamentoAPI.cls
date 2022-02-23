@RestResource(urlMapping='/SalvarA2RebaixamentoAPI/*')
global with sharing class SalvarA2RebaixamentoAPI {
    
    public static final String SUCCESSMESSAGE = 'success';
    public static final String DEFAULTERROR = 'something went wrong';

    /**
     *  SUBCLASS:       Request
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Opportunity Anexo II Rebaja Request body. Created for US #13034 
     *  AUTHOR:         irina.benitez@cloudgaia.com (22-sept-21)
     **/ 
    public class Request {
        public String editId;
        public String accountId;
        public String safra;
        public String marca;
        public String a2aRebajarId;
        public String a2aRebajarEpoca;
        public List<aAppendix.myOppItem> items = new List<aAppendix.myOppItem>();
        public Boolean aprobacion = true;
        public List<aAppendix.myOppItem> tmpAppItemsRebajaRemove = new List<aAppendix.myOppItem>();
    }

    /**
     *  SUBCLASS:       Response
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Save A2 Rebaixamento API response. Created for US #13034 
     *  AUTHOR:         irina.benitez@cloudgaia.com (22-sept-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public String oppA2RebId;
    }

     /**
     *  METHOD:         saveA2Rebaixamento 
     *  PARAMETERS:     -
     *  REQUEST BODY:   SalvarA2RebaixamentoAPI.Request
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  oppA2RebId: inserted opportunity Anexo II Rebaixamento Id
     *  DESCRIPTION:    Inserts/Updates an Opportunity Anexo II Rebaixamento. Created for US #13034 
     *  AUTHOR:         irina.benitez@cloudgaia.com (22-sept-21)
     **/ 
    @HttpPost
    global static void saveA2Rebaixamento() {

        String requestString = RestContext.request.requestBody.toString();
        Request requestBody = (Request)JSON.deserialize(requestString, Request.class);

        RestResponse response = RestContext.response;
        response.statusCode = 400; // Default Error: Bad Request

        Response result = new Response();
        result.status = false;
        result.message = DEFAULTERROR;

        aSiteUtils.retorno retorno;
        Boolean submittedForApproval = false;
        
        Savepoint savePoint = Database.setSavepoint(); 

        try {
            System.debug('requestBody: ' + requestBody);

            Map<String, String> mapVariedades = new Map<String, String>(); 
            List<String> oppIds = New List<String>();
            oppIds.add(requestBody.a2aRebajarId);
            List<Variedad__c> variedades = aAppManager.getVariedadesByOpp(oppIds);
            if (variedades != null){
                for (Variedad__c variedad : variedades){
                    mapVariedades.put(variedad.Id, variedad.Name); 
                }
            }

            Map<String, String> mapCategorias = new Map<String, String>(); 
            List<Categoria__c> categorias = aAppManager.getCategorias(); 
            if (categorias != null){
                for (Categoria__c categoria : categorias){
                    mapCategorias.put(categoria.Id, categoria.Name); 
                }
            }  


            retorno = aAppManager.saveAppend2Rebaja(requestBody.items,
                                                    requestBody.a2aRebajarId,
                                                    requestBody.a2aRebajarEpoca,
                                                    requestBody.accountId, 
                                                    requestBody.safra,
                                                    requestBody.marca,
                                                    requestBody.editId, 
                                                    mapVariedades,
                                                    mapCategorias, 
                                                    requestBody.tmpAppItemsRebajaRemove);
                                                       
            if (retorno.exito == false){
                result.message = retorno.mensaje;
            } else if (requestBody.aprobacion) {
                aAppManager.enviarAnexoAprobacion(retorno.id); 
                submittedForApproval = true;
            }

        } catch (Exception exc) {
            Database.rollback(savePoint);
            result.message = exc.getMessage();
        }
                
        if(retorno.exito && (submittedForApproval || !requestBody.aprobacion)) {
            result.status = true;
            result.oppA2RebId = retorno.id;
            result.message = SUCCESSMESSAGE;
            response.statusCode = 201;  
        } 

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }

}
@RestResource(urlMapping='/SalvarVotoAPI/*')
global with sharing class SalvarVotoAPI {

    @HttpPost
    global static void postSalvarVotoAPI() {
    	
        Response result = new response();
        result.status = false;
        result.message = Label.SalvarVotoAPI_Default_Error_Message;
        result.id = '';
		Savepoint savePoint = Database.setSavepoint(); 
        
        RestResponse response = RestContext.response;
        response.statusCode = 404;
        response.headers.put('Content-Type', 'application/json');
		
        String requestString = RestContext.request.requestBody.toString();
        Request requestParameters = (Request)JSON.deserialize(requestString, Request.class);
		
        try {

            String safra = [SELECT CRM_Safra_Actual__c FROM Configuracion_BMX__c LIMIT 1].CRM_Safra_Actual__c;
            String regionCuenta = aVotacionManager.getRegionCuenta(requestParameters.accountId);
            Integer numeroDeVueltas = aVotacionManager.getNroVuelta(regionCuenta);

            if (String.isBlank(regionCuenta)){

                result.message = Label.SalvarVotoAPI_Null_Region_Validation_Error_Message;
                response.statusCode = 404;

            } else{

            aSiteUtils.retorno retorno = aVotacionManager.votar(requestParameters.accountId, requestParameters.productId, String.valueOf(requestParameters.precio), safra, regionCuenta, numeroDeVueltas);
        
                if (retorno.exito == false){
                    
                    result.message = retorno.mensaje;

                } else{
                    result.id = retorno.id;
                    result.status = true;
                    result.message = Label.SalvarVotoAPI_Success_Message;
                    response.statusCode = 200;
                }
            }
            
            } catch (Exception exc) {
                
                Database.rollback(savePoint);
                result.message = exc.getMessage();
        	
            }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
    }

    public class Response {
        public Boolean status;
        public String message;
        public String id;
    }
    
    public class Request {
        public  String accountId;
        public  String productId;
        public Double precio;
	}
}
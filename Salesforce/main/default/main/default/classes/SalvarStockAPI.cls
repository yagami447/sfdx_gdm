/**
* @name SalvarStockAPI
* @author Jhonny Peroza
* updated 13-10-2021
*/
@RestResource(urlMapping='/SalvarStockAPI/*')
global with sharing class SalvarStockAPI {

    @HttpPost
    global static void salvarStock() {

        Response result = new Response();
        result.status = false;
        result.message = Label.SalvarStockAPI_Default_Error_Message;
        result.id = '';
		Savepoint savePoint = Database.setSavepoint(); 

        RestResponse response = RestContext.Response;
        response.statusCode = 404;
        response.headers.put('Content-Type', 'application/json');
            
        String requestString = RestContext.Request.requestBody.toString();
        Request requestParameters = (Request)JSON.deserialize(requestString, Request.class);
        Boolean submittedForApproval = false;
        aSiteUtils.retorno retorno;

        try {

            if(requestParameters.items != null && !requestParameters.items.isEmpty()) {
                String sementeAprobada = requestParameters.items[0].sem_aprobada;
                for(aAppendix.myOppItem item : requestParameters.items) {
                    item.sem_aprobada = sementeAprobada;
                } 
            }

            SiteUser__c logUser = new SiteUser__c(Id = requestParameters.userId);
            retorno = aAppManager.saveEstoque(requestParameters.items, requestParameters.accId, requestParameters.safra, requestParameters.marca, requestParameters.mes, requestParameters.oppId, logUser, new List<aAppendix.myOppItem>(),new Map<string, string>());

            if (retorno.exito == false){

                result.message = retorno.mensaje;
        
            } else if (Boolean.valueOf(requestParameters.aprobacion)) {

                aAppManager.enviarAnexoAprobacion(retorno.id); 
                submittedForApproval = true;

            }
            
        } catch (Exception e) {
            result.message = e.getMessage();
        }

        if(retorno.exito && (submittedForApproval || !Boolean.valueOf(requestParameters.aprobacion))){
            result.id = retorno.id;
            result.status = true;
            result.message = Label.SalvarStockAPI_Success_Message;
            response.statusCode = 201;
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');

    }

    public class Response {
        public String id;
        public Boolean status;
        public String message;
    }
    
    public class Request {
        public List<aAppendix.myOppItem> items;
        public String accId;
        public String safra;
        public String marca;
        public String mes;
        public String oppId;
        public String userId;
        public String aprobacion;
    }

}
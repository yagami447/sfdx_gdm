/**
* @name AprovarRecusarVBPedidoAPI
* @author Jhonny Peroza
* updated 09-11-2021
*/
@RestResource(urlMapping='/AprovarRecusarVBPedidoAPI/*')
global with sharing class AprovarRecusarVBPedidoAPI {

    @HttpPost
    global static void cambiarEstadoVBPedido() {

        Response result = new Response();
		Savepoint savePoint = Database.setSavepoint(); 

        RestResponse response = RestContext.Response;
        response.headers.put('Content-Type', 'application/json');
            
        String requestString = RestContext.Request.requestBody.toString();
        Request requestParameters = (Request)JSON.deserialize(requestString, Request.class);

        try {

            aSiteVendaDeBasicaController.approvalProcessVBPedido(requestParameters.pedidoId, requestParameters.action, requestParameters.coment);

            if(requestParameters.action == 'Approve') {
                result.status = true;
                result.message = Label.AprovarRecusarVBPedidoAPI_Success_Message;
                response.statusCode = 200;
            } 
            
            if(requestParameters.action == 'Reject') {
                result.status = true;
                result.message = Label.AprovarRecusarVBPedidoAPI_Request_Rejected_Error_Message;
                response.statusCode = 200;
            }

            if(requestParameters.action != 'Approve' && requestParameters.action != 'Reject') {
                result.status = false;
                result.message = Label.AprovarRecusarVBPedidoAPI_Default_Error_Message;
                response.statusCode = 404;
            }

        } catch (Exception e) {
            result.message = e.getMessage();
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');

    }

    public class Response {
        public Boolean status;
        public String message;
    }
    
    public class Request {
        public String pedidoId;
        public String action;
        public String coment;
    }

}
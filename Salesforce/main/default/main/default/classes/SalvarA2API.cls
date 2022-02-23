@RestResource(urlMapping='/SalvarA2API/*')
global with sharing class SalvarA2API {   

    @HttpPost
    global static void postSalvarA2API() {
    	
        Response result = new Response();
        result.status = false;
        result.message = Label.SalvarA2API_Default_Error_Message;
        result.id = '';
		Savepoint savePoint = Database.setSavepoint(); 
        
        RestResponse response = RestContext.Response;
        response.statusCode = 404;
        response.headers.put('Content-Type', 'application/json');
		
        String epocaPlantio;
        String requestString = RestContext.request.requestBody.toString();
        Request requestParameters = (Request)JSON.deserialize(requestString, Request.class);
		Boolean validA2;

        try {

            String safra = [SELECT PM_Safra_Actual_A2__c FROM Configuracion_BMX__c LIMIT 1].PM_Safra_Actual_A2__c;

            if(requestParameters.idAnexoEditar == null){

                validA2 = aAppManager.validarNewA2(requestParameters.accountId, safra, requestParameters.marca);

                if (validA2) {

                    epocaPlantio = aAppManager.getEpocaPlantioToA2(requestParameters.accountId, safra, requestParameters.marca); 

                    for(aAppendix.myOppItem item : requestParameters.nuevosProductos) {
                        if(item.epocaPlantio == null) {
                            item.epocaPlantio = epocaPlantio;
                        }
                    }    
                }

            } else {

                List<Opportunity> anexoForEditList = [SELECT Id 
                                                      FROM Opportunity 
                                                      WHERE Id = :requestParameters.idAnexoEditar 
                                                      AND Estado_Anexos_Portal_Miltiplicadores__c IN ('Edição','Rechazado') 
                                                      LIMIT 1];

                if(!anexoForEditList.isEmpty()){

                    validA2 = true;                   
                } else {

                    validA2 = false; 
                    result.message = Label.SalvarA2API_Opportunity_To_Edit_Error_Message;
                }                                          
            }
            
            if(validA2){

                SiteUser__c logUser = new SiteUser__c(Id = requestParameters.userId);
                aSiteUtils.retorno retorno = aAppManager.saveAppend2(requestParameters.nuevosProductos, requestParameters.accountId,
                                                                     safra, requestParameters.marca, requestParameters.idAnexoEditar, logUser);

                if (retorno.exito == false){
    
                    result.message = Label.Anexo_II_Val_New_Anexo +'  '+retorno.mensaje;
        
                } else {

                    result.id = retorno.id;
                    result.status = true;
                    result.message = Label.SalvarA2API_Success_Message;
                    Response.statusCode = 200;
                }

                if (requestParameters.aprobacion == 'true'){
                    aAppManager.enviarAnexoAprobacion(retorno.Id);
                }

            } else {

                result.message = Label.SalvarA2API_Validation_Error_Message;
            }
               
        }catch (Exception exc) {

                Database.rollback(savePoint);
                result.message = exc.getMessage();       	
        }

        Response.responseBody = Blob.valueOf(JSON.serialize(result));
    }

    public class Response {
        public Boolean status;
        public String message;
        public String id;
    }
    
    public class Request {
        public  List<aAppendix.myOppItem> nuevosProductos;
        public  String accountId;
        public  String marca;
        public String userId;
        public String aprobacion;
        public String idAnexoEditar;
	}
}
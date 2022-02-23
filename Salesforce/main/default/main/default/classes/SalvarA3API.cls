@RestResource(urlMapping='/SalvarA3API/*')
global with sharing class SalvarA3API {
    
    @HttpPost
    global static void postSalvarA3API() {
            
        response result = new response();
        result.status = false;
        result.message = Label.SalvarA3API_Default_Error_Message;
        result.id = '';
        Savepoint savePoint = Database.setSavepoint(); 
            
        RestResponse response = RestContext.response;
        response.statusCode = 404;
        response.headers.put('Content-Type', 'application/json');
            
        String requestString = RestContext.request.requestBody.toString();
        Request requestParameters = (Request)JSON.deserialize(requestString, Request.class);
            
        try {

            String safra = [SELECT PM_Safra_Actual_A3__c FROM Configuracion_BMX__c LIMIT 1].PM_Safra_Actual_A3__c;
            SiteUser__c logUser = new SiteUser__c(Id = requestParameters.userId);
            Map<String, String> categorias = getCategorias();
            aSiteUtils.retorno retorno = aAppManager.saveAppend3(requestParameters.nuevosProductos, requestParameters.accountId, safra, requestParameters.marca,  requestParameters.idAnexoEditar, logUser, categorias);
        
            if (retorno.exito == false){
                 
                if (retorno.mensaje.contains(Label.SalvarA3API_Duplicate_Value_Error_Message)) {
                    
                    result.message = Label.SalvarA3API_Duplicate_Value_Error_Message;
                    result.id = retorno.mensaje.split('id:')[1].split(':')[0];
                } else {
                    
                    result.message = retorno.mensaje;

                }
               
        
            } else {
                result.id = retorno.id;
                result.status = true;
                result.message = Label.SalvarA3API_Success_Message;
                response.statusCode = 200;
            }
        
            if (requestParameters.aprobacion == 'true'){
        
                aAppManager.enviarAnexoAprobacion(retorno.Id);
        
            }
                
            } catch (Exception exc) {
                    
                Database.rollback(savePoint);
                result.message = exc.getMessage();
                
            }
    
        response.responseBody = Blob.valueOf(JSON.serialize(result));
    }

    public static Map<String, String> getCategorias(){
        Map<String, String> mapCategorias = new Map<String, String>();
        List<Categoria__c> categorias = aAppManager.getCategorias(); 
        if (categorias != null){
            for (Categoria__c c : categorias){
                mapCategorias.put(c.Id, c.Name); 	
            }
        }	
        return mapCategorias;
    }
    
        public class response {
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
            public Map<string, string> categorias;
        }
    }
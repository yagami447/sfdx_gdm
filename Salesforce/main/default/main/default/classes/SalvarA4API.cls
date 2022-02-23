@RestResource(urlMapping='/SalvarA4API/*')
global with sharing class SalvarA4API {
    
    @HttpPost
    global static void postSalvarA4API() {
            
        response result = new response();
        result.status = false;
        result.message = Label.SalvarA4API_Default_Error_Message;
        result.id = '';
        Savepoint savePoint = Database.setSavepoint(); 
            
        RestResponse response = RestContext.response;
        response.statusCode = 404;
        response.headers.put('Content-Type', 'application/json');
            
        String requestString = RestContext.request.requestBody.toString();
        Request requestParameters = (Request)JSON.deserialize(requestString, Request.class);
        Map<String, String> mapCategorias;
            
        try {

            String safra = [SELECT PM_Safra_Actual_A4__c FROM Configuracion_BMX__c LIMIT 1].PM_Safra_Actual_A4__c;
            SiteUser__c logUser = new SiteUser__c(Id = requestParameters.userId);
            mapCategorias = getCategoriasForA4();
            aSiteUtils.retorno retorno = aAppManager.saveAppend4(requestParameters.nuevosProductos, requestParameters.accountId, safra, requestParameters.marca,  requestParameters.idAnexoEditar, logUser, mapCategorias);
        
            if (retorno.exito == false){
                        
                if (retorno.mensaje.contains(Label.SalvarA4API_Duplicate_Value_Error_Message)) {
                    
                    result.message = Label.SalvarA4API_Duplicate_Value_Error_Message;
                    result.id = retorno.mensaje.split('id:')[1].split(':')[0];

                } else {
                    
                    result.message = retorno.mensaje;
                }
        
            } else {
                
                result.id = retorno.id;
                result.status = true;
                result.message = Label.SalvarA4API_Success_Message;
                response.statusCode = 200;
            }
        
            if (requestParameters.aprobacion == 'true'){
        
                aAppManager.enviarAnexoAprobacion(retorno.Id);
        
            }
                
            } catch (Exception exc) {
                system.debug('Error: ' + exc);
                Database.rollback(savePoint);
                result.message = exc.getMessage();
                
            }
    
        response.responseBody = Blob.valueOf(JSON.serialize(result));
    }

        /**
         *  METHOD:         getCategoriasForA4 
         *  PARAMETERS:     -
         *  RETURN:         Map<String, String>: Map of Categoria__r.Id, Categoria__r.Name 
         *  DESCRIPTION:    Helper method returns mapCategorias. Created for TASK #18388 
         *  AUTHOR:         irina.benitez@cloudgaia.com (14-dec-21)
         **/ 
        public static Map<String, String> getCategoriasForA4() {

            Map<String, String> mapCategorias = new Map<String, String>(); 
            List<Categoria__c> categorias = aAppManager.getCategorias(); 
            if (categorias != null){
                for (Categoria__c categoria : categorias){
                    mapCategorias.put(categoria.Id, categoria.Name); 
                }
            }  

            if(mapCategorias.isEmpty()) {
                return null;
            }

            return mapCategorias;

        }

    
        public class response {
            public Boolean status;
            public String message;
            public String id;
        }
        
        public class Request {
            public List<aAppendix.myOppItem> nuevosProductos;
            public String accountId;
            public String marca;
            public String userId;
            public String aprobacion;
            public String idAnexoEditar;
        }
    }
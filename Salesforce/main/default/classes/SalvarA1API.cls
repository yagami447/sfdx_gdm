@RestResource(urlMapping='/SalvarA1API/*')
global with sharing class SalvarA1API {

    @HttpPost
    global static void getSalvarA1API() {

        Response result = new Response();
        result.status = false;
        result.message = Label.SalvarA1API_Default_Error_Message;
        
        RestResponse response = RestContext.response;
        response.statusCode = 404;
        response.headers.put('Content-Type', 'application/json');
        
		        
        String requestString = RestContext.request.requestBody.toString();
        Request requestParameters = (Request)JSON.deserialize(requestString, Request.class);
        
        Savepoint savePoint = Database.setSavepoint(); 
        Boolean isSuccess = true;

        try {
            
            String paraAprobacion = requestParameters.aprobacion == 'true' ? '1' : null;
            String safra;
            SiteUser__c logUser = new SiteUser__c(Id = requestParameters.userId);
            Boolean validData = true;
            Opportunity oportunidad = new Opportunity();
            
            if(requestParameters.estados.size() <= 0) {
                result.message = Label.SalvarA1API_First_Empty_Field_Validation_Message;
                validData = false;
            }
            
            if(requestParameters.nuevosProductos.size() <= 0) {
                result.message = Label.SalvarA1API_Second_Empty_Field_Validation_Message;
                validData = false;
            }
    
            
    
            if (validData) {
            system.debug('requestParameters.opportunity: ' + requestParameters.opportunity);
                if (requestParameters.opportunity.sufixCNPJ != null ) {
    
                    requestParameters.opportunity.CNPJ = requestParameters.opportunity.CNPJ + requestParameters.opportunity.sufixCNPJ;
    
                }
    
                List<Configuracion_BMX__c> safras = [SELECT PM_Safra_Actual_A1__c FROM Configuracion_BMX__c];
                safra = safras[0].PM_Safra_Actual_A1__c;
                
                FactoryManejador factory = new FactoryManejador();
                ManejadorAnexoI manejador = (ManejadorAnexoI)factory.devuelveManejador('Anexo I', requestParameters.accountId,
                                                                                       aAppManager.calcularSafraAnterior(safra), requestParameters.marca);
                    
                if(requestParameters.idAnexoEditar != null) {
                        
                    manejador.actualizarOportunidadAnexoi(requestParameters.marca, requestParameters.accountId, safra, logUser, paraAprobacion,
                                                                requestParameters.nuevosProductos, requestParameters.idAnexoEditar,
                                                                requestParameters.opportunity, requestParameters.estados);
                }  else {
                    
                    oportunidad = manejador.crearOportunidadAnexoI(requestParameters.marca, requestParameters.accountId, safra, logUser,
                                                                        paraAprobacion, requestParameters.nuevosProductos,
                                                                        requestParameters.opportunity, requestParameters.estados);
                    result.opportunity = oportunidad;                                                                             
                    }        
            } 

        } catch(DmlException e) {
            Database.rollback(savePoint);
            isSuccess = false;
            result.message = Label.SalvarA1API_DML_Error_Message + ':  ' +e.getMessage();
                      
        } catch (Exception exc) {
            Database.rollback(savePoint);
            isSuccess = false;
            result.message = exc.getMessage();
        }

        if(isSuccess){
            result.status = true;
            result.message = Label.SalvarA1API_Success_Message;
            response.statusCode = 200;
        }                       
        
        response.responseBody = Blob.valueOf(JSON.serialize(result));
       
    }
    
    public class Response {
        public Boolean status;
        public String message;
        public Opportunity opportunity;
    }
    
  	public class Request {
        public List<String> estados;
        public  List<aAppendix.myOppItem> nuevosProductos;
        public  aAppendix.oppWrapper opportunity;
        public  String accountId;
        public  String marca;
        public String userId;
        public String aprobacion;
        public String idAnexoEditar;
	}
}
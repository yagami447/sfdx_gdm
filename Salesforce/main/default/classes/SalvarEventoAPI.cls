@RestResource(urlMapping='/SalvarEventoAPI/*')
global without sharing class SalvarEventoAPI {
  
    @HttpPost
    global static void salvarEventoAPI() {
    	
        response result = new response();
        result.status = false;
        result.message = Label.SalvarEventoAPI_Default_Error_Message;
        result.id = '';
		Savepoint savePoint = Database.setSavepoint(); 
        
        RestResponse response = RestContext.response;
        response.statusCode = 404;
        response.headers.put('Content-Type', 'application/json');
		
        String requestString = RestContext.request.requestBody.toString();
        Request requestParameters = (Request)JSON.deserialize(requestString, Request.class);
		Map<String, String> mapEventosTipoReg;
        try {
            mapEventosTipoReg = getCRMEventosRecordTypeMap();
            String recTypeEvento = mapEventosTipoReg.get(requestParameters.evento.evento);

            SiteUser__c logUser = new SiteUser__c(Id = requestParameters.userId);
            
            aSiteUtils.retorno retorno = aEventosManager.saveEvento(requestParameters.evento, requestParameters.items, requestParameters.itemsBorrar, recTypeEvento, logUser);
        
                if (retorno.exito == false){
                    
                    result.message = retorno.mensaje;
    
                } else {

                    if (requestParameters.aprobacion == 'true' && retorno.exito){

                        aEventosManager.enviarEventoAprobacion(retorno.Id);
        
                    }

                    result.id = retorno.id;
                    result.status = true;
                    result.message = Label.SalvarEventoAPI_Success_Message;
                    response.statusCode = 200;
                }
    

            
            } catch (Exception exc) {
                
                Database.rollback(savePoint);
                result.message = exc.getMessage();
        	
            }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
    }

    public static Map<String, String> getCRMEventosRecordTypeMap() {

        Map<String, String> eventRecordTypeMap = new Map<String, String>();
        List<String> recordTypeList = new List<String>();

        Schema.DescribeFieldResult eventos = CRM_Calendario_de_Eventos__c.Evento__c.getDescribe();

        for (Schema.PickListEntry evento : eventos.getPickListValues()) {
            recordTypeList.add( evento.getvalue() );
        }

        for (String evento : recordTypeList) {
            if (evento == 'Día de Campo' || evento == 'Estação DONMARIO MAS' || evento == 'Tour dos Máximos Rendimentos' || evento == 'Feiras') {
                eventRecordTypeMap.put(evento, 'Día de Campo');
            } else if (evento == 'Palestra' || evento == 'Treinamento' || evento == 'Encontro Técnico' || evento == 'Jornada Técnica') {
                eventRecordTypeMap.put(evento, 'Treinamento Tecnico');
            } else if (evento == 'Strip Test' || evento == 'Lado a Lado' || evento == 'CESB' || evento == 'Area comercial') {
                eventRecordTypeMap.put(evento, 'Test a campo');
            } else if (evento == 'Emplacamento' || evento == 'Outdoor') {
                eventRecordTypeMap.put(evento, 'Emplacamento');
            }
        }

        return eventRecordTypeMap;
    }

    public class Response {
        public Boolean status;
        public String message;
        public String id;
    }
    
    public class Request {
        public aSiteEventosController.evento evento;
        public List<aSiteEventosController.item> items;
        public List<aSiteEventosController.item> itemsBorrar; 
        public String userId;
        public String aprobacion;
	}
}
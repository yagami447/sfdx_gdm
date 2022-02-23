@RestResource(urlMapping='/EstadoParaCRMAPI/*')

global with sharing class EstadoParaCRMAPI {
    
    @HttpGet
    global static void listarEstados() {
        
        RestResponse response = RestContext.response;
        response.statusCode = 404;
        
        EstadoParaCRMAPIResponse result = new EstadoParaCRMAPIResponse();
        result.status = false;
        result.message = Label.EstadoParaCRMAPI_Default_Error_Message;
        
        String strObjectName = 'Estado_para_CRM__c';
        String strPicklistField = 'Estado__c';
        List<String> listaDeEstadosaDevolver = new List<String>();
        
        try{
            
            Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(strObjectName);
            Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
            Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
            List<Schema.PicklistEntry> lstPickListValues = mapFields.get(strPicklistField).getDescribe().getPickListValues(); 
            
            for(Schema.PicklistEntry pickListValue : lstPickListValues) {
                
                listaDeEstadosaDevolver.add(pickListValue.label);
            }
            
            response.statusCode = 200;
            result.status = true;
            result.message = Label.EstadoParaCRMAPI_Success_Message;
            result.listaDeEstados = listaDeEstadosaDevolver;
            
        }catch (Exception exc) {
            
            response.statusCode = 400;
            result.message = exc.getMessage();        
        }
        
        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
        
    }
    public class EstadoParaCRMAPIResponse {
        
        public Boolean status;
        public String message;
        public List<String> listaDeEstados = new List<String>();
    }
}
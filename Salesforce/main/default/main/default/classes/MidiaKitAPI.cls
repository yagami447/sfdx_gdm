@RestResource(urlMapping='/MidiaKitAPI/*')
global with sharing class MidiaKitAPI {
    
    @HttpGet
    global static void listarMidiaKits() {
        
        RestResponse response = RestContext.response;
        response.statusCode = 404;
        
        MidiaKitAPIResponse result = new MidiaKitAPIResponse();
        result.status = false;
        result.message = Label.MidiaKitAPI_Default_Error_Message;
        
        String accountId = RestContext.request.params.get('accountId');
        String marca = RestContext.request.params.get('marca');
        Map<String, String> urlByName = new Map<String, String>();
        
        try{
            if(String.isBlank(accountId) || String.isBlank(marca)){
                
                response.statusCode = 404;
                result.status = false;
                result.message = Label.MidiaKitAPI_Validation_Error_Message;
                
            } else {
                
                List<Midia_Kit__c> midiaKitListReturn = [SELECT Id, Name, URL__c
                                                         FROM Midia_Kit__c
                                                         WHERE (Cuenta__c = :accountId OR Cuenta__c = null)
                                                         AND Marca__c = :marca
                                                         AND Active__c = true
                                                         ORDER BY Category__c];
                
                if(!midiaKitListReturn.isEmpty()){
                    
                    for(Midia_Kit__c midiaKit : midiaKitListReturn){
                        urlByName.put(midiaKit.Name, midiaKit.URL__c);
                    }
                    
                    
                    response.statusCode = 200;
                    result.status = true;
                    result.message = Label.MidiaKitAPI_Success_Message;
                    result.midiaKits = urlByName;
                    
                } else {
                    
                    result.message = Label.MidiaKitAPI_No_Items_Error_Message;
                    result.status = false;
                    response.statusCode = 404;
                    
                }
            }
            
        }catch (Exception exc) {
            
            response.statusCode = 400;
            result.message = exc.getMessage();        
        }
        
        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }
    
    public class MidiaKitAPIResponse {
        
        public Boolean status;
        public String message;
        public Map<String, String> midiaKits;
    }
}
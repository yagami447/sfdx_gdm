@RestResource(urlMapping='/CidadesAPI/*')
global with sharing class CidadesAPI {

    /**
     *  SUBCLASS:       Response
     *  DESCRIPTION:    wrapper class for Cidades API response. Created for US #13357
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public List<Cidade__c> cidades;
    }

     /**
     *  METHOD:         getCidades 
     *  PARAMETERS:     -
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  cidades: list of records to return
     *  DESCRIPTION:    Return list of Cidades for an Event type. Created for US #13082
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     **/ 
    @HttpGet
    global static void getCidades() {

        RestResponse resp = RestContext.response;
        resp.statusCode = 404;

        CidadesAPI.Response result = new CidadesAPI.Response();
        result.status = false;
        result.message = Label.CidadesAPI_Default_Error_Message;
        
        try {

            List<Cidade__c> cidadeList = [SELECT Id, Name, Estado__c, Nombre_Estado__c FROM Cidade__c];

            if( cidadeList != null && !cidadeList.isEmpty() ){
                result.cidades = cidadeList;
            }

        } catch (Exception exc) {
            resp.statusCode = 400;
            result.message = exc.getMessage();
        }
                
        if(result.cidades != null && !result.cidades.isEmpty()) {
            result.status = true;
            result.message = Label.CidadesAPI_Success_Message;
            resp.statusCode = 200;
        }

        resp.responseBody = Blob.valueOf(JSON.serialize(result));
        resp.headers.put('Content-Type', 'application/json');
        resp.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }


}
@RestResource(urlMapping='/CooperantesA1API/*')
global with sharing class CooperantesA1API {

    /**
     *  SUBCLASS:       Cooperante
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Cooperante data 
     *  AUTHOR:         irina.benitez@cloudgaia.com (13-sept-21)
     **/ 
    public class Cooperante {
        public String nombre;
        public String cnpjCnp;
        public String renasem;
        public String id;
        public String IdCuentaCoop;
    }

    /**
     *  SUBCLASS:       Response
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Cooperante A1 API response 
     *  AUTHOR:         irina.benitez@cloudgaia.com (13-sept-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public List<Cooperante> cooperantes;
    }

     /**
     *  METHOD:         getCooperantesAnexo1 
     *  PARAMETERS:     accountId: Id of an Account record 
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  cooperantes: list of records to return
     *  DESCRIPTION:    Return list of cooperantes for an account. Created for US #12714 
     *  AUTHOR:         irina.benitez@cloudgaia.com (13-sept-21)
     **/ 
    @HttpGet
    global static void getCooperantesAnexo1() {

        List<Cooperante__c> cooperanteList;
        List<Cooperante> cooperantes = new List<Cooperante>();
        Response result = new Response();
        result.status = false;
        result.message = Label.CooperantesA1API_Default_Error_Message;

        RestResponse response = RestContext.response;
        String accountId = RestContext.request.requestUri.substringafterlast('/');

        try {
            cooperanteList = [SELECT Id, CuentaCoop__r.Name, CuentaCoop__r.CNPJ_CPF__c, CuentaCoop__r.Renasem__c, CuentaCoop__c FROM Cooperante__c WHERE Cuenta__c = :accountId];

            if(cooperanteList.isEmpty()){
                response.statusCode = 404;
            } else {

                for(Cooperante__c cooperante : cooperanteList) {
                    Cooperante coop = new Cooperante();
                    coop.nombre = cooperante.CuentaCoop__r.Name;
                    coop.cnpjCnp = cooperante.CuentaCoop__r.CNPJ_CPF__c;
                    coop.renasem = cooperante.CuentaCoop__r.Renasem__c;
                    coop.IdCuentaCoop = cooperante.CuentaCoop__c;
                    coop.id = cooperante.Id;
                    cooperantes.add(coop);
                }

                result.status = true;
                result.message = Label.CooperantesA1API_Success_Message;
                result.cooperantes = cooperantes;
                
                response.statusCode = 200;
            }
        } catch (Exception exc) {
            result.message = exc.getMessage();
            response.statusCode = 400;
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');

    }

}
@RestResource(urlMapping='/votosRealizadosAPI/*')
global with sharing class votosRealizadosAPI {

    @HttpGet
    global static void getMisVotos() {

        String regionCuenta = RestContext.request.params.get('regionCuenta');
        String accountId = RestContext.request.params.get('accountId');
        String safra = RestContext.request.params.get('safra');
        String vuelta = RestContext.request.params.get('vuelta');

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        Response result = new Response();
        result.status = false;

        try {

            List<Votacion__c> votes = getVotacionesByAccount(accountId, safra, regionCuenta, Integer.valueOf(vuelta));
            List<VotoWrapper> voteList = new List<VotoWrapper>();

            if(!votes.isEmpty()) {

                VotoWrapper votacionData;

                for (Votacion__c vote : votes) {
                  
                    votacionData = new VotoWrapper();
                    votacionData.name = vote.Variedad__c;
                    votacionData.data = Double.valueOf(vote.Valor__c);
                    votacionData.productId = vote.Producto__c;
                    voteList.add(votacionData);
                }

                result.listaDeVotos = voteList;
                result.message = Label.votosRealizadosAPI_Success_Message;
                result.status = true;
                response.statusCode = 200;
                
            } else {

                result.message = Label.votosRealizadosAPI_Default_Error_Message;
                result.status = false;
                response.statusCode = 404;
            }

            response.responseBody = Blob.valueOf(JSON.serialize(result));

        } catch (Exception e) {

            result.message = e.getMessage();            
        }
    }

    public static List<Votacion__c> getVotacionesByAccount(String accId, String safra, String region, Integer vuelta){
                 
        return [Select Variedad__c, Valor__c, Producto__c From Votacion__c Where Cuenta__c = :accId And Safra__c = :safra And Region_Comercial__c = :region And Vuelta__c = :vuelta];
    }

    public class VotoWrapper {
        public String name {get;set;}
        public Double data {get;set;}
        public Id productId {get;set;}
    }

    public class Response {

        public String message;
        public Boolean status;
        public List<VotoWrapper> listaDeVotos;
    }
}
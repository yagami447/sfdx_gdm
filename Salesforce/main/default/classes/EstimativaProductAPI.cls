/**
* @name EstimativaProductAPI
* @author Jhonny Peroza
* updated 04-11-2021
*/
@RestResource(urlMapping='/EstimativaProductAPI/*')
global with sharing class EstimativaProductAPI {

    @HttpGet
    global static void getEstimativaProducts() {

        RestResponse response = RestContext.response;
        Response result = new Response();

        String accountId = RestContext.request.params.get('accountId');
        String marca = RestContext.request.params.get('marca');

        Savepoint savePoint = Database.setSavepoint(); 

        try {
            
            SiteUserSession__c userSession = new SiteUserSession__c();
            userSession.Marca__c = marca;
            insert userSession;

            Map<Id, Variedad__c> varietyMap = new Map<Id, Variedad__c>();
            Account accountRow = [SELECT Id, Name, Region__r.Region_Comercial__c, Responsavel__c, Reponsavel_DSEM__c FROM Account WHERE Id =: accountId LIMIT 1];

            varietyMap = aSiteVendaDeBasicaController.getVariedades(accountRow.Region__r.Region_Comercial__c, userSession.id, accountRow);

            List<aSiteVendaDeBasicaController.ProductoRequisicion> varietiesList = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

            if (!varietyMap.isEmpty()) {

                for (Variedad__c p : varietyMap.values()) {

                    aSiteVendaDeBasicaController.ProductoRequisicion pr = new aSiteVendaDeBasicaController.ProductoRequisicion();
                    pr.nombre = p.Name;
                    pr.variedadId = p.Id;
                    pr.registro = p.Nombre_de_Registro__c;
                    varietiesList.add(pr);
                }

            }

            if(varietiesList.size() > 0) {

                result.status = true;
                result.message = Label.EstimativaProductAPI_Success_Message;
                result.items = varietiesList;
                response.statusCode = 200;

            } else {
                result.status = false;
                result.message = Label.EstimativaProductAPI_Default_Error_Message;
                response.statusCode = 404;
            }

            delete userSession;

        } catch (Exception e) {

            Database.rollback(savePoint);
            result.status = false;
            result.message = e.getMessage();
        }   


        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');

    }

    public class Response {
        public Boolean status;
        public String message;
        public List<aSiteVendaDeBasicaController.ProductoRequisicion> items = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();
    }

}
/**
* @name StockProductsAPI
* @author Jhonny Peroza
* updated 07-10-2021
*/
@RestResource(urlMapping='/StockProductsAPI/*')
global with sharing class StockProductsAPI {

    @HttpGet
    global static void getStockProducts() {

        Id accountId = RestContext.request.params.get('accountId');
        String safra = RestContext.request.params.get('safra');
        String marca = RestContext.request.params.get('marca');

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        Response result = new Response();
        result.status = false;

        try {

            List<OpportunityLineItem> oppLineItemsList = aAppManager.getItemsToEstoque(accountId, safra, marca);

            if(oppLineItemsList.size()>0) {

                List<OpportunityLineItem> oppLineItemsValidateList = aAppManager.valEstoque_A(oppLineItemsList, marca);

                if(oppLineItemsValidateList != null) {

                    result.stockProducts = oppLineItemJSONConverter(oppLineItemsValidateList);
                    result.message = Label.StockProductsAPI_Success_Message;
                    result.status = true;
                    response.statusCode = 200;
                    response.responseBody = Blob.valueOf(JSON.serialize(result));

                } else {

                    result.message = Label.StockProductsAPI_Default_Error_Message;
                    result.status = false;
                    response.statusCode = 404;
                    response.responseBody = Blob.valueOf(JSON.serialize(result));

                }

            } else {

                result.message = Label.StockProductsAPI_Default_Error_Message;
                result.status = false;
                response.statusCode = 404;
                response.responseBody = Blob.valueOf(JSON.serialize(result));

            }

        } catch (Exception e) {
            result.message = e.getMessage();
        }
 
    }

    public static List<aAppendix.myOppItem> oppLineItemJSONConverter(List<OpportunityLineItem> oppLineItemsValidateList) {

        List<aAppendix.myOppItem> result = new List<aAppendix.myOppItem>();
        
        for(OpportunityLineItem oppLineItem : oppLineItemsValidateList){
            aAppendix.myOppItem oli = new aAppendix.myOppItem();
            oli.id = oppLineItem.Id;
            oli.variedad = oppLineItem.PricebookEntry.Product2.Variedade__c;
            oli.variedad_nombre = oppLineItem.Variedade_Prod__c;
            oli.variedad_registro = oppLineItem.Variedad_de_Produto__c;
            oli.categoria_id = oppLineItem.Categoria__c;
            oli.sem_comer = String.valueOf(oppLineItem.Semente_comercializada__c);
            oli.sem_aprobada = String.valueOf(oppLineItem.Semente_aprovada__c); 

            result.add(oli);
        }
    
        return result;
    }

    public class Response {
        public String message;
        public Boolean status;
        public List<aAppendix.myOppItem> stockProducts = new List<aAppendix.myOppItem>();
    }

}
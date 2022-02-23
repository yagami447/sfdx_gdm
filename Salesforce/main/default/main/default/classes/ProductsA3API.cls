@RestResource(urlMapping='/ProductsA3API/*')
global with sharing class ProductsA3API {

    /**
     *  SUBCLASS:       Response
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Products A3 API response. Created for US #12697 
     *  AUTHOR:         irina.benitez@cloudgaia.com (20-sept-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public List<aAppendix.myOppItem> productsA3;
    }

     /**
     *  METHOD:         getProductsAppendix3 
     *  PARAMETERS:     accountId: Id of an Account record 
     *                  safra  
     *                  marca 
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  productsA3: list of records to return
     *  DESCRIPTION:    Return list of products for Anexo III. Created for US #12697
     *  AUTHOR:         irina.benitez@cloudgaia.com (20-sept-21)
     **/ 
    @HttpGet
    global static void getProductsAppendix3() {

        String accountId = RestContext.request.params.get('accountId');
        String safra = RestContext.request.params.get('safra');
        String marca = RestContext.request.params.get('marca');

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        Response result = new Response();
        result.status = false;
        result.message = Label.Anexo_III_Val_Existe_Anexo_II;
        
        try {

            List<OpportunityLineItem> tmpOppItems = aAppManager.getAnexosItemsToA3(accountId, safra, marca);
            tmpOppItems = aAppManager.valAnexos3_A(tmpOppItems);

            result.productsA3 = oppLineItemJSONConverter(tmpOppItems);

        } catch (Exception exc) {
            response.statusCode = 400;
            result.message = exc.getMessage();
        }
                
        if(result.productsA3 != null && !result.productsA3.isEmpty()) {
            result.status = true;
            result.message = Label.ProductsA3API_Success_Message;
            response.statusCode = 200;
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }


    /**
     *  METHOD:         oppLineItemJSONConverter 
     *  PARAMETERS:     oppLineItems: List of OpportunityLineItems in sObject format
     *  RETURN:         List<aAppendix.myOppItem>: list of records in JSON format to return
     *  DESCRIPTION:    Helper method converts opportunityLineItem sObject in aAppendix.myOppItem JSON wrapper. Created for US #12697 
     *  AUTHOR:         irina.benitez@cloudgaia.com (20-sept-21)
     **/ 
    public static List<aAppendix.myOppItem> oppLineItemJSONConverter(List<OpportunityLineItem> oppLineItems) {
        
        List<aAppendix.myOppItem> result = new List<aAppendix.myOppItem>();
        
        for(OpportunityLineItem oppLineItem : oppLineItems){
            aAppendix.myOppItem oli = new aAppendix.myOppItem();
            oli.variedad = oppLineItem.PricebookEntry.Product2.Variedade__c;
            oli.variedad_nombre = oppLineItem.Variedade_Prod__c;
            oli.variedad_registro = oppLineItem.Variedad_de_Produto__c;
            oli.categoria = oppLineItem.Categoria__r.Name;
            oli.categoria_id = oppLineItem.Categoria__c;

            if(oppLineItem.Semente_bruta__c != null) {
                oli.sem_bruta_A2 = String.valueOf(oppLineItem.Semente_bruta__c);
                oli.sem_bruta = String.valueOf(oppLineItem.Semente_bruta__c);
            } 
            if(oppLineItem.Semente_beneficiada__c != null) {
                oli.sem_beneficiada = String.valueOf(oppLineItem.Semente_beneficiada__c);                
            } 
            if(oppLineItem.Semente_aprovada__c != null) {
                oli.sem_aprobada = String.valueOf(oppLineItem.Semente_aprovada__c);
            }
            if(oppLineItem.Semente_comercializada__c != null) {
                oli.sem_comer = String.valueOf(oppLineItem.Semente_comercializada__c);
            } 
            if(oppLineItem.Semente_uso_propio__c != null) {
                oli.sem_uso_propio = String.valueOf(oppLineItem.Semente_uso_propio__c);  
            }                               

            result.add(oli);
        }
        
        return result;
    }


}
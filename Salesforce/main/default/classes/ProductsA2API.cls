@RestResource(urlMapping='/ProductsA2API/*')
global with sharing class ProductsA2API {

    /**
     *  SUBCLASS:       Response
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Products A2 API response. Created for US #12696 
     *  AUTHOR:         irina.benitez@cloudgaia.com (16-sept-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public String epoca;
        public List<aAppendix.myOppItem> productsA2 = new List<aAppendix.myOppItem>();
    }

     /**
     *  METHOD:         getProductsAppendix2 
     *  PARAMETERS:     accountId: Id of an Account record 
     *                  safra  
     *                  marca 
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  productsA2: list of records to return
     *  DESCRIPTION:    Return list of products for Anexo II. Created for US #12696 
     *  AUTHOR:         irina.benitez@cloudgaia.com (13-sept-21)
     **/ 
    @HttpGet
    global static void getProductsAppendix2() {

        String accountId = RestContext.request.params.get('accountId');
        String safra = RestContext.request.params.get('safra');
        String marca = RestContext.request.params.get('marca');

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        Response result = new Response();
        result.status = false;
        result.message = Label.Anexo_II_Val_Existe_Anexo_I;
        
        try {
            result.epoca = aAppManager.getEpocaPlantioToA2(accountId, safra, marca);
            List<OpportunityLineItem> tmpOppItems = aAppManager.getAnexosItemsToA2(accountId, safra, marca, result.epoca);
            tmpOppItems = aAppManager.valAnexos2_A(tmpOppItems);
            result.productsA2 = oppLineItemJSONConverter(tmpOppItems, result.epoca);
        } catch (Exception exc) {
            response.statusCode = 400;
            result.message = exc.getMessage();
        }
                
        if(result.productsA2 != null && !result.productsA2.isEmpty()) {
            result.status = true;
            result.message = Label.ProductsA2API_Success_Message;
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
     *  DESCRIPTION:    Helper method converts opportunityLineItem sObject in aAppendix.myOppItem JSON wrapper. Created for US #12696 
     *  AUTHOR:         irina.benitez@cloudgaia.com (20-sept-21)
     **/ 
    public static List<aAppendix.myOppItem> oppLineItemJSONConverter(List<OpportunityLineItem> oppLineItems, String epocaDePlantio) {

        List<aAppendix.myOppItem> result = new List<aAppendix.myOppItem>();

        if(oppLineItems != null && oppLineItems.size() > 0) {
            Map<String, OpportunityLineItem> mapOppApp = new Map<String, OpportunityLineItem>();

            for(OpportunityLineItem oppLineItem : oppLineItems){
                if(!mapOppApp.containsKey(oppLineItem.Categoria__r.Name + oppLineItem.Variedade_Prod__c)){                           
                    mapOppApp.put(oppLineItem.Categoria__r.Name + oppLineItem.Variedade_Prod__c, oppLineItem);
                }
            }
        
            for(OpportunityLineItem oppLineItem : oppLineItems){
                aAppendix.myOppItem oli = new aAppendix.myOppItem();
                oli.variedad = oppLineItem.PricebookEntry.Product2.Variedade__c;
                oli.variedad_nombre = oppLineItem.Variedade_Prod__c;
                oli.variedad_registro = oppLineItem.Variedad_de_Produto__c;
                oli.categoria = oppLineItem.Categoria__r.Name;
                oli.categoria_id = oppLineItem.Categoria__c;
                oli.area_autorizada = String.valueOf(oppLineItem.area__c);
                if(mapOppApp.containsKey(oppLineItem.Categoria__r.Name + oppLineItem.Variedade_Prod__c)){
                    OpportunityLineItem i = mapOppApp.get(oppLineItem.Categoria__r.Name + oppLineItem.Variedade_Prod__c);
                    oli.area_autorizada = String.valueOf(i.area__c);
                }

                oli.area_plantada = String.valueOf(oppLineItem.Area_plantada__c);
                oli.sem_bruta = String.valueOf(oppLineItem.Semente_bruta__c);                
                oli.descarte = String.valueOf(oppLineItem.Descarte__c);
                oli.epocaPlantio = epocaDePlantio;

                result.add(oli);
            }
        }

        return result;
    }

}
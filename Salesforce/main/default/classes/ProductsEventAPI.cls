@RestResource(urlMapping='/ProductsEventAPI/*')
global with sharing class ProductsEventAPI {

    /**
     *  SUBCLASS:       Response
     *  DESCRIPTION:    wrapper class for Event Products API response. Created for US #13082 
     *  AUTHOR:         irina.benitez@cloudgaia.com (20-oct-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public List<aSiteEventosController.item> productsEvent;
    }

     /**
     *  METHOD:         getProductsEvent 
     *  PARAMETERS:     event: type of event 
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  productsEvent: list of records to return
     *  DESCRIPTION:    Return list of products for an Event type. Created for US #13082
     *  AUTHOR:         irina.benitez@cloudgaia.com (20-oct-21)
     *  MODIFIED:       irina.benitez@cloudgaia.com (16-feb-22). Added logic for new event 'Area Comercial' for US #20642
     **/ 
    @HttpGet
    global static void getProductsEvent() {

        String event = RestContext.request.params.get('event');

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        ProductsEventAPI.Response result = new ProductsEventAPI.Response();
        result.status = false;
        result.message = Label.ProductsEventAPI_Default_Error_Message;
        
        try {

            String productQuery = 'SELECT Id, Name, Obtentor__c FROM Product2 WHERE Obtentor__c != null AND Portal__c = TRUE ';
            if( event == 'Treinamento' || event == 'Palestra'){ 
                productQuery += 'AND Name = \'Outro\'';
            } else if ( event == 'Area Comercial' ) {
                productQuery += 'AND Obtentor__c = \'Brasmax\'';
            }

            List<Product2> productList = Database.query(productQuery);

            if( productList != null && !productList.isEmpty() ){
                result.productsEvent = productJSONConverter(productList);
            }

        } catch (Exception exc) {
            response.statusCode = 400;
            result.message = exc.getMessage();
        }
                
        if(result.productsEvent != null && !result.productsEvent.isEmpty()) {
            result.status = true;
            result.message = Label.ProductsEventAPI_Success_Message;
            response.statusCode = 200;
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }


    /**
     *  METHOD:         productJSONConverter 
     *  PARAMETERS:     products: List of Product2 items in sObject format
     *  RETURN:         List<aSiteEventosController.item>: list of records in JSON format to return
     *  DESCRIPTION:    Helper method converts Product2 sObject in aSiteEventosController.item JSON wrapper. Created for US #13082 
     *  AUTHOR:         irina.benitez@cloudgaia.com (20-oct-21)
     **/ 
    public static List<aSiteEventosController.item> productJSONConverter(List<Product2> products) {
        
        List<aSiteEventosController.item> result = new List<aSiteEventosController.item>();
        
        if(products != null && !products.isEmpty()) {
            for(Product2 product : products){
                aSiteEventosController.item item = new aSiteEventosController.item();
                item.obtentor = product.Obtentor__c;
                item.id_producto = product.Id;
                item.desc_producto = product.Name;
                result.add(item);
            }
        }
        
        return result;
    }

}
@RestResource(urlMapping='/ProductsCRMAPI/*')
global with sharing class ProductsCRMAPI {

    /**
     *  SUBCLASS:       Response
     *  DESCRIPTION:    wrapper class for CRM Products API response. Created for US #14317 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public Map<String, List<Producto>> productsCRM;
    }

    /**
     *  SUBCLASS:       Producto
     *  DESCRIPTION:    wrapper class for CRM Products. Created for US #14317 //! Ver con team de unificar JSON wrapper en una única clase 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
     **/ 
    public class Producto {
        public String id_producto;
        public String desc_producto;
    }

     /**
     *  METHOD:         getProductsCRM 
     *  PARAMETERS:     event: type of event 
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  productsCRM: list of records to return
     *  DESCRIPTION:    Return list of products for a CRM. Created for US #14317
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
     **/ 
    @HttpGet
    global static void getProductsCRM() {

        String event = RestContext.request.params.get('event');

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        ProductsCRMAPI.Response result = new ProductsCRMAPI.Response();
        result.status = false;
        result.message = Label.ProductsCRMAPI_Default_Error_Message;
        
        try {

            List<Product2> productList = [SELECT Id, Name, Obtentor__c FROM Product2 WHERE Obtentor__c != null AND Portal__c = TRUE ORDER BY Obtentor__c];

            if( productList != null && !productList.isEmpty() ){
                result.productsCRM = productJSONConverter(productList);
            }

        } catch (Exception exc) {
            response.statusCode = 400;
            result.message = exc.getMessage();
        }
                
        if(result.productsCRM != null && !result.productsCRM.isEmpty()) {
            result.status = true;
            result.message = Label.ProductsCRMAPI_Success_Message;
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
     *  DESCRIPTION:    Helper method converts Product2 sObject in aSiteEventosController.item JSON wrapper. Created for US #14317 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
     **/ 
    public static Map<String, List<Producto>> productJSONConverter(List<Product2> products) {
        
        Map<String, List<Producto>> result = new Map<String, List<Producto>>();

        for( Product2 product : products) {
            Producto item = new Producto();
            item.desc_producto = product.Name;
            item.id_producto = product.Id;

            if(!result.containsKey(product.Obtentor__c)) {
                List<Producto> itemList = new List<Producto>();
                itemList.add(item);
                result.put(product.Obtentor__c, itemList);
            } else {
                result.get(product.Obtentor__c).add(item);
            }
        }
        
        return result;
    }


}
@RestResource(urlMapping='/ProductsVotacionAPI/*')
global with sharing class ProductsVotacionAPI {

     /**
     *  METHOD:         getProductsVotacion 
     *  PARAMETERS:     accountId: Id of an Account record 
     *                  safra  
     *                  marca 
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  productsVotacion: list of available products for Votacion
     *  DESCRIPTION:    Return list of products for Votacion. Created for US #13225 
     *  AUTHOR:         irina.benitez@cloudgaia.com (29-sept-21)
     * 
     *  UPDATE:         pablo.fraquia@cloudgaia.com (12-jan-22)
     *  DESCRIPTION:    Return list of products for Votacion Second Round (Balotage) when vuelta == 2. Created for US #19251 
     **/ 
    
    @HttpGet
    global static void getProductsVotacion() {

        String accountId = RestContext.request.params.get('accountId');
        String safra = RestContext.request.params.get('safra');
        String regionCuenta = aVotacionManager.getRegionCuenta(accountId);
        Integer vuelta = aVotacionManager.getNroVuelta(regionCuenta);

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        Response result = new Response();
        result.status = false;
        result.message = Label.ProductsVotacionAPI_Default_Error_Message;
        
        try {

            if(vuelta == 1){

                result.productsVotacion = aVotacionManager.getVariedadesHabilitadas(accountId, safra);
            }

            if(vuelta == 2){
                
                Set<Id> productosHabilitados = new Set<Id>();
                List<Item_del_Contrato__c> items = aVotacionManager.getVariedadesHabilitadas(accountId, safra);
                for(Item_del_Contrato__c item :items){

                    productosHabilitados.add(item.Cultivar__c);
                }

                result.productsVotacionBalotage = getProductsForBalotage( regionCuenta, productosHabilitados );
            }

        } catch (Exception exc) {

            response.statusCode = 400;
            result.message = exc.getMessage();
        }
                
        if((result.productsVotacion != null && !result.productsVotacion.isEmpty()) || (result.productsVotacionBalotage != null && !result.productsVotacionBalotage.isEmpty())) {
                       
            result.status = true;
            result.message = Label.ProductsVotacionAPI_Success_Message;
            result.vuelta = vuelta;
            response.statusCode = 200;
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    } 

     /**
     *  METHOD:         getProductsForBalotage 
     *  PARAMETERS:     region: Account.Region_Comercial__c for match with Votacion_balotage__c.Region_Comercial__c
     *                  productosVotados: Set of products voted in the first round (vuelta 1) for the specified account.
     *  RETURN:         List of Votacion_balotage__c (vuelta 2)
     *  DESCRIPTION:    Return list of Votacion_balotage__c for Balotage. 
     *  AUTHOR:         pablo.fraquia@cloudgaia.com (18-Jan-2022)
     * 
     **/ 
    public static List<Votacion_balotage__c> getProductsForBalotage( String region, Set<Id> productosHabilitados ){

        try{                                                
            return aSiteUtils.queryResults2(Votacion_balotage__c.SObjectType, null ,'Region_Comercial__c = :v1', region, 'Producto__c IN :v2', productosHabilitados);        
        }
        catch(Exception e){
            return null;
        }       
    }

        /**
     *  SUBCLASS:       Response
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Products Votacion API response. Created for US #13225 
     *  AUTHOR:         irina.benitez@cloudgaia.com (4-nov-21)
     * 
     *  UPDATE:         pablo.fraquia@cloudgaia.com (12-jan-22)
     *  DESCRIPTION:    productsVotacionBalotage list added for show products Second Round (Balotage) when vuelta == 2. Created for US #19251 
     **/ 

    public class Response {

        public Boolean status;
        public String message;
        public integer vuelta;
        public List<Item_del_Contrato__c> productsVotacion;
        public List<Votacion_balotage__c> productsVotacionBalotage;
    }
}
@RestResource(urlMapping='/ProductsA1Api/*')
global with sharing class ProductsA1Api 
{
   
    @HttpGet
    global static void restGetDataAppendix1() 
    {
        String accountId = RestContext.request.params.get('accountId');
        String safra = RestContext.request.params.get('safra');
        String marca = RestContext.request.params.get('marca');
        RestResponse response = RestContext.response;
        
        response.headers.put('Content-Type', 'application/json');
        response.statusCode = 200;
        
        WrapperAppendix1 result = ProductHelper.getDataAppendix1(accountId,safra,marca);
        
        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
        
    }
}
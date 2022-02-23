@isTest
private class ProductsA1ApiTest 
{
    @isTest
	public static void testEmpty()
    {
    	RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        Test.startTest();
        
        Account acc = crearCuenta();
    
        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/ProductA1Api'; 
        String postData = '';
        req.addParameter('accountId', acc.Id);
        req.addParameter('safra', '20/21');
        req.addParameter('marca', 'BRMX');    

        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;

        ProductsA1Api.restGetDataAppendix1();

        Test.stopTest();

        WrapperAppendix1 parsedResp = (WrapperAppendix1) JSON.deserialize( RestContext.response.responseBody.toString(), WrapperAppendix1.class);
        System.assertEquals(parsedResp.mapaCategoriaOriginal.isEmpty(),true);      
    }
    
    
    public static Account crearCuenta()
    {
    	Account a = new Account();
        a.Name = 'test';
		insert a;     
        return(a);
    }
}
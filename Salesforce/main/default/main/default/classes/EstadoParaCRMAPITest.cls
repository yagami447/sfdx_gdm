@isTest
public class EstadoParaCRMAPITest {

    @isTest
    public static void getListaDeEstadosTestPositive() {
        
        EstadoParaCRMAPI.EstadoParaCRMAPIResponse result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/EstadoParaCRMAPI/';  
        req.httpMethod = 'GET';
        
        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;
        
        test.startTest();
        EstadoParaCRMAPI.listarEstados();
        test.stopTest();
        
        result = (EstadoParaCRMAPI.EstadoParaCRMAPIResponse)JSON.deserialize(resp.responseBody.toString(), EstadoParaCRMAPI.EstadoParaCRMAPIResponse.class);
        System.assert(result.status);
        System.assertEquals(Label.EstadoParaCRMAPI_Success_Message, result.message);
    }
}
@IsTest
public class CrearFacturaSoapMOCK {
    
    public class CrearFacturaSoapSuccessfullyMOCK implements WebServiceMock{
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
                CrearFacturaSoap.ZcaCrearFacturaArResponse_element respElement = 
                    new CrearFacturaSoap.ZcaCrearFacturaArResponse_element();
                respElement.TResponse = new CrearFacturaSoap.TableOfBapiret2();
                respElement.TResponse.item = new List<CrearFacturaSoap.Bapiret2>();
                respElement.TResponse.item.add(new CrearFacturaSoap.Bapiret2());
                respElement.TResponse.item[0].Message = 'Mock response';
                respElement.TResponse.item[0].Type_x  = 'C';
                response.put('response_x', respElement); 
            }    
    }
    
    public class CrearFacturaSoapErrorMOCK implements WebServiceMock{
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
                CrearFacturaSoap.ZcaCrearFacturaArResponse_element respElement = 
                    new CrearFacturaSoap.ZcaCrearFacturaArResponse_element();
                respElement.TResponse = new CrearFacturaSoap.TableOfBapiret2();
                respElement.TResponse.item = new List<CrearFacturaSoap.Bapiret2>();
                respElement.TResponse.item.add(new CrearFacturaSoap.Bapiret2());
                respElement.TResponse.item[0].Message = 'ERROR SAP';
                respElement.TResponse.item[0].Type_x  = 'E';
                response.put('response_x', respElement); 
            }    
    }
}
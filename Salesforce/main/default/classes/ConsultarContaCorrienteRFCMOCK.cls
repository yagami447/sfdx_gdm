@IsTest
public class ConsultarContaCorrienteRFCMOCK {
	public class ConsultarContaCorrienteRFCSuccessfullyMOCK implements WebServiceMock{
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
                ConsultarContaCorriente.ZcaConsultaFbl5nResponse_element respElement = 
                    new ConsultarContaCorriente.ZcaConsultaFbl5nResponse_element();
                respElement.EtPos = new ConsultarContaCorriente.ZetfiFbl5n();
                respElement.EtPos.item = new List<ConsultarContaCorriente.ZefiFbl5n>();
                respElement.EtPos.item.add(new ConsultarContaCorriente.ZefiFbl5n());
                respElement.EtPos.item[0].Jamon = 'Hay jamon, compre';
                response.put('response_x', respElement); 
            }
    }
    
    public class ConsultarContaCorrienteRFCErrorMOCK implements WebServiceMock{
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
                ConsultarContaCorriente.ZcaConsultaFbl5nResponse_element respElement = 
                    new ConsultarContaCorriente.ZcaConsultaFbl5nResponse_element();
                respElement.EtPos = new ConsultarContaCorriente.ZetfiFbl5n();
                respElement.EtPos.item = new List<ConsultarContaCorriente.ZefiFbl5n>();
                respElement.EtPos.item.add(new ConsultarContaCorriente.ZefiFbl5n());
                respElement.EtPos.item[0].Jamon = 'NO Hay jamon!!';
                response.put('response_x', respElement); 
            }
    }
}
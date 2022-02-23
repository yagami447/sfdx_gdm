@IsTest
public class sapHistorialDePedidosSoapFunctionsMOCK {
	public class sapHistorialDePedidosSoapFunctionsSuccessfullyMOCK implements WebServiceMock{
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
                sapHistorialDePedidosSoapFunctionsMcS.ZMmHistorialPedidoResponse_element respElement = 
                    new sapHistorialDePedidosSoapFunctionsMcS.ZMmHistorialPedidoResponse_element();
                respElement.PoItems = new sapHistorialDePedidosSoapFunctionsMcS.TableOfZmmPoItems();
                respElement.PoItems.item = new List<sapHistorialDePedidosSoapFunctionsMcS.ZmmPoItems>();
                respElement.PoItems.item.add( new sapHistorialDePedidosSoapFunctionsMcS.ZmmPoItems());
                respElement.PoItems.item[0].Material = '000000000012345678';
                respElement.PoItems.item[0].PoQty = '1';
                respElement.PoItems.item[0].DelivQty = '1';
                respElement.PoItems.item[0].IvQty = '1';
                respElement.PoItems.item[0].PoUnit = 'a';
                
                response.put('response_x', respElement); 
            }
    }
    
    public class sapHistorialDePedidosSoapFunctionsErrorMOCK implements WebServiceMock{
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
                sapHistorialDePedidosSoapFunctionsMcS.ZMmHistorialPedidoResponse_element respElement = 
                    new sapHistorialDePedidosSoapFunctionsMcS.ZMmHistorialPedidoResponse_element();/*
                respElement.EtPos = new ConsultarContaCorriente.ZetfiFbl5n();
                respElement.EtPos.item = new List<ConsultarContaCorriente.ZefiFbl5n>();
                respElement.EtPos.item.add(new ConsultarContaCorriente.ZefiFbl5n());
                respElement.EtPos.item[0].Jamon = 'NO Hay jamon!!';*/
                response.put('response_x', respElement); 
            }
    }
}
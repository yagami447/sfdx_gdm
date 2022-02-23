public class ProductHelper 
{
	public static WrapperAppendix1 getDataAppendix1(String accountId, String safra, String marca) 
    {
        FactoryManejador factory = new FactoryManejador();

        ManejadorAnexoI manejador = (ManejadorAnexoI)factory.devuelveManejador('Anexo I', accountId, 
        aAppManager.calcularSafraAnterior(safra), marca);
        
        manejador.cargarItemsContrato(accountId, safra, marca);
        manejador.setearMapas(); 
        manejador.sacarVariedadesRebajadas();
        
        WrapperAppendix1 response = new WrapperAppendix1(manejador.nombreVariedadPorId,manejador.mapaCategoriaOriginal);
        
        return response;
        
    }
}
@isTest
private class WrapperAppendix1Test 
{
    @isTest
	public static void testCreation()
    {
        Map<String,String> nombreVariedadPorId = new Map<String,String>();
        Map<String,List<String>> mapaCategoriaOriginal = new  Map<String,List<String>>();
        
        List<String> categorias = new List<String>{'a','b'};
        
        mapaCategoriaOriginal.put('1',categorias);
        nombreVariedadPorId.put('basica','1');
            
        WrapperAppendix1 wp = new WrapperAppendix1(nombreVariedadPorId,mapaCategoriaOriginal);
    }
}
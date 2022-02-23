@isTest
private class ProductHelperTest 
{
    @isTest
	public static void testEmpty()
    {
        Test.startTest();
        Account acc = crearCuenta();
    	WrapperAppendix1 data = ProductHelper.getDataAppendix1(acc.Id, '19/20', 'BMRX'); 	
        Test.stopTest();
        
        System.assertEquals(data.mapaCategoriaOriginal.isEmpty(),true);
    }
    
    public static Account crearCuenta()
    {
    	Account a = new Account();
        a.Name = 'test';
		insert a;     
        return(a);
    }
}
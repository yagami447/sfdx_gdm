@IsTest
public class sapHistorialDePedidosSoapFunctionsTest {

    static{
        Test.setMock(WebServiceMock.class, new sapHistorialDePedidosSoapFunctionsMOCK.sapHistorialDePedidosSoapFunctionsSuccessfullyMOCK());
        Configuracion_BMX__c endpointConfig = Build.aConfiguracionBMX()
            .withName('Test')
            .withLinkSapQa('gdmdev.dyndns.org:8000')
            .build();

        insert endpointConfig;
	}

	@IsTest
    public static void constructorTest(){
        //Inicialización y carga de datos
        sapHistorialDePedidosSoapFunctions controller;
        //Test
        Test.startTest();
        controller = new sapHistorialDePedidosSoapFunctions();
        Test.stopTest();
        //ASSERTS
        System.assertNotEquals(null, controller.environmentVariables);
        System.assertNotEquals(null, controller.PoItems);
        System.assertNotEquals(null, controller.Return_x);
    }

    @IsTest
    public static void CheckExistingOrderTest(){
        //Inicialización y carga de datos
        List<PricebookEntry> pricebookEntrys = [
            SELECT  Id, Pricebook2.Name, Product2.Codigo_Material_SAP__c,
                    Product2.CANTIDAD_SUB_UNIDAD__c
            FROM PricebookEntry 
            WHERE Pricebook2.Name =  'Lista de precios estándar'
        ];
        System.debug('pricebookEntrys: '+pricebookEntrys);
        System.debug([SELECT Id FROM Pricebook2 WHERE Name =  'Lista de precios estándar']);
        List<Order> result = new List<Order>();
        Account cuenta = Build.anAccount()
            .withName('cuenta')
            .build();
        insert cuenta;

        Order ofertaInterna = Build.anOrder()
            .withNumeroPedidoSAP('4500298692')
            .withstatus('Edição')
            .withAccountId(cuenta)
            .build();
        insert ofertaInterna;
        //Test
        Test.startTest();
        result = sapHistorialDePedidosSoapFunctions.CheckExistingOrder('4500298692');
        Test.stopTest();
        //ASSERTS
        System.assertNotEquals(null, result);
        System.assertEquals('4500298692', result[0].Numero_Pedido_SAP__C);
    }

    @IsTest
    public static void GenerateOrderTest(){
        //Inicialización y carga de datos
        Id result;
        Account cuenta = Build.anAccount()
            .withName('ASOCIADOS DON MARIO S.A.')
            .build();
        insert cuenta;
        
        Pricebook2 listaDePrecio = Build.aPricebook2()
            .withName('Lista de precios estándar')
            .build();
        insert listaDePrecio;
        //Test
        Test.startTest();
        result = sapHistorialDePedidosSoapFunctions.GenerateOrder('4500298692');
        
        Test.stopTest();
        //ASSERTS
        Order ofertaInterna = [SELECT Id FROM Order LIMIT 1];
        System.assertNotEquals(null, result);
        System.assertEquals(ofertaInterna.Id, result);
    }

    @IsTest
    public static void GenerateOrderWithProductsTest(){
        //Inicialización y carga de datos
        Id result;
        Account cuenta = Build.anAccount()
            .withName('ASOCIADOS DON MARIO S.A.')
            .build();
        insert cuenta;

        //Pricebook2 standardPB = [SELECT id FROM Pricebook2 WHERE isStandard=true];
        
        Pricebook2 listaDePrecio = Build.aPricebook2()
            .withName('Lista de precios estándar')
            .withIsActive(true)
            .build();
        insert listaDePrecio;

        Product2 producto = Build.aProduct2()
            .withIsActive(true)
            .withName('prod1')
            .withCodMaterialSAP('12345678')
            .withCantSubUnidad('10')
            .build();
        insert producto;

        PricebookEntry standarPBE = Build.aPricebookEntry()
            .withPricebook2Id(Test.getStandardPricebookId())
            .withUnitPrice(1)
            .withIsActive(true)
            .withProduct2Id(producto)
            .build();
        insert standarPBE;

        PricebookEntry entradaListaPrecio = Build.aPricebookEntry()
            .withPricebook2Id(listaDePrecio)
            .withUnitPrice(1)
            .withIsActive(true)
            .withProduct2Id(producto)
            .build();
        insert entradaListaPrecio;
        
        //Test
        Test.startTest();
        result = sapHistorialDePedidosSoapFunctions.GenerateOrder('4500298692');
        
        Test.stopTest();
        //ASSERTS
        List<OrderItem> ofertaInterna = [
            SELECT  Id,quantidade_da_ordem__c,unidade_da_ordem__c
            FROM OrderItem 
            WHERE OrderId = :result
        ];
        System.assertNotEquals(null, result);
        System.assertEquals( 10 , ofertaInterna[0].quantidade_da_ordem__c);
        System.assertEquals( 'a' , ofertaInterna[0].unidade_da_ordem__c);
    }
}
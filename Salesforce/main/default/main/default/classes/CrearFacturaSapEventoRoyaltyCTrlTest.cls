@IsTest
public class CrearFacturaSapEventoRoyaltyCTrlTest {
    
    static Evento_Royalty__c eventoRoyalty; 
    
    static {
        Configuracion_BMX__c endpointConfig = Build.aConfiguracionBMX()
            .withName('Test')
            .withLinkSapQa('gdmdev.dyndns.org:8000')
            .build();
        insert endpointConfig;
        
        Account cuenta = Build.anAccount().build();
        insert cuenta;
        
        Saldo_por_safra__c saldoPorSafra = Build.aSaldoPorSafra()
            .withAccount(cuenta)
            .withSafra('19/20')
            .build();
        insert saldoPorSafra;
        
        eventoRoyalty = Build.anEventoRoyalty()
            .withCuenta(cuenta)
            .withSaldoPorSafra(saldoPorSafra)
            .withValor(1)
            .build();
        
        insert eventoRoyalty;
        
        Test.setMock(WebServiceMock.class, new CrearFacturaSoapMOCK.CrearFacturaSoapSuccessfullyMOCK());
    }
    
    
    @IsTest
    public static void constructorTest(){
        //Inicialización y carga de datos
        ApexPages.StandardController standarController = new ApexPages.StandardController(eventoRoyalty);
        //Test
        Test.startTest();
        CrearFacturaSapEventoRoyaltyCntroller controller = new CrearFacturaSapEventoRoyaltyCntroller(standarController);
        Test.stopTest();
        //ASSERTS
        System.assertEquals( eventoRoyalty.id , controller.idCurrentRecord );
    }
    
    @IsTest
    public static void enviarASapTestSuccessfully(){
        //Inicialización y carga de datos
        ApexPages.StandardController standarController = new ApexPages.StandardController(eventoRoyalty);
        CrearFacturaSapEventoRoyaltyCntroller controller = new CrearFacturaSapEventoRoyaltyCntroller(standarController);
        //Test
        Test.startTest();
        Pagereference page = controller.enviarASap();
        Test.stopTest();
        //ASSERTS
        System.debug('mensaje: '+ ApexPages.getMessages() );
        //System.assertEquals( true , ApexPages.hasMessages(ApexPages.SEVERITY.CONFIRM) );
    }
    
    @IsTest
    public static void dummyTest(){
        //Inicialización y carga de datos
        ApexPages.StandardController standarController = new ApexPages.StandardController(eventoRoyalty);
        CrearFacturaSapEventoRoyaltyCntroller controller = new CrearFacturaSapEventoRoyaltyCntroller(standarController);
        //Test
        Test.startTest();
        Pagereference page = controller.dummy();
        System.debug('page: '+page.getUrl() );
        Test.stopTest();
        //ASSERTS
        System.assertEquals( true, page.getRedirect() );
    }    
}
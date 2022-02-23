@IsTest
public class ConsultarContaCorrienteRFCTest {

    static{
        Test.setMock(WebServiceMock.class, new ConsultarContaCorrienteRFCMOCK.ConsultarContaCorrienteRFCSuccessfullyMOCK());
        Configuracion_BMX__c endpointConfig = Build.aConfiguracionBMX()
            .withName('Test')
            .withLinkSapQa('gdmdev.dyndns.org:8000')
            .build();

        insert endpointConfig;
    }

    @IsTest
    public static void constructorTest(){
        //Inicialización y carga de datos
        ConsultarContaCorrienteRFC adapter;
        //Test
        Test.startTest();
        adapter = new ConsultarContaCorrienteRFC();
        Test.stopTest();
        //ASSERTS
        System.assertNotEquals(null, adapter.environmentVariables);
        System.assertEquals('X', adapter.IApar);
        System.assertEquals('01BR', adapter.IBukrs);
        System.assertEquals('00:00:00', adapter.IHoraD);
        System.assertEquals('00:00:00', adapter.IHoraH);
        System.assertEquals('X', adapter.INorm);
        System.assertEquals(String.valueOf(System.today()), adapter.IStida);
        System.assertEquals('X', adapter.IUmskz);        
    }

    @IsTest
    public static void startRequestTest(){
        //Inicialización y carga de datos
        Account cuenta = Build.anAccount().build();
        insert cuenta;
        ConsultarContaCorrienteRFC adapter = new ConsultarContaCorrienteRFC();
        //Test
        Test.startTest();
        adapter.startRequest(cuenta.Id);
        Test.stopTest();
        //ASSERTS
        System.assertEquals('Hay jamon, compre', adapter.result.item[0].Jamon );
    }

    @IsTest
    public static void DebeCargarseIKunnrD_ConCodigoSapDeAccount(){
        //Inicialización y carga de datos
        Account cuenta = Build.anAccount()
            .withCodigoSAP('6000000077')
            .build();
        insert cuenta;
        ConsultarContaCorrienteRFC adapter = new ConsultarContaCorrienteRFC();
        //Test
        Test.startTest();
        adapter.startRequest(cuenta.Id);
        Test.stopTest();
        //ASSERTS
        System.assertEquals('6000000077', adapter.IKunnrD );
    }
}
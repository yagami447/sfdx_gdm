@isTest
public class CrearFacturaConverterTest {

    static {
        Configuracion_BMX__c endpointConfig = Build.aConfiguracionBMX()
            .withName('Test')
            .withLinkSapQa('gdmqas.dyndns.org:8000')
            .build();

        insert endpointConfig;
    }

    @IsTest
    public static void constructorTest(){
        //Inicializacion y carga de datos
        CrearFacturaConverter converter;
        //Test
        Test.startTest();
        converter = new CrearFacturaConverter();
        Test.stopTest();
        //ASSERTS
        System.assertEquals('', converter.CodigoSAP);
        System.assertEquals('', converter.Safra);
        System.assertEquals('', converter.ValorPositivo);
        System.assertEquals('', converter.ValorNegativo);
        System.assertNotEquals(null, converter.environmentVariables);
    }

    @IsTest
    public static void cargarDocHeaderZcasDocHeaderArTest(){
        //Inicializacion y carga de datos
        CrearFacturaConverter converter = new CrearFacturaConverter();
        //Test
        Test.startTest();
        converter.cargarDocHeader();
        Test.stopTest();
        //ASSERTS
        System.assertEquals( 
            converter.environmentVariables.DocHeader_BusAct__c , 
            converter.DocHeader.BusAct
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Username__c , 
            converter.DocHeader.Username
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_CompCode__c , 
            converter.DocHeader.CompCode
        );
        System.assertEquals( 
            String.valueOf(System.today()) , 
            converter.DocHeader.DocDate
        );
        System.assertEquals( 
            String.valueOf(System.today()) , 
            converter.DocHeader.PstngDate
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_DocType__c , 
            converter.DocHeader.DocType
        );
        System.assertNotEquals( null , converter.DocHeader.Item );
        System.assertNotEquals( null , converter.DocHeader.Receivable );
        System.assertNotEquals( null , converter.DocHeader.Currency_x );
    }

    @IsTest
    public static void cargarDocHeaderZcasDocItemArTest(){
        //Inicializacion y carga de datos
        CrearFacturaConverter converter = new CrearFacturaConverter();
        //Test
        Test.startTest();
        converter.cargarDocHeader();
        Test.stopTest();
        //ASSERTS
        
        System.assert(converter.DocHeader.Item.item.size() > 0 );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Item_item0_ItemnoAcc__c , 
            converter.DocHeader.Item.item[0].ItemnoAcc
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Item_item0_GlAccount__c , 
            converter.DocHeader.Item.item[0].GlAccount
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Item_item0_ItemText__c , 
            converter.DocHeader.Item.item[0].ItemText
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Item_item0_Quantity__c , 
            converter.DocHeader.Item.item[0].Quantity
        );
    }

    @IsTest
    public static void cargarDocHeaderZcasReceivableItemTest(){
        //Inicializacion y carga de datos
        CrearFacturaConverter converter = new CrearFacturaConverter();
        //Test
        Test.startTest();
        converter.cargarDocHeader();
        Test.stopTest();
        //ASSERTS
        
        System.assert(converter.DocHeader.Receivable.item.size() > 0 );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Receivable_item0_ItemnoAcc__c , 
            converter.DocHeader.Receivable.item[0].ItemnoAcc
        );
        System.assertEquals( 
            converter.CodigoSAP , 
            converter.DocHeader.Receivable.item[0].Customer
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Receivable_item0_Pmnttrms__c , 
            converter.DocHeader.Receivable.item[0].Pmnttrms
        );
        System.assertEquals( 
            String.valueOf(System.today()) , 
            converter.DocHeader.Receivable.item[0].BlineDate
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Receivable_item0_AllocNmbr__c +' '+ converter.Safra , 
            converter.DocHeader.Receivable.item[0].AllocNmbr
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Receivable_item0_ItemText__c , 
            converter.DocHeader.Receivable.item[0].ItemText
        );
    }

    @IsTest
    public static void cargarDocHeaderZcasCurrencyAmountArTest(){
        //Inicializacion y carga de datos
        CrearFacturaConverter converter = new CrearFacturaConverter();
        //Test
        Test.startTest();
        converter.cargarDocHeader();
        Test.stopTest();
        //ASSERTS
        
        System.assert(converter.DocHeader.Currency_x.item.size() == 2 );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Currency_x_item0_ItemnoAcc__c , 
            converter.DocHeader.Currency_x.item[0].ItemnoAcc
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Currency_x_item0_Currency_x__c , 
            converter.DocHeader.Currency_x.item[0].Currency_x
        );
        System.assertEquals( 
            converter.ValorPositivo , 
            converter.DocHeader.Currency_x.item[0].AmtDoccur
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Currency_x_item1_ItemnoAcc__c , 
            converter.DocHeader.Currency_x.item[1].ItemnoAcc
        );
        System.assertEquals( 
            converter.environmentVariables.DocHeader_Currency_x_item1_Currency_x__c, 
            converter.DocHeader.Currency_x.item[1].Currency_x
        );
        System.assertEquals( 
            converter.ValorNegativo , 
            converter.DocHeader.Currency_x.item[1].AmtDoccur
        );
    }
}
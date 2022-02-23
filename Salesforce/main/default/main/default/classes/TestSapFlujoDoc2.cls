/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestSapFlujoDoc2 {
    //TEST DE CLASE A PARTIR DEL WSDL sapFlujoDoc
    @isTest(seeAllData=true)
    public static void test_sapFlujoDoc2(){
    Integer mandanteSAP = 1;
    Configuracion_BMX__c c = new Configuracion_BMX__c(FC_Mandante_SAP__c='300'); 
    //Configuracion_BMX__c c = [Select FC_Mandante_SAP__c From Configuracion_BMX__c Where Name = 'Facturacion' limit 1];
    mandanteSAP = Integer.valueOf(c.FC_Mandante_SAP__c);
    sapFlujoDoc2.ZSSD_FLUJO_DOC a = New sapFlujoDoc2.ZSSD_FLUJO_DOC();
    sapFlujoDoc2.ZSD_FLUJO_DOC_2Response_element b = New sapFlujoDoc2.ZSD_FLUJO_DOC_2Response_element();
    //sapFlujoDoc2.ZsdFlujoDoc_element c = New sapFlujoDoc2.ZsdFlujoDoc_element();
    sapFlujoDoc2.TABLE_OF_ZSSD_FLUJO_DOC d = New sapFlujoDoc2.TABLE_OF_ZSSD_FLUJO_DOC();
    sapFlujoDoc2.ZSD_FLUJO_DOC_2 e = New sapFlujoDoc2.ZSD_FLUJO_DOC_2();
    sapFlujoDoc2.isApexTest = true;
    e.ZSD_FLUJO_DOC_2(d,'','','','','','','',mandanteSAP);
    }
}
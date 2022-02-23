@isTest
public with sharing class UtilsTest {

    @testSetup static void setup() {
        Configuracion_BMX__c configuracionBMX = new Configuracion_BMX__c();
        configuracionBMX.FC_Mandante_SAP__c = 'TEST';

        insert configuracionBMX;
    }

    @isTest static void testGetSAPCredentialsBase64Encoded() {
        SAP_environment_variables__mdt SAPEnviromentMtd = [
                SELECT
                Username__c,
                Password__c
            FROM
                SAP_environment_variables__mdt];

        String stringToBlob = SAPEnviromentMtd.Username__c + ':' + SAPEnviromentMtd.Password__c;
        Blob hash = Blob.valueOf(stringToBlob);
        String expectedCredentials = EncodingUtil.base64Encode(hash);

        Test.startTest();
        String result = Utils.getSAPCredentialsBase64Encoded();
        Test.stopTest();

        system.assertequals(expectedCredentials, result, 'The result doesnt match the expected result');
    }

    @isTest static void testGetSAPEnvTarget() {
        String expectedResult = 'TEST';

        Test.startTest();
        String result = Utils.getSAPEnvTarget();
        Test.stopTest();

        system.assertequals(expectedResult, result, 'The result doesnt match the expected result');
    }

    
    /**
     *  METHOD:         testGetFieldValues 
     *  DESCRIPTION:    test method for Utils.getFieldValues
     *  AUTHOR:         irina.benitez@cloudgaia.com (26-ago-21)
     **/ 
    @isTest
    static void testGetFieldValues() {

        String targetObject = 'Configuracion_BMX__c';
        List<String> listOfFields = new List<String>{'Id', 'FC_Mandante_SAP__c'};
        List<SObject> result;

        test.startTest();
        result = Utils.getFieldValues(targetObject, listOfFields, null, null);
        test.stopTest();

        System.assertEquals('TEST', result[0].get(listOfFields[1]), 'The result doesnt match the expected result');

    }

    /**
     *  METHOD:         testGetFieldValuesAura 
     *  DESCRIPTION:    test method for Utils.getFieldValuesAura
     *  AUTHOR:         irina.benitez@cloudgaia.com (26-ago-21)
     **/ 
    @isTest
    static void testGetFieldValuesAura() {

        String targetObject = 'Configuracion_BMX__c';
        List<String> listOfFields = new List<String>{'Id', 'FC_Mandante_SAP__c'};
        List<SObject> result;

        test.startTest();
        result = Utils.getFieldValuesAura(targetObject, listOfFields, null, null);
        test.stopTest();

        System.assertEquals('TEST', result[0].get(listOfFields[1]), 'The result doesnt match the expected result');

    }

    /**
     *  METHOD:         testGetFieldValuesFullAura 
     *  DESCRIPTION:    test method for Utils.getFieldValuesAura w/ all parameters
     *  AUTHOR:         irina.benitez@cloudgaia.com (1-sep-21)
     **/ 
    @isTest
    static void testGetFieldValuesFullAura() {

        String targetObject = 'Configuracion_BMX__c';
        List<String> listOfFields = new List<String>{'Id', 'FC_Mandante_SAP__c'};
        String filter = 'FC_Mandante_SAP__c = \'TEST\'';
        String orderBy = 'Id';
        List<SObject> result;

        test.startTest();
        result = Utils.getFieldValuesAura(targetObject, listOfFields, filter, orderBy);
        test.stopTest();

        System.assertEquals('TEST', result[0].get(listOfFields[1]), 'The result doesnt match the expected result');

    }
}
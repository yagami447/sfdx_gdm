public with sharing class Utils {
    
    public static String getSAPCredentialsBase64Encoded() {

        SAP_environment_variables__mdt SAPEnviromentMtd = [
                SELECT
                Username__c,
                Password__c
            FROM
                SAP_environment_variables__mdt];

            String stringToBlob = SAPEnviromentMtd.Username__c + ':' + SAPEnviromentMtd.Password__c;
            Blob hash = Blob.valueOf(stringToBlob);
            String credentials = EncodingUtil.base64Encode(hash);

            return credentials;
    }

    public static String getSAPEnvTarget() {

        Configuracion_BMX__c configuracionBMX = [SELECT FC_Mandante_SAP__c FROM Configuracion_BMX__c LIMIT 1];

        return configuracionBMX.FC_Mandante_SAP__c;
    }

     /**
     *  METHOD:         getFieldValuesAura 
     *  PARAMETERS:     recordId: API Name of the object to query, 
     *                  fields: API Name of the fields to query, 
     *                  filter: WHERE clause condition (optional),
     *                  orderyBy: API Name of the field to Order by Asc
     *  DESCRIPTION:    Utility AuraEnabled method for queries
     *  AUTHOR:         irina.benitez@cloudgaia.com (26-ago-21)
     **/ 

    @AuraEnabled(cacheable=true)
    public static List<SObject> getFieldValuesAura(String recordId, List<String> fields, String filter, String orderBy) {
        return getFieldValues(recordId, fields, filter, orderBy);
    }


    /**
     *  METHOD:         getFieldValues 
     *  PARAMETERS:     recordId: API Name of the object to query, 
     *                  fields: API Name of the fields to query, 
     *                  filter: WHERE clause condition (optional),
     *                  orderyBy: API Name of the field to Order by Asc
     *  DESCRIPTION:    Utility method for queries
     *  AUTHOR:         irina.benitez@cloudgaia.com (26-ago-21)
     **/ 
    
    public static List<SObject> getFieldValues(String recordId, List<String> fields, String filter, String orderBy) {

        List<SObject> sObjList;
        String query = 'SELECT Id';

        for(String field : fields) {

            if( !query.contains(field) ) {

                query += ', ' + field;
            }
        }

        query += ' FROM ' + recordId;

        if(filter != null) {

            query += ' WHERE ' + filter;
        }

        if(orderBy != null) {

            query += ' ORDER BY ' + orderBy + ' ASC';
        }

        sObjList = Database.query(query);

        return sObjList;
    }
}
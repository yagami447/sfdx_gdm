@RestResource(urlMapping='/CRMAPI/*')
global with sharing class CRMAPI {
    
    /**
     *  SUBCLASS:       Response
     *  DESCRIPTION:    wrapper class for CRM API response. Created for US #14316 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
    }

    /**
     *  METHOD:         getNewCRMIsValid 
     *  PARAMETERS:     safra: safra of the CRM
     *                  marca: brand of the CRM
     *                  cuenta: account linked to the CRM
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *  DESCRIPTION:    Evaluates if a specific type of CRM can be created today. Created for US #14316 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
     **/ 
    @HttpGet
    global static void getNewCRMIsValid() {

        String safra = RestContext.request.params.get('safra');
        String marca = RestContext.request.params.get('marca');
        String cuenta = RestContext.request.params.get('cuenta');
        //String campania = RestContext.request.params.get('campania');

        RestResponse response = RestContext.response;
        response.statusCode = 400;

        Response result = new Response();
        result.status = false;
        result.message = Label.CRMAPI_Default_Error_Message;
        
        Boolean checkDate = false;
        String startSettings;
        String endSettings;

        try {

            List<Resumo_da_conta__c> existingCRM = [SELECT Id, Name FROM Resumo_da_conta__c WHERE Multiplicador__c = :cuenta AND Marca__c = :marca AND Safra__c = :safra];

            if (existingCRM == null || existingCRM.isEmpty()) {

                Configuracion_BMX__c configuracion = [SELECT Data_Inicial_CRM__c, Data_Final_CRM__c FROM Configuracion_BMX__c LIMIT 1];

                Date today = System.today();

                if(configuracion.Data_Inicial_CRM__c == null || configuracion.Data_Final_CRM__c == null) {
                    result.message = Label.CRMAPI_Bad_Setting_Error_Message;
                } else {
                    checkDate = validateDate(today, configuracion.Data_Inicial_CRM__c, configuracion.Data_Final_CRM__c);
                }
            } else {
                result.message = Label.CRMAPI_CRM_Created_Error_Message;
            }


        } catch (Exception exc) {
            result.message = exc.getMessage();
        }
                
        if(checkDate) {
            result.status = true;
            result.message = Label.CRMAPI_Success_Message;
            response.statusCode = 200;
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }


    /**
     *  METHOD:         validateDate 
     *  PARAMETERS:     dateToCheck: date to validate against settings
     *                  startDateString: start date from settings
     *                  endDateString: end date from settings
     *  RETURN:         String: returns either 'success' or an error message
     *  DESCRIPTION:    Returns if its possible to create a new Stock on date provided. Created for US #14316 
     *  AUTHOR:         irina.benitez@cloudgaia.com (18-nov-21)
     **/ 
    global static Boolean validateDate(Date dateToCheck, String startDateString, String endDateString) {

        Boolean result = false;

        if( startDateString == null || endDateString == null) {
            return false;
        }

        Integer endYear = dateToCheck.year();

        List<String> startDateList = startDateString.split('/');
        List<String> endDateList = endDateString.split('/');

        // If start Date > end Date ==> end Year = start Year + 1
        if( Integer.valueOf(startDateList.get(1)) > Integer.valueOf(endDateList.get(1)) 
                || (startDateList.get(1).equals(endDateList.get(1)) && Integer.valueOf(startDateList.get(0)) >= Integer.valueOf(endDateList.get(0)) ) ) {
            endYear = endYear + 1;
        }
        Date startDate = Date.newInstance( dateToCheck.year(), Integer.valueOf(startDateList.get(1)), Integer.valueOf(startDateList.get(0)) );
        Date endDate = Date.newInstance( endYear, Integer.valueOf(endDateList.get(1)), Integer.valueOf(endDateList.get(0)) );

        if ( dateToCheck >= startDate && dateToCheck <= endDate ) {
            result = true;
        }

        return result;
    }

}
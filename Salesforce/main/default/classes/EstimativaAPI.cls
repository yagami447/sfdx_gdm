@RestResource(urlMapping='/EstimativaAPI/*')
global without sharing class EstimativaAPI {
    
    public static final String SUCCESSMESSAGE = 'Os dados estão corretos, você pode criar a estimativa';
    public static final String ERRORCAMPOSNULOSMILHO = 'Os campos Data_Initial_Estimative_Milho__c e Data_Final_Estimative_Milho__c em Configuration_BMX__c não podem ser nulos';
    public static final String ERRORCAMPOSNULOSSOJA = 'Os campos Data_Inicial_Estimativa_Soja__c e Data_Final_Estimativa_Soja__c em Configuration_BMX__c não podem ser nulos';
    public static final String ERRORFUERADEFECHA = 'Deve estar entre as datas ';
    /** 
     *  METHOD:         doGet 
     *  PARAMETERS:     -
     *  RETURN:         Boolean
     *  DESCRIPTION:    Calls validateDateNewEstimativa method with today's date. Created for US #10309 
     *  AUTHOR:         irina.benitez@cloudgaia.com (06-sept-21)
     **/ 
    @HttpGet
    global static void doGet() {

        /** Agregado por Jhonny Peroza 
         *  US-13218 VB Estimativa - Criar: The culture field is added to separate the logic of Milho and Soja.
         *  updated 04-11-2021
         **/

        String cultura = RestContext.request.params.get('cultura');

        RestResponse response = RestContext.response;
        Response result = new Response();       

        try {

            Map<Boolean, String> resp = validateDateNewEstimativa(cultura, System.today());
            List<Boolean> resultToShow = new List<Boolean>(resp.keySet());


            if(resultToShow[0] == true) {

                
                result.status = resultToShow[0];              
                result.message = SUCCESSMESSAGE;
                response.statusCode = 200;
                
            } else {

                
                result.status = resultToShow[0];
                result.message = resp.get(resultToShow[0]);
                response.statusCode = 200;
  
            }

        } catch (Exception e) {

            result.message = e.getMessage();
            response.statusCode = 400;
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));

    }

    /**
     *  METHOD:         validateDateNewEstimativa 
     *  PARAMETERS:     dateToCheck: date to validate against settings
     *  RETURN:         Boolean
     *  DESCRIPTION:    Returns if its possible to create a new Estimativa Milho on date provided. Created for US #10309 
     *  AUTHOR:         irina.benitez@cloudgaia.com (06-sept-21)
     * 
     *  UPDATED:        pablo.fraquia@cloudgaia.com (30-dic-21)
     **/ 

    global static Map<Boolean,String> validateDateNewEstimativa(String cultura, Date dateToCheck) {

        Map<Boolean, String> messageByBoolean = new Map<Boolean, String>();

        /** Agregado por Jhonny Peroza 
         *  US-13218 VB Estimativa - Criar: The fields related to Soy are added in the query to the Configuracion_BMX__c object and the Soy logic is included, separating the cases according to the culture
         *  updated 04-11-2021
         **/

        Configuracion_BMX__c EstimativaSettings = [ SELECT Id, Data_Inicial_Estimativa_Milho__c, Data_Final_Estimativa_Milho__c, Data_Inicial_Estimativa_Soja__c, Data_Final_Estimativa_Soja__c
                                                    FROM Configuracion_BMX__c 
                                                    LIMIT 1];


        if(cultura == 'Milho' || cultura == 'MILHO') {

            if( EstimativaSettings.Data_Inicial_Estimativa_Milho__c == null || EstimativaSettings.Data_Final_Estimativa_Milho__c == null) {

                messageByBoolean.put(false, ERRORCAMPOSNULOSMILHO);
                
            } else {
                
                checkDates(EstimativaSettings.Data_Inicial_Estimativa_Milho__c.split('/'), EstimativaSettings.Data_Final_Estimativa_Milho__c.split('/'), dateToCheck, messageByBoolean);
            }
        }

        if(cultura == 'Soja' || cultura == 'SOJA') {

            if( EstimativaSettings.Data_Inicial_Estimativa_Soja__c == null || EstimativaSettings.Data_Final_Estimativa_Soja__c == null) {

                messageByBoolean.put(false, ERRORCAMPOSNULOSSOJA);

            } else {
                
                checkDates(EstimativaSettings.Data_Inicial_Estimativa_Soja__c.split('/'), EstimativaSettings.Data_Final_Estimativa_Soja__c.split('/'), dateToCheck, messageByBoolean);
            }
        }
        
        return messageByBoolean;
    }

    private static void checkDates(List<String> startEstimativa, List<String> endEstimativa, Date dateToCheck, Map<Boolean, String> messageByBoolean){

            Integer endYear = dateToCheck.year();

            // If start Date > end Date ==> end Year = start Year + 1
            if( Integer.valueOf(startEstimativa.get(1)) > Integer.valueOf(endEstimativa.get(1)) 
                    || (startEstimativa.get(1).equals(endEstimativa.get(1)) && Integer.valueOf(startEstimativa.get(0)) >= Integer.valueOf(endEstimativa.get(0)) ) ) {
                endYear = endYear + 1;
            }
            Date startDate = Date.newInstance( dateToCheck.year(), Integer.valueOf(startEstimativa.get(1)), Integer.valueOf(startEstimativa.get(0)) );
            Date endDate = Date.newInstance( endYear, Integer.valueOf(endEstimativa.get(1)), Integer.valueOf(endEstimativa.get(0)) );

            if ( dateToCheck >= startDate && dateToCheck <= endDate ) {

                messageByBoolean.put(true, '');

            }else{

                messageByBoolean.put(false, ERRORFUERADEFECHA +startDate.Day() +'/' +startDate.Month() +'/' +startDate.Year() +'  e  ' +endDate.Day() +'/' +endDate.Month() +'/' +endDate.Year());

            }

    }

    /** Agregado por Jhonny Peroza 
     *  US-13218 VB Estimativa - Criar: The API will no longer return a boolean, it will now return an id, a status and the corresponding message
     *  updated 04-11-2021
     **/
    public class Response {
        public Boolean status;
        public String message;
    }  
}
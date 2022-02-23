@RestResource(urlMapping='/EventosAPI/*')
global with sharing class EventosAPI {
  
    /**
     *  SUBCLASS:       Response
     *  CONSTRUCTORS:   - 
     *  DESCRIPTION:    wrapper class for Events API response. Created for US #13074 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-ene-22)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
    }

    /**
     *  METHOD:         getNewEventIsValid 
     *  PARAMETERS:     evento: type of evento
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *  DESCRIPTION:    Evaluates if a specific type of evento (CRM Evento) can be created today. Created for US #13074 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-ene-22)
     **/ 
    @HttpGet
    global static void getNewEventIsValid() {

        String evento = RestContext.request.params.get('evento');
        String estado = RestContext.request.params.get('estado');
        String fase = RestContext.request.params.get('fase');

        RestResponse response = RestContext.response;
        response.statusCode = 400;

        Response result = new Response();
        result.status = false;
        result.message = Label.EventosAPI_Default_Error_Message;
        
        Boolean checkDate = false;
        Boolean error = false;
        Boolean noPrazosDefined = false;
        String startSettings;
        String endSettings;

        try {

            if(evento == 'Lado a Lado' && (fase == null || fase == '')) {
                result.message = Label.EventosAPI_Fase_LXL_Error_Message;
                error = true;
            } else if (evento == 'Dia de Campo') {
                evento = 'Día de Campo';
            } else if (evento == 'Area Comercial') {
                evento = 'Area comercial';
            }

            if(!error) {
                List<String> availableEventTypes = getEventoPicklistValues();
                if(!availableEventTypes.contains(evento)){
                    error = true;
                    result.message = Label.EventosAPI_Bad_Event_Error_Message; 
                }
            }

            if (!error) {
                Configuracion_BMX__c configuracion = [  SELECT  Id, Name,
                                                                (SELECT Id, 
                                                                        Name, 
                                                                        Estado__c, 
                                                                        Estado__r.Name, 
                                                                        Cadastro_de_colheita__c, 
                                                                        Cadastro_de_plantio__c, 
                                                                        Evento__c, 
                                                                        Inicio__c,
                                                                        Termino__c 
                                                                FROM Prazos_de_Lancamento__r
                                                                WHERE Evento__c = :evento)
                                                        FROM Configuracion_BMX__c 
                                                        LIMIT 1];

                if(configuracion != null) {

                    if(configuracion.Prazos_de_Lancamento__r == null || configuracion.Prazos_de_Lancamento__r.isEmpty()){
                         noPrazosDefined = true;
                    } else {
                        Map<String, Prazo_de_Lancamento__c> prazosByEstado = new Map<String, Prazo_de_Lancamento__c>();
                        for(Prazo_de_Lancamento__c prazo : configuracion.Prazos_de_Lancamento__r) {
                            prazosByEstado.put(prazo.Estado__r.Name, prazo);
                        }

                        if(prazosByEstado.containsKey(estado)) {

                            Prazo_de_Lancamento__c prazo = prazosByEstado.get(estado);
                        
                            switch on prazo.Evento__c {
                                when 'Lado a Lado' {
                                    if (fase == 'Plantio') {
                                        startSettings = prazo.Cadastro_de_plantio__c;
                                    } else if (fase == 'Colheita') {
                                        startSettings = prazo.Cadastro_de_colheita__c;
                                    }
                                    endSettings = prazo.Termino__c;
                                }
                                when 'Emplacamento', 'Outdoor', 'Treinamento', 'Palestra', 'Día de Campo','Area comercial' {
                                    startSettings = prazo.Inicio__c;
                                    endSettings = prazo.Termino__c;
                                }
                            }
                        } else {
                            error = true;
                        }

                    }
                    
                } else {
                    error = true;
                }


                Date today = System.today();

                if(noPrazosDefined){
                    checkDate = true;
                } else if(startSettings == null || endSettings == null || error) {
                    result.message = Label.EventosAPI_Bad_Settings_Error_Message;
                } else {
                    checkDate = validateDate(today, startSettings, endSettings);
                }
            }


        } catch (Exception exc) {
            result.message = exc.getMessage();
        }
                
        if(checkDate) {
            result.status = true;
            result.message = Label.EventosAPI_Success_Message;
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
     *  DESCRIPTION:    Returns if its possible to create a new Stock on date provided. Created for US #13074 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-ene-22)
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


    public static List<String> getEventoPicklistValues() {
        List<String> eventoPicklistValues = new List<String>();
        Schema.DescribeFieldResult eventos = CRM_Calendario_de_Eventos__c.Evento__c.getDescribe();
    
        for (Schema.PickListEntry pEntry : eventos.getPickListValues()) {
            eventoPicklistValues.add(pEntry.getvalue());
        }

        return eventoPicklistValues;
    }


}
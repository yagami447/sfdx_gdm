@RestResource(urlMapping='/OpportunityApi/*')
global with sharing class OpportunityAPI {

    public static final String CVBRECTYPE = 'CVB Autorizada';
    public static final String A1RECTYPE = 'Anexo I';

    @HttpGet
    global static void getOpportunityisValid() {

        Map<String, Object> result = new Map<String, Object>();
        RestResponse response = RestContext.response;
        response.headers.put('Content-Type', 'application/json');
        response.statusCode = 404;
        result.put('status', false);
        result.put('message', Label.OpportunityAPI_General_Generic_Success_Message);

        List<Opportunity> oppRetrieved;
        List<Contrato__c> contMultRetrieved;
        String accountId = RestContext.request.params.get('accountId');
        String cultura = RestContext.request.params.get('cultura');
        String marca = RestContext.request.params.get('marca');
        String anexo = RestContext.request.params.get('anexo');
        String objectToFetch = 'Opportunity';
        String recordTypeName = '';
        String epocaDePlantio = '';
        String safra = '';
        String status = 'Aprobada';
        Boolean addRecordTypeName = false;
        Boolean addEpocaDePlantio = false;
        Boolean addStageName = false;
        Boolean validData = true;
        String isNewValid; // Created for US#13073
        String baseQuery = 'SELECT Id FROM Opportunity WHERE Cultura__C =: cultura AND Safra__C =: safra AND Marca__C =: marca AND Account.Id =: accountId';
        String queryOppWithRecords = 'SELECT Id FROM Opportunity WHERE Cultura__C =: cultura AND Safra__C =: safra AND Marca__C =: marca AND Account.Id =: accountId AND RecordType.Name =: anexo';
       
        List<Configuracion_BMX__c> safras = [
                                            SELECT 
                                                PM_Safra_Actual_A1__c,
                                                PM_Safra_Actual_A2__c,
                                                PM_Safra_Actual_A3__c, 
                                                PM_Safra_Actual_A4__c,
                                                PM_Safra_Actual_A5__c,
                                                PM_Safra_Actual_Reembalagem__c,
                                                PM_Safra_Actual_Descarte__c,
                                                PM_Safra_Actual_Estoque__c,
                                                PM_Estoque_Dia_Desde__c,
                                                PM_Estoque_Dia_Hasta__c
                                            FROM Configuracion_BMX__c
                                            ];

        switch on anexo {
            when  'Anexo I'{
                status = 'Chegou';
           		objectToFetch = 'Contrato Mult';
            	baseQuery = 'SELECT Id FROM Contrato__c WHERE Estado__c =: status AND Contrato_marco__c in (SELECT Id FROM Contract WHERE AccountId =: accountId)';
                safra = safras[0].PM_Safra_Actual_A1__c;
            }
            when  'Anexo II Inverno'{
                
                safra = safras[0].PM_Safra_Actual_A2__c;
                Boolean validNewA2 = aAppManager.validarNewA2(accountId, safra, marca);
 
                if (validNewA2) {
                    anexo = anexo.split(' Inverno')[0];
                    recordTypeName = 'Anexo I';
                    epocaDePlantio = 'Inverno';
                    addRecordTypeName = true;
                    addEpocaDePlantio = true;
                    addStageName = true;
                } else {
                    result.put('message', Label.Anexo_II_Val_New_Anexo);
                    validData = false;
                }
            }
            when  'Anexo II Verão'{

                safra = safras[0].PM_Safra_Actual_A2__c;
                Boolean validNewA2 = aAppManager.validarNewA2(accountId, safra, marca);
 
                if (validNewA2) {
                    anexo = anexo.split(' Verão')[0];
                    recordTypeName = 'Anexo I';
                    epocaDePlantio = 'Verão';
                    addRecordTypeName = true;
                    addEpocaDePlantio = true;
                    addStageName = true;
                } else {
                    result.put('message', Label.Anexo_II_Val_New_Anexo);
                    validData = false;
                }
            }
            when  'Anexo III'{
                recordTypeName = 'Anexo II';
                addRecordTypeName = true;
                addStageName = true;
                safra = safras[0].PM_Safra_Actual_A3__c;
            }
            when  'Anexo IV'{
                recordTypeName = 'Anexo III';
                addRecordTypeName = true;
                addStageName = true;
                safra = safras[0].PM_Safra_Actual_A4__c;
            }
            when  'Anexo V'{
                recordTypeName = 'Anexo IV';
                addRecordTypeName = true;
                addStageName = true;
                safra = safras[0].PM_Safra_Actual_A5__c;
            }
            when  'Anexo II Rebaixamento Sacas'{
                
                safra = safras[0].PM_Safra_Actual_A2__c;
                isNewValid = validateNewA2Rebaixamento(accountId, marca, cultura, safra);
                if(isNewValid.equals(Label.OpportunityAPI_General_Generic_Success_Message)) {
                    response.statusCode = 200;
                    result.put('status', true);
                    result.put('message', Label.OpportunityAPI_General_Generic_Success_Message);
                } else {
                    result.put('message', isNewValid);
                }
                validData = false;

            }
            when  'Reembalaje'{

                safra = safras[0].PM_Safra_Actual_Reembalagem__c;
                isNewValid = validateNewReembalaje(accountId, marca, cultura, safra);
                if(isNewValid.equals(Label.OpportunityAPI_General_Generic_Success_Message)) {
                    response.statusCode = 200;
                    result.put('status', true);
                    result.put('message', Label.OpportunityAPI_General_Generic_Success_Message);
                } else {
                    result.put('message', isNewValid);
                }
                validData = false;
            }
            when  'Descarte'{

                safra = safras[0].PM_Safra_Actual_Descarte__c;
                isNewValid = validateNewDescarte(accountId, marca, cultura, safra);
                if(isNewValid.equals(Label.OpportunityAPI_General_Generic_Success_Message)) {
                    response.statusCode = 200;
                    result.put('status', true);
                    result.put('message', Label.OpportunityAPI_General_Generic_Success_Message);
                } else {
                    result.put('message', isNewValid);
                }
                validData = false;
            }
            when  'Stock Multiplicadores'{
                String validDateStock = validateDateNewStock(System.today(), safras[0].PM_Estoque_Dia_Desde__c, safras[0].PM_Estoque_Dia_Hasta__c);
                if(validDateStock.equals(Label.OpportunityAPI_General_Generic_Success_Message)) {
                    safra = safras[0].PM_Safra_Actual_Estoque__c;
                    isNewValid = validateNewStock(accountId, marca, cultura, safra);
                    if(isNewValid.equals(Label.OpportunityAPI_General_Generic_Success_Message)) {
                        response.statusCode = 200;
                        result.put('status', true);
                        result.put('message', Label.OpportunityAPI_General_Generic_Success_Message);
                    } else {
                        result.put('message', isNewValid);
                    }
                } else {
                    result.put('message', validDateStock);
                }
                validData = false;
            }
            when else {
                validData = false;
            }
        }

        if (validData) {
            
            if (addRecordTypeName) {
                baseQuery = baseQuery + ' AND RecordType.Name =: recordTypeName';
            }
            
            if (addStageName) {
                baseQuery = baseQuery + ' AND StageName =: status';
            }
            
            if (addEpocaDePlantio) {
                baseQuery = baseQuery + ' AND epoca_de_plantio__c =: epocaDePlantio';
                queryOppWithRecords = queryOppWithRecords + ' AND epoca_de_plantio__c =: epocaDePlantio';
            }

            baseQuery = String.escapeSingleQuotes(baseQuery);
            queryOppWithRecords = String.escapeSingleQuotes(queryOppWithRecords);


            if(objectToFetch == 'Opportunity') {
            
                List<Opportunity> oppWithCurrentRecordType = Database.query(queryOppWithRecords);    

                if (oppWithCurrentRecordType.size() > 0) {
                    if(addEpocaDePlantio){
                        result.put('message', 'ya existe un ' + anexo + ' con epoca de plantio: ' + epocaDePlantio);

                    } else {
                        result.put('message', 'ya existe un ' + anexo + ' creado');
                    }
                    validData = false;
                   
                } else {
                    oppRetrieved = Database.query(baseQuery);
                    
                    if (oppRetrieved.size() > 0 && validData) {

                        response.statusCode = 200;
                        result.put('status', true);
                        result.put('message', Label.OpportunityAPI_General_Generic_Success_Message);

                    } else if (oppRetrieved.size() == 0 && validData) {
                            
                        result.put('message', 'No existe un ' + recordTypeName + ' autorizado valido');
                }
            }

            } else if(objectToFetch == 'Contrato Mult' && validData) {

                contMultRetrieved = Database.query(baseQuery);
                
                if (contMultRetrieved.size() > 0){
                    
                    response.statusCode = 200;
                    result.put('status', true);
                    result.put('message', Label.OpportunityAPI_General_Generic_Success_Message);
                    result.put('termo aditivo', ProductHelper.getDataAppendix1(accountId, safra, marca));

                } else{
        
                    response.statusCode = 200;
                    result.put('status', false);
                    result.put('message', Label.OpportunityAPI_Object_Contract_Without_Records_Error_Message);   
                }
            }
            
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
        
    }


    /**
     *  METHOD:         validateNewA2Rebaixamento 
     *  PARAMETERS:     - accountId
     *                  - marca
     *                  - cultura
     *                  - safra
     *  RETURN:         String: returns either 'success' or an error message
     *  DESCRIPTION:    Helper method validates is a new Anexo II Rebaixamento Opp can be created. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-oct-21)
     **/ 
    public static String validateNewA2Rebaixamento(String accountId, String marca, String cultura, String safra) {

        String result;
        Boolean approvedA2 = false;
        Boolean existsA3 = false;
        List<String> validAppendixTypes = new List<String>{'AnexoII', 'Anexo_III'};

        List<Opportunity> appendixList = [  SELECT Id, RecordType.DeveloperName, StageName 
                                            FROM Opportunity 
                                            WHERE AccountId = :accountId 
                                            AND Marca__c = :marca 
                                            AND Cultura__c = :cultura 
                                            AND Safra__c = :safra
                                            AND RecordType.DeveloperName IN :validAppendixTypes ]; 

        
        for(Opportunity appendix : appendixList) {
            if( appendix.RecordType.DeveloperName == validAppendixTypes[0] && appendix.StageName == 'Aprobada' ){
                approvedA2 = true;
            } else if( appendix.RecordType.DeveloperName == validAppendixTypes[1] ) {
                existsA3 = true;
            }
        }

        if( approvedA2 && !existsA3 ) {
            result = Label.OpportunityAPI_General_Generic_Success_Message;
        } else if( !approvedA2 ) {
            result = Label.OpportunityAPI_Anexo_II_Error_Message;
        } else if( existsA3 ) {
            result = Label.OpportunityAPI_Existing_Anexo_I_Error_Message;
        }

        return result;

    }

    /**
     *  METHOD:         validateNewReembalaje 
     *  PARAMETERS:     - accountId
     *                  - marca
     *                  - cultura
     *                  - safra
     *  RETURN:         String: returns either 'success' or an error message
     *  DESCRIPTION:    Helper method validates is a new Reembalaje Opp can be created. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-oct-21)
     **/ 
    public static String validateNewReembalaje(String accountId, String marca, String cultura, String safra) {
        
        String result;

        List<Opportunity> appendixList = [  SELECT Id, RecordType.Name, StageName 
                                            FROM Opportunity 
                                            WHERE AccountId = :accountId 
                                            AND Marca__c = :marca 
                                            AND Cultura__c = :cultura 
                                            AND Safra__c = :safra
                                            AND RecordType.Name = :CVBRECTYPE 
                                            AND StageName = 'AU - Autorizada']; 

        if( appendixList != null && !appendixList.isEmpty() ) {
            result = Label.OpportunityAPI_General_Generic_Success_Message;
        } else {
            result = Label.OpportunityAPI_CVB_Approved_Error_Message;
        }

        return result;

    }

    /**
     *  METHOD:         validateNewDescarte 
     *  PARAMETERS:     - accountId
     *                  - marca
     *                  - cultura
     *                  - safra
     *  RETURN:         String: returns either 'success' or an error message
     *  DESCRIPTION:    Helper method validates is a new Descarte Opp can be created. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-oct-21)
     **/ 
    public static String validateNewDescarte(String accountId, String marca, String cultura, String safra) {
        
        String result;
        Boolean approvedA3 = false;
        Boolean existsA4 = false;
        List<String> validAppendixTypes = new List<String>{'Anexo_III', 'Anexo_IV'};

        List<Opportunity> appendixList = [  SELECT Id, RecordType.DeveloperName, StageName 
                                            FROM Opportunity 
                                            WHERE AccountId = :accountId 
                                            AND Marca__c = :marca 
                                            AND Cultura__c = :cultura 
                                            AND Safra__c = :safra
                                            AND RecordType.DeveloperName IN :validAppendixTypes ]; 

        
        for(Opportunity appendix : appendixList) {
            if( appendix.RecordType.DeveloperName == validAppendixTypes[0] && appendix.StageName == 'Aprobada' ){
                approvedA3 = true;
            } else if( appendix.RecordType.DeveloperName == validAppendixTypes[1] ) {
                existsA4 = true;
            }
        }

        if( approvedA3 && !existsA4 ) {
            result = Label.OpportunityAPI_General_Generic_Success_Message;
        } else if ( !approvedA3 ) {
            result = Label.OpportunityAPI_Anexo_III_Error_Message;
        } else if ( existsA4 ) {
            result = Label.OpportunityAPI_Existing_Anexo_IV_Error_Message;
        }

        return result;

    }

    /**
     *  METHOD:         validateNewStock 
     *  PARAMETERS:     - accountId
     *                  - marca
     *                  - cultura
     *                  - safra
     *  RETURN:         String: returns either 'success' or an error message
     *  DESCRIPTION:    Helper method validates is a new Stock Multiplicadores Opp can be created. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-oct-21)
     **/ 
    public static String validateNewStock(String accountId, String marca, String cultura, String safra) {
        
        String result;

        List<Opportunity> appendixList = [  SELECT Id, RecordType.Name, StageName 
                                            FROM Opportunity 
                                            WHERE AccountId = :accountId 
                                            AND Marca__c = :marca 
                                            AND Cultura__c = :cultura 
                                            AND Safra__c = :safra
                                            AND RecordType.Name = :A1RECTYPE 
                                            AND StageName = 'Aprobada']; 

        if( appendixList != null && !appendixList.isEmpty() ) {
            result = Label.OpportunityAPI_General_Generic_Success_Message;
        } else {
            result = Label.OpportunityAPI_Anexo_I_Error_Message;
        }

        return result;

    }

    /**
     *  METHOD:         validateDateNewStock 
     *  PARAMETERS:     dateToCheck: date to validate against settings
     *                  startDate: start date from settings
     *                  endDate: end date from settings
     *  RETURN:         String: returns either 'success' or an error message
     *  DESCRIPTION:    Returns if its possible to create a new Stock on date provided. Created for US #13073 
     *  AUTHOR:         irina.benitez@cloudgaia.com (7-oct-21)
     **/ 
    public static String validateDateNewStock(Date dateToCheck, Decimal startDateSettings, Decimal endDateSettings) {

        String result;

        Integer endYear = dateToCheck.year();
        Integer endMonth = dateToCheck.month();

        // If start Date > end Date ==> end Year = start Year + 1
        if( startDateSettings >= endDateSettings ) {
            endMonth = endMonth + 1;
        }
        Date startDate = Date.newInstance( endYear, dateToCheck.month(), Integer.valueOf(startDateSettings) );
        Date endDate = Date.newInstance( endYear, endMonth, Integer.valueOf(endDateSettings) );

        if ( dateToCheck >= startDate && dateToCheck <= endDate ) {
            result = Label.OpportunityAPI_General_Generic_Success_Message;
        } else {
            result = Label.Estoque_Val_New_Estoque;
        }

        return result;
    }

}
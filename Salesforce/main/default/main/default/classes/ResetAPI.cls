@RestResource(urlMapping='/ResetAPI/*')
global with sharing class ResetAPI {

    /**
     *  SUBCLASS:       Response
     *  DESCRIPTION:    wrapper class for Reset API response. Created for US #18709 
     *  AUTHOR:         irina.benitez@cloudgaia.com (27-dec-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public Set<Id> deletedOppIds;
        public Set<Id> deletedCRMEventsIds;
    }

     /**
     *  METHOD:         resetAccountOpportunitiesAndEvents 
     *  PARAMETERS:     accountId: Id of an Account record 
     *                  safra  
     *                  marca 
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  deletedOppIds: set of deleted opportunity Ids
     *                  deletedCRMEventsIds: set of deleted CRM_Calendario_de_Eventos__c Ids
     *  DESCRIPTION:    DEVELOMPENT API - Deletes all Opportunity and CRM_Calendario_de_Eventos__c. Created for US #18709 
     *  AUTHOR:         irina.benitez@cloudgaia.com (27-dec-21)
     **/ 
    @HttpDelete
    global static void resetAccountOpportunitiesAndEvents() {

        String accountId = RestContext.request.params.get('accountId');
        String safra = RestContext.request.params.get('safra');
        String marca = RestContext.request.params.get('marca');
        String cultura = RestContext.request.params.get('cultura');

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        Response result = new Response();
        result.status = false;
        result.message = Label.ResetAPI_Default_Error_Message;
        
        try {

            Map<Id, Opportunity> mapOpportunities = new Map<Id, Opportunity>([  SELECT Id 
                                                                                FROM Opportunity 
                                                                                WHERE AccountId = :accountId
                                                                                    AND Safra__c = :safra
                                                                                    AND Marca__c = :marca
                                                                                    AND Cultura__c = :cultura]);

            if(!mapOpportunities.isEmpty()) {
                Set<Id> opportunitiesToDelete = mapOpportunities.keySet();
                delete (mapOpportunities.values());
                result.deletedOppIds = opportunitiesToDelete;
            }

            Map<Id, CRM_Calendario_de_Eventos__c> mapEvents = new Map<Id, CRM_Calendario_de_Eventos__c>([   SELECT Id 
                                                                                                            FROM CRM_Calendario_de_Eventos__c 
                                                                                                            WHERE Cuenta__c = :accountId
                                                                                                                AND Safra__c = :safra
                                                                                                                AND Marca__c = :marca]);

            if(!mapEvents.isEmpty()) {
                Set<Id> eventsToDelete = mapEvents.keySet();
                delete (mapEvents.values());
                result.deletedCRMEventsIds = eventsToDelete;
            }


        } catch (Exception exc) {
            response.statusCode = 400;
            result.message = exc.getMessage();
        }
                
        if((result.deletedOppIds != null && result.deletedOppIds.size() > 0) || 
                (result.deletedCRMEventsIds != null && result.deletedCRMEventsIds.size() > 0)) {
            result.status = true;
            result.message = Label.ResetAPI_Success_Message;
            response.statusCode = 200;
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }





}
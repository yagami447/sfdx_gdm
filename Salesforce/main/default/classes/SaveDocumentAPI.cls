@RestResource(urlMapping='/SaveDocumentAPI/*')
global with sharing class SaveDocumentAPI {

    public static final String EVENTLXL = 'Lado a Lado';

    /**
     *  METHOD:         saveDocument 
     *  PARAMETERS:     retrieved from request body
     *  RETURN:         message: displays 'success' or error message  
     *                  status: boolean shows if operation was succesfull
     *  DESCRIPTION:    Inserts an file related to a parent Salesforce record. Created for US #13082. Updated for US #13358
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     * 
     *  UPDATE:         pablo.fraquia@cloudgaia.com (27-Jan-22)
     *                  When the event is a Lado a Lado, the precense of a Junction Object named Attachment_Content__c is checked, if exist, 
     *                  then check the type of Attachment_Content__c and the attachemnt is created based on that. For other events and other 
     *                  object differents than CRM_Calendario_de_Eventos__c only  documents should be created.
     **/ 

    @HttpPost
    global static void saveDocument() {

        Id parentId = RestContext.request.params.get('parentId');
        String name = RestContext.request.params.get('name');
        String attachmentContentType = RestContext.request.params.get('attachmentContentType'); //'Termo de autorização' OR 'Arquivos gerais'
 
        String titleNoExtension = name.split('\\.')[0];

        Blob body = RestContext.request.requestBody;

        RestResponse response = RestContext.response;
        response.statusCode = 400; // Default Error: Bad Request

        Response result = new Response();
        result.status = false;
        result.message = Label.SaveDocumentAPI_Default_Error_Message;

        Savepoint savePoint = Database.setSavepoint(); 

        try {

            if(body.size() == 0 || body == null) {

                result.message += Label.SaveDocumentAPI_Empty_Body_Error_Message;

            } else {

                String parentType =  String.ValueOf(parentId.getSObjectType());
                boolean isLadoALado = getLadoALadoEvent(parentId);
                
                if(parentType == 'CRM_Calendario_de_Eventos__c' &&  isLadoALado){

                        if(String.isEmpty(attachmentContentType)){

                            result.message += Label.SaveDocumentAPI_Attachment_Content_Type_Error_Message;
                            Database.rollback(savePoint);

                        } else {

                            Attachment_Content__c newAttachContent= new Attachment_Content__c( CRM_Calendario_de_Eventos__c = parentId,
                                                                                                Attachment_Type__c = attachmentContentType);
                                
                            Database.SaveResult saveResultNewAttachContent = Database.insert(newAttachContent, true);

                            if(saveResultNewAttachContent.isSuccess()){

                                Attachment newAttachment2 = new Attachment( ParentId = newAttachContent.Id, 
                                                                            Name = name,
                                                                            Body = body
                                                                            );

                                Database.SaveResult saveResultAttachment2 = Database.insert(newAttachment2, true);

                                if(saveResultAttachment2.isSuccess()){

                                    CRM_Calendario_de_Eventos__c eventRecord = new CRM_Calendario_de_Eventos__c(Id = parentId, Autorizado__c = true);
                                    update eventRecord;
                                    
                                    result.documentId = newAttachment2.Id;
                                    result.status = true;
                                    result.message = Label.SaveDocumentAPI_Success_Message;
                                    response.statusCode = 201;

                                } else {

                                    for( Database.Error error : saveResultAttachment2.getErrors() ) {

                                        result.message += error.getMessage();
                                        Database.rollback(savePoint);
                                    }
                                }                                      
                                    
                            } else {

                                for( Database.Error error : saveResultNewAttachContent.getErrors() ) {

                                    result.message += error.getMessage();
                                    Database.rollback(savePoint);
                                }
                            }
                        }

                } else {

                    ContentVersion documentVersion = new ContentVersion(Title = titleNoExtension,
                                                                        PathOnClient = name,
                                                                        VersionData = body,
                                                                        IsMajorVersion = true
                                                                        );

                    Database.SaveResult saveResult = Database.insert(documentVersion, true);

                    if(saveResult.isSuccess()){

                        ContentVersion insertedDocument = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :documentVersion.Id];

                        ContentDocumentLink documentLink = new ContentDocumentLink();
                        documentLink.ContentDocumentId = insertedDocument.ContentDocumentId;
                        documentLink.LinkedEntityId = parentId;

                        Database.SaveResult saveResultLink = Database.insert(documentLink, true);

                        if(saveResultLink.isSuccess()){

                            result.documentId = documentVersion.Id;
                            result.status = true;
                            result.message = Label.SaveDocumentAPI_Success_Message;
                            response.statusCode = 201; 

                        } else {

                            for( Database.Error errorLink : saveResultLink.getErrors() ) {

                                result.message += errorLink.getMessage();
                                Database.rollback(savePoint);
                            }
                        }

                    } else {

                        for( Database.Error error : saveResult.getErrors() ) {
                            result.message += error.getMessage();
                            Database.rollback(savePoint);
                        }
                    }
                }
            }

        } catch (Exception exc) {
            result.message += exc.getMessage();
            Database.rollback(savePoint);
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }

     /**
     *  METHOD:         getLadoALadoEvent 
     *  PARAMETERS:     parentId: Id of Lado a Lado event
     *  RETURN:         Boolean: returns true if parentId belongs to a Lado a Lado event record
     *  DESCRIPTION:    Inserts an file related to a parent Salesforce record. Created for US #13358
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     **/ 

    public static Boolean getLadoALadoEvent(String parentId) {

        Boolean result = false;
        List<CRM_Calendario_de_Eventos__c> eventItems = [SELECT Id, Arquivos_cont__c, Autorizado__c 
                                                         FROM CRM_Calendario_de_Eventos__c 
                                                         WHERE Evento__c = :EVENTLXL
                                                         AND Id = :parentId];

        if(!eventItems.isEmpty()) {
            result = true;
        } 

        return result;
    }

    /**
     *  SUBCLASS:       Response
     *  DESCRIPTION:    wrapper class for Documents API response. Created for US #13083
     *  AUTHOR:         irina.benitez@cloudgaia.com (21-oct-21)
     **/ 
    public class Response {
        public Boolean status;
        public String message;
        public String documentId;
    }
}
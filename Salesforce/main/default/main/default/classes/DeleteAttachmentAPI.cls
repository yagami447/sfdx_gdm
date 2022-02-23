@RestResource(urlMapping='/DeleteAttachmentAPI/*')
global with sharing class DeleteAttachmentAPI {

    public static final String SUCCESSMESSAGE = 'Success';
    public static final String NORECORDSERROR = ' - Por favor, assegure-se de que o arquivo existe e que sua Id está corretamente indicada.  '; 

    /**
     *  METHOD:         deleteAttachment 
     *  PARAMETERS:     attachmentId: Id of an Attachment record. 
     *  RETURN:         message: displays 'Success' or error message  
     *                  status: boolean shows if operation was succesfull
     *                  deletedAttachmentId: Id of deleted Attachment
     *                  deletedAttachmentContentId: Id of deleted  Attachment_Content__c if the deleted attachment reside on Event object and is the unique element on this object
     *  DESCRIPTION:    DEVELOMPENT API - Delete attachemnt record and Attachment_Content__c. Created for US #18866 
     *  AUTHOR:         pablo.fraquia@cloudgaia.com (07-Jan-22)
     *  UPDATES:        irina.benitez@cloudgaia.com (01-feb-22). Updated for #19576
     **/ 

    @HttpDelete
    global static void deleteAttachment() {

        String attachToDelete = RestContext.request.params.get('attachmentId');

        RestResponse response = RestContext.response;
        response.statusCode = 404;

        Response result = new Response();
        result.status = false;

        try {
 
            List<Attachment> attachments = [ SELECT Id, ParentId, Parent.Type
                                            FROM Attachment
                                            WHERE Id = :attachToDelete];

            if(attachments != null && !attachments.isEmpty()){

                Attachment attachment = Attachments[0];
                if(attachment.Parent.Type  == 'Attachment_Content__c') {
 
                    Attachment_Content__c attachmentContent = [SELECT Id 
                                                               FROM Attachment_Content__c
                                                               WHERE Id = :attachment.ParentId];                                       

                    List<Attachment> attachmentList = [SELECT Id
                                                       FROM Attachment
                                                       WHERE ParentId = :attachmentContent.Id];

                    if(attachmentList.size() == 1){
 
                        result.deleted_AttachmentContent_Id = attachmentContent.Id;
                        result.deleted_Attachment_Id = attachment.Id;
                        delete attachmentContent;
                       
                    }else{
                      
                        result.deleted_Attachment_Id = attachment.Id;
                        delete attachment;
                    }

                } else {
                   
                    result.deleted_Attachment_Id = attachment.Id;
                    delete attachment;
                    
                }

                response.statusCode = 200;
                result.status = true;
                result.message = SUCCESSMESSAGE; 

            } else {
                //aca seguire con el caso de documents 
                ContentVersion version = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :attachToDelete];   
                
                if (version != null) {
                    ContentDocument document = new ContentDocument(Id = version.ContentDocumentId);
                    result.deleted_ContentDocument_Id = document.Id;
                    result.deleted_ContentVersion_Id = version.Id;
                    delete document;
                
                    response.statusCode = 200;
                    result.status = true;
                    result.message = SUCCESSMESSAGE; 
                }
            }

        } catch(Exception e){

            response.statusCode = 400;
            result.message = NORECORDSERROR +  e.getMessage();
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');   
    }

    /**
     *  SUBCLASS:       Response
     *  DESCRIPTION:    wrapper class for Reset API response. Created for US #18866 
     *  AUTHOR:         pablo.fraquia@cloudgaia.com (07-Jan-22)
     *  UPDATES:        irina.benitez@cloudgaia.com (01-feb-22). Updated for #19576
     **/ 

    public class Response {
        public Boolean status;
        public String message;
        public String deleted_Attachment_Id;
        public String deleted_AttachmentContent_Id;
        public String deleted_ContentVersion_Id;
        public String deleted_ContentDocument_Id;
    }
}
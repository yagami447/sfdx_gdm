/**
* @name GetDocumentAPI
* @author Jhonny Peroza
* updated 23-11-2021
*/
@RestResource(urlMapping='/GetDocumentAPI/*')
global with sharing class GetDocumentAPI {

    @HttpGet
    global static void getDocument() {

        List<Attachment> attachmentList = new List<Attachment>();
        List<ContentDocumentLink> contentDocumentList = new List<ContentDocumentLink>();

        List<Documents> documentsResultList = new List<Documents>();

        RestResponse response = RestContext.response;  
        response.statusCode = 404;

        Response result = new Response(); 
        result.status = false;   

        String Id = RestContext.request.params.get('Id');

        try {

            List<ContentDocumentLink> contentDocumentLinkRecords = [SELECT ContentDocumentId
                                                                    FROM ContentDocumentLink 
                                                                    WHERE LinkedEntityId =: Id];

            if(contentDocumentLinkRecords.size() > 0) {
                documentsResultList.addAll( makeLinksContentDocuments(contentDocumentLinkRecords) ); 
            }

            List<Attachment> attachmentRecords = [  SELECT Id, ParentId, Body, Name
                                                    FROM Attachment 
                                                    WHERE ParentId =: Id];

            if(attachmentRecords.size() > 0) {
                documentsResultList.addAll( makeLinksAttachments(attachmentRecords) ); 
            } 

            List<Attachment_Content__c> attachmentContents = [  SELECT Id, CRM_Calendario_de_Eventos__c, Show_File__c, Attachment_Type__c
                                                                FROM Attachment_Content__c 
                                                                WHERE CRM_Calendario_de_Eventos__c =: Id];

            if (attachmentContents.size() > 0) {
                documentsResultList.addAll( makeLinksAttachmentContents(attachmentContents) ); 
                
            }
            

            if(!documentsResultList.isEmpty()) {

                result.message = Label.GetDocumentAPI_Success_Message;
                result.body = documentsResultList;
                result.status = true;
                response.statusCode = 200;

            } else {

                result.message = Label.GetDocumentAPI_Default_Error_Message;

            }
        } catch (Exception e) {
            result.message = e.getMessage();
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');

    }

    public static List<Documents> makeLinksContentDocuments(List<ContentDocumentLink> contentDocumentLinkRecords) {

        List<Documents> finalList = new List<Documents>();

        Set<Id> contentDocumentIds = new Set<Id>();

        for(ContentDocumentLink ids : contentDocumentLinkRecords) {
            contentDocumentIds.add(ids.ContentDocumentId);
        }

        List<ContentVersion> contentVersionsList = [SELECT Id, Title, FileExtension, Show_File__c
                                                         FROM ContentVersion  
                                                            WHERE ContentDocumentId IN : contentDocumentIds];

        for(ContentVersion item : contentVersionsList){
            Documents mapData = new Documents();
            if(item.Show_File__c == true) {
                mapData.fileName = item.Title +'.'+item.FileExtension;
                mapData.url = '/services/data/v52.0/sobjects/ContentVersion/'+ item.Id + '/VersionData';
                mapData.documentId = item.Id;
                finalList.add(mapData);
            }
        }

        return finalList;

    }

    public static List<Documents> makeLinksAttachments(List<Attachment> attachmentRecords) {

        List<Documents> finalList = new List<Documents>();

        Set<Id> parentIds = new Set<Id>();

        for(Attachment ids : attachmentRecords) {
            parentIds.add(ids.ParentId);
        }
        
        List<CRM_Calendario_de_Eventos__c> attachmentContentList = [SELECT Id
                                                                    FROM CRM_Calendario_de_Eventos__c  
                                                                    WHERE Id IN : parentIds];
       
        for(Attachment att : attachmentRecords) {
            for(CRM_Calendario_de_Eventos__c item : attachmentContentList){
                Documents mapData = new Documents();
                if(att.ParentId == item.Id) {
                    mapData.fileName = att.Name;
                    mapData.url = '/services/data/v52.0/sobjects/Attachment/'+ att.Id + '/body';
                    mapData.documentId = att.Id;
                    finalList.add(mapData);
                }
            }
        }

        return finalList;

    }

    public static List<Documents> makeLinksAttachmentContents(List<Attachment_Content__c> attachmentContents) {

        List<Documents> finalList = new List<Documents>();

        Set<Id> parentIds = new Set<Id>();

        for(Attachment_Content__c ids : attachmentContents) {

            parentIds.add(ids.Id);

        }

        List<Attachment> attachments = [SELECT Id, ParentId, Body, Name
                                                FROM Attachment 
                                                WHERE ParentId IN : parentIds];
                                                
        for(Attachment att : attachments) {

            for(Attachment_Content__c item : attachmentContents){
                Documents mapData = new Documents();
                if(att.ParentId == item.Id && item.Show_File__c == true) {
                    mapData.fileName = att.Name;
                    mapData.url = '/servlet/servlet.FileDownload?file=' + att.Id;
                    mapData.documentId = att.Id;
                    mapData.attachmentType = item.Attachment_Type__c;
                    finalList.add(mapData);
                }
            }
        }

        return finalList;

    }


    public class Response {
        public String message;
        public Boolean status;
        public List<Documents> body;
    }

    public class Documents {
        public String fileName {get; set;}
        public String url {get; set;}
        public String documentId {get; set;}
        public String attachmentType {get; set;}
    }

}
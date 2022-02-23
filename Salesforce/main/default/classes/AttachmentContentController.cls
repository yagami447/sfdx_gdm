public without sharing class AttachmentContentController {

    /**
     * Añade un Attachment Content relacionado a un CRM Evento especificado según su Id. Se almacena el file subido por el usuario en un Attachment relacionado al Attachment Content.
     */
    @AuraEnabled
    public static void addAttachmentContent(Id eventoId, String tipoArquivo, String name, String type, String body) {
        Attachment_Content__c attContent = new Attachment_Content__c(
            CRM_Calendario_de_Eventos__c = eventoId,
            Attachment_Type__c = tipoArquivo
        );

        try {
            insert attContent;

            Attachment att = new Attachment(
                Name = name,
                ContentType = type,
                Body = EncodingUtil.base64Decode(body),
                ParentId = attContent.Id
            );

            insert att;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Retorna todos los Attachment Contents de un CRM Evento especificado según su Id. El valor retornado consiste en una lista de mapas donde cada mapa contiene valores del Attachment Content y su Attachment relacionado.
     */
    @AuraEnabled
    public static List<Map<String, String>> getAttachmentContents(Id eventoId) {
        List<Map<String, String>> attachmentContents = new List<Map<String, String>>();

        List<Attachment_Content__c> attContents = [
            SELECT Id, Attachment_Type__c, (SELECT Id, Name, ParentId FROM Attachments)
            FROM Attachment_Content__c
            WHERE CRM_Calendario_de_Eventos__c = :eventoId
        ];

        for (Attachment_Content__c attContent : attContents) {
            if (!attContent.Attachments.isEmpty()) {
                attachmentContents.add(
                    new Map<String, String>{
                        'id' => attContent.Id,
                        'AttachmentName' => attContent.Attachments[0].Name,
                        'AttachmentType' => attContent.Attachment_Type__c
                    }
                );
            }
        }

        return attachmentContents;
    }

    /**
     * Retorna el Id del Attachment relacionado a un Attachment Content especificado según su Id. A partir del Id del Attachment puede generarse su url de descarga,
     * ejemplo en Apex: '/servlet/servlet.FileDownload?file=' + :AttachmentId
     */
    @AuraEnabled
    public static Id downloadAttachmentContent(Id attContentId) {
        return [SELECT Id FROM Attachment WHERE ParentId = :attContentId LIMIT 1].Id;
    }

    /**
     * Elimina el Attachment Content especificado en el parámetro attContentId, junto al Attachment Content se elimina el Attachment relacionado.
     */
    @AuraEnabled
    public static void removeAttachmentContent(Id attContentId) {
        try {
            Database.DeleteResult dr = Database.delete(attContentId, true);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
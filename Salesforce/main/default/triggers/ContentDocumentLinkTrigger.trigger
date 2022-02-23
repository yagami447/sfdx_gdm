trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert, after delete) {
    Set<Id> crmEventosIds = new Set<Id>();
    
    if(Trigger.isInsert) {
        for(ContentDocumentLink cdl : Trigger.new) {
            crmEventosIds.add(cdl.LinkedEntityId);
        }
    } else {
        for(ContentDocumentLink cdl : Trigger.old) {
            crmEventosIds.add(cdl.LinkedEntityId);
        }
    }

    
    Map<Id, List<ContentDocumentLink>> cdlsByEventoId = new Map<Id, List<ContentDocumentLink>>();
    for(ContentDocumentLink cdl : [
        SELECT Id, LinkedEntityId
        FROM ContentDocumentLink
        WHERE LinkedEntityId IN :crmEventosIds
    ]) {
        if(!cdlsByEventoId.containsKey(cdl.LinkedEntityId)) {
            cdlsByEventoId.put(cdl.LinkedEntityId, new List<ContentDocumentLink>());
        }
        
        cdlsByEventoId.get(cdl.LinkedEntityId).add(cdl);
    }
    System.debug(cdlsByEventoId);
    
    Map<Id, List<Attachment>> attachmentsByEventoId = new Map<Id, List<Attachment>>();
    for(Attachment attch : [
        SELECT Id, ParentId
        FROM Attachment
        WHERE ParentId IN :crmEventosIds
    ]) {
        if(!attachmentsByEventoId.containsKey(attch.ParentId)) {
            attachmentsByEventoId.put(attch.ParentId, new List<Attachment>());
        }
        
        attachmentsByEventoId.get(attch.ParentId).add(attch);
    }
    
    
    List<CRM_Calendario_de_Eventos__c> crmEventosToUpdate = new List<CRM_Calendario_de_Eventos__c>();
    for(CRM_Calendario_de_Eventos__c crmEvento : [
        SELECT Id, Arquivos_cont__c
        FROM CRM_Calendario_de_Eventos__c
        WHERE Id IN :crmEventosIds
    ]) {
        crmEvento.Arquivos_cont__c = 0;
        
        if(cdlsByEventoId.containsKey(crmEvento.Id) || attachmentsByEventoId.containsKey(crmEvento.Id)) {
            if(cdlsByEventoId.containsKey(crmEvento.Id)) {
                crmEvento.Arquivos_cont__c += cdlsByEventoId.get(crmEvento.Id).size();
            }
            if(attachmentsByEventoId.containsKey(crmEvento.Id)) {
                crmEvento.Arquivos_cont__c += attachmentsByEventoId.get(crmEvento.Id).size();
            }
        }

        crmEventosToUpdate.add(crmEvento);
    }
    
    update crmEventosToUpdate;
}
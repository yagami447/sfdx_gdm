global class CRMEventosUpdaterBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    private String finalStr;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        this.finalStr = 'Id, Arquivos_Cont__c\n';
            
        return Database.getQueryLocator(
            'SELECT Id, Arquivos_cont__c ' +
    		'FROM CRM_Calendario_de_eventos__c ' +
            'WHERE Safra__c = \'19/20\' ' + 
            	'OR Safra__c = \'20/21\'');
    }
    
    global void execute(Database.BatchableContext bc, List<CRM_Calendario_de_Eventos__c> scope) {
        Set<Id> eventosId = new Set<Id>();
        for(CRM_Calendario_de_Eventos__c crmEvento : scope) {
            eventosId.add(crmEvento.Id);
        }
        
        Map<Id, List<ContentDocumentLink>> entityIdToCDL = new Map<Id, List<ContentDocumentLink>>();
        for(ContentDocumentLink cdl : [
            SELECT Id, LinkedEntityId 
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :eventosId
        ]) {
            if(!entityIdToCDL.containsKey(cdl.LinkedEntityId)) {
                entityIdToCDL.put(cdl.LinkedEntityId, new List<ContentDocumentLink>());
            }
            
            entityIdToCDL.get(cdl.LinkedEntityId).add(cdl);
        }
        
        Map<Id, List<Attachment>> parentIdToAttachment = new Map<Id, List<Attachment>>();
        for(Attachment attach : [
            SELECT Id, ParentId
            FROM Attachment
            WHERE ParentId IN :eventosId
        ]) {
            if(!parentIdToAttachment.containsKey(attach.ParentId)) {
                parentIdToAttachment.put(attach.ParentId, new List<Attachment>());
            }
            
            parentIdToAttachment.get(attach.ParentId).add(attach);
        }
        
        for(CRM_Calendario_de_eventos__c crmEvento : scope) {
            crmEvento.Arquivos_cont__c = 0;
            
            if(entityIdToCDL.containsKey(crmEvento.Id)) {
                crmEvento.Arquivos_cont__c += entityIdToCDL.get(crmEvento.Id).size();
            }
            if(parentIdToAttachment.containsKey(crmEvento.Id)) {
                crmEvento.Arquivos_cont__c += parentIdToAttachment.get(crmEvento.Id).size();
            }
            
            finalStr += crmEvento.Id + ', ' + crmEvento.Arquivos_cont__c + '\n';
        }

		update scope;
    }
    
    global void finish(Database.BatchableContext bc) {
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        csvAttc.setFileName('CRM Eventos actualizados.csv');
        csvAttc.setBody(Blob.valueOf(finalstr));
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new List<String>{'andres.guastavino@xappia.com'};
        String subject ='CRM Eventos actualizados';
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setPlainTextBody('CRM Eventos actualizados');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}
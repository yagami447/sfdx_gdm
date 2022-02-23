trigger EnvelopeStatusTrigger on dfsle__EnvelopeStatus__c (after update) {
    
    private static final Map<String, Schema.RecordTypeInfo> rtMapOpportunity = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByName();
    private static final List<Id> APPROVE_PROCESS_RT_IDS = new List<Id>{
        Contrato__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Termo Aditivo Comerciais').getRecordTypeId(),
        rtMapOpportunity.get('Anexo II Rebaixamento Sacas').getRecordTypeId(),
        rtMapOpportunity.get('Anexo I').getRecordTypeId(),
        rtMapOpportunity.get('Reembalaje').getRecordTypeId()
    };
    
    for(dfsle__EnvelopeStatus__c statusObject : Trigger.New) {    
        if(statusObject.dfsle__Status__c == 'Completed' && System.Trigger.oldMap.get(statusObject.Id).dfsle__Status__c != 'Completed') {
            System.debug('ENVELOPE STATUS TRIGGER COMPLETED');
            if(Trigger.isAfter) {
                Id recordTypeId;
                String approvalProcessComent;
                if(Id.valueOf(statusObject.dfsle__SourceId__c).getSobjectType() == Schema.getGlobalDescribe().get('Opportunity')) {
                	recordTypeId = [SELECT RecordTypeId FROM Opportunity WHERE Id = :statusObject.dfsle__SourceId__c LIMIT 1].RecordTypeId;
                    approvalProcessComent = 'Oportunidade assinada pelo Gerente';
                } else if(Id.valueOf(statusObject.dfsle__SourceId__c).getSobjectType() == Schema.getGlobalDescribe().get('Contrato__c')) {
                    recordTypeId = [SELECT RecordTypeId FROM Contrato__c WHERE Id = :statusObject.dfsle__SourceId__c LIMIT 1].RecordTypeId;
                    approvalProcessComent = 'Termo Aditivo assinado pelo Diretor Comercial';
                }
                if(recordTypeId != null && APPROVE_PROCESS_RT_IDS.contains(recordTypeId)) {
                	ProcessInstanceWorkitem approvalProcessItem = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :statusObject.dfsle__SourceId__c ORDER BY CreatedDate DESC LIMIT 1];
                    Approval.ProcessWorkitemRequest approveProcess = new Approval.ProcessWorkitemRequest();
                    approveProcess.setComments(approvalProcessComent);
                    approveProcess.setAction('Approve');
                    approveProcess.setWorkitemId(approvalProcessItem.Id);
                    Approval.ProcessResult approvedProcess = Approval.Process(approveProcess); 
                }
            }
        }
        if((statusObject.dfsle__Status__c == 'Declined' && System.Trigger.oldMap.get(statusObject.Id).dfsle__Status__c != 'Declined')
          	|| (statusObject.dfsle__Status__c == 'Voided' && System.Trigger.oldMap.get(statusObject.Id).dfsle__Status__c != 'Voided')) {
            System.debug('ENVELOPE STATUS TRIGGER DECLINED/VOIDED');
            if(Trigger.isAfter) {
                Id recordTypeId;
                String approvalProcessComent;
                if(Id.valueOf(statusObject.dfsle__SourceId__c).getSobjectType() == Schema.getGlobalDescribe().get('Opportunity')) {
                    recordTypeId = [SELECT RecordTypeId FROM Opportunity WHERE Id = :statusObject.dfsle__SourceId__c LIMIT 1].RecordTypeId;
                    if(statusObject.dfsle__Status__c == 'Declined') {
                        approvalProcessComent = 'Gerente recusou assinatura';
                    } else {
                        approvalProcessComent = 'Contrato cancelado por ADM Vendas';
                    }
                } else if(Id.valueOf(statusObject.dfsle__SourceId__c).getSobjectType() == Schema.getGlobalDescribe().get('Contrato__c')) {
                    recordTypeId = [SELECT RecordTypeId FROM Contrato__c WHERE Id = :statusObject.dfsle__SourceId__c LIMIT 1].RecordTypeId;
                    if(statusObject.dfsle__Status__c == 'Declined') {
                    	approvalProcessComent = 'Diretor Comercial recusou assinatura';
                    } else {
                        approvalProcessComent = 'Contrato cancelado por ADM Vendas';
                    }
                }
                if(recordTypeId != null && APPROVE_PROCESS_RT_IDS.contains(recordTypeId)) {
                	ProcessInstanceWorkitem approvalProcessItem = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :statusObject.dfsle__SourceId__c ORDER BY CreatedDate DESC LIMIT 1];
                    Approval.ProcessWorkitemRequest approveProcess = new Approval.ProcessWorkitemRequest();
                    approveProcess.setComments(approvalProcessComent);
                    approveProcess.setAction('Reject');
                    approveProcess.setWorkitemId(approvalProcessItem.Id);
                    Approval.ProcessResult approvedProcess = Approval.Process(approveProcess); 
                }
            }
        }
    }    
}
global class Batch_Docusign_Approval_Process implements Database.Batchable<sObject> {
    
    global List<dfsle__EnvelopeStatus__c> start(Database.BatchableContext bc){   
        return [SELECT Id, Oportunidade__c, Contrato_de_Multiplicacao__c, Contract__c FROM dfsle__EnvelopeStatus__c WHERE 
        	((Oportunidade__c != null AND Oportunidade__r.StageName = 'Aguardando Assinatura') 
			OR (Contrato_de_Multiplicacao__c != null AND Contrato_de_Multiplicacao__r.Estado__c = 'Aguardando Assinatura')
			OR (Contract__c != null AND Contract__r.Status = 'Pendente de Postagem')) 
            AND dfsle__Status__c = 'Completed'];
    }
    
    global void execute(Database.BatchableContext bc, List<dfsle__EnvelopeStatus__c> envelopeStatusList) {
        Set<Id> signedObjectIdList = new Set<Id>();
        for(dfsle__EnvelopeStatus__c envelopeStatusObject : envelopeStatusList) {
            if(envelopeStatusObject.Oportunidade__c != null) {
                signedObjectIdList.add(envelopeStatusObject.Oportunidade__c);
            } else if(envelopeStatusObject.Contrato_de_Multiplicacao__c != null) {
                signedObjectIdList.add(envelopeStatusObject.Contrato_de_Multiplicacao__c);
            }
			else if(envelopeStatusObject.Contract__c != null) {
                signedObjectIdList.add(envelopeStatusObject.Contract__c);
            }
        }
        System.debug(signedObjectIdList);
        if(signedObjectIdList.size() > 0) {
           	List<ProcessInstanceWorkitem> approvalProcessItemList = [SELECT Id, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN :signedObjectIdList ORDER BY CreatedDate DESC];
            System.debug(approvalProcessItemList);
            if(approvalProcessItemList.size() > 0) {
                for(ProcessInstanceWorkitem approvalProcessItem : approvalProcessItemList) {
                    Approval.ProcessWorkitemRequest approveProcess = new Approval.ProcessWorkitemRequest();
                    String approvalProcessComent = 'Assinado.';
                    if(approvalProcessItem.ProcessInstance.TargetObjectId.getSobjectType() == Schema.getGlobalDescribe().get('Opportunity')) {
                        approvalProcessComent = 'Oportunidade assinada pelo Gerente';
                    } else if(approvalProcessItem.ProcessInstance.TargetObjectId.getSobjectType() == Schema.getGlobalDescribe().get('Contrato__c')) {
                        approvalProcessComent = 'Termo Aditivo assinado pelo Diretor Comercial';
                    } else if(approvalProcessItem.ProcessInstance.TargetObjectId.getSobjectType() == Schema.getGlobalDescribe().get('Contract')) {
                        approvalProcessComent = 'Termo Juridico assinado pelo Diretor Comercial';
                    }
                    approveProcess.setComments(approvalProcessComent);
                    approveProcess.setAction('Approve');
                    approveProcess.setWorkitemId(approvalProcessItem.Id);
                    Approval.ProcessResult approvedProcess = Approval.Process(approveProcess); 
                }   
            }
		}
    }
    
    global void finish(Database.BatchableContext bc) {}
}
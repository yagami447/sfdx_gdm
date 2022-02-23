public class RequisicaoApprovalTreeController {
    @AuraEnabled
    public static List<Requisicao_de_compra__c> getTreeGridData(Id requisitionId, String status){
        
        System.debug('METODO GRID DATA - ID ESTIMATIVA ' +requisitionId);
           return [
            SELECT Id, Name, Estado__c,Tipo__c, Nombre_del_multiplicador__c,
            URL_Multiplica__c, URL__c,
            (SELECT Id,Name, Quantidade__c, URL__c 
             FROM Produtos_de_Requisicao__r)
            FROM Requisicao_de_compra__c
            WHERE Requisicao_de_compra__c = :requisitionId
            AND Estado__c = :status
        ];
         
    } 
    
    @AuraEnabled public static String processRequisitions(String JSONRequisitions, String action, String comment){
        System.debug(action);
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        List<Requisicao_de_compra__c> requisitions = (List<Requisicao_de_compra__c>) System.JSON.deserialize(JSONRequisitions, List<Requisicao_de_compra__c>.class);
        List<String> idsOfWrapp = new List<String>();        
        
        for(Requisicao_de_compra__c req : requisitions){
            idsOfWrapp.add(req.id);
        }
        
        List<ProcessInstanceWorkItem> processOfItem = [
            SELECT Id,processinstance.targetobjectid,ProcessInstance.Status 
            FROM processinstanceworkitem 
            WHERE ProcessInstance.targetObjectId IN: idsOfWrapp
            ORDER BY processinstance.targetobjectid,
            CreatedDate DESC
        ];
        
        for(ProcessInstanceWorkItem item : processOfItem){
            if(item.ProcessInstanceId != null){
                Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
                request.setComments(comment);
                request.setAction(action);     
                request.setWorkitemId(item.Id);
                requests.add(request);
            }
        }
        
        List<Approval.ProcessResult> results =  Approval.process(requests, true);
        String errors = '';
        for(Approval.ProcessResult result : results){
            if(!result.isSuccess()) errors += result.getErrors() + '\n\r';
        }
        if(errors != '') return errors;
        
        return 'SUCCESS';
        
    }
    
}
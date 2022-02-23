public with sharing class approvalButtonCRMEventoController {

    @AuraEnabled
    public static List<CRM_Detalle_Calendario_de_eventos__c> getItems(Id recordId) {
        return [
            SELECT Id, Name, Produto_Principal__c, Area_plantada__c, Area_Colhida__c, Data_de_plantio__c, Data_de_colheita__c,
                Produtividade__c, Volume_Doado__c, Populacao_de_plantas__c, Espacamento__c, Cultura_antecessora__c
            FROM CRM_Detalle_Calendario_de_eventos__c
            WHERE CRM_Calendario_de_eventos__c = :recordId
        ];
    }

    @AuraEnabled
    public static AggregateResult countNumberOfDocuments(Id recordId) {
        return [SELECT COUNT(Id) Total FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
    }

    @AuraEnabled
    public static Boolean sendApprovalRequest(Id recordId, Id ownerId) {
        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();    
        request.setObjectId(recordId);
        request.setNextApproverIds(new Id[]{ownerId});

        Boolean result = false;

        try {
            Approval.ProcessResult pResult = Approval.process(request);
            result = pResult.isSuccess();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return result;
    }
}
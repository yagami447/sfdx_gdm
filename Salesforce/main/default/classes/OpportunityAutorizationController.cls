public without sharing class OpportunityAutorizationController {

    @AuraEnabled
    public static String sendAutorizationRequest(Opportunity opp) {
        RecordType recordTypeCVBPendiente = XappiaHelper.getRecordType('Opportunity', 'CVB_Pendiente');
        
        if (!opp.HasOpportunityLineItem) {
            AuraHandledException e = new AuraHandledException('Opportunity sem Produtos');
            e.setMessage('Opportunity sem Produtos');
            throw e;
        } else if (opp.StageName == 'AN - Anulada') {
            AuraHandledException e = new AuraHandledException('Venda da Basica Anulada');
            e.setMessage('Venda da Basica Anulada');
            throw e;
        } else if (opp.Sucursal__c == null && opp.Origen__c == null) {
            AuraHandledException e = new AuraHandledException('Falta sucursal');
            e.setMessage('Falta sucursal');
            throw e;
        } else if (opp.RecordTypeId == recordTypeCVBPendiente.Id && opp.Destinatario_de_Mercaderia__c == null) {
            AuraHandledException e = new AuraHandledException('Falta Destinatario');
            e.setMessage('Falta Destinatario');
            throw e;
        } else if (opp.RecordTypeId == recordTypeCVBPendiente.Id) {
            List<String> resultsValidatePasoVBSAP = Opp_Utils.validarPasoVBSAP(opp.Id);

            if (resultsValidatePasoVBSAP[1] != 'OK') {
                AuraHandledException e = new AuraHandledException(resultsValidatePasoVBSAP[0]);
                e.setMessage(resultsValidatePasoVBSAP[0]);
                throw e;
            }
        }
        
        return JSON.serialize(Opp_Sap_Alta.enviarSAP(opp.Id, opp.StageName, 200));
    }
}
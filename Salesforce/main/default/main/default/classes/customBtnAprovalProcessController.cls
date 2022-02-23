public inherited sharing class customBtnAprovalProcessController {
    
    // @TestVisible public id oppId;
    // @TestVisible public Boolean hasOppLineItems;
    // @TestVisible public Opportunity opp;
        @TestVisible static String errorTaxaDoPrimerPagamentoVazio = '% Pedido 1º parcela não pode ser vazio.';
        @TestVisible static String errorSinProd = 'A oportunidade deve ter ao menos um produto.';
        @TestVisible static String errorNoEdicion = 'A oportunidade deve estar em status de edição e não aprovada.'; 
        @TestVisible static String errorEnAprob = 'A oportunidade já está no processo de aprovação.';
    	@TestVisible static String errorEnPermiso = 'Você não tem permissão para se enviar para aprovação.';
    	@TestVisible static String errorDesvioNull = 'O desvio básico de venda de basica não pode ser vazio.';
    	@TestVisible static id idProfile = userinfo.getProfileId();
   		
    @AuraEnabled public static void sendToApproveOpportunity(String oppId) {
        @TestVisible String error; 
		Profile UserProfile = [SELECT Id, Name FROM Profile WHERE Id=:idProfile LIMIT 1];
		String UserProfileName = UserProfile.Name;
 
        Opportunity opp = [
            SELECT Id, HasOpportunityLineItem, StageName, 
                    Desvio_Venda_de_Basica__c, Taxa_de_primeiro_pagamento__c
            FROM Opportunity
            WHERE Id = :oppId
            LIMIT 1
        ];
        if(opp.Taxa_de_primeiro_pagamento__c == null){
            AuraHandledException e = new AuraHandledException(errorTaxaDoPrimerPagamentoVazio);
            e.setMessage(errorTaxaDoPrimerPagamentoVazio);
            throw e;
        }
        else if(opp.Desvio_Venda_de_Basica__c == null){
            AuraHandledException e = new AuraHandledException(errorDesvioNull);
            e.setMessage(errorDesvioNull);
            throw e;
        }
        else {if(UserProfileName != 'COMERCIAL LE' && UserProfileName != 'Administrador del sistema'){
            AuraHandledException e = new AuraHandledException(errorEnPermiso);
            e.setMessage(errorEnPermiso);
            throw e;
        }
        else {if(!opp.HasOpportunityLineItem){
            //error = 'A oportunidade deve ter ao menos um produto';
            AuraHandledException e = new AuraHandledException(errorSinProd);
            e.setMessage(errorSinProd);
            throw e;
        }
        else if (opp.StageName != 'Edición'){
            // error = 'A oportunidade deve estar em status de edição e não aprovada';
            AuraHandledException e = new AuraHandledException(errorNoEdicion);
            e.setMessage(errorNoEdicion);
            throw e;
        }else{
            opp.StageName = 'Na aprovação da gerência';
            update opp;
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();    
            req1.setObjectId(opp.Id);
            try {
                Approval.ProcessResult result = Approval.process(req1);
            } catch (Exception ex) {
                system.debug('Excepcion al enviar a aprobar opp ' + ex.getMessage());
                error = 'A oportunidade já está no processo de aprovação.';
                AuraHandledException e = new AuraHandledException(errorEnAprob);
                e.setMessage(errorEnAprob);
                throw e;
            }
        }
    }
}
        
        
    }

}
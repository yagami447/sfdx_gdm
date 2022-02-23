trigger ContratoMultiplicacaoTrigger on Contrato__c (after update) {
    
    private final Id RT_TERMO_ADITIVO = Contrato__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Termo Aditivo Comerciais').getRecordTypeId();

    private final Id RT_TERMO_ADITIVO_BIO = Contrato__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Termo Aditivo Novas Biotecnologias').getRecordTypeId();
    for (Contrato__c contratoMultiplicacaoObject : Trigger.New){
        if(Trigger.isUpdate) {
        	if(contratoMultiplicacaoObject.RecordTypeId == RT_TERMO_ADITIVO || contratoMultiplicacaoObject.RecordTypeId == RT_TERMO_ADITIVO_BIO) {
                if(contratoMultiplicacaoObject.Estado__c == 'Aguardando Assinatura' && System.Trigger.oldMap.get(contratoMultiplicacaoObject.Id).Estado__c != 'Aguardando Assinatura') {
                    if(!Test.isRunningTest()) {
                    	PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF(contratoMultiplicacaoObject.Id, contratoMultiplicacaoObject.RecordTypeId == RT_TERMO_ADITIVO  ? 'Termo Aditivo' : 'Termo Aditivo Biotec');   
                    }
                }
            }   
        }   
    }
}
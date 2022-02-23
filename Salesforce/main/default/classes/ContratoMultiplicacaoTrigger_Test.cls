@isTest
public class ContratoMultiplicacaoTrigger_Test {

    private static final Test_Utils testUtils = Test_Utils.getInstance();

    public static testmethod void shouldCallPdfGeneratorController() {
        Contrato__c contratoMultiplicacaoObject = testUtils.createNewContratoMultiplicacao(null, null, null, null);
        insert contratoMultiplicacaoObject;
        contratoMultiplicacaoObject.Estado__c = 'Aguardando Assinatura';
        update contratoMultiplicacaoObject;
    }
}
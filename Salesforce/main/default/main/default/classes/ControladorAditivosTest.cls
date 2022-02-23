@isTest
public class ControladorAditivosTest {
    
    @isTest
    static void llamarAGetContratoClonadoConUnContratoConContratoAnteriorDeberiaDevolverFalse() {
        Contrato__c contrato = new Contrato__c();
        insert contrato;
        
        ControladorAditivos controlador = new ControladorAditivos(new ApexPages.StandardController(contrato));
        controlador.contratoId = contrato.Id;
        
        Test.startTest();
        Boolean clonado = controlador.getContratoClonado();
        Test.stopTest();
        
        System.assertEquals(false, clonado);
    }
    
    @isTest
    static void llamarAGetContratoClonadoConUnContratoConContratoAnteriorDeberiaDevolverTrue() {
        Contrato__c contratoAnterior = new Contrato__c();
        insert contratoAnterior;
        
        Contrato__c contrato = new Contrato__c(
        	Contrato_ant__c = contratoAnterior.Id
        );
        insert contrato;
        
        ControladorAditivos controlador = new ControladorAditivos(new ApexPages.StandardController(contrato));
        controlador.contratoId = contrato.Id;
        
        Test.startTest();
        Boolean clonado = controlador.getContratoClonado();
        Test.stopTest();
        
        System.assertEquals(true, clonado);
    }
    
}
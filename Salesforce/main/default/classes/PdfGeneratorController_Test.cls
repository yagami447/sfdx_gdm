@isTest
public class PdfGeneratorController_Test {

    private static final Test_Utils testUtils = Test_Utils.getInstance();
    
    public static testmethod void shouldGenerateOpportunityDocusignPDFRebaixaSacas() {
        PdfGeneratorController.generateOpportunityDocusignPDFFuture('006000000000000000', 'Anexo II Rebaixamento Sacas', false);
    }
    
    public static testmethod void shouldGenerateOpportunityDocusignPDFAnexoI() {
        PdfGeneratorController.generateOpportunityDocusignPDFFuture('006000000000000000', 'Anexo I', false);
    }
    
    public static testmethod void shouldGenerateOpportunityDocusignPDFReembalaje() {
        PdfGeneratorController.generateOpportunityDocusignPDFFuture('006000000000000000', 'Reembalaje', false);
    }
    
    public static testmethod void shouldGenerateContratoMultiplicacaoDocusignPDFForBRMXCerrado() {
        Contrato__c contratoMultiplicacaoObject = testUtils.createNewContratoMultiplicacao(null, null, null, null);
        insert contratoMultiplicacaoObject;
        PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF(contratoMultiplicacaoObject.Id, 'Termo Aditivo');
    }
    
    public static testmethod void shouldGenerateContratoMultiplicacaoDocusignPDFForBRMXRegion() {
        Contrato__c contratoMultiplicacaoObject = testUtils.createNewContratoMultiplicacao(new Contrato__c(Region_Comercial__c='REGION 1'), null, null, null);
        insert contratoMultiplicacaoObject;
        PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF(contratoMultiplicacaoObject.Id, 'Termo Aditivo');
    }
    
    public static testmethod void shouldGenerateContratoMultiplicacaoDocusignPDFForDSEMCerrado() {
        Contrato__c contratoMultiplicacaoObject = testUtils.createNewContratoMultiplicacao(new Contrato__c(Sociedad__c='DSEM'), null, null, null);
        insert contratoMultiplicacaoObject;
        PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF(contratoMultiplicacaoObject.Id, 'Termo Aditivo');
    }
    
    public static testmethod void shouldGenerateContratoMultiplicacaoDocusignPDFForDSEMRegion() {
        Contrato__c contratoMultiplicacaoObject = testUtils.createNewContratoMultiplicacao(new Contrato__c(Sociedad__c='DSEM',Region_Comercial__c='REGION 1'), null, null, null);
        insert contratoMultiplicacaoObject;
        PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF(contratoMultiplicacaoObject.Id, 'Termo Aditivo');
    }
    public static testmethod void shouldGenerateContratoMultiplicacaoDocusignPDFForNEOGRegion() {
        Contrato__c contratoMultiplicacaoObject = testUtils.createNewContratoMultiplicacao(new Contrato__c(Sociedad__c='NEOG',Region_Comercial__c='REGION 1'), null, null, null);
        insert contratoMultiplicacaoObject;
        PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF(contratoMultiplicacaoObject.Id, 'Termo Aditivo');
		PageReference pdf = Page.pdfContratoTA_NEOG_Sul;
    }

    @IsTest
    public static void constructorTest(){
        //Inicializacion y carga de datos
        PdfGeneratorController controller;
        Opportunity oportunidad = testUtils.createNewOpportunityAnexo2(null);
        oportunidad.Estados_Comercializacion__c = 'estado test';
        insert oportunidad;
        ApexPages.StandardController standarController = new ApexPages.StandardController(oportunidad);
        ApexPages.currentPage().getParameters().put('id', oportunidad.Id);
        //Test
        Test.startTest();
        controller = new PdfGeneratorController(standarController);
        Test.stopTest();
        //ASSERTS
        System.assertEquals('MarcaTeste', controller.marca);
        System.assertEquals('estadotest', controller.estCom );
    }

    @IsTest
    public static void impresionContratoGuardaChuva_attachment_Test(){
        //Inicializacion y carga de datos
        Contract contract = testUtils.createNewContract(null,null);
        insert contract;
        //Test
        Test.startTest();
        PdfGeneratorController.impresionContratoGuardaChuva(contract.Id);
        Test.stopTest();
        //ASSERTS
        System.assertEquals(1, [SELECT ID FROM Attachment WHERE ParentId = :contract.Id].size());
    }

    @IsTest
    public static void impresionContratoTA_Attachment_Test(){
        //Inicializacion y carga de datos
        Contrato__c contrato = testUtils.createNewContratoMultiplicacao(null,null,null,null);
        insert contrato;
        //Test
        Test.startTest();
        PdfGeneratorController.impresionContratoTA(contrato.Id);
        Test.stopTest();
        //ASSERTS
        System.assertEquals(1, [SELECT ID FROM Attachment WHERE ParentId = :contrato.Id].size());
    }

    @IsTest
    public static void initImpresionContratoGuardaChuva_Test(){
        //Inicializacion y carga de datos
        Contract contract = testUtils.createNewContract(null,null);
        insert contract;
        Account mutiplicador = [SELECT ID FROM Account WHERE Id = : contract.AccountId];
        mutiplicador.ShippingStreet = 'calle falsa 123';
        mutiplicador.BillingStreet = 'calle falsa 1234';
        update mutiplicador;
        ApexPages.StandardController standarController = new ApexPages.StandardController(contract);
        PdfGeneratorController controller = new PdfGeneratorController(standarController);
        ApexPages.currentPage().getParameters().put('id', contract.Id);
        //Test
        Test.startTest();
        controller.initImpresionContratoGuardaChuva();
        Test.stopTest();
        //ASSERTS
        System.assertEquals('callefalsa123', controller.dirUnidade.deleteWhitespace());
        System.assertEquals('callefalsa1234', controller.dirCorrespondencia.deleteWhitespace() );
    }

    @IsTest
    public static void initImpresionContratoTA_Test(){
        //Inicializacion y carga de datos
        Contrato__c contrato = testUtils.createNewContratoMultiplicacao(null,null,null,null);
        insert contrato;
        Account mutiplicador = [SELECT ID FROM Account WHERE Id = : contrato.Multiplicador__c];
        mutiplicador.IE__c = 'texto cualquiera';
        update mutiplicador;
        ApexPages.StandardController standarController = new ApexPages.StandardController(contrato);
        PdfGeneratorController controller = new PdfGeneratorController(standarController);
        ApexPages.currentPage().getParameters().put('id', contrato.Id);
        //Test
        Test.startTest();
        controller.initImpresionContratoTA();
        Test.stopTest();
        //ASSERTS
        System.assertEquals('AccountTest', controller.nombre);
        System.assertEquals('texto cualquiera', controller.inscEst);
    }
}
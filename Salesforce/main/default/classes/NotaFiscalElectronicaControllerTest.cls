@isTest
public class NotaFiscalElectronicaControllerTest {
    @testSetup static void setup() {
        Product2 prod = new Product2(Name='Generico Nota Fiscal');
        insert prod;
        
        PricebookEntry sPBE = new PricebookEntry(Pricebook2Id = test.getStandardPricebookId(), Product2Id = prod.id, UnitPrice = 1000);
        insert sPBE;
        
        
    }
    
    @isTest
	private static void controller_SearchNFE(){
		integer status = 200;
        string mock = WSNFeTest.MockNFe();
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 

        Test.startTest();
        String response = NotaFiscalElectronicaController.searchNFe('35161147508411011603551000077959551093041003',true);
        Test.stopTest();

		
        String expectedValue = JSON.serialize(NFeWapper.parse(WSNFeTest.MockNFe()));
        response = JSON.serialize(NFeWapper.parse(response));

        System.assertEquals(expectedValue, response);
	}

	@isTest
	private static void controller_SaveOpportunity() {
		integer status = 200;
        string mock = WSNFeTest.MockNFe();
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 
        Test.startTest();
		String response = NotaFiscalElectronicaController.searchNFe('35161147508411011603551000077959551093041003',true);

        String idNote = NotaFiscalElectronicaController.saveOpportunity(response);

        Test.stopTest();
		
		List<Nota_Fiscal_Eletr_nica__c> notas = [SELECT Id FROM Nota_Fiscal_Eletr_nica__c WHERE Id =: idNote];
		System.assertEquals(1, notas.size(), 'Deberias tener al menos una Nota Fiscal');
	}
    
    @isTest
	private static void controller_searchNFeError() {
        //Creo e inserto nota con NFe__c de Mock = 87878774456468954646464654654546545446579312.
        Nota_Fiscal_Eletr_nica__c nf = new Nota_Fiscal_Eletr_nica__c(NFe__c='87878774456468954646464654654546545446579312');
        insert nf;
      
		integer status = 200;
        string mock = WSNFeTest.MockNFe();
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 
        Test.startTest();
		String response = NotaFiscalElectronicaController.searchNFe('87878774456468954646464654654546545446579312',true);
        Test.stopTest();  
        System.assertEquals(response, 'Existe:'+nf.Id);     
	}  
    
     @isTest
	private static void controller_searchNFeUpdate() {
        //Creo e inserto nota con NFe__c de Mock = 87878774456468954646464654654546545446579312.
        Nota_Fiscal_Eletr_nica__c nf = new Nota_Fiscal_Eletr_nica__c(NFe__c='87878774456468954646464654654546545446579312');
       	nf.CPF__c = 'Campo a reemplazar';
        nf.CPF_Destinatario__c = 'Campo a reemplazar Destinatario';
        nf.Destinatario_Email__c = 'Campo a mantener';
        insert nf;
      
		integer status = 200;
        string mock = WSNFeTest.MockNFe();
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 
        Test.startTest();
		String response = NotaFiscalElectronicaController.searchNFeUpdate('35161147508411011603551000077959551093041003');
        
        String idNote = NotaFiscalElectronicaController.saveOpportunity(response);

        Test.stopTest();

        List<Nota_Fiscal_Eletr_nica__c> notas = [SELECT Id,CPF_Destinatario__c,CPF__c,Destinatario_Email__c FROM Nota_Fiscal_Eletr_nica__c WHERE Id =: idNote];

        System.assertEquals(1, notas.size(), 'Deberias tener al menos una Nota Fiscal');
        //MOCK con campos CPF__c y CPF_Destinatario__c en null.
        System.assertEquals(notas.get(0).CPF__c, null);
       	System.assertEquals(notas.get(0).CPF_Destinatario__c, null);
	}  
}
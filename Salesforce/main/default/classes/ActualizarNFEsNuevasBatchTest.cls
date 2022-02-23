@isTest
public class ActualizarNFEsNuevasBatchTest {
    
    @testSetup static void setup() {
        Product2 prod = new Product2(Name='Generico Nota Fiscal');
        insert prod;
        
        PricebookEntry sPBE = new PricebookEntry(Pricebook2Id = test.getStandardPricebookId(), Product2Id = prod.id, UnitPrice = 1000);
        insert sPBE;
    }

    @isTest
    static void test1() {
        Contact cont = new Contact(
        	LastName = 'Test'
        );
        insert cont;
        
        Nota_Fiscal_Eletr_nica__c nfe = new Nota_Fiscal_Eletr_nica__c(
        	NFe__c = '35161147508411011603551000077959551093041003',
            Consulta_de_Datos_Realizada__c = false,
            Vendedor__c = cont.Id
        );
        insert nfe;
        
        integer status = 200;
        string mock = WSNFeTest.MockNFe();
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 
        
        Test.startTest();        
        Database.executeBatch(new ActualizarNFEsNuevasBatch());
        Test.stopTest();
        
        nfe = [
            SELECT Consulta_de_Datos_Realizada__c, Status__c
            FROM Nota_Fiscal_Eletr_nica__c 
            WHERE Id = :nfe.Id
        ];
        
        System.assertEquals(true, nfe.Consulta_de_Datos_Realizada__c);
        System.assertEquals('Em Análise', nfe.Status__c);
    }
}
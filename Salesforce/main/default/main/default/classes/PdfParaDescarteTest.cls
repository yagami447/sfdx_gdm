@IsTest
public class PdfParaDescarteTest {
	@IsTest
    public static void printDescarteAutorizationTest(){
        //Inicialización y carga de datos
        Opportunity oportunidad = new Opportunity(
            Marca__c = 'algo',
            StageName = 'Edicion',
            CloseDate = System.today(),
            tienePdf__c = true,
            Name = 'Test'
        );
        insert oportunidad;
        //Test
        Test.startTest();
        PdfParaDescarte.printDescarteAutorization(oportunidad.id);
        Test.stopTest();
        //ASSERTS
        List<Attachment> documentos = [SELECT Id,Name FROM Attachment WHERE ParentId = : oportunidad.id];
        System.assertEquals( 1 , documentos.size());
        System.assertEquals( 'Test_algo_autorizacao_descarte.pdf' , documentos[0].name);
    }
}
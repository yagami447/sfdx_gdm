public class PdfParaDescarte  {

	@Future(Callout=true)
    public static void printDescarteAutorization(Id opId) {
        PageReference pdf = Page.PdfGeneratorTemplateDescarte;
		Opportunity op = [
            SELECT Id, Marca__c, Account.Nome_fantasia__c, tienePdf__c, Next_Step__c, Name
            FROM Opportunity 
            WHERE id = : opId
        ];
        pdf.getParameters().put('id',opId);

        Attachment attach = new Attachment();
        Blob body;

        try {
            body = pdf.getContent();
        } 
        catch (VisualforceException e) {
            body = Blob.valueOf('Some Text ' + e.getMessage());
        }
        attach.Body = body;

        attach.Name = op.Name + '_' + op.Marca__c + '_autorizacao_descarte.pdf';
        attach.IsPrivate = false;
        attach.ParentId = op.id;
        insert attach;
    }
}
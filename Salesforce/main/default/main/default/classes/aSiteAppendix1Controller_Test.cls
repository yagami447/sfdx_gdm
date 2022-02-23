@isTest
public class aSiteAppendix1Controller_Test {

    public static testMethod void shoudlReturnCorrectURL() {   
        dfsle__EnvelopeStatus__c envelopeStatusObject = new dfsle__EnvelopeStatus__c();
        envelopeStatusObject.dfsle__SourceId__c = 'OpportunityId';
        insert envelopeStatusObject;
        
        Attachment attachmentObject = new Attachment();
        attachmentObject.Name = 'Contrato';
        attachmentObject.ParentId = envelopeStatusObject.Id;
        attachmentObject.Body = Blob.valueOf('Teste');
        insert attachmentObject;
        
        aSiteAppendix1Controller app1ControllerObject = new aSiteAppendix1Controller();
        PageReference pageReferenceObject = app1ControllerObject.imprimirContratoAnexoI();
        System.assert(pageReferenceObject.getUrl().contains('/servlet/servlet.FileDownload?file='+attachmentObject.Id));
    }
}
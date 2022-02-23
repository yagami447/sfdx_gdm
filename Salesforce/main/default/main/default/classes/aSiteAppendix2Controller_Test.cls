@isTest
public class aSiteAppendix2Controller_Test {

    public static testMethod void shoudlReturnCorrectURL() {   
        dfsle__EnvelopeStatus__c envelopeStatusObject = new dfsle__EnvelopeStatus__c();
        envelopeStatusObject.dfsle__SourceId__c = 'OpportunityId';
        insert envelopeStatusObject;
        
        Attachment attachmentObject = new Attachment();
        attachmentObject.Name = 'Contrato';
        attachmentObject.ParentId = envelopeStatusObject.Id;
        attachmentObject.Body = Blob.valueOf('Teste');
        insert attachmentObject;
        
        aSiteAppendix2Controller app2ControllerObject = new aSiteAppendix2Controller();
        PageReference pageReferenceObject = app2ControllerObject.imprimirContratoReb();
        System.assert(pageReferenceObject.getUrl().contains('/servlet/servlet.FileDownload?file='+attachmentObject.Id));
    }
}
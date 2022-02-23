public class procesarEstimFaturamentoController {

    public Id Id { get; set; }
    public String safra { get; set; }
    public Opportunity opp { get; set; }

    //constructor to get the Case record
    public procesarEstimFaturamentoController (ApexPages.StandardController controller) {
    opp =  (Opportunity) controller.getRecord();
    Id = opp.Id;  
    Opportunity o = [Select Id, Safra__c From Opportunity Where Id =: Id];
    safra = o.Safra__c;  
    }

    //Method that can is called from the Visual Force page action attribute
    public PageReference procesarEstimativas() {       
       BRAXUtils.procesarEstimativasFaturamento(safra);
       PageReference pageRef = new PageReference('/'+Id);
       pageRef.setRedirect(true);
       return pageRef; //Returns to the case page
    }

}
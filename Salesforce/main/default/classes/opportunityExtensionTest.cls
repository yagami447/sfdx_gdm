@isTest
private class opportunityExtensionTest {

    static testMethod void EstandarOppTest() {        
		Opportunity opp = new Opportunity(
      RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Reembalaje').getRecordTypeId(),
      StageName = 'Edición',
      CloseDate = System.today()
    );		     
    insert opp;
    opp = [SELECT ID FROM Opportunity WHERE ID = :opp.Id ];
     	ApexPages.StandardController controller = new ApexPages.StandardController(opp);     
       Pagereference page1 = new Pagereference('/'+opp.Id);
       page1.getParameters().put('Id',opp.Id);
       Test.setCurrentPageReference(page1);
        opportunityExtension anexos0 = New opportunityExtension(controller);
        System.assertNotEquals(anexos0,null);        
    }
    
    static testMethod void OppNullTest() {
        
     	Map<String,Id> rt = New Map<String, Id>();
    	
    	for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
    		rt.put(reTy.Name, reTy.Id);
		     
        opportunityExtension anexos = New opportunityExtension();
        
    }
    
    static testMethod void opportunityExtensionOtrosTest(){
        opportunityExtension oppExtension = new opportunityExtension();
        List<Opportunity> opps = oppExtension.getresultAnexos();
        List<SelectOption> optionsAux = oppExtension.getTiposAnexos();
        optionsAux = oppExtension.getEtapasAnexos();
        oppExtension.listarAnexos();
        oppExtension.searchAnexos();       
    }
    
}
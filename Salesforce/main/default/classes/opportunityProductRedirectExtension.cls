public with sharing class opportunityProductRedirectExtension {

    Id oppId;
    
    public opportunityProductRedirectExtension(){
    	
    }

    // we are extending the OpportunityLineItem controller, so we query to get the parent OpportunityId
    public opportunityProductRedirectExtension(ApexPages.StandardController controller) {
        oppId = [select Id, OpportunityId from OpportunityLineItem where Id = :controller.getRecord().Id limit 1].OpportunityId;
    }
    
    // then we redirect to our desired page with the Opportunity Id in the URL
    public pageReference redirect(){
        return new PageReference('/apex/opportunityProductEntry?id=' + oppId);
    }
    
    @isTest(SeeAllData=true)
    static void test(){
    	Opportunity o = New Opportunity();
        o.Name = 'a';
        o.CloseDate = system.today();        
        o.StageName = 'Edición';
        o.Marca__c = 'BRMX';
        insert o;
                
        OpportunityProductRedirectExtension a = New OpportunityProductRedirectExtension();
        a.oppId = o.Id;
        PageReference pr = a.redirect();
        
        OpportunityLineItem i = [Select Id From OpportunityLineItem limit 1];
        opportunityProductRedirectExtension oPEE = new opportunityProductRedirectExtension(new ApexPages.StandardController(i));  
    }

}
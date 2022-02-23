global class aSiteProfileController {
    private String token;
    private SiteUser__c logUser;
    public String accSelect {get; set;}
    public SiteUserAccount__c[] relatedAccounts {get;set;}
    public string language {get;set;}
        
    global aSiteProfileController () {
        language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
    }

    public PageReference validate() {
        token = System.currentPageReference().getParameters().get('token');
        if(token!=null){
            logUser = aSiteAuthManager.VerifyUserSession(token);
            if(logUser!=null)
                return null;            
        }
        PageReference p = new PageReference('/apex/aSiteLogin');
        String marca = aSiteAuthManager.getMarcaBySession(token);
        if (marca != null)
        	p.getParameters().put('comp',marca);
        p.setRedirect(true);
        return p;        
    }
    
    public List<SiteUserAccount__c> getAccounts(){
        try{
            if(relatedAccounts != null && relatedAccounts.size()>0)
                return relatedAccounts;
                               
            relatedAccounts = aSiteAuthManager.getUserAccounts_byUser(logUser);
            
            return relatedAccounts;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,ex.getMessage()));
            return null;
        }
    }
    
    public SiteUser__c getUser(){
        return logUser;
    }
    
    public PageReference editProfile(){
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteProfileEdit');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }
    
    public PageReference editCancel() {
        PageReference pr = new PageReference('/apex/aSiteProfile');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }
    
    public PageReference saveProfile(){
        update logUser;
        PageReference pr = new PageReference('/apex/aSiteProfile');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }
    
    //public void setActiveAccount(){
    public PageReference setActiveAccount(){
        try{
            for(SiteUserAccount__c d : relatedAccounts ){
                d.Active__c = false;
                if((String)d.Id == accSelect){
                    d.Active__c = true;
                }            
            }
            update relatedAccounts;
            PageReference pr = new PageReference('/apex/aSiteProfile');
        	pr.setRedirect(true);
        	pr.getParameters().put('token',token);
        	pr.getParameters().put('mens','1');
        	return pr;
        }
        catch(Exception ex){        	
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,ex.getMessage()));
            return null;
        }
    }    
    
}
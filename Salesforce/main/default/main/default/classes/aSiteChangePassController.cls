public with sharing class aSiteChangePassController {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    private String token;
    public string language {get;set;}
    public string company {get; set;}
    private SiteUser__c logUser;

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

    public PageReference ChangePassword() {

        if(oldPassword == '' || oldPassword == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Old password is required!'));
            return null;
        }
        if(newPassword == '' || newPassword == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'New password is required!'));
            return null;
        }
        if(newPassword != verifyNewPassword){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'New password and Verify Password are not the same!'));
            return null;
        }
    
        boolean success = aSiteAuthManager.ChangePassword(token, newPassword, verifyNewPassword, oldpassword);
        PageReference pr = Page.aSiteActionConfirmation;
        pr.getParameters().put('comp', company);
        pr.setRedirect(true);
        
        if (success) {
            aSiteAuthManager.CloseUserSession(token);
            return pr;
        }
        return null;
    }     
    
    public aSiteChangePassController() {
        language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
        company = System.currentPageReference().getParameters().get('comp');
    }
}
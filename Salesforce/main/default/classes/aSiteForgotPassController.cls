/**
 * An apex page controller that exposes the portal site forgot password functionality
 * jgarmendia 17.04.07
 */
public with sharing class aSiteForgotPassController {
    public String username {get; set;}   
    public string language {get;set;}
    public String company {get; set;}
       
    public aSiteForgotPassController() {
        language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
        company = System.currentPageReference().getParameters().get('comp');
    }
    
    public PageReference forgotPassword() {    	    	
    
        if(username == '' || username == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.Email_is_required));
            return null;
        }

        aSiteUtils.retorno ret = aSiteAuthManager.ForgotPassword(username);
        PageReference pr = new PageReference('/apex/aSiteForgotPassConfirm');
        pr.getParameters().put('comp', company);
        pr.setRedirect(true);
        
        if (ret.exito) {                      
            return pr;
        }else{
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ret.mensaje));
        	return null;
        }
    }
    
    public PageReference forwardToLogin() {
        PageReference p = new PageReference('/apex/aSiteLogin');
        p.setRedirect(true);
        p.getParameters().put('comp',company);
        return p;
    }
    
}
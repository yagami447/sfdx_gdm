/**
 * An apex page controller that exposes the site login functionality
 * jgarmendia 17.04.07
 */
global class aSiteLoginController {
    global String username {get; set;}
    global String password {get; set;}
    global String company {get; set;}    
    global String ip {get; set;}
    public Boolean isLogged {get;set;}
    public string language {get;set;}
     
    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String token;
        SiteUser__c user; 

        if(username == '' || username == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Username_is_required));
            return null;
        }

        if(password == '' || password == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Password_is_required));
            return null;
        }
        
        user = aSiteAuthManager.UserLogin(username,password);        
        if(user == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Username_incorrent));
            return null;
        }
        
       /* if (!aAppManager.existeContratoParaCompany(user.Id, company)){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Username_incorrent));
            return null;
        }*/

        if (!user.Habilitado_BRMX__c && company == 'BRMX'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Username_incorrent));
            return null;
        }

        if (!user.Habilitado_DSEM__c && company == 'DSEM'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Username_incorrent));
            return null;
        }
        
        ip = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        if (ip == '' || ip == null) {
            ip = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        } 
        if (ip == '' || ip == null) {
            ip = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
        } 
  
        token = aSiteAuthManager.OpenUserSession(user.Id,ip,company);
                        
        if(token == null || token == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Username_incorrent));
            return null;
        }
        
        isLogged = true;
        
        if(!user.Cadastro_pela_primeira_vez__c){
            return forwardToChangePassPage(token);
        }
        else{
            return forwardToHomePage(token);
        }
    }

    global aSiteLoginController(){
        company = System.currentPageReference().getParameters().get('comp');
        //language = 'en_US';
        language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
    }
    
    public PageReference closeSession(){
        return null;
    }
    
    global PageReference forwardToHomePage(String strSessionToken) {
        PageReference p = new PageReference('/apex/aSiteHome');
        p.setRedirect(true);
        p.getParameters().put('token',strSessionToken);
        return p;
    }
    
    global PageReference forwardToChangePassPage(String strSessionToken) {
        PageReference p = new PageReference('/apex/aSiteChangePass');
        p.setRedirect(true);
        p.getParameters().put('token',strSessionToken);
        p.getParameters().put('comp',company);
        return p;
    }
    
    global PageReference forwardToLogin() {
        PageReference p = new PageReference('/apex/aSiteLogin');
        p.setRedirect(true);
        p.getParameters().put('comp',company);
        return p;
    }
    
    global PageReference forwardToForgotPassword() {
        PageReference p = new PageReference('/apex/aSiteForgotPass');
        p.setRedirect(true);
        p.getParameters().put('comp',company);
        return p;
    }

}
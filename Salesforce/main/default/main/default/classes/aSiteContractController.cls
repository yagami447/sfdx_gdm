global class aSiteContractController {
    private String token;
    private SiteUser__c logUser;
    private SiteUserSession__c activeSession;
    private Account activeAccount;
    
    public Contrato__c[] relatedContracts {get;set;}
    public List<Item_del_contrato__c> items {get; set;}
    public string recId{get;set;}
    public string language {get;set;}
    private String safraActual;
    
    global aSiteContractController () {
        //language = 'en_US';
        language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
    }
    
    public PageReference validate() {
        token = System.currentPageReference().getParameters().get('token');
        if(token!=null){
            logUser = aSiteAuthManager.VerifyUserSession(token);
            if(logUser!=null){
                activeSession = aSiteAuthManager.getUserSession(token);
                activeAccount = aSiteAuthManager.getActiveAccount_byUser(logUser);
                safraActual = aAppManager.getSafraActualByApp('Cont');
                return null;  
            }          
        }
        PageReference p = new PageReference('/apex/aSiteLogin');
        p.setRedirect(true);
        return p;

    }
    
    public List<Contrato__c> getContracts(){
        if(relatedContracts != null && relatedContracts.size()>0)
            return relatedContracts;
        try{    
            relatedContracts = new List<Contrato__c>();       
            relatedContracts = aSiteUtils.queryResults3(Contrato__c.SObjectType, null, 'Multiplicador__c = :v1', activeAccount.Id, 'Safra__c = :v2', safraActual, 'Sociedad__c = :v3',activeSession.Marca__c);
            if(relatedContracts.size()>0)
                recId=relatedContracts[0].Id;
            
            setActiveContract();
            
            return relatedContracts;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage()));
            return null;
        }
    }
    
    public void setActiveContract(){
        try{
            items = aSiteUtils.queryResults1(Item_del_Contrato__c.SObjectType, null, 'Contrato_de_Multiplicacion__c = :v1', recId);
            
            //items = [Select Id, Name, Variedade__c, Precio__c, Categoria__c, Cultivar__c From Item_del_Contrato__c where Contrato_de_Multiplicacion__c=:recId];
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,ex.getMessage()));
        }
    }    
    
    public SiteUser__c getUser(){
        return logUser;
    }
    public Account getAccount(){
        return activeAccount;
    }
}
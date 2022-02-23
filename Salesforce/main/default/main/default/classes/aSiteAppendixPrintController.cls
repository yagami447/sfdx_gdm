global without sharing class aSiteAppendixPrintController {
	
	private String token;
    private SiteUser__c logUser;
    private SiteUserSession__c activeSession;
    private Account activeAccount;
	
	public Opportunity appendix {get; set;}
	public List<OpportunityLineItem> appendixItems {get; set;}
	
	public String language {get;set;}	
	public String marcaImp {get;set;}
		
	public aSiteAppendixPrintController(ApexPages.StandardController controller){		
		String queryPlus = 'RecordType.Name, Account.Name, Account.CNPJ_CPF__c ';
		List<Opportunity> opps = aSiteUtils.queryResults1(Opportunity.SObjectType, queryPlus ,'Id = :v1', System.currentPageReference().getParameters().get('id'));				
		appendix = opps[0];
		appendixItems = aSiteUtils.queryResults2(OpportunityLineItem.SObjectType, null ,'OpportunityId = :v1', apexpages.currentpage().getparameters().get('id'), 'Item_Rebajado__c = :v2', false);
		
		language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
		
		if (appendix.Marca__c == 'BRMX')
			marcaImp = 'BRASMAX GENÉTICA';
			
		if (appendix.Marca__c == 'DSEM')
			marcaImp = 'DONMARIO SEMENTES';	
	}	
	
	public PageReference validate() {      
        token = System.currentPageReference().getParameters().get('token');

        if(token!=null){
            logUser = aSiteAuthManager.VerifyUserSession(token);
            if(logUser!=null){
                activeSession = aSiteAuthManager.getUserSession(token);
                activeAccount = aSiteAuthManager.getActiveAccount_byUser(logUser);
                return null;  
            }          
        }
                
        PageReference p = new PageReference('/apex/aSiteLogin');
        String marca = aSiteAuthManager.getMarcaBySession(token);
        if (marca != null)
        	p.getParameters().put('comp',marca);
        p.setRedirect(true);
        return p;

    }				
  	
  	public List<Schema.FieldSetMember> getFields() {
        if (appendix.RecordType.Name == 'Anexo II')
        	return SObjectType.OpportunityLineItem.FieldSets.AnexoII.getFields();
        if (appendix.RecordType.Name == 'Anexo II Rebaixamento Sacas')
        	return SObjectType.OpportunityLineItem.FieldSets.Anexo_Rebajamiento_Bolsas.getFields();
        if (appendix.RecordType.Name == 'Anexo III')
        	return SObjectType.OpportunityLineItem.FieldSets.Anexo_III.getFields();
        if (appendix.RecordType.Name == 'Anexo IV')
        	return SObjectType.OpportunityLineItem.FieldSets.Anexo_IV.getFields();
        if (appendix.RecordType.Name == 'Anexo V')
        	return SObjectType.OpportunityLineItem.FieldSets.Anexo_V.getFields();	
        	
        return null;
    }

}
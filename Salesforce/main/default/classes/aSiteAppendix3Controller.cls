global without sharing class aSiteAppendix3Controller {
    
    private static String ANEXO_RECORDTYPE = 'Anexo III';
    private static String ANEXO_LP = 'Lista Canal Multiplicadores';
    
    private String token;
    private SiteUser__c logUser;
    private SiteUserSession__c activeSession;
    private Account activeAccount;
    private String safraActual;
    
    private String rt_A3;
    private String rt_A2;
    private Map<String,Id> rty;
    private Map<String,PricebookEntry> rPb;
    private Map<String,aAppendix.myOppItem> mapOppApp1;
     
    public String language {get;set;}
    public String titulo {get;set;}
    private Map<String,String> rTypes;
     
    public Opportunity[] relatedApp {get;set;}
    public OpportunityLineItem[] relatedAppItems {get; set;}
    
    public Opportunity tmpAppII {get; set;}
    public aAppendix.myOppItem[] tmpAppItems {get; set;}
    public string recId{get;set;}
    public string editId{get;set;}
    
    public String enviarAprobacion{get;set;}
    
    private Map<string,string> mapCategorias;
    
    public String mensaje {get; set;}                
    
    global aSiteAppendix3Controller () {
        try{
            rty = Opp_Utils.cargarRecordTypesOportunidades();
            language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
            rTypes = Opp_Utils.cargarRecordTypesOppbyDevName();
            titulo = rTypes.get('Anexo_III');
            editId = System.currentPageReference().getParameters().get('e');
            enviarAprobacion = '0';
            getOptionCategoria();
        }
        catch(Exception e){
        }
    }
    
    public PageReference validate() {        
        token = System.currentPageReference().getParameters().get('token');        
        if(token!=null){
            logUser = aSiteAuthManager.VerifyUserSession(token);
            if(logUser!=null){
                activeSession = aSiteAuthManager.getUserSession(token);
                activeAccount = aSiteAuthManager.getActiveAccount_byUser(logUser);
                safraActual = aAppManager.getSafraActualByApp('A3');
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
    
    public List<Opportunity> getAppends3(){
        try{
            if(relatedApp != null && relatedApp.size()>0)
                return relatedApp;            

            relatedApp = aAppManager.getAnexos3(activeAccount.Id, safraActual, activeSession.Marca__c);

            if(relatedApp.size()>0){
                recId=relatedApp[0].Id;
                setActiveApp3();
            }
        
            return relatedApp;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
    
    public List<aAppendix.myOppItem> getApp3Items(){
        //Arma la grilla de productos activados para nuevo anexo 2, resuelvo items custom para edicion en sitio
        try{
        	if (tmpAppItems != null)
                return tmpAppItems;
        	
            List<aAppendix.myOppItem> tmpItems = new List<aAppendix.myOppItem>();
            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();
            Map<String,OpportunityLineItem> mapOppApp = new Map<String,OpportunityLineItem>();
            tmpOppItems = aAppManager.getAnexosItemsToA3(activeAccount.Id, safraActual, activeSession.Marca__c);            
            //verifico es esta activada la verificacion A de los Anexos 2
            //envio la lista de items cruda, y retorno la lista validada, sumatoria de area x cat+var entre A1 y A1 rebaja
            tmpOppItems = aAppManager.valAnexos3_A(tmpOppItems);
            
            if(editId!=null){
                for(OpportunityLineItem s : tmpOppItems){
                    if(!mapOppApp.containsKey(s.Categoria__r.Name+s.Variedade_Prod__c)){                           
                        mapOppApp.put(s.Categoria__r.Name+s.Variedade_Prod__c, s);
                    }
                }           
                tmpOppItems = aAppManager.getAnexosItemsByOpp(editId);
            }
            
            for(OpportunityLineItem s : tmpOppItems){
                aAppendix.myOppItem oli = new aAppendix.myOppItem();
                if(editId!=null) oli.id = s.Id;
                oli.variedad = s.PricebookEntry.Product2.Variedade__c;
                oli.variedad_nombre = s.Variedade_Prod__c;
                oli.variedad_registro = s.Variedad_de_Produto__c;
                oli.categoria = s.Categoria__r.Name;
                oli.categoria_id = s.Categoria__c;
                /*
                if(mapOppApp.containsKey(s.Categoria__r.Name+s.Variedade_Prod__c)){
                    OpportunityLineItem i = mapOppApp.get(s.Categoria__r.Name+s.Variedade_Prod__c);
                    oli.sem_bruta_A2 = String.valueOf(i.Semente_bruta__c);
                }
                else
                    if(s.Semente_bruta__c!=null) oli.sem_bruta_A2 = String.valueOf(s.Semente_bruta__c);
                */
                //if(s.Semente_bruta__c!=null && editId!=null) oli.sem_bruta = Integer.valueOf(s.Semente_bruta__c);                
                //////if(s.Semente_bruta__c!=null && editId!=null) oli.sem_bruta = String.valueOf(s.Semente_bruta__c);
                if(s.Semente_bruta__c!=null) oli.sem_bruta_A2 = String.valueOf(s.Semente_bruta__c);
                if(s.Semente_bruta__c!=null) oli.sem_bruta = String.valueOf(s.Semente_bruta__c);
                if(s.Semente_beneficiada__c!=null) oli.sem_beneficiada = String.valueOf(s.Semente_beneficiada__c);                
                if(s.Semente_aprovada__c!=null) oli.sem_aprobada = String.valueOf(s.Semente_aprovada__c);
                if(s.Semente_comercializada__c!=null) oli.sem_comer = String.valueOf(s.Semente_comercializada__c);
                if(s.Semente_uso_propio__c!=null) oli.sem_uso_propio = String.valueOf(s.Semente_uso_propio__c);                                

                tmpItems.add(oli);
            }
            
            tmpAppItems = tmpItems;
            
            if (tmpAppItems.size() == 0)
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(Label.Anexo_III_Val_Existe_Anexo_II)));
            
            return tmpItems;  
            
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()));
            return tmpAppItems;
            
        }
    }

    public PageReference submitAppend3(){        
        try{
        	PageReference pr = saveAppend3();
            if (pr != null){
        		aAppManager.enviarAnexoAprobacion(editId);        		
            	return pr;
        	}
            return null;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()));
            return null;
        }
 
    }
    
    public PageReference saveAppend3(){
        
        mensaje = '';
        
        try{
        	        	
        	String msg = '';                     
            aSiteUtils.retorno ret = aAppManager.saveAppend3(tmpAppItems, activeAccount.Id, safraActual, activeSession.Marca__c, editId, logUser, mapCategorias);
                                                       
            if (ret.exito == false){
                //msg = aSiteUtils.procesarAlerta(ret.mensaje);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
                mensaje = ret.mensaje;
                return null;
            }
            
            if (enviarAprobacion == '1')
                aAppManager.enviarAnexoAprobacion(ret.Id);
        	        	        	
        }
        catch(Exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            mensaje = e.getLineNumber() + ' ' + e.getMessage();
            return null;
        }
        
		aAppManager.updateSession(activeSession);
        
        PageReference pr = new PageReference('/apex/aSiteAppendix3');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
        
    }
    
    public List<SelectOption> getOptionCategoria(){
       List<SelectOption> lista = new List<SelectOption>();
       mapCategorias = New Map<string,string>();
       List<Categoria__c> categorias = aAppManager.getCategorias(); 
       if (categorias != null){
       	   for (Categoria__c c : categorias){
       	   	   mapCategorias.put(c.Id, c.Name); 	
       		   lista.add(new SelectOption(c.Id,c.Name));
       	   }
       }	
       return lista;
    }
    
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.OpportunityLineItem.FieldSets.Anexo_III.getFields();
    }
            
    public void setActiveApp3(){
        //Identifica que opp esta activa y consulta los items relacionados para mostrar en pantalla
        try{
            relatedAppItems = new List<OpportunityLineItem>();
            relatedAppItems = aAppManager.getAnexosItemsByOpp(recId);
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage()));
        }        
    }

    public PageReference gotoEdit(){
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix3Edit');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        pr.getParameters().put('e',editId);
        return pr;
    }
    
    public PageReference gotoNew(){
    	Boolean ret = aAppManager.validarNewA3(activeAccount.Id, safraActual, activeSession.Marca__c);
        if (ret){
        	String token = System.currentPageReference().getParameters().get('token');
	        PageReference pr = new PageReference('/apex/aSiteAppendix3Edit');
    	    pr.setRedirect(true);
        	pr.getParameters().put('token',token);
       		return pr;
       	}else{
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(Label.Anexo_III_Val_New_Anexo)));
        	return null;
        }
    }
    
    public PageReference editCancel() {
    	PageReference pr = new PageReference('/apex/aSiteAppendix3');
    	pr.setRedirect(true);
    	pr.getParameters().put('token',token);
        return pr; 
    }
    
    public PageReference imprimirAnexo3() {
    	PageReference pr = new PageReference('/apex/aSiteAppendixPrint');
        pr.setRedirect(true);
        pr.getParameters().put('id',recId);
        pr.getParameters().put('token',token);        
                
        return pr;         
    }
    
    public SiteUser__c getUser(){
        return logUser;
    }
    public Account getAccount(){
        return activeAccount;
    }
}
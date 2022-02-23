global class aSiteAppendix5Controller {
    private String token;
    private SiteUser__c logUser;
    private Account activeAccount;
    private SiteUserSession__c activeSession;
    private String safraActual;
    
    public Opportunity[] relatedApp {get;set;}
    public Opportunity[] relatedAppReb {get;set;}
    public OpportunityLineItem[] relatedAppItems {get; set;}
    public aAppendix.myOppItem[] tmpAppItems {get; set;}
    public aAppendix.myOppItem[] tmpAppItemsNew {get; set;}
    public aAppendix.myOppItem[] tmpAppItemsRemove {get; set;}
    public String recId {get;set;}
    public string editId{get;set;}
    private Map<String,Id> rty;
    
    public String language {get;set;}
    public String titulo {get;set;}
    private Map<String,String> rTypes;
    
    public String enviarAprobacion{get;set;}
    
    private Map<string,string> mapCategorias;
    private Map<string,string> mapVariedades;
    private Map<string,string> mapVariedadesNomReg;
    
    public String mensaje {get; set;}
    
    public String linea{get;set;}
    
    global aSiteAppendix5Controller () {
        try{
            rty = Opp_Utils.cargarRecordTypesOportunidades();
            language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
            rTypes = Opp_Utils.cargarRecordTypesOppbyDevName();
            titulo = rTypes.get('AnexoV');
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
                safraActual = aAppManager.getSafraActualByApp('A5');
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
        
    public List<Opportunity> getAppends5(){
        if(relatedApp != null && relatedApp.size()>0)
            return relatedApp;

        try{
            relatedApp = aAppManager.getAnexos5(activeAccount.Id, safraActual, activeSession.Marca__c);

            if(relatedApp.size()>0){
                recId=relatedApp[0].Id;
                setActiveApp5();
            }
        
            return relatedApp;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage()));
            return null;
        }
    }
    
    public List<aAppendix.myOppItem> getApp5Items(){
        //Arma la grilla de productos activados para nuevo anexo 2, resuelvo items custom para edicion en sitio
        try{
            if (tmpAppItems != null)
                return tmpAppItems;
            
            List<aAppendix.myOppItem> tmpItems = new List<aAppendix.myOppItem>();
            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();
                                    
            if(editId!=null)                                          
                tmpOppItems = aAppManager.getAnexosItemsByOpp(editId);
            
            Integer i = 0;            
            for(OpportunityLineItem s : tmpOppItems){
                aAppendix.myOppItem oli = new aAppendix.myOppItem();
                if(editId!=null)oli.id = s.Id;                  
                oli.variedad = s.PricebookEntry.Product2.Variedade__c;
                oli.variedad_nombre = s.Variedade_Prod__c;
                oli.variedad_registro = s.Variedad_de_Produto__c;
                oli.categoria = s.Categoria__r.Name;
                oli.categoria_id = s.Categoria__c;
                oli.estado_comer_id = s.Estado_de_Comercializacion__c;
                if(s.Semente_comercializada__c!=null) oli.sem_comer = String.valueOf(s.Semente_comercializada__c);
                oli.indice = i;
                i++;
                                              
                tmpItems.add(oli);
            }
            
            tmpAppItems = tmpItems;
            return tmpItems;  
            
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()));
            return tmpAppItems;
            
        }
    }
    
    public List<aAppendix.myOppItem> getApp5ItemsNew(){
        List<aAppendix.myOppItem> tmpItems = new List<aAppendix.myOppItem>();
        try{     
          
          if (tmpAppItemsNew != null)
              return tmpAppItemsNew;
                                                                            
            aAppendix.myOppItem oli = new aAppendix.myOppItem();
            tmpItems.add(oli);
            
            tmpAppItemsNew = tmpItems;                       
            return tmpItems;  
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return tmpAppItemsNew;
        }
    }
    
    public List<SelectOption> getOptionVariedadesAV(){
       List<SelectOption> lista = new List<SelectOption>();
       mapVariedades = New Map<string,string>();
       mapVariedadesNomReg = New Map<string,string>();
       Set<String> vari = New Set<String>();
       
       List<Opportunity> anexosIV = aAppManager.getAnexos3(activeAccount.Id, safraActual, activeSession.Marca__c);
       
       List<String> oppIds = New List<String>();
       for(Opportunity o : anexosIV)
           oppIds.add(o.Id);

       if (oppIds.size() > 0){
           List<Variedad__c> variedades = aAppManager.getVariedadesByOpp(oppIds);
           if (variedades != null){
               for (Variedad__c c : variedades){
                   mapVariedades.put(c.Id, c.Name);  
                   mapVariedadesNomReg.put(c.Id, c.Nombre_de_Registro__c);
                   lista.add(new SelectOption(c.Id,c.Name));
               }
           }           
       }
       
       if (lista.size() == 0)
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(Label.Anexo_V_Val_Existe_Anexo_IV)));       
              
       return lista;
    }
    
    public void setActiveApp5(){
        try{
            relatedAppItems = new List<OpportunityLineItem>();
            relatedAppItems = aAppManager.getAnexosItemsByOpp(recId);     
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage()));
        } 
    }
    
    public PageReference saveAppend5(){
        
        mensaje = '';
        
        try{
                        
            String msg = '';  
            aSiteUtils.retorno ret = aAppManager.saveAppend5(tmpAppItems, activeAccount.Id, safraActual, activeSession.Marca__c, editId, logUser, mapCategorias, mapVariedades, tmpAppItemsRemove);                                  
                  
            if (ret.exito == false){
                mensaje = ret.mensaje;
                return null;
            }
            
            if (enviarAprobacion == '1')
                aAppManager.enviarAnexoAprobacion(ret.Id);
                                    
        }
        catch(Exception e){
            mensaje = e.getLineNumber() + ' ' + e.getMessage();
            return null;
        }
        
        aAppManager.updateSession(activeSession);
        
        PageReference pr = new PageReference('/apex/aSiteAppendix5');
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
               if (c.Name == 'BASICA'){ 
                   mapCategorias.put(c.Id, c.Name);     
                   lista.add(new SelectOption(c.Id,c.Name));
               }
           }
       }    
       return lista;
    }
    
    public List<SelectOption> getOptionEstado(){
       List<SelectOption> lista = new List<SelectOption>();
       //mapCategorias = New Map<string,string>();
       List<Estado__c> estados = aAppManager.getEstados(); 
       if (estados != null){
           for (Estado__c c : estados){
               //mapCategorias.put(c.Id, c.Name);   
               lista.add(new SelectOption(c.Id,c.Name));
           }
       }    
       return lista;
    }
    
    public void agregarProd(){
       
       tmpAppItems.add(tmpAppItemsNew[0]);
       
       Integer j = 0;
       for (aAppendix.myOppItem i : tmpAppItems){
           i.indice = j;
           j++;    
       }
       
       List<aAppendix.myOppItem> tmpItems = new List<aAppendix.myOppItem>();
       aAppendix.myOppItem oli = new aAppendix.myOppItem();
       tmpItems.add(oli);
       tmpAppItemsNew = tmpItems;                              
              
    }
    
    public void removerProd(){
                          
       if (tmpAppItems[Integer.valueOf(linea)].id != null){
            if (tmpAppItemsRemove == null)
               tmpAppItemsRemove = New List<aAppendix.myOppItem>();    
           tmpAppItemsRemove.add(tmpAppItems[Integer.valueOf(linea)]);
       }
       tmpAppItems.remove(Integer.valueOf(linea));
       
       Integer j = 0;
       for (aAppendix.myOppItem i : tmpAppItems){
           i.indice = j;
           j++;    
       }
       
       linea = null;                          
              
    }
    
    public void completarNomRegNewItem(){
        if (tmpAppItemsNew.size() > 0){
            aAppendix.myOppItem item = tmpAppItemsNew[0];
            item.variedad_registro = mapVariedadesNomReg.get(item.variedad);
        }
    }
    
    public void completarNomRegItems(){
        if (tmpAppItems.size() > 0){
            for (aAppendix.myOppItem item : tmpAppItems)
                item.variedad_registro = mapVariedadesNomReg.get(item.variedad);
        }
    }

    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.OpportunityLineItem.FieldSets.Anexo_V.getFields();
    }
    
    public PageReference gotoEdit(){
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix5Edit');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        pr.getParameters().put('e',editId);
        return pr;
    }
    
    public PageReference gotoNew(){
        Boolean ret = aAppManager.validarNewA5(activeAccount.Id, safraActual, activeSession.Marca__c);      
        if (ret){
            String token = System.currentPageReference().getParameters().get('token');
            PageReference pr = new PageReference('/apex/aSiteAppendix5Edit');
            pr.setRedirect(true);
            pr.getParameters().put('token',token);
            return pr;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(Label.Anexo_V_Val_New_Anexo)));
            return null;
        }
    }
    
    public PageReference editCancel() {
        PageReference pr = new PageReference('/apex/aSiteAppendix5');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr; 
    }
    
    public PageReference imprimirAnexo5() {
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
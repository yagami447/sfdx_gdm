global without sharing class aSiteEstoqueController {
    
    private String token;
    private SiteUser__c logUser;
    private SiteUserSession__c activeSession;
    private Account activeAccount;
    private String safraActual;
    
    private Map<String,Id> rty;
     
    public String language {get;set;}
    public String titulo {get;set;}
    private Map<String,String> rTypes;
     
    public Opportunity[] relatedEstoque {get;set;}
    public OpportunityLineItem[] relatedEstoqueItems {get; set;}
    
    public aAppendix.myOppItem[] tmpAppItems {get; set;}
    public string recId{get;set;}
    public string editId{get;set;}
    
    private Map<string,string> mapCategorias;
    //private Map<string,string> mapVariedades;
        
    public String mes{get;set;}
    public String motivoRechazo{get;set;}
    public String enviarAprobacion{get;set;}
    
    public aAppendix.myOppItem[] tmpEstoqueItemsNew {get; set;}
    public aAppendix.myOppItem[] tmpAppItemsRemove {get; set;}
    private Map<string,string> mapVariedades;
    private Map<string,string> mapVariedadesNomReg;
    private Map<string,string> mapEstados;
    public Boolean mostrarSemAPItemsNew {get; set;}
    
    public String linea{get;set;}
    
    public String mensaje {get; set;}
    
            
    global aSiteEstoqueController () {
        try{
            language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
            titulo = 'Levantamento de estoque';
            enviarAprobacion = '0';
            
            editId = System.currentPageReference().getParameters().get('e');                        
            mes = System.currentPageReference().getParameters().get('m');
            
            mostrarSemAPItemsNew = true;
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
                safraActual = aAppManager.getSafraActualByApp('Estoque');
                if (editId == null || editId == ''){
                    mes = aAppManager.determinarMesStock(activeAccount.Id, safraActual, activeSession.Marca__c);
                }else{
                    motivoRechazo = aAppManager.getMotivoRechazo(editId);
                }                
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
    
    public List<SelectOption> getOptionMes(){
       List<SelectOption> lista = new List<SelectOption>();
       List<String> meses = aAppManager.getMeses(); 
       if (meses != null){
           lista.add(new SelectOption('',''));
            for (String s : meses){               
                lista.add(new SelectOption(s,s));
            }
       }  
       
       return lista;
    }
    
    public List<Opportunity> getEstoque(){
        try{
            if(relatedEstoque != null && relatedEstoque.size()>0)
                return relatedEstoque;            

            relatedEstoque = aAppManager.getEstoques(activeAccount.Id, safraActual, activeSession.Marca__c);

            if(relatedEstoque.size()>0){
                recId=relatedEstoque[0].Id;
                setActiveEstoque();
            }
        
            return relatedEstoque;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return null;
        }        
    }

    public List<aAppendix.myOppItem> getEstoqueItems(){
        //Arma la grilla de productos activados para nuevo estoque, resuelvo items custom para edicion en sitio
        try{
            List<aAppendix.myOppItem> tmpItems = new List<aAppendix.myOppItem>();
            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();
            List<OpportunityLineItem> tmpOppItems2 = new List<OpportunityLineItem>();
            Map<String,OpportunityLineItem> mapOppApp = new Map<String,OpportunityLineItem>();
             
            if (tmpAppItems != null)
                return tmpAppItems;
                                                           
            if(editId!=null){
                tmpOppItems = aAppManager.getAnexosItemsByOpp(editId);           
            }else{              
                tmpOppItems = aAppManager.getItemsToEstoque(activeAccount.Id, safraActual, activeSession.Marca__c);                                                           
                tmpOppItems = aAppManager.valEstoque_A(tmpOppItems, activeSession.Marca__c);
            }
            
            if (tmpOppItems.size() > 0)
                superSort.sortList(tmpOppItems, 'PricebookEntryId', 'asc');
            Set<String> mostrarApEstim = New Set<String>();
            for (OpportunityLineItem i : tmpOppItems){
                if (!mostrarApEstim.contains(i.PricebookEntryId)){
                    i.ZZPOSSF__c = 'x';
                    mostrarApEstim.add(i.PricebookEntryId);
                }
            }    
                        
            for(OpportunityLineItem s : tmpOppItems){
                aAppendix.myOppItem oli = new aAppendix.myOppItem();
                if(editId!=null) oli.id = s.Id;                
                oli.variedad = s.PricebookEntry.Product2.Variedade__c;
                oli.variedad_nombre = s.Variedade_Prod__c;
                oli.variedad_registro = s.Variedad_de_Produto__c;                
                oli.categoria_id = s.Categoria__c;
                oli.sem_comer = String.valueOf(s.Semente_comercializada__c);
                oli.sem_aprobada = String.valueOf(s.Semente_aprovada__c);    
                oli.estado_comer_id = s.Estado_de_Comercializacion__c;
                oli.estado_comer = s.Estado_de_Comercializacion__r.Name;
                if (oli.estado_comer_id == null || oli.estado_comer_id == '')
                    oli.estado_comer_id = '99';
                oli.cnpj = String.valueOf(s.ZZPOSSF__c);           
                
                tmpItems.add(oli);
            }
            
            Integer j = 0;
            for (aAppendix.myOppItem i : tmpItems){
                i.indice = j;
                j++;    
            }              
            
            tmpAppItems = tmpItems;
            
            //if (tmpAppItems.size() == 0)
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta('Não possui produtos no Anexo I')));
            
            return tmpItems;  
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return tmpAppItems;
        }
    }
    
    public List<aAppendix.myOppItem> getEstoqueItemsNew(){
        List<aAppendix.myOppItem> tmpItems = new List<aAppendix.myOppItem>();
        try{     
          
          if (tmpEstoqueItemsNew != null)
              return tmpEstoqueItemsNew;
                                                                            
            aAppendix.myOppItem oli = new aAppendix.myOppItem();
            tmpItems.add(oli);
            
            tmpEstoqueItemsNew = tmpItems;                       
            return tmpItems;  
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return tmpEstoqueItemsNew;
        }
    }
    
    public void completarNomRegNewItem(){      
      mostrarSemAPItemsNew = true;     
      if (tmpEstoqueItemsNew.size() > 0){
        aAppendix.myOppItem item = tmpEstoqueItemsNew[0];
        item.variedad_nombre = mapVariedades.get(item.variedad);
        item.variedad_registro = mapVariedadesNomReg.get(item.variedad);
        for (aAppendix.myOppItem i : tmpAppItems){
            if (i.variedad == item.variedad){
                mostrarSemAPItemsNew = false;
                break;
            }
        }         
      }
    }
    
    public void agregarProd(){
       
       mensaje = '';
       
       if (tmpEstoqueItemsNew[0].variedad == '99' || (mostrarSemAPItemsNew && (tmpEstoqueItemsNew[0].sem_aprobada == null || tmpEstoqueItemsNew[0].sem_aprobada == '')) || tmpEstoqueItemsNew[0].sem_comer == null || tmpEstoqueItemsNew[0].sem_comer == ''){
           mensaje = 'Todos os dados são obrigatórios';
           return;
       }
           
       /*if (mostrarSemAPItemsNew && !(Double.valueOf(tmpEstoqueItemsNew[0].sem_aprobada) > 0)){
           mensaje = 'Sem Aprovada deve ser maior que zero.';   
           return;
       }*/
       
       Boolean existenItemsConEstado = false;
       for (aAppendix.myOppItem i : tmpAppItems){
           if (i.estado_comer_id != '99')
               existenItemsConEstado = true;
       }
       
       if (tmpAppItems.size() > 0 && ((existenItemsConEstado && tmpEstoqueItemsNew[0].estado_comer_id == '99') || (!existenItemsConEstado && tmpEstoqueItemsNew[0].estado_comer_id != '99'))){
           mensaje = 'Deve inserir todos os itens com UF ou todos os itens sem UF.';
           return;
       }
       
       Boolean existeItem = false;
       for (aAppendix.myOppItem i : tmpAppItems){
           if (i.variedad == tmpEstoqueItemsNew[0].variedad && i.estado_comer_id == tmpEstoqueItemsNew[0].estado_comer_id)
               existeItem = true;
       }
       if (existeItem){
           mensaje = 'O item já existe.';
           return;
       }
       
       Boolean primeraVezVariedad = true;
       for (aAppendix.myOppItem i : tmpAppItems){
           if (i.variedad == tmpEstoqueItemsNew[0].variedad){
               primeraVezVariedad = false;
               break;
           }
       }
       if (primeraVezVariedad) 
           tmpEstoqueItemsNew[0].cnpj = 'x';
       
       tmpEstoqueItemsNew[0].estado_comer = mapEstados.get(tmpEstoqueItemsNew[0].estado_comer_id); 
       tmpAppItems.add(tmpEstoqueItemsNew[0]);
       
       Integer j = 0;
       for (aAppendix.myOppItem i : tmpAppItems){
           i.indice = j;
           j++;    
       }
       
       List<aAppendix.myOppItem> tmpItems = new List<aAppendix.myOppItem>();
       aAppendix.myOppItem oli = new aAppendix.myOppItem();
       tmpItems.add(oli);
       tmpEstoqueItemsNew = tmpItems;                              
              
    }
    
    public List<SelectOption> getOptionVariedadesEstoque(){
       List<SelectOption> lista = new List<SelectOption>();
       mapVariedades = New Map<string,string>();
       mapVariedadesNomReg = New Map<string,string>();
       Set<String> vari = New Set<String>();              
       
       //List<Opportunity> anexosI = aAppManager.getAnexos1(activeAccount.Id, safraActual, activeSession.Marca__c);
       
       lista.add(new SelectOption('99','-- None --'));
       mapVariedades.put('99', null);
       mapVariedadesNomReg.put('99', null);
       Set<String> variedadesAgregadas = New Set<String>();
       
       //List<String> oppIds = New List<String>();
       //for(Opportunity o : anexosI)
       //    oppIds.add(o.Id);               
       
       //if (oppIds.size() > 0){
           //List<Variedad__c> variedades = aAppManager.getVariedadesByOpp(oppIds);
           List<Variedad__c> variedades = aAppManager.getVariedadesByTA(activeAccount.Id, safraActual, activeSession.Marca__c);
           if (variedades != null){
               for (Variedad__c c : variedades){
                   mapVariedades.put(c.Id, c.Name);  
                   mapVariedadesNomReg.put(c.Id, c.Nombre_de_Registro__c);
                   if (!variedadesAgregadas.contains(c.Id)){
                       lista.add(new SelectOption(c.Id,c.Name));
                       variedadesAgregadas.add(c.Id);
                   }
               }
           }                                 
       //}
              
                     
       return lista;
    }
    
    public void removerProd(){
                          
       mensaje = '';
       
       if (tmpAppItems[Integer.valueOf(linea)].cnpj == 'x'){
           String variedad = tmpAppItems[Integer.valueOf(linea)].variedad;
           Integer j = 0;
           while (j < tmpAppItems.size()){
               if(tmpAppItems.get(j).variedad == variedad){  
                   if (tmpAppItems[Integer.valueOf(linea)].id != null){
                       if (tmpAppItemsRemove == null)
                           tmpAppItemsRemove = New List<aAppendix.myOppItem>();
                       tmpAppItemsRemove.add(tmpAppItems[j]);
                   }        
                   tmpAppItems.remove(j);
               }else{
                   j++;
               }
           }
       }else{
           if (tmpAppItems[Integer.valueOf(linea)].id != null){
               if (tmpAppItemsRemove == null)
                   tmpAppItemsRemove = New List<aAppendix.myOppItem>();    
               tmpAppItemsRemove.add(tmpAppItems[Integer.valueOf(linea)]);
           }
           tmpAppItems.remove(Integer.valueOf(linea));
       }     
                            
       Integer j = 0;
       for (aAppendix.myOppItem i : tmpAppItems){
           i.indice = j;
           j++;    
       }
       
       linea = null;                          
              
    }
    
    public List<SelectOption> getOptionEstado(){
       List<SelectOption> lista = new List<SelectOption>();
       mapEstados = New Map<string,string>();
       lista.add(new SelectOption('99','-- None --'));
       List<Estado__c> estados = aAppManager.getEstados(); 
       if (estados != null){
            for (Estado__c c : estados){          
                mapEstados.put(c.Id, c.Name);       
                lista.add(new SelectOption(c.Id,c.Name));
            }
       }  
       return lista;
    }
      
    public PageReference saveEstoque(){                
                
        try{                           
            
            //String msg = '';                     
            mensaje = '';
            aSiteUtils.retorno ret = aAppManager.saveEstoque(tmpAppItems, activeAccount.Id, safraActual, activeSession.Marca__c, mes, editId, logUser, tmpAppItemsRemove, mapVariedades);
                                                       
            if (ret.exito == false){
                mensaje = ret.mensaje;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
                return null;
            }
            
            if (enviarAprobacion == '1')
                aAppManager.enviarAnexoAprobacion(ret.Id);
                        
        }
        catch(Exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            mensaje = 'ERROR: ' + e.getLineNumber() + ' ' + e.getMessage();
            return null;
        }
        
        aAppManager.updateSession(activeSession);
        
        PageReference pr = new PageReference('/apex/aSiteEstoque');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
        
    }                               
    
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.OpportunityLineItem.FieldSets.Estoque_Multiplicador.getFields();
    }
    public void setActiveEstoque(){
        //Identifica que opp esta activa y consulta los items relacionados para mostrar en pantalla
        try{
            relatedEstoqueItems = new List<OpportunityLineItem>();
            relatedEstoqueItems = aAppManager.getAnexosItemsByOpp(recId);
            if (relatedEstoqueItems.size() > 0){
                superSort.sortList(relatedEstoqueItems, 'PricebookentryId', 'asc');

                Set<String> mostrarApEstim = New Set<String>();
                for (OpportunityLineItem i : relatedEstoqueItems){
                    if (!mostrarApEstim.contains(i.PricebookEntryId)){
                        i.ZZPOSSF__c = 'x';
                        mostrarApEstim.add(i.PricebookEntryId);
                    }
                }    
            }    
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getMessage())));
            
        }        
    }
    
    public PageReference gotoEdit(){
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteEstoqueEdit');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        pr.getParameters().put('e',editId);
        pr.getParameters().put('m',mes);
        return pr;
    }
    
    public PageReference gotoNew(){
        String ret = aAppManager.validarNewEstoque(activeAccount.Id, safraActual, activeSession.Marca__c);
        System.debug('Is valid date to estoque : '+ret);
        if (ret == 'true'){         
            String token = System.currentPageReference().getParameters().get('token');
            PageReference pr = new PageReference('/apex/aSiteEstoqueEdit');
            pr.setRedirect(true);
            pr.getParameters().put('token',token);
            return pr;
        }else if(ret == 'false'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(Label.Estoque_Val_New_Estoque)));
            return null; 
        }else if(ret == 'invalid_period'){
            String inititalDate = '20/'+System.today().month();
            String endDate = '03/'+(System.today().addMonths(+1).month());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta('Não é permitido lançar o estoque fora do prazo.Período permitido entre os dias '+inititalDate+' e '+endDate)));
        }           
        return null;
    }
        
    public PageReference editCancel() {
        PageReference pr = new PageReference('/apex/aSiteEstoque');
        pr.setRedirect(true);
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
global without sharing class aSiteAppendix2Controller {
    
    /*
    private static String ANEXO2_RECORDTYPE = 'Anexo II';
    private static String ANEXO2_REB_RECORDTYPE = 'Anexo II Rebaixamento Sacas';
    private static String ANEXO2_LP = 'Lista Canal Multiplicadores';
    */
    
    private String token;
    private SiteUser__c logUser;
    private SiteUserSession__c activeSession;
    private Account activeAccount;
    private String safraActual;
    
    /*
    private String rt_A1;
    private String rt_A2;
    private String rt_A2_Reb;
    */
    private Map<String,Id> rty;
    /*
    private Map<String,PricebookEntry> rPb;
    private Map<String,aAppendix.myOppItem> mapOppApp1;
    */
     
    public String language {get;set;}
    public String titulo {get;set;}
    public String tituloReb {get;set;}
    private Map<String,String> rTypes;
     
    public Opportunity[] relatedApp {get;set;}
    public Opportunity[] relatedAppReb {get;set;}
    public OpportunityLineItem[] relatedAppItems {get; set;}
    public OpportunityLineItem[] relatedAppRebItems {get; set;}
    
    /*
    public Opportunity tmpAppII {get; set;}
    public Opportunity tmpAppIIReb {get; set;}
    */
    public aAppendix.myOppItem[] tmpAppItems {get; set;}
    public aAppendix.myOppItem[] tmpAppItemsRebaja {get; set;}
    public aAppendix.myOppItem[] tmpAppItemsRebajaNew {get; set;}
    public aAppendix.myOppItem[] tmpAppItemsRebajaRemove {get; set;}
    public string recId{get;set;}
    public string recRebId{get;set;}
    public string editId{get;set;}
    public string editRebajaId{get;set;}
    public string aIIaRebajarId{get;set;}
    public string aIIaRebajarEpocaP{get;set;}
    
    private Map<string,string> mapCategorias;
    private Map<string,string> mapVariedades;
        
    public boolean selA2paraRebaja{get;set;}
    public String enviarAprobacion{get;set;}
    
    public String linea{get;set;}
    
    public String mensaje {get; set;} 
            
    global aSiteAppendix2Controller () {
        try{
            rty = Opp_Utils.cargarRecordTypesOportunidades();
            language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
            rTypes = Opp_Utils.cargarRecordTypesOppbyDevName();
            titulo = rTypes.get('AnexoII');
            tituloReb = rTypes.get('Anexo_II_Rebaixamento_Sacas');
            enviarAprobacion = '0';
            mapCategorias = new Map<String, String>();
            editId = System.currentPageReference().getParameters().get('e');
            editRebajaId = System.currentPageReference().getParameters().get('eReb');
            if (System.currentPageReference().getParameters().get('rebaja') != null)
                selA2paraRebaja = Boolean.valueOf(System.currentPageReference().getParameters().get('rebaja'));
            aIIaRebajarId = System.currentPageReference().getParameters().get('a2RebId');                               
            if (aIIaRebajarId != null)
                aIIaRebajarEpocaP = aAppManager.getEpocaPlantioByApp(aIIaRebajarId);
            
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
                safraActual = aAppManager.getSafraActualByApp('A2');
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
    
    public List<Opportunity> getAppends2(){
        try{
            if(relatedApp != null && relatedApp.size()>0)
                return relatedApp;            

            relatedApp = aAppManager.getAnexos2(activeAccount.Id, safraActual, activeSession.Marca__c);

            if(relatedApp.size()>0){
                recId=relatedApp[0].Id;
                setActiveApp2();
            }
        
            return relatedApp;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return null;
        }        
    }

    public List<Opportunity> getAppends2Reb(){
        try{
            if(relatedAppReb != null && relatedAppReb.size()>0)
                return relatedAppReb;            

            relatedAppReb = aAppManager.getAnexos2Rebaja(activeAccount.Id, safraActual, activeSession.Marca__c);

            if(relatedAppReb.size()>0){
                recRebId=relatedAppReb[0].Id;
                setActiveApp2Reb();
            }
        
            return relatedAppReb;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return null;
        }        
    }
    
    public List<aAppendix.myOppItem> getApp2RebItemsNew(){
        List<aAppendix.myOppItem> tmpItems = new List<aAppendix.myOppItem>();
        try{     
            
            if (tmpAppItemsRebajaNew != null)
                return tmpAppItemsRebajaNew;
                                                                              
            aAppendix.myOppItem oli = new aAppendix.myOppItem();
            tmpItems.add(oli);
            
            tmpAppItemsRebajaNew = tmpItems;
            return tmpItems;  
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return tmpAppItemsRebajaNew;
        }
    }
    
    public List<aAppendix.myOppItem> getApp2RebItems(){
        try{
            List<aAppendix.myOppItem> tmpItems = new List<aAppendix.myOppItem>();
            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();            
                                     
            if (tmpAppItemsRebaja != null)
                return tmpAppItemsRebaja;
                        
            if(editRebajaId!=null)              
                tmpOppItems = aAppManager.getAnexosItemsByOpp(editRebajaId);                                                               
              
            Integer i = 0;
            for(OpportunityLineItem s : tmpOppItems){
                aAppendix.myOppItem oli = new aAppendix.myOppItem();
                if(editRebajaId!=null) oli.id = s.Id;                                
                oli.variedad = s.PricebookEntry.Product2.Variedade__c;
                oli.variedad_nombre = s.Variedade_Prod__c;
                oli.categoria = s.Categoria__r.Name;
                oli.categoria_id = s.Categoria__c;
                oli.categoria_a_rebajar = s.Categoria_a_Rebaixar__r.Name;
                oli.categoria_a_rebajar_id = s.Categoria_a_Rebaixar__c;
                //oli.sem_rebajada = Integer.valueOf(s.Sem_Rebajada__c);                
                oli.sem_rebajada = String.valueOf(s.Sem_Rebajada__c);
                oli.lote_rebajado = s.Lote_Rebajado__c;
                oli.indice = i;
                i++;

                tmpItems.add(oli);
            }
            
            tmpAppItemsRebaja = tmpItems;            
            return tmpItems;  
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return tmpAppItemsRebaja;
        }
    }

    public List<aAppendix.myOppItem> getApp2Items(){
        //Arma la grilla de productos activados para nuevo anexo 2, resuelvo items custom para edicion en sitio
        try{
            List<aAppendix.myOppItem> tmpItems = new List<aAppendix.myOppItem>();
            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();
            List<OpportunityLineItem> tmpOppItems2 = new List<OpportunityLineItem>();
            Map<String,OpportunityLineItem> mapOppApp = new Map<String,OpportunityLineItem>();
             
            if (tmpAppItems != null)
                return tmpAppItems;
            
            String epocaPlantio = '';
            if(editId==null){
                epocaPlantio = aAppManager.getEpocaPlantioToA2(activeAccount.Id, safraActual, activeSession.Marca__c);          
            }else{
                tmpOppItems2 = aAppManager.getAnexosItemsByOpp(editId);
                epocaPlantio = tmpOppItems2[0].Opportunity.Epoca_de_Plantio__c;             
            }                                    
            tmpOppItems = aAppManager.getAnexosItemsToA2(activeAccount.Id, safraActual, activeSession.Marca__c, epocaPlantio);                                               
            //verifico es esta activada la verificacion A de los Anexos 2
            //envio la lista de items cruda, y retorno la lista validada, sumatoria de area x cat+var entre A1 y A1 rebaja
            tmpOppItems = aAppManager.valAnexos2_A(tmpOppItems);
            
            for(OpportunityLineItem s : tmpOppItems){
                if(!mapOppApp.containsKey(s.Categoria__r.Name+s.Variedade_Prod__c)){                           
                    mapOppApp.put(s.Categoria__r.Name+s.Variedade_Prod__c, s);
                }
            }
            if (tmpOppItems2.size() > 0)
                tmpOppItems = tmpOppItems2;
            
            for(OpportunityLineItem s : tmpOppItems){
                aAppendix.myOppItem oli = new aAppendix.myOppItem();
                if(editId!=null) oli.id = s.Id;                
                oli.variedad = s.PricebookEntry.Product2.Variedade__c;
                oli.variedad_nombre = s.Variedade_Prod__c;
                oli.variedad_registro = s.Variedad_de_Produto__c;
                oli.categoria = s.Categoria__r.Name;
                oli.categoria_id = s.Categoria__c;
                //oli.area_autorizada = Integer.valueOf(s.area__c);
                oli.area_autorizada = String.valueOf(s.area__c);
                if(mapOppApp.containsKey(s.Categoria__r.Name+s.Variedade_Prod__c)){
                    OpportunityLineItem i = mapOppApp.get(s.Categoria__r.Name+s.Variedade_Prod__c);
                    //oli.area_autorizada = Integer.valueOf(i.area__c);
                    oli.area_autorizada = String.valueOf(i.area__c);
                }
                //if(s.Area_Plantada__c!=null) oli.area_plantada = Integer.valueOf(s.Area_plantada__c);
                //if(s.Semente_bruta__c!=null) oli.sem_bruta = Integer.valueOf(s.Semente_bruta__c);                
                //if(s.Descarte__c!=null) oli.descarte = Integer.valueOf(s.Descarte__c);
                oli.area_plantada = String.valueOf(s.Area_plantada__c);
                oli.sem_bruta = String.valueOf(s.Semente_bruta__c);                
                oli.descarte = String.valueOf(s.Descarte__c);
                oli.epocaPlantio = epocaPlantio;

                tmpItems.add(oli);
            }
            
            tmpAppItems = tmpItems;
            
            if (tmpAppItems.size() == 0)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(Label.Anexo_II_Val_Existe_Anexo_I)));
            
            return tmpItems;  
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return tmpAppItems;
        }
    }

    /*
    public PageReference submitAppend2(){        
        try{
            PageReference pr = saveAppend2();
            if (pr != null){
                aAppManager.enviarAnexoAprobacion(editId);              
                return pr;
            }
            return null;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return null;
        }
 
    }*/
        
    public PageReference submitAppend2Rebaja(){        
        try{
            PageReference pr = saveAppend2Rebaja();
            if (pr != null){
                    aAppManager.enviarAnexoAprobacion(editRebajaId);
                return pr;
            }
            
            return null;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return null;
        }
 
    }        
    
    public PageReference saveAppend2(){       
    
        mensaje = '';         
                
        try{                           
            
            String msg = '';                     
            aSiteUtils.retorno ret = aAppManager.saveAppend2(tmpAppItems, activeAccount.Id, safraActual, activeSession.Marca__c, editId, logUser);
                                                       
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
            mensaje = e.getMessage();
            return null;
        }
        
        aAppManager.updateSession(activeSession);
        
        PageReference pr = new PageReference('/apex/aSiteAppendix2');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
        
    }
    
    public PageReference saveAppend2Rebaja(){
        Savepoint sp = Database.setSavepoint(); 

        try{
                        
            String msg = '';                     
            aSiteUtils.retorno ret = aAppManager.saveAppend2Rebaja(
                tmpAppItemsRebaja,
                aIIaRebajarId,
                aIIaRebajarEpocaP,
                activeAccount.Id, 
                safraActual,
                activeSession.Marca__c,
                editRebajaId, 
                mapVariedades,
                mapCategorias, 
                tmpAppItemsRebajaRemove
                //logUser
            );
                                                       
            if (ret.exito == false){
                msg = aSiteUtils.procesarAlerta(ret.mensaje);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
                return null;
            }
            if (enviarAprobacion == '1')
                aAppManager.enviarAnexoAprobacion(ret.Id);
            
        }
        catch(Exception e){
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getLineNumber() + ' ' + e.getMessage())));
            return null;
        }
        aAppManager.updateSession(activeSession);
        
        PageReference pr = new PageReference('/apex/aSiteAppendix2Reb');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;    

    }        
    
    public void agregarProdRebaja(){
       
       tmpAppItemsRebaja.add(tmpAppItemsRebajaNew[0]);
       
       Integer j = 0;
       for (aAppendix.myOppItem i : tmpAppItemsRebaja){
           i.indice = j;
           j++;     
       }
       
       List<aAppendix.myOppItem> tmpItems = new List<aAppendix.myOppItem>();
       aAppendix.myOppItem oli = new aAppendix.myOppItem();
       tmpItems.add(oli);
       tmpAppItemsRebajaNew = tmpItems;                   
              
    }
    
    public void removerProdRebaja(){
                          
       if (tmpAppItemsRebaja[Integer.valueOf(linea)].id != null){
           if (tmpAppItemsRebajaRemove == null)
               tmpAppItemsRebajaRemove = New List<aAppendix.myOppItem>();       
           tmpAppItemsRebajaRemove.add(tmpAppItemsRebaja[Integer.valueOf(linea)]);
       }
       tmpAppItemsRebaja.remove(Integer.valueOf(linea));
       
       Integer j = 0;
       for (aAppendix.myOppItem i : tmpAppItemsRebaja){
           i.indice = j;
           j++;     
       }
       
       linea = null;                          
              
    }
    
    public List<SelectOption> getOptionCategoria(){

        String variedadSeleccionadaID = tmpAppItemsRebajaNew[0].variedad;
        List<SelectOption> lista = new List<SelectOption>();
        lista.add(new SelectOption('-- Categoria --', '-- Categoria --'));
        if (tmpAppItemsRebajaNew[0].variedad != null && tmpAppItemsRebajaNew[0].variedad != '--- Variedades ---'){

            Map<string, string> thisMapCategorias = new Map<string, string>();
            List<OpportunityLineItem> A2_Olis = [SELECT ID, NAME, Categoria__c, Categoria__r.Name, Categoria__r.id, Categoria_a_Rebaixar__c, Categoria_a_Rebaixar__r.Name, Categoria_a_Rebaixar__r.id, Item_Rebajado__c, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, PricebookEntry.Product2.Variedade__r.id, PricebookEntry.Product2.Categ__c, PricebookEntry.Product2.Categ__r.Name, PricebookEntry.Product2.Categ__r.id
                                                 FROM OpportunityLineItem
                                                 WHERE OpportunityId = :aIIaRebajarId AND Item_Rebajado__c = false];

            System.debug('Line items found : ' + A2_Olis.size());
            for (OpportunityLineItem oli : A2_Olis){
                if (oli.PricebookEntry.Product2.Variedade__c == variedadSeleccionadaID && oli.Categoria__c != null){
                    if (!thisMapCategorias.containsKey(oli.Categoria__c)){
                        lista.add(new SelectOption(oli.Categoria__c, oli.Categoria__r.Name));
                        thisMapCategorias.put(oli.Categoria__c, oli.Categoria__r.Name);
                        mapCategorias.put(oli.Categoria__c, oli.Categoria__r.Name);
                    }
                }
            }
        } else{
            tmpAppItemsRebajaNew[0].categoria_a_rebajar_id = null;
            tmpAppItemsRebajaNew[0].categoria_id = null;
        }

        return lista;
    }
    
    public List<SelectOption> getOptionVariedadesAII(){
       List<SelectOption> lista = new List<SelectOption>();
       mapVariedades = New Map<string,string>();
       Set<String> vari = New Set<String>();
       
       List<String> oppIds = New List<String>();
       oppIds.add(aIIaRebajarId);
       //List<Variedad__c> variedades = aAppManager.getVariedadesByOpp(aIIaRebajarId);
       List<Variedad__c> variedades = aAppManager.getVariedadesByOpp(oppIds);
       if (variedades != null){
           for (Variedad__c c : variedades){
               mapVariedades.put(c.Id, c.Name); 
               lista.add(new SelectOption(c.Id,c.Name));
           }
       }
              
       return lista;
    }
    
    public PageReference testFunction(){
        return null;
    }



    /*

     private List<Categoria__c> getCategoriaOrigemAnexoII(){

     List<Opportunity> oppA2 = getAppends2();
     List<OpportunityLineItem> A2_Olis =[SELECT ID,NAME,Categoria__r.Name,Categoria_a_Rebaixar__c,Categoria_a_Rebaixar__r.Name,Categoria_a_Rebaixar__r.id,Item_Rebajado__c,PricebookEntry.Product2.Categ__c,PricebookEntry.Product2.Categ__r.Name,PricebookEntry.Product2.Categ__r.id FROM OpportunityLineItem WHERE OpportunityId =: oppA2[0].id AND Item_Rebajado__c = false];


     List<Categoria__c> categorias = new List<Categoria__c>();
     for(OpportunityLineItem oli : A2_Olis){
     categorias.add(oli.PricebookEntry.Product2.Categ__r);
     }
     return categorias;
     }

     public List<SelectOption> getOptionCategoria(){
     System.debug('ITEMS SIZE : '+tmpAppItemsRebajaNew.size());
     System.debug('Selected Variety : '+tmpAppItemsRebajaNew[0].variedad);
     List<SelectOption> lista = new List<SelectOption>();
     Map<string,string> thisMapCategorias = new Map<string,string>();
     List<Categoria__c> categorias = getCategoriaOrigemAnexoII();

     if (categorias != null){
     for (Categoria__c c : categorias){
     if(!thisMapCategorias.containsKey(c.Id)){
     thisMapCategorias.put(c.Id, c.Name);
     lista.add(new SelectOption(c.Id,c.Name));
     }
     }
     }
     return lista;
     }*/
    public List<SelectOption> getOptionCategoriaRebaixada(){
        System.debug('getOptionCategoriaRebaixada');
        List<SelectOption> lista = new List<SelectOption>();
        lista.add(new SelectOption('-- Cat Rebaixada --', '-- Cat Rebaixada --'));
        try{
            if (tmpAppItemsRebajaNew[0].categoria_a_rebajar_id != null){
                String categoriaSeleccionada = tmpAppItemsRebajaNew[0].categoria_a_rebajar_id;

                Categoria__c selectedCategory = new Categoria__c();
                Map<string, string> thisMapCategorias = new Map<string, string>();
                List<Categoria__c> filteredCategories = getCategoriasRebaixadasForCategriaOrigem(categoriaSeleccionada);
                integer counter = 0;
                for (Categoria__c catOrigem : filteredCategories){
                    if (!thisMapCategorias.containsKey(catOrigem.id)){
                        thisMapCategorias.put(catOrigem.Id, catOrigem.Name);
                        mapCategorias.put(catOrigem.Id, catOrigem.Name);
                        lista.add(new SelectOption(catOrigem.Id, catOrigem.Name));
                    }
                }
            }
            return lista;
        } catch (Exception e){
            return lista;
        }
    }

    public List<SelectOption> getFullCategorias(){
        List<SelectOption> lista = new List<SelectOption>();
        List<Categoria__c> categorias = [SELECT id, Name
                                         FROM Categoria__c
                                         WHERE Name in ('BASICA', 'C1', 'C2', 'S1', 'S2')];

        for (Categoria__c c : categorias){
            lista.add(new SelectOption(c.id, c.name));
        }
        return lista;
    }

    public List<Categoria__c> getCategoriasRebaixadasForCategriaOrigem(String idCatOrigen){
        List<Categoria__c> categorias = [SELECT id, Name
                                         FROM Categoria__c
                                         WHERE Name in ('BASICA', 'C1', 'C2', 'S1', 'S2')];
        Categoria__c selectedCat;
        Integer selectedIndex = 0;
        for (Categoria__c c : categorias){
            if (c.id == idCatOrigen){
                selectedCat = c;
                break;
            }
            selectedIndex++;
        }

        if (selectedCat != null){
            switch on selectedCat.Name{
                when 'BASICA'{
                    removeByName(categorias, 'BASICA');
                }
                when 'C1'{
                    removeByName(categorias, 'BASICA');
                    removeByName(categorias, 'C1');
                }
                when 'C2'{
                    removeByName(categorias, 'BASICA');
                    removeByName(categorias, 'C1');
                    removeByName(categorias, 'C2');
                }
                when 'S1'{
                    removeByName(categorias, 'BASICA');
                    removeByName(categorias, 'C1');
                    removeByName(categorias, 'C2');
                    removeByName(categorias, 'S1');
                }
                when 'S2'{
                    removeByName(categorias, 'BASICA');
                    removeByName(categorias, 'C1');
                    removeByName(categorias, 'C2');
                    removeByName(categorias, 'S1');
                }
            }
            return categorias;
        } else
            return null;
    }

    private void removeByName(List<Categoria__c> categorias, String nameToDelete){
        Integer index = 0;
        for (Categoria__c cat : categorias){
            if (cat.Name == nameToDelete){
                break;
            }
            index++;
        }
        if (index != null)
            categorias.remove(index);
    }

    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.OpportunityLineItem.FieldSets.AnexoII.getFields();
    }
    public List<Schema.FieldSetMember> getFieldsReb() {
        return SObjectType.OpportunityLineItem.FieldSets.Anexo_Rebajamiento_Bolsas.getFields();
    }        
    public void setActiveApp2(){
        //Identifica que opp esta activa y consulta los items relacionados para mostrar en pantalla
        try{
            relatedAppItems = new List<OpportunityLineItem>();
            relatedAppItems = aAppManager.getAnexosItemsByOpp(recId);
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getMessage())));
        }        
    }
    public void setActiveApp2Reb(){
        //Identifica que opp esta activa y consulta los items relacionados para mostrar en pantalla
        try{
            relatedAppRebItems = new List<OpportunityLineItem>();
            relatedAppRebItems = aAppManager.getAnexosItemsByOpp(recRebId);
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(e.getMessage())));
        }        
    }

    public PageReference gotoEdit(){
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix2Edit');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        pr.getParameters().put('e',editId);
        return pr;
    }
    
    public PageReference gotoNew(){
        Boolean ret = aAppManager.validarNewA2(activeAccount.Id, safraActual, activeSession.Marca__c);
        if (ret){           
            String token = System.currentPageReference().getParameters().get('token');
            PageReference pr = new PageReference('/apex/aSiteAppendix2Edit');
            pr.setRedirect(true);
            pr.getParameters().put('token',token);
            return pr;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(Label.Anexo_II_Val_New_Anexo)));
            return null;
        }
    }
    
    public PageReference gotoNewRebajaSel(){
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix2');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        pr.getParameters().put('rebaja','true');
        return pr;
    }
    
    public PageReference gotoNewRebaja(){
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix2RebEdit');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);  
        pr.getParameters().put('a2RebId',aIIaRebajarId);
        return pr;
    }
    
    public PageReference gotoEditRebaja(){
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix2RebEdit');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        pr.getParameters().put('eReb',editRebajaId);
        pr.getParameters().put('a2RebId',aIIaRebajarId);
        return pr;
    }
    
    public PageReference editCancel() {
        PageReference pr = new PageReference('/apex/aSiteAppendix2');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);        
        return pr;         
    }
    
    public PageReference editRebajaCancel() {
        PageReference pr = new PageReference('/apex/aSiteAppendix2Reb');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);        
        return pr;         
    }
    
    public PageReference imprimirAnexo2() {
        PageReference pr = new PageReference('/apex/aSiteAppendixPrint');
        pr.setRedirect(true);
        pr.getParameters().put('id',recId);
        pr.getParameters().put('token',token);        
                
        return pr;         
    }
    
    public PageReference imprimirAnexo2Reb() {
        PageReference pr = new PageReference('/apex/aSiteAppendixPrint');
        pr.setRedirect(true);
        pr.getParameters().put('id',recRebId);
        pr.getParameters().put('token',token);        
                
        return pr;         
    }
    
    public PageReference imprimirContratoReb() {
        String documentId;        
        dfsle__EnvelopeStatus__c envelopeStatusObject;
        List<Attachment> attachmentObjectList;
        if(!Test.isRunningTest()) {
            envelopeStatusObject = [SELECT Id FROM dfsle__EnvelopeStatus__c WHERE Oportunidade__c =: recRebId LIMIT 1];
        } else {
            envelopeStatusObject = [SELECT Id FROM dfsle__EnvelopeStatus__c WHERE dfsle__SourceId__c = 'OpportunityId' LIMIT 1];
        }
        attachmentObjectList = [SELECT Id, Name FROM Attachment WHERE ParentId = :envelopeStatusObject.Id];
        for(Attachment attachmentObject : attachmentObjectList) {
            if(!attachmentObject.Name.contains('Certificate')) {
                documentId = attachmentObject.Id;
            }
        }
        System.debug(documentId);
        String downloadUrl = ('/servlet/servlet.FileDownload?file='+documentId);
        PageReference pr = new PageReference(downloadUrl);
        pr.setRedirect(true); 
        System.debug(downloadUrl);
        return pr;         
    }
    
    public SiteUser__c getUser(){
        return logUser;
    }
    public Account getAccount(){
        return activeAccount;
    }
}
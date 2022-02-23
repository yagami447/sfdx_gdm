/*
        @Author: Sergio Migueis - K2
        @Description: Apex controller for lightning (Aura and LWC) responsible for
                        Fetching and Organizing data for OpportunityLineItems

        @History:
        22/11/2019 - Creation. With Converted Methods
        08/12/2019 - Deploy from scratchorg
        14/12/2019 - Refactor with validations.
 */
public with sharing class AddOpportunityLineItemController{

    @AuraEnabled
    public static Opportunity getTheOpportunity(String recordId){
        System.debug(recordId);
        return DAOOpportunity.getInstance().get(recordId);
    }

    @AuraEnabled
    public static List<OpportunityLineItem> getShoppingCart(String recordId){
        //Comes ordered by Variedade_Prod__c.
        List<OpportunityLineItem> items = DAOOpportunityLineItem.getInstance().getByOpportunityId(recordId);
        if(items != null && items.size() > 0){
            for(Integer i = 0; i < items.size(); i++){
                items.get(i).ZZPOSSF__c = String.valueOf(i); //corrects the number
            }
        }
        return items;
    }

    @AuraEnabled
    public static List<Map<String,String>> getNeedBasedOnOpportunity(String recordId){
        //We need clarification on this business logistic.
        Opportunity theOpp = getTheOpportunity(recordId);
        List<Map<String,String>> optionsTipoNecesidad = new List<Map<String,String>>();
        if (theOpp != null){
            if (theOpp.RecordType.Name == 'PB-Comercial' || theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'VB - Pendiente' || theOpp.RecordType.Name == 'VB - Rechazada' || theOpp.RecordType.Name == 'VB - Autorizada' || theOpp.RecordType.Name == 'Objetivo Ventas Semilla'){
                Map<String,String> multOption = new Map<String,String>();
                multOption.put('value','Multiplicação');
                multOption.put('label','Multiplicação');  
                optionsTipoNecesidad.add(multOption);
                
                multOption = new Map<String,String>();
                multOption.put('value','Difusão Multiplicador');
                multOption.put('label','Difusão Multiplicador');  
                optionsTipoNecesidad.add(multOption);
                
                multOption = new Map<String,String>();
                multOption.put('value','Difusão Comercial');
                multOption.put('label','Difusão Comercial');  
                optionsTipoNecesidad.add(multOption);

                multOption = new Map<String,String>();
                multOption.put('value','Dia de Campo');
                multOption.put('label','Dia de Campo');  
                optionsTipoNecesidad.add(multOption);

                multOption = new Map<String,String>();
                multOption.put('value','Lado a Lado');
                multOption.put('label','Lado a Lado');  
                optionsTipoNecesidad.add(multOption);

                multOption = new Map<String,String>();
                multOption.put('value','Strip Test');
                multOption.put('label','Strip Test');  
                optionsTipoNecesidad.add(multOption);             
            }
            if (theOpp.RecordType.Name == 'PB-Desarrollo' || theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'VB - Pendiente' || theOpp.RecordType.Name == 'VB - Autorizada'){
                Map<String,String> multOption = new Map<String,String>();
                multOption.put('value','Desenvolvimento');
                multOption.put('label','Desenvolvimento');  
                optionsTipoNecesidad.add(multOption);
            }
        }
        return optionsTipoNecesidad;
    }

    @AuraEnabled
    public static List<Map<String,String>> getOptionCategoria(){
       List<Map<String,String>> lista = new List<Map<String,String>>();
       List<Categoria__c> categories = DAOCategoria.getInstance().getBasedOnNamesForOpportunity();
       for (Categoria__c c : categories){    
            Map<String,String> option = new Map<String,String>();
            option.put('value',c.Id);
            option.put('label',c.Name);                   
            lista.add(option);
       }
       return lista;
    }

    //Unidades não tem em lugar nenhum na org, todo local usa o mesmo modelo:
    @AuraEnabled
    public static List<Map<String,String>> getOptionUnidades(){
        List<Map<String,String>> lista = new List<Map<String,String>>();

        Map<String,String> optionQuilograma = new Map<String,String>();
        optionQuilograma.put('value','Quilograma');
        optionQuilograma.put('label','Quilograma');                   
        lista.add(optionQuilograma);

        Map<String,String> option25 = new Map<String,String>();
        option25.put('value','Saca 25Kg');
        option25.put('label','Saca 25Kg');                   
        lista.add(option25);

        Map<String,String> option40 = new Map<String,String>();
        option40.put('value','Saca 40Kg');
        option40.put('label','Saca 40Kg');                   
        lista.add(option40);

        Map<String,String> optionTonelada = new Map<String,String>();
        optionTonelada.put('value','Tonelada');
        optionTonelada.put('label','Tonelada');                   
        lista.add(optionTonelada);
        
        return lista;
    }

    @AuraEnabled
    public static List<Map<String,String>> getStates(){
        List<Map<String,String>> lista = new List<Map<String,String>>();
        List<Estado__c> states = DAOState.getInstance(DTOUtils.SharingMode.Without).getAll();
        for (Estado__c c : states){    
            Map<String,String> option = new Map<String,String>();
            option.put('value',c.Id);
            option.put('label',c.Name);                   
            lista.add(option);
        }
        return lista;
    }
    
    @AuraEnabled
    public static Map<Id, User> getUsers(){
        //Returns all visible to user.
        return new Map<Id,User>(DAOUser.getInstance(DTOUtils.SharingMode.Without).getAll());
    }

    @AuraEnabled
    public static List<OpportunityLineItem> getRelatedOli(String recordId){        
        Opportunity theOpp = DAOOpportunity.getInstance().get(recordId);
        List<OpportunityLineItem> items = null;
        if(theOpp.RecordType.Name == 'Anexo V'){
            items = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getAllForA3(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId);
        }else{
            items = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without)
                                                .getByOpportunityId(theOpp.Anexo_Relacionado__c);
        }

        List<OpportunityLineItem> itemsFiltrado = new List<OpportunityLineItem>();
        if(theOpp.RecordType.DeveloperName == 'Anexo_II_Rebaixamento_Sacas'){
            for(OpportunityLineItem oli : items){
                if(oli.Categoria__r.Name != 'S2'){
                    itemsFiltrado.add(oli);
                }
            }
        }else{
            itemsFiltrado = items;
        }
        return itemsFiltrado;
    }

    @AuraEnabled
    public static Map<String,Object> getConfigurationBMX(String recordId){
        Map<Id, User> propRol = getUsers();
        System.debug('Result'+propRol);
        Opportunity theOpp = DAOOpportunity.getInstance().get(recordId);
        Decimal sumaTasas = 0;
        Configuracion_BMX__c confTasas = New Configuracion_BMX__c(Londrina_Tasa_COFINS__c=0, Londrina_Tasa_ISS__c=0, Londrina_Tasa_PIS__c=0, Passo_Fundo_Tasa_COFINS__c=0, Passo_Fundo_Tasa_ISS__c=0, Passo_Fundo_Tasa_PIS__c=0);
        if((theOpp.RecordType.Name == 'Pendiente' || theOpp.RecordType.Name == 'NC - Pendiente') && theOpp.Origen__c != null){
            Configuracion_BMX__c conf = DAOConfiguracionBMX.getInstance().getFirst();
            if (conf.Londrina_Tasa_COFINS__c != null) confTasas.Londrina_Tasa_COFINS__c = conf.Londrina_Tasa_COFINS__c;
            if (conf.Londrina_Tasa_ISS__c != null) confTasas.Londrina_Tasa_ISS__c = conf.Londrina_Tasa_ISS__c;
            if (conf.Londrina_Tasa_PIS__c != null) confTasas.Londrina_Tasa_PIS__c = conf.Londrina_Tasa_PIS__c;
            if (conf.Passo_Fundo_Tasa_COFINS__c != null) confTasas.Passo_Fundo_Tasa_COFINS__c = conf.Passo_Fundo_Tasa_COFINS__c;
            if (conf.Passo_Fundo_Tasa_ISS__c != null) confTasas.Passo_Fundo_Tasa_ISS__c = conf.Passo_Fundo_Tasa_ISS__c;                    
            if (conf.Passo_Fundo_Tasa_PIS__c != null) confTasas.Passo_Fundo_Tasa_PIS__c = conf.Passo_Fundo_Tasa_PIS__c;
            //should we instantiate those numbers in the database?
        }
        if(theOpp.Origen__r.Name != null){
            if(theOpp.Origen__r.Name.contains('Londrina') || theOpp.Origen__r.Name.contains('Cambe')) sumaTasas = confTasas.Londrina_Tasa_COFINS__c + confTasas.Londrina_Tasa_ISS__c + confTasas.Londrina_Tasa_PIS__c;
            if(theOpp.Origen__r.Name.contains('Passo Fundo')) sumaTasas = confTasas.Passo_Fundo_Tasa_COFINS__c + confTasas.Passo_Fundo_Tasa_ISS__c + confTasas.Passo_Fundo_Tasa_PIS__c;
        }
        System.debug('Result'+propRol.get(theOpp.OwnerId));
        if(propRol.get(theOpp.OwnerId).Profile.Name == 'Administrativo_licencias') sumaTasas = 3.65;
        Map<String,Object> retValue = new Map<String, Object>();
        retValue.put('taxes', confTasas);
        retValue.put('sum',sumaTasas);
        return retValue;
    }

    @AuraEnabled
    public static String getFields(String recordId) {
        Opportunity o = DAOOpportunity.getInstance().get(recordId);
        if (o.RecordType.Name == 'Anexo I') return JSON.serialize(SObjectType.OpportunityLineItem.FieldSets.AnexoI.getFields());
        if (o.RecordType.Name == 'Anexo II') return JSON.serialize(SObjectType.OpportunityLineItem.FieldSets.AnexoII.getFields());
        if (o.RecordType.Name == 'Anexo III') return JSON.serialize(SObjectType.OpportunityLineItem.FieldSets.Anexo_III.getFields());  
        if (o.RecordType.Name == 'Anexo IV') return JSON.serialize(SObjectType.OpportunityLineItem.FieldSets.Anexo_IV.getFields());    
        if (o.RecordType.Name == 'Anexo V') return JSON.serialize(SObjectType.OpportunityLineItem.FieldSets.Anexo_V.getFields());             
        if (o.RecordType.Name == 'Pendiente') return JSON.serialize(SObjectType.OpportunityLineItem.FieldSets.Pendiente.getFields());    
        if (o.RecordType.Name == 'NC - Pendiente' || o.RecordType.Name == 'NC - Autorizada') return JSON.serialize(SObjectType.OpportunityLineItem.FieldSets.Nota_de_Credito.getFields()); 
        if (o.RecordType.Name == 'Previsao') return JSON.serialize(SObjectType.OpportunityLineItem.FieldSets.Previsao.getFields());
        if (o.RecordType.Name == 'Exportacion') return JSON.serialize(SObjectType.OpportunityLineItem.FieldSets.Exportacion.getFields());
        if (o.RecordType.Name == 'Reembalaje') return JSON.serialize(SObjectType.OpportunityLineItem.FieldSets.Reembalaje.getFields());
            
        return JSON.serialize(New List<Schema.FieldSetMember>());                     
    }

    @AuraEnabled
    public static Boolean validarOfertaSAP(String recordId){ 
        List<OpportunityLineItem> items = DAOOpportunityLineItem.getInstance().getByOpportunityId(recordId);
        //It seems that the original items on this function where completely ignored.
        List <OpportunityLineItem> ListaItemsParaActualizarEstado = New List<OpportunityLineItem>();
        Map<Id,OpportunityLineItem> oplisSAP = New Map<Id, OpportunityLineItem>();
        Set<Id> ofItems = New Set<Id>(); //Also we have duplicity on this ofItems, simply because the map already contains a keyset for this same field Id_Item_de_Oportunidad_Relacionado__c
        for(OpportunityLineItem i: items) ofItems.add(i.Id_Item_de_Oportunidad_Relacionado__c);
         
        for(OpportunityLineItem opli : items){
            oplisSAP.put(opli.Id_Item_de_Oportunidad_Relacionado__c, opli);
        }
        
        List<OpportunityLineItem> finalItems = DAOOpportunityLineItem.getInstance().get(oplisSAP.keySet());
        for(OpportunityLineItem opli : finalItems){
            if((opli.Quant_Confirmada__c + oplisSAP.get(opli.Id).Quantity) < opli.Quant_Pendiente__c){
                opli.Quant_Confirmada__c = opli.Quant_Confirmada__c + oplisSAP.get(opli.Id).Quantity;
            }
            else{
                //retorno[0] = 'A quantidade confirmada não pode ser maior que a Quantidade Pendiente na Oferta.';
                throw new GenericException(System.Label.ValidaQuantidadePendente);
            }
        }
        update finalItems;
        return true;
    }

    @AuraEnabled
    public static Boolean RemoveFromShoppingCart(String recordId, List<OpportunityLineItem> items){   
        delete items;
        return true;
    }

    @AuraEnabled
    public static Boolean saveShoppingCart(String recordId, List<OpportunityLineItem> items){
        System.debug(items);
        system.debug(items.size());  
        Opportunity theOpp = DAOOpportunity.getInstance().get(recordId);
        Boolean result = true;
        if(theOpp.RecordType.Name == 'Anexo I'){
            result = validateA1(TheOpp, items); 
        }
        if(theOpp.RecordType.Name == 'Anexo II'){
            result = validateA2(TheOpp, items); 
        }
        if(theOpp.RecordType.Name == 'Anexo III'){
            result = validateA3(TheOpp, items); 
        }
        if(theOpp.RecordType.Name == 'Anexo IV' || theOpp.RecordType.Name == 'Anexo_IV'){
            result = validateA4(theOpp, items);
        }
        if(theOpp.RecordType.Name == 'Anexo V' || theOpp.RecordType.Name == 'Anexo_V'){
            result = validateA5(theOpp, items);
        }
        if(theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas'){
            result = validateRebaixamento(theOpp, items);
        }
        if(theOpp.RecordType.Name == 'Descarte'){
            result = validateDescarte(theOpp, items);
        }
        if(theOpp.RecordType.Name == 'Reembalaje'){
            result = validateReembalaje(theOpp, items);
        }
        System.debug(items);
        if(result) upsert items;
        return true;
    }

    @AuraEnabled
    public static OpportunityLineItem addToShoppingCart(String recordId, PricebookEntry d, Decimal sumaTasas){
        Opportunity theOpp = DAOOpportunity.getInstance().get(recordId);
        List<OpportunityLineItem> items = DAOOpportunityLineItem.getInstance().getByOpportunityId(recordId);
        // Cuando el usuario presiona "Seleccionar" en un producto  
        //shoppingCart.add(new opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, ZZPOSSF__c = String.valueOf(contador), Variedad__c = d.Product2.Variedade__c, Volume__c = 0.0, Expec_Prod_Bruta__c = 0.0, Tasas__c = sumaTasas));
        System.debug(d);
        OpportunityLineItem item = New opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, ZZPOSSF__c = String.valueOf(items.size()), Variedad__c = d.Product2.Variedade__c, Volume__c = 0.0, Expec_Prod_Bruta__c = 0.0, Tasas__c = sumaTasas);
        if (theOpp.Local_de_Entrega__c != null)
            item.Local_de_Entrega__c = theOpp.Local_de_Entrega__c;
        if (theOpp.RecordType.Name == 'Anexo I'){
            item.Categoria_a_Rebaixar__c = d.Product2.Categ__c;
        }

        if (theOpp.RecordType.Name == 'VB - Pendiente'){
            item.Tipo_de_Necesidad__c = 'Multiplicação';
            item.Tratamiento_de_Semilla__c = 'T00 - Sem';
        }
        return item;
    }

    @AuraEnabled
    public static Boolean saveOpportunity(String recordId){
        // Si algun producto ya selecciondo es eliminado, entonces debemos quitarlo
        Opportunity TheOpp = DAOOpportunity.getInstance().get(recordId);
        List<OpportunityLineItem> shoppingCart = DAOOpportunityLineItem.getInstance().getByOpportunityId(recordId);
        List<OpportunityLineItem> deleteVB = New List<OpportunityLineItem>();
        List<OpportunityLineItem> insertVB = New List<OpportunityLineItem>();
        OpportunityLineItem cloneVB = New OpportunityLineItem();
        Boolean ofPend = false;
        Savepoint sp;        
        sp = Database.setSavepoint();
        try{        
        // Los datos ya cargados deben ser actualizados
            if (theOpp.RecordType.Name == 'CVB - Pendiente')
                if (!validarOfertaSAP(recordId)) return false;
            for (OpportunityLineItem i : shoppingCart){
                if (i.Quantity == null) i.Quantity = 0.01;
                        
                
                 if (theOpp.RecordType.Name == 'Previsao'){
                     i.Es_Previsao__c = true;
                     if(i.PricebookEntry.Product2.Semilla_Tratada__c == true) i.Tratamiento_de_Semilla__c = 'T05 - Cruiser+Maxim+Amulet';
                     
                 }
                 if(theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'PB-Comercial' || theOpp.RecordType.Name == 'PB-Desarrollo' || theOpp.RecordType.Name.contains('Anexo') || theOpp.RecordType.Name == 'Stock Multiplicadores' || theOpp.RecordType.Name == 'Objetivo Ventas Royalties'){
                    i.Tipo_Registro__c = theOpp.RecordType.Name;
                 }
                 if (((theOpp.RecordType.Name == 'PB-Produccion' && theOpp.Tipo_de_Operacion__c == '7-Descarte') || ((theOpp.RecordType.Name == 'PB-Comercial' || theOpp.RecordType.Name == 'PB-Desarrollo') && theOpp.Tipo_de_Operacion__c == '4-Cancelamento')) && i.Quantidade__c > 0){
                    throw new GenericException(System.Label.ValorNegativo);
                 }
                 if(theOpp.RecordType.Name == 'VB - Pasada SAP' && ofPend == false){
                    if(i.Motivo_de_Rechazo__c != '' && i.Motivo_de_Rechazo__c != null) ofPend = true;
                 }            
            }  
               
            if(shoppingCart.size()>0)
                upsert(shoppingCart);
            if(deleteVB != null && deleteVB.size()>0)
                delete deleteVB;
            if(theOpp.RecordType.Name == 'VB - Pasada SAP' && theOpp.PE_bajar_SAP__c == false && ofPend == true){
                theOpp.PE_Bajar_SAP__c = true;
                update theOpp;
            }
            
            
        }
        catch(Exception e){
            Database.rollback(sp);
            throw new GenericException(e.getMessage() + ' - ' + e.getLineNumber());
        }
        // Luego de grabar los cambios retornamos al usuario a la opp
        return true;
    }

    @AuraEnabled
    public static Boolean validarRebajaAnexoI(String recordId, List<OpportunityLineItem> items){ 
        //Se utiliza para validar la rebaja de Ha. y de Bolsas
        Opportunity theOpp = DAOOpportunity.getInstance().get(recordId);
        Boolean retorno = true;
        Double sumArea = 0;
        Double sumBolsas = 0;
        Map <Id, String> categorias = New Map <Id, String>();
        Map <String, Double> cantidades = New Map <String, Double>();
        Map <String, Double> cantXVarInf = New Map <String, Double>();
        Set <String> prodsDupli = New Set <String>();
        
        for (Categoria__c c : DAOCategoria.getInstance().getAll())
            categorias.put(c.Id, c.Name);
                        
        for (OpportunityLineItem i : items){
                
            if((categorias.get(i.Categoria__c).length() == 1 && categorias.get(i.Categoria_a_Rebaixar__c).length() != 1) || (categorias.get(i.Categoria_a_Rebaixar__c).length() == 1 && categorias.get(i.Categoria__c).length() != 1)){
                throw new GenericException('Error Categoria. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - '  + categorias.get(i.Categoria__c));           
            }
            if(categorias.get(i.Categoria__c).length() == 1){
                if (categorias.get(i.Categoria__c).compareTo(categorias.get(i.Categoria_a_Rebaixar__c)) >= 0){
                    throw new GenericException('Error Categoria. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - '  + categorias.get(i.Categoria__c));
                }
            }else{
                if (categorias.get(i.Categoria__c).compareTo(categorias.get(i.Categoria_a_Rebaixar__c)) <= 0){
                    throw new GenericException('Error Categoria. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - '  + categorias.get(i.Categoria__c));
                }
            }
            
            if(theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas' || Test.isRunningTest()){
                if(cantXVarInf.ContainsKey(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c))){
                    sumBolsas = 0;
                    sumBolsas = cantXVarInf.get(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) + i.Sem_Rebajada__c;
                    cantXVarInf.remove(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c));
                    cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), sumBolsas);
                }else{
                    cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), i.Sem_Rebajada__c);
                }
            }else{
                if(cantXVarInf.ContainsKey(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c))){
                    sumArea = 0;
                    sumArea = cantXVarInf.get(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) + i.Area__c;
                    cantXVarInf.remove(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c));
                    cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), sumArea);
                }else{
                    cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), i.Area__c);
                }
            }
        }
        //for(AggregateResult pr : [Select Id, Categoria_a_Rebaixar__c, PricebookEntry.Product2Id, Sum(Area__c) Area__c, Sum(Sem_Rebajada__c) Sem_Rebajada__c From OpportunityLineItem Where Opportunity.Anexo_Relacionado__c = : theOpp.Anexo_Relacionado__c AND Opportunity.RecordType.Name = :theOpp.RecordType.Name AND OpportunityId != :theOpp.Id Group By Id, Categoria_a_Rebaixar__c, PricebookEntry.Product2Id limit 500]){            
        for(AggregateResult pr : DAOOpportunityLineItem.getInstance().getByFiltrosForAnexoI(theOpp.Anexo_Relacionado__c
                                                                                                , theOpp.RecordType.Name
                                                                                                , theOpp.Id)){    
            if(theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas'){
                if(cantXVarInf.ContainsKey((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'))){
                    sumBolsas = 0;
                    sumBolsas = cantXVarInf.get((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c')) + (Double)pr.get('Sem_Rebajada__c');
                    cantXVarInf.remove((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'));
                    cantXVarInf.put((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'), sumBolsas);
                }
            }else{
                if(cantXVarInf.ContainsKey((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'))){
                    sumArea = 0;
                    sumArea = cantXVarInf.get((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c')) + (Double)pr.get('Area__c');
                    cantXVarInf.remove((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'));
                    cantXVarInf.put((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'), sumArea);
                }
            }
        }
        
                
        Map<String, String> prods_anexo_rel = New Map <String, String>(); 
        for(AggregateResult p : [Select Categoria__c, PricebookEntry.Product2Id, Sum(Area__c) Area__c, Sum(Semente_bruta__c) Semente_bruta__c From OpportunityLineItem Where OpportunityId = : theOpp.Anexo_Relacionado__c Group By Categoria__c, PricebookEntry.Product2Id]){            
            //prods_anexo_rel.put(String.valueOf(p.get('Product2Id')) + String.valueOf(p.get('Categoria__c')),String.valueOf(p.get('Product2Id')) + String.valueOf(p.get('Categoria__c')));
            //cantidades.put(String.valueOf(p.get('Product2Id')) + String.valueOf(p.get('Categoria__c')), Double.valueOf(p.get('Area__c')));
            prods_anexo_rel.put((String)p.get('Product2Id') + (String)p.get('Categoria__c'),(String)p.get('Product2Id') + (String)p.get('Categoria__c'));
            if(theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas'){
                cantidades.put((String)p.get('Product2Id') + (String)p.get('Categoria__c'), (Double)p.get('Semente_bruta__c'));
            }else{
                cantidades.put((String)p.get('Product2Id') + (String)p.get('Categoria__c'), (Double)p.get('Area__c'));
            }
        }
        
        if (prods_anexo_rel.size() > 0 && cantXVarInf.size() > 0){
            for (OpportunityLineItem i : items){
                if (prods_anexo_rel.get(String.valueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) == null){
                    throw new GenericException('No existe el producto en el anexo relacionado a la rebaja. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - ' + categorias.get(i.Categoria__c));
                }
                if (cantXVarInf.get(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) > cantidades.get(String.valueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c))){
                    throw new GenericException('Cantidad excedida. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - ' + categorias.get(i.Categoria_a_Rebaixar__c));
                }
                                       
            }
        }         
        return retorno;
    }

    @AuraEnabled
    public static List<PricebookEntry> updateAvailableList(String recordId, String searchString) {
        if(searchString == null) searchString = '%';
        System.debug('updateAvailableList recordId: '+recordId);
        System.debug('updateAvailableList searchString: '+searchString);
        Opportunity theOpp = DAOOpportunity.getInstance().get(recordId);
        System.debug('theOpp: '+theOpp);
        List<OpportunityLineItem> shoppingCart = DAOOpportunityLineItem.getInstance().getByOpportunityId(recordId); 
        for(OpportunityLineItem item : shoppingCart){
            System.debug('item: '+item);
        }
        Set<Id> prodsARel;
        List<Id> oppsARel;

        String pricebook2Id = theOpp.Pricebook2Id;
        System.debug('pricebook2Id: '+pricebook2Id);
        
        // Construimos un query dinamico sobre los productos de la lista de precios
        String qString = 'select Id, Name, Pricebook2Id, IsActive, Product2.Name, Product2.Especie__c, Product2.Codigo_material_SAP__c, Product2.IsActive, Product2.Description, UnitPrice, Product2.Variedade__r.Name, Product2.Categ__r.Name, Product2.Variedade__c, Product2.Categ__c, Product2.Semilla_Tratada__c, Product2.Variedade__r.Nombre_de_Registro__c, Product2.UNIDADE__c';
        qString += ' from PricebookEntry where IsActive=true ';
        if(pricebook2Id != null){
            qString +=  'and Pricebook2Id = \'' + pricebook2Id + '\'';
        }else{
            qString +=  'and Pricebook2Id = null';
        }
        
        // buscamos productos cuya descripcion o nombre coindidan con el texto ingresado
        if(searchString!=null){
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Codigo_material_SAP__c like \'%' + searchString +  '%\' or Product2.Variedade__r.Name like \'%' + searchString + '%\' or Product2.Variedade__r.Nombre_de_Registro__c like \'%' + searchString + '%\')';
        }
        
        if (theOpp.RecordType.Name.contains('Anexo') || theOpp.RecordType.Name == 'Aquisição Sementes Terceiros'){
            //qString+= ' and Product2.Categ__r.Name= \'BASICA\' and Product2.Family= \'Royalty x Basica\'';   
        }
        
        if (theOpp.RecordType.Name == 'Anexo I' || theOpp.RecordType.Name == 'Anexo V'){
            List<Id> prodsContrato = New List<Id>();
            System.debug(theOpp.Safra__c);
            System.debug(theOpp.AccountId);
            System.debug(theOpp.Marca__c);
            //[Select Cultivar__c From Item_del_Contrato__c Where Contrato_de_Multiplicacion__r.Multiplicador__c = : theOpp.AccountId And Contrato_de_Multiplicacion__r.Safra__c = :theOpp.Safra__c And Contrato_de_Multiplicacion__r.Sociedad__c = : theOpp.Marca__c And Cultivar__c != null And (Contrato_de_Multiplicacion__r.Chegou_na_Brasmax__c = true Or Contrato_de_Multiplicacion__r.Estado__c = 'Chegou')])
            for (Item_del_Contrato__c itmContrato : 
                    DAOItemDelContrato.getInstance(DTOUtils.SharingMode.Without).getByMarcaBySafraByMultiplicador(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId))
                prodsContrato.add(itmContrato.Cultivar__c);            
            qString+= ' and Product2Id In :prodsContrato';                
        }
        
        if (theOpp.RecordType.Name == 'NC - Pendiente'){
            List<Id> prodsPRel = New List<Id>();

            for (OpportunityLineItem itemsPRel : DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(theOpp.Pedido_Relacionado__c)) prodsPRel.add(itemsPRel.PricebookEntry.Product2Id);
            
            if (prodsPRel.size() > 0)  qString+= ' and Product2Id In :prodsPRel';
                
        }
               
        if (theOpp.RecordType.Name == 'Anexo I Rebaixamento Ha'){
            prodsARel = New Set<Id>();            

            for (OpportunityLineItem itemsARel : DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(theOpp.Anexo_Relacionado__c)) prodsARel.add(itemsARel.PricebookEntry.Product2Id);
            
            if (prodsARel.size() > 0) qString+= ' and Product2Id In :prodsARel';

                                    
        }        

        if (theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas'){
            prodsARel = New Set<Id>();
            oppsARel = New List<Id>();
                       /*[SELECT Id, AccountId, RecordType.Name, Safra__c, Marca__c FROM Opportunity WHERE 
                       AccountId = : theOpp.AccountId 
                       AND (RecordType.Name = 'Anexo I' OR RecordType.Name = 'Anexo I Rebaixamento Ha') 
                       AND Safra__c = : theOpp.Safra__c 
                       AND Marca__c = :theOpp.Marca__c]*/
            List<String> recs = new List<String>{'Anexo I', 'Anexo I Rebaixamento Ha'};
            for(Opportunity oppsARelQ : DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).getByFilter(theOpp.Marca__c,theOpp.Safra__c,theOpp.AccountId,recs,'%')) 
                oppsARel.add(oppsARelQ.Id);
            /**[Select Id, PricebookEntry.Product2Id From OpportunityLineItem Where OpportunityId IN : oppsARel] */
            for (OpportunityLineItem itemsARel : DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(oppsARel)) 
                prodsARel.add(itemsARel.PricebookEntry.Product2Id);
            
            if (prodsARel.size() > 0){
               qString+= ' and Product2Id In :prodsARel';
            }else{
               qString+= ' and Product2Id = null';
            }
                                    
        }
         
        if (theOpp.RecordType.Name == 'Anexo II' || theOpp.RecordType.Name == 'Anexo III' || theOpp.RecordType.Name == 'Anexo IV' || theOpp.RecordType.Name == 'Descarte' || theOpp.RecordType.Name == 'Reembalaje'){        
            prodsARel = New Set<Id>();
            oppsARel = New List<Id>();
            /** [SELECT Id, AccountId, RecordType.Name, Safra__c FROM Opportunity WHERE AccountId = : theOpp.AccountId AND RecordType.Name = 'Anexo I' AND Safra__c = : theOpp.Safra__c]*/          
            
            List<String> recs = new List<String>{'Anexo I'};
            for(Opportunity oppsARelQ 
                :DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).getByFilter(theOpp.Marca__c,theOpp.Safra__c,theOpp.AccountId,recs,'%'))               
                    oppsARel.add(oppsARelQ.Id);                            
            
            for (OpportunityLineItem itemsARel : DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(oppsARel))
                prodsARel.add(itemsARel.PricebookEntry.Product2Id);                           
            
            if (prodsARel.size() > 0){
               qString+= ' and Product2Id In :prodsARel';
            }else{
               qString+= ' and Product2Id = null';
            }
                                    
        }                                           
               
        if (theOpp.RecordType.Name == 'Stock Multiplicadores'){               
            prodsARel = New Set<Id>();
            oppsARel = New List<Id>();
            //[SELECT Id, AccountId, RecordType.Name, Safra__c  FROM Opportunity WHERE AccountId = : theOpp.AccountId AND RecordType.Name = 'Anexo I' AND Safra__c = :theOpp.Safra__c AND StageName = 'Aprobada']
            List<String> recs = new List<String>{'Anexo I'};
            for(Opportunity oppsARelQ 
                :DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).getByFilter(theOpp.Marca__c,theOpp.Safra__c,theOpp.AccountId,recs,'Aprobada'))
                    oppsARel.add(oppsARelQ.Id);
            for (OpportunityLineItem itemsARel : [Select Id, PricebookEntry.Product2Id, PricebookEntry.Product2.Variedade__c From OpportunityLineItem Where OpportunityId IN : oppsARel])
               prodsARel.add(itemsARel.PricebookEntry.Product2.Variedade__c);                           
            
            if (prodsARel.size() > 0){
               qString+= ' and Product2.Variedade__c In :prodsARel';
            }else{
               qString+= ' and Product2Id = null';
            }
            qString+= ' and Product2.Semilla_Tratada__c = false';                      
        }
        
        if (theOpp.RecordType.Name == 'VB - Pendiente' || theOpp.RecordType.Name == 'VB - Rechazada' || theOpp.RecordType.Name == 'VB - Pasada SAP'){               
            prodsARel = New Set<Id>();
            
            for (OpportunityLineItem itemsARel : [Select Id, PricebookEntry.Product2Id, PricebookEntry.Product2.Variedade__c From OpportunityLineItem Where OpportunityId = :theOpp.Oportunidad_Relacionada__c])
               prodsARel.add(itemsARel.PricebookEntry.Product2.Variedade__c);                           
            
            if (prodsARel.size() > 0){
               qString+= ' and Product2.Variedade__c In :prodsARel';
            }else{
               qString+= ' and Product2Id = null';
            }
        }
                            
        
        if (theOpp.RecordType.Name == 'Previsao' || theOpp.RecordType.Name == 'Disponibilidade da Basica' || theOpp.RecordType.Name == 'Stock Multiplicadores' || theOpp.RecordType.Name == 'VB - Pendiente' || theOpp.RecordType.Name == 'VB - Rechazada' || theOpp.RecordType.Name == 'VB - Pasada SAP' || theOpp.RecordType.Name == 'Exportacion' || theOpp.RecordType.Name == 'Reembalaje' || theOpp.RecordType.Name == 'Objetivo Ventas Semilla'){ // || theOpp.RecordType.Name == 'Stock Multiplicadores'){
            //qString+= ' and Product2.Categ__r.Name= \'BASICA\' and Product2.Family= \'Semilla\'';   
        }
        
        if (theOpp.RecordType.Name == 'Objetivo Ventas Semilla')
            qString+= ' and Product2.Semilla_Tratada__c = false';
            
        if (theOpp.RecordType.Name == 'Objetivo Ventas Royalties')
            qString+= ' and Product2.Family = \'Royalty x Basica\'';
                        
        Set<Id> selectedEntries = new Set<Id>();        

        if(theOpp.RecordType.Name != 'Anexo V' && theOpp.RecordType.Name != 'PB-Produccion' && theOpp.RecordType.Name != 'PB-Comercial' && theOpp.RecordType.Name != 'PB-Desarrollo' && theOpp.RecordType.Name != 'VB - Pendiente' && theOpp.RecordType.Name != 'Anexo I' && theOpp.RecordType.Name != 'Anexo II' && theOpp.RecordType.Name != 'Anexo I Rebaixamento Ha' && theOpp.RecordType.Name != 'VB - Rechazada' && theOpp.RecordType.Name != 'Anexo II Rebaixamento Sacas' && theOpp.RecordType.Name != 'Anexo III' && theOpp.RecordType.Name != 'Anexo IV' && theOpp.RecordType.Name != 'Exportacion' && theOpp.RecordType.Name != 'Reembalaje' && theOpp.RecordType.Name != 'Objetivo Ventas Semilla' && theOpp.RecordType.Name != 'Descarte'){
            if(selectedEntries.size()>0) qString+= ' and Product2Id not In :selectedEntries';
        }
        if(theOpp.RecordType.Name == 'PB-Comercial'  || theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'PB-Desarrollo' || theOpp.RecordType.Name == 'PB-Oferta'){
            qString+= ' and Product2.Family= \'Semilla\' and Product2.Semilla_Tratada__c = false';
            qString+= ' order by Product2.Categ__r.Name, Product2.Name';
        }else{
            qString+= ' order by Product2.Name';
        }
        
        system.debug('qString:' +qString);        
        return database.query(qString);
        
        
        
    }

    @AuraEnabled
    public static Map<String, Map<String, OpportunityLineItem>> getApprovedItems(String oppId){
        // Retorna um map de <Anexo> => <CodigoDoProduto> => <ProdutoDaOportunidade>        
        Opportunity theOpp = DAOOpportunity.getInstance().get(oppId);
        Map<String, Map<String, OpportunityLineItem>> resposta = new Map<String, Map<String, OpportunityLineItem>>();
        List<OpportunityLineItem> items = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without)
            .getAllApprovedForAttanchmentByMarcaBySafraByAccount(theOpp.AccountId, theOpp.Marca__c, theOpp.Safra__c);
        for(OpportunityLineItem oli : items){
            if(resposta.get(oli.Opportunity.RecordType.DeveloperName) == null)resposta.put(oli.Opportunity.RecordType.DeveloperName, new Map<String, OpportunityLineItem>());
            resposta.get(oli.Opportunity.RecordType.DeveloperName).put(oli.PricebookEntryId, oli);
        }
        return resposta;
    }

    public static Boolean validateA1(Opportunity theOpp, List<OpportunityLineItem> shoppingCart ){
        System.debug('Inicio validateA1 ERNESTO');
        String anexo_1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoI').getRecordTypeId();
        if(theOpp.RecordTypeId == anexo_1){
            String typeBasica = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Aquisicion_Sementes_Terceiros').getRecordTypeId();
    
            List<String> types = new List<String> {typeBasica};
            List<String> safras = new List<String>();
            List<String> marcas = new List<String>();
            List<String> contas = new List<String>();
    
            safras.add(theOpp.Safra__c);
            marcas.add(theOpp.Marca__c);
            contas.add(theOpp.AccountId);
            System.debug('validateA1 safras: '+safras);
            System.debug('validateA1 marcas: '+marcas);
            System.debug('validateA1 contas: '+contas);
            System.debug('theOpp.Safra__c '+theOpp.Safra__c);
            System.debug('theOpp.Marca__c '+theOpp.Marca__c);
            System.debug('theOpp.AccountId '+theOpp.AccountId);
                
            List<Opportunity> approvedBase = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without)
                        .getApprovedByAnexo2_VendaDeBasica_Sementes(contas,safras, marcas, types);
            System.debug('approvedBase '+approvedBase);
            for(Opportunity base : approvedBase){
                System.debug('Opportunity base '+base);
            }
            List<Id> oppIds = new List<Id>();
            for(Opportunity opp : approvedBase) oppIds.add(opp.Id);
            System.debug('oppIds: '+oppIds);
            System.debug(approvedBase.size());
            
            for(Id identificador : oppIds){
                System.debug('identificador '+identificador);
            }
    
            List<OpportunityLineItem> baseOlis = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(oppIds);
    
            System.debug('baseOlis.size(): '+baseOlis.size());
            for(OpportunityLineItem item : baseOlis){
                System.debug('baseOlis item '+item);
            }
            System.debug(JSON.serialize(baseOlis));
            //--------------------------------------------------------------------
            List<Item_del_Contrato__c> baseOlis_Contrato_TA = DAOItemDelContrato.getInstance(DTOUtils.SharingMode.Without).getByMarcaBySafraByMultiplicador(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId);
            System.debug('baseOlis_Contrato_TA.size(): '+baseOlis_Contrato_TA.size());
            for(Item_del_Contrato__c item : baseOlis_Contrato_TA){
                System.debug('baseOlis_Contrato_TA item '+item);
            }
            
            //--------------------------------------------------------------------


            for(OpportunityLineItem item : shoppingCart){
                System.debug('shoppingCart item '+item);
                Boolean canAdd = false;
                System.debug('shoppingCart item.Area__c '+item.Area__c);
                System.debug('shoppingCart item.Expec_Prod_Bruta__c '+item.Expec_Prod_Bruta__c);
                System.debug('shoppingCart item.Estado_de_Produccion__c '+item.Estado_de_Produccion__c);
                System.debug('shoppingCart item.Categoria_a_Rebaixar__c '+item.Categoria_a_Rebaixar__c);
                System.debug('shoppingCart item.Categoria__c '+item.Categoria__c);
                
                if(item.Categoria_a_Rebaixar__c == null
                    || item.Categoria__c == null
                    || item.Area__c == null
                    || item.Expec_Prod_Bruta__c == null
                    || item.Estado_de_Produccion__c == null){
                    throw new GenericException(System.label.ERROR_PREENCHER_DADOS);
                }
                for(OpportunityLineItem base : baseOlis){
                    System.debug('baseOlis base 2 for: '+base);
                    system.debug('base.Categoria__c: '+base.Categoria__c );
                    system.debug('item.Categoria_a_Rebaixar__c: '+item.Categoria_a_Rebaixar__c);
                    system.debug('base.PricebookEntry.Product2.Variedade__c: '+base.PricebookEntry.Product2.Variedade__c);
                    system.debug('item.PricebookEntry.Product2.Variedade__c: '+item.PricebookEntry.Product2.Variedade__c);
                    System.debug('base.Categoria__c == item.Categoria_a_Rebaixar__c: '+(base.Categoria__c == item.Categoria_a_Rebaixar__c));
                    System.debug('base.PricebookEntry.Product2.Variedade__c == item.PricebookEntry.Product2.Variedade__c: '+(base.PricebookEntry.Product2.Variedade__c == item.PricebookEntry.Product2.Variedade__c));
                    system.debug('base.Categoria__r.Name: '+base.Categoria__r.Name );
                    if(base.Categoria__r.Name != 'S2'){
                        System.debug('Entró al if != S2');
                        if(base.Categoria__c == item.Categoria_a_Rebaixar__c
                            && base.PricebookEntry.Product2.Variedade__c == item.PricebookEntry.Product2.Variedade__c){
                                System.debug('Entró al 2do if != S2');
                            canAdd = true;
                        }
                    }
                }

                for(Item_del_Contrato__c base_contrato : baseOlis_Contrato_TA){
                    System.debug('base_contrato.Cultivar__r.Categ__c: '+base_contrato.Cultivar__r.Categ__c );
                    System.debug('item.Categoria_a_Rebaixar__c: '+item.Categoria_a_Rebaixar__c);
                    System.debug('base_contrato.Cultivar__r.Variedade__c: '+base_contrato.Cultivar__r.Variedade__c);
                    System.debug('item.PricebookEntry.Product2.Variedade__c: '+item.PricebookEntry.Product2.Variedade__c);
                    System.debug('base_contrato.Cultivar__r.Categ__c == item.Categoria_a_Rebaixar__c: '+(base_contrato.Cultivar__r.Categ__c == item.Categoria_a_Rebaixar__c));
                    System.debug('base_contrato.Cultivar__r.Variedade__c == item.PricebookEntry.Product2.Variedade__c: '+(base_contrato.Cultivar__r.Variedade__c == item.PricebookEntry.Product2.Variedade__c));
                    if(base_contrato.Cultivar__r.Categ__c == item.Categoria_a_Rebaixar__c
                        && base_contrato.Cultivar__r.Variedade__c == item.PricebookEntry.Product2.Variedade__c){
                        canAdd = true;
                    }
                }
                if(!canAdd){
                    throw new GenericException(System.label.ERROR_NO_PRODUCT);
                }
            }
    
            return true;
        }else{
            String typeBasica = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Aquisicion_Sementes_Terceiros').getRecordTypeId();
    
            List<String> types = new List<String> {typeBasica};
            List<String> safras = new List<String>();
            List<String> marcas = new List<String>();
            List<String> contas = new List<String>();
    
            safras.add(theOpp.Safra__c);
            marcas.add(theOpp.Marca__c);
            contas.add(theOpp.AccountId);
            System.debug('validateA1 safras: '+safras);
            System.debug('validateA1 marcas: '+marcas);
            System.debug('validateA1 contas: '+contas);
            System.debug('theOpp.Safra__c '+theOpp.Safra__c);
            System.debug('theOpp.Marca__c '+theOpp.Marca__c);
            System.debug('theOpp.AccountId '+theOpp.AccountId);
                
            List<Opportunity> approvedBase = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without)
                        .getApprovedByAnexo2_VendaDeBasica_Sementes(contas,safras, marcas, types);
            System.debug('approvedBase '+approvedBase);
            for(Opportunity base : approvedBase){
                System.debug('Opportunity base '+base);
            }
            List<Id> oppIds = new List<Id>();
            for(Opportunity opp : approvedBase) oppIds.add(opp.Id);
            System.debug('oppIds: '+oppIds);
            System.debug(approvedBase.size());
            
            for(Id identificador : oppIds){
                System.debug('identificador '+identificador);
            }
    
            List<OpportunityLineItem> baseOlis = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(oppIds);
    
            System.debug('baseOlis.size(): '+baseOlis.size());
            for(OpportunityLineItem item : baseOlis){
                System.debug('baseOlis item '+item);
            }
            System.debug(JSON.serialize(baseOlis));
            for(OpportunityLineItem item : shoppingCart){
                System.debug('shoppingCart item '+item);
                Boolean canAdd = false;
                System.debug('shoppingCart item.Area__c '+item.Area__c);
                System.debug('shoppingCart item.Expec_Prod_Bruta__c '+item.Expec_Prod_Bruta__c);
                System.debug('shoppingCart item.Estado_de_Produccion__c '+item.Estado_de_Produccion__c);
                System.debug('shoppingCart item.Categoria_a_Rebaixar__c '+item.Categoria_a_Rebaixar__c);
                System.debug('shoppingCart item.Categoria__c '+item.Categoria__c);
                
                if(item.Categoria_a_Rebaixar__c == null
                    || item.Categoria__c == null
                    || item.Area__c == null
                    || item.Expec_Prod_Bruta__c == null
                    || item.Estado_de_Produccion__c == null){
                    throw new GenericException(System.label.ERROR_PREENCHER_DADOS);
                }
                for(OpportunityLineItem base : baseOlis){
                    System.debug('baseOlis base 2 for: '+base);
                    system.debug('base.Categoria__c: '+base.Categoria__c );
                    system.debug('base.Categoria_a_Rebaixar__c: '+item.Categoria_a_Rebaixar__c);
                    system.debug('base.PricebookEntry.Product2.Variedade__c: '+base.PricebookEntry.Product2.Variedade__c);
                    system.debug('item.PricebookEntry.Product2.Variedade__c: '+item.PricebookEntry.Product2.Variedade__c);
                    System.debug('base.Categoria__c == item.Categoria_a_Rebaixar__c: '+(base.Categoria__c == item.Categoria_a_Rebaixar__c));
                    System.debug('base.PricebookEntry.Product2.Variedade__c == item.PricebookEntry.Product2.Variedade__c: '+(base.PricebookEntry.Product2.Variedade__c == item.PricebookEntry.Product2.Variedade__c));
                    system.debug('base.Categoria__r.Name: '+base.Categoria__r.Name );
                    if(base.Categoria__r.Name != 'S2'){
                        System.debug('Entró al if != S2');
                        if(base.Categoria__c == item.Categoria_a_Rebaixar__c
                            && base.PricebookEntry.Product2.Variedade__c == item.PricebookEntry.Product2.Variedade__c){
                                System.debug('Entró al 2do if != S2');
                            canAdd = true;
                        }
                    }
                }
                if(!canAdd){
                    throw new GenericException(System.label.ERROR_NO_PRODUCT);
                }
            }
    
            return true;
        }

    }

    
    public static Boolean validateA2(Opportunity theOpp, List<OpportunityLineItem> shoppingCart ){
        List<String> typesa1 = new List<String>();
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> contas = new List<String>();
        List<String> season = new List<String>();

        typesa1.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoI').getRecordTypeId());
        

        System.debug(theOpp);
        safras.add(theOpp.Safra__c);
        marcas.add(theOpp.Marca__c);
        contas.add(theOpp.AccountId);
        season.add(theOpp.Epoca_de_plantio__c);
            
        
        List<Opportunity> approvedBase = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without)
                    .getApprovedByAccountAndBySafraAndByType(contas,safras, marcas,season, typesa1);
        System.debug(approvedBase.size());
        System.debug(approvedBase);
        List<Id> approvedIds = new List<Id>();
        for(Opportunity opp : approvedBase){
            approvedIds.add(opp.Id);
        }
        System.debug(approvedIds);
        List<OpportunityLineItem> approvedOLI = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without)
                    .getByOpportunityId(approvedIds);
        System.debug(approvedOLI.size());
        System.debug(approvedIds);
        Map<Id, List<OpportunityLineItem>> mapOlis = new Map<Id, List<OpportunityLineItem>>();
        
        for(OpportunityLineItem oli : approvedOLI){
            if(mapOlis.get(oli.OpportunityId) == null){
                mapOlis.put(oli.OpportunityId, new List<OpportunityLineItem>());
            }
            mapOlis.get(oli.OpportunityId).add(oli);
        }
        System.debug(mapOlis);

        List<OpportunityLineItem> items = new List<OpportunityLineItem>();
        Map<String, Map<String, Decimal>> mapA1 = new Map<String, Map<String, Decimal>>();
        for(Opportunity base : approvedBase){
            System.debug(base);
            if(base.AccountId == theOpp.AccountId
                && base.Marca__c == theOpp.Marca__c
                && base.Safra__c == theOpp.Safra__c
                && base.Epoca_de_Plantio__c == theOpp.Epoca_de_Plantio__c){
                
                List<OpportunityLineItem> baseOLI = mapOlis.get(base.Id);
                
                if(baseOLI != null){
                    for(OpportunityLineItem bi : baseOLI){
                        System.debug(bi);
                        
                        if(mapA1.get(bi.PricebookEntryId) == null){
                            mapA1.put(bi.PricebookEntryId, new Map<String, Decimal>());
                        }
                        if(mapA1.get(bi.PricebookEntryId).get(bi.Categoria__c) == null){
                            mapA1.get(bi.PricebookEntryId).put(bi.Categoria__c, 0);
                        }
                        Decimal bv = mapA1.get(bi.PricebookEntryId).get(bi.Categoria__c);
                        System.debug(bv);
                        bv += bi.Area__c; 
                        System.debug(bv);
                        mapA1.get(bi.PricebookEntryId).put(bi.Categoria__c, bv);
                        System.debug(mapA1);


                        
                    }
                }
            }
        }
        for(OpportunityLineItem oli : shoppingCart){
            if(oli.Area_Plantada__c == null
                || oli.Semente_bruta__c == null
                || oli.Descarte__c == null){
                System.debug(oli.Area_Plantada__c);
                System.debug(oli.Area__c);
                System.debug(oli.Semente_bruta__c);
                System.debug(oli.Descarte__c);
                System.debug(JSON.serialize(oli));
                throw new GenericException(System.label.ERROR_PREENCHER_DADOS);
            }
            if(mapA1.get(oli.PricebookEntryId) != null){
                if(mapA1.get(oli.PricebookEntryId).get(oli.Categoria__c) != null){
                    if(oli.Area_PLantada__c > mapA1.get(oli.PricebookEntryId).get(oli.Categoria__c)){
                        throw new GenericException(oli.PricebookEntry.Product2.Variedade__r.Name + System.Label.ExceptionExceeded + ' - ' + mapA1.get(oli.PricebookEntryId).get(oli.Categoria__c) + ' HA.');
                    }
                }
            }
        }
        System.debug(items);
        return true;
    }

    public static Boolean validateA3(Opportunity theOpp, List<OpportunityLineItem> shoppingCart ){
        for(OpportunityLineItem oli : shoppingCart){
            if(oli.Semente_bruta__c == null
                || oli.Semente_beneficiada__c == null
                || oli.Semente_aprovada__c == null
                || oli.Semente_uso_propio__c == null
                || oli.Semente_comercializada__c == null){

                throw new GenericException(System.label.ERROR_PREENCHER_DADOS);

            }
            List<Map<String, String>> categoriasBase  = getOptionCategoria();
            Map<String,String> categoriasMaps = new Map<String,String>();
            for(Map<String, String> base : categoriasBase){
                categoriasMaps.put(base.get('label'),base.get('value'));
            }
            if( oli.Semente_beneficiada__c > oli.Semente_bruta__c){
                throw new GenericException(oli.PricebookEntry.Product2.Variedade__r.Name + ' Beneficiada-' + System.Label.ExceptionExceeded);
            }
            if( oli.Semente_aprovada__c > oli.Semente_beneficiada__c){
                throw new GenericException(oli.PricebookEntry.Product2.Variedade__r.Name + ' Aprovada-' + System.Label.ExceptionExceeded);
            }
            oli.Sem_Comercializada_Uso_Proprio_Sacas__c = (oli.Semente_uso_propio__c != null ? oli.Semente_uso_propio__c : 0) 
                                                                + (oli.Semente_comercializada__c != null ? oli.Semente_comercializada__c : 0);
           
            if( oli.Sem_Comercializada_Uso_Proprio_Sacas__c > oli.Semente_aprovada__c){
                throw new GenericException(oli.PricebookEntry.Product2.Variedade__r.Name + ' Somatório de uso/comécio-' + System.Label.ExceptionExceeded);
            }
            if(oli.Semente_uso_propio__c > 0 && oli.Categoria__c == categoriasMaps.get('S2')){
                throw new GenericException(oli.PricebookEntry.Product2.Variedade__r.Name  + System.Label.ExceptionCannotUseS2);
            }
        }

        return true;
    } 


    public static Boolean validateA4(Opportunity theOpp, List<OpportunityLineItem> shoppingCart ){

        
       List<Categoria__c> categories = DAOCategoria.getInstance().getBasedOnNamesForOpportunity();

       Map<Id, String> catMap = new Map<Id, String>();
       for(Categoria__c cat : categories){
           catMap.put(cat.Id, cat.Name);
       }
        
        List<OpportunityLineItem> itemsA3 = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getAllForA3(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId);
        List<OpportunityLineItem> itemsDescarte = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getAllDescarte(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId);
        
        Map<String, Map<String, Decimal>> aprovadas = new Map<String, Map<String, Decimal>>();
        Map<String, Map<String, Decimal>> descartes = new Map<String, Map<String, Decimal>>();
        Map<String, Map<String, Decimal>> descartesBase = new Map<String, Map<String, Decimal>>();
        Map<String, Map<String, Decimal>> compare = new Map<String, Map<String, Decimal>>();
        
        for(OpportunityLineItem item : shoppingCart){
            if(item.Semente_uso_propio__c == null 
                || item.Semente_comercializada__c == null
                || item.Descarte__c == null){
                throw new GenericException(System.label.ERROR_PREENCHER_DADOS);
            }
            if(aprovadas.get(item.PricebookEntryId) == null) aprovadas.put(item.PricebookEntryId, new Map<String, Decimal>());
            if(aprovadas.get(item.PricebookEntryId).get(item.Categoria__c) == null ) aprovadas.get(item.PricebookEntryId).put(item.Categoria__c, 0);
            if(descartesBase.get(item.PricebookEntryId) == null) descartesBase.put(item.PricebookEntryId, new Map<String, Decimal>());
            if(descartesBase.get(item.PricebookEntryId).get(item.Categoria__c) == null ) descartesBase.get(item.PricebookEntryId).put(item.Categoria__c, 0);
            
            Decimal bv = aprovadas.get(item.PricebookEntryId).get(item.Categoria__c);
            bv += item.Semente_uso_propio__c;
            bv += item.Semente_comercializada__c; 
            //bv -= item.Descarte__c; 
            bv += item.Descarte__c;
           
            Decimal bd = descartesBase.get(item.PricebookEntryId).get(item.Categoria__c);
            //bd += (item.Descarte__c * 40); //En anexo IV el descarte debe ser multiplicado por bolsas de 40kg
            bd += item.Descarte__c;
           
            aprovadas.get(item.PricebookEntryId).put(item.Categoria__c, bv);
            descartesBase.get(item.PricebookEntryId).put(item.Categoria__c, bd);
            System.debug('------------> aprovadas in A4');
            System.debug('Pricebook: '+item.PricebookEntryId+' Categoria: '+item.categoria__c);
            System.debug('Value : '+bv);
        }
        for(OpportunityLineItem item : itemsDescarte){
            if(descartes.get(item.PricebookEntryId) == null) descartes.put(item.PricebookEntryId, new Map<String, Decimal>());
            if(descartes.get(item.PricebookEntryId).get(item.Categoria__c) == null ) descartes.get(item.PricebookEntryId).put(item.Categoria__c, 0);
            
            Decimal bd = descartes.get(item.PricebookEntryId).get(item.Categoria__c);
            //bd += item.Descarte__c;
            //El campo Descarte de los productos de opp Descarte no esta calculano bien, hacemos nosotros el calculo.
            switch on item.Unidade_descarte__c{
                when 'Quilograma'{
                    bd += item.Quantity * 1;
                }
                when 'Saca 40Kg'{
                    bd += item.Quantity * 40;
                }
                when 'Saca 25Kg'{
                    bd += item.Quantity * 25;
                }
                when 'Tonelada'{
                    bd += item.Quantity * 1000;
                }
            }           

            descartes.get(item.PricebookEntryId).put(item.Categoria__c, bd);
         
        }
        for(OpportunityLineItem item : itemsA3){
            if(compare.get(item.PricebookEntryId) == null) compare.put(item.PricebookEntryId, new Map<String, Decimal>());
            if(compare.get(item.PricebookEntryId).get(item.Categoria__c) == null ) compare.get(item.PricebookEntryId).put(item.Categoria__c, 0);
            if(aprovadas.get(item.PricebookEntryId) == null) aprovadas.put(item.PricebookEntryId, new Map<String, Decimal>());
            if(aprovadas.get(item.PricebookEntryId).get(item.Categoria__c) == null ) aprovadas.get(item.PricebookEntryId).put(item.Categoria__c, 0);
          
            Decimal bv = compare.get(item.PricebookEntryId).get(item.Categoria__c);
            bv += item.Semente_aprovada__c;
           
            decimal bn = aprovadas.get(item.PricebookEntryId).get(item.Categoria__c);
            bn += item.Semente_uso_propio__c + item.Semente_comercializada__c;
            
            compare.get(item.PricebookEntryId).put(item.Categoria__c, bv);
            aprovadas.get(item.PricebookEntryId).put(item.Categoria__c, bn);
            System.debug('------------> aprovadas in A3');
            System.debug('Pricebook: '+item.PricebookEntryId+' Categoria: '+item.categoria__c);
            System.debug('Value : '+bn);
        }
      
        for(OpportunityLineItem item : shoppingCart){
            System.debug(math.abs(aprovadas.get(item.PricebookEntryId).get(item.Categoria__c)) + '!=' +math.abs(compare.get(item.PricebookEntryId).get(item.Categoria__c)));
            if(math.abs(aprovadas.get(item.PricebookEntryId).get(item.Categoria__c)) != math.abs(compare.get(item.PricebookEntryId).get(item.Categoria__c))){
                throw new GenericException(item.PricebookEntry.Product2.Variedade__r.Name + ' - ' +  catMap.get(item.Categoria__c) + ' -'
                                            + System.Label.ERROR_VALUE_MISMATCH 
                                            + ' - Tem: ' +  aprovadas.get(item.PricebookEntryId).get(item.Categoria__c)
                                            + ' - Pode: ' + compare.get(item.PricebookEntryId).get(item.Categoria__c));
            }

            //Descartes contiene la suma de los descartes del mismo producto ya existentes.
            if(descartesBase.get(item.PricebookEntryId) != null && descartes.get(item.PricebookEntryId) == null){
                if(descartesBase.get(item.PricebookEntryId).get(item.Categoria__c) != 0){
                    throw new GenericException(item.PricebookEntry.Product2.Variedade__r.Name + ' - ' +  catMap.get(item.Categoria__c) + ' -' +System.label.ERROR_DESCARTE_INVALIDO);
                }
            }else if(descartesBase.get(item.PricebookEntryId) != null && descartes.get(item.PricebookEntryId) != null){
                System.debug('Existen valores en A4 y en opp descarte');
                System.debug('Value descarte A4 : '+Integer.valueOf(descartesBase.get(item.PricebookEntryId).get(item.Categoria__c)));
                System.debug('Value descarte en opp descarte : '+descartes.get(item.PricebookEntryId).get(item.Categoria__c));
                if(!(descartesBase.get(item.PricebookEntryId).get(item.Categoria__c) * 40 <= descartes.get(item.PricebookEntryId).get(item.Categoria__c))){
                    if(descartes.get(item.PricebookEntryId).get(item.Categoria__c) == null 
                        && Integer.valueOf(descartesBase.get(item.PricebookEntryId).get(item.Categoria__c)) != 0) 
                        throw new GenericException(item.PricebookEntry.Product2.Variedade__r.Name + ' - ' +  catMap.get(item.Categoria__c) + ' -' +System.label.ERROR_DESCARTE_INVALIDO);
                    else if(descartes.get(item.PricebookEntryId).get(item.Categoria__c) == null 
                        && Integer.valueOf(descartesBase.get(item.PricebookEntryId).get(item.Categoria__c)) == 0){
                            //continue;
                        }
                    else throw new GenericException(item.PricebookEntry.Product2.Variedade__r.Name + ' - ' +  catMap.get(item.Categoria__c) + ' -'
                                                + System.Label.ERROR_VALUE_MISMATCH 
                                                + ' - Tem descarte: ' +  descartesBase.get(item.PricebookEntryId).get(item.Categoria__c)
                                                + ' - Descartou: ' + descartes.get(item.PricebookEntryId).get(item.Categoria__c)/40);
                }
            }
        }
        return true;
    }

    public static Boolean validateA5(Opportunity theOpp, List<OpportunityLineItem> shoppingCart ){
        System.debug('validateA5');
        System.debug(shoppingCart);
        List<Categoria__c> categories = DAOCategoria.getInstance().getBasedOnNamesForOpportunity();

       Map<Id, String> catMap = new Map<Id, String>();
       for(Categoria__c cat : categories){
           catMap.put(cat.Id, cat.Name);
       }
        
        List<OpportunityLineItem> itemsA3 = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getAllForA3(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId);
        List<OpportunityLineItem> itemsA4 = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getAllForA4(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId);
        
        Map<String, Map<String, Decimal>> aprovadas = new Map<String, Map<String, Decimal>>();
        Map<String, Map<String, Decimal>> compare = new Map<String, Map<String, Decimal>>();
        
        for(OpportunityLineItem item : shoppingCart){
            if(item.Semente_comercializada__c == null
                || item.Estado_de_Comercializacion__c == null){
                throw new GenericException(System.label.ERROR_PREENCHER_DADOS);
            }
            if(compare.get(item.PricebookEntryId) == null) compare.put(item.PricebookEntryId, new Map<String, Decimal>());
            if(compare.get(item.PricebookEntryId).get(item.Categoria__c) == null ) compare.get(item.PricebookEntryId).put(item.Categoria__c, 0);
            Decimal bv = compare.get(item.PricebookEntryId).get(item.Categoria__c);
            bv += item.Semente_comercializada__c;
            compare.get(item.PricebookEntryId).put(item.Categoria__c, bv);
        }
        for(OpportunityLineItem item : itemsA3){
            if(aprovadas.get(item.PricebookEntryId) == null) aprovadas.put(item.PricebookEntryId, new Map<String, Decimal>());
            if(aprovadas.get(item.PricebookEntryId).get(item.Categoria__c) == null ) aprovadas.get(item.PricebookEntryId).put(item.Categoria__c, 0);
            
            

            decimal bn = aprovadas.get(item.PricebookEntryId).get(item.Categoria__c);
            bn += item.Semente_uso_propio__c + item.Semente_comercializada__c;
           
            aprovadas.get(item.PricebookEntryId).put(item.Categoria__c, bn);
        }
        for(OpportunityLineItem item : itemsA4){
            if(aprovadas.get(item.PricebookEntryId) == null) aprovadas.put(item.PricebookEntryId, new Map<String, Decimal>());
            if(aprovadas.get(item.PricebookEntryId).get(item.Categoria__c) == null ) aprovadas.get(item.PricebookEntryId).put(item.Categoria__c, 0);
            
            

            decimal bn = aprovadas.get(item.PricebookEntryId).get(item.Categoria__c);
            bn += item.Semente_uso_propio__c + item.Semente_comercializada__c;
           
            aprovadas.get(item.PricebookEntryId).put(item.Categoria__c, bn);
        }


        for(OpportunityLineItem item : itemsA4){
            //Depois de sumarizado comparamos os nulos com zeros.
            System.debug(compare.get(item.PricebookEntryId).get(item.Categoria__c));
            System.debug(aprovadas.get(item.PricebookEntryId).get(item.Categoria__c));
            if(compare.get(item.PricebookEntryId).get(item.Categoria__c) == null
                && Integer.valueOf(aprovadas.get(item.PricebookEntryId).get(item.Categoria__c)) != 0){
                throw new GenericException(item.PricebookEntry.Product2.Variedade__r.Name + ' - ' +  catMap.get(item.Categoria__c) + ' -' + System.Label.ERROR_MUST_LAUNCH);
            }
        }

        for(OpportunityLineItem item : shoppingCart){
            if(aprovadas.get(item.PricebookEntryId).get(item.Categoria__c) != compare.get(item.PricebookEntryId).get(item.Categoria__c)){
                throw new GenericException(item.PricebookEntry.Product2.Variedade__r.Name + ' - ' +  catMap.get(item.Categoria__c) + ' -'
                                            + System.Label.ERROR_VALUE_MISMATCH 
                                            + ' - Tem: ' +  compare.get(item.PricebookEntryId).get(item.Categoria__c)
                                            + ' - Pode: ' + aprovadas.get(item.PricebookEntryId).get(item.Categoria__c));
            }
        }


        return true;
    }

    public static Boolean validateRebaixamento(Opportunity theOpp, List<OpportunityLineItem> shoppingCart ){
        System.debug(shoppingCart.size());
        List<OpportunityLineItem> olis = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getOlisRebaixamento(theOpp.Anexo_Relacionado__c);
        List<OpportunityLineItem> baseOlis = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(theOpp.Anexo_Relacionado__c);
        
        for(OpportunityLineItem base : baseOlis){
            Decimal totalAdded = 0;
            for(OpportunityLineItem addedOli : shoppingCart){
                if(addedOli.Categoria__c == base.Categoria__c
                    && addedOli.PricebookEntryId == base.PricebookEntryId){
                    if(addedOli.Categoria_a_Rebaixar__c == null 
                        || addedOli.Lote_Rebajado__c == null
                        || addedOli.Sem_Rebajada__c == null ){
                            throw new GenericException(System.label.ERROR_PREENCHER_DADOS);

                    }
                    totalAdded += addedOli.Sem_Rebajada__c;
                    System.debug(totalAdded);
                }
            }
            System.debug(totalAdded);
            for(OpportunityLineItem existingOli : olis){
                if(existingOli.Categoria__c == base.Categoria__c
                    && existingOli.PricebookEntryId == base.PricebookEntryId
                    && existingOli.Id != base.Id){
                    totalAdded += existingOli.Sem_Rebajada__c;
                    System.debug(totalAdded);
                }
            }
            System.debug(totalAdded);
            if(totalAdded > base.Semente_bruta__c){
                throw new GenericException(base.Name + '-' + System.Label.ExceptionExceeded);
            }
            
        }

        return true;
    }

    public static Boolean validateDescarte(Opportunity theOpp, List<OpportunityLineItem> shoppingCart ){
        System.debug(shoppingCart.size());
        
        List<Categoria__c> categories = DAOCategoria.getInstance().getBasedOnNamesForOpportunity();

        Map<Id, String> catMap = new Map<Id, String>();
        for(Categoria__c cat : categories){
            catMap.put(cat.Id, cat.Name);
        }
        
        List<OpportunityLineItem> itemsA3 = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without)
                                            .getAllForA3(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId);
        // List<OpportunityLineItem> itemsA2 = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without)
        //	.getAllForA2(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId);
        List<OpportunityLineItem> itemsDescarte = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without)
                                                    .getAllDescarte(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId);
        List<OpportunityLineItem> compare = null;
        if(itemsA3.size() > 0){
            compare = itemsA3;
        } else {
            return true;
        }
        for(OpportunityLineItem item : shoppingCart){
            System.debug(item);
            if(item.Categoria__c == null || item.Lote_Rebajado__c == null || item.Unidade_descarte__c == null || item.Quantity == null){
                throw new GenericException(System.Label.ERROR_PREENCHER_DADOS);
            }

            if(item.Quantity < 0){
                throw new GenericException(item.PricebookEntry.Product2.Variedade__r.Name + ' - ' +  catMap.get(item.Categoria__c) + ' - '
                + System.Label.ERROR_NO_NEGATIVE);
            }
            
            Decimal valueOfUnidadeDescarte = 0;
            if(item.Unidade_descarte__c.contains('25')) {
                valueOfUnidadeDescarte = 25;
            } else if(item.Unidade_descarte__c.contains('40')) {
                valueOfUnidadeDescarte = 40;
            } else if(item.Unidade_descarte__c == 'Quilograma') {
                valueOfUnidadeDescarte = 1;
            } else if(item.Unidade_descarte__c == 'Tonelada'){
                valueOfUnidadeDescarte = 1000;
            }
            
            System.debug(item.Unidade_descarte__c);
			System.debug(valueOfUnidadeDescarte);
            System.debug(item.Quantity);
            System.debug(item.Quantity * valueOfUnidadeDescarte);
            Decimal valorDescartado = item.Quantity * valueOfUnidadeDescarte;
            item.Descarte__c = valorDescartado == null ? 0 : valorDescartado;
            Decimal totalDescartado = valorDescartado;
            Decimal descarteAprovado = 0;
            
            for(OpportunityLineItem ids : itemsDescarte){
                if(ids.PricebookEntry.Product2.Variedade__c == item.PricebookEntry.Product2.Variedade__c
                    && ids.Categoria__c == item.Categoria__c){
                    totalDescartado += ids.Descarte__c == null ? 0 : ids.Descarte__c;
                    descarteAprovado += ids.Descarte__c == null ? 0 : ids.Descarte__c;
                }
            }
            Decimal totalAprovado = 0;
            for(OpportunityLineItem ta : compare){
                System.debug(ta.PricebookEntry.Product2.Variedade__c);
                System.debug(item.PricebookEntry.Product2.Variedade__c);
                System.debug(ta.PricebookEntry.Product2.Variedade__c == item.PricebookEntry.Product2.Variedade__c);
                System.debug(ta.Categoria__c);
                System.debug(item.Categoria__c);
                if(ta.PricebookEntry.Product2.Variedade__c == item.PricebookEntry.Product2.Variedade__c
                    && ta.Categoria__c == item.Categoria__c){
                        totalAprovado += ta.Semente_Aprovada__c == null ? 0 : ta.Semente_Aprovada__c * 40;
                }
            }
            System.debug(compare);
            System.debug(totalAprovado);
            System.debug(totalDescartado);
            Decimal saldo = totalAprovado - totalDescartado;
            Decimal pode = totalAprovado - descarteAprovado;
            if(totalDescartado > totalAprovado){
                saldo = Math.abs(saldo);
                throw new GenericException(item.PricebookEntry.Product2.Variedade__r.Name + ' - ' +  catMap.get(item.Categoria__c)
                	+ System.Label.ExceptionExceeded + ' - Pode descartar:' + String.valueOf(pode.setScale(2)).replace('.',',') + ' Kg - Descartou a mais:' + String.valueOf(saldo.setScale(2)).replace('.',',') + ' Kg');
            }
        }


        return true;
    }


    public static Boolean validateReembalaje(Opportunity theOpp, List<OpportunityLineItem> shoppingCart ){
        List<OpportunityLineItem> itemsA3 = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without)
                                            .getAllForA3(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId);
        List<OpportunityLineItem> itemsA2 = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without)
                                            .getAllForA2(theOpp.Marca__c, theOpp.Safra__c, theOpp.AccountId);
        List<OpportunityLineItem> compare = null;
        if(itemsA3.size() > 0){
            compare = itemsA3;
        } else if(itemsA2.size() > 0){
            compare = itemsA2;
        }else{
            return true;
        }
        for(OpportunityLineItem item : shoppingCart){
            System.debug(item);
            if(item.Categoria__c == null || item.Qtde_Scs_40kg__c == null || item.Lote_Rebajado__c == null){
                throw new GenericException(System.Label.ERROR_PREENCHER_DADOS);
            }

           Boolean pode = false;
            for(OpportunityLineItem base : compare){
                if(item.PricebookEntryId == base.PricebookEntryId 
                    && item.Categoria__c == base.Categoria__c){
                    pode = true;
                    break;
                }
            }

            if(!pode){
            throw new GenericException(System.Label.ERROR_NO_PRODUCT);

            }

        }
        return true;
        
    }



    public class GenericException extends Exception{

    }


}
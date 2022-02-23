/*
        @Author: Sergio Migueis - K2
        @Description: Handler for object Opportunity

        @History:
        03/01/2020 - Creation
        03/01/2020 - ShareOpportunityFromCommunity: If a opportunity is created on community, 
                        we create a share for it right after its creation, so the creator can see and use it.
        25/02/2020 - validateAII: check uniquiness of the A2 based on marca, safra, conta, temporada
        08/06/2020 - fillRegion: Atualizar região com a região da conta.

 */
public without sharing class OpportunityHandler {
    
    public static void ShareOpportunityFromCommunity(List<Opportunity> triggerNew, Map<Id,Opportunity> oldMap){
        Map<Id, List<Opportunity>> creatorsOpportunityMap = new Map<Id, List<Opportunity>>();
        List<OpportunityShare> shareToBeSaved = new List<OpportunityShare>();
        List<Id> oppIds = new List<Id>();

        for(Opportunity opp : triggerNew){
            oppIds.add(opp.Id);
        }
        List<Opportunity> oppsToMap = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).get(oppIds);
        for(Opportunity opp : oppsToMap){
            if(creatorsOpportunityMap.get(opp.CreatedById) == null)creatorsOpportunityMap.put(opp.CreatedById, new List<Opportunity>());
            creatorsOpportunityMap.get(opp.CreatedById).add(opp);
        }
        System.debug('ResultsShare-'+creatorsOpportunityMap);
        System.debug(creatorsOpportunityMap);
        List<User> creators = DAOUser.getInstance().get(creatorsOpportunityMap.keySet());
        System.debug('ResultsShare-'+creators);
        List<Opportunity> oppsToSaveRelatedContact = new List<Opportunity>();
        for(User creator : creators){
            System.debug('ResultsShare-'+creator);
            System.debug('ResultsShare-'+creator.ContactId);
            if(creator.ContactId != null){ //IF THE CREATOR IS A CONTACT USER
                System.debug('ResultsShare-'+creatorsOpportunityMap.get(creator.Id));
                for(Opportunity opp : creatorsOpportunityMap.get(creator.Id)){
                    System.debug('ResultsShare-'+creatorsOpportunityMap.get(creator.Id));
                    if(opp.CreatedById == opp.OwnerId) continue;
                    OpportunityShare share = new OpportunityShare();
                    share.RowCause = 'Manual';
                    share.OpportunityId = opp.Id;
                    share.UserOrGroupId = creator.Id;
                    share.OpportunityAccessLevel = 'Edit';
                    shareToBeSaved.add(share);
                    opp.Contacto_Portal__c = creator.ContactId;
                    oppsToSaveRelatedContact.add(opp);
                    System.debug(share);
                }
            }
        }
        System.debug('ResultsShare-'+shareToBeSaved);

        if(shareToBeSaved.size() > 0){ 
            List<Database.SaveResult> result =  Database.insert(shareToBeSaved,false);
            System.debug('ResultsShare-'+result);
        }

        if(oppsToSaveRelatedContact.size() > 0){
            upsert oppsToSaveRelatedContact;
        }
    }

    /**
     * It's not a good practice to return to the trigger
     * But this was refactored to be used within the after trigger
     */
    public static List<Opportunity> ChangeOwnerInAfter(List<Opportunity> triggerNew){
        List<Opportunity> oppsToBeSaved = new List<Opportunity>();
        List<Id> accIds = new List<Id>();
        Map<String, User> mapUsers = new Map<String,User>();
        for(Opportunity tr : triggerNew){
            Opportunity opp = tr.clone(true,false,false,true);
            oppsToBeSaved.add(opp);
            accIds.add(opp.AccountId);
            System.debug(opp.Name);
        }
        //BRAXUtils.actualizarPropietarioOpp(oppsToBeSaved);
        //Não estava funcionando no after
        Map<Id,Account> mapAccounts = new Map<Id,Account>(DAOAccount.getInstance(DTOUtils.SharingMode.Without).get(accIds));
        List<User> users = DAOUser.getInstance(DTOUtils.SharingMode.Without).getAll();
        for(User u : users){
            mapUsers.put(u.Codigo_SAP__c, u);
        }
        for(Opportunity opp : oppsToBeSaved){
            Account acc = mapAccounts.get(opp.AccountId);
            String ownerId = null;

            switch on opp.Marca__c {
                when 'BRMX' {
                    opp.ownerId = mapUsers.get(acc.Responsavel__c.split('-')[0].trim()).Id;
                }
                when 'DSEM' {
                    opp.ownerId = mapUsers.get(acc.Reponsavel_DSEM__c.split('-')[0].trim()).Id;
                }
                when 'NEOG' {
                    opp.ownerId = mapUsers.get(acc.Responsavel_NEOGEN__c.split('-')[0].trim()).Id;
                }
                when 'DAGMA' {
                    opp.ownerId = mapUsers.get(acc.Responsavel_DAGMA__c.split('-')[0].trim()).Id;
                }
                when 'LICENÇAS' {
                    opp.ownerId = mapUsers.get(acc.Responsavel_LICENCAS__c.split('-')[0].trim()).Id;
                }
            }
        }
        if(oppsToBeSaved.size() > 0) update oppsToBeSaved;
        return oppsToBeSaved;
    }

    public static void setPricebook2Id(List<Opportunity> triggerNew){
        MarcaPadrao__c marca = MarcaPadrao__c.getInstance();

        for(Opportunity tr : triggerNew){
            System.debug(tr.Pricebook2Id);
            if(tr.Pricebook2Id == null) tr.Pricebook2Id = marca.PricebookId__c;
            System.debug(tr.Pricebook2Id);
        }
        if(triggerNew.size() > 0) update triggerNew;
    }

    //Não deixa criar o Anexo Atual na comunidade sem ter o anexo anterior aprovado.
    public static void ValidatePreviousAttachment(List<Opportunity> triggerNew){
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<Id> accountIds = new List<Id>();
        Map<String, Map<String,List<Opportunity>>> result = new Map<String, Map<String, List<Opportunity>>>();
        for(Opportunity opp : triggerNew){
            if(result.get(opp.AccountId) == null) result.put(opp.AccountId, new Map<String,List<Opportunity>>());
            safras.add(opp.Safra__c);
            marcas.add(opp.Marca__c);
            accountIds.add(opp.AccountId);
        }
        System.debug(safras);
        System.debug(accountIds);
        List<Opportunity> approvedSafra = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).getApprovedByAccountAndBySafra(accountIds,safras,marcas); 
        List<Opportunity> allOfThem = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).getByAccountAndBySafra(accountIds,safras,marcas);
        List<Opportunity> a3s = new List<Opportunity>();
        for(Opportunity opp : allOfThem){
            if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoIII').getRecordTypeId()
                || opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId()){
                a3s.add(opp);
            }
        }
        
        for(Opportunity opp : approvedSafra){
            if(result.get(opp.AccountId).get(opp.RecordType.DeveloperName.replace('_','')) == null) result.get(opp.AccountId).put(opp.RecordType.DeveloperName.replace('_',''), new List<Opportunity>());
            result.get(opp.AccountId).get(opp.RecordType.DeveloperName.replace('_','')).add(opp);
            System.debug(opp);
            System.debug(result.get(opp.AccountId));
        }

        for(Opportunity opp : triggerNew){
            if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoII').getRecordTypeId()){
                Boolean canAdd = false;
                System.debug(result.get(opp.AccountId));
                if(result.get(opp.AccountId).get('AnexoI') == null){
                    opp.addError(System.Label.NeedAnexoI);
                }else if(result.get(opp.AccountId).get('AnexoI').size() == 0){
                    opp.addError(System.Label.NeedAnexoI);                    
                } else {
                    for(Opportunity opa : result.get(opp.AccountId).get('AnexoI')){
                        if(opa.Epoca_de_PLantio__c == opp.Epoca_de_PLantio__c
                        && opa.Marca__c == opp.Marca__c){
                            canAdd = true;
                        }
                    }
                }
                if(!canAdd){
                    opp.addError(System.Label.NeedAnexoI);
                }
            }
            if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId()){
                Boolean canAdd = false;
                if(result.get(opp.AccountId).get('AnexoII') == null){
                    opp.addError(System.Label.NeedAnexoII);
                }else if(result.get(opp.AccountId).get('AnexoII').size() == 0){
                    opp.addError(System.Label.NeedAnexoII);                    
                } else {
                    for(Opportunity opa : result.get(opp.AccountId).get('AnexoII')){
                        if(opa.Marca__c == opp.Marca__c){
                            canAdd = true;
                        }
                    }
                }
                if(!canAdd){
                    opp.addError(System.Label.NeedAnexoII);
                }
            }
            if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_IV').getRecordTypeId()
                || opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoIV').getRecordTypeId()){
                Boolean canAdd = false;
                if(result.get(opp.AccountId).get('AnexoIII') == null){ //REMOVED UNDERSCORE
                    opp.addError(System.Label.NeedAnexoIII);
                }else if(result.get(opp.AccountId).get('AnexoIII').size() == 0){
                    opp.addError(System.Label.NeedAnexoIII);                    
                }else {
                    for(Opportunity opa : result.get(opp.AccountId).get('AnexoIII')){
                        if(opa.Marca__c == opp.Marca__c){
                            canAdd = true;
                        }
                    }
                }
                if(!canAdd){
                    opp.addError(System.Label.NeedAnexoIII);
                }
            }
            if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_II_Rebaixamento_Sacas').getRecordTypeId()){
                if(a3s.size() > 0){
                    opp.addError(System.Label.ERROR_CANT_AFTER_III);
                }
                if(result.get(opp.AccountId).get('AnexoIII') != null && result.get(opp.AccountId).get('AnexoIII').size() > 0){ //REMOVED UNDERSCORE
                    opp.addError(System.Label.ERROR_CANT_AFTER_III);
                }
            }
            if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoV').getRecordTypeId()){
                Boolean canAdd = false;
                if(result.get(opp.AccountId).get('AnexoIV') == null){ //REMOVED UNDERSCORE
                    opp.addError(System.Label.NeedAnexoIV);
                }else if( result.get(opp.AccountId).get('AnexoIV').size() == 0){
                    opp.addError(System.Label.NeedAnexoIV);                    
                }else {
                    for(Opportunity opa : result.get(opp.AccountId).get('AnexoIV')){
                        if(opa.Marca__c == opp.Marca__c){
                            canAdd = true;
                        }
                    }
                }
                if(!canAdd){
                    opp.addError(System.Label.NeedAnexoIV);
                }
            }
        }
    }

    public static void validateAII(List<Opportunity> triggerNew){
        List<Opportunity> a2s = new List<Opportunity>();
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> contas = new List<String>();
        List<String> season = new List<String>();
        Id recordTypeIdA2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoII').getRecordTypeId();
        for(Opportunity opp : triggerNew){
            if(opp.RecordTypeId == recordTypeIdA2){
                a2s.add(opp);
                safras.add(opp.Safra__c);
                marcas.add(opp.Marca__c);
                contas.add(opp.AccountId);
                season.add(opp.Epoca_de_Plantio__c);
            }
        }
        if(safras.size() == 0) return;
        List<Opportunity> approvedBase = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without)
                                            .getByAccountAndBySafra(contas,safras, marcas, season);
        System.debug(approvedBase);
        for(Opportunity opp: triggerNew){
            System.debug('opp: ' + opp.Marca__c + '-' + opp.Safra__c + '-' + opp.Epoca_de_Plantio__c + '-' + opp.RecordTypeId);
            for(Opportunity base : approvedBase){
                System.debug('base: ' + base.Marca__c + '-' + base.Safra__c + '-' + base.Epoca_de_Plantio__c + '-' + opp.RecordTypeId);
                if(base.AccountId == opp.AccountId
                    && base.Marca__c == opp.Marca__c
                    && base.Safra__c == opp.Safra__c
                    && base.Epoca_de_Plantio__c == opp.Epoca_de_Plantio__c
                    && base.RecordTypeId == recordTypeIdA2
                    && opp.RecordTypeId == recordTypeIdA2
                    && opp.Id != base.Id){
                    opp.addError(Label.ERROR_DUPLICATE_A2);
                    break;
                }
            }
        }
    }

    public static void fillSeasonForA2(List<Opportunity> triggerNew){
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> contas = new List<String>();
        Id recordTypeIdA2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoII').getRecordTypeId();
        for(Opportunity opp : triggerNew){
            System.debug(opp);
            if(opp.RecordTypeId == recordTypeIdA2){
                safras.add(opp.Safra__c);
                marcas.add(opp.Marca__c);
                contas.add(opp.AccountId);
            }
        }
        if(safras.size() == 0) return;
        List<Opportunity> approvedBase = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without)
                                            .getByAccountAndBySafra(contas,safras, marcas);
        System.debug(approvedBase);
        for(Opportunity opp : triggerNew){            
            System.debug('opp: ' + opp.Marca__c + '-' + opp.Safra__c + '-' + opp.Epoca_de_Plantio__c + '-' + opp.RecordTypeId);
            if(opp.Epoca_de_Plantio__c == null
                && opp.RecordTypeID == recordTypeIdA2){
                opp.Epoca_de_Plantio__c = BusinessRules__c.getInstance().Epoca_de_Plantio_Padrao__c;
                for(Opportunity base : approvedBase){
                    System.debug('base: ' + base.Marca__c + '-' + base.Safra__c + '-' + base.Epoca_de_Plantio__c + '-' + opp.RecordTypeId);
                    if(base.AccountId == opp.AccountId
                    && base.Marca__c == opp.Marca__c
                    && base.Safra__c == opp.Safra__c
                    && base.RecordTypeId == recordTypeIdA2
                    && opp.RecordTypeId == recordTypeIdA2
                    && opp.Id != base.Id){
                        opp.Epoca_de_Plantio__c = BusinessRules__c.getInstance().Epoca_de_Plantio_Final__c;
                        system.debug(opp.Epoca_de_Plantio__c);
                        break;
                    }
                }
            }
        }
    }

    public static void fillStock(List<Opportunity> triggerNew){
        List<Opportunity> opps = new List<Opportunity>();
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> tipos = new List<String>();
        
        List<Id> accountIds = new List<Id>();
        Id recordTypeStock = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Stock_Multiplicadores').getRecordTypeId();
        tipos.add(recordTypeStock);
        for(Opportunity opp : triggerNew){
            System.debug(opp);
            if(opp.RecordTypeId == recordTypeStock){
                opps.add(opp);
                accountIds.add(opp.AccountId);
                safras.add(opp.Safra__c);
                marcas.add(opp.Marca__c);
            }
        }
        if(opps.size() == 0) return;
        List<Opportunity> existingOpps = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).getApprovedByAccountAndBySafraAndByTypeNotApproved(accountIds,safras, marcas, tipos);
        System.debug(existingOpps);
        System.debug(accountIds);
        System.debug(safras);
        System.debug(marcas);
        System.debug(tipos);
        Map<Integer, String> monthMap = new Map<Integer, String>();
        monthMap.put(1, 'Janeiro');
        monthMap.put(2, 'Fevereiro');
        monthMap.put(3, 'Março');
        monthMap.put(4, 'Abril');
        monthMap.put(5, 'Maio');
        monthMap.put(6, 'Junho');
        monthMap.put(7, 'Julho');
        monthMap.put(8, 'Agosto');
        monthMap.put(9, 'Setembro');
        monthMap.put(10, 'Outubro');
        monthMap.put(11, 'Novembro');
        monthMap.put(12, 'Dezembro');
        List<Account> acc = DAOAccount.getInstance(DTOUtils.SharingMode.Without).get(accountIds);
        Map<Id, Account> accAccount = new Map<Id, Account>(acc);
        Configuracion_BMX__c config = DAOConfiguracionBMX.getInstance(DTOUtils.SharingMode.Without).getFirst();
        for(Opportunity opp : opps){            
            if(System.today().Day() >= config.PM_Estoque_Dia_Desde__c){
                opp.Mes__c = monthMap.get(System.now().month());
            } else{
                opp.Mes__c = monthMap.get(System.now().addMonths(-1).month());
            }
            opp.Control_Stock_Multiplicadores__c = String.valueOf(opp.AccountId) + String.valueOf(opp.Safra__c) + String.valueOf(opp.Marca__c) + String.valueOf(opp.Mes__c);
            //if(config.Mes_Stock__c != null) opp.Mes__c = config.Mes_Stock__c;
            //opp.Region__c = accAccount.get(opp.AccountId).Region__c; Ganhou handler próprio.
            opp.Responsable__c = accAccount.get(opp.AccountId).Responsavel_NEOGEN__c;
            opp.StageName = 'Edición';
            opp.Name = 'Estoque ' + opp.Mes__c;
            for(Opportunity eopp : existingOpps){
                System.debug(eopp.AccountId == opp.AccountId);
                System.debug(eopp.Safra__c == opp.Safra__c);
                System.debug(eopp.Marca__c == opp.Marca__c);
                System.debug(eopp.RecordTypeId == opp.RecordTypeId);
                if(eopp.AccountId == opp.AccountId
                    &&  eopp.Safra__c == opp.Safra__c
                    &&  eopp.Marca__c == opp.Marca__c
                    &&  eopp.RecordTypeId == opp.RecordTypeId){
                        if( eopp.Mes__c == opp.Mes__c) opp.Duplicate_Stock__c = true;
                        break;
                    }
            }
        }
    }

    public static void fillRelatadedAtt(List<Opportunity> triggerNew){
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> contas = new List<String>();
        List<Opportunity> opps = new List<Opportunity>();
        Id recordTypeReb = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_II_Rebaixamento_Sacas').getRecordTypeId();
        for(Opportunity opp : triggerNew){
            System.debug(opp);
            if(opp.RecordTypeId == recordTypeReb){
                opps.add(opp);
                safras.add(opp.Safra__c);
                marcas.add(opp.Marca__c);
                contas.add(opp.AccountId);
            }
        }
        System.debug(opps);
        if(opps.size() == 0) return;
        
        Id recordTypeIdA2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoII').getRecordTypeId(); 
        List<String> types = new List<String>{recordTypeIdA2};
        
        List<Opportunity> approvedBase = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without)
                    .getApprovedByAccountAndBySafraAndByType(contas,safras, marcas, types);
        for(Opportunity opp : opps){        
            System.debug(opp.AccountId + opp.Marca__c + opp.Safra__c);
            opp.StageName = 'Edición';    
            for(Opportunity base : approvedBase){
                System.debug(base.AccountId + base.Marca__c + base.Safra__c); 
                if(base.AccountId == opp.AccountId
                    && base.Marca__c == opp.Marca__c
                    && base.Safra__c == opp.Safra__c){
                    if(opp.Anexo_Relacionado__c == null){
                        opp.Epoca_De_Plantio__c = base.Epoca_De_Plantio__c;
                        opp.Anexo_Relacionado__c = base.Id;
                    }else if(base.Id == opp.Anexo_Relacionado__c){
                        opp.Epoca_De_Plantio__c = base.Epoca_De_Plantio__c;
                    }
                }
            }            
        }
    }

    

    public static void addOpportunityLineItems(List<Opportunity> triggerNew){
        List<Opportunity> anexo2 = new List<Opportunity>();
        List<Opportunity> anexo3 = new List<Opportunity>();
        List<Opportunity> anexo4 = new List<Opportunity>();
        List<Opportunity> anexo5 = new List<Opportunity>();
        List<Opportunity> anexoStock = new List<Opportunity>();
        
        Id recordTypeIdA2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoII').getRecordTypeId();        
        Id recordTypeIdA3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId();       
        Id recordTypeIdA4 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_IV').getRecordTypeId();       
        Id recordTypeIdA5 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoV').getRecordTypeId();
        Id recordTypeStock = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Stock_Multiplicadores').getRecordTypeId();
        for(Opportunity opp : triggerNew){
            if(opp.RecordTypeId == recordTypeIdA2) anexo2.add(opp);
            else if(opp.RecordTypeId == recordTypeIdA3) anexo3.add(opp);
            else if(opp.RecordTypeId == recordTypeIdA4) anexo4.add(opp);
            else if(opp.RecordTypeId == recordTypeIdA5) anexo5.add(opp);
            else if(opp.RecordTypeId == recordTypeStock) anexoStock.add(opp);
        }

        if(anexo2.size() > 0) addOaddOpportunityLineItemsA2(anexo2);
        if(anexo3.size() > 0) addOaddOpportunityLineItemsA3(anexo3);
        if(anexo4.size() > 0) addOaddOpportunityLineItemsA4(anexo4);
        //if(anexo5.size() > 0) addOaddOpportunityLineItemsA5(anexo5);
        if(anexoStock.size() > 0) addOaddOpportunityLineItemsStocks(anexoStock);
    }


    public static void validateStock(List<Opportunity> triggerNew){        
        BusinessRules__c rule = BusinessRules__c.getInstance();
        System.debug(triggerNew);
        List<Opportunity> opps = new List<Opportunity>();        
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> contas = new List<String>();
        Id stock = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Stock_Multiplicadores').getRecordTypeId();
        Id a1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoI').getRecordTypeId();
        Configuracion_BMX__c config = DAOConfiguracionBMX.getInstance(DTOUtils.SharingMode.Without).getFirst();
        for(Opportunity opp : triggerNew){
            if(opp.RecordTypeId == stock){
                opps.add(opp);
                safras.add(opp.Safra__c);
                marcas.add(opp.Marca__c);
                contas.add(opp.AccountId);
            }
        }
        if(opps.size() == 0) return;
        List<Opportunity> approvedSafra = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).getApprovedByAccountAndBySafra(contas,safras,marcas); 
        System.debug(approvedSafra);
        Map<String, List<Opportunity>> mapApproved = new Map<String, List<Opportunity>>();
        for(Opportunity opp : approvedSafra){
            String key = opp.AccountId + opp.Marca__c + opp.Safra__c;
            SYstem.debug(key);
            SYstem.debug(opp.RecordTypeId);
            SYstem.debug(a1);
            if(opp.RecordTypeId == a1){
                if(mapApproved.get(key) == null) mapApproved.put(key, new List<Opportunity>());
                mapApproved.get(key).add(opp);
            }
        }
        for(Opportunity opp : opps){
            String key = opp.AccountId + opp.Marca__c + opp.Safra__c;
            SYstem.debug(key);
            SYstem.debug(mapApproved.get(key));
            Boolean canAdd = false;
            if(mapApproved.get(key) != null && mapApproved.get(key).size() > 0){
                canAdd = true;
            }
            if(!canAdd){
                opp.addError(Label.NeedAnexoI);
            }

            if(rule.ValidateStockMonth__c){
                String months = rule.ValidateStockMonths__c;
                for(String month : months.split(',')){
                    Integer mint = Integer.valueOf(month);
                    if(System.today().month() == mint){
                        opp.addError(Label.ERROR_INVALID_MONTH);
                    }
                }
            }

            if(rule.ValidateStockDay__c){
                if(System.today().day() > config.PM_estoque_dia_Hasta__c && System.today().day() < config.PM_estoque_dia_Desde__c){
                    opp.addError(System.Label.ERROR_WRONG_DAY);
                }
            }
        }
    
    }

    
    public static void addOaddOpportunityLineItemsA2(List<Opportunity> triggerNew){
        List<String> typesa1 = new List<String>();
        typesa1.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoI').getRecordTypeId());
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> contas = new List<String>();
        List<String> season = new List<String>();

        for(Opportunity opp : triggerNew){
            System.debug(opp);
            safras.add(opp.Safra__c);
            marcas.add(opp.Marca__c);
            contas.add(opp.AccountId);
            season.add(opp.Epoca_de_plantio__c);
            
        }
        if(marcas.size() == 0) return;
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
        for(Opportunity opp : triggerNew){
            Map<String, Map<String, Decimal>> mapA1 = new Map<String, Map<String, Decimal>>();
            for(Opportunity base : approvedBase){
                System.debug(base);
                if(base.AccountId == opp.AccountId
                    && base.Marca__c == opp.Marca__c
                    && base.Safra__c == opp.Safra__c
                    && base.Epoca_de_Plantio__c == opp.Epoca_de_Plantio__c){
                    
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
            for(String key : mapA1.keySet()){
                for(String cat : mapA1.get(key).keySet()){
                    OpportunityLineItem newItem = new OpportunityLineItem();

                    newItem.Categoria__c = cat;
                    newItem.Area_Plantada__c = mapA1.get(key).get(cat);
                    newItem.OpportunityId = opp.Id;
                    newItem.PricebookEntryId = key;
                    newItem.Quantity = 1;
                    newItem.UnitPrice = 1;
                    System.debug(newItem);
                    
                    items.add(newItem);
                }
            }
        }
        System.debug(items);
        if(items.size() > 0) insert items;


    }
    public static void addOaddOpportunityLineItemsA3(List<Opportunity> triggerNew){
        BusinessRules__c rule = BusinessRules__c.getInstance();
        System.debug(triggerNew);
        List<Opportunity> opps = new List<Opportunity>();        
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> contas = new List<String>();
        Id a2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoII').getRecordTypeId();
        Id a3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId();
        Configuracion_BMX__c config = DAOConfiguracionBMX.getInstance(DTOUtils.SharingMode.Without).getFirst();
        for(Opportunity opp : triggerNew){
            if(opp.RecordTypeId == a3){
                opps.add(opp);
                safras.add(opp.Safra__c);
                marcas.add(opp.Marca__c);
                contas.add(opp.AccountId);
            }
        }
        List<Opportunity> opps2 = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without)
                                    .getApprovedByAccountAndBySafraAndByType(contas,safras, marcas, new List<String> {a2});
        List<String> opps2Id = new List<String>();
        for(Opportunity opp : opps2){
            opps2Id.add(opp.Id);
        }
        System.debug(opps2Id);
        List<OpportunityLineItem> olis = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getOlisRebaixamento(opps2Id);
        List<OpportunityLineItem> baseOlis = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(opps2Id);
        
       List<OpportunityLineItem> items = new List<OpportunityLineItem>();
       for(Opportunity opp : opps){
            Map<String, Map<String, Decimal>> mapValores = new Map<String, Map<String, Decimal>>();
            for(OpportunityLineItem oli : baseOlis){
                if(oli.Opportunity.Marca__c != opp.Marca__c 
                    || oli.Opportunity.Safra__c != opp.Safra__c
                    || oli.Opportunity.AccountId != opp.AccountId) continue;
                if(mapValores.get(oli.PricebookEntryId) == null )mapValores.put (oli.PricebookEntryId, new Map<String,Decimal>());
                if(mapValores.get(oli.PricebookEntryId).get(oli.Categoria__c) == null )mapValores.get(oli.PricebookEntryId).put(oli.Categoria__c,0);
                mapValores.get(oli.PricebookEntryId).put(oli.Categoria__c,mapValores.get(oli.PricebookEntryId).get(oli.Categoria__c) + oli.Semente_bruta__c);
            }

            for(OpportunityLineItem oli : olis){
                System.debug(oli);
                if(oli.Opportunity.Marca__c != opp.Marca__c 
                    || oli.Opportunity.Safra__c != opp.Safra__c
                    || oli.Opportunity.AccountId != opp.AccountId) continue;
                if(mapValores.get(oli.PricebookEntryId) == null )mapValores.put (oli.PricebookEntryId, new Map<String,Decimal>());
                if(mapValores.get(oli.PricebookEntryId).get(oli.Categoria__c) == null )mapValores.get(oli.PricebookEntryId).put(oli.Categoria__c,0);           
                if(mapValores.get(oli.PricebookEntryId).get(oli.Categoria_a_Rebaixar__c) == null )mapValores.get(oli.PricebookEntryId).put(oli.Categoria_a_Rebaixar__c,0);
                
                mapValores.get(oli.PricebookEntryId).put(oli.Categoria__c,mapValores.get(oli.PricebookEntryId).get(oli.Categoria__c) - oli.Sem_Rebajada__c);
                mapValores.get(oli.PricebookEntryId).put(oli.Categoria_a_Rebaixar__c,mapValores.get(oli.PricebookEntryId).get(oli.Categoria_a_Rebaixar__c) + oli.Sem_Rebajada__c);
            }
            for(String entry : mapValores.keySet()){
                for(String cat : mapValores.get(entry).keySet()){
                    if(mapValores.get(entry).get(cat) == 0) continue;
                    OpportunityLineItem item = new OpportunityLineItem();
                    item.Quantity = 1;
                    item.UnitPrice = 1;
                    item.PricebookEntryId = entry;
                    item.Categoria__c = cat;
                    item.Semente_bruta__c = mapValores.get(entry).get(cat);
                    item.OpportunityId = opp.Id;
                    items.add(item);
                }
            }
            
       }

       if(items.size() > 0) insert items;


    }
    public static void addOaddOpportunityLineItemsA4(List<Opportunity> triggerNew){BusinessRules__c rule = BusinessRules__c.getInstance();
        System.debug(triggerNew);
        List<Opportunity> opps = new List<Opportunity>();        
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> contas = new List<String>();
        Id a4 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_IV').getRecordTypeId();
        Id a3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId();
        Configuracion_BMX__c config = DAOConfiguracionBMX.getInstance(DTOUtils.SharingMode.Without).getFirst();
        for(Opportunity opp : triggerNew){
            if(opp.RecordTypeId == a4){
                opps.add(opp);
                safras.add(opp.Safra__c);
                marcas.add(opp.Marca__c);
                contas.add(opp.AccountId);
            }
        }
        List<Opportunity> opps3 = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without)
                                    .getApprovedByAccountAndBySafraAndByType(contas,safras, marcas, new List<String> {a3});
        List<String> opps3Id = new List<String>();
        for(Opportunity opp : opps3){
            opps3Id.add(opp.Id);
        }
        System.debug(opps3Id);
        List<OpportunityLineItem> baseOlis = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(opps3Id);
        
       List<OpportunityLineItem> items = new List<OpportunityLineItem>();
       for(Opportunity opp : opps){
            Map<String, Map<String, Decimal>> mapValores = new Map<String, Map<String, Decimal>>();
            for(OpportunityLineItem base : baseOlis){
                
                OpportunityLineItem item = new OpportunityLineItem();
                item.Quantity = 1;
                item.UnitPrice = 1;
                item.PricebookEntryId = base.PricebookEntryId;
                item.Categoria__c = base.Categoria__c;
                item.Semente_bruta__c = base.Semente_bruta__c;
                item.OpportunityId = opp.Id;
                items.add(item);
                
            }
            
       }

       if(items.size() > 0) insert items;
    }
    public static void addOaddOpportunityLineItemsA5(List<Opportunity> triggerNew){System.debug(triggerNew);
        List<Opportunity> opps = new List<Opportunity>();        
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> contas = new List<String>();
        Id a4 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_IV').getRecordTypeId();
        Id a5 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoV').getRecordTypeId();
        Configuracion_BMX__c config = DAOConfiguracionBMX.getInstance(DTOUtils.SharingMode.Without).getFirst();
        for(Opportunity opp : triggerNew){
            if(opp.RecordTypeId == a5){
                opps.add(opp);
                safras.add(opp.Safra__c);
                marcas.add(opp.Marca__c);
                contas.add(opp.AccountId);
            }
        }
        List<Opportunity> opps4 = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without)
                                    .getApprovedByAccountAndBySafraAndByType(contas,safras, marcas, new List<String> {a4});
        List<String> opps4Id = new List<String>();
        for(Opportunity opp : opps4){
            opps4Id.add(opp.Id);
        }
        System.debug(opps4Id);
        List<OpportunityLineItem> baseOlis = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without).getByOpportunityId(opps4Id);
        
       List<OpportunityLineItem> items = new List<OpportunityLineItem>();
       for(Opportunity opp : opps){
            Map<String, Map<String, Decimal>> mapValores = new Map<String, Map<String, Decimal>>();
            for(OpportunityLineItem base : baseOlis){
                
                OpportunityLineItem item = new OpportunityLineItem();
                item.Quantity = 1;
                item.UnitPrice = 1;
                item.PricebookEntryId = base.PricebookEntryId;
                item.Categoria__c = base.Categoria__c;
                item.Semente_bruta__c = base.Semente_bruta__c;
                item.OpportunityId = opp.Id;
                items.add(item);
                
            }
            
       }

       if(items.size() > 0) insert items;
    }
    public static void addOaddOpportunityLineItemsStocks(List<Opportunity> triggerNew){
        System.debug(triggerNew);
        List<String> typesa1 = new List<String>();
        typesa1.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoI').getRecordTypeId());
        List<String> typesa2 = new List<String>();
        typesa2.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Stock_Multiplicadores').getRecordTypeId());
        
        
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<String> contas = new List<String>();
        List<String> pricebooks = new List<String>();
        List<String> products = new List<String>();
        List<String> categories = new List<String>();
        MarcaPadrao__c marca = MarcaPadrao__c.getInstance();
        List<Opportunity> opps = new List<Opportunity>();

        for(Opportunity opp : triggerNew){
            System.debug(opp);
            safras.add(opp.Safra__c);
            marcas.add(opp.Marca__c);
            contas.add(opp.AccountId);
            Opportunity nopp = opp.clone(true,true,true,true);
            nopp.Pricebook2Id = marca.PricebookId__c;
            opps.add(nopp);
            pricebooks.add(nopp.Pricebook2Id);

        }
        List<Opportunity> approvedBase = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without)
                    .getApprovedByAccountAndBySafraAndByType(contas,safras, marcas, typesa1);
        System.debug(approvedBase);
        List<Opportunity> previousBase = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without)
                    .getApprovedByAccountAndBySafraAndByType(contas,safras, marcas, typesa2);
        System.debug(contas);
        System.debug(safras);
        System.debug(marcas);
        System.debug(typesa2);
        System.debug(previousBase);
        List<Id> approvedIds = new List<Id>();
        List<Id> previousIds = new List<Id>();
        for(Opportunity opp : approvedBase){
            approvedIds.add(opp.Id);
        }
        for(Opportunity opp : previousBase){
            previousIds.add(opp.Id);
        }
        List<OpportunityLineItem> approvedOLI = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without)
                    .getByOpportunityId(approvedIds);
        List<OpportunityLineItem> previousOLI = DAOOpportunityLineItem.getInstance(DTOUtils.SharingMode.Without)
                    .getByOpportunityId(previousIds);
        Map<Id, List<OpportunityLineItem>> mapOlis = new Map<Id, List<OpportunityLineItem>>();
        Map<Id, List<OpportunityLineItem>> mapOlisBase = new Map<Id, List<OpportunityLineItem>>();
        
        for(OpportunityLineItem oli : approvedOLI){
            if(mapOlis.get(oli.OpportunityId) == null){
                mapOlis.put(oli.OpportunityId, new List<OpportunityLineItem>());
            }
            mapOlis.get(oli.OpportunityId).add(oli);
            products.add(oli.PricebookEntry.Product2Id);
        }
        for(OpportunityLineItem oli : previousOLI){
            if(mapOlisBase.get(oli.OpportunityId) == null){
                mapOlisBase.put(oli.OpportunityId, new List<OpportunityLineItem>());
            }
            mapOlisBase.get(oli.OpportunityId).add(oli);
            products.add(oli.PricebookEntry.Product2Id);
        }
        System.debug(products);
        System.debug(pricebooks);
        List<PricebookEntry> entries = DAOPricebookEntry.getInstance(DTOUtils.SharingMode.Without)
                    .getForPricebooks(pricebooks, products);
        Map<String,Map<String,PricebookEntry>> mapProuctEntry = new Map<String,Map<String,PricebookEntry>>();
        for(PricebookEntry entry : entries){
            if(mapProuctEntry.get(entry.Pricebook2Id) == null)
                mapProuctEntry.put(entry.Pricebook2Id, new Map<String,PricebookEntry>());
            if(mapProuctEntry.get(entry.Pricebook2Id).get(entry.Product2Id) == null)
                mapProuctEntry.get(entry.Pricebook2Id).put(entry.Product2Id, entry);    
        }
        List<OpportunityLineItem> items = new List<OpportunityLineItem>();
        if(previousBase.size() > 0){
            for(Opportunity opp : opps){
                for(Opportunity base : previousBase){
                    if(base.AccountId == opp.AccountId
                        && base.Marca__c == opp.Marca__c
                        && base.Safra__c == opp.Safra__c){
                        List<OpportunityLineItem> baseOLI = mapOlisBase.get(base.Id);
                        if(baseOLI != null){
                            opp.Pricebook2Id = base.Pricebook2Id;
                            for(OpportunityLineItem bi : baseOLI){
                                OpportunityLineItem newItem = new OpportunityLineItem();
                                newItem.Categoria__c = bi.Categoria__c;
                                newItem.Semente_aprovada__c = bi.Semente_aprovada__c;
                                newItem.Semente_comercializada__c = bi.Semente_comercializada__c;
                                newItem.OpportunityId = opp.Id;
                                newItem.PricebookEntryId = bi.PricebookEntryId;
                                newItem.Quantity = 1;
                                newItem.UnitPrice = 1;
                                items.add(newItem);
                            }
                        }
                        break;
                    }
                }
            }
        }else{
            for(Opportunity opp : opps){
                for(Opportunity base : approvedBase){
                    if(base.AccountId == opp.AccountId
                        && base.Marca__c == opp.Marca__c
                        && base.Safra__c == opp.Safra__c){
                        List<OpportunityLineItem> baseOLI = mapOlis.get(base.Id);
                        if(baseOLI != null){
                            for(OpportunityLineItem bi : baseOLI){
                                OpportunityLineItem newItem = new OpportunityLineItem();
                                newItem.Categoria__c = bi.Categoria__c; 
                                newItem.OpportunityId = opp.Id;
                                newItem.PricebookEntryId = bi.PricebookEntryId;
                                newItem.Semente_aprovada__c = 0;
                                newItem.Semente_comercializada__c = 0; 
                                newItem.Quantity = 1;
                                newItem.UnitPrice = 1;
                                items.add(newItem);
                            }
                        }
                        break;
                    }
                }
            }
        }
        if(opps.size() > 0) upsert opps;
        if(items.size() > 0) insert items;
    }
    public static void fillRegion(List<Opportunity> triggerNew){
        Map<Id, List<Opportunity>> mapOpps = new Map<Id,List<Opportunity>>();
        for(Opportunity opp : triggerNew){
            if(mapOpps.get(opp.AccountId) == null) mapOpps.put(opp.AccountId, new List<Opportunity>());
            mapOpps.get(opp.AccountId).add(opp);
        }
        List<Account> accs = DAOAccount.getInstance(DTOUtils.SharingMode.Without).get(new List<Id>(mapOpps.keySet()));
        for(Account acc : accs){
            if(mapOpps.get(acc.Id) != null){
                for(Opportunity opp : mapOpps.get(acc.Id)){
                    opp.Region__c = acc.Region_Comercial__c;
                    opp.Regiao__c = acc.Region__c;
                }
            }
        }
    }
}
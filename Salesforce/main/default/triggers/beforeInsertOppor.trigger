trigger beforeInsertOppor on Opportunity (before insert) {   
    boolean vendaDeBasicaIsRunning = true;
    //Se reemplaza el uso de SOQL, para minimizar uso excesivo de SOQL
    //----------------------------------------------------------------
    // RecordType vendaDeBasicaRt = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'Venda_da_Basica_full'];
    Id vendaDeBasicaRt = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venda_da_Basica_full').getRecordTypeId();
    //----------------------------------------------------------------
    Id AnexoII_RT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoII').getRecordTypeId();
    
    List<Opportunity> anexos2 = new List<Opportunity>();

    for (Opportunity o : Trigger.new) {
        if (o.recordTypeId != vendaDeBasicaRt) vendaDeBasicaIsRunning = false;
        if(o.recordTypeId == AnexoII_RT){anexos2.add(o);}
    }
    
    if (!vendaDeBasicaIsRunning) {
        BRAXUtils.actualizarNroAutorizacionA1(Trigger.new);
        if(Network.getNetworkId() != null && anexos2.size() > 0){
            BRAXUtils.cargarEpocaPlantioAnexo2(anexos2);
        }
        if(Network.getNetworkId() == null)
            BRAXUtils.actualizarPropietarioOpp(Trigger.new); //ADDED "IF" TO AVOID trigger IN COMMUNITTY
        String[] resultado = New String[2];
        for(Opportunity o : Trigger.New){
            resultado = BRAXUtils.validarNuevaProduccionBasica(o);
            if(resultado[1] != 'OK')
                o.addError(resultado[0]);
            
            //resultado = BRAXUtils.validarNuevaPrevision(o);
            //if(resultado[1] != 'OK')
            //    o.addError(resultado[0]);
            
            resultado = BRAXUtils.validarNuevoAnexoI(o);
            if(resultado[1] != 'OK')
                o.addError(resultado[0]);
        }
        
        OpportunittyHelper.setOpportunityCooperante(Trigger.New);    
    }
    
    List<String> accAIIINeog = New List<String>();
    List<String> safraAIIINeog = New List<String>();
    for(Opportunity opp : Trigger.new) {
        if (opp.RecordTypeId == '01240000000M7y6' && opp.Marca__c == 'NEOG' && userInfo.getProfileId() == '00e0b000000y7BZAAY'){
            accAIIINeog.add(opp.AccountId);
            safraAIIINeog.add(opp.Safra__c);
        }    
    }
    if (accAIIINeog.size() > 0 && safraAIIINeog.size() > 0){
        Map<String, CRM_Multiplicador__c> mapPerfiles = New Map<String, CRM_Multiplicador__c>();
        for (CRM_Multiplicador__c crm : [Select Id, Cuenta__c, Safra__c, Region_Comercial__c From CRM_Multiplicador__c Where Cuenta__c In : accAIIINeog And Safra__c In : safraAIIINeog])
            mapPerfiles.put(crm.Cuenta__c + crm.Safra__c, crm);
        for(Opportunity opp : Trigger.new) {
            if (opp.RecordTypeId == '01240000000M7y6' && opp.Marca__c == 'NEOG' && userInfo.getProfileId() == '00e0b000000y7BZAAY'){
                if (mapPerfiles.get(opp.AccountId + opp.Safra__c) != null){
                    if (opp.CRM_Multiplicador__c == null)
                        opp.CRM_Multiplicador__c = mapPerfiles.get(opp.AccountId + opp.Safra__c).Id;
                    if (opp.Region__c == null)            
                        opp.Region__c = mapPerfiles.get(opp.AccountId + opp.Safra__c).Region_Comercial__c;
                }                                                            
            }        
        }    
    }
    
}
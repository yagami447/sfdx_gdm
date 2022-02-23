trigger OpportunityTriggerXappia on Opportunity (before update, after insert, after update, before insert){
    List<OpportunityLineItem> productList = new List<OpportunityLineItem>();
    for (Opportunity op : Trigger.New)
        if (op.RecordTypeId == '0120v000000op3S' || op.RecordTypeId == '0125a000000QkXG')
            return;

    Id vendaBasicaId = XappiaHelper.getRecordType('Opportunity', 'Venda_da_Basica_full').Id;
    // Jhonny Peroza
    Id pbComercialId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('PB_Comercial_Milho').getRecordTypeId(); 
    Id vbCompletoMilhoId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venda_da_Hibrido').getRecordTypeId(); 

    if (Trigger.isBefore && Trigger.isInsert){
        //OpportunityTriggerXappiaHelper.validarEstoque(Trigger.new);
        OpportunityTriggerXappiaHelper.syncRegionAccountWithOpp(Trigger.new);
        List<Opportunity> vendaBasicaList = new List<Opportunity>();
        List<Opportunity> opportunityList = new List<Opportunity>();
        for (Opportunity oppUnit : Trigger.new){

            if (oppUnit.RecordTypeId == vendaBasicaId || oppUnit.RecordTypeId == vbCompletoMilhoId){
                vendaBasicaList.add(oppUnit);
            }

            // Agregado por Jhonny Peroza
            if (oppUnit.RecordTypeId == pbComercialId) {
                opportunityList.add(oppUnit);  
            }

        }

        // Agregado por Jhonny Peroza
        if (opportunityList.size() > 0) {
            OpportunityHelper.verifyProducts(opportunityList);
            OpportunityHelper.verifyOpportunity(opportunityList);
        }

        if (vendaBasicaList.size() > 0){
            OpportunityTriggerXappiaHelper.setCampaignVendaBasica(vendaBasicaList);
        }
    }


    if (Trigger.isUpdate && Trigger.isBefore){
        Id recordTypeVendaDaBasicaFull = XappiaHelper.getRecordType('Opportunity', 'Venda_da_Basica_full').Id;

        Set<Id> opportunitiesToClone = new Set<Id>();
        for (Opportunity opportunityUpdate : Trigger.new){
            if (Trigger.OldMap.get(opportunityUpdate.Id).StageName != opportunityUpdate.StageName && opportunityUpdate.StageName == 'Edición' && opportunityUpdate.RecordTypeId == recordTypeVendaDaBasicaFull){
                opportunitiesToClone.add(opportunityUpdate.Id);

            }
        }
        if (!opportunitiesToClone.isEmpty()){
            OpportunityTriggerXappiaHelper.cloneQuote(Trigger.newMap, opportunitiesToClone);
        }

    } else if (Trigger.IsUpdate && Trigger.isAfter){
        List<Opportunity> vendaBasicaList = new List<Opportunity>();
        //OpportunityTriggerXappiaHelper.desactivateOldStock_ActivateNewStock(Trigger.new,Trigger.oldMap);
        for (Opportunity oppUnit : Trigger.new){
            if (oppUnit.RecordTypeId == vendaBasicaId)
                vendaBasicaList.add(oppUnit);
        }
        if (vendaBasicaList.size() > 0){
            OpportunityTriggerXappiaHelper.runSyncQuote(vendaBasicaList, Trigger.oldMap);
            OpportunityTriggerXappiaHelper.firstTime = false;
        }

    }


    if (Trigger.isInsert && Trigger.isAfter){
        // if(!Test.isRunningTest()) OpportunityTriggerXappiaHelper.SyncQuoteOpp(Trigger.newMap.keyset());
        OpportunityTriggerXappiaHelper.SyncQuoteOpp(Trigger.newMap.keyset()); //future
    }

    if (Trigger.isAfter){
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        List<Opportunity> opportunityList = new List<Opportunity>();
        Set<Id> oppId = new Set<Id>();
        for (Opportunity opp : Trigger.new){
            Opportunity oldOpp;
            if (Trigger.isUpdate){
                oldOpp = Trigger.oldMap.get(opp.Id);
            }
            if (Trigger.isInsert || opp.Taxa_de_primeiro_pagamento__c != oldOpp.Taxa_de_primeiro_pagamento__c || opp.Taxa_de_segundo_pagamento__c != oldOpp.Taxa_de_segundo_pagamento__c || opp.Taxa_de_terceiro_pagamento__c != oldOpp.Taxa_de_terceiro_pagamento__c || opp.Taxa_de_quarto_pagamento__c != oldOpp.Taxa_de_quarto_pagamento__c || opp.Taxa_de_quinto_pagamento__c != oldOpp.Taxa_de_quinto_pagamento__c || opp.Novo_primeiro_vencimento__c != oldOpp.Novo_primeiro_vencimento__c || opp.Novo_segundo_vencimento__c != oldOpp.Novo_segundo_vencimento__c || opp.Novo_terceiro_vencimento__c != oldOpp.Novo_terceiro_vencimento__c || opp.Novo_quarto_vencimento__c != oldOpp.Novo_quarto_vencimento__c || opp.Novo_quinto_vencimento__c != oldOpp.Novo_quinto_vencimento__c){
                if (opp.RecordTypeId == vendaBasicaId){
                    oppId.add(opp.Id);
                }
                // Agregado por Jhonny Peroza
                if (opp.RecordTypeId == pbComercialId && opp.IsClon__c == false) {
                    opportunityList.add(opp);
                }   
            }
        }

        // Agregado por Jhonny Peroza
        if (opportunityList.size() > 0){
            OpportunityHelper.updateOpportunity(opportunityList);
            productList=OpportunityHelper.verifyProducts(opportunityList);
            OpportunityHelper.saveListItems(productList, opportunityList);
        }

        if (oppId.size() > 0){
            olis = [SELECT Id, OpportunityId
                    FROM OpportunityLineItem
                    WHERE OpportunityId IN :oppId];
            System.debug(olis);
            OpportunityLineItemTriggerXappiaHelper.LREngineUpdate(olis);
        }
    }
}
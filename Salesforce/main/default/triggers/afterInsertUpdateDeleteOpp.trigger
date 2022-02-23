trigger afterInsertUpdateDeleteOpp on Opportunity (after delete, after insert, after update, after undelete) {

    //BRAXUtils.actualizarVentasPerfilCuenta(Trigger.new, Trigger.old);
    //
    
    if((Trigger.isBefore)&&(Trigger.isInsert)){
         for(Opportunity opp : Trigger.new){
            System.debug('ID DE CAMPAÑA '+ opp.CampaignId);
        }
    }

    Boolean hayEstimativaFC = false;
    if (Trigger.new != null && Trigger.new[0].RecordTypeId == '0125a000000QkXG' )
        hayEstimativaFC = true;
    
    if (!hayEstimativaFC)     
        BRAXUtils.actualizarVentasPerfilCuenta2(Trigger.new, Trigger.old);
  
    if(trigger.isAfter 
      && trigger.isInsert){
        BusinessRules__c rule = BusinessRules__c.getInstance();
        System.debug(rule);
        if(rule != null){
            if(rule.ValidateAIIUniqueness__c) OpportunityHandler.validateAII(trigger.new);
            if(rule.ValidatePreviousAttachment__c) OpportunityHandler.ValidatePreviousAttachment(trigger.new);
            List<Opportunity> opps = trigger.new;
            if(rule.ChangeOpportunityOwner__c){
                opps = OpportunityHandler.ChangeOwnerInAfter(trigger.new);
                if(rule.ShareWithCreator__c) OpportunityHandler.ShareOpportunityFromCommunity(opps, trigger.oldMap);
            }
            if(rule.SetPricebook__c) OpportunityHandler.setPricebook2Id(opps);
            if(rule.ValidateSotck__c) OpportunityHandler.validateStock(opps);
            if(rule.AddOliForAttachment__c) OpportunityHandler.addOpportunityLineItems(opps);
        }
          
   }
   System.debug('Ernesto Querys 3'+Limits.getQueries());
   
    Set<String> idCuentasBonifBRMX = New Set<String>();
    Set<String> idCuentasBonifDSEM = New Set<String>();
    Set<String> idCuentasBonifNEOG = New Set<String>();
    Set<String> idCuentasElimBonifBRMX = New Set<String>();
    Set<String> idCuentasElimBonifDSEM = New Set<String>();
    Set<String> idCuentasElimBonifNEOG = New Set<String>();
    Set<String> idCuentasBonifBRMXAIV = New Set<String>();
    Set<String> idCuentasElimBonifBRMXAIV = New Set<String>();
    Set<String> idCuentasBonifNEOGAIV = New Set<String>();
    Set<String> idCuentasElimBonifNEOGAIV = New Set<String>();
    List<String> idAnexosValidar = New List<String>();
    List<String> idStockActivar = New List<String>();
    if (Trigger.New != null){
        for (Opportunity op : Trigger.New){
            if (Trigger.isUpdate){
                if (Trigger.size == 1 && (op.RecordtypeId == '01240000000M7M0' || op.RecordtypeId == '01240000000M7y8') && op.StageName == 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName != 'Aprobada')
                    idAnexosValidar.add(op.Id);
                if (Trigger.size == 1 && op.RecordtypeId == '01240000000M9lt' && op.StageName == 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName != 'Aprobada')
                    idStockActivar.add(op.Id);  
                if (op.RecordtypeId == '01240000000M7y6' && op.Safra__c == '20/21' && op.Marca__c == 'BRMX' && op.StageName == 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName != 'Aprobada')
                //if (op.RecordtypeId == '01240000000M7y6' && op.Safra__c == '20/21' && op.Marca__c == 'BRMX' && op.Description != null && System.Trigger.oldMap.get(op.Id).Description == null)
                    idCuentasBonifBRMX.add(op.AccountId);           
                if (op.RecordtypeId == '01240000000M7y6' && op.Safra__c == '20/21' && op.Marca__c == 'DSEM' && op.StageName == 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName != 'Aprobada')
                //if (op.RecordtypeId == '01240000000M7y6' && op.Safra__c == '20/21' && op.Marca__c == 'DSEM' && op.Description != null && System.Trigger.oldMap.get(op.Id).Description == null)
                    idCuentasBonifDSEM.add(op.AccountId);  
                if (op.RecordtypeId == '01240000000M7y6' && op.Safra__c == '20/21' && op.Marca__c == 'NEOG' && op.StageName == 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName != 'Aprobada')
                    idCuentasBonifNEOG.add(op.AccountId);     
                if (op.RecordtypeId == '01240000000M7y6' && op.Safra__c == '20/21' && op.Marca__c == 'BRMX' && op.StageName != 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName == 'Aprobada')
                    idCuentasElimBonifBRMX.add(op.AccountId);
                if (op.RecordtypeId == '01240000000M7y6' && op.Safra__c == '20/21' && op.Marca__c == 'DSEM' && op.StageName != 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName == 'Aprobada')
                    idCuentasElimBonifDSEM.add(op.AccountId);
                if (op.RecordtypeId == '01240000000M7y6' && op.Safra__c == '20/21' && op.Marca__c == 'NEOG' && op.StageName != 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName == 'Aprobada')
                    idCuentasElimBonifNEOG.add(op.AccountId);       
                if (op.RecordtypeId == '01240000000M7y8' && op.Safra__c == '20/21' && op.Marca__c == 'BRMX' && op.StageName == 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName != 'Aprobada')
                    idCuentasBonifBRMXAIV.add(op.AccountId);
                if (op.RecordtypeId == '01240000000M7y8' && op.Safra__c == '20/21' && op.Marca__c == 'BRMX' && op.StageName != 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName == 'Aprobada')
                    idCuentasElimBonifBRMXAIV.add(op.AccountId);                     
                if (op.RecordtypeId == '01240000000M7y8' && op.Safra__c == '20/21' && op.Marca__c == 'NEOG' && op.StageName == 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName != 'Aprobada')
                    idCuentasBonifNEOGAIV.add(op.AccountId);
                if (op.RecordtypeId == '01240000000M7y8' && op.Safra__c == '20/21' && op.Marca__c == 'NEOG' && op.StageName != 'Aprobada' && System.Trigger.oldMap.get(op.Id).StageName == 'Aprobada')
                    idCuentasElimBonifNEOGAIV.add(op.AccountId);    
            }   
        }
    
        if (idCuentasBonifBRMX.size() > 0)
            BRAXUtils.crearBonificaciones(idCuentasBonifBRMX, 'BRMX');
            
        if (idCuentasBonifDSEM.size() > 0)
            BRAXUtils.crearBonificaciones(idCuentasBonifDSEM, 'DSEM');  
            
        if (idCuentasBonifNEOG.size() > 0)
            BRAXUtils.crearBonificaciones(idCuentasBonifNEOG, 'NEOG');    
        
        if (idCuentasElimBonifBRMX.size() > 0)
            BRAXUtils.eliminarBonificaciones(idCuentasElimBonifBRMX, 'BRMX');
            
        if (idCuentasElimBonifDSEM.size() > 0)
            BRAXUtils.eliminarBonificaciones(idCuentasElimBonifDSEM, 'DSEM');   
            
        if (idCuentasElimBonifNEOG.size() > 0)
            BRAXUtils.eliminarBonificaciones(idCuentasElimBonifNEOG, 'NEOG');    
            
        if (idCuentasBonifBRMXAIV.size() > 0)
            BRAXUtils.crearBonificacionesAIV(idCuentasBonifBRMXAIV, 'BRMX');
            
        if (idCuentasElimBonifBRMXAIV.size() > 0)
            BRAXUtils.eliminarBonificacionesAIV(idCuentasElimBonifBRMXAIV, 'BRMX');
            
        if (idCuentasBonifNEOGAIV.size() > 0)
            BRAXUtils.crearBonificacionesAIV(idCuentasBonifNEOGAIV, 'NEOG');
            
        if (idCuentasElimBonifNEOGAIV.size() > 0)
            BRAXUtils.eliminarBonificacionesAIV(idCuentasElimBonifNEOGAIV, 'NEOG');    
            
        if (idStockActivar.size() > 0)
            Opp_Utils.activarStockMult(idStockActivar); 
        
        if (Opp_Utils.validando == false){
            Opp_Utils.validando = true;
            if (idAnexosValidar.size() > 0)
                Opp_Utils.validarAnexos(idAnexosValidar);
        }   
    
    }           
    System.debug('Ernesto Querys 4'+Limits.getQueries());
    
}
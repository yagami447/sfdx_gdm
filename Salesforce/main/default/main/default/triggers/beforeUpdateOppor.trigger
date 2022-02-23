trigger beforeUpdateOppor on Opportunity (before update) {
    //String[] resultado = New String[2];
    Map<Id, Opportunity> rejectedStatements = new Map<Id, Opportunity>{};
    Schema.DescribeFieldResult fieldResult2 = Opportunity.Bloqueo__c.getDescribe();
    List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
    Map<String, String> mapValores3 = new Map<String,String>();         
    for(Schema.PicklistEntry f : ple2) if(f.getLabel().length() > 1) mapValores3.put(f.getLabel().substring(0,2), f.getLabel()); 
    
    if(Trigger.new == null) return;
    for(Opportunity o : Trigger.new){
       Opportunity Antes = System.Trigger.oldMap.get(o.Id);
       if (Antes.Marca__c != o.Marca__c && Antes.Marca__c != null)
           o.Marca__c.adderror('Não é permitido alterar a marca.');               
       if (Antes.Mes__c != o.Mes__c)
           o.Mes__c.adderror('Não é permitido alterar o mes.');                 
       if(((o.StageName == 'Desaprobado x Gerente' && Antes.StageName != 'Desaprobado x Gerente') || (o.StageName == 'Rechazada Supervisor' && Antes.StageName != 'Rechazada Supervisor')) && o.Motivo_de_Rechazo__c == null && (o.TipoReg__c.contains('Anexo') || o.TipoReg__c.contains('Stock'))){
           rejectedStatements.put(o.Id, o);  //Jere cambio 19.02.04
           o.Motivo_de_Rechazo__c.adderror('Para recusar deve completar o campo Motivo de Rejeição.');
           
       }
       /*
       if((o.RecordtypeId == '01240000000MAR3' || o.RecordtypeId == '01233000000MI0j' || o.RecordtypeId == '01240000000MAR8') && Antes.Notificado__c)              
           o.Notificado__c.adderror('Não é permitido alterar.');
       */
       if(o.Bloqueo__c != null){                
            String bloq = null;
            if (o.Bloqueo__c != null && o.Bloqueo__c != '' && o.Bloqueo__c != 'null'){
                bloq = mapValores3.get(o.Bloqueo__c.substring(0,2));
                if (bloq != null) o.Bloqueo__c = bloq;
            }else{ o.Bloqueo__c = null;}
            if((Antes.Bloqueo__c == null || Antes.Bloqueo__c.substring(0,2) != 'Z0') && (o.Bloqueo__c != null && o.Bloqueo__c.substring(0,2) == 'Z0')){o.StageName = 'AN - Anulada';}
            else{if((Antes.Bloqueo__c != null && Antes.Bloqueo__c.substring(0,2) == 'Z0') && (o.Bloqueo__c == null || o.Bloqueo__c.substring(0,2) != 'Z0')){o.StageName = 'AU - Autorizada';}}
        }
    }
    //******************************************************************************************
/*
    if (!rejectedStatements.isEmpty()){
        List<Id> processInstanceIds = new List<Id>{};    
        for (Opportunity invs : [SELECT (SELECT Id FROM ProcessInstances WHERE Status = 'Rejected'
                                              ORDER BY CreatedDate DESC
                                              LIMIT 1)
                                      FROM Opportunity
                                      WHERE ID IN :rejectedStatements.keySet()])
        {
            processInstanceIds.add(invs.ProcessInstances[0].Id);
        }     

        for (ProcessInstance pi : [SELECT TargetObjectId,
                                       (SELECT Id, StepStatus, Comments FROM Steps                                          
                                        ORDER BY CreatedDate DESC
                                        LIMIT 1 )
                                   FROM ProcessInstance
                                   WHERE Id IN :processInstanceIds
                                   ORDER BY CreatedDate DESC])   
        {                   
            if(pi.Steps != null && pi.Steps.size() > 0){
                if (pi.Steps[0].Comments == null || pi.Steps[0].Comments.trim().length() == 0)
                    rejectedStatements.get(pi.TargetObjectId).addError('Operação Cancelada: Para recusar deve completar o Motivo de Rejeição!');
                else
                    rejectedStatements.get(pi.TargetObjectId).Motivo_de_Rechazo__c = pi.Steps[0].Comments;
            }
        }  
    }
  */
    //********************************************************************************************
    Set<Id> rtPend = New Set<ID>();String rtNCPend = '';
    Boolean hayPendiente = false; Boolean hayVB = false;
    Decimal sumaTasas = 0; Decimal sumaTasasMBAS = 3.65;
    List<Id> dest = New List<Id>();
    List<Id> centros = New List<Id>();
    Map<Id,Id> mapDest = New Map<Id,Id>();
    Map<Id,Id> mapCentros = New Map<Id,Id>();
    map<String,Centro_Logistico__c> mapCen = New map<String,Centro_Logistico__c>();
    Map<String,Taxas_Fiscais__c> mapTaxas = New Map<String,Taxas_Fiscais__c>();
    Set<Id> vbList = New Set<Id>();  
    List<Id> oppIds = New List<Id>();
    Map<Id,List<OpportunityLineItem>> items = New Map<Id,List<OpportunityLineItem>>();
    Configuracion_BMX__c confTasas = New Configuracion_BMX__c(Londrina_Tasa_COFINS__c=0, Londrina_Tasa_ISS__c=0, Londrina_Tasa_PIS__c=0, Passo_Fundo_Tasa_COFINS__c=0, Passo_Fundo_Tasa_ISS__c=0, Passo_Fundo_Tasa_PIS__c=0);  
    Set<Id> ncAct = New Set<Id>(); Set<Id> pendParaAct = New Set<Id>(); Map<String,Opportunity> mapOppPend = New Map<String,Opportunity>();  
    //Se reemplaza el uso de SOQL, para minimizar uso excesivo de SOQL
    //----------------------------------------------------------------
    // for(RecordType r: [SELECT Id, Name FROM RecordType WHERE Name IN ('CVB Pendiente','CVB Rechazada', 'Pendiente', 'NC - Pendiente')]){
    //     if(r.Name != 'Pendiente' && r.Name != 'NC - Pendiente')vbList.add(r.Id);
    //     else rtPend.add(r.Id);
    //     if(r.Name == 'NC - Pendiente')rtNCPend = r.Id;
    // }
    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
    Map<String,Schema.RecordTypeInfo> Opp_rtMapByName = new Map<String,Schema.RecordTypeInfo>();
    for(String rt : rtMapByName.keySet()){
        if(rt == 'CVB Pendiente' || rt == 'CVB Rechazada' || rt == 'Pendiente' || rt == 'NC - Pendiente'){
            Opp_rtMapByName.put(rt, rtMapByName.get(rt));
        }
    }

    for(String r_name : Opp_rtMapByName.keySet()){
        if(r_name != 'Pendiente' && r_name != 'NC - Pendiente')vbList.add(Opp_rtMapByName.get(r_name).getRecordTypeId());
        else rtPend.add(Opp_rtMapByName.get(r_name).getRecordTypeId());
        if(r_name == 'NC - Pendiente')rtNCPend = Opp_rtMapByName.get(r_name).getRecordTypeId();
    }
    //----------------------------------------------------------------
    for(Opportunity o : Trigger.new){
        Opportunity Antes = System.Trigger.oldMap.get(o.Id);
        if(o.RecordTypeId == rtNCPend && o.Pedido_Relacionado__c != null && o.Pedido_Relacionado__c != Antes.Pedido_Relacionado__c) {ncAct.add(o.Id); pendParaAct.add(o.Pedido_Relacionado__c);}
        oppIds.add(o.Id);
        if(rtPend.Contains(o.RecordTypeId)) hayPendiente = true;
        if(vbList.Contains(o.RecordTypeId)) hayVB = true;              
    } 
    if(pendParaAct.Size() != 0){for(Opportunity oo: [SELECT Id, Origen__r.Id, Tipo_de_Cota_o__c, Tipo_de_cambio__c, Fecha_fijacion_T_de_cambio__c, VB_Cot_Soja__c FROM Opportunity WHERE Id IN : pendParaAct AND Origen__c != null AND Tipo_de_Cota_o__c != null AND Tipo_de_cambio__c != null]){ mapOppPend.put(String.ValueOf(oo.Id), oo);}}
    
    if(mapOppPend.Size() != 0){
        for(Opportunity o : Trigger.new){
            if(ncAct.contains(o.Id) && mapOppPend.ContainsKey(String.ValueOf(o.Pedido_Relacionado__c))){o.Origen__c = mapOppPend.get(String.ValueOf(o.Pedido_Relacionado__c)).Origen__r.Id; o.Tipo_de_Cota_o__c = mapOppPend.get(String.ValueOf(o.Pedido_Relacionado__c)).Tipo_de_Cota_o__c;o.Tipo_de_cambio__c = mapOppPend.get(String.ValueOf(o.Pedido_Relacionado__c)).Tipo_de_cambio__c;o.Fecha_fijacion_T_de_cambio__c = mapOppPend.get(String.ValueOf(o.Pedido_Relacionado__c)).Fecha_fijacion_T_de_cambio__c; o.VB_Cot_Soja__c = mapOppPend.get(String.ValueOf(o.Pedido_Relacionado__c)).VB_Cot_Soja__c;}
        }
    }
                
    for(Opportunity o : Trigger.new){
        if (o.Destinatario_de_Mercaderia__c != null)
            dest.add(o.Destinatario_de_Mercaderia__c);
        if (o.Origen__c != null)
            centros.add(o.Origen__c);                
    }        
    
   
    
    if(hayPendiente){for (Configuracion_BMX__c conf : [Select Londrina_Tasa_COFINS__c, Londrina_Tasa_ISS__c, Londrina_Tasa_PIS__c, Passo_Fundo_Tasa_COFINS__c, Passo_Fundo_Tasa_ISS__c, Passo_Fundo_Tasa_PIS__c From Configuracion_BMX__c limit 1]){
                     if (conf.Londrina_Tasa_COFINS__c != null) confTasas.Londrina_Tasa_COFINS__c = conf.Londrina_Tasa_COFINS__c;
                     if (conf.Londrina_Tasa_ISS__c != null) confTasas.Londrina_Tasa_ISS__c = conf.Londrina_Tasa_ISS__c;
                     if (conf.Londrina_Tasa_PIS__c != null) confTasas.Londrina_Tasa_PIS__c = conf.Londrina_Tasa_PIS__c;
                     if (conf.Passo_Fundo_Tasa_COFINS__c != null) confTasas.Passo_Fundo_Tasa_COFINS__c = conf.Passo_Fundo_Tasa_COFINS__c;
                     if (conf.Passo_Fundo_Tasa_ISS__c != null) confTasas.Passo_Fundo_Tasa_ISS__c = conf.Passo_Fundo_Tasa_ISS__c;                    
                     if (conf.Passo_Fundo_Tasa_PIS__c != null) confTasas.Passo_Fundo_Tasa_PIS__c = conf.Passo_Fundo_Tasa_PIS__c;
    }} 
    if(hayVB){
         
         List<Contact> con = [SELECT Id, Estado__r.Id FROM Contact WHERE Id In : dest];
        for (Contact c : con){
            mapDest.put(c.Id, c.Estado__r.Id);  
        }  
        List<Taxas_Fiscais__c> taxas = [SELECT Id, Aliquota_de_ICMS__c, Base_de_Calculo__c, Estado_Destino__c, Estado_Origem__c FROM Taxas_Fiscais__c];
        for (Taxas_Fiscais__c t : taxas ){
            if (!mapTaxas.containsKey(String.valueOf(t.Estado_Destino__c) + String.valueOf(t.Estado_Origem__c)))  
                mapTaxas.put(String.valueOf(t.Estado_Destino__c) + String.valueOf(t.Estado_Origem__c), t);  
        }
    }
    if(hayVB || hayPendiente){
        for (Opportunity o : [Select Id, (SELECT Id, OpportunityId, Base_de_Calculo__c, Tasas__c, PricebookEntry.Product2.Sector__c FROM OpportunityLineItems) FROM Opportunity WHERE Id In : oppIds])
            items.put(o.Id, o.OpportunityLineItems);
            
        
        for (Centro_Logistico__c c : [SELECT Id, Estado__r.Id, Name FROM Centro_Logistico__c]){
            mapCentros.put(c.Id, c.Estado__r.Id); mapCen.put(String.ValueOf(c.Id),c);
    }
              
    for(Opportunity o : Trigger.new){
         Opportunity Antes = System.Trigger.oldMap.get(o.Id);
         try{       
         if(vbList.Contains(o.RecordTypeId) && (o.Destinatario_de_Mercaderia__c != Antes.Destinatario_de_Mercaderia__c || o.Origen__c != Antes.Origen__c)){
             if(o.Destinatario_de_Mercaderia__c != null && o.Origen__c != null){                         
                 //o.Estado_Destino__c = mapTaxas.get(String.valueOf(mapDest.get(o.Destinatario_de_Mercaderia__c)) + String.valueOf(mapCentros.get(o.Origen__c))).Estado_Destino__c;
                 //o.Estado_Origem__c = mapTaxas.get(String.valueOf(mapDest.get(o.Destinatario_de_Mercaderia__c)) + String.valueOf(mapCentros.get(o.Origen__c))).Estado_Origem__c;
                 List<OpportunityLineItem> oplis = items.get(o.Id);
                 for(OpportunityLineItem opli : oplis){
                    if(mapTaxas.containsKey(String.valueOf(mapDest.get(o.Destinatario_de_Mercaderia__c)) + String.valueOf(mapCentros.get(o.Origen__c)))){
                        opli.Base_de_Calculo__c = mapTaxas.get(String.valueOf(mapDest.get(o.Destinatario_de_Mercaderia__c)) + String.valueOf(mapCentros.get(o.Origen__c))).Base_de_Calculo__c;
                        opli.Tasas__c = mapTaxas.get(String.valueOf(mapDest.get(o.Destinatario_de_Mercaderia__c)) + String.valueOf(mapCentros.get(o.Origen__c))).Aliquota_de_ICMS__c;
                    }
                 }
                 update oplis;                 
              }
          }else{
                if(rtPend.Contains(o.RecordTypeId)){
                    List<OpportunityLineItem> oplis = items.get(o.Id);
                    if(rtPend.Contains(o.RecordTypeId) && o.Origen__c != Antes.Origen__c && o.Origen__c != null){
                        if(mapCen.get(String.ValueOf(o.Origen__c)).Name.contains('Londrina') || mapCen.get(String.ValueOf(o.Origen__c)).Name.contains('Cambe')) sumaTasas = confTasas.Londrina_Tasa_COFINS__c + confTasas.Londrina_Tasa_ISS__c + confTasas.Londrina_Tasa_PIS__c;
                        if(mapCen.get(String.ValueOf(o.Origen__c)).Name.contains('Passo Fundo')) sumaTasas = confTasas.Passo_Fundo_Tasa_COFINS__c + confTasas.Passo_Fundo_Tasa_ISS__c + confTasas.Passo_Fundo_Tasa_PIS__c;
                        if(o.OwnerId == '00540000001TUHM') sumaTasas = sumaTasasMBAS; ///PRODUCTIVO
                        //if(o.OwnerId == '00540000001TNkC') sumaTasas = sumaTasasMBAS; ///SANDBOX
                        for(OpportunityLineItem opli : oplis) opli.Tasas__c = sumaTasas;
                        update oplis;
                    }
                }
          }
         }catch(exception e){
            String mens = e.getMessage();
            mens = mens.split(',')[mens.split(',').size() - 1] + '-' + String.ValueOf(e.getLineNumber()) +'-'+e.getStackTraceString(); 
            o.Tipo__c.adderror(mens);}
         
      }
    } 

    OpportunittyHelper.updateOpportunityCooperante(Trigger.New, Trigger.OldMap);
}
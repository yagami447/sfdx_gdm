trigger afterUpdate on Opportunity (after update) {
      Boolean prodBasica = true;
      for (Opportunity op : Trigger.New){
          if (op.RecordTypeId == '01240000000M58N' || op.RecordTypeId == '01240000000M8Iw' || op.RecordTypeId == '0120v000000op3S' || op.RecordTypeId == '0125a000000QkXG' || op.RecordTypeId == '01240000000M9lt')
              return;
              //prodBasica = false;
      }
      if (prodBasica){
        String[] resultado = New String[2];
        Opportunity o = New Opportunity();
        resultado = BRAXUtils.actualizarProdBasica(Trigger.New, System.Trigger.oldMap, false);
        BRAXUtils.actualizarProdBasica_New(Trigger.New, System.Trigger.oldMap, false);
        o.addError(resultado[1]);
      }

    //BRAXUtils.generarOppPBP(Trigger.New, System.Trigger.oldMap);
    
    //BRAXUtils.actualizarCampoActiva(Trigger.New);
    
    /*
    Set<String> idOpps = New Set<String>();    
    for (Opportunity op : Trigger.New)
        if (op.Tipo_de_Cambio__c != System.Trigger.oldMap.get(op.Id).Tipo_de_Cambio__c)
            idOpps.add(op.Id);
            
    if (idOpps.size() > 0){         
        List<OpportunityLineItem> items = New List<OpportunityLineItem>();
        items = [Select Id, VL_Liquido__c, VL_Liquido_Copia__c From OpportunityLineItem Where OpportunityId In : idOpps];                               
        for (OpportunityLineItem i : items)
            i.VL_Liquido_Copia__c = i.VL_Liquido__c;            
                
        update items;
    }
    */
    
   //Xappia. Se genera el PDF para los descartes 11/3/2020 NO ESTABA EN dev si en Prod
  if (Trigger.isAfter && Trigger.isUpdate) {
    //Comentado para minimizar uso excesivo de SOQL
    // RecordType tipoDescarte = [SELECT ID FROM RecordType WHERE DeveloperName = 'Descarte'];
    Id tipoDescarte = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Descarte').getRecordTypeId();
    for (Opportunity oportunidad : Trigger.new) {
      if (oportunidad.RecordTypeId == tipoDescarte && oportunidad.isWon && !Trigger.oldMap.get(oportunidad.id).isWon) {
        PdfParaDescarte.printDescarteAutorization(oportunidad.Id);
      }
    }
  }
  
}
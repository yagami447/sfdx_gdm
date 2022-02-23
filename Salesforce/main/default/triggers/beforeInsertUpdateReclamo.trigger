trigger beforeInsertUpdateReclamo on Case (before insert, before update) {
   //Contact Contacto = New Contact();
   Cidade__c CiudadProb = New Cidade__c();
   try{
      if(Trigger.new == null) return;
        for(Case c : Trigger.new){
            //if(c.Contactado__c == true && c.Fecha_de_Contacto__c == null)
              // c.Fecha_de_Contacto__c = System.Today();
              //if(c.ContactId != null){
                  //Contacto = [SELECT Id, Name FROM Contact WHERE Id = : c.ContactId limit 1];
                  //c.Empresa__c = Contacto.Name;
                  //}              
              if(c.Ciudad_del_Problema__c != null){
                    CiudadProb = [SELECT Id, Regi_o__r.Microrregi_o_de_Vendas__c, Regi_o__r.Microrregi_o_de_Vendas__r.Macrorregi_o_de_Vendas__c FROM Cidade__c WHERE Id = :c.Ciudad_del_Problema__c limit 1];
                    c.Microregion_de_Ventas__c = CiudadProb.Regi_o__r.Microrregi_o_de_Vendas__c;
                    c.Macroregion_de_Ventas__c = CiudadProb.Regi_o__r.Microrregi_o_de_Vendas__r.Macrorregi_o_de_Vendas__c;
              }              
        }
        
        BRAXUtils.actualizarResponsableCasos(Trigger.new);
        BRAXUtils.actualizarRTCasos(Trigger.new, System.Trigger.oldMap);
  }catch(Exception e) {
    throw e;
  }

}
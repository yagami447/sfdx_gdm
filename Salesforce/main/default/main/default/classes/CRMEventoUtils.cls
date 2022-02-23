public class CRMEventoUtils {
    
    public CRMEventoUtils(){        
    }
    
    public static void actualizarEventosPerfilCuenta(CRM_Calendario_de_Eventos__c[] eventosNew, CRM_Calendario_de_Eventos__c[] eventosOld){
        
        Set<Id> accIds = New Set<Id>();
        Set<String> accParentIds = New Set<String>();
        accParentIds.add('111111111111111'); //Para cuando consulto que los parentid esten en esta coleccion por lo menos que tenga algo. Si es nulo me va a traer cuentas que no me interesan.
        String safra = '';
        
        Map<String,Double> eventos = New Map<String,Double>();
        Map<String,Double> eventosDMS = New Map<String,Double>();
        Map<String,Double> eventosDMS2 = New Map<String,Double>();
        
        for(Configuracion_BMX__c conf : [Select CRM_Safra_Siguiente__c FROM Configuracion_BMX__c limit 1])
            safra = conf.CRM_Safra_Siguiente__c;
        
        if(eventosNew != null)
            for(CRM_Calendario_de_Eventos__c e : eventosNew)
                if(e.Safra__c == safra && e.Cuenta__c != null)
                    accIds.add(e.Cuenta__c);
                    
        if(eventosOld != null)
            for(CRM_Calendario_de_Eventos__c e : eventosOld)
                if(e.Safra__c == safra && e.Cuenta__c != null)
                    accIds.add(e.Cuenta__c);                            
                    
        if(accIds.size() > 0){
          for (Account a : [Select Id, ParentId From Account Where Id In : accIds])
            if (a.ParentId != null)
              accParentIds.add(a.ParentId);
          
            for (AggregateResult ar : [Select Count(Id) cant, Evento__c, Cuenta__c, Cuenta__r.ParentId principal From CRM_Calendario_de_Eventos__c Where (Evento__c In ('Palestra', 'Treinamento', 'Lado a Lado') Or (Evento__c = 'Día de Campo' And (Custo__c = null Or Custo__c = 0))) And (Cuenta__c In : accIds Or Cuenta__r.ParentId In : accParentIds) And Safra__c = : safra And Marca__c = 'BRMX' And Fase__c = 'Aprovado' Group By Cuenta__r.ParentId, Cuenta__c, Evento__c]){
                String cuenta = String.valueOf(ar.get('Cuenta__c'));
                if (ar.get('principal') != null)
                  cuenta = String.valueOf(ar.get('principal'));   
                if (!eventos.containsKey(cuenta + String.valueOf(ar.get('Evento__c')))){
                  eventos.put(cuenta + String.valueOf(ar.get('Evento__c')), Double.valueOf(ar.get('cant')));  
                }else{
                  Double cant = eventos.get(cuenta + String.valueOf(ar.get('Evento__c')));
                    cant += Double.valueOf(ar.get('cant'));
                    eventos.remove(cuenta + String.valueOf(ar.get('Evento__c')));
                    eventos.put(cuenta + String.valueOf(ar.get('Evento__c')), cant);
                }                
            }
                
            for (CRM_Calendario_de_Eventos__c ar : [Select Cuenta__c, Cuenta__r.ParentId, Evento__c, Custo__c From CRM_Calendario_de_Eventos__c Where (Cuenta__c In : accIds Or Cuenta__r.ParentId In : accParentIds) And Safra__c = : safra And Marca__c = 'DSEM' And Fase__c = 'Aprovado' And (Evento__c = 'Día de Campo' Or Evento__c = 'Emplacamento')]){
                String cuenta = ar.Cuenta__c;
                if (ar.Cuenta__r.ParentId != null)
                  cuenta = ar.Cuenta__r.ParentId;
                if (ar.Evento__c == 'Día de Campo'){
                    if (!eventosDMS.containsKey(cuenta)){
                        Double custo = 0;
                        if (ar.Custo__c != null)
                            custo = ar.Custo__c;
                        eventosDMS.put(cuenta, custo);
                    }else{
                        if (ar.Custo__c != null && ar.Custo__c != 0){
                            eventosDMS.remove(cuenta);
                            eventosDMS.put(cuenta, ar.Custo__c);
                        }   
                    }
                }
                if (ar.Evento__c == 'Emplacamento'){
                    if (!eventosDMS2.containsKey(cuenta)){
                        eventosDMS2.put(cuenta, 1);
                    }else{
                        Double cantEmplac = eventosDMS2.get(cuenta);
                        cantEmplac = cantEmplac + 1;
                        eventosDMS2.remove(cuenta);
                        eventosDMS2.put(cuenta, cantEmplac);
                    }
                }
            }
        }
                
        List<CRM_Multiplicador__c> crm_mult = New List<CRM_Multiplicador__c>();
        crm_mult = [Select Id, Cuenta__c, Cuenta__r.ParentId, BR_Palestras_Realizado__c, BR_Treinamentos_Realizado__c, BR_LXL_Realizado__c, BR_Participacao_dia_campo_realizado__c, DS_Participaca_dias_de_campo__c From CRM_Multiplicador__c Where (Cuenta__c In : accIds Or Cuenta__r.ParentId In : accParentIds) And Safra__c = : safra];
        if(crm_mult.size() > 0){
            for(CRM_Multiplicador__c crm : crm_mult){
              String cuenta = crm.Cuenta__c;
                if (crm.Cuenta__r.ParentId != null)
                  cuenta = crm.Cuenta__r.ParentId;
                crm.BR_Palestras_Realizado__c = eventos.get(cuenta + 'Palestra');
                crm.BR_Treinamentos_Realizado__c = eventos.get(cuenta + 'Treinamento');
                crm.BR_LXL_Realizado__c = eventos.get(cuenta + 'Lado a Lado');
                crm.BR_Participacao_dia_campo_realizado__c = eventos.get(cuenta + 'Día de Campo');   
                crm.DS_Identifica_o_de_beiras_de_rodovia__c = eventosDMS2.get(cuenta);
                crm.DS_Participaca_dias_de_campo__c = true;
                if (eventosDMS.get(cuenta) != null){
                    Double cos = eventosDMS.get(cuenta);
                    if (cos > 0)
                        crm.DS_Participaca_dias_de_campo__c = false;
                }       
            }
            update crm_mult;
        }        
    }
    
    public static void actualizarEvent(CRM_Calendario_de_Eventos__c[] eventosNew, CRM_Calendario_de_Eventos__c[] eventosOld, Boolean del){
            
      //if (eventosOld != null && del){
      if (eventosOld != null){
        List <Event> eventosExistentes = New List <Event>();
        List<String> idsCalendario = New List<Id>();
        for (CRM_Calendario_de_Eventos__c c : eventosOld)                            
          idsCalendario.add(c.Id);
                    
        eventosExistentes = [Select Id, CRM_Calendario_de_eventos__c From Event Where CRM_Calendario_de_eventos__c In : idsCalendario];
      
      if (eventosExistentes.size() > 0)
        delete eventosExistentes;
      }
            
      if (eventosNew != null){
        List<Event> eventos = New List<Event>();
        /*
        Map<String, Event> eventosExistentes = New Map<String, Event>();
        
        List<String> idsCalendario = New List<Id>();
        for (CRM_Calendario_de_Eventos__c c : eventosNew)                            
          if (c.id != null)
            idsCalendario.add(c.Id);
      
        for (Event e : [Select Id, CRM_Calendario_de_eventos__c From Event Where CRM_Calendario_de_eventos__c In : idsCalendario And isChild = false])
          eventosExistentes.put(e.CRM_Calendario_de_eventos__c, e);
        */
        
        Set<String> idCuentas = New Set<String>();
        Set<String> idRevendas = New Set<String>();
        Map<String, String> creadoresEventos = New Map<String, String>();
        for (CRM_Calendario_de_eventos__c e : eventosNew){
          if (e.Cuenta__c != null)
            idCuentas.add(e.Cuenta__c);
          creadoresEventos.put(e.Id, e.CreatedById);
          if (e.Revenda__c != null)
            idRevendas.add(e.Revenda__c);  
        }
        
        Map<Integer, String> usuarios = New Map<Integer, String>();
        List<User> usuarios2 = New List<User>();
        String idUserMKT = '';
        for (User u : [Select Id, Codigo_SAP__c, UserRole.Name From User Where isActive = true]){  
              if (u.Codigo_SAP__c != null) 
                usuarios.put(Integer.valueOf(u.Codigo_SAP__c), String.valueOf(u.Id));
             usuarios2.add(u);   
             if (u.UserRole.Name == 'Gerencia y Marketing')
               idUserMKT = u.Id;  
        }
        
          Map<String, String> propBRMX = New Map<String, String>();        
          Map<String, String> propDSEM = New Map<String, String>();
          Map<String, String> propNEOG = New Map<String, String>();
          Map<String, String> propDAGMA = New Map<String, String>();
          Map<String, String> propLICENCAS = New Map<String, String>();
          Map<String, String> regionCuenta = New Map<String, String>();
          Map<String, String> nombreCuenta = New Map<String, String>();
          Map<String, String> nombreRevenda = New Map<String, String>();
          
          for (Account a : [Select Id, Nome_fantasia__c, Responsavel__c, Reponsavel_DSEM__c, Responsavel_NEOGEN__c, Responsavel_DAGMA__c, Responsavel_LICENCAS__c, Region__r.Region_Comercial__c From Account Where Id In : idCuentas]){
              String idUserBRMX = null;
              String idUserDSEM = null;
              String idUserNEOG = null;
              String idUserDAGMA = null;
              String idUserLICENCAS = null;

              if (a.Responsavel__c != null) {        
                  idUserBRMX = usuarios.get(Integer.valueOf(a.Responsavel__c.split('-')[0].trim()));
                  if (idUserBRMX != null && idUserBRMX != '')
                      propBRMX.put(a.Id, idUserBRMX);
              }
              if (a.Reponsavel_DSEM__c != null) {
                  idUserDSEM = usuarios.get(Integer.valueOf(a.Reponsavel_DSEM__c.split('-')[0].trim()));
                  if (idUserDSEM != null && idUserDSEM != '')
                      propDSEM.put(a.Id, idUserDSEM);
              }    
              if (a.Responsavel_NEOGEN__c != null) {
                  idUserNEOG = usuarios.get(Integer.valueOf(a.Responsavel_NEOGEN__c.split('-')[0].trim()));
                  if (idUserNEOG != null && idUserNEOG != '')
                      propNEOG.put(a.Id, idUserNEOG);
              }
              if (a.Responsavel_DAGMA__c != null) {
                  idUserDAGMA = usuarios.get(Integer.valueOf(a.Responsavel_DAGMA__c.split('-')[0].trim()));
                  if (idUserDAGMA != null && idUserDAGMA != '')
                  propDAGMA.put(a.Id, idUserDAGMA);
              }
              if (a.Responsavel_LICENCAS__c != null) {
                idUserLICENCAS = usuarios.get(Integer.valueOf(a.Responsavel_LICENCAS__c.split('-')[0].trim()));
                if (idUserLICENCAS != null && idUserLICENCAS != '')
                propLICENCAS.put(a.Id, idUserLICENCAS);
            }
              
              if (a.Region__r.Region_Comercial__c != null && a.Region__r.Region_Comercial__c != '')
                regionCuenta.put(a.Id, a.Region__r.Region_Comercial__c);      
              if (a.Nome_fantasia__c != null && a.Nome_fantasia__c != '')
                nombreCuenta.put(a.Id, a.Nome_fantasia__c);  
          }              
          
          for (Account a : [Select Id, Name From Account Where Id In : idRevendas])
            nombreRevenda.put(a.Id, a.Name);
      
        //Set<String> eliminarInvitados = New Set<String>();                
        
        for (CRM_Calendario_de_Eventos__c e : eventosNew){          
           if (e.Fase__c == 'Aprovado' && (e.Evento__c == 'Día de Campo' || e.Evento__c == 'Palestra' || e.Evento__c == 'Treinamento' || e.Evento__c == 'Encontro Técnico' || e.Evento__c == 'Jornada Técnica')){
             Event newEvent = New Event();
             /*
             if (eventosExistentes.get(e.Id) != null){
               newEvent.Id = eventosExistentes.get(e.Id).Id;
               eliminarInvitados.add(newEvent.Id);  
             }
             */
            newEvent.CRM_Calendario_de_Eventos__c = e.Id;
            
            switch on e.Marca__c {
              when 'BRMX' {
                newEvent.Marca_Comercial__c = 'Brasmax';
                newEvent.OwnerId = propBRMX.get(e.Cuenta__c);
              }
              when 'DSEM' {
                newEvent.Marca_Comercial__c = 'Don Mario';
                newEvent.OwnerId = propDSEM.get(e.Cuenta__c);
              }
              when 'NEOG' {
                newEvent.Marca_Comercial__c = 'Neogen';
                newEvent.OwnerId = propNEOG.get(e.Cuenta__c);
              }
              when 'DAGMA' {
                newEvent.Marca_Comercial__c = 'Dagma';
                newEvent.OwnerId = propDAGMA.get(e.Cuenta__c);
              }
              when 'LICENÇAS'  {
                newEvent.Marca_Comercial__c = 'Licenças';
                newEvent.OwnerId = propLICENCAS.get(e.Cuenta__c);
              }
            }
          
            newEvent.Tipo_de_evento__c = e.Evento__c;
             
            String nomCta = '';
            if (nombreCuenta.get(e.Cuenta__c) != null)
              nomCta = nombreCuenta.get(e.Cuenta__c);
              
                     
             newEvent.Subject = e.Evento__c + ' ' + nomCta;    
             newEvent.WhatId = e.Cuenta__c;     
             newEvent.StartDateTime = e.Data_e_horario_inicio__c;
             newEvent.EndDateTime = e.Data_e_horario_termino__c;
//             newEvent.DurationInMinutes = 
             newEvent.ActivityDateTime = e.Data_e_horario_inicio__c;
                  
             if (e.Municipio__c != null)
               newEvent.Location = e.Nome_Cidade__c + ' ' + e.Estado__c;
             newEvent.Description = '';
             if (e.Participante__c != null)
               newEvent.Description = 'Participantes: ' + e.Participante__c + '\n';              
             if (e.Comentarios__c != null)
               newEvent.Description += 'Comentarios: ' + e.Comentarios__c + '\n';  
             if (e.Revenda__c != null)
               newEvent.Description += 'Revenda: ' + nombreRevenda.get(e.Revenda__c) + '\n';  
             eventos.add(newEvent);
           }          
        }
        
        
            if (eventos.size() > 0){            
                  insert eventos;
            
         
          List<EventRelation>  agregarInvitados = New List<EventRelation>();
          EventRelation agregarInvitado;          
          for (Event e : eventos){    
            String creador = creadoresEventos.get(e.CRM_Calendario_de_Eventos__c);  
            //if (e.OwnerId != UserInfo.getUserId()){
            if ((e.OwnerId != creador) && (creador != '00540000000zlzOAAQ') && (creador != '00518000001Sa4oAAC') && (creador != '0050b000004osweAAA')){
              agregarInvitado = New EventRelation();
              agregarInvitado.EventId = e.Id;
              //agregarInvitado.RelationId = UserInfo.getUserId();
              agregarInvitado.RelationId = creador;
              agregarInvitado.Status='Accepted';
              agregarInvitado.IsInvitee=true;              
              agregarInvitados.add(agregarInvitado);          
            }
            if (creador != idUserMKT){
              agregarInvitado = New EventRelation();
              agregarInvitado.EventId = e.Id;
              agregarInvitado.RelationId = idUserMKT;
              agregarInvitado.Status='Accepted';
              agregarInvitado.IsInvitee=true;              
              agregarInvitados.add(agregarInvitado);          
            }
            if (e.Tipo_de_evento__c == 'Día de Campo'){
              String region = regionCuenta.get(e.WhatId);
              if (region != null && region != ''){              
                for (User u : usuarios2){
                  agregarInvitado = New EventRelation();
                  agregarInvitado.EventId = e.Id;
                  agregarInvitado.RelationId = u.Id;
                  agregarInvitado.Status='Accepted';
                  agregarInvitado.IsInvitee=true;                
                  if ((region == 'REGION 1' || region == 'REGION 2') && u.Id != creador && u.Id != e.OwnerId && e.Marca_Comercial__c.contains('Brasmax') && (u.UserRole.Name == 'Comercial R1 BRMX' || u.UserRole.Name == 'Comercial R2 BRMX' || u.UserRole.Name == 'Gerente Regiao 1' || u.UserRole.Name == 'Gerente Regiao 2'))
                    agregarInvitados.add(agregarInvitado);
                  if ((region == 'REGION 1' || region == 'REGION 2') && u.Id != creador && u.Id != e.OwnerId && e.Marca_Comercial__c.contains('Don Mario') && (u.UserRole.Name == 'Comercial R1 DSEM' || u.UserRole.Name == 'Comercial R2 DSEM' || u.UserRole.Name == 'Gerente Regiao 1' || u.UserRole.Name == 'Gerente Regiao 2'))
                    agregarInvitados.add(agregarInvitado);  
                  if ((region == 'CERRADO') && u.Id != creador && u.Id != e.OwnerId && (u.UserRole.Name == 'Comercial Cerrados' || u.UserRole.Name == 'Gerente Cerrados'))
                    agregarInvitados.add(agregarInvitado);
                }
              }
            }
          }
        
          if (agregarInvitados.size() > 0)
            insert agregarInvitados;
        
        }      
      }
    }
}
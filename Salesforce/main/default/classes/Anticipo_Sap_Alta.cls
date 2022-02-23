global class Anticipo_Sap_Alta {
    public static boolean isTest = false;
    private static Map<String,Id> rty;
    
    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        Webservice String pedido;
        Webservice String relPos;
    }
    private class RetCabecera{
        String msg;                      
        sapAltaAnticipo.ZtfiCabeceraAnticipo TCab; 
        sapAltaAnticipo.ZtfiPosicionAnticipo TPos;
        Map<String,String> mapCabeceras;
        Boolean ret;
    }
    WebService static Retorno enviarSAP(List<Id> oppIds, String etapa, Integer target){    
        Retorno r = new Retorno();
        Retorno r1 = new Retorno();
        rty = Opp_Utils.cargarRecordTypesOportunidades();
        r.msg = '\n';
        try
        {
            List<Opportunity> o = [Select Id, PE_Bajar_SAP__c, AccountId From Opportunity Where Id In :oppIds];            
            List<Id> accIds = New List<Id>();
            for(Opportunity o2 : o)
                accIds.add(o2.AccountId);
            r = estaEnSAP(accIds);            
            if(r.ret){
               r = altaNVs(o, etapa, target);
               //for(Opportunity o2 : o)
               //    o.PE_Bajar_SAP__c = false;
            }else{
                  r.msg += '\nEl cliente no existe en SAP.\nLa Nota de Venta queda Pendiente para bajar.';
                  //o.Observaciones_Paso_a_SAP__c = r.msg;
                  r.ret = false;
                  //o.PE_Bajar_SAP__c = true;
                  //update o;
            }
        }
        catch(Exception e)
        {
            r.msg = 'En EnviarSAP - Error: ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    static Retorno estaEnSAP(List<Id> ids){
        Retorno r = new Retorno();
        try{
            if(ids != null && ids.size() > 0){
                List<Account> a = [Select Id, Name, esta_en_SAP__c, CodigoSAP__c From Account Where Id In :ids];                
                if(a != null){
                    for (Account a2 : a){
                        if(a2.CodigoSAP__c != null){
                            r.msg = 'La cuenta existe en SAP'; 
                        }
                        else{
                            r.msg = 'La cuenta ' + a2.Name + ' no existe en SAP'; r.ret = false;   
                        }                        
                    }
                    r.ret = true;
                }
                else{
                    r.msg = 'La cuenta es nula'; r.ret = false;
                }
            }
            else{
                r.msg = 'El Id de parametro es nulo'; r.ret = false;
            }
        }
        catch(Exception e){
            r.msg = e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    static Retorno altaNVs(List<Opportunity> opps, String etapa, Integer target){
        
        String[] retorno = New String[2];               
        Retorno r = new Retorno(); r.ret = true;
        List<Id> oppIds = New List<Id>();
        for(Opportunity o2 : opps)
            oppIds.add(o2.Id);
        List<Opportunity> o = [Select Nro_Pedido_SAP__c, Safra__c, Id, PE_bajar_SAP__c, OwnerId, Owner.Alias, Name, AccountId, Account.CodigoSAP__c, Account.Responsavel__c, CloseDate, RecordTypeId, StageName, Tipo_de_Cambio__c, Fecha_de_Entrega__c, Condicion_de_Pago__c, Sucursal__c, Tipo__c, Pedido_Relacionado__c, Motivo_de_Pedido__c, Account.Grupo_de_cuentas__c, Account.Region__r.Oficina_Ventas__c, Origen__r.Codigo_SAP__c, Destinatario_de_Mercaderia__r.Codigo_SAP__c, Marca__c, Responsable__c, Owner.Codigo_SAP__c, Owner.Profile.Name, Invierno__c, RecordType.Name, Pedido_Relacionado__r.Nro_Pedido_SAP__c, Region__c, Vencimiento_Anexo__c, Pagador__r.CodigoSAP__c, Cuenta_y_Orden__r.CodigoSAP__c, Total_VL_Liquido__c From Opportunity Where Id In :oppIds];        
        r.msg = '\nInicio: altaNVs';
        try{                       
                Retorno rsap = altaNVSAP(o, oppIds, etapa, '', target);
                if(rsap.ret){
                    r.ret = true;
                    r.msg = 'Processo Concluído.';
                    for (Opportunity op : o)
                        if (op.Observaciones_Paso_a_SAP__c.contains('foi contablizado'))
                            Boolean ok = setEtapaAU(op);                        
                }

                /*
                if((rsap.ret && rsap.pedido != null && rsap.pedido != '') || (rsap.msg.contains('Existe la Nota de Venta'))){
                    r.ret = true;
                    o.PE_Bajar_SAP__c = false;
                    o.Nro_Pedido_SAP__c = rsap.pedido;
                    o.Observaciones_Paso_a_SAP__c = rsap.msg;
                    String tipo = o.Tipo__c.substring(0,4);
                    if(!setEtapaAU(o)){
                       r.msg = 'Mala Etapa';
                       r.ret = false;
                    }
                    
                    if (rsap.msg.contains('Existe la Nota de Venta')){
                       Pattern p = Pattern.compile('[a-zA-Z]');
                       o.Nro_Pedido_SAP__c = p.matcher(rsap.msg.substring(0,40)).replaceAll('').trim();
                       
                       String nro_pedido = o.Nro_Pedido_SAP__c;
                       Integer long_nro_pedido = o.Nro_Pedido_SAP__c.length();
                       Integer ceros_agregar = 10 - long_nro_pedido;
                       String ceros = '';
                       Integer i;
                       for (i=0;i<ceros_agregar;i++)
                          ceros += '0';
                       o.Nro_Pedido_SAP__c = ceros + o.Nro_Pedido_SAP__c;   
                       o.Observaciones_Paso_a_SAP__c = 'BR - ' + nro_pedido + ' se ha grabado';                          
                    }                    
                }
                else{
                    o.Observaciones_Paso_a_SAP__c = rsap.msg;
                    r.ret = false;                  
                }
                r.msg = rsap.msg;  
                */              
        }
        catch(Exception e){
            r.msg = 'En altaNVs - Error: ' + e.getMessage(); r.ret = false;
        }
        
        try{
            update o;
            System.debug('UPDATE NV');
        }
        catch(DMLException e){
            r.msg = 'En altaNVs - Error: ' + e.getMessage(); r.ret = false;
        }        
        return r;
    }
    
    public static Retorno altaNVSAP(List<Opportunity> o, List<Id> oppIds, String parEtapa, String clienteSAP, Integer target){
        //sapAltaAnticipo.ZFiAltaAnticipos_element resultado;
        sapAltaAnticipo.ZtfiMensajeAnticipo resultado;
        Retorno r = new Retorno();        
        List<OpportunityLineItem> OppIts = new List<OpportunityLineItem>();
        Map<String,OpportunityLineItem> itemMap = new Map<String,OpportunityLineItem>();
        sapAltaAnticipo.ZtfiPosicionAnticipo TPos;
        //sapAltaAnticipo.ZsfiCabeceraAnticipo ICab;
        
        sapAltaAnticipo.ZtfiCabeceraAnticipo TCab;
        //TCab.item = new List<sapAltaAnticipo.ZsfiCabeceraAnticipo>();
        
        r.ret = true;
        r.msg = '\n';
                
        try{
            OppIts = [Select Id, OpportunityId, TMP_Observaciones__c, Posicion_SAP__c, Quantity, PricebookEntryId, PricebookEntry.Product2.Name, PricebookEntry.Product2.Codigo_material_SAP__c, PriceBookEntry.Product2.Licenciada__c, PriceBookEntry.Product2.Sector__c, UnitPrice, PriceBookEntry.UnitPrice, Contrato_Relacionado__c, Contrato_Relacionado__r.Name, Posicion_SAP_Relacionada__c, Tasas__c, Observaciones_Tasas__c, Precio_SAP__c, Base_de_Calculo__c, Precio_Liquido__c, PriceBookEntry.Product2.Family, Precio_Contrato__c, PricebookEntry.Product2.Variedade__c, Categoria__c, Precio_SAP_Estimado__c, PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c, Tratamiento_de_Semilla__c, Grupo_de_materiales_2__c, PricebookEntry.Product2.Variedade__r.Licenciada__c, Descuento_porc__c, Descuento__c, Desconto_Total_Unidade__c From OpportunityLineItem Where OpportunityId In : oppIds];
                      
            sapAltaAnticipo.Z_FI_ALTA_ANTICIPOS soap = new sapAltaAnticipo.Z_FI_ALTA_ANTICIPOS();
                                                            
            RetCabecera rett = crearCab(o, parEtapa);            
      
            if(rett.ret)
                TCab = rett.TCab;
            else{
                r.msg += rett.msg;
                r.ret = false;
                return r;
            }
            
            /*
            for(OpportunityLineItem i : OppIts){
                String value = i.Id;
                itemMap.put(value, i);
            }
        
            String campania = '';
            */
                                   
            RetCabecera retp = crearPos(o, rett.mapCabeceras);  
            
            if(retp.ret){
                TPos = retp.TPos;
            }
            else{
            
                r.msg += retp.msg;              
                r.ret = false;
                return r;
            }                                                           
                        
            if(TCab == null || TPos == null){
                r.msg += 'Cabecera o Posicion Nula\n'; // + OppIts.get(0).Id;
                r.ret = false; return r;
            }
                        
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
        
            String myData = 'SALESFORCEBR:2o21gdms33dS';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                      
            String tar = String.valueOf(target); 
            system.debug('SET DE DATOS:  CABECERA: ' + TCab + ' POSICIONES: ' + TPos);                                      
            
            resultado = soap.ZFiAltaAnticipos(resultado, '', TCab, TPos, tar);
            
            Map<String,String> mensajeResultado = New Map<String,String>();
            Integer i;         
            for (i=0;i<resultado.item.size();i++)
                //if (!mensajeResultado.containsKey(resultado.item[i].Id)){
                    mensajeResultado.put(resultado.item[i].Id, resultado.item[i].Mensaje);
                //}else{
                //    String mens = mensajeResultado.get(resultado.item[i].Id);
                //    mens += ' -- ' + resultado.item[i].Mensaje;
                //    mensajeResultado.put(resultado.item[i].Id, mens);
                //}
            
            for (Opportunity o2: o){ 
                //o2.Nro_Pedido_SAP__c = mensajeResultado.get(rett.mapCabeceras.get(o2.Id)).Anticipo;
                o2.Observaciones_Paso_a_SAP__c = mensajeResultado.get(rett.mapCabeceras.get(o2.Id));
            }    
                        
            update o;            
            return r;                                      
            
        }catch(System.CalloutException ex) {
            r.msg = '\nEn altaNVSAP - CallOutException: ' + ex.getMessage(); r.ret = false; 
            
            r.ret=false;                       
        
        }catch(System.Exception ex) {
            r.msg = '\nEn altaNVSAP - CallException: ' + ex.getMessage(); r.ret = false; 
            
            r.ret=false;                       
        }                
        
        return r;
    }
    
    public static RetCabecera crearCab(List<Opportunity> o, String parEtapa){
        RetCabecera retCabe = new RetCabecera();
        Map<String,String> mapCabeceras = New Map<String,String>();
        String step = 'Inicio';
        retCabe.msg = '\n';
        try{
            Integer i = 1;
            sapAltaAnticipo.ZtfiCabeceraAnticipo TCab = New sapAltaAnticipo.ZtfiCabeceraAnticipo();
            TCab.item = new List<sapAltaAnticipo.ZsfiCabeceraAnticipo>();
            for(Opportunity o2 : o){
                sapAltaAnticipo.ZsfiCabeceraAnticipo ICab = new sapAltaAnticipo.ZsfiCabeceraAnticipo();
                
                //Varios
                ICab.Id = String.valueOf(i);
                ICab.Xblnr = o2.Name;
                ICab.Blart = 'DA';
                        
                //Organización de Ventas
                ICab.Bukrs = '01BR';   
                            
                step = 'Fechas';
            
                //Fechas varias            
                ICab.Budat = String.valueOf(o2.CloseDate).substring(0,10);            
                ICab.Bldat = String.valueOf(o2.CloseDate).substring(0,10);
            
                if(o2.Safra__c != null)
                    ICab.Gjahr = '20' + o2.Safra__c.substring(3,5);                                                                                   
                            
                mapCabeceras.put(o2.Id, String.valueOf(i));
                TCab.item.add(ICab);            
                
                i++;
            }
            retCabe.TCab = TCab;
            retCabe.mapCabeceras = mapCabeceras;
            retCabe.ret = true;
            
        }
        catch(Exception e){
            retCabe.ret = false;
            retCabe.msg += 'Detalle: ' + step + '\nError: ' + e.getMessage();
            System.debug('Detalle: ' + step + '\nError: ' + e.getMessage());
        }
        return retCabe;
    }
    
    public static RetCabecera crearPos(List<Opportunity> opps, Map<String,String> mapCabeceras){
        RetCabecera retPos = new RetCabecera();
        Map<String,Product2> oppItMap = new Map<String,Product2>();       
        String step = '';        
        Integer index = 0;
        
        try{
          step='CrearPos 1';                       
            sapAltaAnticipo.ZtfiPosicionAnticipo TPos = new sapAltaAnticipo.ZtfiPosicionAnticipo();
            TPos.item = new List<sapAltaAnticipo.ZsfiPosicionAnticipo>();//BORRAR
            
            //for(OpportunityLineItem i : OppIts)                
            //    oppItMap.put(i.Id, i.PricebookEntry.Product2);            
                        
            for(Opportunity o : opps){
                sapAltaAnticipo.ZsfiPosicionAnticipo IPos = new sapAltaAnticipo.ZsfiPosicionAnticipo();
                
                IPos.Id = mapCabeceras.get(o.Id);
                IPos.Buzei = '001';  
                IPos.Koart = 'D';
                IPos.Shkzg = 'S';
                IPos.Umskz = 'A';
                IPos.Zuonr = 'ANTEC ' + o.Safra__c + ' ' + o.Marca__c;
                IPos.Kunnr = o.Account.CodigoSAP__c;                
                IPos.Zfbdt = String.valueOf(o.Vencimiento_Anexo__c).substring(0,10); 
                IPos.Sgtxt = 'Antecipaçõe OP.' + o.Name;
                IPos.Rtcur = 'BRL';
                IPos.Wrbtr = String.valueOf(o.Total_VL_Liquido__c);
                IPos.Waers = 'BRL';
                IPos.Dmbtr = String.valueOf(o.Total_VL_Liquido__c);
                                                
                TPos.item.add(IPos);
                
                index++;
            }
            retPos.TPos = TPos;
            retPos.ret = true;
            return retPos;
        
        }catch(Exception e){
                    
            retPos.ret = false;
            retPos.msg = e.getMessage();
            System.debug('Detalle: ' + step + '\nError: ' + e.getMessage() + e.getlinenumber());
            return retPos;
        }
    }    
    
    static Boolean setEtapaAU(Opportunity o){
       String st_PE = 'PE - Pendiente';
       String st_AU = 'AU - Autorizada';
       String rt_AU = rty.get('Antecipação Autorizada');
       String rt_PE = rty.get('Antecipação Pendente');
       
       if (o.RecordTypeId == rt_PE && o.StageName == st_PE){    
          o.StageName = st_AU;
          o.RecordTypeId = rt_AU;
          return true;
       }
       return false;
    }      
       
}
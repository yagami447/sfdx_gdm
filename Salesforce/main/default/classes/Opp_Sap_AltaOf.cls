global class Opp_Sap_AltaOf {
    public static boolean isTest = false;
    private static Map<String,Id> rty;
    
    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        Webservice String oferta;
        Webservice String relPos;
    }
    private class RetCabecera{
        String msg;                      
        sapAltaOf.ZssdOfertaCab cab; 
        sapAltaOf.ZssdOfertaPosTab TPos; //ZssdOfertaPosTab TPos;
        sapAltaOf.ZssdOfertaCondTab TCond;        
        Boolean ret;
    }
    WebService static Retorno enviarSAP(Id oppId, String etapa, Integer target){    
        Retorno r = new Retorno();
        Retorno r1 = new Retorno();
        rty = Opp_Utils.cargarRecordTypesOportunidades();
        r.msg = '\n';
        try
        {
            Opportunity o = [Select Id, PE_Bajar_SAP__c, AccountId From Opportunity Where Id = :oppId];            
            r = estaEnSAP(o.AccountId);            
            if(r.ret){
               r = altaOFs(o.Id, etapa, target);
               o.PE_Bajar_SAP__c = false;
            }else{
                  r.msg += '\nEl cliente no existe en SAP.\nLa Oferta queda Pendiente para bajar.';
                  o.Observaciones_Paso_a_SAP__c = r.msg; r.ret = false; o.PE_Bajar_SAP__c = true;
                  update o;
            }
        }
        catch(Exception e)
        {
            r.msg = 'En EnviarSAP - Error: ' + e.getMessage() + '-' +e.getLineNumber(); r.ret = false;
        }
        return r;
    }
    
    static Retorno estaEnSAP(Id id){
        Retorno r = new Retorno();
        String step = 'estaEnSAP 1';
        try{
            
            if(id != null){
                Account a = [Select Id, esta_en_SAP__c, CodigoSAP__c From Account Where Id = :id];                
                if(a != null){
                    if(a.CodigoSAP__c != null){ r.msg = 'La cuenta existe en SAP'; r.ret = true;}
                    else{ r.msg = 'La cuenta no existe en SAP'; r.ret = false;}
                }
                else{ r.msg = 'La cuenta es nula'; r.ret = false;}
            }
            else{ r.msg = 'El Id de parametro es nulo'; r.ret = false;}
        }
        catch(Exception e){
            r.msg = e.getMessage() + ' ' + step  + '-' +e.getLineNumber(); r.ret = false;
        }
        return r;
    }
    
    static Retorno altaOFs(Id opId, String etapa, Integer target){
        
        String[] retornoOferta = New String[2];               
        Retorno r = new Retorno(); r.ret = true;
        Opportunity o = [Select Nro_Pedido_SAP__c, Safra__c, Id, PE_bajar_SAP__c, OwnerId, Owner.Alias, Name, AccountId, Account.CodigoSAP__c, Account.Region__r.Oficina_Ventas__c, Account.Responsavel__c, CloseDate, RecordTypeId, StageName, Tipo_de_Cambio__c, Condicion_de_Pago__c, Sucursal__c, Tipo__c, Pedido_Relacionado__c, Motivo_de_Pedido__c, Account.Grupo_de_cuentas__c, Origen__r.Codigo_SAP__c, Destinatario_de_Mercaderia__r.Codigo_SAP__c, Marca__c, Responsable__c, Owner.Codigo_SAP__c, Owner.Profile.Name, Invierno__c, RecordType.Name, Region__c, Bloqueo__c From Opportunity Where Id = :opId];        
        r.msg = '\nInicio: altaOFs';
        try{            
            
                Retorno rsap = altaOFSAP(o, etapa, '', target);
                if((rsap.ret && rsap.oferta != null && rsap.oferta != '') || (rsap.msg.contains('Existe la Oferta de Venta'))){
                    System.debug('ENTRO1');
                    r.ret = true;
                    o.PE_Bajar_SAP__c = false; o.Nro_Pedido_SAP__c = rsap.oferta; o.Observaciones_Paso_a_SAP__c = rsap.msg; String tipo = o.Tipo__c.substring(0,4);
                    if(!setEtapaAU(o)){ r.msg = 'Mala Etapa'; r.ret = false;}

                    if (rsap.msg.contains('Existe la Oferta de Venta')){
                       Pattern p = Pattern.compile('[a-zA-Z]');
                       o.Nro_Pedido_SAP__c = p.matcher(rsap.msg.substring(0,40)).replaceAll('').trim();
                       
                       String nro_oferta = o.Nro_Pedido_SAP__c;
                       Integer long_nro_oferta = o.Nro_Pedido_SAP__c.length();
                       Integer ceros_agregar = 10 - long_nro_oferta;
                       String ceros = ''; Integer i;
                       for (i=0;i<ceros_agregar;i++) ceros += '0';
                       
                       o.Nro_Pedido_SAP__c = ceros + o.Nro_Pedido_SAP__c; o.Observaciones_Paso_a_SAP__c = 'BR - ' + nro_oferta + ' se ha grabado';                          
                    }
                    //System.debug('ACTUALIZA RECORDTYPE!');
                    String rt_VBAU = rty.get('VB - Autorizada'); String rt_VBFA = rty.get('VB - Pasada SAP');
                    if(o.RecordTypeId == rt_VBAU){ o.RecordTypeId = rt_VBFA; o.StageName = 'AU - Autorizada';}  
                      //System.debug('ACTUALIZA RECORDTYPE2!');
                      //System.debug('ACTUALIZA RECORDTYPE3!');
                }
                else{ o.Observaciones_Paso_a_SAP__c = rsap.msg; r.ret = false;}
                r.msg = rsap.msg;
        }
        catch(Exception e){
            r.msg = 'En altaOFs - Error: ' + e.getMessage() + '-' +e.getLineNumber(); r.ret = false;
        }
        
        try{
          update o;
        }
        catch(DMLException e){
            r.msg = 'En altaOFs - Error: ' + e.getMessage()  + '-' +e.getLineNumber(); r.ret = false;
        }        
        return r;
    }
    
    public static Retorno altaOFSAP(Opportunity o, String parEtapa, String clienteSAP, Integer target){
        sapAltaOf.ZSdAltaOfertaResponse_element resultado;
        Retorno r = new Retorno();        
        List<OpportunityLineItem> OppIts = new List<OpportunityLineItem>();
        Map<String,OpportunityLineItem> itemMap = new Map<String,OpportunityLineItem>();
        Boolean vBasica = false; 
        sapAltaOf.ZssdOfertaPosTab TPos; //ZssdOfertaPosTab TPos;
        sapAltaOf.ZssdOfertaCondTab TCond;
        sapAltaOf.ZssdOfertaCab ICab;
        
        r.ret = true;
        r.msg = '\n';
                
        try{
            OppIts = [Select Id, TMP_Observaciones__c, Posicion_SAP__c, Quantity, PricebookEntryId, PricebookEntry.Product2.Name, PricebookEntry.Product2.Codigo_material_SAP__c, PriceBookEntry.Product2.Licenciada__c, PriceBookEntry.Product2.Sector__c, UnitPrice, PriceBookEntry.UnitPrice, Contrato_Relacionado__c, Contrato_Relacionado__r.Name, Posicion_SAP_Relacionada__c, Tasas__c, Observaciones_Tasas__c, Precio_SAP__c, Base_de_Calculo__c, Precio_Liquido__c, PriceBookEntry.Product2.Family, Precio_Contrato__c, PricebookEntry.Product2.Variedade__c, Categoria__c, Precio_SAP_Estimado__c, PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c, Tratamiento_de_Semilla__c, Precio_Bolsa__c, Motivo_de_Rechazo__c, Grupo_de_materiales_2__c, PricebookEntry.Product2.Variedade__r.Licenciada__c From OpportunityLineItem Where OpportunityId = : o.Id]; //Peneira__c,   , Grupo_de_materiales_2__c         
                      
            sapAltaOf.Z_SD_ALTA_OFERTA soap = new sapAltaOf.Z_SD_ALTA_OFERTA();
            
            RetCabecera rett = crearCab(o, OppIts.get(0), parEtapa, vBasica);            

            if(rett.ret)
                ICab = rett.cab;
            else{
                r.msg += rett.msg;
                r.ret = false;
                if(!Test.isRunningTest()) return r;
            }
            
            for(OpportunityLineItem i : OppIts){
                String value = i.Id;
                itemMap.put(value, i);
            }
        
            String campania = '';
                        
            String sucursal = ''; 
            Decimal tipo_cambio = 0;
            String tipo_cuenta = '';
            sucursal = o.Sucursal__c;
            tipo_cambio = o.Tipo_de_Cambio__c;
            campania = o.Safra__c;
            tipo_cuenta = o.Account.Grupo_de_cuentas__c;   
            
            String tipoNV = o.Tipo__c.substring(0,4);          
            //if()                
            RetCabecera retp = crearPos(OppIts, sucursal, campania, tipoNV, o, vBasica);  
            
            if(retp.ret){
                TPos = retp.TPos;
            }
            else{
            
                r.msg += retp.msg;              
                r.ret = false;
                if(!Test.isRunningTest()) return r;
            }                                                           
           
            RetCabecera retc = crearConds(OppIts, tipoNV, tipo_cambio, ICab.VKBUR, tipo_cuenta, vBasica, o.Invierno__c);            
            if(retc.ret){
                TCond = retc.TCond;             
                //r.msg += retc.msg;
            }
            else{
                r.msg += retc.msg;              
                r.ret = false;
                if(!Test.isRunningTest()) return r;
            }

            if(ICab == null || TPos == null || TCond == null){
                r.msg += 'Cabecera, Condicion o Posicion Nula\n' + OppIts.get(0).Id;
                r.ret = false; if(!Test.isRunningTest()) return r;
            }
               
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
        
            String myData = 'SALESFORCE:2o21gdms33dS';
            //String myData = 'SROMERO:06Santi';
            //String myData = 'pruebajk:Soporte02';
            
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                      
            String tar = String.valueOf(target);      
            system.debug('SET DE DATOS: CABECERA: ' + ICab + ' POSICIONES: ' + TPos + ' CONDICIONES: ' + TCond);                   
            resultado = soap.ZSdAltaOferta(ICab, TCond, TPos, tar);
                       
            Integer i;         
            for (i=0;i<resultado.EtReturn.item.size();i++)
               r.msg += resultado.EtReturn.item[i].Message;
            if (resultado.EpSubrc == 0){               
               r.oferta = String.valueOf(resultado.EpNroPedido);
               r.ret = true;
               
               for (Integer j=0;j<resultado.EtRelPos.item.size();j++)
                   if(itemMap.containsKey(resultado.EtRelPos.item[j].Zzpossf)){
                       OpportunityLineItem ii = itemMap.get(resultado.EtRelPos.item[j].Zzpossf);
                       if(ii != null)
                           ii.Posicion_SAP__c = resultado.EtRelPos.item[j].Posnr;
                   }
                   
               }else{
                  r.msg += 'La OF no paso a SAP. ';
                  r.ret = false;                                
            }   
            
            update OppIts;
            if(!Test.isRunningTest()) return r;                                     
            
        }catch(System.CalloutException ex) {
            r.msg = '\nEn altaOFSAP - CallOutException: ' + ex.getMessage() + '-' +ex.getLineNumber(); r.ret = false; 
            o.Observaciones_Paso_a_SAP__c = r.msg.Left(255);
            update o;

            r.ret=false; 
            return r;                      
        
        }catch(System.Exception ex) {
            r.msg = '\nEn altaOFSAP - CallException: ' + ex.getMessage() + '-' +ex.getLineNumber(); r.ret = false; 
            o.Observaciones_Paso_a_SAP__c = r.msg;
            update o;
            r.ret=false;  
            return r;                     
        }
        
        
        /////////////////////////////////////////////BORRAR
        sapAltaOf.Bapiret2Tab mensajes;
        try{
            if(resultado != null){                
                mensajes = resultado.EtReturn;
                String tmsg = '';
                if(Integer.valueOf(mensajes.item[1]) == 0){
                    String nroOferta = resultado.EpNroPedido;
                    String res = '000000000';                   
                    if(nroOferta == ''){
                        tmsg = string.valueOf(mensajes.item[1]);
                        res += tmsg.split('Oferta')[1].split('creada')[0].trim();
                        nroOferta = res.substring(res.length()-10, res.length());
                    }
                    if(nroOferta != ''){
                        r.ret = true;
                        r.oferta = nroOferta;                                            
                        r.msg += '\nExito!!!';
                    }
                    else{r.msg += '\nFalta Nro de Oferta - La Oferta queda pendiente de descargar'; r.ret = false;}
                }else{r.msg += '\nError - No se actualizo SAP - La Oferta queda pendiente de descargar'; r.ret = false;}
            }else{r.msg += '\nError - SAP no retorno ningun mensaje de exito - La Oferta queda pendiente de descargar'; r.ret = false; }
        }        
        catch(Exception e){
            r.msg = 'En altaOFSAP - Exception: ' + resultado + '\n' + e.getMessage() + '-' +e.getLineNumber() + '\n' + resultado; r.ret = false;
        }
        
        /////////////////////////////////////////////////////////////////////////BORRAR
 
                
        try{
            Integer j = 0;
            for(OpportunityLineItem i : OppIts){
                if(TPos == null) continue;              
                sapAltaOf.ZssdOfertaPos IPos2 = TPos.item[j]; //ZssdOfertaPos IPos2 = TPos.item[j];
                if(IPos2 == null) continue;
                i.ZZPOSSF__c = IPos2.ZZPOSSF;
                i.WERKS__c = IPos2.WERKS;
                i.KWMENG__c = String.valueOf(IPos2.KWMENG);
                i.AUFNR__c = IPos2.AUFNR;
                i.MVGR1__c = IPos2.MVGR1;
                i.VRKME__c = IPos2.VRKME;
                i.MATNR__c = IPos2.MATNR;
                i.METODO__c = 'ALTA';
                j++;
            }
        }
        catch(System.Exception ex) {
            r.msg += '\nEn agregado - Exception: ' + ex.getMessage() + '-' +ex.getLineNumber(); r.ret = false;
        }
        
        update OppIts;
        return r;
    }
    
    public static RetCabecera crearCab(Opportunity o, OpportunityLineItem i, String parEtapa, Boolean vBas){
        RetCabecera retCabe = new RetCabecera();
        String step = 'Inicio';
        retCabe.msg = '\n';
        try{
            sapAltaOf.ZssdOfertaCab ICab = new sapAltaOf.ZssdOfertaCab();

            //Varios
            ICab.ZZIDSF = o.Id;
            ICab.ZZNROSF = o.Name.left(15);
            String tipo = o.Tipo__c.substring(0,4);
            
            //Moneda
            ICab.WAERK = 'BRL';
            if ((tipo == 'ZBEX' || o.Account.Grupo_de_cuentas__c == 'CMEX') && !vBas)
                ICab.WAERK = 'USD';
            //Organización de Ventas
            ICab.VKORG = '01BR';   
           if((tipo == 'ZBVN' || tipo == 'ZBFA' || tipo == 'ZBSR' || tipo == 'ZBSE' || tipo == 'ZBNC') && o.Invierno__c == true && o.Owner.Profile.Name == 'Administrativo_licencias')
              ICab.VKORG = 'MBAS';
            ICab.VALDT='';
            step = 'Bloqueos';
            ICab.ABGRU = '';
            ICab.BSTKD = o.Name.left(15);
                        
            step = 'Clientes';
            
            //Cuentas de Cliente y Distribuidor
            if(o.Destinatario_de_Mercaderia__r.Codigo_SAP__c != null)
              ICab.KUNWE = o.Destinatario_de_Mercaderia__r.Codigo_SAP__c.trim();
            else
              ICab.KUNWE = o.Account.CodigoSAP__c.trim();
                        
            Icab.KUNAG = o.Account.CodigoSAP__c.trim();
            
            step = 'Fechas';
            
            //Fechas varias            
            ICab.AUDAT = String.valueOf(o.CloseDate).substring(0,10);
            //ICab.BNDDT = String.valueOf(o.CloseDate).substring(0,10);
            ICab.BNDDT = '';
            //ICab.ANGDT = String.valueOf(o.CloseDate).substring(0,10);
            ICab.ANGDT = String.valueOf(system.today()).substring(0,10);            
            if(o.Safra__c != null)
              ICab.Zzcampana = o.Safra__c.substring(0,2) + '/20' + o.Safra__c.substring(3,5);                                               
            
            //Numero de documento modelo solo para toma consig.
            
            step = 'Pago Especie';
            
            //Motivo de pedido, solo para CANJE o ESPECIE
                                 
                      
            step = 'Incoterms';
                      
            //Datos incoterms, solo exportacion
            ICab.INCO2 = '';                                    

            //Grupo de condiciones de clientes, Solo CEREAL
            System.debug('Mensaje 1');            
            If (tipo != 'ZBNC'){
                //Sector de Ventas y Canal de distribucion
                ICab.VTWEG = '01';
                //if (tipo == 'ZBSE' || tipo == 'ZBEX')
                if (o.Account.Grupo_de_cuentas__c == 'CMEX' || tipo == 'ZBEX')
                    ICab.VTWEG = '04';
                if(i.PricebookEntry.Product2.Licenciada__c)
                    ICab.VTWEG = '07';
                ICab.SPART = i.PricebookEntry.Product2.Sector__c;
                step = 'Incoterms 1';
                //Condicion de Pago
                ICab.ZTERM=o.Condicion_de_Pago__c.substring(0,4);
                step = 'Incoterms 2';
                if(o.Condicion_de_Pago__c.substring(0,4) == 'ZC68'){
                  if(o.RecordType.Name == 'VB - Autorizada'){ICab.VALDT='20' + o.Safra__c.substring(3) + '-12-15';}
                  else{ICab.VALDT='20' + o.Safra__c.substring(3) + '-12-15';}
                }
                //Grupo de Vendedores
                //if((tipo == 'ZBVN' || tipo == 'ZBFA' || tipo == 'ZBSR' || tipo == 'ZBEX') && o.Owner.Codigo_SAP__c != null && o.Owner.Codigo_SAP__c != '')
                
                if(o.Owner.Codigo_SAP__c != null && o.Owner.Codigo_SAP__c != '')
                  ICab.VKGRP=o.Owner.Codigo_SAP__c;
                else
                  ICab.VKGRP=o.Account.Responsavel__c.substring(0,3);
//                if(i.PricebookEntry.Product2.Licenciada__c && i.PricebookEntry.Product2.Family == 'Royalty x Basica')
//                    ICab.VKGRP = '065';
                
                //ICab.VKBUR = 'BR01';
                ICab.VKBUR = 'B001'; //--> Nueva estructura comercial
                if(o.Account.Region__r.Oficina_Ventas__c != null) ICab.VKBUR = o.Account.Region__r.Oficina_Ventas__c.trim();
                //COMENTADO 13/10/2015. CON PREG POR LICENCIADA ALCANZA. SE CAMBIA A PREGUNTAR POR LA VARIEDAD RELACIONADA --> if(i.PricebookEntry.Product2.Licenciada__c && (i.PricebookEntry.Product2.Family == 'Semilla' || i.PricebookEntry.Product2.Family == 'Royalty x Basica' || i.PricebookEntry.Product2.Family == 'Royalty x C-S'))
                if(i.PricebookEntry.Product2.Variedade__r.Licenciada__c){
                    ICab.VKGRP = '095';
                    ICab.VKBUR = 'B000';
                }                
                if(o.Account.Grupo_de_cuentas__c == 'CMEX')
                    ICab.VKBUR = 'B004';
                //}else{
                  //Oficina de Ventas
                  //if (o.Sucursal__c.substring(0,4) == '0094')
                    // ICab.VKBUR = 'BR01';
                 
                  //if (o.Sucursal__c.substring(0,4) == '0095')
                    // ICab.VKBUR = 'BR02';
                  //}
            }else{
              step = 'Incoterms NC 0';
                if (o.Pedido_Relacionado__c != null){
                    Opportunity op_aux = [Select Nro_Pedido_SAP__c, Sector__c, Canal_de_Distribucion__c, Condicion_de_Pago__c, Account.Responsavel__c, Sucursal__c, Owner.Codigo_SAP__c, Owner.Profile.Name, Invierno__c From Opportunity Where Id = : o.Pedido_Relacionado__c];
                    step = 'Incoterms NC 1';
                    ICab.SPART = op_aux.Sector__c;
                    ICab.VTWEG = op_aux.Canal_de_Distribucion__c;
                    //ICab.ZTERM = op_aux.Condicion_de_Pago__c.substring(0,4);
                    ICab.ZTERM=o.Condicion_de_Pago__c.substring(0,4);
                    
                    step = 'Incoterms NC 2';
                    if(op_aux.Owner.Codigo_SAP__c != null && op_aux.Owner.Codigo_SAP__c != '')
                      ICab.VKGRP = op_aux.Owner.Codigo_SAP__c;
                    else
                      ICab.VKGRP = op_aux.Account.Responsavel__c.substring(0,3);
                    
                    step = 'Incoterms NC 3';
                    
                    ICab.VKBUR = 'B001'; //--> Nueva estructura comercial
                if(o.Account.Region__r.Oficina_Ventas__c != null) ICab.VKBUR = o.Account.Region__r.Oficina_Ventas__c.trim();
                  /*if(op_aux.Origen__r.Codigo_SAP_Oficina__c != null){
                    ICab.VKBUR = op_aux.Origen__r.Codigo_SAP_Oficina__c.trim();
                  }else{
                    //Oficina de Ventas
                    if (op_aux.Sucursal__c.substring(0,4) == '0094')
                       ICab.VKBUR = 'BR01';
                   
                    if (op_aux.Sucursal__c.substring(0,4) == '0095')
                       ICab.VKBUR = 'BR02';
                  }*/
                    //ICab.VGBEL = String.valueOf(Integer.valueOf(op_aux.Nro_Pedido_SAP__c));
                    step = 'Incoterms NC 4';        
                    //ICab.VGBEL = op_aux.Nro_Pedido_SAP__c;  
                    //ICab.AUGRU = o.Motivo_de_Pedido__c.substring(0,2);      
                }
            }                                       
            step = 'Sector';
            o.Sector__c = ICab.SPART;
            o.Canal_de_Distribucion__c = ICab.VTWEG;                                
            step = 'Clase de DOC';
            //Clase de documento de ventas
            ICab.AUART = tipo;
            ICab.FAKSK = '';
            //ICab.LIFSK = 'Z1';
            ICab.LIFSK = o.Bloqueo__c.substring(0,2); 
            //////21/07/2014.AGREGADO POR JUAN. INICIO
            //if (o.Marca__c == 'DSEM')
                //ICab.VKBUR = 'BR05';                                                  
            //////21/07/2014.AGREGADO POR JUAN. FIN
            System.debug('Mensaje 3');
            retCabe.ret = true;
            retCabe.cab = ICab;
            
        }
        catch(Exception e){
            retCabe.ret = false;
            retCabe.msg += 'Detalle: ' + step + '\nError: ' + e.getMessage() + '-' +e.getLineNumber();
            System.debug('Detalle: ' + step + '\nError: ' + e.getMessage() + '-' +e.getLineNumber());
        }
        return retCabe;
    }
    
    public static RetCabecera crearPos(List<OpportunityLineItem> OppIts, String sucursal, String campania, String tipoNV, Opportunity o, Boolean vBas){
        RetCabecera retPos = new RetCabecera();
        Map<String,Product2> oppItMap = new Map<String,Product2>();       
        String step = '';        
        Integer index = 0;
        
        try{
          step='CrearPos 1';                       
            sapAltaOf.ZssdOfertaPosTab TPos = new sapAltaOf.ZssdOfertaPosTab();
            TPos.item = new List<sapAltaOf.ZssdOfertaPos>();//BORRAR
            
            for(OpportunityLineItem i : OppIts)                
                oppItMap.put(i.Id, i.PricebookEntry.Product2);            
                        
            for(OpportunityLineItem i : OppIts){
                sapAltaOf.ZssdOfertaPos IPos = new sapAltaOf.ZssdOfertaPos();
                
                IPos.ZZPOSSF = i.Id;
                
                step='CrearPos 2';
                IPos.WERKS = 'BD01';               
               // if(o.Origen__r.Codigo_SAP__c != null) IPos.WERKS = o.Origen__r.Codigo_SAP__c.trim();
                step='CrearPos 3';
                //Cantidad del pedido
                IPos.KWMENG = String.valueOf(i.Quantity);                
                
                //Orden de CO                
                IPos.AUFNR = 'VTA';
        //if((tipo == 'ZBVN' || tipo == 'ZBFA') && o.Marca__c != null){
              //    for(Centro_de_CO_Item__c centro : [Select c.Centro_de_CO__c, c.Id, c.Name, c.Producto__c, Centro_de_CO__r.Orden__c from Centro_de_CO_Item__c c  Where c.Centro_de_CO__r.Sociedad__c = :o.Marca__c and c.Centro_de_CO__r.Campania__c = :campania And c.producto__c = :oppItMap.get(i.Id).Id])
              //        IPos.AUFNR = centro.Centro_de_CO__r.Orden__c;          
        //}else{
                  for(Centro_de_CO_Item__c centro : [Select c.Centro_de_CO__c, c.Id, c.Name, c.Producto__c, Centro_de_CO__r.Orden__c from Centro_de_CO_Item__c c  Where c.Centro_de_CO__r.Sociedad__c = :o.Marca__c and c.Centro_de_CO__r.Campania__c = :campania And c.producto__c = :oppItMap.get(i.Id).Id AND c.Centro_de_CO__r.Region__c = :o.Region__c])
                      IPos.AUFNR = centro.Centro_de_CO__r.Orden__c;
        //}
                //Calibre, Grupo de materiales 1
                IPos.MVGR1 = '';
                //Banda de Calibre, Grupo de materiales 2
                IPos.MVGR2 = '';
                if(i.Grupo_de_materiales_2__c != null && i.Grupo_de_materiales_2__c != '') IPos.MVGR2 = i.Grupo_de_materiales_2__c;
                index++;
                //IPos.POSNR = '0000' + String.ValueOf(index) + '0';
                IPos.POSNR = '';
                //IPos.ABGRU = 'Z2';
                if (i.Motivo_de_Rechazo__c != null)
                    IPos.ABGRU = i.Motivo_de_Rechazo__c.substring(0,2);
                IPos.MVGR4 = '';
                if(i.Tratamiento_de_Semilla__c != null && i.Tratamiento_de_Semilla__c != '') IPos.MVGR4 = i.Tratamiento_de_Semilla__c.substring(0,3);
                //Unidad de medida de venta, se reemplaza por el de las condiciones
                IPos.VRKME = '';
                
                //Codigo de material de SAP, sale del producto Codigo.
                IPos.MATNR = oppItMap.get(i.Id).Codigo_material_SAP__c;
                IPos.LGORT = '';
                IPos.VSTEL = '';
                                
                TPos.item.add(IPos);
                
                
            }
            retPos.TPos = TPos;
            retPos.ret = true;
            return retPos;
        
        }catch(Exception e){
                    
            retPos.ret = false;
            retPos.msg = e.getMessage() + '-' +e.getLineNumber();
            System.debug('Detalle: ' + step + '\nError: ' + e.getMessage() + '-' +e.getLineNumber());
            return retPos;
        }
    }
    
    public static RetCabecera crearConds(List<OpportunityLineItem> OppIts, String tipo, Decimal Tipo_de_Cambio, String ofiVentas, String tipo_cuenta, Boolean vBas, Boolean inv){
        RetCabecera retPos = new RetCabecera();
        Integer index = 0;
        String step = '';       
        try{
          step='CrearConds 1';            
            sapAltaOf.ZssdOfertaCondTab TCond = new sapAltaOf.ZssdOfertaCondTab();
            TCond.item = new List<sapAltaOf.ZssdOfertaCond>();

            for(OpportunityLineItem i : OppIts){
              step='CrearConds 2';
              // Tema precios está complicado. Validar con Cecilia, Juan y Santiago.
                                  
                step='CrearConds 3';
                Decimal ZPRN = 0.0;
                //Double com = i.UnitPrice; 
                Double com = i.Precio_Bolsa__c;                              
                
                ZPRN = Decimal.valueOf(com);
                ZPRN = ZPRN.divide(1, 2, System.RoundingMode.HALF_EVEN);
                
                //i.UnitPrice = ZPRN;  
                i.Precio_SAP__c = ZPRN;              
                                
                sapAltaOf.ZssdOfertaCond ICond1 = new sapAltaOf.ZssdOfertaCond();
                ICond1.ZZPOSSF = i.Id;
                
                //String tipo_aux = tipo;
                //if (tipo_p_rel != '')
                //   tipo_aux = tipo_p_rel;
                   
                ICond1.KSCHL = 'ZPRE';
                //////ESTAS DOS LINEAS DE ABAJO LAS COMENTO JUAN EL 18/07/2014
                //if (tipo_cuenta == 'CMEX' && !vBas) 
                //    ICond1.KSCHL = 'ZBRU';
                                    
                ICond1.Kbetr = String.valueOf(ZPRN);
                    

                //if ((tipo == 'ZBVN' || tipo == 'ZBFA' || tipo == 'ZBSR' || (tipo == 'ZBEX' && vBas)) && ICond1.KSCHL == 'ZPRE' ){
                    //step='CrearConds 5';
                    //Decimal precioLiquido = i.Precio_Liquido__c;                                                                                 
                    //precioLiquido = precioLiquido.divide(1, 2, System.RoundingMode.HALF_EVEN);
                    
                    //i.Precio_SAP__c = precioLiquido;
                                        
                    //ICond1.Kbetr = String.valueOf(precioLiquido);
                    //step='CrearConds 6'; 
                //}                   
                ICond1.KMEIN = '';                
                ICond1.Kpein = '1';
                TCond.item.add(ICond1);
            }                                                            
                                               
            retPos.TCond = TCond;
            retPos.ret = true;
            return retPos;
        }
        catch(Exception e){         
            retPos.ret = false;
            retPos.msg = e.getMessage() + '-' +e.getLineNumber();
            System.debug('Detalle: ' + step + '\nError: ' + e.getMessage() + '-' +e.getLineNumber());
            return retPos;
        }
    }
    
    public static String ofiVentas(String canal){
        String valor = '';
        
        if(canal == '01' || canal == '02' || canal == '03' || canal == '05')
            valor = 'LDLO';
        if(canal == '04' || canal == '06')
            valor = 'LDEX';
        if(canal == '07')
            valor = 'LDLI';
        
        //valor = 'LDLO';
        return valor;
    }
            
    static Boolean setEtapaAU(Opportunity o){
       String st_PE = 'PE - Pendiente';
       String st_AU = 'AU - Autorizada';
       String rt_AU = rty.get('Autorizada');
       String rt_PE = rty.get('Pendiente');
       
       if (o.RecordTypeId == rt_PE && o.StageName == st_PE){o.StageName = st_AU; o.RecordTypeId = rt_AU; return true;}
       return false;
    }
    
    @isTest(SeeAllData=true)        
    static void test2() {    
        //////Product2 px1 = new Product2(Name = 'Test 1', tipo__c = 'SEM', Especie__c = 'SOJA');
        Product2 px1 = new Product2(Name = 'Test 1', Especie__c = 'SOJA', Sector__c = '02');//BORRAR
        insert px1;
        //////Product2 px2 = new Product2(Name = 'Test 1', tipo__c = 'SEM', Especie__c = 'TRIGO');
        Product2 px2 = new Product2(Name = 'Test 1', Especie__c = 'TRIGO');//BORRAR
        insert px2;
        
        Pricebook2 s = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px1.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbesx;
        PricebookEntry pbesx2 = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px2.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbesx2;
        
        //////Opportunity o = new Opportunity(Name = 'Test 1', Tipo__c = 'ZPLO - PEDIDO CON PAGO EN ESPECIE', CloseDate = System.today(), StageName = 'Clientes potenciales');
        //BORRAR
        Opportunity o = new Opportunity(Name = 'Test 1', CloseDate = System.today(), StageName = 'Clientes potenciales');
        //BORRAR
        insert o;
        OpportunityLineItem opli1 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 10, quantity = 1);
        insert opli1;
        OpportunityLineItem opli2 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx2.id, unitPrice = 10, quantity = 1); 
        insert opli2;
        
        //////opli1 = [select id, quantity, unitPrice, pricebookentry.product2.tipo__c, pricebookentry.product2.especie__c, pricebookentry.product2.UNIDAD__C from OpportunityLineItem where id = :opli1.id];
        //////opli2 = [select id, quantity, unitPrice, pricebookentry.product2.tipo__c, pricebookentry.product2.especie__c, pricebookentry.product2.UNIDAD__C from OpportunityLineItem where id = :opli2.id];
        
        //BORRAR
        opli1 = [select id, quantity, unitPrice, pricebookentry.product2.especie__c from OpportunityLineItem where id = :opli1.id];
        opli2 = [select id, quantity, unitPrice, pricebookentry.product2.especie__c from OpportunityLineItem where id = :opli2.id];
        //BORRAR
        
        system.debug('>>> GO!');
        system.debug('>>> RESULT! ' + Opp_SAP_AltaOf.crearPos(new List<OpportunityLineItem>{opli1, opli2}, 'DMAR', 'NONE', 'ZPLO', o, false));
    }
    @isTest(SeeAllData=true)
    static void test3() {
      Test.startTest();
        //////Product2 px1 = new Product2(Name = 'Test 1', tipo__c = 'SEM', Especie__c = 'SOJA');
        Product2 px1 = new Product2(Name = 'Test 1', Especie__c = 'SOJA', Sector__c = '02');//BORRAR
        insert px1;
        //////Product2 px2 = new Product2(Name = 'Test 1', tipo__c = 'SEM', Especie__c = 'TRIGO');
        Product2 px2 = new Product2(Name = 'Test 1', Especie__c = 'TRIGO');//BORRAR
        insert px2;
        
        Pricebook2 s = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px1.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbesx;
        PricebookEntry pbesx2 = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px2.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbesx2;
        
        //////Opportunity o = new Opportunity(Name = 'Test 1', Tipo__c = 'ZPLO - PEDIDO CON PAGO EN ESPECIE', CloseDate = System.today(), StageName = 'Clientes potenciales');
        //BORRAR
        Opportunity o = new Opportunity(Name = 'Test 1', CloseDate = System.today(), StageName = 'Clientes potenciales', Tipo_de_Cambio__c = 1, Sucursal__c = '0095 Londrina', Fecha_fijacion_T_de_cambio__c = System.today(), Condicion_de_Pago__c = 'ZC68 - Anticipado');
        //BORRAR
        insert o;
        OpportunityLineItem opli1 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 1000, quantity = 1);
        //////opli1.PRECIO_NETO__c = 900;
        insert opli1;
        
        //////opli1 = [select id, quantity, unitPrice, Comision_del_Distribuidor__c, AS_Venta_de_Semilla__c, AS_Intereses__c, pricebookentry.product2.tipo__c, pricebookentry.product2.especie__c, pricebookentry.product2.UNIDAD__C from OpportunityLineItem where id = :opli1.id];
        
        //BORRAR
        opli1 = [select id, quantity, unitPrice, pricebookentry.product2.especie__c, pricebookentry.product2.Sector__c from OpportunityLineItem where id = :opli1.id];
        //BORRAR
        
        //////ADM_Opp_SAP_Mod.isTest = true;
        
        Opp_Sap_AltaOf.enviarSAP(o.Id, o.StageName, 110);
        Account acc = New Account(Name='Prueba', Esta_en_sap__c = true, CodigoSap__c = '1234567890', Responsavel__c = '061 - OPEN');
        insert acc;
        o.AccountId = acc.Id;
        update o;
        Opp_Sap_AltaOf.enviarSAP(o.Id, o.StageName, 110);  
        Boolean ok = Opp_Sap_AltaOf.setEtapaAU(o);      
        system.debug('>>> GO!');
        system.debug('>>> RESULT! ' + Opp_SAP_AltaOf.crearConds(new List<OpportunityLineItem>{opli1}, 'XXX', o.Tipo_de_Cambio__c, 'BR01', 'ZBSE', false, false));
        
        Opp_SAP_AltaOf.crearConds(new List<OpportunityLineItem>{opli1}, 'XXX', o.Tipo_de_Cambio__c, 'BR02', 'ZBSE', false, false);
        
        Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
        RecordType rt_prev = [Select Id From RecordType Where Name = 'Previsao' And SObjectType = 'Opportunity' limit 1];
        RecordType rt_VBAU = [Select Id From RecordType Where Name = 'CVB Pendiente' And SObjectType = 'Opportunity' limit 1];
        Account cuenta = [Select Id From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
        //Contact dest = [Select Id FROM Contact WHERE AccountId= :cuenta.Id AND Codigo_SAP__c = '0002027525' limit 1];
        Contact dest = [Select Id, Name, Codigo_SAP__c FROM Contact WHERE AccountId = :cuenta.Id AND Name='ACME1' AND Codigo_SAP__c = '0002027525' limit 1];
      
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Centro_Logistico__c cl = [Select Id, Estado__r.Id FROM Centro_Logistico__c WHERE NAme = '0095 - Londrina' limit 1];
    //Contact dest = New Contact(LastName='ACME1', Codigo_SAP__c = '0002027525', AccountId=cuenta.Id, Numero_Calle__c='566',Estado__c = cl.Estado__r.Id);
    //insert dest;
        //Opportunity prevision = New Opportunity(RecordTypeId=rt_prev.Id, Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
    //insert prevision;
    /*Opportunity oppVB = New Opportunity(AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13', Name='Prueba 3',RecordTypeId = rt_VBAU.Id,Tipo__c='ZBVN - Venda Normal', Origen__c=cl.Id, Responsable__c='061 - Fernando Frenher', Condicion_de_Pago__c='ZC68 - A vista - 15 de Dezembro', Destinatario_de_Mercaderia__c =dest.Id);
    insert oppVB;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=oppVB.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi2;
        
        //String[] opVB = previsionesController.generarVenta(prevision.Id, cuenta.Id);
        
        //Opportunity oppVB = [SELECT Id,Name,RecordTypeId,Tipo__c, Origen__c, Responsable__c, Condicion_de_Pago__c, Destinatario_de_Mercaderia__c from Opportunity WHERE Id = :opVB[2]];
        //oppVB.Condicion_de_Pago__c='ZC68 - A vista - 15 de Dezembro';
        //oppVB.Tipo__c='ZBVN - Venda Normal';
        //oppVB.RecordTypeId=rt_VBAU.Id;
        //oppVB.Responsable__c='061 - Fernando Frenher';
        //oppVB.Origen__c=cl.Id;
        //oppVB.Destinatario_de_Mercaderia__c=dest.Id;
        //update oppVB;
        
        Opp_Sap_Alta.setEtapaNC_AU(oppVB);
        
        Opp_Sap_Alta.enviarSAP(oppVB.Id, oppVB.StageName, 110);
        
        Opportunity prevision4 = New Opportunity(Sucursal__c = '0095 Londrina',Condicion_de_Pago__c = 'ZC68 - A vista - 15 de Dezembro', Canal_de_Distribucion__c = '01',Sector__c = '02',Nro_Pedido_SAP__c = '34344',Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
    insert prevision4;
        PricebookEntry pbe4 = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi24 = new OpportunityLineItem(OpportunityId=prevision4.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe4.Id);
        insert oi24;

        oppVB.Pedido_Relacionado__c = prevision4.Id;
        oppVB.Tipo__c = 'ZBNC - Solicit. Nota de Cred.';
        update oppVB;
        Opp_Sap_Alta.enviarSAP(oppVB.Id, oppVB.StageName, 110);*/
        Test.stopTest();
        
    }
    
    @isTest(SeeAllData=true)
    static void test4() {
      
      Account cuenta = [Select Id From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
      Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
      RecordType rt_VBAU = [Select Id From RecordType Where Name = 'CVB Pendiente' And SObjectType = 'Opportunity' limit 1];
      Centro_Logistico__c cl = [Select Id, Estado__r.Id FROM Centro_Logistico__c WHERE NAme = '0095 - Londrina' limit 1];
      Contact dest = [Select Id, Name, Codigo_SAP__c FROM Contact WHERE AccountId = :cuenta.Id AND Name='ACME1' AND Codigo_SAP__c = '0002027525' limit 1];
      Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
      
      Opportunity oppVB = New Opportunity(AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13', Name='Prueba 3',RecordTypeId = rt_VBAU.Id,Tipo__c='ZBVN - Venda Normal', Origen__c=cl.Id, Responsable__c='061 - Fernando Frenher', Condicion_de_Pago__c='ZC68 - A vista - 15 de Dezembro', Destinatario_de_Mercaderia__c =dest.Id);
    insert oppVB;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=oppVB.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi2;
        
        //Opp_Sap_Alta.setEtapaNC_AU(oppVB);
        
        Opp_Sap_AltaOf.enviarSAP(oppVB.Id, oppVB.StageName, 110);
        
        /*Opportunity prevision4 = New Opportunity(Sucursal__c = '0095 Londrina',Condicion_de_Pago__c = 'ZC68 - A vista - 15 de Dezembro', Canal_de_Distribucion__c = '01',Sector__c = '02',Nro_Pedido_SAP__c = '34344',Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
    insert prevision4;
        PricebookEntry pbe4 = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi24 = new OpportunityLineItem(OpportunityId=prevision4.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe4.Id);
        insert oi24;

        oppVB.Pedido_Relacionado__c = prevision4.Id;
        oppVB.Tipo__c = 'ZBNC - Solicit. Nota de Cred.';
        update oppVB;
        Opp_Sap_Alta.enviarSAP(oppVB.Id, oppVB.StageName, 110);*/
      
      
      
    }

    static testmethod void test5() {
      Test.startTest();
        Opp_SAP_AltaOf.ofiVentas('04');
        Opp_SAP_AltaOf.ofiVentas('07');
        
        Opp_SAP_AltaOf.ofiVentas('01');
        Opp_SAP_AltaOf.ofiVentas('04');
        Opp_SAP_AltaOf.ofiVentas('07');
        Test.stopTest();
    }
    @isTest(SeeAllData=true)
    static void test6() {
        Test.startTest();
        
        //Opp_SAP_Alta.crearConds(new List<OpportunityLineItem>{opli1}, 'XXX', o.Tipo_de_Cambio__c, 'BR02', 'ZBSE');
        
        Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
        RecordType rt_prev = [Select Id From RecordType Where Name = 'Previsao' And SObjectType = 'Opportunity' limit 1];
        RecordType rt_VBAU = [Select Id From RecordType Where Name = 'CVB Pendiente' And SObjectType = 'Opportunity' limit 1];
        Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
        //Contact dest = [Select Id FROM Contact WHERE AccountId= :cuenta.Id AND Codigo_SAP__c = '0002027525' limit 1];
      
      
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Centro_Logistico__c cl = [Select Id, Estado__r.Id FROM Centro_Logistico__c WHERE NAme = '0095 - Londrina' limit 1];
        Contact dest = New Contact(LastName='ACME1', Codigo_SAP__c = '0002027525', AccountId=cuenta.Id, Numero_Calle__c='566',Estado__c = cl.Estado__r.Id, MailingStreet = 'terere', MailingCity = 'terere', MailingCountry = 'terere', MailingState = 'terere', MailingPostalCode='254147777');
        insert dest;
        
        Pricebook2 pb5 = [Select Id, Name From Pricebook2 where Name = 'Lista Canal Multiplicadores' and isActive = true limit 1];

        Opportunity prevision5 = New Opportunity(Canal_de_Distribucion__c = '01',Sector__c = '02',Sucursal__c = '0095 Londrina', Responsable__c='061 - Fernando Frenher',Tipo__c='ZBVN - Venda Normal',Condicion_de_Pago__c='ZC68 - A vista - 15 de Dezembro', Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb5.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prevision5;
        PricebookEntry pbe5 = [Select Id, Product2Id, Product2.Sector__c From PricebookEntry where Pricebook2Id = :pb5.Id and isActive = true and Product2.Sector__c = '02' limit 1];
        //PricebookEntryId=pbe5.Id
        OpportunityLineItem oi25 = new OpportunityLineItem(OpportunityId=prevision5.Id,Quantity=10,Previsao__c = 50,TotalPrice=10, PricebookEntryId=pbe5.Id, PricebookEntry=pbe5);
        insert oi25;

        OpportunityLineItem oi25Prueba = [SELECT Id, OpportunityId, Quantity, PricebookEntryId, PricebookEntry.Product2.Sector__c,PricebookEntry.UnitPrice FROM OpportunityLineItem Where Id = :oi25.Id limit 1];
        //List<OpportunityLineItem> oip25s = New List<OpportunityLineItem>();
        //oip25s.add(oi25);
 
        Opp_Sap_AltaOf.crearConds(new List<OpportunityLineItem>{oi25Prueba}, 'ZBEX', 2.01, 'BR01', 'ZBSE', false, false);
        
        Opp_Sap_AltaOf.enviarSAP(prevision5.Id, prevision5.StageName, 110);
        
        Opp_Sap_AltaOf.setEtapaAU(prevision5);
        
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void test7() {
      
        Account cuenta = [Select Id From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        RecordType rt_VBAU = [Select Id From RecordType Where Name = 'CVB Pendiente' And SObjectType = 'Opportunity' limit 1];
        //Centro_Logistico__c cl = [Select Id, Estado__r.Id FROM Centro_Logistico__c WHERE NAme = '0095 - Londrina' limit 1];
        Centro_Logistico__c cl = [Select Id, Estado__r.Id FROM Centro_Logistico__c WHERE Licencias__c = false limit 1];
        Contact dest = [Select Id, Name, Codigo_SAP__c FROM Contact WHERE AccountId = :cuenta.Id AND Name='ACME1' AND Codigo_SAP__c = '0002027525' limit 1];
        Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
      
        
        /*
        Opportunity prevision4 = New Opportunity(Sucursal__c = '0095 Londrina',Condicion_de_Pago__c = 'ZC68 - A vista - 15 de Dezembro', Canal_de_Distribucion__c = '01',Sector__c = '02',Nro_Pedido_SAP__c = '34344',Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prevision4;
        PricebookEntry pbe4 = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi24 = new OpportunityLineItem(OpportunityId=prevision4.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe4.Id);
        insert oi24;
        */
      
        Opportunity oppVB = New Opportunity(AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13', Name='Prueba 3',RecordTypeId = rt_VBAU.Id,Tipo__c='ZBVN - Venda Normal', Origen__c=cl.Id, Responsable__c='061 - Fernando Frenher', Condicion_de_Pago__c='ZC68 - A vista - 15 de Dezembro', Destinatario_de_Mercaderia__c =dest.Id);
        insert oppVB;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=oppVB.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi2;

        //oppVB.Pedido_Relacionado__c = prevision4.Id;
        oppVB.Tipo__c = 'ZBNC - Solicit. Nota de Cred.';
        Test.startTest();
        update oppVB;
        Test.stopTest();
        Opp_Sap_AltaOf.enviarSAP(oppVB.Id, oppVB.StageName, 110);

    }
}
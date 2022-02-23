global class Opp_SAP_OfMod{
	
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
        sapModOf.ZssdOfertaPosTab TPos; //ZssdOfertaPosTab TPos;
        sapModOf.ZssdOfertaCondTab TCond;        
        Boolean ret;
    }
    WebService static Retorno modifOfertaSAP(Id oppId, String etapa, Integer target){    
        Retorno r = new Retorno();
        Retorno r1 = new Retorno();
        rty = Opp_Utils.cargarRecordTypesOportunidades();
        r.msg = '\n';
        try
        {
			Opportunity o = [Select Id, PE_Bajar_SAP__c, AccountId From Opportunity Where Id = :oppId];            
			r = modOFs(o.Id, etapa, target);
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
                    if(a.CodigoSAP__c != null){
                        r.msg = 'La cuenta existe en SAP'; r.ret = true;
                    }
                    else{
                        r.msg = 'La cuenta no existe en SAP'; r.ret = false;   
                    }
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
            r.msg = e.getMessage() + ' ' + step  + '-' +e.getLineNumber(); r.ret = false;
        }
        return r;
    }
    
    static Retorno modOFs(Id opId, String etapa, Integer target){
        
        String[] retornoOferta = New String[2];               
        Retorno r = new Retorno(); r.ret = true;
        Opportunity o = [Select Nro_Pedido_SAP__c, Safra__c, Id, PE_bajar_SAP__c, OwnerId, Owner.Alias, Name, AccountId, Account.CodigoSAP__c, Account.Responsavel__c, CloseDate, RecordTypeId, StageName, Tipo_de_Cambio__c, Condicion_de_Pago__c, Sucursal__c, Tipo__c, Pedido_Relacionado__c, Motivo_de_Pedido__c, Account.Grupo_de_cuentas__c, Origen__r.Codigo_SAP__c, Destinatario_de_Mercaderia__r.Codigo_SAP__c, Marca__c, Responsable__c, Owner.Codigo_SAP__c, Owner.Profile.Name, Invierno__c, RecordType.Name From Opportunity Where Id = :opId];        
        r.msg = '\nInicio: modOFs';
        try{            
            
                Retorno rsap = modOFSAP(o, etapa, '', target);
                if((rsap.ret && rsap.oferta != null && rsap.oferta != '') || (rsap.msg.contains('Existe la Nota de Venta'))){
                	System.debug('ENTRO1');
                    r.ret = true;
                    //o.Nro_Pedido_SAP__c = rsap.oferta;
                    //o.Observaciones_Paso_a_SAP__c = rsap.msg;
                    String tipo = o.Tipo__c.substring(0,4);
                    if(!setEtapaAU(o)){
                       r.msg = 'Mala Etapa';
                       r.ret = false;
                    }

                    /*if (rsap.msg.contains('Existe la Nota de Venta')){
                       Pattern p = Pattern.compile('[a-zA-Z]');
                       o.Nro_Pedido_SAP__c = p.matcher(rsap.msg.substring(0,40)).replaceAll('').trim();
                       
                       String nro_oferta = o.Nro_Pedido_SAP__c;
                       Integer long_nro_oferta = o.Nro_Pedido_SAP__c.length();
                       Integer ceros_agregar = 10 - long_nro_oferta;
                       String ceros = '';
                       Integer i;
                       for (i=0;i<ceros_agregar;i++)
                          ceros += '0';
                       o.Nro_Pedido_SAP__c = ceros + o.Nro_Pedido_SAP__c;   
                       o.Observaciones_Paso_a_SAP__c = 'BR - ' + nro_oferta + ' se ha grabado';                          
                    }*/ 
                    
            		System.debug('ACTUALIZA PENDIENTE DE BAJAR!');
                    if(o.PE_Bajar_SAP__c == true){
                      System.debug('ACTUALIZA PENDIENTE DE BAJAR2!');		
                      o.PE_Bajar_SAP__c = false;
                      System.debug('ACTUALIZA PENDIENTE DE BAJAR!');
                    } 
                }
                else{
                    //o.Observaciones_Paso_a_SAP__c = rsap.msg;
                    r.ret = false;                  
                }
                r.msg = rsap.msg;                
        }
        catch(Exception e){
            r.msg = 'En modOFs - Error: ' + e.getMessage() + '-' +e.getLineNumber(); r.ret = false;
        }
        
        try{
          update o;
        }
        catch(DMLException e){
            r.msg = 'En modOFs - Error: ' + e.getMessage()  + '-' +e.getLineNumber(); r.ret = false;
        }        
        return r;
    }
    
    public static Retorno modOFSAP(Opportunity o, String parEtapa, String clienteSAP, Integer target){
        sapModOf.ZSdModOfertaResponse_element resultado;
        Retorno r = new Retorno();        
        List<OpportunityLineItem> OppIts = new List<OpportunityLineItem>();
        Map<String,OpportunityLineItem> itemMap = new Map<String,OpportunityLineItem>();
        Boolean vBasica = false; 
        sapModOf.ZssdOfertaPosTab TPos; //ZssdOfertaPosTab TPos;
        sapModOf.ZssdOfertaCondTab TCond;        
        
        r.ret = true;
        r.msg = '\n';
                
        try{
            OppIts = [Select Id, TMP_Observaciones__c, Posicion_SAP__c, Quantity, PricebookEntryId, PricebookEntry.Product2.Name, PricebookEntry.Product2.Codigo_material_SAP__c, PriceBookEntry.Product2.Licenciada__c, PriceBookEntry.Product2.Sector__c, UnitPrice, PriceBookEntry.UnitPrice, Contrato_Relacionado__c, Contrato_Relacionado__r.Name, Posicion_SAP_Relacionada__c, Tasas__c, Observaciones_Tasas__c, Precio_SAP__c, Base_de_Calculo__c, Precio_Liquido__c, PriceBookEntry.Product2.Family, Precio_Contrato__c, PricebookEntry.Product2.Variedade__c, Categoria__c, Precio_SAP_Estimado__c, PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c, Tratamiento_de_Semilla__c, Motivo_de_Rechazo__c, Rechazado__c, Grupo_de_materiales_2__c From OpportunityLineItem Where OpportunityId = : o.Id AND (Motivo_de_Rechazo__c != null OR Motivo_de_Rechazo__c != '')];   //Peneira__c,, Grupo_de_materiales_2__c             
                      
            sapModOf.Z_SD_MOD_OFERTA soap = new sapModOf.Z_SD_MOD_OFERTA();
            
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
            RetCabecera retp = crearPos(OppIts, sucursal, tipoNV, o, vBasica);  
            
            if(retp.ret){
                TPos = retp.TPos;
            }
            else{
            
                r.msg += retp.msg;              
                r.ret = false;
                return r;
            }                                                           
            
            RetCabecera retc = crearConds(OppIts, tipoNV, tipo_cambio, tipo_cuenta, vBasica, o.Invierno__c);            
            if(retc.ret){
                TCond = retc.TCond;             
                //r.msg += retc.msg;
            }
            else{
                r.msg += retc.msg;              
                r.ret = false;
                return r;
            }

            if(TPos == null || TCond == null){
                r.msg += 'Cabecera, Condicion o Posicion Nula\n' + OppIts.get(0).Id;
                r.ret = false; return r;
            }
                        
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
        
            String myData = 'donmario:donmario';
            //String myData = 'SROMERO:04Betu110';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                      
            String tar = String.valueOf(target);                                       
            resultado = soap.ZSdModOferta(String.ValueOf(o.Nro_Pedido_SAP__c), TCond, TPos, tar);

            Integer i;         
            for (i=0;i<resultado.EtReturn.item.size();i++)
               r.msg += resultado.EtReturn.item[i].Message;
            if (resultado.EpSubrc == 0){               
               r.ret = true;
               
               for (Integer j=0;j<resultado.EtRelPos.item.size();j++)
                   if(itemMap.containsKey(resultado.EtRelPos.item[j].Zzpossf)){
                       OpportunityLineItem ii = itemMap.get(resultado.EtRelPos.item[j].Zzpossf);
                       if(ii != null)
                           ii.Posicion_SAP__c = resultado.EtRelPos.item[j].Posnr;
                           ii.Rechazado__c = true;
                   }
                   
               }else{
                  r.msg += 'La OF se actualizó en SAP. ';
                  r.ret = false;                                
            }   
            
            update OppIts;
            return r;                                      
            
        }catch(System.CalloutException ex) {
            r.msg = '\nEn modOFSAP - CallOutException: ' + ex.getMessage() + '-' +ex.getLineNumber(); r.ret = false; 
            //o.Observaciones_Paso_a_SAP__c = r.msg;
            update o;

            r.ret=false;                       
        
        }catch(System.Exception ex) {
            r.msg = '\nEn modOFSAP - CallException: ' + ex.getMessage() + '-' +ex.getLineNumber(); r.ret = false; 
            //o.Observaciones_Paso_a_SAP__c = r.msg;
            update o;
            r.ret=false;                       
        }
        
        
        /////////////////////////////////////////////BORRAR
        sapModOf.Bapiret2Tab mensajes;
        try{
            if(resultado != null){                
                mensajes = resultado.EtReturn;
                String tmsg = '';
                if(Integer.valueOf(mensajes.item[1]) == 0){
                    /*String res = '000000000';                   
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
                    else{                   
                        r.msg += '\nFalta Nro de Oferta - La Oferta queda pendiente de actualizar';
                        r.ret = false;
                    }*/ 
                }
                else{                   
                    r.msg += '\nError - No se actualizo SAP - La Oferta queda pendiente de actualizar';
                    r.ret = false;
                }

                
            }
            else
            {
                r.msg += '\nError - SAP no retorno ningun mensaje de exito - La Oferta queda pendiente de actualizar';
                r.ret = false;
            }
        }        
        catch(Exception e){
            r.msg = 'En modOFSAP - Exception: ' + resultado + '\n' + e.getMessage() + '-' +e.getLineNumber() + '\n' + resultado; r.ret = false;
        }
        
        /////////////////////////////////////////////////////////////////////////BORRAR
 
                
        try{
            Integer j = 0;
            for(OpportunityLineItem i : OppIts){
                if(TPos == null) continue;              
                sapModOf.ZssdOfertaPos IPos2 = TPos.item[j]; //ZssdOfertaPos IPos2 = TPos.item[j];
                if(IPos2 == null) continue;
                i.ZZPOSSF__c = IPos2.ZZPOSSF;
                i.WERKS__c = IPos2.WERKS;
                i.KWMENG__c = String.valueOf(IPos2.KWMENG);
                i.AUFNR__c = IPos2.AUFNR;
                i.MVGR1__c = IPos2.MVGR1;
                i.VRKME__c = IPos2.VRKME;
                i.MATNR__c = IPos2.MATNR;
                i.METODO__c = 'MOD';
                j++;
            }
        }
        catch(System.Exception ex) {
            r.msg += '\nEn agregado - Exception: ' + ex.getMessage() + '-' +ex.getLineNumber(); r.ret = false;
        }
        
        update OppIts;
        return r;
    }
    
    
    public static RetCabecera crearPos(List<OpportunityLineItem> OppIts, String sucursal, String tipoNV, Opportunity o, Boolean vBas){
        RetCabecera retPos = new RetCabecera();
        Map<String,Product2> oppItMap = new Map<String,Product2>();       
        String step = '';        
        Integer index = 0;
        
        try{
          step='CrearPos 1';                       
            sapModOf.ZssdOfertaPosTab TPos = new sapModOf.ZssdOfertaPosTab();
            TPos.item = new List<sapModOf.ZssdOfertaPos>();//BORRAR
            
            for(OpportunityLineItem i : OppIts)                
                oppItMap.put(i.Id, i.PricebookEntry.Product2);            
                        
            for(OpportunityLineItem i : OppIts){
                sapModOf.ZssdOfertaPos IPos = new sapModOf.ZssdOfertaPos();
                
                IPos.ZZPOSSF = i.Id;
                
                step='CrearPos 2';               
                //if(o.Origen__r.Codigo_SAP__c != null){
                  //IPos.WERKS = o.Origen__r.Codigo_SAP__c.trim();
                //}else{            
                  //Centro de despacho
                  //if (sucursal.substring(0,4) == '0094')
                    // IPos.WERKS = 'BD01';                                
                     
                  //if (sucursal.substring(0,4) == '0095')
                    // IPos.WERKS = 'BD02';   
                //}
                step='CrearPos 3';
                //Cantidad del pedido
                IPos.KWMENG = String.valueOf(i.Quantity);                
                
                //Orden de CO                
                IPos.AUFNR = 'VTA';
        //if((tipo == 'ZBVN' || tipo == 'ZBFA') && o.Marca__c != null){
              //    for(Centro_de_CO_Item__c centro : [Select c.Centro_de_CO__c, c.Id, c.Name, c.Producto__c, Centro_de_CO__r.Orden__c from Centro_de_CO_Item__c c  Where c.Centro_de_CO__r.Sociedad__c = :o.Marca__c and c.Centro_de_CO__r.Campania__c = :campania And c.producto__c = :oppItMap.get(i.Id).Id])
              //        IPos.AUFNR = centro.Centro_de_CO__r.Orden__c;          
        //}else{
                  for(Centro_de_CO_Item__c centro : [Select c.Centro_de_CO__c, c.Id, c.Name, c.Producto__c, Centro_de_CO__r.Orden__c from Centro_de_CO_Item__c c  Where c.Centro_de_CO__r.Sociedad__c = 'BRMX' and c.Centro_de_CO__r.Campania__c = :o.Safra__c And c.producto__c = :oppItMap.get(i.Id).Id])
                      IPos.AUFNR = centro.Centro_de_CO__r.Orden__c;
        //}
                //Calibre, Grupo de materiales 1
                IPos.MVGR1 = '';
                //Banda de Calibre, Grupo de materiales 2
                if(i.Grupo_de_materiales_2__c != null && i.Grupo_de_materiales_2__c != '') IPos.MVGR2 = i.Grupo_de_materiales_2__c;
                index++;
				//IPos.POSNR = '0000' + String.ValueOf(index) + '0';
				IPos.POSNR = i.Posicion_SAP__c;
				IPos.ABGRU = '';
				if(i.Motivo_de_Rechazo__c != '' && i.Motivo_de_Rechazo__c != null) IPos.ABGRU = i.Motivo_de_Rechazo__c.substring(0,2);
                
                IPos.MVGR4 = '';
                //if(vBas && (tipoNV == 'ZBVN' || tipoNV == 'ZBSR') && i.Tratamiento_de_Semilla__c != null && i.Tratamiento_de_Semilla__c != '') IPos.MVGR4 = i.Tratamiento_de_Semilla__c.substring(0,3);
                //Unidad de medida de venta, se reemplaza por el de las condiciones
                IPos.VRKME = '';
                
                //Codigo de material de SAP, sale del producto Codigo.
                IPos.MATNR = oppItMap.get(i.Id).Codigo_material_SAP__c;
                                
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
    
    public static RetCabecera crearConds(List<OpportunityLineItem> OppIts, String tipo, Decimal Tipo_de_Cambio, String tipo_cuenta, Boolean vBas, Boolean inv){
        RetCabecera retPos = new RetCabecera();
        Integer index = 0;
        String step = '';       
        try{
          step='CrearConds 1';            
            sapModOf.ZssdOfertaCondTab TCond = new sapModOf.ZssdOfertaCondTab();
            TCond.item = new List<sapModOf.ZssdOfertaCond>();

            for(OpportunityLineItem i : OppIts){
              step='CrearConds 2';
              // Tema precios está complicado. Validar con Cecilia, Juan y Santiago.
                                  
                step='CrearConds 3';
                Decimal ZPRN = 0.0;
                Double com = i.UnitPrice;                                
                
                ZPRN = Decimal.valueOf(com);
                ZPRN = ZPRN.divide(1, 2, System.RoundingMode.HALF_EVEN);
                
                i.UnitPrice = ZPRN;  
                i.Precio_SAP__c = ZPRN;              
                                
                sapModOf.ZssdOfertaCond ICond1 = new sapModOf.ZssdOfertaCond();
                ICond1.ZZPOSSF = i.Id;
                
                //String tipo_aux = tipo;
                //if (tipo_p_rel != '')
                //   tipo_aux = tipo_p_rel;
                   
                ICond1.KSCHL = 'ZPRE';
                if (tipo_cuenta == 'CMEX' && !vBas)
                    ICond1.KSCHL = 'ZBRU';
                                    
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
       
       if (o.RecordTypeId == rt_PE && o.StageName == st_PE){    
          o.StageName = st_AU;
          o.RecordTypeId = rt_AU;
          return true;
       }
       return false;
    }      
    
    static Boolean setEtapaNC_AU(Opportunity o){
       String st_NC_PE = 'PE - Pendiente';
       String st_NC_AU = 'AU - Autorizada';
       String rt_NC_AU = rty.get('NC - Autorizada');
       String rt_NC_PE = rty.get('NC - Pendiente');
       
       if (o.RecordTypeId == rt_NC_PE && o.StageName == st_NC_PE){    
          o.StageName = st_NC_AU;
          o.RecordTypeId = rt_NC_AU;
          return true;
       }
       return false;
    }
    @isTest(SeeAllData=true)
    static void test() {                                  
                  
       Product2 px1 = new Product2(Name = 'Test 1', Especie__c = 'SOJA');
       insert px1;
       Pricebook2 s = [select ID from Pricebook2 where IsStandard = true];
       PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px1.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
       insert pbesx;
       
       Account ac = New Account(Name='Prueba');
       insert ac;
       Opportunity o = new Opportunity(Name = 'Test 1', CloseDate = System.today(), StageName = 'Clientes potenciales', AccountId = ac.Id, Nro_Pedido_Sap__c = '123');
       insert o;
       OpportunityLineItem opli1 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 10, quantity = 1);
       insert opli1;

       Configuracion_BMX__c c = new Configuracion_BMX__c(link_intra_dm__c='www.intra-dm.com.ar:8080',Link_Sap_Prod__c='www.intra-dm.com.ar:8080'); //[Select link_intra_dm__c, Link_Sap_Prod__c From Configuracion_BMX__c limit 1];
       insert c;
       Opp_SAP_OfMod.modifOfertaSAP(o.Id, 'RE', 110);
       Opp_SAP_OfMod.modifOfertaSAP(o.Id, 'RR', 110);
       
       Opp_SAP_OfMod.setEtapaAU(o);
       Opp_SAP_OfMod.setEtapaNC_AU(o);
       
    }
	@isTest(SeeAllData=true)
    static void test2() {                                  
                  
       Product2 px1 = new Product2(Name = 'Test 1', Especie__c = 'SOJA');
       insert px1;
       Pricebook2 s = [select ID from Pricebook2 where IsStandard = TRUE];
       PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px1.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
       insert pbesx;
       
       Account ac = New Account(Name='Prueba');
       insert ac;
       Opportunity o = new Opportunity(Name = 'Test 1', CloseDate = System.today(), StageName = 'Clientes potenciales', AccountId = ac.Id, Nro_Pedido_Sap__c = '123');
       insert o;
       OpportunityLineItem opli1 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 10, quantity = 1);
       insert opli1;

       Opp_SAP_OfMod.modifOfertaSAP(o.Id, 'RR', 110);
       
       Opp_SAP_OfMod.setEtapaAU(o);
       Opp_SAP_OfMod.setEtapaNC_AU(o);
    }
}
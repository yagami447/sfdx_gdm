global class Opp_Sap_Alta {
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
        sapAltaPedido2.ZSSD_PEDIDO_CAB cab; 
        sapAltaPedido2.ZSSD_PEDIDO_POS_TAB TPos; //ZssdPedidoPosTab TPos;
        sapAltaPedido2.ZSSD_PEDIDO_COND_TAB TCond;        
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
               r = altaNVs(o.Id, etapa, target);
               o.PE_Bajar_SAP__c = false;
            }else{
                  r.msg += '\nEl cliente no existe en SAP.\nLa Nota de Venta queda Pendiente para bajar.';
                  o.Observaciones_Paso_a_SAP__c = r.msg;
                  r.ret = false;
                  o.PE_Bajar_SAP__c = true;
                  update o;
            }
        }
        catch(Exception e)
        {
            r.msg = 'En EnviarSAP - Error: ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    static Retorno estaEnSAP(Id id){
        Retorno r = new Retorno();
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
            r.msg = e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    static Retorno altaNVs(Id opId, String etapa, Integer target){
        String[] retornoOferta = New String[2];               
        Retorno r = new Retorno(); r.ret = true;
        Opportunity o = [Select Nro_Pedido_SAP__c, Tipo_saida_de_deposito__c, Safra__c, Id, PE_bajar_SAP__c, OwnerId, Owner.Alias, Name, AccountId, Account.CodigoSAP__c, Account.Responsavel__c, CloseDate, RecordTypeId, StageName, Tipo_de_Cambio__c, Fecha_de_Entrega__c, Condicion_de_Pago__c, Sucursal__c, Tipo__c, Pedido_Relacionado__c, Motivo_de_Pedido__c, Account.Grupo_de_cuentas__c, Account.Region__r.Oficina_Ventas__c, Origen__r.Codigo_SAP__c, Destinatario_de_Mercaderia__r.Codigo_SAP__c, Marca__c, Responsable__c, Owner.Codigo_SAP__c, Owner.Profile.Name, Invierno__c, RecordType.Name, Pedido_Relacionado__r.Nro_Pedido_SAP__c, Region__c, Vencimiento_Anexo__c, Pagador__r.CodigoSAP__c, Cuenta_y_Orden__r.CodigoSAP__c, Relatorio_Relacionado__c, Relatorio_Relacionado__r.RecordType.Name, Valor_antecipado__c, TotalOpportunityQuantity From Opportunity Where Id = :opId];        
        r.msg = '\nInicio: altaNVs';
        
        try{
            
                Retorno rsap = altaNVSAP(o, etapa, '', target);
                System.debug('Ernesto altaNVSAP rsap.ret: '+rsap.ret);
                System.debug('Ernesto altaNVSAP rsap.pedido: '+rsap.pedido);
                System.debug('Ernesto altaNVSAP rsap.msg: '+rsap.msg);
                if((rsap.ret && rsap.pedido != null && rsap.pedido != '') || (rsap.msg.contains('Existe la Nota de Venta'))){
                    System.debug('Ernesto Ingres+o al If');
                    r.ret = true;
                    o.PE_Bajar_SAP__c = false;
                    o.Nro_Pedido_SAP__c = rsap.pedido;
                    o.Observaciones_Paso_a_SAP__c = rsap.msg;
                    String tipo = o.Tipo__c.substring(0,4);
                    if (tipo != 'ZC01'){
                        if(!setEtapaAU(o)){
                           r.msg = 'Mala Etapa';
                           r.ret = false;
                        }
                    }else{
                        if(!setEtapaNC_AU(o)){
                           r.msg = 'Mala Etapa';
                           r.ret = false;
                        } 
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
                    String rt_CVBAU = rty.get('CVB Autorizada');
                    String rt_CVBPE = rty.get('CVB Pendiente'); 
                    System.debug('ACTUALIZA RT');
                    if(o.RecordTypeId == rt_CVBPE){
                        o.RecordTypeId = rt_CVBAU;
                        o.StageName = 'AU - Autorizada';
                        System.debug('ACTUALIZÓ RT');
                    } 
                    Double desc_uso_futuro = 0;
                    if (o.Relatorio_Relacionado__r.RecordType.Name == 'Anexo III'){
                        for (AggregateResult ar : [Select Sum(Desconto_Adicional__c) des From OpportunityLineItem Where OpportunityId = :o.Id]){
                            if (Double.valueOf(ar.get('des')) != 0)
                                desc_uso_futuro = Double.valueOf(ar.get('des'));
                        }   
                        CRM_Bonificacion__c crm_b = [Select Id, BRMX_Desconto_Uso_Futuro__c, NEOG_Desconto_Uso_Futuro__c, BRMX_Desconto_Uso_Futuro_Final__c, NEOG_Desconto_Uso_Futuro_Final__c From CRM_Bonificacion__c Where Safra__c = :o.Safra__c And RecordType.Name = :o.Marca__c And CRM_Multiplicador__r.Cuenta__c = :o.AccountId];                        
                        if (o.Marca__c == 'BRMX'){
                            crm_b.BRMX_Desconto_Uso_Futuro__c = desc_uso_futuro;
                            crm_b.BRMX_Desconto_Uso_Futuro_Final__c = desc_uso_futuro;
                        }
                        if (o.Marca__c == 'NEOG'){
                            crm_b.NEOG_Desconto_Uso_Futuro__c = desc_uso_futuro;
                            crm_b.NEOG_Desconto_Uso_Futuro_Final__c = desc_uso_futuro;
                        }
                        update crm_b;                               
                    }
                    if (o.Relatorio_Relacionado__r.RecordType.Name == 'Anexo IV'){
                        for (AggregateResult ar : [Select Sum(Desconto_Adicional__c) des, Opportunity.RecordType.Name rt From OpportunityLineItem Where ((Opportunity.Relatorio_Relacionado__c = :o.Relatorio_Relacionado__c And Opportunity.RecordType.Name In ('Autorizada', 'NC - Autorizada')) Or OpportunityId = :o.Id) And Opportunity.Marca__c = :o.Marca__c Group By Opportunity.RecordType.Name]){
                            if (Double.valueOf(ar.get('des')) != 0){
                                if (String.valueOf(ar.get('rt')) == 'Pendiente' || String.valueOf(ar.get('rt')) == 'Autorizada')                                
                                    desc_uso_futuro += Double.valueOf(ar.get('des'));
                                if (String.valueOf(ar.get('rt')) == 'NC - Pendiente' || String.valueOf(ar.get('rt')) == 'NC - Autorizada')                                
                                    //desc_uso_futuro += Double.valueOf(ar.get('des')) * -1;
                                    desc_uso_futuro += Double.valueOf(ar.get('des'));
                            }
                        }  
                        CRM_Bonificacion__c crm_b = [Select Id, BRMX_Desconto_Uso_Futuro__c, NEOG_Desconto_Uso_Futuro__c, BRMX_Desconto_Uso_Futuro_Final__c, NEOG_Desconto_Uso_Futuro_Final__c From CRM_Bonificacion__c Where Safra__c = :o.Safra__c And RecordType.Name = :o.Marca__c And CRM_Multiplicador__r.Cuenta__c = :o.AccountId];
                        if (o.Marca__c == 'BRMX'){
                            crm_b.BRMX_Desconto_Uso_Futuro_Final__c = crm_b.BRMX_Desconto_Uso_Futuro__c + desc_uso_futuro;
                        }
                        if (o.Marca__c == 'NEOG'){
                            crm_b.NEOG_Desconto_Uso_Futuro_Final__c = crm_b.NEOG_Desconto_Uso_Futuro__c + desc_uso_futuro;
                        }
                        update crm_b;                                
                    }                              
                }
                else{
                    o.Observaciones_Paso_a_SAP__c = rsap.msg;
                    r.ret = false;                  
                }
                r.msg = rsap.msg;                
        }
        catch(Exception e){
            r.msg = 'En altaNVs - Error: ' + e.getMessage(); r.ret = false;
        }
        
        try{
            System.debug('Ernesto ACTUALIZA OFERTA');
            if(o.RecordTypeId == rty.get('CVB Autorizada')){
                if(o.Fecha_de_Entrega__c == null) o.Fecha_de_Entrega__c = date.today();
                retornoOferta = Opp_Utils.actualizarPasoVBSAP(o.Id, false);  //Si a esta altura tiene el RecordType de CVBAU es porque está todo OK y hay que actualizar la Oferta.
                if(retornoOferta[1] != 'OK') o.Observaciones_Paso_a_SAP__c = o.Observaciones_Paso_a_SAP__c + retornoOferta[0];
                System.debug('ACTUALIZÓ OFERTA');
            }
            update o;
            System.debug('UPDATE NV');
        }
        catch(DMLException e){
            r.msg = 'En altaNVs - Error: ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    public static Retorno altaNVSAP(Opportunity o, String parEtapa, String clienteSAP, Integer target){
        sapAltaPedido2.Z_SD_ALTA_PEDIDOResponse_element resultado;
        Retorno r = new Retorno();        
        List<OpportunityLineItem> OppIts = new List<OpportunityLineItem>();
        Map<String,OpportunityLineItem> itemMap = new Map<String,OpportunityLineItem>();
        Boolean vBasica = false; 
        sapAltaPedido2.ZSSD_PEDIDO_POS_TAB TPos; //ZssdPedidoPosTab TPos;
        sapAltaPedido2.ZSSD_PEDIDO_COND_TAB TCond;
        sapAltaPedido2.ZSSD_PEDIDO_CAB ICab;
        
        r.ret = true;
        r.msg = '\n';
                
        try{
            OppIts = [Select Id, TMP_Observaciones__c, Posicion_SAP__c, Quantity, PricebookEntryId, PricebookEntry.Product2.Name, PricebookEntry.Product2.Codigo_material_SAP__c, PriceBookEntry.Product2.Licenciada__c, PriceBookEntry.Product2.Sector__c, UnitPrice, PriceBookEntry.UnitPrice, Contrato_Relacionado__c, Contrato_Relacionado__r.Name, Posicion_SAP_Relacionada__c, Tasas__c, Observaciones_Tasas__c, Precio_SAP__c, Base_de_Calculo__c, Precio_Liquido__c, PriceBookEntry.Product2.Family, Precio_Contrato__c, PricebookEntry.Product2.Variedade__c, Categoria__c, Precio_SAP_Estimado__c, PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c, Tratamiento_de_Semilla__c, Grupo_de_materiales_2__c, PricebookEntry.Product2.Variedade__r.Licenciada__c, Descuento_porc__c, Descuento__c, Desconto_Total_Unidade__c, Precio_total_estimado__c, Valor_antecipado__c From OpportunityLineItem Where OpportunityId = : o.Id]; //Peneira__c,, Grupo_de_materiales_2__c            
                      
            sapAltaPedido2.Z_SD_ALTA_PEDIDO soap = new sapAltaPedido2.Z_SD_ALTA_PEDIDO();
            
            sapAltaPedido2.ZSSD_PEDIDO_INTERLOCUTORES_TAB TInterlocutores;
            
            sapAltaPedido2.ZSSD_TIPO_CAMBIO_TAB tipoCambioTab = New sapAltaPedido2.ZSSD_TIPO_CAMBIO_TAB();
            
            sapAltaPedido2.ZSSD_TEXTOS_TAB textosTab = New sapAltaPedido2.ZSSD_TEXTOS_TAB();
            
            if(o.RecordType.Name == 'CVB Pendiente' || o.RecordType.Name == 'Pendiente' || o.RecordType.Name == 'NC - Pendiente') vBasica = true;
                        
            Opportunity p_rel;
            if (o.Tipo__c.substring(0,4) == 'ZC01')
                if (o.Pedido_Relacionado__c != null)
                    p_rel = [Select Sucursal__c, Safra__c, Tipo_de_Cambio__c, Tipo__c, Account.Grupo_de_cuentas__c From Opportunity Where Id = : o.Pedido_Relacionado__c];
            
            TInterlocutores = New sapAltaPedido2.ZSSD_PEDIDO_INTERLOCUTORES_TAB();
            TInterlocutores.item = new List<sapAltaPedido2.ZSSD_PEDIDO_INTERLOCUTORES>();
            
            RetCabecera rett = crearCab(o, OppIts.get(0), parEtapa, vBasica, TInterlocutores);            
            
            if(rett.ret)
                ICab = rett.cab;
            else{
                r.msg += rett.msg;
                r.ret = false;
                System.debug('Franco 1');
                return r;
            }
            
            for(OpportunityLineItem i : OppIts){
                String value = i.Id;
                itemMap.put(value, i);
            }
        
            String campania = '';
                        
            String sucursal = ''; 
            Decimal tipo_cambio = 0;
            String tipo_cuenta = '';
            if (p_rel == null){
                sucursal = o.Sucursal__c;
                tipo_cambio = o.Tipo_de_Cambio__c;
                campania = o.Safra__c;
                tipo_cuenta = o.Account.Grupo_de_cuentas__c;
            }else{
                sucursal = p_rel.Sucursal__c;
                tipo_cambio = p_rel.Tipo_de_Cambio__c;
                //p_rel_tipo = p_rel.Tipo__c.substring(0,4);
                tipo_cuenta = p_rel.Account.Grupo_de_cuentas__c;
                campania = p_rel.Safra__c;
            }   
            
            String tipoNV = o.Tipo__c.substring(0,4);             
            //if()                
            RetCabecera retp = crearPos(OppIts, sucursal, campania, tipoNV, o, vBasica);  
            
            if(retp.ret){
                TPos = retp.TPos;
            }
            else{
            
                r.msg += retp.msg;              
                r.ret = false;
                System.debug('Franco 2');
                return r;
            }                                                           
            
            RetCabecera retc = crearConds(OppIts, tipoNV, tipo_cambio, ICab.VKBUR, tipo_cuenta, vBasica, o.Invierno__c, o);            
            if(retc.ret){
                TCond = retc.TCond;             
                //r.msg += retc.msg;
            }
            else{
                r.msg += retc.msg;              
                r.ret = false;
                System.debug('Franco 3');
                return r;
            }

            if(ICab == null || TPos == null || TCond == null){
                r.msg += 'Cabecera, Condicion o Posicion Nula\n' + OppIts.get(0).Id;
                r.ret = false;
                System.debug('Franco 4');
                return r;
            }
                        
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
        
            String myData = 'SALESFORCEBR:2o21gdms33dS';
            //String myData = 'sromero:Mario208';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
                      
            String tar = String.valueOf(target);     
            System.debug('Cabecera: ' + ICab);
            System.debug('Condiciones: ' + TCond);
            System.debug('Interlocutores: ' + TInterlocutores);
            System.debug('Posiciones: ' + TPos);
            System.debug('Textos: ' + textosTab);
            System.debug('Tipo de cambio: ' + tipoCambioTab);
            resultado = soap.Z_SD_ALTA_PEDIDO(ICab, TCond, TInterlocutores, TPos, textosTab, tipoCambioTab, String.valueOf(tar));
            sYSTEM.DEBUG(json.serialize(resultado));
            Integer i;         
            for (i=0;i<resultado.T_RETURN.item.size();i++){
                r.msg += resultado.T_RETURN.item[i].Message;
                System.debug('Mensaje: ' + resultado.T_RETURN.item[i].Message);
            }
               
            
            System.debug('Resultado: ' + resultado.E_SUBRC);
            if (resultado.E_SUBRC == 0){               
               r.pedido = String.valueOf(resultado.E_NRO_PEDIDO);
               r.ret = true;
               
               for (Integer j=0;j<resultado.T_REL_POS.item.size();j++)
                   if(itemMap.containsKey(resultado.T_REL_POS.item[j].Zzpossf)){
                       OpportunityLineItem ii = itemMap.get(resultado.T_REL_POS.item[j].Zzpossf);
                       if(ii != null)
                           ii.Posicion_SAP__c = resultado.T_REL_POS.item[j].Posnr;
                   }
                   
               }else{
                  r.msg += 'La NV no paso a SAP. ';
                  r.ret = false;    
                   System.debug('Franco 5');
            }   
            
            update OppIts;
            System.debug('Franco 6');
            return r;                                      
            
        }catch(System.CalloutException ex) {
            r.msg = '\nEn altaNVSAP - CallOutException: ' + ex.getMessage(); r.ret = false; 
            o.Observaciones_Paso_a_SAP__c = r.msg;
            update o;

            r.ret=false;                       
        
        }catch(System.Exception ex) {
            r.msg = '\nEn altaNVSAP - CallException: ' + ex.getMessage(); r.ret = false; 
            o.Observaciones_Paso_a_SAP__c = r.msg;
            update o;
            r.ret=false;                       
        }
        
        
        /////////////////////////////////////////////BORRAR
        sapAltaPedido2.BAPIRET2_TAB mensajes;
        try{
            if(resultado != null){                
                mensajes = resultado.T_RETURN;
                String tmsg = '';
                if(Integer.valueOf(mensajes.item[1]) == 0){
                    String nroPedido = resultado.E_NRO_PEDIDO;
                    String res = '000000000';                   
                    if(nroPedido == ''){
                        tmsg = string.valueOf(mensajes.item[1]);
                        res += tmsg.split('Venta')[1].split('creada')[0].trim();
                        nroPedido = res.substring(res.length()-10, res.length());
                    }
                    if(nroPedido != ''){
                        r.ret = true;
                        r.pedido = nroPedido;                                            
                        r.msg += '\nExito!!!';
                    }
                    else{                   
                        r.msg += '\nFalta Nro de Pedido - La nota de venta queda pendiente de descargar';
                        r.ret = false;
                    }
                }
                else{                   
                    r.msg += '\nError - No se actualizo SAP - La nota de venta queda pendiente de descargar';
                    r.ret = false;
                }

                
            }
            else
            {
                r.msg += '\nError - SAP no retorno ningun mensaje de exito - La nota de venta queda pendiente de descargar';
                r.ret = false;
            }
        }        
        catch(Exception e){
            r.msg = 'En altaNVSAP - Exception: ' + resultado + '\n' + e.getMessage() + '\n' + resultado; r.ret = false;
        }
        
        /////////////////////////////////////////////////////////////////////////BORRAR
 
                
        try{
            Integer j = 0;
            for(OpportunityLineItem i : OppIts){
                if(TPos == null) continue;              
                sapAltaPedido2.ZSSD_PEDIDO_POS IPos2 = TPos.item[j]; //ZssdPedidoPos IPos2 = TPos.item[j];
                if(IPos2 == null) continue;
                i.ZZPOSSF__c = IPos2.ZZPOSSF;
                i.VGPOS__c = IPos2.VGPOS;                
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
            r.msg += '\nEn agregado - Exception: ' + ex.getMessage(); r.ret = false;
        }
        
        update OppIts;
        return r;
    }
    
    public static RetCabecera crearCab(Opportunity o, OpportunityLineItem i, String parEtapa, Boolean vBas, sapAltaPedido2.ZSSD_PEDIDO_INTERLOCUTORES_TAB TInterlocutores){
        RetCabecera retCabe = new RetCabecera();
        String step = 'Inicio';
        retCabe.msg = '\n';
        try{
            sapAltaPedido2.ZSSD_PEDIDO_CAB ICab = new sapAltaPedido2.ZSSD_PEDIDO_CAB();

            //Varios
            ICab.ZZIDSF = o.Id;
            ICab.ZZNROSF = o.Name.left(15);
            String tipo = o.Tipo__c.substring(0,4);
            
            //Moneda
            ICab.WAERK = 'BRL';
            //if ((tipo == 'ZBEX' || o.Account.Grupo_de_Cuentas__c == 'CMEX') && !vBas)
            if (tipo == 'ZO02' || o.Account.Grupo_de_Cuentas__c == 'CMEX')
                ICab.WAERK = 'USD';
            //Organización de Ventas
            ICab.VKORG = '01BR';   
           if((tipo == 'ZO12' || tipo == 'ZO03' || tipo == 'ZBRG' || tipo == 'ZO08' || tipo == 'ZC01') && o.Invierno__c == true && o.Owner.Profile.Name == 'Administrativo_licencias')
                ICab.VKORG = 'MBAS';
            ICab.VALDT='';
            step = 'Bloqueos';
                        
            ICab.FAKSK = '';
            ICab.LIFSK = '';
            ICab.ABGRU = '';
                        
            step = 'Clientes';
            
            //Cuentas de Cliente y Distribuidor
            if(o.Destinatario_de_Mercaderia__r.Codigo_SAP__c != null)
                ICab.KUNWE = o.Destinatario_de_Mercaderia__r.Codigo_SAP__c.trim();
            else
                ICab.KUNWE = o.Account.CodigoSAP__c.trim();
            ICab.KUNRG = o.Account.CodigoSAP__c.trim();
            ICab.KUNRE = o.Account.CodigoSAP__c.trim();            
            ICab.KUNZD = '';
            
            if(o.Pagador__r.CodigoSAP__c != null)
                ICab.KUNRG = o.Pagador__r.CodigoSAP__c.trim();
                        
            Icab.KUNAG = o.Account.CodigoSAP__c.trim();                                                
            
            if(tipo == 'ZO10' && o.Destinatario_de_Mercaderia__r.Codigo_SAP__c != null){                                
                sapAltaPedido2.ZSSD_PEDIDO_INTERLOCUTORES interlocutor = New sapAltaPedido2.ZSSD_PEDIDO_INTERLOCUTORES();
                interlocutor.Parvw = 'PE';
                interlocutor.Kunnr = o.Destinatario_de_Mercaderia__r.Codigo_SAP__c;
                TInterlocutores.item.add(interlocutor);
            }
            
            if(o.Cuenta_y_Orden__r.CodigoSAP__c != null){
                sapAltaPedido2.ZSSD_PEDIDO_INTERLOCUTORES interlocutor2 = New sapAltaPedido2.ZSSD_PEDIDO_INTERLOCUTORES();
                interlocutor2.Parvw = 'Z6';
                interlocutor2.Kunnr = o.Cuenta_y_Orden__r.CodigoSAP__c;
                TInterlocutores.item.add(interlocutor2);
            }
            
            step = 'Fechas';
            
            //Fechas varias            
            ICab.AUDAT = String.valueOf(o.CloseDate).substring(0,10);            
            //ICab.VDATU = String.valueOf(o.CloseDate).substring(0,10);
            ICab.VDATU = String.ValueOf(date.today()).substring(0,10);
            if(o.Fecha_de_Entrega__c != null) ICab.VDATU = String.valueOf(o.Fecha_de_Entrega__c).substring(0,10);
            if(o.Safra__c != null)
                ICab.Zzcampana = o.Safra__c.substring(0,2) + '/20' + o.Safra__c.substring(3,5);                                               
            
            //Numero de documento modelo solo para toma consig.
            ICab.VGBEL = '';              
            if(o.RecordType.Name == 'CVB Pendiente') ICab.VGBEL = o.Pedido_Relacionado__r.Nro_Pedido_SAP__c;
            step = 'Pago Especie';
            
            //Motivo de pedido, solo para CANJE o ESPECIE
            ICab.AUGRU = '';                       
                      
            step = 'Incoterms';
                      
            //Datos incoterms, solo exportacion
            ICab.INCO1 = '';
            ICab.INCO2 = '';                                    

            //Grupo de condiciones de clientes, Solo CEREAL
            ICab.KDKG1 = '';
            System.debug('Mensaje 1');            
            If (tipo != 'ZC01'){
                //Sector de Ventas y Canal de distribucion
                ICab.VTWEG = '01';
                //if (tipo == 'ZBSE' || tipo == 'ZBEX')
                if (o.Account.Grupo_de_cuentas__c == 'CMEX' || tipo == 'ZO02')
                    ICab.VTWEG = '02'; //02 nuevo canal exterior, antes 04
                if(i.PricebookEntry.Product2.Variedade__r.Licenciada__c)
                    ICab.VTWEG = '03'; //03 nuevo canal licencias, antes 07
                ICab.SPART = i.PricebookEntry.Product2.Sector__c;
                step = 'Incoterms 1';
                //Condicion de Pago
                if(!String.isBlank(o.Condicion_de_Pago__c)){
                    ICab.ZTERM=o.Condicion_de_Pago__c.substring(0,4);
                }
                if(!String.isBlank(o.Condicion_de_Pago__c) && o.Condicion_de_Pago__c.substring(0,4) == 'ZC02'){
                    if(o.RecordType.Name == 'CVB Pendiente'){ICab.VALDT='20' + o.Safra__c.substring(3) + '-12-15';}
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
                
                ICab.VKBUR = 'BR01';
                if(o.Account.Region__r.Oficina_Ventas__c != null) ICab.VKBUR = o.Account.Region__r.Oficina_Ventas__c.trim();
                //COMENTADO 13/10/2015. CON PREG POR LICENCIADA ALCANZA. SE CAMBIA A PREGUNTAR POR LA VARIEDAD RELACIONADA --> if(i.PricebookEntry.Product2.Licenciada__c && (i.PricebookEntry.Product2.Family == 'Semilla' || i.PricebookEntry.Product2.Family == 'Royalty x Basica' || i.PricebookEntry.Product2.Family == 'Royalty x C-S'))
                if(i.PricebookEntry.Product2.Variedade__r.Licenciada__c){
                    //ICab.VKGRP = '124';
                    ICab.VKGRP = '010'; 
                    ICab.VKBUR = 'BR00';
                }
                if(o.Account.Grupo_de_cuentas__c == 'CMEX')
                    ICab.VKBUR = 'BR04';
                //}else{
                    //Oficina de Ventas
                    //if (o.Sucursal__c.substring(0,4) == '0094')
                    //   ICab.VKBUR = 'BR01';
                   
                    //if (o.Sucursal__c.substring(0,4) == '0095')
                    //   ICab.VKBUR = 'BR02';
                //}
            }else{
                step = 'Incoterms NC 0';
                if (o.Pedido_Relacionado__c != null){
                    Opportunity op_aux = [Select Nro_Pedido_SAP__c, Sector__c, Canal_de_Distribucion__c, Condicion_de_Pago__c, Account.Responsavel__c, Account.Region__r.Oficina_Ventas__c, Sucursal__c, Owner.Codigo_SAP__c, Owner.Profile.Name, Invierno__c, Account.Grupo_de_cuentas__c From Opportunity Where Id = : o.Pedido_Relacionado__c];
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
                    
                    ICab.VKBUR = 'BR01';
                    if(op_aux.Account.Region__r.Oficina_Ventas__c != null) ICab.VKBUR = op_aux.Account.Region__r.Oficina_Ventas__c.trim();
                    if(i.PricebookEntry.Product2.Variedade__r.Licenciada__c){
                        //ICab.VKGRP = '124';   
                        ICab.VKGRP = '010';
                        ICab.VKBUR = 'BR00';
                    }
                    if(op_aux.Account.Grupo_de_cuentas__c == 'CMEX')
                        ICab.VKBUR = 'BR04';
                    //}else{
                        //Oficina de Ventas
                        //if (op_aux.Sucursal__c.substring(0,4) == '0094')
                        //   ICab.VKBUR = 'BR01';
                       
                        //if (op_aux.Sucursal__c.substring(0,4) == '0095')
                        //   ICab.VKBUR = 'BR02';
                    //}
                    //ICab.VGBEL = String.valueOf(Integer.valueOf(op_aux.Nro_Pedido_SAP__c));
                    step = 'Incoterms NC 4';        
                    ICab.VGBEL = op_aux.Nro_Pedido_SAP__c;  
                    ICab.AUGRU = o.Motivo_de_Pedido__c.substring(0,3);      
                    ICab.AUGRU = ICab.AUGRU.trim();
                }                                
                
            }    
            //ICab.VKGRP = '095';//BORRAR
            if(o.Vencimiento_Anexo__c != null && o.Condicion_de_Pago__c.substring(0,4) == 'ZC02'){ 
                ICab.VALDT = String.valueOf(o.Vencimiento_Anexo__c).substring(0,10);
            }else{
                o.Vencimiento_Anexo__c = null;
            }      
            
            if(o.Cuenta_y_Orden__r.CodigoSAP__c != null)
                ICab.Bstzd = 'C/OR';                             
            
            o.Sector__c = ICab.SPART;
            o.Canal_de_Distribucion__c = ICab.VTWEG;                                
            
            //Clase de documento de ventas
            ICab.AUART = tipo;                                                      
            System.debug('Mensaje 3');
            retCabe.ret = true;
            retCabe.cab = ICab;            
            
        }
        catch(Exception e){
            retCabe.ret = false;
            retCabe.msg += 'Detalle: ' + step + '\nError: ' + e.getMessage();
            System.debug('Detalle: ' + step + '\nError: ' + e.getStackTraceString());
            System.debug('Detalle: ' + step + '\nError: ' + e.getMessage());
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
            sapAltaPedido2.ZSSD_PEDIDO_POS_TAB TPos = new sapAltaPedido2.ZSSD_PEDIDO_POS_TAB();
            TPos.item = new List<sapAltaPedido2.ZSSD_PEDIDO_POS>();//BORRAR
            
            for(OpportunityLineItem i : OppIts)                
                oppItMap.put(i.Id, i.PricebookEntry.Product2);            
                        
            for(OpportunityLineItem i : OppIts){
                sapAltaPedido2.ZSSD_PEDIDO_POS IPos = new sapAltaPedido2.ZSSD_PEDIDO_POS();
                
                IPos.ZZPOSSF = i.Id;
                IPos.VGPOS = '';  
                
                if (tipoNV == 'ZC01' || o.RecordType.Name == 'CVB Pendiente')              
                    IPos.VGPOS = i.Posicion_SAP_Relacionada__c;
                step='CrearPos 2';               
                if(o.Origen__r.Codigo_SAP__c != null){
                    IPos.WERKS = o.Origen__r.Codigo_SAP__c.trim();
                }else{            
                    //Centro de despacho
                    if (sucursal != null) {
                        if (sucursal.substring(0,4) == '0094')
                            IPos.WERKS = 'B001';                                
                        
                        if (sucursal.substring(0,4) == '0095')
                            IPos.WERKS = 'B002';   
                    }
                }
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
                
                IPos.MVGR4 = '';
                //11.01.22 comentado if(vBas && (tipoNV == 'ZO12' || tipoNV == 'ZBRG') && i.Tratamiento_de_Semilla__c != null && i.Tratamiento_de_Semilla__c != '') IPos.MVGR4 = i.Tratamiento_de_Semilla__c.substring(0,3);
                //Unidad de medida de venta, se reemplaza por el de las condiciones
                IPos.VRKME = '';
                
                //Codigo de material de SAP, sale del producto Codigo.
                IPos.MATNR = oppItMap.get(i.Id).Codigo_material_SAP__c;
                                
                //Nro de Contrato
                if (i.Contrato_Relacionado__c != null)
                    IPos.BSTKD_E = i.Contrato_Relacionado__r.Name;
                    
                if(o.Cuenta_y_Orden__r.CodigoSAP__c != null)
                    IPos.Pstyv = 'Z001';
                
                //Agregado Jere 17.06.19
                if(tipoNV == 'ZO12' && o.Tipo_saida_de_deposito__c != null)
                    IPos.Pstyv = o.Tipo_saida_de_deposito__c.substring(0,4);
                                
                TPos.item.add(IPos);
                
                index++;
            }
            retPos.TPos = TPos;
            retPos.ret = true;
            return retPos;
        
        }catch(Exception e){
                    
            retPos.ret = false;
            retPos.msg = e.getMessage();
            System.debug('Detalle: ' + step + '\nError: ' + e.getMessage());
            System.debug('Detalle: ' + step + '\nError: ' + e.getStackTraceString());
            return retPos;
        }
    }
    
    public static RetCabecera crearConds(List<OpportunityLineItem> OppIts, String tipo, Decimal Tipo_de_Cambio, String ofiVentas, String tipo_cuenta, Boolean vBas, Boolean inv, Opportunity op){
        RetCabecera retPos = new RetCabecera();
        Integer index = 0;
        String step = '';       
        try{
            step='CrearConds 1';            
            sapAltaPedido2.ZSSD_PEDIDO_COND_TAB TCond = new sapAltaPedido2.ZSSD_PEDIDO_COND_TAB();
            TCond.item = new List<sapAltaPedido2.ZSSD_PEDIDO_COND>();

            for(OpportunityLineItem i : OppIts){
                step='CrearConds 2';
                // Tema precios está complicado. Validar con Cecilia, Juan y Santiago.
                if(!vBas){
                    if (tipo == 'ZO02' || tipo_cuenta == 'CMEX'){
                        if(i.Precio_Contrato__c == 0 || i.Precio_Contrato__c == null) i.UnitPrice = i.PriceBookEntry.UnitPrice;
                        else i.UnitPrice = i.Precio_Contrato__c;
                    }else{
                        if(i.Precio_Contrato__c == 0 || i.Precio_Contrato__c == null) i.UnitPrice = i.PriceBookEntry.UnitPrice * Tipo_de_Cambio;
                        else i.UnitPrice = i.Precio_Contrato__c * Tipo_de_Cambio;
                    }
                }                                  
                step='CrearConds 3';
                Decimal ZPRN = 0.0;
                Double com = i.UnitPrice;                                
                
                ZPRN = Decimal.valueOf(com);
                ZPRN = ZPRN.divide(1, 2, System.RoundingMode.HALF_EVEN);
                
                i.UnitPrice = ZPRN;  
                i.Precio_SAP__c = ZPRN;            
                
                //Decimal anticipo = 0.0;
                //if (op.Valor_antecipado__c != null)
                //    anticipo = op.Valor_antecipado__c;  
                                
                sapAltaPedido2.ZSSD_PEDIDO_COND ICond1 = new sapAltaPedido2.ZSSD_PEDIDO_COND();
                ICond1.ZZPOSSF = i.Id;
                
                //String tipo_aux = tipo;
                //if (tipo_p_rel != '')
                //   tipo_aux = tipo_p_rel;
                   
                ICond1.KSCHL = 'ZPRE';
                if (tipo_cuenta == 'CMEX' && !vBas)
                    ICond1.KSCHL = 'ZBRU';
                                    
                //ICond1.Kbetr = String.valueOf(ZPRN);
                //ICond1.Kbetr = String.valueOf(ZPRN * 10000);//24/11/2015 los precios van a bajar * 10mil unidades
                    
                if (ICond1.KSCHL == 'ZPRE' && (i.PriceBookEntry.Product2.Sector__c == '02' || i.PriceBookEntry.Product2.Sector__c == '06')){
                    Decimal tasaCofins = 0;
                    Decimal tasaIss = 0;
                    Decimal tasaPis = 0;
                   
                    for (Configuracion_BMX__c conf : [Select Londrina_Tasa_COFINS__c, Londrina_Tasa_ISS__c, Londrina_Tasa_PIS__c, Passo_Fundo_Tasa_COFINS__c, Passo_Fundo_Tasa_ISS__c, Passo_Fundo_Tasa_PIS__c From Configuracion_BMX__c limit 1]){
                        if (ofiVentas == 'BR02'){
                            if (conf.Londrina_Tasa_COFINS__c != null)
                                tasaCofins = conf.Londrina_Tasa_COFINS__c;
                            if (conf.Londrina_Tasa_ISS__c != null)
                                tasaIss = conf.Londrina_Tasa_ISS__c;    
                            if (conf.Londrina_Tasa_PIS__c != null)
                                tasaPis = conf.Londrina_Tasa_PIS__c; 
                        }           
                        if (ofiVentas == 'BR01'){
                            if (conf.Passo_Fundo_Tasa_COFINS__c != null)
                                tasaCofins = conf.Passo_Fundo_Tasa_COFINS__c;
                            if (conf.Passo_Fundo_Tasa_ISS__c != null)
                                tasaIss = conf.Passo_Fundo_Tasa_ISS__c;    
                            if (conf.Passo_Fundo_Tasa_PIS__c != null)
                                tasaPis = conf.Passo_Fundo_Tasa_PIS__c; 
                        } 
                    }
                    Decimal precioLiquido = 0;
                    if(vBas){
                        precioLiquido = i.Precio_SAP_Estimado__c;                                                                                 
                        //precioLiquido = precioLiquido.divide(1, 2, System.RoundingMode.HALF_EVEN);
                        i.Observaciones_Tasas__c = 'COFINS: ' + string.valueOf(tasaCofins) + '% -- ISS: ' + string.valueOf(tasaIss) + '% -- PIS: ' + string.valueOf(tasaPis) + '%';
                        if(inv) i.Observaciones_Tasas__c = 'COFINS: 3% -- ISS: 0% -- PIS: 0,65%'; 
                    }else{
                        Decimal sumaTasas = tasaCofins + tasaIss + tasaPis; 
                        
                        i.Tasas__c = sumaTasas;
                        i.Observaciones_Tasas__c = 'COFINS: ' + string.valueOf(tasaCofins) + '% -- ISS: ' + string.valueOf(tasaIss) + '% -- PIS: ' + string.valueOf(tasaPis) + '%';
                                                                                                                         
                        precioLiquido = i.UnitPrice - (i.UnitPrice * sumaTasas / 100);                                                                                 
                        //precioLiquido = precioLiquido.divide(1, 2, System.RoundingMode.HALF_EVEN);
                    }
                    i.Precio_SAP__c = precioLiquido;
                                        
                    //ICond1.Kbetr = String.valueOf(precioLiquido);
                    ICond1.Kbetr = String.valueOf((precioLiquido * 10000).divide(1, 2, System.RoundingMode.HALF_EVEN));//24/11/2015 los precios van a bajar * 10mil unidades
                                  
                }
                if ((tipo == 'ZO12' || tipo == 'ZO03' || tipo == 'ZBRG' || tipo == 'ZO10' || (tipo == 'ZO02' && vBas)) && ICond1.KSCHL == 'ZPRE' ){
                    step='CrearConds 5';
                    Decimal precioLiquido = i.Precio_Liquido__c;                                                                                 
                    //precioLiquido = precioLiquido.divide(1, 2, System.RoundingMode.HALF_EVEN);
                    
                    i.Precio_SAP__c = precioLiquido;
                                        
                    //ICond1.Kbetr = String.valueOf(precioLiquido);
                    ICond1.Kbetr = String.valueOf((precioLiquido * 10000).divide(1, 2, System.RoundingMode.HALF_EVEN));//24/11/2015 los precios van a bajar * 10mil unidades
                    step='CrearConds 6'; 
                }                   
                ICond1.KMEIN = '';                
                //ICond1.Kpein = '1';
                ICond1.Kpein = '10000'; //24/11/2015 los precios van a bajar * 10mil unidades
                TCond.item.add(ICond1);
                
                if (i.Desconto_Total_Unidade__c != null && i.Desconto_Total_Unidade__c != 0){
                    sapAltaPedido2.ZSSD_PEDIDO_COND ICond2 = new sapAltaPedido2.ZSSD_PEDIDO_COND();
                    ICond2.ZZPOSSF = i.Id;
                    ICond2.KSCHL = 'ZDEA';
                    ICond2.KMEIN = '';                
                    ICond2.Kpein = '10000';                    
                    ICond2.Kbetr = String.valueOf((i.Desconto_Total_Unidade__c * -1 * 10000).divide(1, 2, System.RoundingMode.HALF_EVEN));
                    
                    TCond.item.add(ICond2);
                    
                    Decimal anticipo = 0.0;
                    if (i.Valor_antecipado__c != null && i.Valor_antecipado__c > 0){                    
                        anticipo = i.Valor_antecipado__c;
                        sapAltaPedido2.ZSSD_PEDIDO_COND ICond6 = new sapAltaPedido2.ZSSD_PEDIDO_COND();
                        ICond6.ZZPOSSF = i.Id;
                        ICond6.KSCHL = 'ZDEB';
                        ICond6.KMEIN = '';                
                        ICond6.Kpein = '';
                        ICond6.WAERS = 'BRL';
                        ICond6.Kbetr = String.valueOf((anticipo).divide(1, 2, System.RoundingMode.HALF_EVEN));                                        
                        TCond.item.add(ICond6);
                    }
                    
                    /*if (porc_anticipo3 > 0){
                        sapAltaPedido2.ZssdPedidoCond ICond4 = new sapAltaPedido2.ZssdPedidoCond();
                        ICond4.ZZPOSSF = i.Id;
                        ICond4.KSCHL = 'ZDES';
                        ICond4.KMEIN = '';                
                        ICond4.Kpein = '';
                        ICond4.Kbetr = String.valueOf(porc_anticipo3 * -1);                                        
                        TCond.item.add(ICond4);
                    }*/
                    
                }
                
                if (i.Descuento_porc__c != null && i.Descuento_porc__c != 0){                
                    sapAltaPedido2.ZSSD_PEDIDO_COND ICond3 = new sapAltaPedido2.ZSSD_PEDIDO_COND();
                    ICond3.ZZPOSSF = i.Id;
                    ICond3.KSCHL = 'ZDES';                                              
                    ICond3.KMEIN = '';                
                    ICond3.Kpein = '';                    
                    ICond3.Kbetr = String.valueOf((i.Descuento_porc__c) * -1);                    
                    
                    TCond.item.add(ICond3);
                    
                    Decimal anticipo = 0.0;
                    if (i.Valor_antecipado__c != null && i.Valor_antecipado__c > 0){                    
                        anticipo = i.Valor_antecipado__c;
                        sapAltaPedido2.ZSSD_PEDIDO_COND ICond4 = new sapAltaPedido2.ZSSD_PEDIDO_COND();
                        ICond4.ZZPOSSF = i.Id;
                        ICond4.KSCHL = 'ZDEB';
                        ICond4.KMEIN = '';                
                        ICond4.Kpein = '';
                        ICond4.WAERS = 'BRL';
                        ICond4.Kbetr = String.valueOf((anticipo).divide(1, 2, System.RoundingMode.HALF_EVEN));                                        
                        TCond.item.add(ICond4);
                    }
                }
                
                if ((i.Desconto_Total_Unidade__c == null || i.Desconto_Total_Unidade__c == 0) && (i.Descuento_porc__c == null || i.Descuento_porc__c == 0)){
                    sapAltaPedido2.ZSSD_PEDIDO_COND ICond5 = new sapAltaPedido2.ZSSD_PEDIDO_COND();
                    ICond5.ZZPOSSF = i.Id;
                    ICond5.KSCHL = 'ZDEB';
                    ICond5.KMEIN = '';                
                    ICond5.Kpein = '';
                    ICond5.WAERS = 'BRL';
                    Decimal anticipo = 0.0;
                    if (i.Valor_antecipado__c != null && i.Valor_antecipado__c > 0){                    
                        ICond5.Kbetr = String.valueOf((i.Valor_antecipado__c).divide(1, 2, System.RoundingMode.HALF_EVEN));                
                        TCond.item.add(ICond5);     
                    }                    
                }
                
            }                                                            
                                               
            retPos.TCond = TCond;
            retPos.ret = true;
            return retPos;
        }
        catch(Exception e){         
            retPos.ret = false;
            retPos.msg = e.getMessage();
            System.debug('Detalle: ' + step + '\nError: ' + e.getMessage());
            System.debug('Detalle: ' + step + '\nError: ' + e.getStackTraceString());
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
        system.debug('>>> RESULT! ' + Opp_SAP_Alta.crearPos(new List<OpportunityLineItem>{opli1, opli2}, 'DMAR', 'NONE', 'ZPLO', o, false));
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
        
        Opp_Sap_Alta.enviarSAP(o.Id, o.StageName, 110);
        Account acc = New Account(Name='Prueba', Esta_en_sap__c = true, CodigoSap__c = '1234567890', Responsavel__c = '061 - OPEN');
        insert acc;
        o.AccountId = acc.Id;
        update o;
        Opp_Sap_Alta.enviarSAP(o.Id, o.StageName, 110);  
        Boolean ok = Opp_Sap_Alta.setEtapaAU(o);      
        system.debug('>>> GO!');
        system.debug('>>> RESULT! ' + Opp_SAP_Alta.crearConds(new List<OpportunityLineItem>{opli1}, 'XXX', o.Tipo_de_Cambio__c, 'BR01', 'ZBSE', false, false, o));
        
        Opp_SAP_Alta.crearConds(new List<OpportunityLineItem>{opli1}, 'XXX', o.Tipo_de_Cambio__c, 'BR02', 'ZBSE', false, false, o);
        
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
        oppVB.Tipo__c = 'ZC01 - Solicit. Nota de Cred.';
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
        
        Opp_Sap_Alta.enviarSAP(oppVB.Id, oppVB.StageName, 110);
        
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
        Opp_SAP_Alta.ofiVentas('04');
        Opp_SAP_Alta.ofiVentas('07');
        
        Opp_SAP_Alta.ofiVentas('01');
        Opp_SAP_Alta.ofiVentas('04');
        Opp_SAP_Alta.ofiVentas('07');
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
 
        Opp_Sap_Alta.crearConds(new List<OpportunityLineItem>{oi25Prueba}, 'ZBEX', 2.01, 'BR01', 'ZBSE', false, false, prevision5);
        
        Opp_Sap_Alta.enviarSAP(prevision5.Id, prevision5.StageName, 110);
        
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
        
        
        Opportunity prevision4 = New Opportunity(Sucursal__c = '0095 Londrina',Condicion_de_Pago__c = 'ZC68 - A vista - 15 de Dezembro', Canal_de_Distribucion__c = '01',Sector__c = '02',Nro_Pedido_SAP__c = '34344',Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prevision4;
        PricebookEntry pbe4 = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi24 = new OpportunityLineItem(OpportunityId=prevision4.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe4.Id);
        insert oi24;
        
        Opportunity oppVB = New Opportunity(AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13', Name='Prueba 3',RecordTypeId = rt_VBAU.Id,Tipo__c='ZBVN - Venda Normal', Origen__c=cl.Id, Responsable__c='061 - Fernando Frenher', Condicion_de_Pago__c='ZC68 - A vista - 15 de Dezembro', Destinatario_de_Mercaderia__c =dest.Id);
        insert oppVB;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=oppVB.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi2;



        /*
        oppVB.Pedido_Relacionado__c = prevision4.Id;
        oppVB.Tipo__c = 'ZBNC - Solicit. Nota de Cred.';
        update oppVB;
        Opp_Sap_Alta.enviarSAP(oppVB.Id, oppVB.StageName, 110);
        
        Opportunity opor = [Select Id, RecordTypeId, StageName From Opportunity Where RecordType.Name = 'NC - Pendiente' And StageName = 'PE - Pendiente' limit 1];
        Opp_Sap_Alta.setEtapaNC_AU(opor);
        
        List<OpportunityLineItem> itms = [Select Id, PricebookEntry.Product2.Sector__c, UnitPrice, Precio_SAP__c, Precio_SAP_Estimado__c, Observaciones_Tasas__c, Tasas__c, Precio_Liquido__c, Descuento_porc__c From OpportunityLineItem Where PricebookEntry.Product2.Sector__c = '02' limit 1];
        Opp_SAP_Alta.crearConds(itms, 'ZBSE', 2, 'BR01', 'CPJU', true, true);
        */
    }  
}
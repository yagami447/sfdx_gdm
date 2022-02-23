global class sapFlujoDoc_caller {

    Webservice static string consultarFlujoDoc(){
        List<Bitacora_NC__c> regBitacora = [SELECT Id, vbtyp__c,fkart__c,Fecha_Desde__c, Fecha_Hasta__c, numero_lote__c, sociedad__c, Iniciar_AcItems__c 
        FROM Bitacora_NC__c where numero_lote__c > 0 order by orden__c];        
        for(Bitacora_NC__c b : regBitacora)
            procesos(b.Id, b.sociedad__c, b.vbtyp__c, b.fkart__c,b.fecha_desde__c, b.Fecha_Hasta__c, Integer.valueOf(b.numero_lote__c)+1, b.Iniciar_AcItems__c);

        return 'Termino';
    }

    @future(callout=true)
    webservice static void procesos(Id bitId, String arg_bukrs, String arg_vbtyp, String arg_fkart,Date arg_desde,Date arg_hasta, Integer arg_nro_lote, Boolean runAc){
        SavePoint sp;
        Decimal cantidadSAP = 0; Decimal cantidadSF = 0;
        String sociedad;
        
        List<Flujo_Doc_tmp__c> tmps = new List<Flujo_Doc_tmp__c>();
        try{
            Integer mandanteSAP = 1;
            Configuracion_BMX__c c = [Select FC_Mandante_SAP__c From Configuracion_BMX__c Where Name = 'Facturacion' limit 1];
            if(c != null && c.FC_Mandante_SAP__c != null)
                mandanteSAP = Integer.valueOf(c.FC_Mandante_SAP__c);
            sociedad = arg_bukrs;
            
            Date hasta = arg_hasta;
            if(arg_hasta==null)
                hasta = system.today().addDays(-1);            
            Date desde = arg_desde;
            
            String s_ayer_mes = String.valueOf(desde.month());
            String s_hoy_mes = String.valueOf(hasta.month());
            String s_ayer_dia = String.valueOf(desde.day());
            String s_hoy_dia = String.valueOf(hasta.day());
            if (Integer.valueOf(s_ayer_mes) < 10)
              s_ayer_mes = '0' + s_ayer_mes;
            if (Integer.valueOf(s_ayer_dia) < 10)
              s_ayer_dia = '0' + s_ayer_dia;
            if (Integer.valueOf(s_hoy_mes) < 10)
              s_hoy_mes = '0' + s_hoy_mes;
            if (Integer.valueOf(s_hoy_dia) < 10)
              s_hoy_dia = '0' + s_hoy_dia;

            String s_ayer = desde.year() + '-' + s_ayer_mes + '-' + s_ayer_dia;
            String s_hoy = hasta.year() + '-' + s_hoy_mes + '-' + s_hoy_dia;

            sapFlujoDoc2.ZSD_FLUJO_DOC_2 soap = New sapFlujoDoc2.ZSD_FLUJO_DOC_2();
            sapFlujoDoc2.ZSD_FLUJO_DOC_2Response_element result = New sapFlujoDoc2.ZSD_FLUJO_DOC_2Response_element();
            sapFlujoDoc2.isApexTest = Test.isRunningTest();

            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;

            String myData = 'SALESFORCEBR:2o21gdms33dS';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 120000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);            
           
                       
            result = soap.ZSD_FLUJO_DOC_2(null,arg_bukrs,s_ayer,s_hoy,arg_fkart,'00:00:00','23:59:59',arg_vbtyp,mandanteSAP);
            if (result != null){
                if (result.E_FLUJO_DOC != null){
                    if (result.E_FLUJO_DOC.item != null){
                        sp=Database.setSavepoint();
                        cantidadSAP = result.E_FLUJO_DOC.item.size();
                        for (sapFlujoDoc2.ZSSD_FLUJO_DOC t : result.E_FLUJO_DOC.item){
                            Flujo_Doc_tmp__c doc = new Flujo_Doc_tmp__c();
                            doc.FKART__c = t.Fkart;
                            doc.FKIMG__c = decimal.valueOf(t.Fkimg);
                            doc.NETWR__c = decimal.valueOf(t.Netwr);
                            doc.SFAKN__c = t.sfakn;
                            doc.POSNV__c= t.Posnv;
                            doc.VBELV__c = t.Vbelv;
                            doc.VBTYP__c = arg_vbtyp;
                            doc.XBLNR__c = t.Xblnr;
                            doc.WAERK__c = t.Waerk;
                            doc.VRKME__c = t.vrkme;
                            doc.ZZPOSSF__c = t.Zzpossf;
                            doc.numero_lote__c = arg_nro_Lote;
                            doc.Fecha_Desde__c= desde;
                            doc.Fecha_Hasta__c= hasta;
                            tmps.add(doc);
                        }
                        insert tmps;
                        cantidadSF = tmps.size();
                    }
                } 
            }
           Bitacora_nc__c bit = new Bitacora_nc__c(Id=bitId,Fecha_desde__c=hasta+1,Cantidad_Registros_SAP__c=cantidadSAP,Cantidad_Registros_SF__c=cantidadSF,numero_lote__c=arg_nro_lote,Copiado_desde_sap__c=true);
           update bit;


        }
        catch(Exception e){
            if(sp == null )
              sp=Database.setSavepoint();
            Database.rollback(sp);
            Bitacora_nc__c bit = new Bitacora_nc__c(Id=bitId,Log__c=e.getMessage(),numero_lote__c=arg_nro_lote,Cantidad_Registros_SAP__c=cantidadSAP,Cantidad_Registros_SF__c=0,Copiado_desde_sap__c=false);
            update bit;
        }

         if(runAc)
            actItems();
        
    }

    webservice static void actItems(){
        try{
            List<Id> itemIds = new List<Id>();
            List<String> itemRef = new List<String>();
            List<Flujo_Doc_tmp__c> fdocs_up = new List<Flujo_Doc_tmp__c>();
            
            OpportunityLineItem item;

            Map <Id, OpportunityLineItem> mapItems = New Map <Id, OpportunityLineItem>();
            Map <Id, Id> mapItemsOk = New Map <Id, Id>();
            Map <String, Flujo_Doc_tmp__c> mapFlujoAnul = New Map <String, Flujo_Doc_tmp__c>();
             
            List<Flujo_Doc_tmp__c> fdocs = [Select Id, ZZPOSSF__c, ActualizadoEnOpLineItem__c,SFAKN__c,FKART__c,WAERK__c,FKIMG__c,VBTYP__c,NETWR__c,XBLNR__c,VRKME__c
                            From Flujo_Doc_tmp__c where ActualizadoEnOpLineItem__c = false and ZZPOSSF__c <> ''];            
            for(Flujo_Doc_tmp__c f : fdocs){
                system.debug('JERE::: Agrego '+ f.XBLNR__c + ',' + f.VBTYP__c );
                itemIds.add(f.ZZPOSSF__c); // traigo los id de los OpportunityLineItem a actualizar                
                if(f.VBTYP__c == 'S')
                    itemRef.add(f.SFAKN__c);
            }

            system.debug('Entro al metodo actItems, en itemIds List size: '+itemIds.size());
                        
            List<OpportunityLineItem> items = new List<OpportunityLineItem>();
            List<OpportunityLineItem> items_up = new List<OpportunityLineItem>();
            items = [Select Id, Bls_devolucion__c, PricebookEntry.Product2.Cantidad_sub_unidad__c  from OpportunityLineItem where Id in :itemIds];
            for(OpportunityLineItem item2 : items){
                mapItems.put(item2.Id,item2);
            }            
            system.debug('Luego de cargar el mapa de items: '+ mapItems.size());
            
            Decimal bls = 0;           
                
            List<Flujo_Doc_tmp__c> fdocAnul = [Select Id, FKART__c, FKIMG__c, XBLNR__c, VBTYP__c 
            From Flujo_Doc_tmp__c where VBTYP__c <> 'S' and ZZPOSSF__c <> '' and XBLNR__c in :itemRef];
            
            for(Flujo_Doc_tmp__c f : fdocAnul){                    
                mapFlujoAnul.put(f.XBLNR__c,f);
                system.debug('JERE::: Mapeo '+ f.XBLNR__c + ',' + f.VBTYP__c );
            }
            
            for(Flujo_Doc_tmp__c documento : fdocs){
                if(mapItems.containsKey(documento.ZZPOSSF__c)){
                    item = mapItems.get(documento.ZZPOSSF__c);
                    
                    bls = item.Bls_devolucion__c == null ? 0 : item.Bls_devolucion__c;
                    
                    if ('ZBDE' == documento.FKART__c || 'ZBDF' == documento.FKART__c || 'ZBDG' == documento.FKART__c || 'ZBDP'== documento.FKART__c || 'ZBDR' == documento.FKART__c || 'ZBDS' == documento.FKART__c) {
                        item.Bls_devolucion__c = bls + documento.FKIMG__c;
                    }
                    
                    //Pensado para anulaciones
                    if ('S2' == documento.FKART__c ) {
                        Flujo_Doc_tmp__c documentoA = mapFlujoAnul.get(documento.SFAKN__c);
                        if(documentoA == null)
                            continue;
                        if ('ZBDE' == documentoA.FKART__c || 'ZBDF' == documentoA.FKART__c || 'ZBDG' == documentoA.FKART__c || 'ZBDP'== documentoA.FKART__c || 'ZBDR' == documentoA.FKART__c || 'ZBDS' == documentoA.FKART__c)
                            item.Bls_devolucion__c = bls - documento.FKIMG__c;
                    }
                    system.debug('DOCUMENTO ACTUAL:::'+ documento.FKART__c +','+ documento.VBTYP__c + ', Id: ' + item.Id);
                }
            }
           
            List<Database.SaveResult> srs = Database.update(items,false);
            system.debug('SaveResult update items bls_devolucion antes de ActualizadoEnOpLineItem__c ');
            for (Database.SaveResult sr : srs){
                if (sr.isSuccess()) {
                    mapItemsOk.put(sr.Id,sr.Id);
                }
            }
            
            for(Flujo_Doc_tmp__c docum : fdocs){
                if(mapItemsOk.containsKey(docum.ZZPOSSF__c)){
                    Flujo_Doc_tmp__c ff = new Flujo_Doc_tmp__c(Id=docum.Id,ActualizadoEnOpLineItem__c=true);
                    fdocs_up.add(ff);
                }                 
            }
            update fdocs_up;

        }catch(Exception ex){
              system.debug('ERROR en actualizar OpportunityLineItem::: Mas raro que perro verde' + ex.getMessage());
        }
    }
   
}
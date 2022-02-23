global class Opp_SAP_Mod {

    global class Retorno {
        webservice String msg;
        webservice Boolean ret;
        Webservice String pedido;
    }

    private class RetPos {
        String msg;
        Boolean ret;
    }

    WebService static String[] statusSAP(Id oppId, String etapa, Integer target, Boolean rechazar_y_liberar, Boolean dev) {
        String[] Retornar = new String[2];
        Retornar[1] = 'false';
        Retorno r = new Retorno();
        Retorno r1 = new Retorno();
        String[] retornoOferta = new String[2];
        sapStatusPedido.ZSdStatusPedidoResponse_element resultado;
        r.msg = '\n';

        try {
            Opportunity o = [
                SELECT Id, Nro_Pedido_SAP__c, PE_Bajar_SAP__c, RecordTypeId, RecordType.Name , StageName, Observaciones_Paso_a_SAP__c FROM Opportunity WHERE Id = :oppId
            ];

            sapStatusPedido.Z_SD_STATUS_PEDIDO soap = new sapStatusPedido.Z_SD_STATUS_PEDIDO();
            sapStatusPedido.ZssdPedidoStatus pedidoStatus = new sapStatusPedido.ZssdPedidoStatus();

            if (etapa == 'RR') {
                if (LiberarItems(o.Id)) {
                    if (setEtapaRR(o)) {
                        Retornar[1] = 'true';
                        Retornar[0] = 'Nueva Etapa: RR - Rechazada para Revision';
                        return Retornar;
                    }
                }
            }

            if (o.Nro_Pedido_SAP__c == null || o.Nro_Pedido_SAP__c == '') {
                Retornar[1]='false';
                Retornar[0]='La Nota de Venta no ha sido descargada a SAP aún. Actualización solo en SF';
                return Retornar;
            }

            if (dev == true) {
                if (setEtapaRE(o)) {
                    System.debug('Paso 3');
                    if (rechazar_y_liberar) {
                        System.debug('Paso 4');
                        System.debug(o.RecordType.Name);
                        if (o.RecordType.Name == 'CVB Autorizada') {
                            System.debug('Paso 5');
                            //retornoOferta = Opp_Utils.actualizarPasoVBSAP(o.Id, true);

                            if (retornoOferta[1] != 'OK') {
                                o.Observaciones_Paso_a_SAP__c = o.Observaciones_Paso_a_SAP__c + retornoOferta[0];
                                Retornar[1] = 'false';
                                Retornar[0] += '\nNueva Etapa: RE - Rechazada por Facturacion(Devolução) --- Error al actualizar Oferta';
                            } else {
                                Retornar[1] = 'false';
                                Retornar[0] += '\nNueva Etapa: RE - Rechazada por Facturacion(Devolução) --- Oferta Actualizada';
                            }
                        }
                    }
                } else {
                    Retornar[1] = 'false';
                    Retornar[0] += '\nError en etapa';
                }
            }

            if (etapa == 'RE') {
                pedidoStatus.ABGRU = 'Z2'; // Rechazo RE                
                pedidoStatus.FAKSK = '';
                pedidoStatus.LIFSK = '';

                String INroPedido = o.Nro_Pedido_SAP__c;

                soap.inputHttpHeaders_x = new Map<String, String>();
                String encodedusernameandpassword;

                String myData = 'SALESFORCEBR:2o21gdms33dS';
                Blob hash = Blob.valueOf(myData);
                encodedusernameandpassword = EncodingUtil.base64Encode(hash);
                soap.timeout_x = 60000;
                soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);

                String STarget = String.valueof(target);

                resultado = soap.ZSdStatusPedido(INroPedido, pedidoStatus, STarget);
                System.debug('Paso 1');
                Integer i;

                if (!Test.isRunningTest()) {
                    for (i=0;i<resultado.TReturn.item.size();i++) {
                        Retornar[0] = resultado.TReturn.item[i].Message;
                    }
                }

                if (resultado.ESubrc == 0) {
                    System.debug('Paso 2');               
                    if (setEtapaRE(o)) {
                        System.debug('Paso 3');
                        if (rechazar_y_liberar) {
                            System.debug('Paso 4');
                            System.debug(o.RecordType.Name);
                            if (o.RecordType.Name == 'CVB Autorizada') {
                                System.debug('Paso 5');
                                //retornoOferta = Opp_Utils.actualizarPasoVBSAP(o.Id, true);
                                actualizarRechazoItems(o.Id);

                                if (retornoOferta[1] != 'OK') {
                                    o.Observaciones_Paso_a_SAP__c = o.Observaciones_Paso_a_SAP__c + retornoOferta[0];
                                    Retornar[1] = 'false';
                                    Retornar[0] += '\nNueva Etapa: RE - Rechazada por Facturacion --- Error al actualizar Oferta';
                                } else {
                                    Retornar[1] = 'false';
                                    Retornar[0] += '\nNueva Etapa: RE - Rechazada por Facturacion --- Oferta Actualizada';
                                }
                            }

                            if (o.RecordType.Name != 'CVB Rechazada' && LiberarItems(o.Id)) {                            
                                Retornar[1] = 'true';
                                Retornar[0] += '\nNueva Etapa: RE - Rechazada por Facturacion';
                            }
                        } else {
                            Retornar[1] = 'true';
                            Retornar[0] += '\nNueva Etapa: RE - Rechazada por Facturacion';  
                            Retornar[0] += '\n' + Opp_Utils.DuplicarPedido(o.Id);
                        }
                    } else {
                        Retornar[1] = 'false';
                        Retornar[0] += '\nError en etapa';
                    }
                } else {
                    Retornar[0] += '\nLa NV no paso a RE. ';
                    Retornar[1] = 'false';
                }
            }
        } catch (System.CalloutException ex) {
            Retornar[0] += '\nEn statusSAP - CallOutException: ' + ex.getMessage(); Retornar[1] = 'false';
        }

        return Retornar;
    }

    static Boolean setEtapaRE(Opportunity o) {
        String st_RE = 'RE - Rechazada por Facturacion';
        String rtName = 'Rechazada';
        if (o.RecordType.Name == 'NC - Autorizada' || o.RecordType.Name == 'NC - Pendiente') { rtName = 'NC - Rechazada'; }
        if (o.RecordType.Name == 'CVB Autorizada') { rtName = 'CVB Rechazada'; }
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = :rtName limit 1];

        o.StageName = st_RE;
        o.RecordTypeId = rt.Id;

        try {
            update o;
            return true;
        } catch (System.CalloutException ex) {
            return false;
        }
    }

    static Boolean setEtapaRR(Opportunity o) {
        String st_RE = 'RR - Rechazada para Revision';
        String rtName = 'Rechazada';
        if (o.RecordType.Name == 'NC - Autorizada' || o.RecordType.Name == 'NC - Pendiente') { rtName = 'NC - Rechazada'; }
        if (o.RecordType.Name == 'CVB Pendiente') {
            rtName = 'CVB Rechazada';
            st_RE = 'RE - Rechazada por Facturacion';
        }

        RecordType rt = [SELECT Id FROM RecordType WHERE Name = :rtName limit 1];

        o.StageName = st_RE;
        o.RecordTypeId = rt.Id;

        try {
            update o;
            return true;
        } catch (System.CalloutException ex) {
            return false;       
        }
    }

    static Boolean LiberarItems(Id oppId) {
        Set<Id> itemsIds = new Set<Id>();

        try {
            for (OpportunityLineItem item : [SELECT Id, Id_Item_de_Oportunidad_Relacionado__c FROM OpportunityLineItem WHERE OpportunityId = : oppId]) {
                itemsIds.add(item.Id_Item_de_Oportunidad_Relacionado__c);
            }

            if (itemsIds.size() > 0) {      
                List<OpportunityLineItem> items = [SELECT Id, Estado_Facturacion__c FROM OpportunityLineItem WHERE Id In : itemsIds];

                for (OpportunityLineItem i : items) {
                    i.Estado_Facturacion__c = '';
                }

                update items;         
            }

            return true;
        } catch (System.CalloutException ex) {
            return false;
        }
    }

    static void actualizarRechazoItems(Id oppId) {
        Set<Id> itemsIds = new Set<Id>();

        try {
            List<OpportunityLineItem> items = [SELECT Id, Motivo_de_Rechazo__c FROM OpportunityLineItem WHERE OpportunityId = : oppId];

            for (OpportunityLineItem i : items) {
                i.Motivo_de_Rechazo__c = 'Z2';
            }

            update items;
        } catch (System.CalloutException ex) {}
    }

    static testmethod void test() {
        Product2 px1 = new Product2(Name = 'Test 1', Especie__c = 'SOJA');
        insert px1;
        Pricebook2 s = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px1.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbesx;
        
        Account ac = new Account(Name='Prueba');
        insert ac;
        Opportunity o = new Opportunity(Name = 'Test 1', CloseDate = System.today(), StageName = 'Clientes potenciales', AccountId = ac.Id, Nro_Pedido_Sap__c = '123');
        insert o;
        OpportunityLineItem opli1 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 10, quantity = 1);
        insert opli1;
        
        Opp_SAP_Mod.setEtapaRE(o);
        Opp_SAP_Mod.setEtapaRR(o);
        
        Opp_SAP_Mod.LiberarItems(o.Id);

        Configuracion_BMX__c c = new Configuracion_BMX__c(link_intra_dm__c='www.intra-dm.com.ar:8080',Link_Sap_Prod__c='www.intra-dm.com.ar:8080'); //[SELECT link_intra_dm__c, Link_Sap_Prod__c FROM Configuracion_BMX__c limit 1];
        insert c;
        Opp_SAP_Mod.statusSAP(o.Id, 'RE', 110, false, false);
        Opp_SAP_Mod.statusSAP(o.Id, 'RR', 110, false, false);
    }

    static testmethod void test2() {
        Product2 px1 = new Product2(Name = 'Test 1', Especie__c = 'SOJA');
        insert px1;
        Pricebook2 s = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px1.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbesx;
        
        Account ac = new Account(Name='Prueba');
        insert ac;
        Opportunity o = new Opportunity(Name = 'Test 1', CloseDate = System.today(), StageName = 'Clientes potenciales', AccountId = ac.Id, Nro_Pedido_Sap__c = '123');
        insert o;
        OpportunityLineItem opli1 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 10, quantity = 1);
        insert opli1;
        
        Opp_SAP_Mod.setEtapaRE(o);
        Opp_SAP_Mod.setEtapaRR(o);
        
        Opp_SAP_Mod.LiberarItems(o.Id);

        Opp_SAP_Mod.statusSAP(o.Id, 'RR', 110, false, false);
    }

    static testmethod void test3() {
        Product2 px1 = new Product2(Name = 'Test 1', Especie__c = 'SOJA');
        insert px1;
        Pricebook2 s = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px1.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbesx;
        
        Account ac = new Account(Name='Prueba');
        insert ac;
        Opportunity o = new Opportunity(Name = 'Test 1', CloseDate = System.today(), StageName = 'Clientes potenciales', AccountId = ac.Id, Nro_Pedido_Sap__c = '123');
        insert o;
        OpportunityLineItem opli1 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 10, quantity = 1);
        insert opli1;
        
        Opp_SAP_Mod.setEtapaRE(o);
        Opp_SAP_Mod.setEtapaRR(o);
        
        Opp_SAP_Mod.LiberarItems(o.Id);

        Configuracion_BMX__c c = new Configuracion_BMX__c(link_intra_dm__c='www.intra-dm.com.ar:8080',Link_Sap_Prod__c='www.intra-dm.com.ar:8080'); //[SELECT link_intra_dm__c, Link_Sap_Prod__c FROM Configuracion_BMX__c limit 1];
        insert c;
        Opp_SAP_Mod.statusSAP(o.Id, 'RE', 110, false, true);
    }

    @isTest(SeeAllData=true)
    static  void test4() {
        Id rt_CVB;
        for(RecordType r: [SELECT Id FROM RecordType WHERE Name =  'CVB Autorizada']) rt_CVB = r.Id;         
        Product2 px1 = new Product2(Name = 'Test 1', Especie__c = 'SOJA');
        insert px1;
        Pricebook2 s = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px1.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbesx;
        
        Account ac = new Account(Name='Prueba');
        insert ac;
        Opportunity o = new Opportunity(Name = 'Test 1', RecordTypeId = rt_CVB, CloseDate = System.today(), StageName = 'Clientes potenciales', AccountId = ac.Id, Nro_Pedido_Sap__c = '123', Next_Step__c = 'Pepe');
        insert o;
        OpportunityLineItem opli1 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 10, quantity = 1);
        insert opli1;
        
        Opp_SAP_Mod.setEtapaRE(o);
        Opp_SAP_Mod.setEtapaRR(o);
        
        Opp_SAP_Mod.LiberarItems(o.Id); 
            
        Configuracion_BMX__c c = new Configuracion_BMX__c(link_intra_dm__c='www.intra-dm.com.ar:8080',Link_Sap_Prod__c='www.intra-dm.com.ar:8080'); //[SELECT link_intra_dm__c, Link_Sap_Prod__c FROM Configuracion_BMX__c limit 1];
        insert c;
        Opp_SAP_Mod.statusSAP(o.Id, 'RE', 110, false, true);
    }
    /*@isTest(SeeAllData=true)
    static  void test5() {
        Id rt_CVB;
        for(RecordType r: [SELECT Id FROM RecordType WHERE Name =  'Anexo I']) rt_CVB = r.Id;         
        Product2 px1 = new Product2(Name = 'Test 1', Especie__c = 'SOJA');
        insert px1;
        Pricebook2 s = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px1.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbesx;
        
        Account ac = new Account(Name='Prueba');
        insert ac;
        Opportunity o = new Opportunity(Name = 'Test 1', RecordTypeId = rt_CVB, CloseDate = System.today(), StageName = 'Pendiente Aprobacion', AccountId = ac.Id, Nro_Pedido_Sap__c = '123', Next_Step__c = 'Pepe');
        insert o;
        OpportunityLineItem opli1 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 10, quantity = 1);
        insert opli1;
        
        Opp_SAP_Mod.setEtapaRE(o);
        Opp_SAP_Mod.setEtapaRR(o);
        
        Opp_SAP_Mod.LiberarItems(o.Id);
            o.Next_Step__c = 'Solicitud Aprobacion';
            update o;   
            
        Configuracion_BMX__c c = new Configuracion_BMX__c(link_intra_dm__c='www.intra-dm.com.ar:8080',Link_Sap_Prod__c='www.intra-dm.com.ar:8080'); //[SELECT link_intra_dm__c, Link_Sap_Prod__c FROM Configuracion_BMX__c limit 1];
        insert c;
        Opp_SAP_Mod.statusSAP(o.Id, 'RE', 110, false, true);
    }*/
}
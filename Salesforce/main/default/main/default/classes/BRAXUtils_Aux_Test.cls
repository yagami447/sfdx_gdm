@isTest(SeeAllData=true)
private class BRAXUtils_Aux_Test {

    private static String rt_anexo_1_opps = '01240000000M7Lv';
    private static String rt_objContratoRoy = '012330000009mqZ';
    private static String rt_fac_brasmax_opps = '012400000000zQt';

    @isTest static void testCompleteAll(){

        RecordType rt = [Select Id
                         From RecordType
                         Where Name = 'BRMX' And SObjectType = 'Contrato__c'
                         limit 1];

        //        Account a = [Select Id From Account limit 1];
        Account a = new Account(Name = 'TMP');
        insert a;
        Pricebook2 pb = [Select Id, Name
                         From Pricebook2 
                         where isActive = true
                         limit 1];
        Opportunity o = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'Aberta', RecordTypeId = rt_fac_brasmax_opps);
        PricebookEntry pbe = [Select Id, Product2Id
                              From PricebookEntry
                              where Pricebook2Id = :pb.Id and isActive = true
                              limit 1];
        insert o;
        List<OpportunityLineItem> items = new List<OpportunityLineItem>();
        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId = o.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Estado_Facturacion__c = 'Facturado');
        // insert oi2;
        items.add(oi2);
        OpportunityLineItem oi = new OpportunityLineItem(OpportunityId = o.Id, Quantity = 12, TotalPrice = 120, PricebookEntryId = pbe.Id, Id_Item_de_Oportunidad_Relacionado__c = oi2.Id);
        // insert oi;
        items.add(oi);
        insert items;
        list<OpportunityLineItem> oppItems = new List<OpportunityLineItem>();
        oppItems.add(oi);

        Contrato__c c = new Contrato__c(Multiplicador__c = a.Id, Cultivar__c = pbe.Product2Id, Sociedad__c = 'BRMX', RecordTypeId = rt.Id);
        insert c;
        //actualizarContrato(oppItems);

        list<Opportunity> opps = new List<Opportunity>();
        BRAXUtils.desfacturarItemComercial(oppItems);
        opps.add(o);
        //actualizarOpps(opps,null);
        //actualizarOpps(opps);
        BRAXUtils.actualizar2Opps(opps);
        delete oi;

        Opportunity anexo = new Opportunity(Name = 'prueba', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'Aberta', RecordTypeId = rt_anexo_1_opps, Safra__c = '10/11');
        insert anexo;
        Opportunity anexo2 = new Opportunity(Name = 'prueba2', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'Aberta', RecordTypeId = rt_anexo_1_opps, Safra__c = '10/11');
        insert anexo2;

        List<Opportunity> listaOpp = New List<Opportunity>();
        listaOpp.add(anexo);

        Boolean b = BRAXUtils.actualizarNroAutorizacionA1(listaOpp);

        delete anexo;
        delete anexo2;
        delete o;

        BRAXUtils prueba = New BRAXUtils();
        ApexPages.currentPage().getParameters().put('tipo_opp', 'Previsao');
        prueba.nuevaOpp();
        prueba.getFull();
    }

    @isTest static void test2(){

        Map<String, Id> rt = New Map<String, Id>();
        Id ownerId;
        for (RecordType reTy : [Select Id, Name
                                From RecordType 
                                Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
            
        for (User u : [Select Id From User Where isActive = true and Codigo_SAP__c != null])    
            ownerId = u.Id;
        Account a = new Account(Name = 'TMP', OwnerId = ownerId);
        insert a;

        Pricebook2 pb = [Select Id, Name
                         From Pricebook2 
                         where Name = 'Lista de Básica BMX SUL' AND isActive = true
                         limit 1];
        Opportunity o1 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'PB-Pendiente', RecordTypeId = rt.get('PB-Comercial'), Tipo_de_Operacion__c = '1-Pedido', Safra__c = '18/19', Marca__c = 'BRMX', Region__c = 'CERRADO', En_Proc_Aprobacion__c = true, Epoca_de_Plantio__c = 'Verão');
        PricebookEntry pbe = [Select Id, Product2Id
                              From PricebookEntry
                              where Pricebook2Id = :pb.Id and isActive = true
                              limit 1];
        insert o1;
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Estado_Facturacion__c = 'Facturado', Quantidade__c = 50);
        insert oli1;


        o1.StageName = 'PB-Aprobada';
        update o1;

        //Opportunity op3 = [SELECT Id, Name, Marca__c, StageName, Notificado__c FROM Opportunity WHERE StageName='PB-Pendiente' AND RecordTypeId= :rt.get('PB-Produccion') AND Tipo_de_Operacion__c = '1-Pedido' AND Safra__c ='18/19' AND Marca__c='BRMX' AND Region__c='CERRADO' limit 1];
        //Opp_Utils.notificacionProd(op3.Id, op3.Id, op3.Marca__c);
        //op3.StageName = 'PB-Aprobada';
        //op3.Notificado__c = true;
        //update op3;

        Opportunity o2 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Description = 'ok', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'PB-Pendiente', RecordTypeId = rt.get('PB-Produccion'), Tipo_de_Operacion__c = '2-Plantio', Safra__c = '18/19', Marca__c = 'BRMX', Region__c = 'CERRADO', Epoca_de_Plantio__c = 'Verão');
        insert o2;
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = o2.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Estado_Facturacion__c = 'Facturado', Quantidade__c = 50);
        insert oli2;

        Opp_Utils.notificacionProd(o2.Id, o2.Id, o2.Marca__c);
    }

    @isTest static void test3(){

        Map<String, Id> rt = New Map<String, Id>();
        Id ownerId;
        for (RecordType reTy : [Select Id, Name
                                From RecordType 
                                Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
        
        for (User u : [Select Id From User Where isActive = true and Codigo_SAP__c != null])    
            ownerId = u.Id;
        Account a = new Account(Name = 'TMP', OwnerId = ownerId);
        insert a;

        Pricebook2 pb = [Select Id, Name
                         From Pricebook2 
                         where Name = 'Lista de Básica BMX SUL' AND isActive = true
                         limit 1];
        Opportunity o1 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'PB-Pendiente', RecordTypeId = rt.get('PB-Comercial'), Tipo_de_Operacion__c = '1-Pedido', Safra__c = '18/19', Marca__c = 'BRMX', Region__c = 'CERRADO', En_Proc_Aprobacion__c = true, Epoca_de_Plantio__c = 'Verão');
        PricebookEntry pbe = [Select Id, Product2Id
                              From PricebookEntry
                              where Pricebook2Id = :pb.Id and isActive = true
                              limit 1];
        insert o1;
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Estado_Facturacion__c = 'Facturado', Quantidade__c = 50);
        insert oli1;
        o1.StageName = 'PB-Aprobada';
        update o1;

        Opportunity op3 = [SELECT Id, Name, Marca__c, StageName, Notificado__c
                           FROM Opportunity
                           WHERE StageName = 'PB-Aprobada' AND RecordTypeId = :rt.get('PB-Produccion') AND Tipo_de_Operacion__c = '1-Pedido' AND Safra__c = '14/15' AND Marca__c = 'BRMX' AND Region__c = 'CERRADO'
                           limit 1];
        //Opp_Utils.notificacionProd(op3.Id, op3.Id, op3.Marca__c);
        //op3.StageName = 'PB-Aprobada';
        //op3.Notificado__c = true;
        //update op3;

        Opp_Utils.clonarOpp(op3.Id);
    }

    @isTest static void test4(){

        Map<String, Id> rt = New Map<String, Id>();
        for (RecordType reTy : [Select Id, Name
                                From RecordType 
                                Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
        Account a = new Account(Name = 'TMP');
        insert a;

        Pricebook2 pb = [Select Id, Name
                         From Pricebook2 
                         where Name = 'Lista de Básica BMX SUL' AND isActive = true
                         limit 1];
        Opportunity o1 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'PB-Pendiente', RecordTypeId = rt.get('PB-Comercial'), Tipo_de_Operacion__c = '1-Pedido', Safra__c = '18/19', Marca__c = 'BRMX', Region__c = 'SUR', En_Proc_Aprobacion__c = true, Epoca_de_Plantio__c = 'Verão');
        PricebookEntry pbe = [Select Id, Product2Id
                              From PricebookEntry
                              where Pricebook2Id = :pb.Id and isActive = true
                              limit 1];
        insert o1;
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Estado_Facturacion__c = 'Facturado', Quantidade__c = 50);
        insert oli1;
        o1.StageName = 'PB-Aprobada';
        update o1;

        //Opportunity op3 = [SELECT Id, Name, Marca__c, StageName, Notificado__c FROM Opportunity WHERE StageName='PB-Pendiente' AND RecordTypeId= :rt.get('PB-Produccion') AND Tipo_de_Operacion__c = '1-Pedido' AND Safra__c ='18/19' AND Marca__c='BRMX' AND Region__c='SUR' limit 1];
        //Opp_Utils.notificacionProd(op3.Id, op3.Id, op3.Marca__c);
        //op3.StageName = 'PB-Aprobada';
        //op3.Notificado__c = true;
        //update op3;

        Opportunity o2 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'PB-Pendiente', RecordTypeId = rt.get('PB-Comercial'), Tipo_de_Operacion__c = '2-Pedido Complementar', Safra__c = '18/19', Marca__c = 'BRMX', Region__c = 'SUR', En_Proc_Aprobacion__c = true, Epoca_de_Plantio__c = 'Verão');
        insert o2;
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Estado_Facturacion__c = 'Facturado', Quantidade__c = 50);
        insert oli2;
        o2.StageName = 'PB-Aprobada';
        update o2;
    }

    @isTest static void test5(){

        Map<String, Id> rt = New Map<String, Id>();
        for (RecordType reTy : [Select Id, Name
                                From RecordType 
                                Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
        Account a = new Account(Name = 'TMP');
        insert a;

        Pricebook2 pb = [Select Id, Name
                         From Pricebook2 
                         where Name = 'Lista de Básica BMX SUL' AND isActive = true
                         limit 1];
        Opportunity o1 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'PB-Pendiente', RecordTypeId = rt.get('PB-Comercial'), Tipo_de_Operacion__c = '1-Pedido', Safra__c = '18/19', Marca__c = 'BRMX', Region__c = 'SUR', En_Proc_Aprobacion__c = true, Epoca_de_Plantio__c = 'Verão');
        PricebookEntry pbe = [Select Id, Product2Id
                              From PricebookEntry
                              where Pricebook2Id = :pb.Id and isActive = true
                              limit 1];
        insert o1;
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Estado_Facturacion__c = 'Facturado', Quantidade__c = 50);
        insert oli1;
        o1.StageName = 'PB-Aprobada';
        update o1;

        //Opportunity op3 = [SELECT Id, Name, Marca__c, StageName, Notificado__c FROM Opportunity WHERE StageName='PB-Pendiente' AND RecordTypeId= :rt.get('PB-Produccion') AND Tipo_de_Operacion__c = '1-Pedido' AND Safra__c ='18/19' AND Marca__c='BRMX' AND Region__c='SUR' limit 1];
        //Opp_Utils.notificacionProd(op3.Id, op3.Id, op3.Marca__c);
        //op3.StageName = 'PB-Aprobada';
        //op3.Notificado__c = true;
        //update op3;

        Opportunity o2 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'PB-Pendiente', RecordTypeId = rt.get('PB-Comercial'), Tipo_de_Operacion__c = '3-Ajuste', Safra__c = '18/19', Marca__c = 'BRMX', Region__c = '_SUR', En_Proc_Aprobacion__c = true, Epoca_de_Plantio__c = 'Verão');
        insert o2;
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Estado_Facturacion__c = 'Facturado', Quantidade__c = 50);
        insert oli2;
        o2.StageName = 'PB-Aprobada';
        update o2;
    }

    @isTest static void test6(){

        Map<String, Id> rt = New Map<String, Id>();
        for (RecordType reTy : [Select Id, Name
                                From RecordType 
                                Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
        Account a = new Account(Name = 'TMP');
        insert a;

        Pricebook2 pb = [Select Id, Name
                         From Pricebook2 
                         where Name = 'Lista de Básica BMX SUL' AND isActive = true
                         limit 1];
        Opportunity o1 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'PB-Pendiente', RecordTypeId = rt.get('PB-Comercial'), Tipo_de_Operacion__c = '1-Pedido', Safra__c = '18/19', Marca__c = 'BRMX', Region__c = 'SUR', En_Proc_Aprobacion__c = true, Epoca_de_Plantio__c = 'Verão');
        PricebookEntry pbe = [Select Id, Product2Id
                              From PricebookEntry
                              where Pricebook2Id = :pb.Id and isActive = true
                              limit 1];
        insert o1;
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Estado_Facturacion__c = 'Facturado', Quantidade__c = 50);
        insert oli1;
        o1.StageName = 'PB-Aprobada';
        update o1;

        Opportunity o2 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Description = 'ok', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'PB-Pendiente', RecordTypeId = rt.get('PB-Produccion'), Tipo_de_Operacion__c = '2-Plantio', Safra__c = '18/19', Marca__c = 'BRMX', Region__c = 'SUR', Epoca_de_Plantio__c = 'Verão');
        insert o2;
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Estado_Facturacion__c = 'Facturado', Quantidade__c = 50);
        insert oli2;
        o2.StageName = 'PB-Aprobada';
        o2.Notificado__c = true;
        update o2;
    }

    @isTest static void test7(){

        Map<String, Id> rt = New Map<String, Id>();
        for (RecordType reTy : [Select Id, Name
                                From RecordType 
                                Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
        Account a = new Account(Name = 'TMP');
        insert a;

        Pricebook2 pb = [Select Id, Name
                         From Pricebook2 
                         where Name = 'Lista de Básica BMX SUL' AND isActive = true
                         limit 1];
        Opportunity o1 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'PB-Pendiente', RecordTypeId = rt.get('PB-Comercial'), Tipo_de_Operacion__c = '1-Pedido', Safra__c = '18/19', Marca__c = 'BRMX', Region__c = 'SUR', En_Proc_Aprobacion__c = true, Epoca_de_Plantio__c = 'Verão');
        PricebookEntry pbe = [Select Id, Product2Id
                              From PricebookEntry
                              where Pricebook2Id = :pb.Id and isActive = true
                              limit 1];
        PricebookEntry pbe2 = [Select Id, Product2Id
                               From PricebookEntry
                               where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__r.Name = 'C2'
                               limit 1];
        insert o1;
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Estado_Facturacion__c = 'Facturado', Quantidade__c = 50);
        insert oli1;
        o1.StageName = 'PB-Aprobada';
        update o1;

        Opportunity o2 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = a.Id, CloseDate = System.today(), StageName = 'PB-Pendiente', RecordTypeId = rt.get('PB-Produccion'), Tipo_de_Operacion__c = '2-Plantio', Safra__c = '18/19', Marca__c = 'BRMX', Region__c = 'SUR', Rebaja__c = true, Epoca_de_Plantio__c = 'Verão');
        insert o2;
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe2.Id, Estado_Facturacion__c = 'Facturado', Quantidade__c = 50);
        insert oli2;
        o2.StageName = 'PB-Aprobada';
        o2.Notificado__c = true;
        update o2;
    }

    @isTest static void test8(){

        //Account a = new Account(Name='TMP');
        //insert a;
        Account cuenta = [Select Id, Estado__c
                          From Account
                          Where Name = 'ACME' AND CodigoSAP__c = '6000000000'
                          limit 1];
        Pricebook2 pb = [Select Id, Name
                         From Pricebook2 
                         where Name = 'Lista de Básica BMX SUL' AND isActive = true
                         limit 1];
        Opportunity o1 = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = cuenta.Id, CloseDate = System.today(), StageName = 'Aprobada', RecordTypeId = rt_anexo_1_opps, Safra__c = '18/19', Marca__c = 'BRMX', Epoca_de_Plantio__c = 'Verão');
        PricebookEntry pbe = [Select Id, Product2Id, Product2.Categ__c
                              From PricebookEntry
                              where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__r.Name = 'C1'
                              limit 1];
        Categoria__c cat = [Select Id
                            FROM Categoria__c
                            WHERE Name = 'C2'
                            limit 1];
        Estado__c est = [SELECT Id
                         FROM Estado__c
                         WHERE Name != 'PR'
                         limit 1];
        insert o1;
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Area__c = 100, Tipo_Registro__c = 'Anexo I', Categoria__c = pbe.Product2.Categ__c, Categoria_a_Rebaixar__c = pbe.Product2.Categ__c, Estado_de_Comercializacion__c = cuenta.Estado__c, Estado_de_Produccion__c = cuenta.Estado__c, Area_Plantada__c = 10, Semente_bruta__c = 20, Descarte__c = 10, Semente_beneficiada__c = 20, Semente_aprovada__c = 20, Semente_uso_propio__c = 10, Semente_comercializada__c = 10, Sem_Rebajada__c = 10);
        insert oli1;

        oli1.Area__c = 101;
        oli1.Categoria__c = cat.Id;
        oli1.Categoria_a_Rebaixar__c = cat.Id;
        oli1.Estado_de_Comercializacion__c = est.Id;
        oli1.Estado_de_Produccion__c = est.Id;
        oli1.Area_Plantada__c = 11;
        oli1.Semente_bruta__c = 22;
        oli1.Descarte__c = 11;
        oli1.Semente_beneficiada__c = 22;
        oli1.Semente_aprovada__c = 22;
        oli1.Semente_uso_propio__c = 11;
        oli1.Semente_comercializada__c = 11;
        oli1.Sem_Rebajada__c = 11;

        update oli1;

        BRAXUtils bu = New BRAXUtils();
        //bu.actStock();

        //Actualizar campo activa
        Opportunity oSM = New Opportunity();
        oSM.Name = 'Estoque';
        oSM.AccountId = cuenta.Id;
        oSM.CloseDate = system.today();
        oSM.StageName = 'Fechada';
        oSM.RecordTypeId = '01240000000M9lt';
        oSM.Safra__c = '14/15';
        oSM.Activa__c = true;
        oSM.Marca__c = 'DSEM';
        Test.StartTest();
        insert oSM;
        Test.StopTest();

        //Actualizar Perfil
        CRM_Multiplicador__c crm = New CRM_Multiplicador__c();
        crm.safra__c = '14/15';
        crm.cuenta__c = cuenta.Id;
        insert crm;
        CRM_Detalhe_de_Perfil_da_Conta__c perf = New CRM_Detalhe_de_Perfil_da_Conta__c();
        perf.CRM_Multiplicador__c = crm.Id;
        insert perf;

        Opportunity opp_obj = new Opportunity(Name = 'TMPPROBANDOLASOPP', Pricebook2Id = pb.Id, AccountId = cuenta.Id, CloseDate = System.today(), StageName = 'Aprobada', RecordTypeId = rt_objContratoRoy, Safra__c = '14/15', Marca__c = 'BRMX');
        insert opp_obj;
        OpportunityLineItem item_obj = new OpportunityLineItem(OpportunityId = o1.Id, Quantity = 10, TotalPrice = 10, PricebookEntryId = pbe.Id, Meta__c = 10);
        insert item_obj;

        BRAXUtils prueba = New BRAXUtils();

        prueba.getFiltroActStock();
        prueba.setFiltroActStock(New Analisis_de_Datos__c());

        Opportunity opp = [Select Id, Next_Step__c
                           From Opportunity
                           Where RecordType.Name = 'Anexo I' And Safra__c = '13/14'
                           limit 1];
        opp.Next_Step__c = 'A';
        update opp;
        opp.Next_Step__c = 'Solicitud Aprobacion';
        update opp;
    }

    @isTest static void test9(){

        Account cuenta = [Select Id, Estado__c
                          From Account
                          Where Name = 'ACME' AND CodigoSAP__c = '6000000000'
                          limit 1];

        CRM_Calendario_de_Eventos__c eventos = New CRM_Calendario_de_Eventos__c();
        eventos.evento__c = 'Emplacamento';
        eventos.cuenta__c = cuenta.Id;
        eventos.data__c = system.today();
        eventos.safra__c = '14/15';
        insert eventos;
    }
}
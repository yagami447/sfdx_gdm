@isTest
private class BRAXUtilsTest {

/*
    static testMethod void gralUnitTest() {
        BRAXUtils b_obj = new BRAXUtils();
                        
        Profile p = [SELECT Id FROM Profile WHERE Name='Usuario estándar'];
        UserRole r_c = [SELECT Id FROM UserRole WHERE Name='Comercial R1 BRMX'];
        UserRole r_p = [SELECT Id FROM UserRole WHERE Name='Gerencia Producción'];
        
        //Funcion Comercial
        User u = new User(Alias = 'ejem', Email='prueba@brx.com', EmailEncodingKey='UTF-8', 
        LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='Comercial@test.com', UserRoleId = r_c.Id);
        
        System.runAs(u) {
        	Integer acceso = b_obj.getFull();
            System.AssertEquals(acceso,1);            
        }
        
        u.UserRoleId = r_p.Id;  //Funcion Produccion
        update u;        
        System.runAs(u) {
        	Integer acceso = b_obj.getFull();
            System.AssertEquals(acceso,2);
        }
    }    
    
    static testMethod void actStockPropTest() {
        BRAXUtils b_obj = new BRAXUtils();

        Estado__c e = new Estado__c (Name='PR'); insert e;
        Regiao__c reg = new Regiao__c(Region_Comercial__c='CERRADO'); insert reg;
        
        Account c = new Account(Estado__c=e.Id, Name='ACME',CodigoSAP__c='6000000000',Reponsavel_DSEM__c='111 - Jere',Responsavel__c='095 - Brasmax',Region__c=reg.Id); insert c;
        Analisis_de_Datos__c ad = new Analisis_de_Datos__c(Safra__c='14/15',Mes__c='Janeiro',Cuenta__c=c.Id); insert ad;
        Contact cto = new Contact(AccountId=c.Id,FirstName='Jere',LastName='Gar',Title='PORTAL'); insert cto;
        
        Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType in ('Opportunity','Contrato__c')])
            rt.put(reTy.Name, reTy.Id);
                            
        Configuracion_BMX__c conf = new Configuracion_BMX__c(Safra_Stock__c='14/15', Mes_Stock__c='Janeiro'); insert conf;
        
        Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedad__c='BRMX ALVO'); insert prod;
        
        Contrato__c cont_multip = new Contrato__c(RecordTypeId=rt.get('BRMX'),Safra__c='14/15',Multiplicador__c=c.Id); insert cont_multip;
        Item_del_Contrato__c item1 = new Item_del_Contrato__c (Contrato_de_Multiplicacion__c=cont_multip.Id,Precio__c=3,
        Name='PEP',Cultivar__c=prod.Id); insert item1;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;
                
        Opportunity opp = new Opportunity(CloseDate=System.today(),StageName='Aberta',Pricebook2Id=pb.Id,RecordTypeId=rt.get('Stock Multiplicadores'),
        Marca__c='BRMX',Safra__c='14/15',Mes__c='Janeiro',AccountId=c.Id,Region__c=reg.id); insert opp;
        OpportunityLineItem item = new OpportunityLineItem (Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id,Estado_Facturacion__c='Facturado',OpportunityId=opp.Id);
        insert item;
        
        b_obj.setFiltroActStock(ad); 
        ad = b_obj.getFiltroActStock();
         
        b_obj.actStock();
        
        opp.RecordTypeId = rt.get('PB-Comercial');
        opp.Region__c = 'CERRADO';
        update opp;
        
        Opportunity opp2 = new Opportunity(CloseDate=System.today(),Nro_autorizacion__c=12,StageName='Aberta',Pricebook2Id=pb.Id,RecordTypeId=rt.get('PB-Comercial'),
        Marca__c='DSEM',Safra__c='14/15',Mes__c='Juno',AccountId=c.Id,Region__c='REGION 2'); insert opp2;
        OpportunityLineItem item2 = new OpportunityLineItem (Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id,Estado_Facturacion__c='Facturado',OpportunityId=opp2.Id);
        insert item2;
        
        
        Opportunity[] oppsNew = new List<Opportunity>();
        oppsNew.add(opp);
        oppsNew.add(opp2);
        
        c.Region__c = null;        
        update c;
        	
        BRAXUtils.actualizarPropietarioOpp(oppsNew);
        
    }
    
    static testMethod void actAutorizacionTest() {
        BRAXUtils b_obj = new BRAXUtils();

        Estado__c e = new Estado__c (Name='PR'); insert e;     
        Account c = new Account(Estado__c=e.Id, Name='ACME',CodigoSAP__c='6000000000',Reponsavel_DSEM__c='111 - Jere',Responsavel__c='095 - Brasmax'); insert c;
        
        Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType in ('Opportunity','Contrato__c')])
            rt.put(reTy.Name, reTy.Id);
                            
        Configuracion_BMX__c conf = new Configuracion_BMX__c(Safra_Stock__c='14/15', Mes_Stock__c='Janeiro'); insert conf;
        
        Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedad__c='BRMX ALVO'); insert prod;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;
                
        Opportunity opp = new Opportunity(CloseDate=System.today(),StageName='Aberta',Pricebook2Id=pb.Id,RecordTypeId=rt.get('Anexo I'),
        Marca__c='BRMX',Safra__c='14/15',Mes__c='Janeiro',AccountId=c.Id,Region__c='REGION 1',Name='PEP'); insert opp;
        OpportunityLineItem item = new OpportunityLineItem (Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id,Estado_Facturacion__c='Facturado',OpportunityId=opp.Id);
        insert item;     
       
        Opportunity opp2 = new Opportunity(CloseDate=System.today(),Name='PERPE',Nro_autorizacion__c=12,StageName='Pendente',Pricebook2Id=pb.Id,RecordTypeId=rt.get('Anexo II'),
        Marca__c='DSEM',Safra__c='14/15',Mes__c='Juno',AccountId=c.Id,Region__c='REGION 2'); insert opp2;
        OpportunityLineItem item2 = new OpportunityLineItem (Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id,Estado_Facturacion__c='Facturado',OpportunityId=opp2.Id);
        insert item2;        
        
        Opportunity[] oppsNew = new List<Opportunity>();
        oppsNew.add(opp);
        oppsNew.add(opp2);

        BRAXUtils.actualizarNroAutorizacionA1(oppsNew);
        
    }
    
    static testMethod void actualizarOppTest() {
    	
    	Estado__c e = new Estado__c (Name='PR'); insert e;     
        Account c = new Account(Estado__c=e.Id, Name='ACME',CodigoSAP__c='6000000000',Reponsavel_DSEM__c='111 - Jere',Responsavel__c='095 - Brasmax'); insert c;
       
    	Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType in ('Opportunity')])
            rt.put(reTy.Name, reTy.Id);
        
        Cotizacion_Soja__c cot = new Cotizacion_Soja__c(Cotacao_de_soja__c='SOJA', Valor__c=1,Safra__c='14/15'); insert cot;                
        Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedad__c='BRMX ALVO'); insert prod;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;
        
    	Opportunity opp2 = new Opportunity(CloseDate=System.today(),Name='PERPE',Nro_autorizacion__c=12,StageName='Pendente',
    	Pricebook2Id=pb.Id,RecordTypeId=rt.get('Fc de Brasmax'),VB_Cot_Soja__c='SOJA',Tipo_de_Cota_o__c='DOLAR',Marca__c='DSEM',Safra__c='14/15',
    	Mes__c='Juno',AccountId=c.Id,Region__c='REGION 2'); insert opp2;
        
        OpportunityLineItem item2 = new OpportunityLineItem (Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id,Estado_Facturacion__c='Facturado',OpportunityId=opp2.Id);
        insert item2;  
        
    	Opportunity[] oppsNew = new List<Opportunity>();
        oppsNew.add(opp2);
        
        BRAXUtils.actualizarOpps(oppsNew);
        
        opp2.RecordTypeId = rt.get('Pendiente');
        BRAXUtils.actualizarOpps(oppsNew);
        
        opp2.Tipo_de_Cota_o__c = 'SOJA';
        BRAXUtils.actualizarOpps(oppsNew);
        
        opp2.RecordTypeId = rt.get('Previsao');
        BRAXUtils.actualizarOpps(oppsNew);
        
        opp2.RecordTypeId = rt.get('Stock Multiplicadores');
        BRAXUtils.actualizarOpps(oppsNew);                
        
    }
    
    static testMethod void deleteOppTest() {
    	Estado__c e = new Estado__c (Name='SC'); insert e;     
        Account c = new Account(Estado__c=e.Id, Name='ACME',CodigoSAP__c='6000000000',Reponsavel_DSEM__c='111 - Jere',Responsavel__c='095 - Brasmax'); insert c;
       
    	Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType in ('Opportunity')])
            rt.put(reTy.Name, reTy.Id);
        
        //Cotizacion_Soja__c cot = new Cotizacion_Soja__c(Cotacao_de_soja__c='SOJA', Valor__c=1,Safra__c='14/15'); insert cot;                
        Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedad__c='BRMX ALVO'); insert prod;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;
        
        Opportunity opp = new Opportunity(CloseDate=System.today(),Name='PEPE',Nro_autorizacion__c=12,StageName='Pen',
    	Pricebook2Id=pb.Id,RecordTypeId=rt.get('Fc de Brasmax'),VB_Cot_Soja__c='SOJA',Tipo_de_Cota_o__c='DOLAR',Marca__c='DSEM',Safra__c='14/15',
    	Mes__c='Juno',AccountId=c.Id,Region__c='REGION 1'); insert opp;
        
        OpportunityLineItem item = new OpportunityLineItem (Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id,Estado_Facturacion__c='Facturado',OpportunityId=opp.Id);
        insert item;  
        
    	Opportunity opp2 = new Opportunity(CloseDate=System.today(),Name='PEPE',Nro_autorizacion__c=12,StageName='Pendente',
    	Pricebook2Id=pb.Id,RecordTypeId=rt.get('Fc de Brasmax'),VB_Cot_Soja__c='SOJA',Tipo_de_Cota_o__c='DOLAR',Marca__c='DSEM',Safra__c='14/15',
    	Mes__c='Juno',AccountId=c.Id,Region__c='REGION 1'); insert opp2;
        
        OpportunityLineItem item2 = new OpportunityLineItem (Id_Item_de_Oportunidad_Relacionado__c=item.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id,Estado_Facturacion__c='Facturado',OpportunityId=opp2.Id);
        insert item2;  
        
    	OpportunityLineItem[] oppItemsDel = new List<OpportunityLineItem>();
        oppItemsDel.add(item2);
        
    	BRAXUtils.desfacturarItemComercial(oppItemsDel);
    
    }
    
    
    static testMethod void validarProdBasicaTest() {
    	
    	Estado__c e = new Estado__c (Name='PR'); insert e;     
        Account c = new Account(Estado__c=e.Id, Name='ACME',CodigoSAP__c='6000000000',Reponsavel_DSEM__c='111 - Jere',Responsavel__c='095 - Brasmax'); insert c;
		Variedad__c var = new Variedad__c (Name='BRMX ALVO',Tecnologia__c='RR',Marca_comercial__c='Brasmax'); insert var;
		Categoria__c cat = new Categoria__c (Name='Basica'); insert cat;
				
		Local__c ll = new Local__c(Name='JERE'); insert ll;
		Local__c ll2 = new Local__c(Name='JERE2'); insert ll2;
    	Local__c ll3 = new Local__c(Name='JERE233'); insert ll3;
    	Local__c ll4 = new Local__c(Name='JERE24433'); insert ll4;
    	
    	Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType in ('Opportunity')])
            rt.put(reTy.Name, reTy.Id);
        
        //Cotizacion_Soja__c cot = new Cotizacion_Soja__c(Cotacao_de_soja__c='SOJA', Valor__c=1,Safra__c='14/15'); insert cot;                
        Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedade__c=var.Id, Categ__c=cat.Id,Variedad__c='BRMX ALVO'); insert prod;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;
		
		//Test.StartTest();
		
        Opportunity o1 = new Opportunity(Name='TMPOPP',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Comercial'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '1-Pedido', Safra__c ='18/19', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão'); insert o1;
		
		Opportunity o2 = new Opportunity(Name='TMPOPP2',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Produccion'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '4-Cancelamento', Safra__c ='18/19', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão',Rebaja__c=true); insert o2;
        
        Opportunity o3 = new Opportunity(Name='TMPOPP3',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Desarrollo'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '5-Realocação', Safra__c ='18/19', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão',Rebaja__c=true); insert o3;
        
        Opportunity o4 = new Opportunity(Name='TMPOPP4',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Desarrollo'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '1-Pedido', Safra__c ='18/19', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão'); //insert o4;
        
        BRAXUtils.validarNuevaProduccionBasica(o1);
                
        OpportunityLineItem oli1 = new OpportunityLineItem(Local_de_Entrega__c=ll.Id,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o1.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 50);
        insert oli1;
        OpportunityLineItem oli2 = new OpportunityLineItem(Local_de_Entrega__c=ll2.Id,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o2.Id,Quantity=10,TotalPrice=120,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 80);
        insert oli2;
        OpportunityLineItem oli3 = new OpportunityLineItem(Local_de_Entrega__c=ll3.Id,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o3.Id,Quantity=10,TotalPrice=120,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 80);
        insert oli3;
        OpportunityLineItem oli4 = new OpportunityLineItem(Local_de_Entrega__c=ll4.Id,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o4.Id,Quantity=10,TotalPrice=120,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 850);
        //insert oli4;
        
        OpportunityLineItem[] oppItems = new List<OpportunityLineItem>();
        oppItems.add(oli1);
        oppItems.add(oli2);
        oppItems.add(oli3);
        //oppItems.add(oli4);
           
        Opportunity[] oppNew = new List<Opportunity>();
        oppNew.add(o1);
        oppNew.add(o2);
        oppNew.add(o3);
        //oppNew.add(o4);
        
        Map<Id,Opportunity> mapOld = new Map<Id,Opportunity>();
        mapOld.put(o1.Id,o1);
        mapOld.put(o2.Id,o2);
        mapOld.put(o3.Id,o3);
        //mapOld.put(o4.Id,o4);
        
        BRAXUtils.validarVariedadPB(o1,oppItems);
        
        Produccion_Basica__c prb = new Produccion_Basica__c(Local_de_Entrega__c=ll.Id,Epoca_de_Plantio__c='',Safra__c='18/19',Region__c='SUR',Marca__c='BRMX'); insert prb;
        prb.Com_1_Pedido__c = 0;
        prb.Prod_1_Pedido__c = 0; 
        prb.Com_2_Pedido_Complementar__c = 0; 
        prb.Com_3_Ajuste__c = 0;
        prb.Com_4_Cancelamiento__c = 0; 
        prb.Com_5_Relocalizacion__c = 0;
        prb.Com_6_Adm_Exedente__c=0;
        prb.Setor__c = 'Comercial';
        prb.Variedade__c = var.Id;
        prb.Categoria__c = cat.Id;
        prb.Tipo_de_Necesidad__c='Basa';
        update prb;          	
               
        o1.StageName = 'PB-Aprobada';
        o1.Notificado__c = true;        
        
        o2.StageName = 'PB-Aprobada';
        o2.Notificado__c = true;        
        
        o3.StageName = 'PB-Aprobada';
        o3.Notificado__c = true;     
        
        update oppNew;
        
    }
    
    static testMethod void validarProdBasicaComercialFalso() {
    	
    	Estado__c e = new Estado__c (Name='PR'); insert e;     
        Account c = new Account(Estado__c=e.Id, Name='ACME',CodigoSAP__c='6000000000',Reponsavel_DSEM__c='111 - Jere',Responsavel__c='095 - Brasmax'); insert c;
		Variedad__c var = new Variedad__c (Name='BRMX ALVO',Tecnologia__c='RR',Marca_comercial__c='Brasmax'); insert var;
		Categoria__c cat = new Categoria__c (Name='Basica'); insert cat;
				
		Local__c ll = new Local__c(Name='JERE'); insert ll;
		Local__c ll2 = new Local__c(Name='JERE2'); insert ll2;
    	Local__c ll3 = new Local__c(Name='JERE233'); insert ll3;
    	//Local__c ll4 = new Local__c(Name='JERE24433'); insert ll4;
    	
    	Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType in ('Opportunity')])
            rt.put(reTy.Name, reTy.Id);
        
        //Cotizacion_Soja__c cot = new Cotizacion_Soja__c(Cotacao_de_soja__c='SOJA', Valor__c=1,Safra__c='14/15'); insert cot;                
        Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedade__c=var.Id, Categ__c=cat.Id,Variedad__c='BRMX ALVO'); insert prod;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;
				
        Opportunity o1 = new Opportunity(Name='TMPOPP',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Comercial'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '6-Administração Excedente', Safra__c ='18/19', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão'); insert o1;
		
		Opportunity o2 = new Opportunity(Name='TMPOPP2',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Comercial'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '3-Ajuste', Safra__c ='18/19', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão'); insert o2;
                
        Opportunity o3 = new Opportunity(Name='TMPOPP3',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Comercial'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '4-Cancelamento', Safra__c ='18/19', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão'); insert o3;
                
        BRAXUtils.validarNuevaProduccionBasica(o1);
                
        OpportunityLineItem oli1 = new OpportunityLineItem(Local_de_Entrega__c=ll.Id,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o1.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 50);
        insert oli1;
        OpportunityLineItem oli2 = new OpportunityLineItem(Local_de_Entrega__c=ll2.Id,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o2.Id,Quantity=10,TotalPrice=120,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 80);
        insert oli2;
        OpportunityLineItem oli3 = new OpportunityLineItem(Local_de_Entrega__c=ll3.Id,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o3.Id,Quantity=10,TotalPrice=120,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 80);
        insert oli3;
          
        Opportunity[] oppNew = new List<Opportunity>();
        oppNew.add(o1);
        oppNew.add(o2);
        oppNew.add(o3);
        
        Produccion_Basica__c prb = new Produccion_Basica__c(Local_de_Entrega__c=ll.Id,Epoca_de_Plantio__c='',Safra__c='18/19',Region__c='SUR',Marca__c='BRMX'); insert prb;
        prb.Com_1_Pedido__c = 0;
        prb.Prod_1_Pedido__c = 0; 
        prb.Com_2_Pedido_Complementar__c = 0; 
        prb.Com_3_Ajuste__c = 0;
        prb.Com_4_Cancelamiento__c = 0; 
        prb.Com_5_Relocalizacion__c = 0;
        prb.Com_6_Adm_Exedente__c=0;
        prb.Setor__c = 'Comercial';
        prb.Variedade__c = var.Id;
        prb.Categoria__c = cat.Id;
        prb.Tipo_de_Necesidad__c='Basa';
        update prb;          	
               
        o1.StageName = 'PB-Aprobada';
        o1.Notificado__c = true;        
        
        o2.StageName = 'PB-Aprobada';
        o2.Notificado__c = true;        
        
        o3.StageName = 'PB-Aprobada';
        o3.Notificado__c = true;     
        
        update oppNew;
        
    }
    
    static testMethod void validarProdBasicaProduccionFalso() {
  
        Account c = new Account(Name='ACME',CodigoSAP__c='6000000000',Reponsavel_DSEM__c='111 - Jere',Responsavel__c='095 - Brasmax'); insert c;
		Variedad__c var = new Variedad__c (Name='BRMX ALVO',Tecnologia__c='RR',Marca_comercial__c='Brasmax'); insert var;
		Categoria__c cat = new Categoria__c (Name='Basica'); insert cat;
				
		Local__c ll = new Local__c(Name='JERE'); insert ll;
		Local__c ll2 = new Local__c(Name='JERE2'); insert ll2;
    	
    	Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType in ('Opportunity')])
            rt.put(reTy.Name, reTy.Id);
                        
        Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedade__c=var.Id, Categ__c=cat.Id,Variedad__c='BRMX ALVO'); insert prod;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;
				
        Opportunity o1 = new Opportunity(Name='TMPOPP',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Produccion'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '1-Pedido', Safra__c ='18/19', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão'); insert o1;
		
		Opportunity o2 = new Opportunity(Name='TMPOPP2',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Produccion'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '2-Plantio', Safra__c ='18/19', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão'); insert o2;
                
        Opportunity o3 = new Opportunity(Name='TMPOPP3',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Produccion'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '3-Estimativa', Safra__c ='18/19', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão'); insert o3;

        OpportunityLineItem oli1 = new OpportunityLineItem(Local_de_Entrega__c=ll.Id,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o1.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 50);
        insert oli1;
        OpportunityLineItem oli2 = new OpportunityLineItem(Local_de_Entrega__c=ll2.Id,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o2.Id,Quantity=10,TotalPrice=120,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 80);
        insert oli2;
        OpportunityLineItem oli3 = new OpportunityLineItem(Local_de_Entrega__c=ll2.Id,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o3.Id,Quantity=10,TotalPrice=120,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 80);
        insert oli3;
         
        Opportunity[] oppNew = new List<Opportunity>();
        oppNew.add(o1);
        oppNew.add(o2);
        oppNew.add(o3);
               
        o1.StageName = 'PB-Aprobada';
        o1.Notificado__c = true;
        o2.StageName = 'PB-Aprobada';
        o2.Notificado__c = true;        
        o3.StageName = 'PB-Aprobada';
        o3.Notificado__c = true;     

        update oppNew;
        
    }
    
    static testMethod void validarProdBasicaProduccion2Falso() {
  
        Account c = new Account(Name='ACME',CodigoSAP__c='6000000000',Reponsavel_DSEM__c='111 - Jere',Responsavel__c='095 - Brasmax'); insert c;
			
		Local__c ll = new Local__c(Name='JERE'); insert ll;
    	
    	Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType in ('Opportunity')])
            rt.put(reTy.Name, reTy.Id);
                        
        Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedad__c='BRMX ALVO'); insert prod;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;
				
        Opportunity o1 = new Opportunity(Name='TMPOPP',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Produccion'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '5-Beneficiamento', Safra__c ='18/19', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão'); insert o1;
		
		Opportunity o2 = new Opportunity(Name='TMPOPP2',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Produccion'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '7-Descarte', Safra__c ='18/19', Marca__c='BRMX'); insert o2;
                
        Opportunity o3 = new Opportunity(Name='TMP3',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='PB-Pendiente',
        RecordTypeId=rt.get('PB-Produccion'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '9-Certificação', Safra__c ='18/19', Marca__c='BRMX'); insert o3;

        OpportunityLineItem oli1 = new OpportunityLineItem(Local_de_Entrega__c=ll.Id,OpportunityId=o1.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 50);
        insert oli1;
        OpportunityLineItem oli2 = new OpportunityLineItem(Local_de_Entrega__c=ll.Id,OpportunityId=o2.Id,Quantity=10,TotalPrice=120,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 80);
        insert oli2;
        OpportunityLineItem oli3 = new OpportunityLineItem(Local_de_Entrega__c=ll.Id,OpportunityId=o3.Id,Quantity=10,TotalPrice=120,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 80);
        insert oli3;
         
        Opportunity[] oppNew = new List<Opportunity>();
        oppNew.add(o1);
        oppNew.add(o2);
        oppNew.add(o3);
               
        o1.StageName = 'PB-Aprobada';
        o1.Notificado__c = true;
        o2.StageName = 'PB-Aprobada';
        o2.Notificado__c = true;        
        o3.StageName = 'PB-Aprobada';
        o3.Notificado__c = true;     

        update oppNew;                
                
    }
    
    static testMethod void validarCatAnexo() {
  
        Account c = new Account(Name='ACME',CodigoSAP__c='6000000000',Reponsavel_DSEM__c='111 - Jere',Responsavel__c='095 - Brasmax'); insert c;
		Variedad__c var = new Variedad__c (Name='BRMX ALVO',Tecnologia__c='RR',Marca_comercial__c='Brasmax'); insert var;
		Categoria__c cat = new Categoria__c (Name='Basica'); insert cat;
		    	
    	Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType in ('Opportunity')])
            rt.put(reTy.Name, reTy.Id);
                        
        Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedad__c='BRMX ALVO'); insert prod;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;
        
        Opportunity o1 = new Opportunity(Name='TMPOPP',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='Aprobada',
        RecordTypeId=rt.get('Anexo III'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '1-Pedido', Safra__c ='14/15', Marca__c='BRMX', 
        Region__c='SUR', Epoca_de_Plantio__c = 'Verão'); insert o1;
		
		Opportunity o2 = new Opportunity(Name='TMPOPP2',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='Aprobada',
        RecordTypeId=rt.get('Anexo II'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '1-Pedido', Safra__c ='18/19', Marca__c='BRMX'); insert o2;
                
        Opportunity o3 = new Opportunity(Name='TMP3',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='Aprobada',
        RecordTypeId=rt.get('Anexo II Rebaixamento Sacas'), Anexo_Relacionado__c=o2.Id, Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '9-Certificação', Safra__c ='18/19', Marca__c='BRMX'); insert o3;

        OpportunityLineItem oli1 = new OpportunityLineItem(Area_Plantada__c=1000,Semente_bruta__c=110,Semente_beneficiada__c=10,Semente_uso_propio__c=11,Meta__c=10,Semente_comercializada__c=10,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o1.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 50);
        insert oli1;
        OpportunityLineItem oli2 = new OpportunityLineItem(Area_Plantada__c=1000,Semente_bruta__c=110,Semente_beneficiada__c=10,Semente_uso_propio__c=11,Meta__c=10,Semente_comercializada__c=10,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o2.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 50);
        insert oli2;
        OpportunityLineItem oli3 = new OpportunityLineItem(Area_Plantada__c=1000,Semente_bruta__c=110,Semente_beneficiada__c=10,Semente_uso_propio__c=11,Meta__c=10,Semente_comercializada__c=10,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o3.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 50);
        insert oli3;
        
        OpportunityLineItem[] oppItems = new List<OpportunityLineItem>();
        oppItems.add(oli1);
        oppItems.add(oli2);
        oppItems.add(oli3);
        
        BRAXUtils.validarVarCatAnexo(oppItems);
        
    }
    
*/
    
    static testMethod void validarCatAnexoRebajas() {

        Account c = new Account(Name='ACME',CodigoSAP__c='6000000000',Reponsavel_DSEM__c='111 - Jere',Responsavel__c='095 - Brasmax'); insert c;
		Variedad__c var = new Variedad__c (Name='BRMX ALVO',Tecnologia__c='RR',Marca_comercial__c='Brasmax'); insert var;
		Categoria__c cat = new Categoria__c (Name='BASICA'); insert cat;
		    	
    	Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType in ('Opportunity')])
            rt.put(reTy.Name, reTy.Id);
                        
        Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedad__c='BRMX ALVO'); insert prod;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;

		Opportunity o2 = new Opportunity(Name='TMPOPP2',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='Aprobada',
        RecordTypeId=rt.get('Anexo II'), Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '1-Pedido', Safra__c ='18/19', Marca__c='BRMX'); insert o2;
                
        Opportunity o3 = new Opportunity(Name='TMP3',Pricebook2Id=pb.Id,AccountId=c.Id,CloseDate=System.today(),StageName='Aprobada',
        RecordTypeId=rt.get('Anexo II Rebaixamento Sacas'), Anexo_Relacionado__c=o2.Id, Setor__c='Comercial', Description = 'ok',Tipo_de_Operacion__c = '9-Certificação', Safra__c ='18/19', Marca__c='BRMX'); insert o3;

		OpportunityLineItem oli2 = new OpportunityLineItem(Area_Plantada__c=1000,Semente_bruta__c=110,Semente_beneficiada__c=10,Semente_uso_propio__c=11,Meta__c=10,Semente_comercializada__c=10,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o2.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 50);
        insert oli2;        
        OpportunityLineItem oli3 = new OpportunityLineItem(Area_Plantada__c=1000,Semente_bruta__c=110,Semente_beneficiada__c=10,Sem_Rebajada__c=22,Semente_uso_propio__c=11,Meta__c=10,Semente_comercializada__c=10,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o3.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 50);
        insert oli3;
        OpportunityLineItem oli3_1 = new OpportunityLineItem(Area_Plantada__c=1200,Semente_bruta__c=1120,Semente_beneficiada__c=10,Sem_Rebajada__c=10,Semente_uso_propio__c=01,Meta__c=10,Semente_comercializada__c=10,Categoria__c=cat.Id,Variedad__c=var.Id,OpportunityId=o3.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Estado_Facturacion__c='Facturado', Quantidade__c = 50);
        insert oli3_1;
        
        OpportunityLineItem[] oppItems = new List<OpportunityLineItem>();
        oppItems.add(oli2);
        oppItems.add(oli3_1);
        oppItems.add(oli3);
        
        BRAXUtils.validarVarCatAnexo(oppItems);
        
    }
    
}
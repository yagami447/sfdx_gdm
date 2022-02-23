@isTest
private class TEST_sapFlujoDoc_caller {
	

	@isTest(SeeAllData=false)
	static void test_procesos() {
	
		Configuracion_BMX__c c = new Configuracion_BMX__c (FC_Mandante_SAP__c = '110', Name = 'Facturacion');insert c;
		Bitacora_NC__c b1 = new Bitacora_NC__c(vbtyp__c='S',fkart__c='S2',Fecha_Desde__c= system.today().addDays(-200), numero_lote__c=1, sociedad__c='BRMX',orden__c=1);
        Bitacora_NC__c b2 = new Bitacora_NC__c(vbtyp__c='O',fkart__c='ZBDF',Fecha_Desde__c=system.today().addDays(-200), numero_lote__c=1, sociedad__c='BRMX',orden__c=2);
        Bitacora_NC__c b3 = new Bitacora_NC__c(vbtyp__c='O',fkart__c='ZBDG',Fecha_Desde__c=system.today().addDays(-200), numero_lote__c=1, sociedad__c='BRMX',orden__c=3);
        Bitacora_NC__c b4 = new Bitacora_NC__c(vbtyp__c='O',fkart__c='ZBDP',Fecha_Desde__c=system.today().addDays(-200), numero_lote__c=1, sociedad__c='BRMX',orden__c=4);
        Bitacora_NC__c b5 = new Bitacora_NC__c(vbtyp__c='O',fkart__c='ZBDR',Fecha_Desde__c=system.today().addDays(-200), numero_lote__c=1, sociedad__c='BRMX',orden__c=5);
        Bitacora_NC__c b6 = new Bitacora_NC__c(vbtyp__c='O',fkart__c='ZBDS',Fecha_Desde__c=system.today().addDays(-200), numero_lote__c=1, sociedad__c='BRMX',orden__c=6);
        Bitacora_NC__c b7 = new Bitacora_NC__c(vbtyp__c='O',fkart__c='ZBDE',Fecha_Desde__c=system.today().addDays(-200), numero_lote__c=1, sociedad__c='BRMX',orden__c=7,Iniciar_AcItems__c=true);
        
        List<Bitacora_NC__c> regBitacora = new List<Bitacora_NC__c>();
        regBitacora.add(b1);
        regBitacora.add(b2);
        regBitacora.add(b3);
        regBitacora.add(b4);
        regBitacora.add(b5);
        regBitacora.add(b6);
        regBitacora.add(b7);
        insert regbitacora;
        sapFlujoDoc_caller.consultarFlujoDoc();
	}
	

	@isTest(SeeAllData=false)
	static void test_actItems_O_ZBDE_BRMX() {
		Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedad__c='BRMX ALVO'); insert prod;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;
		Opportunity opp = new Opportunity(Name='OppTest',Stagename='Aprobada',CloseDate=System.today()); insert opp;
        OpportunityLineItem oItem = new OpportunityLineItem(Estado_facturacion__c='PE',OpportunityId=opp.Id,Quantity=100,PricebookEntryId=pbe.id, TotalPrice=1000,Bls_devolucion__c=0);insert oItem;
		
		Flujo_Doc_tmp__c doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZBDE';
		doc.ZZPOSSF__c = oItem.id;
		insert doc;
		String arg_vbtyp = 'O';
		String arg_fkart = 'ZBDE';
		String sociedad = 'BRMX';
		//sapFlujoDoc_caller.actItems(arg_vbtyp,arg_fkart,sociedad);

		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZBDF';
		doc.ZZPOSSF__c =  oItem.id;
		insert doc;
		arg_fkart = 'ZBDF';
		sociedad = 'BRMX';
		arg_vbtyp = 'O';
		//sapFlujoDoc_caller.actItems(arg_vbtyp,arg_fkart,sociedad);
		
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZBDG';
		doc.ZZPOSSF__c = oItem.id;
		insert doc;
		arg_vbtyp = 'O';
		arg_fkart = 'ZBDG';
		sociedad = 'BRMX';
		//sapFlujoDoc_caller.actItems(arg_vbtyp,arg_fkart,sociedad);
		
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZBDP';
		doc.ZZPOSSF__c = oItem.id;
		insert doc;
		arg_vbtyp = 'O';
		arg_fkart = 'ZBDP';
		sociedad = 'BRMX';
		//sapFlujoDoc_caller.actItems(arg_vbtyp,arg_fkart,sociedad);
		
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZBDR';
		doc.ZZPOSSF__c = oItem.id;
		insert doc;
		arg_vbtyp = 'O';
		arg_fkart = 'ZBDR';
		sociedad = 'BRMX';
		//sapFlujoDoc_caller.actItems(arg_vbtyp,arg_fkart,sociedad);
		
		doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		doc.VBTYP__c = 'O';
		doc.FKART__c = 'ZBDS';
		doc.ZZPOSSF__c = oItem.id;
		insert doc;
		arg_vbtyp = 'O';
		arg_fkart = 'ZBDS';
		sociedad = 'BRMX';
		sapFlujoDoc_caller.actItems();
		
		
	}
	
// ANULACIONES
	@isTest(seeAllData=false)
	static void test_actItems_ANULACIONES() {
		Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedad__c='BRMX ALVO'); insert prod;
                
        Pricebook2 pb = new Pricebook2(Name='local'); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=Test.getStandardPricebookId(),isActive=true); insert pbe_st;
        PricebookEntry pbe = new PricebookEntry(Product2Id=prod.Id,UnitPrice=2,Pricebook2Id=pb.Id,isActive=true); insert pbe;
		Opportunity opp = new Opportunity(Name='OppTest',Stagename='Aprobada',CloseDate=System.today()); insert opp;
        OpportunityLineItem oItem = new OpportunityLineItem(Estado_facturacion__c='PE',PricebookEntryId=pbe.id,OpportunityId=opp.Id,Quantity=100,TotalPrice=1000,Bls_devolucion__c=0);insert oItem;
		Flujo_Doc_tmp__c doc = new Flujo_Doc_tmp__c();
		doc.FKIMG__c = decimal.valueOf(1);
		doc.NETWR__c = decimal.valueOf(1);
		String arg_vbtyp = 'S';
		String arg_fkart = 'S2';
		doc.VBTYP__c = 'S';
		doc.FKART__c = 'S2';
		doc.ZZPOSSF__c = oItem.id;
		insert doc;
		String sociedad = 'BRMX';
		sapFlujoDoc_caller.actItems();

	}


}
global class previsionesController {

    WebService static String[] generarVenta(Id previsionId, Id CuentaId, Boolean rechazo) {
        Id rt_VB_Pe = null;
        Id rt_VB_Au = null;
        Decimal maximo = 0;
        Centro_Logistico__c  cLog = New Centro_Logistico__c();

        for (RecordType r: [SELECT Id, Name FROM RecordType WHERE Name IN ('VB - Pendiente', 'VB - Autorizada') AND SobjectType = 'Opportunity' AND IsActive = true]) {
        	if (r.Name == 'VB - Pendiente') { rt_VB_Pe = r.Id; }
        	if (r.Name == 'VB - Autorizada') { rt_VB_Au = r.Id; }
        }

        Opportunity OppClone = New Opportunity();
        Categoria__c tmpBasica = New Categoria__c();
        PricebookEntry tmpPrice = New PricebookEntry();
        Account cuenta = New Account();
        Map<String, Id> cLogistico = New Map<String, Id>();
        User propietario = New User();
        Set <String> tratadas = New Set<String>();

        Savepoint sp;
    	String[] retorno = New String[3];

        for (Centro_Logistico__c c: [SELECT Id, Marca__c FROM Centro_Logistico__c WHERE Name IN ('0094 - Passo Fundo')]) {
        	cLog = c;
        }

        try {
        	sp = Database.setSavepoint();
        	
            tmpBasica = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
            cuenta = [SELECT Id, Name FROM Account WHERE Id = :CuentaId limit 1];
	        List<OpportunityLineItem> OppCloneOLI = New List<OpportunityLineItem>();
            String soql = getCreatableFieldsSOQL('Opportunity','Id=\'' + previsionId + '\'');
            Opportunity prevision = (Opportunity)Database.query(soql);
            
            OppClone = prevision.clone(false,true);
            String identificador = prevision.Ejercicio__c;

            if (rechazo) {
            	OppClone.RecordTypeId = rt_VB_Au;
            	OppClone.StageName = 'Aprobada';
            	OppClone.Nro_Pedido_SAP__c = '';
            	OppClone.Observaciones_Paso_a_SAP__c = '';
            	OppClone.Origen__c = null;
            	OppClone.Name = 'COPIA ' + OppClone.Name;
            } else {
            	OppClone.RecordTypeId = rt_VB_Pe;
	            // OppClone.Name = 'VB-' + cuenta.Name.left(10)+' '+ OppClone.Marca__c + OppClone.Safra__c +'-'+ identificador;
	            OppClone.StageName = 'Edición';
	            OppClone.Oportunidad_Relacionada__c = previsionId;
	            OppClone.Previsao_Referencia__c = prevision.Name;
	            // OppClone.Condicion_de_Pago__c = 'ZC71 - Parcelado: 30,60 e 90 dias data fatura';
	            OppClone.Condicion_de_Pago__c = 'ZC01 - Parcelado: 30,60 e 90 dias data fatura';
                //OppClone.Tipo__c = 'ZCO - Oferta da Básica';
                OppClone.Tipo__c = 'ZB00 - BR Oferta';
	            OppClone.Fecha_fijacion_T_de_cambio__c = System.Today();
	            OppClone.Tipo_de_cambio__c = 1.0;
	            OppClone.Origen__c = cLog.Id;
	            OppClone.Bloqueo__c = 'Z4 - BR - Bloqueio Salesforce';
	            propietario = [SELECT Id, Profile.Name FROM User WHERE Id =: prevision.OwnerId];
	            // if (propietario.Profile.Name == 'Administrativo_licencias') {
                //     OppClone.Invierno__c = true;
                // }
            }

            insert OppClone;

            if (!rechazo) {
	        	Opportunity Pedido_Aux = [Select Id, Name, Nro_Autom_NV__c From Opportunity Where Id = : OppClone.Id];
	            Pedido_Aux.Name = Pedido_Aux.Nro_Autom_NV__c;
	            update Pedido_Aux;
            }

			for (PricebookEntry p: [SELECT Id FROM PricebookEntry WHERE Pricebook2Id = :prevision.Pricebook2Id AND Product2.Semilla_Tratada__c = true]) {
                tratadas.add(p.Id);
            }

            String soqlOLI = getCreatableFieldsSOQL('OpportunityLineItem','OpportunityId=\'' + previsionId + '\'');
            List<OpportunityLineItem> previsionOLI = (List<OpportunityLineItem>)Database.query(soqlOLI);

            for (OpportunityLineItem oli : previsionOLI) {
                OpportunityLineItem oliClone = oli.clone(false,true);
                oliClone.OpportunityId = OppClone.Id;
                oliClone.TotalPrice = null;
                oliClone.Precio_SAP__c = 0;
                oliClone.Tasas__c = null;
                oliClone.Base_de_Calculo__c = null;

                if (!rechazo) {
                    oliClone.Categoria__c = tmpBasica.Id;

                    if (oliClone.Previsao__c != null && oliClone.Previsao__c != 0) {
                        oliClone.Quantity = oliClone.Previsao__c;
                    } else {
                        oliClone.Quantity = 0.01;
                    }

                    if (tratadas.Contains(oliClone.PricebookEntryId)) {
                        oliClone.Tratamiento_de_Semilla__c = 'T05 - Cruiser+Maxim+Amulet';
                    } else {
                        oliClone.Tratamiento_de_Semilla__c = 'T00 - Sem';
                    }
                    
                    oliClone.Previsao__c = 0;
                    oliClone.Es_Previsao__c = false;
                    oliClone.Quant_Confirmada__c = 0;
                    oliClone.Quant_Rechazada__c = 0;
                    // oliClone.Motivo_de_Rechazo__c = 'Z9 - BR - Recusado para entregar';
                    // COMENTADO 04/04/2018 oliClone.Motivo_de_Rechazo__c = 'Z9 - Pendente de análise';
                    oliClone.Motivo_de_Rechazo__c = null;
                }
                
                OppCloneOLI.Add(oliClone);
            }

            insert OppCloneOLI;
            
            if (rechazo) {
            	prevision.StageName = 'AN - Anulada';
            } else {
                prevision.Ejercicio__c = identificador = String.ValueOf(Integer.ValueOf(Identificador) + 1);
            }

            update prevision;
            
			retorno[0] = 'Se ha creado la Venda da Basica.';
			retorno[1] = 'ok';
			retorno[2] = OppClone.Id;

			return retorno;

   		} catch(Exception e) {
			Database.rollback(sp);
			retorno[0] = 'Error al crear Venda da Basica.'+ e.getMessage();
			retorno[1] = '';
			retorno[2] = '';
			     
			return retorno;
        }
    }
    
    WebService static String[] generarConfirmacion(Id ventaId, Id CuentaId) {
        Id rt_CVB_Pe = null;
        Id rt_CVB_Au = null;
        Decimal maximo = 0;
        Boolean bloq = false;

        for (RecordType r: [SELECT Id, Name FROM RecordType WHERE Name IN ('CVB Pendiente', 'CVB Autorizada') AND SobjectType = 'Opportunity' AND IsActive = true]) {
        	if (r.Name == 'CVB Pendiente') { rt_CVB_Pe = r.Id; }
        	if (r.Name == 'CVB Autorizada') { rt_CVB_Au = r.Id; }
        }

        Opportunity OppClone = New Opportunity();
        Account cuenta = New Account();

        Savepoint sp;
    	String[] retorno = New String[3];
        
        try {
        	sp = Database.setSavepoint();
        	
            cuenta = [SELECT Id, Name FROM Account WHERE Id = :CuentaId LIMIT 1];
	        List<OpportunityLineItem> OppCloneOLI = New List<OpportunityLineItem>();
            String soql = getCreatableFieldsSOQL('Opportunity','Id=\'' + ventaId + '\'');
            Opportunity venta = (Opportunity)Database.query(soql);

            if (venta.Bloqueo__c != '' && venta.Bloqueo__c != null) {
				retorno[0] = 'Erro. Não é possível criar a confirmação até liberar o bloqueio de cabeçalho. \r\n Verificar com o financeiro';
				retorno[1] = '';
				retorno[2] = '';
                
				return retorno;
            }

            OppClone = venta.clone(false,true);
            // String identificador = venta.Ejercicio__c;
        	OppClone.RecordTypeId = rt_CVB_Pe;
            OppClone.StageName = 'Edición';
            OppClone.Oportunidad_Relacionada__c = ventaId;
            OppClone.Pedido_Relacionado__c = ventaId;
            OppClone.Previsao_Referencia__c = venta.Name;
            OppClone.Condicion_de_Pago__c = venta.Condicion_de_Pago__c;
            //OppClone.Tipo__c = 'ZBVN - Venda Normal';
            OppClone.Tipo__c = 'ZO12 - BR Venta Normal';
            OppClone.Fecha_fijacion_T_de_cambio__c = System.Today();
            OppClone.Tipo_de_cambio__c = 1.0;
            OppClone.Nro_Pedido_SAP__c = '';
            OppClone.Observaciones_Paso_a_SAP__c = '';
            OppClone.Origen__c = null;

            Boolean isVBCompleta = [SELECT RecordType.Name FROM Opportunity WHERE Id =: ventaId].RecordType.Name == 'Venda da Basica Completo';
            Id standarPricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true].Id;

            // Lógica de Venda de Basica Completo (US 1171 y US 8438), la nueva CVB Pendiente debe apuntar al Standar Pricebook 
            if (isVBCompleta) {
                OppClone.Pricebook2Id = standarPricebookId;
                oppClone.Condicion_de_Pago__c = 'ZC01 - Antecipado';
            }
            
            insert OppClone;

        	Opportunity Pedido_Aux = [Select Id, Name, Nro_Autom_NV__c From Opportunity Where Id = : OppClone.Id];
            Pedido_Aux.Name = Pedido_Aux.Nro_Autom_NV__c;
            update Pedido_Aux;
            
            String soqlOLI = getCreatableFieldsSOQL('OpportunityLineItem','OpportunityId=\'' + ventaId + '\'');
            List<OpportunityLineItem> ventaOLI = (List<OpportunityLineItem>)Database.query(soqlOLI);

            List<PricebookEntry> PBEs;

            if (isVBCompleta && venta.Pricebook2Id != standarPricebookId) {
                PBEs = [
                    SELECT Id, Product2.Variedade__r.Name, Product2.Variedade__r.Nombre_de_Registro__c, Product2.Categ__r.Name, Product2.UNIDADE__c FROM PriceBookEntry
                    WHERE Pricebook2Id = :standarPricebookId AND isActive = true
                ];
            }
			
            Set<Id> productIds = new Set<Id>();
            for(OpportunityLineItem oli : ventaOLI) {
                productIds.add(oli.Id_Producto__c);
            }
            Map<Id, Product2> productMap = new Map<Id, Product2>([SELECT Id, Categ__c FROM Product2 WHERE Id IN :productIds]);
            
            for (OpportunityLineItem oli : ventaOLI) {
                if (oli.Motivo_de_Rechazo__c != null && oli.Motivo_de_Rechazo__c.substring(0,2) == 'Z9') {
                    bloq = true;
                }
                
                if (oli.Quant_Pendiente__c > 0 && (oli.Motivo_de_Rechazo__c == null || (oli.Motivo_de_Rechazo__c != null && (oli.Motivo_de_Rechazo__c == '' || oli.Motivo_de_Rechazo__c == 'null')))) {
                    OpportunityLineItem oliClone = oli.clone(false,true);

                    oliClone.OpportunityId = OppClone.Id;
                    oliClone.Quantity = oli.Quant_Pendiente__c;
                    oliClone.TotalPrice = null;
                    oliClone.Precio_SAP__c = 0;
                    oliClone.Tasas__c = null;
                    oliClone.Base_de_Calculo__c = null;
                    oliClone.Id_Item_de_Oportunidad_Relacionado__c = oli.Id;
                    oliClone.Posicion_SAP_Relacionada__c = oli.Posicion_SAP__c;
                    oliClone.Motivo_de_Rechazo__c = '';
                    
                    if(oli.Categoria__c != null) {
                        oliClone.Categoria__c = oli.Categoria__c;
                    }
                    else if(oli.Id_Producto__c != null && productMap.containsKey(oli.Id_Producto__c)){
						oliClone.Categoria__c = productMap.get(oli.Id_Producto__c).Categ__c;                        
                    }

                    if (isVBCompleta && venta.Pricebook2Id != standarPricebookId && !PBEs.isEmpty()) {
                        Integer position = 0;
                        Boolean match = true;

                        while (match && position < PBEs.size()) {
                            Boolean match1 = PBEs[position].Product2.Variedade__r.Name == oli.Variedade_Prod__c;
                            Boolean match2 = PBEs[position].Product2.Categ__r.Name == oli.Categoria_Prod__c;
                            Boolean match3 = PBEs[position].Product2.UNIDADE__c == oli.UNIDADE__c;

                            if (match1 && match2 && match3) {
                                oliClone.PricebookEntryId = PBEs[position].Id;
                                match = false;
                            }

                            position++;
                        }
                    }
                    
                    OppCloneOLI.Add(oliClone);
                }
            }

            if (OppCloneOLI.isEmpty()) {
				Database.rollback(sp);

				if (bloq) {
                    retorno[0] = 'Error al crear la Confirmação da Venda da Basica. \r\n  La Oferta não tem quantidades pendentes o tem bloquio de remessa.';
                } else {
                    retorno[0] = 'Error al crear la Confirmação da Venda da Basica. \r\n  La Oferta não tem quantidades pendentes.';
                }

				retorno[1] = '';
				retorno[2] = '';
                
				return retorno;
            }

            insert OppCloneOLI;
            
			retorno[0] = 'Se ha creado la Confirmação da Venda da Basica.';
			retorno[1] = 'ok';
			retorno[2] = OppClone.Id;

			return retorno;
   		} catch(Exception e) {
            Database.rollback(sp);
            retorno[0] = 'Error al crear la Confirmação da Venda da Basica.'+ e.getMessage();
            retorno[1] = '';
            retorno[2] = '';
            
            System.debug(e.getMessage());
            return retorno;
        }
    }
    
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
        String selects = '';
         
        if (whereClause == null || whereClause == '') { return null; }
        
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null) {
            for (Schema.SObjectField ft : fMap.values()) { // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable() || fd.isCalculated()) { // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        
        if (!selectFields.isEmpty()) {
            for (string s : selectFields) { selects += s + ','; }
            if (selects.endsWith(',')) { selects = selects.substring(0,selects.lastIndexOf(',')); }
            
        	return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;     
        }
        
        return null;
    }

    @isTest(SeeAllData=true)
    public static void test(){
  		Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
  		RecordType rt_prev = [Select Id From RecordType Where Name = 'Previsao' And SObjectType = 'Opportunity' limit 1];
		RecordType rt_VBED = [Select Id From RecordType Where Name = 'VB - Pendiente' And SObjectType = 'Opportunity' limit 1];
		RecordType rt_VBAU = [Select Id From RecordType Where Name = 'VB - Autorizada' And SObjectType = 'Opportunity' limit 1];
  		Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
  		Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Opportunity prevision = New Opportunity(RecordTypeId=rt_prev.Id, Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
		insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi2;
        
        generarVenta(prevision.Id, cuenta.Id, false);
        
        oi2.Es_Previsao__c = true;
        update oi2;
        
        oi2.Previsao__c= 100;
        oi2.Motivo__c = 'TERERE';
        
        Test.startTest();
        update oi2;
        delete oi2;       
        delete prevision;
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void test2(){
  		Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
  		RecordType rt_prev = [Select Id From RecordType Where Name = 'Previsao' And SObjectType = 'Opportunity' limit 1];
		RecordType rt_VBED = [Select Id From RecordType Where Name = 'VB - Pendiente' And SObjectType = 'Opportunity' limit 1];
		RecordType rt_VBAU = [Select Id From RecordType Where Name = 'VB - Autorizada' And SObjectType = 'Opportunity' limit 1];
  		Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
  		Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];

        
        Opportunity op1 = New Opportunity(RecordTypeId=rt_VBED.Id, Name='Prueba 1', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert op1;
        delete op1;  

		Opportunity op2 = New Opportunity(RecordTypeId=rt_VBAU.Id, Name='Prueba 2', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert op2;
        delete op2;
    }

    @isTest(SeeAllData=true)
	public static void test3(){
  		Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
  		String[] ret = New String[3];
     	Map<String,Id> rt = New Map<String, Id>();
    	for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
    		rt.put(reTy.Name, reTy.Id);
  		//RecordType rt_prev = [Select Id From RecordType Where Name = 'Previsao' And SObjectType = 'Opportunity' limit 1];
		//RecordType rt_VBED = [Select Id From RecordType Where Name = 'VB - Pendiente' And SObjectType = 'Opportunity' limit 1];
		//RecordType rt_VBAU = [Select Id From RecordType Where Name = 'VB - Autorizada' And SObjectType = 'Opportunity' limit 1];
  		Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
  		Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Opportunity prevision = New Opportunity(RecordTypeId=rt.get('Previsao'), Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='20/21');
		insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi2;
        
        ret = generarVenta(prevision.Id, cuenta.Id, false);
        Opportunity vb = [SELECT Id, Name, RecordTypeId, StageName, Bloqueo__c FROM Opportunity WHERE Id= :ret[2] limit 1];
        vb.RecordTypeId = rt.get('VB - Pasada SAP');
        vb.StageName = 'Aprobada';
        vb.Bloqueo__c = '';
        test.starttest();
        //update vb;
        test.stoptest();
        //ret = generarConfirmacion(vb.Id, cuenta.Id);
    }

    @isTest(SeeAllData=true)
	public static void test4(){
  		Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
  		String[] ret = New String[3];
     	Map<String,Id> rt = New Map<String, Id>();
    	for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
    		rt.put(reTy.Name, reTy.Id);
  		//RecordType rt_prev = [Select Id From RecordType Where Name = 'Previsao' And SObjectType = 'Opportunity' limit 1];
		//RecordType rt_VBED = [Select Id From RecordType Where Name = 'VB - Pendiente' And SObjectType = 'Opportunity' limit 1];
		//RecordType rt_VBAU = [Select Id From RecordType Where Name = 'VB - Autorizada' And SObjectType = 'Opportunity' limit 1];
  		Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
  		Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];        
        Opportunity vb = New Opportunity(RecordTypeId=rt.get('Previsao'), Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aprobada', Safra__c='20/21',Condicion_de_Pago__c = 'ZC71 - Parcelado: 30,60 e 90 dias data fatura',Tipo__c = 'ZCO - Oferta da Básica', Bloqueo__c = null);
		insert vb;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=vb.Id,Quantity=100,Previsao__c = 100,TotalPrice=10,PricebookEntryId=pbe.Id,Motivo_de_Rechazo__c = null);
        insert oi2;
        
        ret = generarConfirmacion(vb.Id, cuenta.Id);
    }

    @isTest(SeeAllData=true)
	public static void test5(){
  		Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
  		String[] ret = New String[3];
     	Map<String,Id> rt = New Map<String, Id>();
    	for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
    		rt.put(reTy.Name, reTy.Id);
  		//RecordType rt_prev = [Select Id From RecordType Where Name = 'Previsao' And SObjectType = 'Opportunity' limit 1];
		//RecordType rt_VBED = [Select Id From RecordType Where Name = 'VB - Pendiente' And SObjectType = 'Opportunity' limit 1];
		//RecordType rt_VBAU = [Select Id From RecordType Where Name = 'VB - Autorizada' And SObjectType = 'Opportunity' limit 1];
  		Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
  		Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Opportunity prevision = New Opportunity(RecordTypeId=rt.get('VB - Pasada SAP'), Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aprobada', Safra__c='20/21');
		insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi2;
        
        ret = generarVenta(prevision.Id, cuenta.Id, true);
    }
}
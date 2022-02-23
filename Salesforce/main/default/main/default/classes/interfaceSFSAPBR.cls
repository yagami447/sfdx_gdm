global with sharing class interfaceSFSAPBR{
    global static Boolean isTest = false;
    global class customException extends Exception {}
    
    //global class oferta {
    
        //webservice String id;
        
    //}
    
    global class item_oferta {
    
        webservice String id;
        webservice String pSAP;
        webservice String motivRechazo;
        webservice String peneira;
        webservice String tratamiento;
        
                
    }
    
    global class retorno {
    
        webservice Boolean exito;
        webservice String mensajeUser;
        webservice String mensajeLog;
        webservice String id;
        webservice List<String> listaIds;
        webservice String idJob;
                
    }
    Webservice static retorno actualizaOferta(String Id, String bloqueo){	//(oferta cab, List<item_oferta> det)
        
        retorno ret = New retorno();                  
        //Set<Id> ofItIds = New Set<Id>();
        //Map<Id, OpportunityLineItem> ofItms = New Map<Id,OpportunityLineItem>();
        Savepoint sp;
        //Map<String,String> mapTrat = New Map<String,String>();
        //mapTrat.put('T05','T05 - Cruiser+Maxim+Amulet');mapTrat.put('T06','T06 - Cruiser+Maxim+Amulet+Co-Mo');
        try{
			
          	sp = Database.setSavepoint();
          	
          	Opportunity ofe = [SELECT Id, Account.Name, PE_bajar_SAP__c, Bloqueo__c, RecordType.Name FROM Opportunity WHERE Id = :Id];
          	
          	if(ofe.RecordType.Name != 'VB - Pasada SAP'){
	            ret.exito = false;            
	            ret.mensajeUser = 'Erro. Solo se permite actualizar a Oferta.';
	            ret.id = ofe.Id;                  
	            Database.rollback(sp);          		
          	}
          	
          	if(ofe.PE_bajar_SAP__c == true){
	            ret.exito = false;            
	            ret.mensajeUser = 'Erro ao actualizar a Oferta. A Oferta têm mudanças pendentes de baixar a SAP.';
	            ret.id = ofe.Id;                  
	            Database.rollback(sp);
          	}
          	if(bloqueo == null || bloqueo == ''){ ofe.Bloqueo__c = '';}
          	else{ofe.Bloqueo__c = bloqueo;}
          	
          	update ofe;
          	/*for(item_oferta i: det) ofItIds.add(i.id);
          	for(OpportunityLineItem oIt : [SELECT Id, OpportunityId, Posicion_SAP__c, Motivo_de_Rechazo__c, Grupo_de_materiales_2__c, Tratamiento_de_Semilla__c, Rechazado__c FROM OpportunityLineItem WHERE Id IN: ofItIds AND OpportunityId = :Id]){
          		ofItms.put(oIt.Id, oIt);
          	}
          	for(item_oferta i: det){
          		OpportunityLineItem tmp = New OpportunityLineItem();
          		if(ofItms.get(i.id).Rechazado__c != true){
					if(i.motivRechazo != '' && i.motivRechazo != null){
						tmp = ofItms.get(i.id);
						tmp.Motivo_de_Rechazo__c = i.motivRechazo; tmp.Rechazado__c = true;
						ofItms.remove(tmp.Id); ofItms.put(tmp.Id, tmp);
						continue;
					}
					if(i.peneira != ofItms.get(i.id).Grupo_de_materiales_2__c || i.tratamiento != ofItms.get(i.id).Tratamiento_de_Semilla__c){
						tmp = ofItms.get(i.id);
						if(i.peneira != tmp.Grupo_de_materiales_2__c) tmp.Grupo_de_materiales_2__c = i.peneira;
						if(i.tratamiento != tmp.Tratamiento_de_Semilla__c.substring(0,3) && tmp.Tratamiento_de_Semilla__c.substring(0,3) != 'T00'){
							tmp.Tratamiento_de_Semilla__c = mapTrat.get(i.tratamiento);
						}
						ofItms.remove(tmp.Id); ofItms.put(tmp.Id, tmp);
						continue;
					}
          		}
          	}
          	List<OpportunityLineItem> oliAct = ofItms.values();
          	update oliAct;*/
          	
          	
            ret.exito = true;
            ret.mensajeUser = 'A Oferta foi actualizada corretamente.'; 
            ret.mensajeLog = '';
            ret.id = ofe.Id;                        
            
        }catch(Exception e){               
            ret.exito = false;            
            ret.mensajeUser = 'Erro ao actualizar a Oferta. Faz favor, tente novamente.';
            ret.mensajeLog = 'Error: ' + e.getMessage(); 
            ret.id = Id;                  
            Database.rollback(sp);
        }
         
        
        return ret;
    }
	@isTest(SeeAllData=true)
	static void test() {
     
		isTest = true;
		Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
        Account cuenta = [Select Id, Estado__c From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' AND isActive = true limit 1];
        Opportunity o1 = new Opportunity(Name='TMPPROBANDOLASOPP',Pricebook2Id=pb.Id,AccountId=cuenta.Id,CloseDate=System.today(),StageName='AU - Autorizada',RecordTypeId=rt.get('VB - Pasada SAP'), Safra__c ='14/15', Marca__c='BRMX');
        PricebookEntry pbe = [Select Id, Product2Id, Product2.Categ__c From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__r.Name = 'BASICA' AND Product2.Semilla_Tratada__c = true limit 1];
        Categoria__c cat = [Select Id FROM Categoria__c WHERE Name = 'BASICA' limit 1];
        Estado__c est = [SELECT Id FROM Estado__c WHERE Name != 'PR' limit 1];
        insert o1;
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=o1.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Tipo_Registro__c = 'VB - Pasada SAP', Categoria__c = pbe.Product2.Categ__c, Tratamiento_de_Semilla__c = 'T06 - Cruiser+Maxim+Amulet+Co-Mo');
        insert oli1;


		interfaceSFSAPBR iSAPSF = New interfaceSFSAPBR();

		retorno ret;         
         
		interfaceSFSAPBR.item_oferta itm = new interfaceSFSAPBR.item_oferta(); 
         
		itm.id = oli1.Id;
		itm.pSAP = '000020';
		itm.motivRechazo = '';
		itm.peneira = '';
		itm.tratamiento = 'T05';
		
		List<interfaceSFSAPBR.item_oferta> deta = New List<interfaceSFSAPBR.item_oferta>();
		deta.add(itm);
		   
		ret = actualizaOferta(o1.Id, 'ZZ');
	}
	@isTest(SeeAllData=true)
	static void test1() {
     
		isTest = true;
		Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
        Account cuenta = [Select Id, Estado__c From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' AND isActive = true limit 1];
        Opportunity o1 = new Opportunity(Name='TMPPROBANDOLASOPP',Pricebook2Id=pb.Id,AccountId=cuenta.Id,CloseDate=System.today(),StageName='AU - Autorizada',RecordTypeId=rt.get('VB - Pasada SAP'), Safra__c ='14/15', Marca__c='BRMX', PE_bajar_SAP__c = true);
        PricebookEntry pbe = [Select Id, Product2Id, Product2.Categ__c From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__r.Name = 'BASICA' AND Product2.Semilla_Tratada__c = true limit 1];
        Categoria__c cat = [Select Id FROM Categoria__c WHERE Name = 'BASICA' limit 1];
        Estado__c est = [SELECT Id FROM Estado__c WHERE Name != 'PR' limit 1];
        insert o1;
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=o1.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Tipo_Registro__c = 'VB - Pasada SAP', Categoria__c = pbe.Product2.Categ__c, Tratamiento_de_Semilla__c = 'T06 - Cruiser+Maxim+Amulet+Co-Mo');
        insert oli1;


		interfaceSFSAPBR iSAPSF = New interfaceSFSAPBR();

		retorno ret;         
         
		interfaceSFSAPBR.item_oferta itm = new interfaceSFSAPBR.item_oferta(); 
         
		itm.id = oli1.Id;
		itm.pSAP = '000020';
		itm.motivRechazo = 'Z3';
		itm.peneira = 'P';
		itm.tratamiento = 'T05';
		
		List<interfaceSFSAPBR.item_oferta> deta = New List<interfaceSFSAPBR.item_oferta>();
		deta.add(itm);
		   
		ret = actualizaOferta(o1.Id, '');
	}
	@isTest(SeeAllData=true)
	static void test3() {
     
		isTest = true;
		Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
        Account cuenta = [Select Id, Estado__c From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' AND isActive = true limit 1];
        Opportunity o1 = new Opportunity(Name='TMPPROBANDOLASOPP',Pricebook2Id=pb.Id,AccountId=cuenta.Id,CloseDate=System.today(),StageName='AU - Autorizada',RecordTypeId=rt.get('VB - Autorizada'), Safra__c ='14/15', Marca__c='BRMX', PE_bajar_SAP__c = false);
        PricebookEntry pbe = [Select Id, Product2Id, Product2.Categ__c From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__r.Name = 'BASICA' AND Product2.Semilla_Tratada__c = true limit 1];
        Categoria__c cat = [Select Id FROM Categoria__c WHERE Name = 'BASICA' limit 1];
        Estado__c est = [SELECT Id FROM Estado__c WHERE Name != 'PR' limit 1];
        insert o1;
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=o1.Id,Quantity=10,TotalPrice=10,PricebookEntryId=pbe.Id, Tipo_Registro__c = 'VB - Pasada SAP', Categoria__c = pbe.Product2.Categ__c, Tratamiento_de_Semilla__c = 'T06 - Cruiser+Maxim+Amulet+Co-Mo');
        insert oli1;


		interfaceSFSAPBR iSAPSF = New interfaceSFSAPBR();

		retorno ret;         
         
		interfaceSFSAPBR.item_oferta itm = new interfaceSFSAPBR.item_oferta(); 
         
		itm.id = oli1.Id;
		itm.pSAP = '000020';
		itm.motivRechazo = 'Z3';
		itm.peneira = 'P';
		itm.tratamiento = 'T05';
		
		List<interfaceSFSAPBR.item_oferta> deta = New List<interfaceSFSAPBR.item_oferta>();
		deta.add(itm);
		   
		ret = actualizaOferta(o1.Id, '');
	}
}
@isTest
public with sharing class SalvarA2APITest {
    
    @TestSetup
    static void makeData(){

        Account account = new Account(Name='test');

        insert account;

        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo II').getRecordTypeId();

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'test config';
        opportunity.Accountid = account.Id;
        opportunity.Cultura__C = 'Milho';
        opportunity.Marca__C = 'BRMX';
        opportunity.Safra__C = '19/20';
        opportunity.RecordTypeId = recordTypeId;
        opportunity.StageName = 'Aprobada';
        opportunity.CloseDate = system.Today();

        insert opportunity;
		
        SiteUser__c testUser = new SiteUser__c();
		testUser.Email__c = 'test@gdm.com';
		testUser.Password__c = '123456';
        
		insert testUser;
        
        Categoria__c categoria = new Categoria__c(Name = 'BASICA',
                                                  Mostrar_en_portal__c = true);
        
		insert categoria;
        
        Variedad__c variedad = new Variedad__c(Name = 'Variedad1',
                                               Ativa__c = true,
                                               Regiao_disponivel_para_venda_basica__c = 'REGION 1',
                                               Disponivel_para_venda_basica__c = true,
                                               Marca_comercial__c = 'Brasmax');
        
        insert variedad;
        
        Product2 px1 = new Product2(Name = 'Test1',
                                    Especie__c = 'SOJA',
                                    Family = 'Royalty x Basica',
                                    Categ__c = categoria.Id,
                                    Variedade__c = variedad.Id );
        
        insert px1;
   		
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
                                        Pricebook2Id = pricebookId, Product2Id = px1.Id,
                                        UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 s = new Pricebook2(Name = 'Lista Canal Multiplicadores', IsActive = true);
      	insert s;
            
        PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,
                                                  	Product2Id=px1.ID,
                                                    UnitPrice=0.00,
                                                  	IsActive=TRUE,
                                                    UseStandardPrice=FALSE);
        
        insert pbesx;
        
        Configuracion_BMX__c configBMX = new Configuracion_BMX__c();
        configBMX.Name = '20/21';
        configBMX.PM_Safra_Actual_A1__c = '19/20';
        configBMX.PM_Safra_Actual_A2__c = '19/20';

        insert configBMX;

        Estado__c estado = new Estado__c(Name = 'Test Estado', Mostrar_en_portal__c = true);
        insert estado;

    }    
    
    @isTest
    public static void postSalvarA2APITest() {
        
        SalvarA2API.response result;
        Account account = [select Id from Account limit 1];
        SiteUser__c user = [select Id from SiteUser__c limit 1];
        Categoria__c categoria = [select Id from Categoria__c WHERE Mostrar_en_portal__c = true limit 1];
        Variedad__c variedad = [select Id FROM Variedad__c WHERE Name = 'Variedad1' limit 1];
        
        List<aAppendix.myOppItem> items = new List<aAppendix.myOppItem>();

        aAppendix.myOppItem item = new aAppendix.myOppItem();
            item.amount=1.00;
            item.area_autorizada='2';
            item.area_plantada='2';
            item.categoria=categoria.Id;
            item.categoria_a_rebajar=null;
            item.categoria_a_rebajar_id=null;
            item.categoria_id=null;
            item.categoria_nombre='BASICA';
            item.cnpj=null;
            item.descarte='1';
            item.epocaPlantio=null;
            item.error_lote=null;
            item.error_msg=null;
            item.estadoProduccion_id=null;
            item.estadoProduccion_nombre=null;
            item.estado_comer_id=null;
            item.haAutorizados=0.00;
            item.id='';
            item.indice=null;
            item.lote_rebajado=null;
            item.name=null;
            item.registro='8745 RSF';
            item.sem_aprobada='1';
            item.sem_beneficiada='2';
            item.sem_bruta='1';
            item.sem_comer='a';
            item.sem_bruta_A2=null;
            item.sem_comer_up_aIII=null;
            item.sem_rebajada='1';
            item.sem_uso_propio='1';
            item.unidadDescarte=null;
            item.unidade=null;
            item.unidade_nombre=null;
            item.variedad=variedad.Id;
            item.variedad_nombre='BMX DESAFIO RR';
            item.variedad_registro=null;

        items.add(item);
        
		SalvarA1API.Request requestBody = new SalvarA1API.Request();
        
        requestBody.accountId = account.Id;
        requestBody.marca = 'BRMX';
        requestBody.userId = user.Id;
        requestBody.aprobacion = '';
        requestBody.nuevosProductos = items;
        requestBody.idAnexoEditar = null;
        
		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarA1API/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarA2API.postSalvarA2API();
        test.stopTest();
        
        result = (SalvarA2API.response)JSON.deserialize(resp.responseBody.toString(), SalvarA2API.response.class);
      
        System.assertEquals(true, result.status);
    }
    
     @isTest
    public static void postSalvarA2APIAprovacionTest() {
        
    SalvarA2API.response result;
        Account account = [select Id from Account limit 1];
        SiteUser__c user = [select Id from SiteUser__c limit 1];
        Categoria__c categoria = [select Id from Categoria__c WHERE Mostrar_en_portal__c = true limit 1];
        Variedad__c variedad = [select Id FROM Variedad__c WHERE Name = 'Variedad1' limit 1];
        
         List<aAppendix.myOppItem> items = new List<aAppendix.myOppItem>();

        aAppendix.myOppItem item = new aAppendix.myOppItem();
            item.amount=1.00;
            item.area_autorizada='2';
            item.area_plantada='2';
            item.categoria=categoria.Id;
            item.categoria_a_rebajar=null;
            item.categoria_a_rebajar_id=null;
            item.categoria_id=null;
            item.categoria_nombre='BASICA';
            item.cnpj=null;
            item.descarte='1';
            item.epocaPlantio=null;
            item.error_lote=null;
            item.error_msg=null;
            item.estadoProduccion_id=null;
            item.estadoProduccion_nombre=null;
            item.estado_comer_id=null;
            item.haAutorizados=0.00;
            item.id='';
            item.indice=null;
            item.lote_rebajado=null;
            item.name=null;
            item.registro='8745 RSF';
            item.sem_aprobada='1';
            item.sem_beneficiada='2';
            item.sem_bruta='1';
            item.sem_comer='a';
            item.sem_bruta_A2=null;
            item.sem_comer_up_aIII=null;
            item.sem_rebajada='1';
            item.sem_uso_propio='1';
            item.unidadDescarte=null;
            item.unidade=null;
            item.unidade_nombre=null;
            item.variedad=variedad.Id;
            item.variedad_nombre='BMX DESAFIO RR';
            item.variedad_registro=null;

        items.add(item);
        
		SalvarA1API.Request requestBody = new SalvarA1API.Request();
        
        requestBody.accountId = account.Id;
        requestBody.marca = 'BRMX';
        requestBody.userId = user.Id;
        requestBody.aprobacion = 'true';
        requestBody.nuevosProductos = items;
        requestBody.idAnexoEditar = null;
        
		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarA1API/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarA2API.postSalvarA2API();
        test.stopTest();
        
        result = (SalvarA2API.response)JSON.deserialize(resp.responseBody.toString(), SalvarA2API.response.class);
      
        System.assertEquals(true, result.status);
    }

    @isTest
    public static void postSalvarA2APIEditA2Test() {
        
    SalvarA2API.response result;
        Account account = [select Id from Account limit 1];
        SiteUser__c user = [select Id from SiteUser__c limit 1];
        Categoria__c categoria = [select Id from Categoria__c WHERE Mostrar_en_portal__c = true limit 1];
        Variedad__c variedad = [select Id FROM Variedad__c WHERE Name = 'Variedad1' limit 1];
        Product2 product = [select Id from Product2 WHERE Name = 'Test1' limit 1];
        PricebookEntry prBEntry = [select Id from PricebookEntry where Product2Id = :product.Id limit 1];
        Estado__c estado = [select Id from Estado__c where Name = 'Test Estado'];

        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo II').getRecordTypeId();
        Opportunity opportunity2 = new Opportunity();
        opportunity2.Name = 'test opp';
        opportunity2.Accountid = account.Id;
        opportunity2.Cultura__C = 'Milho';
        opportunity2.Marca__C = 'BRMX';
        opportunity2.Safra__C = '19/20';
        opportunity2.RecordTypeId = recordTypeId;
        opportunity2.StageName = 'Edición';
        opportunity2.CloseDate = system.Today();

        insert opportunity2;

        OpportunityLineItem oppLineItem = new OpportunityLineItem(OpportunityId = opportunity2.Id,
                                                                  Product2Id = product.Id,
                                                                  PricebookEntryId = prBEntry.Id,
                                                                  Categoria__c = categoria.Id,
                                                                  UnitPrice = 10,
                                                                  Quantity = 1000,
                                                                  Semente_bruta__c = 1000,
                                                                  Estado_de_Comercializacion__c = estado.Id
                                                                  );

        insert oppLineItem;

        List<aAppendix.myOppItem> items = new List<aAppendix.myOppItem>();

        aAppendix.myOppItem item = new aAppendix.myOppItem();
            item.amount=1.00;
            item.area_autorizada='2';
            item.area_plantada='2';
            item.categoria=categoria.Id;
            item.categoria_a_rebajar=null;
            item.categoria_a_rebajar_id=null;
            item.categoria_id=null;
            item.categoria_nombre='BASICA';
            item.cnpj=null;
            item.descarte='1';
            item.epocaPlantio=null;
            item.error_lote=null;
            item.error_msg=null;
            item.estadoProduccion_id=null;
            item.estadoProduccion_nombre=null;
            item.estado_comer_id=null;
            item.haAutorizados=0.00;
            item.id=oppLineItem.Id;
            item.indice=null;
            item.lote_rebajado=null;
            item.name=null;
            item.registro='8745 RSF';
            item.sem_aprobada='1';
            item.sem_beneficiada='2';
            item.sem_bruta='1';
            item.sem_comer='a';
            item.sem_bruta_A2=null;
            item.sem_comer_up_aIII=null;
            item.sem_rebajada='1';
            item.sem_uso_propio='1';
            item.unidadDescarte=null;
            item.unidade=null;
            item.unidade_nombre=null;
            item.variedad=variedad.Id;
            item.variedad_nombre='BMX DESAFIO RR';
            item.variedad_registro=null;

        items.add(item);
        
		SalvarA1API.Request requestBody = new SalvarA1API.Request();
        
        requestBody.accountId = account.Id;
        requestBody.marca = 'BRMX';
        requestBody.userId = user.Id;
        requestBody.aprobacion = 'true';
        requestBody.nuevosProductos = items;
        requestBody.idAnexoEditar = opportunity2.Id;
        
		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarA1API/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarA2API.postSalvarA2API();
        test.stopTest();
        
        result = (SalvarA2API.response)JSON.deserialize(resp.responseBody.toString(), SalvarA2API.response.class);
      
        System.assertEquals(true, result.status);
    }

    @isTest
    public static void postSalvarA2APIEditA2NegativeTest() {
        
    SalvarA2API.response result;
        Account account = [select Id from Account limit 1];
        SiteUser__c user = [select Id from SiteUser__c limit 1];
        Categoria__c categoria = [select Id from Categoria__c WHERE Mostrar_en_portal__c = true limit 1];
        Variedad__c variedad = [select Id FROM Variedad__c WHERE Name = 'Variedad1' limit 1];
        Product2 product = [select Id from Product2 WHERE Name = 'Test1' limit 1];
        PricebookEntry prBEntry = [select Id from PricebookEntry where Product2Id = :product.Id limit 1];
        Estado__c estado = [select Id from Estado__c where Name = 'Test Estado'];

        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo II').getRecordTypeId();
        Opportunity opportunity2 = new Opportunity();
        opportunity2.Name = 'test opp';
        opportunity2.Accountid = account.Id;
        opportunity2.Cultura__C = 'Milho';
        opportunity2.Marca__C = 'BRMX';
        opportunity2.Safra__C = '19/20';
        opportunity2.RecordTypeId = recordTypeId;
        opportunity2.StageName = 'Aprobada';
        opportunity2.CloseDate = system.Today();

        insert opportunity2;

        OpportunityLineItem oppLineItem = new OpportunityLineItem(OpportunityId = opportunity2.Id,
                                                                  Product2Id = product.Id,
                                                                  PricebookEntryId = prBEntry.Id,
                                                                  Categoria__c = categoria.Id,
                                                                  UnitPrice = 10,
                                                                  Quantity = 1000,
                                                                  Semente_bruta__c = 1000,
                                                                  Estado_de_Comercializacion__c = estado.Id
                                                                  );

        insert oppLineItem;

        List<aAppendix.myOppItem> items = new List<aAppendix.myOppItem>();

        aAppendix.myOppItem item = new aAppendix.myOppItem();
            item.amount=1.00;
            item.area_autorizada='2';
            item.area_plantada='2';
            item.categoria=categoria.Id;
            item.categoria_a_rebajar=null;
            item.categoria_a_rebajar_id=null;
            item.categoria_id=null;
            item.categoria_nombre='BASICA';
            item.cnpj=null;
            item.descarte='1';
            item.epocaPlantio=null;
            item.error_lote=null;
            item.error_msg=null;
            item.estadoProduccion_id=null;
            item.estadoProduccion_nombre=null;
            item.estado_comer_id=null;
            item.haAutorizados=0.00;
            item.id=oppLineItem.Id;
            item.indice=null;
            item.lote_rebajado=null;
            item.name=null;
            item.registro='8745 RSF';
            item.sem_aprobada='1';
            item.sem_beneficiada='2';
            item.sem_bruta='1';
            item.sem_comer='a';
            item.sem_bruta_A2=null;
            item.sem_comer_up_aIII=null;
            item.sem_rebajada='1';
            item.sem_uso_propio='1';
            item.unidadDescarte=null;
            item.unidade=null;
            item.unidade_nombre=null;
            item.variedad=variedad.Id;
            item.variedad_nombre='BMX DESAFIO RR';
            item.variedad_registro=null;

        items.add(item);
        
		SalvarA1API.Request requestBody = new SalvarA1API.Request();
        
        requestBody.accountId = account.Id;
        requestBody.marca = 'BRMX';
        requestBody.userId = user.Id;
        requestBody.aprobacion = 'true';
        requestBody.nuevosProductos = items;
        requestBody.idAnexoEditar = opportunity2.Id;
        
		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarA1API/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarA2API.postSalvarA2API();
        test.stopTest();
        
        result = (SalvarA2API.response)JSON.deserialize(resp.responseBody.toString(), SalvarA2API.response.class);
      
        System.assertEquals(false, result.status);
    }
}
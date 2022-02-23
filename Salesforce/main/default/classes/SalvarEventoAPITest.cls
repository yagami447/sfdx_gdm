@IsTest
public class SalvarEventoAPITest {
    
    @TestSetup
    static void makeData(){
       
        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Variedad__c> varietyList = TestDataFactory.createVariety(1);
        List<Categoria__c> categoryList = TestDataFactory.createCategory(1);
        List<Product2> productList = TestDataFactory.createProduct(1, categoryList, varietyList);
        TestDataFactory.createPriceBookEntry(1, productList);
        TestDataFactory.createSiteUser(1);
       
    }           
    
	@isTest
    public static void salvarEventoTreinamento() {

        SalvarEventoAPI.Response result;
        
        List<Account> accountsList = [SELECT Id FROM Account Limit 10];
        List<SiteUser__c> siteUserList = [SELECT Id FROM SiteUser__c];
        List<Product2> productList = [SELECT Id, Obtentor__c FROM Product2];
        List<CRM_Calendario_de_Eventos__c> eventoList = TestDataFactory.createEventos(1, accountsList,'Treinamento Tecnico');
        List<CRM_Detalle_Calendario_de_eventos__c> detalleEventosList = TestDataFactory.createCalendarioEventos(1, eventoList, productList);
	
        List<aSiteEventosController.item> items = new List<aSiteEventosController.item>();
        aSiteEventosController.item item = new aSiteEventosController.item();

        item.id_producto=detalleEventosList[0].Cultivar__c;
        item.obtentor=detalleEventosList[0].Obtentor__c;
        item.data_plantio=detalleEventosList[0].Data_de_plantio__c; 
        item.data_colheita=detalleEventosList[0].Data_de_colheita__c;
        item.area_colhida = String.valueOf(detalleEventosList[0].Area_Colhida__c);
        item.area_plantada = String.valueOf(detalleEventosList[0].Area_plantada__c);
        item.produtividade = String.valueOf(detalleEventosList[0].Produtividade__c);
        item.volume_doado = String.valueOf(detalleEventosList[0].Volume_Doado__c);
        items.add(item);
        
        aSiteEventosController.evento evento = new aSiteEventosController.evento();

        evento.id = eventoList[0].Id;
        evento.fecha = eventoList[0].Data__c;
        evento.fechaInicio = eventoList[0].Data_e_horario_inicio__c;
        evento.fechaFin = eventoList[0].Data_e_horario_termino__c;
        evento.cuenta = eventoList[0].Cuenta__c;
        evento.safra = eventoList[0].Safra__c;
        evento.marca = eventoList[0].Marca__c;
        evento.revenda = eventoList[0].Revenda__c;
        evento.evento ='Treinamento Tecnico';
        
		SalvarEventoAPI.Request requestBody = new SalvarEventoAPI.Request();

        requestBody.items = items;
        requestBody.itemsBorrar = items;
        requestBody.evento = evento; 
        requestBody.userId = siteUserList[0].Id;

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEventoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.Response = resp;

        test.startTest();
        SalvarEventoAPI.salvarEventoAPI();
        test.stopTest();
        
        result = (SalvarEventoAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEventoAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(Label.SalvarEventoAPI_Success_Message, result.message);

    }
  	
    @isTest
    public static void salvarEventoLadoALado() {

        SalvarEventoAPI.Response result;
        
        List<Account> accountsList = [SELECT Id FROM Account Limit 10];
        List<SiteUser__c> siteUserList = [SELECT Id FROM SiteUser__c];
        List<Product2> productList = [SELECT Id, Obtentor__c FROM Product2];
	
        List<aSiteEventosController.item> items = new List<aSiteEventosController.item>();
        aSiteEventosController.item item = new aSiteEventosController.item();

        item.id_producto = productList[0].Id;
        item.obtentor = productList[0].Obtentor__c;
        item.data_plantio = Date.today(); 
        item.data_colheita = Date.today().addDays(1);
        item.area_colhida = '100';
        item.area_plantada = '100';
        item.produtividade = '100';
        item.volume_doado = '100';
        items.add(item);
        
        aSiteEventosController.evento evento = new aSiteEventosController.evento();

        evento.evento ='Lado a Lado';
        evento.cuenta = accountsList[0].Id;
        evento.safra = '20/21';
        evento.marca = 'BRMX';
        evento.agricultor = 'test nombre agricultor';
        evento.tipoAgricultor = 'CPF';
        evento.cpf_cnpj_agricultor = '00000000011';
        evento.latitud = '10.20';
        evento.longitud = '30.40';
        evento.usarCoorCiudad = true;
        evento.irrigado = true;
        evento.comentarios = 'test comentarios';
        evento.autorizado = true;
        evento.divulgarEmNomeDe = 'Multiplicador';

        
		SalvarEventoAPI.Request requestBody = new SalvarEventoAPI.Request();

        requestBody.items = items;
        requestBody.evento = evento; 
        requestBody.userId = siteUserList[0].Id;

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEventoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.Response = resp;

        test.startTest();
        SalvarEventoAPI.salvarEventoAPI();
        test.stopTest();
        
        result = (SalvarEventoAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEventoAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(Label.SalvarEventoAPI_Success_Message, result.message);

    }


    @isTest
    public static void salvarEventoEmplacamento() {

        SalvarEventoAPI.Response result;
        
        List<Account> accountsList = [SELECT Id FROM Account Limit 10];
        List<SiteUser__c> siteUserList = [SELECT Id FROM SiteUser__c];
        List<Product2> productList = [SELECT Id, Obtentor__c FROM Product2];
        List<CRM_Calendario_de_Eventos__c> eventoList = TestDataFactory.createEventos(1, accountsList,'Emplacamento');
        List<CRM_Detalle_Calendario_de_eventos__c> detalleEventosList = TestDataFactory.createCalendarioEventos(1, eventoList, productList);
	
        List<aSiteEventosController.item> items = new List<aSiteEventosController.item>();
        aSiteEventosController.item item = new aSiteEventosController.item();

        item.id_producto=detalleEventosList[0].Cultivar__c;
        item.obtentor=detalleEventosList[0].Obtentor__c;
        item.area_colhida = String.valueOf(detalleEventosList[0].Area_Colhida__c);
        item.produtividade = String.valueOf(detalleEventosList[0].Produtividade__c);
        item.volume_doado = String.valueOf(detalleEventosList[0].Volume_Doado__c);
        items.add(item);
        
        aSiteEventosController.evento evento = new aSiteEventosController.evento();

        evento.id = eventoList[0].Id;
        evento.cuenta = eventoList[0].Cuenta__c;
        evento.safra = eventoList[0].Safra__c;
        evento.marca = eventoList[0].Marca__c;
        evento.ciudad = eventoList[0].Municipio__c;
        evento.direccion = eventoList[0].Direccion__c;
        evento.agricultor = eventoList[0].Nome_do_agricultor_2__c;
        evento.tipoAgricultor = eventoList[0].Tipo_Conta_Agricultor__c;
        evento.cpf_cnpj_agricultor = eventoList[0].CNPJ_CPF_Agricultor__c;
        evento.irrigado = eventoList[0].Irrigado__c;
        evento.usarCoorCiudad = eventoList[0].Usar_coordenadas_da_Cidade__c;

        evento.evento ='Emplacamento';
        
		SalvarEventoAPI.Request requestBody = new SalvarEventoAPI.Request();

        requestBody.items = items;
        requestBody.itemsBorrar = items;
        requestBody.evento = evento; 
        requestBody.userId = siteUserList[0].Id;

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEventoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.Response = resp;

        test.startTest();
        SalvarEventoAPI.salvarEventoAPI();
        test.stopTest();
        
        result = (SalvarEventoAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEventoAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(Label.SalvarEventoAPI_Success_Message, result.message);

    }


    @isTest
    public static void salvarEventoOutdoor() {

        SalvarEventoAPI.Response result;
        
        List<Account> accountsList = [SELECT Id FROM Account Limit 10];
        List<SiteUser__c> siteUserList = [SELECT Id FROM SiteUser__c];
        List<Product2> productList = [SELECT Id, Obtentor__c FROM Product2];
        List<CRM_Calendario_de_Eventos__c> eventoList = TestDataFactory.createEventos(1, accountsList,'Emplacamento');
        List<CRM_Detalle_Calendario_de_eventos__c> detalleEventosList = TestDataFactory.createCalendarioEventos(1, eventoList, productList);
	
        List<aSiteEventosController.item> items = new List<aSiteEventosController.item>();
        aSiteEventosController.item item = new aSiteEventosController.item();

        item.id_producto=detalleEventosList[0].Cultivar__c;
        item.obtentor=detalleEventosList[0].Obtentor__c;
        items.add(item);
        
        aSiteEventosController.evento evento = new aSiteEventosController.evento();

        evento.id = eventoList[0].Id;
        evento.cuenta = eventoList[0].Cuenta__c;
        evento.safra = eventoList[0].Safra__c;
        evento.marca = eventoList[0].Marca__c;
        evento.ciudad = eventoList[0].Municipio__c;

        evento.evento ='Outdoor';
        
		SalvarEventoAPI.Request requestBody = new SalvarEventoAPI.Request();

        requestBody.items = items;
        requestBody.itemsBorrar = items;
        requestBody.evento = evento; 
        requestBody.userId = siteUserList[0].Id;

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEventoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.Response = resp;

        test.startTest();
        SalvarEventoAPI.salvarEventoAPI();
        test.stopTest();
        
        result = (SalvarEventoAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEventoAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(Label.SalvarEventoAPI_Success_Message, result.message);

    }

    @isTest
    public static void salvarEventoAreaComercial() {

        SalvarEventoAPI.Response result;
        
        List<Account> accountsList = [SELECT Id FROM Account Limit 10];
        List<SiteUser__c> siteUserList = [SELECT Id FROM SiteUser__c];
        List<Product2> productList = [SELECT Id, Obtentor__c FROM Product2];
        for(Product2 product : productList) {
            product.Obtentor__c = 'Brasmax';
        }
        update productList;
	
        List<aSiteEventosController.item> items = new List<aSiteEventosController.item>();
        aSiteEventosController.item item = new aSiteEventosController.item();

        item.id_producto = productList[0].Id;
        item.obtentor = productList[0].Obtentor__c;
        item.data_colheita = Date.today().addDays(1);
        item.area_colhida = '100';
        item.produtividade = '100';
        items.add(item);
        
        aSiteEventosController.evento evento = new aSiteEventosController.evento();

        evento.evento = 'Area comercial';
        evento.cuenta = accountsList[0].Id;
        evento.safra = '20/21';
        evento.marca = 'BRMX';
        evento.agricultor = 'test nombre agricultor';
        evento.irrigado = true;
        evento.comentarios = 'test comentarios';
     
		SalvarEventoAPI.Request requestBody = new SalvarEventoAPI.Request();

        requestBody.items = items;
        requestBody.evento = evento; 
        requestBody.userId = siteUserList[0].Id;

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEventoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.Response = resp;

        test.startTest();
        SalvarEventoAPI.salvarEventoAPI();
        test.stopTest();
        
        result = (SalvarEventoAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEventoAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(Label.SalvarEventoAPI_Success_Message, result.message);

    }
}
/**
* @name SalvarEstimativaAPITest
* @author Jhonny Peroza
* updated 08-11-2021
*
* UPDATED  26-Jan-2022  pablo.fraquia@cloudgaia.com /  Se actualizan y agregan métodos acorde a los requerimientos de  BUG-18829
*/

@isTest
public class SalvarEstimativaAPITest {

    final static String MARCA = 'BRMX';
    final static String MARCACOMERCIAL = 'Brasmax';
    final static String TIPO = 'Multiplicador';
    final static String REGIONCOMERCIAL = 'REGION 1';
 
    @TestSetup
    static void makeData(){

        Configuracion_BMX__c testConfig = new Configuracion_BMX__c(Name = 'Test Facturacion',
                                                                   CRM_Safra_Actual__c = '21/22',
                                                                   PM_Safra_Actual_VB_Estimativa_de_Compra__c = '21/22'
                                                                   );
        insert testConfig;
        
        Regiao__c testRegion = new Regiao__c(Name = 'REGION 1',
                                             Region_Comercial__c = 'REGION 1'
                                             );
        insert testRegion;
            
        List<Account> accList = new List<Account>();

        accList.add(new Account(Name = 'Test Account 1', 
                                Region__c = testRegion.Id, 
                                Supervisor__c = UserInfo.getUserId(),
                                Responsavel__c = '104 - Otavio Gorni'
                                ));

        accList.add(new Account(Name = 'Test Account 2', 
                                Region__c = testRegion.Id,
                                Supervisor__c = UserInfo.getUserId(),
                                Responsavel__c = '104 - Otavio Gorni'
                                ));
                                
        insert accList;
        
        List<Variedad__c> varietyList = new List<Variedad__c>();

        varietyList.add(new Variedad__c(Name = 'Test Variedad 1',
                                        Nombre_de_Registro__c = 'Test Variedad 1',
                                        Marca_comercial__c = MARCACOMERCIAL,
                                        Ativa__c = true,
                                        Regiao_disponivel_para_venda_basica__c = 'REGION 1;REGION 2;CERRADO',
                                        Disponivel_para_venda_basica__c = true,
                                        Cultura__c = 'MILHO'
                                        ));

        varietyList.add(new Variedad__c(Name = 'Test Variedad 2',
                                        Nombre_de_Registro__c = 'Test Variedad 2',
                                        Marca_comercial__c = MARCACOMERCIAL,
                                        Ativa__c = true,
                                        Regiao_disponivel_para_venda_basica__c = 'REGION 1;REGION 2;CERRADO',
                                        Disponivel_para_venda_basica__c = true,
                                        Cultura__c = 'MILHO'
                                        ));
                                        
        varietyList.add(new Variedad__c(Name = 'Test Variedad 3',
                                        Nombre_de_Registro__c = 'Test Variedad 3',
                                        Marca_comercial__c = MARCACOMERCIAL,
                                        Ativa__c = true,
                                        Regiao_disponivel_para_venda_basica__c = 'REGION 1;REGION 2;CERRADO',
                                        Disponivel_para_venda_basica__c = true,
                                        Cultura__c = 'MILHO'
                                        ));
                                        
        insert varietyList;
        
        Requisicao_de_compra__c testRequisicao = new Requisicao_de_compra__c(Multiplicador__c = accList[1].Id,
                                                                             Marca__c = MARCA,
                                                                             Safra__c = testConfig.PM_Safra_Actual_VB_Estimativa_de_Compra__c,
                                                                             Tipo__c = TIPO,
                                                                             Regiao_comercial__c = REGIONCOMERCIAL
                                                                             );

        insert testRequisicao;                                                                     

        List<Produto_de_Requisicao__c> tesProductList = new List<Produto_de_Requisicao__c>();
        
        tesProductList.add(new Produto_de_Requisicao__c(Quantidade__c = 10,
                                                        Variedad__c = varietyList[0].Id,
                                                        Requisicao_de_compra__c = testRequisicao.Id
                                                        ));

        tesProductList.add(new Produto_de_Requisicao__c(Quantidade__c = 20,
                                                        Variedad__c = varietyList[1].Id,
                                                        Requisicao_de_compra__c = testRequisicao.Id
                                                        ));
                                                        
        insert tesProductList;                                       
    }

    @isTest
    public static void saveEstimativaProductsTest() {

        List<Atributo_venda_de_basica__mdt> supportTierList = [SELECT Id, Marca__c, Usuario_Gerente_de_Marca__c FROM Atributo_venda_de_basica__mdt];

        Configuracion_BMX__c testConfig = [SELECT Id, Name, PM_Safra_Actual_VB_Estimativa_de_Compra__c FROM Configuracion_BMX__c WHERE Name = 'Test Facturacion' LIMIT 1];

        Account testAccount = [SELECT Id, Name, Region_comercial__c FROM Account WHERE Name = 'Test account 1' LIMIT 1];

        List<Variedad__c> testVarietyList = [SELECT Id, Name FROM Variedad__c WHERE Name IN ('Test Variedad 1','Test Variedad 2') LIMIT 2];
       
        List<aSiteVendaDeBasicaController.ProductoRequisicion> testItems = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        aSiteVendaDeBasicaController.ProductoRequisicion item1 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item1.cantidad=10;
        item1.variedadId = testVarietyList[0].Id;
        testItems.add(item1);

        aSiteVendaDeBasicaController.ProductoRequisicion item2 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item2.cantidad=20;
        item2.variedadId = testVarietyList[1].Id;
        testItems.add(item2);
        
        List<aSiteVendaDeBasicaController.ProductoRequisicion> emptyList = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        SalvarEstimativaAPI.response result;
        SalvarEstimativaAPI.Request requestBody = new SalvarEstimativaAPI.Request();

        requestBody.items = testItems;
        requestBody.itemsToRemove = emptyList;
        requestBody.requisicaoId = null;
        requestBody.multiplicadorId = testAccount.Id;
        requestBody.marca = MARCA;
        requestBody.tipo = TIPO;
        requestBody.regiaoComercial = REGIONCOMERCIAL;
        requestBody.paraAprobacion = true;

        RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEstimativaAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarEstimativaAPI.salvarEstimativa();
        test.stopTest();

        result = (SalvarEstimativaAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEstimativaAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(result.message, Label.SalvarEstimativaAPI_Success_Message);
        System.assertNotEquals(null, result.id);
    }

    @isTest
    public static void editEstimativaProductsTest() {

        List<Atributo_venda_de_basica__mdt> supportTierList = [SELECT Id, Marca__c, Usuario_Gerente_de_Marca__c FROM Atributo_venda_de_basica__mdt];

        Configuracion_BMX__c testConfig = [SELECT Id, Name, PM_Safra_Actual_VB_Estimativa_de_Compra__c FROM Configuracion_BMX__c WHERE Name = 'Test Facturacion' LIMIT 1];


        Account testAccount = [SELECT Id, Name, Region_comercial__c FROM Account WHERE Name = 'Test account 2' LIMIT 1];

        Requisicao_de_compra__c testRequisicao = [SELECT Id FROM Requisicao_de_compra__c WHERE Multiplicador__c = :testAccount.Id LIMIT 1];

        List<Variedad__c> testVarietyList = [SELECT Id, Name FROM Variedad__c WHERE Name IN ('Test Variedad 1','Test Variedad 2') LIMIT 2];
       
        List<aSiteVendaDeBasicaController.ProductoRequisicion> testItems = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        aSiteVendaDeBasicaController.ProductoRequisicion item1 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item1.cantidad=100;
        item1.variedadId = testVarietyList[0].Id;
        testItems.add(item1);

        aSiteVendaDeBasicaController.ProductoRequisicion item2 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item2.cantidad=200;
        item2.variedadId = testVarietyList[1].Id;
        testItems.add(item2);  
        
        List<aSiteVendaDeBasicaController.ProductoRequisicion> emptyList = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        SalvarEstimativaAPI.response result;
        SalvarEstimativaAPI.Request requestBody = new SalvarEstimativaAPI.Request();

        requestBody.items = testItems;
        requestBody.itemsToRemove = emptyList;
        requestBody.requisicaoId = testRequisicao.Id;
        requestBody.multiplicadorId = testAccount.Id;
        requestBody.marca = MARCA;
        requestBody.tipo = TIPO;
        requestBody.regiaoComercial = REGIONCOMERCIAL;
        requestBody.paraAprobacion = true;

        RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEstimativaAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarEstimativaAPI.salvarEstimativa();
        test.stopTest();

        Requisicao_de_compra__c testUpdatedRequisicao = [SELECT Id, Cantidad_Productos__c FROM Requisicao_de_compra__c WHERE Multiplicador__c = :testAccount.Id LIMIT 1];

        List<Produto_de_Requisicao__c> tesProductList = [SELECT Id, Quantidade__c, Variedad__c  FROM Produto_de_Requisicao__c WHERE Requisicao_de_compra__c = :testUpdatedRequisicao.Id LIMIT 2];

        result = (SalvarEstimativaAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEstimativaAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(result.message, Label.SalvarEstimativaAPI_Success_Message);
        System.assertEquals(testUpdatedRequisicao.Id, result.id);
        System.assertEquals(2, testUpdatedRequisicao.Cantidad_Productos__c);
        System.assertEquals(100, tesProductList[0].Quantidade__c);
    }

    @isTest
    public static void editEstimativaDeleteProductsTest() {

        List<Atributo_venda_de_basica__mdt> supportTierList = [SELECT Id, Marca__c, Usuario_Gerente_de_Marca__c FROM Atributo_venda_de_basica__mdt];

        Configuracion_BMX__c testConfig = [SELECT Id, Name, PM_Safra_Actual_VB_Estimativa_de_Compra__c FROM Configuracion_BMX__c WHERE Name = 'Test Facturacion' LIMIT 1];

        Account testAccount = [SELECT Id, Name, Region_comercial__c FROM Account WHERE Name = 'Test account 2' LIMIT 1];

        Requisicao_de_compra__c testRequisicao = [SELECT Id, Cantidad_Productos__c FROM Requisicao_de_compra__c WHERE Multiplicador__c = :testAccount.Id LIMIT 1];

        System.assertEquals(2, testRequisicao.Cantidad_Productos__c);

        List<Variedad__c> testVarietyList = [SELECT Id, Name FROM Variedad__c WHERE Name IN ('Test Variedad 1','Test Variedad 2') LIMIT 2];
       
        List<aSiteVendaDeBasicaController.ProductoRequisicion> testItems = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        aSiteVendaDeBasicaController.ProductoRequisicion item1 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item1.cantidad=100;
        item1.variedadId = testVarietyList[0].Id;
        testItems.add(item1);      
        
        List<aSiteVendaDeBasicaController.ProductoRequisicion> testItemsToRemove = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        aSiteVendaDeBasicaController.ProductoRequisicion item2 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item2.variedadId = testVarietyList[1].Id;
        testItemsToRemove.add(item2);  

        SalvarEstimativaAPI.response result;
        SalvarEstimativaAPI.Request requestBody = new SalvarEstimativaAPI.Request();

        requestBody.items = testItems;
        requestBody.itemsToRemove = testItemsToRemove;
        requestBody.requisicaoId = testRequisicao.Id;
        requestBody.multiplicadorId = testAccount.Id;
        requestBody.marca = MARCA;
        requestBody.tipo = TIPO;
        requestBody.regiaoComercial = REGIONCOMERCIAL;
        requestBody.paraAprobacion = true;

        RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEstimativaAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarEstimativaAPI.salvarEstimativa();
        test.stopTest();

        Requisicao_de_compra__c testUpdatedRequisicao = [SELECT Id, Cantidad_Productos__c FROM Requisicao_de_compra__c WHERE Multiplicador__c = :testAccount.Id LIMIT 1];

        List<Produto_de_Requisicao__c> tesProductList = [SELECT Id, Quantidade__c, Variedad__c  FROM Produto_de_Requisicao__c WHERE Requisicao_de_compra__c = :testUpdatedRequisicao.Id LIMIT 2];

        result = (SalvarEstimativaAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEstimativaAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(result.message, Label.SalvarEstimativaAPI_Success_Message);
        System.assertEquals(testUpdatedRequisicao.Id, result.id);
        System.assertEquals(1, testUpdatedRequisicao.Cantidad_Productos__c);
        System.assertEquals(100, tesProductList[0].Quantidade__c);
    }

    @isTest
    public static void editEstimativaAddProductTest() {

        List<Atributo_venda_de_basica__mdt> supportTierList = [SELECT Id, Marca__c, Usuario_Gerente_de_Marca__c FROM Atributo_venda_de_basica__mdt];

        Configuracion_BMX__c testConfig = [SELECT Id, Name, PM_Safra_Actual_VB_Estimativa_de_Compra__c FROM Configuracion_BMX__c WHERE Name = 'Test Facturacion' LIMIT 1];

        Account testAccount = [SELECT Id, Name, Region_comercial__c FROM Account WHERE Name = 'Test account 2' LIMIT 1];

        Requisicao_de_compra__c testRequisicao = [SELECT Id, Cantidad_Productos__c FROM Requisicao_de_compra__c WHERE Multiplicador__c = :testAccount.Id LIMIT 1];

        System.assertEquals(2, testRequisicao.Cantidad_Productos__c);

        List<Variedad__c> testVarietyList = [SELECT Id, Name FROM Variedad__c WHERE Name IN ('Test Variedad 1','Test Variedad 2', 'Test Variedad 3')];
       
        List<aSiteVendaDeBasicaController.ProductoRequisicion> testItems = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        aSiteVendaDeBasicaController.ProductoRequisicion item1 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item1.cantidad=10;
        item1.variedadId = testVarietyList[0].Id;
        testItems.add(item1);

        aSiteVendaDeBasicaController.ProductoRequisicion item2 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item2.cantidad=20;
        item2.variedadId = testVarietyList[1].Id;
        testItems.add(item2);   
        
        aSiteVendaDeBasicaController.ProductoRequisicion item3 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item3.cantidad=30;
        item3.variedadId = testVarietyList[2].Id;
        testItems.add(item3);

        List<aSiteVendaDeBasicaController.ProductoRequisicion> emptyList = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        SalvarEstimativaAPI.response result;
        SalvarEstimativaAPI.Request requestBody = new SalvarEstimativaAPI.Request();

        requestBody.items = testItems;
        requestBody.itemsToRemove = emptyList;
        requestBody.requisicaoId = testRequisicao.Id;
        requestBody.multiplicadorId = testAccount.Id;
        requestBody.marca = MARCA;
        requestBody.tipo = TIPO;
        requestBody.regiaoComercial = REGIONCOMERCIAL;
        requestBody.paraAprobacion = true;

        RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEstimativaAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarEstimativaAPI.salvarEstimativa();
        test.stopTest();

        Requisicao_de_compra__c testUpdatedRequisicao = [SELECT Id, Cantidad_Productos__c FROM Requisicao_de_compra__c WHERE Multiplicador__c = :testAccount.Id LIMIT 1];

        result = (SalvarEstimativaAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEstimativaAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(result.message, Label.SalvarEstimativaAPI_Success_Message);
        System.assertEquals(testUpdatedRequisicao.Id, result.id);
        System.assertEquals(3, testUpdatedRequisicao.Cantidad_Productos__c);

    }
    
    @isTest
    public static void editEstimativaEmptyProductTest() {

        List<Atributo_venda_de_basica__mdt> supportTierList = [SELECT Id, Marca__c, Usuario_Gerente_de_Marca__c FROM Atributo_venda_de_basica__mdt];

        Configuracion_BMX__c testConfig = [SELECT Id, Name, PM_Safra_Actual_VB_Estimativa_de_Compra__c FROM Configuracion_BMX__c WHERE Name = 'Test Facturacion' LIMIT 1];

        Account testAccount = [SELECT Id, Name, Region_comercial__c FROM Account WHERE Name = 'Test account 2' LIMIT 1];

        Requisicao_de_compra__c testRequisicao = [SELECT Id, Cantidad_Productos__c FROM Requisicao_de_compra__c WHERE Multiplicador__c = :testAccount.Id LIMIT 1];

        System.assertEquals(2, testRequisicao.Cantidad_Productos__c);

        List<Produto_de_Requisicao__c> tesProductList = [SELECT Id, Quantidade__c, Variedad__c  FROM Produto_de_Requisicao__c WHERE Requisicao_de_compra__c = :testRequisicao.Id];

        delete tesProductList;

        Requisicao_de_compra__c testEmptyRequisicao = [SELECT Id, Cantidad_Productos__c FROM Requisicao_de_compra__c WHERE Multiplicador__c = :testAccount.Id LIMIT 1];

        System.assertEquals(0, testEmptyRequisicao.Cantidad_Productos__c);

        List<Variedad__c> testVarietyList = [SELECT Id, Name FROM Variedad__c WHERE Name IN ('Test Variedad 1','Test Variedad 2', 'Test Variedad 3') LIMIT 3];
       
        List<aSiteVendaDeBasicaController.ProductoRequisicion> testItems = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        aSiteVendaDeBasicaController.ProductoRequisicion item1 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item1.cantidad=10;
        item1.variedadId = testVarietyList[0].Id;
        testItems.add(item1);

        aSiteVendaDeBasicaController.ProductoRequisicion item2 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item2.cantidad=20;
        item2.variedadId = testVarietyList[1].Id;
        testItems.add(item2);   
        
        aSiteVendaDeBasicaController.ProductoRequisicion item3 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item2.cantidad=30;
        item2.variedadId = testVarietyList[2].Id;
        testItems.add(item2);

        List<aSiteVendaDeBasicaController.ProductoRequisicion> emptyList = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        SalvarEstimativaAPI.response result;
        SalvarEstimativaAPI.Request requestBody = new SalvarEstimativaAPI.Request();

        requestBody.items = testItems;
        requestBody.itemsToRemove = emptyList;
        requestBody.requisicaoId = testRequisicao.Id;
        requestBody.multiplicadorId = testAccount.Id;
        requestBody.marca = MARCA;
        requestBody.tipo = TIPO;
        requestBody.regiaoComercial = REGIONCOMERCIAL;
        requestBody.paraAprobacion = true;

        RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEstimativaAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarEstimativaAPI.salvarEstimativa();
        test.stopTest();

        Requisicao_de_compra__c testUpdatedRequisicao = [SELECT Id, Cantidad_Productos__c FROM Requisicao_de_compra__c WHERE Multiplicador__c = :testAccount.Id LIMIT 1];

        result = (SalvarEstimativaAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEstimativaAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(result.message, Label.SalvarEstimativaAPI_Success_Message);
        System.assertEquals(testUpdatedRequisicao.Id, result.id);
        System.assertEquals(3, testUpdatedRequisicao.Cantidad_Productos__c);

    }

    @isTest
    public static void estimativeCouldNotBeSaved() {
	
        List<Atributo_venda_de_basica__mdt> supportTierList = [SELECT Id, Marca__c, Usuario_Gerente_de_Marca__c FROM Atributo_venda_de_basica__mdt];

        Configuracion_BMX__c testConfig = [SELECT Id, Name, PM_Safra_Actual_VB_Estimativa_de_Compra__c FROM Configuracion_BMX__c WHERE Name = 'Test Facturacion' LIMIT 1];


        Account testAccount = [SELECT Id, Name, Region_comercial__c FROM Account WHERE Name = 'Test account 1' LIMIT 1];

        List<Variedad__c> testVarietyList = [SELECT Id, Name FROM Variedad__c WHERE Name IN ('Test Variedad 1','Test Variedad 2') LIMIT 2];
       
        List<aSiteVendaDeBasicaController.ProductoRequisicion> testItems = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        aSiteVendaDeBasicaController.ProductoRequisicion item1 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item1.cantidad=10;
        item1.variedadId = testVarietyList[0].Id;
        testItems.add(item1);
        
        List<aSiteVendaDeBasicaController.ProductoRequisicion> emptyList = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        SalvarEstimativaAPI.response result;
        SalvarEstimativaAPI.Request requestBody = new SalvarEstimativaAPI.Request();

        requestBody.items = testItems;
        requestBody.itemsToRemove = emptyList;
        requestBody.requisicaoId = 'a1T0x000000XxxxXXX';
        requestBody.multiplicadorId = testAccount.Id;
        requestBody.marca = MARCA;
        requestBody.tipo = TIPO;
        requestBody.regiaoComercial = REGIONCOMERCIAL;
        requestBody.paraAprobacion = true;

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEstimativaAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarEstimativaAPI.salvarEstimativa();
        test.stopTest();
        
        result = (SalvarEstimativaAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEstimativaAPI.response.class);
      	
        System.assertEquals(false, result.status);
        System.assertNotEquals(result.message, Label.SalvarEstimativaAPI_Success_Message);
    }

    @isTest
    public static void estimativeCouldNotBeSubmitedForApproval() {
	
        List<Atributo_venda_de_basica__mdt> supportTierList = [SELECT Id, Marca__c, Usuario_Gerente_de_Marca__c FROM Atributo_venda_de_basica__mdt];

        Configuracion_BMX__c testConfig = [SELECT Id, Name, PM_Safra_Actual_VB_Estimativa_de_Compra__c FROM Configuracion_BMX__c WHERE Name = 'Test Facturacion' LIMIT 1];


        Account testAccount = [SELECT Id, Name, Region_comercial__c FROM Account WHERE Name = 'Test account 1' LIMIT 1];

        List<Variedad__c> testVarietyList = [SELECT Id, Name FROM Variedad__c WHERE Name IN ('Test Variedad 1','Test Variedad 2') LIMIT 2];
       
        List<aSiteVendaDeBasicaController.ProductoRequisicion> testItemsToRemove = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        aSiteVendaDeBasicaController.ProductoRequisicion item1 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        item1.variedadId = testVarietyList[0].Id;
        testItemsToRemove.add(item1);
        
        aSiteVendaDeBasicaController.ProductoRequisicion item2 = new aSiteVendaDeBasicaController.ProductoRequisicion();

        
        item2.variedadId = testVarietyList[1].Id;
        testItemsToRemove.add(item2); 

        List<aSiteVendaDeBasicaController.ProductoRequisicion> emptyList = new List<aSiteVendaDeBasicaController.ProductoRequisicion>();

        SalvarEstimativaAPI.response result;
        SalvarEstimativaAPI.Request requestBody = new SalvarEstimativaAPI.Request();

        requestBody.items = emptyList;
        requestBody.itemsToRemove = testItemsToRemove;
        requestBody.requisicaoId = testAccount.Id;
        requestBody.multiplicadorId = testAccount.Id;
        requestBody.marca = MARCA;
        requestBody.tipo = TIPO;
        requestBody.regiaoComercial = REGIONCOMERCIAL;
        requestBody.paraAprobacion = true;

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarEstimativaAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarEstimativaAPI.salvarEstimativa();
        test.stopTest();
        
        result = (SalvarEstimativaAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarEstimativaAPI.response.class);
      	
        System.assertEquals(false, result.status);
        System.assertNotEquals(result.message, Label.SalvarEstimativaAPI_Products_Quantity_Error_Message);
    }
}
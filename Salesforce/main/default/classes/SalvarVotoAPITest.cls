@isTest
public with sharing class SalvarVotoAPITest {
    
    @TestSetup
    static void makeData(){
        
        Regiao__c testRegion = new Regiao__c (Name = 'Test Region',
                                              Region_Comercial__c = 'REGION 1');
        
        insert testRegion;                          
        
        Id recordTypeIdTestAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta').getRecordTypeId();
        
        Account testAccount = new Account(Name='TestAccount',
                                          Region__c = testRegion.Id,
                                          RecordTypeId = recordTypeIdTestAccount,
                                          CNPJ_CPF__c = 'CNPJ',
                                          Grupo_de_Cuentas__c = 'CPJU');
        
        insert testAccount;
        
        Variedad__c testVariedad = new Variedad__c(Name = 'testVariedad',
                                                   Ativa__c = true,
                                                   Regiao_disponivel_para_venda_basica__c = 'REGION 1',
                                                   Disponivel_para_venda_basica__c = true,
                                                   Marca_comercial__c = 'BRASMAX',
                                                   Unidade_Preco__c = 'KG',
                                                   Licenciada__c = true,
                                                   Cultura__c = 'MILHO',
                                                   Region_bonificacion__c = 'SUL',
                                                   Safra_Lancamento__c = '21/22');
        
        insert testVariedad;
        
        Categoria__c testCategoria = new Categoria__c(Name = 'BASICA',
                                                      Mostrar_en_portal__c = true);
        
        insert testCategoria;
        
        Product2 testProduct = new Product2(Name = 'TestProduct',
                                            Especie__c = 'MILHO',
                                            Family = 'Royalty x Basica',
                                            Categ__c = testCategoria.Id,
                                            Variedade__c = testVariedad.Id,
                                            IsActive = true,
                                            Price__c = 0,
                                            ProductCode = 'TestProduct',
                                            Obtentor__c = 'Outros',
                                            UNIDADE__c = 'Saca 60 Mil Sementes');
        
        insert testProduct;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry testStandardPrice = new PricebookEntry(Pricebook2Id = pricebookId, 
                                                              Product2Id = testProduct.Id,
                                                              UnitPrice = 10000, 
                                                              IsActive = true);
        insert testStandardPrice;
        
        Date myDate = Date.today();
        Date fechaLimiteVotacion = myDate.addYears(5);
        
        Configuracion_BMX__c testConfigBMX = new Configuracion_BMX__c (Name = 'TestFacturación', 
                                                                       CRM_Safra_Actual__c = '21/22', 
                                                                       Votacion_nro_de_vuelta__c = 1, 
                                                                       Votacion_Cerrado_Nro_de_vuelta__c = 1, 
                                                                       Votaci_n_fecha_hasta__c = fechaLimiteVotacion,
                                                                       Votacion_Cerrado_fecha_hasta__c = fechaLimiteVotacion);
        
        insert testConfigBMX;
        
        Id recordTypeIdCMTermoAditivoComercial = Schema.SObjectType.Contrato__c.getRecordTypeInfosByName().get('Termo Aditivo Comerciais').getRecordTypeId();
        
        Contrato__c testContratoDeMultiplicacion = new Contrato__c(Multiplicador__c = testAccount.Id,
                                                                   Sociedad__c = 'BRMX',
                                                                   Safra__c = '21/22',
                                                                   Region_Comercial__c = 'REGION 1',
                                                                   Estados_Comercializacao__c = 'AC',
                                                                   Tipos_de_Assinaturas__c = 'Manual',
                                                                   RecordTypeId = recordTypeIdCMTermoAditivoComercial,
                                                                   Estado__c = 'Chegou');
        
        insert testContratoDeMultiplicacion;
        
        Id recordTypeIdIDCVolumen = Schema.SObjectType.Item_del_Contrato__c.getRecordTypeInfosByName().get('Volumen').getRecordTypeId();
        
        Item_del_Contrato__c testItemDelContrato = new Item_del_Contrato__c(Name = 'TestItemDelContrato',
                                                                            Contrato_de_Multiplicacion__c = testContratoDeMultiplicacion.Id,
                                                                            Cultivar__c = testProduct.Id,
                                                                            Precio__c = 1,
                                                                            Variedad__c = testVariedad.Id,
                                                                            RecordTypeId = recordTypeIdIDCVolumen,
                                                                            Volumen_Aut_Comercializacion__c = 2,
                                                                            Cotacao_de_soja__c = '1');
        
        insert testItemDelContrato;
        
    }    
    
    @isTest
    public static void postSalvarVotoAPISuccessTest() {
        
        SalvarVotoAPI.response result;
        
        Account account = [SELECT Id
                           FROM Account
                           WHERE Name = 'TestAccount' 
                           LIMIT 1];
        
        Product2 product = [SELECT Id 
                            FROM Product2 
                            WHERE Name = 'TestProduct' 
                            LIMIT 1];                                 
        
        double precio = 5.10;
        
        SalvarVotoAPI.Request requestBody = new SalvarVotoAPI.Request();
        
        requestBody.accountId = account.Id;
        requestBody.productId = product.Id;
        requestBody.precio = precio;
        
        RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarVotoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));
        
        RestContext.request = req;
        RestContext.response = resp;
        
        test.startTest();
        SalvarVotoAPI.postSalvarVotoAPI();
        test.stopTest();
        
        result = (SalvarVotoAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarVotoAPI.response.class);
        
        System.assertEquals(true, result.status);
        System.assertNotEquals('', result.id);
    }
    
    @isTest
    public static void postSalvarVotoAPIFailForRegionTest() {
        
        SalvarVotoAPI.response result;
        
        Account account = [SELECT Id 
                           FROM Account
                           WHERE Name = 'TestAccount' 
                           LIMIT 1];
        account.Region__c = null;
        
        update account;
        
        Product2 product = [SELECT Id 
                            FROM Product2 
                            WHERE Name = 'TestProduct' 
                            LIMIT 1];                                 
        
        double precio = 5.10;
        
        SalvarVotoAPI.Request requestBody = new SalvarVotoAPI.Request();
        
        requestBody.accountId = account.Id;
        requestBody.productId = product.Id;
        requestBody.precio = precio;   
        
        RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarVotoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));
        
        RestContext.request = req;
        RestContext.response = resp;
        
        test.startTest();
        SalvarVotoAPI.postSalvarVotoAPI();
        test.stopTest();
        
        result = (SalvarVotoAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarVotoAPI.response.class);
        
        System.assertEquals(false, result.status);
        System.assertEquals('Por favor, verifique a região de sua conta para votar', result.message);
        System.assertEquals('', result.id);
    }
    
    @isTest
    public static void postSalvarVotoAPIFailForVotacionNullTest() {
        
        SalvarVotoAPI.response result;
        
        Account account = [SELECT Id 
                           FROM Account
                           WHERE Name = 'TestAccount' 
                           LIMIT 1];
        
        Product2 product = [SELECT Id 
                            FROM Product2 
                            WHERE Name = 'TestProduct' 
                            LIMIT 1];                                 
        
        double precio = 5.10;
        
        Configuracion_BMX__c configBMX = [SELECT Id 
                                          FROM Configuracion_BMX__c 
                                          WHERE Name = 'TestFacturación' 
                                          LIMIT 1];
        
        configBMX.Votacion_nro_de_vuelta__c = null;
        configBMX.Votacion_Cerrado_Nro_de_vuelta__c = null;
        
        update configBMX;
        
        SalvarVotoAPI.Request requestBody = new SalvarVotoAPI.Request();
        
        requestBody.accountId = account.Id;
        requestBody.productId = product.Id;
        requestBody.precio = precio;   
        
        
        RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarVotoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));
        
        RestContext.request = req;
        RestContext.response = resp;
        
        test.startTest();
        SalvarVotoAPI.postSalvarVotoAPI();
        test.stopTest();
        
        result = (SalvarVotoAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarVotoAPI.response.class);
        
        System.assertEquals(false, result.status);
        System.assertEquals('Attempt to de-reference a null object', result.message);
        System.assertEquals('', result.id);
    }
    
    @isTest
    public static void postSalvarVotoAPIFailForYaVotoTest() {
        
        SalvarVotoAPI.response result;
        
        Account account = [SELECT Id 
                           FROM Account
                           WHERE Name = 'TestAccount' 
                           LIMIT 1];
        
        Product2 product = [SELECT Id 
                            FROM Product2 
                            WHERE Name = 'TestProduct' 
                            LIMIT 1]; 
        
        double precio = 5.10;
        
        SalvarVotoAPI.Request requestBody = new SalvarVotoAPI.Request();
        
        requestBody.accountId = account.Id;
        requestBody.productId = product.Id;
        requestBody.precio = precio;
        
        RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarVotoAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));
        
        RestContext.request = req;
        RestContext.response = resp;
        
        test.startTest();
        SalvarVotoAPI.postSalvarVotoAPI();
        SalvarVotoAPI.postSalvarVotoAPI();
        test.stopTest();
        
        result = (SalvarVotoAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarVotoAPI.response.class);
        
        System.assertEquals(false, result.status);
        System.assertEquals('A votação já foi feita para esta variedade.', result.message);
        System.assertEquals('', result.id);
    }
}
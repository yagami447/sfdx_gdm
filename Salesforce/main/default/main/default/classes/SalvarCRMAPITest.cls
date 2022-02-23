/**
* @name SalvarCRMAPITest
* @author Jhonny Peroza
* updated 19-11-2021
*
* updated pablo.fraquia@cloudgaia.com 02-feb-2022
*/
@isTest
public class SalvarCRMAPITest {

    @TestSetup
    static void makeData(){
       
        Configuracion_BMX__c testConfig = new Configuracion_BMX__c();
        testConfig.Name = 'Facturacion';
        testConfig.PM_Safra_Actual_Eventos__c = '22/23';

        insert testConfig;

        Regiao__c testRegion = new Regiao__c();
        testRegion.Name = 'REGION 1';
        testRegion.Region_Comercial__c = 'REGION 1';
        
        insert testRegion;

        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.Supervisor__c = UserInfo.getUserId();
        testAccount.Region__c = testRegion.Id;
        testAccount.Responsavel__c = '104 - Otavio Gorni';

        insert testAccount;
    
        Categoria__c testCategory = new Categoria__c();
        testCategory.Name = 'Test Catgory';

        insert testCategory;

        Variedad__c testVariety = new Variedad__c();
        testVariety.Name = 'Test Variety';
        testVariety.Nombre_de_Registro__c  = 'Test Variety';
        testVariety.Marca_comercial__c = 'Brasmax';
        testVariety.Ativa__c = true;
        testVariety.Regiao_disponivel_para_venda_basica__c = 'REGION 1;REGION 2;CERRADO';
        testVariety.Disponivel_para_venda_basica__c = true;
        testVariety.Cultura__c = 'MILHO';

        insert testVariety;

        List<Product2> productList = new List<Product2>();

        Product2 testProduct1 = new Product2();
        testProduct1.Categ__c = testCategory.Id;
        testProduct1.ProductCode = 'CODE001';
        testProduct1.Name = 'Test Product 1';
        testProduct1.Variedad__c = testVariety.Id;
        testProduct1.Variedade__c = testVariety.Id;
        testProduct1.Variedade_Licenciada__c = testVariety.Id;
        testProduct1.Obtentor__c = 'Brasmax';
      
        productList.add(testProduct1);

        Product2 testProduct2 = new Product2();
        testProduct2.Categ__c = testCategory.Id;
        testProduct2.ProductCode = 'CODE002';
        testProduct2.Name = 'Test Product 2';
        testProduct2.Variedad__c = testVariety.Id;
        testProduct2.Variedade__c = testVariety.Id;
        testProduct2.Variedade_Licenciada__c = testVariety.Id;
        testProduct2.Obtentor__c = 'Brasmax';
      
        productList.add(testProduct2);

        insert productList;
   
        Resumo_da_conta__c TestCRM = new Resumo_da_conta__c();
        TestCRM.Name = 'Test CRM';
        TestCRM.Fase__c = 'Edição';
        TestCRM.Marca__c = 'BRMX';
        TestCRM.Safra__c = testConfig.PM_Safra_Actual_Eventos__c;
        TestCRM.Multiplicador__c = testAccount.Id;
       
        insert TestCRM;
        
        List<Estado_para_CRM__c> testEstadosCRMList = new List<Estado_para_CRM__c>();

        Estado_para_CRM__c testCRMEstadoAC = new Estado_para_CRM__c();
        testCRMEstadoAC.Name = 'Test CRM ESTADO AC';
        testCRMEstadoAC.Estado__c = 'Acre (AC)';
        testCRMEstadoAC.Percentagem_de_venda__c = 50.00;
        testCRMEstadoAC.CRM__c = TestCRM.Id;
        
        testEstadosCRMList.add(testCRMEstadoAC);

        Estado_para_CRM__c testCRMEstadoSP = new Estado_para_CRM__c();
        testCRMEstadoSP.Name = 'Test CRM ESTADO SP';
        testCRMEstadoSP.Estado__c = 'São Paulo (SP)';
        testCRMEstadoSP.Percentagem_de_venda__c = 50.00;
        testCRMEstadoSP.CRM__c = TestCRM.Id;
        
        testEstadosCRMList.add(testCRMEstadoSP);

        insert testEstadosCRMList;

        List<Item_de_resumo_da_conta__c> itemsList = new List<Item_de_resumo_da_conta__c>();
                                        
        Item_de_resumo_da_conta__c testItem1 = new Item_de_resumo_da_conta__c();
                                                
        testItem1.Name = 'Test CRM ITEM 1';
        testItem1.Obtentor__c = 'Brasmax';
        testItem1.Produto__c = productList[0].Id;
        testItem1.Resumo_da_conta__c = TestCRM.Id;
        itemsList.add(testItem1);
                                        
        Item_de_resumo_da_conta__c testItem2 = new Item_de_resumo_da_conta__c();
                                                
        testItem2.Name = 'Test CRM ITEM 2';
        testItem2.Obtentor__c = 'Brasmax';
        testItem2.Produto__c = productList[1].Id;
        testItem2.Resumo_da_conta__c = TestCRM.Id;
        itemsList.add(testItem2);
                                        
        insert itemsList;
               
    } 

    @isTest
    public static void saveCRMTestPositive() {

        SalvarCRMAPI.response result;
        SalvarCRMAPI.Request requestBody = new SalvarCRMAPI.Request();

        Account TestMultiplicador = [SELECT Id 
                                        FROM Account 
                                            WHERE Name = 'Test Account'
                                                LIMIT 1];

        List<Estado_para_CRM__c> testEstadosCRMList = [SELECT Id, Name, Estado__c
                                                            FROM Estado_para_CRM__c 
                                                                WHERE Name = 'Test CRM ESTADO AC'
                                                                    LIMIT 1];                                                         

        List<WrapperCRM.Estados> estadoCRMList = new List<WrapperCRM.Estados>();

        WrapperCRM.Estados estadoCRM_AC = new WrapperCRM.Estados();
                                        
        estadoCRM_AC.nombre = testEstadosCRMList[0].Name;
        estadoCRM_AC.nombreEstado = testEstadosCRMList[0].Estado__c;
        estadoCRM_AC.porcentaje = 100.00;
        estadoCRMList.add(estadoCRM_AC);
                                        
        List<Item_de_resumo_da_conta__c> itemsList = [SELECT Name, Obtentor__c, Produto__c 
                                                            FROM Item_de_resumo_da_conta__c
                                                                WHERE Name IN ('Test CRM ITEM 1', 'Test CRM ITEM 2')
                                                                    LIMIT 2];

        List<WrapperCRM.Items> itemCRMList = new List<WrapperCRM.Items>();
                                        
        WrapperCRM.Items itemCRM1 = new WrapperCRM.Items();
                                        
        itemCRM1.nombre = itemsList[0].Name;
        itemCRM1.obtentor = itemsList[0].Obtentor__c;
        itemCRM1.producto = itemsList[0].Produto__c;
        itemCRMList.add(itemCRM1);
                                        
        WrapperCRM.Items itemCRM2 = new WrapperCRM.Items();
                                        
        itemCRM2.nombre = itemsList[1].Name;
        itemCRM2.obtentor = itemsList[1].Obtentor__c;
        itemCRM2.producto = itemsList[1].Produto__c;
        itemCRMList.add(itemCRM2);

        List<WrapperCRM.Estados> emptyEstadosList = new List<WrapperCRM.Estados>();
        List<WrapperCRM.Items> emptyItemsList = new List<WrapperCRM.Items>();
                                                                                
        WrapperCRM.Crm  testNewCRM = new WrapperCRM.Crm();

        testNewCRM.capacidadUBS = 300;
        testNewCRM.produccionTotalesSafraAnterior = 250;
        testNewCRM.ventasTotalesSafraAnterior = 250;
        testNewCRM.numeroDeVendedores = 15;
        testNewCRM.numeroDeUnidades = 10;
        testNewCRM.proyeccionProduccionSafraAnual = 300;
        testNewCRM.proyeccionVentaSafraAnual = 300;
        testNewCRM.ventaAgricultores = 20;
        testNewCRM.marca = 'BRMX';
        testNewCRM.nombre = 'Test NEW CRM';
        testNewCRM.accountId = TestMultiplicador.Id;
        

        requestBody.aprobacion = true;
        requestBody.crmId = null;
        requestBody.crm = testNewCRM;
        requestBody.estados = estadoCRMList;
        requestBody.estadosToRemove = emptyEstadosList;
        requestBody.items = itemCRMList;
        requestBody.itemsToRemove = emptyItemsList;
        
		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarCRMAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarCRMAPI.salvarCRM();
        test.stopTest();
        
        result = (SalvarCRMAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarCRMAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(result.message, SalvarCRMAPI.SUCCESSMESSAGE);
        System.assertNotEquals(null, result.Id);
    }

    @isTest
    public static void saveCRMTestNegative() {

        SalvarCRMAPI.response result;
        SalvarCRMAPI.Request requestBody = new SalvarCRMAPI.Request();

        List<Estado_para_CRM__c> testEstadosCRMList = [SELECT Id, Name, Estado__c
                                                            FROM Estado_para_CRM__c 
                                                                WHERE Name = 'Test CRM ESTADO AC'
                                                                    LIMIT 1];                                                         

        List<WrapperCRM.Estados> estadoCRMList = new List<WrapperCRM.Estados>();

        WrapperCRM.Estados estadoCRM_AC = new WrapperCRM.Estados();
                                        
        estadoCRM_AC.nombre = testEstadosCRMList[0].Name;
        estadoCRM_AC.nombreEstado = testEstadosCRMList[0].Estado__c;
        estadoCRM_AC.porcentaje = 50.00;
        estadoCRMList.add(estadoCRM_AC);
                                        
        List<Item_de_resumo_da_conta__c> itemsList = [SELECT Name, Obtentor__c, Produto__c 
                                                            FROM Item_de_resumo_da_conta__c
                                                                WHERE Name IN ('Test CRM ITEM 1', 'Test CRM ITEM 2')
                                                                    LIMIT 2];

        List<WrapperCRM.Items> itemCRMList = new List<WrapperCRM.Items>();
                                        
        WrapperCRM.Items itemCRM1 = new WrapperCRM.Items();
                                        
        itemCRM1.nombre = itemsList[0].Name;
        itemCRM1.obtentor = itemsList[0].Obtentor__c;
        itemCRM1.producto = itemsList[0].Produto__c;
        itemCRMList.add(itemCRM1);
                                        
        WrapperCRM.Items itemCRM2 = new WrapperCRM.Items();
                                        
        itemCRM2.nombre = itemsList[1].Name;
        itemCRM2.obtentor = itemsList[1].Obtentor__c;
        itemCRM2.producto = itemsList[1].Produto__c;
        itemCRMList.add(itemCRM2);

        List<WrapperCRM.Estados> emptyEstadosList = new List<WrapperCRM.Estados>();
        List<WrapperCRM.Items> emptyItemsList = new List<WrapperCRM.Items>();
                                                                                
        WrapperCRM.Crm  testNewCRM = new WrapperCRM.Crm();

        testNewCRM.capacidadUBS = 300;
        testNewCRM.produccionTotalesSafraAnterior = 250;
        testNewCRM.ventasTotalesSafraAnterior = 250;
        testNewCRM.numeroDeVendedores = 15;
        testNewCRM.numeroDeUnidades = 10;
        testNewCRM.proyeccionProduccionSafraAnual = 300;
        testNewCRM.proyeccionVentaSafraAnual = 300;
        testNewCRM.ventaAgricultores = 20;
        testNewCRM.marca = 'BRMX';
        testNewCRM.nombre = 'Test NEW CRM';
        testNewCRM.accountId = 'Wrong Id';
        

        requestBody.aprobacion = true;
        requestBody.crmId = null;
        requestBody.crm = testNewCRM;
        requestBody.estados = estadoCRMList;
        requestBody.estadosToRemove = emptyEstadosList;
        requestBody.items = itemCRMList;
        requestBody.itemsToRemove = emptyItemsList;

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarCRMAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarCRMAPI.salvarCRM();
        test.stopTest();
        
        result = (SalvarCRMAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarCRMAPI.response.class);
      	
        System.assertEquals(false, result.status);
        System.assertNotEquals(result.message, SalvarCRMAPI.SUCCESSMESSAGE);
    }

    @isTest
    public static void couldNotSaveCRMStates() {

        SalvarCRMAPI.response result;
        SalvarCRMAPI.Request requestBody = new SalvarCRMAPI.Request();

        Account TestMultiplicador = [SELECT Id 
                                        FROM Account 
                                            WHERE Name = 'Test Account'
                                                LIMIT 1];

        List<Estado_para_CRM__c> testEstadosCRMList = [SELECT Id, Name, Estado__c
                                                            FROM Estado_para_CRM__c 
                                                                WHERE Name = 'Test CRM ESTADO AC'
                                                                    LIMIT 1];                                                         

        List<WrapperCRM.Estados> estadoCRMList = new List<WrapperCRM.Estados>();

        WrapperCRM.Estados estadoCRM_AC = new WrapperCRM.Estados();
                                        
        estadoCRM_AC.nombre = testEstadosCRMList[0].Name;
        estadoCRM_AC.nombreEstado = testEstadosCRMList[0].Estado__c;
        estadoCRM_AC.porcentaje = 50.00;
        estadoCRMList.add(estadoCRM_AC);
                                        
        List<Item_de_resumo_da_conta__c> itemsList = [SELECT Name, Obtentor__c, Produto__c 
                                                            FROM Item_de_resumo_da_conta__c
                                                                WHERE Name IN ('Test CRM ITEM 1', 'Test CRM ITEM 2')
                                                                    LIMIT 2];

        List<WrapperCRM.Items> itemCRMList = new List<WrapperCRM.Items>();
                                        
        WrapperCRM.Items itemCRM1 = new WrapperCRM.Items();
                                        
        itemCRM1.nombre = itemsList[0].Name;
        itemCRM1.obtentor = itemsList[0].Obtentor__c;
        itemCRM1.producto = itemsList[0].Produto__c;
        itemCRMList.add(itemCRM1);
                                        
        WrapperCRM.Items itemCRM2 = new WrapperCRM.Items();
                                        
        itemCRM2.nombre = itemsList[1].Name;
        itemCRM2.obtentor = itemsList[1].Obtentor__c;
        itemCRM2.producto = itemsList[1].Produto__c;
        itemCRMList.add(itemCRM2);

        List<WrapperCRM.Estados> emptyEstadosList = new List<WrapperCRM.Estados>();
        List<WrapperCRM.Items> emptyItemsList = new List<WrapperCRM.Items>();
                                                                                
        WrapperCRM.Crm  testNewCRM = new WrapperCRM.Crm();

        testNewCRM.capacidadUBS = 300;
        testNewCRM.produccionTotalesSafraAnterior = 250;
        testNewCRM.ventasTotalesSafraAnterior = 250;
        testNewCRM.numeroDeVendedores = 15;
        testNewCRM.numeroDeUnidades = 10;
        testNewCRM.proyeccionProduccionSafraAnual = 300;
        testNewCRM.proyeccionVentaSafraAnual = 300;
        testNewCRM.ventaAgricultores = 20;
        testNewCRM.marca = 'BRMX';
        testNewCRM.nombre = 'Test NEW CRM';
        testNewCRM.accountId = TestMultiplicador.Id;
        

        requestBody.aprobacion = true;
        requestBody.crmId = null;
        requestBody.crm = testNewCRM;
        requestBody.estados = estadoCRMList;
        requestBody.estadosToRemove = emptyEstadosList;
        requestBody.items = itemCRMList;
        requestBody.itemsToRemove = emptyItemsList;

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarCRMAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarCRMAPI.salvarCRM();
        test.stopTest();
        
        result = (SalvarCRMAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarCRMAPI.response.class);
      	
        System.assertEquals(false, result.status);
        System.assertEquals(result.message, SalvarCRMAPI.FIRSTERRORMESSAGE);
    }

    @isTest
    public static void couldNotSaveCRMItems() {

        SalvarCRMAPI.response result;
        SalvarCRMAPI.Request requestBody = new SalvarCRMAPI.Request();

        Account TestMultiplicador = [SELECT Id 
                                        FROM Account 
                                            WHERE Name = 'Test Account'
                                                LIMIT 1];

        List<Estado_para_CRM__c> testEstadosCRMList = [SELECT Id, Name, Estado__c
                                                            FROM Estado_para_CRM__c 
                                                                WHERE Name = 'Test CRM ESTADO AC'
                                                                    LIMIT 1];                                                         

        List<WrapperCRM.Estados> estadoCRMList = new List<WrapperCRM.Estados>();

        WrapperCRM.Estados estadoCRM_AC = new WrapperCRM.Estados();
                                        
        estadoCRM_AC.nombre = testEstadosCRMList[0].Name;
        estadoCRM_AC.nombreEstado = testEstadosCRMList[0].Estado__c;
        estadoCRM_AC.porcentaje = 100.00;
        estadoCRMList.add(estadoCRM_AC);
                                        
        List<Item_de_resumo_da_conta__c> itemsList = [SELECT Name, Obtentor__c, Produto__c 
                                                            FROM Item_de_resumo_da_conta__c
                                                                WHERE Name IN ('Test CRM ITEM 1', 'Test CRM ITEM 2')
                                                                    LIMIT 2];

        List<WrapperCRM.Items> itemCRMList = new List<WrapperCRM.Items>();
                                        
        WrapperCRM.Items itemCRM1 = new WrapperCRM.Items();
                                        
        itemCRM1.nombre = itemsList[0].Name;
        itemCRM1.obtentor = 'Wrong Obtentor';
        itemCRM1.producto = 'Wrong Id';
        itemCRMList.add(itemCRM1);
                                        
        WrapperCRM.Items itemCRM2 = new WrapperCRM.Items();
                                        
        itemCRM2.nombre = itemsList[1].Name;
        itemCRM2.obtentor = itemsList[1].Obtentor__c;
        itemCRM2.producto = itemsList[1].Produto__c;
        itemCRMList.add(itemCRM2);

        List<WrapperCRM.Estados> emptyEstadosList = new List<WrapperCRM.Estados>();
        List<WrapperCRM.Items> emptyItemsList = new List<WrapperCRM.Items>();
                                                                                
        WrapperCRM.Crm  testNewCRM = new WrapperCRM.Crm();

        testNewCRM.capacidadUBS = 300;
        testNewCRM.produccionTotalesSafraAnterior = 250;
        testNewCRM.ventasTotalesSafraAnterior = 250;
        testNewCRM.numeroDeVendedores = 15;
        testNewCRM.numeroDeUnidades = 10;
        testNewCRM.proyeccionProduccionSafraAnual = 300;
        testNewCRM.proyeccionVentaSafraAnual = 300;
        testNewCRM.ventaAgricultores = 20;
        testNewCRM.marca = 'BRMX';
        testNewCRM.nombre = 'Test NEW CRM';
        testNewCRM.accountId = TestMultiplicador.Id;
        

        requestBody.aprobacion = true;
        requestBody.crmId = null;
        requestBody.crm = testNewCRM;
        requestBody.estados = estadoCRMList;
        requestBody.estadosToRemove = emptyEstadosList;
        requestBody.items = itemCRMList;
        requestBody.itemsToRemove = emptyItemsList;

		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarCRMAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarCRMAPI.salvarCRM();
        test.stopTest();
        
        result = (SalvarCRMAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarCRMAPI.response.class);
      	
        System.assertEquals(false, result.status);
        System.assertNotEquals(result.message, SalvarCRMAPI.SUCCESSMESSAGE);
    }

    @isTest
    public static void editCRMDeletingEstadosTestPositive() {

        SalvarCRMAPI.response result;
        SalvarCRMAPI.Request requestBody = new SalvarCRMAPI.Request();

        Account TestMultiplicador = [SELECT Id 
                                        FROM Account 
                                            WHERE Name = 'Test Account'
                                                LIMIT 1];

        Resumo_da_conta__c testCRM = [SELECT Id
                                          FROM Resumo_da_conta__c 
                                              WHERE Multiplicador__c =: TestMultiplicador.Id
                                                  LIMIT 1];

        List<Estado_para_CRM__c> testEstadosCRMList = [SELECT Id, Name, Estado__c
                                                            FROM Estado_para_CRM__c 
                                                                WHERE CRM__c =: testCRM.Id];    
                                                                    
        System.assertEquals(2, testEstadosCRMList.size());

        List<WrapperCRM.Estados> estadoToRemoveList = new List<WrapperCRM.Estados>();

        WrapperCRM.Estados estadoToRemove = new WrapperCRM.Estados();
                                        
        estadoToRemove.id = testEstadosCRMList[0].Id;
        estadoToRemoveList.add(estadoToRemove);

        WrapperCRM.Estados estadoToRemoveAndEdit = new WrapperCRM.Estados();
                                        
        estadoToRemoveAndEdit.id = testEstadosCRMList[1].Id;
        estadoToRemoveList.add(estadoToRemoveAndEdit);

        List<WrapperCRM.Estados> estadoToEditList = new List<WrapperCRM.Estados>();

        WrapperCRM.Estados estadoToEdit = new WrapperCRM.Estados();
        
        estadoToEdit.nombre = testEstadosCRMList[1].Name;
        estadoToEdit.nombreEstado = testEstadosCRMList[1].Estado__c;
        estadoToEdit.porcentaje = 100.00;
        estadoToEditList.add(estadoToEdit);
                                        
        List<WrapperCRM.Items> emptyItemsList = new List<WrapperCRM.Items>();
                                                                                
        requestBody.aprobacion = true;
        requestBody.crmId = testCRM.Id;
        requestBody.crm = null;
        requestBody.estados = estadoToEditList;
        requestBody.estadosToRemove = estadoToRemoveList;
        requestBody.items = emptyItemsList;
        requestBody.itemsToRemove = emptyItemsList;
        
		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarCRMAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarCRMAPI.salvarCRM();
        test.stopTest();
        
        List<Estado_para_CRM__c> testEstadosCRMListUpdated = [SELECT Id, Percentagem_de_venda__c 
                                                                  FROM Estado_para_CRM__c 
                                                                      WHERE CRM__c =: testCRM.Id];

        result = (SalvarCRMAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarCRMAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(result.message, SalvarCRMAPI.SUCCESSMESSAGE);
        System.assertEquals(100, testEstadosCRMListUpdated[0].Percentagem_de_venda__c);
        System.assertEquals(1, testEstadosCRMListUpdated.size());
        System.assertEquals(testCRM.Id, result.Id);
    }

    @isTest
    public static void editCRMDeletingItemsTestPositive() {

        SalvarCRMAPI.response result;
        SalvarCRMAPI.Request requestBody = new SalvarCRMAPI.Request();

        Account TestMultiplicador = [SELECT Id 
                                        FROM Account 
                                            WHERE Name = 'Test Account'
                                                LIMIT 1];

        Resumo_da_conta__c testCRM = [SELECT Id
                                          FROM Resumo_da_conta__c 
                                              WHERE Multiplicador__c =: TestMultiplicador.Id
                                                  LIMIT 1];

        List<Item_de_resumo_da_conta__c> testItemsCRMList = [SELECT Id, Name, Obtentor__c, Produto__c
                                                                 FROM Item_de_resumo_da_conta__c 
                                                                     WHERE Resumo_da_conta__c =: testCRM.Id];    
                                                                    
        System.assertEquals(2, testItemsCRMList.size());

        List<WrapperCRM.items> itemsToRemoveList = new List<WrapperCRM.items>();

        WrapperCRM.items itemToRemove = new WrapperCRM.items();
                                        
        itemToRemove.id = testItemsCRMList[0].Id;
        itemsToRemoveList.add(itemToRemove);

        WrapperCRM.items itemToRemoveAndEdit = new WrapperCRM.items();
                                        
        itemToRemoveAndEdit.id = testItemsCRMList[1].Id;
        itemsToRemoveList.add(itemToRemoveAndEdit);

        List<WrapperCRM.items> itemsToEditList = new List<WrapperCRM.items>();

        WrapperCRM.items itemToEdit = new WrapperCRM.items();
              
        itemToEdit.nombre = testItemsCRMList[1].Name;
        itemToEdit.obtentor = testItemsCRMList[1].Obtentor__c;
        itemToEdit.producto = testItemsCRMList[1].Produto__c;

        itemsToEditList.add(itemToEdit);

        List<WrapperCRM.Estados> emptyEstadosList = new List<WrapperCRM.Estados>();
                                                                                    
        requestBody.aprobacion = true;
        requestBody.crmId = testCRM.Id;
        requestBody.crm = null;
        requestBody.estados = emptyEstadosList;
        requestBody.estadosToRemove = emptyEstadosList;
        requestBody.items = itemsToEditList;
        requestBody.itemsToRemove = itemsToRemoveList;
        
		RestResponse resp = new RestResponse();
        RestRequest req = new RestRequest(); 
        
        req.requestURI = '/services/apexrest/SalvarCRMAPI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(requestBody));

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        SalvarCRMAPI.salvarCRM();
        test.stopTest();
        
        List<Item_de_resumo_da_conta__c> testItemsCRMListUpdated = [SELECT Id, Name
                                                                        FROM Item_de_resumo_da_conta__c 
                                                                            WHERE Resumo_da_conta__c =: testCRM.Id];

        result = (SalvarCRMAPI.response)JSON.deserialize(resp.responseBody.toString(), SalvarCRMAPI.response.class);
      	
        System.assertEquals(true, result.status);
        System.assertEquals(result.message, SalvarCRMAPI.SUCCESSMESSAGE);
        System.assertEquals(1, testItemsCRMListUpdated.size());
        System.assertEquals(testCRM.Id, result.Id);
    }
}
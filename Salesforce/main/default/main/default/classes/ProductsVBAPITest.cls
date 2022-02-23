@isTest
public class ProductsVBAPITest {

    final static String TESTSAFRA = '21/22';
    final static String TESTWRONGSAFRA = '20/21';
    final static String TESTMARCA = 'BRMX';
    
    @TestSetup
    static void makeData(){
        
        Date myDate = Date.today();
        Date testOppCloseDate = myDate.addYears(2);
        Date testOppNovoPrimeiroVencimento = myDate.addMonths(1);
        Date testOppNovoSegundoVencimento = myDate.addMonths(2);
        Date testCampaignStartDate = myDate;
        Date testCamapignEndDate = myDate.addMonths(3);
        Date testQuoteExpirationDate = testCamapignEndDate;
        Date testQuoteNovoPrimeiroVencimento = testOppNovoPrimeiroVencimento;
        Date testQuoteNovoSegundoVencimento = testOppNovoSegundoVencimento;

        Regiao__c testRegion = new Regiao__c (Name = 'Test Region',
                                              Region_Comercial__c = 'REGION 1');

        insert testRegion;                          

        Id recordTypeIdTestAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta').getRecordTypeId();

        Account testAccount = new Account(Name='TestAccount',
                                          Region__c = testRegion.Id,
                                          RecordTypeId = recordTypeIdTestAccount,
                                          CNPJ_CPF__c = 'CPF',
                                          Grupo_de_Cuentas__c = 'CMEX');

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
                                            Price__c = 1,
                                            ProductCode = 'TestProduct',
                                            Obtentor__c = 'Outros',
                                            UNIDADE__c = 'Saca 60 Mil Sementes');

        insert testProduct;
		
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry testStandardPrice = new PricebookEntry(Pricebook2Id = pricebookId, 
                                                              Product2Id = testProduct.Id,
                                                              UnitPrice = 10, 
                                                              IsActive = true);
        insert testStandardPrice;

        Id recordTypeIdTestCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Venda de Basica').getRecordTypeId();

        Campaign testCampaign = new Campaign(Name = 'testCamapign',
                                             RecordtypeId = recordTypeIdTestCampaign,
                                             Conta__c = testAccount.Id,
                                             Status = 'En curso',
                                             Epoca_de_Producao__c = 'Verão',
                                             IsActive = true,
                                             Cultura__c = 'Milho',
                                             Lista_de_precios__c = testStandardPrice.Pricebook2Id,
                                             Region_VB__c = 'REGION 1',
                                             Safra__c = '21/22',
                                             Marca__c = 'BRMX',
                                             StartDate = testCampaignStartDate,
                                             EndDate = testCamapignEndDate,
                                             Numero_maximo_de_parcelas__c = 3,
                                             Primeiro_vencimento__c =  testCampaignStartDate.addMonths(1),
                                             Segundo_vencimento__c =  testCampaignStartDate.addMonths(2),
                                             Terceiro_vencimiento__c = testCamapignEndDate,
                                             Juros__c = 1,
                                             Juros_para_cada_dias__c = 30.4,
                                             Kg_para_primeiro_preco__c = 10,
                                             Kg_para_segundo_preco__c = 10,
                                             Kg_para_terceiro_prec__c = 10,
                                             Kg_para_quarto_preco__c = 10,
                                             Primeiro_Preco_Multiplicacao__c = 1,
                                             Segundo_Preco_Multiplicacao__c = 2,
                                             Terceiro_Preco_Multiplicacao__c = 3,
                                             Quarto_Preco_Multiplicacao__c = 4,
                                             Primeiro_Preco_Difusao__c = 1,
                                             Segundo_Preco_Difusao__c = 2,
                                             Terceiro_Preco_Difusao__c = 3,
                                             Quarto_Preco_Difusao__c = 4,
                                             Kg_para_2_parcelas_no_m_ximo__c = 2,
                                             Kg_para_3_parcelas_no_m_ximo__c = 3,
                                             Kg_para_4_parcelas_no_m_ximo__c = 4,
                                             Kg_para_5_parcelas_no_m_ximo__c =5);

        insert testCampaign;

        Id recordTypeIdTestOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venda da Basica Completo').getRecordTypeId();

        Opportunity testOpp = new Opportunity(Name='TestOpportunity',
                                              AccountId = testAccount.Id,
                                              RecordTypeId = recordTypeIdTestOpp,
                                              Safra__c = '21/22',
                                              marca__c = 'BRMX',
                                              StageName = 'Aprobada',
                                              CloseDate = testOppCloseDate,
                                              Tipo_de_Cultivares__c = 'Comerciais',
                                              CampaignId = testCampaign.Id,
                                              Preco_unitario_sugerido__c = 1,
                                              Preco_Total_Sugerido_Sem_Juros__c = 5,
                                              Kg_de_produto__c = 5,
                                              Novo_primeiro_vencimento__c = testOppNovoPrimeiroVencimento,
                                              Taxa_de_primeiro_pagamento__c = 50,
                                              Total_do_primeiro_pagamento__c = 250,
                                              Novo_segundo_vencimento__c = testOppNovoSegundoVencimento,
                                              Taxa_de_segundo_pagamento__c = 50,
                                              Total_do_segundo_pagamento__c = 250);
        insert testOpp;

        Quote testQuote = new Quote (Name = 'testQuote',
                                     ExpirationDate = testQuoteExpirationDate,
                                     Vis_vel_para_multiplicador__c = true,
                                     OpportunityId = testOpp.Id,
                                     status = 'Aprovado',
                                     Condi_o_de_pagamento__c = 'test',
                                     Preco_unitario_sugerido__c = 1,
                                     Preco_Total_Sugerido_Sem_Juros__c = 5,
                                     Kg_de_produto__c = 5,
                                     Juros_Desconto__c = 0.52,
                                     Total__c = 500,
                                     Novo_primeiro_vencimento__c = testQuoteNovoPrimeiroVencimento,
                                     Taxa_de_primeiro_pagamento__c = 50,
                                     Total_do_primeiro_pagamento__c = 250,
                                     Novo_segundo_vencimento__c = testQuoteNovoSegundoVencimento,
                                     Taxa_de_segundo_pagamento__c = 50,
                                     Total_do_segundo_pagamento__c = 250);
 
        insert testQuote;

        OpportunityLineItem testOppLineItem = new OpportunityLineItem (OpportunityId = testOpp.Id,
                                                   					   Product2Id = testProduct.Id,
                                                                       UnitPrice = 100,
                                                                       Tipo_de_necessidade__c = 'MULTIPLICAÇÃO',
                                                                       Quantity = 5);
        insert testOppLineItem;
    }

    @isTest
    public static void getProductsVBTestPositive() {

        String accountId = [SELECT Id 
                            FROM Account 
                            WHERE Name = 'TestAccount' 
                            LIMIT 1].Id;

        ProductsVBAPI.ProductsVBAPIResponse result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsVBAPI/';  
        req.addParameter('accountId', accountId);
        req.addParameter('marca', TESTMARCA);
        req.addParameter('safra', TESTSAFRA);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsVBAPI.ListarPedidos();
        test.stopTest();

        result = (ProductsVBAPI.ProductsVBAPIResponse)JSON.deserialize(resp.responseBody.toString(), ProductsVBAPI.ProductsVBAPIResponse.class);
        System.debug('result: ' + result);
        
        System.assert(result.status);
    }

    @isTest
    public static void getProductsVBTestNegative() {

        String accountId = [SELECT Id 
                            FROM Account 
                            WHERE Name = 'TestAccount' 
                            LIMIT 1].Id;

        ProductsVBAPI.ProductsVBAPIResponse result;

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ProductsVBAPI/';  
        req.addParameter('accountId', accountId);
        req.addParameter('marca', TESTMARCA);
        req.addParameter('safra', TESTWRONGSAFRA);
        req.httpMethod = 'GET';

        RestResponse resp = new RestResponse();
        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ProductsVBAPI.ListarPedidos();
        test.stopTest();

        result = (ProductsVBAPI.ProductsVBAPIResponse)JSON.deserialize(resp.responseBody.toString(), ProductsVBAPI.ProductsVBAPIResponse.class);
        System.debug('result: ' + result);
        
        System.assertEquals(false, result.status);
        System.assertEquals(Label.ProductsVBAPI_Product_Not_Attached_Error_Message, result.message);
    }
}
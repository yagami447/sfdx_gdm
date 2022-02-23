@isTest
public class OpportunityTriggerXappiaHelperTest {
    @TestSetup
    static void setup(){
        SiteUser__c site = new SiteUser__c();
        site.Email__c = 'lucas.rios@xappia.com';
        site.Active__c = true;
        site.Password__c = '1234';
        insert site;
        Regiao__c region = Build.aRegiao()
                            .withRegionComercial('Region Test')
                            .build();
        insert region;
    
        Campaign campanha = new Campaign();
            campanha.Marca__c = 'BRMX';
            campanha.Safra__c = '20/21';
            campanha.Region__c = region.Id;
            campanha.Epoca_de_Producao__c = 'Verão';
            campanha.Region_VB__c = 'REGION 1';
            campanha.Name = 'Test';
            campanha.StartDate = System.today().addDays(-10);
            campanha.EndDate = System.today().addDays(10);
            campanha.RecordTypeId = XappiaHelper.getRecordType('Campaign','Venda_de_Basica').Id;
            insert campanha;
        
        Account accountOfOpportunity = Build.anAccount()
                                    .withRegion(region)
                                    .build();
        insert accountOfOpportunity;
       
    }
    @isTest
    public static void method1(){
        Account accountOfOpportunity = [
                    SELECT id
                    FROM Account
                    LIMIT 1
        ];
        Campaign Campanha = [
                    SELECT id 
                    FROM campaign
                    LIMIT 1
        ];
        Opportunity opportunityToInsert = Build.anOpportunityVENTADEBASICA()
                    .withCloseDate(System.today().addDays(4))
                    .withMarca('BRMX')
                    .withSafra('20/21')
                    .withPricebook2Id(Test.getStandardPricebookId())
                    .withAccountId(accountOfOpportunity)
                    .withRecordTypeId(XappiaHelper.getRecordType('Opportunity','Venda_da_Basica_full'))
                    .build();
                    // opportunityToInsert.Usuario__c = site.id;
                    opportunityToInsert.CampaignId = campanha.Id;
        insert opportunityToInsert;

        opportunityToInsert.stageName = 'Revisão do administrador de vendas';
        Quote quoteToSince = [
                    SELECT id, opportunityid, status, IsSyncing 
                    FROM quote  
                    WHERE opportunityId = :opportunityToInsert.Id
        ];
        opportunityToInsert.SyncedQuoteId = quoteToSince.id;
        update(opportunityToInsert);

        Opportunity opportunityInserted = [
            SELECT Id, SyncedQuoteId
            FROM   Opportunity
            WHERE Id = :opportunityToInsert.Id
            LIMIT 1
        ];

        Set<Id> OpportunitiesIds = new Set<Id>();
        OpportunitiesIds.add(opportunityInserted.id);

        test.startTest();
        OpportunityTriggerXappiaHelper.cloneQuote(null, OpportunitiesIds);
        test.stopTest();

        List<Quote> quotesCreated = [
                    SELECT id, opportunityid, status, IsSyncing 
                    FROM quote 
                    WHERE opportunityId = :opportunityToInsert.Id
        ];
        SYSTEM.assertEquals(2, quotesCreated.size());
    }
    @isTest
    public static void method2(){
        Account accountOfOpportunity = [
                    SELECT id
                    FROM Account
                    LIMIT 1
        ];
        Campaign Campanha = [
                    SELECT id 
                    FROM campaign
                    LIMIT 1
                    ];
                    Opportunity opportunityToInsert = Build.anOpportunityVENTADEBASICA()
                    .withCloseDate(System.today().addDays(4))
                    .withMarca('BRMX')
                    .withSafra('20/21')
                    .withPricebook2Id(Test.getStandardPricebookId())
                    .withAccountId(accountOfOpportunity)
                    .withRecordTypeId(XappiaHelper.getRecordType('Opportunity','Venda_da_Basica_full'))
                    .build();
                    // opportunityToInsert.Usuario__c = site.id;
                    opportunityToInsert.stageName = 'Revisão do administrador de vendas';
                    opportunityToInsert.CampaignId = campanha.Id;
                    insert opportunityToInsert;
                    
        Product2 prod = new Product2(Name='Producto',Sociedad__c='BRMX',Variedad__c='BMX POTÊNCIA RR', isActive = true); insert prod;
        Pricebook2 pb = new Pricebook2(Name='local', isActive = true); insert pb;
        PricebookEntry pbe_st = new PricebookEntry(Product2Id = prod.Id, UnitPrice = 2, Pricebook2Id = Test.getStandardPricebookId(), isActive = true); insert pbe_st;
                    
        Quote quoteToSince = [
            SELECT id, opportunityid, status, IsSyncing,
            (
                SELECT Id, Product2.Name, Product2.Description, Product2.UNIDADE__c,Product2.Categoria__c,
                TotalPrice, Quantity, Tipo_de_necessidade__c, UnitPrice 
                FROM QuoteLineItems
            )
            FROM quote  
            WHERE opportunityId = :opportunityToInsert.Id
        ];
        OpportunityLineItem item = new OpportunityLineItem (
            Quantity = 10,
            TotalPrice = 10,
            PricebookEntryId = pbe_st.ID,
            // Estado_Facturacion__c = 'Facturado',
            OpportunityId = opportunityToInsert.Id,
            Tipo_de_Necessidade__c = 'Multiplicação'
        );
        insert item;
        opportunityToInsert.SyncedQuoteId = quoteToSince.id;
        update(opportunityToInsert);

        Opportunity opportunityInserted = [
            SELECT Id, SyncedQuoteId
            FROM   Opportunity
            WHERE Id = :opportunityToInsert.Id
            LIMIT 1
        ];

        Set<Id> OpportunitiesIds = new Set<Id>();
        OpportunitiesIds.add(opportunityInserted.id);
        OpportunityTriggerXappiaHelper.cloneQuote(null, OpportunitiesIds);
        List<Quote> quotesCreated = [
                    SELECT id, opportunityid, status, IsSyncing,
                    (
                        SELECT Id, Product2.Name, Product2.Description, Product2.UNIDADE__c,Product2.Categoria__c,
                        TotalPrice, Quantity, Tipo_de_necessidade__c, UnitPrice 
                        FROM QuoteLineItems
                    )
                    FROM quote 
                    WHERE opportunityId = :opportunityToInsert.Id
        ];
        List<QuoteLineItem> qli = new List<QuoteLineItem>();
        test.startTest();
        qli = OpportunityTriggerXappiaHelper.relacionarProductosALNuevoPresupuesto(quoteToSince, quotesCreated[1]);
        test.stopTest();
       
        list<quotelineitem> qliToControl = [select id from quotelineitem where quoteid = :quotesCreated[0].id];
        system.debug('qliToControl ' + qliToControl);

        System.assertEquals(2, quotesCreated.size());
        // System.assertEquals(qli[0].QuoteId, quotesCreated[0].id, 'El id del Quote no coincide');
    }

    @isTest
    public static void testCheckNewStock(){

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactory.createBusiness(accountsList);
        List<Variedad__c> varietyList = TestDataFactory.createVariety(1);
        List<Configuracion_BMX__c> configuracionList = TestDataFactory.createConfiguracion(1);
        List<Opportunity> opportunitiesList = TestDataFactory.createOpportunitiesTrigger(accountsList, 1);

        Test.startTest();
        Boolean resultado = OpportunityTriggerXappiaHelper.checkNewStock(opportunitiesList);
        Test.stopTest();

    }

    @isTest
    public static void testWhenOppIsAnulada(){

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactory.createBusiness(accountsList);
        List<Opportunity> opportunitiesList = TestDataFactory.createOpportunitiesTrigger(accountsList, 1);

        opportunitiesList[0].StageName = 'Anulada';

        List<Opportunity> opportunities = [SELECT Id, Name, AccountId, Activa__c
                                                FROM Opportunity 
                                                    WHERE Id =: opportunitiesList[0].Id];

        Map<Id, Opportunity> oppor = new Map<Id, Opportunity>();

        for(Opportunity opp : opportunities) {
            oppor.put(opp.Id, opp);
        }

        Test.startTest();
        OpportunityTriggerXappiaHelper.whenOppIsAnulada_LockRecord(opportunitiesList, oppor);
        Test.stopTest();

    }

    @isTest
    public static void testCampaignVendaBasica(){

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactory.createBusiness(accountsList);
        List<Campaign> campaignList = TestDataFactory.createCampaign(accountsList, 1);
        List<Opportunity> opportunitiesList = TestDataFactory.createOpportunitiesWithBusinesss(campaignList, businessList, accountsList, 1);
    
        Test.startTest();
        OpportunityTriggerXappiaHelper.setCampaignVendaBasica(opportunitiesList);
        Test.stopTest();        

    }

    @isTest
    public static void testValidarEstoque(){

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Negocio_por_Conta__c> businessList = TestDataFactory.createBusiness(accountsList);
        List<Variedad__c> varietyList = TestDataFactory.createVariety(1);
        List<Configuracion_BMX__c> configuracionList = TestDataFactory.createConfiguracion(1);
        List<Opportunity> opportunitiesList = TestDataFactory.createOpportunitiesTrigger(accountsList, 1);

        System.debug('### Name RecordType ###' + opportunitiesList[0].RecordType.Name);

        Test.startTest();
        OpportunityTriggerXappiaHelper.validarEstoque(opportunitiesList);
        Test.stopTest();

    }

    @isTest
    public static void testDesactivateOldStock(){

        List<Regiao__c> regionsList = TestDataFactory.createRegions(1);
        List<Account> accountsList = TestDataFactory.createAccounts(regionsList);
        List<Opportunity> opportunitiesList = TestDataFactory.createOpportunitiesTrigger(accountsList, 1);

        opportunitiesList[0].Activa__c = false;

        List<Opportunity> opportunities = [SELECT Id, Name, AccountId, Activa__c
                                                FROM Opportunity 
                                                    WHERE Id =: opportunitiesList[0].Id];

        Map<Id, Opportunity> oppor = new Map<Id, Opportunity>();

        for(Opportunity opp : opportunities) {
            oppor.put(opp.Id, opp);
        }

        System.debug('### activas ###' + opportunitiesList[0].Activa__c);

        Test.startTest();
        OpportunityTriggerXappiaHelper.desactivateOldStock_ActivateNewStock(opportunitiesList, oppor);
        Test.stopTest();

    }
}
@IsTest
public class OpportunityTriggerXappiaTest {
    static Pricebook2 pricebookOne;
    static Id pricebookIdOne;

    
    @TestSetup
    static void makeData() {
        Configuracion_BMX__c conf = new Configuracion_BMX__c(PM_Safra_Actual__c = '20/21');
        insert conf;
		pricebookIdOne = Test.getStandardPricebookId();

        SiteUser__c site = new SiteUser__c();
        site.Email__c = 'lucas.rios@xappia.com';
        site.Active__c = true;
        site.Password__c = '1234';
        insert site;
        
		Regiao__c region = Build.aRegiao().withRegionComercial('Region Test').build();
		insert region;

        Account accountOfOpportunity = Build.anAccount()
		.withRegion(region)
        .build();
        insert accountOfOpportunity;

		

		Campaign campanha = new Campaign();
		campanha.Marca__c = 'BRMX';
		campanha.Safra__c = '20/21';
        //campanha.Region__c = region.Id;
        campanha.Epoca_de_Producao__c = 'Verão';
        campanha.Region_VB__c = 'REGION 1';
		campanha.Name = 'Test';
		campanha.StartDate = System.today().addDays(-10);
		campanha.EndDate = System.today().addDays(10);
		campanha.RecordTypeId = XappiaHelper.getRecordType('Campaign','Venda_de_Basica').Id;
        campanha.Status = 'Aprovado';
		insert campanha;

        Opportunity opportunityToInsert = Build.anOpportunityVENTADEBASICA()
			.withCloseDate(System.today().addDays(4))
			.withMarca('BRMX')
			.withSafra('20/21')
			.withPricebook2Id(Test.getStandardPricebookId())
            .withAccountId(accountOfOpportunity)
            //.withRecordTypeId(XappiaHelper.getRecordType('Opportunity','Venda_da_Basica_full'))
        .build();
        opportunityToInsert.Usuario__c = site.id;
        opportunityToInsert.CampaignId = campanha.Id;
        insert opportunityToInsert;
        
        Product2 producto = Build.aProduct2().build();
        producto.IsActive=true;
        insert producto;
        
        pricebookOne = new Pricebook2(
            Id = pricebookIdOne,
            Regi_o__c = region.Id,
            Para_venda_de_b_sica_inicial__c = true
        );
        update pricebookOne;
        
        
        PricebookEntry PricebookE = new PricebookEntry();
        PricebookE.Product2Id=producto.id;
        PricebookE.Pricebook2Id=pricebookOne.id;
        PricebookE.UnitPrice=10;
        PricebookE.IsActive = true;
        insert PricebookE;
        
        QuoteLineSyncField__c quoteLineSync = new QuoteLineSyncField__c(
        	Name = 'Tipo_de_Necessidade__c',
            OppLineSyncField__c = 'Tipo_de_Necessidade__c'
        );
        insert quoteLineSync;
        
        
    }
    
    
    @IsTest
    static void whenInsertAnOpportuntiyOfVendaDaBasicaFull_SyncTheQuoteGeneretedByProcessBuilder() {
        String safraActual = '20/21'; 
        Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
        Campaign campanha = new Campaign();
        campanha.Marca__c = 'BRMX';
        campanha.Safra__c = safraActual;
        campanha.Region__c = region.Id;
        campanha.Name = 'Campania Test';
        campanha.epoca_de_producao__c = 'Inverno';
        campanha.StartDate = System.today().addDays(-10);
        campanha.EndDate = System.today().addDays(10);
        campanha.Lista_de_precios__c = Test.getStandardPricebookId();
        campanha.RecordTypeId = XappiaHelper.getRecordType('Campaign','Venda_de_Basica').Id;
        campanha.Region_VB__c = 'REGION 1';
        campanha.Status = 'Aprovado';
        insert campanha;
        
        List<Regiao__c> regiones = [SELECT Id FROM Regiao__c];
        Account accountOfOpportunity = Build.anAccount().withRegion(regiones[0])
            .build();
        insert accountOfOpportunity;
        
        Opportunity opportunityToInsert = Build.anOpportunity()
            .withCloseDate(System.today().addDays(4))
            .withMarca('BRMX')
            .withSafra(safraActual)
            .withPricebook2Id(Test.getStandardPricebookId())
            .withAccountId(accountOfOpportunity)
            .withRecordTypeId(XappiaHelper.getRecordType('Opportunity','Venda_da_Basica_full'))
            .withCloseDate(System.today())
            .build();
        opportunityToInsert.CampaignId = campanha.Id;
        
        test.startTest();
        
        PricebookEntry PricebookEntryId = [SELECT Id,Pricebook2Id FROM PricebookEntry LIMIT 1];
        
        opportunityToInsert.pricebook2Id = PricebookEntryId.Pricebook2Id;
        insert opportunityToInsert;

        test.stopTest();
                
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opportunityToInsert.id,
            Quantity = 1,
            UnitPrice = 1,
            PricebookEntryId = PricebookEntryId.id, 
            Tipo_de_Necessidade__c = 'Multiplicação'
            
        );
        
        insert oli;
        
        oli.Tipo_de_Necessidade__c = 'Difusão';
        update oli;
            
        
        Opportunity opportunityInserted = [
            SELECT Id, SyncedQuoteId
            FROM   Opportunity
            WHERE Id = :opportunityToInsert.Id
            LIMIT 1
        ];

        System.assertNotEquals(null, opportunityInserted.SyncedQuoteId);
    }

 
    @IsTest
     static void whenUpdateAnOpportuntiyOfVendaDaBasicaFullAndTheStatusIsDiferentThanEdicion_DontChangeTheSyncQuote() {
        String safraActual = '20/21'; 
        Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
        Campaign campanha = new Campaign();
		campanha.Marca__c = 'BRMX';
		campanha.Safra__c = safraActual;
		campanha.Region__c = region.Id;
        campanha.Name = 'Campania Test';
        campanha.epoca_de_producao__c = 'Inverno';
		campanha.StartDate = System.today().addDays(-10);
        campanha.EndDate = System.today().addDays(10);
        campanha.Lista_de_precios__c = Test.getStandardPricebookId();
        campanha.RecordTypeId = XappiaHelper.getRecordType('Campaign','Venda_de_Basica').Id;
        campanha.Region_VB__c = 'REGION 1';
        campanha.Status = 'Aprovado';
        insert campanha;

        List<Regiao__c> regiones = [SELECT Id FROM Regiao__c];
        Account accountOfOpportunity = Build.anAccount().withRegion(regiones[0])
        .build();
        insert accountOfOpportunity;

         Opportunity opportunityToInsert = Build.anOpportunity()
			.withCloseDate(System.today().addDays(4))
			.withMarca('BRMX')
			.withSafra(safraActual)
			.withPricebook2Id(Test.getStandardPricebookId())
            .withAccountId(accountOfOpportunity)
            .withRecordTypeId(XappiaHelper.getRecordType('Opportunity','Venda_da_Basica_full'))
        .build();
        opportunityToInsert.CampaignId = campanha.Id;
		insert opportunityToInsert;                 

        Opportunity opportunityInserted = [
            SELECT Id, SyncedQuoteId
            FROM   Opportunity
            WHERE Id = :opportunityToInsert.Id
            LIMIT 1
        ];
         
        Quote presupuesto1 = New Quote(
            Name = 'Presupuesto1',
            OpportunityId = opportunityInserted.Id,
            Vis_vel_para_multiplicador__c = true,
            Status = 'Aprovado'          
            );  
        insert presupuesto1;
         
         System.debug('TEST LINE 119 '+ opportunityInserted.SyncedQuoteId);
          
        Quote aQuote = [
            SELECT Id 
            FROM Quote
            WHERE OpportunityId = :opportunityInserted.Id
            LIMIT 1
        ];

        test.startTest();
        opportunityInserted.StageName = 'Revisão do administrador de vendas';
        update opportunityInserted;
        test.stopTest();

        Opportunity opportunityUpdated = [
            SELECT Id, SyncedQuoteId
            FROM   Opportunity
            WHERE Id = :opportunityToInsert.Id
            LIMIT 1
        ];

        System.assertEquals(aQuote.Id, opportunityUpdated.SyncedQuoteId); 

    }
 
    @IsTest
     static void whenUpdateAnOpportuntiyOfVendaDaBasicaFullAndTheStatusIsDiferentThanEdicion_ChangeTheSyncQuote() {
        String safraActual = '20/21'; 
        Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
        Campaign campanha = new Campaign();
		campanha.Marca__c = 'BRMX';
		campanha.Safra__c = safraActual;
		campanha.Region__c = region.Id;
        campanha.Name = 'Campania Test';
        campanha.epoca_de_producao__c = 'Inverno';
		campanha.StartDate = System.today().addDays(-10);
        campanha.EndDate = System.today().addDays(10);
        campanha.Lista_de_precios__c = Test.getStandardPricebookId();
        campanha.RecordTypeId = XappiaHelper.getRecordType('Campaign','Venda_de_Basica').Id;
        campanha.Region_VB__c = 'REGION 1';
        
        insert campanha;

        List<Regiao__c> regiones = [SELECT Id FROM Regiao__c];
        Account accountOfOpportunity = Build.anAccount().withRegion(regiones[0])
        .build();
        insert accountOfOpportunity;
        
        Opportunity opportunityToInsert = Build.anOpportunity()
			.withCloseDate(System.today().addDays(4))
			.withMarca('BRMX')
			.withSafra(safraActual)
			.withPricebook2Id(Test.getStandardPricebookId())
            .withAccountId(accountOfOpportunity)
            .withRecordTypeId(XappiaHelper.getRecordType('Opportunity','Venda_da_Basica_full'))
        .build();
        opportunityToInsert.CampaignId = campanha.Id;
        insert opportunityToInsert;
         
         Quote presupuesto1 = New Quote(
            Name = 'Presupuesto1',
            OpportunityId = opportunityToInsert.Id,
            Vis_vel_para_multiplicador__c = true,
            Status = 'Aprovado'          
            );  
        insert presupuesto1;

        
        opportunityToInsert.stageName = 'Revisão do administrador de vendas';
        Quote quoteToSince = [
            SELECT id, opportunityid, status, IsSyncing
            FROM Quote
            WHERE OpportunityId = : opportunityToInsert.Id
            LIMIT 1
            ];
        opportunityToInsert.SyncedQuoteId = quoteToSince.id;
        update(opportunityToInsert);
        
        Opportunity opportunityInserted = [
            SELECT Id, SyncedQuoteId
            FROM   Opportunity
            WHERE Id = :opportunityToInsert.Id
            LIMIT 1
        ];
        system.debug('Debug desde OppTrieggerXappiaTest OppInserted: ' + opportunityInserted);
        system.debug('Debug desde OppTrieggerXappiaTest : Aquote' + quoteToSince);
        
        test.startTest();
        opportunityInserted.StageName = 'Revisão do administrador de vendas';
        update opportunityInserted;
        opportunityInserted.StageName = 'Edición';
        update opportunityInserted;
        test.stopTest();

        Opportunity opportunityUpdated = [
            SELECT Id, SyncedQuoteId
            FROM   Opportunity
            WHERE Id = :opportunityInserted.Id
            LIMIT 1
        ];

        Quote newQuote = [
            SELECT Id 
            FROM Quote
            WHERE Id != :quoteToSince.Id
            LIMIT 1
        ];

        System.assertNotEquals(quoteToSince.Id, opportunityUpdated.SyncedQuoteId);
        System.assertNotEquals(newQuote.Id, opportunityUpdated.SyncedQuoteId);

    }
    
            
    @isTest
    public static void whenCreateAnOppVendaDeBasicaFull_ifExistACampaignWithSameData_mustRelatedThem_and_priceList(){
        Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
		insert region;
        
        Account accountOfOpportunity = Build.anAccount()
		.withRegion(region)
        .build();
        insert accountOfOpportunity;

        Campaign campanha = new Campaign();
        campanha.Conta__c = accountOfOpportunity.Id;
		campanha.Marca__c = 'BRMX';
		campanha.Safra__c = '20/21';
		campanha.Region__c = region.Id;
        campanha.Name = 'Test';
        campanha.epoca_de_producao__c = 'Verão';
		campanha.StartDate = System.today().addDays(-10);
        campanha.EndDate = System.today().addDays(10);
        campanha.Lista_de_precios__c = Test.getStandardPricebookId();
        campanha.RecordTypeId = XappiaHelper.getRecordType('Campaign','Venda_de_Basica').Id;
        campanha.Region_VB__c = 'REGION 1';
        campanha.Status = 'Aprovado';
        insert campanha;
        System.debug(campanha);
        
        Opportunity opportunityToInsert = Build.anOpportunityVendaDaBasicaCompleta()
			.withCloseDate(System.today().addDays(4))
			.withMarca('BRMX')
            .withSafra('20/21')
            .withAccountId(accountOfOpportunity)
            .withRecordTypeId(XappiaHelper.getRecordType('Opportunity','Venda_da_Basica_full'))
            .build();
            opportunityToInsert.Tipo_de_Cultivares__c = 'Comerciais';
            opportunityToInsert.Regiao__c = region.id;
            opportunityToInsert.StageName = 'Edición';
            opportunityToInsert.CampaignId = campanha.Id;
        
        Test.startTest();
        insert opportunityToInsert;
        Test.stopTest();
        system.debug('JP:' + opportunityToInsert);

        Campaign camp = [SELECT id, Lista_de_precios__c
                        FROM Campaign
                        LIMIT 1];
        Opportunity opp = [SELECT Id, Pricebook2Id, CampaignId
                           FROM Opportunity
                           WHERE campaignID = :camp.id
                           LIMIT 1];
        
        System.assertEquals(camp.id, opp.CampaignId, 'La campaña no se ha relacionado a la oportunidad');
    }

    

    // @IsTest
    //  static void whenUpdateAnOpportuntiyOfVendaDaBasicaFullAndTheStatusIsDiferentThanEdicion_CloneTheQuoteLineItems() {           
    
        // String safraActual = '20/21'; 
        // Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
        // Campaign campanha = new Campaign();
		// campanha.Marca__c = 'BRMX';
		// campanha.Safra__c = safraActual;
		// campanha.Region__c = region.Id;
        // campanha.Name = 'Campania Test';
        // campanha.epoca_de_producao__c = 'Inverno';
		// campanha.StartDate = System.today().addDays(-10);
        // campanha.EndDate = System.today().addDays(10);
        // campanha.Lista_de_precios__c = Test.getStandardPricebookId();
        // campanha.RecordTypeId = XappiaHelper.getRecordType('Campaign','Venda_de_Basica').Id;
        // campanha.Region_VB__c = 'REGION 1';
        // insert campanha;

        // List<Regiao__c> regiones = [SELECT Id FROM Regiao__c];
        // Account accountOfOpportunity = Build.anAccount().withRegion(regiones[0])
        // .build();
        // insert accountOfOpportunity;
        
        // Opportunity opportunityToInsert = Build.anOpportunity()
		// 	.withCloseDate(System.today().addDays(4))
		// 	.withMarca('BRMX')
		// 	.withSafra(safraActual)
		// 	.withPricebook2Id(Test.getStandardPricebookId())
        //     .withAccountId(accountOfOpportunity)
        //     .withRecordTypeId(XappiaHelper.getRecordType('Opportunity','Venda_da_Basica_full'))
        // .build();
        // opportunityToInsert.CampaignId = campanha.Id;
        // insert opportunityToInsert;

        
        // opportunityToInsert.stageName = 'Revisão do administrador de vendas';
        // Quote quoteToSince = [
        //     SELECT id, opportunityid, status, IsSyncing
        //     FROM Quote
        //     WHERE OpportunityId = : opportunityToInsert.Id
        //     ];
        // opportunityToInsert.SyncedQuoteId = quoteToSince.id;
        
        // update(opportunityToInsert);
        
        // Opportunity opportunityInserted = [
        //     SELECT Id, SyncedQuoteId
        //     FROM   Opportunity
        //     WHERE Id = :opportunityToInsert.Id
        //     LIMIT 1
        // ];

        // Product2 producto = [
        //             SELECT Id
        //             FROM Product2
        //             limit 1
        // ];

        // PriceBook2 pricebookOne = [
        //             SELECT Id 
        //             FROM Pricebook2
        //             LIMIT 1
        // ];

        // PricebookEntry PricebookE = [
        //             SELECT id 
        //             FROM PricebookEntry
        //             LIMIT 1
        // ];

        // QuoteLineItem aQuoteLineItem = Build.aQuoteLineItem()
        //     .withPricebookEntry(PricebookE)
        //     .withProduct2(producto)
        //     .withUnitPrice(58)
        //     .withQuote(quoteToSince)
        //     .withQuantity(10)
        // .build();
        // // aQuoteLineItem.Tipo_de_Necessidade__c = 'MULTIPLICAÇÃO';	
        // insert aQuoteLineItem;
        
        // test.startTest();
        // opportunityInserted.StageName = 'Revisão do administrador de vendas';
        // update opportunityInserted;              
        // opportunityInserted.StageName = 'Edición';
        // update opportunityInserted;
        // test.stopTest();

        // Opportunity opportunityUpdated = [
        //     SELECT Id, SyncedQuoteId
        //     FROM   Opportunity
        //     WHERE Id = :opportunityInserted.Id
        //     LIMIT 1
        // ];

        // Quote newQuote = [
        //     SELECT Id 
        //     FROM Quote
        //     WHERE Id != :quoteToSince.Id
        // ];
        // SYstem.debug('Debug desde OpportunityTriggerXappiaTest Quotes ' +
        //     [SELECT Id FROM Quote]);

        // List<QuoteLineItem> quotesLineItemsOfNewQuote = [
        //     SELECT Id, UnitPrice, Quantity, Product2Id
        //     FROM QuoteLineItem
        //     WHERE QuoteId = :newQuote.Id
        // ];

        // System.assertEquals(1, quotesLineItemsOfNewQuote.size());
        // System.assertEquals(58, quotesLineItemsOfNewQuote[0].UnitPrice);
        // System.assertEquals(10, quotesLineItemsOfNewQuote[0].Quantity);
        // System.assertEquals(producto.Id, quotesLineItemsOfNewQuote[0].Product2Id);

    // }

    // @IsTest
    //  static void whenUpdateAnOpportuntiyOfVendaDaBasicaFullAndTheStatusIsDiferentThanEdicion_CheckTheAmmountOfRecordsCreated() {
           

    //     Opportunity opportunityInserted = [
    //         SELECT Id, SyncedQuoteId
    //         FROM  Opportunity
    //         LIMIT 1
    //     ];

    //     Quote aQuote = [
    //         SELECT Id 
    //         FROM Quote
    //         WHERE OpportunityId = : opportunityInserted.Id
    //         LIMIT 1
    //     ];

    //     QuoteLineItem aQuoteLineItem = Build.aQuoteLineItem()
    //         .withPricebookEntry(aPricebookEntry)
    //         .withProduct2(aProduct)
    //         .withUnitPrice(58)
    //         .withQuote(aQuote)
    //         .withQuantity(10)
    //     .build();
    //     insert aQuoteLineItem;

    //     opportunityInserted.StageName = 'Revisão do administrador de vendas';
    //     update opportunityInserted;              

    //     test.startTest();
    //     opportunityInserted.StageName = 'Edición';
    //     update opportunityInserted;
    //     test.stopTest();

    //     List<Quote> quotes = [
    //         SELECT Id 
    //         FROM Quote
    //     ];

    //     List<QuoteLineItem> quotesLineItems = [
    //         SELECT Id
    //         FROM QuoteLineItem
    //     ];

    //     System.assertEquals(2,quotes.size());
    //     System.assertEquals(2,quotesLineItems.size());


    // }

    

    // static Product2 aProduct;
    // static PricebookEntry aPricebookEntry;   

    // Static{

    //     aProduct = Build.aProduct2()
    //         .withName('Test product2')
    //         .withCategoria('BASICA')
    //         .withFamily('Royalty x Basica')
    //         .withPrice(40)
    //         .withIsActive(true)
    //     .build();
    //     insert aProduct;

    //     aPricebookEntry = Build.aPricebookEntry()
    //         .withPricebook2Id(Test.getStandardPricebookId())
    //         .withUnitPrice(58)
    //         .withProduct2Id(aProduct)
    //         .withIsActive(true)
    //     .build();
    //     insert aPricebookEntry;

    // }


}
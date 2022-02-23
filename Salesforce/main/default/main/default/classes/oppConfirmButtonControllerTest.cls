@isTest
private class oppConfirmButtonControllerTest {

    static {
        Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
		insert region;

        Account account = Build.anAccount()
            .withRegion(region)
            .withType('Multiplicador')
			.withMarca('BRMX')
            .build();
        
        insert account;

        Pricebook2[] pricebooks = new Pricebook2[2];

        pricebooks[0] = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );

        pricebooks[1] = new Pricebook2(
            IsActive = true,
            Name = 'Lista de Básica BMX SUL',
            Description = 'Lista de Precios para Venta de Semilla'
        );

        upsert pricebooks;

        Campaign campaign = new Campaign(
            Name = 'Campaña VB - 20/21 - BRMX -',
            Marca__c = 'BRMX',
            Safra__c = '20/21',
            Region__c = region.Id,
            epoca_de_producao__c = 'Verão',
            StartDate = System.today().addDays(-10),
            EndDate = System.today().addDays(10),
            Lista_de_precios__c = pricebooks[1].Id, // la campaña posee el Pricebook "Lista de Básica BMX SUL"
            RecordTypeId = XappiaHelper.getRecordType('Campaign','Venda_de_Basica').Id,
            Region_VB__c = 'REGION 1;CERRADO'
        );

        insert campaign;

        Opportunity opportunity = Build.anOpportunityVendaDaBasicaCompleta()
            .withStageName('Revisão do administrador de vendas')
            .withAccountId(account)
            .withCampaignId(campaign)
            .withRegion('REGION 1')
            .withTipoDeCultivares('Comerciais')
            .withTipoDeNecessidade('Multiplicação')
            .withPricebook2Id(pricebooks[1]) // la VB Completa posee el Pricebook "Lista de Básica BMX SUL"
            .build();

        insert opportunity;
        
        Variedad__c[] variedades = new Variedad__c[6];

        variedades[0] = Build.aVariedad()
            .withName('BMX DESAFIO RR')
            .withNombredeRegistro('8473 RSF')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        variedades[1] = Build.aVariedad()
            .withName('54I52RSF IPRO')
            .withNombredeRegistro('54I52RSF IPRO')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        variedades[2] = Build.aVariedad()
            .withName('BRASMAX ZEUS IPRO')
            .withNombredeRegistro('55I57RSF IPRO')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        variedades[3] = Build.aVariedad()
            .withName('BMX POTÊNCIA RR')
            .withNombredeRegistro('BMX POTÊNCIA RR')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        variedades[4] = Build.aVariedad()
            .withName('BMX FORÇA RR')
            .withNombredeRegistro('BMX FORÇA RR')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        variedades[5] = Build.aVariedad()
            .withName('5958RSF IPRO')
            .withNombredeRegistro('5958RSF IPRO')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        insert variedades;

        Categoria__c[] categorias = new Categoria__c[5];

        categorias[0] = Build.aCategoria().withName('BASICA').build();
        categorias[1] = Build.aCategoria().withName('GENETICA').build();
        categorias[2] = Build.aCategoria().withName('FUNDADORA').build();
        categorias[3] = Build.aCategoria().withName('S1').build();
        categorias[4] = Build.aCategoria().withName('BREEDER').build();

        insert categorias;

        Product2[] productos = new Product2[10];

        productos[0] = Build.aProduct2()
            .withName('BMX DESAFIO RR - Basica  (G)')
            .withIsActive(true)
            .withFamily('Semilla')
            .withVariedad('BMX DESAFIO RR')
            .withVariedade(variedades[0])
            .withCategoria('BASICA')
            .withCateg(categorias[0])
            .withPrice(Double.valueOf(0.25)) // precio de venta por kg de producto
            .withSociedad('BRMX')
            .withUnidad('KG')
            .withCantSubUnidad('1') // cantidad de kg de producto por bolsa
            .build();

        productos[1] = Build.aProduct2()
            .withName('SEM SOJA 6968 RSF BASIC BENE')
            .withIsActive(true)
            .withFamily('Semilla')
            .withVariedad('54I52RSF IPRO')
            .withVariedade(variedades[1])
            .withCategoria('S1')
            .withCateg(categorias[3])
            .withPrice(Double.valueOf(7.61))
            .withSociedad('BRMX')
            .withUnidad('40 kG')
            .withCantSubUnidad('40')
            .build();
        
        productos[2] = Build.aProduct2()
            .withName('SEM SOJA BRASMAX ZEUS IPRO BASICA BENE')
            .withIsActive(true)
            .withFamily('Semilla')
            .withVariedad('BRASMAX ZEUS IPRO')
            .withVariedade(variedades[2])
            .withCategoria('BASICA')
            .withCateg(categorias[0])
            .withPrice(Double.valueOf(5.8))
            .withSociedad('BRMX')
            .withUnidad('KG')
            .withCantSubUnidad('1')
            .build();

        productos[3] = Build.aProduct2()
            .withName('SEM SOJA BMX POTÊNCIA RR BASIC BENE')
            .withIsActive(true)
            .withFamily('Semilla')
            .withVariedad('BMX POTÊNCIA RR')
            .withVariedade(variedades[3])
            .withCategoria('BASICA')
            .withCateg(categorias[0])
            .withPrice(Double.valueOf(7.61))
            .withSociedad('BRMX')
            .withUnidad('KG')
            .withCantSubUnidad('1')
            .build();

        productos[4] = Build.aProduct2()
            .withName('SEM SOJA 6663 RSF FUNDA SC40KG')
            .withIsActive(true)
            .withFamily('Semilla')
            .withVariedad('BMX FORÇA RR')
            .withVariedade(variedades[4])
            .withCategoria('GENETICA')
            .withCateg(categorias[1])
            .withPrice(Double.valueOf(5.8))
            .withSociedad('BRMX')
            .withUnidad('SACA 40 KG')
            .withCantSubUnidad('40')
            .build();

        productos[5] = Build.aProduct2()
            .withName('SEM SOJA 5958RSF IPRO FUNDA SC40KG')
            .withIsActive(true)
            .withFamily('Semilla')
            .withVariedad('5958RSF IPRO')
            .withVariedade(variedades[5])
            .withCategoria('FUNDADORA')
            .withCateg(categorias[2])
            .withPrice(Double.valueOf(4.0))
            .withSociedad('DSEM')
            .withUnidad('SACA 40 KG')
            .withCantSubUnidad('40')
            .build();

        productos[6] = Build.aProduct2()
            .withName('SEM SOJA 5958RSF IPRO BREED SC40KG')
            .withIsActive(true)
            .withFamily('Semilla')
            .withVariedad('5958RSF IPRO')
            .withVariedade(variedades[5])
            .withCategoria('BREEDER')
            .withCateg(categorias[4])
            .withPrice(Double.valueOf(4.0))
            .withSociedad('DSEM')
            .withUnidad('SACA 40 KG')
            .withCantSubUnidad('40')
            .build();

        productos[7] = Build.aProduct2()
            .withName('SEM SOJA BRASMAX ZEUS IPRO BASICA SC40KG')
            .withIsActive(true)
            .withFamily('Semilla')
            .withVariedad('BRASMAX ZEUS IPRO')
            .withVariedade(variedades[2])
            .withCategoria('BASICA')
            .withCateg(categorias[0])
            .withPrice(Double.valueOf(5.8))
            .withSociedad('BRMX')
            .withUnidad('SACA 40 KG')
            .withCantSubUnidad('40')
            .build();

        productos[8] = Build.aProduct2()
            .withName('SEM SOJA BRASMAX ZEUS IPRO BASICA SC1000KG')
            .withIsActive(true)
            .withFamily('Semilla')
            .withVariedad('BRASMAX ZEUS IPRO')
            .withVariedade(variedades[2])
            .withCategoria('BASICA')
            .withCateg(categorias[0])
            .withPrice(Double.valueOf(125.0))
            .withSociedad('BRMX')
            .withUnidad('SACA 1000 KG')
            .withCantSubUnidad('1000')
            .build();

        productos[9] = Build.aProduct2()
            .withName('SEM SOJA 8473 RSF PREBA SC40KG TR')
            .withIsActive(true)
            .withFamily('Semilla')
            .withVariedad('BMX DESAFIO RR')
            .withVariedade(variedades[0])
            .withCategoria('BASICA')
            .withCateg(categorias[0])
            .withPrice(Double.valueOf(4.0)) // precio de venta por kg de producto
            .withSociedad('BRMX')
            .withUnidad('SACA 40 KG')
            .withCantSubUnidad('40') // cantidad de kg de producto por bolsa
            .build();

        insert productos;

        // Lista de precios estándar
        PricebookEntry[] standarPricebookEntries = new PricebookEntry[10];
        
        standarPricebookEntries[0] = Build.aPricebookEntry()
            .withProduct2Id(productos[0])
            .withPricebook2Id(pricebooks[0])
            .withUnitPrice(0.25)
            .withIsActive(true)
            .build();

        standarPricebookEntries[1] = Build.aPricebookEntry()
            .withProduct2Id(productos[1])
            .withPricebook2Id(pricebooks[0])
            .withUnitPrice(7.61)
            .withIsActive(true)
            .build();

        standarPricebookEntries[2] = Build.aPricebookEntry()
            .withProduct2Id(productos[2])
            .withPricebook2Id(pricebooks[0])
            .withUnitPrice(5.8)
            .withIsActive(true)
            .build();

        standarPricebookEntries[3] = Build.aPricebookEntry()
            .withProduct2Id(productos[3])
            .withPricebook2Id(pricebooks[0])
            .withUnitPrice(7.61)
            .withIsActive(true)
            .build();

        standarPricebookEntries[4] = Build.aPricebookEntry()
            .withProduct2Id(productos[4])
            .withPricebook2Id(pricebooks[0])
            .withUnitPrice(5.8)
            .withIsActive(true)
            .build();

        standarPricebookEntries[5] = Build.aPricebookEntry()
            .withProduct2Id(productos[5])
            .withPricebook2Id(pricebooks[0])
            .withUnitPrice(4.0)
            .withIsActive(true)
            .build();

        standarPricebookEntries[6] = Build.aPricebookEntry()
            .withProduct2Id(productos[6])
            .withPricebook2Id(pricebooks[0])
            .withUnitPrice(4.0)
            .withIsActive(true)
            .build();

        standarPricebookEntries[7] = Build.aPricebookEntry()
            .withProduct2Id(productos[7])
            .withPricebook2Id(pricebooks[0])
            .withUnitPrice(5.8)
            .withIsActive(true)
            .build();

        standarPricebookEntries[8] = Build.aPricebookEntry()
            .withProduct2Id(productos[8])
            .withPricebook2Id(pricebooks[0])
            .withUnitPrice(125.0)
            .withIsActive(true)
            .build();

        standarPricebookEntries[9] = Build.aPricebookEntry()
            .withProduct2Id(productos[9])
            .withPricebook2Id(pricebooks[0])
            .withUnitPrice(4.0)
            .withIsActive(true)
            .build();

        insert standarPricebookEntries;

        // Lista de Básica BMX SUL
        PricebookEntry[] basicaBMXSulEntries = new PricebookEntry[4];

        basicaBMXSulEntries[0] = Build.aPricebookEntry()
            .withProduct2Id(productos[0])
            .withPricebook2Id(pricebooks[1])
            .withUnitPrice(0.25)
            .withIsActive(true)
            .build();

        basicaBMXSulEntries[1] = Build.aPricebookEntry()
            .withProduct2Id(productos[1])
            .withPricebook2Id(pricebooks[1])
            .withUnitPrice(7.61)
            .withIsActive(true)
            .build();

        basicaBMXSulEntries[2] = Build.aPricebookEntry()
            .withProduct2Id(productos[2])
            .withPricebook2Id(pricebooks[1])
            .withUnitPrice(5.8)
            .withIsActive(true)
            .build();

        basicaBMXSulEntries[3] = Build.aPricebookEntry()
            .withProduct2Id(productos[3])
            .withPricebook2Id(pricebooks[1])
            .withUnitPrice(7.61)
            .withIsActive(true)
            .build();

        insert basicaBMXSulEntries;

        OpportunityLineItem[] oppLineItems = new OpportunityLineItem[4];

        oppLineItems[0] = Build.anOpportunityLineItem()
            .withOpportunityId(opportunity)
            .withPricebookEntryId(basicaBMXSulEntries[0])
            .withQuantity(1000) // cantidad de bolsas de producto
            .withUnitPrice(0.25) // precio de venta por kg de producto
            .withQuantConfirmada(0)
            .withQuantRechazada(0)
            .withEsPrevisao(false)
            .withTipoDeNecessidade('Multiplicação')
            .build();

        oppLineItems[1] = Build.anOpportunityLineItem()
            .withOpportunityId(opportunity)
            .withPricebookEntryId(basicaBMXSulEntries[1])
            .withQuantity(25000)
            .withUnitPrice(0.2)
            .withQuantConfirmada(0)
            .withQuantRechazada(0)
            .withEsPrevisao(false)
            .withTipoDeNecessidade('Multiplicação')
            .build();

        oppLineItems[2] = Build.anOpportunityLineItem()
            .withOpportunityId(opportunity)
            .withPricebookEntryId(basicaBMXSulEntries[2])
            .withQuantity(2000)
            .withUnitPrice(5.8)
            .withQuantConfirmada(500) // este producto posee 500 bolsas confirmadas
            .withQuantRechazada(100)
            .withEsPrevisao(false)
            .withTipoDeNecessidade('Multiplicação')
            .build();

        oppLineItems[3] = Build.anOpportunityLineItem()
            .withOpportunityId(opportunity)
            .withPricebookEntryId(basicaBMXSulEntries[3])
            .withQuantity(200) // este producto ya no posee cantidades pendientes
            .withUnitPrice(7.61)
            .withQuantConfirmada(200)
            .withQuantRechazada(20)
            .withEsPrevisao(false)
            .withTipoDeNecessidade('Multiplicação')
            .build();

        insert oppLineItems;
    }

    @isTest static void createCVBPendiente1() {
        String[] response = null;

        Opportunity CVBPendiente = null;

        Test.startTest();
        Opportunity VBCompleta = [SELECT Id, AccountId FROM Opportunity LIMIT 1];

        response = oppConfirmButtonController.sendConfirmationRequest(VBCompleta.Id, VBCompleta.AccountId);

        CVBPendiente = [
            SELECT Id, RecordType.Name, Pricebook2Id, (SELECT Id FROM OpportunityLineItems)
            FROM Opportunity
            WHERE Id = :response[2] LIMIT 1
        ];
        Test.stopTest();

        System.assertEquals('Se ha creado la Confirmação da Venda da Basica.', response[0], 'El response no coincide con un caso de éxito');
        System.assertEquals('ok', response[1], 'El response no coincide con un caso de éxito');
        System.assertEquals('CVB Pendiente', CVBPendiente.RecordType.Name, 'El tipo de registro creado debe ser CVB Pendiente');
        System.assertEquals(Test.getStandardPricebookId(), CVBPendiente.Pricebook2Id, 'La CVB Pendiente debe apuntar al Standar Pricebook');
        System.assertEquals(3, CVBPendiente.OpportunityLineItems.size(), 'Deben añadirse solo los productos con cantidades pendientes a la CVB Pendiente');
    }

    @isTest static void createCVBPendiente2() {
        String[] response = null;

        Opportunity CVBPendiente = null;

        Test.startTest();
        Opportunity VBCompleta = [SELECT Id, AccountId FROM Opportunity LIMIT 1];

        response = oppConfirmButtonController.sendConfirmationRequest(VBCompleta.Id, VBCompleta.AccountId);

        CVBPendiente = [ // el producto con variedad BRASMAX ZEUS IPRO posee 500 bolsas confirmadas
            SELECT Id, (
                SELECT Id, Quantity, Variedade_Prod__c, Categoria_Prod__c, UNIDADE__c
                FROM OpportunityLineItems
                WHERE Variedade_Prod__c = 'BRASMAX ZEUS IPRO'
            )
            FROM Opportunity
            WHERE Id = :response[2] LIMIT 1
        ];
        Test.stopTest();

        System.assertNotEquals(2000, CVBPendiente.OpportunityLineItems[0].Quantity, 'Las cantidades no deben coincidir');
        System.assertEquals(1500, CVBPendiente.OpportunityLineItems[0].Quantity, 'La cantidad pendiente de la CVB Completa no coincide con la cantidad disponible de la CVB Pendiente');
        System.assertEquals('BRASMAX ZEUS IPRO', CVBPendiente.OpportunityLineItems[0].Variedade_Prod__c, 'La variedad no coincide con el valor esperado');
        System.assertEquals('BASICA', CVBPendiente.OpportunityLineItems[0].Categoria_Prod__c, 'La categoría no coincide con el valor esperado');
        System.assertEquals('KG', CVBPendiente.OpportunityLineItems[0].UNIDADE__c, 'La unidad no coincide con el valor esperadoe');
    }
}
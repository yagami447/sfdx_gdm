@isTest
private class opportunityProductEntryTest {

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
            .withStageName('Na aprovação do multiplicador')
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

        OpportunityLineItem[] oppLineItems = new OpportunityLineItem[3];

        // VB Completa Opportunity Line Items
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
            .withQuantConfirmada(0)
            .withQuantRechazada(0)
            .withEsPrevisao(false)
            .withTipoDeNecessidade('Multiplicação')
            .build();

        insert oppLineItems;
    }

    @isTest static void editProductCVBPendiente() {
        Opportunity CVBPendiente = null;
        
        Test.StartTest();
        Opportunity VBCompleta = [SELECT Id, AccountId FROM Opportunity LIMIT 1];

        String[] response = oppConfirmButtonController.sendConfirmationRequest(VBCompleta.Id, VBCompleta.AccountId);

        CVBPendiente = [SELECT Id FROM Opportunity WHERE Id = :response[2] LIMIT 1];

        // load page
        Test.setCurrentPageReference(Page.opportunityProductEntry);
        ApexPages.currentPage().getParameters().put('Id', CVBPendiente.Id);
        
        // load extension
        opportunityProductEntryExtension controller = new opportunityProductEntryExtension(new ApexPages.StandardController(CVBPendiente));

        // test init
        System.assertEquals(3, controller.shoppingCartWrappersUpsert.size(), 'El carrito de compras debería tener 3 productos ya cargados provenientes de la VB Completa');
        
        for (opportunityProductEntryExtension.PbeWrapper wrapp : controller.shoppingCartWrappersUpsert) {
            System.assertNotEquals(null, wrapp.item, 'Los wrappers obtenidos de la CVB Pendiente deben poseer Opportunity Line Item asignado');
            System.assertEquals(null, wrapp.PBE, 'Los wrappers obtenidos de la CVB Pendiente no deben poseer Pricebook Entry asignado');
        }

        // edit product
        opportunityProductEntryExtension.PbeWrapper wrp = null;

        for (opportunityProductEntryExtension.PbeWrapper wrapp : controller.shoppingCartWrappersUpsert) {
            if (wrapp.Variedad == 'BRASMAX ZEUS IPRO') { wrp = wrapp; } // Variedad BRASMAX ZEUS IPRO, Categoria BASICA, Unidad KG, Quantity 2000.0
        }

        controller.toEdit = wrp.id;
        controller.quantityTemp = wrp.quantity;
        controller.editProduct();

        System.assert(controller.getDisabled(), 'Al editar productos deben deshabilitarse opciones');

        wrp.idUnidad = 'SACA 40 KG';
        controller.editarCatidadSubUnidad();

        wrp.Quantity = 55; // 2200 kg de producto
        controller.dummy();

        controller.toEdit = wrp.id;
        controller.accion = 'editando';
        controller.addShoppingCartWrappersUpsert();

        ApexPages.Message msg = ApexPages.getMessages()[1]; // debe contener mensaje de error por superar la cantidad de producto disponible

        System.assertEquals('No hay suficiente Stock de ese producto.', msg.getSummary(), 'No debe superar la cantidad de producto disponible');
        System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());

        wrp.Quantity = 40; // 1600 kg de producto
        controller.dummy();

        controller.toEdit = wrp.id;
        controller.accion = 'editando';
        controller.addShoppingCartWrappersUpsert();

        System.assertEquals(3, controller.shoppingCartWrappersUpsert.size(), 'Luego de editar el producto debe mantenerse la cantidad de productos');

        for (opportunityProductEntryExtension.PbeWrapper wrapp : controller.shoppingCartWrappersUpsert) {
            if (wrapp.Variedad == 'BRASMAX ZEUS IPRO') {
                System.assertEquals(40, wrapp.quantity, 'La cantidad de bolsas no coincide con la esperada');
                System.assertEquals(40, wrapp.cantSubUnidad, 'La cantidad de kg por bolsa no coincide con la esperada');
                System.assertEquals('SACA 40 KG', wrapp.idUnidad, 'La unidad de kg por bolsa no coincide con la esperada');
                System.assertNotEquals(null, wrapp.PBE, 'No posee un Pricebook Entry asignado luego de realizar un cambio de unidad');
            }
        }

        // add product
        OpportunityLineItem OLI = null;

        for (OpportunityLineItem producto : controller.VBCompleta.OpportunityLineItems) {
            if (producto.Variedade_Prod__c == 'BRASMAX ZEUS IPRO') { OLI = producto; }
        }

        controller.shoppingCartWrappers[0].idVariedad = OLI.Product2.Variedade__c;
        controller.cantidadDisponible();

        System.assertEquals(2000, controller.shoppingCartWrappers[0].cantidadKgDisponible, 'Debe actualizarse la cantidad de kg disponibles para la variedad');

        controller.shoppingCartWrappers[0].idCategoria = OLI.Product2.Categ__c;
        controller.shoppingCartWrappers[0].idUnidad = 'SACA 40 KG';
        controller.shoppingCartWrappers[0].Tipo_de_Necesidad = 'Multiplicação';
        controller.shoppingCartWrappers[0].quantity = 0;
        
        controller.accion = 'agregando';
        controller.addShoppingCartWrappersUpsert();

        msg = ApexPages.getMessages()[2];

        System.assertEquals('La cantidad de sacas no puede ser cero.', msg.getSummary(), 'No puede resetearse un producto a cero bolsas');
        System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());

        System.assertEquals('', controller.shoppingCartWrappers[0].idVariedad);
        System.assertEquals('', controller.shoppingCartWrappers[0].idCategoria);
        System.assertEquals('', controller.shoppingCartWrappers[0].idUnidad);
        System.assertEquals(0, controller.shoppingCartWrappers[0].quantity);
        System.assertEquals('---Ninguno---', controller.shoppingCartWrappers[0].Tipo_de_Necesidad);
        System.assertEquals(0, controller.shoppingCartWrappers[0].cantidadKgDisponible);

        controller.shoppingCartWrappers[0].idVariedad = OLI.Product2.Variedade__c;
        controller.cantidadDisponible();
        controller.shoppingCartWrappers[0].idCategoria = OLI.Product2.Categ__c;
        controller.shoppingCartWrappers[0].idUnidad = 'SACA 40 KG';
        controller.shoppingCartWrappers[0].Tipo_de_Necesidad = 'Multiplicação';
        controller.shoppingCartWrappers[0].quantity = 10;
        
        controller.accion = 'agregando';
        controller.addShoppingCartWrappersUpsert(); // se agregan 10 bolsas a la variedad de producto BRASMAX ZEUS IPRO, ahora debería de contener 50 bolsas de 40kg

        System.assertEquals(3, controller.shoppingCartWrappersUpsert.size(), 'Luego de sumar cantidades a un mismo producto debe mantenerse la cantidad de productos');

        for (opportunityProductEntryExtension.PbeWrapper wrapp : controller.shoppingCartWrappersUpsert) {
            if (wrapp.Variedad == 'BRASMAX ZEUS IPRO') { // Variedad BRASMAX ZEUS IPRO, Categoria BASICA, Unidad SACA 40 KG, Quantity 50.0
                System.assertEquals(50, wrapp.quantity, 'La cantidad de bolsas no coincide con la esperada');
                System.assertEquals(40, wrapp.cantSubUnidad, 'La cantidad de kg por bolsa no coincide con la esperada');
                System.assertEquals('SACA 40 KG', wrapp.idUnidad, 'La unidad de kg por bolsa no coincide con la esperada');
            }
        }

        // onSaveCVBPendiente
        String nextPage = controller.onSaveCVBPendiente().getUrl();
        System.assertEquals('/'+CVBPendiente.Id, nextPage);
        Test.StopTest();
    }

    @isTest static void deleteProductCVBPendiente() {
        Opportunity CVBPendiente = null;

        Test.StartTest();
        Opportunity VBCompleta = [SELECT Id, AccountId FROM Opportunity LIMIT 1];

        String[] response = oppConfirmButtonController.sendConfirmationRequest(VBCompleta.Id, VBCompleta.AccountId);

        CVBPendiente = [SELECT Id FROM Opportunity WHERE Id = :response[2] LIMIT 1];

        // load page
        Test.setCurrentPageReference(Page.opportunityProductEntry);
        ApexPages.currentPage().getParameters().put('Id', CVBPendiente.Id);
        
        // load extension
        opportunityProductEntryExtension controller = new opportunityProductEntryExtension(new ApexPages.StandardController(CVBPendiente));

        // delete product
        opportunityProductEntryExtension.PbeWrapper wrp = null;

        for (opportunityProductEntryExtension.PbeWrapper wrapp : controller.shoppingCartWrappersUpsert) {
            if (wrapp.Variedad == 'BRASMAX ZEUS IPRO') { wrp = wrapp; } // Variedad BRASMAX ZEUS IPRO, Categoria BASICA, Unidad KG, Quantity 2000.0
        }

        controller.toUnselect = wrp.id;
        controller.removeShoppingCartWrappersUpsert();

        System.assertEquals(2, controller.shoppingCartWrappersUpsert.size(), 'Debe quitarse del carrito el producto Variedad BRASMAX ZEUS IPRO');

        // onSaveCVBPendiente
        String nextPage = controller.onSaveCVBPendiente().getUrl();
        System.assertEquals('/'+CVBPendiente.Id, nextPage);

        CVBPendiente = [SELECT Id, (SELECT Id FROM OpportunityLineItems WHERE Variedade_Prod__c = 'BRASMAX ZEUS IPRO') FROM Opportunity WHERE Id = :CVBPendiente.Id LIMIT 1];
        Test.stopTest();

        System.assert(CVBPendiente.OpportunityLineItems.isEmpty(), 'Debe eliminarse el producto Variedad BRASMAX ZEUS IPRO de la CVB Pendiente');
    }

    @isTest static void addProductCVBPendiente() {
        Opportunity CVBPendiente = null;
        Opportunity VBCompleta = null;
        OpportunityLineItem OLI = null;

        Test.StartTest();
        VBCompleta = [SELECT Id, AccountId FROM Opportunity LIMIT 1];

        String[] response = oppConfirmButtonController.sendConfirmationRequest(VBCompleta.Id, VBCompleta.AccountId);

        CVBPendiente = [SELECT Id FROM Opportunity WHERE Id = :response[2] LIMIT 1];

        // load page
        Test.setCurrentPageReference(Page.opportunityProductEntry);
        ApexPages.currentPage().getParameters().put('Id', CVBPendiente.Id);
        
        // load extension
        opportunityProductEntryExtension controller = new opportunityProductEntryExtension(new ApexPages.StandardController(CVBPendiente));

        // add product
        for (OpportunityLineItem producto : controller.VBCompleta.OpportunityLineItems) {
            if (producto.Variedade_Prod__c == 'BRASMAX ZEUS IPRO') { OLI = producto; } // Variedad BRASMAX ZEUS IPRO, Categoria BASICA, Unidad KG, Quantity Disponible 2000.0
        }

        //---------------------------------------------------------------------------------------------------
        opportunityProductEntryExtension.PbeWrapper wrp = null;

        for (opportunityProductEntryExtension.PbeWrapper wrapp : controller.shoppingCartWrappersUpsert) {
            if (wrapp.Variedad == 'BRASMAX ZEUS IPRO') { wrp = wrapp; }
        }

        controller.toUnselect = wrp.id;
        controller.removeShoppingCartWrappersUpsert(); // se exluye el producto para luego agregar otra variante con misma Variedad
        //---------------------------------------------------------------------------------------------------

        controller.shoppingCartWrappers[0].idVariedad = OLI.Product2.Variedade__c;
        controller.cantidadDisponible();

        controller.shoppingCartWrappers[0].idCategoria = OLI.Product2.Categ__c;
        controller.shoppingCartWrappers[0].idUnidad = 'SACA 40 KG';
        controller.shoppingCartWrappers[0].Tipo_de_Necesidad = 'Multiplicação';
        controller.shoppingCartWrappers[0].quantity = 40;

        controller.accion = 'agregando';
        controller.addShoppingCartWrappersUpsert(); // se agregan 40 bolsas a la variedad de producto BRASMAX ZEUS IPRO

        System.assertEquals(3, controller.shoppingCartWrappersUpsert.size(), 'Luego de sumar cantidades a un mismo producto debe mantenerse la cantidad de productos');

        for (opportunityProductEntryExtension.PbeWrapper wrapp : controller.shoppingCartWrappersUpsert) {
            if (wrapp.Variedad == 'BRASMAX ZEUS IPRO') { // Variedad BRASMAX ZEUS IPRO, Categoria BASICA, Unidad SACA 40 KG, Quantity 40.0
                System.assertEquals(40, wrapp.quantity, 'La cantidad de bolsas no coincide con la esperada');
                System.assertEquals(40, wrapp.cantSubUnidad, 'La cantidad de kg por bolsa no coincide con la esperada');
                System.assertEquals('SACA 40 KG', wrapp.idUnidad, 'La unidad de kg por bolsa no coincide con la esperada');
            }
        }

        // onSaveCVBPendiente
        controller.onSaveCVBPendiente();

        CVBPendiente = [
            SELECT Id, (SELECT Id, Id_Item_de_Oportunidad_Relacionado__c FROM OpportunityLineItems WHERE Variedade_Prod__c = 'BRASMAX ZEUS IPRO')
            FROM Opportunity WHERE Id = :CVBPendiente.Id LIMIT 1
        ];

        VBCompleta = controller.VBCompleta;
        Test.StopTest();

        OLI = null;

        for (OpportunityLineItem producto : VBCompleta.OpportunityLineItems) {
            if (producto.Variedade_Prod__c == 'BRASMAX ZEUS IPRO') { OLI = producto; }
        }

        System.assertNotEquals(null, OLI, 'No se encontró la Variedad BRASMAX ZEUS IPRO en la VB Completa');
        System.assert(!CVBPendiente.OpportunityLineItems.isEmpty(), 'No se encontró la Variedad BRASMAX ZEUS IPRO en la CVB Pendiente');
        System.assertEquals(OLI.Id, CVBPendiente.OpportunityLineItems[0].Id_Item_de_Oportunidad_Relacionado__c, 'El nuevo producto debe estar relacionado a la variedad BRASMAX ZEUS IPRO de la VB Completa');
    }

    @isTest static void onCancelCVBPendiente() {
        String nextPage = null;
        
        Test.StartTest();
        Opportunity VBCompleta = [SELECT Id, AccountId FROM Opportunity LIMIT 1];

        String[] response = oppConfirmButtonController.sendConfirmationRequest(VBCompleta.Id, VBCompleta.AccountId);

        Opportunity CVBPendiente = [SELECT Id FROM Opportunity WHERE Id = :response[2] LIMIT 1];

        Test.setCurrentPageReference(Page.opportunityProductEntry);
        ApexPages.currentPage().getParameters().put('Id', CVBPendiente.Id);
        
        opportunityProductEntryExtension controller = new opportunityProductEntryExtension(new ApexPages.StandardController(CVBPendiente));

        nextPage = controller.onCancelCVBPendiente().getUrl();
        Test.stopTest();

        System.assertEquals('/'+CVBPendiente.Id, nextPage);
    }
}
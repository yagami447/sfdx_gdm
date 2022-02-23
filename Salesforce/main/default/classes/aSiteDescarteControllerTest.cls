@isTest
private class aSiteDescarteControllerTest {
    
    @testSetup 
    static void setup(){
        
        Account testAccount = Build.anAccount().
            withName('Test account').
            withType('Multiplicador').
            withMarca('BRMX').
            build();
        insert testAccount; 
        
        SiteUser__c testSiteUser = Build.aSiteUser().
            withName('Test site user').
            withEmail('testsu@test.com').
            withPassword('test').
            withActive(true).
            withHabilitadoAnexos(true).
            build();
        insert testSiteUser;
        
        SiteUserAccount__c testSiteUserAccount = Build.aSiteUserAccount().
            withName('Test site user account').
            withAccount(testAccount).
            withSiteUser(testSiteUser).
            withActive(true).
            build();
        insert testSiteUserAccount;
        
        SiteUserSession__c testSiteUserSession = Build.aSiteUserSession().
            withSiteUser(testSiteUser).
            withMarca('BRMX').
            withSafra('18/19').
            build();
        insert testSiteUserSession;
        
        Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX().
            withPMSafraActualDescarte('18/19').
            build();
        insert testConfiguracionBMX;
        
        Variedad__c testVariedad = Build.aVariedad().
            withName('Test variety').
            withAtiva(true).
            withNombredeRegistro('Var').
            withNumeroderegistro('123').
            build();
        insert testVariedad;
        
        Categoria__c testCategory = Build.aCategoria().
            withName('BASICA').
            build();
		testCategory.Mostrar_en_portal__c = true;
        insert testCategory;
        
        Categoria__c testCategoryBis = Build.aCategoria().
            withName('C2').
            build();
		testCategoryBis.Mostrar_en_portal__c = true;
        insert testCategoryBis;
        
        Product2 testProduct2 = Build.aProduct2().
            withName('Test product2').
            withCategoria('C1').
            withFamily('Royalty x Basica').
            withVariedade(testVariedad).
            withPrice(40).
            withCateg(testCategory).
            withIsActive(true).
            build();
        insert testProduct2;
        
        Product2 testProduct2bis = Build.aProduct2().
            withName('Test product2').
            withCategoria('C2').
            withFamily('Royalty x Basica').
            withVariedade(testVariedad).
            withPrice(40).
            withCateg(testCategory).
            withIsActive(true).
            build();
        insert testProduct2bis;
       
        Pricebook2 testPricebook2t = new Pricebook2();
        testPricebook2t.Name = 'Lista Canal Multiplicadores';
        insert testPricebook2t;
        
        PricebookEntry standardPrice2 = Build.aPricebookEntry().
            withPricebook2Id(Test.getStandardPricebookId()).
            withUnitPrice(58).
            withProduct2Id(testProduct2).
            withIsActive(false).
            build();
        insert standardPrice2;    


        PricebookEntry standardPrice = Build.aPricebookEntry().
            withPricebook2Id(testPricebook2t).
            withUnitPrice(58).
            withProduct2Id(testProduct2).
            withIsActive(true).
            build();
        insert standardPrice;
        
        Opportunity testOpportunity = Build.anOpportunityDescarte().
            withName('Test descarte').
            withAccountId(testAccount).
            withSafra('18/19').
            withMarca('BRMX').
            withCloseDate(System.today()).
            build();
        insert testOpportunity;
        
        OpportunityLineItem testOpportunityLineItem = Build.anOpportunityLineItem().
            withOpportunityId(testOpportunity).
            withPricebookEntryId(standardPrice).
            withProduct2Id(testProduct2).
            withQuantity(40).
            withUnitPrice(400).
            build();
        insert testOpportunityLineItem;
        
        Opportunity testOpportunityWithoutOpportunityLineItem = Build.anOpportunityDescarte().
            withName('Test descarte without OpportunityLineItem').
            withAccountId(testAccount).
            withSafra('18/19').
            withStageName('Aprobada').
            withDescription('Test').
            withMarca('BRMX').
            withCloseDate(System.today()).
            build();
        insert testOpportunityWithoutOpportunityLineItem;
        
        Opportunity testOpportunityAnexoII = Build.anOpportunityAnexoII().
            withName('Test Anexo II Opportuntiy').
            withAccountId(testAccount).
            withSafra('18/19').
            withStageName('Aprobada').
            withDescription('Not necessary').
            withMarca('BRMX').
            withCloseDate(System.today()).
            build();
        insert testOpportunityAnexoII; 
        
        OpportunityLineItem testOpportunityLineItemForAnexoII = Build.anOpportunityLineItem().
            withOpportunityId(testOpportunityAnexoII).
            withPricebookEntryId(standardPrice).
            withProduct2Id(testProduct2).
            withSementeBruta(60).
            withCategoria(testCategory).
            withQuantity(60).
            withUnitPrice(400).
            build();
		testOpportunityLineItemForAnexoII.Variedad__c = testVariedad.Id;
        insert testOpportunityLineItemForAnexoII;

        
        OpportunityLineItem testOpportunityLineItemForAnexoIIbis = Build.anOpportunityLineItem().
            withOpportunityId(testOpportunityAnexoII).
            withPricebookEntryId(standardPrice).
            withProduct2Id(testProduct2bis).
            withSementeBruta(10).
            withCategoria(testCategoryBis).
            withQuantity(10).
            withUnitPrice(100).
            build();
        insert testOpportunityLineItemForAnexoIIbis;
    }
    
    @isTest 
    static void debeValidarSesion() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        Account controllerAccount = controller.getAccount(); 
        SiteUser__c controllerSiteUser = controller.getUser();
        Test.stopTest();
        
        System.assertEquals(testSiteUser.Id, controllerSiteUser.Id, 'Site user created in test is different from the one returned by the controller');
        System.assertEquals(testAccount.Id, controllerAccount.Id, 'Account created in test is different from the one returned by the controller');
    }
    
    @isTest 
    static void fallaValidarSesion() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        delete testSiteUser;
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        
        PageReference expectedPageRef = new PageReference('/apex/aSiteLogin');
        expectedPageRef.getParameters().put('comp','BRMX');
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        PageReference controllerPageRef = controller.validate();
        Test.stopTest();
        
        System.assertNotEquals(expectedPageRef.getUrl().toLowerCase(), controllerPageRef.getUrl().toLowerCase(), 'Site user created in test is different from the one returned by the controller');  
    }
    
    @isTest
    static void debeObtenerDescartes() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        List<Opportunity> testList = controller.getDescarteOpportunities();
        Test.stopTest();
        
        System.assertEquals(2, testList.size(), 'Did not find descarte opportunities for the account/campaign/safra');
    }
    
    @isTest
    static void fallaObtencionDescartes() {
        List<Opportunity> testDescarteOpportunities = [SELECT Id FROM Opportunity];
        delete testDescarteOpportunities;
        
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        List<Opportunity> testList = controller.getDescarteOpportunities();
        Test.stopTest();
        
        System.assertEquals(0, testList.size(), 'Found descarte opportunities for the account/campaign/safra');
    }
    
    @isTest 
    static void debeObtenerOportunidadesDeDescartes(){
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        controller.getDescarteOpportunities();
        controller.getProductsForSelectedDescarteOpportunity();
        List<OpportunityLineItem> testOpportunityLineItemList = controller.productosDeOportunidadSeleccionada;
        Test.stopTest();
        
        System.assertEquals(1, testOpportunityLineItemList.size(), 'Did not find opportunity line item for the current descarte opportunity');                
    }
    
    @isTest
    static void fallaObtencionOportunidadesDeDescartes() {
        
        List<OpportunityLineItem> opportunityLineItems = [SELECT Id, Name FROM OpportunityLineItem];
        delete opportunityLineItems;
        
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        controller.getProductsForSelectedDescarteOpportunity();
        List<OpportunityLineItem> testOpportunityLineItemList = controller.productosDeOportunidadSeleccionada;
        Test.stopTest();
        
        System.assertEquals(0, testOpportunityLineItemList.size(), 'Did find opportunity line item for the current descarte opportunity');
        
        
    }
    
    @isTest
    static void debeObtenerEtiquetasDeDescarte() {
        List<Schema.FieldSetMember> expectedFieldSet = SObjectType.OpportunityLineItem.FieldSets.Anexo_Descarte.getFields();
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        System.debug(expectedFieldSet);
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id); 
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        list<Schema.FieldSetMember> controllerFieldSet = controller.getFields();
        Test.stopTest();
        
        System.assertEquals(expectedFieldSet.size(), controllerFieldSet.size(), 'Method getFields() inside aSiteDescarteController not returning field set for Anexo_Descarte');
        
        
    }
    
    @isTest 
    static void debeObtenerPdf() {
        List<Opportunity> testOpps = [SELECT Id, Name, Marca__c FROM Opportunity];
        
        Attachment testAttachment = new Attachment();
        testAttachment.Body = Blob.valueOf('TEST');
        testAttachment.Name = testOpps[0].Name + '_' + testOpps[0].Marca__c + '_autorizacao_descarte.pdf';
        testAttachment.parentId = testOpps[0].Id;
        insert testAttachment;
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.idOportunidadImprimir = testOpps[0].Id;
        controller.getPdfUrl();
        Test.stopTest();
        
        System.assertEquals(testAttachment.Name, controller.nombrePDF, 'Name of PDF expected differs from one returned by controller');
        System.assertEquals(testAttachment.Body, EncodingUtil.base64Decode(controller.pdfBlob), 'Blobs are not equal');
    }
    
    @isTest 
    static void debeAsignarVariedadSeleccionada() {
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.nuevoProductoDeOportunidad.variedad = testVariedad.Id;
        controller.setSelectedVariedad();
        Test.stopTest();
        
        System.assertEquals(testVariedad.Id, controller.variedadSeleccionada, 'variedadSeleccionada was not set'); 
    }
    
    @isTest 
    static void debeObtenerNuevoItem() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        aAppendix.myOppItem expectedItem = new aAppendix.myOppItem();
        expectedItem.variedad = '123';
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        controller.getNewOppLineItem();
        controller.nuevoProductoDeOportunidad.variedad = '123';
        aAppendix.myOppItem controllerItem = controller.nuevoProductoDeOportunidad;
        Test.stopTest();
        
        System.assertEquals(expectedItem.variedad, controllerItem.variedad, 'New custom item was not created');
    }
    
    @isTest 
    static void debeDevolverListaDeItemsVacia() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        controller.getOppLineItem();
        List<aAppendix.myOppItem> controllerList = controller.listaDeNuevosProductosDeOportunidad;
        Test.stopTest();	
        
        System.assertEquals(0, controllerList.size(), 'There are OLIS in the list or the list is not null' );
    }
    
    @isTest 
    static void debeDevolverListaDeItemsLlena() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1]; 
        RecordType descarteRecordType = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Descarte' LIMIT 1];
        Opportunity testOpportunity = [SELECT Id, HasOpportunityLineItem, RecordTypeId FROM Opportunity WHERE HasOpportunityLineItem = true AND RecordTypeId = :descarteRecordType.Id];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();     
        controller.idDeDescarteEditar = testOpportunity.Id;
        List<aAppendix.myOppItem> controllerList = controller.getOppLineItem();
        Test.stopTest();	
        
        System.assertEquals(1, controllerList.size(), 'There are OLIS in the list or the list is not null' );
    }
    
    @isTest
    static void debeDevolverUnaVariedad() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();     
        List<SelectOption> controllerVariedadSelectOption = controller.getVariedadesNewDescarte();
        Test.stopTest();
        
        System.assertEquals(1, controllerVariedadSelectOption.size(), 'There are not varieties when one from Anexo II should exist');
    }
    
    // This method was hardcoded that's why it will always return 4 options                                                             
    @isTest
    static void debeDevolverCuatroOpcionesDeUnidad() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();     
        List<SelectOption> controllerVariedadSelectOption = controller.getUnidadesNewDescarte();
        Test.stopTest();
        
        System.assertEquals(4, controllerVariedadSelectOption.size(), 'If not passing, something was changed in aAppManager.getUnidades()');
    }
    
    @isTest 
    static void debeDevolverUnaOpcionParaCategoria() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarteEdit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate(); 
        controller.variedadSeleccionada = testVariedad.Id;
        controller.getVariedadesNewDescarte();
        List<SelectOption> controllerCategoriesSelectOption = controller.getCategoriaNewDescarte();
        Test.stopTest();
        
        System.assertEquals(2, controllerCategoriesSelectOption.size(), 'Categories are not being charged');
    }
    
    @isTest 
    static void debeValidarCompletarNuevoItem() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate(); 
        aAppendix.myOppItem controllerTmpNewOli = controller.nuevoProductoDeOportunidad;
        controllerTmpNewOli.categoria = 'asd';
        controllerTmpNewOli.amount = 123;
        controllerTmpNewOli.variedad = '1231234';
        controllerTmpNewOli.lote_rebajado= '1';
        Boolean controllerValidationResult = controller.validateRequiredFields();
        Test.stopTest();
        
        System.assertEquals(true, controllerValidationResult, 'Required fields are not set and the method still validates the item');     
    }
    
    @isTest 
    static void fallaValidarNuevoItem() {
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        aAppendix.myOppItem controllerTmpNewOli = controller.nuevoProductoDeOportunidad;
        controllerTmpNewOli.categoria = 'asd';
        controllerTmpNewOli.variedad = '1231234';
        Boolean controllerValidationResult = controller.validateRequiredFields();
        Test.stopTest();
        
        System.assertEquals(false, controllerValidationResult);
    }
    
    @isTest 
    static void fallaValidarItemCategoriaVacia() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate(); 
        aAppendix.myOppItem controllerTmpNewOli = controller.nuevoProductoDeOportunidad;
        controllerTmpNewOli.amount = 123;
        controllerTmpNewOli.variedad = '1231234';
        Boolean controllerValidationResult = controller.validateRequiredFields();
        Test.stopTest();
        
        
        System.assertEquals(false, controllerValidationResult);
    }
    
    @isTest 
    static void fallaValidarItemVariedadVacia() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate(); 
        aAppendix.myOppItem controllerTmpNewOli = controller.nuevoProductoDeOportunidad;
        controllerTmpNewOli.amount = 123;
        controllerTmpNewOli.categoria = '1231234';
        Boolean controllerValidationResult = controller.validateRequiredFields();
        Test.stopTest();
        
        
        System.assertEquals(false, controllerValidationResult);
    }
    
    @isTest 
    static void fallaValidarItemCamposRequeridosVacios() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate(); 
        aAppendix.myOppItem controllerTmpNewOli = controller.nuevoProductoDeOportunidad;
        Boolean controllerValidationResult = controller.validateRequiredFields();
        Test.stopTest();
        
        
        System.assertEquals(false, controllerValidationResult);
    }
    
    @isTest 
    static void debeAgregarItemEnListaDeItems() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate(); 
        List<aAppendix.myOppItem> controllerList = controller.getOppLineItem(); 
        aAppendix.myOppItem controllerTmpNewOli = controller.getNewOppLineItem();
        controller.nombreVariedadPorId.put('1231234', 'Asd');
        controller.nombreCategoriaPorId.put('asd', 'AAA');
        controller.variedadSeleccionada = '1231234';
        controllerTmpNewOli.categoria = 'asd';
        controllerTmpNewOli.amount = 123;
        controllerTmpNewOli.variedad = '1231234';
		controllerTmpNewOli.unidade = '1';
        controller.completeAndAddItem();
        Test.stopTest();
        
        System.assertEquals(1, controllerList.size(), 'New oli was not completed or added to the list correctly');
        System.assertEquals(false, String.isEmpty(controllerList[0].categoria_nombre), 'Name of category was not completed');
        System.assertEquals(true, String.isEmpty(controllerList[0].variedad_nombre), 'Name of variety was not completed');
        System.assertEquals(false, String.isEmpty(String.valueOf(controllerList[0].amount)), 'Amount of new oli was not completed');
        System.assertEquals(false, String.isEmpty(String.valueOf(controllerList[0].id)), 'Id of new oli was not completed');
    }
    
    @isTest 
    static void debeRedireccionarPaginaNuevaOportunidad() {
        
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id); 
        
        PageReference expectedPageRef = Page.aSiteDescarteEdit;
        expectedPageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        PageReference controllerPageRef = controller.gotoNew();
        Test.stopTest();
        System.debug(controllerPageRef);
        System.assertEquals(expectedPageRef.getUrl().toLowerCase(), controllerPageRef.getUrl().toLowerCase(), 'Page reference is not the same as the expected one');  
    }
    
    @isTest 
    static void fallaRedireccionPaginaNuevaOportunidad() {
        
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id); 
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        controller.gotoNew();
        PageReference controllerPageRef = ApexPages.currentPage(); 
        Test.stopTest();
        
        System.assertEquals(pageRef.getUrl().toLowerCase(), controllerPageRef.getUrl().toLowerCase());
    }
    
    @isTest 
    static void debeRedireccionarPaginaEditarOportunidad() {
        
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id); 
        
        List<Opportunity> testDescarteOpportunities = [SELECT Id FROM Opportunity LIMIT 2];
        PageReference expectedPageRef = Page.aSiteDescarteEdit;
        expectedPageRef.getParameters().put('token', testSiteUserSession.Id);
        expectedPageRef.getParameters().put('e', testDescarteOpportunities[1].Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        controller.idDeDescarteEditar = testDescarteOpportunities[1].Id;
        PageReference controllerPageRef = controller.gotoEdit();
        Test.stopTest();
        
        System.assertEquals(expectedPageRef.getUrl().toLowerCase(), controllerPageRef.getUrl().toLowerCase(), 'Page reference is not the same as the expected one');  
    }
    
    @isTest 
    static void fallaRedireccionPaginaEditarOportunidad() {
        
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id); 
        
        List<Opportunity> testDescarteOpportunities = [SELECT Id FROM Opportunity LIMIT 2];
        PageReference expectedPageRef = Page.aSiteDescarteEdit;
        expectedPageRef.getParameters().put('token', testSiteUserSession.Id);
        expectedPageRef.getParameters().put('e', testDescarteOpportunities[1].Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        controller.idDeDescarteEditar = testDescarteOpportunities[0].Id;
        PageReference controllerPageRef = controller.gotoEdit();
        Test.stopTest();
        
        System.assertNotEquals(expectedPageRef.getUrl().toLowerCase(), controllerPageRef.getUrl().toLowerCase(), 'Page reference is not the same as the expected one');  
    }
    
    @isTest
    static void debeCancelarEdicion() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarteEdit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        PageReference expectedPageRef = Page.aSiteDescarte;
        expectedPageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();
        PageReference controllerPageRef = controller.editCancel();
        Test.stopTest();
        
        System.assertEquals(expectedPageRef.getUrl().toLowerCase(), controllerPageRef.getUrl().toLowerCase(), 'Did not redirect to asitedescarte page');
    } 
    
    @isTest
    static void debeLimpiarMensajesDeError() {
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.mensajeErrorCantidad = 'ERROR';
        controller.mensajeErrorCategoria = 'ERROR';
        controller.mensajeErrorVariedad = 'ERROR';
        controller.clearErrorMessages();
        Test.stopTest();
        
        System.assertEquals(true, String.isEmpty(controller.mensajeErrorCantidad), 'Amount error message was not deleted');
        System.assertEquals(true, String.isEmpty(controller.mensajeErrorCategoria), 'Category error message was not deleted');
        System.assertEquals(true, String.isEmpty(controller.mensajeErrorVariedad), 'Variety error message was not deleted');
    }
    
    @isTest 
    static void debeRemoverItemsDeLista() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1]; 
        RecordType descarteRecordType = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Descarte' LIMIT 1];
        Opportunity testOpportunity = [SELECT Id, HasOpportunityLineItem, RecordTypeId FROM Opportunity WHERE HasOpportunityLineItem = true AND RecordTypeId = :descarteRecordType.Id];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();     
        controller.idDeDescarteEditar = testOpportunity.Id;
        List<aAppendix.myOppItem> controllerList = controller.getOppLineItem();
        controller.idItemRemover = controllerList[0].id;
        controller.removeProduct();
        Test.stopTest();	
        
        System.assertEquals(0, controllerList.size(), 'Item was not removes from temporary list');
    }
    
    @isTest 
    static void debeValidarCantidadesItem() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarteEdit;
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.setCurrentPage(pageRef);
        
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        List<Categoria__c> testCategorias = [SELECT Id, Name FROM Categoria__c];
        
        aAppendix.myOppItem testItem = new aAppendix.myOppItem();
        testItem.categoria = testCategorias[0].Id;
        testItem.variedad = testVariedad.Id;
        testItem.amount = 23;
        testItem.unidade = '1';
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();  
        controller.nuevoProductoDeOportunidad = testItem;
        controller.variedadSeleccionada = testVariedad.Id;
        controller.listaDeNuevosProductosDeOportunidad = new List<aAppendix.myOppItem>();
        Boolean controllerRet = controller.validateItemQuantity();
        Test.stopTest();
        
        System.assertEquals(true, controllerRet, 'Validation should have been true. Item quantity is bigger than available and it still passes');
        
    } 
    
    @isTest 
    static void fallaValidacionItemCantidadEsCero() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarteEdit;
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.setCurrentPage(pageRef);
        
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        List<Categoria__c> testCategorias = [SELECT Id, Name FROM Categoria__c];
        
        aAppendix.myOppItem testItem = new aAppendix.myOppItem();
        testItem.categoria = testCategorias[0].Id;
        testItem.variedad = testVariedad.Id;
        testItem.amount = 0;
        testItem.unidade = '1';
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();  
        controller.nuevoProductoDeOportunidad = testItem;
        controller.variedadSeleccionada = testVariedad.Id;
        controller.listaDeNuevosProductosDeOportunidad = new List<aAppendix.myOppItem>();
        Boolean controllerRet = controller.validateItemQuantity();
        Test.stopTest();
        
        System.assertEquals(false, controllerRet, 'Validation should have been false. Item quantity is 0 and still passes');
        
    } 
    
    @isTest 
    static void fallaValidacionCantidadesDeItemMayoresAlDisponible() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarteEdit;
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.setCurrentPage(pageRef);
        
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        List<Categoria__c> testCategorias = [SELECT Id, Name FROM Categoria__c];
        
        aAppendix.myOppItem testItem = new aAppendix.myOppItem();
        testItem.categoria = testCategorias[0].Id;
        testItem.variedad = testVariedad.Id;
        testItem.amount = 333333333;
        testItem.unidade = '1';
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();  
        controller.nuevoProductoDeOportunidad = testItem;
        controller.variedadSeleccionada = testVariedad.Id;
        controller.listaDeNuevosProductosDeOportunidad = new List<aAppendix.myOppItem>();
        Boolean controllerRet = controller.validateItemQuantity();
        Test.stopTest();
        
        System.assertEquals(false, controllerRet, 'Validation should have been false. Item quantity is bigger than available and it still passes');
        
    } 
    
    @isTest 
    static void debeValidarCantidadesDeLaListaDeItems() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarteEdit;
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.setCurrentPage(pageRef);
        
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        List<Categoria__c> testCategorias = [SELECT Id, Name FROM Categoria__c];
        
        aAppendix.myOppItem testItem = new aAppendix.myOppItem();
        testItem.categoria = testCategorias[0].Id;
        testItem.variedad = testVariedad.Id;
        testItem.amount = 23;
        testItem.unidade = '1';
		testItem.unidadDescarte = 1;
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();  
		controller.listaDeNuevosProductosDeOportunidad.add(testItem);
        controller.variedadSeleccionada = testVariedad.Id;
        Boolean controllerRet = controller.validateItemQuantityOnSave();
        Test.stopTest();
        
        System.assertEquals(true, controllerRet, 'Validation should have been true. Item quantity is bigger than available and it still passes');
        
    } 
    
    @isTest 
    static void fallaValidacionDeListaDeItemsCantidadExcedeDisponible() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarteEdit;
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.setCurrentPage(pageRef);
        
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        List<Categoria__c> testCategorias = [SELECT Id, Name FROM Categoria__c];
        
        aAppendix.myOppItem testItem = new aAppendix.myOppItem();
        testItem.categoria = testCategorias[0].Id;
        testItem.variedad = testVariedad.Id;
        testItem.amount = 99999;
        testItem.unidade = '1';
        testItem.unidadDescarte = 1;

        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();  
		controller.listaDeNuevosProductosDeOportunidad.add(testItem);
        controller.variedadSeleccionada = testVariedad.Id;
        Boolean controllerRet = controller.validateItemQuantityOnSave();
        Test.stopTest();
        
        System.assertEquals(false, controllerRet, 'Validation should have been false. Item quantity is bigger than available and it still passes');
        
    } 
    
    @isTest 
    static void fallaValidacionDeListaDeItemsCantidadEsCero() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarteEdit;
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.setCurrentPage(pageRef);
        
        
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        List<Categoria__c> testCategorias = [SELECT Id, Name FROM Categoria__c];
        
        aAppendix.myOppItem testItem = new aAppendix.myOppItem();
        testItem.categoria = testCategorias[0].Id;
        testItem.variedad = testVariedad.Id;
        testItem.amount = 0;
        testItem.unidade = '1';
        testItem.unidadDescarte = 1;

        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
        controller.validate();  
		controller.listaDeNuevosProductosDeOportunidad.add(testItem);
        controller.variedadSeleccionada = testVariedad.Id;
        Boolean controllerRet = controller.validateItemQuantityOnSave();
        Test.stopTest();
        
        System.assertEquals(false, controllerRet, 'Validation should have been false. Item quantity is 0 and it still passes');
        
    } 
    
    @isTest 
    static void debeCompletarItemAgregarloEnLista() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarteEdit;
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.setCurrentPage(pageRef);
        
		Account cuenta = [SELECT ID FROM ACCOUNT];
		SiteUserAccount__c testSiteUserAccount = [SELECT ID FROM SiteUserAccount__c];
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        List<Categoria__c> testCategorias = [SELECT Id, Name FROM Categoria__c];
		List<aAppendix.myOppItem> listaDeNuevosProductosDeOportunidad = new List<aAppendix.myOppItem>();
        
        aAppendix.myOppItem testItem = new aAppendix.myOppItem();
        testItem.categoria = testCategorias[0].Id;
        testItem.variedad = testVariedad.Id;
        testItem.amount = 1;
        testItem.unidade = '1';
		testItem.lote_rebajado = '1';
        
        Test.startTest();
        aSiteDescarteController controller = new aSiteDescarteController();
		controller.listaDeNuevosProductosDeOportunidad = listaDeNuevosProductosDeOportunidad;
        controller.validate();  
        controller.nuevoProductoDeOportunidad = testItem;
        controller.variedadSeleccionada = testVariedad.Id;
		controller.addProduct();
		List<aAppendix.myOppItem> controllerTemporalOpportunityLineItems = controller.listaDeNuevosProductosDeOportunidad;
        Test.stopTest();
        
        System.assertEquals(false, controllerTemporalOpportunityLineItems.isEmpty() , 'No se cargaron los items a la listsa, alguna validacion se disparo cuando no debia, o la cantidad no esta bien calculada');
        
    }
    
	@IsTest
	static void validarGuardarElRegistro() {
		SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarteEdit;
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.setCurrentPage(pageRef);
        
		Account cuenta = [SELECT ID FROM ACCOUNT];
		SiteUserAccount__c testSiteUserAccount = [SELECT ID FROM SiteUserAccount__c];
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        List<Categoria__c> testCategorias = [SELECT Id, Name FROM Categoria__c];
		List<aAppendix.myOppItem> listaDeNuevosProductosDeOportunidad = new List<aAppendix.myOppItem>();
        
        aAppendix.myOppItem testItem = new aAppendix.myOppItem();
        testItem.categoria = testCategorias[0].Id;
        testItem.variedad = testVariedad.Id;
        testItem.amount = 1;
        testItem.unidade = '1';
		testItem.lote_rebajado = '1';
        
		PageReference buffer;
			Test.startTest();
			aSiteDescarteController controller = new aSiteDescarteController();
			controller.listaDeNuevosProductosDeOportunidad = listaDeNuevosProductosDeOportunidad;
			controller.validate();  
			controller.nuevoProductoDeOportunidad = testItem;
			controller.variedadSeleccionada = testVariedad.Id;
			controller.addProduct();
			buffer = controller.saveDescarte();
		Test.stopTest();
		System.assertNotEquals(null, buffer, 'No se cargó el registro');
	}

	@IsTest
	static void siHayCamposVaciosNoGuardarElRegistro() {
		SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        PageReference pageRef = Page.aSiteDescarteEdit;
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.setCurrentPage(pageRef);
        
		Account cuenta = [SELECT ID FROM ACCOUNT];
		SiteUserAccount__c testSiteUserAccount = [SELECT ID FROM SiteUserAccount__c];
        Variedad__c testVariedad = [SELECT Id, Name FROM Variedad__c];
        List<Categoria__c> testCategorias = [SELECT Id, Name FROM Categoria__c];
		List<aAppendix.myOppItem> listaDeNuevosProductosDeOportunidad = new List<aAppendix.myOppItem>();
        
        aAppendix.myOppItem testItem = new aAppendix.myOppItem();
        testItem.categoria = testCategorias[0].Id;
        testItem.variedad = testVariedad.Id;

		Test.startTest();
			aSiteDescarteController controller = new aSiteDescarteController();
			controller.listaDeNuevosProductosDeOportunidad = listaDeNuevosProductosDeOportunidad;
			controller.validate();  
			controller.nuevoProductoDeOportunidad = testItem;
			controller.variedadSeleccionada = testVariedad.Id;
			controller.addProduct();
		Test.stopTest();
		System.assertEquals(0, controller.listaDeNuevosProductosDeOportunidad.size(), 'La validacion fallo');
	}
}
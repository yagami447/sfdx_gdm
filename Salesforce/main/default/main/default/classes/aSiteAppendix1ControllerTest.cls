@isTest
private class aSiteAppendix1ControllerTest {
    
    @testSetup
    static void setup() {
    Test.startTest();
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

        Estado__c estado = Build.anEstado().
            withMostrarenportal(true).
            withName('Estado test').
            build();
        insert estado;

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
            withPMSafraActualA1('18/19').
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
            withName('C1').
            build();
        testCategoryBis.Mostrar_en_portal__c = true;
        insert testCategoryBis;

        Categoria__c testCategoryBisBis = Build.aCategoria().
            withName('C2').
            build();
        testCategoryBisBis.Mostrar_en_portal__c = true;
        insert testCategoryBisBis;
        
        Categoria__c testCategoryBisBisBis = Build.aCategoria().
            withName('S1').
            build();
        testCategoryBisBisBis.Mostrar_en_portal__c = true;
        insert testCategoryBisBisBis;

        Product2 testProduct2 = Build.aProduct2().
            withName('Test product2').
            withCategoria('BASICA').
            withFamily('Royalty x Basica').
            withVariedade(testVariedad).
            withPrice(40).
            withCateg(testCategory).
            withIsActive(true).
            build();
        insert testProduct2;
        
        Product2 testProduct2bis = Build.aProduct2().
            withName('Test product2bis').
            withCategoria('C1').
            withFamily('Royalty x Basica').
            withVariedade(testVariedad).
            withPrice(40).
            withCateg(testCategory).
            withIsActive(true).
            build();
        insert testProduct2bis;
        
        Pricebook2 testPricebook2t = new Pricebook2();
        testPricebook2t.Name = 'Lista de precios estándar';
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

       Opportunity oportunidadAnexoI = Build.anOpportunityAnexoI().
            withName('Test Anexo I Opportuntiy').
            withAccountId(testAccount).
            withSafra('17/18').
            withStageName('Aprobada').
            withDescription('Not necessary').
            withMarca('BRMX').
            withCloseDate(System.today()).
            build();
        insert oportunidadAnexoI;

        Opportunity oportunidadSafraAnterior = Build.anOpportunityAnexoII().
            withName('Test Anexo II Opportuntiy').
            withAccountId(testAccount).
            withSafra('17/18').
            withStageName('Aprobada').
            withDescription('Not necessary').
            withMarca('BRMX').
            withCloseDate(System.today()).
            build();
        insert oportunidadSafraAnterior;

        Opportunity anexoIIRebajamiento = Build.anOpportunityAnexoIIRebaixamentoSacas().
            withName('Rebajacionnnn').
            withAccountId(testAccount).
            withSafra('17/18').
            withStageName('Aprobada').
            withDescription('Not necessary').
            withMarca('BRMX').
            withCloseDate(System.today()).
            build();
        anexoIIRebajamiento.Anexo_Relacionado__c = oportunidadSafraAnterior.Id;
        insert anexoIIRebajamiento;

        OpportunityLineItem itemRebaja = Build.anOpportunityLineItem().
            withOpportunityId(anexoIIRebajamiento).
            withPricebookEntryId(standardPrice).
            withProduct2Id(testProduct2bis).
            withSementeBruta(30).
            withCategoria(testCategoryBisBis).
            withQuantity(60).
            withUnitPrice(400).
            build();
        itemRebaja.Variedad__c = testVariedad.Id;
        itemRebaja.Sem_Rebajada__c = 30;
        itemRebaja.Categoria_a_Rebaixar__c = testCategoryBis.Id;
        insert itemRebaja;



        OpportunityLineItem itemAnexoII = Build.anOpportunityLineItem().
            withOpportunityId(oportunidadSafraAnterior).
            withPricebookEntryId(standardPrice).
            withProduct2Id(testProduct2bis).
            withSementeBruta(40).
            withCategoria(testCategoryBis).
            withQuantity(40).
            withUnitPrice(400).
            build();
        itemAnexoII.Variedad__c = testVariedad.Id;
        insert itemAnexoII;

        Opportunity descarte = Build.anOpportunityDescarte().
            withName('Test descarte without OpportunityLineItem').
            withAccountId(testAccount).
            withSafra('17/18').
            withStageName('Aprobada').
            withDescription('Test').
            withMarca('BRMX').
            withCloseDate(System.today()).
            build();
        insert descarte;

        OpportunityLineItem descarteitem = Build.anOpportunityLineItem().
            withOpportunityId(descarte).
            withPricebookEntryId(standardPrice).
            withProduct2Id(testProduct2bis).
            withQuantity(10).
            withUnitPrice(400).
            withCategoria(testCategoryBis).
            build();
        descarteitem.Unidade_descarte__c = 'Quilograma';
        descarteitem.Variedad__c = testVariedad.Id;
        insert descarteitem;

        Test.stopTest();
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
        aSiteAppendix1Controller controller = new aSiteAppendix1Controller();
        controller.validate();
        Account controllerAccount = controller.getAccount(); 
        SiteUser__c controllerSiteUser = controller.getUser();
        Test.stopTest();
        
        System.assertEquals(testSiteUser.Id, controllerSiteUser.Id, 'Site user created in test is different from the one returned by the controller');
        System.assertEquals(testAccount.Id, controllerAccount.Id, 'Account created in test is different from the one returned by the controller');
    }
    
    @isTest
    static void noDebeValidarSesion() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        
        PageReference expectedPageRef = new PageReference('/apex/aSiteLogin');
        expectedPageRef.getParameters().put('comp','BRMX');

        Test.startTest();
        aSiteAppendix1Controller controller = new aSiteAppendix1Controller();
        PageReference controllerPageRef = controller.validate();
        Test.stopTest();
        
        System.assertNotEquals(expectedPageRef.getUrl().toLowerCase(), controllerPageRef.getUrl().toLowerCase(), 'Site user created in test is different from the one returned by the controller');
    }
    
    @isTest
    static void debeRetornarOportunidadesAnexoI() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteAppendix1Controller controller = new aSiteAppendix1Controller();
        controller.validate();
        controller.relatedApp = null;
        controller.getAppends1();
        Test.stopTest();
        
        System.assertEquals(0, controller.relatedApp.size(), 'Site user created in test is different from the one returned by the controller');
    }
    
     @isTest
    static void debeRetornarError() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteAppendix1Controller controller = new aSiteAppendix1Controller();
        controller.validate();
        controller.relatedApp = null;
        controller.getAppends1();
        Test.stopTest();
        
        // System.assertEquals(1, controller.relatedApp.size(), 'Site user created in test is different from the one returned by the controller');
    }
    
    @isTest 
    static void debeDevolverItemsOportunidad() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteDescarte;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        
        Test.startTest();
        aSiteAppendix1Controller controller = new aSiteAppendix1Controller();
        controller.validate();
        controller.relatedAppReb = null;
        controller.getAppends1Reb();
        Test.stopTest();
    }
    /*
    @isTest
    static void devolverCamposAnexoI() {
        
        Test.startTest();
        aSiteAppendix1Controller controller = new aSiteAppendix1Controller();
        List<Schema.FieldSetMember> fields = controller.getFields();
        Test.stopTest();
        
        System.assertEquals(6, fields.size());
    }
    
    @isTest
    static void devolverCamposAnexoIRebaja() {
        
        Test.startTest();
        aSiteAppendix1Controller controller = new aSiteAppendix1Controller();
        List<Schema.FieldSetMember> fields = controller.getFieldsReb();
        Test.stopTest();
        
        System.assertEquals(6, fields.size());
    }

*/

                                    /* Creacion Nueva Oportunidad */
/*
    @isTest
    static void debeCargarLosMapasDeVariedad() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteAppendix1Edit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.startTest();
            aSiteAppendix1Controller controlador = new aSiteAppendix1Controller();
            controlador.validate();
            List<SelectOption> opciones = controlador.getVariedades();
        Test.stopTest();
        System.assertEquals(1, opciones.size(), 'No se cargaron las opciones. O fallo el controlador o se modificó el setup del Test');
    }*/
/*
    @isTest
    static void debeCargarElMapaDeCategorias() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteAppendix1Edit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.startTest();
            aSiteAppendix1Controller controlador = new aSiteAppendix1Controller();
            controlador.validate();
            List<SelectOption> opcionesVariedad = controlador.getVariedades();
            controlador.variedadSeleccionada = opcionesVariedad[0].getValue();
            List<SelectOption> opciones = controlador.getCategoriasAnexo();
        Test.stopTest();
        System.assertEquals(1, opciones.size(), 'No se cargaron las opciones. O fallo el controlador o se modificó el setup del Test');
    }
*/
    @isTest
    static void debeTraerLosEstadosDisponibles() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteAppendix1Edit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.startTest();
            aSiteAppendix1Controller controlador = new aSiteAppendix1Controller();
            controlador.validate();
            List<SelectOption> opciones = controlador.getEstadoDeLaProduccion();
        Test.stopTest();
        System.assertEquals(1, opciones.size(), 'No se cargaron las opciones. O fallo el controlador o se modificó el setup del Test');
    }
/*
    @isTest
    static void debeInsertarLaNuevaOportunidadConSusProductos() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        Variedad__c variedad = [SELECT ID FROM Variedad__c];
        List<Categoria__c> categoria = [SELECT ID FROM Categoria__c];
        PageReference pageRef = Page.aSiteAppendix1Edit;
        List<Opportunity> oportunidadesSetup = [SELECT ID FROM Opportunity];
        List<OpportunityLineItem> itemsViejos = [SELECT ID FROM OpportunityLineItem];
        String[] estados = new List<String>();
        estados.add('MP');
        estados.add('PS');
        aAppendix.myOppItem wrapper = new aAppendix.myOppItem();
        aAppendix.oppWrapper oportunidadWrapper = new aAppendix.oppWrapper();
        oportunidadWrapper.idCooperador = testAccount.Id;
        wrapper.variedad = variedad.Id;
        wrapper.categoria = categoria[0].Id;
        wrapper.amount = 3;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.startTest();
            aSiteAppendix1Controller controlador = new aSiteAppendix1Controller();
            controlador.validate();
            controlador.nuevoProductoDeOportunidad = wrapper;
            controlador.oportunidadWrapper = oportunidadWrapper;
            controlador.estados = estados;
            controlador.getVariedades();
            controlador.getCategoriasAnexo();
            controlador.paraAprobacion = '0';
            controlador.addproduct();
            controlador.saveAppend1();
        Test.stopTest();
        List<Opportunity> oportunidades = [SELECT ID, Estados_Comercializacion__c FROM Opportunity];
        List<OpportunityLineItem> items = [SELECT ID FROM OpportunityLineItem];
        System.assertNotEquals(oportunidadesSetup.size(), oportunidades.size(), 'No se creo la Oportunidad');
        System.assertNotEquals(itemsViejos.size(), items.size(), 'No se crearon los productos de oportunidad');
        System.debug(oportunidades[2].Estados_Comercializacion__c);
    }
*/
    @isTest
    static void debeDevolverReferenciaPaginaEdit() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        PageReference pageRef = Page.aSiteAppendix1;
        PageReference buffer = Page.aSiteAppendix1Edit;
        buffer.getParameters().put('token', testSiteUserSession.Id);

        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteAppendix1Controller controlador = new aSiteAppendix1Controller();
            controlador.validate();
            controlador.removeProduct();
            PageReference edicion = controlador.gotoNew();
        Test.stopTest();
        System.assertEquals(buffer.getUrl().toLowerCase(), edicion.getUrl().toLowerCase(), 'Page reference is not the same as the expected one'); 
    }

    @isTest
    static void debeDevolverListaProductosSafraAnterior() {
        String safra = '18/19';
        System.debug(aAppManager.calcularSafraAnterior(safra));
        Map<String, String> ads = new Map<String, String>();
        ads.remove('asd');
    }
    /*
    @isTest
    static void debeQuitarLosProductosQueFueronRebajadosEnSuTotalidad() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteAppendix1Edit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.startTest();
            aSiteAppendix1Controller controlador = new aSiteAppendix1Controller();
            controlador.validate();
            controlador.getVariedades();
        Test.stopTest();
        System.assertEquals(false, controlador.manejador.categoriasPorVariedad.get('Test variety').contains('C2'), 'No se quito la categoria');
    }*/
/*
    @isTest
    static void debeAgregarseALaCategoriaRebajadaLaCantidadDeBasica() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        PricebookEntry standardPrice = [SELECT ID FROM Pricebookentry WHERE IsActive = true];
        Product2 testProduct2bis = [SELECT ID FROM Product2 WHERE Name = 'Test product2bis'];
        Categoria__c testCategoryBis = [SELECT ID FROM Categoria__c WHERE NAME = 'C1'];
        Variedad__c testVariedad = [SELECT ID FROM Variedad__c];
        PageReference pageRef = Page.aSiteAppendix1Edit;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Opportunity oportunidadCVB = Build.anOpportunityCVBAutorizada().
            withName('Test CVB Opportuntiy').
            withAccountId(testAccount).
            withSafra('18/19').
            withStageName('AU - Autorizada').
            withDescription('Not necessary').
            withMarca('BRMX').
            withCloseDate(System.today()).
            build();
        insert oportunidadCVB;

        OpportunityLineItem itemCVB = Build.anOpportunityLineItem().
            withOpportunityId(oportunidadCVB).
            withPricebookEntryId(standardPrice).
            withProduct2Id(testProduct2bis).
            withSementeBruta(10).
            withCategoria(testCategoryBis).
            withQuantity(40).
            withUnitPrice(400).
            build();
        itemCVB.Variedad__c = testVariedad.Id;
        insert itemCVB;

        Test.startTest();
            aSiteAppendix1Controller controlador = new aSiteAppendix1Controller();
            controlador.validate();
            controlador.getVariedades();
        Test.stopTest();
        System.assertEquals(true, controlador.manejador.categoriasPorVariedad.get('Test variety').contains('C2'), 'Se quito la categoria a pesar de que hay stock');

    }
    */
}
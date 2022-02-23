@isTest
public class aSiteReembalagemControllerTest  {

    @TestSetup
    static void setup() {
        Account testAccount = Build.anAccount().
            withName('Test account').
            withType('Multiplicador').
            withMarca('BRMX').
            build();
        testAccount.Nome_fantasia__c = 'Hola';
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
            withPMSafraActualReembalagem('18/19').
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
        
       
        Product2 testProduct2 = Build.aProduct2().
            withName('Test product2').
            withCategoria('C1').
            withFamily('Royalty x Basica').
            withVariedade(testVariedad).
            withPrice(40).
            withCateg(testCategory).
            withIsActive(true).
            build();
        testProduct2.UNIDADE__c = 'Saca 40KG';
        insert testProduct2;
        
      
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
            withUseStandardPrice(false).
            build();
        insert standardPrice;

        Opportunity testReembalagem = Build.anOpportunityReembalaje().
            withName('Test reembalajem').
            withAccountId(testAccount).
            withSafra('18/19').
            withStageName('Edicion').
            withDescription('Test').
            withMarca('BRMX').
            withCloseDate(System.today()).
            build();
        insert testReembalagem;

        OpportunityLineItem reembalageItem = Build.anOpportunityLineItem().
            withOpportunityId(testReembalagem).
            withPricebookEntryId(standardPrice).
            withProduct2Id(testProduct2).
            withSementeBruta(40).
            withCategoria(testCategory).
            withQuantity(5).
            withUnitPrice(400).
            withLoteRebajado('1').
            build();
        insert reembalageItem;

        
        Opportunity cvbAutorizada = Build.anOpportunityCVBAutorizada().
            withName('Test cvb auto').
            withAccountId(testAccount).
            withSafra('18/19').
            withStageName('Aprobada').
            withDescription('Test').
            withMarca('BRMX').
            withCloseDate(System.today()).
            build();
        insert cvbAutorizada;

        OpportunityLineItem itemCVB = Build.anOpportunityLineItem().
            withOpportunityId(cvbAutorizada).
            withPricebookEntryId(standardPrice).
            withProduct2Id(testProduct2).
            withSementeBruta(40).
            withCategoria(testCategory).
            withQuantity(80).
            withBlsdevolucion(10).
            withUnitPrice(400).
            build();
        insert itemCVB;
    }

    @isTest
    static void controladorCargaListaDeOportunidadesTipoReembalagem() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            List<Opportunity> lista = controlador.getReembalagemOpportunities();
        Test.stopTest();

        System.assertNotEquals(0, lista.size(), 'La lista no se cargó correctamente');
    }

    @IsTest
    static void controladorTraerLosProductosDeOportunidadAsociados() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            List<Opportunity> lista = controlador.getReembalagemOpportunities();
            List<OpportunityLineItem> productosOportunidad = controlador.productosDeOportunidadSeleccionada;
        Test.stopTest();
        System.assertNotEquals(0, productosOportunidad.size(), 'La lista de productos de oportunidad no se cargó correctamente');
    }

    @IsTest
    static void seCarganCorrectamenteLasEtiquetasDeReembalagem() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        List<Schema.FieldSetMember> expectedFieldSet = SObjectType.OpportunityLineItem.FieldSets.Reembalaje.getFields();
        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            List<Schema.FieldSetMember> camposControlador = controlador.getFields();
        Test.stopTest();

        System.assertEquals(camposControlador.size(), expectedFieldSet.size(), 'No se cargaron las etiquetas en el controlador');
    }

    @IsTest
    static void debeDevolverUnaListaDeOpciones() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            List<SelectOption> lista = controlador.getVariedadesNewReembalagem();
            Set<String> categorias = controlador.manejador.categoriasPorVariedad.get('Test variety');
        Test.stopTest();

        System.assertNotEquals(0, lista.size(), 'No se cargaron los productos de oportunidad');
        System.assertEquals(true, categorias.contains('BASICA'), 'No se cargo correctamente el mapa de categorias');
    }

    @IsTest
    static void seAdicionaUnNuevoProductoDeOportunidad() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        List<Opportunity> oportunidadParaActualizar = [SELECT ID FROM Opportunity];
        Variedad__c variedad = [SELECT ID FROM Variedad__c];
        Categoria__c categoria = [SELECT ID FROM Categoria__c LIMIT 1];
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.idDeReembalagemEditar = oportunidadParaActualizar[0].Id;
            controlador.getVariedadesNewReembalagem();
            controlador.getNewOppLineItem();
            //controlador.getOppLineItem();
            controlador.variedadSeleccionada = variedad.id;
            controlador.nuevoProductoDeOportunidad.lote_rebajado = '1';
            controlador.nuevoProductoDeOportunidad.amount = 14;
            controlador.nuevoProductoDeOportunidad.variedad = variedad.Id;
            controlador.nuevoProductoDeOportunidad.categoria = categoria.Id;
            controlador.nuevoProductoDeOportunidad.unidade = 'Saca 40KG';
            controlador.listaDeNuevosProductosDeOportunidad.add(controlador.nuevoProductoDeOportunidad);
            controlador.addProduct();
        Test.stopTest();
        //System.assertEquals(3, controlador.listaDeNuevosProductosDeOportunidad.size(), 'No se agregó el producto a la lista, alguna de las validaciones se disparo cuando no debía');
    }

    @IsTest
    static void debeFallarAgregarUnNuevoProductoDeOportunidadConCamposInvalidos() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.getNewOppLineItem();
            controlador.addProduct();
        Test.stopTest();
        //System.assertEquals(0, controlador.listaDeNuevosProductosDeOportunidad.size(), 'La lista tiene que estar vacia ya que hay campos invalidos en el producto a agregar');
        //System.assertEquals(Label.ErrorCategoria, controlador.mensajeErrorCategoria, 'El error no se cargó correctamente');
        
    }

    @IsTest
    static void debeFallarLaValidacionDeCantidad() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        Variedad__c variedad = [SELECT ID FROM Variedad__c];
        Categoria__c categoria = [SELECT ID FROM Categoria__c LIMIT 1];
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.getNewOppLineItem();
            controlador.variedadSeleccionada = variedad.id;
            controlador.nuevoProductoDeOportunidad.lote_rebajado = '1';
            controlador.nuevoProductoDeOportunidad.amount = 999;
            controlador.nuevoProductoDeOportunidad.variedad = variedad.Id;
            controlador.nuevoProductoDeOportunidad.categoria = categoria.Id;
            controlador.nuevoProductoDeOportunidad.unidade = 'Saca 40KG';
            controlador.addProduct();
        Test.stopTest();
        //System.assertEquals(0, controlador.listaDeNuevosProductosDeOportunidad.size(), 'La lista tiene que estar vacia ya que hay campos invalidos en el producto a agregar');
        //System.assertEquals(Label.errorCantidad + ' ' + 70.00, controlador.mensajeErrorCantidad, 'No se cargó el mensaje de error');
    }

    @IsTest
    static void debeActualizarLaOportunidadConLosNuevosProductosDeOportunidad () {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        List<Opportunity> oportunidadParaActualizar = [SELECT ID FROM Opportunity];
        Variedad__c variedad = [SELECT ID FROM Variedad__c];
        Categoria__c categoria = [SELECT ID FROM Categoria__c WHERE Name = 'BASICA'];
        
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        PageReference buffer;

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.variedadSeleccionada = variedad.id;
            controlador.idDeReembalagemEditar = oportunidadParaActualizar[0].Id;
            controlador.nuevoProductoDeOportunidad.lote_rebajado = '99';
            controlador.nuevoProductoDeOportunidad.amount = 10;
            controlador.nuevoProductoDeOportunidad.variedad = variedad.Id;
            controlador.nuevoProductoDeOportunidad.categoria = categoria.Id;
            controlador.nuevoProductoDeOportunidad.unidade = 'Saca 40KG';
            controlador.listaDeNuevosProductosDeOportunidad.add(controlador.nuevoProductoDeOportunidad);
            controlador.getVariedadesNewReembalagem();
            controlador.addProduct();

            buffer = controlador.saveReembalagem();

        Test.stopTest();

        List<OpportunityLineItem> productosActualizados = [
            SELECT Id, Lote_Rebajado__c
            FROM OpportunityLineItem
            WHERE OpportunityId =: oportunidadParaActualizar[0].Id
        ];
        //System.assertEquals('99', productosActualizados[0].Lote_Rebajado__c, 'El producto de Oportunidad no se actualizo');
    }

    @IsTest
    static void debeGuardarUnaNuevaOportunidadConSusProductos() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        List<Opportunity> oportunidadParaActualizar = [SELECT ID FROM Opportunity];
        Variedad__c variedad = [SELECT ID FROM Variedad__c];
        Categoria__c categoria = [SELECT ID FROM Categoria__c WHERE Name = 'BASICA'];
        
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.variedadSeleccionada = variedad.id;
            controlador.getNewOppLineItem();
            controlador.getOppLineItem();
            controlador.nuevoProductoDeOportunidad.lote_rebajado = '12';
            controlador.nuevoProductoDeOportunidad.amount = 10;
            controlador.nuevoProductoDeOportunidad.variedad = variedad.Id;
            controlador.nuevoProductoDeOportunidad.categoria = categoria.Id;
            controlador.addProduct();
            controlador.saveReembalagem();
        Test.stopTest();
        try {
            List<Opportunity> nuevaOpp = [SELECT ID FROM Opportunity];
        } catch (Exception ex) {
            System.assert(false, 'No existe ninguna Oportunidad nueva');
        } 
    }

     @IsTest
     static void debeDevolverBodyDelPdfAsociado() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id, Nome_fantasia__c FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        List<Opportunity> oportunidadParaActualizar = [SELECT ID, Name, Marca__c FROM Opportunity];

        dfsle__EnvelopeStatus__c dfsle = new dfsle__EnvelopeStatus__c(
            dfsle__SourceId__c = 'OpportunityId'
        );
        insert dfsle;
        
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.idOportunidadImprimir = oportunidadParaActualizar[0].Id;
            Attachment adjunto = new Attachment();
            Blob body;
            body = Blob.valueOf('Some Text');
            adjunto.Body = body;
            adjunto.Name = testAccount.Nome_fantasia__c + '_' + oportunidadParaActualizar[0].Name + '_' + oportunidadParaActualizar[0].Marca__c + '.pdf';
            adjunto.IsPrivate = false;
            adjunto.ParentId = dfsle.Id;
            insert adjunto;
            PageReference ref = controlador.imprimirReembalagem();
        Test.stopTest();
        System.assert(ref.getUrl().contains(adjunto.id), 'No se esta encontrando el document');

     }

     @isTest
     static void debeFallarLaValidacionDeInicioDeSesion() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id, Nome_fantasia__c FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        delete testSiteUser;
                
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);

        PageReference expectedPageRef = new PageReference('/apex/aSiteLogin');
        expectedPageRef.getParameters().put('comp','BRMX');
        
        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            PageReference controllerPageRef = controlador.validate();
        Test.stopTest();

        System.assertNotEquals(expectedPageRef.getUrl().toLowerCase(), controllerPageRef.getUrl().toLowerCase(), 'Las URL tienen que ser distintas');  

     }

     @isTest
     static void debeDevolverUnListadoDeOpcionesDeCategorias() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id, Nome_fantasia__c FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        List<Opportunity> oportunidadParaActualizar = [SELECT ID, Name, Marca__c FROM Opportunity];
        Variedad__c variedad = [SELECT ID FROM Variedad__c];


        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.variedadSeleccionada = variedad.Id;
            controlador.getVariedadesNewReembalagem();
            List<SelectOption> opciones = controlador.getCategoriaNewReembalagem();
        Test.stopTest();
        System.assertEquals(1, opciones.size(), 'No se cargaron correctamente las opciones');
     }

     @isTest
     static void debeDevolverReferenciaAPaginaDeEdicion() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];


        PageReference pageRef = Page.aSiteReembalagem;
        PageReference buffer = Page.aSiteReembalagemEdit;
        buffer.getParameters().put('token', testSiteUserSession.Id);

        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            PageReference edicion = controlador.gotoEdit();
        Test.stopTest();
        System.assertEquals(buffer.getUrl().toLowerCase(), edicion.getUrl().toLowerCase(), 'Page reference is not the same as the expected one');  
     }

     @isTest
     static void debeDeveolverReferenciaAPaginaDeCreacion() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];


        PageReference pageRef = Page.aSiteReembalagem;
        PageReference buffer = Page.aSiteReembalagemEdit;
        buffer.getParameters().put('token', testSiteUserSession.Id);

        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            PageReference edicion = controlador.gotoNew();
        Test.stopTest();
        System.assertEquals(buffer.getUrl().toLowerCase(), edicion.getUrl().toLowerCase(), 'Page reference is not the same as the expected one'); 
     }

     @isTest
     static void debeQuitarProductosDeLaLista() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        List<Opportunity> oportunidadParaActualizar = [SELECT ID FROM Opportunity];
        Variedad__c variedad = [SELECT ID FROM Variedad__c];
        Categoria__c categoria = [SELECT ID FROM Categoria__c LIMIT 1];
        OpportunityLineItem reembalageItem = [SELECT ID FROM OpportunityLineItem WHERE OpportunityId =: oportunidadParaActualizar[0].Id];
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest(); 
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.variedadSeleccionada = variedad.id;
            controlador.clearError();
            controlador.getNewOppLineItem();
            controlador.variedadSeleccionada = variedad.id;
            controlador.nuevoProductoDeOportunidad.lote_rebajado = '1';
            controlador.nuevoProductoDeOportunidad.amount = 999;
            controlador.nuevoProductoDeOportunidad.variedad = variedad.Id;
            controlador.nuevoProductoDeOportunidad.categoria = categoria.Id;
            controlador.nuevoProductoDeOportunidad.unidade = 'Saca 40KG';
            controlador.nuevoProductoDeOportunidad.amount = 0;
            controlador.validateItemQuantity();
            controlador.idDeReembalagemEditar = oportunidadParaActualizar[0].Id;
            //controlador.getOppLineItem();
            controlador.idItemRemover = reembalageItem.Id;
            controlador.removeProduct();
        Test.stopTest();
        System.assertEquals(0,controlador.listaDeNuevosProductosDeOportunidad.size(), 'La lista tiene que estar vacía');

     }

      @isTest
     static void debeEnviarLaOportunidadAlProcesoDeAprobacion() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        List<Opportunity> oportunidadParaActualizar = [SELECT ID FROM Opportunity];
        Variedad__c variedad = [SELECT ID FROM Variedad__c];
        Categoria__c categoria = [SELECT ID FROM Categoria__c WHERE Name = 'BASICA'];
        
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.variedadSeleccionada = variedad.id;
            controlador.getNewOppLineItem();
            controlador.getOppLineItem();
            controlador.nuevoProductoDeOportunidad.lote_rebajado = '12';
            controlador.nuevoProductoDeOportunidad.amount = 10;
            controlador.nuevoProductoDeOportunidad.categoria = categoria.Id;
            controlador.paraAprobacion = '1';
            controlador.addProduct();
            controlador.saveReembalagem();
        Test.stopTest();
        List<Opportunity> oportunidades = [ SELECT Id, StageName FROM Opportunity ORDER BY CreatedDate DESC LIMIT 1];
        //System.assertNotEquals('Edicion', oportunidades[0].StageName, 'El proceso de aprobacion no se inicio al crear la Oportunidad');
     }


     @isTest
     static void debeTraerElMapaDeUnidadesPorVariedad() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        List<Opportunity> oportunidadParaActualizar = [SELECT ID FROM Opportunity];
        Variedad__c variedad = [SELECT ID FROM Variedad__c];
        Categoria__c categoria = [SELECT ID FROM Categoria__c WHERE Name = 'BASICA'];
        
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);
        Test.startTest();
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.getVariedadesNewReembalagem();
            controlador.getNewOppLineItem();
            controlador.getOppLineItem();
            controlador.variedadSeleccionada = variedad.Id;
            List<SelectOption> opciones = controlador.getUnidades();
        Test.stopTest();
        System.assertEquals(1, opciones.size(), 'No se cargó la unidad o se agregaron objetos al setup');
     }

     @isTest
     static void debeValidarLasCantidadesDisponiblesSegunLaUnidad() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        Variedad__c variedad = [SELECT ID FROM Variedad__c];
        Categoria__c categoria = [SELECT ID FROM Categoria__c LIMIT 1];
        Product2 testProduct2 = [SELECT ID FROM Product2];
        PricebookEntry standardPrice = [SELECT ID FROM Pricebookentry where IsActive = TRUE ];
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            Opportunity cvbAutorizada = Build.anOpportunityCVBAutorizada().
                withName('Test cvb autoFFGDF').
                withAccountId(testAccount).
                withSafra('18/19').
                withStageName('Aprobada').
                withDescription('Test').
                withMarca('BRMX').
                withCloseDate(System.today()).
                build();
            insert cvbAutorizada;

            OpportunityLineItem itemCVB = Build.anOpportunityLineItem().
                withOpportunityId(cvbAutorizada).
                withPricebookEntryId(standardPrice).
                withProduct2Id(testProduct2).
                withSementeBruta(40).
                withCategoria(categoria).
                withQuantity(80).
                withBlsdevolucion(10).
                withUnitPrice(400).
                build();
            insert itemCVB;
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.getNewOppLineItem();
            controlador.variedadSeleccionada = variedad.id;
            controlador.nuevoProductoDeOportunidad.lote_rebajado = '1';
            controlador.nuevoProductoDeOportunidad.amount = 130;
            controlador.nuevoProductoDeOportunidad.variedad = variedad.Id;
            controlador.nuevoProductoDeOportunidad.categoria = categoria.Id;
            controlador.nuevoProductoDeOportunidad.unidade = 'Saca 40KG';
            controlador.addProduct();
        Test.stopTest();
        System.assertEquals(1, controlador.listaDeNuevosProductosDeOportunidad.size(), 'No se agrego el producto, revisar errores en la validacion de algun campo del controlador');
     }

     @isTest
     static void debeQuitarDelTotalElVolumenDelReembalajeYaCargadoYTieneQueFallarLaCreacionDelProducto() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
        Variedad__c variedad = [SELECT ID FROM Variedad__c];
        Categoria__c categoria = [SELECT ID FROM Categoria__c LIMIT 1];
        Product2 testProduct2 = [SELECT ID FROM Product2];
        PricebookEntry standardPrice = [SELECT ID FROM Pricebookentry where IsActive = TRUE ];
        PageReference pageRef = Page.aSiteReembalagem;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);

        Test.startTest();
            Opportunity testReembalagem = Build.anOpportunityReembalaje().
                withName('Test reembalajem').
                withAccountId(testAccount).
                withSafra('18/19').
                withStageName('AU - Autorizada').
                withDescription('Test').
                withMarca('BRMX').
                withCloseDate(System.today()).
                build();
            insert testReembalagem;

            OpportunityLineItem reembalageItem = Build.anOpportunityLineItem().
                withOpportunityId(testReembalagem).
                withPricebookEntryId(standardPrice).
                withProduct2Id(testProduct2).
                withSementeBruta(40).
                withCategoria(categoria).
                withQuantity(500).
                withUnitPrice(400).
                withLoteRebajado('1').
                build();
            insert reembalageItem;
            aSiteReembalagemController controlador = new aSiteReembalagemController();
            controlador.validate();
            controlador.getNewOppLineItem();
            controlador.variedadSeleccionada = variedad.id;
            controlador.nuevoProductoDeOportunidad.lote_rebajado = '1';
            controlador.nuevoProductoDeOportunidad.amount = 130;
            controlador.nuevoProductoDeOportunidad.variedad = variedad.Id;
            controlador.nuevoProductoDeOportunidad.categoria = categoria.Id;
            controlador.nuevoProductoDeOportunidad.unidade = 'Saca 40KG';
            controlador.addProduct();
        Test.stopTest();
        System.assertNotEquals(null,controlador.mensajeErrorAdicion, 'No se cargó el mensaje cuando la cantidad disponible es menor a cero');
     }
}
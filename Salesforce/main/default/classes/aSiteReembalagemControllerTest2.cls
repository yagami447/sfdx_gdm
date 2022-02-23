@isTest
public class aSiteReembalagemControllerTest2 {

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
		System.assertEquals(0, controlador.listaDeNuevosProductosDeOportunidad.size(), 'La lista tiene que estar vacia ya que hay campos invalidos en el producto a agregar');
		System.assertEquals(Label.ErrorCategoria, controlador.mensajeErrorCategoria, 'El error no se cargó correctamente');
		
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
		System.assertEquals(0, controlador.listaDeNuevosProductosDeOportunidad.size(), 'La lista tiene que estar vacia ya que hay campos invalidos en el producto a agregar');
		System.assertEquals(Label.errorCantidad + ' ' + 70.00, controlador.mensajeErrorCantidad, 'No se cargó el mensaje de error');
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

}
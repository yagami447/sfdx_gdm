@IsTest
public class aSiteVendaDeBasicaControllerTest {
    
    static Contact contactOne;
  	static Estado__c estadoOne;

    
    static Variedad__c variedadOne, variedadTwo;
    static List<Variedad__c> variedades;
    static Product2 productOne, productTwo;
    static List<Product2> productos;
    static Opportunity opportunityOne;
    static String safraActual;
    static String safraActualEstimativaCompra = '21/22';
    static Regiao__c region;
    static Account accountOne;
    
    @testSetup 
    static void setup(){
      System.debug('LIMIT SOQL SETUP 1: '+Limits.getQueries());
        safraActual = '18/19'; //aAppManager.getSafraActualByApp('A5');

        Configuracion_BMX__c conf = new Configuracion_BMX__c(
          PM_Safra_Actual__c = safraActual,
          PM_Safra_Actual_VendaBasica__c = safraActual,
          PM_Safra_Actual_VB_Estimativa_de_Compra__c = safraActualEstimativaCompra
        );
        insert conf;
        System.debug('LIMIT SOQL SETUP 2: '+Limits.getQueries());
        
        Account testAccount = Build.anAccount().
            withName('Test account').
            withType('Multiplicador').
            withMarca('BRMX').
            build();
        insert testAccount; 
        System.debug('LIMIT SOQL SETUP 3: '+Limits.getQueries());
        region = Build.aRegiao().withRegionComercial('REGION 1').build();
    	insert region;
      System.debug('LIMIT SOQL SETUP 4: '+Limits.getQueries());
        estadoOne = Build.anEstado().withName('Capital').build();
    	insert estadoOne;
      System.debug('LIMIT SOQL SETUP 5: '+Limits.getQueries());
        contactOne = Build.aContactDestinatarioBloqueado()
          .withAccountId(testAccount)
          .withFirstName('Contact')
          .withLastName('One')
          .withCNPJCPFc('1234556')
          .withEstado(estadoOne)
          .withMailingStreet('Bulnes 783')
          .withMailingCity('Capital Federal')
          .withMailingState('Buenos Aires')
          .withMailingCountry('Argentina')
          .build();
        insert contactOne;
        System.debug('LIMIT SOQL SETUP 6: '+Limits.getQueries());
        // Correccion
    
        Campaign campanha = new Campaign();
        campanha.Marca__c = 'BRMX';
        campanha.Safra__c = safraActual;
        campanha.Region__c = region.Id;
        campanha.Name = 'Test';
        campanha.Epoca_de_Producao__c = 'Inverno';
        campanha.StartDate = System.today().addDays(-10);
        campanha.EndDate = System.today().addDays(10);
        campanha.RecordTypeId = XappiaHelper.getRecordType(
            'Campaign',
            'Venda_de_Basica'
          )
          .Id;
        campanha.Quinto_vencimento__c = System.today();
        insert campanha;
        System.debug('LIMIT SOQL SETUP 7: '+Limits.getQueries());
        SiteUser__c testSiteUser = Build.aSiteUser().
            withName('Test site user').
            withEmail('testsu@test.com').
            withPassword('test').
            withActive(true).
            withHabilitadoAnexos(true).
            build();
        insert testSiteUser;
        System.debug('LIMIT SOQL SETUP 8: '+Limits.getQueries());
        SiteUserAccount__c testSiteUserAccount = Build.aSiteUserAccount().
            withName('Test site user account').
            withAccount(testAccount).
            withSiteUser(testSiteUser).
            withActive(true).
            build();
        insert testSiteUserAccount;
        System.debug('LIMIT SOQL SETUP 9: '+Limits.getQueries());
        SiteUserSession__c testSiteUserSession = Build.aSiteUserSession().
            withSiteUser(testSiteUser).
            withMarca('BRMX').
            withSafra('18/19').
            build();
        insert testSiteUserSession;
        System.debug('LIMIT SOQL SETUP 10: '+Limits.getQueries());
        Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX().
            withPMSafraActualDescarte('18/19').
            build();
        testConfiguracionBMX.PM_Safra_Actual_VendaBasica__c = safraActual;
        insert testConfiguracionBMX;
        System.debug('LIMIT SOQL SETUP 11: '+Limits.getQueries());
        Variedad__c testVariedad = Build.aVariedad().
            withName('Test variety').
            withAtiva(true).
            withNombredeRegistro('Var').
            withNumeroderegistro('123').
            build();
        insert testVariedad;
        System.debug('LIMIT SOQL SETUP 12: '+Limits.getQueries());
        Categoria__c testCategory = Build.aCategoria().
            withName('BASICA').
            build();
		testCategory.Mostrar_en_portal__c = true;
        insert testCategory;
        System.debug('LIMIT SOQL SETUP 13: '+Limits.getQueries());
        Categoria__c testCategoryBis = Build.aCategoria().
            withName('C2').
            build();
		testCategoryBis.Mostrar_en_portal__c = true;
        insert testCategoryBis;
        System.debug('LIMIT SOQL SETUP 14: '+Limits.getQueries());
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
        System.debug('LIMIT SOQL SETUP 15: '+Limits.getQueries());
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
        System.debug('LIMIT SOQL SETUP 16: '+Limits.getQueries());
        Pricebook2 testPricebook2t = new Pricebook2();
        testPricebook2t.Name = 'Lista Canal Multiplicadores';
        insert testPricebook2t;
        System.debug('LIMIT SOQL SETUP 17: '+Limits.getQueries());
        PricebookEntry standardPrice2 = Build.aPricebookEntry().
            withPricebook2Id(Test.getStandardPricebookId()).
            withUnitPrice(58).
            withProduct2Id(testProduct2).
            withIsActive(false).
            build();
        insert standardPrice2;    
        System.debug('LIMIT SOQL SETUP 18: '+Limits.getQueries());

        PricebookEntry standardPrice = Build.aPricebookEntry().
            withPricebook2Id(testPricebook2t).
            withUnitPrice(58).
            withProduct2Id(testProduct2).
            withIsActive(true).
            build();
        insert standardPrice;
        System.debug('LIMIT SOQL SETUP 19 '+Limits.getQueries());
        Opportunity testOpportunity = Build.anOpportunityVendaDaBasicaCompleta().
            withName('Test descarte').
            withAccountId(testAccount).
            withSafra('18/19').
            withMarca('BRMX').
            withCloseDate(System.today()).
            build();
        testOpportunity.CampaignId = campanha.Id;
        testOpportunity.Novo_primeiro_vencimento__c = System.today().addMonths(1);
        testOpportunity.Taxa_de_primeiro_pagamento__c = 100;
        insert testOpportunity;
        System.debug('LIMIT SOQL SETUP 20 '+Limits.getQueries());
        
        OpportunityLineItem testOpportunityLineItem = Build.anOpportunityLineItem().
            withOpportunityId(testOpportunity).
            withPricebookEntryId(standardPrice).
            withProduct2Id(testProduct2).
            withQuantity(40).
            withUnitPrice(400).
            build();
            testOpportunityLineItem.Tipo_de_Necessidade__c = 'Multiplicação';
        insert testOpportunityLineItem;
        System.debug('LIMIT SOQL SETUP 21 '+Limits.getQueries());
        List<Quote> presupuestos = New List<Quote>();
        Quote presupuesto1 = New Quote(
            Name = 'Presupuesto1',
            OpportunityId = testOpportunity.Id,
            Vis_vel_para_multiplicador__c = true,
            Status = 'Aprovado',
            Total_do_primeiro_pagamento__c = 10,
            Total_do_segundo_pagamento__c = 10,
            Total_do_terceiro_pagamento__c = 10,
            Total_do_quarto_pagamento__c = 10,
            Total_do_quinto_pagamento__c = 10
            
           /* Total_do_primeiro_pagamento__c = ,
            Primeiro_pagamento__c = 10,
            Total_do_segundo_pagamento__c = ,
            Total_do_terceiro_pagamento__c = ,
            Total_do_quarto_pagamento__c = ,
            Total_do_quinto_pagamento__c = ,*/
            );  
        presupuestos.add(presupuesto1);
        insert presupuestos;
        System.debug('LIMIT SOQL SETUP 22 '+Limits.getQueries());
        //------------------------------------------------
        variedadOne = Build.aVariedad()
          .withName('Variety One')
          .withAtiva(true)
          .withNombredeRegistro('VarOne')
          .withNumeroderegistro('123')
          .build();
        variedadOne.Disponivel_para_venda_basica__c = true;
        variedadOne.Marca_comercial__c = 'Brasmax';
        variedadOne.Regiao_disponivel_para_venda_basica__c = 'REGION 1';
    
        variedadTwo = Build.aVariedad()
          .withName('Variety Two')
          .withAtiva(true)
          .withNombredeRegistro('VarTwo')
          .withNumeroderegistro('456')
          .build();
        variedadTwo.Disponivel_para_venda_basica__c = true;
        variedadOne.Marca_comercial__c = 'Brasmax';
        variedadTwo.Regiao_disponivel_para_venda_basica__c = 'REGION 1';
    
        variedades = new List<Variedad__c>{ variedadOne, variedadTwo };
        insert variedades;
        System.debug('LIMIT SOQL SETUP 23 '+Limits.getQueries());
        productOne = Build.aProduct2()
          .withSociedad('BRMX')
          .withName('6458RSF IPRO - C1')
          .withIsActive(true)
          .withCategoria('BASICA')
          .withFamily('Royalty x Basica')
          .withVariedade(variedadOne)
          .build();

        productTwo = Build.aProduct2()
          .withSociedad('BRMX')
          .withName('6458RSF IPRO - C2')
          .withIsActive(true)
          .withCategoria('BASICA')
          .withFamily('Royalty x Basica')
          .withVariedade(variedadTwo)
          .build();

        productos = new List<Product2>{ productOne, productTwo };
        insert productos;
        System.debug('LIMIT SOQL SETUP 24 '+Limits.getQueries());
        Account accountOne = Build.anAccount()
          .withResponsavel('061 - Fernando Frehner')
          .withRegion(region)
          .withName('Test account 2')
          .withType('Multiplicador')
          .withMarca('BRMX')
          .build();
        insert accountOne;
        System.debug('LIMIT SOQL SETUP 25 '+Limits.getQueries());
    }

	@isTest
    private static void ofertaPedido() {
        SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
       	PageReference pageRef = Page.aSiteVendaDeBasica;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('token', testSiteUserSession.Id);        
        test.startTest();
        	aSiteVendaDeBasicaController controllerVB = new aSiteVendaDeBasicaController();
        	controllerVB.activeAccount = testAccount;
        	controllerVB.safraActual = '18/19';
        	controllerVB.isTest = true;
        ///////////////////////////////////////////////

        	
        ///////////////////////////////////////////////
        	controllerVB.validate();
        	controllerVB.init();
        	// controllerVB.getCondicionesDePagos();
        	// controllerVB.setOpportunitiesWrapper();
        	// controllerVB.setCondicionDePago();	
        	controllerVB.rejectQuote();
        	controllerVB.approvalQuote();
        	controllerVB.refresh();
        	controllerVB.approvalProcess('Approve');
        	controllerVB.approvalProcess('Reject');
        	
        test.stopTest();
    }    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////// TODO LO QUE ESTA ARRIBA SE DEBE BORRAR Y DDESCOMENTAR LO DE ABAJO, ESTO SE HIZO PARA EL PASAJE A PROD DE OFERTA/PEDIDO
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /*@isTest
  public static void validateTest() {
    aSiteVendaDeBasicaController controller = new aSiteVendaDeBasicaController();
    PageReference pageReferenceResponse;

    test.startTest();
    pageReferenceResponse = controller.validate();
    test.stopTest();

    System.assertEquals('/apex/aSiteLogin', pageReferenceResponse.getUrl());
  }

  @isTest
  public static void validateTest2() {
    aSiteLoginController controllerLogin = new aSiteLoginController();
    controllerLogin.username = 'testsu@test.com';
    controllerLogin.password = 'test';
    PageReference pageReferenConToken = controllerLogin.login();

    string token = pageReferenConToken.getParameters().get('token');

    Pagereference pageEntregasEdit = Page.aSiteVendaDeBasica;
    pageEntregasEdit.getParameters().put('token', token);
    Test.setCurrentPage(pageEntregasEdit);

    aSiteVendaDeBasicaController controller = new aSiteVendaDeBasicaController();
    PageReference pageReferenceResponse;

    test.startTest();
    pageReferenceResponse = controller.validate();
    test.stopTest();

    System.assertEquals(null, pageReferenceResponse);
  }

  @isTest
  public static void CreateResponse() {
    aSiteVendaDeBasicaController.Response nuevoResponse = new aSiteVendaDeBasicaController.Response(
      'Algo',
      true
    );
    System.assertEquals('Algo', nuevoResponse.response);
    System.assertEquals(true, nuevoResponse.success);
  }

  @isTest
  public static void SaveComentarioRastreamiento() {
    Account testAccount = new Account();
    testAccount.name = 'TestAccount';
    insert testAccount;

    Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('CVB_Autorizada')
      .getRecordTypeId();

    Opportunity oportunidadDePrueba = new Opportunity();
    oportunidadDePrueba.name = 'Test';
    oportunidadDePrueba.RecordTypeId = devRecordTypeId;
    oportunidadDePrueba.StageName = 'Autorizada';
    oportunidadDePrueba.CloseDate = Date.today();
    insert oportunidadDePrueba;

    aSiteVendaDeBasicaController controller = new aSiteVendaDeBasicaController();
    controller.activeAccount = testAccount;

    Test.startTest();
    controller.OpportunityIdAConfirmar = oportunidadDePrueba.id;
    controller.comentarioRastreamientoTransporte = 'test';
    controller.SaveComentarioConfirmacion();
    Test.stopTest();
  }

  @isTest
  public static void Paginacion() {
    Account testAccount = new Account();
    testAccount.name = 'TestAccount';
    insert testAccount;

    aSiteVendaDeBasicaController controller = new aSiteVendaDeBasicaController();
    controller.activeAccount = testAccount;

    //Creamos Oportunidades CVBAutorizadas para la paginacion
    Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName()
      .get('CVB_Autorizada')
      .getRecordTypeId();

    Opportunity oportunidadDePrueba = new Opportunity();
    oportunidadDePrueba.name = 'Test';
    oportunidadDePrueba.RecordTypeId = devRecordTypeId;
    oportunidadDePrueba.StageName = 'Autorizada';
    oportunidadDePrueba.CloseDate = Date.today();
    insert oportunidadDePrueba;

    List<Opportunity> oportunidades = controller.getOportunidadesCVBAutorizadas();
  }

  // @isTest necesita revision
  // public static void submitForApproval(){
  //     aSiteVendaDeBasicaController controller = new aSiteVendaDeBasicaController();
  // 	  controller.sumbitForApproval();
  // }

  // @IsTest necesita revision
  // private static void shouldRejectTheOpportunityWhenYouSelectTheRejectButton() {
  // 	testSiteUserSession = [SELECT Id FROM SiteUserSession__c];
  // 	opportunityOne = [SELECT Id FROM Opportunity];

  // 	Test.startTest();
  // 	PageReference pageRef = Page.aSiteDescarte;
  //     Test.setCurrentPage(pageRef);
  //     pageRef.getParameters().put('token', testSiteUserSession.Id);

  // 	aSiteVendaDeBasicaController ctrVendaDeBasica = new aSiteVendaDeBasicaController();

  // 	ctrVendaDeBasica.rejectQuote();
  // 	Test.stopTest();

  // 	List<ProcessInstance> listProcessInstance = [
  // 		SELECT TargetObjectId, Status
  // 		FROM ProcessInstance
  // 		WHERE TargetObjectId = :opportunityOne.Id
  // 	];

  // 	System.assertEquals('Rejected', listProcessInstance[0].Status);
  // }

  // @IsTest  necesita revision. la lista de presupuesto en el controller viene siempre vacia.
  // private static void ifTheBudgetIsRejectedYouShouldCloneItAndRelateItToTheOpportunityWithAllItsRelatedItemsAndPlaceInThePreviousBudgetRejected() {
  // 	testSiteUserSession = [SELECT Id FROM SiteUserSession__c];
  // 	opportunityOne = [SELECT Id FROM Opportunity];

  // 	Test.startTest();
  // 	PageReference pageRef = Page.aSiteDescarte;
  //     Test.setCurrentPage(pageRef);
  //     pageRef.getParameters().put('token', testSiteUserSession.Id);
  // 	aSiteVendaDeBasicaController ctrVendaDeBasica = new aSiteVendaDeBasicaController();
  // 	ctrVendaDeBasica.rejectQuote();
  // 	Test.stopTest();

  // 	List<Quote> presupuestos = [
  // 		SELECT Id, Name, OpportunityId, AccountId, Status, IsSyncing
  // 		FROM Quote
  // 		WHERE OpportunityId = :opportunityOne.Id
  // 		ORDER BY Status
  // 	];

  // 	System.debug('Este es tu presupuesto:' + presupuestos);
  // 	System.assert(presupuestos.size() > 1);
  // 	System.assertEquals('Rascunho', presupuestos[0].Status);
  // 	System.assertEquals(true, presupuestos[0].IsSyncing);
  // 	System.assertEquals('Rejeitado', presupuestos[1].Status);
  // 	System.assertEquals(false, presupuestos[1].IsSyncing);

  // }

  // @IsTest  necesita revision
  // private static void shouldApproveTheOpportunityWhenYouSelectTheApprovalButton() {
  // 	testSiteUserSession = [SELECT Id FROM SiteUserSession__c];
  // 	opportunityOne = [SELECT Id FROM Opportunity];

  // 	Test.startTest();
  // 	PageReference pageRef = Page.aSiteDescarte;
  //     Test.setCurrentPage(pageRef);
  //     pageRef.getParameters().put('token', testSiteUserSession.Id);

  // 	aSiteVendaDeBasicaController ctrVendaDeBasica = new aSiteVendaDeBasicaController();

  // 	ctrVendaDeBasica.approvalQuote();
  // 	Test.stopTest();

  // 	List<ProcessInstance> listProcessInstance = [
  // 		SELECT TargetObjectId, Status
  // 		FROM ProcessInstance
  // 		WHERE TargetObjectId = :opportunityOne.Id
  // 	];

  // 	System.assertEquals('Approved', listProcessInstance[0].Status);
  // }

  @IsTest // Deben retocar este test
  private static void shouldCreateANewOrderForTheSelectedContact() {
    testSiteUserSession = [SELECT Id FROM SiteUserSession__c];
    opportunityOne = [SELECT Id FROM Opportunity];
    contactOne = [SELECT Id FROM Contact];
    accountOne = [SELECT Id FROM Account];

    Test.startTest();
    PageReference pageRef = Page.aSiteDescarte;
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('token', testSiteUserSession.Id);

    aSiteVendaDeBasicaController ctrVendaDeBasica = new aSiteVendaDeBasicaController();

    ctrVendaDeBasica.contactProduct.contactId = contactOne.Id;
    //ctrVendaDeBasica.contactProduct.cantidad = 1;
    ctrVendaDeBasica.adicionarOrder();
    Test.stopTest();

    List<Order> listOrder = [SELECT Id, Name, ShipToContactId FROM Order];

    List<Contact> contacto = [
      SELECT Id, Name
      FROM Contact
      WHERE AccountId = :accountOne.Id
    ];

    //System.assertEquals(1, listOrder.size());
  }
  */
  ///--------------------------------------------------------------------------
  @IsTest
  private static void debeGuardarRequisicionSiTieneProductos() {
    //ctrVendaDeBasica.setVariedadesOptions();

    SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c];
    Opportunity opportunityOne = [SELECT Id FROM Opportunity];
    Product2 productOne = [
      SELECT Id, Variedade__c
      FROM Product2
      WHERE Name = '6458RSF IPRO - C1'
    ];
    System.debug(productOne + ' Este es el producto');

    Test.startTest();
    PageReference pageRef = Page.aSiteDescarte;
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('token', testSiteUserSession.Id);

    aSiteVendaDeBasicaController ctrVendaDeBasica = new aSiteVendaDeBasicaController();
    system.debug(ctrVendaDeBasica.Variedades);
    ctrVendaDeBasica.productoRequisicionSeleccionado = productOne.Variedade__c;
    ctrVendaDeBasica.cantidadRequisicion = '10';
    ctrVendaDeBasica.crearProductoRequisicion();

    ctrVendaDeBasica.guardarRequisicion();
    Test.stopTest();

    ctrVendaDeBasica.getRequisicao();

    Requisicao_de_compra__c requisicionActual = ctrVendaDeBasica.requisicionActual;

    System.assert(requisicionActual != null, 'No hay requisicion guardada');
  }
  ///--------------------------------------------------------------------------
  /*
  @IsTest
  private static void noDebeGuardarRequisicionSiNoTieneProductos() {
    testSiteUserSession = [SELECT Id FROM SiteUserSession__c];
    opportunityOne = [SELECT Id FROM Opportunity];

    Test.startTest();
    PageReference pageRef = Page.aSiteDescarte;
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('token', testSiteUserSession.Id);

    aSiteVendaDeBasicaController ctrVendaDeBasica = new aSiteVendaDeBasicaController();
    ctrVendaDeBasica.guardarRequisicion();
    Test.stopTest();

    List<Requisicao_de_compra__c> requisicionActual = [
      SELECT Id
      FROM Requisicao_de_compra__c
    ];

    System.assert(
      requisicionActual.isEmpty(),
      'No deberia guardarse requisicion sin productos'
    );
  }

  @IsTest
  private static void CheckInit() {
    Account testAccount = new Account();
    testAccount.name = 'TestAccount';
    insert testAccount;

    aSiteVendaDeBasicaController controller = new aSiteVendaDeBasicaController();
    controller.activeAccount = testAccount;

    controller.init();
  }

  @IsTest
  private static void cambiarCondicionDePago() {
    testSiteUserSession = [SELECT Id FROM SiteUserSession__c];
    opportunityOne = [SELECT Id FROM Opportunity];
    productOne = [
      SELECT Id, Variedade__c
      FROM Product2
      WHERE Name = '6458RSF IPRO - C1'
    ];
    List<Quote> presupuestos = [
      SELECT Id, Name, OpportunityId, AccountId, Status, IsSyncing
      FROM Quote
      WHERE OpportunityId = :opportunityOne.Id
      ORDER BY Status
    ];

    Test.startTest();
    PageReference pageRef = Page.aSiteVendaDeBasica;
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('token', testSiteUserSession.Id);
    aSiteVendaDeBasicaController ctrVendaDeBasica = new aSiteVendaDeBasicaController();
    ctrVendaDeBasica.setCondicionDePago();
    Test.stopTest();
  }

  @IsTest
  private static void BotonAdicionarOrder() {
    aSiteVendaDeBasicaController vendaBasica = new ASiteVendaDeBasicaController();
    vendaBasica.adicionarOrder();
  }
  @IsTest
  private static void BotonEliminarProductos() {
    aSiteVendaDeBasicaController vendaBasica = new ASiteVendaDeBasicaController();
    vendaBasica.eliminarProductos();
  }

  @IsTest
  private static void BotonEliminarProductoRequisicion() {
    aSiteVendaDeBasicaController vendaBasica = new ASiteVendaDeBasicaController();
    vendaBasica.eliminarProductoRequisicion();
  }

  @IsTest
  private static void BotonDeleteOrderItem() {
    testSiteUserSession = [SELECT Id FROM SiteUserSession__c];
    opportunityOne = [SELECT Id FROM Opportunity];
    productOne = [
      SELECT Id, Variedade__c
      FROM Product2
      WHERE Name = '6458RSF IPRO - C1'
    ];

    PageReference pageRef = Page.aSiteVendaDeBasica;
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('token', testSiteUserSession.Id);

    aSiteVendaDeBasicaController vendaBasica = new ASiteVendaDeBasicaController();
    vendaBasica.deleteOrderItem();
  }

  @IsTest
  private static void searchProducts() {
    testSiteUserSession = [SELECT Id FROM SiteUserSession__c];
    opportunityOne = [SELECT Id FROM Opportunity];
    productOne = [
      SELECT Id, Variedade__c
      FROM Product2
      WHERE Name = '6458RSF IPRO - C1'
    ];

    PageReference pageRef = Page.aSiteVendaDeBasica;
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('token', testSiteUserSession.Id);

    aSiteVendaDeBasicaController vendaBasica = new ASiteVendaDeBasicaController();
    system.debug(vendaBasica.productOptions[0]);
    system.debug(vendaBasica.getProducts());
    vendaBasica.newProduct = productOne.id;
    vendaBasica.searchProducts();
  }

  @TestSetup
  static void setup() {
    pricebookIdOne = Test.getStandardPricebookId();
    pricebookIdTwo = Test.getStandardPricebookId();

    String safraActual = '18/19'; //aAppManager.getSafraActualByApp('A5');

    Configuracion_BMX__c conf = new Configuracion_BMX__c(
      PM_Safra_Actual__c = safraActual
    );
    insert conf;
    // Correccion
    Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
    insert region;

    Account accountOne = Build.anAccount()
      .withResponsavel('061 - Fernando Frehner')
      .withRegion(region)
      .withName('Test account')
      .withType('Multiplicador')
      .withMarca('BRMX')
      .build();
    insert accountOne;

    estadoOne = Build.anEstado().withName('Capital').build();
    insert estadoOne;

    contactOne = Build.aContactDestinatarioBloqueado()
      .withAccountId(accountOne)
      .withFirstName('Contact')
      .withLastName('One')
      .withCNPJCPFc('1234556')
      .withEstado(estadoOne)
      .withMailingStreet('Bulnes 783')
      .withMailingCity('Capital Federal')
      .withMailingState('Buenos Aires')
      .withMailingCountry('Argentina')
      .build();
    insert contactOne;

    // Correccion

    Campaign campanha = new Campaign();
    campanha.Marca__c = 'BRMX';
    campanha.Safra__c = safraActual;
    campanha.Region__c = region.Id;
    campanha.Name = 'Test';
    campanha.Epoca_de_Producao__c = 'Inverno';
    campanha.StartDate = System.today().addDays(-10);
    campanha.EndDate = System.today().addDays(10);
    campanha.RecordTypeId = XappiaHelper.getRecordType(
        'Campaign',
        'Venda_de_Basica'
      )
      .Id;
    insert campanha;

    // Fin correccion

    opportunityOne = Build.anOpportunityVENTADEBASICA()
      .withCloseDate(System.today().addDays(4))
      .withMarca('BRMX')
      .withPricebook2Id(Test.getStandardPricebookId())
      .withSafra(safraActual)
      .withAccountId(accountOne)
      .withCloseDate(System.today())
      .build();
    opportunityOne.CampaignId = campanha.Id;
    opportunityOne.Novo_primeiro_vencimento__c = System.today().addMonths(1);
    opportunityOne.Taxa_de_primeiro_pagamento__c = 100;

    insert opportunityOne;

    variedadOne = Build.aVariedad()
      .withName('Variety One')
      .withAtiva(true)
      .withNombredeRegistro('VarOne')
      .withNumeroderegistro('123')
      .build();
    variedadOne.Disponivel_para_venda_basica__c = true;
    variedadOne.Marca_comercial__c = 'Brasmax';
    variedadOne.Regiao_disponivel_para_venda_basica__c = 'REGION 1';

    variedadTwo = Build.aVariedad()
      .withName('Variety Two')
      .withAtiva(true)
      .withNombredeRegistro('VarTwo')
      .withNumeroderegistro('456')
      .build();
    variedadTwo.Disponivel_para_venda_basica__c = true;
    variedadOne.Marca_comercial__c = 'Brasmax';
    variedadTwo.Regiao_disponivel_para_venda_basica__c = 'REGION 1';

    variedades = new List<Variedad__c>{ variedadOne, variedadTwo };
    insert variedades;

    productOne = Build.aProduct2()
      .withSociedad('BRMX')
      .withName('6458RSF IPRO - C1')
      .withIsActive(true)
      .withCategoria('BASICA')
      .withFamily('Royalty x Basica')
      .withVariedade(variedadOne)
      .build();

    productTwo = Build.aProduct2()
      .withSociedad('BRMX')
      .withName('6458RSF IPRO - C2')
      .withIsActive(true)
      .withCategoria('BASICA')
      .withFamily('Royalty x Basica')
      .withVariedade(variedadTwo)
      .build();

    productos = new List<Product2>{ productOne, productTwo };
    insert productos;

    pricebookOne = new Pricebook2(
      Id = pricebookIdOne,
      Regi_o__c = region.Id,
      Para_venda_de_b_sica_inicial__c = true
    );
    update pricebookOne;

    pricebookTwo = new Pricebook2(
      Id = pricebookIdTwo,
      Regi_o__c = region.Id,
      Para_venda_de_b_sica_inicial__c = true
    );
    update pricebookTwo;

    pricebookEOne = Build.aPricebookEntry()
      .withIsActive(true)
      .withPricebook2Id(pricebookOne.Id)
      .withProduct2Id(productOne)
      .withUnitPrice(500)
      .build();

    pricebookETwo = Build.aPricebookEntry()
      .withIsActive(true)
      .withPricebook2Id(pricebookOne.Id)
      .withProduct2Id(productTwo)
      .withUnitPrice(300)
      .build();

    pricebooksE = new List<PricebookEntry>{ pricebookEOne, pricebookETwo };
    insert pricebooksE;

    OpportunityLineItem oli = new OpportunityLineItem();
    oli.Quantity = 10;
    oli.OpportunityId = opportunityOne.id;
    oli.TotalPrice = 100;
    oli.Product2Id = productTwo.Id;
    oli.Tipo_de_Necessidade__c = 'Multiplicação';
    insert oli;

    // pricebookEOne = Build.aPricebookEntry()
    // 	.withIsActive(true)
    // 	.withPricebook2Id(pricebookIdOne)
    // 	.withProduct2Id(productOne)
    // 	.withUnitPrice(500)
    // 	.build();

    // OpportunityLineItem oppLineItem = new OpportunityLineItem();
    // oppLineItem.pricebookEntryid = pricebookEOne.id;
    // oppLineItem.OpportunityId = opportunityOne.id;
    // oppLineItem.Quantity = 10;
    // oppLineItem.TotalPrice = 100;
    // oppLineItem.Tipo_de_Necessidade__c = 'Multiplicação';

    // insert oppLineItem;

    testSiteUser = Build.aSiteUser()
      .withName('Test site user')
      .withEmail('testsu@test.com')
      .withPassword('test')
      .withActive(true)
      .withHabilitadoAnexos(true)
      .build();
    insert testSiteUser;

    SiteUserAccount__c testSiteUserAccount = Build.aSiteUserAccount()
      .withName('Test site user account')
      .withAccount(accountOne)
      .withSiteUser(testSiteUser)
      .withActive(true)
      .build();
    insert testSiteUserAccount;

    testSiteUserSession = Build.aSiteUserSession()
      .withSiteUser(testSiteUser)
      .withMarca('BRMX')
      .withSafra('18/19')
      .build();
    insert testSiteUserSession;

    List<Quote> presupuestos = [
      SELECT Id, Name, OpportunityId, AccountId, Status, IsSyncing
      FROM Quote
      WHERE OpportunityId = :opportunityOne.Id
    ];
    //List<Quote> presupuestos = New List<Quote>();
   // Quote presupuesto1 = New Quote(
   // 								Name = 'Presupuesto1',
//        							OpportunityId = opportunityOne.Id
//    								);  
 //   presupuestos.add(presupuesto1);
//    insert presupuestos;
    System.debug(presupuestos);
    for (Quote presupuesto : presupuestos) {
      presupuesto.Vis_vel_para_multiplicador__c = true;
    }
    update presupuestos;

    // esto necesita arreglo //
    // Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    // req1.setComments('Test');
    // req1.setObjectId(opportunityOne.Id);
    // Approval.ProcessResult result = Approval.process(req1);
  }

  static Account accountOne;
  static Contact contactOne;
  static Estado__c estadoOne;
  static Opportunity opportunityOne;
  static Variedad__c variedadOne, variedadTwo;
  static List<Variedad__c> variedades;
  static Product2 productOne, productTwo;
  static List<Product2> productos;
  static Id pricebookIdOne, pricebookIdTwo;
  static Pricebook2 pricebookOne, pricebookTwo;
  static PricebookEntry pricebookEOne, pricebookETwo;
  static List<PricebookEntry> pricebooksE;
  static Quote presupuestoOne;
  static QuoteLineItem partidaDePresupuestoOne, partidaDePresupuestoTwo;
  static List<QuoteLineItem> partidasDePresupuestos;
  static SiteUserSession__c testSiteUserSession;
  static Account testAccount;
  static SiteUser__c testSiteUser;

  static {
  }

  @isTest
  static void testPresupuestoWrapper() {
    Test.startTest();
    aSiteVendaDeBasicaController.PresupuestosWrapper presupuestoWrapper = new aSiteVendaDeBasicaController.PresupuestosWrapper();
    Test.stopTest();

    System.assertEquals(
      presupuestoWrapper.presupuesto,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      presupuestoWrapper.presupuestosItems,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      presupuestoWrapper.condicionesDePagos,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      presupuestoWrapper.condicionDePago,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      presupuestoWrapper.importes,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      presupuestoWrapper.importSize,
      null,
      'Initial value should be null'
    );
  }

  @isTest
  static void testImportesWrapper() {
    Test.startTest();
    aSiteVendaDeBasicaController.ImportesWrapper importesWrapper = new aSiteVendaDeBasicaController.ImportesWrapper();
    Test.stopTest();

    System.assertEquals(
      importesWrapper.quantidade,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      importesWrapper.vencimiento,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      importesWrapper.precioUnitario,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      importesWrapper.nuevoVencimiento,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      importesWrapper.diasProrrogacion,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      importesWrapper.Juros,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      importesWrapper.valorJuros,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      importesWrapper.valorConJuros,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      importesWrapper.total,
      null,
      'Initial value should be null'
    );
  }

  @isTest
  static void testPricebookEntryOppLineItmemWrapper() {
    Test.startTest();
    aSiteVendaDeBasicaController.PricebookEntryOppLineItmemWrapp priceBookEntryOppLineItemWrapp = new aSiteVendaDeBasicaController.PricebookEntryOppLineItmemWrapp();
    Test.stopTest();

    System.assertEquals(
      priceBookEntryOppLineItemWrapp.pricebookEntryId,
      null,
      'Initial value should be null'
    );
    System.assertEquals(
      priceBookEntryOppLineItemWrapp.cantidad,
      null,
      'Initial value should be null'
    );
  }

  @isTest
  static void testGoToDevoluciones() {
    Test.startTest();
    aSiteVendaDeBasicaController vendaController = new aSiteVendaDeBasicaController();
    vendaController.OpportunityIdADevolver = 'asdasdasd123123123';
    Pagereference page = vendaController.goToDevoluciones();
    Test.stopTest();

    String expectedUrl = '/apex/aSiteDevoluciones?oppId=asdasdasd123123123';
    String expectedOppId = 'asdasdasd123123123';

    System.assertEquals(
      expectedUrl,
      page.getUrl(),
      'Page reference URL should be /apex/aSiteDevoluciones'
    );
    System.assertEquals(
      expectedOppId,
      page.getParameters().get('oppId'),
      'Opportuniy ID in page reference parameter should be equal to "asdasdasd123123123"'
    );
  }

  @isTest
  static void testGetCurrentPage() {
    Test.startTest();
    aSiteVendaDeBasicaController vendaController = new aSiteVendaDeBasicaController();
    vendaController.pagingNumber = 0;
    aSiteVendaDeBasicaController.paginacion aPaginacion = new aSiteVendaDeBasicaController.paginacion(
      0,
      5,
      10
    );
    vendaController.paginaciones.add(aPaginacion);
    Test.stopTest();

    Integer pageNumber = vendaController.getCurrentPage();

    System.assertEquals(1, pageNumber, 'Page number should be 1');
  }

  @isTest
  static void testGetTotalPages() {
    //Crear oportunidades
  }

  @isTest
  static void testGetPresupuestos() {
    Date today = System.today();

    List<Opportunity> opportunities = [SELECT Id FROM Opportunity];

    Quote aQuote = Build.aQuote()
      .withName('Test')
      .withOpportunity(opportunities[0])
      .build();
    aQuote.Vis_vel_para_multiplicador__c = true;
    aQuote.Status = 'Rascunho';
    aQuote.Condi_o_de_pagamento__c = 'ZC67 - 60 dias Data Ordem	';
    aQuote.Primeiro_pagamento__c = 0;
    aQuote.Novo_primeiro_vencimento__c = today.addDays(1);

    insert aQuote;

    Test.startTest();
    List<Quote> quotes = aSiteVendaDeBasicaController.getPresupuestos(
      opportunities[0]
    );
    Test.stopTest();

    System.assert(
      quotes[0].Id == aQuote.Id,
      'A Quote with the opportunityId passed in the parameters should be found'
    );
  }

  @isTest
  static void testGetOportunidadesDevolucion() {
    Account anAccount = [SELECT Id FROM Account LIMIT 1];
    testSiteUserSession = [SELECT Id FROM SiteUserSession__c];
    PageReference pageRef = Page.aSiteVendaDeBasica;

    Id devolucionRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
      .get('Devolução')
      .getRecordTypeId();
    Opportunity anOpp = Build.anOpportunityVENTADEBASICA()
      .withCloseDate(System.today().addDays(4))
      .withMarca('BRMX')
      .withPricebook2Id(Test.getStandardPricebookId())
      .withSafra('20/21')
      .withAccountId(anAccount)
      .withCloseDate(System.today())
      .withRecordTypeId(devolucionRecordTypeId)
      .build();
    anOpp.Novo_primeiro_vencimento__c = System.today().addMonths(1);
    anOpp.Taxa_de_primeiro_pagamento__c = 100;
    // anOpp.Estado__c = '';
    anOpp.Confirmado__c = true;
    anOpp.Numero_Entrega__c = '10';
    anOpp.Documento_Transporte__c = 'testasd';
    anOpp.Nro_Pedido_SAP__c = 'ANUMBER';
    anOpp.Inicio_Cargamento__c = Date.today().addDays(-1);
    anOpp.Inicio_Transporte__c = Date.today();
    anOpp.Fin_Transporte__c = Date.today().addDays(5);
    anOpp.Name = 'Opp Name';
    insert anOpp;

    Test.startTest();
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('token', testSiteUserSession.Id);
    aSiteVendaDeBasicaController vendaBasicaCtrl = new aSiteVendaDeBasicaController();
    vendaBasicaCtrl.activeAccount = anAccount;
    List<Opportunity> opportunities = vendaBasicaCtrl.getOportunidadesDevolucion();
    Test.stopTest();

    System.assert(
      opportunities.size() > 0,
      'Method should return at least one record of type "Devoluciones" '
    );
    System.assertEquals(
      1,
      opportunities.size(),
      'One opportunity with record type name "Devolução" should be found'
    );
  }

  // @isTest
  // static void testApprovalProcess() {
  //   String safraActual = '19/20';
  //   Configuracion_BMX__c conf = new Configuracion_BMX__c(
  //     PM_Safra_Actual__c = safraActual
  //   );
  //   insert conf;

  //   Account anAccount = [SELECT Id FROM Account LIMIT 1];
  //   testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
  //   Campaign aCampaign = [SELECT Id FROM Campaign LIMIT 1];
  //   PricebookEntry pbe = [SELECT Id FROM PricebookEntry LIMIT 1];
  //   Product2 aProduct = [SELECT Id FROM Product2 LIMIT 1];
  //   Regiao__c region = [SELECT Id FROM Regiao__c LIMIT 1];

  //   PageReference pageRef = Page.aSiteVendaDeBasica;

  //   Id devolucionRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
  //     .get('Venda da Basica Completo')
  //     .getRecordTypeId();

  //   // Test.setCurrentPage(pageRef);
  //   // pageRef.getParameters().put('token', testSiteUserSession.Id);
  //   aSiteVendaDeBasicaController vendaBasicaCtrl = new aSiteVendaDeBasicaController();
  //   vendaBasicaCtrl.activeAccount = anAccount;
  //   vendaBasicaCtrl.safraActual = '19/20';

  //   Opportunity anOpp = Build.anOpportunityVendaDaBasicaCompleta()
  //     .withCloseDate(System.today().addDays(4))
  //     .withMarca('BRMX')
  //     .withPricebook2Id(Test.getStandardPricebookId())
  //     .withSafra(safraActual)
  //     .withAccountId(anAccount)
  //     .withCloseDate(System.today().addDays(1))
  //     .build();
  //   anOpp.CampaignId = aCampaign.Id;
  //   anOpp.Novo_primeiro_vencimento__c = System.today().addMonths(1);
  //   anOpp.Taxa_de_primeiro_pagamento__c = 100;
  //   insert anOpp;
  //   OpportunityLineItem oli = new OpportunityLineItem();
  //   oli.opportunityId = anOpp.id;
  //   oli.Quantity = 10;
  //   oli.TotalPrice = 100;
  //   oli.pricebookEntryId = pbe.id;
  //   oli.Product2Id = aProduct.Id;
  //   oli.Tipo_de_Necessidade__c = 'Multiplicação';
  //   insert oli;

  //   Test.startTest();
  //   // insert anotherAccount;
  //   // vendaBasicaCtrl.approvalProcess('Approve');
  //   Test.stopTest();

  //   Opportunity approvedOpp = [
  //     SELECT Id, StageName, Comentarios_de_confirmacion__c, Confirmado__c
  //     FROM Opportunity
  //     WHERE Id = :anOpp.Id
  //   ];

  //   System.assert(approvedOpp != null);
  // }

  @isTest
  static void testGetTextoFecha() {
    Test.startTest();
    aSiteVendaDeBasicaController vendaController = new aSiteVendaDeBasicaController();
    Date aDate = Date.newInstance(2021, 3, 4);
    String aStringDate = vendaController.getTextoFecha(aDate);
    Test.stopTest();

    System.assertEquals(
      '04/03/2021',
      aStringDate,
      'If day or month number is less than 10, it should add a zero (0) before the day or month number.' +
      ' For example 4/4/2020 should change to 04/04/2021'
    );
  }

  @isTest
  static void testPaginacion() {
    //Need to insert cvb_autorizada and devolucion types of opportunities

    String safraActual = '20/21';

    Account anAccount = [SELECT Id FROM Account LIMIT 1];
    testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
    SiteUser__c aSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
    Campaign aCampaign = [SELECT Id FROM Campaign LIMIT 1];
    PricebookEntry pbe = [SELECT Id FROM PricebookEntry LIMIT 1];
    Product2 aProduct = [SELECT Id FROM Product2 LIMIT 1];
    Regiao__c region = [SELECT Id FROM Regiao__c LIMIT 1];

    Id devolucionId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
      .get('Devolução')
      .getRecordTypeId();
    Id cvbAuorizadaId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
      .get('CVB Autorizada')
      .getRecordTypeId();

    List<Opportunity> testOpps = new List<Opportunity>();

    for (Integer i = 0; i < 10; i++) {
      Opportunity cvbAutorizadaOpp = Build.anOpportunityCVBAutorizada()
        .withName('Test')
        .withStageName('Autorizada')
        .withCloseDate(System.today())
        .build();

      Opportunity devolucionOpp = Build.anOpportunity()
        .withRecordTypeId(devolucionId)
        .withName('Test 2')
        .withMarca('BRMX')
        .withPricebook2Id(Test.getStandardPricebookId())
        .withSafra(safraActual)
        .withAccountId(anAccount)
        .withCloseDate(System.today().addDays(1))
        .build();
      devolucionOpp.CampaignId = aCampaign.Id;
      devolucionOpp.Novo_primeiro_vencimento__c = System.today().addMonths(1);
      devolucionOpp.Taxa_de_primeiro_pagamento__c = 100;
      devolucionOpp.Usuario__c = aSiteUser.Id;

      testOpps.add(cvbAutorizadaOpp);
      testOpps.add(devolucionOpp);
    }

    Test.startTest();
    insert testOpps;
    aSiteVendaDeBasicaController vendaController = new aSiteVendaDeBasicaController();
    vendaController.Next();
    vendaController.Previous();
    Boolean showPrev = vendaController.getShowPrevDev();
    Boolean nextDev = vendaController.getShowNextDev();
    Integer totalPages = vendaController.getTotalPages();
    Test.stopTest();

    List<Opportunity> opps = [
      SELECT Id
      FROM Opportunity
      WHERE
        RecordType.DeveloperName = 'CVB_Autorizada'
        OR RecordType.DeveloperName = 'Devolucion'
    ];

    System.assert(opps.size() == 20);
  }*/
  @IsTest
  public static void changeOpportunityLineItems_TEST(){
    //Inicialización y carga de datos
    System.debug('LIMIT SOQL -1: '+Limits.getQueries());
    Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
    insert region;
    System.debug('LIMIT SOQL -2: '+Limits.getQueries());
    Account accountOne = Build.anAccount()
      .withResponsavel('061 - Fernando Frehner')
      .withRegion(region)
      .withName('Test account 2')
      .withType('Multiplicador')
      .withMarca('BRMX')
      .build();
    insert accountOne;
    System.debug('LIMIT SOQL -3: '+Limits.getQueries());
    getToken(accountOne);
    System.debug('LIMIT SOQL -4: '+Limits.getQueries());

    Campaign campanha = new Campaign();
    campanha.Marca__c = 'BRMX';
    campanha.Safra__c = safraActual;
    campanha.Region__c = region.Id;
    campanha.Name = 'Test';
    campanha.Epoca_de_Producao__c = 'Inverno';
    campanha.StartDate = System.today().addDays(-10);
    campanha.EndDate = System.today().addDays(10);
    campanha.RecordTypeId = XappiaHelper.getRecordType(
        'Campaign',
        'Venda_de_Basica'
      )
      .Id;
    insert campanha;
    System.debug('LIMIT SOQL -5: '+Limits.getQueries());

    Opportunity testOpportunity = Build.anOpportunityVendaDaBasicaCompleta().
        withName('Test VBF').
        withAccountId(accountOne).
        withSafra('18/19').
        withMarca('BRMX').
        withCloseDate(System.today()).
        build();
    testOpportunity.CampaignId = campanha.Id;
    testOpportunity.Novo_primeiro_vencimento__c = System.today().addMonths(1);
    testOpportunity.Taxa_de_primeiro_pagamento__c = 100;
    insert testOpportunity;
    System.debug('LIMIT SOQL -6: '+Limits.getQueries());
    
    System.debug('LIMIT SOQL -A: '+Limits.getQueries());
    PricebookEntry PBE = [SELECT ID FROM PricebookEntry WHERE UnitPrice = 58 AND IsActive = true][0];
    Product2 producto2 = [SELECT ID FROM Product2 WHERE Name = 'Test product2'][0];
    //Test
    Test.startTest();
    OpportunityLineItem testOpportunityLineItemA = Build.anOpportunityLineItem()
      .withOpportunityId(testOpportunity)
      .withPricebookEntryId(PBE)
      .withProduct2Id(producto2)
      .withQuantity(40)
      .withUnitPrice(400)
      .build();
    testOpportunityLineItemA.Tipo_de_Necessidade__c = 'Multiplicação';
    insert testOpportunityLineItemA;
    System.debug('LIMIT SOQL A: '+Limits.getQueries());
    estadoOne = Build.anEstado().withName('Capital').build();
    insert estadoOne;
    
    System.debug('LIMIT SOQL B: '+Limits.getQueries());
    contactOne = Build.aContactDestinatarioBloqueado()
      .withAccountId(accountOne)
      .withFirstName('Contact2')
      .withLastName('two')
      .withCNPJCPFc('1234557')
      .withEstado(estadoOne)
      .withMailingStreet('Bulnes 784')
      .withMailingCity('Capital Federal')
      .withMailingState('Buenos Aires')
      .withMailingCountry('Argentina')
      .build();
    insert contactOne;
    System.debug('LIMIT SOQL C: '+Limits.getQueries());
    Opportunity pedido = new Opportunity(
      Name = 'Pedido1',
      Entregas__c = testOpportunity.id,
      AccountId = accountOne.Id,
      StageName = 'Autorizada', 
      CloseDate = System.today(),
      Destinatario_de_Mercaderia__c = contactOne.Id
    );
    insert pedido;
    System.debug('LIMIT SOQL D: '+Limits.getQueries());
    OpportunityLineItem testOpportunityLineItem = Build.anOpportunityLineItem()
      .withOpportunityId(pedido)
      .withPricebookEntryId(PBE)
      .withProduct2Id(producto2)
      .withQuantity(40)
      .withUnitPrice(400)
      .build();
    testOpportunityLineItem.Tipo_de_Necessidade__c = 'Multiplicação';
    insert testOpportunityLineItem;
    System.debug('LIMIT SOQL E: '+Limits.getQueries());
    
    aSiteVendaDeBasicaController vendaController = new aSiteVendaDeBasicaController();
    System.debug('LIMIT SOQL F: '+Limits.getQueries());
    vendaController.ordersByContactValues = new List<aSiteVendaDeBasicaController.OrderWrapper>();
    vendaController.changeOpportunityLineItems();
    
    System.debug('LIMIT SOQL G: '+Limits.getQueries());
    Test.stopTest();
    //ASSERTS

  }

  @IsTest
  public static void sumbitForApproval_TEST(){
    //Inicialización y carga de datos    
    Profile profileIdSupervisor = [SELECT Id FROM Profile WHERE Name = 'Supervisor Administrativo' LIMIT 1];
    Profile profileIdGerente = [SELECT Id FROM Profile WHERE Name = 'Gerente Administrativo' LIMIT 1];    

    User gerente = new User(
        LastName = 'Rosa Gerente',
        FirstName = 'Jorge Cristiano Gerente',
        Alias = 'Gerente',
        Email = 'jorge.rosa.gerente@asdf.com',
        Username = 'jorge.rosa.gerente@asdf.com',
        ProfileId = profileIdGerente.id,
        TimeZoneSidKey = 'GMT',
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        IsActive = true,
        Codigo_SAP__c = '062'
    );        
    insert gerente;
        
    User supervisor = new User(
        LastName = 'Rosa',
        FirstName = 'Jorge Cristiano',
        Alias = 'jcr',
        Email = 'jorge.rosa@asdf.com',
        Username = 'jorge.rosa@asdf.com',
        ProfileId = profileIdSupervisor.id,
        TimeZoneSidKey = 'GMT',
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LocaleSidKey = 'en_US',
        IsActive = true,
        Codigo_SAP__c = '061',
        ManagerId = gerente.id
    );        
    insert supervisor;
       
    Account testAccountSupervisor = Build.anAccount()
      .withName('Test account supervisor')
      .withType('Supervisor')
      .withMarca('BRMX')		
      .withGerenteComercial(gerente)
      .withResponsavel('061 - Fernando Frehner')
      .build();
    insert testAccountSupervisor;   
        
    Account testAccount = Build.anAccount()
      .withName('Test account')
      .withType('Multiplicador')
      .withMarca('BRMX')
      .withSupervisor(supervisor)
      .withGerenteComercial(gerente)
      .withResponsavel('061 - Fernando Frehner')
      .build();
    insert testAccount;      
        
    Atributo_venda_de_basica__mdt allocation = [
        SELECT id, Nome_de_usu_rio_atribu_do__c, Usuario_gerente__c	
        FROM Atributo_venda_de_basica__mdt
        WHERE  Regi_o__c = 'REGION 1'
        AND  Marca__c= 'BRMX'
        LIMIT 1
    ];
        
    allocation.Nome_de_usu_rio_atribu_do__c = 'jorge.rosa@asdf.com';
    allocation.Usuario_gerente__c = 'jorge.rosa.gerente@asdf.com';
    
    User u = [
        SELECT Id FROM User WHERE UserName =  :allocation.Usuario_gerente__c LIMIT 1
    ];
  
    User us = [
        SELECT Id FROM User WHERE UserName =  :allocation.Nome_de_usu_rio_atribu_do__c LIMIT 1
    ];                
    
    Requisicao_de_compra__c multiplicadorReq = Build.aRequisicaoDeCompra()
        .withTipo('Multiplicador')
        .withSafra(safraActualEstimativaCompra)
        .withRegiao('REGION 1')
        .withMarca('BRMX')
        .withEstado('Edição')
        .withOwner(UserInfo.getUserId())
        .build();
    multiplicadorReq.Aprovador__c = supervisor.Id;
    multiplicadorReq.Multiplicador__c = testAccount.id;
    insert multiplicadorReq;

    Variedad__c testVariedad = Build.aVariedad().
        withName('Test variety').
        withAtiva(true).
        withNombredeRegistro('Var').
        withNumeroderegistro('123').
        withMarcacomercial('BRASMAX').
        build();
    insert testVariedad;

    Produto_de_Requisicao__c prod_requis = new Produto_de_Requisicao__c(
      Requisicao_de_compra__c = multiplicadorReq.Id,
      Variedad__c = testVariedad.Id,
      Quantidade__c = 1
    );
    insert prod_requis;

    SiteUser__c testSiteUserReq = Build.aSiteUser().
      withName('Test Estimativa').
      withEmail('testDeEstimativa@test.com').
      withPassword('test').
      withActive(true).
      withHabilitadoAnexos(true).
      build();
    insert testSiteUserReq;

    SiteUserAccount__c testSiteUserAccount = Build.aSiteUserAccount().
      withName('Test site user account').
      withAccount(testAccount).
      withSiteUser(testSiteUserReq).
      withActive(true).
      build();
    insert testSiteUserAccount;

    SiteUserSession__c testSiteUserSessionReq = Build.aSiteUserSession().
      withSiteUser(testSiteUserReq).
      withMarca('BRMX').
      withSafra(safraActualEstimativaCompra).
      build();
    insert testSiteUserSessionReq;

    SiteUserSession__c testSiteUserSession = [SELECT Id FROM SiteUserSession__c LIMIT 1];
    SiteUser__c testSiteUser = [SELECT Id FROM SiteUser__c LIMIT 1];
    PageReference pageRef = Page.aSiteVendaDeBasica;
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('token', testSiteUserSessionReq.Id);   
    Test.startTest();
      aSiteVendaDeBasicaController vendaController = new aSiteVendaDeBasicaController();
      vendaController.activeAccount = testAccount;
      vendaController.safraActualEstimativaCompra = safraActualEstimativaCompra;
      vendaController.isTest = true;
      vendaController.getRequisicao();
      vendaController.sumbitForApproval();
    Test.stopTest();

  }

  @IsTest
  public static void SaveComentarioConfirmacion_TEST(){
    //Inicialización y carga de datos
    Opportunity CVBA = new Opportunity(
      RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CVB Autorizada').getRecordTypeId(),
      Name = 'Test CVBA',
      CloseDate = System.today(),
      StageName = 'Autorizada'
    );
    insert CVBA;
    //Test
    Test.startTest();
    aSiteVendaDeBasicaController vendaController = new aSiteVendaDeBasicaController();
    vendaController.OpportunityIdAConfirmar = CVBA.Id;
    vendaController.SaveComentarioConfirmacion();
    Test.stopTest();
    //ASSERTS

  }

  @IsTest
  public static void searchProducts_TEST(){
    //Inicialización y carga de datos
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
    insert testProduct2;

    Pricebook2 testPricebook2t = new Pricebook2();
    testPricebook2t.Name = 'Lista Canal Multiplicadores';
    testPricebook2t.Para_venda_de_b_sica_inicial__c = true;
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

    safraActual = '18/19';
    Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
    insert region;
    System.debug('LIMIT SOQL -2: '+Limits.getQueries());
    Account accountOne = Build.anAccount()
      .withResponsavel('061 - Fernando Frehner')
      .withRegion(region)
      .withName('Test account 2')
      .withType('Multiplicador')
      .withMarca('BRMX')
      .build();
    insert accountOne;
    System.debug('LIMIT SOQL -3: '+Limits.getQueries());
    getToken(accountOne);
    //Test
    Test.startTest();
    aSiteVendaDeBasicaController vendaController = new aSiteVendaDeBasicaController();
    vendaController.newProduct = standardPrice.Id;
    vendaController.searchProducts();
    Test.stopTest();
    //ASSERTS

  }

  @IsTest
  public static void pagination_TEST(){
    //Inicialización y carga de datos
    safraActual = '18/19';
    Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
    insert region;
    System.debug('LIMIT SOQL -2: '+Limits.getQueries());
    Account accountOne = Build.anAccount()
      .withResponsavel('061 - Fernando Frehner')
      .withRegion(region)
      .withName('Test account 2')
      .withType('Multiplicador')
      .withMarca('BRMX')
      .build();
    insert accountOne;
    System.debug('LIMIT SOQL -3: '+Limits.getQueries());
    getToken(accountOne);
    //Test
    Test.startTest();
    aSiteVendaDeBasicaController vendaController = new aSiteVendaDeBasicaController();
    vendaController.Previous();
    vendaController.Next();
    vendaController.getShowPrevDev();
    vendaController.getTotalPages();
    vendaController.getCurrentPage();
    vendaController.goToDevoluciones();
    Test.stopTest();
    //ASSERTS

  }

  @IsTest
  public static void validate_TEST(){
    //Inicialización y carga de datos
    //Test
    Test.startTest();
    aSiteVendaDeBasicaController vendaController = new aSiteVendaDeBasicaController();
    vendaController.validate();
    Test.stopTest();
    //ASSERTS

  }

  @IsTest
  public static void adicionarOrder_TEST(){
    //Inicialización y carga de datos
    safraActual = '18/19';
    Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
    insert region;
    PricebookEntry PBE = [SELECT ID FROM PricebookEntry WHERE UnitPrice = 58 AND IsActive = true][0];
    System.debug('LIMIT SOQL -2: '+Limits.getQueries());
    Account accountOne = Build.anAccount()
      .withResponsavel('061 - Fernando Frehner')
      .withRegion(region)
      .withName('Test account 2')
      .withType('Multiplicador')
      .withMarca('BRMX')
      .build();
    insert accountOne;
    System.debug('LIMIT SOQL -3: '+Limits.getQueries());
    getToken(accountOne);
    
    estadoOne = Build.anEstado().withName('Capital').build();
    insert estadoOne;

    contactOne = Build.aContactDestinatarioBloqueado()
      .withAccountId(accountOne)
      .withFirstName('Contact2')
      .withLastName('two')
      .withCNPJCPFc('1234557')
      .withEstado(estadoOne)
      .withMailingStreet('Bulnes 784')
      .withMailingCity('Capital Federal')
      .withMailingState('Buenos Aires')
      .withMailingCountry('Argentina')
      .build();
    insert contactOne;

    Campaign campanha = new Campaign();
    campanha.Marca__c = 'BRMX';
    campanha.Safra__c = safraActual;
    campanha.Region__c = region.Id;
    campanha.Name = 'Test';
    campanha.Epoca_de_Producao__c = 'Inverno';
    campanha.StartDate = System.today().addDays(-10);
    campanha.EndDate = System.today().addDays(10);
    campanha.RecordTypeId = XappiaHelper.getRecordType(
        'Campaign',
        'Venda_de_Basica'
      )
      .Id;
    insert campanha;

    Opportunity testOpportunity = Build.anOpportunityVendaDaBasicaCompleta().
        withName('Test VBF').
        withAccountId(accountOne).
        withSafra('18/19').
        withMarca('BRMX').
        withCloseDate(System.today()).
        build();
    testOpportunity.CampaignId = campanha.Id;
    testOpportunity.Novo_primeiro_vencimento__c = System.today().addMonths(1);
    testOpportunity.Taxa_de_primeiro_pagamento__c = 100;
    insert testOpportunity;

    contactOne = [SELECT ID FROM Contact WHERE ID = :contactOne.Id][0];
    //Test
    Test.startTest();
    aSiteVendaDeBasicaController vendaController = new aSiteVendaDeBasicaController();
    vendaController.productosSeleccionadosValues = new List<aSiteVendaDeBasicaController.ProductosSeleccionados>();
    aSiteVendaDeBasicaController.ProductosSeleccionados wrapp = new aSiteVendaDeBasicaController.ProductosSeleccionados();
    wrapp.pricebookEntryId = PBE.Id;
    wrapp.cantidad = 2;
    vendaController.productosSeleccionadosValues.add(wrapp);
    vendaController.contactProduct.contactId = contactOne.Id;
    vendaController.contactProduct.cantidad = 1;
    vendaController.contactProduct.productId = PBE.Id;
    vendaController.adicionarOrder();

    Test.stopTest();
    //ASSERTS

  }

  public static String getToken(Account cuenta){
    //Inicializacion y carga de datos
    SiteUser__c usuario = new SiteUser__c(
        Email__c = 'emailTest@gmail.com',
        Password__c = '12345678',
        Active__c = true
    );
    insert usuario;

    SiteUserAccount__c cuentaActiva = new SiteUserAccount__c(
        SiteUser__c = usuario.id,
        Active__c = true,
        Account__c = cuenta.id
    );
    insert cuentaActiva;

    aSiteLoginController controllerLogin = new aSiteLoginController();
    
    controllerLogin.username = 'emailtest@gmail.com';
    controllerLogin.password = '12345678';
    Pagereference pageUrlConToken = controllerLogin.login();
    Test.setCurrentPageReference(pageUrlConToken);
    String token = ApexPages.currentPage().getParameters().get('token');
    return token;
  }
}
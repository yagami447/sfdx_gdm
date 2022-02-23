@isTest
private class aSiteEventosControllerTest {

    @TestSetup static void setup() {
        Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX()
            .withPMSafraActualEventos('18/19')
            .withMarca('BRMX')
            .build();

        insert testConfiguracionBMX;

        Account account = Build.anAccount()
            .withName('JERE')
            .withNomefantasia('JRERE')
            .withResponsavel('061 - Fernando Frehner')
            .withType('Multiplicador')
            .build();

        insert account;

        Product2[] products = new Product2[]{
            new Product2(Name = 'Outro', Especie__c = 'SOJA', Obtentor__c = 'ADVANTA'),
            new Product2(Name = '68i69RSF IPRO', Especie__c = 'TRIGO', Obtentor__c = 'Don Mario'),
            new Product2(Name = 'SYN 1359S IPRO', Especie__c = 'SOJA', Obtentor__c = 'Syngenta')
        };

        insert products;

        Estado__c estado = new Estado__c(
            Name = 'SP',
            Mostrar_en_portal__c = true,
            Estado_de_Origem__c = true
        );

        insert estado;

        Cidade__c ciudad = new Cidade__c(
            Name = 'ADAMANTINA',
            GeoCod_municipio__c = '3500105',
            Mesorregion__c = 'PRESIDENTE PRUDENTE',
            Estado__c = estado.Id
        );

        insert ciudad;

        Date fechaInicio1 = Date.today().addDays(-2);
        Date fechaInicio2 = Date.today().addDays(-1);
        Date fechaTermino1 = Date.today().addDays(2);
        Date fechaTermino2 = Date.today().addDays(-1);

        Prazo_de_Lancamento__c[] plazos = new Prazo_de_Lancamento__c[]{
            new Prazo_de_Lancamento__c(
                Evento__c = 'Emplacamento',
                Inicio__c = String.format('{0}/{1}', new Object[]{fechaInicio1.day(), fechaInicio1.month()}),
                Termino__c = String.format('{0}/{1}', new Object[]{fechaTermino1.day(), fechaTermino1.month()}),
                Estado__c = estado.Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            ),
            new Prazo_de_Lancamento__c(
                Evento__c = 'Lado a Lado',
                Cadastro_de_plantio__c = String.format('{0}/{1}', new Object[]{fechaInicio1.day(), fechaInicio1.month()}),
                Cadastro_de_colheita__c = String.format('{0}/{1}', new Object[]{fechaInicio2.day(), fechaInicio2.month()}),
                Termino__c = String.format('{0}/{1}', new Object[]{fechaTermino1.day(), fechaTermino1.month()}),
                Estado__c = estado.Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            ),
            new Prazo_de_Lancamento__c(
                Evento__c = 'Treinamento Tecnico',
                Inicio__c = String.format('{0}/{1}', new Object[]{fechaInicio1.day(), fechaInicio1.month()}),
                Termino__c = String.format('{0}/{1}', new Object[]{fechaTermino2.day(), fechaTermino2.month()}),
                Estado__c = estado.Id,
                Configuracion_de_Marca__c = testConfiguracionBMX.Id
            )
        };

        insert plazos;

        SiteUser__c su = new SiteUser__c(Email__c='jere@dm.com', Password__c='123');
        insert su;

        SiteUserAccount__c suAccount = new SiteUserAccount__c(
            SiteUser__c = su.Id,
            Account__c = account.Id,
            Active__c = true
        );

        insert suAccount;

        SiteUserSession__c siteUserSession = new SiteUserSession__c(
            Marca__c = 'BRMX',
            Safra__c = '18/19',
            SiteUser__c = su.Id
        );

        insert siteUserSession;

        CRM_Calendario_de_Eventos__c crmEvento = new CRM_Calendario_de_Eventos__c(
            Data__c = Date.today(),
            Cuenta__c = account.id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Test_a_campo'].Id,
            Safra__c = '18/19',
            Marca__c = 'BRMX',
            Fase__c = 'Edição',
            Municipio__c = ciudad.Id,
            Realizado_por__c = 'Multiplicador'
        );

        insert crmEvento;

        CRM_Detalle_Calendario_de_eventos__c detalleCRMEvento = new CRM_Detalle_Calendario_de_eventos__c(
            CRM_Calendario_de_eventos__c = crmEvento.Id,
            Obtentor__c = 'Nidera',
            Cultivar__c = products[0].Id,
            Data_de_colheita__c = Date.today().addDays(-30),
            Data_de_plantio__c = Date.today().addDays(30),
            Area_Colhida__c = 3.5,
            Area_Plantada__c = 3.5,
            Produtividade__c = 500,
            Volume_Doado__c = 5.0,
            Populacao_de_plantas__c = 5.5,
            Espacamento__c = 5.5,
            Cultura_antecessora__c = 'Ervilhaca',
            Produto_Principal__c = true
        );

        insert detalleCRMEvento;

        Caracteristica_de_evento__mdt caractEvento = new Caracteristica_de_evento__mdt();
        caractEvento.Nombre_especifico_del_evento__c = 'test caracteristica evento';
        caractEvento.Permitir_creacion_de_nuevos__c = true;

        Attachment_Content__c attContent = new Attachment_Content__c(
            CRM_Calendario_de_Eventos__c = crmEvento.Id
        );

        insert attContent;

        Attachment att = new Attachment(
            Name = 'Unit Test Attachment',
            Body = Blob.valueOf('Unit Test Attachment Body'),
            parentId = attContent.Id
        );

        insert att;
    }

    @isTest static void validate_token_valido() {
        SiteUser__c siteUs = [SELECT Id,Email__c,Password__c FROM SiteUser__c];
        SiteUserSession__c siteUserSession = [SELECT Id, Marca__c, Safra__c FROM SiteUserSession__c];
        Map<Id,CRM_Calendario_de_Eventos__c> lista = new Map<Id,CRM_Calendario_de_Eventos__c>([SELECT Id, Data__c, Evento__c, Cuenta__c, Safra__c FROM CRM_Calendario_de_Eventos__c]);
        List<CRM_Detalle_Calendario_de_eventos__c> listDCE = [SELECT Id, Obtentor__c, Cultivar__c FROM CRM_Detalle_Calendario_de_eventos__c];
        CRM_Calendario_de_Eventos__c crmEvento = lista.values()[0];

        PageReference pageRef = Page.aSiteEventoEdit;
        pageRef.getParameters().put('token', siteUserSession.Id);
        pageRef.getParameters().put('e', crmEvento.Id);
        pageRef.getParameters().put('goArchivos', '0');
        pageRef.getParameters().put('evento', 'Treinamento');

        Test.setCurrentPage(pageRef);
        aSiteEventosController c = new aSiteEventosController();
        c.evento2.id = null;
        c.relatedEventos = lista;
        c.tipoEvento = 'Treinamento Tecnico';
        c.tmpEventoItems = listDCE;
        // poner la identificación del cliente potencial como parámetro

        PageReference web = c.validate();
        //obtiene el log user correcto
        System.assertEquals(siteUs.id , c.logUser.id);
        //le da al event2 la marca correcta
        System.assertEquals('BRMX', c.evento2.marca);

        List<CRM_Calendario_de_Eventos__c> lista2 = c.getEventos();

        c.setActiveEvento();

        List<aSiteEventosController.item> items = c.getEventoItems();

        Boolean valor = c.getCreationIsAllowed();

        List<aSiteEventosController.item> items2 = c.getEventoItemsNew();

        c.updateAvailableList();

        PageReference web2 = c.getVariedadesObt_Add_NewEvento();

        // null list index
        // PageReference web3 = c.getVariedadesObt_Edit_Evento();

        PageReference web4 = c.setearEstadoNewEvento();

        Cidade__c ciudad = [SELECT Id, Name, Estado__r.Name, Estado__c FROM Cidade__c];
        c.evento2.ciudad = ciudad.Id;

        web4 = c.setearEstadoNewEvento();
        PageReference web5 = c.saveEvento();

        c.linea = 0;
        c.agregarItem();

        c.linea = 0; // Al AGREGAR ITEM SE SETEA LA VARIABLE LINEA EN NULL
        c.removerItem();
        c.goVerItems();
        c.verItemsListo();

        c.linea = 0;
        c.editItem();
        c.editItemListo();
        c.cargarNombresProds();
        c.changeTipoCuentaAgricultor();
        c.changeTipoCuentaRevenda();

        // Treinamento Tecnico
        List<Schema.FieldSetMember> fieldsTreinamento = c.getFieldsCab();

        c.tipoEvento = 'Día de Campo';
        List<Schema.FieldSetMember> fieldsCampo = c.getFieldsCab();

        c.tipoEvento  = 'Emplacamento';
        List<Schema.FieldSetMember> fieldsEmplacamento = c.getFieldsCab();

        c.tipoEvento = 'Test a campo';
        List<Schema.FieldSetMember> fieldsTest = c.getFieldsCab();

        List<Schema.FieldSetMember> lista4 = c.getFields();
        List<SelectOption> lista5 = c.getOptionTipoCuenta();

        PageReference web10 = c.gotoEdit();
        PageReference web11 = c.gotoNew();
        PageReference web12 = c.editCancel();

        SiteUser__c miSiteUser = c.getUser();
        Account miCuenta = c.getAccount();

        c.editId = null;
        c.enviarAprobacion = '2';
        c.agregarArchivos = true;
        c.evento2 = null;
        c.logUser = null;
        PageReference web13 = c.saveEvento();
    }

    @isTest static void validate_si_el_token_es_nulo() {
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id, Data__c, Cuenta__c, Evento__c, Safra__c FROM CRM_Calendario_de_Eventos__c];
        List<CRM_Detalle_Calendario_de_eventos__c> listDCE = [SELECT Id, Obtentor__c, Cultivar__c FROM CRM_Detalle_Calendario_de_eventos__c];

        PageReference pageRef = Page.aSiteEventoEdit;
        pageRef.getParameters().put('token', null);
        pageRef.getParameters().put('e', crmEvento.Id);
        pageRef.getParameters().put('goArchivos', '0');
        pageRef.getParameters().put('evento', 'Treinamento');

        Test.setCurrentPage(pageRef);
        aSiteEventosController c = new aSiteEventosController();

        c.tipoEvento = 'Treinamento Tecnico';
        c.tmpEventoItems = listDCE;
        c.relatedEventos = null;

        PageReference web = c.validate();
    }

    @isTest static void saveEvento_aEventosManager() {
        Account cuenta = new Account(Name = 'BSS COMERCIO DE SEMENTES LTDA', CNPJ_CPF__c = '37.442.609/0001-20');
        insert cuenta;

        aSiteEventosController.evento evento = new aSiteEventosController.evento();

        evento.latitud = '100';
        evento.longitud = '200';
        evento.participantes = '5';
        evento.costo = '10';
        evento.cuenta = cuenta.Id;
        evento.marca = 'BRMX';
        evento.safra = '17/18';
        evento.evento = 'Emplacamento';

        Product2 product = new Product2(Name = 'prod test 1', Obtentor__c = 'Bayer', IsActive = true);
        insert product;

        aSiteEventosController.item item = new aSiteEventosController.item();

        item.obtentor = 'Brasmax';
        item.area_colhida = '100';
        item.area_plantada = '100';
        item.produtividade = '100';
        item.volume_doado = '120';
        item.data_plantio = Date.today();
        item.id_producto = product.Id;
        item.produto_principal = false;

        List<aSiteEventosController.item> items = new List<aSiteEventosController.item>{item};
        List<aSiteEventosController.item> delItems = new List<aSiteEventosController.item>{item};

        SiteUser__c su = new SiteUser__c(Email__c='lks0452@dm.com', Password__c='123');
        insert su;

        aSiteUtils.retorno obj = aEventosManager.saveEvento(evento, items, delItems, 'test', su);

        System.assertEquals(true, obj.exito);
    }

    @isTest static void attachmentTest() {
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id FROM CRM_Calendario_de_Eventos__c];
        SiteUserSession__c siteUserSession = [SELECT Id FROM SiteUserSession__c];

        Test.setCurrentPageReference(Page.aSiteEventoEdit);
        ApexPages.currentPage().getParameters().put('token', siteUserSession.Id);
        ApexPages.currentPage().getParameters().put('e', crmEvento.Id);
        ApexPages.currentPage().getParameters().put('goArchivos', '1');
        ApexPages.currentPage().getParameters().put('evento', 'Lado a Lado');

        aSiteEventosController controller = new aSiteEventosController();

        controller.evento2.divulgarEmNomeDe = 'Agricultor';
        controller.evento2.agricultor = 'Juan Pérez';
        controller.evento2.tipoAgricultor = 'CPF';
        controller.enviarAprobacion = '0';
        controller.tipoEvento = 'Test a campo';
        controller.validate();

        Test.startTest();
        List<aSiteEventosController.adjunto> adjuntos = controller.getEventoArchivos();
        List<aSiteEventosController.adjunto> adjunto = controller.getArchivoNew();
        List<System.SelectOption> options = controller.getOptionAttachmentType();

        System.assertEquals(1, adjuntos.size());
        System.assertEquals('Arquivos gerais', options[0].getValue());
        System.assertEquals('Arquivos gerais', adjuntos[0].tipo);
        System.assertNotEquals(null, adjunto);

        adjunto[0].att.Body = Blob.valueOf('Unit Test False JPG Image Body');
        adjunto[0].att.Name = 'image.jpg';
        controller.addAttachment();

        System.assertEquals(2, adjuntos.size());
        System.assert(String.isNotEmpty(adjuntos[1].id));
        System.assertEquals(null, adjuntos[1].tipo);

        controller.attToRemove = adjuntos[1].id;
        controller.removeAttachment();

        System.assertEquals(1, adjuntos.size());
        
        adjunto = controller.getArchivoNew();
        adjunto[0].att.Body = Blob.valueOf('Unit Test False JPG Image Body');
        adjunto[0].att.Name = 'image.jpg';
        adjunto[0].tipo = 'Termo de autorização';
        controller.addAttachment();

        System.assertEquals(2, adjuntos.size());
        System.assertEquals('Termo de autorização', adjuntos[1].tipo);
        Test.stopTest();
    }

    @isTest static void saveValidationsTest() {
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id FROM CRM_Calendario_de_Eventos__c];
        SiteUserSession__c siteUserSession = [SELECT Id FROM SiteUserSession__c];

        Test.setCurrentPageReference(Page.aSiteEventoEdit);
        ApexPages.currentPage().getParameters().put('token', siteUserSession.Id);
        ApexPages.currentPage().getParameters().put('e', crmEvento.Id);
        ApexPages.currentPage().getParameters().put('goArchivos', '0');
        ApexPages.currentPage().getParameters().put('evento', 'Lado a Lado');

        aSiteEventosController controller = new aSiteEventosController();

        controller.evento2.divulgarEmNomeDe = 'Agricultor';
        controller.evento2.agricultor = 'Juan Pérez';
        controller.evento2.tipoAgricultor = 'CPF';
        controller.enviarAprobacion = '1'; // se solicita aprobación del evento
        controller.tipoEvento = 'Test a campo';
        controller.validate();

        Test.startTest();
        controller.getEventoItems();
        controller.getEventoItemsNew();
        controller.saveEvento();

        System.assertEquals('Você deve preencher todos os campos para solicitar aprovação', controller.mensaje);

        controller.tipoEvento = 'Emplacamento';
        controller.saveEvento();

        System.assertEquals('Você deve preencher todos os campos para solicitar aprovação', controller.mensaje);

        controller.tipoEvento = 'Test a campo';
        controller.evento2.latitud = '41.403380';
        controller.evento2.longitud = '2.174030';
        controller.saveEvento();

        System.assertEquals('É obrigatório informa o CPF do agricultor', controller.mensaje, 'Debe informarse que falta especificar el campo cpf_cnpj_agricultor');

        controller.evento2.divulgarEmNomeDe = '';
        controller.evento2.autorizado = true;
        controller.enviarAprobacion = '0';
        controller.saveEvento();

        // La validación debe informar que falta un campo obligatorio
        System.assertEquals('Você deve especificar: Divulgar em nome de', controller.mensaje, 'Debe informarse que falta especificar el campo divulgarEmNomeDe');

        controller.evento2.divulgarEmNomeDe = 'Agricultor';
        controller.evento2.cpf_cnpj_agricultor = '12345678901';
        controller.tmpEventoItems2 = null;
        controller.getEventoItems();
        controller.getEventoItemsNew();

        System.assertEquals(1, controller.tmpEventoItems2.size());

        controller.tmpEventoItems2[0].produto_principal = false; // producto principal deseleccionado
        controller.principalSelected = 0;
        controller.changePrincipalProduct();
        controller.verItemsListo(); // US 11589

        System.assertEquals('Você deve especificar: um (1) produto principal', controller.mensaje);

        controller.tmpEventoItems2[0].produto_principal = true; // producto principal seleccionado
        controller.tmpEventoItems2[0].volume_doado = ''; // se vacía el Volume Doado del producto principal
        controller.principalSelected = 0;
        controller.changePrincipalProduct();
        controller.verItemsListo();
        controller.enviarAprobacion = '1';
        controller.saveEvento();

        System.assertEquals(
            'Você deve especificar: Área plantada, Data de plantio, Volume Doado, População de plantas, Espaçamento e Cultura antecessora para o produto principal',
            controller.mensaje
        );

        controller.goVerItems();
        controller.getEventoItems();
        controller.getEventoItemsNew();
        controller.linea = 2;
        controller.agregarItem(); // BG 4377 RR

        System.assertEquals(2, controller.tmpEventoItems2.size());

        controller.tmpEventoItems2[0].volume_doado = '5,0';
        controller.tmpEventoItems2[1].area_plantada = '3,50';
        controller.tmpEventoItems2[1].populacao_de_plantas = '5,50';
        controller.tmpEventoItems2[1].espacamento = '5,50';
        controller.tmpEventoItems2[1].cultura_antecessora = 'Ervilhaca';
        controller.verItemsListo();
        controller.enviarAprobacion = '1';
        controller.saveEvento();

        System.assertEquals(
            'Você deve especificar: Área plantada, Data de plantio, População de plantas, Espaçamento e Cultura antecessora para o produto comparado',
            controller.mensaje
        );

        controller.evento2.fase = 'Aguardando resultado de colheita';
        controller.tmpEventoItems2[1].data_plantio = Date.today().addDays(-30);
        controller.tmpEventoItems2[1].data_colheita = Date.today().addDays(30);
        controller.enviarAprobacion = '1';
        controller.saveEvento();

        System.assertEquals('Você deve especificar: Área colhida, Data de colheida e Produtividade', controller.mensaje);

        controller.evento2.fase = 'Edição';
        controller.enviarAprobacion = '1';
        controller.saveEvento();

        System.assert(String.isEmpty(controller.mensaje));

        controller.evento2.direccion = 'Av. Siempre Viva 742';
        controller.tipoEvento = 'Emplacamento';
        controller.enviarAprobacion = '1';
        controller.saveEvento();

        System.assert(String.isEmpty(controller.mensaje));

        controller.enviarAprobacion = '2';
        controller.saveEvento();

        System.assert(String.isEmpty(controller.mensaje));
        Test.stopTest();
    }

    @isTest static void enviarAprobacionTest() {
        SiteUserSession__c siteUserSession = [SELECT Id FROM SiteUserSession__c];
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id FROM CRM_Calendario_de_Eventos__c];

        crmEvento.Nome_do_agricultor_2__c = 'Juan Sebastián';
        crmEvento.Tipo_Conta_Agricultor__c = 'CPF';
        crmEvento.CNPJ_CPF_Agricultor__c = '12345678901';
        crmEvento.Divulgar_em_nome_de__c = 'Agricultor';
        crmEvento.Latitud__c = 41.403380;
        crmEvento.Longitud__c = 2.174030;
        crmEvento.Realizado_por__c = 'Multiplicador';

        update crmEvento;

        CRM_Detalle_Calendario_de_eventos__c detalleCRMEvento = [SELECT Id FROM CRM_Detalle_Calendario_de_eventos__c];

        detalleCRMEvento.Data_de_plantio__c = null;
        detalleCRMEvento.Area_Plantada__c = null;
        detalleCRMEvento.Volume_Doado__c = null;
        detalleCRMEvento.Cultura_antecessora__c = null;

        update detalleCRMEvento;

        Id ciudadId = [SELECT Id FROM Cidade__c].Id;

        List<CRM_Calendario_de_Eventos__c> crmEventos = new CRM_Calendario_de_Eventos__c[]{
            new CRM_Calendario_de_Eventos__c(
                Data__c = Date.today(),
                Cuenta__c = [SELECT Id FROM Account].Id,
                RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Emplacamento'].Id,
                Safra__c = '18/19',
                Marca__c = 'BRMX',
                Fase__c = 'Edição',
                Municipio__c = ciudadId,
                Nome_do_agricultor_2__c = 'Juan Sebastián',
                Tipo_Conta_Agricultor__c = 'CPF',
                Latitud__c = 41.403380,
                Longitud__c = 2.174030,
                Direccion__c = 'Av. Siempre Viva 742',
                Realizado_por__c = 'Multiplicador'
            ),
            new CRM_Calendario_de_Eventos__c(
                Data__c = Date.today(),
                Cuenta__c = [SELECT Id FROM Account].Id,
                RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Treinamento_Tecnico'].Id,
                Safra__c = '18/19',
                Marca__c = 'BRMX',
                Fase__c = 'Edição',
                Municipio__c = ciudadId,
                Realizado_por__c = 'Multiplicador'
            )
        };

        insert crmEventos;

        Test.setCurrentPageReference(Page.aSiteEventos);
        ApexPages.currentPage().getParameters().put('token', siteUserSession.Id);
        ApexPages.currentPage().getParameters().put('evento', 'Lado a Lado');

        aSiteEventosController controller = new aSiteEventosController();

        controller.tipoEvento = 'Test a campo';
        controller.validate();

        Test.startTest();
        crmEvento = controller.getEventos()[0];

        System.assertEquals('Lado a Lado', crmEvento.Evento__c);

        controller.recId = crmEvento.Id;
        controller.setActiveEvento();
        controller.enviarAprobacion = crmEvento.Id;
        controller.enviarAprobacion();

        System.assertEquals(
            'Você deve especificar: Área plantada, Data de plantio, Volume Doado, População de plantas, Espaçamento e Cultura antecessora para o produto principal',
            controller.mensaje
        );

        ApexPages.currentPage().getParameters().put('evento', 'Emplacamento'); // Plazo de lanzamiento de Emplacamento

        controller = new aSiteEventosController();
        controller.tipoEvento = 'Emplacamento';
        controller.validate();

        crmEvento = controller.getEventos()[0];

        System.assertEquals('Emplacamento', crmEvento.Evento__c);

        controller.enviarAprobacion = crmEvento.Id;
        controller.enviarAprobacion();

        System.assert(String.isEmpty(controller.mensaje));

        ApexPages.currentPage().getParameters().put('evento', 'Treinamento'); // Plazo de lanzamiento de Treinamento

        controller = new aSiteEventosController();
        controller.tipoEvento = 'Treinamento Tecnico';
        controller.validate();

        crmEvento = controller.getEventos()[0];

        System.assertEquals('Treinamento', crmEvento.Evento__c);

        controller.enviarAprobacion = crmEvento.Id;
        controller.enviarAprobacion();

        System.assertEquals('Não é permitido cadastrar eventos fora do prazo de lançamento', controller.mensaje);
        Test.stopTest();
    }

    @isTest static void agregarItemValidationsTest() {
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id FROM CRM_Calendario_de_Eventos__c];
        SiteUserSession__c siteUserSession = [SELECT Id FROM SiteUserSession__c];

        List<CRM_Detalle_Calendario_de_eventos__c> detalleCRMEventos = [
            SELECT Id, CRM_Calendario_de_eventos__c, Obtentor__c, Cultivar__c FROM CRM_Detalle_Calendario_de_eventos__c
        ];

        Product2[] products = new Product2[]{
            new Product2(Name = 'BG 4377 RR', Especie__c = 'SOJA', Obtentor__c = 'Pioneer'),
            new Product2(Name = 'LG 7708', Especie__c = 'SOJA', Obtentor__c = 'Limagrain'),
            new Product2(Name = '5D6215 IPRO', Especie__c = 'SOJA', Obtentor__c = 'Dow')
        };

        insert products;

        detalleCRMEventos.addAll(new CRM_Detalle_Calendario_de_eventos__c[]{
            new CRM_Detalle_Calendario_de_eventos__c(
                CRM_Calendario_de_eventos__c = crmEvento.Id,
                Obtentor__c = 'Pioneer',
                Cultivar__c = products[0].Id
            ),
            new CRM_Detalle_Calendario_de_eventos__c(
                CRM_Calendario_de_eventos__c = crmEvento.Id,
                Obtentor__c = 'Limagrain',
                Cultivar__c = products[1].Id
            )
        });

        upsert detalleCRMEventos;

        Test.setCurrentPageReference(Page.aSiteEventoEdit);
        ApexPages.currentPage().getParameters().put('token', siteUserSession.Id);
        ApexPages.currentPage().getParameters().put('e', crmEvento.Id);
        ApexPages.currentPage().getParameters().put('goArchivos', '0');
        ApexPages.currentPage().getParameters().put('evento', 'Lado a Lado');

        aSiteEventosController controller = new aSiteEventosController();

        controller.tipoEvento = 'Test a campo';
        controller.validate();

        Test.startTest();
        controller.getEventoItems();
        controller.getEventoItemsNew();

        System.assertEquals(6, controller.tmpEventoItemsNew2.size());
        System.assertEquals(3, controller.tmpEventoItems2.size());

        controller.linea = 3;
        controller.agregarItem(); // BG 4377 RR

        System.assertEquals(3, controller.tmpEventoItems2.size());
        System.assertEquals('Não é permitido informar o mesmo produto mais de uma vez, com exceção do produto outros', controller.mensaje);

        controller.linea = 1;
        controller.removerItem(); // BG 4377 RR

        System.assertEquals(2, controller.tmpEventoItems2.size());

        controller.linea = 0;
        controller.agregarItem(); // Outro

        System.assertEquals(3, controller.tmpEventoItems2.size());
        System.assert(String.isEmpty(controller.mensaje));

        controller.linea = 5;
        controller.agregarItem(); // 5D6215 IPRO

        System.assertEquals(4, controller.tmpEventoItems2.size());
        System.assert(String.isEmpty(controller.mensaje));

        controller.linea = 3;
        controller.agregarItem();

        System.assertEquals(4, controller.tmpEventoItems2.size());
        System.assertEquals('É permitido informar no máximo 4 produtos', controller.mensaje);
        Test.stopTest();
    }

    @isTest static void getFaseCRMEventoTest() {
        SiteUserSession__c siteUserSession = [SELECT Id FROM SiteUserSession__c];

        CRM_Calendario_de_Eventos__c crmEvento = new CRM_Calendario_de_Eventos__c(
            Data__c = Date.today(),
            Cuenta__c = [SELECT Id FROM Account].Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Test_a_campo'].Id,
            Safra__c = '18/19',
            Marca__c = 'BRMX',
            Fase__c = 'Edição',
            Municipio__c = [SELECT Id FROM Cidade__c].Id,
            Realizado_por__c = 'Multiplicador'
        );

        insert crmEvento;

        insert new CRM_Detalle_Calendario_de_eventos__c(
            CRM_Calendario_de_eventos__c = crmEvento.Id,
            Obtentor__c = 'Nidera',
            Cultivar__c = [SELECT Id FROM Product2 WHERE Name = 'Outro'].Id,
            Produto_Principal__c = true
        );

        Test.setCurrentPageReference(Page.aSiteEventos);
        ApexPages.currentPage().getParameters().put('token', siteUserSession.Id);
        ApexPages.currentPage().getParameters().put('e', crmEvento.Id);
        ApexPages.currentPage().getParameters().put('evento', 'Lado a Lado');

        aSiteEventosController controller = new aSiteEventosController();

        controller.tipoEvento = 'Test a campo';
        controller.validate();

        Test.startTest();
        crmEvento = controller.getEventos()[0];
        CRM_Detalle_Calendario_de_eventos__c detalleCRMEvento = controller.relatedEventoItems[0];
        String fase = crmEvento.Fase__c;

        System.assertEquals('Edição', fase);
        System.assertEquals('Edição', controller.getFaseCRMEvento());

        crmEvento.Fase__c = 'Pendente';
        System.assertEquals('Aguardando validação', controller.getFaseCRMEvento());

        crmEvento.Fase__c = 'Aprovado';
        System.assertEquals('Aprovado', controller.getFaseCRMEvento());

        detalleCRMEvento.Data_de_plantio__c = Date.today().addDays(-30);
        System.assertEquals('Aguardando resultado de colheita', controller.getFaseCRMEvento());

        crmEvento.Fase__c = 'Reprovado';
        detalleCRMEvento.Data_de_colheita__c = Date.today().addDays(30);
        System.assertEquals('Edição de dados de colheita', controller.getFaseCRMEvento());

        detalleCRMEvento.Data_de_colheita__c = null;
        System.assertEquals('Edição de dados de plantio', controller.getFaseCRMEvento());

        detalleCRMEvento.Data_de_plantio__c = Date.today().addDays(-60);
        detalleCRMEvento.Data_de_colheita__c = Date.today().addDays(-30);
        System.assertEquals('Reprovados', controller.getFaseCRMEvento());

        detalleCRMEvento.Data_de_plantio__c = Date.today().addDays(10);
        detalleCRMEvento.Data_de_colheita__c = null;
        System.assertEquals('Reprovados', controller.getFaseCRMEvento());

        controller.tipoEvento = 'Emplacamento'; // Test CRM Evento Emplacamento
        crmEvento.Fase__c = 'Edição';
        System.assertEquals('Edição', controller.getFaseCRMEvento());

        crmEvento.Fase__c = 'Pendente';
        System.assertEquals('Aguardando validação', controller.getFaseCRMEvento());

        crmEvento.Fase__c = 'Aprovado';
        System.assertEquals('Aprovado', controller.getFaseCRMEvento());

        crmEvento.Fase__c = 'Reprovado';
        System.assertEquals('Reprovados', controller.getFaseCRMEvento());
        Test.stopTest();
    }
}
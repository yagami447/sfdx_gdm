@isTest
private class CRMEventoItemsExtensionTest {

    @TestSetup static void setup() {
        Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX()
        .withPMSafraActualEventos('18/19')
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

        Estado__c estado = new Estado__c(Name = 'California');
        insert estado;

        Cidade__c ciudad = new Cidade__c(Name = 'Los Angeles', Estado__c = estado.Id);
        insert ciudad;

        CRM_Calendario_de_Eventos__c crmEvento = new CRM_Calendario_de_Eventos__c(
            Data__c = Date.today(),
            Cuenta__c = account.Id,
            Evento__c = 'Area comercial',
            Safra__c = '18/19',
            Municipio__c = ciudad.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Test a campo'].Id
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
            Produto_Principal__c = true
        );

        insert detalleCRMEvento;
    }

    @isTest static void addTest() {
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id FROM CRM_Calendario_de_Eventos__c LIMIT 1];

        Test.setCurrentPageReference(Page.addCRMEventoItems);
        ApexPages.currentPage().getParameters().put('id', crmEvento.Id);

        CRMEventoItemsExtension controller = new CRMEventoItemsExtension(new ApexPages.StandardController(crmEvento));

        Test.startTest();
        controller.updateAvailableList();

        System.assertEquals(1, controller.shoppingCart.size());
        System.assertEquals(3, controller.AvailableProducts.size());

        controller.toSelect = controller.AvailableProducts[1].Id;
        controller.addToShoppingCart();

        System.assertEquals(2, controller.shoppingCart.size());

        controller.searchString = 'Don Mario'; // search test
        controller.updateAvailableList();

        System.assertEquals(1, controller.AvailableProducts.size());
        System.assertEquals('Don Mario', controller.AvailableProducts[0].Obtentor__c);

        controller.shoppingCart[0].Produto_Principal__c = false; // produto principal test
        controller.onSave();

        System.assertEquals('Você deve especificar: um (1) produto principal', controller.mensaje);

        controller.shoppingCart[0].Produto_Principal__c = true;
        String nextPage = controller.onCancel().getUrl();

        System.assertEquals('/' + crmEvento.Id, nextPage);
        Test.stopTest();
    }

    @isTest static void removeTest() {
        CRM_Calendario_de_Eventos__c crmEvento = [SELECT Id FROM CRM_Calendario_de_Eventos__c LIMIT 1];

        Test.setCurrentPageReference(Page.addCRMEventoItems);
        ApexPages.currentPage().getParameters().put('id', crmEvento.Id);

        CRMEventoItemsExtension controller = new CRMEventoItemsExtension(new ApexPages.StandardController(crmEvento));

        Test.startTest();
        controller.updateAvailableList();

        System.assertEquals(1, controller.shoppingCart.size());
        System.assertEquals(3, controller.AvailableProducts.size());

        controller.toUnselect = String.valueOf(controller.shoppingCart[0].Indice__c);
        controller.removeFromShoppingCart();

        System.assertEquals(0, controller.shoppingCart.size());

        controller.toSelect = controller.AvailableProducts[1].Id; // SYN 1359S IPRO
        controller.addToShoppingCart();

        System.assertEquals(1, controller.shoppingCart.size());

        controller.shoppingCart[0].Produto_Principal__c = true;
        controller.shoppingCart[0].Area_plantada__c = 3.5;
        controller.shoppingCart[0].Data_de_plantio__c = Date.today().addDays(-60);
        controller.shoppingCart[0].Volume_Doado__c = 0;
        controller.onSave();

        CRM_Detalle_Calendario_de_eventos__c detalleCRMEvento = [
            SELECT Id, Obtentor__c, Cultivar__r.Name FROM CRM_Detalle_Calendario_de_eventos__c WHERE CRM_Calendario_de_eventos__c = :crmEvento.Id
        ];

        System.assertEquals('Syngenta', detalleCRMEvento.Obtentor__c);
        Test.stopTest();
    }
}
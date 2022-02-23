/**
 * @Author: Sergio Migueis - K2
 * @Description: Test class for AddCRMEventItemsController
 * @History:
 * 08/12/2019 - Creation
 * 12/11/2021 - Add getOptionCulturaAntecessoraTest
 */
@isTest
private class TestAddCRMEventItemsController {

    @isTest static void test() {
        Account acc = new Account(Name = 'Teste');
        insert acc;
        CRM_Calendario_de_Eventos__c event = new CRM_Calendario_de_Eventos__c(Name = 'Teste', Cuenta__c = acc.Id, Marca__c = 'NEOG', Evento__c = 'Emplacamento', Safra__c = '18/19');
        insert event;

        Product2 prod = new Product2(Name = 'Test');
        prod.IsActive = false;
        prod.Obtentor__c = 'Bayer';
        insert prod;
        AddCRMEventItemsController.getTheCRM(event.Id);
        AddCRMEventItemsController.getUsers();
        List<Product2> prods = AddCRMEventItemsController.getAvailableProducts(event.Id, '%');
        List<CRM_Detalle_Calendario_de_eventos__c> listas = AddCRMEventItemsController.addShoppingCart(event.Id, prods);
        AddCRMEventItemsController.saveShoppingCart(event.Id, listas);
        AddCRMEventItemsController.getShoppingCart(event.Id);
        AddCRMEventItemsController.deleteShoppingCart(event.Id, listas);
    }
}
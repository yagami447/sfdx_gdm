@isTest
public class TestDAOPricebookEntry {
    @istest public static void test(){        
        Product2 prod = new Product2();
        prod.name = 'teste';
        insert prod;

        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = prod.Id;
        pbe.UnitPrice = 0;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pbe.IsActive = true;
        insert pbe;

        
        DAOPricebookEntry.getInstance().getByFiltrosForCategoria(test.getStandardPricebookId()
                                                , null
                                                , null
                                                , null
                                                , false);
        DAOPricebookEntry.getInstance(DTOUtils.SharingMode.Without).getByFiltrosForCategoria(test.getStandardPricebookId()
                                                , null
                                                , null
                                                , null
                                                , false);

    }
}
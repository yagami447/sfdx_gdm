@isTest
public class TestDAOProduct2 {
    @istest public static void test(){     
        Product2 prod = new Product2();
        prod.name = 'teste';
        insert prod;
        
        DAOProduct2.getInstance().getBySearchString('test');
        DAOProduct2.getInstance(DTOUtils.SharingMode.Without).getBySearchString('test');
        
    }
}
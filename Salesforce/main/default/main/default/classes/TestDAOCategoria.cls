@IsTest
public class TestDAOCategoria {
    @isTest
    public static void testEvents(){
        Categoria__c cat = new Categoria__c(Name = 'Test');
        insert cat;

        
        DAOCategoria.getInstance().getAll();
        DAOCategoria.getInstance(DTOUtils.SharingMode.Without).getAll();

        
        DAOCategoria.getInstance().getBasedOnNamesForOpportunity();
        DAOCategoria.getInstance(DTOUtils.SharingMode.Without).getBasedOnNamesForOpportunity();
        
        
    }
}
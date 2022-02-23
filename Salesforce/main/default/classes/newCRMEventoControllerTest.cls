@IsTest(SeeAllData=false)
private class newCRMEventoControllerTest {

    static testMethod void oppUnitTest() {
        newCRMEventoController b_obj = new newCRMEventoController();
        
        ApexPages.currentPage().getParameters().put('tipo_crm','Previsao');
        
        b_obj.nuevoEvento();
    }
    
    static testMethod void gralUnitTest() {
        newCRMEventoController b_obj = new newCRMEventoController();
                        
        Profile p = [SELECT Id FROM Profile WHERE Name='Usuario estándar'];
        UserRole r_c = [SELECT Id FROM UserRole WHERE Name='Comercial R1 BRMX'];
        UserRole r_p = [SELECT Id FROM UserRole WHERE Name='Gerencia Producción'];
        
        //Funcion Comercial
        User u = new User(Alias = 'ejemp', Email='prueba@brx.com', EmailEncodingKey='UTF-8', 
        LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='Comercial_2le@test.com', UserRoleId = r_c.Id);
        
        System.runAs(u) {
            b_obj.redirectNewEvento();
        }               
    }    
}
@IsTest(SeeAllData=false)
private class newOppControllerTest {

    static testMethod void oppUnitTest() {
        newOppController b_obj = new newOppController();
        
        ApexPages.currentPage().getParameters().put('tipo_opp','Previsao');        
        b_obj.nuevaOpp();        
        ApexPages.currentPage().getParameters().put('tipo_opp','Anexo I');
        b_obj.nuevaOpp();        
        ApexPages.currentPage().getParameters().put('tipo_opp','PB-Comercial');
        b_obj.nuevaOpp();
        
        
    }
    
    static testMethod void gralUnitTest() {
        newOppController b_obj = new newOppController();
                        
        Profile p = [SELECT Id FROM Profile WHERE Name='Usuario estándar' OR Name='Standard User' LIMIT 1];
        UserRole r_c = [SELECT Id FROM UserRole WHERE Name='Comercial R1 BRMX'];
        UserRole r_p = [SELECT Id FROM UserRole WHERE Name='Gerencia Producción'];
        
        //Funcion Comercial
        User u = new User(Alias = 'ejemp', Email='prueba@brx.com', EmailEncodingKey='UTF-8', 
        LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='Comercial_le@test.com', UserRoleId = r_c.Id);
        
        System.runAs(u) {
          Integer acceso = b_obj.getFull();
            System.AssertEquals(acceso,1);
            b_obj.redirectNewOpp();
        }
        
        u.UserRoleId = r_p.Id;  //Funcion Produccion
        update u;        
        System.runAs(u) {
          Integer acceso = b_obj.getFull();
            System.AssertEquals(acceso,2);
        }
    }
    
}
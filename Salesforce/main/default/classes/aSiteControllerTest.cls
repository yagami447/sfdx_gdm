/**
 * Clase test de todos los controllers del sitio portal
 */
@isTest
global with sharing class aSiteControllerTest {

    @IsTest(SeeAllData=false)
    global static void testAuthManager () {  
        Configuracion_BMX__c conf = new Configuracion_BMX__c(PM_Safra_Actual__c = '20/21');
        insert conf;      
        Account acc = new Account(Site='www.fff.com',AccountNumber='1243',Grupo_de_cuentas__c='US01 - Domestic Customers',Name='JERE', Nome_Fantasia__c = 'JRERE', CodigoSAP__c='451254'); insert acc;
        SiteUser__c su = new SiteUser__c(Email__c='jere@dm.com', Password__c='123'); insert su;
        SiteUserAccount__c suacc = new SiteUserAccount__c(SiteUser__c=su.Id,Account__c=acc.Id, Active__c=true); insert suacc;
        SiteUserSession__c susess = new SiteUserSession__c(Marca__c='BRMX', Safra__c='16/17',SiteUser__c=su.Id); insert susess;
        aSiteAuthManager.ForgotPassword(su.Email__c);

        aSiteAuthManager.RefreshUserSession(susess.Id);
        aSiteAuthManager.OpenUserSession(su.id, '123', 'company');
        
    }
    
    @IsTest(SeeAllData=false)
    global static void testContractController () {
        Account acc = new Account(Site='www.fff.com',AccountNumber='1243',Grupo_de_cuentas__c='US01 - Domestic Customers',Name='JERE', Nome_Fantasia__c = 'JRERE', CodigoSAP__c='451254'); insert acc;
        SiteUser__c su = new SiteUser__c(Email__c='jere@dm.com', Password__c='123'); insert su;
        SiteUserAccount__c suacc = new SiteUserAccount__c(SiteUser__c=su.Id,Account__c=acc.Id, Active__c=true); insert suacc;
        SiteUserSession__c susess = new SiteUserSession__c(Marca__c='BRMX', Safra__c='16/17',SiteUser__c=su.Id); insert susess;
        Contrato__c cont = new Contrato__c(Multiplicador__c=acc.Id, Safra__c='16/17',Sociedad__c='BRMX'); insert cont;
        
        aSiteContractController controller = new aSiteContractController();
        controller.validate();

        PageReference pageRef = Page.aSiteContracts;
        pageRef.getParameters().put('token',susess.Id);
        Test.setCurrentPageReference(pageRef);
        controller.validate();
        controller.getContracts();
        controller.setActiveContract();
        controller.getUser();
        controller.getAccount();
}

    @IsTest(SeeAllData=false)
    global static void testProfileController () {
        Account acc = new Account(Site='www.fff.com',AccountNumber='1243',Grupo_de_cuentas__c='US01 - Domestic Customers',Name='JERE', Nome_Fantasia__c = 'JRERE', CodigoSAP__c='451254'); insert acc;
        SiteUser__c su = new SiteUser__c(Email__c='jere@dm.com', Password__c='123'); insert su;
        SiteUserAccount__c suacc = new SiteUserAccount__c(SiteUser__c=su.Id,Account__c=acc.Id, Active__c=true); insert suacc;
        SiteUserSession__c susess = new SiteUserSession__c(Marca__c='BRMX', Safra__c='16/17',SiteUser__c=su.Id); insert susess;

        aSiteProfileController controller = new aSiteProfileController();
        controller.validate();

        PageReference pageRef = Page.aSiteProfile;
        pageRef.getParameters().put('token',susess.Id);
        Test.setCurrentPageReference(pageRef);
        controller.validate();

        controller.getAccounts();
        controller.accSelect=suacc.Id;
        controller.setActiveAccount();
        controller.getUser();
        
        controller.getAccounts();
        controller.editProfile();
        controller.editCancel();
        controller.saveProfile();
    }

    @IsTest(SeeAllData=false)
    global static void testHomeHeaderController () {
        Account acc = new Account(Site='www.fff.com',AccountNumber='1243',Grupo_de_cuentas__c='US01 - Domestic Customers',Name='JERE', Nome_Fantasia__c = 'JRERE', CodigoSAP__c='451254'); insert acc;
        SiteUser__c su = new SiteUser__c(Email__c='jere@dm.com', Password__c='123'); insert su;
        SiteUserAccount__c suacc = new SiteUserAccount__c(SiteUser__c=su.Id,Account__c=acc.Id, Active__c=true); insert suacc;
        SiteUserSession__c susess = new SiteUserSession__c(Marca__c='BRMX', Safra__c='16/17',SiteUser__c=su.Id); insert susess;

        aSiteHomeController controller0 = new aSiteHomeController();
        controller0.validate();
                        
        PageReference pageRef = Page.aSiteHome;
        pageRef.getParameters().put('token',susess.Id);      
        Test.setCurrentPageReference(pageRef);

        controller0.validate();
        controller0.getUser();

        pageRef = Page.aSiteAppendix2; // new PageReference('/aSiteAppendix2');
        pageRef.getParameters().put('token',susess.Id);      
        Test.setCurrentPageReference(pageRef);

        aSiteHeaderController controller = new aSiteHeaderController();
        controller.getUser();
        controller.gotoDashboard();
        
        controller.gotoProfile();
        //controller.gotoAppend1();
        //controller.gotoAppend1Rebaja();
        //controller.gotoAppend2();
        //controller.gotoAppend2Rebaja();
        
        controller.gotoSalesReport();
        controller.gotoContract();
        
        controller.closeSession();
                
    }

    @IsTest(SeeAllData=false)
    global static void testPasswordController () {
        aSiteForgotPassController controller = new aSiteForgotPassController();
        controller.forgotPassword();

        Account acc = new Account(Site='www.fff.com',AccountNumber='1243',Grupo_de_cuentas__c='US01 - Domestic Customers',Name='JERE', Nome_Fantasia__c = 'JRERE', CodigoSAP__c='451254'); insert acc;
        SiteUser__c su = new SiteUser__c(Email__c='jere@dm.com', Password__c='123456'); insert su;
        SiteUserAccount__c suacc = new SiteUserAccount__c(SiteUser__c=su.Id,Account__c=acc.Id, Active__c=true); insert suacc;
        SiteUserSession__c susess = new SiteUserSession__c(Marca__c='BRMX', Safra__c='16/17',SiteUser__c=su.Id); insert susess;
        
        controller.username = 'test@salesforce.com';
        controller.forgotPassword();
        

        PageReference pageRef = new PageReference('/aSiteChangePass');
        pageRef.getParameters().put('token',susess.Id);
        Test.setCurrentPageReference(pageRef);
        
        aSiteChangePassController controller1 = new aSiteChangePassController();
        controller1.validate();
        controller1.ChangePassword();
        controller1.oldpassword = '123456';
        controller1.ChangePassword();
        controller1.newpassword = '123';
        controller1.ChangePassword();
        controller1.verifynewpassword = '123';
        controller1.ChangePassword();
    }
    
    @IsTest(SeeAllData=false)
    global static void testLoginController () {
        aSiteLoginController controller = new aSiteLoginController ();
        System.assertEquals(controller.login(),null);
        controller.username = 'test@salesforce.com';
        System.assertEquals(controller.login(),null);
        controller.password = '123456';                
        System.assertEquals(controller.login(),null);

        Account acc = new Account(Site='www.fff.com',AccountNumber='1243',Grupo_de_cuentas__c='US01 - Domestic Customers',Name='JERE', Nome_Fantasia__c = 'JRERE', CodigoSAP__c='451254'); insert acc;
        SiteUser__c su = new SiteUser__c(Email__c='test@salesforce.com', Password__c='123456'); insert su;
        SiteUserAccount__c suacc = new SiteUserAccount__c(SiteUser__c=su.Id,Account__c=acc.Id, Active__c=true); insert suacc;
        
        controller.login();
        su.Cadastro_pela_primeira_vez__c = true; update su;
        controller.login();
        controller.closeSession();
    }        

    @isTest
    global static void testPasswordControllerWithoutToken () {
        aSiteForgotPassController controller = new aSiteForgotPassController();
        controller.forgotPassword();

        Account acc = new Account(Site='www.fff.com',AccountNumber='1243',Grupo_de_cuentas__c='US01 - Domestic Customers',Name='JERE', Nome_Fantasia__c = 'JRERE', CodigoSAP__c='451254'); insert acc;
        SiteUser__c su = new SiteUser__c(Email__c='jere@dm.com', Password__c='123456'); insert su;
        SiteUserAccount__c suacc = new SiteUserAccount__c(SiteUser__c=su.Id,Account__c=acc.Id, Active__c=true); insert suacc;
        SiteUserSession__c susess = new SiteUserSession__c(Marca__c='BRMX', Safra__c='16/17',SiteUser__c=su.Id); insert susess;
        
        controller.username = 'test@salesforce.com';
        controller.forgotPassword();
        

        PageReference pageRef = new PageReference('/aSiteChangePass');
      
        Test.setCurrentPageReference(pageRef);
        
        aSiteChangePassController controller1 = new aSiteChangePassController();
        controller1.validate();
        controller1.ChangePassword();
        controller1.oldpassword = '123456';
        controller1.ChangePassword();
        controller1.newpassword = '123';
        controller1.ChangePassword();
        controller1.verifynewpassword = '123';
        controller1.ChangePassword();
    }
  }
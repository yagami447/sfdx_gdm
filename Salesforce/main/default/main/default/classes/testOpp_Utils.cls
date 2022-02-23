/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testOpp_Utils {

    static void test() {
            
        Product2 px1 = new Product2(Name = 'Test 1', Especie__c = 'SOJA');//BORRAR
        insert px1;
        //////Product2 px2 = new Product2(Name = 'Test 1', tipo__c = 'SEM', Especie__c = 'TRIGO');
        Product2 px2 = new Product2(Name = 'Test 1', Especie__c = 'TRIGO');//BORRAR
        insert px2;
        
        Pricebook2 s = [select ID from Pricebook2 where IsStandard = TRUE];
        PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px1.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbesx;
        PricebookEntry pbesx2 = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px2.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
        insert pbesx2;
        
        //////Opportunity o = new Opportunity(Name = 'Test 1', Tipo__c = 'ZPLO - PEDIDO CON PAGO EN ESPECIE', CloseDate = System.today(), StageName = 'Clientes potenciales');
        //BORRAR
        Opportunity o = new Opportunity(Name = 'COPIA 154', CloseDate = System.today(), StageName = 'Clientes potenciales');
        //BORRAR
        test.starttest();
        insert o;
        OpportunityLineItem opli1 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 10, quantity = 1);
        insert opli1;
        OpportunityLineItem opli2 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx2.id, unitPrice = 10, quantity = 1); 
        insert opli2;
        test.stoptest();
        
        Opp_Utils.DuplicarPedido (o.Id);
        
    }
    @isTest(SeeAllData=true)
    static void test2() {
            
        Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
        RecordType rt_prev = [Select Id From RecordType Where Name = 'Stock Multiplicadores' And SObjectType = 'Opportunity' limit 1];
        Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Opportunity prevision = New Opportunity(RecordTypeId=rt_prev.Id, Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='14/15', Mes__c = 'Março');
        insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id, Semente_aprovada__c=50,Semente_comercializada__c=50);
        insert oi2;
        
        //proximoStockMult(prevision.Id);
        
        Opp_Utils.proximaOpp(prevision.Id);
        
        RecordType rt = [Select Id From RecordType Where Name = 'Objetivo Ventas Royalties' limit 1];
        prevision.RecordTypeId = rt.Id;
        prevision.Safra__c = '12/13';
        prevision.Control_Stock_Multiplicadores__c = null;
        test.starttest();
        //update prevision;
        test.stoptest();
        //proximaOpp(prevision.Id);
        
    }
    @isTest(SeeAllData=true)
    static void test3() {
                
        Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
        RecordType rt_prev = [Select Id From RecordType Where Name = 'VB - Autorizada' And SObjectType = 'Opportunity' limit 1];
        Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Opportunity prevision = New Opportunity(RecordTypeId=rt_prev.Id, Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='14/15', Mes__c = 'Março');
        insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=20,TotalPrice=10,PricebookEntryId=pbe.Id, Semente_aprovada__c=50,Semente_comercializada__c=50);
        insert oi2;
        
        Opp_Utils.validarPasoVBSAP(prevision.Id);
    }
    @isTest(SeeAllData=true)
    static void test4() {
                
        Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
        RecordType rt_prev = [Select Id From RecordType Where Name = 'VB - Autorizada' And SObjectType = 'Opportunity' limit 1];
        Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Opportunity prevision = New Opportunity(RecordTypeId=rt_prev.Id, Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='14/15', Mes__c = 'Março');
        insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=20,TotalPrice=10,PricebookEntryId=pbe.Id, Semente_aprovada__c=50,Semente_comercializada__c=50, Base_de_Calculo__c= 40.0, Tasas__c=12.0);
        insert oi2;
        
        Opp_Utils.validarPasoVBSAP(prevision.Id);
        
        Opp_Utils.mapaMensajes2(oi2, 1, 2, 3, 4, 5, 6, 7, 8);
        Opp_Utils.mapaMensajes2(oi2, 2, 1, 3, 4, 5, 6, 7, 8);
        Opp_Utils.mapaMensajes2(oi2, 2, 1, 3, 4, 5, 8, 7, 6);
        Opp_Utils.mapaMensajes2(oi2, 2, 1, 3, 4, 5, 6, 7, 8);
        
        Opp_Utils.getSiguienteMes('Janeiro');
        Opp_Utils.getSiguienteMes('Fevereiro');
        Opp_Utils.getSiguienteMes('Abril');
        Opp_Utils.getSiguienteMes('Maio');
        Opp_Utils.getSiguienteMes('Junho');
        Opp_Utils.getSiguienteMes('Julho');
        Opp_Utils.getSiguienteMes('Agosto');
        Opp_Utils.getSiguienteMes('Setembro');
        Opp_Utils.getSiguienteMes('Outubro');
        Opp_Utils.getSiguienteMes('Novembro');
        
        Opp_Utils.actualizarPasoVBSAP(prevision.Id, true);
        
        Contact con = [Select Id from contact limit 1];
        User us = [Select Id from user limit 1];
        
        Opp_Utils.notificacionContacto(con.Id, us.Id);
        
    }
    
    @isTest(SeeAllData=true)
    static void test5() {
        /*
        Account o = [Select Id From Account limit 1];
        
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';      
        cv.VersionData =beforeblob;                
        insert cv;         

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=o.id;
        contentlink.ContentDocumentId=testContent.ContentDocumentId;
        contentlink.ShareType= 'V';        
        contentlink.Visibility = 'AllUsers';
         
        insert contentlink;
        */
        Account acct = new Account(Name='TEST_ACCT');
        insert acct;
		
		ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content')
            
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;        
        
        delete cdl;
        delete documents[0];
    }
}
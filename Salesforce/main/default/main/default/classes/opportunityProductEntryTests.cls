@istest (seeAllData=true)
private class opportunityProductEntryTests {

    static testMethod void theTests(){              
        
        Test.startTest();
        
        // You really should create test data, but I'm going to query instead
        // It's my best shot of avoiding a test failure in most orgs
        // Once you've installed this package though, you might want to write your own tests
        // or at least customize these ones to make them more applicable to your org
        Pricebook2 pb = [SELECT Id FROM Pricebook2 where Name = 'Lista Canal Multiplicadores' limit 1];   
        OpportunityLineItem oli = [select Id, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem WHERE PricebookEntry.Pricebook2Id = :pb.Id limit 1];
               
                
        ////////////////////////////////////////
        //  test opportunityProductEntry
        ////////////////////////////////////////
        
        // load the page       
        PageReference pageRef = Page.opportunityProductEntry;
        pageRef.getParameters().put('Id',oli.OpportunityId);
        Test.setCurrentPageReference(pageRef);
        
        // load the extension
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(oli.Opportunity));

        oPEE.searchString = 'michaelforce is a hip cat';
        oPEE.setforcePricebookSelection(false);
        oPEE.priceBookCheck();
        oPEE.updateAvailableList();
        oPEE.getOptionCategoria();
        oPEE.setforcePricebookSelection(true);
        oPEE.priceBookCheck();
        
        //test remove from shopping cart
        oPEE.toUnselect = oli.PricebookEntryId;
        oPEE.removeFromShoppingCart();
        //system.assert(oPEE.shoppingCart.size()==startCount-1);
        
        //test save and reload extension
        oPEE.onSave();
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(oli.Opportunity));
        //system.assert(oPEE.shoppingCart.size()==startCount-1);
        
        // test search again, this time we will find something
        oPEE.searchString = oli.PricebookEntry.Name;
        oPEE.updateAvailableList();
        //system.assert(oPEE.AvailableProducts.size()>0);       

        // test save method - WITHOUT quanitities and amounts entered and confirm that error message is displayed
        oPEE.onSave();
        
        // add required info and try save again
        for(OpportunityLineItem o : oPEE.ShoppingCart){
            o.quantity = 5;
            o.unitprice = 300;
        }
        oPEE.onSave();
        
        // query line items to confirm that the save worked
        opportunityLineItem[] oli2 = [select Id from opportunityLineItem where OpportunityId = :oli.OpportunityId];

        //oPEE.getDespachoItems();
        
        Test.stopTest();
        
    }
    @isTest(SeeAllData=true)
    public static void theTests2(){
        
                
        Pricebook2 pb = [SELECT Id FROM Pricebook2 where Name = 'Lista Canal Multiplicadores' limit 1];
        OpportunityLineItem oli = [select Id, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem WHERE PricebookEntry.Pricebook2Id = :pb.Id limit 1];
        
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(oli.Opportunity));
        
        Map<String,Id> cat = New Map<String,Id>();
        for(Categoria__c cate : [SELECT Id, Name FROM Categoria__c])
            cat.put(cate.Name, cate.Id);
            
        Map<String,Id> rtype = New Map<String,Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
          rtype.put(reTy.Name, reTy.Id);
        
        Local__c l = new Local__c(Name='Locl2'); insert l;
        
        Account cuenta = [Select Id From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
        Pricebook2 pb1 = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Opportunity prevision = New Opportunity(RecordTypeId=rtype.get('Previsao'), Name='Previsao', AccountId = cuenta.Id,Local_de_Entrega__c=l.Id, Pricebook2Id=pb1.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb1.Id and isActive = true and Product2.Categ__c = :cat.get('BASICA') limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Local_de_Entrega__c=l.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi2;
        
         oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(prevision));
        //System.assert(oPEE.priceBookCheck()!=null);
        //oPEE.getFields();
        oPEE.toSelect = oPEE.AvailableProducts[0].Id;
        oPEE.addToShoppingCart();
        oPEE.onSave();

        Opportunity prevision2 = New Opportunity(RecordTypeId=rtype.get('Previsao'), Name='Previsao2', AccountId = cuenta.Id, CloseDate=System.today(), Marca__c='DSEM',StageName='Aberta', Safra__c='12/13');
        insert prevision2;

       
        
         oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(prevision2));
        //oPEE.getFields();
        prevision2.RecordTypeId = rtype.get('Stock Multiplicadores');
        update prevision2;
        
        /*
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(prevision2));
        oPEE.getFields();
        prevision2.RecordTypeId = rtype.get('Anexo II');
        Test.startTest();
        update prevision2;
        
        prevision2.RecordTypeId = rtype.get('Anexo III');
        update prevision2;
        OpportunityLineItem oi32 = new OpportunityLineItem(OpportunityId=prevision2.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi32;
        
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(prevision2));        
        oPEE.updateAvailableList();
        
        Test.stopTest();         
        */
     
    }
    static testMethod void theTests3(){
        
        Test.startTest();
        
        Map<String,Id> rtype = New Map<String,Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
          rtype.put(reTy.Name, reTy.Id);        
        
        Pricebook2 pb = [SELECT Id FROM Pricebook2 where Name = 'Lista Canal Multiplicadores' limit 1];
        OpportunityLineItem oli = [select Id, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem WHERE PricebookEntry.Pricebook2Id = :pb.Id limit 1];
        
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(oli.Opportunity));
        
        
        Opportunity newOpp = new Opportunity(Name='New Opp',RecordTypeId=rtype.get('Anexo I'),stageName='Pipeline',Amount=10,closeDate=System.Today()+30,AccountId=oli.Opportunity.AccountId);
        insert(newOpp);
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newOpp));

        System.assert(oPEE.onCancel()!=null);
        Map<String,Id> cat = New Map<String,Id>();
        for(Categoria__c cate : [SELECT Id, Name FROM Categoria__c])
            cat.put(cate.Name, cate.Id);            

        
        Account cuenta = [Select Id From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
        Pricebook2 pb1 = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        //Opportunity prevision = New Opportunity(RecordTypeId=rtype.get('Previsao'), Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb1.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        //insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb1.Id and isActive = true and Product2.Categ__c = :cat.get('BASICA') limit 1];


        Opportunity prevision2 = New Opportunity(RecordTypeId=rtype.get('Anexo I Rebaixamento Ha'), Name='Previsao2', AccountId = cuenta.Id, CloseDate=System.today(), Marca__c='DSEM',StageName='Aberta', Safra__c='12/13', Anexo_Relacionado__c = newOpp.Id);
        insert prevision2;
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(prevision2));
        oPEE.getFields();
        oPEE.getTipoNecesidad();
                    
        Test.stopTest();
     
    }
    static testMethod void theTests4(){
        
        Test.startTest();
        
        Map<String,Id> rtype = New Map<String,Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
          rtype.put(reTy.Name, reTy.Id);        
        
        Pricebook2 pb1 = [SELECT Id FROM Pricebook2 where Name = 'Lista Canal Multiplicadores' limit 1];
        Account cuenta = [Select Id From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
        
        Opportunity newOpp = new Opportunity(Name='New Opp',RecordTypeId=rtype.get('Anexo I'),StageName='Aprobada',Amount=10,closeDate=System.Today()+30,AccountId=cuenta.Id);
        insert(newOpp);
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newOpp));

        System.assert(oPEE.onCancel()!=null);
        Map<String,Id> cat = New Map<String,Id>();
        for(Categoria__c cate : [SELECT Id, Name FROM Categoria__c])
            cat.put(cate.Name, cate.Id);
           

        
        
        //Pricebook2 pb1 = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX 2' and isActive = true limit 1];
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb1.Id and isActive = true and Product2.Categ__c = :cat.get('BASICA') limit 1];
        OpportunityLineItem oliNewOpp = new OpportunityLineItem(OpportunityId=newOpp.Id,Quantity=0.01,TotalPrice=10,PricebookEntryId=pbe.Id, Categoria__c = cat.get('C1'), Area__c=50.00);
        insert oliNewOpp;
        Opportunity prevision2 = New Opportunity(RecordTypeId=rtype.get('Anexo I Rebaixamento Ha'), Name='Previsao2', AccountId = cuenta.Id, CloseDate=System.today(), Marca__c='DSEM',StageName='Aberta', Safra__c='12/13', Anexo_Relacionado__c = newOpp.Id);
        insert prevision2;
        OpportunityLineItem anexoRoli2 = new OpportunityLineItem(OpportunityId=prevision2.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id, Categoria__c = cat.get('C1'), Categoria_a_Rebaixar__c = cat.get('C2'), Area__c=10.00);
        insert anexoRoli2;

        OpportunityLineItem oliprueba =  [SELECT Id, OpportunityId,PricebookEntry.Product2Id, PricebookEntry.Product2.Variedade__r.Name, Area__c, Categoria__c, Categoria_a_Rebaixar__c,Sem_Rebajada__c FROM OpportunityLineItem WHERE Id=:anexoRoli2.Id];
        
        oPEE.validarRebajaAnexoI(New List<OpportunityLineItem> {oliprueba});
        
        oliprueba.Area__c = 100;
        update oliprueba;
        
        OpportunityLineItem oliprueba2 =  [SELECT Id, OpportunityId,PricebookEntry.Product2Id, PricebookEntry.Product2.Variedade__r.Name, Area__c, Categoria__c, Categoria_a_Rebaixar__c,Sem_Rebajada__c FROM OpportunityLineItem WHERE Id=:anexoRoli2.Id];
        
        oPEE.validarRebajaAnexoI(New List<OpportunityLineItem> {oliprueba2});

        Test.stopTest();
     
    }
    
    static testMethod void theTests5(){    
        
        Map<String,Id> rtype = New Map<String,Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
          rtype.put(reTy.Name, reTy.Id);        
        
        Pricebook2 pb1 = [SELECT Id FROM Pricebook2 where Name = 'Lista Canal Multiplicadores' limit 1];
        Account cuenta = [Select Id From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
        Opportunity newOpp1 = new Opportunity(Name='New Opp',RecordTypeId=rtype.get('Anexo I'),StageName='Aprobada',Amount=10,closeDate=System.Today()+30,AccountId=cuenta.Id);
        insert(newOpp1);
        
        Opportunity newOpp = new Opportunity(Name='New Opp',RecordTypeId=rtype.get('Anexo II'),StageName='Aprobada',Amount=10,closeDate=System.Today()+30,AccountId=cuenta.Id);
        insert(newOpp);
        //opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newOpp));

        //System.assert(oPEE.onCancel()!=null);
        Map<String,Id> cat = New Map<String,Id>();
        for(Categoria__c cate : [SELECT Id, Name FROM Categoria__c])
            cat.put(cate.Name, cate.Id);
                  
        
        //Pricebook2 pb1 = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX 2' and isActive = true limit 1];
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb1.Id and isActive = true and Product2.Categ__c = :cat.get('BASICA') limit 1];
        OpportunityLineItem oliNewOpp1 = new OpportunityLineItem(OpportunityId=newOpp1.Id,Quantity=0.01,TotalPrice=10,PricebookEntryId=pbe.Id, Categoria__c = cat.get('C1'), Area__c=50.00);
        insert oliNewOpp1;
        
        OpportunityLineItem oliNewOpp = new OpportunityLineItem(OpportunityId=newOpp.Id,Quantity=0.01,TotalPrice=10,PricebookEntryId=pbe.Id, Categoria__c = cat.get('C1'), Semente_Bruta__c=50.00);
        insert oliNewOpp;
        Opportunity prevision2 = New Opportunity(RecordTypeId=rtype.get('Anexo II Rebaixamento Sacas'), Name='Previsao2', AccountId = cuenta.Id, CloseDate=System.today(), Marca__c='DSEM',StageName='Aberta', Safra__c='12/13', Anexo_Relacionado__c = newOpp.Id);
        insert prevision2;
        OpportunityLineItem anexoRoli2 = new OpportunityLineItem(OpportunityId=prevision2.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id, Categoria__c = cat.get('C1'), Categoria_a_Rebaixar__c = cat.get('C2'), Sem_Rebajada__c=10.00);
        insert anexoRoli2;

        OpportunityLineItem oliprueba =  [SELECT Id, OpportunityId,PricebookEntry.Product2Id, PricebookEntry.Product2.Variedade__r.Name,  Area__c, Sem_Rebajada__c, Semente_Bruta__c, Categoria__c, Categoria_a_Rebaixar__c FROM OpportunityLineItem WHERE Id=:anexoRoli2.Id];
        
        //opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(prevision2));
        
        /*
        oPEE.validarRebajaAnexoI(New List<OpportunityLineItem> {oliprueba});
        
        oliprueba.Categoria_a_Rebaixar__c = cat.get('S1');
        test.starttest();
        update oliprueba;
        
        
        OpportunityLineItem oliprueba2 =  [SELECT Id, OpportunityId,PricebookEntry.Product2Id, PricebookEntry.Product2.Variedade__r.Name, Area__c, Sem_Rebajada__c, Semente_Bruta__c, Categoria__c, Categoria_a_Rebaixar__c FROM OpportunityLineItem WHERE Id=:anexoRoli2.Id];
        
        oPEE.validarRebajaAnexoI(New List<OpportunityLineItem> {oliprueba2});                     
     
        Test.stopTest();
        */
     
    }
    static testMethod void theTests6(){
        
        Test.startTest();
        
        Map<String,Id> rtype = New Map<String,Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
          rtype.put(reTy.Name, reTy.Id);        
        
        Map<String,Id> cat = New Map<String,Id>();
        for(Categoria__c cate : [SELECT Id, Name FROM Categoria__c])
            cat.put(cate.Name, cate.Id);
            

        
        Account cuenta = [Select Id From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
        Pricebook2 pb1 = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        //Opportunity prevision = New Opportunity(RecordTypeId=rtype.get('Previsao'), Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb1.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        //insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb1.Id and Product2.Semilla_Tratada__c = false AND isActive = true and Product2.Categ__c = :cat.get('BASICA') limit 1];
        
        Opportunity opVB = New Opportunity(RecordTypeId=rtype.get('VB - Pendiente'), Name='Prueba1', AccountId = cuenta.Id,Pricebook2Id=pb1.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert opVB;
        OpportunityLineItem oi4 = new OpportunityLineItem(OpportunityId=opVB.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi4;
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(opVB));

        oPEE.shoppingCart[0].Categoria__c = cat.get('C1');
        oPEE.onSave();
              
     
        Test.stopTest();
        
        List<OpportunityLineItem> itms = [Select Id, Id_Item_de_Oportunidad_Relacionado__c From OpportunityLineItem Where Id_Item_de_Oportunidad_Relacionado__c != null limit 1];
        oPEE.validarOfertaSAP(itms);
     
    }
    
    static testMethod void theTestsPendiente(){    
        Estado__c estado = new Estado__c(Name='PR'); insert estado;
        Centro_Logistico__c centro = new Centro_Logistico__c(Codigo_SAP__c='20442',Name='Londrina', Estado__c=estado.Id); insert centro;
         
        Map<String,Id> rtype = New Map<String,Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
          rtype.put(reTy.Name, reTy.Id);        
        
        Pricebook2 pb1 = [SELECT Id FROM Pricebook2 where Name = 'Lista Canal Multiplicadores' limit 1];
        Account cuenta = [Select Id From Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' limit 1];
        Opportunity newOpp1 = new Opportunity(Name='New Opp',Origen__c=centro.Id,RecordTypeId=rtype.get('Pendiente'),StageName='Pendiente',Amount=10,closeDate=System.Today()+30,AccountId=cuenta.Id);
        insert(newOpp1);
        
        Opportunity newDSEM = new Opportunity(Name='New Opp',Marca__c='DSEM',Origen__c=centro.Id,RecordTypeId=rtype.get('Pendiente'),StageName='Pendiente',Amount=10,closeDate=System.Today()+30,AccountId=cuenta.Id);
        insert(newDSEM);
         
        Map<String,Id> cat = New Map<String,Id>();
        for(Categoria__c cate : [SELECT Id, Name FROM Categoria__c])
            cat.put(cate.Name, cate.Id);
           
        test.starttest();

        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newDSEM));
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newOpp1));
         
        //Pricebook2 pb1 = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX 2' and isActive = true limit 1];
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb1.Id and isActive = true and Product2.Categ__c = :cat.get('BASICA') limit 1];
        OpportunityLineItem oliNewOpp1 = new OpportunityLineItem(OpportunityId=newOpp1.Id,Quantity=0.01,TotalPrice=10,PricebookEntryId=pbe.Id, Categoria__c = cat.get('C1'), Area__c=50.00);
        insert oliNewOpp1;
        
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newOpp1));
      
        Test.stopTest();
     
    }
    
}
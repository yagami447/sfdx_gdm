@isTest
private class testContratoTrigger {

    static testMethod void updateTest() {
        RecordType rt = [Select Id, Name From RecordType Where sObjectType = 'Contrato__c' and Name = 'BRMX' limit 1];
        Id PriceBook2Id = Test.getStandardPricebookId();
        Product2 newProd = new Product2(Name='test',Sociedad__c='BRMX',family='family'); insert newProd;        
        Contrato__c c = new Contrato__c(RecordTypeId=rt.Id,Safra__c='15/16',Sociedad__c='BRMX'); insert c;
        Item_del_Contrato__c i = new Item_del_Contrato__c(Contrato_de_Multiplicacion__c=c.Id, Cultivar__c=newProd.Id); insert i;
        
        system.assertNotEquals(null,c.Id);
        
        try{
            c.Tipo_de_Cota_o__c = 'DOLAR';
            update c;
        }
        catch(Exception e){}        
    }
    
    static testMethod void test1(){
    
        Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select Id, Name From RecordType])
            rt.put(reTy.Name, reTy.Id);
        
        Categoria__c cat = new Categoria__c(Name='BASICA'); insert cat;
        Product2 prd = new Product2(Name='PROD', Categ__c=cat.Id); insert prd;
        Estado__c est = new Estado__c(Name='GO'); insert est;
        Regiao__c reg = new Regiao__c(Name='GO 2'); insert reg;
        Account cuenta = new Account(Estado__c=est.Id, Name='ACME3', Region__c=reg.Id, CodigoSAP__c = '6000000001'); insert cuenta;
        Pricebook2 pb = new Pricebook2(Name='Lista Canal Multiplicadores'); insert pb;        
        Centro_Logistico__c cl = new Centro_Logistico__c(Name='CENTRO', Codigo_SAP__c='123', Estado__c=est.Id,Marca__c='BRMX',Licencias__c=false); insert cl;
        
        Opportunity o1 = new Opportunity(Name='TMPPROBANDOLASOPP',Pricebook2Id=pb.Id,AccountId=cuenta.Id,CloseDate=System.today(),StageName='Aprobada',RecordTypeId=rt.get('Anexo III'), Safra__c ='18/19', Marca__c='BRMX', Epoca_de_Plantio__c = 'Verão',Tipo__c = 'ZBSF - Venda Serviços',Origen__c=cl.Id);
        Opportunity o2 = new Opportunity(Name='TMPPROBANDOLASOPP',Pricebook2Id=pb.Id,AccountId=cuenta.Id,CloseDate=System.today(),StageName='Aprobada',RecordTypeId=rt.get('Anexo III'), Safra__c ='18/19', Marca__c='BRMX', Epoca_de_Plantio__c = 'Verão',Tipo__c = 'ZBSF - Venda Serviços',Origen__c=cl.Id);

        PricebookEntry pbest = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(),Product2Id=prd.Id,UnitPrice=12,isActive=true); insert pbest;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.id,Product2Id=prd.Id,UnitPrice=12,isActive=true); insert pbe;
        
        Contrato__c c = new Contrato__c(Multiplicador__c=cuenta.Id,Sociedad__c='BRMX', RecordTypeId = rt.get('BRMX'), Tipo_de_Cota_o__c = 'DOLAR', Safra__c = '18/19');
        insert c;
        Item_del_Contrato__c ic = new Item_del_Contrato__c(Cultivar__c=pbe.Product2Id, Contrato_de_Multiplicacion__c = c.Id);
        insert ic;
        Contrato__c adi = new Contrato__c(Multiplicador__c=cuenta.Id,Sociedad__c='BRMX', RecordTypeId = rt.get('Aditivo BRMX'), Tipo_de_Cota_o__c = 'DOLAR', Tipo_de_cambio__c = 1.45, Safra__c = '18/19');
        insert adi;
        Item_del_Contrato__c iadi = new Item_del_Contrato__c(Cultivar__c=pbe.Product2Id, Contrato_de_Multiplicacion__c = adi.Id, Quantidade__c = 10, Categoria__c = cat.Id);
        insert iadi;
        Item_del_Contrato__c iadi2 = new Item_del_Contrato__c(Cultivar__c=pbe.Product2Id, Contrato_de_Multiplicacion__c = adi.Id, Quantidade__c = 10, Categoria__c = cat.Id);
    
        PageReference pageRef = Page.Items_Contrato_Multiplicacion;
        pageRef.getParameters().put('Id',c.Id);
        pageRef.getParameters().put('nombre',c.Name);
        pageRef.getParameters().put('sociedad',c.Sociedad__c);
        
        Test.setCurrentPageReference(pageRef);

        itemsContratoMultController i = New itemsContratoMultController();
        i.init();      
        
        Id a;
        String b;
        List<SelectOption> opt = New List<SelectOption>();
        //i.setprodsBasica(opt);
        //opt = i.getprodsBasica();
        //opt = i.getproductosBasica();
        
        i.seteditItem(a);
        i.seteliminarItem(a);
        i.setidContrato(a);
        i.setsaveEditItem(a);
        i.setrecTypeContrato('BRMX');
        i.getrecTypeContrato();
        i.setMensaje('Probando');
        i.getMensaje();
        i.getProductosBasica();
        
        i.getprodsBasica();
        a = i.geteditItem();  
        a = i.geteliminarItem();
        a = i.getidContrato();
        a = i.getsaveEditItem();
        i.setnombreContrato(b);
        i.setnuevoBasica(b);
        i.seteditBasica(b);
        i.setsociedadContrato(b);
        b = i.getnombreContrato();
        b = i.getnuevoBasica();
        b = i.geteditBasica();
        b = i.getsociedadContrato();
        
        i.editarItem();
        i.cancelEditarItem();
        i.eliminarItem();
        i.addItem();
        i.saveEditItem();
        i.volver();
        
    }
 
    static testMethod void test2(){
    
        Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select Id, DeveloperName From RecordType])
            rt.put(reTy.DeveloperName, reTy.Id);


        Categoria__c cat = new Categoria__c(Name='BASICA'); insert cat;
        Variedad__c var = new Variedad__c(Name='6546RSF'); insert var;
        Product2 prd = new Product2(licenciada__c=false,Variedade__c=var.Id,Name='PROD',Family='Royalty x Basica',Categ__c=cat.Id,Sociedad__c='BRMX', isActive=true); insert prd;
        Product2 prd2 = new Product2(licenciada__c=false,Variedade__c=var.Id,Name='22 PROD',Family='Royalty x Basica',Categ__c=cat.Id,Sociedad__c='BRMX',isActive=true); insert prd2;
        Estado__c est = new Estado__c(Name='GO'); insert est;
        Regiao__c reg = new Regiao__c(Name='GO 2'); insert reg;
        Account cuenta = new Account(Estado__c=est.Id, Name='ACME3', Region__c=reg.Id, CodigoSAP__c = '6000000001',Tipo_de_referencia__c='CERRADO'); insert cuenta;
        Pricebook2 pb = new Pricebook2(Name='Lista Canal Multiplicadores'); insert pb;        
        Centro_Logistico__c cl = new Centro_Logistico__c(Name='CENTRO', Codigo_SAP__c='123', Estado__c=est.Id,Marca__c='BRMX',Licencias__c=false); insert cl;
        
        Opportunity o1 = new Opportunity(Name='TMPPROBANDOLASOPP',Pricebook2Id=pb.Id,AccountId=cuenta.Id,CloseDate=System.today(),StageName='Aprobada',RecordTypeId=rt.get('Anexo_III'), Safra__c ='18/19', Marca__c='BRMX', Epoca_de_Plantio__c = 'Verão',Tipo__c = 'ZBSF - Venda Serviços',Origen__c=cl.Id);
        Opportunity o2 = new Opportunity(Name='TMPPROBANDOLASOPP',Pricebook2Id=pb.Id,AccountId=cuenta.Id,CloseDate=System.today(),StageName='Aprobada',RecordTypeId=rt.get('Anexo_III'), Safra__c ='18/19', Marca__c='BRMX', Epoca_de_Plantio__c = 'Verão',Tipo__c = 'ZBSF - Venda Serviços',Origen__c=cl.Id);

        PricebookEntry pbest = new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(),Product2Id=prd.Id,UnitPrice=12,isActive=true); insert pbest;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pb.id,Product2Id=prd.Id,UnitPrice=12,isActive=true); insert pbe;

        Contrato__c c = new Contrato__c(Multiplicador__c=cuenta.Id,Sociedad__c='BRMX', RecordTypeId = rt.get('Termo_Aditivo'), Safra__c = '18/19');
        insert c;
        Item_del_Contrato__c ic = new Item_del_Contrato__c(Cultivar__c=pbe.Product2Id, Contrato_de_Multiplicacion__c = c.Id);
        insert ic;

        PageReference pageRef = Page.ItemsContrato2;
        pageRef.getParameters().put('Id',c.Id);
        
        Test.setCurrentPageReference(pageRef);

        Referencia_de_Preco__c r1 = new Referencia_de_Preco__c(Variedad__c=var.Id,Tipo_de_Cotacao__c='DOLAR',Tipo_de_referencia__c='CERRADO'); insert r1;
        Referencia_de_Praca__c r2 = new Referencia_de_Praca__c(Tipo_de_Cotacao__c='DOLAR',Safra__c='18/19',Conta__c=cuenta.Id); insert r2;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(c);     
        itemsContrato2Controller it = New itemsContrato2Controller(controller);
        
        it.marca='BRMX';
        it.searchString='PROD';
        it.UpdateAvailableList();
        it.onSave();
                        
        it.toUnselect = '0';
        it.removeFromShoppingCart();
        it.onSave();
        
        it.toSelect = prd.Id;
        it.addToShoppingCart();
        it.onCancel();
    }
       
}
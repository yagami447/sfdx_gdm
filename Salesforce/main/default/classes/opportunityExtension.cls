Public class opportunityExtension{

   public opportunityExtension(ApexPages.StandardController controller) {

    Opportunity opp = [SELECT id,RecordType.DeveloperName FROM Opportunity WHERE id =:apexpages.currentpage().getparameters().get('id') ];
    this.recordTypeDevName = opp.RecordType.DeveloperName;
   }

   public String searchTextAnexo {get; set;}
   public List<Opportunity> resultAnexos = new List<Opportunity>();
   public String anexo {get; set;}
   public String etapaAnexo;

   private String rt_anexoI_opps;
   private String rt_anexoII_opps;
   private String rt_anexoIII_opps;
   private String rt_anexoIV_opps;
   private String rt_anexoV_opps;
   private String rt_Previsao_opps;
   private String rt_Previsao_Cerrada_opps;
   private String rt_VB_Fc_opps;
   private String rt_VB_Pe_opps;
   private String rt_VB_Au_opps;
   private String rt_VB_Re_opps;
   private String rt_DB_opps;
   private String rt_PBC_opps;
   private String rt_PBP_opps;
   private String rt_Exp_opps;
   private String rt_Reemb_opps;
   private String rt_Descarte_opps;
   public String recordTypeDevName {get;set;}

   public void setetapaAnexo(String arg){
       etapaAnexo = arg;
   }

   public String getetapaAnexo(){
       Profile pro = [Select Name From Profile Where Id = : UserInfo.getProfileId()];       
       if (pro.Name == 'Administrador del sistema' || pro.Name == 'Gerente Administrativo')
           etapaAnexo = 'PEAP';
       if (pro.Name == 'Comercial')
           etapaAnexo = 'PEAN';    
       if (pro.Name == 'Administrativo')
           etapaAnexo = 'APR';    
   
       return etapaAnexo;
   }
   
   public opportunityExtension(){    
       searchTextAnexo = '';        
       for (RecordType rt : [Select Id, Name From RecordType Where Name in ('Anexo I','Anexo II','Anexo III', 'Anexo IV', 'Anexo V', 'Previsao', 'Previsao Cerrada', 'VB - Pasada SAP', 'VB - Pendiente', 'VB - Autorizada', 'VB - Rechazada', 'Disponibilidade da Basica', 'Exportacion', 'PB-Comercial', 'PB-Produccion', 'Reembalaje', 'Descarte')]){
           if (rt.Name == 'Anexo I')
              rt_anexoI_opps = rt.Id;
           if (rt.Name == 'Anexo II')
              rt_anexoII_opps = rt.Id;
           if (rt.Name == 'Anexo III')
              rt_anexoIII_opps = rt.Id;
           if (rt.Name == 'Anexo IV')
              rt_anexoIV_opps = rt.Id;
           if (rt.Name == 'Anexo V')
              rt_anexoV_opps = rt.Id; 
           if (rt.Name == 'Previsao')
              rt_Previsao_opps = rt.Id;
           if (rt.Name == 'Previsao Cerrada')
              rt_Previsao_Cerrada_opps = rt.Id;              
           if (rt.Name == 'VB - Pasada SAP')
              rt_VB_Fc_opps = rt.Id;
           if (rt.Name == 'VB - Pendiente')
              rt_VB_Pe_opps = rt.Id;
           if (rt.Name == 'VB - Autorizada')
              rt_VB_Au_opps = rt.Id;
           if (rt.Name == 'VB - Rechazada')
              rt_VB_Re_opps = rt.Id;
           if (rt.Name == 'Disponibilidade da Basica')
              rt_DB_opps = rt.id;
           if (rt.Name == 'PB-Comercial')
              rt_PBC_opps = rt.Id;
           if (rt.Name == 'PB-Produccion')
              rt_PBP_opps = rt.Id;
           if (rt.Name == 'Exportacion')
              rt_Exp_opps = rt.Id;
           if (rt.Name == 'Reembalaje')
              rt_Reemb_opps = rt.Id;
           if(rt.Name == 'Descarte')
              rt_Descarte_opps = rt.Id;
       }
   }
       
   public List<Opportunity> getresultAnexos() {return resultAnexos;}    
   
   public List<SelectOption> getTiposAnexos() {
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('ALL','--Todos--'));
       options.add(new SelectOption('A1','Anexo I'));
       options.add(new SelectOption('A2','Anexo II'));
       options.add(new SelectOption('A3','Anexo III'));
       options.add(new SelectOption('A4','Anexo IV'));
       options.add(new SelectOption('A5','Anexo V'));
       return options;
   }
   
   public List<SelectOption> getEtapasAnexos() {        
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('ALL','--Todas--'));
       options.add(new SelectOption('PEAN','Pendiente de Analisis'));
       options.add(new SelectOption('PEAP','Pendiente de Aprobacion'));
       options.add(new SelectOption('APR','Aprobada'));      
       
       return options;
   }
   
   public Boolean getIsRebaixamento(){
      Boolean resultado = this.recordTypeDevName == 'Anexo_I_Rebaixamento_Ha' || this.recordTypeDevName == 'Anexo_II_Rebaixamento_Sacas';
      return resultado;      
   }
   
   public void listarAnexos(){
       resultAnexos = null;
       this.searchAnexos();       
   }
   
   public void searchAnexos(){
       String s = searchTextAnexo;
       
       String qry = 'select Id, Name, Mes__c, Regiao__r.Name, VB_Franqueado__c, VB_Franqueado__r.Name, StageName, Safra__c, Estado_Facturacion__c, CloseDate, Numero_del__c, Account.Id, Account.Name, Account.Responsavel__c, RecordType.Name, LastModifiedDate, Relatorio_Relacionado__c, Relatorio_Relacionado__r.Name, Nro_Pedido_SAP__c, VB_Cidade__c, Estado_de_Produccion__c From Opportunity ';
       
       qry += 'where OwnerId != null ';
       if (anexo == 'A1')
           qry += ' and RecordTypeId = : rt_anexoI_opps ';
       if (anexo == 'A2')
           qry += ' and RecordTypeId = : rt_anexoII_opps ';
       if (anexo == 'A3')
           qry += ' and RecordTypeId = : rt_anexoIII_opps ';
       if (anexo == 'A4')
           qry += ' and RecordTypeId = : rt_anexoIV_opps ';
       if (anexo == 'A5')
           qry += ' and RecordTypeId = : rt_anexoV_opps ';        
       if (anexo == 'ALL')
           qry += ' and (RecordTypeId = : rt_anexoI_opps OR RecordTypeId = : rt_anexoII_opps OR RecordTypeId = : rt_anexoIII_opps OR RecordTypeId = : rt_anexoIV_opps OR RecordTypeId = : rt_anexoV_opps) ';
           
       if (etapaAnexo == 'PEAN')
           qry += ' and StageName = \'Pendiente de Análisis\'';    
       if (etapaAnexo == 'PEAP')
           qry += ' and StageName = \'Pendiente de Aprobación\'';    
       if (etapaAnexo == 'APR')
           qry += ' and StageName = \'Aprobada\'';                   
                       
       if(s != ''){ s = '%' + s + '%'; qry += ' and Name like : s';}
       qry += ' Order by Nro_Pedido_SAP__c, Safra__c Desc, LastModifiedDate Desc';
       resultAnexos = Database.query(qry);
   }
      
   public List<OpportunityLineItem> getItems() {
       String query = 'SELECT ';
       for(Schema.FieldSetMember f : this.getFields()) {
           query += f.getFieldPath() + ', ';
       }
       query += 'Id FROM OpportunityLineItem Where OpportunityId = \'' + apexpages.currentpage().getparameters().get('id') + '\'';
       query += ' And Item_Rebajado__c = false Order by Variedade_Prod__c';
       return Database.query(query);
   }
   
   public List<Schema.FieldSetMember> getFields() {
        Opportunity opp = [SELECT RecordType.Name, Setor__c, Oportunidad_Relacionada__r.RecordType.Name,RecordType.DeveloperName FROM Opportunity WHERE Id =: apexpages.currentpage().getparameters().get('id')];

        if (opp.RecordType.Name == 'Anexo I')
            return SObjectType.OpportunityLineItem.FieldSets.AnexoI.getFields();
        if (opp.RecordType.Name == 'Anexo II')
            return SObjectType.OpportunityLineItem.FieldSets.AnexoII.getFields();
        if (opp.RecordType.Name == 'Anexo III')
            return SObjectType.OpportunityLineItem.FieldSets.Anexo_III.getFields();  
        if (opp.RecordType.Name == 'Anexo IV')
            return SObjectType.OpportunityLineItem.FieldSets.Anexo_IV.getFields();
        if (opp.RecordType.Name == 'Anexo V')
            return SObjectType.OpportunityLineItem.FieldSets.Anexo_V.getFields();        
        if (opp.RecordType.Name == 'Pendiente')
            return SObjectType.OpportunityLineItem.FieldSets.Pendiente.getFields();    
        if (opp.RecordType.Name == 'NC - Pendiente' || opp.RecordType.Name == 'NC - Autorizada' || opp.RecordType.Name == 'NC - Rechazada')
            return SObjectType.OpportunityLineItem.FieldSets.Nota_de_Credito.getFields();    
        if (opp.RecordType.Name == 'Autorizada')
            return SObjectType.OpportunityLineItem.FieldSets.Autorizada.getFields();    
        if (opp.RecordType.Name == 'Rechazada')
            return SObjectType.OpportunityLineItem.FieldSets.Rechazada.getFields();    
        if (opp.RecordType.Name == 'Anexo I Rebaixamento Ha')           
            return SObjectType.OpportunityLineItem.FieldSets.AnexoI_Rebaixamento.getFields();    
        if (opp.RecordType.Name == 'Anexo II Rebaixamento Sacas')             
            return SObjectType.OpportunityLineItem.FieldSets.Anexo_Rebajamiento_Bolsas.getFields();
        if (opp.RecordType.Name == 'Stock Multiplicadores')
            return SObjectType.OpportunityLineItem.FieldSets.Stock_Multiplicadores.getFields();
        if (opp.RecordType.Name == 'Stock Multiplicadores Milho')
            return SObjectType.OpportunityLineItem.FieldSets.Stock_Multiplicadores_Milho.getFields();           
        if (opp.RecordType.Name == 'Previsao' || opp.RecordType.Name == 'Previsao Cerrada')
            return SObjectType.OpportunityLineItem.FieldSets.Previsao.getFields();
        if (opp.RecordType.Name == 'VB - Pendiente' || opp.RecordType.Name == 'VB - Autorizada' || opp.RecordType.Name == 'VB - Rechazada')
            return SObjectType.OpportunityLineItem.FieldSets.VB_General.getFields();
        if (opp.RecordType.Name == 'VB - Pasada SAP')
            return SObjectType.OpportunityLineItem.FieldSets.VB_SAP.getFields();
        if (opp.RecordType.Name == 'CVB Pendiente') {
            if (opp.Oportunidad_Relacionada__r.RecordType.Name == 'Venda da Basica Completo') { // relacionado a una CVB Completa
                return SObjectType.OpportunityLineItem.FieldSets.CVB_Pendiente_VB_Completa.getFields();
            } else {
                return SObjectType.OpportunityLineItem.FieldSets.CVB_Pendiente.getFields();
            }
        }
        if (opp.RecordType.Name == 'CVB Rechazada' || opp.RecordType.Name == 'CVB Autorizada') {
            if (opp.Oportunidad_Relacionada__r.RecordType.Name == 'Venda da Basica Completo') { // relacionado a una CVB Completa
                return SObjectType.OpportunityLineItem.FieldSets.CVB_Autorizada_VB_Completa.getFields();
            } else {
                return SObjectType.OpportunityLineItem.FieldSets.CVB_Autorizada.getFields();
            }
        }
        if (opp.RecordType.Name == 'Disponibilidade da Basica')
            return SObjectType.OpportunityLineItem.FieldSets.Disponibilidade_da_Basica.getFields();
        if (opp.RecordType.Name == 'PB-Comercial')
            return SObjectType.OpportunityLineItem.FieldSets.Produccion_Basica.getFields();
        if (opp.RecordType.Name == 'Exportacion')
            return SObjectType.OpportunityLineItem.FieldSets.Exportacion.getFields();
        if (opp.RecordType.Name == 'Reembalaje')
            return SObjectType.OpportunityLineItem.FieldSets.Reembalaje.getFields();
        if (opp.RecordType.Name == 'Objetivo Ventas Semilla')
            return SObjectType.OpportunityLineItem.FieldSets.Objetivo_Ventas_Semilla.getFields();
        if (opp.RecordType.Name == 'PB-Desarrollo')
            return SObjectType.OpportunityLineItem.FieldSets.Produccion_Basica_Desarrollo.getFields();
        if (opp.RecordType.Name == 'PB-Produccion' && opp.Setor__c == 'Comercial')
            return SObjectType.OpportunityLineItem.FieldSets.Produccion_Basica.getFields();
        if (opp.RecordType.Name == 'PB-Produccion' && opp.Setor__c == 'Desarrollo')
            return SObjectType.OpportunityLineItem.FieldSets.Produccion_Basica_Desarrollo.getFields();  
        if (opp.RecordType.Name == 'PB-Oferta')
            return SObjectType.OpportunityLineItem.FieldSets.Produccion_Basica_Oferta.getFields();  
        if (opp.RecordType.Name == 'Objetivo Ventas Royalties')
            return SObjectType.OpportunityLineItem.FieldSets.Objetivo_Ventas_Royalties.getFields();
        if (opp.RecordType.Name == 'Estimativa de venda')
            return SObjectType.OpportunityLineItem.FieldSets.Estimativa.getFields();
        if (opp.RecordType.Name == 'Objetivo Contrato Royalties')
            return SObjectType.OpportunityLineItem.FieldSets.Objetivo_Contrato_Royalties.getFields();
        if (opp.RecordType.Name.contains('Antecipação'))
            return SObjectType.OpportunityLineItem.FieldSets.Anticipo.getFields();  
        if (opp.RecordType.Name.contains('Descarte'))
            return SObjectType.OpportunityLineItem.FieldSets.Anexo_Descarte.getFields(); 
        if (opp.RecordType.Name.contains('Aquisição Sementes Terceiros'))
            return SObjectType.OpportunityLineItem.FieldSets.Aquisicion_Sementes_Terceiros.getFields(); 
        if (opp.RecordType.Name == 'Estimativa de Faturamento')
            return SObjectType.OpportunityLineItem.FieldSets.Pendiente.getFields();
        if (opp.RecordType.Name == 'Venda da Basica Completo')
            return SObjectType.OpportunityLineItem.FieldSets.VB_Completa.getFields();
        
        return null;                      
    }
   
   @isTest(SeeAllData=true)
   static void test(){
 
        Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
     
       opportunityExtension anexos = New opportunityExtension();
       
       anexos.searchAnexos();  
       //anexos.listarAnexos();
       String a;
       anexos.setetapaAnexo(a);
       a = anexos.getetapaAnexo();
       List<SelectOption> op = New List<SelectOption>();
       op = anexos.getEtapasAnexos();
       op = anexos.getTiposAnexos(); 
       anexos.getResultAnexos();      
       List <OpportunityLineItem> items = New List<OpportunityLineItem>();
       
        Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];  
        
        Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Opportunity prevision = New Opportunity(RecordTypeId=rt.get('Previsao'), Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        //insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        //insert oi2;
       
   }

   @isTest(SeeAllData=true)
   static void test2(){
 
        Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
     
       opportunityExtension anexos = New opportunityExtension();
           
       List <OpportunityLineItem> items = New List<OpportunityLineItem>();
       
        Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];  
        
        Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Opportunity prevision = New Opportunity(RecordTypeId=rt.get('Previsao'), Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi2;
       
       
       ApexPages.currentPage().getParameters().put('id',prevision.Id);
       items = anexos.getItems();
       List<Schema.FieldSetMember> b = anexos.getFields();
       
        Opportunity prueba1 = New Opportunity(RecordTypeId=rt.get('VB - Pendiente'), Name='Prueba1', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prueba1;

        OpportunityLineItem p1oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert p1oi2;
       
       ApexPages.currentPage().getParameters().put('id',prueba1.Id);
        anexos.getFields();
       
        Opportunity prueba2 = New Opportunity(RecordTypeId=rt.get('Disponibilidade da Basica'), Name='Prueba2', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prueba2;

        OpportunityLineItem p2oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        Test.StartTest();
        insert p2oi2;
        Test.StopTest();
       
       ApexPages.currentPage().getParameters().put('id',prueba2.Id);
        anexos.getFields();

        Opportunity prueba3 = New Opportunity(RecordTypeId=rt.get('Stock Multiplicadores'), Name='Prueba1', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prueba3;

       
       ApexPages.currentPage().getParameters().put('id',prueba3.Id);
       anexos.getFields();    
              
        Opportunity prueba4 = New Opportunity(RecordTypeId=rt.get('Rechazada'), Name='Prueba1', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prueba4;

       
       ApexPages.currentPage().getParameters().put('id',prueba4.Id);
       anexos.getFields();

   }
   
   @isTest(SeeAllData=true)
   static void test3(){
 
        Map<String,Id> rt = New Map<String, Id>();
        for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
            rt.put(reTy.Name, reTy.Id);
     
       opportunityExtension anexos = New opportunityExtension();
           
       List <OpportunityLineItem> items = New List<OpportunityLineItem>();
       
        Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];  
        
        Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
        Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
        Opportunity prevision = New Opportunity(RecordTypeId=rt.get('Previsao'), Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prevision;
        PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];

        OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=0.01,Previsao__c = 50,TotalPrice=10,PricebookEntryId=pbe.Id);
        insert oi2;
       
       
       ApexPages.currentPage().getParameters().put('id',prevision.Id);
       items = anexos.getItems();
       List<Schema.FieldSetMember> b = anexos.getFields();
       
        Opportunity prueba5 = New Opportunity(RecordTypeId=rt.get('Pendiente'), Name='Prueba1', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prueba5;

       
       ApexPages.currentPage().getParameters().put('id',prueba5.Id);
       anexos.getFields();
       
        Opportunity prueba6 = New Opportunity(RecordTypeId=rt.get('Anexo V'), Name='Prueba1', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prueba6;

       
       ApexPages.currentPage().getParameters().put('id',prueba6.Id);
       anexos.getFields();       

         Opportunity prueba7 = New Opportunity(RecordTypeId=rt.get('Anexo IV'), Name='Prueba1', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        Test.StartTest();
        insert prueba7;
        Test.StopTest();

       
       ApexPages.currentPage().getParameters().put('id',prueba7.Id);
       anexos.getFields();

         Opportunity prueba8 = New Opportunity(RecordTypeId=rt.get('Anexo III'), Name='Prueba1', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='12/13');
        insert prueba8;

       
       ApexPages.currentPage().getParameters().put('id',prueba8.Id);
       anexos.getFields();
                  
       anexos.anexo = 'A1';
       anexos.searchAnexos();
       anexos.anexo = 'A2';
       anexos.searchAnexos();
       anexos.anexo = 'A3';
       anexos.searchAnexos();
       anexos.anexo = 'A4';
       anexos.searchAnexos();
       anexos.anexo = 'A5';
       anexos.searchAnexos();
       anexos.anexo = 'ALL';
       anexos.searchAnexos();
       
       anexos.etapaAnexo = 'PEAN';
       anexos.searchAnexos();
       anexos.etapaAnexo = 'PEAP';
       anexos.searchAnexos();
       anexos.etapaAnexo = 'APR';
       anexos.searchAnexos();
       
       for (AggregateResult ar : [Select Max(Id) id, RecordType.Name rt From Opportunity Where RecordType.Name In ('Anexo I', 'Anexo II', 'NC - Autorizada', 'Autorizada', 'Anexo I Rebaixamento Ha', 'Anexo II Rebaixamento Sacas', 'VB - Pasada SAP', 'CVB Autorizada', 'PB-Comercial', 'Exportacion', 'Objetivo Ventas Semilla', 'Objetivo Ventas Royalties', 'Objetivo Contrato Royalties') Group By RecordType.Name]){
           apexpages.currentpage().getparameters().put('Id', String.valueOf(ar.get('id')));
           anexos.getFields();
       }      
   }
   
}
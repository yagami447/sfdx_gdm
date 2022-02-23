Public class anexosController{

   public anexosController(ApexPages.StandardController controller) {

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
   
   public anexosController(){    
       searchTextAnexo = '';
      
       for (RecordType rt : [Select Id, Name From RecordType Where Name in ('Anexo I','Anexo II','Anexo III', 'Anexo IV', 'Anexo V')]){
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
       return Database.query(query);
   }
   
   public List<Schema.FieldSetMember> getFields() {
        Opportunity o = [Select RecordType.Name From Opportunity Where Id = : apexpages.currentpage().getparameters().get('id')];
        if (o.RecordType.Name == 'Anexo I')
            return SObjectType.OpportunityLineItem.FieldSets.AnexoI.getFields();
        if (o.RecordType.Name == 'Anexo II')
            return SObjectType.OpportunityLineItem.FieldSets.AnexoII.getFields();
        if (o.RecordType.Name == 'Anexo III')
            return SObjectType.OpportunityLineItem.FieldSets.Anexo_III.getFields();  
            
        return null;                      
   }
   
   
   static testmethod void test(){
   	
       anexosController anexos = New anexosController();
       
       anexos.searchAnexos();	
       anexos.listarAnexos();
       String a;
       anexos.setetapaAnexo(a);
       a = anexos.getetapaAnexo();
       List<SelectOption> op = New List<SelectOption>();
       op = anexos.getEtapasAnexos();
       op = anexos.getTiposAnexos();       
       List <OpportunityLineItem> items = New List<OpportunityLineItem>();
       
       RecordType rt = [Select Id From RecordType Where Name = 'Anexo I' And SObjectType = 'Opportunity' limit 1];
       Opportunity o = New Opportunity();
       o.Name = 'a';
       o.CloseDate = system.today();
       o.RecordTypeId = rt.Id;
       o.StageName = 'Edición';
       o.Marca__c = 'BRMX';
       insert o;
       ApexPages.currentPage().getParameters().put('id',o.Id);
       items = anexos.getItems();              
       
       //ApexPages.currentPage().getParameters().put('id',o.Id);
       //items = anexos.getItems();
       //List<Schema.FieldSetMember> b = anexos.getFields();
   	
   }
   
}
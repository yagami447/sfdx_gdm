public class Opp_wzRebaja_Ctrl {
 //****************************************************************************
    //* JG 2009.06
    //* Metodo controlador pagina de VF: Opp_wzRebaja_Pasox
    //* Sirve para crear Oportunidades del tipo Rebajamiento en formato wizard.
    //****************************************************************************    
    private static String rt_multi_brasmax_opps = '0124000000010P5';
    private static String rt_rebaja_brasmax_opps = '012400000009d9B';
    private Map<String,OpportunityLineItem> itemMap = new Map<String,OpportunityLineItem>();
    private Map<String,OpportunityLineItem> oppIMap = new Map<String,OpportunityLineItem>();
    private Opportunity opp;
    private String safra = '';
    private String Accountid = '';
    private String name = '';
    private Date CloseDate = null;
                
    private List<Prod> items;
    private List<Prod> selItems = new List<Prod>();
    private Set<Id> selItemIds = new Set<Id>();
    public String filtro {get;set;}
    
    //JM 25/10/2011
    private boolean agregar_prod = false;
    private Id opId;
    //JM 25/10/2011
    
    public class Prod{
        public OpportunityLineItem item {get;set;}
        public Boolean selected {get;set;}
        public String OppItemId {get;set;}
        public String OppItemName {get;set;}
        public Boolean modBeneficiada {get;set;}
        public Boolean modAprovada {get;set;}
        public Prod(OpportunityLineItem i){
            item = i;
            selected = false;
            modBeneficiada = false;
            modAprovada = false;
        } 
    }

    public List<SelectOption> getItemsFase() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Aberta','Aberta'));
        options.add(new SelectOption('Relatório de Produção','Relatório de Produção'));
        options.add(new SelectOption('Relatório de Vendas','Relatório de Vendas'));
        return options;
    }
    
    public Opportunity getOpp(){
        if (this.opp == null){
                this.opp = new Opportunity();
            RecordType rt = [select id,name from RecordType where name like '%Rebaja%' limit 1];
            this.opp.recordtypeid = rt.id;
            Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Multiplica%' limit 1];
            this.opp.pricebook2id = pb2.id;
            this.opp.probability = 100;
            this.opp.Stagename = 'Aberta';
        }
        return this.opp;
    }    
    public void setOpp(Opportunity o){
        this.opp = o;
    }
    
    
    
    //JM 25/10/2011
    public List<Prod> getItems2(){
        if(ApexPages.currentPage().getParameters().get('id') != null){
            opId=ApexPages.currentPage().getParameters().get('id');
            Opportunity o = [Select Id, safra__c, AccountId, Name, CloseDate From Opportunity Where Id = : opId];
            this.safra = o.safra__c;
            this.accountid = o.AccountId;
            this.name = o.Name;
            this.CloseDate = o.CloseDate;
        }
        return getItems();
    }
    //JM 25/10/2011
    
    
    
    public List<Prod> getItems(){
        String f = filtro;
        
        items = new List<Prod>();
        if (f == null || f == '') f = '%';
        f = '%' + f + '%';
        
        
        List<Id> oppItemIds = new List<Id>();
        if(this.Accountid != null && this.safra != null){
                List<Id> oppIds = new List<Id>();           
                for(Opportunity op : [Select id, name, accountid, safra__c, recordtypeid From Opportunity Where (RecordTypeId = :rt_multi_brasmax_opps or RecordTypeId = :rt_rebaja_brasmax_opps) and safra__c = :this.safra and AccountId =: this.accountid]){
                        oppIds.add(op.Id);
                }
                for(OpportunityLineItem oit : [Select id, Semente_beneficiada__c, Semente_aprovada__c,
                PricebookEntry.Name, PricebookEntryId From OpportunityLineItem 
                Where Semente_beneficiada__c <> 0 and Semente_aprovada__c <> 0 AND Semente_bruta__c <> 0 AND OpportunityId in : oppIds]){
                        oppItemIds.add(oit.PricebookEntryId);
                        itemMap.put(oit.PricebookEntryId, oit);
                }
        }
        
        for (PricebookEntry pe : [select Id, Name, ProductCode, UnitPrice, Product2Id, Product2.Categoria__c from pricebookentry where Id in :oppItemIds and Product2.Categoria__c != 'S2' and name like :f order by name]){
            Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id));            
            items.add(pr);
        }
        return items;
    }
    
    public List<Prod> getSelItems(){
        return selItems;
    }
    
    public void cargarItems(){
        for (PricebookEntry pe : [select Id, Name, ProductCode, Product2Id, Product2.Categoria__c, Product2.Variedad__c, Product2.Licenciada__c, Product2.Variedad_licenciada__c, Pricebook2Id, UnitPrice from pricebookentry where id in :selItemIds order by name]){
            OpportunityLineItem oppItem = oppIMap.get(pe.Id);
            if (oppItem == null){
                oppItem = new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id);
                Prod pr = new Prod(oppItem);
                pr.selected = true;
                OpportunityLineItem i = itemMap.get(pe.Id);
                if(i != null){
                        pr.OppItemId = i.Id;
                        pr.OppItemName = i.PricebookEntry.Name;
                }
                selItems.add(pr);
                oppIMap.put(pe.Id, oppItem);
            }
        }
    }
    
    public void setItems(List<Prod> i){
        items = i;
    }

    public PageReference next(){
        this.safra = this.opp.safra__c;
        this.Accountid = this.opp.AccountId;
        this.name = this.opp.Name;
        this.CloseDate = this.opp.CloseDate;
        
        return Page.Opp_wzRebaja_Paso2;        
    }

    public PageReference prev(){
        return Page.Opp_wzRebaja_Paso1;
    }
    public PageReference next2(){
        for (Prod i:items){
            System.debug('************* '+i.selected + ' >>> '+i);
            if (i.selected == true){
                selItemIds.add(i.item.PricebookEntryId);
            }
        }
        cargarItems();
        return Page.Opp_wzRebaja_Paso3;
    }
    
    
    //JM 25/10/2011
    public PageReference agregar_prod_next(){
        for (Prod i:items){
            System.debug('************* '+i.selected + ' >>> '+i);
            if (i.selected == true){
                selItemIds.add(i.item.PricebookEntryId);
            }
        }
        cargarItems();
        return New PageReference ('/apex/Opp_wzRebaja_Agregar_Prod_2');
    }
    //JM 25/10/2011
    
    
    public PageReference prev2(){
        return Page.Opp_wzRebaja_Paso2;
    }
    public PageReference Salir(){
        return Page.Opp_listRebaixa;
    }
    
    
    //JM 25/10/2011
    public PageReference guardar2(){
        opp = [Select Id, AccountId, safra__c From Opportunity Where Id = : opId];
        agregar_prod = true;
        return guardar();
    }
    //JM 25/10/2011
        
    
    public PageReference guardar(){
        if (agregar_prod != true){//JM 25/10/2011
           opp.name = this.name;
           opp.CloseDate = this.CloseDate;
        }//JM 25/10/2011
                
        List<OpportunityLineItem> uitems = new List<OpportunityLineItem>();
        for (Prod i: selItems){
            Double aprov = i.item.Semente_aprovada__c;
            Double ben = i.item.Semente_beneficiada__c;
            
            if(i.item.pricebookentry.Product2.Categoria__c == 'C2'){
                if(i.item.Rebaja__c == 'C2' || i.item.Rebaja__c == 'C1'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A categoria debe ser inferior a la original'));
                    return null;
                }
            }
            else if(i.item.pricebookentry.Product2.Categoria__c == 'C1'){
                if(i.item.Rebaja__c == 'C1'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A categoria debe ser inferior a la original'));
                    return null;
                }
            }
            else if(i.item.pricebookentry.Product2.Categoria__c == 'S1'){
                if(i.item.Rebaja__c == 'C2' || i.item.Rebaja__c == 'S1' || i.item.Rebaja__c == 'C1'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A categoria debe ser inferior a la original'));
                    return null;
                }
            }
            
            if(ben < 0){                       
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A quantidade de beneficiada debe ser superior a 0'));
                return null;                    
            }
            if(aprov < 0){                  
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A quantidade de aprovada debe ser superior a 0'));
                return null;                    
            }
            
            if(aprov > ben){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Aprovada: ' + String.valueOf(aprov)
                + ' - Beneficiada: ' + String.valueOf(ben) + ': A semente aprovada não pode ser maior que a beneficiada.' ));
                return null;                
            }
            
            OpportunityLineItem item = new OpportunityLineItem();
            item.quantity = 1;
            item.opportunityid = opp.id;
            item.unitprice = i.item.pricebookentry.unitprice;
            item.pricebookentryid = i.item.pricebookentryid;
            item.Autori__c = i.item.Autori__c;
            item.Cidade__c = i.item.Cidade__c;
            item.Data__c = i.item.Data__c;
            item.Area__c = i.item.Area__c;
            item.Produto_Rebaixado__c = i.OppItemId;
            
            if(i.item.pricebookentry.Product2.Licenciada__c){
                for(PricebookEntry pbe : [Select Id From PricebookEntry Where Product2.Variedad_licenciada__c = :i.item.pricebookentry.Product2.Variedad_licenciada__c and Pricebook2Id = :i.item.pricebookentry.Pricebook2Id and Product2.Categoria__c = :i.item.Rebaja__c])
                    item.pricebookentryid = pbe.Id;
                
                for(OpportunityLineItem oit : [Select id, Semente_beneficiada__c, Semente_aprovada__c 
                    From OpportunityLineItem Where Opportunity.AccountId = :opp.AccountId
                    and Opportunity.RecordTypeId = '0124000000010P5' and PricebookEntry.Product2.Categoria__c = :i.item.pricebookentry.Product2.Categoria__c // JM 25/10/2011 Cambio i.item.Rebaja__c por i.item.pricebookentry.Product2.Categoria__c
                    and Opportunity.Safra__c = :opp.Safra__c and PricebookEntry.Product2.Variedad_licenciada__c = :i.item.pricebookentry.Product2.Variedad_licenciada__c]){
                    if(i.modBeneficiada){
                        Double benef = 0;
                        if(oit.Semente_beneficiada__c != null) benef = oit.Semente_beneficiada__c;
                        oit.Semente_beneficiada__c = benef - i.item.Semente_beneficiada__c;
                    }
                    if(i.modAprovada){
                        Double apr = 0;
                        if(oit.Semente_aprovada__c != null) apr = oit.Semente_aprovada__c;
                         oit.Semente_aprovada__c = apr - i.item.Semente_aprovada__c;
                    }
                    update oit;
                }
            }
            else{
                for(PricebookEntry pbe : [Select Id From PricebookEntry Where Product2.Variedad__c = :i.item.pricebookentry.Product2.Variedad__c and Pricebook2Id = :i.item.pricebookentry.Pricebook2Id and Product2.Categoria__c = :i.item.Rebaja__c])
                    item.pricebookentryid = pbe.Id;
                    
                for(OpportunityLineItem oit : [Select id, Semente_beneficiada__c, Semente_aprovada__c 
                    From OpportunityLineItem Where Opportunity.AccountId = :opp.AccountId
                    and Opportunity.RecordTypeId = '0124000000010P5' and PricebookEntry.Product2.Categoria__c = :i.item.pricebookentry.Product2.Categoria__c
                    and Opportunity.Safra__c = :opp.Safra__c and PricebookEntry.Product2.Variedad__c = :i.item.pricebookentry.Product2.Variedad__c]){
                    if(i.modBeneficiada){
                        Double benef = 0;
                        if(oit.Semente_beneficiada__c != null) benef = oit.Semente_beneficiada__c;
                        oit.Semente_beneficiada__c = benef - i.item.Semente_beneficiada__c;
                    }
                    if(i.modAprovada){
                        Double apr = 0;
                        if(oit.Semente_aprovada__c != null) apr = oit.Semente_aprovada__c;
                         oit.Semente_aprovada__c = apr - i.item.Semente_aprovada__c;
                    }
                    update oit;
                }
            }
            
            //Agregado para rebajar el valor de la categoria final, no la original de la nota de venta original.            
            
//            for(OpportunityLineItem oit : [Select id, Semente_beneficiada__c, Semente_aprovada__c From OpportunityLineItem Where Id = :i.OppItemId]){
//                if(i.modBeneficiada) oit.Semente_beneficiada__c = oit.Semente_beneficiada__c - i.item.Semente_beneficiada__c;
//              if(i.modAprovada) oit.Semente_aprovada__c = oit.Semente_aprovada__c - i.item.Semente_aprovada__c;
//                update oit;
//            }
                
            item.Produto_Rebaixado_Nombre__c = i.OppItemName;
            item.Semente_beneficiada__c = i.item.Semente_beneficiada__c;            
            item.Semente_aprovada__c = i.item.Semente_aprovada__c;            
            uitems.add(item);
        }
        if (uitems.size()>0){
            upsert opp;
            for(OpportunityLineItem ii : uitems)
                ii.OpportunityId = opp.Id;
            insert uitems;
        }
        return new PageReference('/'+opp.id);
    }
    @isTest(SeeAllData=true)
    static void test(){
        Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Multiplica%' AND IsActive = true limit 1];
        PricebookEntry pbe = [Select id, Product2Id From PricebookEntry where Pricebook2Id = :pb2.id AND IsActive = true limit 1];
//        Account acc = [Select id, name From Account limit 1];
        Account acc = new Account(Name='TMP');        
        insert acc;
        Opportunity o = new Opportunity(Safra__c='07/08',RecordTypeId=rt_rebaja_brasmax_opps,Name='TMP',Stagename='Aberta',CloseDate=System.Today());
        o.pricebook2id = pb2.id;
        o.AccountId = acc.Id;
        insert o;
            
        Opp_wzRebaja_Ctrl c = new Opp_wzRebaja_Ctrl();
        
        c.getOpp();
        ApexPages.currentPage().getParameters().put('id','0064000000BPCDLAA5');
        c.setItems(c.getItems());
        c.filtro = 'Gene';                
        c.setOpp(o);
        c.setOpp(c.getOpp());        
        c.setItems(c.getItems());
        c.getSelItems();
        c.getItemsFase();
        c.Salir();                
        c.next();
        
        c.prev();
        c.prev2();
        
        for (PricebookEntry pe : [select Pricebook2Id, Product2.Categoria__c, Product2.Licenciada__c, Product2.Variedad_licenciada__c, Product2.Variedad__c, id, name, productcode, unitprice from pricebookentry where pricebook2id = :o.pricebook2id AND IsActive = true limit 1]){
            Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id));
            pr.selected = true;
            c.getSelItems().add(pr);
            c.getItems().add(pr);
        }
        
        c.next2();
        c.agregar_prod_next();
        c.cargarItems();
        ApexPages.currentPage().getParameters().put('id',o.Id);
        c.getItems2();
        c.guardar();
        for (PricebookEntry pe2 : [select Pricebook2Id, Product2.Categoria__c, Product2.Licenciada__c, Product2.Variedad_licenciada__c, Product2.Variedad__c, id, name, productcode, unitprice from pricebookentry where Product2.Variedad_licenciada__c != '' and  pricebook2id = :o.pricebook2id and isactive=true limit 1]){
            Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe2, pricebookentryid=pe2.id));
            pr.selected = true;
            c.getSelItems().add(pr);
            c.getItems().add(pr);
        }                                
        c.next2();
        c.cargarItems();        
        //c.guardar();
        //c.guardar2();
    }
}
public class Opp_wzEstoque_Ctrl {
//****************************************************************************    
//* JG 2010.10    
//* Metodo controlador pagina de VF: Opp_wzEstoque_Pasox    
//* Sirve para crear Oportunidades del tipo Previcao y Estoque en formato wizard.    
//****************************************************************************

    private static String rt_multi_brasmax_opps = '0124000000010P5';
    private static String rt_rebaja_brasmax_opps = '012400000009d9B';
    private static String rt_comer_brasmax_opps = '012400000009d91';
    private static String rt_estoque_brasmax_opps = '012S00000004NSo';
    
    private Map<String,OpportunityLineItem> pbeMap = new Map<String,OpportunityLineItem>();
    private Map<String,OpportunityLineItem> variedadMap = new Map<String,OpportunityLineItem>();
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
    
    public class Prod{
        public OpportunityLineItem item {get;set;}
        public Boolean selected {get;set;}
        public Prod(OpportunityLineItem i){
            item = i;
            selected = false;
        }
    }

    public List<SelectOption> getItemsFase() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('RelatÃ³rio de Vendas','RelatÃ³rio de Vendas'));
        
        return options;
    }
    
    public Opportunity getOpp(){
        if (this.opp == null){
            this.opp = new Opportunity();
            RecordType rt = [select id,name from RecordType where name like '%Estoque%' limit 1];
            this.opp.recordtypeid = rt.id;
            Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Basicas%' limit 1];
            this.opp.pricebook2id = pb2.id;
            this.opp.probability = 100;
            this.opp.Stagename = 'Aberta';
        }
        return this.opp;
    }
    public void setOpp(Opportunity o){
        this.opp = o;
    }
    
    public List<Prod> getSelItems(){
        return selItems;
    }
    
    public void cargarItems(){
        for (PricebookEntry pe : [select id, name, productcode, Product2.Categoria__c, Product2.Variedad__c, Product2.Name,unitprice from pricebookentry where id in :selItemIds order by name]){
            OpportunityLineItem oppItem; // = oppIMap.get(pe.Id);
            //if (oppItem == null){
                oppItem = new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id);
                Prod pr = new Prod(oppItem);
                pr.selected = true;
                selItems.add(pr);
                oppIMap.put(pe.Id, oppItem);
            //}
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
        return Page.Opp_wzEstoque_Paso2;
    }

    public List<Prod> getItems(){
        String f = filtro;
        items = new List<Prod>();
        if (f == null || f == '') f = '%';
        f = '%' + f + '%';        
        for (PricebookEntry pe : [select id,name,productcode,Product2Id,Product2.Name,Product2.Licenciada__c,Product2.Variedad_Licenciada__c,Product2.Variedad__c,Product2.Categoria__c, unitprice from pricebookentry where pricebook2id = :this.getOpp().pricebook2id and Product2.Licenciada__c = false and name like :f order by name]){                
            Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id));            
            if (selItemIds.contains(pe.id))                
                pr.selected = true;            
            items.add(pr);        
        }        
        return items;    
    }    

    public PageReference prev(){
        return Page.Opp_wzComer_Paso1;
    }
    public PageReference next2(){
        Boolean paso = false;
        selItemIds = new Set<Id>();
        selItems = new List<Prod>();
        for (Prod i:items){
            System.debug('************* '+i.selected + ' >>> '+i);
            if (i.selected == true){
                selItemIds.add(i.item.PricebookEntryId);
                paso = true;
            }
        }
        
        if(paso){
                cargarItems();
            return Page.Opp_wzEstoque_Paso3;
        }
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'NÃ£o Ã© possÃ­vel criar uma oportunidade de comercializaÃ§Ã£o sem possuir oportunidade de multiplicaÃ§Ã£o.'));
        return null;

    }
    public PageReference prev2(){
        return Page.Opp_wzEstoque_Paso2;
    }
    public PageReference guardar(){
        String variedad = ''; String name = '';
        Boolean paso = false;
        
        List<OpportunityLineItem> uitems = new List<OpportunityLineItem>();
        Map<String,OpportunityLineItem> variedadMap = new Map<String,OpportunityLineItem>();
                
        opp.name = this.name;
        opp.CloseDate = System.Today();
        
        pbeMap = Opp_Utils.mapaValidacion(opp);
        
        for (Prod i: selItems){
                
            OpportunityLineItem item = new OpportunityLineItem();
           
            variedad = i.item.PricebookEntry.Product2.Variedad__c;
            name = i.item.pricebookentry.Product2.Name;
            item.quantity = 1;
            item.opportunityid = opp.id;
            item.unitprice = i.item.pricebookentry.unitprice;
            item.PricebookEntry = i.item.PricebookEntry;
            item.pricebookentryid = i.item.pricebookentryid;
            item.Estim_Sem_Previsao__c = i.item.Estim_Sem_Previsao__c;
            item.Estim_Sem_Comerc__c = i.item.Estim_Sem_Comerc__c;
            
            uitems.add(item);
        }
        if (uitems.size() == 0)
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, ' A oportunidade nÃ£o tem produtos, nÃ£o pode ser salvada'));
        
        upsert opp;
        for(OpportunityLineItem ii : uitems)
            ii.OpportunityId = opp.Id;
        insert uitems;
        return new PageReference('/'+opp.id);
                
    }
    
    public static testmethod void test(){
        RecordType rt = [select id,name from RecordType where name like '%Comercial%' And sObjectType = 'Opportunity' limit 1];
        Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Multiplica%' AND IsActive = true limit 1];
        PricebookEntry pbe = [Select id, Product2Id From PricebookEntry where Pricebook2Id = :pb2.id  AND IsActive = true limit 1];
//        Account acc = [Select id, name From Account limit 1];
        Account acc = new Account(Name='TMP');
        insert acc;
                
        Opportunity o = new Opportunity(Safra__c='07/08',RecordTypeId=rt.Id,Name='TMP',Stagename='Abierta',CloseDate=System.Today());
        o.recordtypeid = rt.id;
        o.pricebook2id = pb2.id;
        o.AccountId = acc.Id;
        insert o;

        Opportunity o_multi = new Opportunity(Safra__c='07/08',RecordTypeId= rt_multi_brasmax_opps,Name='TMP2',Stagename='Abierta',CloseDate=System.Today());
        o_multi.pricebook2id = pb2.id;
        o_multi.AccountId = acc.Id;
        insert o_multi;
        OpportunityLineItem i = new OpportunityLineItem(OpportunityId=o_multi.Id,PricebookEntryId=pbe.id,Quantity=1,UnitPrice=2);
        i.Cantidad_autorizada_vi__c = 12;
        i.Semente_aprovada__c = 100;
        i.Semente_uso_propio__c = 90;
        i.Semente_comercializada__c = 10;
        
        insert i;
            
        Opp_wzEstoque_Ctrl c = new Opp_wzEstoque_Ctrl();
        c.getOpp();
        c.setOpp(o);
        c.getOpp();
        c.next();
        c.getItems();
        c.getSelItems();
        c.prev();
        c.next2();
        c.prev2();

        c.setItems(c.getItems());

        for (PricebookEntry pe : [select id,name,productcode, Product2.Categoria__c, Product2.Name, unitprice from pricebookentry where pricebook2id = :o.pricebook2id  AND IsActive = true limit 1]){
            Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id));
            pr.selected = true;
            c.getSelItems().add(pr);
            c.getItems().add(pr);
        }

        c.next2();
        c.guardar();

    }
}
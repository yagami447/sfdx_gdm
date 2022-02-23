public class Opp_wzExpor_Ctrl {

    private static String rt_comer_brasmax_opps = '012400000009d91';
    private static String rt_franq_brasmax_opps = '012400000000zQu';
            
    private Map<String,OpportunityLineItem> oppIMap = new Map<String,OpportunityLineItem>();
    private Map<String,OpportunityLineItem> pbeMap = new Map<String,OpportunityLineItem>();
    
    private Opportunity opp;
    private String safra = '';
    private String Accountid = '';
    private String name = '';
    private Date CloseDate = null;
	private Boolean noSalvar = false;
	                
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
        options.add(new SelectOption('Aberta','Aberta'));
        //options.add(new SelectOption('Relatorio de Produção','Relatorio de Produção'));
        
    	return options;
    }
    
    public Opportunity getOpp(){
        if (this.opp == null){
        	this.opp = new Opportunity();
            RecordType rt = [select id,name from RecordType where name like '%Exportacion%' limit 1];
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
    
    public List<Prod> getItems(){
        String f = filtro;
        items = new List<Prod>();
        if (f == null || f == '') f = '%';
        f = '%' + f + '%';
        for (PricebookEntry pe : [select id,name,productcode,Product2Id,Product2.Name,Product2.Licenciada__c,Product2.Variedad_Licenciada__c,Product2.Variedad__c,Product2.Categoria__c, unitprice from pricebookentry where pricebook2id = :this.getOpp().pricebook2id and name like :f order by name]){
                Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id));
            if (selItemIds.contains(pe.id))
                pr.selected = true;
            items.add(pr);
        }
        return items;
    }
    
    public List<Prod> getSelItems(){
        return selItems;
    }
    
    public void cargarItems(){
        for (PricebookEntry pe : [select id, name, productcode, Product2Id,Product2.Name,Product2.Licenciada__c,Product2.Variedad_Licenciada__c,Product2.Variedad__c,Product2.Categoria__c,unitprice from pricebookentry where id in :selItemIds]){
            OpportunityLineItem oppItem;
            oppItem = new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id);
            Prod pr = new Prod(oppItem);
            pr.selected = true;
            selItems.add(pr);
            oppIMap.put(pe.Id, oppItem);
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
        
        return Page.Opp_wzExpor_Paso2;        
    }

    public PageReference prev(){
        return Page.Opp_wzExpor_Paso1;
    }
    public PageReference next2(){
    	selItemIds = new Set<Id>();
        selItems = new List<Prod>();
        for (Prod i:items){            
            if (i.selected) selItemIds.add(i.item.PricebookEntryId);                        
        }
        cargarItems();
        return Page.Opp_wzExpor_Paso3;
    }
    public PageReference prev2(){       
        return Page.Opp_wzExpor_Paso2;
    }       
    
    public PageReference guardar(){    	
    	String name = '';
    	String variedad = '';
    	Boolean paso = false;
    	
    	List<OpportunityLineItem> uitems = new List<OpportunityLineItem>();    	        
    	Map<String,OpportunityLineItem> variedadMap = new Map<String,OpportunityLineItem>();    	        
    	        
        opp.name = this.name;
        opp.CloseDate = this.CloseDate;
        
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
            item.Volume__c = i.item.Volume__c;            						
            
            uitems.add(item);
        }
        
        if (uitems.size() == 0)
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, ' A oportunidade não tem produtos, não pode ser salvada'));        
                	       
        upsert opp;
        for(OpportunityLineItem ii : uitems)
        	ii.OpportunityId = opp.Id;
        insert uitems;
        return new PageReference('/'+opp.id);	
                
    }
    
    public static testmethod void test(){
        Opportunity o = new Opportunity();
                
        o.name = 'TMP';
		o.stagename = 'Abierta';
        o.CloseDate = System.today();
        o.safra__c = '07/08';
        o.recordtypeid = '012400000000zQtAAI';
        insert o;

		Opportunity oo = new Opportunity(Safra__c='07/08',name='TMP',recordtypeid='0124000000010P5AAI',pricebook2id='01s400000001xhNAAQ',closedate=System.today(),stagename='Relatorio de Produção');
        insert oo;
        
        Opp_wzExpor_Ctrl c = new Opp_wzExpor_Ctrl();
        ApexPages.currentPage().getParameters().put('id',oo.Id);
        c.setItems(c.getItems());
        c.filtro = 'Gene';                
        c.setOpp(o);
        c.setOpp(c.getOpp());        
        c.setItems(c.getItems());
        c.getSelItems();                
        c.next();
        
        c.prev();
        c.prev2();
        
        for (PricebookEntry pe : [select id,name,productcode,Product2.Name,Product2.Licenciada__c,Product2.Variedad_Licenciada__c,Product2.Variedad__c,Product2.Categoria__c,unitprice from pricebookentry where pricebook2id = :oo.pricebook2id  AND IsActive = true limit 1]){
            Prod pr = new Prod(new OpportunityLineItem(Semente_bruta__c=100,Semente_beneficiada__c=100,Semente_aprovada__c=100,pricebookentry=pe, pricebookentryid=pe.id));
            pr.selected = true;
            c.getSelItems().add(pr);
            c.getItems().add(pr);
        }
                                
        c.next2();
        c.cargarItems();        
        c.guardar();
    }
}
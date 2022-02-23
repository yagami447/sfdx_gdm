public with sharing class Opp_wzMulti_Ctrl {
    //****************************************************************************
    //* JG 2008.12
    //* Metodo controlador pagina de VF: Opp_wzMulti_Pasox
    //* Sirve para crear Oportunidades del tipo Multiplicador en formato wizard.
    //****************************************************************************
    
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
        options.add(new SelectOption('Relatorio de Produção','Relatorio de Produção'));
        
    	return options;
    }
    
    public Opportunity getOpp(){
        if (this.opp == null){
        	this.opp = new Opportunity();
            RecordType rt = [select id,name from RecordType where name like '%Produccion%' And sObjectType = 'Opportunity' limit 1];
            this.opp.recordtypeid = rt.id;
            Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Multiplica%' limit 1];
            this.opp.pricebook2id = pb2.id;
            
            if (UserInfo.getProfileId() == '00e40000000yy83AAA'){
            	pb2 = [select id,name from Pricebook2 where name like '%Licencias%' limit 1];
                this.opp.pricebook2id = pb2.id;
            }
            
            this.opp.probability = 100;
            this.opp.Stagename = 'Relatorio de Produção';
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
        
        return Page.Opp_wzMulti_Paso2;        
    }

    public PageReference prev(){
        return Page.Opp_wzMulti_Paso1;
    }
    public PageReference next2(){
    	selItemIds = new Set<Id>();
        selItems = new List<Prod>();
        for (Prod i:items){            
            if (i.selected) selItemIds.add(i.item.PricebookEntryId);                        
        }
        cargarItems();
        return Page.Opp_wzMulti_Paso3;
    }
    public PageReference prev2(){       
        return Page.Opp_wzMulti_Paso2;
    }       
    
    public PageReference guardar(){
    	String msgBenef = ''; String msgAprov = ''; String msgPlantada = ''; String msgAutoriza = ''; String variedad = '';
    	String name = '';
    	Boolean paso = false;
    	
    	List<OpportunityLineItem> uitems = new List<OpportunityLineItem>();    	        
    	Map<String,OpportunityLineItem> variedadMap = new Map<String,OpportunityLineItem>();    	        
    	        
        opp.name = this.name;
        opp.CloseDate = this.CloseDate;
        
        pbeMap = Opp_Utils.mapaValidacion(opp);
        
        for (Prod i: selItems){
        	
            OpportunityLineItem item = new OpportunityLineItem();
            Double ben = 0; Double bruta = 0; Double aprov = 0; Double area = 0; Double area_p = 0;
            Double basica = 0; Double uso_ant = 0; Double area2 = 0;
            
            variedad = i.item.PricebookEntry.Product2.Variedad__c;
            name = i.item.pricebookentry.Product2.Name;
            item.quantity = 1;
            item.opportunityid = opp.id;
            item.unitprice = i.item.pricebookentry.unitprice;
            item.PricebookEntry = i.item.PricebookEntry;
            item.pricebookentryid = i.item.pricebookentryid;
            
            PricebookEntry pbe_aux = [Select Id, Product2Id, Product2.Licenciada__c From PricebookEntry Where Id = : item.pricebookentryid];
            if (pbe_aux.Product2.Licenciada__c){
                PricebookEntry pbe_aux_2 = [Select Id, Pricebook2Id From PricebookEntry Where Product2Id = : pbe_aux.Product2Id And Pricebook2.Name = 'Lista de precios de Licencias'];	
                item.PricebookEntry = null;
                item.pricebookentryid = pbe_aux_2.Id;
                opp.Pricebook2Id = pbe_aux_2.Pricebook2Id;
            }
            
            
            item.Autori__c = i.item.Autori__c;
            item.Cidade__c = i.item.Cidade__c;
            item.Data__c = i.item.Data__c;
			item.Autorizacion_V_Industria__c = i.item.Autorizacion_V_Industria__c;
			
			OpportunityLineItem itemAnt = variedadMap.get(variedad);
			if(itemAnt == null){
				itemAnt = new OpportunityLineItem(PricebookEntryId=i.item.pricebookentryid,Area__c=0);
            	variedadMap.put(variedad, itemAnt);
			}	
			
			basica = Opp_Utils.valCantBasica(i.item.pricebookentry.Product2,opp);
			uso_ant = Opp_Utils.valCantUsoPropio(i.item.pricebookentry.Product2,opp);

            OpportunityLineItem oi3 = pbeMap.get(i.item.pricebookentryid);
       		if(oi3 != null){
       			ben = oi3.Semente_beneficiada__c;
       			bruta = oi3.Semente_bruta__c;
       			aprov = oi3.Semente_aprovada__c;
       			area = oi3.Area__c;
       			area2 = oi3.Area__c;
       			area_p = oi3.Area_Plantada__c;
       		}
						
			if(i.item.Semente_beneficiada__c != null) ben += i.item.Semente_beneficiada__c;
	   		if(i.item.Semente_bruta__c != null) bruta += i.item.Semente_bruta__c;
   			if(i.item.Semente_aprovada__c != null) aprov += i.item.Semente_aprovada__c;       		
   			if(i.item.Area_Plantada__c != null) area_p += i.item.Area_Plantada__c;
   			if(i.item.Area__c != null) area += i.item.Area__c;
			if(i.item.Area__c != null) area2 += i.item.Area__c;
   			if(itemAnt.Area__c != null) area2 += itemAnt.Area__c;
   		
   			if(!paso)
				paso = Opp_Utils.mapaMensajes(i.item, area2, area_p, area, uso_ant, basica, ben, aprov, bruta);

			item.Area__c = i.item.Area__c;
            item.Area_Plantada__c = i.item.Area_Plantada__c;
        	item.Semente_bruta__c = i.item.Semente_bruta__c;
            item.Semente_beneficiada__c = i.item.Semente_beneficiada__c;
            item.Semente_aprovada__c = i.item.Semente_aprovada__c;            
        	item.Cantidad_autorizada_vi__c = i.item.Cantidad_autorizada_vi__c;
            
            itemAnt.Area__c = area;
            
            uitems.add(item);
        }
        if (uitems.size() == 0)
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, ' A oportunidade não tem produtos, não pode ser salvada'));
        else{
        	if(!Opp_Utils.validarFranqueados(uitems, opp))
        		return null;
        }
        	
        if(opp.type == 'Normal' && ApexPages.hasMessages() && !noSalvar){
        	if(paso) noSalvar = true;
        	return null;
        }
        
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
        
        Opp_wzMulti_Ctrl c = new Opp_wzMulti_Ctrl();
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
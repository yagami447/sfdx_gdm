public class Opp_Multi_View_Ctrl{
    private static String rt_produc_brasmax_opps = '0124000000010P5';
    private static String rt_comer_brasmax_opps = '012400000009d91';
    private static String rt_franq_brasmax_opps = '012400000000zQu';
    private static String rt_fact_brasmax_opps = '012400000000zQt';
    private static String rt_rebaja_brasmax_opps = '012400000009d9B';
    private static String rt_exportacion_brasmax_opps = '01240000000M570';
    
    private Opportunity opp;
    private Pricebook2 pcb;
    private final ApexPages.StandardController controller;
    
    private Map<String,OpportunityLineItem> oppIMap = new Map<String,OpportunityLineItem>();
    public OpportunityLineItem[] itemList;
    public String filtro {get;set;}
    
    public List<Prod> items;
    private List<Prod> selItems = new List<Prod>();
    private Set<Id> selItemIds = new Set<Id>();
    
    public class Prod{
        public OpportunityLineItem item {get;set;}
        public Boolean selected {get;set;}        
        public Prod(OpportunityLineItem i){
            item = i;
            selected = false;
        } 
    }
    
    public Opp_Multi_View_Ctrl(ApexPages.StandardController controller){  
        this.controller = controller;
        if(ApexPages.currentPage().getParameters().get('id') != null)
        {
            try{
                this.opp = [Select id, Atualizacao__c, Tem_Descarte__c, name, OwnerId, Importador__c, VB_Franqueado__c, VB_Quem_negocia__c, Objetivo__c, VB_Recebeu__c,
                VB_Chegou_na_Brasmax__c, VB_Cot_Soja__c, VB_Ok_Grte_gral_p_Assinar__c, Respons_vel__c, VB_Cidade__c,
                Negocio__c, Enviamos_por_correio__c, CloseDate, AccountId, Stagename, Safra__c, Recordtypeid, 
                Pricebook2.Name, pricebook2id, Account.Responsavel__c From Opportunity Where Id = :ApexPages.currentPage().getParameters().get('id')];
                
                this.itemList = [Select Orden__c, Cantidad_autorizada_vi__c, Autorizacion_V_Industria__c, PricebookEntryId,
                Qtde_Scs_40kg__c, Area_Plantada__c, Id, Rebaja__c, Cidade__c, Area__c, Semente_bruta__c, Cantidad_autorizada_Aprov__c,
                Semente_beneficiada__c, Semente_aprovada__c, Semente_uso_propio__c, Semente_comercializada__c, Volume__c,
                Data__c, PricebookEntry.Product2.Variedad__c, PricebookEntry.Product2.Categoria__c, PricebookEntry.Product2.Name, Produto_Rebaixado_Nombre__c,
                Produto_Rebaixado__c, Autori__c from OpportunityLineItem Where OpportunityId = : this.opp.Id order by PricebookEntry.Product2.Name];
                
                this.items = new List<Prod>();
                this.selItemIds = new Set<Id>();
            }
            catch(Exception e){
            }
        }
    }
    
    
    //JM 25/10/2011
    public PageReference Agregar_Prod(){
        PageReference pageRef = new PageReference('/apex/Opp_wzRebaja_Agregar_Prod?id=' + opp.Id);
        return pageRef;
    }
    //JM 25/10/2011
    
    
    public pageReference init(){
        return getRedir();
    }
    
    public Boolean getBasica(){
        if(opp.RecordTypeId == rt_franq_brasmax_opps)
            return true;
        return false;
    }    
    public Boolean getProduccion(){
        if(opp.RecordTypeId == rt_produc_brasmax_opps)
            return true;
        return false;
    }
    public Boolean getComercial(){
        if(opp.RecordTypeId == rt_comer_brasmax_opps)
            return true;
        return false;
    }    
    public Boolean getRebaja(){
        if(opp.RecordTypeId == rt_rebaja_brasmax_opps)
            return true;
        return false;
    }
    
    //JM 26/10/2011
    public Boolean getExportacion(){
        if(opp.RecordTypeId == rt_exportacion_brasmax_opps)
            return true;
        return false;
    }
    //JM 26/10/2011
    
    public void setOpp(Opportunity o){
        opp = o;
    }
    public Opportunity getOpp(){
        return opp;
    }
    
    public boolean getShowItems(){
        if(itemList==null) return false;        
        if(itemList.size()==0) return false;
        return true;            
    }
    
    public List<Prod> getSelItems(){
        return selItems;
    }
    
    public OpportunityLineItem[] getItems() {       
        return itemList;
    }
    
    public PageReference Preview() {
        PageReference pageRef = new PageReference('/apex/Opp_PrintView?id=' + opp.Id);
        ///apex/Opp_PrintView?id={!Opportunity.Id}
        pageRef.setredirect(true);
        return pageRef;
    }

    public PageReference getRedir(){
        try
        {
            Opportunity o = [Select id, name, recordtypeid, pricebook2.Name, pricebook2id From Opportunity Where Id = :ApexPages.currentPage().getParameters().get('id')];          
            if(o.pricebook2 == null)
                pcb = [select id, Name from Pricebook2 where name like '%Multiplica%' limit 1];
            else
                pcb = o.pricebook2;
                
            if (o.recordtypeid == rt_rebaja_brasmax_opps || o.recordtypeid == rt_comer_brasmax_opps || o.recordtypeid == rt_produc_brasmax_opps || o.recordtypeid == rt_franq_brasmax_opps || o.recordtypeid == rt_exportacion_brasmax_opps)
                return null;
            
            PageReference newPage;
            newPage = new PageReference('/' + o.id);
            newPage.getParameters().put('nooverride', '1');
            newPage.getParameters().put('id', o.id);
            return newPage.setRedirect(true);
        }
        catch(QueryException ex)
        {
            return null;
        }
    }
    
    public PageReference prev(){
        ApexPages.currentPage().getParameters().put('id', opp.id);
        return Page.Opp_wzMulti_View;
    }
    public PageReference addProduct(){
        PageReference newPage = Page.Opp_wzMulti_AddProducts;
        newPage.getParameters().put('id',this.opp.id);
        return newPage.setRedirect(true);
        
        //ApexPages.currentPage().getParameters().put('id', opp.id);
        //return Page.Opp_wzMulti_AddProducts;
    }
    public PageReference seleccionar(){
        this.selItemIds = new Set<Id>();
        for (Prod i:items){
            if (i.selected == true){
                selItemIds.add(i.item.PricebookEntryId);
            }
        }
        cargarItems();
        ApexPages.currentPage().getParameters().put('id', opp.id);
        return Page.Opp_wzMulti_valores;
    }
    
    public void cargarItems(){
        for (PricebookEntry pe : [select id, name, productcode, unitprice, Product2.Variedad__c, Product2.Categoria__c, Product2.Name from pricebookentry where id in :selItemIds]){
            OpportunityLineItem oppItem;
            oppItem = new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id);
            Prod pr = new Prod(oppItem);
            pr.selected = true;
            selItems.add(pr);
        }
    }
    
    public List<Prod> getProducts(){
        try{
            String f = filtro;
            items = new List<Prod>();
            if (f == null || f == '') f = '%';
            f = '%' + f + '%';
        
            for (PricebookEntry pe : [select id,name,productcode, unitprice, Product2Id from pricebookentry where pricebook2id = :pcb.Id and name like :f order by name]){
                Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id));
                items.add(pr);
            }
        }
        catch(Exception e){
            return items;
        }
        return items;
    }
    
    public PageReference save(){
        String variedad; String categoria;
            
        List<OpportunityLineItem> uitems = new List<OpportunityLineItem>();
        for (Prod i: selItems){
            OpportunityLineItem item = new OpportunityLineItem();
                                    
            item.quantity = 1;
            item.opportunityid = opp.id;
            item.unitprice = i.item.pricebookentry.unitprice;
            item.pricebookentryid = i.item.pricebookentryid;
            item.PricebookEntry = i.item.PricebookEntry;
            item.Autori__c = i.item.Autori__c;
            item.Cidade__c = i.item.Cidade__c;
            item.Data__c = i.item.Data__c;
            item.Area__c = i.item.Area__c;
            item.Qtde_Scs_40kg__c = i.item.Qtde_Scs_40kg__c;
            item.Area_Plantada__c = i.item.Area_Plantada__c;
            item.Semente_bruta__c = i.item.Semente_bruta__c;
            item.Semente_beneficiada__c = i.item.Semente_beneficiada__c;            
            item.Semente_aprovada__c = i.item.Semente_aprovada__c;
            item.Semente_uso_propio__c = i.item.Semente_uso_propio__c;
            item.Semente_comercializada__c = i.item.Semente_comercializada__c;            
            item.Cantidad_autorizada_Aprov__c = i.item.Cantidad_autorizada_Aprov__c;
            item.Cantidad_autorizada_vi__c = i.item.Cantidad_autorizada_vi__c;
            item.Autorizacion_V_Industria__c = i.item.Autorizacion_V_Industria__c;
            
            uitems.add(item);
        }
        
        if (uitems.size() != 0){
            if(this.getComercial()){
                for (OpportunityLineItem i :uitems){
                    variedad = i.pricebookentry.Product2.Name;
                    categoria = i.pricebookentry.Product2.Categoria__c;
                    if(categoria == 'S2' && i.Semente_uso_propio__c > 0){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, variedad + ': Categoria S2. A semente uso proprio não pode ser maior que 0.' ));
                        return null;
                    }
                }            
            }
            if(this.getBasica() || this.getProduccion()){
                if(!Opp_Utils.validarFranqueados(uitems, opp)) return null;
            }
            insert uitems;
        }
        return new PageReference('/' + this.opp.id);
    }
    
    public static testMethod void testM() {
        Opportunity opp = new Opportunity(Stagename = 'Abierta', CloseDate = System.today(), Name = 'TMP');
        insert opp;
        ApexPages.currentPage().getParameters().put('id',opp.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        Opp_Multi_View_Ctrl c = new Opp_Multi_View_Ctrl(controller);        
        c.init();
        c.getBasica();
        c.getProduccion();
        c.getShowItems();
        opp = c.getOpp();
        opp.RecordTypeId = rt_franq_brasmax_opps;
        c.itemList = null;
        c.getShowItems();
        c.addProduct();
        c.getSelItems();
        c.getItems();
        c.prev();       
        c.setOpp(opp);      
        c.getBasica();
        c.getComercial();
        c.getRebaja();
        c.Preview();
        
        opp = c.getOpp();
        opp.RecordTypeId = rt_franq_brasmax_opps;       
        c.init();
        c.setOpp(opp);
        c.getProducts();
        update opp;
        c.getRedir();
        
        
        List<Prod> prods = new List<Prod>();
        PricebookEntry pe = [Select id, product2id from PricebookEntry where id = '01u40000001xCc6'];
        
        OpportunityLineItem oppItem = new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id);
        Prod pr = new Prod(oppItem);
        pr.selected = true;
        c.items.add(pr);            
        c.seleccionar();        
        c.save();
        
    }
}
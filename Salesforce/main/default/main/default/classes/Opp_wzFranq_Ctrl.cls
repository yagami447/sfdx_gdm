public class Opp_wzFranq_Ctrl {
    //****************************************************************************
    //* JG 2009.01
    //* Metodo controlador pagina de VF: Opp_wzFranq_Pasox
    //* Sirve para crear Oportunidades del tipo Venda de Basica a Franqueados mediante el asistente.
    //****************************************************************************
        
    /*private Map<String,OpportunityLineItem> oppIMap = new Map<String,OpportunityLineItem>();
    private Opportunity opp;
                
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
        options.add(new SelectOption('Reserva','Reserva'));
        options.add(new SelectOption('Fechada Recebida','Fechada Recebida'));
        
        return options;
    }
    
    public Opportunity getOpp(){
        if (this.opp == null){
            this.opp = new Opportunity();
            RecordType rt = [select id,name from RecordType where name like '%Venda da Basica%' limit 1];
            this.opp.recordtypeid = rt.id;
            Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Basicas%' limit 1];
            this.opp.pricebook2id = pb2.id;
            this.opp.probability = 100;
            this.opp.Stagename = 'Reserva';
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
        for (PricebookEntry pe : [select Id, Name, Product2.Name, ProductCode, Product2Id, UnitPrice from pricebookentry where pricebook2id = :this.getOpp().pricebook2id and name like :f]){
            //Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id));
            //items.add(pr);
            items.add(new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id)));
        }
        return items;
    }
    
    public List<Prod> getSelItems(){
        return selItems;
    }
    
    public void cargarItems(){      
        for (PricebookEntry pe : [select Id, Name, ProductCode, Product2.Name, Product2Id, UnitPrice from pricebookentry where id in :selItemIds]){
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
        return Page.Opp_wzFranq_Paso2;        
    }

    public PageReference prev(){
        return Page.Opp_wzFranq_Paso1;
    }
    public PageReference next2(){
        selItemIds = new Set<Id>();
        selItems = new List<Prod>();        
        for (Prod i:items){
            System.debug('************* '+i.selected + ' >>> '+i);
            if (i.selected == true){
                selItemIds.add(i.item.PricebookEntryId);                
            }
        }        
            
        cargarItems();
        return Page.Opp_wzFranq_Paso3;
    }
    public PageReference prev2(){
        return Page.Opp_wzFranq_Paso2;
    }
    public PageReference Salir(){
        return Page.Opp_listFranq;
    }
    
    public PageReference guardar(){
                
        Set<Id> CultivarIds = new Set<Id>();        
        
        for(Contrato__c c : [Select c.Id, c.Cultivar__c, c.Cultivar__r.Variedad__c, c.Multiplicador__c, c.Name from Contrato__c c  Where c.Multiplicador__c = :opp.AccountId]){
            CultivarIds.add(c.Cultivar__c);
        }
        
        String variedad = '\n';
        List<OpportunityLineItem> uitems = new List<OpportunityLineItem>();
        for (Prod i: selItems){
            OpportunityLineItem item = new OpportunityLineItem();           

            if(!CultivarIds.contains(i.item.pricebookentry.Product2Id)){
                variedad += ', ' + i.item.pricebookentry.Product2.Name;                
            }
            item.quantity = 1;
            item.opportunityid = opp.id;
            item.unitprice = i.item.pricebookentry.unitprice;
            item.pricebookentryid = i.item.pricebookentryid;            
            //item.Area__c = i.item.Area__c;
            item.Qtde_Scs_40kg__c = i.item.Qtde_Scs_40kg__c;
            uitems.add(item);
        }
        if(variedad != '\n'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A conta não possui contrato desse produto ' + variedad));
            return null;
        }
                
        if (uitems.size()>0){
            upsert opp;
            for(OpportunityLineItem ii : uitems)
                ii.OpportunityId = opp.Id;
            insert uitems;
            return new PageReference('/'+opp.id);
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A oportunidade deve possui al menos um produto.'));
        return null;
        
    }
    
    public static testmethod void test(){
//        Account acc = [Select id, name From Account limit 1];
        Account acc = new Account(Name='TMP');
        insert acc;
        Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Multiplica%' limit 1];
        PricebookEntry pbe = [Select id, Product2Id From PricebookEntry where Pricebook2Id = :pb2.id limit 1];
        Product2 p2 = [Select id, ProductCode From Product2 limit 1];
        
        Contrato__c con = new Contrato__c(Cultivar__c=p2.id,Multiplicador__c=acc.Id);
        insert con;
        
        Opportunity o = new Opportunity(Name='TMP',Pricebook2Id=pb2.id,Stagename='Reserva',CloseDate=System.today());
        o.recordtypeid = '012400000000zQtAAI';
        o.AccountId = con.Multiplicador__c;
        insert o;

        Opp_wzFranq_Ctrl c = new Opp_wzFranq_Ctrl();
        
        c.setItems(c.getItems());
        c.filtro = 'Gene';                
        c.setOpp(o);
        c.setOpp(c.getOpp());        
        c.setItems(c.getItems());
        c.getSelItems();
        c.next();
        c.prev();
        c.Salir();
        c.next2();

        c.cargarItems(); 
        
        for (PricebookEntry pe : [select id,name,productcode, Product2.Name, Product2Id, unitprice from pricebookentry where pricebook2id = :o.pricebook2id limit 1]){
            Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id, Qtde_Scs_40kg__c = 2));
            pr.selected = true;
            c.getSelItems().add(pr);
            c.getItems().add(pr);
        }
        c.next2();
        c.prev2();

        PricebookEntry pe1 = [select id,name,productcode, Product2.Name, Product2Id, unitprice from pricebookentry where pricebook2id = :o.pricebook2id limit 1];
        Prod pr2 = new Prod(new OpportunityLineItem(pricebookentry=pe1, Qtde_Scs_40kg__c = 2,pricebookentryid=pe1.id));            
        c.getItems().add(pr2);
                       
        c.guardar();
    }*/
}
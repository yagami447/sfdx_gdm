public with sharing class Opp_wzComer_Ctrl {
//****************************************************************************
    //* JG 2009.06
    //* Metodo controlador pagina de VF: Opp_wzComer_Pasox
    //* Sirve para crear Oportunidades del tipo Multiplicador en formato wizard.
    //****************************************************************************
    
    private static String rt_multi_brasmax_opps = '0124000000010P5';
    private static String rt_rebaja_brasmax_opps = '012400000009d9B';
    private static String rt_comer_brasmax_opps = '012400000009d91';
    
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
        options.add(new SelectOption('Relatorio de Vendas','Relatorio de Vendas'));
        
        return options;
    }
    
    public Opportunity getOpp(){
        if (this.opp == null){
            this.opp = new Opportunity();
            RecordType rt = [select id,name from RecordType where name like '%Comercial%' And sObjectType = 'Opportunity' limit 1];
            this.opp.recordtypeid = rt.id;
            Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Multiplica%' limit 1];
            this.opp.pricebook2id = pb2.id;
            this.opp.probability = 100;
            this.opp.Stagename = 'Relatorio de Vendas';
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
        return Page.Opp_wzComer_Paso2;        
    }

    public List<Prod> getItems(){
        String f = filtro;
        items = new List<Prod>();
        if (f == null || f == '') f = '%';
        f = '%' + f + '%';
        
        List<Id> oppItemIds = new List<Id>();
        List<String> oppItemVariedad = new List<String>();
        
        System.Debug('Tiene safra '+ this.safra);
        System.Debug('Tiene cuenta '+ this.accountid);
        
        if(this.Accountid != null && this.safra != ''){
            List<Id> oppIds = new List<Id>();
            String campa = '%' + this.safra.substring(2,5);
            for(Opportunity op : [Select id, name, accountid, safra__c, recordtypeid From Opportunity 
            Where (RecordTypeId = :rt_multi_brasmax_opps or RecordTypeId = :rt_rebaja_brasmax_opps) 
            and safra__c like :campa and AccountId =: this.accountid]){
                oppIds.add(op.Id);
            }
            if(this.opp.Aprovar_Todas_Categorias__c){
                for(OpportunityLineItem oit : [Select id, PricebookEntryId, PricebookEntry.Product2.Categoria__c, PricebookEntry.Product2.Variedad__c, PricebookEntry.Product2.Name From OpportunityLineItem Where OpportunityId in : oppIds]){
                    oppItemVariedad.add(oit.PricebookEntry.Product2.Variedad__c);
                }
            }
            else{               
                for(OpportunityLineItem oit : [Select id, PricebookEntryId, PricebookEntry.Product2.Categoria__c, PricebookEntry.Product2.Variedad__c, PricebookEntry.Product2.Name From OpportunityLineItem Where OpportunityId in : oppIds]){
                    oppItemIds.add(oit.PricebookEntryId);
                }
            }
        }
        else
            System.Debug('No tiene safra o cuenta');
        
        if(this.opp.Aprovar_Todas_Categorias__c){
            for (PricebookEntry pe : [select id,name,productcode,unitprice,Product2.Name,Product2.Categoria__c from pricebookentry where Product2.Variedad__c in :oppItemVariedad and Product2.Licenciada__c = false and Pricebook2Id = : opp.Pricebook2Id and name like :f order by name]){
                Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id));
                if (selItemIds.contains(pe.id))
                    pr.selected = true;
                items.add(pr);
            }
        }
        else{
            for (PricebookEntry pe : [select id,name,productcode,unitprice,Product2.Name,Product2.Categoria__c from pricebookentry where Id in :oppItemIds and name like :f order by name]){
                Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id));
                if (selItemIds.contains(pe.id))
                    pr.selected = true;
                items.add(pr);
            }
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
            return Page.Opp_wzComer_Paso3;              
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Não é possível criar uma oportunidade de comercialização sem possuir oportunidade de multiplicação.'));
        return null;

    }
    public PageReference prev2(){       
        return Page.Opp_wzComer_Paso2;
    }
    public PageReference guardar(){
        opp.name = this.name;
        opp.CloseDate = this.CloseDate;
                
        pbeMap = new Map<String,OpportunityLineItem>();

        String safra = '%' + opp.safra__c.substring(2,5);
        List<Id> RecordTypeIds = new List<Id>();
        RecordTypeIds.add(rt_rebaja_brasmax_opps);
        RecordTypeIds.add(rt_comer_brasmax_opps);
        RecordTypeIds.add(rt_multi_brasmax_opps);
        
        for(OpportunityLineItem oi :[Select Id, PricebookEntry.Product2.Variedad__c, PricebookEntryId,
        Cantidad_autorizada_aprov__c,Semente_comercializada__c, Semente_uso_propio__c, Area_Plantada__c, 
        Area__c, Semente_aprovada__c, Semente_bruta__c, Semente_beneficiada__c from OpportunityLineItem 
        Where opportunityid != :opp.id and opportunity.AccountId = :opp.accountId and Opportunity.RecordTypeId
        in :RecordTypeIds and Opportunity.Safra__c like :safra]){
            
            OpportunityLineItem oi2 = pbeMap.get(oi.pricebookentryid);

            if(oi2 == null){
                oi2 = new OpportunityLineItem(Semente_aprovada__c=0,Cantidad_autorizada_aprov__c=0,Semente_comercializada__c=0,
                Area_Plantada__c=0,Semente_uso_propio__c=0,Area__c=0,Semente_beneficiada__c=0,Semente_bruta__c=0,
                PricebookEntryId=oi.pricebookentryid);
                pbeMap.put(oi.pricebookEntryId, oi2);
            }
            if(oi.Semente_aprovada__c != null){
                oi2.Semente_aprovada__c += oi.Semente_aprovada__c;
            }
            if(oi.Cantidad_autorizada_aprov__c != null){
                oi2.Cantidad_autorizada_aprov__c += oi.Cantidad_autorizada_aprov__c;
            }
            if(oi.Semente_uso_propio__c != null){
                oi2.Semente_uso_propio__c += oi.Semente_uso_propio__c;
            }
            if(oi.Semente_comercializada__c != null){
                oi2.Semente_comercializada__c += oi.Semente_comercializada__c;
            }
        }
        
        String msgVendida = ''; String msgDescarte = '';
        
        List<OpportunityLineItem> uitems = new List<OpportunityLineItem>();
        for (Prod i: selItems){
            OpportunityLineItem item = new OpportunityLineItem();
            Double uso = 0; Double comer = 0; Double cant_aut = 0; Double aprov = 0;
            
            String n = i.item.pricebookentry.Product2.Name;
            String cat = i.item.pricebookentry.Product2.Categoria__c;
            if(cat == 'S2' && i.item.Semente_uso_propio__c > 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, n + '- A categoria S2 não pode ter semente uso próprio.' ));
                return null;
            }
            
            item.quantity = 1;
            item.unitprice = i.item.pricebookentry.unitprice;
            
            
            item.pricebookentryid = i.item.pricebookentryid;
            PricebookEntry pbe_aux = [Select Id, Product2Id, Product2.Licenciada__c From PricebookEntry Where Id = : item.pricebookentryid];
            if (pbe_aux.Product2.Licenciada__c){
                PricebookEntry pbe_aux_2 = [Select Id, Pricebook2Id From PricebookEntry Where Product2Id = : pbe_aux.Product2Id And Pricebook2.Name = 'Lista de precios de Licencias'];	
                item.pricebookentryid = pbe_aux_2.Id;
                opp.Pricebook2Id = pbe_aux_2.Pricebook2Id;
            }             
            
            
            item.Data__c = i.item.Data__c;
            item.Autorizacion_V_Industria__c = i.item.Autorizacion_V_Industria__c;
            
            OpportunityLineItem oi3 = pbeMap.get(i.item.pricebookentryid);
            if(oi3 != null){
                cant_aut = oi3.Cantidad_autorizada_aprov__c;
                aprov = oi3.Semente_aprovada__c;
                uso = oi3.Semente_uso_propio__c;
                comer = oi3.Semente_comercializada__c;
            }
            if(i.item.Cantidad_autorizada_aprov__c != null) cant_aut += i.item.Cantidad_autorizada_aprov__c;
            if(i.item.Semente_aprovada__c != null) aprov += i.item.Semente_aprovada__c;
            if(i.item.Semente_uso_propio__c != null) uso += i.item.Semente_uso_propio__c;
            if(i.item.Semente_comercializada__c != null) comer += i.item.Semente_comercializada__c;

            if(opp.Aprovar_Uso_Proprio__c)
                uso = 0;
            
            if(opp.Aprovar_Comercializada__c)
                comer = 0;
                
            if(!opp.Aprovar_Todas_Categorias__c){
                if(uso+comer > aprov)
                    msgVendida += '\n' + n + ' - Comercialização: ' + String.valueOf(uso+comer) + ' - Sem.Aprovada: ' + String.valueOf(aprov);            
                if(cant_aut > (aprov-uso-comer))
                    msgDescarte += '\n' + n + ' - Comercialização: ' + String.valueOf(uso+comer) + ' - Sem.Aprovada: ' + String.valueOf(aprov) + ' - Descarte: ' + String.valueOf(cant_aut);
            }
            
            item.Cantidad_autorizada_aprov__c = i.item.Cantidad_autorizada_aprov__c;
            item.Semente_aprovada__c = i.item.Semente_aprovada__c;            
            item.Semente_uso_propio__c = i.item.Semente_uso_propio__c;
            item.Semente_comercializada__c = i.item.Semente_comercializada__c;
            
            uitems.add(item);
        }
        if(msgVendida != ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, msgVendida + ': A semente comercializada não pode ser maior que a semente aprovada.' ));
            return null;
        }
        if(msgDescarte != ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, msgDescarte + ': A semente descartada não pode ser maior que a semente aprovada - comercializada - Uso Próprio.' ));
            return null;
        }
        
        upsert opp;
        if (uitems.size()>0){
            for (OpportunityLineItem item : uitems) item.opportunityid = opp.id;
            insert uitems;
        }
                
        return new PageReference('/'+opp.id);
    }
    
    public static testmethod void test(){
        RecordType rt = [select id,name from RecordType where name like '%Comercial%' And sObjectType = 'Opportunity' limit 1];
        Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Multiplica%'  AND IsActive = true limit 1];
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
            
        Opp_wzComer_Ctrl c = new Opp_wzComer_Ctrl();
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

        for (PricebookEntry pe : [select id,name,productcode, Product2.Categoria__c, Product2.Name, unitprice from pricebookentry where pricebook2id = :o.pricebook2id and isActive = true limit 1]){
            Prod pr = new Prod(new OpportunityLineItem(pricebookentry=pe, pricebookentryid=pe.id));
            pr.selected = true;
            c.getSelItems().add(pr);
            c.getItems().add(pr);
        }

        c.next2();
        c.guardar();

    }
}
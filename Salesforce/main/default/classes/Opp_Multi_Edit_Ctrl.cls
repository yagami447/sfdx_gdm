public class Opp_Multi_Edit_Ctrl {

  /*  private static String rt_produc_brasmax_opps = '0124000000010P5';
    private static String rt_comer_brasmax_opps = '012400000009d91';
    private static String rt_franq_brasmax_opps = '012400000000zQu';
    private static String rt_fact_brasmax_opps = '012400000000zQt';
    private static String rt_rebaja_brasmax_opps = '012400000009d9B';
    private static String rt_exportacion_brasmax_opps = '01240000000M570';
    
    private Map<String,OpportunityLineItem> pbeMap = new Map<String,OpportunityLineItem>();
    private Boolean noSalvar = false;
    private Opportunity opp;
    public List<OpportunityLineItem> itemList;
    private final ApexPages.StandardController controller;
    
    public Opp_Multi_Edit_Ctrl(ApexPages.StandardController controller){
        this.controller = controller;
//        noSalvar = false;
        this.opp = (Opportunity) controller.getRecord();
        if(this.opp.Id != null){
            this.opp = [SELECT Id, type, Atualizacao__c, Tem_Descarte__c, Aprovar_Uso_Proprio__c, Importador__c, VB_Franqueado__c, VB_Quem_negocia__c, Objetivo__c, VB_Recebeu__c,
            VB_Chegou_na_Brasmax__c, VB_Cot_Soja__c, VB_Ok_Grte_gral_p_Assinar__c, Respons_vel__c,
            VB_Cidade__c, Negocio__c, Enviamos_por_correio__c, Name, AccountId, Safra__c, CloseDate, Despachante__c,
            Stagename, RecordTypeId FROM Opportunity WHERE Id = :this.opp.id];
            List<OpportunityLineItem> lista = [Select Orden__c, Produto_Rebaixado_Nombre__c,Cantidad_autorizada_Aprov__c,
            Produto_Rebaixado__c, Qtde_Scs_40kg__c, Area_Plantada__c, Id, Cidade__c, Semente_uso_propio__c,
            Cantidad_autorizada_vi__c, Autorizacion_V_Industria__c, Semente_comercializada__c, Autori__c,
            Semente_aprovada__c, Semente_bruta__c, Semente_beneficiada__c, PricebookEntry.Product2.Categoria__c, Volume__c,
            PricebookEntry.Product2.Variedad__c , PricebookEntry.Product2.Name, pricebookentryid, Data__c, Area__c
            From OpportunityLineItem Where OpportunityId = :this.opp.Id order by PricebookEntry.Product2.Name];
            this.itemList = new List<OpportunityLineItem>();
            for(OpportunityLineItem o : lista){
                o.Orden__c = this.itemList.size();
                this.itemList.add(o);
            }
        }
    }
                
    public List<SelectOption> getItemsFase() {
        List<SelectOption> options = new List<SelectOption>();
        if(this.getProduccion()){
                options.add(new SelectOption('Aberta','Aberta'));
                options.add(new SelectOption('Relatorio de Produção','Relatorio de Produção'));
        }
        if(this.getRebaja()){
                options.add(new SelectOption('Aberta','Aberta'));
                options.add(new SelectOption('Relatorio de Produção','Relatorio de Produção'));
                options.add(new SelectOption('Relatorio de Vendas','Relatorio de Vendas'));
        }
        if(this.getBasica()){
                options.add(new SelectOption('Reserva','Reserva'));
                options.add(new SelectOption('Fechada Recebida','Fechada Recebida'));
        }
        if(this.getComercial()){
                options.add(new SelectOption('Relatorio de Vendas','Relatorio de Vendas'));
        }
        if(this.getExportacion()){
                options.add(new SelectOption('Aberta','Aberta'));
        }
        
        return options;
    }
  
        public Boolean getNoSalvar(){
        return noSalvar;
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
    
    
    public PageReference delProduto(){
        Integer index = 0;
        PageReference pg = ApexPages.currentPage();
        if(pg.getparameters().get('orden') != null){
            index = Integer.valueOf(pg.getparameters().get('orden'));
            this.itemList.remove(index);
        }
        
        return null;
    }
    
    public String getProfile(){
        return UserInfo.getProfileId();
    }
    public Boolean getEditable(){
        String prof = UserInfo.getProfileId();
        if(prof.substring(0,15) == '00e40000000rObQ') return true;  //mgoriabr
        if(prof.substring(0,15) == '00e40000000rPTd') return true;  //Liliane
        if(prof.substring(0,15) == '00e40000000yy83') return true;  //Licencias
        if(getExportacion()) return true;
        return false;
    }
    public boolean getShowItems(){
        if(itemList==null) return false;
        if(itemList.size()==0) return false;
        return true;
    }
    
    public pageReference guardar(){
        Boolean paso = false;
        try{
            if(this.getProduccion() && opp.Type == 'Normal'){
                Opp_Utils.validarFranqueados(itemList, opp);
                
                if(!validarProduccion(itemList)){
                        paso = true; //return null;
                }
                if(!validarProduccion2(itemList)){
                        return null;
                }
            }
            if(this.getComercial()){
                if(!validarComercial(opp.Aprovar_Uso_Proprio__c ,itemList)) return null;
            }
            if(this.getRebaja()){
                if(!validarRebaja(itemList)) return null;
            }

            if(opp.type == 'Normal' && ApexPages.hasMessages() && !noSalvar){
                //if(paso)
                        noSalvar = true;
                        return null;
                }
                
            update opp;
            update itemList;
            PageReference pr = new PageReference('/apex/Opp_wzMulti_View?id='+opp.id);
            return pr;
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
            return null;
        }
    }
    
    public Boolean validarRebaja(List<OpportunityLineItem> itemList){
        
        for (OpportunityLineItem i :itemList){
            Double aprov = i.Semente_aprovada__c;
            Double ben = i.Semente_beneficiada__c;
            
            if(i.pricebookentry.Product2.Categoria__c == 'C2'){
                if(i.Rebaja__c == 'C2' || i.Rebaja__c == 'C1'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A categoria debe ser inferior a la original'));
                    return false;
                }
            }
            else if(i.pricebookentry.Product2.Categoria__c == 'C1'){
                if(i.Rebaja__c == 'C1'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A categoria debe ser inferior a la original'));
                    return false;
                }
            }
            else if(i.pricebookentry.Product2.Categoria__c == 'S1'){
                if(i.Rebaja__c == 'C2' || i.Rebaja__c == 'S1' || i.Rebaja__c == 'C1'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A categoria debe ser inferior a la original'));
                    return false;
                }
            }
            
            if(ben < 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A quantidade de beneficiada debe ser superior a 0'));
                return false;
            }
            if(aprov < 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'A quantidade de aprovada debe ser superior a 0'));
                return false;
            }
            if(aprov > ben){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Aprovada: ' + String.valueOf(aprov)
                + ' - Beneficiada: ' + String.valueOf(ben) + ': A semente aprovada nÃ£o pode ser maior que a beneficiada.' ));
                return false;
            }
        }
        return true;
    }
    
    public Boolean validarComercial(Boolean apro_uso, List<OpportunityLineItem> itemList){
        Map<String,OpportunityLineItem> pbeMap = new Map<String,OpportunityLineItem>();
        String safra = '%' + opp.safra__c.substring(2,5);
        String msgDescarte = ''; String msgVendida = '';
        
        List<Id> RecordTypeIds = new List<Id>();
        RecordTypeIds.add(rt_rebaja_brasmax_opps);
        RecordTypeIds.add(rt_comer_brasmax_opps);
        RecordTypeIds.add(rt_produc_brasmax_opps);
        
        for(OpportunityLineItem oi :[Select Id, PricebookEntry.Product2.Variedad__c, PricebookEntryId,
        Cantidad_autorizada_aprov__c , Semente_comercializada__c, Semente_uso_propio__c, Semente_aprovada__c
        from OpportunityLineItem Where opportunityid != :opp.id and opportunity.AccountId = :opp.accountId
        and Opportunity.RecordTypeId in :RecordTypeIds and Opportunity.Safra__c like :safra]){
            
            OpportunityLineItem oi2 = pbeMap.get(oi.pricebookentryid);

            if(oi2 == null){
                oi2 = new OpportunityLineItem(Semente_aprovada__c=0,Cantidad_autorizada_aprov__c=0,Semente_comercializada__c=0,
                Semente_uso_propio__c=0,PricebookEntryId=oi.pricebookentryid);
                pbeMap.put(oi.pricebookEntryId, oi2);
            }
            if(oi.Semente_aprovada__c != null) oi2.Semente_aprovada__c += oi.Semente_aprovada__c;
            if(oi.Cantidad_autorizada_aprov__c != null) oi2.Cantidad_autorizada_aprov__c += oi.Cantidad_autorizada_aprov__c;
            if(oi.Semente_uso_propio__c != null) oi2.Semente_uso_propio__c += oi.Semente_uso_propio__c;
            if(oi.Semente_comercializada__c != null) oi2.Semente_comercializada__c += oi.Semente_comercializada__c;

        }
        
        for (OpportunityLineItem i :itemList){
            Double aprov = 0; Double comer = 0; Double cant_aut = 0; Double uso = 0;
            String n = i.pricebookentry.Product2.Name;
            String cat = i.pricebookentry.Product2.Categoria__c;
            if(cat == 'S2' && i.Semente_uso_propio__c > 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, n +
                '- A categoria S2 nÃ£o pode ter semente uso prÃ³prio.' ));
                return false;
            }
            
            OpportunityLineItem oi3 = pbeMap.get(i.pricebookentryid);
            if(oi3 != null){
                cant_aut = oi3.Cantidad_autorizada_aprov__c;
                aprov = oi3.Semente_aprovada__c;
                uso = oi3.Semente_uso_propio__c;
                comer = oi3.Semente_comercializada__c;
            }
            if(i.Cantidad_autorizada_aprov__c != null) cant_aut += i.Cantidad_autorizada_aprov__c;
            if(i.Semente_aprovada__c != null) aprov += i.Semente_aprovada__c;
            if(i.Semente_uso_propio__c != null) uso += i.Semente_uso_propio__c;
            if(i.Semente_comercializada__c != null) comer += i.Semente_comercializada__c;
            
            if(apro_uso) //Aprovar_Uso_Proprio__c)
                uso = 0;
            if(uso+comer > aprov)
                msgVendida += '\n' + n + ' - Comercialização: ' + String.valueOf(uso+comer) +
                ' - Sem.Aprovada: ' + String.valueOf(aprov);
            if(cant_aut > (aprov-uso-comer))
                msgDescarte += '\n' + n + ' - Comercialização: ' + String.valueOf(uso+comer) +
                ' - Sem.Aprovada: ' + String.valueOf(aprov) + ' - Descarte: ' + String.valueOf(cant_aut);
            
        }
        
        if(msgVendida != ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, msgVendida +
            ': A semente comercializada não pode ser maior que a semente aprovada.' ));
            return false;
        }
        if(msgDescarte != ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, msgDescarte +
            ': A semente descartada não pode ser maior que a semente aprovada - comercializada - Uso PrÃ³prio.' ));
            return false;
        }
        return true;
    }
    
    public Map<String,OpportunityLineItem> mapaValidacion(){
        pbeMap = new Map<String,OpportunityLineItem>();
        String safra = '%' + opp.safra__c.substring(2,5);
        for(OpportunityLineItem oi :[Select Id, PricebookEntry.Product2.Variedad__c, PricebookEntryId,
        Semente_comercializada__c, Semente_uso_propio__c, Area_Plantada__c, Area__c, Semente_aprovada__c,
        Semente_bruta__c, Semente_beneficiada__c from OpportunityLineItem Where opportunityid != :opp.id
        and opportunity.AccountId = :opp.accountId and Opportunity.RecordTypeId = :opp.RecordTypeId and
        Opportunity.Safra__c like :safra]){
            OpportunityLineItem oi2 = pbeMap.get(oi.pricebookentryid);
            if(oi2 == null){
                oi2 = new OpportunityLineItem(Semente_aprovada__c=0,Semente_comercializada__c=0,
                Area_Plantada__c=0,Semente_uso_propio__c=0,Area__c=0,Semente_beneficiada__c=0,Semente_bruta__c=0,
                PricebookEntryId=oi.pricebookentryid);
                pbeMap.put(oi.pricebookEntryId, oi2);
            }
            if(oi.Semente_bruta__c != null) oi2.Semente_bruta__c += oi.Semente_bruta__c;
            if(oi.Semente_beneficiada__c != null) oi2.Semente_beneficiada__c += oi.Semente_beneficiada__c;
            if(oi.Semente_aprovada__c != null) oi2.Semente_aprovada__c += oi.Semente_aprovada__c;
            if(oi.Area_Plantada__c != null) oi2.Area_Plantada__c += oi.Area_Plantada__c;
            if(oi.Area__c != null) oi2.Area__c += oi.Area__c;
        }
        return pbeMap;
    }
    
    public Boolean validarProduccion(List<OpportunityLineItem> itemList){
        String msgBenef = ''; String msgBruta = ''; String msgPlantada = '';
        Map<String,OpportunityLineItem> variedadMap = new Map<String,OpportunityLineItem>();
        Set<String> CultivarIds = new Set<String>();
        Boolean paso = false;

        pbeMap = Opp_Utils.mapaValidacion(opp);
        
        for (OpportunityLineItem i :itemList){
            Double ben = 0; Double bruta = 0; Double aprov = 0; Double area = 0; Double area_p = 0;
            Double basica = 0; Double uso_ant = 0; Double area2 = 0;
            
            String n = i.PricebookEntry.Product2.Name;
            String variedad = i.PricebookEntry.Product2.Variedad__c;
            
            OpportunityLineItem itemAnt = variedadMap.get(variedad);
            if(itemAnt == null){
                itemAnt = new OpportunityLineItem(PricebookEntryId=i.PricebookEntryId,Area__c=0);
                variedadMap.put(variedad, itemAnt);
            }
            
            basica = Opp_Utils.valCantBasica(i.pricebookentry.Product2,opp);
            uso_ant = Opp_Utils.valCantUsoPropio(i.pricebookentry.Product2,opp);

            OpportunityLineItem oi3 = pbeMap.get(i.pricebookentryid);
            if(oi3 != null){
                ben = oi3.Semente_beneficiada__c;
                bruta = oi3.Semente_bruta__c;
                aprov = oi3.Semente_aprovada__c;
                area = oi3.Area__c;
                area2 = oi3.Area__c;
                area_p = oi3.Area_Plantada__c;
            }

            if(i.Semente_beneficiada__c != null) ben += i.Semente_beneficiada__c;
            if(i.Semente_bruta__c != null) bruta += i.Semente_bruta__c;
            if(i.Semente_aprovada__c != null) aprov += i.Semente_aprovada__c;
            if(i.Area_Plantada__c != null) area_p += i.Area_Plantada__c;
            if(i.Area__c != null) area += i.Area__c;
            if(i.Area__c != null) area2 += i.Area__c;
            if(itemAnt.Area__c != null) area2 += itemAnt.Area__c;
            
            paso = Opp_Utils.mapaMensajes(i, area2, area_p, area, uso_ant, basica, ben, aprov, bruta);
        
        }
        if(ApexPages.hasMessages()){
            return false;
        }
        
        return true;
    }
    
    public Boolean validarProduccion2(List<OpportunityLineItem> itemList){
        String msgBenef = ''; String msgBruta = ''; String msgPlantada = '';
        Map<String,OpportunityLineItem> variedadMap = new Map<String,OpportunityLineItem>();
        Set<String> CultivarIds = new Set<String>();
        Boolean paso = false;

        pbeMap = Opp_Utils.mapaValidacion(opp);
        
        for (OpportunityLineItem i :itemList){
            Double ben = 0; Double bruta = 0; Double aprov = 0; Double area = 0; Double area_p = 0;
            Double basica = 0; Double uso_ant = 0; Double area2 = 0;
            
            String n = i.PricebookEntry.Product2.Name;
            String variedad = i.PricebookEntry.Product2.Variedad__c;
            
            OpportunityLineItem itemAnt = variedadMap.get(variedad);
            if(itemAnt == null){
                itemAnt = new OpportunityLineItem(PricebookEntryId=i.PricebookEntryId,Area__c=0);
                variedadMap.put(variedad, itemAnt);
            }
            
            basica = Opp_Utils.valCantBasica(i.pricebookentry.Product2,opp);
            uso_ant = Opp_Utils.valCantUsoPropio(i.pricebookentry.Product2,opp);

            OpportunityLineItem oi3 = pbeMap.get(i.pricebookentryid);
            if(oi3 != null){
                ben = oi3.Semente_beneficiada__c;
                bruta = oi3.Semente_bruta__c;
                aprov = oi3.Semente_aprovada__c;
                area = oi3.Area__c;
                area2 = oi3.Area__c;
                area_p = oi3.Area_Plantada__c;
            }

            if(i.Semente_beneficiada__c != null) ben += i.Semente_beneficiada__c;
            if(i.Semente_bruta__c != null) bruta += i.Semente_bruta__c;
            if(i.Semente_aprovada__c != null) aprov += i.Semente_aprovada__c;
            if(i.Area_Plantada__c != null) area_p += i.Area_Plantada__c;
            if(i.Area__c != null) area += i.Area__c;
            if(i.Area__c != null) area2 += i.Area__c;
            if(itemAnt.Area__c != null) area2 += itemAnt.Area__c;
            
            paso = Opp_Utils.mapaMensajes2(i, area2, area_p, area, uso_ant, basica, ben, aprov, bruta);
                if(paso){
                return false;
                }
        }
        
        return true;
    }
    
    public void setOpp(Opportunity o){
        opp = o;
    }
    public Opportunity getOpp(){
        return opp;
    }
    public List<OpportunityLineItem> getItems(){
        return itemList;
    }
    
    public pageReference init(){
        return getRedir();
    }
    
    public PageReference getRedir(){
        try
        {
            Opportunity o = [Select id, name, recordtypeid From Opportunity Where Id = :ApexPages.currentPage().getParameters().get('id')];
                    
            if (o.recordtypeid == rt_rebaja_brasmax_opps || o.recordtypeid == rt_produc_brasmax_opps
            || o.recordtypeid == rt_comer_brasmax_opps || o.recordTypeId == rt_franq_brasmax_opps || o.recordTypeId == rt_exportacion_brasmax_opps)
                return null;
        
            PageReference newPage;
            newPage = new PageReference('/' + o.id + '/e');
            newPage.getParameters().put('nooverride', '1');
            newPage.getParameters().put('id', o.id);
            newPage.getParameters().put('orden', '2');
            return newPage.setRedirect(true);
        }
        catch(QueryException qe)
        {
            return null;
        }
    }
    
    @isTest(SeeAllData=true)
    public static void testM() {
    	
    	Test.startTest();

        Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Multiplica%' AND IsActive = true limit 1];
        PricebookEntry pbe = [Select id, Product2Id From PricebookEntry where Pricebook2Id = :pb2.id  AND IsActive = true limit 1];
        PricebookEntry pbe2 = [Select id, Product2Id From PricebookEntry where Product2.Categoria__c = 'C1' and Pricebook2Id = :pb2.id and isactive = true order by name desc limit 1];
//        Account acc = [Select id, name From Account limit 1];
        Account acc = new Account(Name='TMP');
        insert acc;
        Opportunity o1 = new Opportunity(recordTypeId=rt_produc_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',Safra__c='07/08',CloseDate=System.today(),Name='TMP'); insert o1;
        Opportunity o2 = new Opportunity(recordTypeId=rt_comer_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',Safra__c='07/08',CloseDate=System.today(),Name='TMP'); insert o2;
        Opportunity o3 = new Opportunity(recordTypeId=rt_franq_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',Safra__c='07/08',CloseDate=System.today(),Name='TMP'); insert o3;
        Opportunity o4 = new Opportunity(recordTypeId=rt_rebaja_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',Safra__c='07/08',CloseDate=System.today(),Name='TMP'); insert o4;
        OpportunityLineItem i = new OpportunityLineItem(OpportunityId=o1.id,PricebookEntryId=pbe.Id,quantity=12,UnitPrice=12);
        i.Cantidad_autorizada_vi__c = 12;
        i.Semente_aprovada__c = 100;
        i.Semente_uso_propio__c = 90;
        i.Semente_bruta__c = 110;
        i.Semente_comercializada__c = 10;
        insert i;

        OpportunityLineItem i1 = new OpportunityLineItem(OpportunityId=o1.id,PricebookEntryId=pbe2.Id,quantity=12,UnitPrice=12);
        i1.Cantidad_autorizada_vi__c = 2;
        i1.Semente_aprovada__c = 1000;
        i1.Semente_uso_propio__c = 9;
        i1.Semente_comercializada__c = 120;
        insert i1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(o4);
        Opp_Multi_Edit_Ctrl c = new Opp_Multi_Edit_Ctrl(controller); c.getRebaja();
        controller = new ApexPages.StandardController(o2);
        c = new Opp_Multi_Edit_Ctrl(controller); c.getComercial();
        controller = new ApexPages.StandardController(o3);
        c = new Opp_Multi_Edit_Ctrl(controller); c.getBasica();
        c.getProduccion();
        controller = new ApexPages.StandardController(o1);
        c = new Opp_Multi_Edit_Ctrl(controller); c.getRebaja();
        c.getBasica();
        c.getComercial();
        c.getProduccion();
        
        /*c.getShowItems();
        ApexPages.currentPage().getparameters().put('orden','0');
        c.delProduto();
        c.getProfile();
        c.getEditable();
        c.getShowItems();

        c.setOpp(c.getOpp());
        c.getItems();
        c.validarProduccion2(c.getItems());
        c.validarProduccion(c.getItems());
        c.init();
        
        ApexPages.currentPage().getParameters().put('id',o2.Id);
        c.init();
        
        Opportunity fact = new Opportunity(recordTypeId=rt_fact_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',CloseDate=System.today(),Name='TMP'); insert fact;
        ApexPages.currentPage().getParameters().put('id',fact.Id);
        c.init();
        c.guardar();
        
        c.setOpp(fact);
        c.guardar();
        
        o1.Safra__c='08/09';
        update o1;
        
        Opportunity o_ant = new Opportunity(Safra__c='08/09',RecordTypeId=rt_produc_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',CloseDate=System.today(),Name='TMP'); insert o_ant;
        OpportunityLineItem i_ant = new OpportunityLineItem(OpportunityId=o_ant.id,PricebookEntryId=pbe2.Id,quantity=12,UnitPrice=12);
        i_ant.Cantidad_autorizada_vi__c = 2;
        i_ant.Semente_aprovada__c = 1000;
        i_ant.Semente_beneficiada__c = 1000;
        i_ant.Semente_bruta__c = 1000;
        i_ant.Semente_uso_propio__c = 9;
        i_ant.Semente_comercializada__c = 120;
        insert i_ant;
                
        c.setOpp(o_ant);
        c.getItemsFase();
        c.guardar();
        
        Opportunity o_2 = new Opportunity(Safra__c='08/09',RecordTypeId=rt_comer_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',CloseDate=System.today(),Name='TMP'); insert o_2;
        OpportunityLineItem i_2ant = new OpportunityLineItem(OpportunityId=o_2.id,PricebookEntryId=pbe2.Id,quantity=12,UnitPrice=12);
        i_2ant.Cantidad_autorizada_vi__c = 2;
        i_2ant.Semente_aprovada__c = 1000;
        i_2ant.Semente_beneficiada__c = 1000;
        i_2ant.Semente_bruta__c = 1000;
        i_2ant.Semente_uso_propio__c = 9;
        i_2ant.Semente_comercializada__c = 120;
        insert i_2ant;

        c.setOpp(o_2);
        c.guardar();
        
        //Opportunity o_reb = new Opportunity(Safra__c='08/09',RecordTypeId=rt_rebaja_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',CloseDate=System.today(),Name='TMP'); insert o_reb;
        //OpportunityLineItem i_3ant = new OpportunityLineItem(OpportunityId= o_reb.id,PricebookEntryId=pbe2.Id,quantity=12,UnitPrice=12);
        
        //i_3ant.Semente_aprovada__c = 1000;
        //i_3ant.Semente_beneficiada__c = 1000;
        //i_3ant.Semente_bruta__c = 1000;
        //insert i_3ant;

        c.getItemsFase();
        //c.setOpp(o_reb);
        c.getItemsFase();
        c.guardar();
        
        Test.stopTest();
        
    }
    
    @isTest(SeeAllData=true)
    public static void test2() {
    	
    	Test.startTest();

        Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Multiplica%' AND IsActive = true limit 1];
        PricebookEntry pbe = [Select id, Product2Id From PricebookEntry where Pricebook2Id = :pb2.id  AND IsActive = true limit 1];
        PricebookEntry pbe2 = [Select id, Product2Id From PricebookEntry where Product2.Categoria__c = 'C1' and Pricebook2Id = :pb2.id and isactive = true order by name desc limit 1];
//        Account acc = [Select id, name From Account limit 1];
        Account acc = new Account(Name='TMP');
        insert acc;
        //Opportunity o1 = new Opportunity(recordTypeId=rt_produc_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',Safra__c='07/08',CloseDate=System.today(),Name='TMP'); insert o1;
        Opportunity o2 = new Opportunity(recordTypeId=rt_comer_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',Safra__c='07/08',CloseDate=System.today(),Name='TMP'); insert o2;
        Opportunity o3 = new Opportunity(recordTypeId=rt_franq_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',Safra__c='07/08',CloseDate=System.today(),Name='TMP'); insert o3;
        Opportunity o4 = new Opportunity(recordTypeId=rt_rebaja_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',Safra__c='07/08',CloseDate=System.today(),Name='TMP'); insert o4;
        OpportunityLineItem i = new OpportunityLineItem(OpportunityId=o2.id,PricebookEntryId=pbe.Id,quantity=12,UnitPrice=12);
        i.Cantidad_autorizada_vi__c = 12;
        i.Semente_aprovada__c = 100;
        i.Semente_uso_propio__c = 90;
        i.Semente_bruta__c = 110;
        i.Semente_comercializada__c = 10;
        insert i;

        /*OpportunityLineItem i1 = new OpportunityLineItem(OpportunityId=o1.id,PricebookEntryId=pbe2.Id,quantity=12,UnitPrice=12);
        i1.Cantidad_autorizada_vi__c = 2;
        i1.Semente_aprovada__c = 1000;
        i1.Semente_uso_propio__c = 9;
        i1.Semente_comercializada__c = 120;
        insert i1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(o4);
        Opp_Multi_Edit_Ctrl c = new Opp_Multi_Edit_Ctrl(controller); c.getRebaja();
        controller = new ApexPages.StandardController(o2);
       
        c = new Opp_Multi_Edit_Ctrl(controller); c.getComercial();
        controller = new ApexPages.StandardController(o3);
        c = new Opp_Multi_Edit_Ctrl(controller); c.getBasica();
        c.getProduccion();
        controller = new ApexPages.StandardController(o1);
        c = new Opp_Multi_Edit_Ctrl(controller); c.getRebaja();
        c.getBasica();
        c.getComercial();
        c.getProduccion();
        
        c.getShowItems();
        ApexPages.currentPage().getparameters().put('orden','0');
        //c.delProduto();
        c.getProfile();
        c.getEditable();
        c.getShowItems();

        c.setOpp(c.getOpp());
        c.getItems();
        c.validarProduccion2(c.getItems());
        c.validarProduccion(c.getItems());
        c.init();
        
        ApexPages.currentPage().getParameters().put('id',o2.Id);
        c.init();
        
        Opportunity fact = new Opportunity(recordTypeId=rt_fact_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',CloseDate=System.today(),Name='TMP'); insert fact;
        ApexPages.currentPage().getParameters().put('id',fact.Id);
        c.init();
        c.guardar();
        
        c.setOpp(fact);
        c.guardar();
        
        //o1.Safra__c='08/09';
        //update o1;
        
        Opportunity o_ant = new Opportunity(Safra__c='08/09',RecordTypeId=rt_produc_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',CloseDate=System.today(),Name='TMP'); insert o_ant;
        OpportunityLineItem i_ant = new OpportunityLineItem(OpportunityId=o_ant.id,PricebookEntryId=pbe2.Id,quantity=12,UnitPrice=12);
        i_ant.Cantidad_autorizada_vi__c = 2;
        i_ant.Semente_aprovada__c = 1000;
        i_ant.Semente_beneficiada__c = 1000;
        i_ant.Semente_bruta__c = 1000;
        i_ant.Semente_uso_propio__c = 9;
        i_ant.Semente_comercializada__c = 120;
        insert i_ant;
                
        c.setOpp(o_ant);
        c.getItemsFase();
        c.guardar();
        
        Opportunity o_2 = new Opportunity(Safra__c='08/09',RecordTypeId=rt_comer_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',CloseDate=System.today(),Name='TMP'); insert o_2;
        OpportunityLineItem i_2ant = new OpportunityLineItem(OpportunityId=o_2.id,PricebookEntryId=pbe2.Id,quantity=12,UnitPrice=12);
        i_2ant.Cantidad_autorizada_vi__c = 2;
        i_2ant.Semente_aprovada__c = 1000;
        i_2ant.Semente_beneficiada__c = 1000;
        i_2ant.Semente_bruta__c = 1000;
        i_2ant.Semente_uso_propio__c = 9;
        i_2ant.Semente_comercializada__c = 120;
        insert i_2ant;

        c.setOpp(o_2);
        c.guardar();
        
        Opportunity o_reb = new Opportunity(Safra__c='08/09',RecordTypeId=rt_rebaja_brasmax_opps,AccountId=acc.Id,Stagename='Aberta',CloseDate=System.today(),Name='TMP'); insert o_reb;
        OpportunityLineItem i_3ant = new OpportunityLineItem(OpportunityId= o_reb.id,PricebookEntryId=pbe2.Id,quantity=12,UnitPrice=12);
        
        i_3ant.Semente_aprovada__c = 1000;
        i_3ant.Semente_beneficiada__c = 1000;
        i_3ant.Semente_bruta__c = 1000;
        insert i_3ant;

        c.getItemsFase();
        c.setOpp(o_reb);
        c.getItemsFase();
        c.guardar();
        
        Test.stopTest();
        
    }
    */
}
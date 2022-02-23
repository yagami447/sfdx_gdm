public with sharing class Opp_NV_tabListados {

    private Integer pageNumber = 0;
    private Integer pageSize = 20;
    private Integer totalPageNumber = 0;
    
    private String safra = '';
    private static String rt_multi_opps = '0124000000010P5';
    private static String rt_comer_opps = '012400000009d91';
    private static String rt_franq_opps = '012400000000zQu';
    private static String rt_fact_opps = '012400000000zQt';
    private static String rt_fact_c_opps = '0124000000010pm';
    private static String rt_rebaja_opps = '012400000009d9B';
    private static String rt_estoque_opps = '01240000000M3D1'; //'012S00000004NSo';    
    private String rt_pendiente_opps;
    private String rt_autorizada_opps;
    private String rt_rechazada_opps;
    private String rt;
    private Account ac = New Account();
    
    private String rt_opp = '';
    private String searchText = '';
    public Opportunity opp {get; set;}
    public List<Opportunity> result = new List<Opportunity>();
    private List<Opportunity> pageResult;

    public Opp_NV_tabListados() {
        this.opp = new Opportunity();
        this.rt = 'PE';
        for (RecordType rt : [Select Id, Name From RecordType Where Name in ('Pendiente','Rechazada','Autorizada')]){
           if (rt.Name == 'Pendiente')
              rt_pendiente_opps = rt.Id;
           if (rt.Name == 'Autorizada')
              rt_autorizada_opps = rt.Id;
           if (rt.Name == 'Rechazada')
              rt_rechazada_opps = rt.Id;
        } 
    }
    
    public String getrt(){                
       return rt;    
    }
    
    public void setrt (String arg){    
       this.rt = arg;    
    }
    
    public List<SelectOption> getRTypes() {
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('ALL','--Todos--'));
       options.add(new SelectOption('PE','Pendiente'));
       options.add(new SelectOption('AU','Autorizada'));
       options.add(new SelectOption('RE','Rechazada'));
       return options;
    }
    
    public Account getac(){                
       return ac;    
    }
    
    public void setac (Account arg){    
       this.ac = arg;    
    }
        
    public void listar(){
        result = null;
        totalPageNumber = 0;
        this.search();
        BindData(1);
    }
         
    public String getSearchText() {return searchText;}
    public void setSearchText(String arg) {searchText = arg;}
    public List<Opportunity> getResult() {return pageResult;}
    
    public void search(){
        String qry = 'select Id, Name, Mes__c, Regiao__r.Name, VB_Franqueado__c, VB_Franqueado__r.Name, StageName, Safra__c, Estado_Facturacion__c, CloseDate, Numero_del__c, Account.Id, Account.Name, Account.Responsavel__c, RecordType.Name, LastModifiedDate, Relatorio_Relacionado__c, Relatorio_Relacionado__r.Name, Nro_Pedido_SAP__c From Opportunity ';
        String s = searchText;
        String resp = ac.Responsavel__c;
        String safra = opp.Safra__c;
        String mes = ''; String region;
        List<Id> propIds = new List<Id>();
        propIds = colaboracionOpp(UserInfo.getProfileId());

        //qry += 'where OwnerId in: propIds ';
        qry += 'where OwnerId != null ';
        if (rt == 'PE')
           qry += ' and RecordTypeId = : rt_pendiente_opps ';
        if (rt == 'AU')
           qry += ' and RecordTypeId = : rt_autorizada_opps ';   
        if (rt == 'RE')
           qry += ' and RecordTypeId = : rt_rechazada_opps ';
        if (rt == 'ALL')
           qry += ' and (RecordTypeId = : rt_rechazada_opps OR RecordTypeId = : rt_autorizada_opps OR RecordTypeId = : rt_pendiente_opps) ';
           
        if(s != ''){ s = '%' + s + '%'; qry += ' and Name like : s';}
        if(safra != null){qry += ' and Safra__c = :safra';}
        if(resp != null){qry += ' and Account.Responsavel__c = : resp';}
        //qry += ' Order by Nro_Pedido_SAP__c, Safra__c Desc, LastModifiedDate Desc';        
        qry += ' Order by LastModifiedDate Desc limit 50000';
        system.debug('@JERE ' + qry);
        
        result = Database.query(qry);
        
    }
    
    private List<Id> colaboracionOpp(String profileId){
        List<Id> Ids = new List<Id>();
        //Ids.add('00540000000zsNB');  //Usuario Lilianne
        Ids.add('00540000001RDF0');  //Usuario Deyse        
        Ids.add('00540000000zlzO');  //Usuario Mariano Goria
        if(profileId.substring(0,15) != '00e40000000rQsv')  //Perfil comercial
            Ids.add('00540000000zui4');   //Usuario Brasmax
            
        return Ids;
    }
    
    public Boolean getNewButtonEnabled(){               
        return (UserInfo.getProfileId() == '00e40000000rPTdAAM' || UserInfo.getProfileId() == '00e40000000rQiTAAU' || UserInfo.getProfileId() == '00e40000000rObQAAU');
    }
    
    //--------------------
    public Integer getPageNumber(){
        return pageNumber;
    }
    public Integer getPageSize(){
        return pageSize;
    }
    public Boolean getPreviousButtonEnabled(){
        return !(pageNumber > 1);
    }
    public Boolean getFirstButtonDisabled(){
        return !(pageNumber > 1);
    }
    public Boolean getLastButtonDisabled(){
        if (result == null) return true;
        else
            return ((pageNumber * pageSize) >= result.size());
    }
    public Boolean getNextButtonDisabled(){
        if (result == null) return true;
        else
            return ((pageNumber * pageSize) >= result.size());
    }
    public Integer getTotalPageNumber(){
        if (totalPageNumber == 0 && result != null){
            totalPageNumber = result.size() / pageSize;
            Integer mod = result.size() - (totalPageNumber * pageSize);
            if (mod > 0)
                totalPageNumber++;
        }
        return totalPageNumber;
    }
        
    //----------------------------
    public PageReference lastBtnClick(){
        pageNumber = totalPageNumber - 1;
        BindData(totalPageNumber);
        return null;
    }
    public PageReference nextBtnClick(){
        BindData(pageNumber + 1);
        return null;
    }
    public PageReference previousBtnClick(){
        BindData(pageNumber - 1);
        return null;
    }
    public PageReference firstBtnClick(){
        BindData(1);
        return null;
    }
       
    private void BindData(Integer newPageIndex){        
        if (result == null)
            result = getResult();
        pageResult = new List<Opportunity>();
        Transient Integer counter = 0;
        Transient Integer min = 0;
        Transient Integer max = 0;
        if (newPageIndex > pageNumber){
            min = pageNumber * pageSize;
            max = newPageIndex * pageSize;
        }
        else {
            max = newPageIndex * pageSize;
            min = max - pageSize;
        }
        for(Opportunity a : result){
            counter++;
            if (counter > min && counter <= max)
                pageResult.add(a);
        }
        pageNumber = newPageIndex;
    }
    
    //************************************************
    public static testMethod void testAll(){
        Opp_NV_tabListados c = new Opp_NV_tabListados();    
        
        c.Opp.Safra__c = '15/16';
        
        RecordType rt = [Select Id From RecordType Where Name = 'Pendiente' limit 1];
        
        c.setrt(rt.Id);
        String r = c.getrt();  
        
        Account acc = New Account (Name = 'Prueba');
        insert acc;
        
        c.setac(acc);
        Account a = c.getac();   
        
        c.listar();

        List<SelectOption> selOp = c.getRTypes();     
        
        Opportunity o = new Opportunity(Name='TMP',CloseDate=System.today(),StageName='Aberta',RecordTypeId=rt.Id);
        insert o;
        
        
        c.search();
        
        c.getTotalPageNumber();
        
        c.getResult();
        c.getPageNumber();
        c.getPageSize();
        c.getPreviousButtonEnabled();
        c.getNewButtonEnabled();
        c.getFirstButtonDisabled();
        c.getLastButtonDisabled();
        c.getNextButtonDisabled();        
        c.getTotalPageNumber();
        //c.BindData(1);
        c.firstBtnClick();
        c.getLastButtonDisabled();        
        c.getNextButtonDisabled();
        c.nextBtnClick();
        c.lastBtnClick();
        c.previousBtnClick();
        
        c.setSearchText('TMP');
        System.Assert(c.getSearchText() != null);
        
        c.result = null;
        c.getLastButtonDisabled();
        c.getNextButtonDisabled();
        //c.BindData(1);
        
    }
}
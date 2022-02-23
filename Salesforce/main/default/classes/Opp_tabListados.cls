public with sharing class Opp_tabListados {
    //************************************************************************
    //* JG 2009.06
    //* Metodo controlador paginas de VF: Opp_list_produccion, Opp_list_comercial
    //* Administra la lista de Oportunidades del tipo Multiplicador
    //************************************************************************
        
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
    private static String rt_expor_opps = '01240000000M570';
    
    
    private String rt_opp = '';
    private String searchText = '';
    public Opportunity opp {get; set;}
    public List<Opportunity> result = new List<Opportunity>();
    private List<Opportunity> pageResult;

    public Opp_tabListados() {
        this.opp = new Opportunity();
    }
    
    public void initFact(){
        rt_opp = rt_fact_opps;
        this.listar();
    }
    public void initProd(){
        rt_opp = rt_multi_opps;
        this.listar();
    }
    public void initComer(){
        rt_opp = rt_comer_opps;
        this.listar();
    }
    public void initBasica(){
        rt_opp = rt_franq_opps;
        this.listar();
    }
    public void initRebaja(){
        rt_opp = rt_rebaja_opps;
        this.listar();
    }    
    public void initEstoque(){
        rt_opp = rt_estoque_opps;
        this.listar();
    }
    public void initExpor(){
        rt_opp = rt_expor_opps;
        this.listar();
    }

    public void listar(){
        result = null;
        totalPageNumber = 0;
        this.search();
        BindData(1);
    }
    
    public String getCampania() {return safra;}
    public void setCampania(String valor) {safra = valor; }    
    public String getSearchText() {return searchText;}
    public void setSearchText(String arg) {searchText = arg;}
    public List<Opportunity> getResult() {return pageResult;}
    
    public void search(){
        String qry = 'select Id, Name, Mes__c, Regiao__r.Name, VB_Franqueado__c, VB_Franqueado__r.Name, StageName, Safra__c, Estado_Facturacion__c, CloseDate, Numero_del__c, Account.Id, Account.Name From Opportunity ';
        String s = searchText;
        String mes = ''; String region;
        List<Id> propIds = new List<Id>();
        propIds = colaboracionOpp(UserInfo.getProfileId());

		if(rt_opp == rt_fact_opps)
			qry += 'where OwnerId in: propIds and (RecordTypeId = : rt_fact_opps or RecordTypeId = : rt_fact_c_opps) ';
		else
        	qry += 'where OwnerId in: propIds and RecordTypeId = : rt_opp ';
        
        if(s != ''){ s = '%' + s + '%'; qry += 'and Name like :s ';}
        if(!(safra == '(Nenhuma)' || safra == '')) qry += 'and Safra__c = :safra '; 
        if(opp.Safra__c != null){ safra = this.opp.Safra__c; qry += 'and Safra__c = :safra ';}
        if(opp.Mes__c != null){ mes = this.opp.Mes__c; qry += 'and Mes__c = :mes ';}
        if(opp.Regiao__c != null){ region = this.opp.Regiao__c; qry += 'and Regiao__c = :region ';}
        qry += 'Order by Safra__c Desc limit 100';        
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
    
    public pageReference NuevaFact(){
        PageReference pr = new PageReference('/006/e');
        return pr;
    }
    public pageReference NuevaProd(){
        return Page.Opp_wzMulti_Paso1;
    }
    public pageReference NuevaComer(){
        return Page.Opp_wzComer_Paso1;
    }
    public pageReference NuevaBasica(){
        return Page.Opp_wzFranq_Paso1;
    }
    public pageReference NuevaRebaja(){
        return Page.Opp_wzRebaja_Paso1;
    }
    public pageReference NuevaEstoque(){
        return Page.Opp_wzEstoque_paso1;
    }
    public pageReference NuevaExpor(){
        return Page.Opp_wzExpor_paso1;
    }
    public Boolean getNewButtonEnabled(){               
        return (UserInfo.getProfileId() == '00e40000000rPTdAAM' || UserInfo.getProfileId() == '00e40000000rQiTAAU' || UserInfo.getProfileId() == '00e40000000rObQAAU' || UserInfo.getProfileId() == '00e40000000yy83AAA');
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
        Opp_tabListados c = new Opp_tabListados();               
        
        Opportunity o = new Opportunity(Name='TMP',CloseDate=System.today(),StageName='Aberta',RecordTypeId=rt_multi_opps);
        insert o;
        
        c.initProd();           
        c.initBasica();
        
        c.getTotalPageNumber();
        
        c.getResult();
        c.NuevaProd();
        c.NuevaComer();
        c.NuevaBasica();
        c.NuevaFact();

        c.getCampania();
        c.setCampania('06/07');
        c.initRebaja();
        c.initFact();   
        System.assertNotEquals(null,c.getResult(),'contactos son nulos despues de listar!!');
        c.getPageNumber();
        c.getPageSize();
        c.getPreviousButtonEnabled();
        c.getNewButtonEnabled();
        c.getFirstButtonDisabled();
        c.getLastButtonDisabled();
        c.getNextButtonDisabled();        
        c.getTotalPageNumber();
        c.NuevaRebaja();
        c.NuevaEstoque();
        c.BindData(1);
        c.firstBtnClick();
        c.getLastButtonDisabled();        
        c.getNextButtonDisabled();
        c.nextBtnClick();
        c.lastBtnClick();
        c.previousBtnClick();
        
        c.setSearchText('TMP');
        System.Assert(c.getSearchText() != null);
        c.initComer();
        
        c.result = null;
        c.getLastButtonDisabled();
        c.getNextButtonDisabled();
        c.BindData(1);
        
    }
}
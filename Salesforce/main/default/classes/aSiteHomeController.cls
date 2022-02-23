global class aSiteHomeController {
    private String token;
    public SiteUser__c logUser {get;set;}
    private SiteUserSession__c activeSession;
    private Account activeAccount;
    private String safraActual;
    public string language {get;set;}
    public string marcaLog {get;set;}
    
    public Grafico indicador;
    public List<Grafico2> indicador2;
    public List<Grafico2> indicador3;
    
    public Double vol_autorizado {get;set;}
    public Double vol_vendido {get;set;}
    public Double avance {get;set;}
    
    public Integer lxl_meta {get;set;}
    public Integer lxl_realizado {get;set;}
    public Integer emp_meta {get;set;}
    public Integer emp_realizado {get;set;}
    public Integer pal_trei_meta {get;set;}
    public Integer pal_trei_realizado {get;set;}
    public Integer dia_campo_meta {get;set;}
    public Integer dia_campo_realizado {get;set;}
    public Boolean area_ensaios {get;set;}
    
    public Double puntos_req_1 {get;set;}
    public Double puntos_req_2 {get;set;}
    public Double puntos_req_3 {get;set;}
    public Double puntos_req_4 {get;set;}
    
    public Double puntos_crm {get;set;}
    public Double puntos_stock {get;set;}
    
    public Double vendas_classe1 {get;set;}
    public Double vendas_classe2 {get;set;}
    public Double vendas_classe3 {get;set;}
    public Double desc_classe1 {get;set;}
    public Double desc_classe2 {get;set;}
    public Double desc_classe3 {get;set;}
    public Double desc_superior_classe3 {get;set;}
        
    public String categ_actual {get;set;}
    public String categ_anterior {get;set;}
    public String region_cuenta {get;set;}
    public Double total_puntos {get;set;}
    public Double porc_descuento {get;set;}
    
    public Boolean redirectArg {get;set;}
            
    public class Grafico {
        public Double value1 { get; set; }
        public Double value2 { get; set; }

        public Grafico(Double value1, Double value2) {
            this.value1 = value1;
            this.value2 = value2;
        }
    }
    
    public class Grafico2 {
        public String name { get; set; }
        public Double data { get; set; }

        public Grafico2(String name, Double data) {
            this.name = name;
            this.data = data;
        }
    }
    
    public String indicador1json {get; set;}
    public String indicador2json {get; set;}
    public String indicador3json {get; set;}
     
    global aSiteHomeController () {
        language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
        indicador1json = JSON.serialize(getindicador());
        
        redirectArg = false;        
    }

    public PageReference validate() {        
        
        token = System.currentPageReference().getParameters().get('token');
        if(token!=null){
            logUser = aSiteAuthManager.VerifyUserSession(token);
            if(logUser!=null){
                activeSession = aSiteAuthManager.getUserSession(token);
                marcaLog = activeSession.Marca__c;
                activeAccount = aSiteAuthManager.getActiveAccount_byUser(logUser);
                if (activeAccount.BillingCountry == 'PY' || activeAccount.BillingCountry == 'PARAGUAI' || activeAccount.BillingCountry == 'Paraguai')
                    redirectArg = true;
                safraActual = aAppManager.getSafraActualByApp('A2');
                setIndicador1y3(activeAccount.Id, safraActual, activeSession.Marca__c);
                indicador2json = JSON.serialize(getindicador2(activeAccount.Id, safraActual, activeSession.Marca__c));    
                getResumenVentasClasse(activeAccount.Id, safraActual, activeSession.Marca__c);            
                return null;  
            }          
        }
                
        PageReference p = new PageReference('/apex/aSiteLogin');
        String marca = aSiteAuthManager.getMarcaBySession(token);
        if (marca != null)
            p.getParameters().put('comp',marca);
        p.setRedirect(true);
        return p;
        
    }
    
    public void delay(){
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        Long millisec = 5000;
        while ((finishTime - startTime) < millisec) {
            //sleep for parameter x millisecs
            finishTime = DateTime.now().getTime();
        }
        String token = System.currentPageReference().getParameters().get('token');
        String ret = token;        
        ret = aSiteAuthManager.CloseUserSession(token);
    }
    
    public String getTotalProduction(){
        String value = ''; String recId;
        //Opportunity[] relatedApp = aAppManager.getProductionReportOpp(activeAccount.Id, activeSession.Safra__c, activeSession.Marca__c);
        Integer data = 0;
        
        //if(relatedApp.size()>0){
        //    recId=relatedApp[0].Id;
        //}
        
        //List<OpportunityLineItem> relatedAppItems = new List<OpportunityLineItem>();
        //relatedAppItems = aAppManager.getAnexosItemsByOpp(recId);
        
        //for(OpportunityLineItem s : relatedAppItems){
        //    if(s.Semente_aprovada__c!=null) data = data + Integer.valueOf(s.Semente_aprovada__c);
        //}
        
        Double valor = aAppManager.getTotalSemBrutaAII(activeAccount.Id, safraActual, activeSession.Marca__c);
                        
        value = String.valueOf(valor);
        return value;
    }
    
    public String getTotalPlantado(){
        String value = '';
                
        Double valor = aAppManager.getTotalHasPlantadasAII(activeAccount.Id, safraActual, activeSession.Marca__c);
                        
        value = String.valueOf(valor);
        return value;
    }
    
    public String getDiffProduction(){
        String value = '';
        value = String.valueOf(10) + '%';
        return value;
    }

    public String getTotalSold(){
        String value = ''; String recId;
        //Opportunity[] relatedApp = aAppManager.getSalesReportOpp(activeAccount.Id, activeSession.Safra__c, activeSession.Marca__c);
        Integer data = 0;
        
        //if(relatedApp.size()>0){
        //    recId=relatedApp[0].Id;
        //}
        
        //List<OpportunityLineItem> relatedAppItems = new List<OpportunityLineItem>();
        //relatedAppItems = aAppManager.getAnexosItemsByOpp(recId);
        
        //for(OpportunityLineItem s : relatedAppItems){
        //    if(s.Semente_comercializada__c!=null) data = data + Integer.valueOf(s.Semente_comercializada__c);
        //}
                        
        value = String.valueOf(data);
        return value;
    }
    public String getDiffSold(){
        String value = '';
        value = String.valueOf(30) + '%';
        return value;
    }        
    
    public Grafico getindicador(){
        indicador = New Grafico(22524, 100000);
        return indicador;
    }
    
    public void setIndicador1y3(String accId, String safra, String marca){
        CRM_Multiplicador__c perfil = aAppManager.getPerfilByMultiplicador(accId, safra);
        
        categ_anterior = aAppManager.getCategoriaBonifAnterior(accId, marca);
        
        vol_autorizado = 0;
        vol_vendido = 0;
        avance = 0;
        
        lxl_meta = 0;
        lxl_realizado = 0;
        emp_meta = 0;
        emp_realizado = 0;
        pal_trei_meta = 0;
        pal_trei_realizado = 0;
        dia_campo_meta = 0;
        dia_campo_realizado = 0;
        
        puntos_crm = 0;
        puntos_stock = 0;
        
        desc_classe1 = 0;
        desc_classe2 = 0;
        desc_classe3 = 0;
        desc_superior_classe3 = 0;
        
        indicador3 = New List<Grafico2>();
        
        Double porc_IPRO = 0;
        Double porc_RR = 0;
        
        region_cuenta = '';
        
        if(perfil != null)
            if(perfil.Region_Comercial__c != null)
                region_cuenta = perfil.Region_Comercial__c;
        
        if (perfil != null){                        
            if (marca == 'BRMX'){
                categ_actual = perfil.BR_Categoria_resultante__c;
                total_puntos = perfil.BR_Total_de_pontos__c;
                puntos_req_1 = perfil.Pontos_Porc_Vendas__c;
                puntos_req_2 = perfil.BR_Pontos_volume_2__c;
                puntos_req_3 = perfil.BR_Pontos_penetra_o__c;
                puntos_req_4 = perfil.BR_Pontos_mix__c;
                desc_classe1 = perfil.BRMX_Desconto_Classe_1__c;
                desc_classe2 = perfil.BRMX_Desconto_Classe_2__c;
                desc_classe3 = perfil.BRMX_Desconto_Classe_3__c;
                if (region_cuenta.contains('REGION')){
                    if (perfil.BRMX_Desconto_Obj_Rel_Gen_Dem__c > 12.50){
                        desc_classe3 = desc_classe3 - perfil.BRMX_Desconto_Obj_Rel_Gen_Dem__c + 12.50;
                        desc_superior_classe3 = perfil.BRMX_Desconto_Obj_Rel_Gen_Dem__c - 12.50;
                    }
                }else{
                    if (perfil.BRMX_Desconto_Obj_Rel_Gen_Dem__c > 11.76){
                        desc_classe3 = desc_classe3 - perfil.BRMX_Desconto_Obj_Rel_Gen_Dem__c + 11.76;
                        desc_superior_classe3 = perfil.BRMX_Desconto_Obj_Rel_Gen_Dem__c - 11.76;
                    }
                }                
                //if (perfil.BRMX_Desconto_Obj_Rel_Gen_Dem__c > 2){
                //    desc_classe3 = desc_classe3 - perfil.BRMX_Desconto_Obj_Rel_Gen_Dem__c + 2;
                //    desc_superior_classe3 = perfil.BRMX_Desconto_Obj_Rel_Gen_Dem__c - 2;
                //}
                if (perfil.BR_LXL_Meta__c != null)
                    lxl_meta = Integer.valueOf(perfil.BR_LXL_Meta__c);
                if (perfil.BR_LXL_Realizado__c != null)
                    lxl_realizado = Integer.valueOf(perfil.BR_LXL_Realizado__c);    
                if (perfil.BR_Emplacamentos_Meta__c != null)
                    emp_meta = Integer.valueOf(perfil.BR_Emplacamentos_Meta__c);
                if (perfil.BR_Identifica_o_de_beiras_de_rodovia__c != null)
                    emp_realizado = Integer.valueOf(perfil.BR_Identifica_o_de_beiras_de_rodovia__c);    
                if (perfil.BR_Palestras_Meta__c != null)
                    pal_trei_meta = Integer.valueOf(perfil.BR_Palestras_Meta__c);
                if (perfil.BR_Treinamentos_Meta__c != null)
                    pal_trei_meta += Integer.valueOf(perfil.BR_Treinamentos_Meta__c);   
                if (perfil.BR_Palestras_Realizado__c != null)
                    pal_trei_realizado = Integer.valueOf(perfil.BR_Palestras_Realizado__c);
                if (perfil.BR_Treinamentos_Realizado__c != null)
                    pal_trei_realizado += Integer.valueOf(perfil.BR_Treinamentos_Realizado__c);
                if (perfil.BR_Penetra_o_INTACTA__c != null){                
                    porc_IPRO = perfil.BR_Penetra_o_INTACTA__c;
                    porc_RR = 100 - porc_IPRO;  
                }
                if (perfil.BR_Soma_de_Meta__c  != null)
                    vol_autorizado = perfil.BR_Soma_de_Meta__c ;
                if (perfil.BR_SemComer_Safra_actual__c != null)
                    vol_vendido = perfil.BR_SemComer_Safra_actual__c;
                    
                if (perfil.BR_Desconto_CRM__c != null)
                    puntos_crm = perfil.BR_Desconto_CRM__c;
                if (perfil.BR_Pontos_Stock_Mult__c != null)
                    puntos_stock = perfil.BR_Pontos_Stock_Mult__c;      
            }
            if (marca == 'DSEM'){
                categ_actual = perfil.DS_Categoria_resultante__c;
                porc_descuento = perfil.DS_Categoria__c;
                if (perfil.DS_LXL_Meta__c != null)
                    lxl_meta = Integer.valueOf(perfil.DS_LXL_Meta__c);
                if (perfil.DS_LXL_Realizado__c != null)
                    lxl_realizado = Integer.valueOf(perfil.DS_LXL_Realizado__c);    
                if (perfil.DS_Emplacamentos_Meta__c != null)
                    emp_meta = Integer.valueOf(perfil.DS_Emplacamentos_Meta__c);
                if (perfil.DS_Identifica_o_de_beiras_de_rodovia__c != null)
                    emp_realizado = Integer.valueOf(perfil.DS_Identifica_o_de_beiras_de_rodovia__c);    
                if (perfil.DS_Palestras_Meta__c != null)
                    pal_trei_meta = Integer.valueOf(perfil.DS_Palestras_Meta__c);
                if (perfil.DS_Palestras_Realizado__c != null)
                    pal_trei_realizado = Integer.valueOf(perfil.DS_Palestras_Realizado__c);                 
                if (perfil.DS_Participacao_dia_de_campo_meta__c != null)
                    dia_campo_meta = Integer.valueOf(perfil.DS_Participacao_dia_de_campo_meta__c);
                if (perfil.DS_Participacao_dia_campo_realizado__c != null)
                    dia_campo_realizado = Integer.valueOf(perfil.DS_Participacao_dia_campo_realizado__c);   
                area_ensaios = perfil.DS_Areas_para_ensaios__c;
                if (perfil.DS_Soma_de_Meta__c  != null)
                    vol_autorizado = perfil.DS_Soma_de_Meta__c;
                if (perfil.DSoma_de_Sem_Comercializada__c != null)
                    vol_vendido = perfil.DSoma_de_Sem_Comercializada__c;                
            }
        }
        
        indicador3.add(New Grafico2('IPRO', porc_IPRO));
        indicador3.add(New Grafico2('RR', porc_RR));
        
        indicador3json = JSON.serialize(indicador3);
                
        if (vol_autorizado != 0){
            avance = Decimal.valueOf((vol_vendido / vol_autorizado * 100)).divide(1, 2, System.RoundingMode.HALF_EVEN);
            if (avance > 100)
                avance = 100;   
        }       
                        
    }    
    
    public List<Grafico2> getindicador2(String accId, String safra, String marca){
        indicador2 = New List<Grafico2>();
        
        List<OpportunityLineItem> items = New List<OpportunityLineItem>();
        items = aAppManager.getVentasByMultiplicador(accId, safra, marca);
        items = aAppManager.valVentasByMultiplicador(items);
        
        if (items != null)
            for (OpportunityLineItem i : items)
                if (i.Semente_Comercializada__c > 0)
                    if (vol_vendido > 0)
                        indicador2.add(New Grafico2(i.Variedade_Prod__c, Double.valueOf(Decimal.valueOf(Double.valueOf(i.Semente_Comercializada__c) / vol_vendido * 100).divide(1, 2, System.RoundingMode.HALF_EVEN))));                
            
        return indicador2;
    }
    
    public void getResumenVentasClasse(String accId, String safra, String marca){
        List<OpportunityLineItem> items = New List<OpportunityLineItem>();
        items = aAppManager.getVentasByMultiplicador(accId, safra, marca);
        items = aAppManager.valVentasByMultiplicadorClasse(items);
        
        vendas_classe1 = 0;
        vendas_classe2 = 0;
        vendas_classe3 = 0;     
        
        if (items != null)
            for (OpportunityLineItem i : items){
                if (i.PricebookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c == '1')
                    vendas_classe1 = i.Semente_comercializada__c;
                if (i.PricebookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c == '2')
                    vendas_classe2 = i.Semente_comercializada__c;
                if (i.PricebookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c == '3')
                    vendas_classe3 = i.Semente_comercializada__c;       
            }
        
    }
    
    public PageReference gotoAppend2(){
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix2');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }
    
    public PageReference gotoAppend3(){
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix3');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }
              
    public PageReference gotoAppend4(){
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix4');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public SiteUser__c getUser(){
        return logUser;
    }
}
public without sharing class Autorizar_Relatorios_Controller  {

    public OpportunityLineItem Item;
    public Opportunity opp = new Opportunity();
    public Opportunity tipoAnexo = new Opportunity();   
    public Account cuenta = new Account();
    public Product2 pro = new Product2();    
    public Contrato__c contrato = new Contrato__c();
    public Contrato__c aditivo = New Contrato__c();
    public Item_del_Contrato__c itemCont = New Item_del_Contrato__c();
    public List<Item_del_Contrato__c> itemAdi = New List<Item_del_Contrato__c>();
    public map<String,Item_del_Contrato__c> mapItAd = New map<String,Item_del_Contrato__c>();
    public map<String,Double> mapCantItAd = New map<String,Double>();
    public map<String,Item_del_Contrato__c> mapItContRel = New map<String,Item_del_Contrato__c>();
    public map<String,PricebookEntry> mapPrecios = New map<String,PricebookEntry>();
    public map<String,String> mapLPNombres = New map<String,String>();
    public List<Opor> listaOpp = new List<Opor>();    
    public String Mensaje;    
    public String url = '';    
    public Opportunity Fact_Param = new Opportunity();
    public String TipoCambio = '';
    public String TipoCot = '';
    public Map<String,Double> varCatCant = New Map<String,Double>();
    public Map<String,Double> precCont = New Map<String,Double>();
    public map<String,Centro_Logistico__c> centLog = New map<String,Centro_Logistico__c>();
    public Double cotiz = 0;
    public Configuracion_BMX__c confTasas = New Configuracion_BMX__c(Londrina_Tasa_COFINS__c=0, Londrina_Tasa_ISS__c=0, Londrina_Tasa_PIS__c=0, Passo_Fundo_Tasa_COFINS__c=0, Passo_Fundo_Tasa_ISS__c=0, Passo_Fundo_Tasa_PIS__c=0);
    public Date vencimAnexoIII = null;
    public Date vencimAnexoIV = null;
    
        
    Set<Id> resultIdsItemsAux = new Set<Id>();
         
    public Autorizar_Relatorios_Controller(){
        opp.safra__c = '20/21';
        opp.Marca__c = 'BRMX';
        opp.RecordTypeId = '01240000000M58N';
        opp.Tipo__c = 'ZO09 - BR Regalías';
        cotiz = 0;
        if(Item == null)
            Item = new OpportunityLineItem();
        for (Configuracion_BMX__c conf : [Select Londrina_Tasa_COFINS__c, Londrina_Tasa_ISS__c, Londrina_Tasa_PIS__c, Passo_Fundo_Tasa_COFINS__c, Passo_Fundo_Tasa_ISS__c, Passo_Fundo_Tasa_PIS__c, Vencimiento_Anexo_III__c, Vencimiento_Anexo_IV__c From Configuracion_BMX__c limit 1]){
                if (conf.Londrina_Tasa_COFINS__c != null) confTasas.Londrina_Tasa_COFINS__c = conf.Londrina_Tasa_COFINS__c;
                if (conf.Londrina_Tasa_ISS__c != null) confTasas.Londrina_Tasa_ISS__c = conf.Londrina_Tasa_ISS__c;
                if (conf.Londrina_Tasa_PIS__c != null) confTasas.Londrina_Tasa_PIS__c = conf.Londrina_Tasa_PIS__c;
                if (conf.Passo_Fundo_Tasa_COFINS__c != null) confTasas.Passo_Fundo_Tasa_COFINS__c = conf.Passo_Fundo_Tasa_COFINS__c;
                if (conf.Passo_Fundo_Tasa_ISS__c != null) confTasas.Passo_Fundo_Tasa_ISS__c = conf.Passo_Fundo_Tasa_ISS__c;                    
                if (conf.Passo_Fundo_Tasa_PIS__c != null) confTasas.Passo_Fundo_Tasa_PIS__c = conf.Passo_Fundo_Tasa_PIS__c;
                if (conf.Vencimiento_Anexo_III__c != null) vencimAnexoIII = conf.Vencimiento_Anexo_III__c;
                if (conf.Vencimiento_Anexo_IV__c != null) vencimAnexoIV = conf.Vencimiento_Anexo_IV__c;
        }
        for(PricebookEntry pbi: [SELECT Id, Pricebook2Id, Pricebook2.Name, Product2.Categ__c, Product2.Variedade__c, UnitPrice FROM PricebookEntry WHERE isActive = true And Pricebook2.Name IN ('Lista Canal Multiplicadores', 'Lista Canal Multiplicadores - REGION 1', 'Lista Canal Multiplicadores - REGION 2', 'Lista Canal Multiplicadores - CERRADO', 'Lista de precios de Licencias', 'Lista DSEM', 'Lista DSEM - REGION 1', 'Lista DSEM - REGION 2', 'Lista DSEM - CERRADO', 'Lista NEOG', 'Lista NEOG - REGION 1', 'Lista NEOG - REGION 2', 'Lista NEOG - CERRADO')]){
            //if(!mapPrecios.ContainsKey(String.ValueOf(pbi.Pricebook2Id) + String.ValueOf(pbi.Product2.Variedade__c) + String.ValueOf(pbi.Product2.Categ__c))) mapPrecios.put(String.ValueOf(pbi.Pricebook2Id) + String.ValueOf(pbi.Product2.Variedade__c) + String.ValueOf(pbi.Product2.Categ__c), pbi);
            if(!mapPrecios.ContainsKey(String.ValueOf(pbi.Pricebook2.Name) + String.ValueOf(pbi.Product2.Variedade__c) + String.ValueOf(pbi.Product2.Categ__c))) mapPrecios.put(String.ValueOf(pbi.Pricebook2.Name) + String.ValueOf(pbi.Product2.Variedade__c) + String.ValueOf(pbi.Product2.Categ__c), pbi);
            if(!mapLPNombres.ContainsKey(String.valueOf(pbi.Pricebook2Id))) mapLPNombres.put(String.valueOf(pbi.Pricebook2Id), String.valueOf(pbi.Pricebook2.Name));
        }
        for(Centro_Logistico__c cl: [SELECT Id, Name, Codigo_SAP__c, Licencias__c, Marca__c FROM Centro_Logistico__c WHERE Licencias__c = false]) centLog.put(String.ValueOf(cl.Id), cl);
            
        for (RecordType rt : [SELECT Id, Name FROM RecordType WHERE Name = 'Anexo III' AND SobjectType='Opportunity'])                            
            tipoAnexo.RecordTypeId = rt.Id;
            
        contrato.Tipo_de_Cota_o__c = 'SOJA';
        
        tipoAnexo.RecordTypeId = '01240000000M7y6';
            
    }
 
    public class Opor{
        public Opportunity oport {get;set;}
        public OpportunityLineItem opli {get;set;}
        public Boolean selected {get;set;}
        public Double Quant_Disp {get;set;}
        public Double Quantidade {get;set;}
    }                    
    public class OppFact{
        public Opportunity oport {get;set;}
        public List<OpportunityLineItem> oplis {get;set;}
        public Boolean generaNC {get;set;}
    }

    public Opportunity getFact_Param(){
       return Fact_Param;
    }

    public Void setFact_Param(Opportunity arg){
       Fact_Param = arg;
    }

    public List<SelectOption> getOptionOrigen(){
       List<SelectOption> lista = new List<SelectOption>();
       Boolean lic = false;
       User usuario = [SELECT Id, Profile.Name FROM User WHERE Id =: Userinfo.getUserId()];
       if(usuario.Profile.Name == 'Administrativo_licencias') lic = true;
       for (Centro_Logistico__c c : [Select Id, Name from Centro_Logistico__c WHERE Name != '0097 - Rio Verde' AND Licencias__c = : lic  Order By Name]){                            
            lista.add(new SelectOption(c.Id,c.Name));
            if (c.Name == '0095 - Cambé')
                opp.Origen__c = c.Id;
       }
       return lista;
    }
    
    public List<SelectOption> getOptionRecType(){
       List<SelectOption> lista = new List<SelectOption>();
       for (RecordType rt : [SELECT Id, Name FROM RecordType WHERE (Name='Anexo III' OR Name = 'Anexo IV') AND SobjectType='Opportunity'  Order By Name]){                            
            lista.add(new SelectOption(rt.Id,rt.Name));
       }
       return lista;
    }

    public Contrato__c getcontrato(){    
        return contrato;      
    }
    
    public void setcontrato(Contrato__c arg){    
        contrato = arg;      
    }

    public String geturl(){    
        return url;      
    }
    
    public void seturl(String arg){    
        url = arg;      
    }      

    public OpportunityLineItem getItem() {
        return Item;
    }
    
    public void setItem(OpportunityLineItem i) {
        Item=i;
    }

    public Item_del_Contrato__c getItemCont() {
        return itemCont;
    }    
    public void setItemCont(Item_del_Contrato__c i) {
        itemCont=i;
    }

    public Opportunity getOpp() {
        return opp;
    }    
    public void setOpp(Opportunity i) {
        opp=i;
    }
    
    public Opportunity getTipoAnexo(){
        return tipoAnexo;
    }
    public void setTipoAnexo(Opportunity i){
        tipoAnexo=i;
    }
    public Account getcuenta() {
        return cuenta;
    }    
    public void setcuenta(Account i) {
        cuenta=i;
    }

    public Product2 getpro() {
        return pro;
    }    
    public void setpro(Product2 i) {
        pro=i;
    }
    
    public List<Opor> getlistaOpp() {
        return listaOpp;
    }
    
    public void setlistaOpp(List<Opor> arg) {
        listaOpp=arg;
    }
                    
    public Void Buscar () {
        Double sumCant = 0; Double mult = 1; Double sumAdi = 0;
        Mensaje='';
        cotiz=0; 
        varCatCant.clear();
        if (listaOpp != null)
            listaOpp.clear();
              
        resultIdsItemsAux.clear();  
        
        Fact_Param = New Opportunity();

        if (opp.AccountId == null){ Mensaje = 'Deve ingressar uma Conta'; return;}  
           
        //if (contrato.Tipo_de_Cota_o__c == null){ Mensaje = 'Deve Selecionar um Tipo de Cotação'; return;}
                        
        //if (contrato.Tipo_de_Cota_o__c == 'SOJA' && contrato.Cotacao_de_soja__c == null){ Mensaje = 'Deve Selecionar Cotação de soja'; return;}

        if (opp.Safra__c == null){ Mensaje = 'Deve Selecionar uma Safra'; return;}
        
        if (opp.Marca__c == null || opp.Marca__c == ''){ Mensaje = 'Deve Selecionar uma Marca'; return;}
        
        //if(opp.Marca__c != centLog.get(String.ValueOf(opp.Origen__c)).Marca__c){ Mensaje = 'Deve selecionar um Escritório da mesma marca.'; return;}
        
        //if(tipoAnexo.RecordTypeId == '01240000000M7y8AAC' && opp.Filtro_Contrato_Mult__c != null) { Mensaje = 'Ao processar Anexo IV não pode ser indicado um aditivo.'; return;} 
        
        if(opp.Filtro_Contrato_Mult__c != null){
            aditivo = [SELECT Id, Name, RecordType.Name, Multiplicador__c, Safra__c, Sociedad__c, Aditivo_Facturado__c, Tipo_de_cambio__c FROM Contrato__c WHERE Id = : opp.Filtro_Contrato_Mult__c];
            if (aditivo.Aditivo_Facturado__c){ Mensaje = 'O aditivo ingressado foi facturado.'; opp.Filtro_Contrato_Mult__c = null; return; } 

            if (aditivo.Multiplicador__c != opp.AccountId){ Mensaje = 'Deve Selecionar um Aditivo da conta ingressada.'; opp.Filtro_Contrato_Mult__c = null; return; }          
            
            if (aditivo.RecordType.Name != 'Aditivo BRMX' && aditivo.RecordType.Name != 'Aditivo DSEM' && aditivo.RecordType.Name != 'Aditivo % BRMX' && aditivo.RecordType.Name != 'Aditivo % DSEM'){ Mensaje = 'Deve Selecionar um Contrato com Tipo de Registro Aditivo.'; opp.Filtro_Contrato_Mult__c = null; return; }

            if (aditivo.RecordType.Name.right(4) != opp.Marca__c){ Mensaje = 'Deve Selecionar um Aditivo com a mesma Marca selecionada.'; opp.Filtro_Contrato_Mult__c = null; return; }
    
            if (aditivo.Safra__c != opp.Safra__c){ Mensaje = 'Deve Selecionar um Aditivo com a mesma Safra selecionada.'; opp.Filtro_Contrato_Mult__c = null; return; }
            
            if (aditivo.Tipo_de_cambio__c <= 0){ Mensaje = 'Erro. Tem que preencher no aditivo a cotação.'; opp.Filtro_Contrato_Mult__c = null; return; }
            
            for(Item_del_Contrato__c i: [Select Id, Name, Cultivar__r.Variedade__c, Categoria__c, Quantidade__c, Precio__c, Porcentaje__c FROM Item_del_Contrato__c WHERE Contrato_de_Multiplicacion__c =: aditivo.Id]){
                itemAdi.Add(i);
                //if(!mapItAd.ContainsKey(String.ValueOf(i.Cultivar__r.Variedade__c)+String.ValueOf(i.Categoria__c)))mapItAd.put(String.ValueOf(i.Cultivar__r.Variedade__c)+String.ValueOf(i.Categoria__c), i);
                if(!mapItAd.ContainsKey(String.ValueOf(i.Cultivar__r.Variedade__c))){mapItAd.put(String.ValueOf(i.Cultivar__r.Variedade__c), i); mapCantItAd.put(String.ValueOf(i.Cultivar__r.Variedade__c), 0);}
            }
            cotiz = aditivo.Tipo_de_cambio__c;
        }
        
        TipoCot=contrato.Tipo_de_Cota_o__c;
        if(contrato.Tipo_de_Cota_o__c == 'FATURAMENTO') cotiz = 1;
                
        TipoCambio = '';
        if (contrato.Cotacao_de_soja__c != null) TipoCambio = contrato.Cotacao_de_soja__c;                 
        
        List<RecordType> rt=[SELECT Id FROM RecordType WHERE (Name='Anexo III' OR Name = 'Anexo IV') AND SobjectType='Opportunity'];
        List<Profile> prof=[SELECT Id, Name FROM Profile WHERE Name='Administrador del sistema'];
        List<OpportunityLineItem> resultItems;
        Set<Id> listaIdOpportunity = New Set<Id>();
        Set<Id> listaIdOppLineItem = New Set<Id>();
        Set<Id> listaContratos = New Set<Id>();
        List<Opportunity> Oportunidades = New List<Opportunity>();
        List<OpportunityLineItem> Pend = New List<OpportunityLineItem>();
        
                
        Integer cont = 0;
        
        String qry;

        qry = 'SELECT Id, OpportunityId, Opportunity.Name, Opportunity.OwnerId, Opportunity.CloseDate, Opportunity.Account.Name,';
        qry += ' Opportunity.Account.Estado__c, Opportunity.Account.Id, Opportunity.Account.Grupo_de_cuentas__c,';
        qry += ' Opportunity.Safra__c, PriceBookEntry.Product2.Variedad__c, PriceBookEntry.Product2.Variedade__c,';
        qry += ' Contrato_relacionado__c, Tipo_de_Cotizacion__c, Cot_Soja__c, UnitPrice FROM OpportunityLineItem';
        qry += ' WHERE Opportunity.RecordTypeId= \''+tipoAnexo.RecordTypeId+'\' AND Opportunity.StageName= \'Aprobada\'';
        
        //qry += ' AND Contrato_relacionado__r.Tipo_de_Cota_o__c = \''+this.contrato.Tipo_de_Cota_o__c+'\'';
        
        //if (contrato.Tipo_de_Cota_o__c == 'SOJA') qry += ' AND Contrato_relacionado__r.Cotacao_de_soja__c = \''+this.contrato.Cotacao_de_soja__c+'\'';
                               
        if (this.opp.AccountId != null) qry += ' AND Opportunity.AccountId = \''+this.opp.AccountId+'\'';          
                      
        if (this.opp.Safra__c != null) qry += ' AND Opportunity.Safra__c = \''+this.opp.Safra__c+'\'';                        
           
        if (this.opp.Marca__c != null) qry += ' AND Opportunity.Marca__c = \''+this.opp.Marca__c+'\'';
        
        qry += ' AND Estado_Facturacion__c != \'Pasado Pedido\' AND IsDeleted = false';   
                        
        if(UserInfo.getProfileId() == '00e40000000yy83AAA'){ qry += ' AND Opportunity.OwnerId = \'' + UserInfo.getUserId() +'\'';}                                   
        else{ if(UserInfo.getProfileId() != '00e40000000yy83AAA'){ qry += ' AND Opportunity.OwnerId != \'00540000001TUHM\'';}}  /// PRODUCTIVO ///       
        qry += ' Limit 1000'; 
                                                             
        resultItems = Database.query(qry);

        if (resultItems != null){
           for (OpportunityLineItem i: resultItems){                         
              if (!(listaIdOpportunity.contains(i.OpportunityId)))
                 listaIdOpportunity.add(i.OpportunityId);
              if (!(listaIdOppLineItem.contains(i.Id)))
                 listaIdOppLineItem.add(i.Id);                                  
           }
           Oportunidades = [SELECT Id, Name, RecordType.Name, RecordTypeId, CloseDate, Account.Name, Account.Id, Safra__c, Marca__c, Account.Grupo_de_Cuentas__c, Owner.Profile.Name, Region__c,(Select Id, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.Variedad__c, PriceBookEntry.Product2.Variedade__c, PriceBookEntry.Product2.Variedade__r.Tecnologia__c, PriceBookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c, Semente_comercializada__c, Semente_uso_propio__c, Categoria__c, UnitPrice, PricebookEntry.UnitPrice, PricebookEntry.Pricebook2Id, Tipo_de_Cotizacion__c, Cot_Soja__c From OpportunityLineItems Where Id In : listaIdOppLineItem) FROM Opportunity WHERE Id in : listaIdOpportunity AND IsDeleted = false];
           
           for(OpportunityLineItem r: [SELECT Opportunity.Relatorio_Relacionado__c, Opportunity.RecordType.Name, Categoria__c, PricebookEntryId, PricebookEntry.Product2Id, PricebookEntry.Product2.Variedade__c, Quantity From OpportunityLineItem Where Opportunity.Relatorio_Relacionado__c IN : listaIdOpportunity AND Opportunity.RecordType.Name IN ('Autorizada', 'Pendiente','NC - Autorizada','NC - Pendiente') AND IsDeleted = false]){
                mult = 1;
                if(r.Opportunity.RecordType.Name == 'NC - Pendiente' || r.Opportunity.RecordType.Name == 'NC - Autorizada') mult = -1;
                if(varCatCant.ContainsKey(String.ValueOf(r.Opportunity.Relatorio_Relacionado__c)+String.ValueOf(r.PricebookEntry.Product2.Variedade__c) + String.valueOf(r.Categoria__c))){
                    sumCant = 0;
                    sumCant = varCatCant.get(String.ValueOf(r.Opportunity.Relatorio_Relacionado__c)+String.ValueOf(r.PricebookEntry.Product2.Variedade__c) + String.valueOf(r.Categoria__c));
                    sumCant += (r.Quantity * mult);
                    varCatCant.remove(String.ValueOf(r.Opportunity.Relatorio_Relacionado__c)+String.ValueOf(r.PricebookEntry.Product2.Variedade__c) + String.valueOf(r.Categoria__c));
                    varCatCant.put(String.ValueOf(r.Opportunity.Relatorio_Relacionado__c)+String.ValueOf(r.PricebookEntry.Product2.Variedade__c) + String.valueOf(r.Categoria__c), sumCant);                    
                }else{
                    varCatCant.put(String.ValueOf(r.Opportunity.Relatorio_Relacionado__c)+String.ValueOf(r.PricebookEntry.Product2.Variedade__c) + String.valueOf(r.Categoria__c), r.Quantity);
                }
           }
                        
           for (Opportunity o:Oportunidades) {
              for(OpportunityLineItem oli: o.OpportunityLineItems){                     
                    Opor op = new Opor();
                    op.oport=o;
                    op.selected=false;
                    op.opli = oli;
                    op.Quantidade = 0;
                    if(varCatCant.ContainsKey(String.ValueOf(o.Id)+String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c) + String.valueOf(oli.Categoria__c))){
                        if(varCatCant.get(String.ValueOf(o.Id)+String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c) + String.valueOf(oli.Categoria__c)) > 0){op.Quant_disp = (oli.Semente_comercializada__c + oli.Semente_uso_propio__c) - varCatCant.get(String.ValueOf(o.Id)+String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c) + String.valueOf(oli.Categoria__c));}
                        else{op.Quant_disp = (oli.Semente_comercializada__c + oli.Semente_uso_propio__c);}
                    }else{op.Quant_disp = (oli.Semente_comercializada__c + oli.Semente_uso_propio__c);}
                                                            
                    
                    if(o.RecordType.Name != 'Anexo IV'){ if(op.Quant_Disp < 0) op.Quant_disp = 0;}
                    if(opp.Filtro_Contrato_Mult__c != null){
                        //if(!mapItAd.ContainsKey(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)+String.ValueOf(oli.Categoria__c))){ continue;}
                        //else{
                        //  if(mapItAd.get(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)+String.ValueOf(oli.Categoria__c)).Quantidade__c <= op.Quant_Disp) op.Quantidade = mapItAd.get(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)+String.ValueOf(oli.Categoria__c)).Quantidade__c;
                        //  else{op.Quantidade = op.Quant_Disp;} 
                        //}
                        if(aditivo.RecordType.Name.contains('%')){
                            if(!mapItAd.ContainsKey(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c))){ continue;}
                                else{
                                    //op.Quantidade = mapItAd.get(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)).Porcentaje__c * op.Quant_Disp / 100;
                                    op.Quantidade = mapItAd.get(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)).Porcentaje__c * (oli.Semente_comercializada__c + oli.Semente_uso_propio__c) / 100;
                                    if (op.Quantidade > op.Quant_Disp)
                                        op.Quantidade = op.Quant_Disp;
                                }                               
                        }else{                                              
                            if(!mapItAd.ContainsKey(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)) || (mapItAd.get(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)).Quantidade__c == mapCantItAd.get(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)))){ continue;}
                            else{
                                if((mapItAd.get(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)).Quantidade__c - mapCantItAd.get(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c))) <= op.Quant_Disp) op.Quantidade = (mapItAd.get(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)).Quantidade__c - mapCantItAd.get(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)));
                                else{op.Quantidade = op.Quant_Disp;}
                                sumAdi = 0;
                                sumAdi = mapCantItAd.get(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c));
                                sumAdi = sumAdi + op.Quantidade;
                                mapCantItAd.remove(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c));
                                mapCantItAd.put(String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c), sumAdi);
                            }
                        }
                    }else{
                        op.Quantidade = op.Quant_Disp;
                    }
                    listaOpp.add(op);
              }
              if (cont == 998 && Oportunidades.size() == 1000){
                 ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Se estan visualizando 999 registros. Hay mas registros para consultar.');                 
                 ApexPages.addMessage(msg); 
                 break;  
              }
              cont += 1;   
           }
        }                                                                                                 
    }
            
    public void getVerDetalles () {

    }
    
    public String getFacturar () {
       if (listaOpp.size() > 0)           
          return '/apex/Facturar_Fecha_Valor';    

       return '';   
    }
    
    public Boolean getVerDetallesDisabled(){    
       if (listaOpp.size() == 0) return true;       
       return false;    
    }
    
    public void CrearPedidos () {
    
       List <OpportunityLineItem> items;
       List <RecordType> rt = [SELECT Id FROM RecordType WHERE Name = 'Pendiente' OR Name = 'NC - Pendiente' order by Name];
       List <OpportunityLineItem> itemsFactura = New List <OpportunityLineItem>();
       List <OpportunityLineItem> ListaItemsParaActualizarEstado = New List<OpportunityLineItem>();
       List<Item_del_Contrato__c> resultItems;
       List <OppFact> oppsfact = New List <OppFact>();
       Boolean HaySeleccion = false;Boolean CantPasadas = false;Boolean factAditivo = false;Boolean inverno = false;
       String tipo = ''; Id recT = rt[1].Id; Double mult = 1; String condP = ''; String motivoP = '';
       
       String pedidosCreados = '';
       
       Date vAnexo = null;
       
       Account acc = [Select Id, Region_Comercial__c From Account Where Id = : this.opp.AccountId];
       String centroOrigen = '0094 - Passo Fundo';
       if (acc.Region_Comercial__c != null && acc.Region_Comercial__c != '')
           if (acc.Region_Comercial__c == 'REGION 2' || acc.Region_Comercial__c == 'CERRADO')
               centroOrigen = '0095 - Cambé';
       Centro_Logistico__c centroOrigen2 = [Select Id, Name from Centro_Logistico__c WHERE Name = : centroOrigen limit 1];
       
       Double sumaTasas = confTasas.Passo_Fundo_Tasa_COFINS__c + confTasas.Passo_Fundo_Tasa_ISS__c + confTasas.Passo_Fundo_Tasa_PIS__c;      
       //if(centLog.get(String.ValueOf(opp.Origen__c)).Name.contains('Londrina') || centLog.get(String.ValueOf(opp.Origen__c)).Name.contains('Cambe')){
       if(centroOrigen == '0095 - Cambé'){
            sumaTasas = confTasas.Londrina_Tasa_COFINS__c + confTasas.Londrina_Tasa_ISS__c + confTasas.Londrina_Tasa_PIS__c;
       }            
       
       Set <Id> olis = New Set<Id>();

        if(opp.Filtro_Contrato_Mult__c != null){
            factAditivo = true; Fact_Param.Fecha_fijacion_T_de_cambio__c = system.today();
        }
        if(opp.Marca__c == 'DSEM') Fact_Param.Fecha_fijacion_T_de_cambio__c = system.today(); 
        String qry;
        
        /*
        qry = 'SELECT Id, Contrato_de_Multiplicacion__c, Cultivar__r.Variedade__c, Precio__c FROM Item_del_Contrato__c';
                
        qry += ' WHERE Contrato_de_Multiplicacion__r.Multiplicador__c = \'' +this.opp.AccountId+'\'';
                
        qry += ' AND Contrato_de_Multiplicacion__r.Safra__c = \''+this.opp.Safra__c+'\'';
                
        qry += 'AND Contrato_de_Multiplicacion__r.RecordType.Name = \''+this.opp.Marca__c+'\'';
                
        qry += ' AND Contrato_de_Multiplicacion__r.Tipo_de_Cota_o__c = \''+this.contrato.Tipo_de_Cota_o__c+'\'';
                
        if (contrato.Tipo_de_Cota_o__c == 'SOJA')
            qry += ' AND Contrato_de_Multiplicacion__r.Cotacao_de_soja__c = \''+this.contrato.Cotacao_de_soja__c+'\'';        
                                
        qry += ' Limit 1000';
                                                                     
        resultItems = Database.query(qry);
                
        if (resultItems != null){
            for (Item_del_Contrato__c itc: resultItems){
                if(!precCont.ContainsKey(String.ValueOf(itc.Cultivar__r.Variedade__c))){
                    precCont.put(String.ValueOf(itc.Cultivar__r.Variedade__c), itc.Precio__c);
                }
            }
        }
        */
        
       Mensaje = '';
       url = '';
       
       for (Opor opo :listaOpp)
          if (opo.Quantidade != 0){
             HaySeleccion=true;
             break;
          }
          
       if (!HaySeleccion){
            Mensaje = 'Deve ingressar pelo menos uma quantidade.';
            return;
       }
       for(Opor opo: listaOpp)
          if(opo.Quantidade != 0 && opo.Quantidade > opo.Quant_disp){
            CantPasadas = true;
            break;
          }
       
       if (CantPasadas){
          Mensaje = 'As quantidades não devem superar à quantidade disponível';
          return;
       }
       
       List<CRM_Bonificacion__c> bonif = New List<CRM_Bonificacion__c>();
       Double descuentoDM = 0;
       Double descuentoBR1 = 0;
       Double descuentoBR2 = 0;
       Double descuentoBR3 = 0;
       Double descuentoBR3_superior = 0;
       Double descuentoNG = 0;
       Double descuentoNG_superior = 0;
       Double descuentoNG_adic_novas_tec = 0;
       String categoria = '';
       bonif = [Select Id, BR_Catergoria_BRXM__c, DS_Categoria__c, BR_Categoria_resultante__c, DS_Categoria_resultante__c, BRMX_Descuento__c, BRMX_Desconto_Classe_1__c, BRMX_Desconto_Classe_2__c, BRMX_Desconto_Classe_3__c, BRMX_Desconto_Obj_Rel_Gen_Dem__c, BRMX_Desconto_Classe_1_AIV__c, BRMX_Desconto_Classe_2_AIV__c, BRMX_Desconto_Classe_3_AIV__c, NG_Categoria_resultante__c, NEOG_Descuento__c, NG_Pontos_volume_superior__c, NEOG_Descuento_AIV__c, NG_Pontos_volume_superior_AIV__c, NEOG_Desconto_Obj_Gen_Dem__c, BRMX_Desconto_Classe_2_MKT__c, BRMX_Desconto_Classe_3_MKT__c, BRMX_Desconto_Obj_Rel_Gen_Dem_MKT__c, DS_Categoria_MKT__c, NEOG_Descuento_MKT__c, NG_Pontos_volume_superior_MKT__c From CRM_Bonificacion__c Where CRM_Multiplicador__r.Cuenta__c = : this.opp.AccountId And CRM_Multiplicador__r.Safra__c = : this.opp.Safra__c And RecordType.Name = : this.Opp.Marca__c And Descuento_aprobado__c = true limit 1];
       if (bonif.size() > 0){
           if (this.Opp.Marca__c == 'BRMX'){               
               //if (bonif[0].BRMX_Descuento__c != null && bonif[0].BRMX_Descuento__c != 0)
               //    descuento = bonif[0].BRMX_Descuento__c;
               if (tipoAnexo.RecordTypeId == '01240000000M7y6'){               
                   if (bonif[0].BRMX_Desconto_Classe_1__c != null && bonif[0].BRMX_Desconto_Classe_1__c != 0)
                       descuentoBR1 = bonif[0].BRMX_Desconto_Classe_1__c;
                   if (bonif[0].BRMX_Desconto_Classe_2__c != null && bonif[0].BRMX_Desconto_Classe_2__c != 0)
                       descuentoBR2 = bonif[0].BRMX_Desconto_Classe_2__c;
                   if (bonif[0].BRMX_Desconto_Classe_2_MKT__c != null && bonif[0].BRMX_Desconto_Classe_2_MKT__c != 0)
                       descuentoBR2 = bonif[0].BRMX_Desconto_Classe_2_MKT__c;    
                   if (bonif[0].BRMX_Desconto_Classe_3__c != null && bonif[0].BRMX_Desconto_Classe_3__c != 0){
                       //descuentoBR3 = bonif[0].BRMX_Desconto_Classe_3__c.divide(1, 2, System.RoundingMode.HALF_DOWN);        
                       descuentoBR3 = bonif[0].BRMX_Desconto_Classe_3__c;        
                       if ((acc.Region_Comercial__c == 'REGION 1' || acc.Region_Comercial__c == 'REGION 2') && bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c  > 12.5){
                           descuentoBR3 = (descuentoBR3 - bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c + 12.5).divide(1, 2, System.RoundingMode.HALF_DOWN);
                           descuentoBR3_superior = (bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c - 12.5).divide(1, 2, System.RoundingMode.HALF_DOWN);
                       }
                       if (acc.Region_Comercial__c == 'CERRADO' && bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c  > 11.76){
                           descuentoBR3 = (descuentoBR3 - bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c + 11.76).divide(1, 2, System.RoundingMode.HALF_DOWN);
                           descuentoBR3_superior = (bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c - 11.76).divide(1, 2, System.RoundingMode.HALF_DOWN);
                       }
                       descuentoBR3 = Decimal.valueOf(descuentoBR3).divide(1, 2, System.RoundingMode.HALF_DOWN);
                       //if (bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c  > 2){
                       //    descuentoBR3 = descuentoBR3 - bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c + 2;
                       //    descuentoBR3_superior = bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c - 2;
                       //}    
                   }
                   if (bonif[0].BRMX_Desconto_Classe_3_MKT__c != null && bonif[0].BRMX_Desconto_Classe_3_MKT__c != 0){
                       descuentoBR3 = bonif[0].BRMX_Desconto_Classe_3_MKT__c;        
                       if ((acc.Region_Comercial__c == 'REGION 1' || acc.Region_Comercial__c == 'REGION 2') && bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem_MKT__c  > 12.5){
                           descuentoBR3 = (descuentoBR3 - bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem_MKT__c + 12.5).divide(1, 2, System.RoundingMode.HALF_DOWN);
                           descuentoBR3_superior = (bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem_MKT__c - 12.5).divide(1, 2, System.RoundingMode.HALF_DOWN);
                       }
                       if (acc.Region_Comercial__c == 'CERRADO' && bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem_MKT__c  > 11.76){
                           descuentoBR3 = (descuentoBR3 - bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem_MKT__c + 11.76).divide(1, 2, System.RoundingMode.HALF_DOWN);
                           descuentoBR3_superior = (bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem_MKT__c - 11.76).divide(1, 2, System.RoundingMode.HALF_DOWN);
                       }                       
                   }
               }
               
               if (tipoAnexo.RecordTypeId == '01240000000M7y8'){               
                   if (bonif[0].BRMX_Desconto_Classe_1_AIV__c != null && bonif[0].BRMX_Desconto_Classe_1_AIV__c != 0)
                       //descuentoBR1 = bonif[0].BRMX_Desconto_Classe_1__c;
                       descuentoBR1 = bonif[0].BRMX_Desconto_Classe_1_AIV__c;
                   if (bonif[0].BRMX_Desconto_Classe_2_AIV__c != null && bonif[0].BRMX_Desconto_Classe_2_AIV__c != 0)
                       //descuentoBR2 = bonif[0].BRMX_Desconto_Classe_2__c;
                       descuentoBR2 = bonif[0].BRMX_Desconto_Classe_2_AIV__c;
                   if (bonif[0].BRMX_Desconto_Classe_3_AIV__c != null && bonif[0].BRMX_Desconto_Classe_3_AIV__c != 0){
                       //descuentoBR3 = bonif[0].BRMX_Desconto_Classe_3__c;        
                       //descuentoBR3 = bonif[0].BRMX_Desconto_Classe_3_AIV__c.divide(1, 2, System.RoundingMode.HALF_DOWN);        
                       descuentoBR3 = bonif[0].BRMX_Desconto_Classe_3_AIV__c;        
                       if ((acc.Region_Comercial__c == 'REGION 1' || acc.Region_Comercial__c == 'REGION 2') && bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c  > 12.5){
                           descuentoBR3 = (descuentoBR3 - bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c + 12.5).divide(1, 2, System.RoundingMode.HALF_DOWN);
                           descuentoBR3_superior = (bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c - 12.5).divide(1, 2, System.RoundingMode.HALF_DOWN);
                       }
                       if (acc.Region_Comercial__c == 'CERRADO' && bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c  > 11.76){
                           descuentoBR3 = (descuentoBR3 - bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c + 11.76).divide(1, 2, System.RoundingMode.HALF_DOWN);
                           descuentoBR3_superior = (bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c - 11.76).divide(1, 2, System.RoundingMode.HALF_DOWN);
                       }
                       //if (bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c  > 2){
                       //    descuentoBR3 = descuentoBR3 - bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c + 2;
                       //    descuentoBR3_superior = bonif[0].BRMX_Desconto_Obj_Rel_Gen_Dem__c - 2;
                       //}    
                   }
               }
               if (bonif[0].BR_Categoria_resultante__c != null)
                   categoria = bonif[0].BR_Categoria_resultante__c;    
           }         
           if (this.Opp.Marca__c == 'DSEM'){
               if (bonif[0].DS_Categoria__c != null && bonif[0].DS_Categoria__c != 0)
                   descuentoDM = bonif[0].DS_Categoria__c;
               if (bonif[0].DS_Categoria_MKT__c != null && bonif[0].DS_Categoria_MKT__c != 0)
                   descuentoDM = bonif[0].DS_Categoria_MKT__c;    
               if (bonif[0].DS_Categoria_resultante__c != null)
                   categoria = bonif[0].DS_Categoria_resultante__c;    
           }
           if (this.Opp.Marca__c == 'NEOG'){               
               if (tipoAnexo.RecordTypeId == '01240000000M7y6'){               
                   if (bonif[0].NEOG_Descuento__c != null && bonif[0].NEOG_Descuento__c != 0)
                       descuentoNG = bonif[0].NEOG_Descuento__c;
                   if (bonif[0].NG_Pontos_volume_superior__c != null && bonif[0].NG_Pontos_volume_superior__c != 0)
                       descuentoNG_superior = bonif[0].NG_Pontos_volume_superior__c;                                            
                   if (bonif[0].NEOG_Descuento_MKT__c != null && bonif[0].NEOG_Descuento_MKT__c != 0)
                       descuentoNG = bonif[0].NEOG_Descuento_MKT__c;
                   if (bonif[0].NG_Pontos_volume_superior_MKT__c != null && bonif[0].NG_Pontos_volume_superior_MKT__c != 0)
                       descuentoNG_superior = bonif[0].NG_Pontos_volume_superior_MKT__c;                         
               }
               
               if (tipoAnexo.RecordTypeId == '01240000000M7y8'){               
                   if (bonif[0].NEOG_Descuento_AIV__c != null && bonif[0].NEOG_Descuento_AIV__c != 0)
                       descuentoNG = bonif[0].NEOG_Descuento_AIV__c;
                   if (bonif[0].NG_Pontos_volume_superior_AIV__c != null && bonif[0].NG_Pontos_volume_superior_AIV__c != 0)
                       descuentoNG_superior = bonif[0].NG_Pontos_volume_superior_AIV__c;
               }
               if (bonif[0].NG_Categoria_resultante__c != null)
                   categoria = bonif[0].NG_Categoria_resultante__c;    
               if (bonif[0].NEOG_Desconto_Obj_Gen_Dem__c != null && bonif[0].NEOG_Desconto_Obj_Gen_Dem__c != 0)
                   descuentoNG_adic_novas_tec = bonif[0].NEOG_Desconto_Obj_Gen_Dem__c;                             
           }
       }else{
           Mensaje = 'El gerente debe aprobar CRM Bonificacion.';
           return;       
       }
              
       Savepoint sp;
       try{
            sp = Database.setSavepoint();
            for(Opor o : listaOpp){
                if(o.Quantidade > 0 && !olis.contains(o.opli.Id)){
                    OppFact opFact = New OppFact();
                    List <OpportunityLineItem> armaLineItem = New List<OpportunityLineItem>();
                    opFact.oport = o.oport;
                    opFact.oplis = armaLineItem;
                    opFact.generaNC = false;
                    for(Opor oo : listaOpp){
                        if(oo.oport.Id == o.oport.Id && oo.Quantidade > 0 && !olis.contains(oo.opli.Id)){
                            olis.add(oo.opli.Id);
                            oo.opli.Quantidade__c = oo.Quantidade;  //Lo guardo en Quantidade__c para en el update no pise Quantity.
                            oo.opli.Previsao__c = oo.Quant_disp;    //Acá guardo cuanto podía facturar.
                            opFact.oplis.add(oo.opli);
                        }
                    }
                    oppsFact.add(opFact);
                }else{
                    if(o.Quantidade < 0 && !olis.contains(o.opli.Id)){
                        OppFact opFact = New OppFact();
                        List <OpportunityLineItem> armaLineItem = New List<OpportunityLineItem>();
                        opFact.oport = o.oport;
                        opFact.oplis = armaLineItem;
                        opFact.generaNC = true;
                        for(Opor oo : listaOpp){
                            if(oo.oport.Id == o.oport.Id && oo.Quantidade < 0 && !olis.contains(oo.opli.Id)){
                                olis.add(oo.opli.Id);
                                oo.opli.Quantidade__c = oo.Quantidade;  //Lo guardo en Quantidade__c para en el update no pise Quantity.
                                oo.opli.Previsao__c = oo.Quant_disp;    //Acá guardo cuanto podía facturar.
                                opFact.oplis.add(oo.opli);
                            }
                        }
                        oppsFact.add(opFact);
                    }
                }
            }
            
            for(OppFact ooo: oppsFact){
                 tipo = 'ZO08 - BR Regalías s/NF';inverno=false; recT = rt[1].Id; mult = 1; condP = 'ZC02 - A vista - 15 de Dezembro';
                 //if(ooo.oport.Owner.Profile.Name != 'Administrativo_licencias' && centLog.get(String.ValueOf(opp.Origen__c)).Name.contains('Passo Fundo')) tipo = 'ZBSF - Venda Serviços';

                 if(ooo.oport.Owner.Profile.Name == 'Administrativo_licencias'){ inverno=true; sumaTasas = 3.65;}
                 if(ooo.generaNC){ tipo = 'ZC01 - Solicit. Nota de Cred.'; recT = rt[0].Id; mult = -1; motivoP = 'Z3 - BR - Devoluções';}
                 condP = 'ZC68 - A vista Faturamento Royalties';    
                 if(tipoAnexo.RecordTypeId == '01240000000M7y6AAC')
                     vAnexo = vencimAnexoIII;
                 if(tipoAnexo.RecordTypeId == '01240000000M7y8AAC'){
                     vAnexo = vencimAnexoIV;
                 }
                 //Opportunity Pedido = New Opportunity(Name='Pedido ' + ooo.oport.name, AccountId= ooo.oport.AccountId, StageName='PE - Pendiente', Tipo__c = tipo,Condicion_de_Pago__c=condP, Fecha_fijacion_T_de_cambio__c=Fact_Param.Fecha_fijacion_T_de_cambio__c, CloseDate=system.today(), RecordTypeId= recT, VB_Cot_Soja__c=TipoCambio,Safra__c=ooo.oport.safra__c,Tipo_de_cambio__c=cotiz,Sucursal__c=opp.Sucursal__c, Tipo_de_Cota_o__c=TipoCot, Relatorio_Relacionado__c=ooo.oport.Id, Marca__c = ooo.oport.Marca__c,VB_Chegou_na_Brasmax__c = factAditivo, Invierno__c=inverno, Origen__c = centroOrigen2.Id, Motivo_de_Pedido__c = motivoP, Vencimiento_Anexo__c = vAnexo);
                 Opportunity Pedido = New Opportunity(Name='Pedido ' + ooo.oport.name, AccountId= ooo.oport.AccountId, StageName='PE - Pendiente', Tipo__c = tipo,Condicion_de_Pago__c=condP, Fecha_fijacion_T_de_cambio__c=Fact_Param.Fecha_fijacion_T_de_cambio__c, CloseDate=system.today(), RecordTypeId= recT, Safra__c=ooo.oport.safra__c,Sucursal__c=opp.Sucursal__c, Relatorio_Relacionado__c=ooo.oport.Id, Marca__c = ooo.oport.Marca__c,VB_Chegou_na_Brasmax__c = factAditivo, Invierno__c=inverno, Origen__c = centroOrigen2.Id, Motivo_de_Pedido__c = motivoP, Vencimiento_Anexo__c = vAnexo);
                 if (categoria != null && categoria != '')
                    Pedido.Categoria_Cliente__c = categoria;
                 Insert Pedido;
                 
                 vAnexo = null;
                 
                 Opportunity Pedido_Aux = [Select Id, Name, Nro_Autom_NV__c From Opportunity Where Id = : Pedido.Id];
                 Pedido_Aux.Name = Pedido_Aux.Nro_Autom_NV__c;
                 update Pedido_Aux;
                 pedidosCreados += Pedido_Aux.Name + '\r\n';
                                 
                 url = String.ValueOf(Pedido_Aux.Id);

                 items = ooo.oplis;   
    
                 if (items != null){
                    for (OpportunityLineItem i:items){
                       if(i.Quantidade__c == i.Previsao__c) i.Estado_Facturacion__c='Pasado Pedido';
                       ListaItemsParaActualizarEstado.add(i); 
                       //COMENTADO 05/10/2016. LISTA DE PRECIOS POR REGION. OpportunityLineItem it = New OpportunityLineItem (OpportunityId=Pedido.Id, PriceBookEntryId = mapPrecios.get(String.ValueOf(i.PricebookEntry.PriceBook2Id) + String.ValueOf(i.PricebookEntry.Product2.Variedade__c) + String.ValueOf(i.Categoria__c)).Id, UnitPrice=mapPrecios.get(String.ValueOf(i.PricebookEntry.PriceBook2Id) + String.ValueOf(i.PricebookEntry.Product2.Variedade__c) + String.ValueOf(i.Categoria__c)).UnitPrice, Id_Item_de_Oportunidad_Relacionado__c=i.Id, TotalPrice = null, Categoria__c = i.Categoria__c, Tasas__c = sumaTasas, Produto_Rebaixado__c = i.PriceBookEntryId);
                       //OpportunityLineItem it = New OpportunityLineItem (OpportunityId=Pedido.Id, PriceBookEntryId = mapPrecios.get(String.ValueOf(mapLPNombres.get(i.PricebookEntry.PriceBook2Id)) + ' - ' + ooo.oport.Region__c + String.ValueOf(i.PricebookEntry.Product2.Variedade__c) + String.ValueOf(i.Categoria__c)).Id, UnitPrice=mapPrecios.get(String.ValueOf(mapLPNombres.get(i.PricebookEntry.PriceBook2Id)) + ' - ' + ooo.oport.Region__c + String.ValueOf(i.PricebookEntry.Product2.Variedade__c) + String.ValueOf(i.Categoria__c)).UnitPrice, Id_Item_de_Oportunidad_Relacionado__c=i.Id, TotalPrice = null, Categoria__c = i.Categoria__c, Tasas__c = sumaTasas, Produto_Rebaixado__c = i.PriceBookEntryId);
                       OpportunityLineItem it = New OpportunityLineItem (OpportunityId=Pedido.Id, PriceBookEntryId = mapPrecios.get(String.ValueOf(mapLPNombres.get(i.PricebookEntry.PriceBook2Id)) + ' - ' + ooo.oport.Region__c + String.ValueOf(i.PricebookEntry.Product2.Variedade__c) + String.ValueOf(i.Categoria__c)).Id, UnitPrice=i.UnitPrice, Id_Item_de_Oportunidad_Relacionado__c=i.Id, TotalPrice = null, Categoria__c = i.Categoria__c, Tasas__c = sumaTasas, Produto_Rebaixado__c = i.PriceBookEntryId, Tipo_de_Cotizacion__c = i.Tipo_de_Cotizacion__c, Cot_Soja__c = i.Cot_Soja__c);
                       it.Quantity = i.Quantidade__c * mult;
                       if (i.PricebookEntry.Product2.Variedade__r.Tecnologia__c == 'IPRO' || i.PricebookEntry.Product2.Variedade__r.Tecnologia__c == 'E' || i.PricebookEntry.Product2.Variedade__r.Tecnologia__c == 'CE' || i.PricebookEntry.Product2.Variedade__r.Tecnologia__c == 'I2X'){
                           if (this.Opp.Marca__c == 'BRMX'){
                               if (i.PriceBookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c == '0')
                                   //it.Descuento__c = 0;
                                   it.Descuento_porc__c = 0;
                               if (i.PriceBookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c == '1')
                                   //it.Descuento__c = descuentoBR1;
                                   it.Descuento_porc__c = descuentoBR1;
                               if (i.PriceBookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c == '2')
                                   //it.Descuento__c = descuentoBR2;
                                   it.Descuento_porc__c = descuentoBR2;
                               if (i.PriceBookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c == '3'){
                                   //it.Descuento__c = descuentoBR3;                                 
                                   it.Descuento_porc__c = descuentoBR3;
                                   if (descuentoBR3_superior != 0)
                                       //it.Descuento_Adicional__c = descuentoBR3_superior;
                                       it.Descuento_Adicional_Porc__c = descuentoBR3_superior;
                               }    
                           }
                           if (this.Opp.Marca__c == 'DSEM')
                               it.Descuento_porc__c = descuentoDM;  
                               
                           if (this.Opp.Marca__c == 'NEOG'){
                               it.Descuento__c = descuentoNG;
                               if (descuentoNG_superior != 0)
                                   it.Descuento_Adicional__c = descuentoNG_superior;                                   
                           }                                                
                       }
                       if (i.PricebookEntry.Product2.Variedade__r.Tecnologia__c == 'E' || i.PricebookEntry.Product2.Variedade__r.Tecnologia__c == 'CE' || i.PricebookEntry.Product2.Variedade__r.Tecnologia__c == 'I2X'){
                           if (this.Opp.Marca__c == 'BRMX'){
                               if (acc.Region_Comercial__c == 'REGION 1' || acc.Region_Comercial__c == 'REGION 2')
                                   it.Descuento_porc__c = 31.25; 
                               if (acc.Region_Comercial__c == 'CERRADO')
                                   it.Descuento_porc__c = 29.40;
                               if (descuentoBR3_superior != 0)
                                   it.Descuento_Adicional_Porc__c = descuentoBR3_superior;
                           }
                           if (this.Opp.Marca__c == 'DSEM' && acc.Region_Comercial__c == 'CERRADO')
                               it.Descuento_porc__c = 25;  
                               
                           if (this.Opp.Marca__c == 'NEOG'){
                               it.Descuento__c = 3 + descuentoNG_adic_novas_tec;
                               //if (descuentoNG_superior != 0)
                               //    it.Descuento_Adicional__c = descuentoNG_superior;                                   
                           }
                       }
                       //if(itemCont.Contrato_de_Multiplicacion__c != null) {it.Precio_Contrato__c =  mapItAd.get(String.ValueOf(i.PriceBookEntry.Product2.Variedade__c)+String.ValueOf(i.Categoria__c)).Precio__c;}
                       //else{if(precCont.ContainsKey(String.ValueOf(i.PriceBookEntry.Product2.Variedade__c))) it.Precio_Contrato__c =  precCont.get(String.ValueOF(i.PriceBookEntry.Product2.Variedade__c));}
                       if(precCont.ContainsKey(String.ValueOf(i.PriceBookEntry.Product2.Variedade__c))) it.Precio_Contrato__c =  precCont.get(String.ValueOF(i.PriceBookEntry.Product2.Variedade__c));
                       if(it.Precio_Contrato__c != null && it.Precio_Contrato__c != 0) it.UnitPrice = it.Precio_Contrato__c;
                       itemsFactura.add (it);
                    }
                    insert itemsFactura;   
                    itemsFactura.clear();   
                 }
            }

          update ListaItemsParaActualizarEstado;
          if(opp.Filtro_Contrato_Mult__c != null){
                aditivo.Aditivo_Facturado__c = true;
                update aditivo;
          }
          
          Mensaje = 'Processo Concluído. \r\n Foram gerados os seguintes pedidos:' + pedidosCreados;
          listaOpp.clear();
          
          opp.AccountId=null;
          cuenta.Estado__c=null;
          pro.variedade__c=null;
          pro.Variedad__c=null;
          Fact_Param.Fecha_fijacion_T_de_cambio__c = null;
          Fact_Param.Tipo_de_cambio__c=null;
          Fact_Param.Sucursal__c=null;
          opp.Filtro_Contrato_Mult__c = null;
          itemAdi.clear();
          mapItAd.clear();
          mapItContRel.clear();
          listaOpp.clear();    
          //url = ''; TipoCot = ''; TipoCambio = '';  
          TipoCot = ''; TipoCambio = '';
          Fact_Param = new Opportunity();
          varCatCant.clear();
          precCont.clear();
          mapCantItAd.Clear();
          tipoAnexo.RecordTypeId = null;
          
          
       }catch(exception e){
        Mensaje = e.getMessage() + '-' + String.ValueOf(e.getLineNumber()) + '/n' + e.getStackTraceString();
        Database.rollback(sp);
        listaOpp.clear();opp.AccountId=null;cuenta.Estado__c=null;pro.variedade__c=null;pro.Variedad__c=null;
        Fact_Param.Fecha_fijacion_T_de_cambio__c = null;Fact_Param.Tipo_de_cambio__c=null;Fact_Param.Sucursal__c=null;opp.Filtro_Contrato_Mult__c = null;itemAdi.clear();mapItAd.clear();listaOpp.clear();
        url = ''; TipoCot = ''; TipoCambio = '';varCatCant.clear();precCont.clear(); tipoAnexo.RecordTypeId = null;mapCantItAd.clear();
       }
    }
            
    public String getMensaje() {
       return Mensaje;      
    }

    public void setMensaje(String arg) {
       Mensaje=arg;      
    }
    
    public void SelectAll(){

       for (Opor o:listaOpp){        
          o.selected=true;
          o.Quantidade = o.Quant_Disp;
       }             

    }

    public void quitarSeleccion(){

       for (Opor o:listaOpp){        
          o.selected=false;
          o.Quantidade = 0;
       }             

    }

   
}
public class AnticiposController  {

    Public OpportunityLineItem Item;
    Public Opportunity opp = new Opportunity();
    Public map<String,PricebookEntry> mapPrecios = New map<String,PricebookEntry>();
    Public List<Anticipo> listaAnticipos = new List<Anticipo>();    
    Public String Mensaje;    
    Public Date vencimAnticipo = null;        
        
    public AnticiposController(){
        opp.safra__c = '20/21';
        opp.Marca__c = 'BRMX';
        opp.Region__c = 'REGION 1';
        opp.RecordTypeId = '01240000000M58N';        
        if(Item == null)
            Item = new OpportunityLineItem();
        for (Configuracion_BMX__c conf : [Select Vencimiento_Anticipo__c From Configuracion_BMX__c limit 1]){                
                if (conf.Vencimiento_Anticipo__c != null) vencimAnticipo = conf.Vencimiento_Anticipo__c;
        }
        for(PricebookEntry pbi: [SELECT Id, Pricebook2Id, Pricebook2.Name, Product2.Categ__c, Product2.Variedade__c, UnitPrice FROM PricebookEntry WHERE isActive = true And Pricebook2.Name IN ('Lista Canal Multiplicadores', 'Lista Canal Multiplicadores - REGION 1', 'Lista Canal Multiplicadores - REGION 2', 'Lista Canal Multiplicadores - CERRADO', 'Lista de precios de Licencias', 'Lista DSEM', 'Lista DSEM - REGION 1', 'Lista DSEM - REGION 2', 'Lista DSEM - CERRADO', 'Lista NEOG', 'Lista NEOG - REGION 1', 'Lista NEOG - REGION 2', 'Lista NEOG - CERRADO')]){
            if(!mapPrecios.ContainsKey(String.ValueOf(pbi.Pricebook2.Name) + String.ValueOf(pbi.Product2Id))) mapPrecios.put(String.ValueOf(pbi.Pricebook2.Name) + String.ValueOf(pbi.Product2Id), pbi);            
        }            
    }
 
    public class Anticipo{
        public String idCuenta {get;set;}
        public String cuenta {get;set;}
        
        public Opportunity cab {get;set;}
        public List<OpportunityLineItem> items {get;set;}        
        
        public Double quantidade {get;set;}
        public Double quantidadeAnticipo {get;set;}
        public String porcAnticipo {get;set;}
        public Double valorTotal {get;set;}
        public Boolean selected {get;set;}        
    }                                
    
    Public OpportunityLineItem getItem() {
        return Item;
    }
    
    Public void setItem(OpportunityLineItem i) {
        Item=i;
    }

    Public Opportunity getOpp() {
        return opp;
    }    
    Public void setOpp(Opportunity i) {
        opp=i;
    }        
    
    Public List<Anticipo> getlistaAnticipos() {
        return listaAnticipos;
    }
    
    Public void setlistaAnticipos(List<Anticipo> arg) {
        listaAnticipos=arg;
    }
                    
    Public Void Buscar () {        
        Mensaje='';
        if (listaAnticipos!= null)
              listaAnticipos.clear();
                      
        if (opp.Safra__c == null){ Mensaje = 'Deve Selecionar uma Safra'; return;}
        
        if (opp.Marca__c == null || opp.Marca__c == ''){ Mensaje = 'Deve Selecionar uma Marca'; return;}
        
        if (opp.Region__c == null || opp.Region__c == ''){ Mensaje = 'Deve Selecionar uma Região'; return;}                                
                
        List<AggregateResult> resultItems;
        
        Map<String,String> mapCuentas = New Map<String,String>();
        Map<String,Double> mapTotXCuenta = New Map<String,Double>();
        Map<String,Double> mapTot2XCuenta = New Map<String,Double>();
        Map<String,Double> mapValorTotXCuenta = New Map<String,Double>();
        Map<String,List<OpportunityLineItem>> mapItmXCuenta = New Map<String,List<OpportunityLineItem>>();
                        
        Integer cont = 0;
        
        String qry;

        Map<String,Cotizacion_Soja__c> mapCotizaciones = New Map<String,Cotizacion_Soja__c>();
        //String safraAnterior = String.valueOf(Integer.valueOf(opp.Safra__c.substring(0,2)) - 1) + '/' + String.valueOf(Integer.valueOf(opp.Safra__c.substring(3,5)) - 1);   
        for (Cotizacion_Soja__c cot : [Select Id, Cotacao_de_soja__c, Valor__c From Cotizacion_Soja__c Where Safra__c = :opp.Safra__c])
            mapCotizaciones.put(cot.Cotacao_de_soja__c, cot);
        
        List<String> cuentasConAnticipos = New List<String>();
        for (Opportunity o : [Select Id, AccountId From Opportunity Where RecordType.Name Like 'Antecipação%' And Marca__c = :opp.Marca__c And Safra__c = :opp.Safra__c And Region__c = :opp.Region__c])
            cuentasConAnticipos.add(o.AccountId);                     
        
        qry = 'SELECT Sum(Volumen_Aut_Comercializacion__c) volume, Variedad__r.Name vari, Cultivar__c cultivar, Cultivar__r.Variedade__r.Nombre_de_Registro__c cultivar_nr, Cultivar__r.Categ__c categoria,';
        qry += ' Contrato_de_Multiplicacion__r.Multiplicador__c idCuenta,';
        qry += ' Contrato_de_Multiplicacion__r.Multiplicador__r.Name cuenta, Max(Precio__c) precio, Praca__c praca FROM Item_del_Contrato__c';
        qry += ' WHERE Contrato_de_Multiplicacion__r.RecordType.DeveloperName In (\'Termo_Aditivo\', \'Termo_Aditivo_Lan_amentos\') AND Contrato_de_Multiplicacion__r.Estado__c= \'Chegou\'';
        qry += ' AND RecordType.Name = \'Volumen\' And Contrato_de_Multiplicacion__r.Multiplicador__c Not In :cuentasConAnticipos';
                                               
        if (this.opp.Safra__c != null) qry += ' AND Contrato_de_Multiplicacion__r.Safra__c = \''+this.opp.Safra__c+'\'';                        
           
        if (this.opp.Marca__c != null) qry += ' AND Contrato_de_Multiplicacion__r.Sociedad__c = \''+this.opp.Marca__c+'\'';
        
        if (this.opp.Region__c != null) qry += ' AND Contrato_de_Multiplicacion__r.Region_Comercial__c = \''+this.opp.Region__c +'\'';
                                
        qry += ' Group By Contrato_de_Multiplicacion__r.Multiplicador__c, Contrato_de_Multiplicacion__r.Multiplicador__r.Name, Variedad__r.Name, Cultivar__c, Cultivar__r.Variedade__r.Nombre_de_Registro__c, Cultivar__r.Categ__c, Praca__c';
        qry += ' Order By Contrato_de_Multiplicacion__r.Multiplicador__r.Name';
        //qry += ' Limit 1000'; 
                                                             
        resultItems = Database.query(qry);

        if (resultItems != null){           
           for (AggregateResult i: resultItems){
               if (Double.valueOf(i.get('volume')) > 0){
                   OpportunityLineItem item = New OpportunityLineItem();
                   //item.MATNR__c = String.valueOf(i.get('vari'));
                   item.MATNR__c = String.valueOf(i.get('cultivar_nr'));
                   item.AUFNR__c = String.valueOf(i.get('praca'));
                   item.Quantity = Double.valueOf(i.get('volume'));
                   item.WERKS__c = '30%';
                   item.Quantidade__c = item.Quantity * 30 / 100;
                   item.UnitPrice = Double.valueOf(i.get('precio'));
                   item.ZZPOSSF__c = String.valueOf(i.get('cultivar'));
                   item.Categoria__c = String.valueOf(i.get('categoria'));
                   Double cotiz = 0;
                   if (mapCotizaciones.get(item.AUFNR__c) != null)
                       cotiz = mapCotizaciones.get(item.AUFNR__c).Valor__c;  
                   item.Tipo_de_Cambio__c = cotiz;
                   item.TotalPrice = item.UnitPrice * item.Tipo_de_Cambio__c * item.Quantidade__c;
                   List<OpportunityLineItem> items;
                   if (!mapItmXCuenta.containsKey(String.valueOf(i.get('idCuenta')))){
                       items = New List<OpportunityLineItem>();
                   }else{
                       items = mapItmXCuenta.get(String.valueOf(i.get('idCuenta')));
                   }
                   items.add(item);
                   mapItmXCuenta.put(String.valueOf(i.get('idCuenta')), items);    
                              
                   mapCuentas.put(String.valueOf(i.get('idCuenta')), String.valueOf(i.get('cuenta')));
                   if (!mapTotXCuenta.containsKey(String.valueOf(i.get('idCuenta')))){
                       mapTotXCuenta.put(String.valueOf(i.get('idCuenta')), Double.valueOf(i.get('volume')));
                   }else{
                       Double cant = mapTotXCuenta.get(String.valueOf(i.get('idCuenta')));
                       cant += Double.valueOf(i.get('volume'));
                       mapTotXCuenta.put(String.valueOf(i.get('idCuenta')), cant);
                   }
                   if (!mapTot2XCuenta.containsKey(String.valueOf(i.get('idCuenta')))){
                       mapTot2XCuenta.put(String.valueOf(i.get('idCuenta')), item.Quantidade__c);
                   }else{
                       Double cant = mapTot2XCuenta.get(String.valueOf(i.get('idCuenta')));
                       cant += item.Quantidade__c;
                       mapTot2XCuenta.put(String.valueOf(i.get('idCuenta')), cant);
                   }                   
                   if (!mapValorTotXCuenta.containsKey(String.valueOf(i.get('idCuenta')))){
                       mapValorTotXCuenta.put(String.valueOf(i.get('idCuenta')), item.TotalPrice);
                   }else{
                       Double valor = mapValorTotXCuenta.get(String.valueOf(i.get('idCuenta')));
                       valor += item.TotalPrice;
                       mapValorTotXCuenta.put(String.valueOf(i.get('idCuenta')), valor);
                   }
               }   
           }    
           for (String s: mapCuentas.keySet()){
               Anticipo an = New Anticipo();
               an.cab = New Opportunity();
               an.cab.AccountId = s;
               an.cab.Despachante__c = mapCuentas.get(s);
               an.cab.TotalOpportunityQuantity = mapTotXCuenta.get(s);
               an.cab.Quantidade_Total__c = mapTotXCuenta.get(s);
               an.cab.CNPJ_CPF_Anexo__c = '30%';
               an.cab.Cotizacion__c = mapTot2XCuenta.get(s);
               an.cab.Amount = mapValorTotXCuenta.get(s);
               
               /*
               an.idCuenta = s;
               an.cuenta = mapCuentas.get(s);
               an.quantidade = mapTotXCuenta.get(s);
               an.porcAnticipo = '30%';
               an.quantidadeAnticipo = mapTot2XCuenta.get(s);
               an.valorTotal = mapValorTotXCuenta.get(s);
               */
               
               an.selected = false;
               an.items = mapItmXCuenta.get(s);
               listaAnticipos.add(an);
           }                                                                                   
       }                                                                                                 
    }
    
    Public void CrearPedidos () {
    
       List <OpportunityLineItem> items;
       List <RecordType> rt = [SELECT Id FROM RecordType WHERE Name = 'Antecipação Pendente' and sObjectType = 'Opportunity'];
       List <OpportunityLineItem> itemsFactura = New List <OpportunityLineItem>();
       Boolean HaySeleccion = false;
       Id recT = rt[0].Id;
       
       String pedidosCreados = '';
       
       Date vAnticipo = null;
       
       Mensaje = '';
       
       for (Anticipo an :listaAnticipos)
          if (an.selected == true){
             HaySeleccion=true;
             break;
          }
          
         if (!HaySeleccion){
             Mensaje = 'Deve selecionar pelo menos uma conta.';
             return;
         }
                     
              
       Savepoint sp;
       try{
           sp = Database.setSavepoint();   
           String lista_precios = 'Lista Canal Multiplicadores';      
           if (opp.Marca__c == 'DSEM')
               lista_precios = 'Lista DSEM';           
           if (opp.Marca__c == 'NEOG')
               lista_precios = 'Lista NEOG';               
           for(Anticipo o: listaAnticipos){
               vAnticipo = vencimAnticipo;
               if (o.selected == true){
                   Opportunity Pedido = New Opportunity(Name='Anticipo ' + o.cab.Despachante__c, AccountId= o.cab.AccountId, StageName='PE - Pendiente', CloseDate=system.today(), RecordTypeId= recT, Safra__c=opp.Safra__c, Marca__c=opp.Marca__c, Region__c=opp.Region__c, Vencimiento_Anexo__c = vAnticipo);
                   Insert Pedido;
               
                   Opportunity Pedido_Aux = [Select Id, Name, Nro_Autom_NV__c From Opportunity Where Id = : Pedido.Id];
                   Pedido_Aux.Name = Pedido_Aux.Nro_Autom_NV__c;
                   update Pedido_Aux;
                   //pedidosCreados += Pedido_Aux.Name + '\r\n';                                             

                   items = o.items;   
  
                   if (items != null){
                       for (OpportunityLineItem i:items){                      
                           OpportunityLineItem it = New OpportunityLineItem (OpportunityId=Pedido.Id, PriceBookEntryId = mapPrecios.get(lista_precios + String.ValueOf(i.ZZPOSSF__c)).Id, Categoria__c=i.Categoria__c, Cot_Soja__c=i.AUFNR__c, UnitPrice=i.UnitPrice, Tipo_de_Cambio__c=i.Tipo_de_Cambio__c, TotalPrice = null);
                           it.Volumen_Aut_Comercializacion__c = i.Quantity; 
                           it.Volume_porc__c = 30;
                           it.Quantity = i.Quantidade__c;                                            
                           itemsFactura.add (it);
                        }                  
                    }
                }
            }
            insert itemsFactura;   
            itemsFactura.clear();              
        
            //Mensaje = 'Processo Concluído. \r\n Foram gerados os seguintes anticipos:' + pedidosCreados;
            Mensaje = 'Processo Concluído.';
            listaAnticipos.clear();
        
       }catch(exception e){
           Mensaje = e.getMessage() + '-' + String.ValueOf(e.getLineNumber()) + '/n' + e.getStackTraceString();
           Database.rollback(sp);
           listaAnticipos.clear();            
       }
    }
            
    Public void getVerDetalles () {

    }
    
    Public Boolean getVerDetallesDisabled(){    
       if (listaAnticipos.size() == 0) return true;       
       return false;    
    }
                
    Public String getMensaje() {
       return Mensaje;      
    }

    Public void setMensaje(String arg) {
       Mensaje=arg;      
    }
    
    
    Public void SelectAll(){
       for (Anticipo o:listaAnticipos)        
          o.selected=true;          
    }

    Public void quitarSeleccion(){
       for (Anticipo o:listaAnticipos)        
          o.selected=false;
    }
    
}
Public with sharing class Autorizar_NV_Controller  {

    Public OpportunityLineItem Item;
    Public Opportunity opp = new Opportunity();    
    Public Account cuenta = new Account();
    Public Product2 pro = new Product2();    
    Public Contrato__c contrato = new Contrato__c();
    Public List<Opor> listaOpp = new List<Opor>();    
    Public String Mensaje;    
    Public Opportunity Fact_Param = new Opportunity();
    Public String TipoCambio = '';
    Public String TipoCot = '';
        
    Set<Id> resultIdsItemsAux = new Set<Id>();
         
    public Autorizar_NV_Controller(){
        opp.safra__c = '11/12';
        if(Item == null)
            Item = new OpportunityLineItem();    
    }
        
    public class Opor{
        public Opportunity oport {get;set;}
        public Boolean selected {get;set;}        
    }                    
    
    Public Opportunity getFact_Param(){
       return Fact_Param;
    }

    Public Void setFact_Param(Opportunity arg){
       Fact_Param = arg;
    }

    Public Contrato__c getcontrato(){    
        return contrato;      
    }
    
    Public void setcontrato(Contrato__c arg){    
        contrato = arg;      
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
    
    Public Account getcuenta() {
        return cuenta;
    }    
    Public void setcuenta(Account i) {
        cuenta=i;
    }

    Public Product2 getpro() {
        return pro;
    }    
    Public void setpro(Product2 i) {
        pro=i;
    }
    
    Public List<Opor> getlistaOpp() {
        return listaOpp;
    }
    
    Public void setlistaOpp(List<Opor> arg) {
        listaOpp=arg;
    }
                        
    Public Void Buscar () {
    
        Mensaje='';
        
        if (listaOpp != null)
              listaOpp.clear();
              
        resultIdsItemsAux.clear();  
        
        Fact_Param = New Opportunity();
                        
        //Fact_Param.Fecha_fijacion_T_de_cambio__c = null;
        //Fact_Param.Amount = null;           
           
        if (contrato.Tipo_de_Cota_o__c == null){   
           Mensaje = 'Deve Selecionar um Tipo de Cotação';
           return;        
        }
                        
        if (contrato.Tipo_de_Cota_o__c == 'SOJA' && contrato.Cotacao_de_soja__c == null){
           Mensaje = 'Deve Selecionar Cotação de soja';
           return;
        }
        
        /*
        if (this.cuenta.Macrorregion_de_Vendas__c == null){   
           Mensaje = 'Deve Selecionar uma Macrorregion de Vendas';
           return;        
        } 
        */       
        
        //TipoCambio = '';
        //if (contrato.Cotacao_de_soja__c != null)
        //   TipoCambio = contrato.Cotacao_de_soja__c;        
        
        if (contrato.Tipo_de_Cota_o__c == 'DOLAR'){
           Cotizacion_Soja__c cot_soja = [SELECT Valor__c,Fecha__c FROM Cotizacion_Soja__c WHERE Cotacao_de_soja__c = 'DOLAR' And Safra__c = : opp.Safra__c limit 1];
           if (cot_soja != null){
              Fact_Param.Tipo_de_cambio__c=cot_soja.valor__c;
              Fact_Param.Fecha_fijacion_T_de_cambio__c=cot_soja.Fecha__c;
           }                 
        }         
        
        if (contrato.Cotacao_de_soja__c != null){
           Cotizacion_Soja__c cot_soja = [SELECT Valor__c,Fecha__c FROM Cotizacion_Soja__c WHERE Cotacao_de_soja__c = : contrato.Cotacao_de_soja__c And Safra__c = : opp.Safra__c];
           if (cot_soja != null){
              Fact_Param.Tipo_de_cambio__c=cot_soja.valor__c;
              Fact_Param.Fecha_fijacion_T_de_cambio__c=cot_soja.Fecha__c;
           }                 
        }      
        
        /*
        if (this.cuenta.Macrorregion_de_Vendas__c != null){
           for (Macrorregi_o_de_Vendas__c mr : [Select Id, Name From Macrorregi_o_de_Vendas__c Where Id = : this.cuenta.Macrorregion_de_Vendas__c]){
              if (mr.Name == '1')
                 Fact_Param.Sucursal__c = '0094 Passo Fundo';
              if (mr.Name == '2')
                 Fact_Param.Sucursal__c = '0095 Londrina';
              if (mr.Name == '3')
                 Fact_Param.Sucursal__c = '0095 Londrina';
              if (mr.Name == '4')
                 Fact_Param.Sucursal__c = '0095 Londrina';
           }      
        }
        */
        
        Fact_Param.Condicion_de_Pago__c = 'ZC68 - A vista - 15 de Dezembro';
                                               
        List<RecordType> rt=[SELECT Id FROM RecordType WHERE Name='Pendiente' AND SobjectType='Opportunity'];
        List<Profile> prof=[SELECT Id, Name FROM Profile WHERE Name='Administrador del sistema'];
        List<Opportunity> result;
                
        Integer cont = 0;
        
        String qry;

        qry = 'SELECT Id, Name, CloseDate, Account.Name, Account.Id, Safra__c, Tipo_de_Cambio__c, Sucursal__c, Fecha_fijacion_T_de_cambio__c, Condicion_de_Pago__c, Marca_Enviar_SAP__c';
        qry += ',(SELECT Id, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.Variedad__c, Quantity, UnitPrice, TotalPrice From OpportunityLineItems)';
        qry += ' FROM Opportunity WHERE RecordTypeId= \''+rt[0].Id+'\'';
        
        qry += ' AND Tipo_de_Cota_o__c = \''+this.contrato.Tipo_de_Cota_o__c+'\'';
        
        if (contrato.Tipo_de_Cota_o__c == 'SOJA')
           qry += ' AND VB_Cot_Soja__c = \''+this.contrato.Cotacao_de_soja__c+'\'';                                                     
        
        if (this.Opp.AccountId != null)
           qry += ' AND AccountId = \''+this.Opp.AccountId+'\'';          
                      
        if (this.Opp.Safra__c != null)
           qry += ' AND Safra__c = \''+this.Opp.Safra__c+'\'';                                       
           
        if (this.cuenta.estado__c != null)
           qry += ' AND Opportunity.Account.Estado__c = \''+this.cuenta.estado__c+'\'';   
           
        //if (this.cuenta.Microrregi_o_de_Vendas__c != null)
        //   qry += ' AND Opportunity.Account.Microrregi_o_de_Vendas__c = \''+this.cuenta.Microrregi_o_de_Vendas__c+'\'';   
           
        //if (this.cuenta.Macrorregion_de_Vendas__c != null)
        //   qry += ' AND Opportunity.Account.Macrorregion_de_Vendas__c = \''+this.cuenta.Macrorregion_de_Vendas__c+'\'';      
           
        if (this.cuenta.Responsavel__c != null)
           qry += ' AND Opportunity.Account.Responsavel__c = \''+this.cuenta.Responsavel__c+'\''; 
                      
        //if (prof[0].Id != UserInfo.getProfileId())
        //   qry += ' AND Opportunity.OwnerId = \''+UserInfo.getUserId()+'\''; 
        
        qry += ' Order By Account.Name';                                                        
                        
        qry += ' Limit 1000';
                                                             
        result = Database.query(qry);
                                    
        if (result != null){          
                        
           for (Opportunity o:result) {
              Opor op = new Opor();
              op.oport=o;
              op.selected=false; 
              listaOpp.add(op);           
              if (cont == 998 && result.size() == 1000){
                 ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Se estan visualizando 999 registros. Hay mas registros para consultar.');                 
                 ApexPages.addMessage(msg); 
                 break;  
              }
              cont += 1;   
           }
        }                                                                                                 
    }
    
    Public String getVerDetalles () {
    
       String acc;
       String camp;
       String vari;
       String url;
       String tipoCot;
       String cotSoja;
       String estado;
       String microReg;
       String macroReg;
              
       if (this.opp.safra__c != null) {
          camp = this.opp.safra__c;
          }else{
             //camp= '/';
             camp= '';
       }  
        
       if (this.pro.variedad__c != null) {
          vari = this.pro.variedad__c;
          }else{
             //vari= 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,x,y,z,0,1,2,3,4,5,6,7,8,9';
             vari='';
       }
       
       if (this.contrato.Tipo_de_Cota_o__c != null) {
          tipoCot = this.contrato.Tipo_de_Cota_o__c;
          }else{
             tipoCot='';
       }
       
       if (this.contrato.Cotacao_de_soja__c != null) {
          cotSoja = this.contrato.Cotacao_de_soja__c;
          }else{
             cotSoja='';
       } 

       if (this.cuenta.estado__c != null) {
          Estado__c e=[SELECT name FROM Estado__c WHERE Id= : this.cuenta.estado__c limit 1];
          estado = e.name;
          }else{
             estado='';
       }

       /*
       if (this.cuenta.Microrregi_o_de_Vendas__c != null) {
          Microrregi_o_de_Vendas__c micr = [SELECT name FROM Microrregi_o_de_Vendas__c WHERE Id= : this.cuenta.Microrregi_o_de_Vendas__c limit 1]; 
          microReg = micr.name;
          }else{
             microReg='';
       }

       if (this.cuenta.Macrorregion_de_Vendas__c != null) {
          Macrorregi_o_de_Vendas__c macr = [SELECT name FROM Macrorregi_o_de_Vendas__c WHERE Id= : this.cuenta.Macrorregion_de_Vendas__c limit 1]; 
          macroReg = macr.name;
          }else{
             macroReg='';
       }
       */
       
       if (this.opp.AccountId != null) {       
          acc = this.opp.AccountId; 
          url = '/00O40000002JSqI?pv1=' + acc + '&pv2=' + camp + '&pv3=' + vari + '&pv5=' + estado + '&pv6=' + microReg + '&pv7=' + macroReg + '&pv8=' + tipoCot + '&pv9=' + cotSoja; 
          }else{
             url = '/00O40000002JSqN?pv1=' + camp + '&pv2=' + vari + '&pv4=' + estado + '&pv5=' + microReg + '&pv6=' + macroReg + '&pv7=' + tipoCot + '&pv8=' + cotSoja;
       }
        
        //'00O40000002JSqN' //sin cuenta   //sandbox 00OS0000000KBRM
        //'00O40000002JSqI'  //con cuenta   //sandbox 00OS0000000KBRH
                      
       return url;              

    }
    
    Public String getFacturar () {
       if (listaOpp.size() > 0)           
          return '/apex/Facturar_Fecha_Valor';    

       return '';   
    }
    
    Public Boolean getVerDetallesDisabled(){    
       if (listaOpp.size() == 0) return true;       
       return false;    
    }
    
    Public void AutorizarNV () {
    
       List <OpportunityLineItem> items;
       List <RecordType> rt = [SELECT Id FROM RecordType WHERE Name = 'Fc de Brasmax'];
       List <OpportunityLineItem> itemsFactura = New List <OpportunityLineItem>();
       List <Opportunity> ListaOppParaActualizar = New List<Opportunity>();
       List <OpportunityLineItem> ListaItemsParaActualizar = New List<OpportunityLineItem>();
       Set <Id> IdsOpps = New Set <Id>();
       Boolean HaySeleccion = false;
       Decimal Contador_Nro_Legal;
       String retorno;
       
       Mensaje = '';
       
       if (Fact_Param.Fecha_fijacion_T_de_cambio__c == null){
          Mensaje = 'Debe Ingresar una Fecha fijacion de Tipo de Cambio';
          return;
       }
       
       if (Fact_Param.Tipo_de_cambio__c == null){
          Mensaje = 'Debe Ingresar el Tipo de Cambio';
          return;
       }
       
       if (Fact_Param.Sucursal__c == null){
          Mensaje = 'Debe Ingresar una Sucursal';
          return;
       }
       
       if (Fact_Param.Condicion_de_Pago__c == null){
          Mensaje = 'Debe Ingresar una Condicion de Pago';
          return;
       }
                            
       for (Opor opo :listaOpp)
          if (opo.selected == true){
             HaySeleccion=true;
             break;
          }
          
       if (!HaySeleccion){
          Mensaje = 'Debe Seleccionar al menos una Oportunidad';
          return;
       }    
    
       for (Opor o :listaOpp){
          if (o.Selected == true){          
             o.oport.Tipo_de_Cambio__c = Fact_Param.Tipo_de_cambio__c;
             o.oport.Sucursal__c = Fact_Param.Sucursal__c;
             o.oport.Fecha_fijacion_T_de_cambio__c=Fact_Param.Fecha_fijacion_T_de_cambio__c;
             o.oport.Condicion_de_Pago__c=Fact_Param.Condicion_de_Pago__c;
             o.oport.Marca_Enviar_SAP__c = true;
             ListaOppParaActualizar.add(o.oport);
             //for (OpportunityLineItem i : [Select Id, UnitPrice From OpportunityLineItem Where OpportunityId = : o.oport.Id]){
             //   i.UnitPrice = i.UnitPrice * o.oport.Tipo_de_Cambio__c;
             //   ListaItemsParaActualizar.add(i);
             //}                        
          }
       }   
      
       try{
          update ListaOppParaActualizar;
          //update ListaItemsParaActualizar;
          }catch(Exception e){
             String mensaje = e.getMessage();           
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error al Autorizar NV');                 
             ApexPages.addMessage(msg);
             return;     
          }                  
                                   
                                   
       AutorizarNVBatchJob j = New AutorizarNVBatchJob ();
       ID batchId = Database.executeBatch(j, 1);
       
                           
       Mensaje = 'El Proceso de Autorizacion ha comenzado. Recibira un Mail cuando haya finalizado.';
       listaOpp.clear();
       this.getFact_Param().Sucursal__c=null;
       Fact_Param.Numero_Legal__c=null;
      
    }
            
    Public String getMensaje() {
       return Mensaje;      
    }

    Public void setMensaje(String arg) {
       Mensaje=arg;      
    }
    
    Public void SelectAll(){

       for (Opor o:listaOpp){        
          o.selected=true;
       }             

    }

    Public void quitarSeleccion(){

       for (Opor o:listaOpp){        
          o.selected=false;
       }             

    }
    
    static testmethod void test() {
    
       Autorizar_NV_Controller aNV = New Autorizar_NV_Controller();
/*       
       Product2 px1 = new Product2(Name = 'Test 1', Especie__c = 'SOJA');
       insert px1;
       Pricebook2 s = [select ID from Pricebook2 where IsStandard = TRUE];
       PricebookEntry pbesx = new PricebookEntry(Pricebook2Id=s.ID,Product2Id=px1.ID, UnitPrice=0.00, IsActive=TRUE, UseStandardPrice=FALSE);
       insert pbesx;
       
       Macrorregi_o_de_Vendas__c mr = new Macrorregi_o_de_Vendas__c(Name='SUR'); // [Select Id From Macrorregi_o_de_Vendas__c limit 1];
       Account ac = New Account(Name='Prueba', Macrorregion_de_Vendas__c = mr.Id);
       insert ac;
       Opportunity o = new Opportunity(Name = 'Test 1', CloseDate = System.today(), StageName = 'Clientes potenciales', AccountId = ac.Id);
       insert o;
       OpportunityLineItem opli1 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 10, quantity = 1);
       insert opli1;
       Opportunity o1 = new Opportunity(Name = 'Test 1', CloseDate = System.today(), StageName = 'Clientes potenciales', Tipo_de_cambio__c = 2, Fecha_fijacion_T_de_cambio__c = system.today(), Sucursal__c = 'Londrina');
       insert o1;

       aNV.setFact_Param(o1);
       o1 = aNV.getFact_Param();
       aNV.setOpP(o1);
       o1 = aNV.getOpP();
       OpportunityLineItem opli2 = new OpportunityLineItem(OpportunityId = o.id, PricebookEntryId = pbesx.id, unitPrice = 10, quantity = 1);
       insert opli2;
       aNV.setItem(opli2);
       opli2 = aNV.getItem();
       Contrato__c con = New Contrato__c (Tipo_de_Cota_o__c = 'DOLAR');
       aNV.setContrato(con);
       con = aNV.getContrato();
       Account acc = New Account(Name='Prueba', Macrorregion_de_Vendas__c = mr.Id);
       insert acc;
       aNV.setcuenta(acc);
       acc = aNV.getcuenta();
       Product2 p = new Product2(Name = 'prueba', Especie__c = 'SOJA');
       insert p;
       aNV.setpro(p);
       p = aNV.getpro();
       
       Autorizar_NV_Controller.Opor opor = New Autorizar_NV_Controller.Opor();
       opor.oport = o;
       opor.selected = true;
       
       List<Opor> lopor = New List<Opor>();
       lopor.add (opor);
       aNV.setListaOPp (lopor);
       
       lopor = aNV.getListaOpp();
*/                     
       aNV.AutorizarNV();
       
       Macrorregi_o_de_Vendas__c mr = new Macrorregi_o_de_Vendas__c(Name='2');
       insert mr;
       Microrregi_o_de_Vendas__c mm = new Microrregi_o_de_Vendas__c(Name='M2');
       insert mm;
       Estado__c e = new Estado__c(Name='SP');
       insert e;
       Account ac = New Account(Name='Prueba',Responsavel__c='073 - Jacques Müllich', Estado__c=e.Id);
       insert ac;
       Opportunity param;
       Opportunity o = new Opportunity(Fecha_fijacion_T_de_cambio__c = System.Today(), Safra__c = '10/11', Name = 'Test 1', CloseDate = System.today(), StageName = 'Clientes potenciales', AccountId = ac.Id);
       insert o;
       aNV.setFact_Param(o);
       aNV.getContrato();
       aNV.setMensaje('a');
       String msj = aNV.getMensaje();
       param = aNV.getFact_Param();       
       aNV.AutorizarNV();
       param.Tipo_de_cambio__c = 1;
       aNV.AutorizarNV();
       param.Sucursal__c = 'Londrina';
       aNV.AutorizarNV();
       param.Condicion_de_Pago__c = 'ZC68 - A vista - 15 de Dezembro';
       aNV.AutorizarNV();

       Autorizar_NV_Controller.Opor opor = New Autorizar_NV_Controller.Opor();
       opor.oport = o;
       opor.selected = true;
       List<Opor> lopor = New List<Opor>();
       lopor.add (opor);
       aNV.setListaOPp (lopor);
       aNV.AutorizarNV();             
       lopor = aNV.getListaOpp();       
       aNV.AutorizarNV();
       
       
       aNV.Buscar();
       Contrato__c con = New Contrato__c (Tipo_de_Cota_o__c = 'SOJA');
       aNV.setContrato(con);
       aNV.Buscar();
       con.Tipo_de_Cota_o__c = 'DOLAR';
       aNV.setContrato(con);
       aNV.Buscar();
       
       Cotizacion_Soja__c cot_soja = new Cotizacion_Soja__c(Cotacao_de_soja__c = 'DOLAR');
       insert cot_soja;       
       aNV.setcuenta(ac);
       ac = aNV.getcuenta();
       o = aNV.getOpp();
       aNV.setOpp(o);
       
       List<RecordType> rt = [SELECT Id FROM RecordType WHERE Name='Pendiente' AND SobjectType='Opportunity'];
       Opportunity odb = new Opportunity(RecordTypeId=rt[0].Id,Fecha_fijacion_T_de_cambio__c=System.Today(),Safra__c='10/11', Name = 'Test 1', CloseDate = System.today(), StageName = 'Aberta', AccountId = ac.Id);
       odb.Tipo_de_Cota_o__c = 'DOLAR';
       insert odb;
       aNV.Buscar();

       Product2 p = new Product2(Name = 'prueba', Especie__c = 'SOJA',variedad__c='DM3810');       
       insert p;
       aNV.setpro(p);
       p = aNV.getpro();
    
       aNV.SelectAll();
       aNV.QuitarSeleccion();
       
       aNV.getVerDetalles();
  
       aNV.getFacturar();
       
       aNV.getVerDetallesDisabled();

       aNV.getItem();
       aNV.setItem(null);
                  
    }

}
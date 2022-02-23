Public class Facturar_Controller  {

    Public OpportunityLineItem Item;
    Public Opportunity opp = new Opportunity();    
    Public Account cuenta = new Account();
    Public Product2 pro = new Product2();    
    Public Contrato__c contrato = new Contrato__c();
    Public List<Opor> listaOpp = new List<Opor>();    
    Public String Mensaje;    
    Public Opportunity Fact_Param = new Opportunity();
    Public String TipoCambio = '';
        
    Set<Id> resultIdsItemsAux = new Set<Id>();
         
    public Facturar_Controller(){
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
        
        if (Opp.Safra__c == null){
           Mensaje = 'Deve Selecionar uma Safra';
           return;
        }
        
        TipoCambio = '';
        if (contrato.Cotacao_de_soja__c != null)
           TipoCambio = contrato.Cotacao_de_soja__c;                 
        
        if (contrato.Cotacao_de_soja__c != null){
           Cotizacion_Soja__c cot_soja = [SELECT Valor__c,Fecha__c FROM Cotizacion_Soja__c WHERE Cotacao_de_soja__c = : contrato.Cotacao_de_soja__c limit 1];
           if (cot_soja != null)
              Fact_Param.Tipo_de_cambio__c=cot_soja.valor__c;
              Fact_Param.Fecha_fijacion_T_de_cambio__c=cot_soja.Fecha__c;
        }      
                                               
        List<RecordType> rt=[SELECT Id FROM RecordType WHERE Name='Comercial' AND SobjectType='Opportunity'];
        List<Profile> prof=[SELECT Id, Name FROM Profile WHERE Name='Administrador del sistema'];
        List<OpportunityLineItem> resultItems;
        Set<Id> listaIdOpportunity = New Set<Id>();
        List<Opportunity> Oportunidades = New List<Opportunity>();
                
        Integer cont = 0;
        
        String qry;

        qry = 'SELECT Id, OpportunityId, Opportunity.Name, Opportunity.CloseDate, Opportunity.Account.Name, Opportunity.Account.Estado__c, Opportunity.Account.Id, Opportunity.Safra__c, PriceBookEntry.Product2.Variedad__c FROM OpportunityLineItem';
        qry += ' WHERE Opportunity.RecordTypeId= \''+rt[0].Id+'\'';
        
        qry += ' AND Contrato_relacionado__r.Tipo_de_Cota_o__c = \''+this.contrato.Tipo_de_Cota_o__c+'\'';
        
        if (contrato.Tipo_de_Cota_o__c == 'SOJA')
           qry += ' AND Contrato_relacionado__r.Cotacao_de_soja__c = \''+this.contrato.Cotacao_de_soja__c+'\'';
                               
        if (this.Opp.AccountId != null)
           qry += ' AND Opportunity.AccountId = \''+this.Opp.AccountId+'\'';          
                      
        if (this.Opp.Safra__c != null)
           qry += ' AND Opportunity.Safra__c = \''+this.Opp.Safra__c+'\'';   
                
        if (this.pro.Variedad__c != null)
           qry += ' AND PriceBookEntry.Product2.Variedad__c = \''+this.pro.Variedad__c+'\'';                      
           
        if (this.cuenta.estado__c != null)
           qry += ' AND Opportunity.Account.Estado__c = \''+this.cuenta.estado__c+'\'';   
                               
        //if (prof[0].Id != UserInfo.getProfileId())
        //   qry += ' AND Opportunity.OwnerId = \''+UserInfo.getUserId()+'\'';  
                               
        qry += ' AND Estado_Facturacion__c != \'Facturado\'';                
                        
        qry += ' Limit 1000';
                                                             
        resultItems = Database.query(qry);
                                    
        if (resultItems != null){
           for (OpportunityLineItem i: resultItems)                         
              if (!(listaIdOpportunity.contains(i.OpportunityId)))
                 listaIdOpportunity.add(i.OpportunityId);         
                
           Oportunidades = [SELECT Id, Name, CloseDate, Account.Name, Account.Id, Safra__c FROM Opportunity WHERE Id in : listaIdOpportunity];
                        
           for (Opportunity o:Oportunidades) {
              Opor op = new Opor();
              op.oport=o;
              op.selected=false; 
              listaOpp.add(op);           
              if (cont == 998 && Oportunidades.size() == 1000){
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
    
    Public void CrearFacturas () {
    
       List <OpportunityLineItem> items;
       List <RecordType> rt = [SELECT Id FROM RecordType WHERE Name = 'Fc de Brasmax'];
       List <OpportunityLineItem> itemsFactura = New List <OpportunityLineItem>();
       List <OpportunityLineItem> ListaItemsParaActualizarEstado = New List<OpportunityLineItem>();
       Boolean HaySeleccion = false;
       
       Mensaje = '';
       
       if (Fact_Param.Fecha_fijacion_T_de_cambio__c == null){
          Mensaje = 'Deves Inserir uma Data';
          return;
       }
       
       if (Fact_Param.Tipo_de_cambio__c == null){
          Mensaje = 'Deves Inserir uma Cotação';
          return;       
       }

       if (Fact_Param.Sucursal__c == null){
          Mensaje = 'Deves Inserir uma Filial';
          return;       
       }
       
       for (Opor opo :listaOpp)
          if (opo.selected == true){
             HaySeleccion=true;
             break;
          }
          
       if (!HaySeleccion){
          Mensaje = 'Deve Selecionar pelo menos um Relatorio de Venda';
          return;
       }
    
       for (Opor o :listaOpp){
          if (o.Selected == true){          
             Opportunity Factura = New Opportunity(Name='Factura ' + o.oport.name, AccountId= o.oport.AccountId, StageName='Aberta', Fecha_fijacion_T_de_cambio__c=Fact_Param.Fecha_fijacion_T_de_cambio__c, CloseDate=system.today(), RecordTypeId= rt[0].Id, Estado_Facturacion__c='PE Contabilizar',VB_Cot_Soja__c=TipoCambio,safra__c=o.oport.safra__c,Tipo_de_cambio__c=Fact_Param.Tipo_de_cambio__c,Sucursal__c=Fact_Param.Sucursal__c); 
             Insert Factura;
             
             String qry='';
             //items = [Select Id, Quantity, PricebookEntryId, PriceBookEntry.UnitPrice, Contrato_relacionado__r.Tipo_de_Cota_o__c, Contrato_relacionado__r.Cotacao_de_soja__c FROM OpportunityLineItem WHERE OpportunityId= : o.oport.id];
             qry = 'Select Id, Semente_comercializada__c, Semente_uso_propio__c, Quantity, PricebookEntryId, PriceBookEntry.UnitPrice FROM OpportunityLineItem WHERE OpportunityId=\''+o.oport.id+'\'';
             qry += ' AND Contrato_relacionado__r.Tipo_de_Cota_o__c=\''+this.contrato.Tipo_de_Cota_o__c+'\'';
             if (this.contrato.Cotacao_de_soja__c != null)
                qry += ' AND Contrato_relacionado__r.Cotacao_de_soja__c=\''+this.contrato.Cotacao_de_soja__c+'\'';
             if (this.pro.variedad__c != null)
                qry += ' AND PriceBookEntry.Product2.Variedad__c=\''+this.pro.variedad__c+'\'';

             items=DataBase.query(qry);   

             if (items != null){
                for (OpportunityLineItem i:items){
                   i.Estado_Facturacion__c='Facturado';
                   ListaItemsParaActualizarEstado.add(i); 
                   OpportunityLineItem it = New OpportunityLineItem (OpportunityId=Factura.Id, PriceBookEntryId = i.PriceBookEntryId, UnitPrice=i.PriceBookEntry.UnitPrice, Id_Item_de_Oportunidad_Relacionado__c=i.Id);
                   Double cant = 0;
                   if(i.Semente_comercializada__c != null)
                     cant = i.Semente_comercializada__c;
                   if(i.Semente_uso_propio__c != null)
                     cant += i.Semente_uso_propio__c;
                   if(cant > 0)
                    it.Quantity = cant;
                   else
                    it.Quantity = 1;
                   itemsFactura.add (it);
                }
                insert itemsFactura;   
                itemsFactura.clear();   
             }
           
         }
      }
      
      update ListaItemsParaActualizarEstado;
      
      Mensaje = 'Processo Concluído';
      listaOpp.clear();
      opp.AccountId=null;
      opp.Safra__c=null;
      contrato.Cotacao_de_soja__c=null;
      pro.variedad__c=null;
      Fact_Param.Fecha_fijacion_T_de_cambio__c = null;
      Fact_Param.Tipo_de_cambio__c=null;
      Fact_Param.Sucursal__c=null;
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

}
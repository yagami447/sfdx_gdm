Public class Facturas_Pendientes_Contab_Controller {
   /* Se comenta toda la clase porque está fuera de uso
   Public Opportunity opp = new Opportunity();
   Public List<Opor> listaOpp = new List<Opor>();
   //Public Account cuenta = new Account();
   Public String Mensaje;
   private boolean pasar = false;
   Public Opportunity Fact_Param = new Opportunity(); 
   Public String MiQuery='';
   
   public class Opor{
       public Opportunity oport {get;set;}
       public Boolean selected {get;set;}        
   } 
   
   Public Opportunity getOpp() {
       return opp;
   }    
   
   Public void setOpp(Opportunity i) {
       opp=i;
   }
   
   Public Opportunity getFact_Param(){
      return Fact_Param;
   }

   Public Void setFact_Param(Opportunity arg){
       Fact_Param = arg;
   }

        public boolean getPasar() {
        return pasar;
        }
        public void setPasar(boolean value) {
        pasar = value;
        }
   
   //Public Account getCuenta() {
   //    return cuenta;
   //}    

   //Public void setCuenta(Account i) {
   //    cuenta = i;
   //}
   
   Public List<Opor> getlistaOpp() {
       return listaOpp;
   }
    
   Public void setlistaOpp(List<Opor> arg) {
       listaOpp=arg;
   }
   
   Public String getMensaje() {
      return Mensaje;      
   }

   Public void setMensaje(String arg) {
      Mensaje=arg;      
   }
  
   public void Buscar () {
    
        this.setMensaje('');
        
        if (this.getListaOpp() != null)
              listaOpp.clear();                                                               
                                               
        List<RecordType> rt=[SELECT Id FROM RecordType WHERE Name='Fc de Brasmax' AND SobjectType='Opportunity'];
        List<RecordType> rt2=[SELECT Id FROM RecordType WHERE Name='Fc de Brasmax Contabilizada' AND SobjectType='Opportunity'];        
        List<Opportunity> result;
                        
        Integer cont = 0;
        
        for(Opportunity o : [Select Id From Opportunity Where Observaciones_paso_a_sap__c <> 'Ok' and Observaciones_paso_a_sap__c <> '']){
                if(!pasar){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Existen oportunidades con errores. No es aconsejable proseguir');                 
                ApexPages.addMessage(msg);
                return; 
                }
        }
         
        String qry;
        String estadoFact = 'PE Contabilizar';

        qry = 'SELECT Id, Name, CloseDate, Account.Name, Account.Id, Safra__c FROM Opportunity';
        qry += ' WHERE RecordTypeId= \''+rt[0].Id+'\' and Observaciones_paso_a_sap__c = \'\'';
                               
        if (this.getOpp().Sucursal__c != null)
           qry += ' AND Sucursal__c = \''+this.Opp.Sucursal__c+'\'';
           
        qry += ' AND Estado_Facturacion__C= \''+estadoFact+'\'';   
                                                             
        qry += ' Limit 1000';

        MiQuery = qry;                                              
        result = Database.query(qry);
                                                                    
        if (result != null)
           for (Opportunity o:result) {
              Opor op = new Opor();
              op.oport=o;
              op.selected=false; 
              listaOpp.add(op);           
            //  if (cont == 998 && Oportunidades.size() == 1000){
            //     ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Se estan visualizando 999 registros. Hay mas registros para consultar.');                 
            //     ApexPages.addMessage(msg); 
            //     break;  
            //  }
              cont += 1;   
           }   
           
        List<AggregateResult> Max_Nro_Legal = [SELECT MAX (Numero_Legal__c) num FROM Opportunity WHERE RecordTypeId = :rt2[0].Id and Sucursal__c= : this.Opp.Sucursal__c];                                                                                            
        Decimal auxVal = 0;
        if(Max_Nro_Legal[0] != null)
                if(Max_Nro_Legal[0].get('num') != null)
                        auxVal += (Decimal)Max_Nro_Legal[0].get('num');
        auxVal++;
        Fact_Param.Numero_Legal__c = auxVal;       
        
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
    
    Public void CrearFacturas () {
    
       List <OpportunityLineItem> items;
       List <RecordType> rt = [SELECT Id FROM RecordType WHERE Name = 'Fc de Brasmax'];
       List <OpportunityLineItem> itemsFactura = New List <OpportunityLineItem>();
       List <Opportunity> ListaOppParaActualizarEstado = New List<Opportunity>();
       Set <Id> IdsOpps = New Set <Id>();
       Boolean HaySeleccion = false;
       Decimal Contador_Nro_Legal;
       String retorno;
       
       Mensaje = '';
       
       if (Fact_Param.Numero_Legal__c == null){
          Mensaje = 'Debe Ingresar un Nro. Legal Inicial';
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
    
       Contador_Nro_Legal = Fact_Param.Numero_Legal__c;
    
       for (Opor o :listaOpp){
          if (o.Selected == true){          
             o.oport.Numero_Legal__c = Contador_Nro_Legal;
             o.oport.CloseDate = System.today();
             ListaOppParaActualizarEstado.add(o.oport);                        
             Contador_Nro_Legal = Contador_Nro_Legal + 1;
          }
       }   
      
       try{
        update ListaOppParaActualizarEstado;
       }catch(Exception e){
        String mensaje = e.getMessage();    
        if(mensaje.contains('DUPLICATE_VALUE')){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Existe una oportunidad con el mismo numero legal');                 
            ApexPages.addMessage(msg);
            return;     
        }           
       }
                                   
       //for (Opor o:listaOpp)
       //   if (o.Selected == true){
             //BMX_Opp_fc_Alta.altaFC(o.oport.Id);
       //      If (!IdsOpps.contains(o.oport.Id))
       //         IdsOpps.add(o.oport.Id);                
       //   }
          
       //FacturasBatchJob j = New FacturasBatchJob (IdsOpps);
       FacturasBatchJob j = New FacturasBatchJob ();
       ID batchId = Database.executeBatch(j, 1);
       
                           
       Mensaje = 'Proceso Terminado';
       listaOpp.clear();
       this.getFact_Param().Sucursal__c=null;
       Fact_Param.Numero_Legal__c=null;
      
    }
    
        
    public static testMethod void test() {
        List<RecordType> rt = [SELECT Id FROM RecordType WHERE Name='Fc de Brasmax' AND SobjectType='Opportunity' limit 1];
//        Account acc = [Select Id, Name From Account limit 1];
        Account acc = new Account(Name='tMP');
        insert acc;
        Opportunity o = new Opportunity(Name='Prub',Stagename='Aberta',Sucursal__c='0094',CloseDate=System.Today(),AccountId=acc.Id,Safra__c='09/10', RecordTypeId=rt[0].Id);
        insert o;
        Facturas_Pendientes_Contab_Controller f = new Facturas_Pendientes_Contab_Controller();
        Facturas_Pendientes_Contab_Controller f2 = new Facturas_Pendientes_Contab_Controller();
        f.setOpp(o);
        f.Buscar();
        f.getMensaje();
        f.SelectAll();
        f.quitarSeleccion();
        f.SelectAll();
        
        Opportunity o2 = new Opportunity(Numero_Legal__c=152, Name='Prueba',Stagename='Aberta',Sucursal__c='0094',CloseDate=System.Today(),AccountId=acc.Id,Safra__c='09/10', RecordTypeId=rt[0].Id); 
        
        f2.crearFacturas();
        f2.setFact_Param(o2);
        f2.crearFacturas();
        
        f.getPasar();
        f.setFact_Param(o2);
        f.crearFacturas();      
        f.setListaOpp(f.getListaOpp());
    }
    */    
  }
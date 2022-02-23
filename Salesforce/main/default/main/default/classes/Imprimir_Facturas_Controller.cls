Public class Imprimir_Facturas_Controller {
   
   Public Opportunity opp = new Opportunity();
   Public Opportunity opp2 = new Opportunity();
   Public List<Opportunity> listaOpp = new List<Opportunity>();
   Public Account cuenta = new Account();
   Public String Mensaje;
   Public Opportunity Fact_Param = new Opportunity(); 
   Public String MiQuery='';
   
      
   Public Opportunity getOpp() {
       return opp;
   }    
   
   Public void setOpp(Opportunity i) {
       opp=i;
   }
   
   Public Opportunity getOpp2() {
       return opp2;
   }    
   
   Public void setOpp2(Opportunity i) {
       opp2=i;
   }
   
   Public Opportunity getFact_Param(){
      return Fact_Param;
   }

   Public Void setFact_Param(Opportunity arg){
       Fact_Param = arg;
   }

   Public Account getcuenta() {
       return cuenta;
   }    

   Public void setcuenta(Account i) {
       cuenta=i;
   }
   
   Public List<Opportunity> getlistaOpp() {
       return listaOpp;
   }
    
   Public void setlistaOpp(List<Opportunity> arg) {
       listaOpp=arg;
   }
   
   Public String getMensaje() {
      return Mensaje;      
   }

   Public void setMensaje(String arg) {
      Mensaje=arg;      
   }
  
   Public Void Buscar () {
    
        Mensaje='';
        
        if (listaOpp != null)
              listaOpp.clear();                                                               
                                               
        List<RecordType> rt=[SELECT Id FROM RecordType WHERE Name='Fc de Brasmax Contabilizada' AND SobjectType='Opportunity'];
        //List<Profile> prof=[SELECT Id, Name FROM Profile WHERE Name='Administrador del sistema'];
        List<Opportunity> result;
                        
        Integer cont = 0;
        
        String qry;

        qry = 'SELECT Id, Name, CloseDate, Estado_Facturacion__c, Account.Name, Account.Id, Safra__c, Numero_Legal__c FROM Opportunity';
        qry += ' WHERE RecordTypeId= \'' + rt[0].Id + '\'';
                                                                                   
        if (opp.Numero_Legal__c != null)
           qry += ' AND Numero_Legal__c >= ' + String.valueOf(opp.Numero_Legal__c);
           
        if (opp2.Numero_Legal__c != null)
           qry += ' AND Numero_Legal__c <= ' + String.valueOf(opp2.Numero_Legal__c);
        
        if (opp.Sucursal__c != null)
        	qry += ' AND Sucursal__c = \'' + String.valueOf(opp.Sucursal__c) + '\'';
                                                             
        qry += ' ORDER BY Numero_Legal__c';
        
        //qry += ' Limit 1000';
                
        MiQuery=qry;                                              
        result = Database.query(qry);
                                                                    
        if (result != null)
           for (Opportunity o:result) {
              listaOpp.add(o);           
            //  if (cont == 998 && Oportunidades.size() == 1000){
            //     ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Se estan visualizando 999 registros. Hay mas registros para consultar.');                 
            //     ApexPages.addMessage(msg); 
            //     break;  
            //  }
              cont += 1;   
           }                                                                                              
    }
    
    Public void Imprimir(){
    
    }
    
    public static testMethod void test() {
    
       Imprimir_Facturas_Controller ifc = new Imprimir_Facturas_Controller(); 
       Opportunity o = new Opportunity();
       Account cuenta = new Account();
       List<Opportunity> lista = new List<Opportunity>();
       ifc.setopp(o);
       o = ifc.getopp();
       ifc.setopp2(o);
       o=ifc.getopp2();
       ifc.setFact_Param(o);
       o=ifc.getFact_Param();
       ifc.setCuenta(cuenta);
       cuenta=ifc.getCuenta();
       ifc.setlistaopp(lista);
       lista = ifc.getListaOpp();    
       ifc.setMensaje('a');
       String a = ifc.getMensaje();
       ifc.Buscar();
    
    }
        
            
  }
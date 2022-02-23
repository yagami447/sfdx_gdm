Public with sharing class Autorizar_Anticipos_Controller  {

    Public OpportunityLineItem Item;
    Public Opportunity opp = new Opportunity();    
    Public List<Opor> listaOpp = new List<Opor>();    
    Public String Mensaje;    
        
    Set<Id> resultIdsItemsAux = new Set<Id>();
         
    public Autorizar_Anticipos_Controller(){
        opp.safra__c = '20/21';
        opp.Marca__c = 'BRMX';
        opp.Region__c = 'REGION 1';
        opp.RecordTypeId = '01240000000M58N';
        if(Item == null)
            Item = new OpportunityLineItem();    
    }
        
    public class Opor{
        public Opportunity oport {get;set;}
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
        
        if (opp.Safra__c == null){ Mensaje = 'Deve Selecionar uma Safra'; return;}
        
        if (opp.Marca__c == null || opp.Marca__c == ''){ Mensaje = 'Deve Selecionar uma Marca'; return;}
        
        if (opp.Region__c == null || opp.Region__c == ''){ Mensaje = 'Deve Selecionar uma Região'; return;}                                         
                                                       
        List<Opportunity> result;
                
        String qry;

        qry = 'SELECT Id, Name, CloseDate, Account.Name, Account.Id, Safra__c, Total_VL_Liquido__c';
        qry += ',(SELECT Id, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.Variedad__c, PriceBookEntry.Product2.Variedade__r.Nombre_de_Registro__c, Quantity, UnitPrice, Tipo_de_Cambio__c, Cot_Soja__c, VL_Liquido__c From OpportunityLineItems)';
        qry += ' FROM Opportunity WHERE RecordType.Name= \'Antecipação Pendente\'';
        
        if (this.opp.Safra__c != null) qry += ' AND Safra__c = \''+this.opp.Safra__c+'\'';     
        
        if (this.opp.Marca__c != null) qry += ' AND Marca__c = \''+this.opp.Marca__c+'\'';     
        
        if (this.opp.Region__c != null) qry += ' AND Region__c = \''+this.opp.Region__c+'\'';     
                   
        qry += ' Order By Account.Name';                                                        
                        
        result = Database.query(qry);
                                    
        if (result != null){          
                        
           for (Opportunity o:result) {
              Opor op = new Opor();
              op.oport=o;
              op.selected=false; 
              listaOpp.add(op);           
           }
        }                                                                                                 
    }
              
    Public void AutorizarAnticipos () {
    
       List <Id> IdsOpps = New List <Id>();
       Boolean HaySeleccion = false;
       String retorno;
       
       Mensaje = '';              
                            
       for (Opor opo :listaOpp)
          if (opo.selected == true){
             HaySeleccion=true;
             break;
          }
          
       if (!HaySeleccion){
          Mensaje = 'Debe Seleccionar al menos una Oportunidad';
          return;
       }    
    
       for (Opor o :listaOpp)
          if (o.Selected == true)          
             IdsOpps.add(o.oport.Id);
             
       Anticipo_Sap_Alta.Retorno ret = Anticipo_Sap_Alta.enviarSAP(IdsOpps, '', 300);
       Mensaje = ret.msg;
                                  
       //Mensaje = 'El Proceso de Autorizacion ha comenzado. Recibira un Mail cuando haya finalizado.';
       listaOpp.clear();       
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
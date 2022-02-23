Public class Facturar_Errores_Controller  {

    Private Opportunity opp;
    Private String url;
            
    Public Facturar_Errores_Controller(){    
       if(this.opp == null)
          this.opp = new Opportunity();    
    }
             
    Public Opportunity getOpp() {                         
        return opp;
    }  
      
    Public void setOpp(Opportunity o) {
        opp=o;
    }
    
    Public String geturl() {                         
        return url;
    }  
      
    Public void seturl(String o) {
        url=o;
    }
        
    Public String getVerDetalles () {
    
       //String url='';
       String anio;
       String mes;
       String dia;
       String fecha; 
                         
       if (this.Opp.Fecha_fijacion_T_de_cambio__c != null){           
          anio = String.valueOf(this.opp.Fecha_fijacion_T_de_cambio__c).substring(0,4);
          dia = String.valueOf(this.opp.Fecha_fijacion_T_de_cambio__c).substring(5,7);
          mes = String.valueOf(this.opp.Fecha_fijacion_T_de_cambio__c).substring(8,10);
          fecha = dia + '/' + mes + '/' + anio;          
          url = '/00O40000002JSq8?pv4=' + fecha;   //00O40000002JSq8       //00OS0000000KGa4                   
       }   
              
       return url;

    }
    
    public static testMethod void test() {
       Facturar_Errores_Controller fec = new Facturar_Errores_Controller();
       Opportunity o = new Opportunity(Fecha_fijacion_T_de_cambio__c=system.today());
       fec.setOpp(o);
       o = fec.getOpp();
       fec.seturl('a');
       String a = fec.geturl();
       String b = fec.getVerDetalles();
    
    }
}
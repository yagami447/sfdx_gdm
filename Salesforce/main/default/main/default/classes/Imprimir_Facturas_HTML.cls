Public class Imprimir_Facturas_HTML {
   
   Private String Fecha_Factura;
   Private Opportunity opp;
   Private Account cuenta;
   Private List<OpportunityLineItem> items;
   Private List<String> lineasRelleno=new List<String>();
   
   Public void setFecha_Factura(String arg) {
      Fecha_Factura=arg;
   }
   
   Public String getFecha_Factura() {
      return Fecha_Factura;
   }
   
   Public void setcuenta(Account arg) {
      cuenta=arg;
   }
   
   Public Account getcuenta() {
      return cuenta;
   }
   
   Public void setopp(Opportunity arg) {
      opp=arg;
   }
   
   Public Opportunity getopp() {
      return opp;
   }
   
   Public void setitems(List<OpportunityLineItem> arg) {
      items=arg;
   }
   
   Public List<OpportunityLineItem> getitems() {
      return items;
   }
   
   Public List<String> getlineasRelleno() {
      return lineasRelleno;
   }
   
   Public void setlineasRelleno(List<String> arg) {
      lineasRelleno=arg;
   }

       
   Public Imprimir_Facturas_HTML(){
                      
      Id oppId = System.currentPageReference().getParameters().get('id');
      
      opp = [Select Id, Type, Name, numero_legal__c, StageName, AccountId, CloseDate, Tipo_de_cambio__c, Numero_del__c, Amount, Safra__c From Opportunity Where Id = : oppId];
      cuenta = [Select Id, Name, BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, CEP__c, CNPJ_CPF__c, IE__c From Account Where Id = : opp.accountId];  
      items = [Select Id, PricebookEntry.Product2.Name, PricebookEntry.Product2.Description ,UnitPrice, TotalPrice, Quantity From OpportunityLineItem Where OpportunityId = : oppId]; 
   
      Fecha_Factura=String.valueof(opp.CloseDate);
      Fecha_Factura=Fecha_Factura.substring(8,10) + '/' + Fecha_Factura.substring(5,7) + '/' + Fecha_Factura.substring(0,4); 
      
      for(Integer i=items.size();i<=31;i++)
         lineasRelleno.add('');
  
   }
   
   public static testMethod void testM() {

      Account acc = New Account (Name='a');
      insert acc;
      RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Comercial' limit 1];
      Opportunity opp = New Opportunity(Name='a', StageName='Abierta', AccountId= acc.Id, CloseDate=system.today(), RecordTypeId=rt.Id);                  
      insert opp;
      PriceBookEntry pbe = [Select Id From PriceBookEntry where isActive = true limit 1];
      OpportunityLineItem item = New OpportunityLineItem (OpportunityId = opp.Id, UnitPrice = 1, Quantity = 1, PricebookEntryId = pbe.Id);
      insert item; 
      System.currentPageReference().getParameters().put('id',opp.Id);
      Imprimir_Facturas_HTML a = New Imprimir_Facturas_HTML();
      a.setFecha_Factura('a');
      String b = a.getFecha_Factura();
      a.setcuenta(acc);
      acc=a.getcuenta();
      a.setOpp(opp);
      Opportunity o = a.getOpp();
      OpportunityLineItem i = New OpportunityLineItem(OpportunityId=opp.Id, Quantity=1, UnitPrice=1);
      List <OpportunityLineItem> items = New List<OpportunityLineItem>();
      items.add(i);
      a.setitems(items);
      List <OpportunityLineItem> it = a.getitems();
      List <String> g = a.getLineasRelleno();
      List <String> h = New List <String>();
      a.setLineasRelleno(h);
         
   }


}
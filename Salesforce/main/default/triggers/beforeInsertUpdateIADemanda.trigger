trigger beforeInsertUpdateIADemanda on Analitica_DemandaVsVenta__c (before update) {
    List<String> names = new List<String>();
    Map<String, Id> mapProds = new Map<String,Id>();
    for(Analitica_DemandaVsVenta__c a : Trigger.New){
        if(a.ProductName__c!=null && a.ProductName__c != '')
            names.add(a.ProductName__c);
    }
    for(Product2 p : [Select Id, Name From Product2 where Name in :names]){
        mapProds.put(p.Name,p.Id);
    }
    for(Analitica_DemandaVsVenta__c a : Trigger.New){
        a.Producto__c = mapProds.get(a.ProductName__c);
    }
}
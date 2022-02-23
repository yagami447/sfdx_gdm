global class ScheduActualizarIADemanda implements Schedulable {
	
	//Global execute, este método es ejecutado en la fecha y horario configurado para tal trabajo	
	global void execute(SchedulableContext ctx){		
        actualizarIA();
	}		
	
	@future(callout=true)
	public static void actualizarIA(){
		List<Product2> prods = [Select Id, Name From Product2 where isActive = true];
		Map<String, Product2> mapProds = New Map <String, Product2>();
		for(Product2 p : prods){
			mapProds.put(p.Name,p);		
		}
		
		List<Analitica_DemandaVsVenta__c> ias = [Select Id, ProductName__c from Analitica_DemandaVsVenta__c where ProductName__c != null and Producto__c = null];
		for(Analitica_DemandaVsVenta__c i_a : ias)
		{
			Product2 p = mapProds.get(i_a.ProductName__c);
			if(p != null)
				i_a.Producto__c = p.Id;	
		}
		update ias;
	}

}
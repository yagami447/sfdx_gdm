@isTest
private class testOppItemTrigger {

   static testMethod void deleteItemsTest() {
    	Id PriceBook2Id = Test.getStandardPricebookId();
    	Product2 newProd = new Product2(Name = 'test product', family = 'test family');	insert newProd;    	
    	PriceBookEntry pbEntry = new PriceBookEntry(UnitPrice = 300, PriceBook2Id = PriceBook2Id, Product2Id = newProd.Id, IsActive = true); insert pbEntry ;

    	Opportunity opp = new Opportunity(Name='OppTest',Stagename='Aprobada',CloseDate=System.today()); insert opp;
        OpportunityLineItem oi = new OpportunityLineItem(Estado_facturacion__c='PE',OpportunityId=opp.Id,Quantity=100,PricebookEntryId=pbEntry.Id,TotalPrice=1000);
        insert oi; 
        OpportunityLineItem oiDel = null;
        
    	Id itemId = oi.Id;
        delete oi;
        
        try{
        	oiDel = [Select Id from OpportunityLineItem where Id = :itemId];
        }
        catch(Exception e){
        	
        }        
        System.assertEquals(oiDel, null);    
       
    }
    
    static testMethod void updateItemsTest() {
    	Id PriceBook2Id = Test.getStandardPricebookId();
    	Product2 newProd = new Product2(Name = 'product', family = 'family');	insert newProd;    	
    	PriceBookEntry pbEntry = new PriceBookEntry(UnitPrice = 3, PriceBook2Id = PriceBook2Id, Product2Id = newProd.Id, IsActive = true); insert pbEntry ;

    	Opportunity opp = new Opportunity(Name='Opp2Test',Stagename='Aprobada',CloseDate=System.today()); insert opp;
        OpportunityLineItem oi = new OpportunityLineItem(Estado_facturacion__c='PE',OpportunityId=opp.Id,Quantity=100,PricebookEntryId=pbEntry.Id,TotalPrice=100);
        insert oi; 
        
        oi.Estado_facturacion__c = 'Pasado Pedido';
        update oi;	
                        
        try{
        	oi.Estado_facturacion__c = 'Pasado Pedido';
        	oi.Motivo_de_Rechazo__c = 'Z6';
        	update oi;	
        }
        catch(Exception e){
        	
        } 
    }
}
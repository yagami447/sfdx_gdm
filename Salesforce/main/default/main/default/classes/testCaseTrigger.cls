@isTest
private class testCaseTrigger {

   static testMethod void InsertCaseVB() {
    	RecordType rt = [Select Id, Name From RecordType Where Name = 'Reclamo Venda Basica'];  
    	
        Case rec = new Case(Subject='JERE',RecordTypeId=rt.Id,Data_do_problema__c=System.Today(),Marca__c='BRMX',Reason='NOO',Status='PE');
        insert rec;
        System.assertNotEquals(rec.Id,null);
    }
    
    static testMethod void updateCase() {
        RecordType rt = [Select Id, Name From RecordType Where Name = 'Reclamo Venda Basica'];  
    	Cidade__c ciudad = new Cidade__c(Name='JERE'); insert ciudad;
    	
        Case rec = new Case(Subject='JERE',RecordTypeId=rt.Id,Data_do_problema__c=System.Today(),Marca__c='BRMX',Reason='NOO',Status='PE');
        insert rec;
        
        rec.Ciudad_del_Problema__c = ciudad.Id;
        update rec;
          
    }
}
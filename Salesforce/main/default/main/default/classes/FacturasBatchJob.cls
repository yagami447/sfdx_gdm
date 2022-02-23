global class FacturasBatchJob implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {

    private final String query;
                    
    Public FacturasBatchJob (){
       query = 'SELECT Id FROM Opportunity WHERE Numero_Legal__c != null AND Observaciones_paso_a_sap__c = \'\' and Estado_Facturacion__c = \'PE Contabilizar\'';       
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
       return Database.getQueryLocator(this.query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> batch){
        for(SObject s : batch) {
            Opportunity opp = (Opportunity)s;
            BMX_Opp_fc_Alta.altaFC(opp.Id, '300');
        }
    }

    global void finish(Database.BatchableContext bc){
    
       AsyncApexJob a = [select Id, Status, NumberOfErrors, CompletedDate, CreatedDate from AsyncApexJob where Id = :bc.getJobId()];
    
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {'jarias@donmario.com'}; 
       
       mail.setToAddresses(toAddresses);
       mail.setSenderDisplayName('Facturacion Brasmax.');
       mail.setSubject('Facturacion Brasmax: ' + a.Status);
       String msg = 'El proceso finalizo con ' + a.NumberOfErrors + ' errores.<br>';
       msg += 'Creado el ' + a.CreatedDate.format('dd/MM/yyyy HH:mm:ss') + ' - Finalizado el: ' + a.CompletedDate.format('dd/MM/yyyy HH:mm:ss') + '<br>';
       msg += 'Batch Id: ' + a.id;
       mail.setHtmlBody(msg);
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
    }

	public static testMethod void testBatch() {		
		Test.StartTest();
		FacturasBatchJob fb_job = new FacturasBatchJob();		
		ID batchprocessid = Database.executeBatch(fb_job);
   		Test.StopTest(); 
	}
	
}
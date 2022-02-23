global class AutorizarNVBatchJob implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {

    private final String query;
    private List<Id> opIds = New List<Id>();
                    
    Public AutorizarNVBatchJob (){
       List <RecordType> rt = [SELECT Id FROM RecordType WHERE Name = 'Pendiente' limit 1];
       //query = 'SELECT Id, StageName FROM Opportunity WHERE RecordTypeId = \''+rt[0].Id+'\' AND Fecha_fijacion_T_de_cambio__c != null AND Tipo_de_cambio__c != null AND Sucursal != \'\'';       
       //query = 'SELECT Id, StageName FROM Opportunity WHERE RecordTypeId = \''+rt[0].Id+'\' AND Fecha_fijacion_T_de_cambio__c != null AND Tipo_de_cambio__c != null AND Sucursal__c != null';       
       query = 'SELECT Id, StageName, Marca_Enviar_SAP__c FROM Opportunity WHERE RecordTypeId = \''+rt[0].Id+'\' AND Marca_Enviar_SAP__c = true';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
       return Database.getQueryLocator(this.query);          
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> batch){
    	
    	//List<Opportunity> oport = [Select Id, Marca_Enviar_SAP__c From Opportunity Where Marca_Enviar_SAP__c = true];
        //if (oport != null){
           //for (Opportunity opo : oport) 
              //opo.Marca_Enviar_SAP__c = false;
           //update oport;   
        //}
        
        //for(SObject s : batch) {
           //Opportunity opp = (Opportunity)s;
           //opp.Marca_Enviar_SAP__c = false;	
           //opIds.add(opp.Id);
        //}
       
        //update batch;
       
        for(SObject s : batch) {
            Opportunity opp = (Opportunity)s;
            opIds.add(opp.Id);
            Opp_Sap_Alta.enviarSAP(opp.Id,opp.StageName,300);
        }
    }

    global void finish(Database.BatchableContext bc){
    
       List<Opportunity> oport = [Select Id, Marca_Enviar_SAP__c From Opportunity Where Marca_Enviar_SAP__c = true];
        if (oport != null){
           for (Opportunity opo : oport) 
              opo.Marca_Enviar_SAP__c = false;
           update oport;   
        }
       
       AsyncApexJob a = [select Id, Status, NumberOfErrors, CompletedDate, CreatedDate from AsyncApexJob where Id = :bc.getJobId()];
       List<Opportunity> op = [Select Id, Name, Account.Name, RecordType.Name From Opportunity Where Id In : opIds];	
    
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {'mauricio@brasmaxgenetica.com.br'}; 
       String[] ccAddresses = new String[] {};
       toAddresses.add('carla@brasmaxgenetica.com.br');
       ccAddresses.add('jarias@donmario.com');       
       
       mail.setToAddresses(toAddresses);
       mail.setCcAddresses(ccAddresses);
       mail.setSenderDisplayName('Facturacion Brasmax.');
       mail.setSubject('Facturacion Brasmax: ' + a.Status);
       //String msg = 'El proceso finalizo con ' + a.NumberOfErrors + ' errores.<br>';
       String msg = 'Resumen del proceso:<br><br>';
       if (op != null){
       	  msg +='<table border="1"><tr><td>ID OPORTUNIDAD</td><td>NOMBRE</td><td>CUENTA</td><td>ESTADO</td></tr>'; 
          for (Opportunity o : op)
             msg += '<tr><td>' + o.Id + '</td><td>' + o.Name + '</td><td>' + o.Account.Name + '</td><td>' + o.RecordType.Name + '</td></tr>';
          msg += '</table>';                
       }      
       msg += '<br>';        
       msg += 'Creado el ' + a.CreatedDate.format('dd/MM/yyyy HH:mm:ss') + ' - Finalizado el: ' + a.CompletedDate.format('dd/MM/yyyy HH:mm:ss') + '<br>';
       msg += 'Batch Id: ' + a.id;
       mail.setHtmlBody(msg);
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
    }

    public static testMethod void testBatch() {     
        Test.StartTest();
        AutorizarNVBatchJob aNV_job = new AutorizarNVBatchJob();       
        ID batchprocessid = Database.executeBatch(aNV_job);
        Test.StopTest(); 
    }
    
}
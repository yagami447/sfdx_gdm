trigger afterInsertUpdateReclamoVB on Case (after insert, after update) {
    String Body = ''; Boolean hayRVB = false;
    Map<Id,String> mapAcc = New Map<Id,String>();
    for(Case c : Trigger.new) if(c.RecordTypeId == '01240000000MFFQ' || c.RecordTypeId == '012f00000008p48') hayRVB = true;
    Set<Id> accId = New Set<Id>();
    for(Case c : Trigger.new) accId.add(c.AccountId);
    if(hayRVB){
	    for(Account a : [SELECT Id, Name FROM Account WHERE Id IN : accId]) mapAcc.put(a.Id, a.Name);
	    if(Trigger.isInsert){
	        for(Case c : Trigger.new){
	            Body = 'Nova Reclamação de Venda de Básica. \r\n'+'Número: ' + c.CaseNumber + '\r\n'+'Multiplicador: ' + mapAcc.get(c.AccountId) + '\r\n' + 'Marca: ' + c.Marca__c + '\r\n' + 'Motivo: ' + c.Reason + '\r\n' + 'Status: ' + c.Status + '\r\n' + 'Data do Prob.: ' + c.Data_do_problema__c.format() + '\r\n' + 'Descrip: ' + c.Description + '\r\n' + 'Acessar:   https://cs16.salesforce.com/' + c.Id;
	            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	            mail.setSenderDisplayName('Reclamo Venda Basica');
	            String[] toAddresses = new String[] {'admvendas@gdmseeds.com'};
	            mail.setCcAddresses(toAddresses);
	            mail.setSaveAsActivity(false);
	            mail.setPlainTextBody(Body);
	            mail.setSubject('Reclamação Venda de Básica: ' + c.CaseNumber);
	            if (!Test.isRunningTest())
	            	Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
	        }	        
	    }
	    if(Trigger.isUpdate){
	        for(Case c : Trigger.new){
	            Case Antes = System.Trigger.oldMap.get(c.Id);
	            Body = 'Reclamação de Venda de Básica atualizada. \r\n'+'Número: ' + c.CaseNumber + '\r\n'+'Multiplicador: ' + mapAcc.get(c.AccountId) + '\r\n' + 'Marca: ' + c.Marca__c + '\r\n' + 'Motivo: ' + c.Reason + '\r\n' + 'Status: ' + c.Status + '\r\n' + 'Data do Prob.: ' + c.Data_do_problema__c.format() + '\r\n' + 'Descrip: ' + c.Description + '\r\n' + 'Resolução: ' + c.Respuesta__c + '\r\n' + 'Acessar:   https://cs16.salesforce.com/' + c.Id;
	            /*Body = 'Reclamação de Venda de Básica atualizada \r\n'+'Número: ' + c.CaseNumber + ' \r\n'+'Multiplicador: ' + mapAcc.get(c.AccountId) + ' \r\n' + 'Marca: ' + c.Marca__c + ' \r\n';
	            Body += Motivo Atual: ' + c.Reason;
	            Body += '\r\n'+ 'Status Ant: ' + Antes.Status + '\r\n Status Atual: ' + c.Status;
	            Body += '\r\n'+ 'Data do Prob. Ant: ' + Antes.Data_do_problema__c.format() + '\r\n Data do Prob. Atual: ' + c.Data_do_problema__c.format()+'\r\n';
	            Body += '\r\n'+ 'Descrip Ant: ' + Antes.Description + '\r\n Descrip Atual: ' + c.Description + ' \r\n';
	            Body += '\r\n'+ 'Resolução Ant: ' + Antes.Respuesta__c + '\r\n Resolução Atual: ' + c.Respuesta__c + ' \r\n';
	            Body += 'Acessar:   https://cs16.salesforce.com/' + c.Id;*/
	            
	            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	            mail.setSenderDisplayName('Reclamo Venda Basica');
	            String[] toAddresses = new String[] {'admvendas@gdmseeds.com'};
	            mail.setCcAddresses(toAddresses);
	            mail.setSaveAsActivity(false);
	            mail.setPlainTextBody(Body);
	            mail.setSubject('Reclamação Venda de Básica: ' + c.CaseNumber);
	            if (!Test.isRunningTest())
	            	Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
	        }
	    }
    }else{
    	if(Trigger.isInsert)
	        for(Case c : Trigger.new) reclamosController.asignar(c.Id, UserInfo.getUserId());
    }
    
}
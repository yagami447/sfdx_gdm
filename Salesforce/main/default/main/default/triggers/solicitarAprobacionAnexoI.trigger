trigger solicitarAprobacionAnexoI on Opportunity (After update) {     
    
    for (Integer i = 0; i < Trigger.new.size(); i++){  
       try{     
          if(Trigger.new[i].Next_Step__c == 'Solicitud Aprobacion' && Trigger.old[i].Next_Step__c != 'Solicitud Aprobacion')  
             submitForApproval(Trigger.new[i]);  
       }catch(Exception e){  
          Trigger.new[i].addError(e.getMessage());  
       }  
    }  

    public void submitForApproval(Opportunity opp){  
       // Create an approval request for the Opportunity  
       Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
       //req1.setComments('Submitting request for approval automatically using Trigger');  
       req1.setObjectId(opp.id);
       List<Id> nextApproverIds = New List<Id>();
       nextApproverIds.add(opp.ownerId);
       req1.setNextApproverIds(nextApproverIds);    
       // Submit the approval request for the Opportunity  
       if (!Test.isRunningTest())                
       	   Approval.ProcessResult result = Approval.process(req1);            
    }      
    
}
public class CulturaBatch implements Database.Batchable<Opportunity> { 

    public List<Opportunity> start(Database.BatchableContext info){ 
        return [SELECT Id, Cultura__c FROM Opportunity WHERE Cultura__c = '']; 
    }     

    public void execute(Database.BatchableContext info, List<Opportunity> scope){

        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for(Opportunity opp : scope){ 
            opp.Cultura__c = 'Soja'; 
            oppsToUpdate.add(opp); 
        } 

        Database.SaveResult[] updateResults = Database.update(oppsToUpdate, false); 

        for(Database.SaveResult result : updateResults) {
            if(!result.isSuccess()) {
                for(Database.Error err : result.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Opportunity field that affected this error: ' + err.getFields());
                }
            }
        }

    }     

    public void finish(Database.BatchableContext info){     
    } 
 }
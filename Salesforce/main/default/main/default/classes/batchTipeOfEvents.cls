global class batchTipeOfEvents implements Database.Batchable<sObject>, Database.Stateful {
    
    Map<String,integer> typesByCant = new Map<String,integer>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id FROM CRM_Calendario_de_Eventos__c';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<CRM_Calendario_de_Eventos__c> eventos) {
        
        Integer cant;
        List<Id> contentDocLink = new List<Id>();  
        List<Id> attachmentContentId = new List<Id>();       
		Set<Id> resultIds = (new Map<Id,CRM_Calendario_de_Eventos__c>(eventos)).keySet();

        try {
        
            // Para contentDocument
            List<ContentDocumentLink> contentDocumentLinkRecords = [SELECT ContentDocumentId
                                                                        FROM ContentDocumentLink 
                                                                            WHERE LinkedEntityId IN: resultIds];

       

            for(ContentDocumentLink content: contentDocumentLinkRecords){
                if(content.ContentDocumentId != null){
                    contentDocLink.add(content.ContentDocumentId);
                }
            }

  


            // Para attachment
            List<Attachment> attachmentRecords = [SELECT Name
                                                        FROM Attachment 
                                                            WHERE ParentId IN: resultIds OR ParentId IN: attachmentContentId];

     

            AggregateResult[] fileTypes = [SELECT FileType  
                                                FROM ContentVersion 
                                                    GROUP BY FileType];


            List<ContentVersion> contentVersions = [SELECT Id, FileType 
                                                        FROM ContentVersion 
                                                            WHERE ContentDocumentId IN: contentDocLink];


            for(Integer i = 0; i < fileTypes.size(); i++) {
                
                cant= typesByCant.get(JSON.serialize(fileTypes[i].get('FileType'))) == null ?  0 : typesByCant.get(JSON.serialize(fileTypes[i].get('FileType')));
                
                    for(ContentVersion content: contentVersions){
                        
                          
                            if(fileTypes[i].get('FileType') == content.FileType) {
                   
                                cant++;
                                typesByCant.put(JSON.serialize(fileTypes[i].get('FileType')), cant);
                            }
                     }
                    for(Attachment attach: attachmentRecords){
                        
                          String ext = attach.Name.split('\\.')[1];
                        
                          if(fileTypes[i].get('FileType') == ext) {
                   
                                cant++;
                                typesByCant.put(JSON.serialize(fileTypes[i].get('FileType')), cant);
                          }      
                    }

                } 
  

        }catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }  
    }
     
    global void finish(Database.BatchableContext BC) {
        system.debug('---Finished');
        system.debug('---typesByCant ' + typesByCant);
       for(String key : typesByCant.keySet()){
      		System.debug(key + ' ' + typesByCant.get(key));
       }
    }
}
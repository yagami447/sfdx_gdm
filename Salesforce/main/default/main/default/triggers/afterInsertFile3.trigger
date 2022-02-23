trigger afterInsertFile3 on ContentDocument (before delete) {
    Id recId;
    //if(Trigger.isInsert)
    //    recId = Trigger.New[0].Id;
    //if(Trigger.isDelete)
        recId = Trigger.Old[0].Id;
        
    List<ContentDocumentLink> cd = New List<ContentDocumentLink>(); 
    cd = [Select Id, LinkedEntityId From ContentDocumentLink Where ContentDocumentId = : recId];
        
    if (cd.size() > 0 && cd[0].LinkedEntityId != null){
	    List<CRM_Calendario_de_Eventos__c> co = [select id, Arquivos_cont__c from CRM_Calendario_de_Eventos__c where id =: cd[0].LinkedEntityId];
    	if(co.size()>0) {
	    	List<String> cdId = New List<String>();
		    for (ContentDocumentLink cdl : [select Id, ContentDocumentId from ContentDocumentLink where LinkedEntityId=:co[0].Id])
    		  	cdId.add(cdl.ContentDocumentId);
		    if (cdId.size() > 0){	        	
    		   	List<ContentVersion> cv = [select Id from ContentVersion where ContentDocumentId In :cdId And IsLatest = true];
       			co[0].Arquivos_cont__c -= 1;
	    	}
    
    	    Integer numAtts = [select count() from attachment where parentid=:recId];
        	co[0].Arquivos_cont__c += numAtts;
                       
        	update co;   
    	}
    }
}
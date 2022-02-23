trigger afterInsertFile2 on ContentDocumentLink (after insert, after delete) {
    Id recId;
    if(Trigger.isInsert)
        recId = Trigger.New[0].LinkedEntityId;
    if(Trigger.isDelete)
        recId = Trigger.Old[0].LinkedEntityId;
        
    List<CRM_Calendario_de_Eventos__c> co = [select id, Arquivos_cont__c from CRM_Calendario_de_Eventos__c where id =: recId];
    if(co.size()>0) {
    	List<String> cdId = New List<String>();
	    for (ContentDocumentLink cdl : [select Id, ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recId])
    	  	cdId.add(cdl.ContentDocumentId);
	    if (cdId.size() > 0){	        	
    	   	List<ContentVersion> cv = [select Id from ContentVersion where ContentDocumentId In :cdId And IsLatest = true];
       		co[0].Arquivos_cont__c = cv.size();
    	}
    
        Integer numAtts = [select count() from attachment where parentid=:recId];
        co[0].Arquivos_cont__c += numAtts;
                       
        update co;   
    }
}
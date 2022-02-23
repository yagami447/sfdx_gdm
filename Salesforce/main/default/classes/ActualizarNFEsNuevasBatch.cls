global class ActualizarNFEsNuevasBatch implements Database.Batchable<sObject>, Database.Stateful,  Database.AllowsCallouts {
    
    private String idNota;
    private Datetime fechaFiltro;
    private String finalStr;
    
    public ActualizarNFEsNuevasBatch() {
        // La fecha para filtrar por CreatedDate por defecto es 48 horas atras desde este momento
        this.fechaFiltro = System.now().addHours(-48);
    }

    public ActualizarNFEsNuevasBatch(String idNota) {
        this.idNota = idNota;
    }

    public ActualizarNFEsNuevasBatch(Datetime fechaFiltro) {
        this.fechaFiltro = fechaFiltro;
    }
    
    public ActualizarNFEsNuevasBatch(String idNota, Datetime fechaFiltro) {
        this.idNota = idNota;
        this.fechaFiltro = fechaFiltro;
    }
    
    global Database.QueryLocator start(Database.BatchableContext context) {  
        this.finalStr = 'Nota fiscal eletronica id, Nota fiscal eletronica, Nro de nota fiscal eletronica, Fecha creacion, Actualizado\n';
        
 		String query =  
            'SELECT Id, NFe__c, Name, CreatedDate ' +
            'FROM Nota_Fiscal_Eletr_nica__c ' +
            'WHERE CreatedDate >= :fechaFiltro ' +
            '	AND Consulta_de_Datos_Realizada__c = false ';
        
        query += idNota != null ? 'AND NFe__c = :idNota' : 'AND NFe__c != NULL ';
        
        return Database.getQueryLocator(query);
    }
    	
    global void execute(Database.BatchableContext context, List<Nota_Fiscal_Eletr_nica__c> scope) {
        Map<Id, Nota_Fiscal_Eletr_nica__c> responseNFEsById = new Map<Id, Nota_Fiscal_Eletr_nica__c>();
        Map<Id, List<Produto_da_nota_fiscal__c>> produtosByNFEId = new Map<Id, List<Produto_da_nota_fiscal__c>>();

        for (Nota_Fiscal_Eletr_nica__c nFE : scope) {      
            try {
                NFeWapper nFEWrapper = WSNFe.getNFe(nFE.NFe__c, false);
                responseNFEsById.put(nFE.Id, nFEWrapper.createOpportunity());
                if(!produtosByNFEId.containsKey(nFE.Id)) {
                    produtosByNFEId.put(nFE.Id, new List<Produto_da_nota_fiscal__c>());
                }
                produtosByNFEId.get(nFE.id).addAll(nFEWrapper.createItems(nFE.id));
            } catch (Exception ex) {
                System.debug(ex.getMessage());
            }
        }
        
        WSNFe.RegisterRequest('WSNFe', responseNFEsById.size());
        
        Map<Id, Map<String, Produto_da_Nota_Fiscal__c>> produtosByNameByNFEId = new Map<Id, Map<String, Produto_da_Nota_Fiscal__c>>();
        for(Produto_da_Nota_Fiscal__c produto : [
            SELECT Id, Name, Nota_Fiscal_Eletr_nica__c 
            FROM Produto_da_Nota_Fiscal__c 
            WHERE Nota_Fiscal_Eletr_nica__c IN :scope
        ]) {
            if(!produtosByNameByNFEId.containsKey(produto.Nota_Fiscal_Eletr_nica__c)) {
                produtosByNameByNFEId.put(produto.Nota_Fiscal_Eletr_nica__c, new Map<String, Produto_da_Nota_Fiscal__c>());
            }
            
            produtosByNameByNFEId.get(produto.Nota_Fiscal_Eletr_nica__c).put(produto.Name, produto);
        }
        
        List<Nota_Fiscal_Eletr_nica__c> nFEsToUpdate = new List<Nota_Fiscal_Eletr_nica__c>();
        List<Produto_da_Nota_Fiscal__c> produtosToUpsert = new List<Produto_da_Nota_Fiscal__c>(); 
        for(Nota_Fiscal_Eletr_nica__c nFE : scope) {
            if(responseNFEsById.containsKey(nFE.Id)) {
                Nota_Fiscal_Eletr_nica__c nota = responseNFEsById.get(nFE.Id);
                nota.Id = nFE.Id;
                nota.Consulta_de_Datos_Realizada__c = true;
                nota.Status__c = 'Em Análise';
                nFEsToUpdate.add(nota);
            }
            if(produtosByNFEId.containsKey(nFE.Id)) {
                Map<String, Produto_da_Nota_Fiscal__c> produtosNFEByName = new Map<String, Produto_da_Nota_Fiscal__c>();
                if(produtosByNameByNFEId.containsKey(nFE.Id)) {
                    produtosNFEByName = produtosByNameByNFEId.get(nFE.Id);
                }
                
                for(Produto_da_Nota_Fiscal__c produto : produtosByNFEId.get(nFE.Id)) {
                    // Veo si existe un producto con el mismo nombre relacionada a la nfe actual 
                    // y si es asi le pego el id del producto con el mismo nombre asi se actualiza en vez 
                    // de insertarse y que haya productos repetidos
                    if(produtosNFEByName.containsKey(produto.Name)) {
                        produto.Id = produtosNFEByName.get(produto.Name).Id;
                    }
                    produtosToUpsert.add(produto);
                }
            }
        }
        
        if(nFEsToUpdate.size() > 0) {
            update nFEsToUpdate;
        }
        if(produtosToUpsert.size() > 0) {
            upsert produtosToUpsert;
        }
        
        for(Nota_fiscal_eletr_nica__c nFE : scope) {
            if(responseNFEsById.containsKey(nFE.Id)) {
            	finalStr += nFE.Id + ', ' + nFE.Name + ', ' + nFE.NFe__c + ', ' + nFE.CreatedDate + ', ' + 'Si' + '\n';
            }
        }
    }
    
    global void finish(Database.BatchableContext context) {
        if(!Test.isRunningTest()) {
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            csvAttc.setFileName('Notas fiscales consultadas.csv');
            csvAttc.setBody(Blob.valueOf(finalstr));
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] toAddresses = new List<String>();
            for(User u : [
                SELECT Email 
                FROM User 
                WHERE Profile.Name IN ('System Administrator', 'Administrador del Sistema')
            ]) {
                toAddresses.add(u.Email);
            }
            String subject ='Notas fiscales consultadas CSV ' + System.now();
            email.setSubject(subject);
            email.setToAddresses(toAddresses);
            email.setPlainTextBody('Notas fiscales consultadas CSV');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
}
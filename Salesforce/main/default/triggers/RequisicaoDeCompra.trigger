trigger RequisicaoDeCompra on Requisicao_de_compra__c (before update, after insert, after update, before insert) {
   
    Id milhoRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByDeveloperName().get('Milho').getRecordTypeId();
    Id sojaRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByDeveloperName().get('Soja').getRecordTypeId();

    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            List<Requisicao_de_compra__c> filteredList = new List<Requisicao_de_compra__c>();
            for(Requisicao_de_compra__c record : Trigger.New) {
                if(record.RecordTypeId == sojaRecordType) {
                    filteredList.add(record);
                }
            }
            if(filteredList.size() != 0) {
                RequisicaoDeCompraHelper.setParent(filteredList);
            }
        } else if(Trigger.isUpdate) {
            //agregamos las requisiciones para aprobar que tengan estado pendiente y sean distinto al estado anterior
            List<Id> requisicionesParaAprobarId = new List<Id>();
            List<Requisicao_de_compra__c> filteredList = new List<Requisicao_de_compra__c>();
            
            for(Requisicao_de_compra__c req : Trigger.new) {
                Requisicao_de_compra__c oldReq = Trigger.oldMap.get(req.id);
                Boolean cambioAPendiente = req.Estado__c == 'Pendente' && req.Estado__c != oldReq.Estado__c && req.Tipo__c != 'Supervisor' && req.RecordTypeId != milhoRecordType;
                if(cambioAPendiente) { 
                    requisicionesParaAprobarId.add(req.id);
                }
                if(req.RecordTypeId == milhoRecordType && req.Estado__c == 'Pendente') { 
                    filteredList.add(req);
                }
                //Si el cambio a pendiente fue exitoso y la cantidad productos es 0 entonces lanzo error
                if(cambioAPendiente && req.Cantidad_Productos__c == 0) {                
                   req.addError('Não é possível enviar se você não tiver produtos');
                }
            }
            if(!filteredList.isEmpty()) {
                RequisicaoDeCompraHelper.setParent(filteredList);
            }
			//Si hay requisiciones para aprobar mandamos a validar las requisiciones hijas
            if(!requisicionesParaAprobarId.isEmpty()) {
                RequisicaoDeCompraHelper.validarEstadoRequisicionesHijasParaAprobar(requisicionesParaAprobarId);
            }
        }
    } 
    
    // Agregado por Jhonny Peroza
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {                                                                                                                                                                                                                                                                                                           
            RequisicaoDeCompraHelper.updateRequisicao(Trigger.New);
        }
    }
}
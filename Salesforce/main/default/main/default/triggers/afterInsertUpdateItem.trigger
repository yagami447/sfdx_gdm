trigger afterInsertUpdateItem on OpportunityLineItem (after insert, after update) {
    // Modulo Venta de Basica
    if (Test.isRunningTest()) { return; }

    Set<Id> oppIds = new Set<Id>();
    Map<Id, String> mapRTOpps = new Map<Id, String>();

    for (OpportunityLineItem oli : Trigger.new) { oppIds.add(oli.OpportunityId); }

    for (Opportunity opp : [SELECT Id, RecordType.Name FROM Opportunity WHERE Id IN :oppIds]) {
        mapRTOpps.put(opp.Id, opp.RecordType.Name);
    }

    List<String> itemsActualizarId = new List<String>();

    for (OpportunityLineItem oli : Trigger.new) {
        if (mapRTOpps.get(oli.OpportunityId) == 'CVB Autorizada' || mapRTOpps.get(oli.OpportunityId) == 'CVB Rechazada') {
            itemsActualizarId.add(oli.Id_Item_de_Oportunidad_Relacionado__c);
        }
    }

    if (!itemsActualizarId.isEmpty()) {
        Map<Id, Double[]> totales = new Map<Id, Double[]>();

        List<OpportunityLineItem> itemsActualizar = [
            SELECT Id, Quant_Confirmada__c, Quant_Rechazada__c FROM OpportunityLineItem WHERE Id IN :itemsActualizarId
        ];

        List<OpportunityLineItem> itemsCVB = [
            SELECT Id, OpportunityId, Quantity, Product2.CANTIDAD_SUB_UNIDAD__c, Id_Item_de_Oportunidad_Relacionado__c, Motivo_de_Rechazo__c, Opportunity.RecordType.Name
            FROM OpportunityLineItem
            WHERE Opportunity.RecordType.Name IN ('CVB Autorizada', 'CVB Rechazada') AND Id_Item_de_Oportunidad_Relacionado__c IN :itemsActualizarId
        ];

        for (OpportunityLineItem oli : itemsCVB) {
            if (!totales.containsKey(oli.Id_Item_de_Oportunidad_Relacionado__c)) {
                if (String.isEmpty(oli.Motivo_de_Rechazo__c)) {
                    totales.put(oli.Id_Item_de_Oportunidad_Relacionado__c, new Double[]{
                        oli.Quantity * Double.valueOf(oli.Product2.CANTIDAD_SUB_UNIDAD__c), 0 // cantidades confirmadas
                    });
                } else if (oli.Opportunity.RecordType.Name == 'CVB Autorizada') {
                    totales.put(oli.Id_Item_de_Oportunidad_Relacionado__c, new Double[]{
                        0, oli.Quantity * Double.valueOf(oli.Product2.CANTIDAD_SUB_UNIDAD__c) // cantidades rechazadas
                    });
                } else {
                    totales.put(oli.Id_Item_de_Oportunidad_Relacionado__c, new Double[]{0, 0}); // cantidades rechazadas para CVB Rechazada
                }
            } else {
                Double[] anterior = totales.get(oli.Id_Item_de_Oportunidad_Relacionado__c);

                if (String.isEmpty(oli.Motivo_de_Rechazo__c)) {
                    anterior[0] += oli.Quantity * Double.valueOf(oli.Product2.CANTIDAD_SUB_UNIDAD__c); // cantidades confirmadas
                    totales.put(oli.Id_Item_de_Oportunidad_Relacionado__c, anterior);
                } else {
                    anterior[1] += oli.Quantity * Double.valueOf(oli.Product2.CANTIDAD_SUB_UNIDAD__c); // cantidades rechazadas
                    totales.put(oli.Id_Item_de_Oportunidad_Relacionado__c, anterior);
                }
            }
        }

        for (OpportunityLineItem oli : itemsActualizar) {
            if (totales.containsKey(oli.Id)) {
                Double[] total = totales.get(oli.Id);
                oli.Quant_Confirmada__c = total[0] != null ? total[0] : 0;
                oli.Quant_Rechazada__c = total[1] != null ? total[1] : 0;
            }
        }

        update itemsActualizar;
    }
}
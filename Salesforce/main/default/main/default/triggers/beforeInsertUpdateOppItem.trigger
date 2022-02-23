trigger beforeInsertUpdateOppItem on OpportunityLineItem (before insert, before update) {
    Map<String, String> mapValores = new Map<String, String>();
    Map<String, String> mapRTOpps = new Map<String, String>();
    Map<String, OpportunityLineItem> mapItems = new Map<String, OpportunityLineItem>();
    Set<Id> oppIds = new Set<Id>();

    for (Schema.PicklistEntry ple : OpportunityLineItem.Motivo_de_Rechazo__c.getDescribe().getPicklistValues()) {
        mapValores.put(ple.getLabel().substring(0,2), ple.getLabel());
    }

    for (OpportunityLineItem oli : Trigger.new) {
        if (oli.Posicion_Relativa_Consign__c != null) {
            oli.Posicion_SAP__c = oli.Posicion_Relativa_Consign__c;
        }

        oppIds.add(oli.OpportunityId);

        if (oli.Grupo_de_Materiales_2__c == 'null') { oli.Grupo_de_Materiales_2__c = null; }
        if (oli.Motivo_de_Rechazo__c == 'null' || oli.Motivo_de_Rechazo__c == '') { oli.Motivo_de_Rechazo__c = null; }
        if (oli.Motivo_de_Rechazo__c != null ) {
            if (oli.Motivo_de_Rechazo__c.length() <= 2 && mapValores.containsKey(oli.Motivo_de_Rechazo__c.substring(0,2))) {
                oli.Motivo_de_Rechazo__c = mapValores.get(oli.Motivo_de_Rechazo__c.substring(0,2));
            }
        }
    }

    for (Opportunity opp : [SELECT Id, RecordType.Name FROM Opportunity WHERE Id IN :oppIds]) {
        mapRTOpps.put(opp.Id, opp.RecordType.Name);
    }

    if (Trigger.isInsert) {
        Boolean hayCVB = false;
        for (OpportunityLineItem oli : Trigger.new) {
            if (mapRTOpps.containsKey(oli.OpportunityId) && oli.Posicion_SAP__c != null) {
                //if (mapRTOpps.get(oli.OpportunityId) == 'CVB Autorizada' && oli.Posicion_SAP__c.right(1) == '0') {
                if (mapRTOpps.get(oli.OpportunityId) == 'CVB Autorizada') {
                    hayCVB = true;
                }
            }    
        }
    
        if (hayCVB){
            for (OpportunityLineItem oli : [SELECT Id, OpportunityId, Posicion_SAP__c, Tasas__c, Base_de_Calculo__c, Tipo_de_Necesidad__c, Tipo_de_Necessidade__c, Id_Item_de_Oportunidad_Relacionado__c, UnitPrice FROM OpportunityLineItem WHERE OpportunityId IN :oppIds]) {
                if (mapRTOpps.containsKey(oli.OpportunityId) && oli.Posicion_SAP__c != null) {
                    if (mapRTOpps.get(oli.OpportunityId) == 'CVB Autorizada' && oli.Posicion_SAP__c.right(1) == '0') {
                        mapItems.put(oli.OpportunityId + oli.Posicion_SAP__c, oli);
                    }
                }
            }
        }    

        for (OpportunityLineItem oli : Trigger.new) {
            if (mapRTOpps.containsKey(oli.OpportunityId) && oli.Posicion_SAP__c != null) {
                if (mapRTOpps.get(oli.OpportunityId) == 'CVB Autorizada' && oli.Posicion_SAP__c.right(1) != '0') {
                    Decimal pos_d = Decimal.valueOf(Integer.valueOf(oli.Posicion_SAP__c.left(5))/2*2).divide(1, 0, System.RoundingMode.DOWN);
                    Integer pos_l = String.valueOf(pos_d).length();
                    String pos;

                    if (pos_l == 1) {
                        pos = '0000' + pos_d + '0';
                    } else if (pos_l == 2) {
                        pos = '000' + pos_d + '0';
                    } else if (pos_l == 3) {
                        pos = '00' + pos_d + '0';
                    }

                    if (mapItems.containsKey(oli.OpportunityId + pos)) {
                        OpportunityLineItem itm = mapItems.get(oli.OpportunityId + pos);
                        oli.Tasas__c = itm.Tasas__c;
                        oli.Base_de_Calculo__c = itm.Base_de_Calculo__c;
                        oli.Tipo_de_Necesidad__c = itm.Tipo_de_Necesidad__c;
                        oli.Id_Item_de_Oportunidad_Relacionado__c = itm.Id_Item_de_Oportunidad_Relacionado__c;
                        oli.Tipo_de_Necessidade__c = itm.Tipo_de_Necessidade__c;
                        oli.UnitPrice = itm.UnitPrice;
                        oli.TotalPrice = null;
                    }           
                }
            }
        }               
    }

    if (Trigger.isUpdate) {
        for (OpportunityLineItem oli : Trigger.new) {
            if (mapRTOpps.containsKey(oli.OpportunityId) && oli.Posicion_SAP__c != null) {
                if (mapRTOpps.get(oli.OpportunityId) == 'CVB Autorizada') {
                    oli.UnitPrice = Trigger.oldMap.get(oli.Id).UnitPrice;
                    if (oli.Quantity != null && oli.UnitPrice != null)
                        oli.TotalPrice = oli.Quantity * oli.UnitPrice;
                }
            }
        }
    }

    BRAXUtils.actualizarContratoItem(Trigger.new);
}
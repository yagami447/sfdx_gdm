trigger afterInsertUpdateDeleteCRMVendas on CRM_Vendas__c (after delete, after insert, after update) {
            
    /*for (AggregateResult a : [Select Sum(Volume__c) Volume, Variedad__r.Sociedad__c, Cuenta__c, Safra__c From CRM_Vendas__c Where Variedad__r.Sociedad__c != null Group By Variedad__r.Sociedad__c, Cuenta__c, Safra__c]){
        CRM_Multiplicador__c m = New CRM_Multiplicador__c();
        m.Control_Registro__c = String.valueOf(a.get('Cuenta__c')) + String.valueOf(a.get('Safra__c'));
        m.Cuenta__c = String.valueof(a.get('Cuenta__c'));
        m.Safra__c = String.valueOf(a.get('Safra__c'));
        if (a.get('Sociedad__c') == 'BRMX')
            m.Ventas_BMX__c = Double.valueOf(a.get('Volume'));
        if (a.get('Sociedad__c') == 'DSEM')
            m.Ventas_DMS__c = Double.valueOf(a.get('Volume'));
        upsert m;   
    }*/

}
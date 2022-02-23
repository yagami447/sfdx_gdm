trigger beforeUpdateContrato on Contrato__c (before Update, before insert) {

    if(Trigger.new == null) return;
    
    //valida que no se modifique la cotizacion si ya tiene productos
    if(Trigger.old != null){
        for(Contrato__c c : Trigger.new){
            Contrato__c old = System.Trigger.oldMap.get(c.Id);
            if(c.Tipo_de_Cota_o__c != old.Tipo_de_Cota_o__c){
                for(Item_del_Contrato__c it: [SELECT Id FROM Item_del_Contrato__c WHERE Contrato_de_Multiplicacion__c =: c.Id])
                    c.Tipo_de_Cota_o__c.adderror('Não pode ser modificado o tipo de cotação.');
            }
        }
    }
    
    //busca y asigna el contrato marco
    for(Contrato__c ta : Trigger.new){
        String safra = ta.Safra__c;        
        if (ta.Contrato_marco__c == null)
            for(Contract contrato: [SELECT Id FROM Contract WHERE AccountId =: ta.Multiplicador__c and Sociedad__c =: ta.Sociedad__c and Safras__c includes (:safra)])
                ta.Contrato_marco__c = contrato.id;
        
        if(ta.Contrato_marco__c==null && ta.RecordType.DeveloperName=='Termo_Aditivo')
            ta.Multiplicador__c.adderror('Não pode ser criado um termo aditivo sem contrato guarda chuva.');
    }
}
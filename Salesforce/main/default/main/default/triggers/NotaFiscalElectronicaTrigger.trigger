trigger NotaFiscalElectronicaTrigger on Nota_Fiscal_Eletr_nica__c (after insert, after update, after delete) {
    if(Trigger.isAfter) {
        if(Trigger.isDelete) {          
            List<Nota_Fiscal_Eletr_nica__c> allNotasFiscalesElectronicas = [
                SELECT Id 
                FROM Nota_Fiscal_Eletr_nica__c 
                WHERE ID != NULL
            ];
            
            Set<Id> vendedoresIds = new Set<Id>(); 
            for(Nota_Fiscal_Eletr_nica__c notaFiscal : [
                SELECT Id, Vendedor__c
                FROM Nota_Fiscal_Eletr_nica__c 
                WHERE Id IN :Trigger.old 
                	AND Id NOT IN :allNotasFiscalesElectronicas 
                ALL ROWS
            ]) {
                vendedoresIds.add(notaFiscal.Vendedor__c);
            }
            
            NotaFiscalElectronicaHelper.updateVendedoresCounters(vendedoresIds);
        }
        if(Trigger.isInsert || Trigger.isUpdate) {
            Set<Id> vendedoresIds = new Set<Id>(); 
            for(Nota_Fiscal_Eletr_nica__c notaFiscal : Trigger.new) {
                vendedoresIds.add(notaFiscal.Vendedor__c);
            }
            
            NotaFiscalElectronicaHelper.updateVendedoresCounters(vendedoresIds);
        }
    }
}
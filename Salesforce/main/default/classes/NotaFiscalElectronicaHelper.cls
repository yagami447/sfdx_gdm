public class NotaFiscalElectronicaHelper {

    public static void updateVendedoresCounters(Set<Id> vendedoresIds) {
        Map<Id, Contact> vendedoresById = new Map<Id, Contact>();
        
        for(Contact vendedor : [ 
        	SELECT Id, Valor_Total_Bonificacao_DMValoriza__c, Quantidade_KG_Total_DMValoriza__c,
            	Total_NFe__c
        	FROM Contact
            WHERE Id IN :vendedoresIds
        ]) {
            // Reseteo los contadores ya que vamos a empezar a contar desde 0
            vendedor.Valor_Total_Bonificacao_DMValoriza__c = 0;
          	vendedor.Quantidade_KG_Total_DMValoriza__c = 0;
            vendedor.Total_NFe__c = 0;
            
            vendedoresById.put(vendedor.Id, vendedor);
        }
        
        if(vendedoresById.size() > 0) {
            for(Nota_Fiscal_Eletr_nica__c notaFiscal : [
                SELECT Id, Vendedor__c, Quantidade_KG_Total_NF__c, Valor_Total_Bonificacao_NF__c
                FROM Nota_Fiscal_Eletr_nica__c
                WHERE Vendedor__c IN :vendedoresIds
            ]) {
                if(vendedoresById.containsKey(notaFiscal.Vendedor__c)) {
                    Contact vendedor = vendedoresById.get(notaFiscal.Vendedor__c);
                                       
                    if(notaFiscal.Valor_Total_Bonificacao_NF__c != null) {
                        if(vendedor.Valor_Total_Bonificacao_DMValoriza__c == 0) {
                            vendedor.Valor_Total_Bonificacao_DMValoriza__c = notaFiscal.Valor_Total_Bonificacao_NF__c;
                        } else {
                            vendedor.Valor_Total_Bonificacao_DMValoriza__c += notaFiscal.Valor_Total_Bonificacao_NF__c;
                        }
                    }
                    
                    if(notaFiscal.Quantidade_KG_Total_NF__c != null) {
                        if(vendedor.Quantidade_KG_Total_DMValoriza__c == 0) {
                            vendedor.Quantidade_KG_Total_DMValoriza__c = notaFiscal.Quantidade_KG_Total_NF__c;
                        } else {
                            vendedor.Quantidade_KG_Total_DMValoriza__c += notaFiscal.Quantidade_KG_Total_NF__c;
                        }
                    }
                    
                    vendedor.Total_NFe__c++;
                    vendedoresById.put(vendedor.Id, vendedor);
                }
            }
            
            update vendedoresById.values();
        }
    }
    
}
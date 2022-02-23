public class ordemDeCompraController {
    @AuraEnabled
    public static String consultaSapController(String purchaseOrder){
        
        List<Order> existOrder = sapHistorialDePedidosSoapFunctions.CheckExistingOrder(purchaseOrder);
        
        if (!existOrder.isEmpty() && existOrder[0].Status == 'Edição') {
            return 'Já existe um pedido em edição. Ative o antigo para criar um novo.';
        }
        
        Id orderId = sapHistorialDePedidosSoapFunctions.GenerateOrder(purchaseOrder);
        
        if (!existOrder.isEmpty() && orderId != null) {
            existOrder[0].Status = 'Draft';
            existOrder[0].Pai__c = orderId;
            update existOrder;
        }
        
        return orderId;
        
    }
    
       @AuraEnabled
    public static String consultaSapControllerWithOldOrder(Id orderId){                
        
        String orderNumber = [SELECT Numero_Pedido_sap__c FROM Order WHERE Id = :orderId][0].Numero_Pedido_sap__c;       
        return consultaSapController(orderNumber);     
        
    }
    
}
@isTest(SeeAllData=true)
public class ActualizarResponsableBatchsTest {
      
     static testMethod void testBatchOpp(){
         Set<Id> idCuentas = new Set<Id>();
         Account cta = [Select Id From Account LIMIT 1];  
        if(cta != null)
            idCuentas.add(cta.Id);
        BATCH_Opp_Actualizar_Responsable bOppRC = New BATCH_Opp_Actualizar_Responsable(idCuentas);       
        Id batchId = Database.executeBatch(bOppRC, 1); 
    }
    
     static testMethod void testBatchEventos(){
         Set<Id> idCuentas = new Set<Id>();
         Account cta = [Select Id From Account LIMIT 1];  
        if(cta != null)
            idCuentas.add(cta.Id);
        BATCH_Evento_Actualizar_Responsable bEventosRC = New BATCH_Evento_Actualizar_Responsable(idCuentas);       
        Id batchId = Database.executeBatch(bEventosRC, 1); 
    }
    
    static testMethod void testBatchContratos(){
         Set<Id> idCuentas = new Set<Id>();
         Account cta = [Select Id From Account LIMIT 1];  
        if(cta != null)
            idCuentas.add(cta.Id);
        BATCH_Contrato_Actualizar_Responsable bContratosRC = New BATCH_Contrato_Actualizar_Responsable(idCuentas);       
        Id batchId = Database.executeBatch(bContratosRC, 1); 
    }
    static testMethod void ExecutarBatchableControllerTest(){
        ExecutarBatchableController exCtrl = new ExecutarBatchableController();
        exCtrl.searchKey = 'ACME';
         exCtrl.contaSeleccionada = [Select Id, Name From Account Limit 1];
        exCtrl.buscarCuentas();
        exCtrl.borrarCuentas();
        exCtrl.actualizarResponsable();
    }
}
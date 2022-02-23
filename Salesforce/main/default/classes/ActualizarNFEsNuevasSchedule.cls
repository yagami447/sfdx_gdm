global class ActualizarNFEsNuevasSchedule implements Schedulable {
    
    global void execute(SchedulableContext context) {
        Integer batchSize = 5;
        Database.executeBatch(new ActualizarNFEsNuevasBatch(), batchSize);
   }
}
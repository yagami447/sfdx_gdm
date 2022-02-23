global class Job_Docusign_Send_Envelope implements Schedulable {

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Batch_Docusign_Send_Envelope(), 1);
    }
}
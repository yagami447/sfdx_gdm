global class Job_Docusign_Approval_Process implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new Batch_Docusign_Approval_Process());
    }
}
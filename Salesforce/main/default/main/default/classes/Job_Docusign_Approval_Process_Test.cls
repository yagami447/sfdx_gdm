@isTest
public class Job_Docusign_Approval_Process_Test {
    
    static testMethod void shouldExecute() {
        Test.StartTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' ' + dt.hour() + ' ?  * * *';
        System.schedule('Job_Docusign_Approval_Process_'+System.now().millisecond(), CRON_EXP, new Job_Docusign_Approval_Process());
        Test.stopTest();
    }
}
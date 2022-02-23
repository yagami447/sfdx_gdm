@isTest
public class Job_Docusign_Send_Envelope_Test {

    static testMethod void shouldExecute() {
        Test.StartTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' ' + dt.hour() + ' ?  * * *';
        System.schedule('Job_Docusign_Send_Envelope'+System.now().millisecond(), CRON_EXP, new Job_Docusign_Send_Envelope());
        Test.stopTest();
    }
}
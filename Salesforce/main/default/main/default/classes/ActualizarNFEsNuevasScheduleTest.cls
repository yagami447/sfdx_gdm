@isTest
public class ActualizarNFEsNuevasScheduleTest {

    @isTest
    static void schedulingTest() {
        String sch = '0 0 0 30 11 ?';
        
        Test.startTest();
        String jobID = System.schedule('Actualizar Notas Fiscales Eletronicas', sch, new ActualizarNFEsNuevasSchedule());
        Test.stopTest();
        
        CronTrigger ct = [
            SELECT CronExpression, State, TimesTriggered
    		FROM CronTrigger 
            WHERE Id = :jobID
        ];
        
        System.assertEquals(sch, ct.CronExpression);
        System.assertEquals('WAITING', ct.State);
        System.assertEquals(0, ct.TimesTriggered);
    }
}
@isTest
public class Bloquear_LiberarControllerTest {
    @TestSetup
    static void makeData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.CloseDate = System.today();
        opp.StageName = 'Edición';
        insert opp;        
    }    

    @isTest
    static void liberar(){
        Opportunity opp = [SELECT ID,Name FROM Opportunity];
        String recordId = String.valueOf(opp.id);
        Approval.lock(opp.id);

        test.startTest();
        Boolean response = Bloquear_LiberarController.liberar_bloquear(recordId); //Returns true if de record was unlocked
        test.stopTest();
        
        System.assertEquals(true, response,'Return must be true because we start the test with a locked record');        
    }

    @isTest
    static void bloquear(){
        Opportunity opp = [SELECT ID,Name FROM Opportunity];
        String recordId = String.valueOf(opp.id);        

        test.startTest();
        Boolean response = Bloquear_LiberarController.liberar_bloquear(recordId); //Returns false if de record was locked
        test.stopTest();
        
        System.assertEquals(false, response,'Return must be false because we start the test with a unlocked record');        
    }
}
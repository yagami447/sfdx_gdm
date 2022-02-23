@isTest
public class ExceptionManager_Test {

    public static testMethod void shouldSaveException() {
        DmlException dmlException = new DmlException();
        dmlException.setMessage('errorMessage');
        ExceptionManager.saveException(dmlException, 'ExceptionManager_Test', 'shouldSaveException', '006000000000000000');
        GDMException__c exceptionObject = [SELECT Message__c, Class__c, Method__c, Record_Id__c, Type__c FROM GDMException__c ORDER BY CreatedDate DESC LIMIT 1];
        System.assertEquals('errorMessage', exceptionObject.Message__c);
        System.assertEquals('ExceptionManager_Test', exceptionObject.Class__c);
        System.assertEquals('shouldSaveException', exceptionObject.Method__c);
        System.assertEquals('006000000000000000', exceptionObject.Record_Id__c);
    }
    
    public static testMethod void shouldSaveMessage() {
        ExceptionManager.saveMessage('errorMessage', 'ExceptionManager_Test', 'shouldSaveMessage', '006000000000000000', 'DEBUG');
        GDMException__c exceptionObject = [SELECT Message__c, Class__c, Method__c, Record_Id__c, Type__c FROM GDMException__c ORDER BY CreatedDate DESC LIMIT 1];
        System.assertEquals('errorMessage', exceptionObject.Message__c);
        System.assertEquals('ExceptionManager_Test', exceptionObject.Class__c);
        System.assertEquals('shouldSaveMessage', exceptionObject.Method__c);
        System.assertEquals('006000000000000000', exceptionObject.Record_Id__c);
        System.assertEquals('DEBUG', exceptionObject.Type__c);
    }
}
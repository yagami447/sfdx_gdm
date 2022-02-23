public class ExceptionManager {

    public static void saveException(Exception e, String apexClass, String method, Id recordId) {
        GDMException__c exceptionObject = new GDMException__c();
        exceptionObject.Class__c = apexClass;
        exceptionObject.Method__c = method;
        exceptionObject.Record_Id__c = recordId;
        
        if(e != null) {
            exceptionObject.Line__c = e.getLineNumber();
            exceptionObject.Type__c = e.getTypeName();
            exceptionObject.Message_Long__c = e.getMessage();
            exceptionObject.StackTrace_Long__c = e.getStackTraceString();
            if(e.getStackTraceString() != null && e.getStackTraceString().length() > 255) {
                exceptionObject.StackTrace__c = e.getStackTraceString().substring(0, 254);
            } else {
                exceptionObject.StackTrace__c = e.getStackTraceString();
            }
            if(e.getMessage() != null && e.getMessage().length() > 255) {
                exceptionObject.Message__c = e.getMessage().substring(0, 254);
            } else {
                exceptionObject.Message__c = e.getMessage();
            }
        }
        
        try {
            insert exceptionObject;
        } catch (Exception insertException) {
            System.debug('Erro to save Exception' + insertException.getMessage());
        }
    }
    
    public static void saveMessage(String message, String apexClass, String method, Id recordId, String messageType) {
        GDMException__c exceptionObject = new GDMException__c();
        exceptionObject.Class__c = apexClass;
        exceptionObject.Method__c = method;
        exceptionObject.Record_Id__c = recordId;
        exceptionObject.Message_Long__c = message;
        if(message != null && message.length() > 255) {
        	exceptionObject.Message__c = message.substring(0, 254);
        } else {
        	exceptionObject.Message__c = message;
        }
        exceptionObject.Type__c = messageType;
        
        try {
            insert exceptionObject;
        } catch (Exception insertException) {
            System.debug('Erro to save Exception' + insertException.getMessage());
        }
    }
}
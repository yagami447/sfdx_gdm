public class Docusign_Config {

    public static String getValueByName(String fieldName) {
        String developerName = isProduction() ? 'PRODUCTION' : 'SANDBOX';
        Docusign_Config__mdt docusignConfigObject = [SELECT Account_Id__c, Authentication_URL__c, Certificate_Name__c, Integration_Key__c, User_Id__c FROM Docusign_Config__mdt WHERE DeveloperName = :developerName LIMIT 1];
        return ((String) docusignConfigObject.get(fieldName));

    }
    
    public static Boolean isProduction() {
        return ![SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
}
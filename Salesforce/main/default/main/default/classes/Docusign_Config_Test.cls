@isTest
public class Docusign_Config_Test {

    public static testmethod void shouldGetValueByName() {
        System.assertEquals(Docusign_Config.isProduction() ? 'account.docusign.com' : 'account-d.docusign.com', Docusign_Config.getValueByName('Authentication_URL__c'));
    }
}
@isTest
public class JWT_Test {

    static testMethod void shouldIssueToken(){
        JWT jwtObject = new JWT('RS256');
        
        jwtObject.iss = Docusign_Config.getValueByName('Integration_Key__c');
        jwtObject.sub = Docusign_Config.getValueByName('User_Id__c');
        jwtObject.aud = Docusign_Config.getValueByName('Authentication_URL__c');
        jwtObject.scope = 'signature';
        jwtObject.cert = Docusign_Config.getValueByName('Certificate_Name__c');
        
		String token = jwtObject.issue();
        System.assert(token != null);
        System.debug(token);
    }
}
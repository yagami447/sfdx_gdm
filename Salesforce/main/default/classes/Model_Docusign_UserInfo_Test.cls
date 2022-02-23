@isTest
public class Model_Docusign_UserInfo_Test {
    
    public static String TEST_BODY = '{"accounts":[{"base_uri":"https://domain.example.com","account_id":"a4ec37d6-xxxx-xxxx-xxxx-143885c220e1"}]}';
        
    public static testmethod void shouldDeserialize() {
        Model_Docusign_UserInfo model = (Model_Docusign_UserInfo) JSON.deserialize(TEST_BODY, Model_Docusign_UserInfo.class);
		System.assertEquals('https://domain.example.com', model.accounts.get(0).base_uri);
        System.assertEquals('a4ec37d6-xxxx-xxxx-xxxx-143885c220e1', model.accounts.get(0).account_id);
    }
    
    public static testmethod void shouldSerialize() {
        List<Model_Docusign_UserInfo.Account> accounts = new List<Model_Docusign_UserInfo.Account>();
        Model_Docusign_UserInfo.Account account = new Model_Docusign_UserInfo.Account();
        account.account_id = 'a4ec37d6-xxxx-xxxx-xxxx-143885c220e1';
        account.base_uri = 'https://domain.example.com';
        accounts.add(account);
        
        Model_Docusign_UserInfo model = new Model_Docusign_UserInfo();
        model.accounts = accounts;
        
        System.assertEquals(TEST_BODY, JSON.serialize(model));
    }
    
    public static testmethod void shouldGetBaseUrlByAccountId() {
        List<Model_Docusign_UserInfo.Account> accounts = new List<Model_Docusign_UserInfo.Account>();
        Model_Docusign_UserInfo.Account account = new Model_Docusign_UserInfo.Account();
        account.base_uri = 'https://domain.example.com';
        account.account_id = 'a4ec37d6-xxxx-xxxx-xxxx-143885c220e1';
        accounts.add(account);
        
        Model_Docusign_UserInfo model = new Model_Docusign_UserInfo();
        model.accounts = accounts;
        
        System.assertEquals('https://domain.example.com', Model_Docusign_UserInfo.getBaseUrlByAccountId(model, 'a4ec37d6-xxxx-xxxx-xxxx-143885c220e1'));
    }
}
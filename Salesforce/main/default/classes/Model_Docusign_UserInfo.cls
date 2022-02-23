public class Model_Docusign_UserInfo {

    public List<Account> accounts {get; set;} 
        
    public class Account {
        public String account_id {get; set;}
        public String base_uri {get; set;}
    }
    
    public static String getBaseUrlByAccountId(Model_Docusign_UserInfo userInfoObject, String accountId){
        for(Account account : userInfoObject.accounts) {
            if(account.account_id == accountId) {
                return account.base_uri;
            }
        }
        return 'null';
    }
}
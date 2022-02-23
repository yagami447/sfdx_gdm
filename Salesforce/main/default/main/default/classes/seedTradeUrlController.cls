public class seedTradeUrlController {
    @AuraEnabled 
    public static String fetchUserAccountId(){
        User u = [select id,Name,ContactId from User where id =: userInfo.getUserId()]; 
        
        Contact ctc;
        if (!Test.isRunningTest()){
            ctc = [SELECT id,Name,AccountId FROM Contact WHERE id =: u.ContactId];       
        }else{
            Account acc = [SELECT ID,Name FROM Account WHERE Name = 'Acc testing'];            
            ctc = new Contact(AccountId= acc.id,lastName='Testing Contact');  
        }      
               
        
        String myId = String.valueOf(ctc.AccountId);
		String result = myId.substring(0,15);
        return result;
    }
}
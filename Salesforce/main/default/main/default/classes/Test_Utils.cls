@isTest
public class Test_Utils {

    private static Test_Utils testUtils;
    
    public static Test_Utils getInstance(){
        if (testUtils == null){
            testUtils = new Test_Utils();
        }
        return testUtils;
    }
    
    public Account createNewAccount(Account accountObject){
        if(accountObject == null) {
            accountObject = new Account();
        }
        if(accountObject.Nome_fantasia__c == null) { accountObject.Nome_fantasia__c = 'FantasiaTest';}
        if(accountObject.Name == null) { accountObject.Name = 'AccountTest';}
        return accountObject;
    }
    
    public User createNewDiretorComercial(User userObject) {
        if(userObject == null) {
            userObject = new User();
        }
        User userBase = [SELECT CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, LanguageLocaleKey FROM User LIMIT 1];
        Profile profileDiretorObject = [SELECT Id FROM Profile WHERE Name = 'Solo Lectura Custom' LIMIT 1];
        
        userObject.ProfileId = profileDiretorObject.Id;
        if(userObject.FirstName == null) { userObject.FirstName = 'Diretor'; }
        if(userObject.LastName == null) { userObject.LastName = 'Comercial'; }
        if(userObject.Email == null) { userObject.Email = 'teste3@email.com.br'; }
        if(userObject.Username == null) { userObject.Username = 'diretor'+System.now().millisecond()+'@comercial.com'; }
        if(userObject.Alias == null) { userObject.Alias = 'pdftes'; }
        if(userObject.CommunityNickname == null) { userObject.CommunityNickname = 'nicknamegerente'+System.now().millisecond(); }
        if(userObject.TimeZoneSidKey == null) { userObject.TimeZoneSidKey = userBase.TimeZoneSidKey; }
        if(userObject.LocaleSidKey == null) { userObject.LocaleSidKey = userBase.LocaleSidKey; }
        if(userObject.EmailEncodingKey == null) { userObject.EmailEncodingKey = userBase.EmailEncodingKey; }
        if(userObject.LanguageLocaleKey == null) { userObject.LanguageLocaleKey = userBase.LanguageLocaleKey; }
        return userObject;
    }
    
    public User createNewUserGerente(User userObject){
        if(userObject == null) {
            userObject = new User();
        }
        User userBase = [SELECT CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, LanguageLocaleKey FROM User LIMIT 1];
        Profile profileGerenteObject = [SELECT Id FROM Profile WHERE Name = 'Gerente LE' LIMIT 1];
        
		if(userObject.ManagerId == null) { 
            User diretorComercial = createNewDiretorComercial(null);
            insert diretorComercial;
            userObject.ManagerId = diretorComercial.Id;
        }
        if(userObject.FirstName == null) { userObject.FirstName = 'Gerente'; }
        if(userObject.LastName == null) { userObject.LastName = 'Test'; }
        if(userObject.Email == null) { userObject.Email = 'teste@email.com.br'; }
        userObject.ProfileId = profileGerenteObject.Id;
        if(userObject.Username == null) { userObject.Username = 'gerente'+System.now().millisecond()+'@comercial.com'; }
        if(userObject.Alias == null) { userObject.Alias = 'pdftes'; }
        if(userObject.CommunityNickname == null) { userObject.CommunityNickname = 'nicknamegerente'+System.now().millisecond(); }
        if(userObject.TimeZoneSidKey == null) { userObject.TimeZoneSidKey = userBase.TimeZoneSidKey; }
        if(userObject.LocaleSidKey == null) { userObject.LocaleSidKey = userBase.LocaleSidKey; }
        if(userObject.EmailEncodingKey == null) { userObject.EmailEncodingKey = userBase.EmailEncodingKey; }
        if(userObject.LanguageLocaleKey == null) { userObject.LanguageLocaleKey = userBase.LanguageLocaleKey; }
        return userObject;
    }
    
    public User createNewUserSupervisor(User userObject){
        if(userObject == null) {
            userObject = new User();
        }
        User userBase = [SELECT CommunityNickname, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, LanguageLocaleKey FROM User LIMIT 1];
        Profile profileSupervisorObject = [SELECT Id FROM Profile WHERE Name = 'Comercial LE' LIMIT 1];
        
        if(userObject.FirstName == null) { userObject.FirstName = 'Supervisor'; }
        if(userObject.LastName == null) { userObject.LastName = 'Test'; }
        if(userObject.Email == null) { userObject.Email = 'testes@email.com.br'; }
        userObject.ProfileId = profileSupervisorObject.Id;
        if(userObject.Username == null) { userObject.Username = 'supervisor'+System.now().millisecond()+'@comercial.com'; }
        if(userObject.Alias == null) { userObject.Alias = 'pdftest'; }
        if(userObject.CommunityNickname == null) { userObject.CommunityNickname = 'nicknamesupervisor'+System.now().millisecond(); }
        if(userObject.TimeZoneSidKey == null) { userObject.TimeZoneSidKey = userBase.TimeZoneSidKey; }
        if(userObject.LocaleSidKey == null) { userObject.LocaleSidKey = userBase.LocaleSidKey; }
        if(userObject.EmailEncodingKey == null) { userObject.EmailEncodingKey = userBase.EmailEncodingKey; }
        if(userObject.LanguageLocaleKey == null) { userObject.LanguageLocaleKey = userBase.LanguageLocaleKey; }
        if(userObject.ManagerId == null) {
            User userGerenteObject = createNewUserGerente(null);
        	insert userGerenteObject;
            userObject.ManagerId = userGerenteObject.Id;
        }
        return userObject;
    }
    
    public Opportunity createNewOpportunityAnexo2(Opportunity opportunityObject) {
        if(opportunityObject == null) {
            opportunityObject = new Opportunity();
        }
        RecordType rtAnexo2Object = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Anexo II' LIMIT 1];
        
        opportunityObject.RecordTypeId = rtAnexo2Object.Id;
        if(opportunityObject.StageName == null) { opportunityObject.StageName = 'Pendiente de Análisis'; }
        if(opportunityObject.Name == null) { opportunityObject.Name = 'OppTeste'; }
        if(opportunityObject.Marca__c == null) { opportunityObject.Marca__c = 'MarcaTeste'; }
        if(opportunityObject.AccountId == null) { 
            Account accountObject = createNewAccount(null);
            insert accountObject;
            opportunityObject.AccountId = accountObject.Id; 
        }
        if(opportunityObject.OwnerId == null) { 
            User userObject = createNewUserGerente(null);
            userObject.CommunityNickname = 'UserAnexo2';
            userObject.Username = 'aaaewasdaeerfrf@gmail.com';
            insert userObject;
            opportunityObject.OwnerId = userObject.Id; 
        }
        if(opportunityObject.CloseDate == null) { opportunityObject.CloseDate = System.today(); }
        return opportunityObject;
    }
    
    public Opportunity createNewOpportunityAnexo2RebajaSupervisorOrGerente(Opportunity opportunityObject, String ownerUser) {
        if(opportunityObject == null) {
            opportunityObject = new Opportunity();
        }
        RecordType rtRebObject = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Anexo II Rebaixamento Sacas' LIMIT 1];
        
        opportunityObject.RecordTypeId = rtRebObject.Id;
        if(opportunityObject.StageName == null) { opportunityObject.StageName = 'Pendiente de Análisis'; }
        if(opportunityObject.Name  == null) { opportunityObject.Name = 'OppTest'; }
        if(opportunityObject.Marca__c == null) { opportunityObject.Marca__c = 'MarcaTest'; }
        if(opportunityObject.AccountId == null) { 
            Account accountObject = createNewAccount(null);
            insert accountObject;
            opportunityObject.AccountId = accountObject.Id; 
        }
        if(opportunityObject.OwnerId == null) {
            User userObject;
            if(ownerUser == 'Supervisor') {
                userObject = createNewUserSupervisor(null);
            } else {
            	userObject=createNewUserGerente(null);
            }
            insert userObject;
            opportunityObject.OwnerId = userObject.Id; 
        }
        if(opportunityObject.Anexo_Relacionado__c == null) { 
            Opportunity opportunityBaseObject = createNewOpportunityAnexo2(null);
            insert opportunityBaseObject;
            opportunityObject.Anexo_Relacionado__c = opportunityBaseObject.Id; 
        }
        if(opportunityObject.CloseDate == null) { opportunityObject.CloseDate = System.today(); }
        return opportunityObject;
    }
    
    public Contract createNewContract(Contract contractObject, Account accountObject) {
        if(contractObject == null) {
            contractObject = new Contract();
        }
        if(accountObject == null) {
            accountObject = createNewAccount(null);
        }
        if(accountObject.Id == null) {
            insert accountObject;
        }
        if(contractObject.AccountId == null) { contractObject.AccountId = accountObject.Id; }
        if(contractObject.Status == null) { contractObject.Status = 'Edição'; }
        if(contractObject.Safras__c == null) { 
            Integer actualYear = System.today().year();
            contractObject.Safras__c = String.valueOf(actualYear).right(2)+'/'+String.valueOf(actualYear+1).right(2); 
        }
        if(contractObject.Sociedad__c == null) { contractObject.Sociedad__c = 'BRMX'; }
        return contractObject;
    }
    
    public Contrato__c createNewContratoMultiplicacao(Contrato__c contratoMultiplicacaoObject, Account accountObject, Contract contractObject, User userObject) {
        if(contratoMultiplicacaoObject == null) {
            contratoMultiplicacaoObject = new Contrato__c();
        }
        if(accountObject == null) {
            accountObject = createNewAccount(null);
        }
        if(accountObject.Id == null) {
            insert accountObject;
        }
        if(contractObject == null) {
            contractObject = createNewContract(null, accountObject);
        }
        if(contractObject.Id == null) {
            insert contractObject;
        }
        if(userObject == null) {
            userObject = createNewUserSupervisor(null);
        }
        if(userObject.Id == null) {
            insert userObject;
        }
        if(contratoMultiplicacaoObject.OwnerId == null) { contratoMultiplicacaoObject.OwnerId = userObject.Id; }
        if(contratoMultiplicacaoObject.Multiplicador__c == null) { contratoMultiplicacaoObject.Multiplicador__c = accountObject.Id; }
        if(contratoMultiplicacaoObject.Safra__c == null) { 
            Integer actualYear = System.today().year();
            contratoMultiplicacaoObject.Safra__c = String.valueOf(actualYear).right(2)+'/'+String.valueOf(actualYear+1).right(2); 
        }
        if(contratoMultiplicacaoObject.Sociedad__c == null) { contratoMultiplicacaoObject.Sociedad__c = 'BRMX'; }
        if(contratoMultiplicacaoObject.Region_Comercial__c == null) { contratoMultiplicacaoObject.Region_Comercial__c = 'CERRADO'; }
        if(contratoMultiplicacaoObject.Estados_Comercializacao__c == null) { contratoMultiplicacaoObject.Estados_Comercializacao__c = 'SP'; }
        if(contratoMultiplicacaoObject.Estado__c == null) { contratoMultiplicacaoObject.Estado__c = 'Edição'; }
        if(contratoMultiplicacaoObject.Contrato_marco__c == null) { contratoMultiplicacaoObject.Contrato_marco__c = contractObject.Id; }  
        if(contratoMultiplicacaoObject.RecordTypeId == null) { contratoMultiplicacaoObject.RecordTypeId = Contrato__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Termo Aditivo Comerciais').getRecordTypeId(); }
        return contratoMultiplicacaoObject;
    }
}
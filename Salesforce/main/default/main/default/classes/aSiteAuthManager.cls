public without sharing class aSiteAuthManager {
    
    public aSiteAuthManager() {
    }

    public static SiteUser__c UserLogin(String us, String pass){

        SiteUser__c[] users = aSiteUtils.queryResults3(SiteUser__c.SObjectType, null, 'Password__c = :v1', pass, 'Email__c = :v2',us, 'Active__c = :v3', true);
        if(users.size() > 0)
            return users[0];
        else
            return null;
    }    
    
    public static Account getActiveAccount_byUser(SiteUser__c user){

        SiteUserAccount__c usacc = aSiteAuthManager.VerifyActiveAccount(user);
        Account[] accs = aSiteUtils.queryResults1(Account.SObjectType, null, 'Id = :v1', usacc.Account__c);        
        if(accs.size() > 0)
            return accs[0];
        else
            return null;
    }
    
    public static List<SiteUserAccount__c> getUserAccounts_byUser(SiteUser__c user){
        String queryPlus;            
        queryPlus = 'Account__r.Site, Account__r.AccountNumber, Account__r.Grupo_de_cuentas__c, Account__r.Name, Account__r.Nome_Fantasia__c, Account__r.CodigoSAP__c, Account__r.BillingCountry ';

        List<SiteUserAccount__c> lista = new List<SiteUserAccount__c>();
        SiteUserAccount__c[] lusers = aSiteUtils.queryResults1(SiteUserAccount__c.SObjectType, queryPlus,'SiteUser__c = :v1', user.Id);
            
        return lusers;       
    }

    public static SiteUserAccount__c VerifyActiveAccount(SiteUser__c user){
        try{
            List<SiteUserAccount__c> lista = new List<SiteUserAccount__c>();            
            lista = aSiteAuthManager.getUserAccounts_byUser(user);
            for (SiteUserAccount__c acc : lista){
                if(acc.Active__c)
                    return acc;
            }
            return null;
        }
        catch(Exception ex){
            return null;    
        }
    }

    public static SiteUserSession__c getUserSession(String token){
        try{

            SiteUserSession__c userSess = new SiteUserSession__c();
            String plus = ', SiteUser__r.Email__c, SiteUser__r.Password__c '+
                          ', SiteUser__r.Site__c, SiteUser__r.Address__c '+
                          ', SiteUser__r.Occupation__c, SiteUser__r.Name '+
                          ', SiteUser__r.Phone__c, SiteUser__r.MobilePhone__c '+
                          ', SiteUser__r.Habilitado_Votacion_DSEM__c '+
                          ', SiteUser__r.Habilitado_Anexos__c '+
                          ', SiteUser__r.Habilitado_Eventos__c '+
                          ', SiteUser__r.Habilitar_Royalty__c '+
                          ', SiteUser__r.ativar_conta_corrente__c '+
                          ', SiteUser__r.Habilitar_Venda_de_Basica__c';
            SiteUserSession__c[] ss = Database.query(aSiteUtils.querySelect(SiteUserSession__c.SObjectType) + plus + ' from SiteUserSession__c where Id = :token and valid_session__c = true order by LastModifiedDate desc limit 1');

            //SiteUserSession__c[] ss = [Select Id, Marca__c, Safra__c, SiteUser__c, Name,
            //SiteUser__r.Email__c, SiteUser__r.Password__c, SiteUser__r.Site__c, SiteUser__r.Address__c, SiteUser__r.Occupation__c, SiteUser__r.Name 
            //FROM SiteUserSession__c where Id = :token and valid_session__c = true order by LastModifiedDate desc limit 1];
            
            if(ss.size() > 0)
                return ss[0];
            else
                return null;
        }
        catch(Exception ex){
            return null;    
        }
    }

    public static SiteUser__c VerifyUserSession(String token){
        try{

            SiteUserSession__c userSess = getUserSession(token);
            if(userSess==null)
                return null;

            SiteUser__c user = new SiteUser__c(Name=userSess.SiteUser__r.Name,Email__c=userSess.SiteUser__r.Email__c,Password__c=userSess.SiteUser__r.Password__c);
            user.Site__c = userSess.SiteUser__r.Site__c;
            user.Address__c = userSess.SiteUser__r.Address__c;
            user.Occupation__c = userSess.SiteUser__r.Occupation__c;
            user.Phone__c = userSess.SiteUser__r.Phone__c;
            user.MobilePhone__c = userSess.SiteUser__r.MobilePhone__c;
            user.Habilitado_Votacion_DSEM__c = userSess.SiteUser__r.Habilitado_Votacion_DSEM__c;
            user.Habilitado_Anexos__c = userSess.SiteUser__r.Habilitado_Anexos__c;
            user.Habilitado_Eventos__c = userSess.SiteUser__r.Habilitado_Eventos__c;
            user.Habilitar_Royalty__c = userSess.SiteUser__r.Habilitar_Royalty__c;
            user.Habilitar_Venda_de_Basica__c = userSess.SiteUser__r.Habilitar_Venda_de_Basica__c;
            user.Id = userSess.SiteUser__c;

            return user;
        }
        catch(Exception ex){
            return null;    
        }
    }
    
    public static String OpenUserSession(String userId, String ip, String company){
        try{
            SiteUserSession__c s = new SiteUserSession__c();
            //buscar si vale la pena traer una session valida
            s.SiteUser__c = userId;
            if(company==null) company = 'BRMX';
            s.Safra__c = '15/16';  //traer la campaña de alguna configuracion
            s.Marca__c = company;
            s.IP__c = ip;
            insert s;
            return s.Id;
        }
        catch(Exception ex){
            return null;    
        }
    }
    
    public static String RefreshUserSession(String token){
        try{
            SiteUserSession__c userSess = getUserSession(token);
            if(userSess==null)
                return null;

            update userSess;

            return userSess.Id;
        }
        catch(Exception ex){
            return null;    
        }
    
    }
    
    public static String CloseUserSession(String token){
        try{
            SiteUserSession__c userSess = new SiteUserSession__c();
            //SiteUserSession__c[] ss = [Select Id, Close_Time__c From SiteUserSession__c where Id = :token limit 1];
            SiteUserSession__c[] ss = aSiteUtils.queryResults1(SiteUserSession__c.SObjectType, null, 'Id = :v1', token);            
            if(ss.size() > 0)
                userSess = ss[0];
            else
                return 'No active session. Token=' + token;
            
            userSess.Close_Time__c = system.now();           
            update userSess;
            return 'Ok';
        }
        catch(Exception ex){
            return ex.getMessage();
        }
    }
    
    public static aSiteUtils.retorno ForgotPassword(String us){
        SiteUser__c user;
        SiteUser__c[] users = aSiteUtils.queryResults1(SiteUser__c.SObjectType, null, 'Email__c = :v1', us);
        Configuracion_BMX__c[] conf = aSiteUtils.queryResults1(Configuracion_BMX__c.SObjectType, null, 'Id != :v1', null);
        aSiteUtils.retorno ret = New aSiteUtils.retorno();
                
        Savepoint sp;
        
        try{
            sp = Database.setSavepoint();
            if(users.size() > 0){
                user = users[0];
                user.Password__c = string.valueof(Math.abs(Crypto.getRandomLong())).substring(0,5);
                user.Cadastro_pela_primeira_vez__c = false;
                update user;
            
                String templateId = conf[0].PM_Template_Forgot_Password__c;
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setTemplateId(templateId);
                message.setWhatId(user.Id);
                message.setCcAddresses(new String[]{user.Email__c});
                message.setTargetObjectId(conf[0].PM_Contact_Send_Email__c);   
                message.setOrgWideEmailAddressId(conf[0].PM_Email_Sender__c);    
                message.setSaveAsActivity(false);
                if (!Test.isRunningTest())
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
            }else{
                ret.mensaje = Label.Unknown_User;
                ret.exito = false;
                return ret;
            }
         }catch(Exception e){
            Database.rollback(sp);            
            ret.mensaje = Label.Recover_Password_Error;
            ret.exito = false;
            return ret;
        }
            
        ret.exito = true;
           
        return ret;
    }

    public static boolean ChangePassword(String token, String newPassword, String verifyNewPassword, String oldpassword){
        
        SiteUser__c us = VerifyUserSession(token);
        if(us==null)        
            return false;

        if(us.Password__c != oldpassword)
            return false;
            
        try{
            us.Password__c = newPassword;
            us.Cadastro_pela_primeira_vez__c = true;
            update us;
        }
        catch(Exception ex){
            return false;
        }
            
        return true;
    }
    
    public static String getMarcaBySession(String token){
        try{

            SiteUserSession__c userSess = new SiteUserSession__c();            
            SiteUserSession__c[] ss = Database.query(aSiteUtils.querySelect(SiteUserSession__c.SObjectType) + ' from SiteUserSession__c where Id = :token order by LastModifiedDate desc limit 1');
            
            if(ss.size() > 0)
                return ss[0].Marca__c;
            else
                return null;
        }
        catch(Exception ex){
            return null;    
        }
    }

  }
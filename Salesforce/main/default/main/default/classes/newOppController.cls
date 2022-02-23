public class newOppController {

    public newOppController(ApexPages.StandardController controller){  
    }
    public newOppController(){        
    }
    
    public Integer getFull(){
        Integer acceso = 0; // 0 es full access
        Profile pr = [SELECT Id, Name FROM Profile WHERE Id =: Userinfo.getProfileId() limit 1];
        UserRole ur = [SELECT Id, Name FROM UserRole WHERE Id =: Userinfo.getUserRoleId() limit 1];
        if(ur.Name.contains('Comercial')) acceso = 1;
        if(ur.Name.contains('Producción')) acceso = 2;
        if(ur.Name.contains('Gerente Cerrados')) acceso = 3;
        if(ur.Name.contains('Gerente Regiao 1')) acceso = 4;
        if(ur.Name.contains('Gerente Regiao 2')) acceso = 5;
        if(ur.Name.contains('Desarrollo')) acceso = 6;
        //if(UserInfo.getUserName() == 'marcelo@brasmaxgenetica.com.br') acceso = 5;
        return acceso;
    }
    
    public PageReference redirectNewOpp(){
    
        String theme = UserInfo.getUiThemeDisplayed();
        if(theme == 'Theme3'){  //Classic
            PageReference mainHome = Page.nueva_Opp; 
            mainHome.setRedirect(true);
            return mainHome;    
        }
        return null;
    }
    
    public PageReference nuevaOpp (){
        Map<Id, String> usuarios = New Map<Id, String>();
        String tipo = ApexPages.currentPage().getParameters().get('tipo_opp');
        RecordType rt = [Select Id From RecordType Where Name = : tipo And SObjectType = 'Opportunity' limit 1];
        User usuario = [SELECT Id, Username, Name, Email, IsActive, UserRoleId, UserRole.Name, ProfileId, Profile.Name FROM User WHERE Id =: Userinfo.getUserId()]; 
                
        PageReference pr = new PageReference('/006/e');
        pr.getParameters().put('RecordType', String.valueOf(rt.Id));
        if(tipo=='Previsao' || tipo=='Stock Multiplicadores'){
            pr.getParameters().put('opp3', 'NOVO');
            pr.getParameters().put('opp11', 'Aberta');
            if(tipo=='Previsao'){
                pr.getParameters().put('00N40000002I4n8', 'BRMX');
                if(usuario.UserRole.Name == 'Comercial R1 DSEM' || usuario.UserRole.Name == 'Comercial R2 DSEM') pr.getParameters().put('00N40000002I4n8', 'DSEM');
            }
        }
        if(tipo.contains('Anexo') || tipo=='Reembalaje'){
            pr.getParameters().put('opp3', 'NOVO');
            pr.getParameters().put('opp11', 'Edición');
        }
        if(tipo=='Exportacion' || tipo=='Objetivo Ventas Semilla' || tipo=='Objetivo Ventas Royalties' || tipo=='Objetivo Contrato Royalties'){
            pr.getParameters().put('opp11', 'Aprobada');
            pr.getParameters().put('opp3', 'NOVO');
        }

        if(tipo=='PB-Comercial' || tipo=='PB-Produccion' || tipo=='PB-Desarrollo' || tipo=='PB-Oferta'){
            
            if(tipo=='PB-Comercial'){
                if(usuario.UserRole.Name == 'Gerente Cerrados')
                    pr.getParameters().put('00Nf0000000LKeS', 'CERRADO');
                if(usuario.UserRole.Name == 'Gerente Regiao 1'){
                    pr.getParameters().put('00Nf0000000LKeS', 'REGION 1');
                    pr.getParameters().put('00N40000002I4n8', 'BRMX');
                }
                if(usuario.UserRole.Name == 'Gerente Regiao 2'){
                    pr.getParameters().put('00Nf0000000LKeS', 'REGION 2');
                    pr.getParameters().put('00N40000002I4n8', 'BRMX');
                }
            }
            pr.getParameters().put('opp3', 'NOVO');
            pr.getParameters().put('opp9', System.today().format());
            pr.getParameters().put('opp11', 'PB-Pendiente');
        }
        //if(tipo=='PB-Produccion') pr.getParameters().put('opp11', 'PB-Aprobada'); 
        pr.getParameters().put('nooverride', '1');      
        return pr.setRedirect(true);
                
    }
    
}
public class newCRMEventoController {

    public newCRMEventoController(ApexPages.StandardController controller){  
    }
    public newCRMEventoController(){        
    }

    public PageReference redirectNewEvento(){
    
        // && !'Administrador'.equals(p.name)
    
//        Profile p = [select name from Profile where id = :UserInfo.getProfileId()];
//        if (!'Comercial BRMX LE'.equals(p.name)){
//            PageReference mainHome = new PageReference('/'+CRM_Calendario_de_Eventos__c.sobjecttype.getDescribe().getKeyPrefix()+'/o');            
//            mainHome.setRedirect(true);
//            return mainHome;
//        }
//        else
            return null;
    }
 
    public PageReference nuevoEvento (){
        Map<Id, String> usuarios = New Map<Id, String>();
        String tipo = ApexPages.currentPage().getParameters().get('tipo_crm');
        //User usuario = [SELECT Id, Username, Name, Email, IsActive, UserRoleId, UserRole.Name, ProfileId, Profile.Name FROM User WHERE Id =: Userinfo.getUserId()]; 
                
        PageReference pr = new PageReference('/'+CRM_Calendario_de_Eventos__c.sobjecttype.getDescribe().getKeyPrefix()+'/e');
        pr.getParameters().put('nooverride', '1');
        
        //if(tipo=='palestra'){
        //    pr.getParameters().put('opp3', 'NOVO');
        //    pr.getParameters().put('opp11', 'Aberta');
        //}
        
        //if(tipo=='dia_de_campo'){
//            pr.getParameters().put('00N40000002I4n8', 'BRMX');
        ////    pr.getParameters().put('00N40000002HxsD', 'Día de Campo');
        //    pr.getParameters().put('Name', 'Día de Campo');
        //    
//            if(usuario.UserRole.Name == 'Comercial R1 DSEM' || usuario.UserRole.Name == 'Comercial R2 DSEM') pr.getParameters().put('00N40000002I4n8', 'DSEM');
        //}        
        
        return pr.setRedirect(true);        
    }
    
}
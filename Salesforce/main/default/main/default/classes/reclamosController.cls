global without sharing class reclamosController {       

    WebService static String Asignar(Id caseId, Id userId){
        Map<Integer, String> usuarios = New Map<Integer, Id>();
        CaseTeamMember contactoTM = new CaseTeamMember();
        CaseTeamMember respTM = new CaseTeamMember();
        CaseTeamMember gerTM = new CaseTeamMember();
        CaseTeamMember respTM2 = new CaseTeamMember();
        CaseTeamMember gerTM2 = new CaseTeamMember();
        CaseTeamMember adminTM = new CaseTeamMember();
        CaseTeamMember respMarcaTM = new CaseTeamMember();
        Map<String,Id> MapRol = new Map<String,Id>();
        for(CaseTeamRole tmpRole :[SELECT Id, Name FROM CaseTeamRole] )
            MapRol.put(tmpRole.Name, tmpRole.Id);
        
        for (User u : [Select Id, Codigo_SAP__c, Name From User Where isActive = true]){  
            if (u.Codigo_SAP__c != null) usuarios.put(Integer.valueOf(u.Codigo_SAP__c), String.valueOf(u.Id));
        }
        
        Id IdRolGer = MapRol.get('Función Gerente Comercial');
        Id IdRolResp = MapRol.get('Función Responsable Reclamo');
        Id IdRolRespAten = MapRol.get('Función Responsable Atendimento');
        Id IdRolAdministrativo = MapRol.get('Función Administrativo');
        Id IdRolRespMarca = MapRol.get('Función Responsable Marca');
        Case casoAsignado = [SELECT Id, Responsavel__c, Responsavel_pelo_atendimento__c, Responsavel_pelo_atendimento__r.DelegatedApproverId, OwnerId, RecordType.Name, Marca__c FROM Case WHERE Id = :caseId];
        User gestorDelProp = [Select Id, DelegatedApproverId From User Where Id = : casoAsignado.OwnerId];
        
        Id IdUser = gestorDelProp.DelegatedApproverId;
        
        validarMiembro(caseId, IdUser);
        gerTM.ParentId = caseId;
        //gerTM.MemberId = userId;
        gerTM.MemberId = IdUser;
        gerTM.TeamRoleId = IdRolGer;
        
        insert gerTM;                
        
        String bandera = 'false';
        
        //if(usuarios.ContainsKey(Integer.valueOf(casoAsignado.Responsavel__c.split('-')[0].trim())) && bandera == 'false'){
        if(casoAsignado.OwnerId != null && bandera == 'false'){
            IdUser = casoAsignado.OwnerId;
            
            validarMiembro(caseId, IdUser);
            respTM.ParentId = caseId;
            respTM.MemberId = IdUser;
            respTM.TeamRoleId = IdRolResp;
        
            insert respTM;
        }
        
        if (casoAsignado.Responsavel_pelo_atendimento__c != null){
            IdUser = casoAsignado.Responsavel_pelo_atendimento__c;
            validarMiembro(caseId, IdUser);
            respTM2.ParentId = caseId;
            respTM2.MemberId = IdUser;
            respTM2.TeamRoleId = IdRolRespAten;
            
            insert respTM2;
            
        }
        
        if (casoAsignado.Responsavel_pelo_atendimento__r.DelegatedApproverId != null){
            IdUser = casoAsignado.Responsavel_pelo_atendimento__r.DelegatedApproverId;
            validarMiembro(caseId, IdUser);
            gerTM2.ParentId = caseId;
            gerTM2.MemberId = IdUser;
            gerTM2.TeamRoleId = IdRolGer;
            
            insert gerTM2;
            
        }
        
        if (casoAsignado.RecordType.Name == 'Fiscalização'){
            IdUser = '0050b000005ZSPc';
            //IdUser = '00540000000zlzO';
            validarMiembro(caseId, IdUser);
            adminTM.ParentId = caseId;
            adminTM.MemberId = IdUser;
            adminTM.TeamRoleId = IdRolAdministrativo;
            
            insert adminTM;
            
            if (![SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox){
              //Alteração feita por Sergio Migueis - k2 autorizada por Celso
              if (casoAsignado.Marca__c == 'BRMX'){
                IdUser = '0050b0000034jUG';
                validarMiembro(caseId, IdUser);
                respMarcaTM.ParentId = caseId;
                respMarcaTM.MemberId = IdUser;
                respMarcaTM.TeamRoleId = IdRolRespMarca;
              }              
              if (casoAsignado.Marca__c == 'DSEM'){
                IdUser = '0050b000004Xqai';
                validarMiembro(caseId, IdUser);
                respMarcaTM.ParentId = caseId;
                respMarcaTM.MemberId = IdUser;
                respMarcaTM.TeamRoleId = IdRolRespMarca;
                }
                if (casoAsignado.Marca__c == 'NEOG'){
                IdUser = '0055a000007lsqH';
                validarMiembro(caseId, IdUser);
                respMarcaTM.ParentId = caseId;
                respMarcaTM.MemberId = IdUser;
                respMarcaTM.TeamRoleId = IdRolRespMarca;
              }
              insert respMarcaTM;
            }
            
        }
        
        return 'true';
        
    }
        
/*        
        
        if(casoAsignado.Responsable__c == 'Com. BMX 5 - Tiago Goulart' && bandera == 'false'){
            try{
                Contact Contacto = [SELECT Id FROM Contact WHERE Usuario_Reclamos__c = 'Tiago Goulart' limit 1];
                Id IdContact = Contacto.Id;
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Antonio Paiva' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                validarMiembro(caseId, IdContact);
                
                contactoTM.ParentId = caseId;
                contactoTM.MemberId = IdContact;
                contactoTM.TeamRoleId = IdRolResp;
                
                insert contactoTM;
                
                bandera = 'true';
            }catch(exception e){}
        }
        if(casoAsignado.Responsable__c == 'Com. DSEM - Charles C. Pinto' && bandera == 'false'){
            try{
                Contact Contacto = [SELECT Id FROM Contact WHERE Usuario_Reclamos__c = 'Charles C. Pinto' limit 1];
                Id IdContact = Contacto.Id;
                User Usuario = [SELECT Id FROM User WHERE Username = 'comercialdsem@donmario.com' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                validarMiembro(caseId, IdContact);
                
                contactoTM.ParentId = caseId;
                contactoTM.MemberId = IdContact;
                contactoTM.TeamRoleId = IdRolResp;
                
                insert contactoTM;
                
                bandera = 'true';
            }catch(exception e){}
        }
        if(casoAsignado.Responsable__c == 'Com. DSEM - Lucas C. Pires' && bandera == 'false'){
            try{
                Contact Contacto = [SELECT Id FROM Contact WHERE Usuario_Reclamos__c = 'Lucas C. Pires' limit 1];
                Id IdContact = Contacto.Id;
                User Usuario = [SELECT Id FROM User WHERE Username = 'comercialdsem@donmario.com' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                validarMiembro(caseId, IdContact);
                
                contactoTM.ParentId = caseId;
                contactoTM.MemberId = IdContact;
                contactoTM.TeamRoleId = IdRolResp;
                
                insert contactoTM;
                
                bandera = 'true';
            }catch(exception e){}
        }
        if(casoAsignado.Responsable__c == 'Com. DSEM - Sandro Ferrari M.' && bandera == 'false'){
            try{
                Contact Contacto = [SELECT Id FROM Contact WHERE Usuario_Reclamos__c = 'Sandro Ferrari M.' limit 1];
                Id IdContact = Contacto.Id;
                User Usuario = [SELECT Id FROM User WHERE Username = 'comercialdsem@donmario.com' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                validarMiembro(caseId, IdContact);
                
                contactoTM.ParentId = caseId;
                contactoTM.MemberId = IdContact;
                contactoTM.TeamRoleId = IdRolResp;
                
                insert contactoTM;
                
                bandera = 'true';
            }catch(exception e){}
        }
        //String resp;
        
        if(bandera == 'false' && casoAsignado.Responsable__c != ''){
            resp = casoAsignado.Responsable__c.right(casoAsignado.Responsable__c.IndexOf('-')+2).trim();
            //if(resp == 'Fernando Frenher'){
            User Usuario = [SELECT Id FROM User WHERE Lastname = : resp limit 1];
            IdUser = Usuario.Id;
            //}
            bandera = 'true';
        }
        
        try{
            if(casoAsignado.Responsable__c == 'Com. BMX 2 - Fernando Frenher' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Fernando Frenher' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
            if(casoAsignado.Responsable__c == 'Com. BMX 1 - Fausto Fanchin' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Fausto Fanchin' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
            if(casoAsignado.Responsable__c == 'Com. BMX 3 - J. Cristiano Rosa' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'J. Cristiano Rosa' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
            if(casoAsignado.Responsable__c == 'Com. BMX 4 - Sérgio Bertagnoli' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Sérgio Bertagnoli' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
            if(casoAsignado.Responsable__c == 'Com. BMX 5 - Antonio Paiva' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Antonio Paiva' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
            if(casoAsignado.Responsable__c == 'Gerente Des. DSEM - Carlos Pattis' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Carlos Pattis' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
            if(casoAsignado.Responsable__c == 'Gerente Des. BRMX - Francisco Nogara' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Francisco Nogara' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
            if(casoAsignado.Responsable__c == 'Gerente Des. BRMX - Pablo Souza' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Pablo Souza' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
            if(casoAsignado.Responsable__c == 'Com. DSEM 1 - Charles C. Pinto' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Charles Pintro' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
            if(casoAsignado.Responsable__c == 'Com. DSEM 2 - Otavio Ogorni' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Otavio Ogorni' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
            if(casoAsignado.Responsable__c == 'Com. DSEM 3 - Sandro Ferrari M.' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Sandro Moreira' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
            if(casoAsignado.Responsable__c == 'Com. DSEM 4 - Fernando Calazans' && bandera == 'false'){
                User Usuario = [SELECT Id FROM User WHERE Usuario_Reclamos__c = 'Fernando Calazans' AND IsActive = true limit 1];
                IdUser = Usuario.Id;
                
                bandera = 'true';
            }
        }catch(exception e){}        
        if(bandera == 'true'){
            validarMiembro(caseId, IdUser);
            respTM.ParentId = caseId;
            respTM.MemberId = IdUser;
            respTM.TeamRoleId = IdRolResp;
        
            insert respTM;
        }
        
        //return 'true';
        return bandera;
            
    }*/
    
    Public static void validarMiembro(Id caseId, Id IdMiembro){
        CaseTeamMember miembroValidar = new CaseTeamMember();  
        try{
              miembroValidar = [SELECT Id, ParentId, MemberId FROM CaseTeamMember WHERE ParentId =: caseId AND MemberId =: IdMiembro limit 1];
        }catch(exception e){}
        if(miembroValidar.Id != null)
            delete miembroValidar;      
    }
    
    WebService static String reclamoAEdicion (Id caseId, Boolean atendimento){
                
        String rt_sinAtend;
        String rt_conAtend;
        PageReference pr = new PageReference('/' + caseId + '/e');
        for (RecordType rt : [Select Id, Name From RecordType Where Name In ('RECLAMO CON ATEND EN EDICION', 'RECLAMO SIN ATEND EN EDICION') And SObjectType = 'Case']){
            if (rt.Name == 'RECLAMO CON ATEND EN EDICION')
                rt_conAtend = rt.Id;
            if (rt.Name == 'RECLAMO SIN ATEND EN EDICION')
                rt_sinAtend = rt.Id;                
        }
        
        if (atendimento){
            pr.getParameters().put('RecordType', String.valueOf(rt_conAtend));
        }else{
            pr.getParameters().put('RecordType', String.valueOf(rt_sinAtend));
        }
        pr.getParameters().put('retURL', String.valueOf(caseId));           
        return pr.getURL();
        
    }

}
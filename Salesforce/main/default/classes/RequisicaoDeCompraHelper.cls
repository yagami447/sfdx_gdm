public class RequisicaoDeCompraHelper {

    public static Id milhoRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByDeveloperName().get('Milho').getRecordTypeId();
    public static Id sojaRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByDeveloperName().get('Soja').getRecordTypeId();

    public class RequisicaoDeCompraHelperException extends Exception{}
    public static void setParent(List<Requisicao_de_compra__c> requisitions) {
        //cargo mapa de asignaciones por region(marca)
        Map<String, Atributo_venda_de_basica__mdt> assignmentsByRegion  = getAssignments();
        List<String> ResponsavelyTipo = new List<String>();
        Map<String, String> multiplicators = new Map<String, String>();
        Map<String, String> sapCodes = new Map<String, String>();
        Set<String> supervisorIds = new Set<String>();
        List<String> reqIds = new List<String>();
        List<String> supervisores = new List<String>();
        List<String> owners = new List<String>();
        
        for (Requisicao_de_compra__c req : requisitions) {
            if (req.tipo__c == 'Multiplicador') {
                multiplicators.put(req.Multiplicador__c, req.Marca__c);
            }
		}

        for (Account a : [SELECT Id, OwnerId, Responsavel__c, Reponsavel_DSEM__c, Responsavel_NEOGEN__c FROM Account WHERE Id IN :multiplicators.keyset() limit 1] )  {
            //en base a la marca del multiplicador agrego al mapa sapCodes al responsable de la marca 
            try {
                if (multiplicators.get(a.id) == 'BRMX') {
                    if(a.Responsavel__c == null){
                        throw new RequisicaoDeCompraHelperException('::: Observação ::: Verifique se a conta selecionada tem um gerente atribuído :::');
                    } else {
                        sapCodes.put(a.id, a.Responsavel__c.substring(0, 3));
                    }
                } else if (multiplicators.get(a.id) == 'DSEM') {
                    if(a.Reponsavel_DSEM__c == null){
                        throw new RequisicaoDeCompraHelperException('::: Observação ::: Verifique se a conta selecionada tem um gerente atribuído :::');
                    } else {
                        sapCodes.put(a.id, a.Reponsavel_DSEM__c.substring(0, 3));
                    }
                } else if (multiplicators.get(a.id) == 'NEOG') {
                    if(a.Responsavel_NEOGEN__c == null){
                        throw new RequisicaoDeCompraHelperException('::: Observação ::: Verifique se a conta selecionada tem um gerente atribuído :::');
                    } else {
                        sapCodes.put(a.id, a.Responsavel_NEOGEN__c.substring(0, 3));
                    }
                }
            } catch(Exception e) {
                System.debug('Error message: ' + e.getMessage());
            }         
        }

        for (Requisicao_de_compra__c req : requisitions){
			reqIds.add(req.Id);
		}

        List<Requisicao_de_compra__c> requisitionsList = [SELECT Negocio__r.Supervidor__c FROM Requisicao_de_compra__c WHERE Id IN : reqIds];

        for (Requisicao_de_compra__c neg : requisitions){
			supervisores.add(neg.Id);
            owners.add(neg.Id);
		}

        List<User> managerList = [SELECT ManagerId FROM User WHERE Id IN : supervisores];

        List<User> managerOwnersList = [SELECT ManagerId FROM User WHERE Id IN : owners];

        for (Requisicao_de_compra__c req : requisitions) {
            if (req.tipo__c == 'Supervisor') {
                supervisorIds.add(req.ownerId);
            }
        }
        
        //Busco usuarios en funcion del codigo sap, region o supervisor a cargo.
        Map<String, User> UserIdByUserName = getUserNames(assignmentsByRegion,  sapCodes.values(), supervisorIds);
        //Recorro la requisicion
        for(Requisicao_de_compra__c req : requisitions) {
            for(Requisicao_de_compra__c sup : requisitionsList) { 
                String nextLevelType = req.tipo__c == 'Multiplicador'  ? 'Supervisor' : 'Gerente Comercial';
                if (req.tipo__c == 'Multiplicador') {
                    User u = UserIdByUserName.get(sapCodes.get(req.Multiplicador__c));
                    if(req.RecordTypeId == sojaRecordType) {
                        if(u.id == null){
                            req.addError('Verifique o campo ManagerId, aparentemente você não tem um Supervisor atribuído');
                        } else {
                            req.ownerId = u.Id;                
                            req.Aprovador__c = u.Id;
                        }
                    } else {
                        if(req.Estado__c == 'Pendente' && req.RecordTypeId == milhoRecordType) {
                            for(User man : managerList) {
                                req.ownerId = sup.Negocio__r.Supervidor__c;
                                req.Aprovador__c = man.ManagerId;     
                            }          
                        }
                    }   
                } else if (req.tipo__c == 'Supervisor'){
                    User u = UserIdByUserName.get(req.ownerId);
                    if(req.RecordTypeId == sojaRecordType) {
                        if(u.ManagerId == null){
                            req.addError('Verifique o campo ManagerId, aparentemente você não tem um Supervisor atribuído');
                        } else {
                            req.Aprovador__c = u.ManagerId;
                        }
                    } else {
                        for(User man : managerList) {
                            if(req.Estado__c == 'Pendente' && req.RecordTypeId == milhoRecordType) {
                                for(User own : managerOwnersList) {
                                    req.ownerId = own.ManagerId;    
                                    req.Aprovador__c = man.ManagerId;  
                                }
                            } 
                        }    
                    }
                } else if (req.tipo__c == 'Gerente Comercial') {
                    Atributo_venda_de_basica__mdt assignment = assignmentsByRegion.get(req.marca__c);
                    req.Aprovador__c = UserIdByUserName.get(assignment.Usuario_Gerente_de_Marca__c).id;
                }
            }
        }
        
        //Recorro cada requesicion
        for (Requisicao_de_compra__c req : requisitions) {

            if (req.tipo__c == 'Supervisor') {
                ResponsavelyTipo.add(req.Aprovador__c+'-'+ 'Gerente Comercial');    
            }

            ResponsavelyTipo.add(req.OwnerId+'-'+(req.Tipo__c == 'Multiplicador' ? 'Supervisor' : 'Gerente Comercial'));
        }        
       	Map<String, Requisicao_de_compra__c> existingRequitionsByResponsavelyTipo = getExistingRequisitions(ResponsavelyTipo);
        Map<String, Requisicao_de_compra__c> parentReqsByChildReqId = new Map<String, Requisicao_de_compra__c>();
        List<Requisicao_de_compra__c> parentRequisicaoList = new List<Requisicao_de_compra__c>();

        for (Requisicao_de_compra__c req : requisitions) {

            String nextLevelType = (req.Tipo__c == 'Multiplicador' ? 'Supervisor' : 'Gerente Comercial');

            ResponsavelyTipo.add(req.OwnerId+'-'+nextLevelType);
            
            if (req.tipo__c != 'Gerente Comercial'){

                String key = req.OwnerId + '-' + nextLevelType;   

                if (nextLevelType == 'Gerente Comercial') {
                    key = req.Aprovador__c + '-' + nextLevelType;
                }

                if (existingRequitionsByResponsavelyTipo.containsKey(key)) {
                    req.Requisicao_de_compra__c = existingRequitionsByResponsavelyTipo.get(key).id;
                    continue;
                }
                
                if (!parentReqsByChildReqId.containsKey(key)) {

                    Requisicao_de_compra__c newReq = new Requisicao_de_compra__c(
                        Safra__c = req.Safra__c,
                        Marca__c = req.Marca__c, 
                        OwnerId = req.ownerId,
                        Regiao_Comercial__c= req.Regiao_comercial__c,
                        Tipo__c = nextLevelType,
                        RecordTypeId = req.RecordTypeId,
                        Estado__c = 'Edição'
                    );
                    System.debug('Req: ' + newReq);
                    parentReqsByChildReqId.put(key, newReq);
                }
            }
        }

        if (parentReqsByChildReqId.size() != 0) {
            //inserto en la base de datos los padres de las requisiciones por hijo

            System.debug('Childs: ' + parentReqsByChildReqId.values());
            insert parentReqsByChildReqId.values();
            // recorro cada requisicion
            
            for (Requisicao_de_compra__c req : requisitions) {

                String key = req.OwnerId+'-'+(req.Tipo__c == 'Multiplicador' ? 'Supervisor' : 'Gerente Comercial');

                if (req.Tipo__c == 'Supervisor') {
                    key = req.Aprovador__c + '-' + 'Gerente Comercial';
                }

                req.Requisicao_de_compra__c = parentReqsByChildReqId.get(key).Id;        
                
            }
        }
    }

    private static Map<String, Atributo_venda_de_basica__mdt> getAssignments( ) {
        //Carga una lista de asignaciones(atributo de venda de basica metada) con marca y usuario gerente de marca
        List<Atributo_venda_de_basica__mdt> assignments = [
            SELECT Id, Marca__c, Usuario_Gerente_de_Marca__c
            FROM Atributo_venda_de_basica__mdt
        ];
        //Creamos mapa de marca a asignacion
        Map<String, Atributo_venda_de_basica__mdt>  assignmentsByRegion = new Map<String, Atributo_venda_de_basica__mdt> ();   
        
        //recorro las asignaciones
        for (Atributo_venda_de_basica__mdt a : assignments) {
            //cargo el mapa de asignaciones por marca(region) 
            assignmentsByRegion.put(a.marca__c, a);
        }
        
        return assignmentsByRegion;
    }
    
    private static Map<String, User> getUserNames(Map<String, Atributo_venda_de_basica__mdt> assignmentsByRegion, List<String> sapCodes, Set<String> ownerIds) {
        
        System.debug('assignmentsByRegion: ' + assignmentsByRegion);
        System.debug('sapCodes: ' + sapCodes);
        System.debug('ownersIds: '+ ownerIds);
        
        Map<String, User> UserIdByUserName = new Map<String, User>();
            
		List<String> usernames = new List<String>();
        //busco usernames Gerentes de marca en base a la region 
        for (Atributo_venda_de_basica__mdt a : assignmentsByRegion.values()) {
            usernames.add(a.Usuario_Gerente_de_Marca__c);
        }
        //busco en base a los usernames anteriores un usuario y lo cargo dentro del mapa
        for (User u : [SELECT Id, UserName FROM User WHERE UserName = :usernames AND IsActive = true  AND UserName != null]) {
            UserIdByUserName.put(u.UserName, u);
        }
        
		//busco usuarios en base al codigo sap         
        for (User u : [SELECT Id, Codigo_SAP__c FROM User WHERE Codigo_SAP__c IN :sapCodes  AND IsActive = true  AND Codigo_SAP__c != null]) {
            UserIdByUserName.put(u.Codigo_SAP__c, u);
			System.debug(u.Codigo_SAP__c);
        }
        //busco usuarios que sean propietarios
        for (User u : [SELECT Id, ManagerId FROM User WHERE Id IN :ownerIds AND IsActive = true]) {
            UserIdByUserName.put(u.Id, u);
        }
        
        System.debug('Users: ' + UserIdByUserName.values());
        return UserIdByUserName;
    }
    
    private static Map<String, Requisicao_de_compra__c> getExistingRequisitions(List<String> keys) {
        
        Map<String, Requisicao_de_compra__c>  requisitionsByResponsavelyTipo = new Map<String, Requisicao_de_compra__c> ();   
        
        for (Requisicao_de_compra__c req : [
            SELECT Id, Responsavel_y_Tipo__c
            FROM Requisicao_de_compra__c
            WHERE Responsavel_y_Tipo__c IN :keys
        ]) {
            requisitionsByResponsavelyTipo.put(req.Responsavel_y_Tipo__c, req);
        }
        
        return requisitionsByResponsavelyTipo;        
    }
    
    public static void validarEstadoRequisicionesHijasParaAprobar(List<Id> requisicionesParaAprobarId){
        //obtengo una lista de las requisiciones de compra con sus requisiciones de compra hijas
        List<Requisicao_de_compra__c> requisicionesParaAprobar = [
            SELECT id,Name,
                   (
                       SELECT id,Name,Estado__c 
                       FROM Requisitos_de_compra__r
                   ) 
            FROM Requisicao_de_compra__c 
            WHERE Id IN : requisicionesParaAprobarId
        ];

        //recorro cada requisicion a aprobar junto a cada requisicion hija 
        for(Requisicao_de_compra__c req : requisicionesParaAprobar) {
            for(Requisicao_de_compra__c resHIja : req.Requisitos_de_compra__r) {
                //si su estado es pendente lanzo error
                if(resHIja.Estado__c == 'Pendente') {
                    req.addError('Não é possível enviar se houver requisições pendentes');
                }
            }
        }
    }

    // Agregado por Jhonny Peroza
    public static void updateRequisicao(List<Requisicao_de_compra__c> requisicaoList) {

        System.debug('### Estamos actualizando Requisicao!! ###');

        List<String> gerentes = new List<String>();
        List<String> propietarios = new List<String>();
        List<String> negocios = new List<String>();
        List<String> usuarios = new List<String>();
    
        List<Requisicao_de_compra__c> updateRequisitions = new List<Requisicao_de_compra__c>();
    
        for(Requisicao_de_compra__c req : requisicaoList){
            negocios.add(req.Negocio__c);
            propietarios.add(req.OwnerId);
        }
    
        List<Negocio_por_Conta__c> businessList = [SELECT Id, Marca__c, Cultura__c, Region_Comercial__c, Supervidor__c, Conta__c, OwnerId
                                                        FROM Negocio_por_Conta__c 
                                                           WHERE Id IN : negocios];
    
        for(Negocio_por_Conta__c bus : businessList){
            usuarios.add(bus.Supervidor__c);
        }
    
        List<User> userList = [SELECT Id, ManagerId 
                                    FROM User 
                                        WHERE Id IN : propietarios];
          
        for(Requisicao_de_compra__c requisition : requisicaoList) {
            Requisicao_de_compra__c requisitionMap = new Requisicao_de_compra__c();
            requisitionMap.Id = requisition.Id; 
            if(requisition.Tipo__c != 'Supervisor' && requisition.Tipo__c != 'Gerente Comercial' && requisition.RecordTypeId == milhoRecordType) {
                for(Negocio_por_Conta__c business : businessList) {
                    if(requisition.Negocio__c == business.Id) {
                        requisitionMap.Id = requisition.Id;
                        requisitionMap.Marca__c = business.Marca__c;
                        requisitionMap.Cultura__c = business.Cultura__c;
                        requisitionMap.Regiao_Comercial__c = business.Region_Comercial__c;
                        requisitionMap.Multiplicador__c = business.Conta__c;
                        requisitionMap.Supervisor__c = business.Supervidor__c;
                        requisitionMap.OwnerId = business.Supervidor__c;
                        requisitionMap.Aprovador__c = business.Supervidor__c;
                    }
                }   
            }
            if(requisition.Tipo__c == 'Supervisor' && requisition.RecordTypeId == milhoRecordType) {
                for(User manager : userList) {
                    requisitionMap.Id = requisition.Id;
                    requisitionMap.Cultura__c = 'MILHO';
                    requisitionMap.Aprovador__c = manager.ManagerId;
                    requisitionMap.OwnerId = manager.Id; 
                }
            }
            if(requisition.Tipo__c == 'Gerente Comercial' && requisition.RecordTypeId == milhoRecordType) {
                for(User manager : userList) {
                    requisitionMap.Id = requisition.Id;
                    requisitionMap.Cultura__c = 'MILHO';
                    requisitionMap.OwnerId = manager.ManagerId; 
                }
            }
            updateRequisitions.add(requisitionMap);
        }
    
        try {
            if(updateRequisitions != null && updateRequisitions.size() > 0) { 
                update updateRequisitions;
            }
        } catch(DmlException e) {
            System.debug('DML Error message: ' + e.getMessage());
        }                      
    }
}
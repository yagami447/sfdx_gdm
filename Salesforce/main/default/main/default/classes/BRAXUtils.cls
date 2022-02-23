public class BRAXUtils{
    //Antes de deployar cambiar el método de cambio de propietario de Opp!!!!!!!!!!
    private static String rt_fac_brasmax_opps = '012400000000zQt';
    private static String rt_anexo_1_opps = '01240000000M7Lv';
    private static String rt_anexo_5_opps = '01240000000M7MF';
    private static String rt_prevision_opps = '01240000000M9lr';
    private static String rt_estoque_opps = '01240000000M9lt';
    private static String rt_rebajaAnexoHa = '01240000000M7Oz';
    private static String rt_rebajaSacas = '01240000000M7y7';
    private static String rt_objContratoRoy = '012330000009mqZ';
    public Analisis_de_Datos__c filtroActStock = New Analisis_de_Datos__c();
    Public Analisis_de_Datos__c getFiltroActStock(){
        return filtroActStock;
    }

    Public Void setFiltroActStock(Analisis_de_Datos__c arg){
        filtroActStock = arg;
    }

    public Integer getFull(){
        Integer acceso = 0; // 0 es full access
        Profile pr = [SELECT Id, Name
                      FROM Profile
                      WHERE Id = :Userinfo.getProfileId()
                      limit 1];
        UserRole ur = [SELECT Id, Name
                       FROM UserRole
                       WHERE Id = :Userinfo.getUserRoleId()
                       limit 1];
        if (ur.Name.contains('Comercial'))
            acceso = 1;
        if (ur.Name.contains('Producción'))
            acceso = 2;
        if (ur.Name.contains('Gerente Cerrados'))
            acceso = 3;
        if (ur.Name.contains('Gerente Regiao 1'))
            acceso = 4;
        if (ur.Name.contains('Gerente Regiao 2'))
            acceso = 5;
        if (ur.Name.contains('Desarrollo'))
            acceso = 6;
        //if(UserInfo.getUserName() == 'marcelo@brasmaxgenetica.com.br') acceso = 5;
        return acceso;
    }

    public BRAXUtils(ApexPages.StandardController controller){
    }

    public BRAXUtils(){
    }

    public static void actualizarRTCasos(Case[] casos, Map<Id, Case> casos_antes){

        String rt_nuevo;
        String rt_sinAtend;
        String rt_conAtend;
        String rt_enAndamento;
        String rt_propCierre;
        for (RecordType rt : [Select Id, Name
                              From RecordType
                              Where Name In ('RECLAMO CON ATEND EN EDICION', 'RECLAMO SIN ATEND EN EDICION', 'RECLAMO EN ANDAMENTO', 'RECLAMO NUEVO', 'RECLAMO PROPUESTA CIERRE') And SObjectType = 'Case']){
            if (rt.Name == 'RECLAMO CON ATEND EN EDICION')
                rt_conAtend = rt.Id;
            if (rt.Name == 'RECLAMO SIN ATEND EN EDICION')
                rt_sinAtend = rt.Id;
            if (rt.Name == 'RECLAMO EN ANDAMENTO')
                rt_enAndamento = rt.Id;
            if (rt.Name == 'RECLAMO NUEVO')
                rt_nuevo = rt.Id;
            if (rt.Name == 'RECLAMO PROPUESTA CIERRE')
                rt_propCierre = rt.Id;
        }

        //23/11/2017 CAMBIO QUE PIDIO KLEBER QUE TODOS LOS CASOS DE CREEN CON ATENDIMIENTO, POR LO TANTO SE LE ASIGNA EL RT EN ANDAMENTO
        for (Case c : casos){
            if (c.Id == null && c.RecordTypeId == rt_conAtend){
                c.RecordTypeId = rt_enAndamento;
                c.Status = 'Reclamo en Andamento';
            }
        }

        /*
         for (Case c : casos){
         if (casos_antes != null){
         if (casos_antes.get(c.Id).RecordTypeId == rt_nuevo){
         if (c.RecordTypeId == rt_conAtend){
         c.RecordTypeId = rt_enAndamento;
         c.Status = 'Reclamo en Andamento';
         }
         if (c.RecordTypeId == rt_sinAtend){
         c.RecordTypeId = rt_propCierre;
         c.Status = 'Reclamo Propuesta Cierre';
         }
         }
         }
         }
         */
    }

    public PageReference redirectNewOpp(){

        Profile p = [select name
                     from Profile
                     where id = :UserInfo.getProfileId()];
        if (!'Comercial BRMX LE'.equals(p.name)){
            PageReference mainHome = Page.nueva_Opp;
            mainHome.setRedirect(true);
            return mainHome;
        } else
            return null;
    }

    public static void actualizarResponsableCasos(Case[] casos){

        Set<String> cuentas = New Set<String>();
        Map<String, String> accResp = New Map<String, String>();
        Map<String, String> usuarios = New Map<String, String>();

        for (Case c : casos)
            cuentas.add(c.AccountId);
        if (cuentas.size() > 0){
            for (User u : [Select Id, Codigo_SAP__c
                           From User
                           Where isActive = true])
                usuarios.put(u.Codigo_SAP__c, u.Id);
            for (Account a : [Select Id, Responsavel__c, Reponsavel_DSEM__c, Responsavel_NEOGEN__c, Responsavel_DAGMA__c, Responsavel_LICENCAS__c
                              From Account
                              Where Id In :cuentas]){
                if (a.Responsavel__c != null)
                    accResp.put('BRMX' + a.Id, a.Responsavel__c);
                if (a.Reponsavel_DSEM__c != null)
                    accResp.put('DSEM' + a.Id, a.Reponsavel_DSEM__c);
                if (a.Responsavel_NEOGEN__c != null)
                    accResp.put('NEOG' + a.Id, a.Responsavel_NEOGEN__c);
                if (a.Responsavel_DAGMA__c != null)
                    accResp.put('DAGMA' + a.Id, a.Responsavel_DAGMA__c);
                if (a.Responsavel_LICENCAS__c != null)
                    accResp.put('LICENÇAS' + a.Id, a.Responsavel_LICENCAS__c);
            }

            for (Case c : casos){
                if (c.Responsavel__c == null && c.Marca__c != null && c.AccountId != null){
                    c.Responsavel__c = accResp.get(c.Marca__c + c.AccountId);
                    c.OwnerId = usuarios.get(c.Responsavel__c.substring(0, 3));
                }
            }
        }
    }

    /**
     * Actualizar propietarios (Owners) de las oportunidades según el responsable de marca en la cuenta relacionada
     */
    public static void actualizarPropietarioOpp(Opportunity[] oppsNew) {
        Set<Id> cuentas = new Set<Id>();
        Map<Integer, Id> usuarios = new Map<Integer, Id>();
        Map<Id, User> usName = new Map<Id, User>([SELECT Id, Codigo_SAP__c, Name, UserRole.Name FROM User WHERE isActive = true]);

        for (Opportunity opp : oppsNew) { cuentas.add(opp.AccountId); }

        for (User user : usName.values()) {
            if (String.isNotEmpty(user.Codigo_SAP__c)) {
                usuarios.put(Integer.valueOf(user.Codigo_SAP__c), user.Id);
            }
        }

        List<Map<Id, String>> responsables = getResponsablesPorMarca(usuarios, cuentas);

        actualizarPropietariosOpp(oppsNew, usuarios, cuentas, responsables[0], responsables[1], responsables[2], responsables[3], responsables[4], responsables[5], getOpportunityRtNames(), usName);
    }

    /**
     * Actualizar propietarios (Owners) de las oportunidades, CRM eventos y aditivos según el responsable de marca en la cuenta relacionada.
     * El método retorna las listas de oportunidades, CRM eventos y aditivos que deben actualizarse.
     * USER STORY 8211, USER STORY 9543
     */
    public static List<SObject[]> actualizarPropietarios(Id accId, Opportunity[] opps, CRM_Calendario_de_Eventos__c[] eventos, Contrato__c[] aditivos) {
        Map<Integer, Id> usuarios = new Map<Integer, Id>();
        Map<Id, User> usName = new Map<Id, User>([SELECT Id, Codigo_SAP__c, Name, UserRole.Name FROM User WHERE isActive = true]);

        for (User user : usName.values()) {
            if (String.isNotEmpty(user.Codigo_SAP__c)) {
                usuarios.put(Integer.valueOf(user.Codigo_SAP__c), user.Id);
            }
        }

        List<Map<Id, String>> responsables = getResponsablesPorMarca(usuarios, new Set<Id>{accId});

        Map<Id, String> propBRMX = responsables[0];
        Map<Id, String> propDSEM = responsables[1];
        Map<Id, String> propNEOG = responsables[2];
        Map<Id, String> propDAGMA = responsables[3];
        Map<Id, String> propLICENCAS = responsables[4];

        List<Opportunity> oppsToUpdate = actualizarPropietariosOpp(opps, usuarios, new Set<Id>{accId}, propBRMX, propDSEM, propNEOG, propDAGMA, propLICENCAS, responsables[5], getOpportunityRtNames(), usName);

        List<CRM_Calendario_de_Eventos__c> eventosToUpdate = new List<CRM_Calendario_de_Eventos__c>();

        for (CRM_Calendario_de_Eventos__c evento : eventos) {
            String idUser = null;
            Boolean changed = false;

            switch on evento.Marca__c {
                
                when 'BRMX' {
                    idUser = propBRMX.get(evento.Cuenta__c);
                    if (String.isNotEmpty(idUser) && evento.ownerId != idUser) {
                        evento.ownerId = idUser;
                        changed = true;
                    }
                }
                when 'DSEM' {
                    idUser = propDSEM.get(evento.Cuenta__c);
                    if (String.isNotEmpty(idUser) && evento.ownerId != idUser) {
                        evento.ownerId = idUser;
                        changed = true;
                    }
                }
                when 'NEOG' {
                    idUser = propNEOG.get(evento.Cuenta__c);
                    if (String.isNotEmpty(idUser) && evento.ownerId != idUser) {
                        evento.ownerId = idUser;
                        changed = true;
                    }
                }
                when 'DAGMA' {
                    idUser = propDAGMA.get(evento.Cuenta__c);
                    if (String.isNotEmpty(idUser) && evento.ownerId != idUser) {
                        evento.ownerId = idUser;
                        changed = true;
                    }
                }
                when 'LICENÇAS' {
                    idUser = propLICENCAS.get(evento.Cuenta__c);
                    if (String.isNotEmpty(idUser) && evento.ownerId != idUser) {
                        evento.ownerId = idUser;
                        changed = true;
                    }
                }
            }

            if (changed) { eventosToUpdate.add(evento); }
        }

        List<Contrato__c> aditivosToUpdate = new List<Contrato__c>();

        for (Contrato__c aditivo : aditivos) {
            String idUser = null;
            Boolean changed = false;

            switch on aditivo.Sociedad__c {

                when 'BRMX' {
                    idUser = propBRMX.get(aditivo.Multiplicador__c);
                    if (String.isNotEmpty(idUser) && aditivo.ownerId != idUser) {
                        aditivo.ownerId = idUser;
                        changed = true;
                    }
                }
                when 'DSEM' {
                    idUser = propDSEM.get(aditivo.Multiplicador__c);
                    if (String.isNotEmpty(idUser) && aditivo.ownerId != idUser) {
                        aditivo.ownerId = idUser;
                        changed = true;
                    }
                }
                when 'NEOG' {
                    idUser = propNEOG.get(aditivo.Multiplicador__c);
                    if (String.isNotEmpty(idUser) && aditivo.ownerId != idUser) {
                        aditivo.ownerId = idUser;
                        changed = true;
                    } 
                }
                when 'DAGMA' {
                    idUser = propDAGMA.get(aditivo.Multiplicador__c);
                    if (String.isNotEmpty(idUser) && aditivo.ownerId != idUser) {
                        aditivo.ownerId = idUser;
                        changed = true;
                    }
                }
                when 'LICENÇAS' {
                    idUser = propLICENCAS.get(aditivo.Multiplicador__c);
                    if (String.isNotEmpty(idUser) && aditivo.ownerId != idUser) {
                        aditivo.ownerId = idUser;
                        changed = true;
                    }
                }
            }

            if (changed) { aditivosToUpdate.add(aditivo); }
        }

        List<SObject[]> listToUpdate = new List<SObject[]>();

        listToUpdate.add(oppsToUpdate);
        listToUpdate.add(eventosToUpdate);
        listToUpdate.add(aditivosToUpdate);
        
        return listToUpdate;
    }

    /**
     * Actualizar propietarios (Owners) de las oportunidades según el responsable de marca en la cuenta relacionada
     */
    public static List<Opportunity> actualizarPropietariosOpp(Opportunity[] opps, Map<Integer, Id> usuarios, Set<Id> cuentas, Map<Id, String> propBRMX, Map<Id, String> propDSEM, Map<Id, String> propNEOG, Map<Id, String> propDAGMA, Map<Id, String> propLICENCAS, Map<Id, String> accsRegion, Map<Id, String> rtNames, Map<Id, User> usName) {
        Map<Id, Id> contactPortal = new Map<Id, Id>();

        for (Contact contact: [SELECT Id, AccountId FROM Contact WHERE AccountId IN :cuentas AND Title LIKE '%PORTAL%']) {
            if (!contactPortal.ContainsKey(contact.AccountId)) {
                contactPortal.put(contact.AccountId, contact.Id);
            }
        }

        List<Opportunity> oppsToUpdate = new List<Opportunity>();

        for (Opportunity opp : opps) {
            String idUser = null;
            Boolean changed = false;

            if (rtNames.get(opp.RecordTypeId) == 'PB-Comercial') {
                if (opp.Region__c == 'REGION 1') { opp.OwnerId = usuarios.get(8); }
                if (opp.Region__c == 'REGION 2') { opp.OwnerId = usuarios.get(7); }
                if (opp.Region__c == 'CERRADO') { opp.OwnerId = usuarios.get(11); }                          
            }

            switch on opp.Marca__c {

                when 'BRMX' {
                    idUser = propBRMX.get(opp.AccountId);
                    if (String.isNotEmpty(idUser) && opp.ownerId != idUser) {
                        opp.ownerId = idUser;
                        changed = true;
                    }
                }
                when 'DSEM' {
                    idUser = propDSEM.get(opp.AccountId);
                    if (String.isNotEmpty(idUser) && opp.ownerId != idUser) {
                        opp.ownerId = idUser;
                        changed = true;
                    }
                }
                when 'NEOG' {
                    idUser = propNEOG.get(opp.AccountId);
                    if (String.isNotEmpty(idUser) && opp.ownerId != idUser) {
                        opp.ownerId = idUser;
                        changed = true;
                    }
                }
                when 'DAGMA' {
                    idUser = propDAGMA.get(opp.AccountId);
                    if (String.isNotEmpty(idUser) && opp.ownerId != idUser) {
                        opp.ownerId = idUser;
                        changed = true;
                    }
                }
                when 'LICENÇAS' {
                    idUser = propLICENCAS.get(opp.AccountId);
                    if (String.isNotEmpty(idUser) && opp.ownerId != idUser) {
                        opp.ownerId = idUser;
                        changed = true;
                    } 
                }
            }

            // 04.11.2016 Excluyo que en el Anexo I se asigne el contacto para que luego no reciban notificaciones por el proceso de aprobacion, ya que el Anexo I no lo carga el multiplicador
            if (rtNames.get(opp.RecordTypeId) != 'Anexo I' && contactPortal.ContainsKey(opp.AccountId)) {
                opp.Contacto_Portal__c = contactPortal.get(opp.AccountId);
            }

            if (accsRegion.get(opp.AccountId) != null && accsRegion.get(opp.AccountId) != '') {
                opp.Region__c = accsRegion.get(opp.AccountId);
            } else if (usName.get(String.ValueOf(opp.OwnerId)).UserRole.Name == 'Gerente Cerrados') {
                opp.Region__c = 'CERRADO';
            } else if (usName.get(String.ValueOf(opp.OwnerId)).UserRole.Name == 'Gerente Regiao 1') {
                opp.Region__c = 'REGION 1';
            } else if (usName.get(String.ValueOf(opp.OwnerId)).UserRole.Name == 'Gerente Regiao 2') {
                opp.Region__c = 'REGION 2';
            }

            if (changed) { oppsToUpdate.add(opp); }
        }

        return oppsToUpdate;
    }

    /**
     * Obtiene los responsables de marca y región comercial por cuenta, según la lista de usuarios con código SAP
     */
    public static List<Map<Id, String>> getResponsablesPorMarca(Map<Integer, Id> usuariosSAP, Set<Id> cuentas) {
        Map<Id, String> propBRMX = new Map<Id, String>();
        Map<Id, String> propDSEM = new Map<Id, String>();
        Map<Id, String> propNEOG = new Map<Id, String>();
        Map<Id, String> propDAGMA = new Map<Id, String>();
        Map<Id, String> propLICENCAS = new Map<Id, String>();
        Map<Id, String> accsRegion = new Map<Id, String>();
        Map<Id, String> accsName = new Map<Id, String>();
    
        for (Account acc : [SELECT Id, Nome_fantasia__c, Responsavel__c, Reponsavel_DSEM__c, Responsavel_NEOGEN__c, Responsavel_DAGMA__c, Responsavel_LICENCAS__c, Region__r.Region_Comercial__c FROM Account WHERE Id IN :cuentas]) {
            String idUserBRMX = null;
            String idUserDSEM = null;
            String idUserNEOG = null;
            String idUserDAGMA = null;
            string idUserLICENCAS = null;
    
            if (acc.Responsavel__c != null) {
                idUserBRMX = usuariosSAP.get(Integer.valueOf(acc.Responsavel__c.split('-')[0].trim()));
                if (String.isNotEmpty(idUserBRMX)) { propBRMX.put(acc.Id, idUserBRMX); }
            }
    
            if (acc.Reponsavel_DSEM__c != null) {
                idUserDSEM = usuariosSAP.get(Integer.valueOf(acc.Reponsavel_DSEM__c.split('-')[0].trim()));
                if (String.isNotEmpty(idUserDSEM)) { propDSEM.put(acc.Id, idUserDSEM); }
            }
    
            if (acc.Responsavel_NEOGEN__c != null) {
                idUserNEOG = usuariosSAP.get(Integer.valueOf(acc.Responsavel_NEOGEN__c.split('-')[0].trim()));
                if (String.isNotEmpty(idUserNEOG)) { propNEOG.put(acc.Id, idUserNEOG); }
            }

            if (acc.Responsavel_DAGMA__c != null) {
                idUserDAGMA = usuariosSAP.get(Integer.valueOf(acc.Responsavel_DAGMA__c.split('-')[0].trim()));
                if (String.isNotEmpty(idUserDAGMA)) { propDAGMA.put(acc.Id, idUserDAGMA); }
            }

            if (acc.Responsavel_LICENCAS__c != null) {
                idUserLICENCAS = usuariosSAP.get(Integer.valueOf(acc.Responsavel_LICENCAS__c.split('-')[0].trim()));
                if (String.isNotEmpty(idUserLICENCAS)) { propLICENCAS.put(acc.Id, idUserLICENCAS); }
            }
    
            if (String.isNotEmpty(acc.Region__r.Region_Comercial__c)) {
                accsRegion.put(acc.Id, acc.Region__r.Region_Comercial__c);
            }
    
            if (String.isNotEmpty(acc.Nome_fantasia__c)) { accsName.put(acc.Id, acc.Nome_fantasia__c); }
        }
    
        return new List<Map<Id, String>>{propBRMX, propDSEM, propNEOG, propDAGMA, propLICENCAS, accsRegion, accsName};
    }

    /**
     * Genera un mapa con los Id de RecordTypes de oportunidad como clave y sus respectivos nombres como valor
     */
    private static Map<Id, String> getOpportunityRtNames() {
        Map<Id, String> rtNames = new Map<Id, String>();
        
        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        
        for (String rt : rtMapByName.keySet()) {
            rtNames.put(rtMapByName.get(rt).getRecordTypeId(), rtMapByName.get(rt).getName());
        }

        return rtNames;
    }

    /*
     public static void actualizarPropietarioOpp(Opportunity[] oppsNew){
     System.debug('Actualizar propietario de la opp');
     Set<Id> cuentas = New Set<Id>();
     Map<Integer, String> usuarios = New Map<Integer, Id>();
     Map<String, String> propBRMX = New Map<String, String>();
     Map<String, String> propDSEM = New Map<String, String>();
     Map<String, String> propNEOG = New Map<String, String>();
     Map<String, String> cont = New Map<String, String>();
     Map<String, String> accsRegion = New Map<String, String>();
     Map<Id, User> usName = New Map<Id, User>();
     Account cuenta = New Account();
     Map<Id, String> rtNames = New Map<Id, String>();

     List<RecordType> recordTypes = new List<RecordType>{XappiaHelper.getRecordType('Opportunity', 'AnexoI'), XappiaHelper.getRecordType('Opportunity', 'AnexoII'), XappiaHelper.getRecordType('Opportunity', 'AnexoIII'), XappiaHelper.getRecordType('Opportunity', 'AnexoIV'), XappiaHelper.getRecordType('Opportunity', 'AnexoV'), XappiaHelper.getRecordType('Opportunity', 'Anexo_III'), XappiaHelper.getRecordType('Opportunity', 'Anexo_II_Rebaixamento_Sacas'), XappiaHelper.getRecordType('Opportunity', 'Anexo_IV'), XappiaHelper.getRecordType('Opportunity', 'Anexo_I_Rebaixamento_Ha'), XappiaHelper.getRecordType('Opportunity', 'Anticipo_Autorizada'), XappiaHelper.getRecordType('Opportunity', 'Anticipo_Pendiente'), XappiaHelper.getRecordType('Opportunity', 'Aquisicion_Sementes_Terceiros'), XappiaHelper.getRecordType('Opportunity', 'Autorizada'), XappiaHelper.getRecordType('Opportunity', 'CVB_Autorizada'), XappiaHelper.getRecordType('Opportunity', 'CVB_Pendiente'), XappiaHelper.getRecordType('Opportunity', 'CVB_Rechazada'), XappiaHelper.getRecordType('Opportunity', 'Comercial'), XappiaHelper.getRecordType('Opportunity', 'Descarte'), XappiaHelper.getRecordType('Opportunity', 'Disponibilidade_da_Basica'), XappiaHelper.getRecordType('Opportunity', 'Estimativa_de_faturamento'), XappiaHelper.getRecordType('Opportunity', 'Estimativa_de_venda'), XappiaHelper.getRecordType('Opportunity', 'Exportacion'), XappiaHelper.getRecordType('Opportunity', 'Fc_de_Brasmax'), XappiaHelper.getRecordType('Opportunity', 'Fc_de_Brasmax_Contabilizada'), XappiaHelper.getRecordType('Opportunity', 'MBVentas'), XappiaHelper.getRecordType('Opportunity', 'NC_Autorizada'), XappiaHelper.getRecordType('Opportunity', 'NC_Pendiente'), XappiaHelper.getRecordType('Opportunity', 'NC_Rechazada'), XappiaHelper.getRecordType('Opportunity', 'Objetivo_Contrato_Royalties'), XappiaHelper.getRecordType('Opportunity', 'Objetivo_Ventas_Royalties'), XappiaHelper.getRecordType('Opportunity', 'Objetivo_Ventas_Semilla'), XappiaHelper.getRecordType('Opportunity', 'PB_Comercial'), XappiaHelper.getRecordType('Opportunity', 'PB_Desarrollo'), XappiaHelper.getRecordType('Opportunity', 'PB_Oferta'), XappiaHelper.getRecordType('Opportunity', 'PB_Produccion'), XappiaHelper.getRecordType('Opportunity', 'Pendiente'), XappiaHelper.getRecordType('Opportunity', 'Previsao'), XappiaHelper.getRecordType('Opportunity', 'Previsao_Cerrada'), XappiaHelper.getRecordType('Opportunity', 'Previsao_e_Estoque'), XappiaHelper.getRecordType('Opportunity', 'Produccion'), XappiaHelper.getRecordType('Opportunity', 'Rebaja'), XappiaHelper.getRecordType('Opportunity', 'Rechazada'), XappiaHelper.getRecordType('Opportunity', 'Reembalaje'), XappiaHelper.getRecordType('Opportunity', 'Stock_Multiplicadores'), XappiaHelper.getRecordType('Opportunity', 'VB_Autorizada'), XappiaHelper.getRecordType('Opportunity', 'VB_Facturada'), XappiaHelper.getRecordType('Opportunity', 'VB_Pendiente'), XappiaHelper.getRecordType('Opportunity', 'VB_Rechazada'), XappiaHelper.getRecordType('Opportunity', 'VENTA_DE_BASICA'), XappiaHelper.getRecordType('Opportunity', 'Venda_da_Basica_full')};
     try{
    // for (RecordType rt : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
    //     rtNames.put(rt.Id, rt.Name);
     for (RecordType rt : recordTypes)
     rtNames.put(rt.Id, rt.Name);
     for (User u : [Select Id, Codigo_SAP__c, Name, UserRole.Name
     From User
     Where isActive = true]){
     if (u.Codigo_SAP__c != null)
     usuarios.put(Integer.valueOf(u.Codigo_SAP__c), String.valueOf(u.Id));
     usName.put(String.ValueOf(u.Id), u);
     }
     for (Opportunity o : oppsNew)
     cuentas.add(o.AccountId);
     for (Account a : [Select Id, Responsavel__c, Reponsavel_DSEM__c, Responsavel_NEOGEN__c, Region__r.Region_Comercial__c
     From Account
     Where Id In :cuentas]){
     String idUserBRMX = null;
     String idUserDSEM = null;
     String idUserNEOG = null;
     cuenta = a;
     if (a.Responsavel__c != null){
     idUserBRMX = usuarios.get(Integer.valueOf(a.Responsavel__c.split('-')[0].trim()));
     if (idUserBRMX != null && idUserBRMX != '')
     propBRMX.put(a.Id, idUserBRMX);
     }
     if (a.Reponsavel_DSEM__c != null){
     idUserDSEM = usuarios.get(Integer.valueOf(a.Reponsavel_DSEM__c.split('-')[0].trim()));
     if (idUserDSEM != null && idUserDSEM != '')
     propDSEM.put(a.Id, idUserDSEM);
     }
     if (a.Responsavel_NEOGEN__c != null){
     idUserNEOG = usuarios.get(Integer.valueOf(a.Responsavel_NEOGEN__c.split('-')[0].trim()));
     if (idUserNEOG != null && idUserNEOG != '')
     propNEOG.put(a.Id, idUserNEOG);
     }
     accsRegion.put(a.Id, a.Region__r.Region_Comercial__c);
     }
     for (Contact c : [SELECT Id, AccountId
     FROM Contact
     WHERE AccountId IN :cuentas AND Title LIKE '%PORTAL%'])
     if (!cont.ContainsKey(String.ValueOf(c.AccountId)))
     cont.put(String.ValueOf(c.AccountId), String.ValueOf(c.Id));
     for (Opportunity o : oppsNew){
     String idUser = null;
    //if (o.ownerId != '00540000001TUHM'){ //Esto es para Productivo!!!!!!!!!!
    //if (o.ownerId != '00540000001TNkC'){ //Esto es para Sandbox!!!!!!!!!!!!
     if (rtNames.get(o.RecordTypeId) == 'PB-Comercial'){
     if (o.Region__c == 'REGION 1')
     o.OwnerId = usuarios.get(67);
     if (o.Region__c == 'REGION 2')
     o.OwnerId = usuarios.get(66);
     if (o.Region__c == 'CERRADO')
     o.OwnerId = usuarios.get(111);
     }
     if (o.Marca__c == 'BRMX'){
     idUser = propBRMX.get(o.AccountId);
     if (idUser != null && idUser != '')
     o.ownerId = idUser;
     }
     if (o.Marca__c == 'DSEM'){
     idUser = propDSEM.get(o.AccountId);
     if (idUser != null && idUser != '')
     o.ownerId = idUser;
     }
     if (o.Marca__c == 'NEOG'){
     idUser = propNEOG.get(o.AccountId);
     if (idUser != null && idUser != '')
     o.ownerId = idUser;
     }
    //}
    //if (o.ownerId == '00540000001TUHM') o.Invierno__c = true; //Esto es para Productivo!!!!!!!!!!
    //if (o.ownerId == '00540000001TNkC')  o.Invierno__c = true;//Esto es para Sandbox!!!!!!!!!!!!

     if (rtNames.get(o.RecordTypeId) != 'Anexo I')
    //04.11.2016 Excluyo que en el Anexo I se asigne el contacto para que luego no reciban notificaciones por el proceso de aprobacion, ya que el Anexo I no lo carga el multiplicador
     if (cont.ContainsKey(String.ValueOf(o.AccountId)))
     o.Contacto_Portal__c = cont.get(String.ValueOf(o.AccountId));
     if (accsRegion.get(o.AccountId) != null && accsRegion.get(o.AccountId) != ''){
     o.Region__c = accsRegion.get(o.AccountId);
     } else{
     if (usName.get(String.ValueOf(o.OwnerId)).UserRole.Name == 'Gerente Cerrados'){
     o.Region__c = 'CERRADO';
     } else{
     if (usName.get(String.ValueOf(o.OwnerId)).UserRole.Name == 'Gerente Regiao 1'){
     o.Region__c = 'REGION 1';
     } else{
     if (usName.get(String.ValueOf(o.OwnerId)).UserRole.Name == 'Gerente Regiao 2'){
     o.Region__c = 'REGION 2';
     }
     }
     }
     }

     /* Esto va comentado todo, de aca para abajo
     if(cuenta.Region__r.Region_Comercial__c != null){ o.Region__c = cuenta.Region__r.Region_Comercial__c;}

     else{   if(usName.get(String.ValueOf(o.OwnerId)).UserRole.Name == 'Gerente Cerrados'){o.Region__c = 'CERRADO';}
     else{   if(usName.get(String.ValueOf(o.OwnerId)).UserRole.Name == 'Gerente Regiao 1') {o.Region__c = 'REGION 1';}
     else{if(usName.get(String.ValueOf(o.OwnerId)).UserRole.Name == 'Gerente Regiao 2') {o.Region__c = 'REGION 2';}
     }
     }
     }
     */
    /*}
     System.debug('Propietario de la opp actualizado');
     } catch (Exception e){
     System.debug('Exception catched in BraxUtils change owner');
     System.debug(e.getMessage());
     }
     }*/
    public static boolean actualizarNroAutorizacionA1(Opportunity[] oppsNew){
        Map<Id, String> rt = New Map<Id, String>();
        Decimal maximo = 0;
        String camp = '';

        List<Id> negocios = new List<Id>();

        for (Opportunity opp : oppsNew){
            negocios.add(opp.Negocio_por_Conta__c);
        }

        List<Negocio_por_Conta__c> brandsList = [SELECT Id, Marca__c, Conta__c
                                                        FROM Negocio_por_Conta__c 
                                                            WHERE Id IN : negocios]; 

    List<RecordType> recordTypes = new List<RecordType>{XappiaHelper.getRecordType('Opportunity', 'AnexoI'), XappiaHelper.getRecordType('Opportunity', 'AnexoII'), XappiaHelper.getRecordType('Opportunity', 'Anexo_III'), XappiaHelper.getRecordType('Opportunity', 'Anexo_IV'), XappiaHelper.getRecordType('Opportunity', 'AnexoV'), XappiaHelper.getRecordType('Opportunity', 'Anexo_I_Rebaixamento_Ha'), XappiaHelper.getRecordType('Opportunity', 'Anexo_II_Rebaixamento_Sacas'), XappiaHelper.getRecordType('Opportunity', 'Exportacion'), XappiaHelper.getRecordType('Opportunity', 'Reembalaje'), XappiaHelper.getRecordType('Opportunity', 'Aquisicion_Sementes_Terceiros'), XappiaHelper.getRecordType('Opportunity', 'Descarte'), XappiaHelper.getRecordType('Opportunity', 'Previsao'), XappiaHelper.getRecordType('Opportunity', 'Stock_Multiplicadores'), XappiaHelper.getRecordType('Opportunity', 'Stock_Multiplicadores_Milho'), XappiaHelper.getRecordType('Opportunity', 'Estimativa_de_faturamento')};

        // for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity' AND Name IN ('Anexo I','Anexo II', 'Anexo III', 'Anexo IV', 'Anexo V', 'Anexo I Rebaixamento Ha', 'Anexo II Rebaixamento Sacas', 'Exportacion', 'Reembalaje', 'Aquisição Sementes Terceiros', 'Descarte', 'Previsao', 'Stock Multiplicadores', 'Estimativa de faturamento')])
        //     rt.put(reTy.Id, reTy.Name);
        for (RecordType reTy : recordTypes)
            rt.put(reTy.Id, reTy.Name);
        for (Opportunity o1 : oppsNew)
            camp = o1.Safra__c;
        for (Opportunity opp : [Select Id, Nro_autorizacion__c
                                From Opportunity
                                where Nro_autorizacion__c<>null and Safra__c = :camp and (RecordTypeId = :rt_anexo_1_opps OR RecordTypeId = :rt_rebajaAnexoHa OR RecordTypeId = :rt_rebajaSacas OR RecordType.Name IN ('Anexo II', 'Anexo III', 'Anexo IV', 'Anexo V', 'Anexo I Rebaixamento Ha', 'Anexo II Rebaixamento Sacas', 'Exportacion', 'Reembalaje', 'Aquisição Sementes Terceiros'))
                                order by Nro_autorizacion__c desc
                                limit 1])
            if (opp != null)
                maximo = opp.Nro_autorizacion__c;
            for (Opportunity o : oppsNew){
                if ((o.RecordTypeId == rt_anexo_1_opps || o.RecordTypeId == rt_rebajaAnexoHa || o.RecordTypeId == rt_rebajaSacas || rt.get(o.RecordTypeId) == 'Anexo II' || rt.get(o.RecordTypeId) == 'Descarte' || rt.get(o.RecordTypeId) == 'Anexo III' || rt.get(o.RecordTypeId) == 'Anexo IV' || rt.get(o.RecordTypeId) == 'Anexo V' || rt.get(o.RecordTypeId) == 'Anexo I Rebaixamento Ha' || rt.get(o.RecordTypeId) == 'Anexo II Rebaixamento Sacas' || rt.get(o.RecordTypeId) == 'Exportacion' || rt.get(o.RecordTypeId) == 'Reembalaje' || rt.get(o.RecordTypeId) == 'Aquisição Sementes Terceiros') && o.Nro_autorizacion__c == null){
                    o.Nro_autorizacion__c = maximo + 1;
                o.Name = (maximo + 1)+'-' + EncodingUtil.convertToHex(crypto.generateAesKey(128)).substring(1, 3).toLowerCase()+'/20' + camp.substring(3, 5);
            }

            if (rt.get(o.RecordTypeid) == 'Previsao'){
                o.Name = 'Negociação VB ' + o.Marca__c + ' ' + o.Safra__c;
                o.Previsao_Referencia__c = o.Name;
                if (o.Ejercicio__c == null || o.Ejercicio__c.length() == 0)
                    o.Ejercicio__c = String.ValueOf(1);
            }
            if (rt.get(o.RecordTypeid) == 'Stock Multiplicadores'){
                o.Control_Stock_Multiplicadores__c = String.valueOf(o.AccountId)+String.valueOf(o.Safra__c)+String.valueOf(o.Marca__c)+String.valueOf(o.Mes__c);
                o.Name = 'Estoque ' + o.Mes__c;
            }
            if (rt.get(o.RecordTypeid) == 'Stock Multiplicadores Milho'){
                for(Negocio_por_Conta__c brands : brandsList) {
                    o.Name = 'Estoque ' + o.Mes__c;
                    o.Marca__c = brands.Marca__c;
                    o.AccountId = brands.Conta__c;
                    o.Control_Stock_Multiplicadores__c = String.valueOf(o.AccountId) + String.valueOf(o.Safra__c) + String.valueOf(brands.Marca__c) + String.valueOf(o.Mes__c);
                }
            }            
            if (rt.get(o.RecordTypeid) == 'Estimativa de faturamento'){
                o.Name = 'Estimativa de faturamento ' + o.Mes__c;
            }
        }
        return true;
    }

    public static boolean actualizarNombreOpps(Opportunity[] oppsNew){
        // rt.put(reTy.Id, reTy.Name);
        //for(Account a : [SELECT Id, Name FROM Account WHERE Id IN :acc])
        //accts.put(a.Id, a.Name);


        //for(Opportunity o : oppsNew){
        //if (rt.get(o.RecordTypeid) == 'Anexo II' || rt.get(o.RecordTypeid) == 'Anexo III' || rt.get(o.RecordTypeid) == 'Anexo IV' || rt.get(o.RecordTypeid) == 'Anexo V')
        //o.Name = rt.get(o.RecordTypeid).left(10) + '-' + o.Safra__c + '-' + accts.get(o.AccountId).left(12);
        //if (rt.get(o.RecordTypeid) == 'Anexo II Rebaixamento Sacas')
        //o.Name = 'Rebaix. Sacas-' + o.Safra__c + '-' + accts.get(o.AccountId).left(12);
        /*if(o.RecordTypeId == rt_prevision_opps)
         o.Name = 'Previsão VB '+ o.Marca__c + ' ' + o.Safra__c; */
        /*if(o.RecordTypeId == rt_estoque_opps){
         o.Control_Stock_Multiplicadores__c = String.valueOf(o.AccountId) + String.valueOf(o.Safra__c) + String.valueOf(o.Marca__c) + String.valueOf(o.Mes__c);
         o.Name = 'Estoque ' + o.Mes__c;
         }*/
        //}

        return true;
    }

    /*
     public static void actualizarItemTipoRegistro (OpportunityLineItem[] items){

     List<Id> ids = New List<Id>();
     Map<Id,String> rtypes = New Map<Id,String>();

     for (OpportunityLineItem i : items)
     ids.add(i.Id);

     if (ids.size() > 0){
     for (OpportunityLineItem i : [Select Id, Opportunity.RecordType.Name From OpportunityLineItem Where Id In : ids])
     rtypes.put(i.Id, i.Opportunity.RecordType.Name);

     for (OpportunityLineItem i : items)
     i.Tipo_Registro__c = rtypes.get(i.id);
     }

     }
     */
    /*
     REEMPLAZADO POR actualizarContratoItem
     public static boolean actualizarOpps(Opportunity[] oppsNew)
     {
     Map<String,Double> tipos_cambio = New Map<String,Double>();
     Map<String,Date> fechas = New Map<String,Date>();
     Map<Id,String> rt = New Map<Id,String>();

     for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity'])
     rt.put(reTy.Id, reTy.Name);



     for(Opportunity o : oppsNew){
     if(o.RecordTypeId == rt_fac_brasmax_opps){
     o.VB_Franqueado__c = o.AccountId;
     }

     if (rt.get(o.RecordTypeid) == 'Pendiente'){
     if (o.Safra__c != null && o.VB_Chegou_na_Brasmax__c == false){
     if (o.Tipo_de_Cota_o__c != null){
     if (o.Marca__c == 'BRMX'){
     for (Cotizacion_Soja__c c : [SELECT Cotacao_de_soja__c, Valor__c,Fecha__c, Safra__c FROM Cotizacion_Soja__c]){
     tipos_cambio.put(c.Cotacao_de_soja__c + c.Safra__c, c.Valor__c);
     fechas.put(c.Cotacao_de_soja__c + c.Safra__c, c.Fecha__c);
     }
     if (o.Tipo_de_Cota_o__c == 'DOLAR'){
     if (o.Tipo_de_Cambio__c == null || o.Tipo_de_Cambio__c == 0)
     o.Tipo_de_Cambio__c = tipos_cambio.get(o.Tipo_de_Cota_o__c + o.Safra__c);
     if (o.Fecha_fijacion_T_de_cambio__c == null)
     o.Fecha_fijacion_T_de_cambio__c = fechas.get(o.Tipo_de_Cota_o__c + o.Safra__c);
     }else{
     if (o.VB_Cot_Soja__c != null){
     if (o.Tipo_de_Cambio__c == null || o.Tipo_de_Cambio__c == 0)
     o.Tipo_de_Cambio__c = tipos_cambio.get(o.VB_Cot_Soja__c + o.Safra__c);
     if (o.Fecha_fijacion_T_de_cambio__c == null)
     o.Fecha_fijacion_T_de_cambio__c = fechas.get(o.VB_Cot_Soja__c + o.Safra__c);
     }

     }
     }else{
     o.Tipo_de_Cambio__c = 1;
     }
     }
     }
     }
     if (rt.get(o.RecordTypeid) == 'NC - Pendiente'){
     if (o.Pedido_Relacionado__c != null){
     Opportunity o_rel = [Select Id, Tipo_de_Cambio__c From Opportunity Where Id = : o.Pedido_Relacionado__c];
     o.Tipo_de_Cambio__c = o_rel.Tipo_de_Cambio__c;
     }
     }

     }
     return true;
     }
     */
    public static boolean desfacturarItemComercial(OpportunityLineItem[] oppDeleted){
        List<Id> upItem = new List<Id>();
        for (OpportunityLineItem it : oppDeleted){
            if (it.Id_Item_de_Oportunidad_Relacionado__c != null)
                upItem.add(it.Id_Item_de_Oportunidad_Relacionado__c);
        }
        List<OpportunityLineItem> opItems = [select Id, Estado_facturacion__c
                                             From OpportunityLineItem
                                             where Id in :upItem];
        for (OpportunityLineItem it2 : opItems){
            it2.estado_facturacion__c = 'No facturado';
        }
        update opItems;
        return true;
    }

    /*public static boolean actualizarContrato(OpportunityLineItem[] oppItems)
     {
     Id accId; Id oppId;
     List<Id> pbeIds = new List<Id>();
     Map<String,String> pbeMap = new Map<String,String>();
     Map<String,Contrato__c> conMap = new Map<String,Contrato__c>();

     try{

     for(OpportunityLineItem i : oppItems){
     oppId = i.OpportunityId;
     pbeIds.add(i.PricebookEntryId);
     }

     Opportunity o = [SELECT Id, RecordType.Name, AccountId FROM Opportunity WHERE Id = : oppId limit 1];
     if(o.RecordType.Name != 'Comercial') return true;

     for(PricebookEntry pbe : [Select Id, Product2.Variedad__c, Product2.Licenciada__c, Product2.Variedad_Licenciada__c From PricebookEntry Where Id in :pbeIds]){
     if (pbe.Product2.Licenciada__c){
     pbeMap.put(pbe.Id, pbe.Product2.Variedad_Licenciada__c);
     }else{
     pbeMap.put(pbe.Id, pbe.Product2.Variedad__c);
     }
     }

     accId = o.AccountId;
     for(Contrato__c c : [Select Id, Cultivar__r.Variedad__c, Cultivar__r.Licenciada__c, Cultivar__r.Variedad_Licenciada__c From Contrato__c Where Safra__c = 'Sem Safra' And Multiplicador__c = :accId]){
     if (!c.Cultivar__r.Licenciada__c){
     if(!conMap.containsKey(c.Cultivar__r.Variedad__c))
     conMap.put(c.Cultivar__r.Variedad__c, c);
     }else{
     if(!conMap.containsKey(c.Cultivar__r.Variedad_Licenciada__c))
     conMap.put(c.Cultivar__r.Variedad_Licenciada__c, c);
     }
     }
     for(OpportunityLineItem i : oppItems){
     i.Contrato_relacionado__c = conMap.get(pbeMap.get(i.PricebookEntryId)).Id;
     }
     }
     catch(Exception e){
     return false;
     }
     return true;
     }*/
    public static boolean actualizarContratoItem(OpportunityLineItem[] oppItems){
        //Probar si al actualizar masivamente OpportunityLineItems deja mal los setados los contratos. Hay que tener en cuenta la marca del contrato.
        Id accId;
        Id oppId;
        List<Id> pbeIds = New List<Id>();
        Map<String, Opportunity> OppMap = New Map<String, Opportunity>();
        Map<String, String> pbeMap = New Map<String, String>();
        Map<String, Item_del_Contrato__c> conMap = New Map<String, Item_del_Contrato__c>();
        Map<String, OpportunityLineItem> mapItemsRel = New Map<String, OpportunityLineItem>();
        Set<Id> opps = New Set<Id>();
        Set<Id> accs = New Set<Id>();
        Set<Id> idsRel = New Set<Id>();
        Set<String> safras = New Set<String>();

        Map<String, Double> tipos_cambio = New Map<String, Double>();//1
        Map<String, Date> fechas = New Map<String, Date>();//1

        try{
            for (Cotizacion_Soja__c c : [SELECT Cotacao_de_soja__c, Valor__c, Fecha__c, Safra__c
                                         FROM Cotizacion_Soja__c]){
                //1
                tipos_cambio.put(c.Cotacao_de_soja__c + c.Safra__c, c.Valor__c);//1
                fechas.put(c.Cotacao_de_soja__c + c.Safra__c, c.Fecha__c);      //1
            }
            //1

            for (OpportunityLineItem i : oppItems){
                opps.add(i.OpportunityId);
                pbeIds.add(i.PricebookEntryId);
            }

            for (PricebookEntry pbe : [Select Id, Product2.Variedade__c
                                       From PricebookEntry
                                       Where Id In :pbeIds])
                pbeMap.put(String.ValueOf(pbe.Id), String.ValueOf(pbe.Product2.Variedade__c));
            for (Opportunity op : [Select Id, AccountId, Safra__c, RecordType.Name, Pedido_Relacionado__c, Marca__c
                                   From Opportunity
                                   Where Id In :opps]){
                accs.add(op.AccountId);
                safras.add(op.Safra__c);
                if (op.Pedido_Relacionado__c != null)
                    idsRel.add(op.Pedido_Relacionado__c);
                if (!OppMap.ContainsKey(String.ValueOf(op.Id)))
                    OppMap.put(String.ValueOf(op.Id), op);
            }

            if (idsRel.size() > 0){
                for (OpportunityLineItem i : [Select Id, OpportunityId, PricebookEntry.Product2.Variedade__c, Tipo_de_Cambio__c, Tipo_de_Cotizacion__c, Cot_Soja__c
                                              From OpportunityLineItem
                                              Where OpportunityId In :idsRel]){
                    mapItemsRel.put(String.valueOf(i.OpportunityId)+String.valueOf(i.PricebookEntry.Product2.Variedade__c), i);
                }
            }

            for (Item_del_Contrato__c itc : [Select Id, Contrato_de_Multiplicacion__c, Cultivar__r.Variedade__c, Contrato_de_Multiplicacion__r.Multiplicador__c, Contrato_de_Multiplicacion__r.Safra__c, Cotacao_de_soja__c, Praca__c, Precio__c
                                             From Item_del_Contrato__c
                                             Where Contrato_de_Multiplicacion__r.Multiplicador__c In :accs And Contrato_de_Multiplicacion__r.Safra__c In :safras And Contrato_de_Multiplicacion__r.RecordType.Name In ('Termo Aditivo Comerciais', 'Termo Aditivo Novas Biotecnologias') And RecordType.Name In ('Volumen') And Contrato_de_Multiplicacion__r.Estado__c = 'Chegou']){
                if (!conMap.containsKey(String.ValueOf(itc.Contrato_de_Multiplicacion__r.Multiplicador__c)+String.ValueOf(itc.Contrato_de_Multiplicacion__r.Safra__c)+String.ValueOf(itc.Cultivar__r.Variedade__c)))
                    conMap.put(String.ValueOf(itc.Contrato_de_Multiplicacion__r.Multiplicador__c)+String.ValueOf(itc.Contrato_de_Multiplicacion__r.Safra__c)+String.ValueOf(itc.Cultivar__r.Variedade__c), itc);
            }

            for (OpportunityLineItem i : oppItems){
                if (OppMap.get(i.OpportunityId) != null){
                    if (OppMap.get(i.OpportunityId).Safra__c >= '18/19' && (OppMap.get(i.OpportunityId).RecordType.Name == 'Anexo III' || OppMap.get(i.OpportunityId).RecordType.Name == 'Anexo IV' || OppMap.get(i.OpportunityId).RecordType.Name == 'Estimativa de faturamento')){
                        if (conMap.get(OppMap.get(String.ValueOf(i.OpportunityId)).AccountId + String.ValueOf(OppMap.get(String.ValueOf(i.OpportunityId)).Safra__c)+pbeMap.get(String.ValueOf(i.PricebookEntryId))) != null){
                            Item_del_Contrato__c itc = conMap.get(OppMap.get(String.ValueOf(i.OpportunityId)).AccountId + String.ValueOf(OppMap.get(String.ValueOf(i.OpportunityId)).Safra__c)+pbeMap.get(String.ValueOf(i.PricebookEntryId)));
                            i.Contrato_relacionado__c = itc.Contrato_de_Multiplicacion__c;
                            i.Tipo_de_Cotizacion__c = itc.Cotacao_de_soja__c;
                            i.Cot_Soja__c = itc.Praca__c;
                            i.UnitPrice = itc.Precio__c;
                        }
                    }

                    if (OppMap.get(i.OpportunityId).RecordType.Name == 'Pendiente' || OppMap.get(i.OpportunityId).RecordType.Name == 'NC - Pendiente' || OppMap.get(i.OpportunityId).RecordType.Name == 'Estimativa de faturamento'){
                        if (OppMap.get(i.OpportunityId).Safra__c != null){
                            if (i.Cot_Soja__c != null){
                                if (OppMap.get(i.OpportunityId).Marca__c == 'BRMX' || OppMap.get(i.OpportunityId).Marca__c == 'NEOG'){
                                    if (i.Tipo_de_Cambio__c == null || i.Tipo_de_Cambio__c == 0)
                                        i.Tipo_de_Cambio__c = tipos_cambio.get(i.Cot_Soja__c + OppMap.get(i.OpportunityId).Safra__c);
                                    if (i.Fecha_fijacion_T_de_cambio__c == null)
                                        i.Fecha_fijacion_T_de_cambio__c = fechas.get(i.Cot_Soja__c + OppMap.get(i.OpportunityId).Safra__c);
                                } else{
                                    i.Tipo_de_Cambio__c = 1;
                                }
                            }
                        }
                    }

                    if (OppMap.get(i.OpportunityId).RecordType.Name == 'NC - Pendiente'){
                        if (OppMap.get(i.OpportunityId).Pedido_Relacionado__c != null){
                            if (mapItemsRel.get(String.valueOf(OppMap.get(i.OpportunityId).Pedido_Relacionado__c)+String.valueOf(pbeMap.get(i.PricebookEntryId))) != null){
                                i.Tipo_de_Cambio__c = mapItemsRel.get(String.valueOf(OppMap.get(i.OpportunityId).Pedido_Relacionado__c)+String.valueOf(pbeMap.get(i.PricebookEntryId))).Tipo_de_Cambio__c;
                                i.Cot_Soja__c = mapItemsRel.get(String.valueOf(OppMap.get(i.OpportunityId).Pedido_Relacionado__c)+String.valueOf(pbeMap.get(i.PricebookEntryId))).Cot_Soja__c;
                                i.Tipo_de_Cotizacion__c = mapItemsRel.get(String.valueOf(OppMap.get(i.OpportunityId).Pedido_Relacionado__c)+String.valueOf(pbeMap.get(i.PricebookEntryId))).Tipo_de_Cotizacion__c;
                            }
                        }
                    }
                }
            }
        } catch (Exception e){
            return false;
        }

        return true;
    }

    public static String[] validarNuevaProduccionBasica(Opportunity opPB){

        List<Opportunity> opps1 = New List<Opportunity>();
        Map<Id, String> regiones = New Map<Id, String>();
        List<Id> oppIds = New List<Id>();
        //RecordType rt_pbcom = New RecordType();
        //RecordType rt_pbprod = New RecordType();
        //RecordType rt_pbdes = New RecordType();
        Id rt_pbcom = '01240000000MAR3';
        Id rt_pbprod = '01240000000MAR8';
        Id rt_pbdes = '01233000000MI0j';
        Boolean pendienteProd = false;
        Boolean pendienteCom = false;
        Boolean pendienteDes = false;
        Boolean comercial = false;
        Boolean desarrollo = false;

        String maximo = '0';

        String[] retorno = New String[2];
        /*
         11.11.2016 COMENTADO PARA EVITAR 101 QUERIES
         List<RecordType> rt = [Select Id, Name From RecordType Where Name in ('PB-Comercial','PB-Produccion','PB-Desarrollo')];
         for(RecordType r :rt){
         if(r.Name == 'PB-Comercial') rt_pbcom = r;
         if(r.Name == 'PB-Produccion') rt_pbprod = r;
         if(r.Name == 'PB-Desarrollo') rt_pbdes = r;
         }
         11.11.2016 COMENTADO PARA EVITAR 101 QUERIES
         */

        if (opPB.RecordTypeId == rt_pbcom || opPB.RecordTypeId == rt_pbprod || opPB.RecordTypeId == rt_pbdes){

            if (opPB.RecordTypeId == rt_pbprod && opPB.Description != 'ok' && opPB.Rebaja__c == false){
                retorno[0] = 'Falha ao criar a oportunidade Produção da Basica. Deve criar a partir do clone';
                retorno[1] = '';

                return retorno;
            } else{
                opPB.Description = null;
            }

            //for(Opportunity opp : [SELECT Id, RecordTypeId, Name, Safra__c, Macrorregion_de_Ventas__c, Marca__c, Tipo_de_Operacion__c, StageName, Notificado__c, Region__c, Invierno__c, Epoca_de_Plantio__c FROM Opportunity WHERE Marca__c = :opPB.Marca__c AND Safra__c = :opPB.Safra__c AND Region__c = :opPB.Region__c AND Epoca_de_Plantio__c = :opPB.Epoca_de_Plantio__c AND Setor__c = :opPB.Setor__c AND (RecordTypeId = :rt_pbcom.Id OR RecordTypeId = :rt_pbprod.Id OR RecordTypeId = :rt_pbdes.Id)]){

            for (Opportunity opp : [SELECT Id, RecordTypeId, Name, Safra__c, Macrorregion_de_Ventas__c, Marca__c, Tipo_de_Operacion__c, StageName, Notificado__c, Region__c, Invierno__c, Epoca_de_Plantio__c
                                    FROM Opportunity
                                    WHERE Safra__c = :opPB.Safra__c AND Region__c = :opPB.Region__c AND Setor__c = :opPB.Setor__c AND (RecordTypeId = :rt_pbcom OR RecordTypeId = :rt_pbprod OR RecordTypeId = :rt_pbdes)]){
                //opps.put(opp.Id, opp);
                opps1.add(opp);
                //***11/01/2016. Se saca validacion de opps desarrollo, comercial y produccion pendientes de notificar
                //if((opp.RecordTypeId == rt_pbcom.Id && (opp.StageName != 'PB-Aprobada' && opp.StageName != 'PB-Rechazada')))pendienteCom=true;
                //if(opp.RecordTypeId == rt_pbprod.Id && (!opp.Notificado__c)) pendienteProd=true;
                //***11/01/2016. Se saca validacion de opps desarrollo, comercial y produccion pendientes de notificar

                if (opp.RecordTypeId == rt_pbcom && opp.StageName == 'PB-Aprobada')
                    comercial = true;
                //***11/01/2016. Se saca validacion de opps desarrollo, comercial y produccion pendientes de notificar
                //if((opp.RecordTypeId == rt_pbdes.Id && (opp.StageName != 'PB-Aprobada' && opp.StageName != 'PB-Rechazada')))pendienteDes=true;
                //***11/01/2016. Se saca validacion de opps desarrollo, comercial y produccion pendientes de notificar

                if (opp.RecordTypeId == rt_pbdes && opp.StageName == 'PB-Aprobada')
                    desarrollo = true;
            }


            //***11/01/2016. Se saca validacion de opps desarrollo, comercial y produccion pendientes de notificar
            /*
             if(pendienteCom && !Test.isRunningTest()){

             retorno[0] = 'Falha ao criar a oportunidade Produção da Basica. Existe uma Opp Comercial inclinação para aprovar';
             retorno[1] = '';

             return retorno;
             }
             if(pendienteDes && !Test.isRunningTest()){

             retorno[0] = 'Falha ao criar a oportunidade Produção da Basica. Existe uma Opp Desenvolvimento inclinação para aprovar';
             retorno[1] = '';

             return retorno;
             }
             if(pendienteProd && !Test.isRunningTest()){

             retorno[0] = 'Falha ao criar a oportunidade Produção da Basica. Existe uma Opp Produção inclinação para notificar';
             retorno[1] = '';

             return retorno;
             }
             */
            //***11/01/2016. Se saca validacion de opps desarrollo, comercial y produccion pendientes de notificar

            //***10/06/2020. Comentado. Vimos con Celso que no necesitan validar.
            /*
             if(!comercial && opPB.RecordTypeId == rt_pbprod && opPB.Setor__c == 'Comercial' && !Test.isRunningTest()){
             retorno[0] = 'Falha ao criar a oportunidade Produção da Basica. No existe uma Opp Comercial';
             retorno[1] = '';

             return retorno;
             }
             */
            //***10/06/2020. Comentado. Vimos con Celso que no necesitan validar.

            if (!desarrollo && opPB.RecordTypeId == rt_pbprod && opPB.Setor__c == 'Desarrollo' && !Test.isRunningTest()){

                retorno[0] = 'Falha ao criar a oportunidade Produção da Basica. No existe uma Opp Desenvolvimento';
                retorno[1] = '';

                return retorno;
            }

            //for(Opportunity opp : [Select Id, Nro_autorizacion__c, RecordType.Name From Opportunity where Marca__c = :opPB.Marca__c AND Safra__c = :opPB.Safra__c AND Region__c = :opPB.Region__c AND  Nro_autorizacion__c <> null and (RecordType.Name = 'PB-Comercial' OR RecordType.Name = 'PB-Produccion')  order by Nro_autorizacion__c desc limit 1])
            //  if(opp != null) maximo = opp.Nro_autorizacion__c;
            //for(Macrorregi_o_de_Vendas__c reg: [SELECT Id, Name FROM Macrorregi_o_de_Vendas__c])
            //  regiones.put(reg.Id, reg.Name);
            /*
             maximo = obtenerNroAU_PB(opPB.Marca__c, opPB.Safra__c, opPB.Region__c);
             opPB.Nro_autorizacion__c = Integer.valueOf(maximo);
             opPB.Name = String.valueOf(opPB.Marca__c) + '-' + String.valueOf(opPB.Safra__c) + '-' + String.valueOf(opPB.Region__c) + '-' + maximo;
             */
            //maximo = maximo + 1;

            maximo = obtenerNroAU_PB(opPB.Safra__c, opPB.Region__c);
            opPB.Nro_autorizacion__c = Integer.valueOf(maximo);
            opPB.Name = String.valueOf(opPB.Safra__c);
            if (opPB.Marca__c != null)
                opPB.Name += '-' + String.valueOf(opPB.Marca__c);
            if (opPB.Region__c != null)
                opPB.Name += '-' + String.valueOf(opPB.Region__c);
            opPB.Name += '-' + maximo;
        }


        retorno[0] = 'OK';
        retorno[1] = 'OK';

        return retorno;
    }

    //public static string obtenerNroAU_PB(string marca, string safra, string region){
    public static string obtenerNroAU_PB(string safra, string region){

        string retorno = '1';

        //for(Opportunity opp : [Select Id, Nro_autorizacion__c, RecordType.Name From Opportunity where Marca__c = :marca AND Safra__c = :safra AND Region__c = :region AND Nro_autorizacion__c <> null and (RecordType.Name = 'PB-Comercial' OR RecordType.Name = 'PB-Produccion' OR RecordType.Name = 'PB-Desarrollo')  order by Nro_autorizacion__c desc limit 1])
        for (Opportunity opp : [Select Id, Nro_autorizacion__c, RecordType.Name
                                From Opportunity 
                                where Safra__c = :safra AND Region__c = :region AND Nro_autorizacion__c<>null and (RecordType.Name = 'PB-Comercial' OR RecordType.Name = 'PB-Produccion' OR RecordType.Name = 'PB-Desarrollo')
                                order by Nro_autorizacion__c desc
                                limit 1])
            if (opp != null)
                retorno = String.valueOf(opp.Nro_autorizacion__c + 1);
            return retorno;
    }

    /*
     public static void generarOppPBP(Opportunity[] oppsNew, Map<Id,Opportunity> oppsOld){
     Id rt_PBP = null;
     Id rt_PBC = null;
     Id rt_PBD = null;
     Id usProd = null;
     Boolean hayPBC = false;
     Boolean hayPBD = false;

     for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity']){
     if(reTy.Name == 'PB-Produccion') rt_PBP = reTy.Id;
     if(reTy.Name == 'PB-Comercial') rt_PBC = reTy.Id;
     if(reTy.Name == 'PB-Desarrollo') rt_PBD = reTy.Id;
     }
     for(Opportunity o :oppsNew){
     if(o.RecordTypeId == rt_PBC) hayPBC = true;
     if(o.RecordTypeId == rt_PBD) hayPBD = true;
     }
     if(hayPBC || hayPBD){
     for(User u : [SELECT Id, Name, Profile.Name FROM User WHERE (Name = 'Marcelo Dankert' OR Profile.Name = 'Gerente Producción') AND IsActive = true limit 1]){
     usProd = u.Id;
     }
     for(Opportunity o : oppsNew){
     if((o.RecordTypeId == rt_PBC || o.RecordTypeId == rt_PBD) && o.StageName == 'PB-Aprobada' && o.Tipo_de_Operacion__c == '1-Pedido'){
     Opportunity opOld = oppsOld.get(o.Id);
     if(opOld.StageName == 'PB-Pendiente'){
     Savepoint sp;
     Opportunity OppClone = New Opportunity();
     List<OpportunityLineItem> OppCloneOLI = New List<OpportunityLineItem>();

     try{
     sp = Database.setSavepoint();
     OppClone = o.clone(false,true);
     OppClone.RecordTypeId = rt_PBP;
    //if(Test.isRunningTest())
    //OppClone.StageName = 'PB-Pendiente';
    //OppClone.Notificado__c = true;
     OppClone.Notificado__c = false;
     OppClone.StageName = 'PB-Pendiente';
     OppClone.Nro_Autorizacion__c = Integer.valueOf(obtenerNroAU_PB(OppClone.Marca__c, OppClone.Safra__c, OppClone.Region__c));
     OppClone.Name = String.valueOf(OppClone.Marca__c) + '-' + String.valueOf(OppClone.Safra__c) + '-' + String.valueOf(OppClone.Region__c) + '-' + String.valueOf(OppClone.Nro_Autorizacion__c);
     OppClone.Description = 'ok'; //Le pongo un valor a este campo para indicar que la PB-Produccion se esta generando automatica. Para que no se permita crear desde nueva opp a menos que sea una rebaja.
     if(usProd != null)
     OppClone.OwnerId = usProd;
     insert OppClone;
     if(o.HasOpportunityLineItem){
     String soqlOLI = previsionesController.getCreatableFieldsSOQL('OpportunityLineItem','OpportunityId=\'' + o.Id + '\'');
     List<OpportunityLineItem> pbcOLI = (List<OpportunityLineItem>)Database.query(soqlOLI);
     for(OpportunityLineItem oli : pbcOLI){
     OpportunityLineItem oliClone = oli.clone(false,true);
     oliClone.OpportunityId = OppClone.Id;
     oliClone.TotalPrice = null;
     oliClone.Data__c = null;
     OppCloneOLI.Add(oliClone);
     }
     insert OppCloneOLI;
     }

     OppClone.Notificado__c = true;
     OppClone.StageName = 'PB-Aprobada';
     update OppClone;

     }catch(exception e){}
     }

     }

     }
     }
     }
     */
    public static string[] validarVariedadPB(Opportunity op, List<OpportunityLineItem> olis){
        // Este método valida que Producción no carque operaciones de forma incorrecta.
        // = New List<Opportunity>();
        Map<Id, String> oppOperacion = New Map<Id, String>();
        Map<String, String> variedadOpp = New Map<String, String>();
        List<Id> oppIds = New List<Id>();
        Set<Id> variedades = New Set<Id>();

        RecordType rt_pbcom = New RecordType();
        RecordType rt_pbprod = New RecordType();
        RecordType rt_pbdes = New RecordType();
        Boolean pasa = true;
        String varNoPasan = '';

        String[] retorno = New String[2];
        if (op.Rebaja__c){
            retorno[0] = 'OK';
            retorno[1] = 'OK';

            return retorno;
        }
        //try{
        List<RecordType> rt = [Select Id, Name
                               From RecordType 
                               Where Name in ('PB-Comercial', 'PB-Produccion', 'PB-Desarrollo')];
        for (RecordType r : rt){
            if (r.Name == 'PB-Comercial')
                rt_pbcom = r;
            if (r.Name == 'PB-Produccion')
                rt_pbprod = r;
            if (r.Name == 'PB-Desarrollo')
                rt_pbdes = r;
        }

        //List<Opportunity> opps = [SELECT Id, RecordTypeId, Name, Safra__c, Macrorregion_de_Ventas__c, Marca__c, Tipo_de_Operacion__c, StageName, Notificado__c, Region__c, Epoca_de_Plantio__c FROM Opportunity WHERE StageName = 'PB-Aprobada' AND Notificado__c = true AND Marca__c = :op.Marca__c AND Safra__c = :op.Safra__c AND Region__c = :op.Region__c AND RecordTypeId = :rt_pbprod.Id AND Epoca_de_Plantio__c = : op.Epoca_de_Plantio__c AND Setor__c = : op.Setor__c];
        List<Opportunity> opps = [SELECT Id, RecordTypeId, Name, Safra__c, Macrorregion_de_Ventas__c, Marca__c, Tipo_de_Operacion__c, StageName, Notificado__c, Region__c, Epoca_de_Plantio__c
                                  FROM Opportunity
                                  WHERE StageName = 'PB-Aprobada' AND Notificado__c = true AND Safra__c = :op.Safra__c AND Region__c = :op.Region__c AND RecordTypeId = :rt_pbprod.Id AND Setor__c = :op.Setor__c];
        for (Opportunity o : opps){
            oppIds.add(o.Id);
            oppOperacion.put(o.Id, o.Tipo_de_Operacion__c);
        }


        if (olis.size() > 0){
            for (OpportunityLineItem oli : olis){
                variedades.add(oli.PricebookEntry.Product2.Variedade__c);
            }
            List<OpportunityLineItem> oppsoli = [SELECT Id, OpportunityId, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Categ__c
                                                 FROM OpportunityLineItem
                                                 WHERE OpportunityId IN :oppIds AND PricebookEntry.Product2.Variedade__c IN :variedades];
            for (OpportunityLineItem oli : oppsoli){
                if (!variedadOpp.containsKey(String.ValueOf(oli.PricebookEntry.Product2.Variedade__c)+String.ValueOf(oli.PricebookEntry.Product2.Categ__c))){
                    variedadOpp.put(String.ValueOf(oli.PricebookEntry.Product2.Variedade__c)+String.ValueOf(oli.PricebookEntry.Product2.Categ__c), oppOperacion.get(oli.OpportunityId));
                } else{
                    if (oppOperacion.get(oli.OpportunityId) != variedadOpp.get(String.ValueOf(oli.PricebookEntry.Product2.Variedade__c)+String.ValueOf(oli.PricebookEntry.Product2.Categ__c))){
                        if (Integer.ValueOf(oppOperacion.get(oli.OpportunityId).left(1)) > Integer.ValueOf(variedadOpp.get(String.ValueOf(oli.PricebookEntry.Product2.Variedade__c)+String.ValueOf(oli.PricebookEntry.Product2.Categ__c)).left(1))){
                            variedadOpp.remove(String.ValueOf(oli.PricebookEntry.Product2.Variedade__c)+String.ValueOf(oli.PricebookEntry.Product2.Categ__c));
                            variedadOpp.put(String.ValueOf(oli.PricebookEntry.Product2.Variedade__c)+String.ValueOf(oli.PricebookEntry.Product2.Categ__c), oppOperacion.get(oli.OpportunityId));
                        }
                    }
                }
            }
            if (Integer.ValueOF(op.Tipo_de_Operacion__c.left(1)) != 1){
                for (OpportunityLineItem oli : olis){
                    if (variedadOpp.get(String.ValueOf(oli.PricebookEntry.Product2.Variedade__c)+String.ValueOf(oli.PricebookEntry.Product2.Categ__c)) == null){
                        pasa = false;
                        varNoPasan += String.ValueOf(oli.PricebookEntry.Product2.Variedade__r.Name)+'-' + String.ValueOf(oli.PricebookEntry.Product2.Categ__r.Name)+';\r\n';
                    } else{
                        if ((Integer.ValueOf(variedadOpp.get(String.ValueOf(oli.PricebookEntry.Product2.Variedade__c)+String.ValueOf(oli.PricebookEntry.Product2.Categ__c)).left(1)) <= 5 || Integer.ValueOF(op.Tipo_de_Operacion__c.left(1)) < 5) && (Integer.ValueOf(variedadOpp.get(String.ValueOf(oli.PricebookEntry.Product2.Variedade__c)+String.ValueOf(oli.PricebookEntry.Product2.Categ__c)).left(1)) > Integer.ValueOF(op.Tipo_de_Operacion__c.left(1)))){
                            pasa = false;
                            varNoPasan += String.ValueOf(oli.PricebookEntry.Product2.Variedade__r.Name)+'-' + String.ValueOf(oli.PricebookEntry.Product2.Categ__r.Name)+';\r\n';
                        } else{
                            if ((Integer.ValueOf(variedadOpp.get(String.ValueOf(oli.PricebookEntry.Product2.Variedade__c)+String.ValueOf(oli.PricebookEntry.Product2.Categ__c)).left(1)) < 5) && math.abs((Integer.ValueOF(op.Tipo_de_Operacion__c.left(1))-Integer.ValueOf(variedadOpp.get(String.ValueOf(oli.PricebookEntry.Product2.Variedade__c)+String.ValueOf(oli.PricebookEntry.Product2.Categ__c)).left(1)))) > 1){
                                pasa = false;
                                varNoPasan += String.ValueOf(oli.PricebookEntry.Product2.Variedade__r.Name)+'-' + String.ValueOf(oli.PricebookEntry.Product2.Categ__r.Name)+';\r\n';
                            }
                        }
                    }
                }
            }
            if (pasa){
                retorno[0] = 'OK';
                retorno[1] = 'OK';

                return retorno;
            } else{
                retorno[0] = 'Existem variedades que não podem ser introduzidos para o tipo de operação.\r\n' + varNoPasan;
                retorno[1] = '';

                return retorno;
            }
        }

        /*}catch(exception e){
         retorno[0] = 'Falla al validar---' + e.getMessage();
         retorno[1] = '';

         return retorno;
         }*/
        retorno[0] = 'OK';
        retorno[1] = 'OK';

        return retorno;
    }

    public static String[] actualizarProdBasica_New(Opportunity[] oppsNew, Map<Id, Opportunity> oppsOld, Boolean del){
        String[] retorno = New String[2];
        Integer mult = 1;
        Id rt_PBO = null;
        Id rt_PBP = null;
        Id rt_PBC = null;
        Id rt_PBD = null;
        Id usProd = null;
        Integer a = 0;
        Set<Id> opps = New Set<Id>();
        Set<String> prodCamp = New Set<String>();
        if (del)
            mult = -1;
        List<OpportunityLineItem> olis = New List<OpportunityLineItem>();
        Map<String, Asignacion_de_Oferta__c> pbs = New Map<String, Asignacion_de_Oferta__c>();
        Map<String, Asignacion_de_Oferta__c> ofertaAnterior = New Map<String, Asignacion_de_Oferta__c>();
        Map<String, Asignacion_de_Oferta__c> ofertaSinDemanda = New Map<String, Asignacion_de_Oferta__c>();
        Map<Id, List<OpportunityLineItem>> mapaOli = New Map<Id, List<OpportunityLineItem>>();
        Boolean esOferta = false;
        String oppid;
        String safraActual = '15/16';
        Savepoint sp;

        try{

            sp = Database.setSavepoint();

            for (Configuracion_BMX__c conf : [Select Id, PB_Safra_Actual__c
                                              From Configuracion_BMX__c
                                              Where Name = 'Facturacion'
                                              limit 1])
                safraActual = conf.PB_Safra_Actual__c;
            //Se reemplaza el uso de SOQL, para minimizar uso excesivo de SOQL
            //----------------------------------------------------------------
            // for (RecordType reTy : [Select Id, Name
            //                         From RecordType
            //                         Where sObjectType = 'Opportunity'
            //                         limit 1000]){
            //     if (reTy.Name == 'PB-Produccion')
            //         rt_PBP = reTy.Id;
            //     if (reTy.Name == 'PB-Comercial')
            //         rt_PBC = reTy.Id;
            //     if (reTy.Name == 'PB-Desarrollo')
            //         rt_PBD = reTy.Id;
            //     if (reTy.Name == 'PB-Oferta')
            //         rt_PBO = reTy.Id;
            // }

            Map<String, Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
            for (String reName : rtMapByName.keySet()){
                if (reName == 'PB_Produccion')
                    rt_PBP = rtMapByName.get(reName).getRecordTypeId();
                if (reName == 'PB_Comercial')
                    rt_PBC = rtMapByName.get(reName).getRecordTypeId();
                if (reName == 'PB_Desarrollo')
                    rt_PBD = rtMapByName.get(reName).getRecordTypeId();
                if (reName == 'PB_Oferta')
                    rt_PBO = rtMapByName.get(reName).getRecordTypeId();
            }
            //----------------------------------------------------------------
            for (Opportunity o : oppsNew){
                Opportunity opOld = oppsOld.get(o.Id);
                if ((o.RecordTypeId == rt_PBC || o.RecordTypeId == rt_PBD) && o.Safra__c == safraActual && ((o.Notificado__c == true && o.StageName == 'PB-Aprobada' && opOld.Notificado__c == false && opOld.StageName == 'PB-Pendiente') || (del == true && o.Notificado__c == true && o.StageName == 'PB-Aprobada'))){
                    opps.add(o.Id);
                }
                if (o.RecordTypeId == rt_PBO && o.Safra__c == safraActual && ((o.Oferta_Asignada__c == true && o.StageName == 'PB-Aprobada' && opOld.Oferta_Asignada__c == false && opOld.StageName == 'PB-Pendiente') || (del == true && o.Notificado__c == true && o.StageName == 'PB-Aprobada'))){
                    opps.add(o.Id);
                    esOferta = true;
                    oppId = o.Id;
                }
            }
            if (opps.size() > 0){
                if (esOferta)
                    guardarHistoricoPB(safraActual);
                ofertaSinDemanda = eliminarOfertaSinDemanda(safraActual);
                for (OpportunityLineItem oli : [SELECT Id, OpportunityId, PricebookEntry.Product2Id, Quantidade__c, Data__c, Tipo_de_Necesidad__c, Local_Origem__c, Fecha_de_Entrega__c, Local_de_Entrega__c, Estimativa__c, Certificacion__c, Despacho__c, Estoque_Granel__c, Estoque_Sacas__c, Compras_Pedido__c, Compras_Entrada_de_Mercaderia__c
                                                FROM OpportunityLineItem
                                                WHERE OpportunityId IN :opps]){
                    olis.add(oli);
                }
                if (olis.size() > 0){
                    for (Id i : opps){
                        List<OpportunityLineItem> tmpOli = New List<OpportunityLineItem>();
                        for (OpportunityLineItem oli : olis){
                            if (oli.OpportunityId == i){
                                tmpOli.add(oli);
                            }
                        }
                        mapaOli.put(i, tmpOli);

                    }
                    for (Asignacion_de_Oferta__c pb : [SELECT Safra__c, Region__c, Com_Pedido__c, Com_Pedido_Complementar__c, Com_Ajuste__c, Com_Cancelamiento__c, Com_Relocalizacion__c, Com_Adm_Exedente__c, Prod_Estimativa__c, Prod_Certificacion__c, Prod_Compras_Entrada_Mercaderia__c, Prod_Compras_Pedido__c, Prod_Despacho__c, Prod_Estoque_Granel__c, Prod_Estoque_Sacas__c, Com_Subtotal__c, Prod_Subtotal__c, Producto__c, Tipo_de_Necesidad__c, Setor__c, Oportunidad_Oferta__c, Cantidad_Asignada__c, Diferencia__c
                                                       from Asignacion_de_Oferta__c
                                                       Where Safra__c = :safraActual And Activa__c = true]){
                        pbs.put(pb.Region__c + pb.Safra__c + pb.Setor__c + pb.Tipo_de_Necesidad__c + String.ValueOf(pb.Producto__c), pb);
                    }
                    for (Opportunity o : oppsNew){
                        if (opps.Contains(o.Id)){
                            for (OpportunityLineItem oli : mapaOli.get(o.Id)){
                                prodCamp.add(o.Safra__c + oli.PricebookEntry.Product2Id);
                                //if(oli.Quantidade__c == 0 || o.RecordTypeId == rt_PBP){
                                //    continue;
                                //}
                                Asignacion_de_Oferta__c pbUpdate = New Asignacion_de_Oferta__c(Com_Pedido__c = 0, Com_Pedido_Complementar__c = 0, Com_Ajuste__c = 0, Com_Cancelamiento__c = 0, Com_Relocalizacion__c = 0, Com_Adm_Exedente__c = 0, Prod_Estimativa__c = 0, Prod_Certificacion__c = 0, Prod_Compras_Entrada_Mercaderia__c = 0, Prod_Compras_Pedido__c = 0, Prod_Despacho__c = 0, Prod_Estoque_Granel__c = 0, Prod_Estoque_Sacas__c = 0, Com_Subtotal__c = 0, Prod_Subtotal__c = 0);
                                String clave = '';
                                clave = o.Region__c + o.Safra__c + o.Setor__c + oli.Tipo_de_Necesidad__c + String.ValueOf(oli.PricebookEntry.Product2Id);
                                if (pbs.ContainsKey(clave)){
                                    pbUpdate = pbs.get(clave);
                                } else{
                                    if ((o.RecordTypeId == rt_PBC || o.RecordTypeId == rt_PBD) && (o.Tipo_de_Operacion__c == '1-Pedido' || o.Tipo_de_Operacion__c == '2-Pedido Complementar') && del == false){
                                        pbUpdate.Region__c = o.Region__c;
                                        pbUpdate.Safra__c = o.Safra__c;
                                        pbUpdate.Activa__c = true;
                                        pbUpdate.Com_Pedido__c = oli.Quantidade__c;
                                        pbUpdate.Com_Subtotal__c = oli.Quantidade__c;
                                        pbUpdate.Producto__c = oli.PricebookEntry.Product2Id;
                                        pbUpdate.Diferencia__c = 0;
                                        pbUpdate.Setor__c = o.Setor__c;
                                        pbUpdate.Tipo_de_necesidad__c = oli.Tipo_de_necesidad__c;
                                        pbUpdate.Cantidad_Asignada__c = 0;

                                        Asignacion_de_oferta__c ofExistente = ofertaExistente(pbs, pbUpdate.Safra__c, pbUpdate.Producto__c);
                                        if (ofExistente != null){
                                            pbUpdate.Prod_Estimativa__c = ofExistente.Prod_Estimativa__c;
                                            pbUpdate.Prod_Despacho__c = ofExistente.Prod_Despacho__c;
                                            pbUpdate.Prod_Certificacion__c = ofExistente.Prod_Certificacion__c;
                                            pbUpdate.Prod_Estoque_Granel__c = ofExistente.Prod_Estoque_Granel__c;
                                            pbUpdate.Prod_Estoque_Sacas__c = ofExistente.Prod_Estoque_Sacas__c;
                                            pbUpdate.Prod_Compras_Pedido__c = ofExistente.Prod_Compras_Pedido__c;
                                            pbUpdate.Prod_Compras_Entrada_Mercaderia__c = ofExistente.Prod_Compras_Entrada_Mercaderia__c;
                                            pbUpdate.Prod_Subtotal__c = ofExistente.Prod_Subtotal__c;
                                            pbUpdate.Oportunidad_Oferta__c = ofExistente.Oportunidad_Oferta__c;
                                        }

                                        insert pbUpdate;
                                        pbs.put(pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Setor__c + pbUpdate.Tipo_de_Necesidad__c + String.ValueOf(oli.PricebookEntry.Product2Id), pbUpdate);
                                        continue;
                                    }
                                }
                                if (o.RecordTypeId == rt_PBC || o.RecordTypeId == rt_PBD){
                                    if (o.Tipo_de_Operacion__c == '5-Realocação'){
                                        pbUpdate.Com_Relocalizacion__c = pbUpdate.Com_Relocalizacion__c + (oli.Quantidade__c * mult);
                                    } else{
                                        if (o.Tipo_de_Operacion__c == '6-Administração Excedente'){
                                            pbUpdate.Com_Adm_Exedente__c = pbUpdate.Com_Adm_Exedente__c + (oli.Quantidade__c * mult);
                                        } else{
                                            if (o.Tipo_de_Operacion__c == '1-Pedido'){
                                                pbUpdate.Com_Pedido__c = pbUpdate.Com_Pedido__c + (oli.Quantidade__c * mult);
                                            } else{
                                                if (o.Tipo_de_Operacion__c == '2-Pedido Complementar'){
                                                    pbUpdate.Com_Pedido_Complementar__c = pbUpdate.Com_Pedido_Complementar__c + (oli.Quantidade__c * mult);
                                                } else{
                                                    if (o.Tipo_de_Operacion__c == '3-Ajuste'){
                                                        pbUpdate.Com_Ajuste__c = pbUpdate.Com_Ajuste__c + (oli.Quantidade__c * mult);
                                                    } else{
                                                        if (o.Tipo_de_Operacion__c == '4-Cancelamento'){
                                                            pbUpdate.Com_Cancelamiento__c = pbUpdate.Com_Cancelamiento__c + (oli.Quantidade__c * mult);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    pbUpdate.Fecha_de_Necesidad__c = oli.Data__c;
                                    pbUpdate.Com_Subtotal__c = pbUpdate.Com_Subtotal__c + (oli.Quantidade__c * mult);
                                    pbUpdate.Diferencia__c = pbUpdate.Cantidad_Asignada__c - pbUpdate.Com_Subtotal__c;
                                    pbs.remove(pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Setor__c + pbUpdate.Tipo_de_Necesidad__c + String.ValueOf(oli.PricebookEntry.Product2Id));
                                    pbs.put(pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Setor__c + pbUpdate.Tipo_de_Necesidad__c + String.ValueOf(oli.PricebookEntry.Product2Id), pbUpdate);
                                }
                                if (o.RecordTypeId == rt_PBO){
                                    Boolean encontroDemanda = false;
                                    for (Asignacion_de_Oferta__c asig : pbs.values()){
                                        if (asig.Producto__c == oli.PricebookEntry.Product2Id){
                                            if (ofertaSinDemanda.containsKey(asig.Safra__c + asig.Producto__c))
                                                ofertaSinDemanda.remove(asig.Safra__c + asig.Producto__c);
                                            encontroDemanda = true;
                                            asig.Prod_Estimativa__c = oli.Estimativa__c;
                                            asig.Prod_Despacho__c = oli.Despacho__c;
                                            asig.Prod_Certificacion__c = oli.Certificacion__c;
                                            asig.Prod_Estoque_Granel__c = oli.Estoque_Granel__c;
                                            asig.Prod_Estoque_Sacas__c = oli.Estoque_Sacas__c;
                                            asig.Prod_Compras_Pedido__c = oli.Compras_Pedido__c;
                                            asig.Prod_Compras_Entrada_Mercaderia__c = oli.Compras_Entrada_de_Mercaderia__c;
                                            asig.Prod_Subtotal__c = oli.Quantidade__c;
                                            asig.Oportunidad_Oferta__c = o.Id;
                                            //pbUpdate.Fecha_de_entrega__c = oli.Fecha_de_entrega__c;
                                        }
                                    }
                                    if (!encontroDemanda){
                                        pbs.put(String.ValueOf(o.Safra__c)+String.ValueOf(oli.PricebookEntry.Product2Id), New Asignacion_de_Oferta__c(Producto__c = oli.PricebookEntry.Product2Id, Safra__c = o.Safra__c, Prod_Estimativa__c = oli.Estimativa__c, Prod_Despacho__c = oli.Despacho__c, Prod_Certificacion__c = oli.Certificacion__c, Prod_Estoque_Granel__c = oli.Estoque_Granel__c, Prod_Estoque_Sacas__c = oli.Estoque_Sacas__c, Prod_Compras_Pedido__c = oli.Compras_Pedido__c, Prod_Compras_Entrada_Mercaderia__c = oli.Compras_Entrada_de_Mercaderia__c, Prod_Subtotal__c = oli.Quantidade__c, Cantidad_Asignada__c = oli.Quantidade__c, Activa__c = true, Oportunidad_Oferta__c = o.Id, Com_Subtotal__c = 0));
                                    }
                                }
                            }
                        }
                    }
                }
                if (pbs.Size() > 0){

                    Map<String, Double> cantidadItems = calcularPorcentajesPB(pbs, prodCamp);

                    for (Asignacion_de_Oferta__c asig : pbs.values()){
                        if (asig.Com_Subtotal__c != null && asig.Com_Subtotal__c != 0 && cantidadItems.get(asig.Safra__c + asig.Producto__c) != null){
                            if (ofertaSinDemanda.containsKey(asig.Safra__c + asig.Producto__c)){
                                Asignacion_de_oferta__c sobra = ofertaSinDemanda.get(asig.Safra__c + asig.Producto__c);
                                asig.Prod_Estimativa__c = sobra.Prod_Estimativa__c;
                                asig.Prod_Despacho__c = sobra.Prod_Despacho__c;
                                asig.Prod_Certificacion__c = sobra.Prod_Certificacion__c;
                                asig.Prod_Estoque_Granel__c = sobra.Prod_Estoque_Granel__c;
                                asig.Prod_Estoque_Sacas__c = sobra.Prod_Estoque_Sacas__c;
                                asig.Prod_Compras_Pedido__c = sobra.Prod_Compras_Pedido__c;
                                asig.Prod_Compras_Entrada_Mercaderia__c = sobra.Prod_Compras_Entrada_Mercaderia__c;
                                asig.Prod_Subtotal__c = sobra.Prod_Subtotal__c;
                                asig.Oportunidad_Oferta__c = sobra.Oportunidad_Oferta__c;
                            }
                            asig.CAC__c = asig.Com_Subtotal__c * 100 / cantidadItems.get(asig.Safra__c + asig.Producto__c);
                            //if (asig.Prod_Subtotal__c != null && asig.Prod_Subtotal__c != 0){
                            if (asig.Prod_Subtotal__c != null){
                                asig.Cantidad_Asignada__c = asig.CAC__c * asig.Prod_Subtotal__c / 100;
                                if (asig.Cantidad_Asignada__c > asig.Com_Subtotal__c)
                                    asig.Cantidad_Asignada__c = asig.Com_Subtotal__c;
                            }
                        }
                        asig.Diferencia__c = asig.Cantidad_Asignada__c - asig.Com_Subtotal__c;
                    }


                    Map<String, Double> cantidadSobra = calcularSobraPB(pbs, ofertaSinDemanda);

                    for (String s : cantidadSobra.keySet()){
                        Double sobra = cantidadSobra.get(s);
                        for (Asignacion_de_oferta__c asi : pbs.values())
                            if (asi.Safra__c + asi.Producto__c == s){
                                pbs.put(String.ValueOf(asi.Safra__c)+String.ValueOf(asi.Producto__c), New Asignacion_de_Oferta__c(Producto__c = asi.Producto__c, Safra__c = asi.Safra__c, Com_Subtotal__c = 0, Prod_Estimativa__c = asi.Prod_Estimativa__c, Prod_Despacho__c = asi.Prod_Despacho__c, Prod_Certificacion__c = asi.Prod_Certificacion__c, Prod_Estoque_Granel__c = asi.Prod_Estoque_Granel__c, Prod_Estoque_Sacas__c = asi.Prod_Estoque_Sacas__c, Prod_Compras_Pedido__c = asi.Prod_Compras_Pedido__c, Prod_Compras_Entrada_Mercaderia__c = asi.Prod_Compras_Entrada_Mercaderia__c, Prod_Subtotal__c = asi.Prod_Subtotal__c, Cantidad_Asignada__c = sobra, Activa__c = true, Oportunidad_Oferta__c = asi.Oportunidad_Oferta__c, Diferencia__c = sobra));
                            break;
                        }
                        for (Asignacion_de_oferta__c asi : ofertaSinDemanda.values())
                            if (asi.Safra__c + asi.Producto__c == s){
                                pbs.put(String.ValueOf(asi.Safra__c)+String.ValueOf(asi.Producto__c), New Asignacion_de_Oferta__c(Producto__c = asi.Producto__c, Safra__c = asi.Safra__c, Com_Subtotal__c = 0, Prod_Estimativa__c = asi.Prod_Estimativa__c, Prod_Despacho__c = asi.Prod_Despacho__c, Prod_Certificacion__c = asi.Prod_Certificacion__c, Prod_Estoque_Granel__c = asi.Prod_Estoque_Granel__c, Prod_Estoque_Sacas__c = asi.Prod_Estoque_Sacas__c, Prod_Compras_Pedido__c = asi.Prod_Compras_Pedido__c, Prod_Compras_Entrada_Mercaderia__c = asi.Prod_Compras_Entrada_Mercaderia__c, Prod_Subtotal__c = asi.Prod_Subtotal__c, Cantidad_Asignada__c = sobra, Activa__c = true, Oportunidad_Oferta__c = asi.Oportunidad_Oferta__c, Diferencia__c = sobra));
                            break;
                        }
                    }

                    if (esOferta)
                        for (Asignacion_de_oferta__c asi : pbs.values())
                            asi.Oportunidad_Oferta__c = oppId;
                        upsert pbs.values();
                }

            }

        } catch (exception e){
            Database.rollback(sp);
            retorno[0] = 'ERROR: ' + e.getMessage();
            retorno[1] = 'ERROR';
            return retorno;
        }

        retorno[0] = 'OK';
        retorno[1] = 'OK';
        return retorno;
    }

    public static void guardarHistoricoPB(String safra){

        List<Asignacion_de_oferta__c> asig = New List<Asignacion_de_oferta__c>();
        List<Asignacion_de_oferta__c> asig_clone = New List<Asignacion_de_oferta__c>();
        Set<Id> pbsDel = New Set<Id>();
        asig = [Select Id, Activa__c, CAC__c, Cantidad_Asignada__c, Com_Adm_Exedente__c, Com_Ajuste__c, Com_Cancelamiento__c, Com_Pedido__c, Com_Pedido_Complementar__c, Com_Relocalizacion__c, Com_Subtotal__c, Prod_Certificacion__c, Prod_Compras_Entrada_Mercaderia__c, Prod_Compras_Pedido__c, Prod_Despacho__c, Prod_Estimativa__c, Prod_Estoque_Granel__c, Prod_Estoque_Sacas__c, Prod_Subtotal__c, Producto__c, Region__c, Safra__c, Setor__c, Tipo_de_Necesidad__c, Diferencia__c, Oportunidad_Oferta__c
                From Asignacion_de_oferta__c
                Where Safra__c = :safra And Activa__c = true];

        if (asig.size() > 0){
            for (Asignacion_de_oferta__c a : asig){
                Asignacion_de_oferta__c a_clone = a.clone(false, true);
                a_clone.Oportunidad_Oferta__c = null;
                asig_clone.add(a_clone);
            }

            insert asig_clone;

            for (Asignacion_de_oferta__c a : asig){
                a.Activa__c = false;
                if (a.Oportunidad_Oferta__c == null)
                    pbsDel.add(a.Id);
            }

            update asig;

            if (pbsDel.size() > 0){
                List<Asignacion_de_oferta__c> asig_borrar = [Select Id
                                                             From Asignacion_de_oferta__c
                                                             Where Id In :pbsDel];
                delete asig_borrar;
            }
        }
    }

    public static Map<String, Double> calcularPorcentajesPB(Map<String, Asignacion_de_Oferta__c> pbs, Set<String> prodCamp){

        Map<String, Double> cantidadItems = New Map<String, Double>();

        for (Asignacion_de_Oferta__c asig : pbs.values()){
            if (prodCamp.contains(asig.Safra__c + asig.Producto__c)){
                if (!cantidadItems.containsKey(asig.Safra__c + asig.Producto__c)){
                    if (asig.Com_Subtotal__c != null)
                        cantidadItems.put(asig.Safra__c + asig.Producto__c, Double.valueOf(asig.Com_Subtotal__c));
                } else{
                    Double cant = Double.valueOf(cantidadItems.get(asig.Safra__c + asig.Producto__c));
                    cantidadItems.remove(asig.Safra__c + asig.Producto__c);
                    if (asig.Com_Subtotal__c != null)
                        cant = cant + Double.valueOf(asig.Com_Subtotal__c);
                    cantidadItems.put(asig.Safra__c + asig.Producto__c, cant);
                }
            }
        }

        return cantidadItems;
    }

    public static Map<String, Asignacion_de_oferta__c> eliminarOfertaSinDemanda(String safra){

        Map<String, Asignacion_de_oferta__c> ofSinDem = New Map<String, Asignacion_de_oferta__c>();

        List<Asignacion_de_oferta__c> o = [SELECT Safra__c, Region__c, Com_Pedido__c, Com_Pedido_Complementar__c, Com_Ajuste__c, Com_Cancelamiento__c, Com_Relocalizacion__c, Com_Adm_Exedente__c, Prod_Estimativa__c, Prod_Certificacion__c, Prod_Compras_Entrada_Mercaderia__c, Prod_Compras_Pedido__c, Prod_Despacho__c, Prod_Estoque_Granel__c, Prod_Estoque_Sacas__c, Com_Subtotal__c, Prod_Subtotal__c, Producto__c, Tipo_de_Necesidad__c, Setor__c, Oportunidad_Oferta__c
                                           from Asignacion_de_Oferta__c
                                           Where ((Com_Pedido__c = null Or Com_Pedido__c = 0) And (Com_Pedido_Complementar__c = null Or Com_Pedido_Complementar__c = 0)) And Safra__c = :safra And Activa__c = true];
        if (o.size() > 0)
            for (Asignacion_de_oferta__c a : o)
                ofSinDem.put(a.Safra__c + a.Producto__c, a);
            delete o;
        return ofSindem;
    }

    public static Asignacion_de_oferta__c ofertaExistente(Map<String, Asignacion_de_Oferta__c> pbs, String safra, String prod){

        for (Asignacion_de_Oferta__c asi : pbs.values())
            if (asi.Safra__c == safra && asi.Producto__c == prod)
                return asi;
            return null;
    }

    public static Map<String, Double> calcularSobraPB(Map<String, Asignacion_de_Oferta__c> pbs, Map<String, Asignacion_de_Oferta__c> ofSinDem){

        Map<String, Double> oferta = New Map<String, Double>();
        Map<String, Double> demanda = New Map<String, Double>();
        Map<String, Double> oferta_aux = New Map<String, Double>();

        for (Asignacion_de_Oferta__c ofer : pbs.values()){
            if (!oferta.containsKey(ofer.Safra__c + ofer.Producto__c))
                oferta.put(ofer.Safra__c + ofer.Producto__c, Double.valueOf(ofer.Prod_Subtotal__c));
            if (!demanda.containsKey(ofer.Safra__c + ofer.Producto__c)){
                demanda.put(ofer.Safra__c + ofer.Producto__c, Double.valueOf(ofer.Com_Subtotal__c));
            } else{
                Double dem = demanda.get(ofer.Safra__c + ofer.Producto__c);
                demanda.remove(ofer.Safra__c + ofer.Producto__c);
                demanda.put(ofer.Safra__c + ofer.Producto__c, Double.valueOf(ofer.Com_Subtotal__c)+dem);
            }
        }

        for (Asignacion_de_Oferta__c ofer : ofSinDem.values())
            if (!oferta.containsKey(ofer.Safra__c + ofer.Producto__c))
                oferta.put(ofer.Safra__c + ofer.Producto__c, Double.valueOf(ofer.Prod_Subtotal__c));
            for (String s : demanda.keySet()){
                Double dem = demanda.get(s);
            Double ofe = 0;
            if (oferta.get(s) != null)
                ofe = oferta.get(s);
            if (dem < ofe)
                oferta_aux.put(s, ofe - dem);
        }

        for (String s : ofSinDem.keySet()){
            Asignacion_de_oferta__c ofe = ofSinDem.get(s);
            if (demanda.get(s) == null)
                oferta_aux.put(s, ofe.Prod_Subtotal__c);
        }

        return oferta_aux;
    }

    public static String[] actualizarProdBasica(Opportunity[] oppsNew, Map<Id, Opportunity> oppsOld, Boolean del){
        String[] retorno = New String[2];
        Integer mult = 1;
        Id rt_PBP = null;
        Id rt_PBC = null;
        Id rt_PBD = null;
        Id usProd = null;
        Integer a = 0;
        Set<Id> opps = New Set<Id>();
        if (del)
            mult = -1;
        //List<OpportunityLineItem> tmpOli = New List<OpportunityLineItem>();
        List<OpportunityLineItem> olis = New List<OpportunityLineItem>();
        Map<String, Produccion_Basica__c> pbs = New Map<String, Produccion_Basica__c>();
        Map<Id, List<OpportunityLineItem>> mapaOli = New Map<Id, List<OpportunityLineItem>>();
        //Produccion_Basica__c pbUpdate = New Produccion_Basica__c();
        //sObjetct pbUpdate = New Produccion_Basica__c();

        //Se reemplaza el uso de SOQL, para minimizar uso excesivo de SOQL
        //----------------------------------------------------------------
        // for (RecordType reTy : [Select Id, Name
        //                         From RecordType
        //                         Where sObjectType = 'Opportunity']){
        //     if (reTy.Name == 'PB-Produccion')
        //         rt_PBP = reTy.Id;
        //     if (reTy.Name == 'PB-Comercial')
        //         rt_PBC = reTy.Id;
        //     if (reTy.Name == 'PB-Desarrollo')
        //         rt_PBD = reTy.Id;
        // }

        Map<String, Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        for (String reName : rtMapByName.keySet()){
            if (reName == 'PB_Produccion')
                rt_PBP = rtMapByName.get(reName).getRecordTypeId();
            if (reName == 'PB_Comercial')
                rt_PBC = rtMapByName.get(reName).getRecordTypeId();
            if (reName == 'PB_Desarrollo')
                rt_PBD = rtMapByName.get(reName).getRecordTypeId();
        }
        //----------------------------------------------------------------
        for (Opportunity o : oppsNew){
            Opportunity opOld = oppsOld.get(o.Id);
            //if(o.RecordTypeId == rt_PBP && ((o.Notificado__c == true && o.StageName == 'PB-Aprobada' && opOld.Notificado__c == false && opOld.StageName == 'PB-Pendiente') || (del == true && o.Notificado__c == true && o.StageName == 'PB-Aprobada'))){
            if ((o.RecordTypeId == rt_PBP || o.RecordTypeId == rt_PBC || o.RecordTypeId == rt_PBD) && ((o.Notificado__c == true && o.StageName == 'PB-Aprobada' && opOld.Notificado__c == false && opOld.StageName == 'PB-Pendiente') || (del == true && o.Notificado__c == true && o.StageName == 'PB-Aprobada'))){
                opps.add(o.Id);
            }
            //if((o.RecordTypeId == rt_PBC || o.RecordTypeId == rt_PBD) && ((o.En_Proc_Aprobacion__c == true && o.StageName == 'PB-Aprobada' && opOld.En_Proc_Aprobacion__c == true && opOld.StageName != 'PB-Aprobada') || (del == true && o.StageName == 'PB-Aprobada'))) opps.add(o.Id);
        }
        if (opps.size() > 0){
            for (OpportunityLineItem oli : [SELECT Id, OpportunityId, PricebookEntry.Product2Id, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, PricebookEntry.Product2.Variedade__r.Id, PricebookEntry.Product2.Categ__c, PricebookEntry.Product2.Categ__r.Name, PricebookEntry.Product2.Categ__r.Id, Quantidade__c, Data__c, Tipo_de_Necesidad__c, Local_Origem__c, Fecha_de_Entrega__c, Local_de_Entrega__c
                                            FROM OpportunityLineItem
                                            WHERE OpportunityId IN :opps]){
                olis.add(oli);
            }
            if (olis.size() > 0){
                for (Id i : opps){
                    List<OpportunityLineItem> tmpOli = New List<OpportunityLineItem>();
                    for (OpportunityLineItem oli : olis){
                        if (oli.OpportunityId == i){
                            tmpOli.add(oli);
                        }
                    }
                    mapaOli.put(i, tmpOli);

                }
                for (Produccion_Basica__c pb : [SELECT Epoca_de_Plantio__c, Safra__c, Region__c, Marca__c, Com_1_Pedido__c, Prod_1_Pedido__c, Com_2_Pedido_Complementar__c, Com_3_Ajuste__c, Com_4_Cancelamiento__c, Com_5_Relocalizacion__c, Com_6_Adm_Exedente__c, Prod_2_Plantio__c, Prod_3_Estimativa__c, Prod_4_Colheita__c, Prod_5_Beneficiamento__c, Prod_6_Armazenagem__c, Prod_7_Descarte__c, Prod_8_Cessao__c, Prod_9_Certificacion__c, Variedade__c, Categoria__c, Variedade__r.Id, Categoria__r.Id, Subtotal_Comercial__c, Subtotal_Prod__c, Diferencia__c, Local_Origem__c, Local_de_Entrega__c, Fecha_de_entrega__c, Fecha_de_necesidad__c, Tipo_de_Necesidad__c, Setor__c
                                                from Produccion_Basica__c]){
                    /*
                     if (pb.Setor__c == 'Comercial'){
                     pbs.put(pb.Marca__c + pb.Region__c + pb.Safra__c + pb.Epoca_de_Plantio__c + pb.Setor__c + String.ValueOf(pb.Variedade__r.Id) + String.ValueOF(pb.Categoria__r.Id), pb);
                     }else{
                     pbs.put(pb.Marca__c + pb.Region__c + pb.Safra__c + pb.Epoca_de_Plantio__c + pb.Setor__c + pb.Tipo_de_Necesidad__c + pb.Local_Origem__c + String.ValueOf(pb.Variedade__r.Id) + String.ValueOF(pb.Categoria__r.Id), pb);
                     }
                     */
                    pbs.put(pb.Region__c + pb.Safra__c + pb.Setor__c + pb.Tipo_de_Necesidad__c + pb.Local_de_Entrega__c + String.ValueOf(pb.Variedade__r.Id)+String.ValueOF(pb.Categoria__r.Id), pb);
                }
                for (Opportunity o : oppsNew){
                    if (opps.Contains(o.Id)){
                        for (OpportunityLineItem oli : mapaOli.get(o.Id)){
                            //if(oli.Quantidade__c == 0){
                            if (oli.Quantidade__c == 0 && o.RecordTypeId != rt_PBP){
                                continue;
                            }
                            Produccion_Basica__c pbUpdate = New Produccion_Basica__c(Com_1_Pedido__c = 0, Prod_1_Pedido__c = 0, Com_2_Pedido_Complementar__c = 0, Com_3_Ajuste__c = 0, Com_4_Cancelamiento__c = 0, Com_5_Relocalizacion__c = 0, Com_6_Adm_Exedente__c = 0, Prod_2_Plantio__c = 0, Prod_3_Estimativa__c = 0, Prod_4_Colheita__c = 0, Prod_5_Beneficiamento__c = 0, Prod_6_Armazenagem__c = 0, Prod_7_Descarte__c = 0, Prod_8_Cessao__c = 0, Prod_9_Certificacion__c = 0, Subtotal_Comercial__c = 0, Subtotal_Prod__c = 0, Diferencia__c = 0);
                            String clave = '';
                            /*
                             if (o.Setor__c == 'Comercial'){
                             clave = o.Marca__c + o.Region__c + o.Safra__c + o.Epoca_de_plantio__c + o.Setor__c + String.ValueOf(oli.PricebookEntry.Product2.Variedade__r.Id) + String.ValueOf(oli.PricebookEntry.Product2.Categ__r.Id);
                             }else{
                             clave = o.Marca__c + o.Region__c + o.Safra__c + o.Epoca_de_plantio__c + o.Setor__c + oli.Tipo_de_Necesidad__c + oli.Local_Origem__c + String.ValueOf(oli.PricebookEntry.Product2.Variedade__r.Id) + String.ValueOf(oli.PricebookEntry.Product2.Categ__r.Id);
                             }
                             */
                            clave = o.Region__c + o.Safra__c + o.Setor__c + oli.Tipo_de_Necesidad__c + oli.Local_de_Entrega__c + String.ValueOf(oli.PricebookEntry.Product2.Variedade__r.Id)+String.ValueOf(oli.PricebookEntry.Product2.Categ__r.Id);
                            //if(pbs.ContainsKey(clave) && oli.Quantidade__c != 0){
                            if (pbs.ContainsKey(clave)){
                                pbUpdate = pbs.get(clave);
                            } else{
                                if ((o.RecordTypeId == rt_PBC || o.RecordTypeId == rt_PBD) && (o.Tipo_de_Operacion__c == '1-Pedido' || o.Tipo_de_Operacion__c == '2-Pedido Complementar') && del == false){
                                    //pbUpdate.Marca__c = o.Marca__c;
                                    pbUpdate.Region__c = o.Region__c;
                                    pbUpdate.Safra__c = o.Safra__c;
                                    //pbUpdate.Epoca_de_Plantio__c = o.Epoca_de_plantio__c;
                                    pbUpdate.Variedade__c = oli.PricebookEntry.Product2.Variedade__c;
                                    pbUpdate.Categoria__c = oli.PricebookEntry.Product2.Categ__c;
                                    pbUpdate.Com_1_Pedido__c = oli.Quantidade__c;
                                    //pbUpdate.Prod_1_Pedido__c = oli.Quantidade__c;
                                    pbUpdate.Subtotal_Comercial__c = oli.Quantidade__c;
                                    //pbUpdate.Subtotal_Prod__c = oli.Quantidade__c;
                                    pbUpdate.Producto__c = oli.PricebookEntry.Product2Id;
                                    pbUpdate.Diferencia__c = 0;
                                    pbUpdate.Setor__c = o.Setor__c;
                                    pbUpdate.Tipo_de_necesidad__c = oli.Tipo_de_necesidad__c;
                                    pbUpdate.Local_de_Entrega__c = oli.Local_de_Entrega__c;
                                    pbUpdate.Fecha_de_necesidad__c = oli.Data__c;
                                    ////if (pbUpdate.Setor__c == 'Desarrollo'){
                                    ////pbUpdate.Fecha_de_necesidad__c = oli.Data__c;
                                    //pbUpdate.Tipo_de_necesidad__c = oli.Tipo_de_necesidad__c;
                                    //pbUpdate.Local_Origem__c = oli.Local_Origem__c;
                                    ////}
                                    insert pbUpdate;
                                    /*
                                     if (pbUpdate.Setor__c == 'Comercial'){
                                     pbs.put(pbUpdate.Marca__c + pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Epoca_de_Plantio__c + pbUpdate.Setor__c + String.ValueOf(pbUpdate.Variedade__r.Id) + String.ValueOf(pbUpdate.Categoria__r.Id), pbUpdate);
                                     }else{
                                     pbs.put(pbUpdate.Marca__c + pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Epoca_de_Plantio__c + pbUpdate.Setor__c + pbUpdate.Tipo_de_Necesidad__c + pbUpdate.Local_Origem__c + String.ValueOf(pbUpdate.Variedade__r.Id) + String.ValueOf(pbUpdate.Categoria__r.Id), pbUpdate);
                                     }
                                     */
                                    pbs.put(pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Setor__c + pbUpdate.Tipo_de_Necesidad__c + pbUpdate.Local_de_Entrega__c + String.ValueOf(oli.PricebookEntry.Product2.Variedade__r.Id)+String.ValueOf(oli.PricebookEntry.Product2.Categ__r.Id), pbUpdate);
                                    continue;
                                }

                                if (((o.RecordTypeId == rt_PBP && o.Rebaja__c == true) || ((o.RecordTypeId == rt_PBC || o.RecordTypeId == rt_PBD) && o.Tipo_de_Operacion__c == '2-Pedido Complementar')) && del == false && oli.Quantidade__c != 0){
                                    //pbUpdate.Marca__c = o.Marca__c;
                                    pbUpdate.Region__c = o.Region__c;
                                    pbUpdate.Safra__c = o.Safra__c;
                                    //pbUpdate.Epoca_de_Plantio__c = o.Epoca_de_plantio__c;
                                    pbUpdate.Variedade__c = oli.PricebookEntry.Product2.Variedade__c;
                                    pbUpdate.Categoria__c = oli.PricebookEntry.Product2.Categ__c;
                                    pbUpdate.Producto__c = oli.PricebookEntry.Product2Id;
                                    //pbUpdate.Subtotal_Comercial__c = 0;
                                    //pbUpdate.Subtotal_Prod__c = oli.Quantidade__c;
                                    //pbUpdate.Diferencia__c =  oli.Quantidade__c *-1;
                                    pbUpdate.Setor__c = o.Setor__c;
                                    pbUpdate.Tipo_de_necesidad__c = oli.Tipo_de_necesidad__c;
                                    pbUpdate.Local_de_Entrega__c = oli.Local_de_Entrega__c;
                                    pbUpdate.Fecha_de_entrega__c = oli.Fecha_de_entrega__c;
                                    ////if (pbUpdate.Setor__c == 'Desarrollo'){
                                    ////pbUpdate.Fecha_de_entrega__c = oli.Fecha_de_entrega__c;
                                    //pbUpdate.Tipo_de_necesidad__c = oli.Tipo_de_necesidad__c;
                                    //pbUpdate.Local_Origem__c = oli.Local_Origem__c;
                                    ////}
                                    insert pbUpdate;
                                    /*
                                     if (pbUpdate.Setor__c == 'Comercial'){
                                     pbs.put(pbUpdate.Marca__c + pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Epoca_de_Plantio__c + pbUpdate.Setor__c + String.ValueOf(pbUpdate.Variedade__r.Id) + String.ValueOf(pbUpdate.Categoria__r.Id), pbUpdate);
                                     }else{
                                     pbs.put(pbUpdate.Marca__c + pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Epoca_de_Plantio__c + pbUpdate.Setor__c + pbUpdate.Tipo_de_Necesidad__c + pbUpdate.Local_Origem__c + String.ValueOf(pbUpdate.Variedade__r.Id) + String.ValueOf(pbUpdate.Categoria__r.Id), pbUpdate);
                                     }
                                     */
                                    pbs.put(pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Setor__c + pbUpdate.Tipo_de_Necesidad__c + pbUpdate.Local_de_Entrega__c + String.ValueOf(oli.PricebookEntry.Product2.Variedade__r.Id)+String.ValueOf(oli.PricebookEntry.Product2.Categ__r.Id), pbUpdate);
                                }
                            }
                            if (o.RecordTypeId == rt_PBC || o.RecordTypeId == rt_PBD){
                                if (o.Tipo_de_Operacion__c == '5-Realocação'){
                                    pbUpdate.Com_5_Relocalizacion__c = pbUpdate.Com_5_Relocalizacion__c + (oli.Quantidade__c * mult);
                                } else{
                                    if (o.Tipo_de_Operacion__c == '6-Administração Excedente'){
                                        pbUpdate.Com_6_Adm_Exedente__c = pbUpdate.Com_6_Adm_Exedente__c + (oli.Quantidade__c * mult);
                                    } else{
                                        //pbUpdate.put('Com_' + o.Tipo_de_Operacion__c.left(1) + '_' + (o.Tipo_de_Operacion__c.substring(3)).replace(' ', '_') + '__c', Double.ValueOf(pbUpdate.get('Com_' + o.Tipo_de_Operacion__c.left(1) + '_' + (o.Tipo_de_Operacion__c.substring(3)).replace(' ', '_') + '__c')) + oli.Quantidade__c);
                                        if (o.Tipo_de_Operacion__c == '1-Pedido'){
                                            pbUpdate.Com_1_Pedido__c = pbUpdate.Com_1_Pedido__c + (oli.Quantidade__c * mult);
                                        } else{
                                            if (o.Tipo_de_Operacion__c == '2-Pedido Complementar'){
                                                pbUpdate.Com_2_Pedido_Complementar__c = pbUpdate.Com_2_Pedido_Complementar__c + (oli.Quantidade__c * mult);
                                            } else{
                                                if (o.Tipo_de_Operacion__c == '3-Ajuste'){
                                                    pbUpdate.Com_3_Ajuste__c = pbUpdate.Com_3_Ajuste__c + (oli.Quantidade__c * mult);
                                                } else{
                                                    if (o.Tipo_de_Operacion__c == '4-Cancelamento'){
                                                        pbUpdate.Com_4_Cancelamiento__c = pbUpdate.Com_4_Cancelamiento__c + (oli.Quantidade__c * mult);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                /*
                                 if((o.Tipo_de_Operacion__c == '1-Pedido' || o.Tipo_de_Operacion__c == '2-Pedido Complementar' || o.Tipo_de_Operacion__c == '3-Ajuste') && oli.Data__c != null){
                                 if(pbUpdate.Fecha_de_necesidad__c == null){
                                 pbUpdate.Fecha_de_necesidad__c = oli.Data__c;
                                 }else{
                                 if (oli.Data__c > pbUpdate.Fecha_de_necesidad__c)
                                 pbUpdate.Fecha_de_necesidad__c = oli.Data__c;
                                 }
                                 }
                                 */
                                //if((o.RecordTypeId == rt_PBC || o.RecordTypeId == rt_PBD) && oli.Data__c != null)
                                pbUpdate.Fecha_de_Necesidad__c = oli.Data__c;
                                pbUpdate.Subtotal_Comercial__c = pbUpdate.Subtotal_Comercial__c + (oli.Quantidade__c * mult);
                            }
                            if (o.RecordTypeId == rt_PBP){
                                if (o.Tipo_de_Operacion__c == '1-Pedido' || o.Tipo_de_Operacion__c == '2-Plantio' || o.Tipo_de_Operacion__c == '3-Estimativa' || o.Tipo_de_Operacion__c == '4-Colheita'){
                                    //pbUpdate.put('Prod_' + o.Tipo_de_Operacion__c.left(1) + '_' + (o.Tipo_de_Operacion__c.substring(3)).replace(' ', '_') + '__c', Double.ValueOf(pbUpdate.get('Com_' + o.Tipo_de_Operacion__c.left(1) + '_' + (o.Tipo_de_Operacion__c.substring(3)).replace(' ', '_') + '__c')) + oli.Quantidade__c);
                                    if (o.Tipo_de_Operacion__c == '1-Pedido'){
                                        pbUpdate.Prod_1_Pedido__c = pbUpdate.Prod_1_Pedido__c + (oli.Quantidade__c * mult);
                                        pbUpdate.Subtotal_Prod__c = pbUpdate.Prod_1_Pedido__c;
                                    } else{
                                        if (o.Tipo_de_Operacion__c == '2-Plantio'){
                                            pbUpdate.Prod_2_Plantio__c = pbUpdate.Prod_2_Plantio__c + (oli.Quantidade__c * mult);
                                            pbUpdate.Subtotal_Prod__c = pbUpdate.Prod_2_Plantio__c;
                                        } else{
                                            if (o.Tipo_de_Operacion__c == '3-Estimativa'){
                                                //pbUpdate.Prod_3_Estimativa__c = pbUpdate.Prod_3_Estimativa__c + (oli.Quantidade__c * mult);
                                                pbUpdate.Prod_3_Estimativa__c = oli.Quantidade__c * mult;
                                                pbUpdate.Subtotal_Prod__c = pbUpdate.Prod_3_Estimativa__c;
                                            } else{
                                                if (o.Tipo_de_Operacion__c == '4-Colheita'){
                                                    pbUpdate.Prod_4_Colheita__c = pbUpdate.Prod_4_Colheita__c + (oli.Quantidade__c * mult);
                                                    pbUpdate.Subtotal_Prod__c = pbUpdate.Prod_4_Colheita__c;
                                                }
                                            }
                                        }
                                    }
                                    //pbUpdate.Subtotal_Prod__c = oli.Quantidade__c;
                                } else{
                                    if (o.Tipo_de_Operacion__c == '5-Beneficiamento' || o.Tipo_de_Operacion__c == '6-Armazenagem' || o.Tipo_de_Operacion__c == '7-Descarte' || o.Tipo_de_Operacion__c == '8-Cessão'){
                                        if (o.Tipo_de_Operacion__c == '8-Cessão'){
                                            pbUpdate.Prod_8_Cessao__c = pbUpdate.Prod_8_Cessao__c + (oli.Quantidade__c * mult);
                                        } else{
                                            //pbUpdate.put('Prod_' + o.Tipo_de_Operacion__c.left(1) + '_' + (o.Tipo_de_Operacion__c.substring(3)).replace(' ', '_') + '__c', Double.ValueOf(pbUpdate.get('Com_' + o.Tipo_de_Operacion__c.left(1) + '_' + (o.Tipo_de_Operacion__c.substring(3)).replace(' ', '_') + '__c')) + oli.Quantidade__c);
                                            if (o.Tipo_de_Operacion__c == '5-Beneficiamento'){
                                                pbUpdate.Prod_5_Beneficiamento__c = pbUpdate.Prod_5_Beneficiamento__c + (oli.Quantidade__c * mult);
                                                pbUpdate.Subtotal_Prod__c = pbUpdate.Prod_5_Beneficiamento__c;
                                            } else{
                                                if (o.Tipo_de_Operacion__c == '6-Armazenagem'){
                                                    pbUpdate.Prod_6_Armazenagem__c = pbUpdate.Prod_6_Armazenagem__c + (oli.Quantidade__c * mult);
                                                    pbUpdate.Subtotal_Prod__c = (pbUpdate.Prod_6_Armazenagem__c * 0.75).divide(1, 0, System.RoundingMode.UP)+pbUpdate.Prod_5_Beneficiamento__c;
                                                } else{
                                                    if (o.Tipo_de_Operacion__c == '7-Descarte'){
                                                        pbUpdate.Prod_7_Descarte__c = pbUpdate.Prod_7_Descarte__c + (oli.Quantidade__c * mult);
                                                    }
                                                }
                                            }
                                        }
                                        //pbUpdate.Subtotal_Prod__c = pbUpdate.Prod_5_Beneficiamento__c;
                                    } else{
                                        if (o.Tipo_de_Operacion__c == '9-Certificação'){
                                            pbUpdate.Prod_9_Certificacion__c = pbUpdate.Prod_9_Certificacion__c + (oli.Quantidade__c * mult);
                                            pbUpdate.Subtotal_Prod__c = pbUpdate.Prod_9_Certificacion__c;
                                        }
                                    }
                                }
                                /*
                                 if(pbUpdate.Fecha_de_entrega__c == null){
                                 pbUpdate.Fecha_de_entrega__c = oli.Fecha_de_entrega__c;
                                 }else{
                                 if (oli.Fecha_de_entrega__c != null && oli.Fecha_de_entrega__c > pbUpdate.Fecha_de_entrega__c)
                                 pbUpdate.Fecha_de_entrega__c = oli.Fecha_de_entrega__c;
                                 }
                                 */
                                //if (oli.Fecha_de_entrega__c != null)
                                pbUpdate.Fecha_de_entrega__c = oli.Fecha_de_entrega__c;
                            }
                            pbUpdate.Diferencia__c = pbUpdate.Subtotal_Prod__c - pbUpdate.Subtotal_Comercial__c;
                            /*
                             if (pbUpdate.Setor__c == 'Comercial'){
                             pbs.remove(pbUpdate.Marca__c + pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Epoca_de_Plantio__c + pbUpdate.Setor__c + String.ValueOf(pbUpdate.Variedade__r.Id) + String.ValueOf(pbUpdate.Categoria__r.Id));
                             pbs.put(pbUpdate.Marca__c + pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Epoca_de_Plantio__c + pbUpdate.Setor__c + String.ValueOf(pbUpdate.Variedade__r.Id) + String.ValueOf(pbUpdate.Categoria__r.Id), pbUpdate);
                             }else{
                             pbs.remove(pbUpdate.Marca__c + pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Epoca_de_Plantio__c + pbUpdate.Setor__c + pbUpdate.Tipo_de_Necesidad__c + pbUpdate.Local_Origem__c + String.ValueOf(pbUpdate.Variedade__r.Id) + String.ValueOf(pbUpdate.Categoria__r.Id));
                             pbs.put(pbUpdate.Marca__c + pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Epoca_de_Plantio__c + pbUpdate.Setor__c + pbUpdate.Tipo_de_Necesidad__c + pbUpdate.Local_Origem__c + String.ValueOf(pbUpdate.Variedade__r.Id) + String.ValueOf(pbUpdate.Categoria__r.Id), pbUpdate);
                             }
                             */
                            pbs.remove(pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Setor__c + pbUpdate.Tipo_de_Necesidad__c + pbUpdate.Local_de_Entrega__c + String.ValueOf(oli.PricebookEntry.Product2.Variedade__r.Id)+String.ValueOf(oli.PricebookEntry.Product2.Categ__r.Id));
                            pbs.put(pbUpdate.Region__c + pbUpdate.Safra__c + pbUpdate.Setor__c + pbUpdate.Tipo_de_Necesidad__c + pbUpdate.Local_de_Entrega__c + String.ValueOf(oli.PricebookEntry.Product2.Variedade__r.Id)+String.ValueOf(oli.PricebookEntry.Product2.Categ__r.Id), pbUpdate);
                        }
                    }
                }
            }
            if (pbs.Size() > 0)
                upsert pbs.values();
        }

        /*
         for(Opportunity o : oppsNew){
         if(o.RecordTypeId == rt_PBC && o.StageName == 'PB-Aprobada'){
         if(opOld.StageName == 'PB-Aprobada Parcial'){
         Savepoint sp;
         Opportunity OppClone = New Opportunity();
         List<OpportunityLineItem> OppCloneOLI = New List<OpportunityLineItem>();

         try{
         sp = Database.setSavepoint();
         OppClone = o.clone(false,true);
         OppClone.RecordTypeId = rt_PBP;
         if(Test.isRunningTest())
         OppClone.StageName = 'PB-Pendiente';

         OppClone.Notificado__c = true;
         if(usProd != null)
         OppClone.OwnerId = usProd;
         insert OppClone;
         if(o.HasOpportunityLineItem){
         String soqlOLI = previsionesController.getCreatableFieldsSOQL('OpportunityLineItem','OpportunityId=\'' + o.Id + '\'');
         List<OpportunityLineItem> pbcOLI = (List<OpportunityLineItem>)Database.query(soqlOLI);
         for(OpportunityLineItem oli : pbcOLI){
         OpportunityLineItem oliClone = oli.clone(false,true);
         oliClone.OpportunityId = OppClone.Id;
         oliClone.TotalPrice = null;
         OppCloneOLI.Add(oliClone);
         }
         insert OppCloneOLI;
         }

         }catch(exception e){}
         }

         }
         }
         */
        retorno[0] = 'OK';
        retorno[1] = 'OK';
        //retorno[1] = String.ValueOf(mapaOli.Size());
        return retorno;
    }

    //agregado JERE para verificar Variedades del Anexo IV contra Anexo III
    public static string[] validarAnexo4(List<OpportunityLineItem> olis){
        String[] retorno = New String[2];
        retorno[0] = 'OK';
        retorno[1] = 'OK';
        String mens = 'OK';
        Boolean hayAnexoAValidar = false;

        Set<Id> opIds = New Set<Id>();
        Set<Id> accIds = New Set<Id>();
        Set<Id> catIds = New Set<Id>();
        Set<Id> pbeIds = New Set<Id>();
        Set<String> safra = New Set<String>();
        Set<String> varCatCargadas = New Set<String>();
        Map<String, Opportunity> mapOpRT = New Map<String, Opportunity>();
        Map<String, String> mapCatName = New Map<String, String>();
        Map<String, String> mapProdName = New Map<String, String>();
        Map<String, Double> mapCantAIII = New Map<String, Double>();

        for (OpportunityLineItem oli : olis){
            opIds.add(oli.OpportunityId);
            catIds.add(oli.Categoria__c);
            pbeIds.add(oli.PricebookEntryId);
        }

        for (Categoria__c c : [Select Id, Name
                               From Categoria__c 
                               Where Id In :catIds])
            mapCatName.put(c.Id, c.Name);
        for (PricebookEntry pbe : [Select Id, Product2.Variedade__r.Name
                                   From PricebookEntry 
                                   Where Id In :pbeIds])
            mapProdName.put(pbe.Id, pbe.Product2.Variedade__r.Name);
        for (Opportunity o : [SELECT Id, RecordType.Name, AccountId, Safra__c, Marca__c
                              FROM Opportunity
                              WHERE Id IN :opIds and RecordType.Name = 'Anexo IV']){
            hayAnexoAValidar = true;
            mapOpRT.put(o.Id, o);
            accids.add(o.AccountId);
            safra.add(o.Safra__c);
        }

        if (!hayanexoAValidar)
            return retorno;
        for (OpportunityLineItem oli : [SELECT Id, OpportunityId, Opportunity.RecordType.Name, Opportunity.AccountId, Opportunity.Safra__c, Opportunity.Marca__c, PricebookEntryId, Categoria__c, Semente_aprovada__c, Semente_comercializada__c, Semente_uso_propio__c
                                        FROM OpportunityLineItem
                                        WHERE Opportunity.Safra__c IN :safra AND Opportunity.AccountId IN :accIds AND Opportunity.RecordType.Name = 'Anexo III' AND Opportunity.StageName = 'Aprobada' AND IsDeleted = false]){
            varCatCargadas.add(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));

            /*
             if (!mapCantAIII.containsKey(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c+oli.Opportunity.Marca__c+
             String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))){
             mapCantAIII.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c+oli.Opportunity.Marca__c+
             String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c), oli.Semente_aprovada__c - oli.Semente_comercializada__c - oli.Semente_uso_propio__c);
             }else{
             Double cant = mapCantAIII.get(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c+oli.Opportunity.Marca__c+
             String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
             mapCantAIII.remove(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c+oli.Opportunity.Marca__c+
             String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
             mapCantAIII.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c+oli.Opportunity.Marca__c+
             String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c), oli.Semente_aprovada__c - oli.Semente_comercializada__c - oli.Semente_uso_propio__c + cant);
             }
             */
        }

        Opportunity opp;
        for (OpportunityLineItem oli : olis){
            opp = mapOpRT.get(oli.OpportunityId);
            if (!varCatCargadas.Contains(String.ValueOf(opp.AccountId)+opp.Safra__c + opp.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))){
                //mens = 'As Categorias ingressadas não foram aprovadas em um anexo anterior.';
                //mens = 'As Categorias ingressadas não foram aprovadas em um anexo anterior: ';
                mens += mapProdName.get(oli.PricebookEntryId)+' ' + mapCatName.get(oli.Categoria__c)+' ';
            }

            /*
             Double cantAIII = 0;
             if(mapCantAIII.get(String.ValueOf(opp.AccountId)+opp.Safra__c+opp.Marca__c+String.ValueOf(oli.PricebookEntryId)+
             String.ValueOf(oli.Categoria__c)) != null){
             cantAIII = mapCantAIII.get(String.ValueOf(opp.AccountId)+opp.Safra__c+opp.Marca__c+String.ValueOf(oli.PricebookEntryId)+
             String.ValueOf(oli.Categoria__c));
             }
             if ((oli.Semente_comercializada__c + oli.Semente_uso_propio__c + oli.Descarte__c) > cantAIII){
             mens = 'As Categorias ingressadas superan Anexo III: ';
             mens += mapProdName.get(oli.PricebookEntryId) + ' ' + mapCatName.get(oli.Categoria__c);
             retorno[0] = mens;
             retorno[1] = '';
             return retorno;
             }
             */
        }
        if (mens != 'OK')
            mens = 'As Categorias ingressadas não foram aprovadas em um anexo anterior: ' + mens.substring(2, mens.length());
        if (mens != 'OK'){
            retorno[0] = mens;
            retorno[1] = '';
        }
        return retorno;
    }

    public static string[] validarVarCatAnexo(List<OpportunityLineItem> olis){
        /////////////////////////////////////////////////////////////////////////////
        //SE COMENTA A PEDIDO DE SANTIAGO. LUEGO SE VA A VOLVER A HABILITAR!!!!!/////
        /////////////////////////////////////////////////////////////////////////////

        String[] retorno = New String[2];
        retorno[0] = 'OK';
        retorno[1] = 'OK';
        String mens = 'OK';
        Boolean hayAnexoAValidar = false;
        Boolean validarAV = false;
        List<OpportunityLineItem> oplis = New List<OpportunityLineItem>();
        Set<Id> opIds = New Set<Id>();
        Set<Id> opliIds = New Set<Id>();
        Set<Id> accIds = New Set<Id>();
        Set<String> safra = New Set<String>();
        Set<String> varCatCargadas = New Set<String>();
        Set<String> pbe = New Set<String>();
        Set<String> cats = New Set<String>();
        Set<String> aIII = New Set<String>();
        Set<String> aII = New Set<String>();
        Map<String, Opportunity> mapOpRT = New Map<String, Opportunity>();
        Map<String, String> mapPBE = New Map<String, String>();
        Map<String, String> mapPBEId = New Map<String, String>();
        Map<String, String> mapCat = New Map<String, String>();
        Map<String, String> mapVarCatPermitidos = New Map<String, String>();
        Map<String, Double> mapVarCatCantDest = New Map<String, Double>();
        Map<String, Double> mapVarCatCantOrig = New Map<String, Double>();
        Map<String, Double> mapVarCatCantDestHa = New Map<String, Double>();
        Map<String, Double> mapVarCatCantOrigHa = New Map<String, Double>();
        Map<String, Double> mapHaAI = New Map<String, Double>();
        Map<String, Double> mapHaAII = New Map<String, Double>();
        Map<String, Double> mapBrutAII = New Map<String, Double>();
        Map<String, Double> mapBrutAIII = New Map<String, Double>();
        Map<String, Double> mapBenfAIII = New Map<String, Double>();
        Map<String, Double> mapCantParaValidAnexoV = New Map<String, Double>();
        Map<String, Double> mapCantAnexoV = New Map<String, Double>();
        Map<String, Double> mapCantAnexoIII = New Map<String, Double>();
        Double sumSemente = 0;
        Double sumBenef = 0;
        Double sumBruta = 0;
        Double sumRebaja = 0;
        Double sumHaAut = 0;
        Double sumHaPl = 0;
        Double sumBrutAII;
        Double sumBrutaAIIIActual = 0;
        //for(OpportunityLineItem oli : olis) opIds.add(oli.OpportunityId);
        for (OpportunityLineItem oli : olis){
            opIds.add(oli.OpportunityId);
            opliIds.add(oli.Id);
            pbe.add(oli.PricebookEntryId);
            cats.add(oli.Categoria__c);
        }

        for (Opportunity o : [SELECT Id, RecordType.Name, AccountId, Safra__c, Marca__c
                              FROM Opportunity
                              WHERE Id IN :opIds]){
            if (o.RecordType.Name == 'Anexo II' || o.RecordType.Name == 'Anexo I Rebaixamento Ha' || o.RecordType.Name == 'Anexo II Rebaixamento Sacas' || o.RecordType.Name == 'Anexo III' || o.RecordType.Name == 'Anexo V'){
                hayAnexoAValidar = true;
                mapOpRT.put(o.Id, o);
                //mapOli.put(oli.Id, oli);
                accids.add(o.AccountId);
                safra.add(o.Safra__c);
                if (o.RecordType.Name == 'Anexo II')
                    aII.add(o.Id);
                if (o.RecordType.Name == 'Anexo III')
                    aIII.add(o.Id);
                if (o.RecordType.Name == 'Anexo V')
                    validarAV = true;
            }
        }
        if (hayAnexoAValidar){
            for (PricebookEntry pbke : [SELECT Id, Product2.Variedade__r.Name
                                        FROM PricebookEntry 
                                        WHERE Id IN :pbe]){
                mapPBE.put(pbke.Id, pbke.Product2.Variedade__r.Name);
                mapPBEId.put(pbke.Id, pbke.Product2.Variedade__r.Id);
            }
            for (Categoria__c cate : [SELECT Id, Name
                                      FROM Categoria__c 
                                      WHERE Id IN :cats])
                mapCat.put(cate.Id, cate.Name);
            for (OpportunityLineItem oli : [SELECT Id, OpportunityId, Opportunity.RecordType.Name, Opportunity.AccountId, Opportunity.Safra__c, Opportunity.Marca__c, PricebookEntryId, PriceBookEntry.Product2.Variedade__c, Categoria__c, Categoria_a_Rebaixar__c, Sem_Rebajada__c, Semente_comercializada__c, Semente_uso_propio__c, Area__c, Area_Plantada__c
                                            FROM OpportunityLineItem
                                            WHERE Opportunity.Safra__c IN :safra AND Opportunity.AccountId IN :AccIds AND Opportunity.RecordType.Name IN ('Anexo I Rebaixamento Ha', 'Anexo II Rebaixamento Sacas', 'Anexo I', 'Anexo II', 'Anexo III', 'Anexo IV') AND Opportunity.StageName = 'Aprobada' AND IsDeleted = false]){
                if (oli.Opportunity.RecordType.Name == 'Anexo I Rebaixamento Ha' || oli.Opportunity.RecordType.Name == 'Anexo II Rebaixamento Sacas'){
                    varCatCargadas.add(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + oli.Opportunity.RecordType.Name + String.ValueOf(oli.PriceBookEntryId)+String.ValueOf(oli.Categoria__c));
                } else{
                    varCatCargadas.add(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + oli.Opportunity.RecordType.Name + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                }
                if (oli.Opportunity.RecordType.Name == 'Anexo II Rebaixamento Sacas'){
                    if (mapVarCatCantDest.ContainsKey(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))){
                        sumSemente = 0;
                        sumSemente = mapVarCatCantDest.get(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))+oli.Sem_Rebajada__c;
                        mapVarCatCantDest.remove(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                        mapVarCatCantDest.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c), sumSemente);
                    } else{
                        mapVarCatCantDest.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c), oli.Sem_Rebajada__c);
                    }
                    if (mapVarCatCantOrig.ContainsKey(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria_a_Rebaixar__c))){
                        sumSemente = 0;
                        sumSemente = mapVarCatCantOrig.get(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria_a_Rebaixar__c))+oli.Sem_Rebajada__c;
                        mapVarCatCantOrig.remove(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria_a_Rebaixar__c));
                        mapVarCatCantOrig.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria_a_Rebaixar__c), sumSemente);
                    } else{
                        mapVarCatCantOrig.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria_a_Rebaixar__c), oli.Sem_Rebajada__c);
                    }
                }
                if (oli.Opportunity.RecordType.Name == 'Anexo I Rebaixamento Ha'){
                    if (mapVarCatCantDestHa.ContainsKey(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))){
                        sumSemente = 0;
                        sumSemente = mapVarCatCantDestHa.get(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))+oli.Area__c;
                        mapVarCatCantDestHa.remove(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                        mapVarCatCantDestHa.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c), sumSemente);
                    } else{
                        mapVarCatCantDestHa.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c), oli.Area__c);
                    }
                    if (mapVarCatCantOrigHa.ContainsKey(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria_a_Rebaixar__c))){
                        sumSemente = 0;
                        sumSemente = mapVarCatCantOrigHa.get(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria_a_Rebaixar__c))+oli.Area__c;
                        mapVarCatCantOrigHa.remove(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria_a_Rebaixar__c));
                        mapVarCatCantOrigHa.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria_a_Rebaixar__c), sumSemente);
                    } else{
                        mapVarCatCantOrigHa.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria_a_Rebaixar__c), oli.Area__c);
                    }
                }
                if (oli.Opportunity.RecordType.Name == 'Anexo III' || oli.Opportunity.RecordType.Name == 'Anexo IV'){
                    if (mapCantParaValidAnexoV.ContainsKey(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c))){
                        sumSemente = 0;
                        sumSemente = mapCantParaValidAnexoV.get(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c))+oli.Semente_comercializada__c + oli.Semente_uso_propio__c;
                        mapCantParaValidAnexoV.remove(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c));
                        mapCantParaValidAnexoV.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c), sumSemente);
                    } else{
                        mapCantParaValidAnexoV.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c), (oli.Semente_comercializada__c + oli.Semente_uso_propio__c));
                    }
                }
                if (oli.Opportunity.RecordType.Name == 'Anexo I'){
                    //system.debug('ENTRO1');
                    if (mapHaAI.ContainsKey(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntryId)+String.ValueOf(oli.Categoria__c))){
                        sumSemente = 0;
                        sumSemente = mapHaAI.get(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntryId)+String.ValueOf(oli.Categoria__c))+oli.Area__c;
                        mapHaAI.remove(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntryId)+String.ValueOf(oli.Categoria__c));
                        mapHaAI.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntryId)+String.ValueOf(oli.Categoria__c), sumSemente);
                    } else{
                        mapHaAI.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntryId)+String.ValueOf(oli.Categoria__c), oli.Area__c);
                    }
                }
            }
            //Se le saca el "AND Opportunity.StageName NOT IN('Desaprobado x Gerente', 'Rechazada Supervisor')" ya que las Opp con esas ETAPAS se pueden reingresar en el proceso de aprobación. Hay analizarlo en caso de que se presente algún problema.
            //for(OpportunityLineItem oli: [SELECT Id, OpportunityId, Opportunity.RecordType.Name, Opportunity.AccountId, Opportunity.Safra__c, Opportunity.Marca__c, PricebookEntryId, PriceBookEntry.Product2.Variedade__c, Categoria__c, Semente_Bruta__c, Semente_Beneficiada__c FROM OpportunityLineItem WHERE Opportunity.Safra__c IN : safra AND Opportunity.AccountId IN: AccIds AND Opportunity.RecordType.Name IN ('Anexo III','Anexo II') AND Opportunity.StageName NOT IN('Desaprobado x Gerente', 'Rechazada Supervisor') AND OpportunityId NOT IN :aIII AND OpportunityId NOT IN :aII]){
            //COMENTADO JUAN 01/12/2016 for(OpportunityLineItem oli: [SELECT Id, OpportunityId, Opportunity.RecordType.Name, Opportunity.AccountId, Opportunity.Safra__c, Opportunity.Marca__c, PricebookEntryId, PriceBookEntry.Product2.Variedade__c, Categoria__c, Semente_Bruta__c, Semente_Beneficiada__c, Area_Plantada__c FROM OpportunityLineItem WHERE OpportunityLineItem.isDeleted = false AND Opportunity.Safra__c IN : safra AND Opportunity.AccountId IN: AccIds AND Opportunity.RecordType.Name IN ('Anexo III','Anexo II') AND OpportunityId NOT IN :aIII AND OpportunityId NOT IN :aII]){
            for (OpportunityLineItem oli : [SELECT Id, OpportunityId, Opportunity.RecordType.Name, Opportunity.AccountId, Opportunity.Safra__c, Opportunity.Marca__c, PricebookEntryId, PriceBookEntry.Product2.Variedade__c, Categoria__c, Semente_Bruta__c, Semente_Beneficiada__c, Area_Plantada__c
                                            FROM OpportunityLineItem
                                            WHERE OpportunityLineItem.isDeleted = false AND Opportunity.Safra__c IN :safra AND Opportunity.AccountId IN :AccIds AND ((Opportunity.RecordType.Name = 'Anexo II' And Opportunity.StageName = 'Aprobada') Or Opportunity.RecordType.Name = 'Anexo III') AND Id NOT IN :opliIds]){
                if (oli.Opportunity.RecordType.Name == 'Anexo III'){
                    if (mapBrutAIII.ContainsKey(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))){
                        sumSemente = 0;
                        sumSemente = mapBrutAIII.get(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))+oli.Semente_Bruta__c;
                        mapBrutAIII.remove(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                        mapBrutAIII.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c), sumSemente);
                        sumSemente = 0;
                        sumSemente = mapBenfAIII.get(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))+oli.Semente_Beneficiada__c;
                        mapBenfAIII.remove(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                        mapBenfAIII.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c), sumSemente);

                    } else{
                        mapBrutAIII.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c), oli.Semente_Bruta__c);
                        mapBenfAIII.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c), oli.Semente_Beneficiada__c);
                    }
                } else{
                    if (oli.Opportunity.RecordType.Name == 'Anexo II'){
                        if (mapHaAII.ContainsKey(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)+String.ValueOf(oli.Categoria__c))){
                            sumSemente = 0;
                            sumSemente = mapHaAII.get(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)+String.ValueOf(oli.Categoria__c))+oli.Area_Plantada__c;
                            mapHaAII.remove(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)+String.ValueOf(oli.Categoria__c));
                            mapHaAII.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)+String.ValueOf(oli.Categoria__c), sumSemente);
                        } else{
                            mapHaAII.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntry.Product2.Variedade__c)+String.ValueOf(oli.Categoria__c), oli.Area_Plantada__c);
                        }
                        if (mapBrutAII.ContainsKey(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntryId)+String.ValueOf(oli.Categoria__c))){
                            sumSemente = 0;
                            sumSemente = mapBrutAII.get(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntryId)+String.ValueOf(oli.Categoria__c))+oli.Semente_Bruta__c;
                            mapBrutAII.remove(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntryId)+String.ValueOf(oli.Categoria__c));
                            mapBrutAII.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntryId)+String.ValueOf(oli.Categoria__c), sumSemente);
                        } else{
                            mapBrutAII.put(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c + oli.Opportunity.Marca__c + String.ValueOf(oli.PriceBookEntryId)+String.ValueOf(oli.Categoria__c), oli.Semente_Bruta__c);
                        }
                    }
                }
            }
            for (OpportunityLineItem oli : olis){
                if (mapOpRT.get(String.ValueOf(oli.OpportunityId)).RecordType.Name == 'Anexo V'){
                    //system.debug('ENTRO2!!!!!');
                    if (mapCantAnexoV.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId)))){
                        sumSemente = 0;
                        sumSemente = mapCantAnexoV.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId)))+oli.Semente_comercializada__c;
                        mapCantAnexoV.remove(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId)));
                        mapCantAnexoV.put(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId)), sumSemente);
                    } else{
                        mapCantAnexoV.put(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId)), oli.Semente_comercializada__c);
                    }
                }
                if (mapOpRT.get(String.ValueOf(oli.OpportunityId)).RecordType.Name == 'Anexo III'){
                    system.debug('ENTRO----1!!!!!');
                    System.debug('TAMAÑO!!!!!!  ' + String.ValueOf(olis.size()));
                    if (mapCantAnexoIII.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId))+String.ValueOf(oli.Categoria__c))){
                        sumSemente = 0;
                        sumSemente = mapCantAnexoIII.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId))+String.ValueOf(oli.Categoria__c))+oli.Semente_Bruta__c;
                        system.debug('suma: ' + String.ValueOf(sumSemente));
                        mapCantAnexoIII.remove(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId))+String.ValueOf(oli.Categoria__c));
                        mapCantAnexoIII.put(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId))+String.ValueOf(oli.Categoria__c), sumSemente);
                    } else{
                        mapCantAnexoIII.put(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId))+String.ValueOf(oli.Categoria__c), oli.Semente_Bruta__c);
                    }
                    system.debug('suma: ' + String.ValueOf(mapCantAnexoIII.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId))+String.ValueOf(oli.Categoria__c))));
                }
            }
            if (varCatCargadas.Size() == 0 && !Test.isRunningTest()){
                retorno[0] = 'As Variedades ingressadas não foram aprovadas em um anexo anterior.';
                return retorno;
            }

            for (OpportunityLineItem oli : olis){
                if (mapOpRT.get(oli.OpportunityId).RecordType.Name == 'Anexo II'){
                    //retorno[0] = String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c+mapOpRT.get(oli.OpportunityId).Marca__c+'Anexo I'+String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c);
                    //return retorno;
                    if (!varCatCargadas.Contains(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + 'Anexo I' + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c)) && !varCatCargadas.Contains(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + 'Anexo I Rebaixamento Ha' + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c)) && !Test.isRunningTest()){
                        //if(retorno[0] == 'OK'){retorno[0] = 'Existem variedades que não podem ser introduzidos.';}
                        if (mens == 'OK'){
                            mens = 'Existem variedades que não podem ser introduzidos. \r\n';
                        }
                        //retorno[0] += '\r\n' + mapOli.get(oli.Id).PricebookEntry.Product2.Variedade__r.Name+mapOli.get(oli.Id).Categoria__r.Name;
                        mens += mapPBE.get(oli.PricebookEntryId)+' ' + mapCat.get(oli.Categoria__c)+'\r\n';
                    }
                    sumHaAut = 0;
                    sumHaPl = 0;
                    if (mapHaAII.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))){
                        //system.debug('ENTRO2');
                        sumHaPl = mapHaAII.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                    }
                    if (mapHaAI.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))){
                        //system.debug('ENTRO3');
                        sumHaAut = mapHaAI.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                    }
                    if (mapVarCatCantOrigHa.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c)))
                        sumHaAut -= mapVarCatCantOrigHa.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                    if (mapVarCatCantDestHa.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c)))
                        sumHaAut += mapVarCatCantDestHa.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                    //system.debug('Validación:(' + String.ValueOf(oli.Area_Plantada__c)+ '+'+String.ValueOf(sumHaPl)+') > '+String.ValueOf(sumHaAut));

                    if (((oli.Area_Plantada__c + sumHaPl) > sumHaAut && !Test.isRunningTest())){
                        if (mens == 'OK'){
                            retorno[0] = 'Existem variedades que não podem ser introduzidos. ';
                        }
                        mens += mapPBE.get(oli.PricebookEntryId)+' ' + mapCat.get(oli.Categoria__c)+' - a quantidade de Hectares Semeadas não pode superar a quantidade de Hectares Autorizados + Rebaixamentos \r\n';
                    }
                } else{
                    if (mapOpRT.get(oli.OpportunityId).RecordType.Name == 'Anexo III'){
                        if (!varCatCargadas.Contains(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + 'Anexo II' + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c)) && !varCatCargadas.Contains(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + 'Anexo II Rebaixamento Sacas' + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c)) && !Test.isRunningTest()){
                            if (mens == 'OK'){
                                mens = 'Existem variedades que não podem ser introduzidos. \r\n';
                            }
                            mens += mapPBE.get(oli.PricebookEntryId)+' ' + mapCat.get(oli.Categoria__c)+'\r\n';
                        }
                        if (oli.Semente_aprovada__c < (oli.Semente_uso_propio__c + oli.Semente_comercializada__c)){
                            if (mens == 'OK'){
                                mens = 'Existem variedades que não podem ser introduzidos. \r\n';
                            }
                            mens += mapPBE.get(oli.PricebookEntryId)+' ' + mapCat.get(oli.Categoria__c)+' - O volume de semente comercializada mais uso próprio não pode superar o de semente aprovada. \r\n';
                        }
                        if (oli.Semente_beneficiada__c < oli.Semente_aprovada__c){
                            if (mens == 'OK'){
                                mens = 'Existem variedades que não podem ser introduzidos. \r\n';
                            }
                            mens += mapPBE.get(oli.PricebookEntryId)+' ' + mapCat.get(oli.Categoria__c)+' - O volume de semente aprovada não pode superar o de semente beneficiada. \r\n';
                        }
                        sumBruta = 0;
                        sumBenef = 0;
                        sumRebaja = 0;
                        sumBrutAII = 0;
                        sumBrutaAIIIActual = 0;
                        //if(mapBrutAIII.ContainsKey(String.ValueOf(oli.Opportunity.AccountId)+oli.Opportunity.Safra__c+oli.Opportunity.Marca__c+String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))){ ??????
                        if (mapCantAnexoIII.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId))+String.ValueOf(oli.Categoria__c))){
                            sumBrutaAIIIActual = mapCantAnexoIII.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId))+String.ValueOf(oli.Categoria__c));
                        }
                        system.debug('BUSQUEDA 1:   ' + String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(mapPBEId.get(oli.PriceBookEntryId))+String.ValueOf(oli.Categoria__c));
                        system.debug('sunBrutaAIIIActual:   ' + String.ValueOf(sumBrutaAIIIActual));
                        //system.debug('ENTRO----1!!!!!');
                        //system.debug('ENTRO----1!!!!!');
                        if (mapBrutAIII.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))){
                            sumBenef = mapBenfAIII.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                            sumBruta = mapBrutAIII.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                        }
                        if (mapVarCatCantOrig.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c)))
                            sumRebaja -= mapVarCatCantOrig.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                        if (mapVarCatCantDest.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c)))
                            sumRebaja += mapVarCatCantDest.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                        if (mapBrutAII.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c)))
                            sumBrutAII = mapBrutAII.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c + mapOpRT.get(oli.OpportunityId).Marca__c + String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c));
                        if (((Integer.ValueOf((sumBrutaAIIIActual + sumBruta)) > Integer.ValueOf(sumBrutAII)) || (Integer.ValueOf((sumBrutaAIIIActual + sumBruta)) < Integer.ValueOf(sumBrutAII))) && !Test.isRunningTest()){
                            system.debug('VALIDACION:   ' + String.ValueOf(sumBrutaAIIIActual)+' + ' + String.ValueOf(sumBruta)+' > ' + String.ValueOf(sumBrutAII));
                            if (mens == 'OK'){
                                mens = 'Existem variedades que não podem ser introduzidos. \r\n';
                            }
                            mens += mapPBE.get(oli.PricebookEntryId)+' ' + mapCat.get(oli.Categoria__c)+' - O Volume de Semente Bruta tem que ser igual ao Volume de Semente Bruta informado no Anexo II. \r\n' + 'sumBrutaAIIIActual: ' + sumBrutaAIIIActual + ' sumBruta: ' + sumBruta + ' sumBrutAII: ' + sumBrutAII;
                        }


                        if (((oli.Semente_beneficiada__c + sumBenef) > ((oli.Semente_bruta__c + sumBruta)+sumRebaja) && !Test.isRunningTest())){
                            if (mens == 'OK'){
                                mens = 'Existem variedades que não podem ser introduzidos. \r\n';
                            }
                            mens += mapPBE.get(oli.PricebookEntryId)+' ' + mapCat.get(oli.Categoria__c)+' - O Volume de Semente Beneficiada não pode superar ao Volume de Semente Bruta mais a semente informada no rebaixamento. \r\n';
                        }
                        //Se comenta este If porque si está en el primero.
                        //if(mapVarCatCantOrig.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c+mapOpRT.get(oli.OpportunityId).Marca__c+String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c))){
                        //if((oli.Semente_beneficiada__c + sumBenef) > ((oli.Semente_bruta__c + sumBruta) - mapVarCatCantOrig.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c+mapOpRT.get(oli.OpportunityId).Marca__c+String.ValueOf(oli.PricebookEntryId)+String.ValueOf(oli.Categoria__c)))){
                        //if(retorno[0] == 'OK'){retorno[0] = 'Existem variedades que não podem ser introduzidos. ';}
                        //retorno[0] += ' \r\n' + mapPBE.get(oli.PricebookEntryId)+' '+mapCat.get(oli.Categoria__c) + ' O volume de semente Beneficiada não pode superar o de semente bruta menos semente rebaixada';
                        //retorno[1] = '';
                        //}
                        //}
                    } else{
                        if (mapOpRT.get(oli.OpportunityId).RecordType.Name == 'Anexo V'){
                            system.debug('ENTROAV1!!!!!');
                            /* SE COMENTA ESTA VALIDACION PORQUE HAY QUE REPENSARLA
                             if(!mapCantParaValidAnexoV.ContainsKey(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c+mapOpRT.get(oli.OpportunityId).Marca__c+String.ValueOf(mapPBEId.get(oli.PriceBookEntryId))) && !Test.isRunningTest()){
                             if(mens == 'OK'){mens = 'Existem variedades que não podem ser introduzidos. \r\n';}
                            //retorno[0] += '\r\n' + mapOli.get(oli.Id).PricebookEntry.Product2.Variedade__r.Name+mapOli.get(oli.Id).Categoria__r.Name;
                             mens += mapPBE.get(oli.PricebookEntryId)+'\r\n';
                             }
                             system.debug(String.ValueOF(mapCantParaValidAnexoV.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c+mapOpRT.get(oli.OpportunityId).Marca__c+String.ValueOf(mapPBEId.get(oli.PriceBookEntryId)))) + ' > ' + String.ValueOf(mapCantAnexoV.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c+mapOpRT.get(oli.OpportunityId).Marca__c+String.ValueOf(mapPBEId.get(oli.PriceBookEntryId)))));
                             system.debug(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId) + mapOpRT.get(oli.OpportunityId).Safra__c+mapOpRT.get(oli.OpportunityId).Marca__c+String.ValueOf(mapPBEId.get(oli.PriceBookEntryId)) + ' > ' + String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c+mapOpRT.get(oli.OpportunityId).Marca__c+String.ValueOf(mapPBEId.get(oli.PriceBookEntryId)));
                             system.debug('Tamaño de mapCantAnexoV:    '+String.ValueOf(mapCantAnexoV.Size()));
                             if((mapCantParaValidAnexoV.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c+mapOpRT.get(oli.OpportunityId).Marca__c+String.ValueOf(mapPBEId.get(oli.PriceBookEntryId))) >                         mapCantAnexoV.get(String.ValueOf(mapOpRT.get(oli.OpportunityId).AccountId)+mapOpRT.get(oli.OpportunityId).Safra__c+mapOpRT.get(oli.OpportunityId).Marca__c+String.ValueOf(mapPBEId.get(oli.PriceBookEntryId)))) && !Test.isRunningTest()){
                             if(mens == 'OK'){mens = 'Existem variedades que não podem ser introduzidos.\r\n O Volume de Semente Comercializada não pode ser menor Volume de Semente Comercializada + Uso Proprio informada no Anexo III mais ao Volume informado no Anexo IV.\r\n';}
                             mens += mapPBE.get(oli.PricebookEntryId)+'\r\n';
                             }*/
                        }
                    }
                }
            }
        }
        if (mens != 'OK'){
            retorno[0] = mens;
            retorno[1] = '';
        }
        return retorno;
    }

    public static String[] validarNuevaPrevision(Opportunity opPB){
        Boolean hayPrevision = false;
        String[] retorno = New String[2];
        /*
         Map<String,RecordType> mapaTR = New Map<String,RecordType>();
         for(RecordType tr: [Select Id, Name, Description, SobjectType, IsActive from RecordType WHERE IsActive = true AND SobjectType = 'Opportunity' AND Name IN ('Previsao')]) mapaTR.put(String.ValueOf(tr.Id), tr);
         if(mapaTR.ContainsKey(String.ValueOf(opPB.RecordTypeId))){
         if (opPB.ownerId != '00540000001TUHM' && opPB.ownerId != '00540000001TNkC'){
         for(Opportunity opp : [SELECT Id, RecordTypeId, Name, OwnerId, Safra__c, Marca__c, AccountId FROM Opportunity WHERE Marca__c = :opPB.Marca__c AND Safra__c = :opPB.Safra__c AND AccountId = :opPB.AccountId AND OwnerId != '00540000001TUHM' AND OwnerId != '00540000001TNkC' AND RecordTypeId = :mapaTR.get(String.ValueOf(opPB.RecordTypeId)).Id]){
         hayPrevision = true;
         }
         }else{
         for(Opportunity opp : [SELECT Id, RecordTypeId, Name, OwnerId, Safra__c, Marca__c, AccountId FROM Opportunity WHERE Marca__c = :opPB.Marca__c AND Safra__c = :opPB.Safra__c AND AccountId = :opPB.AccountId AND (OwnerId = '00540000001TUHM' OR OwnerId = '00540000001TNkC') AND RecordTypeId = :mapaTR.get(String.ValueOf(opPB.RecordTypeId)).Id]){
         hayPrevision = true;
         }
         }
         if(hayPrevision && !Test.isRunningTest()){
         retorno[0] = 'Falha ao criar a oportunidade. Existe uma Opp desse tipo para a conta';
         retorno[1] = '';
         return retorno;
         }
         }
         */


        retorno[0] = 'OK';
        retorno[1] = 'OK';

        return retorno;
    }

    public static String[] validarNuevoAnexoI(Opportunity opPB){         
        Boolean hayContratoSinFirmar = false;
        String[] retorno = New String[2];                    

        Map<String, RecordType> mapaTR = New Map<String, RecordType>();
        // Map<String, String> mapaTR = New Map<String, String>();
        //Se reemplaza el uso de SOQL, para minimizar uso excesivo de SOQL
        //----------------------------------------------------------------
        for (RecordType tr : [Select Id, Name, Description, SobjectType, IsActive
                              from RecordType
                              WHERE IsActive = true AND SobjectType = 'Opportunity' AND Name IN ('Anexo I')])
            mapaTR.put(String.ValueOf(tr.Id), tr);

        // Map<String, Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        // for (String tr : rtMapByName.keySet()){
        //  if (tr == 'AnexoI'){
        //      mapaTR.put(rtMapByName.get(tr).getRecordTypeId(), tr);
        //  }
        // }


        //----------------------------------------------------------------
        if (mapaTR.ContainsKey(String.ValueOf(opPB.RecordTypeId))){
            for (Contrato__c cont : [Select Chegou_na_Brasmax__c
                                     From Contrato__c
                                     Where Multiplicador__c = :opPB.AccountId And Safra__c = :opPB.Safra__c And RecordType.Name = :opPB.Marca__c]){
                if (cont.Chegou_na_Brasmax__c == false){
                    hayContratoSinFirmar = true;
                }
            }

            if (hayContratoSinFirmar && !Test.isRunningTest()){
                retorno[0] = 'Falha ao criar a oportunidade. A conta tem contratos sem assinar.';
                retorno[1] = '';
                return retorno;
            }
        }
        retorno[0] = 'OK';
        retorno[1] = 'OK';
        return retorno;
    }

    public static boolean validarDelOpps(Opportunity opDel){
        String rt_anexoI_opps;
        String rt_anexoII_opps;
        String rt_anexoIII_opps;
        String rt_anexoIV_opps;
        String rt_anexoV_opps;
        String rt_Previsao_opps;
        String rt_Previsao_Cerrada_opps;
        String rt_VB_Fc_opps;
        String rt_VB_Pe_opps;
        String rt_VB_Au_opps;
        String rt_VB_Re_opps;
        String rt_DB_opps;

        /*for (RecordType rt : [Select Id, Name From RecordType Where Name in ('Anexo I','Anexo II','Anexo III', 'Anexo IV', 'Anexo V', 'Previsao', 'Previsao Cerrada', 'VB - Pasada SAP', 'VB - Pendiente', 'VB - Autorizada', 'VB - Rechazada', 'Disponibilidade da Basica')]){
         if (rt.Name == 'Anexo I')
         rt_anexoI_opps = rt.Id;
         if (rt.Name == 'Anexo II')
         rt_anexoII_opps = rt.Id;
         if (rt.Name == 'Anexo III')
         rt_anexoIII_opps = rt.Id;
         if (rt.Name == 'Anexo IV')
         rt_anexoIV_opps = rt.Id;
         if (rt.Name == 'Anexo V')
         rt_anexoV_opps = rt.Id;
         if (rt.Name == 'Previsao')
         rt_Previsao_opps = rt.Id;
         if (rt.Name == 'Previsao Cerrada')
         rt_Previsao_Cerrada_opps = rt.Id;
         if (rt.Name == 'VB - Pasada SAP')
         rt_VB_Fc_opps = rt.Id;
         if (rt.Name == 'VB - Pendiente')
         rt_VB_Pe_opps = rt.Id;
         if (rt.Name == 'VB - Autorizada')
         rt_VB_Au_opps = rt.Id;
         if (rt.Name == 'VB - Rechazada')
         rt_VB_Re_opps = rt.Id;
         if (rt.Name == 'Disponibilidade da Basica')
         rt_DB_opps = rt.id;
         }


         Id IdUs = Userinfo.getUserId();
         Id IdProf = Userinfo.getProfileId();

         Profile perfil = [SELECT Id, Name FROM Profile WHERE Id = :IdProf limit 1];
        //for(Opportunity oppdel: oppsDel){
         if(opDel.RecordTypeId == rt_VB_Fc_opps){
         if(perfil.Name == 'Comercial BMX' || perfil.Name == 'Comercial DSEM')
         return true;
         if(perfil.Name == 'Administrador del sistema')
         return false;

         }
         if(opDel.RecordTypeId == rt_VB_Au_opps){
         if(perfil.Name == 'Comercial BMX' || perfil.Name == 'Comercial DSEM')
         return true;
         if(perfil.Name == 'Administrador del sistema')
         return false;
         }
         if(opDel.RecordTypeId == rt_VB_Pe_opps){
         if(perfil.Name == 'Comercial BMX' || perfil.Name == 'Comercial DSEM' || perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema' || perfil.Name == 'Marketing' || perfil.Name == 'Gerente DSEM' || perfil.Name == 'Gerente BMX' || perfil.Name == 'Gerente Administrativo')
         return false;
        //if(perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema' || perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema')
         else
         return true;
         }
         if(opDel.RecordTypeId == rt_VB_Re_opps){
         if(perfil.Name == 'Comercial BMX' || perfil.Name == 'Comercial DSEM' || perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema' || perfil.Name == 'Marketing' || perfil.Name == 'Gerente DSEM' || perfil.Name == 'Gerente BMX' || perfil.Name == 'Gerente Administrativo')
         return false;
        //if(perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema' || perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema')
         else
         return true;
         }
         if(opDel.RecordTypeId == rt_DB_opps){
         if(perfil.Name == 'Administrador del sistema' || perfil.Name == 'Marketing' || perfil.Name == 'Gerente Administrativo')
         return false;
        //if(perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema' || perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema')
         else
         return true;
         }
         if(opDel.RecordTypeId == rt_Previsao_opps){
         if(perfil.Name == 'Comercial BMX' || perfil.Name == 'Comercial DSEM' || perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema' || perfil.Name == 'Marketing' || perfil.Name == 'Gerente DSEM' || perfil.Name == 'Gerente BMX' || perfil.Name == 'Gerente Administrativo')
         return false;
        //if(perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema' || perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema')
         else
         return true;
         }
         if(opDel.RecordTypeId == rt_Previsao_Cerrada_opps){
         if(perfil.Name == 'Administrador del sistema')
         return false;
        //if(perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema' || perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema')
         else
         return true;
         }
        //if(opDel.RecordTypeId == rt_anexoI_opps || opDel.RecordTypeId == rt_anexoII_opps || opDel.RecordTypeId == rt_anexoIII_opps || opDel.RecordTypeId == rt_anexoIV_opps || opDel.RecordTypeId == rt_anexoV_opps)
         if(perfil.Name == 'Administrador del sistema' || perfil.Name == 'Gerente Administrativo')
         return false;
        //if(perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema' || perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema')
         else
         return true;
        //else
        //if(perfil.Name == 'Administrador del sistema')
         return false;
        //if(perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema' || perfil.Name == 'Comercial BMX y DSEM' || perfil.Name == 'Administrador del sistema')
        //else
        //return true;

        //}*/
        return false;
    }

    /*public static void actualizarCategoriaStockMult(OpportunityLineItem[] items){

     system.debug('empezo');
     List <Id> idItems = New List <Id>();
     for (OpportunityLineItem i : items)
     idItems.add(i.Id);

     Map<String,Id> categorias = New Map<String,Id>();

     List<OpportunityLineItem> itemAnexo = New List<OpportunityLineItem>();

     List<OpportunityLineItem> itemStock = New List<OpportunityLineItem>();
     itemStock = [Select Id, PricebookEntryId, Opportunity.AccountId, Opportunity.Safra__c, Opportunity.Marca__c, Categoria__c From OpportunityLineItem Where Opportunity.RecordType.Name = 'Stock Multiplicadores' And Id In : idItems];

     List <Id> idCuentas = New List <Id>();
     List <String> campanias = New List <String>();
     List <String> marcas = New List <String>();
     List <Id> pbes = New List <Id>();

     if (itemStock.size() > 0){
     system.debug('hay stock');
     for(OpportunityLineItem i : itemStock){
     idCuentas.add(i.Opportunity.AccountId);
     campanias.add(i.Opportunity.Safra__c);
     marcas.add(i.Opportunity.Marca__c);
     pbes.add(i.PricebookEntryId);
     }

     itemAnexo = [Select Id, PricebookEntryId, Opportunity.AccountId, Opportunity.Safra__c, Opportunity.Marca__c, Categoria__c From OpportunityLineItem Where Opportunity.RecordType.Name = 'Anexo I' And Opportunity.StageName = 'Aprobada' And Opportunity.AccountId In : idCuentas And Opportunity.Safra__c In : campanias And Opportunity.Marca__c In : marcas And PricebookEntryId In : pbes];

     if (itemAnexo.size() > 0){
     system.debug('hay anexo');
     for(OpportunityLineItem i : itemAnexo){
     if (!categorias.containsKey(String.valueOf(i.PricebookEntryId) + String.valueOf(i.Opportunity.AccountId) + String.valueOf(i.Opportunity.Safra__c) + String.valueOf(i.Opportunity.Marca__c)))
     categorias.put(String.valueOf(i.PricebookEntryId) + String.valueOf(i.Opportunity.AccountId) + String.valueOf(i.Opportunity.Safra__c) + String.valueOf(i.Opportunity.Marca__c), i.Categoria__c);
     }
     }

     for (OpportunityLineItem i : itemStock)
     i.Categoria__c = categorias.get(String.valueOf(i.PricebookEntryId) + String.valueOf(i.Opportunity.AccountId) + String.valueOf(i.Opportunity.Safra__c) + String.valueOf(i.Opportunity.Marca__c));

     update itemStock;

     }

     }*/
    public static boolean actualizar2Opps(Opportunity[] oppsNew){
        Integer longitud = 0;
        for (Opportunity o : oppsNew){
            longitud = o.Name.length();
            o.Name = o.Name.substring(4, longitud - 4);
        }
        return true;
    }

    public PageReference nuevoReclamo(){

        PageReference pr = new PageReference('/500/e');
        RecordType rt = [Select Id
                         From RecordType
                         Where Name = 'RECLAMO CON ATEND EN EDICION' And SObjectType = 'Case'
                         limit 1];
        pr.getParameters().put('RecordType', String.valueOf(rt.Id));
        pr.getParameters().put('retURL', '/500/o');

        pr.getParameters().put('nooverride', '1');
        return pr.setRedirect(true);
    }

    public PageReference nuevaOpp(){
        Map<Id, String> usuarios = New Map<Id, String>();
        String tipo = ApexPages.currentPage().getParameters().get('tipo_opp');
        RecordType rt = [Select Id
                         From RecordType
                         Where Name = :tipo And SObjectType = 'Opportunity'
                         limit 1];
        User usuario = [SELECT Id, Username, Name, Email, IsActive, UserRoleId, UserRole.Name, ProfileId, Profile.Name
                        FROM User 
                        WHERE Id = :Userinfo.getUserId()];

        PageReference pr = new PageReference('/006/e');
        pr.getParameters().put('RecordType', String.valueOf(rt.Id));
        if (tipo == 'Previsao' || tipo == 'Stock Multiplicadores'){
            pr.getParameters().put('opp3', 'NOVO');
            pr.getParameters().put('opp11', 'Aberta');
            if (tipo == 'Previsao'){
                pr.getParameters().put('00N40000002I4n8', 'BRMX');
                if (usuario.UserRole.Name == 'Comercial R1 DSEM' || usuario.UserRole.Name == 'Comercial R2 DSEM')
                    pr.getParameters().put('00N40000002I4n8', 'DSEM');
            }
        }
        if (tipo.contains('Anexo') || tipo == 'Reembalaje' || tipo == 'Aquisição Sementes Terceiros'){
            pr.getParameters().put('opp3', 'NOVO');
            pr.getParameters().put('opp11', 'Edición');
        }
        if (tipo == 'Exportacion' || tipo == 'Objetivo Ventas Semilla' || tipo == 'Objetivo Ventas Royalties' || tipo == 'Objetivo Contrato Royalties'){
            pr.getParameters().put('opp11', 'Aprobada');
            pr.getParameters().put('opp3', 'NOVO');
        }

        if (tipo == 'PB-Comercial' || tipo == 'PB-Produccion' || tipo == 'PB-Desarrollo' || tipo == 'PB-Oferta'){

            if (tipo == 'PB-Comercial'){
                if (usuario.UserRole.Name == 'Gerente Cerrados')
                    pr.getParameters().put('00Nf0000000LKeS', 'CERRADO');
                if (usuario.UserRole.Name == 'Gerente Regiao 1'){
                    pr.getParameters().put('00Nf0000000LKeS', 'REGION 1');
                    pr.getParameters().put('00N40000002I4n8', 'BRMX');
                }
                if (usuario.UserRole.Name == 'Gerente Regiao 2'){
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

    public PageReference actStock(){
        Map<String, Analisis_de_Datos__c> mapStock = New Map<String, Analisis_de_Datos__c>();
        Map<String, Analisis_de_Datos__c> mapContratos = New Map<String, Analisis_de_Datos__c>();
        Map<String, Analisis_de_Datos__c> mapAnalisis = New Map<String, Analisis_de_Datos__c>();
        List<Analisis_de_Datos__c> actualizar = New List<Analisis_de_Datos__c>();
        Analisis_de_Datos__c tmp = New Analisis_de_Datos__c();
        Analisis_de_Datos__c filtroActStock = New Analisis_de_Datos__c();
        Schema.DescribeFieldResult fieldResult2 = Opportunity.Mes__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        List<String> meses = new List<String>();
        for (Schema.PicklistEntry f : ple2)
            if (f.getLabel().length() > 1)
                meses.add(f.getLabel());
            Set<Id> cuentas = New Set<Id>();
        Map<Integer, String> usuarios = New Map<Integer, Id>();
        Map<String, String> prop = New Map<String, String>();
        for (Configuracion_BMX__c conf : [Select Safra_Stock__c, Mes_Stock__c
                                          FROM Configuracion_BMX__c
                                          limit 1]){
            filtroActStock.Safra__c = conf.Safra_Stock__c;
            filtroActStock.Mes__c = conf.Mes_Stock__c;
        }
        for (User u : [Select Id, Codigo_SAP__c, Name
                       From User 
                       Where isActive = true]){
            if (u.Codigo_SAP__c != null)
                usuarios.put(Integer.valueOf(u.Codigo_SAP__c), String.valueOf(u.Id));
            //usName.put(String.ValueOf(u.Id), u.Name);
        }

        //String qry = 'SELECT Opportunity.Marca__c, Opportunity.Safra__c, Opportunity.Mes__c, Opportunity.OwnerId, Opportunity.AccountId, PriceBookEntry.Product2.Variedade__c FROM OpportunityLineItem WHERE Opportunity.RecordType.Name = \'Stock Multiplicadores\' AND Opportunity.Safra__c = \'13/14\' AND Mes = \'Setembro\'';


        for (AggregateResult p : [SELECT Contrato_de_Multiplicacion__r.RecordType.Name, Contrato_de_Multiplicacion__r.Safra__c, Contrato_de_Multiplicacion__r.Multiplicador__r.Id Mult, Cultivar__r.Variedade__r.Id, Count(Cultivar__r.Variedade__r.Name)myCount
                                  FROM Item_del_Contrato__c
                                  WHERE Contrato_de_Multiplicacion__r.RecordType.Name IN ('BRMX', 'DSEM') AND Contrato_de_Multiplicacion__r.Safra__c = :filtroActStock.Safra__c AND Cultivar__r.Variedade__r.Licenciada__c = false
                                  Group By Contrato_de_Multiplicacion__r.RecordType.Name, Contrato_de_Multiplicacion__r.Safra__c, Contrato_de_Multiplicacion__r.Multiplicador__r.Id, Cultivar__r.Variedade__r.Id]){
            mapContratos.put(String.ValueOf(p.get('Mult'))+String.ValueOf(p.get('Id')), new Analisis_de_Datos__c(Marca__c = String.ValueOf(p.get('Name')), Safra__c = String.ValueOf(p.get('Safra__c')), Cuenta__c = String.ValueOf(p.get('Mult')), Variedad__c = String.ValueOf(p.get('Id')), Cantidad_Contrato__c = Integer.ValueOf(p.get('myCount'))));
            cuentas.add(String.ValueOf(p.get('Mult')));
        }
        for (String mes : meses){
            for (AggregateResult p : [SELECT Opportunity.Marca__c, Opportunity.Safra__c, Opportunity.Mes__c, Opportunity.AccountId, PriceBookEntry.Product2.Variedade__r.Id, Count(PriceBookEntry.Product2.Variedade__r.Name)myCount
                                      FROM OpportunityLineItem
                                      WHERE Opportunity.RecordType.Name = 'Stock Multiplicadores' AND Opportunity.Safra__c = :filtroActStock.Safra__c AND Opportunity.Mes__c = :mes AND PricebookEntry.Product2.Variedade__r.Licenciada__c = false
                                      Group By Opportunity.Marca__c, Opportunity.Safra__c, Opportunity.Mes__c, Opportunity.AccountId, PriceBookEntry.Product2.Variedade__r.Id]){
                mapStock.put(String.ValueOf(p.get('AccountId'))+String.ValueOf(p.get('Id'))+String.ValueOf(p.get('Safra__c'))+String.ValueOf(p.get('Mes__c')), new Analisis_de_Datos__c(Marca__c = String.ValueOf(p.get('Marca__c')), Safra__c = String.ValueOf(p.get('Safra__c')), Mes__c = String.ValueOf(p.get('Mes__c')), Cuenta__c = String.ValueOf(p.get('AccountId')), Variedad__c = String.ValueOf(p.get('Id')), Cantidad_Stock__c = Integer.ValueOf(p.get('myCount'))));
            }
        }
        for (Analisis_de_Datos__c a : [SELECT Id, Variedad__c, Variedad__r.Id, Safra__c, PropietarioOpp__c, PropietarioOpp__r.Id, Mes__c, Marca__c, Cuenta__c, Cuenta__r.Id, Cantidad_Contrato__c, Cantidad_Stock__c
                                       FROM Analisis_de_Datos__c
                                       WHERE Safra__c = :filtroActStock.Safra__c]){
            mapAnalisis.put(String.ValueOf(a.Cuenta__c)+String.ValueOf(a.Variedad__c)+String.ValueOf(a.Mes__c), a);
        }

        for (Account a : [Select Id, Responsavel__c, Reponsavel_DSEM__c
                          From Account
                          Where Id In :cuentas]){
            String idUser = null;

            if (a.Responsavel__c != null){
                idUser = usuarios.get(Integer.valueOf(a.Responsavel__c.split('-')[0].trim()));
                if (idUser != null && idUser != ''){
                    prop.put(String.ValueOf(a.Id)+'BRMX', idUser);
                    idUser = null;
                }
            }
            if (a.Reponsavel_DSEM__c != null){
                idUser = usuarios.get(Integer.valueOf(a.Reponsavel_DSEM__c.split('-')[0].trim()));
                if (idUser != null && idUser != ''){
                    prop.put(String.ValueOf(a.Id)+'DSEM', idUser);
                    idUser = null;
                }
            }
            if (a.Responsavel_NEOGEN__c != null){
                idUser = usuarios.get(Integer.valueOf(a.Responsavel_NEOGEN__c.split('-')[0].trim()));
                if (idUser != null && idUser != ''){
                    prop.put(String.ValueOf(a.Id)+'NEOG', idUser);
                    idUser = null;
                }
            }
            if (a.Responsavel_DAGMA__c != null){
                idUser = usuarios.get(Integer.valueOf(a.Responsavel_DAGMA__c.split('-')[0].trim()));
                if (idUser != null && idUser != ''){
                    prop.put(String.ValueOf(a.Id)+'DAGMA', idUser);
                    idUser = null;
                }
            }
            if (a.Responsavel_LICENCAS__c != null){
                idUser = usuarios.get(Integer.valueOf(a.Responsavel_LICENCAS__c.split('-')[0].trim()));
                if (idUser != null && idUser != ''){
                    prop.put(String.ValueOf(a.Id)+'LICENÇAS', idUser);
                    idUser = null;
                }
            }
        }
        Savepoint sp;
        try{
            sp = Database.setSavepoint();
            for (Analisis_de_Datos__c a : mapContratos.values()){
                for (String mes : meses){
                    system.debug('ANALISIS----' + String.ValueOf(a.Cuenta__c)+String.ValueOf(a.Variedad__c)+mes);
                    if (mapAnalisis.ContainsKey(String.ValueOf(a.Cuenta__c)+String.ValueOf(a.Variedad__c)+mes)){
                        //Si ya existe hay que actualizarlo.
                        tmp = mapAnalisis.get(String.ValueOf(a.Cuenta__c)+String.ValueOf(a.Variedad__c)+mes);
                        tmp.Cantidad_Contrato__c = a.Cantidad_Contrato__c; //Actualizo las cantidades de Contrato por las dudas
                        if (mapStock.ContainsKey(String.ValueOf(tmp.Cuenta__r.Id)+String.ValueOf(tmp.Variedad__r.Id)+String.ValueOf(tmp.Safra__c)+mes)){
                            tmp.Cantidad_Stock__c = mapStock.get(String.ValueOf(tmp.Cuenta__r.Id)+String.ValueOf(tmp.Variedad__r.Id)+String.ValueOf(tmp.Safra__c)+mes).Cantidad_Stock__c;
                        } else{
                            tmp.Cantidad_Stock__c = 0;
                        }
                        actualizar.add(new Analisis_de_Datos__c(Id = tmp.Id, Variedad__c = tmp.Variedad__c, Safra__c = tmp.Safra__c, PropietarioOpp__c = tmp.PropietarioOpp__c, Mes__c = tmp.Mes__c, Marca__c = tmp.Marca__c, Cuenta__c = tmp.Cuenta__c, Cantidad_Contrato__c = tmp.Cantidad_Contrato__c, Cantidad_Stock__c = tmp.Cantidad_Stock__c));
                        tmp = null;
                    } else{
                        // Si no existe hay que crearlo
                        tmp = a;
                        tmp.Mes__c = mes;
                        tmp.PropietarioOpp__c = prop.get(String.ValueOf(tmp.Cuenta__c)+tmp.Marca__c);
                        if (mapStock.ContainsKey(String.ValueOf(tmp.Cuenta__c)+String.ValueOf(tmp.Variedad__c)+String.ValueOf(tmp.Safra__c)+mes)){
                            tmp.Cantidad_Stock__c = mapStock.get(String.ValueOf(tmp.Cuenta__c)+String.ValueOf(tmp.Variedad__c)+String.ValueOf(tmp.Safra__c)+mes).Cantidad_Stock__c;
                        } else{
                            tmp.Cantidad_Stock__c = 0;
                        }
                        actualizar.add(new Analisis_de_Datos__c(Variedad__c = tmp.Variedad__c, Safra__c = tmp.Safra__c, PropietarioOpp__c = tmp.PropietarioOpp__c, Mes__c = tmp.Mes__c, Marca__c = tmp.Marca__c, Cuenta__c = tmp.Cuenta__c, Cantidad_Contrato__c = tmp.Cantidad_Contrato__c, Cantidad_Stock__c = tmp.Cantidad_Stock__c));
                        tmp = null;
                    }
                }
            }
            upsert actualizar;
            actualizar.clear();
            /*//for(String mes: meses){
             for(Analisis_de_Datos__c a: mapContratos.values()){
             if(mapAnalisis.ContainsKey(String.ValueOf(a.Cuenta__c)+String.ValueOf(a.Variedad__c)+filtroActStock.Mes__c)){//Si ya existe hay que actualizarlo.
             tmp = mapAnalisis.get(String.ValueOf(a.Cuenta__c)+String.ValueOf(a.Variedad__c)+filtroActStock.Mes__c);
             tmp.Cantidad_Contrato__c = a.Cantidad_Contrato__c; //Actualizo las cantidades de Contrato por las dudas
             if(mapStock.ContainsKey(String.ValueOf(tmp.Cuenta__c)+String.ValueOf(tmp.Variedad__c)+String.ValueOf(tmp.Safra__c)+filtroActStock.Mes__c)){
             tmp.Cantidad_Stock__c = mapStock.get(String.ValueOf(tmp.Cuenta__c)+String.ValueOf(tmp.Variedad__c)+String.ValueOf(tmp.Safra__c)+filtroActStock.Mes__c).Cantidad_Stock__c;
             }else{tmp.Cantidad_Stock__c = 0;}
             actualizar.add(new Analisis_de_Datos__c(Id=tmp.Id,Variedad__c=tmp.Variedad__c,Safra__c=tmp.Safra__c,PropietarioOpp__c=tmp.PropietarioOpp__c,Mes__c=tmp.Mes__c,Marca__c=tmp.Marca__c,Cuenta__c=tmp.Cuenta__c,Cantidad_Contrato__c=tmp.Cantidad_Contrato__c, Cantidad_Stock__c=tmp.Cantidad_Stock__c));tmp=null;
             }else{// Si no existe hay que crearlo
             tmp = a;
             tmp.Mes__c = filtroActStock.Mes__c;
             tmp.PropietarioOpp__c = prop.get(String.ValueOf(tmp.Cuenta__c)+tmp.Marca__c);
             if(mapStock.ContainsKey(String.ValueOf(tmp.Cuenta__c)+String.ValueOf(tmp.Variedad__c)+String.ValueOf(tmp.Safra__c)+filtroActStock.Mes__c)){
             tmp.Cantidad_Stock__c = mapStock.get(String.ValueOf(tmp.Cuenta__c)+String.ValueOf(tmp.Variedad__c)+String.ValueOf(tmp.Safra__c)+filtroActStock.Mes__c).Cantidad_Stock__c;
             }else{tmp.Cantidad_Stock__c = 0;}
             actualizar.add(new Analisis_de_Datos__c(Variedad__c=tmp.Variedad__c,Safra__c=tmp.Safra__c,PropietarioOpp__c=tmp.PropietarioOpp__c,Mes__c=tmp.Mes__c,Marca__c=tmp.Marca__c,Cuenta__c=tmp.Cuenta__c,Cantidad_Contrato__c=tmp.Cantidad_Contrato__c, Cantidad_Stock__c=tmp.Cantidad_Stock__c));tmp=null;
             }
             }
             upsert actualizar;
             actualizar.clear();
            //}*/
        } catch (Exception e){
            //ApexPages.addMessages(e);
            Database.rollback(sp);
        }
        return null;
    }

    public static void actualizarEvent(CRM_Calendario_de_Eventos__c[] eventosNew, CRM_Calendario_de_Eventos__c[] eventosOld, Boolean del) {
        if (eventosOld != null && !eventosOld.isEmpty()) {
            List<Id> idsCalendario = new List<Id>();

            for (CRM_Calendario_de_Eventos__c e : eventosOld) { idsCalendario.add(e.Id); }

            List<Event> eventosExistentes = [
                SELECT Id, CRM_Calendario_de_eventos__c FROM Event WHERE CRM_Calendario_de_eventos__c IN :idsCalendario
            ];

            if (!eventosExistentes.isEmpty()) { delete eventosExistentes; }
        }

        if (eventosNew != null) {
            List<Event> eventos = new List<Event>();

            Set<Id> idCuentas = new Set<Id>();
            Set<Id> idRevendas = new Set<Id>();
            Map<Id, Id> creadoresEventos = new Map<Id, Id>();

            for (CRM_Calendario_de_eventos__c e : eventosNew) {
                if (e.Cuenta__c != null) { idCuentas.add(e.Cuenta__c); }
                if (e.Revenda__c != null) { idRevendas.add(e.Revenda__c); }
                creadoresEventos.put(e.Id, e.CreatedById);
            }

            Map<Integer, Id> usuariosSAP = new Map<Integer, Id>();
            List<User> usuarios = new List<User>();
            Id idUserMKT = null;

            for (User u : [SELECT Id, Codigo_SAP__c, UserRole.Name FROM User WHERE isActive = true]) {
                if (String.isNotEmpty(u.Codigo_SAP__c)) {
                    usuariosSAP.put(Integer.valueOf(u.Codigo_SAP__c), u.Id);
                }

                usuarios.add(u);

                if (u.UserRole.Name == 'Gerencia y Marketing') {
                    idUserMKT = u.Id;
                }
            }

            List<Map<Id, String>> responsables = getResponsablesPorMarca(usuariosSAP, idCuentas);

            Map<Id, String> propBRMX = responsables[0];
            Map<Id, String> propDSEM = responsables[1];
            Map<Id, String> propNEOG = responsables[2];
            Map<Id, String> propDAGMA = responsables[3];
            Map<Id, String> propLICENCAS = responsables[4];
            Map<Id, String> regionCuenta = responsables[5];
            Map<Id, String> nombreCuenta = responsables[6];
            Map<Id, String> nombreRevenda = new Map<Id, String>();

            for (Account acc : [SELECT Id, Name FROM Account WHERE Id IN :idRevendas]) {
                nombreRevenda.put(acc.Id, acc.Name);
            }

            for (CRM_Calendario_de_Eventos__c e : eventosNew) {
                if (e.Fase__c == 'Aprovado' && (e.Evento__c == 'Día de Campo' || e.Evento__c == 'Palestra' || e.Evento__c == 'Treinamento' || e.Evento__c == 'Encontro Técnico' || e.Evento__c == 'Jornada Técnica') && (e.Marca__c == 'BRMX' || e.Marca__c == 'DSEM' || e.Marca__c == 'NEOG' || e.Marca__c == 'DAGMA' || e.Marca__c == 'LICENÇAS')) {
                    String nomCta = nombreCuenta.containsKey(e.Cuenta__c) ? nombreCuenta.get(e.Cuenta__c) : '';

                    Event newEvent = new Event(
                        CRM_Calendario_de_Eventos__c = e.Id,
                        Tipo_de_evento__c = e.Evento__c,
                        WhatId = e.Cuenta__c,
                        StartDateTime = e.Data_e_horario_inicio__c,
                        EndDateTime = e.Data_e_horario_termino__c,
                        Subject = e.Evento__c + ' ' + nomCta,
                        Description = ''
                    );

                    switch on e.Marca__c {
                        when 'BRMX' {
                            newEvent.Marca_Comercial__c = 'Brasmax';
                            newEvent.OwnerId = propBRMX.get(e.Cuenta__c);
                        }
                        when 'DSEM' {
                            newEvent.Marca_Comercial__c = 'Don Mario';
                            newEvent.OwnerId = propDSEM.get(e.Cuenta__c);
                        }
                        when 'NEOG' {
                            newEvent.Marca_Comercial__c = 'Neogen';
                            newEvent.OwnerId = propNEOG.get(e.Cuenta__c);
                        }
                        when 'DAGMA' {
                            newEvent.Marca_Comercial__c = 'Dagma';
                            newEvent.ownerId = propDAGMA.get(e.Cuenta__c);
                        }
                        when 'LICENÇAS' {
                            newEvent.Marca_Comercial__c = 'Licenças';
                            newEvent.ownerId = propLICENCAS.get(e.Cuenta__c);
                        }
                    }

                    if (e.Municipio__c != null) { newEvent.Location = e.Nome_Cidade__c + ' ' + e.Estado__c; }
                    if (e.Participante__c != null) { newEvent.Description = 'Participantes: ' + e.Participante__c + '\n'; }
                    if (e.Comentarios__c != null) { newEvent.Description += 'Comentarios: ' + e.Comentarios__c + '\n'; }
                    if (e.Revenda__c != null) { newEvent.Description += 'Revenda: ' + nombreRevenda.get(e.Revenda__c)+'\n'; }

                    eventos.add(newEvent);
                }
            }

            if (!eventos.isEmpty()) {
                insert eventos;

                List<EventRelation> agregarInvitados = new List<EventRelation>();

                for (Event e : eventos) {
                    Id creador = creadoresEventos.get(e.CRM_Calendario_de_Eventos__c);

                    if (e.OwnerId != creador && creador != '00540000000zlzOAAQ' && creador != '00518000001Sa4oAAC' && creador != '0050b000004osweAAA') {
                        agregarInvitados.add(new EventRelation(
                            EventId = e.Id,
                            RelationId = creador,
                            Status = 'Accepted',
                            IsInvitee = true
                        ));
                    }

                    if (creador != idUserMKT) {
                        agregarInvitados.add(new EventRelation(
                            EventId = e.Id,
                            RelationId = idUserMKT,
                            Status = 'Accepted',
                            IsInvitee = true
                        ));
                    }

                    if (e.Tipo_de_evento__c == 'Día de Campo' && regionCuenta.containsKey(e.WhatId)) {
                        String region = regionCuenta.get(e.WhatId);

                        for (User u : usuarios) {
                            if (u.Id != creador && u.Id != e.OwnerId) {
                                EventRelation agregarInvitado = new EventRelation(
                                    EventId = e.Id,
                                    RelationId = u.Id,
                                    Status = 'Accepted',
                                    IsInvitee = true
                                );

                                if ((region == 'REGION 1' || region == 'REGION 2') && e.Marca_Comercial__c.contains('Brasmax') && (u.UserRole.Name == 'Comercial R1 BRMX' || u.UserRole.Name == 'Comercial R2 BRMX' || u.UserRole.Name == 'Gerente Regiao 1' || u.UserRole.Name == 'Gerente Regiao 2')) {
                                    agregarInvitados.add(agregarInvitado);
                                } else if ((region == 'REGION 1' || region == 'REGION 2') && e.Marca_Comercial__c.contains('Don Mario') && (u.UserRole.Name == 'Comercial R1 DSEM' || u.UserRole.Name == 'Comercial R2 DSEM' || u.UserRole.Name == 'Gerente Regiao 1' || u.UserRole.Name == 'Gerente Regiao 2')) {
                                    agregarInvitados.add(agregarInvitado);
                                } else if (region == 'CERRADO' && (u.UserRole.Name == 'Comercial Cerrados' || u.UserRole.Name == 'Gerente Cerrados')) {
                                    agregarInvitados.add(agregarInvitado);
                                }
                            }
                        }
                    }
                }

                if (!agregarInvitados.isEmpty()) { insert agregarInvitados; }
            }
        }
    }

    public static void actualizarEventosPerfilCuenta(CRM_Calendario_de_Eventos__c[] eventosNew, CRM_Calendario_de_Eventos__c[] eventosOld){

        Set<Id> accIds = New Set<Id>();
        Set<String> accParentIds = New Set<String>();
        accParentIds.add('111111111111111'); //Para cuando consulto que los parentid esten en esta coleccion por lo menos que tenga algo. Si es nulo me va a traer cuentas que no me interesan.
        String safra = '';

        //Map<String,Double> cantPalestras = New Map<String,Double>();
        //Map<String,Double> cantDiasDeCampo = New Map<String,Double>();
        //Map<String,Double> LadoALado = New Map<String,Double>();
        Map<String, Double> eventos = New Map<String, Double>();
        Map<String, Double> eventosDMS = New Map<String, Double>();
        Map<String, Double> eventosDMS2 = New Map<String, Double>();

        for (Configuracion_BMX__c conf : [Select CRM_Safra_Siguiente__c
                                          FROM Configuracion_BMX__c
                                          limit 1])
            safra = conf.CRM_Safra_Siguiente__c;
        if (eventosNew != null)
            for (CRM_Calendario_de_Eventos__c e : eventosNew)
                if (e.Safra__c == safra && e.Cuenta__c != null)
                    accIds.add(e.Cuenta__c);
                if (eventosOld != null)
                    for (CRM_Calendario_de_Eventos__c e : eventosOld)
                        if (e.Safra__c == safra && e.Cuenta__c != null)
                            accIds.add(e.Cuenta__c);
                        if (accIds.size() > 0){
                            for (Account a : [Select Id, ParentId
                                              From Account
                                              Where Id In :accIds])
                                if (a.ParentId != null)
                                    accParentIds.add(a.ParentId);
                                for (AggregateResult ar : [Select Count(Id)cant, Evento__c, Cuenta__c, Cuenta__r.ParentId principal
                                                           From CRM_Calendario_de_Eventos__c 
                                                           Where (Evento__c In ('Palestra', 'Treinamento') Or (Evento__c = 'Lado a Lado' And Produtividade__c > 0) Or (Evento__c = 'Día de Campo' And (Custo__c = null Or Custo__c = 0))) And (Cuenta__c In :accIds Or Cuenta__r.ParentId In :accParentIds) And Safra__c = :safra And Marca__c = 'BRMX' And Fase__c = 'Aprovado'
                                                           Group By Cuenta__r.ParentId, Cuenta__c, Evento__c]){
                                    String cuenta = String.valueOf(ar.get('Cuenta__c'));
                                if (ar.get('principal') != null)
                                    cuenta = String.valueOf(ar.get('principal'));
                                if (!eventos.containsKey(cuenta + String.valueOf(ar.get('Evento__c')))){
                                    eventos.put(cuenta + String.valueOf(ar.get('Evento__c')), Double.valueOf(ar.get('cant')));
                } else{
                    Double cant = eventos.get(cuenta + String.valueOf(ar.get('Evento__c')));
                    cant += Double.valueOf(ar.get('cant'));
                    eventos.remove(cuenta + String.valueOf(ar.get('Evento__c')));
                    eventos.put(cuenta + String.valueOf(ar.get('Evento__c')), cant);
                }
            }

            for (CRM_Calendario_de_Eventos__c ar : [Select Cuenta__c, Cuenta__r.ParentId, Evento__c, Custo__c
                                                    From CRM_Calendario_de_Eventos__c
                                                    Where (Cuenta__c In :accIds Or Cuenta__r.ParentId In :accParentIds) And Safra__c = :safra And Marca__c = 'DSEM' And Fase__c = 'Aprovado' And (Evento__c = 'Día de Campo' Or Evento__c = 'Emplacamento')]){
                String cuenta = ar.Cuenta__c;
                if (ar.Cuenta__r.ParentId != null)
                    cuenta = ar.Cuenta__r.ParentId;
                if (ar.Evento__c == 'Día de Campo'){
                    if (!eventosDMS.containsKey(cuenta)){
                        Double custo = 0;
                        if (ar.Custo__c != null)
                            custo = ar.Custo__c;
                        eventosDMS.put(cuenta, custo);
                    } else{
                        if (ar.Custo__c != null && ar.Custo__c != 0){
                            eventosDMS.remove(cuenta);
                            eventosDMS.put(cuenta, ar.Custo__c);
                        }
                    }
                }
                if (ar.Evento__c == 'Emplacamento'){
                    if (!eventosDMS2.containsKey(cuenta)){
                        eventosDMS2.put(cuenta, 1);
                    } else{
                        Double cantEmplac = eventosDMS2.get(cuenta);
                        cantEmplac = cantEmplac + 1;
                        eventosDMS2.remove(cuenta);
                        eventosDMS2.put(cuenta, cantEmplac);
                    }
                }
            }
        }

        List<CRM_Multiplicador__c> crm_mult = New List<CRM_Multiplicador__c>();
        crm_mult = [Select Id, Cuenta__c, Cuenta__r.ParentId, BR_Palestras_Realizado__c, BR_Treinamentos_Realizado__c, BR_LXL_Realizado__c, BR_Participacao_dia_campo_realizado__c, DS_Participaca_dias_de_campo__c
                    From CRM_Multiplicador__c
                    Where (Cuenta__c In :accIds Or Cuenta__r.ParentId In :accParentIds) And Safra__c = :safra];
        if (crm_mult.size() > 0){
            for (CRM_Multiplicador__c crm : crm_mult){
                String cuenta = crm.Cuenta__c;
                if (crm.Cuenta__r.ParentId != null)
                    cuenta = crm.Cuenta__r.ParentId;
                crm.BR_Palestras_Realizado__c = eventos.get(cuenta + 'Palestra');
                crm.BR_Treinamentos_Realizado__c = eventos.get(cuenta + 'Treinamento');
                crm.BR_LXL_Realizado__c = eventos.get(cuenta + 'Lado a Lado');
                crm.BR_Participacao_dia_campo_realizado__c = eventos.get(cuenta + 'Día de Campo');
                crm.DS_Identifica_o_de_beiras_de_rodovia__c = eventosDMS2.get(cuenta);
                crm.DS_Participaca_dias_de_campo__c = true;
                if (eventosDMS.get(cuenta) != null){
                    Double cos = eventosDMS.get(cuenta);
                    if (cos > 0)
                        crm.DS_Participaca_dias_de_campo__c = false;
                }
            }
            update crm_mult;
        }
    }

    public static void actualizarMetasPerfilCuenta(Contrato__c[] contNew, Contrato__c[] contOld){

        Set<Id> contratoIds = New Set<Id>();
        Set<Id> accIds = New Set<Id>();
        Map<String, String> mapVari = New Map<String, String>();

        Map<String, Double> metaBRMX = New Map<String, Double>();
        Map<String, Double> metaDSEM = New Map<String, Double>();
        Map<String, Double> metaNEOG = New Map<String, Double>();
        Map<string, Double> metaDAGMA = New Map<String, Double>();
        Map<String, Double> metaLICENCAS = New Map<String, Double>();

        if (contNew != null)
            for (Contrato__c c : contNew)
                if (c.Safra__c == '20/21')
                    accIds.add(c.Multiplicador__c);
                //contratoIds.add(i.Contrato_de_Multiplicacion__c);

                if (contOld != null)
                    for (Contrato__c c : contOld)
                        if (c.Safra__c == '20/21')
                            accIds.add(c.Multiplicador__c);
                        //contratoIds.add(i.Contrato_de_Multiplicacion__c);

                        for (Variedad__c v : [Select Id, Region_bonificacion__c
                                              From Variedad__c])
                            mapVari.put(v.Id, v.Region_bonificacion__c);
                        //for(Contrato__c c : [Select Id, Multiplicador__c From Contrato__c Where Id In : contratoIds And Safra__c = '18/19'])
                        //  accIds.add(c.Multiplicador__c);

                        Set<String> accParentIds = New Set<String>();
                    accParentIds.add('111111111111111');
                //Para cuando consulto que los parentid esten en esta coleccion por lo menos que tenga algo. Si es nulo me va a traer cuentas que no me interesan.
                for (Account a : [Select Id, ParentId
                                  From Account
                                  Where Id In :accIds])
                    if (a.ParentId != null)
                        accParentIds.add(a.ParentId);
                    if (accIds.size() > 0){
                        for (AggregateResult ar : [Select Sum(Volumen_Aut_Comercializacion__c)cantidad, Contrato_de_Multiplicacion__r.Multiplicador__c cuenta, Contrato_de_Multiplicacion__r.Multiplicador__r.ParentId principal, Contrato_de_Multiplicacion__r.Region_Comercial__c region, Contrato_de_Multiplicacion__r.Sociedad__c marca, Variedad__c variedad
                                                   From Item_del_Contrato__c 
                                                   Where (Contrato_de_Multiplicacion__r.Multiplicador__c In :accIds Or Contrato_de_Multiplicacion__r.Multiplicador__r.ParentId In :accParentIds) And Contrato_de_Multiplicacion__r.Safra__c = '20/21' And Contrato_de_Multiplicacion__r.Estado__c = 'Chegou' And RecordType.Name = 'Volumen'
                                                   Group By Contrato_de_Multiplicacion__r.Multiplicador__c, Contrato_de_Multiplicacion__r.Multiplicador__r.ParentId, Contrato_de_Multiplicacion__r.Region_Comercial__c, Contrato_de_Multiplicacion__r.Sociedad__c, Variedad__c]){
                            String cuenta = String.valueOf(ar.get('cuenta'));
                        if (ar.get('principal') != null)
                            cuenta = String.valueOf(ar.get('principal'));
                        String region = String.valueOf(ar.get('region'));
                    if (region == 'REGION 1' || region == 'REGION 2')
                        region = 'SUL';
                    String region_vari = mapVari.get(String.valueOf(ar.get('variedad')));
                if (region_vari != null && region_vari.contains(region)){
                    
                    switch on String.valueOf(ar.get('marca')) {

                        when 'BRMX' {
                            if (!metaBRMX.containsKey(cuenta)){
                                metaBRMX.put(cuenta, Double.valueOf(ar.get('cantidad')));
                            } else{
                                Double metaB = metaBRMX.get(cuenta);
                                metaB += Double.valueOf(ar.get('cantidad'));
                                metaBRMX.remove(cuenta);
                                metaBRMX.put(cuenta, metaB);
                            }
                        }
                        when 'DSEM' {
                            if (!metaDSEM.containsKey(cuenta)){
                                metaDSEM.put(cuenta, Double.valueOf(ar.get('cantidad')));
                            } else{
                                Double metaD = metaDSEM.get(cuenta);
                                metaD += Double.valueOf(ar.get('cantidad'));
                                metaDSEM.remove(cuenta);
                                metaDSEM.put(cuenta, metaD);
                            }
                        }
                        when 'NEOG' {
                            if (!metaNEOG.containsKey(cuenta)){
                                metaNEOG.put(cuenta, Double.valueOf(ar.get('cantidad')));
                            } else{
                                Double metaN = metaNEOG.get(cuenta);
                                metaN += Double.valueOf(ar.get('cantidad'));
                                metaNEOG.remove(cuenta);
                                metaNEOG.put(cuenta, metaN);
                            }
                        }
                        when 'DAGMA' {
                            if (!metaDAGMA.containsKey(cuenta)){
                                metaDAGMA.put(cuenta, Double.valueOf(ar.get('cantidad')));
                            } else{
                                Double metaD = metaDAGMA.get(cuenta);
                                metaD += Double.valueOf(ar.get('cantidad'));
                                metaDAGMA.remove(cuenta);
                                metaDAGMA.put(cuenta, metaD);
                            }
                        }
                        when 'LICENÇAS' {
                            if (!metaLICENCAS.containsKey(cuenta)){
                                metaLICENCAS.put(cuenta, Double.valueOf(ar.get('cantidad')));
                            } else{
                                Double metaL = metaLICENCAS.get(cuenta);
                                metaL += Double.valueOf(ar.get('cantidad'));
                                metaLICENCAS.remove(cuenta);
                                metaLICENCAS.put(cuenta, metaL);
                            }
                        }
                    }
                }
            }

            List<CRM_Multiplicador__c> crm_mult = New List<CRM_Multiplicador__c>();
            crm_mult = [Select Id, Cuenta__c, Cuenta__r.ParentId, Safra__c, BR_Soma_de_Meta__c, DS_Soma_de_Meta__c, NG_Soma_de_Meta__c
                        From CRM_Multiplicador__c
                        Where (Cuenta__c In :accIds Or Cuenta__r.ParentId In :accParentIds) And Safra__c In ('20/21')];
            if (crm_mult.size() > 0){
                for (CRM_Multiplicador__c crm : crm_mult){
                    String cuenta = crm.Cuenta__c;
                    if (crm.Cuenta__r.ParentId != null)
                        cuenta = crm.Cuenta__r.ParentId;
                    crm.BR_Soma_de_Meta__c = metaBRMX.get(cuenta);
                    crm.DS_Soma_de_Meta__c = metaDSEM.get(cuenta);
                    crm.NG_Soma_de_Meta__c = metaNEOG.get(cuenta);

                }
                update crm_mult;
            }

        }
    }

    public static void actualizarEventosPerfilCuenta2(CRM_Calendario_de_Eventos__c[] eventosNew, CRM_Calendario_de_Eventos__c[] eventosOld, Contrato__c[] contNew, Contrato__c[] contOld){

        Set<Id> accIds = New Set<Id>();
        Map<String, Double> eventosMeta = New Map<String, Double>();
        Map<String, Double> eventosMeta2 = New Map<String, Double>();
        Map<String, Double> eventosRealizado = New Map<String, Double>();
        Map<String, Double> eventosRealizado2 = New Map<String, Double>();
        Map<String, Double> eventosTotalRealizado = New Map<String, Double>();
        Map<String, Double> eventosTotalRealizado2 = New Map<String, Double>();
        Map<String, Double> eventosTotalRealizadoProdutiv = New Map<String, Double>();
        Map<String, CRM_Multiplicador__c> eventosTotalMeta = New Map<String, CRM_Multiplicador__c>();
        Set<String> accParentIds = New Set<String>();
        accParentIds.add('111111111111111'); //Para cuando consulto que los parentid esten en esta coleccion por lo menos que tenga algo. Si es nulo me va a traer cuentas que no me interesan.

        if (contNew != null)
            for (Contrato__c c : contNew)
                if (c.Safra__c == '20/21')
                    accIds.add(c.Multiplicador__c);
                if (contOld != null)
                    for (Contrato__c c : contOld)
                        if (c.Safra__c == '20/21')
                            accIds.add(c.Multiplicador__c);
                        if (eventosNew != null)
                            for (CRM_Calendario_de_Eventos__c c : eventosNew)
                                if (c.Safra__c == '20/21')
                                    accIds.add(c.Cuenta__c);
                                if (eventosOld != null)
                                    for (CRM_Calendario_de_Eventos__c c : eventosOld)
                                        if (c.Safra__c == '20/21')
                                            accIds.add(c.Cuenta__c);
                                        if (accIds.size() > 0){
                                            for (Account a : [Select Id, ParentId
                                                              From Account
                                                              Where Id In :accIds])
                                                if (a.ParentId != null)
                                                    accParentIds.add(a.ParentId);
                                                for (AggregateResult ar : [Select Multiplicador__c cuenta, Multiplicador__r.ParentId principal, Sociedad__c marca, Sum(Meta_Qde_Dias_de_Campo__c)meta_dc, Sum(Meta_Qde_Emplacamentos__c)meta_emp, Sum(Meta_Qde_Lado_a_Lado__c)meta_lxl, Sum(Meta_Qde_Palestras__c)meta_pal, Sum(Meta_Qde_Treinamentos__c)meta_tre
                                                                           From Contrato__c
                                                                           Where (Multiplicador__c In :accIds Or Multiplicador__r.ParentId In :accParentIds) And Safra__c = '20/21' And Estado__c = 'Chegou'
                                                                           Group By Multiplicador__c, Multiplicador__r.ParentId, Sociedad__c]){
                                                    String cuenta = String.valueOf(ar.get('cuenta'));
                                                if (ar.get('principal') != null)
                                                    cuenta = String.valueOf(ar.get('principal'));
                                                if (!eventosTotalMeta.containsKey(cuenta + '_' + String.valueOf(ar.get('marca')))){
                                                    CRM_Multiplicador__c crm = New CRM_Multiplicador__c();
                                                if (Double.valueOf(ar.get('meta_dc')) != null)
                                                    crm.BR_Participacao_dia_de_campo_meta__c = Double.valueOf(ar.get('meta_dc'));
                                                crm.BR_Emplacamentos_Meta__c = Double.valueOf(ar.get('meta_emp'));
                                            crm.BR_LXL_Meta__c = Double.valueOf(ar.get('meta_lxl'));
                                        if (String.valueOf(ar.get('marca')) == 'BRMX' || String.valueOf(ar.get('marca')) == 'DSEM'){
                                            //cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                                            crm.BR_Palestras_Meta__c = Double.valueOf(ar.get('meta_pal'))+Double.valueOf(ar.get('meta_tre'));
                    } else{
                        crm.BR_Palestras_Meta__c = Double.valueOf(ar.get('meta_pal'));
                        crm.BR_Treinamentos_Meta__c = Double.valueOf(ar.get('meta_tre'));
                    }
                    //crm.BR_Palestras_Meta__c = Double.valueOf(ar.get('meta_pal')); cambio 16072020 Kleber ticket 41036
                    //crm.BR_Treinamentos_Meta__c = Double.valueOf(ar.get('meta_tre')); cambio 16072020 Kleber ticket 41036
                    eventosTotalMeta.put(cuenta + '_' + String.valueOf(ar.get('marca')), crm);
                } else{
                    CRM_Multiplicador__c crm = eventosTotalMeta.get(cuenta + '_' + String.valueOf(ar.get('marca')));
                    if (Double.valueOf(ar.get('meta_dc')) != null)
                        crm.BR_Participacao_dia_de_campo_meta__c += Double.valueOf(ar.get('meta_dc'));
                    crm.BR_Emplacamentos_Meta__c += Double.valueOf(ar.get('meta_emp'));
                    crm.BR_LXL_Meta__c += Double.valueOf(ar.get('meta_lxl'));
                    if (String.valueOf(ar.get('marca')) == 'BRMX' || String.valueOf(ar.get('marca')) == 'DSEM'){
                        //cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                        crm.BR_Palestras_Meta__c += Double.valueOf(ar.get('meta_pal'))+Double.valueOf(ar.get('meta_tre'));
                    } else{
                        crm.BR_Palestras_Meta__c += Double.valueOf(ar.get('meta_pal'));
                        crm.BR_Treinamentos_Meta__c += Double.valueOf(ar.get('meta_tre'));
                    }
                    //crm.BR_Palestras_Meta__c += Double.valueOf(ar.get('meta_pal')); cambio 16072020 Kleber ticket 41036
                    //crm.BR_Treinamentos_Meta__c += Double.valueOf(ar.get('meta_tre')); cambio 16072020 Kleber ticket 41036
                    eventosTotalMeta.put(cuenta + '_' + String.valueOf(ar.get('marca')), crm);
                }
            }

            for (AggregateResult ar : [Select Sum(Quantidade__c)cantidad, Tipo_de_Evento__c tipo, Contrato_de_Multiplicacion__r.Multiplicador__c cuenta, Contrato_de_Multiplicacion__r.Multiplicador__r.ParentId principal, Contrato_de_Multiplicacion__r.Sociedad__c marca, Variedad__c variedad, Estado__c estado
                                       From Item_del_Contrato__c 
                                       Where (Contrato_de_Multiplicacion__r.Multiplicador__c In :accIds Or Contrato_de_Multiplicacion__r.Multiplicador__r.ParentId In :accParentIds) And Contrato_de_Multiplicacion__r.Safra__c = '20/21' And Contrato_de_Multiplicacion__r.Estado__c = 'Chegou' And RecordType.Name In ('Metas', 'Metas x Cultivar') And Quantidade__c > 0
                                       Group By Tipo_de_Evento__c, Contrato_de_Multiplicacion__r.Multiplicador__c, Contrato_de_Multiplicacion__r.Multiplicador__r.ParentId, Contrato_de_Multiplicacion__r.Sociedad__c, Variedad__c, Estado__c]){
                String cuenta = String.valueOf(ar.get('cuenta'));
                if (ar.get('principal') != null)
                    cuenta = String.valueOf(ar.get('principal'));
                String tipoAux = String.valueOf(ar.get('tipo')); //cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                String estadoAux = String.valueOf(ar.get('estado')); //cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                if ((String.valueOf(ar.get('marca')) == 'BRMX' || String.valueOf(ar.get('marca')) == 'DSEM') && (String.valueOf(ar.get('tipo')) == 'Palestra' || String.valueOf(ar.get('tipo')) == 'Treinamento')){
                    //cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                    tipoAux = 'PalTrei';
                    estadoAux = 'null';
                }
                system.debug('PONE META: ' + cuenta + '_' + tipoAux + '_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + estadoAux + ' ' + Double.valueOf(ar.get('cantidad')));
                if (!eventosMeta.containsKey(cuenta + '_' + tipoAux + '_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + estadoAux)){
                    eventosMeta.put(cuenta + '_' + tipoAux + '_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + estadoAux, Double.valueOf(ar.get('cantidad')));
                } else{
                    Double cantMet = eventosMeta.get(cuenta + '_' + tipoAux + '_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + estadoAux);
                    cantMet += Double.valueOf(ar.get('cantidad'));
                    eventosMeta.put(cuenta + '_' + tipoAux + '_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + estadoAux, cantMet);
                }
                if (!eventosMeta2.containsKey(cuenta + '_' + tipoAux + '_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + estadoAux)){
                    eventosMeta2.put(cuenta + '_' + tipoAux + '_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + estadoAux, Double.valueOf(ar.get('cantidad')));
                } else{
                    Double cantMet = eventosMeta2.get(cuenta + '_' + tipoAux + '_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + estadoAux);
                    cantMet += Double.valueOf(ar.get('cantidad'));
                    eventosMeta2.put(cuenta + '_' + tipoAux + '_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + estadoAux, cantMet);
                }
                //eventosMeta2.put(cuenta + '_' + String.valueOf(ar.get('tipo')) + '_' + String.valueOf(ar.get('marca')) + '_' + String.valueOf(ar.get('variedad')) + '_' + String.valueOf(ar.get('estado')), Double.valueOf(ar.get('cantidad')));
            }

            for (AggregateResult ar : [Select CRM_Calendario_de_eventos__c idEvento, Max(Id)Id, Max(CRM_Calendario_de_eventos__r.Evento__c)evento, Max(CRM_Calendario_de_eventos__r.Cuenta__c)cuenta, Max(CRM_Calendario_de_eventos__r.Marca__c)marca, Max(CRM_Calendario_de_eventos__r.Cuenta__r.ParentId)principal, Max(Produtividade__c)produtividade, Cultivar__r.Variedade__c variedad, Max(CRM_Calendario_de_eventos__r.Municipio__r.Estado__r.Name)estado
                                       From CRM_Detalle_Calendario_de_eventos__c
                                       Where CRM_Calendario_de_eventos__r.Evento__c In ('Lado a Lado', 'Emplacamento') And (CRM_Calendario_de_eventos__r.Cuenta__c In :accIds Or CRM_Calendario_de_eventos__r.Cuenta__r.ParentId In :accParentIds) And CRM_Calendario_de_eventos__r.Safra__c = '20/21' And CRM_Calendario_de_eventos__r.Fase__c = 'Aprovado' And CRM_Calendario_de_eventos__r.CreatedBy.Name = 'Portal Usuario' And Usar_en_Bonificacion__c = true And CRM_Calendario_de_eventos__r.Fecha_Valida__c = true
                                       Group By CRM_Calendario_de_eventos__c , Cultivar__r.Variedade__c]){
                String cuenta = String.valueOf(ar.get('cuenta'));
                String idEvento = String.valueOf(ar.get('idEvento'));
                if (ar.get('principal') != null)
                    cuenta = String.valueOf(ar.get('principal'));
                //if (ar.get('evento') == 'Emplacamento')
                idEvento = String.valueOf(ar.get('Id')); //Bonif 20/21 siempre toma el id del item para validar q item se usa para bonificar en LxL y Emplac. Se toman todos los items tildados "Usar en Bonif"
                if (!eventosRealizado.containsKey(cuenta + '_' + String.valueOf(ar.get('evento'))+'_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + String.valueOf(ar.get('estado'))+'_' + String.valueOf(ar.get('produtividade'))+'_' + idEvento)){
                    system.debug('PONE REALIZADO: ' + cuenta + '_' + String.valueOf(ar.get('evento'))+'_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + String.valueOf(ar.get('estado')));
                    eventosRealizado.put(cuenta + '_' + String.valueOf(ar.get('evento'))+'_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + String.valueOf(ar.get('estado'))+'_' + String.valueOf(ar.get('produtividade'))+'_' + idEvento, 1);
                } else{
                    Double realizado = eventosRealizado.get(cuenta + '_' + String.valueOf(ar.get('evento'))+'_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + String.valueOf(ar.get('estado'))+'_' + String.valueOf(ar.get('produtividade'))+'_' + idEvento);
                    realizado++;
                    eventosRealizado.remove(cuenta + '_' + String.valueOf(ar.get('evento'))+'_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + String.valueOf(ar.get('estado'))+'_' + String.valueOf(ar.get('produtividade'))+'_' + idEvento);
                    eventosRealizado.put(cuenta + '_' + String.valueOf(ar.get('evento'))+'_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + String.valueOf(ar.get('estado'))+'_' + String.valueOf(ar.get('produtividade'))+'_' + idEvento, realizado);
                    system.debug('ACTUALICE REALIZADO: ' + cuenta + '_' + String.valueOf(ar.get('evento'))+'_' + String.valueOf(ar.get('marca'))+'_' + String.valueOf(ar.get('variedad'))+'_' + String.valueOf(ar.get('estado'))+realizado);
                }
            }

            //**
            for (AggregateResult ar : [Select Id idEvento, Evento__c evento, Cuenta__c cuenta, Marca__c marca, Cuenta__r.ParentId principal, Municipio__r.Estado__r.Name estado
                                       From CRM_Calendario_de_eventos__c 
                                       Where ((Evento__c In ('Palestra', 'Treinamento') And CreatedBy.Name = 'Portal Usuario') Or (Evento__c = 'Día de Campo' And (Custo__c = null Or Custo__c = 0))) And (Cuenta__c In :accIds Or Cuenta__r.ParentId In :accParentIds) And Safra__c = '20/21' And Fase__c = 'Aprovado' And Fecha_Valida__c = true
                                       Group By Id, Evento__c, Cuenta__c, Marca__c, Cuenta__r.ParentId, Municipio__r.Estado__r.Name]){
                String cuenta = String.valueOf(ar.get('cuenta'));
                if (ar.get('principal') != null)
                    cuenta = String.valueOf(ar.get('principal'));
                String eventoAux = String.valueOf(ar.get('evento')); //cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                if ((String.valueOf(ar.get('marca')) == 'BRMX' || String.valueOf(ar.get('marca')) == 'DSEM') && (String.valueOf(ar.get('evento')) == 'Palestra' || String.valueOf(ar.get('evento')) == 'Treinamento')){
                    //cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                    eventoAux = 'PalTrei';
                }
                if (!eventosRealizado.containsKey(cuenta + '_' + eventoAux + '_' + String.valueOf(ar.get('marca'))+'_null_' + String.valueOf(ar.get('estado'))+'_null_' + String.valueOf(ar.get('idEvento')))){
                    eventosRealizado.put(cuenta + '_' + eventoAux + '_' + String.valueOf(ar.get('marca'))+'_null_' + String.valueOf(ar.get('estado'))+'_null_' + String.valueOf(ar.get('idEvento')), 1);
                } else{
                    Double realizado = eventosRealizado.get(cuenta + '_' + eventoAux + '_' + String.valueOf(ar.get('marca'))+'_null_' + String.valueOf(ar.get('estado'))+'_null_' + String.valueOf(ar.get('idEvento')));
                    realizado++;
                    eventosRealizado.remove(cuenta + '_' + eventoAux + '_' + String.valueOf(ar.get('marca'))+'_null_' + String.valueOf(ar.get('estado'))+'_null_' + String.valueOf(ar.get('idEvento')));
                    eventosRealizado.put(cuenta + '_' + eventoAux + '_' + String.valueOf(ar.get('marca'))+'_null_' + String.valueOf(ar.get('estado'))+'_null_' + String.valueOf(ar.get('idEvento')), realizado);
                }
            }
            //**

            //**NEOG
            for (CRM_Calendario_de_eventos__c ar : [Select Id, Evento__c, Cuenta__c, Cuenta__r.ParentId, tieneItems__c, Items_Colhidos__c
                                                    From CRM_Calendario_de_eventos__c
                                                    Where Evento__c In ('Palestra', 'Treinamento', 'Lado a Lado', 'Emplacamento', 'Outdoor', 'Día de Campo', 'Dia de Campo') And CreatedBy.Profile.Name = 'Neogen Partner User' And (Cuenta__c In :accIds Or Cuenta__r.ParentId In :accParentIds) And Safra__c = '20/21' And Fase__c = 'Aprovado' And Marca__c = 'NEOG' And Fecha_Valida__c = true]){
                String cuenta = ar.Cuenta__c;
                if (ar.Cuenta__r.ParentId != null)
                    cuenta = ar.Cuenta__r.ParentId;
                String eventoAux = ar.Evento__c;
                if (eventoAux == 'Lado a Lado'){
                    eventoAux = 'Lado a Lado Plantado';
                    if (ar.tieneItems__c == ar.Items_Colhidos__c)
                        eventoAux = 'Lado a Lado Colhido';
                }
                if (!eventosTotalRealizado.containsKey(cuenta + '_' + eventoAux + '_NEOG')){
                    eventosTotalRealizado.put(cuenta + '_' + eventoAux + '_NEOG', 1);
                } else{
                    Double realizado = eventosTotalRealizado.get(cuenta + '_' + eventoAux + '_NEOG');
                    realizado++;
                    eventosTotalRealizado.remove(cuenta + '_' + eventoAux + '_NEOG');
                    eventosTotalRealizado.put(cuenta + '_' + eventoAux + '_NEOG', realizado);
                }
            }
            //**NEOG

            //**11.09.2019
            for (String s : eventosRealizado.keySet()){
                String[] clave = s.split('_');
                if (clave[1] == 'Día de Campo'){
                    Double cantRealizado = eventosRealizado.get(s);
                    if (eventosTotalRealizado.get(clave[0]+'_' + clave[1]+'_' + clave[2]) == null){
                        eventosTotalRealizado.put(clave[0]+'_' + clave[1]+'_' + clave[2], cantRealizado);
                    } else{
                        Double realizado = eventosTotalRealizado.get(clave[0]+'_' + clave[1]+'_' + clave[2]);
                        realizado += cantRealizado;
                        eventosTotalRealizado.put(clave[0]+'_' + clave[1]+'_' + clave[2], realizado);
                    }
                }
            }
            //**11.09.2019

            //**02.10.2019  ORDENO PARA QUE ME QUEDEN PRIMERO LOS REALIZADOS CON PRODUTIVIDADE
            for (String s : eventosRealizado.keySet()){
                String[] clave = s.split('_');
                if (clave[5] != 'null'){
                    if (Double.valueOf(clave[5]) != 0){
                        eventosRealizado2.put(s, eventosRealizado.get(s));
                        eventosRealizado.remove(s);
                    }
                }
            }
            for (String s : eventosRealizado.keySet())
                eventosRealizado2.put(s, eventosRealizado.get(s));
            //**02.10.2019

            Map<String, Double> lxlRealizadoProdutiv = New Map<String, Double>();
            Set<String> eventosUtilizados = New Set<String>();
            for (String s : eventosMeta.keySet()){
                Double cantMeta = eventosMeta.get(s);
                Double cantRealizado = 0;
                Double cantRealizadoLxlProd = 0;
                String[] claveMeta = s.split('_');
                for (String s2 : eventosRealizado2.keySet()){
                    String[] claveRealizado = s2.split('_');
                    if (!eventosUtilizados.contains(claveRealizado[6])){
                        if (claveMeta[0] == claveRealizado[0] && claveMeta[1] == claveRealizado[1] && claveMeta[2] == claveRealizado[2] && claveMeta[3] == claveRealizado[3] && claveMeta[4] == claveRealizado[4]){
                            cantRealizado += eventosRealizado2.get(s2);
                            if (claveMeta[1] == 'Lado a Lado')
                                if (claveRealizado[5] != 'null')
                                    if (Double.valueOf(claveRealizado[5]) != 0)
                                        cantRealizadoLxlProd += cantRealizado;
                                    eventosUtilizados.add(claveRealizado[6]);
                                if (cantRealizado == cantMeta)
                                    break;
                        }
                    }
                }
                if (cantRealizado != 0){
                    if ((cantMeta - cantRealizado) > 0){
                        eventosMeta.put(s, (cantMeta - cantRealizado));
                    } else{
                        eventosMeta.remove(s);
                    }
                    Double realizado = 0;
                    //////if (eventosTotalRealizado.get(claveMeta[0] + '_' + claveMeta[1] + '_' + claveMeta[2]) != null)
                    //////  realizado = eventosTotalRealizado.get(claveMeta[0] + '_' + claveMeta[1] + '_' + claveMeta[2]);
                    //////realizado += cantRealizado;
                    //////eventosTotalRealizado.put(claveMeta[0] + '_' + claveMeta[1] + '_' + claveMeta[2], realizado);
                    if (eventosTotalRealizado2.get(s) != null)
                        realizado = eventosTotalRealizado2.get(s);
                    realizado += cantRealizado;
                    system.debug('PONE META REALIZADO 2: ' + s + ' ' + realizado);
                    eventosTotalRealizado2.put(s, realizado);
                }
                if (cantRealizadoLxlProd != 0){
                    Double realizado = 0;
                    //////if (lxlRealizadoProdutiv.get(claveMeta[0] + '_' + claveMeta[2]) != null)
                    //////  realizado = lxlRealizadoProdutiv.get(claveMeta[0] + '_' + claveMeta[2]);
                    //////realizado += cantRealizadoLxlProd;
                    //////lxlRealizadoProdutiv.put(claveMeta[0] + '_' + claveMeta[2], realizado);
                    if (lxlRealizadoProdutiv.get(s) != null)
                        realizado = lxlRealizadoProdutiv.get(s);
                    realizado += cantRealizadoLxlProd;
                    lxlRealizadoProdutiv.put(s, realizado);
                }
            }


            system.debug('AAAA: ' + eventosMeta.size()+' ' + eventosRealizado2.size());
            Set<String> realizadoRemover = New Set<String>();
            for (String s : eventosMeta.keySet()){
                Double cantMeta = eventosMeta.get(s);
                Double cantRealizado = 0;
                Double cantRealizadoLxlProd = 0;
                String[] claveMeta = s.split('_');
                for (String s2 : eventosRealizado2.keySet()){
                    String[] claveRealizado = s2.split('_');
                    if (!eventosUtilizados.contains(claveRealizado[6])){
                        if (claveMeta[0] == claveRealizado[0] && claveMeta[1] == claveRealizado[1] && claveMeta[2] == claveRealizado[2]){
                            if (claveMeta[3] == 'null' || claveMeta[3] == claveRealizado[3]){
                                if (claveMeta[4] == 'null' || claveMeta[4] == claveRealizado[4]){
                                    system.debug('MATCHEA: ' + claveMeta + ' ' + claveRealizado);
                                    system.debug('MATCHEA2: ' + cantRealizado + ' ' + eventosRealizado2.get(s2));
                                    cantRealizado += eventosRealizado2.get(s2);
                                    if (claveMeta[1] == 'Lado a Lado')
                                        if (claveRealizado[5] != 'null')
                                            if (Double.valueOf(claveRealizado[5]) != 0)
                                                cantRealizadoLxlProd += cantRealizado;
                                            eventosUtilizados.add(claveRealizado[6]);
                                        if (cantRealizado == cantMeta)
                                            break;
                                }
                            }
                        }
                    }
                }
                if (cantRealizado != 0){
                    Double realizado = 0;
                    //////if (eventosTotalRealizado.get(claveMeta[0] + '_' + claveMeta[1] + '_' + claveMeta[2]) != null)
                    //////  realizado = eventosTotalRealizado.get(claveMeta[0] + '_' + claveMeta[1] + '_' + claveMeta[2]);
                    //////realizado += cantRealizado;
                    //////eventosTotalRealizado.put(claveMeta[0] + '_' + claveMeta[1] + '_' + claveMeta[2], realizado);
                    if (eventosTotalRealizado2.get(s) != null)
                        realizado = eventosTotalRealizado2.get(s);
                    realizado += cantRealizado;
                    system.debug('PONE META REALIZADO 2_2: ' + s + ' ' + realizado);
                    eventosTotalRealizado2.put(s, realizado);
                }
                if (cantRealizadoLxlProd != 0){
                    Double realizado = 0;
                    //////if (lxlRealizadoProdutiv.get(claveMeta[0] + '_' + claveMeta[2]) != null)
                    //////  realizado = lxlRealizadoProdutiv.get(claveMeta[0] + '_' + claveMeta[2]);
                    //////realizado += cantRealizadoLxlProd;
                    //////lxlRealizadoProdutiv.put(claveMeta[0] + '_' + claveMeta[2], realizado);
                    if (lxlRealizadoProdutiv.get(s) != null)
                        realizado = lxlRealizadoProdutiv.get(s);
                    realizado += cantRealizadoLxlProd;
                    lxlRealizadoProdutiv.put(s, realizado);
                }
            }

            for (String s : eventosMeta2.keySet()){
                system.debug('BBBB: ' + s);
                String[] claveMeta = s.split('_');
                Double cantMeta = eventosMeta2.get(s);
                Double cantRealizado = 0;
                Boolean noSumarLxL = false; //27.04.2020 REPORTE KLEBER
                if (eventosTotalRealizado2.get(s) != null)
                    cantRealizado = eventosTotalRealizado2.get(s);
                system.debug('DAME META 1: ' + s + ' ' + cantRealizado);
                if (claveMeta[1] == 'Emplacamento'){
                    if ((cantRealizado / cantMeta) < 0.8)
                        continue;
                    cantRealizado = cantMeta;
                }
                if (claveMeta[1] == 'Lado a Lado'){
                    Double cantRealizado2 = 0;
                    if (lxlRealizadoProdutiv.get(s) != null)
                        cantRealizado2 = lxlRealizadoProdutiv.get(s);
                    //if (((cantRealizado / cantMeta) < 0.8) || ((cantRealizado2 / cantMeta) < 0.5))  27.04.2020 COMENTADO REPORTE KLEBER
                    if ((cantRealizado / cantMeta) < 0.5)
                        continue;
                    cantRealizado = cantMeta;

                    //27.04.2020 AGREGADO PARA REPORTE KLEBER
                    if ((cantRealizado2 / cantMeta) < 0.5)
                        noSumarLxL = true;
                    //27.04.2020 AGREGADO PARA REPORTE KLEBER
                }

                Double realizado = 0;
                if (eventosTotalRealizado.get(claveMeta[0]+'_' + claveMeta[1]+'_' + claveMeta[2]) != null)
                    realizado = eventosTotalRealizado.get(claveMeta[0]+'_' + claveMeta[1]+'_' + claveMeta[2]);
                realizado += cantRealizado;
                system.debug('PONE META TOTAL: ' + claveMeta[0]+'_' + claveMeta[1]+'_' + claveMeta[2]+' ' + realizado);
                eventosTotalRealizado.put(claveMeta[0]+'_' + claveMeta[1]+'_' + claveMeta[2], realizado);

                //27.04.2020 AGREGADO PARA REPORTE KLEBER
                if (claveMeta[1] == 'Lado a Lado' && claveMeta[2] == 'BRMX'){
                    Double realizado99 = 0;
                    if (eventosTotalRealizado.get(claveMeta[0]+'_' + claveMeta[1]+'2_' + claveMeta[2]) != null)
                        realizado99 = eventosTotalRealizado.get(claveMeta[0]+'_' + claveMeta[1]+'2_' + claveMeta[2]);
                    if (!noSumarLxL)
                        realizado99 += cantRealizado;
                    eventosTotalRealizado.put(claveMeta[0]+'_' + claveMeta[1]+'2_' + claveMeta[2], realizado99);
                }
                //27.04.2020 AGREGADO PARA REPORTE KLEBER
            }

            //**
            List<CRM_Multiplicador__c> crm_mult = New List<CRM_Multiplicador__c>();
            crm_mult = [Select Id, Cuenta__c, Cuenta__r.ParentId, BR_Palestras_Realizado__c, BR_Treinamentos_Realizado__c, BR_LXL_Realizado__c, BR_Participacao_dia_campo_realizado__c, DS_Participaca_dias_de_campo__c, BR_Participacao_dia_de_campo_meta__c, DS_Identifica_o_de_beiras_de_rodovia__c, BR_Palestras_Meta__c, BR_Treinamentos_Meta__c, BR_LXL_Meta__c, BR_Emplacamentos_Meta__c, DS_Emplacamentos_Meta__c, BR_Realizado_LxL_Con_Prod__c, NG_LXL_Realizado_Plantado__c, NG_LXL_Realizado_Colhido__c, NG_Palestras_Realizado__c, NG_Identifica_o_de_beiras_de_rodovia__c, NG_Outdoor_Realizado__c, NG_Treinamentos_Realizado__c, NG_Participacao_dia_campo_realizado__c
                        From CRM_Multiplicador__c
                        Where (Cuenta__c In :accIds Or Cuenta__r.ParentId In :accParentIds) And Safra__c = '20/21'];
            if (crm_mult.size() > 0){
                for (CRM_Multiplicador__c crm : crm_mult){
                    String cuenta = crm.Cuenta__c;
                    if (crm.Cuenta__r.ParentId != null)
                        cuenta = crm.Cuenta__r.ParentId;
                    crm.BR_Palestras_Realizado__c = eventosTotalRealizado.get(cuenta + '_PalTrei_BRMX'); //cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                    //crm.BR_Palestras_Realizado__c = eventosTotalRealizado.get(cuenta + '_Palestra_BRMX'); cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                    //crm.BR_Treinamentos_Realizado__c = eventosTotalRealizado.get(cuenta + '_Treinamento_BRMX'); cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                    crm.BR_LXL_Realizado__c = eventosTotalRealizado.get(cuenta + '_Lado a Lado_BRMX');
                    crm.BR_Participacao_dia_campo_realizado__c = eventosTotalRealizado.get(cuenta + '_Día de Campo_BRMX');
                    crm.BR_Identifica_o_de_beiras_de_rodovia__c = eventosTotalRealizado.get(cuenta + '_Emplacamento_BRMX');
                    crm.DS_Palestras_Realizado__c = eventosTotalRealizado.get(cuenta + '_PalTrei_DSEM'); //cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                    //crm.DS_Palestras_Realizado__c = eventosTotalRealizado.get(cuenta + '_Palestra_DSEM');cambio 16072020 Kleber ticket 41036 y 22102020 Natalia ticket 44269
                    crm.DS_LXL_Realizado__c = eventosTotalRealizado.get(cuenta + '_Lado a Lado_DSEM');
                    crm.DS_Participacao_dia_campo_realizado__c = eventosTotalRealizado.get(cuenta + '_Día de Campo_DSEM');
                    crm.DS_Identifica_o_de_beiras_de_rodovia__c = eventosTotalRealizado.get(cuenta + '_Emplacamento_DSEM');
                    crm.NG_LXL_Realizado_Plantado__c = eventosTotalRealizado.get(cuenta + '_Lado a Lado Plantado_NEOG');
                    crm.NG_LXL_Realizado_Colhido__c = eventosTotalRealizado.get(cuenta + '_Lado a Lado Colhido_NEOG');
                    crm.NG_Palestras_Realizado__c = eventosTotalRealizado.get(cuenta + '_Palestra_NEOG');
                    crm.NG_Identifica_o_de_beiras_de_rodovia__c = eventosTotalRealizado.get(cuenta + '_Emplacamento_NEOG');
                    crm.NG_Outdoor_Realizado__c = eventosTotalRealizado.get(cuenta + '_Outdoor_NEOG');
            crm.NG_Treinamentos_Realizado__c = eventosTotalRealizado.get(cuenta + '_Treinamento_NEOG');
                    crm.NG_Participacao_dia_campo_realizado__c = eventosTotalRealizado.get(cuenta + '_Dia de Campo_NEOG');                                          
            if (crm.NG_LXL_Realizado_Plantado__c == null)
                        crm.NG_LXL_Realizado_Plantado__c = 0;
                    if (crm.NG_LXL_Realizado_Colhido__c == null)
                        crm.NG_LXL_Realizado_Colhido__c = 0;
                    if (crm.NG_Palestras_Realizado__c == null)
                        crm.NG_Palestras_Realizado__c = 0;
                    if (crm.NG_Identifica_o_de_beiras_de_rodovia__c == null)
                        crm.NG_Identifica_o_de_beiras_de_rodovia__c = 0;
                    if (crm.NG_Outdoor_Realizado__c == null)
                        crm.NG_Outdoor_Realizado__c = 0;
                    if (crm.NG_Treinamentos_Realizado__c == null)
                        crm.NG_Treinamentos_Realizado__c = 0;    
                    if (crm.NG_Participacao_dia_campo_realizado__c == null)
                        crm.NG_Participacao_dia_campo_realizado__c = 0;                            
                //27.04.2020 AGREGADO PARA REPORTE KLEBER
                    crm.BR_Realizado_LxL_Con_Prod__c = eventosTotalRealizado.get(cuenta + '_Lado a Lado2_BRMX');

                    CRM_Multiplicador__c crm2 = eventosTotalMeta.get(cuenta + '_BRMX');
                    if (crm2 != null){
                        crm.BR_Participacao_dia_de_campo_meta__c = Double.valueOf(crm2.BR_Participacao_dia_de_campo_meta__c);
                        crm.BR_Emplacamentos_Meta__c = Double.valueOf(crm2.BR_Emplacamentos_Meta__c);
                        crm.BR_LXL_Meta__c = Double.valueOf(crm2.BR_LXL_Meta__c);
                        crm.BR_Palestras_Meta__c = Double.valueOf(crm2.BR_Palestras_Meta__c);
                        //crm.BR_Treinamentos_Meta__c = Double.valueOf(crm2.BR_Treinamentos_Meta__c); cambio 16072020 Kleber ticket 41036
                    }
                    crm2 = eventosTotalMeta.get(cuenta + '_DSEM');
                    if (crm2 != null){
                        crm.DS_Participacao_dia_de_campo_meta__c = Double.valueOf(crm2.BR_Participacao_dia_de_campo_meta__c);
                        crm.DS_Emplacamentos_Meta__c = Double.valueOf(crm2.BR_Emplacamentos_Meta__c);
                        crm.DS_LXL_Meta__c = Double.valueOf(crm2.BR_LXL_Meta__c);
                        crm.DS_Palestras_Meta__c = Double.valueOf(crm2.BR_Palestras_Meta__c);
                    }
                }
                update crm_mult;
            }
            //**

        }
    }

    public static void procesarEstimativasFaturamento(String safra){

        Map<String, String> mapVari = New Map<String, String>();

        Map<String, Double> ventasTotalesBRMX = New Map<String, Double>();
        Map<String, Double> ventasBRMXIntacta = New Map<String, Double>();
        Map<String, Double> ventasXVariedadBRMX = New Map<String, Double>();
        Map<String, Double> ventasXVariCuentaBRMX = New Map<String, Double>();

        Set<String> accIds = New Set<String>();

        for (Variedad__c v : [Select Id, Region_bonificacion__c
                              From Variedad__c])
            mapVari.put(v.Id, v.Region_bonificacion__c);
        for (AggregateResult ar : [Select Sum(Estimativa__c) estimativa, Opportunity.AccountId cuenta, Opportunity.Account.ParentId principal, Opportunity.Region__c region, PricebookEntry.Product2.Variedade__c variedad, PricebookEntry.Product2.Variedade__r.Tecnologia__c tecno
                                   From OpportunityLineItem 
                                   Where Opportunity.Safra__c = :safra And Opportunity.Activa__c = true And Opportunity.RecordType.Name = 'Estimativa de faturamento' And Opportunity.Marca__c = 'BRMX'
                                   Group By Opportunity.Account.ParentId, Opportunity.AccountId, Opportunity.Region__c, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Tecnologia__c]){
            String cuenta = String.valueOf(ar.get('cuenta'));
            accIds.add(cuenta);
            if (ar.get('principal') != null)
                cuenta = String.valueOf(ar.get('principal'));
            String region = String.valueOf(ar.get('region'));
            if (region == 'REGION 1' || region == 'REGION 2')
                region = 'SUL';
            String region_vari = mapVari.get(String.valueOf(ar.get('variedad')));

            if (!ventasTotalesBRMX.containsKey(cuenta)){
                ventasTotalesBRMX.put(cuenta, Double.valueOf(ar.get('estimativa')));
            } else{
                Double ventasTB = ventasTotalesBRMX.get(cuenta);
                ventasTB += Double.valueOf(ar.get('estimativa'));
                ventasTotalesBRMX.remove(cuenta);
                ventasTotalesBRMX.put(cuenta, ventasTB);
            }
            if (!ventasXVariedadBRMX.containsKey(cuenta + String.valueOf(ar.get('variedad')))){
                ventasXVariedadBRMX.put(cuenta + String.valueOf(ar.get('variedad')), Double.valueOf(ar.get('estimativa')));
            } else{
                Double ventasXVar = ventasXVariedadBRMX.get(cuenta + String.valueOf(ar.get('variedad')));
                ventasXVar += Double.valueOf(ar.get('estimativa'));
                ventasXVariedadBRMX.remove(cuenta + String.valueOf(ar.get('variedad')));
                ventasXVariedadBRMX.put(cuenta + String.valueOf(ar.get('variedad')), ventasXVar);
            }
            if (String.valueOf(ar.get('tecno')) == 'IPRO'){
                if (!ventasBRMXIntacta.containsKey(cuenta)){
                    ventasBRMXIntacta.put(cuenta, Double.valueOf(ar.get('estimativa')));
                } else{
                    Double ventasB = ventasBRMXIntacta.get(cuenta);
                    ventasB += Double.valueOf(ar.get('estimativa'));
                    ventasBRMXIntacta.remove(cuenta);
                    ventasBRMXIntacta.put(cuenta, ventasB);
                }
            }

        }

        for (String key : ventasXVariedadBRMX.keySet()){
            if (!ventasXVariCuentaBRMX.containsKey(key.substring(0, 18))){
                ventasXVariCuentaBRMX.put(key.substring(0, 18), Double.valueOf(ventasXVariedadBRMX.get(key)));
            } else{
                Double ventasXVarC = ventasXVariCuentaBRMX.get(key.substring(0, 18));
                if (Double.valueOf(ventasXVariedadBRMX.get(key)) > ventasXVarC){
                    ventasXVarC = Double.valueOf(ventasXVariedadBRMX.get(key));
                    ventasXVariCuentaBRMX.remove(key.substring(0, 18));
                    ventasXVariCuentaBRMX.put(key.substring(0, 18), ventasXVarC);
                }
            }
        }

        List<CRM_Multiplicador__c> crm_mult = New List<CRM_Multiplicador__c>();
        crm_mult = [Select Id, Cuenta__c, Cuenta__r.ParentId, Safra__c, BR_Soma_de_Sem_Comercializada_Estim__c, BR_SemComer_Safra_actual_Estim__c, BR_Mix_de_Produto_Estim__c
                    From CRM_Multiplicador__c
                    Where Cuenta__c In :accIds And Safra__c = :safra];
        if (crm_mult.size() > 0){
            for (CRM_Multiplicador__c crm : crm_mult){
                String cuenta = crm.Cuenta__c;
                if (crm.Cuenta__r.ParentId != null)
                    cuenta = crm.Cuenta__r.ParentId;
                crm.BR_Soma_de_Sem_Comercializada_Estim__c = ventasBRMXIntacta.get(cuenta);
                crm.BR_SemComer_Safra_actual_Estim__c = ventasTotalesBRMX.get(cuenta);

                Double porcVari = 0;
                if (ventasXVariCuentaBRMX.get(cuenta) != null && crm.BR_SemComer_Safra_actual_Estim__c != null && crm.BR_SemComer_Safra_actual_Estim__c != 0){
                    porcVari = ventasXVariCuentaBRMX.get(cuenta) * 100 / crm.BR_SemComer_Safra_actual_Estim__c;
                }
                crm.BR_Mix_de_Produto_Estim__c = porcVari;
            }

            update crm_mult;

        }

        Map<String, CRM_Multiplicador__c> mapAccMult = New Map<String, CRM_Multiplicador__c>();
        for (CRM_Multiplicador__c c : [Select Id, Cuenta__c, BR_Categoria_resultante_Estim__c, BRMX_Desconto_Classe_1_Estim__c, BRMX_Desconto_Classe_2_Estim__c, BRMX_Desconto_Classe_3_Estim__c, BRMX_Desconto_Obj_Rel_Gen_Dem_Estim__c
                                       From CRM_Multiplicador__c
                                       Where Cuenta__c In :accIds And Safra__c = :safra]){
            mapAccMult.put(c.Cuenta__c, c);
        }

        List<Opportunity> oppsUpd = New List<Opportunity>();
        List<OpportunityLineItem> itemsUpd = New List<OpportunityLineItem>();
        oppsUpd = [Select Id, AccountId, Region__c, Categoria_Cliente__c, (Select Id, PriceBookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c, Descuento_porc__c
                                                                           From OpportunityLineItems)
                   From Opportunity 
                   Where Safra__c = :safra And Activa__c = true And RecordType.Name = 'Estimativa de faturamento' And Marca__c = 'BRMX'];
        if (oppsUpd.size() > 0){
            for (Opportunity o : oppsUpd){
                CRM_Multiplicador__c crm = mapAccMult.get(o.AccountId);
                if (crm != null){
                    o.Categoria_Cliente__c = crm.BR_Categoria_resultante_Estim__c;
                    for (OpportunityLineItem i : o.OpportunityLineItems){
                        if (i.PriceBookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c == '1')
                            i.Descuento_porc__c = crm.BRMX_Desconto_Classe_1_Estim__c;
                        if (i.PriceBookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c == '2')
                            i.Descuento_porc__c = crm.BRMX_Desconto_Classe_2_Estim__c;
                        if (i.PriceBookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c == '3'){
                            i.Descuento_porc__c = crm.BRMX_Desconto_Classe_3_Estim__c;
                            if ((o.Region__c == 'REGION 1' || o.Region__c == 'REGION 2') && crm.BRMX_Desconto_Obj_Rel_Gen_Dem_Estim__c > 12.5){
                                i.Descuento_porc__c = (crm.BRMX_Desconto_Classe_3_Estim__c - crm.BRMX_Desconto_Obj_Rel_Gen_Dem_Estim__c + 12.5).divide(1, 2, System.RoundingMode.HALF_DOWN);
                                i.Descuento_Adicional_Porc__c = (crm.BRMX_Desconto_Obj_Rel_Gen_Dem_Estim__c - 12.5).divide(1, 2, System.RoundingMode.HALF_DOWN);
                            }
                            if ((o.Region__c == 'CERRADO') && crm.BRMX_Desconto_Obj_Rel_Gen_Dem_Estim__c > 11.76){
                                i.Descuento_porc__c = (crm.BRMX_Desconto_Classe_3_Estim__c - crm.BRMX_Desconto_Obj_Rel_Gen_Dem_Estim__c + 11.76).divide(1, 2, System.RoundingMode.HALF_DOWN);
                                i.Descuento_Adicional_Porc__c = (crm.BRMX_Desconto_Obj_Rel_Gen_Dem_Estim__c - 11.76).divide(1, 2, System.RoundingMode.HALF_DOWN);
                            }
                        }
                        itemsUpd.add(i);
                    }
                }
            }
            update oppsUpd;
            if (itemsUpd.size() > 0)
                update itemsUpd;
        }
    }

    public static void actualizarVentasPerfilCuenta2(Opportunity[] oppsNew, Opportunity[] oppsOld){

        if (Test.isRunningTest())
            return;
        Id rt_stock = null;
        Id rt_aIII = null;
        Id rt_aIV = null;

        rt_stock = '01240000000M9lt';
        rt_aIII = '01240000000M7y6';
        rt_aIV = '01240000000M7y8';

        Set<Id> accIds = New Set<Id>();
        Set<String> accParentIds = New Set<String>();
        accParentIds.add('111111111111111'); //Para cuando consulto que los parentid esten en esta coleccion por lo menos que tenga algo. Si es nulo me va a traer cuentas que no me interesan.

        Map<String, Double> ventasBRMXIntactaStock = New Map<String, Double>();
        Map<String, Double> ventasDSEMIntactaStock = New Map<String, Double>();
        Map<String, Double> ventasNEOGIntactaStock = New Map<String, Double>();
        Map<String, Double> ventasDAGMAIntactaStock = New Map<String, Double>();
        Map<String, Double> ventasLICENCASIntactaStock = New Map<String, Double>();
        Map<String, Double> ventasXVariedadBRMXStock = New Map<String, Double>();
        Map<String, Double> ventasXVariCuentaBRMXStock = New Map<String, Double>();
        Map<String, Double> ventasTotalesStock = New Map<String, Double>();
        Map<String, Double> ventasTotalesBRMXStock = New Map<String, Double>();

        Map<String, Double> ventasBRMXIntacta = New Map<String, Double>();
        Map<String, Double> ventasDSEMIntacta = New Map<String, Double>();
        Map<String, Double> ventasNEOGIntacta = New Map<String, Double>();
        Map<String, Double> ventasDAGMAIntacta = New Map<String, Double>();
        Map<String, Double> ventasLICENCASIntacta = New Map<String, Double>();
        Map<String, Double> ventasXVariedadBRMX = New Map<String, Double>();
        Map<String, Double> ventasXVariCuentaBRMX = New Map<String, Double>();
        Map<String, Double> ventasTotales = New Map<String, Double>();
        Map<String, Double> ventasTotalesBRMX = New Map<String, Double>();

        Map<String, String> mapVari = New Map<String, String>();

        Set<String> accIdsAnexo = New Set<String>();

        if (oppsNew != null)
            for (Opportunity o : oppsNew)
                if (o.RecordTypeId == rt_stock || o.RecordTypeId == rt_aIII || o.RecordTypeId == rt_aIV)
                    accIds.add(o.AccountId);
                if (oppsOld != null)
                    for (Opportunity o : oppsOld)
                        if (o.RecordTypeId == rt_stock || o.RecordTypeId == rt_aIII || o.RecordTypeId == rt_aIV)
                            accIds.add(o.AccountId);
                    if (accIds.size() > 0){
                        for (Variedad__c v : [Select Id, Region_bonificacion__c
                                                From Variedad__c])
                            mapVari.put(v.Id, v.Region_bonificacion__c);
                        for (Account a : [Select Id, ParentId
                                          From Account
                                              Where Id In :accIds])
                            if (a.ParentId != null)
                                accParentIds.add(a.ParentId);
                            for (AggregateResult ar : [Select Sum(Semente_comercializada__c) semC, Sum(Semente_uso_propio__c) semUP, Opportunity.RecordType.Name tipoReg, Opportunity.AccountId cuenta, Opportunity.Account.ParentId principal, Opportunity.Marca__c marca, Opportunity.Region__c region, PricebookEntry.Product2.Variedade__c variedad, PricebookEntry.Product2.Variedade__r.Tecnologia__c tecno
                                                       From OpportunityLineItem 
                                                       Where (Opportunity.AccountId In :accIds Or Opportunity.Account.ParentId In :accParentIds) And Opportunity.Safra__c = '20/21' And ((Opportunity.RecordType.Name = 'Stock Multiplicadores' And Opportunity.Activa__c = true And Opportunity.StageName = 'Aprobada') Or (Opportunity.RecordType.Name In ('Anexo III', 'Anexo IV') And Opportunity.StageName In ('Pendiente de Análisis', 'Pendiente de Aprobación', 'Aprobada'))) 
                                                       Group By Opportunity.RecordType.Name, Opportunity.Account.ParentId, Opportunity.AccountId, Opportunity.Marca__c, Opportunity.Region__c, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Tecnologia__c]){
                                String cuenta = String.valueOf(ar.get('cuenta'));
                            if (ar.get('principal') != null)
                                cuenta = String.valueOf(ar.get('principal'));
                            String region = String.valueOf(ar.get('region'));
                        if (region == 'REGION 1' || region == 'REGION 2')
                            region = 'SUL';
                        String region_vari = mapVari.get(String.valueOf(ar.get('variedad')));
                    if (region_vari != null && region != null && region_vari.contains(region)){
                        if ((String.valueOf(ar.get('tipoReg')) == 'Stock Multiplicadores')){
                            if (!ventasTotalesStock.containsKey(cuenta)){
                                ventasTotalesStock.put(cuenta, Double.valueOf(ar.get('semC')));
                        } else{
                            Double ventasT = ventasTotalesStock.get(cuenta);
                            ventasT += Double.valueOf(ar.get('semC'));
                            ventasTotalesStock.remove(cuenta);
                            ventasTotalesStock.put(cuenta, ventasT);
                        }
                        if (String.valueOf(ar.get('marca')) == 'BRMX'){
                            if (!ventasTotalesBRMXStock.containsKey(cuenta)){
                                ventasTotalesBRMXStock.put(cuenta, Double.valueOf(ar.get('semC')));
                            } else{
                                Double ventasTB = ventasTotalesBRMXStock.get(cuenta);
                                ventasTB += Double.valueOf(ar.get('semC'));
                                ventasTotalesBRMXStock.remove(cuenta);
                                ventasTotalesBRMXStock.put(cuenta, ventasTB);
                            }
                            if (!ventasXVariedadBRMXStock.containsKey(cuenta + String.valueOf(ar.get('variedad')))){
                                ventasXVariedadBRMXStock.put(cuenta + String.valueOf(ar.get('variedad')), Double.valueOf(ar.get('semC')));
                            } else{
                                Double ventasXVar = ventasXVariedadBRMXStock.get(cuenta + String.valueOf(ar.get('variedad')));
                                ventasXVar += Double.valueOf(ar.get('semC'));
                                ventasXVariedadBRMXStock.remove(cuenta + String.valueOf(ar.get('variedad')));
                                ventasXVariedadBRMXStock.put(cuenta + String.valueOf(ar.get('variedad')), ventasXVar);
                            }
                            if (String.valueOf(ar.get('tecno')) == 'IPRO' || String.valueOf(ar.get('tecno')) == 'CE' || String.valueOf(ar.get('tecno')) == 'E' || String.valueOf(ar.get('tecno')) == 'I2X'){ //*****
                                if (!ventasBRMXIntactaStock.containsKey(cuenta)){
                                    ventasBRMXIntactaStock.put(cuenta, Double.valueOf(ar.get('semC')));
                                } else{
                                    Double ventasB = ventasBRMXIntactaStock.get(cuenta);
                                    ventasB += Double.valueOf(ar.get('semC'));
                                    ventasBRMXIntactaStock.remove(cuenta);
                                    ventasBRMXIntactaStock.put(cuenta, ventasB);
                                }
                            }
                        }
                        if (String.valueOf(ar.get('marca')) == 'DSEM' && (String.valueOf(ar.get('tecno')) == 'IPRO' || String.valueOf(ar.get('tecno')) == 'CE' || String.valueOf(ar.get('tecno')) == 'E' || String.valueOf(ar.get('tecno')) == 'I2X')){ //**********
                            if (!ventasDSEMIntactaStock.containsKey(cuenta)){
                                ventasDSEMIntactaStock.put(cuenta, Double.valueOf(ar.get('semC')));
                            } else{
                                Double ventasD = ventasDSEMIntactaStock.get(cuenta);
                                ventasD += Double.valueOf(ar.get('semC'));
                                ventasDSEMIntactaStock.remove(cuenta);
                                ventasDSEMIntactaStock.put(cuenta, ventasD);
                            }
                        }
                        if (String.valueOf(ar.get('marca')) == 'NEOG' && (String.valueOf(ar.get('tecno')) == 'IPRO' || String.valueOf(ar.get('tecno')) == 'CE' || String.valueOf(ar.get('tecno')) == 'E' || String.valueOf(ar.get('tecno')) == 'I2X')){ //******************
                            if (!ventasNEOGIntactaStock.containsKey(cuenta)){
                                ventasNEOGIntactaStock.put(cuenta, Double.valueOf(ar.get('semC')));
                            } else{
                                Double ventasN = ventasNEOGIntactaStock.get(cuenta);
                                ventasN += Double.valueOf(ar.get('semC'));
                                ventasNEOGIntactaStock.remove(cuenta);
                                ventasNEOGIntactaStock.put(cuenta, ventasN);
                            }
                        }
                        if (String.valueOf(ar.get('marca')) == 'DAGMA' && (String.valueOf(ar.get('tecno')) == 'IPRO' || String.valueOf(ar.get('tecno')) == 'CE' || String.valueOf(ar.get('tecno')) == 'E' || String.valueOf(ar.get('tecno')) == 'I2X')){ //******************
                            if (!ventasDAGMAIntactaStock.containsKey(cuenta)){
                                ventasDAGMAIntactaStock.put(cuenta, Double.valueOf(ar.get('semC')));
                            } else{
                                Double ventasD = ventasDAGMAIntactaStock.get(cuenta);
                                ventasD += Double.valueOf(ar.get('semC'));
                                ventasDAGMAIntactaStock.remove(cuenta);
                                ventasDAGMAIntactaStock.put(cuenta, ventasD);
                            }
                        }
                        if (String.valueOf(ar.get('marca')) == 'LICENÇAS' && (String.valueOf(ar.get('tecno')) == 'IPRO' || String.valueOf(ar.get('tecno')) == 'CE' || String.valueOf(ar.get('tecno')) == 'E' || String.valueOf(ar.get('tecno')) == 'I2X')){ //******************
                            if (!ventasLICENCASIntactaStock.containsKey(cuenta)){
                                ventasLICENCASIntactaStock.put(cuenta, Double.valueOf(ar.get('semC')));
                            } else{
                                Double ventasL = ventasLICENCASIntactaStock.get(cuenta);
                                ventasL += Double.valueOf(ar.get('semC'));
                                ventasLICENCASIntactaStock.remove(cuenta);
                                ventasLICENCASIntactaStock.put(cuenta, ventasL);
                            }
                        }
                    }
                    //************************************************************************************************************************************************
                    if ((String.valueOf(ar.get('tipoReg')) == 'Anexo III' || String.valueOf(ar.get('tipoReg')) == 'Anexo IV')){
                        accIdsAnexo.add(cuenta + String.valueOf(ar.get('marca')));
                        if (!ventasTotales.containsKey(cuenta)){
                            ventasTotales.put(cuenta, Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                        } else{
                            Double ventasT = ventasTotales.get(cuenta);
                            ventasT += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                            ventasTotales.remove(cuenta);
                            ventasTotales.put(cuenta, ventasT);
                        }
                        if (String.valueOf(ar.get('marca')) == 'BRMX'){
                            if (!ventasTotalesBRMX.containsKey(cuenta)){
                                ventasTotalesBRMX.put(cuenta, Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                            } else{
                                Double ventasTB = ventasTotalesBRMX.get(cuenta);
                                ventasTB += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                                ventasTotalesBRMX.remove(cuenta);
                                ventasTotalesBRMX.put(cuenta, ventasTB);
                            }
                            if (!ventasXVariedadBRMX.containsKey(cuenta + String.valueOf(ar.get('variedad')))){
                                ventasXVariedadBRMX.put(cuenta + String.valueOf(ar.get('variedad')), Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                            } else{
                                Double ventasXVar = ventasXVariedadBRMX.get(cuenta + String.valueOf(ar.get('variedad')));
                                ventasXVar += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                                ventasXVariedadBRMX.remove(cuenta + String.valueOf(ar.get('variedad')));
                                ventasXVariedadBRMX.put(cuenta + String.valueOf(ar.get('variedad')), ventasXVar);
                            }
                            if (String.valueOf(ar.get('tecno')) == 'IPRO' || String.valueOf(ar.get('tecno')) == 'CE' || String.valueOf(ar.get('tecno')) == 'E' || String.valueOf(ar.get('tecno')) == 'I2X'){  //*********************
                                if (!ventasBRMXIntacta.containsKey(cuenta)){
                                    ventasBRMXIntacta.put(cuenta, Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                                } else{
                                    Double ventasB = ventasBRMXIntacta.get(cuenta);
                                    ventasB += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                                    ventasBRMXIntacta.remove(cuenta);
                                    ventasBRMXIntacta.put(cuenta, ventasB);
                                }
                            }
                        }
                        if (String.valueOf(ar.get('marca')) == 'DSEM' && (String.valueOf(ar.get('tecno')) == 'IPRO' || String.valueOf(ar.get('tecno')) == 'CE' || String.valueOf(ar.get('tecno')) == 'E' || String.valueOf(ar.get('tecno')) == 'I2X')){  //**************
                            if (!ventasDSEMIntacta.containsKey(cuenta)){
                                ventasDSEMIntacta.put(cuenta, Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                            } else{
                                Double ventasD = ventasDSEMIntacta.get(cuenta);
                                ventasD += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                                ventasDSEMIntacta.remove(cuenta);
                                ventasDSEMIntacta.put(cuenta, ventasD);
                            }
                        }
                        if (String.valueOf(ar.get('marca')) == 'NEOG' && (String.valueOf(ar.get('tecno')) == 'IPRO' || String.valueOf(ar.get('tecno')) == 'CE' || String.valueOf(ar.get('tecno')) == 'E' || String.valueOf(ar.get('tecno')) == 'I2X')){  //***************
                            if (!ventasNEOGIntacta.containsKey(cuenta)){
                                ventasNEOGIntacta.put(cuenta, Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                            } else{
                                Double ventasN = ventasNEOGIntacta.get(cuenta);
                                ventasN += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                                ventasNEOGIntacta.remove(cuenta);
                                ventasNEOGIntacta.put(cuenta, ventasN);
                            }
                        }
                        if (String.valueOf(ar.get('marca')) == 'DAGMA' && (String.valueOf(ar.get('tecno')) == 'IPRO' || String.valueOf(ar.get('tecno')) == 'CE' || String.valueOf(ar.get('tecno')) == 'E' || String.valueOf(ar.get('tecno')) == 'I2X')){  //***************
                            if (!ventasDAGMAIntacta.containsKey(cuenta)){
                                ventasDAGMAIntacta.put(cuenta, Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                            } else{
                                Double ventasD = ventasDAGMAIntacta.get(cuenta);
                                ventasD += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                                ventasDAGMAIntacta.remove(cuenta);
                                ventasDAGMAIntacta.put(cuenta, ventasD);
                            }
                        }
                        if (String.valueOf(ar.get('marca')) == 'LICENÇAS' && (String.valueOf(ar.get('tecno')) == 'IPRO' || String.valueOf(ar.get('tecno')) == 'CE' || String.valueOf(ar.get('tecno')) == 'E' || String.valueOf(ar.get('tecno')) == 'I2X')){  //***************
                            if (!ventasLICENCASIntacta.containsKey(cuenta)){
                                ventasLICENCASIntacta.put(cuenta, Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                            } else{
                                Double ventasL = ventasLICENCASIntacta.get(cuenta);
                                ventasL += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                                ventasLICENCASIntacta.remove(cuenta);
                                ventasLICENCASIntacta.put(cuenta, ventasL);
                            }
                        }
                    }

                }

            }

            for (String key : ventasXVariedadBRMXStock.keySet()){
                if (!ventasXVariCuentaBRMXStock.containsKey(key.substring(0, 18))){
                    ventasXVariCuentaBRMXStock.put(key.substring(0, 18), Double.valueOf(ventasXVariedadBRMXStock.get(key)));
                } else{
                    Double ventasXVarC = ventasXVariCuentaBRMXStock.get(key.substring(0, 18));
                    if (Double.valueOf(ventasXVariedadBRMXStock.get(key)) > ventasXVarC){
                        ventasXVarC = Double.valueOf(ventasXVariedadBRMXStock.get(key));
                        ventasXVariCuentaBRMXStock.remove(key.substring(0, 18));
                        ventasXVariCuentaBRMXStock.put(key.substring(0, 18), ventasXVarC);
                    }
                }
            }

            for (String key : ventasXVariedadBRMX.keySet()){
                if (!ventasXVariCuentaBRMX.containsKey(key.substring(0, 18))){
                    ventasXVariCuentaBRMX.put(key.substring(0, 18), Double.valueOf(ventasXVariedadBRMX.get(key)));
                } else{
                    Double ventasXVarC = ventasXVariCuentaBRMX.get(key.substring(0, 18));
                    if (Double.valueOf(ventasXVariedadBRMX.get(key)) > ventasXVarC){
                        ventasXVarC = Double.valueOf(ventasXVariedadBRMX.get(key));
                        ventasXVariCuentaBRMX.remove(key.substring(0, 18));
                        ventasXVariCuentaBRMX.put(key.substring(0, 18), ventasXVarC);
                    }
                }
            }

            List<CRM_Multiplicador__c> crm_mult = New List<CRM_Multiplicador__c>();
            crm_mult = [Select Id, Cuenta__c, Cuenta__r.ParentId, Safra__c, BR_Soma_de_Sem_Comercializada__c, DSoma_de_Sem_Comercializada__c, SSemComer_Safra_actual__c, NG_Soma_de_Sem_Comercializada__c
                        From CRM_Multiplicador__c
                        Where (Cuenta__c In :accIds Or Cuenta__r.ParentId In :accParentIds) And Safra__c In ('20/21', '21/22')];
            if (crm_mult.size() > 0){
                for (CRM_Multiplicador__c crm : crm_mult){
                    String cuenta = crm.Cuenta__c;
                    if (crm.Cuenta__r.ParentId != null)
                        cuenta = crm.Cuenta__r.ParentId;
                    if (crm.Safra__c == '20/21'){
                        crm.BR_Soma_de_Sem_Comercializada__c = ventasBRMXIntactaStock.get(cuenta);
                        crm.DSoma_de_Sem_Comercializada__c = ventasDSEMIntactaStock.get(cuenta);
                        crm.SSemComer_Safra_actual__c = ventasTotalesStock.get(cuenta);
                        crm.BR_SemComer_Safra_actual__c = ventasTotalesBRMXStock.get(cuenta);
                        crm.NG_Soma_de_Sem_Comercializada__c = ventasNEOGIntactaStock.get(cuenta);
                        Double porcVari = 0;
                        if (ventasXVariCuentaBRMXStock.get(cuenta) != null && crm.BR_SemComer_Safra_actual__c != null && crm.BR_SemComer_Safra_actual__c != 0){
                            porcVari = ventasXVariCuentaBRMXStock.get(cuenta) * 100 / crm.BR_SemComer_Safra_actual__c;
                        }
                        crm.BR_Mix_de_Produto__c = porcVari;
                        if (accIdsAnexo.contains(cuenta + 'DSEM')){
                            crm.DSoma_de_Sem_Comercializada__c = ventasDSEMIntacta.get(cuenta);
                        }    
                        if (accIdsAnexo.contains(cuenta + 'NEOG')){
                            crm.NG_Soma_de_Sem_Comercializada__c = ventasNEOGIntacta.get(cuenta);
                        }
                        if (accIdsAnexo.contains(cuenta + 'BRMX')){
                            crm.BR_Soma_de_Sem_Comercializada__c = ventasBRMXIntacta.get(cuenta);                            
                            crm.SSemComer_Safra_actual__c = ventasTotales.get(cuenta);
                            crm.BR_SemComer_Safra_actual__c = ventasTotalesBRMX.get(cuenta);                            
                            porcVari = 0;
                            if (ventasXVariCuentaBRMX.get(cuenta) != null && crm.BR_SemComer_Safra_actual__c != null && crm.BR_SemComer_Safra_actual__c != 0){
                                porcVari = ventasXVariCuentaBRMX.get(cuenta) * 100 / crm.BR_SemComer_Safra_actual__c;
                            }
                            crm.BR_Mix_de_Produto__c = porcVari;
                        }
                    }
                    if (crm.Safra__c == '21/22'){
                        crm.SSemComer_safra_ant__c = ventasTotalesStock.get(cuenta);
                        if (accIdsAnexo.contains(cuenta))
                            crm.SSemComer_safra_ant__c = ventasTotales.get(cuenta);
                    }
                }

                update crm_mult;

            }

        }
    }

    public static void actualizarVentasPerfilCuenta(Opportunity[] oppsNew, Opportunity[] oppsOld){

        Id rt_obj = null;
        Id rt_aIII = null;
        Id rt_aIV = null;

        /*
         for(RecordType reTy : [Select Id, Name From RecordType Where sObjectType = 'Opportunity']){
         if(reTy.Name == 'Objetivo Contrato Royalties') rt_obj = reTy.Id;
         if(reTy.Name == 'Anexo III') rt_aIII = reTy.Id;
         if(reTy.Name == 'Anexo IV') rt_aIV = reTy.Id;
         }
         */
        rt_obj = '012330000009mqZ';
        rt_aIII = '01240000000M7y6';
        rt_aIV = '01240000000M7y8';

        Set<Id> accIds = New Set<Id>();
        Set<String> accParentIds = New Set<String>();
        accParentIds.add('111111111111111'); //Para cuando consulto que los parentid esten en esta coleccion por lo menos que tenga algo. Si es nulo me va a traer cuentas que no me interesan.

        Map<String, Double> metaBRMX = New Map<String, Double>();
        Map<String, Double> metaDSEM = New Map<String, Double>();
        Map<String, Double> ventasBRMXIntacta = New Map<String, Double>();
        Map<String, Double> ventasDSEMIntacta = New Map<String, Double>();
        Map<String, Double> ventasXVariedadBRMX = New Map<String, Double>();
        Map<String, Double> ventasXVariCuentaBRMX = New Map<String, Double>();
        Map<String, Double> ventasTotales = New Map<String, Double>();
        Map<String, Double> ventasTotalesBRMX = New Map<String, Double>();

        if (oppsNew != null)
            for (Opportunity o : oppsNew)
                if (o.RecordTypeId == rt_obj || o.RecordTypeId == rt_aIII || o.RecordTypeId == rt_aIV)
                    accIds.add(o.AccountId);
                if (oppsOld != null)
                    for (Opportunity o : oppsOld)
                        if (o.RecordTypeId == rt_obj || o.RecordTypeId == rt_aIII || o.RecordTypeId == rt_aIV)
                            accIds.add(o.AccountId);
                        if (accIds.size() > 0){
                            for (Account a : [Select Id, ParentId
                                              From Account
                                              Where Id In :accIds])
                                if (a.ParentId != null)
                                    accParentIds.add(a.ParentId);
                                //for (AggregateResult ar : [Select Sum(Meta__c) meta, Sum(Semente_comercializada__c) semC, Sum(Semente_uso_propio__c) semUP, Opportunity.RecordType.Name tipoReg, Opportunity.AccountId cuenta, Opportunity.Marca__c marca, Variedad__c variedad, Variedad__r.Tecnologia__c tecno From OpportunityLineItem Where Opportunity.AccountId In : accIds And Opportunity.Safra__c = '15/16' And (Opportunity.RecordType.Name = 'Objetivo Contrato Royalties' Or ((Opportunity.RecordType.Name = 'Anexo III' Or Opportunity.RecordType.Name = 'Anexo IV') And Opportunity.StageName = 'Aprobada')) Group By Opportunity.RecordType.Name, Opportunity.AccountId, Opportunity.Marca__c, Variedad__c, Variedad__r.Tecnologia__c]){
                                for (AggregateResult ar : [Select Sum(Meta__c) meta, Sum(Semente_comercializada__c) semC, Sum(Semente_uso_propio__c) semUP, Opportunity.RecordType.Name tipoReg, Opportunity.AccountId cuenta, Opportunity.Account.ParentId principal, Opportunity.Marca__c marca, PricebookEntry.Product2.Variedade__c variedad, PricebookEntry.Product2.Variedade__r.Tecnologia__c tecno
                                                           From OpportunityLineItem
                                                           Where (Opportunity.AccountId In :accIds Or Opportunity.Account.ParentId In :accParentIds) And Opportunity.Safra__c = '17/18' And (Opportunity.RecordType.Name = 'Objetivo Contrato Royalties' Or ((Opportunity.RecordType.Name = 'Anexo III' Or Opportunity.RecordType.Name = 'Anexo IV') And Opportunity.StageName = 'Aprobada'))
                                                           Group By Opportunity.RecordType.Name, Opportunity.Account.ParentId, Opportunity.AccountId, Opportunity.Marca__c, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Tecnologia__c]){
                                    String cuenta = String.valueOf(ar.get('cuenta'));
                                if (ar.get('principal') != null)
                                    cuenta = String.valueOf(ar.get('principal'));
                                if (String.valueOf(ar.get('tipoReg')) == 'Objetivo Contrato Royalties' && String.valueOf(ar.get('tecno')) == 'IPRO' && Double.valueOf(ar.get('meta')) != 0){
                                    if (String.valueOf(ar.get('marca')) == 'BRMX'){
                                        if (!metaBRMX.containsKey(cuenta)){
                                            metaBRMX.put(cuenta, Double.valueOf(ar.get('meta')));
                        } else{
                            Double metaB = metaBRMX.get(cuenta);
                            metaB += Double.valueOf(ar.get('meta'));
                            metaBRMX.remove(cuenta);
                            metaBRMX.put(cuenta, metaB);
                        }
                    }
                    if (String.valueOf(ar.get('marca')) == 'DSEM'){
                        if (!metaDSEM.containsKey(cuenta)){
                            metaDSEM.put(cuenta, Double.valueOf(ar.get('meta')));
                        } else{
                            Double metaD = metaDSEM.get(cuenta);
                            metaD += Double.valueOf(ar.get('meta'));
                            metaDSEM.remove(cuenta);
                            metaDSEM.put(cuenta, metaD);
                        }
                    }
                }

                if ((String.valueOf(ar.get('tipoReg')) == 'Anexo III' || String.valueOf(ar.get('tipoReg')) == 'Anexo IV') && ((Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'))) != 0)){
                    if (!ventasTotales.containsKey(cuenta)){
                        ventasTotales.put(cuenta, Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                    } else{
                        Double ventasT = ventasTotales.get(cuenta);
                        ventasT += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                        ventasTotales.remove(cuenta);
                        ventasTotales.put(cuenta, ventasT);
                    }
                    if (String.valueOf(ar.get('marca')) == 'BRMX'){
                        if (!ventasTotalesBRMX.containsKey(cuenta)){
                            ventasTotalesBRMX.put(cuenta, Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                        } else{
                            Double ventasTB = ventasTotalesBRMX.get(cuenta);
                            ventasTB += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                            ventasTotalesBRMX.remove(cuenta);
                            ventasTotalesBRMX.put(cuenta, ventasTB);
                        }
                        if (!ventasXVariedadBRMX.containsKey(cuenta + String.valueOf(ar.get('variedad')))){
                            ventasXVariedadBRMX.put(cuenta + String.valueOf(ar.get('variedad')), Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                        } else{
                            Double ventasXVar = ventasXVariedadBRMX.get(cuenta + String.valueOf(ar.get('variedad')));
                            ventasXVar += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                            ventasXVariedadBRMX.remove(cuenta + String.valueOf(ar.get('variedad')));
                            ventasXVariedadBRMX.put(cuenta + String.valueOf(ar.get('variedad')), ventasXVar);
                        }
                        if (String.valueOf(ar.get('tecno')) == 'IPRO'){
                            if (!ventasBRMXIntacta.containsKey(cuenta)){
                                ventasBRMXIntacta.put(cuenta, Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                            } else{
                                Double ventasB = ventasBRMXIntacta.get(cuenta);
                                ventasB += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                                ventasBRMXIntacta.remove(cuenta);
                                ventasBRMXIntacta.put(cuenta, ventasB);
                            }
                        }
                    }
                    if (String.valueOf(ar.get('marca')) == 'DSEM' && String.valueOf(ar.get('tecno')) == 'IPRO'){
                        if (!ventasDSEMIntacta.containsKey(cuenta)){
                            ventasDSEMIntacta.put(cuenta, Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP')));
                        } else{
                            Double ventasD = ventasDSEMIntacta.get(cuenta);
                            ventasD += Double.valueOf(ar.get('semC'))+Double.valueOf(ar.get('semUP'));
                            ventasDSEMIntacta.remove(cuenta);
                            ventasDSEMIntacta.put(cuenta, ventasD);
                        }
                    }
                }

            }

            for (String key : ventasXVariedadBRMX.keySet()){
                if (!ventasXVariCuentaBRMX.containsKey(key.substring(0, 18))){
                    ventasXVariCuentaBRMX.put(key.substring(0, 18), Double.valueOf(ventasXVariedadBRMX.get(key)));
                } else{
                    Double ventasXVarC = ventasXVariCuentaBRMX.get(key.substring(0, 18));
                    if (Double.valueOf(ventasXVariedadBRMX.get(key)) > ventasXVarC){
                        ventasXVarC = Double.valueOf(ventasXVariedadBRMX.get(key));
                        ventasXVariCuentaBRMX.remove(key.substring(0, 18));
                        ventasXVariCuentaBRMX.put(key.substring(0, 18), ventasXVarC);
                    }
                }
            }

            /*
             List<CRM_Detalhe_de_Perfil_da_Conta__c> perfiles = New List<CRM_Detalhe_de_Perfil_da_Conta__c>();
             perfiles = [Select Id, CRM_Multiplicador__r.Cuenta__c, BR_Soma_de_Meta__c, DS_Soma_de_Meta__c, BR_Soma_de_Sem_Comercializada__c, DSoma_de_Sem_Comercializada__c, SSemComer_Safra_actual__c From CRM_Detalhe_de_Perfil_da_Conta__c Where CRM_Multiplicador__r.Cuenta__c In : accIds And CRM_Multiplicador__r.Safra__c = '14/15'];
             if(perfiles.size() > 0){
             for(CRM_Detalhe_de_Perfil_da_Conta__c p : perfiles){
             p.BR_Soma_de_Meta__c = metaBRMX.get(p.CRM_Multiplicador__r.Cuenta__c);
             p.DS_Soma_de_Meta__c = metaDSEM.get(p.CRM_Multiplicador__r.Cuenta__c);
             p.BR_Soma_de_Sem_Comercializada__c = ventasBRMXIntacta.get(p.CRM_Multiplicador__r.Cuenta__c);
             p.DSoma_de_Sem_Comercializada__c = ventasDSEMIntacta.get(p.CRM_Multiplicador__r.Cuenta__c);
             p.SSemComer_Safra_actual__c = ventasTotales.get(p.CRM_Multiplicador__r.Cuenta__c);
             p.BR_SemComer_Safra_actual__c = ventasTotalesBRMX.get(p.CRM_Multiplicador__r.Cuenta__c);
             Double porcVari = 0;
             if (ventasXVariCuentaBRMX.get(p.CRM_Multiplicador__r.Cuenta__c) != null && p.BR_SemComer_Safra_actual__c != null && p.BR_SemComer_Safra_actual__c != 0){
             porcVari = ventasXVariCuentaBRMX.get(p.CRM_Multiplicador__r.Cuenta__c) * 100 / p.BR_SemComer_Safra_actual__c;
             }
             p.BR_Mix_de_Produto__c = porcVari;
             }
             update perfiles;
             }
             */

            List<CRM_Multiplicador__c> crm_mult = New List<CRM_Multiplicador__c>();
            crm_mult = [Select Id, Cuenta__c, Cuenta__r.ParentId, Safra__c, BR_Soma_de_Meta__c, DS_Soma_de_Meta__c, BR_Soma_de_Sem_Comercializada__c, DSoma_de_Sem_Comercializada__c, SSemComer_Safra_actual__c
                        From CRM_Multiplicador__c
                        Where (Cuenta__c In :accIds Or Cuenta__r.ParentId In :accParentIds) And Safra__c In ('17/18', '18/19')];
            if (crm_mult.size() > 0){
                for (CRM_Multiplicador__c crm : crm_mult){
                    String cuenta = crm.Cuenta__c;
                    if (crm.Cuenta__r.ParentId != null)
                        cuenta = crm.Cuenta__r.ParentId;
                    if (crm.Safra__c == '17/18'){
                        crm.BR_Soma_de_Meta__c = metaBRMX.get(cuenta);
                        crm.DS_Soma_de_Meta__c = metaDSEM.get(cuenta);
                        crm.BR_Soma_de_Sem_Comercializada__c = ventasBRMXIntacta.get(cuenta);
                        crm.DSoma_de_Sem_Comercializada__c = ventasDSEMIntacta.get(cuenta);
                        crm.SSemComer_Safra_actual__c = ventasTotales.get(cuenta);
                        crm.BR_SemComer_Safra_actual__c = ventasTotalesBRMX.get(cuenta);
                        Double porcVari = 0;
                        if (ventasXVariCuentaBRMX.get(cuenta) != null && crm.BR_SemComer_Safra_actual__c != null && crm.BR_SemComer_Safra_actual__c != 0){
                            porcVari = ventasXVariCuentaBRMX.get(cuenta) * 100 / crm.BR_SemComer_Safra_actual__c;
                        }
                        crm.BR_Mix_de_Produto__c = porcVari;
                    }
                    if (crm.Safra__c == '18/19'){
                        crm.SSemComer_safra_ant__c = ventasTotales.get(cuenta);
                    }
                }
                update crm_mult;
            }

        }
    }

    public static void eliminarBonificaciones(Set<String> cuentas, String marca){

        Set<String> cuentasConAnexos = New Set<String>();
        for (Opportunity o : [Select Id, AccountId
                              From Opportunity
                              Where RecordType.Name = 'Anexo III' And Safra__c = '20/21' And StageName = 'Aprobada' And Marca__c = :marca And AccountId In :cuentas])
            cuentasConAnexos.add(o.AccountId);
        List<CRM_Bonificacion__c> eliminarBonif = New List<CRM_Bonificacion__c>();
        eliminarBonif = [Select Id
                         From CRM_Bonificacion__c
                         Where Safra__c = '20/21' And RecordType.Name = :marca And CRM_Multiplicador__r.Cuenta__c In :cuentas And CRM_Multiplicador__r.Cuenta__c Not In :cuentasConAnexos];

        if (eliminarBonif.size() > 0)
            delete eliminarBonif;
    }

    public static void crearBonificaciones(Set<String> cuentas, String marca){

        RecordType rt = [Select Id
                         From RecordType
                         Where SObjectType = 'CRM_Bonificacion__c' And Name = :marca
                         limit 1];

        Set<String> cuentasConBonif = New Set<String>();
        for (CRM_Bonificacion__c c : [Select Id, CRM_Multiplicador__r.Cuenta__c
                                      From CRM_Bonificacion__c
                                      Where Safra__c = '20/21' And RecordType.Name = :marca And CRM_Multiplicador__r.Cuenta__c In :cuentas])
            cuentasConBonif.add(c.CRM_Multiplicador__r.Cuenta__c);
        //////
        Set<String> cuentasConCuentaPrincipal = New Set<String>();
        for (Account a : [Select Id, ParentId
                          From Account
                          Where Id In :cuentas And Id Not In :cuentasConBonif And ParentId != null])
            cuentasConCuentaPrincipal.add(a.ParentId);
        if (cuentasConCuentaPrincipal.size() > 0){
            List<CRM_Bonificacion__c> bonifDelGrupo = New List<CRM_Bonificacion__c>();
            bonifDelGrupo = [Select Id, CRM_Multiplicador__r.Cuenta__c
                             From CRM_Bonificacion__c
                             Where CRM_Multiplicador__r.Cuenta__r.ParentId In :cuentasConCuentaPrincipal And Safra__c = '20/21' And RecordType.Name = :marca];
            for (CRM_Bonificacion__c b : bonifDelGrupo)
                cuentas.add(b.CRM_Multiplicador__r.Cuenta__c);
            delete bonifDelGrupo;
        }
        //////

        Map<String, CRM_Multiplicador__c> mapPerfiles = New Map<String, CRM_Multiplicador__c>();
        for (CRM_Multiplicador__c crm : [Select Id, BR_Mix_de_Produto__c, DS_Aumento_nas_Vendas__c, BR_Catergoria_BRXM__c, BR_Desconto_Exclusividade__c, BR_Pontos_palestras__c, BR_Resultado_Vendas__c, BR_Venda_de_Intacta__c, BR_Categoria_resultante__c, DS_Categoria_resultante__c, DS_Areas_para_ensaios__c, Cuenta__c, DS_Categoria__c, DS_Participaca_dias_de_campo__c, BR_Exclusividade_GDM__c, DS_Manual_da_marca__c, BR_Meta_BRMX_porc__c, Meta_DSEM_porc__c, BR_Soma_de_Meta__c, BR_Participacao_dia_de_campo_meta__c, DS_Soma_de_Meta__c, BR_LXL_Meta__c, BR_Palestras_Meta__c, BR_Treinamentos_Meta__c, DS_Reclam_de_prec__c, BR_Penetra_o_INTACTA__c, BR_Pontos_dias_de_campo__c, BR_Pontos_LxL__c, BR_Pontos_mix__c, BR_Resultado_Palestra_e_Treinamentos__c, BR_Pontos_penetra_o__c, BR_Pontos_volume__c, BR_Pontos_volume_2__c, DS_Identifica_o_de_beiras_de_rodovia__c, BR_Participacao_dia_campo_realizado__c, BR_LXL_Realizado__c, BR_Palestras_Realizado__c, BR_Treinamentos_Realizado__c, Safra__c, BR_Superou_Meta__c, DS_Superou_Meta__c, BR_Total_de_pontos__c, BR_SemComer_Safra_actual__c, BR_Soma_de_Sem_Comercializada__c, DSoma_de_Sem_Comercializada__c, SSemComer_safra_ant__c, SSemComer_Safra_actual__c, BRMX_Descuento__c, BRMX_Desconto_Classe_1__c, BRMX_Desconto_Classe_2__c, BRMX_Desconto_Classe_3__c, BR_Desconto_CRM__c, BRMX_Desconto_Obj_Rel_Gen_Dem__c, DS_Participacao_dia_de_campo_meta__c, BR_Emplacamentos_Meta__c, DS_Emplacamentos_Meta__c, DS_LXL_Meta__c, DS_Palestras_Meta__c, Pontos_Porc_Vendas__c, BR_Pontos_Emplacamentos__c, BR_Identifica_o_de_beiras_de_rodovia__c, DS_Participacao_dia_campo_realizado__c, DS_LXL_Realizado__c, DS_Palestras_Realizado__c, BR_Stock_Mult_Realizado__c, CRM_BRMX__c, BR_Pontos_Stock_Mult__c, BRMX_Desconto_Obj_Gen_Dem__c, NG_Categoria_resultante__c, CRM_NEOG__c, NG_Soma_de_Meta__c, NEOG_Desconto_Obj_Gen_Dem__c, NEOG_Descuento__c, NEOG_Pontos_Obj_Gen_Dem__c, Pontos_CRM_y_Stock_Mult_NEOG__c, NG_Pontos_volume__c, NG_Pontos_volume_superior__c, NG_Identifica_o_de_beiras_de_rodovia__c, NG_LXL_Realizado_Colhido__c, NG_LXL_Realizado_Plantado__c, NG_Outdoor_Realizado__c, NG_Palestras_Realizado__c, NG_Stock_Mult_Realizado__c, NG_Soma_de_Sem_Comercializada__c, DS_porc_Meta_a_Alcanzar__c, BRMX_Desconto_Classe_2_MKT__c, BRMX_Desconto_Classe_3_MKT__c, BRMX_Desconto_Obj_Rel_Gen_Dem_MKT__c, DS_Categoria_MKT__c, NEOG_Descuento_MKT__c, NG_Pontos_volume_superior_MKT__c, NG_Treinamentos_Realizado__c, NG_Participacao_dia_campo_realizado__c
                                         From CRM_Multiplicador__c
                                         Where Safra__c = '20/21' And Cuenta__c In :cuentas])
            if (!mapPerfiles.containsKey(crm.Cuenta__c))
                mapPerfiles.put(crm.Cuenta__c, crm);
            Set<String> idCuentasCrearBonif = New Set<String>();
        List<CRM_Bonificacion__c> newBonificaciones = New List<CRM_Bonificacion__c>();
        for (String s : cuentas){
            if (!cuentasConBonif.contains(s)){
                if (mapPerfiles.get(s) != null){
                    CRM_Bonificacion__c newBonif = New CRM_Bonificacion__c();
                    CRM_Multiplicador__c crm = mapPerfiles.get(s);
                    newBonif.CRM_Multiplicador__c = crm.Id;
                    newBonif.BR_Mix_de_Produto__c = crm.BR_Mix_de_Produto__c;
                    newBonif.DS_Aumento_nas_Vendas__c = crm.DS_Aumento_nas_Vendas__c;
                    newBonif.BR_Catergoria_BRXM__c = crm.BR_Catergoria_BRXM__c;
                    newBonif.BRMX_Descuento__c = crm.BRMX_Descuento__c;
                    newBonif.BR_Desconto_Exclusividade__c = crm.BR_Desconto_Exclusividade__c;
                    newBonif.BR_Pontos_palestras__c = crm.BR_Pontos_palestras__c;
                    newBonif.BR_Resultado_Vendas__c = crm.BR_Resultado_Vendas__c;
                    newBonif.BR_Venda_de_Intacta__c = crm.BR_Venda_de_Intacta__c;
                    newBonif.BR_Categoria_resultante__c = crm.BR_Categoria_resultante__c;
                    newBonif.DS_Categoria_resultante__c = crm.DS_Categoria_resultante__c;
                    newBonif.DS_Areas_para_ensaios__c = crm.DS_Areas_para_ensaios__c;
                    newBonif.DS_Categoria__c = crm.DS_Categoria__c;
                    newBonif.DS_Participaca_dias_de_campo__c = crm.DS_Participaca_dias_de_campo__c;
                    newBonif.BR_Exclusividade_GDM__c = crm.BR_Exclusividade_GDM__c;
                    newBonif.DS_Manual_da_marca__c = crm.DS_Manual_da_marca__c;
                    newBonif.BR_Meta_BRMX_porc__c = crm.BR_Meta_BRMX_porc__c;
                    newBonif.Meta_DSEM_porc__c = crm.Meta_DSEM_porc__c;
                    newBonif.BR_Soma_de_Meta__c = crm.BR_Soma_de_Meta__c;
                    newBonif.BR_Participacao_dia_de_campo_meta__c = crm.BR_Participacao_dia_de_campo_meta__c;
                    newBonif.DS_Soma_de_Meta__c = crm.DS_Soma_de_Meta__c;
                    newBonif.BR_LXL_Meta__c = crm.BR_LXL_Meta__c;
                    newBonif.BR_Palestras_Meta__c = crm.BR_Palestras_Meta__c;
                    newBonif.BR_Treinamentos_Meta__c = crm.BR_Treinamentos_Meta__c;
                    newBonif.DS_Reclam_de_prec__c = crm.DS_Reclam_de_prec__c;
                    newBonif.BR_Penetra_o_INTACTA__c = crm.BR_Penetra_o_INTACTA__c;
                    newBonif.BR_Pontos_dias_de_campo__c = crm.BR_Pontos_dias_de_campo__c;
                    newBonif.BR_Pontos_LxL__c = crm.BR_Pontos_LxL__c;
                    newBonif.BR_Pontos_mix__c = crm.BR_Pontos_mix__c;
                    newBonif.BR_Resultado_Palestra_e_Treinamentos__c = crm.BR_Resultado_Palestra_e_Treinamentos__c;
                    newBonif.BR_Pontos_penetra_o__c = crm.BR_Pontos_penetra_o__c;
                    //newBonif.BR_Pontos_volume__c = crm.BR_Pontos_volume__c;
                    newBonif.BR_Pontos_volume__c = crm.BR_Pontos_volume_2__c;
                    newBonif.DS_Identifica_o_de_beiras_de_rodovia__c = crm.DS_Identifica_o_de_beiras_de_rodovia__c;
                    newBonif.BR_Participacao_dia_campo_realizado__c = crm.BR_Participacao_dia_campo_realizado__c;
                    newBonif.BR_LXL_Realizado__c = crm.BR_LXL_Realizado__c;
                    newBonif.BR_Palestras_Realizado__c = crm.BR_Palestras_Realizado__c;
                    newBonif.BR_Treinamentos_Realizado__c = crm.BR_Treinamentos_Realizado__c;
                    newBonif.BR_Superou_Meta__c = crm.BR_Superou_Meta__c;
                    newBonif.DS_Superou_Meta__c = crm.DS_Superou_Meta__c;
                    newBonif.BR_Total_de_pontos__c = crm.BR_Total_de_pontos__c;
                    newBonif.BR_SemComer_Safra_actual__c = crm.BR_SemComer_Safra_actual__c;
                    newBonif.BR_Soma_de_Sem_Comercializada__c = crm.BR_Soma_de_Sem_Comercializada__c;
                    newBonif.DSoma_de_Sem_Comercializada__c = crm.DSoma_de_Sem_Comercializada__c;
                    newBonif.SSemComer_safra_ant__c = crm.SSemComer_safra_ant__c;
                    newBonif.SSemComer_Safra_actual__c = crm.SSemComer_Safra_actual__c;
                    //newBonif.Marca__c = marca;
                    newBonif.BRMX_Desconto_Classe_1__c = crm.BRMX_Desconto_Classe_1__c;
                    newBonif.BRMX_Desconto_Classe_2__c = crm.BRMX_Desconto_Classe_2__c;
                    newBonif.BRMX_Desconto_Classe_3__c = crm.BRMX_Desconto_Classe_3__c;
                    newBonif.BR_Desconto_CRM__c = crm.BR_Desconto_CRM__c;
                    newBonif.BRMX_Desconto_Obj_Rel_Gen_Dem__c = crm.BRMX_Desconto_Obj_Rel_Gen_Dem__c;
                    newBonif.DS_Participacao_dia_de_campo_meta__c = crm.DS_Participacao_dia_de_campo_meta__c;
                    newBonif.BR_Emplacamentos_Meta__c = crm.BR_Emplacamentos_Meta__c;
                    newBonif.DS_Emplacamentos_Meta__c = crm.DS_Emplacamentos_Meta__c;
                    newBonif.DS_LXL_Meta__c = crm.DS_LXL_Meta__c;
                    newBonif.DS_Palestras_Meta__c = crm.DS_Palestras_Meta__c;
                    newBonif.Pontos_Porc_Vendas__c = crm.Pontos_Porc_Vendas__c;
                    newBonif.BR_Pontos_Emplacamentos__c = crm.BR_Pontos_Emplacamentos__c;
                    newBonif.BR_Identifica_o_de_beiras_de_rodovia__c = crm.BR_Identifica_o_de_beiras_de_rodovia__c;
                    newBonif.DS_Participacao_dia_campo_realizado__c = crm.DS_Participacao_dia_campo_realizado__c;
                    newBonif.DS_LXL_Realizado__c = crm.DS_LXL_Realizado__c;
                    newBonif.DS_Palestras_Realizado__c = crm.DS_Palestras_Realizado__c;
                    newBonif.BR_Stock_Mult_Realizado__c = crm.BR_Stock_Mult_Realizado__c;
                    newBonif.BR_Pontos_Stock_Mult__c = crm.BR_Pontos_Stock_Mult__c;
                    newBonif.CRM_BRMX__c = crm.CRM_BRMX__c;
                    newBonif.BRMX_Desconto_Obj_Gen_Dem__c = crm.BRMX_Desconto_Obj_Gen_Dem__c;
                    newBonif.NG_Categoria_resultante__c = crm.NG_Categoria_resultante__c;
                    newBonif.CRM_NEOG__c = crm.CRM_NEOG__c;
                    newBonif.NG_Soma_de_Meta__c = crm.NG_Soma_de_Meta__c;
                    newBonif.NEOG_Desconto_Obj_Gen_Dem__c = crm.NEOG_Desconto_Obj_Gen_Dem__c;
                    newBonif.NEOG_Descuento__c = crm.NEOG_Descuento__c;
                    newBonif.NEOG_Pontos_Obj_Gen_Dem__c = crm.NEOG_Pontos_Obj_Gen_Dem__c;
                    newBonif.Pontos_CRM_y_Stock_Mult_NEOG__c = crm.Pontos_CRM_y_Stock_Mult_NEOG__c;
                    newBonif.NG_Pontos_volume__c = crm.NG_Pontos_volume__c;
                    newBonif.NG_Pontos_volume_superior__c = crm.NG_Pontos_volume_superior__c;
                    newBonif.NG_Identifica_o_de_beiras_de_rodovia__c = crm.NG_Identifica_o_de_beiras_de_rodovia__c;
                    newBonif.NG_LXL_Realizado_Colhido__c = crm.NG_LXL_Realizado_Colhido__c;
                    newBonif.NG_LXL_Realizado_Plantado__c = crm.NG_LXL_Realizado_Plantado__c;
                    newBonif.NG_Outdoor_Realizado__c = crm.NG_Outdoor_Realizado__c;
                    newBonif.NG_Palestras_Realizado__c = crm.NG_Palestras_Realizado__c;
                    newBonif.NG_Stock_Mult_Realizado__c = crm.NG_Stock_Mult_Realizado__c;
                    newBonif.NG_Soma_de_Sem_Comercializada__c = crm.NG_Soma_de_Sem_Comercializada__c;
                    newBonif.DS_porc_Meta_a_Alcanzar__c = crm.DS_porc_Meta_a_Alcanzar__c;
            newBonif.BRMX_Desconto_Classe_2_MKT__c = crm.BRMX_Desconto_Classe_2_MKT__c;
                    newBonif.BRMX_Desconto_Classe_3_MKT__c = crm.BRMX_Desconto_Classe_3_MKT__c;
                    newBonif.BRMX_Desconto_Obj_Rel_Gen_Dem_MKT__c = crm.BRMX_Desconto_Obj_Rel_Gen_Dem_MKT__c;
                    newBonif.DS_Categoria_MKT__c = crm.DS_Categoria_MKT__c;
                    newBonif.NEOG_Descuento_MKT__c = crm.NEOG_Descuento_MKT__c;
                    newBonif.NG_Pontos_volume_superior_MKT__c = crm.NG_Pontos_volume_superior_MKT__c;
                    newBonif.NG_Treinamentos_Realizado__c = crm.NG_Treinamentos_Realizado__c;
                    newBonif.NG_Participacao_dia_campo_realizado__c = crm.NG_Participacao_dia_campo_realizado__c;
                    
                    newBonif.RecordTypeId = rt.Id;
                    newBonificaciones.add(newBonif);
                    idCuentasCrearBonif.add(crm.Cuenta__c);
                }
            }
        }

        if (newBonificaciones.size() > 0){
            insert newBonificaciones;
            if (marca == 'BRMX'){
                List<CRM_Bonificacion__c> bonifDSEM = New List<CRM_Bonificacion__c>();
                Set<String> idCuentasCrearBonifDSEM = New Set<String>();
                bonifDSEM = [Select Id, CRM_Multiplicador__r.Cuenta__c
                             From CRM_Bonificacion__c
                             Where CRM_Multiplicador__r.Cuenta__c In :idCuentasCrearBonif And Safra__c = '20/21' And RecordType.Name = 'DSEM'];
                for (CRM_Bonificacion__c b : bonifDSEM)
                    idCuentasCrearBonifDSEM.add(b.CRM_Multiplicador__r.Cuenta__c);
                delete bonifDSEM;
                crearBonificaciones(idCuentasCrearBonifDSEM, 'DSEM');
            }
        }
    }

    public static void crearBonificacionesAIV(Set<String> cuentas, String marca){

        Set<String> cuentasConCuentaPrincipal = New Set<String>();
        for (Account a : [Select Id, ParentId
                          From Account
                          Where Id In :cuentas And ParentId != null])
            cuentasConCuentaPrincipal.add(a.ParentId);
        if (cuentasConCuentaPrincipal.size() > 0){
            List<CRM_Bonificacion__c> bonifDelGrupo = New List<CRM_Bonificacion__c>();
            bonifDelGrupo = [Select Id, CRM_Multiplicador__r.Cuenta__c
                             From CRM_Bonificacion__c
                             Where CRM_Multiplicador__r.Cuenta__r.ParentId In :cuentasConCuentaPrincipal And Safra__c = '20/21' And RecordType.Name = :marca];
            for (CRM_Bonificacion__c b : bonifDelGrupo)
                cuentas.add(b.CRM_Multiplicador__r.Cuenta__c);
        }

        Map<String, CRM_Multiplicador__c> mapPerfiles = New Map<String, CRM_Multiplicador__c>();
        for (CRM_Multiplicador__c crm : [Select Id, Cuenta__c, BRMX_Desconto_Classe_1__c, BRMX_Desconto_Classe_2__c, BRMX_Desconto_Classe_3__c, NEOG_Descuento__c, NG_Pontos_volume_superior__c
                                         From CRM_Multiplicador__c
                                         Where Safra__c = '20/21' And Cuenta__c In :cuentas])
            if (!mapPerfiles.containsKey(crm.Cuenta__c))
                mapPerfiles.put(crm.Cuenta__c, crm);
            Map<String, CRM_Bonificacion__c> mapBonif = New Map<String, CRM_Bonificacion__c>();
        for (CRM_Bonificacion__c crm : [Select Id, CRM_Multiplicador__r.Cuenta__c, BRMX_Desconto_Classe_1_AIV__c, BRMX_Desconto_Classe_2_AIV__c, BRMX_Desconto_Classe_3_AIV__c, NEOG_Descuento__c, NG_Pontos_volume_superior__c
                                        From CRM_Bonificacion__c
                                        Where Safra__c = '20/21' And CRM_Multiplicador__r.Cuenta__c In :cuentas And RecordType.Name = :marca])
            if (!mapBonif.containsKey(crm.CRM_Multiplicador__r.Cuenta__c))
                mapBonif.put(crm.CRM_Multiplicador__r.Cuenta__c, crm);
            if (mapPerfiles.size() > 0){
                List<CRM_Bonificacion__c> updBonificaciones = New List<CRM_Bonificacion__c>();
            for (String s : mapPerfiles.keySet()){
                if (mapBonif.get(s) != null){
                    CRM_Multiplicador__c crm = mapPerfiles.get(s);
                    CRM_Bonificacion__c bonif = mapBonif.get(s);
                    if (marca == 'BRMX'){
                        bonif.BRMX_Desconto_Classe_1_AIV__c = crm.BRMX_Desconto_Classe_1__c;
                        bonif.BRMX_Desconto_Classe_2_AIV__c = crm.BRMX_Desconto_Classe_2__c;
                        bonif.BRMX_Desconto_Classe_3_AIV__c = crm.BRMX_Desconto_Classe_3__c;
                    }
                    if (marca == 'NEOG'){
                        bonif.NEOG_Descuento_AIV__c = crm.NEOG_Descuento__c;
                        bonif.NG_Pontos_volume_superior_AIV__c = crm.NG_Pontos_volume_superior__c;
                    }
                    updBonificaciones.add(bonif);
                }
            }
            if (updBonificaciones.size() > 0)
                update updBonificaciones;
        }
    }

    public static void eliminarBonificacionesAIV(Set<String> cuentas, String marca){

        List<CRM_Bonificacion__c> eliminarBonif = New List<CRM_Bonificacion__c>();
        eliminarBonif = [Select Id
                         From CRM_Bonificacion__c
                         Where Safra__c = '20/21' And RecordType.Name = :marca And CRM_Multiplicador__r.Cuenta__c In :cuentas];

        if (eliminarBonif.size() > 0){
            for (CRM_Bonificacion__c bonif : eliminarBonif){
                if (marca == 'BRMX'){
                    bonif.BRMX_Desconto_Classe_1_AIV__c = null;
                    bonif.BRMX_Desconto_Classe_2_AIV__c = null;
                    bonif.BRMX_Desconto_Classe_3_AIV__c = null;
                }
                if (marca == 'NEOG'){
                    bonif.NEOG_Descuento_AIV__c = null;
                    bonif.NG_Pontos_volume_superior_AIV__c = null;
                }
            }
            update eliminarBonif;
        }
    }

    /*
     public static void actualizarCampoActiva(Opportunity[] opps){

     Set<String> cuentasStockM = New Set<String>();
     Set<String> safrasStockM = New Set<String>();
     Set<String> marcasStockM = New Set<String>();
     Set<String> oppsStockM = New Set<String>();
     Set<String> combinacionStockM = New Set<String>();

     for (Opportunity o : opps){
     if (o.RecordTypeId == '01240000000M9lt' && o.Activa__c){
     cuentasStockM.add(o.AccountId);
     safrasStockM.add(o.Safra__c);
     marcasStockM.add(o.Marca__c);
     combinacionStockM.add(o.AccountId + o.Safra__c + o.Marca__c);
     oppsStockM.add(o.Id);
     }
     }

     if (oppsStockM.size() > 0){
     List<Opportunity> ops = New List<Opportunity>();
     ops = [Select Id, Activa__c, AccountId, Safra__c, Marca__c From Opportunity Where RecordTypeId = '01240000000M9lt' And AccountId In : cuentasStockM And Safra__c In : safrasStockM And Marca__c In : marcasStockM];
     for (Opportunity o : ops)
     if (!oppsStockM.contains(o.Id) && combinacionStockM.contains(o.AccountId + o.Safra__c + o.Marca__c))
     o.Activa__c = false;

     update ops;

     }

     }
     */

    public static void cargarEpocaPlantioAnexo2(List<Opportunity> anexos2){
        List<String> safras = new List<String>();
        List<String> marcas = new List<String>();
        List<Id> accountIds = new List<Id>();
        Map<String, Map<String,List<Opportunity>>> result = new Map<String, Map<String, List<Opportunity>>>();
        for(Opportunity opp : anexos2){
            if(result.get(opp.AccountId) == null) result.put(opp.AccountId, new Map<String,List<Opportunity>>());
            safras.add(opp.Safra__c);
            marcas.add(opp.Marca__c);
            accountIds.add(opp.AccountId);
        }
        List<Opportunity> approvedSafra = DAOOpportunity.getInstance(DTOUtils.SharingMode.Without).getApprovedByAccountAndBySafra(accountIds,safras,marcas); 
        for(Opportunity opp : approvedSafra){
            if(result.get(opp.AccountId).get(opp.RecordType.DeveloperName.replace('_','')) == null) result.get(opp.AccountId).put(opp.RecordType.DeveloperName.replace('_',''), new List<Opportunity>());
            result.get(opp.AccountId).get(opp.RecordType.DeveloperName.replace('_','')).add(opp);
        }
        for(Opportunity opp : anexos2){
            if(result.get(opp.AccountId).get('AnexoI') != null && result.get(opp.AccountId).get('AnexoI').size() > 0){
                for(Opportunity opa : result.get(opp.AccountId).get('AnexoI')){
                    if(opa.Marca__c == opp.Marca__c){
                        opp.Epoca_de_PLantio__c = opa.Epoca_de_PLantio__c;
                    }
                }
            }
        }
    }
}
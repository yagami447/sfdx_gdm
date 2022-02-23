global class BATCH_Evento_Actualizar_Responsable  implements Database.Batchable<sObject>,  Database.Stateful {
    private String query; 
    private Integer limite;
    private Set<Id> cuentasIds;
    private String textoMail;
        
    global BATCH_Evento_Actualizar_Responsable(Set<Id> idsCuentas){
        this.limite = 1000;
        this.cuentasIds = new Set<Id>();
        this.cuentasIds.addAll(idsCuentas);
        String filtroIdCuentas = this.getIdsStringFiltro(idsCuentas);
        this.query = 'SELECT Id, Cuenta__c,Cuenta__r.Name, Marca__c, OwnerId FROM CRM_Calendario_de_Eventos__c WHERE OwnerId != \'00540000001TUHM\' AND Cuenta__c IN ' + filtroIdCuentas + ' LIMIT ' + String.valueOf(this.limite);
    }
    
     global Database.QueryLocator start(Database.BatchableContext context) { 
         return  Database.getQueryLocator(this.query);
     }
    global void execute(Database.BatchableContext context, List<CRM_Calendario_de_Eventos__c> eventos) {
         try{
               Map<Integer, Id> usuarios = new Map<Integer, Id>();
        	Map<Id, User> usName = new Map<Id, User>([SELECT Id, Codigo_SAP__c, Name, UserRole.Name FROM User WHERE isActive = true]);
            for (User user : usName.values()) {
                if (String.isNotEmpty(user.Codigo_SAP__c)) {
                    usuarios.put(Integer.valueOf(user.Codigo_SAP__c), user.Id);
                }
            }
            List<Map<Id, String>> responsables = BRAXUtils.getResponsablesPorMarca(usuarios, this.cuentasIds);
            Map<Id, String> propBRMX = responsables[0];
            Map<Id, String> propDSEM = responsables[1];
            Map<Id, String> propNEOG = responsables[2]; 
            Map<Id, String> propDAGMA = responsables[3];
        	Map<Id, String> propLICENCAS = responsables[4];
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
             Database.update(eventosToUpdate, false);
             this.loadDatosResumen(eventosToUpdate);
         }catch(Exception e){
             this.textoMail = 'O processo de atualização responsável de eventos falhou.\n Error: ' + e.getMessage() + ', línea : ' + e.getLineNumber();
         }        
    }
    
    global void finish(Database.BatchableContext context) {
        if(!Test.isRunningTest() && !this.runningInASandbox()) { 
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] toAddresses = new List<String>();
            for(User u : [
                SELECT Email 
                FROM User 
                WHERE Profile.Name IN ('System Administrator', 'Administrador del Sistema')
            ]) {
                toAddresses.add(u.Email);
            }
            String subject ='Batch Atualizar Responsável CRM Eventos: ' + System.now();
            email.setSubject(subject);
            email.setToAddresses(toAddresses);
             email.setPlainTextBody('O processo de atualização responsável para os CRM Eventos terminou.');         
            if(this.textoMail != null && this.textoMail != ''){
                 email.setPlainTextBody(this.textoMail);
            }              
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    
      private void loadDatosResumen(List<CRM_Calendario_de_Eventos__c> eventos){
        Map<String,Integer> mapCuenta = new Map<String,Integer>();
        Map<String,List<CRM_Calendario_de_Eventos__c>> mapCuentaEventos = new Map<String,List<CRM_Calendario_de_Eventos__c>>();
        for(CRM_Calendario_de_Eventos__c evento : eventos){
            if(!mapCuentaEventos.containsKey(evento.Cuenta__r.Name)){
                mapCuentaEventos.put(evento.Cuenta__r.Name,new List<CRM_Calendario_de_Eventos__c>());
            }
            mapCuentaEventos.get(evento.Cuenta__r.Name).add(evento);
        }
        for(String cuenta : mapCuentaEventos.keySet()){
            mapCuenta.put(cuenta,mapCuentaEventos.get(cuenta).size());
        }
        this.textoMail = 'O processo de atualização do responsável pelo objeto CRM_Calendario_de_Evento__c foi concluído com sucesso.. Abaixo está um breve resumo da tarefa: \n ';        
        for(String nombreCuenta : mapCuenta.keySet()){
             this.textoMail += nombreCuenta + ' : ' + mapCuenta.get(nombreCuenta) + ' eventos atualizados. \n';
        }
    }
    
     private String getIdsStringFiltro(Set<Id> idsCuentas){
        String resultado = '';
          if(idsCuentas != null && idsCuentas.size() > 0){
               resultado = '(';
               Integer cant = 1;
                for(Id idCuenta : idsCuentas){   
                    if(cant > 1)
                    resultado += ','; 
                    resultado += '\'' + (String)idCuenta + '\'';             
                    cant ++;
                }
                resultado += ')';
        	}
        return resultado;
    }
    
    private Boolean runningInASandbox() {
		return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
}
global class BATCH_Opp_Actualizar_Responsable implements Database.Batchable<sObject>,  Database.Stateful{   
    private String query; 
    private Integer limite;
    private Set<Id> cuentasIds;
    private String textoMail;
    global BATCH_Opp_Actualizar_Responsable(Set<Id> idsCuentas){
        this.limite = 1000;
        this.cuentasIds = new Set<Id>();
        this.cuentasIds.addAll(idsCuentas);
        String filtroIdCuentas = this.getIdsStringFiltro(idsCuentas);
        this.query = 'SELECT Id, AccountId,Account.Name, RecordTypeId, Marca__c, OwnerId FROM Opportunity WHERE OwnerId != \'00540000001TUHM\' AND AccountId IN ' + filtroIdCuentas + ' LIMIT ' + String.valueOf(this.limite);
    }
    
  
     global Database.QueryLocator start(Database.BatchableContext context) { 
         return  Database.getQueryLocator(this.query);
     }
    
     global void execute(Database.BatchableContext context, List<Opportunity> opps) {
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
          	List<Opportunity> oppsToUpdate = BRAXUtils.actualizarPropietariosOpp(opps, usuarios, this.cuentasIds, propBRMX, propDSEM, propNEOG, propDAGMA, propLICENCAS, responsables[5], getOpportunityRtNames(), usName);
            Database.update(oppsToUpdate, false);
             this.loadDatosResumen(oppsToUpdate);             
         }catch(Exception e){
             this.textoMail = 'O processo de atualização responsável de oportunidades falhou.\n Error: ' + e.getMessage() + ', línea : ' + e.getLineNumber();
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
            String subject ='Batch Atualizar Responsável Oportunidades: ' + System.now();
            email.setSubject(subject);
            email.setToAddresses(toAddresses);
             email.setPlainTextBody('O processo de atualização responsável terminou.');         
            if(this.textoMail != null && this.textoMail != ''){
                 email.setPlainTextBody(this.textoMail);
            }              
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    
    private void loadDatosResumen(List<Opportunity> opps){
        Map<String,Integer> mapCuenta = new Map<String,Integer>();
        Map<String,List<Opportunity>> mapCuentaOpps = new Map<String,List<Opportunity>>();
        for(Opportunity opp : opps){
            if(!mapCuentaOpps.containsKey(opp.Account.Name)){
                mapCuentaOpps.put(opp.Account.Name,new List<Opportunity>());
            }
            mapCuentaOpps.get(opp.Account.Name).add(opp);
        }
        for(String cuenta : mapCuentaOpps.keySet()){
            mapCuenta.put(cuenta,mapCuentaOpps.get(cuenta).size());
        }
        this.textoMail = 'O processo de atualização responsável foi concluído com sucesso. Abaixo está um breve resumo da tarefa: \n ';
        
        for(String nombreCuenta : mapCuenta.keySet()){
             this.textoMail += nombreCuenta + ' : ' + mapCuenta.get(nombreCuenta) + ' oportunidades atualizadas. \n';
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
    
     public static Map<Id, String> getOpportunityRtNames() {
        Map<Id, String> rtNames = new Map<Id, String>();
        
        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        
        for (String rt : rtMapByName.keySet()) {
            rtNames.put(rtMapByName.get(rt).getRecordTypeId(), rtMapByName.get(rt).getName());
        }

        return rtNames;
    }    
  
      private Boolean runningInASandbox() {
		return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
}
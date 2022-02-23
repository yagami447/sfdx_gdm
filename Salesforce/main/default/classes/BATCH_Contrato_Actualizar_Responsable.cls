global class BATCH_Contrato_Actualizar_Responsable implements Database.Batchable<sObject>,  Database.Stateful {
    private String query; 
    private Integer limite;
    private Set<Id> cuentasIds;
    private String textoMail;
    
    global BATCH_Contrato_Actualizar_Responsable(Set<Id> idsCuentas){
        this.limite = 1000;
        this.cuentasIds = new Set<Id>();
        this.cuentasIds.addAll(idsCuentas);
        String filtroIdCuentas = this.getIdsStringFiltro(idsCuentas);
        this.query = 'SELECT Id, Multiplicador__c,Multiplicador__r.Name, Sociedad__c, OwnerId FROM Contrato__c WHERE OwnerId != \'00540000001TUHM\' AND Multiplicador__c IN ' + filtroIdCuentas + ' LIMIT ' + String.valueOf(this.limite);
    }
    global Database.QueryLocator start(Database.BatchableContext context) { 
         return  Database.getQueryLocator(this.query);
     }
    
    global void execute(Database.BatchableContext context, List<Contrato__c> contratos) {
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
             	List<Contrato__c> aditivosToUpdate = new List<Contrato__c>();        
                for (Contrato__c aditivo : contratos) {
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
              Database.update(aditivosToUpdate, false);
             this.loadDatosResumen(aditivosToUpdate);
         }catch(Exception e){
             this.textoMail = 'O processo de atualização responsável de Contratos falhou.\n Error: ' + e.getMessage() + ', línea : ' + e.getLineNumber();
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
            String subject ='Batch Atualizar Responsável Contratos: ' + System.now();
            email.setSubject(subject);
            email.setToAddresses(toAddresses);
             email.setPlainTextBody('O processo de atualização responsável para os Contratos terminou.');         
            if(this.textoMail != null && this.textoMail != ''){
                 email.setPlainTextBody(this.textoMail);
            }              
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    
    private void loadDatosResumen(List<Contrato__c> contratos){
        Map<String,Integer> mapCuenta = new Map<String,Integer>();
        Map<String,List<Contrato__c>> mapCuentaContratos = new Map<String,List<Contrato__c>>();
        for(Contrato__c contrato : contratos){
            if(!mapCuentaContratos.containsKey(contrato.Multiplicador__r.Name)){
                mapCuentaContratos.put(contrato.Multiplicador__r.Name,new List<Contrato__c>());
            }
            mapCuentaContratos.get(contrato.Multiplicador__r.Name).add(contrato);
        }
        for(String cuenta : mapCuentaContratos.keySet()){
            mapCuenta.put(cuenta,mapCuentaContratos.get(cuenta).size());
        }
        this.textoMail = 'O processo de atualização do responsável pelo objeto Contrato__c foi concluído com sucesso.. Abaixo está um breve resumo da tarefa: \n ';        
        for(String nombreCuenta : mapCuenta.keySet()){
             this.textoMail += nombreCuenta + ' : ' + mapCuenta.get(nombreCuenta) + ' contratos atualizados. \n';
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
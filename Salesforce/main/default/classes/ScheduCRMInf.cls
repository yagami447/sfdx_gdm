global class ScheduCRMInf implements Schedulable{

    // Global execute, este método es ejecutado en la fecha y horario configurado para tal trabajo
    global void execute(SchedulableContext ctx){
        Set<Id> listaInf = New Set<Id>();
        List<CRM_Infraestructura__c> schedListInf = new List<CRM_Infraestructura__c>();
        List<CRM_Multiplicador__c> listaMult = new List<CRM_Multiplicador__c>();
        map<Id, Id> multCuenta = New map<Id, Id>();
        Integer limite;
        //Actualizando Opportunidades historicas CAMPAÑA 08/09
        
        //if(!Test.isRunningTest())
          //  limite = 5000;
            
        //else
          //  limite = 1;
            
        
        schedListInf = [SELECT Id, Cuenta__c, CRM_Multiplicador__r.Id FROM CRM_Infraestructura__c WHERE Cuenta__c = ''];
        for(CRM_Infraestructura__c c: schedListInf)
            listaInf.Add(c.CRM_Multiplicador__r.Id);
            
        //listaMult = ;
        for(CRM_Multiplicador__c m: [SELECT Id, Cuenta__r.Id FROM CRM_Multiplicador__c WHERE Id in: listaInf])
            if(!multCuenta.ContainsKey(m.Id))
                multCuenta.put(m.Id, m.Cuenta__r.Id);
                
        for(CRM_Infraestructura__c c: schedListInf)
            c.Cuenta__c = multCuenta.get(c.CRM_Multiplicador__r.Id);
        update schedListInf;
            
        
        
        
        schedListInf.Clear();
        
        
        //Actualizando Opportunidades historicas CAMPAÑA 09/10
       
    }
    
    // Este método se encarga de realizar los test de la clase
    static testMethod void test() {
        Test.startTest();
            ScheduCRMInf sCRM = new ScheduCRMInf();
            String sche = '0 0 23 * * ?';
            System.schedule('Update', sche, sCRM);
        Test.stopTest();
    }
}
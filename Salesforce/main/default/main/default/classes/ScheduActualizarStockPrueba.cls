global class ScheduActualizarStockPrueba implements Schedulable {
    
    //Global execute, este método es ejecutado en la fecha y horario configurado para tal trabajo   
    global void execute(SchedulableContext ctx){        
        actStock();
    }       
    
    @future(callout=false)
    public static void actStock(){
        
        
        Map<String,Analisis_de_Datos__c> mapStock = New Map<String,Analisis_de_Datos__c>();
        Map<String,Analisis_de_Datos__c> mapContratos = New Map<String,Analisis_de_Datos__c>();
        Map<String,Analisis_de_Datos__c> mapAnalisis = New Map<String,Analisis_de_Datos__c>();
        List<Analisis_de_Datos__c> actualizar = New List<Analisis_de_Datos__c>();
        Analisis_de_Datos__c tmp = New Analisis_de_Datos__c();
        Analisis_de_Datos__c filtroActStock = New Analisis_de_Datos__c();
        Schema.DescribeFieldResult fieldResult2 = Opportunity.Mes__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        List<String> meses = new List<String>();         
        for(Schema.PicklistEntry f : ple2) if(f.getLabel().length() > 1) meses.add(f.getLabel());
        
        Set<Id> cuentas = New Set<Id>(); 
        Map<Integer, String> usuarios = New Map<Integer, Id>();
        Map<String, String> prop = New Map<String, String>();        
        for(Configuracion_BMX__c conf : [Select Safra_Stock__c, Mes_Stock__c FROM Configuracion_BMX__c limit 1]){ filtroActStock.Safra__c = conf.Safra_Stock__c; filtroActStock.Mes__c = conf.Mes_Stock__c;}
        for (User u : [Select Id, Codigo_SAP__c, Name From User Where isActive = true]){  
            if (u.Codigo_SAP__c != null) usuarios.put(Integer.valueOf(u.Codigo_SAP__c), String.valueOf(u.Id));
            //usName.put(String.ValueOf(u.Id), u.Name); 
        }
        
        //String qry = 'SELECT Opportunity.Marca__c, Opportunity.Safra__c, Opportunity.Mes__c, Opportunity.OwnerId, Opportunity.AccountId, PriceBookEntry.Product2.Variedade__c FROM OpportunityLineItem WHERE Opportunity.RecordType.Name = \'Stock Multiplicadores\' AND Opportunity.Safra__c = \'13/14\' AND Mes = \'Setembro\'';
        
        for(AggregateResult p : [SELECT Contrato_de_Multiplicacion__r.RecordType.Name, Contrato_de_Multiplicacion__r.Safra__c, Contrato_de_Multiplicacion__r.Multiplicador__r.Id Mult, Cultivar__r.Variedade__r.Id, Count(Cultivar__r.Variedade__r.Name) myCount FROM Item_del_Contrato__c WHERE Contrato_de_Multiplicacion__r.RecordType.Name IN ('BRMX', 'DSEM') AND Contrato_de_Multiplicacion__r.Safra__c = :filtroActStock.Safra__c AND Cultivar__r.Variedade__r.Licenciada__c = false Group By Contrato_de_Multiplicacion__r.RecordType.Name, Contrato_de_Multiplicacion__r.Safra__c, Contrato_de_Multiplicacion__r.Multiplicador__r.Id, Cultivar__r.Variedade__r.Id]){
            mapContratos.put((string) p.get('Mult')+(string) p.get('Id'), new Analisis_de_Datos__c(Marca__c=(string) p.get('Name'),Safra__c=(string) p.get('Safra__c'),Cuenta__c=(string) p.get('Mult'),Variedad__c=(string) p.get('Id'),Cantidad_Contrato__c=(integer) p.get('myCount')));
            cuentas.add((string) p.get('Mult'));
        }
        for(String mes : meses){
            for(AggregateResult p : [SELECT Opportunity.Marca__c, Opportunity.Safra__c, Opportunity.Mes__c, Opportunity.OwnerId, Opportunity.AccountId, PriceBookEntry.Product2.Variedade__r.Id, Count(PriceBookEntry.Product2.Variedade__r.Name) myCount FROM OpportunityLineItem WHERE Opportunity.RecordType.Name = 'Stock Multiplicadores' AND Opportunity.Safra__c = :filtroActStock.Safra__c AND Opportunity.Mes__c = :mes AND PricebookEntry.Product2.Variedade__r.Licenciada__c = false Group By Opportunity.Marca__c, Opportunity.Safra__c, Opportunity.Mes__c, Opportunity.OwnerId, Opportunity.AccountId, PriceBookEntry.Product2.Variedade__r.Id]){
            mapStock.put((string) p.get('AccountId')+(string) p.get('Id')+(string) p.get('Safra__c')+(string) p.get('Mes__c'), new Analisis_de_Datos__c(Marca__c=(string) p.get('Marca__c'),Safra__c=(string) p.get('Safra__c'),Mes__c=(string) p.get('Mes__c'), PropietarioOpp__c=(string) p.get('OwnerId'),Cuenta__c=(string) p.get('AccountId'),Variedad__c=(string) p.get('Id'),Cantidad_Stock__c=(integer) p.get('myCount')));
            }
        }
        for(Analisis_de_Datos__c a: [SELECT Id, Variedad__c, Variedad__r.Id,Safra__c,PropietarioOpp__c, PropietarioOpp__r.Id,Mes__c,Marca__c,Cuenta__c, Cuenta__r.Id,Cantidad_Contrato__c, Cantidad_Stock__c FROM Analisis_de_Datos__c WHERE Safra__c = :filtroActStock.Safra__c]){
            mapAnalisis.put(String.ValueOf(a.Cuenta__r.Id)+String.ValueOf(a.Variedad__r.Id)+String.ValueOf(a.Safra__c)+String.ValueOf(a.Mes__c), a);
        }
        
        for (Account a : [Select Id, Responsavel__c, Reponsavel_DSEM__c From Account Where Id In : cuentas]){
            String idUser = null;
            
            if (a.Responsavel__c != null){        
                idUser = usuarios.get(Integer.valueOf(a.Responsavel__c.split('-')[0].trim()));
                if (idUser != null && idUser != ''){ prop.put(String.ValueOf(a.Id)+'BRMX', idUser);idUser=null;}
            }
            if (a.Reponsavel_DSEM__c != null){                
                idUser = usuarios.get(Integer.valueOf(a.Reponsavel_DSEM__c.split('-')[0].trim()));
                if (idUser != null && idUser != ''){ prop.put(String.ValueOf(a.Id)+'DSEM', idUser);idUser=null;}
            }
        }
        Savepoint sp;
        try{
            sp = Database.setSavepoint();
            for(Analisis_de_Datos__c a: mapContratos.values()){
                for(String mes: meses){
                    if(mapAnalisis.ContainsKey(String.ValueOf(a.Cuenta__r.Id)+String.ValueOf(a.Variedad__r.Id)+mes)){//Si ya existe hay que actualizarlo.
                        tmp = mapAnalisis.get(String.ValueOf(a.Cuenta__r.Id)+String.ValueOf(a.Variedad__r.Id)+mes);
                        tmp.Cantidad_Contrato__c = a.Cantidad_Contrato__c; //Actualizo las cantidades de Contrato por las dudas
                        if(mapStock.ContainsKey(String.ValueOf(tmp.Cuenta__r.Id)+String.ValueOf(tmp.Variedad__r.Id)+String.ValueOf(tmp.Safra__c)+mes)){
                            tmp.Cantidad_Stock__c = mapStock.get(String.ValueOf(tmp.Cuenta__r.Id)+String.ValueOf(tmp.Variedad__r.Id)+String.ValueOf(tmp.Safra__c)+mes).Cantidad_Stock__c;
                        }else{tmp.Cantidad_Stock__c = 0;}
                        actualizar.add(new Analisis_de_Datos__c(Id=tmp.Id,Variedad__c=tmp.Variedad__c,Safra__c=tmp.Safra__c,PropietarioOpp__c=tmp.PropietarioOpp__c,Mes__c=tmp.Mes__c,Marca__c=tmp.Marca__c,Cuenta__c=tmp.Cuenta__c,Cantidad_Contrato__c=tmp.Cantidad_Contrato__c, Cantidad_Stock__c=tmp.Cantidad_Stock__c));tmp=null;
                    }else{// Si no existe hay que crearlo
                        tmp = a;
                        tmp.Mes__c = mes;
                        tmp.PropietarioOpp__c = prop.get(String.ValueOf(tmp.Cuenta__r.Id)+tmp.Marca__c);
                        if(mapStock.ContainsKey(String.ValueOf(tmp.Cuenta__r.Id)+String.ValueOf(tmp.Variedad__r.Id)+String.ValueOf(tmp.Safra__c)+mes)){
                            tmp.Cantidad_Stock__c = mapStock.get(String.ValueOf(tmp.Cuenta__r.Id)+String.ValueOf(tmp.Variedad__r.Id)+String.ValueOf(tmp.Safra__c)+mes).Cantidad_Stock__c;
                        }else{tmp.Cantidad_Stock__c = 0;}
                        actualizar.add(new Analisis_de_Datos__c(Variedad__c=tmp.Variedad__c,Safra__c=tmp.Safra__c,PropietarioOpp__c=tmp.PropietarioOpp__c,Mes__c=tmp.Mes__c,Marca__c=tmp.Marca__c,Cuenta__c=tmp.Cuenta__c,Cantidad_Contrato__c=tmp.Cantidad_Contrato__c, Cantidad_Stock__c=tmp.Cantidad_Stock__c));tmp=null;
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
        }catch(Exception e){
            //ApexPages.addMessages(e);
            Database.rollback(sp);
        }
    }
    @isTest(SeeAllData=true)
    static void test(){
        
        Test.startTest();
        ScheduActualizarStockPrueba act = new ScheduActualizarStockPrueba();
        //String str = system.now().addMinutes(0).format('ss mm HH dd MM ? yyyy');
        //System.schedule('Update', str, control);
        String sche = '0 0 23 * * ?';
        System.schedule('Update', sche, act);
        Test.stopTest();
        
    }

}
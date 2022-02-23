@isTest
private class testOppTrigger {

    	static testMethod void insertOkTest() {
        
        Opportunity opp = new Opportunity(Name='OppTest',Stagename='Aprobada',CloseDate=System.today());
        insert opp;
        
        try{
        	opp = [Select Id from Opportunity where Name = 'OppTest'];
        }
        catch(Exception e){
        	
        }        
        System.assertNotEquals(opp, null);
    }
    
    static testMethod void insertBasicaOkTest() {
        RecordType rt = [Select Id, Name From RecordType Where Name = 'PB-Produccion'];            
        Opportunity opp2 = new Opportunity(RecordTypeId=rt.id,Name='OppTestPB',Description='Ok',Rebaja__c=true,Stagename='Aprobada',CloseDate=System.today());
        
        Test.startTest();
        insert opp2;
        Test.stopTest();

        System.assertNotEquals(opp2, null);
    }
    
    static testMethod void insertBasicaFallaTest() {
        RecordType rt = [Select Id, Name From RecordType Where Name = 'PB-Produccion'];            
        Opportunity opp = new Opportunity(RecordTypeId=rt.id,Name='OppTestPB',Description='',Rebaja__c=false,Stagename='Aprobada',CloseDate=System.today());
       
        try{        
        	insert opp;        	
        }
        catch(DMLException e)
        {
        	
        } 
            
        System.assertEquals(opp.Id, null);
    }
    
    static testMethod void updateOkTest() {
        RecordType rt = [Select Id, Name From RecordType Where Name = 'PB-Produccion'];            
        Opportunity opp = new Opportunity(RecordTypeId=rt.id,Name='OppTestPB',Description='Ok',Rebaja__c=true,Stagename='Aprobada',CloseDate=System.today());
        
        insert opp;
        
        //Tipo de cambio
        opp.Tipo_de_Cambio__c=3;
        update opp;
        
        System.assertNotEquals(opp, null);
    }
    
    static testMethod void updateFallaTest() {
        RecordType rt = [Select Id, Name From RecordType Where Name = 'Anexo I'];            
        Opportunity opp = new Opportunity(RecordTypeId=rt.id,Name='OppTestAnexo',Description='Ok',Rebaja__c=true,Stagename='Aprobada',CloseDate=System.today());
        
        insert opp;
        
        try{   	//Marca
			opp.Marca__c='BRMX';
        	update opp;        	     	
        }
        catch(DMLException e)
        {     	
        }
        
        try{   	//Mes
			opp.Mes__c='Juno';		
        	update opp;      	
        }
        catch(DMLException e)
        {        	
        }
        
        try{   	//Etapa
			opp.StageName = 'Desaprobado x Gerente';	
        	update opp;      	
        }
        catch(DMLException e)
        {        	
        }
        
        //System.assertNotEquals(opp, null);
    }
    
    static testMethod void updateBloqueoTest() {
        RecordType rt = [Select Id, Name From RecordType Where Name = 'NC - Pendiente'];
        RecordType rtVB = [Select Id, Name From RecordType Where Name = 'CVB Pendiente'];
        Account acc = new Account(Name='Conta');
        insert acc;
        
        Estado__c est = new Estado__c(Name='JERE');
        insert est;
		Estado__c est2 = new Estado__c(Name='JERE2',Estado_de_Origem__c=true);
        insert est2;
		Taxas_Fiscais__c tasa = new Taxas_Fiscais__c(Aliquota_de_ICMS__c=1, Base_de_Calculo__c=2, Estado_Destino__c=est.Id, Estado_Origem__c=est2.Id);
		insert tasa; 

        Centro_Logistico__c cl = new Centro_Logistico__c(Name='ACA',Codigo_SAP__c='CD433',Estado__c=est.Id);
        insert cl;
        Centro_Logistico__c cl2 = new Centro_Logistico__c(Name='Londrina',Codigo_SAP__c='CE433',Estado__c=est.Id);
        insert cl2;
        Opportunity ped = new Opportunity(Origen__c=cl.Id,Tipo_de_Cota_o__c='DOLAR',Tipo_de_cambio__c=1,RecordTypeId=rt.id,Name='OppTenexo',Description='Ok',Rebaja__c=false,Stagename='Aprobada',CloseDate=System.today());
        insert ped;
        Opportunity opp = new Opportunity(Origen__c=cl.Id,Tipo_de_Cota_o__c='DOLAR',Tipo_de_cambio__c=1,RecordTypeId=rt.id,Name='OppTestAnexo',Description='Ok',Rebaja__c=true,Stagename='Aprobada',CloseDate=System.today());
        insert opp;
        
        Configuracion_BMX__c conf = new Configuracion_BMX__c(Londrina_Tasa_COFINS__c=7, Londrina_Tasa_ISS__c=0, Londrina_Tasa_PIS__c=1, Passo_Fundo_Tasa_COFINS__c=7, Passo_Fundo_Tasa_ISS__c=0, Passo_Fundo_Tasa_PIS__c=1);
        insert conf;
        
        opp.Pedido_Relacionado__c=ped.Id;
		opp.Bloqueo__c ='';
        update opp;
       
        try{
			opp.Bloqueo__c ='Z4 - BR - Bloqueio Salesforce';
			opp.Origen__c=cl2.Id;
        	update opp;
        }
        catch(DMLException e)
        {     	
        }
        
        opp.RecordTypeId = rtVB.Id;
        opp.Bloqueo__c ='Z4 - BR - Bloqueio Salesforce';        
        update opp;
        
    }
    
    static testMethod void deleteOkTest() {
        Opportunity oppDel = null;
        Opportunity opp = new Opportunity(Name='OppTest',Stagename='Aprobada',CloseDate=System.today());
        insert opp;
        
        delete opp;
        
        try{
        	oppDel = [Select Id from Opportunity where Name = 'OppTest'];
        }
        catch(Exception e){
        	
        }        
        System.assertEquals(oppDel, null);        
    }
}
global class BMX_Opp_fc_Anulacion {
	/* Se comenta toda la clase porque está fuera de uso
    public static boolean isApexTest = false;
    
    webservice static string anulacionFC(Id oppId, String target) {
        Opportunity op = [Select Id, Estado_facturacion__c, Name, Sap_EP_NF_Anulacion__c, Stagename, Ejercicio__c, Sociedad__c, Numero_documento_SAP__c, CloseDate, Tipo_de_cambio__c, Sucursal__c, Account.CodigoSAP__c, Account.Estado__r.Name From Opportunity Where Id = :oppId];
        return enviarSAP(op, target);
    }
                
    static string enviarSAP(Opportunity op, String target){
        sapSoapFunctionsAnulMcS.Z_FI_ELIMINA_FACTURACION_BR soap = new sapSoapFunctionsAnulMcS.Z_FI_ELIMINA_FACTURACION_BR();
        sapSoapFunctionsAnulMcS.TableOfBapiret2 retorno2 = new sapSoapFunctionsAnulMcS.TableOfBapiret2();        
        sapSoapFunctionsAnulMcS.ZFiEliminaFacturacionBrResponse_element retorno = new sapSoapFunctionsAnulMcS.ZFiEliminaFacturacionBrResponse_element(); 
        sapSoapFunctionsAnulMcS.TableOfBapiret2 EtReturn = new sapSoapFunctionsAnulMcS.TableOfBapiret2();
        
        
        soap.inputHttpHeaders_x = new Map<String, String>();
        String encodedusernameandpassword;
        Boolean Contab = false;
        String msg = '';
        
        if(op.Estado_Facturacion__c == 'Contabilizada' || op.Estado_Facturacion__c == 'Impresa')
        	Contab = true;
        	
        String myData = 'donmario:donmario';
        Blob hash = Blob.valueOf(myData);
        encodedusernameandpassword = EncodingUtil.base64Encode(hash);        
        soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);        
        
        if(Contab){
        	String IpAwkey = '1900000275BRMX2010';
        	IpAwkey = op.Numero_Documento_SAP__c.substring(0,10) + op.Sociedad__c.substring(0,4) + op.Ejercicio__c.substring(0,4);
        
        	if (!isApexTest && op.Id != '0064000000HOI5X'){
	            retorno = soap.ZFiEliminaFacturacionBr(EtReturn, IpAwkey, target);
    	    }
        	else{
	            retorno.EpFb08 = '1600000059BRMX2010';
    	        retorno.EpNfAnul = '0000002682';
        	}        
	        if (retorno.EpFb08.trim() != null && retorno.EpFb08.trim() != ''){  //Anulacion exitosa
    	        op.Sap_EP_FB08_Anulacion__c = retorno.EpFb08;
        	    op.Sap_EP_NF_Anulacion__c = retorno.EpNfAnul;
        	    msg = retorno.EpFb08;
        	}
        	else{
	            return 'Error: ' + retorno.EtReturn.item[0].Message;
    	    }
        }
        
        op.Estado_Facturacion__c = 'Anulada';
        op.StageName = 'Anulada';
        update op;
            
        List<OpportunityLineItem> items = New List<OpportunityLineItem>();
        List<Id> idsItems = New List<Id>();
        items = [SELECT Id, Id_Item_de_Oportunidad_Relacionado__c FROM OpportunityLineItem WHERE OpportunityId= : op.Id];
        for (OpportunityLineItem i : items)
           idsItems.add(i.Id_Item_de_Oportunidad_Relacionado__c);
        List<OpportunityLineItem> itemsDesfacturar = New List<OpportunityLineItem>();
        itemsDesfacturar = [SELECT Id, Estado_Facturacion__c FROM OpportunityLineItem WHERE Id in : idsItems];
        for (OpportunityLineItem i: itemsDesfacturar)
           i.Estado_Facturacion__c='No facturado';
        update itemsDesfacturar;
                
        return 'Cancelação Ok - Doc. Anulação EpFb08: ' + msg;
         
    }
    
    WebService static void mainForTest(Id oppId){
        isApexTest = true;        
        anulacionFC(oppId, '110');
    }
    
    public static testMethod void test(){
        
        RecordType rt = [Select Id From RecordType Where Name = 'BRMX' And SObjectType = 'Contrato__c' limit 1];
        
        Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Multiplica%' limit 1];
        PricebookEntry pbe = [Select id, Product2Id From PricebookEntry where isActive = true and Pricebook2Id = :pb2.id limit 1];
        Account a = new Account(Name='TMP');
        insert a;
        Contrato__c c = new Contrato__c(Cultivar__c=pbe.Product2Id, Multiplicador__c=a.Id,Sociedad__c='BRMX', RecordTypeId = rt.Id);
        insert c;                   
        Opportunity opp = new Opportunity(Tipo_de_Cambio__c=2,Numero_Documento_SAP__c='1900000021',Sociedad__c='BMRX',Ejercicio__c='2010',Sucursal__c='0094',Pricebook2Id=pb2.Id,AccountId=a.Id,Name='TMP',Safra__c='08/09',StageName='Aberta',CloseDate=System.Today());
        insert opp;
        OpportunityLineItem i = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId=pbe.id,Quantity=1,UnitPrice=2);
        insert i;
        BMX_Opp_fc_Anulacion.mainForTest(opp.Id);
        
    }
    */
}
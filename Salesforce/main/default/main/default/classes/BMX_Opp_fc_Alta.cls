global class BMX_Opp_fc_Alta {

    public static boolean isApexTest = false;
    //@future (callout=true)

    webservice static void altaFC(Id oppId, String target) {
        Opportunity op = [Select Id, Name, Numero_legal__c, Stagename, CloseDate, Tipo_de_cambio__c, Sucursal__c, Account.CodigoSAP__c, Account.Responsavel__c, Account.Estado__r.Name From Opportunity Where Id = :oppId];         
        enviarSAP(op, target);
    }
                
    static void enviarSAP(Opportunity op, String target){
    
    String linea = '12';
    try {
     
        sapSoapFunctionsMcS.Z_FI_CREA_FACTURACION_BR soap = new sapSoapFunctionsMcS.Z_FI_CREA_FACTURACION_BR();
        sapSoapFunctionsMcS.ZFiCreaFacturacionBrResponse_element retorno = new sapSoapFunctionsMcS.ZFiCreaFacturacionBrResponse_element();
        sapSoapFunctionsMcS.TableOfBapiret2 EtReturn = new sapSoapFunctionsMcS.TableOfBapiret2();

        sapSoapFunctionsMcS.ZfiesJ1b1nHead IHeader = new sapSoapFunctionsMcS.ZfiesJ1b1nHead();
        IHeader.Bukrs = 'BRMX'; //Sociedad
        IHeader.Brnch = op.Sucursal__c.substring(0,4); //Sucursal
        IHeader.Parid = op.Account.CodigoSAP__c; //cod sap cuenta '6000000002'; 
        IHeader.Nfnum = String.ValueOf(op.Numero_Legal__c); //'58'; //nro fact contador

        IHeader.Docdat = String.valueOf(op.CloseDate).substring(0,10); //closedate
        IHeader.Pstdat = String.valueOf(system.today()).substring(0,10); //fecha actual '2010-10-01'; //

        sapSoapFunctionsMcS.ZfittJ1b1n ItPos = new sapSoapFunctionsMcS.ZfittJ1b1n();        
        sapSoapFunctionsMcS.ZfiesJ1b1n[] ItPoss = new  List<sapSoapFunctionsMcS.ZfiesJ1b1n>();
                
        String Suc = '';
        if (op.Sucursal__c.substring(0,4) == '0094')
           Suc='RS';           
        if (op.Sucursal__c.substring(0,4) == '0095')
           Suc='PR';
        
        List<OpportunityLineItem> items =[SELECT Id, Quantity, PriceBookEntry.Product2.Name, UnitPrice FROM OpportunityLineItem WHERE OpportunityId= : op.Id];        
        if (items != null){
           for (OpportunityLineItem i:items){
              sapSoapFunctionsMcS.ZfiesJ1b1n ItPos1 = new sapSoapFunctionsMcS.ZfiesJ1b1n();
              
              Decimal ZPRN = 0.0; Decimal ZINI = 0.0; Decimal ZPRC = 0.0;
              Double unitp=i.UnitPrice;
              Double tipoc=op.Tipo_de_cambio__c;
              ZPRN = Decimal.valueOf(unitp * tipoc);
              ZPRN = ZPRN.divide(1, 4, System.RoundingMode.UP);
                
              ItPos1.Maktx = i.PriceBookEntry.Product2.Name.substring(0,10); //name del producto
              ItPos1.Menge = String.valueof(i.Quantity);
              ItPos1.Netpr = String.valueof(ZPRN);
              ItPos1.Zuonr = op.Account.Responsavel__c;

              if (Suc == op.Account.Estado__r.Name){ //estado cuenta contra estado sucursal
                 ItPos1.Cfop10 = '5933AA';
              }
              else{
                    ItPos1.Cfop10 = '6933AA';
              } 
              ItPoss.add(ItPos1);
           }
        }
        
        ItPos.Item = ItPoss; 
                
        soap.inputHttpHeaders_x = new Map<String, String>();
        String encodedusernameandpassword;
        
        String myData = 'donmario:donmario';
        Blob hash = Blob.valueOf(myData);
        encodedusernameandpassword = EncodingUtil.base64Encode(hash);        
        soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);

        String retornando = '';                
        sapSoapFunctionsMcS.Bapiret2[] item;
        
        if (!isApexTest){
            retorno = soap.ZFiCreaFacturacionBr(EtReturn, IHeader, ItPos, target);
            linea = '92';
        }
        else{
            retorno.EpFb07 = '1900000015BRMX2010';   //Solo para motivos de testing
            retorno.EpJ1b1n = '0000000254';
        }
       
        linea = '84';
               
        if (retorno.EpFb07 != null && retorno.EpFb07 != ''){
           op.Numero_Documento_SAP__c = retorno.EpFb07.substring(0,10);
           op.Sociedad__c = retorno.EpFb07.substring(10,14);
           op.Ejercicio__c = retorno.EpFb07.substring(14,18);
        }
        else{
            if (retorno.EpJ1b1n == '0000000000'){
                String errores = IHeader.Nfnum + '\n';
                if(retorno.EtReturn.item[0] != null)
                    errores = retorno.EtReturn.item[0].Message;
                op.Observaciones_Paso_a_SAP__c = errores;
      
                update op;                              
                return;
            }
        }   
        
        if (retorno.EpJ1b1n != null)
            op.Sap_J1b1_N_Fiscal__c = retorno.EpJ1b1n;
      
        List<RecordType> rt = [SELECT Id FROM RecordType WHERE Name = 'Fc de Brasmax Contabilizada'];
        if (rt != null)
           op.RecordTypeId = rt[0].Id;
        op.Estado_facturacion__c = 'Contabilizada';
        op.Observaciones_Paso_a_SAP__c = 'OK';
        update op;        
        
    }catch(Exception e){
        op.Observaciones_Paso_a_SAP__c = 'Linea: ' + linea + '\nError: ' + e.getMessage();
        update op;
    }   
    }
    
    WebService static void mainForTest(Id oppId){
        isApexTest = true;        
        altaFC(oppId, '110');
    }
    
    public static testMethod void test(){
        RecordType rt = [Select Id From RecordType Where Name = 'BRMX' And SObjectType = 'Contrato__c' limit 1];
        
        Pricebook2 pb2 = [select id,name from Pricebook2 where name like '%Multiplica%' limit 1];
        PricebookEntry pbe = [Select id, Product2Id From PricebookEntry where isActive = true and Pricebook2Id = :pb2.id limit 1];
        Account a = new Account(Name='TMP');
        insert a;
        Contrato__c c = new Contrato__c(Cultivar__c=pbe.Product2Id, Multiplicador__c=a.Id, Sociedad__c='BRMX', RecordTypeId=rt.Id);
        insert c;                   
        Opportunity opp = new Opportunity(Tipo_de_Cambio__c=2,Sucursal__c='0094',Pricebook2Id=pb2.Id,AccountId=a.Id,Name='TMP',Safra__c='08/09',StageName='Aberta',CloseDate=System.Today());
        insert opp;
        OpportunityLineItem i = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId=pbe.id,Quantity=1,UnitPrice=2);
        insert i;
        BMX_Opp_fc_Alta.mainForTest(opp.Id);
        
    }
}
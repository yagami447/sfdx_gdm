public class CrearFacturaConverter {
    
    public CrearFacturaSoap.ZcaCrearFacturaArResponse_element result {get;set;}
    @TestVisible private SAP_environment_variables__mdt environmentVariables;
    @TestVisible private CrearFacturaSoap.ZcasDocHeaderAr DocHeader = new CrearFacturaSoap.ZcasDocHeaderAr();
    private CrearFacturaSoap.TableOfBapiret2 TResponse = new CrearFacturaSoap.TableOfBapiret2();
    @TestVisible private String CodigoSAP;
    @TestVisible private String Safra;
    @TestVisible private String ValorPositivo;
    @TestVisible private String ValorNegativo;
    @TestVisible private String DocRefNum;
    @TestVisible private String Orden;
    
    public CrearFacturaConverter(){
        CodigoSAP = '';
        Safra = '';
        ValorPositivo = '';
        ValorNegativo = '';
        this.environmentVariables = [
            SELECT  Username__c,Password__c,Target__c,
                    DocHeader_BusAct__c,
                    DocHeader_Username__c,
                    DocHeader_CompCode__c,
                    DocHeader_Item_item0_OrderId__c,
                    DocHeader_DocType__c,
                    DocHeader_Item_item0_ItemnoAcc__c,
                    DocHeader_Item_item0_GlAccount__c,
                    DocHeader_Item_item0_ItemText__c,
                    DocHeader_Item_item0_Quantity__c,
                    DocHeader_Receivable_item0_ItemnoAcc__c,
                    DocHeader_Receivable_item0_Pmnttrms__c,
                    DocHeader_Receivable_item0_AllocNmbr__c,
                    DocHeader_Receivable_item0_ItemText__c,
                    DocHeader_Currency_x_item0_ItemnoAcc__c,
                    DocHeader_Currency_x_item0_Currency_x__c,
                    DocHeader_Currency_x_item1_ItemnoAcc__c,
                    DocHeader_Currency_x_item1_Currency_x__c
            FROM SAP_environment_variables__mdt
            LIMIT 1
        ];
    }

    // Action method
    public void startRequest(Id idEventoRoyalty){
        Evento_Royalty__c eventoRoyalty = [
            SELECT Cuenta__c, Cuenta__r.CodigoSAP__c,Cuenta__r.Region__r.Region_Comercial__c,Safra__c,Valor__c, Numero_de_Referencia_SAP__c
            FROM Evento_Royalty__c
            WHERE Id = :idEventoRoyalty
        ];
        
        OpportunityLineItem itm = [Select PricebookEntry.Product2Id From OpportunityLineItem Where Opportunity.RecordType.Name In ('Pendiente','Autorizada','NC - Pendiente','NC - Autorizada') And Opportunity.AccountId =: eventoRoyalty.Cuenta__c And Opportunity.Safra__c =: eventoRoyalty.Safra__c And Opportunity.Marca__c = 'BRMX' limit 1];
        for(Centro_de_CO_Item__c centro : [Select Id, Centro_de_CO__r.Orden__c from Centro_de_CO_Item__c Where Centro_de_CO__r.Sociedad__c = 'BRMX' and Centro_de_CO__r.Campania__c = :eventoRoyalty.Safra__c And producto__c = :itm.PricebookEntry.Product2Id And Centro_de_CO__r.Region__c = :eventoRoyalty.Cuenta__r.Region__r.Region_Comercial__c])
            Orden = centro.Centro_de_CO__r.Orden__c;
        
        Safra = eventoRoyalty.Safra__c;
        ValorPositivo = String.valueOf(eventoRoyalty.Valor__c);
        ValorNegativo = String.valueOf(eventoRoyalty.Valor__c * (-1));
        CodigoSAP = eventoRoyalty.Cuenta__r.CodigoSAP__c;
        DocRefNum = eventoRoyalty.Numero_de_Referencia_SAP__c;
            
        CrearFacturaSoap.ZCA_CREAR_FACTURA_AR soap = new CrearFacturaSoap.ZCA_CREAR_FACTURA_AR();

        soap.inputHttpHeaders_x = new Map<String, String>();
        String encodedusernameandpassword;

        String myData = environmentVariables.Username__c + ':' + environmentVariables.Password__c;
        //String myData = 'sromero:Mario208';
        Blob hash = Blob.valueOf(myData);
        encodedusernameandpassword = EncodingUtil.base64Encode(hash);
        soap.timeout_x = 60000;
        soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
        cargarDocHeader();

        result = soap.ZcaCrearFacturaAr(DocHeader,TResponse,environmentVariables.Target__c);
        for( CrearFacturaSoap.Bapiret2 item : result.TResponse.item){
            System.debug('Response start');
            System.debug('item.Type_x: '+item.Type_x );
            System.debug('item.Id: '+item.Id );
            System.debug('item.Number_x: '+item.Number_x );
            System.debug('item.Message: '+item.Message );
            System.debug('item.LogNo: '+item.LogNo );
            System.debug('item.LogMsgNo: '+item.LogMsgNo );
            System.debug('item.MessageV1: '+item.MessageV1 );
            System.debug('item.MessageV2: '+item.MessageV2 );
            System.debug('item.MessageV3: '+item.MessageV3 );
            System.debug('item.MessageV4: '+item.MessageV4 );
            System.debug('item.Parameter: '+item.Parameter );
            System.debug('item.Row: '+item.Row );
            System.debug('item.Field: '+item.Field );
            System.debug('item.System_x: '+item.System_x );
            System.debug('-----------------------------------------------');
            System.debug('-----------------------------------------------');
        }
    }

    @TestVisible
    private void cargarDocHeader(){
        DocHeader.BusAct = environmentVariables.DocHeader_BusAct__c;
        DocHeader.Username = environmentVariables.DocHeader_Username__c;
        DocHeader.CompCode = environmentVariables.DocHeader_CompCode__c;
        DocHeader.DocDate = String.valueOf(System.today());
        DocHeader.PstngDate = String.valueOf(System.today());
        DocHeader.DocType = environmentVariables.DocHeader_DocType__c;
        DocHeader.RefDocNo = DocRefNum;
        DocHeader.Item = new CrearFacturaSoap.ZcatDocItemAr();
        DocHeader.Item.item = new List<CrearFacturaSoap.ZcasDocItemAr>();
        DocHeader.Item.item.add(
        new CrearFacturaSoap.ZcasDocItemAr()
        );
        DocHeader.Item.item[0].ItemnoAcc = environmentVariables.DocHeader_Item_item0_ItemnoAcc__c;
        DocHeader.Item.item[0].GlAccount = environmentVariables.DocHeader_Item_item0_GlAccount__c;
        DocHeader.Item.item[0].ItemText = environmentVariables.DocHeader_Item_item0_ItemText__c;
        DocHeader.Item.item[0].Quantity = String.ValueOf(Integer.valueOf(environmentVariables.DocHeader_Item_item0_Quantity__c));
        //DocHeader.Item.item[0].Orderid = environmentVariables.DocHeader_Item_item0_OrderId__c; 
        DocHeader.Item.item[0].Orderid = Orden; 

        DocHeader.Receivable = new CrearFacturaSoap.ZcatReceivableItem();
        DocHeader.Receivable.item = new List<CrearFacturaSoap.ZcasReceivableItem>();
        DocHeader.Receivable.item.add(
        new CrearFacturaSoap.ZcasReceivableItem()
        );
        DocHeader.Receivable.item[0].ItemnoAcc = environmentVariables.DocHeader_Receivable_item0_ItemnoAcc__c;
        DocHeader.Receivable.item[0].Customer = CodigoSAP;
        DocHeader.Receivable.item[0].Pmnttrms = environmentVariables.DocHeader_Receivable_item0_Pmnttrms__c;
        DocHeader.Receivable.item[0].BlineDate = String.valueOf(System.today());
        DocHeader.Receivable.item[0].AllocNmbr = environmentVariables.DocHeader_Receivable_item0_AllocNmbr__c +' '+ Safra;
        DocHeader.Receivable.item[0].ItemText = environmentVariables.DocHeader_Receivable_item0_ItemText__c;

        DocHeader.Currency_x = new CrearFacturaSoap.ZcatCurrencyAmountAr();
        DocHeader.Currency_x.item = new List<CrearFacturaSoap.ZcasCurrencyAmountAr>();
        DocHeader.Currency_x.item.add(
        new CrearFacturaSoap.ZcasCurrencyAmountAr()
        );
        DocHeader.Currency_x.item[0].ItemnoAcc = environmentVariables.DocHeader_Currency_x_item0_ItemnoAcc__c;
        DocHeader.Currency_x.item[0].Currency_x = environmentVariables.DocHeader_Currency_x_item0_Currency_x__c;
        DocHeader.Currency_x.item[0].AmtDoccur = ValorPositivo;
        DocHeader.Currency_x.item.add(
        new CrearFacturaSoap.ZcasCurrencyAmountAr()
        );
        DocHeader.Currency_x.item[1].ItemnoAcc = environmentVariables.DocHeader_Currency_x_item1_ItemnoAcc__c;
        DocHeader.Currency_x.item[1].Currency_x = environmentVariables.DocHeader_Currency_x_item1_Currency_x__c;
        DocHeader.Currency_x.item[1].AmtDoccur = ValorNegativo;
    }
}
@isTest
public class customBtnAprovalProcessControllerTest {
    static Opportunity opportunityOne;
    static Variedad__c variedadOne;
    // static PricebookEntry pricebookEOne;
    static Pricebook2 pricebookOne;
    static Id pricebookIdOne;

    @TestSetup 
    public static void setup() {
        pricebookIdOne = Test.getStandardPricebookId();
        Regiao__c region = Build.aRegiao().withRegionComercial('REGION 1').build();
		insert region;
        Account testAccount = new Account();
        testAccount.name = 'TestAccount';
        testAccount.Region__c = region.id;
        insert testAccount;

        String safraActual = '20/21'; //aAppManager.getSafraActualByApp('A5');

		Configuracion_BMX__c conf = new Configuracion_BMX__c(PM_Safra_Actual__c = safraActual);
        insert conf;
        
        // Account accountOfOpportunity = Build.anAccount()
		// .withRegion(region)
        // .build();
        // insert accountOfOpportunity;

        Campaign campanha = new Campaign();
		campanha.Marca__c = 'BRMX';
		campanha.Safra__c = safraActual;
		campanha.Region__c = region.Id;
        campanha.Name = 'Campania Test';
        campanha.epoca_de_producao__c = 'Inverno';
		campanha.StartDate = System.today().addDays(-10);
        campanha.EndDate = System.today().addDays(10);
        campanha.Lista_de_precios__c = Test.getStandardPricebookId();
        campanha.RecordTypeId = XappiaHelper.getRecordType('Campaign','Venda_de_Basica').Id;
        campanha.Region_VB__c = 'REGION 1';
        insert campanha;
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venda_da_Basica_full').getRecordTypeId();

        opportunityOne = Build.anOpportunityVENTADEBASICA()
        .withCloseDate(System.today().addDays(4))
        .withMarca('BRMX')
        .withPricebook2Id(Test.getStandardPricebookId())
        .withSafra(safraActual)
        .withAccountId(testAccount)
        .withCloseDate(System.today())
        .build();
        opportunityOne.CampaignId = campanha.Id;
        opportunityOne.Novo_primeiro_vencimento__c = System.today().addMonths(1);
        opportunityOne.Taxa_de_primeiro_pagamento__c = 100;
        opportunityOne.Total__c = 100;
        opportunityOne.Preco_Total_Sugerido_Sem_Juros__c = 100;
    
        insert opportunityOne;

        variedadOne = Build.aVariedad().
        withName('Variety One').
        withAtiva(true).
        withNombredeRegistro('VarOne').
        withNumeroderegistro('123').
        build();
        variedadOne.Disponivel_para_venda_basica__c = true;
        variedadOne.Marca_comercial__c = 'Brasmax';
        variedadOne.Regiao_disponivel_para_venda_basica__c = 'REGION 1';

        insert variedadOne;

        Product2 producto = Build.aProduct2().build();
        producto.IsActive=true;
        insert producto;

        pricebookOne = new Pricebook2(
        Id = pricebookIdOne,
        Regi_o__c = region.Id,
        Para_venda_de_b_sica_inicial__c = true
        );
        update pricebookOne;
        

        PricebookEntry PricebookE = new PricebookEntry();
        PricebookE.Product2Id=producto.id;
        PricebookE.Pricebook2Id=pricebookOne.id;
        PricebookE.UnitPrice=10;
        PricebookE.IsActive = true;
        insert PricebookE;
    }

    @isTest
    public static void opporMustHaveAtLeastOneProduct_TobeSendToAproval () {
        String result = '';
        opportunity opp = [
                        SELECT id, stageName, hasOpportunityLineItem
                        FROM Opportunity
                        ];
        opp.StageName = 'Edición';
        update opp;
        Test.startTest();
        try {
            customBtnAprovalProcessController.sendToApproveOpportunity(opp.id);
        } catch (AuraHandledException e) {
            result = e.getMessage();
        }
        Test.stopTest();

        System.assertEquals(customBtnAprovalProcessController.errorSinProd, result, 'No se puede enviar a aprobar una oportunidad sin productos');
    }

    @isTest
    public static void oppStageMustBeEdicion(){
        String result = '';
        Configuracion_BMX__c conf = [SELECT Id, PM_Safra_Actual__c FROM Configuracion_BMX__c LIMIT 1];

        opportunity opp = [
                    SELECT id, stageName, hasOpportunityLineItem, Desvio_Venda_de_Basica__c
                    FROM Opportunity
        ];
        opp.StageName = 'Na revisão do supervisor';
        opp.Safra__c = conf.PM_Safra_Actual__c;
        update opp;

        product2 prod = [
                    SELECT Id
                    FROM Product2
        ];

        PricebookEntry pbe = [
                    SELECT id 
                    FROM PricebookEntry
        ];
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.opportunityId = opp.id;
        oli.Quantity = 10;
		oli.TotalPrice = 100;
        oli.pricebookEntryId = Pbe.id ;
		oli.Product2Id = prod.Id;
        oli.Tipo_de_Necessidade__c = 'Multiplicação';
        insert oli;

        Test.startTest();
        try {
            customBtnAprovalProcessController.sendToApproveOpportunity(opp.id);
        } catch (AuraHandledException e) {
            result = e.getMessage();
        }
        Test.stopTest();

        System.assertEquals(customBtnAprovalProcessController.errorNoEdicion, result, 'Etapa de la oportunidad debe ser Edición para ser enviada a aprobar');
    }
    @isTest
    public static void StageNameOfOppMustBecameEdicion(){
        String result = '';
        Configuracion_BMX__c conf = [SELECT Id, PM_Safra_Actual__c FROM Configuracion_BMX__c LIMIT 1];

        opportunity opp = [
                    SELECT id, stageName, hasOpportunityLineItem
                    FROM Opportunity
        ];
        opp.StageName = 'Edición';
        opp.Safra__c = conf.PM_Safra_Actual__c;
        update opp;

        product2 prod = [
                    SELECT Id
                    FROM Product2
        ];

        PricebookEntry pbe = [
                    SELECT id 
                    FROM PricebookEntry
        ];
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.opportunityId = opp.id;
        oli.Quantity = 10;
		oli.TotalPrice = 100;
        oli.pricebookEntryId = Pbe.id ;
		oli.Product2Id = prod.Id;
        oli.Tipo_de_Necessidade__c = 'Multiplicação';
        insert oli;

        Test.startTest();
        try {
            customBtnAprovalProcessController.sendToApproveOpportunity(opp.id);
        } catch (AuraHandledException e) {
            result = e.getMessage();
        }
        Test.stopTest();

        System.assertEquals('Edición', opp.StageName, 'La oportunidad debería estar en estado de Edición');
    }
}
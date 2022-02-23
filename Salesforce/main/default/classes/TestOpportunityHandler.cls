@IsTest
public class TestOpportunityHandler {
    
    @istest public static void test1(){
        Id recordTypeA1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoI').getRecordTypeId();
        Id recordTypeA2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoII').getRecordTypeId();
        Id recordTypeA3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId();
        Id recordTypeA4 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_IV').getRecordTypeId();
        Id recordTypeA5 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoV').getRecordTypeId();
        Id recordTypeStock = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Stock_Multiplicadores').getRecordTypeId();
        Id recordTypeReb = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_II_Rebaixamento_Sacas').getRecordTypeId();
        Id recordTypeDesc = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Descarte').getRecordTypeId();
        List<String> month = new List<String> {'ZERO', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'};
        Configuracion_BMX__c config = new Configuracion_BMX__c();
        config.Mes_Stock__c = String.valueOf(month.get(System.today().month()));
        insert config;
        Account acc = new Account(Name = 'Teste');
        acc.Responsavel_NEOGEN__c = '020 - Eduardo L. da Silva';
        insert acc;
        Contrato__c cont = new Contrato__c();
        cont.Multiplicador__c = acc.Id;
        cont.Safra__c = '19/20';
        cont.Sociedad__c = 'NEOG';
        insert cont;
        Product2 prod = new Product2(Name = 'Test');
        prod.IsActive = true;
        insert prod;
        Item_del_Contrato__c icon = new Item_del_Contrato__c();
        icon.Cultivar__c = prod.Id;
        icon.Contrato_de_Multiplicacion__c = cont.Id;
        insert icon;
        Opportunity oppa1 = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '19/20', RecordTypeId = recordTypeA1);
        insert oppa1;
        Opportunity oppa2V = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '19/20', RecordTypeId = recordTypeA2, Epoca_de_plantio__c = 'Verão');
        insert oppa2V;
        
        Opportunity oppE = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '19/20', RecordTypeId = recordTypeStock);
        insert oppE;
        Test.StartTest();
        OpportunityHandler.setPricebook2Id(new List<Opportunity>{oppa1});
        OpportunityHandler.ChangeOwnerInAfter(new List<Opportunity>{oppa1});
        OpportunityHandler.ShareOpportunityFromCommunity(new List<Opportunity>{oppa1}, null);
        OpportunityHandler.fillRegion(new List<Opportunity>{oppa1});    
        OpportunityHandler.ValidatePreviousAttachment(new List<Opportunity>{oppa1});  
        
        OpportunityHandler.validateAII(new List<Opportunity>{oppa2V});
        
        OpportunityHandler.fillSeasonForA2(new List<Opportunity>{oppa2V}); 
        oppa2V.StageName = 'Aprobada';
        update oppa2V;
        Opportunity oppa2I = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '19/20', RecordTypeId = recordTypeA2, Epoca_de_plantio__c = 'Inverno');
        insert oppa2I;
              
        OpportunityHandler.fillSeasonForA2(new List<Opportunity>{oppa2I});
        //Daqui pra baixo ajustar
        OpportunityHandler.fillStock(new List<Opportunity>{oppE});
        //OpportunityHandler.addOpportunityLineItems(new List<Opportunity>{oppE}); //DESCOMENTAR E AJUSTAR
        
        Opportunity oppReb = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '19/20', RecordTypeId = recordTypeReb);
        oppReb.Anexo_Relacionado__c = oppa2V.Id;
        insert oppReb;
        OpportunityHandler.fillRelatadedAtt(new List<Opportunity>{oppReb});
        Test.stopTest();
        

        
        
        /*
        
        */
    }
    @isTest
    public static void testa35(){
        Id recordTypeA1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoI').getRecordTypeId();
        Id recordTypeA2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoII').getRecordTypeId();
        Id recordTypeA3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_III').getRecordTypeId();
        Id recordTypeA4 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_IV').getRecordTypeId();
        Id recordTypeA5 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AnexoV').getRecordTypeId();
        Id recordTypeStock = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Stock_Multiplicadores').getRecordTypeId();
        Id recordTypeReb = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Anexo_II_Rebaixamento_Sacas').getRecordTypeId();
        Id recordTypeDesc = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Descarte').getRecordTypeId();
        List<String> month = new List<String> {'ZERO', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'};
        Configuracion_BMX__c config = new Configuracion_BMX__c();
        config.Mes_Stock__c = String.valueOf(month.get(System.today().month()));
        insert config;
        Account acc = new Account(Name = 'Teste');
        acc.Responsavel_NEOGEN__c = '020 - Eduardo L. da Silva';
        insert acc;
        Contrato__c cont = new Contrato__c();
        cont.Multiplicador__c = acc.Id;
        cont.Safra__c = '19/20';
        cont.Sociedad__c = 'NEOG';
        insert cont;
        Product2 prod = new Product2(Name = 'Test');
        prod.IsActive = true;
        insert prod;
        Item_del_Contrato__c icon = new Item_del_Contrato__c();
        icon.Cultivar__c = prod.Id;
        icon.Contrato_de_Multiplicacion__c = cont.Id;
        insert icon;
        Opportunity oppa1 = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '19/20', RecordTypeId = recordTypeA1);
        insert oppa1;
        Opportunity oppa2v = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '19/20', RecordTypeId = recordTypeA2, Epoca_de_plantio__c = 'Verão');
        insert oppa2v;
        Opportunity oppa3 = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '19/20', RecordTypeId = recordTypeA3);
        insert oppa3;
        Opportunity oppa4 = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '19/20', RecordTypeId = recordTypeA4);
        insert oppa4;
        Opportunity oppa5 = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '19/20', RecordTypeId = recordTypeA5);
        insert oppa5;
        Opportunity oppE = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '19/20', RecordTypeId = recordTypeStock);
        insert oppE;

        Test.StartTest();
        OpportunityHandler.addOpportunityLineItems(new List<Opportunity>{oppa1});
        OpportunityHandler.addOpportunityLineItems(new List<Opportunity>{oppa2v});
        oppa2v.StageName = 'Aprobada';
        update oppa2v;
        OpportunityHandler.addOpportunityLineItems(new List<Opportunity>{oppa3});
        OpportunityHandler.addOpportunityLineItems(new List<Opportunity>{oppa4});
        OpportunityHandler.addOpportunityLineItems(new List<Opportunity>{oppa5});
        OpportunityHandler.addOpportunityLineItems(new List<Opportunity>{oppE});
        Test.stopTest();
    }
}
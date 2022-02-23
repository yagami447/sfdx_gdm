@IsTest
public class beforeInsertUpdateOpporTest {
    /*
    @IsTest
    public static void SiCambiaEltipoDeRegistroDeAnexoIII_aAutorizada_habilitarSaldo(){
        //Inicialización y carga de datos
        Opportunity opp = Build.anOpportunityAnexoIII().build();
        insert opp;
        
        opp = [
            SELECT ID 
            FROM Opportunity
            WHERE ID = :opp.id
        ];
        
        opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Autorizada').Id;
        
        //Test
        Test.startTest();
        update opp;
        Test.stopTest();
        //ASSERTS
		System.assertEquals(true, [SELECT Saldo_Habilitado__c FROM Opportunity WHERE ID = : opp.id].Saldo_Habilitado__c);        
    }*/
    
    @IsTest
    public static void SiCambiaElStageAAutorizada_cargaroppIdDescuentoYaccs(){
        //Inicialización y carga de datos
        Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX().
            withPMSafraActualA1('18/19').
            build();
        insert testConfiguracionBMX;
        
        Account cuenta = Build.anAccountCuenta().build();
        insert cuenta;
        
        Opportunity opp = Build.anOpportunityAnexoIII().build();
        opp.AccountId = cuenta.id;
        insert opp;
        
        Product2 producto = Build.aProduct2().build();
        producto.IsActive=true;
        insert producto;
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;

        PricebookEntry PricebookE = new PricebookEntry();
        PricebookE.Product2Id=producto.id;
        PricebookE.Pricebook2Id=standardPricebook.id;
        PricebookE.UnitPrice=10;
        PricebookE.IsActive = true;
        insert PricebookE;
        OpportunityLineItem OppLineItem = 
            Build.anOpportunityLineItem()
            .withOpportunityId(opp)
            .withPricebookEntryId(PricebookE)
            .withProduct2Id(producto)
            .withQuantity(1)
            .withUnitPrice(10)
            .build();
        insert OppLineItem;
        
        /*
        Account cuenta = new Account(
            name = 'test'
        );
        insert cuenta;
        
        Saldo_por_safra__c saldoSafra = Build.aSaldoPorSafra()
            .withAccount(cuenta)
            .build();
        saldoSafra.Safra__c = '123';
        insert saldoSafra;
        
        Opportunity opp = Build.anOpportunityAnexoIII().build();
        opp.AccountId = cuenta.id;
        insert opp;
        
        OpportunityLineItem item = Build.anOpportunityLineItem().build();
        item.OpportunityId = opp.id;
        
        insert item;
        */
        
        opp = [
            SELECT ID 
            FROM Opportunity
            WHERE ID = :opp.id
        ];
        
        opp.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Autorizada').Id;
        
        update opp;
        opp.StageName = 'AU - Autorizada';
        
        //Test
        Test.startTest();
        update opp;
        Test.stopTest();
        //ASSERTS
		//System.assertEquals(true, [SELECT Saldo_Habilitado__c FROM Opportunity WHERE ID = : opp.id].Saldo_Habilitado__c);        
    }
}
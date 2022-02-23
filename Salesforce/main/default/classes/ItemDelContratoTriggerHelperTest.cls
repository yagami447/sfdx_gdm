@isTest
public class ItemDelContratoTriggerHelperTest  {

	@TestSetup
	static void setup() {
		Account cuenta = new Account(
			Name = 'Test'
		);
		insert cuenta;
		Contract contratoMarco = new Contract (
			Name = 'Contrato marco',
			AccountId = cuenta.Id
		);
		insert contratoMarco;
		Contrato__c contrato = new Contrato__c(
			RecordTypeId = [SELECT ID FROM RecordType WHERE DeveloperName = 'Termo_Aditivo'].id,
			Estado__c = 'Chegou',
			Observacao__c = 'Soy el original',
			Sociedad__c = 'DSEM',
			Estados_Comercializacao__c = 'CE',
			Contrato_marco__c = contratoMarco.Id,
			Region_Comercial__c = 'REGION 1',
			Meta_Qde_comodato_de_area__c = 1,
			Meta_Qde_Dias_de_Campo__c = 1
		);
		insert contrato;
	}


	@isTest
	static void debeAniadirAlLogLosNuevosProductosAlContratoClonado() {
		Contrato__c contrato = [SELECT ID FROM Contrato__c WHERE Estado__c = 'Chegou'];
        Item_del_Contrato__c itemObjetivo = new Item_del_Contrato__c();
        Item_del_Contrato__c item = new Item_del_Contrato__c();
		String id = ClonarContratoLightningController.cloneContract(contrato.Id);
		Test.startTest();
			item.Contrato_de_Multiplicacion__c = id;
			insert item;
			itemObjetivo.Contrato_de_Multiplicacao__c = id;
			itemObjetivo.Contrato_de_Multiplicacion__c = id;
			insert itemObjetivo;
			Contrato__c clon = [SELECT ID, log_cambios__c FROM Contrato__c WHERE ID =: id];
		Test.stopTest();
		System.assertEquals(true, clon.log_cambios__c.contains('Novo cultivar'), 'No se escribio el log');
		System.assertEquals(true, clon.log_cambios__c.contains('Novo objetivo'), 'No se escribio el log');
	}

	@isTest
	static void debeAniadirAlLogLasModificacionesEnLosItems() {
		Contrato__c contrato = [SELECT ID FROM Contrato__c WHERE Estado__c = 'Chegou'];
        Item_del_Contrato__c itemObjetivo = new Item_del_Contrato__c();
        Item_del_Contrato__c item = new Item_del_Contrato__c();
		String id = ClonarContratoLightningController.cloneContract(contrato.Id);
		Test.startTest();
			item.Contrato_de_Multiplicacion__c = id;
			insert item;
			itemObjetivo.Contrato_de_Multiplicacao__c = id;
			itemObjetivo.Contrato_de_Multiplicacion__c = id;
			insert itemObjetivo;
			itemObjetivo.Quantidade__c = 100;
			itemObjetivo.Volumen_Aut_Comercializacion__c = 100;
			update itemObjetivo;
			Contrato__c clon = [SELECT ID, log_cambios__c FROM Contrato__c WHERE ID =: id];
		Test.stopTest();
		System.debug(clon.log_cambios__c);
		System.assertEquals(true, clon.log_cambios__c.contains('Volume de comercialização'), 'No se esctibio el log del volumen');
		System.assertEquals(true, clon.log_cambios__c.contains('Quantidade alterado de'), 'No se esctibio el log de la cantidad');
	}

	@IsTest
	static void debeAniadirAlLogAlBorrarUnItem() {
		Contrato__c contrato = [SELECT ID FROM Contrato__c WHERE Estado__c = 'Chegou'];
        Item_del_Contrato__c itemObjetivo = new Item_del_Contrato__c();
        Item_del_Contrato__c item = new Item_del_Contrato__c();
		String id = ClonarContratoLightningController.cloneContract(contrato.Id);
		Test.startTest();
			item.Contrato_de_Multiplicacion__c = id;
			insert item;
			itemObjetivo.Contrato_de_Multiplicacao__c = id;
			itemObjetivo.Contrato_de_Multiplicacion__c = id;
			insert itemObjetivo;
			itemObjetivo.Quantidade__c = 100;
			itemObjetivo.Volumen_Aut_Comercializacion__c = 100;
			update itemObjetivo;
			delete itemObjetivo;
			Contrato__c clon = [SELECT ID, log_cambios__c FROM Contrato__c WHERE ID =: id];
		Test.stopTest();
		System.debug(clon.log_cambios__c);
		System.assertEquals(true, clon.log_cambios__c.contains('Removido'), 'No se esctibio el log al borrar el item');


	}
}
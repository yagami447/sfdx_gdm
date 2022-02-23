@isTest
public class ClonarContratoControllerTest{
	@TestSetup
	static void setup(){
		Account cuenta = new Account(Name = 'Test');
		insert cuenta;
		Contract contratoMarco = new Contract(Name = 'Contrato marco', AccountId = cuenta.Id);
		insert contratoMarco;
		Contrato__c contrato = new Contrato__c(RecordTypeId = [SELECT ID
		                                                       FROM RecordType
		                                                       WHERE DeveloperName = 'Termo_Aditivo'].id, Estado__c = 'Chegou', Observacao__c = 'Soy el original', Sociedad__c = 'DSEM', Estados_Comercializacao__c = 'CE', Contrato_marco__c = contratoMarco.Id, Region_Comercial__c = 'REGION 1', Meta_Qde_comodato_de_area__c = 1, Meta_Qde_Dias_de_Campo__c = 1);
		insert contrato;

		Categoria__c categoria = new Categoria__c(Name = 'ElPsyKongroo');
		insert categoria;

		Variedad__c variedad = new Variedad__c(Name = 'Reading Steiner', Ativa__c = true, Marca_comercial__c = 'Brasmax');
		insert variedad;
	}

	@IsTest
	static void debeClonarseElContratoConSusItems(){

		PageReference pref = Page.ClonarContrato;
		Test.setCurrentPage(pref);

		Contrato__c contrato = [SELECT ID
		                        FROM Contrato__c
		                        WHERE Estado__c = 'Chegou'];

		Item_del_Contrato__c item = new Item_del_Contrato__c();
		item.Contrato_de_Multiplicacion__c = contrato.Id;
		item.Contrato_de_Multiplicacao_vol__c = contrato.Id;
		insert item;

		ApexPages.StandardController con = new ApexPages.StandardController(contrato);

		ClonarContratoController controlador = new ClonarContratoController(con);

		Test.startTest();

		PageReference ref = controlador.cloneWithItems();

		PageReference redir = new PageReference('/' + controlador.newRecordId + '/e?retURL=%2F' + controlador.newRecordId);

		System.assertEquals(ref.getUrl(), redir.getUrl());
		Test.stopTest();
		Contrato__c newPO = [select id
		                     from Contrato__c
		                     where id = :controlador.newRecordId];
		System.assertNotEquals(newPO, null);
		List<Item_del_Contrato__c> newItems = [Select Id
		                                       From Item_del_Contrato__c
		                                       WHERE Contrato_de_Multiplicacion__c = :newPO.id];
		System.assertEquals(newItems.size(), 1);
	}

	@isTest
	static void debeActualizarElCampoLogDeCambios(){
		Contrato__c contrato = [SELECT ID
		                        FROM Contrato__c];
		ApexPages.StandardController con = new ApexPages.StandardController(contrato);
		ClonarContratoController controlador = new ClonarContratoController(con);
		Test.startTest();

		controlador.cloneWithItems();
		List<Contrato__c> listaContratos = [SELECT ID, Estado__c, Observacao__c, log_cambios__c
		                                    FROM Contrato__c];
		listaContratos[1].Sociedad__c = 'NEOG';
		listaContratos[1].Estado__c = 'Pendente de Aprovação';
		listaContratos[1].Estados_Comercializacao__c = 'AM';
		listaContratos[1].Region_Comercial__c = 'REGION 2';
		listaContratos[1].Contrato_marco__c = null;
		listaContratos[1].Meta_Qde_comodato_de_area__c = 5;
		listaContratos[1].Meta_Qde_Dias_de_Campo__c = 5;
		update listaContratos[1];
		listaContratos = [SELECT ID, Estado__c, Observacao__c, log_cambios__c
		                  FROM Contrato__c];
		System.debug(listaContratos[1].log_cambios__c);
		Test.stopTest();

		System.assertNotEquals(null, listaContratos[1].log_cambios__c, 'El Log no se escribió');
		System.assertEquals(true, listaContratos[1].log_cambios__c.contains('alterada'), 'No se tomaron los cambios');
	}

	@isTest
	static void debeContarCorrectamenteLaCantidadDeItems(){
		PageReference pref = Page.ClonarContrato;
		Test.setCurrentPage(pref);

		Contrato__c contrato = [SELECT ID
		                        FROM Contrato__c
		                        WHERE Estado__c = 'Chegou'];


		Item_del_Contrato__c item = new Item_del_Contrato__c();
		item.Contrato_de_Multiplicacion__c = contrato.Id;
		item.Contrato_de_Multiplicacao_vol__c = contrato.Id;
		item.Contrato_de_Multiplicacion__c = contrato.Id;
		insert item;
		System.debug(item.Contrato_de_Multiplicacion__c);

		ApexPages.StandardController con = new ApexPages.StandardController(contrato);

		ClonarContratoController controlador = new ClonarContratoController(con);

		Test.startTest();

		PageReference ref = controlador.cloneWithItems();

		PageReference redir = new PageReference('/' + controlador.newRecordId + '/e?retURL=%2F' + controlador.newRecordId);

		System.assertEquals(ref.getUrl(), redir.getUrl());
		Test.stopTest();
		Contrato__c newPO = [select id
		                     from Contrato__c
		                     where id = :controlador.newRecordId];
		List<Item_del_Contrato__c> items = [SELECT ID, Contrato_de_Multiplicacion__c
		                                    FROM Item_del_Contrato__c];
		System.assertEquals(items[1].Contrato_de_Multiplicacion__c, newPO.Id, 'No se clono la relacion mater-detail');
	}

	@IsTest
	static void debeClonarElContratoEnLightning(){
		Contrato__c contrato = [SELECT ID
		                        FROM Contrato__c
		                        WHERE Estado__c = 'Chegou'];
		Test.startTest();
		String id = ClonarContratoLightningController.cloneContract(contrato.Id);
		Test.stopTest();
		System.assertNotEquals(null, id, 'No se clono el contrato');
	}

	@isTest
	static void NoDebeClonarElContratoSiElEstadoNoEsChego(){
		Contrato__c contrato = [SELECT ID
		                        FROM Contrato__c
		                        WHERE Estado__c = 'Chegou'];
		contrato.Estado__c = 'Pendente de Aprovação';
		update contrato;
		String id;
		String mensaje;
		Test.startTest();
		try{
			id = ClonarContratoLightningController.cloneContract(contrato.Id);
		} catch (Exception e){
			mensaje = e.getMessage();
		}
		Test.stopTest();
		System.assertEquals(null, id, 'No se lanzo la excepcion para impedir clonar el contrato');
		System.assertEquals('Script-thrown exception', mensaje, 'No se disparo la expcecion');
	}

	@IsTest
	static void debeClonarElContratoConSusItems(){
		Contrato__c contrato = [SELECT ID
		                        FROM Contrato__c
		                        WHERE Estado__c = 'Chegou'];
		Item_del_Contrato__c item = new Item_del_Contrato__c();
		item.Contrato_de_Multiplicacion__c = contrato.Id;
		item.Contrato_de_Multiplicacao_vol__c = contrato.Id;
		item.Contrato_de_Multiplicacion__c = contrato.Id;
		insert item;
		Test.startTest();
		String id = ClonarContratoLightningController.cloneContract(contrato.Id);
		Test.stopTest();
		List<Item_del_Contrato__c> itemClon = [SELECT ID
		                                       FROM Item_del_Contrato__c
		                                       WHERE Contrato_de_Multiplicacion__c = :id];
		System.assertNotEquals(null, id, 'No se clono el contrato');
		System.assertEquals(1, itemClon.size(), 'No se clono el item');
	}

	@isTest
	static void TipodeCotacao_NoPuedeSerCambiado(){
		try{
			Contrato__c contract = [SELECT ID, Tipo_de_Cota_o__c, Name
			                       FROM Contrato__c];
			Item_del_Contrato__c item = new Item_del_Contrato__c();
			item.Contrato_de_Multiplicacion__c = contract.id;
			insert item;

			contract.Tipo_de_Cota_o__c = 'SOJA';
			test.startTest();
			Database.SaveResult updateResult = Database.update(contract);
			test.stopTest();

			Boolean wasUpdated = updateResult.isSuccess();
		} catch (Exception e){
			System.debug('Exception captured: ');
			System.debug(e.getMessage());
			//System.assertEquals(false, wasUpdated);
		}


		
	}
}
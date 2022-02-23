@isTest
public class AnticiposControllerTest{
	@TestSetup
	static void makeData(){
		Cotizacion_Soja__c cotSoja = new Cotizacion_Soja__c();
		cotSoja.Valor__c = 200;
		cotSoja.Cotacao_de_soja__c = 'ADM';
		cotSoja.Safra__c = '18/20';
		insert cotSoja;
		Account accMulti = new Account();
		accMulti.Name = 'accMulti';
		insert accMulti;
		Variedad__c variedad = new Variedad__c();
		variedad.Name = 'Variedad testing';
		variedad.Nombre_de_Registro__c = 'Nom reg';
		insert variedad;

		Categoria__c categoria = new Categoria__c();
		categoria.Name = 'Categoria X';
		insert categoria;
		//Cultivar
		Product2 prod = new Product2();
		prod.Name = 'Testing prod';
		prod.Variedade__c = variedad.id;
		prod.Categ__c = categoria.id;
		insert prod;

		Contrato__c contractM = new Contrato__c();
		contractM.Multiplicador__c = accMulti.id;
		contractM.RecordTypeId = Schema.SObjectType.Contrato__c.getRecordTypeInfosByDeveloperName().get('Termo_Aditivo').getRecordTypeId();
		contractM.Estado__c = 'Chegou';
		contractM.Safra__c = '19/20';
		contractM.Sociedad__c = 'BRMX';
		contractM.Region_Comercial__c = 'REGION 1';
		insert contractM;

		Item_del_Contrato__c item = new Item_del_Contrato__c();
		item.Volumen_Aut_Comercializacion__c = 5;
		item.Cultivar__c = prod.id;
		item.variedad__c = variedad.id;
		item.Contrato_de_Multiplicacion__c = contractM.id;
		item.Precio__c = 200;
		item.Praca__c = 'Praca actual';
		item.RecordTypeId = Schema.SObjectType.Item_del_Contrato__c.getRecordTypeInfosByName().get('Volumen').getRecordTypeId();
		insert item;
	}

	@isTest
	private static void buscarYcrearPedidos(){
		AnticiposController controller = new AnticiposController();
		Test.startTest();
		controller.Buscar();
		controller.SelectAll();
		controller.CrearPedidos();
		Test.stopTest();
	}

	@isTest
	private static void setGetMensaje(){
		AnticiposController controller = new AnticiposController();
		Test.startTest();
		controller.setMensaje('Test message');
		String msg = controller.getMensaje();
		Test.stopTest();

		System.assertEquals('Test message', msg);
	}

	@isTest
	private static void getVerDetallesDisabled(){
		AnticiposController controller = new AnticiposController();
		Test.startTest();
		controller.getVerDetalles();
		Boolean resp = controller.getVerDetallesDisabled();
		Test.stopTest();
	}

	@isTest
	private static void quitarSeleccion(){
		AnticiposController controller = new AnticiposController();
		Test.startTest();
		controller.quitarSeleccion();
		Test.stopTest();
	}
	@isTest 
	private static void gettersAndSetters(){
		AnticiposController controller = new AnticiposController();
		OpportunityLineItem newOli = new OpportunityLineItem();
		Opportunity opp = new Opportunity(Name = 'New Opp');
		AnticiposController.Anticipo anticipo = new AnticiposController.Anticipo();
		anticipo.idCuenta = 'IDTEST123';
		anticipo.cuenta = 'Cuenta';
		anticipo.quantidade = 22;
		anticipo.quantidadeAnticipo = 5;
		anticipo.porcAnticipo = '10';
		anticipo.valorTotal = 3000;
		List<AnticiposController.Anticipo> listaAnticipos = new List<AnticiposController.Anticipo>();
		listaAnticipos.add(anticipo);
		Test.startTest();
		controller.setOpp(opp);
		Opportunity oppGetted = controller.getOpp();
		controller.setItem(newOli);
		OpportunityLineItem oli = controller.getItem();		
		controller.setlistaAnticipos(listaAnticipos);
		List<AnticiposController.Anticipo> ant = controller.getlistaAnticipos();
		Test.stopTest();

	}
}
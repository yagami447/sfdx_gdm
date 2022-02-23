@isTest
public class EventoRoyaltyTriggerTest  {
	
	//Se agrego static para evitar problema con Too many SOQL queries: 101
	static{
		Test.setMock(WebServiceMock.class, new CrearFacturaSoapMOCK.CrearFacturaSoapSuccessfullyMOCK());
	}

	@TestSetup
	public static void setup(){
		Account acc = new Account(Name='Conta');
		acc.Supervisor__c = UserInfo.getUserId();
		acc.Gerente_comercial__c = UserInfo.getUserId();
        insert acc;

		Product2 prod = Build.aProduct2().
            withName('Test product2').
            withCategoria('BASICA').
            withFamily('Royalty x Basica').
            withPrice(40).
            withIsActive(true).
            build();
        insert prod;

		Pricebook2 pricebook = new Pricebook2();
        pricebook.Name = 'Lista de precios estándar';
        insert pricebook;

		PricebookEntry pbe = Build.aPricebookEntry().
            withPricebook2Id(Test.getStandardPricebookId()).
            withUnitPrice(58).
            withProduct2Id(prod).
            withIsActive(true).
            build();
        insert pbe;

		Configuracion_BMX__c testConfiguracionBMX = Build.aConfiguracionBMX().
            withPMSafraActualA1('18/19').
            build();
        insert testConfiguracionBMX;

		Saldo_por_safra__c saldoPorSafra = Build.aSaldoPorSafra().
		withAccount(acc).
		withSafra('18/19').

		build();
		insert saldoPorSafra;

		Opportunity opp = Build.anOpportunityAnexoIII().withSafra('18/19').withAccountId(acc).withPricebook2Id(Test.getStandardPricebookId()).build();
		insert opp;

		List<OpportunityLineItem> items = new List<OpportunityLineItem>();
		for(Integer i = 0; i < 10; i++) {
			OpportunityLineItem item = new OpportunityLineItem();
			item.OpportunityId = opp.Id;
			item.Quantity = 10;
			item.Product2Id = prod.Id;
			item.Descuento__c = 10;
			item.TotalPrice = item.Quantity * prod.Price__c;
			item.PricebookEntryId = pbe.Id;
			items.add(item);
		}
		insert items;
		opp.StageName = 'Aprobada';
		update opp;
	}

	@IsTest
	public static void eventoRoyaltyRestaSaldo() {
		Evento_Royalty__c evento = new Evento_Royalty__c();
		evento.Cuenta__c = [SELECT Id FROM Account].Id;
		evento.Saldo_por_safra__c = [SELECT Id FROM Saldo_por_safra__c].Id;
		evento.Safra__c = '18/19';
		evento.Data__c = '22/01/2020';
		evento.Items__c = 'Placas';
		evento.Valor__c = 1000.00;
		evento.Estado__c = 'Aprobado';


		Test.startTest();
		insert evento;
		Test.stopTest();

		Saldo_por_safra__c saldo = [SELECT Id,Saldo__c, Saldo_Disponible__c, Saldo_Gastado__c 
									FROM Saldo_por_safra__c];

		System.assertEquals(evento.Valor__c, saldo.Saldo_Gastado__c);
	}

	@IsTest
	public static void eventoRoyaltiesRestaSaldo() {
		List<Evento_Royalty__c> eventos = new List<Evento_Royalty__c>();
		Double total = 0;
		for(Integer i = 0; i < 3; i++) {
			Evento_Royalty__c evento = new Evento_Royalty__c();
			evento.Cuenta__c = [SELECT Id FROM Account].Id;
			evento.Saldo_por_safra__c = [SELECT Id FROM Saldo_por_safra__c].Id;
			evento.Safra__c = '18/19';
			evento.Data__c = '22/01/2020';
			evento.Items__c = 'Placas';
			evento.Valor__c = 1000.00;
			evento.Estado__c = 'Aprobado';
			total += evento.Valor__c;
			eventos.add(evento);
		}

		Test.startTest();
		insert eventos;
		Test.stopTest();

		Saldo_por_safra__c saldo = [SELECT Id,Saldo__c, Saldo_Disponible__c, Saldo_Gastado__c 
									FROM Saldo_por_safra__c];

		System.assertEquals(total, saldo.Saldo_Gastado__c);
	}

	@IsTest
	public static void revisarSaldoPorEventoPendiente() {
		Evento_Royalty__c evento = new Evento_Royalty__c();
		evento.Cuenta__c = [SELECT Id FROM Account].Id;
		evento.Saldo_por_safra__c = [SELECT Id FROM Saldo_por_safra__c].Id;
		evento.Safra__c = '18/19';
		evento.Data__c = '22/01/2020';
		evento.Items__c = 'Placas';
		evento.Valor__c = 1000.00;
		evento.Estado__c = 'Pendiente de aprobación';
		
		insert evento;
		
		Evento_Royalty__c evento2 = new Evento_Royalty__c();
		evento2.Cuenta__c = [SELECT Id FROM Account].Id;
		evento2.Saldo_por_safra__c = [SELECT Id FROM Saldo_por_safra__c].Id;
		evento2.Safra__c = '18/19';
		evento2.Data__c = '22/01/2020';
		evento2.Items__c = 'Placas';
		evento2.Valor__c = 1000.00;
		evento2.Estado__c = 'Pendiente de aprobación';

		Test.startTest();

		try {
			insert evento2;
		}
		catch(Exception e) {
			System.debug(e.getMessage());
		}

		Test.stopTest();

		List<Evento_Royalty__c> eventos = [SELECT Id FROM Evento_Royalty__c];
		System.assertEquals(1, eventos.size(), 'No deberia insertarse el segundo evento');

	}

	// @IsTest
	// public static void siSeApruebaEventoRoyalty_llamaAsyncCrearFacturaSoap() {
	// 	//Inicialización y carga de datos
	// 	Evento_Royalty__c evento = new Evento_Royalty__c();
	// 	evento.Cuenta__c = [SELECT Id FROM Account].Id;
	// 	evento.Saldo_por_safra__c = [SELECT Id FROM Saldo_por_safra__c].Id;
	// 	evento.Safra__c = '18/19';
	// 	evento.Data__c = '22/01/2020';
	// 	evento.Items__c = 'Placas';
	// 	evento.Valor__c = 1000.00;
	// 	evento.Estado__c = 'Aprobado';

	// 	//Test
	// 	Test.startTest();
	// 	insert evento;
	// 	Test.stopTest();

	// 	//ASSERTS
	// 	evento = [
	// 		SELECT Resposta_SAP__c,Enviado_para_SAP__c 
	// 		FROM Evento_Royalty__c 
	// 		WHERE Id = :evento.id
	// 	];
	// 	System.assertEquals( 1 , EventoRoyaltyTriggerHelper.cantLlamadas );
	// 	System.assertEquals( 'Mock response' , evento.Resposta_SAP__c);
	// 	System.assertEquals( true , evento.Enviado_para_SAP__c);
		
	// }
}
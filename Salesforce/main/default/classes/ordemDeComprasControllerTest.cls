@isTest
public class ordemDeComprasControllerTest{
	@TestSetup
	static void setup(){
		Account acc = new Account();
		acc.Name = 'ASOCIADOS DON MARIO S.A.';
		insert acc;


		Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
		insert pb;
		Product2 prod = new Product2(Name = 'SLA: Bronze', IsActive = true);
		insert prod;
		// First insert a price for the standard price book
		Pricebook2 standardPB = new Pricebook2(id = Test.getStandardPricebookId(),isActive = true);

		PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
		insert standardPBE;
		PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
		insert pbe;

		Order o = new Order();
		o.Name = 'Test order';
		o.Numero_Pedido_sap__c = '123';
		o.AccountId = acc.id;
		o.EffectiveDate = System.today();
		o.Status = 'Edição';
		o.Pricebook2Id = standardPB.id;
		insert o;

		OrderItem oItem = new OrderItem();
		oItem.OrderId = o.id;
		oItem.Quantity = 1;
		oItem.PricebookEntryId = standardPBE.id;
		oItem.UnitPrice = 10;
		insert oItem;
	}

	@isTest
	private static void consultaSapControllerWithOldOrderTestError(){
		Id ordId = [SELECT id
		            FROM Order].id;

		test.startTest();
		String response = ordemDeCompraController.consultaSapControllerWithOldOrder(ordId);
		test.stopTest();

		System.assertEquals('Já existe um pedido em edição. Ative o antigo para criar um novo.', response);
	}

	@isTest
	private static void consultaSapControllerWithOldOrderTest(){
		Order o = [SELECT id, Status
		           FROM Order];
		o.Status = 'Activated';
		update o;

		test.startTest();
		Id response = ordemDeCompraController.consultaSapControllerWithOldOrder(o.id);
		test.stopTest();

		//System.assertEquals(o.id, response);
	}
}
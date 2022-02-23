@IsTest
public class ItensResumoDaContaExtensionTest {
 
    //Unit test

    @IsTest
    private static void addItem() {

        Resumo_da_conta__c crmTest = [SELECT Id FROM Resumo_da_conta__c];
        ApexPages.StandardController sc = new ApexPages.StandardController(crmTest);
        ItensResumoDaContaExtension controller = new ItensResumoDaContaExtension(sc);
        controller.getObtentores();
        
        Test.startTest();
            controller.toAdd = 'ADVANTA';
            controller.addToItemsAlreadySelected();
        Test.stopTest();

        system.assertEquals(2, controller.itemsAlreadySelected.size());

    }

    @IsTest
    private static void removeItem() {

        Resumo_da_conta__c crmTest = [SELECT Id FROM Resumo_da_conta__c];
        ApexPages.StandardController sc = new ApexPages.StandardController(crmTest);
        ItensResumoDaContaExtension controller = new ItensResumoDaContaExtension(sc);
        controller.getObtentores();
        controller.toAdd = 'ADVANTA';
        controller.addToItemsAlreadySelected();
        controller.toAdd = 'Agroeste';
        controller.addToItemsAlreadySelected();
        
        Test.startTest();
            controller.toRemove = '0'; //se borra el que se inserto en el setUp asi recorre la linea de agregar a la lista de Delete.
            controller.removeFromItemsAlreadySelected();
        Test.stopTest();

        system.assertEquals(2, controller.itemsAlreadySelected.size());

    }

    //Integratio test

    @IsTest
    private static void saveCRMWithTwoNewItemsAndDeletingExistingItem() {

        Resumo_da_conta__c crmTest = [SELECT Id FROM Resumo_da_conta__c];
        ApexPages.StandardController sc = new ApexPages.StandardController(crmTest);
        ItensResumoDaContaExtension controller = new ItensResumoDaContaExtension(sc);
        controller.getObtentores();
        controller.toAdd = 'ADVANTA';
        controller.addToItemsAlreadySelected();
        controller.toAdd = 'Agroeste';
        controller.addToItemsAlreadySelected();
        controller.toRemove = '0'; //se borra el que se inserto en el setUp asi recorre la linea de agregar a la lista de Delete.
        controller.removeFromItemsAlreadySelected();

        Test.startTest();                      
            controller.save();    
        Test.stopTest();

        List<Item_de_resumo_da_conta__c> itemsDelCrm = [SELECT Id, Obtentor__c FROM Item_de_resumo_da_conta__c WHERE resumo_da_conta__c = :crmTest.id];
        system.assertEquals(2, itemsDelCrm.size());

    }

    @TestSetup
	private static void IsTheSetup() {

        Profile profileIdSupervisor = [SELECT Id FROM Profile WHERE Name = 'Supervisor Administrativo' LIMIT 1];
		Profile profileIdGerente = [SELECT Id FROM Profile WHERE Name = 'Gerente Administrativo' LIMIT 1];

		User supervisor = new User(
		                           LastName = 'Rosa',
		                           FirstName = 'Jorge Cristiano',
		                           Alias = 'jcr',
		                           Email = 'jorge.rosa@asdf.com',
		                           Username = 'jorge.rosa@asdf.com',
		                           ProfileId = profileIdSupervisor.id,
		                           TimeZoneSidKey = 'GMT',
		                           LanguageLocaleKey = 'en_US',
		                           EmailEncodingKey = 'UTF-8',
		                           LocaleSidKey = 'en_US'
		);

		User gerente = new User(
		                        LastName = 'Bertagnolli',
		                        FirstName = 'Sergio Vieira',
		                        Alias = 'svb',
		                        Email = 'sergio.bertagnolli@asdf.com',
		                        Username = 'sergio.bertagnolli@asdf.com',
		                        ProfileId = profileIdGerente.id,
		                        TimeZoneSidKey = 'GMT',
		                        LanguageLocaleKey = 'en_US',
		                        EmailEncodingKey = 'UTF-8',
		                        LocaleSidKey = 'en_US'
		);

		List<User> users = new List<User> {
			supervisor, gerente
		};
		insert users;

		Account testAccount = Build.anAccount()
			.withName('Test account')
			.withType('Multiplicador')
			.withMarca('BRMX')
			.withSupervisor(supervisor)
			.withGerenteComercial(gerente)
			.build();
        insert testAccount;
        
        Resumo_da_conta__c crmTest = new Resumo_da_conta__c(
            Multiplicador__c = testAccount.id,
            Safra__c = '19/20',
            Marca__c = 'BRMX'
        );
        insert crmTest;

        Item_de_resumo_da_conta__c newItem = new Item_de_resumo_da_conta__c(
            Resumo_da_conta__c = crmTest.id,
            Obtentor__c = 'Brasmax'
        );
        Insert newItem;

    }

}
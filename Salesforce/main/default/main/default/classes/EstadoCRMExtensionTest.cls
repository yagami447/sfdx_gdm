@IsTest
public class EstadoCRMExtensionTest {
   
    //Unit test

    @IsTest
    private static void addEstado() {

        Resumo_da_conta__c crmTest = [SELECT Id FROM Resumo_da_conta__c];
        ApexPages.StandardController sc = new ApexPages.StandardController(crmTest);
        EstadoCRMExtension controller = new EstadoCRMExtension(sc);
        controller.getEstados();
        
        Test.startTest();
            controller.toAdd = 'Acre (AC)';
            controller.addToEstadosAlreadySelected();
        Test.stopTest();

        system.assertEquals(2, controller.estadosAlreadySelected.size());

    }

    @IsTest
    private static void removeEstado() {

        Resumo_da_conta__c crmTest = [SELECT Id FROM Resumo_da_conta__c];
        ApexPages.StandardController sc = new ApexPages.StandardController(crmTest);
        EstadoCRMExtension controller = new EstadoCRMExtension(sc);
        controller.getEstados();
        controller.toAdd = 'Acre (AC)';
        controller.addToEstadosAlreadySelected();
        controller.toAdd = 'Alagoas (AL)';
        controller.addToEstadosAlreadySelected();
        
        Test.startTest();
            controller.toRemove = '0'; //se borra el que se inserto en el setUp asi recorre la linea de agregar a la lista de Delete.
            controller.removeFromEstadosAlreadySelected();
        Test.stopTest();

        system.assertEquals(2, controller.estadosAlreadySelected.size());

    }

    @IsTest
    private static void trySavingWithoutPercentageTotal() {

        Resumo_da_conta__c crmTest = [SELECT Id FROM Resumo_da_conta__c];
        ApexPages.StandardController sc = new ApexPages.StandardController(crmTest);
        EstadoCRMExtension controller = new EstadoCRMExtension(sc);
        controller.getEstados();
        controller.toAdd = 'Acre (AC)';
        controller.addToEstadosAlreadySelected();
        controller.toAdd = 'Alagoas (AL)';
        controller.addToEstadosAlreadySelected();
        controller.toRemove = '0'; //se borra el que se inserto en el setUp asi recorre la linea de agregar a la lista de Delete.
        controller.removeFromEstadosAlreadySelected();

        Test.startTest();
            controller.save();    
        Test.stopTest();

        List<Estado_Para_CRM__c> estadosDelCRM = [SELECT Id, Name, Estado__c, Percentagem_de_venda__c, Indice__c FROM Estado_Para_CRM__c WHERE CRM__c = :crmTest.id];
        system.assertEquals(1, estadosDelCRM.size()); //Como borre el unico estado que tenia cargado un porcentaje, ahora el control de que 'la totalidad del porcentaje debe sumar 100%' salta y no permite guardar
        system.assertEquals('Mato Grosso (MT)', estadosDelCRM[0].Estado__c);// por lo que sigo teniendo un solo estado y es el que venia ya cargado con el CRM.

    }

    //Integratio test

    @IsTest
    private static void saveCRMWithTwoNewEstadosAndDeletingExistingEstado() {

        Resumo_da_conta__c crmTest = [SELECT Id FROM Resumo_da_conta__c];
        ApexPages.StandardController sc = new ApexPages.StandardController(crmTest);
        EstadoCRMExtension controller = new EstadoCRMExtension(sc);
        controller.getEstados();
        controller.toAdd = 'Acre (AC)';
        controller.addToEstadosAlreadySelected();
        controller.toAdd = 'Alagoas (AL)';
        controller.addToEstadosAlreadySelected();
        controller.toRemove = '0'; //se borra el que se inserto en el setUp asi recorre la linea de agregar a la lista de Delete.
        controller.removeFromEstadosAlreadySelected();

        Test.startTest();
            for(Estado_Para_CRM__c estado : controller.estadosAlreadySelected.values()){
                estado.Percentagem_de_venda__c = 50;
            }            
            controller.save();    
        Test.stopTest();

        List<Estado_Para_CRM__c> estadosDelCRM = [SELECT Id, Name, Estado__c, Percentagem_de_venda__c, Indice__c FROM Estado_Para_CRM__c WHERE CRM__c = :crmTest.id];
        system.assertEquals(2, estadosDelCRM.size()); //Se guardaron los dos estados agregados y se borro el que ya existia con el CRM.

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

        Estado_Para_CRM__c newEstadoCRMTest = new Estado_Para_CRM__c (
            CRM__c = crmTest.id,
            Estado__c = 'Mato Grosso (MT)',
            Percentagem_de_venda__c = 100
        );
        insert newEstadoCRMTest;

    }
    
}
@IsTest
public class ContactsForSignatureControllerTest {
    
    //Unit Test

    @IsTest
    private static void getTwoContactsButOneCheck(){
        
        Contrato__c contract = [SELECT Id FROM Contrato__c LIMIT 1];
        List<ContactsForSignatureController.wrapSigner> signers = ContactsForSignatureController.getContacts(contract.Id);        
        Integer count = 0;
        for(ContactsForSignatureController.wrapSigner signer : signers){
            if(signer.check){
                count++;
            }
        }
        System.assertEquals(2, signers.size()); // cantidad de contactos en lista
        System.assertEquals(1, count); //cantidad de signers con contactos

    }

    //Integration Test

    //Test Setup
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
        
        Contact contacto = new Contact(
            FirstName = 'Test',
            LastName = 'Signers',
            AccountId = testAccount.id
        );
        insert contacto;

        Contact contacto1 = new Contact(
            FirstName = 'Test1',
            LastName = 'Signers1',
            AccountId = testAccount.id
        );
        insert contacto1;

		Contrato__c contract = new Contrato__c(
			Multiplicador__c = testAccount.Id
		);
		insert contract;

        Signatario__c signers = new Signatario__c(
            Contacto__c = contacto.Id,
            Contrato_de_Multiplicacao__c = contract.Id
        );
        insert signers;

	}	

}
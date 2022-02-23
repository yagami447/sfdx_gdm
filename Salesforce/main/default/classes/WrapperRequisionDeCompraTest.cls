@IsTest
public class WrapperRequisionDeCompraTest {

	@IsTest
	public static void SetConstructorVarietyTypeReq() {
		// la cobertura a este test esta dada en la clase RequisicaoTreeControllerTest, igualmente se debe corregir esta clase y darle cobertura apropiadamente.
	}
    

    @TestSetup
	private static void IsTheSetup() {

        Profile profileIdSupervisor = [SELECT Id FROM Profile WHERE Name = 'Supervisor Administrativo' LIMIT 1];
        Profile profileIdGerente = [SELECT Id FROM Profile WHERE Name = 'Gerente Administrativo' LIMIT 1];    

        User gerente = new User(
            LastName = 'Rosa Gerente',
            FirstName = 'Jorge Cristiano Gerente',
            Alias = 'Gerente',
            Email = 'jorge.rosa.gerente@asdf.com',
            Username = 'jorge.rosa.gerente@asdf.com',
            ProfileId = profileIdGerente.id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US',
            IsActive = true,
            Codigo_SAP__c = '062'
        );        
        insert gerente;
        
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
            LocaleSidKey = 'en_US',
            IsActive = true,
            Codigo_SAP__c = '061',
            ManagerId = gerente.id
        );        
        insert supervisor;
       
         Account testAccountSupervisor = Build.anAccount()
            .withName('Test account supervisor')
            .withType('Supervisor')
            .withMarca('BRMX')		
            .withGerenteComercial(gerente)
            .withResponsavel('061 - Fernando Frehner')
            .build();
        insert testAccountSupervisor;   
        
        Account testAccount = Build.anAccount()
			.withName('Test account')
			.withType('Multiplicador')
			.withMarca('BRMX')
            .withSupervisor(supervisor)
            .withGerenteComercial(gerente)
            .withResponsavel('061 - Fernando Frehner')
			.build();
        insert testAccount;        
        
        Atributo_venda_de_basica__mdt allocation = [
            SELECT id, Nome_de_usu_rio_atribu_do__c, Usuario_gerente__c	
            FROM Atributo_venda_de_basica__mdt
            WHERE  Regi_o__c = 'REGION 1'
            AND  Marca__c= 'BRMX'
            LIMIT 1
        ];
        
        allocation.Nome_de_usu_rio_atribu_do__c = 'jorge.rosa@asdf.com';
		allocation.Usuario_gerente__c = 'jorge.rosa.gerente@asdf.com';
        
        User u = [
            SELECT Id FROM User WHERE UserName =  :allocation.Usuario_gerente__c LIMIT 1
        ];
      
        User us = [
            SELECT Id FROM User WHERE UserName =  :allocation.Nome_de_usu_rio_atribu_do__c LIMIT 1
        ];           

		Requisicao_de_compra__c requisitionChild1 = Build.aRequisicaoDeCompra()
			.withTipo('Multiplicador')
			.withSafra('19/20')
			.withRegiao('REGION 1')
			.withMarca('BRMX')
			.withEstado('Pendente')
			//.withOwner(testAccount.id)
			.build();
		requisitionChild1.Aprovador__c = supervisor.Id;
		requisitionChild1.Multiplicador__c = testAccount.id;
		insert requisitionChild1;

        Variedad__c variety1 = new Variedad__c(Name = 'Variedad1', Regiao_disponivel_para_venda_basica__c = 'REGION 1', Disponivel_para_venda_basica__c = true, Marca_comercial__c = 'Brasmax');
        insert variety1;

        Variedad__c variety2 = new Variedad__c(Name = 'variedad2', Regiao_disponivel_para_venda_basica__c = 'REGION 1', Disponivel_para_venda_basica__c = true, Marca_comercial__c = 'Brasmax');
        insert variety2;

        Produto_de_requisicao__c product1 = new Produto_de_requisicao__c(
																			Name = 'Producto1',
																			Requisicao_de_compra__c = requisitionChild1.Id,
																			Quantidade__c = 60,
																			Variedad__c = variety1.Id
		);
		insert product1;

        Produto_de_requisicao__c product2 = new Produto_de_requisicao__c(
																			Name = 'Producto2',
																			Requisicao_de_compra__c = requisitionChild1.Id,
																			Quantidade__c = 40,
																			Variedad__c = variety2.Id
		);
		insert product2;
                
    }
}
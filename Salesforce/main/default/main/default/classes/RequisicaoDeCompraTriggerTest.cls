@IsTest 
public class RequisicaoDeCompraTriggerTest {
    
    @IsTest
    public static void insertoUnaEstimativaMultiplicadorYSiExistenLosSuperioresSeDebeVincularAEllos() {

        Id sojaRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByDeveloperName().get('Soja').getRecordTypeId();
        
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
            SELECT id, Nome_de_usu_rio_atribu_do__c, Usuario_gerente__c, Usuario_Gerente_de_Marca__c
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
        
        Requisicao_de_compra__c multiplicadorReq = Build.aRequisicaoDeCompra()
            .withTipo('Multiplicador')
            .withSafra('19/20')
            .withRegiao('REGION 1')
            .withMarca('BRMX')
            .withEstado('Pendente')
            .build();
        multiplicadorReq.Aprovador__c = supervisor.Id;
        multiplicadorReq.OwnerId = UserInfo.getUserId();
        multiplicadorReq.Multiplicador__c = testAccount.id;
        multiplicadorReq.RecordTypeId = sojaRecordType;
        
        Test.startTest();
        	insert multiplicadorReq;
        Test.stopTest();
        
        List<Requisicao_de_compra__c> requerimientos = [SELECT Id, Owner.UserName, Requisicao_de_compra__r.Owner.UserName, Requisicao_de_compra__c , Tipo__c
                                                       FROM Requisicao_de_compra__c];
        List<Requisicao_de_compra__c> reqMultiplicador = [SELECT Id, Owner.UserName, Requisicao_de_compra__r.Owner.UserName, Requisicao_de_compra__c , Tipo__c
                                                    FROM Requisicao_de_compra__c
                                                   	WHERE Tipo__c = 'Multiplicador'];
        List<Requisicao_de_compra__c> reqSupervisor = [SELECT Id, Owner.UserName, Requisicao_de_compra__r.Owner.UserName, Requisicao_de_compra__c , Tipo__c
                                                    FROM Requisicao_de_compra__c
                                                   	WHERE Tipo__c = 'Supervisor'];
   
        System.assertEquals(3, requerimientos.size());
        System.assertEquals(1, reqSupervisor.size());
        System.assertEquals(reqMultiplicador[0].Requisicao_de_compra__c, reqSupervisor[0].Id);
        
    }
    
    @IsTest
    public static void insertoUnaEstimativaMultiplicadorYSiNoExistenLosSuperioresSeDebenCrear() {

        Id sojaRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByDeveloperName().get('Soja').getRecordTypeId();
        
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
        
        Requisicao_de_compra__c multiplicadorReq = Build.aRequisicaoDeCompra()
            .withTipo('Multiplicador')
            .withSafra('19/20')
            .withRegiao('REGION 1')
            .withMarca('BRMX')
            .withEstado('Pendente')
            .build();
        multiplicadorReq.Aprovador__c = supervisor.Id;
        multiplicadorReq.OwnerId = supervisor.Id;
        multiplicadorReq.Multiplicador__c = testAccount.id;
        multiplicadorReq.RecordTypeId = sojaRecordType;
        
        Test.startTest();
        	insert multiplicadorReq;
        Test.stopTest();
        
        List<Requisicao_de_compra__c> requerimientos = [SELECT Id, Owner.UserName, Requisicao_de_compra__r.Owner.UserName, Requisicao_de_compra__c , Tipo__c
                                                       FROM Requisicao_de_compra__c];
        Requisicao_de_compra__c reqMultiplicador = [SELECT Id, Owner.UserName, Requisicao_de_compra__r.Owner.UserName, Requisicao_de_compra__c , Tipo__c
                                                    FROM Requisicao_de_compra__c
                                                   	WHERE Tipo__c = 'Multiplicador'];
        Requisicao_de_compra__c reqSupervisor = [SELECT Id, OwnerId, Owner.UserName, Requisicao_de_compra__r.Owner.UserName, Requisicao_de_compra__c , Tipo__c
                                                    FROM Requisicao_de_compra__c
                                                   	WHERE Tipo__c = 'Supervisor'];
        // Requisicao_de_compra__c reqGerente = [SELECT Id, OwnerId, Owner.UserName, Requisicao_de_compra__r.Owner.UserName, Requisicao_de_compra__c , Tipo__c
        //                                             FROM Requisicao_de_compra__c
        //                                            	WHERE Tipo__c = 'Gerente Comercial'];
   
        System.assertEquals(3, requerimientos.size());
        System.assertEquals(supervisor.id, reqSupervisor.OwnerId);
        // System.assertEquals(gerente.id, reqGerente.OwnerId);
                
    }
	
    @IsTest
    public static void coberturaDesesperada() {
        
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
        
        Negocio_por_Conta__c negocio = new Negocio_por_Conta__c(
        	Conta__c = testAccount.Id,
            Cultura__c = 'MILHO',
            Marca__c = 'BRMX',
            Name = 'Negocio Test',
            Region_Comercial__c = 'REGION 1',
            Supervidor__c = supervisor.Id        
        );
        insert negocio;
        
        Id milhoRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByDeveloperName().get('Milho').getRecordTypeId();
        Requisicao_de_compra__c multiplicadorReq = Build.aRequisicaoDeCompra()
            .withTipo('Multiplicador')
            .withSafra('19/20')
            .withRegiao('REGION 1')
            .withMarca('BRMX')
            .withEstado('Pendente')
            //.withOwner(testAccount.id)
            .build();
        multiplicadorReq.Aprovador__c = supervisor.Id;
        multiplicadorReq.OwnerId = supervisor.Id;
        multiplicadorReq.Multiplicador__c = testAccount.id;
        multiplicadorReq.RecordTypeId = milhoRecordType;
        multiplicadorReq.Negocio__c = negocio.Id;
        
        Test.startTest();
        	insert multiplicadorReq;
        Test.stopTest();
                
    }
    
}
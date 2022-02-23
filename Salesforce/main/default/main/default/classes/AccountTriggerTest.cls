@IsTest
public class AccountTriggerTest {
    
	@IsTest
    public static void insertAccountsTrhoughCargarSupervisorYGerenteComerciaHelperlMethod(){
        Account acc = Build.anAccount()
            .withName('testaccount')
            .withCNPJCPF('testcnpjcpf')
            .withGrupodeCuentas('CMEX')
            .withResponsavel('061 - Fernando Frehner')
            .build();

        Test.startTest();
        insert acc;
        Test.stopTest();

        System.assertEquals(
            [select Supervisor__c from Account where Id=:acc.Id].Supervisor__c,
            [select Id from User where Nombre_De_Lista_Respons_vel_BRMX__c='061 - Fernando Frehner'].Id,
            'The Supervisor was not assign properly');
        
        System.assertEquals(
            [select Gerente_comercial__c from Account where Id=:acc.Id].Gerente_comercial__c,
            [select DelegatedApproverId from User where Nombre_De_Lista_Respons_vel_BRMX__c='061 - Fernando Frehner'].DelegatedApproverId,
            'The Gerente Comercial was not assign properly');
    }

    @IsTest
    public static void siSeActualizaUnaCuenta_ySiTieneresponsableBRMX_CargaCamposSupervisorYGerente(){
        //Inicialización y carga de datos
        Account acc = Build.anAccount()
            .withName('testaccount')
            .withCNPJCPF('testcnpjcpf')
            .withGrupodeCuentas('CMEX')
            .withResponsavel('061 - Fernando Frehner')
            .build();
        insert acc;

        acc = [
            SELECT Id,Responsavel__c
            FROM Account
            WHERE Id = : acc.id
        ];

        acc.Responsavel__c = '066 - Marcelo Steffen';
    
        //Test
        Test.startTest();
        update acc;
        Test.stopTest();
        //ASSERTS
        System.assertEquals(
            [select Supervisor__c from Account where Id=:acc.Id].Supervisor__c,
            [select Id from User where Nombre_De_Lista_Respons_vel_BRMX__c='066 - Marcelo Steffen'].Id,
            'The Supervisor was not assign properly');
        
        System.assertEquals(
            [select Gerente_comercial__c from Account where Id=:acc.Id].Gerente_comercial__c,
            [select DelegatedApproverId from User where Nombre_De_Lista_Respons_vel_BRMX__c='066 - Marcelo Steffen'].DelegatedApproverId,
            'The Gerente Comercial was not assign properly');
    }

    // @IsTest
    // public static void siSeActualizaUnaCuenta_ySiTieneresponsableBRMX_ActualizaSUpervisorYgerenteEnEventoRoyalty(){
    //     //Inicialización y carga de datos
    //     Account acc = Build.anAccount()
    //         .withName('testaccount')
    //         .withCNPJCPF('testcnpjcpf')
    //         .withGrupodeCuentas('CMEX')
    //         .withResponsavel('061 - Fernando Frehner')
    //         .build();
    //     insert acc;

    //     Saldo_por_safra__c safra = new Saldo_por_safra__c(
    //         name = 'Test safra',
    //         Account__c = acc.id,
    //         Safra__c = '123'
    //     );
    //     insert safra;

    //     Evento_Royalty__c eventRoyalty = new Evento_Royalty__c(
    //         Name = 'Test',
    //         Cuenta__c = acc.id,
    //         Saldo_por_safra__c = safra.id
    //     );
    //     insert eventRoyalty;
    //     System.debug('Esta cosa: '+[SELECT Supervisor__c,Gerente_comercial__c FROM Evento_Royalty__c]);
    //     acc = [
    //         SELECT Id,Responsavel__c
    //         FROM Account
    //         WHERE Id = : acc.id
    //     ];

    //     acc.Responsavel__c = '066 - Marcelo Steffen';
    
    //     //Test
    //     Test.startTest();
    //     update acc;
    //     Test.stopTest();
    //     //ASSERTS
    //     System.assertEquals(
    //         [select Supervisor__c from Evento_Royalty__c where Cuenta__c=:acc.Id].Supervisor__c,
    //         [select Id from User where Nombre_De_Lista_Respons_vel_BRMX__c='066 - Marcelo Steffen'].Id,
    //         'The Supervisor was not assign properly');
        
    //     System.assertEquals(
    //         [select Gerente_comercial__c from Evento_Royalty__c where Cuenta__c=:acc.Id].Gerente_comercial__c,
    //         [select DelegatedApproverId from User where Nombre_De_Lista_Respons_vel_BRMX__c='066 - Marcelo Steffen'].DelegatedApproverId,
    //         'The Gerente Comercial was not assign properly');
    // }
}
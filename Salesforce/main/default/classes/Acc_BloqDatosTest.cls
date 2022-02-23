@isTest(SeeAllData=true)
private class Acc_BloqDatosTest {

    @isTest static void test() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Account account = [SELECT Id FROM Account WHERE Name = 'ACME'];
        
        Acc_BloqDatos.FC_Bloq_Dest(contact.Id, 110);
        Acc_BloqDatos.FC_Desbloq_Dest(contact.Id);
        Acc_BloqDatos.atualizar_Supervisor(account.Id);
    }
}
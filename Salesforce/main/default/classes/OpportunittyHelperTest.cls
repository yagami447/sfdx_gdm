@isTest
public class OpportunittyHelperTest {
    @isTest
    public static void createAnOpportunityWithCooperante() {
        List<Account> accList = new List<Account>();
        Account anAccount = Build.anAccountCuenta().withName('Una cuenta').build();
        Account anAccountC = Build.anAccountCuenta().withName('Una cuenta Coop').build();
        accList.add(anAccount);
        accList.add(anAccountC);
        insert accList;
        Cooperante__c aCooperante = new Cooperante__c(
            Cuenta__c = accList[0].Id,
            CuentaCoop__c = accList[1].Id,
            Name = accList[1].Name
        );
        insert aCooperante;
        Opportunity testOpp = Build.anOpportunityAnexoI().withAccountId(accList[0]).build();
        testOpp.Cooperante2__c = aCooperante.Id;
        
        Test.startTest();
        insert testOpp;
        Test.stopTest();

        Opportunity resultOpp = [
            SELECT Cooperante__c
            FROM Opportunity
            LIMIT 1
        ];

        System.assertEquals(accList[1].Id, resultOpp.Cooperante__c, 'La Id no es la esperada');
    }

    @isTest
    public static void updateAnOpportunityWithCooperante() {
        List<Account> accList = new List<Account>();
        Account anAccount = Build.anAccountCuenta().withName('Una cuenta').build();
        Account anAccountC = Build.anAccountCuenta().withName('Una cuenta Coop').build();
        accList.add(anAccount);
        accList.add(anAccountC);
        insert accList;

        Cooperante__c aCooperante = new Cooperante__c(
            Cuenta__c = accList[0].Id,
            CuentaCoop__c = accList[1].Id,
            Name = accList[1].Name
        );
        insert aCooperante;
        
        Opportunity testOpp = Build.anOpportunityAnexoI().withAccountId(accList[0]).build();
        insert testOpp;
        
        testOpp.Cooperante2__c = aCooperante.Id;
        
        Test.startTest();
        update testOpp;
        Test.stopTest();

        Opportunity resultOpp = [
            SELECT Cooperante2__c,Cooperante__c,Cooperante2__r.CuentaCoop__c
            FROM Opportunity
            LIMIT 1
        ];

        //System.assertEquals(resultOpp.Cooperante__c, resultOpp.Cooperante2__r.CuentaCoop__c, 'La Id no es la esperada');
    }
}
@IsTest
public class TestDAOConfiguracionBMX {
    @isTest
    public static void test(){
        Configuracion_BMX__c bmx = new Configuracion_BMX__c(Name = 'Test');
        insert bmx;
        DAOConfiguracionBMX.getInstance().getFirst();
        DAOConfiguracionBMX.getInstance(DTOUtils.SharingMode.Without).getFirst();
    }
}
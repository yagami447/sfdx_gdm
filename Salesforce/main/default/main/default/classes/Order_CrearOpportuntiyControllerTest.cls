@IsTest
public class Order_CrearOpportuntiyControllerTest {

    @TestSetup
    static void setupData() {
        Account accountForTest = Build.anAccount().build();
        insert accountForTest;

        Order orderForTest = build.anOrder().withAccountId(accountForTest).build();
        orderForTest.Status = 'Edição';
        insert orderForTest;

    }


    @IsTest
    private static void WhenInitTheComponet_GetTheDefautlValuesOfOrder() {

        Order orderForTest = [
            SELECT Id, AccountId
            FROM Order
            LIMIT 1
        ];

        RecordType recordTypeCVBPendiente = XappiaHelper.getRecordType('Opportunity', 'CVB_Pendiente');

        test.startTest();
        Order_CrearOpportuntiyController.DefaultValues result = Order_CrearOpportuntiyController.getDefaultValues(orderForTest.Id);
        test.stopTest();

        System.assertEquals(orderForTest.AccountId, result.order.AccountId);
        System.assertEquals(recordTypeCVBPendiente.Id, result.recordTypeId);

    }
}
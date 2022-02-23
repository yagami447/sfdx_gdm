public class Order_CrearOpportuntiyController {

    @AuraEnabled
    public static DefaultValues getDefaultValues(String recordId) {

        DefaultValues response = new DefaultValues();
        response.order = [
            SELECT Id, AccountId
            FROM Order
            WHERE Id = : recordId
            LIMIT 1
        ];
        response.recordTypeId = XappiaHelper.getRecordType('Opportunity','CVB_Pendiente').Id;
        return response;
    }

    public class DefaultValues {
        @AuraEnabled public Order order;
        @AuraEnabled public String recordTypeId;
    }
}
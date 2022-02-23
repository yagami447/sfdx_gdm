@isTest
public class TestDTOUtils {
    @istest public static void test(){     
        DTOUtils.RecordTypeInfo info = new DTOUtils.RecordTypeInfo();
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        info = new DTOUtils.RecordTypeInfo(RT.get(0));
    }
}
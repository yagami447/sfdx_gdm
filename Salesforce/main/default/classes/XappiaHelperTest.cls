@IsTest
private class XappiaHelperTest {
	@IsTest static void testItShouldReturnRightCuits() {
		System.assertEquals('27123412341',XappiaHelper.GenerateCUITFromDNI('12341234', false));
		System.assertEquals('23123412214',XappiaHelper.GenerateCUITFromDNI('12341221', false));
		System.assertEquals('20123412223',XappiaHelper.GenerateCUITFromDNI('12341222', true));
		System.assertEquals('20123411030',XappiaHelper.GenerateCUITFromDNI('12341103', true));
		System.assertEquals('23123411099',XappiaHelper.GenerateCUITFromDNI('12341109', true));
	}
	
	@IsTest static void testItShouldReturnNothingWhenDatesAreWrong() {
		System.assertEquals('', XappiaHelper.GenerateCUITFromDNI('',false));
		System.assertEquals('', XappiaHelper.GenerateCUITFromDNI('1234q341',false));
		System.assertEquals('', XappiaHelper.GenerateCUITFromDNI('54131234123',true));
		System.assertEquals('', XappiaHelper.GenerateCUITFromDNI('23-12341109a9',true));
		System.assertEquals('', XappiaHelper.GenerateCUITFromDNI(null,null));
	}

	@IsTest static void testCUITValidationGiveRightAnswers() {
		//right CUIT
		System.assertEquals(true,XappiaHelper.IsItValidCUIT('27123412341'));
		System.assertEquals(true,XappiaHelper.IsItValidCUIT('27-12341234-1'));
		System.assertEquals(true,XappiaHelper.IsItValidCUIT('23123412214'));
		System.assertEquals(true,XappiaHelper.IsItValidCUIT('20123412223'));
		System.assertEquals(true,XappiaHelper.IsItValidCUIT('20123411030'));
		System.assertEquals(true,XappiaHelper.IsItValidCUIT('23123411099'));
		//wrong CUIT
		System.assertEquals(false,XappiaHelper.IsItValidCUIT('1234123'));
		System.assertEquals(false,XappiaHelper.IsItValidCUIT(''));
		System.assertEquals(false,XappiaHelper.IsItValidCUIT('1234q341'));
		System.assertEquals(false,XappiaHelper.IsItValidCUIT('54131234123'));
		System.assertEquals(false,XappiaHelper.IsItValidCUIT('20-a123412223'));
		System.assertEquals(false,XappiaHelper.IsItValidCUIT(null));
	}

	@IsTest static void CBUValidtionGiveRightAnswers() {
		//right cbu
		System.assertEquals(XappiaHelper.isItValidCBU('2850590940090418135201'), true);
		System.assertEquals(XappiaHelper.isItValidCBU('2850100640094040123748'), true);
		System.assertEquals(XappiaHelper.isItValidCBU('0440053040000160557800'), true);
		System.assertEquals(XappiaHelper.isItValidCBU('0440024040000165916790'), true);
		System.assertEquals(XappiaHelper.isItValidCBU('044-0024-0400-0016-5916-790'), true);
		//wrong cbu
		System.assertEquals(XappiaHelper.isItValidCBU('0170099220000067797371'), false);
		System.assertEquals(XappiaHelper.isItValidCBU('0850100640094040123748'), false);
		System.assertEquals(XappiaHelper.isItValidCBU('0440053040002160557801'), false);
		System.assertEquals(XappiaHelper.isItValidCBU('04400530400021605'), false);
		System.assertEquals(XappiaHelper.isItValidCBU(null), false);
		System.assertEquals(XappiaHelper.isItValidCBU('044005304000216055A801'), false);
	}

	@IsTest static void testLuhnValidtionGiveRightAnswers() {
		//right Luhn code
		System.assertEquals(true, XappiaHelper.isItValidLuhnCode('4398728045218854'));
		System.assertEquals(true, XappiaHelper.isItValidLuhnCode('4667858768964691'));
		System.assertEquals(true, XappiaHelper.isItValidLuhnCode('5028276435949634'));
		System.assertEquals(true, XappiaHelper.isItValidLuhnCode('5980289411573076'));
		System.assertEquals(true, XappiaHelper.isItValidLuhnCode('4667858768964691'));
		System.assertEquals(true, XappiaHelper.isItValidLuhnCode('371449635398431'));
		//wrong Luhn code
		System.assertEquals(false, XappiaHelper.isItValidLuhnCode('0850100640094040123748'));
		System.assertEquals(false, XappiaHelper.isItValidLuhnCode('0876543210'));
		System.assertEquals(false, XappiaHelper.isItValidLuhnCode(''));
		System.assertEquals(false, XappiaHelper.isItValidLuhnCode(null));
		System.assertEquals(false, XappiaHelper.isItValidLuhnCode('6980289411573076'));
		System.assertEquals(false, XappiaHelper.isItValidLuhnCode('6980289411573076'));
	}

	@IsTest static void testNumericStringGiveRightAnswers() {
		System.assertEquals('1234',XappiaHelper.stringToNumericString('1234'));
		System.assertEquals('1234',XappiaHelper.stringToNumericString('x1a2a3-qw4'));
		System.assertEquals('',XappiaHelper.stringToNumericString('hello world!'));
		System.assertEquals('',XappiaHelper.stringToNumericString(''));
		System.assertEquals('',XappiaHelper.stringToNumericString(null));
	}

	@IsTest static void testGetRecordTypeReturnRecordTypeIfExist() {
		List<RecordType> rts = [
			SELECT id, DeveloperName,
				SobjectType
			FROM RecordType 
			LIMIT 1
		];        
		if (rts.size() > 0) {
			System.assertNotEquals(null, XappiaHelper.getRecordType(rts[0].sObjectType, rts[0].DeveloperName));
		}		
	}
    
	@IsTest static void testGetRecordTypeShouldNotUseQuery() {
		List<RecordType> rts = [
			SELECT id, DeveloperName,
				SobjectType
			FROM RecordType 
			LIMIT 1
		];
        System.debug(Limits.getQueries());
		if (rts.size() > 0) {
			System.assertNotEquals(null, XappiaHelper.getRecordType(rts[0].sObjectType, rts[0].DeveloperName));            
            XappiaHelper.getRecordType(rts[0].sObjectType, rts[0].DeveloperName);            
            System.assertEquals(1, Limits.getQueries());
		}		
	}    
    
	@IsTest static void testGetRecordTypeEncodedReturnRecordTypeIfExist() {
		List<RecordType> rts = [
			SELECT id, DeveloperName,
				SobjectType
			FROM RecordType 
			LIMIT 1
		];
		if (rts.size() > 0) {
			System.assertNotEquals(null, XappiaHelper.getRecordType(rts[0].sObjectType + '-' + rts[0].DeveloperName));
		}		
	}    
    
	@IsTest static void testGetRecordTypeEncodedReturnNullIfWasWrongEcnoded() {
		List<RecordType> rts = [
			SELECT id, DeveloperName,
				SobjectType
			FROM RecordType 
			LIMIT 1
		];
		if (rts.size() > 0) {
			System.assertEquals(null, XappiaHelper.getRecordType(rts[0].sObjectType + '!' + rts[0].DeveloperName));
		}		
	}        
    
	@IsTest static void testGetRecordTypeReturnNullIfRecordTypeIDoesntExist() {		
		System.assertEquals(null, XappiaHelper.getRecordType(',.!'  ,' '));
	}        
}
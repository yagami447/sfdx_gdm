@isTest
public with sharing class ResetAPITest {

    public static final String TESTACCTNAME = 'Test Account';
    public static final String TESTMARCA = 'NEOG';
    public static final String TESTSAFRA = '16/17';
    public static final String TESTCULTURA = 'Soja';
    
    @TestSetup
    static void makeData(){
       
        //create an account with valid Responavel_Neogen
        Account account = new Account( Name = TESTACCTNAME );

        // search active users for responsible fields
        Set<String> activeUserSet = new Set<String>();
        List<User> activeUserList = [SELECT Id, Name, Codigo_Sap__c FROM User WHERE Codigo_Sap__c != null AND User.IsActive = true];
        for(User activeUser : activeUserList) {
            activeUserSet.add(activeUser.Name);
        }

        //get Responsavel_Neogen picklist
		DescribeFieldResult responsavelNeogenField = Schema.Account.Responsavel_NEOGEN__c.getDescribe();
		List<Schema.PicklistEntry> picklistValues = responsavelNeogenField.getPickListValues();
        
        //sap codes list
        List<String> sapCodeList = new List<String>();
		for (Schema.PicklistEntry value : picklistValues) {
            String userName = value.getValue().split('-')[1].trim();
            if(value.isActive() && activeUserSet.contains(userName)) {
                account.Responsavel_NEOGEN__c = value.getValue();
                System.debug('Responsavel_Neogen__c: ' + value.getValue());
                break;
            }
		}
        
        insert account;

        Id recordTypeIdA1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo I').getRecordTypeId();
        Id recordTypeIdA2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Anexo II').getRecordTypeId();

        // Insert test Opportunities
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add( new Opportunity( Name = 'Test Opportunity A1',
                                            Accountid = account.Id,
                                            Cultura__C = TESTCULTURA,
                                            Marca__C = TESTMARCA,
                                            Safra__C = TESTSAFRA,
                                            RecordTypeId = recordTypeIdA1,
                                            StageName = 'Aprobada',
                                            CloseDate = system.Today()
                                        )
            );
        opportunities.add( new Opportunity( Name = 'Test Opportunity A2',
                                            Accountid = account.Id,
                                            Cultura__C = TESTCULTURA,
                                            Marca__C = TESTMARCA,
                                            Safra__C = TESTSAFRA,
                                            RecordTypeId = recordTypeIdA2,
                                            StageName = 'Aprobada',
                                            CloseDate = system.Today()
                                        )
            );

        insert opportunities;  
		
        // Insert Events
        List<CRM_Calendario_de_Eventos__c> events = new List<CRM_Calendario_de_Eventos__c>();
        events.add( new CRM_Calendario_de_Eventos__c(   Name = 'Test Event Palestra',
                                                        Cuenta__c = account.Id,
                                                        Marca__C = TESTMARCA,
                                                        Safra__C = TESTSAFRA,
                                                        Evento__c = 'Palestra',
                                                        Data_e_horario_inicio__c = System.today(),
                                                        Data_e_horario_termino__c = System.today().addDays(1)
                                                    )
            );
        events.add( new CRM_Calendario_de_Eventos__c(   Name = 'Test Event Treinamento',
                                                        Cuenta__c = account.Id,
                                                        Marca__C = TESTMARCA,
                                                        Safra__C = TESTSAFRA,
                                                        Evento__c = 'Treinamento',
                                                     	Data_e_horario_inicio__c = System.today(),
                                                        Data_e_horario_termino__c = System.today().addDays(1)
                                                    )
            );

        insert events;  


    }    
    
    @isTest
    public static void resetAccountOpportunitiesAndEventsTestPositive() {
        
        Account account = [SELECT Id FROM Account WHERE Name = :TESTACCTNAME LIMIT 1];

        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ResetAPI/';
        req.addParameter('accountId', account.Id);
        req.addParameter('marca', TESTMARCA);
        req.addParameter('safra', TESTSAFRA);
        req.addParameter('cultura', TESTCULTURA);  
        req.httpMethod = 'DELETE';

        RestContext.request = req;

        RestResponse resp = new RestResponse();
        RestContext.response = resp;

        test.startTest();
        ResetAPI.resetAccountOpportunitiesAndEvents();
        test.stopTest();
        
        ResetAPI.Response result = (ResetAPI.response)JSON.deserialize(resp.responseBody.toString(), ResetAPI.response.class);
      
        System.assertEquals(true, result.status);
        System.assertEquals(2, result.deletedOppIds.size());
        System.assertEquals(2, result.deletedCRMEventsIds.size());
    }
    
    @isTest
    public static void resetAccountOpportunitiesAndEventsTestNegative() {

        Account account = [SELECT Id FROM Account WHERE Name = :TESTACCTNAME LIMIT 1];
        
        RestRequest req = new RestRequest(); 
        req.requestURI = '/services/apexrest/ResetAPI/';
        req.addParameter('accountId', account.Id);
        req.addParameter('marca', 'BRMX');
        req.addParameter('safra', '18/19');
        req.addParameter('cultura', 'Milho');  
        req.httpMethod = 'DELETE';

		RestResponse resp = new RestResponse();

        RestContext.request = req;
        RestContext.response = resp;

        test.startTest();
        ResetAPI.resetAccountOpportunitiesAndEvents();
        test.stopTest();
        
        ResetAPI.Response result = (ResetAPI.response)JSON.deserialize(resp.responseBody.toString(), ResetAPI.response.class);
      
        System.assertEquals(false, result.status);
    }
}
@isTest
public with sharing class WSNFeTest {
    
    @testSetup static void setup() {
        Product2 prod = new Product2(Name='Generico Nota Fiscal');
        insert prod;
        
        PricebookEntry sPBE = new PricebookEntry(Pricebook2Id = test.getStandardPricebookId(), Product2Id = prod.id, UnitPrice = 1000);
        insert sPBE;
        
        
    }

    public static string MockToken(){
        return '{'+
		'    \"scope\": \"am_application_scope default\",'+
		'    \"token_type\": \"Bearer\",'+
		'    \"expires_in\": 3600,'+
		'    \"access_token\": \"e30d3ea4bada19ebd2b104ff5bcba599\"'+
		'}';
	}
    public static string MockNFe() {
        return'{'+
		'  \"nfeProc\": {'+
		'    \"protNFe\": {'+
		'      \"infProt\": {'+
		'        \"nProt\": 55455534534,'+
		'        \"digVal\": \"jfdgh76tr542786rteuhyfbwef8=\",'+
		'        \"dhRecbto\": \"2019-07-22T09:34:06-03:00\",'+
		'        \"Id\": \"Id445345345\",'+
		'        \"chNFe\": \"87878772\",'+
		'        \"xMotivo\": \"Autorizado o uso da NF-e\",'+
		'        \"cStat\": 100'+
		'      }'+
		'    },'+
		'    \"NFe\": {'+
		'      \"infNFe\": {'+
		'        \"infAdic\": {'+
		'          \"infCpl\": \"Lorem ipsum dolor...\",'+
		'          \"obsCont\": ['+
		'            {'+
		'              \"xCampo\": \"LEI DA TRANSPARENCIA\",'+
		'              \"xTexto\": \"O VALOR APROXIMADO DE TRIBUTOS INCIDENTES SOBRE O PRECO DESTE SERVICO E DE R$ 5.62 (16.06) FONTE: IBPT\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        \"det\": ['+
		'          {'+
		'            \"nItem\": 1,'+
		'            \"prod\": {'+
		'              \"cEAN\": \"SEM GTIN\",'+
		'              \"cProd\": \"JC59-00035A-SI\",'+
		'              \"qCom\": 1,'+
		'              \"cEANTrib\": \"SEM GTIN\",'+
		'              \"vUnTrib\": 265.79,'+
		'              \"qTrib\": 1,'+
		'              \"vProd\": 265.79,'+
		'              \"xProd\": \"UNIDADE DE DISCO RIGIDO 320GB\",'+
		'              \"vUnCom\": 265.79,'+
		'              \"indTot\": 1,'+
		'              \"uTrib\": \"UN\",'+
		'              \"NCM\": 84717012,'+
		'              \"uCom\": \"UN\",'+
		'              \"CFOP\": 5949,'+
		'              \"CEST\": 2103300,'+
		'              \"rastro\": ['+
		'                \"Item qualquer 1\",'+
		'                \"Item qualquer 2\"'+
		'              ]'+
		'            },'+
		'            \"imposto\": {'+
		'              \"ICMS\": {'+
		'                \"ICMS40\": {'+
		'                  \"orig\": 1,'+
		'                  \"CST\": 41'+
		'                }'+
		'              },'+
		'              \"IPI\": {'+
		'                \"IPINT\": {'+
		'                  \"CST\": 53'+
		'                },'+
		'                \"cEnq\": 999'+
		'              },'+
		'              \"COFINS\": {'+
		'                \"COFINSNT\": {'+
		'                  \"CST\": \"07\"'+
		'                }'+
		'              },'+
		'              \"PIS\": {'+
		'                \"PISNT\": {'+
		'                  \"CST\": \"07\"'+
		'                }'+
		'              }'+
		'            }'+
		'          }'+
		'        ],'+
		'        \"total\": {'+
		'          \"ICMSTot\": {'+
		'            \"vCOFINS\": 0,'+
		'            \"vBCST\": 0,'+
		'            \"vICMSDeson\": 0,'+
		'            \"vProd\": 265.79,'+
		'            \"vSeg\": 0,'+
		'            \"vFCP\": 0,'+
		'            \"vFCPST\": 0,'+
		'            \"vNF\": 265.79,'+
		'            \"vPIS\": 0,'+
		'            \"vIPIDevol\": 0,'+
		'            \"vBC\": 0,'+
		'            \"vST\": 0,'+
		'            \"vICMS\": 0,'+
		'            \"vII\": 0,'+
		'            \"vFCPSTRet\": 0,'+
		'            \"vDesc\": 0,'+
		'            \"vOutro\": 0,'+
		'            \"vIPI\": 0,'+
		'            \"vFrete\": 0'+
		'          }'+
		'        },'+
		'        \"pag\": {'+
		'          \"detPag\": ['+
		'            {'+
		'              \"vPag\": 265.79,'+
		'              \"tPag\": \"Dinheiro\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        \"Id\": \"NFe87878774456468954646464654654546545446579312\",'+
		'        \"ide\": {'+
		'          \"tpNF\": 1,'+
		'          \"mod\": 55,'+
		'          \"indPres\": 0,'+
		'          \"tpImp\": 1,'+
		'          \"nNF\": 1353368,'+
		'          \"cMunFG\": 3534401,'+
		'          \"procEmi\": 0,'+
		'          \"finNFe\": 1,'+
		'          \"dhEmi\": \"2019-07-22T09:33:31-03:00\",'+
		'          \"tpAmb\": 1,'+
		'          \"indFinal\": 1,'+
		'          \"dhSaiEnt\": \"2019-07-22T09:33:31-03:00\",'+
		'          \"idDest\": 1,'+
		'          \"tpEmis\": 1,'+
		'          \"cDV\": 0,'+
		'          \"cUF\": 35,'+
		'          \"serie\": 3,'+
		'          \"natOp\": \"Outra saida merc./prestacao serv. nao espec.\",'+
		'          \"cNF\": \"00012763\",'+
		'          \"verProc\": \"5.0.1500.2985\"'+
		'        },'+
		'        \"emit\": {'+
		'          \"CNAE\": 34324,'+
		'          \"xNome\": \"ACME SERVICOS LTDA\",'+
		'          \"IM\": 96852,'+
		'          \"CRT\": 3,'+
		'          \"xFant\": \"ACME SERVICOS LTDA\",'+
		'          \"CNPJ\": \"4545345345345\",'+
		'          \"enderEmit\": {'+
		'            \"fone\": 4534534534,'+
		'            \"UF\": \"SP\",'+
		'            \"xPais\": \"Brasil\",'+
		'            \"cPais\": 1058,'+
		'            \"xLgr\": \"AV Paulista\",'+
		'            \"xMun\": \"São Paulo\",'+
		'            \"nro\": 628,'+
		'            \"cMun\": 454545,'+
		'            \"xBairro\": \"Bairro do Chaves\",'+
		'            \"CEP\": \"06200000\"'+
		'          },'+
		'          \"IE\": 8465465454'+
		'        },'+
		'        \"dest\": {'+
		'          \"xNome\": \"ACME SERVICOS LTDA\",'+
		'          \"CNPJ\": \"454875345345345\",'+
		'          \"enderDest\": {'+
		'            \"xCpl\": \"GALP 1 E 2\",'+
		'            \"fone\": 4534534534,'+
		'            \"UF\": \"SP\",'+
		'            \"xPais\": \"Brasil\",'+
		'            \"cPais\": 1058,'+
		'            \"xLgr\": \"AV Paulista\",'+
		'            \"xMun\": \"Osasco\",'+
		'            \"nro\": 628,'+
		'            \"cMun\": 454545,'+
		'            \"xBairro\": \"Bairro do Chaves\",'+
		'            \"CEP\": \"06200000\"'+
		'          },'+
		'          \"IE\": 8465465454,'+
		'          \"indIEDest\": 9,'+
		'          \"email\": \"acme@acme.com\"'+
		'        },'+
		'        \"transp\": {'+
		'          \"modFrete\": 0,'+
		'          \"vol\": ['+
		'            {'+
		'              \"pesoL\": 0.03,'+
		'              \"qVol\": 1,'+
		'              \"pesoB\": 0.033'+
		'            }'+
		'          ],'+
		'          \"transporta\": {'+
		'            \"xNome\": \"John Doe da Silva\",'+
		'            \"UF\": \"SP\",'+
		'            \"xEnder\": \"Rua 1\",'+
		'            \"xMun\": \"Sao Paulo\",'+
		'            \"CNPJ\": \"4654654654654\",'+
		'            \"IE\": 8789789789'+
		'          }'+
		'        }'+
		'      }'+
		'    },'+
		'    \"versao\": 4'+
		'  }'+
		'}';
    }
    public static string MockNFeError400() {
        return 'O número da chave informado não é válido.';
    }
    public static string MockNFeError404() {
        return 'O número da chave informado não foi encontrado.';
    }
    public static string MockNFeError406() {
        return 'O formato do arquivo de saída deve ser Json/Xml.';
    }
    public static string MockNFeError500() {
        return 'Ocorreu algum erro no servidor.';
    }
	@isTest 
	private static void getToken(){
	    integer status = 200;
        string mock = WSNFeTest.MockToken();
		System.debug(mock);
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 
		
		Test.startTest();
        HttpResponse response = WSNFe.responseToken();
        Test.stopTest();
		System.debug(response);
		String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
		System.debug(response.getBody());
		string token = (string) ((Map<String, Object>) JSON.deserializeUntyped(response.getBody())).get('access_token');
		System.assertEquals('e30d3ea4bada19ebd2b104ff5bcba599', token);

		
	}
        
    @isTest private static void monthTest(){
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 1, 1)),'Ene');
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 2, 1)),'Feb');
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 3, 1)),'Mar');
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 4, 1)),'Abr');
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 5, 1)),'May');
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 6, 1)),'Jun');
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 7, 1)),'Jul');
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 8, 1)),'Ago');
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 9, 1)),'Sep');
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 10, 1)),'Oct');
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 11, 1)),'Nov');
        System.assertEquals(WSNFe.getMonthName(Date.newInstance(2000, 12, 1)),'Dic');
    }
    
    @isTest
    private static void sendNFe_ReciveNFeJson(){
        Product2 product = new Product2(Name='Generico Nota Fiscal', isActive = true);
        insert product;
        
        integer status = 200;
        string mock = WSNFeTest.MockNFe();
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 

        Test.startTest();
        
        Id productId = [SELECT Id FROM Product2 WHERE Name = 'Generico Nota Fiscal' LIMIT 1].id;
        
        HttpResponse response = WSNFe.responseWSNFe('35161147508411011603551000077959551093041003', '123456789',false);
        Test.stopTest();

        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');

        String actualValue = response.getBody();

        String expectedValue = WSNFeTest.MockNFe();
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
    }
    @isTest
    private static void sendNFe_ReciveNFeWapper(){
        integer status = 200;
        string mock = WSNFeTest.MockNFe();
        string NFe = '35161147508411011603551000077959551093041003';
        
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 
        
        Test.startTest();
        NFeWapper Wapper = WSNFe.getNFe(NFe);
        Test.stopTest();

        string json = WSNFeTest.MockNFe();
        NFeWapper NFeWapperExpected = NFeWapper.parse(json);
        System.assertEquals(NFeWapperExpected.nfeProc.NFe.infNFe.Id, Wapper.nfeProc.NFe.infNFe.Id);
    }
    @isTest
    private static void sendNFe_WithError400(){
        Boolean testPass = false;
        integer status = 400;
        string mock = WSNFeTest.MockNFeError400();
        string NFe = '35161147508411011603551000077959551093041003';
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        try {
            NFeWapper Wapper = WSNFe.getNFe(NFe);
        } catch (DMLException errorUnit) {
            System.assert(errorUnit.getMessage().contains(mock), 'El error es: ' + errorUnit.getMessage());
            testPass = true;
        }
        Test.stopTest();
        System.assert(testPass,'Debe entrar en el error');
    }
    @isTest
    private static void sendNFe_WithError404(){
        Boolean testPass = false;
        integer status = 404;
        string mock = WSNFeTest.MockNFeError404();
        string NFe = '35161147508411011603551000077959551093041003';
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        try {
            NFeWapper Wapper = WSNFe.getNFe(NFe);
        } catch (DMLException error) {
            System.assert(error.getMessage().contains(mock), 'El error es: ' + error.getMessage());
            testPass = true;
        }
        Test.stopTest();
        System.assert(testPass,'Debe entrar en el error');
    }
    @isTest
    private static void sendNFe_WithError406(){
        Boolean testPass = false;
        integer status = 406;
        string mock = WSNFeTest.MockNFeError406();
        string NFe = '35161147508411011603551000077959551093041003';
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        try {
            NFeWapper Wapper = WSNFe.getNFe(NFe);
        } catch (DMLException error) {
            System.assert(error.getMessage().contains(mock), 'El error es: ' + error.getMessage());
            testPass = true;
        }
        Test.stopTest();
        System.assert(testPass,'Debe entrar en el error');
    }
    @isTest
    private static void sendNFe_WithError500(){
        Boolean testPass = false;
        integer status = 500;
        string mock = WSNFeTest.MockNFeError500();
        string NFe = '35161147508411011603551000077959551093041003';
        Test.setMock(HttpCalloutMock.class, new WSNFeMock(status, mock)); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        try {
            NFeWapper Wapper = WSNFe.getNFe(NFe);
        } catch (DMLException error) {
            System.assert(error.getMessage().contains(mock), 'El error es: ' + error.getMessage());
            testPass = true;
        }
        Test.stopTest();
        System.assert(testPass,'Debe entrar en el error');
    }

	@isTest
	private static void RegisterRequest_UnavaiableSetting() {

		Test.startTest();
		WSNFe.RegisterRequest('Doesnt Exists');
		Test.stopTest();

		List<API_Counter__c> API_Counters = [SELECT Id FROM API_Counter__c];

		System.assertEquals(0, API_Counters.size(), 'No debe generarse ningun contador ya que la configuración no existe');
	}
	@IsTest
	private static void RegisterRequest_UnexistingCounter() {
		
		Request_Counter_Configuration__c Conf = new Request_Counter_Configuration__c(Name = 'WSNFe', MonthDay__c = 1);
		insert Conf;

		Test.startTest();
		WSNFe.RegisterRequest('WSNFe');
		Test.stopTest();

		List<API_Counter__c> API_Counters = [SELECT Id, Nomenclature__c, 
													Starting_Date__c, Finishing_Date__c,
													Requests_Amount__c
											 FROM API_Counter__c];
		
		System.assertEquals(1, API_Counters.size(), 'Deberia generarse 1 contador');

		Date startingDate = Date.newInstance(System.today().year(), 
											 System.today().month(),
											 (Integer)Conf.MonthDay__c);
		Date finishingDate = startingDate.addMonths(1).addDays(-1);
		String counterName = WSNFe.getMonthName(finishingDate) + ' ' + finishingDate.Year()  + ' - ' +
							 WSNFe.getStringDate(startingDate) + ' - '  + 
							 WSNFe.getStringDate(finishingDate);

		System.assertEquals(startingDate, API_Counters[0].Starting_Date__c, 'Fechas de inicio son distintas');
		System.assertEquals(finishingDate, API_Counters[0].Finishing_Date__c, 'Fechas de fin son distintas');
		System.assertEquals(counterName, API_Counters[0].Nomenclature__c, 'Nomenclatura del contador es distinta');
		System.assertEquals(1, API_Counters[0].Requests_Amount__c, 'La cantidad de solicitudes debe ser 1');
	}
	@IsTest
	private static void RegisterRequest_ExistingCounter() {
		
		Request_Counter_Configuration__c Conf = new Request_Counter_Configuration__c(Name = 'WSNFe', MonthDay__c = 1);
		insert Conf;
		WSNFe.RegisterRequest('WSNFe');

		Test.startTest();
		WSNFe.RegisterRequest('WSNFe');
		Test.stopTest();

		List<API_Counter__c> API_Counters = [SELECT Id, Nomenclature__c, 
													Starting_Date__c, Finishing_Date__c,
													Requests_Amount__c
											 FROM API_Counter__c];
		
		System.assertEquals(1, API_Counters.size(), 'Deberia generarse 1 contador');

		Date startingDate = Date.newInstance(System.today().year(), 
											 System.today().month(),
											 (Integer)Conf.MonthDay__c);
		Date finishingDate = startingDate.addMonths(1).addDays(-1);
		String counterName = WSNFe.getMonthName(finishingDate) + ' ' + finishingDate.Year()  + ' - ' +
							 WSNFe.getStringDate(startingDate) + ' - '  + 
							 WSNFe.getStringDate(finishingDate);

		System.assertEquals(startingDate, API_Counters[0].Starting_Date__c, 'Fechas de inicio son distintas');
		System.assertEquals(finishingDate, API_Counters[0].Finishing_Date__c, 'Fechas de fin son distintas');
		System.assertEquals(counterName, API_Counters[0].Nomenclature__c, 'Nomenclatura del contador es distinta');
		System.assertEquals(2, API_Counters[0].Requests_Amount__c, 'La cantidad de solicitudes debe ser 1');
	}

	@IsTest
	private static void RegisterRequest_LastMonthDaySet() {
        
		Request_Counter_Configuration__c Conf = new Request_Counter_Configuration__c(Name = 'WSNFe', MonthDay__c = System.today().day() != 1 ? 30 : System.today().day()-1);
		insert Conf;
		WSNFe.RegisterRequest('WSNFe');

		Test.startTest();
		WSNFe.RegisterRequest('WSNFe');
		Test.stopTest();

		List<API_Counter__c> API_Counters = [SELECT Id, Nomenclature__c, 
													Starting_Date__c, Finishing_Date__c,
													Requests_Amount__c
											 FROM API_Counter__c];
		
		System.assertEquals(1, API_Counters.size(), 'Deberia generarse 1 contador');

		Date startingDate = Date.newInstance(System.today().year(), 
											 System.today().month()-1,
											 (Integer)Conf.MonthDay__c);
		Date finishingDate = startingDate.addMonths(1).addDays(-1);
		String counterName = WSNFe.getMonthName(finishingDate) + ' ' + finishingDate.Year()  + ' - ' +
							 WSNFe.getStringDate(startingDate) + ' - '  + 
							 WSNFe.getStringDate(finishingDate);

		System.assertEquals(2, API_Counters[0].Requests_Amount__c, 'La cantidad de solicitudes debe ser 1');
	}

}
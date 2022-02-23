public with sharing class WSNFe {
	public static HttpResponse responseToken(){
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('callout:TokenWSNFe/'+'token?grant_type=client_credentials');
		request.setMethod('POST');
		request.setHeader('Accept', 'application/json');
		string tipo = '{!$Credential.UserName}';
		string password = '{!$Credential.Password}';
		request.setHeader('Authorization', tipo + ' ' + password);
		return http.send(request);
	}
	public static HttpResponse responseWSNFe(string NFe,  string token, boolean isSandbox) {
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		//Credencial Name
		
		request.setMethod('GET');
		request.setHeader('Accept', 'application/json');
		System.debug(isSandbox);
		if(isSandbox){
			request.setEndpoint('callout:WSNFeTest/' + NFe);
			System.debug(request.getEndpoint());
			string tipo = '{!$Credential.UserName}';
			string password = '{!$Credential.Password}';
            
			request.setHeader('Authorization', tipo + ' ' + password);
		}else{
			request.setEndpoint('callout:WSNFe/' + NFe);
			request.setHeader('Authorization', 'Bearer ' + token);
		}
		return http.send(request);
	}
    
    public static NFeWapper getNFe(string NFe) {
		return getNFe(NFe, true);
    }
    
	public static NFeWapper getNFe(String NFe, boolean registerRequest) {
		boolean isSandbox = isSandbox();
		String token = '';

        HttpResponse accessToken = responseToken();
        
        if(accessToken.getStatusCode() >= 200 && accessToken.getStatusCode() < 300 ) {
            token = (string) ((Map<String, Object>) JSON.deserializeUntyped(accessToken.getBody())).get('access_token');
            System.debug(token);
        }
        else{
            DMLException auraError = new DMLException('error Token: '+ accessToken.getBody());
            auraError.setMessage('error Token: '+ accessToken.getBody());
            throw auraError;
        }

		HttpResponse response = WSNFe.responseWSNFe(NFe, token, isSandbox);
		// If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            NFeWapper wapper= NFeWapper.parse(response.getBody());
            wapper.JSONstring = response.getBody();
			System.debug(wapper);
            if(registerRequest) RegisterRequest('WSNFe');
            return wapper;
        } else {
            DMLException auraError = new DMLException('CodeError: '+ response.getStatusCode() + ' '+ response.getBody());
			auraError.setMessage('CodeError: '+ response.getStatusCode() + ' '+ response.getBody());
            throw auraError;
        }
    }
    
    public static void RegisterRequest(String SettingName) {
        RegisterRequest(SettingName, 1);
    }
    
    public static void RegisterRequest(String SettingName, Integer requestsAmount) {
        Date today = System.today();
        
        List<Request_Counter_Configuration__c> RCCList = [
            SELECT Id, MonthDay__c 
            FROM Request_Counter_Configuration__c
            WHERE Name =: SettingName
        ];
        
		System.debug(RCCList);
		if(RCCList.isEmpty()) {
			return;
		}
        
        Request_Counter_Configuration__c RelatedRCC = RCCList[0];
        
        Date startingDate = Date.newInstance(today.year(), 
                                             today.month(), 
                                             (Integer)RelatedRCC.MonthDay__c);

		if(today.day() < (Integer)RelatedRCC.MonthDay__c) {
			startingDate = startingDate.addMonths(-1);
		}

        Date finishingDate = startingDate.addMonths(1).addDays(-1);
        
        
        List<API_Counter__c> API_Counters = [
            SELECT Id, Requests_Amount__c 
            FROM API_Counter__c 
            WHERE Starting_Date__c <=: today
            AND Finishing_Date__c >=: today
        ];
        
        if(API_Counters.isEmpty()) {
            
			String counterName = getMonthName(finishingDate) + ' ' + finishingDate.Year()  + ' - ' +
								 getStringDate(startingDate) + ' - '  + 
								 getStringDate(finishingDate);
            
			API_Counter__c counter = new API_Counter__c(Name = counterName,
														Nomenclature__c = counterName,
														Starting_Date__c = startingDate,
														Finishing_Date__c = finishingDate,
														Requests_Amount__c = requestsAmount,
														RelatedAPI__c = SettingName);
			insert counter;
		}
		else {
			for(API_Counter__c API_CounterUnit : API_Counters) {
				API_CounterUnit.Requests_Amount__c += requestsAmount;
			}
			update API_Counters;
		}

	}

	public static String getMonthName(Date dateUnit) {
		Integer month = dateUnit.month();
		
		switch on month {
			when 1 {
				return 'Ene';
			}
			when 2 {
				return 'Feb';
			}
			when 3 {
				return 'Mar';
			}
			when 4 {
				return 'Abr';
			}
			when 5 {
				return 'May';
			}
			when 6 {
				return 'Jun';
			}
			when 7 {
				return 'Jul';
			}
			when 8 {
				return 'Ago';
			}
			when 9 {
				return 'Sep';
			}
			when 10 {
				return 'Oct';
			}
			when 11 {
				return 'Nov';
			}
			when 12 {
				return 'Dic';
			}
		}
		return null;
		
	}

	public static String getStringDate(Date dateUnit) {
		String result = dateUnit.day() + 
						'/' + dateUnit.month() + 
						'/' + dateUnit.year();
		return result;
	}
	public static Boolean isSandbox(){
		return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
	}
}
// WSNFe.getNFe('35161147508411011603551000077959551093041003');
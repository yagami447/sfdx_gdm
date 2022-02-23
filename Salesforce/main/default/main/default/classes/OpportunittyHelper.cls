public with sharing class OpportunittyHelper {
    //Migrar todo a xappia Opportunit Helper una vez que esa clase este funcional al 100%
    public static void setOpportunityCooperante(List<Opportunity> opportunityList){
		List<Id> cooperanteIdList = new List<Id>();
		for(Opportunity anOpportunity: opportunityList) {
			if(anOpportunity.Cooperante2__c != null) {
				cooperanteIdList.add(anOpportunity.Cooperante2__c);
			}
		}

		Map<Id, Cooperante__c> mapCooperantes = new Map<Id, Cooperante__c>([
			SELECT CuentaCoop__c
			FROM Cooperante__c
			WHERE Id IN :cooperanteIdList
		]);

		for(Opportunity anOpportunity: opportunityList) {
			if(anOpportunity.Cooperante2__c != null) {
				anOpportunity.Cooperante__c = mapCooperantes.get(anOpportunity.Cooperante2__c).CuentaCoop__c;
			}
		}
	}
   
    public static void updateOpportunityCooperante(List<Opportunity> opportunityList, Map<Id,Opportunity> oldOppMap){
		List<Id> cooperanteIdList = new List<Id>();
		for(Opportunity anOpportunity: opportunityList) {
			if(anOpportunity.Cooperante2__c != null) {
				cooperanteIdList.add(anOpportunity.Cooperante2__c);
			}
		}

		Map<Id, Cooperante__c> mapCooperantes = new Map<Id, Cooperante__c>([
			SELECT CuentaCoop__c
			FROM Cooperante__c
			WHERE Id IN :cooperanteIdList
		]);

		for(Opportunity anOpportunity: opportunityList) {
			if(anOpportunity.Cooperante2__c != null && anOpportunity.Cooperante2__c != oldOppMap.get(anOpportunity.id).Cooperante2__c) {
				anOpportunity.Cooperante__c = mapCooperantes.get(anOpportunity.Cooperante2__c).CuentaCoop__c;
			}
		}
	}
}
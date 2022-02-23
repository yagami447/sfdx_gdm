/**
* @name ContactsForSignatureElectronica
* @author Jhonny Peroza
* updated 07-09-2021
*/
public class ContactsForSignatureElectronica {

	@AuraEnabled
	public static List<wrapSigner> getContacts(String recordId) {

		System.debug('RecordId: ' + recordId);

		List<wrapSigner> finalSignerList = new List<wrapSigner>();

		List<Contract> contractList = [SELECT AccountId FROM Contract WHERE Id =: recordId];
		
        List<Contact> contactList = [SELECT Account.Name, Name, CNPJ_CPF_c__c, Email, Tipo_de_Assinatura__c, Origem_Docto__c, Vencimiento_docto__c FROM Contact WHERE AccountId =: contractList[0].AccountId];

		for (Contact c : contactList) {
		    finalSignerList.add(new wrapSigner(c, recordId));
		}

		return finalSignerList;        
	}

	@auraEnabled
    public static void updateContacts(String recordId, String selectedRows) {

		System.debug('selectedRows: ' + selectedRows);

		List<Signatario_do_Contrato__c> querySignatarios = [SELECT Id FROM Signatario_do_Contrato__c WHERE Contrato__c =: recordId];

		if(querySignatarios.size() > 0) {

			try {
				delete querySignatarios;
			} catch (DmlException e) {
				System.debug('DML Error message: ' + e.getMessage());
			}

		}

        List<wrapSigner> signersList = (List<wrapSigner>)System.JSON.deserialize(selectedRows, List<wrapSigner>.class);
        
    	List<Signatario_do_Contrato__c> signers = new List<Signatario_do_Contrato__c>();
        
        for (wrapSigner s : signersList) {
           signers.add(s.getSignatario(recordId));
        }

		System.debug('Signers: ' + signers);

		try {
			upsert signers;
		} catch (DmlException e) {
			System.debug('DML Error message: ' + e.getMessage());
		}
        
    }

	public class wrapSigner {

		@AuraEnabled public String signerId {get; set;}
        @AuraEnabled public String contactId {get; set;}
        @AuraEnabled public Boolean check {get; set;}
		@AuraEnabled public String Account {get;set;}
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public String CPF {get; set;}
        @AuraEnabled public String Email {get; set;}
        @AuraEnabled public String tipoAsignatura {get; set;}
        @AuraEnabled public String origemDoc {get; set;}
		@AuraEnabled public String atribuido {get; set;}
        @AuraEnabled public Date vencimientoDoc {get; set;}

		public wrapSigner(Contact c, String recordId) {

			List<Signatario_do_Contrato__c> querySignatario = [SELECT Id FROM Signatario_do_Contrato__c WHERE Contacto__c =:c.id AND Contrato__c =: recordId];

			this.Account = c.Account.Name;
			this.Name = c.Name;
			this.CPF = c.CNPJ_CPF_c__c;
			this.Email = c.email;
			this.tipoAsignatura = c.Tipo_de_Assinatura__c;
			this.origemDoc = c.Origem_Docto__c;
			this.vencimientoDoc = c.Vencimiento_docto__c;
			this.contactId = c.id;
			this.check = querySignatario.size() > 0 ? true : false;

		}	

		public Signatario_do_Contrato__c getSignatario(String contractId) {
			
			return new Signatario_do_Contrato__c
			(
				Contacto__c = contactId,
                Contrato__c = contractId
			);
		}

	}

}
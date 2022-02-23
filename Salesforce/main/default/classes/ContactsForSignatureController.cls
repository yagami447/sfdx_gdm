public class ContactsForSignatureController {
	@auraEnabled
	public static List<wrapSigner> getContacts(String recordId) {
		Map<Id, Signatario__c> signerByContactId = new map<Id, Signatario__c>();
		List<wrapSigner> finalSignerList = new List<wrapSigner>();
		Contrato__c con = [SELECT Multiplicador__c FROM Contrato__c WHERE Id = :recordId];

		List<Contact> contactList=[
		    SELECT name, CNPJ_CPF_c__c, email,
            Tipo_de_Assinatura__c, Vencimiento_docto__c, Origem_Docto__c 
		    FROM Contact 
		    WHERE AccountId = :con.Multiplicador__c
		];
        
		List<Signatario__c> signers = [
		    SELECT Id, Contacto__c, Contrato_de_Multiplicacao__c
		    FROM Signatario__c 
		    WHERE Contrato_de_Multiplicacao__c = :recordId
		];

		for (Signatario__c signer : signers) {
		    signerByContactId.put(signer.Contacto__c, signer);
		} 
		for (Contact c : contactList) {
		    if (signerByContactId.containsKey(c.id)) {
		        finalSignerList.add(
                    new wrapSigner(c, signerByContactId.get(c.id))
                );
		    } else {
				finalSignerList.add(
					new wrapSigner(c)
		    	);
		    }
		}
		return finalSignerList;        
	}

   @auraEnabled
    public static void updateContacts(String recordId, String selectedRows) {
        
        List<wrapSigner> signersList = (List<wrapSigner>)System.JSON.deserialize(selectedRows, List<wrapSigner>.class);
        
        
    	List<Signatario__c> signers = new List<Signatario__c>();
        
    	delete [
		    SELECT Id, Contacto__c, Contrato_de_Multiplicacao__c
		    FROM Signatario__c 
		    WHERE Contrato_de_Multiplicacao__c = :recordId
		];
        
        for (wrapSigner s : signersList) {
           signers.add(s.getSignatario(recordId));
        }

        upsert signers;
    }
    
    public class wrapSigner {
        @AuraEnabled public String signerId {get; set;}
        @AuraEnabled public String contactId {get; set;}
        @AuraEnabled public Boolean check {get; set;}
        @AuraEnabled public String name {get; set;}
        @AuraEnabled public String CPF {get; set;}
        @AuraEnabled public String Email {get; set;}
        @AuraEnabled public String tipoAsignatura {get; set;}
        @AuraEnabled public String origemDoc {get; set;}
        @AuraEnabled public Date vencimientoDoc {get; set;}
        
        
        public wrapSigner(Contact c) {
            this.name = c.Name;
            this.CPF = c.CNPJ_CPF_c__c;
            this.Email = c.email;
            this.tipoAsignatura = c.Tipo_de_Assinatura__c;
            this.origemDoc = c.Origem_Docto__c;
            this.vencimientoDoc = c.Vencimiento_docto__c;
            this.contactId = c.id;
            this.check = false;
        }
        
        
        public wrapSigner(Contact c, Signatario__c s) {
            this.contactId = c.id;
            this.name = c.Name;
            this.CPF = c.CNPJ_CPF_c__c;
            this.Email = c.email;
            this.tipoAsignatura = c.Tipo_de_Assinatura__c;
            this.origemDoc = c.Origem_Docto__c;
            this.vencimientoDoc = c.Vencimiento_docto__c;
            this.signerId = s.id;
            this.check = true;
        }
        
        public Signatario__c getSignatario(String contractId) {
            return new Signatario__c (
            	Contacto__c = contactId,
                Contrato_de_multiplicacao__c = contractId
            );
        }
    }
}
public without sharing class NotaFiscalElectronicaController {

	@auraEnabled
    public static String searchNFeUpdate(String NFe) {
        return searchNFe(NFe, true);
    }
    
	@auraEnabled
    public static String searchNFe(String NFe, boolean exist) {
        List<Nota_Fiscal_Eletr_nica__c> notas = [SELECT Id, NFe__c FROM Nota_Fiscal_Eletr_nica__c WHERE NFe__c = :NFe ];
        if (notas.size() > 0 /*&& exist*/) {
            return 'Existe:'+notas[0].id;
        }
        NFeWapper wrapper =  WSNFe.getNFe(NFe);
        System.debug(wrapper);
        return  JSON.serialize(wrapper);
    }
    
    @auraEnabled
    public static String saveOpportunity(String NFe) {
        NFeWapper NFeToConvert =   (NFeWapper)System.JSON.deserialize(NFe, NFeWapper.class);
        Nota_Fiscal_Eletr_nica__c nota = NFeToConvert.createOpportunity();
     
        List<Nota_Fiscal_Eletr_nica__c> notas = [SELECT Id, NFe__c, CPF_Destinatario__c,CPF__c FROM Nota_Fiscal_Eletr_nica__c WHERE NFe__c = :nota.NFe__c];
        if (notas.size() == 0) {
            return saveNewOpportunity(NFe);
        }else{
       		notas[0].CPF__c = nota.CPF__c;
        	notas[0].CPF_Destinatario__c = nota.CPF_Destinatario__c;
        	update notas[0];
            return notas[0].id;
        }
    }
    
    @auraEnabled
    public static String saveNewOpportunity(String NFe) {
        System.debug(NFe);
        //NFeWapper NFeToConvert = NFeWapper.parse(NFe);
        NFeWapper NFeToConvert =   (NFeWapper)System.JSON.deserialize(NFe, NFeWapper.class);
        Nota_Fiscal_Eletr_nica__c nota = NFeToConvert.createOpportunity();
        insert nota;
        List<Produto_da_nota_fiscal__c> items = NFeToConvert.createItems(nota.id);
        insert items;
        
        return nota.id;
    }
}
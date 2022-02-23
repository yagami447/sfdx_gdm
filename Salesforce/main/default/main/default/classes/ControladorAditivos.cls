Global with sharing class ControladorAditivos  {
    
    
    public id contratoId {get;set;}
    public List<Integer> numerosDeSignatarios{get;set;}

	public ControladorAditivos(ApexPages.StandardController controller) {
		contratoId = apexpages.currentpage().getparameters().get('id');
    	numerosDeSignatarios = new  List<Integer>();
        
        List<Signatario__c> signatarios = [
            SELECT Id, Contrato_de_Multiplicacao__c 
            FROM Signatario__c
            WHERE Contrato_de_Multiplicacao__c  = :contratoId
        ];
        
        for (integer i = 0; i < signatarios.size(); i++) {
            numerosDeSignatarios.add(i+2);
        }
	}
    public boolean getContratoClonado(){
         Contrato__c obj = [
            SELECT Id, Contrato_ant__c
            FROM Contrato__c
            WHERE id =: contratoId 
         ];
        
        return obj.Contrato_ant__c != null;
    }
}
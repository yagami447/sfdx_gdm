trigger afterDeleteOppItem on OpportunityLineItem (after delete) {
	
	List<Registro_de_Eliminacion__c> regs = New List<Registro_de_Eliminacion__c>();
    for (OpportunityLineItem i : Trigger.Old){
    	Registro_de_Eliminacion__c reg = New Registro_de_Eliminacion__c();
    	reg.Fecha_eliminacion__c = system.today();
    	reg.Id_reg_objeto__c = i.Id;
    	reg.Nombre_objeto__c = 'OpportunityLineItem';
    	regs.add(reg);
    }
    insert regs;

}
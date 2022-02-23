public class CrearFacturaSapEventoRoyaltyCntroller {
    
    public String idCurrentRecord { get; set;}
    
    public CrearFacturaSapEventoRoyaltyCntroller( ApexPages.StandardController stdController ){
        System.debug('Cosa esta?: '+stdController.getId());
        idCurrentRecord = stdController.getId();
    }
    
    public Pagereference enviarASap(){
        Boolean SapError = false;
        String SapMessage = '';
        CrearFacturaConverter adapter = new CrearFacturaConverter();        
        try {
            Evento_Royalty__c eventoRoyalty = [
                SELECT ID,Accion__c,Resposta_SAP__c,Enviado_para_SAP__c
                FROM Evento_Royalty__c
                WHERE ID = :idCurrentRecord
            ];
            if (eventoRoyalty.Accion__c != 'Reembolso'){
                ApexPages.addMessage(
                    new ApexPages.message(
                        ApexPages.Severity.ERROR, 'Só é possível enviar para SAP ação de reembolso.'
                    )
                );
            }
            adapter.startRequest(idCurrentRecord);
            System.debug('Result Cntroller: '+adapter.result.NumDoc );
            // System.debug('Result Cntroller: '+adapter.result.TResponse.item.size() );
            for( CrearFacturaSoap.Bapiret2 item : adapter.result.TResponse.item){
                if(item.Type_x == 'E' || item.Type_x == 'e'){
                    SapError = true;
                }
                SapMessage += item.Message + ' ';
            }            
            if(SapError){
                eventoRoyalty.Resposta_SAP__c = SapMessage;
                ApexPages.addMessage(
                    new ApexPages.message(
                        ApexPages.Severity.ERROR, SapMessage
                    )
                );
            }else{
                eventoRoyalty.Enviado_para_SAP__c = true;
                ApexPages.addMessage(
                    new ApexPages.message(
                        ApexPages.Severity.CONFIRM,'Envío de datos Correcto.'
                    )
                );
            }
            update eventoRoyalty;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR ,'Error en la llamada a SAP.'));
            System.debug('ERROR ###: '+e);
        }
        
        return null;
    }
    
    public Pagereference dummy(){
        System.debug('Entro a dummy');
        PageReference pg = new PageReference('/'+idCurrentRecord);
        pg.setRedirect(true);
        return pg; 
    }
}
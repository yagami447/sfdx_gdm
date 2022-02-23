public with sharing class ObservacionesDeAuditoriaController {

    public Plano_de_Auditoria__c planoDeAuditoria                   {get; set;}
    public String safra												{get; set;}
    public Resumo_da_Conta__c crm                                   {get; set;}

    public ObservacionesDeAuditoriaController(ApexPages.StandardController controller) {
        Id planoDeAuditoriaId = controller.getRecord().Id;
        safra = apexpages.currentPage().getParameters().get('Safra');

        planoDeAuditoria = [
            SELECT Id, Name, Safra__c, Cuenta_Principal__c, Cuenta_Principal__r.Marca__c FROM Plano_de_Auditoria__c WHERE Id = :planoDeAuditoriaId
        ];

        crm= [
            SELECT Id, Name,Multiplicador__c, Multiplicador__r.Name, Sistema_Implantado__c, Miembros_o_area_para_Multiplicar__c,
                Emiten_Facturas_de_Venta_Transferencia__c, Separa_los_volumenes__c, Compra_Vende_Semillas_de_Terceros__c, Separa_los_volumenes_2__c, 
                Mencion_factura_de_venta__c, Clausula_5_1__c, Quebra__c, Otros_criadores__c, Participacion_en_la_cosecha__c, Ventas_Totales_RR__c,
                Ventas_Totales_INTACTA__c, Safra__c 
            FROM Resumo_da_Conta__c 
            WHERE Multiplicador__c = :planoDeAuditoria.Cuenta_Principal__c AND Safra__c = :safra LIMIT 1
        ];
    }

    public PageReference save() {
        update crm;
        PageReference pr = new PageReference('/apex/AuditarVisita');
        Id PlanoId = apexpages.currentPage().getParameters().get('Id');
        pr.getParameters().put('Id',PlanoId);
        pr.setRedirect(true);
        return pr;
    }

    public PageReference goToAuditar() {
        PageReference pr = new PageReference('/apex/AuditarVisita');
        Id PlanoId = planoDeAuditoria.Id;
        pr.getParameters().put('Id',PlanoId);
        pr.setRedirect(true); // If you want a redirect. Do not set anything if you want a forward.
        return pr;
    }

    public PageReference goToCalendario() {
        PageReference pr = new PageReference('/apex/FullCalendarDemo');
        pr.setRedirect(true);
        return pr;
    }
}
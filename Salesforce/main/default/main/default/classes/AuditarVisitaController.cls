public with sharing class AuditarVisitaController {

    @TestVisible public Plano_de_Auditoria__c planoDeAuditoria                   {get; set;}
    @TestVisible public Map<String, Producto_auditado__c> productoPorVariedad    {get; set;}
    @TestVisible public List<Producto_auditado__c> productosDelPlano             {get; set;}
    @TestVisible public Calendar_Event__c calendarEvent                          {get; set;}
    @TestVisible public List<SelectOption> safraFiltrer         				 {get; set;}
    @TestVisible public String safraSelected									 {get; set;}

    public AuditarVisitaController(ApexPages.StandardController controller) {
        Id planoDeAuditoriaId = controller.getRecord().Id;
        String safras = ApexPages.currentPage().getParameters().get('safras');
        safraSelected = ApexPages.currentPage().getParameters().get('Safra');
        System.debug('id: ' + planoDeAuditoriaId);
        System.debug('safras: ' + safras);

        planoDeAuditoria = [
            SELECT Id, Name, Safra__c, Cuenta_Principal__c, Observacion__c, Cuenta_Principal__r.Marca__c
            FROM Plano_de_Auditoria__c WHERE Id = :planoDeAuditoriaId
        ];

        productoPorVariedad = new Map<String, Producto_auditado__c>();
        productosDelPlano = new List<Producto_auditado__c>();

        safraFiltrer = new SelectOption[]{ new SelectOption('', 'Seleccione Safra') };

        if (String.isNotEmpty(safras)) {
            for (String safra : safras.split(';')) {
                safraFiltrer.add(new SelectOption(safra, safra));
            }
        } else {
            for (String safra : planoDeAuditoria.Safra__c.split(';')) {
                safraFiltrer.add(new SelectOption(safra, safra));
            }
        }

        getProductosParaAuditar();
    }

    public void getProductosParaAuditar() {
        System.debug('Safra seleccionada: ' + safraSelected);
        productosDelPlano = [
            SELECT Id, Name, Safra__C, Variedad__c, Variedad__r.Name, Marca__c, Categoria_Oli__c, Area_Autorizada__c, Area_Plantada__c, Productividad__c,
                Sem_Bruta__c, Quebra__c, Sem_Beneficiada__c, Sem_Aprobada__c, Sem_Aprovada_Verificada__c, Sem_Comercializada__c, Sem_Uso_Propio__c, Total_Com_Up__c, Descarte__c, Comercializado__c,
                Uso_Propio__c, Descarte_Cliente__c, Total_Com_UP_Cliente__c, Diferencia_de_Venta__c, Diferencia_Descarte__c, Observacion__c, Salir_de_la_visita__c
            FROM Producto_auditado__c WHERE Plano_de_Auditoria__c = :planoDeAuditoria.Id AND Safra__c = :safraSelected
        ];

        for (Producto_auditado__c product : productosDelPlano) {
            if (product.Diferencia_de_Venta__c != 0 || product.Diferencia_Descarte__c != 0) {
                product.Salir_de_la_visita__c = true;
            }
            System.debug('Diferencia de venta: ' + product.Diferencia_de_Venta__c);
        }
    }

    public PageReference save() {
        update productosDelPlano;
        update planoDeAuditoria;
        Id planoId = planoDeAuditoria.Id;
        PageReference pr = new PageReference('/apex/AuditarVisita');
        pr.getParameters().put('Id',planoId);
        pr.getParameters().put('Safra',safraSelected);
        pr.setRedirect(true);
        return pr;
    }

    public PageReference goToPlano() {
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }

    public PageReference goToCalendario() {
        PageReference pr = new PageReference('/apex/FullCalendarDemo');
        pr.setRedirect(true);
        return pr;
    }

    public PageReference goToObservaciones() {
        PageReference pr = new PageReference('/apex/ObservacionesDeAuditoria');
        Id planoId = planoDeAuditoria.Id;
        List<Resumo_da_Conta__c> CRMs = [
            SELECT Id, Name,Multiplicador__c, Multiplicador__r.Name, Sistema_Implantado__c, Miembros_o_area_para_Multiplicar__c,
                Emiten_Facturas_de_Venta_Transferencia__c, Separa_los_volumenes__c, Compra_Vende_Semillas_de_Terceros__c, Separa_los_volumenes_2__c, 
                Mencion_factura_de_venta__c, Clausula_5_1__c, Quebra__c, Otros_criadores__c, Participacion_en_la_cosecha__c, Ventas_Totales_RR__c,
                Ventas_Totales_INTACTA__c, Safra__c
            FROM Resumo_da_Conta__c WHERE Multiplicador__c = :planoDeAuditoria.Cuenta_Principal__c AND Safra__c = :safraSelected
        ];

        if (CRMs.isEmpty()) { createCRM(); }

        pr.getParameters().put('Id',planoId);
        pr.getParameters().put('Safra',safraSelected);
        pr.setRedirect(true);
        return pr;
    }

    public void createCRM() {
        Resumo_da_Conta__c newCRM = new Resumo_da_Conta__c(
            Name = 'CRM',
            Multiplicador__c = planoDeAuditoria.Cuenta_Principal__c,
            safra__c = safraSelected,
            Marca__c = planoDeAuditoria.Cuenta_Principal__r.Marca__c
        );

        insert newCRM;
    }

    public PageReference generatePDF() {
        PageReference pr = new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
        Id planoId = planoDeAuditoria.Id;

        //Your PDF
        PageReference pdf = new PageReference('/apex/PDFVisitaAuditada?Id=' + planoId);
        Blob bodyBlob;

        if (Test.isRunningTest()) { 
            bodyBlob = Blob.valueOf('Unit.Test');
        } else {
            bodyBlob = pdf.getContentAsPDF();
        }

        //ContentVersion
        Integer currentYear = System.Today().year();
        ContentVersion contentVersion_1 = new ContentVersion(
            Title = 'ApuntamentoPDF',
            PathOnClient ='/ApuntamentoPDF.pdf',
            VersionData = bodyBlob,
            origin = 'H'
        );

        insert contentVersion_1;

        ContentVersion contentVersion_2 = [
            SELECT Id, Title, ContentDocumentId, PathOnClient, VersionNumber, CreatedDate FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1
        ];

        Integer cantidadDeVersiones = [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId = :planoId];

        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = planoId;
        contentlink.ContentDocumentId = contentVersion_2.ContentDocumentId;
        contentlink.ShareType = 'V';
        insert contentlink;
        contentVersion_2.Title = currentYear + '/' + (cantidadDeVersiones+1);
        update contentVersion_2;

        return pr;
    }
}
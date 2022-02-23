@isTest
public class TestDAOCRMCalendarioDeEventos {
    @isTest
    public static void testEvents(){
        Account acc = new Account(Name = 'Teste');
        insert acc;
        CRM_Calendario_de_Eventos__c event = new CRM_Calendario_de_Eventos__c(Name = 'Teste', Cuenta__c = acc.Id, Marca__c = 'NEOG', Evento__c = 'Emplacamento', Safra__c = '18/19');
        insert event;
        DAOCRMCalendarioDeEventos.getInstance().get(event.Id);
        DAOCRMCalendarioDeEventos.getInstance(DTOUtils.SharingMode.Without).get(event.Id);
        Product2 prod = new Product2();
        prod.Name = 'Test';
        prod.Obtentor__c = 'Bayer';
        insert prod;
        CRM_Detalle_Calendario_de_eventos__c nprod = new CRM_Detalle_Calendario_de_eventos__c(CRM_Calendario_de_eventos__c = event.id,Cultivar__c = prod.id );
        insert nprod;
        DAOCRMDetalleCalendarioDeEventos.getInstance().getByCRMCalendarioId(event.Id);
        DAOCRMDetalleCalendarioDeEventos.getInstance(DTOUtils.SharingMode.Without).getByCRMCalendarioId(event.Id);
        
    }
}
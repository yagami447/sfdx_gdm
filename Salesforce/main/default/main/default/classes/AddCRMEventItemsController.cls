/**
 * @Author: Sergio Migueis - K2
 * @Description: Apex controller for lightning (Aura and LWC) responsible for Fetching and Organizing data for event items creation.
 * @History:
 * 22/11/2019 - Creation. With Converted Methods
 * 08/12/2019 - Deploy from scratchorg
 */
public without sharing class AddCRMEventItemsController {

    @AuraEnabled
    public static CRM_Calendario_de_Eventos__c getTheCRM(String recordId) {
        return DAOCRMCalendarioDeEventos.getInstance().get(recordId);
    }

    @AuraEnabled
    public static List<CRM_Detalle_Calendario_de_eventos__c> getShoppingCart(String recordId) {
        //Comes ordered by name.
        List<CRM_Detalle_Calendario_de_eventos__c> details = DAOCRMDetalleCalendarioDeEventos.getInstance().getByCRMCalendarioId(recordId);

        if (details != null && details.size() > 0) {
            for (Integer i = 0; i < details.size(); i++) {
                details.get(i).Indice__c = i; //corrects the number
            }
        }

        return details;
    }

    @AuraEnabled
    public static Map<Id, User> getUsers() {
        //Returns all visible to user.
        return new Map<Id,User>(DAOUser.getInstance().getAll());
    }

    @AuraEnabled
    public static List<Product2> getAvailableProducts(String recordId, String search) {
        return DAOProduct2.getInstance().getBySearchString(search);
    }

    @AuraEnabled
    public static List<CRM_Detalle_Calendario_de_eventos__c> addShoppingCart(String recordId, List<Product2> toSave) {
        Integer contador = DAOCRMDetalleCalendarioDeEventos.getInstance().getByCRMCalendarioId(recordId).size();
        List<CRM_Detalle_Calendario_de_eventos__c> added = new List<CRM_Detalle_Calendario_de_eventos__c>();

        for (Product2 d : toSave) {
            CRM_Detalle_Calendario_de_eventos__c item = new CRM_Detalle_Calendario_de_eventos__c(
                CRM_Calendario_de_eventos__c = recordId,
                Cultivar__r = d,
                Cultivar__c = d.Id,
                Indice__c = contador
            );

            contador++;
            added.add(item);
        }

        return added;
    }

    @AuraEnabled
    public static Boolean saveShoppingCart(String recordId, List<CRM_Detalle_Calendario_de_eventos__c> toSave) {
        try {
            upsert toSave;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return true;
    }

    @AuraEnabled
    public static Boolean deleteShoppingCart(String recordId, List<CRM_Detalle_Calendario_de_eventos__c> toDelete) {
        try {
            delete toDelete;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return true;
    }
}
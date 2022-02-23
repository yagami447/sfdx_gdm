public with sharing class oppConfirmButtonController {

    /*
     * Wrapper del método original para generar una CVB - Pendiente.
     */
    @AuraEnabled
    public static String[] sendConfirmationRequest(Id oppId, Id accId) {
        return previsionesController.generarConfirmacion(oppId, accId);
    }
}
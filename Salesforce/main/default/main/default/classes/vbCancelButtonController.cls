public without sharing class vbCancelButtonController {

    /*
     * Wrapper del método original para cancelar una CVB Pendiente/Autorizada
     */
    @AuraEnabled
    public static String[] sendCanceltionRequest(Id oppId, String stage) {
        return Opp_SAP_Mod.statusSAP(oppId, stage, 300, true, false);
    }
}
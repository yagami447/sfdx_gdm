public without sharing class accUpdateResponsibleController {

    /*
     * Wrapper del método original para solicitar la actualización de los responsables de cuenta y marca
     */
    @AuraEnabled
    public static String[] sendUpdateRequest(Id accId) {
        return Acc_BloqDatos.atualizar_Supervisor(accId);
    }
}
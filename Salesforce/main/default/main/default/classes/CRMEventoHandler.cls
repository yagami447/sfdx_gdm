/**
 * @Author: Sergio Migueis - K2
 * @Description: Handler for object CRMEvento
 * 
 * @History:
 * 10/01/2020 - Creation - to deal with opportunity ownership
 * 04/11/2021 - FEATURE 11614 - Prazos de lançamentos Brasmax
 */
public class CRMEventoHandler {

    public static void beforeInsertCRMEventos(List<CRM_Calendario_de_Eventos__c> crmsNew) {
        List<CRM_Calendario_de_Eventos__c> crmList = new List<CRM_Calendario_de_Eventos__c>();

        for (CRM_Calendario_de_Eventos__c crm : crmsNew) {
            if (crm.Municipio__c != null) { crmList.add(crm); }
        }

        if (!crmList.isEmpty()) { addPrazoDeLancamento(crmList); }
    }

    public static void beforeUpdateCRMEventos(List<CRM_Calendario_de_Eventos__c> crmsNew, List<CRM_Calendario_de_Eventos__c> crmsOld) {
        List<CRM_Calendario_de_Eventos__c> crmList = new List<CRM_Calendario_de_Eventos__c>();

        for (Integer i = 0; i < crmsNew.size(); i++) {
            CRM_Calendario_de_Eventos__c crmNew = crmsNew[i];
            CRM_Calendario_de_Eventos__c crmOld = crmsOld[i];

            if (crmNew.Municipio__c != crmOld.Municipio__c && crmNew.Municipio__c != null) {
                crmList.add(crmNew);
            }
        }

        if (!crmList.isEmpty()) { addPrazoDeLancamento(crmList); }
    }

    /**
     * Añade el Prazo de Lancamento que le corresponde a los CRM Eventos ingresados según UF, Tipo de Evento y Marca.
     */
    private static void addPrazoDeLancamento(List<CRM_Calendario_de_Eventos__c> crmList) {
        Set<Id> ciudades = new Set<Id>();
        Set<Id> estados = new Set<Id>();
        Set<String> eventos = new Set<String>();

        Map<Id, String> rtNames = getCRMEventoRtNames();

        for (CRM_Calendario_de_Eventos__c crm : crmList) {
            ciudades.add(crm.Municipio__c);
            eventos.add(getEventType(rtNames.get(crm.RecordTypeId)));
        }

        Map<Id, Cidade__c> cidades = new Map<Id, Cidade__c>([SELECT Id, Estado__c FROM Cidade__c WHERE Id IN :ciudades]);

        for (Cidade__c cidade : cidades.values()) {
            estados.add(cidade.Estado__c);
        }

        List<Prazo_de_Lancamento__c> plazos = [
            SELECT Id, Evento__c, Estado__c, Configuracion_de_Marca__r.Marca__c
            FROM Prazo_de_Lancamento__c
            WHERE Evento__c IN :eventos AND Estado__c IN :estados AND Configuracion_de_Marca__r.Marca__c = 'BRMX'
        ];

        for (Prazo_de_Lancamento__c plazo : plazos) {
            for (CRM_Calendario_de_Eventos__c crm : crmList) {
                String tipoEvento = getEventType(rtNames.get(crm.RecordTypeId));

                if (crm.Marca__c == 'BRMX' && plazo.Evento__c == tipoEvento && plazo.Estado__c == cidades.get(crm.Municipio__c).Estado__c) {
                    crm.Prazo_de_Lancamento__c = plazo.Id;
                }
            }
        }
    }

    /**
     * Deduce el tipo de evento de un CRM Evento según el RecordTypeName del CRM Evento ingresado.
     */
    private static String getEventType(String recordTypeName) {
        String eventType = null;

        if (recordTypeName == 'Día de Campo') { // No se incluirá Día de Campo en esta etapa
            // eventType = 'Día de Campo';
        } else if (recordTypeName == 'Emplacamento') {
            eventType = 'Emplacamento';
        } else if (recordTypeName == 'Test a campo') {
            eventType = 'Lado a Lado';
        } else if (recordTypeName == 'Treinamento Tecnico') {
            eventType = 'Treinamento Tecnico';
        }

        return eventType;
    }

    /**
     * Genera un mapa con los Id de RecordTypes de CRM Evento como clave y sus respectivos nombres como valor.
     */
    private static Map<Id, String> getCRMEventoRtNames() {
        Map<Id, String> rtNames = new Map<Id, String>();

        Map<String, Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByDeveloperName();

        for (String rt : rtMapByName.keySet()) {
            rtNames.put(rtMapByName.get(rt).getRecordTypeId(), rtMapByName.get(rt).getName());
        }

        return rtNames;
    }

    public static List<CRM_Calendario_de_Eventos__c> ChangeOwnerInAfter(List<CRM_Calendario_de_Eventos__c> triggerNew) {
        List<CRM_Calendario_de_Eventos__c> toBeSaved = new List<CRM_Calendario_de_Eventos__c>();
        List<Id> accountIds = new List<Id>();

        for (CRM_Calendario_de_Eventos__c tr : triggerNew) {
            CRM_Calendario_de_Eventos__c ev = tr.clone(true,false,false,true);
            accountIds.add(ev.Cuenta__c);
            toBeSaved.add(ev);
        }

        Map<Id, Account> mapAccountEvent = new Map<Id, Account>(DAOAccount.getInstance().get(accountIds));    
        Map<String, User> mappedUsers = new Map<String,User>();
        List<User> users = DAOUser.getInstance(DTOUtils.SharingMode.Without).getAll();

        for (User u : users) {
            mappedUsers.put(u.Codigo_Sap__c, u);
        }

        for (CRM_Calendario_de_Eventos__c tr : toBeSaved) {
            String usuario = null;
            Account acc = mapAccountEvent.get(tr.Cuenta__c);

            if (tr.Marca__c == 'BRMX' && acc.Responsavel__c != null) {
                usuario = acc.Responsavel__c;
            } else if (tr.Marca__c == 'DSEM' && acc.Reponsavel_DSEM__c != null) {
                usuario = acc.Reponsavel_DSEM__c;
            } else if (tr.Marca__c == 'NEOG' && acc.Responsavel_NEOGEN__c != null) {
                usuario = acc.Responsavel_NEOGEN__c;
            } else if (tr.Marca__c == 'DAGMA' && acc.Responsavel_DAGMA__c != null) {
                usuario = acc.Responsavel_DAGMA__c;
            } else if (tr.Marca__c == 'LICENÇAS' && acc.Responsavel_LICENCAS__c != null) {
                usuario = acc.Responsavel_LICENCAS__c;
            }

            if (usuario != null) {
                tr.OwnerId = mappedUsers.get(usuario.split('-')[0].trim()).Id;
            }

            if (tr.Realizado_por__c == null)
                tr.Realizado_por__c = 'Multiplicador';
        }

        if (!toBeSaved.isEmpty()) { upsert toBeSaved; }

        return toBeSaved;
    }

    public static void ShareCRMEventFromCommunity(List<CRM_Calendario_de_Eventos__c> triggerNew, Map<Id,CRM_Calendario_de_Eventos__c> oldMap) {
        Map<Id, List<CRM_Calendario_de_Eventos__c>> creatorsEventMap = new Map<Id, List<CRM_Calendario_de_Eventos__c>>();
        List<CRM_Calendario_de_Eventos__Share> shareToBeSaved = new List<CRM_Calendario_de_Eventos__Share>();
        List<CRM_Calendario_de_Eventos__c> eventsToBeSaved = new List<CRM_Calendario_de_Eventos__c>();
        List<Id> eventsId = new List<Id>();

        for (CRM_Calendario_de_Eventos__c event : triggerNew) {
            eventsId.add(event.Id);
        }

        List<CRM_Calendario_de_Eventos__c> evetnsToMap = DAOCRMCalendarioDeEventos.getInstance(DTOUtils.SharingMode.Without).get(eventsId);

        for (CRM_Calendario_de_Eventos__c event : evetnsToMap) {
            if (!creatorsEventMap.containsKey(event.CreatedById)) {
                creatorsEventMap.put(event.CreatedById, new List<CRM_Calendario_de_Eventos__c>{event});
            }
        }

        List<User> creators = DAOUser.getInstance().get(creatorsEventMap.keySet());

        for (User creator : creators) {
            if (creator.ContactId != null) { // IF THE CREATOR IS A CONTACT USER
                System.debug('ResultsShare-' + creatorsEventMap.get(creator.Id));

                for (CRM_Calendario_de_Eventos__c event : creatorsEventMap.get(creator.Id)) {
                    if (event.CreatedById != event.OwnerId) {
                        shareToBeSaved.add(new CRM_Calendario_de_Eventos__Share(
                            RowCause = 'Manual',
                            ParentId = event.Id,
                            UserOrGroupId = creator.Id,
                            AccessLevel = 'Edit'
                        ));
    
                        eventsToBeSaved.add(event);
                    }
                }
            }
        }

        if (!shareToBeSaved.isEmpty()) {
            List<Database.SaveResult> result = Database.insert(shareToBeSaved, false);

            for (Database.SaveResult sr : result) {
                if (!sr.isSuccess()) { System.debug(sr.getErrors()); }
            }
        }

        if (!eventsToBeSaved.isEmpty()) { upsert eventsToBeSaved; }
    }
}
public with sharing class AuditManagementController {

    /**
     * Obtiene los auditores disponibles para ser seleccionados por el usuario. Es posible que diferentes auditores posean el mismo nombre.
     */
    @AuraEnabled
    public static List<Map<String, String>> getAuditors() {
        List<Map<String, String>> auditors = new List<Map<String, String>>();

        auditors.add(new Map<String, String>{'value' => '', 'label' => '-- All --'});

        for (Account auditor : [SELECT Id, Name FROM Account WHERE Interno__c = true ORDER BY Name]) {
            auditors.add(new Map<String, String>{'value' => auditor.Id, 'label' => auditor.Name});
        }

        return auditors;
    }

    /**
     * Los nombres de planes de auditoría populan el title en los calendar events.
     */
    @AuraEnabled
    public static Map<Id, Plano_de_Auditoria__c> getAuditPlans() {
        return new Map<Id, Plano_de_Auditoria__c>([SELECT Id, Name, Nombre__c, Safra__c FROM Plano_de_Auditoria__c]);
    }

    /**
     * Obtiene los calendar events según los filtros especificados. Si recibe un map null devuelve todos los eventos sin filtrar.
     */
    @AuraEnabled
    public static List<Calendar_Event__c> getEvents(Map<String, List<String>> filters) {
        List<Calendar_Event__c> events = null;

        try {
            String fields = 'Id, Name, Plano_de_Auditoria__r.Nombre__c, Start_Time__c, End_Time__c, Auditor__c';
            String condition = 'Plano_de_Auditoria__c != null AND Plano_de_Auditoria__r.Cuenta_Principal__r.Name != null';

            if (filters != null) {
                for (String f : filters.keySet()) {
                    String values = '';

                    for (String v : filters.get(f)) {
                        values += '\'' + v + '\', ';
                    }

                    condition += ' AND ' + f + ' IN (' + values.removeEnd(', ') + ')';
                }
            }

            events = (List<Calendar_Event__c>)Database.query(
                String.format('SELECT {0} FROM Calendar_Event__c WHERE {1}', new Object[]{fields, condition})
            );
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return events;
    }

    /**
     * Obtiene las listas de filtros que serán expuestas al usuario. Los filtros usados fueron solicitados en la USER STORY 10236.
     */
    @AuraEnabled
    public static Map<String, List<Map<String, String>>> getFilters() {
        Map<String, List<Map<String, String>>> filters = new Map<String, List<Map<String, String>>>();

        List<Calendar_Event__c> events = [
            SELECT Cidade__c, UF__c, Etapa__c, Responsavel__c
            FROM Calendar_Event__c
            WHERE Plano_de_Auditoria__c != null AND Plano_de_Auditoria__r.Cuenta_Principal__r.Name != null
        ];

        String[] keys = new String[]{'Cidade__c','UF__c', 'Etapa__c', 'Responsavel__c'};

        for (String key : keys) {
            Set<String> keySet = new Set<String>();

            for (Calendar_Event__c event : events) {
                String field = (String)event.get(key);
                if (String.isNotEmpty(field)) { keySet.add(field); }
            }

            List<Map<String, String>> options = new List<Map<String, String>>();

            for (String ele : keySet) {
                options.add(new Map<String, String>{'value' => ele, 'label' => ele});
            }

            filters.put(key, options);
        }

        return filters;
    }
}
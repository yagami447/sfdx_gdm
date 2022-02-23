public with sharing abstract class CultivarsTechnicalInformation {

    /**
     * Retorna el total de registros según el SObject Name especificado y los campos Marca y Tecnología ingresados.
     */
    public static AggregateResult countRecords(String sObjectName, List<List<String>> filters) {
        return (AggregateResult)Database.query('SELECT COUNT(Id) Total FROM ' + sObjectName + ' ' + condition(filters));
    }

    public static List<SObject> getData(SObjectType entity, Integer queryLimit, Integer queryOffset, List<List<String>> filters) {
        List<SObject> items = null;

        try {
            String fields = String.join(new List<String>(entity.getDescribe().fields.getMap().keySet()), ', ');

            items = Database.query(String.format(
                'SELECT {0} FROM {1} {2} LIMIT {3} OFFSET {4}', new Object[]{
                    fields, entity.getDescribe().getName(), condition(filters), queryLimit, queryOffset
                }
            ));
        } catch (Exception e) {
            throw new AuraException(e.getMessage());
        }

        return items;
    }

    /**
     * Deduce la condición WHERE según los filtros ingresados.
     */
    private static String condition(List<List<String>> filters) {
        String condition = '';
        List<List<String>> auxList = new List<List<String>>();

        for (String[] filter : filters) {
            if (!String.isEmpty(filter[1])) { auxList.add(filter); }
        }

        if (!auxList.isEmpty()) {
            condition = 'WHERE ';
            Integer count = 0;

            for (String[] filter : auxList) {
                condition += filter[0] + ' = \'' + filter[1] + '\' ';
                count++;

                if (count != auxList.size()) {
                    condition += ' AND ';
                }
            }
        }

        return condition;
    }
}
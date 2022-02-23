public with sharing class VariedadRecomendacionesController extends CultivarsTechnicalInformation {

    /**
     * Retorna el total de registros de Recomendaciones de Variedad según los filtros de Marca, Tecnología y Región ingresados.
     */
    @AuraEnabled
    public static AggregateResult countRecomendaciones(String brand, String technology, String region) {
        return countRecords('Recomenda_o_de_variedade__c',
            new List<List<String>>{
                new List<String>{'Marca__c', brand},
                new List<String>{'Tecnologia__c', technology},
                new List<String>{'Regi_o__c', region}
            }
        );
    }

    @AuraEnabled
    public static List<Recomenda_o_de_variedade__c> getRecomendaciones(Integer queryLimit, Integer queryOffset, String brand, String technology, String region) {
        return getData(Recomenda_o_de_variedade__c.SObjectType, queryLimit, queryOffset,
            new List<List<String>>{
                new List<String>{'Marca__c', brand},
                new List<String>{'Tecnologia__c', technology},
                new List<String>{'Regi_o__c', region}
            }
        );
    }
}
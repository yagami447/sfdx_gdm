public with sharing class VariedadDatosComplementaresController extends CultivarsTechnicalInformation {

    /**
     * Retorna el total de registros de Variedad Datos Complementares según los filtros de Marca y Tecnología ingresados.
     */
    @AuraEnabled
    public static AggregateResult countDatosComplementares(String brand, String technology) {
        return countRecords('Variedad_Datos_Complementares__c',
            new List<List<String>>{
                new List<String>{'Marca__c', brand},
                new List<String>{'Tecnologia__c', technology}
            }
        );
    }

    @AuraEnabled
    public static List<Variedad_Datos_Complementares__c> getDatosComplementares(Integer queryLimit, Integer queryOffset, String brand, String technology) {
        return getData(Variedad_Datos_Complementares__c.SObjectType, queryLimit, queryOffset,
            new List<List<String>>{
                new List<String>{'Marca__c', brand},
                new List<String>{'Tecnologia__c', technology}
            }
        );
    }
}
/**
* @name ProductoDeRequisicaoHelper
* @author Jhonny Peroza
* @since 28-06-2021
*/
public class ProductoDeRequisicaoHelper {
    public static void updateRequisitionProduct(Produto_de_Requisicao__c requisitionProduct) {
        Id milhoRecordType = Schema.SObjectType.Produto_de_Requisicao__c.getRecordTypeInfosByDeveloperName().get('Milho').getRecordTypeId();
        Produto_de_Requisicao__c queryProduct = [SELECT Id, Name, Tipo__c, RecordTypeId, Requisicao_de_compra__c, Variedad__r.Name, Embalagem__c, Tratamento__c, Quantidade__c, quantidade_de_sementes__c 
                                                    FROM Produto_de_Requisicao__c
                                                        WHERE Id =: requisitionProduct.Id LIMIT 1];
        
        if(queryProduct.RecordTypeId == milhoRecordType && queryProduct.Tipo__c == 'Multiplicador') {

            queryProduct.Name = queryProduct.Variedad__r.Name + '-' + queryProduct.Embalagem__c + '-' + queryProduct.Tratamento__c; 
            queryProduct.quantidade_de_sementes__c = queryProduct.Embalagem__c == 'Saca 60 Mil Sementes' ? queryProduct.Quantidade__c * 60000 : queryProduct.Quantidade__c * 5000000;

            try {
                update queryProduct;
            } catch (DmlException e) {
                System.debug('DML Error message: ' + e.getMessage());
            } 
        }

        if(queryProduct.RecordTypeId == milhoRecordType && queryProduct.Tipo__c != 'Multiplicador') {

            Requisicao_de_compra__c queryRequisicao = [SELECT Id, Tipo__c, RecordType.Name 
                                                          FROM Requisicao_de_compra__c 
                                                            WHERE Requisicao_de_compra__c =: queryProduct.Requisicao_de_compra__c LIMIT 1];

            Produto_de_Requisicao__c queryProductTwo = [SELECT Id, Name, Embalagem__c, Quantidade_de_Sementes__c, RecordTypeId 
                                                          FROM Produto_de_Requisicao__c 
                                                            WHERE Requisicao_de_compra__c =: queryRequisicao.Id LIMIT 1];

            queryProduct.Name = queryProductTwo.Name;
            queryProduct.RecordTypeId = queryProductTwo.RecordTypeId;
            queryProduct.Embalagem__c = queryProductTwo.Embalagem__c;
            queryProduct.Quantidade_de_Sementes__c = queryProductTwo.Embalagem__c == 'Saca 60 Mil Sementes' ? requisitionProduct.Quantidade__c * 60000 : requisitionProduct.Quantidade__c * 5000000;

            try {
                update queryProduct;
            } catch (DmlException e) {
                System.debug('DML Error message: ' + e.getMessage());
            } 
        } 
    }
}
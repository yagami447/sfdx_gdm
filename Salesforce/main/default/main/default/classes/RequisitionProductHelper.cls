/**
* @name RequisitionProductHelper
* @author Jhonny Peroza
* updated 21-01-2022
*/
public class RequisitionProductHelper {

    public static Id milhoRecordTypeId = Schema.SObjectType.Produto_de_Requisicao__c.getRecordTypeInfosByDeveloperName().get('Milho').getRecordTypeId();

    public static void verifyRequisitionProduct(List<Produto_de_Requisicao__c> requisitionProductList) {

        List<String> marcaProduct = new List<String>();
        List<String> requisiciones = new List<String>();
        List<String> variedades = new List<String>();

		for (Produto_de_Requisicao__c productoRequisicao : requisitionProductList){
			requisiciones.add(productoRequisicao.Requisicao_de_compra__c);
            variedades.add(productoRequisicao.Variedad__c);
		}

        List<Requisicao_de_compra__c> requisicionMarcasList = [SELECT Marca__c, RecordTypeId
                                                                    FROM Requisicao_de_compra__c
                                                                        WHERE Id IN :requisiciones];

        List<Variedad__c> variedadesList = [SELECT Sociedad__c, Marca_comercial__c
                                                    FROM Variedad__c 
                                                        WHERE Id IN :variedades];

        for(Requisicao_de_compra__c requisicion : requisicionMarcasList) {
            for(Variedad__c variedade : variedadesList) {

                switch on requisicion.Marca__c {

                    when 'BRMX' {
                        if (variedade.Marca_comercial__c == 'BRASMAX' || variedade.Marca_comercial__c == 'Brasmax') {
                            marcaProduct.add(variedade.Id);
                        } 
                    }
                    when 'DSEM' {
                        if (variedade.Marca_comercial__c == 'DONMARIO' || variedade.Marca_comercial__c == 'DM Sementes') {
                            marcaProduct.add(variedade.Id);
                        } 
                    }
                    when 'NEOG' {
                        if (variedade.Marca_comercial__c == 'NEOGEN' || variedade.Marca_comercial__c == 'Neogen') {
                            marcaProduct.add(variedade.Id);
                        } 
                    }
                    when 'DAGMA' {
                        if (variedade.Marca_comercial__c == 'DAGMA' || variedade.Marca_comercial__c == 'Dagma') {
                            marcaProduct.add(variedade.Id);
                        }
                    }
                    when 'LICENÇAS' {
                        if (variedade.Marca_comercial__c == 'LICENÇAS' || variedade.Marca_comercial__c == 'Licenças') {
                            marcaProduct.add(variedade.Id);
                        }
                    }

                }
            }
        }
        
        for(Produto_de_Requisicao__c produto : requisitionProductList) {
            if(marcaProduct.size() == 0) {
                produto.addError('a estimativa tem uma marca diferente da empresa incluída nesta variedade');
            }
        }
    }

    public static void updateRequisitionProduct(List<Produto_de_Requisicao__c> requisitionProductList) {

        List<String> requisiciones = new List<String>();
        List<String> productosRequisiciones = new List<String>();
        List<String> variedades = new List<String>();

        List<Produto_de_Requisicao__c> updateProducts = new List<Produto_de_Requisicao__c>();

        for(Produto_de_Requisicao__c reqVar : requisitionProductList){
            variedades.add(reqVar.Variedad__c);
        }

        List<Variedad__c> variedadeList = [SELECT Id, Name
                                                FROM Variedad__c
                                                   WHERE Id IN : variedades];

        for(Produto_de_Requisicao__c req : requisitionProductList){
            requisiciones.add(req.Requisicao_de_compra__c);
        }

        List<Requisicao_de_compra__c> requisicionesList = [SELECT Id, Tipo__c, RecordType.Name 
                                                               FROM Requisicao_de_compra__c 
                                                                 WHERE Requisicao_de_compra__c IN : requisiciones];

        for(Requisicao_de_compra__c prodReq : requisicionesList){
            productosRequisiciones.add(prodReq.Id);
        }

        List<Produto_de_Requisicao__c> productTwoList = [SELECT Id, Name, Embalagem__c, Tratamento__c, Quantidade__c, Quantidade_de_Sementes__c, RecordTypeId 
                                                             FROM Produto_de_Requisicao__c 
                                                               WHERE Requisicao_de_compra__c IN : productosRequisiciones];

        for(Produto_de_Requisicao__c requisition : requisitionProductList) {
            for(Variedad__c variety : variedadeList) {
                if(requisition.Variedad__c==variety.Id) {
                    Produto_de_Requisicao__c productMap = new Produto_de_Requisicao__c();
                    if(requisition.Tipo__c == 'Multiplicador' && requisition.RecordTypeId == milhoRecordTypeId) {
                        productMap.Id = requisition.Id;
                        productMap.Name = variety.Name + '-' + requisition.Embalagem__c + '-' + requisition.Tratamento__c;
                        productMap.Quantidade_de_Sementes__c = requisition.Embalagem__c == 'Saca 60 Mil Sementes' ? requisition.Quantidade__c * 60000 : requisition.Quantidade__c * 5000000;
                    }
                    if(requisition.Tipo__c != 'Multiplicador' && requisition.RecordTypeId == milhoRecordTypeId) {
                          for(Produto_de_Requisicao__c product : productTwoList) {
                            productMap.Id = requisition.Id;
                            productMap.Name = variety.Name + '-' + 'Saca 60 Mil Sementes';
                            productMap.RecordTypeId = product.RecordTypeId;
                            productMap.Embalagem__c = 'Saca 60 Mil Sementes';
                            productMap.Quantidade__c = requisition.Quantidade__c;
                            productMap.Quantidade_de_Sementes__c = requisition.Quantidade__c * 60000;
                        }
                    }
                    updateProducts.add(productMap);
                }
            } 
        }

        try {
            update updateProducts;
        } catch (DmlException e) {
            System.debug('DML Error message: ' + e.getMessage());
        } 
    }
}
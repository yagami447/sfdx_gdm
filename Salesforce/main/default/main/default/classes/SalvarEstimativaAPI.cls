/**
* @name SalvarEstimativaAPI
* @author Jhonny Peroza
* updated 08-11-2021
*
* updated 04-jan-2022 pablo.fraquia@cloudgaia.com / Se le agrega un nuevo string al error message para aclarar el motivo del fallo en la llamada (from line 52 to 57)
*
* updated 25-jan-2022 pablo.fraquia@cloudgaia.com / Se cambia la logica de la API para que contemple los casos de editar e insertar una Requisicao_de_compra__c  (BUG 18829)
*/
@RestResource(urlMapping='/SalvarEstimativaAPI/*')
global with sharing class SalvarEstimativaAPI {

    @HttpPost
    global static void salvarEstimativa() {

        Response result = new Response();
        result.status = false;
		Savepoint savePoint = Database.setSavepoint(); 

        RestResponse response = RestContext.Response;
        response.headers.put('Content-Type', 'application/json');
        response.statusCode = 404;
            
        String requestString = RestContext.Request.requestBody.toString();
        Request requestParameters = (Request)JSON.deserialize(requestString, Request.class);

        String requisicaoId = requestParameters.requisicaoId;
        List<aSiteVendaDeBasicaController.ProductoRequisicion> items = requestParameters.items;
        List<aSiteVendaDeBasicaController.ProductoRequisicion> itemsToDelete = requestParameters.itemsToRemove;
        String multiplicadorId = requestParameters.multiplicadorId;
        String marca = requestParameters.marca;
        String tipo = requestParameters.tipo;
        String regiaoComercial = requestParameters.regiaoComercial;
        Boolean paraAprobacion = requestParameters.paraAprobacion;
        
        try {

            Configuracion_BMX__c config = [SELECT id, PM_Safra_Actual_VB_Estimativa_de_Compra__c 
                                                FROM Configuracion_BMX__c 
                                                    ORDER BY CreatedDate ASC 
                                                        LIMIT 1];

            String safraActualEstimativaCompra = config.PM_Safra_Actual_VB_Estimativa_de_Compra__c;
            String resultado = '';
            Boolean deleteStatus = true;

            if(!String.isEmpty(requisicaoId)) {

                List<Requisicao_de_compra__c> requisicao = [SELECT Id, Multiplicador__c, Marca__c, Safra__c, Tipo__c, Regiao_comercial__c, Cantidad_Productos__c  
                                                                FROM Requisicao_de_compra__c 
                                                                    WHERE Id =: requisicaoId 
                                                                        LIMIT 1];

                if(!requisicao.isEmpty()){

                    resultado = editCreateProduct(requisicaoId, items);
                    
                    if(!itemsToDelete.isEmpty()){

                        deleteStatus = removeProducts(requisicaoId, itemsToDelete); 
                    }
                    
                } else {

                    result.message = Label.SalvarEstimativaAPI_Clarification_Message;
                    DataBase.rollback(savePoint);
                }
            
            } else {
                
                resultado = saveRequisicao(multiplicadorId, marca, safraActualEstimativaCompra, tipo, regiaoComercial, items);
            }
            
            if(!deleteStatus){

                result.message = Label.SalvarEstimativaAPI_Products_Quantity_Error_Message;
                resultado = null;
                DataBase.rollback(savePoint);

            } else if(!String.isEmpty(resultado)){

                List<Requisicao_de_compra__c> testResult = [SELECT Id, Multiplicador__c, Marca__c, Safra__c, Tipo__c, Regiao_comercial__c, Cantidad_Productos__c  
                                                                FROM Requisicao_de_compra__c 
                                                                    WHERE Id =: resultado 
                                                                        LIMIT 1];
        
                if(paraAprobacion){

                    requisicaoSumbitForApproval(resultado);
                }

                result.Id = resultado;
                result.message = Label.SalvarEstimativaAPI_Success_Message;
                result.status = true;
                response.statusCode = 200;
            } 
            
        } catch (Exception e) {

            String error = e.getMessage();

            if(error.contains('ALREADY_IN_PROCESS,')){

                error = error.split('ALREADY_IN_PROCESS,')[1];
            }

            result.message = Label.SalvarEstimativaAPI_Default_Error_Message + ':  ' +error;
            result.status = false;  
            response.statusCode = 404;
            DataBase.rollback(savePoint);
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
    }

    private static String saveRequisicao(String multiplicadorId, String marca, String safra, String tipo, String regionComercial, List<aSiteVendaDeBasicaController.ProductoRequisicion> products) {

        List<Produto_de_Requisicao__c> listProdutoDeRequisicao = new List<Produto_de_Requisicao__c>();
        
        Requisicao_de_compra__c requisicaoDeCompra = new Requisicao_de_compra__c();
        requisicaoDeCompra.Multiplicador__c = multiplicadorId;
        requisicaoDeCompra.Marca__c = marca;
        requisicaoDeCompra.Safra__c = safra;
        requisicaoDeCompra.Tipo__c = tipo;
        requisicaoDeCompra.Regiao_comercial__c = regionComercial;
        insert requisicaoDeCompra;

        for(aSiteVendaDeBasicaController.ProductoRequisicion pr : products) {

            Produto_de_Requisicao__c produtoDeRequisicao = new Produto_de_Requisicao__c();
            produtoDeRequisicao.Quantidade__c = pr.cantidad;
            produtoDeRequisicao.Variedad__c = pr.variedadId;
            produtoDeRequisicao.Requisicao_de_compra__c = requisicaoDeCompra.Id;
            listProdutoDeRequisicao.add(produtoDeRequisicao);
        }
        
        if(!listProdutoDeRequisicao.isEmpty()) {
            insert listProdutoDeRequisicao;
        }

        return requisicaoDeCompra.Id;
    }

    private static String editCreateProduct(String requisicaoId, List<aSiteVendaDeBasicaController.ProductoRequisicion> products){

        List<Produto_de_Requisicao__c> productList = new List<Produto_de_Requisicao__c>();
        Map<Id, Produto_de_Requisicao__c> productByVariedad = new  Map<Id, Produto_de_Requisicao__c>();

        List<Produto_de_Requisicao__c> existingProductsList = [SELECT Id, Variedad__c, Quantidade__c 
                                                                   FROM Produto_de_Requisicao__c 
                                                                       WHERE Requisicao_de_compra__c = :requisicaoId];
            
            for(Produto_de_Requisicao__c pr : existingProductsList) {
    
                productByVariedad.put(pr.Variedad__c, pr);
            }
    
            for(aSiteVendaDeBasicaController.ProductoRequisicion product :products){
                    
                if(productByVariedad.containsKey(product.variedadId)){
    
                    Produto_de_Requisicao__c editableProduct = productByVariedad.get(product.variedadId);
                    editableProduct.Quantidade__c = product.cantidad;
                    productList.add(editableProduct);
    
                } else {
    
                        Produto_de_Requisicao__c produtoDeRequisicao = new Produto_de_Requisicao__c();
                        produtoDeRequisicao.Quantidade__c = product.cantidad;
                        produtoDeRequisicao.Variedad__c = product.variedadId;
                        produtoDeRequisicao.Requisicao_de_compra__c = requisicaoId;
                        productList.add(produtoDeRequisicao);
                    }
            }

        upsert productList;
        return requisicaoId;
    }

    private static Boolean removeProducts(String requisicaoId, List<aSiteVendaDeBasicaController.ProductoRequisicion> productsToDelete){

        List<Produto_de_Requisicao__c> listProdutoDeRequisicaoForDelete = new List<Produto_de_Requisicao__c>();
        List<Produto_de_Requisicao__c> existingProductsList = [SELECT Id, Variedad__c, Quantidade__c, Requisicao_de_compra__r.Cantidad_Productos__c 
                                                                    FROM Produto_de_Requisicao__c 
                                                                        WHERE Requisicao_de_compra__c = :requisicaoId];
        
        Map<Id, Produto_de_Requisicao__c> productByVariedad = new  Map<Id, Produto_de_Requisicao__c>();
        Boolean status = true;
 
        for(Produto_de_Requisicao__c pr : existingProductsList) {

            productByVariedad.put(pr.Variedad__c, pr);
        }
  
        if(productsToDelete.size() < existingProductsList[0].Requisicao_de_compra__r.Cantidad_Productos__c){

            for(aSiteVendaDeBasicaController.ProductoRequisicion productToDelete :productsToDelete){

                if(productByVariedad.containsKey(productToDelete.variedadId)){
                    Produto_de_Requisicao__c productToRemove = productByVariedad.get(productToDelete.variedadId);
                    listProdutoDeRequisicaoForDelete.add(productToRemove);
                }
            }

            delete listProdutoDeRequisicaoForDelete;

        } else{

            status = false;
        }

        return status;
    }

    private static void requisicaoSumbitForApproval(String reqId) {     
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(reqId);
            Approval.ProcessResult result = Approval.process(req);
        }

    public class Response {
        public String id;
        public Boolean status;
        public String message;
    }
    
    public class Request {
        public List<aSiteVendaDeBasicaController.ProductoRequisicion> items;
        public List<aSiteVendaDeBasicaController.ProductoRequisicion> itemsToRemove;
        public String requisicaoId;
        public String multiplicadorId;
        public String marca;
        public String tipo;
        public String regiaoComercial;
        public Boolean paraAprobacion;
    }
}
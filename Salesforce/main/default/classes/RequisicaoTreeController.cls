public class RequisicaoTreeController {

    public String totalLabel    {get; set;}
    
    @AuraEnabled 
    public static List<Produto_de_Requisicao__c> getProdutoRequisicao(Id requisitionId, 
                                                                      String pageSize,
                                                                      String pageNumber) {
        
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
        return [
            SELECT Id, Name, Multiplicador__c,  Quantidade__c, Tipo__c,
            (SELECT Name, Multiplicador__c,Tipo__c, Quantidade__c, Quantidade_de_Sementes__c
             FROM Produtos_de_Requisi_o__r )
            FROM Produto_de_Requisicao__c
            WHERE Requisicao_de_compra__c = :requisitionId  
            LIMIT :Integer.valueOf(psize) OFFSET :(psize*pnumber)
        ];
    }
  
    @AuraEnabled 
    public static List<WrapperRequisionDeCompra> getProdutos(Id requisitionId) {  
        System.debug(' GET PROD ' + requisitionId);
        Requisicao_de_compra__c requisicao = [
            SELECT Name, Tipo__c, Marca__c, Regiao_comercial__c, Ownerid, Owner.name,
            Multiplicador__c, Multiplicador__r.name,Requisicao_de_compra__c,
            Requisicao_de_compra__r.Name, RecordType.Name
            FROM Requisicao_de_compra__c
            WHERE Id = :requisitionId
        ]; 
        
        List<Produto_de_Requisicao__c> requisitionProducts = [SELECT Id, Name, Quantidade__c, Variedad__c, Embalagem__c, Tratamento__c
                                                                FROM Produto_de_Requisicao__c
                                                                WHERE Requisicao_de_compra__c = :requisicao.Id];
        
        List<Variedad__c> varietys = [SELECT Id, Name, Nombre_de_Registro__c
                                        FROM Variedad__c
                                        WHERE Disponivel_para_venda_basica__c = true
                                        AND Sociedad__c = :requisicao.Marca__c
                                        AND Regiao_disponivel_para_venda_basica__c INCLUDES (:requisicao.Regiao_comercial__c)
                                        ];

        Map<Id, List<Produto_de_Requisicao__c>> productsByVariety = getChildProducts(requisitionId);  
        Map<Id, Produto_de_Requisicao__c> existingProductByVariety = getExistingProducts(requisitionId);
       
        List<WrapperRequisionDeCompra> requisitions = new List<WrapperRequisionDeCompra>();

        for(Variedad__c v : varietys){
            WrapperRequisionDeCompra wrapper;
            if (!existingProductByVariety.containsKey(v.id)) {
                wrapper = new WrapperRequisionDeCompra(v, requisicao.tipo__c, requisicao);
            } else {
                wrapper = new WrapperRequisionDeCompra(existingProductByVariety.get(v.id), requisicao.tipo__c, true);
            }
                           
            if(productsByVariety.containsKey(v.id)){
                for(Produto_de_Requisicao__c product : productsByVariety.get(v.id)){
                    wrapper.addProduct(product);
                }
            }
            requisitions.add(wrapper);
        }
        
        System.debug(productsByVariety);
        System.debug(existingProductByVariety);
        System.debug(requisitions);
        return requisitions;
    }

    public static Map<Id, Produto_de_Requisicao__c> getExistingProducts(Id requisitionId) {    
        
        Map<Id, Produto_de_Requisicao__c> productByVariety = new Map<Id, Produto_de_requisicao__c>();
        
        List<Produto_de_Requisicao__c> existingProducts = [
            SELECT Id, Name, Multiplicador__c,  Quantidade__c, Quantidade_de_Sementes__c, Tipo__c, 
            Variedad__r.Name, Embalagem__c, Tratamento__c, Requisicao_de_compra__r.Owner.Name,Produto_principal__c ,
            Produto_principal__r.Multiplicador__c,
            Requisicao_de_compra__r.OwnerId,Variedad__c,Requisicao_de_compra__r.Tipo__C, 
            Requisicao_de_compra__r.name, Requisicao_de_compra__c,
            Requisicao_de_compra__r.Multiplicador__c,
            Requisicao_de_compra__r.Marca__c, 
            Requisicao_de_compra__r.regiao_comercial__c,
            RecordType.Name,
            Requisicao_de_compra__r.RecordType.Name
            FROM Produto_de_Requisicao__c
            WHERE Requisicao_de_compra__c = :requisitionId 
    
        ];
        
        for (Produto_de_Requisicao__c p : existingProducts) {
            productByVariety.put(p.variedad__c, p);
        }

        return productByVariety;
    }
  
    public static  Map<Id, List<Produto_de_Requisicao__c>> getChildProducts(Id requisitionId) {    
        List<Produto_de_Requisicao__c> childProducts = [
            SELECT Id, Name, Multiplicador__c,  Quantidade__c, Quantidade_de_Sementes__c, Tipo__c, Variedad__r.Name, Embalagem__c, Tratamento__c,
            Requisicao_de_compra__r.Owner.Name, Requisicao_de_compra__r.OwnerId,
            Variedad__c,Requisicao_de_compra__r.Tipo__C, Requisicao_de_compra__r.name,
            Requisicao_de_compra__c,Requisicao_de_compra__r.Multiplicador__c, 
            Requisicao_de_compra__r.Marca__c,
            Requisicao_de_compra__r.regiao_comercial__c,    
            RecordType.Name,
            Requisicao_de_compra__r.RecordType.Name
            FROM Produto_de_Requisicao__c
            WHERE Requisicao_de_compra__r.Requisicao_de_compra__c = :requisitionId
            AND Requisicao_de_compra__r.Estado__c = 'Aprovada'
            
        ];
        
        Map<Id, List<Produto_de_Requisicao__c>> productsByVariety = new Map<Id, List<Produto_de_requisicao__c>>();
        
        for (Produto_de_Requisicao__c product : childProducts) {
            
            if (!productsByVariety.containsKey(product.Variedad__c)) {
                productsByVariety.put(product.Variedad__c, new List<Produto_de_Requisicao__c>());
            }
            
            productsByVariety.get(product.Variedad__c).add(product);
        }
        
        return productsByVariety;
    }
   
    @AuraEnabled
    public static void save(String productsWrapperJSON, Id reqId){ 
        List<WrapperRequisionDeCompra> productsWrapper =(List<WrapperRequisionDeCompra>)System.JSON.deserialize(productsWrapperJSON, List<WrapperRequisionDeCompra>.class);
        List<Produto_de_requisicao__c> products = new List<Produto_de_requisicao__c>();
    
        for (WrapperRequisionDeCompra p : productsWrapper) {
            products.add(p.getProduct(reqId));
        }   
        System.debug('### products ###' + products);
        upsert products;
    }
}
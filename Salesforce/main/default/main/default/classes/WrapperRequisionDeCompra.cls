public class WrapperRequisionDeCompra {

    public static final Decimal SACOS = 83.33;
    public static Id milhoRecordType = Schema.SObjectType.Produto_de_Requisicao__c.getRecordTypeInfosByDeveloperName().get('Milho').getRecordTypeId();
    
    @AuraEnabled public Id  productId                          {get; set;}
    @AuraEnabled public Decimal  quantity                      {get; set;}
    @AuraEnabled public Decimal  managerQuantity               {get; set;}
    @AuraEnabled public Decimal sementes                       {get; set;}
    @AuraEnabled public String  type                           {get; set;}
    @AuraEnabled public List<WrapperRequisionDeCompra> childs  {get; set;}
    @AuraEnabled public String  owner                          {get; set;}
    @AuraEnabled public String  ownerId                        {get; set;}
    @AuraEnabled public String  marca                          {get; set;}
    @AuraEnabled public String  region                         {get; set;}
    @AuraEnabled public String varietyName                     {get; set;}
    @AuraEnabled public String varietyEmbalagem                {get; set;}
    @AuraEnabled public String varietyTratamento               {get; set;}
    @AuraEnabled public String embalagem                       {get; set;}
    @AuraEnabled public String tratamento                      {get; set;}
    @AuraEnabled public String  reqName                        {get; set;}
    @AuraEnabled public String  reqId                          {get; set;}
    @AuraEnabled public variedad__c variety                    {get; set;}
    @AuraEnabled public Boolean parentProduct                  {get; set;}
    @AuraEnabled public String cuenta                          {get; set;}
    @AuraEnabled public Id multiplica                          {get; set;}
    
    public WrapperRequisionDeCompra(Variedad__c variety, String rType, 
                                    Requisicao_de_compra__c req) {
        quantity = 0;
        managerQuantity = 0;
        this.type = rType;
        this.variety = variety;
        this.varietyName = variety.name;
        childs = new List<WrapperRequisionDeCompra> (); 
        owner = '';

        if(req.RecordType.Name == 'Milho') {
          this.varietyEmbalagem = 'Saca 60 Mil Sementes';
        }
       
        this.parentProduct = true;
        this.marca = req.marca__c;
        this.region = req.regiao_comercial__c;
        this.reqId = req.Id;
        this.reqName = req.Name;
        
        if (rType == 'Multiplicador') {
          ownerId = req.Multiplicador__c;
            owner = req.Multiplicador__r.name;
        } else {
          ownerId = req.OwnerId;
            owner = req.Owner.Name;
            multiplica = req.Multiplicador__c;          
        }
    }

    public WrapperRequisionDeCompra(Produto_de_requisicao__c p, String rType,
                                    Boolean parentProduct) {
        productId = p.id;
        if (parentProduct) { 
            managerQuantity = p.Quantidade__c;
            quantity = 0;
        } else {
            quantity = p.Quantidade__c;
        }
        
        this.type = type;
        childs = new List<WrapperRequisionDeCompra> ();
        this.marca = p.Requisicao_de_compra__r.marca__c;
        this.region = p.Requisicao_de_compra__r.regiao_comercial__c;
        this.reqId = p.Requisicao_de_compra__c;
        this.reqName = p.Requisicao_de_compra__r.Name;
        this.type = rType;
        this.embalagem = p.Embalagem__c;
        this.tratamento = p.Tratamento__c;

        if (rType == 'Multiplicador') {
          ownerId = p.Requisicao_de_compra__r.Multiplicador__c;
          owner = p.Multiplicador__c;
          cuenta = p.Multiplicador__c;
        } else {
          ownerId = p.Requisicao_de_compra__r.OwnerId;
          owner = p.Requisicao_de_compra__r.Owner.Name;
          cuenta = p.Multiplicador__c;
        }
        this.variety = p.Variedad__r;
        this.varietyName =  p.Variedad__r.name;
        this.varietyEmbalagem = p.Requisicao_de_compra__r.RecordType.Name == 'Milho' ? 'Saca 60 Mil Sementes' : null;
    }
    
    public void addProduct(Produto_de_requisicao__c p) {
        childs.add(new WrapperRequisionDeCompra(p, p.Requisicao_de_compra__r.Tipo__c, false));
        quantity += p.RecordType.Name == 'Milho' && p.Embalagem__c == 'Bag 5 Milhões Sementes' ? (SACOS * p.Quantidade__c).round(system.RoundingMode.CEILING) : p.Quantidade__c;
    }
        
    public Produto_de_requisicao__c getProduct(Id rqId) {
      
        Requisicao_de_compra__c queryRequisicao = [SELECT Id, RecordType.Name, Requisicao_de_compra__c
                                                        FROM Requisicao_de_compra__c 
                                                           WHERE Requisicao_de_compra__c =: rqId LIMIT 1];

        Produto_de_requisicao__c p = new Produto_de_requisicao__c();

        if(queryRequisicao.RecordType.Name == 'Milho') {    

            Produto_de_Requisicao__c queryProduct = [SELECT Id, Name, Embalagem__c, Quantidade__c, Tratamento__c, RecordType.Name
                                                          FROM Produto_de_Requisicao__c 
                                                             WHERE Requisicao_de_compra__c =: queryRequisicao.Id 
                                                                  AND Quantidade__c != 0 
                                                                  AND Oportunidade__c = null LIMIT 1];
            p.id = productId;
            p.Name = queryProduct.Name;
            p.Embalagem__c = embalagem;
            p.Tratamento__c = tratamento;
            p.Variedad__c = variety.id;
            p.Quantidade__c = managerQuantity;
            p.Requisicao_de_compra__c = rqId;
            p.RecordTypeId = milhoRecordType;
        
        } else {

            p.id = productId;
            p.Name = varietyName;
            p.Variedad__c = variety.id;
            p.Quantidade__c = managerQuantity;
            p.Requisicao_de_compra__c = rqId;
            
        }

        return p;
    }
}
public without sharing class itemsContrato2Controller {

    public Contrato__c theContrat {get;set;}
    public Item_del_contrato__c[] shoppingCart {get;set;}
    public Item_del_contrato__c[] AvailableProducts {get;set;}
    public String searchString {get;set;}
    public String toSelect {get; set;}
    public String toUnselect {get; set;}    
    public Boolean overLimit {get;set;}
    private Integer contador = 0;
    private List<String> tecnologiasViejas;
    private List<String> tecnologiesNuevos;
    
    private Item_del_contrato__c[] forDeletion = new Item_del_contrato__c[]{}; 
    
    private Map<String, Schema.SObjectField> objectFields_Items = Schema.getGlobalDescribe().get('Item_del_contrato__c').getDescribe().fields.getMap();     
    private Map<String, Schema.SObjectField> objectFields_cont = Schema.getGlobalDescribe().get('Contrato__c').getDescribe().fields.getMap();
    private Map<String, Schema.SObjectField> objectFields_ref_precio = Schema.getGlobalDescribe().get('Referencia_de_Preco__c').getDescribe().fields.getMap();
    private Map<String, Schema.SObjectField> objectFields_ref_plaza = Schema.getGlobalDescribe().get('Referencia_de_Praca__c').getDescribe().fields.getMap();
    
    public String marca;
    private String tipoReferencia;
    private String multiplicador;
    private String safra;
    private String safraAnt;
    private Map<String, Referencia_de_Preco__c> mapRefPrecio = new Map<String, Referencia_de_Preco__c>();
    private Map<String, Referencia_de_Praca__c> mapRefPraca = new Map<String, Referencia_de_Praca__c>();
        
    public Set<Id> basicaSel = New Set<Id>();
   
    public itemsContrato2Controller(ApexPages.StandardController controller) {
        tecnologiasViejas = new List<String> {'RR', 'IPRO', null};
        tecnologiesNuevos = new List<String> {'CE', 'E', 'I2X'};
        try{

            map<Id, User> propRol = New map<Id, User>();
            List<Referencia_de_Preco__c> refPrecio = new List<Referencia_de_Preco__c>();
            List<Referencia_de_Praca__c> refPraca = new List<Referencia_de_Praca__c>();
                
            String query = 'SELECT ';
            for(String s : objectFields_cont.keySet())
                query += ' ' + s + ',';      
            query += 'RecordType.Name, Multiplicador__r.Name, Multiplicador__r.Tipo_de_Referencia__c, RecordType.DeveloperName FROM Contrato__c Where Id = \'' + controller.getRecord().Id + '\' limit 1';        
            theContrat = Database.query(query);
            
            marca = theContrat.Sociedad__c;
            tipoReferencia = theContrat.Multiplicador__r.Tipo_de_Referencia__c;
            multiplicador = theContrat.Multiplicador__c;
            safra = theContrat.Safra__c;
            safraAnt = String.valueOf(Integer.valueOf(safra.substring(0,2)) - 1) + '/' + String.valueOf(Integer.valueOf(safra.substring(3,5)) - 1);             
                
            // Obtengo los productos ya cargados a la opp y los cargo como "Seleccionados"
            String queryItems = 'SELECT ';
            for(String s : objectFields_Items.keySet())
                    queryItems += ' ' + s + ',';                                    
            queryItems += ' Cultivar__r.Name, Contrato_de_Multiplicacion__r.Sociedad__c FROM Item_del_contrato__c Where RecordType.Name = \'Volumen\' and Contrato_de_Multiplicacion__c = \'' + theContrat.Id + '\' Order by Cultivar__r.Name';
            
            shoppingCart = Database.query(queryItems);
            for(Item_del_contrato__c o: shoppingCart){
                o.Indice__c = contador;
                contador++;
            }
            for(User u: [SELECT Id, UserRole.Name, Profile.Name FROM User]){
                propRol.put(u.Id, u);
            }
            
            //************************* Obtengo de una vez todos los registros de referencia de precio para la region de la cuenta
            String queryRef = 'SELECT ';
            for(String s : objectFields_ref_precio.keySet())
                queryRef += ' ' + s + ',';      
            queryRef += ' Variedad__r.Name FROM Referencia_de_Preco__c Where Tipo_de_Referencia__c = \'' + tipoReferencia + '\'';
            refPrecio = Database.query(queryRef);
            for(Referencia_de_Preco__c r:refPrecio){
                mapRefPrecio.put(r.Variedad__c, r);
            }            
            
            //************************* Obtengo de una vez todos los registros de referencia de plazas para la cuenta y safra            
            queryRef = 'SELECT ';
            for(String s : objectFields_ref_plaza.keySet())
                queryRef += ' ' + s + ',';      
            queryRef += ' Conta__r.Name FROM Referencia_de_Praca__c Where Safra__c = \'' + theContrat.Safra__c + '\' and Conta__c = \'' + theContrat.Multiplicador__c + '\'';
            refPraca = Database.query(queryRef);
            for(Referencia_de_Praca__c r:refPraca){
                mapRefPraca.put(r.Tipo_de_Cotacao__c, r);
            }
               
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return;        
        }
        
    }
   
    //agregados
    public void updateAvailableList() {
    
        Product2[] queryProducts;        
                  
        // Consultamos las variedades de AII safra anterior y VB safra actual para validar que solo se agreguen al contrato esas variedades        
        List<String> variedades = New List<String>(); 
        List<OpportunityLineItem> olis = [
            Select Id, PricebookEntry.Product2.Variedade__c 
            From OpportunityLineItem 
            Where (
                    (
                        Opportunity.RecordType.Name = 'Anexo II' And 
                        Opportunity.Safra__c = :safraAnt And 
                        Opportunity.StageName = 'Aprobada'
                    ) 
                    Or 
                    (
                        (
                            (
                                (
                                    Opportunity.RecordType.Name = 'VB - Autorizada' OR
                                    Opportunity.RecordType.Name = 'VB - Pasada SAP' OR
                                    Opportunity.RecordType.Name = 'Venda da Basica Completo'
                                )
                                AND
                                (
                                    Opportunity.StageName = 'AU - Autorizada' OR
                                    Opportunity.StageName = 'Aprobada' OR
                                    Opportunity.StageName = 'Revisão do administrador de vendas' OR
                                    Opportunity.StageName = 'Na aprovação do multiplicador'
                                )
                            ) 
                            Or 
                            (
                                Opportunity.RecordType.Name = 'Aquisição Sementes Terceiros' And 
                                Opportunity.StageName = 'Aprobada'
                            )
                        ) 
                        And 
                        Opportunity.Safra__c = :safra
                    )
                  ) And Opportunity.AccountId = :multiplicador And Categoria__r.Name != 'S2'
        ];
        for (OpportunityLineItem i : olis)
            variedades.add(i.PricebookEntry.Product2.Variedade__c);            

        List<String> tecnologies = new list<String>();
        if (theContrat.recordtype.DeveloperName == 'Termo_Aditivo_Lan_amentos') {
            tecnologies = tecnologiesNuevos;
        } else {
            tecnologies = tecnologiasViejas;
        }

        // Construimos un query dinamico sobre los productos de la lista de precios
        String qString = 'Select Id, Name, Obtentor__c, IsActive, Variedade__c, pruebaNV__c, Sociedad__c, Variedade__r.Name ';
        qString += ' from Product2';
        qString += ' where Categ__r.Name = \'BASICA\' and Variedade__r.Ativa__c = true and Variedade__c != null and isActive = true And Family = \'Royalty x Basica\' and sociedad__c = :marca ';
        qString += ' and Variedade__c in :variedades ';
    
        if(Userinfo.getUserRoleId() == '00E40000001C6eWEAS'){
            qString += 'and licenciada__c = true ';
        }
        else
            qString += 'and licenciada__c = false ';
     
        if(searchString!=null){
            qString+= 'and (pruebaNV__c like \'%' + searchString + '%\' or Name like \'%' + searchString + '%\' or Description like \'%' + searchString +  '%\') ';
        }
        
        //qString+= 'and Variedade__r.Tecnologia__c IN :tecnologies ';
        qString+= 'and (Variedade__r.Tecnologia__c IN :tecnologiesNuevos or Variedade__r.Tecnologia__c IN :tecnologiasViejas) ';
        qString+= ' order by Variedade__r.Name';
        qString+= ' limit 31';
        
        system.debug('qString:' +qString);        
        queryProducts = database.query(qString);
        
        AvailableProducts = New List<Item_del_Contrato__c>();
        
        
        
        for(Product2 p: queryProducts){
            Decimal precio = 0;
            String tipoCot = '';
            String idRef = null;
            String idRef2 = null;
            String plaza = '';
            Referencia_de_Preco__c rr = mapRefPrecio.get(p.Variedade__c);
            Referencia_de_Praca__c rr2;
            if(rr != null){            
                precio = rr.Preco__c;
                tipoCot = rr.Tipo_de_Cotacao__c;
                idRef = rr.Id;
                rr2 = mapRefPraca.get(rr.Tipo_de_Cotacao__c);
                if(rr2 != null){
                    plaza = rr2.Praca__c;
                    idRef2 = rr2.Id;
                }
            }
            
            Id itemRTId = Schema.SObjectType.Item_del_Contrato__c.getRecordTypeInfosByName().get('Volumen').getRecordTypeId();
            Item_del_contrato__c i = new Item_del_Contrato__c(RecordTypeId=itemRTId,Cultivar__c=p.Id,Cultivar__r=p,Variedad__c=p.Variedade__c,Name=p.Variedade__r.Name,Referencia_de_Preco__c=idRef,Referencia_de_Praca__c=IdRef2,Tipo_de_Referencia__c=tipoReferencia,Cotacao_de_soja__c=tipoCot,Precio__c=precio,Praca__c=plaza);
            AvailableProducts.add(i);
        }
        
        // Solo se mostraran hasta 30 registros... si el query tiene mas, entonces el usuario vera un mensaje
        if(AvailableProducts.size()==31){
            AvailableProducts.remove(30);
            overLimit = true;
        }
        else{
            overLimit=false;
        }        
        
    }
   
    public PageReference onSave(){
    
        List<Item_del_contrato__c> deleteVB = New List<Item_del_contrato__c>();
        List<Item_del_contrato__c> insertVB = New List<Item_del_contrato__c>();
        Item_del_contrato__c cloneVB = New Item_del_contrato__c();
        Boolean ofPend = false;

        Savepoint sp;
        try{        
            // Los datos ya cargados deben ser actualizados
            sp = Database.setSavepoint();
            if(forDeletion.size()>0)
                delete(forDeletion);
               
            if(shoppingCart.size()>0)
                upsert(shoppingCart);
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            Database.rollback(sp);
            return null;
        }  
        
        String nextlink = '/' + ApexPages.currentPage().getParameters().get('Id');
        PageReference nextPage = new PageReference(nextlink);
        nextPage.setRedirect(true);
        return nextPage;
    }
   
    public PageReference onCancel(){
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
   
    public void addToShoppingCart(){
        for(Item_del_contrato__c d : AvailableProducts){
            
            if((String) d.Cultivar__c == toSelect){  
                System.debug(d);
                d.Indice__c = contador;
                d.Contrato_de_Multiplicacion__c = theContrat.Id;
                d.Contrato_de_Multiplicacao_vol__c = theContrat.Id;
                shoppingCart.add(d);
                contador++;
                break;
            }
        }
    }
    
    public PageReference removeFromShoppingCart(){    
        // Cuando el usuario presiona "Eliminar" en un producto seleccionado    
        Integer count = 0;    
        for(Item_del_contrato__c d : shoppingCart){
            if(String.valueOf(d.Indice__c)==toUnselect){
            
                if(d.Id!=null)
                    forDeletion.add(d);
            
                shoppingCart.remove(count);
                break;
            }
            count++;
        }
        
        updateAvailableList();        
        return null;
    }
   
}
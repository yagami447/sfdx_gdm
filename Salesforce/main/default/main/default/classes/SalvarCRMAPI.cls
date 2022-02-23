@RestResource(urlMapping='/SalvarCRMAPI/*')
global without sharing class SalvarCRMAPI {

    public static final String SUCCESSMESSAGE = 'Salvo com sucesso no objeto CRM';
    public static final String DEFAULTERRORMESSAGE = 'Não foi possível salvar o CRM:  ';
    public static final String FIRSTERRORMESSAGE = 'Falha ao salvar devido a um problema com status de CRM';
    public static final String SECONDERRORMESSAGE = 'Falha ao salvar devido a um problema com itens de CRM';
    

    @HttpPost
    global static void salvarCRM() {


        Response result = new Response();
        result.status = false;
    Savepoint savePoint = Database.setSavepoint(); 

        RestResponse response = RestContext.Response;
        response.headers.put('Content-Type', 'application/json');
        response.statusCode = 404;
            
        String requestString = RestContext.Request.requestBody.toString();
        Request requestParameters = (Request)JSON.deserialize(requestString, Request.class);

        String crmId = requestParameters.crmId;
        List<WrapperCRM.Items> items = requestParameters.items;
        List<WrapperCRM.Items> itemsToRemove = requestParameters.itemsToRemove;
        List<WrapperCRM.Estados> estados = requestParameters.estados;
        List<WrapperCRM.Estados> estadosToRemove = requestParameters.estadosToRemove;
        WrapperCRM.Crm crm = requestParameters.crm;
        Boolean aprobacion = requestParameters.aprobacion;
         
        try {

            Boolean estadosResult = false;
            Boolean itemsResult = false;
            
            if (String.isEmpty(crmId)) {
                
                crmId = createCRM(crm);
            }

            if(!estadosToRemove.isEmpty()){

                eliminarEstados(estadosToRemove);
             }
 
             if(!itemsToRemove.isEmpty()){
 
                 eliminarItems(itemsToRemove);
             }

            if(estados.isEmpty()){

                estadosResult = true;
            
            } else {

                estadosResult = validateAndSaveEstados(crmId, estados);
            }
           
            if (estadosResult) {
                
                if(items.isEmpty()){

                    itemsResult = true;

                } else {

                    itemsResult = validateAndSaveItems(crmId, items);
    
                    if(!itemsResult){
    
                        result.message = SECONDERRORMESSAGE;
                        DataBase.rollback(savePoint);
                    }
                }

            } else {

                result.message = FIRSTERRORMESSAGE;
                DataBase.rollback(savePoint);
            }

            if(estadosResult && itemsResult){

                if (aprobacion) {

                    Boolean approvalResult = sendCRMForApproval(crmId);
                }

                result.message = SUCCESSMESSAGE;
                result.status = true;
                result.Id = crmId;  
                response.statusCode = 200;
                response.responseBody = Blob.valueOf(JSON.serialize(result));
            }
            

        } catch (Exception e) {

            result.message = DEFAULTERRORMESSAGE + e.getMessage();
            DataBase.rollback(savePoint);
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }

    public static Boolean validateAndSaveEstados(String crmId, List<WrapperCRM.Estados> estados) {

        Boolean status;
        Decimal total = 0.00;

        for(Estado_para_CRM__c estate : [SELECT Id, Percentagem_de_venda__c FROM Estado_para_CRM__c WHERE CRM__c = :crmId]) {

            total += estate.Percentagem_de_venda__c;
        }

        List<Estado_para_CRM__c> estadosToUpsert = new List<Estado_para_CRM__c>();

        for(WrapperCRM.Estados est : estados) {

            Estado_para_CRM__c estado = new Estado_para_CRM__c();

            estado.CRM__c = crmId;
            estado.Name = est.nombre;
            estado.Estado__c = est.nombreEstado;
            estado.Percentagem_de_venda__c = est.porcentaje;
            estadosToUpsert.add(estado);
            total = total + est.porcentaje;
        }

        if(total == 100.00) {

            try {

                insert estadosToUpsert;
                status=true;

            } catch(DmlException e) {

                System.debug('Error al actualizar/ insertar los items' + e.getMessage());
                status=false;
            }

        } else {

            status=false;
        }

        return status;
    }

    public static Boolean validateAndSaveItems(String crmId, List<WrapperCRM.Items> items) {

        Boolean status;
        List<Item_de_resumo_da_conta__c> itemsToUpsert = new List<Item_de_resumo_da_conta__c>();

        Map<String,String> productIdByObtentor = getProductosOutro();
        productIdByObtentor = createProductosOutro(productIdByObtentor, items);

        for(WrapperCRM.Items item : items) {

            Item_de_resumo_da_conta__c itemResumoDaConta = new Item_de_resumo_da_conta__c();

            itemResumoDaConta.Resumo_da_conta__c = crmId;
            itemResumoDaConta.Name = item.nombre;
            itemResumoDaConta.Obtentor__c = item.obtentor;
            itemResumoDaConta.Produto__c = productIdByObtentor.get(item.obtentor);

            itemsToUpsert.add(itemResumoDaConta);
        }

        try {

            insert itemsToUpsert;
            status=true;

        } catch(DmlException e) {
            
            System.debug('Error al actualizar/ insertar los items' + e.getMessage());
            status=false;
        }

        return status;
    }

    public static Boolean sendCRMForApproval(String crmId) {

        Boolean status;

        Resumo_da_conta__c rowCRM = [SELECT Fase__c FROM Resumo_da_conta__c WHERE Id =: crmId];

        rowCRM.Fase__c = 'Pendente';

        try {

            update rowCRM;
            status=true;

        } catch(DmlException e) {
            System.debug('DML Error message: ' + e.getMessage());
            status=false;
        }

        return status;
    }

    public static Id createCRM (WrapperCRM.Crm  crm) {

        List<Configuracion_BMX__c> config = [SELECT Id, PM_Safra_Actual_Eventos__c FROM Configuracion_BMX__c LIMIT 1];
        
        String safra = config[0].PM_Safra_Actual_Eventos__c;

        Resumo_da_conta__c newCrm = new Resumo_da_conta__c();
        newCrm.Capacidade_de_UBS__c = crm.capacidadUBS;
        newCrm.Producao_total_safra_anterior__c = crm.produccionTotalesSafraAnterior;
        newCrm.Vendas_totais_safra_anterior__c = crm.ventasTotalesSafraAnterior;
        newCrm.Numero_de_vendedores__c = crm.numeroDeVendedores;
        newCrm.Numero_de_unidades__c = crm.numeroDeUnidades;
        newCrm.Projecao_de_producao_safra_anual__c = crm.proyeccionProduccionSafraAnual;
        newCrm.Projecao_de_vendas_safra_anual__c = crm.proyeccionVentaSafraAnual;
        newCrm.Vendas_para_agricultores__c = crm.ventaAgricultores;
        newCrm.Marca__c = crm.marca;
        newCrm.Safra__c = safra;
        newCrm.Name = crm.nombre;
        newCrm.Multiplicador__c = crm.accountId;

        try {

           insert newCrm;

        } catch(DmlException e) {

            System.debug('DML Error message: ' + e.getMessage());
        }

        return newCrm.Id;
    }

    public static void eliminarEstados(List<WrapperCRM.Estados> estados) {

        List<Estado_para_CRM__c> estadosToDelete = new List<Estado_para_CRM__c>();

        for(WrapperCRM.Estados est : estados){

            Estado_para_CRM__c estado = new Estado_para_CRM__c();

            if (est.id != null) {
                
                estado.Id = est.id;
                estadosToDelete.add(estado);
            } 
        }

        try {

            delete estadosToDelete;
 
        } catch(DmlException e) {

            System.debug('Error al eliminar estados' + e.getMessage());  
        } 
    }

    public static void eliminarItems(List<WrapperCRM.Items> items) {

       
        List<Item_de_resumo_da_conta__c> itemsToDelete = new List<Item_de_resumo_da_conta__c>();

        for(WrapperCRM.Items item : items){

            Item_de_resumo_da_conta__c itemResumoDaConta = new Item_de_resumo_da_conta__c();

            if (item.id != null) {
                
                itemResumoDaConta.Id = item.id;
                itemsToDelete.add(itemResumoDaConta);
            }
        }

        try {

            delete itemsToDelete;

        } catch(DmlException e) {

            System.debug('Error al eliminar items' + e.getMessage());
        }
    }
    
    public static Map<String,String> getProductosOutro(){

        Map<String,String> productIdsByObtentor = new Map<String,String>();

        for (Product2 product : [Select Id, Name, Obtentor__c 
                                FROM product2
                                WHERE Name = 'Outro']) {
            
            productIdsByObtentor.put(product.Obtentor__c, product.Id);
        }

        return productIdsByObtentor;
    }

    public static Map<String,String>  createProductosOutro(Map<String,String> productIdByObtentor, List<WrapperCRM.Items> products){
        List<Product2> newProducts = new List<Product2>();

      

        for (WrapperCRM.Items product : products) {
            
            if (String.isEmpty(productIdByObtentor.get(product.obtentor))) {

                product2 newProduct = new product2();
                newProduct.Name = 'Outro';
                newProduct.Obtentor__c = product.obtentor;
                newProducts.add(newProduct);
            } 
        }

        insert newProducts;

        for (Product2 product : newProducts) {
            
            productIdByObtentor.put(product.Obtentor__c, product.Id);
        }

        return productIdByObtentor;
    }

    public class Response {
        public String id;
        public Boolean status;
        public String message;
    }
    
    public class Request {
        public List<WrapperCRM.Items> items;
        public List<WrapperCRM.Items> itemsToRemove;
        public List<WrapperCRM.Estados> estados;
        public List<WrapperCRM.Estados> estadosToRemove;
        public WrapperCRM.Crm crm;
        public String crmId;
        public Boolean aprobacion;
    }
}
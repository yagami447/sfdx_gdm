@RestResource(urlMapping='/ProductsVBAPI/*')
global with sharing class ProductsVBAPI {

    public static final String SUCCESSMESSAGE = 'success';
    public static final String DEFAULTERROR = 'ocorreu um erro inesperado';
    public static final String NOPEDIDOS = 'Nenhum produto foi anexado';
    private static aSiteVendaDeBasicaController controller = new aSiteVendaDeBasicaController(true);

    @HttpGet
    global static void ListarPedidos() {
        
        RestResponse response = RestContext.response;
        response.statusCode = 404;

        ProductsVBAPIResponse result = new ProductsVBAPIResponse();
        result.status = false;
        result.message = DEFAULTERROR;
        
        String accountId = RestContext.request.params.get('accountId');
        String safra = RestContext.request.params.get('safra');
        String marca = RestContext.request.params.get('marca');
        Map<Id, List<Quote>> quotesByOppId = new Map<Id, List<Quote>>();
     
        try {
            List <aSiteVendaDeBasicaController.OpportunityWrapper> opportunitiesWrapperValues = new List <aSiteVendaDeBasicaController.OpportunityWrapper>();
            List <Opportunity> opps = getOportunidad(accountId, safra, marca);
            set<Id> oppsIds = (new Map<Id, Opportunity>(opps)).keySet();
            List <Quote> presupuestos = getPresupuestos(oppsIds);

            for(Quote presupuesto : presupuestos){
                if(quotesByOppId.containsKey(presupuesto.OpportunityId)){
                    quotesByOppId.get(presupuesto.OpportunityId).add(presupuesto);
                }else{
                    List <Quote> quoteList = new List<Quote>();
                    quoteList.add(presupuesto);
                    quotesByOppId.put(presupuesto.OpportunityId, quoteList);
                }
            }
            if (opps.size() != 0 && opps != null) {
                for (Opportunity opp : opps){                
                    aSiteVendaDeBasicaController.OpportunityWrapper newOpportunityWrapper = new aSiteVendaDeBasicaController.OpportunityWrapper();
                    newOpportunityWrapper.venta = opp;
                    newOpportunityWrapper.presupuestos = quotesByOppId.get(opp.Id);
                    List<aSiteVendaDeBasicaController.PresupuestosWrapper> presupuestosWrapperValuesNuevo = controller.setPresupuestosWrapper(newOpportunityWrapper.presupuestos, opp.name);
                    newOpportunityWrapper.presupuestosWrapperValues = presupuestosWrapperValuesNuevo;
                    newOpportunityWrapper.isEmpty = newOpportunityWrapper.presupuestos.size() == 0;
                    newOpportunityWrapper.isSelect = false;
                    opportunitiesWrapperValues.add(newOpportunityWrapper);
 
                    response.statusCode = 200;
                    result.status = true;
                    result.message = SUCCESSMESSAGE;
                    result.productList = opportunitiesWrapperValues;
                }
            }else{

                response.statusCode = 200;
                result.message = NOPEDIDOS;
            }
 
        } catch (Exception exc) {
 
            response.statusCode = 400;
            result.message = exc.getMessage();        
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Type', 'application/json');
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');
    }

    public static List<Opportunity> getOportunidad(String accountId, String safraActual, String marca) {     
        List<Opportunity> opps;
 
        opps = [
            SELECT Id, AccountId, Pricebook2Id, StageName, name,
            (
                SELECT Id, Name, Product2.Name, Product2.Id, PricebookEntryId, TotalPrice, Quantity, UnitPrice 
                FROM OpportunityLineItems
            )
            FROM Opportunity
            WHERE Safra__c = :safraActual
            AND AccountId = :accountId
            AND RecordType.DeveloperName = 'Venda_da_Basica_full'
            AND marca__c = :marca
            AND (StageName = 'Na aprovação do multiplicador' OR StageName = 'Aprobada')
            ORDER BY CreatedDate DESC
        ];

        return opps;

    }

    public static List<Quote> getPresupuestos(Set<Id> oppsIds) {
     
        List<Quote> presupuestos = [
           SELECT Id, Name, Status, TotalPrice , IsSyncing, Condi_o_de_pagamento__c,
           Taxa_de_primeiro_pagamento__c,Taxa_de_segundo_pagamento__c,Taxa_de_terceiro_pagamento__c, 
           Taxa_de_quarto_pagamento__c,Taxa_de_quinto_pagamento__c,
           Primeiro_pagamento__c, Dias_de_primeira_prorrogaco__c, Primeiro_juros__c, 
           Novo_primeiro_vencimento__c, Preco_unitario_primeiro_vencimento__c, 
           Total_do_primeiro_pagamento__c, Primeiro_vencimento__c, Valor_primeiro_juro__c,
           Segundo_pagamento__c, Dias_de_segunda_prorrogaco__c, segundo_juros__c, 
           Novo_Segundo_vencimento__c, Preco_unitario_Segundo_vencimento__c, 
           Total_do_Segundo_pagamento__c, Segundo_vencimento__c, Valor_Segundo_juro__c,
           Terceiro_pagamento__c, Dias_de_terceira_prorrogaco__c, Terceiro_juros__c, 
           Novo_Terceiro_vencimento__c, Preco_unitario_Terceiro_vencimento__c, 
           Total_do_Terceiro_pagamento__c, Terceiro_vencimento__c, Valor_Terceiro_juro__c,
           Quarto_pagamento__c, Dias_de_quarta_prorrogaco__c, Quarto_juros__c, 
           Novo_Quarto_vencimento__c, Preco_unitario_Quarto_vencimento__c, 
           Total_do_Quarto_pagamento__c, Quarto_vencimento__c, Valor_Quarto_juro__c,
           Quinto_pagamento__c, Dias_de_quinta_prorrogaco__c, Quinto_juros__c, 
           Novo_Quinto_vencimento__c, Preco_unitario_Quinto_vencimento__c, 
           Total_do_Quinto_pagamento__c, Quinto_vencimento__c, Valor_Quinto_juro__c,
           Preco_unitario_final__c, OpportunityId,
           (
               SELECT Id, Product2.Name, Product2.Description, Product2.UNIDADE__c,Product2.Categoria__c,
               TotalPrice, Quantity, Tipo_de_necessidade__c, UnitPrice 
               FROM QuoteLineItems
           )
           FROM Quote
           WHERE OpportunityId IN :oppsIds
           AND Vis_vel_para_multiplicador__c = true
           AND Status != 'Rejeitado'
           ORDER BY CreatedDate DESC
       ];
       return presupuestos;
   }

    public class ProductsVBAPIResponse {
        public Boolean status;
        public String message;
        public List<aSiteVendaDeBasicaController.OpportunityWrapper> productList = new List<aSiteVendaDeBasicaController.OpportunityWrapper>();
    }
}
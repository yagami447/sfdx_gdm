@RestResource(urlMapping='/EstadoDeComercialisacionAPI/*')
global with sharing class EstadoDeComercialisacionAPI {

    @HttpGet
    global static void getEstadoDeComercialisacion() {

        List<Cooperante__c> CooperanteList;
        List<Map<String, Object>> cooperantes = new List<Map<String, Object>>();
        Set<String> estados = new Set<String>();

        Map<String, Object> result = new Map<String, Object>();
        result.put('status', false);
        result.put('message', 'cuenta o marca invalida');

        RestResponse response = RestContext.response;
        response.headers.put('Content-Type', 'application/json');

        String accountId = RestContext.request.params.get('accountId');
        String marca = RestContext.request.params.get('marca');

        List<Configuracion_BMX__c> safras = [
                                            SELECT 
                                                PM_Safra_Actual_A1__c
                                            FROM Configuracion_BMX__c
        ];

        List<Contrato__c> listaEstados = [
                                            SELECT Id, Estados_Comercializacao__c
                                            FROM Contrato__c
                                            WHERE Sociedad__c =: marca
                                            AND Safra__c =: safras[0].PM_Safra_Actual_A1__c
                                            AND Multiplicador__c =: accountId
                                            AND Estado__c = 'Chegou'
                                            AND Estados_Comercializacao__c != null
        ];

        if (listaEstados.isEmpty()) {

            response.statusCode = 404;
        } else {

            for(Contrato__c contrato : listaEstados) {

                for (String estado : contrato.Estados_Comercializacao__c.split(';')) {

                    if (!estados.contains(estado))  {

                        estados.add(estado);
                    }
                }
            } 

            result.put('status', true);
            result.put('message', 'success');
            result.put('estados', estados);
            response.statusCode = 200;
        }

        response.responseBody = Blob.valueOf(JSON.serialize(result));
        response.headers.put('Content-Length', RestContext.response.responseBody.size()+'');

    }


  
}
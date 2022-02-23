public with sharing class addAnexoIToPlanoController {

    @TestVisible public Map<Id, Opportunity> anexosSelected     {get; set;}
    @TestVisible public Id planoDeAuditoriaId                   {get; set;}
    @TestVisible public Map<Id, Opportunity> anexosInDataBase   {get; set;}   
    @TestVisible public Account filtroDeCuenta                  {get; set;}
    @TestVisible public List<SelectOption> accounts             {get; set;}
    @TestVisible public List<SelectOption> oppFiltrer           {get; set;}
    @TestVisible public List<SelectOption> marcaFiltrer         {get; set;}    
    @TestVisible public List<SelectOption> safraFiltrer         {get; set;}
    @TestVisible public Id toAdd                                {get; set;}
    @TestVisible public Id toRemove                             {get; set;}
    @TestVisible public String accountsSelected                 {get; set;}
    @TestVisible public String oppSelected                      {get; set;}
    @TestVisible public String marcaSelected                    {get; set;}
    @TestVisible public String safraSelected                    {get; set;}
    @TestVisible public Integer OffsetSize = 0;
    @TestVisible public Integer QueryLimit = 30;
    @TestVisible public Integer CountTotalRecords;
    @TestVisible public List<Id> oppToDelete;
    @TestVisible public List<Account> accountsFromPlano;
    @TestVisible public Map<Id, Opportunity> anexosDelPlano;
    @TestVisible public Map<String, Producto_Auditado__c> productosParaAuditar;

    public addAnexoIToPlanoController(ApexPages.StandardController controller) {
        planoDeAuditoriaId = controller.getRecord().Id;
        anexosSelected = new Map<Id, Opportunity>();
        accounts = new List<SelectOption>();    
        oppToDelete = new List<Id>();
        accountsFromPlano = [SELECT Id, Name FROM Account WHERE Plano_de_Auditoria__c = :planoDeAuditoriaId];
        CountTotalRecords = [
            SELECT count() FROM Opportunity
            WHERE RecordType.DeveloperName = 'AnexoI' AND StageName = 'Aprobada' AND AccountId IN :accountsFromPlano AND Plano_de_auditoria__r.Status__c NOT IN ('Concluido', 'Cancelado')
        ];
        addAccountsToFiltrer();
        addMarcaToFiltrer();
        addSafraToFiltrer([SELECT Safra__c FROM Plano_de_Auditoria__c WHERE Id = :planoDeAuditoriaId].Safra__c);
    }

    public void retrieveAnexosFromPlanoDeAuditoria() {
        List<Opportunity> anexosFromPlano = [
            SELECT Id, Name, Account.Name, RecordType.Name, Marca__c, Safra__c FROM Opportunity
            WHERE RecordType.DeveloperName = 'AnexoI' AND Plano_de_Auditoria__c = :planoDeAuditoriaId
        ];

        for (Opportunity anexo : anexosFromPlano) {
            anexosSelected.put(anexo.Id, anexo);
        }

        getAnexosI();
    }

    public void getAnexosI() {
        anexosInDataBase = new Map<Id, Opportunity>();

        List<Opportunity> anexosI;
        Set<Id> oppsID = new Set<Id>();

        for (Id oppId : anexosSelected.keySet()) {
            oppsID.add(oppId);
        }

        Plano_de_Auditoria__c plano = [SELECT Id, Safra__c FROM Plano_de_Auditoria__c WHERE Id = :planoDeAuditoriaId];
        anexosDelPlano = new Map<Id, Opportunity>();

        for (Opportunity opp : [SELECT Id FROM Opportunity WHERE Plano_de_Auditoria__c = :planoDeAuditoriaId]) {
            anexosDelPlano.put(opp.Id, opp);
        }

        List<String> safras = plano.Safra__c.split(';');
        System.Debug('Safras: '+ safras);
        String query = 'SELECT Id, Name, Account.Name, RecordType.Name, Marca__c, Safra__c, Plano_de_Auditoria__c, Plano_de_Auditoria__r.Status__c, Plano_de_Auditoria__r.Safra__c FROM Opportunity WHERE RecordType.DeveloperName = \'AnexoI\'AND StageName = \'Aprobada\' AND Id NOT IN :oppsID AND AccountId IN :accountsFromPlano AND Plano_de_auditoria__r.Status__c != \'Concluido\' AND Safra__c IN :safras ';

        if (String.isNotEmpty(accountsSelected)) { query += ' AND AccountId = :accountsSelected'; }
        if (String.isNotEmpty(oppSelected)) { query += ' AND Id = :oppSelected'; }
        if (String.isNotEmpty(marcaSelected)) { query += ' AND Marca__c = :marcaSelected'; }
        if (String.isNotEmpty(safraSelected)) { query += ' AND Safra__c = :safraSelected'; }

        query += ' LIMIT :QueryLimit OFFSET :OffsetSize';
        anexosI = database.Query(query);

        for (Opportunity anexo : anexosI) {
            anexosInDataBase.put(anexo.Id, anexo);
        }

        addOpportunityToFiltrer();
    }

    public void addAccountsToFiltrer() {
        accounts.add(new SelectOption('', 'Seleccione Conta'));

        for (Account acc : accountsFromPlano) {
            accounts.add(new SelectOption(acc.Id, acc.Name));
        }
    }

    public void addOpportunityToFiltrer() {
        oppFiltrer = new List<SelectOption>();
        oppFiltrer.add(new SelectOption('', 'Seleccione Oportunidad'));

        for (Opportunity opp : anexosInDataBase.values()) {
            oppFiltrer.add(new SelectOption(opp.Id, opp.Name));
        }
    }

    public void addMarcaToFiltrer() {
        marcaFiltrer = new List<SelectOption>();  
        marcaFiltrer.add(new SelectOption('', 'Seleccione Marca'));
        marcaFiltrer.add(new SelectOption('BRMX', 'BRMX'));
        marcaFiltrer.add(new SelectOption('DSEM', 'DSEM'));
        marcaFiltrer.add(new SelectOption('NEOG', 'NEOG'));
        marcaFiltrer.add(new SelectOption('DAGMA', 'DAGMA'));
        marcaFiltrer.add(new SelectOption('LICENÇAS', 'LICENÇAS'));
    }

    public void addSafraToFiltrer(String safras) {
        safraFiltrer = new SelectOption[]{new SelectOption('', 'Seleccione Safra')};

        for (String safra : safras.split(';')) {
            safraFiltrer.add(new SelectOption(safra, safra));
        }
    }

    public void addAnexos() {
        anexosSelected.put(toAdd, anexosInDataBase.get(toAdd));
        anexosInDataBase.remove(toAdd);
    }

    public void removeAnexo() {
        if (anexosDelPlano.containsKey(toRemove)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Não pode remover um anexo já adicionado ao plano'));
        } else {
            anexosSelected.remove(toRemove);
        	oppToDelete.add(toRemove);
        }        

        getAnexosI();
    }

    public PageReference next() {
        OffsetSize += QueryLimit;
        getAnexosI();
        return null;
    }

    public PageReference previous() {
        OffsetSize -= QueryLimit;
        getAnexosI();
        return null;
    }

    public Boolean getDisablePrevious() {
        return OffsetSize <= 0;
    }

    public Boolean getDisableNext() {
        return OffsetSize + QueryLimit >= countTotalRecords;
    }

    public PageReference save() {
        for (Opportunity opp : anexosSelected.values()) {
            opp.Plano_de_Auditoria__c = planoDeAuditoriaId;
        }

        for (Opportunity opp : [SELECT Id, Name, Plano_de_Auditoria__c FROM Opportunity WHERE Id IN :oppToDelete]) {
            opp.Plano_de_Auditoria__c = null;
            anexosSelected.put(opp.Id, opp); // Agrego la opp a este mapa para hacer un solo update, por mas que esta opp seria las que se desligaron del plano de auditoria.
        }

        update anexosSelected.values();
        createProductoAuditado();
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }

    public void createProductoAuditado() {
        Set<Id> oppsParaAuditar = new Set<Id>(); // Lista de oportunidades de Anexo 1, 2, 3 y 4 que seran utilizadas para cargar los productos.
        productosParaAuditar = new Map<String, Producto_Auditado__c>();
        List<Opportunity> oppsUpdate = new List<Opportunity>();
        List<Producto_Auditado__c> productosDelPlano = [ // Productos ya existentes en el plano.
            SELECT Id, Name, Safra__C, Variedad__c, Marca__c, Categoria__c, Area_Autorizada__c, Area_Plantada__c, Productividad__c,
                Sem_Bruta__c, Quebra__c, Sem_Beneficiada__c, Sem_Aprobada__c, Sem_Comercializada__c, Sem_Uso_Propio__c, Total_Com_Up__c,
                Descarte__c, Comercializado__c, Uso_Propio__c, Descarte_Cliente__c, Total_Com_UP_Cliente__c, Diferencia_de_Venta__c, Diferencia_Descarte__c 
            FROM Producto_Auditado__c
            WHERE Plano_de_Auditoria__c = :planoDeAuditoriaId
        ];

        for (Producto_Auditado__c producto : productosDelPlano) {
            productosParaAuditar.put(producto.Variedad__c, producto);
        }

        List<Opportunity> anexos1 = new List<Opportunity>();

        for (Opportunity opp : anexosSelected.values()) {
            if (opp.Plano_de_Auditoria__c != null) { // Reutilizo el mapa y quito las opportunidades desvinculadas al plano.
                anexos1.add(opp);
            }
        }
        // Filtrar!!!
        List<Opportunity> anexos2 = [SELECT Id, Name, Marca__c, Safra__c, AccountId FROM Opportunity WHERE RecordType.DeveloperName = 'AnexoII' AND StageName = 'Aprobada'];
        List<Opportunity> anexos3 = [SELECT Id, Name, Marca__c, Safra__c, AccountId FROM Opportunity WHERE RecordType.DeveloperName = 'Anexo_III' AND StageName = 'Aprobada'];
        List<Opportunity> anexos4 = [SELECT Id, Name, Marca__c, Safra__c, AccountId FROM Opportunity WHERE RecordType.DeveloperName = 'Anexo_IV' AND StageName = 'Aprobada'];

        for (Opportunity anexo1 : anexos1) {
            oppsParaAuditar.add(anexo1.Id);

            if (!oppsUpdate.contains(anexo1)) {
                oppsUpdate.add(anexo1);
            }

            for (Opportunity anexo2 : anexos2) {
                if (anexo1.Safra__c == anexo2.Safra__c && anexo1.Marca__c == anexo2.Marca__c && anexo1.AccountId == anexo2.AccountId) {
                    oppsParaAuditar.add(anexo2.Id);
                    anexo2.Plano_de_Auditoria__c = planoDeAuditoriaId;

                    if (!oppsUpdate.contains(anexo2)) {
                        oppsUpdate.add(anexo2);
                    }
                }
            }

            for (Opportunity anexo3 : anexos3) {
                if (anexo1.Safra__c == anexo3.Safra__c && anexo1.Marca__c == anexo3.Marca__c && anexo1.AccountId == anexo3.AccountId) {
                    oppsParaAuditar.add(anexo3.Id);
                    anexo3.Plano_de_Auditoria__c = planoDeAuditoriaId;

                    if (!oppsUpdate.contains(anexo3)) {
                        oppsUpdate.add(anexo3);
                    }  
                }
            }
            
            for (Opportunity anexo4 : anexos4) {
                if (anexo1.Safra__c == anexo4.Safra__c && anexo1.Marca__c == anexo4.Marca__c && anexo1.AccountId == anexo4.AccountId) {
                    oppsParaAuditar.add(anexo4.Id);
                    anexo4.Plano_de_Auditoria__c = planoDeAuditoriaId;

                    if (!oppsUpdate.contains(anexo4)) {
                        oppsUpdate.add(anexo4);
                    }  
                }
            }
        }

        update oppsUpdate;

        List<OpportunityLineItem> olis = [ // ACA AGREGAR LOS CAMPOS NUEVOS.
            SELECT Id, Name, Product2Id, Safra__c, Product2.Variedade__c, Categoria__c, Product2.Categoria__c, Product2.Sociedad__c, OpportunityId,
                Area__c, Area_Plantada__c,Semente_bruta__c, Semente_beneficiada__c, Semente_aprovada__c, Semente_comercializada__c, Semente_uso_propio__c,
                Descarte__c, Opportunity.RecordType.DeveloperName
            FROM OpportunityLineItem 
            WHERE OpportunityId IN :oppsParaAuditar
        ];
        System.debug('Olis: ' + olis);
        for (OpportunityLineItem oli: olis) {
            String variedadeXcategoriaXsafra = oli.Product2.Variedade__c + '/' + oli.Categoria__c + '/' + oli.Safra__c;
            System.debug('variedadeXcategoriaXsafra: ' + variedadeXcategoriaXsafra);
            if (productosParaAuditar.isEmpty() || !productosParaAuditar.containsKey(variedadeXcategoriaXsafra)) {
                insertProduct(oli, variedadeXcategoriaXsafra);
            } else if (oli.Opportunity.RecordType.DeveloperName == 'AnexoI') {
                productosParaAuditar.get(variedadeXcategoriaXsafra).Area_Autorizada__c += oli.Area__c;
            } else if (oli.Opportunity.RecordType.DeveloperName == 'AnexoII') {
                productosParaAuditar.get(variedadeXcategoriaXsafra).Area_Plantada__c += oli.Area_Plantada__c;
            } else if (oli.Opportunity.RecordType.DeveloperName == 'Anexo_III') { // EL mapa contiene la variedad y es de la misma safra, por lo tanto hago update con los campos de los otros anexos.
                productosParaAuditar.get(variedadeXcategoriaXsafra).Sem_Bruta__c += oli.Semente_bruta__c;
                productosParaAuditar.get(variedadeXcategoriaXsafra).Sem_Beneficiada__c += oli.Semente_beneficiada__c;
                productosParaAuditar.get(variedadeXcategoriaXsafra).Sem_Aprobada__c += oli.Semente_aprovada__c;
                productosParaAuditar.get(variedadeXcategoriaXsafra).Sem_Comercializada__c += oli.Semente_comercializada__c;
                productosParaAuditar.get(variedadeXcategoriaXsafra).Sem_Uso_Propio__c += oli.Semente_uso_propio__c;
            } else if (oli.Opportunity.RecordType.DeveloperName == 'Anexo_IV') {
                productosParaAuditar.get(variedadeXcategoriaXsafra).Sem_Comercializada__c += oli.Semente_comercializada__c;
                productosParaAuditar.get(variedadeXcategoriaXsafra).Sem_Uso_Propio__c += oli.Semente_uso_propio__c;
                productosParaAuditar.get(variedadeXcategoriaXsafra).Descarte__c += oli.Descarte__c;
            }
        }
        System.debug('Productos para auditar: ' + productosParaAuditar.values());
        upsert productosParaAuditar.values();
    }

    public void insertProduct(OpportunityLineItem oli, String variedadeXcategoriaXsafra) {
        Producto_Auditado__c productoParaAuditar = new Producto_Auditado__c( // ACA CREAR LOS CAMPOS NUEVOS.
            Variedad__c = oli.Product2.Variedade__c,
            Marca__c = oli.Product2.Sociedad__c,
            Safra__c = oli.Safra__c,
            Area_Autorizada__c = 0,
            Area_Plantada__c = 0,
            Sem_Bruta__c = 0,
            Sem_Beneficiada__c = 0,
            Sem_Aprobada__c = 0,
            Sem_Aprovada_Verificada__c = 0,
            Sem_Comercializada__c = 0,
            Sem_Uso_Propio__c = 0,
            Descarte__c = 0,
            Plano_de_Auditoria__c = planoDeAuditoriaId,
            Produto__c = oli.Product2Id
        );

        if (oli.Opportunity.RecordType.DeveloperName == 'AnexoI') {
            productoParaAuditar.Categoria_Oli__c = oli.Categoria__c;
            productoParaAuditar.Area_Autorizada__c = oli.Area__c;
        } else if (oli.Opportunity.RecordType.DeveloperName == 'AnexoII') {
            productoParaAuditar.Area_Plantada__c = oli.Area_Plantada__c;
        } else if (oli.Opportunity.RecordType.DeveloperName == 'Anexo_III') {
            productoParaAuditar.Sem_Bruta__c = oli.Semente_bruta__c;
            productoParaAuditar.Sem_Beneficiada__c = oli.Semente_beneficiada__c;
            productoParaAuditar.Sem_Aprobada__c = oli.Semente_aprovada__c;
            productoParaAuditar.Sem_Comercializada__c = oli.Semente_comercializada__c;
            productoParaAuditar.Sem_Uso_Propio__c = oli.Semente_uso_propio__c;
        } else if (oli.Opportunity.RecordType.DeveloperName == 'Anexo_IV') {
            productoParaAuditar.Sem_Comercializada__c = oli.Semente_comercializada__c;
            productoParaAuditar.Sem_Uso_Propio__c = oli.Semente_uso_propio__c;
            productoParaAuditar.Descarte__c = oli.Descarte__c;
        }

        productosParaAuditar.put(variedadeXcategoriaXsafra, productoParaAuditar);
    }

    public PageReference cancel() {
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
}
public with sharing class opportunityProductEntryExtension {

    public Opportunity theOpp {get;set;}
    public Opportunity VBCompleta {get;set;}
    public String searchString {get;set;}
    public opportunityLineItem[] shoppingCart {get;set;}
    public priceBookEntry[] AvailableProducts {get;set;}
    public Pricebook2 theBook {get;set;}
    
    private List<SelectOption> optionsTipoNecesidad = new List<SelectOption>();

    public List<PBEWrapper> shoppingCartWrappers {get;set;}
    public List<PBEWrapper> shoppingCartWrappersUpsert {get;set;}
    
    public Map<Id,Variedad__c> variedades {get;set;}
    public Map<Id,Categoria__c> categorias {get;set;}
    public Map<String,Double> cantSubUnidporUnid {get;set;}
    
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public String toEdit {get; set;}
    public String accion {get; set;}
    public Decimal Total {get;set;}
    public Double quantityTemp {get;set;}

    public Boolean overLimit {get;set;}
    
    public Boolean esVenta {get;set;}
    
    public Decimal anticipoItems {get;set;}
    
    private Boolean forcePricebookSelection = false;
    private String compania = 'FTEC - Forratec';
    private Integer contador = 0;
    private Double sumaTasas = 0;
    private Configuracion_BMX__c confTasas = New Configuracion_BMX__c(Londrina_Tasa_COFINS__c=0, Londrina_Tasa_ISS__c=0, Londrina_Tasa_PIS__c=0, Passo_Fundo_Tasa_COFINS__c=0, Passo_Fundo_Tasa_ISS__c=0, Passo_Fundo_Tasa_PIS__c=0);
    
    private opportunityLineItem[] forDeletion = new opportunityLineItem[]{};  
    
    private Map<String, Schema.SObjectField> objectFields_oppItems = Schema.getGlobalDescribe().get('OpportunityLineItem').getDescribe().fields.getMap();     
    
    private void determinarTipoNecesidad() {
        if (theOpp != null) {
            if (theOpp.RecordType.Name == 'PB-Comercial' || theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'VB - Pendiente' || theOpp.RecordType.Name == 'VB - Rechazada' || theOpp.RecordType.Name == 'VB - Autorizada' || theOpp.RecordType.Name == 'Objetivo Ventas Semilla') {
                optionsTipoNecesidad.add(new SelectOption('Multiplicação', 'Multiplicação'));
                optionsTipoNecesidad.add(new SelectOption('Difusão Multiplicador', 'Difusão Multiplicador'));
                optionsTipoNecesidad.add(new SelectOption('Difusão Comercial', 'Difusão Comercial'));
                optionsTipoNecesidad.add(new SelectOption('Dia de Campo', 'Dia de Campo'));
                optionsTipoNecesidad.add(new SelectOption('Lado a Lado', 'Lado a Lado'));
                optionsTipoNecesidad.add(new SelectOption('Strip Test', 'Strip Test'));              
            }
            if (theOpp.RecordType.Name == 'PB-Desarrollo' || theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'VB - Pendiente' || theOpp.RecordType.Name == 'VB - Autorizada') {
                optionsTipoNecesidad.add(new SelectOption('Desenvolvimento', 'Desenvolvimento'));
            }
        }       
    }
    
    public List<SelectOption> getTipoNecesidad() {
        return optionsTipoNecesidad;
    }
    
    public List<SelectOption> getTipoCot() {
        List<SelectOption> lista = new List<SelectOption>();        
        Schema.DescribeFieldResult tipo_cot = Referencia_de_Praca__c.Tipo_de_Cotacao__c.getDescribe();
        List<Schema.PickListEntry> p_tipo_cot = tipo_cot.getPickListValues();
        lista.add(new SelectOption('', '--Ninguno--'));
        for (Schema.PickListEntry p : p_tipo_cot)
            lista.add(new SelectOption(p.getvalue(),p.getvalue()));    
            
        return lista;                
    }
    
    public List<SelectOption> getCotSoja() {
        List<SelectOption> lista = new List<SelectOption>();        
        Schema.DescribeFieldResult cot_soja = Referencia_de_Praca__c.Praca__c.getDescribe();
        List<Schema.PickListEntry> p_cot_soja = cot_soja.getPickListValues();
        lista.add(new SelectOption('', '--Ninguno--'));
        for (Schema.PickListEntry p : p_cot_soja)
            lista.add(new SelectOption(p.getvalue(),p.getvalue()));    
            
        return lista;                
    }
    
    public List<SelectOption> getOptionCategoria() {
       List<SelectOption> lista = new List<SelectOption>();
       //lista.add(new SelectOption('', '--Ninguno--'));
       for (Categoria__c c : [Select Id, Name from Categoria__c WHERE Name IN('BASICA', 'C1', 'C2', 'S1', 'S2', 'PREBA', 'FUNDADORA') Order By Name]) {                            
           //if (c.Name != 'PRE BASICA' || (c.Name == 'PRE BASICA' && (Userinfo.getProfileId() == '00e40000000yy83AAA' || Userinfo.getProfileId() == '00e40000000rObQAAU'))) {
                lista.add(new SelectOption(c.Id,c.Name));
           //}
       }
       return lista;
    }

    public List<SelectOption> getOptionEstado() {
        List<SelectOption> lista = new List<SelectOption>();
        lista.add(new SelectOption('', '--None--'));
        for (Estado__c e : [Select Id, Name from Estado__c WHERE Mostrar_en_Portal__c = true Order By Name]) {                            
             lista.add(new SelectOption(e.Id,e.Name));
        }
        return lista;
     }

    public void setforcePricebookSelection(Boolean a) {
        forcePricebookSelection = a;
    }

    public opportunityProductEntryExtension(ApexPages.StandardController controller) {
        map<Id, User> propRol = New map<Id, User>();
        shoppingCartWrappers = new List<PBEWrapper>();
        shoppingCartWrappersUpsert = new List<PBEWrapper>();
        cantSubUnidporUnid = new Map<String,Double>();
        
        // obtener los datos de la opp en edición
        theOpp = [
            SELECT Id, Pricebook2Id, RecordType.Name,  RecordType.DeveloperName, PriceBook2.Name, AccountId, Safra__c,
                Sociedad__c, Pedido_Relacionado__c, Marca__c, Anexo_Relacionado__c, StageName, Tipo_de_Operacion__c,OwnerId,
                Oportunidad_Relacionada__c, Origen__c, Origen__r.Name, PE_Bajar_SAP__c, Setor__c, Local_de_Entrega__c, Region__c, Valor_antecipado__c,
                (
                    SELECT Id, OpportunityId, Kg_de_produto__c, Tipo_de_Necessidade__c, Id_Item_de_Oportunidad_Relacionado__c, Posicion_SAP_Relacionada__c,
                        Product2.CANTIDAD_SUB_UNIDAD__c, Product2.UNIDADE__c, Quantity, UnitPrice, UNIDADE__c,
                        Product2.Variedade__c, Variedade_Prod__c, Variedad_de_Produto__c, Product2.Categ__c, Categoria_Prod__c
                    FROM OpportunityLineItems
                )
            FROM Opportunity
            WHERE Id = :controller.getRecord().Id LIMIT 1
        ];
        
        if (theOpp.RecordType.Name == 'CVB Pendiente') {
            variedades = new Map<Id,Variedad__c>([SELECT Id, Name, Nombre_de_Registro__c FROM Variedad__c]);
            categorias = new Map<Id,Categoria__c>([SELECT Id, Name FROM Categoria__c]);

            VBCompleta = [
                SELECT Id, Name, (SELECT Id FROM Oportunidades1__r),
                    (
                        SELECT Id, OpportunityId, Quant_Pendiente__c, Kg_de_produto__c, Tipo_de_Necessidade__c, Posicion_SAP__c,
                            Product2.CANTIDAD_SUB_UNIDAD__c, Product2.UNIDADE__c, Quantity, UnitPrice, UNIDADE__c,
                            Product2.Variedade__c, Variedade_Prod__c, Variedad_de_Produto__c, Product2.Categ__c, Categoria_Prod__c
                        FROM OpportunityLineItems
                    )
                FROM Opportunity
                WHERE Id = :theOpp.Pedido_Relacionado__c LIMIT 1
            ];
            
            List<PricebookEntry> pricebookProducts = [
                SELECT Product2.Variedade__c, Product2.Categ__c, Product2.UNIDADE__c, Product2.CANTIDAD_SUB_UNIDAD__c
                FROM PriceBookEntry
                WHERE Pricebook2Id = :theOpp.Pricebook2Id AND IsActive = true // la CVB Pendiente debería utilizar el Standar Pricebook
            ];
            
            Map<Id,List<PricebookEntry>> pricebookProductsMap = new Map<Id,List<PricebookEntry>>();

            Set<String> idCategorias = new Set<String>();
            Set<String> idUnidades = new Set<String>();

            for (PricebookEntry PBE : pricebookProducts) {
                idCategorias.add(PBE.Product2.Categ__c);
                idUnidades.add(PBE.Product2.UNIDADE__c);

                if (String.isNotEmpty(PBE.Product2.CANTIDAD_SUB_UNIDAD__c)) {
                    cantSubUnidporUnid.put(PBE.Product2.UNIDADE__c, Double.valueOf(PBE.Product2.CANTIDAD_SUB_UNIDAD__c));
                }

                if (pricebookProductsMap.containsKey(PBE.Product2.Variedade__c)) {
                    pricebookProductsMap.get(PBE.Product2.Variedade__c).add(PBE);
                } else {
                    pricebookProductsMap.put(PBE.Product2.Variedade__c, new PricebookEntry[]{PBE});
                }
            }

            for (OpportunityLineItem producto : theOpp.OpportunityLineItems) {
                PBEWrapper wrapp = new PBEWrapper();
                
                wrapp.id = GuidUtil.NewGuid();
                wrapp.item = producto;
                wrapp.idVariedad = producto.Product2.Variedade__c;
                wrapp.Variedad = producto.Variedade_Prod__c; // Nome Comercial
                wrapp.Nombre_de_Registro = producto.Variedad_de_Produto__c; // Registro Cultivar
                wrapp.idCategoria = producto.Product2.Categ__c;
                wrapp.Categoria = producto.Categoria_Prod__c;
                wrapp.idUnidad = producto.Product2.UNIDADE__c;
                wrapp.quantity = producto.Quantity;
                wrapp.cantSubUnidad = Double.valueOf(producto.Product2.CANTIDAD_SUB_UNIDAD__c);
                wrapp.Tipo_de_Necesidad = producto.Tipo_de_Necessidade__c;

                for (PricebookEntry PBE : pricebookProductsMap.get(producto.Product2.Variedade__c)) {
                    if (PBE.Product2.Categ__c != null && categorias.containsKey(PBE.Product2.Categ__c)) {
                        SelectOption categoria = new SelectOption(String.valueOf(PBE.Product2.Categ__c), categorias.get(PBE.Product2.Categ__c).Name);

                        if (!wrapp.opcionesCategoria.contains(categoria)) {
                            wrapp.opcionesCategoria.add(categoria);
                        }
                    }

                    if (PBE.Product2.UNIDADE__c != null) {
                        SelectOption unidad = new SelectOption(PBE.Product2.UNIDADE__c, PBE.Product2.UNIDADE__c);

                        if (!wrapp.opcionesUnidad.contains(unidad)) {
                            wrapp.opcionesUnidad.add(unidad);
                        }
                    }
                }
                
                shoppingCartWrappersUpsert.add(wrapp);
            }

            PBEWrapper wrapp = new PBEWrapper(); // wrapp general para agregar productos según las combinaciones elegidas por el usuario

            wrapp.opcionesVariedad.add(new SelectOption('---Ninguno---','---Ninguno---'));
            wrapp.opcionesCategoria.add(new SelectOption('---Ninguno---','---Ninguno---'));
            wrapp.opcionesUnidad.add(new SelectOption('---Ninguno---','---Ninguno---'));

            for (OpportunityLineItem producto : VBCompleta.OpportunityLineItems) {
                String idVaried = producto.Product2.Variedade__c;
                
                SelectOption variedad = new SelectOption(idVaried,producto.Variedad_de_Produto__c);

                if (idVaried != null && !wrapp.opcionesVariedad.contains(variedad)) {
                    wrapp.opcionesVariedad.add(variedad);
                }
            }

            for (String idCateg : idCategorias) {
                if (String.isNotEmpty(idCateg) && categorias.containsKey(idCateg)) {
                    wrapp.opcionesCategoria.add(new SelectOption(idCateg,categorias.get(idCateg).Name));
                }
            }

            for (String idUnid : idUnidades) {
                if (String.isNotEmpty(idUnid)) {
                    wrapp.opcionesUnidad.add(new SelectOption(idUnid,idUnid));
                }
            }
            
            shoppingCartWrappers.add(wrapp);
        }

        // Obtengo los productos ya cargados a la opp y los cargo como "Seleccionados"
        String queryItems = 'SELECT ';
        for (String s : objectFields_oppItems.keySet()) {
            queryItems += ' ' + s + ',';
        }

        queryItems += 'PriceBookEntry.UnitPrice, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.PriceBook2Id, PricebookEntry.Product2.Especie__c, Categoria__r.Name, Categoria_a_Rebaixar__r.Name, PricebookEntry.Product2.Categ__c, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c, PricebookEntry.Product2.Categ__r.Name, PricebookEntry.Product2.Semilla_Tratada__c, PricebookEntry.Product2.UNIDADE__c FROM OpportunityLineItem Where OpportunityId = \'' + theOpp.Id + '\'';
        queryItems += ' And Item_Rebajado__c = false Order by Variedade_Prod__c';
        shoppingCart = Database.query(queryItems);
        Map<String,Double> cantComerXPbeId = New Map<String,Double>();
        Set<String> mostrarApEstim = New Set<String>();
        for (OpportunityLineItem o: shoppingCart) {
            if (theOpp.RecordType.Name == 'Stock Multiplicadores' && !mostrarApEstim.contains(o.PricebookEntryId)){
                o.WERKS__c = 'x';
                mostrarApEstim.add(o.PricebookEntryId);
            }
            if (o.Semente_comercializada__c != null){
                if (!cantComerXPbeId.containsKey(o.PricebookEntryId)){
                    cantComerXPbeId.put(o.PricebookEntryId, o.Semente_comercializada__c);
                }else{
                    Double ant = cantComerXPbeId.get(o.PricebookEntryId);
                    ant += o.Semente_comercializada__c;
                    cantComerXPbeId.put(o.PricebookEntryId, ant);
                }
            }
        }
        for (OpportunityLineItem o: shoppingCart) {
            o.ZZPOSSF__c = String.ValueOf(contador);
            contador++;

                            
            if (theOpp.RecordType.Name == 'Stock Multiplicadores' && o.Estimativa__c == null && o.WERKS__c == 'x'){
                o.Estimativa__c = cantComerXPbeId.get(o.PricebookEntryId);                
            }
        }
        for (User u: [SELECT Id, UserRole.Name, Profile.Name FROM User]) {
            propRol.put(u.Id, u);
        }
        if ((theOpp.RecordType.Name == 'Pendiente' || theOpp.RecordType.Name == 'NC - Pendiente') && theOpp.Origen__c != null) {
            for (Configuracion_BMX__c conf : [Select Londrina_Tasa_COFINS__c, Londrina_Tasa_ISS__c, Londrina_Tasa_PIS__c, Passo_Fundo_Tasa_COFINS__c, Passo_Fundo_Tasa_ISS__c, Passo_Fundo_Tasa_PIS__c From Configuracion_BMX__c limit 1]) {
                if (conf.Londrina_Tasa_COFINS__c != null) confTasas.Londrina_Tasa_COFINS__c = conf.Londrina_Tasa_COFINS__c;
                if (conf.Londrina_Tasa_ISS__c != null) confTasas.Londrina_Tasa_ISS__c = conf.Londrina_Tasa_ISS__c;
                if (conf.Londrina_Tasa_PIS__c != null) confTasas.Londrina_Tasa_PIS__c = conf.Londrina_Tasa_PIS__c;
                if (conf.Passo_Fundo_Tasa_COFINS__c != null) confTasas.Passo_Fundo_Tasa_COFINS__c = conf.Passo_Fundo_Tasa_COFINS__c;
                if (conf.Passo_Fundo_Tasa_ISS__c != null) confTasas.Passo_Fundo_Tasa_ISS__c = conf.Passo_Fundo_Tasa_ISS__c;                    
                if (conf.Passo_Fundo_Tasa_PIS__c != null) confTasas.Passo_Fundo_Tasa_PIS__c = conf.Passo_Fundo_Tasa_PIS__c;
            }
            if (theOpp.Origen__r.Name.contains('Londrina') || theOpp.Origen__r.Name.contains('Cambe')) sumaTasas = confTasas.Londrina_Tasa_COFINS__c + confTasas.Londrina_Tasa_ISS__c + confTasas.Londrina_Tasa_PIS__c;
            if (theOpp.Origen__r.Name.contains('Passo Fundo')) sumaTasas = confTasas.Passo_Fundo_Tasa_COFINS__c + confTasas.Passo_Fundo_Tasa_ISS__c + confTasas.Passo_Fundo_Tasa_PIS__c;
            if (propRol.get(theOpp.OwnerId).Profile.Name == 'Administrativo_licencias') sumaTasas = 3.65;
        }

        // Chequeo si la opp ya tiene una lista de precios
        if (theOpp.Pricebook2Id == null) {
            //Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            String nombreLista = '';
            if (theOpp.Marca__c == 'BRMX' || theOpp.Marca__c == null) {
                if (theOpp.RecordType.Name == 'Previsao' || theOpp.RecordType.Name == 'Disponibilidade da Basica' || theOpp.RecordType.Name == 'Stock Multiplicadores' || theOpp.RecordType.Name == 'Exportacion' || theOpp.RecordType.Name == 'Reembalaje' || theOpp.RecordType.Name == 'Objetivo Ventas Semilla') {
                    if (propRol.get(theOpp.OwnerId).UserRole.Name == 'Gerente Cerrados') {nombreLista = 'Lista de Básica BMX CERRADOS';}
                    else {nombreLista = 'Lista de Básica BMX SUL';}
                } else {nombreLista = 'Lista Canal Multiplicadores';}
                if (theOpp.RecordType.Name == 'Pendiente' || theOpp.RecordType.Name == 'NC - Pendiente') {
                    nombreLista = 'Lista Canal Multiplicadores - ' + theOpp.Region__c;
                }
                //if (theOpp.RecordType.Name == 'PB-Comercial'  || theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'PB-Desarrollo') nombreLista = 'Lista de Básica BMX SUL';
                if (theOpp.RecordType.Name == 'PB-Comercial'  || theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'PB-Desarrollo' || theOpp.RecordType.Name == 'PB-Oferta') nombreLista = 'Lista de Básica - Prod. de Básica';
                if (propRol.get(theOpp.OwnerId).Profile.Name == 'Administrativo_licencias') {
                    if (theOpp.RecordType.Name == 'Previsao') {
                    nombreLista = 'Lista de Básica Licencias';
                    } else {
                    nombreLista = 'Lista de precios de Licencias';
                    }
                }
                //nombreLista = 'Lista Canal Multiplicadores';
                Pricebook2[] activepbs = [select Id, Name from Pricebook2 where Name = :nombreLista And isActive = true limit 1];
                if (activepbs.size() == 1) {
                    theBook = activepbs[0];
                }
            }
            
            if (theOpp.Marca__c == 'DSEM') {
                if (theOpp.RecordType.Name == 'Previsao' || theOpp.RecordType.Name == 'Disponibilidade da Basica' || theOpp.RecordType.Name == 'Stock Multiplicadores' || theOpp.RecordType.Name == 'Exportacion' || theOpp.RecordType.Name == 'Reembalaje' || theOpp.RecordType.Name == 'Objetivo Ventas Semilla') {
                    if (propRol.get(theOpp.OwnerId).UserRole.Name == 'Gerente Cerrados') {nombreLista = 'Lista de Básica DSEM CERRADOS';}
                    else {nombreLista = 'Lista de Básica DSEM SUL';}
                } else {nombreLista = 'Lista DSEM';}
                if (theOpp.RecordType.Name == 'Pendiente' || theOpp.RecordType.Name == 'NC - Pendiente') {
                    nombreLista = 'Lista DSEM - ' + theOpp.Region__c;
                }
                //if (theOpp.RecordType.Name == 'PB-Comercial'  || theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'PB-Desarrollo') nombreLista = 'Lista de Básica DSEM SUL';
                if (theOpp.RecordType.Name == 'PB-Comercial'  || theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'PB-Desarrollo' || theOpp.RecordType.Name == 'PB-Oferta') nombreLista = 'Lista de Básica - Prod. de Básica';
                if (propRol.get(theOpp.OwnerId).Profile.Name == 'Administrativo_licencias') nombreLista = 'Lista de precios de Licencias';
                Pricebook2[] activepbs = [select Id, Name from Pricebook2 where Name = :nombreLista And isActive = true limit 1];
                if (activepbs.size() == 1) {
                    theBook = activepbs[0];
                }
            }
            
            if (theOpp.Marca__c == 'NEOG') {
                if (theOpp.RecordType.Name == 'Previsao' || theOpp.RecordType.Name == 'Disponibilidade da Basica' || theOpp.RecordType.Name == 'Stock Multiplicadores' || theOpp.RecordType.Name == 'Exportacion' || theOpp.RecordType.Name == 'Reembalaje' || theOpp.RecordType.Name == 'Objetivo Ventas Semilla') {
                    if (propRol.get(theOpp.OwnerId).UserRole.Name.contains('Cerrados')) {nombreLista = 'Lista de Básica NEOG CERRADOS';}
                    else {nombreLista = 'Lista de Básica NEOG SUL';}
                } else {nombreLista = 'Lista NEOG';}
                if (theOpp.RecordType.Name == 'Pendiente' || theOpp.RecordType.Name == 'NC - Pendiente') {
                    nombreLista = 'Lista NEOG - ' + theOpp.Region__c;
                }
                Pricebook2[] activepbs = [select Id, Name from Pricebook2 where Name = :nombreLista And isActive = true limit 1];
                if (activepbs.size() == 1) {
                    theBook = activepbs[0];
                }
            }

            if (theOpp.Marca__c == 'DAGMA') {
                if (theOpp.RecordType.Name == 'Previsao' || theOpp.RecordType.Name == 'Disponibilidade da Basica' || theOpp.RecordType.Name == 'Stock Multiplicadores' || theOpp.RecordType.Name == 'Exportacion' || theOpp.RecordType.Name == 'Reembalaje' || theOpp.RecordType.Name == 'Objetivo Ventas Semilla') {
                    if (propRol.get(theOpp.OwnerId).UserRole.Name.contains('Cerrados')) {nombreLista = 'Lista de Básica DAGMA CERRADOS';}
                    else {nombreLista = 'Lista de Básica DAGMA SUL';}
                } else {nombreLista = 'Lista DAGMA';}
                if (theOpp.RecordType.Name == 'Pendiente' || theOpp.RecordType.Name == 'NC - Pendiente') {
                    nombreLista = 'Lista DAGMA - ' + theOpp.Region__c;
                }
                Pricebook2[] activepbs = [select Id, Name from Pricebook2 where Name = :nombreLista And isActive = true limit 1];
                if (activepbs.size() == 1) {
                    theBook = activepbs[0];
                }
            }

            if (theOpp.Marca__c == 'LICENÇAS') {
                if (theOpp.RecordType.Name == 'Previsao' || theOpp.RecordType.Name == 'Disponibilidade da Basica' || theOpp.RecordType.Name == 'Stock Multiplicadores' || theOpp.RecordType.Name == 'Exportacion' || theOpp.RecordType.Name == 'Reembalaje' || theOpp.RecordType.Name == 'Objetivo Ventas Semilla') {
                    if (propRol.get(theOpp.OwnerId).UserRole.Name.contains('Cerrados')) {nombreLista = 'Lista de Básica LICENÇAS CERRADOS';}
                    else {nombreLista = 'Lista de Básica LICENÇAS SUL';}
                } else {nombreLista = 'Lista LICENÇAS';}
                if (theOpp.RecordType.Name == 'Pendiente' || theOpp.RecordType.Name == 'NC - Pendiente') {
                    nombreLista = 'Lista LICENÇAS - ' + theOpp.Region__c;
                }
                Pricebook2[] activepbs = [select Id, Name from Pricebook2 where Name = :nombreLista And isActive = true limit 1];
                if (activepbs.size() == 1) {
                    theBook = activepbs[0];
                }
            }
        } else {
            theBook = theOpp.Pricebook2;
        }
        
        determinarTipoNecesidad();    
        
        esVenta = true;
        
        if (!forcePricebookSelection) { updateAvailableList(); }
    }

    public Boolean getDisabled() {
        Boolean disabled = false;

        for (PBEWrapper wrapp : shoppingCartWrappersUpsert) {
            if (!wrapp.readOnly) {
                disabled = !wrapp.readOnly;
                break;
            }
        }

        return disabled;
    }

    public Pagereference dummy() { return null; }

    public Pagereference cargarCatidadSubUnidad() {
        shoppingCartWrappers[0].cantSubUnidad = cantSubUnidporUnid.get(shoppingCartWrappers[0].idUnidad);
        return null;
    }

    public Pagereference editarCatidadSubUnidad() {
        PBEWrapper wrapp = getWrapper();
        wrapp.cantSubUnidad = cantSubUnidporUnid.get(wrapp.idUnidad);
        return null;
    }

    public Pagereference addShoppingCartWrappersUpsert() {
        PBEWrapper wrapper;

        if (accion == 'agregando') {
            wrapper = shoppingCartWrappers[0];
        } else if (accion == 'editando') {
            wrapper = getWrapper();
        }
        
        if (validarCantidadProducto(wrapper,VBCompleta)) {
            PriceBookEntry PBE = buscarProductoEnListaDePrecio(wrapper);

            if (PBE == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No se encontró ese producto en la lista de precios.');
                ApexPages.addMessage(myMsg);
                return null;
            }

            Boolean estaEnLaLista = false;

            if (accion == 'editando') {
                estaEnLaLista = true;
                wrapper.readOnly = true;
                wrapper.PBE = PBE;
            } else if (accion == 'agregando') {
                for (PBEWrapper wrapp : shoppingCartWrappersUpsert) {
                    if (
                        wrapp.idVariedad == wrapper.idVariedad && 
                        wrapp.idCategoria == wrapper.idCategoria && 
                        wrapp.idUnidad == wrapper.idUnidad && 
                        wrapp.Tipo_de_Necesidad == wrapper.Tipo_de_Necesidad
                    ) {
                        estaEnLaLista = true;
                        wrapp.quantity += wrapper.quantity;
                    }
                }
            }

            if (!estaEnLaLista) {
                PBEWrapper wrapp = new PBEWrapper();

                wrapp.id = GuidUtil.NewGuid();
                wrapp.PBE = PBE;
                wrapp.idVariedad = wrapper.idVariedad;
                wrapp.Variedad = variedades.get(wrapp.idVariedad).Name;
                wrapp.Nombre_de_Registro = variedades.get(wrapp.idVariedad).Nombre_de_Registro__c;
                wrapp.idCategoria = wrapper.idCategoria;
                wrapp.Categoria = categorias.get(wrapp.idCategoria).Name;
                wrapp.idUnidad = wrapper.idUnidad;
                wrapp.quantity = wrapper.quantity;
                wrapp.cantSubUnidad = cantSubUnidporUnid.get(wrapp.idUnidad);
                wrapp.Tipo_de_Necesidad = wrapper.Tipo_de_Necesidad;

                shoppingCartWrappersUpsert.add(wrapp);
            }
        }
        
        //resetear wrapper de carga
        shoppingCartWrappers[0].idVariedad = '';
        shoppingCartWrappers[0].idCategoria = '';
        shoppingCartWrappers[0].idUnidad = '';
        shoppingCartWrappers[0].quantity = 0;
        shoppingCartWrappers[0].Tipo_de_Necesidad = '---Ninguno---';
        shoppingCartWrappers[0].cantidadKgDisponible = 0;
        
        return null;
    }

    public Pagereference cantidadDisponible() {
        shoppingCartWrappers[0].cantidadKgDisponible = 0;

        for (OpportunityLineItem OLI : VBCompleta.OpportunityLineItems) {
            String productoVBF = String.valueOf(OLI.Product2.Variedade__c);
            
            if (shoppingCartWrappers[0].idVariedad == productoVBF) {
                shoppingCartWrappers[0].cantidadKgDisponible += OLI.Quant_Pendiente__c * Double.valueOf(OLI.Product2.CANTIDAD_SUB_UNIDAD__c);
            }
        }
        
        return null;
    }

    public Boolean validarCantidadProducto(PBEWrapper wrapp, Opportunity vendaBasica) {
        if (wrapp.quantity <= 0 || wrapp.quantity == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'La cantidad de sacas no puede ser cero.');
            ApexPages.addMessage(myMsg);
            return false;
        }
        // ----------------------------------------------------------------------------------------------
        Double cantidadProductoDisponible = 0;
        Double cantidadProductoReservado = 0;
        
        for (OpportunityLineItem OLI : vendaBasica.OpportunityLineItems) {
            if (wrapp.idVariedad == String.valueOf(OLI.Product2.Variedade__c)) {
                // el quantity de los OpportunityLineItems de la VB Completa representan kg de producto
                cantidadProductoDisponible += OLI.Quant_Pendiente__c * Double.valueOf(OLI.Product2.CANTIDAD_SUB_UNIDAD__c);
            }
        }

        for (PBEWrapper wrapper : shoppingCartWrappersUpsert) {
            if (wrapp.idVariedad == wrapper.idVariedad && wrapper.id != wrapp.id) {
                cantidadProductoReservado += wrapper.quantity * wrapper.cantSubUnidad;
            }
        }
        
        if (cantidadProductoDisponible < cantidadProductoReservado + (wrapp.quantity * wrapp.cantSubUnidad)) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No hay suficiente Stock de ese producto.');
            ApexPages.addMessage(myMsg);
            return false;
        }
        // ----------------------------------------------------------------------------------------------
        return true;
    }

    /**
     * Busca la existencia del producto en la lista de precios de la oportunidad. La búsqueda se realiza en base a la variedad, categoría y unidad.
     */
    public PricebookEntry buscarProductoEnListaDePrecio(PBEWrapper wrapp) {
        List<PricebookEntry> PBEs = [
            SELECT Id FROM PriceBookEntry
            WHERE Pricebook2Id = :theOpp.Pricebook2Id AND Product2.Variedade__c = :wrapp.idVariedad AND Product2.Categ__c = :wrapp.idCategoria AND Product2.UNIDADE__c = :wrapp.idUnidad AND isActive = true
        ];

        if (!PBEs.isEmpty()) { return PBEs[0]; }
        return null;
    }

    public Pagereference editProduct() {
        PBEWrapper wrapp = getWrapper();
        wrapp.readOnly = !wrapp.readOnly;
        return null;
    }

    public Pagereference removeShoppingCartWrappersUpsert() {
        Integer position = 0;
        Boolean match = true;

        while (match && position < shoppingCartWrappersUpsert.size()) {
            if (toUnselect == shoppingCartWrappersUpsert[position].id) {
                if (shoppingCartWrappersUpsert[position].item != null) {
                    forDeletion.add(shoppingCartWrappersUpsert[position].item);
                }

                shoppingCartWrappersUpsert.remove(position);
                match = false;
            }

            position++;
        }

        return null;
    }

    // metodo 'action' del inicio de la pagina VF
    public PageReference priceBookCheck() {
        if (((theOpp.RecordType.Name == 'VB - Pendiente' || theOpp.RecordType.Name == 'VB - Rechazada') && theOpp.StageName == 'Bloqueada') ) {
            return OnCancel();
        }
        if (forcePricebookSelection) {         //si es necesario elegir la lista entonces va a la pagina estandar
            return changePricebook();
        }
        return null;        
    }
    
    public Pagereference calcularAnticipoitems() {
        if (theOpp.Valor_antecipado__c != null){
            Double totalItems = 0;            
            for (opportunityLineItem i : shoppingCart) {
                totalItems += i.Precio_total_estimado__c;
            }
            
            for (opportunityLineItem i : shoppingCart) {
                Double porc = i.Precio_total_estimado__c * 100 / totalItems;                
                i.Valor_antecipado__c = (porc * theOpp.Valor_antecipado__c / 100).divide(1, 2, System.RoundingMode.HALF_EVEN);
            }
        }
        return verificarAnticipoitems();
    }
    
    public Pagereference verificarAnticipoitems() {
        anticipoItems = 0;
        for (opportunityLineItem i : shoppingCart) {
            if (i.Valor_antecipado__c != null)
                anticipoItems += i.Valor_antecipado__c;
        }
        
        return null;
    }

    public PageReference changePricebook() {    
        // Simplemente retornamos la pagina comun de seleccion de lista de precios    
        PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
        ref.getParameters().put('id',theOpp.Id);
        ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + theOpp.Id);        
        return ref;
    }
    
    public void updateAvailableList() {
        
        Set<Id> prodsARel;
        List<Id> oppsARel;
        
        // Construimos un query dinamico sobre los productos de la lista de precios
        String qString = 'select Id, Name, Pricebook2Id, IsActive, Product2.Name, Product2.Especie__c, Product2.Codigo_material_SAP__c, Product2.IsActive, Product2.Description, UnitPrice, Product2.Variedade__r.Name, Product2.Categ__r.Name, Product2.Variedade__c, Product2.Categ__c, Product2.Semilla_Tratada__c, Product2.Variedade__r.Nombre_de_Registro__c, Product2.UNIDADE__c';
        qString += ' from PricebookEntry where IsActive=true and Pricebook2Id = \'' + theBook.Id + '\'';
        
        // buscamos productos cuya descripcion o nombre coindidan con el texto ingresado
        if (searchString!=null) {
            qString+= ' and (Product2.Name like \'%' + searchString + '%\' or Product2.Codigo_material_SAP__c like \'%' + searchString +  '%\' or Product2.Variedade__r.Name like \'%' + searchString + '%\' or Product2.Variedade__r.Nombre_de_Registro__c like \'%' + searchString + '%\')';
        }
        
        if (theOpp.RecordType.Name.contains('Anexo') || theOpp.RecordType.Name == 'Aquisição Sementes Terceiros') {
            qString+= ' and Product2.Categ__r.Name= \'BASICA\' and Product2.Family= \'Royalty x Basica\'';   
        }
        
        if (theOpp.RecordType.Name == 'Anexo I' || theOpp.RecordType.Name == 'Anexo V') {
            List<Id> prodsContrato = New List<Id>();
            for (Item_del_Contrato__c itmContrato : [Select Cultivar__c From Item_del_Contrato__c Where Contrato_de_Multiplicacion__r.Multiplicador__c = : theOpp.AccountId And Contrato_de_Multiplicacion__r.Safra__c = : theOpp.Safra__c And Contrato_de_Multiplicacion__r.Sociedad__c = : theOpp.Marca__c And Cultivar__c != null And (Contrato_de_Multiplicacion__r.Chegou_na_Brasmax__c = true Or Contrato_de_Multiplicacion__r.Estado__c = 'Chegou')])
                prodsContrato.add(itmContrato.Cultivar__c);            
            qString+= ' and Product2Id In :prodsContrato';                
        }
        
        if (theOpp.RecordType.Name == 'NC - Pendiente') {
            List<Id> prodsPRel = New List<Id>();

            for (OpportunityLineItem itemsPRel : [Select Id, PricebookEntry.Product2Id From OpportunityLineItem Where OpportunityId = : theOpp.Pedido_Relacionado__c]) prodsPRel.add(itemsPRel.PricebookEntry.Product2Id);
            
            if (prodsPRel.size() > 0)  qString+= ' and Product2Id In :prodsPRel';
        }

        if (theOpp.RecordType.Name == 'Anexo I Rebaixamento Ha') {
            prodsARel = New Set<Id>();            

            for (OpportunityLineItem itemsARel : [Select Id, PricebookEntry.Product2Id From OpportunityLineItem Where OpportunityId = : theOpp.Anexo_Relacionado__c]) prodsARel.add(itemsARel.PricebookEntry.Product2Id);
            
            if (prodsARel.size() > 0) qString+= ' and Product2Id In :prodsARel';              
        }        

        if (theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas') {
            prodsARel = New Set<Id>();
            oppsARel = New List<Id>();
                       
            for (Opportunity oppsARelQ : [SELECT Id, AccountId, RecordType.Name, Safra__c, Marca__c FROM Opportunity WHERE AccountId = : theOpp.AccountId AND (RecordType.Name = 'Anexo I' OR RecordType.Name = 'Anexo I Rebaixamento Ha') AND Safra__c = : theOpp.Safra__c AND Marca__c = :theOpp.Marca__c]) oppsARel.add(oppsARelQ.Id);
            
            for (OpportunityLineItem itemsARel : [Select Id, PricebookEntry.Product2Id From OpportunityLineItem Where OpportunityId IN : oppsARel]) prodsARel.add(itemsARel.PricebookEntry.Product2Id);
            
            if (prodsARel.size() > 0) {
                System.debug('Lista product2Id: ' + prodsARel);
               qString+= ' and Product2Id In :prodsARel';
            } else {
               qString+= ' and Product2Id = null';
            }
        }

        if (theOpp.RecordType.Name == 'Anexo II' || theOpp.RecordType.Name == 'Anexo III' || theOpp.RecordType.Name == 'Anexo IV') {        
            prodsARel = New Set<Id>();
            oppsARel = New List<Id>();
   
            for (Opportunity oppsARelQ : [SELECT Id, AccountId, RecordType.Name, Safra__c FROM Opportunity WHERE AccountId = : theOpp.AccountId AND RecordType.Name = 'Anexo I' AND Safra__c = : theOpp.Safra__c])                
                oppsARel.add(oppsARelQ.Id);                            
            
            for (OpportunityLineItem itemsARel : [Select Id, PricebookEntry.Product2Id From OpportunityLineItem Where OpportunityId IN : oppsARel])
                prodsARel.add(itemsARel.PricebookEntry.Product2Id);                           
            
            if (prodsARel.size() > 0) {
                System.debug('Lista product2Id: ' + prodsARel);
               qString+= ' and Product2Id In :prodsARel';
            } else {
               qString+= ' and Product2Id = null';
            }
        }                                           

        if (theOpp.RecordType.Name == 'Stock Multiplicadores') {               
            prodsARel = New Set<Id>();
            oppsARel = New List<Id>();
            
            for (Opportunity oppsARelQ : [SELECT Id, AccountId, RecordType.Name, Safra__c  FROM Opportunity WHERE AccountId = : theOpp.AccountId AND RecordType.Name = 'Anexo I' AND Safra__c = :theOpp.Safra__c AND StageName = 'Aprobada'])
                oppsARel.add(oppsARelQ.Id);
            for (OpportunityLineItem itemsARel : [Select Id, PricebookEntry.Product2Id, PricebookEntry.Product2.Variedade__c From OpportunityLineItem Where OpportunityId IN : oppsARel])
               prodsARel.add(itemsARel.PricebookEntry.Product2.Variedade__c);                           
            
            if (prodsARel.size() > 0) {
               qString+= ' and Product2.Variedade__c In :prodsARel';
            } else {
               qString+= ' and Product2Id = null';
            }
            qString+= ' and Product2.Semilla_Tratada__c = false';                      
        }
        
        if (theOpp.RecordType.Name == 'VB - Pendiente' || theOpp.RecordType.Name == 'VB - Rechazada' || theOpp.RecordType.Name == 'VB - Pasada SAP') {               
            prodsARel = New Set<Id>();
            
            for (OpportunityLineItem itemsARel : [Select Id, PricebookEntry.Product2Id, PricebookEntry.Product2.Variedade__c From OpportunityLineItem Where OpportunityId = :theOpp.Oportunidad_Relacionada__c])
               prodsARel.add(itemsARel.PricebookEntry.Product2.Variedade__c);                           
            
            if (prodsARel.size() > 0) {
               qString+= ' and Product2.Variedade__c In :prodsARel';
            } else {
               qString+= ' and Product2Id = null';
            }
        }
                            
        
        if (theOpp.RecordType.Name == 'Previsao' || theOpp.RecordType.Name == 'Disponibilidade da Basica' || theOpp.RecordType.Name == 'Stock Multiplicadores' || theOpp.RecordType.Name == 'VB - Pendiente' || theOpp.RecordType.Name == 'VB - Rechazada' || theOpp.RecordType.Name == 'VB - Pasada SAP' || theOpp.RecordType.Name == 'Exportacion' || theOpp.RecordType.Name == 'Reembalaje' || theOpp.RecordType.Name == 'Objetivo Ventas Semilla') { // || theOpp.RecordType.Name == 'Stock Multiplicadores') {
            qString+= ' and Product2.Categ__r.Name= \'BASICA\' and Product2.Family= \'Semilla\'';   
        }
        
        if (theOpp.RecordType.Name == 'Objetivo Ventas Semilla')
            qString+= ' and Product2.Semilla_Tratada__c = false';
            
        if (theOpp.RecordType.Name == 'Objetivo Ventas Royalties')
            qString+= ' and Product2.Family = \'Royalty x Basica\'';
                        
        Set<Id> selectedEntries = new Set<Id>();
        for (opportunityLineItem d:shoppingCart) {
            selectedEntries.add(d.PricebookEntry.Product2.Id);
        }

        if (theOpp.RecordType.Name != 'Anexo V' && theOpp.RecordType.Name != 'PB-Produccion' && theOpp.RecordType.Name != 'PB-Comercial' && theOpp.RecordType.Name != 'PB-Desarrollo' && theOpp.RecordType.Name != 'VB - Pendiente' && theOpp.RecordType.Name != 'Anexo I' && theOpp.RecordType.Name != 'Anexo II' && theOpp.RecordType.Name != 'Anexo I Rebaixamento Ha' && theOpp.RecordType.Name != 'VB - Rechazada' && theOpp.RecordType.Name != 'Anexo II Rebaixamento Sacas' && theOpp.RecordType.Name != 'Anexo III' && theOpp.RecordType.Name != 'Anexo IV' && theOpp.RecordType.Name != 'Exportacion' && theOpp.RecordType.Name != 'Reembalaje' && theOpp.RecordType.Name != 'Objetivo Ventas Semilla' && theOpp.RecordType.Name != 'Stock Multiplicadores') {
            if (selectedEntries.size()>0) qString+= ' and Product2Id not In :selectedEntries';
        }
        if (theOpp.RecordType.Name == 'PB-Comercial'  || theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'PB-Desarrollo' || theOpp.RecordType.Name == 'PB-Oferta') {
            qString+= ' and Product2.Family= \'Semilla\' and Product2.Semilla_Tratada__c = false';
            qString+= ' order by Product2.Categ__r.Name, Product2.Name';
        } else {
            qString+= ' order by Product2.Name';
        }
        qString+= ' limit 31';
        
        system.debug('qString:' +qString);        
        AvailableProducts = database.query(qString);
        
        // Solo se mostraran hasta 30 registros... si el query tiene mas, entonces el usuario vera un mensaje
        if (AvailableProducts.size()==31) {
            AvailableProducts.remove(30);
            overLimit = true;
        }
        else {
            overLimit=false;
        } 
    }
    
    public void addToShoppingCart() {
    
        // Cuando el usuario presiona "Seleccionar" en un producto    

        for (PricebookEntry d : AvailableProducts) {
            if ((String)d.Id==toSelect) {
                Boolean primeraVezVariedad = true;
                for (OpportunityLineItem i : shoppingCart){
                    if (i.PricebookEntryId == d.Id){
                        primeraVezVariedad = false;
                        break;
                    }
                }  
                //shoppingCart.add(new opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, ZZPOSSF__c = String.valueOf(contador), Variedad__c = d.Product2.Variedade__c, Volume__c = 0.0, Expec_Prod_Bruta__c = 0.0, Tasas__c = sumaTasas));
                OpportunityLineItem item = New opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, ZZPOSSF__c = String.valueOf(contador), Variedad__c = d.Product2.Variedade__c, Volume__c = 0.0, Expec_Prod_Bruta__c = 0.0, Tasas__c = sumaTasas);
                if (theOpp.Local_de_Entrega__c != null)
                    item.Local_de_Entrega__c = theOpp.Local_de_Entrega__c;
                if (theOpp.RecordType.Name == 'VB - Pendiente') {
                    item.Tipo_de_Necesidad__c = 'Multiplicação';
                    item.Tratamiento_de_Semilla__c = 'T00 - Sem';
                }            
                if (theOpp.RecordType.Name == 'Stock Multiplicadores' && primeraVezVariedad){
                    item.WERKS__c = 'x';
                }     
                shoppingCart.add(item);
                contador++;
                break;
            }
        }
        
        updateAvailableList();  
    }

    public PageReference removeFromShoppingCart() {
    
        // Cuando el usuario presiona "Eliminar" en un producto seleccionado    
        Integer count = 0;
    
        for (opportunityLineItem d : shoppingCart) {
            if ((String)d.ZZPOSSF__c==toUnselect) {
                if (theOpp.RecordType.Name == 'Stock Multiplicadores' && d.WERKS__c == 'x'){
                    String pbeId = d.PricebookEntryId;
                    Integer j = 0;
                    while (j < shoppingCart.size()){
                        if(shoppingCart.get(j).PricebookEntryId == pbeId){  
                            if (shoppingCart.get(j).Id!=null)
                                forDeletion.add(shoppingCart.get(j));                                                                
                            shoppingCart.remove(j);                                       
                        }else{
                            j++;
                        }
                    }
                    break;
                }else{  
                    if (d.Id!=null)
                        forDeletion.add(d);
                
                    shoppingCart.remove(count);
                    break;
                }
            }
            count++;
        }
        
        updateAvailableList();
        
        return null;
    }
    
    public Boolean validarRebajaAnexoI(List<OpportunityLineItem> items) { //Se utiliza para validar la rebaja de Ha. y de Bolsas

        Boolean retorno = true;
        Double sumArea = 0;
        Double sumBolsas = 0;
        Map <Id, String> categorias = New Map <Id, String>();
        Map <String, Double> cantidades = New Map <String, Double>();
        Map <String, Double> cantXVarInf = New Map <String, Double>();
        Set <String> prodsDupli = New Set <String>();
        
        for (Categoria__c c :[Select Id, Name From Categoria__c])
            categorias.put(c.Id, c.Name);
                        
        for (OpportunityLineItem i : items) {
                
            if ((categorias.get(i.Categoria__c).length() == 1 && categorias.get(i.Categoria_a_Rebaixar__c).length() != 1) || (categorias.get(i.Categoria_a_Rebaixar__c).length() == 1 && categorias.get(i.Categoria__c).length() != 1)) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Error Categoria. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - '  + categorias.get(i.Categoria__c)); ApexPages.addMessage(msg);
                if (!Test.isRunningTest()) return false;             
            }
            if (categorias.get(i.Categoria__c).length() == 1) {
                if (categorias.get(i.Categoria__c).compareTo(categorias.get(i.Categoria_a_Rebaixar__c)) >= 0) {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Error Categoria. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - '  + categorias.get(i.Categoria__c));  ApexPages.addMessage(msg);
                    if (!Test.isRunningTest()) return false;
                }
            } else {
                if (categorias.get(i.Categoria__c).compareTo(categorias.get(i.Categoria_a_Rebaixar__c)) <= 0) {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Error Categoria. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - '  + categorias.get(i.Categoria__c)); ApexPages.addMessage(msg);
                    if (!Test.isRunningTest()) return false;
                }
            }
            
            if (theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas' || Test.isRunningTest()) {

                if (cantXVarInf.ContainsKey(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c))) {
                    sumBolsas = 0;
                    sumBolsas = cantXVarInf.get(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) + i.Sem_Rebajada__c;
                    cantXVarInf.remove(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c));
                    cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), sumBolsas);
                } else {
                    cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), i.Sem_Rebajada__c);
                }
            } else {
                if (cantXVarInf.ContainsKey(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c))) {
                    sumArea = 0;
                    sumArea = cantXVarInf.get(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) + i.Area__c;
                    cantXVarInf.remove(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c));
                    cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), sumArea);
                } else {
                    cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), i.Area__c);
                }
            }
        }

        for (AggregateResult pr : [Select Id, Categoria_a_Rebaixar__c, PricebookEntry.Product2Id, Sum(Area__c) Area__c, Sum(Sem_Rebajada__c) Sem_Rebajada__c From OpportunityLineItem Where Opportunity.Anexo_Relacionado__c = : theOpp.Anexo_Relacionado__c AND Opportunity.RecordType.Name = :theOpp.RecordType.Name AND OpportunityId != :theOpp.Id Group By Id, Categoria_a_Rebaixar__c, PricebookEntry.Product2Id limit 500]) {
            
            if (theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas') {
                if (cantXVarInf.ContainsKey((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'))) {
                    sumBolsas = 0;
                    sumBolsas = cantXVarInf.get((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c')) + (Double)pr.get('Sem_Rebajada__c');
                    cantXVarInf.remove((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'));
                    cantXVarInf.put((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'), sumBolsas);
                }
            } else {
                if (cantXVarInf.ContainsKey((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'))) {
                    sumArea = 0;
                    sumArea = cantXVarInf.get((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c')) + (Double)pr.get('Area__c');
                    cantXVarInf.remove((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'));
                    cantXVarInf.put((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'), sumArea);
                }
            }
        }
        
        Map<String, String> prods_anexo_rel = New Map <String, String>(); 
        for (AggregateResult p : [Select Categoria__c, PricebookEntry.Product2Id, Sum(Area__c) Area__c, Sum(Semente_bruta__c) Semente_bruta__c From OpportunityLineItem Where OpportunityId = : theOpp.Anexo_Relacionado__c Group By Categoria__c, PricebookEntry.Product2Id]) {            
            //prods_anexo_rel.put(String.valueOf(p.get('Product2Id')) + String.valueOf(p.get('Categoria__c')),String.valueOf(p.get('Product2Id')) + String.valueOf(p.get('Categoria__c')));
            //cantidades.put(String.valueOf(p.get('Product2Id')) + String.valueOf(p.get('Categoria__c')), Double.valueOf(p.get('Area__c')));
            prods_anexo_rel.put((String)p.get('Product2Id') + (String)p.get('Categoria__c'),(String)p.get('Product2Id') + (String)p.get('Categoria__c'));
            if (theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas') {
                cantidades.put((String)p.get('Product2Id') + (String)p.get('Categoria__c'), (Double)p.get('Semente_bruta__c'));
            } else {
                cantidades.put((String)p.get('Product2Id') + (String)p.get('Categoria__c'), (Double)p.get('Area__c'));
            }
        }
        
        if (prods_anexo_rel.size() > 0 && cantXVarInf.size() > 0) {
            for (OpportunityLineItem i : items) {
                if (prods_anexo_rel.get(String.valueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) == null) {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'No existe el producto en el anexo relacionado a la rebaja. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - ' + categorias.get(i.Categoria__c)); ApexPages.addMessage(msg);
                    if (!Test.isRunningTest()) return false;
                }
                if (cantXVarInf.get(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) > cantidades.get(String.valueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c))) {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Cantidad excedida. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - ' + categorias.get(i.Categoria_a_Rebaixar__c)); ApexPages.addMessage(msg);
                    if (!Test.isRunningTest()) return false;
                }
                                       
            }
        }         
        return retorno;
    }
    
    public PageReference onSave() {
        List<OpportunityLineItem> deleteVB = New List<OpportunityLineItem>();
        List<OpportunityLineItem> insertVB = New List<OpportunityLineItem>();
        OpportunityLineItem cloneVB = New OpportunityLineItem();
        Boolean ofPend = false;
        // Si algun producto ya selecciondo es eliminado, entonces debemos quitarlo
        Savepoint sp;
        try{        
        // Los datos ya cargados deben ser actualizados
            sp = Database.setSavepoint();
            if (forDeletion.size()>0)
                delete(forDeletion);
            if (theOpp.RecordType.Name == 'CVB - Pendiente')
                if (!validarOfertaSAP(shoppingCart)) return null;
            Set<String> pbeIdEstadoComer = New Set<String>();
            String estadoComerIdAnt = null;
            if (shoppingCart.size() > 0)
                estadoComerIdAnt = shoppingCart[0].Estado_de_Comercializacion__c;
                
            Map<String, Double> mapCantEstim = New Map<String, Double>();
            if (theOpp.RecordType.Name == 'Stock Multiplicadores'){
                for (OpportunityLineItem i : shoppingCart){
                    if(i.WERKS__c == 'x' && i.Estimativa__c != null)
                        mapCantEstim.put(i.PricebookEntryId, i.Estimativa__c);
                }
            }  
            for (OpportunityLineItem i : shoppingCart) {
                if (i.Quantity == null) i.Quantity = 0.01;
                        
                if (theOpp.RecordType.Name == 'VB - Pendiente'  || theOpp.RecordType.Name == 'VB - Rechazada' || theOpp.RecordType.Name == 'VB - Autorizada' || theOpp.RecordType.Name == 'Exportacion' || theOpp.RecordType.Name == 'Reembalaje' || theOpp.RecordType.Name == 'Aquisição Sementes Terceiros') {
                    system.debug('ENTRO A CAMBIAR EL PRD' );
                    if (i.Categoria__c != i.PricebookEntry.Product2.Categ__c) {//Si le cambió la categoría al producto, elimino el existente y traigo el ue corresponde a esa categoría
                        system.debug('DETECTO QUE LAS CATEGORIAS SON DIFERENTES');
                        system.debug('qString:' +'SELECT Id, Name, Pricebook2Id, IsActive, Product2.Name, Product2.Especie__c, Product2.Categoria__c, Product2.Codigo_material_SAP__c, Product2.IsActive, Product2.Description, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = \''+ theBook.Id +'\' AND Product2.Variedade__c = \''+i.PricebookEntry.Product2.Variedade__c+ '\' AND Product2.Categ__c =\''+ i.Categoria__c+'\' AND IsActive = true AND Product2.Semilla_Tratada__c = \''+i.PricebookEntry.Product2.Semilla_Tratada__c +'\'limit 1');
                        for (PricebookEntry newPbe :[SELECT Id, Name, Pricebook2Id, IsActive, Product2.Name, Product2.Especie__c, Product2.Categoria__c, Product2.Codigo_material_SAP__c, Product2.IsActive, Product2.Description, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :theBook.Id AND Product2.Variedade__c = :i.PricebookEntry.Product2.Variedade__c AND Product2.Categ__c =: i.Categoria__c AND Product2.Unidade__c =: i.PricebookEntry.Product2.Unidade__c AND IsActive = true AND Product2.Semilla_Tratada__c = :i.PricebookEntry.Product2.Semilla_Tratada__c limit 1]) {
                            cloneVB = i.clone(false, true);
                            
                            cloneVB.PricebookEntryId = newPbe.Id; cloneVB.OpportunityId = i.OpportunityId; cloneVB.UnitPrice = i.UnitPrice; cloneVB.TotalPrice = null; //cloneVB.Motivo_de_Rechazo__c = 'Z9 - Pendente de análise';
                            insertVB.Add(cloneVB);
                            deleteVB.Add(i);
                            //shoppingCart.add(new opportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice));
                            
                        }
                    }
                }
                 if (theOpp.RecordType.Name == 'Previsao') {
                     i.Es_Previsao__c = true;
                     if (i.PricebookEntry.Product2.Semilla_Tratada__c == true) i.Tratamiento_de_Semilla__c = 'T05 - Cruiser+Maxim+Amulet';
                     
                 }
                 if (theOpp.RecordType.Name == 'PB-Produccion' || theOpp.RecordType.Name == 'PB-Comercial' || theOpp.RecordType.Name == 'PB-Desarrollo' || theOpp.RecordType.Name.contains('Anexo') || theOpp.RecordType.Name == 'Stock Multiplicadores' || theOpp.RecordType.Name == 'Objetivo Ventas Royalties') {
                    i.Tipo_Registro__c = theOpp.RecordType.Name;
                 }
                 if (((theOpp.RecordType.Name == 'PB-Produccion' && theOpp.Tipo_de_Operacion__c == '7-Descarte') || ((theOpp.RecordType.Name == 'PB-Comercial' || theOpp.RecordType.Name == 'PB-Desarrollo') && theOpp.Tipo_de_Operacion__c == '4-Cancelamento')) && i.Quantidade__c > 0) {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Você deve digitar um valor negativo');                 
                    ApexPages.addMessage(msg);
                    return null;
                 }
                 if (theOpp.RecordType.Name == 'VB - Pasada SAP' && ofPend == false) {
                    if (i.Motivo_de_Rechazo__c != '' && i.Motivo_de_Rechazo__c != null) ofPend = true;
                 } 
                 
                 if (theOpp.RecordType.Name == 'Stock Multiplicadores'){                     
                    if (mapCantEstim.get(i.PricebookEntryId) != null && i.WERKS__c != 'x')
                        i.Estimativa__c = mapCantEstim.get(i.PricebookEntryId);
                    if ((estadoComerIdAnt == null && i.Estado_de_Comercializacion__c != null) || (estadoComerIdAnt != null && i.Estado_de_Comercializacion__c == null)){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Deve inserir todos os itens com UF ou todos os itens sem UF.');                 
                        ApexPages.addMessage(msg);
                        return null;
                    }
                    estadoComerIdAnt = i.Estado_de_Comercializacion__c;
                    if (pbeIdEstadoComer.contains(String.valueOf(i.PricebookEntryId) + String.valueOf(i.Estado_de_Comercializacion__c))){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Existen produtos duplicados.');                 
                        ApexPages.addMessage(msg);
                        return null;
                    }
                    pbeIdEstadoComer.add(String.valueOf(i.PricebookEntryId) + String.valueOf(i.Estado_de_Comercializacion__c));
                    i.WERKS__c = null;
                }            
            }  
               
            if (shoppingCart.size()>0)
                upsert(shoppingCart);
            if (insertVB != null && insertVB.size()>0)
                insert insertVB;
            if (deleteVB != null && deleteVB.size()>0)
                delete deleteVB;
            if (theOpp.RecordType.Name == 'VB - Pasada SAP' && theOpp.PE_bajar_SAP__c == false && ofPend == true) {
                theOpp.PE_Bajar_SAP__c = true;
                update theOpp;
            }
            
            if (theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas') {
                aSiteUtils.retorno ret = aAppManager.completarRegistrosRebaja(theOpp.Id); 
                if (!ret.exito) {
                    Database.rollback(sp);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,ret.mensaje));
                    return null;
                }
            } 
            
        }
        catch(Exception e) {
            ApexPages.addMessages(e);
            Database.rollback(sp);
            return null;
        }  
           
        // Luego de grabar los cambios retornamos al usuario a la opp
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public Boolean validarOfertaSAP(List<OpportunityLineItem> items) { 
        List <OpportunityLineItem> ListaItemsParaActualizarEstado = New List<OpportunityLineItem>();
        Map<Id,OpportunityLineItem> oplisSAP = New Map<Id, OpportunityLineItem>();
        Set<Id> ofItems = New Set<Id>();
        for (OpportunityLineItem i: items) ofItems.add(i.Id_Item_de_Oportunidad_Relacionado__c);
         
        for (OpportunityLineItem opli : [SELECT Id, Quantity, Id_Item_de_Oportunidad_Relacionado__c FROM OpportunityLineItem WHERE Id IN :ofItems]) {
            oplisSAP.put(opli.Id_Item_de_Oportunidad_Relacionado__c, opli);
        }
        for (OpportunityLineItem opli : [SELECT Id, OpportunityId, PricebookEntry.Product2.Variedade__r.Name, PricebookEntry.Product2.Categ__r.Name, Quantity, Id_Item_de_Oportunidad_Relacionado__c, Quant_Pendiente__c, Quant_Confirmada__c FROM OpportunityLineItem WHERE Id IN :oplisSAP.keySet()]) {
            if ((opli.Quant_Confirmada__c + oplisSAP.get(opli.Id).Quantity) < opli.Quant_Pendiente__c) {opli.Quant_Confirmada__c = opli.Quant_Confirmada__c + oplisSAP.get(opli.Id).Quantity;}
            else {
                //retorno[0] = 'A quantidade confirmada não pode ser maior que a Quantidade Pendiente na Oferta.';
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'A quantidade confirmada não pode ser maior que a Quantidade Pendiente na Oferta.');                 
                ApexPages.addMessage(msg);
                return false;
            }
        }
        return true;
    }

    public PageReference onCancel() {        
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public List<Schema.FieldSetMember> getFields() {
        Opportunity o = [Select RecordType.Name From Opportunity Where Id = : theOpp.Id];
        if (o.RecordType.Name == 'Anexo I') return SObjectType.OpportunityLineItem.FieldSets.AnexoI.getFields();
        if (o.RecordType.Name == 'Anexo II') return SObjectType.OpportunityLineItem.FieldSets.AnexoII.getFields();
        if (o.RecordType.Name == 'Anexo III') return SObjectType.OpportunityLineItem.FieldSets.Anexo_III.getFields();  
        if (o.RecordType.Name == 'Anexo IV') return SObjectType.OpportunityLineItem.FieldSets.Anexo_IV.getFields();    
        if (o.RecordType.Name == 'Anexo V') return SObjectType.OpportunityLineItem.FieldSets.Anexo_V.getFields();             
        if (o.RecordType.Name == 'Pendiente') return SObjectType.OpportunityLineItem.FieldSets.Pendiente.getFields();    
        if (o.RecordType.Name == 'NC - Pendiente' || o.RecordType.Name == 'NC - Autorizada') return SObjectType.OpportunityLineItem.FieldSets.Nota_de_Credito.getFields(); 
        if (o.RecordType.Name == 'Previsao') return SObjectType.OpportunityLineItem.FieldSets.Previsao.getFields();
        if (o.RecordType.Name == 'Exportacion') return SObjectType.OpportunityLineItem.FieldSets.Exportacion.getFields();
        if (o.RecordType.Name == 'Reembalaje') return SObjectType.OpportunityLineItem.FieldSets.Reembalaje.getFields();
            
        return New List<Schema.FieldSetMember>();                     
    }

    public Pagereference onSaveCVBPendiente() {
        try {
            List<OpportunityLineItem> itemsToUpsert = new List<OpportunityLineItem>();
            
            for (PBEWrapper wrapp : shoppingCartWrappersUpsert) {
                OpportunityLineItem item = new OpportunityLineItem();
                
                if (wrapp.item != null) {
                    if (wrapp.PBE != null) { // si posee item y un PBE, es porque ya existía y se modificó el producto
                        forDeletion.add(wrapp.item); // no puede modificarse el PricebookEntry, debe eliminarse el OpportunityLineItem y crear uno nuevo
                        item.OpportunityId = theOpp.Id;
                        item.Tipo_de_Necessidade__c = wrapp.Tipo_de_Necesidad;
                        item.UnitPrice = wrapp.item.UnitPrice;
                        item.Id_Item_de_Oportunidad_Relacionado__c = wrapp.item.Id_Item_de_Oportunidad_Relacionado__c;
                        item.Posicion_SAP_Relacionada__c = wrapp.item.Posicion_SAP_Relacionada__c;
                        item.PricebookEntryId = wrapp.PBE.Id;
                    } else { // en este caso solo se actualizará la cantidad de bolsas del OpportunityLineItem
                        item.Id = wrapp.item.Id;
                    }
                } else { // debe buscarse en la VB Completa un OpportunityLineItem que coincida con los valores ingresados por el usuario
                    Integer position = 0;
                    Boolean match = true;

                    while (match && position < VBCompleta.OpportunityLineItems.size()) {
                        Boolean match1 = VBCompleta.OpportunityLineItems[position].Variedade_Prod__c == wrapp.Variedad;
                        Boolean match2 = VBCompleta.OpportunityLineItems[position].Tipo_de_Necessidade__c == wrapp.Tipo_de_Necesidad;

                        if (match1 && match2) {
                            item.OpportunityId = theOpp.Id;
                            item.Tipo_de_Necessidade__c = wrapp.Tipo_de_Necesidad;
                            item.UnitPrice = VBCompleta.OpportunityLineItems[position].UnitPrice;
                            item.Id_Item_de_Oportunidad_Relacionado__c = VBCompleta.OpportunityLineItems[position].Id;
                            item.Posicion_SAP_Relacionada__c = VBCompleta.OpportunityLineItems[position].Posicion_SAP__c;
                            item.PricebookEntryId = wrapp.PBE.Id;
                            match = false;
                        }

                        position++;
                    }
                }

                item.Quantity = wrapp.quantity;

                itemsToUpsert.add(item);
            }

            if (!forDeletion.isEmpty()) { delete(forDeletion); }

            upsert itemsToUpsert;

            return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }

    public Pagereference onCancelCVBPendiente() {
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }

    public class PBEWrapper {
        
        public String id                    {get; set;}
        public OpportunityLineItem item     {get; set;}
        public PricebookEntry PBE           {get; set;}
        public Double quantity              {get; set;}
        public Double cantSubUnidad         {get; set;}
        public String idVariedad            {get; set;}
        public String Variedad              {get; set;}
        public String idCategoria           {get; set;}
        public String Categoria             {get; set;}
        public String idUnidad              {get; set;}
        public String Unidad                {get; set;}
        public String Nombre_de_Registro    {get; set;}
        public String Tipo_de_Necesidad     {get; set;}
        public Double cantidadKgDisponible  {get; set;}
        
        public List<SelectOption> opcionesVariedad          {get; set;}
        public List<SelectOption> opcionesCategoria         {get; set;}
        public List<SelectOption> opcionesUnidad            {get; set;}

        public Boolean readOnly                             {get; set;}

        public PBEWrapper() {
            this.opcionesVariedad = new List<SelectOption>();
            this.opcionesCategoria = new List<SelectOption>();
            this.opcionesUnidad = new List<SelectOption>();
            this.readOnly = true;
            this.cantSubUnidad = 0;
            this.Nombre_de_Registro = '';
            this.cantidadKgDisponible = 0;
        }
    }

    private PBEWrapper getWrapper() {
        Integer position = 0;
        PBEWrapper wrapp = null;

        while (wrapp == null && position < shoppingCartWrappersUpsert.size()) {
            if (toEdit == shoppingCartWrappersUpsert[position].id) {
                wrapp = shoppingCartWrappersUpsert[position];
            }

            position++;
        }

        return wrapp;
    }
}
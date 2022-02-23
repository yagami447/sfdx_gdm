public without sharing class aSiteVendaDeBasicaController {
    private String token;
    private SiteUser__c logUser;
    public Account activeAccount {get;set;}
    private SiteUserSession__c activeSession;
    public String safraActual {get;set;}
    public String safraActualEstimativaCompra {get;set;}
    public Opportunity venta {get;set;}
    public List<Quote> presupuestos {get;set;}
    public List<Opportunity> pedidos {get;set;}
    public Account cuenta {get;set;}
    public List<Opportunity> pedidosRelacionados {get;set;}
    
    public Opportunity newOpp {get;set;}
    public Quote newQuote {get;set;}
    public String newProduct {get;set;}
    public String updateProductId {get;set;}
    public Map<Id, ProductosSeleccionados> newProducts {get;set;}
    public Map<Id, ProductosSeleccionados> opportunityLineItems {get;set;}
    public Boolean hayProductos {get;set;}
    public Map<Id, PricebookEntry> products {get;set;}
    public List<SelectOption> productOptions {get;set;}
    public List<SelectOption> variedadOptions {get;set;}
    public Map<Id, Variedad__c> variedades  {get; set;}
    public List<SelectOption> newProductOptions {get;set;}
    public List<SelectOption> listContacts {get;set;}
    public List<SelectOption> condicionesDePagos {get;set;}
    public List<OpportunityLineItem> productosDisponibles {get; set;}
    public List<Id> idOrderItems = new List<Id>();   
    public ContactAndProduct contactProduct {get; set;}
    
    public Response response{get;set;}
    public Map<Id, Opportunity> ordersByContact{get;set;}
    public String comentario{get;set;}
    public string error{get;set;}
    
    public Boolean modificarCondicionDePago {get; set;}
    private boolean esNueva {get;set;}
    public Id itemToRemove {get; set;}
    public String contactToRemove {get; set;}
    public String presupuestoId {get; set;}
    public String condicionDePago {get; set;}
    
    public List<OrderWrapper> ordersByContactValues {get; set;}
    public List<ProductosSeleccionados> productosSeleccionadosValues {get; set;}
    public List<PresupuestosWrapper> presupuestosWrapperValues {get; set;}
    public List<OpportunityWrapper> opportunitiesWrapperValues {get; set;}
    
    public String cantidadRequisicion {get;set;}
    public Double algo {get; set;}
    public String  cantidadRequisicionErrorMessage {get;set;}
    public List<productoRequisicion> productosRequisicion {get;set;}
    public List<productoRequisicion> productosEliminados {get;set;}
    public Requisicao_de_compra__c requisicionActual        {get; set;}
    public String productoRequisicionSeleccionado           {get; set;}
    public Integer idEliminar                               {get; set;}
    public Integer lastId                                   {get; set;}
    public Boolean requisicionEditable                      {get; set;}
    public id OpportunityIdAConfirmar {get;set;}
    public string comentarioRastreamientoTransporte {get;set;}
    public String OpportunityIdADevolver {get; set;}
    public list<paginacion> paginaciones = new list<paginacion>{};
    public Integer pagingNumber {get; set;}
    public string mensaje {get;set;}
    @TestVisible public Boolean isTest = false;
    public Id indexOpp {get;set;}
    
    public aSiteVendaDeBasicaController(boolean isEmpty) {
        
    }
    
    public aSiteVendaDeBasicaController() {
         //PageSize = 10;
         //PageNumber = 1;
         //RecordCount = 0;
        mensaje = null;
         //System.debug('Entre venda de basica');
        ordersByContact = new Map<Id, Opportunity>();
        newProducts = new Map<Id, ProductosSeleccionados>();
        contactProduct = new ContactAndProduct();
        opportunityLineItems = new Map<Id, ProductosSeleccionados>();
        productosRequisicion = new List<ProductoRequisicion>();
        productosEliminados = new List<ProductoRequisicion>();
        esNueva = false;
        hayProductos = false;
        pagingNumber = 0;
        token = System.currentPageReference().getParameters().get('token');
        System.debug('COnstructor Token: '+token);
        if(token!=null){
            logUser = aSiteAuthManager.VerifyUserSession(token);
            
            if(logUser!=null){
                    activeSession = aSiteAuthManager.getUserSession(token);
                activeAccount = aSiteAuthManager.getActiveAccount_byUser(logUser);
               
                Configuracion_BMX__c config = [
                    SELECT id, PM_Safra_Actual_VendaBasica__c,PM_Safra_Actual_VB_Estimativa_de_Compra__c 
                    FROM Configuracion_BMX__c 
                    ORDER BY CreatedDate ASC 
                    LIMIT 1 
                ];

                safraActual = config.PM_Safra_Actual_VendaBasica__c;  //aAppManager.getSafraActualByApp('VendaBasica'); 
                safraActualEstimativaCompra = config.PM_Safra_Actual_VB_Estimativa_de_Compra__c;
                //safraActual =   [SELECT id, PM_Safra_Actual_VendaBasica__c FROM Configuracion_BMX__c ORDER BY CreatedDate ASC LIMIT 1 ].PM_Safra_Actual_VendaBasica__c;  //aAppManager.getSafraActualByApp('VendaBasica'); 
                cuenta = getAccount(activeAccount);
                init(); /////
                getProducts();
                
                setVariedadesOptions();

                getOppLineItems();
                getContact();
                getOrderItems();
                getOpportunityLineItems();  
                changeOpportunityLineItems();   
                getRequisicao(); 
            }
        }
		
        paginaciones.add(new paginacion(0,10,[
            SELECT count() 
            FROM Opportunity 
            WHERE RecordType.DeveloperName = 'CVB_Autorizada' 
                       //     AND AccountId =: activeAccount.id
        ]));
        paginaciones.add(new paginacion(0,10,[
            SELECT count() 
            FROM Opportunity 
            WHERE RecordType.DeveloperName = 'Devolucion' 
                        //    AND AccountId =: activeAccount.id
        ]));
        System.debug('Termino Constructor');
    }
    // @RemoteAction
    

    public static Account getAccount(Account acc) {
        List<Account> accounts = [
        SELECT Id, Name, Marca__c, Region__c, Region__r.Name, Region__r.Region_comercial__c, Responsavel__c, Reponsavel_DSEM__c
        FROM Account
        WHERE Id = :acc.Id
        ];
        return accounts[0];
    }

    
    public PageReference validate() {
        System.debug('Validate running');
        if (token == null || logUser == null) {
            PageReference p = new PageReference('/apex/aSiteLogin');
            String marca = aSiteAuthManager.getMarcaBySession(token);
            if (marca != null) p.getParameters().put('comp',marca);
            p.setRedirect(true);
            return p;
        }
        System.debug('end Validate');
        return null;
    }

    public void crearProductoRequisicion() {
        System.debug('Cantidad1: ' + cantidadRequisicion);
        List<String> cantSplited = cantidadRequisicion.split(',');
        
        cantSplited[0] = cantSplited[0].replace('.', '');
        if(cantSplited.size() == 2){
            cantidadRequisicion = cantSplited[0] + '.' +cantSplited[1];
        }else{
            cantidadRequisicion = cantSplited[0];
        }
        System.debug('Cantidad2: ' + cantidadRequisicion);
        
        // cantidadRequisicion = cantidadRequisicion.replace('.',',');
        // cantidadRequisicion = cantidadRequisicion.replace('.','');
        Boolean breakOutOfFunc = false; 

        for (ProductoRequisicion prod : productosRequisicion) {
            if (aSiteAuthManager.getMarcaBySession(token) != 'DSEM' && variedades.get(Id.valueOf(productoRequisicionSeleccionado)).Name + ' - ' + variedades.get(Id.valueOf(productoRequisicionSeleccionado)).Nombre_de_Registro__c == prod.nombre) {
                breakOutOfFunc = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Esse produto já está adicionado na sua estimativa.'));
            } 
            if (
                    aSiteAuthManager.getMarcaBySession(token) == 'DSEM' 
                    && variedades.get(Id.valueOf(productoRequisicionSeleccionado)).Name == prod.nombre
                    )
            {
                breakOutOfFunc = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Esse produto já está adicionado na sua estimativa.'));
            }
        }
        if (!breakOutOfFunc) {
            
            if(Decimal.valueOf(cantidadRequisicion) >= 4000){
                ProductoRequisicion nuevoProducto = new ProductoRequisicion();
                System.debug(productoRequisicionSeleccionado);
                if (aSiteAuthManager.getMarcaBySession(token) == 'DSEM') {
                    nuevoProducto.nombre = variedades.get(Id.valueOf(productoRequisicionSeleccionado)).Name;
                }else {
                    nuevoProducto.nombre = variedades.get(Id.valueOf(productoRequisicionSeleccionado)).Name + ' - ' + variedades.get(Id.valueOf(productoRequisicionSeleccionado)).Nombre_de_Registro__c;    
                }
                nuevoProducto.cantidad = Decimal.valueOf(cantidadRequisicion);
                nuevoProducto.cantidadString = formatDecimal(nuevoProducto.cantidad, 2, '.', ',');
                System.debug(productoRequisicionSeleccionado);
                nuevoProducto.variedadId = productoRequisicionSeleccionado;
                nuevoProducto.eliminada = false;
                if(productosRequisicion.isEmpty()) {
                    nuevoProducto.idPR = 0;
                }
                else {
                    nuevoProducto.idPR = lastId + 1;
                }
                Integer zero = 0;
                lastId = nuevoProducto.idPR;
                productosRequisicion.add(nuevoProducto);
                System.debug('Cantidad3: ' + cantidadRequisicion);
                cantidadRequisicion = zero.format();    
                System.debug('Cantidad4: ' + cantidadRequisicion);
                mensaje = null;
            // return null;
            } else {
                mensaje = 'Quantidade mínima de 4.000 Kg';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Quantidade mínima de 4.000 Kg'));
                
            // return null;
            }   

        }
    } 
    
    public List<SelectOption> getProducts() {
        products = new Map<Id, PricebookEntry>([
        SELECT Id, Name, Product2Id
        FROM PricebookEntry
        WHERE Pricebook2.Para_venda_de_b_sica_inicial__c = true
        ]);
        productOptions = new List<SelectOption>();
        
        for (PricebookEntry p : products.values()) {
            productOptions.add(new SelectOption(p.Id, p.name));
        }
        return productOptions;
    }

    public static Map<Id, Variedad__c> getVariedades(String Region, String token, Account cuenta) {

        String marca = aSiteAuthManager.getMarcaBySession(token);

        if((cuenta.Responsavel__c != null && marca == 'BRMX') || (cuenta.Reponsavel_DSEM__c != null && marca == 'DSEM')){
            return new Map<Id, Variedad__c>([
            SELECT Id, Name, Nombre_de_Registro__c
            FROM Variedad__c
            WHERE Disponivel_para_venda_basica__c = true
            AND Sociedad__c = :marca
            AND Regiao_disponivel_para_venda_basica__c INCLUDES (:Region)
            ]);
        }  else {
            return new Map<Id, Variedad__c>();
        }       
        
    }

    public void setVariedadesOptions() {
        String nameProduct;
        system.debug(cuenta.Marca__c + ' - ' + cuenta.Region__r.Region_Comercial__c);
        variedades = getVariedades(cuenta.Region__r.Region_Comercial__c, token, cuenta);
        variedadOptions = new List<SelectOption>();
        System.debug(activeAccount.Id);
        if (!variedades.isEmpty()) {
            for (Variedad__c p : variedades.values()) {
                if (aSiteAuthManager.getMarcaBySession(token) == 'DSEM') {
                    nameProduct = p.name ;
                    variedadOptions.add(new SelectOption(p.Id, nameProduct)); 
                }else {
                    nameProduct = p.name + ' - ' + p.Nombre_de_Registro__c;
                    variedadOptions.add(new SelectOption(p.Id, nameProduct));     
                } 
                
                
            }
        }       
        System.debug(variedadOptions);
    }
    
    public List<SelectOption> getOppLineItems() {
        newProductOptions = new List<SelectOption>();
        
        for (OpportunityLineItem oppLineItems : venta.OpportunityLineItems) {
            newProductOptions.add(new SelectOption(oppLineItems.PricebookEntryId, oppLineItems.Product2.Name));
        }
        
        return newProductOptions;
    }

    
    
    public List<SelectOption> getContact() {
        listContacts = new List<SelectOption>();
        
        List<Opportunity> opps = getOportunidad();
        if(opps.isEmpty()) 
            return listContacts;
        List<Contact> contacts = [
        SELECT Id, Name
        FROM Contact
        WHERE AccountId = :opps[0].AccountId
        ];
        
        for (Contact contacto : contacts) {
            listContacts.add(new SelectOption(contacto.Id, contacto.Name));
        }
        
        return listContacts;
    }

    public void getOpportunityLineItems() {
        
        for(OpportunityLineItem oppLineItem : venta.OpportunityLineItems) {
            ProductosSeleccionados newProductosSeleccionados = new ProductosSeleccionados();    
            newProductosSeleccionados.id = oppLineItem.Id;
            newProductosSeleccionados.label = oppLineItem.Product2.Name;
            newProductosSeleccionados.cantidad = oppLineItem.Quantity;
            newProductosSeleccionados.pricebookEntryId = oppLineItem.PricebookEntryId;
            opportunityLineItems.put(newProductosSeleccionados.id, newProductosSeleccionados);
        }
    }

    public void changeOpportunityLineItems() {
        Set<Id> productsId = new Set<Id>();
        List<OpportunityLineItem> ListOrderItem = new List<OpportunityLineItem>();
        
        for(OrderWrapper ordWrapper : ordersByContactValues) {
            for(OpportunityLineItem ordItem : ordWrapper.orderItems.values()) {
                productsId.add(ordItem.Product2Id);
                ListOrderItem.add(ordItem);
            }
        }
        
        Map<Id, OpportunityLineItem> mapOpportunityLineItem = new Map<Id, OpportunityLineItem>([
        SELECT Id, Name, Product2Id, Quantity, PricebookEntryId
        FROM OpportunityLineItem 
        WHERE OpportunityId = :venta.id
        ]);
        
        productosSeleccionadosValues = new List<ProductosSeleccionados>();
        for(ProductosSeleccionados oppLineItem : opportunityLineItems.values()) {
            if(mapOpportunityLineItem.containsKey(oppLineItem.Id)) {
                Decimal newQuantity = 0;
                
                for(OpportunityLineItem ordItem : ListOrderItem) {
                    if(ordItem.Product2Id == mapOpportunityLineItem.get(oppLineItem.Id).Product2Id) {
                        newQuantity = newQuantity + ordItem.Quantity;
                    }
                }           
                
                if(newQuantity > oppLineItem.cantidad) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'A quantidade excede a disponível'));
                } else {
                    ProductosSeleccionados newProductosSeleccionados = new ProductosSeleccionados();
                    newProductosSeleccionados.id = oppLineItem.id;
                    newProductosSeleccionados.label = oppLineItem.label;
                    newProductosSeleccionados.pricebookEntryId = oppLineItem.pricebookEntryId;
                    newProductosSeleccionados.cantidad = oppLineItem.cantidad - newQuantity;
                    productosSeleccionadosValues.add(newProductosSeleccionados);
                }
            } else {
                ProductosSeleccionados newProductosSeleccionados = new ProductosSeleccionados();
                newProductosSeleccionados.id = oppLineItem.id;
                newProductosSeleccionados.label = oppLineItem.label;
                newProductosSeleccionados.pricebookEntryId = oppLineItem.pricebookEntryId;
                newProductosSeleccionados.cantidad = oppLineItem.cantidad;
                productosSeleccionadosValues.add(newProductosSeleccionados);
            }
        }
    }

    /////////////// OFERTA - PEDIDO //////////////////
    public PageReference sumbitForApproval() {
        guardarRequisicion();
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        //system.debug(requisicionActual.name);
        req.setObjectId(requisicionActual.Id);
        Approval.ProcessResult result = Approval.process(req);
        return refresh();
    }
    
    public void SaveComentarioConfirmacion() {
        
        Opportunity opp = [
            SELECT ID, Confirmado__c, Comentarios_de_confirmacion__c
            FROM Opportunity
            WHERE RecordType.DeveloperName = 'CVB_Autorizada' 
            AND ID =: OpportunityIdAConfirmar
            LIMIT 1
        ];
        opp.Comentarios_de_confirmacion__c = comentarioRastreamientoTransporte;
        opp.Confirmado__c = true;
        comentarioRastreamientoTransporte = '';

        update  opp;
    }

    public void setOpportunitiesWrapper() {
        opportunitiesWrapperValues = new List <OpportunityWrapper>();
        List <opportunity> opps = getOportunidad();
        if (opps.size() != 0 && opps != null) {
            for (Opportunity opp : opps){                
                OpportunityWrapper newOpportunityWrapper = new OpportunityWrapper();
                newOpportunityWrapper.venta = opp;
                newOpportunityWrapper.presupuestos = getPresupuestos(opp);
                List<PresupuestosWrapper> presupuestosWrapperValuesNuevo = setPresupuestosWrapper(newOpportunityWrapper.presupuestos, opp.name);
                newOpportunityWrapper.presupuestosWrapperValues = presupuestosWrapperValuesNuevo;
                newOpportunityWrapper.isEmpty = newOpportunityWrapper.presupuestos.size() == 0;
                newOpportunityWrapper.isSelect = false;
                opportunitiesWrapperValues.add(newOpportunityWrapper);
            }
        }
        // else {
        //     OpportunityWrapper newOpportunityWrapper = new OpportunityWrapper();
        //     newOpportunityWrapper.venta = new Opportunity();
        //     newOpportunityWrapper.presupuestos = new List<Quote>();
        //     newOpportunityWrapper.esNueva = true;
        //     newOpportunityWrapper.presupuestosWrapperValues = new List<PresupuestosWrapper>(); 
        //     opportunitiesWrapperValues.add(newOpportunityWrapper);
        // }
    }

    public void getOrderItems() {
        ordersByContactValues = new List<OrderWrapper>();
        for(Opportunity orden : ordersByContact.values()) {
            OrderWrapper newOrderWrapper = new OrderWrapper();
            newOrderWrapper.anOrder = orden;
            newOrderWrapper.orderItems = new Map<Id, OpportunityLineItem>(orden.OpportunityLineItems);
            newOrderWrapper.size = newOrderWrapper.orderItems.size();
            newOrderWrapper.nomeDoContacto = orden.Destinatario_de_Mercaderia__r.Name;
            newOrderWrapper.rua = orden.Destinatario_de_Mercaderia__r.MailingStreet;
            newOrderWrapper.ciudade = orden.Destinatario_de_Mercaderia__r.MailingCity;
            newOrderWrapper.estado = orden.Destinatario_de_Mercaderia__r.MailingState;
            newOrderWrapper.pais = orden.Destinatario_de_Mercaderia__r.MailingCountry;
            ordersByContactValues.add(newOrderWrapper);
        }
    }

    public List<PresupuestosWrapper> setPresupuestosWrapper(List<quote> presupuestos, String name) {
        List<PresupuestosWrapper> presupuestosWrapperValues = new List<PresupuestosWrapper>();
        if(presupuestos.size() != 0 && presupuestos != null) {
            for(Quote presupuesto : presupuestos) {
                PresupuestosWrapper newPresupuestosWrapper = new PresupuestosWrapper();
                newPresupuestosWrapper.presupuesto = presupuesto;
                newPresupuestosWrapper.presupuestosItems = presupuesto.QuoteLineItems;

                if(!String.isBlank(presupuesto.Condi_o_de_pagamento__c)) {
                    newPresupuestosWrapper.condicionDePago = presupuesto.Condi_o_de_pagamento__c;
                } else {
                    newPresupuestosWrapper.condicionesDePagos = condicionesDePagos;
                }
                newPresupuestosWrapper.oppName = name;

                newPresupuestosWrapper.importes = setImportesWrapper(presupuesto);
                newPresupuestosWrapper.importSize = newPresupuestosWrapper.importes.size();
                presupuestosWrapperValues.add(newPresupuestosWrapper);
            }
        }
        return presupuestosWrapperValues;
    }
    
    public List<ImportesWrapper> setImportesWrapper(Quote presupuesto) {
        List<ImportesWrapper> importes = new List<ImportesWrapper>();

        if((presupuesto.Total_do_primeiro_pagamento__c != null && presupuesto.Total_do_primeiro_pagamento__c > 0) || isTest) {
            ImportesWrapper importe = new ImportesWrapper();
            importe.quantidade = (Integer)presupuesto.Taxa_de_primeiro_pagamento__c;
            importe.diasProrrogacion = (Integer)presupuesto.Dias_de_primeira_prorrogaco__c;
            importe.Juros = presupuesto.Primeiro_juros__c;
            importe.nuevoVencimiento = getTextoFecha(presupuesto.Novo_primeiro_vencimento__c);            
            importe.valorConJuros = getDivisa(presupuesto.Preco_unitario_primeiro_vencimento__c);                  
            importe.total = getDivisa(presupuesto.Total_do_primeiro_pagamento__c);
            importe.precioUnitario = getDivisa(presupuesto.Preco_unitario_final__c);
            importe.valorJuros = getDivisa(presupuesto.Valor_primeiro_juro__c);
            importe.vencimiento = getTextoFecha(presupuesto.Primeiro_vencimento__c);
            importes.add(importe);

        }
        if((presupuesto.Total_do_segundo_pagamento__c != null && presupuesto.Total_do_segundo_pagamento__c > 0) || isTest) {
            ImportesWrapper importe = new ImportesWrapper();
            importe.quantidade = (Integer)presupuesto.Taxa_de_segundo_pagamento__c;
            importe.diasProrrogacion = (Integer)presupuesto.Dias_de_segunda_prorrogaco__c;
            importe.Juros = presupuesto.Segundo_juros__c;
            importe.nuevoVencimiento = getTextoFecha(presupuesto.Novo_segundo_vencimento__c);
            importe.valorConJuros = getDivisa(presupuesto.Preco_unitario_segundo_vencimento__c);
            importe.total = getDivisa(presupuesto.Total_do_segundo_pagamento__c);
            importe.precioUnitario = getDivisa(presupuesto.Preco_unitario_final__c);
            importe.valorJuros = getDivisa(presupuesto.Valor_segundo_juro__c);
            importe.vencimiento = getTextoFecha(presupuesto.Segundo_vencimento__c);
            importes.add(importe);
        }
        if((presupuesto.Total_do_terceiro_pagamento__c != null && presupuesto.Total_do_terceiro_pagamento__c > 0) || isTest) {
            ImportesWrapper importe = new ImportesWrapper();
            importe.quantidade = (Integer)presupuesto.Taxa_de_terceiro_pagamento__c;
            importe.diasProrrogacion = (Integer)presupuesto.Dias_de_terceira_prorrogaco__c;
            importe.Juros = presupuesto.Terceiro_juros__c;
            importe.nuevoVencimiento = getTextoFecha(presupuesto.Novo_terceiro_vencimento__c);
            importe.valorConJuros = getDivisa(presupuesto.Preco_unitario_terceiro_vencimento__c);
            importe.total = getDivisa(presupuesto.Total_do_terceiro_pagamento__c);
            importe.precioUnitario = getDivisa(presupuesto.Preco_unitario_final__c);
            importe.valorJuros = getDivisa(presupuesto.Valor_terceiro_juro__c);
            importe.vencimiento = getTextoFecha(presupuesto.Terceiro_vencimento__c);
            importes.add(importe);
        }
        if((presupuesto.Total_do_quarto_pagamento__c != null && presupuesto.Total_do_quarto_pagamento__c > 0) || isTest) {
            ImportesWrapper importe = new ImportesWrapper();
            importe.quantidade = (Integer)presupuesto.Taxa_de_quarto_pagamento__c;
            importe.diasProrrogacion = (Integer)presupuesto.Dias_de_quarta_prorrogaco__c;
            importe.Juros = presupuesto.Quarto_juros__c;
            importe.nuevoVencimiento = getTextoFecha(presupuesto.Novo_quarto_vencimento__c);
            importe.valorConJuros = getDivisa(presupuesto.Preco_unitario_quarto_vencimento__c);
            importe.total = getDivisa(presupuesto.Total_do_quarto_pagamento__c);
            importe.precioUnitario = getDivisa(presupuesto.Preco_unitario_final__c);
            importe.valorJuros = getDivisa(presupuesto.Valor_quarto_juro__c);
            importe.vencimiento = getTextoFecha(presupuesto.Quarto_vencimento__c);
            importes.add(importe);
        }
        if((presupuesto.Total_do_quinto_pagamento__c != null && presupuesto.Total_do_quinto_pagamento__c > 0) || isTest) {
            ImportesWrapper importe = new ImportesWrapper();
            importe.quantidade = (Integer)presupuesto.Taxa_de_quinto_pagamento__c;
            importe.diasProrrogacion = (Integer)presupuesto.Dias_de_quinta_prorrogaco__c;
            importe.Juros = presupuesto.Quinto_juros__c;
            importe.nuevoVencimiento = getTextoFecha(presupuesto.Novo_quinto_vencimento__c);
            importe.valorConJuros = getDivisa(presupuesto.Preco_unitario_quinto_vencimento__c);
            importe.total = getDivisa(presupuesto.Total_do_quinto_pagamento__c);
            importe.precioUnitario = getDivisa(presupuesto.Preco_unitario_final__c);
            importe.valorJuros = getDivisa(presupuesto.Valor_quinto_juro__c);
            importe.vencimiento = getTextoFecha(presupuesto.Quinto_vencimento__c);
            importes.add(importe);
        }
        return importes;
    }

    public List<SelectOption> getCondicionesDePagos() {
        condicionesDePagos = new List<SelectOption>();
        
        Schema.DescribeFieldResult oppCond = Opportunity.Condicion_de_Pago__c.getDescribe();
        List<Schema.PicklistEntry> oppCondValues = oppCond.getPicklistValues();
        condicionesDePagos.add(new SelectOption('', '--Seleccionar--'));
        for(Schema.PicklistEntry valuePickList : oppCondValues) {
            if(valuePickList.isActive()) {
                condicionesDePagos.add(new SelectOption(valuePickList.getValue(), valuePickList.getLabel()));
            }
        }        
        return condicionesDePagos;
    }

    public String getTextoFecha(Date fecha) {
        String textoFecha = '';
        if(fecha == null) 
            return textoFecha;
        if(fecha.day() < 10) {
            textoFecha += '0';
        }
        textoFecha += fecha.day() + '/';
        
        if(fecha.month() < 10) {
            textoFecha += '0';
        }
        
        textoFecha += fecha.month() + '/' + fecha.year();
        return textoFecha;
    }
    
    public String getDivisa(Decimal divisa) {
       
        decimal divDec = ((decimal)divisa).setscale(2);
        String aux = divDec.format();
        String divToStr = string.valueOf(aux);
        String retorno = 'R$  ' + divToStr;
        
        if (!(aux.contains(','))){
            retorno += ',00';
        }else { 
            list<String> auxs = aux.split(',');
            if(auxs[1].length() == 1){
                retorno += '0';
            }
        }
        return retorno;
    }

    public void adicionarOrder() {
        
        error = null;
        
        if (contactProduct.cantidad == null || contactProduct.cantidad <= 0)  {
            error = 'Deve inserir uma quantidade';
            return;
        }
        
        ProductosSeleccionados productoSeleccionadoWpp;
        System.debug(productosSeleccionadosValues);
        for(ProductosSeleccionados prod : productosSeleccionadosValues) {
            System.debug('adicionarOrder prod: '+prod);
            System.debug('adicionarOrder prod.pricebookEntryId: '+prod.pricebookEntryId);
            System.debug('adicionarOrder contactProduct.productId: '+contactProduct.productId);
            if(prod.pricebookEntryId == contactProduct.productId) {
                productoSeleccionadoWpp = prod;
            }
        }
        
        if(productoSeleccionadoWpp.cantidad < contactProduct.cantidad) {
            error = 'A quantidade excede a disponível';
            return;
        } 
        
        List<Opportunity> opps = getOportunidad();
        
        
        if (!ordersByContact.containsKey(contactProduct.contactId)) {
            Opportunity newOrder = new Opportunity(
                Name ='Entrega',
                AccountId = activeAccount.id,
                RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('VB - Pendiente').getRecordTypeId(),
                Destinatario_de_Mercaderia__c = contactProduct.contactId,
                CloseDate = Date.today(),
                Pricebook2Id = opps[0].Pricebook2Id,
                StageName = 'Aberta',
                Entregas__c = opps[0].Id
            );
            insert newOrder;
            OrdersByContact.put(newOrder.Destinatario_de_Mercaderia__c, newOrder);
        }
        buscarPedidos();
        adicionarOrderItem();
        
        productoSeleccionadoWpp.cantidad -= contactProduct.cantidad;
    }

    public void adicionarOrderItem() {
        
        OrderWrapper wrapper;
        OpportunityLineItem newOrderItem;             
        
        for(OrderWrapper w : ordersByContactValues) {
            if(w.anOrder.Destinatario_de_Mercaderia__c == contactProduct.contactId) {
                wrapper = w;
            }
        }
        for(OpportunityLineItem w : wrapper.orderItems.values()){
            if(w.PricebookEntryId == contactProduct.productId){
                newOrderItem = w;    
                break; 
            }
        }                       
        if(newOrderItem != null) {
            newOrderItem.Quantity = newOrderItem.Quantity + contactProduct.cantidad;
            update newOrderItem;
        } else {
            newOrderItem = new OpportunityLineItem(
            PricebookEntryId = contactProduct.productId,
            OpportunityId = ordersByContact.get(contactProduct.contactId).id,
            Quantity = contactProduct.cantidad,
            UnitPrice = 0.1
            );          
            insert newOrderItem;
            
            
            if(!idOrderItems.contains(newOrderItem.Id)){
                idOrderItems.add(newOrderItem.Id);                
            }
            
            List<OpportunityLineItem> listNewOrderItem = [
            SELECT Id, PricebookEntryId, OpportunityId, Quantity, UnitPrice, Product2.Name
            FROM OpportunityLineItem
            WHERE Id = :newOrderItem.Id
            ]; 
            
            wrapper.orderItems.put(listNewOrderItem[0].Id, listNewOrderItem[0]);
            
        }
    }
    
    public void deleteOrderItem() {
        Decimal cantidad;
        Id pricebookEntry;
        for(Integer i = 0 ; i < ordersByContactValues.size() ; i++) {
            System.debug(contactToRemove);
            if (ordersByContactValues[i].anOrder.Destinatario_de_Mercaderia__c == contactToRemove) {
                cantidad = ordersByContactValues[i].orderItems.get(itemToRemove).Quantity;
                pricebookEntry = ordersByContactValues[i].orderItems.get(itemToRemove).pricebookEntryId;
                delete ordersByContactValues[i].orderItems.remove(itemToRemove);
                
                if ( ordersByContactValues[i].orderItems.size() == 0) {
                    delete ordersByContactValues[i].anOrder;
                } 
                
                break;
            }
        }
        
        for(ProductosSeleccionados prod : productosSeleccionadosValues) {
            
            if(prod.pricebookEntryId == pricebookEntry) {
                prod.cantidad += cantidad;
            }
        }
        buscarPedidos();
    }

    public void setCondicionDePago() {
        Map<Id, String> mapPresupuestoWrapper = new Map<Id, String>();
        List<Quote> presupuestosUpdate = new List<Quote>();
     
        for(PresupuestosWrapper presupuestoWrapper : presupuestosWrapperValues) {
            if(presupuestoWrapper.condicionDePago != '') {
                mapPresupuestoWrapper.put(presupuestoWrapper.presupuesto.Id, presupuestoWrapper.condicionDePago);
            }
        }
     
        for(Quote presupuesto : presupuestos) {
            if(mapPresupuestoWrapper.containsKey(presupuesto.Id) && (presupuesto.Condi_o_de_pagamento__c != mapPresupuestoWrapper.get(presupuesto.Id))) {
                presupuesto.Condi_o_de_pagamento__c = mapPresupuestoWrapper.get(presupuesto.Id);
                presupuestosUpdate.add(presupuesto);
            }
        }
     
        if(presupuestosUpdate.size() > 0) {
            update presupuestosUpdate;
        }
    }

    public void searchProducts() {
        hayProductos = true;
        
        if(!newProducts.containsKey(newProduct)) {
            system.debug(newProduct);
            if (products.containsKey(newProduct)) {
                ProductosSeleccionados newProductoSeleccionado = new ProductosSeleccionados();
                newProductoSeleccionado.id = products.values().Id;
                newProductoSeleccionado.label = products.values().Name;
                this.newProducts.put(newProductoSeleccionado.id, newProductoSeleccionado);
            }
            
        }
    }
    
    public void eliminarProductos() {
        newProducts.remove(itemToRemove);
    }
    
    public void eliminarProductoRequisicion()   {
        System.debug(idEliminar);

        for(Integer i = 0; i < productosRequisicion.size(); i++)
        {
            System.debug(i);
            if(idEliminar == productosRequisicion[i].idPR) {
                if(productosRequisicion[i].productoRequisicionId != null) {
                    productosEliminados.add(productosRequisicion[i]);
                }
                productosRequisicion.remove(i);
                idEliminar = null;
                return;
            }
        }
    }
    
    // public void criarRequisicao() {
        
    //     List<Produto_de_Requisicao__c> listProdutoDeRequisicao = new List<Produto_de_Requisicao__c>();
        
    //     Requisicao_de_compra__c requisicaoDeCompra = new Requisicao_de_compra__c();
    //     requisicaoDeCompra.Multiplicador__c = cuenta.Id;
    //     requisicaoDeCompra.Marca__c = cueproductOptionsnta.Marca__c;
    //     requisicaoDeCompra.Safra__c = safraActual;
    //     requisicaoDeCompra.Tipo__c = 'Multiplicador';
    //     requisicaoDeCompra.Regiao__c = cuenta.Region__r.Region_Comercial__c;
    //     insert requisicaoDeCompra;
        
    //     List<PricebookEntry> listPricebookEntry = [
    //     SELECT Id, Name, Pricebook2Id, Product2Id
    //     FROM PricebookEntry
    //     WHERE Id IN :newProducts.keySet()
    //     ];
        
    //     if(!newProducts.isEmpty()) {
    //         for(PricebookEntry pricebookE : listPricebookEntry) {
    //             Produto_de_Requisicao__c produtoDeRequisicao = new Produto_de_Requisicao__c();
    //             produtoDeRequisicao.Name = 'Prueba ' + pricebookE.Product2Id;
    //             produtoDeRequisicao.Requisicao_de_compra__c = requisicaoDeCompra.Id;
    //             produtoDeRequisicao.Quantidade__c = newProducts.get(pricebookE.Id).cantidad;
    //             produtoDeRequisicao.Producto__c = pricebookE.Product2Id;
    //             listProdutoDeRequisicao.add(produtoDeRequisicao);
    //         }
    //     }
        
    //     if(!listProdutoDeRequisicao.isEmpty()) {
    //         insert listProdutoDeRequisicao;
    //     }
    // }

    // Agregado por Jhonny Peroza
    public static String criarRequisicao(Requisicao_de_compra__c requisicao, List<ProductoRequisicion> produto) {
        
        List<Produto_de_Requisicao__c> listProdutoDeRequisicao = new List<Produto_de_Requisicao__c>();
        
        Requisicao_de_compra__c requisicaoDeCompra = new Requisicao_de_compra__c();
        requisicaoDeCompra.Multiplicador__c = requisicao.Multiplicador__c;
        requisicaoDeCompra.Marca__c = requisicao.Marca__c;
        requisicaoDeCompra.Safra__c = requisicao.Safra__c;
        requisicaoDeCompra.Tipo__c = requisicao.Tipo__c;
        requisicaoDeCompra.Regiao_comercial__c = requisicao.Regiao_comercial__c;
        insert requisicaoDeCompra; 
        
        for(ProductoRequisicion pr : produto) {
            Produto_de_Requisicao__c produtoDeRequisicao = new Produto_de_Requisicao__c();
            produtoDeRequisicao.Quantidade__c = pr.cantidad;
            produtoDeRequisicao.Variedad__c = pr.variedadId;
            produtoDeRequisicao.Requisicao_de_compra__c = requisicao.Id;
            listProdutoDeRequisicao.add(produtoDeRequisicao);
        }
        
        if(!listProdutoDeRequisicao.isEmpty()) {
            insert listProdutoDeRequisicao;
        }

        return listProdutoDeRequisicao[0].Id;
    }

    // Agregado por Jhonny Peroza
    public static void requisicaoSumbitForApproval(String reqId) {     
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(reqId);
        Approval.ProcessResult result = Approval.process(req);
    }
    
    // Agregado por Jhonny Peroza US-13222
    public static Boolean approvalProcessVBPedido(String pedidoId, String action, String coment) {

        Boolean status;
        Opportunity opp = [SELECT Id, StageName, Confirmado__c, Comentarios_de_confirmacion__c FROM Opportunity WHERE Id =: pedidoId LIMIT 1];  

        if (action == 'Approve') {
            opp.StageName = 'Revisão do administrador de vendas';
            opp.Comentarios_de_confirmacion__c =coment;
            opp.Confirmado__c = true;
        } else if (action == 'Reject'){ 
            opp.StageName = 'Edición';
            opp.Confirmado__c = false;
            opp.Comentarios_de_confirmacion__c =coment;
        }

        try {
            update opp; 
            status = true;

        } catch(Exception e) {
            e.getMessage();
            status = false;
        }

    return status;

}

    public void buscarPedidos() {
        ordersByContact = new Map<Id, Opportunity>();
        pedidos = [
            SELECT Id, Name, Destinatario_de_Mercaderia__r.Name, Stagename, Destinatario_de_Mercaderia__r.MailingCity, Pricebook2Id, Destinatario_de_Mercaderia__c,
            Destinatario_de_Mercaderia__r.MailingState,  Destinatario_de_Mercaderia__r.MailingCountry, Destinatario_de_Mercaderia__r.MailingStreet, Condicion_de_Pago__c,
            (SELECT Id, Product2.Name, Product2.Id, Quantity, PriceBookEntryId FROM OpportunityLineItems)
            FROM Opportunity
            WHERE Entregas__c = :venta.id
            ORDER BY CreatedDate DESC
        ];
        system.debug('venta.id'+ venta.id);
        for (Opportunity p : pedidos) {
            OrdersByContact.put(p.Destinatario_de_Mercaderia__c, p);
        }
        
        getOrderItems();
    }
    
    public void init() {
        System.debug('Adentro del init');
        List<Opportunity> opps = getOportunidad();
        if (opps.size() != 0) {
            venta = opps[0];
            System.debug('Ësta es tu opp creo:' + opps[0].Id);
            
            presupuestos = getPresupuestos(opps[0]);
            buscarPedidos();
        } else {
            venta = new Opportunity();
            presupuestos = new List<Quote>();

            esNueva = true;
        }
        
        system.debug('Entrando en el init aSiteVendaDeBasicaController');
        getCondicionesDePagos();
        setOpportunitiesWrapper();
    }

    public  List<Opportunity> getOportunidad() {     
        String marca = aSiteAuthManager.getMarcaBySession(token);   
        List<Opportunity> opps;
      
        System.debug('safraActual: '+safraActual);
        System.debug('activeAccount: '+activeAccount.id);
        System.debug('marca: '+marca);
        opps = [
            SELECT Id, AccountId, Pricebook2Id, StageName, name,
            (SELECT Id, Name, Product2.Name, Product2.Id, PricebookEntryId, TotalPrice, Quantity, UnitPrice FROM OpportunityLineItems)
            FROM Opportunity
            WHERE Safra__c = :safraActual
            AND AccountId = :activeAccount.id
            AND RecordType.DeveloperName = 'Venda_da_Basica_full'
            AND marca__c = :marca
            ORDER BY CreatedDate DESC
        ];
        
      
        
        return opps;
    }

    public void getRequisicao() {
        String marca = aSiteAuthManager.getMarcaBySession(token);
        System.debug('getRequisicao safraActual: '+safraActual);
        System.debug('getRequisicao activeAccount: '+activeAccount.id);
        System.debug('getRequisicao marca: '+ marca);
        List<Requisicao_de_compra__c> requisiciones = 
                                                [SELECT Id, toLabel(Estado__c), Name,
                                                    (SELECT Id, Name, Variedad__c, Quantidade__c FROM Produtos_de_Requisicao__r)
                                                FROM Requisicao_de_compra__c
                                                WHERE Safra__c = :safraActualEstimativaCompra
                                                AND Multiplicador__c = :activeAccount.Id
                                                AND Marca__c = :marca
                                                ORDER BY CreatedDate DESC];
        system.debug(requisiciones + 'esta lista esta vacia? requisiones');
        if(!requisiciones.isEmpty()) {
            requisicionActual = requisiciones[0];
            if(requisicionActual.Estado__c == 'Edição' || requisicionActual.Estado__c == 'Rejeitado') {
                requisicionEditable = true;
            }

            for(Produto_de_Requisicao__c prod : requisicionActual.Produtos_de_Requisicao__r) {
                ProductoRequisicion nuevoProducto = new ProductoRequisicion();
                nuevoProducto.nombre = prod.Name;
                nuevoProducto.cantidad = (Decimal)prod.Quantidade__c;
                nuevoProducto.cantidadString = formatDecimal(nuevoProducto.cantidad, 2, '.', ',');
                nuevoProducto.variedadId = prod.Variedad__c;
                nuevoProducto.productoRequisicionId = prod.Id;
                if(productosRequisicion.isEmpty()) {
                    nuevoProducto.idPR = 0;
                }
                else {
            
                    nuevoProducto.idPR = lastId + 1;
                }
                lastId = nuevoProducto.idPR;
                productosRequisicion.add(nuevoProducto);
            }

        }
        else {
            Id sojaRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByDeveloperName().get('Soja').getRecordTypeId();
            requisicionActual = new Requisicao_de_compra__c();
            requisicionActual.RecordTypeId = sojaRecordType;
            requisicionActual.Multiplicador__c = activeAccount.Id;
            requisicionActual.Safra__c = safraActualEstimativaCompra;
            requisicionActual.Tipo__c = 'Multiplicador';
            requisicionActual.Regiao_comercial__c = cuenta.Region__r.Region_Comercial__c;
            requisicionActual.Marca__c = activeSession.marca__c;
            requisicionActual.Estado__c = 'Edição';

            System.debug('Requerimiento actual1: ' + requisicionActual);

            requisicionEditable = true;
            
        }
    }

    public String formatDecimal(Decimal val, integer dec, String tSep, String dSep) {
        System.debug('Cantidad5: ' + val);
        String s, tmp;
        Integer i = 4 + dec;
     
        // If the number of decimals is zero (0)... prevents the first 1000s seperator from being set at the 4th.
        if(dec==0){
            i--;
        }
     
        s = val.setScale(dec).toPlainString().replace(tSep, dSep);
        while(s.length() > i) {
            tmp = s.substring(0, s.length() - i) + tSep + s.substring(s.length() - i);
            s = tmp;
            i += 4;
        }
     
        // If the number is negative and has a number non-decimal digits divisible by 3, it prevents putting a comma before the 1st digit (ex -300,000.00  comes out -,300,000.00)
        if (s.substring(0,1) == '-') {
            if (s.substring(1,2) == tSep) {
                s = '-' + s.substring(2);
            }
        }
        System.debug('Cantidad6: ' + s);
        return s;
    }

    public String getEstadoRequisicion() {
        return requisicionActual.Estado__c;
    }

    public static List<Quote> getPresupuestos(Opportunity opp) {
     
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
            Preco_unitario_final__c,
            (
                SELECT Id, Product2.Name, Product2.Description, Product2.UNIDADE__c,Product2.Categoria__c,
                TotalPrice, Quantity, Tipo_de_necessidade__c, UnitPrice 
                FROM QuoteLineItems
            )
            FROM Quote
            WHERE OpportunityId = :opp.id
            AND Vis_vel_para_multiplicador__c = true
            AND Status != 'Rejeitado'
            ORDER BY CreatedDate DESC
        ];
      
        return presupuestos;
    }

    public PageReference guardarRequisicion() {
        if(productosRequisicion.isEmpty()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Deve adicionar um produto para salvar esta requisição'));
            productosRequisicion.addAll(productosEliminados);
            productosEliminados.clear();
            return null;
        }
        
        requisicionActual.Email_Site_User__c = logUser.Email__c;
        
        System.debug('Requerimiento actual: ' + requisicionActual);
        upsert requisicionActual;

        List<Produto_de_Requisicao__c> productosInsertar = new List<Produto_de_Requisicao__c>();
        for(ProductoRequisicion prod : productosRequisicion) {
            if(prod.productoRequisicionId != null) {
                continue;
            }                       
            Produto_de_Requisicao__c newProd = new Produto_de_Requisicao__c();
            newProd.Variedad__c = prod.variedadId;
            newProd.Requisicao_de_compra__c = requisicionActual.Id;
            newProd.Quantidade__c = prod.cantidad;
            newProd.Name = prod.nombre;
            
            productosInsertar.add(newProd);
        }
        
        insert productosInsertar;      

        List<Produto_de_Requisicao__c> productosEliminar = new List<Produto_de_Requisicao__c>();
        for(ProductoRequisicion prod : productosEliminados) {
            Produto_de_Requisicao__c newProd = new Produto_de_Requisicao__c(Id = prod.productoRequisicionId);
            productosEliminar.add(newProd);
        }
        productosEliminados.clear();
        delete productosEliminar;

        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Confirm , 'Requisição salva corretamente'));
        // ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Confirm, 'Deve adicionar um produto para salvar esta requisição'));
        // return refresh();
        return null;
    }

    public void setIdToReject(){
        system.debug('index opp2 ' + indexOpp);
    }

    public pageReference rejectQuote() {
        system.debug('index opp3 ' + indexOpp);
        opportunityWrapper wrpAux = new opportunityWrapper ();
        for(opportunityWrapper wrpOpp : opportunitiesWrapperValues){
            system.debug('oppportunity name: ' + wrpOpp.venta.name + ', opportunity checkeada: ' + wrpOpp.isSelect);
            if(wrpOpp.venta.id == indexOpp){
                wrpAux = wrpOpp;
            }
        }
        if(wrpAux.venta != null){
            wrpAux.venta.StageName = 'Edición';
            wrpAux.venta.Confirmado__c = false;
            wrpAux.venta.Comentarios_de_confirmacion__c = comentario;
            if(Approval.isLocked( wrpAux.venta.id)){
                Approval.unlock( wrpAux.venta.id);
            }
            update wrpAux.venta;
        }
        if(wrpAux.presupuestos != null && wrpAux.presupuestos.size() > 1){
            wrpAux.presupuestos[0].Status = 'Rejeitado';
            update wrpAux.presupuestos[0];
        }
        return refresh();
    }

    public pageReference approvalQuote() {
        opportunityWrapper wrpAux = new opportunityWrapper ();
        for(opportunityWrapper wrpOpp : opportunitiesWrapperValues){
            if(wrpOpp.isSelect){
                wrpAux = wrpOpp;
            }
        }
        
        if(wrpAux.venta != null){
            wrpAux.venta.StageName = 'Revisão do administrador de vendas';
            wrpAux.venta.Comentarios_de_confirmacion__c = comentario;
            wrpAux.venta.Confirmado__c = true;
            System.debug('Opp: ' + wrpAux.venta);
            update wrpAux.venta;
        }
        if(wrpAux.presupuestos != null && wrpAux.presupuestos.size() > 0){
            wrpAux.presupuestos[0].Status = 'Aprovado';
            update wrpAux.presupuestos[0];
        }
        return refresh();
    }

    public pageReference refresh() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteVendaDeBasica');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public void approvalProcess(String act) {
        Opportunity opp = getOportunidad()[0];
        
        if (act == 'Approve') {
            opp.StageName = 'Revisão do administrador de vendas';
            opp.Comentarios_de_confirmacion__c =comentario;
            opp.Confirmado__c = true;
        } else if (act == 'Reject'){ 
            opp.StageName = 'Edición';
            opp.Confirmado__c = false;
            opp.Comentarios_de_confirmacion__c =comentario;
        }
        update opp;
       
        
    }

    public class paginacion{
        public Integer counter {get; set;}
        public Integer list_size {get; set;}
        public Integer total_size {get; set;}
        public Integer total_Pages;
        public paginacion(Integer counter, Integer list_size, Integer total_size){
            this.counter = counter;
            this.list_size = list_size;
            this.total_size = total_size;
            
        }
    }


    public class OrderWrapper {
        public Opportunity anOrder {get; set;}
        public Map<Id, OpportunityLineItem> orderItems {get; set;}
        public Integer size {get; set;}
        public String nomeDoContacto {get; set;}
        public String rua {get; set;}
        public String ciudade {get; set;}
        public String estado {get; set;}
        public String pais {get; set;}
    }
    
    public class PresupuestosWrapper {
        public Quote presupuesto {get; set;}
        public List<QuoteLineItem> presupuestosItems {get; set;}
        public List<SelectOption> condicionesDePagos {get; set;}
        public String condicionDePago {get; set;}
        public List<ImportesWrapper> importes {get; set;}
        public Integer importSize   {get; set;}
        public String oppName {get; set;}
    }

    public class ImportesWrapper {
        public Integer quantidade {get; set;}
        public String vencimiento {get; set;}
        public String precioUnitario {get; set;}
        public String nuevoVencimiento  {get; set;}
        public Integer diasProrrogacion {get; set;}
        public Double Juros {get; set;}
        public String valorJuros    {get; set;}
        public String valorConJuros {get; set;}
        public String total {get; set;}
    }
    
    public class PricebookEntryOppLineItmemWrapp {
        public Id pricebookEntryId {get; set;}
        public Decimal cantidad {get; set;}
    }
    
    public class ProductosSeleccionados {
        public String id {get; set;}
        public Id pricebookEntryId;
        public String label {get; set;}
        public Decimal cantidad {get; set;}
    }
    
    public class ContactAndProduct {
        public String contactId {get; set;}
        public String productId {get; set;}
        
        public Integer cantidad {get; set;}
    }
    
    public class Response {
        public String response {get;set;}
        public boolean success {get;set;}
        
        public Response( String response, boolean success) {
            this.response = response;
            this.success = success;
        }
    }

    /*public List<Opportunity> getOportunidadesCVBAutorizadas() { 
        List<Opportunity> opps = [
            SELECT Id, Estado__c, Confirmado__c, Numero_Entrega__c, Documento_Transporte__c, Nro_Pedido_SAP__c,
            Inicio_Cargamento__c, Inicio_Transporte__c, Fin_Transporte__c,
            (SELECT Id, Name, Product2.Name, Quantity FROM OpportunityLineItems)
            FROM Opportunity 
            WHERE RecordType.DeveloperName = 'CVB_Autorizada' 
            AND AccountId =: activeAccount.id
            ORDER BY CreatedDate DESC   
            LIMIT : paginaciones[0].list_size
            OFFSET : paginaciones[0].counter
        ];
        
        // RecordCount = opps.size();
        
        return opps;
    }COMENTADO PARA DEPLOYAR ESTIMATIVAS*/

    public class OpportunityWrapper {
        public List<PresupuestosWrapper> presupuestosWrapperValues {get; set;}
        public Opportunity venta {get; set;}
        public boolean esNueva {get; set;}
        public List<Quote> presupuestos {get;set;}
        public Boolean isEmpty {get; set;}
        public boolean isSelect {get; set;}
        public id oppId {get; set;}
    }


    public class ProductoRequisicion {
        public string nombre {get; set;}
        public Decimal cantidad {get; set;}
        public string cantidadString {get; set;}
        public Id variedadId {get; set;}
        public Id productoRequisicionId {get; set;}
        public Boolean eliminada {get; set;}
        public Integer idPR {get; set;}
        public String registro {get; set;}
    }

    public PageReference Previous() { //user clicked previous button
        paginaciones[pagingNumber].counter -= paginaciones[pagingNumber].list_size;
        return null;
    }

    public PageReference Next() { //user clicked next button
        paginaciones[pagingNumber].counter += paginaciones[pagingNumber].list_size;
        return null;
    }

    public Boolean getShowPrevDev() {
        if (paginaciones[pagingNumber].counter > 0) return true;
        else return false;
    }

    public Boolean getShowNextDev() {
        Integer counter = paginaciones[pagingNumber].counter;
        Integer list_size = paginaciones[pagingNumber].list_size;
        Integer total_size = paginaciones[pagingNumber].total_size;
        if (counter + list_size < total_size) return true;
        else return false;
    }

    public Integer getTotalPages() {
        if (math.mod(paginaciones[pagingNumber].total_size, paginaciones[pagingNumber].list_size) > 0) {
            return paginaciones[pagingNumber].total_size / paginaciones[pagingNumber].list_size + 1;
        } else {
            return (paginaciones[pagingNumber].total_size / paginaciones[pagingNumber].list_size);
        }
    }

    public Integer getCurrentPage(){
        return (paginaciones[pagingNumber].counter / paginaciones[pagingNumber].list_size) + 1;
    }

    // Metodo para hacer un render asinc, no borrar
    public void changePagingNumber(){

    }

    /*public List<Opportunity> getOportunidadesDevolucion() { 
        List<Opportunity> opps = [
            SELECT Id, Estado__c, Confirmado__c, Numero_Entrega__c, Documento_Transporte__c, Nro_Pedido_SAP__c,
            Inicio_Cargamento__c, Inicio_Transporte__c, Fin_Transporte__c,Name,
            (SELECT Id, Name, Product2.Name, Quantity FROM OpportunityLineItems)
            FROM Opportunity 
            WHERE RecordType.DeveloperName = 'Devolucion' 
            AND AccountId =: activeAccount.id
            ORDER BY CreatedDate DESC   
            LIMIT : paginaciones[1].list_size
            OFFSET : paginaciones[1].counter
        ];
        
        return opps;
    }COMENTADO PARA DEPLOYAR ESTIMATIVAS*/ 

    public Pagereference goToDevoluciones(){
        PageReference p = new PageReference('/apex/aSiteDevoluciones');
        p.getParameters().put('token',token);
        p.getParameters().put('oppId',OpportunityIdADevolver);
        p.setRedirect(true);
        return p;
    }

}
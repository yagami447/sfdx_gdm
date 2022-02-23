public class ManejadorReembalagem extends ManejadorProductos {


    public Map<String, Set<String>> mapaUnidadesProductos {get;set;}
    public Map<String, String> mapaVariedadesPriceBookEntry {get;set;}
    public Map<String, Map<String, Id>> productByVariedadeAndUnidade {get;set;}
    public List<OpportunityLineItem> productosReemabalaje {get;set;}
    public String idListaPrecio {get;set;}

    public ManejadorReembalagem() {
        super();

        this.mapaUnidadesProductos = new Map<String, Set<String>>();
        this.mapaVariedadesPriceBookEntry = new Map<String, String>();
        this.productosReemabalaje = new List<OpportunityLineItem>();
        this.productByVariedadeAndUnidade = new Map<String, Map<String, Id>> ();

    }

    /*
    public override void setearMapas() {
        if (!this.listaProductos.isEmpty()) {
            for (Integer i = 0; i < this.listaProductos.size(); i++) {

                this.idListaPrecio = this.listaProductos[i].PricebookEntry.Pricebook2Id;
                String tmpVarietyId = this.listaProductos[i].PricebookEntry.Product2.Variedade__c;
                String tmpVarietyName = this.listaProductos[i].PricebookEntry.Product2.Variedade__r.Name;
                String tmpVarietyRegisterName = this.listaProductos[i].PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c;
                String tmpCategoryName;
                tmpCategoryName = this.listaProductos[i].Categoria__r.Name;

                if(!this.mapaVariedadesPriceBookEntry.containsKey(tmpVarietyId)) {
                    this.mapaVariedadesPriceBookEntry.put(tmpVarietyId, this.listaProductos[i].PricebookEntryId);
                }

                if (!this.nombreVariedadPorId.containsKey(tmpVarietyId)) {

                    Set<String> categoriesForVariety  = new Set<String>();

                    categoriesForVariety.add(tmpCategoryName);
                    this.categoriasPorVariedad.put(tmpVarietyName, categoriesForVariety);
                    this.tmpvarietyNameById.put(tmpVarietyId, tmpVarietyName);
                    this.nombreRegistroVariedadPorId.put(tmpVarietyId, tmpVarietyRegisterName);                
                    this.nombreVariedadPorId.put(tmpVarietyId, tmpVarietyName);
                } else {
                    Set<String> categoriesForVariety = this.categoriasPorVariedad.get(tmpVarietyName);
                    if (!categoriesForVariety.contains(tmpCategoryName)) {
                        categoriesForVariety.add(tmpCategoryName);
                    }
                }
                if(!this.mapaUnidadesProductos.containsKey(tmpVarietyId)) {
                    Set<String> unidades = new Set<String>();

                    unidades.add(this.listaProductos[i].UNIDADE__c);
                    this.mapaUnidadesProductos.put(tmpVarietyId, unidades);
                }else {
                    Set<String> unidadesCargadas = this.mapaUnidadesProductos.get(tmpVarietyId);
                    if(!unidadesCargadas.contains(this.listaProductos[i].UNIDADE__c)) {
                        unidadesCargadas.add(this.listaProductos[i].UNIDADE__c);
                    }
                }
            }
        }
    }*/

    public override void setearMapas() {
        for (Integer i = 0; i < this.listaProductos.size(); i++) {

            this.idListaPrecio =            this.listaProductos[i].PricebookEntry.Pricebook2Id;
            String varietyId =              this.listaProductos[i].PricebookEntry.Product2.Variedade__c;
            String varietyName =            this.listaProductos[i].PricebookEntry.Product2.Variedade__r.Name;

            if (!this.nombreVariedadPorId.containsKey(varietyId)) {
                this.productByVariedadeAndUnidade.put(varietyId, new Map<String, Id>());
                this.mapaUnidadesProductos.put(varietyId, new Set<String>());
                this.categoriasPorVariedad.put(varietyName, new Set<String>());

                this.nombreRegistroVariedadPorId.put(varietyId, this.listaProductos[i].PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c);                
                this.nombreVariedadPorId.put(varietyId, varietyName);
            }

            this.productByVariedadeAndUnidade.get(varietyId).put(this.listaProductos[i].UNIDADE__c, this.listaProductos[i].PricebookEntryId);
            this.categoriasPorVariedad.get(varietyName).add(this.listaProductos[i].Categoria__r.Name);
            this.mapaUnidadesProductos.get(varietyId).add(this.listaProductos[i].UNIDADE__c);
        }
    }


    //Para el portal de Reembalagem
    public Map<String, Map<String, Map<String, Decimal>>> validarVolumenReembalaejem(List<aAppendix.myOppItem> listaWrapper) {
        Map<String, Map<String, Map<String, Decimal>>> mapaVolumenDisponible = new Map<String, Map<String, Map<String, Decimal>>>();
        for(OpportunityLineItem item : this.listaProductos) {
            String variedadId = String.valueOf(item.PricebookEntry.Product2.Variedade__c);
            if(!mapaVolumenDisponible.containsKey(variedadId)) {
                Map<String, Map<String,Decimal>> tmpMapCategoriaAmount = new Map<String, Map<String, Decimal>>();
                String tmpCategoria = String.valueOf(item.Categoria__c);
                Map<String,Decimal> tmpAmount = new Map<String, Decimal>();
                Decimal disponible = 0;
                if(item.Bls_devolucion__c != null) {
                      disponible = item.Quantity - item.Bls_devolucion__c;
                } else {
                    disponible = item.Quantity;
                }
                tmpAmount.put(item.UNIDADE__c, disponible);
                tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
                mapaVolumenDisponible.put(variedadId, tmpMapCategoriaAmount);

            } else {
                if(!mapaVolumenDisponible.get(variedadId).containsKey(item.Categoria__c)) {
                    Map<String, Map<String,Decimal>> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadId);
                    String tmpCategoria = String.valueOf(item.Categoria__c);
                    Decimal disponible = 0;
                    if(item.Bls_devolucion__c != null) {
                        disponible = item.Quantity - item.Bls_devolucion__c;
                    }
                    Map<String, Decimal> unidadeCantidad = new Map<String, Decimal>();
                    unidadeCantidad.put(item.UNIDADE__c, disponible);
                    tmpMapCategoriaAmount.put(tmpCategoria, unidadeCantidad);
                }else {
                   
                    Map<String, Map<String, Decimal>> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadId);
                    String tmpCategoria = String.valueOf(item.Categoria__c);
                    Map<String, Decimal> unidadDisponible = new Map<String, Decimal>();
                    unidadDisponible = tmpMapCategoriaAmount.get(tmpCategoria);

                    //Si tiene la Variedad y la Categoria, nos fijamos que tenga la unidad de bolsa antes de validar cantidad disponible
                    if(unidadDisponible.containsKey(item.UNIDADE__c)) {
                        Decimal disponible = unidadDisponible.get(item.UNIDADE__c);
                        if(item.Bls_devolucion__c != null) {
                            disponible += item.Quantity - item.Bls_devolucion__c;
                        }else {
                            disponible += item.Quantity;
                        }
                        unidadDisponible.put(item.UNIDADE__c, disponible);
                    }else {
                        Decimal disponible = 0;
                        if(item.Bls_devolucion__c != null) {
                            disponible += item.Quantity - item.Bls_devolucion__c;
                        }else {
                            disponible += item.Quantity;
                        }
                        unidadDisponible.put(item.UNIDADE__c, disponible);
                    }
                }
            }
        }

        //Revisar los Reembalajes aprobados o en proceso de aprobacion
        for(OpportunityLineItem rembalaje : this.productosReemabalaje) {
            String variedadId = String.valueOf(rembalaje.PricebookEntry.Product2.Variedade__c);
            String categoriaId = String.valueOf(rembalaje.Categoria__c);
            String unidade = String.valueOf(rembalaje.UNIDADE__c);

            Map<String, Map<String, Decimal>> mapaCategoriaVolumen = mapaVolumenDisponible.get(variedadId);
            Map<String, Decimal> disponiblePorUnidad = mapaCategoriaVolumen.get(categoriaId);
            Decimal cantidad = disponiblePorUnidad.get(unidade);
            cantidad -= rembalaje.Quantity;
            disponiblePorUnidad.put(unidade, cantidad);
            mapaCategoriaVolumen.put(categoriaId, disponiblePorUnidad);
        }

        return mapaVolumenDisponible;
    }

     public  List<Opportunity> obtenerOportunidadesReembalaje(Id idCuenta, String safra, String marca) {
        List<Opportunity> queryResult = [
            SELECT Id, Name, Safra__c, Marca__c, CloseDate, pdf_descarte__c, tienePdf__c, VB_Recebeu__c,
            Estado_Anexos_Portal_Miltiplicadores__c, StageName
            FROM  Opportunity
            WHERE RecordType.DeveloperName = 'Reembalaje'
            AND Safra__c =: safra
            AND Marca__c =: marca
            AND Estado_Anexos_Portal_Miltiplicadores__c != 'Anulado'
            AND AccountId =: idCuenta
            ORDER BY CloseDate DESC
        ];
        return queryResult;
    }

    public  List<OpportunityLineItem> obtenerProductosOportunidad(Id oppId) {
        List<OpportunityLineItem> queryResult = [
            SELECT Id, PricebookEntry.Product2.Variedade__c,
            PricebookEntry.Product2.Variedade__r.Name, Semente_comercializada__c,
            PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c,
            PricebookEntry.Product2.UNIDADE__c, Area__c, Estado_de_Produccion__r.Name,
            Categoria__r.Name, Quantity, Lote_Rebajado__c,
            Categoria__c, Categoria_Prod__c, Unidade_descarte__c,
            UNIDADE__c, Variedade_Prod__c, Unidade_Reembalagem__c, Variedad_de_Produto__c, Expec_Prod_Bruta__c, Categoria_a_Rebaixar__r.Name, Categoria_a_Rebaixar__c, Qtde_Scs_40kg__c
            FROM   OpportunityLineItem
            WHERE  OpportunityId = :oppId
        ];
        return queryResult;
    }


    public  void actualizarReembalagem(List<aAppendix.myOppItem> nuevosProductos, Id idOportunidad, String marca, String comentarioNuevaOportunidad, String paraAprobacion) {
        Opportunity OpportunityBeingUpdated = [
            SELECT Id, Comentarios__c, Pricebook2Id, OwnerId
            FROM Opportunity
            WHERE Id = :idOportunidad
            LIMIT 1
        ];
        Pricebook2 preciosOportunidad = [
            SELECT Id, Name
            FROM Pricebook2
            WHERE Id =: OpportunityBeingUpdated.Pricebook2Id
        ];
       
        Map<String, PricebookEntry> royalPriceBook = Opp_Utils2.cargarPricebookEntries(preciosOportunidad.Name);
        String queryPlus = 'PricebookEntry.Product2.Variedade__c,'
            + 'PricebookEntry.Product2.Variedade__r.Name,'
            + 'PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c,'
            + 'PricebookEntry.Product2.UNIDADE__c,'
            + 'Categoria__r.Name';
               
        List<OpportunityLineItem> listOlisOfOppBeingEdited = aSiteUtils.queryResults1(
            OpportunityLineItem.SObjectType, queryPlus,
            'Opportunity.Id = :v1', idOportunidad
        );
               
        delete listOlisOfOppBeingEdited;
               
        List<OpportunityLineItem> itemsToBeAdded = new List<OpportunityLineItem>();
        for (aAppendix.myOppItem tmpItem : nuevosProductos) {
            OpportunityLineItem producto = aAppendix.myOppItem.armarLineItem(tmpItem);  
           
            if (this.productByVariedadeAndUnidade.containsKey(producto.Variedad__c)) producto.PricebookEntryId = this.productByVariedadeAndUnidade.get(producto.Variedad__c).get(tmpItem.unidade);
            producto.Lote_Rebajado__c = tmpItem.lote_rebajado;
            producto.OpportunityId = idOportunidad;
            itemsToBeAdded.add(producto);
        }
        insert itemsToBeAdded;
               
        if (OpportunityBeingUpdated.Comentarios__c != comentarioNuevaOportunidad) {
            OpportunityBeingUpdated.Comentarios__c = comentarioNuevaOportunidad;
            update OpportunityBeingUpdated;
        }

        if(paraAprobacion == '1') {
            aAppManager.enviarParaAprobacion(OpportunityBeingUpdated);
        }
    }

    public  void crearReembalagem(String opportunityComentario, String activeMarca,
                                                                String activeAccountId, String activeSafra,
                                                                SiteUser__c activeSiteUser, List<aAppendix.myOppItem> olisToBeAdded, String paraAprobacion) {

        Map<String, String> ListaRecordTypes = Opp_Utils2.cargarRecordTypesOportunidades();
        String reembalagemRecordTypeId = ListaRecordTypes.get('Reembalaje');
       
        String correoSiteUser = [
            SELECT Email__c
            FROM SiteUser__c
            WHERE Id =: activeSiteUser.id
            LIMIT 1
        ].Email__c;
       
        Opportunity reembalagemOpportunity = new Opportunity();

        reembalagemOpportunity.Name = 'Reembalaje';
        reembalagemOpportunity.StageName = 'Edición';
        reembalagemOpportunity.RecordTypeId = reembalagemRecordTypeId;
        reembalagemOpportunity.AccountId = activeAccountId;
        reembalagemOpportunity.Safra__c = activeSafra;
        reembalagemOpportunity.Marca__c = activeMarca;
        reembalagemOpportunity.Usuario__c = activeSiteUser.Id;
        reembalagemOpportunity.CloseDate = System.today();
        reembalagemOpportunity.Comentarios__c = opportunityComentario;
        reembalagemOpportunity.Pricebook2Id = this.idListaPrecio;
        reembalagemOpportunity.CorreoElectronicoSiteUser__c = correoSiteUser;

        insert reembalagemOpportunity;

        List<OpportunityLineItem> itemsToBeAdded = new List<OpportunityLineItem>();
        for (aAppendix.myOppItem tmpItem : olisToBeAdded) {
            OpportunityLineItem producto = aAppendix.myOppItem.armarLineItem(tmpItem);
            producto.Lote_Rebajado__c = tmpItem.lote_rebajado;
            producto.OpportunityId = reembalagemOpportunity.id;
            System.debug('this.productByVariedadeAndUnidade: ' + this.productByVariedadeAndUnidade);
            System.debug('this.productByVariedadeAndUnidade.get(producto.Variedad__c): ' + this.productByVariedadeAndUnidade.get(producto.Variedad__c));
            producto.PricebookEntryId = this.productByVariedadeAndUnidade.get(producto.Variedad__c).get(tmpItem.unidade);

            itemsToBeAdded.add(producto);
        }
        reembalagemOpportunity = [
            SELECT OwnerId
            FROM Opportunity
            WHERE ID =: reembalagemOpportunity.Id
        ];
        insert itemsToBeAdded;
        if(paraAprobacion == '1') {
            aAppManager.enviarParaAprobacion(reembalagemOpportunity);
        }
    }
}
global class aSiteAppendix1Controller {

    private String token;
    private SiteUser__c logUser;
    private Account activeAccount;
    private SiteUserSession__c activeSession;
    private String safraActual;
    public List<string> contratosestados {get;set;}
    public Opportunity[] relatedApp {get;set;}
    public Opportunity[] relatedAppReb {get;set;}
    public OpportunityLineItem[] relatedAppItems {get; set;}
    public String recId {get;set;}
    public String language {get;set;}
    public String titulo {get;set;}
    public String tituloReb {get;set;}
    private Map<String,String> rTypes;
    private String accountCNPJ;
    public string idOportunidadImprimir {get;set;}
    public String pdfBlob {get; set;}
    public String nombrePDF {get; set;}
    public List<String> categoriaOriginal {get;set;}
    public Boolean mostrarCooperante {get; set;}

    public Map<String, String> mapaIdCooperanteCampoRenasem {get;set;}
    public Map<String, String> mapaIdCooperanteCampoCNPJ {get;set;}

    public String idAnexoEditar {get;set;}
    public List<aAppendix.myOppItem> listaDeNuevosProductosDeOportunidad {get; set;}
    public aAppendix.myOppItem nuevoProductoDeOportunidad {get; set;}
    public String paraAprobacion {get; set;}
    public String idItemRemover {get;set;}
    public String variedadSeleccionada {get;set;}
    public aAppendix.oppWrapper oportunidadWrapper {get;set;}
    public String estadoComercioPreSeleccionados {get;set;}
    public String cooperante {get;set;}
    public List<String> arrayEstados {get;set;}
    public String[] estados {get;set;}

    public Map<String,String> nombreCategoriaPorId {get;set;}
    public Map<String, String> idCategoriaNombre {get;set;}
    public Map<String, String> nombreEstadoPorId {get;set;}

    public ManejadorAnexoI manejador {get;set;}
    private FactoryManejador factory;

    public String[] epocaPlantacion {get;set;}

    public String mensajeErrorCantidad {get; set;}
    public String mensajeErrorCategoria {get; set;}
    public String mensajeErrorPlantio {get; set;}
    public String mensajeErrorVariedad {get; set;}
    public String mensajeErrorCategoriaPlantar {get;set;}
    public String mensajeErrorEstadoProduccion {get;set;}
    public String mensajeErrorHaAutorizados {get;set;}
    public String categoriaPlantarSeleccionada {get;set;}
    public string mensajeErrorNohayProductos {get;set;}
    public String[] ListaDeEstadosActual() {
        return estados;
    }

    public String[] getEstados() {
        return estados;
    }
    
    public void setEstados(String[] estados) {
        this.estados = estados;
    }
    
    public string getEstadosComercializacionAppendix(){
        return this.oportunidadWrapper.estadoComercialzacion;
    }
    global aSiteAppendix1Controller () {
        try {
            language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
            rTypes = Opp_Utils.cargarRecordTypesOppbyDevName();
            titulo = rTypes.get('AnexoI');
            //tituloReb = rTypes.get('Anexo_I_Rebaixamento_Ha');
        }
        catch(Exception e) {
            System.debug(e.getMessage());
        }
        this.idAnexoEditar = null;
        this.listaDeNuevosProductosDeOportunidad = new List<aAppendix.myOppItem>();
        this.nuevoProductoDeOportunidad = new aAppendix.myOppItem();
        this.nombreCategoriaPorId = new Map<String,String>();
        this.nombreEstadoPorId = new Map<String, String>();
        this.arrayEstados = new List<String>();
        this.idAnexoEditar = System.currentPageReference().getParameters().get('idEdicion');
        this.estados = new String[]{};
        this.epocaPlantacion = new string[]{};
        this.factory = new FactoryManejador();
        this.mapaIdCooperanteCampoRenasem = new Map<String, String>();
        this.mapaIdCooperanteCampoCNPJ = new Map<String, String>();
        this.estadoComercioPreSeleccionados =  'null';
        this.categoriaOriginal = new List<String>();
        this.idCategoriaNombre = new Map<String, String>();
        this.mostrarCooperante = false;
        
        List<Categoria__c> categoriesInDb = aAppManager.getCategorias();
        if (!categoriesInDb.isEmpty()) {
            for (Categoria__c tmpCategory : categoriesInDb) {
                    this.idCategoriaNombre.put(tmpCategory.Name, tmpCategory.Id);     
                }
            }
        if(this.idAnexoEditar != null) {
            Opportunity oportunidad = [
                SELECT Id, Cooperante__c, Epoca_de_Plantio__c, Estados_Comercializacion__c, CNPJ_CPF_Anexo__c, Motivo_de_Rechazo__c,
                Cooperante__r.Renasem__c
                FROM Opportunity
                WHERE ID =: idAnexoEditar
            ];
            
            

            this.oportunidadWrapper = new aAppendix.oppWrapper();
            this.oportunidadWrapper.idCooperador = oportunidad.Cooperante__c;
            this.oportunidadWrapper.epocaPlantacion = oportunidad.Epoca_de_Plantio__c;
            this.oportunidadWrapper.estadoComercialzacion = oportunidad.Estados_Comercializacion__c;
            this.oportunidadWrapper.cnpj = oportunidad.CNPJ_CPF_Anexo__c;
            this.oportunidadWrapper.rechazo = oportunidad.Motivo_de_Rechazo__c;
            this.oportunidadWrapper.renasem = oportunidad.Cooperante__r.Renasem__c;
            if(oportunidad.Cooperante__c != null)
            {
                this.mostrarCooperante = true;
            }
            else
            {
                if (this.oportunidadWrapper.cnpj != null && this.oportunidadWrapper.cnpj.length() > 10) {
                    this.oportunidadWrapper.sufixCnpj = this.oportunidadWrapper.cnpj.substring(11,this.oportunidadWrapper.cnpj.length());
                    this.oportunidadWrapper.cnpj = this.oportunidadWrapper.cnpj.substring(0, 11);
                    
                }                    
            }
        }else {
            this.oportunidadWrapper = new aAppendix.oppWrapper();
        }
    }
       
    public PageReference validate() {
        token = System.currentPageReference().getParameters().get('token');
        if(token!=null) {
            logUser = aSiteAuthManager.VerifyUserSession(token);
            if(logUser!=null) {
                activeSession = aSiteAuthManager.getUserSession(token);
                activeAccount = aSiteAuthManager.getActiveAccount_byUser(logUser);
                safraActual = aAppManager.getSafraActualByApp('A1');
                this.manejador = (ManejadorAnexoI)factory.devuelveManejador('Anexo I', activeAccount.Id, aAppManager.calcularSafraAnterior(safraActual), activeSession.Marca__c);
                this.manejador.cargarItemsContrato(activeAccount.Id, safraActual, activeSession.Marca__c);
                this.manejador.setearMapas(); 
                this.manejador.sacarVariedadesRebajadas();
                Account cuenta = [SELECT ID, CNPJ_CPF__c FROM Account WHERE ID =: activeAccount.Id];
                accountCNPJ = cuenta.CNPJ_CPF__c;
                if(this.oportunidadWrapper.cnpj == null && this.oportunidadWrapper.idCooperador == null) setTheAccountCNPJ();
                return null;  
            }          
        }
        PageReference p = new PageReference('/apex/aSiteLogin');
        String marca = aSiteAuthManager.getMarcaBySession(token); 
        if (marca != null) {
            p.getParameters().put('comp',marca);
        }
        p.setRedirect(true);
        return p;

    }
       
        
    public List<Opportunity> getAppends1(){
        if(relatedApp != null && relatedApp.size()>0){
          return relatedApp;
        }

        try {
//          relatedApp = aSiteUtils.queryResults4(Opportunity.SObjectType, null,'AccountId = :v1', activeAccount.Id, 'RecordType.DeveloperName = :v2', 'AnexoI', 'Safra__c = :v3',activeSession.Safra__c, 'Marca__c = :v4', activeSession.Marca__c);
           // relatedApp = aAppManager.getAnexos1(activeAccount.Id, safraActual, activeSession.Marca__c);
          
           relatedApp = aSiteUtils.queryResults5(
                Opportunity.SObjectType, null,
                'AccountId = :v1', activeAccount.Id, 
                'RecordType.DeveloperName = :v2', 'AnexoI',
                'Safra__c = :v3', safraActual, 
                'Marca__c = :v4', activeSession.Marca__c, 
                'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado'
            );

            if(relatedApp.size()>0){
                recId=relatedApp[0].Id;
            }

            setActiveApp1();
        
            return relatedApp;
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage()));
            return null;
        }
    }
    
    
    public List<Opportunity> getAppends1Reb(){
        try{

            if(relatedAppReb != null && relatedAppReb.size()>0) {
                return relatedAppReb;
            }
                
            //relatedAppReb = aSiteUtils.queryResults4(Opportunity.SObjectType, null,'AccountId = :v1', activeAccount.Id, 'RecordType.DeveloperName = :v2', 'Anexo_I_Rebaixamento_Ha','Safra__c = :v3',activeSession.Safra__c, 'Marca__c = :v4', activeSession.Marca__c);    
            relatedAppReb = aAppManager.getAnexos1Rebaja(activeAccount.Id, safraActual, activeSession.Marca__c);
        
            if(relatedAppReb .size()>0) {
                recId=relatedAppReb [0].Id;   
            }

            setActiveApp1();
        
            return relatedAppReb ;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage()));
            return null;
        }   
    }

    public void setActiveApp1(){
        try{
            relatedAppItems = new List<OpportunityLineItem>();
            relatedAppItems = aAppManager.getAnexosItemsByOpp(recId);
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getMessage()));
        } 
    }

    public PageReference imprimirContratoAnexoI() {
        String documentId;        
        dfsle__EnvelopeStatus__c envelopeStatusObject;
        List<Attachment> attachmentObjectList;
        if(!Test.isRunningTest()) {
            envelopeStatusObject = [SELECT Id FROM dfsle__EnvelopeStatus__c WHERE Oportunidade__c =: recId LIMIT 1];
        } else {
            envelopeStatusObject = [SELECT Id FROM dfsle__EnvelopeStatus__c WHERE dfsle__SourceId__c = 'OpportunityId' LIMIT 1];
        }
        attachmentObjectList = [SELECT Id, Name FROM Attachment WHERE ParentId = :envelopeStatusObject.Id];
        for(Attachment attachmentObject : attachmentObjectList) {
            if(!attachmentObject.Name.contains('Certificate')) {
                documentId = attachmentObject.Id;
            }
        }
        String downloadUrl = ('/servlet/servlet.FileDownload?file='+documentId);
        PageReference pr = new PageReference(downloadUrl);
        pr.setRedirect(true); 
        return pr;         
    }

    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.OpportunityLineItem.FieldSets.AnexoI.getFields();
    }
    public List<Schema.FieldSetMember> getFieldsReb() {
        return SObjectType.OpportunityLineItem.FieldSets.AnexoI_Rebaixamento.getFields();
    }
    public SiteUser__c getUser(){
        return logUser;
    }
    public Account getAccount(){
        return activeAccount;
    }

                                        /******************* GENERAR NUEVA OPORTUNIDAD ********************/

    public PageReference gotoNew() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix1Edit');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public List<aAppendix.myOppItem>  getApp1Items() {

        if(this.idAnexoEditar != null && this.listaDeNuevosProductosDeOportunidad.isEmpty()) {
            List<OpportunityLineItem> listaProductos = this.manejador.obtenerProductosOportunidad(this.idAnexoEditar);
            for(OpportunityLineItem producto: listaProductos) {
                if(idItemRemover != producto.Id) {
                    aAppendix.myOppItem wrapper = aAppendix.armarWrapper(producto);
                    this.listaDeNuevosProductosDeOportunidad.add(wrapper);
                }
            }
        }
        return this.listaDeNuevosProductosDeOportunidad;
    }

    //TODO: PDF DESCARTE TO APPENDIX
    public void getPdfUrl() {
        List<Attachment> pdfs = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId = :idOportunidadImprimir];
        Opportunity opp = [SELECT Id, Name, Marca__c FROM Opportunity WHERE Id = :idOportunidadImprimir LIMIT 1];
        String expectedName = opp.Name + '_' + opp.Marca__c + '_autorization.pdf';
        for (Attachment tmpPdf :pdfs) {
            if (tmpPdf.Name == expectedName) {
                nombrePDF = tmpPdf.Name;
                pdfBlob = EncodingUtil.base64Encode(tmpPdf.Body);
                break;
            }
        }
    }

    public PageReference saveAppend1() {
        
        if(this.estados.size() <= 0) {
            mensajeErrorNohayProductos = ' - O campo "Estado de Comercialização" não pode estar vazio';
            return null;
        }
        
        if(listaDeNuevosProductosDeOportunidad.size() <= 0) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Não possui produtos associados'));
            mensajeErrorNohayProductos = ' - Não possui produtos associados';
            return null;
        }

        if (this.oportunidadWrapper.sufixCNPJ != null) {
                this.oportunidadWrapper.CNPJ = this.oportunidadWrapper.CNPJ + this.oportunidadWrapper.sufixCNPJ;
        }
        
        mensajeErrorCantidad = null;
        if(idAnexoEditar != null) {
            this.manejador.actualizarOportunidadAnexoi(activeSession.Marca__c, activeAccount.Id, safraActual, logUser, paraAprobacion,
                                                    listaDeNuevosProductosDeOportunidad, idAnexoEditar, this.oportunidadWrapper, this.estados);
        }
        else {
            Opportunity oportunidad = this.manejador.crearOportunidadAnexoI(activeSession.Marca__c, activeAccount.Id, safraActual, logUser,
                                                    paraAprobacion, listaDeNuevosProductosDeOportunidad, this.oportunidadWrapper, this.estados);
        }
        return editCancel();
    }

    public aAppendix.myOppItem getnuevoOppLineItem() {
        aAppendix.myOppItem oli = new aAppendix.myOppItem();
        this.nuevoProductoDeOportunidad = oli;
        this.nuevoProductoDeOportunidad.haAutorizados = null;
        this.nuevoProductoDeOportunidad.amount = null;
        return nuevoProductoDeOportunidad;
    }

    public PageReference editCancel() {
        PageReference pr = new PageReference('/apex/aSiteAppendix1');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);      
        return pr; 
    }
    public PageReference gotoEdit() {
        String tokenUsuarioActivo = System.currentPageReference().getParameters().get('token');
        PageReference pageRef = new PageReference('/apex/aSiteAppendix1Edit');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('token',tokenUsuarioActivo);
        pageRef.getParameters().put('idEdicion',idAnexoEditar);
        
        return pageRef;
    }
    
    public List<SelectOption> getVariedades() {
        List<SelectOption> varietiesList = new List<SelectOption>();

        Set<String> idsVariedad = this.manejador.nombreVariedadPorId.keySet();
        for(String variedad : idsVariedad) {
            varietiesList.add(new SelectOption(variedad, this.manejador.nombreVariedadPorId.get(variedad)));
        }
            return varietiesList;
    }

    public void setSelectedVariedad() {
        this.variedadSeleccionada = nuevoProductoDeOportunidad.variedad;
        this.categoriaOriginal = new List<String>();
        this.categoriaOriginal.addAll(this.manejador.mapaCategoriaOriginal.get(this.variedadSeleccionada));
    }

    public void setSelectedCooperante() {
        this.cooperante = this.oportunidadWrapper.idCooperador;
    }

    public void setCategoriaRebaja() {
        this.categoriaPlantarSeleccionada = this.nuevoProductoDeOportunidad.categoria_a_rebajar;
    }

    public List<SelectOption> getCategoriasAnexo() {
        List<SelectOption> categoriesList = new List<SelectOption>();
        nombreCategoriaPorId = New Map<String,String>();
        Boolean flag=false;
        if (!String.isEmpty(variedadSeleccionada)) {
            for (String categoriaName : this.manejador.mapaRebajaCategorias.get(this.categoriaPlantarSeleccionada)) 
            {
                String categoriaId = this.manejador.mapaCategorias.get(categoriaName);
                nombreCategoriaPorId.put(categoriaId, categoriaName);     
                categoriesList.add(new SelectOption(categoriaId, categoriaName));
            }
        }
        return categoriesList;
    }

    public void addProduct() {
        if ( validateRequiredFields()) {
            this.addItem();
            clearErrorMessages();
        }
    }

     public Boolean validateRequiredFields() {
        Boolean ret = true;

        if(String.isEmpty(nuevoProductoDeOportunidad.variedad)) {
            mensajeErrorVariedad = Label.ErrorVariedad;
            ret = false;
        }

        if(String.isEmpty(String.valueOf(nuevoProductoDeOportunidad.categoria_a_rebajar))) {
            mensajeErrorCategoriaPlantar = Label.ErrorCategoria;
            ret = false;
        }

        if(String.isEmpty(nuevoProductoDeOportunidad.categoria)) {
            mensajeErrorCategoria = Label.ErrorCategoria;
            ret = false;
        }
        
        if(String.isEmpty(String.valueOf(nuevoProductoDeOportunidad.haAutorizados)) || nuevoProductoDeOportunidad.haAutorizados < 0 ) {
            mensajeErrorHaAutorizados = Label.cantidadIgualCero;
            ret = false;
        }

        if(String.isEmpty(String.valueOf(nuevoProductoDeOportunidad.amount))  || nuevoProductoDeOportunidad.amount <= 0) {
            mensajeErrorCantidad = Label.cantidadIgualCero;
            ret = false;
        }

        if(String.isEmpty(String.valueOf(nuevoProductoDeOportunidad.estadoProduccion_id))) {
            mensajeErrorEstadoProduccion = 'Deve eleger um estado';
            ret = false;
        }

        return ret;
    }
    

    public void addItem() {
        nuevoProductoDeOportunidad.id = GuidUtil.NewGuid();
        nuevoProductoDeOportunidad.variedad_nombre = this.manejador.nombreVariedadPorId.get(nuevoProductoDeOportunidad.variedad);
        nuevoProductoDeOportunidad.registro = this.manejador.nombreRegistroVariedadPorId.get(nuevoProductoDeOportunidad.variedad);
        nuevoProductoDeOportunidad.categoria_nombre = this.nombreCategoriaPorId.get(nuevoProductoDeOportunidad.categoria);
        
        //nuevoProductoDeOportunidad.categoria_nombre = this.idCategoriaNombre.get(nuevoProductoDeOportunidad.categoria);  //JERE
                
        this.nuevoProductoDeOportunidad.estadoProduccion_nombre = nombreEstadoPorId.get(nuevoProductoDeOportunidad.estadoProduccion_id);
       
        if(nuevoProductoDeOportunidad.categoria_a_rebajar == 'PREBA') nuevoProductoDeOportunidad.categoria_a_rebajar = 'GENETICA';
       
        this.nuevoProductoDeOportunidad.categoria_a_rebajar_id = this.idCategoriaNombre.get(nuevoProductoDeOportunidad.categoria_a_rebajar);
        if(!this.listaDeNuevosProductosDeOportunidad.contains(this.nuevoProductoDeOportunidad)) {
            this.listaDeNuevosProductosDeOportunidad.add(this.nuevoProductoDeOportunidad);
        }
    }

    
    public void removeProduct() {
        for (Integer i = 0; i < listaDeNuevosProductosDeOportunidad.size(); i++) {
            if (listaDeNuevosProductosDeOportunidad[i].id == idItemRemover) {
                listaDeNuevosProductosDeOportunidad.remove(i);
            }
        } 
    }

    public List<SelectOption> getEstadoDeLaProduccion() {
        List<SelectOption> opciones = new List<SelectOption>();
        List<Estado__c> listaEstados = [
            SELECT Id, Name
            FROM Estado__c
            WHERE Mostrar_en_portal__c = true ORDER BY Name
        ];
        for(Estado__c estado : listaEstados) {
            opciones.add(new SelectOption(estado.Id, estado.Name));
            nombreEstadoPorId.put(estado.Id, estado.Name);
        }

        return opciones;
    }

      public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('US','US'));
            options.add(new SelectOption('CANADA','Canada'));
            options.add(new SelectOption('MEXICO','Mexico'));
            return options;
        }

           
    public List<SelectOption> getEstadoComercializacion() {
        List<SelectOption> opciones = new List<SelectOption>();

        List<Contrato__c> listaEstados = [
            SELECT Id, Estados_Comercializacao__c
            FROM Contrato__c
            WHERE Sociedad__c =: activeSession.Marca__c
            AND Safra__c =: safraActual
            AND Multiplicador__c =: activeAccount.Id
            AND Estado__c = 'Chegou'
            AND Estados_Comercializacao__c != null
        ];
        
        Set<String> estados = new Set<String>();

        for(Contrato__c contrato : listaEstados) {
            for (String estado : contrato.Estados_Comercializacao__c.split(';')) {          
                if (!estados.contains(estado))  {
                    estados.add(estado);
                }
            }
        }

        
        List<String> estadosList = new List<string>(estados);
        estadosList.sort();

        for (String estado : estadosList) {
            opciones.add(new SelectOption(estado,estado));
        }
        estadoComercioPreSeleccionados = '\'' + this.oportunidadWrapper.estadoComercialzacion + '\'';
        if(estadoComercioPreSeleccionados == null){
                estadoComercioPreSeleccionados = 'null';

        }
        
        return opciones;
    }


    

    public List<SelectOption> getEpocaPlantaciones() {
        List<SelectOption> opciones = new List<SelectOption>();
        Schema.DescribeFieldResult plantacionEstatus = Opportunity.Epoca_de_Plantio__c.getDescribe();

        list<Schema.PicklistEntry> picklistValues = plantacionEstatus.getPicklistValues();
        //Modificar la query para filtrar qué estados mostrar

        for(Schema.PicklistEntry p : picklistValues) {
            opciones.add(new SelectOption(p.getLabel(), p.getValue()));
        }
        //this.oportunidadWrapper.epocaPlantacion = opciones[0].getLabel();
        return opciones;
    }
   

    public List<SelectOption> getCuentasCooperantes() {
        List<SelectOption> opciones = new List<SelectOption>();
        //Modificar la query para filtrar qué estados mostrar
        List<Cooperante__c> cuentas = [ 
            SELECT Id, Name, CuentaCoop__c, CuentaCoop__r.Name, Renasem__c, CuentaCoop__r.Renasem__c, CuentaCoop__r.CNPJ_CPF__c
            FROM Cooperante__c
            WHERE Cuenta__c =: this.activeAccount.Id
        ];
        for(Cooperante__c cuenta : cuentas) {
            opciones.add(New SelectOption(cuenta.CuentaCoop__c, cuenta.CuentaCoop__r.Name));
            this.mapaIdCooperanteCampoRenasem.put(cuenta.CuentaCoop__c, cuenta.CuentaCoop__r.Renasem__c);
            this.mapaIdCooperanteCampoCNPJ.put(cuenta.CuentaCoop__c, cuenta.CuentaCoop__r.CNPJ_CPF__c);
        }
        return opciones;
    }

    public aAppendix.oppWrapper getNuevaOportunidad() {
        return this.oportunidadWrapper;
    }

    public PageReference setEstadosSeleccionados() {
        this.arrayEstados.add(ApexPages.currentPage().getParameters().get('estados'));
        System.debug(this.arrayEstados);
        return null;
    }
    
    public void setTheAccountCNPJ() {
        if (accountCNPJ != null && accountCNPJ.length() > 10) {
            this.oportunidadWrapper.cnpj = accountCNPJ.substring(0, 11);
            this.oportunidadWrapper.sufixCnpj = accountCNPJ.substring(11,accountCNPJ.length());
        }
       
    }    
    public void actualizarRenasem() {
        this.oportunidadWrapper.renasem = this.mapaIdCooperanteCampoRenasem.get(this.oportunidadWrapper.idCooperador);
        if (this.oportunidadWrapper.idCooperador != null && this.mapaIdCooperanteCampoCNPJ.get(this.oportunidadWrapper.idCooperador) != null) {
            this.oportunidadWrapper.cnpj = this.mapaIdCooperanteCampoCNPJ.get(this.oportunidadWrapper.idCooperador);
            this.oportunidadWrapper.sufixCnpj = null;
        } else {
            setTheAccountCNPJ();
        }
    }

    public List<SelectOption> getCategoriaPlantar() {
        List<SelectOption> opciones = new List<SelectOption>();
        for(String cate : this.categoriaOriginal) {
            opciones.add(new SelectOption(cate, cate));
        }
        //if(this.manejador.mapaCategoriaRebajada.get(this.variedadSeleccionada) != null && this.manejador.mapaCategoriaRebajada.get(this.variedadSeleccionada) != 'S2') {
        //    opciones.add(new SelectOption(this.manejador.mapaCategoriaRebajada.get(this.variedadSeleccionada), this.manejador.mapaCategoriaRebajada.get(this.variedadSeleccionada)));
        //    this.categoriaOriginal.add(this.manejador.mapaCategoriaRebajada.get(this.variedadSeleccionada));
        //}
        return opciones;
    }
    
    public void clearErrorMessages() {
        mensajeErrorHaAutorizados = null;
        mensajeErrorCantidad = null;
        mensajeErrorCategoria = null;
        mensajeErrorVariedad = null;
        mensajeErrorEstadoProduccion = null;
        mensajeErrorCategoriaPlantar = null;
    }
    
    public void habilitarCooperante()
    {
        //this.mostrarCooperante = !this.mostrarCooperante;
        if(!this.mostrarCooperante)
        {
            this.oportunidadWrapper.idCooperador = null;
            this.oportunidadWrapper.renasem = null;
            actualizarRenasem();
        }
    }

}
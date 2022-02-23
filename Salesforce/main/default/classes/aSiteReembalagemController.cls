global without sharing class aSiteReembalagemController {
    
    private Map<String,Id> tipoRegistroPorNombre;
    private Map<String,String> tipoRegistroPorNombreDesarrollador;
    public String lenguajeUsuario {get; set;}
    public String language {get; set;}

    public String tituloDePagina {get; set;}
    
    private String tokenUsuarioActivo;
    private SiteUser__c usuarioDeSitioActivo;
    private SiteUserSession__c sesionActiva;
    private Account cuentaActiva;
    private String safraActiva;

    public List<Opportunity> listaDeOportunidades {get; set;}
    public List<OpportunityLineItem> productosDeOportunidadSeleccionada {get; set;}
    public Map<Id, Attachment> attachmentByOppId {get; set;}
	public Map<Id, string> attachmentsBase64 {get; set;}

    public String idDeReembalagemSeleccionado {get;set;}
    public String idDeReembalagemEditar {get;set;}

    public Map<String,String> nombreVariedadPorId; 
    public Map<String,String> nombreRegistroVariedadPorId;
    public Map<String,String> nombreCategoriaPorId;
    public Map<String, Set<String>> categoriasPorVariedad {get; set;}
	public String editId {get;set;}
	public Map<String, Map<String, Map<String, Decimal>>> mapaVolumenDisponibleEnPortal{get;set;}

    public aAppendix.myOppItem nuevoProductoDeOportunidad {get; set;}
    public List<aAppendix.myOppItem> listaDeNuevosProductosDeOportunidad {get; set;}
    public String variedadSeleccionada {get; set;}
    public String idItemRemover {get; set;}
    public String comentarioNuevaOportunidad {get; set;}
    public String paraAprobacion {get; set;}
   
    public String mensajeErrorCantidad {get; set;}
    public String mensajeErrorCategoria {get; set;}
    public String mensajeErrorVariedad {get; set;}
	public String mensajeErrorLote {get;set;}
	public String mensajeErrorUnidad {get;set;}
	public String mensajeErrorCantidadPortal {get;set;}
	public String mensajeErrorAdicion {get;set;}
	public string mensajeErrorNohayProductos {get;set;}

	public ManejadorReembalagem manejador {get;set;}
	private FactoryManejador factory;
    
    public String pdfBlob {get; set;}
    public String nombrePDF {get; set;}
    public String idOportunidadImprimir {get; set;}
    public List<aAppendix.myOppItem> listaProductosParaEliminar {get; set;}
    
    global aSiteReembalagemController() {
        listaDeNuevosProductosDeOportunidad = new List<aAppendix.myOppItem>();
        nombreVariedadPorId = New Map<String, String>();
        listaDeOportunidades =  new List<Opportunity>();
        nombreCategoriaPorId = new Map<String,String>();
        categoriasPorVariedad = new Map<String, Set<String>>();
        nuevoProductoDeOportunidad = new aAppendix.myOppItem();
		listaProductosParaEliminar = new List<aAppendix.myOppItem>();
        nombreRegistroVariedadPorId = new Map<String, String>();
		this.factory = new FactoryManejador();
		
        
        tipoRegistroPorNombre = Opp_Utils.cargarRecordTypesOportunidades();
        lenguajeUsuario = [SELECT id, LanguageLocaleKey 
                            FROM User 
                            WHERE id = :UserInfo.getUserId()].LanguageLocaleKey;
        
        language = lenguajeUsuario;

        tipoRegistroPorNombreDesarrollador = Opp_Utils.cargarRecordTypesOppbyDevName();
        tituloDePagina = 'Reembalaje'; 
        idDeReembalagemEditar = System.currentPageReference().getParameters().get('e');
    }
    
    public PageReference validate() {  
        tokenUsuarioActivo = System.currentPageReference().getParameters().get('token');
        if(!String.isEmpty(tokenUsuarioActivo)) {
            usuarioDeSitioActivo = aSiteAuthManager.VerifyUserSession(tokenUsuarioActivo);
            if(usuarioDeSitioActivo!=null) {
                sesionActiva = aSiteAuthManager.getUserSession(tokenUsuarioActivo);
                cuentaActiva = aSiteAuthManager.getActiveAccount_byUser(usuarioDeSitioActivo);
                safraActiva = aAppManager.getSafraActualByApp('Reembalagem');
				this.manejador = (ManejadorReembalagem)factory.devuelveManejador('Reembalagem', cuentaActiva.Id, safraActiva, sesionActiva.Marca__c);
				System.debug('safra ' + safraActiva);
                return null;  
            }          
        }
        
        PageReference pageRef = new PageReference('/apex/aSiteLogin');
        String activeMarca = aSiteAuthManager.getMarcaBySession(tokenUsuarioActivo);
        if (!String.isEmpty(activeMarca)) { 
            pageRef.getParameters().put('comp',activeMarca);
        }	
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public SiteUser__c getUser() {
        return usuarioDeSitioActivo;
    }
    
    public Account getAccount() {
        return cuentaActiva;
    }

    
	public void getAttachment() {
		attachmentByOppId = new Map<Id, Attachment>();
		Set<string> oppIds = new Set<string>();


		for (Opportunity opp : listaDeOportunidades) {
			oppIds.add(opp.Id);
		}

        List<Attachment> pdfs = [
            SELECT Id, Name, Body, ParentId 
            FROM Attachment 
            WHERE ParentId = :oppIds
			AND Parent.RecordType.DeveloperName = 'Reembalaje'
			ORDER BY CreatedDate DESC
        ];
		

		for (Opportunity opp : listaDeOportunidades) {
			for (Attachment att : pdfs) {
				if (att.ParentId == opp.id && att.name.contains(opp.Marca__c+'.pdf') ){
					attachmentByOppId.put(opp.Id, att);
					opp.VB_Recebeu__c = true;
				}
			}
		}
	}

    public void getPdfUrl() {
        //List<Attachment> pdfs = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId = :idOportunidadImprimir];
		Attachment att = attachmentByOppId.get(idOportunidadImprimir);
		if(att != null) {
			nombrePDF = att.Name;
			pdfBlob = EncodingUtil.base64Encode(att.Body);
		}
		
      	

		//nombrePDF = pdfs[0].Name;
        //pdfBlob = EncodingUtil.base64Encode(pdfs[0].Body);

		/*for (Attachment tmpPdf :pdfs) {
           if(tmpPdf.Name.contains(opp.Marca__c + '.pdf')) {
		    //if (tmpPdf.Name == expectedName) {
                nombrePDF = tmpPdf.Name;
                pdfBlob = EncodingUtil.base64Encode(tmpPdf.Body);
                break;
            }
        }*/


    }
    
    public PageReference imprimirReembalagem() {
        String documentId;        
        dfsle__EnvelopeStatus__c envelopeStatusObject;
        List<Attachment> attachmentObjectList;
        if(!Test.isRunningTest()) {
            envelopeStatusObject = [SELECT Id FROM dfsle__EnvelopeStatus__c WHERE Oportunidade__c =: idOportunidadImprimir LIMIT 1];
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
    
    public List<Opportunity> getReembalagemOpportunities() {
        if (listaDeOportunidades.isEmpty()) {
            listaDeOportunidades = this.manejador.obtenerOportunidadesReembalaje(cuentaActiva.Id, safraActiva, sesionActiva.Marca__c);
            if (!listaDeOportunidades.isEmpty()) {
                idDeReembalagemSeleccionado = listaDeOportunidades[0].Id;
            }
            getProductsForSelectedReembalagemOpportunity();
        } 
		//getAttachment();
        return listaDeOportunidades;
    }
    
    public void getProductsForSelectedReembalagemOpportunity() {
        productosDeOportunidadSeleccionada = this.manejador.obtenerProductosOportunidad(idDeReembalagemSeleccionado);
    }
    
    public List<Schema.FieldSetMember> getFields() {
		
        return SObjectType.OpportunityLineItem.FieldSets.Reembalaje.getFields();
    }

	
    public aAppendix.myOppItem getNewOppLineItem() {
        aAppendix.myOppItem  oli = new aAppendix.myOppItem();
        nuevoProductoDeOportunidad = oli;
        return nuevoProductoDeOportunidad;
    }
    
    public List<aAppendix.myOppItem> getOppLineItem() {
        
        if (!String.isEmpty(idDeReembalagemEditar) && listaDeNuevosProductosDeOportunidad.isEmpty() && listaProductosParaEliminar.isEmpty()) {
            comentarioNuevaOportunidad = [SELECT Id, Comentarios__c 
                            FROM Opportunity 
                            WHERE Id = :idDeReembalagemEditar LIMIT 1].Comentarios__c; 
            
            List<OpportunityLineItem> tmpOlisList = this.manejador.obtenerProductosOportunidad(idDeReembalagemEditar);
            for (OpportunityLineItem tmpOLI : tmpOlisList) {
				if(tmpOLI.Id != idItemRemover) {
					aAppendix.myOppItem customOli = aAppendix.armarWrapper(tmpOLI);
					listaDeNuevosProductosDeOportunidad.add(customOli);
				}
            }
        } 

		mapaVolumenDisponibleEnPortal = this.manejador.validarVolumenReembalaejem(this.listaDeNuevosProductosDeOportunidad);
        return listaDeNuevosProductosDeOportunidad;
    }
    
    public List<SelectOption> getVariedadesNewReembalagem() {

        List<SelectOption> varietiesList = new List<SelectOption>();
		this.manejador.setearMapas();
		Set<String> idsVariedad = this.manejador.nombreVariedadPorId.keySet();
		System.debug(idsVariedad);
		for(String variedad : idsVariedad) {
			varietiesList.add(new SelectOption(variedad, this.manejador.nombreVariedadPorId.get(variedad)));
		}

		return varietiesList;
	}
   
    public void setSelectedVariedad() {
        variedadSeleccionada = nuevoProductoDeOportunidad.variedad ;
		mensajeErrorVariedad = null;
    }
    public void clearError() {
		mensajeErrorCategoria = null;
	}


    public List<SelectOption> getCategoriaNewReembalagem() {
        List<SelectOption> categoriesList = new List<SelectOption>();
        if (!String.isEmpty(variedadSeleccionada)) {
            Set<String> categoriesForSelectedVariedad = this.manejador.categoriasPorVariedad.get(this.manejador.nombreVariedadPorId.get(variedadSeleccionada)); 
            System.debug(categoriesForSelectedVariedad);
			System.debug('v<ar ' + this.manejador.categoriasPorVariedad);
			nombreCategoriaPorId = New Map<String,String>();
            List<Categoria__c> categoriesInDb = aAppManager.getCategorias(); 
            if (!categoriesInDb.isEmpty()) {
                for (Categoria__c tmpCategory : categoriesInDb) {
                    if (categoriesForSelectedVariedad.contains(tmpCategory.Name)) {
                        nombreCategoriaPorId.put(tmpCategory.Id, tmpCategory.Name);     
                        categoriesList.add(new SelectOption(tmpCategory.Id, tmpCategory.Name));
                    }
                }
            }
        }
        return categoriesList;
    }

    public Boolean validateItemQuantityOnSave() { 

        Boolean ret = true;
		if(listaDeNuevosProductosDeOportunidad.size() == 0) { 
			return ret;
		}
		Map<String, Decimal> mapaCantidadDisponible = new Map<String, Decimal>();
		Map<String, Decimal> mapaCantidadIngresada = new Map<String, Decimal>();
		mapaVolumenDisponibleEnPortal = this.manejador.validarVolumenReembalaejem(this.listaDeNuevosProductosDeOportunidad);

        for (aAppendix.myOppItem tmpOli :listaDeNuevosProductosDeOportunidad) {
			Map<String, Map<String,Decimal>> cantidadVariedad = mapaVolumenDisponibleEnPortal.get(tmpOli.variedad);
			Map<String, Decimal> unidadPorCantidad = cantidadVariedad.get(tmpOli.categoria);
			Decimal cantidadDisponible = unidadPorCantidad.get(tmpOli.unidade);

			if(!mapaCantidadDisponible.containsKey(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade)) {
				mapaCantidadDisponible.put(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade, cantidadDisponible);
			}
			if(!mapaCantidadIngresada.containsKey(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade)) {
				mapaCantidadIngresada.put(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade, tmpOli.amount);
			}else {
				Decimal cant = mapaCantidadIngresada.get(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade);
				cant += tmpOli.amount;
				mapaCantidadIngresada.put(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade, cant);
			}
		}
		for (aAppendix.myOppItem tmpOli :listaDeNuevosProductosDeOportunidad) {

			Decimal disponible = mapaCantidadDisponible.get(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade);
			Decimal enPortal = mapaCantidadIngresada.get(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade);

			if (enPortal> disponible) {
           		String errorCant = 'O quantidade total da variedade ' + tmpOli.variedad_nombre + ' categoria ' + tmpOli.categoria_nombre + ' e pela unidade ' + tmpOli.unidade + ' não deve ser maior que ' + disponible;  //QUANTITY EXCEEDS
				ret = false;
           		mensajeErrorCantidadPortal = errorCant;
				break;

       	 	} else if (tmpOli.amount <= 0) {
           		String error = Label.cantidadIgualCero;
				tmpOli.error_msg = error; 
				ret = false;
				break;
        	}
		}        
       	return ret;
    }

	public Boolean validateLote() {
		Boolean resp = true;
		for(aAppendix.myOppItem tmp : listaDeNuevosProductosDeOportunidad) {
			if(tmp.lote_rebajado.isWhitespace()) {
				tmp.error_lote = Label.ErrorLote;
				resp = false;
				break;
			}
		}
		return resp;
	}
    
    public Boolean validateItemQuantity() {
        Boolean ret = true;
		List<aAppendix.myOppItem> listaVacia = new List<aAppendix.myOppItem>();
		Map<String, Map<String, Map<String, Decimal>>> mapaVolumenDisponible = this.manejador.validarVolumenReembalaejem(listaVacia);
		if(mapaVolumenDisponible.size() == 0) {
			return ret;
		}
		Map<String, Map<String,Decimal>> cantidadVariedad = mapaVolumenDisponible.get(this.variedadSeleccionada);
		Map<String, Decimal> unidadPorCantidad = cantidadVariedad.get(nuevoProductoDeOportunidad.categoria);
		Decimal cantidadDisponible = unidadPorCantidad.get(this.nuevoProductoDeOportunidad.unidade);
		Decimal totalEnPortal = 0;
		if(!this.listaDeNuevosProductosDeOportunidad.isEmpty()) {
			for(aAppendix.myOppItem item : this.listaDeNuevosProductosDeOportunidad) {
				if(item.variedad == this.nuevoProductoDeOportunidad.variedad && item.categoria == this.nuevoProductoDeOportunidad.categoria && item.unidade == this.nuevoProductoDeOportunidad.unidade) {
					totalEnPortal += item.amount;
				}
			}
		}
		cantidadDisponible -= totalEnPortal;
		if(cantidadDisponible < 0) {
			mensajeErrorAdicion = Label.ErrorAdicionNuevoItem;
			mensajeErrorCantidad = Label.ErrorAdicionNuevoItem;

			return false;
		}

		if(this.nuevoProductoDeOportunidad.amount > cantidadDisponible) {
			mensajeErrorCantidad = Label.errorCantidad + ' ' + cantidadDisponible;
			ret = false;
		}else if(nuevoProductoDeOportunidad.amount <= 0 || nuevoProductoDeOportunidad.amount == null) {
			mensajeErrorCantidad = Label.cantidadIgualCero;
			ret = false;
		}
        return ret; 
    }
    
    public Boolean validateRequiredFields() {
		
	
	    Boolean ret = true;
		if(String.isEmpty(nuevoProductoDeOportunidad.categoria)) {
			mensajeErrorCategoria = Label.ErrorCategoria;
			ret = false;
		}
		if(nuevoProductoDeOportunidad.amount == null || nuevoProductoDeOportunidad.amount == 0) {
			mensajeErrorCantidad = Label.cantidadIgualCero;
			ret = false;
		}

		if(nuevoProductoDeOportunidad.lote_rebajado == null || nuevoProductoDeOportunidad.lote_rebajado == '') {
			mensajeErrorLote = Label.ErrorLote;
			ret = false;
		}
		if(String.isEmpty(String.valueOf(nuevoProductoDeOportunidad.unidade))) {
			mensajeErrorUnidad = Label.ErrorUnidade;
			ret = false;
		}
        return ret;
    }
    
    public void completeAndAddItem() {
        nuevoProductoDeOportunidad.id = GuidUtil.NewGuid();
        nuevoProductoDeOportunidad.variedad_nombre = this.manejador.nombreVariedadPorId.get(variedadSeleccionada);
        nuevoProductoDeOportunidad.categoria_nombre = nombreCategoriaPorId.get(nuevoProductoDeOportunidad.categoria);	
        nuevoProductoDeOportunidad.variedad_registro = nombreRegistroVariedadPorId.get(variedadSeleccionada);
        
        listaDeNuevosProductosDeOportunidad.add(nuevoProductoDeOportunidad);
    }
    
    public void clearErrorMessages() {
        mensajeErrorCantidad = null;
        mensajeErrorCategoria = null;
        mensajeErrorVariedad = null;
		mensajeErrorLote = null;
		mensajeErrorCantidadPortal = null;
		mensajeErrorAdicion = null;
    }
    
    public void addProduct() {
        clearErrorMessages();
        if ( validateRequiredFields() && validateItemQuantity() ) {
            completeAndAddItem();
        }
    }
    
    public void removeProduct() {  
        for (Integer i = 0; i < listaDeNuevosProductosDeOportunidad.size(); i++) {
            if (listaDeNuevosProductosDeOportunidad[i].id == idItemRemover) {
				if(!listaDeNuevosProductosDeOportunidad[i].id.contains('-')) {
					listaProductosParaEliminar.add(listaDeNuevosProductosDeOportunidad[i]);
				}
				listaDeNuevosProductosDeOportunidad.remove(i);
            }
        }        	
    }
    
    public PageReference saveReembalagem() {

		if(listaDeNuevosProductosDeOportunidad.size() <= 0) {
			mensajeErrorNohayProductos = ' - Não possui produtos associados';
			return null;
		}
		mensajeErrorNohayProductos = null;

		if (validateItemQuantityOnSave() && validateLote()) {
			if(idDeReembalagemEditar != null) {
				this.manejador.actualizarReembalagem(listaDeNuevosProductosDeOportunidad,
				 idDeReembalagemEditar, sesionActiva.Marca__c, comentarioNuevaOportunidad, paraAprobacion);
			}
			else {
				this.manejador.crearReembalagem(comentarioNuevaOportunidad, sesionActiva.Marca__c, 
				cuentaActiva.Id, safraActiva, usuarioDeSitioActivo, listaDeNuevosProductosDeOportunidad, paraAprobacion);
			}
			return editCancel();   
		} 
		else {
			return null; 
		}
	}

    
    public PageReference gotoNew() {
        
        String tokenUsuarioActivo = System.currentPageReference().getParameters().get('token');
        PageReference pageRef = new PageReference('/apex/aSiteReembalagemEdit');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('token',tokenUsuarioActivo);
        
        return pageRef;
       
    }
    
    public PageReference gotoEdit() {
        String tokenUsuarioActivo = System.currentPageReference().getParameters().get('token');
        PageReference pageRef = new PageReference('/apex/aSiteReembalagemEdit');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('token',tokenUsuarioActivo);
        pageRef.getParameters().put('e',idDeReembalagemEditar);
        
        return pageRef;
    }
    
    public PageReference editCancel() {
        PageReference pr = new PageReference('/apex/aSiteReembalagem');
        pr.setRedirect(true);
        pr.getParameters().put('token', tokenUsuarioActivo);
        return pr; 
    }

    public List<SelectOption> getUnidades() {
        List<SelectOption> listUnidades = new List<SelectOption>();
		if(!String.isEmpty(this.variedadSeleccionada)) {
			Set<String> unidadesDeVariedad = this.manejador.mapaUnidadesProductos.get(this.variedadSeleccionada);
			for(String unidad : unidadesDeVariedad) {
				listUnidades.add(new SelectOption(unidad, unidad));
			}
		}
        return listUnidades;    
	}
}
global without sharing class aSiteDescarteController {
    
    private Map<String,Id> tipoRegistroPorNombre;
    private Map<String,String> tipoRegistroPorNombreDesarrollador;
    public String lenguajeUsuario {get; set;}
    public String language {get; set;}

    public String tituloDePagina {get; set;}
    
    public String tokenUsuarioActivo {get; set;} 
    public SiteUser__c usuarioDeSitioActivo {get; set;}
    public SiteUserSession__c sesionActiva {get; set;}
    public Account cuentaActiva {get; set;}
    public String safraActiva {get; set;}
    
    public List<Opportunity> listaDeOportunidades {get; set;}
    public List<OpportunityLineItem> productosDeOportunidadSeleccionada {get; set;}
    public String idDeDescarteSeleccionado {get;set;}
    public String idDeDescarteEditar {get;set;}
    public String editId {get;set;}

    public Map<String,String> nombreVariedadPorId;
    public Map<String,String> nombreRegistroVariedadPorId;
    public Map<String,String> nombreCategoriaPorId;
    public Map<String, Set<String>> categoriasPorVariedad {get; set;}
    
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
	public String mensajeErrorAdicion {get;set;}
	public String mensajeErrorCantidadPortal {get;set;}

	private Boolean descartesCargados {get;set;}
    
    public String pdfBlob {get; set;}
    public String nombrePDF {get; set;}
    public String idOportunidadImprimir {get; set;}
    public List<aAppendix.myOppItem> listaProductosParaEliminar {get; set;}

	public ManejadorDescarte manejador {get;set;}
	private FactoryManejador factory;
    
    global aSiteDescarteController() {
        listaDeNuevosProductosDeOportunidad = new List<aAppendix.myOppItem>();
        nombreVariedadPorId = New Map<String, String>();
        listaDeOportunidades =  new List<Opportunity>();
        nombreCategoriaPorId = new Map<String,String>();
        categoriasPorVariedad = new Map<String, Set<String>>();
        nuevoProductoDeOportunidad = new aAppendix.myOppItem();
		listaProductosParaEliminar = new List<aAppendix.myOppItem>();
        nombreRegistroVariedadPorId = new Map<String, String>();
        this.descartesCargados = true;
		this.factory = new FactoryManejador();
        
        tipoRegistroPorNombre = Opp_Utils.cargarRecordTypesOportunidades();
        lenguajeUsuario = [SELECT id, LanguageLocaleKey 
                            FROM User 
                            WHERE id = :UserInfo.getUserId()].LanguageLocaleKey;
        
        language = lenguajeUsuario;

        tipoRegistroPorNombreDesarrollador = Opp_Utils.cargarRecordTypesOppbyDevName();
        tituloDePagina = tipoRegistroPorNombreDesarrollador.get('Descarte');
        idDeDescarteEditar = System.currentPageReference().getParameters().get('e');
        editId = idDeDescarteEditar;
		mensajeErrorCantidad = null;
		mensajeErrorCategoria = null;
		mensajeErrorVariedad = null;
		mensajeErrorAdicion = null;
    }
    
    public PageReference validate() {  
        tokenUsuarioActivo = System.currentPageReference().getParameters().get('token');
        if(!String.isEmpty(tokenUsuarioActivo)) {
            usuarioDeSitioActivo = aSiteAuthManager.VerifyUserSession(tokenUsuarioActivo);
            if(usuarioDeSitioActivo!=null) {
                sesionActiva = aSiteAuthManager.getUserSession(tokenUsuarioActivo);
                cuentaActiva = aSiteAuthManager.getActiveAccount_byUser(usuarioDeSitioActivo);
                safraActiva = aAppManager.getSafraActualByApp('Descarte');
				this.manejador = (ManejadorDescarte) factory.devuelveManejador('Descarte', cuentaActiva.Id, safraActiva, sesionActiva.Marca__c);
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
    
    public void getPdfUrl() {
        List<Attachment> pdfs = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId = :idOportunidadImprimir];
       	Opportunity opp = [SELECT Id, Name, Marca__c FROM Opportunity WHERE Id = :idOportunidadImprimir LIMIT 1];
        String expectedName = opp.Name + '_' + opp.Marca__c + '_autorizacao_descarte.pdf';
        String expectedName2 = opp.Name + '_' + opp.Marca__c + '_autorization.pdf';
        for (Attachment tmpPdf :pdfs) {
            if (tmpPdf.Name == expectedName || tmpPdf.Name == expectedName2) {
                nombrePDF = tmpPdf.Name;
                pdfBlob = EncodingUtil.base64Encode(tmpPdf.Body);
                break;
            }
        }
    }


    public List<Opportunity> getDescarteOpportunities() {
        if (listaDeOportunidades.isEmpty()) {
            listaDeOportunidades = this.manejador.obtenerOportunidadesDescarte(cuentaActiva.Id, safraActiva, sesionActiva.Marca__c);
            if (!listaDeOportunidades.isEmpty()) {
                idDeDescarteSeleccionado = listaDeOportunidades[0].Id;
            }
            getProductsForSelectedDescarteOpportunity();
        } 
		for(Opportunity op : listaDeOportunidades) {
			if(op.tienePdf__c) {
				op.VB_Recebeu__c = true;
			}
		}
        return listaDeOportunidades;
    }
    
    public void getProductsForSelectedDescarteOpportunity() {
        productosDeOportunidadSeleccionada = this.manejador.obtenerProductosOportunidad(idDeDescarteSeleccionado);
    }
    
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.OpportunityLineItem.FieldSets.Anexo_Descarte.getFields();
    }
    
    public aAppendix.myOppItem getNewOppLineItem() {
        aAppendix.myOppItem  oli = new aAppendix.myOppItem();
        nuevoProductoDeOportunidad = oli;
        return nuevoProductoDeOportunidad;
    }
    
    public List<aAppendix.myOppItem> getOppLineItem() {
        List<aAppendix.myOppItem> listToReturn = new List<aAppendix.myOppItem>();
        Map<String, Integer> mapaUnidadesDescarte = new Map<String, Integer>();
		mapaUnidadesDescarte.put('Quilograma', 1);
		mapaUnidadesDescarte.put('Saca 25Kg', 25);
		mapaUnidadesDescarte.put('Saca 40Kg', 40);
		mapaUnidadesDescarte.put('Tonelada', 1000);
        if (!String.isEmpty(idDeDescarteEditar) && listaDeNuevosProductosDeOportunidad.isEmpty() && listaProductosParaEliminar.isEmpty()) {
                comentarioNuevaOportunidad = [SELECT Id, Comentarios__c 
                              FROM Opportunity 
                              WHERE Id = :idDeDescarteEditar LIMIT 1].Comentarios__c; 
            
                List<OpportunityLineItem> tmpOlisList = this.manejador.obtenerProductosOportunidad(idDeDescarteEditar);
            
                for (OpportunityLineItem tmpOLI : tmpOlisList) {
					if(tmpOLI.Id != idItemRemover) {
						aAppendix.myOppItem customOli = new aAppendix.myOppItem();
						customOli.variedad = tmpOLI.PricebookEntry.Product2.Variedade__c;
						customOli.variedad_nombre = tmpOLI.Variedade_Prod__c;
						customOli.categoria = tmpOLI.Categoria__c;
						customOli.categoria_nombre = tmpOli.Categoria__r.Name;
						customOli.amount = tmpOLI.Quantity;
						customOli.unidadDescarte = mapaUnidadesDescarte.get(tmpOLI.Unidade_descarte__c);
						customOli.unidade = tmpOLI.Unidade_descarte__c;
						customOli.unidade_nombre = tmpOLI.Unidade_descarte__c;
						customOli.lote_rebajado = tmpOLI.Lote_Rebajado__c;
						customOli.id = tmpOLI.Id;
						listaDeNuevosProductosDeOportunidad.add(customOli);
					}
                }
            } 
        
        return listaDeNuevosProductosDeOportunidad;
    }
    
    public List<SelectOption> getVariedadesNewDescarte() {
		List<SelectOption> opciones = new List<SelectOption>();
		Set<String> idsVariedad = this.manejador.nombreVariedadPorId.keySet();
		for(String variedad : idsVariedad) {
			opciones.add(new SelectOption(variedad, this.manejador.nombreVariedadPorId.get(variedad)));
		}
		return opciones;
}
    
    public void setSelectedVariedad() {
        variedadSeleccionada = nuevoProductoDeOportunidad.variedad ;
		mensajeErrorVariedad = null;
    }
    public void clearError() {
		mensajeErrorCategoria = null;
	}


    public List<SelectOption> getCategoriaNewDescarte() {
        List<SelectOption> categoriesList = new List<SelectOption>();
        
        if (!String.isEmpty(variedadSeleccionada)) {
            Set<String> categoriesForSelectedVariedad = this.manejador.categoriasPorVariedad.get(this.manejador.nombreVariedadPorId.get(variedadSeleccionada));          
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
    
    public List<SelectOption> getUnidadesNewDescarte() {
        List<SelectOption> listUnidades = new List<SelectOption>();
        listUnidades.add(new SelectOption('1', 'Quilograma'));
        listUnidades.add(new SelectOption('25', 'Saca 25Kg'));
        listUnidades.add(new SelectOption('40', 'Saca 40Kg'));
        listUnidades.add(new SelectOption('1000', 'Tonelada'));
        return listUnidades;
	}
    
	/**
		Al guardar una Oportunidad hay que validar que las cantidades ingresadas en el la lista de productos del Portal no exceda el total disponible.
		Por ejemplo, cuando se edita una Oportunidad y se modifica una cantidad ya ingresada, hay que validar que esa cantidad no exceda el limite.
		En caso de que exceda se muestra un mensaje de error indicando Variedad + Categoria + volumen maximo disponible
	**/

    public Boolean validateItemQuantityOnSave() { 

        Boolean ret = true;

		if(listaDeNuevosProductosDeOportunidad.size() == 0) { 
			return ret;
		}
		Map<String, Decimal> mapaCantidadDisponible = new Map<String, Decimal>();
		Map<String, Decimal> mapaCantidadIngresada = new Map<String, Decimal>();

		Map<String, Map<String, Decimal>> amountByCategoriaByVariedad = this.manejador.calcularVolumenDisponible();
		
		System.debug(listaDeNuevosProductosDeOportunidad);

		for(aAppendix.myOppItem item : this.listaDeNuevosProductosDeOportunidad) {
			System.debug(item);
			Map<String, Decimal> mapaCategoria = amountByCategoriaByVariedad.get(item.variedad);
			Decimal cantidad = mapaCategoria.get(item.categoria);

			if(!mapaCantidadDisponible.containsKey(item.variedad + '-' + item.categoria + '-' + item.unidade)) {
				mapaCantidadDisponible.put(item.variedad + '-' + item.categoria + '-' + item.unidade, cantidad / Integer.valueOf(item.unidadDescarte));
				mapaCantidadIngresada.put(item.variedad + '-' + item.categoria + '-' + item.unidade, 0);
			}

			Decimal cant = mapaCantidadIngresada.get(item.variedad + '-' + item.categoria + '-' + item.unidade);
			mapaCantidadIngresada.put(item.variedad + '-' + item.categoria + '-' + item.unidade, cant + item.amount );
		}


        for (aAppendix.myOppItem tmpOli : listaDeNuevosProductosDeOportunidad) {
			Decimal disponible = mapaCantidadDisponible.get(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade);
			Decimal enPortal = mapaCantidadIngresada.get(tmpOli.variedad + '-' + tmpOli.categoria + '-' + tmpOli.unidade);
			if(enPortal > disponible) {
           		String errorCant = 'O quantidade total da variedade ' + tmpOli.variedad_nombre + ' categoria ' + tmpOli.categoria_nombre + ' e pela unidade ' + tmpOli.unidade_nombre + ' não deve ser maior que ' + disponible;  //QUANTITY EXCEEDS
				ret = false;
				mensajeErrorCantidadPortal = errorCant;
				break;
			} else if (disponible <= 0 || enPortal <= 0) {
           		String error = Label.cantidadIgualCero;
				tmpOli.error_msg = error;
				ret = false;
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
			}
		}
		return resp;
	}
    
    public Boolean validateItemQuantity() {

		//Validamos para no cargar dos veces los mismos productos
		if(this.descartesCargados) {
			this.manejador.cargarProductos(new String[] {'Descarte'}, this.cuentaActiva.Id, this.safraActiva, this.sesionActiva.Marca__c);
			this.descartesCargados = false;
		}
		this.manejador.setearMapas();

		Map<String, Map<String, Decimal>> amountByCategoriaByVariedad = this.manejador.calcularVolumenDisponible();
		if(amountByCategoriaByVariedad.size() == 0) {
			return false;
		}

		Map<String, Decimal> amountByCategoria = amountByCategoriaByVariedad.get(variedadSeleccionada);
        Decimal availableAmount = amountByCategoria.get(nuevoProductoDeOportunidad.categoria);
        Decimal amountToAdd = nuevoProductoDeOportunidad.amount * Integer.valueOf(nuevoProductoDeOportunidad.unidade);
        Boolean ret = true;
        Decimal totalEnPortal = 0;
		for(aAppendix.myOppItem item : this.listaDeNuevosProductosDeOportunidad) {
			if(item.variedad == this.nuevoProductoDeOportunidad.variedad && item.categoria == this.nuevoProductoDeOportunidad.categoria) {
				totalEnPortal += item.amount * Integer.valueOf(item.unidadDescarte);
			}
		}
		availableAmount -= totalEnPortal;
		if(availableAmount < 0) {
			mensajeErrorAdicion = Label.ErrorAdicionNuevoItem;
			return false;
		}

        if (amountToAdd > availableAmount) {
            ret = false;
            Decimal availableAmountForThatKg = availableAmount / Integer.valueOf(nuevoProductoDeOportunidad.unidade) ;

			string tipoUnidad = '';

			if(nuevoProductoDeOportunidad.unidade == '1' ) {
				tipoUnidad = 'KG';
			}
			if(nuevoProductoDeOportunidad.unidade == '25' ) {
				tipoUnidad = 'Saca 25KG';
			}
			if(nuevoProductoDeOportunidad.unidade == '40' ) {
				tipoUnidad = 'Saca 40KG';
			}
			if(nuevoProductoDeOportunidad.unidade == '1000' ) {
				tipoUnidad = 'Tonelada';
			}

            mensajeErrorCantidad = Label.errorCantidad + ' ' +  availableAmountForThatKg + ' ' + tipoUnidad;  
        } else if (amountToAdd <= 0) {
            ret = false;
            mensajeErrorCantidad = Label.cantidadIgualCero;
        } else if( amountToAdd == null) { 
            ret = false;
            mensajeErrorCantidad = Label.cantidadIgualCero;
        }
        
        return ret;     
    }
    
    public Boolean validateRequiredFields() {
        Boolean ret = true;
		System.debug(nuevoProductoDeOportunidad.amount);
		if(String.isEmpty(nuevoProductoDeOportunidad.categoria)) {
			mensajeErrorCategoria = Label.ErrorCategoria;
			ret = false;
		}
		if(String.isEmpty(nuevoProductoDeOportunidad.variedad)) {
			mensajeErrorVariedad = Label.ErrorVariedad;
			ret = false;
		}
		if(String.isEmpty(String.valueOf(nuevoProductoDeOportunidad.amount))) {
			mensajeErrorCantidad = Label.cantidadIgualCero;
			ret = false;
		}
		if(String.isEmpty(String.valueOf(nuevoProductoDeOportunidad.lote_rebajado))) {
			mensajeErrorLote = Label.ErrorLote;
			ret = false;
		}
        return ret;
    }
    
    public void completeAndAddItem() {
        Map<String, String> mapaUnidadesDescarte = new Map<String, String>();
		mapaUnidadesDescarte.put('1', 'Quilograma');
		mapaUnidadesDescarte.put('25', 'Sacas 25Kg');
		mapaUnidadesDescarte.put('40', 'Sacas 40Kg');
		mapaUnidadesDescarte.put('1000', 'Tonelada');
        nuevoProductoDeOportunidad.id = GuidUtil.NewGuid();
        nuevoProductoDeOportunidad.variedad_nombre = this.manejador.nombreVariedadPorId.get(variedadSeleccionada);
        nuevoProductoDeOportunidad.categoria_nombre = nombreCategoriaPorId.get(nuevoProductoDeOportunidad.categoria);	
        nuevoProductoDeOportunidad.variedad_registro = nombreRegistroVariedadPorId.get(variedadSeleccionada);
        nuevoProductoDeOportunidad.unidadDescarte = Integer.valueOf(nuevoProductoDeOportunidad.unidade);
		nuevoProductoDeOportunidad.unidade_nombre = mapaUnidadesDescarte.get(nuevoProductoDeOportunidad.unidade);
        listaDeNuevosProductosDeOportunidad.add(nuevoProductoDeOportunidad);
		this.nuevoProductoDeOportunidad = new aAppendix.myOppItem();
    }
    
    public void clearErrorMessages() {
        mensajeErrorCantidad = null;
        mensajeErrorCategoria = null;
        mensajeErrorVariedad = null;
		mensajeErrorLote = null;
    }
    
    public void addProduct() {
        if ( validateRequiredFields() && validateItemQuantity() ) {
            completeAndAddItem();
            clearErrorMessages();
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
    
    public PageReference saveDescarte() {
        if (validateItemQuantityOnSave() && validateLote() ) {
            this.manejador.crearDescarte(paraAprobacion, idDeDescarteEditar, listaDeNuevosProductosDeOportunidad, comentarioNuevaOportunidad, sesionActiva.Marca__c, cuentaActiva.Id, safraActiva, usuarioDeSitioActivo, listaProductosParaEliminar);
        	return editCancel();   
        } else {
            return null; 
        }
    }
    
    public PageReference gotoNew() {
        Boolean anexoII = aAppManager.existeAnexoII(cuentaActiva.Id, safraActiva, sesionActiva.Marca__c);
		Boolean anexoIV = aAppManager.existeAnexoIV(cuentaActiva.Id, safraActiva, sesionActiva.Marca__c);
        
        if (anexoII && anexoIV) {        
            String tokenUsuarioActivo = System.currentPageReference().getParameters().get('token');
            PageReference pageRef = new PageReference('/apex/aSiteDescarteEdit');
            pageRef.setRedirect(true);
            pageRef.getParameters().put('token',tokenUsuarioActivo);
            
            return pageRef;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,aSiteUtils.procesarAlerta(Label.Anexo_Descarte_Val_New_Anexo)));
            return null;
        }
    }
    
    public PageReference gotoEdit() {
        String tokenUsuarioActivo = System.currentPageReference().getParameters().get('token');
        PageReference pageRef = new PageReference('/apex/aSiteDescarteEdit');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('token',tokenUsuarioActivo);
        pageRef.getParameters().put('e',idDeDescarteEditar);
        
        return pageRef;
    }
    
    public PageReference editCancel() {
        PageReference pr = new PageReference('/apex/aSiteDescarte');
        pr.setRedirect(true);
        pr.getParameters().put('token', tokenUsuarioActivo);
        return pr; 
    }
}
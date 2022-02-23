public class ManejadorAnexoI extends ManejadorProductos  {

	public Map<String, Set<String>> mapaRebajaCategorias {get;set;}
	public Map<String, List<String>> mapaCategoriaOriginal {get;set;}
	public Map<String, String> mapaCategoriaSiguiente {get;set;}
	public Map<String, String> mapaItemContrato {get;set;}
	public List<Item_del_Contrato__c> listaItems {get;set;}

	public Map<String, String> mapaNombreIdCategoria {get;set;}
	public Map<String, String> mapaCategorias {get;set;}
	public List<String> mapaCategoriasOrder {get;set;}

	public ManejadorAnexoI() {
		super();
		
		this.mapaCategoriaOriginal = new Map<String, List<String>>();
		this.mapaRebajaCategorias = new Map<String, Set<String>>();
		this.mapaCategoriaSiguiente = new Map<String, String>();
		this.mapaItemContrato = new Map<String, String>();
		this.mapaNombreIdCategoria = new Map<String, String>();
		this.mapaCategorias = new Map<String, String>();
		this.mapaCategoriasOrder = new List<String>();
		
		this.mapaRebajaCategorias.put('PREBA', new Set<String>{'C1', 'C2', 'S1', 'S2'});
		this.mapaRebajaCategorias.put('GENETICA', new Set<String>{'C1', 'C2', 'S1', 'S2'});
		this.mapaRebajaCategorias.put('BASICA', new Set<String>{'C1', 'C2', 'S1', 'S2'});
		this.mapaRebajaCategorias.put('C1', new Set<String>{'C2', 'S1', 'S2'}); 
		this.mapaRebajaCategorias.put('C2', new Set<String>{'S1', 'S2'});
		this.mapaRebajaCategorias.put('S1', new Set<String>{'S2'});
		this.mapaRebajaCategorias.put('S2', new Set<String>{});
				

		this.mapaCategoriaSiguiente.put('BASICA', 'C1');
		this.mapaCategoriaSiguiente.put('C1', 'C2');
		this.mapaCategoriaSiguiente.put('C2', 'S1');
		this.mapaCategoriaSiguiente.put('S1', 'S2');
		
		List<Categoria__c> categorias = [SELECT Id, Name FROM Categoria__c];
		for(Categoria__c categoria : categorias)
			mapaCategorias.put(categoria.Name, categoria.Id);
			
		mapaCategoriasOrder = new List<String>{'PREBA', 'GENETICA', 'BASICA', 'C1', 'C2', 'S1', 'S2'};
		
	}

	public override void setearMapas() {
		
		for (Integer i = 0; i < this.listaProductos.size(); i++) {
			String tmpVarietyId = this.listaProductos[i].PricebookEntry.Product2.Variedade__c;
			String tmpVarietyName = this.listaProductos[i].PricebookEntry.Product2.Variedade__r.Name;
			String tmpVarietyRegisterName = this.listaProductos[i].PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c;
			String tmpCategoryName;

			if(this.mapaItemContrato.containsKey(this.listaProductos[i].PricebookEntry.Product2.Variedade__r.Name)) {
	
				List<String> catOrigs = new List<String>(); 
				if(!this.mapaCategoriaOriginal.containsKey(tmpVarietyId))					
					this.mapaCategoriaOriginal.put(tmpVarietyId, catOrigs);
				else
					catOrigs = this.mapaCategoriaOriginal.get(tmpVarietyId);
				
				if(!catOrigs.contains(this.listaProductos[i].Categoria__r.Name))
				{
					Integer catOrder = mapaCategoriasOrder.indexOf(this.listaProductos[i].Categoria__r.Name);
					for(Integer j = 0; j < catOrigs.size(); j++)
					{
						if(catOrder < mapaCategoriasOrder.indexOf(catOrigs[j]))
						{
							catOrder = j;
							break;
						}
					}
					if(catOrder < catOrigs.size())
						catOrigs.add(catOrder, this.listaProductos[i].Categoria__r.Name);
					else
						catOrigs.add(this.listaProductos[i].Categoria__r.Name);
							
				}
				
				if (!tmpvarietyNameById.containsKey(tmpVarietyId)) { 

					Set<String> categoriesForVariety  = new Set<String>();
					if(mapaRebajaCategorias.get(this.listaProductos[i].Categoria__r.Name) != null) {
						categoriesForVariety.addAll(this.mapaRebajaCategorias.get(this.listaProductos[i].Categoria__r.Name));
					}
					categoriasPorVariedad.put(tmpVarietyName, categoriesForVariety);
					tmpvarietyNameById.put(tmpVarietyId, tmpVarietyName);
					nombreRegistroVariedadPorId.put(tmpVarietyId, tmpVarietyRegisterName);                 
					nombreVariedadPorId.put(tmpVarietyId, tmpVarietyName);
				}
			}

			//Llenamos el mapa de categorias
			if(!this.mapaNombreIdCategoria.containsKey(this.listaProductos[i].Categoria__c)) {
				this.mapaNombreIdCategoria.put(this.listaProductos[i].Categoria__r.Name, this.listaProductos[i].Categoria__c);
			}
		}
		
	}

	//Revisar los campos de los OpportunityLineItems para ver cuál se usa para la cantidad para cada tipo de Oportunidad. Y tambien la unidad en que vienen esas cantidades (bolsas de 40 kg, 1000 kg etc)

	//Para el Portal de Anexo I
	public void sacarVariedadesRebajadas() {
		
		List<OpportunityLineItem> productosAnexoIIRebaja = new List<OpportunityLineItem>();
		List<OpportunityLineItem> productosAnexoII = new List<OpportunityLineItem>();
		List<OpportunityLineItem> productosDescarte = new List<OpportunityLineItem>();
		List<OpportunityLineItem> productosCVB = new List<OpportunityLineItem>();
		List<OpportunityLineItem> productosAST = new List<OpportunityLineItem>();

		Map<String, Map<String, Decimal>> mapaVolumenDisponible = new Map<String, Map<String, Decimal>>();
		Map<String, Decimal> productosParaEliminar = new Map<String, Decimal>();
		

		for(OpportunityLineItem producto : this.listaProductos) {
			if(producto.Opportunity.TipoReg__c == 'Anexo II Rebaixamento Sacas' && !producto.item_rebajado__c) {
				productosAnexoIIRebaja.add(producto);
				continue;
			}
			if(producto.Opportunity.TipoReg__c == 'Anexo II') {
				productosAnexoII.add(producto);
				continue;
			}
			if(producto.Opportunity.TipoReg__c == 'Descarte') {
				productosDescarte.add(producto);
				continue;
			}
			if(producto.Opportunity.TipoReg__c == 'CVB Autorizada') {
				productosCVB.add(producto);
				continue;
			}
			if(producto.Opportunity.TipoReg__c == 'Aquisição Sementes Terceiros') {
				productosAST.add(producto);
				continue;
			}
			
		}

		for(OpportunityLineItem anexoII : productosAnexoII) {
			String variedadId = String.valueOf(anexoII.PricebookEntry.Product2.Variedade__r.Name);
			if(!mapaVolumenDisponible.containsKey(variedadId)) {
                Map<String, Decimal> tmpMapCategoriaAmount = new Map<String, Decimal>();
                String tmpCategoria = String.valueOf(anexoII.Categoria__r.Name);
				Decimal tmpAmount = 0;
				if(anexoII.Semente_bruta__c != null) {
					  tmpAmount = anexoII.Semente_bruta__c; 
				}
                tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				mapaVolumenDisponible.put(variedadId, tmpMapCategoriaAmount);

			} else { 
				if(!mapaVolumenDisponible.get(variedadId).containsKey(anexoII.Categoria__r.Name)) {
					Map<String, Decimal> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadId);
					String tmpCategoria = String.valueOf(anexoII.Categoria__r.Name);
					Decimal tmpAmount = 0;
					if(anexoII.Semente_bruta__c != null) {
							tmpAmount = anexoII.Semente_bruta__c;
					}
					tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				}else {
					Map<String, Decimal> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadId);
					String tmpCategoria = String.valueOf(anexoII.Categoria__r.Name);
					Decimal tmpAmount = tmpMapCategoriaAmount.get(tmpCategoria);
					if(anexoII.Semente_bruta__c != null) {
						tmpAmount += anexoII.Semente_bruta__c;
					}
					tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				}
			}
		}		


		for(OpportunityLineItem autorizada : productosCVB) {
        	String variedadId = String.valueOf(autorizada.PricebookEntry.Product2.Variedade__r.Name);
			String categoriaId = String.valueOf(autorizada.Categoria__r.Name);

			if(!mapaVolumenDisponible.containsKey(variedadId)) {
                Map<String, Decimal> tmpMapCategoriaAmount = new Map<String, Decimal>();
                String tmpCategoria = String.valueOf(autorizada.Categoria__r.Name);
				Decimal tmpAmount = 0;
				if(autorizada.Quantity != null) {
					  tmpAmount = autorizada.Quantity; 
				}
                tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				mapaVolumenDisponible.put(variedadId, tmpMapCategoriaAmount);

			} else {
				if(!mapaVolumenDisponible.get(variedadId).containsKey(categoriaId)) {
					Map<String, Decimal> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadId);
					String tmpCategoria = String.valueOf(autorizada.Categoria__r.Name);
					Decimal tmpAmount = 0;
					if(autorizada.Quantity != null) {
							tmpAmount = autorizada.Quantity;
					}
					tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				}else {
					Map<String, Decimal> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadId);
					String tmpCategoria = String.valueOf(autorizada.Categoria__r.Name);
					Decimal tmpAmount = tmpMapCategoriaAmount.get(tmpCategoria);
					if(autorizada.Quantity != null) {
						if(tmpAmount <= 0) {
							productosParaEliminar.remove(variedadId + '-' + categoriaId);
						}
						tmpAmount += autorizada.Quantity;
					}
					tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				}
			}
		}

		for(OpportunityLineItem autorizada : productosAST) {
        	String variedadId = String.valueOf(autorizada.PricebookEntry.Product2.Variedade__r.Name);
			String categoriaId = String.valueOf(autorizada.Categoria__r.Name);

			if(!mapaVolumenDisponible.containsKey(variedadId)) {
                Map<String, Decimal> tmpMapCategoriaAmount = new Map<String, Decimal>();
                String tmpCategoria = String.valueOf(autorizada.Categoria__r.Name);
				Decimal tmpAmount = 0;
				if(autorizada.Quantity != null) {
					  tmpAmount = autorizada.Quantity; 
				}
                tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				mapaVolumenDisponible.put(variedadId, tmpMapCategoriaAmount);

			} else {
				if(!mapaVolumenDisponible.get(variedadId).containsKey(categoriaId)) {
					Map<String, Decimal> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadId);
					String tmpCategoria = String.valueOf(autorizada.Categoria__r.Name);
					Decimal tmpAmount = 0;
					if(autorizada.Quantity != null) {
							tmpAmount = autorizada.Quantity;
					}
					tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				}else {
					Map<String, Decimal> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadId);
					String tmpCategoria = String.valueOf(autorizada.Categoria__r.Name);
					Decimal tmpAmount = tmpMapCategoriaAmount.get(tmpCategoria);
					if(autorizada.Quantity != null) {
						if(tmpAmount <= 0) {
							productosParaEliminar.remove(variedadId + '-' + categoriaId);
						}
						tmpAmount += autorizada.Quantity;
					}
					tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				}
			}
		}
			
		for(OpportunityLineItem descarte : productosDescarte) {
        	String variedadId = String.valueOf(descarte.PricebookEntry.Product2.Variedade__r.Name);
            String categoriaId = String.valueOf(descarte.Categoria__r.Name);

			if(mapaVolumenDisponible.containsKey(variedadId) && mapaVolumenDisponible.get(variedadId).containsKey(categoriaId)) {
                Map<String, Decimal> tmpCategoriaAmountMap = mapaVolumenDisponible.get(variedadId);
                Decimal amountAvailable = tmpCategoriaAmountMap.get(categoriaId);
                Integer unidade = 0;
                if (descarte.Unidade_descarte__c == 'Quilograma') {
                    unidade = 1;
                }
                if (descarte.Unidade_descarte__c == 'Saca 25Kg') {
                    unidade = 25;
                }
                if (descarte.Unidade_descarte__c == 'Saca 40Kg') {
                    unidade = 40;
                }
                if (descarte.Unidade_descarte__c == 'Tonelada') {
                    unidade = 1000;
                }
                amountAvailable -=  descarte.Quantity * unidade;
				if(amountAvailable <= 0) {
					productosParaEliminar.put(String.valueOf(variedadId) + '-' + String.valueOf(categoriaId), amountAvailable);
					if(this.mapaCategoriaOriginal.containsKey(variedadId)) {
						List<String> catOrigs =  this.mapaCategoriaOriginal.get(variedadId);
						catOrigs.remove(catOrigs.indexOf(categoriaId));
					}
				}
                tmpCategoriaAmountMap.put(categoriaId, amountAvailable);
			}
		}
		
		for(OpportunityLineItem anexoRebaja : productosAnexoIIRebaja) {
			
        	String variedadRebId = String.valueOf(anexoRebaja.PricebookEntry.Product2.Variedade__r.Name);
			String variedadId = String.valueOf(anexoRebaja.PricebookEntry.Product2.Variedade__c);
            String categoriaOrig = String.valueOf(anexoRebaja.Categoria_a_Rebaixar__r.Name);
			String categoriaFinal = String.valueOf(anexoRebaja.Categoria__r.Name);
			
			//Se hace la resta del Volumen para la Variedad + Categoria rebajada
			Map<String, Decimal> tmpCategoriaAmountMap = mapaVolumenDisponible.get(variedadRebId);
			if (tmpCategoriaAmountMap != null) {
                Decimal amountAvailable = tmpCategoriaAmountMap.get(categoriaOrig);
				if(anexoRebaja.Sem_Rebajada__c != null && amountAvailable != null) {
                    amountAvailable -= anexoRebaja.Sem_Rebajada__c;
                    if(amountAvailable <= 0) {
                        productosParaEliminar.put(String.valueOf(variedadRebId) + '-' + String.valueOf(categoriaOrig), amountAvailable);
                        if(this.mapaCategoriaOriginal.containsKey(variedadId)) {
							List<String> catOrigs =  this.mapaCategoriaOriginal.get(variedadId);
							Integer indexcatOrigs = catOrigs.indexOf(categoriaOrig);
							if(indexcatOrigs > -1)
								catOrigs.remove(indexcatOrigs);
                            
                            Set<String> categoriesForVariety  = new Set<String>();
                            if(this.mapaRebajaCategorias.get(categoriaFinal) != null) {
                                categoriesForVariety.addAll(this.mapaRebajaCategorias.get(categoriaFinal));
                                categoriesForVariety.addAll(this.mapaRebajaCategorias.get(categoriaOrig));
                            }
                            this.categoriasPorVariedad.put(variedadRebId, categoriesForVariety);
                        }
                    }
                    tmpCategoriaAmountMap.put(categoriaOrig, amountAvailable);
                }
                
                //Revisamos si existe la nueva Categoria (la que sale del rebajamiento). Si existe se suma la cantidad, sino se la agrega
                if (mapaVolumenDisponible.get(variedadRebId).containsKey(categoriaFinal)) {
                    Map<String, Decimal> tmpNewCategoriaAmount = mapaVolumenDisponible.get(variedadRebId);
                    String tmpNewCat = String.valueOf(anexoRebaja.Categoria__r.Name);
                    Decimal tmpNewAmount = tmpNewCategoriaAmount.get(tmpNewCat);
                    if(anexoRebaja.Sem_Rebajada__c != null) {
                        if(tmpNewAmount <= 0) {
                            productosParaEliminar.remove(String.valueOf(variedadRebId) + '-' + String.valueOf(categoriaOrig));
                        }
                        tmpNewAmount += anexoRebaja.Sem_Rebajada__c;
                    }
                    tmpNewCategoriaAmount.put(tmpNewCat, tmpNewAmount);
                } else {
                    Map<String, Decimal> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadRebId);
                    String tmpCategoria = String.valueOf(categoriaFinal);
                    Decimal tmpAmount = 0;
                    if(anexoRebaja.Sem_Rebajada__c != null) {
                        tmpAmount = anexoRebaja.Sem_Rebajada__c;
                    }
                    tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
                }
                
            }
		}
		
		System.debug(mapaVolumenDisponible);

		//Se buscan las Variedades que fueron rebajadas al 100% para sacarlas de los mapas
		System.debug('Antes ' + this.categoriasPorVariedad);
		for(String producto : productosParaEliminar.keySet()) {
			List<String> separador = producto.split('-', 2);  //El primer elemento es la Variedad, el segundo la Categoria
			if(this.categoriasPorVariedad.containsKey(separador[0])) {
				Set<String> categorias = new Set<String>(); 
				categorias = this.categoriasPorVariedad.get(separador[0]);				
				categorias.remove(this.mapaCategoriaSiguiente.get(separador[1]));
				categoriasPorVariedad.put(separador[0], categorias);
			}
		}
		
		//Se eliminan todos los producstos sin categorias o solo s2
		for(String variedad : mapaCategoriaOriginal.keySet())
		{
			List<String> catOrigs = mapaCategoriaOriginal.get(variedad);
			if(catOrigs.contains('S2'))
			if(catOrigs.size() == 1)
				nombreVariedadPorId.remove(variedad);
			else
				catOrigs.remove(catOrigs.indexOf('S2'));
			
			if(catOrigs.contains('PREBA'))
			{			
				catOrigs.remove(catOrigs.indexOf('PREBA'));
				if(!catOrigs.contains('GENETICA'))
					catOrigs.add('GENETICA');
			}
				
		}
		
		System.debug('Desp ' + this.categoriasPorVariedad);
	}
	
	public  List<OpportunityLineItem> obtenerProductosOportunidad(Id oppId) {
        List<OpportunityLineItem> queryResult = [
            SELECT Id, PricebookEntry.Product2.Variedade__c,
				PricebookEntry.Product2.Variedade__r.Name, 
				PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c, 
				PricebookEntry.Product2.UNIDADE__c, Area__c, Estado_de_Produccion__r.Name,
				Categoria__r.Name, Quantity, Lote_Rebajado__c, Categoria_a_Rebaixar__c,
				Categoria__c, Categoria_Prod__c, Unidade_descarte__c, Categoria_a_Rebaixar__r.Name,
				UNIDADE__c, Variedade_Prod__c, Variedad_de_Produto__c, Expec_Prod_Bruta__c, Semente_comercializada__c 
            FROM   OpportunityLineItem d
            WHERE  OpportunityId = :oppId
        ];
        return queryResult; 
    }


	public Opportunity crearOportunidadAnexoI(String marca, String activeAccountId, String activeSafra, SiteUser__c activeSiteUser,
													 String paraAprobacion, List<aAppendix.myOppItem> itemsParaAgregar, aAppendix.oppWrapper oportunidadWrapper, String[] estados ) {

		Map<String, String> anexoUno = Opp_Utils2.cargarRecordTypesOportunidades(); 
        String AnexoIRecordTypeId = anexoUno.get('AnexoI');
		Pricebook2 listaStandard = [
			SELECT Id, Name
			FROM Pricebook2
			WHERE Name = 'Lista de precios estándar'
		];
		List<PricebookEntry> precioItem = [
			SELECT Id, Product2.Variedade__c, Product2.Categ__r.Name, Product2.Family
			FROM PricebookEntry
			WHERE Pricebook2.Name  =: listaStandard.Name
				AND Product2.Categ__r.Name = 'BASICA'
				AND Product2.Family = 'Royalty x Basica'
		];

		Map<String, PricebookEntry> mapaVariedadPrecio = new Map<String, PricebookEntry>();

		for(PricebookEntry precio : precioItem) {
			mapaVariedadPrecio.put(precio.Product2.Variedade__c, precio);
		}

		String correoSiteUser = [
						SELECT Email__c 
						FROM SiteUser__c 
						WHERE Id =: activeSiteUser.id 
						LIMIT 1
					].Email__c;

		Opportunity nuevaOportunidad = new Opportunity();
        nuevaOportunidad.Name = 'ANEXO I';
       	nuevaOportunidad.Pricebook2Id = listaStandard.id;
        nuevaOportunidad.StageName = 'Edición';
		nuevaOportunidad.Epoca_de_Plantio__c = 'Verão';
        nuevaOportunidad.RecordTypeId = AnexoIRecordTypeId;
        nuevaOportunidad.AccountId = activeAccountId;
        nuevaOportunidad.Safra__c = activeSafra;
        nuevaOportunidad.Marca__c = marca;
        nuevaOportunidad.Usuario__c = activeSiteUser.Id;
        nuevaOportunidad.CloseDate = System.today();
		nuevaOportunidad.Cooperante__c = oportunidadWrapper.idCooperador;
		nuevaOportunidad.Epoca_de_Plantio__c = oportunidadWrapper.epocaPlantacion;
		nuevaOportunidad.CNPJ_CPF_Anexo__c = oportunidadWrapper.cnpj;
		nuevaOportunidad.Estados_Comercializacion__c = this.devuelveEstadosComercializacion(estados);
		nuevaOportunidad.Renasem_Produtor__c = oportunidadWrapper.renasem;
		nuevaOportunidad.CorreoElectronicoSiteUser__c = correoSiteUser;

		insert nuevaOportunidad;
		if(paraAprobacion == '1') {
			nuevaOportunidad = [SELECT OwnerId FROM Opportunity WHERE ID =: nuevaOportunidad.Id];
			aAppManager.enviarParaAprobacion(nuevaOportunidad);
		}

		List<OpportunityLineItem> productosAgregar = new List<OpportunityLineItem>();
		for(aAppendix.myOppItem item : itemsParaAgregar) {
			OpportunityLineItem producto = aAppendix.myOppItem.armarLineItem(item);
			producto.OpportunityId = nuevaOportunidad.Id;
			producto.PricebookEntryId = mapaVariedadPrecio.get(producto.Variedad__c).Id;

			productosAgregar.add(producto);
		}
		insert productosAgregar;
		return nuevaOportunidad;
	}

	public void actualizarOportunidadAnexoi(String marca, String activeAccountId, String activeSafra, SiteUser__c activeSiteUser,
													 String paraAprobacion, List<aAppendix.myOppItem> itemsParaAgregar, String idOportunidad, aAppendix.oppWrapper oportunidadWrapper, String[] estados) {
		Opportunity oportunidadEditar = [
			SELECT Id, Pricebook2ID, OwnerId
			FROM Opportunity
			WHERE ID =: idOportunidad
		];
		String estadosComercializacion = '';
		for(String est : estados) {
			estadosComercializacion += est + ';';
		}
		estadosComercializacion.removeEnd(';');
		oportunidadEditar.Cooperante__c = oportunidadWrapper.idCooperador;
		oportunidadEditar.Estados_Comercializacion__c = estadosComercializacion;
		oportunidadEditar.CNPJ_CPF_Anexo__c = oportunidadWrapper.cnpj;
		oportunidadEditar.Epoca_de_Plantio__c = oportunidadWrapper.epocaPlantacion;

		update oportunidadEditar;

		Pricebook2 preciosOportunidad = [
			SELECT Id, Name
			FROM Pricebook2
			WHERE Id =: oportunidadEditar.Pricebook2Id
		];

		List<PricebookEntry> precioItem = [
			SELECT Id, Product2.Variedade__c, Product2.Categ__r.Name, Product2.Family
			FROM PricebookEntry
			WHERE Pricebook2.Name  =: preciosOportunidad.Name
			AND Product2.Categ__r.Name = 'BASICA'
			AND Product2.Family = 'Royalty x Basica'
		];
		
		Map<String, PricebookEntry> mapaVariedadPrecio = new Map<String, PricebookEntry>();

		for(PricebookEntry precio : precioItem) {
			mapaVariedadPrecio.put(precio.Product2.Variedade__c, precio);
		}
		if(paraAprobacion == '1') {
			aAppManager.enviarParaAprobacion(oportunidadEditar);
		}
		List<OpportunityLineItem> borrar = this.obtenerProductosOportunidad(idOportunidad);
		delete borrar;
		List<OpportunityLineItem> productosAgregar = new List<OpportunityLineItem>();
		for(aAppendix.myOppItem item : itemsParaAgregar) {
			System.debug(item.estadoProduccion_nombre);
			OpportunityLineItem producto = aAppendix.myOppItem.armarLineItem(item);
			producto.OpportunityId = idOportunidad;
			producto.PricebookEntryId = mapaVariedadPrecio.get(producto.Variedad__c).Id;

			productosAgregar.add(producto);
		}
		insert productosAgregar;
	}

	private String devuelveEstadosComercializacion(String[] estados) {
		String retorno = '';
		for(String estado : estados) {
			retorno += estado +';';
		}
		retorno = retorno.removeEnd(';');
		return retorno;
	}

	public void cargarItemsContrato(String accountid, String safra, String marca) {


		List<Item_deL_contrato__c> listaItems = new List<Item_del_Contrato__c>();
		listaItems = [
			SELECT Cultivar__c, Id, Variedad__r.Name, Categoria__r.Name, Contrato_de_Multiplicacion__c, Categoria__c
			FROM Item_del_Contrato__c 
			WHERE Contrato_de_Multiplicacion__r.Multiplicador__c = : accountid 
			AND Contrato_de_Multiplicacion__r.Safra__c = : safra 
			AND Contrato_de_Multiplicacion__r.Sociedad__c = : marca
			AND Cultivar__c != null
			AND (Contrato_de_Multiplicacion__r.Chegou_na_Brasmax__c = true
			OR Contrato_de_Multiplicacion__r.Estado__c = 'Chegou')
		];

		for (Item_del_Contrato__c itmContrato : listaItems) {
			System.debug('nombre en item ' + itmContrato.Variedad__r.Name);
			this.mapaItemContrato.put(itmContrato.Variedad__r.Name, itmContrato.Contrato_de_Multiplicacion__c);
		}
	}
}
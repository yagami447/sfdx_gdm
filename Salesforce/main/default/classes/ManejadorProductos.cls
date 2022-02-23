public virtual class ManejadorProductos  {

	public Map<Id, String> tmpvarietyNameById {get;set;}
	public Map<String, Set<String>> categoriasPorVariedad {get;set;}
	public Map<String,String> nombreRegistroVariedadPorId {get;set;}
	public Map<String,String> nombreVariedadPorId {get;set;}
	public Map<String, String> mapaRebajaCategorias {get;set;}

	public List<OpportunityLineItem> listaProductos {get;set;}

	public ManejadorProductos() {
		this.tmpvarietyNameById = new Map<Id,String>();
		this.categoriasPorVariedad = new Map<String, Set<String>>();
		this.nombreRegistroVariedadPorId = new Map<String, String>();
		this.nombreVariedadPorId = new Map<String, String>();
		this.mapaRebajaCategorias = new Map<String, String>();
	}


	/** METODOS VIRTUALES **/

	public virtual void setearMapas(){}


	public virtual void procesarProductosDescarte(Map<String, Map<String, Decimal>> mapaVolumenDisponible, List<OpportunityLineItem> productosDescarte) {
		for(OpportunityLineItem descarte : productosDescarte) {
        	String variedadId = String.valueOf(descarte.PricebookEntry.Product2.Variedade__c);
            String categoriaId = String.valueOf(descarte.Categoria__c);

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
                tmpCategoriaAmountMap.put(categoriaId, amountAvailable);
				
			}
		}
	}

	public virtual void procesarProductosAnexoIIRebaxa(Map<String, Map<String, Decimal>> mapaVolumenDisponible, List<OpportunityLineItem> productosAnexoIIRebaja) {
		for(OpportunityLineItem anexoRebaja : productosAnexoIIRebaja) {
        	String variedadRebId = String.valueOf(anexoRebaja.PricebookEntry.Product2.Variedade__c);
            String categoriaRebId = String.valueOf(anexoRebaja.Categoria_a_Rebaixar__c);
			String categoriaFinal = String.valueOf(anexoRebaja.Categoria__c);

			//Se hace la resta del Volumen para la Variedad + Categoria rebajada

			Map<String, Decimal> tmpCategoriaAmountMap = mapaVolumenDisponible.get(variedadRebId);
            Decimal amountAvailable = tmpCategoriaAmountMap.get(categoriaRebId);
			if(anexoRebaja.Sem_Rebajada__c != null) {
				amountAvailable -= anexoRebaja.Sem_Rebajada__c * 40;
            }
			tmpCategoriaAmountMap.put(categoriaRebId, amountAvailable);


			//Revisamos si existe la nueva Categoria (la que sale del rebajamiento). Si existe se suma la cantidad, sino se la agrega
			if (mapaVolumenDisponible.get(variedadRebId).containsKey(categoriaFinal)) {
                Map<String, Decimal> tmpNewCategoriaAmount = mapaVolumenDisponible.get(variedadRebId);
                String tmpNewCat = String.valueOf(anexoRebaja.Categoria__c);
                Decimal tmpNewAmount = tmpNewCategoriaAmount.get(tmpNewCat);
				if(anexoRebaja.Sem_Rebajada__c != null) {
					tmpNewAmount += anexoRebaja.Sem_Rebajada__c * 40;
				}
				tmpNewCategoriaAmount.put(tmpNewCat, tmpNewAmount);
			} else {
                Map<String, Decimal> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadRebId);
                String tmpCategoria = String.valueOf(categoriaFinal);
				Decimal tmpAmount = 0;
				if(anexoRebaja.Sem_Rebajada__c != null) {
					  tmpAmount = anexoRebaja.Sem_Rebajada__c * 40;
				}
                tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
			}
		}
	}


	public virtual void cargarProductos(String[] criterios, Id idCuenta, String safra, String marca) {
        
        
		List<OpportunityLineItem> productosBasica = this.obtenerProductos(criterios, idCuenta, safra, marca, new String[] {'Aprobada','AU - Autorizada'});
        
        System.debug(productosBasica);
        
		if(!productosBasica.isEmpty()) {
			for(OpportunityLineItem item : productosBasica) {
				this.listaProductos.add(item);
			}
		}
	}

	private List<OpportunityLineItem> obtenerProductos( String[] registros, Id idCuenta, String safra, String marca, String[] stages) {
        
        
        System.debug(idCuenta);
        System.debug(safra);
        System.debug(marca);
        System.debug(registros);
        
        String queryPlus = 'PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name,' 
            +'PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c,PricebookEntry.Product2.UNIDADE__c,'
            +'PriceBookEntry.Product2.Categ__c, Categoria__r.Name, Opportunity.TipoReg__c, Categoria_a_Rebaixar__r.Name,'
            +'PriceBookEntry.PriceBook2Id, PricebookEntry.Product2.Variedad__c, PricebookEntry.Product2.Categ__r.Name ';

        return aSiteUtils.queryResults5(
            OpportunityLineItem.SObjectType, queryPlus,
            'Opportunity.AccountId = :v1', idCuenta, 
            'Opportunity.TipoReg__c in :v2', registros,
            'Opportunity.Safra__c = :v3', safra,
            'Opportunity.Marca__c = :v4', marca,
            'Opportunity.StageName = :v5', stages
        );
    }
}
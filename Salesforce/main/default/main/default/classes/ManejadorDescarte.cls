public class ManejadorDescarte extends ManejadorProductos  {



	/**
	* @author 
		Gaston Doval
	* @description 
		Recorre cada una de las listas de OpportunityLineItems de los distintos tipos de Oportunidad y, por cada uno, calcula el stock disponible 
		según la Variedad y Categoría de cada Producto. Retorna un Map donde la primer key es el tipo de Variedad y el valor otro Map, donde se guarda
		la Categoría (key) y el volumen total disponible (value). Los volumenes son multiplican por 40 dado que esa es la unidad en la que están cargados
		los Productos (1 bolsa = 40 Kg), con la excepcion de los Productos de las Oportunidades de tipo Descarte.
	*/ 
	
	public Map<String, Map<String, Decimal>> calcularVolumenDisponible() {
		List<OpportunityLineItem> productosAnexoII = new List<OpportunityLineItem>();
		List<OpportunityLineItem> productosAnexoIIRebaja = new List<OpportunityLineItem>();
		List<OpportunityLineItem> productosDescarte = new List<OpportunityLineItem>();

		Map<String, Map<String, Decimal>> mapaVolumenDisponible = new Map<String, Map<String, Decimal>>();
		for(OpportunityLineItem producto : this.listaProductos) {
			System.debug( producto);
			if(producto.Opportunity.TipoReg__c == 'Descarte') {
				productosDescarte.add(producto);
			}
			if(producto.Opportunity.TipoReg__c == 'Anexo II') {
				productosAnexoII.add(producto);
			}
			if(producto.Opportunity.TipoReg__c == 'Anexo II Rebaixamento Sacas') {
				productosAnexoIIRebaja.add(producto);
			}
		}

		for(OpportunityLineItem anexoII : productosAnexoII) {
			String variedadId = String.valueOf(anexoII.PricebookEntry.Product2.Variedade__c);
			if(!mapaVolumenDisponible.containsKey(variedadId)) {
                Map<String, Decimal> tmpMapCategoriaAmount = new Map<String, Decimal>();
                String tmpCategoria = String.valueOf(anexoII.Categoria__c);
				Decimal tmpAmount = 0;
				if(anexoII.Semente_bruta__c != null) {
					  tmpAmount = anexoII.Semente_bruta__c * 40; 
				}
                tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				mapaVolumenDisponible.put(variedadId, tmpMapCategoriaAmount);

			} else { 
				if(!mapaVolumenDisponible.get(variedadId).containsKey(anexoII.Categoria__c)) {
					Map<String, Decimal> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadId);
					String tmpCategoria = String.valueOf(anexoII.Categoria__c);
					Decimal tmpAmount = 0;
					if(anexoII.Semente_bruta__c != null) {
							tmpAmount = anexoII.Semente_bruta__c * 40;
					}
					tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				}else {
					Map<String, Decimal> tmpMapCategoriaAmount = mapaVolumenDisponible.get(variedadId);
					String tmpCategoria = String.valueOf(anexoII.Categoria__c);
					Decimal tmpAmount = tmpMapCategoriaAmount.get(tmpCategoria);
					if(anexoII.Semente_bruta__c != null) {
						tmpAmount += anexoII.Semente_bruta__c * 40;
					}
					tmpMapCategoriaAmount.put(tmpCategoria, tmpAmount);
				}
			}
		}

		this.procesarProductosAnexoIIRebaxa(mapaVolumenDisponible, productosAnexoIIRebaja);

		this.procesarProductosDescarte(mapaVolumenDisponible, productosDescarte);

		return mapaVolumenDisponible;
	}

    public  List<Opportunity> obtenerOportunidadesDescarte(Id idCuenta, String safra, String marca) {
        List<Opportunity> queryResult = [
            SELECT Id, Name, Safra__c, Marca__c, StageName,
            CloseDate, Estado_Anexos_Portal_Miltiplicadores__c, pdf_descarte__c, tienePdf__c, VB_Recebeu__c
            FROM  Opportunity
            WHERE AccountId = :idCuenta
            AND RecordType.DeveloperName = 'Descarte'
            AND Safra__c = :safra
            AND Marca__c = :marca
            AND Estado_Anexos_Portal_Miltiplicadores__c != 'Anulado'
			ORDER BY CloseDate DESC
        ];
        return queryResult;
    }

    public  List<OpportunityLineItem> obtenerProductosOportunidad(Id oppId) {
        List<OpportunityLineItem> queryResult = [
            SELECT Id, PricebookEntry.Product2.Variedade__c,
            PricebookEntry.Product2.Variedade__r.Name, 
            PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c, 
            PricebookEntry.Product2.UNIDADE__c, Area__c, Estado_de_Produccion__r.Name,
            Categoria__r.Name, Quantity, Lote_Rebajado__c, 
            Categoria__c, Categoria_Prod__c, Unidade_descarte__c,
            UNIDADE__c, Variedade_Prod__c, Variedad_de_Produto__c
            FROM   OpportunityLineItem d
            WHERE  OpportunityId = :oppId
        ];
        return queryResult; 
    }




    public void crearDescarte(String toApproval, String idOppBeingEdited,
                                     List<aAppendix.myOppItem> olisToBeAdded,
                                     String opportunityComentario, String activeMarca, 
                                     String activeAccountId, String activeSafra, SiteUser__c activeSiteUser,
									 List<aAppendix.myOppItem> listaProductosParaEliminar) {
                                         
        String lista = 'Lista Canal Multiplicadores';
                                         
        if (activeMarca == 'DSEM') {
            lista = 'Lista DSEM';
        }   

        Map<String, PricebookEntry> royalPriceBook = Opp_Utils2.cargarRoyaltyPricebookEntries(lista);
        
        if (toApproval == '1') {
            if (!String.isEmpty(idOppBeingEdited)) {
                Opportunity descarteOpportunityBeingUpdated = [
                    SELECT Id, Comentarios__c, OwnerId
                    FROM Opportunity
                    WHERE Id = :idOppBeingEdited 
                    LIMIT 1
                ];
                
                String queryPlus = 'PricebookEntry.Product2.Variedade__c,'
                    + 'PricebookEntry.Product2.Variedade__r.Name,'
                    + 'PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c,'
                    + 'PricebookEntry.Product2.UNIDADE__c,'
                    + 'Categoria__r.Name';
                
       			List<OpportunityLineItem> listOlisOfOppBeingEdited = aSiteUtils.queryResults1(
                    OpportunityLineItem.SObjectType, queryPlus,
                    'Opportunity.Id = :v1', idOppBeingEdited
                );
                
                delete listOlisOfOppBeingEdited;
                
                List<OpportunityLineItem> itemsToBeAdded = new List<OpportunityLineItem>();
                for (aAppendix.myOppItem tmpItem : olisToBeAdded) {
                    OpportunityLineItem newOli = new OpportunityLineItem();
                    newOli.Quantity = tmpItem.amount;
                    newOli.Categoria__c = tmpItem.categoria;
                    newOli.Variedad__c = tmpItem.variedad;

                    if (tmpItem.unidade == '1') {
                        newOli.Unidade_descarte__c = 'Quilograma';
                    }
                    if (tmpItem.unidade == '25') {
                        newOli.Unidade_descarte__c = 'Saca 25Kg';
                    }
                    if (tmpItem.unidade == '40') {
                        newOli.Unidade_descarte__c = 'Saca 40Kg';
                    }
                    if (tmpItem.unidade == '1000') {
                        newOli.Unidade_descarte__c = 'Tonelada';
                    }
                    newOli.PricebookEntryId = royalPricebook.get(tmpItem.variedad).id;
                    newOli.Lote_Rebajado__c = tmpItem.lote_rebajado;
                    newOli.OpportunityId = descarteOpportunityBeingUpdated.Id;
                    newOli.UnitPrice = 1;
                    itemsToBeAdded.add(newOli);
                }
                insert itemsToBeAdded; 
                
                if (descarteOpportunityBeingUpdated.Comentarios__c != opportunityComentario) {
                    descarteOpportunityBeingUpdated.Comentarios__c = opportunityComentario;
                    update descarteOpportunityBeingUpdated;
                }
                
                aAppManager.enviarParaAprobacion(descarteOpportunityBeingUpdated);
            }
            else {
                Opportunity newlyCreatedOpportunity = crearGuardarOportunidadDescarteEdicion(
                    opportunityComentario, activeMarca,
                    activeAccountId, activeSafra,
                    activeSiteUser
                );

                newlyCreatedOpportunity = [SELECT Id, OwnerId FROM Opportunity WHERE ID =: newlyCreatedOpportunity.Id];
                
				List<OpportunityLineItem> itemsToBeAdded = new List<OpportunityLineItem>();
                for (aAppendix.myOppItem tmpItem : olisToBeAdded) {
                    OpportunityLineItem newOli = new OpportunityLineItem();
                    newOli.Quantity = tmpItem.amount;
                    newOli.Categoria__c = tmpItem.categoria;
                    newOli.Variedad__c = tmpItem.variedad;
                    if (tmpItem.unidade == '1') {
                        newOli.Unidade_descarte__c = 'Quilograma';
                    }
                    if (tmpItem.unidade == '25') {
                        newOli.Unidade_descarte__c = 'Saca 25Kg';
                    }
                    if (tmpItem.unidade == '40') {
                        newOli.Unidade_descarte__c = 'Saca 40Kg';
                    }
                    if (tmpItem.unidade == '1000') {
                        newOli.Unidade_descarte__c = 'Tonelada';
                    }
                    newOli.PricebookEntryId = royalPricebook.get(tmpItem.variedad).id;
                    newOli.Lote_Rebajado__c = tmpItem.lote_rebajado;
                    newOli.OpportunityId = newlyCreatedOpportunity.Id;
                    newOli.UnitPrice = 1;
                    itemsToBeAdded.add(newOli);
                }
                insert itemsToBeAdded;  
                
                aAppManager.enviarParaAprobacion(newlyCreatedOpportunity);
            }         
        }
        else if (!String.isEmpty(idOppBeingEdited)) {
                Opportunity descarteOpportunityBeingUpdated = [
                    SELECT Id, Comentarios__c 
                    FROM Opportunity
                    WHERE Id = :idOppBeingEdited 
                    LIMIT 1
                ];
                String queryPlus = 'PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name,'
                    + 'PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c,'
                    + 'PricebookEntry.Product2.UNIDADE__c, Categoria__r.Name';
                
       			List<OpportunityLineItem> listOlisOfOppBeingEdited = aSiteUtils.queryResults1(
                    OpportunityLineItem.SObjectType, queryPlus, 
                    'Opportunity.Id = :v1', idOppBeingEdited
                );
                delete listOlisOfOppBeingEdited;
                
                List<OpportunityLineItem> itemsToBeAdded = new List<OpportunityLineItem>();
                for (aAppendix.myOppItem tmpItem : olisToBeAdded) {
                    OpportunityLineItem newOli = new OpportunityLineItem();
                    newOli.Quantity = tmpItem.amount;
					newOli.Variedad__c = tmpItem.variedad;// Agregado Nuevo
                    newOli.Categoria__c = tmpItem.categoria;
                    
                    if (tmpItem.unidade == '1') {
                        newOli.Unidade_descarte__c = 'Quilograma';
                    }
                    
                    if (tmpItem.unidade == '25') {
                        newOli.Unidade_descarte__c = 'Saca 25Kg';
                    }
                    if (tmpItem.unidade == '40') {
                        newOli.Unidade_descarte__c = 'Saca 40Kg';
                    }
                    if (tmpItem.unidade == '1000') {
                        newOli.Unidade_descarte__c = 'Tonelada';
                    }
                    newOli.PricebookEntryId = royalPricebook.get(tmpItem.variedad).id;
                    newOli.Lote_Rebajado__c = tmpItem.lote_rebajado;
                    newOli.OpportunityId = descarteOpportunityBeingUpdated.Id;
                    newOli.UnitPrice = 1;
                    itemsToBeAdded.add(newOli);
                }
                insert itemsToBeAdded; 
                
                if (descarteOpportunityBeingUpdated.Comentarios__c != opportunityComentario) {
                    descarteOpportunityBeingUpdated.Comentarios__c = opportunityComentario;
                    update descarteOpportunityBeingUpdated;
                }
                
            } 
            else {
                Opportunity newlyCreatedOpportunity = crearGuardarOportunidadDescarteEdicion(
                    opportunityComentario, activeMarca, 
                    activeAccountId, activeSafra, 
                    activeSiteUser
                );
                    
                List<OpportunityLineItem> itemsToBeAdded = new List<OpportunityLineItem>();
                for (aAppendix.myOppItem tmpItem : olisToBeAdded) {
                    OpportunityLineItem newOli = new OpportunityLineItem();
                    newOli.Quantity = tmpItem.amount;
                    newOli.Variedad__c = tmpItem.variedad; // Agregado para Bug 18911
                    newOli.Categoria__c = tmpItem.categoria;
                    
                    if (tmpItem.unidade == '1') {
                        newOli.Unidade_descarte__c = 'Quilograma';
                    }
                    if (tmpItem.unidade == '25') {
                        newOli.Unidade_descarte__c = 'Saca 25Kg';
                    }
                    if (tmpItem.unidade == '40') {
                        newOli.Unidade_descarte__c = 'Saca 40Kg';
                    }
                    if (tmpItem.unidade == '1000') {
                        newOli.Unidade_descarte__c = 'Tonelada';
                    }
                    newOli.PricebookEntryId = royalPricebook.get(tmpItem.variedad).id;
                    newOli.Lote_Rebajado__c = tmpItem.lote_rebajado;
                    newOli.OpportunityId = newlyCreatedOpportunity.id;
                    newOli.UnitPrice = 1;
                    itemsToBeAdded.add(newOli);
                }
                insert itemsToBeAdded; 
            }

			List<Id> idsParaEliminar =new List<Id>();
			for(aAppendix.myOppItem oppItem : listaProductosParaEliminar) {
				idsParaEliminar.add(oppItem.id);
			}
			List<OpportunityLineItem> itemsParaEliminar = [
				SELECT Id
				FROM OpportunityLineItem
				WHERE ID IN :idsParaEliminar
			];
			Database.delete(itemsParaEliminar, false);
        }
    
    public Opportunity crearGuardarOportunidadDescarteEdicion(String opportunityComentario, String activeMarca,
                                                                String activeAccountId, String activeSafra, 
                                                                SiteUser__c activeSiteUser) { 
                                                                    
        Map<String, String> descarteRecordTypes = Opp_Utils2.cargarRecordTypesOportunidades(); 
        String descarteRecordTypeId = descarteRecordTypes.get('Descarte');
        
		String correoSiteUser = [
			SELECT Email__c 
			FROM SiteUser__c 
			WHERE Id =: activeSiteUser.id 
			LIMIT 1
		].Email__c;

        Opportunity descarteOpportunity = new Opportunity();
        descarteOpportunity.Name = 'DESCARTE';
        descarteOpportunity.StageName = 'Edición';
        descarteOpportunity.RecordTypeId = descarteRecordTypeId;
        descarteOpportunity.AccountId = activeAccountId;
        descarteOpportunity.Safra__c = activeSafra;
        descarteOpportunity.Marca__c = activeMarca;
        descarteOpportunity.Usuario__c = activeSiteUser.Id;
        descarteOpportunity.CloseDate = System.today();
        descarteOpportunity.Comentarios__c = opportunityComentario;
        descarteOpportunity.CorreoElectronicoSiteUser__c = correoSiteUser;
		                 
        insert descarteOpportunity;
        return descarteOpportunity;  
    }
}
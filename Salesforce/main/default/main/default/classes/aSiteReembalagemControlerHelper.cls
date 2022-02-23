public class aSiteReembalagemControlerHelper  {

     public static List<Opportunity> obtenerOportunidadesReembalaje(Id idCuenta, String safra, String marca) {
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

	public static List<OpportunityLineItem> obtenerProductosOportunidad(Id oppId) {
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


	public static void actualizarReembalagem(List<aAppendix.myOppItem> nuevosProductos, Id idOportunidad, String marca, String comentarioNuevaOportunidad, String paraAprobacion) {
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
			producto.PricebookEntryId = royalPriceBook.get(producto.Variedad__c).Id;
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

	public static void crearReembalagem(String opportunityComentario, String activeMarca,
                                                                String activeAccountId, String activeSafra, 
                                                                SiteUser__c activeSiteUser, List<aAppendix.myOppItem> olisToBeAdded, String paraAprobacion) {

		Map<String, String> ListaRecordTypes = Opp_Utils2.cargarRecordTypesOportunidades(); 
        String reembalagemRecordTypeId = ListaRecordTypes.get('Reembalaje');
        Opportunity reembalagemOpportunity = new Opportunity();
		Pricebook2 listaStandard = [
			SELECT Id, Name
			FROM Pricebook2
			WHERE Name = 'Lista de precios estándar'
		];

        reembalagemOpportunity.Name = 'Reembalaje'; 
        reembalagemOpportunity.StageName = 'Edición';
        reembalagemOpportunity.RecordTypeId = reembalagemRecordTypeId;
        reembalagemOpportunity.AccountId = activeAccountId;
        reembalagemOpportunity.Safra__c = activeSafra;
        reembalagemOpportunity.Marca__c = activeMarca;
        reembalagemOpportunity.Usuario__c = activeSiteUser.Id;
        reembalagemOpportunity.CloseDate = System.today();
        reembalagemOpportunity.Comentarios__c = opportunityComentario;
		reembalagemOpportunity.Pricebook2Id = listaStandard.Id;

		insert reembalagemOpportunity;

		List<PricebookEntry> precioItem = [
			SELECT Id, Product2.Variedade__c
			FROM PricebookEntry
			WHERE Pricebook2.Name  =: listaStandard.Name
		];

		Map<String, PricebookEntry> mapaVariedadPrecio = new Map<String, PricebookEntry>();

		for(PricebookEntry precio : precioItem) {
			mapaVariedadPrecio.put(precio.Product2.Variedade__c, precio);
		}
		
		List<OpportunityLineItem> itemsToBeAdded = new List<OpportunityLineItem>();
		for (aAppendix.myOppItem tmpItem : olisToBeAdded) {
			OpportunityLineItem producto = aAppendix.myOppItem.armarLineItem(tmpItem);
			producto.PricebookEntryId = mapaVariedadPrecio.get(producto.Variedad__c).Id;
			producto.Lote_Rebajado__c = tmpItem.lote_rebajado;
			producto.OpportunityId = reembalagemOpportunity.id;
			itemsToBeAdded.add(producto);
		}
		insert itemsToBeAdded;
		if(paraAprobacion == '1') {
			aAppManager.enviarParaAprobacion(reembalagemOpportunity);
		}
	}
}
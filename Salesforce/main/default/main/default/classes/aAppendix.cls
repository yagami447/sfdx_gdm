public class aAppendix {
	
	public class myOppItem {
        public String id {get; set;}
        public String name {get; set; }
        public Decimal amount {get; set; }
        public String variedad {get; set; }
        public String variedad_nombre {get; set; }
        public String variedad_registro {get; set; }
        public String categoria {get; set; }
        public String categoria_nombre {get; set;}
        public String categoria_id {get; set; }
        public String categoria_a_rebajar {get; set; }
        public String categoria_a_rebajar_id {get; set; }
        public String area_autorizada {get; set; }
        public String area_plantada {get; set; }
        public String sem_bruta {get; set; }            
        public String sem_bruta_A2 {get; set; }
        public String sem_rebajada {get; set; }
		public Decimal sem_disponibles {get; set; }
        public String descarte {get; set; }        
        public String sem_beneficiada {get; set; }
        public String sem_aprobada {get; set; }
        public String sem_comer {get; set; }
        public String sacas_disponibles {get; set; }
		public Decimal sem_comerci {get; set; }
        public String unidade {get; set;}
        public String sem_uso_propio {get; set; }
        public String sem_comer_up_aIII {get; set; }
        public String epocaPlantio {get; set; }
        public String lote_rebajado {get; set; }
        public String estado_comer_id {get; set; }
		public String estado_comer {get; set; }
        public String error_msg {get; set;}
        public Integer indice {get; set; }
		public String error_lote {get;set;}
		public String registro {get;set;}
		public Decimal haAutorizados {get;set;}
		public String estadoProduccion_nombre {get;set;}
		public String estadoProduccion_id {get;set;}
		public String unidade_nombre {get;set;}
		public Integer unidadDescarte {get;set;}
		public String cnpj {get;set;}
    }

	public class oppWrapper {
		public String idCooperador {get;set;}
		public String estadoComercialzacion {get;set;}
		public String cnpj {get;set;}
		public String epocaPlantacion {get;set;}
		public String rechazo {get;set;}
		public String renasem {get;set;}
        public String sufixCNPJ {get;set;}
	}

	public static OpportunityLineItem armarLineItem(aAppendix.myOppItem item) {
		OpportunityLineItem producto = new OpportunityLineItem();
		producto.Variedad__c = item.variedad;
		producto.Categoria__c = item.categoria;
		producto.Area__c = item.haAutorizados;
		producto.Expec_Prod_Bruta__c = item.amount;
		producto.Qtde_Scs_40kg__c = item.amount;
		producto.Quantity = item.amount;
		producto.Estado_de_Produccion__c = item.estadoProduccion_id;
		producto.Area__c = item.haAutorizados;
		producto.Estado_de_Produccion__c = item.estadoProduccion_id;
		try {
			producto.Categoria_a_Rebaixar__c = item.categoria_a_rebajar_id;
		}catch(Exception e) {
			System.debug(e.getMessage());
		}		
		producto.UnitPrice = 1;
		return producto;
	}

	public static aAppendix.myOppItem armarWrapper(OpportunityLineItem item) {
		aAppendix.myOppItem customOli = new aAppendix.myOppItem();
		customOli.variedad = item.PricebookEntry.Product2.Variedade__c;
		customOli.variedad_nombre = item.Variedade_Prod__c;
		customOli.registro = item.PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c;
		customOli.categoria = item.Categoria__c;
		customOli.categoria_nombre = item.Categoria__r.Name;
		customOli.amount = item.Expec_Prod_Bruta__c;
		customOli.lote_rebajado = item.Lote_Rebajado__c;
		customOli.id = item.Id;
		customOli.haAutorizados = item.Area__c;
		customOli.estadoProduccion_nombre = item.Estado_de_Produccion__r.Name;
		customOli.estadoProduccion_id = item.Estado_de_Produccion__c;
		customOli.unidade = item.PricebookEntry.Product2.UNIDADE__c;
		customOli.categoria_a_rebajar = item.Categoria_a_Rebaixar__r.Name;
		customOli.categoria_a_rebajar_id = item.Categoria_a_Rebaixar__c;
		customOli.sem_comer = String.valueOf(item.Semente_comercializada__c);

		return customOli;
	}

}
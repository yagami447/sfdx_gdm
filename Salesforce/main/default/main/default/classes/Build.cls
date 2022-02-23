global class Build { 

	public class SiteUserBuilder {
		private SiteUser__c obj = new SiteUser__c(Email__c = 'SOME DATE',
			Password__c = 'STRING'
		);

		public SiteUserBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public SiteUserBuilder withEmail(String value) {
			obj.Email__c = value;
			return this;
		}

		public SiteUserBuilder withPassword(String value) {
			obj.Password__c = value;
			return this;
		}

		public SiteUserBuilder withActive(Boolean value) {
			obj.Active__c = value;
			return this;
		}

		public SiteUserBuilder withHabilitadoVotacionDSEM(Boolean value) {
			obj.Habilitado_Votacion_DSEM__c = value;
			return this;
		}

		public SiteUserBuilder withHabilitadoAnexos(Boolean value) {
			obj.Habilitado_Anexos__c = value;
			return this;
		}

		public SiteUserBuilder withHabilitadoEventos(Boolean value) {
			obj.Habilitado_Eventos__c = value;
			return this;
		}

		public SiteUser__c build() {
			return obj;
		}
	}

	public static SiteUserBuilder aSiteUser() { return new SiteUserBuilder(); }

	/*------------------------------------------------------------------------
	             SiteUserBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             AccountBuilderStart
	------------------------------------------------------------------------*/
	public class AccountBuilder {
		private Account obj = new Account(Name = 'STRING');

		public AccountBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  'Analista', 'Competidor', 'Cliente', 'Integrador', 'Inversor', 'Socio', 'Prensa', 'Cliente potencial', 'Distribuidor', 'Otros', 'Franqueado', 'Multiplicador', 'Agricultor' */
		public AccountBuilder withType(String value) {
			obj.Type = value;
			return this;
		}

		public AccountBuilder withRecordTypeId(RecordType value) {
			obj.RecordTypeId = value.Id;
			return this;
		}

		public AccountBuilder withParentId(Account value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AccountBuilder withBillingStreet(String value) {
			obj.BillingStreet = value;
			return this;
		}

		public AccountBuilder withBillingCity(String value) {
			obj.BillingCity = value;
			return this;
		}

		public AccountBuilder withBillingState(String value) {
			obj.BillingState = value;
			return this;
		}

		public AccountBuilder withBillingPostalCode(String value) {
			obj.BillingPostalCode = value;
			return this;
		}

		public AccountBuilder withBillingCountry(String value) {
			obj.BillingCountry = value;
			return this;
		}

		public AccountBuilder withBillingLatitude(Double value) {
			obj.BillingLatitude = value;
			return this;
		}

		public AccountBuilder withBillingLongitude(Double value) {
			obj.BillingLongitude = value;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  'Address', 'NearAddress', 'Block', 'Street', 'ExtendedZip', 'Zip', 'Neighborhood', 'City', 'County', 'State', 'Unknown' */
		public AccountBuilder withBillingGeocodeAccuracy(String value) {
			obj.BillingGeocodeAccuracy = value;
			return this;
		}

		public AccountBuilder withShippingStreet(String value) {
			obj.ShippingStreet = value;
			return this;
		}

		public AccountBuilder withShippingCity(String value) {
			obj.ShippingCity = value;
			return this;
		}

		public AccountBuilder withShippingState(String value) {
			obj.ShippingState = value;
			return this;
		}

		public AccountBuilder withShippingPostalCode(String value) {
			obj.ShippingPostalCode = value;
			return this;
		}

		public AccountBuilder withShippingCountry(String value) {
			obj.ShippingCountry = value;
			return this;
		}

		public AccountBuilder withShippingLatitude(Double value) {
			obj.ShippingLatitude = value;
			return this;
		}

		public AccountBuilder withShippingLongitude(Double value) {
			obj.ShippingLongitude = value;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  'Address', 'NearAddress', 'Block', 'Street', 'ExtendedZip', 'Zip', 'Neighborhood', 'City', 'County', 'State', 'Unknown' */
		public AccountBuilder withShippingGeocodeAccuracy(String value) {
			obj.ShippingGeocodeAccuracy = value;
			return this;
		}

		public AccountBuilder withPhone(String value) {
			obj.Phone = value;
			return this;
		}

		public AccountBuilder withFax(String value) {
			obj.Fax = value;
			return this;
		}

		public AccountBuilder withWebsite(String value) {
			obj.Website = value;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  'Agricultura', 'Indumentaria', 'Banca', 'Biotecnología', 'Química', 'Comunicaciones', 'Construcción', 'Consultoría', 'Educación', 'Electrónica', 'Energía', 'Ingeniería', 'Entretenimiento', 'Medio ambiente', 'Finanzas', 'Alimentos y bebidas', 'Gobierno', 'Salud', 'Recepciones', 'Seguros', 'Maquinaria', 'Fabricación', 'Medios de comunicación', 'Sin fines de lucro', 'Otros', 'Recreación', 'Minorista', 'Envíos', 'Tecnología', 'Telecomunicaciones', 'Transportes', 'Servicios públicos' */
		public AccountBuilder withIndustry(String value) {
			obj.Industry = value;
			return this;
		}

		public AccountBuilder withAnnualRevenue(Decimal value) {
			obj.AnnualRevenue = value;
			return this;
		}

		public AccountBuilder withNumberOfEmployees(Integer value) {
			obj.NumberOfEmployees = value;
			return this;
		}

		public AccountBuilder withDescription(String value) {
			obj.Description = value;
			return this;
		}

		public AccountBuilder withOwnerId(User value) {
			obj.OwnerId = value.Id;
			return this;
		}

		public AccountBuilder withJigsaw(String value) {
			obj.Jigsaw = value;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  'Publicidad', 'Referencia del empleado', 'Referencia externa', 'Socio', 'Relaciones públicas', 'Seminario - Interno', 'Seminario - Socio', 'Feria', 'Web', 'Por comentarios de terceros', 'Otros' */
		public AccountBuilder withAccountSource(String value) {
			obj.AccountSource = value;
			return this;
		}

		public AccountBuilder withSicDesc(String value) {
			obj.SicDesc = value;
			return this;
		}

		public AccountBuilder withCEP(String value) {
			obj.CEP__c = value;
			return this;
		}

		public AccountBuilder withCNPJCPF(String value) {
			obj.CNPJ_CPF__c = value;
			return this;
		}

		public AccountBuilder withIE(String value) {
			obj.IE__c = value;
			return this;
		}

		public AccountBuilder withRegion(Regiao__c value) {
			obj.Region__c = value.Id;
			return this;
		}

		public AccountBuilder withAsociaciones(String value) {
			obj.Asociaciones__c = value;
			return this;
		}

		public AccountBuilder withEstado(Estado__c value) {
			obj.Estado__c = value.Id;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  'Verde', 'Amarelo', 'Vermelho' */
		public AccountBuilder withStatusBase(String value) {
			obj.Status_Base__c = value;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  '061 - Fernando Frehner', '066 - Marcelo Steffen', '067 - Sergio Bertagnolli', '076 - Tiago Goulart', '083 - Jorge Cristiano Rosa', '095 - Brasmax', '101 - Fausto Tadeu Fanchin', '104 - Otavio Gorni', '111 - Pablo R. de Souza', '150 - João Serrano', '151 - Anderson Weissheimer', '196 - Edson Chambo', '197 - Wagner Rank', '198 - Bernardo Zanardo', '199 - Lucas Costa', '231 - Willian Von Scharten', '234 - Julio Cesar Poletto', '238 - Luis Fernando Cecatto', '289 - Flávio Marçal dos Santos', '312 - Lucas Hilario Fantineli', '319 - Felipe Oliveira Costa' */
		public AccountBuilder withResponsavel(String value) {
			obj.Responsavel__c = value;
			return this;
		}

		public AccountBuilder withAtivo(Boolean value) {
			obj.Ativo__c = value;
			return this;
		}

		public AccountBuilder withMotivoinativo(String value) {
			obj.Motivo_inativo__c = value;
			return this;
		}

		public AccountBuilder withMonsantoAutorizo(Boolean value) {
			obj.Monsanto_Autorizo__c = value;
			return this;
		}

		public AccountBuilder withDatadaAutorizacion(Date value) {
			obj.Data_da_Autorizacion__c = value;
			return this;
		}

		public AccountBuilder withClientede(String value) {
			obj.Cliente_de__c = value;
			return this;
		}

		public AccountBuilder withCodigoSAP(String value) {
			obj.CodigoSAP__c = value;
			return this;
		}

		public AccountBuilder withObtentores(String value) {
			obj.Obtentores__c = value;
			return this;
		}

		public AccountBuilder withMultiplicador(Boolean value) {
			obj.Multiplicador__c = value;
			return this;
		}

		public AccountBuilder withAuditor(Boolean value) {
			obj.Interno__c = value;
			return this;
		}

		public AccountBuilder withCooperativa(Boolean value) {
			obj.Cooperativa__c = value;
			return this;
		}

		public AccountBuilder withRevenda(Boolean value) {
			obj.Revenda__c = value;
			return this;
		}

		public AccountBuilder withAgricultor(Boolean value) {
			obj.Agricultor__c = value;
			return this;
		}

		public AccountBuilder withCorretora(Boolean value) {
			obj.Corretora__c = value;
			return this;
		}

		public AccountBuilder withEscritoriodePlanejamento(Boolean value) {
			obj.Escritorio_de_Planejamento__c = value;
			return this;
		}

		public AccountBuilder withFundacion(Boolean value) {
			obj.Fundacion__c = value;
			return this;
		}

		public AccountBuilder withNomefantasia(String value) {
			obj.Nome_fantasia__c = value;
			return this;
		}

		public AccountBuilder withestaenSAP(Boolean value) {
			obj.esta_en_SAP__c = value;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  'SUL', 'CERRADO', 'DIFERENCIADA', 'EXTERIOR' */
		public AccountBuilder withTipodeReferencia(String value) {
			obj.Tipo_de_Referencia__c = value;
			return this;
		}

		public AccountBuilder withSafras(String value) {
			obj.Safras__c = value;
			return this;
		}

		public AccountBuilder withSitedemultiplicadores(Boolean value) {
			obj.Site_de_multiplicadores__c = value;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  'CMEX', 'CPFI', 'CPJU' */
		public AccountBuilder withGrupodeCuentas(String value) {
			obj.Grupo_de_Cuentas__c = value;
			return this;
		}

		public AccountBuilder withObtentor(Boolean value) {
			obj.Obtentor__c = value;
			return this;
		}

		public AccountBuilder withEstadoComercializacion(String value) {
			obj.Estado_Comercializacion__c = value;
			return this;
		}

		public AccountBuilder withEmail(String value) {
			obj.Email__c = value;
			return this;
		}

		public AccountBuilder withGeolocalizacionLatitudes(Double value) {
			obj.Geolocalizacion__Latitude__s = value;
			return this;
		}

		public AccountBuilder withGeolocalizacionLongitudes(Double value) {
			obj.Geolocalizacion__Longitude__s = value;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  '061 - Fernando Frehner', '066 - Marcelo Steffen', '067 - Sergio Bertagnoli', '095 - GDM Genetica', '111 - Pablo R. de Souza', '217 - Cristian Pirolli', '225 - Fagner Regis de Oliveira', '229 - Murilo Brazero Cacheffo', '234 - Julio Cesar Poletto' */
		public AccountBuilder withReponsavelDSEM(String value) {
			obj.Reponsavel_DSEM__c = value;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  'Verde', 'Amarelo', 'Vermelho' */
		public AccountBuilder withStatusBaseDSEM(String value) {
			obj.Status_Base_DSEM__c = value;
			return this;
		}

		public AccountBuilder withBarrio(String value) {
			obj.Barrio__c = value;
			return this;
		}

		public AccountBuilder withComplemento(String value) {
			obj.Complemento__c = value;
			return this;
		}

		/** (2019-05-30 13:05:58) Valores disponibles:  'BRMX', 'DSEM' */
		public AccountBuilder withMarca(String value) {
			obj.Marca__c = value;
			return this;
		}

		public AccountBuilder withinitProcess(Boolean value) {
			obj.initProcess__c = value;
			return this;
		}

		public AccountBuilder withSupervisor(User value) {
			obj.Supervisor__c = value.Id;
			return this;
		}

		public AccountBuilder withGerenteComercial(User value) {
			obj.Gerente_comercial__c = value.Id;
			return this;
		}

		public Account build() {
			return obj;
		}
	}

	public static AccountBuilder anAccount() { return new AccountBuilder(); }

	public static AccountBuilder anAccountCuenta() { 
		AccountBuilder val = new AccountBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Account', 'Cuenta').Id;
		return val;
	}

	public static AccountBuilder anAccountGrupo() { 
		AccountBuilder val = new AccountBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Account', 'Grupo').Id;
		return val;
	}

	/*------------------------------------------------------------------------
	             AccountBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             SiteUserAccountBuilderStart
	------------------------------------------------------------------------*/
	 public class SiteUserAccountBuilder {
		private SiteUserAccount__c obj = new SiteUserAccount__c();

		public SiteUserAccountBuilder withName(String value) {
			 obj.Name = value;
			 return this;
		}

		public SiteUserAccountBuilder withAccount(Account value) {
			 obj.Account__c = value.Id;
			 return this;
		}

		public SiteUserAccountBuilder withActive(Boolean value) {
			 obj.Active__c = value;
			 return this;
		}

		public SiteUserAccountBuilder withSiteUser(SiteUser__c value) {
			 obj.SiteUser__c = value.Id;
			 return this;
		}

		 public SiteUserAccount__c build() {
			 return obj;
		}

	}

	public static SiteUserAccountBuilder aSiteUserAccount() { return new SiteUserAccountBuilder(); }

	/*------------------------------------------------------------------------
	             SiteUserAccountBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             SiteUserSessionBuilderStart
	------------------------------------------------------------------------*/
	public class SiteUserSessionBuilder {
		private SiteUserSession__c obj = new SiteUserSession__c();

		/** (2019-04-08 13:03:53) Valores disponibles:  'BRMX', 'DSEM' */
		public SiteUserSessionBuilder withMarca(String value) {
			obj.Marca__c = value;
			return this;
		}

		/** (2019-04-08 13:03:53) Valores disponibles:  '14/15', '15/16', '16/17', '17/18', '18/19', '19/20', '20/21', '21/22', '22/23', '23/24' */
		public SiteUserSessionBuilder withSafra(String value) {
			obj.Safra__c = value;
			return this;
		}

		public SiteUserSessionBuilder withSiteUser(SiteUser__c value) {
			obj.SiteUser__c = value.Id;
			return this;
		}

		public SiteUserSession__c build() {
			return obj;
		}
	}

	public static SiteUserSessionBuilder aSiteUserSession() { return new SiteUserSessionBuilder(); }

	/*------------------------------------------------------------------------
	             SiteUserSessionBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             ConfiguracionBMXBuilderStart
	------------------------------------------------------------------------*/
	public class ConfiguracionBMXBuilder {
		private Configuracion_BMX__c obj = new Configuracion_BMX__c();

		public ConfiguracionBMXBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public ConfiguracionBMXBuilder withPMSafraActualA1(String value) {
			obj.PM_Safra_Actual_A1__c = value;
			return this;
		}

		public ConfiguracionBMXBuilder withPMSafraActualA2(String value) {
			obj.PM_Safra_Actual_A2__c = value;
			return this;
		}

		public ConfiguracionBMXBuilder withPMSafraActualA3(String value) {
			obj.PM_Safra_Actual_A3__c = value;
			return this;
		}

		public ConfiguracionBMXBuilder withPMSafraActualA4(String value) {
			obj.PM_Safra_Actual_A4__c = value;
			return this;
		}

		public ConfiguracionBMXBuilder withPMSafraActualA5(String value) {
			obj.PM_Safra_Actual_A5__c = value;
			return this;
		}

		public ConfiguracionBMXBuilder withPMSafraActualContratos(String value) {
			obj.PM_Safra_Actual_Contratos__c = value;
			return this;
		}

		public ConfiguracionBMXBuilder withPMSafraActualDescarte(String value) {
			obj.PM_Safra_Actual_Descarte__c = value;
			return this;
		}

		public ConfiguracionBMXBuilder withPMSafraActualEventos(String value) {
			obj.PM_Safra_Actual_Eventos__c = value;
			return this;
		}

		public ConfiguracionBMXBuilder withCRMSafraSiguiente(String value) {
			obj.CRM_Safra_Siguiente__c = value;
			return this;
		}

		public ConfiguracionBMXBuilder withPMSafraActualReembalagem(String value) {
			obj.PM_Safra_Actual_Reembalagem__c = value;
			return this;
		}

		public ConfiguracionBMXBuilder withLinkSapQa(String value) {
			obj.Link_Sap_QA__c = value;
			return this;
		}

		/** (2021-11-05 09:00:00) Valores disponibles:  'BRMX', 'DSEM', 'NEOG' */
		public ConfiguracionBMXBuilder withMarca(String value) {
			obj.Marca__c = value;
			return this;
		}

		public Configuracion_BMX__c build() {
			return obj;
		}
	}

	public static ConfiguracionBMXBuilder aConfiguracionBMX() { return new ConfiguracionBMXBuilder(); }

	/*------------------------------------------------------------------------
	             ConfiguracionBMXBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             Pricebook2BuilderStart
	------------------------------------------------------------------------*/
	public class Pricebook2Builder {
		private Pricebook2 obj = new Pricebook2(Name = 'STRING');

		public Pricebook2Builder withName(String value) {
			obj.Name = value;
			return this;
		}

		public Pricebook2Builder withIsActive(Boolean value) {
			obj.IsActive = value;
			return this;
		}

		public Pricebook2Builder withDescription(String value) {
			obj.Description = value;
			return this;
		}

		public Pricebook2Builder withParaVendaDeBasicaInicial(Boolean value) {
			obj.Para_venda_de_b_sica_inicial__c = value;
			return this;
		}

		public Pricebook2 build() {
			return obj;
		}
	}

	public static Pricebook2Builder aPricebook2() { return new Pricebook2Builder(); }

	/*------------------------------------------------------------------------
	             Pricebook2BuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             VariedadBuilderStart
	------------------------------------------------------------------------*/
	public class VariedadBuilder {
		private Variedad__c obj = new Variedad__c();

		public VariedadBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		/** (2021-06-01 10:38:00) Valores disponibles:  'DM Sementes', 'Brasmax', Neogen */
		public VariedadBuilder withMarcacomercial(String value) {
			obj.Marca_comercial__c = value;
			return this;
		}

		public VariedadBuilder withNombredeRegistro(String value) {
			obj.Nombre_de_Registro__c = value;
			return this;
		}

		public VariedadBuilder withAtiva(Boolean value) {
			obj.Ativa__c = value;
			return this;
		}

		public VariedadBuilder withDisponivelVendaBasica(Boolean value) {
			obj.Disponivel_para_venda_basica__c = value;
			return this;
		}

		public VariedadBuilder withNumeroderegistro(String value) {
			obj.Numero_de_registro__c = value;
			return this;
		}

		 public Variedad__c build() {
			return obj;
		}
	}

	public static VariedadBuilder aVariedad() { return new VariedadBuilder(); }

	/*------------------------------------------------------------------------
	             VariedadBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             CategoriaBuilderStart
	------------------------------------------------------------------------*/
	public class CategoriaBuilder {
		private Categoria__c obj = new Categoria__c();

		public CategoriaBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

        public CategoriaBuilder withShowPortal(Boolean value){
            obj.Mostrar_en_portal__c = true;
            return this;
        }

		public Categoria__c build() {
			return obj;
		}
	}

	public static CategoriaBuilder aCategoria() { return new CategoriaBuilder(); }

	/*------------------------------------------------------------------------
	             CategoriaBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             Product2BuilderStart
	------------------------------------------------------------------------*/
	public class Product2Builder {
		private Product2 obj = new Product2(Name = 'STRING');

		public Product2Builder withName(String value) {
			obj.Name = value;
			return this;
		}

		public Product2Builder withIsActive(Boolean value) {
			obj.IsActive = value;
			return this;
		}

		public Product2Builder withFamily(String value) {
			obj.Family = value;
			return this;
		}

		/** (2019-04-08 13:17:33) Valores disponibles:  'BMX APOLO RR', 'BMX IMPACTO RR', 'BMX MAGNA RR', 'BMX POTÊNCIA RR', 'BMX TITAN RR', 'BMX FORÇA RR', 'BMX ENERGIA RR', 'BMX ATIVA RR', 'BMX TURBO RR', 'BMX VELOZ RR', 'BMX ALVO RR', 'BMX TORNADO RR', 'BMX CLASSE RR', 'BMX DESAFIO RR', 'BMX RAÇA RR', 'BMX PROGRESSO RR', 'BRASMAX ELITE IPRO', 'BRASMAX FLECHA IPRO', 'BRASMAX BONUS IPRO', 'BRASMAX BRAVA', 'BRASMAX CLASSE', 'BRASMAX PRISMA', 'BRASMAX OPUS IPRO', 'BRASMAX LANÇA IPRO', 'BRASMAX GARRA IPRO', 'BRASMAX ÍCONE IPRO', 'BRASMAX POWER IPRO', '68I69RSF IPRO', '75I76RSF IPRO', '81I84RSF IPRO', '53I54RSF IPRO', '66I68RSF IPRO' */
		public Product2Builder withVariedad(String value) {
			obj.Variedad__c = value;
			return this;
		}

        public Product2Builder withVariedade(Variedad__c value) {
			obj.Variedade__c = value.Id;
			return this;
		}

		/** (2019-04-08 13:17:33) Valores disponibles:  'BREEDER', 'FUNDADORA', 'Genetica', 'Pre Basica', 'BASICA', 'C', 'C1', 'C2', 'R', 'S1', 'S2' */
		public Product2Builder withCategoria(String value) {
			obj.Categoria__c = value;
			return this;
		}

		public Product2Builder withCateg(Categoria__c value) {
			obj.Categ__c = value.id;
			return this;
		}

		public Product2Builder withPrice(Double value) {
			obj.Price__c = value;
			return this;
		}

		public Product2Builder withSociedad(String value) {
			obj.Sociedad__c = value;
			return this;
		}

		public Product2Builder withCodMaterialSAP(String value) {
			obj.Codigo_Material_SAP__c = value;
			return this;
		}

		public Product2Builder withUnidad(String value) {
			obj.UNIDADE__c = value;
			return this;
		}

		public Product2Builder withCantSubUnidad(String value) {
			obj.CANTIDAD_SUB_UNIDAD__c = value;
			return this;
		}

		public Product2 build() {
			return obj;
		}
	}

	public static Product2Builder aProduct2() { return new Product2Builder(); }

	/*------------------------------------------------------------------------
	             Product2BuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             PricebookEntryBuilderStart
	------------------------------------------------------------------------*/
	public class PricebookEntryBuilder {
		private PricebookEntry obj = new PricebookEntry(UnitPrice = 1.1);

		public PricebookEntryBuilder withPricebook2Id(Pricebook2 value) {
			obj.Pricebook2Id = value.Id;
			return this;
		}
  
        public PricebookEntryBuilder withPricebook2Id(Id value) {
			obj.Pricebook2Id = value;
			return this;
		}

		public PricebookEntryBuilder withProduct2Id(Product2 value) {
			obj.Product2Id = value.Id;
			return this;
		}

		public PricebookEntryBuilder withUnitPrice(Decimal value) {
			obj.UnitPrice = value;
			return this;
		}

		public PricebookEntryBuilder withIsActive(Boolean value) {
			obj.IsActive = value;
			return this;
		}

		public PricebookEntryBuilder withUseStandardPrice(Boolean value) {
			obj.UseStandardPrice = value;
			return this;
		}

		public PricebookEntry build() {
			return obj;
		}
	}

	/** It require following fields to can be inserted: Pricebook2Id, Product2Id. */
	public static PricebookEntryBuilder aPricebookEntry() { return new PricebookEntryBuilder(); }

	/*------------------------------------------------------------------------
	             PricebookEntryBuilderEnd
	------------------------------------------------------------------------*/
    
    /*------------------------------------------------------------------------
	             OpportunityBuilderStart
	------------------------------------------------------------------------*/
	 public class OpportunityBuilder {
		private Opportunity obj = new Opportunity(Name = 'STRING',
			StageName = 'Edición',
			CloseDate = Date.today()
		);

		public OpportunityBuilder withAccountId(Account value) {
			obj.AccountId = value.Id;
			return this;
		}

		public OpportunityBuilder withCampaignId(Campaign value) {
			obj.CampaignId = value.Id;
			return this;
		}

		public OpportunityBuilder withRecordTypeId(RecordType value) {
			obj.RecordTypeId = value.Id;
			return this;
		}

        public OpportunityBuilder withRecordTypeId(id value) {
			obj.RecordTypeId = value;
			return this;
        }

		public OpportunityBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public OpportunityBuilder withDescription(String value) {
			obj.Description = value;
			return this;
		}

		/** (2019-04-08 14:57:49) Valores disponibles:  'Edición', 'Edición vencida', 'Edición post Vencimiento', 'Pendiente de Análisis', 'Pendiente de Aprobación', 'Rechazada Supervisor', 'Desaprobado x Gerente', 'Aprobada', 'Reserva', 'Aberta', 'Fechada Perdida', 'Fechada Recibida', 'Anulada', 'Relatorio de Vendas', 'Relatorio de Produção', 'AN - Anulada', 'PE - Pendiente', 'RR - Rechazada para Revision', 'RE - Rechazada por Facturacion', 'AU - Autorizada', 'Estimado', 'Con condición de pago', 'Con contrato firmado', 'Cobrado', 'PB-Pendiente', 'PB-Aprobada Parcial', 'PB-Aprobada', 'PB-Rechazada' */
		public OpportunityBuilder withStageName(String value) {
			obj.StageName = value;
			return this;
		}

		public OpportunityBuilder withCloseDate(Date value) {
			obj.CloseDate = value;
			return this;
		}

		/** (2019-04-08 14:57:49) Valores disponibles:  'Normal', 'Regularização', 'Existing Business', 'New Business' */
		public OpportunityBuilder withType(String value) {
			obj.Type = value;
			return this;
		}

		public OpportunityBuilder withNextStep(String value) {
			obj.NextStep = value;
			return this;
		}

		public OpportunityBuilder withPricebook2Id(Pricebook2 value) {
			obj.Pricebook2Id = value.Id;
			return this;
		}

		public OpportunityBuilder withPricebook2Id(Id value) {
			obj.Pricebook2Id = value;
			return this;
		}

		/** (2019-04-08 14:57:49) Valores disponibles:  '06/07', '07/08', '08/09', '09/10', '09/09', '10/10', '10/11', '11/11', '11/12', '12/12', '12/13', '13/14', '14/15', '15/16', '16/17', '17/18', '18/19', '19/20' */
		public OpportunityBuilder withSafra(String value) {
			obj.Safra__c = value;
			return this;
		}

		public OpportunityBuilder withTipodecambio(Decimal value) {
			obj.Tipo_de_cambio__c = value;
			return this;
		}

		/** (2019-04-08 14:57:49) Valores disponibles:  'BRMX', 'DSEM' */
		public OpportunityBuilder withMarca(String value) {
			obj.Marca__c = value;
			return this;
		}

        public OpportunityBuilder withNotificado(Boolean value) {
			obj.Notificado__c = value;
			return this;
		}

		public OpportunityBuilder withNroAutorizacion(Double value) {
			obj.Nro_Autorizacion__c = value;
			return this;
		}
        
        /** (2019-04-25 14:45:56) Valores disponibles:  'SUR', 'CERRADO', 'REGION 1', 'REGION 2' */
		public OpportunityBuilder withRegion(String value) {
			obj.Region__c = value;
			return this;
		}

        public OpportunityBuilder withMes(String value) {
			obj.Mes__c = value;
			return this;
        }

		/** (2021-05-31 09:10:00) Valores disponibles:  'Comerciais', 'Lançamentos' */
		public OpportunityBuilder withTipoDeCultivares(String value) {
			obj.Tipo_de_Cultivares__c = value;
			return this;
		}

		/** (2021-05-31 09:20:00) Valores disponibles:  'Multiplicação', 'Difusão' */
		public OpportunityBuilder withTipoDeNecessidade(String value) {
			obj.Tipo_de_Necessidade__c = value;
			return this;
		}

		public OpportunityBuilder withOportunidadRelacionada(Opportunity value) {
			obj.Oportunidad_Relacionada__c = value.Id;
			return this;
		}

		public OpportunityBuilder withPlanoDeAuditoria(Plano_de_Auditoria__c value) {
			obj.Plano_de_Auditoria__c = value.Id;
			return this;
		}

		public Opportunity build() {
			return obj;
		}
	}

	public static OpportunityBuilder anOpportunity() { return new OpportunityBuilder(); }

	public static OpportunityBuilder anOpportunityAnexoI() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'AnexoI').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityAnexoIRebaixamentoHa() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Anexo_I_Rebaixamento_Ha').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityAnexoII() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'AnexoII').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityAnexoIIRebaixamentoSacas() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Anexo_II_Rebaixamento_Sacas').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityAnexoIII() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Anexo_III').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityAnexoIV() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Anexo_IV').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityAnexoV() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'AnexoV').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityAutorizada() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Autorizada').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityComercial() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Comercial').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityCVBAutorizada() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'CVB_Autorizada').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityCVBPendiente() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'CVB_Pendiente').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityCVBRechazada() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'CVB_Rechazada').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityDescarte() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Descarte').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityDisponibilidadedaBasica() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Disponibilidade_da_Basica').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityEstimativadevenda() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Estimativa_de_venda').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityExportacion() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Exportacion').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityFcdeBrasmax() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Fc_de_Brasmax').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityFcdeBrasmaxContabilizada() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Fc_de_Brasmax_Contabilizada').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityNCAutorizada() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'NC_Autorizada').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityNCPendiente() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'NC_Pendiente').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityNCRechazada() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'NC_Rechazada').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityObjetivoContratoRoyalties() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Objetivo_Contrato_Royalties').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityObjetivoVentasRoyalties() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Objetivo_Ventas_Royalties').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityObjetivoVentasSemilla() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Objetivo_Ventas_Semilla').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityPBComercial() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'PB_Comercial').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityPBDesarrollo() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'PB_Desarrollo').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityPBOferta() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'PB_Oferta').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityPBProduccion() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'PB_Produccion').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityPendiente() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Pendiente').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityPrevisao() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Previsao').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityPrevisaoCerrada() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Previsao_Cerrada').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityPrevisaoeEstoque() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Previsao_e_Estoque').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityProduccion() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Produccion').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityRebaja() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Rebaja').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityRechazada() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Rechazada').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityReembalaje() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Reembalaje').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityStockMultiplicadores() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Stock_Multiplicadores').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityVBAutorizada() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'VB_Autorizada').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityVBFacturada() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'VB_Facturada').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityVBPendiente() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'VB_Pendiente').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityVBRechazada() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'VB_Rechazada').Id;
		return val;
	}

	public static OpportunityBuilder anOpportunityVENTADEBASICA() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'VENTA_DE_BASICA').Id;
		return val;
	}
    
	public static OpportunityBuilder anOpportunityNFe() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'NFe').Id;
		return val;
	}
    
    public static OpportunityBuilder anOpportunityVendaDaBasicaCompleta() { 
		OpportunityBuilder val = new OpportunityBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Opportunity', 'Venda_da_Basica_full').Id;
		return val;
	}

	/*------------------------------------------------------------------------
	             OpportunityBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             OpportunityLineItemBuilderStart
	------------------------------------------------------------------------*/
	public class OpportunityLineItemBuilder {
		private OpportunityLineItem obj = new OpportunityLineItem(Quantity = 1.5);

		public OpportunityLineItemBuilder withOpportunityId(Opportunity value) {
			obj.OpportunityId = value.Id;
			return this;
		}

		public OpportunityLineItemBuilder withPricebookEntryId(PricebookEntry value) {
			obj.PricebookEntryId = value.Id;
			return this;
		}

		public OpportunityLineItemBuilder withProduct2Id(Product2 value) {
			obj.Product2Id = value.Id;
			return this;
		}

		public OpportunityLineItemBuilder withQuantity(Double value) {
			obj.Quantity = value;
			return this;
		}

		public OpportunityLineItemBuilder withDiscount(Decimal value) {
			obj.Discount = value;
			return this;
		}

		public OpportunityLineItemBuilder withUnitPrice(Decimal value) {
			obj.UnitPrice = value;
			return this;
		}

		public OpportunityLineItemBuilder withVariedad(Variedad__c value) {
			obj.Variedad__c = value.Id;
			return this;
		}

		public OpportunityLineItemBuilder withCategoria(Categoria__c value) {
			obj.Categoria__c = value.Id;
			return this;
		}

		public OpportunityLineItemBuilder withDescuentoporc(Double value) {
			obj.Descuento_porc__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withVLLiquidoCopia(Decimal value) {
			obj.VL_Liquido_Copia__c = value;
			return this;
		}
         
         public OpportunityLineItemBuilder withSementeBruta(Decimal value) {
			obj.Semente_bruta__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withQuantConfirmada(Double value) {
			obj.Quant_Confirmada__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withQuantRechazada(Double value) {
			obj.Quant_Rechazada__c = value;
			return this;
	   	}

		public OpportunityLineItemBuilder withIdItemdeOportunidadRelacionado(String value) {
			obj.Id_Item_de_Oportunidad_Relacionado__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withTasas(Double value) {
			obj.Tasas__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withUnidadedescarte(String value) {
			obj.Unidade_descarte__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withBasedeCalculo(Double value) {
			obj.Base_de_Calculo__c = value;
			return this;
		}

		/** (2019-06-03 15:19:10) Valores disponibles:  'P', 'G' */
		public OpportunityLineItemBuilder withGrupodemateriales2(String value) {
			obj.Grupo_de_materiales_2__c = value;
			return this;
		}

		/** (2019-06-03 15:19:10) Valores disponibles:  '50 - Questão está sendo resolvida', 'Z0 - Recusa posição para faturar parcial', 'Z1 - Troca de produto SF', 'Z2 - Credito não autorizado', 'Z3 - Pedido recusado em Salesforce', 'Z4 - Contrato concluído', 'Z5 - Sol. De NC/ND não autorizada', 'Z6 - Recusa posição para faturar total', 'Z8 - Pedido em duplicidade', 'Z9 - Pendente de análise', 'ZA - Devolução acreditada', 'ZB - Troca de produto SAP', 'ZC - BR - Bloqueio – Produção', 'ZD - BR - Bloqueio – Comercial' */
		public OpportunityLineItemBuilder withMotivodeRechazo(String value) {
			obj.Motivo_de_Rechazo__c = value;
			return this;
		}

		/** (2019-06-03 15:19:10) Valores disponibles:  'Multiplicação', 'Difusão Multiplicador', 'Difusão Comercial', 'Dia de Campo', 'Lado a Lado', 'Strip Test', 'Desenvolvimento', 'Desenvolvimento Manejo', 'Desenvolvimento Rede', 'Difusão E.B.E. (Eventos / Bera de estrada)', 'Ensayo Rede', 'Ensayo Manejo', 'Difusão para Multiplicador ou Revenda (40kg)', 'Difusão GDM Comercial', 'Difusão GDM – DC /ST' */
		public OpportunityLineItemBuilder withTipodeNecesidad(String value) {
			obj.Tipo_de_Necesidad__c = value;
			return this;
		}

		/** (2021-05-31 11:00:00) Valores disponibles:  'Multiplicação', 'Difusão' */
		public OpportunityLineItemBuilder withTipoDeNecessidade(String value) {
			obj.Tipo_de_Necessidade__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withPosicionRelativaConsign(String value) {
			obj.Posicion_Relativa_Consign__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withEsPrevisao(Boolean value) {
			obj.Es_Previsao__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withTipoRegistro(String value) {
			obj.Tipo_Registro__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withQuantidade(Double value) {
			obj.Quantidade__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withSementebruta(Double value) {
			obj.Semente_bruta__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withSementebeneficiada(Double value) {
			obj.Semente_beneficiada__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withSementeaprovada(Double value) {
			obj.Semente_aprovada__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withSementeusopropio(Double value) {
			obj.Semente_uso_propio__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withSementecomercializada(Double value) {
			obj.Semente_comercializada__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withDescarte(Double value) {
			obj.Descarte__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withBlsdevolucion(Double value) {
			obj.Bls_devolucion__c = value;
			return this;
		}

		public OpportunityLineItemBuilder withLoteRebajado(String value) {
			obj.Lote_Rebajado__c = value;
			return this;
		}
 
		public OpportunityLineItem build() {
			return obj;
		}
	}

	/** It require following fields to can be inserted: OpportunityId. */
	public static OpportunityLineItemBuilder anOpportunityLineItem() { return new OpportunityLineItemBuilder(); }

	/*------------------------------------------------------------------------
	             OpportunityLineItemBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             CRMMultiplicadorBuilderStart
	------------------------------------------------------------------------*/
	public class CRMMultiplicadorBuilder {
		private CRM_Multiplicador__c obj = new CRM_Multiplicador__c();

		public CRMMultiplicadorBuilder withCuenta(Account value) {
			obj.Cuenta__c = value.Id;
			return this;
		}

		public CRMMultiplicadorBuilder withBRLXLRealizado(Double value) {
			obj.BR_LXL_Realizado__c = value;
			return this;
		}

		public CRMMultiplicadorBuilder withBRTreinamentosRealizado(Double value) {
			obj.BR_Treinamentos_Realizado__c = value;
			return this;
		}

		public CRMMultiplicadorBuilder withBRPalestrasRealizado(Double value) {
			obj.BR_Palestras_Realizado__c = value;
			return this;
		}

		public CRMMultiplicadorBuilder withBRParticipacaodiacamporealizado(Double value) {
			obj.BR_Participacao_dia_campo_realizado__c = value;
			return this;
		}

		public CRMMultiplicadorBuilder withDSParticipacadiasdecampo(Boolean value) {
			obj.DS_Participaca_dias_de_campo__c = value;
			return this;
		}

		/** (2019-06-04 10:22:06) Valores disponibles:  '11/12', '12/13', '13/14', '14/15', '15/16', '17/18', '16/17' */
		public CRMMultiplicadorBuilder withSafra(String value) {
			obj.Safra__c = value;
			return this;
		}


		public CRM_Multiplicador__c build() {
			return obj;
		}
	}

	public static CRMMultiplicadorBuilder aCRMMultiplicador() { return new CRMMultiplicadorBuilder(); }

	/*------------------------------------------------------------------------
	             CRMMultiplicadorBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             CaseBuilderStart
	------------------------------------------------------------------------*/
	public class CaseBuilder {
		private Case obj = new Case();

		public CaseBuilder withAccountId(Account value) {
			obj.AccountId = value.Id;
			return this;
		}

		public CaseBuilder withRecordTypeId(id value) {
			obj.RecordTypeId = value;
			return this;
		}

		/** (2019-05-21 13:40:38) Valores disponibles:  'En espera', 'Fechados', 'Solucionada', 'Novo', 'Pendente', 'Reclamo Comercial', 'Reclamo Comercial Aceptado', 'Reclamo Desarrollo', 'Reclamo Nuevo', 'Reclamo Desarrollo Aceptado', 'Reclamo Propuesta Cierre', 'Reclamo Rechazado', 'Reclamo Solicitud Visita Campo', 'Reclamo Visita Campo Conf', 'Reclamo en Pesquisa', 'Reclamo en Produccion', 'Reclamo Indemnización Pendiente', 'Aberta', 'Fechada', 'Cancelada', 'Reclamo en Desenvolvimento', 'Reclamo en Andamento', 'Reclamo en Propuesta de Cierre' */
		public CaseBuilder withStatus(String value) {
			obj.Status = value;
			return this;
		}

		/** (2019-05-21 13:40:38) Valores disponibles:  'El usuario no asistió a la formación', 'Funcionalidad compleja', 'Problema existente', 'Instrucciones poco claras', 'Nuevo problema', 'Atraso', 'Avaria', 'Documentação', 'Pedido', 'Transportadora' */
		public CaseBuilder withReason(String value) {
			obj.Reason = value;
			return this;
		}

		public CaseBuilder withSubject(String value) {
			obj.Subject = value;
			return this;
		}

		public CaseBuilder withDatadoproblema(Date value) {
			obj.Data_do_problema__c = value;
			return this;
		}
         
        public CaseBuilder withCiudadDelProblema(Cidade__c value) {
			obj.Ciudad_del_Problema__c = value.id;
			return this;
		}
         
        public CaseBuilder withOwnerId(id value) {
			obj.OwnerId = value;
			return this;
		}
         
        public CaseBuilder withFechaDeContacto(Date value) {
			obj.Fecha_de_Contacto__c = value;
			return this;
		}
        public CaseBuilder withResponsavel(string value) {
			obj.Responsavel__c = value;
			return this;
		}

		/** (2019-05-21 13:40:38) Valores disponibles:  'BRMX', 'DSEM' */
		public CaseBuilder withMarca(String value) {
			obj.Marca__c = value;
			return this;
		}

		public Case build() {
			return obj;
		}
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCase() { return new CaseBuilder(); }

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseFiscalizacion() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'Fiscalizacion').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseReclamo() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reclamo').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOCERRADO() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_CERRADO').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOCOMERCIAL() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_COMERCIAL').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOCOMERCIALACEPTADO() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_COMERCIAL_ACEPTADO').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOCONATENDENEDICION() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_CON_ATEND_EN_EDICION').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOCONSDESARROLLO() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_CONS_DESARROLLO').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOCONSPESQUISA() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_CONS_PESQUISA').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOCONSPRODUCCION() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_CONS_PRODUCCION').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMODESARROLLOACEPTADO() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_DESARROLLO_ACEPTADO').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOENANDAMENTO() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_EN_ANDAMENTO').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOINDEMNIZACION() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_INDEMNIZACION').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMONUEVO() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_NUEVO').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOPROPUESTACIERRE() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_PROPUESTA_CIERRE').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMORECHAZADO() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_RECHAZADO').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOSINATENDENEDICION() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_SIN_ATEND_EN_EDICION').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseReclamoVendaBasica() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'Reclamo_Venda_Basica').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOVISITACAMPO() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_VISITA_CAMPO').Id;
		return val;
	}

	/** It require following fields to can be inserted: BusinessHoursId. */
	public static CaseBuilder aCaseRECLAMOVISITACAMPOCONF() { 
		CaseBuilder val = new CaseBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Case', 'RECLAMO_VISITA_CAMPO_CONF').Id;
		return val;
	}

	/*------------------------------------------------------------------------
	             CaseBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             CidadeBuilderStart
	------------------------------------------------------------------------*/
	public class CidadeBuilder {
		private Cidade__c obj = new Cidade__c();

		public CidadeBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public CidadeBuilder withRegio(Regiao__c value) {
			obj.Regi_o__c = value.Id;
			return this;
		}

		public Cidade__c build() {
			return obj;
		}
	}

	public static CidadeBuilder aCidade() { return new CidadeBuilder(); }

	/*------------------------------------------------------------------------
	             CidadeBuilderEnd
	------------------------------------------------------------------------*/
 
	/*------------------------------------------------------------------------
	             CRMCalendariodeEventosBuilderStart
	------------------------------------------------------------------------*/
	public class CRMCalendariodeEventosBuilder {
		private CRM_Calendario_de_Eventos__c obj = new CRM_Calendario_de_Eventos__c();

		public CRMCalendariodeEventosBuilder withOwnerId(Group value) {
			obj.OwnerId = value.Id;
			return this;
		}
		public CRMCalendariodeEventosBuilder withOwnerId(User value) {
			obj.OwnerId = value.Id;
			return this;
		}

		public CRMCalendariodeEventosBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withRecordTypeId(RecordType value) {
			obj.RecordTypeId = value.Id;
			return this;
		}

		/** (2019-05-30 16:05:22) Valores disponibles:  'Día de Campo', 'Area comercial', 'Emplacamento', 'Encontro Técnico', 'Estação DONMARIO MAS', 'Feiras', 'Jornada Técnica', 'Lado a Lado', 'Painel Técnico', 'Palestra', 'Strip Test', 'Tour dos Máximos Rendimentos', 'Treinamento', 'CESB' */
		public CRMCalendariodeEventosBuilder withEvento(String value) {
			obj.Evento__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withData(Date value) {
			obj.Data__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withMunicipio(Cidade__c value) {
			obj.Municipio__c = value.Id;
			return this;
		}

		public CRMCalendariodeEventosBuilder withNumerodeparticipantess(Double value) {
			obj.Numero_de_participantess__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withCuenta(Account value) {
			obj.Cuenta__c = value.Id;
			return this;
		}

		/** (2019-05-30 16:05:22) Valores disponibles:  '11/12', '12/13', '17/18', '18/19' */
		public CRMCalendariodeEventosBuilder withSafra(String value) {
			obj.Safra__c = value;
			return this;
		}

		/** (2019-05-30 16:05:22) Valores disponibles:  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10' */
		public CRMCalendariodeEventosBuilder withEvaluacion(String value) {
			obj.Evaluacion__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withCusto(Decimal value) {
			obj.Custo__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withDireccion(String value) {
			obj.Direccion__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withParticipante(String value) {
			obj.Participante__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withHorario(String value) {
			obj.Horario__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withDataehorarioinicio(DateTime value) {
			obj.Data_e_horario_inicio__c = value;
			return this;
		}

		/** (2019-05-30 16:05:22) Valores disponibles:  'BRMX', 'DSEM' */
		public CRMCalendariodeEventosBuilder withMarca(String value) {
			obj.Marca__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withGeoreferenciaText(String value) {
			obj.Georeferencia_Text__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withLatitud(Double value) {
			obj.Latitud__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withLongitud(Double value) {
			obj.Longitud__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withRevenda(Account value) {
			obj.Revenda__c = value.Id;
			return this;
		}

		public CRMCalendariodeEventosBuilder withComentarios(String value) {
			obj.Comentarios__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withDataehorariotermino(DateTime value) {
			obj.Data_e_horario_termino__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withRealizadopor(String value) {
			obj.Realizado_por__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withNomedoagricultor(Contact value) {
			obj.Nome_do_agricultor__c = value.Id;
			return this;
		}

		public CRMCalendariodeEventosBuilder withIrrigado(Boolean value) {
			obj.Irrigado__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withFinalizado(Boolean value) {
			obj.Finalizado__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withArquivoscont(Double value) {
			obj.Arquivos_cont__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withUsarcoordenadasdaCidade(Boolean value) {
			obj.Usar_coordenadas_da_Cidade__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withCRMEventoOffline(CRM_Evento_Offline__c value) {
			obj.CRM_Evento_Offline__c = value.Id;
			return this;
		}

		/** (2019-05-30 16:05:22) Valores disponibles:  'Edição', 'Pendente', 'Aprovado', 'Reprovado', 'Anulado' */
		public CRMCalendariodeEventosBuilder withFase(String value) {
			obj.Fase__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withNomedoagricultor2(String value) {
			obj.Nome_do_agricultor_2__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withRevenda2(String value) {
			obj.Revenda_2__c = value;
			return this;
		}

		/** (2019-05-30 16:05:22) Valores disponibles:  'CPF', 'CNPJ' */
		public CRMCalendariodeEventosBuilder withTipoContaAgricultor(String value) {
			obj.Tipo_Conta_Agricultor__c = value;
			return this;
		}

		/** (2019-05-30 16:05:22) Valores disponibles:  'CPF', 'CNPJ' */
		public CRMCalendariodeEventosBuilder withTipoContaRevenda(String value) {
			obj.Tipo_Conta_Revenda__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withCNPJCPFAgricultor(String value) {
			obj.CNPJ_CPF_Agricultor__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withCNPJCPFRevenda(String value) {
			obj.CNPJ_CPF_Revenda__c = value;
			return this;
		}

		public CRMCalendariodeEventosBuilder withAgricultor(Account value) {
			obj.Agricultor__c = value.Id;
			return this;
		}

		public CRMCalendariodeEventosBuilder withUsuario(SiteUser__c value) {
			obj.Usuario__c = value.Id;
			return this;
		}

		public CRM_Calendario_de_Eventos__c build() {
			return obj;
		}
	}

	public static CRMCalendariodeEventosBuilder aCRMCalendariodeEventos() { return new CRMCalendariodeEventosBuilder(); }

	public static CRMCalendariodeEventosBuilder aCRMCalendariodeEventoscompleto() { 
		CRMCalendariodeEventosBuilder val = new CRMCalendariodeEventosBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('CRM_Calendario_de_Eventos__c', 'completo').Id;
		return val;
	}

	public static CRMCalendariodeEventosBuilder aCRMCalendariodeEventosDiadeCampo() { 
		CRMCalendariodeEventosBuilder val = new CRMCalendariodeEventosBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('CRM_Calendario_de_Eventos__c', 'Dia_de_Campo').Id;
		return val;
	}

	public static CRMCalendariodeEventosBuilder aCRMCalendariodeEventosEmplacamento() { 
		CRMCalendariodeEventosBuilder val = new CRMCalendariodeEventosBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('CRM_Calendario_de_Eventos__c', 'Emplacamento').Id;
		return val;
	}

	public static CRMCalendariodeEventosBuilder aCRMCalendariodeEventosTestacampo() { 
		CRMCalendariodeEventosBuilder val = new CRMCalendariodeEventosBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('CRM_Calendario_de_Eventos__c', 'Test_a_campo').Id;
		return val;
	}

	public static CRMCalendariodeEventosBuilder aCRMCalendariodeEventosTreinamentoTecnico() { 
		CRMCalendariodeEventosBuilder val = new CRMCalendariodeEventosBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('CRM_Calendario_de_Eventos__c', 'Treinamento_Tecnico').Id;
		return val;
	}

	/*------------------------------------------------------------------------
	             CRMCalendariodeEventosBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             AttachmentBuilderStart
	------------------------------------------------------------------------*/
	public class AttachmentBuilder {
		private Attachment obj = new Attachment(Name = 'STRING',
			Body = Blob.valueOf('SOME DATE')
		);

		public AttachmentBuilder withParentId(Account value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Analisis_de_Datos__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Analitica_DemandaVsVenta__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Area_Plantada__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Asignacion_de_Oferta__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Asset value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Bitacora_NC__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(CRM_Area_de_Atuacion__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(CRM_Bonificacion__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(CRM_Calendario_de_Eventos__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(CRM_Detalhe_de_Perfil_da_Conta__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(CRM_Detalle_Calendario_de_eventos__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(CRM_Evento_Offline__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(CRM_Infraestructura__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(CRM_Multiplicador__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(CRM_Vendas__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Cambios_OLI__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Campaign value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Canal_de_Venda__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Case value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Categoria__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Centro_Logistico__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Centro_de_CO_Item__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Centro_de_CO__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Cidade__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Configuracion_BMX__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Contact value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Contract value) {
			obj.ParentId = value.Id;
			return this;
		}
		public AttachmentBuilder withParentId(Contrato__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Cotizacion_Soja__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(EmailMessage value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(EmailTemplate value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Empresa__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Estado__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Event value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Flujo_Doc_tmp__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(INCIDENTES_SISTEMAS__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Item_del_Contrato__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Lead value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Local__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Lote__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Macrorregi_o_de_Vendas__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Market_Share__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Microrregi_o_de_Vendas__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Opportunity value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Pagamento__c value) {
			obj.ParentId = value.Id;
			return this; 
		}

		public AttachmentBuilder withParentId(Produccion_Basica__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Product2 value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Proyecto_sistemas__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Referencia_de_Praca__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Referencia_de_Preco__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Referencia_de_Preco_sugerido__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Regiao__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Registro_de_Eliminacion__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(SFGA__Ad_Group__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(SFGA__Google_Campaign__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(SFGA__Keyword__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(SFGA__Search_Phrase__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(SFGA__Text_Ad__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(SFGA__Version_33_0_3__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Segmentacion__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(SiteUserAccount__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(SiteUserSession__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(SiteUser__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(SocialPost value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Solution value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Task value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Taxas_Fiscais__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Variedad__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Visita_a_Clientes__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Votacion__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(Votacion_balotage__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withParentId(rea_de_Atua_o__c value) {
			obj.ParentId = value.Id;
			return this;
		}

		public AttachmentBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public AttachmentBuilder withBody(String value) {
			obj.Body = Blob.valueOf(value);
			return this;
		}

		public Attachment build() {
			return obj;
		}
	}

	/** It require following fields to can be inserted: ParentId. */
	public static AttachmentBuilder anAttachment() { return new AttachmentBuilder(); }

	/*------------------------------------------------------------------------
	             AttachmentBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             ContratoBuilderStart
	------------------------------------------------------------------------*/
	public class ContratoBuilder {
		private Contrato__c obj = new Contrato__c();

		public ContratoBuilder withMultiplicador(Account value) {
			obj.Multiplicador__c = value.Id;
			return this;
		}

		public ContratoBuilder withRecordTypeId(ID value) {
			obj.RecordTypeId = value;
			return this;
		}

		public ContratoBuilder withRecordTypeId(RecordType value) {
			obj.RecordTypeId = value.id;
			return this;
		}

		public ContratoBuilder withContratomarcoNull() {
			obj.Contrato_marco__c = null;
			return this;
		}
		public ContratoBuilder withContratomarco(Contrato__c val) {
			obj.Contrato_marco__c = val.id;
			return this;
		}

		/** (2019-05-27 09:29:57) Valores disponibles:  '17/18', '18/19', '19/20', '20/21' */
		public ContratoBuilder withSafra(String value) {
			obj.Safra__c = value;
			return this;
		}

		/** (2019-05-27 09:29:57) Valores disponibles:  'BRMX', 'DSEM' */
		public ContratoBuilder withSociedad(String value) {
			obj.Sociedad__c = value;
			return this;
		}

		/** (2019-05-27 15:00:01) Valores disponibles:  'DOLAR', 'SOJA', 'FATURAMENTO' */
		public ContratoBuilder withTipodeCotao(String value) {
			obj.Tipo_de_Cota_o__c = value;
			return this;
		}

		public Contrato__c build() {
			return obj;
		}
	}

	public static ContratoBuilder aContrato() { return new ContratoBuilder(); }

	public static ContratoBuilder aContratoAditivoPorcentajeBRMX() { 
		ContratoBuilder val = new ContratoBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Contrato__c', 'Aditivo_Porcentaje_BRMX').Id;
		return val;
	}

	public static ContratoBuilder aContratoAditivoPorcentajeDSEM() { 
		ContratoBuilder val = new ContratoBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Contrato__c', 'Aditivo_Porcentaje_DSEM').Id;
		return val;
	}

	public static ContratoBuilder aContratoAditivoBRMX() { 
		ContratoBuilder val = new ContratoBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Contrato__c', 'Aditivo_BRMX').Id;
		return val;
	}

	public static ContratoBuilder aContratoAditivoDSEM() { 
		ContratoBuilder val = new ContratoBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Contrato__c', 'Aditivo_DSEM').Id;
		return val;
	}

	public static ContratoBuilder aContratoBRMX() { 
		ContratoBuilder val = new ContratoBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Contrato__c', 'BRMX').Id;
		return val;
	}

	public static ContratoBuilder aContratoDSEM() { 
		ContratoBuilder val = new ContratoBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Contrato__c', 'DSEM').Id;
		return val;
	}

	public static ContratoBuilder aContratoTermoAditivo() { 
		ContratoBuilder val = new ContratoBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Contrato__c', 'Termo_Aditivo').Id;
		return val;
	}

	/*------------------------------------------------------------------------
	             ContratoBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             ContractBuilderStart
	------------------------------------------------------------------------*/
	public class ContractBuilder {
		private Contract obj = new Contract(Status = 'Edição');

		public ContractBuilder withAccountId(Account value) {
			obj.AccountId = value.Id;
			return this;
		}

		public ContractBuilder withDescription(String value) {
			obj.Description = value;
			return this;
		}

		public ContractBuilder withSafras(String value) {
			obj.Safras__c = value;
			return this;
		}

		/** (2019-05-27 09:44:23) Valores disponibles:  'BRMX', 'DSEM' */
		public ContractBuilder withSociedad(String value) {
			obj.Sociedad__c = value;
			return this;
		}

		public Contract build() {
			return obj;
		}
	}

	/** It require following fields to can be inserted: AccountId. */
	public static ContractBuilder aContract() { return new ContractBuilder(); }

	/*------------------------------------------------------------------------
	             ContractBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             ItemdelContratoBuilderStart
	------------------------------------------------------------------------*/
	 public class ItemdelContratoBuilder {
		private Item_del_Contrato__c obj = new Item_del_Contrato__c();

		public ItemdelContratoBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public ItemdelContratoBuilder withContratodeMultiplicacion(Contrato__c value) {
			obj.Contrato_de_Multiplicacion__c = value.Id;
			return this;
		}

		public Item_del_Contrato__c build() {
			return obj;
		}
	}

	/** It require following fields to can be inserted: Contrato_de_Multiplicacion__c. */
	public static ItemdelContratoBuilder anItemdelContrato() { return new ItemdelContratoBuilder(); }

	/** It require following fields to can be inserted: Contrato_de_Multiplicacion__c. */
	public static ItemdelContratoBuilder anItemdelContratoMetas() { 
		ItemdelContratoBuilder val = new ItemdelContratoBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Item_del_Contrato__c', 'Metas').Id;
		return val;
	}

	/** It require following fields to can be inserted: Contrato_de_Multiplicacion__c. */
	public static ItemdelContratoBuilder anItemdelContratoMetascultivar() { 
		ItemdelContratoBuilder val = new ItemdelContratoBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Item_del_Contrato__c', 'Metas_cultivar').Id;
		return val;
	}

	/** It require following fields to can be inserted: Contrato_de_Multiplicacion__c. */
	public static ItemdelContratoBuilder anItemdelContratoMetasxestado() { 
		ItemdelContratoBuilder val = new ItemdelContratoBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Item_del_Contrato__c', 'Metas_x_estado').Id;
		return val;
	}

	/** It require following fields to can be inserted: Contrato_de_Multiplicacion__c. */
	public static ItemdelContratoBuilder anItemdelContratoVolumen() { 
		ItemdelContratoBuilder val = new ItemdelContratoBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Item_del_Contrato__c', 'Volumen').Id;
		return val;
	}

	/*------------------------------------------------------------------------
	             ItemdelContratoBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             AnaliticaDemandaVsVentaBuilderStart
	------------------------------------------------------------------------*/
	public class AnaliticaDemandaVsVentaBuilder {
		private Analitica_DemandaVsVenta__c obj = new Analitica_DemandaVsVenta__c();

		public AnaliticaDemandaVsVentaBuilder withProducto(Product2 value) {
			obj.Producto__c = value.Id;
			return this;
		}

		public AnaliticaDemandaVsVentaBuilder withProductName(String value) {
			obj.ProductName__c = value;
			return this;
		}

		public Analitica_DemandaVsVenta__c build() {
			return obj;
		}
	}

	public static AnaliticaDemandaVsVentaBuilder anAnaliticaDemandaVsVenta() { return new AnaliticaDemandaVsVentaBuilder(); }

	/*------------------------------------------------------------------------
	             AnaliticaDemandaVsVentaBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             CRMDetalleCalendariodeeventosBuilderStart
	------------------------------------------------------------------------*/
	public class CRMDetalleCalendariodeeventosBuilder {
		private CRM_Detalle_Calendario_de_eventos__c obj = new CRM_Detalle_Calendario_de_eventos__c();

		public CRMDetalleCalendariodeeventosBuilder withAreaColhida(Double value) {
			obj.Area_Colhida__c = value;
			return this;
		}

		public CRMDetalleCalendariodeeventosBuilder withCRMCalendariodeeventos(CRM_Calendario_de_Eventos__c value) {
			obj.CRM_Calendario_de_eventos__c = value.Id;
			return this;
		}

		public CRMDetalleCalendariodeeventosBuilder withCultivar(Product2 value) {
			obj.Cultivar__c = value.Id;
			return this;
		}

		public CRMDetalleCalendariodeeventosBuilder withProdutividade(Double value) {
			obj.Produtividade__c = value;
			return this;
		}

		public CRMDetalleCalendariodeeventosBuilder withDatadeplantio(Date value) {
			obj.Data_de_plantio__c = value;
			return this;
		}

		public CRMDetalleCalendariodeeventosBuilder withDatadecolheita(Date value) {
			obj.Data_de_colheita__c = value;
			return this;
		}

		public CRMDetalleCalendariodeeventosBuilder withObtentor(String value) {
			obj.Obtentor__c = value;
			return this;
		}

		public CRMDetalleCalendariodeeventosBuilder withIndice(Double value) {
			obj.Indice__c = value;
			return this;
		}

		public CRMDetalleCalendariodeeventosBuilder withAreaplantada(Double value) {
			obj.Area_plantada__c = value;
			return this;
		}

		public CRMDetalleCalendariodeeventosBuilder withVolumeDoado(Double value) {
			obj.Volume_Doado__c = value;
			return this;
		}
		
		public CRM_Detalle_Calendario_de_eventos__c build() {
			return obj;
		}
	}

	/** It require following fields to can be inserted: CRM_Calendario_de_eventos__c. */
	public static CRMDetalleCalendariodeeventosBuilder aCRMDetalleCalendariodeeventos() { return new CRMDetalleCalendariodeeventosBuilder(); }

	/*------------------------------------------------------------------------
	             CRMDetalleCalendariodeeventosBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             EventBuilderStart
	------------------------------------------------------------------------*/
	public class EventBuilder {
		private Event obj = new Event();

		public EventBuilder withWhoId(Contact value) {
			 obj.WhoId = value.Id;
			 return this;
		}
		public EventBuilder withWhoId(Lead value) {
			 obj.WhoId = value.Id;
			 return this;
		}

		public EventBuilder withWhatId(Account value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Asset value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(AssetRelationship value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Bitacora_NC__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(CRM_Calendario_de_Eventos__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(CRM_Detalhe_de_Perfil_da_Conta__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(CRM_Infraestructura__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(CRM_Multiplicador__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(CRM_Vendas__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Campaign value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Canal_de_Venda__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Case value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Configuracion_BMX__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Contract value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Contrato__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Flujo_Doc_tmp__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(INCIDENTES_SISTEMAS__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Item_del_Contrato__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(ListEmail value) {
			 obj.WhatId = value.Id;
			 return this;
		}

		public EventBuilder withWhatId(Opportunity value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Product2 value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Proyecto_sistemas__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Segmentacion__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Solution value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(Visita_a_Clientes__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}
		public EventBuilder withWhatId(rea_de_Atua_o__c value) {
			 obj.WhatId = value.Id;
			 return this;
		}

		public EventBuilder withSubject(String value) {
			 obj.Subject = value;
			 return this;
		}

		public EventBuilder withLocation(String value) {
			 obj.Location = value;
			 return this;
		}

		public EventBuilder withIsAllDayEvent(Boolean value) {
			 obj.IsAllDayEvent = value;
			 return this;
		}

		public EventBuilder withActivityDateTime(DateTime value) {
			 obj.ActivityDateTime = value;
			 return this;
		}

		public EventBuilder withActivityDate(Date value) {
			 obj.ActivityDate = value;
			 return this;
		}

		public EventBuilder withDurationInMinutes(Integer value) {
			 obj.DurationInMinutes = value;
			 return this;
		}

		public EventBuilder withStartDateTime(DateTime value) {
			 obj.StartDateTime = value;
			 return this;
		}

		public EventBuilder withEndDateTime(DateTime value) {
			 obj.EndDateTime = value;
			 return this;
		}

		public EventBuilder withDescription(String value) {
			 obj.Description = value;
			 return this;
		}

		public EventBuilder withOwnerId(User value) {
			 obj.OwnerId = value.Id;
			 return this;
		}

		public EventBuilder withIsPrivate(Boolean value) {
			 obj.IsPrivate = value;
			 return this;
		}

		/** (2019-05-30 10:55:04) Valores disponibles:  'Busy', 'OutOfOffice', 'Free' */
		public EventBuilder withShowAs(String value) {
			 obj.ShowAs = value;
			 return this;
		}

		public EventBuilder withIsRecurrence(Boolean value) {
			 obj.IsRecurrence = value;
			 return this;
		}

		public EventBuilder withRecurrenceStartDateTime(DateTime value) {
			 obj.RecurrenceStartDateTime = value;
			 return this;
		}

		public EventBuilder withRecurrenceEndDateOnly(Date value) {
			 obj.RecurrenceEndDateOnly = value;
			 return this;
		}

		/** (2019-05-30 10:55:04) Valores disponibles:  'Pacific/Kiritimati', 'Pacific/Enderbury', 'Pacific/Tongatapu', 'Pacific/Chatham', 'Asia/Kamchatka', 'Pacific/Auckland', 'Pacific/Fiji', 'Pacific/Guadalcanal', 'Pacific/Norfolk', 'Australia/Lord_Howe', 'Australia/Brisbane', 'Australia/Sydney', 'Australia/Adelaide', 'Australia/Darwin', 'Asia/Seoul', 'Asia/Tokyo', 'Asia/Hong_Kong', 'Asia/Kuala_Lumpur', 'Asia/Manila', 'Asia/Shanghai', 'Asia/Singapore', 'Asia/Taipei', 'Australia/Perth', 'Asia/Bangkok', 'Asia/Ho_Chi_Minh', 'Asia/Jakarta', 'Asia/Rangoon', 'Asia/Dhaka', 'Asia/Kathmandu', 'Asia/Colombo', 'Asia/Kolkata', 'Asia/Karachi', 'Asia/Tashkent', 'Asia/Yekaterinburg', 'Asia/Kabul', 'Asia/Tehran', 'Asia/Baku', 'Asia/Dubai', 'Asia/Tbilisi', 'Asia/Yerevan', 'Africa/Nairobi', 'Asia/Baghdad', 'Asia/Beirut', 'Asia/Jerusalem', 'Asia/Kuwait', 'Asia/Riyadh', 'Europe/Athens', 'Europe/Bucharest', 'Europe/Helsinki', 'Europe/Istanbul', 'Europe/Minsk', 'Europe/Moscow', 'Africa/Cairo', 'Africa/Johannesburg', 'Europe/Amsterdam', 'Europe/Berlin', 'Europe/Brussels', 'Europe/Paris', 'Europe/Prague', 'Europe/Rome', 'Africa/Algiers', 'Africa/Casablanca', 'Europe/Dublin', 'Europe/Lisbon', 'Europe/London', 'America/Scoresbysund', 'Atlantic/Azores', 'GMT', 'Atlantic/Cape_Verde', 'Atlantic/South_Georgia', 'America/St_Johns', 'America/Argentina/Buenos_Aires', 'America/Halifax', 'America/Sao_Paulo', 'Atlantic/Bermuda', 'America/Caracas', 'America/Indiana/Indianapolis', 'America/New_York', 'America/Puerto_Rico', 'America/Santiago', 'America/Bogota', 'America/Chicago', 'America/Lima', 'America/Mexico_City', 'America/Panama', 'America/Denver', 'America/El_Salvador', 'America/Mazatlan', 'America/Los_Angeles', 'America/Phoenix', 'America/Tijuana', 'America/Anchorage', 'Pacific/Pitcairn', 'America/Adak', 'Pacific/Gambier', 'Pacific/Marquesas', 'Pacific/Honolulu', 'Pacific/Niue', 'Pacific/Pago_Pago' */
		public EventBuilder withRecurrenceTimeZoneSidKey(String value) {
			 obj.RecurrenceTimeZoneSidKey = value;
			 return this;
		}

		/** (2019-05-30 10:55:04) Valores disponibles:  'RecursDaily', 'RecursEveryWeekday', 'RecursMonthly', 'RecursMonthlyNth', 'RecursWeekly', 'RecursYearly', 'RecursYearlyNth' */
		public EventBuilder withRecurrenceType(String value) {
			 obj.RecurrenceType = value;
			 return this;
		}

		public EventBuilder withRecurrenceInterval(Integer value) {
			 obj.RecurrenceInterval = value;
			 return this;
		}

		public EventBuilder withRecurrenceDayOfWeekMask(Integer value) {
			 obj.RecurrenceDayOfWeekMask = value;
			 return this;
		}

		public EventBuilder withRecurrenceDayOfMonth(Integer value) {
			 obj.RecurrenceDayOfMonth = value;
			 return this;
		}

		/** (2019-05-30 10:55:04) Valores disponibles:  'First', 'Second', 'Third', 'Fourth', 'Last' */
		public EventBuilder withRecurrenceInstance(String value) {
			 obj.RecurrenceInstance = value;
			 return this;
		}

		/** (2019-05-30 10:55:04) Valores disponibles:  'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' */
		public EventBuilder withRecurrenceMonthOfYear(String value) {
			 obj.RecurrenceMonthOfYear = value;
			 return this;
		}

		public EventBuilder withReminderDateTime(DateTime value) {
			 obj.ReminderDateTime = value;
			 return this;
		}

		public EventBuilder withIsReminderSet(Boolean value) {
			 obj.IsReminderSet = value;
			 return this;
		}

		/** (2019-05-30 10:55:04) Valores disponibles:  'Event' */
		public EventBuilder withEventSubtype(String value) {
			 obj.EventSubtype = value;
			 return this;
		}

		public EventBuilder withMarcacomercial(String value) {
			 obj.Marca_comercial__c = value;
			 return this;
		}

		/** (2019-05-30 10:55:04) Valores disponibles:  'Día de Campo', 'Treinamento', 'Palestra', 'Apresentação de dados, novos produtos e novos projetos', 'Contrato de multiplicação', 'Ensaio de manejo', 'Combate à Pirataria', 'Relatório Semanal', 'Reunião', 'Contato Telefônico', 'Observações Gerais', 'Visita aos Produtores' */
		public EventBuilder withEvento(String value) {
			 obj.Evento__c = value;
			 return this;
		}

		public EventBuilder withCRMCalendariodeeventos(String value) {
			 obj.CRM_Calendario_de_eventos__c = value;
			 return this;
		}

		public EventBuilder withNombreProductor(String value) {
			 obj.Nombre_Productor__c = value;
			 return this;
		}

		/** (2019-05-30 10:55:04) Valores disponibles:  'Día de Campo', 'Lado a Lado', 'Palestra', 'Emplacamentos de Rodovias', 'Treinamento', 'Encontro Técnico', 'Jornada Técnica' */
		public EventBuilder withTipodeevento(String value) {
			 obj.Tipo_de_evento__c = value;
			 return this;
		}

		public EventBuilder withNumerodeparticipantes(Double value) {
			 obj.Numero_de_participantes__c = value;
			 return this;
		}

		/** (2019-05-30 10:55:04) Valores disponibles:  'Muito ruim', 'Ruim', 'Regular', 'Bom', 'Muito bom' */
		public EventBuilder withStatusdoevento(String value) {
			 obj.Status_do_evento__c = value;
			 return this;
		}

		public EventBuilder withRelatorioRelacionado(Visita_a_Clientes__c value) {
			 obj.Relatorio_Relacionado__c = value.Id;
			 return this;
		}

		public EventBuilder withCiudad(Cidade__c value) {
			 obj.Ciudad__c = value.Id;
			 return this;
		}

		public EventBuilder withorden(Double value) {
			 obj.orden__c = value;
			 return this;
		}

		public EventBuilder withiddeCiudad(String value) {
			 obj.id_de_Ciudad__c = value;
			 return this;
		}

		public EventBuilder withiddeRelatorio(String value) {
			 obj.id_de_Relatorio__c = value;
			 return this;
		}

		 public Event build() {
			 return obj;
		}
	}

	public static EventBuilder anEvent() { return new EventBuilder(); }

	/*------------------------------------------------------------------------
	             EventBuilderEnd
	------------------------------------------------------------------------*/
	
	/*------------------------------------------------------------------------
	             UserBuilderStart
	------------------------------------------------------------------------*/
	public class UserBuilder {
		private User obj = new User(
			Username = 'STRING',
			LastName = 'STRING',
			Email = 'SOME DATE',
			Alias = 'STRING',
			CommunityNickname = 'STRING',
			TimeZoneSidKey = 'GMT',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			DigestFrequency = 'D',
			DefaultGroupNotificationFrequency = 'P'
		);

		public UserBuilder withUsername(String value) {
			obj.Username = value;
			return this;
		}

		public UserBuilder withLastName(String value) {
			obj.LastName = value;
			return this;
		}

		public UserBuilder withFirstName(String value) {
			obj.FirstName = value;
			return this;
		}

		public UserBuilder withCompanyName(String value) {
			obj.CompanyName = value;
			return this;
		}

		public UserBuilder withDivision(String value) {
			obj.Division = value;
			return this;
		}

		public UserBuilder withDepartment(String value) {
			obj.Department = value;
			return this;
		}

		public UserBuilder withTitle(String value) {
			obj.Title = value;
			return this;
		}

		public UserBuilder withStreet(String value) {
			obj.Street = value;
			return this;
		}

		public UserBuilder withCity(String value) {
			obj.City = value;
			return this;
		}

		public UserBuilder withState(String value) {
			obj.State = value;
			return this;
		}

		public UserBuilder withPostalCode(String value) {
			obj.PostalCode = value;
			return this;
		}

		public UserBuilder withCountry(String value) {
			obj.Country = value;
			return this;
		}

		public UserBuilder withLatitude(Double value) {
			obj.Latitude = value;
			return this;
		}

		public UserBuilder withLongitude(Double value) {
			obj.Longitude = value;
			return this;
		}

		/** (2019-05-30 12:56:39) Valores disponibles:  'Address', 'NearAddress', 'Block', 'Street', 'ExtendedZip', 'Zip', 'Neighborhood', 'City', 'County', 'State', 'Unknown' */
		public UserBuilder withGeocodeAccuracy(String value) {
			 obj.GeocodeAccuracy = value;
			 return this;
		}

		public UserBuilder withEmail(String value) {
			 obj.Email = value;
			 return this;
		}

		public UserBuilder withEmailPreferencesAutoBcc(Boolean value) {
			 obj.EmailPreferencesAutoBcc = value;
			 return this;
		}

		public UserBuilder withEmailPreferencesAutoBccStayInTouch(Boolean value) {
			 obj.EmailPreferencesAutoBccStayInTouch = value;
			 return this;
		}

		public UserBuilder withEmailPreferencesStayInTouchReminder(Boolean value) {
			 obj.EmailPreferencesStayInTouchReminder = value;
			 return this;
		}

		public UserBuilder withSenderEmail(String value) {
			 obj.SenderEmail = value;
			 return this;
		}

		public UserBuilder withSenderName(String value) {
			 obj.SenderName = value;
			 return this;
		}

		public UserBuilder withSignature(String value) {
			 obj.Signature = value;
			 return this;
		}

		public UserBuilder withStayInTouchSubject(String value) {
			 obj.StayInTouchSubject = value;
			 return this;
		}

		public UserBuilder withStayInTouchSignature(String value) {
			 obj.StayInTouchSignature = value;
			 return this;
		}

		public UserBuilder withStayInTouchNote(String value) {
			 obj.StayInTouchNote = value;
			 return this;
		}

		public UserBuilder withPhone(String value) {
			 obj.Phone = value;
			 return this;
		}

		public UserBuilder withFax(String value) {
			 obj.Fax = value;
			 return this;
		}

		public UserBuilder withMobilePhone(String value) {
			 obj.MobilePhone = value;
			 return this;
		}

		public UserBuilder withAlias(String value) {
			 obj.Alias = value;
			 return this;
		}

		public UserBuilder withCommunityNickname(String value) {
			 obj.CommunityNickname = value;
			 return this;
		}

		public UserBuilder withIsActive(Boolean value) {
			 obj.IsActive = value;
			 return this;
		}

		/** (2019-05-30 12:56:39) Valores disponibles:  'Pacific/Kiritimati', 'Pacific/Enderbury', 'Pacific/Tongatapu', 'Pacific/Chatham', 'Asia/Kamchatka', 'Pacific/Auckland', 'Pacific/Fiji', 'Pacific/Guadalcanal', 'Pacific/Norfolk', 'Australia/Lord_Howe', 'Australia/Brisbane', 'Australia/Sydney', 'Australia/Adelaide', 'Australia/Darwin', 'Asia/Seoul', 'Asia/Tokyo', 'Asia/Hong_Kong', 'Asia/Kuala_Lumpur', 'Asia/Manila', 'Asia/Shanghai', 'Asia/Singapore', 'Asia/Taipei', 'Australia/Perth', 'Asia/Bangkok', 'Asia/Ho_Chi_Minh', 'Asia/Jakarta', 'Asia/Rangoon', 'Asia/Dhaka', 'Asia/Kathmandu', 'Asia/Colombo', 'Asia/Kolkata', 'Asia/Karachi', 'Asia/Tashkent', 'Asia/Yekaterinburg', 'Asia/Kabul', 'Asia/Tehran', 'Asia/Baku', 'Asia/Dubai', 'Asia/Tbilisi', 'Asia/Yerevan', 'Africa/Nairobi', 'Asia/Baghdad', 'Asia/Beirut', 'Asia/Jerusalem', 'Asia/Kuwait', 'Asia/Riyadh', 'Europe/Athens', 'Europe/Bucharest', 'Europe/Helsinki', 'Europe/Istanbul', 'Europe/Minsk', 'Europe/Moscow', 'Africa/Cairo', 'Africa/Johannesburg', 'Europe/Amsterdam', 'Europe/Berlin', 'Europe/Brussels', 'Europe/Paris', 'Europe/Prague', 'Europe/Rome', 'Africa/Algiers', 'Africa/Casablanca', 'Europe/Dublin', 'Europe/Lisbon', 'Europe/London', 'America/Scoresbysund', 'Atlantic/Azores', 'GMT', 'Atlantic/Cape_Verde', 'Atlantic/South_Georgia', 'America/St_Johns', 'America/Argentina/Buenos_Aires', 'America/Halifax', 'America/Sao_Paulo', 'Atlantic/Bermuda', 'America/Caracas', 'America/Indiana/Indianapolis', 'America/New_York', 'America/Puerto_Rico', 'America/Santiago', 'America/Bogota', 'America/Chicago', 'America/Lima', 'America/Mexico_City', 'America/Panama', 'America/Denver', 'America/El_Salvador', 'America/Mazatlan', 'America/Los_Angeles', 'America/Phoenix', 'America/Tijuana', 'America/Anchorage', 'Pacific/Pitcairn', 'America/Adak', 'Pacific/Gambier', 'Pacific/Marquesas', 'Pacific/Honolulu', 'Pacific/Niue', 'Pacific/Pago_Pago' */
		public UserBuilder withTimeZoneSidKey(String value) {
			 obj.TimeZoneSidKey = value;
			 return this;
		}

		public UserBuilder withUserRoleId(UserRole value) {
			 obj.UserRoleId = value.Id;
			 return this;
		}

		/** (2019-05-30 12:56:39) Valores disponibles:  'sq', 'sq_AL', 'de', 'de_DE_EURO', 'de_DE', 'de_AT_EURO', 'de_AT', 'de_BE', 'de_LU_EURO', 'de_LU', 'de_CH', 'ar', 'ar_SA', 'ar_DZ', 'ar_BH', 'ar_EG', 'ar_AE', 'ar_IQ', 'ar_JO', 'ar_KW', 'ar_LB', 'ar_LY', 'ar_MA', 'ar_OM', 'ar_QA', 'ar_SY', 'ar_SD', 'ar_TN', 'ar_YE', 'hy', 'hy_AM', 'az_AZ', 'bn', 'bn_BD', 'be_BY', 'my_MM', 'bs', 'bs_BA', 'bg', 'bg_BG', 'ca', 'ca_ES_EURO', 'ca_ES', 'cs', 'cs_CZ', 'zh', 'zh_CN_PINYIN', 'zh_CN_STROKE', 'zh_CN', 'zh_HK', 'zh_MO', 'zh_HK_STROKE', 'zh_SG', 'zh_TW_STROKE', 'zh_TW', 'ko', 'ko_KP', 'ko_KR', 'hr', 'hr_HR', 'da', 'da_DK', 'dz_BT', 'sk', 'sk_SK', 'sl', 'sl_SI', 'es', 'es_AR', 'es_BO', 'es_CL', 'es_CO', 'es_CR', 'es_CU', 'es_EC', 'es_SV', 'es_ES_EURO', 'es_ES', 'es_US', 'es_GT', 'es_HN', 'es_MX', 'es_NI', 'es_PA', 'es_PY', 'es_PE', 'es_PR', 'es_DO', 'es_UY', 'es_VE', 'et', 'et_EE', 'fi', 'fi_FI_EURO', 'fi_FI', 'fr', 'fr_BE', 'fr_CA', 'fr_KM', 'fr_FR_EURO', 'fr_FR', 'fr_GN', 'fr_HT', 'fr_LU', 'fr_MR', 'fr_MC', 'fr_CH', 'fr_WF', 'cy', 'cy_GB', 'ka', 'ka_GE', 'el', 'el_GR', 'iw', 'iw_IL', 'hi', 'hi_IN', 'hu', 'hu_HU', 'in', 'in_ID', 'en_AG', 'en_AU', 'en_BS', 'en_BB', 'en_BZ', 'en_BM', 'en_BW', 'en_CM', 'en_CA', 'en_ER', 'en_US', 'en_PH', 'en_FJ', 'en_GM', 'en_GH', 'en_GI', 'en_GY', 'en_HK', 'en_IN', 'en_ID', 'en_IE_EURO', 'en_IE', 'en_KY', 'en_FK', 'en_SB', 'en_JM', 'en_KE', 'en_LR', 'en_MG', 'en_MY', 'en_MW', 'en_MU', 'en_NA', 'en_NG', 'en_NZ', 'en_PG', 'en_PK', 'en_GB', 'en_RW', 'en_WS', 'en_SX', 'en_SH', 'en_SC', 'en_SL', 'en_SG', 'en_SZ', 'en_ZA', 'en_TZ', 'en_TO', 'en_TT', 'en_UG', 'en_VU', 'ga', 'ga_IE', 'is', 'is_IS', 'it', 'it_IT', 'it_CH', 'ja', 'ja_JP', 'km_KH', 'kk_KZ', 'ky_KG', 'rn_BI', 'lo_LA', 'lv', 'lv_LV', 'lt', 'lt_LT', 'lu_CD', 'lb', 'lb_LU', 'mk', 'mk_MK', 'ms', 'ms_BN', 'ms_MY', 'mt', 'mt_MT', 'sh_ME', 'nl', 'nl_AW', 'nl_BE', 'nl_NL', 'nl_SR', 'ne_NP', 'no', 'no_NO', 'ps_AF', 'fa_IR', 'pl', 'pl_PL', 'pt', 'pt_AO', 'pt_BR', 'pt_CV', 'pt_MZ', 'pt_PT', 'pt_ST', 'rm', 'rm_CH', 'ro', 'ro_MD', 'ro_RO', 'ru', 'ru_RU', 'sr', 'sr_BA', 'sr_CS', 'sh_BA', 'sh_CS', 'sh', 'sr_RS', 'so_SO', 'so_DJ', 'sv', 'sv_SE', 'tl', 'tl_PH', 'th', 'th_TH', 'ta', 'ta_IN', 'ta_LK', 'tg_TJ', 'ti_ET', 'tr', 'tr_TR', 'uk', 'uk_UA', 'ur', 'ur_PK', 'uz_LATN_UZ', 'eu', 'eu_ES', 'vi', 'vi_VN', 'yo_BJ' */
		public UserBuilder withLocaleSidKey(String value) {
			 obj.LocaleSidKey = value;
			 return this;
		}

		public UserBuilder withReceivesInfoEmails(Boolean value) {
			 obj.ReceivesInfoEmails = value;
			 return this;
		}

		public UserBuilder withReceivesAdminInfoEmails(Boolean value) {
			 obj.ReceivesAdminInfoEmails = value;
			 return this;
		}

		/** (2019-05-30 12:56:39) Valores disponibles:  'UTF-8', 'ISO-8859-1', 'Shift_JIS', 'ISO-2022-JP', 'EUC-JP', 'ks_c_5601-1987', 'Big5', 'GB2312', 'Big5-HKSCS', 'x-SJIS_0213' */
		public UserBuilder withEmailEncodingKey(String value) {
			 obj.EmailEncodingKey = value;
			 return this;
		}

		public UserBuilder withProfileId(Profile value) {
			 obj.ProfileId = value.Id;
			 return this;
		}

		/** (2019-05-30 12:56:39) Valores disponibles:  'en_US', 'de', 'es', 'fr', 'it', 'ja', 'sv', 'ko', 'zh_TW', 'zh_CN', 'pt_BR', 'nl_NL', 'da', 'th', 'fi', 'ru', 'es_MX', 'no' */
		public UserBuilder withLanguageLocaleKey(String value) {
			 obj.LanguageLocaleKey = value;
			 return this;
		}

		public UserBuilder withEmployeeNumber(String value) {
			 obj.EmployeeNumber = value;
			 return this;
		}

		public UserBuilder withDelegatedApproverId(Group value) {
			 obj.DelegatedApproverId = value.Id;
			 return this;
		}
		public UserBuilder withDelegatedApproverId(User value) {
			 obj.DelegatedApproverId = value.Id;
			 return this;
		}

		public UserBuilder withManagerId(User value) {
			 obj.ManagerId = value.Id;
			 return this;
		}

		public UserBuilder withUserPermissionsMarketingUser(Boolean value) {
			 obj.UserPermissionsMarketingUser = value;
			 return this;
		}

		public UserBuilder withUserPermissionsOfflineUser(Boolean value) {
			 obj.UserPermissionsOfflineUser = value;
			 return this;
		}

		public UserBuilder withUserPermissionsAvantgoUser(Boolean value) {
			 obj.UserPermissionsAvantgoUser = value;
			 return this;
		}

		public UserBuilder withUserPermissionsCallCenterAutoLogin(Boolean value) {
			 obj.UserPermissionsCallCenterAutoLogin = value;
			 return this;
		}

		public UserBuilder withUserPermissionsMobileUser(Boolean value) {
			 obj.UserPermissionsMobileUser = value;
			 return this;
		}

		public UserBuilder withUserPermissionsSFContentUser(Boolean value) {
			 obj.UserPermissionsSFContentUser = value;
			 return this;
		}

		public UserBuilder withUserPermissionsInteractionUser(Boolean value) {
			 obj.UserPermissionsInteractionUser = value;
			 return this;
		}

		public UserBuilder withUserPermissionsSupportUser(Boolean value) {
			 obj.UserPermissionsSupportUser = value;
			 return this;
		}

		public UserBuilder withUserPermissionsChatterAnswersUser(Boolean value) {
			 obj.UserPermissionsChatterAnswersUser = value;
			 return this;
		}

		public UserBuilder withForecastEnabled(Boolean value) {
			 obj.ForecastEnabled = value;
			 return this;
		}

		public UserBuilder withUserPreferencesActivityRemindersPopup(Boolean value) {
			 obj.UserPreferencesActivityRemindersPopup = value;
			 return this;
		}

		public UserBuilder withUserPreferencesEventRemindersCheckboxDefault(Boolean value) {
			 obj.UserPreferencesEventRemindersCheckboxDefault = value;
			 return this;
		}

		public UserBuilder withUserPreferencesTaskRemindersCheckboxDefault(Boolean value) {
			 obj.UserPreferencesTaskRemindersCheckboxDefault = value;
			 return this;
		}

		public UserBuilder withUserPreferencesReminderSoundOff(Boolean value) {
			 obj.UserPreferencesReminderSoundOff = value;
			 return this;
		}

		public UserBuilder withUserPreferencesDisableAllFeedsEmail(Boolean value) {
			 obj.UserPreferencesDisableAllFeedsEmail = value;
			 return this;
		}

		public UserBuilder withUserPreferencesApexPagesDeveloperMode(Boolean value) {
			 obj.UserPreferencesApexPagesDeveloperMode = value;
			 return this;
		}

		public UserBuilder withUserPreferencesHideCSNGetChatterMobileTask(Boolean value) {
			 obj.UserPreferencesHideCSNGetChatterMobileTask = value;
			 return this;
		}

		public UserBuilder withUserPreferencesHideCSNDesktopTask(Boolean value) {
			 obj.UserPreferencesHideCSNDesktopTask = value;
			 return this;
		}

		public UserBuilder withUserPreferencesHideChatterOnboardingSplash(Boolean value) {
			 obj.UserPreferencesHideChatterOnboardingSplash = value;
			 return this;
		}

		public UserBuilder withUserPreferencesHideSecondChatterOnboardingSplash(Boolean value) {
			 obj.UserPreferencesHideSecondChatterOnboardingSplash = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowTitleToExternalUsers(Boolean value) {
			 obj.UserPreferencesShowTitleToExternalUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowManagerToExternalUsers(Boolean value) {
			 obj.UserPreferencesShowManagerToExternalUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowEmailToExternalUsers(Boolean value) {
			 obj.UserPreferencesShowEmailToExternalUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowWorkPhoneToExternalUsers(Boolean value) {
			 obj.UserPreferencesShowWorkPhoneToExternalUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowMobilePhoneToExternalUsers(Boolean value) {
			 obj.UserPreferencesShowMobilePhoneToExternalUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowFaxToExternalUsers(Boolean value) {
			 obj.UserPreferencesShowFaxToExternalUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowStreetAddressToExternalUsers(Boolean value) {
			 obj.UserPreferencesShowStreetAddressToExternalUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowCityToExternalUsers(Boolean value) {
			 obj.UserPreferencesShowCityToExternalUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowStateToExternalUsers(Boolean value) {
			 obj.UserPreferencesShowStateToExternalUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowPostalCodeToExternalUsers(Boolean value) {
			 obj.UserPreferencesShowPostalCodeToExternalUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowCountryToExternalUsers(Boolean value) {
			 obj.UserPreferencesShowCountryToExternalUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowProfilePicToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowProfilePicToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowTitleToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowTitleToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowCityToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowCityToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowStateToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowStateToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowPostalCodeToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowPostalCodeToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowCountryToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowCountryToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesHideS1BrowserUI(Boolean value) {
			 obj.UserPreferencesHideS1BrowserUI = value;
			 return this;
		}

		public UserBuilder withUserPreferencesPathAssistantCollapsed(Boolean value) {
			 obj.UserPreferencesPathAssistantCollapsed = value;
			 return this;
		}

		public UserBuilder withUserPreferencesCacheDiagnostics(Boolean value) {
			 obj.UserPreferencesCacheDiagnostics = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowEmailToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowEmailToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowManagerToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowManagerToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowWorkPhoneToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowWorkPhoneToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowMobilePhoneToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowMobilePhoneToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowFaxToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowFaxToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesShowStreetAddressToGuestUsers(Boolean value) {
			 obj.UserPreferencesShowStreetAddressToGuestUsers = value;
			 return this;
		}

		public UserBuilder withUserPreferencesLightningExperiencePreferred(Boolean value) {
			 obj.UserPreferencesLightningExperiencePreferred = value;
			 return this;
		}

		public UserBuilder withUserPreferencesPreviewLightning(Boolean value) {
			 obj.UserPreferencesPreviewLightning = value;
			 return this;
		}

		public UserBuilder withUserPreferencesHideEndUserOnboardingAssistantModal(Boolean value) {
			 obj.UserPreferencesHideEndUserOnboardingAssistantModal = value;
			 return this;
		}

		public UserBuilder withUserPreferencesHideLightningMigrationModal(Boolean value) {
			 obj.UserPreferencesHideLightningMigrationModal = value;
			 return this;
		}

		public UserBuilder withUserPreferencesHideSfxWelcomeMat(Boolean value) {
			 obj.UserPreferencesHideSfxWelcomeMat = value;
			 return this;
		}

		public UserBuilder withUserPreferencesHideBiggerPhotoCallout(Boolean value) {
			 obj.UserPreferencesHideBiggerPhotoCallout = value;
			 return this;
		}

		public UserBuilder withUserPreferencesGlobalNavBarWTShown(Boolean value) {
			 obj.UserPreferencesGlobalNavBarWTShown = value;
			 return this;
		}

		public UserBuilder withUserPreferencesGlobalNavGridMenuWTShown(Boolean value) {
			 obj.UserPreferencesGlobalNavGridMenuWTShown = value;
			 return this;
		}

		public UserBuilder withUserPreferencesCreateLEXAppsWTShown(Boolean value) {
			 obj.UserPreferencesCreateLEXAppsWTShown = value;
			 return this;
		}

		public UserBuilder withUserPreferencesFavoritesWTShown(Boolean value) {
			 obj.UserPreferencesFavoritesWTShown = value;
			 return this;
		}

		public UserBuilder withUserPreferencesRecordHomeSectionCollapseWTShown(Boolean value) {
			 obj.UserPreferencesRecordHomeSectionCollapseWTShown = value;
			 return this;
		}

		public UserBuilder withUserPreferencesRecordHomeReservedWTShown(Boolean value) {
			 obj.UserPreferencesRecordHomeReservedWTShown = value;
			 return this;
		}

		public UserBuilder withUserPreferencesFavoritesShowTopFavorites(Boolean value) {
			 obj.UserPreferencesFavoritesShowTopFavorites = value;
			 return this;
		}

		public UserBuilder withUserPreferencesExcludeMailAppAttachments(Boolean value) {
			 obj.UserPreferencesExcludeMailAppAttachments = value;
			 return this;
		}

		public UserBuilder withUserPreferencesSuppressTaskSFXReminders(Boolean value) {
			 obj.UserPreferencesSuppressTaskSFXReminders = value;
			 return this;
		}

		public UserBuilder withUserPreferencesSuppressEventSFXReminders(Boolean value) {
			 obj.UserPreferencesSuppressEventSFXReminders = value;
			 return this;
		}

		public UserBuilder withUserPreferencesPreviewCustomTheme(Boolean value) {
			 obj.UserPreferencesPreviewCustomTheme = value;
			 return this;
		}

		public UserBuilder withUserPreferencesHasCelebrationBadge(Boolean value) {
			 obj.UserPreferencesHasCelebrationBadge = value;
			 return this;
		}

		public UserBuilder withContactId(Contact value) {
			 obj.ContactId = value.Id;
			 return this;
		}

		public UserBuilder withCallCenterId(CallCenter value) {
			 obj.CallCenterId = value.Id;
			 return this;
		}

		public UserBuilder withExtension(String value) {
			 obj.Extension = value;
			 return this;
		}

		public UserBuilder withFederationIdentifier(String value) {
			 obj.FederationIdentifier = value;
			 return this;
		}

		public UserBuilder withAboutMe(String value) {
			 obj.AboutMe = value;
			 return this;
		}

		/** (2019-05-30 12:56:39) Valores disponibles:  'D', 'W', 'N' */
		public UserBuilder withDigestFrequency(String value) {
			 obj.DigestFrequency = value;
			 return this;
		}

		/** (2019-05-30 12:56:39) Valores disponibles:  'P', 'D', 'W', 'N' */
		public UserBuilder withDefaultGroupNotificationFrequency(String value) {
			 obj.DefaultGroupNotificationFrequency = value;
			 return this;
		}

		public UserBuilder withIndividualId(Individual value) {
			 obj.IndividualId = value.Id;
			 return this;
		}

		public UserBuilder withUsuarioReclamos(String value) {
			 obj.Usuario_Reclamos__c = value;
			 return this;
		}

		public UserBuilder withCodigoSAP(String value) {
			 obj.Codigo_SAP__c = value;
			 return this;
		}

		public UserBuilder withCentrodeCosto(String value) {
			 obj.Centro_de_Costo__c = value;
			 return this;
		}

		public UserBuilder withGerenteComercial(String value) {
			 obj.Gerente_Comercial__c = value;
			 return this;
		}

		 public User build() {
			 return obj;
		}
	}

	/** It require following fields to can be inserted: ProfileId. */
	public static UserBuilder anUser() { return new UserBuilder(); }

	/*------------------------------------------------------------------------
	             UserBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             RegiaoBuilderStart
	------------------------------------------------------------------------*/
	 public class RegiaoBuilder {
		private Regiao__c obj = new Regiao__c();

		public RegiaoBuilder withOwnerId(Group value) {
			 obj.OwnerId = value.Id;
			 return this;
		}
		public RegiaoBuilder withOwnerId(User value) {
			 obj.OwnerId = value.Id;
			 return this;
		}

		public RegiaoBuilder withName(String value) {
			 obj.Name = value;
			 return this;
		}

		/** (2019-05-30 16:34:28) Valores disponibles:  'RS', 'SC', 'PR', 'MS', 'SP', 'MT', 'GO', 'BA', 'RO', 'PA', 'PI', 'MG', 'TO', 'MA' */
		public RegiaoBuilder withGrupodeR(String value) {
			 obj.Grupo_de_R__c = value;
			 return this;
		}

		public RegiaoBuilder withEstado(Estado__c value) {
			 obj.Estado__c = value.Id;
			 return this;
		}

		public RegiaoBuilder withMicrorregiodeVendas(Microrregi_o_de_Vendas__c value) {
			 obj.Microrregi_o_de_Vendas__c = value.Id;
			 return this;
		}

		/** (2019-05-30 16:34:28) Valores disponibles:  'REGION 1', 'REGION 2', 'CERRADO' */
		public RegiaoBuilder withRegionComercial(String value) {
			 obj.Region_Comercial__c = value;
			 return this;
		}

		/** (2019-05-30 16:34:28) Valores disponibles:  'B001', 'B002', 'B003', 'B004' */
		public RegiaoBuilder withOficinaVentas(String value) {
			 obj.Oficina_Ventas__c = value;
			 return this;
		}

		 public Regiao__c build() {
			 return obj;
		}
	}

	public static RegiaoBuilder aRegiao() { return new RegiaoBuilder(); }

	/*------------------------------------------------------------------------
	             RegiaoBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             MicrorregiodeVendasBuilderStart
	------------------------------------------------------------------------*/
	public class MicrorregiodeVendasBuilder {
		private Microrregi_o_de_Vendas__c obj = new Microrregi_o_de_Vendas__c();

		public MicrorregiodeVendasBuilder withOwnerId(Group value) {
			obj.OwnerId = value.Id;
			return this;
		}
		public MicrorregiodeVendasBuilder withOwnerId(User value) {
			obj.OwnerId = value.Id;
			return this;
		}

		public MicrorregiodeVendasBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public MicrorregiodeVendasBuilder withMacrorregiodeVendas(Macrorregi_o_de_Vendas__c value) {
			obj.Macrorregi_o_de_Vendas__c = value.Id;
			return this;
		}

		public Microrregi_o_de_Vendas__c build() {
			return obj;
		}
	}

	public static MicrorregiodeVendasBuilder aMicrorregiodeVendas() { return new MicrorregiodeVendasBuilder(); }

	/*------------------------------------------------------------------------
	             MicrorregiodeVendasBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             MacrorregiodeVendasBuilderStart
	------------------------------------------------------------------------*/
	public class MacrorregiodeVendasBuilder {
		private Macrorregi_o_de_Vendas__c obj = new Macrorregi_o_de_Vendas__c();

		public MacrorregiodeVendasBuilder withOwnerId(Group value) {
			obj.OwnerId = value.Id;
			return this;
		}

		public MacrorregiodeVendasBuilder withOwnerId(User value) {
			obj.OwnerId = value.Id;
			return this;
		}

		public MacrorregiodeVendasBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public Macrorregi_o_de_Vendas__c build() {
			return obj;
		}
	}

	public static MacrorregiodeVendasBuilder aMacrorregiodeVendas() { return new MacrorregiodeVendasBuilder(); }

	/*------------------------------------------------------------------------
	             MacrorregiodeVendasBuilderEnd
	------------------------------------------------------------------------*/

  	/*------------------------------------------------------------------------
	             EstadoBuilderStart
	------------------------------------------------------------------------*/
	public class EstadoBuilder {
		private Estado__c obj = new Estado__c();

		public EstadoBuilder withOwnerId(Group value) {
			obj.OwnerId = value.Id;
			return this;
		}

		public EstadoBuilder withOwnerId(User value) {
			obj.OwnerId = value.Id;
			return this;
		}

		public EstadoBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public EstadoBuilder withEstadodeOrigem(Boolean value) {
			obj.Estado_de_Origem__c = value;
			return this;
		}

		public EstadoBuilder withMostrarenportal(Boolean value) {
			obj.Mostrar_en_portal__c = value;
			return this;
		}

		public Estado__c build() {
			return obj;
		}
	}

	public static EstadoBuilder anEstado() { return new EstadoBuilder(); }

	/*------------------------------------------------------------------------
	             EstadoBuilderEnd
	------------------------------------------------------------------------*/
    
    /*------------------------------------------------------------------------
	             EventoRoyaltyBuilderStart
	------------------------------------------------------------------------*/
	public class EventoRoyaltyBuilder {
		private Evento_Royalty__c obj = new Evento_Royalty__c();

		public EventoRoyaltyBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public EventoRoyaltyBuilder withCuenta(Account value) {
			obj.Cuenta__c = value.Id;
			return this;
		}

		public EventoRoyaltyBuilder withData(String value) {
			obj.Data__c = value;
			return this;
		}

		public EventoRoyaltyBuilder withEstado(String value) {
			obj.Estado__c = value;
			return this;
		}

		public EventoRoyaltyBuilder withComentarios(String value) {
			obj.Comentarios__c = value;
			return this;
		}
         
        public EventoRoyaltyBuilder withItems(String value) {
			obj.Items__c = value;
			return this;
		}

		public EventoRoyaltyBuilder withSafra(String value) {
			obj.Safra__c = value;
			return this;
		}

		public EventoRoyaltyBuilder withValor(Decimal value) {
			obj.Valor__c = value;
			return this;
		}

		public EventoRoyaltyBuilder withSaldoPorSafra(Saldo_por_safra__c value) {
			obj.Saldo_por_safra__c = value.Id;
			return this;
		}

		public EventoRoyaltyBuilder withSupervisor(User value) {
			obj.Supervisor__c = value.Id;
			return this;
		}

		public Evento_Royalty__c build() {
			return obj;
		}
	}

	public static EventoRoyaltyBuilder anEventoRoyalty() { return new EventoRoyaltyBuilder(); }

	/*------------------------------------------------------------------------
	             EventoRoyaltyBuilderEnd
	------------------------------------------------------------------------*/
    
    /*------------------------------------------------------------------------
	             SaldoPorSafraBuilderStart
	------------------------------------------------------------------------*/
	public class SaldoPorSafraBuilder {
		private Saldo_por_safra__c obj = new Saldo_por_safra__c();

		public SaldoPorSafraBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public SaldoPorSafraBuilder withAccount(Account value) {
			obj.Account__c = value.Id;
			return this;
		}

		public SaldoPorSafraBuilder withEstado(String value) {
			obj.Estado__c = value;
			return this;
		}

		public SaldoPorSafraBuilder withSafra(String value) {
			obj.Safra__c = value;
			return this;
		}

		public SaldoPorSafraBuilder withSaldo(Decimal value) {
			obj.Saldo__c = value;
			return this;
		}

		public Saldo_por_safra__c build() {
			return obj;
		}
	}

	public static SaldoPorSafraBuilder aSaldoPorSafra() { return new SaldoPorSafraBuilder(); }

	/*------------------------------------------------------------------------
	             SaldoPorSafraBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             ContactBuilderStart
	------------------------------------------------------------------------*/
	 public class ContactBuilder {
		private Contact obj = new Contact(LastName = 'STRING');

		public ContactBuilder withAccountId(Account value) {
			 obj.AccountId = value.Id;
			 return this;
		}

		public ContactBuilder withLastName(String value) {
			 obj.LastName = value;
			 return this;
		}

		public ContactBuilder withFirstName(String value) {
			 obj.FirstName = value;
			 return this;
		}

		/** (2019-06-04 13:18:47) Valores disponibles:  'Sr.', 'Srta.', 'Sra.', 'Dr.', 'Prof.' */
		public ContactBuilder withSalutation(String value) {
			 obj.Salutation = value;
			 return this;
		}

		public ContactBuilder withRecordTypeId(RecordType value) {
			 obj.RecordTypeId = value.Id;
			 return this;
		}

		public ContactBuilder withOtherStreet(String value) {
			 obj.OtherStreet = value;
			 return this;
		}

		public ContactBuilder withOtherCity(String value) {
			 obj.OtherCity = value;
			 return this;
		}

		public ContactBuilder withOtherState(String value) {
			 obj.OtherState = value;
			 return this;
		}

		public ContactBuilder withOtherPostalCode(String value) {
			 obj.OtherPostalCode = value;
			 return this;
		}

		public ContactBuilder withOtherCountry(String value) {
			 obj.OtherCountry = value;
			 return this;
		}

		public ContactBuilder withOtherLatitude(Double value) {
			 obj.OtherLatitude = value;
			 return this;
		}

		public ContactBuilder withOtherLongitude(Double value) {
			 obj.OtherLongitude = value;
			 return this;
		}

		/** (2019-06-04 13:18:47) Valores disponibles:  'Address', 'NearAddress', 'Block', 'Street', 'ExtendedZip', 'Zip', 'Neighborhood', 'City', 'County', 'State', 'Unknown' */
		public ContactBuilder withOtherGeocodeAccuracy(String value) {
			 obj.OtherGeocodeAccuracy = value;
			 return this;
		}

		public ContactBuilder withMailingStreet(String value) {
			 obj.MailingStreet = value;
			 return this;
		}

		public ContactBuilder withMailingCity(String value) {
			 obj.MailingCity = value;
			 return this;
		}

		public ContactBuilder withMailingState(String value) {
			 obj.MailingState = value;
			 return this;
		}

		public ContactBuilder withMailingPostalCode(String value) {
			 obj.MailingPostalCode = value;
			 return this;
		}

		public ContactBuilder withMailingCountry(String value) {
			 obj.MailingCountry = value;
			 return this;
		}

		public ContactBuilder withMailingLatitude(Double value) {
			 obj.MailingLatitude = value;
			 return this;
		}

		public ContactBuilder withMailingLongitude(Double value) {
			 obj.MailingLongitude = value;
			 return this;
		}

		/** (2019-06-04 13:18:47) Valores disponibles:  'Address', 'NearAddress', 'Block', 'Street', 'ExtendedZip', 'Zip', 'Neighborhood', 'City', 'County', 'State', 'Unknown' */
		public ContactBuilder withMailingGeocodeAccuracy(String value) {
			 obj.MailingGeocodeAccuracy = value;
			 return this;
		}

		public ContactBuilder withPhone(String value) {
			 obj.Phone = value;
			 return this;
		}

		public ContactBuilder withFax(String value) {
			 obj.Fax = value;
			 return this;
		}

		public ContactBuilder withMobilePhone(String value) {
			 obj.MobilePhone = value;
			 return this;
		}

		public ContactBuilder withHomePhone(String value) {
			 obj.HomePhone = value;
			 return this;
		}

		public ContactBuilder withOtherPhone(String value) {
			 obj.OtherPhone = value;
			 return this;
		}

		public ContactBuilder withAssistantPhone(String value) {
			 obj.AssistantPhone = value;
			 return this;
		}

		public ContactBuilder withReportsToId(Contact value) {
			 obj.ReportsToId = value.Id;
			 return this;
		}

		public ContactBuilder withEmail(String value) {
			 obj.Email = value;
			 return this;
		}

		public ContactBuilder withTitle(String value) {
			 obj.Title = value;
			 return this;
		}

		public ContactBuilder withDepartment(String value) {
			 obj.Department = value;
			 return this;
		}

		public ContactBuilder withAssistantName(String value) {
			 obj.AssistantName = value;
			 return this;
		}

		/** (2019-06-04 13:18:47) Valores disponibles:  'Publicidad', 'Referencia del empleado', 'Referencia externa', 'Socio', 'Relaciones públicas', 'Seminario - Interno', 'Seminario - Socio', 'Feria', 'Web', 'Por comentarios de terceros', 'Otros' */
		public ContactBuilder withLeadSource(String value) {
			 obj.LeadSource = value;
			 return this;
		}

		public ContactBuilder withBirthdate(Date value) {
			 obj.Birthdate = value;
			 return this;
		}

		public ContactBuilder withDescription(String value) {
			 obj.Description = value;
			 return this;
		}

		public ContactBuilder withOwnerId(User value) {
			 obj.OwnerId = value.Id;
			 return this;
		}

		public ContactBuilder withEmailBouncedReason(String value) {
			 obj.EmailBouncedReason = value;
			 return this;
		}

		public ContactBuilder withEmailBouncedDate(DateTime value) {
			 obj.EmailBouncedDate = value;
			 return this;
		}

		/** (2019-06-04 13:18:47) Valores disponibles:  'No', 'NoResponse', 'NotSure', 'YesAdmin', 'YesNotAdmin' */
		public ContactBuilder withUseSalesforce(String value) {
			 obj.UseSalesforce = value;
			 return this;
		}

		public ContactBuilder withJigsaw(String value) {
			 obj.Jigsaw = value;
			 return this;
		}

		public ContactBuilder withIndividualId(Individual value) {
			 obj.IndividualId = value.Id;
			 return this;
		}

		public ContactBuilder withHabilitadoSitedemultiplicadores(Boolean value) {
			 obj.Habilitado_Site_de_multiplicadores__c = value;
			 return this;
		}

		public ContactBuilder withSenha(String value) {
			 obj.Senha__c = value;
			 return this;
		}

		public ContactBuilder withCadastropelaprimeiravez(Boolean value) {
			 obj.Cadastro_pela_primeira_vez__c = value;
			 return this;
		}

		public ContactBuilder withUsuarioReclamos(String value) {
			 obj.Usuario_Reclamos__c = value;
			 return this;
		}

		public ContactBuilder withEstado(Estado__c value) {
			 obj.Estado__c = value.Id;
			 return this;
		}

		public ContactBuilder withCNPJCPFc(String value) {
			 obj.CNPJ_CPF_c__c = value;
			 return this;
		}

		public ContactBuilder withCodigoSAP(String value) {
			 obj.Codigo_SAP__c = value;
			 return this;
		}

		public ContactBuilder withEstaenSAP(Boolean value) {
			 obj.Esta_en_SAP__c = value;
			 return this;
		}

		public ContactBuilder withFechaBloqueoSAP(Date value) {
			 obj.Fecha_Bloqueo_SAP__c = value;
			 return this;
		}

		public ContactBuilder withNumeroCalle(String value) {
			 obj.Numero_Calle__c = value;
			 return this;
		}

		public ContactBuilder withBarrio(String value) {
			 obj.Barrio__c = value;
			 return this;
		}

		public ContactBuilder withInscripcionEstadual(String value) {
			 obj.Inscripcion_Estadual__c = value;
			 return this;
		}

		public ContactBuilder withPersonaFisica(Boolean value) {
			 obj.Persona_Fisica__c = value;
			 return this;
		}

		public ContactBuilder withPropietarioAnterior(String value) {
			 obj.Propietario_Anterior__c = value;
			 return this;
		}

		public ContactBuilder withTipoRegAnterior(String value) {
			 obj.TipoReg_Anterior__c = value;
			 return this;
		}

		public ContactBuilder withEliminacion(Boolean value) {
			 obj.Eliminacion__c = value;
			 return this;
		}

		public ContactBuilder withRepresentante(String value) {
			 obj.Representante__c = value;
			 return this;
		}

		 public Contact build() {
			 return obj;
		}

	}

	public static ContactBuilder aContact() { return new ContactBuilder(); }

	public static ContactBuilder aContactDestinatarioBloqueado() { 
		ContactBuilder val = new ContactBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Contact', 'Destinatario_Bloqueado').Id;
		return val;
	}

	public static ContactBuilder aContactDestinatarioDesbloqueado() { 
		ContactBuilder val = new ContactBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Contact', 'Destinatario_Desbloqueado').Id;
		return val;
	}

	public static ContactBuilder aContactGeneral() { 
		ContactBuilder val = new ContactBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Contact', 'General').Id;
		return val;
	}

	public static ContactBuilder aContactInactivo() { 
		ContactBuilder val = new ContactBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('Contact', 'Inactivo').Id;
		return val;
	}

	/*------------------------------------------------------------------------
	             ContactBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             CRMBonificacionBuilderStart
	------------------------------------------------------------------------*/
	 public class CRMBonificacionBuilder {
		private CRM_Bonificacion__c obj = new CRM_Bonificacion__c();

		public CRMBonificacionBuilder withRecordTypeId(RecordType value) {
			 obj.RecordTypeId = value.Id;
			 return this;
		}

		public CRMBonificacionBuilder withRecordTypeId(ID value) {
			 obj.RecordTypeId = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRMixdeProduto(Decimal value) {
			 obj.BR_Mix_de_Produto__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withDSAumentonasVendas(Boolean value) {
			 obj.DS_Aumento_nas_Vendas__c = value;
			 return this;
		}

		/** (2019-06-04 15:28:54) Valores disponibles:  'PRATA', 'OURO', 'PLATINUM' */
		public CRMBonificacionBuilder withBRCategoria(String value) {
			 obj.BR_Categoria__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRCatergoriaBRXM(Decimal value) {
			 obj.BR_Catergoria_BRXM__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRDesconto(Double value) {
			 obj.BR_Desconto__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRDescontoExclusividade(Double value) {
			 obj.BR_Desconto_Exclusividade__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRDescontototalkgs(Double value) {
			 obj.BR_Desconto_total_kgs__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRPontospalestras(Double value) {
			 obj.BR_Pontos_palestras__c = value;
			 return this;
		}

		/** (2019-06-04 15:28:54) Valores disponibles:  '066 - Marcelo Steffen', '061 - Fernando Frehner', '067 - Sergio Bertagnolli', '076 - Tiago Goulart', '083 - Jorge Cristiano Rosa', '095 - Brasmax', '101 - Fausto Tadeu Fanchin', '111 - Pablo R. de Souza', '150 - João Serrano', '151 - Anderson Weissheimer', '196 - Edson Chambo', '198 - Bernardo Zanardo', '199 - Lucas Costa', '197 - Wagner Rank' */
		public CRMBonificacionBuilder withBRResponsavel(String value) {
			 obj.BR_Responsavel__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRResultadoVendas(Double value) {
			 obj.BR_Resultado_Vendas__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRVendadeIntacta(Double value) {
			 obj.BR_Venda_de_Intacta__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRCategoriaresultante(String value) {
			 obj.BR_Categoria_resultante__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withDSCategoriaresultante(String value) {
			 obj.DS_Categoria_resultante__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withDSAreasparaensaios(Boolean value) {
			 obj.DS_Areas_para_ensaios__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withCRMMultiplicador(CRM_Multiplicador__c value) {
			 obj.CRM_Multiplicador__c = value.Id;
			 return this;
		}

		public CRMBonificacionBuilder withDSCategoria(Decimal value) {
			 obj.DS_Categoria__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withDSParticipacadiasdecampo(Boolean value) {
			 obj.DS_Participaca_dias_de_campo__c = value;
			 return this;
		}

		/** (2019-06-04 15:28:54) Valores disponibles:  '096 - Charles C. Pintro', '105 - Rogério A. Schneider', '106 - Sandro Ferrari M', '104 - Otavio Gorni', '152 - Fernando Calazans', '190 - Marcos Berlezi' */
		public CRMBonificacionBuilder withDSResponsavel(String value) {
			 obj.DS_Responsavel__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRExclusividadeGDM(Boolean value) {
			 obj.BR_Exclusividade_GDM__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withDSManualdamarca(Boolean value) {
			 obj.DS_Manual_da_marca__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRMetaBRMXporc(Decimal value) {
			 obj.BR_Meta_BRMX_porc__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withMetaDSEMporc(Decimal value) {
			 obj.Meta_DSEM_porc__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRSomadeMeta(Double value) {
			 obj.BR_Soma_de_Meta__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRParticipacaodiadecampometa(Double value) {
			 obj.BR_Participacao_dia_de_campo_meta__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withDSSomadeMeta(Double value) {
			 obj.DS_Soma_de_Meta__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRLXLMeta(Double value) {
			 obj.BR_LXL_Meta__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRPalestrasMeta(Double value) {
			 obj.BR_Palestras_Meta__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRTreinamentosMeta(Double value) {
			 obj.BR_Treinamentos_Meta__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withDSReclamdeprec(Double value) {
			 obj.DS_Reclam_de_prec__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRPenetraoINTACTA(Decimal value) {
			 obj.BR_Penetra_o_INTACTA__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRPontosdiasdecampo(Double value) {
			 obj.BR_Pontos_dias_de_campo__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRPontosLxL(Double value) {
			 obj.BR_Pontos_LxL__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRPontosmix(Double value) {
			 obj.BR_Pontos_mix__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRResultadoPalestraeTreinamentos(Double value) {
			 obj.BR_Resultado_Palestra_e_Treinamentos__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRPontospenetrao(Double value) {
			 obj.BR_Pontos_penetra_o__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRPontosvolume(Double value) {
			 obj.BR_Pontos_volume__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withDSIdentificaodebeirasderodovia(Double value) {
			 obj.DS_Identifica_o_de_beiras_de_rodovia__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRParticipacaodiacamporealizado(Double value) {
			 obj.BR_Participacao_dia_campo_realizado__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRLXLRealizado(Double value) {
			 obj.BR_LXL_Realizado__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRPalestrasRealizado(Double value) {
			 obj.BR_Palestras_Realizado__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRTreinamentosRealizado(Double value) {
			 obj.BR_Treinamentos_Realizado__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRSuperouMeta(Boolean value) {
			 obj.BR_Superou_Meta__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withDSSuperouMeta(Boolean value) {
			 obj.DS_Superou_Meta__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRTotaldepontos(Double value) {
			 obj.BR_Total_de_pontos__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRSemComerSafraactual(Double value) {
			 obj.BR_SemComer_Safra_actual__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRSomadeSemComercializada(Double value) {
			 obj.BR_Soma_de_Sem_Comercializada__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withDSomadeSemComercializada(Double value) {
			 obj.DSoma_de_Sem_Comercializada__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withSSemComersafraant(Double value) {
			 obj.SSemComer_safra_ant__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withSSemComerSafraactual(Double value) {
			 obj.SSemComer_Safra_actual__c = value;
			 return this;
		}

		public CRMBonificacionBuilder withBRMXDescuento(Double value) {
			 obj.BRMX_Descuento__c = value;
			 return this;
		}

		 public CRM_Bonificacion__c build() {
			 return obj;
		}

	}

	/** It require following fields to can be inserted: CRM_Multiplicador__c. */
	public static CRMBonificacionBuilder aCRMBonificacion() { return new CRMBonificacionBuilder(); }

	/** It require following fields to can be inserted: CRM_Multiplicador__c. */
	public static CRMBonificacionBuilder aCRMBonificacionBRMX() { 
		CRMBonificacionBuilder val = new CRMBonificacionBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('CRM_Bonificacion__c', 'BRMX').Id;
		return val;
	}

	/** It require following fields to can be inserted: CRM_Multiplicador__c. */
	public static CRMBonificacionBuilder aCRMBonificacionDSEM() { 
		CRMBonificacionBuilder val = new CRMBonificacionBuilder();
		val.obj.RecordTypeId = XappiaHelper.getRecordType('CRM_Bonificacion__c', 'DSEM').Id;
		return val;
	}

	/*------------------------------------------------------------------------
	             CRMBonificacionBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
	             OrderBuilderStart
	------------------------------------------------------------------------*/
	 public class OrderBuilder {
		private Order obj = new Order(
            Status = 'Borrador',
            EffectiveDate = System.today().addDays(10)
        );
         
		public OrderBuilder withOwnerId(User value) {
			obj.OwnerId = value.Id;
			return this;
		}

        public OrderBuilder withAccountId(Account value) {
			obj.AccountId = value.Id;
			return this;
        }

		public OrderBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public OrderBuilder withNumeroPedidoSAP(String value) {
			obj.Numero_Pedido_SAP__C = value;
			return this;
		}

		public OrderBuilder withstatus(String value) {
			obj.Status = value;
			return this;
		}

		public Order build() {
			return obj;
		}
	}

	public static OrderBuilder anOrder() { return new OrderBuilder(); }

	/*------------------------------------------------------------------------
	             OrderBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             QuoteLineItemBuilderStart
	------------------------------------------------------------------------*/
	public class QuoteLineItemBuilder {
		private QuoteLineItem obj = new QuoteLineItem();
         
		public QuoteLineItemBuilder withDescription(String value) {
			obj.Description = value;
			return this;
		}

		public QuoteLineItemBuilder withQuote(Quote value) {
			obj.QuoteId = value.Id;
			return this;
		}

		public QuoteLineItemBuilder withProduct2(Product2 value) {
			obj.Product2Id = value.Id;
			return this;
		}
         
        public QuoteLineItemBuilder withUnitPrice(Decimal value) {
			obj.UnitPrice = value;
			return this;
		}
         
        public QuoteLineItemBuilder withQuantity(Integer value) {
			obj.Quantity = value;
			return this;
		}
		
        public QuoteLineItemBuilder withPricebookEntry(PricebookEntry value) {
			obj.PricebookEntryId = value.Id;
			return this;
		}

		public QuoteLineItem build() {
			return obj;
		}
	}

	public static QuoteLineItemBuilder aQuoteLineItem() { return new QuoteLineItemBuilder(); }

	/*------------------------------------------------------------------------
	             QuoteLineItemBuilderEnd
	------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------
	             QuoteBuilderStart
	------------------------------------------------------------------------*/
	public class QuoteBuilder {
		private Quote obj = new Quote();
         
		public QuoteBuilder withName(String value) {
			obj.Name = value;
			return this;
		}

		public QuoteBuilder withOpportunity(Opportunity value) {
			obj.OpportunityId = value.Id;
			return this;
		}
         
        public QuoteBuilder withPricebook2(Pricebook2 value) {
			obj.Pricebook2Id = value.Id;
			return this;
		}
         
        public QuoteBuilder withStatus(String value) {
			obj.Status = value;
			return this;
		}

		public Quote build() {
			return obj;
		}
	}

	public static QuoteBuilder aQuote() { return new QuoteBuilder(); }

	/*------------------------------------------------------------------------
	             QuoteBuilderEnd
	------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
                 EventoRoyaltyItemBuilderStart
    ------------------------------------------------------------------------*/
	public class EventoRoyaltyItemBuilder {
        private Evento_Royalty_Item__c obj = new Evento_Royalty_Item__c();

        public EventoRoyaltyItemBuilder withName(String value) {
			obj.Name = value;
			return this;
        }

        public EventoRoyaltyItemBuilder withCantidad(Integer value) {
			obj.Cantidad__c = value;
			return this;
        }

        public EventoRoyaltyItemBuilder withComentario(String value) {
			obj.Comentario__c = value;
			return this;
        }

        public EventoRoyaltyItemBuilder withData(Date value) {
			obj.Data__c = value;
			return this;
        }

        public EventoRoyaltyItemBuilder withEventoRoyalty(Evento_Royalty__c value) {
			obj.Evento_Royalty__c = value.Id;
			return this;
        }

        public EventoRoyaltyItemBuilder withIndice(Integer value) {
			obj.Indice__c = value;
			return this;
        }

        public EventoRoyaltyItemBuilder withItem(String value) {
			obj.Item__c = value;
			return this;
        }

        public EventoRoyaltyItemBuilder withValor(Decimal value) {
			obj.Valor__c = value;
			return this;
        }

		public Evento_Royalty_Item__c build() {
			return obj;
        }
    }

    public static EventoRoyaltyItemBuilder anEventoRoyaltyItem() { return new EventoRoyaltyItemBuilder(); }

    /*------------------------------------------------------------------------
                 EventoRoyaltyItemBuilderEnd
    ------------------------------------------------------------------------*/

	/*------------------------------------------------------------------------
                 RequisicaoDeCompraBuilderStart
    ------------------------------------------------------------------------*/
	public class RequisicaoDeCompraBuilder {
        private Requisicao_de_compra__c obj = new Requisicao_de_compra__c();

        public RequisicaoDeCompraBuilder withMarca(String value) {
			obj.Marca__c = value;
			return this;
        }

        public RequisicaoDeCompraBuilder withSafra(String value) {
			obj.Safra__c = value;
			return this;
        }

        public RequisicaoDeCompraBuilder withRegiao(String value) {
			obj.Regiao_comercial__c = value;
			return this;
        }

        public RequisicaoDeCompraBuilder withTipo(String value) {
			obj.Tipo__c = value;
			return this;
        }

        public RequisicaoDeCompraBuilder forMultiplicador(Id value) {
			obj.Multiplicador__c = value;
			return this;
        }

        public RequisicaoDeCompraBuilder withOwner(String value) {
			obj.OwnerId = value;
			return this;
        }
         
        public RequisicaoDeCompraBuilder withEstado(String value) {
			obj.Estado__c = value;
			return this;
        }

        public RequisicaoDeCompraBuilder withPai(Id value) {
			obj.Requisicao_de_compra__c = value;
			return this;
        }

		public Requisicao_de_compra__c build() {
			return obj;
        }
    }

    public static RequisicaoDeCompraBuilder aRequisicaoDeCompra() { return new RequisicaoDeCompraBuilder(); }

    /*------------------------------------------------------------------------
                 RequisicaoDeCompraBuilderBuilderEnd
    ------------------------------------------------------------------------*/
}
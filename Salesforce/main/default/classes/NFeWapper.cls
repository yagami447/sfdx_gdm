public class NFeWapper {
   @AuraEnabled public string JSONstring {get;set;}

    public Nota_Fiscal_Eletr_nica__c createOpportunity() {
        Nota_Fiscal_Eletr_nica__c nota = new Nota_Fiscal_Eletr_nica__c();
		//nota.Name 	=	 this.nfeProc.protNFe.infProt.chNFe ;
        nota.NFe__c = this.nfeProc.protNFe.infProt.chNFe;


        if (nfeProc.NFe.infNFe.ide != null) {
            nota.Codigo_do_Modelo_do_Documento_Fiscal__c = String.valueOf(this.nfeProc.NFe.infNFe.ide.mod);
            nota.Serie_Do_Documento_Fiscal__c = nfeProc.NFe.infNFe.ide.serie;
            nota.Numero_do_Documento_Fiscal__C = nfeProc.NFe.infNFe.ide.nNF;
            nota.participante__c = nfeProc.NFe.infNFe.ide.participante;
            if (this.nfeProc.NFe.infNFe.ide.dhEmi != null) nota.Data_e_hora_de_Emissao_do_Documento__c = (DateTime)JSON.deserialize('"' + this.nfeProc.NFe.infNFe.ide.dhEmi + '"', DateTime.class);
            if (this.nfeProc.NFe.infNFe.ide.dhSaiEnt != null) nota.Data_e_hora_de_Saida_ou_da_Entrada__c =(DateTime) JSON.deserialize('"' + this.nfeProc.NFe.infNFe.ide.dhSaiEnt + '"', DateTime.class);
            nota.Natureza_da_Opera_o__c = this.nfeProc.NFe.infNFe.ide.natOp;
            nota.Tipo_de_Operacao_NFe__c = String.valueOf(this.nfeProc.NFe.infNFe.ide.tpNF);
        }
        /// Emitente 
        if (nfeProc.NFe.infNFe.emit != null) {
            nota.Emitente__C = nfeProc.NFe.infNFe.emit.accountId;
            nota.emitente_razon_social__c = nfeProc.NFe.infNFe.emit.xNome;
            nota.Emitente_Nome_Fantas__c = nfeProc.NFe.infNFe.emit.xFant;
            nota.Emitente_Endere_o__c = nfeProc.NFe.infNFe.emit.enderEmit.xLgr;
            nota.Emitente_CNPJ__c = nfeProc.NFe.infNFe.emit.CNPJ;
            nota.CPF__c = nfeProc.NFe.infNFe.emit.CPF;
            nota.Emitente_Bairro_Distrito__c = nfeProc.NFe.infNFe.emit.enderEmit.xBairro;
            nota.Emitente_Munic_pio__c = nfeProc.NFe.infNFe.emit.enderEmit.xMun;
            nota.Emitente_Telefone__c = String.valueOf(nfeProc.NFe.infNFe.emit.enderEmit.fone);
            nota.Emitente_UF__c = nfeProc.NFe.infNFe.emit.enderEmit.UF;
            nota.Emitente_pa_s__c = nfeProc.NFe.infNFe.emit.enderEmit.xPais;            
            nota.Emitente_CNAE_Fiscal__c = String.valueOf(nfeProc.NFe.infNFe.emit.CNAE);
            
        	if (nfeProc.NFe.infNFe.emit.accountId == null && !string.isEmpty(nfeProc.NFe.infNFe.emit.CNPJ) ) { 
                //nota.Emitente__c = createEmitente();
            }
        }
        // Destinatario
        if (nfeProc.NFe.infNFe.dest != null) {
            nota.Destinatario__C = nfeProc.NFe.infNFe.dest.accountId;
            nota.Destinatario_Raz_o_Social__c = nfeProc.NFe.infNFe.dest.xNome;
            nota.Destinatario_Endere_o__c = nfeProc.NFe.infNFe.dest.enderDest.xLgr;
            nota.Destinatario_CNPJ__c = nfeProc.NFe.infNFe.dest.CNPJ;
            nota.Destinatario_Bairro_Distrito__c = nfeProc.NFe.infNFe.dest.enderDest.xBairro;
            nota.Destinatario_CEP__c = nfeProc.NFe.infNFe.dest.enderDest.CEP;
            nota.Destinatario_Munic_pio__c = nfeProc.NFe.infNFe.dest.enderDest.xMun;
            nota.CPF_Destinatario__c = nfeProc.NFe.infNFe.dest.CPF;
            nota.Destinatario_Telefone__c = String.valueOf(nfeProc.NFe.infNFe.dest.enderDest.fone);
            nota.Destinatario_UF__c = nfeProc.NFe.infNFe.dest.enderDest.UF;
            nota.Destinatario_pa_s__c = nfeProc.NFe.infNFe.dest.enderDest.xPais;
            nota.Destinatario_Email__c = nfeProc.NFe.infNFe.dest.enderDest.email;
        	 if (nfeProc.NFe.infNFe.dest.accountId == null  && !string.isEmpty(nfeProc.NFe.infNFe.dest.CNPJ) ) {
                //nota.Destinatario__c = createDestinatario();
            }
        } 
        
        /// ABA Totais
        if (nfeProc.NFe.infNFe.total != null && nfeProc.NFe.infNFe.total.ICMSTot != null) {
            nota.Valor_Total_dos_productos_e_servicos__c = nfeProc.NFe.infNFe.total.ICMSTot.vProd;
            nota.Valor_do_Frete__c = nfeProc.NFe.infNFe.total.ICMSTot.vFrete;
            nota.Valor_do_Seguro__c = nfeProc.NFe.infNFe.total.ICMSTot.vSeg;
            nota.Valor_Total_dos_Descontos__c = nfeProc.NFe.infNFe.total.ICMSTot.vDesc;
            nota.Valor_Total_da_NFe__c = nfeProc.NFe.infNFe.total.ICMSTot.vNF;
            nota.Valor_Aproximado_dos_Tributos__c = nfeProc.NFe.infNFe.total.ICMSTot.vTotTrib;
        }
        ///
        
        /// ABA Transporte
        if (nfeProc.NFe.infNFe.transp != null ) {
            nota.Modalidade_do_frete__c = String.valueOf(nfeProc.NFe.infNFe.transp.modFrete);
            if (nfeProc.NFe.infNFe.transp.transporta!= null) {
                
                nota.Nome_Transporta__c = nfeProc.NFe.infNFe.transp.transporta.xNome;
                nota.Inscricao_Estadual_do_Transportador__c = nfeProc.NFe.infNFe.transp.transporta.IE;
                nota.Endereco_Completo__c = nfeProc.NFe.infNFe.transp.transporta.xEnder;
                nota.Municipio_Transportador__c = nfeProc.NFe.infNFe.transp.transporta.xMun;
                nota.UF_Transportador__c = nfeProc.NFe.infNFe.transp.transporta.UF;
            }
            
            if (nfeProc.NFe.infNFe.transp.veicTransp != null) {
                nota.Placa_veiculo__c = nfeProc.NFe.infNFe.transp.veicTransp.placa;
                nota.UF_Veiculo__c = nfeProc.NFe.infNFe.transp.veicTransp.UF;
                nota.RNTC__c = nfeProc.NFe.infNFe.transp.veicTransp.RNTC;
            }
            
            
            //Volumenes
            if (nfeProc.NFe.infNFe.transp.vol!= null) {
                nota.Volumes_Transportados__c = nfeProc.NFe.infNFe.transp.vol.qVol;
                nota.Especie_Dos_Volumes_Transportados__c = nfeProc.NFe.infNFe.transp.vol.esp;
                nota.Marca_Dos_Volumes_Transportados__C = nfeProc.NFe.infNFe.transp.vol.marca;
                nota.Numeracao_Dos_Volumes_Transportados__c = nfeProc.NFe.infNFe.transp.vol.nVol;
                nota.Peso_Liquido_Volumes_Transportados__C = nfeProc.NFe.infNFe.transp.vol.pesoL;
                nota.Peso_Bruto_Volumes_Transportados__c = nfeProc.NFe.infNFe.transp.vol.pesoB;
            }
        }
        //ABA Cobrança
        //Duplicatas
        if (nfeProc.NFe.infNFe.cobr != null && nfeProc.NFe.infNFe.cobr.dup != null) {
            if (nfeProc.NFe.infNFe.cobr.dup.nDup != null) nota.Numero_da_Duplicata__c = String.valueOf(nfeProc.NFe.infNFe.cobr.dup.nDup);
            nota.Data_da_Vencimiento_Duplicata__c = Date.valueOf(nfeProc.NFe.infNFe.cobr.dup.dVenc);
            nota.Valor_da_Duplicata__c = nfeProc.NFe.infNFe.cobr.dup.vDup;
        }
                
        ///Formas de Pagamento
        if (nfeProc.NFe.infNFe.pag != null && nfeProc.NFe.infNFe.pag.detPag != null && nfeProc.NFe.infNFe.pag.detPag.size() > 0 ) {
            nota.Forma_de_pagamento__c = nfeProc.NFe.infNFe.pag.detPag[0].tPag;
            nota.Valor_do_Pagamento__c = nfeProc.NFe.infNFe.pag.detPag[0].vPag;
        }
     	//ABA Informações Adicionais
        if (nfeProc.NFe.infNFe.infAdic != null) nota.Informa_es_Complementares_de_Interesse__c = nfeProc.NFe.infNFe.infAdic.infCpl;
        ///
        //
        return nota;
    }
    
    private id createEmitente() {
        Account ac = new Account();
        ac.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cuenta').getRecordTypeId();
        ac.Name = nfeProc.NFe.infNFe.emit.xNome;
        ac.Nome_fantasia__c = nfeProc.NFe.infNFe.emit.xFant;
        ac.ShippingStreet = nfeProc.NFe.infNFe.emit.enderEmit.xLgr;
        ac.CNPJ_CPF__c = nfeProc.NFe.infNFe.emit.CNPJ;
        ac.Barrio__c = nfeProc.NFe.infNFe.emit.enderEmit.xBairro;
        ac.ShippingCity = nfeProc.NFe.infNFe.emit.enderEmit.xMun;
        ac.Phone = String.valueOf(nfeProc.NFe.infNFe.emit.enderEmit.fone);
        ac.ShippingState = nfeProc.NFe.infNFe.emit.enderEmit.UF;
        ac.ShippingCountry = nfeProc.NFe.infNFe.emit.enderEmit.xPais; 
        insert ac;
        return ac.id;
    }
    
    private id createDestinatario() {
        Account ac = new Account();
        ac.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cuenta').getRecordTypeId();
        ac.Name = nfeProc.NFe.infNFe.dest.xNome;
        ac.ShippingStreet = nfeProc.NFe.infNFe.dest.enderDest.xLgr;
        ac.CNPJ_CPF__c = nfeProc.NFe.infNFe.dest.CNPJ;
        ac.Barrio__c = nfeProc.NFe.infNFe.dest.enderDest.xBairro;
        ac.ShippingCity = nfeProc.NFe.infNFe.dest.enderDest.xMun;
		ac.CEP__c =       nfeProc.NFe.infNFe.dest.enderDest.CEP;  
        ac.Phone = String.valueOf(nfeProc.NFe.infNFe.dest.enderDest.fone);
        ac.ShippingState = nfeProc.NFe.infNFe.dest.enderDest.UF;
        ac.ShippingCountry = nfeProc.NFe.infNFe.dest.enderDest.xPais; 
        ac.Email__c = nfeProc.NFe.infNFe.dest.enderDest.email; 
        insert ac;
        return ac.id;
    }

    public List<Produto_da_nota_fiscal__c> createItems(Id Nota_Fiscal_Eletronica) {
    	List<Produto_da_nota_fiscal__c> pnfs = new List<Produto_da_nota_fiscal__c>();
        
        if (nfeProc.NFe.infNFe.det != null) {
            for (Det d : nfeProc.NFe.infNFe.det) {
                Produto_da_nota_fiscal__c pnf = new Produto_da_nota_fiscal__c();
                pnf.Producto2Id__c = d.prod.productId;
                pnf.Motivo_invalido__c = d.prod.motivoInvalido;
                pnf.Validade__c = d.prod.validade;
                
                pnf.Nota_Fiscal_Eletr_nica__c = Nota_Fiscal_Eletronica;
                pnf.CFOP__c =String.valueOf(d.prod.CFOP);
                if (d.prod.xProd != null) {
                    if (d.prod.xProd.length() > 80) {                    	
                        pnf.name = d.prod.xProd.substring(0,80);
                    } else {
                        pnf.name = d.prod.xProd;
                    }
                }
				pnf.Description__c = d.infAdProd;
				pnf.Quantity__c = d.prod.quantityReal;

				pnf.Unidade_Comercial__c = String.valueOf(d.prod.uCom);
				pnf.TotalPrice__c = d.prod.vProd;
				if (d.imposto != null) {
					pnf.Valor_Aproximado_dos_Tributos__c= d.imposto.vTotTrib;
					if (d.imposto.IPI != null) pnf.CNPJ_do_Fabricante_da_Mercadoria__c = d.imposto.IPI.CNPJProd;
				}
				pnf.Codigo_do_produto__c = d.prod.cProd;
				pnf.Codigo_NCM__c = String.valueOf(d.prod.NCM);
                if (pnf.Codigo_NCM__c == '12011000') {
                    pnf.TIPO_DE_PRODUTO__c = 'SEMENTE';
                } else if (pnf.Codigo_NCM__c == '12019000'){
                    pnf.TIPO_DE_PRODUTO__c = 'GRÃO';
                } else  {
                    pnf.TIPO_DE_PRODUTO__c = 'OUTROS';
                    
                }
				pnf.Codigo_CEST__c = d.prod.CEST;
				pnf.Indicador_de_Escala_Relevante__c = d.prod.CEST;
				pnf.Valor_do_Desconto__c = d.prod.vDesc;
				pnf.Valor_Total_do_Frete__c = d.prod.vFrete;
				pnf.Valor_do_Seguro__c = d.prod.vSeg;
				//pnf.Indicador_de_Composicao_do_Valor_Total__c = d.prod.indTot; 
				pnf.GTIN_o_C_digo_EAN_Comercial_do_Producto__c= d.prod.cEAN;
				pnf.Unidade_Comercial__c= d.prod.uCom;
				pnf.Quantidade_Comercial__c= d.prod.qCom;
				pnf.GTIN_o_Codigo_EAN_Tributavel__c = d.prod.cEANTrib;
				pnf.Unidade_Tributavel__c= d.prod.uTrib;
				pnf.Quantidade_Tributavel__c= d.prod.qTrib;
				pnf.Valor_unitario_de_comercializacao__c= d.prod.vUnCom;
				pnf.Valor_unitario_de_tributacao__c= d.prod.vUnTrib;
				pnf.Numero_do_pedido_de_compra__c= d.prod.xPed;
				pnf.Item_do_pedido_de_compra__c= d.prod.nItemPed;
				pnf.quantityReal__c = d.prod.quantityReal;

				pnf.Numero_da_FCI__c= d.prod.nFCI;

				pnfs.add(pnf);
            }
        }
    	return pnfs;

	}
    
    public void setProducts() {
        Id productId = [SELECT Id FROM Product2 WHERE Name = 'Generico Nota Fiscal' LIMIT 1].id;
        List<Natureza_da_Opera_o__mdt> natures = [
          	SELECT Id, Codigo_de__c, Natureza_da_opera_o__c, Valido__c
            FROM Natureza_da_Opera_o__mdt
        ];
        Map<String, Natureza_da_Opera_o__mdt> naturesbyCode = new Map<String, Natureza_da_Opera_o__mdt>();
        
        for (Natureza_da_Opera_o__mdt n : natures) {
            naturesbyCode.put(n.Codigo_de__c, n);
        }
        
        if (nfeProc.NFe.infNFe.det != null) {
            for (Det d : nfeProc.NFe.infNFe.det) {
        		d.prod.productId = productId;
                d.prod.validade = 'Desconhecido';
                
                if (d.prod.CFOP != null && naturesbyCode.containsKey(String.valueOf(d.prod.CFOP))) {
                    Natureza_da_Opera_o__mdt n = naturesbyCode.get(String.valueOf(d.prod.CFOP));
                    d.prod.validade = n.Valido__c ?  'Valida' : 'Invalida';
                    if (!n.Valido__c) d.prod.motivoInvalido = 'Natureza da operação '+n.Natureza_da_opera_o__c+'– Inválida';
                }
            }
        }
        
    }
    
    
/***
 * 
 * 															¡STOPP!
 * 
 * 
 * 
 * 
 * Nexts methods and classes have been generated automatically and do not contain any business logic other than making a parser of the NFe object
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * *///
    
    
    
    
	public class IPI {

		public String CNPJProd {get;set;} 	

		public IPI(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'CNPJProd') {
							CNPJProd = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'IPI consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class InfNFe {
		public InfAdic infAdic {get;set;} 
		public List<Det> det {get;set;} 
		public Total total {get;set;} 
		public Pag pag {get;set;} 
		public String Id {get;set;} 
		public Ide ide {get;set;} 
		public Emit emit {get;set;} 
        public Cobr cobr{get;set;} 
		public Dest dest {get;set;} 
		public Transp transp {get;set;} 

		public InfNFe(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'infAdic') {
							infAdic = new InfAdic(parser);
						} else if (text == 'det') {
							det = arrayOfDet(parser);
						} else if (text == 'total') {
							total = new Total(parser);
						} else if (text == 'pag') {
							pag = new Pag(parser);
						} else if (text == 'Id') {
							Id = parser.getText();
						} else if (text == 'ide') {
							ide = new Ide(parser);
						} else if (text == 'emit') {
							emit = new Emit(parser);
						} else if (text == 'cobr') {
							cobr = new Cobr(parser);
						} else if (text == 'dest') {
							dest = new Dest(parser);
						} else if (text == 'transp') {
							transp = new Transp(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'InfNFe consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public NfeProc nfeProc {get;set;} 

	public NFeWapper(JSONParser parser) {   
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'nfeProc') {
                        if (parser.getText() == '' || parser.getText() == null) continue;      
						nfeProc = new NfeProc(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'NFeWapper consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class InfAdic {
		public String infCpl {get;set;} 

		public InfAdic(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'infCpl') {
							infCpl = parser.getText().replace('*', '\n*');
						} else {
							System.debug(LoggingLevel.WARN, 'InfAdic consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class EnderDest {
		public String xCpl {get;set;} 
		public String fone {get;set;} 
		public String UF {get;set;} 
		public String xPais {get;set;} 
		public Integer cPais {get;set;} 
		public String xLgr {get;set;} 
		public String xMun {get;set;} 
		public String nro {get;set;} 
		public Integer cMun {get;set;} 
		public String xBairro {get;set;} 
		public String CEP {get;set;} 
		public String email {get;set;} 

		public EnderDest(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'xCpl') {
							xCpl = parser.getText();
						} else if (text == 'fone') {
							fone = parser.getText();
						} else if (text == 'UF') {
							UF = parser.getText();
						} else if (text == 'xPais') {
							xPais = parser.getText();
						} else if (text == 'cPais') {
							cPais = parser.getIntegerValue();
						} else if (text == 'xLgr') {
							xLgr = parser.getText();
						} else if (text == 'xMun') {
							xMun = parser.getText();
						} else if (text == 'nro') {
							nro = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'cMun') {
							cMun = parser.getIntegerValue();
						} else if (text == 'xBairro') {
							xBairro = parser.getText();
						} else if (text == 'CEP') {
							CEP = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'EnderDest consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class ProtNFe {
		public InfProt infProt {get;set;} 

		public ProtNFe(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'infProt') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							infProt = new InfProt(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ProtNFe consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Ide {
		public String participante {get;set;} 
		public Integer tpNF {get;set;} 
		public Integer mod {get;set;} 
		public Integer indPres {get;set;} 
		public Integer tpImp {get;set;} 
		public Integer nNF {get;set;} 
		public Integer cMunFG {get;set;} 
		public Integer procEmi {get;set;} 
		public Integer finNFe {get;set;} 
		public String dhEmi {get;set;} 
		public Integer tpAmb {get;set;} 
		public Integer indFinal {get;set;} 
		public String dhSaiEnt {get;set;} 
		public Integer idDest {get;set;} 
		public Integer tpEmis {get;set;} 
		public Integer cDV {get;set;} 
		public Integer cUF {get;set;} 
		public Integer serie {get;set;} 
		public String natOp {get;set;} 
		public String cNF {get;set;} 
		public String verProc {get;set;} 

		public Ide(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'tpNF') {
							tpNF = parser.getIntegerValue();
						} else if (text == 'mod') {
							mod = parser.getIntegerValue();
						} else if (text == 'indPres') {
							indPres = parser.getIntegerValue();
						} else if (text == 'tpImp') {
							tpImp = parser.getIntegerValue();
						} else if (text == 'nNF') {
							nNF = parser.getIntegerValue();
						} else if (text == 'cMunFG') {
							cMunFG = parser.getIntegerValue();
						} else if (text == 'procEmi') {
							procEmi = parser.getIntegerValue();
						} else if (text == 'finNFe') {
							finNFe = parser.getIntegerValue();
						} else if (text == 'dhEmi') {
							dhEmi = parser.getText();
						} else if (text == 'tpAmb') {
							tpAmb = parser.getIntegerValue();
						} else if (text == 'indFinal') {
							indFinal = parser.getIntegerValue();
						} else if (text == 'dhSaiEnt') {
							dhSaiEnt = parser.getText();
						} else if (text == 'idDest') {
							idDest = parser.getIntegerValue();
						} else if (text == 'tpEmis') {
							tpEmis = parser.getIntegerValue();
						} else if (text == 'cDV') {
							cDV = parser.getIntegerValue();
						} else if (text == 'cUF') {
							cUF = parser.getIntegerValue();
						} else if (text == 'serie') {
							serie = parser.getIntegerValue();
						} else if (text == 'natOp') {
							natOp = parser.getText();
						} else if (text == 'cNF') {
							cNF = parser.getText();
						} else if (text == 'verProc') {
							verProc = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Ide consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Imposto {
		public IPI IPI {get;set;} 
		public Double vTotTrib {get;set;} 

		public Imposto(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'vTotTrib') {
							vTotTrib = parser.getDoubleValue();
						} else if (text == 'IPI') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							IPI = new IPI(parser);
						}  else {
							System.debug(LoggingLevel.WARN, 'Imposto consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Prod {
		public Id productId {get;set;} 
        public String validade {get;set;} 
        public String motivoInvalido{get;set;} 
        public Integer quantityReal {get;set;} 
        public string xPed {get;set;} 
        public String nItemPed {get;set;} 
		public String cEAN {get;set;} 
		public String cProd {get;set;} 
		public Integer qCom {get;set;} 
		public String cEANTrib {get;set;} 
		public Double vUnTrib {get;set;} 
		public Integer qTrib {get;set;} 
		public Double vProd {get;set;} 
		public String xProd {get;set;} 
		public Double vUnCom {get;set;} 
		public Double vFrete {get;set;} 
		public Double vSeg {get;set;} 
		public Double vDesc {get;set;} 
		public Double vOutro {get;set;} 
		public Integer indTot {get;set;} 
		public String indEscala {get;set;} 
		public String uTrib {get;set;} 
		public String NCM {get;set;} 
		public String uCom {get;set;} 
		public Integer CFOP {get;set;} 
		public String CEST {get;set;} 
		public String nFCI {get;set;} 
		public String cBenef {get;set;} 

		public Prod(JSONParser parser) {
            
            
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'cEAN') {
							cEAN = parser.getText();
						} else if (text == 'cProd') {
							cProd = parser.getText();
						} else if (text == 'qCom') {
							qCom = parser.getIntegerValue();
                            quantityReal = qCom;
						} else if (text == 'cBenef') {
							cBenef = parser.getText();
						} else if (text == 'xPed') {
							xPed = parser.getText();
						} else if (text == 'nItemPed') {
							nItemPed = parser.getText();
						} else if (text == 'nFCI') {
							nFCI = parser.getText();
						} else if (text == 'vFrete') {
							vFrete = parser.getDoubleValue();
						} else if (text == 'vSeg') {
							vSeg = parser.getDoubleValue();
						} else if (text == 'vDesc') {
							vDesc = parser.getDoubleValue();
						} else if (text == 'vOutro') {
							vOutro = parser.getDoubleValue();
						} else if (text == 'cEANTrib') {
							cEANTrib = parser.getText();
						} else if (text == 'vUnTrib') {
							vUnTrib = parser.getDoubleValue();
						} else if (text == 'qTrib') {
							qTrib = parser.getIntegerValue();
						} else if (text == 'quantityReal') {
							quantityReal = Integer.valueOf(parser.getText());
						} else if (text == 'vProd') {
							vProd = parser.getDoubleValue();
						} else if (text == 'xProd') {
							xProd = parser.getText();
						} else if (text == 'indEscala') {
							indEscala = parser.getText();
						} else if (text == 'vUnCom') {
							vUnCom = parser.getDoubleValue();
						} else if (text == 'indTot') {
							indTot = parser.getIntegerValue();
						} else if (text == 'uTrib') {
							uTrib = parser.getText();
						} else if (text == 'NCM') {
							NCM = parser.getText();
						} else if (text == 'uCom') {
							uCom = parser.getText();
						} else if (text == 'CFOP') {
							CFOP = parser.getIntegerValue();
						} else if (text == 'CEST') {
							CEST = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Prod consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Emit {
        public Id accountId {get;set;}
		public String CNAE {get;set;} 
		public String xNome {get;set;} 
		public String  IM {get;set;} 
		public Integer CRT {get;set;} 
		public String xFant {get;set;} 
		public String CNPJ {get;set;} 
		public String CPF {get;set;} 
		public EnderEmit enderEmit {get;set;} 
		public String IE {get;set;} 

		public Emit(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'accountId') {
							accountId = parser.getText();
                        } else if (text == 'CNAE') {
							CNAE = parser.getText();
						} else if (text == 'xNome') {
							xNome = parser.getText();
						} else if (text == 'IM') {
							IM = parser.getText();
						} else if (text == 'CRT') {
							CRT = parser.getIntegerValue();
						} else if (text == 'xFant') {
							xFant = parser.getText();
						} else if (text == 'CNPJ') {
							CNPJ = parser.getText();
                            String CNPJOnlyNumeric = CNPJ.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', ''); 
                            
                            List<Account> cuentas = [SELECT Id FROM Account WHERE CNPJ_CPF_Solo_Numeros__c = :CNPJOnlyNumeric];
                            if (cuentas.size() != 0) {
                                accountId = cuentas[0].id;
                            }         
						} else if (text == 'CPF') {
							CPF = parser.getText();
                            
                            String CPFOnlyNumeric = CPF.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', ''); 
                            
                            List<Account> cuentas = [SELECT Id FROM Account WHERE CNPJ_CPF_Solo_Numeros__c = :CPFOnlyNumeric];
                            if (cuentas.size() != 0) {
                                accountId = cuentas[0].id;
                            }          
                            
						} else if (text == 'enderEmit') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							enderEmit = new EnderEmit(parser);
						} else if (text == 'IE') {
							IE = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Emit consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Transporta {
		public String xNome {get;set;} 
		public String UF {get;set;} 
		public String xEnder {get;set;} 
		public String xMun {get;set;} 
		public String CNPJ {get;set;} 
		public String IE {get;set;} 

		public Transporta(JSONParser parser) {
            System.debug(parser);
            
			while (parser.nextToken() != System.JSONToken.END_OBJECT  && parser.getCurrentToken() != System.JSONToken.END_ARRAY ) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'xNome') {
							xNome = parser.getText();
						} else if (text == 'UF') {
							UF = parser.getText();
						} else if (text == 'xEnder') {
							xEnder = parser.getText();
						} else if (text == 'xMun') {
							xMun = parser.getText();
						} else if (text == 'CNPJ') {
							CNPJ = parser.getText();
						} else if (text == 'IE') {
							IE = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Transporta consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class InfProt {
		public Long nProt {get;set;} 
		public String digVal {get;set;} 
		public String dhRecbto {get;set;} 
		public String Id {get;set;} 
		public String chNFe {get;set;} 
		public String xMotivo {get;set;} 
		public Integer cStat {get;set;} 

		public InfProt(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'nProt') {
							nProt = parser.getLongValue();
						} else if (text == 'digVal') {
							digVal = parser.getText();
						} else if (text == 'dhRecbto') {
							dhRecbto = parser.getText();
						} else if (text == 'Id') {
							Id = parser.getText();
						} else if (text == 'chNFe') {
							chNFe = parser.getText();
						} else if (text == 'xMotivo') {
							xMotivo = parser.getText();
						} else if (text == 'cStat') {
							cStat = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'InfProt consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public class Dest {
        public Id accountId {get;set;}
		public String xNome {get;set;} 
		public String CNPJ {get;set;} 
		public String CPF {get;set;} 
		public EnderDest enderDest {get;set;} 
		public String IE {get;set;} 
		public String indIEDest {get;set;} 

		public String email {get;set;} 

		public Dest(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'xNome') {
							xNome = parser.getText();
                        } else if (text == 'accountId') {
							accountId = parser.getText();
						} else if (text == 'CNPJ') {
							CNPJ = parser.getText();
                            
                            String CNPJOnlyNumeric = CNPJ.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', ''); 
                            
                            List<Account> cuentas = [SELECT Id FROM Account WHERE CNPJ_CPF_Solo_Numeros__c = :CNPJOnlyNumeric];
                            if (cuentas.size() != 0) {
                                accountId = cuentas[0].id;
                            }          
                            
						} else if (text == 'CPF') {
							CPF = parser.getText();
                            
                            String CPFOnlyNumeric = CPF.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', ''); 
                            
                            List<Account> cuentas = [SELECT Id FROM Account WHERE CNPJ_CPF_Solo_Numeros__c = :CPFOnlyNumeric];
                            if (cuentas.size() != 0) {
                                accountId = cuentas[0].id;
                            }          
                            
						} else if (text == 'enderDest') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							enderDest = new EnderDest(parser);
						} else if (text == 'IE') {
							IE = parser.getText();
						} else if (text == 'indIEDest') {
							indIEDest = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Dest consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Transp {
		public String modFrete {get;set;} 
		public Vol vol {get;set;}
		public VeicTransp veicTransp {get;set;} 
		public Transporta transporta {get;set;} 

		public Transp(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'modFrete') {
							modFrete = parser.getText();
						} else if (text == 'vol') {
                            if (parser.getText() == '' || parser.getText() == null) continue;                  
							vol = new Vol(parser);
						} else if (text == 'transporta') {
                            if (parser.getText() == '' || parser.getText() == null) continue;                            
							transporta = new Transporta(parser);
						} else if (text == 'veicTransp') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							veicTransp = new VeicTransp(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Transp consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ICMSTot {
		public Integer vCOFINS {get;set;} 
		public Integer vBCST {get;set;} 
		public Integer vICMSDeson {get;set;} 
		public Double vProd {get;set;} 
		public Integer vSeg {get;set;} 
		public Integer vFCP {get;set;} 
		public Integer vFCPST {get;set;} 
		public Double vNF {get;set;} 
		public Double vTotTrib {get;set;} 
		public Integer vPIS {get;set;} 
		public Integer vIPIDevol {get;set;} 
		public Integer vBC {get;set;} 
		public Integer vST {get;set;} 
		public Integer vICMS {get;set;} 
		public Integer vII {get;set;} 
		public Integer vFCPSTRet {get;set;} 
		public Integer vDesc {get;set;} 
		public Integer vOutro {get;set;} 
		public Integer vIPI {get;set;} 
		public Integer vFrete {get;set;} 

		public ICMSTot(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'vCOFINS') {
							vCOFINS = parser.getIntegerValue();
						} else if (text == 'vBCST') {
							vBCST = parser.getIntegerValue(); //vTotTrib
						} else if (text == 'vICMSDeson') {
							vICMSDeson = parser.getIntegerValue();
						} else if (text == 'vProd') {
							vICMSDeson = parser.getIntegerValue();
						} else if (text == 'vTotTrib') {
							vTotTrib = parser.getDoubleValue();
						} else if (text == 'vSeg') {
							vSeg = parser.getIntegerValue();
						} else if (text == 'vFCP') {
							vFCP = parser.getIntegerValue();
						} else if (text == 'vFCPST') {
							vFCPST = parser.getIntegerValue();
						} else if (text == 'vNF') {
							vNF = parser.getDoubleValue();
						} else if (text == 'vPIS') {
							vPIS = parser.getIntegerValue();
						} else if (text == 'vIPIDevol') {
							vIPIDevol = parser.getIntegerValue();	
						} else if (text == 'vBC') {
							vBC = parser.getIntegerValue();
						} else if (text == 'vST') {
							vST = parser.getIntegerValue();
						} else if (text == 'vICMS') {
							vICMS = parser.getIntegerValue();
						} else if (text == 'vII') {
							vII = parser.getIntegerValue();
						} else if (text == 'vFCPSTRet') {
							vFCPSTRet = parser.getIntegerValue();
						} else if (text == 'vDesc') {
							vDesc = parser.getIntegerValue();
						} else if (text == 'vOutro') {
							vOutro = parser.getIntegerValue();
						} else if (text == 'vIPI') {
							vIPI = parser.getIntegerValue();
						} else if (text == 'vFrete') {
							vFrete = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'ICMSTot consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class NfeProc {
		public ProtNFe protNFe {get;set;} 
		public NFe NFe {get;set;} 
		public Integer versao {get;set;} 

		public NfeProc(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'protNFe') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							protNFe = new ProtNFe(parser);
						} else if (text == 'NFe') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							NFe = new NFe(parser);
						} else if (text == 'versao') {
							versao = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'NfeProc consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class NFe {
		public InfNFe infNFe {get;set;} 

		public NFe(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'infNFe') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							infNFe = new InfNFe(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'NFe consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DetPag {
		public Double vPag {get;set;} 
		public String tPag {get;set;} 

		public DetPag(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'vPag') {
							vPag = parser.getDoubleValue();
						} else if (text == 'tPag') {
							tPag = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DetPag consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Det {
		public Integer nItem {get;set;} 
		public Prod prod {get;set;} 
		public Imposto imposto {get;set;} 
        public string infAdProd {get;set;} 

		public Det(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                	String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'nItem') {
							nItem = parser.getIntegerValue();
                        } else if (text == 'infAdProd') {
							infAdProd = parser.getText();
						}else if (text == 'prod') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							prod = new Prod(parser);
						} else if (text == 'imposto') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							imposto = new Imposto(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Det consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
    
    public class Cobr {
		public Dup dup {get;set;} 

		public Cobr(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'dup') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							dup = arrayOfDup(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Det consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
    
    public class Dup {
		public String dVenc {get;set;} 
		public String nDup {get;set;} 
		public Decimal vDup {get;set;} 

		public Dup(JSONParser parser) {
            System.JSONToken token = parser.nextToken();
			while (token != System.JSONToken.END_OBJECT && token != System.JSONToken.END_ARRAY) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'dVenc') {
							dVenc = parser.getText();
                        } else if (text == 'nDup') {
							nDup = parser.getText();
                        } else if (text == 'vDup') {
							vDup = parser.getDecimalValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Det consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
                	token = parser.nextToken();
				}
			}
		}
	}
	
	
	public class Vol {
		public Double pesoL {get;set;} 
		public String esp {get;set;} 
		public String marca {get;set;} 
		public String nVol {get;set;} 
		public Integer qVol {get;set;} 
		public Double pesoB {get;set;} 

		public Vol(JSONParser parser) {
            
			while (parser.nextToken() != System.JSONToken.END_OBJECT && parser.getCurrentToken() != System.JSONToken.END_ARRAY) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'pesoL') {
							pesoL = parser.getDoubleValue();
						} else if (text == 'qVol') {
							qVol = parser.getIntegerValue();
						} else if (text == 'esp') {
							esp = parser.getText();
						} else if (text == 'marca') {
							marca = parser.getText();
						} else if (text == 'nVol') {
							nVol = parser.getText();
						} else if (text == 'pesoB') {
							pesoB = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Vol consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
    
	public class VeicTransp {
		public String placa {get;set;} 
		public String UF {get;set;} 
		public String RNTC {get;set;} 

		public VeicTransp(JSONParser parser) {
            
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
                    System.debug(text);
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'placa') {
							placa = parser.getText();
						} else if (text == 'UF') {
							UF = parser.getText();
						} else if (text == 'RNTC') {
							RNTC = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'VeicTransp consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Total {
		public ICMSTot ICMSTot {get;set;} 

		public Total(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ICMSTot') {
                            if (parser.getText() == '' || parser.getText() == null) continue;      
							ICMSTot = new ICMSTot(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Total consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
        }
    }
	public class Pag {
		public List<DetPag> detPag {get;set;} 

		public Pag(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'detPag') {
							detPag = arrayOfDetPag(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Pag consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class EnderEmit {
		public String fone {get;set;} 
		public String UF {get;set;} 
		public String xPais {get;set;} 
		public Integer cPais {get;set;} 
		public String xLgr {get;set;} 
		public String xMun {get;set;} 
		public String nro {get;set;} 
		public Integer cMun {get;set;} 
		public String xBairro {get;set;} 
		public String CEP {get;set;} 

		public EnderEmit(JSONParser parser) {
            
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'fone') {
							fone = parser.getText();
						} else if (text == 'UF') {
							UF = parser.getText();
						} else if (text == 'xPais') {
							xPais = parser.getText();
						} else if (text == 'cPais') {
							cPais = parser.getIntegerValue();
						} else if (text == 'xLgr') {
							xLgr = parser.getText();
						} else if (text == 'xMun') {
							xMun = parser.getText();
						} else if (text == 'nro') {
							nro = parser.getText();
						} else if (text == 'cMun') {
							cMun = parser.getIntegerValue();
						} else if (text == 'xBairro') {
							xBairro = parser.getText();
						} else if (text == 'CEP') {
							CEP = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'EnderEmit consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	
	public static NFeWapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		NFeWapper nfe = new NFeWapper(parser);
        nfe.setProducts();
		return nfe;
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	


    private static List<Det> arrayOfDet(System.JSONParser p) {
        List<Det> res = new List<Det>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Det(p));
        }
        return res;
    }



    private static List<DetPag> arrayOfDetPag(System.JSONParser p) {
        List<DetPag> res = new List<DetPag>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new DetPag(p));
        }
        return res;
    }


    private static Dup arrayOfDup(System.JSONParser p) {
        List<Dup> res = new List<Dup>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Dup(p));
        }
        return res[0];
    }


}
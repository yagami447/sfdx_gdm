@IsTest
public class NFeWapperTest {
    @testSetup static void setup() {
        Product2 prod = new Product2(Name='Generico Nota Fiscal');
        insert prod;
        
        PricebookEntry sPBE = new PricebookEntry(Pricebook2Id = test.getStandardPricebookId(), Product2Id = prod.id, UnitPrice = 1000);
        insert sPBE;
        
        
    }
    
	@isTest
    static void debeCrearProductoDeOportunidad() {
        string json = '{"nfeProc":{"versao":2,"protNFe":{"infProt":{"xMotivo":null,"nProt":null,"Id":null,"digVal":null,"dhRecbto":null,"cStat":null,"chNFe":"53131205035672000156550010000004991543410167"}},"NFe":{"infNFe":{"transp":{"vol":null,"veicTransp":null,"transporta":{"xNome":null,"xMun":null,"xEnder":",","UF":null,"IE":null,"CNPJ":null},"modFrete":"0"},"total":{"ICMSTot":{"vTotTrib":null,"vST":0,"vSeg":0,"vProd":null,"vPIS":0,"vOutro":0,"vNF":181.74,"vIPIDevol":null,"vIPI":0,"vII":0,"vICMSDeson":0,"vICMS":0,"vFrete":0,"vFCPSTRet":null,"vFCPST":null,"vFCP":null,"vDesc":0,"vCOFINS":0,"vBCST":0,"vBC":0}},"pag":null,"infAdic":{"obsCont":null,"infCpl":"DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL"},"ide":{"verProc":"Service_NFe_Util_v2G","tpNF":1,"tpImp":1,"tpEmis":1,"tpAmb":1,"serie":1,"procEmi":0,"nNF":499,"natOp":"PRESTACAO DE SERVICOS SUJEITOS A ISSQN","mod":55,"indPres":null,"indFinal":null,"idDest":null,"finNFe":1,"dhSaiEnt":null,"dhEmi":null,"cUF":53,"cNF":"54341016","cMunFG":5300108,"cDV":6},"Id":"NFe53131205035672000156550010000004991543410167","emit":{"xNome":"EMPRESA DE SEGURANCA FICTICIA E SERVICOS LTDA - EPP","xFant":"EMPRESA FICTICIA","IM":"1234567891234","IE":"0743340400127","enderEmit":{"xPais":"Brasil","xMun":"BRASILIA","xLgr":"BAIRRO FICTICIO DA CIDADE FICTICIA","xBairro":"ASA SUL","UF":"DF","nro":"S/N","fone":6111235678,"cPais":1058,"cMun":5300108,"CEP":"70000000"},"CRT":1,"CNPJ":"99348255000107","CNAE":8020000,"accountId":null},"det":[{"prod":{"xProd":"REF. A PRESTACAO DE SERVICO DE SEGURANCA ELETRONICA.*/* DEZEMBRO/2013","xPed":null,"vUnTrib":181.74,"vUnCom":181.74,"vSeg":null,"vProd":181.74,"vOutro":null,"vFrete":null,"vDesc":null,"uTrib":"UN","uCom":"UN","rastro":null,"quantityReal":1,"qTrib":1,"qCom":1,"nItemPed":null,"nFCI":null,"NCM":"00","indTot":0,"indEscala":null,"cProd":"S0000000000","CFOP":5933,"CEST":null,"cEANTrib":"","cEAN":"","cBenef":null},"nItem":1,"imposto":{"vTotTrib":null,"PIS":{"PISNT":null},"IPI":null,"ICMS":null,"COFINS":{"COFINSNT":null}}}],"dest":{"xNome":"CARLOS ALBERTO FICTICIO","indIEDest":null,"IE":"ISENTO","enderDest":{"xPais":"BRASIL","xMun":"BRASILIA","xLgr":"BAIRRO E QUADRA FICTICIA","xCpl":null,"xBairro":"BAIRRO FICTICIO","UF":"DF","nro":"34","fone":61999999911,"cPais":1058,"cMun":5300108,"CEP":"70000000"},"email":"email1teste@dominioqualquer.com.br;email2teste@dominio2qualquer.com","CNPJ":null,"accountId":null},"cobr":null}}}}';
        Pricebook2 pricebook = new Pricebook2(id=test.getStandardPricebookId(), isActive=true);
        update pricebook;
        
        NFeWapper nfe = NFeWapper.parse(json);
        Nota_Fiscal_Eletr_nica__c opp = nfe.createOpportunity();
        insert opp;
        
        Product2 product = new Product2(Name='Generico Nota Fiscal');
        insert product;
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = product.id;
        pbe.UnitPrice = 1;
        pbe.Pricebook2Id = pricebook.id;
        pbe.IsActive = true;
        insert pbe;
           List<Produto_da_nota_fiscal__c> productosDeOportunidad;
       // List<OpportunityLineItem> olis = [SELECT ID FROM OpportunityLineItem WHERE OpportunityId =: opp.Id];

        test.startTest();
            productosDeOportunidad = nfe.createItems(opp.id);
        	insert productosDeOportunidad;
        test.stopTest();
        
        for(Produto_da_nota_fiscal__c productoDeOportunidad: productosDeOportunidad) {
            system.assertEquals(productoDeOportunidad.Nota_Fiscal_Eletr_nica__c, opp.id);
          	system.assertEquals(productoDeOportunidad.Quantity__c, 1);
            system.assertEquals(productoDeOportunidad.Unidade_Comercial__c, 'UN');
            system.assertEquals(productoDeOportunidad.TotalPrice__c, 181.74);
            system.assertEquals(productoDeOportunidad.Valor_Aproximado_dos_Tributos__c, null);
            system.assertEquals(productoDeOportunidad.CNPJ_do_Fabricante_da_Mercadoria__c, null);
            system.assertEquals(productoDeOportunidad.Codigo_do_produto__c, 'S0000000000');
            system.assertEquals(productoDeOportunidad.Codigo_NCM__c, '00');
            system.assertEquals(productoDeOportunidad.Codigo_CEST__c,  null);
            system.assertEquals(productoDeOportunidad.Indicador_de_Escala_Relevante__c, null);
            system.assertEquals(productoDeOportunidad.Valor_do_Desconto__c, null);
            system.assertEquals(productoDeOportunidad.Valor_Total_do_Frete__c, null);
            system.assertEquals(productoDeOportunidad.Valor_do_Seguro__c, null);
            system.assertEquals(productoDeOportunidad.Quantidade_Comercial__c, 1);
            system.assertEquals(productoDeOportunidad.GTIN_o_Codigo_EAN_Tributavel__c, '');
            system.assertEquals(productoDeOportunidad.Unidade_Tributavel__c, 'UN');
            system.assertEquals(productoDeOportunidad.Quantidade_Tributavel__c, 1);
            system.assertEquals(productoDeOportunidad.Valor_unitario_de_comercializacao__c, 181.74);
            system.assertEquals(productoDeOportunidad.Valor_unitario_de_tributacao__c, 181.74);
            system.assertEquals(productoDeOportunidad.Numero_do_pedido_de_compra__c, null);
            system.assertEquals(productoDeOportunidad.Item_do_pedido_de_compra__c, null);
            system.assertEquals(productoDeOportunidad.Numero_da_FCI__c, null); /**/
		
        }
		//List<OpportunityLineItem> olisActuales = [SELECT ID FROM OpportunityLineItem WHERE OpportunityId =: opp.id];
        //system.assertEquals(olis.size()+1, olisActuales.size());
    }
    
    @isTest
    static void debeCrearOportunidad() {
		
		Account emit = Build.anAccount().withName('Emit').withCNPJCPF('99348255000107').build();
		insert emit;
		Account dest = Build.anAccount().withName('Dest').withCNPJCPF('99348255000108').build();
		insert dest;

        string json = '{"nfeProc":{"versao":2,"protNFe":{"infProt":{"xMotivo":null,"nProt":null,"Id":null,"digVal":null,"dhRecbto":null,"cStat":null,"chNFe":"53131205035672000156550010000004991543410167"}},"NFe":{"infNFe":{"transp":{"vol":null,"veicTransp":null,"transporta":{"xNome":null,"xMun":null,"xEnder":",","UF":null,"IE":null,"CNPJ":null},"modFrete":"0"},"total":{"ICMSTot":{"vTotTrib":null,"vST":0,"vSeg":0,"vProd":null,"vPIS":0,"vOutro":0,"vNF":181.74,"vIPIDevol":null,"vIPI":0,"vII":0,"vICMSDeson":0,"vICMS":0,"vFrete":0,"vFCPSTRet":null,"vFCPST":null,"vFCP":null,"vDesc":0,"vCOFINS":0,"vBCST":0,"vBC":0}},"pag":null,"infAdic":{"obsCont":null,"infCpl":"DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL"},"ide":{"verProc":"Service_NFe_Util_v2G","tpNF":1,"tpImp":1,"tpEmis":1,"tpAmb":1,"serie":1,"procEmi":0,"nNF":499,"natOp":"PRESTACAO DE SERVICOS SUJEITOS A ISSQN","mod":55,"indPres":null,"indFinal":null,"idDest":null,"finNFe":1,"dhSaiEnt":null,"dhEmi":null,"cUF":53,"cNF":"54341016","cMunFG":5300108,"cDV":6},"Id":"NFe53131205035672000156550010000004991543410167","emit":{"xNome":"EMPRESA DE SEGURANCA FICTICIA E SERVICOS LTDA - EPP","xFant":"EMPRESA FICTICIA","IM":"1234567891234","IE":"0743340400127","enderEmit":{"xPais":"Brasil","xMun":"BRASILIA","xLgr":"BAIRRO FICTICIO DA CIDADE FICTICIA","xBairro":"ASA SUL","UF":"DF","nro":"S/N","fone":6111235678,"cPais":1058,"cMun":5300108,"CEP":"70000000"},"CRT":1,"CNPJ":"99348255000107","CNAE":8020000,"accountId":null},"det":[{"prod":{"xProd":"REF. A PRESTACAO DE SERVICO DE SEGURANCA ELETRONICA.*/* DEZEMBRO/2013*/*MONITORAMENTO COM APOIO DE VEICULO4174*/*CONTRA","xPed":null,"vUnTrib":181.74,"vUnCom":181.74,"vSeg":null,"vProd":181.74,"vOutro":null,"vFrete":null,"vDesc":null,"uTrib":"UN","uCom":"UN","rastro":null,"quantityReal":null,"qTrib":1,"qCom":1,"nItemPed":null,"nFCI":null,"NCM":"00","indTot":0,"indEscala":null,"cProd":"S0000000000","CFOP":5933,"CEST":null,"cEANTrib":"","cEAN":"","cBenef":null},"nItem":1,"imposto":{"vTotTrib":null,"PIS":{"PISNT":null},"IPI":null,"ICMS":null,"COFINS":{"COFINSNT":null}}}],"dest":{"xNome":"CARLOS ALBERTO FICTICIO","indIEDest":null,"IE":"ISENTO","enderDest":{"xPais":"BRASIL","xMun":"BRASILIA","xLgr":"BAIRRO E QUADRA FICTICIA","xCpl":null,"xBairro":"BAIRRO FICTICIO","UF":"DF","nro":"34","fone":61999999911,"cPais":1058,"cMun":5300108,"CEP":"70000000"},"email":"email1teste@dominioqualquer.com.br;email2teste@dominio2qualquer.com","CNPJ":"99348255000108","accountId":null},"cobr":null}}}}';
        Pricebook2 pricebook = new Pricebook2(id=test.getStandardPricebookId(), isActive=true);
        update pricebook;
        
        Product2 product = new Product2(Name='Generico Nota Fiscal');
        insert product;

        
        test.startTest();
        	NFeWapper nfe = NFeWapper.parse(json);
        	Nota_Fiscal_Eletr_nica__c opp = nfe.createOpportunity();
        	insert opp;
        test.stopTest();
        
        
        system.assertEquals(opp.NFe__c, '53131205035672000156550010000004991543410167');
        system.assertEquals(opp.Codigo_do_Modelo_do_Documento_Fiscal__c, '55');
        system.assertEquals(opp.Serie_Do_Documento_Fiscal__c, 1);
        system.assertEquals(opp.Numero_do_Documento_Fiscal__c, 499);
		system.assertEquals(opp.Data_e_hora_de_Emissao_do_Documento__c, null);
        system.assertEquals(opp.Data_e_hora_de_Saida_ou_da_Entrada__c, null);
        system.assertEquals(opp.Natureza_da_Opera_o__c, 'PRESTACAO DE SERVICOS SUJEITOS A ISSQN');
        system.assertEquals(opp.Tipo_de_Operacao_NFe__c, '1');
        system.assertEquals(opp.Valor_Total_dos_productos_e_servicos__c, null);
        system.assertEquals(opp.Valor_do_Frete__c, 0);
        system.assertEquals(opp.Valor_do_Seguro__c, 0);
        system.assertEquals(opp.Valor_Total_dos_Descontos__c, 0);
        system.assertEquals(opp.Valor_Total_da_NFe__c , 181.74);
        system.assertEquals(opp.Valor_Aproximado_dos_Tributos__c, null);
        
        system.assertEquals(opp.Modalidade_do_frete__c, '0');
        system.assertEquals(opp.Nome_Transporta__c, null);
        system.assertEquals(opp.Inscricao_Estadual_do_Transportador__c, null);
        system.assertEquals(opp.Endereco_Completo__c, ',');
        system.assertEquals(opp.Municipio_Transportador__c, null);
        system.assertEquals(opp.UF_Transportador__c, null);
        system.assertEquals(opp.Placa_veiculo__c, null);
        system.assertEquals(opp.UF_Veiculo__c, null);
        system.assertEquals(opp.RNTC__c, null);
        
        system.assertEquals(opp.Volumes_Transportados__c, null);
        system.assertEquals(opp.Especie_Dos_Volumes_Transportados__c, null);
        system.assertEquals(opp.Marca_Dos_Volumes_Transportados__C, null);

        system.assertEquals(opp.Peso_Liquido_Volumes_Transportados__C, null);
        system.assertEquals(opp.Peso_Bruto_Volumes_Transportados__c, null);
        
        system.assertEquals(opp.Numero_da_Duplicata__c, null);
        system.assertEquals(opp.Data_da_Vencimiento_Duplicata__c, null);
        system.assertEquals(opp.Valor_da_Duplicata__c, null);

        system.assertEquals(opp.Forma_de_pagamento__c, null);
        system.assertEquals(opp.Valor_do_Pagamento__c, null);

        system.assertEquals(opp.Informa_es_Complementares_de_Interesse__c, 'DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL');

		System.assertEquals(emit.Id, opp.Emitente__c, 'El emitente no esta relacionado a la nota fiscal');
		System.assertEquals(dest.Id, opp.Destinatario__c, 'El destinatario no esta relacionado a la nota fiscal');

    }
    
    
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"nfeProc\": {'+
		'    \"protNFe\": {'+
		'      \"infProt\": {'+
		'        \"nProt\": 55455534534,'+
		'        \"digVal\": \"jfdgh76tr542786rteuhyfbwef8=\",'+
		'        \"dhRecbto\": \"2019-07-22T09:34:06-03:00\",'+
		'        \"Id\": \"Id445345345\",'+
		'        \"chNFe\": \"87878774456468954646464654654546545446579312\",'+
		'        \"xMotivo\": \"Autorizado o uso da NF-e\",'+
		'        \"cStat\": 100'+
		'      }'+
		'    },'+
		'    \"NFe\": {'+
		'      \"infNFe\": {'+
		'        \"infAdic\": {'+
		'          \"infCpl\": \"Lorem ipsum dolor...\",'+
		'          \"obsCont\": ['+
		'            {'+
		'              \"xCampo\": \"LEI DA TRANSPARENCIA\",'+
		'              \"xTexto\": \"O VALOR APROXIMADO DE TRIBUTOS INCIDENTES SOBRE O PRECO DESTE SERVICO E DE R$ 5.62 (16.06) FONTE: IBPT\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        \"det\": ['+
		'          {'+
		'            \"nItem\": 1,'+
		'            \"prod\": {'+
		'              \"cEAN\": \"SEM GTIN\",'+
		'              \"cProd\": \"JC59-00035A-SI\",'+
		'              \"qCom\": 1,'+
		'              \"cEANTrib\": \"SEM GTIN\",'+
		'              \"vUnTrib\": 265.79,'+
		'              \"qTrib\": 1,'+
		'              \"vProd\": 265.79,'+
		'              \"xProd\": \"UNIDADE DE DISCO RIGIDO 320GB\",'+
		'              \"vUnCom\": 265.79,'+
		'              \"indTot\": 1,'+
		'              \"uTrib\": \"UN\",'+
		'              \"NCM\": 84717012,'+
		'              \"uCom\": \"UN\",'+
		'              \"CFOP\": 5949,'+
		'              \"CEST\": 2103300,'+
		'              \"rastro\": ['+
		'                \"Item qualquer 1\",'+
		'                \"Item qualquer 2\"'+
		'              ]'+
		'            },'+
		'            \"imposto\": {'+
		'              \"ICMS\": {'+
		'                \"ICMS40\": {'+
		'                  \"orig\": 1,'+
		'                  \"CST\": 41'+
		'                }'+
		'              },'+
		'              \"IPI\": {'+
		'                \"IPINT\": {'+
		'                  \"CST\": 53'+
		'                },'+
		'                \"cEnq\": 999'+
		'              },'+
		'              \"COFINS\": {'+
		'                \"COFINSNT\": {'+
		'                  \"CST\": \"07\"'+
		'                }'+
		'              },'+
		'              \"PIS\": {'+
		'                \"PISNT\": {'+
		'                  \"CST\": \"07\"'+
		'                }'+
		'              }'+
		'            }'+
		'          }'+
		'        ],'+
		'        \"total\": {'+
		'          \"ICMSTot\": {'+
		'            \"vCOFINS\": 0,'+
		'            \"vBCST\": 0,'+
		'            \"vICMSDeson\": 0,'+
		'            \"vProd\": 265.79,'+
		'            \"vSeg\": 0,'+
		'            \"vFCP\": 0,'+
		'            \"vFCPST\": 0,'+
		'            \"vNF\": 265.79,'+
		'            \"vPIS\": 0,'+
		'            \"vIPIDevol\": 0,'+
		'            \"vBC\": 0,'+
		'            \"vST\": 0,'+
		'            \"vICMS\": 0,'+
		'            \"vII\": 0,'+
		'            \"vFCPSTRet\": 0,'+
		'            \"vDesc\": 0,'+
		'            \"vOutro\": 0,'+
		'            \"vIPI\": 0,'+
		'            \"vFrete\": 0'+
		'          }'+
		'        },'+
		'        \"pag\": {'+
		'          \"detPag\": ['+
		'            {'+
		'              \"vPag\": 265.79,'+
		'              \"tPag\": 99'+
		'            }'+
		'          ]'+
		'        },'+
		'        \"Id\": \"NFe87878774456468954646464654654546545446579312\",'+
		'        \"ide\": {'+
		'          \"tpNF\": 1,'+
		'          \"mod\": 55,'+
		'          \"indPres\": 0,'+
		'          \"tpImp\": 1,'+
		'          \"nNF\": 1353368,'+
		'          \"cMunFG\": 3534401,'+
		'          \"procEmi\": 0,'+
		'          \"finNFe\": 1,'+
		'          \"dhEmi\": \"2019-07-22T09:33:31-03:00\",'+
		'          \"tpAmb\": 1,'+
		'          \"indFinal\": 1,'+
		'          \"dhSaiEnt\": \"2019-07-22T09:33:31-03:00\",'+
		'          \"idDest\": 1,'+
		'          \"tpEmis\": 1,'+
		'          \"cDV\": 0,'+
		'          \"cUF\": 35,'+
		'          \"serie\": 3,'+
		'          \"natOp\": \"Outra saida merc./prestacao serv. nao espec.\",'+
		'          \"cNF\": \"00012763\",'+
		'          \"verProc\": \"5.0.1500.2985\"'+
		'        },'+
		'        \"emit\": {'+
		'          \"CNAE\": 34324,'+
		'          \"xNome\": \"ACME SERVICOS LTDA\",'+
		'          \"IM\": 96852,'+
		'          \"CRT\": 3,'+
		'          \"xFant\": \"ACME SERVICOS LTDA\",'+
		'          \"CNPJ\": \"4545345345345\",'+
		'          \"enderEmit\": {'+
		'            \"fone\": 4534534534,'+
		'            \"UF\": \"SP\",'+
		'            \"xPais\": \"Brasil\",'+
		'            \"cPais\": 1058,'+
		'            \"xLgr\": \"AV Paulista\",'+
		'            \"xMun\": \"São Paulo\",'+
		'            \"nro\": 628,'+
		'            \"cMun\": 454545,'+
		'            \"xBairro\": \"Bairro do Chaves\",'+
		'            \"CEP\": \"06200000\"'+
		'          },'+
		'          \"IE\": 8465465454'+
		'        },'+
		'        \"dest\": {'+
		'          \"xNome\": \"ACME SERVICOS LTDA\",'+
		'          \"CNPJ\": \"4545345345345\",'+
		'          \"enderDest\": {'+
		'            \"xCpl\": \"GALP 1 E 2\",'+
		'            \"fone\": 4534534534,'+
		'            \"UF\": \"SP\",'+
		'            \"xPais\": \"Brasil\",'+
		'            \"cPais\": 1058,'+
		'            \"xLgr\": \"AV Paulista\",'+
		'            \"xMun\": \"Osasco\",'+
		'            \"nro\": 628,'+
		'            \"cMun\": 454545,'+
		'            \"xBairro\": \"Bairro do Chaves\",'+
		'            \"CEP\": \"06200000\"'+
		'          },'+
		'          \"IE\": 8465465454,'+
		'          \"indIEDest\": 9,'+
		'          \"email\": \"acme@acme.com\"'+
		'        },'+
		'        \"transp\": {'+
		'          \"modFrete\": 0,'+
		'          \"vol\": ['+
		'            {'+
		'              \"pesoL\": 0.03,'+
		'              \"qVol\": 1,'+
		'              \"pesoB\": 0.033'+
		'            }'+
		'          ],'+
		'          \"transporta\": {'+
		'            \"xNome\": \"John Doe da Silva\",'+
		'            \"UF\": \"SP\",'+
		'            \"xEnder\": \"Rua 1\",'+
		'            \"xMun\": \"Sao Paulo\",'+
		'            \"CNPJ\": \"4654654654654\",'+
		'            \"IE\": 8789789789'+
		'          }'+
		'        }'+
		'      }'+
		'    },'+
		'    \"versao\": 4'+
		'  }'+
		'}';
		NFeWapper r = NFeWapper.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.IPI objIPI = new NFeWapper.IPI(System.JSON.createParser(json));
		System.assert(objIPI != null);


		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.InfNFe objInfNFe = new NFeWapper.InfNFe(System.JSON.createParser(json));
		System.assert(objInfNFe != null);
		System.assert(objInfNFe.infAdic == null);
		System.assert(objInfNFe.det == null);
		System.assert(objInfNFe.total == null);
		System.assert(objInfNFe.pag == null);
		System.assert(objInfNFe.Id == null);
		System.assert(objInfNFe.ide == null);
		System.assert(objInfNFe.emit == null);
		System.assert(objInfNFe.dest == null);
		System.assert(objInfNFe.transp == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper objNFeWapper = new NFeWapper(System.JSON.createParser(json));
		System.assert(objNFeWapper != null);
		System.assert(objNFeWapper.nfeProc == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.InfAdic objInfAdic = new NFeWapper.InfAdic(System.JSON.createParser(json));
		System.assert(objInfAdic != null);
		System.assert(objInfAdic.infCpl == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.EnderDest objEnderDest = new NFeWapper.EnderDest(System.JSON.createParser(json));
		System.assert(objEnderDest != null);
		System.assert(objEnderDest.xCpl == null);
		System.assert(objEnderDest.fone == null);
		System.assert(objEnderDest.UF == null);
		System.assert(objEnderDest.xPais == null);
		System.assert(objEnderDest.cPais == null);
		System.assert(objEnderDest.xLgr == null);
		System.assert(objEnderDest.xMun == null);
		System.assert(objEnderDest.nro == null);
		System.assert(objEnderDest.cMun == null);
		System.assert(objEnderDest.xBairro == null);
		System.assert(objEnderDest.CEP == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.ProtNFe objProtNFe = new NFeWapper.ProtNFe(System.JSON.createParser(json));
		System.assert(objProtNFe != null);
		System.assert(objProtNFe.infProt == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.Ide objIde = new NFeWapper.Ide(System.JSON.createParser(json));
		System.assert(objIde != null);
		System.assert(objIde.tpNF == null);
		System.assert(objIde.mod == null);
		System.assert(objIde.indPres == null);
		System.assert(objIde.tpImp == null);
		System.assert(objIde.nNF == null);
		System.assert(objIde.cMunFG == null);
		System.assert(objIde.procEmi == null);
		System.assert(objIde.finNFe == null);
		System.assert(objIde.dhEmi == null);
		System.assert(objIde.tpAmb == null);
		System.assert(objIde.indFinal == null);
		System.assert(objIde.dhSaiEnt == null);
		System.assert(objIde.idDest == null);
		System.assert(objIde.tpEmis == null);
		System.assert(objIde.cDV == null);
		System.assert(objIde.cUF == null);
		System.assert(objIde.serie == null);
		System.assert(objIde.natOp == null);
		System.assert(objIde.cNF == null);
		System.assert(objIde.verProc == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.Imposto objImposto = new NFeWapper.Imposto(System.JSON.createParser(json));
		System.assert(objImposto != null);
		System.assert(objImposto.IPI == null);


		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.Prod objProd = new NFeWapper.Prod(System.JSON.createParser(json));
		System.assert(objProd != null);
		System.assert(objProd.cEAN == null);
		System.assert(objProd.cProd == null);
		System.assert(objProd.qCom == null);
		System.assert(objProd.cEANTrib == null);
		System.assert(objProd.vUnTrib == null);
		System.assert(objProd.qTrib == null);
		System.assert(objProd.vProd == null);
		System.assert(objProd.xProd == null);
		System.assert(objProd.vUnCom == null);
		System.assert(objProd.indTot == null);
		System.assert(objProd.uTrib == null);
		System.assert(objProd.NCM == null);
		System.assert(objProd.uCom == null);
		System.assert(objProd.CFOP == null);
		System.assert(objProd.CEST == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.Emit objEmit = new NFeWapper.Emit(System.JSON.createParser(json));
		System.assert(objEmit != null);
		System.assert(objEmit.CNAE == null);
		System.assert(objEmit.xNome == null);
		System.assert(objEmit.IM == null);
		System.assert(objEmit.CRT == null);
		System.assert(objEmit.xFant == null);
		System.assert(objEmit.CNPJ == null);
		System.assert(objEmit.enderEmit == null);
		System.assert(objEmit.IE == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.Transporta objTransporta = new NFeWapper.Transporta(System.JSON.createParser(json));
		System.assert(objTransporta != null);
		System.assert(objTransporta.xNome == null);
		System.assert(objTransporta.UF == null);
		System.assert(objTransporta.xEnder == null);
		System.assert(objTransporta.xMun == null);
		System.assert(objTransporta.CNPJ == null);
		System.assert(objTransporta.IE == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.InfProt objInfProt = new NFeWapper.InfProt(System.JSON.createParser(json));
		System.assert(objInfProt != null);
		System.assert(objInfProt.nProt == null);
		System.assert(objInfProt.digVal == null);
		System.assert(objInfProt.dhRecbto == null);
		System.assert(objInfProt.Id == null);
		System.assert(objInfProt.chNFe == null);
		System.assert(objInfProt.xMotivo == null);
		System.assert(objInfProt.cStat == null);




		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.Dest objDest = new NFeWapper.Dest(System.JSON.createParser(json));
		System.assert(objDest != null);
		System.assert(objDest.xNome == null);
		System.assert(objDest.CNPJ == null);
		System.assert(objDest.enderDest == null);
		System.assert(objDest.IE == null);
		System.assert(objDest.indIEDest == null);
		System.assert(objDest.email == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.Transp objTransp = new NFeWapper.Transp(System.JSON.createParser(json));
		System.assert(objTransp != null);
		System.assert(objTransp.modFrete == null);
		System.assert(objTransp.vol == null);
		System.assert(objTransp.transporta == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.ICMSTot objICMSTot = new NFeWapper.ICMSTot(System.JSON.createParser(json));
		System.assert(objICMSTot != null);
		System.assert(objICMSTot.vCOFINS == null);
		System.assert(objICMSTot.vBCST == null);
		System.assert(objICMSTot.vICMSDeson == null);
		System.assert(objICMSTot.vProd == null);
		System.assert(objICMSTot.vSeg == null);
		System.assert(objICMSTot.vFCP == null);
		System.assert(objICMSTot.vFCPST == null);
		System.assert(objICMSTot.vNF == null);
		System.assert(objICMSTot.vPIS == null);
		System.assert(objICMSTot.vIPIDevol == null);
		System.assert(objICMSTot.vBC == null);
		System.assert(objICMSTot.vST == null);
		System.assert(objICMSTot.vICMS == null);
		System.assert(objICMSTot.vII == null);
		System.assert(objICMSTot.vFCPSTRet == null);
		System.assert(objICMSTot.vDesc == null);
		System.assert(objICMSTot.vOutro == null);
		System.assert(objICMSTot.vIPI == null);
		System.assert(objICMSTot.vFrete == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.NfeProc objNfeProc = new NFeWapper.NfeProc(System.JSON.createParser(json));
		System.assert(objNfeProc != null);
		System.assert(objNfeProc.protNFe == null);
		System.assert(objNfeProc.NFe == null);
		System.assert(objNfeProc.versao == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.NFe objNFe = new NFeWapper.NFe(System.JSON.createParser(json));
		System.assert(objNFe != null);
		System.assert(objNFe.infNFe == null);



		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.DetPag objDetPag = new NFeWapper.DetPag(System.JSON.createParser(json));
		System.assert(objDetPag != null);
		System.assert(objDetPag.vPag == null);
		System.assert(objDetPag.tPag == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.Det objDet = new NFeWapper.Det(System.JSON.createParser(json));
		System.assert(objDet != null);
		System.assert(objDet.nItem == null);
		System.assert(objDet.prod == null);
		System.assert(objDet.imposto == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.Vol objVol = new NFeWapper.Vol(System.JSON.createParser(json));
		System.assert(objVol != null);
		System.assert(objVol.pesoL == null);
		System.assert(objVol.qVol == null);
		System.assert(objVol.pesoB == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.Total objTotal = new NFeWapper.Total(System.JSON.createParser(json));
		System.assert(objTotal != null);
		System.assert(objTotal.ICMSTot == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.Pag objPag = new NFeWapper.Pag(System.JSON.createParser(json));
		System.assert(objPag != null);
		System.assert(objPag.detPag == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		NFeWapper.EnderEmit objEnderEmit = new NFeWapper.EnderEmit(System.JSON.createParser(json));
		System.assert(objEnderEmit != null);
		System.assert(objEnderEmit.fone == null);
		System.assert(objEnderEmit.UF == null);
		System.assert(objEnderEmit.xPais == null);
		System.assert(objEnderEmit.cPais == null);
		System.assert(objEnderEmit.xLgr == null);
		System.assert(objEnderEmit.xMun == null);
		System.assert(objEnderEmit.nro == null);
		System.assert(objEnderEmit.cMun == null);
		System.assert(objEnderEmit.xBairro == null);
		System.assert(objEnderEmit.CEP == null);


	}
    
    
    @isTest
    static void debeCrearOportunidadConElBatch() {
        Document document;
        
        
        document = new Document();
        document.Body = Blob.valueOf('cualquiera\n53131205035672000156550010000004991543410167');
        document.ContentType = 'text/csv';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'Notas4';
        document.FolderId = UserInfo.getUserId();
        insert document;
        
		
		Account emit = Build.anAccount().withName('Emit').withCNPJCPF('99348255000107').build();
		insert emit;
		Account dest = Build.anAccount().withName('Dest').withCNPJCPF('99348255000108').build();
		insert dest;

        string json = '{"nfeProc":{"versao":2,"protNFe":{"infProt":{"xMotivo":null,"nProt":null,"Id":null,"digVal":null,"dhRecbto":null,"cStat":null,"chNFe":"53131205035672000156550010000004991543410167"}},"NFe":{"infNFe":{"transp":{"vol":null,"veicTransp":null,"transporta":{"xNome":null,"xMun":null,"xEnder":",","UF":null,"IE":null,"CNPJ":null},"modFrete":"0"},"total":{"ICMSTot":{"vTotTrib":null,"vST":0,"vSeg":0,"vProd":null,"vPIS":0,"vOutro":0,"vNF":181.74,"vIPIDevol":null,"vIPI":0,"vII":0,"vICMSDeson":0,"vICMS":0,"vFrete":0,"vFCPSTRet":null,"vFCPST":null,"vFCP":null,"vDesc":0,"vCOFINS":0,"vBCST":0,"vBC":0}},"pag":null,"infAdic":{"obsCont":null,"infCpl":"DOCUMENTO EMITIDO POR ME OU EPP OPTANTE PELO SIMPLES NACIONAL"},"ide":{"verProc":"Service_NFe_Util_v2G","tpNF":1,"tpImp":1,"tpEmis":1,"tpAmb":1,"serie":1,"procEmi":0,"nNF":499,"natOp":"PRESTACAO DE SERVICOS SUJEITOS A ISSQN","mod":55,"indPres":null,"indFinal":null,"idDest":null,"finNFe":1,"dhSaiEnt":null,"dhEmi":null,"cUF":53,"cNF":"54341016","cMunFG":5300108,"cDV":6},"Id":"NFe53131205035672000156550010000004991543410167","emit":{"xNome":"EMPRESA DE SEGURANCA FICTICIA E SERVICOS LTDA - EPP","xFant":"EMPRESA FICTICIA","IM":"1234567891234","IE":"0743340400127","enderEmit":{"xPais":"Brasil","xMun":"BRASILIA","xLgr":"BAIRRO FICTICIO DA CIDADE FICTICIA","xBairro":"ASA SUL","UF":"DF","nro":"S/N","fone":6111235678,"cPais":1058,"cMun":5300108,"CEP":"70000000"},"CRT":1,"CNPJ":"99348255000107","CNAE":8020000,"accountId":null},"det":[{"prod":{"xProd":"REF. A PRESTACAO DE SERVICO DE SEGURANCA ELETRONICA.*/* DEZEMBRO/2013*/*MONITORAMENTO COM APOIO DE VEICULO4174*/*CONTRA","xPed":null,"vUnTrib":181.74,"vUnCom":181.74,"vSeg":null,"vProd":181.74,"vOutro":null,"vFrete":null,"vDesc":null,"uTrib":"UN","uCom":"UN","rastro":null,"quantityReal":null,"qTrib":1,"qCom":1,"nItemPed":null,"nFCI":null,"NCM":"00","indTot":0,"indEscala":null,"cProd":"S0000000000","CFOP":5933,"CEST":null,"cEANTrib":"","cEAN":"","cBenef":null},"nItem":1,"imposto":{"vTotTrib":null,"PIS":{"PISNT":null},"IPI":null,"ICMS":null,"COFINS":{"COFINSNT":null}}}],"dest":{"xNome":"CARLOS ALBERTO FICTICIO","indIEDest":null,"IE":"ISENTO","enderDest":{"xPais":"BRASIL","xMun":"BRASILIA","xLgr":"BAIRRO E QUADRA FICTICIA","xCpl":null,"xBairro":"BAIRRO FICTICIO","UF":"DF","nro":"34","fone":61999999911,"cPais":1058,"cMun":5300108,"CEP":"70000000"},"email":"email1teste@dominioqualquer.com.br;email2teste@dominio2qualquer.com","CNPJ":"99348255000108","accountId":null},"cobr":null}}}}';
        Pricebook2 pricebook = new Pricebook2(id=test.getStandardPricebookId(), isActive=true);
        update pricebook;
        
        Product2 product = new Product2(Name='Generico Nota Fiscal');
        insert product;

        
        test.startTest();
        NFeBatch batch = new NFeBatch(document);
        Database.executeBatch(batch);
        test.stopTest();

    }
}
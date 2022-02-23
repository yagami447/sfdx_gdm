/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, wire, track } from 'lwc'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { NavigationMixin } from 'lightning/navigation';

//SOBJECT DATA
import OpportunityLineItem from '@salesforce/schema/OpportunityLineItem'
import Product2 from '@salesforce/schema/Product2'
import { getObjectInfo } from 'lightning/uiObjectInfoApi'

import calltheopp from '@salesforce/apex/AddOpportunityLineItemController.getTheOpportunity'
import callNeeds from '@salesforce/apex/AddOpportunityLineItemController.getNeedBasedOnOpportunity'
import callShoppingCart from '@salesforce/apex/AddOpportunityLineItemController.getShoppingCart'
import callCategorias from '@salesforce/apex/AddOpportunityLineItemController.getOptionCategoria'
import callUnidades from '@salesforce/apex/AddOpportunityLineItemController.getOptionUnidades'
import callStates from '@salesforce/apex/AddOpportunityLineItemController.getStates'
import callUsers from '@salesforce/apex/AddOpportunityLineItemController.getUsers'
import callConfiguration from '@salesforce/apex/AddOpportunityLineItemController.getConfigurationBMX'
import callFields from '@salesforce/apex/AddOpportunityLineItemController.getFields'
import callRemoveFromCart from '@salesforce/apex/AddOpportunityLineItemController.RemoveFromShoppingCart'
import callSaveCart from '@salesforce/apex/AddOpportunityLineItemController.saveShoppingCart'
import callAddCartShopping from '@salesforce/apex/AddOpportunityLineItemController.addToShoppingCart'
import callSaveOpportunity from '@salesforce/apex/AddOpportunityLineItemController.saveOpportunity'
import callUpdateAvailableList from '@salesforce/apex/AddOpportunityLineItemController.updateAvailableList'
import callApprovedList from '@salesforce/apex/AddOpportunityLineItemController.getApprovedItems'
import callRelatedOli from '@salesforce/apex/AddOpportunityLineItemController.getRelatedOli'


export default class AddOpportunityLineItemLWC extends NavigationMixin(LightningElement) {
    @track theOpp = {}
    @track theOppId = null
    @track shoppingcart = []
    @track toDelete = []
    @track availableProducts = []
    @track filteredProducts = []
    @track baseOli = []
    @track filteredBaseOli = []
    @track produtoplaceholder = 'Buscar produtos'
    @track searchstring = ''
    @track needs = []
    @track categorias = []
    @track categoriasSemS2 = []
    @track categoriasSemBasica = []
    @track categoriaMap = {}
    @track unidades = []
    @track states = []
    @track users = []
    @track configurations = []
    @track fields = []
    @track searchstring = ''

    @track renderCategoria = false
    @track renderUnidade = false
    @track renderSemilhaTratada = false
    @track renderRegistroCultivar = false
    @track renderCodigoMaterial = false

    @track renderedCategoriaOli = false
    @track renderedCategoriaOliInput = false
    @track renderedCategoriaOliInputRebSacas = false
    @track renderedCategoriaPlantadaOliInput = false
    @track renderedUnidadeOli = false
    @track renderedGrupoMateriales2 = false
    @track renderedGrupoMateriales2Input = false
    @track renderedSemillaOli = false
    @track renderedSemillaOliInput = false
    @track renderedAreaPlantadaOliInput = false
    @track renderedSementeBrutaOliInput = false
    @track renderedSementeBeneficiadaOliInput = false
    @track renderedSementeAprovadaOliInput = false
    @track renderedSementeProprioOliInput = false
    @track renderedSementeComercializadaOliInput = false
    @track renderedDescarteOliInput = false
    @track renderedCategoriaRebaixarOliInput = false
    @track renderedAreaOliInput = false
    @track renderedSemRebaixadaOliInput = false
    @track renderedqtdsacas40Input = false
    @track renderedloterebajado = false
    @track renderedvolumeoli = false
    @track renderedprodbrutaoli = false
    @track renderedestadocomercializacaooli = false
    @track renderedlocalentregaoli = false
    @track renderedfechanecessidadoli = false
    @track renderedtiponecessidade = false
    @track renderedDataEvento = false
    @track renderedFechaEntrega = false
    @track renderedestadoproducion = false
    @track renderedquantityoli = false
    @track renderedquantidadec = false
    @track renderedmetaoli = false
    @track renderedestimativa = false
    @track renderedquantidadeestimada = false
    @track renderedquantidaderechazada = false
    @track renderedquantidadependente = false
    @track renderedunitpriceoli = false
    @track renderedunitpriceoliinput = false
    @track renderedposicionsaprelacionada = false
    @track renderedprevisaooli = false
    @track isCategoriaLocked = false
    @track showProducts = false
    @track showBaseOli = false
    @track renderunidadeinput = false
    @track isValid = true
    @track itensMap = {}

    @track disablebuttons = false

    @wire(getObjectInfo, { objectApiName: OpportunityLineItem }) detalles = {}
    @wire(getObjectInfo, { objectApiName: Product2 }) products = {}


    mensagemErroInferiorPlantada = 'Categoria tem que ser inferior a plantada.'
    mensagemEmptyFields = 'Campos não podem estar vazios.'

    //bouncers
    bouncerAnexo5 = null
    bouncerAnexo4 = null

    getRelatedOli() {
        callRelatedOli({ recordId: this.theOppId })
            .then(result => {
                this.baseOli = JSON.parse(JSON.stringify(result))
                this.filteredBaseOli = this.baseOli
                this.showBaseOli = true
            })
            .catch(error => {
                this.dispatchErrorMessage(error)
            })
    }

    validateA1() {
        let itsOk = true
        this.shoppingcart.forEach(item => {
            if (!item.Categoria_a_Rebaixar__c ||
                !item.Categoria__c ||
                !item.Area__c ||
                !item.Expec_Prod_Bruta__c ||
                !item.Estado_de_Produccion__c ||
                item.Expec_Prod_Bruta__c === '0') itsOk = false
        })
        return itsOk
    }

    handleChangeSearch(event) {
        this.searchstring = event.target.value
        this.filterProducts()
    }

    handleChangeSearchBaseOli(event) {
        this.searchstring = event.target.value
        this.filterBaseOli()
    }

    handleSave(event) {
        if (!this.isValid) {
            this.dispatchErrorMessage('Por favor revise os valores do Anexo.')
            return
        }
        if (this.theOpp.RecordType.Name === 'Anexo I') {
            if (!this.validateA1()) {
                this.dispatchErrorMessage(this.mensagemEmptyFields)
                return
            }
        }

        let remove = this.toDelete.filter(remo => remo.Id)
        this.disablebuttons = true
        callRemoveFromCart({ recordId: this.theOppId, items: remove })
            .then(resultDelete => {
                window.console.log(resultDelete)
                this.toDelete = []
                this.shoppingcart.forEach(item => {
                    if (!item.Quantity) item.Quantity = 1
                })
                console.log('Shopping cart : ');
                console.log(this.shoppingcart);
                callSaveCart({ recordId: this.theOppId, items: this.shoppingcart })
                    .then(resultSave => {
                        window.console.log(resultSave)
                        callSaveOpportunity({ recordId: this.theOppId })
                            .then(resultOpp => {
                                window.console.log(resultOpp)
                                this.navigateToRecord(event)
                                this.disablebuttons = false
                            })
                            .catch(oppError => {
                                this.dispatchErrorMessage(oppError)
                                this.disablebuttons = false
                            })
                    })
                    .catch(saveError => {
                        this.dispatchErrorMessage(saveError)
                        this.disablebuttons = false
                    })
            })
            .catch(deleteError => {
                this.dispatchErrorMessage(deleteError)
                this.disablebuttons = false
            })
    }

    handleCancel(event) {
        this.navigateToRecord(event)
    }

    handleCategoriaPlantadaOli(event) {
        this.shoppingcart[event.target.dataset.index].Categoria_a_Rebaixar__c = event.target.value
        this.shoppingcart[event.target.dataset.index].Categoria_a_RebaixarLabel = this.categoriaMap[event.target.value]
    }

    handleCategoriaOli(event) {
        this.shoppingcart[event.target.dataset.index].Categoria__c = event.target.value
        this.shoppingcart[event.target.dataset.index].CategoriaLabel = this.categoriaMap[event.target.value]
        if (this.theOpp.RecordType.Name === 'Anexo I') {
            if (this.shoppingcart[event.target.dataset.index].Categoria_a_RebaixarLabel === 'C1' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'C2' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'S1' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'S2') {
                this.dispatchErrorMessage(this.mensagemErroInferiorPlantada)
                this.errorAnexo1Categoria(event.target.dataset.index)
            } else if (this.shoppingcart[event.target.dataset.index].Categoria_a_RebaixarLabel === 'C2' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'S1' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'S2') {
                this.errorAnexo1Categoria(event.target.dataset.index)
            } else if (this.shoppingcart[event.target.dataset.index].Categoria_a_RebaixarLabel === 'S1' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'S2') {
                this.errorAnexo1Categoria(event.target.dataset.index)
            }
        }
    }

    handleCategoriaReb(event) {
        this.shoppingcart[event.target.dataset.index].Categoria_a_Rebaixar__c = event.target.value
        this.shoppingcart[event.target.dataset.index].CategoriaLabel = this.categoriaMap[event.target.value]
        if (this.theOpp.RecordType.Name === 'Anexo II Rebaixamento Sacas') {
            if (this.shoppingcart[event.target.dataset.index].Categoria_a_RebaixarLabel === 'C1' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'C2' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'S1' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'S2') {
                this.dispatchErrorMessage(this.mensagemErroInferiorPlantada)
                this.errorRebCategoria(event.target.dataset.index)
            } else if (this.shoppingcart[event.target.dataset.index].Categoria_a_RebaixarLabel === 'C2' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'S1' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'S2') {
                this.errorRebCategoria(event.target.dataset.index)
            } else if (this.shoppingcart[event.target.dataset.index].Categoria_a_RebaixarLabel === 'S1' &&
                this.shoppingcart[event.target.dataset.index].CategoriaLabel !== 'S2') {
                this.errorRebCategoria(event.target.dataset.index)
            }
        }
    }


    errorAnexo1Categoria(index) {
        window.setTimeout(() => {
            this.dispatchErrorMessage(this.mensagemErroInferiorPlantada)
            this.shoppingcart[index].Categoria__c = null
            this.shoppingcart[index].CategoriaLabel = null
        }, 100)
    }
    errorRebCategoria(index) {
        window.setTimeout(() => {
            this.dispatchErrorMessage(this.mensagemErroInferiorPlantada)
            this.shoppingcart[index].Categoria_a_Rebaixar__c = null
            this.shoppingcart[index].CategoriaLabel = null
        }, 100)
    }
    duplicateShoppingCart(event) {
        let oli = JSON.parse(JSON.stringify(this.baseOli[event.target.dataset.index]))
        oli.OpportunityId = this.theOppId.Id
        oli.Sem_Rebajada__c = 0
        oli.Categoria_a_RebaixarLabel = this.categoriaMap[oli.Categoria__c]
        oli.Id = null
        oli.Opportunity = null
        oli.Area_Plantada__c = null
        oli.Semente_bruta__c = null
        oli.Categoria_a_Rebaixar__c = null
        oli.OpportunityId = this.theOpp.Id
        oli.Seq = (this.shoppingcart.length || 0) + 1
        if (this.theOpp.RecordType.Name == 'Anexo V') {
            oli.Semente_comercializada__c = 0;
        }
        this.shoppingcart.push(oli)

    }

    addToShoppingCart(event) {
        callAddCartShopping({
            recordId: this.theOppId,
            d: this.filteredProducts[event.target.dataset.index],
            sumaTasas: this.configurations.sum ? this.configurations.sum : 0
        }).then(result => {
            let prep = JSON.parse(JSON.stringify(result))
            if (this.theOpp.RecordType.DeveloperName === 'AnexoII') {
                if (this.itensMap.AnexoI && this.itensMap.AnexoI[prep.PricebookEntryId]) {
                    prep.Categoria__c = this.itensMap.AnexoI[prep.PricebookEntryId].Categoria__c
                    prep.Area_Plantada__c = this.itensMap.AnexoI[prep.PricebookEntryId].Area__c
                }
            }
            if (this.theOpp.RecordType.DeveloperName === 'Anexo_III' || this.theOpp.RecordType.DeveloperName === 'AnexoIII') {
                if (this.itensMap.AnexoII && this.itensMap.AnexoII[prep.PricebookEntryId]) {
                    prep.Categoria__c = this.itensMap.AnexoII[prep.PricebookEntryId].Categoria__c
                    prep.Semente_bruta__c = this.itensMap.AnexoII[prep.PricebookEntryId].Semente_bruta__c
                }
            }
            if (this.theOpp.RecordType.DeveloperName === 'Anexo_IV' || this.theOpp.RecordType.DeveloperName === 'AnexoIV') {
                if (this.itensMap.AnexoIII && this.itensMap.AnexoIII[prep.PricebookEntryId]) {
                    prep.Categoria__c = this.itensMap.AnexoIII[prep.PricebookEntryId].Categoria__c
                    prep.Semente_uso_propio__c = 0
                    prep.Semente_comercializada__c = 0
                    prep.Descarte__c = 0
                } else if (this.itensMap.Anexo_III && this.itensMap.Anexo_III[prep.PricebookEntryId]) {
                    prep.Categoria__c = this.itensMap.Anexo_III[prep.PricebookEntryId].Categoria__c
                    prep.Semente_uso_propio__c = 0
                    prep.Semente_comercializada__c = 0
                    prep.Descarte__c = 0
                }
            }
            if (this.theOpp.RecordType.DeveloperName === 'Anexo_V' || this.theOpp.RecordType.DeveloperName === 'AnexoV') {
                if (this.itensMap.AnexoI && this.itensMap.AnexoI[prep.PricebookEntryId]) {
                    prep.Categoria__c = this.itensMap.AnexoI[prep.PricebookEntryId].Categoria__c
                }
            }

            prep.Seq = (this.shoppingcart.length || 0) + 1
            this.shoppingcart.push(prep)
        }).catch(shoppingerror => {
            this.dispatchErrorMessage(shoppingerror)
        })
    }
    handleValidacaoAreaAnexoIIvsAnexoI(event) {
        let prep = this.shoppingcart[event.target.dataset.index]
        window.setTimeout(() => {
            if (this.theOpp.RecordType.DeveloperName === 'AnexoII') {
                if (this.itensMap.AnexoI && this.itensMap.AnexoI[prep.PricebookEntryId]) {
                    if (prep.Area_Plantada__c > this.itensMap.AnexoI[prep.PricebookEntryId].Area__c) {
                        this.dispatchErrorMessage('Área não pode ser maior que a aprovada no Anexo I')
                        prep.Area_Plantada__c = null
                        this.isValid = false
                        return
                    }
                }
                this.isValid = true
            }
        }, 100)
    }

    //This method is to avoid NaN apears in input placeholder when delete input value



    handleExcluirItem(event) {
        this.toDelete.push(this.shoppingcart[event.target.dataset.index])
        this.shoppingcart.splice(event.target.dataset.index, 1)
    }

    handlechangegurpomateriales2(event) {
        this.shoppingcart[event.target.dataset.index].Grupo_de_materiales_2__c = event.target.value
    }
    handlechangesemilla(event) {
        this.shoppingcart[event.target.dataset.index].Tratamiento_de_Semilla__c = event.target.value
    }
    handlechangeareaplantada(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Area_Plantada__c = formatedValue;
        //this.handleValidacaoAreaAnexoIIvsAnexoI(event)
    }
    handlechangebruta(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Semente_bruta__c = formatedValue;
    }
    handlechangebeneficiada(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Semente_beneficiada__c = formatedValue;
    }
    handlechangeaprovada(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Semente_aprovada__c = formatedValue;
    }
    handlechangepropria(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Semente_uso_propio__c = formatedValue;
    }
    handlechangecomercializada(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed comercializada! : ' + formatedValue);
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Semente_comercializada__c = formatedValue;
        console.log('Asigned comercializada! : ' + this.shoppingcart[event.target.dataset.index].Semente_comercializada__c);
    }

    handlechangedescarte(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Descarte__c = formatedValue;
    }
    handlechangecatrebaixar(event) {
        this.shoppingcart[event.target.dataset.index].Categoria_a_Rebaixar__c = event.target.value
    }
    handlechangearea(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Area__c = formatedValue;
    }
    handlechangesemrebaijada(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Sem_Rebajada__c = formatedValue;
    }
    handlechangeqtdscs40(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Qtde_Scs_40kg__c = formatedValue;
    }
    handlechangeloterebaixado(event) {
        this.shoppingcart[event.target.dataset.index].Lote_Rebajado__c = event.target.value
    }
    hadnlechangevolume(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Volume__c = formatedValue;
    }
    hadnlechangeexpecprodbruta(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Expec_Prod_Bruta__c = formatedValue;
    }
    handlechangeestadocomercia(event) {
        this.shoppingcart[event.target.dataset.index].Estado_de_Comercializacion__c = event.target.value
    }
    hadnlechangeendereco(event) {
        this.shoppingcart[event.target.dataset.index].Local_de_Entrega__c = event.target.value
    }
    handlechangedatanecessidad(event) {
        this.shoppingcart[event.target.dataset.index].Data__c = event.target.value
    }
    hadnleChangeneedOli(event) {
        this.shoppingcart[event.target.dataset.index].Tipo_de_Necesidad__c = event.target.value
    }
    handlechangefechaentrega(event) {
        this.shoppingcart[event.target.dataset.index].Fecha_de_entrega__c = event.target.value
    }
    handlechangeestadoprod(event) {
        this.shoppingcart[event.target.dataset.index].Estado_de_Produccion__c = event.target.value
    }
    hadnlechangequantity(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Quantity = formatedValue;
    }
    hadnlechangequantidadec(event) {
        this.shoppingcart[event.target.dataset.index].Quantidade__c = event.target.value
    }
    handlechangemeta(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Meta__c = formatedValue;
    }
    handlechangeestimativa(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Estimativa__c = formatedValue;
    }
    handlechangequantconfirmada(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Quant_Confirmada__c = formatedValue;
    }
    handlechangeqtdrechazada(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Quant_Rechazada__c = formatedValue;
    }
    hadnlechangeunidadedescarte(event) {
        this.shoppingcart[event.target.dataset.index].Unidade_descarte__c = event.target.value
    }
    handlechangeqtdpendente(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].Quant_Pendiente__c = formatedValue;
    }
    handlechangeunitprice(event) {
        var formatedValue = parseFloat(event.target.value.replace(',', '.'));
        console.log('Parsed');
        if (isNaN(formatedValue) == true || formatedValue == '' || formatedValue == null) {
            formatedValue = 0;
        }
        this.shoppingcart[event.target.dataset.index].UnitPrice = formatedValue;
    }
    handlechangepossaprec(event) {
        this.shoppingcart[event.target.dataset.index].Posicion_SAP_Relacionada__c = event.target.value
    }
    handlechangeprevisao(event) {
        this.shoppingcart[event.target.dataset.index].Previsao__c = event.target.value
    }
    handlechangemotivorechazo(event) {
        this.shoppingcart[event.target.dataset.index].Motivo_de_Rechazo__c = event.target.value
    }



    filterProducts() {
        if (!this.searchstring) this.filteredProducts = this.availableProducts
        else {
            this.filteredProducts = this.availableProducts.filter(product => product.Name.toLowerCase().indexOf(this.searchstring.toLowerCase()) !== -1)
        }
    }


    filterBaseOli() {
        if (!this.searchstring) this.filteredBaseOli = this.baseOli
        else {
            this.filteredBaseOli = this.baseOli.filter(product => product.PricebookEntry.Product2.Variedade__r.Name.toLowerCase().indexOf(this.searchstring.toLowerCase()) !== -1)
        }
    }

    navigateToRecord(event) {
        window.console.log(event)
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.theOppId,
                objectApiName: 'Opportunity',
                actionName: 'view'
            }
        });
    }

    getUrlParamValue(key) {
        return new URL(window.location.href).searchParams.get(key);
    }

    dispatchErrorMessage(error) {
        this.error = error
        window.console.log(error);
        let message = ''
        if (error.body) {
            if (error.body.message) {
                message += error.body.message
            } else if (error.body.pageErrors) {
                error.body.pageErrors.forEach(pe => {
                    message += ' - ' + pe.message
                })
            } else if (error.body.fieldErrors) {
                error.body.fieldErrors.forEach(pe => {
                    message += ' - ' + pe.message
                })
            }
        } else {
            message = JSON.stringify(error, null, 0)
        }
        const evt = new ShowToastEvent({
            title: 'Error',
            message: message,
            variant: 'error',
            mode: 'dismissable'
        })
        this.dispatchEvent(evt)
    }

    connectedCallback() {
        this.theOppId = this.getUrlParamValue('c__Id')
        calltheopp({ recordId: this.theOppId })
            .then(result => {
                this.theOpp = JSON.parse(JSON.stringify(result))
                    //this.showProducts = true //USE ONLY FOR TEST.
                if (this.theOpp.RecordType.Name !== 'Anexo I') {
                    this.isCategoriaLocked = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo I') {
                    this.showProducts = true

                } else {
                    this.showProducts = false
                }
                if (this.theOpp.RecordType.Name === 'Anexo V' || this.theOpp.RecordType.Name === 'Anexo II Rebaixamento Sacas') {
                    this.isCategoriaLocked = this.theOpp.RecordType.Name === 'Anexo II Rebaixamento Sacas' ? false : true ;// Agregado el 15/09/21
                    this.showProducts = false
                    this.getRelatedOli()
                }
                if (this.theOpp.RecordType.Name === 'Reembalaje') {
                    this.showProducts = true
                    this.isCategoriaLocked = false
                }
                if (this.theOpp.RecordType.Name === 'Descarte') {
                    this.renderedquantityoli = true
                    this.renderunidadeinput = true
                    this.showProducts = true
                    this.isCategoriaLocked = false
                    this.renderedloterebajado = true
                }
                if (this.theOpp.RecordType.Name !== 'Previsao' && this.theOpp.RecordType.Name !== 'VB - Pendiente' && this.theOpp.RecordType.Name !== 'VB - Rechazada' && this.theOpp.RecordType.Name !== 'Stock Multiplicadores') {
                    this.renderCategoria = true
                }
                if (this.theOpp.RecordType.Name === 'Previsao' || this.theOpp.RecordType.Name === 'VB - Pendiente' || this.theOpp.RecordType.Name === 'VB - Rechazada' || this.theOpp.RecordType.Name === 'VB - Autorizada' || this.theOpp.RecordType.Name === 'VB - Pasada SAP' || this.theOpp.RecordType.Name === 'CVB Autorizada' || this.theOpp.RecordType.Name === 'CVB Pendiente' || this.theOpp.RecordType.Name === 'CVB Rechazada') {
                    this.renderUnidade = true
                }
                if (this.theOpp.RecordType.Name === 'Previsao' || this.theOpp.RecordType.Name === 'VB - Pendiente' || this.theOpp.RecordType.Name === 'VB - Rechazada' || this.theOpp.RecordType.Name === 'VB - Autorizada' || this.theOpp.RecordType.Name === 'Disponibilidade da Basica') {
                    this.renderSemilhaTratada = true
                }
                this.renderRegistroCultivar = false
                if (this.theOpp.RecordType.Name !== 'PB-Produccion' && this.theOpp.RecordType.Name !== 'PB-Comercial') {
                    this.renderCodigoMaterial = true
                }
                if (this.theOpp.RecordType.Name === 'Disponibilidade da Basica' || this.theOpp.RecordType.Name === 'PB-Produccion' || this.theOpp.RecordType.Name === 'PB-Comercial' || this.theOpp.RecordType.Name === 'CVB Pendiente' || this.theOpp.RecordType.Name === 'CVB Rechazada' || this.theOpp.RecordType.Name === 'PB-Desarrollo') {
                    this.renderedCategoriaOli = true
                }
                /*
                if (this.theOpp.RecordType.Name === 'Anexo II Rebaixamento Sacas') {
                    this.renderedCategoriaOliInputRebSacas = true
                }*/
                if (this.theOpp.RecordType.Name === 'Anexo I' || this.theOpp.RecordType.Name === 'Anexo II' || this.theOpp.RecordType.Name === 'Anexo III' || this.theOpp.RecordType.Name === 'Anexo IV' || this.theOpp.RecordType.Name === 'Anexo V' || this.theOpp.RecordType.Name === 'Anexo I Rebaixamento Ha' || (this.theOpp.RecordType.Name === 'Anexo II Rebaixamento Sacas' && this.renderedCategoriaOliInputRebSacas == false) || this.theOpp.RecordType.Name === 'Exportacion' || this.theOpp.RecordType.Name === 'Reembalaje' || this.theOpp.RecordType.Name === 'Aquisição Sementes Terceiros' || this.theOpp.RecordType.Name === 'Descarte') {
                    this.renderedCategoriaOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo I') {
                    this.renderedCategoriaPlantadaOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Previsao' || this.theOpp.RecordType.Name === 'VB - Pendiente' || this.theOpp.RecordType.Name === 'VB - Rechazada' || this.theOpp.RecordType.Name === 'VB - Autorizada' || this.theOpp.RecordType.Name === 'VB - Pasada SAP' || this.theOpp.RecordType.Name === 'CVB Autorizada' || this.theOpp.RecordType.Name === 'CVB Pendiente' || this.theOpp.RecordType.Name === 'CVB Rechazada') {
                    this.renderedUnidadeOli = true
                }
                if (this.theOpp.RecordType.Name === 'VB - Pasada SAP') {
                    this.renderedGrupoMateriales2 = true
                }
                if (this.theOpp.RecordType.Name === 'VB - Pendiente' || this.theOpp.RecordType.Name === 'VB - Rechazada' || this.theOpp.RecordType.Name === 'CVB Pendiente' || this.theOpp.RecordType.Name === 'CVB Rechazada') {
                    this.renderedGrupoMateriales2Input = true
                }
                if (this.theOpp.RecordType.Name === 'VB - Pasada SAP') {
                    this.renderedSemillaOli = true
                }
                if (this.theOpp.RecordType.Name === 'VB - Pendiente' || this.theOpp.RecordType.Name === 'VB - Rechazada' || this.theOpp.RecordType.Name === 'VB - Autorizada') {
                    this.renderedSemillaOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo II') {
                    this.renderedAreaPlantadaOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo II' || this.theOpp.RecordType.Name === 'Anexo III') {
                    this.renderedSementeBrutaOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo III') {
                    this.renderedSementeBeneficiadaOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo III' || this.theOpp.RecordType.Name === 'Stock Multiplicadores') {
                    this.renderedSementeAprovadaOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo III' || this.theOpp.RecordType.Name === 'Anexo IV') {
                    this.renderedSementeProprioOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo III' || this.theOpp.RecordType.Name === 'Anexo IV' || this.theOpp.RecordType.Name === 'Anexo V' || this.theOpp.RecordType.Name === 'Stock Multiplicadores') {
                    this.renderedSementeComercializadaOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo II' || this.theOpp.RecordType.Name === 'Anexo IV') {
                    this.renderedDescarteOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo I Rebaixamento Ha' || this.theOpp.RecordType.Name === 'Anexo II Rebaixamento Sacas') {
                    console.log('Anexo II Rebaixamento Sacas');
                    this.renderedCategoriaRebaixarOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo I' || this.theOpp.RecordType.Name === 'Anexo I Rebaixamento Ha') {
                    this.renderedAreaOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo II Rebaixamento Sacas') {
                    this.renderedSemRebaixadaOliInput = true
                }
                if (this.theOpp.RecordType.Name === 'Reembalaje') {
                    this.renderedqtdsacas40Input = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo I Rebaixamento Ha' || this.theOpp.RecordType.Name === 'Reembalaje' || this.theOpp.RecordType.Name === 'Anexo II Rebaixamento Sacas') {
                    this.renderedloterebajado = true
                }
                if (this.theOpp.RecordType.Name === 'Exportacion') {
                    this.renderedvolumeoli = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo I') {
                    this.renderedprodbrutaoli = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo V') {
                    this.renderedestadocomercializacaooli = true
                }
                if (this.theOpp.RecordType.Name === 'PB-Comercial' || this.theOpp.RecordType.Name === 'PB-Produccion' || this.theOpp.RecordType.Name === 'PB-Desarrollo') {
                    this.renderedlocalentregaoli = true
                }
                if (this.theOpp.RecordType.Name === 'PB-Desarrollo' || this.theOpp.RecordType.Name === 'PB-Comercial') {
                    this.renderedfechanecessidadoli = true
                }
                if (this.theOpp.Setor__c === 'Desarrollo' || this.theOpp.Setor__c === 'Comercial' || this.theOpp.RecordType.Name === 'VB - Pendiente' || this.theOpp.RecordType.Name === 'VB - Rechazada' || this.theOpp.RecordType.Name === 'VB - Autorizada' || this.theOpp.RecordType.Name === 'Objetivo Ventas Semilla') {
                    this.renderedtiponecessidade = true
                }
                if (this.theOpp.RecordType.Name === 'PB-Produccion') {
                    this.renderedDataEvento = true
                    this.renderedFechaEntrega = true
                }
                if (this.theOpp.RecordType.Name === 'Anexo I') {
                    this.renderedestadoproducion = true
                }
                if (this.theOpp.RecordType.Name === 'Pendiente' || this.theOpp.RecordType.Name === 'NC - Pendiente' || this.theOpp.RecordType.Name === 'VB - Pendiente' || this.theOpp.RecordType.Name === 'VB - Rechazada' || this.theOpp.RecordType.Name === 'Disponibilidade da Basica' || this.theOpp.RecordType.Name === 'CVB Pendiente' || this.theOpp.RecordType.Name === 'CVB Rechazada') {
                    this.renderedquantityoli = true
                }
                if (this.theOpp.RecordType.Name === 'PB-Produccion' || this.theOpp.RecordType.Name === 'PB-Comercial' || this.theOpp.RecordType.Name === 'PB-Desarrollo' || this.theOpp.RecordType.Name === 'Objetivo Ventas Semilla' || this.theOpp.RecordType.Name === 'Aquisição Sementes Terceiros') {
                    this.renderedquantidadec = true
                }
                if (this.theOpp.RecordType.Name === 'Objetivo Ventas Royalties' || this.theOpp.RecordType.Name === 'Objetivo Contrato Royalties') {
                    this.renderedmetaoli = true
                }
                if (this.theOpp.RecordType.Name === 'Estimativa de venda') {
                    this.renderedestimativa = true
                }
                if (this.theOpp.RecordType.Name === 'VB - Pasada SAP') {
                    this.renderedquantidadeestimada = true
                    this.renderedquantidaderechazada = true
                    this.renderedquantidadependente = true
                }
                if (this.theOpp.RecordType.Name === 'NC - Pendiente') {
                    this.renderedunitpriceoli = true
                }
                if (this.theOpp.RecordType.Name === 'VB - Pendiente' || this.theOpp.RecordType.Name === 'VB - Rechazada' || this.theOpp.RecordType.Name === 'Pendiente') {
                    this.renderedunitpriceoliinput = true
                }
                if (this.theOpp.RecordType.Name === 'NC - Pendiente') {
                    this.renderedposicionsaprelacionada = true
                }
                if (this.theOpp.RecordType.Name === 'Previsao') {
                    this.renderedprevisaooli = true
                }
                if (this.theOpp.RecordType.Name === 'VB - Pasada SAP') {
                    this.renderedMotivoDeRechazo = true
                }
                callApprovedList({ oppId: this.theOpp.Id })
                    .then(mapOliResults => {
                        this.itensMap = JSON.parse(JSON.stringify(mapOliResults))
                    })
                    .catch(needError => {
                        this.dispatchErrorMessage(needError)
                    })
                callNeeds({ recordId: this.theOppId })
                    .then(needresult => {
                        this.needs = JSON.parse(JSON.stringify(needresult))
                    })
                    .catch(needError => {
                        this.dispatchErrorMessage(needError)
                    })
                callShoppingCart({ recordId: this.theOppId })
                    .then(shoppincartresult => {
                        this.shoppingcart = JSON.parse(JSON.stringify(shoppincartresult))
                        this.shoppingcart.forEach((item, index) => {
                            item.Seq = index
                        })
                    })
                    .catch(shoppingerror => {
                        this.dispatchErrorMessage(shoppingerror)
                    })
                callCategorias()
                    .then(categoriaResult => {
                        let prep = JSON.parse(JSON.stringify(categoriaResult))
                        let fin = []
                        let semS2 = []
                        let semBasica = []
                        prep.forEach(item => {
                            if (item.label !== 'PREBA' &&
                                item.label !== 'FUNDADORA') {
                                fin.push(item)
                                if (item.label !== 'S2') {
                                    semS2.push(item)
                                }
                                if (item.label !== 'BASICA') {
                                    semBasica.push(item)
                                }
                            }
                            this.categoriaMap[item.value] = item.label
                        })
                        this.categorias = fin
                        this.categoriasSemS2 = semS2
                        this.categoriasSemBasica = semBasica

                    })
                    .catch(categoriasError => {
                        this.dispatchErrorMessage(categoriasError)
                    })
                callUnidades()
                    .then(result => {
                        this.unidades = JSON.parse(JSON.stringify(result))
                    })
                    .catch(categoriasError => {
                        this.dispatchErrorMessage(categoriasError)
                    })
                callStates()
                    .then(resultState => {
                        let prep = JSON.parse(JSON.stringify(resultState))
                        this.states = prep
                    })
                    .catch(stateError => {
                        this.dispatchErrorMessage(stateError)
                    })
                callUsers()
                    .then(userResult => {
                        this.users = JSON.parse(JSON.stringify(userResult))
                    })
                    .catch(userError => {
                        this.dispatchErrorMessage(userError)
                    })
                callConfiguration({ recordId: this.theOppId })
                    .then(configResult => {
                        this.configurations = JSON.parse(JSON.stringify(configResult))
                    })
                    .catch(configError => {
                        this.dispatchErrorMessage(configError)
                    })
                callFields({ recordId: this.theOppId })
                    .then(fieldsResult => {
                        this.fields = JSON.parse(JSON.stringify(fieldsResult))
                    })
                    .catch(configError => {
                        this.dispatchErrorMessage(configError)
                    })
                this.refreshAvailable()

            }).catch(error => {
                this.dispatchErrorMessage(error)
            })
    }

    refreshAvailable() {
        callUpdateAvailableList({ recordId: this.theOppId, searchString: '%' })
            .then(availableResult => {
                this.availableProducts = JSON.parse(JSON.stringify(availableResult))
                this.filterProducts()
            })
            .catch(configError => {
                this.dispatchErrorMessage(configError)
            })
    }

}
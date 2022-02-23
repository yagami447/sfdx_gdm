import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { createRecord, updateRecord, deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

// sObject
import CRM_DETALLE_EVENTO from '@salesforce/schema/CRM_Detalle_Calendario_de_eventos__c';
import CULTURA_ANTECESSORA from '@salesforce/schema/CRM_Detalle_Calendario_de_eventos__c.Cultura_antecessora__c';

// Controller
import callGetCart from '@salesforce/apex/AddCRMEventItemsController.getShoppingCart';

export default class CrudEventItems extends NavigationMixin(LightningElement) {

    @api recordId;
    @api eventType;

    @track data;
    @track columns;
    @track errors;
 
    options; // PICKLIST CULTURA ANTECESSORA

    @wire(getObjectInfo, { objectApiName: CRM_DETALLE_EVENTO }) objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: CULTURA_ANTECESSORA })
    picklistValues({ data, error }) {
        if (data) {
            this.options = data.values;
            this.dispatchEvent(new CustomEvent('selectColumns', {}));
        } else if (error) {
            const event = new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            });

            this.dispatchEvent(event);
        }
    }

    parseData(data) {
        return data.map((row, index) => {
            return {
                ...row,
                Indice__c: index,
                cultivarObtentor: row.Cultivar__r.Obtentor__c,
                cultivarName: row.Cultivar__r.Name,
            }
        });
    }

    connectedCallback() {
        this.addEventListener('selectColumns', () => {
            const { fields } = this.objectInfo.data;

            const button = {
                type: 'button',
                typeAttributes: {
                    label: 'Excluir',
                    name: 'Excluir',
                    title: 'Excluir',
                    value: 'excluir',
                    variant: 'base'
                },
                hideDefaultActions: true
            };

            if (this.eventType.palestra) {
                this.columns = [
                    button,
                    { label: fields.Obtentor__c.label, fieldName: 'cultivarObtentor', type: 'text', sortable: false, hideDefaultActions: true },
                ];
            } else if (this.eventType.diaDeCampo) {
                this.columns = [
                    button,
                    { label: fields.Obtentor__c.label, fieldName: 'cultivarObtentor', type: 'text', sortable: false, hideDefaultActions: true },
                    { label: fields.Cultivar__c.label, fieldName: 'cultivarName', type: 'text', sortable: false, hideDefaultActions: true },
                ];
            } else if (this.eventType.ladoALado) {
                this.columns = [
                    button,
                    {
                        label: fields.Produto_Principal__c.label,
                        fieldName: 'Produto_Principal__c',
                        type: 'boolean',
                        cellAttributes: {
                            alignment: 'center'
                        },
                        editable: true,
                        hideDefaultActions: true,
                    },
                    { label: fields.Obtentor__c.label, fieldName: 'cultivarObtentor', type: 'text', hideDefaultActions: true },
                    { label: fields.Cultivar__c.label, fieldName: 'cultivarName', type: 'text', hideDefaultActions: true },
                    {
                        label: fields.Populacao_de_plantas__c.label,
                        fieldName: 'Populacao_de_plantas__c',
                        type: 'number',
                        cellAttributes: {
                            alignment: 'left'
                        },
                        editable: true,
                        hideDefaultActions: true,
                    },
                    {
                        label: fields.Espacamento__c.label,
                        fieldName: 'Espacamento__c',
                        type: 'number',
                        cellAttributes: {
                            alignment: 'left'
                        },
                        editable: true,
                        hideDefaultActions: true,
                    },
                    {
                        label: fields.Area_plantada__c.label,
                        fieldName: 'Area_plantada__c',
                        type: 'number',
                        cellAttributes: {
                            alignment: 'left'
                        },
                        editable: true,
                        hideDefaultActions: true,
                    },
                    {
                        label: fields.Area_Colhida__c.label,
                        fieldName: 'Area_Colhida__c',
                        type: 'number',
                        cellAttributes: {
                            alignment: 'left'
                        },
                        editable: true,
                        hideDefaultActions: true,
                    },
                    {
                        label: fields.Produtividade__c.label,
                        fieldName: 'Produtividade__c',
                        type: 'number',
                        cellAttributes: {
                            alignment: 'left'
                        },
                        editable: true,
                        hideDefaultActions: true,
                        initialWidth: 150,
                    },
                    {
                        label: fields.Data_de_plantio__c.label,
                        fieldName: 'Data_de_plantio__c',
                        type: 'date',
                        cellAttributes: {},
                        editable: true,
                        hideDefaultActions: true,
                    },
                    {
                        label: fields.Data_de_colheita__c.label,
                        fieldName: 'Data_de_colheita__c',
                        type: 'date',
                        cellAttributes: {},
                        editable: true,
                        hideDefaultActions: true,
                    },
                    {
                        label: fields.Volume_Doado__c.label,
                        fieldName: 'Volume_Doado__c',
                        type: 'number',
                        cellAttributes: {
                            alignment: 'left'
                        },
                        editable: true,
                        hideDefaultActions: true,
                        initialWidth: 150,
                    },
                    {
                        label: fields.Cultura_antecessora__c.label,
                        fieldName: 'Cultura_antecessora__c',
                        type: 'picklist',
                        cellAttributes: {},
                        typeAttributes: {
                            placeholder: '',
                            options: this.options,
                            value: { fieldName: 'Cultura_antecessora__c' },
                            context: { fieldName: 'Id' }
                        },
                        editable: true,
                        hideDefaultActions: true,
                        initialWidth: 210,
                    },
                ];
            } else if (this.eventType.emplacamento) {
                this.columns = [
                    button,
                    { label: fields.Obtentor__c.label, fieldName: 'cultivarObtentor', type: 'text', hideDefaultActions: true },
                    { label: fields.Cultivar__c.label, fieldName: 'cultivarName', type: 'text', hideDefaultActions: true },
                    {
                        label: fields.Area_plantada__c.label,
                        fieldName: 'Area_plantada__c',
                        type: 'number',
                        cellAttributes: {
                            alignment: 'left'
                        },
                        editable: true,
                        hideDefaultActions: true,
                    },
                    {
                        label: fields.Produtividade__c.label,
                        fieldName: 'Produtividade__c',
                        type: 'number',
                        cellAttributes: {
                            alignment: 'left'
                        },
                        editable: true,
                        hideDefaultActions: true,
                    },
                    {
                        label: fields.Volume_Doado__c.label,
                        fieldName: 'Volume_Doado__c',
                        type: 'number',
                        cellAttributes: {
                            alignment: 'left'
                        },
                        editable: true,
                        hideDefaultActions: true,
                    },
                ];
            }
        });

        callGetCart({ recordId: this.recordId })
        .then(data => {
            this.data = this.parseData(data);
        })
        .catch(error => {
            const event = new ShowToastEvent({
                title: 'Error',
                message: error,
                variant: 'error'
            });

            this.dispatchEvent(event);
        });
    }

    @api
    addProduct(event) {
        const { product } = event.detail;

        createRecord({
            apiName: CRM_DETALLE_EVENTO.objectApiName,
            fields: {
                CRM_Calendario_de_eventos__c: this.recordId,
                Cultivar__c: product.Id,
            }
        })
        .then(result => {
            this.data = this.parseData([...this.data, {
                Id: result.id,
                CRM_Calendario_de_eventos__c: this.recordId,
                Cultivar__r: product,
                Cultivar__c: product.Id,
            }]);

            this.dispatchEvent(new ShowToastEvent({
                message: `Produto ${product.Name} adicionado`,
                variant: 'success'
            }));
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: error.statusText,
                message: error.body.message,
                variant: 'error'
            }));
        });
    }

    @api
    saveItems() {
        const { draftValues } = this.template.querySelector(this.eventType.ladoALado ? 'c-custom-data-table' : 'lightning-datatable');

        if (this.eventType.ladoALado) {
            const dataToSave = this.data.map(element => {
                const cells = draftValues.find(el => el.Id === element.Id);

                if (cells) {
                    for (let field in cells) {
                        element[field] = cells[field];
                    }

                    return {
                        Id: element.Id,
                        Produto_Principal__c: element.Produto_Principal__c,
                        Populacao_de_plantas__c: element.Populacao_de_plantas__c,
                        Espacamento__c: element.Espacamento__c,
                        Area_plantada__c: element.Area_plantada__c,
                        Area_Colhida__c: element.Area_Colhida__c,
                        Produtividade__c: element.Produtividade__c,
                        Data_de_plantio__c: element.Data_de_plantio__c,
                        Data_de_colheita__c: element.Data_de_colheita__c,
                        Volume_Doado__c: element.Volume_Doado__c,
                        Cultura_antecessora__c: element.Cultura_antecessora__c,
                    };
                } else {
                    return {
                        Id: element.Id,
                        Produto_Principal__c: element.Produto_Principal__c,
                    };
                }
            });

            if (dataToSave && this.validLadoXLado(dataToSave)) {
                this.callSaveItems(dataToSave);
            }
        } else if (this.eventType.emplacamento) {
            const dataToSave = this.data.map(element => {
                const cells = draftValues.find(el => el.Id === element.Id);

                if (cells) {
                    for (let field in cells) {
                        element[field] = cells[field];
                    }

                    return {
                        Id: element.Id,
                        Area_plantada__c: element.Area_plantada__c,
                        Produtividade__c: element.Produtividade__c,
                        Volume_Doado__c: element.Volume_Doado__c,
                    };
                } else {
                    return { Id: element.Id };
                }
            });

            if (dataToSave) {
                this.callSaveItems(dataToSave);
            }
        } else { // palestra y diaDeCampo
            this.callSaveItems(
                this.data.map(element => {
                    return {
                        CRM_Calendario_de_eventos__c: this.recordId,
                        Cultivar__c: element.Cultivar__c,
                    };
                })
            );
        }
    }

    /**
     * Solicita el guardado de los detalles de productos del CRM Evento. Al finalizar exitosamente redirige al record page del CRM Evento.
     * @param {Object[]} data
     */
    callSaveItems(data) {
        Promise.all(data.map(element => updateRecord({ fields: element })))
        .then(() => {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: 'CRM_Calendario_de_Eventos__c',
                    actionName: 'view'
                }
            });
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: error.statusText,
                message: error.body.message,
                variant: 'error'
            }));
        });
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const { row } = event.detail;
        const datatable = this.template.querySelector(this.eventType.ladoALado ? 'c-custom-data-table' : 'lightning-datatable');

        if (actionName === 'Excluir') {
            const copyData = [...this.data];
            const index = copyData.findIndex(element => element.Id === row.Id);

            if (index !== -1) {
                datatable.draftValues = []; // limpiar celdas editadas
                const arr = copyData.splice(index, 1); // se elimina el elemento según su índice

                if (arr.length) {
                    deleteRecord(row.Id)
                    .then(() => {
                        this.data = this.parseData(copyData);
                        this.dispatchEvent(new ShowToastEvent({
                            message: `Produto ${arr[0].cultivarName} excluido`,
                            variant: 'success'
                        }));
                    })
                    .catch(error => {
                        this.dispatchEvent(new ShowToastEvent({
                            title: error.statusText,
                            message: error,
                            variant: 'error'
                        }));
                    });
                }
            }
        }
    }

    handlePicklistChange(event) {
        event.stopPropagation();
        const { data } = event.detail;
        const product = this.data.find(element => element.Id === data.context);

        if (product) {
            this.updateDraftValues({
                Cultura_antecessora__c: data.value,
                Id: product.Id
            });
        }
    }

    /**
     * Método auxiliar para dar soporte a la modificación de valores de eventos de Lado a Lado.
     * Este método no es necesario en los tipos de evento que no sean Lado a Lado.
     * @param {Object} updateItem celda que contiene el campo que fue actualizado
     * @param {(string|number)} updateItem.fieldName nombre api del campo y su nuevo valor 
     * @param {string} updateItem.Id identificativo de la fila que contiene la celda modificada
     */
    updateDraftValues(updateItem) {
        const datatable = this.template.querySelector('c-custom-data-table');

        let draftValueChanged = false;
        let copyDraftValues = [...datatable.draftValues];

        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });

        if (draftValueChanged) {
            datatable.draftValues = [...copyDraftValues];
        } else {
            datatable.draftValues = [...copyDraftValues, updateItem];
        }
    }

    /**
     * Método auxiliar para validar los items de un evento de Lado a Lado. Solo debe de haber un Producto Principal seleccionado (US 13894) y
     * se incluyen campos obligatorios (US 14899).
     * @param {Object[]} data
     * @returns {Boolean} retorna true si los items son válidos para ser guardados
     */
    validLadoXLado(data) {
        let validity = true;

        const principal = data.reduce((previousCount, item) => {
            return item.Produto_Principal__c ? previousCount + 1 : previousCount;
        }, 0);

        if (data.length > 0 && principal !== 1) {
            validity = false;

            this.dispatchEvent(new ShowToastEvent({
                title: 'Atenção',
                message: 'Você deve especificar: um (1) produto principal',
                variant: 'warning'
            }));
        } else {
            const errors = { rows: {}, table: {} };
            let count = 0;

            data.forEach(element => {
                if (!element.Produto_Principal__c) {
                    const { Area_plantada__c, Area_Colhida__c } = element;

                    if (Area_plantada__c && (Area_plantada__c < 0.5 || Area_plantada__c > 10)) {
                        errors.rows[element.Id] = {
                            title: 'Atenção',
                            messages: ['Permitido valores de 0,5 e 10 hectares'],
                            fieldNames: ['Area_plantada__c']
                        };

                        count++;
                    }

                    if (Area_Colhida__c && (Area_Colhida__c < 0.5 || Area_Colhida__c > 10)) {
                        errors.rows[element.Id] = {
                            title: 'Atenção',
                            messages: ['Permitido valores de 0,5 e 10 hectares'],
                            fieldNames: ['Area_Colhida__c']
                        };

                        count++;
                    }
                }
            });

            errors.table.title = `(${count}) erros detectados`;
            errors.table.messages = ['Permitido valores de 0,5 e 10 hectares']; // de momento solo se realiza esta validación

            this.errors = errors;

            if (count !== 0) { validity = false; }
        }

        return validity;
    }
}
import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// sObject
import VARIEDAD_DATOS_COMPLEMENTARES from '@salesforce/schema/Variedad_Datos_Complementares__c';

// Controller
import fetchData from '@salesforce/apex/VariedadDatosComplementaresController.getDatosComplementares';
import countNumberOfRows from '@salesforce/apex/VariedadDatosComplementaresController.countDatosComplementares';

const actions = [
    { label: 'Editar datos complementares', name: 'edit' },
    { label: 'Remover de la tabla', name: 'remove' },
];

const QUERY_LIMIT = 500;

export default class VariedadDatosComplementaresEditor extends LightningElement {

    @api brand;
    @api technology;

    @api
    applyFilters() {
        countNumberOfRows({ brand: this.brand, technology: this.technology })
        .then(data => {
            this.totalNumberOfRows = data.Total;

            fetchData({
                queryLimit: QUERY_LIMIT,
                queryOffset: 0,
                brand: this.brand,
                technology: this.technology
            })
            .then(data => {
                this.data = this.parseData(data);
                this.template.querySelector('lightning-datatable').enableInfiniteLoading = true;
            })
            .catch(error => {
                const event = new ShowToastEvent({
                    message: error.message,
                    variant: 'error'
                });

                this.dispatchEvent(event);
            });
        })
        .catch(error => {
            const event = new ShowToastEvent({
                message: error.message,
                variant: 'error'
            });

            this.dispatchEvent(event);
        });
    }

    @track data;
    @track columns;
    @track sortedBy;
    @track sortDirection;
    @track totalNumberOfRows;

    @wire(getObjectInfo, { objectApiName: VARIEDAD_DATOS_COMPLEMENTARES })
    objectInfo({ data, error }) {
        if (data) {
            this.columns = [
                {
                    type: 'action',
                    typeAttributes: { rowActions: actions },
                },
                {
                    label: data.fields.Name.label,
                    fieldName: 'datoComplementarURL',
                    type: 'url',
                    typeAttributes: {
                        label: { fieldName: 'Name' },
                        target: '_blank'
                    },
                    sortable: true
                },
                {
                    label: data.fields.Variedad__c.label,
                    fieldName: 'variedadURL',
                    type: 'url',
                    typeAttributes: {
                        label: { fieldName: 'Nome_da_variedade__c' },
                        target: '_blank'
                    },
                    sortable: true
                },
                { label: data.fields.Marca__c.label, fieldName: 'Marca__c', type: 'text', sortable: false },
                { label: data.fields.Tecnologia__c.label, fieldName: 'Tecnologia__c', type: 'text', sortable: true },
                { label: data.fields.Safra_Lancamento__c.label, fieldName: 'Safra_Lancamento__c', type: 'text', sortable: true },
                { label: data.fields.Ordem__c.label, fieldName: 'Ordem__c', type: 'number', sortable: true },
                { label: data.fields.Cor_do_hipoc_tilo__c.label, fieldName: 'Cor_do_hipoc_tilo__c', type: 'text', sortable: false },
                { label: data.fields.H_bito_de_Crescimento__c.label, fieldName: 'H_bito_de_Crescimento__c', type: 'text', sortable: false },
                { label: data.fields.Cor_do_hilo__c.label, fieldName: 'Cor_do_hilo__c', type: 'text', sortable: false },
                { label: data.fields.Cor_da_flor__c.label, fieldName: 'Cor_da_flor__c', type: 'text', sortable: false },
                { label: data.fields.Pubesc_ncia__c.label, fieldName: 'Pubesc_ncia__c', type: 'text', sortable: false },
                { label: data.fields.STS_Tolerante_a_sulfonilureias__c.label, fieldName: 'STS_Tolerante_a_sulfonilureias__c', type: 'boolean', sortable: false },
                { label: data.fields.Cancro_da_haste__c.label, fieldName: 'Cancro_da_haste__c', type: 'text', sortable: false },
                { label: data.fields.Mancha_olho_de_r__c.label, fieldName: 'Mancha_olho_de_r__c', type: 'text', sortable: false },
                { label: data.fields.P_stula_bacteriana__c.label, fieldName: 'P_stula_bacteriana__c', type: 'text', sortable: false },
                { label: data.fields.Podrid_o_radicular_de_Phytophtora__c.label, fieldName: 'Podrid_o_radicular_de_Phytophtora__c', type: 'text', sortable: false},
                { label: data.fields.PO_1__c.label, fieldName: 'PO_1__c', type: 'text', sortable: false },
                { label: data.fields.PO_3__c.label, fieldName: 'PO_3__c', type: 'text', sortable: false },
                { label: data.fields.PO_4__c.label, fieldName: 'PO_4__c', type: 'text', sortable: false },
                { label: data.fields.PO_Gene_RPS1K__c.label, fieldName: 'PO_Gene_RPS1K__c', type: 'text', sortable: false  },
                { label: data.fields.Mancha_alvo__c.label, fieldName: 'Mancha_alvo__c', type: 'text', sortable: false  },
                { label: data.fields.Nematoides_Cisto__c.label, fieldName: 'Nematoides_Cisto__c', type: 'text', sortable: false },
                { label: data.fields.Nematoides_Cisto_Ra_a_3__c.label, fieldName: 'Nematoides_Cisto_Ra_a_3__c', type: 'text', sortable: false },
                { label: data.fields.Nematoides_Cisto_Ra_a_6__c.label, fieldName: 'Nematoides_Cisto_Ra_a_6__c', type: 'text', sortable: false },
                { label: data.fields.Nematoides_Cisto_Ra_a_9__c.label, fieldName: 'Nematoides_Cisto_Ra_a_9__c', type: 'text', sortable: false },
                { label: data.fields.Nematoides_Cisto_Ra_a_10__c.label, fieldName: 'Nematoides_Cisto_Ra_a_10__c', type: 'text', sortable: false },
                { label: data.fields.Nematoides_Cisto_Ra_a_14__c.label, fieldName: 'Nematoides_Cisto_Ra_a_14__c', type: 'text', sortable: false },
                { label: data.fields.Nematoides_Cisto_Ra_a_14_plus__c.label, fieldName: 'Nematoides_Cisto_Ra_a_14_plus__c', type: 'text', sortable: false },
                { label: data.fields.Nematoides_Galha__c.label, fieldName: 'Nematoides_Galha__c', type: 'text', sortable: false },
                { label: data.fields.Nematoides_Galha_Meloydogine_javanica__c.label, fieldName: 'Nematoides_Galha_Meloydogine_javanica__c', type: 'text', sortable: false },
                { label: data.fields.Nematoides_Galha_Meloydogine_incognit__c.label, fieldName: 'Nematoides_Galha_Meloydogine_incognit__c', type: 'text', sortable: false },
            ];
        } else if (error) {
            const event = new ShowToastEvent({
                title: error.statusText,
                message: error.message,
                variant: 'error'
            });

            this.dispatchEvent(event);
        }
    }

    parseData(data) {
        return data.map(row => {
            return {
                ...row,
                variedadURL: location.host + '/' + row.Variedad__c,
                datoComplementarURL: location.host + '/' + row.Id,
            }
        });
    }

    loadMoreData(event) {
        const { target } = event;
        target.isLoading = true;

        fetchData({
            queryLimit: QUERY_LIMIT,
            queryOffset: this.data.length,
            brand: this.brand,
            technology: this.technology
        })
        .then(data => {
            this.data = this.data.concat(this.parseData(data));

            if (this.data.length >= this.totalNumberOfRows) {
                target.enableInfiniteLoading = false;
            }

            target.isLoading = false;
        })
        .catch(error => {
            const event = new ShowToastEvent({
                message: error.message,
                variant: 'error'
            });

            this.dispatchEvent(event);
        });
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const { row } = event.detail;

        switch (actionName) {
            case 'edit':
                this.editDatosComplementares(row);
                break;
            case 'remove':
                this.removeRow(row);
                break;
        }
    }

    removeRow(row) {
        const { id } = row;
        const index = this.findRowIndexById(id);

        if (index !== -1) {
            this.data = this.data.slice(0, index).concat(this.data.slice(index + 1));
        }
    }

    findRowIndexById(id) {
        let ret = -1;
        this.data.some((row, index) => {
            if (row.id === id) {
                ret = index;
                return true;
            } else {
                return false;
            }
        });
        return ret;
    }

    editDatosComplementares(row) {
        const editRecordEvent = new CustomEvent('editrecord', {
            detail: { row },
        });

        this.dispatchEvent(editRecordEvent);
    }

    doSorting(event) {
        const { fieldName, sortDirection } = event.detail;

        this.sortedBy = fieldName;
        this.sortedDirection = sortDirection;

        if (this.data) {
            this.data = this.sortData(fieldName, sortDirection);
        }
    }

    sortData(fieldName, sortDirection) {
        let fName = fieldName;
        const isReverse = sortDirection === 'asc' ? 1 : -1;

        if (fieldName === 'datoComplementarURL') {
            fName = 'Name';
        } else if (fieldName === 'variedadURL') {
            fName = 'Nome_da_variedade__c';
        }

        const mapped = this.data.map((el, i) => {
            return { index: i, value: el[fName] };
        })

        mapped.sort((a, b) => {
            return isReverse * ((a.value > b.value) - (a.value < b.value));
        });

        return mapped.map(el => this.data[el.index]);
    }
}
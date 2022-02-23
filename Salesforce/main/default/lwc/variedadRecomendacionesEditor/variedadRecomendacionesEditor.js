import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// sObject
import VARIEDAD_RECOMENDACIONES from '@salesforce/schema/Recomenda_o_de_variedade__c';

// Controller
import fetchData from '@salesforce/apex/VariedadRecomendacionesController.getRecomendaciones';
import countNumberOfRows from '@salesforce/apex/VariedadRecomendacionesController.countRecomendaciones';

const actions = [
    { label: 'Editar recomendações', name: 'edit' },
    { label: 'Remover de la tabla', name: 'remove' },
];

const QUERY_LIMIT = 500;

export default class VariedadRecomendacionesEditor extends LightningElement {

    @api brand;
    @api technology;
    @api region;

    @api
    applyFilters() {
        countNumberOfRows({
            brand: this.brand,
            technology: this.technology,
            region: this.region
        })
        .then(data => {
            this.totalNumberOfRows = data.Total;

            fetchData({
                queryLimit: QUERY_LIMIT,
                queryOffset: 0,
                brand: this.brand,
                technology: this.technology,
                region: this.region
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

    @wire(getObjectInfo, { objectApiName: VARIEDAD_RECOMENDACIONES })
    objectInfo({ data, error }) {
        if (data) {
            this.columns = [
                {
                    type: 'action',
                    typeAttributes: { rowActions: actions },
                },
                {
                    label: data.fields.Name.label,
                    fieldName: 'recomendacionURL',
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
                { label: data.fields.Safra__c.label, fieldName: 'Safra__c', type: 'text', sortable: true },
                { label: data.fields.Regi_o__c.label, fieldName: 'Regi_o__c', type: 'text', sortable: false },
                { label: data.fields.Nome_da_estado__c.label, fieldName: 'Nome_da_estado__c', type: 'text', sortable: false },
                { label: data.fields.Nome_da_macro__c.label, fieldName: 'Nome_da_macro__c', type: 'text', sortable: false },
                { label: data.fields.Nome_da_micro__c.label, fieldName: 'Nome_da_micro__c', type: 'text', sortable: false },
                { label: data.fields.Micro_Detalhe__c.label, fieldName: 'Micro_Detalhe__c', type: 'text', sortable: false },
                { label: data.fields.Titulo__c.label, fieldName: 'Titulo__c', type: 'text', sortable: false },
                { label: data.fields.Inicio_Antecipado__c.label, fieldName: 'Inicio_Antecipado__c', type: 'text', sortable: false },
                { label: data.fields.Fim_Antecipado__c.label, fieldName: 'Fim_Antecipado__c', type: 'text', sortable: false },
                { label: data.fields.Inicio_Tolerado__c.label, fieldName: 'Inicio_Tolerado__c', type: 'text', sortable: false },
                { label: data.fields.Fim_Tolerado__c.label, fieldName: 'Fim_Tolerado__c', type: 'text', sortable: false },
                { label: data.fields.In_cio_Preferencial__c.label, fieldName: 'In_cio_Preferencial__c', type: 'text', sortable: false },
                { label: data.fields.Fim_Preferencial__c.label, fieldName: 'Fim_Preferencial__c', type: 'text', sortable: false },
                { label: data.fields.Densidade_Min__c.label, fieldName: 'Densidade_Min__c', type: 'number', sortable: false },
                { label: data.fields.Densidade_Max__c.label, fieldName: 'Densidade_Max__c', type: 'number', sortable: false },
                { label: data.fields.Ciclo_M_dio__c.label, fieldName: 'Ciclo_M_dio__c', type: 'number', sortable: false },
                { label: data.fields.Detalhe__c.label, fieldName: 'Detalhe__c', type: 'text', sortable: false },
                { label: data.fields.Dias_at_R1__c.label, fieldName: 'Dias_at_R1__c', type: 'number', sortable: false },
                { label: data.fields.IA_Min__c.label, fieldName: 'IA_Min__c', type: 'number', sortable: false },
                { label: data.fields.Algoritmo__c.label, fieldName: 'Algoritmo__c', type: 'boolean', sortable: false },
                { label: data.fields.Adapta_o_da_cultivar__c.label, fieldName: 'Adapta_o_da_cultivar__c', type: 'text', sortable: false },
                { label: data.fields.Altitude_minima__c.label, fieldName: 'Altitude_minima__c', type: 'number', sortable: false },
                { label: data.fields.Altitude_maxima__c.label, fieldName: 'Altitude_maxima__c', type: 'number', sortable: false },
                { label: data.fields.Ordem_micro__c.label, fieldName: 'Ordem_micro__c', type: 'number', sortable: false },
                { label: data.fields.Altura_de_planta_cm__c.label, fieldName: 'Altura_de_planta_cm__c', type: 'number', sortable: false },
                { label: data.fields.Grupo_de_Matura_o__c.label, fieldName: 'Grupo_de_Matura_o__c', type: 'text', sortable: false },
                { label: data.fields.Potencial_de_Ramifica_o__c.label, fieldName: 'Potencial_de_Ramifica_o__c', type: 'text', sortable: false },
                { label: data.fields.Porte__c.label, fieldName: 'Porte__c', type: 'text', sortable: false },
                { label: data.fields.Resist_ncia_ao_acamamento__c.label, fieldName: 'Resist_ncia_ao_acamamento__c', type: 'text', sortable: false },
                { label: data.fields.Exig_ncia_a_Fertilidade__c.label, fieldName: 'Exig_ncia_a_Fertilidade__c', type: 'text', sortable: false },
                { label: data.fields.PMG__c.label, fieldName: 'PMG__c', type: 'text', sortable: false },
                { label: data.fields.Pontos_Fortes__c.label, fieldName: 'Pontos_Fortes__c', type: 'text', sortable: false },
                { label: data.fields.Texto_Legal__c.label, fieldName: 'Texto_Legal__c', type: 'text', sortable: false },
                { label: data.fields.Mostrar_Recomendador__c.label, fieldName: 'Mostrar_Recomendador__c', type: 'boolean', sortable: false },
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
                recomendacionURL: location.host + '/' + row.Id,
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
            technology: this.technology,
            region: this.region
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
                this.editRecomendacion(row);
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

    editRecomendacion(row) {
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

        if (fieldName === 'recomendacionURL') {
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
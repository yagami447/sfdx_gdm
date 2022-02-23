import { LightningElement, track, wire } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';

import OBJECT_VARIEDAD from '@salesforce/schema/Variedad__c';
import OBJECT_RECOMENDACION from '@salesforce/schema/Recomenda_o_de_variedade__c';
import FIELD_MARCA from '@salesforce/schema/Variedad__c.Marca__c';
import FIELD_TECNOLOGIA from '@salesforce/schema/Variedad__c.Tecnologia__c';
import FIELD_REGION from '@salesforce/schema/Recomenda_o_de_variedade__c.Regi_o__c';

const DATOS_COMPLEMENTARES = 'Datos Complementares';
const RECOMENDACIONES = 'Recomendações de Variedad';

export default class VariedadDatosComplementares extends LightningElement {

    items = [
        {
            id: 'menu-item-1',
            label: DATOS_COMPLEMENTARES,
            value: DATOS_COMPLEMENTARES,
        },
        {
            id: 'menu-item-2',
            label: RECOMENDACIONES,
            value: RECOMENDACIONES,
        },
    ];

    component = DATOS_COMPLEMENTARES;
    itemOneVisible = true;
    itemTwoVisible = false;

    @track
    filters = {
        brand: '',
        technology: '',
        region: '',
    }

    @wire(getObjectInfo, { objectApiName: OBJECT_VARIEDAD }) variedad;
    @wire(getObjectInfo, { objectApiName: OBJECT_RECOMENDACION }) recomendacion;
    @wire(getPicklistValues, { recordTypeId: '$variedad.data.defaultRecordTypeId', fieldApiName: FIELD_MARCA }) brand;
    @wire(getPicklistValues, { recordTypeId: '$variedad.data.defaultRecordTypeId', fieldApiName: FIELD_TECNOLOGIA }) technology;
    @wire(getPicklistValues, { recordTypeId: '$recomendacion.data.defaultRecordTypeId', fieldApiName: FIELD_REGION }) region;

    handleSelect(event) {
        const { name } = event.target;

        if (name === 'brand') {
            this.filters.brand = event.detail.value;
        } else if (name === 'technology') {
            this.filters.technology = event.detail.value;
        } else if (name === 'region') {
            this.filters.region = event.detail.value;
        }
    }

    handleApplyFilters() {
        if (this.component === DATOS_COMPLEMENTARES) {
            this.template.querySelector('c-variedad-datos-complementares-editor').applyFilters();
        } else if (this.component === RECOMENDACIONES) {
            this.template.querySelector('c-variedad-recomendaciones-editor').applyFilters();
        }
    }

    handleRemoveFilters() {
        for (const property in this.filters) {
            if (Object.hasOwnProperty.call(this.filters, property)) {
                this.filters[property] = '';
            }
        }
    }

    handleEditRecord(event) {
        this.dispatchEvent(new CustomEvent('editrecord', event));
    }

    handleClickMenuItem(event) {
        const { value } = event.target;

        if (value === DATOS_COMPLEMENTARES) {
            this.component = DATOS_COMPLEMENTARES;
            this.itemOneVisible = true;
            this.itemTwoVisible = false;
        } else if (value === RECOMENDACIONES) {
            this.component = RECOMENDACIONES;
            this.itemOneVisible = false;
            this.itemTwoVisible = true;
        }
    }
}
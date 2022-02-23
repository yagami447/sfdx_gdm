import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

// sObject
import ID from '@salesforce/schema/CRM_Calendario_de_Eventos__c.Id';
import NAME from '@salesforce/schema/CRM_Calendario_de_Eventos__c.Name';
import RECORD_TYPE_ID from '@salesforce/schema/CRM_Calendario_de_Eventos__c.RecordTypeId';
import RECORD_TYPE_NAME from '@salesforce/schema/CRM_Calendario_de_Eventos__c.RecordType.Name';
import RECORD_TYPE_DNAME from '@salesforce/schema/CRM_Calendario_de_Eventos__c.RecordType.DeveloperName';

const EVENT_TYPE = {
    palestra: false,
    diaDeCampo: false,
    ladoALado: false,
    emplacamento: false,
}

export default class AddCRMEventItemsLWC extends NavigationMixin(LightningElement) {

    title;
    recordId;

    @track eventType;

    @wire(getRecord, { recordId: new URL(window.location.href).searchParams.get('id'), fields: [ID, NAME, RECORD_TYPE_ID, RECORD_TYPE_NAME, RECORD_TYPE_DNAME] })
    evento({ data, error }) {
        if (data) {
            this.title = data.fields.Name.value;
            this.recordId = data.fields.Id.value;

            const { DeveloperName } = data.fields.RecordType.value.fields;

            if (DeveloperName.value === 'Treinamento_Tecnico') {
                EVENT_TYPE.palestra = true;
            } else if (DeveloperName.value === 'Dia_de_Campo') {
                EVENT_TYPE.diaDeCampo = true;
            } else if (DeveloperName.value === 'Test_a_campo') {
                EVENT_TYPE.ladoALado = true;
            } else if (DeveloperName.value === 'Emplacamento') {
                EVENT_TYPE.emplacamento = true;
            }

            this.eventType = EVENT_TYPE;
        } else if (error) {
            const event = new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            });

            this.dispatchEvent(event);
        }
    }

    handleAddProduct(event) {
        this.template.querySelector('c-crud-event-items').addProduct(event);
    }

    handleSave(event) {
        this.template.querySelector('c-crud-event-items').saveItems();
    }

    handleCancel(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'CRM_Calendario_de_Eventos__c',
                actionName: 'view'
            }
        });
    }
}
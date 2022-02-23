import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// sObject
import PRODUCT from '@salesforce/schema/Product2';

// Controller
import callForAvailableProducts from '@salesforce/apex/AddCRMEventItemsController.getAvailableProducts';

export default class AddCRMEventItems extends LightningElement {

    @api recordId;
    @api eventType;

    @track data;
    @track filteredData;
    @track columns;

    @wire(getObjectInfo, { objectApiName: PRODUCT })
    products({ data, error }) {
        if (data) {
            this.columns = [
                {
                    type: 'button',
                    typeAttributes: {
                        label: 'Adicionar',
                        name: 'Adicionar',
                        title: 'Adicionar',
                        value: 'adicionar'
                    },
                    hideDefaultActions: true
                },
                {
                    label: data.fields.Obtentor__c.label,
                    fieldName: 'Obtentor__c',
                    type: 'text',
                    sortable: false,
                    hideDefaultActions: true,
                    cellAttributes: {
                        alignment: 'left'
                    },
                },
                {
                    label: data.fields.Name.label,
                    fieldName: 'Name',
                    type: 'text',
                    sortable: false,
                    hideDefaultActions: true,
                    cellAttributes: {
                        alignment: 'left'
                    }
                },
            ];
        } else if (error) {
            const event = new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            });

            this.dispatchEvent(event);
        }
    }

    connectedCallback() {
        callForAvailableProducts({ recordId: this.recordId, search: '' })
        .then(result => {
            if (this.eventType.palestra) {
                const finalData = [];
                const added = [];

                result.forEach(item => {
                    if (!added.includes(item.Obtentor__c)) {
                        finalData.push(item);
                        added.push(item.Obtentor__c);
                    }
                });

                this.data = finalData;
                this.filteredData = finalData;
            } else {
                this.data = result;
                this.filteredData = result;
            }
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

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const { row } = event.detail;

        if (actionName === 'Adicionar') {
            const product = this.data.find(element => element.Id === row.Id);
            const addProductEvent = new CustomEvent('addproduct', {
                detail: { product },
            });
    
            this.dispatchEvent(addProductEvent);
        }
    }

    handleKeyUp(event) {
        if (event.keyCode === 13) {
            const { value } = event.target;

            if (value) {
                this.filteredData = this.data.filter(element => {
                    return (element.Name && element.Name.toLowerCase().indexOf(value.toLowerCase()) !== -1) || (element.Obtentor__c && element.Obtentor__c.toLowerCase().indexOf(value.toLowerCase()) !== -1);
                });
            } else {
                this.filteredData = this.data;
            }
        }
    }
}
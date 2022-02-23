import { LightningElement, track, wire, api } from 'lwc';
import USER_ID from '@salesforce/user/Id';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import OPPLINEITEM_OBJECT from '@salesforce/schema/OpportunityLineItem';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 

import getItems from '@salesforce/apex/OpportunityHelper.selectOpportunityLineItems';
import saveItems from '@salesforce/apex/OpportunityHelper.verifyOpportunityLineItems'; 

const RECORD_TYPE_FIELDSET = {
    "DEFAULT": [
        { apiName: 'Name', isReadOnly: true }
    ],
    "PB-Comercial Milho": [
        { apiName: 'Variedad__c', isReadOnly: true },
        { apiName: 'Embalagem__c', isReadOnly: false },
        { apiName: 'Tratamento__c', isReadOnly: false },
        //{ apiName: 'Quantidade_de_sementes__c', isReadOnly: false }
        { apiName: 'Quantidade__c', isReadOnly: false }
    ],
    "Stock Multiplicadores Milho": [
        { apiName: 'Variedad__c', isReadOnly: true },
        { apiName: 'Semente_aprovada__c', isReadOnly: false },
        { apiName: 'Semente_comercializada__c', isReadOnly: false },
        { apiName: 'Estimativa__c', isReadOnly: false }
    ],
    "Venda da Basica Completo": [
        { apiName: 'Variedade_Prod__c', isReadOnly: true },
        { apiName: 'Variedad_de_Produto__c', isReadOnly: true },
        { apiName: 'UNIDADE__c', isReadOnly: true },
        { apiName: 'Categoria_Prod__c', isReadOnly: true },
        { apiName: 'Tratamiento_de_Semilla__c', isReadOnly: false },
        { apiName: 'Tipo_de_Necessidade__c', isReadOnly: false },
        { apiName: 'Quantity', isReadOnly: false },
        { apiName: 'Quant_Confirmada__c', isReadOnly: false },
        { apiName: 'Quant_Rechazada__c', isReadOnly: false },
        { apiName: 'Quant_Pendiente__c', isReadOnly: true },
        { apiName: 'UnitPrice', isReadOnly: false },
        { apiName: 'Precio_Bolsa__c', isReadOnly: true },
        { apiName: 'Precio_Total__c', isReadOnly: true },
        { apiName: 'Kg_de_Produto__c', isReadOnly: true },
        { apiName: 'Motivo_de_Rechazo__c', isReadOnly: false },
        { apiName: 'Posicion_SAP__c', isReadOnly: false }                              
    ]
}

export default class OppLineItem_Milho extends LightningElement {
    @api recordId;
    @track isModalOpen = false;
    @track isAdmin = false;
    @track isEditionMode = false;
    @track isButtonDisabled = true; // all buttons - all areActionsDisable ??
    @track originalItems = [];
    @track modifyItems = []; // ver el nombre, hace ruido
    @track listOfFields = [];
    @track recordTypeFields = [];
    opportunityLineItemFields = {};
    opportunityLineItems = [];
    isFirstRender = true;
    
    label = {
        title: 'Opp line item'
    }

    renderedCallback() {
        if (this.isFirstRender) {
            this.isFirstRender = false;
            this.template.querySelector('.oppLineItem__styles').innerHTML = '<style> .oppLineItem__container lightning-helptext { display:none }</style>';
        }
    }

    // Get user PROFILE
    @wire(getRecord, {
        recordId: USER_ID,
        fields: ['User.Profile.Name']
    }) wireUser({ error, data }) {
        if (data)
            if ( data.fields.Profile.displayValue === 'Administrador del sistema' )
                this.isAdmin = true;
        if (error)
            console.warn(error);
    }

    // Get opportunity Record Type & StageName
    @wire(getRecord, {
        recordId: '$recordId',
        fields: ['Opportunity.RecordType.Name','Opportunity.StageName']
    }) wireRecordType({ error, data }) {
        if (data) {
            this.isEditionMode = false;
            if (  data.fields.StageName.value === "PB-Edicion" || data.fields.StageName.value === "Edición" ) // Irina - Change for Estoque Mensal
                this.isEditionMode = true;
            if ( RECORD_TYPE_FIELDSET[data.recordTypeInfo.name] ) {
                this.recordTypeFields = RECORD_TYPE_FIELDSET[data.recordTypeInfo.name];
            } else {
                this.recordTypeFields = RECORD_TYPE_FIELDSET['DEFAULT'];
            }
            this.setOriginalItems();
        }
        if (error)
            console.warn(error);
    }

    // Get opportunity line item fields data
    @wire(getObjectInfo, {
        objectApiName: OPPLINEITEM_OBJECT
    }) opportunityLineItemInfo({ error, data }) {
        if (data) {
            this.opportunityLineItemFields = data.fields;
            this.setOriginalItems();
        }
        if (error)
            console.warn(error);
    }

    setOriginalItems() {
        if ( this.recordTypeFields.length && Object.keys(this.opportunityLineItemFields).length ) { 

            this.recordTypeFields.forEach (field => {
                if ( this.opportunityLineItemFields[field.apiName] ) {
                    field.label = this.opportunityLineItemFields[field.apiName].label;
                    field.dataType = this.opportunityLineItemFields[field.apiName].dataType;
                }
                this.listOfFields.push(field.apiName);

                if ( field.dataType === 'Reference')
                    this.listOfFields.push( field.apiName.replace('__c', '__r.Name'));
            })
            getItems({
                idOpp: this.recordId,
                fields: this.listOfFields
            })
            .then(result => {
                this.originalItems = result.map(( record, index) => {
                    // mapeo (id: index)
                    return this.setNewLineItem(record ,'original');
                })
                this.modifyItems = JSON.parse(JSON.stringify(this.originalItems));
            })
            .catch(error => {
                this.error = error;
            });
        }
    }

    setNewLineItem(record, status) {
        let newItem = {};
        newItem = {
            OpportunityId: this.recordId,
            id: record.Id,
            status: status,
            isEdited: false,
            isNew: false,
            isDeleted: false
        }
        
        if ( status === 'original' ) {
            newItem.isOriginal = true;
        } else {
            newItem.isOriginal = false;
            newItem.isNew = true;
        }

        let recordData = [];
        this.recordTypeFields.forEach (field => {
            let obj = {
                apiName: field.apiName,
                isReadOnly: newItem.isNew ? newItem.isNew : field.isReadOnly,
                dataType: field.dataType
            };
            switch (field.dataType) {
                case 'Double':
                    obj.showLabel = true;
                    obj.label = record[field.apiName] ? record[field.apiName].toLocaleString() : '';
                    obj.value = record[field.apiName];
                    break;
                case 'Reference':
                    obj.showLabel = true;
                    let referenceField =field.apiName.replace('__c', '__r');
                    obj.value = record[field.apiName];
                    if ( record[referenceField] && record[referenceField].Name ) {
                        obj.label = record[referenceField].Name;
                    } else {
                        obj.value = record[field.apiName];
                        obj.showLabel = false;
                    }
                    break;
                default: 
                    obj.value = record[field.apiName];
                    break;
            };
            recordData.push(obj);
        })
        newItem.recordData = recordData;
        return newItem;
    }

    handleClickNew() {
        this.isModalOpen = true;
    }

    handleCloseModal() {
        this.isModalOpen = false;
    }

    handleSubmitNew(event) {
        event.preventDefault(); // stop the form from submitting
        this.modifyItems.push(this.setNewLineItem(event.detail.fields, 'new'));
        this.isModalOpen = false;
        this.isButtonDisabled = false;
    }
    
    handleClickDelete(event) {
        let item = this.modifyItems.find(array => array.id === event.target.dataset.id);
        item.status = 'deleted'; 
        item.isDeleted = true;
        item.isOriginal = false; 
        item.recordData.forEach((item) => item.isReadOnly = true); 
        this.isButtonDisabled = false;
    }

    handleChange(event) {
        let item = this.modifyItems.find(array => array.id === event.target.dataset.id);
        let itemOriginal = this.originalItems.find(array => array.id === event.target.dataset.id);
        
        if ( itemOriginal.recordData.find(array => array.apiName === event.target.dataset.apiname).value !== event.target.value ) {
            item.recordData.find(array => array.apiName === event.target.dataset.apiname).value = event.target.value;
            item.status = 'edited';
            item.isEdited = true;
            item.isOriginal = false;
            this.isButtonDisabled = false;
        }
    }
    
    handleClickSave() {
        let listUpsert = [];
        let listDelete = [];
        this.modifyItems.forEach( record => {
            if ( !record.isOriginal ) {
                let updateRecord = {};
                record.recordData.forEach( field => {
                    updateRecord[field.apiName] = field.value;
                });
                updateRecord.OpportunityId = record.OpportunityId;
                updateRecord.Id = record.id;

                if ( record.status === 'deleted' ) {
                    listDelete.push(updateRecord);
                }else{
                    listUpsert.push(updateRecord);
                }

            }
        });
        console.log(listDelete);
        saveItems({
            listUpsert: JSON.stringify(listUpsert),
            listDelete: JSON.stringify(listDelete)
        })
        .then(result => {
            console.log(result);
            location.reload();
        })
        .catch(error => {
            console.warn(error);
            this.showToast('Something went wrong', error.body.message, 'error');
        });
    }

    handleClickCancel() {
        this.modifyItems = this.originalItems;
        this.isButtonDisabled = true;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

}
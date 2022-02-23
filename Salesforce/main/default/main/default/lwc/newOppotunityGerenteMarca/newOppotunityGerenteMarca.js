import { LightningElement, track, wire } from 'lwc';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

// Labels
import createopportunity from '@salesforce/label/c.CreateOpportunity';

export default class NewOppotunityGerenteMarca extends NavigationMixin(LightningElement) {
    @track objectInfo;
    @track regiones;
    @track marcas;
    @track safras;
    @track isButtonDisabled = true;
    oppRecordTypeId = '';

    @wire(getObjectInfo, { objectApiName: 'Opportunity' })
    getObjectFieldInfo(value) {
        if (value.data) {
            function recordType(array) {
                return array.name === 'PB-Comercial Milho';
            }
            this.oppRecordTypeId = Object.values(value.data.recordTypeInfos).find(recordType).recordTypeId;
        }
    }

    @wire(getPicklistValuesByRecordType, { recordTypeId: "$oppRecordTypeId", objectApiName: 'Opportunity' })
    getPicklistValues(value) {
        if (value.data) {
            this.regiones = value.data.picklistFieldValues['Region__c'].values;
            this.marcas = value.data.picklistFieldValues['Marca__c'].values;
            this.safras = value.data.picklistFieldValues['Safra__c'].values;
        }
    }


    
    // Labels
    label = {
        createopportunity
    }

    handleChangeRegion (event) {
        this.region = event.detail.value;
        this.checkButtonActivation();
    }

    handleChangeMarca (event) {
        this.marca = event.detail.value;
        this.checkButtonActivation();
    }

    handleChangeSafra (event) {
        this.safra = event.detail.value;
        this.checkButtonActivation();
    }

    checkButtonActivation(){
        if (this.region && this.marca && this.safra){
            this.isButtonDisabled = false;
        }
    }

    handleClickNew (event) {
        let dt = new Date();
        const dtf = new Intl.DateTimeFormat('en', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit'
        })
        const [{value: mo}, , {value: da}, , {value: ye}] = dtf.formatToParts(dt);
        let formatedDate = `${ye}/${mo}/${da}`;

        let defaultValues= encodeDefaultFieldValues({
            Region__c: this.region,
            Marca__c: this.marca,
            Safra__c: this.safra,
            Cultura__c: 'Milho',
            StageName: 'PB-Edicion',
            Name: 'Novo'
        });
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues,
                nooverride: '1',
                recordTypeId: this.oppRecordTypeId
            }
        });
    }

}
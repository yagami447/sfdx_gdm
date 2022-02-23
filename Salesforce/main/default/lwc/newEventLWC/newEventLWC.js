import { LightningElement, wire } from 'lwc';
//Apex Controller
import getRecordTypes from '@salesforce/apex/NewRecordController.getRecordTypesAllowedUC'
import callMarca from '@salesforce/apex/NewRecordController.getMarca'
import callAccountId from '@salesforce/apex/NewRecordController.getAccountId'
import callConfig from '@salesforce/apex/NewRecordController.getConfiguration'
//LABELS
import labelcreateevent from '@salesforce/label/c.CreateEvent';

export default class NewEventLWC extends LightningElement {

    //Labels
    label = {
        labelcreateevent
    }

    //Objects
    @wire(getRecordTypes,{sobjectname: 'CRM_Calendario_de_Eventos__c'}) recordtypes
    @wire(callMarca) marca
    @wire(callAccountId) accountId
    @wire(callConfig) config

    handleClick(event) {
        event.preventDefault();
        window.console.log(event.target);
        window.console.log(event.target.dataset.id);
        
        const oncreateevent = new CustomEvent('createevent', {
            detail: { 
                id: event.target.dataset.id,
                name: event.target.dataset.name,
                marca: this.marca.data,
                accountId: this.accountId.data,
                config: this.config.data.PM_Safra_Actual_Eventos__c
            },
        });
        // Fire the custom event
        this.dispatchEvent(oncreateevent);
    }
}
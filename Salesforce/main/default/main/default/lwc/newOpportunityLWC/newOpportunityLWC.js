/*
        @Author: Sergio Migueis - K2
        @Description: Component JS
                    Used to pick the opportunity type.

        @History:
        05/11/2019 - Creation.
        20/11/2019 - Connection with backend.
        26/11/2019 - Deploy from scratchorg
 */

 /*
    imports:
 */
import { LightningElement, wire } from 'lwc';
import getRecordTypes from '@salesforce/apex/NewRecordController.getRecordTypesAllowedUC'
import callMarca from '@salesforce/apex/NewRecordController.getMarca'
import callAccountId from '@salesforce/apex/NewRecordController.getAccountId'
import callConfig from '@salesforce/apex/NewRecordController.getConfiguration'
import callRegion from '@salesforce/apex/NewRecordController.getRegion'
/*
    Labels:
*/
import createopportunity from '@salesforce/label/c.CreateOpportunity';

export default class newOpportunityLWC extends LightningElement {
    
    //Labels
    label = {
        createopportunity
    }

    //Objects
    @wire(getRecordTypes,{sobjectname: 'Opportunity'}) recordtypes
    @wire(callMarca) marca
    @wire(callAccountId) accountId
    @wire(callConfig) config
    @wire(callRegion) region
    //No componente original pegava da safra atual,
    //Celso pediu que fosse pelo tipo de registro
    idSafraMap = {
        '01240000000M7LvAAK': 'PM_Safra_Actual_A1__c', //A1
        '01240000000M7M0AAK': 'PM_Safra_Actual_A2__c', //A2
        '01240000000M7P4AAK': 'PM_Safra_Actual_A2__c', //Rebaix
        '01240000000M7y6AAC': 'PM_Safra_Actual_A3__c', //A3
        '01240000000M7y8AAC': 'PM_Safra_Actual_A4__c', //A4
        '01240000000M7MFAA0': 'PM_Safra_Actual_A5__c', //A5
        '01240000000M7MAAA0': 'PM_Safra_Actual_A4__c', //A42
        '0120b000000EyRIAA0': 'PM_Safra_Actual_Descarte__c', //Descarte
        '01240000000MDvBAAW': 'PM_Safra_Actual_Reembalagem__c', //Reembala
        '01240000000M9ltAAC': 'PM_Safra_Actual_Estoque__c', //Estoque
    }
    
    connectedCallback(){
        console.log('Datos traidos de la cuenta');
        console.log(this.region);
        console.log(this.accountId);
        console.log(this.marca);
    }

    handleClick(event){
        event.preventDefault()
        window.console.log(event.target)
        window.console.log(event.target.dataset.id)
        
        const oncreateopportunity = new CustomEvent('createopportunity', {
            detail: { 
                id: event.target.dataset.id,
                name: 'NOVO',
                marca: this.marca.data,
                closedate: (new Date()).toISOString().slice(0,10),
                stage: 'Edición',
                accountId: this.accountId.data,
                config: this.config.data[this.idSafraMap[event.target.dataset.id]],
                region: this.region.data
            },
        });
        // Fire the custom event
        this.dispatchEvent(oncreateopportunity)
    }
   
    

    


}
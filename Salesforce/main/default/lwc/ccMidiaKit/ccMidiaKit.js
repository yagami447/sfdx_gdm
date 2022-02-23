import { LightningElement, wire, track } from 'lwc';
import getLinks from '@salesforce/apex/Utils.getFieldValuesAura';

export default class CcMidiaKit extends LightningElement {

    
    @track finalList = [];
    data = [];

    @wire(getLinks, {
        recordId: 'Midia_Kit__c',
        fields: ['Name', 'Active__c', 'Category__c', 'URL__c'],
        filter: 'Marca__c = \'NEOG\'',
        orderBy: 'Category__c'
    }) wireLinks({ error, data }) {
        if (data) {
            let tempObject = {};
            data.forEach(element => {
                if (element.Active__c) {
                    let tempList = [];
                    if (tempObject[element.Category__c]){
                    tempList = tempObject[element.Category__c].items;
                    }
                    tempObject[element.Category__c] = {
                        cat_api: element.Category__c,
                        cat_label: element.Category__c,
                        items: tempList.concat([element])
                    }
                }
            });

            this.finalList = Object.values(tempObject);
        }
        if (error)
            console.warn(error);
    }
    
    connectedCallback(){
        // let tempObject = {};
        // let cont = 1;
        // this.data.forEach(element => {
        //     let tempList = [];
        //     if (tempObject[element.cat_api]){
        //        tempList = tempObject[element.cat_api].items;
        //     }
        //     element.Id = cont;
        //     tempObject[element.cat_api] = {
        //         cat_api: element.cat_api,
        //         cat_label: element.cat_label,
        //         items: tempList.concat([element])
        //     }
        //     cont++;
        // });

        // this.finalList = Object.values(tempObject);
    }

    data = [
        {
            cat_label: 'Arte de Resultado de Produtividade',
            cat_api: 'arte',
            Name: 'Resultado Produtividade 2021 – Cerrado',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/ResultProdutiv/ResultadoCERRADO.pptx'
        },
        {
            cat_label: 'Arte de Resultado de Produtividade',
            cat_api: 'arte',
            Name: 'Resultado Produtividade 2021 – Sul',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/ResultProdutiv/ResultadoSUL.pptx'
        },
        {
            cat_label: 'Big Bag',
            cat_api: 'bigbag',
            Name: 'BigBag Neogen 105x120cm',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/BigBag/BigBagNeogen105x120cm.pdf'
        },
        {
            cat_label: 'Big Bag',
            cat_api: 'bigbag',
            Name: 'Etiqueta Neogen Big Bag CONKESTA',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/BigBag/EtiquetaNEOGENBigBagCONKESTA.pdf'
        },
        {
            cat_label: 'Big Bag',
            cat_api: 'bigbag',
            Name: 'Etiqueta Neogen Big Bag INTACTA',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/BigBag/EtiquetaNEOGENBigBagINTACTA.pdf'
        },
        {
            cat_label: 'Big Bag',
            cat_api: 'bigbag',
            Name: 'Etiqueta Neogen Big Bag INTACTA 2XTEND',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/BigBag/EtiquetaNEOGENBigBagINTACTA2XTEND.pdf'
        },
        {
            cat_label: 'Big Bag',
            cat_api: 'bigbag',
            Name: 'Etiqueta Neogen Big Bag RR',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/BigBag/EtiquetaNEOGENBigBagRR.pdf'
        },
        {
            cat_label: 'Logos',
            cat_api: 'logos',
            Name: 'Institucional',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Institucional.rar'
        },
        /* {
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo500',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo500.rar'
        }, */
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo530',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo530.rar'
        },
        /* {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo570',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo570.rar'
        }, */
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo580',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo580.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo590',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo590.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo610',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo610.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo660',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo660.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo680',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo680.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo710',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo710.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo720',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo720.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo730',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo730.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo740',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo740.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo750',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo750.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo760',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo760.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo790',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo790.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo810',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo810.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo820',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo820.rar'
        },
        {    
            cat_label: 'Cultivares',
            cat_api: 'cultivares',
            Name: 'Neo850',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo850.rar'
        },
        {
            cat_label: 'Manual de Identidade Visual',
            cat_api: 'manual',
            Name: 'Manual de identidade visual Neogen',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/IdentidadeVisual/NeogenManualIdentidadeVisual.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Institucional',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/Institucional.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo530',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo530.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo580',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo580.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo590',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo590.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo610',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo610.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo660',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo660.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo680',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo680.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo710',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo710.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo720',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo720.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo730',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo730.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo740',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo740.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo750',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo750.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo760',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo760.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo790',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo790.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo810',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo810.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo820',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo820.pdf'
        },
        {
            cat_label: 'Placas de campo',
            cat_api: 'placas',
            Name: 'Neo850',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo850.pdf'
        },
        {
            cat_label: 'Sacaria',
            cat_api: 'sacaria',
            Name: 'Sacaria Neogen Conkesta 2021',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Sacaria/SacariaNeogenConkesta2021.pdf'
        },
        {
            cat_label: 'Sacaria',
            cat_api: 'sacaria',
            Name: 'Sacaria Neogen Intacta 2021',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Sacaria/SacariaNeogenIntacta2021.pdf'
        },
        {
            cat_label: 'Sacaria',
            cat_api: 'sacaria',
            Name: 'Sacaria Neogen Intacta I2X 2021',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Sacaria/SacariaNeogenIntactaI2X2021.pdf'
        },
        {
            cat_label: 'Sacaria',
            cat_api: 'sacaria',
            Name: 'Sacaria Neogen RR 2021',
            Link: 'https://www.neogensementes.com.br/MidiaKit2021/Sacaria/SacariaNeogenBolsaRR2021.pdf'
        }
    ];
}
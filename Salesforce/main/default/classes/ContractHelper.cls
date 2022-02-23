/**
* @name ContractHelper
* @author Jhonny Peroza
* updated 07-09-2021
*/
public class ContractHelper {

    public static Id milhoRecordType = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Macro_Milho').getRecordTypeId();

    public static void afterInsert(List<Contract> contractList) {

        List<Negocio_por_Conta__c> businessList = new List<Negocio_por_Conta__c>();
        businessList=getBusinessData(contractList); 
        updateContract(contractList, businessList); 

    }

    public static List<Negocio_por_Conta__c> getBusinessData(List<Contract> contractList) {

        List<String> businessId = new List<String>();

		for (Contract contract : contractList){
			businessId.add(contract.Negocio__c);
		}

        List<Negocio_por_Conta__c> businessList = [SELECT Id, Marca__c, Cultura__c, Region_Comercial__c, Supervidor__c, Gerenciador__c, Supervidor__r.ManagerId
                                                        FROM Negocio_por_Conta__c 
                                                            WHERE Id IN : businessId];                                     
        return businessList;
    }

    public static void updateContract(List<Contract> contractList, List<Negocio_por_Conta__c> businessList) {
    
        List<Contract> contratoList = new List<Contract>();

        for(Contract contract : contractList) {
            for(Negocio_por_Conta__c business : businessList) {
                if(business.Id == contract.Negocio__c && contract.RecordTypeId == milhoRecordType) {
                    Contract contractMap = new Contract();
                    contractMap.Id = contract.Id;
                    contractMap.Region_Comercial__c = business.Region_Comercial__c;
                    contractMap.Marca__c = business.Marca__c;
                    contractMap.Cultura__c = business.Cultura__c;
                    contractMap.Supervidor__c = business.Supervidor__c;
                    contractMap.OwnerId = business.Supervidor__c;
                    contractMap.Tipo_de_Assinatura__c = contract.Tipo_de_Assinatura__c != null ? contract.Tipo_de_Assinatura__c : 'Manual';
                    if(business.Supervidor__r.ManagerId == null) {
                        contract.addError('Verifique o campo ManagerId, aparentemente o supervisor deste negocio não possui um superior designado');
                    } else {
                        contractMap.Gerenciador__c = business.Supervidor__r.ManagerId;
                    }
                    contratoList.add(contractMap);
                }
            }
        }

        try {                       
            update contratoList;
        } catch (DmlException e) {
            System.debug('DML Error message: ' + e.getMessage());
        }
    }

    public static void generateContractPDF(Contract contract) {

        if(contract.RecordTypeId == milhoRecordType && contract.Status == 'Aguardando Asignatura') {
            if(!Test.isRunningTest()) {
                    PdfGeneratorController.generateContratoMacroDocusignPDF(contract.Id);   
            }
        }
    }

    public static void beforeUpdate (List<Contract> contractNew, Map<Id, Contract> contractOld) {
        validateContractStatus(contractNew, contractOld);
    }

    private static void validateContractStatus (List<Contract> contractNew, Map<Id, Contract> contractOld) {
        for(Contract contract : contractNew) {
            if(contract.RecordTypeId == milhoRecordType && contract.Status == 'Edição' && contract.Tipo_de_Assinatura__c != contractOld.get(contract.Id).Tipo_de_Assinatura__c) {
                contract.addError('O contrato está no estado de Edição, por favor, aguarde até que ele esteja no estado Pendente de impressão');
            }
            if(contract.RecordTypeId == milhoRecordType && contract.Status == 'Pendente de Aprovação' && contract.Tipo_de_Assinatura__c != contractOld.get(contract.Id).Tipo_de_Assinatura__c) {
                contract.addError('O contrato está no estado de Pendente de Aprovação, por favor, aguarde até que ele esteja no estado Pendente de impressão');
            }
        }
    }
}
/*
        @Author: Sergio Migueis - K2
        @Description: Apex controller for lightning (Aura and LWC) responsible for
                        Fetching and Organizing data for opportunity creation.

        @History:
        16/11/2019 - Creation.
        20/11/2019 - Method getRecordTypesAllowedUC
        26/11/2019 - Deploy from scratchorg
        02/01/2020 - Changes to order - requested by Celso
        06/01/2020 - Changes for marca with customized settings.
        08/01/2020 - Changes for account ordered by Celso.
 */
global with sharing class NewRecordController {

    /*
        @Method: getRecordTypesAllowedUC
        @Author: Sergio Migueis - K2
        @Description: Get the available record type for user profile and crosses
                        with the mapped information for the community through the
                        custom metadata.
                    The trick here is to return the intersection of the collections.
        @History:
        20/11/2019 - Creation
     */
    @AuraEnabled(cacheable=true)
    global static List<DTOUtils.RecordTypeInfo> getRecordTypesAllowedUC(String sobjectname){
        User currentUser = DAOUser.getInstance().get(UserInfo.getUserId());
        List<DTOUtils.RecordTypeInfo> retValue = new List<DTOUtils.RecordTypeInfo>();
        Map<String,Schema.RecordTypeInfo> allowedRecords;
        if(sobjectname.equals(Opportunity.sObjectType.getDescribe().getName())){
             allowedRecords = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        }else {
             allowedRecords = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByName();
        }
        System.debug(allowedRecords);
        Map<String, Schema.RecordTypeInfo> allowedRecordDeveloperName = new Map<String, Schema.RecordTypeInfo>();
        //We do this for beforehand in order to save iterations (we avoid for inside for as often as possible.)
        for(Schema.RecordTypeInfo info: allowedRecords.values()){
            allowedRecordDeveloperName.put(info.getDeveloperName(), info);
        }
        List<CommunityRecordType__mdt> communityRecords = DAOMetadata.getCommunityRecordType(sobjectname);
        for(CommunityRecordType__mdt communityRecordType : communityRecords){
            if(allowedRecordDeveloperName.containsKey(communityRecordType.RecordTypeName__c)){
                if((currentUser.ContactId != null && communityRecordType.Show_in_Community__c) || currentUser.ContactId == null){
                    retValue.add(new DTOUtils.RecordTypeInfo(
                        allowedRecordDeveloperName.get(communityRecordType.RecordTypeName__c)
                        ,communityRecordType.Description__c
                        ,communityRecordType.Order__c )
                    );
                }
            }
        }
        return retValue;
    }

    @AuraEnabled(cacheable=true)
    public static string getMarca(){
        MarcaPadrao__c marca = MarcaPadrao__c.getInstance(); //custom settings for "Marca", use profile for different communities, and different marcas
        String networkName = 'NEOG'; //If never setted hardcoded but should be setted on the line above, this is only for safe code.
        if(marca != null && marca.Name__c != null){
            networkName = marca.Name__c;
        }
        return networkName;
    }

    
    @AuraEnabled(cacheable=true)
    public static string getAccountId(){         
        User communityUser = DAOUser.getInstance().get(UserInfo.getUserId());
        return communityUser.Contact.AccountId;
    }

    @AuraEnabled(cacheable=true)
    public static string getRegion(){         
        User communityUser = DAOUser.getInstance().get(UserInfo.getUserId());
        return communityUser.Contact.Account.Region_Comercial__c;
    }

    
    @AuraEnabled(cacheable=true)
    public static Configuracion_BMX__c getConfiguration(){         
        Configuracion_BMX__c config = DAOConfiguracionBMX.getInstance().getFirst();
        return config;
    }
}
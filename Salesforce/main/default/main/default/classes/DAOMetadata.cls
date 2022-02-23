/*
        @Author: Sergio Migueis - K2
        @Description: DAO responsible for fetching metadada from the database

        @History:
        05/11/2019 - Creation.
        26/11/2019 - Deploy from scratchorg
        02/01/2020 - changes for order requested by Celso
 */
global class  DAOMetadata {
     //METADADO doesn't have sharing.
    global static List<CommunityRecordType__mdt> getCommunityRecordType(String sobjectname){
        return [
            SELECT Id
                ,DeveloperName
                ,Description__c
                ,SObjectName__c
                ,RecordTypeName__c
                ,Show_in_Community__c
                ,Order__c
            FROM CommunityRecordType__mdt
            WHERE SobjectName__c = :sobjectname
            ORDER BY Order__c
        ];
    }
}
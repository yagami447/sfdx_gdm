/*
        @Author: Sergio Migueis - K2
        @Description: Utils holding all DTO used accross all objects

        @History:
        05/11/2019 - Creation.
        20/11/2019 - Connection with backend.
        26/11/2019 - Deploy from scratchorg
 */
global class DTOUtils {
    /*
        @Authos: Sergio Migueis - K2
        @Description: Since we cannot send the Schema.RecordTypeInfo to the front, 
                        We use this DTO to transfer data to the front.
     */
    global class RecordTypeInfo{
        @AuraEnabled global String Id { get; set;}
        @AuraEnabled global String Name { get; set;}
        @AuraEnabled global String DeveloperName { get; set;}
        @AuraEnabled global String Description { get; set;}
        @AuraEnabled global Decimal Order { get; set;}

        global RecordTypeInfo(){

        }
        
        global RecordTypeInfo(Schema.RecordTypeInfo baseInfo){
            this.Id = baseInfo.getRecordTypeId();
            this.Name = baseInfo.getName();
            this.DeveloperName = baseInfo.getDeveloperName();
            this.Order = 0;
        }
        
        global RecordTypeInfo(Schema.RecordTypeInfo baseInfo, String description){
            this.Id = baseInfo.getRecordTypeId();
            this.Name = baseInfo.getName();
            this.DeveloperName = baseInfo.getDeveloperName();
            this.Description = description;
            this.Order = 0;
        }
        global RecordTypeInfo(Schema.RecordTypeInfo baseInfo, String description, Decimal order){
            this.Id = baseInfo.getRecordTypeId();
            this.Name = baseInfo.getName();
            this.DeveloperName = baseInfo.getDeveloperName();
            this.Description = description;
            this.Order = order;
        }
    }
    //Used for sharing control.
    global enum SharingMode{
        With,
        Without,
        Inherit
    }
}
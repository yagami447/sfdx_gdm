public class EstadoCRMExtension {
    @TestVisible public List<Wrapper> estados                                   {get; set;}
    @TestVisible public Map<String, Estado_Para_CRM__c> estadosAlreadySelected  {get; set;}
    @TestVisible public String toAdd                                            {get; set;}
    @TestVisible public String toRemove                                         {get; set;}
    @TestVisible public String searchString                                     {get; set;}
    @TestVisible private String resumenId;
    @TestVisible private Integer count = 0;
    @TestVisible private List<Estado_Para_CRM__c> forDeletion; 

    public EstadoCRMExtension(ApexPages.StandardController controller) {

        resumenId =  controller.getRecord().Id;   
        estadosAlreadySelected = new Map<String, Estado_Para_CRM__c>();
        forDeletion = new List<Estado_Para_CRM__c>();
        getEstadosAlreadySelected();

    }

    public void getEstadosAlreadySelected() {

        count = 0;
        List<Estado_Para_CRM__c> estadosDelCRM = [SELECT Id, Name, Estado__c, Percentagem_de_venda__c, Indice__c FROM Estado_Para_CRM__c WHERE CRM__c = :resumenId];
        for(Estado_Para_CRM__c estado : estadosDelCRM){
            estadosAlreadySelected.put(estado.Estado__c, estado);
        }
        for(Estado_Para_CRM__c item : estadosAlreadySelected.values()){
            item.Indice__c = count;
            count ++;
        }

    }

    public void getEstados() {

        estados = new List<Wrapper>();
        for(String pickListValue : getPickListValuesIntoList()) {
            Wrapper estado = new Wrapper();
            estado.Estado = pickListValue;
            estados.add(estado); 
            if(searchString != '' && searchString != null && searchString != pickListValue) {
                estados.remove(estados.size()-1);
            } 
            if(estadosAlreadySelected.containsKey(pickListValue)){
                estados.remove(estados.size()-1);
            }
        }     

    }

    public List<String> getPickListValuesIntoList(){

        List<String> pickListValuesList= new List<String>();
         Schema.DescribeFieldResult fieldResult = Estado_Para_CRM__c.Estado__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         for( Schema.PicklistEntry pickListVal : ple){
             pickListValuesList.add(pickListVal.getLabel());
         }     
         return pickListValuesList;

     }

    public PageReference addToEstadosAlreadySelected() {

        for(Wrapper estado : estados){
            if((String) estado.Estado == toAdd){
                
                Estado_Para_CRM__c newItem = New Estado_Para_CRM__c(CRM__c = resumenId,
                                                                    Estado__c = estado.Estado,
                                                                    Name = estado.Estado,
                                                                    Percentagem_de_venda__c = 0,
                                                                    Indice__c = count);
                
                estadosAlreadySelected.put(newItem.Estado__c, newItem);
                count++;
                break;
            }            
        }
        getEstados();
        return null;
    }

    public PageReference removeFromEstadosAlreadySelected() {
    
        for(Estado_Para_CRM__c estado : estadosAlreadySelected.values()){
            if(String.valueOf(estado.Indice__c) == toRemove){            
                if(estado.Id != null)
                    forDeletion.add(estado);           
                    estadosAlreadySelected.remove(estado.EStado__c);
                break;
            }
        }        
        getEstados();   
        return null;     

    }

    public PageReference save() {

        Integer totalSalePercentage = 0;
        for(Estado_Para_CRM__C estado : estadosAlreadySelected.values()){
            totalSalePercentage += Integer.valueOf(estado.Percentagem_de_venda__c);
        }
        if(totalSalePercentage != 100){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'A soma total da porcentagem de venda deve ser de 100.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        Savepoint sp;   
        sp = Database.setSavepoint();
        if(forDeletion.size()>0)
            delete(forDeletion);
        if(estadosAlreadySelected.size()>0)
            upsert(estadosAlreadySelected.values());    
        String nextlink = '/' + ApexPages.currentPage().getParameters().get('Id');
        PageReference nextPage = new PageReference(nextlink);
        nextPage.setRedirect(true);
        return nextPage;

    }

    public PageReference cancel() {

        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));

    }

    public class wrapper {
        public String Estado        {get; set;}
        public Integer Porcentaje   {get; set;}
    }
}
public class ItensResumoDaContaExtension {
    
    @TestVisible public List<Wrapper> obtentores                                        {get; set;}
    @TestVisible public String searchString                                             {get; set;}
    @TestVisible public Map<String, Item_de_Resumo_Da_Conta__C> itemsAlreadySelected    {get; set;}
    @TestVisible public String toAdd                                                    {get; set;}
    @TestVisible public String toRemove                                                 {get; set;}
    @TestVisible private String resumenId;
    @TestVisible private Integer count = 0;
    @TestVisible private List<Item_de_Resumo_Da_Conta__C> forDeletion; 

    public ItensResumoDaContaExtension(ApexPages.StandardController controller) {

        resumenId =  controller.getRecord().Id;
        this.resumenId = resumenId;       
        itemsAlreadySelected = new Map<String, Item_de_resumo_da_Conta__c>(); 
        forDeletion = new List<Item_de_Resumo_Da_Conta__C>();
        getItemsAlreadySelected();        

    }

    public void getItemsAlreadySelected() {

        count = 0;
        List<Item_De_Resumo_Da_Conta__C> itemsDelCRM = [SELECT Id, Name, Obtentor__c, Indice__c FROM Item_de_Resumo_Da_Conta__C WHERE Resumo_da_Conta__C = :resumenId];
        for(Item_De_Resumo_Da_Conta__C item : itemsDelCRM){
            itemsAlreadySelected.put(item.Obtentor__c, item);
        }
        for(Item_de_Resumo_Da_Conta__C item : itemsAlreadySelected.values()){
            item.Indice__c = count;
            count ++;
        }

    }

    public void getObtentores() {

        obtentores = new List<Wrapper>();
        for(String pickListValue : getPickListValuesIntoList()) {
            Wrapper obtentor = new Wrapper();
            obtentor.Obtentor = pickListValue;
            obtentores.add(obtentor); 
            if(searchString != '' && searchString != null && searchString != pickListValue) {
                obtentores.remove(obtentores.size()-1);
            } 
            if(itemsAlreadySelected.containsKey(pickListValue)){
                obtentores.remove(obtentores.size()-1);
            }
        }
        

    }

    public List<String> getPickListValuesIntoList(){

        List<String> pickListValuesList= new List<String>();
         Schema.DescribeFieldResult fieldResult = Item_de_Resumo_Da_Conta__C.Obtentor__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         for( Schema.PicklistEntry pickListVal : ple){
             pickListValuesList.add(pickListVal.getLabel());
         }     
         return pickListValuesList;

     }

    public PageReference addToItemsAlreadySelected() {

        for(Wrapper item : obtentores){
            if((String) item.Obtentor == toAdd){
                
                Item_de_Resumo_Da_Conta__C newItem = New Item_de_Resumo_Da_Conta__C(Resumo_da_Conta__c = resumenId,
                                                                                 Obtentor__c = item.Obtentor,
                                                                                 Name = item.Obtentor,
                                                                                 Indice__c = count);
                
                itemsAlreadySelected.put(newItem.Obtentor__c, newItem);
                count++;
                break;
            }            
        }
        getObtentores();
        return null;

    }

    public PageReference removeFromItemsAlreadySelected() {

        Integer count = 0;    
        for(Item_de_Resumo_Da_Conta__C item : itemsAlreadySelected.values()){
            if(String.valueOf(item.Indice__c) == toRemove){            
                if(item.Id != null)
                    forDeletion.add(item);           
                itemsAlreadySelected.remove(item.Obtentor__c);
                break;
            }
            count++;
        }        
        getObtentores();   
        return null;     

    }

    public PageReference save() {

        Savepoint sp;   
        sp = Database.setSavepoint();
        if(forDeletion.size()>0)
            delete(forDeletion);
        if(itemsAlreadySelected.size()>0)
            upsert(itemsAlreadySelected.values());    
        String nextlink = '/' + ApexPages.currentPage().getParameters().get('Id');
        PageReference nextPage = new PageReference(nextlink);
        nextPage.setRedirect(true);
        return nextPage;

    }

    public PageReference cancel() {

        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));

    }

    public class wrapper {
        public String Obtentor  {get; set;}
    }

}
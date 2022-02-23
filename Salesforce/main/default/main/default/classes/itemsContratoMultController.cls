public class itemsContratoMultController {

    public List<Item_del_Contrato__c> items {get; set;}  
    public List<Item_del_Contrato__c> nuevoItem {get; set;}
    public String query {get;set;}
    private Id idContrato;
    private String nombreContrato;
    private String recTypeContrato;
    private String sociedadContrato;
    private String safraContrato;
    private String accContrato;
    private Boolean comParaguai;
    public String tipoCot;
    public String Mensaje;
    private Id editItem;
    private Id eliminarItem;
    private Id saveEditItem;
    
    private String nuevoBasica;
    private String editBasica;
    public Set<Id> basicaSel = New Set<Id>();
    private List<SelectOption> prodsBasica;
    
    public void setprodsBasica (List<SelectOption> i){
        prodsBasica = i;
    }
    
    public List<SelectOption> getprodsBasica (){
        return prodsBasica;
    } 
    
    public void seteditBasica (String i){
        editBasica = i;
    }
    
    public String geteditBasica (){
        return editBasica;
    }
    
    public void setnuevoBasica (String i){
        nuevoBasica = i;
    }
    
    public String getnuevoBasica (){
        return nuevoBasica;
    } 
    
    public void setsociedadContrato (String i){
        sociedadContrato = i;
    }
    
    public String getsociedadContrato (){
        return sociedadContrato;
    }  
    
    public void setnombreContrato (String i){
        nombreContrato = i;
    }
    
    public String getnombreContrato (){
        return nombreContrato;
    }
    
    public void setrecTypeContrato (String i){
        recTypeContrato = i;
    }
    
    public String getrecTypeContrato (){
        return recTypeContrato;
    }
    
    public void setsaveEditItem (Id i){
        saveEditItem = i;
    }
    
    public Id getsaveEditItem (){
        return saveEditItem;
    }
    
    public void setidContrato (Id i){
        idContrato = i;
    }
    
    public Id getidContrato (){
        return idContrato;
    } 
    
    public void seteditItem (Id i){
        editItem = i;
    }
    
    public Id geteditItem (){
        return editItem;
    } 
    
    public void seteliminarItem (Id i){
        eliminarItem = i;
    }
    
    public Id geteliminarItem (){
        return eliminarItem;
    } 
        Public String getMensaje() {
       return Mensaje;      
    }

    Public void setMensaje(String arg) {
       Mensaje=arg;      
    }         
    
    public List<SelectOption> getProductosBasica() {
        Set<String> contrat = New Set<String>();
        List<Product2> prods = New List<Product2>();
        
        for(Item_del_Contrato__c i: [SELECT Cultivar__r.Id FROM Item_del_Contrato__c WHERE Contrato_de_Multiplicacion__r.Sociedad__c =: sociedadContrato AND Contrato_de_Multiplicacion__r.Safra__c = :safraContrato AND Contrato_de_Multiplicacion__r.RecordType.Name = :sociedadContrato AND Contrato_de_Multiplicacion__r.Multiplicador__c =: accContrato]) 
            contrat.add(i.Cultivar__r.Id);
        
       List<SelectOption> lista = new List<SelectOption>();
       
       String qString = 'Select Id, Name, Variedad__c, Variedade__c, Variedade__r.Name From Product2 Where Categ__r.Name = \'BASICA\' And Variedade__c != null And isActive = true And Family = \'Royalty x Basica\' AND Tipo_de_Cota_o_Contrato__c = \'' + tipoCot + '\'';
       if(comParaguai){
        qString+='  AND Variedade__r.Comercializa_Paraguai__c = :comParaguai ';
       }
       if(Userinfo.getUserRoleId() == '00E40000001C6eWEAS'){
        qString+=' and licenciada__c = true ';
       }
       if(contrat.Size() > 0 && (recTypeContrato == 'Aditivo BRMX' || recTypeContrato == 'Aditivo DSEM' || recTypeContrato == 'Aditivo % DSEM' || recTypeContrato == 'Aditivo % BRMX')){
        qString+= ' and Id In :contrat ';
       }
       qString+= ' Order By Variedade__r.Name ';
        
        system.debug('qString:' +qString);
        query = qString;
        prods = database.query(qString);
       
        for (Product2 p : prods)                               
           lista.add(new SelectOption(p.Id,p.Variedade__r.Name));             
                                           
       return lista;
    }
        
    public void init(){
    
        
        tipoCot = 'SOJA';
        idContrato = ApexPages.currentPage().getParameters().get('id');
        nombreContrato = ApexPages.currentPage().getParameters().get('nombre');
        sociedadContrato = ApexPages.currentPage().getParameters().get('sociedad');
        Contrato__c c = [SELECT Id, RecordType.Name, Safra__c, Multiplicador__c, Tipo_de_Cota_o__c, Comercializa_Paraguai__c, Multiplicador__r.Region__r.Region_Comercial__c, Region_Comercial__c FROM Contrato__c WHERE Id =: idContrato];
        safraContrato = c.Safra__c;
        accContrato = c.Multiplicador__c;
        recTypeContrato = c.RecordType.Name;
        tipoCot = c.Tipo_de_Cota_o__c;
        comParaguai = c.Comercializa_Paraguai__c;
        c.Region_Comercial__c = c.Multiplicador__r.Region__r.Region_Comercial__c;
        update c;

        items = New List <Item_del_Contrato__c>();
        items = [Select Id, Precio__c, Cultivar__c, Tipo_de_Cotizacion__c, Variedade__c, Categoria__c, Quantidade__c, Porcentaje__c, Contrato_de_Multiplicacion__r.Safra__c, Contrato_de_Multiplicacion__r.Multiplicador__c, Incidencia_para_Votar__c From Item_del_Contrato__c Where Contrato_de_Multiplicacion__c = : idContrato];
            try{
        for(Item_del_Contrato__c it: items) basicaSel.add(it.Cultivar__c);
        nuevoitem = New List<Item_del_Contrato__c>();
        Item_del_Contrato__c i = New Item_del_Contrato__c();
        this.nuevoItem.add(i);

        }catch (Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()); 
            ApexPages.addMessage(msg);  
                                
        } 
                
    }
    
    public PageReference editarItem(){
        editItem = ApexPages.currentPage().getParameters().get('edit_item');
        
        if (editItem != null)
            for (Item_del_Contrato__c i : items)
                if (i.Id == editItem)   
                    editBasica = i.Cultivar__c;
        
        return null;    
    }
    
    public PageReference cancelEditarItem(){
        editItem = null;                
        saveEditItem = null;
        nuevobasica = null;
        editBasica = null;
        
        return null;    
    }
    
    public PageReference addItem(){
        
        try{
            //if((recTypeContrato == 'Aditivo BRMX' || recTypeContrato == 'Aditivo DSEM') && (this.nuevoItem[0].Categoria__c == null || this.nuevoItem[0].Quantidade__c == 0)){
            if((recTypeContrato == 'Aditivo BRMX' || recTypeContrato == 'Aditivo DSEM') && this.nuevoItem[0].Quantidade__c == 0){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Deve ingressar a quantidade'); 
                ApexPages.addMessage(msg);  
                return null;
            }
            this.nuevoItem[0].Contrato_de_Multiplicacion__c = idContrato;
            this.nuevoItem[0].Cultivar__c = nuevoBasica;
            Product2 p = [Select Id, Name From Product2 Where Id = : nuevoBasica];
            this.nuevoItem[0].Name = p.Name;
            insert nuevoItem;
        
            this.nuevoitem.clear();
            Item_del_Contrato__c i = New Item_del_Contrato__c();
            this.nuevoItem.add(i);
            
            editItem = null;
            saveEditItem = null;
            nuevobasica = null;
            editBasica = null;
        
            PageReference pr = new PageReference('/apex/Items_Contrato_Multiplicacion');
            pr.getParameters().put('id',idContrato);
            pr.getParameters().put('nombre',nombreContrato);
            return pr;
            
        }catch (Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()); 
            ApexPages.addMessage(msg);  
            return null;                    
        }                       
        
    }
    
    public PageReference eliminarItem(){        
        eliminarItem = ApexPages.currentPage().getParameters().get('eliminar_item');
        if (eliminarItem != null){
            Item_del_Contrato__c eliminar = [Select Id From Item_del_Contrato__c Where Id = : eliminarItem];
            delete eliminar;
        }    
        
        PageReference pr = new PageReference('/apex/Items_Contrato_Multiplicacion');
        pr.getParameters().put('id',idContrato);
        pr.getParameters().put('nombre',nombreContrato);
        return pr;
            
    }
    
    public PageReference saveEditItem(){        
        
        try{
        
            saveEditItem = ApexPages.currentPage().getParameters().get('save_edit_item');
            if (saveEditItem != null){
                for (Item_del_Contrato__c i : items){
                    if (i.Id == saveEditItem){
                        i.Cultivar__c = editBasica;
                        Product2 p = [Select Id, Name From Product2 Where Id = : editBasica];
                        i.Name = p.Name;   
                    }       
                }   
                update items;
            }       
                        
            editItem = null;
            saveEditItem = null;
            nuevobasica = null;
            editBasica = null;
            
            PageReference pr = new PageReference('/apex/Items_Contrato_Multiplicacion');
            pr.getParameters().put('id',idContrato);
            pr.getParameters().put('nombre',nombreContrato);
            return pr;
            
        }catch (Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
    }
    
    public PageReference volver(){
    
        PageReference pr = new PageReference('/' + String.valueOf(idContrato));     
        return pr;  
        
    }

}
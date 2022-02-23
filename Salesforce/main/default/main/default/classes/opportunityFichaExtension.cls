public with sharing class opportunityFichaExtension{
    
    private List<Opportunity> oppz;
    public Account cuenta {get; set;} 
    public Boolean sbx {get; set;}
    
    public String IdView = '00B40000005PjLu'; //Recientes
    public String marca = '';
    public opportunityFichaExtension(ApexPages.StandardController controller){
        //this.cuenta= (Account)controller.getRecord();
        String idAcc = ApexPages.currentPage().getParameters().get('id');
        this.cuenta = [Select Id, Name From Account Where Id = : idAcc];
        sbx = [Select id, isSandbox From Organization].isSandbox;
    }
    
    public opportunityFichaExtension(){
        
    }
    
    public class archivosYNotas{
        public String id { get; set; }
        public String tipo { get; set; }
        public String titulo { get; set; }
        public String ultimaModif { get; set; }
        public String creadoPor { get; set; }
        public String creadoPorId { get; set; }
    }
    
    public List<Opportunity> getOppz()
    {
        marca = '';
        if(UserInfo.getProfileId() == '00e40000000yyv4AAA' || UserInfo.getProfileId() == '00e40000000yysjAAA'){ //Perfiles DSEM
            marca = 'DSEM';
        }else{
            if(UserInfo.getProfileId() == '00e40000000yyIOAAY' || UserInfo.getProfileId() == '00e40000000yyHBAAY' || UserInfo.getProfileId() == '00e40000000yyHBAAY'){ //Perfiles BRMX
                marca = 'BRMX';
            }
        }
        if(marca == ''){
            oppz = [Select Id, Name, Account.Name, CloseDate, StageName, Safra__c, RecordType.Name from Opportunity where Account.id = :this.cuenta.Id AND (RecordType.Name != 'Stock Multipplicadores' OR (RecordType.Name = 'Stock Multiplicadores' AND StageName != 'Fechada')) Order By CreatedDate Desc Limit 150];
        }else{
            oppz = [Select Id, Name, Account.Name, CloseDate, StageName, Safra__c, RecordType.Name from Opportunity where Account.id = :this.cuenta.Id AND Marca__c = :marca AND (RecordType.Name != 'Stock Multipplicadores' OR (RecordType.Name = 'Stock Multiplicadores' AND StageName != 'Fechada')) Order By CreatedDate Desc Limit 150];
        }
        return oppz;
    }
    
    public List<Contrato__c> getContratos(){
        return [Select Id, Name, Observacao__c, RecordType.Name, Safra__c, Tipo_de_Cota_o__c, Cotacao_de_soja__c, Tipo_de_cambio__c, Aditivo_Facturado__c, Sociedad__c, Estado__c From Contrato__c Where Multiplicador__c = :this.cuenta.Id Order By CreatedDate desc];
    }
    
    public List<archivosYNotas> getArchivosYNotas(){
        
        List<archivosYNotas> ret = New List<archivosYNotas>();
        for (Attachment a : [Select Id, Name, LastModifiedDate, CreatedById, CreatedBy.Name From Attachment Where ParentId = : this.cuenta.Id Order By LastModifiedDate desc]){
            archivosYNotas a2 = New archivosYNotas();
            a2.id = a.Id;
            a2.tipo = 'Anexo';
            a2.titulo = a.Name;
            String dia = String.valueOf(a.LastModifiedDate.day());
            String mes = String.valueOf(a.LastModifiedDate.month());
            String hora = String.valueOf(a.LastModifiedDate.hour());
            String minutos = String.valueOf(a.LastModifiedDate.minute());
            if (Integer.valueOf(dia) < 10)
                dia = '0' + dia;            
            if (Integer.valueOf(mes) < 10)
                mes = '0' + mes;
            if (Integer.valueOf(hora) < 10)
                hora = '0' + hora;
            if (Integer.valueOf(minutos) < 10)
                minutos = '0' + minutos;            
            a2.ultimaModif = dia + '/' + mes + '/' + a.LastModifiedDate.year() + ' ' + hora + ':' + minutos;
            a2.creadoPor = a.CreatedBy.Name; 
            a2.creadoPorId = a.CreatedById;
            ret.add(a2);    
        }    
        
        for (Note n : [Select Id, Title, LastModifiedDate, CreatedBy.Name From Note Where ParentId = : this.cuenta.Id Order By LastModifiedDate desc]){
            archivosYNotas a2 = New archivosYNotas();
            a2.id = n.Id;
            a2.tipo = 'Nota';
            a2.titulo = n.Title;
            String dia = String.valueOf(n.LastModifiedDate.day());
            String mes = String.valueOf(n.LastModifiedDate.month());
            String hora = String.valueOf(n.LastModifiedDate.hour());
            String minutos = String.valueOf(n.LastModifiedDate.minute());
            if (Integer.valueOf(dia) < 10)
                dia = '0' + dia;            
            if (Integer.valueOf(mes) < 10)
                mes = '0' + mes;
            if (Integer.valueOf(hora) < 10)
                hora = '0' + hora;
            if (Integer.valueOf(minutos) < 10)
                minutos = '0' + minutos;
            a2.ultimaModif = dia + '/' + mes + '/' + n.LastModifiedDate.year() + ' ' + hora + ':' + minutos;
            a2.creadoPor = n.CreatedBy.Name; 
            a2.creadoPorId = n.CreatedById;
            ret.add(a2);
        }                   
        
        return ret;     
    }
    
    public PageReference nuevaNota (){
        PageReference pr = New PageReference('/002/e');
        pr.getParameters().put('parentId', String.valueOf(this.cuenta.Id));
        pr.getParameters().put('retURL', String.valueOf(this.cuenta.Id));
        return pr.setRedirect(true);
    }
 
    public PageReference crearOpp (){
        return Page.nueva_opp;
    }
    
    public PageReference ListadoOpp(){
        PageReference pr = System.currentPageReference();//new PageReference('/006/e');
        pr.getParameters().put('Id', String.valueOf(this.cuenta.Id));
        pr.getParameters().put('rlid', 'RelatedOpportunityList');
        pr.getParameters().put('nooverride', '1');      
        return pr.setRedirect(true);
    }         
   
    public Boolean getShowShortTable(){
        Boolean resultado = false;
        User usuario = [Select Id, Email From User Where Id =: UserInfo.getUserId() limit 1];
        if(usuario != null){
            resultado =   usuario.Email.contains('pueno@gdmseeds.com');        
        }            
        return resultado;
    }
}
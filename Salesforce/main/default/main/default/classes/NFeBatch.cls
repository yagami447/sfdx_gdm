global class NFeBatch implements Database.Batchable<String> , Database.Stateful,  Database.AllowsCallouts{
	String Resultados;
    String name;
    Document d;
    
    public NFeBatch(Document d){
        this.d = d;
    }
    
    global Iterable<String>	 start(Database.BatchableContext BC){
        List<String> strings = d.body.toString().split('\n');
        System.debug(strings);
        Resultados = 'Id, Clave, Resultado\n';
        
        return strings;
    }
    	
    global void execute(Database.BatchableContext BC, List<String> scope){
        for (String s : scope) {      
            s = s.trim().replace('\n', '');
            try {
                String NFe = NotaFiscalElectronicaController.searchNFe(s, false);
                if (!NFe.contains('Existe') && !NFe.contains('CodeError')) {
                    Id i = NotaFiscalElectronicaController.saveOpportunity(NFe);
                    if (i != null) Resultados += i+','+s+', Ok\n';
                } else {
                    Resultados += ','+s+','+NFe+'\n';
                }
                
            } catch (Exception ex) {
                Resultados += ' ,'+s+', '+ex.getMessage().replace('\n','')+'\n';
            }
            
        }

    }
    
    global void finish(Database.BatchableContext BC){
        
        ContentVersion contentVersion_1 = new ContentVersion(
            Title = 'Resultados de Nota Fiscal',
            PathOnClient = 'Resultados de Nota Fiscal'+'.csv',
            VersionData = Blob.valueOf(resultados),
            IsMajorVersion = false 
        );
        insert contentVersion_1;
    }
    
}
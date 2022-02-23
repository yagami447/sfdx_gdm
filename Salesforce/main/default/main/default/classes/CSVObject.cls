public class CSVObject  {

    @AuraEnabled
    public List<CSVHeader> headers {get; set;}

    @AuraEnabled
    public List<List<String>> lines {get; set;}

    @AuraEnabled
    public Integer line_count {get; set;}

    public CSVObject() {}

    public CSVObject(List<CSVHeader> headers, List<List<String>> lines) {
        this.headers = headers;
        this.lines = lines;
        this.line_count = lines.size();
        
        this.headers.add(new CSVHeader('Conta'));
        this.headers.add(new CSVHeader('Variedade'));
        
        Map<String,Account> accs = New Map<String,Account>();
        for(Account a : [Select Id, Name From Account])
            accs.put(a.Id, a);
            
        Map<String,PricebookEntry> pbes = New Map<String,PricebookEntry>();
        for(PricebookEntry p : [Select Id, Product2.Variedade__r.Name From PricebookEntry Where Pricebook2.Name = 'Lista Canal Multiplicadores' And Product2.Categ__r.Name = 'BASICA' And Product2.Family = 'Royalty x Basica'])
            pbes.put(p.Product2.Variedade__c, p);    
        
        for(List<String> s1 : this.lines){
            if (accs.containsKey(s1[0])){
                s1.add(accs.get(s1[0]).Name);
                }else{
                    s1.add('');
            }
            if (pbes.containsKey(s1[1])){
                s1.add(pbes.get(s1[1]).Product2.Variedade__r.Name);
                }else{
                    s1.add('');
            }
        }
        
    }

}
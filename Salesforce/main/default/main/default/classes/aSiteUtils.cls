public class aSiteUtils {
    
    public aSiteUtils() {
    }
    
    public class retorno {
        public String id { get; set; }
        public String mensaje { get; set; }
        public Boolean exito { get; set; }
    }
    
    public static String procesarAlerta(String msg){
        return '<div class="alert alert-danger errors">' + msg + '</div>';
    }
    
    public static List<String> getDatosCombo(String entity, String field){
      List<String> ret = New List<String>();              
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(entity);
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult fieldInfo = describeResult.fields.getMap().get(field).getDescribe();
        List<Schema.PickListEntry> p_f = fieldInfo.getPickListValues();
        for(Schema.PickListEntry p : p_f){
            String descrip = p.getvalue();
            ret.add(descrip);
        }
      
      return ret;
      
    }
    
    public static Integer getNumberOfMonth(String mes){
        if (mes == 'Janeiro')
            return 1;
        if (mes == 'Fevereiro')
            return 2;
        if (mes == 'Março')
            return 3;
        if (mes == 'Abril')
            return 4;
        if (mes == 'Maio')
            return 5;
        if (mes == 'Junho')
            return 6;
        if (mes == 'Julho')
            return 7;
        if (mes == 'Agosto')
            return 8;
        if (mes == 'Setembro')
            return 9;
        if (mes == 'Outubro')
            return 10;
        if (mes == 'Novembro')
            return 11;
        if (mes == 'Dezembro')
            return 12;
      
        return null;
      
    }
    
    public static String getMonthOfNumber(Integer i){
        if (i == 1)
            return 'Janeiro';
        if (i == 2)
            return 'Fevereiro';
        if (i == 3)
            return 'Março';
        if (i == 4)
            return 'Abril';
        if (i == 5)
            return 'Maio';
        if (i == 6)
            return 'Junho';
        if (i == 7)
            return 'Julho';
        if (i == 8)
            return 'Agosto';
        if (i == 9)
            return 'Setembro';
        if (i == 10)
            return 'Outubro';
        if (i == 11)
            return 'Novembro';
        if (i == 12)
            return 'Dezembro';
      
        return null;
      
    }
        
    public static String querySelect(SObjectType entity){
        return 'select ' + string.join(new list<string>(entity.getdescribe().fields.getmap().keyset()),',');
    }   
    public static String queryFromSObject(SObjectType entity, String plus) {
        String extra = (plus != null) ? ', ' + plus : '';        
        return querySelect(entity) + extra + ' from ' + string.valueof(entity);
    }
    public static SObject[] queryResults1(SObjectType entity, String queryPlus, String fn1, Object v1) {
        return Database.query(queryFromSObject(entity,queryPlus)+' where ' + fn1 + ' Order By Name');
    }
    public static SObject[] queryResults2(SObjectType entity, String queryPlus, String fn1, Object v1, String fn2, Object v2) {
        return Database.query(queryFromSObject(entity,queryPlus)+' where '+ fn1 + ' and ' + fn2 + ' Order By Name');
    }
    public static SObject[] queryResults3(SObjectType entity, String queryPlus, String fn1, Object v1, String fn2, Object v2, String fn3, Object v3){
        return Database.query(queryFromSObject(entity,queryPlus)+' where ' + fn1 + ' and ' + fn2 + ' and ' + fn3 + ' Order By Name');
    }
    public static SObject[] queryResults4(SObjectType entity, String queryPlus, String fn1, Object v1, String fn2, Object v2, String fn3, Object v3, String fn4, Object v4){
        return Database.query(queryFromSObject(entity,queryPlus)+' where ' + fn1 + ' and ' + fn2 + ' and ' + fn3 + ' and ' + fn4 + ' Order By Name');
    }
    public static SObject[] queryResults5(SObjectType entity, String queryPlus, String fn1, Object v1, String fn2, Object v2, String fn3, Object v3, String fn4, Object v4, String fn5, Object v5){
        return Database.query(queryFromSObject(entity,queryPlus)+' where ' + fn1 + ' and ' + fn2 + ' and ' + fn3 + ' and ' + fn4 + ' and ' + fn5 + ' Order By CreatedDate desc');
    }
    public static SObject[] queryResults6(SObjectType entity, String queryPlus, String fn1, Object v1, String fn2, Object v2, String fn3, Object v3, String fn4, Object v4, String fn5, Object v5, String fn6, Object v6){
        return Database.query(queryFromSObject(entity,queryPlus)+' where ' + fn1 + ' and ' + fn2 + ' and ' + fn3 + ' and ' + fn4 + ' and ' + fn5 + ' and ' + fn6 + ' Order By Name');
    }

    //USO: queryResults(Account.SObjectType, 'CreatedDate < :v1', DateTime.Now(), 'Name IN :v2', new String[] { 'Acme' });    
}
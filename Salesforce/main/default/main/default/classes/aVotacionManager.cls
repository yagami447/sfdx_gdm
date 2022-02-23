public class aVotacionManager {
    
    public aVotacionManager(){}
    
    public static String getSafraActualVotacion(){
      try{
        List<Configuracion_BMX__c> conf = aSiteUtils.queryResults1(Configuracion_BMX__c.SObjectType, null, 'Id != :v1', null);
            return conf[0].PV_Safra_Actual__c;          
          
        return null;
      }
        catch(Exception e){
            return null;
        }
    }
    
    public static Integer getNroVuelta(String region){
        try{                                    
            List<Configuracion_BMX__c> conf = aSiteUtils.queryResults1(Configuracion_BMX__c.SObjectType, null , 'Id != :v1', null);
            if (region == 'SUL')
                return Integer.valueOf(conf[0].Votacion_nro_de_vuelta__c);
            if (region == 'CERRADO')
                return Integer.valueOf(conf[0].Votacion_Cerrado_Nro_de_vuelta__c);    
                
            return 1;
        }
        catch(Exception e){
            return null;
        }       
    }
    
    public static Boolean getHabilitadoVotacion(String region){
        try{    
            List<Configuracion_BMX__c> conf = aSiteUtils.queryResults1(Configuracion_BMX__c.SObjectType, null , 'Id != :v1', null);         
            Date fecha;
            if (region == 'SUL')
                fecha = conf[0].Votaci_n_fecha_hasta__c;
            if (region == 'CERRADO')
                fecha = conf[0].Votacion_cerrado_fecha_hasta__c;
                
            if (system.today() > fecha)
                return false;                                   
                
            return true;
        }
        catch(Exception e){
            return null;
        }       
    }
    
    public static List<Item_del_Contrato__c> getVariedadesHabilitadas(Id accId, String safra){
        try{                                    
            String queryPlus = 'Cultivar__r.Variedade__r.Name';
            List<String> contratos = New List<String>();
            contratos.add('Termo_Aditivo');
            contratos.add('Termo_Aditivo_Lan_amentos');
            
            return aSiteUtils.queryResults6(Item_del_Contrato__c.SObjectType, queryPlus ,'Contrato_de_Multiplicacion__r.Multiplicador__c = :v1', accId, 'Contrato_de_Multiplicacion__r.Safra__c = :v2', safra, 'Contrato_de_Multiplicacion__r.RecordType.DeveloperName In :v3', contratos, 'Contrato_de_Multiplicacion__r.Sociedad__c = :v4', 'DSEM', 'Contrato_de_Multiplicacion__r.Estado__c = :v5', 'Chegou', 'RecordType.Name = :v6', 'Volumen');               
        }
        catch(Exception e){
            return null;
        }       
    }
    
    public static List<Votacion_balotage__c> getVariedadesBalotage(String safra, String region){
        try{                                                
            return aSiteUtils.queryResults1(Votacion_balotage__c.SObjectType, null ,'Region_Comercial__c = :v1', region);                           
        }
        catch(Exception e){
            return null;
        }       
    }
    
    public static String getRegionCuenta(Id accId){
        try{                                    
            List<Account> acc = aSiteUtils.queryResults1(Account.SObjectType, null ,'Id = :v1', accId);
            if (acc[0].Region_Comercial__c == 'REGION 1' || acc[0].Region_Comercial__c == 'REGION 2')
                return 'SUL';
            if (acc[0].Region_Comercial__c == 'CERRADO')
                return 'CERRADO';
                
            return null;    
        }
        catch(Exception e){
            return null;
        }       
    }
    
    public static List<AggregateResult> getVotacionVariedad(String idProducto, String safra, String region, Integer vuelta){
        try{            
            return [Select Sum(Incidencia_para_Votar__c) porc, Valor_Copia__c valor From Votacion__c Where Producto__c = :idProducto And Safra__c = :safra And Region_Comercial__c = :region And Vuelta__c = :vuelta Group By Valor_Copia__c];
        }
        catch(Exception e){
            return null;
        }  
    }
    
    public static List<Votacion__c> getVotacionesByAccount(String accId, String safra, String region, Integer vuelta){
        try{            
            return [Select Variedad__c, Valor__c From Votacion__c Where Cuenta__c = :accId And Safra__c = :safra And Region_Comercial__c = :region And Vuelta__c = :vuelta];            
        }
        catch(Exception e){
            return null;
        }  
    }
    
    public static String valDatos(String idProducto, String valor){
        
        String valDatosOblig = '';
        if (idProducto == '--Nenhuma--' || valor == null || valor == '')
            valDatosOblig = 'Dados obligatorios: Cultivar - Preço.';
        
        if (valDatosOblig != '')
            return valDatosOblig;
            
        String valDatosValidos = '';
        if (!Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', valor))
            valDatosValidos = 'Inseriu um preço não valido. Por favor utilizar ponto como separador de casas decimais.';                
        
        if (valDatosValidos != '')
            return valDatosValidos;   
            
        return '';     
        
    }
    
    public static Boolean yaVoto(Id accId, String idProducto, String safra, Integer vuelta){
        
        try{
            List<Votacion__c> v = New List<Votacion__c>(); 
            v = aSiteUtils.queryResults4(Votacion__c.SObjectType, null ,'Cuenta__c = :v1', accId, 'Producto__c = :v2', idProducto, 'Safra__c = :v3', safra, 'Vuelta__c = :v4', vuelta);
            if (v.size() > 0)
                return true;
        }
        catch(Exception e){
            return null;
        }
            
        return false;
    }
    
    public static aSiteUtils.retorno votar(Id accId, String idProducto, String valor, String safra, String region, Integer vuelta){
        Savepoint sp = Database.setSavepoint(); 
        aSiteUtils.retorno ret = New aSiteUtils.retorno(); 
        Votacion__c votacion = New Votacion__c();
        
        try{  
            String msg = valDatos(idProducto, valor); 
            if(msg!=''){                  
                ret.mensaje = msg;
                ret.exito = false;
                ret.id = null;
                return ret;
            }
            
            if (yaVoto(accId, idProducto, safra, vuelta)){
                ret.mensaje = 'A votação já foi feita para esta variedade.';
                ret.exito = false;
                ret.id = null;
                return ret;
            }
            
            List<String> contratos = New List<String>();
            contratos.add('Termo_Aditivo');
            contratos.add('Termo_Aditivo_Lan_amentos');
            
            List<Configuracion_BMX__c> conf = aSiteUtils.queryResults1(Configuracion_BMX__c.SObjectType, null ,'Id != :v1', null);
            Decimal incidenciaDM = 40;
            Decimal incidenciaMult = 60;
            
            if (conf[0].Incidencia_DM_para_Votar__c != null)
                incidenciaDM = conf[0].Incidencia_DM_para_Votar__c;
                
            if (conf[0].Incidencia_Mult_para_Votar__c != null)
                incidenciaMult = conf[0].Incidencia_Mult_para_Votar__c; 
            
            List<String> regiones = New List<String>();
            if (region == 'SUL'){
                regiones.add('REGION 1');
                regiones.add('REGION 2');
            }   
            if (region == 'CERRADO')
                regiones.add('CERRADO');                
            
            Decimal incidencia = 0;
            if (accId == '0014000000oTy8R' || accId == '0011800000EQLSG' || accId == '0011800000bhtI0' || accId == '0010b00002GZyA9'){
                incidencia = incidenciaDM;
            }else{
                AggregateResult ar = [Select Sum(Volumen_Aut_Comercializacion__c) total From Item_del_Contrato__c Where Cultivar__c = :idProducto And Contrato_de_Multiplicacion__r.Safra__c = :safra And Contrato_de_Multiplicacion__r.Region_Comercial__c In :regiones And Contrato_de_Multiplicacion__r.RecordType.DeveloperName In :contratos And Contrato_de_Multiplicacion__r.Estado__c = 'Chegou' And RecordType.Name = 'Volumen' And (Not (Contrato_de_Multiplicacion__r.Multiplicador__r.Name Like :'ACME'))];
                AggregateResult ar2 = [Select Sum(Volumen_Aut_Comercializacion__c) total From Item_del_Contrato__c Where Cultivar__c = :idProducto And Contrato_de_Multiplicacion__r.Safra__c = :safra And Contrato_de_Multiplicacion__r.Region_Comercial__c In :regiones And Contrato_de_Multiplicacion__r.RecordType.DeveloperName In :contratos And Contrato_de_Multiplicacion__r.Estado__c = 'Chegou' And RecordType.Name = 'Volumen' And Contrato_de_Multiplicacion__r.Multiplicador__c = :accId];
                Double totalProd = Double.valueOf(ar.get('total'));
                Double totalProdMult = Double.valueOf(ar2.get('total'));
                
                AggregateResult ar3 = [Select Sum(Incidencia_para_Votar__c) total From Votacion__c Where Producto__c = :idProducto And Safra__c = :safra And Region_Comercial__c = :region And Vuelta__c =: vuelta];
                Double totalPorc = Double.valueOf(ar3.get('total'));
                if (totalPorc == null)
                    totalPorc = 0;
                                
                incidencia = Double.valueOf((totalProdMult * 100 / totalProd * (incidenciaMult / 100)).divide(1, 2, System.RoundingMode.HALF_EVEN));
                
                if (totalPorc + incidencia > 100)
                    incidencia = 100 - totalPorc;                               
            }
            
            votacion.Cuenta__c = accId;
            votacion.Producto__c = idProducto;
            votacion.Safra__c = safra;
            votacion.Valor__c = Double.valueOf(valor);
            votacion.Incidencia_para_Votar__c = incidencia;
            votacion.Variable__c = 'Precio';
            votacion.Region_Comercial__c = region;
            votacion.Vuelta__c = vuelta;
            votacion.Control_Voto_Duplicado__c = safra + accId + idProducto + region + vuelta;
            
            insert votacion;
            
            ret.mensaje = null;
            ret.exito = true;
            ret.id = votacion.Id;
            return ret;
            
        }
        catch(Exception e){
            return null;
        }
    }
    
}
global class Acc_SAP_Alta {

    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        Webservice String cliente;
    }    
    static Account Acc(Id accId){
        try{
            return [Select Id, Grupo_de_Cuentas__c,
            Phone, Fax, CNPJ_CPF__c, CNPJ_CPF_Solo_Numeros__c, Parent.CNPJ_CPF__c,
            Calle__c, Numero__c, Region_SAP__c, Name, Barrio__c,
            PoblacionSAP__c, Codigo_Postal_SAP__c, esta_en_Sap__c, Categoria_CFOP__c,
            Cod_Juros__c, Formas_de_pagamento__c, Contribuinte_ICMS__c, RecordTypeId 
            From Account Where Id = :accId];
        }
        catch(Exception e){
            return null;
        }       
    }    
      
    WebService Static Retorno enviarCtaSAP(Id accId, Integer target){
        Retorno r = new Retorno(); Retorno r1 = new Retorno(); Retorno r2 = new Retorno();
        r.msg = '';
        r.ret = true;

        try{            
            Account a = Acc(accId);
            r.ret = true;
            r1 = altaCtaSAP(a, null, target);
            if(r1.ret){
                r.cliente = r1.cliente;
                r.msg = r1.msg;
            }
            else{                  
                r.msg += '\nNo ha podido ser actualizada en SAP\n' + r1.msg; r.ret = false;
            }
        }
        catch(Exception e){
            r.msg = '\nEn EnviarCtaSAP - Error: ' + e.getMessage(); r.ret = false;
        }
        return r;
    }
    
    Static Retorno altaCtaSAP(Account a, Contact contacto, Integer target){
        Retorno r = new Retorno();
        sapAltaCliente.Z_SD_ALTA_CLIENTEResponse_element resultado; 
        sapAltaCliente.TABLE_OF_BAPIRET2 EtReturn = new sapAltaCliente.TABLE_OF_BAPIRET2();
        String debuger = '';
        r.ret = true;
        r.msg = '\n';
        
        String sociedad = '01BR';
        
        String correo = ' ';
                    
        debuger = 'solo contacto';
        
        sapAltaCliente.Z_SD_ALTA_CLIENTE soap = new sapAltaCliente.Z_SD_ALTA_CLIENTE();           
        sapAltaCliente.ZSSD_IN_CLIE_GRAL ICliente = new sapAltaCliente.ZSSD_IN_CLIE_GRAL();           
        sapAltaCliente.TABLE_OF_ZSSD_IN_CLIE_CFIS TCategorias = new sapAltaCliente.TABLE_OF_ZSSD_IN_CLIE_CFIS();
        TCategorias.item = new List<sapAltaCliente.ZSSD_IN_CLIE_CFIS>();                   
        sapAltaCliente.TABLE_OF_ZSSD_IN_CLIE_IMPTO TDatos = new sapAltaCliente.TABLE_OF_ZSSD_IN_CLIE_IMPTO();
        TDatos.item = new List<sapAltaCliente.ZSSD_IN_CLIE_IMPTO>();
        String ampVentas = 'X';
        String ampSociedad = '';
            
        try{                        
            ICliente.ACREEDOR = '';                 
            ICliente.CANAL_DIST = '01';
            ICliente.CLIENTE_SAP = '';
                         
            ICliente.CLIENTE_SF = a.Id;
            
            String nombre = a.Name;
            if(nombre.length() > 20)
                ICliente.CONC_BUSQUEDA = nombre.substring(0,20);
            else
                ICliente.CONC_BUSQUEDA = nombre;
                         
            ICliente.COND_EXPEDICION = '05';
            
            ICliente.CUENTA_ASOCIADA = '0012100001';
            ICliente.GRUPO_CLIENTES = '01';
            ICliente.GRUPO_TESORERIA = 'E2';
            
            ICliente.GRUPO_CTAS = 'CUST';
            
            if(a.Grupo_de_Cuentas__c.substring(0,4) == 'CPFI'){
                ICliente.NRO_IIBB = a.CNPJ_CPF_Solo_Numeros__c;                
                ICliente.TP_CLIENTE = 'PF BRASIL';
                ICliente.PERS_FIS = '1';
            }
            
            if(a.Grupo_de_Cuentas__c.substring(0,4) == 'CPJU'){
                ICliente.NIF = a.CNPJ_CPF_Solo_Numeros__c;                
                ICliente.TP_CLIENTE = 'PJ BRASIL';
                ICliente.PERS_FIS = '2';
            }     
            
            if (a.Cod_Juros__c != null)
                ICliente.VZSKZ = a.Cod_Juros__c.substring(0,2);     
                
            if (a.Formas_de_pagamento__c != null)
                ICliente.ZWELS = a.Formas_de_pagamento__c.substring(0,1);         
                
            if (a.Contribuinte_ICMS__c != null)
                ICliente.ICMSTAXPAY = a.Contribuinte_ICMS__c.substring(0,1); 
                
            if (a.Categoria_CFOP__c != null)
                ICliente.CAT_CFOPC = a.Categoria_CFOP__c.substring(0,2);    
            
            //Data de Domicilio
            ICliente.PAIS = 'BR';
            ICliente.COD_POSTAL = a.Codigo_Postal_SAP__c;
            ICliente.POBLACION = a.PoblacionSAP__c;
            ICliente.REGION = a.Region_SAP__c;
            ICliente.BARRIO = a.Barrio__c;
            if(a.Calle__c.length() > 60)
                ICliente.CALLE = a.Calle__c.substring(0,60);
            else
                ICliente.CALLE = a.Calle__c;
            ICliente.NUMERO = a.Numero__c;
            
            //Correo electronico que sale del contacto 1
            ICliente.EMAIL = correo;
            
            ICliente.ESQUEMA_CLIENTE = '01';
            ICliente.FAX = '';
            if(a.Fax != null) ICliente.FAX = a.Fax;
             
            ICliente.GRUPO_IMPUTACION = '01';
            
            ICliente.MONEDA = 'BRL';
            
                        
            if(nombre.length() > 40)
                ICliente.NOMBRE = a.Name.substring(0,40);
            else
                ICliente.NOMBRE = a.Name;
                                 
            ICliente.ORG_VTAS = sociedad;
            ICliente.SECTOR = '01';
            ICliente.SOCIEDAD = sociedad;
            
            //Telefono de la cuenta
            ICliente.TELEFONO = '';
            if(a.Phone != null) ICliente.TELEFONO = String.valueOf(a.Phone);
            
            ICliente.Prientrega = '00'; //Por defecto se pasa la prioridad mas baja            
                              
            
            ICliente.GRP_COND = '';
            
            //LIMITE DE COMPRA
            ICliente.CALC_LIMITE = '';
            ICliente.LIMITE_COMPRA = '0';
            
            
            sapAltaCliente.ZSSD_IN_CLIE_IMPTO IDatos1 = new sapAltaCliente.ZSSD_IN_CLIE_IMPTO();
            
            IDatos1.TIPO_IMPUESTO = 'IBRX';
            IDatos1.CLASIF_FISCAL = '1';
            TDatos.item.add(IDatos1);
                        
            
            debuger = 'CallOut altaCliente de SAP - Error'; 
            
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
            
            String myData = 'SALESFORCEBR:2o21gdms33dS';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);    
            
            resultado = soap.Z_SD_ALTA_CLIENTE (EtReturn, TCategorias, TDatos, ampSociedad, ampVentas, ICliente, String.valueOf(target));
            
            //debuger = resultado;
            
            if (resultado != null){                        
               Integer i;
               if (resultado.ET_RETURN.item != null)
                   for (i=0;i<resultado.ET_RETURN.item.size();i++)
                      r.msg += resultado.ET_RETURN.item[i].Message;
               if (Integer.valueOf(resultado.E_SUBRC) == 0){
                  r.ret = true;
                  r.cliente = resultado.E_NRO_CLIENTE;
               }else{
                  r.msg += '\nError - No se actualizó SAP -El cliente queda pendiente de descargar';
                  r.ret = false;
               }
            }else{
               r.msg += '\n El resultado es nulo';
               r.ret = false;
            }   
            
        }catch(Exception e){
            r.msg += 'En altaCtaSAP - ';
            r.msg += debuger + '\n' + e.getMessage(); r.ret = false;            
        }
        return r;
    }
    
    // @isTest(seeAllData=true)
    // public static void test(){
        
    //     Acc(null);
        
    //     Account cuenta = [Select Id From Account Where Grupo_de_Cuentas__c = 'CNAC - Cliente Nacional' And codigoSAP__c != null And esta_en_Sap__c = true limit 1];
    
    //     Account cuenta2 = Acc(cuenta.Id);
                
    //     cuenta2.name = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        
    //     altaCtaSAP(cuenta2, null, 200);
    
    // }
    
}
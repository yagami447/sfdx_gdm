global class FC_Dest_SAP_Alta {

    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        Webservice String cliente;
    }    
    static Contact Con(Id conId){
        try{
            return [Select Id, Account.CNPJ_CPF__c, Name, Account.Name, Account.CodigoSAP__c, MailingStreet, MailingState, MailingCity, MailingPostalCode, MailingCountry, Esta_en_SAP__c, RecordTypeId, Fecha_Bloqueo_SAP__c, LastName, Numero_Calle__c, Estado_Contacto__c, Cidade__c, Cidade__r.Name, CNPJ_CPF_c__c, Pais__c, Barrio__c, Persona_Fisica__c, Inscripcion_Estadual__c  From Contact Where Id = :conId];
        }
        catch(Exception e){
            return null;
        }       
    }    
    WebService static Retorno enviarDestSAP(Id conId, Integer target, Boolean test){
        Retorno r = new Retorno(); Retorno r1 = new Retorno(); Retorno r2 = new Retorno();
        r.msg = '';
        r.ret = true;

        try{            
            Contact a = Con(conId);
            r.ret = true;
            r1 = altaDestSAP(a, target, test);
            if(r1.ret){
                r.cliente = r1.cliente;
                r.msg = r1.msg;
            }
            else{                  
                r.msg += '\nNo ha podido ser actualizada en SAP\n' + r1.msg;
                r.ret = false;
            }
        }
        catch(Exception e){
            r.msg = '\nEn EnviarCtaSAP - Error: ' + e.getMessage();
            r.ret = false;
        }
        return r;
    }
    
    static Retorno altaDestSAP(Contact a, Integer target, Boolean test){
        Retorno r = new Retorno();
        sapAltaCliente.Z_SD_ALTA_CLIENTEResponse_element resultado; 
        sapAltaCliente.TABLE_OF_BAPIRET2 EtReturn = new sapAltaCliente.TABLE_OF_BAPIRET2();
        String conIVA = '';
        String debuger = '';
        String pais = '';
        r.ret = true;
        r.msg = '\n';
        
        String sociedad = '';
                
        sapAltaCliente.Z_SD_ALTA_CLIENTE soap = new sapAltaCliente.Z_SD_ALTA_CLIENTE();           
        sapAltaCliente.ZSSD_IN_CLIE_GRAL ICliente = new sapAltaCliente.ZSSD_IN_CLIE_GRAL();           
        sapAltaCliente.TABLE_OF_ZSSD_IN_CLIE_CFIS TCategorias = new sapAltaCliente.TABLE_OF_ZSSD_IN_CLIE_CFIS();
        TCategorias.item = new List<sapAltaCliente.ZSSD_IN_CLIE_CFIS>();                   
        sapAltaCliente.TABLE_OF_ZSSD_IN_CLIE_IMPTO TDatos = new sapAltaCliente.TABLE_OF_ZSSD_IN_CLIE_IMPTO();
        TDatos.item = new List<sapAltaCliente.ZSSD_IN_CLIE_IMPTO>();
        String ampVentas = '';
        String ampSociedad = '';
            
        try{                        
            ICliente.ACREEDOR = '';                 
            ICliente.CANAL_DIST = '';
            ICliente.CLIENTE_SAP = '';
                                    
            ICliente.CLIENTE_SF = a.Id;
            
            String nombre = a.LastName + a.Account.Name;
            if(nombre.length() > 20)
                ICliente.CONC_BUSQUEDA = nombre.substring(0,20);
            else
                ICliente.CONC_BUSQUEDA = nombre;
            debuger = 'punto 1';
            ICliente.CONDICION_IVA = conIVA;
             
            ICliente.COND_EXPEDICION = '';
            ICliente.COND_PAGO = '';            
            
            ICliente.CUENTA_ASOCIADA = a.Account.CodigoSAP__c.substring(10);
            ICliente.GRUPO_CLIENTES = '';
            ICliente.GRUPO_TESORERIA = '';
            debuger = 'punto 2';
            if(a.Persona_Fisica__c == true){
                ICliente.GRUPO_CTAS = 'CPFI';
                ICliente.NRO_IIBB = (((a.CNPJ_CPF_c__c).remove('.')).remove('/')).remove('-');
                ICliente.INSC_EST = '';
                ICliente.PERS_FIS = 'X';
            }else{
                ICliente.GRUPO_CTAS = 'CPJU';
                //ICliente.NIF = a.CNPJ_CPF_c__c.substring(0,14);
                ICliente.NIF = (((a.CNPJ_CPF_c__c).remove('.')).remove('/')).remove('-');
                ICliente.INSC_EST = a.Inscripcion_Estadual__c.substring(0,11);
                ICliente.PERS_FIS = '';
            }
            ICliente.TIPO_NIF = '';            
            debuger = 'punto 3';
            //Data de Domicilio
            if(a.MailingCountry.toUpperCase() == 'BRASIL' || a.MailingCountry.toUpperCase() == 'BR'){pais = 'BR';}
            else{if(a.MailingCountry.toUpperCase() == 'ARGENTINA' || a.MailingCountry.toUpperCase() == 'AR'){pais = 'AR';}
                else{if(a.MailingCountry.toUpperCase() == 'PARAGUAY' || a.MailingCountry.toUpperCase() == 'PY'){pais = 'PY';}
                    else{pais = 'BR';}}}
            ICliente.PAIS = pais;
            ICliente.COD_POSTAL = a.MailingPostalCode;
            //ICliente.POBLACION = a.MailingCity;
            ICliente.POBLACION = a.Cidade__r.Name;
            ICliente.REGION = a.MailingState;
            ICliente.BARRIO = a.Barrio__c;
            //ICliente.PAIS = 'BR';
            //ICliente.COD_POSTAL = '86050460';//a.MailingPostalCode;
            //ICliente.POBLACION = 'LONDRINA';
            //ICliente.REGION = 'PR';
            ICliente.Prientrega = '5';
            debuger = 'punto 4';         
            if(a.MailingStreet.length() > 60)
                ICliente.CALLE = a.MailingStreet.substring(0,60);
            else
                ICliente.CALLE = a.MailingStreet;
            debuger = 'punto 5';
            ICliente.NUMERO = a.Numero_Calle__c;
                                    
            ICliente.ESQUEMA_CLIENTE = '';
            ICliente.FAX = '';
                         
            ICliente.GRUPO_IMPUTACION = '';
            
            ICliente.MONEDA = '';
            
            nombre=a.Name;            
            if(nombre.length() > 40)
                ICliente.NOMBRE = a.Name.substring(0,40);
            else
                ICliente.NOMBRE = a.Name;
            debuger = 'punto 6';
            ICliente.ORG_VTAS = sociedad;
            ICliente.SECTOR = '';
            ICliente.SOCIEDAD = sociedad;
            ICliente.CAT_CFOPC = '4';
            debuger = 'punto 7';
            //Telefono de la cuenta
            ICliente.TELEFONO = '';
             
            debuger = 'categorias';
 
            /*
            sapAltaCliente.ZssdInClieCfis ICat0 = new sapAltaCliente.ZssdInClieCfis();
            ICat0.CATEGORIAFISCAL = '';
            ICat0.SUJETODESDE = '0000-00-00';
            ICat0.SUJETOHASTA = '0000-00-00';
            TCategorias.item.add(ICat0);            
            
            debuger = 'datos impositivos';
            
            //sapAltaCliente.ZssdInClieImpto IDatos1 = new sapAltaCliente.ZssdInClieImpto();
            
            //IDatos1.TIPOIMPUESTO = '';
            //IDatos1.CLASIFFISCAL = '';
            //TDatos.item.add(IDatos1);            
            */
            debuger = 'CallOut altaCliente de SAP - Error'; 
            
            soap.inputHttpHeaders_x = new Map<String, String>();
            String encodedusernameandpassword;
            
            String myData = 'donmario:donmario';
            Blob hash = Blob.valueOf(myData);
            encodedusernameandpassword = EncodingUtil.base64Encode(hash);
            soap.timeout_x = 60000;
            soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);    
            debuger = 'punto 9';
            if(!test){
                resultado = soap.Z_SD_ALTA_CLIENTE(EtReturn, TCategorias, TDatos, ampSociedad, ampVentas, ICliente, String.valueOf(target));
            }
            //debuger = resultado;
            debuger = 'punto 10';
            if (resultado != null){                        
               Integer i;
               for (i=0;i<resultado.ET_RETURN.item.size();i++)
                  r.msg += resultado.ET_RETURN.item[i].Message;
               if (Integer.valueOf(resultado.E_SUBRC) == 0 && (resultado.E_NRO_CLIENTE).length() != 0){
                  r.ret = true;
                  r.cliente = resultado.E_NRO_CLIENTE;
                  r.msg += resultado.E_SUBRC;
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

   
    @isTest(SeeAllData=true)
    static void test() {
        /*Account acc = New Account();
        acc.Name = 'Prueba';
        acc.CNPJ_CPF__c = '01234567891';
        insert acc;
        sapAltaCliente.isApexTest = true;*/
        Account acme = [Select Id, CNPJ_CPF__c, Name, CodigoSAP__c, Estado__c FROM Account Where Name = 'ACME' AND CodigoSAP__c = '6000000000' Limit 1];
        Cidade__c ciudad = [Select Id, Name from Cidade__c Limit 1];
        
        RecordType rt = [Select Id From RecordType Where Name = 'Destinatario Desbloqueado' And SObjectType = 'Contact' limit 1];
        
        Contact con = New Contact();
        con.AccountId = acme.Id;
        con.CNPJ_CPF_c__c = '111198646444';
        con.MailingStreet = 'aaaa';
        con.MailingState = '01 - 01'; 
        con.MailingCity = 'cccc'; 
        con.MailingPostalCode = '1111';
        con.MailingCountry = 'dddd';
        con.Esta_en_SAP__c = false;
        con.RecordTypeId = rt.Id;
        con.LastName = 'Contacto';
        con.Barrio__c = 'Probando';
        con.Pais__c = 'BR';
        con.Persona_Fisica__c = true;
        con.Cidade__c = ciudad.Id;
        
        insert con;
        
        FC_Dest_SAP_Alta.enviarDestSAP(con.Id, 110, true);
        
    }


}
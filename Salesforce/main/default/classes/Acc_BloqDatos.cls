global class Acc_BloqDatos {
    
    global class Retorno{
        webservice String msg;
        webservice Boolean ret;
        webservice String tipo;
    }
    
    WebService static String[] atualizar_Supervisor(Id accId) {
        String[] retorno = new String[]{'', 'true'};
        
        Opportunity[] opps = [
            SELECT Id, AccountId, RecordTypeId, Marca__c, OwnerId
            FROM Opportunity
            WHERE OwnerId != '00540000001TUHM' AND AccountId = :accId
        ];
        
        CRM_Calendario_de_Eventos__c[] eventos = [
            SELECT Id, Cuenta__c, Marca__c, OwnerId
            FROM CRM_Calendario_de_Eventos__c
            WHERE OwnerId != '00540000001TUHM' AND Cuenta__c = :accId
        ];
        
        Contrato__c[] aditivos = [
            SELECT Id, Multiplicador__c, Sociedad__c, OwnerId
            FROM Contrato__c
            WHERE OwnerId != '00540000001TUHM' AND Multiplicador__c = :accId
        ];
        
        List<SObject[]> listToUpdate = new List<SObject[]>();

        try {
            listToUpdate = BRAXUtils.actualizarPropietarios(accId, opps, eventos, aditivos);
            Database.update(listToUpdate[0], false); // Opportunity[]
            Database.update(listToUpdate[1], false); // CRM_Calendario_de_Eventos__c[]
            Database.update(listToUpdate[2], false); // Contrato__c[]
        } catch (Exception e) {
            retorno[0] = 'Atualização da Conta com erro: ' + e.getMessage();
            retorno[1] = 'false';
        }
        
        if (retorno[1] == 'true') {
            retorno[0] = String.format(
                'Oportunidades atualizadas {0}, CRM Eventos atualizados {1}, Aditivos atualizados {2}',
                new Object[]{listToUpdate[0].size(), listToUpdate[1].size(), listToUpdate[2].size()}
            );
        }
        
        return retorno;
    }
    
    WebService static String FC_Bloq_Dest(Id contactId, Integer target) {
        String retorno = null;
        FC_Dest_SAP_Alta.Retorno re = new FC_Dest_SAP_Alta.Retorno();
        RecordType rtBQ = [SELECT Id FROM RecordType WHERE Name = 'Destinatario Bloqueado' LIMIT 1];

        try {
            Contact contact = [SELECT Id, Name, Esta_en_SAP__c FROM Contact WHERE Id = :contactId];
            re = FC_Dest_SAP_Alta.enviarDestSAP(contactId, target, false);
            if (!re.ret) {
                retorno = 'El Destinatario no ha sido Bloqueada ni descargada a SAP\n' + re.msg;
            } else {
                contact.Esta_en_SAP__c = true;
                contact.Codigo_SAP__c = re.cliente;
                contact.RecordTypeId = rtBQ.Id;
                contact.Fecha_Bloqueo_SAP__c = System.today();
                update contact;
                retorno = 'El Destinatario ' + contact.Name + ' del tipo DEST Codigo ' + contact.Codigo_SAP__c + ' ha sido Bloqueada\n' + re.msg;
            }
        } catch (Exception e) {
            retorno = 'Bloqueo de Cuenta - Error: ' + e.getMessage();
        }

        return retorno;
    }
    
    WebService static String FC_Desbloq_Dest(Id contactId) {
        String retorno = null;
        RecordType rtDBQ = [SELECT Id FROM RecordType WHERE Name = 'Destinatario Desbloqueado' LIMIT 1];

        try {
            Contact contact = [SELECT Id, RecordTypeId FROM Contact WHERE Id = :contactId];
            contact.RecordTypeId = rtDBQ.Id;
            update contact;
            retorno = 'Desbloqueada';
        } catch (Exception e) {
            retorno = e.getMessage();
        }

        return retorno;
    }
    
    
    
    
    
    WebService static String BloqCuenta(Id accId, Integer target){
        Retorno r = new Retorno();
        RecordType rrtt = [Select Id From RecordType Where Name = 'Conta Bloqueada' limit 1];        
        String rtBQ = rrtt.Id; 
        Acc_SAP_Alta.Retorno re = new Acc_SAP_Alta.Retorno();
        try
        {
            Account a = [Select Id, CodigoSAP__c, Name, ParentId, Parent.CNPJ_CPF__c, CNPJ_CPF__c, Grupo_de_Cuentas__c, Calle__c, Numero__c, Region_SAP__c, Barrio__c, PoblacionSAP__c, Codigo_Postal_SAP__c, Categoria_CFOP__c, Cod_Juros__c, Formas_de_pagamento__c, Contribuinte_ICMS__c, esta_en_Sap__c, RecordTypeId From Account Where Id = :accId];                        
            r = validoCTA(a, 1);
            if(!r.ret){
                return 'La cuenta ' + a.Name + ' no es válida.\n' + r.msg;              
            }
            String grupo = r.tipo;                        
                
            if(grupo == 'CPFI' || grupo == 'CPJU'){
                re = Acc_SAP_Alta.enviarCtaSAP(a.Id, target);
                if(!re.ret){
                    return 'La Cuenta ' + a.Name + ' no ha sido Bloqueada ni descargada a SAP\n' + re.msg;              
                }              

                a.esta_en_Sap__c = true;
                if((re.cliente == null || re.cliente == ''))
                    a.CodigoSAP__c = re.cliente;
                else
                    a.CodigoSAP__c = re.cliente;                
            }
            else if(grupo == 'CMEX'){
                a.esta_en_Sap__c = true;
                re.msg = 'Esta cuenta no se descarga a SAP';
            }
            a.RecordTypeId = rtBQ;            
            
            update a;
            return 'La cuenta ' + a.Name + ' del tipo ' + grupo + ' Codigo ' + a.CodigoSAP__c + ' ha sido Bloqueada\n' + re.msg;
        }
        catch(Exception e)
        {
            return 'Bloqueo de Cuenta - Error: ' + e.getMessage();
        }
    }        
    
    WebService static String DesbloqCuenta(Id accId){
        RecordType rrtt = [Select Id From RecordType Where Name = 'Conta Desbloqueada' limit 1];        
        String rtDBQ = rrtt.Id;

        try
        {
            Account a = [Select Id, RecordTypeId From Account Where Id = :accId];
            a.RecordTypeId = rtDBQ;
            update a;
            return 'Desbloqueada';
        }
        catch(Exception e)
        {
            return e.getMessage();
        }
    }
    
    static Retorno validoCTA(Account a, Integer tipo){
        Retorno r = new Retorno();
        try{            
            if(a.Grupo_de_Cuentas__c == null){
                r.msg = 'El Grupo de Cuentas no puede estar vacío'; r.ret = false;
                return r;
            }
            
            r.tipo = a.Grupo_de_Cuentas__c.substring(0,4);
                            
            if(a.Grupo_de_Cuentas__c.substring(0,4) == 'CMEX'){                
                if(a.BillingCountry == null){
                    r.msg = 'El País de Facturación no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.BillingState == null){
                    r.msg = 'El Estado/Provincia de Facturación no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.BillingCity == null){
                    r.msg = 'La Ciudad de Facturación no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.BillingPostalCode == null){
                    r.msg = 'El Código Postal de Facturación no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.BillingStreet == null){
                    r.msg = 'La Calle de Facturación no puede estar vacía'; r.ret = false;
                    return r;
                }               
                if(a.CodigoSAP__c == null){
                    r.msg = 'El Código de SAP no puede estar vacío'; r.ret = false;
                    return r;
                }
            }
            else if(a.Grupo_de_Cuentas__c.substring(0,4) == 'CPFI' || a.Grupo_de_Cuentas__c.substring(0,4) == 'CPJU'){
                if(a.CNPJ_CPF__c == null){
                    r.msg = 'CNPJ/CPF no puede estar vacío'; r.ret = false;
                    return r;
                }                                      
                if(a.PoblacionSAP__c == null){
                    r.msg = 'La Ciudad no puede estar vacía'; r.ret = false;
                    return r;
                } 
                if(a.Calle__c == null){
                    r.msg = 'La Calle no puede estar vacía'; r.ret = false;
                    return r;
                }
                if(a.Numero__c == null){
                    r.msg = 'El Número no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.Barrio__c == null){
                    r.msg = 'El Barrio no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.Categoria_CFOP__c == null){
                    r.msg = 'Categoria CFOP no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.Cod_Juros__c == null){
                    r.msg = 'Cod Juros no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.Formas_de_pagamento__c == null){
                    r.msg = 'Formas de pagamento no puede estar vacío'; r.ret = false;
                    return r;
                }
                if(a.Contribuinte_ICMS__c == null){
                    r.msg = 'Contribuinte ICMS no puede estar vacío'; r.ret = false;
                    return r;
                }                                
            }            
            
            r.msg = 'La cuenta está Ok'; r.ret = true;
                    
        }
        catch(Exception e){
            r.msg = 'Valido CTA\n' + e.getMessage(); r.ret = false;
        }
        
        return r;
    }
    
}
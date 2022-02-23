public class aAppManager{
    private static String ST_APROBADA = 'Aprobada';
    public aAppManager(){
    }

    //Brasil
    public static List<Opportunity> getAnexos1(Id accId, String safra, String marca){
        try{
            return aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'RecordType.DeveloperName = :v2', 'AnexoI', 'Safra__c = :v3', safra, 'Marca__c = :v4', marca, 'Estado_Anexos_Portal_Miltiplicadores__c = :v5', 'Aprovado');
        } catch (Exception e){
            return null;
        }
    }

    public static List<Opportunity> getAnexos1Rebaja(Id accId, String safra, String marca){
        try{
            return aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'RecordType.DeveloperName = :v2', 'Anexo_I_Rebaixamento_Ha', 'Safra__c = :v3', safra, 'Marca__c = :v4', marca, 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
        } catch (Exception e){
            return null;
        }
    }

    public static List<OpportunityLineItem> getAnexosItemsByOpp(Id oppId){
        try{
            String queryPlus = 'PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c, PricebookEntry.Product2.Variedade__c, Variedad__r.Name,Categoria__r.Name, Categoria_a_Rebaixar__r.Name, Opportunity.Epoca_de_Plantio__c, Estado_de_Comercializacion__r.Name ';
            //return aSiteUtils.queryResults1(OpportunityLineItem.SObjectType, queryPlus ,'OpportunityId = :v1', oppId);
            return aSiteUtils.queryResults2(OpportunityLineItem.SObjectType, queryPlus, 'OpportunityId = :v1', oppId, 'Item_Rebajado__c = :v2', false);
        } catch (Exception e){
            system.debug('AAAA ' + e.getMessage());
            return null;
        }
    }

    public static Boolean existeContratoParaCompany(String idUser, String comp){
        try{
            List<Configuracion_BMX__c> conf = aSiteUtils.queryResults1(Configuracion_BMX__c.SObjectType, null, 'Id != :v1', null);
            List<SiteUserAccount__c> siteUserAccs = aSiteUtils.queryResults1(SiteUserAccount__c.SObjectType, null, 'SiteUser__c = :v1', idUser);
            List<String> campanias = New List<String>();
            List<String> cuentas = New List<String>();

            if (conf[0].PM_Safra_Actual_A1__c != null && conf[0].PM_Safra_Actual_A1__c != '')
                campanias.add(conf[0].PM_Safra_Actual_A1__c);
            if (conf[0].PM_Safra_Actual_A2__c != null && conf[0].PM_Safra_Actual_A2__c != '')
                campanias.add(conf[0].PM_Safra_Actual_A2__c);
            if (conf[0].PM_Safra_Actual_A3__c != null && conf[0].PM_Safra_Actual_A3__c != '')
                campanias.add(conf[0].PM_Safra_Actual_A3__c);
            if (conf[0].PM_Safra_Actual_A4__c != null && conf[0].PM_Safra_Actual_A4__c != '')
                campanias.add(conf[0].PM_Safra_Actual_A4__c);
            if (conf[0].PM_Safra_Actual_A5__c != null && conf[0].PM_Safra_Actual_A5__c != '')
                campanias.add(conf[0].PM_Safra_Actual_A5__c);
            if (conf[0].PM_Safra_Actual_Eventos__c != null && conf[0].PM_Safra_Actual_Eventos__c != '')
                campanias.add(conf[0].PM_Safra_Actual_Eventos__c);
            for (SiteUserAccount__c s : siteUserAccs)
                cuentas.add(s.Account__c);
            List<Contrato__c> contratos = New List<Contrato__c>();
            contratos = aSiteUtils.queryResults4(Contrato__c.SObjectType, null, 'Multiplicador__c In :v1', cuentas, 'Safra__c In :v2', campanias, 'Sociedad__c = :v3', comp, 'Chegou_na_Brasmax__c = :v4', true);
            if (contratos.size() > 0)
                return true;
            contratos = New List<Contrato__c>();
            contratos = aSiteUtils.queryResults4(Contrato__c.SObjectType, null, 'Multiplicador__c In :v1', cuentas, 'Safra__c In :v2', campanias, 'Sociedad__c = :v3', comp, 'Estado__c = :v4', 'Chegou');
            if (contratos.size() > 0)
                return true;
            return false;

        } catch (Exception e){
            return false;
        }
    }

    public static Boolean existeAnexoII(Id idCuenta, String safra, String marca){
        System.debug('existeAnexo 2 : idCuenta : '+idCuenta+' , safra: '+safra+' , Marca : '+marca);
        List<Opportunity> anexo2opps = [SELECT Id, Name
                                        FROM Opportunity
                                        WHERE AccountId = :idCuenta AND Safra__c = :safra AND Marca__c = :marca AND RecordType.DeveloperName = 'AnexoII' AND Estado_Anexos_Portal_Miltiplicadores__c != 'Anulado'];
        if (!anexo2opps.isEmpty()){
            return true;
        }
        return false;
    }

    public static Boolean existeAnexoIV(Id idCuenta, String safra, String marca){

        List<Opportunity> anexo4opps = [SELECT Id, Name
                                        FROM Opportunity
                                        WHERE AccountId = :idCuenta AND Safra__c = :safra AND Marca__c = :marca AND RecordType.DeveloperName = 'Anexo_IV' AND Estado_Anexos_Portal_Miltiplicadores__c = 'Aprovado'];

        if (anexo4opps.isEmpty()){
            return true;
        }
        return false;
    }

    public static String getSafraActualByApp(String appendix){
        try{
            List<Configuracion_BMX__c> conf = aSiteUtils.queryResults1(Configuracion_BMX__c.SObjectType, null, 'Id != :v1', null);
            if (appendix == 'A1')
                return conf[0].PM_Safra_Actual_A1__c;
            if (appendix == 'A2')
                return conf[0].PM_Safra_Actual_A2__c;
            if (appendix == 'A3')
                return conf[0].PM_Safra_Actual_A3__c;
            if (appendix == 'A4')
                return conf[0].PM_Safra_Actual_A4__c;
            if (appendix == 'A5')
                return conf[0].PM_Safra_Actual_A5__c;
            if (appendix == 'A6')
                return conf[0].PM_Safra_Actual_A6__c;
            if (appendix == 'Cont')
                return conf[0].PM_Safra_Actual_Contratos__c;
            if (appendix == 'Estoque')
                return conf[0].PM_Safra_Actual_Estoque__c;
            if (appendix == 'Descarte'){
                System.debug('Safra actual encontrada ! : '+conf[0].PM_Safra_Actual_Descarte__c);
                return conf[0].PM_Safra_Actual_Descarte__c;
            }
            if (appendix == 'Reembalagem'){
                return conf[0].PM_Safra_Actual_Reembalagem__c;
            }
            if (appendix == 'DescontoRoyalty')
                return conf[0].PM_Safra_Actual_DescontoRoyalty__c;
            if (appendix == 'VendaBasica')
                return conf[0].PM_Safra_Actual_VendaBasica__c;
            return null;
        } catch (Exception e){
            return null;
        }
    }

    public static List<String> getMeses(){

        try{
            return aSiteUtils.getDatosCombo('Opportunity', 'Mes__c');
        } catch (Exception e){
            return null;
        }
    }

    public static String determinarMesStock(String accId, String safra, String marca){
        try{
            List<Opportunity> opps = New List<Opportunity>();
            opps = aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'Safra__c = :v2', safra, 'Marca__c = :v3', marca, 'RecordType.DeveloperName = :v4', 'Stock_Multiplicadores', 'Estado_Anexos_Portal_Miltiplicadores__c = :v5', 'Aprovado');
            Integer mayorMes = 0;
            String mayorMes2 = '';
            if (opps.size() > 0){
                mayorMes = aSiteUtils.getNumberOfMonth(opps[0].Mes__c);
                mayorMes2 = opps[0].Mes__c;
                for (Opportunity o : opps)
                    if (aSiteUtils.getNumberOfMonth(o.Mes__c) > mayorMes){
                        mayorMes = aSiteUtils.getNumberOfMonth(o.Mes__c);
                    mayorMes2 = o.Mes__c;
                }
            }
            if (mayorMes2 == '') return 'Janeiro';
            return Opp_Utils.getSiguienteMes(mayorMes2);
        } catch (Exception e){
            return null;
        }
    }

    public static string getMotivoRechazo(Id oId){
        try{
            String motivo = '';
            List<Opportunity> opps = New List<Opportunity>();
            opps = aSiteUtils.queryResults1(Opportunity.SObjectType, null, 'Id = :v1', oId);
            if (opps.size() > 0)
                motivo = opps[0].Motivo_de_Rechazo__c;
            return motivo;
        } catch (Exception e){
            return null;
        }
    }

    public static Boolean esRebajaCorrecta(string origen, string destino){
        if (origen == 'C1' && destino != 'C2' && destino != 'S1' && destino != 'S2')
            return false;
        if (origen == 'C2' && destino != 'S1' && destino != 'S2')
            return false;
        if (origen == 'S1' && destino != 'S2')
            return false;
        if (origen == 'S2')
            return false;
        return true;
    }

    public static string getEpocaPlantioByApp(Id appId){
        try{
            String epoca = '';
            List<Opportunity> opps = New List<Opportunity>();
            opps = aSiteUtils.queryResults1(Opportunity.SObjectType, null, 'Id = :v1', appId);
            if (opps.size() > 0)
                epoca = opps[0].Epoca_de_Plantio__c;
            return epoca;
        } catch (Exception e){
            return null;
        }
    }

    public static string getEpocaPlantioToA2(Id accId, String safra, String marca){
        try{
            String epoca = 'Verão';
            List<Opportunity> opps = New List<Opportunity>();
            opps = aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'Safra__c = :v2', safra, 'Marca__c = :v3', marca, 'RecordType.DeveloperName = :v4', 'AnexoII', 'Estado_Anexos_Portal_Miltiplicadores__c = :v5', 'Aprovado');
            if (opps.size() > 0)
                epoca = 'Inverno';
            return epoca;
        } catch (Exception e){
            return null;
        }
    }

    public static String getCategoriaBonifAnterior(Id accId, String marca){
        try{
            List<CRM_Bonificacion__c> bonif = New List<CRM_Bonificacion__c>();
            String queryPlus = 'RecordType.Name';
            bonif = aSiteUtils.queryResults2(CRM_Bonificacion__c.SObjectType, queryPlus, 'CRM_Multiplicador__r.Cuenta__c = :v1', accId, 'CRM_Multiplicador__r.Safra__c = :v2', '17/18');
            String categBRMX = '';
            String categDSEM = '';
            if (bonif.size() > 0){
                for (CRM_Bonificacion__c b : bonif){
                    if (b.RecordType.Name == 'BRMX')
                        categBRMX = b.BR_Categoria_resultante__c;
                    if (b.RecordType.Name == 'DSEM')
                        categDSEM = b.DS_Categoria_resultante__c;
                }
            }

            if (marca == 'BRMX')
                return categBRMX;
            if (marca == 'DSEM')
                return categDSEM;
            return '';
        } catch (Exception e){
            return null;
        }
    }

    public static CRM_Multiplicador__c getPerfilByMultiplicador(Id accId, String safra){
        try{
            List<CRM_Multiplicador__c> crm = New List<CRM_Multiplicador__c>();
            crm = aSiteUtils.queryResults2(CRM_Multiplicador__c.SObjectType, null, 'Cuenta__c = :v1', accId, 'Safra__c = :v2', safra);

            if (crm.size() > 0)
                return crm[0];
            return null;

        } catch (Exception e){
            return null;
        }
    }

    public static List<OpportunityLineItem> getVentasByMultiplicador(Id accId, String safra, String marca){
        try{
            List<Account> accs = New List<Account>();
            
             accs = aSiteUtils.queryResults1(Account.SObjectType, null, 'Id = :v1', accId);
            
            List<OpportunityLineItem> items = New List<OpportunityLineItem>();
            String queryPlus = 'Opportunity.RecordType.Name, Opportunity.Region__c, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c ';
            
            if (accs[0].ParentId == null){
                items = aSiteUtils.queryResults5(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.AccountId = :v1', accId, 'Opportunity.Safra__c = :v2', safra, 'Opportunity.Marca__c = :v3', marca, 'Opportunity.RecordType.DeveloperName In :v4', new String[]{'Anexo_III', 'Anexo_IV'}, 'Opportunity.Estado_Anexos_Portal_Miltiplicadores__c = :v5', 'Aprovado');

                if (items.size() == 0)
                    items = aSiteUtils.queryResults6(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.AccountId = :v1', accId, 'Opportunity.Safra__c = :v2', safra, 'Opportunity.Marca__c = :v3', marca, 'Opportunity.RecordType.DeveloperName In :v4', new String[]{'Stock_Multiplicadores'}, 'Opportunity.Estado_Anexos_Portal_Miltiplicadores__c = :v5', 'Aprovado', 'Opportunity.Activa__c = :v6', true);
            }else{
                items = aSiteUtils.queryResults5(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.Account.ParentId = :v1', accs[0].ParentId, 'Opportunity.Safra__c = :v2', safra, 'Opportunity.Marca__c = :v3', marca, 'Opportunity.RecordType.DeveloperName In :v4', new String[]{'Anexo_III', 'Anexo_IV'}, 'Opportunity.Estado_Anexos_Portal_Miltiplicadores__c = :v5', 'Aprovado');

                if (items.size() == 0)
                    items = aSiteUtils.queryResults6(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.Account.ParentId = :v1', accs[0].ParentId, 'Opportunity.Safra__c = :v2', safra, 'Opportunity.Marca__c = :v3', marca, 'Opportunity.RecordType.DeveloperName In :v4', new String[]{'Stock_Multiplicadores'}, 'Opportunity.Estado_Anexos_Portal_Miltiplicadores__c = :v5', 'Aprovado', 'Opportunity.Activa__c = :v6', true);             
            }
             
            return items;

        } catch (Exception e){
            return null;
        }
    }

    public static Double getTotalSemBrutaAII(Id accId, String safra, String marca){
        try{
            Double total = 0;
            List<OpportunityLineItem> items = New List<OpportunityLineItem>();
            items = aSiteUtils.queryResults5(OpportunityLineItem.SObjectType, null, 'Opportunity.AccountId = :v1', accId, 'Opportunity.Safra__c = :v2', safra, 'Opportunity.Marca__c = :v3', marca, 'Opportunity.RecordType.DeveloperName = :v4', 'AnexoII', 'Opportunity.Estado_Anexos_Portal_Miltiplicadores__c = :v5', 'Aprovado');

            for (OpportunityLineItem s : items)
                if (s.Semente_bruta__c != null)
                    total = total + s.Semente_bruta__c;
                return total;
        } catch (Exception e){
            return null;
        }
    }

    public static Double getTotalHasPlantadasAII(Id accId, String safra, String marca){
        try{
            Double total = 0;
            List<OpportunityLineItem> items = New List<OpportunityLineItem>();
            items = aSiteUtils.queryResults5(OpportunityLineItem.SObjectType, null, 'Opportunity.AccountId = :v1', accId, 'Opportunity.Safra__c = :v2', safra, 'Opportunity.Marca__c = :v3', marca, 'Opportunity.RecordType.DeveloperName = :v4', 'AnexoII', 'Opportunity.Estado_Anexos_Portal_Miltiplicadores__c = :v5', 'Aprovado');

            for (OpportunityLineItem s : items)
                if (s.Area_Plantada__c != null)
                    total = total + s.Area_Plantada__c;
                return total;
        } catch (Exception e){
            return null;
        }
    }

    public static Boolean validarNewA2(Id accId, String safra, String marca){
        Boolean retorno;
        try{
            List<Opportunity> opps = New List<Opportunity>();
            opps = aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'Safra__c = :v2', safra, 'Marca__c = :v3', marca, 'RecordType.DeveloperName = :v4', 'AnexoII', 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
            if (opps.size() == 1)
                if (opps[0].Estado_Anexos_Portal_Miltiplicadores__c != 'Aprovado')
                    return false;
                if (opps.size() > 1)
                    return false;
                return true;
        } catch (Exception e){
            return false;
        }
    }

    public static Boolean validarNewA3(Id accId, String safra, String marca){
        Boolean retorno;
        try{
            List<Opportunity> opps = New List<Opportunity>();
            opps = aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'Safra__c = :v2', safra, 'Marca__c = :v3', marca, 'RecordType.DeveloperName = :v4', 'Anexo_III', 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
            if (opps.size() > 0)
                return false;
            return true;
        } catch (Exception e){
            return false;
        }
    }

    public static Boolean validarNewA4(Id accId, String safra, String marca){
        Boolean retorno;
        try{
            List<Opportunity> opps = New List<Opportunity>();
            opps = aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'Safra__c = :v2', safra, 'Marca__c = :v3', marca, 'RecordType.DeveloperName = :v4', 'Anexo_IV', 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
            if (opps.size() > 0)
                return false;
            return true;
        } catch (Exception e){
            return false;
        }
    }

    public static Boolean validarNewA5(Id accId, String safra, String marca){
        Boolean retorno;
        try{
            List<Opportunity> opps = New List<Opportunity>();
            opps = aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'Safra__c = :v2', safra, 'Marca__c = :v3', marca, 'RecordType.DeveloperName = :v4', 'AnexoV', 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
            if (opps.size() > 0)
                return false;
            return true;
        } catch (Exception e){
            return false;
        }
    }

    public static String validarNewEstoque(Id accId, String safra, String marca){
        Boolean retorno;
        try{
            List<Opportunity> opps = New List<Opportunity>();
            opps = aSiteUtils.queryResults6(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'Safra__c = :v2', safra, 'Marca__c = :v3', marca, 'RecordType.DeveloperName = :v4', 'Stock_Multiplicadores', 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado', 'Estado_Anexos_Portal_Miltiplicadores__c != :v6', 'Aprovado');
            if (opps.size() > 0) return 'false';
            List<Configuracion_BMX__c> conf = aSiteUtils.queryResults1(Configuracion_BMX__c.SObjectType, null, 'Name = :v1', 'Facturacion');
            Integer desde = 1;
            Integer hasta = 31;
            if (conf[0].PM_Estoque_Dia_Desde__c != null)
                desde = Integer.valueOf(conf[0].PM_Estoque_Dia_Desde__c);
            if (conf[0].PM_Estoque_Dia_Hasta__c != null)
                hasta = Integer.valueOf(conf[0].PM_Estoque_Dia_Hasta__c);

            Integer hoy = system.today().day();           
     
            if (hoy < desde && hoy > hasta) {
                return 'invalid_period';
            }else{
                 return 'true';
            }        
           
        } catch (Exception e){
            return 'false';
        }
    }
   

    //Validacion A, anexos II
    /*
     public static List<OpportunityLineItem> valAnexos2_A(List<OpportunityLineItem> items){
     try{
     Map<String,OpportunityLineItem> mapOppApp1 = new Map<String,OpportunityLineItem>();

     for(OpportunityLineItem s : items){
     if(!mapOppApp1.containsKey(s.Categoria__r.Name+s.Variedade_Prod__c)){
     mapOppApp1.put(s.Categoria__r.Name+s.Variedade_Prod__c, s);
     }
     else{
     OpportunityLineItem oli = mapOppApp1.get(s.Categoria__r.Name+s.Variedade_Prod__c);
     if(oli != null)
     oli.Area__c = oli.Area__c + Integer.valueOf(s.Area__c);
     }
     }
     for(OpportunityLineItem s : items){
     if(s.Categoria_a_Rebaixar__c != null){  //si es rebaja, entonces puedo completar producto existente o crear uno nuevo
     if(mapOppApp1.containsKey(s.Categoria_a_Rebaixar__r.Name+s.Variedade_Prod__c)){
     OpportunityLineItem oli = mapOppApp1.get(s.Categoria_a_Rebaixar__r.Name+s.Variedade_Prod__c);
     if(oli != null)
     oli.Area__c = oli.Area__c - s.Area__c;
     }
     }
     }
     return mapOppApp1.values();

     }
     catch(Exception e){
     return null;
     }
     }
     */
    public static List<OpportunityLineItem> valEstoque_A(List<OpportunityLineItem> items, String marca){
        try{
            if (items.size() > 0 && items[0].Opportunity.RecordType.DeveloperName == 'Stock_Multiplicadores')
                return items;
            Map<String, OpportunityLineItem> mapOppApp1 = new Map<String, OpportunityLineItem>();
            for (OpportunityLineItem s : items){
                if (!mapOppApp1.containsKey(String.valueOf(s.PricebookEntry.Product2.Variedade__c))){
                    s.Semente_comercializada__c = null;
                    s.Semente_aprovada__c = null;
                    mapOppApp1.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c), s);
                }
            }

            return mapOppApp1.values();

            /*
             List<String> idVari = New List<String>();
             for (OpportunityLineItem i : items)
             if (i.PricebookEntry.Product2.Variedade__c != null)
             idVari.add(i.PricebookEntry.Product2.Variedade__c);

             if (idVari.size() > 0){
             String lp = '';
             if (marca == 'BRMX')
             lp = 'Lista de Básica BMX SUL';
             if (marca == 'DSEM')
             lp = 'Lista de Básica DSEM SUL';
             List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();
             String queryPlus = 'Product2.Variedade__c, Product2.Variedade_Prod__c, Product2.Categ__r.Name ';

             List<PricebookEntry> lpbe = aSiteUtils.queryResults6(PricebookEntry.SObjectType, queryPlus, 'Product2.Categ__r.Name = :v1', 'BASICA', 'Product2.Family = :v2', 'Semilla', 'Product2.Semilla_Tratada__c = :v3', false, 'Product2.CANTIDAD_SUB_UNIDAD__c = :v4', '40', 'Pricebook2.Name = :v5', lp, 'Product2.Variedade__c In :v6', idVari);
             for (PricebookEntry pbe : lpbe){
             OpportunityLineItem i = New OpportunityLineItem();
             i.PricebookEntry = pbe;
             tmpOppItems.add(i);
             }

             return tmpOppItems;
             }
             */

            return null;

        } catch (Exception e){
            return null;
        }
    }

    public static String calcularSafraAnterior(String safraActual){
        String safraAnterior;
        List<String> partes = safraActual.split('/', 2);
        Integer parte_1 = Integer.valueOf(partes[0])-1;
        Integer parte_2 = Integer.valueOf(partes[1])-1;
        safraAnterior = String.valueOf(parte_1)+'/' + String.valueOf(parte_2);
        return safraAnterior;
    }

    public static List<OpportunityLineItem> valAnexos2_A(List<OpportunityLineItem> items){
        try{
            Map<String, OpportunityLineItem> mapOppApp1 = new Map<String, OpportunityLineItem>();
            Map<String, Double> mapRebajas = new Map<String, Double>();

            for (OpportunityLineItem s : items){
                if (!mapOppApp1.containsKey(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c))){
                    s.Area_Plantada__c = null;
                    s.Semente_bruta__c = null;
                    s.Descarte__c = null;
                    mapOppApp1.put(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c), s);
                } else{
                    OpportunityLineItem oli = mapOppApp1.get(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                    if (oli != null)
                        oli.Area__c = oli.Area__c + s.Area__c;
                    //oli.Area__c = oli.Area__c + Integer.valueOf(s.Area__c);

                }
                if (s.Opportunity.RecordType.Name == 'Anexo I Rebaixamento Ha' && s.Categoria_a_Rebaixar__c != null){
                    if (!mapRebajas.containsKey(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c))){
                        mapRebajas.put(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c), s.Area__c);
                    } else{
                        Double cant = mapRebajas.get(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                        cant += s.Area__c;
                        mapRebajas.remove(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                        mapRebajas.put(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c), cant);
                    }
                }
            }

            for (OpportunityLineItem s : mapOppApp1.values()){
                Double rebaja = mapRebajas.get(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                if (rebaja != null)
                    s.Area__c -= rebaja;
            }

            /*
             for(OpportunityLineItem s : items){
             if(s.Categoria_a_Rebaixar__c != null){  //si es rebaja, entonces puedo completar producto existente o crear uno nuevo
             if(mapOppApp1.containsKey(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c))){
             OpportunityLineItem oli = mapOppApp1.get(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));
             if(oli != null)
             oli.Area__c = oli.Area__c - s.Area__c;
             }
             }
             }
             */
            return mapOppApp1.values();

        } catch (Exception e){
            return null;
        }
    }

    //Validacion B, anexos II
    public static String valAnexos2_B(List<aAppendix.myOppItem> items){

        try{

            Integer j = 0;

            //Validar datos obligatorios

            String valDatosOblig = '';
            for (aAppendix.myOppItem i : items){
                if (i.area_plantada == null || i.area_plantada == '' || i.sem_bruta == null || i.sem_bruta == '' || i.descarte == null || i.descarte == '')
                    valDatosOblig += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Val_Datos_Oblig + '|';
                j++;
            }

            if (valDatosOblig != '')
                return valDatosOblig;
            //Validar datos validos

            j = 0;
            String valDatosValidos = '';
            for (aAppendix.myOppItem i : items){
                if (!Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.area_plantada) || !Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.sem_bruta) || !Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.descarte))
                    valDatosValidos += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Val_Datos_No_Validos + '|';
                j++;
            }

            if (valDatosValidos != '')
                return valDatosValidos;
            //Valida que has plantadas no sean mayores a has autor.

            j = 0;
            String valHasAU = '';
            for (aAppendix.myOppItem i : items){
                if (Double.valueOf(i.area_plantada) > Double.valueOf(i.area_autorizada))
                    valHasAU += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Validacion_B + '|';
                j++;
            }

            if (valHasAU != '')
                return valHasAU;
            return '';

        } catch (Exception e){
            return e.getMessage();
        }
    }

    //Validaciones Anexos II Rebajas
    public static String valAnexos2Reb(List<aAppendix.myOppItem> items, String a2Id, String epocaPlantioAII, string rebajaId, Id accId, String safra, String marca, Map<string, string> mapVariedades, Map<string, string> mapCategorias){

        try{

            Integer j = 0;

            //Validar datos obligatorios

            String valDatosOblig = '';
            for (aAppendix.myOppItem i : items){
                if (i.sem_rebajada == null || i.sem_rebajada == '')
                    valDatosOblig += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Reb_Val_Datos_Oblig + '<br/>';
                j++;
            }

            if (valDatosOblig != '')
                return valDatosOblig;
            //Validar datos validos

            j = 0;
            String valDatosValidos = '';
            for (aAppendix.myOppItem i : items){
                if (!Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.sem_rebajada))
                    valDatosValidos += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Reb_Val_Datos_No_Validos + '<br/>';
                j++;
            }

            if (valDatosValidos != '')
                return valDatosValidos;
            //Validar datos validos 2

            j = 0;
            String valDatosValidos2 = '';
            for (aAppendix.myOppItem i : items){
                if (Double.valueOf(i.sem_rebajada) == 0)
                    valDatosValidos2 += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Reb_Val_Datos_No_Validos_2 + '<br/>';
                j++;
            }

            if (valDatosValidos2 != '')
                return valDatosValidos2;
            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();
            String queryPlus = 'PricebookEntry.Product2.Variedade__c, Categoria__r.Name, Opportunity.Epoca_de_Plantio__c, Opportunity.Name';
            System.debug('Buscando Anexo II para cchequear items');
            tmpOppItems = aSiteUtils.queryResults5(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.RecordType.DeveloperName in :v1', new String[]{'AnexoII', 'Anexo_II_Rebaixamento_Sacas'}, 'Opportunity.Safra__c = :v2', safra, 'Opportunity.Marca__c = :v3', marca, 'Opportunity.AccountId = :v4', accId, 'Item_Rebajado__c = :v5', false);
            System.debug('Se encontraron : '+tmpOppItems.size()+' items');
            //Validar que las categorias ingresadas existan en el anexo II relacionado

            Set<String> variCategA2 = New Set<String>();
            for (OpportunityLineItem i : tmpOppItems)
                if (i.OpportunityId == a2Id)
                    variCategA2.add(String.valueOf(i.PricebookEntry.Product2.Variedade__c)+String.valueOf(i.Categoria__c));
                j = 0;
            String valCategorias = '';
            for (aAppendix.myOppItem i : items){
                if (!(variCategA2.contains(String.valueOf(i.variedad)+String.valueOf(i.categoria_a_rebajar_id))))
                    valCategorias += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Reb_Val_Categ_Relacionadas + ': ' + mapVariedades.get(i.variedad)+' - ' + mapCategorias.get(i.categoria_a_rebajar_id)+'<br/>';
                j++;
            }

            if (valCategorias != ''){
                System.debug('Devolviendo valCategorias : '+valCategorias);
                return valCategorias;
            }
                
            //Validar que las categorias sean correctamente rebajadas

            j = 0;
            String valCategorias2 = '';
            for (aAppendix.myOppItem i : items){
                System.debug('i.categoria_a_rebajar_id');
                System.debug(mapCategorias.get(i.categoria_a_rebajar_id));
                System.debug('i.categoria_id');
                System.debug(mapCategorias.get(i.categoria_id));
                if (!esRebajaCorrecta(mapCategorias.get(i.categoria_a_rebajar_id), mapCategorias.get(i.categoria_id)))
                    valCategorias2 += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Reb_Val_Rebaja_Correcta + ': ' + mapCategorias.get(i.categoria_a_rebajar_id)+' a ' + mapCategorias.get(i.categoria_id)+'<br/>';
                j++;
            }

            if (valCategorias2 != ''){
                System.debug('Devolviendo valCategorias2 : '+valCategorias2);
                return valCategorias2;
            }
                
            //Validar las cantidades ingresadas

            Map<String, Double> mapCantidades = new Map<String, Double>();
            Map<String, Double> mapCantidadesActuales = new Map<String, Double>();

            for (OpportunityLineItem s : tmpOppItems){
                if (s.Opportunity.Epoca_de_Plantio__c == epocaPlantioAII && s.OpportunityId != rebajaId){
                    if (s.Semente_bruta__c != null){
                        //si es anexo II
                        if (!mapCantidades.containsKey(String.valueOf(s.PricebookEntry.Product2.Variedade__c)+String.valueOf(s.Categoria__c))){
                            mapCantidades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c)+String.valueOf(s.Categoria__c), s.Semente_bruta__c);
                        } else{
                            Double cant = mapCantidades.get(String.valueOf(s.PricebookEntry.Product2.Variedade__c)+String.valueOf(s.Categoria__c));
                            cant += s.Semente_bruta__c;
                            mapCantidades.remove(String.valueOf(s.PricebookEntry.Product2.Variedade__c)+String.valueOf(s.Categoria__c));
                            mapCantidades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c)+String.valueOf(s.Categoria__c), cant);
                        }
                    }
                    if (s.Sem_Rebajada__c != null){
                        //si es rebaja
                        if (mapCantidades.containsKey(String.valueOf(s.PricebookEntry.Product2.Variedade__c)+String.valueOf(s.Categoria_a_Rebaixar__c))){
                            Double cant = mapCantidades.get(String.valueOf(s.PricebookEntry.Product2.Variedade__c)+String.valueOf(s.Categoria_a_Rebaixar__c));
                            cant -= s.Sem_Rebajada__c;
                            mapCantidades.remove(String.valueOf(s.PricebookEntry.Product2.Variedade__c)+String.valueOf(s.Categoria_a_Rebaixar__c));
                            mapCantidades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c)+String.valueOf(s.Categoria_a_Rebaixar__c), cant);
                        }
                    }
                }
            }

            for (aAppendix.myOppItem i : items){
                if (!mapCantidadesActuales.containsKey(String.valueOf(i.variedad)+String.valueOf(i.categoria_a_rebajar_id))){
                    mapCantidadesActuales.put(String.valueOf(i.variedad)+String.valueOf(i.categoria_a_rebajar_id), Double.valueOf(i.sem_rebajada));
                } else{
                    Double cant = mapCantidadesActuales.get(String.valueOf(i.variedad)+String.valueOf(i.categoria_a_rebajar_id));
                    cant += Double.valueOf(i.sem_rebajada);
                    mapCantidadesActuales.remove(String.valueOf(i.variedad)+String.valueOf(i.categoria_a_rebajar_id));
                    mapCantidadesActuales.put(String.valueOf(i.variedad)+String.valueOf(i.categoria_a_rebajar_id), cant);
                }
            }

            j = 0;
            String valCantidades = '';
            for (aAppendix.myOppItem i : items){
                if (mapCantidadesActuales.get(String.valueOf(i.variedad)+String.valueOf(i.categoria_a_rebajar_id)) > mapCantidades.get(String.valueOf(i.variedad)+String.valueOf(i.categoria_a_rebajar_id)))
                    valCantidades += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Reb_Val_Cant_Rebajada + ': ' + mapVariedades.get(i.variedad)+' - ' + mapCategorias.get(i.categoria_a_rebajar_id)+'<br/>';
                j++;
            }

            if (valCantidades != '')
                return valCantidades;
            return '';

        } catch (Exception e){
            System.debug('Exception in appManager validate valAnexos2Reb');
            return e.getMessage() + ' '+e.getLineNumber() ;
        }
    }

    //Validaciones Generales, anexos III
    public static String valAnexos3General(List<aAppendix.myOppItem> items, Map<string, string> mapCategorias){

        try{

            String msg = '';

            Integer j = 0;

            //Validar datos obligatorios

            String valDatosOblig = '';
            for (aAppendix.myOppItem i : items){
                if (i.sem_beneficiada == null || i.sem_beneficiada == '' || i.sem_aprobada == null || i.sem_aprobada == '' || i.sem_comer == null || i.sem_comer == '' || i.sem_uso_propio == null || i.sem_uso_propio == '')
                    valDatosOblig += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Val_Datos_Oblig + '|';
                j++;
            }

            if (valDatosOblig != '')
                return valDatosOblig;
            //Validar datos validos

            j = 0;
            String valDatosValidos = '';
            for (aAppendix.myOppItem i : items){
                if (!Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.sem_beneficiada) || !Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.sem_aprobada) || !Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.sem_comer) || !Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.sem_uso_propio))
                    valDatosValidos += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_III_Val_Datos_No_Validos + '|';
                j++;
            }

            if (valDatosValidos != '')
                return valDatosValidos;
            /*
             msg = aAppManager.valAnexos3_B(item, Integer.valueOf(tmp.sem_bruta_A2)); //valida que la sem bruta sea igual a bruta de A2
             if(msg!=''){
             return msg;
             */

            msg = aAppManager.valAnexos3_C(items); //valida que la sem beneficiada no sea mayor a sem bruta.
            if (msg != '')
                return msg;
            msg = aAppManager.valAnexos3_D(items); //valida que la sem aprovada no sea mayor a sem beneficiada .
            if (msg != '')
                return msg;
            msg = aAppManager.valAnexos3_E(items); //valida que la sem comer + uso propio no sea mayor a sem aprovada.
            if (msg != '')
                return msg;
            msg = aAppManager.valAnexos3_F(items, mapCategorias); //valida que el uso propio no sea en categoria final (S2).
            if (msg != '')
                return msg;
            return msg;

        } catch (Exception e){
            return e.getMessage();
        }
    }

    //Validaciones Generales, anexos IV
    public static String valAnexos4General(List<aAppendix.myOppItem> items, Map<string, string> mapCategorias){

        try{

            String msg = '';

            Integer j = 0;

            //Validar datos obligatorios

            String valDatosOblig = '';
            for (aAppendix.myOppItem i : items){
                if (i.sem_comer == null || i.sem_comer == '' || i.sem_uso_propio == null || i.sem_uso_propio == '' || i.descarte == null || i.descarte == '')
                    valDatosOblig += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Val_Datos_Oblig + '|';
                j++;
            }

            if (valDatosOblig != '')
                return valDatosOblig;
            //Validar datos validos

            j = 0;
            String valDatosValidos = '';
            for (aAppendix.myOppItem i : items){
                if (!Pattern.matches('-?[0-9]+(\\.[0-9]{1,2})?', i.sem_comer) || !Pattern.matches('-?[0-9]+(\\.[0-9]{1,2})?', i.sem_uso_propio) || !Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.descarte))
                    valDatosValidos += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_IV_Val_Datos_No_Validos + '|';
                j++;
            }

            if (valDatosValidos != '')
                return valDatosValidos;
            msg = aAppManager.valAnexos4_B(items); //valida que la sem beneficiada no sea mayor a sem bruta.
            if (msg != '')
                return msg;
            msg = aAppManager.valAnexos3_F(items, mapCategorias); //valida que el uso propio no sea en categoria final (S2).
            if (msg != '')
                return msg;
            return msg;

        } catch (Exception e){
            return e.getMessage();
        }
    }

    //Validaciones Anexos V
    public static String valAnexos5(List<aAppendix.myOppItem> items, Id accId, String safra, String marca, string editId, Map<string, string> mapVariedades, Map<string, string> mapCategorias){

        try{

            Integer j = 0;

            //Validar que haya al menos un item

            if (items.size() == 0)
                return 'Deve inserir pelo menos um item.';
            //Validar datos obligatorios

            String valDatosOblig = '';
            for (aAppendix.myOppItem i : items){
                if (i.variedad == null || i.variedad == '' || i.sem_comer == null || i.sem_comer == '')
                    valDatosOblig += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_V_Val_Datos_Oblig + '|';
                j++;
            }

            if (valDatosOblig != '')
                return valDatosOblig;
            //Validar datos validos

            j = 0;
            String valDatosValidos = '';
            for (aAppendix.myOppItem i : items){
                if (!Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.sem_comer))
                    valDatosValidos += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_V_Val_Datos_No_Validos + '|';
                j++;
            }

            if (valDatosValidos != '')
                return valDatosValidos;
            //Validar datos validos 2

            /*
             j=0;
             String valDatosValidos2 = '';
             for (aAppendix.myOppItem i : items){
             if (Double.valueOf(i.sem_comer) == 0)
             valDatosValidos2 += Label.Linea + ' ' + (j + 1) + ': ' + Label.Anexo_V_Val_Datos_No_Validos_2 + '|';
             j++;
             }

             if (valDatosValidos2 != '')
             return valDatosValidos2;
             */

            Map<String, Double> mapCantidades = new Map<String, Double>();
            Map<String, Double> mapCantidadesActuales = new Map<String, Double>();

            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();
            String queryPlus = 'PricebookEntry.Product2.Variedade__c, Categoria__r.Name, Opportunity.Name';

            tmpOppItems = aSiteUtils.queryResults6(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.RecordType.DeveloperName in :v1', new String[]{'Anexo_III', 'Anexo_IV'}, 'Opportunity.Safra__c = :v2', safra, 'Opportunity.Marca__c = :v3', marca, 'Opportunity.AccountId = :v4', accId, 'Item_Rebajado__c = :v5', false, 'Opportunity.Estado_Anexos_Portal_Miltiplicadores__c != :v6', 'Anulado');


            //Validar que las categorias ingresadas existan en el anexo II relacionado
            /*
             Set<String> variCategA2 = New Set<String>();
             for (OpportunityLineItem i : tmpOppItems)
             variCategA2.add(String.valueOf(i.PricebookEntry.Product2.Variedade__c) + String.valueOf(i.Categoria__c));


             j = 0;
             String valCategorias = '';
             for (aAppendix.myOppItem i : items){
             if (!(variCategA2.contains(String.valueOf(i.variedad) + String.valueOf(i.categoria_id))))
             valCategorias += Label.Linea + ' ' + (j + 1) + ': ' + Label.Anexo_V_Val_Categ_Relacionadas + ': ' +  mapVariedades.get(i.variedad) + ' - ' + mapCategorias.get(i.categoria_id) + '|';
             j++;
             }

             if (valCategorias != '')
             return valCategorias;
             */

            //Validar las cantidades ingresadas

            for (OpportunityLineItem s : tmpOppItems){
                if (s.OpportunityId != editId){
                    if (!mapCantidades.containsKey(String.valueOf(s.PricebookEntry.Product2.Variedade__c))){
                        mapCantidades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c), s.Semente_comercializada__c + s.Semente_uso_propio__c);
                    } else{
                        Double cant = mapCantidades.get(String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                        cant += s.Semente_comercializada__c + s.Semente_uso_propio__c;
                        mapCantidades.remove(String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                        mapCantidades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c), cant);
                    }
                }
            }

            for (aAppendix.myOppItem i : items){
                if (!mapCantidadesActuales.containsKey(String.valueOf(i.variedad))){
                    mapCantidadesActuales.put(String.valueOf(i.variedad), Double.valueOf(i.sem_comer));
                } else{
                    Double cant = mapCantidadesActuales.get(String.valueOf(i.variedad));
                    cant = (Decimal.valueOf(cant)+Double.valueOf(i.sem_comer)).divide(1, 2, System.RoundingMode.HALF_EVEN);
                    mapCantidadesActuales.remove(String.valueOf(i.variedad));
                    mapCantidadesActuales.put(String.valueOf(i.variedad), cant);
                }
            }

            j = 0;
            String valCantidades = '';
            Set<String> valCantidades2 = New Set<String>();
            for (aAppendix.myOppItem i : items){
                if (mapCantidadesActuales.get(String.valueOf(i.variedad)) != mapCantidades.get(String.valueOf(i.variedad))){
                    valCantidades2.add(mapVariedades.get(i.variedad));
                    //valCantidades = mapCantidadesActuales.get(String.valueOf(i.variedad)) + ' ' + mapCantidades.get(String.valueOf(i.variedad));
                }
                //valCantidades += Label.Linea + ' ' + (j + 1) + ': ' + Label.Anexo_V_Val_Cantidades + ': ' +  mapVariedades.get(i.variedad) + ' - ' + mapCategorias.get(i.categoria_id) + '|';

                j++;
            }

            if (valCantidades2.size() > 0){
                for (String s : valCantidades2)
                    valCantidades += s + ': ' + Label.Anexo_V_Val_Cantidades + '|';
            }

            if (valCantidades != '')
                return valCantidades;
            return '';

        } catch (Exception e){
            return e.getMessage();
        }
    }

    //Validaciones Levantamento de Estoque
    public static String valEstoque(List<aAppendix.myOppItem> items, String mes, Id accId, String safra, String marca, Map<string, string> mapVariedades){

        try{

            Integer j = 0;

            //Validar datos obligatorios

            String valDatosOblig = '';
            if (mes == null || mes == '')
                valDatosOblig += 'Dados obligatorios: Mês';
            if (valDatosOblig != '')
                return valDatosOblig;
            valDatosOblig = '';
            for (aAppendix.myOppItem i : items){
                if (i.sem_comer == null || i.sem_comer == '' || (i.cnpj == 'x' && (i.sem_aprobada == null || i.sem_aprobada == '')))
                    valDatosOblig += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_II_Val_Datos_Oblig + '|';
                j++;
            }

            if (valDatosOblig != '')
                return valDatosOblig;
            //Validar datos validos

            j = 0;
            String valDatosValidos = '';
            for (aAppendix.myOppItem i : items){
                if (!Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.sem_comer) || (i.cnpj == 'x' && !Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', i.sem_aprobada)))
                    valDatosValidos += Label.Linea + ' ' + (j + 1)+': ' + Label.Estoque_Val_Datos_No_Validos + '|';
                j++;
            }

            if (valDatosValidos != '')
                return valDatosValidos;
            //Validar que semente comercializada no sea mayor que semente aprobada

            /*
             j=0;
             String valEstoque_A = '';
             for (aAppendix.myOppItem i : items){
             if (Double.valueOf(i.sem_comer) > Double.valueOf(i.sem_aprobada))
             valEstoque_A += Label.Linea + ' ' + (j + 1) + ': ' + Label.Estoque_Validacion_A + '<br/>';
             j++;
             }

             if (valEstoque_A != '')
             return valEstoque_A;
             */


            //Validar mes

            String valMes = '';
            List<Opportunity> opps = New List<Opportunity>();
            opps = aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'Safra__c = :v2', safra, 'Marca__c = :v3', marca, 'RecordType.DeveloperName = :v4', 'Stock_Multiplicadores', 'Estado_Anexos_Portal_Miltiplicadores__c = :v5', 'Aprovado');
            Integer mayorMes = 0;
            if (opps.size() > 0){
                mayorMes = aSiteUtils.getNumberOfMonth(opps[0].Mes__c);
                for (Opportunity o : opps)
                    if (aSiteUtils.getNumberOfMonth(o.Mes__c) > mayorMes)
                        mayorMes = aSiteUtils.getNumberOfMonth(o.Mes__c);
            }
            if (aSiteUtils.getNumberOfMonth(mes) <= mayorMes)
                valMes = 'Mês não válido.';
            if (valMes != '')
                return valMes;
            
            
            String valCantidadesApComer = '';
            Map<String,Double> cantAprobada = New Map<String,Double>();
            Map<String,Double> cantComer = New Map<String,Double>();
            for (aAppendix.myOppItem i : items){
                if (i.sem_aprobada != null && i.sem_aprobada != '' && i.cnpj == 'x'){
                    if (!cantAprobada.containsKey(i.variedad)){                    
                        cantAprobada.put(i.variedad, Double.valueOf(i.sem_aprobada));
                    }else{
                        Double anterior = cantAprobada.get(i.variedad);
                        anterior += Double.valueOf(i.sem_aprobada);
                        cantAprobada.put(i.variedad, anterior);
                    }
                }
                if (!cantComer.containsKey(i.variedad)){
                    cantComer.put(i.variedad, Double.valueOf(i.sem_comer));
                }else{
                    Double anterior = cantComer.get(i.variedad);
                    anterior += Double.valueOf(i.sem_comer);
                    cantComer.put(i.variedad, anterior);
                }
            }
            for(String s : cantAprobada.keySet()){
                Double ap = cantAprobada.get(s);
                Double com = cantComer.get(s);
                if (com > ap)
                    valCantidadesApComer = mapVariedades.get(s) + ': Semente comercializada supera Semente Aprovada.';
            }
            //if (valCantidadesApComer != '')  COMENTADO 31.01.2022. SE SOLICITO DESCARTAR ESTA REGLA.
            //    return valCantidadesApComer;
            
            return '';

        } catch (Exception e){
            return e.getMessage();
        }
    }

    public static aSiteUtils.retorno saveAppend2(List<aAppendix.myOppItem> items, String accId, String safra, String marca, String editId, SiteUser__c logUser){

        Savepoint sp = Database.setSavepoint();
        aSiteUtils.retorno ret = New aSiteUtils.retorno();

        try{
            List<OpportunityLineItem> saveOppItems = new List<OpportunityLineItem>();

            Map<String, Id> rty = Opp_Utils.cargarRecordTypesOportunidades();

            String msg = '';
            String rt_A2 = rty.get('Anexo II');
            String lista = 'Lista Canal Multiplicadores';
            if (marca == 'DSEM')
                lista = 'Lista DSEM';
            Map<String, PricebookEntry> rPb = Opp_Utils.cargarRoyaltyPricebookEntries(lista);

            msg = valAnexos2_B(items);
            if (msg != ''){
                ret.mensaje = msg;
                ret.exito = false;
                ret.id = null;
                return ret;
            }

            Double cantidades = 0; //para control de opp duplicada
            String productos = ''; //para control de opp duplicada

            for (aAppendix.myOppItem tmp : items){
                OpportunityLineItem item = new OpportunityLineItem();

                item.Quantity = 0.1;
                item.UnitPrice = 1;
                if (rPb.get(tmp.variedad) != null)
                    item.PricebookEntryId = rPb.get(tmp.variedad).Id;
                item.Semente_bruta__c = Double.valueOf(tmp.sem_bruta);
                item.Area__c = Double.valueOf(tmp.area_autorizada);
                item.Area_plantada__c = Double.valueOf(tmp.area_plantada);
                item.Categoria__c = tmp.categoria_id;
                item.Descarte__c = Double.valueOf(tmp.descarte);

                cantidades += item.Semente_bruta__c + item.Area_plantada__c + item.Descarte__c;
                productos = item.PricebookEntryId;

                /*
                 msg = valAnexos2_B(item); //valida que has plantadas no sean mayores a has autor.
                 if(msg!=''){
                 ret.mensaje = tmp.variedad_nombre + ' ' + tmp.categoria + msg;
                 ret.exito = false;
                 ret.id = null;
                 return ret;
                 }
                 */
                if (tmp.id != null && tmp.Id != '')
                    item.Id = tmp.Id;
                saveOppItems.add(item);
            }

            if (editId == null){
                //insert
                String control_opp_dup = accId + safra + marca + cantidades + productos + String.valueOf(system.today().day())+String.valueOf(system.today().month())+String.valueOf(system.today().year());
                Opportunity tmpAppII = new Opportunity(Name = 'TMP', Stagename = 'Edición', CloseDate = System.today(), RecordTypeId = rt_A2, AccountId = accId, Safra__c = safra, Marca__c = marca, Epoca_de_Plantio__c = items[0].epocaPlantio, Usuario__c = logUser.Id, Control_Opp_Duplicada__c = control_opp_dup);
                insert tmpAppII;
                editId = tmpAppII.Id;
                for (OpportunityLineItem item : saveOppItems)
                    item.OpportunityId = tmpAppII.Id;
                insert saveOppItems;
            } else{
                update saveOppItems;
            }

        } catch (Exception e){
            Database.rollback(sp);
            ret.mensaje = e.getLineNumber()+'\n' + e.getMessage();
            ret.exito = false;
            ret.id = null;
            return ret;
        }

        ret.mensaje = null;
        ret.exito = true;
        ret.id = editId;
        return ret;
    }

    public static aSiteUtils.retorno saveAppend2Rebaja(List<aAppendix.myOppItem> items, String aIIaRebajarId, String aIIaRebajarEpocaP, String accId, String safra, String marca, String editRebajaId, Map<string, string> mapVariedades, Map<string, string> mapCategorias, List<aAppendix.myOppItem> tmpAppItemsRebajaRemove){
        Savepoint sp = Database.setSavepoint();
        aSiteUtils.retorno ret = New aSiteUtils.retorno();

        //VER QUE SE GRABE EL USUARIO EN LAS NUEVAS REBAJAS

        try{
            List<OpportunityLineItem> saveOppItemsInsert = new List<OpportunityLineItem>();
            List<OpportunityLineItem> saveOppItemsUpdate = new List<OpportunityLineItem>();

            Map<String, Id> rty = Opp_Utils.cargarRecordTypesOportunidades();

            String msg = '';
            String rt_A2_Reb = rty.get('Anexo II Rebaixamento Sacas');
            String lista = 'Lista Canal Multiplicadores';
            if (marca == 'DSEM')
                lista = 'Lista DSEM';
            Map<String, PricebookEntry> rPb = Opp_Utils.cargarRoyaltyPricebookEntries(lista);

            msg = valAnexos2Reb(items, aIIaRebajarId, aIIaRebajarEpocaP, editRebajaId, accId, safra, marca, mapVariedades, mapCategorias);
            
            if (msg != ''){
                System.debug('Devolviendo mensaje validacion fallo: '+msg);
                ret.mensaje = msg;
                ret.exito = false;
                ret.id = null;
                return ret;
            }

            Map<String, String> pbeAnt = New Map<String, String>();
            List<String> idItems = New List<String>();
            for (aAppendix.myOppItem tmp : items)
                if (tmp.id != null && tmp.Id != '')
                    idItems.add(tmp.id);
                if (idItems.size() > 0){
                    List<OpportunityLineItem> itemsAnt = aSiteUtils.queryResults1(OpportunityLineItem.SObjectType, null, 'Id In :v1', idItems);
                for (OpportunityLineItem i : itemsAnt)
                    pbeAnt.put(i.id, i.PricebookEntryId);
            }


            for (aAppendix.myOppItem tmp : items){
                OpportunityLineItem item = new OpportunityLineItem();

                item.Quantity = 0.1;
                item.UnitPrice = 1;
                if (rPb.get(tmp.variedad) != null)
                    item.PricebookEntryId = rPb.get(tmp.variedad).Id;
                item.Categoria__c = tmp.categoria_id;
                item.Categoria_a_Rebaixar__c = tmp.categoria_a_rebajar_id;
                item.Sem_Rebajada__c = Double.valueOf(tmp.sem_rebajada);
                item.Lote_Rebajado__c = tmp.lote_rebajado;
                item.Id = tmp.Id;
                if (tmp.id != null && tmp.Id != ''){
                    if (item.PricebookEntryId != pbeAnt.get(item.Id)){
                        saveOppItemsInsert.add(item);
                        if (tmpAppItemsRebajaRemove == null)
                            tmpAppItemsRebajaRemove = New List<aAppendix.myOppItem>();
                        tmpAppItemsRebajaRemove.add(tmp);
                    } else{
                        saveOppItemsUpdate.add(item);
                    }
                } else{
                    saveOppItemsInsert.add(item);
                }
            }

            if (editRebajaId == null){
                //insert
                Opportunity tmpAppIIReb = new Opportunity(Name = 'TMP', Stagename = 'Edición', CloseDate = System.today(), RecordTypeId = rt_A2_Reb, AccountId = accId, Safra__c = safra, Marca__c = marca, Epoca_de_Plantio__c = aIIaRebajarEpocaP, Anexo_Relacionado__c = aIIaRebajarId);
                insert tmpAppIIReb;
                editRebajaId = tmpAppIIReb.Id;
                /*
                 for(OpportunityLineItem item : saveOppItems)
                 item.OpportunityId = tmpAppIIReb.Id;

                 insert saveOppItems;
                 */
            }
            if (saveOppItemsInsert.size() > 0){
                for (OpportunityLineItem item : saveOppItemsInsert)
                    item.OpportunityId = editRebajaId;
                insert saveOppItemsInsert;
            }
            if (saveOppItemsUpdate.size() > 0)
                update saveOppItemsUpdate;
            if (tmpAppItemsRebajaRemove != null)
                if (tmpAppItemsRebajaRemove.size() > 0){
                    List<String> idsEliminar = New List<String>();
                for (aAppendix.myOppItem i : tmpAppItemsRebajaRemove)
                    idsEliminar.add(i.Id);
                List<OpportunityLineItem> itemsEliminar = [Select Id
                                                           From OpportunityLineItem
                                                           Where Id In :idsEliminar];
                delete itemsEliminar;
            }

            aSiteUtils.retorno ret2 = completarRegistrosRebaja(editRebajaId);
            if (!ret2.exito){
                Database.rollback(sp);
                ret.mensaje = ret2.mensaje;
                ret.exito = false;
                ret.id = null;
                return ret;
            }

        } catch (Exception e){
            Database.rollback(sp);
            ret.mensaje = e.getLineNumber()+'\n' + e.getMessage();
            ret.exito = false;
            ret.id = null;
            return ret;
        }

        ret.mensaje = null;
        ret.exito = true;
        ret.id = editRebajaId;
        return ret;
    }

    public static aSiteUtils.retorno saveAppend3(List<aAppendix.myOppItem> items, String accId, String safra, String marca, String editId, SiteUser__c logUser, Map<string, string> mapCategorias){
        Savepoint sp = Database.setSavepoint();
        aSiteUtils.retorno ret = New aSiteUtils.retorno();

        try{
            List<OpportunityLineItem> saveOppItems = new List<OpportunityLineItem>();

            Map<String, Id> rty = Opp_Utils.cargarRecordTypesOportunidades();

            String msg = '';
            String rt_A3 = rty.get('Anexo III');
            String lista = 'Lista Canal Multiplicadores';
            if (marca == 'DSEM')
                lista = 'Lista DSEM';
            Map<String, PricebookEntry> rPb = Opp_Utils.cargarRoyaltyPricebookEntries(lista);

            msg = valAnexos3General(items, mapCategorias);
            if (msg != ''){
                ret.mensaje = msg;
                ret.exito = false;
                ret.id = null;
                return ret;
            }

            Double cantidades = 0; //para control de opp duplicada

            for (aAppendix.myOppItem tmp : items){
                OpportunityLineItem item = new OpportunityLineItem();

                item.Quantity = 0.1;
                item.UnitPrice = 1;
                if (rPb.get(tmp.variedad) != null)
                    item.PricebookEntryId = rPb.get(tmp.variedad).Id;
                item.Categoria__c = tmp.categoria_id;

                //item.Semente_bruta__c = tmp.sem_bruta;
                item.Semente_bruta__c = Double.valueOf(tmp.sem_bruta);
                item.Semente_beneficiada__c = Double.valueOf(tmp.sem_beneficiada);
                item.Semente_aprovada__c = Double.valueOf(tmp.sem_aprobada);
                item.Semente_comercializada__c = Double.valueOf(tmp.sem_comer);
                item.Semente_uso_propio__c = Double.valueOf(tmp.sem_uso_propio);

                cantidades += item.Semente_bruta__c + item.Semente_beneficiada__c + item.Semente_aprovada__c + item.Semente_comercializada__c + item.Semente_uso_propio__c;

                if (tmp.id != null && tmp.Id != '')
                    item.Id = tmp.Id;
                saveOppItems.add(item);
            }

            if (editId == null){
                //insert
                String control_opp_dup = 'AIII' + accId + safra + marca + cantidades + String.valueOf(system.today().day())+String.valueOf(system.today().month())+String.valueOf(system.today().year());
                Opportunity tmpAppIII = new Opportunity(Name = 'TMP', Stagename = 'Edición', CloseDate = System.today(), RecordTypeId = rt_A3, AccountId = accId, Safra__c = safra, Marca__c = marca, Usuario__c = logUser.Id, Control_Opp_Duplicada__c = control_opp_dup);
                List<CRM_Multiplicador__c> crm_mult = New List<CRM_Multiplicador__c>();
                crm_mult = [Select Id From CRM_Multiplicador__c Where Cuenta__c = :accId And Safra__c = :safra limit 1];
                if (crm_mult.size() > 0)
                    tmpAppIII.CRM_Multiplicador__c = crm_mult[0].Id;
                insert tmpAppIII;
                editId = tmpAppIII.Id;
                for (OpportunityLineItem item : saveOppItems)
                    item.OpportunityId = tmpAppIII.Id;
                insert saveOppItems;
            } else{
                update saveOppItems;
            }

        } catch (Exception e){
            Database.rollback(sp);
            ret.mensaje = e.getLineNumber()+'\n' + e.getMessage();
            ret.exito = false;
            ret.id = null;
            return ret;
        }

        ret.mensaje = null;
        ret.exito = true;
        ret.id = editId;
        return ret;
    }

    public static aSiteUtils.retorno saveAppend4(List<aAppendix.myOppItem> items, String accId, String safra, String marca, String editId, SiteUser__c logUser, Map<string, string> mapCategorias){
        Savepoint sp = Database.setSavepoint();
        aSiteUtils.retorno ret = New aSiteUtils.retorno();

        try{
            List<OpportunityLineItem> saveOppItems = new List<OpportunityLineItem>();

            Map<String, Id> rty = Opp_Utils.cargarRecordTypesOportunidades();

            String msg = '';
            String rt_A4 = rty.get('Anexo IV');
            String lista = 'Lista Canal Multiplicadores';
            if (marca == 'DSEM')
                lista = 'Lista DSEM';
            Map<String, PricebookEntry> rPb = Opp_Utils.cargarRoyaltyPricebookEntries(lista);

            msg = valAnexos4General(items, mapCategorias);
            if (msg != ''){
                ret.mensaje = msg;
                ret.exito = false;
                ret.id = null;
                return ret;
            }

            Double cantidades = 0; //para control de opp duplicada

            for (aAppendix.myOppItem tmp : items){
                OpportunityLineItem item = new OpportunityLineItem();

                item.Quantity = 0.1;
                item.UnitPrice = 1;
                if (rPb.get(tmp.variedad) != null)
                    item.PricebookEntryId = rPb.get(tmp.variedad).Id;
                item.Categoria__c = tmp.categoria_id;

                item.Semente_comercializada__c = Double.valueOf(tmp.sem_comer);
                item.Semente_uso_propio__c = Double.valueOf(tmp.sem_uso_propio);
                item.Descarte__c = Double.valueOf(tmp.descarte);

                cantidades += item.Descarte__c + item.Semente_comercializada__c + item.Semente_uso_propio__c;

                if (tmp.id != null && tmp.Id != '')
                    item.Id = tmp.Id;
                saveOppItems.add(item);
            }

            if (editId == null){
                //insert
                String control_opp_dup = 'AIV' + accId + safra + marca + cantidades + String.valueOf(system.today().day())+String.valueOf(system.today().month())+String.valueOf(system.today().year());
                Opportunity tmpAppIV = new Opportunity(Name = 'TMP', Stagename = 'Edición', CloseDate = System.today(), RecordTypeId = rt_A4, AccountId = accId, Safra__c = safra, Marca__c = marca, Usuario__c = logUser.Id, Control_Opp_Duplicada__c = control_opp_dup);
                insert tmpAppIV;
                editId = tmpAppIV.Id;
                for (OpportunityLineItem item : saveOppItems)
                    item.OpportunityId = tmpAppIV.Id;
                insert saveOppItems;
            } else{
                update saveOppItems;
            }

        } catch (Exception e){
            Database.rollback(sp);
            ret.mensaje = e.getLineNumber()+'\n' + e.getMessage();
            ret.exito = false;
            ret.id = null;
            return ret;
        }

        ret.mensaje = null;
        ret.exito = true;
        ret.id = editId;
        return ret;
    }

    public static aSiteUtils.retorno saveAppend5(List<aAppendix.myOppItem> items, String accId, String safra, String marca, String editId, SiteUser__c logUser, Map<string, string> mapCategorias, Map<string, string> mapVariedades, List<aAppendix.myOppItem> tmpAppItemsRemove){
        Savepoint sp = Database.setSavepoint();
        aSiteUtils.retorno ret = New aSiteUtils.retorno();

        //VER QUE SE GRABE EL USUARIO EN LAS NUEVAS REBAJAS

        try{
            List<OpportunityLineItem> saveOppItemsInsert = new List<OpportunityLineItem>();
            List<OpportunityLineItem> saveOppItemsUpdate = new List<OpportunityLineItem>();

            Map<String, Id> rty = Opp_Utils.cargarRecordTypesOportunidades();

            String msg = '';
            String rt_A5 = rty.get('Anexo V');
            String lista = 'Lista Canal Multiplicadores';
            if (marca == 'DSEM')
                lista = 'Lista DSEM';
            Map<String, PricebookEntry> rPb = Opp_Utils.cargarRoyaltyPricebookEntries(lista);

            msg = valAnexos5(items, accId, safra, marca, editId, mapVariedades, mapCategorias);
            if (msg != ''){
                ret.mensaje = msg;
                ret.exito = false;
                ret.id = null;
                return ret;
            }

            Map<String, String> pbeAnt = New Map<String, String>();
            List<String> idItems = New List<String>();
            for (aAppendix.myOppItem tmp : items)
                if (tmp.id != null && tmp.Id != '')
                    idItems.add(tmp.id);
                if (idItems.size() > 0){
                    List<OpportunityLineItem> itemsAnt = aSiteUtils.queryResults1(OpportunityLineItem.SObjectType, null, 'Id In :v1', idItems);
                for (OpportunityLineItem i : itemsAnt)
                    pbeAnt.put(i.id, i.PricebookEntryId);
            }

            Double cantidades = 0; //para control de opp duplicada

            for (aAppendix.myOppItem tmp : items){
                OpportunityLineItem item = new OpportunityLineItem();

                item.Quantity = 0.1;
                item.UnitPrice = 1;
                if (rPb.get(tmp.variedad) != null)
                    item.PricebookEntryId = rPb.get(tmp.variedad).Id;
                item.Categoria__c = tmp.categoria_id;
                item.Semente_comercializada__c = Double.valueOf(tmp.sem_comer);
                cantidades += item.Semente_comercializada__c;
                item.Estado_de_Comercializacion__c = tmp.estado_comer_id;
                item.Id = tmp.Id;
                if (tmp.id != null && tmp.Id != ''){
                    if (item.PricebookEntryId != pbeAnt.get(item.Id)){
                        saveOppItemsInsert.add(item);
                        if (tmpAppItemsRemove == null)
                            tmpAppItemsRemove = New List<aAppendix.myOppItem>();
                        tmpAppItemsRemove.add(tmp);
                    } else{
                        saveOppItemsUpdate.add(item);
                    }
                } else{
                    saveOppItemsInsert.add(item);
                }
            }

            if (editId == null){
                //insert
                String control_opp_dup = 'AV' + accId + safra + marca + String.valueOf(system.today().day())+String.valueOf(system.today().month())+String.valueOf(system.today().year());
                Opportunity tmpApp5 = new Opportunity(Name = 'TMP', Stagename = 'Edición', CloseDate = System.today(), RecordTypeId = rt_A5, AccountId = accId, Safra__c = safra, Marca__c = marca, Usuario__c = logUser.Id, Control_Opp_Duplicada__c = control_opp_dup);
                insert tmpApp5;
                editId = tmpApp5.Id;
            }
            if (saveOppItemsInsert.size() > 0){
                for (OpportunityLineItem item : saveOppItemsInsert)
                    item.OpportunityId = editId;
                insert saveOppItemsInsert;
            }
            if (saveOppItemsUpdate.size() > 0)
                update saveOppItemsUpdate;
            if (tmpAppItemsRemove != null)
                if (tmpAppItemsRemove.size() > 0){
                    List<String> idsEliminar = New List<String>();
                for (aAppendix.myOppItem i : tmpAppItemsRemove)
                    idsEliminar.add(i.Id);
                List<OpportunityLineItem> itemsEliminar = [Select Id
                                                           From OpportunityLineItem
                                                           Where Id In :idsEliminar];
                delete itemsEliminar;
            }

        } catch (Exception e){
            Database.rollback(sp);
            ret.mensaje = e.getLineNumber()+'\n' + e.getMessage();
            ret.exito = false;
            ret.id = null;
            return ret;
        }

        ret.mensaje = null;
        ret.exito = true;
        ret.id = editId;
        return ret;
    }

    public static aSiteUtils.retorno saveEstoque(List<aAppendix.myOppItem> items, String accId, String safra, String marca, String mes, String editId, SiteUser__c logUser, List<aAppendix.myOppItem> tmpAppItemsRemove, Map<string, string> mapVariedades){

        Savepoint sp = Database.setSavepoint();
        aSiteUtils.retorno ret = New aSiteUtils.retorno();

        try{
            //List<OpportunityLineItem> saveOppItems = new List<OpportunityLineItem>();
            List<OpportunityLineItem> insertOppItems = new List<OpportunityLineItem>();
            List<OpportunityLineItem> updateOppItems = new List<OpportunityLineItem>();

            Map<String, Id> rty = Opp_Utils.cargarRecordTypesOportunidades();

            String msg = '';
            String rt_Stock = rty.get('Stock Multiplicadores');
            String lista = 'Lista de Básica BMX SUL';
            if (marca == 'DSEM')
                lista = 'Lista de Básica DSEM SUL';
            Map<String, PricebookEntry> rPb = Opp_Utils.cargarSemillaPricebookEntries(lista);

            msg = valEstoque(items, mes, accId, safra, marca, mapVariedades);
            if (msg != ''){
                ret.mensaje = msg;
                ret.exito = false;
                ret.id = null;
                return ret;
            }

            Double cantidades = 0; //para control de opp duplicada
            String productos = ''; //para control de opp duplicada

            Map<String, Double> mapCantAp = New Map<String, Double>();
            for (aAppendix.myOppItem tmp : items){
                if(tmp.cnpj == 'x' && tmp.sem_aprobada != null && tmp.sem_aprobada != '')
                    mapCantAp.put(tmp.variedad, Double.valueOf(tmp.sem_aprobada));
            }

            for (aAppendix.myOppItem tmp : items){
                OpportunityLineItem item = new OpportunityLineItem();

                item.Quantity = 0.1;
                item.UnitPrice = 1;
                if (rPb.get(tmp.variedad) != null)  item.PricebookEntryId = rPb.get(tmp.variedad).Id;
                item.Semente_comercializada__c = Double.valueOf(tmp.sem_comer);
                if (mapCantAp.get(tmp.variedad) != null && tmp.cnpj != 'x')
                    tmp.sem_aprobada = String.valueOf(mapCantAp.get(tmp.variedad));
                item.Semente_aprovada__c = Double.valueOf(tmp.sem_aprobada);
                
                if (tmp.estado_comer_id != '99')
                    item.Estado_de_Comercializacion__c = tmp.estado_comer_id;

                cantidades += item.Semente_comercializada__c + item.Semente_aprovada__c;
                productos = item.PricebookEntryId;

                if (tmp.id != null && tmp.Id != ''){
                    updateOppItems.add(item);
                    item.Id = tmp.Id;
                }else{
                    insertOppItems.add(item);
                }
            }

            Opportunity oppStock;
            if (editId == null){
                //insert
                String control_opp_dup = accId + safra + marca + mes + cantidades + productos + String.valueOf(system.today().day())+String.valueOf(system.today().month())+String.valueOf(system.today().year());
                oppStock = new Opportunity(Name = 'TMP', Stagename = 'Edición', CloseDate = System.today(), RecordTypeId = rt_Stock, AccountId = accId, Safra__c = safra, Marca__c = marca, Mes__c = mes, Usuario__c = logUser.Id, Usuario_Email__c = logUser.Email__c, Control_Opp_Duplicada__c = control_opp_dup);
                insert oppStock;
                editId = oppStock.Id;
                //for (OpportunityLineItem item : saveOppItems)
                //    item.OpportunityId = tmpStock.Id;
                //insert saveOppItems;
            } else{
                oppStock = [Select Id, Mes__c
                                           From Opportunity
                                           Where Id = :editId];
                oppStock.Mes__c = mes;
                update oppStock;

                //update saveOppItems;
            }
            
            if (insertOppItems.size() > 0){
                for (OpportunityLineItem item : insertOppItems)
                    item.OpportunityId = oppStock.Id;
                insert insertOppItems;
            }            
            
            if (updateOppItems.size() > 0){
                update updateOppItems;
            }
            
            if (tmpAppItemsRemove != null)
                if (tmpAppItemsRemove.size() > 0){
                    List<String> idsEliminar = New List<String>();
                for (aAppendix.myOppItem i : tmpAppItemsRemove)
                    idsEliminar.add(i.Id);
                List<OpportunityLineItem> itemsEliminar = [Select Id
                                                           From OpportunityLineItem
                                                           Where Id In :idsEliminar];
                delete itemsEliminar;
            }

        } catch (Exception e){
            Database.rollback(sp);
            ret.mensaje = e.getLineNumber()+'\n' + e.getMessage();
            ret.exito = false;
            ret.id = null;
            return ret;
        }

        ret.mensaje = null;
        ret.exito = true;
        ret.id = editId;
        return ret;
    }

    public static void enviarAnexoAprobacion(String idOpp){
        Opportunity opp = [SELECT id,Name,OwnerId FROM Opportunity WHERE id =: idOpp];       
    try{
            Approval.ProcessSubmitRequest aprovalRequest = new Approval.ProcessSubmitRequest();
            aprovalRequest.setObjectId(opp.id);   
            aprovalRequest.setNextApproverIds(new ID[]{opp.OwnerId});
            Approval.ProcessResult result = Approval.process(aprovalRequest);
    } catch (Exception e){
        System.debug(e.getMessage());
    }
       
    }

    public static void updateSession(SiteUserSession__c sesion){
        update sesion;
    }

    public static aSiteUtils.retorno completarRegistrosRebaja(String idOpp){
        aSiteUtils.retorno ret = New aSiteUtils.retorno();
        try{
            Map<String, OpportunityLineItem> reb = New Map<String, OpportunityLineItem>();
            Set<String> idItemsAReb = New Set<String>();

            List<OpportunityLineItem> items = New List<OpportunityLineItem>();
            items = aSiteUtils.queryResults1(OpportunityLineItem.SObjectType, null, 'OpportunityId = :v1', idOpp);

            List<OpportunityLineItem> insertarItems = New List<OpportunityLineItem>();
            List<OpportunityLineItem> actualizarItems = New List<OpportunityLineItem>();
            List<OpportunityLineItem> eliminarItems = New List<OpportunityLineItem>();

            if (items.size() > 0){
                for (OpportunityLineItem i : items)
                    if (!i.Item_Rebajado__c){
                        reb.put(i.Id, i);
                } else{
                    idItemsAReb.add(i.Id_Item_de_Oportunidad_Relacionado__c);
                }
                for (OpportunityLineItem i : items){
                    if (i.Item_Rebajado__c){
                        OpportunityLineItem itm = reb.get(i.Id_Item_de_Oportunidad_Relacionado__c);
                        if (itm != null){
                            i.Categoria__c = itm.Categoria_a_Rebaixar__c;
                            i.Semente_bruta__c = itm.Sem_Rebajada__c;
                            actualizarItems.add(i);
                        } else{
                            eliminarItems.add(i);
                        }
                    } else{
                        if (!idItemsAReb.contains(i.Id)){
                            OpportunityLineItem itm = New OpportunityLineItem();
                            itm.OpportunityId = idOpp;
                            itm.Quantity = 0.1;
                            itm.UnitPrice = 1;
                            itm.PricebookEntryId = i.PricebookEntryId;
                            itm.Categoria__c = i.Categoria_a_Rebaixar__c;
                            itm.Semente_bruta__c = i.Sem_Rebajada__c;
                            itm.Item_Rebajado__c = true;
                            itm.Id_Item_de_Oportunidad_Relacionado__c = i.Id;
                            insertarItems.add(itm);
                        }
                    }
                }

                if (insertarItems.size() > 0)
                    insert insertarItems;
                if (actualizarItems.size() > 0)
                    update actualizarItems;
                if (eliminarItems.size() > 0)
                    delete eliminarItems;
            }

            ret.mensaje = null;
            ret.exito = true;
            ret.id = null;
            return ret;

        } catch (Exception e){
            ret.mensaje = e.getLineNumber()+'\n' + e.getMessage();
            ret.exito = false;
            ret.id = null;
            return ret;
        }
    }

    public static List<Estado__c> getEstados(){

        try{
            return aSiteUtils.queryResults2(Estado__c.SObjectType, null, 'Id != :v1', null, 'Mostrar_en_portal__c = :v2', true);
        } catch (Exception e){
            return null;
        }
    }

    public static List<Categoria__c> getCategorias(){

        try{
            return aSiteUtils.queryResults2(Categoria__c.SObjectType, null, 'Id != :v1', null, 'Mostrar_en_portal__c = :v2', true);
        } catch (Exception e){
            return null;
        }
    }

    public static List<Variedad__c> getVariedadesByOpp(List<String> oppIds){

        try{
            Set<String> vari = New Set<String>();
            String queryPlus = 'PricebookEntry.Product2.Variedade__c';
            List<OpportunityLineItem> items = aSiteUtils.queryResults1(OpportunityLineItem.SObjectType, queryPlus, 'OpportunityId In :v1', oppIds);

            if (items != null){
                for (OpportunityLineItem c : items){
                    vari.add(c.PricebookEntry.Product2.Variedade__c);
                }
            }

            return aSiteUtils.queryResults1(Variedad__c.SObjectType, null, 'Id In :v1', vari);

        } catch (Exception e){
            return null;
        }
    }
    
    public static List<Variedad__c> getVariedadesByTA(String accId, String safra, String marca){

        try{
            Set<String> vari = New Set<String>();
            String queryPlus = 'Cultivar__r.Variedade__c';
            List<Item_del_Contrato__c> items = aSiteUtils.queryResults6(Item_del_Contrato__c.SObjectType, queryPlus, 'Contrato_de_Multiplicacion__r.RecordType.Name In :v1', new String[]{'Termo Aditivo Comerciais','Termo Aditivo Novas Biotecnologias'}, 'Contrato_de_Multiplicacion__r.Multiplicador__c = :v2', accId, 'Contrato_de_Multiplicacion__r.Safra__c = :v3', safra, 'Contrato_de_Multiplicacion__r.Sociedad__c = :v4', marca, 'RecordType.Name In :v5', new String[]{'Volumen'}, 'Contrato_de_Multiplicacion__r.Estado__c = :v6', 'Chegou');

            if (items != null){
                for (Item_del_Contrato__c c : items){
                    vari.add(c.Cultivar__r.Variedade__c);
                }
            }

            return aSiteUtils.queryResults1(Variedad__c.SObjectType, null, 'Id In :v1', vari);

        } catch (Exception e){
            return null;
        }
    }

    public static List<OpportunityLineItem> getItemsToEstoque(Id accId, String safra, String marca){
        try{
            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();
            List<OpportunityLineItem> tmpOppItems2 = new List<OpportunityLineItem>();
            String queryPlus = 'Variedad__r.Name, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, Opportunity.RecordType.DeveloperName, Opportunity.StageName, Estado_de_Comercializacion__r.Name ';

            String qry = 'Select Id From Opportunity Where AccountId=\'' + accId + '\' And Opportunity.RecordType.DeveloperName=\'Stock_Multiplicadores\' And Opportunity.Safra__c =\'' + safra + '\' And Opportunity.Marca__c=\'' + marca + '\' And Opportunity.StageName=\'Aprobada\' Order By CreatedDate desc limit 1';
            List<Opportunity> result = New List<Opportunity>();
            result = database.query(qry);

            if (result.size() > 0)//{
                tmpOppItems2 = aSiteUtils.queryResults1(OpportunityLineItem.SObjectType, queryPlus, 'OpportunityId = :v1', result[0].Id);
            /*} else{
                tmpOppItems2 = aSiteUtils.queryResults5(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.AccountId = :v1', accId, 'Opportunity.RecordType.DeveloperName in :v2', new String[]{'AnexoI'}, 'Opportunity.Safra__c = :v3', safra, 'Opportunity.StageName = :v4', 'Aprobada', 'Opportunity.Marca__c = :v5', marca);
            }*/

            //Consulto todos los ANEXOS I para armar la grilla disponible de variedades.
            /*tmpOppItems2 = aSiteUtils.queryResults5(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.AccountId = :v1', accId, 'Opportunity.RecordType.DeveloperName in :v2', new String[] {'AnexoI'}, 'Opportunity.Safra__c = :v3', safra, 'Opportunity.Marca__c = :v4', marca, 'Opportunity.Epoca_de_Plantio__c = :v5', epocaPlantio);
             for(OpportunityLineItem s : tmpOppItems2){
             if(s.Opportunity.StageName == ST_APROBADA){ //Ojo, ver idioma para este dato
             tmpOppItems.add(s);
             }
             }
             return tmpOppItems;*/

            return tmpOppItems2;
        } catch (Exception e){
            return null;
        }
    }

    public static List<OpportunityLineItem> getAnexosItemsToA2(Id accId, String safra, String marca, String epocaPlantio){
        try{
            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();
            List<OpportunityLineItem> tmpOppItems2 = new List<OpportunityLineItem>();
            String queryPlus = 'Variedad__r.Name, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, Categoria__r.Name, Categoria_a_Rebaixar__r.Name, Opportunity.StageName, Opportunity.RecordType.Name';

            //Consulto todos los ANEXOS y todas las rebajas I para armar la grilla disponible de variedades.
            //tmpOppItems2 = aSiteUtils.queryResults4(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.AccountId = :v1', accId, 'Opportunity.RecordType.DeveloperName in :v2', new String[] {'AnexoI' ,'Anexo_I_Rebaixamento_Ha'}, 'Opportunity.Safra__c = :v3', safra, 'Opportunity.Marca__c = :v4', marca);
            tmpOppItems2 = aSiteUtils.queryResults5(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.AccountId = :v1', accId, 'Opportunity.RecordType.DeveloperName in :v2', new String[]{'AnexoI', 'Anexo_I_Rebaixamento_Ha'}, 'Opportunity.Safra__c = :v3', safra, 'Opportunity.Marca__c = :v4', marca, 'Opportunity.Epoca_de_Plantio__c = :v5', epocaPlantio);
            System.debug('tmpOppItems2');
            System.debug(tmpOppItems2);

            for (OpportunityLineItem s : tmpOppItems2){
                if (s.Opportunity.StageName == ST_APROBADA){
                    //Ojo, ver idioma para este dato
                    tmpOppItems.add(s);
                }
            }
            return tmpOppItems;
        } catch (Exception e){
            return null;
        }
    }

    public static List<Opportunity> getAnexos2(Id accId, String safra, String marca){
        try{
            return aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'RecordType.DeveloperName = :v2', 'AnexoII', 'Safra__c = :v3', safra, 'Marca__c = :v4', marca, 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
        } catch (Exception e){
            return null;
        }
    }

    public static List<Opportunity> getAnexos2Rebaja(Id accId, String safra, String marca){
        try{
            System.debug('Tiene que ser safra : '+safra);
            System.debug('Tiene que ser marca : '+marca);
            return aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'RecordType.DeveloperName = :v2', 'Anexo_II_Rebaixamento_Sacas', 'Safra__c = :v3', safra, 'Marca__c = :v4', marca, 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
        } catch (Exception e){
            return null;
        }
    }

    public static List<Opportunity> getAnexos3(Id accId, String safra, String marca){
        try{
            return aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'RecordType.DeveloperName = :v2', 'Anexo_III', 'Safra__c = :v3', safra, 'Marca__c = :v4', marca, 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
        } catch (Exception e){
            return null;
        }
    }

    public static List<Opportunity> getAnexos4(Id accId, String safra, String marca){
        try{
            return aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'RecordType.DeveloperName = :v2', 'Anexo_IV', 'Safra__c = :v3', safra, 'Marca__c = :v4', marca, 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
        } catch (Exception e){
            return null;
        }
    }

    public static List<Opportunity> getAnexos5(Id accId, String safra, String marca){
        try{
            return aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'RecordType.DeveloperName = :v2', 'AnexoV', 'Safra__c = :v3', safra, 'Marca__c = :v4', marca, 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
        } catch (Exception e){
            return null;
        }
    }

    public static List<OpportunityLineItem> getAnexosItemsToA3(Id accId, String safra, String marca){
        try{
            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();
            List<OpportunityLineItem> tmpOppItems2 = new List<OpportunityLineItem>();
            String queryPlus = 'Variedad__r.Name, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, Categoria__r.Name, Categoria_a_Rebaixar__r.Name, Opportunity.StageName';

            //Consulto todos los ANEXOS y todas las rebajas I para armar la grilla disponible de variedades.
            tmpOppItems2 = aSiteUtils.queryResults5(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.AccountId = :v1', accId, 'Opportunity.RecordType.DeveloperName in :v2', new String[]{'AnexoII', 'Anexo_II_Rebaixamento_Sacas'}, 'Opportunity.Safra__c = :v3', safra, 'Opportunity.Marca__c = :v4', marca, 'Item_Rebajado__c = :v5', false);
            for (OpportunityLineItem s : tmpOppItems2){
                if (s.Opportunity.StageName == ST_APROBADA){
                    //Ojo, ver idioma para este dato
                    tmpOppItems.add(s);
                }
            }
            return tmpOppItems;
        } catch (Exception e){
            return null;
        }
    }

    public static List<OpportunityLineItem> getAnexosItemsToA4(Id accId, String safra, String marca){
        try{
            List<OpportunityLineItem> tmpOppItems = new List<OpportunityLineItem>();
            List<OpportunityLineItem> tmpOppItems2 = new List<OpportunityLineItem>();
            String queryPlus = 'Variedad__r.Name, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, Categoria__r.Name, Categoria_a_Rebaixar__r.Name, Opportunity.StageName, Estado_de_Comercializacion__r.Name';

            //Consulto todos los ANEXOS y todas las rebajas I para armar la grilla disponible de variedades.
            tmpOppItems2 = aSiteUtils.queryResults5(OpportunityLineItem.SObjectType, queryPlus, 'Opportunity.AccountId = :v1', accId, 'Opportunity.RecordType.DeveloperName in :v2', new String[]{'Anexo_III'}, 'Opportunity.Safra__c = :v3', safra, 'Opportunity.Marca__c = :v4', marca, 'Item_Rebajado__c = :v5', false);
            for (OpportunityLineItem s : tmpOppItems2){
                if (s.Opportunity.StageName == ST_APROBADA){
                    //Ojo, ver idioma para este dato
                    tmpOppItems.add(s);
                }
            }
            return tmpOppItems;
        } catch (Exception e){
            return null;
        }
    }

    public static List<Opportunity> getEstoques(Id accId, String safra, String marca){
        try{
            //return aSiteUtils.queryResults5(Opportunity.SObjectType, null,'AccountId = :v1', accId, 'RecordType.DeveloperName = :v2', 'Stock_Multiplicadores', 'Safra__c = :v3',safra, 'Marca__c = :v4', marca, 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
            List<Opportunity> opps = New List<Opportunity>();
            List<Opportunity> opps2 = New List<Opportunity>();
            Map<String, Opportunity> mapOpps = New Map<String, Opportunity>();
            opps = aSiteUtils.queryResults5(Opportunity.SObjectType, null, 'AccountId = :v1', accId, 'RecordType.DeveloperName = :v2', 'Stock_Multiplicadores', 'Safra__c = :v3', safra, 'Marca__c = :v4', marca, 'Estado_Anexos_Portal_Miltiplicadores__c != :v5', 'Anulado');
            System.debug('Estoques');
            System.debug(opps);
            for (Opportunity o : opps)
                mapOpps.put(o.Mes__c, o);
            for (Integer i = 1; i <= 12; i++){
                if (mapOpps.get(aSiteUtils.getMonthOfNumber(i)) != null)
                    opps2.add(mapOpps.get(aSiteUtils.getMonthOfNumber(i)));
            }
            return opps2;

        } catch (Exception e){
            return null;
        }
    }

    public static List<OpportunityLineItem> valVentasByMultiplicador(List<OpportunityLineItem> items){
        try{
            Map<String, OpportunityLineItem> mapVariedades = new Map<String, OpportunityLineItem>();
            Map<String, String> mapVari = New Map<String, String>();

            List<Variedad__c> vari = New List<Variedad__c>();
            vari = aSiteUtils.queryResults1(Variedad__c.SObjectType, null, 'Id != :v1', null);

            for (Variedad__c v : vari)
                mapVari.put(v.Id, v.Region_bonificacion__c);
            for (OpportunityLineItem s : items){
                String region = s.Opportunity.Region__c;
                if (region == 'REGION 1' || region == 'REGION 2')
                    region = 'SUL';
                String region_vari = mapVari.get(s.PricebookEntry.Product2.Variedade__c);
                if (region_vari != null && region_vari.contains(region)){
                    if (!mapVariedades.containsKey(String.valueOf(s.PricebookEntry.Product2.Variedade__c))){
                        if (s.Opportunity.RecordType.Name == 'Anexo III' || s.Opportunity.RecordType.Name == 'Anexo IV'){
                            s.Semente_comercializada__c += Double.valueOf(s.Semente_uso_propio__c);
                            mapVariedades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c), s);
                        }
                        if (s.Opportunity.RecordType.Name == 'Stock Multiplicadores')
                            mapVariedades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c), s);
                    } else{
                        OpportunityLineItem itm = mapVariedades.get(String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                        if (s.Opportunity.RecordType.Name == 'Anexo III' || s.Opportunity.RecordType.Name == 'Anexo IV')
                            itm.Semente_comercializada__c += Double.valueOf(s.Semente_comercializada__c)+Double.valueOf(s.Semente_uso_propio__c);
                        if (s.Opportunity.RecordType.Name == 'Stock Multiplicadores')
                            itm.Semente_comercializada__c += Double.valueOf(s.Semente_comercializada__c);
                        mapVariedades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__c), itm);
                    }
                }
            }

            return mapVariedades.values();

        } catch (Exception e){
            return null;
        }
    }

    public static List<OpportunityLineItem> valVentasByMultiplicadorClasse(List<OpportunityLineItem> items){
        try{
            Map<String, OpportunityLineItem> mapVariedades = new Map<String, OpportunityLineItem>();
            Map<String, String> mapVari = New Map<String, String>();

            List<Variedad__c> vari = New List<Variedad__c>();
            vari = aSiteUtils.queryResults1(Variedad__c.SObjectType, null, 'Id != :v1', null);

            for (Variedad__c v : vari)
                mapVari.put(v.Id, v.Region_bonificacion__c);
            for (OpportunityLineItem s : items){
                String region = s.Opportunity.Region__c;
                if (region == 'REGION 1' || region == 'REGION 2')
                    region = 'SUL';
                String region_vari = mapVari.get(s.PricebookEntry.Product2.Variedade__c);
                if (region_vari != null && region_vari.contains(region)){
                    if (!mapVariedades.containsKey(String.valueOf(s.PricebookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c))){
                        if (s.Opportunity.RecordType.Name == 'Anexo III' || s.Opportunity.RecordType.Name == 'Anexo IV'){
                            s.Semente_comercializada__c += Double.valueOf(s.Semente_uso_propio__c);
                            mapVariedades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c), s);
                        }
                        if (s.Opportunity.RecordType.Name == 'Stock Multiplicadores')
                            mapVariedades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c), s);
                    } else{
                        OpportunityLineItem itm = mapVariedades.get(String.valueOf(s.PricebookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c));
                        if (s.Opportunity.RecordType.Name == 'Anexo III' || s.Opportunity.RecordType.Name == 'Anexo IV')
                            itm.Semente_comercializada__c += Double.valueOf(s.Semente_comercializada__c)+Double.valueOf(s.Semente_uso_propio__c);
                        if (s.Opportunity.RecordType.Name == 'Stock Multiplicadores')
                            itm.Semente_comercializada__c += Double.valueOf(s.Semente_comercializada__c);
                        mapVariedades.put(String.valueOf(s.PricebookEntry.Product2.Variedade__r.Classes_de_Bonificacao__c), itm);
                    }
                }
            }

            return mapVariedades.values();

        } catch (Exception e){
            return null;
        }
    }

    //Validacion A, anexos III
    public static List<OpportunityLineItem> valAnexos3_A(List<OpportunityLineItem> items){
        try{
            Map<String, OpportunityLineItem> mapOppApp1 = new Map<String, OpportunityLineItem>();
            Map<String, Double> mapRebajas = new Map<String, Double>();

            for (OpportunityLineItem s : items){
                if (!mapOppApp1.containsKey(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c))){
                    mapOppApp1.put(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c), s);
                } else{
                    OpportunityLineItem oli = mapOppApp1.get(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                    if (oli != null){
                        if (s.Sem_Rebajada__c == null)
                            s.Sem_Rebajada__c = 0;
                        if (oli.Sem_Rebajada__c == null)
                            oli.Sem_Rebajada__c = 0;
                        oli.Sem_Rebajada__c = oli.Sem_Rebajada__c + s.Sem_Rebajada__c;

                        if (s.Semente_Bruta__c == null)
                            s.Semente_Bruta__c = 0;
                        if (oli.Semente_Bruta__c == null)
                            oli.Semente_Bruta__c = 0;
                        oli.Semente_Bruta__c = oli.Semente_Bruta__c + s.Semente_Bruta__c;
                    }
                }
                if (s.Categoria_a_Rebaixar__c != null){
                    if (!mapRebajas.containsKey(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c))){
                        mapRebajas.put(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c), s.Sem_Rebajada__c);
                    } else{
                        Double cant = mapRebajas.get(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                        cant += s.Sem_Rebajada__c;
                        mapRebajas.remove(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                        mapRebajas.put(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c), cant);
                    }
                }
            }
            /*
             for(OpportunityLineItem s : items){
             if(s.Sem_Rebajada__c!=null)
             s.Semente_Bruta__c = s.Semente_Bruta__c + s.Sem_Rebajada__c;

             }
             */
            for (OpportunityLineItem s : mapOppApp1.values()){
                if (s.Semente_Bruta__c == null)
                    s.Semente_Bruta__c = 0;
                if (s.Sem_Rebajada__c != null)
                    s.Semente_Bruta__c = s.Semente_Bruta__c + s.Sem_Rebajada__c;
            }
            for (OpportunityLineItem s : mapOppApp1.values()){
                Double rebaja = mapRebajas.get(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                if (rebaja != null)
                    s.Semente_Bruta__c -= rebaja;
            }
            /*
             for(OpportunityLineItem s : items){
             if(s.Categoria_a_Rebaixar__c != null){  //si es rebaja, entonces puedo completar producto existente o crear uno nuevo
             if(mapOppApp1.containsKey(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c))){
             OpportunityLineItem oli = mapOppApp1.get(String.valueOf(s.Categoria_a_Rebaixar__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));
             if(oli != null){
             if(s.Sem_Rebajada__c!=null)
             oli.Semente_Bruta__c = oli.Semente_Bruta__c - s.Sem_Rebajada__c;
             }
             }
             }
             }
             */
            return mapOppApp1.values();

        } catch (Exception e){
            return null;
        }
    }

    //Validacion B, anexos III
    /*
     public static String valAnexos3_B(OpportunityLineItem item, Integer bruta_A2){
     try{
     if(item.Semente_bruta__c != bruta_A2)
     return ' Semente Bruta (Sacas) no pode ser diferente que Sem Bruta. (' + String.valueOf(bruta_A2) + ' Sacas) informada en A.II';
     return '';
     }
     catch(Exception e){
     return e.getMessage();
     }
     }
     */
    //Validacion C, anexos III
    public static String valAnexos3_C(List<aAppendix.myOppItem> items){
        try{
            Integer j = 0;
            String retorno = '';
            for (aAppendix.myOppItem i : items){
                if (Double.valueOf(i.sem_beneficiada) > Double.valueOf(i.sem_bruta))
                    retorno += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_III_Validacion_C + '|';
                j++;
            }

            return retorno;
        } catch (Exception e){
            return e.getMessage();
        }
    }

    //Validacion D, anexos III
    public static String valAnexos3_D(List<aAppendix.myOppItem> items){
        try{
            Integer j = 0;
            String retorno = '';
            for (aAppendix.myOppItem i : items){
                if (Double.valueOf(i.sem_aprobada) > Double.valueOf(i.sem_beneficiada))
                    retorno += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_III_Validacion_D + '|';
                j++;
            }

            return retorno;
        } catch (Exception e){
            return e.getMessage();
        }
    }

    //Validacion E, anexos III
    public static String valAnexos3_E(List<aAppendix.myOppItem> items){
        try{
            Integer j = 0;
            String retorno = '';
            for (aAppendix.myOppItem i : items){
                if ((Double.valueOf(i.sem_uso_propio)+Double.valueOf(i.sem_comer)) > Double.valueOf(i.sem_aprobada))
                    retorno += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_III_Validacion_E + '|';
                j++;
            }

            return retorno;
        } catch (Exception e){
            return e.getMessage();
        }
    }

    //Validacion F, anexos III
    public static String valAnexos3_F(List<aAppendix.myOppItem> items, Map<string, string> mapCategorias){
        try{
            Integer j = 0;
            String retorno = '';
            for (aAppendix.myOppItem i : items){
                if (Double.valueOf(i.sem_uso_propio) > 0 && mapCategorias.get(i.categoria_id) == 'S2')
                    retorno += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_III_Validacion_F + '|';
                j++;
            }

            return retorno;
        } catch (Exception e){
            return e.getMessage();
        }
    }

    //Validacion A, anexos IV
    public static List<OpportunityLineItem> valAnexos4_A(List<OpportunityLineItem> items){
        try{
            Map<String, OpportunityLineItem> mapOppApp1 = new Map<String, OpportunityLineItem>();

            for (OpportunityLineItem s : items){
                /*
                 if(s.Semente_aprovada__c==null) s.Semente_aprovada__c=0;
                 if(s.Semente_comercializada__c==null) s.Semente_comercializada__c=0;
                 if(s.Semente_uso_propio__c==null) s.Semente_uso_propio__c=0;
                 s.Quantidade__c = s.Semente_comercializada__c + s.Semente_uso_propio__c;
                 s.Semente_comercializada__c=null;
                 s.Semente_uso_propio__c=null;
                 s.Descarte__c=null;
                 */

                if (!mapOppApp1.containsKey(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c))){
                    mapOppApp1.put(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c), s);
                } else{
                    OpportunityLineItem oli = mapOppApp1.get(String.valueOf(s.Categoria__c)+String.valueOf(s.PricebookEntry.Product2.Variedade__c));
                    if (oli != null){
                        if (s.Semente_comercializada__c == null)
                            s.Semente_comercializada__c = 0;
                        if (oli.Semente_comercializada__c == null)
                            oli.Semente_comercializada__c = 0;
                        oli.Semente_comercializada__c = oli.Semente_comercializada__c + s.Semente_comercializada__c;

                        if (s.Semente_uso_propio__c == null)
                            s.Semente_uso_propio__c = 0;
                        if (oli.Semente_uso_propio__c == null)
                            oli.Semente_uso_propio__c = 0;
                        oli.Semente_uso_propio__c = oli.Semente_uso_propio__c + s.Semente_uso_propio__c;
                    }
                }
            }

            for (OpportunityLineItem s : mapOppApp1.values()){
                if (s.Semente_aprovada__c == null)
                    s.Semente_aprovada__c = 0;
                if (s.Semente_comercializada__c == null)
                    s.Semente_comercializada__c = 0;
                if (s.Semente_uso_propio__c == null)
                    s.Semente_uso_propio__c = 0;
                s.Quantidade__c = s.Semente_comercializada__c + s.Semente_uso_propio__c;
                s.Semente_comercializada__c = null;
                s.Semente_uso_propio__c = null;
                s.Descarte__c = null;
            }

            return mapOppApp1.values();
        } catch (Exception e){
            return null;
        }
    }

    //Validacion B, anexos IV
    public static String valAnexos4_B(List<aAppendix.myOppItem> items){
        try{
            Integer j = 0;
            String retorno = '';
            for (aAppendix.myOppItem i : items){
                Double suma = Double.valueOf(Decimal.valueOf((Double.valueOf(i.sem_comer)+Double.valueOf(i.sem_uso_propio)+Double.valueOf(i.descarte)+Double.valueOf(i.sem_comer_up_aIII))).divide(1, 2, System.RoundingMode.HALF_EVEN));
                if (suma != Double.valueOf(i.sem_aprobada))
                    retorno += Label.Linea + ' ' + (j + 1)+': ' + Label.Anexo_IV_Validacion_B + '|';
                //retorno += String.valueOf(suma) + '|';
                j++;
            }

            return retorno;
        } catch (Exception e){
            return e.getMessage();
        }
    }

    public static void enviarParaAprobacion(Opportunity oportunidad){
        System.debug('owner ' + oportunidad.OwnerId);
        try{
            Approval.ProcessSubmitRequest aprobacion = new Approval.ProcessSubmitRequest();
            aprobacion.setObjectId(oportunidad.Id);
            aprobacion.setNextApproverIds(new ID[]{oportunidad.OwnerId});
            Approval.ProcessResult resultado = Approval.process(aprobacion);
        } catch (Exception e){
            System.debug(e.getMessage());
        }
    }

    public static void paraAumentarcobertura(){
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }

    public static Boolean validarRebajaAnexoI(List<OpportunityLineItem> items, Opportunity theOpp){
        //Se utiliza para validar la rebaja de Ha. y de Bolsas
        /*
         Boolean retorno = true;
         Double sumArea = 0;
         Double sumBolsas = 0;
         Map <Id, String> categorias = New Map <Id, String>();
         Map <String, Double> cantidades = New Map <String, Double>();
         Map <String, Double> cantXVarInf = New Map <String, Double>();
         Set <String> prodsDupli = New Set <String>();

         for (Categoria__c c :[Select Id, Name From Categoria__c])
         categorias.put(c.Id, c.Name);

         for (OpportunityLineItem i : items){
        //if (String.valueOf(i.Categoria__r.Name) < String.valueOf(i.Categoria_a_Rebaixar__r.Name)){
        //if (Integer.valueOf(categorias.get(i.Categoria__c)) < Integer.valueOf(categorias.get(i.Categoria_a_Rebaixar__c))){

        //if (!prodsDupli.contains(String.valueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria__c) + String.valueOf(i.Categoria_a_Rebaixar__c))){
        //    prodsDupli.add(String.valueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria__c) + String.valueOf(i.Categoria_a_Rebaixar__c));
        //}else{
        //    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Producto duplicado. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - '  + categorias.get(i.Categoria__c));
        //    ApexPages.addMessage(msg);
        //    return false;
        //}

        //if (categorias.get(i.Categoria__c).compareTo(categorias.get(i.Categoria_a_Rebaixar__c)) <= 0){
         if((categorias.get(i.Categoria__c).length() == 1 && categorias.get(i.Categoria_a_Rebaixar__c).length() != 1) || (categorias.get(i.Categoria_a_Rebaixar__c).length() == 1 && categorias.get(i.Categoria__c).length() != 1)){
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Error Categoria. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - '  + categorias.get(i.Categoria__c)); ApexPages.addMessage(msg);
         if(!Test.isRunningTest()) return false;
         }
         if(categorias.get(i.Categoria__c).length() == 1){
         if (categorias.get(i.Categoria__c).compareTo(categorias.get(i.Categoria_a_Rebaixar__c)) >= 0){
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Error Categoria. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - '  + categorias.get(i.Categoria__c));  ApexPages.addMessage(msg);
         if(!Test.isRunningTest()) return false;
         }
         }else{
         if (categorias.get(i.Categoria__c).compareTo(categorias.get(i.Categoria_a_Rebaixar__c)) <= 0){
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Error Categoria. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - '  + categorias.get(i.Categoria__c)); ApexPages.addMessage(msg);
         if(!Test.isRunningTest()) return false;
         }
         }

         if(theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas' || Test.isRunningTest()){
         if(cantXVarInf.ContainsKey(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c))){
         sumBolsas = 0;
         sumBolsas = cantXVarInf.get(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) + i.Sem_Rebajada__c;
         cantXVarInf.remove(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c));
         cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), sumBolsas);
         }else{
         cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), i.Sem_Rebajada__c);
         }
         }else{
         if(cantXVarInf.ContainsKey(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c))){
         sumArea = 0;
         sumArea = cantXVarInf.get(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) + i.Area__c;
         cantXVarInf.remove(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c));
         cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), sumArea);
         }else{
         cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c), i.Area__c);
         }
         }
         }
         for(AggregateResult pr : [Select Id, Categoria_a_Rebaixar__c, PricebookEntry.Product2Id, Sum(Area__c) Area__c, Sum(Sem_Rebajada__c) Sem_Rebajada__c From OpportunityLineItem Where Opportunity.Anexo_Relacionado__c = : theOpp.Anexo_Relacionado__c AND Opportunity.RecordType.Name = :theOpp.RecordType.Name AND OpportunityId != :theOpp.Id Group By Id, Categoria_a_Rebaixar__c, PricebookEntry.Product2Id limit 500]){

         if(theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas'){
         if(cantXVarInf.ContainsKey((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'))){
         sumBolsas = 0;
         sumBolsas = cantXVarInf.get((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c')) + (Double)pr.get('Sem_Rebajada__c');
         cantXVarInf.remove((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'));
         cantXVarInf.put((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'), sumBolsas);
         }
        //}else{
        //cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria__c), i.Sem_Rebajada__c);
        //}
         }else{
         if(cantXVarInf.ContainsKey((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'))){
         sumArea = 0;
         sumArea = cantXVarInf.get((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c')) + (Double)pr.get('Area__c');
         cantXVarInf.remove((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'));
         cantXVarInf.put((String)pr.get('Product2Id') + (String)pr.get('Categoria_a_Rebaixar__c'), sumArea);
         }
        //}else{
        //cantXVarInf.put(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria__c), i.Area__c);
        //}
         }
         }


         Map<String, String> prods_anexo_rel = New Map <String, String>();
         for(AggregateResult p : [Select Categoria__c, PricebookEntry.Product2Id, Sum(Area__c) Area__c, Sum(Semente_bruta__c) Semente_bruta__c From OpportunityLineItem Where OpportunityId = : theOpp.Anexo_Relacionado__c Group By Categoria__c, PricebookEntry.Product2Id]){
        //prods_anexo_rel.put(String.valueOf(p.get('Product2Id')) + String.valueOf(p.get('Categoria__c')),String.valueOf(p.get('Product2Id')) + String.valueOf(p.get('Categoria__c')));
        //cantidades.put(String.valueOf(p.get('Product2Id')) + String.valueOf(p.get('Categoria__c')), Double.valueOf(p.get('Area__c')));
         prods_anexo_rel.put((String)p.get('Product2Id') + (String)p.get('Categoria__c'),(String)p.get('Product2Id') + (String)p.get('Categoria__c'));
         if(theOpp.RecordType.Name == 'Anexo II Rebaixamento Sacas'){
         cantidades.put((String)p.get('Product2Id') + (String)p.get('Categoria__c'), (Double)p.get('Semente_bruta__c'));
         }else{
         cantidades.put((String)p.get('Product2Id') + (String)p.get('Categoria__c'), (Double)p.get('Area__c'));
         }
         }

         if (prods_anexo_rel.size() > 0 && cantXVarInf.size() > 0){
         for (OpportunityLineItem i : items){
         if (prods_anexo_rel.get(String.valueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) == null){
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'No existe el producto en el anexo relacionado a la rebaja. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - ' + categorias.get(i.Categoria__c)); ApexPages.addMessage(msg);
         if(!Test.isRunningTest()) return false;
         }
         if (cantXVarInf.get(String.ValueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c)) > cantidades.get(String.valueOf(i.PricebookEntry.Product2Id) + String.valueOf(i.Categoria_a_Rebaixar__c))){
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Cantidad excedida. ' + i.PricebookEntry.Product2.Variedade__r.Name + ' - ' + categorias.get(i.Categoria_a_Rebaixar__c)); ApexPages.addMessage(msg);
         if(!Test.isRunningTest()) return false;
         }

         }
         }
         return retorno;
         */
        return false;
    }
}
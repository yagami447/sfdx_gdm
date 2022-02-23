global class Opp_Utils {

    private static String rt_comer_brasmax_opps = '012400000009d91';
    private static String rt_franq_brasmax_opps = '012400000000zQu';
    
    public static Boolean validando = false;

    webservice static String anularOpp(String idOpp){
        Savepoint sp;       
        sp = Database.setSavepoint();
        String retorno = '';
        
        try{
        
            List<Opportunity> opps = [Select Id, StageName From Opportunity Where Id = : idOpp];
            
            opps[0].StageName = 'AN - Anulada';
            update opps;
            
            retorno = 'Oportunidad anulada.';
            
        }catch(Exception e){                                     
            retorno = 'Error al anular la oportunidad. \n\n' + e.getMessage();
            Database.rollback(sp);                        
        }
        
        return retorno;
    }
    
    webservice static String liberarParaEdicionOpp(String idOpp){
        Savepoint sp;       
        sp = Database.setSavepoint();
        String retorno = '';
        
        try{
        
            List<Opportunity> opps = [Select Id, StageName From Opportunity Where Id = : idOpp];
            
            if (opps[0].StageName != 'Aprobada'){
                retorno = 'Para liberar para edicion la etapa debe ser Aprobada.';
                return retorno;
            }
            
            System.Approval.unlock(idOpp);
                
            opps[0].StageName = 'Edición';
            update opps;
            
            retorno = 'Se ha liberado la oportunidad para edicion.';
            
        }catch(Exception e){                                     
            retorno = 'Error al liberar la oportunidad para edicion. \n\n' + e.getMessage();
            Database.rollback(sp);                        
        }
        
        return retorno;
            
    }
    
    webservice static String liberarParaEdicionTA(String idTA){
        Savepoint sp;       
        sp = Database.setSavepoint();
        String retorno = '';
        
        try{
        
            List<Contrato__c> ta = [Select Id, Estado__c From Contrato__c Where Id = : idTA];                        
            
            System.Approval.unlock(idTA);
                
            //ta[0].Estado__c = 'Edição';
            //update ta;
            
            retorno = 'Se ha liberado el TA.';
            
        }catch(Exception e){                                     
            retorno = 'Error al liberar el TA para edicion. \n\n' + e.getMessage();
            Database.rollback(sp);                        
        }
        
        return retorno;
            
    }
    
    webservice static String bloquearTA(String idTA){
        Savepoint sp;       
        sp = Database.setSavepoint();
        String retorno = '';
        
        try{
        
            List<Contrato__c> ta = [Select Id, Estado__c From Contrato__c Where Id = : idTA];                        
            
            System.Approval.lock(idTA);
                
            //ta[0].Estado__c = 'Edição';
            //update ta;
            
            retorno = 'Se ha bloqueado el TA.';
            
        }catch(Exception e){                                     
            retorno = 'Error al bloquear el TA. \n\n' + e.getMessage();
            Database.rollback(sp);                        
        }
        
        return retorno;
            
    }
    
    public static Map<String,OpportunityLineItem> mapaValidacion(Opportunity opp){
        Map<String,OpportunityLineItem> pbeMap = new Map<String,OpportunityLineItem>();     
        String safra = '%' + opp.safra__c.substring(2,5);
        for(OpportunityLineItem oi :[Select Id, PricebookEntryId, Semente_comercializada__c, Semente_uso_propio__c, Area_Plantada__c, Area__c, Semente_aprovada__c, Semente_bruta__c, Semente_beneficiada__c from OpportunityLineItem Where opportunityid != :opp.id and opportunity.AccountId = :opp.accountId and Opportunity.RecordTypeId = :opp.RecordTypeId and Opportunity.Safra__c like :safra]){
            OpportunityLineItem oi2 = pbeMap.get(oi.pricebookentryid);
            if(oi2 == null){
                oi2 = new OpportunityLineItem(Semente_aprovada__c=0,Semente_comercializada__c=0,Area_Plantada__c=0,Semente_uso_propio__c=0,Area__c=0,Semente_beneficiada__c=0,Semente_bruta__c=0,PricebookEntryId=oi.pricebookentryid);
                pbeMap.put(oi.pricebookEntryId, oi2);
            }
            if(oi.Semente_bruta__c != null) oi2.Semente_bruta__c += oi.Semente_bruta__c;
            if(oi.Semente_beneficiada__c != null) oi2.Semente_beneficiada__c += oi.Semente_beneficiada__c;
            if(oi.Semente_aprovada__c != null) oi2.Semente_aprovada__c += oi.Semente_aprovada__c;
            if(oi.Area_Plantada__c != null) oi2.Area_Plantada__c += oi.Area_Plantada__c;
            if(oi.Area__c != null) oi2.Area__c += oi.Area__c;
        }
        return pbeMap;
    }
    
    public static Boolean mapaMensajes(OpportunityLineItem item, Double area2, Double area_p, Double area, Double uso_ant, Double basica, Double ben, Double aprov, Double bruta){
        Boolean paso = false;
        String variedad = item.Variedade_Prod__c;
        String name = item.PricebookEntry.Product2.Name;
                
        if(area2 > 0 && (uso_ant+basica)/area2 < 1){
            paso = true;
            if((uso_ant+basica)/area2 > 0.86)               
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, variedad + ' - Basica: ' + String.valueOf(basica) 
                + ' - Uso Proprio: ' + String.valueOf(uso_ant) + ' - Ha.Autorizado: ' + String.valueOf(area2) + ': Menos de uma saca por hectare.'));               
            else
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, variedad + ' - Basica: ' + String.valueOf(basica) 
                + ' - Uso Proprio: ' + String.valueOf(uso_ant) + ' - Ha.Autorizado: ' + String.valueOf(area2) + ': Menos de uma saca por hectare.'));
        }
        /*
        if(area_p > area){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, variedad + ' - Ha.Autorizados: ' + String.valueOf(area)
            + ' - Ha.Plantados: ' + String.valueOf(area_p) + ': A area plantada não pode ser maior que a area autorizada.' ));
            paso = true;
        }
        if(ben > bruta){                
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, name + ' - Beneficiada: ' + String.valueOf(ben)
            + ' - Bruta: ' + String.valueOf(bruta) + ': A semente beneficiada não pode ser maior que a bruta.' ));
            paso = true;
        }
        if(aprov > ben){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, name + ' - Aprovada: ' + String.valueOf(aprov)
            + ' - Beneficiada: ' + String.valueOf(ben) + ': A semente aprovada não pode ser maior que a beneficiada.' ));
            paso = true;                
        }
        */
        return paso;
    }
    
    public static Boolean mapaMensajes2(OpportunityLineItem item, Double area2, Double area_p, Double area, Double uso_ant, Double basica, Double ben, Double aprov, Double bruta){
        Boolean paso = false;
        String variedad = item.Variedade_Prod__c;
        String name = item.PricebookEntry.Product2.Name;
        /*      
        if(area2 > 0 && (uso_ant+basica)/area2 < 1){
            paso = true;
            if((uso_ant+basica)/area2 > 0.86)               
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, variedad + ' - Basica: ' + String.valueOf(basica) 
                + ' - Uso Proprio: ' + String.valueOf(uso_ant) + ' - Ha.Autorizado: ' + String.valueOf(area2) + ': Menos de uma saca por hectare.'));               
            else
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, variedad + ' - Basica: ' + String.valueOf(basica) 
                + ' - Uso Proprio: ' + String.valueOf(uso_ant) + ' - Ha.Autorizado: ' + String.valueOf(area2) + ': Menos de uma saca por hectare.'));
        }
        */
        if(area_p > area){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, variedad + ' - Ha.Autorizados: ' + String.valueOf(area)
            + ' - Ha.Plantados: ' + String.valueOf(area_p) + ': A area plantada não pode ser maior que a area autorizada.' ));
            paso = true;
        }
        if(ben > bruta){                
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, name + ' - Beneficiada: ' + String.valueOf(ben)
            + ' - Bruta: ' + String.valueOf(bruta) + ': A semente beneficiada não pode ser maior que a bruta.' ));
            paso = true;
        }
        if(aprov > ben){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, name + ' - Aprovada: ' + String.valueOf(aprov)
            + ' - Beneficiada: ' + String.valueOf(ben) + ': A semente aprovada não pode ser maior que a beneficiada.' ));
            paso = true;                
        }
        return paso;
    }
    
    public static Boolean validarFranqueados(List<OpportunityLineItem> itemList, Opportunity opp){
        Set<String> CultivarIds = new Set<String>();
        for(Contrato__c c : [Select c.Id, c.Cultivar__r.Variedad__c, c.Cultivar__r.Variedade__c, c.Cultivar__r.Variedade__r.Name  from Contrato__c c Where c.Multiplicador__c = :opp.AccountId])
            CultivarIds.add(c.Cultivar__r.Variedad__c);
        
        for (OpportunityLineItem i :itemList){
            if(!CultivarIds.contains(i.PricebookEntry.Product2.Variedad__c)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, i.Variedade_Prod__c + ' - A conta não possui contrato desse produto.'));
                return false;
            }
        }
        return true;
    }
    
    public static Double valCantBasica(Product2 prod2, Opportunity opp){
        String safra = '%' + opp.safra__c.substring(2,5);       
        String conta = opp.AccountId;
        String variedad = prod2.Variedad__c;
        String categ = prod2.Categoria__c;
        Double basica = 0;
        
        if(categ == 'Basica') return 999999;
            
        for(OpportunityLineItem oi :[select id, Qtde_Scs_40kg__c From Opportunitylineitem 
            where pricebookentry.product2.Variedad__c = :variedad 
            and pricebookentry.product2.Categoria__c = 'Basica' 
            and Opportunity.RecordTypeid = :rt_franq_brasmax_opps 
            and Opportunity.AccountId = :conta
            and Opportunity.Safra__c like :safra]){
                if(oi.Qtde_Scs_40kg__c != null) basica += oi.Qtde_Scs_40kg__c;
        }
        return basica;
    }
    
    public static Double valCantUsoPropio(Product2 prod2, Opportunity opp){
        String safraAnt = String.valueOf(Integer.valueOf(opp.safra__c.substring(3,5)) - 1);
        if(safraAnt.length() == 1) safraAnt = '0' + safraAnt;
        safraAnt = '%/' + safraAnt;
        
        String conta = opp.AccountId;
        String variedad = prod2.Variedad__c;
        String categ = prod2.Categoria__c;
        Double uso = 0;
        
        if(categ == 'Basica') return 999999;
        
        List<String> cats = new List<String>();
        if(categ == 'C2' || categ == 'S1' || categ == 'S2' || categ == 'C1')
            cats.add('Basica');
            
        if(categ == 'C2' || categ == 'S1' || categ == 'S2')
            cats.add('C1');
            
        if(categ == 'S1' || categ == 'S2')
            cats.add('C2');
        
        if(categ == 'S2')
            cats.add('S1');
        
        for(OpportunityLineItem oi :[select id, Semente_uso_propio__c From Opportunitylineitem 
            where pricebookentry.product2.variedad__c = :variedad 
            and pricebookentry.product2.Categoria__c in :cats 
            and Opportunity.RecordTypeid = :rt_comer_brasmax_opps 
            and Opportunity.AccountId = :conta and Opportunity.Safra__c like :safraAnt]){
                if(oi.Semente_uso_propio__c != null) uso += oi.Semente_uso_propio__c;
        }
        
        return uso;
    }
    
    public static Map<String,PricebookEntry> cargarRoyaltyPricebookEntries(String lp_name){
        Map<String,PricebookEntry> rPb = new Map<String,PricebookEntry>();
        for (PricebookEntry p :[Select Id, Product2.Variedade__c, Product2.Variedade__r.Name, Name From PricebookEntry where Product2.Family = 'Royalty x Basica' and Product2.Categ__r.Name = 'BASICA' and Pricebook2.Name = :lp_name and isActive = true])
     		//rPb.put(p.Product2.Variedade__r.Name, p);
            rPb.put(p.Product2.Variedade__c, p);
    
        return rPb;
    }
    
    public static Map<String,PricebookEntry> cargarSemillaPricebookEntries(String lp_name){
        Map<String,PricebookEntry> rPb = new Map<String,PricebookEntry>();
        
        for (PricebookEntry p :[Select Id, Product2.Variedade__c, Product2.Variedade__r.Name, Name From PricebookEntry where Product2.Family = 'Semilla' and Product2.Categ__r.Name = 'BASICA' and Product2.Semilla_Tratada__c = false and Product2.CANTIDAD_SUB_UNIDAD__c = '40' and Pricebook2.Name = :lp_name and isActive = true])
            rPb.put(p.Product2.Variedade__c, p);
            
        return rPb;
    }
    
    public static Map<String,String> cargarRecordTypesOppbyDevName() {
       
        Map<String,String> rTypes = new Map<String,String>();
        for(RecordType rt : [SELECT Id,DeveloperName,Name FROM RecordType WHERE SobjectType='Opportunity' And isActive = true]){         
            rTypes.put(rt.DeveloperName, rt.Name);
        }       
        
        return rTypes;
    }
    
    public static Map<String, Id> cargarRecordTypesOportunidades() {
    
       Map<String,Id> rTypes = new Map<String,Id>();
       Schema.Describesobjectresult d = Opportunity.sObjectType.getDescribe();
       Map<String, Schema.Recordtypeinfo> rt = d.getRecordTypeInfosByName();
       
       for(String s : rt.keySet()) {
          rTypes.put(s, rt.get(s).getRecordTypeId());
       }
       
       return rTypes;
       
    }    
    
    public static String DuplicarPedido (Id oppId){
    
       try{
       
          String st_PE = 'PE - Pendiente';

          Opportunity o = [Select Id, Name, RecordType.Name, AccountId, Fecha_fijacion_T_de_cambio__c, CloseDate, VB_Cot_Soja__c, Safra__c, Tipo_de_Cambio__c, Sucursal__c, Tipo_de_Cota_o__c, Condicion_de_Pago__c, Relatorio_Relacionado__c, Tipo__c, OwnerId, Marca__c, Invierno__c, Origen__c, VB_Chegou_na_Brasmax__c, Vencimiento_Anexo__c From Opportunity Where Id = : oppId];

            String rtName = 'Pendiente';
            if(o.RecordType.Name == 'NC - Autorizada' || o.RecordType.Name == 'NC - Pendiente' || o.RecordType.Name == 'NC - Rechazada') rtName = 'NC - Pendiente';
            RecordType rt = [Select Id From RecordType Where Name = :rtName limit 1];
          
          List<OpportunityLineItem> items = [Select Id, OpportunityId, PriceBookEntryId, UnitPrice, Id_Item_de_Oportunidad_Relacionado__c, Quantity, Tasas__c, Categoria__c, Produto_Rebaixado__c From OpportunityLineItem Where OpportunityId = : oppId];        
       
          Opportunity nueva_op = New Opportunity();
          if (!o.Name.contains('COPIA')){
             nueva_op.Name = o.Name + ' COPIA 1';
          }else{
             String nro_copia = o.Name.split('COPIA')[1].trim();
             Integer nro_copia_aux = Integer.valueOf(nro_copia);
             nro_copia_aux = nro_copia_aux + 1;
             nueva_op.Name = o.Name.split('COPIA')[0].trim() + ' COPIA ' + String.valueOf(nro_copia_aux);
          }      
             
          //nueva_op.Name = o.Name + ' COPIA';
          nueva_op.AccountId = o.AccountId;
          nueva_op.Fecha_fijacion_T_de_cambio__c = o.Fecha_fijacion_T_de_cambio__c;
          nueva_op.CloseDate = o.CloseDate;
          nueva_op.VB_Cot_Soja__c = o.VB_Cot_Soja__c;
          nueva_op.Safra__c = o.Safra__c;
          nueva_op.Tipo_de_Cambio__c = o.Tipo_de_Cambio__c;
          nueva_op.Sucursal__c = o.Sucursal__c;
          nueva_op.Tipo_de_Cota_o__c = o.Tipo_de_Cota_o__c;
          nueva_op.Condicion_de_Pago__c = o.Condicion_de_Pago__c;
          nueva_op.Relatorio_Relacionado__c = o.Relatorio_Relacionado__c;
          nueva_op.Tipo__c = o.Tipo__c;
          nueva_op.OwnerId = o.OwnerId;
          nueva_op.Marca__c = o.Marca__c; 
          nueva_op.Invierno__c = o.Invierno__c;
          nueva_op.Origen__c = o.Origen__c;
          nueva_op.VB_Chegou_na_Brasmax__c = o.VB_Chegou_na_Brasmax__c;

          nueva_op.RecordTypeId = rt.Id;
          nueva_op.StageName = st_PE;
          nueva_op.Vencimiento_Anexo__c = o.Vencimiento_Anexo__c;
       
          insert nueva_op;
       
          for (OpportunityLineItem i : items){       
             OpportunityLineItem nuevo_item = New OpportunityLineItem();
             nuevo_item.OpportunityId = nueva_op.Id;
             nuevo_item.PriceBookEntryId = i.PriceBookEntryId;
             nuevo_item.UnitPrice = i.UnitPrice;
             nuevo_item.Id_Item_de_Oportunidad_Relacionado__c = i.Id_Item_de_Oportunidad_Relacionado__c;
             nuevo_item.Quantity = i.Quantity;
             nuevo_item.Tasas__c = i.Tasas__c;
             nuevo_item.Produto_Rebaixado__c = i.Produto_Rebaixado__c;
             nuevo_item.Categoria__c = i.Categoria__c;         
             insert nuevo_item;          
          }
       
          return 'El pedido se ha duplicado: ' + nueva_op.Name;

       }catch(System.CalloutException ex){       
          return 'Error al duplicar el Pedido';       
       }
    }         
    
    webservice static String[] proximaOpp(Id oppId) {
        
        String[] retorno;       
        Opportunity o = [Select Id, RecordType.Name From Opportunity Where Id = : oppId];
        if (o.RecordType.Name.contains('Stock Multiplicadores'))
            retorno = proximoStockMult(oppId);
        if (o.RecordType.Name == 'Objetivo Ventas Royalties')
            retorno = proximoObjetivoVentaRoyalties(oppId);
            
        return retorno;         
        
    }
    
    webservice static String[] proximoObjetivoVentaRoyalties(Id oppId) {
        
        Savepoint sp;
        String[] retorno = New String[3];
        
        try{
            
            sp = Database.setSavepoint();                                                                                   
            
            Opportunity OppClone = New Opportunity();
            Map<String,Id> rType = New Map<String,Id>();                                    
            List<OpportunityLineItem> nuevosItems = New List<OpportunityLineItem>();            
            String soql = previsionesController.getCreatableFieldsSOQL('Opportunity','Id=\'' + oppId + '\'');
            Opportunity oppAClonar = (Opportunity)Database.query(soql);
            OppClone = oppAClonar.clone(false, true);   
            OppClone.Mes__c = getSiguienteMes(OppClone.Mes__c);       
           
            insert OppClone;
          
            List<OpportunityLineItem> items = [Select Id, OpportunityId, PriceBookEntryId, Quantidade__c From OpportunityLineItem Where OpportunityId = : oppId];        
       
            String soqlOLI = previsionesController.getCreatableFieldsSOQL('OpportunityLineItem','OpportunityId=\'' + oppId + '\'');
            List<OpportunityLineItem> prodOLIaClonar = (List<OpportunityLineItem>)Database.query(soqlOLI);
       
            for (OpportunityLineItem i : prodOLIaClonar){       
                OpportunityLineItem nuevo_item = i.clone(false,true);
                nuevo_item.OpportunityId = OppClone.Id;
                nuevo_item.TotalPrice = null;
                nuevosItems.add(nuevo_item);          
            }

            insert nuevosItems;
       
            retorno[0] = 'Foi criada a oportunidade.';
            retorno[1] = 'ok';
            retorno[2] = OppClone.Id;
          
            return retorno;
                                                                                                
        }catch(System.CalloutException ex){       
           
           Database.rollback(sp);
           retorno[0] = 'Falha ao criar a oportunidade para o próximo mês.';
           retorno[1] = '';
           retorno[2] = '';
           
           return retorno;
                          
       }
        
    }
    
    webservice static String[] proximoStockMult(Id oppId) {
        
        Savepoint sp;
        String[] retorno = New String[3];
        
        try{
            
          sp = Database.setSavepoint(); 
          List<OpportunityLineItem> nuevosItems = New List<OpportunityLineItem>();
          Boolean cantidadesNulas = false;
          Opportunity opp = [ SELECT Id, Name, AccountId, CloseDate, Safra__c, Mes__c, Tipo__c, OwnerId, StageName, Marca__c,
                                    Negocio_por_Conta__c, Negocio_por_Conta__r.Cultura__c, Cultura__c, RecordTypeId, RecordType.Name 
                            FROM Opportunity 
                            WHERE Id = : oppId];

          List<OpportunityLineItem> items = [   SELECT Id, OpportunityId, PriceBookEntryId, UnitPrice, Quantity, Semente_aprovada__c, 
                                                    Semente_comercializada__c, estimativa__c, Categoria__c, Variedad__c
                                                FROM OpportunityLineItem 
                                                WHERE OpportunityId = : oppId];        
       
          String siguienteMes = getSiguienteMes(opp.Mes__c);
          Opportunity nueva_op = New Opportunity();
          nueva_op.AccountId = opp.AccountId;          
          nueva_op.CloseDate = opp.CloseDate;          
          nueva_op.Safra__c = opp.Safra__c;
          nueva_op.Mes__c = siguienteMes;
          nueva_op.Name = 'Estoque ' + siguienteMes;
          nueva_op.Tipo__c = opp.Tipo__c;          
          nueva_op.OwnerId = opp.OwnerId;
          //nueva_op.StageName = 'Aberta';
          nueva_op.StageName = 'Edición';          
          nueva_op.Marca__c = opp.Marca__c;          
          nueva_op.RecordTypeId = opp.RecordTypeId;
          nueva_op.Comentarios__c = '';         
       
          if( opp.RecordType.Name.contains('Milho') ) {
            nueva_op.Negocio_por_Conta__c = opp.Negocio_por_Conta__c;
            if( opp.Cultura__c != '' ) {
                nueva_op.Cultura__c = opp.Cultura__c;
            } else {
                nueva_op.Cultura__c = opp.Negocio_por_Conta__r.Cultura__c;
            }
            
          }
       
          insert nueva_op;
       
          for (OpportunityLineItem i : items){       
             OpportunityLineItem nuevo_item = New OpportunityLineItem();
             nuevo_item.OpportunityId = nueva_op.Id;
             nuevo_item.PriceBookEntryId = i.PriceBookEntryId;
             nuevo_item.UnitPrice = i.UnitPrice;             
             nuevo_item.Quantity = i.Quantity;
             nuevo_item.Categoria__c = i.Categoria__c;
             nuevo_item.Semente_aprovada__c = i.Semente_aprovada__c;
             nuevo_item.Semente_comercializada__c = i.Semente_comercializada__c;
             nuevo_item.Estimativa__c = i.Estimativa__c;
             
             if( opp.RecordType.Name.contains('Milho') ) {
                 nuevo_item.Variedad__c = i.Variedad__c;
             }
             
             if(i.Semente_aprovada__c == null || i.Semente_comercializada__c == null){
                cantidadesNulas = true;
                break;
             }
             //total += (math.abs(i.Semente_aprovada__c) + math.abs(i.Semente_comercializada__c));
             //insert nuevo_item;
             nuevosItems.add(nuevo_item);          
          }
          
          if(cantidadesNulas){ //Retorno error por cantidades en 0
               Database.rollback(sp);
               retorno[0] = 'Falha ao criar a oportunidade para o próximo mês. Quantidades em zero';
               retorno[1] = '';
               retorno[2] = '';
               
               return retorno;
          }
          
          insert nuevosItems;
          
          //o.StageName = 'Fechada';
          //update o;
          
          //Opportunity opp_aux = [Select Id, Name, Account.Name, Safra__c, Mes__c From Opportunity Where Id = : nueva_op.Id];
          //opp_aux.Name = 'Stock Mult. / ' + opp_aux.Account.Name + ' / ' + opp_aux.Safra__c + ' / ' + opp_aux.Mes__c;
          //update opp_aux;
       
          retorno[0] = 'Foi criada a oportunidade para o próximo mês.';
          retorno[1] = 'ok';
          retorno[2] = nueva_op.Id;
          
          return retorno;
          
          //return 'Se ha creado el siguiente stock de multiplicadores.';

       }catch(System.CalloutException ex){       
           Database.rollback(sp);
           retorno[0] = 'Falha ao criar a oportunidade para o próximo mês.';
           retorno[1] = '';
           retorno[2] = '';
           
           return retorno;
           //return 'Error al crear siguiente stock de multiplicadores';       
       }
        
    }
    
    public static String getSiguienteMes (String mes){
        
        String siguienteMes;
        
        if (mes == 'Janeiro')
            siguienteMes = 'Fevereiro';
        if (mes == 'Fevereiro')
            siguienteMes = 'Março';
        if (mes == 'Março')
            siguienteMes = 'Abril';
        if (mes == 'Abril')
            siguienteMes = 'Maio';
        if (mes == 'Maio')
            siguienteMes = 'Junho';
        if (mes == 'Junho')
            siguienteMes = 'Julho';
        if (mes == 'Julho')
            siguienteMes = 'Agosto'; 
        if (mes == 'Agosto')
            siguienteMes = 'Setembro';
        if (mes == 'Setembro')
            siguienteMes = 'Outubro';
        if (mes == 'Outubro')
            siguienteMes = 'Novembro';
        if (mes == 'Novembro')
            siguienteMes = 'Dezembro';
            
        return siguienteMes;                                            
        
    }
    
    
    webservice static String[] notificacionProd_New(Id oppId) {
        
        Map<String, User> destinatarios = New Map<String, User>();
        Map<String, Schema.SObjectField> objectFields_oppItems = Schema.getGlobalDescribe().get('OpportunityLineItem').getDescribe().fields.getMap();
        List<OpportunityLineItem> oppoli = New List<OpportunityLineItem>();
        String Body = '';
        String[] retorno = New String[2];
        Savepoint sp;
        
        try{
            sp = Database.setSavepoint();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             
            Opportunity opp = [SELECT Id, Name, Safra__c, Marca__c, Tipo_de_Operacion__c, Comentarios__c, Region__c, Invierno__c, Epoca_de_Plantio__c, Rebaja__c, StageName, Notificado__c, Setor__c, RecordType.Name FROM Opportunity WHERE Id = :oppId];
                        
            String sector = 'Comercial';
            if (opp.RecordType.Name == 'PB-Desarrollo')
                sector = 'Desarrollo';
            if (opp.RecordType.Name == 'PB-Oferta')
                sector = 'Produccion';
                
            String queryItems = 'SELECT ';
            for(String s : objectFields_oppItems.keySet())
                    queryItems += ' ' + s + ',';                                                                
            
            queryItems += 'PriceBookEntry.UnitPrice, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.PriceBook2Id, PricebookEntry.Product2.Especie__c, Categoria__r.Name, Categoria_a_Rebaixar__r.Name, PricebookEntry.Product2.Categ__c, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, PricebookEntry.Product2.Variedade__r.Marca_comercial__c, PricebookEntry.Product2.Categ__r.Name, Local_de_Entrega__r.Name FROM OpportunityLineItem Where OpportunityId = \'' + oppId + '\' Order by Variedade_Prod__c';        
            oppoli = Database.query(queryItems);
            
            for(User u : [SELECT Id, Username, Name, Email, IsActive, UserRoleId, ProfileId FROM User WHERE Name in ('Robert Moser', 'Ricardo Franconere', 'Julio Cesar Poletto', 'Administrador')]){
                destinatarios.put(u.Name, u);
            }
            
            opp.StageName = 'PB-Aprobada';
                        
            Body = sector + ' tem atualizações para reportar<br><br>';
            
            if (sector == 'Comercial' || sector == 'Desarrollo'){
                
                opp.Notificado__c = true;
                
                Body += 'Nome: ' + opp.Name + '<br>';
                Body += 'Safra: ' + opp.Safra__c + '<br>'; 
                Body += 'Tipo Op.: ' + opp.Tipo_de_Operacion__c + '<br>'; 
                Body += 'Rebaja: ' + opp.Rebaja__c + '<br>';
                Body += 'Comentarios: ' + opp.Comentarios__c + '<br>'; 
                //Body += 'Acessar:   https://cs23.salesforce.com/' + opp.Id + '<br><br><br>';
                Body += 'Acessar:   https://na27.salesforce.com/' + opp.Id + '<br><br><br>';
                if (oppoli != null){
                    if (opp.Setor__c == 'Comercial'){
                        Body +='<table border="1"><tr><td>Marca Comercial</td><td>Region</td><td>Safra</td><td>Variedade</td><td>Categoria</td><td>Tipo de necesidad</td><td>Local de Entrega</td><td>Quantidade</td></tr>'; 
                        for (OpportunityLineItem i : oppoli)
                            Body += '<tr><td>'+i.PricebookEntry.Product2.Variedade__r.Marca_comercial__c+'</td><td>'+opp.Region__c+'</td><td>'+opp.Safra__c+'</td><td>'+i.PricebookEntry.Product2.Variedade__r.Name+'</td><td>'+i.PricebookEntry.Product2.Categ__r.Name+'</td><td>'+i.Tipo_de_necesidad__c+'</td><td>'+i.Local_de_Entrega__r.Name+'</td><td>'+i.Quantidade__c+'</td></tr>';
                    
                        mail.setTargetObjectId(destinatarios.get('Robert Moser').Id); // Specify who the email should be sent to.
                    }
                    if (opp.Setor__c == 'Desarrollo'){
                        Body +='<table border="1"><tr><td>Marca Comercial</td><td>Region</td><td>Safra</td><td>Variedade</td><td>Categoria</td><td>Tipo de necesidad</td><td>Local de Entrega</td><td>Fecha de necesidad</td></tr>'; 
                        for (OpportunityLineItem i : oppoli)
                            Body += '<tr><td>'+i.PricebookEntry.Product2.Variedade__r.Marca_comercial__c+'</td><td>'+opp.Region__c+'</td><td>'+opp.Safra__c+'</td><td>'+i.PricebookEntry.Product2.Variedade__r.Name+'</td><td>'+i.PricebookEntry.Product2.Categ__r.Name+'</td><td>'+i.Tipo_de_necesidad__c+'</td><td>'+i.Local_de_Entrega__r.Name+'</td><td>'+i.Data__c+'</td><td>'+i.Quantidade__c+'</td></tr>';
                    
                        mail.setTargetObjectId(destinatarios.get('Robert Moser').Id); // Specify who the email should be sent to.
                    }
                    Body += '</table>';        
                }
                Body += '<br>';
            }else{
                mail.setTargetObjectId(destinatarios.get('Robert Moser').Id); // Specify who the email should be sent to.               
                opp.Oferta_Asignada__c = true;
            }
            
            update opp;                        
                                     
            mail.setSenderDisplayName('Notificação de ' + sector);
            //String[] toAddresses = new String[] {destinatarios.get('Robert Moser').Email};
            
            //mail.setCcAddresses(toAddresses);
            mail.setSaveAsActivity(false);
            mail.setHtmlBody(Body);
            mail.setSubject('Notificação de Produção Basica');
             
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            
            retorno[0] = 'Notificação OK';
            retorno[1] = 'ok';
              
            return retorno;
        }catch(exception e){
            retorno[0] = 'Error al Notificar.';
            retorno[1] = '';
                 
            return retorno;
        }
        
    }
    
    
    webservice static String[] notificacionProd(Id oppId, Id regionId, String marca) {
        Map<String, User> destinatarios = New Map<String, User>();
        Map<String, Schema.SObjectField> objectFields_oppItems = Schema.getGlobalDescribe().get('OpportunityLineItem').getDescribe().fields.getMap();
        List<OpportunityLineItem> oppoli = New List<OpportunityLineItem>();
        String Body = '';
        String[] retorno = New String[2];
        Savepoint sp;
        List<Produccion_Basica__c> pbs = New List<Produccion_Basica__c>();
        try{
            sp = Database.setSavepoint();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             
            Opportunity opp = [SELECT Id, Name, Safra__c, Marca__c, Tipo_de_Operacion__c, Comentarios__c, Region__c, Invierno__c, Epoca_de_Plantio__c, Rebaja__c, StageName, Notificado__c, Setor__c, RecordType.Name FROM Opportunity WHERE Id = :oppId];
            
            String sector = 'Produção';
            if (opp.RecordType.Name == 'PB-Comercial')
                sector = 'Comercial';
            if (opp.RecordType.Name == 'PB-Desarrollo')
                sector = 'Desarrollo';
            
            String queryItems = 'SELECT ';
            for(String s : objectFields_oppItems.keySet())
                    queryItems += ' ' + s + ',';                                                                
            
            queryItems += 'PriceBookEntry.UnitPrice, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.PriceBook2Id, PricebookEntry.Product2.Especie__c, Categoria__r.Name, Categoria_a_Rebaixar__r.Name, PricebookEntry.Product2.Categ__c, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, PricebookEntry.Product2.Categ__r.Name FROM OpportunityLineItem Where OpportunityId = \'' + oppId + '\' Order by Variedade_Prod__c';        
            oppoli = Database.query(queryItems);
            
            if (sector == 'Produção'){
                system.debug('PASO 1');
                retorno = BRAXUtils.validarVariedadPB(opp, oppoli);
                system.debug('PASO 2');
                if(retorno[0] != 'OK'){
                    return retorno;
                }
            }
            opp.StageName = 'PB-Aprobada';
            opp.Notificado__c = true;
            update opp;
            system.debug('PASO 3');
            pbs = [SELECT Id, Marca__c, Marca_Comercial__c, Safra__c, Region__c, Epoca_de_Plantio__c, Variedade__r.Name, Categoria__r.Name, Com_1_Pedido__c, Com_2_Pedido_Complementar__c, Com_3_Ajuste__c, Com_4_Cancelamiento__c, Com_5_Relocalizacion__c, Com_6_Adm_Exedente__c, Diferencia__c, Prod_1_Pedido__c, Prod_2_Plantio__c, Prod_3_Estimativa__c, Prod_4_Colheita__c, Prod_5_Beneficiamento__c, Prod_6_Armazenagem__c, Prod_7_Descarte__c, Prod_8_Cessao__c, Prod_9_Certificacion__c, Subtotal_Comercial__c, Subtotal_Prod__c, Variedade__c, Producto__c, Tipo_de_Necesidad__c, Fecha_de_entrega__c, Fecha_de_necesidad__c, Local_Origem__c, Local_de_Entrega__r.Name from Produccion_Basica__c WHERE Marca__c = :opp.Marca__c AND  Region__c = :opp.Region__c AND Safra__c = :opp.Safra__c AND Epoca_de_plantio__c = :opp.Epoca_de_Plantio__c AND Setor__c = : opp.Setor__c];
            
            //Body = 'Produção tem atualizações para reportar<br><br>';
            Body = sector + ' tem atualizações para reportar<br><br>';
            Body += 'Nome: ' + opp.Name + '<br>';
            Body += 'Safra: ' + opp.Safra__c + '<br>'; 
            //Body += 'Marca: ' + opp.Marca__c + '<br>'; 
            Body += 'Tipo Op.: ' + opp.Tipo_de_Operacion__c + '<br>'; 
            Body += 'Rebaja: ' + opp.Rebaja__c + '<br>';
            Body += 'Comentarios: ' + opp.Comentarios__c + '<br>'; 
            Body += 'Acessar:   https://na2.salesforce.com/' + opp.Id + '<br><br><br>';
            if (pbs != null){
                /*
                Body +='<table border="1"><tr><td>Marca</td><td>Region</td><td>Safra</td><td>Variedade</td><td>Categoria</td><td>Com.1-Ped</td><td>Com.2-Ped Compl</td><td>Com.3-Ajuste</td><td>Com.4-Canc</td><td>Com.5-Realoc</td><td>Com.6-Adm Ex</td><td>Subt Com</td><td>Prd.1-Ped</td><td>Prd.2-Plant</td><td>Prd.3-Estim</td><td>Prd.4-Colh</td><td>Prd.5-Benef</td><td>Prd.6-Armaz</td><td>Prd.7-Desc</td><td>Prd.8-Cess</td><td>Prd.9-Cert</td><td>Subt Prd</td><td>Dif</td></tr>'; 
                for (Produccion_Basica__c pb : pbs)
                    Body += '<tr><td>'+pb.Marca__c+'</td><td>'+pb.Region__c+'</td><td>'+pb.Safra__c+'</td><td>'+pb.Variedade__r.Name+'</td><td>'+pb.Categoria__r.Name+'</td><td>'+pb.Com_1_Pedido__c+'</td><td>'+pb.Com_2_Pedido_Complementar__c+'</td><td>'+pb.Com_3_Ajuste__c+'</td><td>'+pb.Com_4_Cancelamiento__c+'</td><td>'+pb.Com_5_Relocalizacion__c+'</td><td>'+pb.Com_6_Adm_Exedente__c+'</td><td>'+pb.Subtotal_Comercial__c+'</td><td>'+pb.Prod_1_Pedido__c+'</td><td>'+pb.Prod_2_Plantio__c+'</td><td>'+pb.Prod_3_Estimativa__c+'</td><td>'+pb.Prod_4_Colheita__c+'</td><td>'+pb.Prod_5_Beneficiamento__c+'</td><td>'+pb.Prod_6_Armazenagem__c+'</td><td>'+pb.Prod_7_Descarte__c+'</td><td>'+pb.Prod_8_Cessao__c+'</td><td>'+pb.Prod_9_Certificacion__c+'</td><td>'+pb.Subtotal_Prod__c+'</td><td>'+pb.Diferencia__c+'</td></tr>';
                Body += '</table>';
                */
                if (opp.Setor__c == 'Comercial'){
                    Body +='<table border="1"><tr><td>Marca Comercial</td><td>Region</td><td>Safra</td><td>Variedade</td><td>Categoria</td><td>Tipo de necesidad</td><td>Local de Entrega</td><td>Com.1-Ped</td><td>Com.2-Ped Compl</td><td>Com.3-Ajuste</td><td>Com.4-Canc</td><td>Com.5-Realoc</td><td>Com.6-Adm Ex</td><td>Subt Com</td><td>Prd.1-Ped</td><td>Prd.2-Plant</td><td>Prd.3-Estim</td><td>Prd.4-Colh</td><td>Prd.5-Benef</td><td>Prd.6-Armaz</td><td>Prd.7-Desc</td><td>Prd.8-Cess</td><td>Prd.9-Cert</td><td>Subt Prd</td><td>Dif</td></tr>'; 
                    for (Produccion_Basica__c pb : pbs)
                        Body += '<tr><td>'+pb.Marca_Comercial__c+'</td><td>'+pb.Region__c+'</td><td>'+pb.Safra__c+'</td><td>'+pb.Variedade__r.Name+'</td><td>'+pb.Categoria__r.Name+'</td><td>'+pb.Tipo_de_necesidad__c+'</td><td>'+pb.Local_de_Entrega__r.Name+'</td><td>'+pb.Com_1_Pedido__c+'</td><td>'+pb.Com_2_Pedido_Complementar__c+'</td><td>'+pb.Com_3_Ajuste__c+'</td><td>'+pb.Com_4_Cancelamiento__c+'</td><td>'+pb.Com_5_Relocalizacion__c+'</td><td>'+pb.Com_6_Adm_Exedente__c+'</td><td>'+pb.Subtotal_Comercial__c+'</td><td>'+pb.Prod_1_Pedido__c+'</td><td>'+pb.Prod_2_Plantio__c+'</td><td>'+pb.Prod_3_Estimativa__c+'</td><td>'+pb.Prod_4_Colheita__c+'</td><td>'+pb.Prod_5_Beneficiamento__c+'</td><td>'+pb.Prod_6_Armazenagem__c+'</td><td>'+pb.Prod_7_Descarte__c+'</td><td>'+pb.Prod_8_Cessao__c+'</td><td>'+pb.Prod_9_Certificacion__c+'</td><td>'+pb.Subtotal_Prod__c+'</td><td>'+pb.Diferencia__c+'</td></tr>';
                }
                if (opp.Setor__c == 'Desarrollo'){
                    Body +='<table border="1"><tr><td>Marca Comercial</td><td>Region</td><td>Safra</td><td>Variedade</td><td>Categoria</td><td>Tipo de necesidad</td><td>Local de Entrega</td><td>Fecha de necesidad</td><td>Fecha de entrega</td><td>Com.1-Ped</td><td>Com.2-Ped Compl</td><td>Com.3-Ajuste</td><td>Com.4-Canc</td><td>Com.5-Realoc</td><td>Com.6-Adm Ex</td><td>Subt Com</td><td>Prd.1-Ped</td><td>Prd.2-Plant</td><td>Prd.3-Estim</td><td>Prd.4-Colh</td><td>Prd.5-Benef</td><td>Prd.6-Armaz</td><td>Prd.7-Desc</td><td>Prd.8-Cess</td><td>Prd.9-Cert</td><td>Subt Prd</td><td>Dif</td></tr>'; 
                    for (Produccion_Basica__c pb : pbs)
                        Body += '<tr><td>'+pb.Marca_Comercial__c+'</td><td>'+pb.Region__c+'</td><td>'+pb.Safra__c+'</td><td>'+pb.Variedade__r.Name+'</td><td>'+pb.Categoria__r.Name+'</td><td>'+pb.Tipo_de_necesidad__c+'</td><td>'+pb.Local_de_Entrega__r.Name+'</td><td>'+pb.Fecha_de_necesidad__c+'</td><td>'+pb.Fecha_de_entrega__c+'</td><td>'+pb.Com_1_Pedido__c+'</td><td>'+pb.Com_2_Pedido_Complementar__c+'</td><td>'+pb.Com_3_Ajuste__c+'</td><td>'+pb.Com_4_Cancelamiento__c+'</td><td>'+pb.Com_5_Relocalizacion__c+'</td><td>'+pb.Com_6_Adm_Exedente__c+'</td><td>'+pb.Subtotal_Comercial__c+'</td><td>'+pb.Prod_1_Pedido__c+'</td><td>'+pb.Prod_2_Plantio__c+'</td><td>'+pb.Prod_3_Estimativa__c+'</td><td>'+pb.Prod_4_Colheita__c+'</td><td>'+pb.Prod_5_Beneficiamento__c+'</td><td>'+pb.Prod_6_Armazenagem__c+'</td><td>'+pb.Prod_7_Descarte__c+'</td><td>'+pb.Prod_8_Cessao__c+'</td><td>'+pb.Prod_9_Certificacion__c+'</td><td>'+pb.Subtotal_Prod__c+'</td><td>'+pb.Diferencia__c+'</td></tr>';
                }
                Body += '</table>';        
            }
            Body += '<br>';
            
            for(User u : [SELECT Id, Username, Name, Email, IsActive, UserRoleId, ProfileId FROM User WHERE Name in ('Pablo Souza', 'Rogério Schneider', 'Marcelo Steffen', 'Robert Moser', 'Ricardo Franconere', 'Julio Cesar Poletto', 'Administrador')]){
                destinatarios.put(u.Name, u);
            }
            
            /*
            if(opp.Region__c == 'SUR'){
                if(marca == 'DSEM')mail.setTargetObjectId(destinatarios.get('Rogério Schneider').Id); // Specify who the email should be sent to.
                if(marca == 'BRMX')mail.setTargetObjectId(destinatarios.get('Marcelo Steffen').Id); // Specify who the email should be sent to.
            }else{
                mail.setTargetObjectId(destinatarios.get('Pablo Souza').Id); // Specify who the email should be sent to.
            }
            */
            
            if(opp.Setor__c == 'Comercial'){
                mail.setTargetObjectId(destinatarios.get('Ricardo Franconere').Id); // Specify who the email should be sent to.             
            }else{
                mail.setTargetObjectId(destinatarios.get('Julio Cesar Poletto').Id); // Specify who the email should be sent to.
            }
             
            //mail.setSenderDisplayName('Notificação de Produção');
            mail.setSenderDisplayName('Notificação de ' + sector);
            String[] toAddresses = new String[] {destinatarios.get('Robert Moser').Email};
            
            mail.setCcAddresses(toAddresses);
            mail.setSaveAsActivity(false);
            mail.setHtmlBody(Body);
            mail.setSubject('Notificação de Produção Basica');
             
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            
            retorno[0] = 'Notificação OK';
            retorno[1] = 'ok';
              
            return retorno;
        }catch(exception e){
            retorno[0] = 'Error al Notificar.';
            retorno[1] = '';
                 
            return retorno;
        }
    }
    
    webservice static String[] clonarOpp(Id oppId) {
        Opportunity OppClone = New Opportunity();
        Map<String,Id> rType = New Map<String,Id>();
        Savepoint sp;
        String[] retorno = New String[3];
        
        try{
            for(RecordType r : [Select Id, Name From RecordType Where Name in ('PB-Comercial', 'PB-Desarrollo', 'PB-Produccion')]){
                rType.put(r.Name, r.Id);
            }
          
          sp = Database.setSavepoint(); 
          List<OpportunityLineItem> nuevosItems = New List<OpportunityLineItem>();
          Boolean cantidadesNulas = false;
          String soql = previsionesController.getCreatableFieldsSOQL('Opportunity','Id=\'' + oppId + '\'');
          Opportunity oppAClonar = (Opportunity)Database.query(soql);
          OppClone = oppAClonar.clone(false, true);
          OppClone.Tipo_de_Operacion__c = '';
          OppClone.StageName = 'PB-Pendiente';
          OppClone.Notificado__c = false;
          OppClone.Rebaja__c = false;
          OppClone.Comentarios__c = '';
          OppClone.OwnerId = UserInfo.getUserId();
          if(UserInfo.getName() == 'Carlos Pattis' || UserInfo.getName() == 'Administrador'){
                OppClone.RecordTypeId = rType.get('PB-Produccion');
                OppClone.Description = 'ok'; //Le pongo un valor a este campo para indicar que la PB-Produccion se esta generando desde clonar. Para que no se permita crear desde nueva opp a menos que sea una rebaja.
          }
          if(UserInfo.getName() == 'Ricardo Franconere')
                OppClone.RecordTypeId = rType.get('PB-Comercial');                      
          if(UserInfo.getName() == 'Julio Cesar Poletto')
                OppClone.RecordTypeId = rType.get('PB-Desarrollo');
           
          insert OppClone;
          
          List<OpportunityLineItem> items = [Select Id, OpportunityId, PriceBookEntryId, UnitPrice, Quantity, Semente_aprovada__c, Semente_comercializada__c, Categoria__c From OpportunityLineItem Where OpportunityId = : oppId];        
       
          String soqlOLI = previsionesController.getCreatableFieldsSOQL('OpportunityLineItem','OpportunityId=\'' + oppId + '\'');
          List<OpportunityLineItem> prodOLIaClonar = (List<OpportunityLineItem>)Database.query(soqlOLI);
       
          for (OpportunityLineItem i : prodOLIaClonar){       
                OpportunityLineItem nuevo_item = i.clone(false,true);
                nuevo_item.OpportunityId = OppClone.Id;
                nuevo_item.TotalPrice = null;
                //if (OppClone.RecordTypeId == rType.get('PB-Comercial') || OppClone.RecordTypeId == rType.get('PB-Desarrollo'))
                if(UserInfo.getName() != 'Robert Moser')
                    nuevo_item.quantidade__c = 0;
                nuevosItems.add(nuevo_item);          
          }

          insert nuevosItems;
       
          retorno[0] = 'Foi criada a oportunidade. Lembre-se de carregar o tipo de operação';
          retorno[1] = 'ok';
          retorno[2] = OppClone.Id;
          
          return retorno;
          
          //return 'Se ha creado el siguiente stock de multiplicadores.';

       }catch(exception ex){
            String mens = ex.getMessage();
            
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            //mens += String.ValueOf(ex.getLineNumber()) + ex.getStackTraceString();   
           Database.rollback(sp);
           retorno[0] = 'Falha ao criar a oportunidade. ' + mens;
           retorno[1] = '';
           retorno[2] = '';
           
           return retorno;     
       }
        
    }
    
    webservice static String[] validarPasoVBSAP(Id opId){
        Boolean impuestosOK = true;
        String[] retorno = New String[2];
        retorno[0] = 'OK';
        retorno[1] = 'OK';
        //Set <Id> oplisRel = New Set<Id>();
        Map<Id,OpportunityLineItem> oplisSAP = New Map<Id, OpportunityLineItem>();
        for(OpportunityLineItem opli : [SELECT Id, OpportunityId, Base_de_Calculo__c, Tasas__c, Quantity, Id_Item_de_Oportunidad_Relacionado__c FROM OpportunityLineItem WHERE OpportunityId = :opId]){
            //if(opli.Base_de_Calculo__c == null || opli.Tasas__c == null) impuestosOK = false;
            oplisSAP.put(opli.Id_Item_de_Oportunidad_Relacionado__c, opli);
        }
        if(!impuestosOK){ 
            retorno[0] = 'Error na determinação do preço (erro na determinação das taxas fiscais). Contatar ao administrador do sistema.';
            retorno[1] = '';
            return retorno;
        }
        system.debug('validVB 1');
        for(OpportunityLineItem opli : [SELECT Id, OpportunityId, PricebookEntry.Product2.Variedade__r.Name, PricebookEntry.Product2.Categ__r.Name, Quantity, Id_Item_de_Oportunidad_Relacionado__c, Quant_Pendiente__c FROM OpportunityLineItem WHERE Id IN :oplisSAP.keySet()]){
            system.debug('validVB 2');
            if(opli.Quant_Pendiente__c < oplisSAP.get(opli.Id).Quantity){
                system.debug('validVB 3');
                if(retorno[0] == 'OK'){retorno[0] = 'Existem variedades que não podem ser baixadas a SAP porque superam a quantidade pendente da Oferta.';}
                retorno[0] += ' \r\n' + opli.PricebookEntry.Product2.Variedade__r.Name +' '+ opli.PricebookEntry.Product2.Categ__r.Name;
                retorno[1] = '';
            }
        }
         
        return retorno;
    }
    
    public static String[] actualizarPasoVBSAP(Id opId, Boolean cancOp) {
        String[] retorno = new String[]{'OK', 'OK'};
        Integer mult = cancOp ? -1 : 1;

        try {
            List<OpportunityLineItem> listaItemsParaActualizarEstado = new List<OpportunityLineItem>();
            Map<Id,OpportunityLineItem> oplisSAP = new Map<Id,OpportunityLineItem>();

            for (OpportunityLineItem opli : [SELECT Id, Quantity, Id_Item_de_Oportunidad_Relacionado__c, Product2.CANTIDAD_SUB_UNIDAD__c FROM OpportunityLineItem WHERE OpportunityId = :opId]) {
                oplisSAP.put(opli.Id_Item_de_Oportunidad_Relacionado__c, opli);
            }

            for (OpportunityLineItem opli : [SELECT Id, OpportunityId, Quant_Pendiente__c, Quant_Confirmada__c, Product2.CANTIDAD_SUB_UNIDAD__c FROM OpportunityLineItem WHERE Id IN :oplisSAP.keySet()]) {
                OpportunityLineItem opliSAP = oplisSAP.get(opli.Id); // OpportunityLineItem con cantidades a confirmar en VB Completa o VB Pasada SAP
                opli.Quant_Confirmada__c += ((opliSAP.Quantity * Double.valueOf(opliSAP.Product2.CANTIDAD_SUB_UNIDAD__c)) / Double.valueOf(opli.Product2.CANTIDAD_SUB_UNIDAD__c)) * mult;
                listaItemsParaActualizarEstado.Add(opli);
            }

            update listaItemsParaActualizarEstado;
        } catch(Exception e) {
            retorno[0] = 'Erro ao actualizar a Oferta. Contatar ao administrador do sistema. \r\n Error: ' + e.getMessage();
            retorno[1] = '';
        }

        return retorno;
    }
    
    webservice static String[] notificacionContacto(Id contId, Id userId) {
        String Body = '';
        String[] retorno = New String[2];
        User u = [SELECT Id, Username, Name, Profile.Name, Email, IsActive, UserRoleId, ProfileId FROM User WHERE Id = :userId];

        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             
            //Macrorregi_o_de_Vendas__c region = [SELECT id, Name FROM Macrorregi_o_de_Vendas__c WHERE Id =: regionId LIMIT 1];
            Contact cont = [SELECT Id, MasterRecordId, AccountId, Account.Name, LastName, FirstName, Name FROM Contact WHERE Id = :contId];
            
            Body = 'O Supervisor Comercial ' + u.Name +' deseja eliminar o seguinte contato: \r\n'; 

                Body += 'Nome: ' + cont.Name + '\r\n';
                Body += 'Cuenta: ' + cont.Account.Name + '\r\n'; 

                Body += 'Acessar:   ' + URL.getSalesforceBaseUrl().toExternalForm() + cont.Id;  ///PRODUCTIVO
                //Body += 'Acessar:   https://cs16.salesforce.com/' + cont.Id;  ///SANDBOX
                

            //EmailTemplate et = [SELECT id FROM EmailTemplate WHERE Name = 'Notificación Producción Básica'];
            
            mail.setTargetObjectId('00540000002nK10'); // PRODUCTIVO  Specify who the email should be sent to.
            //mail.setTargetObjectId('00540000001TUHM'); // SANDBOX  Specify who the email should be sent to.
             
            mail.setSenderDisplayName('Contato para Eliminar.');
            String[] toAddresses = new String[] {'salesforce@gdmseeds.com'};
            
            //mail.setTemplateId(et.id);
            mail.setCcAddresses(toAddresses);
            mail.setSaveAsActivity(false);
            mail.setPlainTextBody(Body);
            mail.setSubject('Contato para Eliminar.');
            //mail.setWhatId(oppId);
             
            if (!Test.isRunningTest())
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            
            retorno[0] = 'Solicitação OK';
            retorno[1] = 'ok';
              
            return retorno;
        }catch(exception e){
            retorno[0] = 'Erro na Solicitação.';
            retorno[1] = '';
                 
            return retorno;
        }
    }
    
    
    webservice static String consultarOfertaSAP() {
        sapOferta.data_element[] resultado;
        
        sapOferta.SI_Sync_WebServicePort soap = new sapOferta.SI_Sync_WebServicePort();
        
        soap.inputHttpHeaders_x = new Map<String, String>();
        String encodedusernameandpassword;
        
        String myData = 'xioma:DM2016';
        Blob hash = Blob.valueOf(myData);
        encodedusernameandpassword = EncodingUtil.base64Encode(hash);
        soap.timeout_x = 90000;
        soap.inputHttpHeaders_x.put('Authorization', 'Basic '+ encodedusernameandpassword);
        
        if (!Test.isRunningTest())
            resultado = soap.SI_Sync_WebService();
        
        Savepoint sp;
        sp = Database.setSavepoint();
        String msg = '';
        try{
        
        String campania;
        Map<String, String> productos = New Map<String, String>();
        Map<String, String> productos2 = New Map<String, String>();
        RecordType rt = [Select Id From RecordType Where Name = 'PB-Oferta' And sObjectType = 'Opportunity' limit 1];
        User us = [Select Id From User Where Name = 'Carlos Pattis' limit 1];
        String safraActual = '15/16';        
        for (Configuracion_BMX__c conf : [Select Id, PB_Safra_Actual__c From Configuracion_BMX__c Where Name = 'Facturacion' limit 1])
            safraActual = conf.PB_Safra_Actual__c;                     
        if (resultado != null){
            if (resultado.size() > 0){
                for (PricebookEntry pbe : [Select Id, Product2.Variedade__r.Nombre_de_Registro__c, Product2.Variedade__r.Name, Product2.Categ__r.Name From PricebookEntry Where Pricebook2.Name = 'Lista de Básica - Prod. de Básica' And isActive = true And Product2.Semilla_Tratada__c = false And Product2.Unidade__c = 'SACA 40 KG']){
                    if (!productos.containsKey(pbe.Product2.Variedade__r.Nombre_de_Registro__c + pbe.Product2.Categ__r.Name))
                        productos.put(pbe.Product2.Variedade__r.Nombre_de_Registro__c + pbe.Product2.Categ__r.Name, pbe.Id);
                    if (!productos2.containsKey(pbe.Product2.Variedade__r.Name + pbe.Product2.Categ__r.Name))
                        productos2.put(pbe.Product2.Variedade__r.Name + pbe.Product2.Categ__r.Name, pbe.Id);    
                }               
                List<Opportunity> oppsDelete = New List<Opportunity>();
                List<Opportunity> oppsActEstado = New List<Opportunity>();
                oppsDelete = [Select Id From Opportunity Where RecordType.Name = 'PB-Oferta' And Safra__c = : safraActual And Oferta_Asignada__c = false];
                if (oppsDelete.size() > 0)
                    delete oppsDelete;
                oppsActEstado = [Select Id, Activa__c From Opportunity Where RecordType.Name = 'PB-Oferta' And Safra__c = : safraActual And Oferta_Asignada__c = true];
                if (oppsActEstado.size() > 0){
                    for (Opportunity o : oppsActEstado)
                        o.Activa__c = false;
                    update oppsActEstado;
                }
                
                Opportunity nuevaOferta = New Opportunity();
                nuevaOferta.Name = 'Oferta ' + system.today().day() + '/' + system.today().month() + '/' + system.today().year();
                nuevaOferta.RecordTypeId = rt.Id;
                nuevaOferta.StageName = 'PB-Pendiente';
                nuevaOferta.CloseDate = system.today();
                nuevaOferta.OwnerId = us.Id;
                nuevaOferta.Safra__c = safraActual;
                nuevaOferta.Activa__c = true;
                
                insert nuevaOferta;
                
                //List<OpportunityLineItem> itemsInsert = New List<OpportunityLineItem>();
                Map<String, OpportunityLineItem> mapitemsInsert = New Map<String, OpportunityLineItem>();
                for (sapOferta.data_element i : resultado){
                    //String varCateg = i.EXTMATLGRP + i.BASIC_MATL;
                    String idPBE = productos.get(i.EXTMATLGRP + i.BASIC_MATL);
                    if (idPBE == null)
                        idPBE = productos2.get(i.EXTMATLGRP + i.BASIC_MATL);
                    //if (productos.get(i.EXTMATLGRP + i.BASIC_MATL) != null && (i.BASIC_MATL.contains('BASICA') || i.BASIC_MATL.contains('C1') || i.BASIC_MATL.contains('C2') || i.BASIC_MATL.contains('S1') || i.BASIC_MATL.contains('S2')) && ((i.ZC_CMPN.substring(0,3) + i.ZC_CMPN.substring(5,7)) == safraActual || (i.ZC_CMPN.substring(0,3) + i.ZC_CMPN.substring(5,7)) == String.valueOf(Integer.valueOf(safraActual.substring(0,2)) + 1) + '/' + safraActual.substring(3,5))){
                    if (i.ZC_CMPN != null && i.ZC_CMPN != ''){
                        if (idPBE != null && (i.BASIC_MATL.contains('PREBA') || i.BASIC_MATL.contains('BASICA') || i.BASIC_MATL.contains('C1') || i.BASIC_MATL.contains('C2') || i.BASIC_MATL.contains('S1') || i.BASIC_MATL.contains('S2')) && ((i.ZC_CMPN.substring(0,3) + i.ZC_CMPN.substring(5,7)) == safraActual || (i.ZC_CMPN.substring(0,3) + i.ZC_CMPN.substring(5,7)) == String.valueOf(Integer.valueOf(safraActual.substring(0,2)) + 1) + '/' + safraActual.substring(3,5))){
                            OpportunityLineItem item;
                            if (!mapitemsInsert.containsKey(i.EXTMATLGRP + i.BASIC_MATL)){
                                item = New OpportunityLineItem();
                                item.OpportunityId = nuevaOferta.Id;
                                item.UnitPrice = 0.01;
                                item.Quantity = 0.01;
                                //item.PricebookEntryId = productos.get(i.EXTMATLGRP + i.BASIC_MATL);                                           
                                item.PricebookEntryId = idPBE;
                                item.Estimativa__c = i.ZR_PLEMVA;                                               
                                item.Certificacion__c = i.ZR_PLCERT;
                                item.Despacho__c = i.ZR_PLDESP;
                                item.Estoque_Granel__c = i.ZR_PLESGR;
                                item.Estoque_Sacas__c = i.ZR_PLESSA;
                                item.Compras_Pedido__c = i.ZR_PLCOPE;
                                item.Compras_Entrada_de_Mercaderia__c = i.ZR_PLENME;
                                item.Quantidade__c = i.ZR_PLSPR;
                                mapitemsInsert.put(i.EXTMATLGRP + i.BASIC_MATL, item);                                                      
                            }else{
                                item = mapitemsInsert.get(i.EXTMATLGRP + i.BASIC_MATL);
                                if (item.Estimativa__c != null){
                                    item.Estimativa__c += i.ZR_PLEMVA;
                                }else{
                                    item.Estimativa__c = i.ZR_PLEMVA;
                                }
                                if (item.Certificacion__c != null){                                             
                                    item.Certificacion__c += i.ZR_PLCERT;
                                }else{
                                    item.Certificacion__c = i.ZR_PLCERT;
                                }
                                if (item.Despacho__c != null){
                                    item.Despacho__c += i.ZR_PLDESP;
                                }else{
                                    item.Despacho__c = i.ZR_PLDESP;
                                }
                                if (item.Estoque_Granel__c != null){
                                    item.Estoque_Granel__c += i.ZR_PLESGR;
                                }else{
                                    item.Estoque_Granel__c = i.ZR_PLESGR;
                                }
                                if (item.Estoque_Sacas__c != null){
                                    item.Estoque_Sacas__c += i.ZR_PLESSA;
                                }else{
                                    item.Estoque_Sacas__c = i.ZR_PLESSA;
                                }
                                if (item.Compras_Pedido__c != null){
                                    item.Compras_Pedido__c += i.ZR_PLCOPE;
                                }else{
                                    item.Compras_Pedido__c = i.ZR_PLCOPE;
                                }
                                if (item.Compras_Entrada_de_Mercaderia__c != null){
                                    item.Compras_Entrada_de_Mercaderia__c += i.ZR_PLENME;
                                }else{
                                    item.Compras_Entrada_de_Mercaderia__c = i.ZR_PLENME;
                                }
                                if (item.Quantidade__c != null){
                                    item.Quantidade__c += i.ZR_PLSPR;
                                }else{
                                    item.Quantidade__c = i.ZR_PLSPR;
                                }
                                mapitemsInsert.remove(i.EXTMATLGRP + i.BASIC_MATL);
                                mapitemsInsert.put(i.EXTMATLGRP + i.BASIC_MATL, item);
                            }
                        }
                    }
                }
                
                insert mapitemsInsert.values();     
                     
            }
        }                               
        
        }catch(exception ex){
            Database.rollback(sp);
            return ex.getMessage();                
        }
        
        return 'SE CREO LA OFERTA.';
        //return msg;
        
    }  
    
    public static void activarStockMult(List<Id> oppsId) {
        Savepoint sp;
        sp = Database.setSavepoint();
        try{
            
            Opportunity opp = [Select Id, Activa__c, Marca__c, Safra__c, AccountId, Account.ParentId From Opportunity Where Id = :oppsId[0]];
            List<Opportunity> opps = New List<Opportunity>(); 
            opps = [Select Id, Activa__c From Opportunity Where AccountId = :opp.AccountId And Safra__c = :opp.Safra__c And Marca__c = :opp.Marca__c And RecordType.Name = 'Stock Multiplicadores' And Activa__c = true And Id != :oppsId[0]];
            if (opps.size() > 0){
                for (Opportunity o : opps)
                    o.Activa__c = false;
                update opps;
            }
            opp.Activa__c = true;
            update opp;         
            
            //02.07.2019
            if (opp.Marca__c == 'BRMX'){
                Integer cantStocks = 0;
                if (opp.Account.ParentId == null){
                    for (AggregateResult ar : [Select Max(Id) id, Mes__c mes From Opportunity Where AccountId = :opp.AccountId And Safra__c = :opp.Safra__c And Marca__c = :opp.Marca__c And RecordType.Name = 'Stock Multiplicadores' And StageName = 'Aprobada' And CreatedBy.Name = 'Portal Usuario' And Mes__c != null Group By Mes__c])
                        cantStocks ++;
                
                    List<CRM_Multiplicador__c> crm_mult = New List<CRM_Multiplicador__c>();
                    crm_mult = [Select Id, BR_Stock_Mult_Realizado__c From CRM_Multiplicador__c Where Cuenta__c = : opp.AccountId And Safra__c = : opp.Safra__c];
                    if (crm_mult.size() > 0){
                        crm_mult[0].BR_Stock_Mult_Realizado__c = cantStocks;
                        update crm_mult;
                    }
                }else{
                    for (AggregateResult ar : [Select Max(Id) id, Mes__c mes From Opportunity Where Account.ParentId = :opp.Account.ParentId And Safra__c = :opp.Safra__c And Marca__c = :opp.Marca__c And RecordType.Name = 'Stock Multiplicadores' And StageName = 'Aprobada' And CreatedBy.Name = 'Portal Usuario' And Mes__c != null Group By Mes__c])
                        cantStocks ++;
                
                    List<CRM_Multiplicador__c> crm_mult = New List<CRM_Multiplicador__c>();
                    crm_mult = [Select Id, BR_Stock_Mult_Realizado__c From CRM_Multiplicador__c Where Cuenta__r.ParentId = : opp.Account.ParentId And Safra__c = : opp.Safra__c];
                    if (crm_mult.size() > 0){
                        for (CRM_Multiplicador__c crm : crm_mult)
                            crm_mult[0].BR_Stock_Mult_Realizado__c = cantStocks;
                        update crm_mult;
                    }
                }
            }
            if (opp.Marca__c == 'NEOG'){
                Integer cantStocks = 0;
                for (AggregateResult ar : [Select Count(Id) id From Opportunity Where AccountId = :opp.AccountId And Safra__c = :opp.Safra__c And Marca__c = :opp.Marca__c And RecordType.Name = 'Stock Multiplicadores' And StageName = 'Aprobada' And CreatedBy.Profile.Name = 'Neogen Partner User'])
                    cantStocks = Integer.valueOf(ar.get('id'));
                
                List<CRM_Multiplicador__c> crm_mult = New List<CRM_Multiplicador__c>();
                crm_mult = [Select Id, NG_Stock_Mult_Realizado__c From CRM_Multiplicador__c Where Cuenta__c = : opp.AccountId And Safra__c = : opp.Safra__c];
                if (crm_mult.size() > 0){
                    crm_mult[0].NG_Stock_Mult_Realizado__c = cantStocks;
                    update crm_mult;
                }
            }
            
        }catch(exception ex){
            Database.rollback(sp);                           
        }   
    }
    
    public static void validarAnexos(List<Id> oppsId) {
     
        Opportunity opp = [Select Id, AccountId, Marca__c, Safra__c, RecordType.Name From Opportunity Where Id = :oppsId[0]];
     
        if (opp.RecordType.Name == 'Anexo II')
            validacionAII(opp);
        
        if (opp.RecordType.Name == 'Anexo IV')
            validacionAIV(opp);                 
                            
    }
  
    public static void validacionAII(Opportunity o){
        
        String descripcion = '';
        for (OpportunityLineItem i : [Select Id, Semente_bruta__c, Area_Plantada__c, PricebookEntry.Product2.Variedade__r.Name, PricebookEntry.Product2.Categ__r.Name From OpportunityLineItem Where OpportunityId = :o.Id]){
            if (i.Area_Plantada__c != 0){
                if (i.Semente_bruta__c == null)
                    i.Semente_bruta__c = 0;
                Double semXHa = (i.Semente_bruta__c / i.Area_Plantada__c).divide(1, 2, System.RoundingMode.HALF_EVEN);
                if (semXHa > 120)
                    descripcion += i.PricebookEntry.Product2.Variedade__r.Name + ' ' + i.PricebookEntry.Product2.Categ__r.Name + ': ' + semXHa + ' Sacas x Ha.\n';
            }
        }
        
        if (descripcion != '')
            crearCaso(o.AccountId, o.Marca__c, 'Anexo II', 'Semente bruta x Has plantadas', descripcion);
        
    }
    
    public static void validacionAIV(Opportunity o){
      
        Map<String, AggregateResult> mapVari = New Map<String, AggregateResult>();
      
        for (AggregateResult ar : [Select PricebookEntry.Product2.Variedade__r.Name vari, Sum(Meta__c) meta, Sum(Semente_comercializada__c) semC, Sum(Semente_uso_propio__c) semUP From OpportunityLineItem Where Opportunity.AccountId = : o.AccountId And Opportunity.Safra__c = :o.Safra__c And Opportunity.Marca__c = :o.Marca__c And (Opportunity.RecordType.Name = 'Objetivo Contrato Royalties' Or ((Opportunity.RecordType.Name = 'Anexo III' Or Opportunity.RecordType.Name = 'Anexo IV') And Opportunity.StageName = 'Aprobada')) Group By PricebookEntry.Product2.Variedade__r.Name]){
            Double semC = Double.valueOf(ar.get('semC'));
            Double semUP = Double.valueOf(ar.get('semUP'));
            Double meta = Double.valueOf(ar.get('meta'));
            if (semC == null)
                semC = 0;
            if (semUP == null)
                semUP = 0;
            if (meta == null)
                meta = 0;        
            if (semC + semUP > meta)
                mapVari.put(String.valueOf(ar.get('vari')), ar);        
        }
            
        if (mapVari.size() > 0){
            String descripcion = '';
            for (String s : mapVari.keySet()){
                AggregateResult ar2 = mapVari.get(s);
                Double semC = Double.valueOf(ar2.get('semC'));
                Double semUP = Double.valueOf(ar2.get('semUP'));
                Double meta = Double.valueOf(ar2.get('meta'));
                if (semC == null)
                    semC = 0;
                if (semUP == null)
                    semUP = 0;
                if (meta == null)
                    meta = 0;
                descripcion += s + ': Semente Comer. + UP: ' + (semC + semUP) + ' - Semente Autorizada: ' +  meta + '\n';   
            }
            crearCaso(o.AccountId, o.Marca__c, 'Anexo IV', 'Volume autorizado x comercializado', descripcion);
        }   
            
    }
  
    public static void crearCaso(String idCuenta, String marca, String origen, String asunto, String descripcion){             
                
        Case c = New Case();        
        
        //try{
        
            RecordType rt = [Select Id From RecordType Where Name = 'Fiscalização' And SObjectType = 'Case'];                        
            
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;        
        
            c.RecordTypeId = rt.Id;
            c.AccountId = idCuenta;
            c.Marca__c = marca;
            c.subject = asunto;
            c.description = descripcion;
            c.status = 'Novo';
            c.origin = origen;           
            c.setOptions(dmo);
        
            insert c;
                    
        //}catch(Exception e){
            //return e.getMessage();
        //}                         
        
    }      
    
}
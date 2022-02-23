global class Opp_Utils2
{
    private static Id rt_comer_brasmax_opps = Schema.SObjectType.Opportunity
            .getRecordTypeInfosByDeveloperName()
            .get('Comercial')
            .getRecordTypeID();

    private static Id rt_franq_brasmax_opps =  Schema.SObjectType.Opportunity
            .getRecordTypeInfosByDeveloperName()
            .get('VENTA_DE_BASICA')
            .getRecordTypeID();


    webservice static String anularOpportunidad(String idOportunidad) {
        Savepoint savePoint = Database.setSavepoint();
        String retorno = '';

        try {
            Opportunity oportunidad = [
                SELECT Id, StageName 
                FROM Opportunity 
                WHERE Id =: idOportunidad
            ];
            oportunidad.StageName = 'AN - Anulada';
            update oportunidad;
            retorno = 'Oportunidad anulada.'; 

        } catch(Exception e) {                                     
            retorno = 'Error al anular la oportunidad. \n\n' + e.getMessage();
            Database.rollback(savePoint);                        
        }
        return retorno;
    }

    webservice static String liberarParaEdicionOpp(String idOportunidad) {

        Savepoint savePoint = Database.setSavepoint();
        String retorno = '';

        try {
            Opportunity oportunidad = [
                SELECT Id, StageName 
                FROM Opportunity 
                WHERE Id =: idOportunidad
            ];
            
            if (oportunidad.StageName != 'Aprobada') {
                retorno = 'Para liberar para edicion la etapa debe ser Aprobada.';
                return retorno;
            }
            
            System.Approval.unlock(idOportunidad);
                
            oportunidad.StageName = 'Edición';
            update oportunidad;
            
            retorno = 'Se ha liberado la oportunidad para edicion.';
            
        } catch(Exception e) {                                     
            retorno = 'Error al liberar la oportunidad para edicion. \n\n' + e.getMessage();
            Database.rollback(savePoint);                        
        }

        return retorno;
    }

    webservice static String liberarParaEdicionTA(String idTA) {
        Savepoint savePoint = Database.setSavepoint();
        String retorno = '';

        try {
            List<Contrato__c> ta = [
                SELECT Id, Estado__c 
                FROM Contrato__c 
                WHERE Id = : idTA
            ];                        
            
            System.Approval.unlock(idTA);
                
            //ta[0].Estado__c = 'Edição';
            //update ta;
            
            retorno = 'Se ha liberado el TA.';
            
        } catch(Exception e) {                                     
            retorno = 'Error al liberar el TA para edicion. \n\n' + e.getMessage();
            Database.rollback(savePoint);                        
        }
            return retorno;
    }

    webservice static String bloquearTA(String idTA) {
        Savepoint savePoint = Database.setSavepoint();
        String retorno = '';

        try {                  

            System.Approval.lock(idTA);
            retorno = 'Se ha bloqueado el TA.';

        } catch(Exception e) {                                     
            retorno = 'Error al bloquear el TA. \n\n' + e.getMessage();
            Database.rollback(savePoint);                        
        }
        return retorno;
    }

    public static Map<String,OpportunityLineItem> mapaValidacion(Opportunity oportunidad) {
        
        Map<String,OpportunityLineItem> pbeMap = new Map<String,OpportunityLineItem>();     
        String safra = '%' + oportunidad.safra__c.substring(2,5);
        List<OpportunityLineItem> lineItemsLista = [
                SELECT Id, PricebookEntryId, Semente_comercializada__c,
                Semente_uso_propio__c, Area_Plantada__c, Area__c,
                Semente_aprovada__c, Semente_bruta__c, Semente_beneficiada__c
                FROM OpportunityLineItem 
            	WHERE opportunityid != :oportunidad.id 
                AND opportunity.AccountId = :oportunidad.accountId 
                AND Opportunity.RecordTypeId = :oportunidad.RecordTypeId
                AND Opportunity.Safra__c like :safra
            ];
        
        for(OpportunityLineItem lineItem : lineItemsLista) {
                OpportunityLineItem lineItem_2 = pbeMap.get(lineItem.pricebookentryid);
                if(lineItem_2 == null) {
                    lineItem_2 = new OpportunityLineItem (
                        Semente_aprovada__c = 0,
                        Semente_comercializada__c = 0,
                        Area_Plantada__c= 0 ,
                        Semente_uso_propio__c = 0,
                        Area__c = 0,
                        Semente_beneficiada__c = 0,
                        Semente_bruta__c = 0,
                        PricebookEntryId = lineItem.pricebookentryid
                    );
                    pbeMap.put(lineItem.pricebookEntryId, lineItem_2);
                }
                if(lineItem.Semente_bruta__c != null) {
                    lineItem_2.Semente_bruta__c += lineItem.Semente_bruta__c;
                }
                if(lineItem.Semente_beneficiada__c != null) {
                    lineItem_2.Semente_beneficiada__c += lineItem.Semente_beneficiada__c;
                }
                if(lineItem.Semente_aprovada__c != null) {
                    lineItem_2.Semente_aprovada__c += lineItem.Semente_aprovada__c;
                }
                if(lineItem.Area_Plantada__c != null) {
                    lineItem_2.Area_Plantada__c += lineItem.Area_Plantada__c;
                }
                if(lineItem.Area__c != null) {
                    lineItem_2.Area__c += lineItem.Area__c;
                }
            }
        return pbeMap;
    }

    public static Boolean mapaMensajes(OpportunityLineItem item, Double area2, Double area_p, 
                                       Double area, Double uso_ant, Double basica, Double ben,
                                       Double aprov, Double bruta) {
        Boolean paso = false;
        String variedad = item.Variedade_Prod__c;
        String name = item.PricebookEntry.Product2.Name;
                
        if(area2 > 0 && (uso_ant + basica) / area2 < 1) {

            paso = true;
            if((uso_ant + basica) / area2 > 0.86)  {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, variedad + ' - Basica: ' + String.valueOf(basica) 
                + ' - Uso Proprio: ' + String.valueOf(uso_ant) + ' - Ha.Autorizado: ' + String.valueOf(area2) + ': Menos de uma saca por hectare.'));               
            } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, variedad + ' - Basica: ' + String.valueOf(basica) 
                    + ' - Uso Proprio: ' + String.valueOf(uso_ant) + ' - Ha.Autorizado: ' + String.valueOf(area2) + ': Menos de uma saca por hectare.'));
            }
        }
        return paso;
    }

    public static Boolean mapaMensajes2(OpportunityLineItem item, Double area2,
                                        Double area_p, Double area, Double uso_ant,
                                        Double basica, Double ben, Double aprov, Double bruta) {
        Boolean paso = false;
        String variedad = item.Variedade_Prod__c;
        String name = item.PricebookEntry.Product2.Name;

        if(area_p > area) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, variedad + ' - Ha.Autorizados: ' + String.valueOf(area)
            + ' - Ha.Plantados: ' + String.valueOf(area_p) + ': A area plantada não pode ser maior que a area autorizada.' ));
            paso = true;
        }

        if(ben > bruta) {                
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, name + ' - Beneficiada: ' + String.valueOf(ben)
            + ' - Bruta: ' + String.valueOf(bruta) + ': A semente beneficiada não pode ser maior que a bruta.' ));
            paso = true;
        }

        if(aprov > ben) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, name + ' - Aprovada: ' + String.valueOf(aprov)
            + ' - Beneficiada: ' + String.valueOf(ben) + ': A semente aprovada não pode ser maior que a beneficiada.' ));
            paso = true;                
        }

        return paso;
    }

    public static Boolean validarFranqueados(List<OpportunityLineItem> itemList, Opportunity oportunidad) {
        Set<String> CultivarIds = new Set<String>();
        List<Contrato__c> contratos = [            
            SELECT c.Id, c.Cultivar__r.Variedad__c,
            c.Cultivar__r.Variedade__c, c.Cultivar__r.Variedade__r.Name 
            FROM Contrato__c c
            WHERE c.Multiplicador__c =: oportunidad.AccountId
        ];
        
        for(Contrato__c contrato : contratos) {
            CultivarIds.add(contrato.Cultivar__r.Variedad__c);
        }

        for (OpportunityLineItem item :itemList) {
            if(!CultivarIds.contains(item.PricebookEntry.Product2.Variedad__c)) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, item.Variedade_Prod__c + ' - A conta não possui contrato desse produto.'));
                return false;
            }
        }
        return true;
    }

    public static Double valCantBasica(Product2 producto, Opportunity oportunidad) {
        String safra = '%' + oportunidad.safra__c.substring(2,5);       
        String conta = oportunidad.AccountId;
        String variedad = producto.Variedad__c;
        String categ = producto.Categoria__c;
        Double basica = 0;

        if(categ == 'Basica') {
            return 999999;
        }
            
        list<OpportunityLineItem> lineItemsLista = [
            SELECT id, Qtde_Scs_40kg__c 
            FROM Opportunitylineitem 
            WHERE pricebookentry.product2.Variedad__c =: variedad 
            AND pricebookentry.product2.Categoria__c = 'Basica' 
            AND Opportunity.RecordTypeid =: rt_franq_brasmax_opps
            AND Opportunity.AccountId =: conta
            AND Opportunity.Safra__c like :safra
        ];
        for(OpportunityLineItem lineItem : lineItemsLista) {
            if(lineItem.Qtde_Scs_40kg__c != null) {
                basica += lineItem.Qtde_Scs_40kg__c;
            }
        }
        return basica;
    }

    public static Double valCantUsoPropio(Product2 producto, Opportunity oportunidad) {
        String safraAnt = String.valueOf(Integer.valueOf(oportunidad.safra__c.substring(3,5)) - 1);

        if(safraAnt.length() == 1) {
            safraAnt = '0' + safraAnt;
        }

        safraAnt = '%/' + safraAnt;

        String conta = oportunidad.AccountId;
        String variedad = producto.Variedad__c;
        String categoria = producto.Categoria__c;
        Double uso = 0;

        if(categoria == 'Basica') {
            return 999999;
        } 

        List<String> categorias = new List<String>();

        if(categoria == 'C2' || categoria == 'S1' || categoria == 'S2' || categoria == 'C1') {
            categorias.add('Basica');
        }
            
            
        if(categoria == 'C2' || categoria == 'S1' || categoria == 'S2') {
            categorias.add('C1');
        }
            
        if(categoria == 'S1' || categoria == 'S2') {
            categorias.add('C2');
        }

        if(categoria == 'S2') {
            categorias.add('S1');
        }

        
        List <OpportunityLineItem> lineItemsList  = [
                SELECT id, Semente_uso_propio__c FROM Opportunitylineitem 
                WHERE pricebookentry.product2.variedad__c = :variedad 
                AND pricebookentry.product2.Categoria__c in :categorias 
                AND Opportunity.RecordTypeid = :rt_comer_brasmax_opps
                AND Opportunity.AccountId = :conta AND Opportunity.Safra__c like :safraAnt
            ];
        for(OpportunityLineItem item : lineItemsList) {
                if(item.Semente_uso_propio__c != null) {
                    uso += item.Semente_uso_propio__c;
                }
        }
        return uso;
    }

    public static Map<String,PricebookEntry> cargarRoyaltyPricebookEntries(String lp_name) {

        Map<String,PricebookEntry> mapaPriceBook = new Map<String,PricebookEntry>();

        List<PricebookEntry> listaPrecios = [
            SELECT Id, Product2.Variedade__c, Product2.Variedade__r.Name, Name, Pricebook2Id
            FROM PricebookEntry
            WHERE Product2.Family = 'Royalty x Basica' 
            AND Product2.Categ__r.Name = 'BASICA'
            AND Pricebook2.Name = :lp_name 
            AND isActive = true
        ];

        for (PricebookEntry priceBook : listaPrecios) {
            mapaPriceBook.put(priceBook.Product2.Variedade__c, priceBook);
        }
            
        return mapaPriceBook;
    }


	public static Map<String,PricebookEntry> cargarPricebookEntries(String lp_name) {

        Map<String,PricebookEntry> mapaPriceBook = new Map<String,PricebookEntry>();

        List<PricebookEntry> listaPrecios = [
            SELECT Id, Product2.Variedade__c, Product2.Variedade__r.Name, Name, Pricebook2Id
            FROM PricebookEntry
            WHERE Pricebook2.Name = :lp_name 
            AND isActive = true
        ];

        for (PricebookEntry priceBook : listaPrecios) {
            mapaPriceBook.put(priceBook.Product2.Variedade__c, priceBook);
        }
            
        return mapaPriceBook;
    }

    public static Map<String,String> cargarRecordTypesOportunidadPorDeveloperName() {

        Map<String,String> mapRecordTypes = new Map<String,String>();

        List<RecordType> recordsTypes = [
            SELECT Id, DeveloperName, Name 
            FROM RecordType 
            WHERE SobjectType = 'Opportunity' 
            AND isActive = true
        ];

        for(RecordType recordType : recordsTypes) {         
            mapRecordTypes.put(recordType.DeveloperName, recordType.Name);
        }
        return mapRecordTypes;
    }

    public static Map<String, Id> cargarRecordTypesOportunidades() {

        Map<String,Id> mapRecordTypes = new Map<String,Id>();
        Schema.Describesobjectresult descripcion = Opportunity.sObjectType.getDescribe();
        //Map<String, Schema.Recordtypeinfo> recordType = descripcion.getRecordTypeInfosByName();
        Map<String, Schema.Recordtypeinfo> recordType = descripcion.getRecordTypeInfosByDeveloperName();

        for(String record : recordType.keySet()) {
            mapRecordTypes.put(record, recordType.get(record).getRecordTypeId());
        }
        return mapRecordTypes;
    }    

    public static String duplicarPedido (Id idOportunidad) {
        try {
            String st_PE = 'PE - Pendiente';
            Opportunity oportunidad = [
                SELECT Id, Name, RecordType.Name,
                AccountId, Fecha_fijacion_T_de_cambio__c, 
                CloseDate, VB_Cot_Soja__c, Safra__c, 
                Tipo_de_Cambio__c, Sucursal__c, 
                Tipo_de_Cota_o__c, Condicion_de_Pago__c, 
                Relatorio_Relacionado__c, Tipo__c, OwnerId,
                Marca__c, Invierno__c, Origen__c, 
                VB_Chegou_na_Brasmax__c, Vencimiento_Anexo__c 
                FROM Opportunity 
                WHERE Id = : idOportunidad
            ];

            String rtName = 'Pendiente';
            if(oportunidad.RecordType.Name == 'NC - Autorizada' || oportunidad.RecordType.Name == 'NC - Pendiente' 
                || oportunidad.RecordType.Name == 'NC - Rechazada') {
                    rtName = 'NC - Pendiente';
                }

            RecordType recordYType = [
                SELECT Id
                FROM RecordType
                WHERE Name = :rtName
                LIMIT 1
            ];
            
            List<OpportunityLineItem> items = [
                SELECT Id, OpportunityId, PriceBookEntryId, UnitPrice, 
                Id_Item_de_Oportunidad_Relacionado__c, Quantity, 
                Tasas__c, Categoria__c, Produto_Rebaixado__c 
                FROM OpportunityLineItem 
                WHERE OpportunityId = : idOportunidad
            ];

            List<OpportunityLineItem> listaOportunidades = new List<OpportunityLineItem>();

            Opportunity nuevaOportunidad = New Opportunity();

            if (!oportunidad.Name.contains('COPIA')) {
                nuevaOportunidad.Name = oportunidad.Name + ' COPIA 1';
            } else {
                String nro_copia = oportunidad.Name.split('COPIA')[1].trim();
                Integer nro_copia_aux = Integer.valueOf(nro_copia);
                nro_copia_aux = nro_copia_aux + 1;
                nuevaOportunidad.Name = oportunidad.Name.split('COPIA')[0].trim() + ' COPIA ' + String.valueOf(nro_copia_aux);
            }      
                
            nuevaOportunidad.AccountId = oportunidad.AccountId;
            nuevaOportunidad.Fecha_fijacion_T_de_cambio__c = oportunidad.Fecha_fijacion_T_de_cambio__c;
            nuevaOportunidad.CloseDate = oportunidad.CloseDate;
            nuevaOportunidad.VB_Cot_Soja__c = oportunidad.VB_Cot_Soja__c;
            nuevaOportunidad.Safra__c = oportunidad.Safra__c;
            nuevaOportunidad.Tipo_de_Cambio__c = oportunidad.Tipo_de_Cambio__c;
            nuevaOportunidad.Sucursal__c = oportunidad.Sucursal__c;
            nuevaOportunidad.Tipo_de_Cota_o__c = oportunidad.Tipo_de_Cota_o__c;
            nuevaOportunidad.Condicion_de_Pago__c = oportunidad.Condicion_de_Pago__c;
            nuevaOportunidad.Relatorio_Relacionado__c = oportunidad.Relatorio_Relacionado__c;
            nuevaOportunidad.Tipo__c = oportunidad.Tipo__c;
            nuevaOportunidad.OwnerId = oportunidad.OwnerId;
            nuevaOportunidad.Marca__c = oportunidad.Marca__c; 
            nuevaOportunidad.Invierno__c = oportunidad.Invierno__c;
            nuevaOportunidad.Origen__c = oportunidad.Origen__c;
            nuevaOportunidad.VB_Chegou_na_Brasmax__c = oportunidad.VB_Chegou_na_Brasmax__c;

            nuevaOportunidad.RecordTypeId = recordYType.Id;
            nuevaOportunidad.StageName = st_PE;
            nuevaOportunidad.Vencimiento_Anexo__c = oportunidad.Vencimiento_Anexo__c;

            insert nuevaOportunidad;

            for (OpportunityLineItem lineItem : items) { 
                OpportunityLineItem NuevoItem = New OpportunityLineItem();
                nuevoItem.OpportunityId = nuevaOportunidad.Id;
                nuevoItem.PriceBookEntryId = lineItem.PriceBookEntryId;
                nuevoItem.UnitPrice = lineItem.UnitPrice;
                nuevoItem.Id_Item_de_Oportunidad_Relacionado__c = lineItem.Id_Item_de_Oportunidad_Relacionado__c;
                nuevoItem.Quantity = lineItem.Quantity;
                nuevoItem.Tasas__c = lineItem.Tasas__c;
                nuevoItem.Produto_Rebaixado__c = lineItem.Produto_Rebaixado__c;
                nuevoItem.Categoria__c = lineItem.Categoria__c;
                listaOportunidades.add(NuevoItem);          
            }
            insert listaOportunidades;
            return 'El pedido se ha duplicado: ' + nuevaOportunidad.Name;

        } catch(System.CalloutException ex) {       
            return 'Error al duplicar el Pedido';       
        }
    }         

    webservice static String[] proximaOportunidad(Id idOportunidad) {

        String[] retorno;       
        Opportunity oportunidad = [
            SELECT Id, RecordType.Name
            FROM Opportunity
            WHERE Id =: idOportunidad
        ];

        if (oportunidad.RecordType.Name == 'Stock Multiplicadores') {
            retorno = proximoStockMult(idOportunidad);
        }

        if (oportunidad.RecordType.Name == 'Objetivo Ventas Royalties') {
            retorno = proximoObjetivoVentaRoyalties(idOportunidad);
        }
        return retorno;         
    }

    webservice static String[] proximoObjetivoVentaRoyalties(Id idOportunidad) {

        Savepoint savePoint;
        String[] retorno = New String[3];
        try {
            
            savePoint = Database.setSavepoint();                                                                                   
            
            Opportunity OppClone = New Opportunity();
            Map<String,Id> rType = New Map<String,Id>();                                    
            List<OpportunityLineItem> nuevosItems = New List<OpportunityLineItem>();            
            String soql = previsionesController.getCreatableFieldsSOQL('Opportunity','Id=\'' + idOportunidad + '\'');
            Opportunity oppAClonar = (Opportunity)Database.query(soql);
            OppClone = oppAClonar.clone(false, true);   
            OppClone.Mes__c = getSiguienteMes(OppClone.Mes__c);       
            
            insert OppClone;
            
            List<OpportunityLineItem> items = [
                SELECT Id, OpportunityId, PriceBookEntryId, Quantidade__c 
                FROM OpportunityLineItem 
                WHERE OpportunityId = : idOportunidad
            ];        

            String soqlOLI = previsionesController.getCreatableFieldsSOQL('OpportunityLineItem','OpportunityId=\'' + idOportunidad + '\'');
            List<OpportunityLineItem> prodOLIaClonar = (List<OpportunityLineItem>)Database.query(soqlOLI);

            for (OpportunityLineItem i : prodOLIaClonar) {       
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
                                                                                                
        } catch(System.CalloutException ex) {       
            
            Database.rollback(savePoint);
            retorno[0] = 'Falha ao criar a oportunidade para o próximo mês.';
            retorno[1] = '';
            retorno[2] = '';
            
            return retorno;
        }
    }

    webservice static String[] proximoStockMult(Id idOportunidad) {

        Savepoint savePoint;
        String[] retorno = New String[3];

        try {
            savePoint = Database.setSavepoint(); 
            List<OpportunityLineItem> nuevosItems = New List<OpportunityLineItem>();
            Boolean cantidadesNulas = false;
            Opportunity oportunidad = [
                SELECT Id, Name, AccountId, CloseDate, Safra__c, Mes__c,
                Tipo__c, OwnerId, StageName, Marca__c, RecordTypeId
                FROM Opportunity
                WHERE Id =: idOportunidad
                LIMIT 1
            ];
            List<OpportunityLineItem> items = [
                SELECT Id, OpportunityId, PriceBookEntryId, UnitPrice, Quantity,
                Semente_aprovada__c, Semente_comercializada__c, estimativa__c, Categoria__c
                FROM OpportunityLineItem
                WHERE OpportunityId =: idOportunidad
            ];        

            Opportunity nueva_op = New Opportunity();
            nueva_op.Name = oportunidad.Name;
            nueva_op.AccountId = oportunidad.AccountId;          
            nueva_op.CloseDate = oportunidad.CloseDate;          
            nueva_op.Safra__c = oportunidad.Safra__c;
            nueva_op.Mes__c = getSiguienteMes(oportunidad.Mes__c);
            nueva_op.Tipo__c = oportunidad.Tipo__c;          
            nueva_op.OwnerId = oportunidad.OwnerId;
            nueva_op.StageName = 'Aberta';
            nueva_op.Marca__c = oportunidad.Marca__c;          
            nueva_op.RecordTypeId = oportunidad.RecordTypeId;
            nueva_op.Comentarios__c = '';         

            insert nueva_op;

            for(OpportunityLineItem lineItem : items) {    
                OpportunityLineItem nuevo_item = New OpportunityLineItem();
                nuevo_item.OpportunityId = nueva_op.Id;
                nuevo_item.PriceBookEntryId = lineItem.PriceBookEntryId;
                nuevo_item.UnitPrice = lineItem.UnitPrice;             
                nuevo_item.Quantity = lineItem.Quantity;
                nuevo_item.Categoria__c = lineItem.Categoria__c;
                nuevo_item.Semente_aprovada__c = lineItem.Semente_aprovada__c;
                nuevo_item.Estimativa__c = lineItem.Estimativa__c;
                
                if(lineItem.Semente_aprovada__c == null || lineItem.Semente_comercializada__c == null) {
                    cantidadesNulas = true;
                    break;
                }
                nuevosItems.add(nuevo_item);          
            }
            
            if(cantidadesNulas) { //Retorno error por cantidades en 0
                Database.rollback(savePoint);
                retorno[0] = 'Falha ao criar a oportunidade para o próximo mês. Quantidades em zero';
                retorno[1] = '';
                retorno[2] = '';
                
                return retorno;
            }
            
            insert nuevosItems;
            oportunidad.StageName = 'Fechada';
            update oportunidad;

            retorno[0] = 'Foi criada a oportunidade para o próximo mês.';
            retorno[1] = 'ok';
            retorno[2] = nueva_op.Id;
            
            return retorno;

        }catch(System.CalloutException ex) {       
            Database.rollback(savePoint);
            retorno[0] = 'Falha ao criar a oportunidade para o próximo mês.';
            retorno[1] = '';
            retorno[2] = '';
            
            return retorno;
        }
    }

    public static String getSiguienteMes (String mes) {

        if (mes == 'Janeiro') {
            return  'Fevereiro';
        }

        if (mes == 'Fevereiro') {
            return  'Março';
        }

        if (mes == 'Março') {
            return  'Abril';
        }

        if (mes == 'Abril') {
            return  'Maio';
        }

        if (mes == 'Maio') {
            return  'Junho';
        }

        if (mes == 'Junho') {
            return  'Julho';
        }

        if (mes == 'Julho') {
            return  'Agosto'; 
        }

        if (mes == 'Agosto') {
            return  'Setembro';
        }

        if (mes == 'Setembro') {
            return  'Outubro';
        }

        if (mes == 'Outubro') {
            return  'Novembro';
        }

        if (mes == 'Novembro') { 
            return  'Dezembro';
        }
        return '';                                 
    }


    webservice static String[] notificacionProd_New(Id idOportunidad) {

        Map<String, User> destinatarios = New Map<String, User>();
        Map<String, Schema.SObjectField> objectFields_oppItems = Schema.getGlobalDescribe().get('OpportunityLineItem').getDescribe().fields.getMap();
        List<OpportunityLineItem> oppoli = New List<OpportunityLineItem>();
        String Body = '';
        String[] retorno = New String[2];
        Savepoint savePoint;

        try{
            savePoint = Database.setSavepoint();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
            Opportunity opp = [
                SELECT Id, Name, 
                Safra__c, Marca__c, Tipo_de_Operacion__c,
                Comentarios__c, Region__c, Invierno__c, 
                Epoca_de_Plantio__c, Rebaja__c, StageName,
                Notificado__c, Setor__c, RecordType.Name
                FROM Opportunity 
                WHERE Id = :idOportunidad
            ];
                        
            String sector = 'Comercial';

            if (opp.RecordType.Name == 'PB-Desarrollo') {
                sector = 'Desarrollo';
            }

            if (opp.RecordType.Name == 'PB-Oferta') {
                sector = 'Produccion';
            }
                
            String queryItems = 'SELECT ';
            
            for(String s : objectFields_oppItems.keySet()) {
                queryItems += ' ' + s + ',';     
            }
                                                                            
            queryItems += 'PriceBookEntry.UnitPrice, PriceBookEntry.IsActive,'
            + 'PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name, PriceBookEntry.PriceBook2Id,'
            + 'PricebookEntry.Product2.Especie__c, Categoria__r.Name, Categoria_a_Rebaixar__r.Name,' 
            + 'PricebookEntry.Product2.Categ__c, PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name,' 
            + 'PricebookEntry.Product2.Variedade__r.Marca_comercial__c, PricebookEntry.Product2.Categ__r.Name,'
            + 'Local_de_Entrega__r.Name FROM OpportunityLineItem Where OpportunityId = \'' + idOportunidad + '\' Order by Variedade_Prod__c';   

            oppoli = Database.query(queryItems);
            List<User> listaUsuarios = [
                SELECT Id, Username, Name,
                Email, IsActive, UserRoleId, ProfileId 
                FROM User 
                WHERE Name IN ('Robert Moser', 'Ricardo Franconere',
                'Julio Cesar Poletto', 'Administrador')
            ];
            
            for(User u : listaUsuarios) {
                destinatarios.put(u.Name, u);
            }
            
            opp.StageName = 'PB-Aprobada';
                        
            Body = sector + ' tem atualizações para reportar<br><br>';
            
            if (sector == 'Comercial' || sector == 'Desarrollo') {

                opp.Notificado__c = true;
                
                Body += 'Nome: ' + opp.Name + '<br>';
                Body += 'Safra: ' + opp.Safra__c + '<br>'; 
                Body += 'Tipo Op.: ' + opp.Tipo_de_Operacion__c + '<br>'; 
                Body += 'Rebaja: ' + opp.Rebaja__c + '<br>';
                Body += 'Comentarios: ' + opp.Comentarios__c + '<br>'; 

                Body += 'Acessar:   https://na27.salesforce.com/' + opp.Id + '<br><br><br>';

                if (oppoli != null) {
                    if (opp.Setor__c == 'Comercial') {
                        Body +='<table border="1"><tr><td>Marca Comercial</td><td>Region</td><td>Safra</td><td>Variedade</td><td>Categoria</td><td>Tipo de necesidad</td><td>Local de Entrega</td><td>Quantidade</td></tr>'; 
                        for (OpportunityLineItem i : oppoli) {
                            Body += '<tr><td>'+i.PricebookEntry.Product2.Variedade__r.Marca_comercial__c+'</td><td>'+opp.Region__c+'</td><td>'+opp.Safra__c+'</td><td>'+i.PricebookEntry.Product2.Variedade__r.Name+'</td><td>'+i.PricebookEntry.Product2.Categ__r.Name+'</td><td>'+i.Tipo_de_necesidad__c+'</td><td>'+i.Local_de_Entrega__r.Name+'</td><td>'+i.Quantidade__c+'</td></tr>';
                        }
                    
                        mail.setTargetObjectId(destinatarios.get('Robert Moser').Id); // Especifica a quien se le enviara el mail
                    }
                    if (opp.Setor__c == 'Desarrollo') {
                        Body +='<table border="1"><tr><td>Marca Comercial</td><td>Region</td><td>Safra</td><td>Variedade</td><td>Categoria</td><td>Tipo de necesidad</td><td>Local de Entrega</td><td>Fecha de necesidad</td></tr>'; 
                        for (OpportunityLineItem i : oppoli) {
                            Body += '<tr><td>'+i.PricebookEntry.Product2.Variedade__r.Marca_comercial__c+'</td><td>'+opp.Region__c+'</td><td>'+opp.Safra__c+'</td><td>'+i.PricebookEntry.Product2.Variedade__r.Name+'</td><td>'+i.PricebookEntry.Product2.Categ__r.Name+'</td><td>'+i.Tipo_de_necesidad__c+'</td><td>'+i.Local_de_Entrega__r.Name+'</td><td>'+i.Data__c+'</td><td>'+i.Quantidade__c+'</td></tr>';
                        }
                    
                        mail.setTargetObjectId(destinatarios.get('Robert Moser').Id); // Especifica a quien se le enviara el mail
                    }
                    Body += '</table>';        
                }
                Body += '<br>';
            }else {
                mail.setTargetObjectId(destinatarios.get('Robert Moser').Id);  // Especifica a quien se le enviara el mail            
                opp.Oferta_Asignada__c = true;
            }
            
            update opp;                        
                                        
            mail.setSenderDisplayName('Notificação de ' + sector);
            
            mail.setSaveAsActivity(false);
            mail.setHtmlBody(Body);
            mail.setSubject('Notificação de Produção Basica');
                
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            
            retorno[0] = 'Notificação OK';
            retorno[1] = 'ok';
                
            return retorno;
        }
        catch(exception e) {
            retorno[0] = 'Error al Notificar.';
            retorno[1] = '';
                    
            return retorno;
        }
    }

    webservice static String[] notificacionProd(Id idOportunidad, Id regionId, String marca) {
        Map<String, User> destinatarios = New Map<String, User>();
        Map<String, Schema.SObjectField> objectFields_oppItems = Schema.getGlobalDescribe()
            .get('OpportunityLineItem')
            .getDescribe().fields
            .getMap();
            
        List<OpportunityLineItem> lineItemLista = New List<OpportunityLineItem>();
        String Body = '';
        String[] retorno = New String[2];

        Savepoint savePoint;
        List<Produccion_Basica__c> produccionBasicaLista = New List<Produccion_Basica__c>();

        try {
            savePoint = Database.setSavepoint();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
            Opportunity oportunidad = [
                SELECT Id, Name, Safra__c, Marca__c,
                Tipo_de_Operacion__c, Comentarios__c, 
                Region__c, Invierno__c, Epoca_de_Plantio__c,
                Rebaja__c, StageName, Notificado__c,
                Setor__c, RecordType.Name 
                FROM Opportunity
                WHERE Id = :idOportunidad
            ];
            
            String sector = 'Produção';

            if (oportunidad.RecordType.Name == 'PB-Comercial') {
                sector = 'Comercial';
            }

            if (oportunidad.RecordType.Name == 'PB-Desarrollo') {
                sector = 'Desarrollo';
            }
            
            String queryItems = 'SELECT ';

            for(String s : objectFields_oppItems.keySet()) {
                queryItems += ' ' + s + ',';                                                                
            }
            
            queryItems += 'PriceBookEntry.UnitPrice, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, PriceBookEntry.Product2.Name,' +
                'PriceBookEntry.PriceBook2Id, PricebookEntry.Product2.Especie__c, Categoria__r.Name, Categoria_a_Rebaixar__r.Name,' +
                'PricebookEntry.Product2.Categ__c, PricebookEntry.Product2.Variedade__c,'+
                'PricebookEntry.Product2.Variedade__r.Name, PricebookEntry.Product2.Categ__r.Name';
            

            lineItemLista = Database.query(queryItems);
            
            if (sector == 'Produção') {

                system.debug('PASO 1');
                retorno = BRAXUtils.validarVariedadPB(oportunidad, lineItemLista);
                system.debug('PASO 2');

                if(retorno[0] != 'OK') {
                    return retorno;
                }
            }
            
            oportunidad.StageName = 'PB-Aprobada';
            oportunidad.Notificado__c = true;
            update oportunidad;
            system.debug('PASO 3');
            produccionBasicaLista = [
                SELECT Id, Marca__c, Marca_Comercial__c,
                Safra__c, Region__c, Epoca_de_Plantio__c,
                Variedade__r.Name, Categoria__r.Name, Com_1_Pedido__c,
                Com_2_Pedido_Complementar__c, Com_3_Ajuste__c, 
                Com_4_Cancelamiento__c, Com_5_Relocalizacion__c, 
                Com_6_Adm_Exedente__c, Diferencia__c, Prod_1_Pedido__c, 
                Prod_2_Plantio__c, Prod_3_Estimativa__c, Prod_4_Colheita__c,
                Prod_5_Beneficiamento__c, Prod_6_Armazenagem__c, Prod_7_Descarte__c,
                Prod_8_Cessao__c, Prod_9_Certificacion__c, Subtotal_Comercial__c, 
                Subtotal_Prod__c, Variedade__c, Producto__c, Tipo_de_Necesidad__c,
                Fecha_de_entrega__c, Fecha_de_necesidad__c, Local_Origem__c, 
                Local_de_Entrega__r.Name from Produccion_Basica__c 
                WHERE Marca__c = :oportunidad.Marca__c 
                AND  Region__c = :oportunidad.Region__c 
                AND Safra__c = :oportunidad.Safra__c 
                AND Epoca_de_plantio__c = :oportunidad.Epoca_de_Plantio__c 
                AND Setor__c = : oportunidad.Setor__c
            ];
            
            Body = sector + ' tem atualizações para reportar<br><br>';
            Body += 'Nome: ' + oportunidad.Name + '<br>';
            Body += 'Safra: ' + oportunidad.Safra__c + '<br>'; 
            Body += 'Tipo Op.: ' + oportunidad.Tipo_de_Operacion__c + '<br>'; 
            Body += 'Rebaja: ' + oportunidad.Rebaja__c + '<br>';
            Body += 'Comentarios: ' + oportunidad.Comentarios__c + '<br>'; 
            Body += 'Acessar:   https://na2.salesforce.com/' + oportunidad.Id + '<br><br><br>';

            if (produccionBasicaLista != null) {
                
                if (oportunidad.Setor__c == 'Comercial') {
                    Body +='<table border="1"><tr><td>Marca Comercial</td><td>Region</td><td>Safra</td><td>Variedade</td><td>Categoria</td><td>Tipo de necesidad</td><td>Local de Entrega</td><td>Com.1-Ped</td><td>Com.2-Ped Compl</td><td>Com.3-Ajuste</td><td>Com.4-Canc</td><td>Com.5-Realoc</td><td>Com.6-Adm Ex</td><td>Subt Com</td><td>Prd.1-Ped</td><td>Prd.2-Plant</td><td>Prd.3-Estim</td><td>Prd.4-Colh</td><td>Prd.5-Benef</td><td>Prd.6-Armaz</td><td>Prd.7-Desc</td><td>Prd.8-Cess</td><td>Prd.9-Cert</td><td>Subt Prd</td><td>Dif</td></tr>'; 
                    for (Produccion_Basica__c pb : produccionBasicaLista) {
                        Body += '<tr><td>'+pb.Marca_Comercial__c+'</td><td>'+pb.Region__c+'</td><td>'+pb.Safra__c+'</td><td>'+pb.Variedade__r.Name+'</td><td>'+pb.Categoria__r.Name+'</td><td>'+pb.Tipo_de_necesidad__c+'</td><td>'+pb.Local_de_Entrega__r.Name+'</td><td>'+pb.Com_1_Pedido__c+'</td><td>'+pb.Com_2_Pedido_Complementar__c+'</td><td>'+pb.Com_3_Ajuste__c+'</td><td>'+pb.Com_4_Cancelamiento__c+'</td><td>'+pb.Com_5_Relocalizacion__c+'</td><td>'+pb.Com_6_Adm_Exedente__c+'</td><td>'+pb.Subtotal_Comercial__c+'</td><td>'+pb.Prod_1_Pedido__c+'</td><td>'+pb.Prod_2_Plantio__c+'</td><td>'+pb.Prod_3_Estimativa__c+'</td><td>'+pb.Prod_4_Colheita__c+'</td><td>'+pb.Prod_5_Beneficiamento__c+'</td><td>'+pb.Prod_6_Armazenagem__c+'</td><td>'+pb.Prod_7_Descarte__c+'</td><td>'+pb.Prod_8_Cessao__c+'</td><td>'+pb.Prod_9_Certificacion__c+'</td><td>'+pb.Subtotal_Prod__c+'</td><td>'+pb.Diferencia__c+'</td></tr>';
                    }
                }
                if (oportunidad.Setor__c == 'Desarrollo') {
                    Body +=
                    '<table border="1">'+
                        '<tr><td>Marca Comercial</td>'+
                        '<td>Region</td>'+
                        '<td>Safra</td>'+
                        '<td>Variedade</td>'+
                        '<td>Categoria</td>'+
                        '<td>Tipo de necesidad</td>'+
                        '<td>Local de Entrega</td>'+
                        '<td>Fecha de necesidad</td>'+
                        '<td>Fecha de entrega</td>'+
                        '<td>Com.1-Ped</td>'+
                        '<td>Com.2-Ped Compl</td>'+
                        '<td>Com.3-Ajuste</td>'+
                        '<td>Com.4-Canc</td>'+
                        '<td>Com.5-Realoc</td>'+
                        '<td>Com.6-Adm Ex</td>'+
                        '<td>Subt Com</td>'+
                        '<td>Prd.1-Ped</td>'+
                        '<td>Prd.2-Plant</td>'+
                        '<td>Prd.3-Estim</td>'+
                        '<td>Prd.4-Colh</td>'+
                        '<td>Prd.5-Benef</td>'+
                        '<td>Prd.6-Armaz</td>'+
                        '<td>Prd.7-Desc</td>'+
                        '<td>Prd.8-Cess</td>'+
                        '<td>Prd.9-Cert</td>'+
                        '<td>Subt Prd</td>'+
                        '<td>Dif</td>'+
                    '</tr>'; 
                    
                    for (Produccion_Basica__c pb : produccionBasicaLista) {
                        Body +=
                        '<tr><td>'+pb.Marca_Comercial__c+
                        '</td><td>'+pb.Region__c+
                        '</td><td>'+pb.Safra__c+
                        '</td><td>'+pb.Variedade__r.Name+
                        '</td><td>'+pb.Categoria__r.Name+
                        '</td><td>'+pb.Tipo_de_necesidad__c+
                        '</td><td>'+pb.Local_de_Entrega__r.Name+
                        '</td><td>'+pb.Fecha_de_necesidad__c+
                        '</td><td>'+pb.Fecha_de_entrega__c+
                        '</td><td>'+pb.Com_1_Pedido__c+
                        '</td><td>'+pb.Com_2_Pedido_Complementar__c+
                        '</td><td>'+pb.Com_3_Ajuste__c+
                        '</td><td>'+pb.Com_4_Cancelamiento__c+
                        '</td><td>'+pb.Com_5_Relocalizacion__c+
                        '</td><td>'+pb.Com_6_Adm_Exedente__c+
                        '</td><td>'+pb.Subtotal_Comercial__c+
                        '</td><td>'+pb.Prod_1_Pedido__c+
                        '</td><td>'+pb.Prod_2_Plantio__c+
                        '</td><td>'+pb.Prod_3_Estimativa__c+
                        '</td><td>'+pb.Prod_4_Colheita__c+
                        '</td><td>'+pb.Prod_5_Beneficiamento__c+
                        '</td><td>'+pb.Prod_6_Armazenagem__c+
                        '</td><td>'+pb.Prod_7_Descarte__c+
                        '</td><td>'+pb.Prod_8_Cessao__c+
                        '</td><td>'+pb.Prod_9_Certificacion__c+
                        '</td><td>'+pb.Subtotal_Prod__c+
                        '</td><td>'+pb.Diferencia__c+
                        '</td></tr>';
                    }
                }
                Body += '</table>';        
            }
            Body += '<br>';
            
            List<User> Users = [
                SELECT Id, Username, Name, 
                Email, IsActive, UserRoleId, ProfileId 
                FROM User 
                WHERE Name IN ('Pablo Souza', 'Rogério Schneider', 
                'Marcelo Steffen', 'Robert Moser', 'Ricardo Franconere', 
                'Julio Cesar Poletto', 'Administrador')
            ];

            for(User u : Users) {
                destinatarios.put(u.Name, u);
            }
            
            
            if(oportunidad.Setor__c == 'Comercial') { 
                mail.setTargetObjectId(destinatarios.get('Ricardo Franconere').Id); // Specify who the email should be sent to.             
            }else{
                mail.setTargetObjectId(destinatarios.get('Julio Cesar Poletto').Id); // Specify who the email should be sent to.
            }
                
            mail.setSenderDisplayName('Notificação de ' + sector);
            String[] toAddresses = new String[] {
                destinatarios.get('Robert Moser').Email
            };
            
            mail.setCcAddresses(toAddresses);
            mail.setSaveAsActivity(false);
            mail.setHtmlBody(Body);
            mail.setSubject('Notificação de Produção Basica');
                
            Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
            
            retorno[0] = 'Notificação OK';
            retorno[1] = 'ok';
                
            return retorno;
        }catch(exception e) {
            retorno[0] = 'Error al Notificar.';
            retorno[1] = '';
                    
            return retorno;
        }
    }

    webservice static String[] clonarOportunidad(Id idOportunidad) {
        Opportunity OppClone = New Opportunity();
        Map<String,Id> rType = New Map<String,Id>();
        Savepoint savePoint;
        String[] retorno = New String[3];

        try {
            List<RecordType> recordTypes = [
                SELECT Id, Name 
                FROM RecordType
                WHERE Name IN ('PB-Comercial', 'PB-Desarrollo', 'PB-Produccion')
            ];

            for(RecordType r : recordTypes) {
                rType.put(r.Name, r.Id);
            }
            
            savePoint = Database.setSavepoint(); 
            List<OpportunityLineItem> nuevosItems = New List<OpportunityLineItem>();
            Boolean cantidadesNulas = false;
            String soql = previsionesController.getCreatableFieldsSOQL('Opportunity','Id=\'' + idOportunidad + '\'');
            Opportunity oppAClonar = (Opportunity)Database.query(soql);
            OppClone = oppAClonar.clone(false, true);
            OppClone.Tipo_de_Operacion__c = '';
            OppClone.StageName = 'PB-Pendiente';
            OppClone.Notificado__c = false;
            OppClone.Rebaja__c = false;
            OppClone.Comentarios__c = '';
            OppClone.OwnerId = UserInfo.getUserId();

            if(UserInfo.getName() == 'Robert Moser') {
                OppClone.RecordTypeId = rType.get('PB-Produccion');
                OppClone.Description = 'ok';    //Le pongo un valor a este campo para indicar que la PB-Produccion
                                                // se esta generando desde clonar. 
                                                //Para que no se permita crear desde nueva opp a menos que sea una rebaja.
            }

            if(UserInfo.getName() == 'Ricardo Franconere') {
                OppClone.RecordTypeId = rType.get('PB-Comercial');                      
            }

            if(UserInfo.getName() == 'Julio Cesar Poletto') {
                OppClone.RecordTypeId = rType.get('PB-Desarrollo');
            }
            
            insert OppClone;
            
            List<OpportunityLineItem> items = [
                SELECT Id, OpportunityId, PriceBookEntryId, 
                UnitPrice, Quantity, Semente_aprovada__c, 
                Semente_comercializada__c, Categoria__c 
                FROM OpportunityLineItem 
                WHERE OpportunityId = : idOportunidad
            ];        

            String soqlOLI = previsionesController.getCreatableFieldsSOQL('OpportunityLineItem','OpportunityId=\'' + idOportunidad + '\'');
            List<OpportunityLineItem> prodOLIaClonar = (List<OpportunityLineItem>)Database.query(soqlOLI);

            for(OpportunityLineItem item : prodOLIaClonar) {    
                OpportunityLineItem nuevo_item = item.clone(false,true);
                nuevo_item.OpportunityId = OppClone.Id;
                nuevo_item.TotalPrice = null;
                
                if(UserInfo.getName() != 'Robert Moser') {
                    nuevo_item.quantidade__c = 0;
                }
                nuevosItems.add(nuevo_item);          
            }

            insert nuevosItems;

            retorno[0] = 'Foi criada a oportunidade. Lembre-se de carregar o tipo de operação';
            retorno[1] = 'ok';
            retorno[2] = OppClone.Id;
            
            return retorno;

        } catch(exception ex) {
            String mens = ex.getMessage();
            
            mens = mens.split(',')[mens.split(',').size() - 1];
            Database.rollback(savePoint);
            retorno[0] = 'Falha ao criar a oportunidade. ' + mens;
            retorno[1] = '';
            retorno[2] = '';
            
            return retorno;     
        }
    }

    webservice static String[] validarPasoVBSAP(Id idOportunidad) {
        Boolean impuestosOK = true;
        String[] retorno = New String[2];
        retorno[0] = 'OK';
        retorno[1] = 'OK';
        Map<Id,OpportunityLineItem> oplisSAP = New Map<Id, OpportunityLineItem>();
        
        List<OpportunityLineItem> oplis =  [
                SELECT Id, OpportunityId, Base_de_Calculo__c,
                Tasas__c, Quantity, Id_Item_de_Oportunidad_Relacionado__c 
                FROM OpportunityLineItem 
                WHERE OpportunityId = :idOportunidad
            ];

        for(OpportunityLineItem opli : oplis) {
            if(opli.Base_de_Calculo__c == null || opli.Tasas__c == null){
                impuestosOK = false;
            } 
            oplisSAP.put(opli.Id_Item_de_Oportunidad_Relacionado__c, opli);
        }

        if(!impuestosOK) { 
            retorno[0] = 'Error na determinação do preço (erro na determinação das taxas fiscais). Contatar ao administrador do sistema.';
            retorno[1] = '';
            return retorno;
        }

        system.debug('validVB 1');
        List<OpportunityLineItem> oplis2 = [
            SELECT Id, OpportunityId,
            PricebookEntry.Product2.Variedade__r.Name, 
            PricebookEntry.Product2.Categ__r.Name, Quantity, 
            Id_Item_de_Oportunidad_Relacionado__c, Quant_Pendiente__c 
            FROM OpportunityLineItem 
            WHERE Id IN :oplisSAP.keySet()
        ];

        for(OpportunityLineItem opli : oplis2) {
            system.debug('validVB 2');
            if (opli.Quant_Pendiente__c < oplisSAP.get(opli.Id).Quantity) {
                system.debug('validVB 3');
                if (retorno[0] == 'OK') {
                    retorno[0] = 'Existem variedades que não podem ser baixadas a SAP porque superam a quantidade pendente da Oferta.';
                }
                retorno[0] += ' \r\n' + opli.PricebookEntry.Product2.Variedade__r.Name +' '+ opli.PricebookEntry.Product2.Categ__r.Name;
                retorno[1] = '';
            }
        }
            
        return retorno;
    }    

    public static String[] actualizarPasoVBSAP(Id idOportunidad, Boolean cancOp) {
        String[] retorno = New String[2];
        retorno[0] = 'OK';
        retorno[1] = 'OK';
        system.debug('actVB 1');
        integer mult = 1; 
        if(cancOp) { 
            mult = -1;
        }
        try {

            List <OpportunityLineItem> ListaItemsParaActualizarEstado = New List<OpportunityLineItem>();
            Map<Id,OpportunityLineItem> oplisSAP = New Map<Id, OpportunityLineItem>();
            
            List<OpportunityLineItem> oplis1 = [
                SELECT Id, Quantity, 
                Id_Item_de_Oportunidad_Relacionado__c
                FROM OpportunityLineItem 
                WHERE OpportunityId = :idOportunidad
            ];

            for (OpportunityLineItem opli : oplis1) {
                oplisSAP.put(opli.Id_Item_de_Oportunidad_Relacionado__c, opli);
                retorno[1] = 'OK';
            }

             List<OpportunityLineItem> oplis2 = [
                SELECT Id, OpportunityId, 
                PricebookEntry.Product2.Variedade__r.Name, 
                PricebookEntry.Product2.Categ__r.Name, 
                Quantity, Id_Item_de_Oportunidad_Relacionado__c, 
                Quant_Pendiente__c, Quant_Confirmada__c
                FROM OpportunityLineItem 
                WHERE Id IN :oplisSAP.keySet()
            ];

            for (OpportunityLineItem opli : oplis2)  {
                system.debug('actVB 3');
                opli.Quant_Confirmada__c = opli.Quant_Confirmada__c + (oplisSAP.get(opli.Id).Quantity * mult);
                ListaItemsParaActualizarEstado.Add(opli);
                retorno[1] = 'OK';
            }
            update ListaItemsParaActualizarEstado;
            system.debug('actVB 4');
            retorno[1] = 'OK';
        } catch(Exception e) {
            retorno[0] = 'Erro ao actualizar a Oferta. Contatar ao administrador do sistema. \r\n Error: ' + e.getMessage();
            retorno[1] = '';
        }
            return retorno;
    }  


    webservice static String[] notificacionContacto(Id contactoID, Id userId) {
        String Body = '';
        String[] retorno = New String[2];
        User usuario = [
            SELECT Id, Username, Name, Profile.Name, Email, IsActive, UserRoleId, ProfileId
            FROM User
            WHERE Id = :userId
        ];
        try {
                
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
            Contact contacto = [
                SELECT Id, MasterRecordId, AccountId,
                Account.Name, LastName, FirstName, Name
                FROM Contact
                WHERE Id = :contactoID
            ];
                
            Body = 'O Supervisor Comercial ' + usuario.Name +' deseja eliminar o seguinte contato: \r\n'; 
            Body += 'Nome: ' + contacto.Name + '\r\n';
            Body += 'Cuenta: ' + contacto.Account.Name + '\r\n'; 
            Body += 'Acessar:   ' + URL.getSalesforceBaseUrl().toExternalForm() + contacto.Id;  ///PRODUCTIVO
            User adminVendas = [
                SELECT ID
                FROM User
                WHERE NAME = 'Adm. Vendas'
            ];
            //mail.setTargetObjectId('00540000002nK10'); // PRODUCTIVO  Especifica quien se le envia el mail
            mail.setTargetObjectId(adminVendas.Id); // PRODUCTIVO  Especifica quien se le envia el mail
                
            mail.setSenderDisplayName('Contato para Eliminar.');
            String[] toAddresses = new String[] {'salesforce@gdmseeds.com'};
            
            mail.setCcAddresses(toAddresses);
            mail.setSaveAsActivity(false);
            mail.setPlainTextBody(Body);
            mail.setSubject('Contato para Eliminar.');
                
            if (!Test.isRunningTest()) {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            }
            
            retorno[0] = 'Solicitação OK';
            retorno[1] = 'ok';
                
            return retorno;

        } catch (exception e) {
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

        if (!Test.isRunningTest()) {
            resultado = soap.SI_Sync_WebService();
        }

        Savepoint savePoint = Database.setSavepoint();
        String msg = '';

        try {
            String campania;
            Map<String, String> productos = New Map<String, String>();
            Map<String, String> productos2 = New Map<String, String>();

            User usuario = [
                SELECT Id 
                FROM User 
                WHERE Name = 'Carlos Pattis'
                LIMIT 1
            ];

            RecordType recordType = [
                SELECT Id 
                FROM RecordType
                WHERE Name = 'PB-Oferta' 
                AND sObjectType = 'Opportunity' 
                LIMIT 1
            ];

            String safraActual = '15/16';        
            List<Configuracion_BMX__c> configuracionesBMX = [
                SELECT Id, PB_Safra_Actual__c 
                FROM Configuracion_BMX__c 
                WHERE Name = 'Facturacion' 
                LIMIT 1
            ];

            for (Configuracion_BMX__c conf : configuracionesBMX) {
                    safraActual = conf.PB_Safra_Actual__c;                     
            }
            if (resultado != null) {
                if (resultado.size() > 0) {
                    List<PriceBookEntry> pricebooksEntries = [
                        SELECT Id, Product2.Variedade__r.Nombre_de_Registro__c, 
                        Product2.Variedade__r.Name, Product2.Categ__r.Name
                        FROM PricebookEntry
                        WHERE Pricebook2.Name = 'Lista de Básica - Prod. de Básica' 
                        AND isActive = true 
                        AND Product2.Semilla_Tratada__c = false 
                        AND Product2.Unidade__c = 'SACA 40 KG'
                    ];

                    for (PricebookEntry pbe :pricebooksEntries) {
                        if (!productos.containsKey(pbe.Product2.Variedade__r.Nombre_de_Registro__c + pbe.Product2.Categ__r.Name)) {
                            productos.put(pbe.Product2.Variedade__r.Nombre_de_Registro__c + pbe.Product2.Categ__r.Name, pbe.Id);
                        }

                        if (!productos2.containsKey(pbe.Product2.Variedade__r.Name + pbe.Product2.Categ__r.Name)) {
                            productos2.put(pbe.Product2.Variedade__r.Name + pbe.Product2.Categ__r.Name, pbe.Id);    
                        }
                    }               
                    List<Opportunity> oppsDelete = New List<Opportunity>();
                    List<Opportunity> oppsActEstado = New List<Opportunity>();
                    oppsDelete = [
                        SELECT Id 
                        FROM Opportunity 
                        WHERE RecordType.Name = 'PB-Oferta'
                        AND Safra__c = : safraActual 
                        AND Oferta_Asignada__c = false
                    ];
                    if (oppsDelete.size() > 0) {
                        delete oppsDelete;
                    }
                    oppsActEstado = [
                        SELECT Id, Activa__c 
                        FROM Opportunity
                        WHERE RecordType.Name = 'PB-Oferta' 
                        AND Safra__c = : safraActual 
                        AND Oferta_Asignada__c = true
                    ];
                    if (oppsActEstado.size() > 0) {
                        for (Opportunity o : oppsActEstado){
                            o.Activa__c = false;
                        }
                        update oppsActEstado;
                    }
                    
                    Opportunity nuevaOferta = New Opportunity();
                    nuevaOferta.Name = 'Oferta ' + system.today().day() + '/' + system.today().month() + '/' + system.today().year();
                    nuevaOferta.RecordTypeId = recordType.Id;
                    nuevaOferta.StageName = 'PB-Pendiente';
                    nuevaOferta.CloseDate = system.today();
                    nuevaOferta.OwnerId = usuario.Id;
                    nuevaOferta.Safra__c = safraActual;
                    nuevaOferta.Activa__c = true;
                    
                    insert nuevaOferta;
                    
                    Map<String, OpportunityLineItem> mapitemsInsert = New Map<String, OpportunityLineItem>();
                    for (sapOferta.data_element i : resultado) {
                        String idPBE = productos.get(i.EXTMATLGRP + i.BASIC_MATL);
                        if (idPBE == null) {
                            idPBE = productos2.get(i.EXTMATLGRP + i.BASIC_MATL);
                        }
                        if (i.ZC_CMPN != null && i.ZC_CMPN != '') {
                            if (idPBE != null && (i.BASIC_MATL.contains('PREBA')
                                || i.BASIC_MATL.contains('BASICA')  || i.BASIC_MATL.contains('C1') 
                                || i.BASIC_MATL.contains('C2') || i.BASIC_MATL.contains('S1') 
                                || i.BASIC_MATL.contains('S2')) && ((i.ZC_CMPN.substring(0,3) + i.ZC_CMPN.substring(5,7)) == safraActual 
                                || (i.ZC_CMPN.substring(0,3) + 
                                    i.ZC_CMPN.substring(5,7)) == String.valueOf(Integer.valueOf(safraActual.substring(0,2)) + 1)
                                    + '/' + safraActual.substring(3,5))) {

                                OpportunityLineItem item;
                                if (!mapitemsInsert.containsKey(i.EXTMATLGRP + i.BASIC_MATL)) {
                                    item = New OpportunityLineItem();
                                    item.OpportunityId = nuevaOferta.Id;
                                    item.UnitPrice = 0.01;
                                    item.Quantity = 0.01;
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
                                } 
                                else {
                                    item = mapitemsInsert.get(i.EXTMATLGRP + i.BASIC_MATL);
                                    if (item.Estimativa__c != null) {
                                        item.Estimativa__c += i.ZR_PLEMVA;
                                    } 
                                    else {
                                        item.Estimativa__c = i.ZR_PLEMVA;
                                    }

                                    if (item.Certificacion__c != null) {                                             
                                        item.Certificacion__c += i.ZR_PLCERT;
                                    }
                                    else {
                                        item.Certificacion__c = i.ZR_PLCERT;
                                    }
                                    if (item.Despacho__c != null) {
                                        item.Despacho__c += i.ZR_PLDESP;
                                    }
                                    else {
                                        item.Despacho__c = i.ZR_PLDESP;
                                    }
                                    if (item.Estoque_Granel__c != null) {
                                        item.Estoque_Granel__c += i.ZR_PLESGR;
                                    }
                                    else {
                                        item.Estoque_Granel__c = i.ZR_PLESGR;
                                    }
                                    if (item.Estoque_Sacas__c != null) {
                                        item.Estoque_Sacas__c += i.ZR_PLESSA;
                                    }
                                    else {
                                        item.Estoque_Sacas__c = i.ZR_PLESSA;
                                    }
                                    if (item.Compras_Pedido__c != null) {
                                        item.Compras_Pedido__c += i.ZR_PLCOPE;
                                    }
                                    else {
                                        item.Compras_Pedido__c = i.ZR_PLCOPE;
                                    }
                                    if (item.Compras_Entrada_de_Mercaderia__c != null) {
                                        item.Compras_Entrada_de_Mercaderia__c += i.ZR_PLENME;
                                    }
                                    else {
                                        item.Compras_Entrada_de_Mercaderia__c = i.ZR_PLENME;
                                    }
                                    if (item.Quantidade__c != null) {
                                        item.Quantidade__c += i.ZR_PLSPR;
                                    }
                                    else {
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
        }catch(exception ex) {
            Database.rollback(savePoint);
            return ex.getMessage();                
        }

        return 'SE CREO LA OFERTA.';
    }  

    public static void validarAIV(List<Id> IDoportunidades) {

        Opportunity opp = [
            SELECT Id, AccountId, Marca__c, Safra__c, RecordType.Name
            FROM Opportunity WHERE Id = :IDoportunidades[0]
        ];

        if (opp.RecordType.Name == 'Anexo IV'){
            validacionAIV(opp);	     
        }
    }

    public static void validacionAIV(Opportunity oportunidad) {

        Map<String, AggregateResult> mapVari = New Map<String, AggregateResult>();

        List<AggregateResult> aggregateResults = [
            SELECT PricebookEntry.Product2.Variedade__r.Name vari,
            Sum(Meta__c) meta, Sum(Semente_comercializada__c) semC, 
            Sum(Semente_uso_propio__c) semUP 
            FROM OpportunityLineItem 
            WHERE Opportunity.AccountId = : oportunidad.AccountId 
            AND Opportunity.Safra__c = :oportunidad.Safra__c 
            AND Opportunity.Marca__c = :oportunidad.Marca__c 
            AND (Opportunity.RecordType.Name = 'Objetivo Contrato Royalties' 
            OR ((Opportunity.RecordType.Name = 'Anexo III' 
            OR Opportunity.RecordType.Name = 'Anexo IV') 
            AND Opportunity.StageName = 'Aprobada')) 
            GROUP BY PricebookEntry.Product2.Variedade__r.Name
        ];

        for(AggregateResult ar : aggregateResults) {
            Double semC = Double.valueOf(ar.get('semC'));
            Double semUP = Double.valueOf(ar.get('semUP'));
            Double meta = Double.valueOf(ar.get('meta'));

            if (semC == null) {
                semC = 0;
            }

            if (semUP == null) {
                semUP = 0;
            }            

            if (meta == null) {
                meta = 0;        
            }

            if (semC + semUP > meta) {
                mapVari.put(String.valueOf(ar.get('vari')), ar);		
            }
        }
            
        if (mapVari.size() > 0) {
            String descripcion = '';
            for (String cadena : mapVari.keySet()) {
                AggregateResult ar2 = mapVari.get(cadena);
                Double semC = Double.valueOf(ar2.get('semC'));
                Double semUP = Double.valueOf(ar2.get('semUP'));
                Double meta = Double.valueOf(ar2.get('meta'));

                if (semC == null) {
                        semC = 0;
                }

                if (semUP == null) {
                        semUP = 0;
                }

                if (meta == null) {
                        meta = 0;
                }

                descripcion += cadena
                            + ': Semente Comer. + UP: ' + (semC + semUP) 
                            + ' - Semente Autorizada: ' +  meta + '\n';	
            }
            crearCaso(oportunidad.AccountId, oportunidad.Marca__c, 'Anexo IV', 'Volume autorizado x comercializado', descripcion);
        }	
    }

    public static void crearCaso(String idCuenta, String marca, String origen, String asunto, String descripcion) {             
            
        Case caso = New Case();        

        RecordType recordType = [
            SELECT Id 
            FROM RecordType 
            WHERE Name = 'Fiscalização' 
            AND SObjectType = 'Case'
        ];                        

        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;        

        caso.RecordTypeId = recordType.Id;
        caso.AccountId = idCuenta;
        caso.Marca__c = marca;
        caso.subject = asunto;
        caso.description = descripcion;
        caso.status = 'Novo';
        caso.origin = origen;           
        caso.setOptions(dmo);

        insert caso;
    }

    public static Map<String,String> cargarRecordTypesOppbyDevName() {
       
        Map<String,String> rTypes = new Map<String,String>();
        List<RecordType> listaRecordTypes = [
            SELECT Id,DeveloperName,Name
            FROM RecordType
            WHERE SobjectType='Opportunity'
            AND isActive = true
        ];
        for(RecordType recordType : listaRecordTypes) {         
            rTypes.put(recordType.DeveloperName, recordType.Name);
        }       
        return rTypes;
    }

    webservice static String[] clonarOpp(Id oportunidadID) {
        Opportunity OppClone = New Opportunity();
        Map<String,Id> rType = New Map<String,Id>();
        Savepoint sp;
        String[] retorno = New String[3];
        List<RecordType> listaRecordTypes = [ 
            SELECT Id, Name
            FROM RecordType
            WHERE Name IN ('PB-Comercial', 'PB-Desarrollo', 'PB-Produccion')
        ];
        try {
            for(RecordType r : listaRecordTypes) {
                rType.put(r.Name, r.Id);
            }
          
          sp = Database.setSavepoint(); 
          List<OpportunityLineItem> nuevosItems = New List<OpportunityLineItem>();
          Boolean cantidadesNulas = false;
          String soql = previsionesController.getCreatableFieldsSOQL('Opportunity','Id=\'' + oportunidadID + '\'');
          Opportunity oppAClonar = (Opportunity)Database.query(soql);
          OppClone = oppAClonar.clone(false, true);
          OppClone.Tipo_de_Operacion__c = '';
          OppClone.StageName = 'PB-Pendiente';
          OppClone.Notificado__c = false;
          OppClone.Rebaja__c = false;
          OppClone.Comentarios__c = '';
          OppClone.OwnerId = UserInfo.getUserId();
          if(UserInfo.getName() == 'Robert Moser'){
                OppClone.RecordTypeId = rType.get('PB-Produccion');
                OppClone.Description = 'ok'; //Le pongo un valor a este campo para indicar que la PB-Produccion se esta generando desde clonar. Para que no se permita crear desde nueva opp a menos que sea una rebaja.
          }
          if(UserInfo.getName() == 'Ricardo Franconere')
                OppClone.RecordTypeId = rType.get('PB-Comercial');                      
          if(UserInfo.getName() == 'Julio Cesar Poletto')
                OppClone.RecordTypeId = rType.get('PB-Desarrollo');
           
          insert OppClone;
          
          List<OpportunityLineItem> items = [
              SELECT Id, OpportunityId, PriceBookEntryId, UnitPrice, Quantity, Semente_aprovada__c,
              Semente_comercializada__c, Categoria__c
              FROM OpportunityLineItem
              WHERE OpportunityId = : oportunidadID
            ];        
       
          String soqlOLI = previsionesController.getCreatableFieldsSOQL('OpportunityLineItem','OpportunityId=\'' + oportunidadID + '\'');
          List<OpportunityLineItem> prodOLIaClonar = (List<OpportunityLineItem>)Database.query(soqlOLI);
       
          for (OpportunityLineItem item : prodOLIaClonar) {   
                OpportunityLineItem nuevo_item = item.clone(false,true);
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

       }catch(exception ex) {
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
}
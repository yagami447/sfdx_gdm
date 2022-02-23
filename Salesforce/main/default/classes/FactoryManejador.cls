public class FactoryManejador  {


    public  ManejadorProductos devuelveManejador(String tipoRegistro, Id idCuenta, String safra, String marca) {
    
        if(tipoRegistro == 'Anexo I') {
            ManejadorAnexoI anexoI = new ManejadorAnexoI();
            anexoI.listaProductos = this.obtenerProductos(new String[] {'Anexo I', 'Anexo II', 'Anexo II Rebaixamento Sacas', 'Descarte', 'Aquisicion Sementes Terceiros'}, idCuenta, safra, marca, new String[] {'Aprobada', 'AU - Autorizada'});
            anexoI.cargarProductos(new String[] {'CVB Autorizada','Aquisição Sementes Terceiros'}, idCuenta, aAppManager.getSafraActualByApp('A1'), marca);
            return anexoI;
        }

        if(tipoRegistro == 'Descarte') {
            ManejadorDescarte descarte = new ManejadorDescarte();
            descarte.listaProductos = this.obtenerProductos(new String[] {'Anexo II', 'Anexo II Rebaixamento Sacas'}, idCuenta, safra, marca, new String[] {'Aprobada', 'AU - Autorizada'});
            this.setearMapas(descarte);
            return descarte;
        }

        if(tipoRegistro == 'Reembalagem') {
            ManejadorReembalagem reembalagem = new ManejadorReembalagem();
            reembalagem.listaProductos = this.obtenerProductos(new String[] {'CVB Autorizada'}, idCuenta, safra, marca, new String[] {'Aprobada','AU - Autorizada'});
			reembalagem.productosReemabalaje = this.obtenerProductos(new String[] {'Reembalaje'}, idCuenta, safra, marca, new String[] {'AU - Autorizada', 'Pendiente de Analisis'});
            return reembalagem;
        }


        return new ManejadorProductos();
    }



    private void setearMapas(ManejadorProductos manejador) {
        if (!manejador.listaProductos.isEmpty()) {
            for (Integer i = 0; i < manejador.listaProductos.size(); i++) {
                String tmpVarietyId = manejador.listaProductos[i].PricebookEntry.Product2.Variedade__c;
                String tmpVarietyName = manejador.listaProductos[i].PricebookEntry.Product2.Variedade__r.Name;
                String tmpVarietyRegisterName = manejador.listaProductos[i].PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c;
                String tmpCategoryName;
                tmpCategoryName = manejador.listaProductos[i].Categoria__r.Name;
                if (!manejador.tmpvarietyNameById.containsKey(tmpVarietyId)) { 

                    Set<String> categoriesForVariety  = new Set<String>();

                    categoriesForVariety.add(tmpCategoryName);
                    manejador.categoriasPorVariedad.put(tmpVarietyName, categoriesForVariety);
                    manejador.tmpvarietyNameById.put(tmpVarietyId, tmpVarietyName);
                    manejador.nombreRegistroVariedadPorId.put(tmpVarietyId, tmpVarietyRegisterName);                 
                    manejador.nombreVariedadPorId.put(tmpVarietyId, tmpVarietyName);
                } else {
                    Set<String> categoriesForVariety = manejador.categoriasPorVariedad.get(tmpVarietyName);
                    if (!categoriesForVariety.contains(tmpCategoryName)) {
                        categoriesForVariety.add(tmpCategoryName);
                    }
                }    
            }
        }
    }

    private List<OpportunityLineItem> obtenerProductos( String[] registros, Id idCuenta, String safra, String marca, String[] stages) {
        String queryPlus = 'PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Name, ' 
            +'PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c, PricebookEntry.Product2.UNIDADE__c, '+
            'PriceBookEntry.Product2.Categ__c, PricebookEntry.Product2.Categ__r.Name, Categoria__r.Name, Opportunity.TipoReg__c, Categoria_a_Rebaixar__r.Name, PriceBookEntry.PriceBook2Id, PricebookEntry.Product2.Variedad__c,' +
			'Variedad__r.Name, Estado_de_Produccion__r.Name';

        return aSiteUtils.queryResults5(
            OpportunityLineItem.SObjectType, queryPlus,
            'Opportunity.AccountId = :v1', idCuenta, 
            'Opportunity.TipoReg__c in :v2', registros,
            'Opportunity.Safra__c = :v3', safra,
            'Opportunity.Marca__c = :v4', marca,
            'Opportunity.StageName = :v5', stages
        );
    }
}
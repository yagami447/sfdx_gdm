trigger beforeInsertUpdateOppItemPrevision on OpportunityLineItem (before insert, before update, before delete) {
    Map<String, String> mapaCat = New Map<String,String>();
    Map<String, String> mapaEstados = New Map<String, String>();
    
    if (Trigger.isInsert || Trigger.isUpdate){
        Boolean hayPrevOPB = false;
        for (OpportunityLineItem i : Trigger.New)
            if (i.Es_Previsao__c == true || (i.Tipo_Registro__c != null && (i.Tipo_Registro__c == 'PB-Produccion' || i.Tipo_Registro__c == 'PB-Comercial' || i.Tipo_Registro__c == 'PB-Desarrollo' || i.Tipo_Registro__c.contains('Anexo') || i.Tipo_Registro__c.contains('Objetivo Ventas Royalties'))))
                hayPrevOPB = true;

        if (!hayPrevOPB)
            return;
    }        
    
    for(Categoria__c c: [SELECT Id, Name FROM Categoria__c]) if(!mapaCat.ContainsKey(String.ValueOf(c.Id))) mapaCat.put(String.ValueOf(c.Id), c.Name);
    
    for(Estado__c e: [SELECT Id, Name FROM Estado__c]) if(!mapaEstados.ContainsKey(String.ValueOf(e.Id))) mapaEstados.put(String.ValueOf(e.Id), e.Name);
    
     List<Cambios_OLI__c> cambios = New List<Cambios_OLI__c>();
     if (Trigger.isDelete) {

        // In a before delete trigger, the trigger accesses the records that will be
        // deleted with the Trigger.old list.
        for (OpportunityLineItem i : Trigger.old) {
            if(i.Es_Previsao__c == true || (i.Tipo_Registro__c != null && (i.Tipo_Registro__c == 'PB-Produccion' || i.Tipo_Registro__c == 'PB-Comercial' || i.Tipo_Registro__c == 'PB-Desarrollo' || i.Tipo_Registro__c.contains('Anexo') || i.Tipo_Registro__c.contains('Objetivo Ventas Royalties')))){
            //if(i.Es_Previsao__c == true || i.Tipo_Registro__c == 'PB-Produccion' || i.Tipo_Registro__c == 'PB-Comercial'){
                Cambios_OLI__c borrado = New Cambios_OLI__c();
                borrado.Accion__c = 'ELIMINÓ';
                if(i.Es_Previsao__c == true){
                    borrado.Campo__c = 'Previsao:' + String.ValueOf(i.Previsao__c) + '; Motivo:' + i.Motivo__c;
                }else{
                    if(i.Tipo_Registro__c == 'PB-Produccion' || i.Tipo_Registro__c == 'PB-Comercial' || i.Tipo_Registro__c == 'PB-Desarrollo'){
                        borrado.Campo__c = 'Quantidade:' + String.ValueOf(i.Quantidade__c) + '; Local de Entrega:' + i.Local_de_Entrega__c + '; Data:' + i.Data__c + '; Tipo de Necesidad:' + i.Tipo_de_Necesidad__c + '; Fecha de Entrega:' + i.Fecha_de_entrega__c;
                    }else{
                        if(i.Tipo_Registro__c.contains('Anexo')){
                            borrado.Campo__c = 'Cultivar:' + String.ValueOf(i.Variedade_Prod__c) + '; Categoria:' + mapaCat.get(String.ValueOf(i.Categoria__c));
                        }
                    }
                }
                if(i.Tipo_Registro__c == 'Objetivo Ventas Royalties'){
                    borrado.Campo__c = 'Quantidade:' + String.ValueOf(i.Quantidade__c);
                }
                borrado.Producto_Referencia__c = i.Variedade_Prod__c;
                borrado.Usuario__c = UserInfo.getUserId();
                borrado.Fecha_de_Cambio__c = System.Now();
                borrado.Oportunidad_Referencia__c = i.OpportunityId;
                cambios.add(borrado);
            }     
        }
    }
     if (Trigger.isInsert) {

        for (OpportunityLineItem i : Trigger.new) {
            if(i.Es_Previsao__c == true || (i.Tipo_Registro__c != null && (i.Tipo_Registro__c == 'PB-Produccion' || i.Tipo_Registro__c == 'PB-Comercial' || i.Tipo_Registro__c == 'PB-Desarrollo' || i.Tipo_Registro__c.contains('Anexo') || i.Tipo_Registro__c.contains('Objetivo Ventas Royalties')))){
            //if(i.Es_Previsao__c == true || i.Tipo_Registro__c == 'PB-Produccion' || i.Tipo_Registro__c == 'PB-Comercial'){
                Cambios_OLI__c agregado = New Cambios_OLI__c();
                agregado.Accion__c = 'AGREGÓ';
                if(i.Es_Previsao__c == true){
                    agregado.Campo__c = 'Previsao:' + String.ValueOf(i.Previsao__c) + '; Motivo:' + i.Motivo__c;
                }else{
                    if(i.Tipo_Registro__c == 'PB-Produccion' || i.Tipo_Registro__c == 'PB-Comercial' || i.Tipo_Registro__c == 'PB-Desarrollo'){
                        agregado.Campo__c = 'Quantidade:' + String.ValueOf(i.Quantidade__c) + '; Local de Entrega:' + i.Local_de_Entrega__c + '; Data:' + i.Data__c + '; Tipo de Necesidad:' + i.Tipo_de_Necesidad__c + '; Fecha de Entrega:' + i.Fecha_de_entrega__c;
                    }else{
                        if(i.Tipo_Registro__c.contains('Anexo')){
                            agregado.Campo__c = 'Cultivar:' + String.ValueOf(i.Variedade_Prod__c) + '; Categoria:' + mapaCat.get(String.ValueOf(i.Categoria__c));
                        }
                    }
                }
                if(i.Tipo_Registro__c == 'Objetivo Ventas Royalties'){
                    agregado.Campo__c = 'Quantidade:' + String.ValueOf(i.Quantidade__c);
                }
                agregado.Producto_Referencia__c = i.Variedade_Prod__c;
                agregado.Usuario__c = UserInfo.getUserId();
                agregado.Fecha_de_Cambio__c = System.Now();
                agregado.Oportunidad_Referencia__c = i.OpportunityId;
                cambios.add(agregado);
            }     
        }
    }      
     if (Trigger.isUpdate) {

        for (OpportunityLineItem i : Trigger.new) {
            if(i.Es_Previsao__c == true || (i.Tipo_Registro__c != null && (i.Tipo_Registro__c == 'PB-Produccion' || i.Tipo_Registro__c == 'PB-Comercial' || i.Tipo_Registro__c == 'PB-Desarrollo' || i.Tipo_Registro__c.contains('Anexo') || i.Tipo_Registro__c.contains('Objetivo Ventas Royalties')))){
            //if(i.Es_Previsao__c == true || i.Tipo_Registro__c == 'PB-Produccion' || i.Tipo_Registro__c == 'PB-Comercial'){
                OpportunityLineItem Antes = System.Trigger.oldMap.get(i.Id);
                if(Antes.Previsao__c != i.Previsao__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Previsao';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Previsao__c);
                    actualizado.Valor_Actual__c = String.ValueOF(i.Previsao__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Motivo__c != i.Motivo__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Motivo';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = Antes.Motivo__c;
                    actualizado.Valor_Actual__c = i.Motivo__c;
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Quantidade__c != i.Quantidade__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Quantidade';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Quantidade__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Quantidade__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Data__c != i.Data__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Data';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Data__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Data__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                /*
                if(Antes.Local_Origem__c != i.Local_Origem__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Local Origem';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = Antes.Local_Origem__c;
                    actualizado.Valor_Actual__c = i.Local_Origem__c;
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                } 
                */
                if(Antes.Local_de_Entrega__c != i.Local_de_Entrega__c){                
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Local de Entrega';                    
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = Antes.Local_de_Entrega__c;
                    actualizado.Valor_Actual__c = i.Local_de_Entrega__c;                    
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Categoria__c != i.Categoria__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Categoria';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = mapaCat.get(String.ValueOf(Antes.Categoria__c));
                    actualizado.Valor_Actual__c = mapaCat.get(String.ValueOf(i.Categoria__c));
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Categoria_a_Rebaixar__c != i.Categoria_a_Rebaixar__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Categoria a Rebaixar';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = mapaCat.get(String.ValueOf(Antes.Categoria_a_Rebaixar__c));
                    actualizado.Valor_Actual__c = mapaCat.get(String.ValueOf(i.Categoria_a_Rebaixar__c));
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                } 
                if(Antes.Estado_de_Comercializacion__c != i.Estado_de_Comercializacion__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Estado de Com.';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = mapaEstados.get(String.ValueOf(Antes.Estado_de_Comercializacion__c));
                    actualizado.Valor_Actual__c = mapaEstados.get(String.ValueOf(i.Estado_de_Comercializacion__c));
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Estado_de_Produccion__c != i.Estado_de_Produccion__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Estado de Prod.';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = mapaEstados.get(String.ValueOf(Antes.Estado_de_Produccion__c));
                    actualizado.Valor_Actual__c = mapaEstados.get(String.ValueOf(i.Estado_de_Produccion__c));
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Area__c != i.Area__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Ha. Aut.';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Area__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Area__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Area_Plantada__c != i.Area_Plantada__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Ha. Plant.';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Area_Plantada__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Area_Plantada__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Semente_bruta__c != i.Semente_bruta__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Semente Bruta';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Semente_bruta__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Semente_bruta__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Descarte__c != i.Descarte__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Descarte';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Descarte__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Descarte__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Semente_beneficiada__c != i.Semente_beneficiada__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Sem. Beneficiada';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Semente_beneficiada__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Semente_beneficiada__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Semente_aprovada__c != i.Semente_aprovada__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Sem. Aprovada';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Semente_aprovada__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Semente_aprovada__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Semente_uso_propio__c != i.Semente_uso_propio__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Sem. Uso Prop.';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Semente_uso_propio__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Semente_uso_propio__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Semente_comercializada__c != i.Semente_comercializada__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Sem. Comerc.';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Semente_comercializada__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Semente_comercializada__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Sem_Rebajada__c != i.Sem_Rebajada__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Sem. Rebaixada';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Sem_Rebajada__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Sem_Rebajada__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Fecha_de_entrega__c != i.Fecha_de_entrega__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Fecha de entrega';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Fecha_de_entrega__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Fecha_de_entrega__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
                if(Antes.Tipo_de_Necesidad__c != i.Tipo_de_Necesidad__c){
                    Cambios_OLI__c actualizado = New Cambios_OLI__c();
                    actualizado.Accion__c = 'ACTUALIZÓ';
                    actualizado.Campo__c = 'Tipo de Necesidad';
                    actualizado.Producto_Referencia__c = i.Variedade_Prod__c;
                    actualizado.Valor_Anterior__c = String.ValueOf(Antes.Tipo_de_Necesidad__c);
                    actualizado.Valor_Actual__c = String.ValueOf(i.Tipo_de_Necesidad__c);
                    actualizado.Usuario__c = UserInfo.getUserId();
                    actualizado.Fecha_de_Cambio__c = System.Now();
                    actualizado.Oportunidad_Referencia__c = i.OpportunityId;
                    cambios.add(actualizado);
                }
            } 
        }
    }
    if(cambios.size() != 0) insert cambios;
}
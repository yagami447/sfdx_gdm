public class aSiteCreateRoyaltyEventController  {

    public Evento_Royalty__c newEvent       {get; set;}
    public Saldo_por_safra__c saldoActual   {get; set;}

    private String token;
    private SiteUser__c logUser;
    private SiteUserSession__c activeSession;
    public Account activeAccount            {get; set;}
    public String safraActual               {get; set;}

    public Evento_Royalty_Item__c newItem {get; set;}
    public List<Evento_Royalty_Item__c> item {get; set;}
    public List<SelectOption> optionCultivar {get; set;}
    public List<SelectOption> optionUF      {get; set;}
    public List<SelectOption> optionItemAll {get; set;}
    public String linea {get; set;}
    public String estado;
    public Id eventoId                      {get; set;}
    public Boolean vieneDeEditar            {get; set;}
    
    public String categoria                 {get; set;}
    public String tipoAccion                {get; set;}
    public Map<String, Evento_Royalty_Produto__c> mapPrecioItems    {get; set;}
    public String mensaje                   {get; set;} 
    
    public aSiteCreateRoyaltyEventController() {

        newItem = new Evento_Royalty_Item__c();
        item = new List<Evento_Royalty_Item__c>();
        linea = null;
        
        mapPrecioItems = New Map<String, Evento_Royalty_Produto__c>();        

    }

    public PageReference validate() {
        token = System.currentPageReference().getParameters().get('token'); 
        eventoId = System.currentPageReference().getParameters().get('eventoId');
        tipoAccion = System.currentPageReference().getParameters().get('tipo');
        if(token!=null){
            logUser = aSiteAuthManager.VerifyUserSession(token);
            if(logUser!=null){
                activeSession = aSiteAuthManager.getUserSession(token);
                activeAccount = aSiteAuthManager.getActiveAccount_byUser(logUser);

                safraActual = aAppManager.getSafraActualByApp('DescontoRoyalty');

                List<Saldo_por_safra__c> saldo = 
                                        [SELECT Id, Saldo_Disponible__c, Saldo__c, Estado__c 
                                         FROM Saldo_por_safra__c 
                                         WHERE Safra__c =: safraActual 
                                         AND Account__c =: activeAccount.Id AND Marca__c =: activeSession.Marca__c LIMIT 1];
                if (saldo.size() > 0)
                    saldoActual = saldo[0];
                newEvent = new Evento_Royalty__c();
                newEvent.Cuenta__c = activeAccount.Id;
                if (saldoActual != null)
                    newEvent.Saldo_por_safra__c = saldoActual.Id;
                newEvent.Valor__c = 0;
                newEvent.Accion__c = tipoAccion;

                if(eventoId != null){
                    vieneDeEditar = true;
                    Evento_Royalty__c royalty = [SELECT Id, Name, Valor__c, Fecha__c, Comentarios__c, Estado__c, Accion__c
                                                 FROM Evento_Royalty__c
                                                 WHERE Id = :eventoId];

                    newEvent.Name = royalty.Name;
                    newEvent.Fecha__c = royalty.Fecha__c;
                    newEvent.Valor__c = royalty.Valor__c;
                    newEvent.Comentarios__c = royalty.Comentarios__c;
                    newEvent.Accion__c = royalty.Accion__c;
                    getItems();
                } else {
                    vieneDeEditar = false;          
                }
                
                categoria = 'Categoria 1';
                if (saldoActual != null){
                    if (saldoActual.Saldo__c >= 100000 && saldoActual.Saldo__c < 200000)
                        categoria = 'Categoria 2';
                    if (saldoActual.Saldo__c >= 200000 && saldoActual.Saldo__c < 300000)
                        categoria = 'Categoria 3';
                    if (saldoActual.Saldo__c >= 300000 && saldoActual.Saldo__c < 400000)
                        categoria = 'Categoria 4';
                    if (saldoActual.Saldo__c >= 400000 && saldoActual.Saldo__c < 600000)
                        categoria = 'Categoria 5';
                    if (saldoActual.Saldo__c >= 600000)
                        categoria = 'Categoria 6'; 
                }
                
                optionCultivar = new List<SelectOption>{new SelectOption('','-- None --')};
                for (Variedad__c c : [Select Id, Name From Variedad__c Where Sociedad__c = 'BRMX'])
                    optionCultivar.add(new SelectOption(c.Id, c.Name));
                    
                optionUF = new List<SelectOption>{new SelectOption('','-- None --')};
                for (Estado__c e : [Select Id, Name From Estado__c Where Mostrar_en_portal__c = true])
                    optionUF.add(new SelectOption(e.Id, e.Name));    
                    
                optionItemAll = new List<SelectOption>{new SelectOption('','-- None --')};
                for (Evento_Royalty_Produto__c e : [Select Id, Nome__c, Valor__c From Evento_Royalty_Produto__c])
                    optionItemAll.add(new SelectOption(e.Id, e.Nome__c));  
                    
                return null;  
            }          
        }

        PageReference p = new PageReference('/apex/aSiteLogin');
        String marca = aSiteAuthManager.getMarcaBySession(token);
        if (marca != null)
            p.getParameters().put('comp',marca);
        p.setRedirect(true);
        return p;
        
    }
    
    public List<SelectOption> getOptionTipo(){
    
        Set<String> tipos = New Set<String>();
        List<SelectOption> lista = new List<SelectOption>{new SelectOption('','-- None --')};
        for (Evento_Royalty_Produto__c  p : [Select Id, Tipo__c From Evento_Royalty_Produto__c Where Accion__c = :tipoAccion AND Marca__c =: activeSession.Marca__c]){
            if (!tipos.contains(p.Tipo__c))
                lista.add(new SelectOption(p.Tipo__c, p.Tipo__c));
            tipos.add(p.Tipo__c);    
        }    
            
        return lista;
    
    }
    
    public List<SelectOption> getOptionItem(){
    
        List<SelectOption> lista = new List<SelectOption>{new SelectOption('','-- None --')};
        for (Evento_Royalty_Produto__c  p : [Select Id, Tipo__c, Nome__c, Valor__c From Evento_Royalty_Produto__c Where Tipo__c = :newItem.Tipo__c]){
            lista.add(new SelectOption(p.Id, p.Nome__c));
            mapPrecioItems.put(p.Id, p);            
        }    
            
        return lista;
    
    }        
    
    public void changeTipo(){
        newItem.Valor_Unitario__c = null;
    }
    
    public void changeItem(){
        newItem.Valor_Unitario__c = null;
        if (mapPrecioItems.get(newItem.Item__c) != null){
            newItem.Valor_Unitario__c = mapPrecioItems.get(newItem.Item__c).Valor__c;
        }
    }

    public Boolean validateValue() {

        if (saldoActual != null){
            if(saldoActual.Saldo_Disponible__c - newEvent.Valor__c >= 0) {
                return true;
            }
        }
        return false;

    }
    
    public Boolean validateSecuenciaTipos() {
        Double brindes = 0;
        Boolean hayOutdoor = false;
        for (AggregateResult ar : [Select Tipo__c tipo, Sum(Valor__c) valor From Evento_Royalty_Item__c Where Evento_Royalty__r.Saldo_por_safra__c = :newEvent.Saldo_por_safra__c And Evento_Royalty__r.Estado__c = 'Aprobado' Group By Tipo__c]){
            if (String.valueOf(ar.get('tipo')) == 'Brinde')
                brindes = Double.valueOf(ar.get('valor'));        
            if (String.valueOf(ar.get('tipo')) == 'Outdoor')    
                hayOutdoor = true;
        }
        
        for (Evento_Royalty_Item__c i : item){
            if (i.Tipo__c == 'Brinde')
                brindes += i.Valor__c;
            if (i.Tipo__c == 'Outdoor')
                hayOutdoor = true;    
        }
        
        for (Evento_Royalty_Item__c i : item){
            if (i.Tipo__c == 'Outdoor')
                if (validarBrindesCategoria(brindes)){
                    break;
                }else{
                    return false;
                }
        }
        
        for (Evento_Royalty_Item__c i : item){
            if (i.Tipo__c != 'Brinde' && i.Tipo__c != 'Outdoor')
                if (validarBrindesCategoria(brindes) && hayOutdoor){
                    break;
                }else{
                    return false;
                }
        }
        
        return true;
        
    }
    
    public Boolean validarBrindesCategoria (Double brindes){
    
        if (saldoActual != null){
            if (categoria == 'Categoria 1')
                if ((brindes * 100 / saldoActual.Saldo__c) < 60)
                    return false;
                
            if (categoria == 'Categoria 2')
                if ((brindes * 100 / saldoActual.Saldo__c) < 50)
                    return false;        
    
            if (categoria == 'Categoria 3')
                if ((brindes * 100 / saldoActual.Saldo__c) < 40)
                    return false;
    
            if (categoria == 'Categoria 4')
                if ((brindes * 100 / saldoActual.Saldo__c) < 30)
                    return false;
                
            if (categoria == 'Categoria 5')
                if ((brindes * 100 / saldoActual.Saldo__c) < 20)
                    return false;       
                
            if (categoria == 'Categoria 6')
                if ((brindes * 100 / saldoActual.Saldo__c) < 15)
                    return false;         
        }                            
                
        return true;        
    
    }

    public void getItems(){
        item = [SELECT Id, Item__c, Valor__c, Data__c, 
                        Comentario__c, Evento_Royalty__c, Cidade__c, Quantidade__c, Tipo__c, UF__c, UF__r.Name, Valor_Unitario__c, Variedad__c, Variedad__r.Name, Modelo__c, Tamanio__c, Indice__c
                FROM Evento_Royalty_Item__c
                WHERE Evento_Royalty__c = :eventoId];
    }

    public PageReference agregarItem(){

        mensaje = '';
        
        if(newItem.Tipo__c ==  '-- None --' || newItem.Item__c ==  '-- None --' || newItem.Comentario__c == null){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Você deve preencher todos os campos');
            //ApexPages.addMessage(myMsg);
            mensaje = 'Você deve preencher todos os campos';
            return null;
        }
        
        if(tipoAccion == 'Pedido' && (newItem.Quantidade__c == null ||  newItem.Valor_Unitario__c == null)){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Você deve preencher todos os campos');
            //ApexPages.addMessage(myMsg);
            mensaje = 'Você deve preencher todos os campos';
            return null;
        }
        
        if(tipoAccion == 'Pedido' && (newItem.Tipo__c == 'Outdoor' || newItem.Tipo__c == 'Placa' || newItem.Tipo__c == 'Semente') && newItem.Variedad__c == null){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Você deve preencher todos os campos');
            //ApexPages.addMessage(myMsg);
            mensaje = 'Você deve preencher todos os campos';
            return null;
        }
        
        if(tipoAccion == 'Pedido' && newItem.Tipo__c == 'Outdoor' && (newItem.UF__c == null ||  newItem.Cidade__c == null ||  newItem.Cidade__c == '')){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Você deve preencher todos os campos');
            //ApexPages.addMessage(myMsg);
            mensaje = 'Você deve preencher todos os campos';
            return null;
        }

        if(tipoAccion == 'Reembolso' && (newItem.Data__c == null ||  newItem.Valor__c == null)){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Você deve preencher todos os campos');
            //ApexPages.addMessage(myMsg);
            mensaje = 'Você deve preencher todos os campos';
            return null;
        }

        if(newItem.Valor__c != null && newItem.Valor__c < 1){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Quantidades devem ser maiores que 0');
            //ApexPages.addMessage(myMsg);
            mensaje = 'Você deve preencher todos os campos';
            return null;
        }

        item.add(newItem);
        newItem = New Evento_Royalty_Item__c();
        Integer j = 0;
        for (Evento_Royalty_Item__c i : item){
            i.Indice__c = j;
            j++;    
        }
        sumarValor();
        return null;

    }

    public void eliminarItem() {

        if(item[Integer.valueOf(linea)].id != null){
            delete item[Integer.valueOf(linea)];
        }
        item.remove(Integer.valueOf(linea));
        Integer j = 0;
        for (Evento_Royalty_Item__c i : item){
            i.Indice__c = j;
            j++;    
        }
        linea = null;
        sumarValor();

    }


    public void sumarValor(){

        newEvent.Valor__c = 0;
        for(Evento_Royalty_Item__c itemRoyalty : item){
            if (tipoAccion == 'Pedido')
                itemRoyalty.Valor__c = (itemRoyalty.Quantidade__c * itemRoyalty.Valor_Unitario__c).divide(1, 2, System.RoundingMode.HALF_EVEN);
            newEvent.Valor__c += itemRoyalty.Valor__c;
        }

    }


    public PageReference guardarEvento() {

        estado = 'Edicion';
        return guardar(estado);

    }


    public PageReference enviarParaAprobacion(){
        
        mensaje = '';
        
        if(!validateSecuenciaTipos()) {
            mensaje = 'Você não solicitou o valor mínimo necessário em brindes e/ou outdoor.';
            return null;
        }
        
        estado = 'Pendiente de aprobación';
        return guardar(estado);

    }


    public PageReference guardar(String estado){
        
        mensaje = '';
        
        if(!validateValue()) {
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Saldo insuficiente para este evento.');
            //ApexPages.addMessage(myMsg);
            mensaje = 'Error: Saldo insuficiente para este evento.';
            return null;
        }                

        Evento_Royalty__c evento = new Evento_Royalty__c();
        System.debug('Usuario?: '+logUser);
        evento.Name = newEvent.Name;
        evento.Correo_Site_user__c = logUser.Email__c;
        if(newEvent != null){   
            evento.Valor__c = newEvent.Valor__c;
        }
        if(newEvent != null){   
            evento.Comentarios__c = newEvent.Comentarios__c;
        }                       
        if(newEvent != null && newEvent.Fecha__c != null){
            evento.Fecha__c = newEvent.Fecha__c;
            evento.Data__c = String.valueOf(newEvent.Fecha__c);
        } else if(newEvent.Fecha__c == null) {
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Você deve inserir uma data.');
            //ApexPages.addMessage(myMsg);
            mensaje = 'Error: Você deve inserir uma data.';
            return null;
        }
        evento.Cuenta__c = activeAccount.Id;
        evento.Safra__c = safraActual;
        evento.Saldo_por_safra__c = saldoActual.Id;
        evento.Estado__c = estado;
        evento.Accion__c = newEvent.Accion__c;
        evento.Marca__c = activeSession.Marca__c;
        
        if(!item.isEmpty()){
            if(vieneDeEditar){
                evento.Id = eventoId;
                update evento;
            } else {
                insert evento;
            }
            for(Evento_Royalty_Item__c itemRoyalty : item){
                if (itemRoyalty.Id == null)
                    if (mapPrecioItems.get(itemRoyalty.Item__c) != null)
                        itemRoyalty.Item__c = mapPrecioItems.get(itemRoyalty.Item__c).Nome__c;
                itemRoyalty.Evento_Royalty__c = evento.id;
            }           
            upsert item;
        } else {
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: você deve inserir itens.');
            //ApexPages.addMessage(myMsg);
            mensaje = 'Error: você deve inserir itens.';
            return null;
        }
        return goToSaldoSafra();

    }


    public PageReference goToSaldoSafra() {

        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteSaldoSafra');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
            
    }   

}
public class aSiteSaldoSafraController  {
    
    private String token;
    private SiteUser__c logUser;
    private SiteUserSession__c activeSession;
    public Account activeAccount            {get; set;}
    public Saldo_por_safra__c saldoActual   {get; set;}
    public String safraActual               {get; set;}
    
    public Boolean renderSaldo              {get; set;}
    public Boolean activeNuevoEvento        {get; set;}
    
    public List<Evento_Royalty__c> eventos  {get; set;}
    public List<Opportunity> opps           {get; set;}
    public Id eventoId                      {get; set;}
    public List<Evento_Royalty_Item__c> itemsDelEvento {get; set;}    
    
    public String categoria                 {get; set;} 
    public Double porcBrindes               {get; set;} 
    public Opportunity montoBrindes         {get; set;}   
    public String mensaje                   {get; set;} 
    public String tipoSel                   {get; set;}
    
    public aSiteSaldoSafraController(){
        itemsDelEvento = new List<Evento_Royalty_Item__c>();
    }
    
    public PageReference validate() {  
        
        activeNuevoEvento = true;
        
        token = System.currentPageReference().getParameters().get('token'); 
        
        if(token!=null){
            logUser = aSiteAuthManager.VerifyUserSession(token);
            if(logUser!=null){
                activeSession = aSiteAuthManager.getUserSession(token);
                activeAccount = aSiteAuthManager.getActiveAccount_byUser(logUser);
                safraActual = aAppManager.getSafraActualByApp('DescontoRoyalty');
                setItems();
                return null;
            }
            else {
                activeNuevoEvento = false;
            }
        }
        else {
            activeNuevoEvento = false;
        }       
        
        PageReference p = new PageReference('/apex/aSiteLogin');
        String marca = aSiteAuthManager.getMarcaBySession(token);
        if (marca != null)
            p.getParameters().put('comp',marca);
        p.setRedirect(true);
        return p;
        
    }
    
    public void setItems() {
        eventos = new List<Evento_Royalty__c>();
        List<Saldo_por_safra__c> saldo = [SELECT Id, Saldo_Disponible__c, Saldo__c, Estado__c 
                                          FROM Saldo_por_safra__c 
                                          WHERE Safra__c = :safraActual AND Account__c =: activeAccount.Id AND Marca__c =: activeSession.Marca__c
                                          LIMIT 1];
        if(saldo.isEmpty()){
            renderSaldo = false;
            activeNuevoEvento = false;
        }
        else {
            renderSaldo = true;
            saldoActual = saldo[0];
            
            List<Evento_Royalty__c> royalties = [SELECT Id, Fecha__c, Items__c, Name,
                                                 Comentarios__c, Valor__c,
                                                 Estado__c, Accion__c 
                                                 FROM Evento_Royalty__c 
                                                 WHERE Cuenta__c =: activeAccount.Id 
                                                 AND Safra__c =: safraActual AND Marca__c =: activeSession.Marca__c
                                                 ORDER BY CreatedDate DESC];    
            
            for(Evento_Royalty__c royalty : royalties) {
                if (royalty.Estado__c.containsIgnoreCase('Pendiente') || royalty.Estado__c.containsIgnoreCase('Edicion')) {
                    activeNuevoEvento = false;
                }
                eventos.add(royalty);
            }
            //eventos = sortByDate(eventos);
            if(saldoActual.Saldo_Disponible__c <= 0) {
                activeNuevoEvento = false;
            }                                       
            
            categoria = 'Categoria 1';
            porcBrindes = 60;            
            
            if (saldoActual.Saldo__c >= 100000 && saldoActual.Saldo__c < 200000){
                categoria = 'Categoria 2';
                porcBrindes = 50;    
            } 
               
            if (saldoActual.Saldo__c >= 200000 && saldoActual.Saldo__c < 300000){
                categoria = 'Categoria 3';
                porcBrindes = 40;
            }    
                
            if (saldoActual.Saldo__c >= 300000 && saldoActual.Saldo__c < 400000){
                categoria = 'Categoria 4';
                porcBrindes = 30;
            }    
                
            if (saldoActual.Saldo__c >= 400000 && saldoActual.Saldo__c < 600000){
                categoria = 'Categoria 5';
                porcBrindes = 20;
            }    
                
            if (saldoActual.Saldo__c >= 600000){
                categoria = 'Categoria 6'; 
                porcBrindes = 15;
            }    
            
            montoBrindes = New Opportunity();
            montoBrindes.Amount = (porcBrindes * saldoActual.Saldo__c / 100).divide(1, 2, System.RoundingMode.HALF_EVEN);
            
        }
        
    }
    
    public String getTextoFecha(Date fecha) {
        String textoFecha = fecha.day() + '/' + fecha.month() + '/' + fecha.year();
        return textoFecha;
    }
    
    public PageReference goToCreateRoyaltyEventPedido() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteCreateRoyaltyEvent');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        pr.getParameters().put('tipo','Pedido');
        return pr;
    }
    
    public Boolean validateSecuenciaTipos(String paso) {
        Double brindes = 0;
        Boolean hayOutdoor = false;
        for (AggregateResult ar : [Select Tipo__c tipo, Sum(Valor__c) valor From Evento_Royalty_Item__c Where Evento_Royalty__r.Saldo_por_safra__c = :saldoActual.Id And Evento_Royalty__r.Estado__c = 'Aprobado' Group By Tipo__c]){
            if (String.valueOf(ar.get('tipo')) == 'Brinde')
                brindes = Double.valueOf(ar.get('valor'));        
            if (String.valueOf(ar.get('tipo')) == 'Outdoor')    
                hayOutdoor = true;
        }
        
        if (paso == 'irReembolso' && (!validarBrindesCategoria(brindes) || !hayOutdoor))
            return false;   
            
        List<Evento_Royalty_Item__c> items = New List<Evento_Royalty_Item__c>();
        items = [Select Tipo__c, Valor__c From Evento_Royalty_Item__c Where Evento_Royalty__c =: eventoId];

        for (Evento_Royalty_Item__c i : items){
            if (i.Tipo__c == 'Brinde')
                brindes += i.Valor__c;        
            if (i.Tipo__c == 'Outdoor')    
                hayOutdoor = true;
        }       
        
        for (Evento_Royalty_Item__c i : items){
            if (i.Tipo__c == 'Outdoor')
                if (validarBrindesCategoria(brindes)){
                    break;
                }else{
                    return false;
                }
        }
        
        for (Evento_Royalty_Item__c i : items){
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
    
        if (brindes < montoBrindes.Amount)
            return false;                                
                
        return true;        
    
    }
    
    public PageReference goToCreateRoyaltyEventReembolso() {
        
        mensaje = '';
        
        if(!validateSecuenciaTipos('irReembolso')) {
            mensaje = 'Você não solicitou o valor mínimo necessário em brindes e/ou outdoor.';
            return null;
        }                  
        
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteCreateRoyaltyEvent');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        pr.getParameters().put('tipo','Reembolso');
        return pr;
    }
    
    public void verItems(){
        itemsDelEvento = [SELECT Id, Item__c, Valor__c, Data__c, 
                          Comentario__c, Evento_Royalty__c, Variedad__r.Name, UF__r.Name, Cidade__c, Quantidade__c, Tipo__c, Valor_Unitario__c, Evento_Royalty__r.Accion__c, Modelo__c, Tamanio__c
                          FROM Evento_Royalty_Item__c
                          WHERE Evento_Royalty__c = :eventoId];
                          
        tipoSel = itemsDelEvento[0].Evento_Royalty__r.Accion__c;
        
    }
    
    public PageReference editar(){
        Evento_Royalty__c roy = [SELECT Id, Accion__c 
                                         FROM Evento_Royalty__c 
                                         WHERE Id =: eventoId 
                                         limit 1];          
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteCreateRoyaltyEvent');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        pr.getParameters().put('eventoId',eventoId);
        pr.getParameters().put('tipo',roy.Accion__c);
        return pr;
    }
    
    public void enviarParaAprobacion(){
        
        mensaje = '';
        
        if(!validateSecuenciaTipos('enviarAprobacion')) {
            mensaje = 'Você não solicitou o valor mínimo necessário em brindes e/ou outdoor.';
            return;
        }
        
        Evento_Royalty__c evento = [SELECT Id, Name, Estado__c
                                    FROM Evento_Royalty__c
                                    WHERE Id = :eventoId];
        
        evento.Estado__c = 'Pendiente de aprobación';
        update evento;
        setItems();
    }
    
}
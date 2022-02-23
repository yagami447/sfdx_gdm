global without sharing class aSiteVotacionController {

	private String token;
    private SiteUser__c logUser;
    private SiteUserSession__c activeSession;
    private Account activeAccount;
    private String safraActual;
    
    public List<SelectOption> optionVariedad {get; set;}
    public Map<String, String> mapVariedades {get; set;}
    public String variedad {get; set;}
    public String valor {get; set;}
    public Integer vuelta {get; set;}
    private Map<String, List<String>> preciosBalotage;
    public List<SelectOption> optionsPrecio {get; set;}
    public Boolean generaVoto {get;set;}
    
    public String language {get;set;}
    public String mensaje {get;set;}
    public String regionCuenta {get;set;}
    
    public Boolean habilitadoVotar {get;set;}
    
    public List<PieWedgeData> PieData {get;set;}
    public List<PieWedgeData> PieData2 {get;set;}
        
    public class PieWedgeData {
        public String name { get; set; }
        public Double data { get; set; }

        public PieWedgeData(String name, Double data) {
            this.name = name;
            this.data = data;
        }
    }
    
    global aSiteVotacionController () {
        try{
            language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
            
            PieData = new List<PieWedgeData>();
            PieData2 = new List<PieWedgeData>();            											                                                                               	
        }
        catch(Exception e){
        }
    }
    
    public PageReference validate() {        
        token = System.currentPageReference().getParameters().get('token');

        if(token!=null){
            logUser = aSiteAuthManager.VerifyUserSession(token);
            if(logUser!=null){
                activeSession = aSiteAuthManager.getUserSession(token);
                activeAccount = aSiteAuthManager.getActiveAccount_byUser(logUser);
                safraActual = aVotacionManager.getSafraActualVotacion();  
                regionCuenta = aVotacionManager.getRegionCuenta(activeAccount.Id);
                habilitadoVotar = aVotacionManager.getHabilitadoVotacion(regionCuenta);
                vuelta = aVotacionManager.getNroVuelta(regionCuenta);
                cargarVariedades();  
                //cargarResumenVotos();                                          
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
    
    public void cargarVariedades(){
    	optionVariedad = New List<SelectOption>();
        optionVariedad.add(new SelectOption('--Nenhuma--', '--Nenhuma--'));
        mapVariedades = New Map <String, String>();
        if (vuelta == 1){
        	for (Item_del_Contrato__c i : aVotacionManager.getVariedadesHabilitadas(activeAccount.Id, safraActual)){
            	optionVariedad.add(new SelectOption(i.Cultivar__c, i.Cultivar__r.Variedade__r.Name));
            	mapVariedades.put(i.Cultivar__c, i.Cultivar__r.Variedade__r.Name);
        	}
        }
        if (vuelta == 2){
        	preciosBalotage = New Map<String, List<String>>();
        	for (Votacion_balotage__c i : aVotacionManager.getVariedadesBalotage(safraActual, regionCuenta)){
            	optionVariedad.add(new SelectOption(i.Producto__c, i.Variedad__c));
            	mapVariedades.put(i.Producto__c, i.Variedad__c);
            	List<String> precios = New List<String>();
            	precios.add(String.valueOf(i.valor1__c));
            	precios.add(String.valueOf(i.valor2__c));
            	preciosBalotage.put(i.Producto__c, precios);
        	}
        }
    }   
    
    public void changeVariedad(){
    	PieData = new List<PieWedgeData>();
    	for (AggregateResult ar : aVotacionManager.getVotacionVariedad(variedad, safraActual, regionCuenta, vuelta))
    		PieData.add(new PieWedgeData(String.valueOf(ar.get('valor')), Double.valueOf(ar.get('porc'))));    	
    	
    	if (vuelta == 2){
    		optionsPrecio = New List<SelectOption>();
    		List<String> precios = New List<String>();
    		precios = preciosBalotage.get(variedad);
    		if (precios != null && precios.size() > 0)
    			for (String s : precios)
    				optionsPrecio.add(new SelectOption(s,s));    		
    	}
    	
    	valor = null;
    } 
    
    public void cargarResumenVotos(){
    	PieData2 = new List<PieWedgeData>();
    	for (Votacion__c v : aVotacionManager.getVotacionesByAccount(activeAccount.Id, safraActual, regionCuenta, vuelta))
    		PieData2.add(new PieWedgeData(v.Variedad__c, Double.valueOf(v.Valor__c)));    	    	    
    } 
    
    public void generarVotacion(){
    	
    	generaVoto = false;
    	String valDatos = aVotacionManager.valDatos(variedad, valor);
    	if (valDatos == ''){
    		generaVoto = true;
    		mensaje = 'Deseja avançar com o valor ' + valor + ' para a votação da variedade ' + mapVariedades.get(variedad) + '? Apos confirmar, não será possível alteração do valor.';
    	}else{
    		mensaje = valDatos;
    	}
    }
    
    public PageReference saveVotacion(){                
        
        mensaje = '';
        
        try{                                               
            aSiteUtils.retorno ret = aVotacionManager.votar(activeAccount.Id, variedad, valor, safraActual, regionCuenta, vuelta);
                                                       
            if (ret.exito == true){
            	mensaje = 'Seu voto foi registrado com sucesso.';
            }else{
                mensaje = ret.mensaje;
                return null;
            } 
            
            changeVariedad();
                                    
        }catch(Exception e){          
            mensaje = e.getMessage();
            return null;
        }        
        
        aAppManager.updateSession(activeSession);
                
        return null;
        
    }		
    
}
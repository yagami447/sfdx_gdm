global class aSiteHeaderController {

    public SiteUser__c logUser {get;set;}
    public SiteUserAccount__c activeAccount {get;set;}
    public SiteUserSession__c activeSession {get;set;}
    public Boolean isLogged {get;set;}
    public String titulo1 {get;set;}
    public String titulo1Reb {get;set;}
    public String titulo2 {get;set;}
    public String titulo2Reb {get;set;}
    public String titulo3 {get;set;}
    public String titulo4 {get;set;}
    public String titulo5 {get;set;}
    // Descarte get and set Elias
    public String titulo6 {get; set;}
    public String titulo7 {get; set;}
    public String tituloEstoque {get;set;}
    public String tituloMidia {get;set;}

    public String tituloVotacion1 {get;set;}
    public String tituloVotacion2 {get;set;}
    public String tituloVotacion3 {get;set;}

    public String tituloSalesRep {get;set;}
    public String tituloProdRep {get;set;}
    public String tituloVenda {get;set;}

    private Map<String,String> rTypes;
    public String language {get;set;}

    public String evento {get;set;}
    public List<SelectOption> OptionEvento {get;set;}

    public Boolean habilitadoMenuVotacion {get;set;}
    public Boolean habilitadoVotar {get;set;}
    public Boolean hibilitadoDescontoRoyalties {get; set;}
    public Boolean habilitadoContaCorriente {get; set;}
    public Boolean habilitadoVendaDeBasica {get; set;}

    public Boolean redirectArg {get;set;}

    global aSiteHeaderController() {
        String pn = getVFPageName();
        //'aSiteLogin', 'aSiteActionConfirmation' , 'aSiteChangePass', 'aSiteForgotPass', 'aSiteForgotPassConfirm'
        language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;

        redirectArg = false; 

        if ((pn == 'aSiteHome' || pn == 'aSiteProfile' || pn == 'aSiteAppendix1' || pn == 'aSiteAppendix2' || pn == 'aSiteContracts'
        || pn == 'aSiteProfileEdit' || pn == 'aSiteAppendix1Edit' ||pn == 'aSiteAppendix2Edit' || pn == 'aSiteAppendix3Edit' || pn == 'aSiteAppendix3' || pn == 'aSiteAppendix1Reb'
        || pn == 'aSiteAppendix2Reb' || pn == 'aSiteAppendix4' || pn == 'aSiteAppendix4Edit' || pn == 'aSiteAppendix5' || pn == 'aSiteAppendix5Edit' || pn == 'aSiteReembalagemEdit'
        || pn == 'aSiteSalesReportEdit' || pn == 'aSiteProductionReportEdit' || pn == 'aSiteSalesReport' || pn == 'aSiteProductionReport' 
        || pn == 'aSiteAppendix2RebEdit' || pn == 'aSiteEventos' || pn == 'aSiteEventoEdit' || pn == 'aSiteVotacion' || pn == 'aSiteVotacionResumen'
        || pn == 'aSiteEstoque' || pn == 'aSiteEstoqueEdit' || pn == 'aSiteMidiaKit'
        || pn == 'aSiteDescarte' || pn == 'aSiteDescarteEdit' || pn == 'aSiteReembalagem' || pn == 'aSiteCreateRoyaltyEvent'
		|| pn == 'aSiteSaldoSafra' || pn == 'aSiteVendaDeBasica' || pn == 'aSiteCuentaCorriente' || pn == 'asiteDevoluciones') && validate()) {
            isLogged = true;
        }

        rTypes = Opp_Utils.cargarRecordTypesOppbyDevName();

        titulo1 = rTypes.get('AnexoI');
        titulo1Reb = Label.Rebajamiento_de_Hectareas;
        titulo2 = rTypes.get('AnexoII');
        titulo2Reb = Label.Rebajamiento_de_Bolsas;
        titulo3 = rTypes.get('Anexo_III');
        titulo4 = rTypes.get('Anexo_IV');
        titulo5 = rTypes.get('AnexoV');
        // Addded titulo6 Descarte Elias
        titulo6 = rTypes.get('Descarte');
        // titulo7 = rTypes.get('Reembalaje');
        titulo7 = 'Reembalagem'; 
        tituloSalesRep = rTypes.get('Sales_Report');
        tituloProdRep = rTypes.get('Production_Report');

        OptionEvento = new List<SelectOption>();

        for (String s : aEventosManager.getTiposEvento()) {
        	OptionEvento.add(new SelectOption(s,s));
        }

        tituloVotacion1 = 'Votar no preço';  
        tituloVotacion2 = 'Resultados';    	
        tituloVotacion3 = 'Meus votos';

        tituloEstoque = 'Levantamento de estoque';
        tituloVenda = 'Venda de básica';
        tituloMidia = 'Midia Kit';                   
    }

    public SiteUser__c getUser() {
        return logUser;
    }

    public boolean validate() {
        String token = System.currentPageReference().getParameters().get('token');

        if (token != null) {
            logUser = aSiteAuthManager.VerifyUserSession(token);

            if (logUser != null) {
                activeAccount = aSiteAuthManager.VerifyActiveAccount(logUser);

                if (activeAccount.Account__r.BillingCountry == 'PY' || activeAccount.Account__r.BillingCountry == 'PARAGUAI' || activeAccount.Account__r.BillingCountry == 'Paraguai') {
                    redirectArg = true;
                }

                activeSession = aSiteAuthManager.getUserSession(token);
                String regionCuenta = aVotacionManager.getRegionCuenta(activeAccount.Account__r.Id);
                habilitadoVotar = aVotacionManager.getHabilitadoVotacion(regionCuenta);

                habilitadoMenuVotacion = false;
                hibilitadoDescontoRoyalties = false;
                habilitadoContaCorriente = false;
                habilitadoVendaDeBasica = false;
                String marca = aSiteAuthManager.getMarcaBySession(token);

                if (marca == 'DSEM' && aSiteAuthManager.getUserSession(token).SiteUser__r.Habilitar_Royalty__c) {
                    habilitadoMenuVotacion = true;
                }

                if (marca == 'BRMX' && aSiteAuthManager.getUserSession(token).SiteUser__r.Habilitar_Royalty__c) {
                    hibilitadoDescontoRoyalties = true;
                }

                if (aSiteAuthManager.getUserSession(token).SiteUser__r.ativar_conta_corrente__c) {
                    habilitadoContaCorriente = true;
                }

                if (aSiteAuthManager.getUserSession(token).SiteUser__r.Habilitar_Venda_de_Basica__c) {
                    habilitadoVendaDeBasica = true;
                }

                return true;
            }
        }

        return false;
    }

    public string getVFPageName() {
        String pageName = ApexPages.CurrentPage().getUrl();
		//Arreglar
        if (Test.isRunningTest()) {
            pageName = '/apex/aSiteCreateRoyaltyEvent';
        }

        if (pageName.contains('/apex/')) {
            pageName = pageName.replaceFirst('/apex/', '');
        }

        pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');
        string[] pageNameExtra = pageName.split('%3F', 0);
        pageName = pageNameExtra[0];
    
        System.debug('pageName-->' + pageName);
        return pageName;
    }

    public PageReference gotoSalesReport() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteSalesReport');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoProdReport() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteProductionReport');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoDashboard() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteHome');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoProfile() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteProfile');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoAppend1() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix1');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoAppend1Rebaja() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix1Reb');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoAppend2() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix2');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoAppend2Rebaja() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix2Reb');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoAppend3() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix3');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoAppend4() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix4');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoAppend5() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteAppendix5');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoContract() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteContracts');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoEventos() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteEventos');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        pr.getParameters().put('evento',evento);
        return pr;
    }

    public PageReference gotoVotar() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteVotacion');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoResumenVotos() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteVotacionResumen');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoEstoque() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteEstoque');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    /////// Page reference descarte Elias/////////
	public PageReference gotoDescarte() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteDescarte');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }
    //////////////////////////////////////////////

    public PageReference gotoReembalagem() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteReembalagem');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

	public PageReference gotoSaldos() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteSaldoSafra');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

	public PageReference gotoVendaBasica() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteVendaDeBasica');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoCuentaCorriente() {
        System.debug('Llame a la pagina?');
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteCuentaCorriente');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference gotoMidiaKit() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteMidiaKit');
        pr.setRedirect(true);
        pr.getParameters().put('token',token);
        return pr;
    }

    public PageReference closeSession() {
        String token = System.currentPageReference().getParameters().get('token');
        String ret = token;
        String marca = activeSession.Marca__c;
        ret = aSiteAuthManager.CloseUserSession(token);
        PageReference pr = new PageReference('/apex/aSiteActionConfirmation');
        pr.setRedirect(true);
        pr.getParameters().put('comp', marca);

        if (ret == 'Ok') { return pr; }

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ret));
        return null;
    }
}
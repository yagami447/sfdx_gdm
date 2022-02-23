global without sharing class aSiteMidiaKitController {
    
    private String token;
    private SiteUser__c logUser;
    public SiteUserSession__c activeSession {get;set;}
    private Account activeAccount;
            
    public String language {get;set;}
    public String titulo {get;set;}
    
    public String pdfBlob {get; set;}
    public String nombrePDF {get; set;}
    public String urlImprimir {get; set;}
    
    public String mensaje {get; set;}
    
    public class archivo {
        public String nombre {get; set;}
        public String link {get; set;}        
    }                
    
    global aSiteMidiaKitController () {
        try{
            language = [select id, LanguageLocaleKey from User where id =: UserInfo.getUserId()].LanguageLocaleKey;
            titulo = 'Media Kit';            
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
    
    public List<archivo> getArteResProdutividadeBRMX(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Resultado Produtividade 2022 - Cerrado';
            arch.link = 'https://www.brasmaxgenetica.com.br/MidiaKit/ResultadoProdutividadeBrasmax_CERRADO_22.pptx';            
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Resultado Produtividade 2022 - Sul';
            arch2.link = 'https://www.brasmaxgenetica.com.br/MidiaKit/ResultadoProdutividadeBrasmax_SUL_22.pptx';            
            l_arch.add(arch2);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
    
    public List<archivo> getBigBagBRMX(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Etiquetas Big Bag';
            arch.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/BigBag/EtiquetaBigBag.rar';            
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'BigBag Brasmax 105x120cm logo uma cor';
            arch2.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/BigBag/BigBag_Brasmax_105x120cm_logo.pdf';            
            l_arch.add(arch2);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
    
    public List<archivo> getManualIdentVisualBRMX(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Manual de identidade visual Brasmax';
            arch.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/IdentidadeVisual/Manual_Identidade_Visual_Brasmax.pdf';            
            l_arch.add(arch);
                        
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
        
    public List<archivo> getTermosBRMX(){
        try{  
        
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Termo de Autorização de Uso de Imagem - Prazo Determinado';
            arch.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Autorizacao/TAUIPrazoDeterminado.doc';          
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Termo de Autorização de Uso de Imagem - Prazo Indeterminado';
            arch2.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Autorizacao/TAUIPrazoIndeterminado.doc';            
            l_arch.add(arch2);
            
            archivo arch3 = New archivo();
            arch3.nombre = 'Termo de Autorização de Uso de Imagem - Prazo Indeterminado CNPJ';
            arch3.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Autorizacao/TAUIPrazoIndeterminadoCNPJ.doc';            
            l_arch.add(arch3);
        
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }          
    
    public List<archivo> getLogosBRMX(){
        try{  
        
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Logo Brasmax Branco Horizontal';
            arch.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Brasmax/BrancoHorizontal.rar';            
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Logo Brasmax Branco Vertical';
            arch2.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Brasmax/BrancoVertical.rar';            
            l_arch.add(arch2);
            
            archivo arch3 = New archivo();
            arch3.nombre = 'Logo Brasmax Color Branco Horizontal';
            arch3.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Brasmax/ColorBrancoHorizontal.rar';            
            l_arch.add(arch3);
            
            archivo arch4 = New archivo();
            arch4.nombre = 'Logo Brasmax Color Branco Vertical';
            arch4.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Brasmax/ColorBrancoVertical.rar';            
            l_arch.add(arch4);
                                    
            archivo arch5 = New archivo();
            arch5.nombre = 'Logo Brasmax Color Preto Horizontal';
            arch5.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Brasmax/ColorPretoHorizontal.rar';            
            l_arch.add(arch5);
            
            archivo arch6 = New archivo();
            arch6.nombre = 'Logo Brasmax Color Preto Vertical';
            arch6.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Brasmax/ColorPretoVertical.rar';            
            l_arch.add(arch6);
            
            archivo arch7 = New archivo();
            arch7.nombre = 'Logo Brasmax Preto Horizontal';
            arch7.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Brasmax/PretoHorizontal.rar';            
            l_arch.add(arch7);
            
            archivo arch8 = New archivo();
            arch8.nombre = 'Logo Brasmax Preto Vertical';
            arch8.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Brasmax/PretoVertical.rar';            
            l_arch.add(arch8);
        
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }          
    
    public List<archivo> getLogosCultivaresBRMX(){
        try{
            
            List<archivo> l_arch = New List<archivo>();                        
            
            archivo arch5 = New archivo();
            arch5.nombre = 'BRASMAX ALVO RR';
            arch5.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/ALVORR.rar';            
            l_arch.add(arch5);
            
            archivo arch6 = New archivo();
            arch6.nombre = 'BRASMAX ATIVA RR';
            arch6.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/ATIVARR.rar';            
            l_arch.add(arch6);
            
            archivo arch7 = New archivo();
            arch7.nombre = 'BRASMAX BÔNUS IPRO';
            arch7.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/BONUSIPRO.rar';            
            l_arch.add(arch7);
            
            archivo arch8 = New archivo();
            arch8.nombre = 'BRASMAX BRAVA RR';
            arch8.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/BRAVARR.rar';            
            l_arch.add(arch8); 
            
            archivo arch9 = New archivo();
            arch9.nombre = 'BRASMAX CARGO I2X';
            arch9.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/CARGOI2X.rar';            
            l_arch.add(arch9);
            
            archivo arch10 = New archivo();
            arch10.nombre = 'BRASMAX CERTA IPRO';
            arch10.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/CERTAIPRO.rar';            
            l_arch.add(arch10); 
            
            archivo arch11 = New archivo();
            arch11.nombre = 'BRASMAX CICLONE CE';
            arch11.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/CICLONECE.rar';            
            l_arch.add(arch11);
            
            archivo arch12 = New archivo();
            arch12.nombre = 'BRASMAX COMPACTA IPRO';
            arch12.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/COMPACTAIPRO.rar';            
            l_arch.add(arch12); 
            
            archivo arch13 = New archivo();
            arch13.nombre = 'BRASMAX CROMO TF IPRO';
            arch13.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/CROMOTFIPRO.rar';            
            l_arch.add(arch13);
            
            archivo arch14 = New archivo();
            arch14.nombre = 'BRASMAX DELTA IPRO';
            arch14.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/DELTAIPRO.rar';            
            l_arch.add(arch14);
            
            archivo arch15 = New archivo();
            arch15.nombre = 'BRASMAX DESAFIO RR';
            arch15.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/DESAFIORR.rar';            
            l_arch.add(arch15);
            
            archivo arch16 = New archivo();
            arch16.nombre = 'BRASMAX DOMÍNIO IPRO';
            arch16.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/DOMINIOIPRO.rar';            
            l_arch.add(arch16);
            
            archivo arch17 = New archivo();
            arch17.nombre = 'BRASMAX EXTRA IPRO';
            arch17.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/EXTRAIPRO.rar';            
            l_arch.add(arch17);
            
            archivo arch18 = New archivo();
            arch18.nombre = 'BRASMAX EXTREMA IPRO';
            arch18.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/EXTREMAIPRO.rar';            
            l_arch.add(arch18);
            
            archivo arch19 = New archivo();
            arch19.nombre = 'BRASMAX FIBRA IPRO';
            arch19.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/FIBRAIPRO.rar';            
            l_arch.add(arch19);
            
            archivo arch20 = New archivo();
            arch20.nombre = 'BRASMAX FLX IPRO';
            arch20.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/FLXIPRO.rar';            
            l_arch.add(arch20);
            
            archivo arch21 = New archivo();
            arch21.nombre = 'BRASMAX FOCO IPRO';
            arch21.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/FOCOIPRO.rar';            
            l_arch.add(arch21);
            
            archivo arch22 = New archivo();
            arch22.nombre = 'BRASMAX GARRA IPRO';
            arch22.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/GARRAIPRO.rar';            
            l_arch.add(arch22);
            
            archivo arch23 = New archivo();
            arch23.nombre = 'BRASMAX ÍCONE IPRO';
            arch23.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/ICONEIPRO.rar';            
            l_arch.add(arch23);
            
            archivo arch24 = New archivo();
            arch24.nombre = 'BRASMAX LANÇA IPRO';
            arch24.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/LANCAIPRO.rar';            
            l_arch.add(arch24); 
            
            archivo arch25 = New archivo();
            arch25.nombre = 'BRASMAX LÓTUS IPRO';
            arch25.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/LOTUSIPRO.rar';            
            l_arch.add(arch25);
            
            archivo arch26 = New archivo();
            arch26.nombre = 'BRASMAX NEXUS IPRO';
            arch26.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/NEXUSI2X.rar';            
            l_arch.add(arch26); 

            archivo arch27 = New archivo();
            arch27.nombre = 'BRASMAX OLIMPO IPRO';
            arch27.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/OLIMPOIPRO.rar';            
            l_arch.add(arch27);
            
            archivo arch28 = New archivo();
            arch28.nombre = 'BRASMAX ORIGEM IPRO';
            arch28.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/ORIGEMIPRO.rar';            
            l_arch.add(arch28);
            
            archivo arch29 = New archivo();
            arch29.nombre = 'BRASMAX PONTA IPRO';
            arch29.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/PONTAIPRO.rar';            
            l_arch.add(arch29);
            
            archivo arch30 = New archivo();
            arch30.nombre = 'BRASMAX POTÊNCIA RR';
            arch30.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/POTENCIARR.rar';            
            l_arch.add(arch30);
            
            archivo arch31 = New archivo();
            arch31.nombre = 'BRASMAX POWER IPRO';
            arch31.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/POWERIPRO.rar';            
            l_arch.add(arch31);
            
            archivo arch32 = New archivo();
            arch32.nombre = 'BRASMAX RAIO IPRO';
            arch32.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/RAIOIPRO.rar';            
            l_arch.add(arch32);
            
            archivo arch33 = New archivo();
            arch33.nombre = 'BRASMAX RESULTA E';
            arch33.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/RESULTAE.rar';            
            l_arch.add(arch33);
            
            archivo arch34 = New archivo();
            arch34.nombre = 'BRASMAX TANQUE I2X';
            arch34.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/TANQUEI2X.rar';            
            l_arch.add(arch34);
            
            archivo arch35 = New archivo();
            arch35.nombre = 'BRASMAX TORMENTA CE';
            arch35.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/TORMENTACE.rar';            
            l_arch.add(arch35); 
            
            archivo arch36 = New archivo();
            arch36.nombre = 'BRASMAX TORNADO RR';
            arch36.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/TORNADORR.rar';            
            l_arch.add(arch36);
            
            archivo arch37 = New archivo();
            arch37.nombre = 'BRASMAX TORQUE I2X';
            arch37.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/TORQUEI2X.rar';            
            l_arch.add(arch37); 
            
            archivo arch38 = New archivo();
            arch38.nombre = 'BRASMAX TROVÃO I2X';
            arch38.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/TROVAOI2X.rar';            
            l_arch.add(arch38); 
            
            archivo arch39 = New archivo();
            arch39.nombre = 'BRASMAX ULTRA IPRO';
            arch39.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/ULTRAIPRO.rar';            
            l_arch.add(arch39);
            
            archivo arch40 = New archivo();
            arch40.nombre = 'BRASMAX ÚNICA IPRO';
            arch40.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/UNICAIPRO.rar';            
            l_arch.add(arch40);
            
            archivo arch41 = New archivo();
            arch41.nombre = 'BRASMAX VALENTE RR';
            arch41.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/VALENTERR.rar';            
            l_arch.add(arch41);
            
            archivo arch42 = New archivo();
            arch42.nombre = 'BRASMAX VELOZ RR';
            arch42.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/VELOZRR.rar';            
            l_arch.add(arch42);
            
            archivo arch43 = New archivo();
            arch43.nombre = 'BRASMAX VORAZ RR';
            arch43.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/VORAZIPRO.rar';            
            l_arch.add(arch43);
            
            archivo arch44 = New archivo();
            arch44.nombre = 'BRASMAX ZEUS IPRO';
            arch44.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/ZEUSIPRO.rar';            
            l_arch.add(arch44); 
                                                            
            archivo arch45 = New archivo();
            arch45.nombre = 'BRASMAX ATAQUE I2X';
            arch45.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/ATAQUEI2X.rar';            
            l_arch.add(arch45);
            
            archivo arch46 = New archivo();
            arch46.nombre = 'BRASMAX AUGE E';
            arch46.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/AUGEE.rar';            
            l_arch.add(arch46);
            
            archivo arch47 = New archivo();
            arch47.nombre = 'BRASMAX COLISEU I2X';
            arch47.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/COLISEUI2X.rar';            
            l_arch.add(arch47);
            
            archivo arch48 = New archivo();
            arch48.nombre = 'BRASMAX EXATA I2X';
            arch48.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/EXATAI2X.rar';            
            l_arch.add(arch48);
            
            archivo arch49 = New archivo();
            arch49.nombre = 'BRASMAX FORTALEZA IPRO';
            arch49.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/FORTALEZAIPRO.rar';            
            l_arch.add(arch49);
            
            archivo arch50 = New archivo();
            arch50.nombre = 'BRASMAX GUEPARDO IPRO';
            arch50.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/GUEPARDOIPRO.rar';            
            l_arch.add(arch50);
            
            archivo arch51 = New archivo();
            arch51.nombre = 'BRASMAX LENDÁRIA CE';
            arch51.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/LENDARIACE.rar';            
            l_arch.add(arch51);
            
            archivo arch52 = New archivo();
            arch52.nombre = 'BRASMAX VÊNUS CE';
            arch52.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Logos/Cultivares/VENUSCE.rar';            
            l_arch.add(arch52);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
    
    public List<archivo> getPlacasCampoBRMX(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Cultivar';
            arch.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/PlacasCampo/Cultivar.rar';
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Institucional';
            arch2.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/PlacasCampo/Institucional.rar';            
            l_arch.add(arch2);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    } 
    
    public List<archivo> getSacariaBRMX(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Sacaria Brasmax Conkesta 2021';
            arch.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Sacaria/SacariaConkesta2021.pdf';
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Sacaria Brasmax Enlist 2021';
            arch2.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Sacaria/SacariaEnlist2021.pdf';            
            l_arch.add(arch2);
                        
            archivo arch3 = New archivo();
            arch3.nombre = 'Sacaria Brasmax Intacta 2021';
            arch3.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Sacaria/SacariaIntacta2021.pdf';            
            l_arch.add(arch3);
            
            archivo arch4 = New archivo();
            arch4.nombre = 'Sacaria Brasmax Intacta I2X 2021';
            arch4.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Sacaria/SacariaIntactaI2X2021.pdf';            
            l_arch.add(arch4);
            
            archivo arch5 = New archivo();
            arch5.nombre = 'Sacaria Brasmax RR 2021';
            arch5.link = 'https://www.brasmaxgenetica.com.br/MidiaKit2021/Sacaria/SacariaRR2021.pdf';            
            l_arch.add(arch5);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    } 
            
    public List<archivo> getOutdoorBRMX(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Outdoor';
            arch.link = 'https://www.brasmaxgenetica.com.br/MidiaKit/Outdoor/outdoor_brasmax_2022.zip';
            l_arch.add(arch);    
            
            return l_arch;                    
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    } 
    
    public List<archivo> getArteResProdutividadeDSEM(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Resultado Produtividade 2022 - Cerrado';
            arch.link = 'https://www.donmario.com.br/MidiaKit/ResultadoProdutividadeDonmario_Cerrado_22.pptx';            
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Resultado Produtividade 2022 - Sul';
            arch2.link = 'https://www.donmario.com.br/MidiaKit/ResultadoProdutividadeDonmario_Sul_22.pptx';            
            l_arch.add(arch2);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
                        
    public List<archivo> getManualIdentVisualDSEM(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Manual da Marca DonMario 2021';
            arch.link = 'https://www.donmario.com/MidiaKit2021/IdentidadeVisual/ManualMarcaDonmario2021.pdf';
            
            l_arch.add(arch);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
    
    public List<archivo> getLogosDSEM(){
        try{  
        
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Com contorno';
            arch.link = 'https://www.donmario.com/MidiaKit2021/Logos/Institucional/ComContorno.rar';            
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'PB';
            arch2.link = 'https://www.donmario.com/MidiaKit2021/Logos/Institucional/PB.rar';            
            l_arch.add(arch2);
            
            archivo arch3 = New archivo();
            arch3.nombre = 'Sem contorno';
            arch3.link = 'https://www.donmario.com/MidiaKit2021/Logos/Institucional/SemContorno.rar';            
            l_arch.add(arch3);                        
        
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }    
    
    public List<archivo> getLogosCultivaresDSEM(){
        try{
            
            List<archivo> l_arch = New List<archivo>();                        
            
            archivo arch5 = New archivo();
            arch5.nombre = 'DM 53I54 RSF IPRO';
            arch5.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM53I54RSFIPRO.rar';            
            l_arch.add(arch5);
            
            archivo arch6 = New archivo();
            arch6.nombre = 'DM 57I52 RSF IPRO';
            arch6.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM57I52RSFIPRO.rar';            
            l_arch.add(arch6);
            
            archivo arch7 = New archivo();
            arch7.nombre = 'DM 60I63 RSF IPRO';
            arch7.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM60I63RSFIPRO.rar';            
            l_arch.add(arch7);
            
            archivo arch8 = New archivo();
            arch8.nombre = 'DM 61I59 RSF IPRO';
            arch8.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM61I59RSFIPRO.rar';            
            l_arch.add(arch8);
            
            archivo arch9 = New archivo();
            arch9.nombre = 'DM 64I63 RSF IPRO';
            arch9.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM64I63RSFIPRO.rar';            
            l_arch.add(arch9);
            
            archivo arch10 = New archivo();
            arch10.nombre = 'DM 66I68 RSF IPRO';
            arch10.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM66I68RSFIPRO.rar';            
            l_arch.add(arch10);
            
            archivo arch11 = New archivo();
            arch11.nombre = 'DM 68I69 RSF IPRO';
            arch11.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM68I69RSFIPRO.rar';            
            l_arch.add(arch11);
            
            archivo arch12 = New archivo();
            arch12.nombre = 'DM 73I75 RSF IPRO';
            arch12.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM73I75RSFIPRO.rar';            
            l_arch.add(arch12);
            
            archivo arch13 = New archivo();
            arch13.nombre = 'DM 75I74 RSF IPRO';
            arch13.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM75I74RSFIPRO.rar';            
            l_arch.add(arch13);
            
            archivo arch14 = New archivo();
            arch14.nombre = 'DM 75I76 RSF IPRO';
            arch14.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM75I76RSFIPRO.rar';            
            l_arch.add(arch14);
            
            archivo arch15 = New archivo();
            arch15.nombre = 'DM 79I81 RSF IPRO';
            arch15.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM79I81RSFIPRO.rar';            
            l_arch.add(arch15);
            
            archivo arch16 = New archivo();
            arch16.nombre = 'DM 80I79 RSF IPRO';
            arch16.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM80I79RSFIPRO.rar';            
            l_arch.add(arch16);
            
            archivo arch17 = New archivo();
            arch17.nombre = 'DM 80IX83 RSF I2X';
            arch17.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM80IX83RSFI2X.rar';            
            l_arch.add(arch17);
            
            archivo arch18 = New archivo();
            arch18.nombre = 'DM 81I84 RSF IPRO';
            arch18.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM81I84RSFIPRO.rar';            
            l_arch.add(arch18);
            
            archivo arch19 = New archivo();
            arch19.nombre = 'DM 82I78 RSF IPRO';
            arch19.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM82I78RSFIPRO.rar';            
            l_arch.add(arch19);
            
            archivo arch20 = New archivo();
            arch20.nombre = 'DM 82K84 RSF CE';
            arch20.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM82K84RSFCE.rar';            
            l_arch.add(arch20);
            
            archivo arch21 = New archivo();
            arch21.nombre = 'DM 5958 RSF IPRO';
            arch21.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM5958RSFIPRO.rar';            
            l_arch.add(arch21);
            
            archivo arch122 = New archivo();
            arch122.nombre = 'DM 6563 RSF IPRO';
            arch122.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM6563RSFIPRO.rar';            
            l_arch.add(arch122);  
            //-------------- Agregado por ygiralt@gdmseeds.com (30/11/2021) ---------------------------
            archivo arch123 = New archivo();
            arch123.nombre = 'DM 56I59 RSF IPRO';
            arch123.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM56I59RSFIPRO.rar'; 
            l_arch.add(arch123); 
            
            archivo arch124 = New archivo();
            arch124.nombre = 'DM69IX69RSF I2X';
            arch124.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM69IX69RSFI2X.rar'; 
            l_arch.add(arch124); 
            
            archivo arch125 = New archivo();
            arch125.nombre = 'DM70I71RSF IPRO';
            arch125.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM70I71RSFIPRO.rar'; 
            l_arch.add(arch125); 
            
            archivo arch126 = New archivo();
            arch126.nombre = 'DM74K75RSF CE';
            arch126.link = 'https://www.donmario.com/MidiaKit2021/Logos/Cultivar/DM74K75RSFCE.rar'; 
            l_arch.add(arch126); 
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
    
     public List<archivo> getLogosHibridosDSEM(){
        try{            
            List<archivo> l_arch = New List<archivo>();  
                archivo arch1 = New archivo();
                arch1.nombre = 'DM2830 PRO3';
                arch1.link = 'https://www.donmario.com/MidiaKit2021/Logos/Hibrido/DM2830%20PRO3.rar';            
                l_arch.add(arch1);
            
                archivo arch2 = New archivo();
                arch2.nombre = 'DM2840 PRO3';
                arch2.link = 'https://www.donmario.com/MidiaKit2021/Logos/Hibrido/DM2840%20PRO3.rar';            
                l_arch.add(arch2);
            
                return l_arch;
           }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }   
     }
        
    public List<archivo> getPlacasCampoDSEM(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Cultivar';
            arch.link = 'https://www.donmario.com/MidiaKit2021/PlacasCampo/Cultivar.rar';            
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Institucional';
            arch2.link = 'https://www.donmario.com/MidiaKit2021/PlacasCampo/Institucional.rar';            
            l_arch.add(arch2);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }         
    
    public List<archivo> getBigBagDSEM(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Etiquetas Big Bag';
            arch.link = 'https://www.donmario.com/MidiaKit2021/BigBag/EtiquetaBigBag.rar';            
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'BigBag DonMario 105 x 120 cm';
            arch2.link = 'https://www.donmario.com/MidiaKit2021/BigBag/BigBagDonmario105x120cm.pdf';            
            l_arch.add(arch2);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
    
    public List<archivo> getOutdoorDSEM(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Outdoor';
            arch.link = 'https://www.donmario.com.br/MidiaKit/Outdoor/outdoor_donmario_2022.zip';
            l_arch.add(arch);    
            
            return l_arch;                    
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }     
    
    public List<archivo> getSacariaDSEM(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Sacaria Multiplicador DONMARIO 40Kg - Conkesta 2021';
            arch.link = 'https://www.donmario.com/MidiaKit2021/Sacaria/SacariaDONMARIOConkesta2021.pdf';
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Sacaria Multiplicador DONMARIO 40Kg – Intacta 2021';
            arch2.link = 'https://www.donmario.com/MidiaKit2021/Sacaria/SacariaDONMARIOIntacta2021.pdf';            
            l_arch.add(arch2);
                        
            archivo arch3 = New archivo();
            arch3.nombre = 'Sacaria Multiplicador DONMARIO 40Kg – Intacta I2X 2021';
            arch3.link = 'https://www.donmario.com/MidiaKit2021/Sacaria/SacariaDONMARIOIntactaI2X2021.pdf';            
            l_arch.add(arch3);            
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }                 
    
    public List<archivo> getVideosDSEM(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'DM53I54';
            arch.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM53I54.mp4';
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'DM57I52';
            arch2.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM57I52.mp4';            
            l_arch.add(arch2);
                        
            archivo arch3 = New archivo();
            arch3.nombre = 'DM60I63';
            arch3.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM60I63.mp4';            
            l_arch.add(arch3);
                                    
            archivo arch4 = New archivo();
            arch4.nombre = 'DM64I63';
            arch4.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM64I63.mp4';            
            l_arch.add(arch4);

            archivo arch5 = New archivo();
            arch5.nombre = 'DM66I68';
            arch5.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM66I68.mp4';            
            l_arch.add(arch5);            
            
            archivo arch6 = New archivo();
            arch6.nombre = 'DM68I69';
            arch6.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM68I69.mp4';            
            l_arch.add(arch6);
            
            archivo arch7 = New archivo();
            arch7.nombre = 'DM73I75';
            arch7.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM73I75.mp4';            
            l_arch.add(arch7);
            
            archivo arch8 = New archivo();
            arch8.nombre = 'DM75I74';
            arch8.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM75I74.mp4';            
            l_arch.add(arch8);
            
            archivo arch9 = New archivo();
            arch9.nombre = 'DM79I81';
            arch9.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM79I81.mp4';            
            l_arch.add(arch9);
            
            archivo arch10 = New archivo();
            arch10.nombre = 'DM80I79';
            arch10.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM80I79.mp4';            
            l_arch.add(arch10);
            
            archivo arch11 = New archivo();
            arch11.nombre = 'DM80IX83';
            arch11.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM80IX83.mp4';            
            l_arch.add(arch11);
            
            archivo arch12 = New archivo();
            arch12.nombre = 'DM82I78';
            arch12.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM82I78.mp4';            
            l_arch.add(arch12);
            
            archivo arch13 = New archivo();
            arch13.nombre = 'DM82K84';
            arch13.link = 'https://www.donmario.com/MidiaKit2021/Videos/DM82K84.mp4';            
            l_arch.add(arch13);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
    
    public void getPdfUrl() {
        Http h = new Http(); 
        HttpRequest req = new HttpRequest(); 
        //Replace any spaces in extFileUrl with %20 
        urlImprimir= urlImprimir.replace(' ', '%20'); 
        //Set the end point URL
        req.setEndpoint(urlImprimir); 
        req.setMethod('GET'); 
        req.setHeader('Content-Type', 'application/pdf'); 
        req.setCompressed(true); 
        req.setTimeout(60000); 
        //Now Send HTTP Request
        HttpResponse res = h.send(req); 
        //getBodyAsBlob method was will convert the response into Blob 
        blob retFile = res.getBodyAsBlob();
    
        pdfBlob = EncodingUtil.base64Encode(retFile);         
    }
    
    public SiteUser__c getUser(){
        return logUser;
    }
    public Account getAccount(){
        return activeAccount;
    }
}
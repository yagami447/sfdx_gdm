public class aSiteMidiaKitNEOGController {
            
    public class archivo {
        @AuraEnabled
        public String nombre {get; set;}
        @AuraEnabled
        public String link {get; set;}        
    }                
    
    @AuraEnabled
    public static List<archivo> getArteResProdutividade(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Resultado Produtividade 2021 - Cerrado';
            arch.link = 'https://www.neogensementes.com.br/MidiaKit2021/ResultProdutiv/ResultadoCERRADO.pptx';            
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Resultado Produtividade 2021 - Sul';
            arch2.link = 'https://www.neogensementes.com.br/MidiaKit2021/ResultProdutiv/ResultadoSUL.pptx';            
            l_arch.add(arch2);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
    
    @AuraEnabled
    public static List<archivo> getBigBag(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'BigBag Neogen 105x120cm';
            arch.link = 'https://www.neogensementes.com.br/MidiaKit2021/BigBag/BigBagNeogen105x120cm.pdf';            
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Etiqueta Neogen Big Bag CONKESTA';
            arch2.link = 'https://www.neogensementes.com.br/MidiaKit2021/BigBag/EtiquetaNEOGENBigBagCONKESTA.pdf';            
            l_arch.add(arch2);
            
            archivo arch3 = New archivo();
            arch3.nombre = 'Etiqueta Neogen Big Bag INTACTA';
            arch3.link = 'https://www.neogensementes.com.br/MidiaKit2021/BigBag/EtiquetaNEOGENBigBagINTACTA.pdf';            
            l_arch.add(arch3);
            
            archivo arch4 = New archivo();
            arch4.nombre = 'Etiqueta Neogen Big Bag INTACTA 2XTEND';
            arch4.link = 'https://www.neogensementes.com.br/MidiaKit2021/BigBag/EtiquetaNEOGENBigBagINTACTA2XTEND.pdf';            
            l_arch.add(arch4);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
    
    @AuraEnabled
    public static List<archivo> getManualIdentVisual(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Manual de identidade visual Neogen';
            arch.link = 'https://www.neogensementes.com.br/MidiaKit2021/IdentidadeVisual/NeogenManualIdentidadeVisual.pdf';
            
            l_arch.add(arch);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }                
    
    @AuraEnabled
    public static List<archivo> getLogos(){
        try{  
        
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Institucional';
            arch.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Institucional.rar';            
            l_arch.add(arch);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }          
    
    @AuraEnabled
    public static List<archivo> getLogosCultivares(){
        try{
            
            List<archivo> l_arch = New List<archivo>();                        
            
            archivo arch5 = New archivo();
            arch5.nombre = 'Neo500';
            arch5.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo500.rar';            
            l_arch.add(arch5);
            
            archivo arch6 = New archivo();
            arch6.nombre = 'Neo530';
            arch6.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo530.rar';            
            l_arch.add(arch6);
            
            archivo arch7 = New archivo();
            arch7.nombre = 'Neo570';
            arch7.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo570.rar';            
            l_arch.add(arch7);
            
            archivo arch8 = New archivo();
            arch8.nombre = 'Neo580';
            arch8.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo580.rar';            
            l_arch.add(arch8); 
            
            archivo arch9 = New archivo();
            arch9.nombre = 'Neo590';
            arch9.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo590.rar';            
            l_arch.add(arch9);
            
            archivo arch10 = New archivo();
            arch10.nombre = 'Neo610';
            arch10.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo610.rar';            
            l_arch.add(arch10); 
            
            archivo arch11 = New archivo();
            arch11.nombre = 'Neo660';
            arch11.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo660.rar';            
            l_arch.add(arch11);
            
            archivo arch12 = New archivo();
            arch12.nombre = 'Neo680';
            arch12.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo680.rar';            
            l_arch.add(arch12); 
            
            archivo arch13 = New archivo();
            arch13.nombre = 'Neo710';
            arch13.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo710.rar';            
            l_arch.add(arch13);
            
            archivo arch14 = New archivo();
            arch14.nombre = 'Neo720';
            arch14.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo720.rar';            
            l_arch.add(arch14);
            
            archivo arch15 = New archivo();
            arch15.nombre = 'Neo740';
            arch15.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo740.rar';            
            l_arch.add(arch15);
            
            archivo arch16 = New archivo();
            arch16.nombre = 'Neo750';
            arch16.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo750.rar';            
            l_arch.add(arch16);
            
            archivo arch17 = New archivo();
            arch17.nombre = 'Neo760';
            arch17.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo760.rar';            
            l_arch.add(arch17);
            
            archivo arch18 = New archivo();
            arch18.nombre = 'Neo790';
            arch18.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo790.rar';            
            l_arch.add(arch18);
            
            archivo arch19 = New archivo();
            arch19.nombre = 'Neo850';
            arch19.link = 'https://www.neogensementes.com.br/MidiaKit2021/Logos/Cultivar/Neo850.rar';            
            l_arch.add(arch19);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }
    
    @AuraEnabled
    public static List<archivo> getPlacasCampo(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Neo530';
            arch.link = 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo530.pdf';
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Neo580';
            arch2.link = 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo580.pdf';            
            l_arch.add(arch2);
            
            archivo arch3 = New archivo();
            arch3.nombre = 'Neo590';
            arch3.link = 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo590.pdf';            
            l_arch.add(arch3);
            
            archivo arch4 = New archivo();
            arch4.nombre = 'Neo680';
            arch4.link = 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo680.pdf';            
            l_arch.add(arch4);
            
            archivo arch5 = New archivo();
            arch5.nombre = 'Neo710';
            arch5.link = 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo710.pdf';            
            l_arch.add(arch5);
            
            archivo arch6 = New archivo();
            arch6.nombre = 'Neo720';
            arch6.link = 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo720.pdf';            
            l_arch.add(arch6);
            
            archivo arch7 = New archivo();
            arch7.nombre = 'Neo740';
            arch7.link = 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo740.pdf';            
            l_arch.add(arch7);
            
            archivo arch8 = New archivo();
            arch8.nombre = 'Neo750';
            arch8.link = 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo750.pdf';            
            l_arch.add(arch8);
            
            archivo arch9 = New archivo();
            arch9.nombre = 'Neo760';
            arch9.link = 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo760.pdf';            
            l_arch.add(arch9);
            
            archivo arch10 = New archivo();
            arch10.nombre = 'Neo790';
            arch10.link = 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo790.pdf';            
            l_arch.add(arch10);
            
            archivo arch11 = New archivo();
            arch11.nombre = 'Neo850';
            arch11.link = 'https://www.neogensementes.com.br/MidiaKit2021/PlacaCampo/neo850.pdf';            
            l_arch.add(arch11);
            
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    } 
    
    @AuraEnabled
    public static List<archivo> getSacaria(){
        try{
            
            List<archivo> l_arch = New List<archivo>();
            
            archivo arch = New archivo();
            arch.nombre = 'Sacaria Neogen Conkesta 2021';
            arch.link = 'https://www.neogensementes.com.br/MidiaKit2021/Sacaria/SacariaNeogenConkesta2021.pdf';
            l_arch.add(arch);
            
            archivo arch2 = New archivo();
            arch2.nombre = 'Sacaria Neogen Intacta 2021';
            arch2.link = 'https://www.neogensementes.com.br/MidiaKit2021/Sacaria/SacariaNeogenConkesta2021.pdf';            
            l_arch.add(arch2);
                        
            archivo arch3 = New archivo();
            arch3.nombre = 'Sacaria Neogen Intacta I2X 2021';
            arch3.link = 'https://www.neogensementes.com.br/MidiaKit2021/Sacaria/SacariaNeogenConkesta2021.pdf';            
            l_arch.add(arch3);
                        
            return l_arch;
            
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,e.getLineNumber() + '\n' + e.getMessage()) );
            return null;
        }        
    }                                                                                 
}
@isTest
public class aSiteMidiaKitControllerTest {
    
    @isTest
    static void testGetManualDaMarcaBRMXMethod() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getManualDaMarcaBRMX();
        Test.stopTest();
        
        System.assertEquals(1, archivos.size());
        System.assertEquals(archivos[0].nombre, 'Manual de identidade visual Brasmax');
        System.assertEquals(archivos[0].link, 'https://www.brasmaxgenetica.com.br/MidiaKit/ManualMarca/Manual%20de%20identidade%20visual%20Brasmax.pdf');
        */
    }
    
    @isTest
    static void testGetLogosBRMXMethod() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getLogosBRMX();
        Test.stopTest();
        
        /*
        System.assertEquals(4, archivos.size());
        System.assertEquals(archivos[0].nombre, 'Branco');
        System.assertEquals(archivos[0].link, 'https://www.brasmaxgenetica.com.br/MidiaKit/Logos/Brasmax/Branco.rar');
        System.assertEquals(archivos[1].nombre, 'Banco com Contorno');
        System.assertEquals(archivos[1].link, 'https://www.brasmaxgenetica.com.br/MidiaKit/Logos/Brasmax/BrancoContorno.rar');
        System.assertEquals(archivos[2].nombre, 'Preto');
        System.assertEquals(archivos[2].link, 'https://www.brasmaxgenetica.com.br/MidiaKit/Logos/Brasmax/Preto.rar');
        System.assertEquals(archivos[3].nombre, 'Preto com Contorno');
        System.assertEquals(archivos[3].link, 'https://www.brasmaxgenetica.com.br/MidiaKit/Logos/Brasmax/PretoContorno.rar');
        */
    }
    
    @isTest
    static void testGetLogosCultivaresBRMXMethod() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getLogosCultivaresBRMX();
        Test.stopTest();
        
        /*
        System.assertEquals(40, archivos.size());
        */
    }
    
    @isTest
    static void testGetPlacaCampoInstBRMXMethod() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getPlacaCampoInstBRMX();
        Test.stopTest();
        
        System.assertEquals(1, archivos.size());
        System.assertEquals('Institucional', archivos[0].nombre);
        System.assertEquals('https://www.brasmaxgenetica.com.br/MidiaKit/Placas/Institucional/Placa%20de%20campo%20Institucional%20Brasmax_82X46CM.pdf', archivos[0].link);
        */
    }
    
    @isTest
    static void testGetPlacaCampoLanzamBRMX() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getPlacaCampoLanzamBRMX();
        Test.stopTest();
        */
        /*
        System.assertEquals(0, archivos.size());
        System.assertEquals('BRASMAX DOMÍNIO IPRO', archivos[0].nombre);
        System.assertEquals('http://www.brasmaxgenetica.com.br/MidiaKit/Placas/Especial/_PLACA%20DE%20CAMPO_DOMINIO%20-%2082X46cm.pdf', archivos[0].link);
        System.assertEquals('BRASMAX VORAZ IPRO', archivos[1].nombre);
        System.assertEquals('http://www.brasmaxgenetica.com.br/MidiaKit/Placas/Especial/_PLACA%20DE%20CAMPO_VORAZ%20-%2082X46cm.pdf', archivos[1].link);
        */
    }
    
    @isTest
    static void testGetPlacaCampoCultivaresBRMX() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getPlacaCampoCultivaresBRMX();
        Test.stopTest();
        
        System.assertEquals(23, archivos.size());
        */
    }
    
    @isTest
    static void testGetOutdoorBRMX() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getOutdoorBRMX();
        Test.stopTest();
        
        /*
        System.assertEquals(1, archivos.size());
        System.assertEquals('Outdoor Resultado de Produtividade', archivos[0].nombre);
        System.assertEquals('https://www.brasmaxgenetica.com.br/MidiaKit/OutdoorResultado.rar', archivos[0].link);
        */
    }
    
    @isTest
    static void testGetMiniOutdoorBRMX() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getMiniOutdoorBRMX();
        Test.stopTest();
        
        System.assertEquals(1, archivos.size());
        System.assertEquals('Mini Outdoor Resultado de Produtividade', archivos[0].nombre);
        System.assertEquals('https://www.brasmaxgenetica.com.br/MidiaKit/MininoutdoorResultado.rar', archivos[0].link);
        */
    }
    
    @isTest
    static void testGetPostsBRMX() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getPostsBRMX();
        Test.stopTest();
        
        System.assertEquals(2, archivos.size());
        System.assertEquals('Institucional', archivos[0].nombre);
        System.assertEquals('https://www.brasmaxgenetica.com.br/MidiaKit/Posts/Institucional.rar', archivos[0].link);
        System.assertEquals('Resultado de produtividade', archivos[1].nombre);
        System.assertEquals('https://www.brasmaxgenetica.com.br/MidiaKit/Posts/ResultadoProdutividade.rar', archivos[1].link);
        */
    }
    
    @isTest
    static void testGetManualDaMarcaDSEM() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getManualDaMarcaDSEM();
        Test.stopTest();
        
        System.assertEquals(1, archivos.size());
        System.assertEquals('Manual de identidade visual DONMARIO', archivos[0].nombre);
        System.assertEquals('https://www.donmario.com/MidiaKit/ManualMarca/Manual%20de%20identidade%20visual%20Donmario.pdf', archivos[0].link);
        */
    }
    
    @isTest
    static void testGetLogosDSEM() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getLogosDSEM();
        Test.stopTest();
        
        /*
        System.assertEquals(3, archivos.size());
        System.assertEquals('Preto e Branco', archivos[0].nombre);
        System.assertEquals('https://www.donmario.com/MidiaKit/Logos/Donmario/PB.rar', archivos[0].link);
        System.assertEquals('Com Contorno', archivos[1].nombre);
        System.assertEquals('https://www.donmario.com/MidiaKit/Logos/Donmario/COM%20CONTORNO.rar', archivos[1].link);
        System.assertEquals('Sem Contorno', archivos[2].nombre);
        System.assertEquals('https://www.donmario.com/MidiaKit/Logos/Donmario/SEM%20CONTORNO.rar', archivos[2].link);
        */
    }
    
    @isTest
    static void testGetLogosCultivaresDSEM() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getLogosCultivaresDSEM();
        Test.stopTest();
        
        /*
        System.assertEquals(19, archivos.size());
        */
    }
    @isTest
    static void testGetLogosHibridosDSEM() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getLogosHibridosDSEM();
        Test.stopTest();
        
        /*
        System.assertEquals(19, archivos.size());
        */
    }
    
    @isTest
    static void testGetPlacaCampoInstDSEM() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getPlacaCampoInstDSEM();
        Test.stopTest();
        
        System.assertEquals(1, archivos.size());
        System.assertEquals('Institucional', archivos[0].nombre);
        System.assertEquals('https://www.donmario.com/MidiaKit/Placas/Institucional/Placa%20Institucional%20DM%20-%2080x52%2C4.pdf', archivos[0].link);
        */
    }
    
    @isTest
    static void testGetPlacaCampoCultivaresDSEM() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getPlacaCampoCultivaresDSEM();
        Test.stopTest();
        
        System.assertEquals(19, archivos.size());
        */
    }
    
    @isTest
    static void testGetPlacaCampoEspecificDSEM() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();        
        List<ASiteMidiaKitController.archivo> archivos = controlador.getPlacaCampoEspecificDSEM();
        Test.stopTest();
        
        System.assertEquals(1, archivos.size());
        System.assertEquals('Especificações', archivos[0].nombre);
        System.assertEquals('https://www.donmario.com/MidiaKit/Placas/Especifica%C3%A7%C3%B5es%20Placas.jpg', archivos[0].link);
        */
    }
    
    @isTest
    static void testGetBigBagDSEM() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getBigBagDSEM();
        Test.stopTest();
        
        /*
        System.assertEquals(1, archivos.size());
        System.assertEquals('Big Bag - DONMARIO - 105x120cm', archivos[0].nombre);
        System.assertEquals('https://www.donmario.com/MidiaKit/BigBag/Big%20Bag%20-%20Donmario%20-%20105x120cm%20.pdf', archivos[0].link);
        */
    }
    
    @isTest
    static void testGetOutdoorDSEM() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getOutdoorDSEM();
        Test.stopTest();
        
        /*
        System.assertEquals(1, archivos.size());
        System.assertEquals('Outdoor Resultado de Produtividade DONMARIO', archivos[0].nombre);
        System.assertEquals('https://www.donmario.com/MidiaKit/OutdoorResultado.rar', archivos[0].link);
        */
    }
    
    @isTest
    static void testGetPostsDSEM() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getPostsDSEM();
        Test.stopTest();
        
        System.assertEquals(1, archivos.size());
        System.assertEquals('Resultado de produtividade DONMARIO', archivos[0].nombre);
        System.assertEquals('https://www.donmario.com/MidiaKit/Posts.rar', archivos[0].link);
        */
    }
    
    @isTest
    static void testGetFontesBRMX() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getFontesBRMX();
        Test.stopTest();
        
        System.assertEquals(1, archivos.size());
        System.assertEquals('Fontes Institucionais Brasmax', archivos[0].nombre);
        System.assertEquals('https://www.brasmaxgenetica.com.br/MidiaKit/FontesBrasmax.rar', archivos[0].link);
        */
    }
    
    @isTest
    static void testGetFontesDSEM() {
        ASiteMidiaKitController controlador = new ASiteMidiaKitController();
        
        /*
        Test.startTest();
        List<ASiteMidiaKitController.archivo> archivos = controlador.getFontesDSEM();
        Test.stopTest();
        
        System.assertEquals(1, archivos.size());
        System.assertEquals('Fontes Institucionais DONMARIO', archivos[0].nombre);
        System.assertEquals('https://www.donmario.com/MidiaKit/FontesDonmario.rar', archivos[0].link);
        */
    }
    
}
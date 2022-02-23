@isTest(SeeAllData=true)
public class aAppManagerTesting {
   
    // Safra: 18/19
    // Marca: BRMX
   
    @isTest
    public static void aumentarCobertura() {
        aAppManager.paraAumentarcobertura();
    }
   
    @isTest
    public static void getAnexos1Test() {
        // List<Opportunity> getAnexos1(Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getAnexos1(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getAnexosItemsByOppTest() {
        // List<OpportunityLineItem> getAnexosItemsByOpp(Id oppId)
       
        Opportunity opportunity = [select Id from Opportunity limit 1];
       
        Test.startTest();
        aAppManager.getAnexosItemsByOpp(opportunity.Id);
        Test.stopTest();
    }
   
    @isTest
    public static void completarRegistrosRebajaTest() {
       
        OpportunityLineItem opportunity = [SELECT Opportunityid FROM OpportunityLineItem  LIMIT 1];
       
        Test.startTest();
        aAppManager.completarRegistrosRebaja(opportunity.Opportunityid);
        Test.stopTest();
    }
   
   
    @isTest
    public static void getAnexos1RebajaTest() {
        // List<Opportunity> getAnexos1Rebaja(Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getAnexos1Rebaja(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void existeContratoParaCompanyTest() {
        // Boolean existeContratoParaCompany(String idUser, String comp)
       
        User user = [select Id from User limit 1];
       
        Test.startTest();
        aAppManager.existeContratoParaCompany(user.Id, 'comp');
        Test.stopTest();
    }
   
    @isTest
    public static void existeAnexoIITest() {
        // Boolean existeAnexoII(Id idCuenta, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.existeAnexoII(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void existeAnexoIVTest() {
        // Boolean existeAnexoIV(Id idCuenta, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.existeAnexoIV(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getSafraActualByAppTest() {
        // String getSafraActualByApp(String appendix)
       
        // {'A1', 'A2', 'A3', 'A4', 'A5', 'Cont', 'Estoque', 'Descarte', 'Reembalagem'}
        Test.startTest();
        for (String s : new List<String> {'A1', 'A2', 'A3', 'A4', 'A5', 'Cont', 'Estoque', 'Descarte', 'Reembalagem', 'uno'} )
            aAppManager.getSafraActualByApp(s);
        Test.stopTest();
    }
   
    @isTest
    public static void getMesesTest() {
        // List<String> getMeses()
       
        Test.startTest();
        aAppManager.getMeses();
        Test.stopTest();
    }
   
    @isTest
    public static void determinarMesStockTest() {
        // String determinarMesStock(String accId, String safra, String marca)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.determinarMesStock(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getMotivoRechazoTest() {
        // string getMotivoRechazo(Id oId)
       
        Opportunity opportunity = [select Id from Opportunity limit 1];
       
        Test.startTest();
        aAppManager.getMotivoRechazo(opportunity.Id);
        Test.stopTest();
    }
   
    @isTest
    public static void esRebajaCorrectaTest() {
        // Boolean esRebajaCorrecta(string origen, string destino)
       
        // {'C1', 'C2', 'S1', 'S2'}
        Test.startTest();
            aAppManager.esRebajaCorrecta('C1', 'C2');
            aAppManager.esRebajaCorrecta('C1', 'S1');
            aAppManager.esRebajaCorrecta('C1', 'S2');
            aAppManager.esRebajaCorrecta('C2', 'S1');
            aAppManager.esRebajaCorrecta('C2', 'S2');
            aAppManager.esRebajaCorrecta('C1', '');
            aAppManager.esRebajaCorrecta('C2', '');
            aAppManager.esRebajaCorrecta('S1', '');
            aAppManager.esRebajaCorrecta('S2', '');
        Test.stopTest();
    }
   
    @isTest
    public static void getEpocaPlantioByAppTest() {
        // string getEpocaPlantioByApp(Id appId)
       
        Opportunity opportunity = [select Id from Opportunity limit 1];
       
        Test.startTest();
        aAppManager.getEpocaPlantioByApp(opportunity.Id);
        Test.stopTest();
    }
   
    @isTest
    public static void getEpocaPlantioToA2Test() {
        // string getEpocaPlantioToA2(Id accId, String safra, String marca)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getEpocaPlantioToA2(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getCategoriaBonifAnteriorTest() {
        // String getCategoriaBonifAnterior(Id accId, String marca)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        //DSEM
        aAppManager.getCategoriaBonifAnterior(account.Id, 'BRMX');
        aAppManager.getCategoriaBonifAnterior(account.Id, 'DSEM');
        Test.stopTest();
    }
   
    @isTest
    public static void getPerfilByMultiplicadorTest() {
        // static CRM_Multiplicador__c getPerfilByMultiplicador(Id accId, String safra)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getPerfilByMultiplicador(account.Id, 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getVentasByMultiplicadorTest() {
        // List<OpportunityLineItem> getVentasByMultiplicador(Id accId, String safra, String marca)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getVentasByMultiplicador(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getTotalSemBrutaAIITest() {
        // Double getTotalSemBrutaAII(Id accId, String safra, String marca)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getTotalSemBrutaAII(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getTotalHasPlantadasAIITest() {
        // Double getTotalHasPlantadasAII(Id accId, String safra, String marca)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getTotalHasPlantadasAII(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void validarNewA2Test() {
        // Boolean validarNewA2(Id accId, String safra, String marca)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.validarNewA2(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void validarNewA3Test() {
        // Boolean validarNewA3(Id accId, String safra, String marca)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.validarNewA3(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void validarNewA4Test() {
        // Boolean validarNewA4(Id accId, String safra, String marca)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.validarNewA4(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void validarNewA5Test() {
        // Boolean validarNewA4(Id accId, String safra, String marca)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.validarNewA5(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void validarNewEstoqueTest() {
        // Boolean validarNewEstoque(Id accId, String safra, String marca)

        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.validarNewEstoque(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void valEstoque_ATest() {
        // List<OpportunityLineItem> valEstoque_A(List<OpportunityLineItem> items, String marca)

        List<OpportunityLineItem> opportunityLineItems = [select Id, Opportunity.RecordType.DeveloperName, PricebookEntry.Product2.Variedade__c from OpportunityLineItem limit 10];
       
        Test.startTest();
        aAppManager.valEstoque_A(opportunityLineItems, 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void calcularSafraAnteriorTest() {
        // String calcularSafraAnterior( String safraActual)
       
        Test.startTest();
        aAppManager.calcularSafraAnterior('18/19');
        Test.stopTest();
    }
   
    @isTest
    public static void valAnexos2_ATest() {
        // List<OpportunityLineItem> valAnexos2_A(List<OpportunityLineItem> items)

        List<OpportunityLineItem> opportunityLineItems = [select Id, Categoria_a_Rebaixar__c, Categoria__c, PricebookEntry.Product2.Variedade__c from OpportunityLineItem WHERE Categoria_a_Rebaixar__c != null limit 10];
       
        Test.startTest();
        aAppManager.valAnexos2_A(opportunityLineItems);
        Test.stopTest();
    }
   
    @isTest
    public static void valAnexos2_BTestOne() {
        // String valAnexos2_B(List<aAppendix.myOppItem> items)
       
        List<aAppendix.myOppItem> items = aAppManagerTesting.BDIOppLineItems(null, null, null, null, null, null, null, null, null);
       
        Test.startTest();
        aAppManager.valAnexos2_B(items);
        Test.stopTest();
    }
   
    @isTest
    public static void valAnexos2_BTestTwo() {
        // String valAnexos2_B(List<aAppendix.myOppItem> items)
       
        List<aAppendix.myOppItem> items = aAppManagerTesting.BDIOppLineItems('2', '1', '1', '1', '1', null, null, null, null);
       
        Test.startTest();
        aAppManager.valAnexos2_B(items);
        Test.stopTest();
    }
   
    @isTest
    public static void valAnexos2RebTest() {
        // String valAnexos2Reb(
        //      List<aAppendix.myOppItem> items, String a2Id, String epocaPlantioAII,
        //      String rebajaId, Id accId, String safra, String marca,
        //      Map<string, string> mapVariedades, Map<string, string> mapCategorias)

        Opportunity opportunity = [select Id from Opportunity limit 1];
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.valAnexos2Reb(aAppManagerTesting.BDIOppLineItems('', '', '', '', null, null, null, null, null), opportunity.Id, 'Verão',
                                    '', account.Id, '18/19', 'BRMX',
                                    new Map<String, String>(), new Map<String, String>());
       
        aAppManager.valAnexos2Reb(aAppManagerTesting.BDIOppLineItems('', '', '', '', 'a', null, null, null, null), opportunity.Id, 'Verão',
                                    '', account.Id, '18/19', 'BRMX',
                                    new Map<String, String>(), new Map<String, String>());
       
        aAppManager.valAnexos2Reb(aAppManagerTesting.BDIOppLineItems('', '', '', '', '0', null, null, null, null), '006c000000QvuExAAJ', 'Verão',
                                    '', account.Id, '18/19', 'BRMX',
                                    new Map<String, String>(), new Map<String, String>());
        Test.stopTest();
    }
   
    @isTest
    public static void valAnexos3GeneralTest() {
        // String valAnexos3General(List<aAppendix.myOppItem> items, Map<string, string> mapCategorias)
       
        Test.startTest();
        aAppManager.valAnexos3General(aAppManagerTesting.BDIOppLineItems('', '', '', '', '', null, '', '', ''), new Map<String, String>());
        aAppManager.valAnexos3General(aAppManagerTesting.BDIOppLineItems('', '', '', '', '', 'a', '1', '1', '1'), new Map<String, String>());
        aAppManager.valAnexos3General(aAppManagerTesting.BDIOppLineItems('', '', '1', '', '', '2', '1', '1', '1'), new Map<String, String>());
        aAppManager.valAnexos3General(aAppManagerTesting.BDIOppLineItems('', '', '2', '', '', '1', '2', '1', '1'), new Map<String, String>());
        aAppManager.valAnexos3General(aAppManagerTesting.BDIOppLineItems('', '', '2', '', '', '1', '1', '2', '1'), new Map<String, String>());
        aAppManager.valAnexos3General(aAppManagerTesting.BDIOppLineItems('', '', '2', '', '', '1', '1', '1', '1'), new Map<String, String>());
        Test.stopTest();
    }
   
    @isTest
    public static void valAnexos4GeneralTest() {
        // String valAnexos4General(List<aAppendix.myOppItem> items, Map<string, string> mapCategorias)
       
        Test.startTest();
        aAppManager.valAnexos4General(aAppManagerTesting.BDIOppLineItems('', '', '', '1', '', '', '', null, '1'), new Map<String, String>());
        aAppManager.valAnexos4General(aAppManagerTesting.BDIOppLineItems('', '', '', '1', '', '', '', 'a', '1'), new Map<String, String>());
        aAppManager.valAnexos4General(aAppManagerTesting.BDIOppLineItems('', '', '1', '', '', '2', '', 'a', '1'), new Map<String, String>());
        Test.stopTest();
    }

    @isTest
    public static void valAnexos5TestOne() {
        // String valAnexos5(List<aAppendix.myOppItem> items, Id accId, String safra,
        //                      String marca, String editId,
        //                      Map<string, string> mapVariedades, Map<string, string> mapCategorias)
       
        Account account = [select Id from Account limit 1];
        Opportunity opportunity = [select Id from Opportunity limit 1];
        List<aAppendix.myOppItem> items = aAppManagerTesting.BDIOppLineItems('', '', '1', '', '', '2', '', 'a', '1');
        for (aAppendix.myOppItem i : items)
            i.variedad = null;
       
        Test.startTest();
        aAppManager.valAnexos5(items, account.Id, '18/19',
                               'BRMX', opportunity.Id,
                               new Map<String, String>(), new Map<String, String>());
        aAppManager.valAnexos5(aAppManagerTesting.BDIOppLineItems('', '', '1', '', '', '2', '', 'a', '1'), account.Id, '18/19',
                               'BRMX', opportunity.Id,
                               new Map<String, String>(), new Map<String, String>());
        Test.stopTest();
    }
   
    @isTest
    public static void valAnexos5TestTwo() {
        // String valAnexos5(List<aAppendix.myOppItem> items, Id accId, String safra,
        //                      String marca, String editId,
        //                      Map<string, string> mapVariedades, Map<string, string> mapCategorias)
       
        Account account = [select Id from Account limit 1];
        Opportunity opportunity = [select Id from Opportunity limit 1];
       
        Test.startTest();
            aAppManager.valAnexos5(aAppManagerTesting.BDIOppLineItems('', '', '1', '', '', '2', '', '1', '1'), account.Id, '18/19',
                                    'BRMX', opportunity.Id, new Map<String, String>(), new Map<String, String>());
        Test.stopTest();
    }
   
    @isTest
    public static void valEstoqueTest() {
        // String valEstoque(List<aAppendix.myOppItem> items, String mes, Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.valEstoque(aAppManagerTesting.BDIOppLineItems('', '', '1', '', '', '2', '1', null, '1'), '-1', account.Id, '18/19', 'BRMX', New Map<String,String>());
        aAppManager.valEstoque(aAppManagerTesting.BDIOppLineItems('', '', '1', '', '', '2', '1', 'a', '1'), '', account.Id, '18/19', 'BRMX', New Map<String,String>());
        aAppManager.valEstoque(aAppManagerTesting.BDIOppLineItems('', '', '1', '', '', '2', '1', 'a', '1'), 'Fevereiro', account.Id, '18/19', 'BRMX', New Map<String,String>());
        Test.stopTest();
    }
   
    @isTest
    public static void saveAppend2Test() {
        // aSiteUtils.retorno saveAppend2 (List<aAppendix.myOppItem> items, String accId, String safra, String marca, String editId, SiteUser__c logUser)
       
        Account account = [select Id from Account limit 1];
        Opportunity opportunity = [select Id from Opportunity limit 1];
        SiteUser__c user = [select Id from SiteUser__c limit 1];
        List<aAppendix.myOppItem> items = aAppManagerTesting.BDIOppLineItems('', '', '1', '1', '', '2', '1', 'a', '1');
        for (aAppendix.myOppItem i : items) {
            i.area_plantada = '1';
            i.area_autorizada = '2';
        }
       
        Test.startTest();
        aAppManager.saveAppend2(aAppManagerTesting.BDIOppLineItems('', '', '1', '', '', '2', '1', '1', '1'), account.Id, '18/19', 'DSEM', opportunity.Id, user);
        aAppManager.saveAppend2(aAppManagerTesting.BDIOppLineItems('', '', '1', '', '', '2', '1', '1', '1'), account.Id, '18/19', 'BRMX', null, user);
        aAppManager.saveAppend2(items, account.Id, '18/19', 'BRMX', null, user);
        Test.stopTest();
    }
   
    @isTest
    public static void saveAppend2RebajaTest() {
        // aSiteUtils.retorno saveAppend2Rebaja(List<aAppendix.myOppItem> items, String aIIaRebajarId, String aIIaRebajarEpocaP,
        //                                      String accId, String safra, String marca, String editRebajaId,
        //                                      Map<string, string> mapVariedades, Map<string, string> mapCategorias,
        //                                      List<aAppendix.myOppItem> tmpAppItemsRebajaRemove)
       
        Account account = [select Id from Account limit 1];
        Opportunity opportunity = [select Id from Opportunity limit 1];
       
        Test.startTest();
        aAppManager.saveAppend2Rebaja(new List<aAppendix.myOppItem>(), '123', '123',
                                        account.Id, '18/19', 'DSEM', opportunity.Id,
                                        new Map<String, String>(), new Map<String, String>(),
                                        new List<aAppendix.myOppItem>());
       
        aAppManager.saveAppend2Rebaja(new List<aAppendix.myOppItem>(), '123', '123',
                                        account.Id, '18/19', 'DSEM', null,
                                        new Map<String, String>(), new Map<String, String>(),
                                        new List<aAppendix.myOppItem>());
        Test.stopTest();
    }
   
    @isTest
    public static void saveAppend3Test() {
        // aSiteUtils.retorno saveAppend3(List<aAppendix.myOppItem> items, String accId, String safra, String marca,
        //                                  String editId, SiteUser__c logUser, Map<string, string> mapCategorias)
       
        Account account = [select Id from Account limit 1];
        Opportunity opportunity = [select Id from Opportunity limit 1];
        SiteUser__c user = [select Id from SiteUser__c limit 1];
       
        Test.startTest();
        aAppManager.saveAppend3(new List<aAppendix.myOppItem>(), account.Id, '18/19', 'DSEM',
                                    opportunity.Id, user, new Map<String, String>());
       
        aAppManager.saveAppend3(new List<aAppendix.myOppItem>(), account.Id, '18/19', 'DSEM',
                                    null, user, new Map<String, String>());
        Test.stopTest();
    }
   
    @isTest
    public static void saveAppend4Test() {
        // aSiteUtils.retorno saveAppend4(List<aAppendix.myOppItem> items, String accId, String safra, String marca,
        //                                  String editId, SiteUser__c logUser, Map<string, string> mapCategorias)
       
        Account account = [select Id from Account limit 1];
        Opportunity opportunity = [select Id from Opportunity limit 1];
        SiteUser__c user = [select Id from SiteUser__c limit 1];
       
        Test.startTest();
        aAppManager.saveAppend4(new List<aAppendix.myOppItem>(), account.Id, '18/19', 'DSEM',
                                    opportunity.Id, user, new Map<String, String>());
       
        aAppManager.saveAppend4(new List<aAppendix.myOppItem>(), account.Id, '18/19', 'DSEM',
                                    null, user, new Map<String, String>());
        Test.stopTest();
    }
   
    @isTest
    public static void saveAppend5Test() {
        // aSiteUtils.retorno saveAppend5(List<aAppendix.myOppItem> items, String accId, String safra, String marca,
        //                                  String editId, SiteUser__c logUser,
        //                                  Map<string, string> mapCategorias, Map<string, string> mapVariedades,
        //                                  List<aAppendix.myOppItem> tmpAppItemsRemove)
       
        Account account = [select Id from Account limit 1];
        Opportunity opportunity = [select Id from Opportunity limit 1];
        SiteUser__c user = [select Id from SiteUser__c limit 1];
       
        Test.startTest();
        aAppManager.saveAppend5(new List<aAppendix.myOppItem>(), account.Id, '18/19', 'DSEM',
                                    opportunity.Id, user,
                                    new Map<String, String>(), new Map<String, String>(),
                                    new List<aAppendix.myOppItem>());
       
        aAppManager.saveAppend5(new List<aAppendix.myOppItem>(), account.Id, '18/19', 'DSEM',
                                    null, user,
                                    new Map<String, String>(), new Map<String, String>(),
                                    new List<aAppendix.myOppItem>());
        Test.stopTest();
    }
   
    @isTest
    public static void saveEstoqueTest() {
        // aSiteUtils.retorno saveEstoque(List<aAppendix.myOppItem> items, String accId, String safra, String marca,
        //                                  String mes, String editId, SiteUser__c logUser)
       
        Account account = [select Id from Account limit 1];
        Opportunity opportunity = [select Id from Opportunity limit 1];
        SiteUser__c user = [select Id from SiteUser__c limit 1];
       
        Test.startTest();
        aAppManager.saveEstoque(aAppManagerTesting.BDIOppLineItems('12', '12', '12', '12', '12', '12', '12', '12', '12'), account.Id, '18/19', 'DSEM',
                                    '1', opportunity.Id, user, New List<aAppendix.myOppItem>(), New Map<String,String>());
       
        aAppManager.saveEstoque(aAppManagerTesting.BDIOppLineItems(null, null, null, null, null, null, null, null, null), account.Id, '18/19', 'DSEM',
                                    '', null, user, New List<aAppendix.myOppItem>(), New Map<String,String>());
        Test.stopTest();
    }
   
    @isTest
    public static void enviarAnexoAprobacionTest() {
        // void enviarAnexoAprobacion(String idOpp)
       
        Opportunity opportunity = [select Id from Opportunity limit 1];
       
        Test.startTest();
        aAppManager.enviarAnexoAprobacion(opportunity.Id);
        Test.stopTest();
    }
   
    @isTest
    public static void updateSessionTest() {
        // void updateSession(SiteUserSession__c sesion)
       
        SiteUserSession__c user = [select Id from SiteUserSession__c limit 1];
       
        Test.startTest();
        aAppManager.updateSession(user);
        Test.stopTest();
    }
   
    @isTest
    public static void getEstadosTest() {
        // List<Estado__c> getEstados()
       
        Test.startTest();
        aAppManager.getEstados();
        Test.stopTest();
    }
   
    @isTest
    public static void getCategoriasTest() {
        // List<Categoria__c> getCategorias()
       
        Test.startTest();
        aAppManager.getCategorias();
        Test.stopTest();
    }
   
    @isTest
    public static void getVariedadesByOpp() {
        // List<Variedad__c> getVariedadesByOpp(String oppId)
       
        Opportunity opportunity = [select Id from Opportunity limit 1];
        List<String> oppIds = New List<String>();
        oppIds.add(opportunity.Id);
       
        Test.startTest();
        aAppManager.getVariedadesByOpp(oppIds);
        aAppManager.getVariedadesByOpp(null);

        Test.stopTest();
    }
   
    @isTest
    public static void getItemsToEstoqueTest() {
        // List<OpportunityLineItem> getItemsToEstoque(Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getItemsToEstoque(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getAnexosItemsToA2Test() {
        // List<OpportunityLineItem> getAnexosItemsToA2(Id accId, String safra, String marca, String epocaPlantio)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getAnexosItemsToA2(account.Id, '18/19', 'BRMX', '123');
        aAppManager.getAnexosItemsToA2(account.Id, '18/19', 'BRMX', null);
        Test.stopTest();
    }
   
    @isTest
    public static void getAnexos2Test() {
        // List<Opportunity> getAnexos2(Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getAnexos2(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getAnexos2RebajaTest() {
        // List<Opportunity> getAnexos2Rebaja(Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getAnexos2Rebaja(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getAnexos3Test() {
        // List<Opportunity> getAnexos3(Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getAnexos3(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getAnexos4Test() {
        // List<Opportunity> getAnexos4(Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getAnexos4(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getAnexos5Test() {
        // List<Opportunity> getAnexos5(Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getAnexos5(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getAnexosItemsToA3Test() {
        // List<OpportunityLineItem> getAnexosItemsToA3(Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getAnexosItemsToA3(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getAnexosItemsToA4Test() {
        // List<OpportunityLineItem> getAnexosItemsToA4(Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getAnexosItemsToA4(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void getEstoquesTest() {
        // List<Opportunity> getEstoques(Id accId, String safra, String marca)
       
        Account account = [select Id from Account limit 1];
       
        Test.startTest();
        aAppManager.getEstoques(account.Id, '18/19', 'BRMX');
        Test.stopTest();
    }
   
    @isTest
    public static void valVentasByMultiplicadorTest() {
        // List<OpportunityLineItem> valVentasByMultiplicador(List<OpportunityLineItem> items)
       
        List<OpportunityLineItem> opportunityLineItems = [select Id from OpportunityLineItem limit 10];
       
        Test.startTest();
        aAppManager.valVentasByMultiplicador(opportunityLineItems);
        Test.stopTest();
    }
   
    @isTest
    public static void valVentasByMultiplicadorClasseTest() {
        // List<OpportunityLineItem> valVentasByMultiplicadorClasse(List<OpportunityLineItem> items)
       
        List<OpportunityLineItem> opportunityLineItems = [select Id from OpportunityLineItem limit 10];
       
        Test.startTest();
        aAppManager.valVentasByMultiplicadorClasse(opportunityLineItems);
        Test.stopTest();
    }
   
    @isTest
    public static void valAnexos3_ATest() {
        // List<OpportunityLineItem> valAnexos3_A(List<OpportunityLineItem> items)
       
        List<OpportunityLineItem> opportunityLineItems = [select Id from OpportunityLineItem limit 10];
       
        Test.startTest();
        aAppManager.valAnexos3_A(opportunityLineItems);
        Test.stopTest();
    }
   
    @isTest
    public static void valAnexos4_ATest() {
        // List<OpportunityLineItem> valAnexos4_A(List<OpportunityLineItem> items)
       
        List<OpportunityLineItem> opportunityLineItems = [select Id from OpportunityLineItem limit 10];
       
        Test.startTest();
        aAppManager.valAnexos4_A(opportunityLineItems);
        Test.stopTest();
    }
   
    @isTest
    public static void valAnexos4_BTest() {
        // String valAnexos4_B(List<aAppendix.myOppItem> items)
       
        Test.startTest();
        aAppManager.valAnexos4_B(new List<aAppendix.myOppItem>());
        Test.stopTest();
    }
   
    @isTest
    public static void enviarParaAprobacionTest() {
        // void enviarParaAprobacion(Opportunity oportunidad)
       
        Opportunity opportunity = [select Id, OwnerId from Opportunity limit 1];
       
        Test.startTest();
        aAppManager.enviarParaAprobacion(opportunity);
        Test.stopTest();
    }
   
    @isTest
    public static void validarRebajaAnexoITest() {
        // Boolean validarRebajaAnexoI(List<OpportunityLineItem> items, Opportunity theOpp)
       
        List<OpportunityLineItem> opportunityLineItems = [select Id from OpportunityLineItem limit 10];
        Opportunity opportunity = [select Id from Opportunity limit 1];
       
        Test.startTest();
        aAppManager.validarRebajaAnexoI(opportunityLineItems, opportunity);
        Test.stopTest();
    }
   
    public static List<aAppendix.myOppItem> BDIOppLineItems(
        String area_plantada, String area_autorizada,
        String sem_bruta, String descarte, String sem_rebajada,
        String sem_beneficiada, String sem_aprobada, String sem_comer,
        String sem_uso_propio) {
        List<OpportunityLineItem> opportunityLineItems = [
            select Id, Variedade_Prod__c, Categoria__c, Expec_Prod_Bruta__c, Lote_Rebajado__c, Area__c, Estado_de_Produccion__c, Categoria_a_Rebaixar__c,
            PricebookEntry.Product2.Variedade__c, PricebookEntry.Product2.Variedade__r.Nombre_de_Registro__c, PricebookEntry.Product2.UNIDADE__c,
            OpportunityId, Opportunity.Epoca_de_Plantio__c, Semente_comercializada__c,
            Categoria__r.Name, Estado_de_Produccion__r.Name, Categoria_a_Rebaixar__r.Name
            from OpportunityLineItem limit 10
        ];
        List<aAppendix.myOppItem> items = new List<aAppendix.myOppItem>();
        for (OpportunityLineItem o : opportunityLineItems) {
            aAppendix.myOppItem  i = aAppendix.armarWrapper(o);
            i.area_plantada = area_plantada;
            i.area_autorizada = area_autorizada;
            i.sem_bruta = sem_bruta;
            i.descarte = descarte;
            i.sem_rebajada = sem_rebajada;
            i.sem_beneficiada =sem_beneficiada;
            i.sem_aprobada =sem_aprobada;
            i.sem_comer = sem_comer;
            i.sem_uso_propio = sem_uso_propio;
            items.add(i);
        }
   
        return items;
    }
   
}
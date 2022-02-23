/**
* @name TestDataFactory
* @author Jhonny Peroza
* updated 19-11-2021
*/
@IsTest
public class TestDataFactory {

    public static List<Estado__c> createEstados(Integer num){
        
        List<Estado__c> statesList = new List<Estado__c>();

        for(Integer i=0;i<num;i++){
            Estado__c newState = new Estado__c();
            newState.Name = 'ESTADO ' + i;
            statesList.add(newState);
        }
        insert statesList;
        return statesList;
    }

    public static List<Macrorregi_o_de_Vendas__c> createMacros(Integer num){
        
        List<Macrorregi_o_de_Vendas__c> macroList = new List<Macrorregi_o_de_Vendas__c>();

        for(Integer i=0;i<num;i++){
            Macrorregi_o_de_Vendas__c newMacro = new Macrorregi_o_de_Vendas__c();
            newMacro.Name = 'MACRO REGION ' + i;
            macroList.add(newMacro);
        }
        insert macroList;
        return macroList;
    }

    public static List<Microrregi_o_de_Vendas__c> createMicros(Integer num){
        
        List<Microrregi_o_de_Vendas__c> microList = new List<Microrregi_o_de_Vendas__c>();

        for(Integer i=0;i<num;i++){
            Microrregi_o_de_Vendas__c newMicro = new Microrregi_o_de_Vendas__c();
            newMicro.Name = 'MICRO REGION ' + i;
            microList.add(newMicro);
        }
        insert microList;
        return microList;
    }
    
    public static List<Regiao__c> createRegions(Integer num){
        
        List<Regiao__c> regionsList = new List<Regiao__c>();

        for(Integer i=0;i<num;i++){
            Regiao__c newRegions = new Regiao__c();
            newRegions.Name = 'REGION 1';
            newRegions.Region_Comercial__c = 'REGION 1';
            regionsList.add(newRegions);
        }
        insert regionsList;
        return regionsList;
    }
    
    public static List<Account> createAccounts(List<Regiao__c> regions){
        
        List<Account> accountsList = new List<Account>();

        Integer i=0;

        for(Regiao__c a : regions){
            i=i+1;
            Account newAccount = new Account();
            newAccount.Name = 'ACCOUNT ' + i;
            newAccount.Region__c = a.Id;
            newAccount.Supervisor__c = UserInfo.getUserId();
            newAccount.Region__c = regions[0].Id;
            newAccount.Responsavel__c = '104 - Otavio Gorni';
            newAccount.Reponsavel_DSEM__c = '217 - Cristian Pirolli';
            newAccount.Responsavel_NEOGEN__c = '020 - Eduardo L. da Silva';
            newAccount.Responsavel_DAGMA__c = '033 - Gustavo Suzano';
            newAccount.Responsavel_LICENCAS__c = '124 - Thiago Schwonka';
            accountsList.add(newAccount);
        }
        insert accountsList;
        return accountsList;
    }

    public static List<Negocio_por_Conta__c> createBusiness(List<Account> accounts){
        
        List<Negocio_por_Conta__c> businessList = new List<Negocio_por_Conta__c>();

        Integer i=0;

        for(Account a : accounts){
            i=i+1;
            Negocio_por_Conta__c newBusiness = new Negocio_por_Conta__c();
            newBusiness.Name = 'BUSINESS ' + i;
            newBusiness.Conta__c = a.Id;
            newBusiness.Region_Comercial__c = 'REGION 1';
            newBusiness.Marca__c = 'BRMX';
            newBusiness.Cultura__c = 'MILHO';
            newBusiness.Supervidor__c = UserInfo.getUserId();
            businessList.add(newBusiness);
        }
        insert businessList;
        return businessList;
    }

    public static List<Variedad__c> createVariety(Integer num){
        
        List<Variedad__c> varietyList = new List<Variedad__c>();

        for(Integer i=0;i<num;i++){
            Variedad__c newVariety = new Variedad__c();
            newVariety.Name = 'VARIEDAD ' + i;
            newVariety.Nombre_de_Registro__c  = 'VARIEDAD ' + i;
            newVariety.Marca_comercial__c = 'Brasmax';
            newVariety.Ativa__c = true;
            newVariety.Regiao_disponivel_para_venda_basica__c = 'REGION 1;REGION 2;CERRADO';
            newVariety.Disponivel_para_venda_basica__c = true;
            newVariety.Cultura__c = 'MILHO';
            varietyList.add(newVariety);
        }
        insert varietyList;
        return varietyList;
    }

    // Crear lista de Opportunidades

    public static List<Opportunity> createOpportunities(List<Account> accountList, Integer num){
        
        List<Opportunity> opportunityList = new List<Opportunity>();

        Id queryRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Stock Multiplicadores').getRecordTypeId();

        Id priceBookId = Test.getStandardPricebookId();

        for(Integer i=0;i<num;i++) {
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.AccountId = accountList[0].Id;
            newOpportunity.Name = 'OPPORTUNITY ' + i; 
            newOpportunity.StageName = 'Aprobada';
            newOpportunity.CloseDate = System.Today();
            newOpportunity.Marca__c = 'BRMX';
            newOpportunity.Safra__c = '20/21';
            newOpportunity.Region__c = 'REGION 1';
            newOpportunity.Activa__c = true;
            newOpportunity.Pricebook2Id = priceBookId;
            newOpportunity.RecordTypeId = queryRecordType;
            newOpportunity.Confirmado__c = false;
            opportunityList.add(newOpportunity);
        }
        insert opportunityList;
        return opportunityList;
    }

    public static List<Opportunity> createOpportunitiesTrigger(List<Account> accountList, Integer num){
        
        List<Opportunity> opportunityList = new List<Opportunity>();

        Id queryRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Stock_Multiplicadores').getRecordTypeId();

        Id priceBookId = Test.getStandardPricebookId();

        for(Integer i=0;i<num;i++) {
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.AccountId = accountList[0].Id;
            newOpportunity.Name = 'OPPORTUNITY ' + i; 
            newOpportunity.StageName = 'Edición';
            newOpportunity.CloseDate = System.Today();
            newOpportunity.Marca__c = 'BRMX';
            newOpportunity.Safra__c = '21/22';
            newOpportunity.Region__c = 'REGION 1';
            newOpportunity.Activa__c = true;
            newOpportunity.Pricebook2Id = priceBookId;
            newOpportunity.RecordTypeId = queryRecordType;
            opportunityList.add(newOpportunity);
        }
        insert opportunityList;
        return opportunityList;
    }

    public static List<Opportunity> createOpportunitiesWithBusinesss(List<Campaign> campaignList, List<Negocio_por_Conta__c> negocioList, List<Account> accountList, Integer num){
        
        List<Opportunity> opportunityList = new List<Opportunity>();

        Id queryRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venda_da_Hibrido').getRecordTypeId();

        Id priceBookId = Test.getStandardPricebookId();

        for(Integer i=0;i<num;i++) {
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.Name = 'OPPORTUNITY ' + i; 
            newOpportunity.StageName = 'Edición';
            newOpportunity.CloseDate = System.Today();
            newOpportunity.Safra__c = '21/22';
            newOpportunity.Region__c = 'REGION 1';
            newOpportunity.Tipo_de_Cultivares__c = 'Lançamentos';
            newOpportunity.Activa__c = true;
            newOpportunity.Pricebook2Id = priceBookId;
            newOpportunity.RecordTypeId = queryRecordType;
            newOpportunity.Negocio_por_Conta__c = negocioList[0].Id;
            newOpportunity.AccountId= negocioList[0].Conta__c;
            newOpportunity.Marca__c = negocioList[0].Marca__c;
            newOpportunity.CampaignId = campaignList[0].Id;
            opportunityList.add(newOpportunity);
        }
        insert opportunityList;
        return opportunityList;
    }

    public static List<Campaign> createCampaign(List<Account> accountList, Integer num) {

        List<Campaign> campaignList = new List<Campaign>();

        Id queryRecordType = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Venda_de_Basica').getRecordTypeId();

        Id priceBookId = Test.getStandardPricebookId();

        for(Integer i=0;i<num;i++){
            Campaign newCampaign = new Campaign();
            newCampaign.Status = 'En curso';
            newCampaign.Name = 'Campaña VB - 21/22 - BRMX -';
            newCampaign.Epoca_de_Producao__c = 'Inverno';
            newCampaign.Cultura__c = 'Milho';
            newCampaign.Region_VB__c = 'REGION 1;REGION 2;CERRADO'; 
            newCampaign.StartDate = system.today();
            newCampaign.EndDate = system.today();
            newCampaign.IsActive = true;
            newCampaign.Lista_de_precios__c = priceBookId;
            newCampaign.Marca__c = 'BRMX';
            newCampaign.Safra__c = '21/22';
            newCampaign.RecordTypeId = queryRecordType;
            campaignList.add(newCampaign);
        }
        insert campaignList;
        return campaignList;

    }

    public static List<Campaign> createCampaignWithAccount(List<Account> accountList, Integer num) {

        List<Campaign> campaignList = new List<Campaign>();

        Id queryRecordType = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Venda_de_Basica').getRecordTypeId();

        Id priceBookId = Test.getStandardPricebookId();

        for(Integer i=0;i<num;i++){
            Campaign newCampaign = new Campaign();
            newCampaign.Status = 'En curso';
            newCampaign.Name = 'Campaña VB - 21/22 - BRMX -';
            newCampaign.Epoca_de_Producao__c = 'Inverno';
            newCampaign.Cultura__c = 'Milho';
            newCampaign.Region_VB__c = 'REGION 1;REGION 2;CERRADO'; 
            newCampaign.StartDate = system.today();
            newCampaign.EndDate = system.today();
            newCampaign.IsActive = true;
            newCampaign.Lista_de_precios__c = priceBookId;
            newCampaign.Marca__c = 'BRMX';
            newCampaign.Safra__c = '21/22';
            newCampaign.RecordTypeId = queryRecordType;
            newCampaign.Conta__c = accountList[0].Id;
            campaignList.add(newCampaign);
        }
        insert campaignList;
        return campaignList;

    }

    public static List<Opportunity> createPedidos(List<Campaign> campaignList, List<Account> accountList, Integer num){
        
        List<Opportunity> opportunityList = new List<Opportunity>();

        Id queryRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venda da Hibrido').getRecordTypeId();

        Id priceBookId = Test.getStandardPricebookId();

        for(Integer i=0;i<num;i++) {
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.AccountId = accountList[0].Id;
            newOpportunity.Name = 'OPPORTUNITY ' + i; 
            newOpportunity.StageName = 'Edición';
            newOpportunity.CloseDate = System.Today();
            newOpportunity.Marca__c = 'BRMX';
            newOpportunity.Safra__c = '21/22';
            newOpportunity.Region__c = 'REGION 1';
            newOpportunity.Activa__c = true;
            newOpportunity.Pricebook2Id = priceBookId;
            newOpportunity.RecordTypeId = queryRecordType;
            newOpportunity.CampaignId = campaignList[0].Id;
            opportunityList.add(newOpportunity);
        }
        insert opportunityList;
        return opportunityList;
    }
    
    public static List<Categoria__c> createCategory(Integer num){
        
        List<Categoria__c> categoryList = new List<Categoria__c>();

        for(Integer i=0;i<num;i++){
            Categoria__c newCategory = new Categoria__c();
            newCategory.Name = 'CATEGORY ' + i;
            categoryList.add(newCategory);
        }
        insert categoryList;
        return categoryList;
    }

    public static List<Product2> createProduct(Integer num, List<Categoria__c> categories, List<Variedad__c> varietys){
        
        List<Product2> productList = new List<Product2>();

        for(Integer i=0;i<num;i++) {
            Product2 newProduct = new Product2();
            newProduct.Categ__c = categories[0].Id;
            newProduct.ProductCode = 'CODE00' + i;
            newProduct.Name = 'PRODUCT ' + i;
            newProduct.Variedad__c = varietys[0].Id;
            newProduct.Variedade__c = varietys[0].Id;
            newProduct.Variedade_Licenciada__c = varietys[0].Id;
            newProduct.Obtentor__c = 'Bayer';
            productList.add(newProduct);
        }
        insert productList;
        return productList;
    }

    public static List<PricebookEntry> createPriceBookEntry(Integer num, List<Product2> products){

        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        
        Id estandarPriceBookId = Test.getStandardPricebookId();

        PricebookEntry newPriceBookEntryStandar = new PricebookEntry();
        newPriceBookEntryStandar.Pricebook2Id = estandarPriceBookId;
        newPriceBookEntryStandar.Product2Id = products[0].Id; 
        newPriceBookEntryStandar.UnitPrice = 1.00;
        newPriceBookEntryStandar.isActive = true;
        insert newPriceBookEntryStandar;

        PriceBook2 newPriceBook2 = new Pricebook2();
        newPriceBook2.Name = 'CUSTOM PRICEBOOK';
        newPriceBook2.isActive = true;
        insert newPriceBook2;

        List<PriceBook2> priceBook2IdList = [SELECT Id FROM PriceBook2];

        for(Product2 pro : Products) {
            PricebookEntry newPriceBookEntry = new PricebookEntry();
            newPriceBookEntry.Product2Id = pro.Id; 
            newPriceBookEntry.Pricebook2Id = priceBook2IdList[0].Id;
            newPriceBookEntry.IsActive = true;
            newPriceBookEntry.UnitPrice = 1.00;
            priceBookEntryList.add(newPriceBookEntry);
        }
        insert priceBookEntryList;
        return priceBookEntryList;
    }

    public static List<OpportunityLineItem> createOpportunityLineItems(List<Opportunity> opportunities, List<Product2> products){
        
        List<OpportunityLineItem> opportunityLineItemsList = new List<OpportunityLineItem>();

        List<PricebookEntry> priceBookEntryList = [SELECT Id FROM PriceBookEntry];

        Integer i = 0;

        for(Product2 pro : products) {
            i=i+1;
            OpportunityLineItem newOpportunityLineItem = new OpportunityLineItem();
            newOpportunityLineItem.OpportunityId = opportunities[0].Id;
            newOpportunityLineItem.Product2Id = pro.Id;
            newOpportunityLineItem.PricebookEntryId = priceBookEntryList[0].Id;
            newOpportunityLineItem.Variedad__c = pro.Variedad__c;
            newOpportunityLineItem.Quantity = 1;
            newOpportunityLineItem.Bls_devolucion__c = 1;
            newOpportunityLineItem.UnitPrice = 1.00;
            opportunityLineItemsList.add(newOpportunityLineItem);
        }

        insert opportunityLineItemsList;
        return opportunityLineItemsList;
    }

    // Crear lista de Versiones de Contenido para Documentos y Archivos

    public static List<ContentVersion> createContentVersion(Integer num) {

        List<ContentVersion> contentVersionList = new List<ContentVersion>();

        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the');

        for(Integer i=0;i<num;i++){
            ContentVersion newContentVersion = new ContentVersion();
            newContentVersion.Title = 'CONTENT VERSION ' + i + '.txt';
            newContentVersion.PathOnClient = 'CONTENT VERSION ' + i + '.txt';
            newContentVersion.VersionData = bodyBlob;
            newContentVersion.Origin = 'C';
            newContentVersion.Show_File__c = true;
            contentVersionList.add(newContentVersion);
        }
        insert contentVersionList;
        return contentVersionList;
    }

    public static List<Attachment_Content__c> createAttachmentContent(Integer num, List<CRM_Calendario_de_Eventos__c> crmEventosList) {

        List<Attachment_Content__c> attachmentContentList = new List<Attachment_Content__c>();

        for(Integer i=0;i<num;i++){
            Attachment_Content__c newAttachmentContent = new Attachment_Content__c();
            newAttachmentContent.CRM_Calendario_de_Eventos__c = crmEventosList[0].Id;
            newAttachmentContent.Show_File__c = true;
            attachmentContentList.add(newAttachmentContent);
        }
        insert attachmentContentList;
        return attachmentContentList;
    }

    // Crear lista de Usuarios de Sitio Web para Apis de Stock

    public static List<SiteUser__c> createSiteUser(Integer num) {

        List<SiteUser__c> siteUserList = new List<SiteUser__c>();

        for(Integer i=0;i<num;i++){
            SiteUser__c newSiteUser = new SiteUser__c();
            newSiteUser.Email__c = 'jhonny.peroza@cloudgaia.com';
            newSiteUser.Password__c = '123456';
            siteUserList.add(newSiteUser);
        }
        insert siteUserList;
        return siteUserList;
    }

    // Crear lista de Sesiones de Usuario de Sitio Web para Apis de Stock

    public static List<SiteUserSession__c> createSessionUser(Integer num, List<SiteUser__c> siteUserList) {

        List<SiteUserSession__c> sessionUserList = new List<SiteUserSession__c>();

        for(Integer i=0;i<num;i++){
            SiteUserSession__c newSessionUser = new SiteUserSession__c();
            newSessionUser.SiteUser__c = siteUserList[0].Id;
            newSessionUser.Marca__c = 'BRMX';
            newSessionUser.Safra__c = '21/22';
            sessionUserList.add(newSessionUser);
        }
        insert sessionUserList;
        return sessionUserList;
    }

    // Crear lista de eventos

    public static List<CRM_Calendario_de_Eventos__c> createEventos(Integer num, List<Account> accountList, String nombreEvento) {

        List<CRM_Calendario_de_Eventos__c> eventoList = new List<CRM_Calendario_de_Eventos__c>();

        Id queryRecordType = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByName().get(nombreEvento).getRecordTypeId();

        for(Integer i=0;i<num;i++){
            CRM_Calendario_de_Eventos__c newEvento = new CRM_Calendario_de_Eventos__c();
            newEvento.RecordTypeId = queryRecordType;
            newEvento.Data_e_horario_inicio__c = system.today();
            newEvento.Data_e_horario_termino__c = system.today();
            newEvento.Cuenta__c = accountList[0].Id;
            newEvento.Marca__c = 'NEOG';
            newEvento.Safra__c = '20/21';
            newEvento.Data__c = system.today();
            newEvento.Revenda__c = accountList[0].Id;
            newEvento.Fase__c = 'Edição';
            newEvento.Realizado_por__c = 'Multiplicador';
            newEvento.Evento__c = 'Treinamento';
            eventoList.add(newEvento);
        }
        insert eventoList;
        return eventoList;
    }

    // Crear lista de productos de eventos

    public static List<CRM_Detalle_Calendario_de_eventos__c> createCalendarioEventos(Integer num, List<CRM_Calendario_de_Eventos__c> eventoList, List<Product2> productList) {

        List<CRM_Detalle_Calendario_de_eventos__c> calendarList = new List<CRM_Detalle_Calendario_de_eventos__c>();

        for(Integer i=0;i<num;i++){
            CRM_Detalle_Calendario_de_eventos__c newCalendar = new CRM_Detalle_Calendario_de_eventos__c();
            newCalendar.CRM_Calendario_de_eventos__c = eventoList[0].Id;
            newCalendar.Cultivar__c = productList[0].Id;
            newCalendar.Data_de_colheita__c = system.today();
            newCalendar.Data_de_plantio__c = system.today();
            newCalendar.Obtentor__c = productList[0].Obtentor__c;   
            newCalendar.Area_plantada__c = 2.50;
            newCalendar.Area_Colhida__c = 4.10;
            newCalendar.Volume_Doado__c = 6.60;
            newCalendar.Produtividade__c = 8.40;
            calendarList.add(newCalendar);
        }
        insert calendarList;
        return calendarList;
    }

    public static List<User> createUser(Integer num) {

        List<User> usersList = new List<User>();

        Profile profileIdSupervisor = [SELECT Id FROM Profile WHERE Name = 'Supervisor Administrativo' LIMIT 1];

        for(Integer i=0;i<num;i++){
            User newUser = new User();
            newUser.ManagerId = UserInfo.getUserId();
            newUser.Username = 'jhonnyperoza@gmail.com';
            newUser.LastName = 'Peroza';
            newUser.Email = 'jhonny.peroza@gmail.com';
            newUser.Alias = 'JhonnyPe';
            newUser.TimeZoneSidKey = 'GMT';
            newUser.LocaleSidKey = 'en_US';
            newUser.EmailEncodingKey = 'UTF-8';
            newUser.ProfileId = profileIdSupervisor.Id;
            newUser.LanguageLocaleKey = 'en_US';
            usersList.add(newUser);
        }
        insert usersList;
        return usersList;

    }

    public static List<Requisicao_de_compra__c> createRequisitions(Integer num, List<Account> accountList){
        
        List<Requisicao_de_compra__c> requisitionsList = new List<Requisicao_de_compra__c>();

        for(Integer i=0;i<num;i++){
            Requisicao_de_compra__c newRequisitions = new Requisicao_de_compra__c();
            newRequisitions.Multiplicador__c = accountList[0].Id;
            newRequisitions.Tipo__c = 'Multiplicador';
            newRequisitions.Safra__c = '20/21';
            newRequisitions.Estado__c = 'Edição';
            newRequisitions.Marca__c = 'BRMX';
            newRequisitions.Regiao_comercial__c = 'REGION 1';
            newRequisitions.OwnerId = UserInfo.getUserId();
            requisitionsList.add(newRequisitions);
        }
        insert requisitionsList;
        return requisitionsList;
    }

    public static List<Produto_de_Requisicao__c> createRequisitionsProducts(List<Requisicao_de_compra__c> requisitions, List<Variedad__c> variety){

        List<Produto_de_Requisicao__c> requisitionsProductsList = new List<Produto_de_Requisicao__c>();

        for(Requisicao_de_compra__c req : requisitions){
            for(Variedad__c var : variety) {
                Produto_de_Requisicao__c newRequisitionsProducts = new Produto_de_Requisicao__c();
                newRequisitionsProducts.Quantidade__c = 100;
                newRequisitionsProducts.Requisicao_de_compra__c = req.Id;
                newRequisitionsProducts.Variedad__c = var.Id;
                requisitionsProductsList.add(newRequisitionsProducts);
            }
        }

        insert requisitionsProductsList;
        return requisitionsProductsList;
    }

    public static List<Configuracion_BMX__c> createConfiguracion(Integer num) {

        List<Configuracion_BMX__c> configuracionList = new List<Configuracion_BMX__c>();

        for(Integer i=0;i<num;i++){
            Configuracion_BMX__c newConfiguracion = new Configuracion_BMX__c();
            newConfiguracion.PM_Estoque_Dia_Desde__c = 10;
            newConfiguracion.PM_Estoque_Dia_Hasta__c = 20;
            newConfiguracion.Name = 'Facturacion';
            configuracionList.add(newConfiguracion);
        }
        insert configuracionList;
        return configuracionList;
    }

    // Objetos para CRM 

    public static List<Resumo_da_conta__c> createCRM(Integer num, List<Account> accountList) {

        List<Resumo_da_conta__c> crmList = new List<Resumo_da_conta__c>();

        for(Integer i=0;i<num;i++){
            Resumo_da_conta__c newCRM = new Resumo_da_conta__c();
            newCRM.Name = 'CRM '+ i;
            newCRM.Fase__c = 'Edição';
            newCRM.Marca__c = 'BRMX';
            newCRM.Safra__c = '20/21';
            newCRM.Multiplicador__c = accountList[0].Id;
            crmList.add(newCRM);
        }
        insert crmList;
        return crmList;
    }

    public static List<Estado_para_CRM__c> createEstadoCRM(Integer num, List<Resumo_da_conta__c> crmList) {

        List<Estado_para_CRM__c> crmEstadoList = new List<Estado_para_CRM__c>();

        for(Integer i=0;i<num;i++){
            Estado_para_CRM__c newCRMEstado = new Estado_para_CRM__c();
            newCRMEstado.Name = 'ESTADO CRM ' + i;
            newCRMEstado.Estado__c = 'Acre (AC)';
            newCRMEstado.Percentagem_de_venda__c = 100.00;
            newCRMEstado.CRM__c = crmList[0].Id;
            crmEstadoList.add(newCRMEstado);
        }
        insert crmEstadoList;
        return crmEstadoList;
    }

    public static List<Item_de_resumo_da_conta__c> createItemCRM(Integer num, List<Resumo_da_conta__c> crmList, List<Product2> productList) {

        List<Item_de_resumo_da_conta__c> crmItemList = new List<Item_de_resumo_da_conta__c>();

        for(Integer i=0;i<num;i++){
            Item_de_resumo_da_conta__c newCRMItem = new Item_de_resumo_da_conta__c();
            newCRMItem.Name = 'ITEM CRM ' + i;
            newCRMItem.Obtentor__c = 'ADVANTA';
            newCRMItem.Porcentagem__c = 100.00;
            newCRMItem.Produto__c = productList[0].Id;
            newCRMItem.Resumo_da_conta__c = crmList[0].Id;
            crmItemList.add(newCRMItem);
        }
        insert crmItemList;
        return crmItemList;
    }

}
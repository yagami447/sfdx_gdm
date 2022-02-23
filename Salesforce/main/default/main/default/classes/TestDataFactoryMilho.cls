/**
* @name TestDataFactoryMilho
* @author Jhonny Peroza
* updated 21-10-2021
*/
@IsTest
public class TestDataFactoryMilho {

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
            newRegions.Name = 'REGION ' + i;
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
            newAccount.Marca__c = 'BRMX';
            newAccount.Reponsavel_DSEM__c = '061 - Fernando Frehner';
            newAccount.Responsavel_NEOGEN__c = '020 - Eduardo L. da Silva';
            newAccount.Responsavel__c = '066 - Marcelo Steffen';
            newAccount.Responsavel_DAGMA__c = '033 - Gustavo Suzano';
            newAccount.Responsavel_LICENCAS__c = '124 - Thiago Schwonka';
            newAccount.OwnerId = UserInfo.getUserId();
            newAccount.Supervisor__c = UserInfo.getUserId();
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
            newBusiness.Marca__c = 'NEOG';
            newBusiness.Cultura__c = 'MILHO';
            newBusiness.Supervidor__c = UserInfo.getUserId();
            businessList.add(newBusiness);
        }
        insert businessList;
        return businessList;
    }

    public static List<Contract> createContract(List<Negocio_por_Conta__c> business){
        
        List<Contract> contractList = new List<Contract>();

        List<RecordType> queryRecord = [SELECT Id, Name FROM RecordType WHERE Name = 'Macro Milho' LIMIT 1];

        for(Negocio_por_Conta__c a : business){
            Contract newContract = new Contract();
            newContract.RecordTypeId = queryRecord[0].Id;
            newContract.AccountId = a.Conta__c;
            newContract.Negocio__c = a.Id;
            newContract.Status = 'Edição';
            newContract.Tipo_de_Assinatura__c = 'Manual';
            newContract.Sociedad__c = 'BRMX';
            newContract.Comercializa_paraguai__c = false;
            newContract.OwnerId = UserInfo.getUserId();
            newContract.Gerenciador__c = UserInfo.getUserId();
            contractList.add(newContract);
        }
        insert contractList;
        return contractList;
    }

    public static List<Variedad__c> createVariety(Integer num){
        
        List<Variedad__c> varietyList = new List<Variedad__c>();

        for(Integer i=0;i<num;i++){
            Variedad__c newVariety = new Variedad__c();
            newVariety.Name = 'VARIEDAD ' + i;
            newVariety.Marca_comercial__c = 'NEOGEN';
            newVariety.Ativa__c = true;
            newVariety.Regiao_disponivel_para_venda_basica__c = 'REGION 1;REGION 2;CERRADO';
            newVariety.Disponivel_para_venda_basica__c = true;
            newVariety.Cultura__c = 'MILHO';
            varietyList.add(newVariety);
        }
        insert varietyList;
        return varietyList;
    }

    public static List<Requisicao_de_compra__c> createRequisitions(List<Negocio_por_Conta__c> negocios){
        
        List<Requisicao_de_compra__c> requisitionsList = new List<Requisicao_de_compra__c>();

        Id queryRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByName().get('Milho') .getRecordTypeId();

        for(Negocio_por_Conta__c a : negocios){
            Requisicao_de_compra__c newRequisitions = new Requisicao_de_compra__c();
            newRequisitions.Tipo__c = 'Gerente Comercial';
            newRequisitions.RecordTypeId = queryRecordType;
            newRequisitions.Safra__c = '20/21';
            newRequisitions.Estado__c = 'Edição';
            newRequisitions.Negocio__c = a.Id;
            newRequisitions.Marca__c = 'NEOG';
            newRequisitions.Regiao_comercial__c = 'REGION 1';
            newRequisitions.OwnerId = UserInfo.getUserId();
            requisitionsList.add(newRequisitions);
        }
        insert requisitionsList;
        return requisitionsList;
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

    public static List<User> createUserRequisition(Integer num) {

        List<User> usersList = new List<User>();

        Profile profileIdSupervisor = [SELECT Id FROM Profile WHERE Name = 'Supervisor Administrativo' LIMIT 1];

        for(Integer i=0;i<num;i++){
            User newUser = new User();
            newUser.ManagerId = UserInfo.getUserId();
            newUser.Username = 'jhonnyperoza26@gmail.com';
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

    public static List<Requisicao_de_compra__c> createRequisitionsMultiplicador(List<Negocio_por_Conta__c> negocios){
        
        List<Requisicao_de_compra__c> requisitionsList = new List<Requisicao_de_compra__c>();

        Id queryRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByName().get('Milho') .getRecordTypeId();

        for(Negocio_por_Conta__c a : negocios){
            Requisicao_de_compra__c newRequisitions = new Requisicao_de_compra__c();
            newRequisitions.Tipo__c = 'Multiplicador';
            newRequisitions.Multiplicador__c = a.Conta__c;
            newRequisitions.RecordTypeId = queryRecordType;
            newRequisitions.Safra__c = '20/21';
            newRequisitions.Estado__c = 'Edição';
            newRequisitions.Negocio__c = a.Id;
            newRequisitions.Marca__c = 'NEOG';
            newRequisitions.Regiao_comercial__c = 'REGION 1';
            newRequisitions.OwnerId = UserInfo.getUserId();
            requisitionsList.add(newRequisitions);
        }
        insert requisitionsList;
        return requisitionsList;
    }

    public static List<Requisicao_de_compra__c> createRequisitionsAprovada(List<Negocio_por_Conta__c> negocios){
        
        List<Requisicao_de_compra__c> requisitionsList = new List<Requisicao_de_compra__c>();

        Id queryRecordType = Schema.SObjectType.Requisicao_de_compra__c.getRecordTypeInfosByName().get('Milho') .getRecordTypeId();

        for(Negocio_por_Conta__c a : negocios){
            Requisicao_de_compra__c newRequisitions = new Requisicao_de_compra__c();
            newRequisitions.Tipo__c = 'Gerente Comercial';
            newRequisitions.RecordTypeId = queryRecordType;
            newRequisitions.Safra__c = '20/21';
            newRequisitions.Estado__c = 'Aprovada';
            newRequisitions.Negocio__c = a.Id;
            newRequisitions.Marca__c = 'NEOG';
            newRequisitions.Regiao_comercial__c = 'REGION 1';
            newRequisitions.Cultura__c = 'MILHO';
            newRequisitions.OwnerId = UserInfo.getUserId();
            requisitionsList.add(newRequisitions);
        }
        insert requisitionsList;
        return requisitionsList;
    }

    public static List<Produto_de_Requisicao__c> createRequisitionsProducts(List<Requisicao_de_compra__c> requisitions, List<Variedad__c> variety){

        Id queryRecordType = Schema.SObjectType.Produto_de_Requisicao__c.getRecordTypeInfosByName().get('Milho') .getRecordTypeId();

        System.debug('Marca: ' + requisitions[0].Marca__c);
        System.debug('Marca Comercial: ' + variety[0].Marca_comercial__c);

        List<Produto_de_Requisicao__c> requisitionsProductsList = new List<Produto_de_Requisicao__c>();

        for(Requisicao_de_compra__c req : requisitions){
            for(Variedad__c var : variety) {
                System.debug('Row: ' + req + ' - ' + var);
                Produto_de_Requisicao__c newRequisitionsProducts = new Produto_de_Requisicao__c();
                if(var.Marca_comercial__c == 'NEOGEN') {
                    newRequisitionsProducts.RecordTypeId = queryRecordType;
                    newRequisitionsProducts.Quantidade__c = 100;
                    newRequisitionsProducts.Requisicao_de_compra__c = req.Id;
                    newRequisitionsProducts.Variedad__c = var.Id;
                    newRequisitionsProducts.Embalagem__c = 'Saca 60 Mil Sementes';
                    newRequisitionsProducts.Tratamento__c = 'Tratamento A';
                    requisitionsProductsList.add(newRequisitionsProducts);
                }
            }
        }
        insert requisitionsProductsList;
        return requisitionsProductsList;
    }

    // Crear lista de Opportunidades

    public static List<Opportunity> createOpportunities(List<Account> accountList, Integer num){
        
        List<Opportunity> opportunityList = new List<Opportunity>();

        Id priceBookId = Test.getStandardPricebookId();

        for(Integer i=0;i<num;i++) {
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.AccountId = accountList[0].Id;
            newOpportunity.Name = 'OPPORTUNITY ' + i; 
            newOpportunity.StageName = 'PB-Edicion';
            newOpportunity.CloseDate = System.Today();
            newOpportunity.Marca__c = 'BRMX';
            newOpportunity.Safra__c = '20/21';
            newOpportunity.Region__c = 'REGION 1';
            newOpportunity.IsClon__c = false;
            newOpportunity.Activa__c = true;
            newOpportunity.Pricebook2Id = priceBookId;
            opportunityList.add(newOpportunity);
        }
        insert opportunityList;
        return opportunityList;
    }

    public static List<Opportunity> createOpportunitiesPBComercial(Integer num, List<Account> accountList, List<Requisicao_de_compra__c> requisicaoList){

        Id pbComercialId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('PB_Comercial_Milho').getRecordTypeId(); 
        
        List<Opportunity> opportunityList = new List<Opportunity>();

        Id priceBookId = Test.getStandardPricebookId();

        for(Integer i=0;i<num;i++) {
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.AccountId = accountList[0].Id;
            newOpportunity.RecordTypeId = pbComercialId;
            newOpportunity.Estimativas__c = requisicaoList[0].Id; 
            newOpportunity.Name = 'OPPORTUNITY ' + i; 
            newOpportunity.StageName = 'PB-Edicion';
            newOpportunity.CloseDate = System.Today();
            newOpportunity.Marca__c = 'NEOG';
            newOpportunity.Safra__c = '20/21';
            newOpportunity.Region__c = 'REGION 1';
            newOpportunity.IsClon__c = false;
            newOpportunity.Activa__c = true;
            newOpportunity.Tipo_de_Operacion__c = '1-Pedido	';
            newOpportunity.Cultura__c = 'Milho';
            newOpportunity.Pricebook2Id = priceBookId;
            opportunityList.add(newOpportunity);
        }

        System.debug('### Oportunidad PB-Comercial ### ' + opportunityList);

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
            newProduct.Variedade_Licenciada__c = varietys[0].Id;
            newProduct.UNIDADE__c = 'Saca 60 Mil Sementes';
            newProduct.Variedade__c = varietys[0].Id;
            newProduct.Especie__c = 'Milho';
            newProduct.IsActive = true;
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

        System.debug('PriceBook2: ' + newPriceBook2);

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

    public static List<OpportunityLineItem> createOpportunityLineItems(List<Opportunity> opportunities, List<Product2> products, List<Produto_de_Requisicao__c> requisitionProducts){
        
        List<OpportunityLineItem> opportunityLineItemsList = new List<OpportunityLineItem>();

        List<PricebookEntry> priceBookEntryList = [SELECT Id FROM PriceBookEntry];

        Id priceBookId = Test.getStandardPricebookId();

        Integer i = 0;

        for(Produto_de_Requisicao__c pro : requisitionProducts) {
            i=i+1;
            OpportunityLineItem newOpportunityLineItem = new OpportunityLineItem();
            newOpportunityLineItem.OpportunityId = opportunities[0].Id;
            newOpportunityLineItem.Product2Id = products[0].Id;
            newOpportunityLineItem.Nome__c = 'OPPORTUNITY LINE ITEM ' + i;
            newOpportunityLineItem.Quantidade_de_sementes__c = 5000000.00;
            newOpportunityLineItem.Producto_de_requisicion__c = pro.Id;
            newOpportunityLineItem.Variedad__c = pro.Variedad__c;
            newOpportunityLineItem.Embalagem__c = pro.Embalagem__c;
            newOpportunityLineItem.Tratamento__c = pro.Tratamento__c;
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
            contentVersionList.add(newContentVersion);
        }
        insert contentVersionList;
        return contentVersionList;
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

    // Crear lista de Contactos

    public static List<Contact> createContact(Integer num, List<Account> accountList) {

        List<Contact> ContactList = new List<Contact>();
    
        for(Integer i=0;i<num;i++){
            Contact newContact = new Contact();
            newContact.LastName = 'Peroza';
            newContact.CNPJ_CPF_c__c = '123456789101';
            newContact.Email = 'jhonnyperoza@gmail.com';
            newContact.Tipo_de_Assinatura__c = 'Individual';
            newContact.Origem_Docto__c = 'Estatuto';
            newContact.Vencimiento_docto__c = system.today();
            newContact.AccountId = accountList[0].Id;
            ContactList.add(newContact);
        }
        insert ContactList;
        return ContactList;
    }

    // Crear lista de Firmantes en Contrato "Milho"

    public static List<Signatario_do_Contrato__c> createSignatario(Integer num, List<Contract> contractList, List<Contact> contactList) {

        List<Signatario_do_Contrato__c> signatarioList = new List<Signatario_do_Contrato__c>();
        
        for(Integer i=0;i<num;i++){
            Signatario_do_Contrato__c newSignatario = new Signatario_do_Contrato__c();
            newSignatario.Contacto__c = contactList[0].Id;
            newSignatario.Contrato__c = contractList[0].Id;
            newSignatario.Tipos_de_Assinatura__c = 'Individual';
            newSignatario.Origem_Docto__c = 'Estatuto';
            newSignatario.Vencimiento_docto__c = system.today();
            signatarioList.add(newSignatario);
        }
        insert signatarioList;
        return signatarioList;
    }



}
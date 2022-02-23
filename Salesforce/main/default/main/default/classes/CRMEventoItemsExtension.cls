public with sharing class CRMEventoItemsExtension {

    public CRM_Calendario_de_Eventos__c theCRM {get;set;}
    public String searchString {get;set;}
    public CRM_Detalle_Calendario_de_eventos__c[] shoppingCart {get;set;}
    public Product2[] AvailableProducts {get;set;}

    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public Boolean overLimit {get;set;}
    public String mensaje {get;set;}
    private Integer contador = 0;

    private CRM_Detalle_Calendario_de_eventos__c[] forDeletion = new CRM_Detalle_Calendario_de_eventos__c[]{};

    private Map<String, Schema.SObjectField> objectFields_eventoItems = Schema.getGlobalDescribe().get('CRM_Detalle_Calendario_de_eventos__c').getDescribe().fields.getMap();
    private Map<String, Schema.SObjectField> objectFields_eventos = Schema.getGlobalDescribe().get('CRM_Calendario_de_Eventos__c').getDescribe().fields.getMap();

    public CRMEventoItemsExtension(ApexPages.StandardController controller) {
        try {
            Map<Id, User> propRol = new Map<Id, User>();
            String queryCRM = 'SELECT ';

            for (String s : objectFields_eventos.keySet()) {
                queryCRM += ' ' + s + ',';
            }

            queryCRM += 'RecordType.Name, RecordType.DeveloperName FROM CRM_Calendario_de_Eventos__c WHERE Id = \'' + controller.getRecord().Id + '\' LIMIT 1';        
            theCRM = Database.query(queryCRM);

            // Obtengo los productos ya cargados a la opp y los cargo como "Seleccionados"
            String queryItems = 'SELECT ';

            for (String s : objectFields_eventoItems.keySet()) {
                queryItems += ' ' + s + ',';
            }

            queryItems += ' Cultivar__r.Name, Cultivar__r.Obtentor__c FROM CRM_Detalle_Calendario_de_eventos__c WHERE CRM_Calendario_de_eventos__c = \'' + theCRM.Id + '\' ORDER BY Cultivar__r.Name';
            shoppingCart = Database.query(queryItems);

            for (CRM_Detalle_Calendario_de_eventos__c o: shoppingCart) {
                o.Indice__c = contador;
                contador++;
            }

            for (User u: [SELECT Id, UserRole.Name, Profile.Name FROM User]) {
                propRol.put(u.Id, u);
            }
        } catch (Exception e) {
            ApexPages.addMessages(e);
            return;
        }
    }

    public void updateAvailableList() {
        Set<Id> prodsARel;
        List<Id> oppsARel;

        // Construimos un query dinamico sobre los productos de la lista de precios
        String qString = 'SELECT Id, Name, Obtentor__c, IsActive, Variedade__c, Variedade__r.Name FROM Product2 WHERE isActive = false AND Obtentor__c != null ';

        // buscamos productos cuya descripcion o nombre coindidan con el texto ingresado
        if (searchString != null) {
            qString += 'AND (Name LIKE \'%' + searchString + '%\' OR Obtentor__c LIKE \'%' + searchString +  '%\')';
        }

        qString += ' ORDER BY Name LIMIT 31';

        AvailableProducts = Database.query(qString);

        // Solo se mostraran hasta 30 registros... si el query tiene mas, entonces el usuario vera un mensaje
        if (AvailableProducts.size() == 31) {
            AvailableProducts.remove(30);
            overLimit = true;
        } else {
            overLimit = false;
        }
    }

    /**
     * Añade un producto al shoppingCart cuando el usuario presiona "Adicionar" en un producto
     */
    public void addToShoppingCart() {
        for (Product2 d : AvailableProducts) {
            if ((String)d.Id == toSelect) {
                CRM_Detalle_Calendario_de_eventos__c item = new CRM_Detalle_Calendario_de_eventos__c(
                    CRM_Calendario_de_eventos__c = theCRM.Id,
                    Cultivar__r = d,
                    Cultivar__c = d.Id,
                    Indice__c = contador
                );

                shoppingCart.add(item);
                contador++;
                break;
            }
        }
    }

    /**
     * Quita un producto del shoppingCart cuando el usuario presiona "Excluir" en un producto
     */
    public PageReference removeFromShoppingCart() {
        Integer count = 0;

        for (CRM_Detalle_Calendario_de_eventos__c d : shoppingCart) {
            if (String.valueOf(d.Indice__c) == toUnselect) {
                if (d.Id != null) { forDeletion.add(d); }
                shoppingCart.remove(count);
                break;
            }

            count++;
        }

        updateAvailableList();
        return null;
    }

    public PageReference onSave() {
        if (theCRM.RecordType.Name == 'Test a campo' && validatePrincipalProduct()) { // validaciones US 13888
            mensaje = 'Você deve especificar: um (1) produto principal';
            return null;
        } else {
            mensaje = '';
        }

        try {
            if (!forDeletion.isEmpty()) { delete(forDeletion); }
            if (!shoppingCart.isEmpty()) { upsert(shoppingCart); }
        } catch (Exception e) {
            ApexPages.addMessages(e);
            return null;
        }

        // Luego de grabar los cambios retornamos al usuario a la opp
        String nextlink = '/' + ApexPages.currentPage().getParameters().get('Id');
        // '/rlName/OpportunityLineItems/view'

        PageReference nextPage = new PageReference(nextlink);
        nextPage.setRedirect(true);
        return nextPage;
    }

    public PageReference onCancel() {
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }

    /**
     * Solo debe de haber un Producto Principal seleccionado, valida si un item y solo un (1) item fue elegido como principal (US 13888).
     */
    private Boolean validatePrincipalProduct() {
        Integer count = 0;
        for (CRM_Detalle_Calendario_de_eventos__c i : shoppingCart) { if (i.Produto_Principal__c) { count++; } }
        return !shoppingCart.isEmpty() && count != 1;
    }
}
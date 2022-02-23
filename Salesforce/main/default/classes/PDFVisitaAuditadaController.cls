global with sharing class PDFVisitaAuditadaController {

    public String apontamentoName               {get; set;}
    public Account account                      {get; set;}
    public List<ProductWrapper> products        {get; set;}
    public String total                         {get; set;}
    public String ahora                         {get; set;}
    public Calendar_event__c calendarEvent      {get; set;}
    public Plano_De_Auditoria__c plano			{get; set;}

    public PDFVisitaAuditadaController(ApexPages.StandardController controller) {
        ahora = dateToStr(datetime.now());
        Integer cantidadDeVersiones = [SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId = :controller.getRecord().Id];
        Integer currentYear = System.Today().year();
        apontamentoName = currentYear + '/' + (cantidadDeVersiones+1);
        products = new List<ProductWrapper>();

        List<Producto_Auditado__c> productos = [
            SELECT Id, Name, Safra__c, Variedad__c, Variedad__r.Name, Categoria_Oli__C, Categoria_Oli__r.Name, Diferencia_de_Venta__c, Diferencia_Descarte__c
            FROM Producto_Auditado__c
            WHERE Plano_De_Auditoria__c = :controller.getRecord().Id
        ];

        plano = [SELECT Id, Name, Cuenta_Principal__c, Observacion__c FROM Plano_De_Auditoria__c WHERE Id = :controller.getRecord().Id];
        account = [SELECT Id, Name FROM Account WHERE Id = :plano.Cuenta_Principal__c];

        List<String> safras = new List<String>();
        Map<String, Decimal> mapDifNegativaPorSafra = new Map<String, Decimal>();
        Map<String, Decimal> mapDifPositivaPorSafra = new Map<String, Decimal>();
        Map<String, String> mapDifTotalPorSafra = new Map<String, String>();
        Decimal diferenciaNegativaTotal = 0;
        Decimal diferenciaPositivaTotal = 0;

        for (Producto_Auditado__c producto : productos) {
            if (producto.Diferencia_de_Venta__c != null) {
                ProductWrapper product = new ProductWrapper();
                product.safra = producto.Safra__c;
                product.variedad = producto.Variedad__r.Name;
                product.categoria = producto.Categoria_Oli__r.Name;
                product.origen = 'COMERCIALIZAÇÃO';
                product.cantidad = producto.Diferencia_de_Venta__c;

                if (producto.Diferencia_de_Venta__c < 0) {
                    if (!mapDifNegativaPorSafra.containsKey(producto.Safra__c)) {
                        mapDifNegativaPorSafra.put(producto.Safra__c, producto.Diferencia_de_Venta__c);
                        safras.add(producto.Safra__C);
                    } else {
                        mapDifNegativaPorSafra.put(producto.Safra__c, mapDifNegativaPorSafra.get(producto.Safra__c) + producto.Diferencia_de_Venta__c);
                    }
                } else {
                    if (!mapDifPositivaPorSafra.containsKey(producto.Safra__c)) {
                        mapDifPositivaPorSafra.put(producto.Safra__c, producto.Diferencia_de_Venta__c);
                        safras.add(producto.Safra__C);
                    } else {
                        mapDifPositivaPorSafra.put(producto.Safra__c, mapDifPositivaPorSafra.get(producto.Safra__c) + producto.Diferencia_de_Venta__c);
                    }
                }

                products.add(product);
            }

            if (producto.Diferencia_Descarte__c != null) {
                ProductWrapper product = new ProductWrapper(); 
                product.safra = producto.Safra__c;
                product.variedad = producto.Variedad__r.Name;
                product.categoria = producto.Categoria_Oli__r.Name;
                product.origen = 'DESCARTE';
                product.cantidad = producto.Diferencia_Descarte__c;

                if (producto.Diferencia_Descarte__c < 0) {
                    if (!mapDifNegativaPorSafra.containsKey(producto.Safra__c)) {
                        mapDifNegativaPorSafra.put(producto.Safra__c, producto.Diferencia_Descarte__c);
                        safras.add(producto.Safra__C);
                    } else {
                        mapDifNegativaPorSafra.put(producto.Safra__c,mapDifNegativaPorSafra.get(producto.Safra__c) + producto.Diferencia_Descarte__c);
                    }
                } else {
                    if (!mapDifPositivaPorSafra.containsKey(producto.Safra__c)) {
                        mapDifPositivaPorSafra.put(producto.Safra__c, producto.Diferencia_Descarte__c);
                        safras.add(producto.Safra__C);
                    } else {
                        mapDifPositivaPorSafra.put(producto.Safra__c,mapDifPositivaPorSafra.get(producto.Safra__c) + producto.Diferencia_Descarte__c);
                    }
                }

                products.add(product);
            }
        }

        for (ProductWrapper producto : products) {
            for (String safra: safras) {
                mapDifTotalPorSafra.put(safra, 
                                        (String.valueOf(mapDifNegativaPorSafra.get(producto.safra)) == null ? '0.00' : String.valueOf(mapDifNegativaPorSafra.get(producto.safra))) + 
                                        '/' + 
                                        (String.valueOf(mapDifPositivaPorSafra.get(producto.safra)) == null ? '0.00' : String.valueOf(mapDifPositivaPorSafra.get(producto.safra)))
                                        );
            }            
        }

        for (Decimal dif : mapDifNegativaPorSafra.values()) {
            diferenciaNegativaTotal += dif;
            system.debug('mapDifNeg' + dif);
        }

        for (Decimal dif : mapDifPositivaPorSafra.values()) {
            diferenciaPositivaTotal += dif;
            system.debug('mapDifPos' + dif);
        }

        total = (String.valueOf(diferenciaNegativaTotal) == null ? '0.00' : String.valueOf(diferenciaNegativaTotal)) + '/' + (String.valueOf(diferenciaPositivaTotal)==null ? '0.00' : String.valueOf(diferenciaPositivaTotal));
        products.sort();

        for (Integer i = 0; i < products.size(); i++) {
            if (i == (products.size()-1) || products[i].safra != products[i+1].safra) {
                products[i].totalSafra = mapDifTotalPorSafra.get(products[i].safra);
            }
        }
    }

    private String dateToStr(Datetime aDate) {
        Integer m = aDate.month();
        String mString = '';

        switch on m {
            when 1 {mString = 'janeiro';}
            when 2 {mString = 'fevereiro';}
            when 3 {mString = 'Março';}
            when 4 {mString = 'abril';}
            when 5 {mString = 'maio';}
            when 6 {mString = 'Junho';}
            when 7 {mString = 'Julho';}
            when 8 {mString = 'agosto';}
            when 9 {mString = 'setembro';}
            when 10 {mString = 'Outubro';}
            when 11 {mString = 'novembro';}
            when 12 {mString = 'dezembro';}
        }

        return (aDate.day() + ' de ' + mString + ' de ' + aDate.year());
    }

    global class ProductWrapper implements Comparable {

        public String safra         {get; set;}
        public String variedad      {get; set;}
        public String categoria     {get; set;}
        public String origen        {get; set;}
        public Decimal cantidad     {get; set;}
        public String totalSafra    {get; set;}

        global Integer compareTo(Object compareTo) {
            ProductWrapper wrapper = (ProductWrapper)compareTo;

            if (safra == wrapper.safra) {
                return 0;
            } else if (safra < wrapper.safra) {
                return 1;
            } else {
                return -1;
            }
        }
    }
}
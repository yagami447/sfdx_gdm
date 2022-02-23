public class CRM_Controller {
    
    public Id accId {get; set;}
    public String campania {get; set;}
    public String nombre_cuenta {get; set;}
    
    private Id editInfrA;
    private Id editInfrB;
    private Id editInfrF;
    private Id editInfrG;
    private Id editvbmx;
    private Id editvdms;
    private Id editpbmx;
    private Id editpdms;
    private Id saveedit_planeamiento_bmx;
    private Id saveedit_planeamiento_dms;
    private Id saveedit_venta_bmx;
    private Id saveedit_venta_dms;
    private Id saveedit_sacas_v;
    private Id saveedit_sacas_cf;
    private Id saveedit_sacas_o;
    private Id saveedit_p_sacas_o;
    private Id saveedit_p_sacas_v;
    private Id saveedit_p_sacas_cf;
    private Boolean editInfrC = false;
    private Boolean editInfrD = false;
    private Boolean editInfrE = false;
    private Boolean editPInfrC = false;
    private Boolean editPInfrD = false;
    private Boolean editPInfrE = false;
    //private Boolean editInfrG = false;
    private Boolean editTotalSacasV = false;
    private Boolean editTotalSacasCF = false;
    private Boolean editDatosBonifBRMX = false;
    private Boolean editDatosBonifDSEM = false;
    private Id elimInfr;
    private Id editCalendario;
    private Id eliminarCalendario;
    private Id eliminar_planeamiento_BMX;
    private Id eliminar_planeamiento_DMS;
    private Id eliminar_venta_DMS;
    private Id eliminar_venta_BMX;
    private Id eliminar_sacas_v;
    private Id eliminar_sacas_cf;
    private Id eliminar_sacas_o;
    private Id eliminar_p_sacas_o;
    private Id eliminar_p_sacas_v;
    private Id eliminar_p_sacas_cf;
    private Boolean editCanalDeVendas = false;
    private Boolean editarVendas = false;
    
    private Boolean adicionar_inf_A = false;
    private Boolean adicionar_inf_B = false;
    private Boolean adicionar_inf_F = false;
    private Boolean adicionar_inf_G = false;
    
    private Boolean adicionar_plan_inf_A = false;
    private Boolean adicionar_plan_inf_B = false;
    private Boolean adicionar_plan_inf_F = false;
    private Boolean adicionar_plan_inf_G = false;
    
    public Boolean adicionar_venta_BMX = false;
    private Boolean adicionar_venta_DMS = false;
    
    private Boolean adicionar_sacas_v = false;
    private Boolean adicionar_sacas_cf = false;
    public Boolean adicionar_sacas_o = false;
    
    private Boolean adicionar_p_sacas_o = false;
    private Boolean adicionar_p_sacas_v = false;
    private Boolean adicionar_p_sacas_cf = false;
    
    private Boolean adicionar_planeamiento_BMX = false;
    private Boolean adicionar_planeamiento_DMS = false;
    
    public List<CRM_Calendario_de_Eventos__c> calendario;
    public CRM_Calendario_de_Eventos__c nuevo_calendario;
    public CRM_Calendario_de_Eventos__c ver_calendario {get; set;}
    public List<CRM_Detalle_Calendario_de_eventos__c> nuevo_calendario_detalles {get; set;}
    public List<CRM_Detalle_Calendario_de_eventos__c> nuevo_calendario_detalle {get; set;}
    public List<CRM_Detalle_Calendario_de_eventos__c> ver_calendario_detalles {get; set;}
    public List<CRM_Detalle_Calendario_de_eventos__c> ver_calendario_detalle {get; set;}
    
    public List<Attachment> nuevo_calendario_attach {get; set;}
    public List<Attachment> nuevo_calendario_attachs {get; set;}
    
    public List<Attachment> ver_calendario_attachs {get; set;}
    public List<Attachment> ver_calendario_attach {get; set;}
    
    public Boolean verItemsNewCalendario{get; set;}
    
    private CRM_Multiplicador__c canal_de_vendas;
    
    private CRM_Multiplicador__c vendas;
    
    private List<CRM_Area_de_Atuacion__c> area_atuacion;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_RS;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_SC;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_PR;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_MS;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_SP;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_GO;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_MG;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_MA;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_BA;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_RO;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_TO;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_PI;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_MT;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_PA;
    
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_RS;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_SC;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_PR;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_MS;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_SP;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_GO;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_MG;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_MA;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_BA;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_RO;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_TO;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_PI;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_MT;
    private List<CRM_Area_de_Atuacion__c> area_atuacion_planeamiento_PA;
    
    private String estadoNewCal;
    private String estadoEditCal;
    
    public String estadoEditCal2 {get; set;}    
    public Boolean editVerCalendario {get; set;}
    
    private String nuevaVariedadBMX;
    private String nuevaVariedadDMS;
    private String nuevoAgroquimico;
    
    private String nuevoProdOutros;
    private Double nuevoProdOutrosVolume;
    private Double nuevoProdOutrosVolumeProd;
    private Double totalCanalVendas = 0;
    
    private Product2 nuevaSacasV = New Product2();
    private Product2 nuevaSacasCF = New Product2();
    private Product2 nuevaSacasO = New Product2();
    
    public Product2 addNuevoItemEvento = New Product2();
    public Product2 editNuevoItemEvento = New Product2();
    public String nuevoItemEvento;
    
    private Double nuevaSacasVVolume;
    private Double nuevaSacasCFVolume;
    
    private Double nuevaSacasVVolumeProd;
    private Double nuevaSacasCFVolumeProd;
    
    private Product2 editSacasV = New Product2();
    private Product2 editSacasCF = New Product2();
    private Product2 editSacasO = New Product2();
    
    private String editVariedadBMX;
    private String editVariedadDMS;
    private String editAgroquimico;
    
    private String editProdOutros;
    
    private String nuevoAreaAtuacion;
    private Double nuevoAreaAtuacionCantidad;
    private Double nuevoAreaAtuacionPorcentaje;
    
    private Integer editNewItemEvento;
    
    private String editsv;
    private String editscf;
    private String editso;
    
    private String editpsv;
    private String editpscf;
    private String editpso;
    
    private Id editareaa;
    private String elim_areaa;
    private String editRegAreaA;
    
    private Double editCantAreaA;
    private Double editPorcentajeAreaA;
    
    private Double totalVentasBMX;
    private Double totalVentasDMS;
    private Double totalVentasOutros;
    
    private Double totalVolProduzidoBMX;
    private Double totalVolProduzidoDMS;
    private Double totalVolProduzidoOutros;
    private Double totalVolProduzidoSV;
    private Double totalVolProduzidoSCF;
    
    private Double totalPlaneamientoBMX;
    private Double totalPlaneamientoDMS;
    private Double totalPlaneamientoOutros;
    private Double totalPlaneamientoSacasVerticaliza;
    private Double totalPlaneamientoSacasCF;
    
    private Double totalPlanInfCapPorUBS;
    private Double totalPlanInfProdPorUBS;
    private Double totalPlanInfCapPorEmpresa;
    private Double totalPlanInfVolTPorEmpresa;
    
    private CRM_Area_de_Atuacion__c totalRS = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalSC = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPR = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalMS = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalSP = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalGO = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalMG = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalMA = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalBA = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalRO = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalTO = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPI = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalMT = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPA = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalGeneralEstados = New CRM_Area_de_Atuacion__c();
    
    private CRM_Area_de_Atuacion__c totalPlaneamientoRS = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoSC = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoPR = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoMS = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoSP = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoGO = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoMG = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoMA = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoBA = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoRO = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoTO = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoPI = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoMT = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoPA = New CRM_Area_de_Atuacion__c();
    private CRM_Area_de_Atuacion__c totalPlaneamientoGeneralEstados = New CRM_Area_de_Atuacion__c();
        
    private List<CRM_Infraestructura__c> infraestructura;
    private List<CRM_Infraestructura__c> infraestructura_A;
    private List<CRM_Infraestructura__c> infraestructura_B {get; set;}
    private List<CRM_Infraestructura__c> infraestructura_F;
    private List<CRM_Infraestructura__c> infraestructura_G {get; set;}
    private List<CRM_Infraestructura__c> plan_infraestructura;
    private List<CRM_Infraestructura__c> plan_infraestructura_A;
    private List<CRM_Infraestructura__c> plan_infraestructura_B {get; set;}
    private List<CRM_Infraestructura__c> plan_infraestructura_F;
    private List<CRM_Infraestructura__c> plan_infraestructura_G {get; set;}
    public CRM_Multiplicador__c crm_mult {get; set;}
    private CRM_Multiplicador__c infraestructura_C {get; set;}
    private CRM_Multiplicador__c infraestructura_D {get; set;}
    private CRM_Multiplicador__c infraestructura_E {get; set;}
    
    public List<CRM_Infraestructura__c> nuevo_infraestructura_A;   
    public List<CRM_Infraestructura__c> nuevo_infraestructura_B;
    public List<CRM_Infraestructura__c> nuevo_infraestructura_F;
    public List<CRM_Infraestructura__c> nuevo_infraestructura_G;
    
    private List<CRM_Infraestructura__c> nuevo_plan_infraestructura_A;   
    private List<CRM_Infraestructura__c> nuevo_plan_infraestructura_B;
    private List<CRM_Infraestructura__c> nuevo_plan_infraestructura_F;
    private List<CRM_Infraestructura__c> nuevo_plan_infraestructura_G;
    
    
    private List<CRM_Vendas__c> ventas;
    private List<CRM_Vendas__c> ventas_BMX;
    private List<CRM_Vendas__c> ventas_DMS;
    private List<CRM_Vendas__c> nuevo_ventas_BMX;
    private List<CRM_Vendas__c> nuevo_ventas_DMS;
    
    private List<CRM_Vendas__c> sacas_verticaliza;
    private List<CRM_Vendas__c> sacas_compra_fora;
    private List<CRM_Vendas__c> nuevo_sacas_verticaliza;
    private List<CRM_Vendas__c> nuevo_sacas_compra_fora;
    private List<CRM_Vendas__c> sacas_outros;
    private List<CRM_Vendas__c> nuevo_sacas_outros;
    
    private List<CRM_Vendas__c> planeamiento_BMX;
    private List<CRM_Vendas__c> planeamiento_DMS;
    private List<CRM_Vendas__c> planeamiento_sacas_verticaliza; 
    private List<CRM_Vendas__c> planeamiento_sacas_compra_fora; 
    private List<CRM_Vendas__c> planeamiento_sacas_outros;
    private List<CRM_Vendas__c> nuevo_planeamiento_BMX;
    private List<CRM_Vendas__c> nuevo_planeamiento_DMS;
    private List<CRM_Vendas__c> nuevo_planeamiento_sacas_verticaliza;
    private List<CRM_Vendas__c> nuevo_planeamiento_sacas_compra_fora;
    private List<CRM_Vendas__c> nuevo_planeamiento_sacas_outros;
    
    private List<SelectOption> optionsNewOutros;
    private List<SelectOption> optionsEditOutros;
    private List<SelectOption> optionsEditNuevoEvento;
    public List<SelectOption> optionsAddNuevoEvento;
        
    private Map<String, Schema.SObjectField> objectFields_CRM_Mult = Schema.getGlobalDescribe().get('CRM_Multiplicador__c').getDescribe().fields.getMap();
    private Map<String, Schema.SObjectField> objectFields_CRM_Inf = Schema.getGlobalDescribe().get('CRM_Infraestructura__c').getDescribe().fields.getMap(); 
    private Map<String, Schema.SObjectField> objectFields_CRM_Calen = Schema.getGlobalDescribe().get('CRM_Calendario_de_Eventos__c').getDescribe().fields.getMap();
    private Map<String, Schema.SObjectField> objectFields_CRM_Calen_Det = Schema.getGlobalDescribe().get('CRM_Detalle_Calendario_de_Eventos__c').getDescribe().fields.getMap();
    private Map<String, Schema.SObjectField> objectFields_CRM_Vendas = Schema.getGlobalDescribe().get('CRM_Vendas__c').getDescribe().fields.getMap();
    private Map<String, Schema.SObjectField> objectFields_CRM_Area_Atuacion = Schema.getGlobalDescribe().get('CRM_Area_de_Atuacion__c').getDescribe().fields.getMap();
    private Map<Id, Id> ciudades = New Map<Id, Id>();
                
                    
    public List<SelectOption> getAgroquimicos() {
       List<SelectOption> lista = new List<SelectOption>();
       
       for (Product2 p : [Select Id, Name From Product2 Where Family = 'Agroquimico' Order By Name])                               
           lista.add(new SelectOption(p.Id,p.Name));               
                                           
       return lista;
    }
    
    public List<SelectOption> getRegionesConGrupo() {
       Map<String, Regiao__c> regiones = New Map<String, Regiao__c>();
       List<SelectOption> lista = new List<SelectOption>();
       List<SelectOption> listSortByLabel = new List<SelectOption>();
       
       for (Regiao__c r : [Select Id, Name From Regiao__c Where Grupo_de_R__c != null Order By Name]){
            if(!regiones.containsKey(r.Name))
                regiones.put(r.Name, r);                                   
           //lista.add(new SelectOption(r.Id,r.Name));
       }
       for(Regiao__c rr: regiones.values()){
            lista.add(new SelectOption(rr.Id,rr.Name));
       }
       listSortByLabel = selectOptionSortByLabel(lista);
       return listSortByLabel; 
    }
    
    public static list<selectOption> selectOptionSortByLabel(list<selectOption>selectOptionsToSort) {
        if(selectOptionsToSort == null || selectOptionsToSort.size() <= 1){
            return selectOptionsToSort;
        }
        List<SelectOption> lessSelectOption = new List<SelectOption>();
        List<SelectOption> greaterSelectOption = new List<SelectOption>();
        integer pivot = selectOptionsToSort.size() / 2;
        
        //save the pivot and remove it from the selectOption list
        SelectOption pivotValue = selectOptionsToSort[pivot];
        selectOptionsToSort.remove(pivot);
        for(selectOption SO : selectOptionsToSort){
            if(SO.getLabel() <= pivotValue.getLabel()){
                lessSelectOption.add(SO);
            }else if(SO.getLabel() > pivotValue.getLabel()){
                greaterSelectOption.add(SO);   
            }
        }
        list<selectOption> sortedSelectOptions = new list<selectOption>(); 
        sortedSelectOptions.addAll(selectOptionSortByLabel(lessSelectOption));
        sortedSelectOptions.add(pivotValue);
        sortedSelectOptions.addAll(selectOptionSortByLabel(greaterSelectOption));
        return SortedSelectOptions;
    }
    
    public PageReference getVariedadesObt_New_SacasO() {
       List<Product2> prods = New List<Product2>();
       optionsNewOutros = new List<SelectOption>();
       
       if (nuevaSacasO.Obtentor__c != null){
           prods = [Select Id, Name From Product2 Where Obtentor__c = : nuevaSacasO.Obtentor__c];
       
           if (prods.size() > 0){
               for (Product2 p : prods){                           
                   optionsNewOutros.add(new SelectOption(p.Id,p.Name));               
               }
           }
       }            
       
       return null;
    }
    public String formatDouble(Decimal myNumber,Boolean isCurrency){
        String formattedString = '';
        String myNumberAsString = String.valueOf(myNumber);
        if (isCurrency){
            formattedString = '$';
        }
        if(myNumber>999999999){
            formattedString += myNumberAsString.substring(0,myNumberAsString.length()-9)+ '.' + myNumberAsString.substring(myNumberAsString.length()-9,myNumberAsString.length()-6) + '.' + myNumberAsString.substring(myNumberAsString.length()-6,myNumberAsString.length()-3) + '.' + myNumberAsString.substring(myNumberAsString.length()-3,myNumberAsString.length());
        } else  if(myNumber>999999){
                    formattedString += myNumberAsString.substring(0,myNumberAsString.length()-6)+ '.' + myNumberAsString.substring(myNumberAsString.length()-6,myNumberAsString.length()-3) + '.' + myNumberAsString.substring(myNumberAsString.length()-3,myNumberAsString.length());
                } else if(myNumber>999){
                    formattedString += myNumberAsString.substring(0,myNumberAsString.length()-3)+ '.' + myNumberAsString.substring(myNumberAsString.length()-3,myNumberAsString.length());
                    } else {
                        formattedString += myNumberAsString;
        }
        return formattedString;
    }
    
    public PageReference getVariedadesObt_Add_NewEvento() {
       List<Product2> prods = New List<Product2>();
       optionsAddNuevoEvento = new List<SelectOption>();
       prods = [Select Id, Name From Product2 Where Obtentor__c = : addNuevoItemEvento.Obtentor__c];
       
       if (prods.size() > 0){
           for (Product2 p : prods){                           
               optionsAddNuevoEvento.add(new SelectOption(p.Id,p.Name));               
           }
       }        
       
       return null;
    }
    
    public PageReference getVariedadesObt_Edit_NewEvento() {
       List<Product2> prods = New List<Product2>();
       optionsEditNuevoEvento = new List<SelectOption>();
       prods = [Select Id, Name From Product2 Where Obtentor__c = : editNuevoItemEvento.Obtentor__c];
       
       if (prods.size() > 0){
           for (Product2 p : prods){                           
               optionsEditNuevoEvento.add(new SelectOption(p.Id,p.Name));               
           }
       }        
       
       return null;
    }
    
    public PageReference getVariedadesObt_Edit_SacasO() {
       List<Product2> prods = New List<Product2>();
       optionsEditOutros = new List<SelectOption>();
       prods = [Select Id, Name From Product2 Where Obtentor__c = : editSacasO.Obtentor__c];
       
       if (prods.size() > 0){
           for (Product2 p : prods){                           
               optionsEditOutros.add(new SelectOption(p.Id,p.Name));               
           }
       }        
       
       return null;
    }
            
    public List<SelectOption> getVariedadesBMX() {
       Map<String, Product2> variedad = New Map<String, Product2>();
       List<SelectOption> options = new List<SelectOption>();
       for (Product2 p : [Select Id, Variedad__c, Categ__r.Name, Variedade__r.Name From Product2 Where Sociedad__c = 'BRMX' AND Categ__r.Name = 'BASICA' AND Variedade__r.Licenciada__c != true AND Variedade__r.Name != null])
            if (!variedad.containsKey(p.Variedade__r.Name)) variedad.put(p.Variedade__r.Name, p);
       if (variedad.size() > 0) {
           for (Product2 p : variedad.Values()) {                           
               options.add(new SelectOption(p.Id, p.Variedade__r.Name));               
           }
       }        
       
       return options;
    }
    
    public List<SelectOption> getVariedadesDMS() {
       Map<String, Product2> variedad = New Map<String, Product2>();
       List<SelectOption> options = new List<SelectOption>();
       for (Product2 p : [Select Id, Variedad__c, Categ__r.Name, Variedade__r.Name From Product2 Where Sociedad__c = 'DSEM' AND Categ__r.Name = 'BASICA' AND Variedade__r.Licenciada__c != true AND Variedade__r.Name != null])
            if (!variedad.containsKey(p.Variedade__r.Name)) variedad.put(p.Variedade__r.Name, p);
       
       if (variedad.size() > 0) {
           for (Product2 p : variedad.Values()) {                           
               options.add(new SelectOption(p.Id, p.Variedade__r.Name));               
           }
       }        
       return options;
    }

    public List<SelectOption> getVariedadesNEO() {
        Map<String, Product2> variedad = New Map<String, Product2>();
        List<SelectOption> options = new List<SelectOption>();
        for (Product2 p : [SELECT Id, Variedad__c, Categ__r.Name, Variedade__r.Name FROM Product2 WHERE Sociedad__c = 'NEOG' AND Categ__r.Name = 'BASICA' AND Variedade__r.Licenciada__c != true AND Variedade__r.Name != null])
            if (!variedad.containsKey(p.Variedade__r.Name)) variedad.put(p.Variedade__r.Name, p);
        
        if (variedad.size() > 0) {
            for (Product2 p : variedad.Values()) {
                options.add(new SelectOption(p.Id, p.Variedade__r.Name));
            }
        }
        return options;
    }

    public List<SelectOption> getVariedadesDAG() {
        Map<String, Product2> variedad = new Map<String, Product2>();
        List<SelectOption> options = new List<SelectOption>();
        for (Product2 p : [SELECT Id, Variedade__c, Categ__r.Name, Variedade__r.Name FROM Product2 WHERE Sociedad__c = 'DAGMA' AND Categ__r.Name = 'BASICA' AND Variedade__r.Licenciada__c != true AND Variedade__r.Name != null])
            if (!variedad.containsKey(p.Variedade__r.Name)) variedad.put(p.Variedade__r.Name, p);
        
        if (variedad.size() > 0) {
            for (Product2 p : variedad.Values()) {
                options.add(new SelectOption(p.Id, p.Variedade__r.Name));
            }
        }
        return options;
    }

    public List<SelectOption> getVariedadesLIC() {
        Map<String, Product2> variedad = new Map<String, Product2>();
        List<SelectOption> options = new List<SelectOption>();
        for (Product2 p : [SELECT Id, Variedade__c, Categ__r.Name, Variedade__r.Name FROM Product2 WHERE Sociedad__c = 'LICENÇAS' AND Categ__r.Name = 'BASICA' AND Variedade__r.Licenciada__c != true AND Variedade__r.Name != null])
            if (!variedad.containsKey(p.Variedade__r.Name)) variedad.put(p.Variedade__r.Name, p);
        
        if (variedad.size() > 0) {
            for (Product2 p : variedad.Values()) {
                options.add(new SelectOption(p.Id, p.Variedade__r.Name));
            }
        }
        return options;
    }
    
    public List<SelectOption> getVariedadesCalendario() {
        
        switch on nuevo_calendario.Marca__c {
            when 'BRMX'  {
                return getVariedadesBMX();
            }
            when 'DSEM' {
                return getVariedadesDMS();
            }
            when 'NEOG' {
                return getVariedadesNEO();
            }
            when 'DAGMA' {
                return getVariedadesDAG();
            }
            when 'LICENÇAS' {
                return getVariedadesLIC();
            }
        } 
        return null;    
        
    }
    
    public List<SelectOption> getVariedadesEditCalendario() {

        switch on ver_calendario.Marca__c {
            when 'BRMX' {
                return getVariedadesBMX();
            }
            when 'DSEM' {
                return getVariedadesDMS();
            }
            when 'NEOG' {
                return getVariedadesNEO();
            }
            when 'DAGMA' {
                return getVariedadesDAG();
            }
            when 'LICENÇAS' {
                return getVariedadesLIC();
            }
        } 
        return null;    
        
    }
    
    public void seteditAgroquimico (String i){
        editAgroquimico = i;
    }
    
    public String geteditAgroquimico (){
        return editAgroquimico;
    }
    
    public void setnuevoAgroquimico (String i){
        nuevoAgroquimico = i;
    }
    
    public String getnuevoAgroquimico (){
        return nuevoAgroquimico;
    }
    
    public void setnuevaSacasCFVolume (Double i){
        nuevaSacasCFVolume = i;
    }
    
    public Double getnuevaSacasCFVolume (){
        return nuevaSacasCFVolume;
    }
    
    public void setnuevaSacasCFVolumeProd (Double i){
        nuevaSacasCFVolumeProd = i;
    }
    
    public Double getnuevaSacasCFVolumeProd (){
        return nuevaSacasCFVolumeProd;
    }
    
    public void setnuevaSacasVVolume (Double i){
        nuevaSacasVVolume = i;
    }
    
    public Double getnuevaSacasVVolume (){
        return nuevaSacasVVolume;
    }
    
    public void setnuevaSacasVVolumeProd (Double i){
        nuevaSacasVVolumeProd = i;
    }
    
    public Double getnuevaSacasVVolumeProd (){
        return nuevaSacasVVolumeProd;
    }
    
    public Double gettotalCanalVendas(){
        return totalCanalVendas;
    }
    public void settotalCanalVendas(Double i){
        totalCanalVendas = i;
    }
    
    public void setcrm_mult (CRM_Multiplicador__c i){
        crm_mult = i;
    }
    
    public CRM_Multiplicador__c getcrm_mult (){
        return crm_mult;
    }
    
    public void settotalPlaneamientoGeneralEstados (Double i){
        totalPlaneamientoGeneralEstados.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoGeneralEstados (){
        return totalPlaneamientoGeneralEstados;
    }
    
    public void settotalGeneralEstados (Double i){
        totalGeneralEstados.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalGeneralEstados (){
        return totalGeneralEstados;
    }
    
    public void setnuevoProdOutrosVolume (Double i){
        nuevoProdOutrosVolume = i;
    }
    
    public Double getnuevoProdOutrosVolume (){
        return nuevoProdOutrosVolume;
    }
    
    public void setnuevoProdOutrosVolumeProd (Double i){
        nuevoProdOutrosVolumeProd = i;
    }
    
    public Double getnuevoProdOutrosVolumeProd (){
        return nuevoProdOutrosVolumeProd;
    }
    
    public void setnombre_cuenta (String i){
        nombre_cuenta = i;
    }
    
    public String getnombre_cuenta (){
        return nombre_cuenta;
    }
   
    public void setcampania(String i){
        campania = i;
    }
    
    public String getcampania (){
        return campania;
    }
    
    public void seteditCantAreaA (Double i){
        editCantAreaA = i;
    }
    
    public Double geteditCantAreaA (){
        return editCantAreaA;
    }
    
    public void seteditPorcentajeAreaA (Double i){
        editPorcentajeAreaA = i;
    }
    
    public Double geteditPorcentajeAreaA (){
        return editPorcentajeAreaA;
    }
    
    public void setnuevoAreaAtuacionCantidad (Double i){
        nuevoAreaAtuacionCantidad = i;
    }
    
    public Double getnuevoAreaAtuacionCantidad (){
        return nuevoAreaAtuacionCantidad;
    }
    
    public void setnuevoAreaAtuacionPorcentaje (Double i){
        nuevoAreaAtuacionPorcentaje = i;
    }
    
    public Double getnuevoAreaAtuacionPorcentaje (){
        return nuevoAreaAtuacionPorcentaje;
    }
    
    public void setnuevoAreaAtuacion (String i){
        nuevoAreaAtuacion = i;
    }
    
    public String getnuevoAreaAtuacion (){
        return nuevoAreaAtuacion;
    }       
    
    public void settotalPlaneamientoSP (Double i){
        totalPlaneamientoSP.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoSP (){
        return totalPlaneamientoSP;
    }
    
    public void settotalPlaneamientoMS (Double i){
        totalPlaneamientoMS.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoMS (){
        return totalPlaneamientoMS;
    }
    
    public void settotalPlaneamientoPR (Double i){
        totalPlaneamientoPR.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoPR (){
        return totalPlaneamientoPR;
    }
    
    public void settotalPlaneamientoSC (Double i){
        totalPlaneamientoSC.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoSC (){
        return totalPlaneamientoSC;
    }
    
    public void settotalPlaneamientoRS (Double i){
        totalPlaneamientoRS.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoRS (){
        return totalPlaneamientoRS;
    }
    
    public void settotalPlaneamientoGO (Double i){
        totalPlaneamientoGO.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoGO (){
        return totalPlaneamientoGO;
    }
    public void settotalPlaneamientoMG (Double i){
        totalPlaneamientoMG.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoMG (){
        return totalPlaneamientoMG;
    }
    
    public void settotalPlaneamientoMA (Double i){
        totalPlaneamientoMA.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoMA (){
        return totalPlaneamientoMA;
    }
    
    public void settotalPlaneamientoBA (Double i){
        totalPlaneamientoBA.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoBA (){
        return totalPlaneamientoBA;
    }
    
    public void settotalPlaneamientoRO (Double i){
        totalPlaneamientoRO.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoRO (){
        return totalPlaneamientoRO;
    }
    
    public void settotalPlaneamientoTO (Double i){
        totalPlaneamientoTO.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoTO (){
        return totalPlaneamientoTO;
    }
 
    public void settotalPlaneamientoPI (Double i){
        totalPlaneamientoPI.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoPI (){
        return totalPlaneamientoPI;
    }
    public void settotalPlaneamientoMT (Double i){
        totalPlaneamientoMT.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoMT (){
        return totalPlaneamientoMT;
    } 
    
    public void settotalPlaneamientoPA (Double i){
        totalPlaneamientoPA.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPlaneamientoPA (){
        return totalPlaneamientoPA;
    } 
    
    public void settotalSP (Double i){
        totalSP.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalSP (){
        return totalSP;
    }
    
    public void settotalMS (Double i){
        totalMS.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalMS (){
        return totalMS;
    }
    
    public void settotalPR (Double i){
        totalPR.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPR (){
        return totalPR;
    }
    
    public void settotalSC (Double i){
        totalSC.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalSC (){
        return totalSC;
    }
    
    public void settotalRS (Double i){
        totalRS.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalRS (){
        return totalRS;
    }
    
    public void settotalGO (Double i){
        totalGO.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalGO (){
        return totalGO;
    }
    public void settotalMG (Double i){
        totalMG.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalMG (){
        return totalMG;
    }
    
    public void settotalMA (Double i){
        totalMA.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalMA (){
        return totalMA;
    }
    
    public void settotalBA (Double i){
        totalBA.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalBA (){
        return totalBA;
    }
    
    public void settotalRO (Double i){
        totalRO.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalRO (){
        return totalRO;
    }
    
    public void settotalTO (Double i){
        totalTO.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalTO (){
        return totalTO;
    }
 
    public void settotalPI (Double i){
        totalPI.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPI (){
        return totalPI;
    }
    public void settotalMT (Double i){
        totalMT.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalMT (){
        return totalMT;
    }
    
    public void settotalPA (Double i){
        totalPA.Sacas__c = i;
    }
    
    public CRM_Area_de_Atuacion__c gettotalPA (){
        return totalPA;
    }
    
    public void setoptionsAddNuevoEvento (List<SelectOption> i){
        optionsAddNuevoEvento = i;
    }
    
    public List<SelectOption> getoptionsAddNuevoEvento (){
        return optionsAddNuevoEvento;
    }
    
    public void setoptionsEditNuevoEvento (List<SelectOption> i){
        optionsEditNuevoEvento = i;
    }
    
    public List<SelectOption> getoptionsEditNuevoEvento (){
        return optionsEditNuevoEvento;
    }
    
    public void setoptionsEditOutros (List<SelectOption> i){
        optionsEditOutros = i;
    }
    
    public List<SelectOption> getoptionsEditOutros (){
        return optionsEditOutros;
    }
    
    public void setoptionsNewOutros (List<SelectOption> i){
        optionsNewOutros = i;
    }
    
    public List<SelectOption> getoptionsNewOutros (){
        return optionsNewOutros;
    }
    
    public void setarea_atuacion (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion = i;
    }
    
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion (){
        return area_atuacion;
    }
    
    public void setarea_atuacion_RS (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_RS = i;
    }
    
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_RS (){
        return area_atuacion_RS;
    }
    
    public void setarea_atuacion_SC (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_SC = i;
    }
    
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_SC (){
        return area_atuacion_SC;
    }
    
    public void setarea_atuacion_PR (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_PR = i;
    }
    
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_PR (){
        return area_atuacion_PR;
    }
    
    public void setarea_atuacion_MS (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_MS = i;
    }
    
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_MS (){
        return area_atuacion_MS;
    }
    
    public void setarea_atuacion_SP (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_SP = i;
    }
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_SP (){
        return area_atuacion_SP;
    }
    
    public void setarea_atuacion_GO (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_GO = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_GO (){
        return area_atuacion_GO;
    }
    
    public void setarea_atuacion_MG (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_MG = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_MG (){
        return area_atuacion_MG;
    }
    
    public void setarea_atuacion_MA (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_MA = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_MA (){
        return area_atuacion_MA;
    }   

    public void setarea_atuacion_BA (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_BA = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_BA (){
        return area_atuacion_BA;
    }
    
    public void setarea_atuacion_RO (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_RO = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_RO (){
        return area_atuacion_RO;
    }
    
    public void setarea_atuacion_TO (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_TO = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_TO (){
        return area_atuacion_TO;
    }
    
    public void setarea_atuacion_PI (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_PI = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_PI (){
        return area_atuacion_PI;
    }
    
    public void setarea_atuacion_MT (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_MT = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_MT (){
        return area_atuacion_MT;
    }
    
    public void setarea_atuacion_PA (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_PA = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_PA (){
        return area_atuacion_PA;
    }
    
    public void setarea_atuacion_planeamiento (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento = i;
    }
    
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento (){
        return area_atuacion_planeamiento;
    }
    
    public void setarea_atuacion_planeamiento_RS (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_RS = i;
    }
    
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_RS (){
        return area_atuacion_planeamiento_RS;
    }
    
    public void setarea_atuacion_planeamiento_SC (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_SC = i;
    }
    
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_SC (){
        return area_atuacion_planeamiento_SC;
    }
    
    public void setarea_atuacion_planeamiento_PR (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_PR = i;
    }
    
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_PR (){
        return area_atuacion_planeamiento_PR;
    }
    
    public void setarea_atuacion_planeamiento_MS (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_MS = i;
    }
    
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_MS (){
        return area_atuacion_planeamiento_MS;
    }
    
    public void setarea_atuacion_planeamiento_SP (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_SP = i;
    }
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_SP (){
        return area_atuacion_planeamiento_SP;
    }
    
    public void setarea_atuacion_planeamiento_GO (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_GO = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_GO (){
        return area_atuacion_planeamiento_GO;
    }
    
    public void setarea_atuacion_planeamiento_MG (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_MG = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_MG (){
        return area_atuacion_planeamiento_MG;
    }
    
    public void setarea_atuacion_planeamiento_MA (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_MA = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_MA (){
        return area_atuacion_planeamiento_MA;
    }   

    public void setarea_atuacion_planeamiento_BA (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_BA = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_BA (){
        return area_atuacion_planeamiento_BA;
    }
    
    public void setarea_atuacion_planeamiento_RO (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_RO = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_RO (){
        return area_atuacion_planeamiento_RO;
    }
    
    public void setarea_atuacion_planeamiento_TO (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_TO = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_TO (){
        return area_atuacion_planeamiento_TO;
    }
    
    public void setarea_atuacion_planeamiento_PI (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_PI = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_PI (){
        return area_atuacion_planeamiento_PI;
    }
    
    public void setarea_atuacion_planeamiento_MT (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_MT = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_MT (){
        return area_atuacion_planeamiento_MT;
    }
    
    public void setarea_atuacion_planeamiento_PA (List<CRM_Area_de_Atuacion__c> i){
        area_atuacion_planeamiento_PA = i;
    }   
    public List<CRM_Area_de_Atuacion__c> getarea_atuacion_planeamiento_PA (){
        return area_atuacion_planeamiento_PA;
    }
    
    public void setnuevo_sacas_verticaliza (List<CRM_Vendas__c> i){
        nuevo_sacas_verticaliza = i;
    }
    
    public List<CRM_Vendas__c> getnuevo_sacas_verticaliza (){
        return nuevo_sacas_verticaliza;
    }
    
    public void setnuevo_sacas_compra_fora (List<CRM_Vendas__c> i){
        nuevo_sacas_compra_fora = i;
    }
    
    public List<CRM_Vendas__c> getnuevo_sacas_compra_fora (){
        return nuevo_sacas_compra_fora;
    }
    
    public void setsacas_compra_fora (List<CRM_Vendas__c> i){
        sacas_compra_fora = i;
    }
    
    public List<CRM_Vendas__c> getsacas_compra_fora (){
        return sacas_compra_fora;
    }
    
    public void setsacas_verticaliza (List<CRM_Vendas__c> i){
        sacas_verticaliza = i;
    }
    
    public List<CRM_Vendas__c> getsacas_verticaliza (){
        return sacas_verticaliza;
    }
    
    public void setsacas_outros (List<CRM_Vendas__c> i){
        sacas_outros = i;
    }
    
    public List<CRM_Vendas__c> getsacas_outros (){
        return sacas_outros;
    }
    
    public void setnuevo_sacas_outros (List<CRM_Vendas__c> i){
        nuevo_sacas_outros = i;
    }
    
    public List<CRM_Vendas__c> getnuevo_sacas_outros (){
        return nuevo_sacas_outros;
    }
    
    public void settotalPlaneamientoDMS (Double i){
        totalPlaneamientoDMS = i;
    }
    
    public String gettotalPlaneamientoDMS (){
        return formatDouble(Integer.ValueOF(totalPlaneamientoDMS),false);
    }
    
    public void settotalPlanInfCapPorUBS (Double i){
        totalPlanInfCapPorUBS = i;
    }
    
    public String gettotalPlanInfCapPorUBS (){
        return formatDouble(Integer.ValueOF(totalPlanInfCapPorUBS),false);
    }
    
    public void settotalPlanInfProdPorUBS (Double i){
        totalPlanInfProdPorUBS = i;
    }
    
    public String gettotalPlanInfProdPorUBS (){
        return formatDouble(Integer.ValueOF(totalPlanInfProdPorUBS),false);
    }
    
    public void settotalPlanInfCapPorEmpresa (Double i){
        totalPlanInfCapPorEmpresa = i;
    }
    
    public String gettotalPlanInfCapPorEmpresa (){
        return formatDouble(Integer.ValueOF(totalPlanInfCapPorEmpresa),false);
    }
    
    public void settotalPlanInfVolTPorEmpresa (Double i){
        totalPlanInfVolTPorEmpresa = i;
    }
    
    public String gettotalPlanInfVolTPorEmpresa (){
        return formatDouble(Integer.ValueOF(totalPlanInfVolTPorEmpresa),false);
    }
    
    public void settotalPlaneamientoBMX (Double i){
        totalPlaneamientoBMX = i;
    }
    
    public String gettotalPlaneamientoBMX (){
        return formatDouble(Integer.ValueOF(totalPlaneamientoBMX),false);
    }
    
    public void settotalPlaneamientoSacasCF (Double i){
        totalPlaneamientoSacasCF = i;
    }
    
    public String gettotalPlaneamientoSacasCF (){
        return formatDouble(Integer.ValueOF(totalPlaneamientoSacasCF),false);
    }
    
    public void settotalPlaneamientoSacasVerticaliza (Double i){
        totalPlaneamientoSacasVerticaliza = i;
    }
    
    public String gettotalPlaneamientoSacasVerticaliza (){
        return formatDouble(Integer.ValueOF(totalPlaneamientoSacasVerticaliza),false);
    }
    
    public void settotalPlaneamientoOutros (Double i){
        totalPlaneamientoOutros = i;
    }
    
    public String gettotalPlaneamientoOutros (){
        return formatDouble(Integer.ValueOF(totalPlaneamientoOutros),false);
    }
    
    public void settotalVentasOutros (Double i){
        totalVentasOutros = i;
    }
    
    public String gettotalVentasOutros (){
        return formatDouble(Integer.ValueOF(totalVentasOutros),false);
    }
    
    public void settotalVentasBMX (Double i){
        totalVentasBMX = i;
    }
    
    public String gettotalVentasBMX (){
        return formatDouble(Integer.ValueOF(totalVentasBMX),false);
    }
    
    public void settotalVentasDMS (Double i){
        totalVentasDMS = i;
    }
    
    public String gettotalVentasDMS (){
        return formatDouble(Integer.ValueOF(totalVentasDMS),false);
    }
    
    public void settotalVolProduzidoBMX (Double i){
        totalVolProduzidoBMX = i;
    }
    
    public String gettotalVolProduzidoBMX (){
        return formatDouble(Integer.ValueOF(totalVolProduzidoBMX),false);
    }
    
    public void settotalVolProduzidoDMS (Double i){
        totalVolProduzidoDMS = i;
    }
    
    public String gettotalVolProduzidoDMS (){
        return formatDouble(Integer.ValueOF(totalVolProduzidoDMS),false);
    }
    
    public void settotalVolProduzidoOutros (Double i){
        totalVolProduzidoOutros = i;
    }
    
    public String gettotalVolProduzidoOutros (){
        return formatDouble(Integer.ValueOF(totalVolProduzidoOutros),false);
    }
    
    public void settotalVolProduzidoSV (Double i){
        totalVolProduzidoSV = i;
    }
    
    public String gettotalVolProduzidoSV (){
        return formatDouble(Integer.ValueOF(totalVolProduzidoSV),false);
    }
    
    public void settotalVolProduzidoSCF (Double i){
        totalVolProduzidoSCF = i;
    }
    
    public String gettotalVolProduzidoSCF (){
        return formatDouble(Integer.ValueOF(totalVolProduzidoSCF),false);
    }
    
    public void seteditareaa (Id i){
        editareaa = i;
    }
    
    public Id geteditareaa (){
        return editareaa;
    }
    
    public void seteditpscf (String i){
        editpscf = i;
    }
    
    public String geteditpscf (){
        return editpscf;
    }
    
    public void seteditpsv (String i){
        editpsv = i;
    }
    
    public String geteditpsv (){
        return editpsv;
    }
    
    public void seteditpso (String i){
        editpso = i;
    }
    
    public String geteditpso (){
        return editpso;
    }
        
    public void seteditNewItemEvento (Integer i){
        editNewItemEvento = i;
    }
    
    public Integer geteditNewItemEvento (){
        return editNewItemEvento;
    }
        
    public void seteditso (String i){
        editso = i;
    }
    
    public String geteditso (){
        return editso;
    }
    
    public void seteditRegAreaA (String i){
        editRegAreaA = i;
    }
    
    public String geteditRegAreaA (){
        return editRegAreaA;
    }
    
    public void seteditscf (String i){
        editscf = i;
    }
    
    public String geteditscf (){
        return editscf;
    }
    
    public void seteditsv (String i){
        editsv = i;
    }
    
    public String geteditsv (){
        return editsv;
    }
    
    public void seteditVariedadBMX (String i){
        editVariedadBMX = i;
    }
    
    public String geteditVariedadBMX (){
        return editVariedadBMX;
    }
    
    public void seteditVariedadDMS (String i){
        editVariedadDMS = i;
    }
    
    public String geteditVariedadDMS (){
        return editVariedadDMS;
    }        
    
    public void seteditNuevoItemEvento (Product2 i){
        editNuevoItemEvento = i;
    }
    
    public Product2 geteditNuevoItemEvento (){
        return editNuevoItemEvento;
    }
    
    public void setaddNuevoItemEvento (Product2 i){
        addNuevoItemEvento = i;
    }
    
    public Product2 getaddNuevoItemEvento (){
        return addNuevoItemEvento;
    }
    
    public void seteditSacasO (Product2 i){
        editSacasO = i;
    }
    
    public Product2 geteditSacasO (){
        return editSacasO;
    }
    
    public void seteditSacasV (Product2 i){
        editSacasV = i;
    }
    
    public Product2 geteditSacasV (){
        return editSacasV;
    }
    
    public void seteditSacasCF (Product2 i){
        editSacasCF = i;
    }
    
    public Product2 geteditSacasCF (){
        return editSacasCF;
    }
    
    public void setnuevaSacasO (Product2 i){
        nuevaSacasO = i;
    }
    
    public Product2 getnuevaSacasO (){
        return nuevaSacasO;
    }
    
    public void setnuevaSacasCF (Product2 i){
        nuevaSacasCF = i;
    }
    
    public Product2 getnuevaSacasCF (){
        return nuevaSacasCF;
    }
    
    public void setnuevaSacasV (Product2 i){
        nuevaSacasV = i;
    }
    
    public Product2 getnuevaSacasV (){
        return nuevaSacasV;
    }
    
    public void seteditProdOutros (String i){
        editProdOutros = i;
    }
    
    public String geteditProdOutros (){
        return editProdOutros;
    }
    
    public void setnuevoProdOutros (String i){
        nuevoProdOutros = i;
    }
    
    public String getnuevoProdOutros (){
        return nuevoProdOutros;
    }
    
    public void setnuevaVariedadDMS (String i){
        nuevaVariedadDMS = i;
    }
    
    public String getnuevaVariedadDMS (){
        return nuevaVariedadDMS;
    }
    
    public void setnuevaVariedadBMX (String i){
        nuevaVariedadBMX = i;
    }
    
    public String getnuevaVariedadBMX (){
        return nuevaVariedadBMX;
    }
        
    public void setnuevo_planeamiento_sacas_outros (List<CRM_Vendas__c> i){
        nuevo_planeamiento_sacas_outros = i;
    }
    
    public List<CRM_Vendas__c> getnuevo_planeamiento_sacas_outros (){
        return nuevo_planeamiento_sacas_outros;
    }
    
    public void setnuevo_planeamiento_BMX (List<CRM_Vendas__c> i){
        nuevo_planeamiento_BMX = i;
    }
    
    public List<CRM_Vendas__c> getnuevo_planeamiento_BMX (){
        return nuevo_planeamiento_BMX;
    }
    
    public void setnuevo_planeamiento_DMS (List<CRM_Vendas__c> i){
        nuevo_planeamiento_DMS = i;
    }
    
    public List<CRM_Vendas__c> getnuevo_planeamiento_DMS (){
        return nuevo_planeamiento_DMS;
    }
    
    public void setnuevo_planeamiento_sacas_compra_fora (List<CRM_Vendas__c> i){
        nuevo_planeamiento_sacas_compra_fora = i;
    }
    
    public List<CRM_Vendas__c> getnuevo_planeamiento_sacas_compra_fora (){
        return nuevo_planeamiento_sacas_compra_fora;
    }
    
    public void setnuevo_planeamiento_sacas_verticaliza (List<CRM_Vendas__c> i){
        nuevo_planeamiento_sacas_verticaliza = i;
    }
    
    public List<CRM_Vendas__c> getnuevo_planeamiento_sacas_verticaliza (){
        return nuevo_planeamiento_sacas_verticaliza;
    }
    
    public void setnuevo_ventas_DMS (List<CRM_Vendas__c> i){
        nuevo_ventas_DMS = i;
    }
    
    public List<CRM_Vendas__c> getnuevo_ventas_DMS (){
        return nuevo_ventas_DMS;
    }
    
    public void setnuevo_ventas_BMX (List<CRM_Vendas__c> i){
        nuevo_ventas_BMX = i;
    }
    
    public List<CRM_Vendas__c> getnuevo_ventas_BMX (){
        return nuevo_ventas_BMX;
    }
    
    public void setventas (List<CRM_Vendas__c> i){
        ventas = i;
    }
    
    public List<CRM_Vendas__c> getventas (){
        return ventas;
    }
    
    public void setplaneamiento_sacas_compra_fora (List<CRM_Vendas__c> i){
        planeamiento_sacas_compra_fora = i;
    }
    
    public List<CRM_Vendas__c> getplaneamiento_sacas_compra_fora (){
        return planeamiento_sacas_compra_fora;
    }
    
    public void setplaneamiento_sacas_verticaliza (List<CRM_Vendas__c> i){
        planeamiento_sacas_verticaliza = i;
    }
    
    public List<CRM_Vendas__c> getplaneamiento_sacas_verticaliza (){
        return planeamiento_sacas_verticaliza;
    }
    
    public void setplaneamiento_sacas_outros (List<CRM_Vendas__c> i){
        planeamiento_sacas_outros = i;
    }
    
    public List<CRM_Vendas__c> getplaneamiento_sacas_outros (){
        return planeamiento_sacas_outros;
    }
    
    public void setplaneamiento_BMX (List<CRM_Vendas__c> i){
        planeamiento_BMX = i;
    }
    
    public List<CRM_Vendas__c> getplaneamiento_BMX (){
        return planeamiento_BMX;
    }
    
    public void setplaneamiento_DMS (List<CRM_Vendas__c> i){
        planeamiento_DMS = i;
    }
    
    public List<CRM_Vendas__c> getplaneamiento_DMS (){
        return planeamiento_DMS;
    }
    
    public void setventas_BMX (List<CRM_Vendas__c> i){
        ventas_BMX = i;
    }
    
    public List<CRM_Vendas__c> getventas_BMX (){
        return ventas_BMX;
    }
    
    public void setventas_DMS (List<CRM_Vendas__c> i){
        ventas_DMS = i;
    }
    
    public List<CRM_Vendas__c> getventas_DMS (){
        return ventas_DMS;
    }
    
    public void setestadoEditCal (String i){
        estadoEditCal = i;
    }
    
    public String getestadoEditCal (){
        return estadoEditCal;
    }
        
    public void setestadoNewCal (String i){
        estadoNewCal = i;
    }
    
    public String getestadoNewCal (){
        return estadoNewCal;
    }
    
    public void setadicionar_sacas_cf (Boolean i){
        adicionar_sacas_cf = i;
    }
    
    public Boolean getadicionar_sacas_cf (){
        return adicionar_sacas_cf;
    }
    
    public void setadicionar_p_sacas_cf (Boolean i){
        adicionar_p_sacas_cf = i;
    }
    
    public Boolean getadicionar_p_sacas_cf (){
        return adicionar_p_sacas_cf;
    }
    
    public void setadicionar_p_sacas_v (Boolean i){
        adicionar_p_sacas_v = i;
    }
    
    public Boolean getadicionar_p_sacas_v (){
        return adicionar_p_sacas_v;
    }
    
    public void setadicionar_p_sacas_o (Boolean i){
        adicionar_p_sacas_o = i;
    }
    
    public Boolean getadicionar_p_sacas_o (){
        return adicionar_p_sacas_o;
    }
    
    public void setadicionar_sacas_o (Boolean i){
        adicionar_sacas_o = i;
    }
    
    public Boolean getadicionar_sacas_o (){
        return adicionar_sacas_o;
    }
    
    public void setadicionar_sacas_v (Boolean i){
        adicionar_sacas_v = i;
    }
    
    public Boolean getadicionar_sacas_v (){
        return adicionar_sacas_v;
    }
    
    public void seteditTotalSacasCF (Boolean i){
        editTotalSacasCF = i;
    }
    
    public Boolean geteditTotalSacasCF (){
        return editTotalSacasCF;
    }
    
    public void seteditTotalSacasV (Boolean i){
        editTotalSacasV = i;
    }
    
    public Boolean geteditTotalSacasV (){
        return editTotalSacasV;
    }
    
    public void seteditDatosBonifBRMX (Boolean i){
        editDatosBonifBRMX = i;
    }
    
    public Boolean geteditDatosBonifBRMX (){
        return editDatosBonifBRMX;
    }
    
    public void seteditDatosBonifDSEM (Boolean i){
        editDatosBonifDSEM = i;
    }
    
    public Boolean geteditDatosBonifDSEM (){
        return editDatosBonifDSEM;
    }
    
    public void setadicionar_inf_F (Boolean i){
        adicionar_inf_F = i;
    }
    
    public Boolean getadicionar_inf_F (){
        return adicionar_inf_F;
    }
    
    public void setadicionar_inf_B (Boolean i){
        adicionar_inf_B = i;
    }
    
    public Boolean getadicionar_inf_B (){
        return adicionar_inf_B;
    }
    
    public void setadicionar_planeamiento_BMX (Boolean i){
        adicionar_planeamiento_BMX = i;
    }
    
    public Boolean getadicionar_planeamiento_BMX (){
        return adicionar_planeamiento_BMX;
    }
    
    public void setadicionar_planeamiento_DMS (Boolean i){
        adicionar_planeamiento_DMS = i;
    }
    
    public Boolean getadicionar_planeamiento_DMS (){
        return adicionar_planeamiento_DMS;
    }
    
    public void setadicionar_venta_DMS (Boolean i){
        adicionar_venta_DMS = i;
    }
    
    public Boolean getadicionar_venta_DMS (){
        return adicionar_venta_DMS;
    }
    
    public void setadicionar_venta_BMX (Boolean i){
        adicionar_venta_BMX = i;
    }
    
    public Boolean getadicionar_venta_BMX (){
        return adicionar_venta_BMX;
    }
    
    public void setadicionar_plan_inf_A (Boolean i){
        adicionar_plan_inf_A = i;
    }
    
    public Boolean getadicionar_plan_inf_A (){
        return adicionar_plan_inf_A;
    }
    
    public void setadicionar_plan_inf_B (Boolean i){
        adicionar_plan_inf_B = i;
    }
    
    public Boolean getadicionar_plan_inf_B (){
        return adicionar_plan_inf_B;
    }
    
    public void setadicionar_plan_inf_F (Boolean i){
        adicionar_plan_inf_F = i;
    }
    
    public Boolean getadicionar_plan_inf_F (){
        return adicionar_plan_inf_F;
    }
    
    public void setadicionar_plan_inf_G (Boolean i){
        adicionar_plan_inf_G = i;
    }
    
    public Boolean getadicionar_plan_inf_G (){
        return adicionar_plan_inf_G;
    }
    
    public void setadicionar_inf_A (Boolean i){
        adicionar_inf_A = i;
    }
    
    public Boolean getadicionar_inf_A (){
        return adicionar_inf_A;
    }
    
    public void setadicionar_inf_G (Boolean i){
        adicionar_inf_G = i;
    }
    
    public Boolean getadicionar_inf_G (){
        return adicionar_inf_G;
    }
    
    public void seteditCanalDeVendas (Boolean i){
        editCanalDeVendas = i;
    }
    
    public Boolean geteditCanalDeVendas (){
        return editCanalDeVendas;
    }
    
    public void seteditarVendas (Boolean i){
        editarVendas = i;
    }
    
    public Boolean geteditarVendas (){
        return editarVendas;
    }
    
    public void setvendas (CRM_Multiplicador__c i){
        vendas = i;
    }
    
    public CRM_Multiplicador__c getvendas (){
        return vendas;
    }
    
    public void setcanal_de_vendas (CRM_Multiplicador__c i){
        canal_de_vendas = i;
    }
    
    public CRM_Multiplicador__c getcanal_de_vendas (){
        return canal_de_vendas;
    }
    
    public void setsaveedit_sacas_cf (Id i){
        saveedit_sacas_cf = i;
    }
    
    public Id getsaveedit_sacas_cf (){
        return saveedit_sacas_cf;
    }
    
    public void setsaveedit_p_sacas_cf (Id i){
        saveedit_p_sacas_cf = i;
    }
    
    public Id getsaveedit_p_sacas_cf (){
        return saveedit_p_sacas_cf;
    }
    
    public void setsaveedit_p_sacas_v (Id i){
        saveedit_p_sacas_v = i;
    }
    
    public Id getsaveedit_p_sacas_v (){
        return saveedit_p_sacas_v;
    }
    
    public void setsaveedit_p_sacas_o (Id i){
        saveedit_p_sacas_o = i;
    }
    
    public Id getsaveedit_p_sacas_o (){
        return saveedit_p_sacas_o;
    }
    
    public void setsaveedit_sacas_o (Id i){
        saveedit_sacas_o = i;
    }
    
    public Id getsaveedit_sacas_o (){
        return saveedit_sacas_o;
    }
    
    public void setsaveedit_sacas_v (Id i){
        saveedit_sacas_v = i;
    }
    
    public Id getsaveedit_sacas_v (){
        return saveedit_sacas_v;
    }
    
    public void setsaveedit_planeamiento_bmx (Id i){
        saveedit_planeamiento_bmx = i;
    }
    
    public Id getsaveedit_planeamiento_bmx (){
        return saveedit_planeamiento_bmx;
    }
    
    public void setsaveedit_planeamiento_dms (Id i){
        saveedit_planeamiento_dms = i;
    }
    
    public Id getsaveedit_planeamiento_dms (){
        return saveedit_planeamiento_dms;
    }
    
    public void setsaveedit_venta_bmx (Id i){
        saveedit_venta_bmx = i;
    }
    
    public Id getsaveedit_venta_bmx (){
        return saveedit_venta_bmx;
    }
    
    public void setsaveedit_venta_dms (Id i){
        saveedit_venta_dms = i;
    }
    
    public Id getsaveedit_venta_dms (){
        return saveedit_venta_dms;
    }
    
    public void seteliminar_sacas_cf (Id i){
        eliminar_sacas_cf = i;
    }
    
    public Id geteliminar_sacas_cf (){
        return eliminar_sacas_cf;
    }
    
    public void seteliminar_p_sacas_cf (Id i){
        eliminar_p_sacas_cf = i;
    }
    
    public Id geteliminar_p_sacas_cf (){
        return eliminar_p_sacas_cf;
    }
    
    public void seteliminar_p_sacas_v (Id i){
        eliminar_p_sacas_v = i;
    }
    
    public Id geteliminar_p_sacas_v (){
        return eliminar_p_sacas_v;
    }
    
    public void seteliminar_p_sacas_o (Id i){
        eliminar_p_sacas_o = i;
    }
    
    public Id geteliminar_p_sacas_o (){
        return eliminar_p_sacas_o;
    }
    
    public void seteliminar_sacas_o (Id i){
        eliminar_sacas_o = i;
    }
    
    public Id geteliminar_sacas_o (){
        return eliminar_sacas_o;
    }
    
    public void seteliminar_sacas_v (Id i){
        eliminar_sacas_v = i;
    }
    
    public Id geteliminar_sacas_v (){
        return eliminar_sacas_v;
    }
    
    public void seteliminar_venta_DMS (Id i){
        eliminar_venta_DMS = i;
    }
    
    public Id geteliminar_venta_DMS (){
        return eliminar_venta_DMS;
    }
    
    public void seteliminar_venta_BMX (Id i){
        eliminar_venta_BMX = i;
    }
    
    public Id geteliminar_venta_BMX (){
        return eliminar_venta_BMX;
    }
    
    public void seteliminar_planeamiento_BMX (Id i){
        eliminar_planeamiento_BMX = i;
    }
    
    public Id geteliminar_planeamiento_BMX (){
        return eliminar_planeamiento_BMX;
    }
    
    public void seteliminar_planeamiento_DMS (Id i){
        eliminar_planeamiento_DMS = i;
    }
    
    public Id geteliminar_planeamiento_DMS (){
        return eliminar_planeamiento_DMS;
    }
    
    public void seteliminarCalendario (Id i){
        eliminarCalendario = i;
    }
    
    public Id geteliminarCalendario (){
        return eliminarCalendario;
    }
    
    public void setelim_areaa (String i){
        elim_areaa = i;
    }
    
    public String getelim_areaa (){
        return elim_areaa;
    }
    
    public void seteditCalendario (Id i){
        editCalendario = i;
    }
    
    public Id geteditCalendario (){
        return editCalendario;
    }
    
    public void setelimInfr (Id i){
        elimInfr = i;
    }
    
    public Id getelimInfr (){
        return elimInfr;
    }
    
    public void seteditpdms (Id i){
        editpdms = i;
    }
    
    public Id geteditpdms (){
        return editpdms;
    }
    
    public void seteditpbmx (Id i){
        editpbmx = i;
    }
    
    public Id geteditpbmx (){
        return editpbmx;
    }
    
    public void seteditvbmx (Id i){
        editvbmx = i;
    }
    
    public Id geteditvbmx (){
        return editvbmx;
    }
    
    public void seteditvdms (Id i){
        editvdms = i;
    }
    
    public Id geteditvdms (){
        return editvdms;
    }
    
    public void seteditInfrA (Id i){
        editInfrA = i;
    }
    
    public Id geteditInfrA (){
        return editInfrA;
    }
    
    public void seteditInfrG (Id i){
        editInfrG = i;
    }
    
    public Id geteditInfrG (){
        return editInfrG;
    }
    
    public void seteditInfrF (Id i){
        editInfrF = i;
    }
    
    public Id geteditInfrF (){
        return editInfrF;
    }
    
    public void seteditInfrB (Id i){
        editInfrB = i;
    }
    
    public Id geteditInfrB (){
        return editInfrB;
    }
    
    public void seteditPInfrC (Boolean i){
        editPInfrC = i;
    }
    
    public Boolean geteditPInfrC (){
        return editPInfrC;
    }
    
    public void seteditPInfrD (Boolean i){
        editPInfrD = i;
    }
    
    public Boolean geteditPInfrD (){
        return editPInfrD;
    }
    
    public void seteditPInfrE (Boolean i){
        editPInfrE = i;
    }
    
    public Boolean geteditPInfrE (){
        return editPInfrE;
    }
    
    public void seteditInfrC (Boolean i){
        editInfrC = i;
    }
    
    public Boolean geteditInfrC (){
        return editInfrC;
    }
    
    public void seteditInfrD (Boolean i){
        editInfrD = i;
    }
    
    public Boolean geteditInfrD (){
        return editInfrD;
    }
    
    public void seteditInfrE (Boolean i){
        editInfrE = i;
    }
    
    public Boolean geteditInfrE (){
        return editInfrE;
    }
    
    public void setnuevo_calendario(CRM_Calendario_de_Eventos__c a){
        nuevo_calendario = a;
    }
    
    public CRM_Calendario_de_Eventos__c getnuevo_calendario(){
        return nuevo_calendario;
    }
    
    public void setcalendario(List<CRM_Calendario_de_Eventos__c> a){
        calendario = a;
    }
    
    public List<CRM_Calendario_de_Eventos__c> getcalendario(){
        return calendario;
    }
    
    public void setplan_infraestructura_A(List<CRM_Infraestructura__c> a){
        plan_infraestructura_A = a;
    }
    
    public List<CRM_Infraestructura__c> getplan_infraestructura_A(){
        return plan_infraestructura_A;
    }
    
    public void setplan_infraestructura_B(List<CRM_Infraestructura__c> a){
        plan_infraestructura_B = a;
    }
    
    public List<CRM_Infraestructura__c> getplan_infraestructura_B(){
        return plan_infraestructura_B;
    }
    
    public void setplan_infraestructura_F(List<CRM_Infraestructura__c> a){
        plan_infraestructura_F = a;
    }
    
    public List<CRM_Infraestructura__c> getplan_infraestructura_F(){
        return plan_infraestructura_F;
    }
       
    public void setplan_infraestructura_G(List<CRM_Infraestructura__c> a){
        plan_infraestructura_G = a;
    }
    
    public List<CRM_Infraestructura__c> getplan_infraestructura_G(){
        return plan_infraestructura_G;
    }
    
    public void setinfraestructura_A(List<CRM_Infraestructura__c> a){
        infraestructura_A = a;
    }
    
    public List<CRM_Infraestructura__c> getinfraestructura_A(){
        return infraestructura_A;
    }
    
    public void setnuevo_plan_infraestructura_A(List<CRM_Infraestructura__c> a){
        nuevo_plan_infraestructura_A = a;
    }
    
    public List<CRM_Infraestructura__c> getnuevo_plan_infraestructura_A(){
        return nuevo_plan_infraestructura_A;
    }
    
    public void setnuevo_plan_infraestructura_B(List<CRM_Infraestructura__c> a){
        nuevo_plan_infraestructura_B = a;
    }
    
    public List<CRM_Infraestructura__c> getnuevo_plan_infraestructura_B(){
        return nuevo_plan_infraestructura_B;
    }
    
    public void setnuevo_plan_infraestructura_F(List<CRM_Infraestructura__c> a){
        nuevo_plan_infraestructura_F = a;
    }
    
    public List<CRM_Infraestructura__c> getnuevo_plan_infraestructura_F(){
        return nuevo_plan_infraestructura_F;
    }
    
    public void setnuevo_plan_infraestructura_G(List<CRM_Infraestructura__c> a){
        nuevo_plan_infraestructura_G = a;
    }
    
    public List<CRM_Infraestructura__c> getnuevo_plan_infraestructura_G(){
        return nuevo_plan_infraestructura_G;
    }
    
    public void setnuevo_infraestructura_A(List<CRM_Infraestructura__c> a){
        nuevo_infraestructura_A = a;
    }
    
    public List<CRM_Infraestructura__c> getnuevo_infraestructura_A(){
        return nuevo_infraestructura_A;
    }

    public List<CRM_Infraestructura__c> getnuevo_infraestructura_G(){
        return nuevo_infraestructura_G;
    }
    
    public void setnuevo_infraestructura_B(List<CRM_Infraestructura__c> b){
        nuevo_infraestructura_B = b;
    }
    
    public List<CRM_Infraestructura__c> getnuevo_infraestructura_B(){
        return nuevo_infraestructura_B;
    }
    
    public void setinfraestructura_F(List<CRM_Infraestructura__c> b){
        infraestructura_F = b;
    }
    
    public List<CRM_Infraestructura__c> getinfraestructura_F(){
        return infraestructura_F;
    }
    
    public void setnuevo_infraestructura_F(List<CRM_Infraestructura__c> b){
        nuevo_infraestructura_F = b;
    }
    
    public List<CRM_Infraestructura__c> getnuevo_infraestructura_F(){
        return nuevo_infraestructura_F;
    }
    
    public void setinfraestructura_B(List<CRM_Infraestructura__c> b){
        infraestructura_B = b;
    }
    
    public List<CRM_Infraestructura__c> getinfraestructura_B(){
        return infraestructura_B;
    }
    
    public void setinfraestructura_C(CRM_Multiplicador__c c){
        infraestructura_C = c;
    }
    
    public CRM_Multiplicador__c getinfraestructura_C(){
        return infraestructura_C;
    }
    
    public void setinfraestructura_D(CRM_Multiplicador__c d){
        infraestructura_D = d;
    }
    
    public CRM_Multiplicador__c getinfraestructura_D(){
        return infraestructura_D;
    }
    
    public void setinfraestructura_E(CRM_Multiplicador__c e){
        infraestructura_E = e;
    }
    
    public CRM_Multiplicador__c getinfraestructura_E(){
        return infraestructura_E;
    }
    
    public List<CRM_Infraestructura__c> getinfraestructura_G(){
        return infraestructura_G;
    }
    
    public void setnuevo_infraestructura_G(List<CRM_Infraestructura__c> b){
        nuevo_infraestructura_G = b;
    }
    
    public void initPlanejamientoInfr(){
        
        plan_infraestructura_A = New List<CRM_Infraestructura__c>();
        plan_infraestructura_B = New List<CRM_Infraestructura__c>();
        plan_infraestructura_F = New List<CRM_Infraestructura__c>();
        plan_infraestructura_G = New List<CRM_Infraestructura__c>();
        
        totalCanalVendas = 0;
        
        //crm_mult = New CRM_Multiplicador__c();
                
        String qry = '';
        
        this.accId = ApexPages.currentPage().getParameters().get('id');
        this.nombre_cuenta = ApexPages.currentPage().getParameters().get('nombre');
        campania = '12/13';
        
        Configuracion_BMX__c conf = new Configuracion_BMX__c();
        conf = [Select Id, CRM_Safra_Siguiente__c From Configuracion_BMX__c limit 1];
        if(conf.CRM_Safra_Siguiente__c != null) campania = conf.CRM_Safra_Siguiente__c;
        
        if (this.accId != null){
            qry = 'Select ';
            for(String s : objectFields_CRM_Mult.keySet())
                qry += ' ' + s + ',';                           
                            
            qry = qry.substring(0,qry.length() - 1);
            qry += ' From CRM_Multiplicador__c Where Cuenta__c = \'' + accId + '\''; 
            qry += ' And Safra__c = \'' + this.campania + '\' limit 1';
               
            List<CRM_Multiplicador__c> result = New List<CRM_Multiplicador__c>(); 
            result = database.query(qry);
            if (result.size() > 0)
                crm_mult = result[0];   
        
            if (crm_mult != null && crm_mult.Id != null){
                qry = 'Select ';
                for(String s : objectFields_CRM_Inf.keySet())
                    qry += ' ' + s + ', ';
                
                qry += 'RecordType.Name From CRM_Infraestructura__c Where CRM_Multiplicador__c = \'' + crm_mult.Id + '\'';                  
                           
                plan_infraestructura = database.query(qry);                           
            
                for (CRM_Infraestructura__c c : plan_infraestructura){
                    if (c.RecordType.Name == 'P_A')
                        plan_infraestructura_A.add(c);  
                    if (c.RecordType.Name == 'P_B')               
                        plan_infraestructura_B.add(c);                    
                    if (c.RecordType.Name == 'P_F')               
                        plan_infraestructura_F.add(c);
                    if (c.RecordType.Name == 'P_G')               
                        plan_infraestructura_G.add(c);   
                            
                }
            }                                                       
                
        }
        
        CRM_Infraestructura__c nuevo_A = New CRM_Infraestructura__c();
        nuevo_plan_infraestructura_A = New List<CRM_Infraestructura__c>();
        nuevo_plan_infraestructura_A.add(nuevo_A);
        
        CRM_Infraestructura__c nuevo_B = New CRM_Infraestructura__c();
        nuevo_plan_infraestructura_B = New List<CRM_Infraestructura__c>();
        nuevo_plan_infraestructura_B.add(nuevo_B);   
        
        CRM_Infraestructura__c nuevo_F = New CRM_Infraestructura__c();
        nuevo_plan_infraestructura_F = New List<CRM_Infraestructura__c>();
        nuevo_plan_infraestructura_F.add(nuevo_F);
        
        CRM_Infraestructura__c nuevo_G = New CRM_Infraestructura__c();
        nuevo_plan_infraestructura_G = New List<CRM_Infraestructura__c>();
        nuevo_plan_infraestructura_G.add(nuevo_G);
        for(Cidade__c c : [SELECT Id, Regi_o__c FROM Cidade__c WHERE Regi_o__c != null])
            ciudades.put(c.Id, c.Regi_o__c);
        
        sumarizar_plan_infr();
        
    }
    
    public void init(){
        
        infraestructura_A = New List<CRM_Infraestructura__c>();
        infraestructura_B = New List<CRM_Infraestructura__c>();
        infraestructura_F = New List<CRM_Infraestructura__c>();
        infraestructura_G = New List<CRM_Infraestructura__c>();
        
        totalCanalVendas = 0;
        
        //crm_mult = New CRM_Multiplicador__c();
                
        String qry = '';
        
        this.accId = ApexPages.currentPage().getParameters().get('id');
        this.nombre_cuenta = ApexPages.currentPage().getParameters().get('nombre');
        campania = '12/13';
        Configuracion_BMX__c conf = new Configuracion_BMX__c();
        conf = [Select Id, CRM_Safra_Actual__c From Configuracion_BMX__c limit 1];
        if(conf.CRM_Safra_Actual__c != null) campania = conf.CRM_Safra_Actual__c;
        if (this.accId != null){
            qry = 'Select ';
            for(String s : objectFields_CRM_Mult.keySet())
                qry += ' ' + s + ',';                           
                            
            qry = qry.substring(0,qry.length() - 1);
            qry += ' From CRM_Multiplicador__c Where Cuenta__c = \'' + accId + '\''; 
            qry += ' And Safra__c = \'' + this.campania + '\' limit 1';
               
            List<CRM_Multiplicador__c> result = New List<CRM_Multiplicador__c>(); 
            result = database.query(qry);
            if (result.size() > 0)
                crm_mult = result[0];   
            if (crm_mult != null && crm_mult.Id != null){
          
                qry = 'Select ';
                for(String s : objectFields_CRM_Inf.keySet())
                    qry += ' ' + s + ', ';
                
                qry += 'RecordType.Name From CRM_Infraestructura__c Where CRM_Multiplicador__c = \'' + crm_mult.Id + '\'';                  
                infraestructura = database.query(qry);    
                
            
                for (CRM_Infraestructura__c c : infraestructura){
 
                    if (c.RecordType.Name == 'A')
                        infraestructura_A.add(c);
                    if (c.RecordType.Name == 'B')               
                        infraestructura_B.add(c);
                    if (c.RecordType.Name == 'F')               
                        infraestructura_F.add(c);
                    if (c.RecordType.Name == 'G')               
                        infraestructura_G.add(c);
                            
                }
            }else{ 
                crear_crm_mult();
            }                                                       
                
        }
        
        CRM_Infraestructura__c nuevo_A = New CRM_Infraestructura__c();
        nuevo_infraestructura_A = New List<CRM_Infraestructura__c>();
        nuevo_infraestructura_A.add(nuevo_A);
        
        CRM_Infraestructura__c nuevo_B = New CRM_Infraestructura__c();
        nuevo_infraestructura_B = New List<CRM_Infraestructura__c>();
        nuevo_infraestructura_B.add(nuevo_B);   
        
        CRM_Infraestructura__c nuevo_F = New CRM_Infraestructura__c();
        nuevo_infraestructura_F = New List<CRM_Infraestructura__c>();
        nuevo_infraestructura_F.add(nuevo_F);
        
        CRM_Infraestructura__c nuevo_G = New CRM_Infraestructura__c();
        nuevo_infraestructura_G = New List<CRM_Infraestructura__c>();
        nuevo_infraestructura_G.add(nuevo_G);
        for(Cidade__c c : [SELECT Id, Regi_o__c FROM Cidade__c WHERE Regi_o__c != null])
            ciudades.put(c.Id, c.Regi_o__c);
        
        
    }
    
    public void initDatosBonificacion(){               
                               
        String qry = '';
        
        this.accId = ApexPages.currentPage().getParameters().get('id');
        this.nombre_cuenta = ApexPages.currentPage().getParameters().get('nombre');
        campania = '12/13';
        
        Configuracion_BMX__c conf = new Configuracion_BMX__c();
        conf = [Select Id, CRM_Safra_Siguiente__c From Configuracion_BMX__c limit 1];
        if(conf.CRM_Safra_Siguiente__c != null) campania = conf.CRM_Safra_Siguiente__c;
        
        if (this.accId != null){
            qry = 'Select ';
            for(String s : objectFields_CRM_Mult.keySet())
                qry += ' ' + s + ',';                           
                            
            qry = qry.substring(0,qry.length() - 1);
            qry += ' From CRM_Multiplicador__c Where Cuenta__c = \'' + accId + '\''; 
            qry += ' And Safra__c = \'' + this.campania + '\' limit 1';
               
            List<CRM_Multiplicador__c> result = New List<CRM_Multiplicador__c>(); 
            result = database.query(qry);
            if (result.size() > 0)
                crm_mult = result[0];                                                                            
                
        }                
                
    }
    
    public void initCanalVentas(){
    
        init();
        
        if (crm_mult!= null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Vendas Totais (Sacas de 40kg): ' + formatDouble(Integer.ValueOf(crm_mult.Ventas_Totales__c),false)); 
            ApexPages.addMessage(msg); 
            //ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.INFO, 'Totais em Canal de Vendas: ' + formatDouble(Integer.ValueOf(crm_mult.CV_Total__c),false)); 
            //ApexPages.addMessage(msg2);
            
            if(crm_mult.CV_Agricultores__c != null) totalCanalVendas = totalCanalVendas + crm_mult.CV_Agricultores__c;
            if(crm_mult.CV_Revendas__c != null) totalCanalVendas = totalCanalVendas + crm_mult.CV_Revendas__c;
            if(crm_mult.CV_Cooperadores__c != null) totalCanalVendas = totalCanalVendas + crm_mult.CV_Cooperadores__c;
            if(crm_mult.CV_Multiplicadores__c != null) totalCanalVendas = totalCanalVendas + crm_mult.CV_Multiplicadores__c;
            if(crm_mult.CV_Corretoras__c != null) totalCanalVendas = totalCanalVendas + crm_mult.CV_Corretoras__c;
            if(crm_mult.CV_Pool_de_Compras__c != null) totalCanalVendas = totalCanalVendas + crm_mult.CV_Pool_de_Compras__c;

            
            if(totalCanalVendas == 0) totalCanalVendas = 1;
            
        }   
        
    }
    
    public void initEditCalendario(){
        String editC = ApexPages.currentPage().getParameters().get('editCal');
        String qry = '';                
        
        qry = 'Select ';
        for(String s : objectFields_CRM_Calen.keySet())
            qry += ' ' + s + ', ';
                
        qry += 'Owner.Name, Cuenta__r.Name From CRM_Calendario_de_Eventos__c Where Id = \'' + editC + '\'';                   
                           
        ver_calendario = database.query(qry);
        
        //06012016 Lo agrego porq puede venir desde el link del reporte de eventos y no tiene la referencia para navegar por el CRM.
        if (this.accId == null){
            this.accId = ver_calendario.Cuenta__c;
            this.nombre_cuenta = ver_calendario.Cuenta__r.Name;
            this.campania = ver_calendario.Safra__c;
        }
        
        setearEstadoEditCalendario2();
        
        qry = 'Select ';
        for(String s : objectFields_CRM_Calen_Det.keySet())
            qry += ' ' + s + ', ';
            
        qry += 'CRM_Calendario_de_Eventos__r.Name From CRM_Detalle_Calendario_de_Eventos__c Where CRM_Calendario_de_Eventos__c = \'' + editC + '\'';
        
        ver_calendario_detalles = database.query(qry);
        
        editNewItemEvento = null;
        editVerCalendario = false;
        addNuevoItemEvento = New Product2();
        optionsAddNuevoEvento = new List<SelectOption>();
        
        Integer i = 0;
        for (CRM_Detalle_Calendario_de_eventos__c v : ver_calendario_detalles){
            v.Indice__c = i;
            i++;
        }
        
        if (ver_calendario.Evento__c == 'Día de Campo' || ver_calendario.Evento__c == 'Estação DONMARIO MAS' || ver_calendario.Evento__c == 'Tour dos Máximos Rendimentos' || ver_calendario.Evento__c == 'Feiras' || ver_calendario.Evento__c == 'Lado a Lado' || ver_calendario.Evento__c == 'Strip Test' || ver_calendario.Evento__c == 'Emplacamento' || ver_calendario.Evento__c == 'Treinamento' || ver_calendario.Evento__c == 'Palestra'){                                      
            ver_calendario_detalle = New List<CRM_Detalle_Calendario_de_eventos__c>();
            CRM_Detalle_Calendario_de_eventos__c nuevoDet = New CRM_Detalle_Calendario_de_eventos__c();
            ver_calendario_detalle.add(nuevoDet);
        }
        
        qry = 'Select Id, Name, Body, Description From Attachment Where ParentId = \'' + editC + '\'';
        ver_calendario_attachs = database.query(qry);
        i = 0;
        for (Attachment a : ver_calendario_attachs){
            a.Description = String.valueOf(i);
            i++;
        }
        
        //if (ver_calendario.Evento__c == 'Lado a Lado' || ver_calendario.Evento__c == 'Strip Test' || ver_calendario.Evento__c == 'Emplacamento'){                                     
            ver_calendario_attach = New List<Attachment>();
            Attachment att = New Attachment();
            ver_calendario_attach.add(att);
        //}        
        
    }
    
    public void initCalendario(){
        
        calendario = new List<CRM_Calendario_de_Eventos__c>();
        
        String qry = '';
        
        this.accId = ApexPages.currentPage().getParameters().get('id');
        campania = '16/17';

        Id devRecordTypeId = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByName().get('completo').getRecordTypeId();
        
        Configuracion_BMX__c conf = new Configuracion_BMX__c();
        conf = [Select Id, CRM_Safra_Siguiente__c From Configuracion_BMX__c limit 1];
        if(conf.CRM_Safra_Siguiente__c != null) campania = conf.CRM_Safra_Siguiente__c;
        
        if (this.accId != null){
            qry = 'Select ';
            for(String s : objectFields_CRM_Calen.keySet())
                qry += ' ' + s + ', ';
                
            qry += 'Owner.Name From CRM_Calendario_de_Eventos__c Where Cuenta__c = \'' + this.accId + '\''; 
            qry += ' And Safra__c = \'' + this.campania + '\' Order By Evento__c, Data_e_horario_inicio__c';           
                           
            calendario = database.query(qry);   
        }
        
        CRM_Calendario_de_Eventos__c nuevoC = New CRM_Calendario_de_Eventos__c();
        nuevo_calendario = New CRM_Calendario_de_Eventos__c(recordTypeId=devRecordTypeId);
        
        verItemsNewCalendario = false;
        nuevo_calendario_detalles = New List<CRM_Detalle_Calendario_de_eventos__c>();
        
        nuevo_calendario_attachs = New List<Attachment>();
        nuevo_calendario_attach = New List<Attachment>();
        Attachment att = New Attachment();
        nuevo_calendario_attach.add(att);
        
    }
    
    public void initVendas(){
        
        ventas = new List<CRM_Vendas__c>();
        ventas_BMX = new List<CRM_Vendas__c>();
        ventas_DMS = new List<CRM_Vendas__c>();
        sacas_verticaliza = new List<CRM_Vendas__c>();
        sacas_compra_fora = new List<CRM_Vendas__c>();
        sacas_outros = new List<CRM_Vendas__c>();
        List<CRM_Vendas__c> newVentas = new List<CRM_Vendas__c>();
        Map<String, CRM_Vendas__c> mapVendaVar = New Map<String, CRM_Vendas__c>();
        Map<String, Product2> variedad = New Map<String, Product2>();
        for(Product2 p : [Select Id, Variedade__r.Id, Categ__r.Name, Sociedad__c From Product2 Where Variedade__r.Id != null AND Categ__r.Name = 'BASICA' AND Variedade__r.Licenciada__c != true])
            if(!variedad.containsKey(String.ValueOf(p.Variedade__r.Id))) variedad.put(String.ValueOf(p.Variedade__r.Id), p);
        
        init();
        
        String qry = '';
        
        this.accId = ApexPages.currentPage().getParameters().get('id');
        campania = '12/13';
        
        Configuracion_BMX__c conf = new Configuracion_BMX__c();
        conf = [Select Id, CRM_Safra_Actual__c From Configuracion_BMX__c limit 1];
        if(conf.CRM_Safra_Actual__c != null) campania = conf.CRM_Safra_Actual__c;
        
        if (this.accId != null && crm_mult != null  && crm_mult.Id != null){
            qry = 'Select ';
            for(String s : objectFields_CRM_Vendas.keySet())
                qry += ' ' + s + ', ';                       
            
            qry += 'Variedad__r.Sociedad__c, RecordType.Name, Variedad__r.Variedade__r.Id From CRM_Vendas__c Where RecordType.Name In (\'B\',\'C\',\'D\',\'E\') And CRM_Multiplicador__c = \'' + crm_mult.Id + '\''; 
                           
            ventas = database.query(qry);
            
            for(CRM_Vendas__c v: ventas) if(!mapVendaVar.ContainsKey(String.ValueOf(v.Variedad__r.Variedade__r.Id))) mapVendaVar.put(String.ValueOf(v.Variedad__r.Variedade__r.Id), v);
            
            for(AggregateResult pr : [Select PricebookEntry.Product2.Variedade__c var, Sum(Semente_comercializada__c) Semente_comercializada__c From OpportunityLineItem Where Opportunity.AccountId = : this.accId AND Opportunity.RecordType.Name IN ('Anexo III', 'Anexo IV') AND Opportunity.StageName = 'Aprobada' AND Opportunity.Safra__c = :campania AND Opportunity.Owner.Profile.Name != 'Administrativo_licencias' And PricebookEntry.Product2.Variedade__r.Licenciada__c != true Group By PricebookEntry.Product2.Variedade__c]){               
                if(!mapVendaVar.ContainsKey((String)pr.get('var')) && (Double)pr.get('Semente_comercializada__c') != 0){                                        
                    CRM_Vendas__c newV = New CRM_Vendas__c(CRM_Multiplicador__c = crm_mult.Id, Cuenta__c = this.accId, Safra__c = campania, Variedad__c = variedad.get((String)pr.get('var')).Id, Volume__c = (Double)pr.get('Semente_comercializada__c'), Obtentor__c = variedad.get((String)pr.get('var')).Sociedad__c);
                    newVentas.add(newV);
                }else{
                    if(mapVendaVar.ContainsKey((String)pr.get('var')) && mapVendaVar.get((String)pr.get('var')).Volume__c != (Double)pr.get('Semente_comercializada__c')){
                        CRM_Vendas__c actV = mapVendaVar.get((String)pr.get('var'));
                        actV.Volume__c = (Double)pr.get('Semente_comercializada__c');
                        newVentas.add(actV);
                    }
                }
            }            
            if(newVentas != null && newVentas.Size() > 0){ 
                upsert newVentas; 
                actualizarAreaAtuacion(crm_mult.Id, null);
            }
                
            newVentas.clear();
            mapVendaVar.clear();
            ventas = database.query(qry);
            
            for(CRM_Vendas__c v: ventas) if(!mapVendaVar.ContainsKey(String.ValueOf(v.Variedad__r.Variedade__r.Id))) mapVendaVar.put(String.ValueOf(v.Variedad__r.Variedade__r.Id), v);
            
            for(AggregateResult pr : [Select PricebookEntry.Product2.Variedade__c var, Sum(Semente_aprovada__c) Semente_aprovada__c From OpportunityLineItem Where Opportunity.AccountId = : this.accId AND Opportunity.RecordType.Name IN ('Anexo III') AND Opportunity.StageName = 'Aprobada' AND Opportunity.Safra__c = :campania AND Opportunity.Owner.Profile.Name != 'Administrativo_licencias' And PricebookEntry.Product2.Variedade__r.Licenciada__c != true Group By PricebookEntry.Product2.Variedade__c]){               
                if(!mapVendaVar.ContainsKey((String)pr.get('var')) && (Double)pr.get('Semente_aprovada__c') != 0){                                      
                    CRM_Vendas__c newV = New CRM_Vendas__c(CRM_Multiplicador__c = crm_mult.Id, Cuenta__c = this.accId, Safra__c = campania, Variedad__c = variedad.get((String)pr.get('var')).Id, Volume_Produzido__c = (Double)pr.get('Semente_aprovada__c'), Obtentor__c = variedad.get((String)pr.get('var')).Sociedad__c);
                    newVentas.add(newV);
                }else{
                    if(mapVendaVar.ContainsKey((String)pr.get('var')) && mapVendaVar.get((String)pr.get('var')).Volume_Produzido__c != (Double)pr.get('Semente_aprovada__c')){
                        CRM_Vendas__c actV = mapVendaVar.get((String)pr.get('var'));
                        actV.Volume_Produzido__c = (Double)pr.get('Semente_aprovada__c');
                        newVentas.add(actV);
                    }
                }
            }            
            if(newVentas != null && newVentas.Size() > 0) 
                upsert newVentas; 
                
            newVentas.clear();
            
            ventas = database.query(qry);  
        }
        
        for (CRM_Vendas__c v : ventas){
            if (v.RecordType.Name == 'B' && v.Variedad__r.Sociedad__c == 'BRMX')
                ventas_BMX.add(v);
            if (v.RecordType.Name == 'B' && v.Variedad__r.Sociedad__c == 'DSEM')    
                ventas_DMS.add(v);              
            if (v.RecordType.Name == 'D')    
                sacas_verticaliza.add(v);    
            if (v.RecordType.Name == 'E')    
                sacas_compra_fora.add(v);    
            if (v.RecordType.Name == 'C')    
                sacas_outros.add(v);    
        }           
        
        CRM_Vendas__c nuevaV = New CRM_Vendas__c();
        CRM_Vendas__c nuevaV2 = New CRM_Vendas__c();
        CRM_Vendas__c nuevaV3 = New CRM_Vendas__c();
        CRM_Vendas__c nuevaV4 = New CRM_Vendas__c();
        CRM_Vendas__c nuevaV5 = New CRM_Vendas__c();
        nuevo_ventas_BMX = New List<CRM_Vendas__c>();
        nuevo_ventas_DMS = New List<CRM_Vendas__c>();
        nuevo_sacas_verticaliza = New List<CRM_Vendas__c>();
        nuevo_sacas_compra_fora = New List<CRM_Vendas__c>();
        nuevo_sacas_outros = New List<CRM_Vendas__c>();
        nuevo_ventas_BMX.add(nuevaV);   
        nuevo_ventas_DMS.add(nuevaV2);
        nuevo_sacas_verticaliza.add(nuevaV3);
        nuevo_sacas_compra_fora.add(nuevaV4);
        nuevo_sacas_outros.add(nuevaV5);
        
        sumarizar_ventas();
        
    }
    
    public void initPlaneamiento(){
                
        planeamiento_BMX = new List<CRM_Vendas__c>();
        planeamiento_DMS = new List<CRM_Vendas__c>();
        planeamiento_sacas_verticaliza = new List<CRM_Vendas__c>();
        planeamiento_sacas_compra_fora = new List<CRM_Vendas__c>();
        planeamiento_sacas_outros = new List<CRM_Vendas__c>();
        List<CRM_Vendas__c> newVentas = new List<CRM_Vendas__c>();
        Map<Id, CRM_Vendas__c> mapVendaVar = New Map<Id, CRM_Vendas__c>();
        Map<String, Product2> variedad = New Map<String, Product2>();
        for(Product2 p : [Select Id, Variedade__r.Id, Categ__r.Name, Sociedad__c From Product2 Where Variedade__r.Id != null AND Categ__r.Name = 'BASICA' AND Variedade__r.Licenciada__c != true])
            if(!variedad.containsKey(String.ValueOf(p.Variedade__r.Id))) variedad.put(String.ValueOf(p.Variedade__r.Id), p);
        
        init();
        
        String qry = '';
        
        this.accId = ApexPages.currentPage().getParameters().get('id');
        campania = '12/13';
        
        Configuracion_BMX__c conf = new Configuracion_BMX__c();
        conf = [Select Id, CRM_Safra_Siguiente__c From Configuracion_BMX__c limit 1];
        if(conf.CRM_Safra_Siguiente__c != null) campania = conf.CRM_Safra_Siguiente__c;
        
        if (this.accId != null && crm_mult != null  && crm_mult.Id != null){
            qry = 'Select ';
            for(String s : objectFields_CRM_Vendas.keySet())
                qry += ' ' + s + ', ';                       
            
            qry += 'Variedad__r.Sociedad__c, RecordType.Name, Variedad__r.Variedade__r.Id From CRM_Vendas__c Where CRM_Multiplicador__c = \'' + crm_mult.Id + '\''; 
                           
            ventas = database.query(qry);
            
            for(CRM_Vendas__c v: ventas) if(!mapVendaVar.ContainsKey(String.ValueOf(v.Variedad__r.Variedade__r.Id))) mapVendaVar.put(String.ValueOf(v.Variedad__r.Variedade__r.Id), v);
            
            /*for(AggregateResult pr : [Select PricebookEntry.Product2.Variedade__c var, Sum(Semente_comercializada__c) Semente_comercializada__c From OpportunityLineItem Where Opportunity.AccountId = : this.accId AND Opportunity.RecordType.Name IN ('Anexo III', 'Anexo IV') AND Opportunity.StageName = 'Aprobada' AND Opportunity.Safra__c = :campania AND Opportunity.Owner.Profile.Name != 'Administrativo_licencias' Group By PricebookEntry.Product2.Variedade__c]){
                //if(!mapVendaVar.ContainsKey(String.ValueOf(pr.PricebookEntry.Product2.Variedade__r.Id))){ (String)pr.get('Product2Id')
                if(!mapVendaVar.ContainsKey((String)pr.get('var')) && (Double)pr.get('Semente_comercializada__c') != 0){ 
                    CRM_Vendas__c newV = New CRM_Vendas__c(CRM_Multiplicador__c = crm_mult.Id, Cuenta__c = this.accId, Safra__c = campania, Variedad__c = variedad.get((String)pr.get('var')).Id, Volume__c = (Double)pr.get('Semente_comercializada__c'), Obtentor__c = variedad.get((String)pr.get('var')).Sociedad__c);
                    newVentas.add(newV);
                }else{
                    if(mapVendaVar.ContainsKey((String)pr.get('var')) && mapVendaVar.get((String)pr.get('var')).Volume__c != (Double)pr.get('Semente_comercializada__c')){
                        CRM_Vendas__c actV = mapVendaVar.get((String)pr.get('var'));
                        actV.Volume__c = (Double)pr.get('Semente_comercializada__c');
                        newVentas.add(actV);
                    }
                }
            }
            if(newVentas != null && newVentas.Size() > 0) upsert newVentas; newVentas.clear();
            ventas = database.query(qry);*/  
        }
        
        for (CRM_Vendas__c v : ventas){
            if (v.RecordType.Name == 'F' && v.Variedad__r.Sociedad__c == 'BRMX')
                planeamiento_BMX.add(v);
            if (v.RecordType.Name == 'F' && v.Variedad__r.Sociedad__c == 'DSEM')    
                planeamiento_DMS.add(v);              
            if (v.RecordType.Name == 'G')    
                planeamiento_sacas_outros.add(v);                   
            if (v.RecordType.Name == 'H')    
                planeamiento_sacas_verticaliza.add(v);                   
            if (v.RecordType.Name == 'I')    
                planeamiento_sacas_compra_fora.add(v);    
        }           
        
        CRM_Vendas__c nuevaV = New CRM_Vendas__c();
        CRM_Vendas__c nuevaV2 = New CRM_Vendas__c();
        CRM_Vendas__c nuevaV3 = New CRM_Vendas__c();
        CRM_Vendas__c nuevaV4 = New CRM_Vendas__c();
        CRM_Vendas__c nuevaV5 = New CRM_Vendas__c();
        nuevo_planeamiento_BMX = New List<CRM_Vendas__c>();
        nuevo_planeamiento_DMS = New List<CRM_Vendas__c>();
        nuevo_planeamiento_sacas_verticaliza = New List<CRM_Vendas__c>();
        nuevo_planeamiento_sacas_compra_fora = New List<CRM_Vendas__c>();
        nuevo_planeamiento_sacas_outros = New List<CRM_Vendas__c>();
        nuevo_planeamiento_BMX.add(nuevaV);   
        nuevo_planeamiento_DMS.add(nuevaV2);
        nuevo_planeamiento_sacas_verticaliza.add(nuevaV3);
        nuevo_planeamiento_sacas_compra_fora.add(nuevaV4);
        nuevo_planeamiento_sacas_outros.add(nuevaV5);
        
        sumarizar_planeamiento(crm_mult.Id);
        
    }
    
    public void initAreaActuacion(){
        
        area_atuacion = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_RS = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_SC = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_PR = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_MS = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_SP = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_GO = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_MG = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_MA = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_BA = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_RO = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_TO = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_PI = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_MT = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_PA = new List<CRM_Area_de_Atuacion__c>();
                
        totalRS.Sacas__c = 0.0;
        totalRS.Porcentaje_Vendas__c = 0.0;
        totalSC.Sacas__c = 0.0;
        totalSC.Porcentaje_Vendas__c = 0.0;
        totalPR.Sacas__c = 0.0;
        totalPR.Porcentaje_Vendas__c = 0.0;
        totalMS.Sacas__c = 0.0;
        totalMS.Porcentaje_Vendas__c = 0.0;
        totalSP.Sacas__c = 0.0;
        totalSP.Porcentaje_Vendas__c = 0.0;
        totalGO.Sacas__c = 0.0;
        totalGO.Porcentaje_Vendas__c = 0.0;
        totalMG.Sacas__c = 0.0;
        totalMG.Porcentaje_Vendas__c = 0.0;
        totalMA.Sacas__c = 0.0;
        totalMA.Porcentaje_Vendas__c = 0.0;
        totalBA.Sacas__c = 0.0;
        totalBA.Porcentaje_Vendas__c = 0.0;
        totalRO.Sacas__c = 0.0;
        totalRO.Porcentaje_Vendas__c = 0.0;
        totalTO.Sacas__c = 0.0;
        totalTO.Porcentaje_Vendas__c = 0.0;
        totalPI.Sacas__c = 0.0;
        totalPI.Porcentaje_Vendas__c = 0.0;
        totalMT.Sacas__c = 0.0;
        totalMT.Porcentaje_Vendas__c = 0.0;
        totalPA.Sacas__c = 0.0;
        totalPA.Porcentaje_Vendas__c = 0.0;
        totalGeneralEstados.Sacas__c = 0.0;
        totalGeneralEstados.Porcentaje_Vendas__c = 0.0;
                
        String qry = '';
        
        this.accId = ApexPages.currentPage().getParameters().get('id');
        campania = '12/13';
        
        Configuracion_BMX__c conf = new Configuracion_BMX__c();
        conf = [Select Id, CRM_Safra_Actual__c From Configuracion_BMX__c limit 1];
        if(conf.CRM_Safra_Actual__c != null) campania = conf.CRM_Safra_Actual__c;
        
        if (this.accId != null){                    
            AggregateResult[] area_a = [Select Sum(Sacas__c) Sacas__c, Sum(Porcentaje_Vendas__c) Porcentaje_Vendas__c, Regi_o__r.Grupo_de_R__c From CRM_Area_de_Atuacion__c Where Cuenta__c = : this.accId And Safra__c = : this.campania And Regi_o__r.Grupo_de_R__c <> null And Tipo__c = null Group By Regi_o__r.Grupo_de_R__c];        
            for (AggregateResult ar : area_a){  
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'RS'){
                    totalRS.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalRS.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'SC'){
                    totalSC.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalSC.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'PR'){
                    totalPR.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPR.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'MS'){
                    totalMS.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalMS.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'SP'){
                    totalSP.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalSP.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'GO'){
                    totalGO.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalGO.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'MG'){
                    totalMG.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalMG.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'MA'){
                    totalMA.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalMA.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'BA'){
                    totalBA.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalBA.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'RO'){
                    totalRO.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalRO.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'TO'){
                    totalTO.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalTO.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'PI'){
                    totalPI.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPI.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'MT'){
                    totalMT.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalMT.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'PA'){
                    totalPA.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPA.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
            }   
            
            totalGeneralEstados.Sacas__c = totalRS.Sacas__c + totalSC.Sacas__c + totalPR.Sacas__c + totalMS.Sacas__c + totalSP.Sacas__c + totalGO.Sacas__c + totalMG.Sacas__c + totalMA.Sacas__c + totalBA.Sacas__c + totalRO.Sacas__c + totalTO.Sacas__c + totalPI.Sacas__c + totalMT.Sacas__c + totalPA.Sacas__c;
            totalGeneralEstados.Porcentaje_Vendas__c = totalRS.Porcentaje_Vendas__c + totalSC.Porcentaje_Vendas__c + totalPR.Porcentaje_Vendas__c + totalMS.Porcentaje_Vendas__c + totalSP.Porcentaje_Vendas__c + totalGO.Porcentaje_Vendas__c + totalMG.Porcentaje_Vendas__c + totalMA.Porcentaje_Vendas__c + totalBA.Porcentaje_Vendas__c + totalRO.Porcentaje_Vendas__c + totalTO.Porcentaje_Vendas__c + totalPI.Porcentaje_Vendas__c + totalMT.Porcentaje_Vendas__c + totalPA.Porcentaje_Vendas__c;
                
            qry = 'Select ';
            for(String s : objectFields_CRM_Area_Atuacion.keySet())
                qry += ' ' + s + ', ';
                
            qry += 'Regi_o__r.Grupo_de_R__c From CRM_Area_de_Atuacion__c Where Cuenta__c = \'' + this.accId + '\''; 
            qry += ' And Safra__c = \'' + this.campania + '\'';  
            qry += ' And Tipo__c = null';                        
                           
            area_atuacion = database.query(qry); 
            
            for (CRM_Area_de_Atuacion__c a : area_atuacion){
                if (a.Regi_o__r.Grupo_de_R__c == 'RS')
                    area_atuacion_RS.add(a);    
                if (a.Regi_o__r.Grupo_de_R__c == 'SC')
                    area_atuacion_SC.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'PR')
                    area_atuacion_PR.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'MS')
                    area_atuacion_MS.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'SP')
                    area_atuacion_SP.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'GO')
                    area_atuacion_GO.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'MG')
                    area_atuacion_MG.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'MA')
                    area_atuacion_MA.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'BA')
                    area_atuacion_BA.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'RO')
                    area_atuacion_RO.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'TO')
                    area_atuacion_TO.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'PI')
                    area_atuacion_PI.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'MT')
                    area_atuacion_MT.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'PA')
                    area_atuacion_PA.add(a);
            }   
        }           
        
        if (crm_mult!= null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Vendas Totais (Sacas de 40kg): ' + formatDouble(Integer.ValueOf(crm_mult.Ventas_Totales__c),false)); 
            ApexPages.addMessage(msg); 
            ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.INFO, 'Total em Area de Atuação: ' + formatDouble(Integer.ValueOf(totalGeneralEstados.Sacas__c),false)); 
            ApexPages.addMessage(msg2);
            ApexPages.Message msg3 = new ApexPages.Message(ApexPages.Severity.INFO, '% em Area de Atuação: ' + formatDouble(Integer.ValueOf(totalGeneralEstados.Porcentaje_Vendas__c),false)); 
            ApexPages.addMessage(msg3);
        } 
    }
    
    public void initAreaActuacionPlaneamiento(){
        
        area_atuacion_planeamiento = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_RS = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_SC = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_PR = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_MS = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_SP = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_GO = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_MG = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_MA = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_BA = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_RO = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_TO = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_PI = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_MT = new List<CRM_Area_de_Atuacion__c>();
        area_atuacion_planeamiento_PA = new List<CRM_Area_de_Atuacion__c>();
                
        totalPlaneamientoRS.Sacas__c = 0.0;
        totalPlaneamientoRS.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoSC.Sacas__c = 0.0;
        totalPlaneamientoSC.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoPR.Sacas__c = 0.0;
        totalPlaneamientoPR.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoMS.Sacas__c = 0.0;
        totalPlaneamientoMS.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoSP.Sacas__c = 0.0;
        totalPlaneamientoSP.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoGO.Sacas__c = 0.0;
        totalPlaneamientoGO.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoMG.Sacas__c = 0.0;
        totalPlaneamientoMG.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoMA.Sacas__c = 0.0;
        totalPlaneamientoMA.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoBA.Sacas__c = 0.0;
        totalPlaneamientoBA.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoRO.Sacas__c = 0.0;
        totalPlaneamientoRO.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoTO.Sacas__c = 0.0;
        totalPlaneamientoTO.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoPI.Sacas__c = 0.0;
        totalPlaneamientoPI.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoMT.Sacas__c = 0.0;
        totalPlaneamientoMT.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoPA.Sacas__c = 0.0;
        totalPlaneamientoPA.Porcentaje_Vendas__c = 0.0;
        totalPlaneamientoGeneralEstados.Sacas__c = 0.0;
        totalPlaneamientoGeneralEstados.Porcentaje_Vendas__c = 0.0;
                
        String qry = '';
        
        this.accId = ApexPages.currentPage().getParameters().get('id');
        campania = '12/13';
        
        Configuracion_BMX__c conf = new Configuracion_BMX__c();
        conf = [Select Id, CRM_Safra_Siguiente__c From Configuracion_BMX__c limit 1];
        if(conf.CRM_Safra_Siguiente__c != null) campania = conf.CRM_Safra_Siguiente__c;
        
        if (this.accId != null){                    
            AggregateResult[] area_a = [Select Sum(Sacas__c) Sacas__c, Sum(Porcentaje_Vendas__c) Porcentaje_Vendas__c, Regi_o__r.Grupo_de_R__c From CRM_Area_de_Atuacion__c Where Cuenta__c = : this.accId And Safra__c = : this.campania And Regi_o__r.Grupo_de_R__c <> null And Tipo__c = 'PLANEAMIENTO' Group By Regi_o__r.Grupo_de_R__c];        
            for (AggregateResult ar : area_a){  
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'RS'){
                    totalPlaneamientoRS.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoRS.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'SC'){
                    totalPlaneamientoSC.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoSC.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'PR'){
                    totalPlaneamientoPR.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoPR.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'MS'){
                    totalPlaneamientoMS.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoMS.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'SP'){
                    totalPlaneamientoSP.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoSP.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'GO'){
                    totalPlaneamientoGO.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoGO.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'MG'){
                    totalPlaneamientoMG.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoMG.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'MA'){
                    totalPlaneamientoMA.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoMA.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'BA'){
                    totalPlaneamientoBA.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoBA.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'RO'){
                    totalPlaneamientoRO.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoRO.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'TO'){
                    totalPlaneamientoTO.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoTO.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'PI'){
                    totalPlaneamientoPI.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoPI.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'MT'){
                    totalPlaneamientoMT.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoMT.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
                if (String.valueof(ar.get('Grupo_de_R__c')) == 'PA'){
                    totalPlaneamientoPA.Sacas__c += Double.valueof(ar.get('Sacas__c'));
                    totalPlaneamientoPA.Porcentaje_Vendas__c += Double.valueof(ar.get('Porcentaje_Vendas__c'));   
                }
            }   
            
            totalPlaneamientoGeneralEstados.Sacas__c = totalPlaneamientoRS.Sacas__c + totalPlaneamientoSC.Sacas__c + totalPlaneamientoPR.Sacas__c + totalPlaneamientoMS.Sacas__c + totalPlaneamientoSP.Sacas__c + totalPlaneamientoGO.Sacas__c + totalPlaneamientoMG.Sacas__c + totalPlaneamientoMA.Sacas__c + totalPlaneamientoBA.Sacas__c + totalPlaneamientoRO.Sacas__c + totalPlaneamientoTO.Sacas__c + totalPlaneamientoPI.Sacas__c + totalPlaneamientoMT.Sacas__c + totalPlaneamientoPA.Sacas__c;
            totalPlaneamientoGeneralEstados.Porcentaje_Vendas__c = totalPlaneamientoRS.Porcentaje_Vendas__c + totalPlaneamientoSC.Porcentaje_Vendas__c + totalPlaneamientoPR.Porcentaje_Vendas__c + totalPlaneamientoMS.Porcentaje_Vendas__c + totalPlaneamientoSP.Porcentaje_Vendas__c + totalPlaneamientoGO.Porcentaje_Vendas__c + totalPlaneamientoMG.Porcentaje_Vendas__c + totalPlaneamientoMA.Porcentaje_Vendas__c + totalPlaneamientoBA.Porcentaje_Vendas__c + totalPlaneamientoRO.Porcentaje_Vendas__c + totalPlaneamientoTO.Porcentaje_Vendas__c + totalPlaneamientoPI.Porcentaje_Vendas__c + totalPlaneamientoMT.Porcentaje_Vendas__c + totalPlaneamientoPA.Porcentaje_Vendas__c;
                
            qry = 'Select ';
            for(String s : objectFields_CRM_Area_Atuacion.keySet())
                qry += ' ' + s + ', ';
                
            qry += 'Regi_o__r.Grupo_de_R__c From CRM_Area_de_Atuacion__c Where Cuenta__c = \'' + this.accId + '\''; 
            qry += ' And Safra__c = \'' + this.campania + '\'';                          
            qry += ' And Tipo__c = \'PLANEAMIENTO\'';
                           
            area_atuacion_planeamiento = database.query(qry); 
            
            for (CRM_Area_de_Atuacion__c a : area_atuacion_planeamiento){
                if (a.Regi_o__r.Grupo_de_R__c == 'RS')
                    area_atuacion_planeamiento_RS.add(a);    
                if (a.Regi_o__r.Grupo_de_R__c == 'SC')
                    area_atuacion_planeamiento_SC.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'PR')
                    area_atuacion_planeamiento_PR.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'MS')
                    area_atuacion_planeamiento_MS.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'SP')
                    area_atuacion_planeamiento_SP.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'GO')
                    area_atuacion_planeamiento_GO.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'MG')
                    area_atuacion_planeamiento_MG.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'MA')
                    area_atuacion_planeamiento_MA.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'BA')
                    area_atuacion_planeamiento_BA.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'RO')
                    area_atuacion_planeamiento_RO.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'TO')
                    area_atuacion_planeamiento_TO.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'PI')
                    area_atuacion_planeamiento_PI.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'MT')
                    area_atuacion_planeamiento_MT.add(a);
                if (a.Regi_o__r.Grupo_de_R__c == 'PA')
                    area_atuacion_planeamiento_PA.add(a);
            }   
        }           
        
        if (crm_mult!= null){
            sumarizar_planeamiento(crm_mult.Id);
            //Double total = totalPlaneamientoBMX + totalPlaneamientoDMS + totalPlaneamientoOutros + totalPlaneamientoSacasVerticaliza + totalPlaneamientoSacasCF;
            Double total = totalPlaneamientoBMX + totalPlaneamientoDMS + totalPlaneamientoOutros + totalPlaneamientoSacasCF;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Vendas Totais (Sacas de 40kg): ' + formatDouble(Integer.ValueOf(total),false)); 
            ApexPages.addMessage(msg); 
            ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.INFO, 'Total em Area de Atuação: ' + formatDouble(Integer.ValueOf(totalPlaneamientoGeneralEstados.Sacas__c),false)); 
            ApexPages.addMessage(msg2);
            ApexPages.Message msg3 = new ApexPages.Message(ApexPages.Severity.INFO, '% em Area de Atuação: ' + formatDouble(Integer.ValueOf(totalPlaneamientoGeneralEstados.Porcentaje_Vendas__c),false)); 
            ApexPages.addMessage(msg3);
        } 
    }
    
    public PageReference verPlaneamientoInfr(){
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference verInfraestructura(){
        PageReference pr = new PageReference('/apex/CRM_Infraestructura');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference verDatosBonificacion(){
        PageReference pr = new PageReference('/apex/CRM_Datos_Bonificacion');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference volverAConta(){         
        PageReference pr = new PageReference('/' + String.valueOf(accId));      
        return pr;      
    }
    
    public PageReference verCalendario(){        
        PageReference pr = new PageReference('/apex/CRM_Calendario');   
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);    
        return pr;      
    }
    
    public PageReference verVendas(){        
        PageReference pr = new PageReference('/apex/CRM_Vendas');       
        return pr;      
    }
    
    public PageReference verCanalVendas(){       
        PageReference pr = new PageReference('/apex/CRM_Canal_Vendas');     
        return pr;      
    }
    
    public PageReference verAreaAct(){       
        PageReference pr = new PageReference('/apex/CRM_Area_Atuacion');        
        return pr;      
    }
    
    public PageReference verPlaneamiento(){       
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');        
        return pr;      
    }
    
    public PageReference verPlaneamientoAreaA(){       
        PageReference pr = new PageReference('/apex/CRM_Planeamiento_Area_Atuacion');        
        return pr;      
    }
    
    public PageReference verEncerrar(){       
        PageReference pr = new PageReference('/apex/CRM_Encerrar');        
        return pr;      
    }
    
    public void crear_crm_mult(){
        crm_mult = New CRM_Multiplicador__c();
        crm_mult.Cuenta__c = accId;
        crm_mult.Safra__c = campania;
        if(Test.isRunningTest()){ crm_mult.Area_multiplic_propia__c = 100; crm_mult.Vendas_de_Sem_sem_tratar__c = 100;}
        //insert crm_mult;       //03/12/2015 NO SE CREA MAS AUTOMATICAMENTE          
    }
    
    public PageReference addNuevoPlaneamientoDMS(){
    
        RecordType rt = [Select Id From RecordType Where Name = 'F' And SobjectType = 'CRM_Vendas__c' limit 1];
        
        if (crm_mult == null || crm_mult.Id == null)
            crear_crm_mult();

        this.nuevo_planeamiento_DMS[0].CRM_Multiplicador__c = crm_mult.Id;
        this.nuevo_planeamiento_DMS[0].RecordTypeId = rt.Id;
        this.nuevo_planeamiento_DMS[0].Variedad__c = nuevaVariedadDMS;
        this.nuevo_planeamiento_DMS[0].Obtentor__c = 'DMS';
        
        insert nuevo_planeamiento_DMS;      
        actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');          
        
        this.nuevo_planeamiento_DMS.clear();
        CRM_Vendas__c i = New CRM_Vendas__c();
        this.nuevo_planeamiento_DMS.add(i);
        
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    
    }
    
    public PageReference addNuevoPlaneamientoBMX(){
    
        RecordType rt = [Select Id From RecordType Where Name = 'F' And SobjectType = 'CRM_Vendas__c' limit 1];
        
        if (crm_mult == null)
            crear_crm_mult();

        this.nuevo_planeamiento_BMX[0].CRM_Multiplicador__c = crm_mult.Id;
        this.nuevo_planeamiento_BMX[0].RecordTypeId = rt.Id;
        this.nuevo_planeamiento_BMX[0].Variedad__c = nuevaVariedadBMX;
        this.nuevo_planeamiento_BMX[0].Obtentor__c = 'BRMX';
        
        insert nuevo_planeamiento_BMX;    
        actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');            
        
        this.nuevo_planeamiento_BMX.clear();
        CRM_Vendas__c i = New CRM_Vendas__c();
        this.nuevo_planeamiento_BMX.add(i);
        
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    
    }
    
    public PageReference addNuevaVentaBMX(){
    
        RecordType rt = [Select Id From RecordType Where Name = 'B' And SobjectType = 'CRM_Vendas__c' limit 1];
        
        if (crm_mult == null)
            crear_crm_mult();

        this.nuevo_ventas_BMX[0].CRM_Multiplicador__c = crm_mult.Id;
        this.nuevo_ventas_BMX[0].RecordTypeId = rt.Id;
        this.nuevo_ventas_BMX[0].Variedad__c = nuevaVariedadBMX;
        this.nuevo_ventas_BMX[0].Obtentor__c = 'BRMX';
        
        insert nuevo_ventas_BMX;                
        
        this.nuevo_ventas_BMX.clear();
        CRM_Vendas__c i = New CRM_Vendas__c();
        this.nuevo_ventas_BMX.add(i);
        
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    
    }
    
    public PageReference addNuevaVentaDMS(){
    
        RecordType rt = [Select Id From RecordType Where Name = 'B' And SobjectType = 'CRM_Vendas__c' limit 1];
        
        if (crm_mult == null)
            crear_crm_mult();

        this.nuevo_ventas_DMS[0].CRM_Multiplicador__c = crm_mult.Id;
        this.nuevo_ventas_DMS[0].RecordTypeId = rt.Id;
        this.nuevo_ventas_DMS[0].Variedad__c = nuevaVariedadDMS;
        this.nuevo_ventas_DMS[0].Obtentor__c = 'DSEM';      
        
        insert nuevo_ventas_DMS;
        
        this.nuevo_ventas_DMS.clear();
        CRM_Vendas__c i = New CRM_Vendas__c();
        this.nuevo_ventas_DMS.add(i);
        
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    
    }
    
    public PageReference addNuevo_SacasV(){
    
        RecordType rt = [Select Id From RecordType Where Name = 'D' And SobjectType = 'CRM_Vendas__c' limit 1];
        
        if (crm_mult == null)
            crear_crm_mult();

        this.nuevo_sacas_verticaliza[0].CRM_Multiplicador__c = crm_mult.Id;
        this.nuevo_sacas_verticaliza[0].RecordTypeId = rt.Id;
        this.nuevo_sacas_verticaliza[0].Obtentor__c = String.valueOf(nuevaSacasV.Obtentor__c);
        this.nuevo_sacas_verticaliza[0].Volume__c = nuevaSacasVVolume;
        this.nuevo_sacas_verticaliza[0].Volume_Produzido__c = nuevaSacasVVolumeProd;
        
        insert nuevo_sacas_verticaliza;
        
        nuevaSacasVVolume = null;
        nuevaSacasVVolumeProd = null;
        
        this.nuevo_sacas_verticaliza.clear();
        CRM_Vendas__c i = New CRM_Vendas__c();
        this.nuevo_sacas_verticaliza.add(i);
        
        sumarizar_ventas();
        
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    
    }
    
    public PageReference addNuevo_SacasCF(){
    
        RecordType rt = [Select Id From RecordType Where Name = 'E' And SobjectType = 'CRM_Vendas__c' limit 1];
        
        if (crm_mult == null)
            crear_crm_mult();

        this.nuevo_sacas_compra_fora[0].CRM_Multiplicador__c = crm_mult.Id;
        this.nuevo_sacas_compra_fora[0].RecordTypeId = rt.Id;
        this.nuevo_sacas_compra_fora[0].Obtentor__c = nuevaSacasCF.Obtentor__c;
        this.nuevo_sacas_compra_fora[0].Volume__c = nuevaSacasCFVolume;
        this.nuevo_sacas_compra_fora[0].Volume_Produzido__c = nuevaSacasCFVolumeProd;
        
        insert nuevo_sacas_compra_fora;
        actualizarAreaAtuacion(crm_mult.Id, null);
        
        nuevaSacasCFVolume = null;
        nuevaSacasCFVolumeProd = null;
        
        this.nuevo_sacas_compra_fora.clear();
        CRM_Vendas__c i = New CRM_Vendas__c();
        this.nuevo_sacas_compra_fora.add(i);
        
        sumarizar_ventas();
        
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    
    }
    
    public PageReference addNuevo_SacasO(){
    
        RecordType rt = [Select Id From RecordType Where Name = 'C' And SobjectType = 'CRM_Vendas__c' limit 1];
        
        if (crm_mult == null)
            crear_crm_mult();

        this.nuevo_sacas_outros[0].CRM_Multiplicador__c = crm_mult.Id;
        this.nuevo_sacas_outros[0].RecordTypeId = rt.Id;
        this.nuevo_sacas_outros[0].Obtentor__c = nuevaSacasO.Obtentor__c;
        this.nuevo_sacas_outros[0].Variedad__c = nuevoProdOutros;
        this.nuevo_sacas_outros[0].Volume__c = nuevoProdOutrosVolume;
        this.nuevo_sacas_outros[0].Volume_Produzido__c = nuevoProdOutrosVolumeProd;
        
        insert nuevo_sacas_outros;
        actualizarAreaAtuacion(crm_mult.Id, null);
        
        nuevoProdOutros = null;
        nuevoProdOutrosVolume = null;
        nuevoProdOutrosVolumeProd = null;
        
        this.nuevo_sacas_outros.clear();
        CRM_Vendas__c i = New CRM_Vendas__c();
        this.nuevo_sacas_outros.add(i);             
        
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    
    }
    
    public PageReference addNuevo_PSacasO(){
    
        RecordType rt = [Select Id From RecordType Where Name = 'G' And SobjectType = 'CRM_Vendas__c' limit 1];
        
        if (crm_mult == null)
            crear_crm_mult();

        this.nuevo_planeamiento_sacas_outros[0].CRM_Multiplicador__c = crm_mult.Id;
        this.nuevo_planeamiento_sacas_outros[0].RecordTypeId = rt.Id;
        this.nuevo_planeamiento_sacas_outros[0].Obtentor__c = nuevaSacasO.Obtentor__c;
        this.nuevo_planeamiento_sacas_outros[0].Variedad__c = nuevoProdOutros;
        this.nuevo_planeamiento_sacas_outros[0].Volume__c = nuevoProdOutrosVolume;
        
        insert nuevo_planeamiento_sacas_outros;
        actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');
        
        nuevoProdOutros = null;
        nuevoProdOutrosVolume = null;
        
        this.nuevo_planeamiento_sacas_outros.clear();
        CRM_Vendas__c i = New CRM_Vendas__c();
        this.nuevo_planeamiento_sacas_outros.add(i);             
        
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    
    }
    
    public PageReference addNuevo_PSacasV(){
    
        RecordType rt = [Select Id From RecordType Where Name = 'H' And SobjectType = 'CRM_Vendas__c' limit 1];
        
        if (crm_mult == null)
            crear_crm_mult();

        this.nuevo_planeamiento_sacas_verticaliza[0].CRM_Multiplicador__c = crm_mult.Id;
        this.nuevo_planeamiento_sacas_verticaliza[0].RecordTypeId = rt.Id;
        this.nuevo_planeamiento_sacas_verticaliza[0].Obtentor__c = String.valueOf(nuevaSacasV.Obtentor__c);
        this.nuevo_planeamiento_sacas_verticaliza[0].Volume__c = nuevaSacasVVolume;
        
        insert nuevo_planeamiento_sacas_verticaliza;
        
        this.nuevo_planeamiento_sacas_verticaliza.clear();
        CRM_Vendas__c i = New CRM_Vendas__c();
        this.nuevo_planeamiento_sacas_verticaliza.add(i);
        
        sumarizar_planeamiento(crm_mult.Id);
        
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    
    }
    
    public PageReference addNuevo_PSacasCF(){
    
        RecordType rt = [Select Id From RecordType Where Name = 'I' And SobjectType = 'CRM_Vendas__c' limit 1];
        
        if (crm_mult == null)
            crear_crm_mult();

        this.nuevo_planeamiento_sacas_compra_fora[0].CRM_Multiplicador__c = crm_mult.Id;
        this.nuevo_planeamiento_sacas_compra_fora[0].RecordTypeId = rt.Id;
        this.nuevo_planeamiento_sacas_compra_fora[0].Obtentor__c = nuevaSacasCF.Obtentor__c;
        this.nuevo_planeamiento_sacas_compra_fora[0].Volume__c = nuevaSacasCFVolume;
        
        insert nuevo_planeamiento_sacas_compra_fora;
        actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');
        
        this.nuevo_planeamiento_sacas_compra_fora.clear();
        CRM_Vendas__c i = New CRM_Vendas__c();
        this.nuevo_planeamiento_sacas_compra_fora.add(i);
        
        sumarizar_planeamiento(crm_mult.Id);
        
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    
    }
    
    public PageReference addInfraestructura_A(){
        
        try{
                                                                        
            RecordType rt = [Select Id From RecordType Where Name = 'A' And SobjectType = 'CRM_Infraestructura__c' limit 1];                
        
            if (crm_mult == null)
                crear_crm_mult();

            this.nuevo_infraestructura_A[0].CRM_Multiplicador__c = crm_mult.Id;
            this.nuevo_infraestructura_A[0].RecordTypeId = rt.Id;
            this.nuevo_infraestructura_A[0].Cuenta__c = this.accId;
            if(ciudades.get(this.nuevo_infraestructura_A[0].Cidade__c) != null)
                this.nuevo_infraestructura_A[0].Region__c = ciudades.get(this.nuevo_infraestructura_A[0].Cidade__c);
            insert nuevo_infraestructura_A;
        
            this.nuevo_infraestructura_A.clear();
            CRM_Infraestructura__c i = New CRM_Infraestructura__c();
            this.nuevo_infraestructura_A.add(i);
        
            PageReference pr = new PageReference('/apex/CRM_Infraestructura');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens);            
            ApexPages.addMessage(msg);  
            return null;                    
        }                   
    }
    
    public PageReference addPInfraestructura_A(){
        
        try{
                                                                        
            RecordType rt = [Select Id From RecordType Where Name = 'P_A' And SobjectType = 'CRM_Infraestructura__c' limit 1];                
        
            if (crm_mult == null)
                return null;

            this.nuevo_plan_infraestructura_A[0].CRM_Multiplicador__c = crm_mult.Id;
            this.nuevo_plan_infraestructura_A[0].RecordTypeId = rt.Id;
            this.nuevo_plan_infraestructura_A[0].Cuenta__c = this.accId;
            if(ciudades.get(this.nuevo_plan_infraestructura_A[0].Cidade__c) != null)
                this.nuevo_plan_infraestructura_A[0].Region__c = ciudades.get(this.nuevo_plan_infraestructura_A[0].Cidade__c);
            insert nuevo_plan_infraestructura_A;
        
            this.nuevo_plan_infraestructura_A.clear();
            CRM_Infraestructura__c i = New CRM_Infraestructura__c();
            this.nuevo_plan_infraestructura_A.add(i);
        
            PageReference pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens);            
            ApexPages.addMessage(msg);  
            return null;                    
        }                   
    }
    
    public PageReference addPInfraestructura_B(){
        
        try{
        
            RecordType rt = [Select Id From RecordType Where Name = 'P_B' And SobjectType = 'CRM_Infraestructura__c' limit 1];
        
            if (crm_mult == null)
                return null;

            this.nuevo_plan_infraestructura_B[0].CRM_Multiplicador__c = crm_mult.Id;
            this.nuevo_plan_infraestructura_B[0].RecordTypeId = rt.Id;
            this.nuevo_plan_infraestructura_B[0].Produto__c = nuevoAgroquimico;
            this.nuevo_plan_infraestructura_B[0].Cuenta__c = this.accId;
            insert nuevo_plan_infraestructura_B;
        
            this.nuevo_plan_infraestructura_B.clear();
            CRM_Infraestructura__c i = New CRM_Infraestructura__c();
            this.nuevo_plan_infraestructura_B.add(i);
        
            PageReference pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;  
            
        }catch (Exception e){
            String mens = e.getMessage();
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
                            
    }
    
    public PageReference addInfraestructura_B(){
        
        try{
        
            RecordType rt = [Select Id From RecordType Where Name = 'B' And SobjectType = 'CRM_Infraestructura__c' limit 1];
        
            if (crm_mult == null)
                crear_crm_mult();

            this.nuevo_infraestructura_B[0].CRM_Multiplicador__c = crm_mult.Id;
            this.nuevo_infraestructura_B[0].RecordTypeId = rt.Id;
            this.nuevo_infraestructura_B[0].Produto__c = nuevoAgroquimico;
            this.nuevo_infraestructura_B[0].Cuenta__c = this.accId;
            insert nuevo_infraestructura_B;
        
            this.nuevo_infraestructura_B.clear();
            CRM_Infraestructura__c i = New CRM_Infraestructura__c();
            this.nuevo_infraestructura_B.add(i);
        
            PageReference pr = new PageReference('/apex/CRM_Infraestructura');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;  
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
                            
    }
    
    public PageReference addPInfraestructura_F(){
        
        try{
        
            RecordType rt = [Select Id From RecordType Where Name = 'P_F' And SobjectType = 'CRM_Infraestructura__c' limit 1];
        
            if (crm_mult == null)
                return null;

            this.nuevo_plan_infraestructura_F[0].CRM_Multiplicador__c = crm_mult.Id;
            this.nuevo_plan_infraestructura_F[0].RecordTypeId = rt.Id;
            this.nuevo_plan_infraestructura_F[0].Cuenta__c = this.accId;
            insert nuevo_plan_infraestructura_F;
        
            this.nuevo_plan_infraestructura_F.clear();
            CRM_Infraestructura__c i = New CRM_Infraestructura__c();
            this.nuevo_plan_infraestructura_F.add(i);
        
            PageReference pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;   
            
        }catch (Exception e){
            String mens = e.getMessage();            
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }
                            
    }
    
    public PageReference addInfraestructura_F(){
        
        try{
        
            RecordType rt = [Select Id From RecordType Where Name = 'F' And SobjectType = 'CRM_Infraestructura__c' limit 1];
        
            if (crm_mult == null)
                crear_crm_mult();

            this.nuevo_infraestructura_F[0].CRM_Multiplicador__c = crm_mult.Id;
            this.nuevo_infraestructura_F[0].RecordTypeId = rt.Id;
            this.nuevo_infraestructura_F[0].Cuenta__c = this.accId;
            insert nuevo_infraestructura_F;
        
            this.nuevo_infraestructura_F.clear();
            CRM_Infraestructura__c i = New CRM_Infraestructura__c();
            this.nuevo_infraestructura_F.add(i);
        
            PageReference pr = new PageReference('/apex/CRM_Infraestructura');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;   
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }
                            
    }
    
    public PageReference addPInfraestructura_G(){
        
        try{
                                                                        
            RecordType rt = [Select Id From RecordType Where Name = 'P_G' And SobjectType = 'CRM_Infraestructura__c' limit 1];                
        
            if (crm_mult == null)
                return null;

            this.nuevo_plan_infraestructura_G[0].CRM_Multiplicador__c = crm_mult.Id;
            this.nuevo_plan_infraestructura_G[0].RecordTypeId = rt.Id;
            this.nuevo_plan_infraestructura_G[0].Cuenta__c = this.accId;
            if(ciudades.get(this.nuevo_plan_infraestructura_G[0].Cidade__c) != null)
                this.nuevo_plan_infraestructura_G[0].Region__c = ciudades.get(this.nuevo_plan_infraestructura_G[0].Cidade__c);
            insert nuevo_plan_infraestructura_G;
        
            this.nuevo_plan_infraestructura_G.clear();
            CRM_Infraestructura__c i = New CRM_Infraestructura__c();
            this.nuevo_plan_infraestructura_G.add(i);
        
            PageReference pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();            
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens);            
            ApexPages.addMessage(msg);  
            return null;                    
        }                   
    }

    public PageReference addInfraestructura_G(){
        
        try{
                                                                        
            RecordType rt = [Select Id From RecordType Where Name = 'G' And SobjectType = 'CRM_Infraestructura__c' limit 1];                
        
            if (crm_mult == null)
                crear_crm_mult();

            this.nuevo_infraestructura_G[0].CRM_Multiplicador__c = crm_mult.Id;
            this.nuevo_infraestructura_G[0].RecordTypeId = rt.Id;
            this.nuevo_infraestructura_G[0].Cuenta__c = this.accId;
            if(ciudades.get(this.nuevo_infraestructura_G[0].Cidade__c) != null)
                this.nuevo_infraestructura_G[0].Region__c = ciudades.get(this.nuevo_infraestructura_G[0].Cidade__c);
            insert nuevo_infraestructura_G;
        
            this.nuevo_infraestructura_G.clear();
            CRM_Infraestructura__c i = New CRM_Infraestructura__c();
            this.nuevo_infraestructura_G.add(i);
        
            PageReference pr = new PageReference('/apex/CRM_Infraestructura');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens);            
            ApexPages.addMessage(msg);  
            return null;                    
        }                   
    }
    
    public PageReference updateCalendarioCab(){
        
        Savepoint sp;
        
        try{
            
            sp = Database.setSavepoint();
            
            update ver_calendario;
            
            PageReference pr = new PageReference('/apex/CRM_Calendario');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            Database.rollback(sp);         
            String mens = e.getMessage();
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }   
        
    }
    
    public PageReference updateCalendarioDetalle(){
        
        Savepoint sp;
        
        try{
            
            sp = Database.setSavepoint();
            
            List<CRM_Detalle_Calendario_de_eventos__c> editCalendarioDet = New List<CRM_Detalle_Calendario_de_eventos__c>();
            
            for (CRM_Detalle_Calendario_de_eventos__c det : ver_calendario_detalles){
                CRM_Detalle_Calendario_de_eventos__c d = New CRM_Detalle_Calendario_de_eventos__c();
                d.Id = det.Id;
                if (det.Id == null)
                    d.CRM_Calendario_de_eventos__c = ver_calendario.Id;
                d.Obtentor__c = det.Obtentor__c;
                d.Cultivar__c = det.Cultivar__c;
                d.Area_Plantada__c = det.Area_Plantada__c;
                d.Area_Colhida__c = det.Area_Colhida__c;
                d.Produtividade__c = det.Produtividade__c;
                d.Data_de_colheita__c = det.Data_de_colheita__c;
                d.Data_de_plantio__c = det.Data_de_plantio__c;
                editCalendarioDet.add(d);
            }
       
            if (editCalendarioDet.size() > 0)
                upsert editCalendarioDet;
        
                                    
            List<Attachment> editCalendarioAtt = New List<Attachment>();
            
            for (Attachment a : ver_calendario_attachs){
                if (a.Id == null){
                    Attachment att = New Attachment();                              
                    att.ParentId = ver_calendario.Id;                   
                    att.Body = a.Body;
                    att.Name = a.Name;
                    editCalendarioAtt.add(att);
                }
            }
            
            if (editCalendarioAtt.size() > 0)
                insert editCalendarioAtt;
                
            this.ver_calendario.clear();
            this.ver_calendario_detalles.clear();
            if (this.ver_calendario_attach != null)
                this.ver_calendario_attach.clear();
            if (this.ver_calendario_attachs != null)                
                this.ver_calendario_attachs.clear();
            
            PageReference pr = new PageReference('/apex/CRM_Calendario');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
            
        }catch (Exception e){
            Database.rollback(sp);         
            String mens = e.getMessage();
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }  
        
    }
    
    public PageReference addCalendario(){
        
        Savepoint sp;
        
        try{
            
            sp = Database.setSavepoint(); 
            
            CRM_Calendario_de_Eventos__c newCalendario = New CRM_Calendario_de_Eventos__c();
            List<CRM_Detalle_Calendario_de_eventos__c> newCalendarioDet = New List<CRM_Detalle_Calendario_de_eventos__c>();
            
            Id eveRTypeId; String eve = nuevo_calendario.Evento__c;
            if(eve == 'Día de Campo' || eve == 'Feira' || eve == 'Estação DONMARIO MAS' || eve == 'Tour dos máximos rendimentos'){
                eveRTypeId = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByName().get('Día de Campo').getRecordTypeId();
            }
            else if(eve == 'Lado x Lado' || eve == 'Strip Test' || eve == 'CESB' || eve == 'Area comercial'){
                eveRTypeId = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByName().get('Test a campo').getRecordTypeId();
            }
            else if(eve == 'Emplacamento'){
                eveRTypeId = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByName().get('Emplacamento').getRecordTypeId();
            }
            else
                eveRTypeId = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByName().get('Treinamento Tecnico').getRecordTypeId();
                
            /*
            switch on nuevo_calendario.Evento__c {
                when 'Día de Campo', 'Feira', 'Estação DONMARIO MAS', 'Tour dos máximos rendimentos' {
                    eveRTypeId = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByName().get('Día de Campo').getRecordTypeId();
                }
                when 'Lado x Lado', 'Strip Test', 'CESB', 'Area comercial' {
                    eveRTypeId = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByName().get('Test a campo').getRecordTypeId();
                }
                when 'Emplacamento' {
                    eveRTypeId = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByName().get('Emplacamento').getRecordTypeId();
                }
                when else {
                    eveRTypeId = Schema.SObjectType.CRM_Calendario_de_Eventos__c.getRecordTypeInfosByName().get('Treinamento Tecnico').getRecordTypeId();
                }
            } */   
    
            List<Attachment> newCalendarioAtt = New List<Attachment>();
                    
            if (nuevo_calendario.Marca__c == null){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Debe ingresar Marca'); 
                ApexPages.addMessage(msg);  
                return null;
            }
            
            newCalendario.RecordTypeId = eveRTypeId;
            newCalendario.Cuenta__c = accId;
            newCalendario.Safra__c = campania;
            newCalendario.Marca__c = nuevo_calendario.Marca__c;
            newCalendario.Revenda__c = nuevo_calendario.Revenda__c;
            newCalendario.Municipio__c = nuevo_calendario.Municipio__c;
            newCalendario.Direccion__c = nuevo_calendario.Direccion__c;
            newCalendario.Evaluacion__c = nuevo_calendario.Evaluacion__c;
            newCalendario.Evento__c = nuevo_calendario.Evento__c;
            newCalendario.Latitud__c = nuevo_calendario.Latitud__c;
            newCalendario.Longitud__c = nuevo_calendario.Longitud__c;
            newCalendario.Custo__c = nuevo_calendario.Custo__c;
            newCalendario.Numero_de_participantess__c = nuevo_calendario.Numero_de_participantess__c;
            newCalendario.Comentarios__c = nuevo_calendario.Comentarios__c;
            newCalendario.Data__c = nuevo_calendario.Data__c;
            newCalendario.Participante__c = nuevo_calendario.Participante__c;
            newCalendario.Data_e_horario_inicio__c = nuevo_calendario.Data_e_horario_inicio__c;
            newCalendario.Data_e_horario_termino__c = nuevo_calendario.Data_e_horario_termino__c;
            newCalendario.Realizado_por__c = nuevo_calendario.Realizado_por__c;
            newCalendario.Nome_do_agricultor__c = nuevo_calendario.Nome_do_agricultor__c;
            newCalendario.Irrigado__c = nuevo_calendario.Irrigado__c;
            newCalendario.Finalizado__c = nuevo_calendario.Finalizado__c;
            if (newCalendario.Data__c == null)
                newCalendario.Data__c = system.today();
        
            insert newcalendario;
            
            for (CRM_Detalle_Calendario_de_eventos__c det : nuevo_calendario_detalles){
                CRM_Detalle_Calendario_de_eventos__c d = New CRM_Detalle_Calendario_de_eventos__c();
                d.CRM_Calendario_de_eventos__c = newcalendario.Id;
                d.Obtentor__c = det.Obtentor__c;
                d.Cultivar__c = det.Cultivar__c;
                d.Area_Plantada__c = det.Area_Plantada__c;
                d.Area_Colhida__c = det.Area_Colhida__c;
                d.Produtividade__c = det.Produtividade__c;
                d.Data_de_colheita__c = det.Data_de_colheita__c;
                d.Data_de_plantio__c = det.Data_de_plantio__c;
                newCalendarioDet.add(d);
            }
            
            Integer suma = 0;
            
            for (Attachment a : nuevo_calendario_attachs){
                Attachment atta = New Attachment();
                atta.Name = a.Name;
                atta.Body = a.Body;
                atta.ParentId = newcalendario.Id;
                newCalendarioAtt.add(atta);            
                suma++;
            }
            
            newCalendario.Arquivos_cont__c = suma;
            
            if (newCalendarioDet.size() > 0)
                insert newCalendarioDet;
                
            if (newCalendarioAtt.size() > 0)
                insert newCalendarioAtt;
            
            update newCalendario;
            
            this.nuevo_calendario.clear();
            //CRM_Calendario_de_Eventos__c i = New CRM_Calendario_de_Eventos__c();
            //this.nuevo_calendario.add(i);
        
            estadoNewCal = '';
        
            
            PageReference pr = new PageReference('/apex/CRM_Calendario');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            
            /*
            PageReference pr = new PageReference('/apex/CRM_Calendario_Ver_Edit');
            pr.getParameters().put('editCal', newCalendario.Id);
            */            
            return pr;
            
        }catch (Exception e){
            Database.rollback(sp);         
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }                       
        
    }
    
    public PageReference volverCalendario(){
        PageReference pr = new PageReference('/apex/CRM_Calendario');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    }
    
    public PageReference addAreaAtuacion(){
        
        try{
        
            List<CRM_Area_de_Atuacion__c> existe = New List<CRM_Area_de_Atuacion__c>();
            existe = [Select Id, Sacas__c, Porcentaje_Vendas__c From CRM_Area_de_Atuacion__c Where Cuenta__c = : accId And Safra__c = : campania And Regi_o__c = : nuevoAreaAtuacion And Tipo__c = null limit 1];
            if (existe.size() > 0){
                //existe[0].Sacas__c += nuevoAreaAtuacionCantidad;
                existe[0].Porcentaje_Vendas__c = nuevoAreaAtuacionPorcentaje;
                existe[0].Sacas__c = (nuevoAreaAtuacionPorcentaje * crm_mult.Ventas_Totales__c / 100).divide(1, 0, System.RoundingMode.HALF_UP);
                update existe;
                nuevoAreaAtuacion = '';
                nuevoAreaAtuacionCantidad = null;
                nuevoAreaAtuacionPorcentaje = null;
                PageReference pr = new PageReference('/apex/CRM_Area_Atuacion');
                pr.getParameters().put('id',this.accId);
                pr.getParameters().put('nombre',this.nombre_cuenta);
                return pr;
            }    
                
            CRM_Area_de_Atuacion__c area_a = New CRM_Area_de_Atuacion__c();
        
            area_a.Cuenta__c = accId;
            area_a.Safra__c = campania;
            area_a.Regi_o__c = nuevoAreaAtuacion;
            //area_a.Sacas__c = nuevoAreaAtuacionCantidad;
            area_a.Porcentaje_Vendas__c = nuevoAreaAtuacionPorcentaje;
            area_a.Sacas__c = (nuevoAreaAtuacionPorcentaje * crm_mult.Ventas_Totales__c / 100).divide(1, 0, System.RoundingMode.HALF_UP);
        
            insert area_a;
                   
            nuevoAreaAtuacion = '';
            nuevoAreaAtuacionCantidad = null;
            nuevoAreaAtuacionPorcentaje = null;
        
            PageReference pr = new PageReference('/apex/CRM_Area_Atuacion');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }                       
        
    }
    
    public PageReference addAreaAtuacionPlaneamiento(){
        
        try{
        
            List<CRM_Area_de_Atuacion__c> existe = New List<CRM_Area_de_Atuacion__c>();
            existe = [Select Id, Sacas__c, Porcentaje_Vendas__c From CRM_Area_de_Atuacion__c Where Cuenta__c = : accId And Safra__c = : campania And Regi_o__c = : nuevoAreaAtuacion And Tipo__c = 'PLANEAMIENTO' limit 1];
            if (existe.size() > 0){
                //existe[0].Sacas__c += nuevoAreaAtuacionCantidad;
                existe[0].Porcentaje_Vendas__c = nuevoAreaAtuacionPorcentaje;
                existe[0].Sacas__c = (nuevoAreaAtuacionPorcentaje * Decimal.valueOf(totalPlaneamientoBMX + totalPlaneamientoDMS + totalPlaneamientoOutros + totalPlaneamientoSacasCF) / 100).divide(1, 0, System.RoundingMode.HALF_UP);
                update existe;
                nuevoAreaAtuacion = '';
                nuevoAreaAtuacionCantidad = null;
                nuevoAreaAtuacionPorcentaje = null;
                PageReference pr = new PageReference('/apex/CRM_Planeamiento_Area_Atuacion');
                pr.getParameters().put('id',this.accId);
                pr.getParameters().put('nombre',this.nombre_cuenta);
                return pr;
            }    
                
            CRM_Area_de_Atuacion__c area_a = New CRM_Area_de_Atuacion__c();
        
            area_a.Cuenta__c = accId;
            area_a.Safra__c = campania;
            area_a.Regi_o__c = nuevoAreaAtuacion;
            //area_a.Sacas__c = nuevoAreaAtuacionCantidad;
            area_a.Porcentaje_Vendas__c = nuevoAreaAtuacionPorcentaje;
            area_a.Sacas__c = (nuevoAreaAtuacionPorcentaje * Decimal.valueOf(totalPlaneamientoBMX + totalPlaneamientoDMS + totalPlaneamientoOutros + totalPlaneamientoSacasCF) / 100).divide(1, 0, System.RoundingMode.HALF_UP);
            area_a.Tipo__c = 'PLANEAMIENTO';
        
            insert area_a;
                   
            nuevoAreaAtuacion = '';
            nuevoAreaAtuacionCantidad = null;
            nuevoAreaAtuacionPorcentaje = null;
        
            PageReference pr = new PageReference('/apex/CRM_Planeamiento_Area_Atuacion');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }                       
        
    }
            
    public PageReference editInfraestructura_A(){
        editInfrA = ApexPages.currentPage().getParameters().get('editInfr_A');

        return null;    
    }
    
    public PageReference editInfraestructura_G(){
        editInfrG = ApexPages.currentPage().getParameters().get('editInfr_G');

        return null;    
    }
    
    public PageReference editInfraestructura_B(){
        editInfrB = ApexPages.currentPage().getParameters().get('editInfr_B');
        if (editInfrB != null)
            for (CRM_Infraestructura__c i : Infraestructura_B)
                if (i.Id == editInfrB)  
                    editAgroquimico = i.Produto__c;

        return null;    
    }
    
    public PageReference editInfraestructura_F(){
        editInfrF = ApexPages.currentPage().getParameters().get('editInfr_F');

        return null;    
    }
    
    public PageReference editPInfraestructura_C(){
        editPInfrC = true;
        return null;    
    }
    
    public PageReference editPInfraestructura_D(){
        editPInfrD = true;
        return null;    
    }
    
    public PageReference editPInfraestructura_E(){
        editPInfrE = true;
        return null;    
    }
    
    public PageReference editInfraestructura_C(){
        editInfrC = true;
        return null;    
    }
        
    public PageReference editInfraestructura_D(){
        editInfrD = true;
        return null;    
    }
    
    public PageReference editInfraestructura_E(){
        editInfrE = true;
        return null;    
    }
    
    public PageReference editDatosBonificacionBRMX(){
        editDatosBonifBRMX = true;
        return null;    
    }
    
    public PageReference editDatosBonificacionDSEM(){
        editDatosBonifDSEM = true;
        return null;    
    }
    
    public PageReference editCanalVendas(){
        editCanalDeVendas = true;
        return null;    
    }
    
    public PageReference editVendas(){
        editarVendas = true;
        return null;    
    }
    
    public PageReference editTSacasV(){
        editTotalSacasV = true;
        return null;    
    }
    
    public PageReference editTSacasCF(){
        editTotalSacasCF = true;
        return null;    
    }
    
    public PageReference editCalendario(){
        //editCalendario = ApexPages.currentPage().getParameters().get('editCal');
        //ApexPages.currentPage().getParameters().put('editCal', String.valueOf(editCalendario));
        
        PageReference pr = new PageReference('/apex/CRM_Calendario_Ver_Edit');        
        return pr;        
    }
    
    public PageReference editAreaAtuacion(){
        editareaa = ApexPages.currentPage().getParameters().get('edit_area_a');
        
        CRM_Area_de_Atuacion__c a = [Select Id, Regi_o__c, Sacas__c, Porcentaje_Vendas__c From CRM_Area_de_Atuacion__c Where Id = : editareaa];
        editRegAreaA = a.Regi_o__c;
        //editCantAreaA = a.Sacas__c;
        editPorcentajeAreaA = a.Porcentaje_Vendas__c;

        return null;    
    }
    
    public PageReference editVentaDMS(){
        editvdms = ApexPages.currentPage().getParameters().get('edit_v_dms');
        if (editvdms != null)
            for (CRM_Vendas__c v : ventas_DMS)
                if (v.Id == editvdms)   
                    editVariedadDMS = v.Variedad__c;

        return null;    
    }
    
    public PageReference editVentaBMX(){
        editvbmx = ApexPages.currentPage().getParameters().get('edit_v_bmx');
        if (editvbmx != null)
            for (CRM_Vendas__c v : ventas_BMX)
                if (v.Id == editvbmx)   
                    editVariedadBMX = v.Variedad__c;

        return null;    
    }
    
    public PageReference editPlaneamientoBMX(){
        editpbmx = ApexPages.currentPage().getParameters().get('edit_p_bmx');
        if (editpbmx != null)
            for (CRM_Vendas__c p : planeamiento_BMX)
                if (p.Id == editpbmx)   
                    editVariedadBMX = p.Variedad__c;

        return null;    
    }
    
    public PageReference editPlaneamientoDMS(){
        editpdms = ApexPages.currentPage().getParameters().get('edit_p_dms');
        if (editpdms != null)
            for (CRM_Vendas__c p : planeamiento_DMS)
                if (p.Id == editpdms)   
                    editVariedadDMS = p.Variedad__c;

        return null;    
    }
    
    public PageReference editSacasV(){
        editsv = ApexPages.currentPage().getParameters().get('edit_s_v');
        if (editsv != null)
            for (CRM_Vendas__c v : sacas_verticaliza)
                if (v.Id == editsv)
                    editSacasV.Obtentor__c = v.Obtentor__c;     

        return null;    
    }
    
    public PageReference editSacasCF(){
        editscf = ApexPages.currentPage().getParameters().get('edit_s_cf'); 
        if (editscf != null)
            for (CRM_Vendas__c v : sacas_compra_fora)
                if (v.Id == editscf)
                    editSacasCF.Obtentor__c = v.Obtentor__c;    

        return null;    
    }
    
    public PageReference editSacasO(){
        editso = ApexPages.currentPage().getParameters().get('edit_s_o');   
        if (editso != null)
            for (CRM_Vendas__c v : sacas_outros)
                if (v.Id == editso){
                    editSacasO.Obtentor__c = v.Obtentor__c;
                    getVariedadesObt_Edit_SacasO();
                }               

        return null;    
    }
    
    public PageReference editItemC(){
        editNewItemEvento = Integer.valueOf(ApexPages.currentPage().getParameters().get('edit_new_item_c'));
        editNuevoItemEvento.Obtentor__c = ver_calendario_detalles[editNewItemEvento].Obtentor__c;
        getVariedadesObt_Edit_NewEvento();  
                        
        return null;
            
    }
    
    public PageReference editNewItemC(){
        editNewItemEvento = Integer.valueOf(ApexPages.currentPage().getParameters().get('edit_new_item_c'));
        editNuevoItemEvento.Obtentor__c = nuevo_calendario_detalles[editNewItemEvento].Obtentor__c;
        getVariedadesObt_Edit_NewEvento();  
                        
        return null;
            
    }
    
    public PageReference editPSacasO(){
        editpso = ApexPages.currentPage().getParameters().get('edit_p_s_o');   
        if (editpso != null)
            for (CRM_Vendas__c p : planeamiento_sacas_outros)
                if (p.Id == editpso){
                    editSacasO.Obtentor__c = p.Obtentor__c;
                    getVariedadesObt_Edit_SacasO();
                    editProdOutros = p.Variedad__c;
                }               

        return null;    
    }
    
    public PageReference editPSacasV(){
        editpsv = ApexPages.currentPage().getParameters().get('edit_p_s_v');
        if (editpsv != null)
            for (CRM_Vendas__c p : planeamiento_sacas_verticaliza)
                if (p.Id == editpsv)
                    editSacasV.Obtentor__c = p.Obtentor__c;     

        return null;    
    }
    
    public PageReference editPSacasCF(){
        editpscf = ApexPages.currentPage().getParameters().get('edit_p_s_cf'); 
        if (editpscf != null)
            for (CRM_Vendas__c p : planeamiento_sacas_compra_fora)
                if (p.Id == editpscf)
                    editSacasCF.Obtentor__c = p.Obtentor__c;    

        return null;    
    }
    
    public PageReference eliminarInfraestructura(){     
        elimInfr = ApexPages.currentPage().getParameters().get('eliminarInfr');
        if (elimInfr != null){
            CRM_Infraestructura__c eliminar = [Select Id From CRM_Infraestructura__c Where Id = : elimInfr];
            delete eliminar;
        }    
        
        PageReference pr;
        if (ApexPages.currentPage().getURL() != null && ApexPages.currentPage().getURL().contains('Planejamiento')){
            pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
        }else{
            pr = new PageReference('/apex/CRM_Infraestructura');
        }
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarCalendario(){      
        eliminarCalendario = ApexPages.currentPage().getParameters().get('eliminarCal');
        if (eliminarCalendario != null){
            CRM_Calendario_de_Eventos__c eliminar = [Select Id From CRM_Calendario_de_Eventos__c Where Id = : eliminarCalendario];
            delete eliminar;
        }    
        
        PageReference pr = new PageReference('/apex/CRM_Calendario');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarPlaneamientoBMX(){        
        eliminar_planeamiento_BMX = ApexPages.currentPage().getParameters().get('eliminar_p_BMX');
        if (eliminar_planeamiento_BMX != null){
            CRM_Vendas__c eliminar = [Select Id From CRM_Vendas__c Where Id = : eliminar_planeamiento_BMX];
            delete eliminar;
            actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');
        }else{
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Es nulo!!!!!!!!!'); 
            ApexPages.addMessage(msg);
            return null;
        }    
        
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarPlaneamientoDMS(){        
        eliminar_planeamiento_DMS = ApexPages.currentPage().getParameters().get('eliminar_p_DMS');
        if (eliminar_planeamiento_DMS != null){
            CRM_Vendas__c eliminar = [Select Id From CRM_Vendas__c Where Id = : eliminar_planeamiento_DMS];
            delete eliminar;
            actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');
        }else{
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Es nulo!!!!!!!!!'); 
            ApexPages.addMessage(msg);
            return null;
        }    
        
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarVentaBMX(){        
        eliminar_venta_BMX = ApexPages.currentPage().getParameters().get('eliminar_v_BMX');
        if (eliminar_venta_BMX != null){
            CRM_Vendas__c eliminar = [Select Id From CRM_Vendas__c Where Id = : eliminar_venta_BMX];
            delete eliminar;
        }else{
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Es nulo!!!!!!!!!'); 
            ApexPages.addMessage(msg);
            return null;
        }    
        
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarVentaDMS(){        
        eliminar_venta_DMS = ApexPages.currentPage().getParameters().get('eliminar_v_DMS');
        if (eliminar_venta_DMS != null){
            CRM_Vendas__c eliminar = [Select Id From CRM_Vendas__c Where Id = : eliminar_venta_DMS];
            delete eliminar;
        }    
        
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarSacasV(){      
        eliminar_sacas_v = ApexPages.currentPage().getParameters().get('eliminar_s_v');
        if (eliminar_sacas_v != null){
            CRM_Vendas__c eliminar = [Select Id From CRM_Vendas__c Where Id = : eliminar_sacas_v];
            delete eliminar;
        }    
        
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarSacasCF(){     
        eliminar_sacas_cf = ApexPages.currentPage().getParameters().get('eliminar_s_cf');
        if (eliminar_sacas_cf != null){
            CRM_Vendas__c eliminar = [Select Id From CRM_Vendas__c Where Id = : eliminar_sacas_cf];
            delete eliminar;
            actualizarAreaAtuacion(crm_mult.Id, null);
        }    
        
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarSacasO(){      
        eliminar_sacas_o = ApexPages.currentPage().getParameters().get('eliminar_s_o');
        if (eliminar_sacas_o != null){
            CRM_Vendas__c eliminar = [Select Id From CRM_Vendas__c Where Id = : eliminar_sacas_o];
            delete eliminar;
            actualizarAreaAtuacion(crm_mult.Id, null);
        }    
        
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarPSacasO(){      
        eliminar_p_sacas_o = ApexPages.currentPage().getParameters().get('eliminar_p_s_o');
        if (eliminar_p_sacas_o != null){
            CRM_Vendas__c eliminar = [Select Id From CRM_Vendas__c Where Id = : eliminar_p_sacas_o];
            delete eliminar;
            actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');
        }    
        
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarPSacasV(){      
        eliminar_p_sacas_v = ApexPages.currentPage().getParameters().get('eliminar_p_s_v');
        if (eliminar_p_sacas_v != null){
            CRM_Vendas__c eliminar = [Select Id From CRM_Vendas__c Where Id = : eliminar_p_sacas_v];
            delete eliminar;
        }    
        
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarPSacasCF(){     
        eliminar_p_sacas_cf = ApexPages.currentPage().getParameters().get('eliminar_p_s_cf');
        if (eliminar_p_sacas_cf != null){
            CRM_Vendas__c eliminar = [Select Id From CRM_Vendas__c Where Id = : eliminar_p_sacas_cf];
            delete eliminar;
            actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');
        }    
        
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference eliminarAreaAtuacion(){        
        elim_areaa = ApexPages.currentPage().getParameters().get('eliminar_area_a');
        if (elim_areaa != null){
            CRM_Area_de_Atuacion__c eliminar = [Select Id From CRM_Area_de_Atuacion__c Where Id = : elim_areaa];
            delete eliminar;
        }    
        
        PageReference pr;
        if (ApexPages.currentPage().getURL() != null && ApexPages.currentPage().getURL().contains('Planeamiento')){
            pr = new PageReference('/apex/CRM_Planeamiento_Area_Atuacion');
        }else{
            pr = new PageReference('/apex/CRM_Area_Atuacion');
        }
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
            
    }
    
    public PageReference cancelEditVentaDMS(){      
        this.editvdms = null;   

        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditVentaBMX(){      
        this.editvbmx = null;   

        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditPlaneamientoBMX(){      
        this.editpbmx = null;   

        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditPlaneamientoDMS(){      
        this.editpdms = null;   

        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditPlaneamientoSacasV(){        
        this.editpsv = null; 

        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditSacasV(){        
        this.editsv = null; 

        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditSacasCF(){       
        this.editscf = null;    

        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditPSacasCF(){       
        this.editpscf = null;    

        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditSacasO(){        
        this.editso = null; 

        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public void cancelEditNewItemCal(){        
        this.editNewItemEvento = null;         
    }
    
    public PageReference cancelEditPSacasO(){        
        this.editpso = null; 

        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditAreaAtuacion(){      
        this.editareaa = null;  

        PageReference pr;
        if (ApexPages.currentPage().getURL() != null && ApexPages.currentPage().getURL().contains('Planeamiento')){
            pr = new PageReference('/apex/CRM_Planeamiento_Area_Atuacion');
        }else{
            pr = new PageReference('/apex/CRM_Area_Atuacion');
        }
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditInfraestructura_A(){     
        this.editInfrA = null;  

        PageReference pr;
        if (ApexPages.currentPage().getURL() != null && ApexPages.currentPage().getURL().contains('Planejamiento')){
            pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
        }else{
            pr = new PageReference('/apex/CRM_Infraestructura');
        }
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditInfraestructura_G(){     
        this.editInfrG = null;  

        PageReference pr;
        if (ApexPages.currentPage().getURL() != null && ApexPages.currentPage().getURL().contains('Planejamiento')){
            pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
        }else{
            pr = new PageReference('/apex/CRM_Infraestructura');
        }
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditInfraestructura_B(){     
        this.editInfrB = null;  

        PageReference pr;
        if (ApexPages.currentPage().getURL() != null && ApexPages.currentPage().getURL().contains('Planejamiento')){
            pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
        }else{
            pr = new PageReference('/apex/CRM_Infraestructura');
        }
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditInfraestructura_F(){     
        this.editInfrF = null;  

        PageReference pr;
        if (ApexPages.currentPage().getURL() != null && ApexPages.currentPage().getURL().contains('Planejamiento')){
            pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
        }else{
            pr = new PageReference('/apex/CRM_Infraestructura');
        }
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditInfraestructura_C(){     
        this.editInfrC = false; 

        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
            
    public PageReference cancelEditInfraestructura_D(){     
        this.editInfrD = false; 

        PageReference pr = new PageReference('/apex/CRM_Infraestructura');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditInfraestructura_E(){     
        this.editInfrE = false; 

        PageReference pr = new PageReference('/apex/CRM_Infraestructura');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditPInfraestructura_C(){     
        this.editPInfrC = false; 

        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
            
    public PageReference cancelEditPInfraestructura_D(){     
        this.editPInfrD = false; 

        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditPInfraestructura_E(){     
        this.editPInfrE = false; 

        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditDatosBonifBRMX(){       
        this.editDatosBonifBRMX = false; 
        
        PageReference pr = new PageReference('/apex/CRM_Datos_Bonificacion');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditDatosBonifDSEM(){       
        this.editDatosBonifDSEM = false; 
        
        PageReference pr = new PageReference('/apex/CRM_Datos_Bonificacion');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditCanalVendas(){       
        this.editCanalDeVendas = false; 

        PageReference pr = new PageReference('/apex/CRM_Canal_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditVendas(){        
        this.editarVendas = false;  

        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditTSacasV(){       
        this.editTotalSacasV = false;   

        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditTSacasCF(){      
        this.editTotalSacasCF = false;  

        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference cancelEditCalendario(){        
        this.editCalendario = null; 

        PageReference pr = new PageReference('/apex/CRM_Calendario');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;      
    }
    
    public PageReference saveEditPlaneamientoBMX(){
        saveedit_planeamiento_bmx = ApexPages.currentPage().getParameters().get('saveedit_p_BMX');
        if (saveedit_planeamiento_bmx != null){
            for (CRM_Vendas__c p : planeamiento_bmx){
                if (p.Id == saveedit_planeamiento_bmx)
                    p.Variedad__c = editVariedadBMX;    
            }   
            update planeamiento_BMX;
            actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');
        }       
                        
        editpbmx = null;
        saveedit_planeamiento_bmx = null;
            
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    }
    
    public PageReference saveEditPlaneamientoDMS(){
        saveedit_planeamiento_dms = ApexPages.currentPage().getParameters().get('saveedit_p_DMS');
        if (saveedit_planeamiento_dms != null){
            for (CRM_Vendas__c p : planeamiento_dms){
                if (p.Id == saveedit_planeamiento_dms)
                    p.Variedad__c = editVariedadDMS;    
            }   
            update planeamiento_DMS;
            actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');
        }       
                        
        editpdms = null;
        saveedit_planeamiento_dms = null;
            
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    }
    
    public PageReference saveEditVentaBMX(){
        saveedit_venta_bmx = ApexPages.currentPage().getParameters().get('saveedit_v_BMX');
        if (saveedit_venta_bmx != null){
            for (CRM_Vendas__c v : ventas_bmx){
                if (v.Id == saveedit_venta_bmx)
                    v.Variedad__c = editVariedadBMX;    
            }   
            update ventas_BMX;
        }       
                        
        editvbmx = null;
        saveedit_venta_bmx = null;
            
        return null;
    }
    
    public PageReference saveEditVentaDMS(){
        saveedit_venta_DMS = ApexPages.currentPage().getParameters().get('saveedit_v_DMS');
        if (saveedit_venta_DMS != null){
            for (CRM_Vendas__c v : ventas_dms){
                if (v.Id == saveedit_venta_dms)
                    v.Variedad__c = editVariedadDMS;    
            }   
            update ventas_DMS;
        }       
                        
        editvdms = null;
        saveedit_venta_dms = null;
            
        return null;
    }
    
    public PageReference saveEditSacasV(){
        saveedit_sacas_v = ApexPages.currentPage().getParameters().get('saveedit_s_v');
        if (saveedit_sacas_v != null){
            for (CRM_Vendas__c v : sacas_verticaliza){
                if (v.Id == saveedit_sacas_v)
                    v.Obtentor__c = editSacasV.Obtentor__c; 
            }   
            update sacas_verticaliza;
        }       
                        
        editsv = null;
        saveedit_sacas_v = null;
        
        sumarizar_ventas();
            
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
        
    }
    
    public PageReference saveEditSacasCF(){
        saveedit_sacas_cf = ApexPages.currentPage().getParameters().get('saveedit_s_cf');
        if (saveedit_sacas_cf != null){
            for (CRM_Vendas__c v : sacas_compra_fora){
                if (v.Id == saveedit_sacas_cf)
                    v.Obtentor__c = editSacasCF.Obtentor__c;    
            }   
            update sacas_compra_fora;
            actualizarAreaAtuacion(crm_mult.Id, null);
        }       
                        
        editscf = null;
        saveedit_sacas_cf = null;
        
        sumarizar_ventas();
            
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
        
    } 
    
    public void confirmEditItemCal(){
        Integer linea = Integer.valueOf(ApexPages.currentPage().getParameters().get('confir_edit_new_item_cal'));
        ver_calendario_detalles[linea].Obtentor__c = editNuevoItemEvento.Obtentor__c;
        editNewItemEvento = null;                                                                    
    }       
    
    public void confirmEditNewItemCal(){
        Integer linea = Integer.valueOf(ApexPages.currentPage().getParameters().get('confir_edit_new_item_cal'));
        nuevo_calendario_detalles[linea].Obtentor__c = editNuevoItemEvento.Obtentor__c;
        editNewItemEvento = null;                                                                    
    }
    
    public PageReference saveEditSacasO(){
        saveedit_sacas_o = ApexPages.currentPage().getParameters().get('saveedit_s_o');
        if (saveedit_sacas_o != null){
            for (CRM_Vendas__c v : sacas_outros){
                if (v.Id == saveedit_sacas_o){
                    v.Obtentor__c = editSacasO.Obtentor__c;
                    v.Variedad__c = editProdOutros;
                }   
            }   
            update sacas_outros;
            actualizarAreaAtuacion(crm_mult.Id, null);
        }       
                        
        editso = null;
        saveedit_sacas_o = null;
            
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    }
    
    public PageReference saveEditPSacasO(){
        saveedit_p_sacas_o = ApexPages.currentPage().getParameters().get('saveedit_p_s_o');
        if (saveedit_p_sacas_o != null){
            for (CRM_Vendas__c p : planeamiento_sacas_outros){
                if (p.Id == saveedit_p_sacas_o){
                    p.Obtentor__c = editSacasO.Obtentor__c;
                    p.Variedad__c = editProdOutros;
                }   
            }   
            update planeamiento_sacas_outros;
            actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');
        }       
                        
        editpso = null;
        saveedit_p_sacas_o = null;
            
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    }
    
    public PageReference saveEditPSacasV(){
        saveedit_p_sacas_v = ApexPages.currentPage().getParameters().get('saveedit_p_s_v');
        if (saveedit_p_sacas_v != null){
            for (CRM_Vendas__c p : planeamiento_sacas_verticaliza){
                if (p.Id == saveedit_p_sacas_v)
                    p.Obtentor__c = editSacasV.Obtentor__c; 
            }   
            update planeamiento_sacas_verticaliza;
        }       
                        
        editpsv = null;
        saveedit_p_sacas_v = null;
        
        sumarizar_planeamiento(crm_mult.Id);
            
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    }
    
    public PageReference saveEditPSacasCF(){
        saveedit_p_sacas_cf = ApexPages.currentPage().getParameters().get('saveedit_p_s_cf');
        if (saveedit_p_sacas_cf != null){
            for (CRM_Vendas__c p : planeamiento_sacas_compra_fora){
                if (p.Id == saveedit_p_sacas_cf)
                    p.Obtentor__c = editSacasCF.Obtentor__c;    
            }   
            update planeamiento_sacas_compra_fora;
            actualizarAreaAtuacion(crm_mult.Id, 'PLANEAMIENTO');
        }       
                        
        editpscf = null;
        saveedit_p_sacas_cf = null;
        
        sumarizar_planeamiento(crm_mult.Id);
            
        PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    }
    
    public PageReference saveEditPInfraestructura_A(){   
        
        try{
            
            if (plan_infraestructura_A.size() > 0){
               for(Integer i = 0; i < plan_infraestructura_A.size(); i++){
                    plan_infraestructura_A[i].Region__c = null;
                    if(ciudades.get(plan_infraestructura_A[i].Cidade__c) != null)
                        plan_infraestructura_A[i].Region__c = ciudades.get(plan_infraestructura_A[i].Cidade__c);
               }        
               update plan_infraestructura_A;
            }
            editInfrA = null;
                        
            PageReference pr = new PageReference('/apex/CRM_Planejamiento_Infraestructura');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
            
    }
    
    public PageReference saveEditInfraestructura_A(){   
        
        try{
            
            if (infraestructura_A.size() > 0){
               for(Integer i = 0; i < infraestructura_A.size(); i++){
                    infraestructura_A[i].Region__c = null;
                    if(ciudades.get(infraestructura_A[i].Cidade__c) != null)
                        infraestructura_A[i].Region__c = ciudades.get(infraestructura_A[i].Cidade__c);
               }        
               update infraestructura_A;
            }
            editInfrA = null;
            
            //return null;
            
            PageReference pr = new PageReference('/apex/CRM_Infraestructura');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
            
    }
    
    public PageReference saveEditPInfraestructura_G(){   
        
        try{
            
            if (plan_infraestructura_G.size() > 0){
               for(Integer i = 0; i < plan_infraestructura_G.size(); i++){
                    plan_infraestructura_G[i].Region__c = null;
                    if(ciudades.get(plan_infraestructura_G[i].Cidade__c) != null)
                        plan_infraestructura_G[i].Region__c = ciudades.get(plan_infraestructura_G[i].Cidade__c);
               }
               update plan_infraestructura_G;
            }
            editInfrG = null;
            
            return null;
            
        }catch (Exception e){
            String mens = e.getMessage();            
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
            
    }
    
    public PageReference saveEditInfraestructura_G(){   
        
        try{
            
            if (infraestructura_G.size() > 0){
               for(Integer i = 0; i < infraestructura_A.size(); i++){
                    infraestructura_A[i].Region__c = null;
                    if(ciudades.get(infraestructura_A[i].Cidade__c) != null)
                        infraestructura_A[i].Region__c = ciudades.get(infraestructura_A[i].Cidade__c);
               }
               update infraestructura_G;
            }
            editInfrG = null;
            
            return null;
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
            
    }
    
    public PageReference saveEditPInfraestructura_B(){
        
        try{
            
            for (CRM_Infraestructura__c i : plan_infraestructura_B)
                if (i.Id == editInfrB)
                    i.Produto__c = editAgroquimico;
                                                    
            update plan_infraestructura_B;
            
            editInfrB = null;   
            
            return null;   
            
        }catch (Exception e){
            String mens = e.getMessage();            
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
            
    }
    
    public PageReference saveEditInfraestructura_B(){
        
        try{
                    
            /*if (infraestructura_B.size() > 0)
               update infraestructura_B;
        
            editInfrB = null;
            
            return null;*/
            
            for (CRM_Infraestructura__c i : infraestructura_B)
                if (i.Id == editInfrB)
                    i.Produto__c = editAgroquimico;
                                                    
            update infraestructura_B;
            
            editInfrB = null;   
            
            PageReference pr = new PageReference('/apex/CRM_Infraestructura');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;   
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
            
    }
    
    public PageReference saveEditPInfraestructura_F(){
        
        try{
                
            if (plan_infraestructura_F.size() > 0)
               update plan_infraestructura_F;
        
            editInfrF = null;
            
            return null;
            
        }catch (Exception e){
            String mens = e.getMessage();            
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        } 
            
    }
    
    public PageReference saveEditInfraestructura_F(){
        
        try{
                
            if (infraestructura_F.size() > 0)
               update infraestructura_F;
        
            editInfrF = null;
            
            return null;
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        } 
            
    }
    
    public PageReference saveDatosBonif(){

        try{
            if (crm_mult == null)
                crear_crm_mult();
            upsert crm_mult;
        
            editDatosBonifBRMX = null;
            editDatosBonifDSEM = null;
                    
            PageReference pr = new PageReference('/apex/CRM_Datos_Bonificacion');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();            
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
                        
    }
    
    public PageReference saveInfraestructura(){

        try{
            if (crm_mult == null)
                crear_crm_mult();
            upsert crm_mult;
        
            editInfrC = null;
            editInfrD = null;
            editInfrE = null;
            editInfrF = null;
        
            PageReference pr = new PageReference('/apex/CRM_Vendas');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
                        
    }
    
    public PageReference savePInfraestructura(){

        try{
            if (crm_mult == null)
                return null;
            upsert crm_mult;
        
            editPInfrC = false;
            editPInfrD = false;
            editPInfrE = false;
            editInfrF = null;
        
            PageReference pr = new PageReference('/apex/CRM_Planejamiento_Vendas');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
                        
    }
    
    public PageReference saveCanalVendas(){      
        
        try{   
            crm_mult.Cuenta__c = accId;
            crm_mult.Safra__c = campania;
                            
            Double agric = 0;
            Double coop = 0;
            Double corr = 0;
            Double mult = 0;
            Double pool = 0;
            Double rev = 0;
            
            if (crm_mult.CV_Agricultores_Porc__c != null)
                agric = crm_mult.CV_Agricultores_Porc__c;
            if (crm_mult.CV_Cooperadores_Porc__c != null)
                coop = crm_mult.CV_Cooperadores_Porc__c;
            if (crm_mult.CV_Corretoras_Porc__c != null)
                corr = crm_mult.CV_Corretoras_Porc__c;
            if (crm_mult.CV_Multiplicadores_Porc__c != null)
                mult = crm_mult.CV_Multiplicadores_Porc__c;
            if (crm_mult.CV_Pool_de_Compras_Porc__c != null)
                pool = crm_mult.CV_Pool_de_Compras_Porc__c;             
            if (crm_mult.CV_Revendas_Porc__c != null)
                rev = crm_mult.CV_Revendas_Porc__c;
            
            if ((agric + coop + corr + mult + pool + rev) > 100){               
                String mens = 'La suma se porcentajes no debe superar el 100%';
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
                ApexPages.addMessage(msg);  
                return null;
            }
            
            upsert crm_mult;
        
            editCanalDeVendas = false;
            
            PageReference pr = new PageReference('/apex/CRM_Canal_Vendas');
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;
        }
    }
    
    public PageReference saveVendas(){      
        crm_mult.Cuenta__c = accId;
        crm_mult.Safra__c = campania;
        
        upsert crm_mult;
        
        editarVendas = false;
        editTotalSacasV = false;
        editTotalSacasCF = false;
            
        PageReference pr = new PageReference('/apex/CRM_Vendas');
        pr.getParameters().put('id',this.accId);
        pr.getParameters().put('nombre',this.nombre_cuenta);
        return pr;
    }       
    
    public PageReference saveEditCalendario(){      
        
        try{
        
            if (calendario.size() > 0)
               update calendario;
        
            editCalendario = null;
            
            return null;
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
    }
    
    public PageReference saveEditAreaAtuacion(){    
        
        try{
        
            String Id_area = ApexPages.currentPage().getParameters().get('save_area_a');    
            //CRM_Area_de_Atuacion__c a = [Select Id, Regi_o__c, Sacas__c From CRM_Area_de_Atuacion__c Where Id = : Id_area];
            CRM_Area_de_Atuacion__c a = [Select Id, Cuenta__c, Safra__c, Tipo__c, Regi_o__c, Sacas__c From CRM_Area_de_Atuacion__c Where Id = : Id_area];
        
            List<CRM_Area_de_Atuacion__c> existe = New List<CRM_Area_de_Atuacion__c>();
            existe = [Select Id, Sacas__c, Porcentaje_Vendas__c From CRM_Area_de_Atuacion__c Where Cuenta__c = : a.Cuenta__c And Safra__c = : a.Safra__c And Regi_o__c = : editRegAreaA And Tipo__c = : a.Tipo__c And Id != : a.Id limit 1];
            if (existe.size() > 0){
                //existe[0].Sacas__c += editCantAreaA;
                existe[0].Porcentaje_Vendas__c = editPorcentajeAreaA;
                if (a.Tipo__c == null){
                    existe[0].Sacas__c = (editPorcentajeAreaA * crm_mult.Ventas_Totales__c / 100).divide(1, 0, System.RoundingMode.HALF_UP);
                }else{
                    existe[0].Sacas__c = (editPorcentajeAreaA * Decimal.valueOf(totalPlaneamientoBMX + totalPlaneamientoDMS + totalPlaneamientoOutros + totalPlaneamientoSacasCF) / 100).divide(1, 0, System.RoundingMode.HALF_UP);
                }
                update existe;     
                delete a;           
            }else{                  
                a.Regi_o__c = editRegAreaA;    
                //a.Sacas__c = editCantAreaA;
                a.Porcentaje_Vendas__c = editPorcentajeAreaA;
                if (a.Tipo__c == null){
                    a.Sacas__c = (editPorcentajeAreaA * crm_mult.Ventas_Totales__c / 100).divide(1, 0, System.RoundingMode.HALF_UP);
                }else{
                    a.Sacas__c = (editPorcentajeAreaA * Decimal.valueOf(totalPlaneamientoBMX + totalPlaneamientoDMS + totalPlaneamientoOutros + totalPlaneamientoSacasCF) / 100).divide(1, 0, System.RoundingMode.HALF_UP);
                }        
                update a;
            }
        
            editCantAreaA = null;
            editPorcentajeAreaA = null;
            editRegAreaA = null;
            editareaa = null;       
            elim_areaa = null;
            
            PageReference pr;
            if (ApexPages.currentPage().getURL() != null && ApexPages.currentPage().getURL().contains('Planeamiento')){
                pr = new PageReference('/apex/CRM_Planeamiento_Area_Atuacion');
            }else{
                pr = new PageReference('/apex/CRM_Area_Atuacion');
            }
            pr.getParameters().put('id',this.accId);
            pr.getParameters().put('nombre',this.nombre_cuenta);
            return pr;
            
        }catch (Exception e){
            String mens = e.getMessage();
            //mens = mens.split(',')[1];
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }    
    }
    
    public PageReference adicionarPlanInfA(){               
        adicionar_plan_inf_A = !adicionar_plan_inf_A;
        return null;
    }
    
    public PageReference adicionarPlanInfG(){               
        adicionar_plan_inf_G = !adicionar_plan_inf_G;
        return null;
    }
    
    public PageReference adicionarPlanInfB(){               
        adicionar_plan_inf_B = !adicionar_plan_inf_B;
        return null;
    }
    
    public PageReference adicionarPlanInfF(){               
        adicionar_plan_inf_F = !adicionar_plan_inf_F;
        return null;
    }
    
    public PageReference adicionarInfA(){               
        adicionar_inf_A = !adicionar_inf_A;
        return null;
    }
    
    public PageReference adicionarInfG(){               
        adicionar_inf_G = !adicionar_inf_G;
        return null;
    }
    
    public PageReference adicionarInfB(){               
        adicionar_inf_B = !adicionar_inf_B;
        return null;
    }
    
    public PageReference adicionarInfF(){               
        adicionar_inf_F = !adicionar_inf_F;
        return null;
    }
    
    public PageReference adicionarPlaneamientoDMS(){               
        adicionar_planeamiento_DMS = !adicionar_planeamiento_DMS;
        return null;
    }
    
    public PageReference adicionarPlaneamientoBMX(){               
        adicionar_planeamiento_BMX = !adicionar_planeamiento_BMX;
        return null;
    }
    
    public PageReference adicionarVentaBMX(){               
        adicionar_venta_BMX = !adicionar_venta_BMX;
        return null;
    }
    
    public PageReference adicionarVentaDMS(){               
        adicionar_venta_DMS = !adicionar_venta_DMS;
        return null;
    }
    
    public PageReference adicionarSacasV(){             
        adicionar_sacas_v = !adicionar_sacas_v;
        return null;
    }
    
    public PageReference adicionarSacasCF(){                
        adicionar_sacas_cf = !adicionar_sacas_cf;
        return null;
    }
    
    public PageReference adicionarSacasO(){             
        adicionar_sacas_o = !adicionar_sacas_o;
        return null;
    }
    
    public PageReference adicionarPSacasO(){             
        adicionar_p_sacas_o = !adicionar_p_sacas_o;
        return null;
    }
    
    public PageReference adicionarPSacasV(){             
        adicionar_p_sacas_v = !adicionar_p_sacas_v;
        return null;
    }
    
    public PageReference adicionarPSacasCF(){                
        adicionar_p_sacas_cf = !adicionar_p_sacas_cf;
        return null;
    }
    
    public PageReference setearEstadoNewCalendario(){                       
        estadoNewCal = '';      
        if (nuevo_calendario.Municipio__c != null){
            Cidade__c ciu = [Select Id, Estado__r.Name From Cidade__c Where Id = : nuevo_calendario.Municipio__c];
            estadoNewCal = ciu.Estado__r.Name;          
        }
                            
        return null;
    }
    
    public PageReference setearEstadoEditCalendario2(){                       
        estadoEditCal2 = '';      
        if (ver_calendario.Municipio__c != null){
            Cidade__c ciu = [Select Id, Estado__r.Name From Cidade__c Where Id = : ver_calendario.Municipio__c];
            estadoEditCal2 = ciu.Estado__r.Name;          
        }
                            
        return null;
    }
    
    public PageReference setearEstadoEditCalendario(){  
        estadoEditCal = '';
        Id idCal = ApexPages.currentPage().getParameters().get('idCal');
        for (CRM_Calendario_de_Eventos__c c : calendario)
        if (c.Id == idCal){
            if (c.Municipio__c != null){
                Cidade__c ciu = [Select Id, Estado__r.Name From Cidade__c Where Id = : c.Municipio__c];
                estadoEditCal = ciu.Estado__r.Name;
            }    
        }
                            
        return null;
    }
    
    public void sumarizar_ventas(){
    
        totalVentasBMX = 0;
        totalVentasDMS = 0;
        totalVentasOutros = 0;
        totalVolProduzidoBMX = 0;
        totalVolProduzidoDMS = 0;
        totalVolProduzidoOutros = 0;
        totalVolProduzidoSV = 0;
        totalVolProduzidoSCF = 0;
                
        if (ventas_BMX != null)
            for (CRM_Vendas__c v : ventas_BMX){
                if(v.Volume__c != null)
                    totalVentasBMX += v.Volume__c;
                if(v.Volume_Produzido__c != null)
                    totalVolProduzidoBMX += v.Volume_Produzido__c;    
            }
        
        if (ventas_DMS != null)    
            for (CRM_Vendas__c v : ventas_DMS){
                if(v.Volume__c != null)
                    totalVentasDMS += v.Volume__c;
                if(v.Volume_Produzido__c != null)
                    totalVolProduzidoDMS += v.Volume_Produzido__c;    
            }    
                
        if (sacas_outros != null)    
            for (CRM_Vendas__c v : sacas_outros){
                if(v.Volume__c != null)
                    totalVentasOutros += v.Volume__c;
                if(v.Volume_Produzido__c != null)
                    totalVolProduzidoOutros += v.Volume_Produzido__c;    
            }
            
        if (sacas_verticaliza != null)    
            for (CRM_Vendas__c v : sacas_verticaliza){                
                if(v.Volume_Produzido__c != null)
                    totalVolProduzidoSV += v.Volume_Produzido__c;    
            }  
              
        if (sacas_compra_fora != null)    
            for (CRM_Vendas__c v : sacas_compra_fora){                
                if(v.Volume_Produzido__c != null)
                    totalVolProduzidoSCF += v.Volume_Produzido__c;    
            } 
        
    }
    
    /*
    public void sumarizar_planeamiento(){
    
        totalPlaneamientoBMX = 0;
        totalPlaneamientoDMS = 0;
        totalPlaneamientoOutros = 0;
        totalPlaneamientoSacasVerticaliza = 0;
        totalPlaneamientoSacasCF = 0;
                
        if (planeamiento_BMX != null)
            for (CRM_Vendas__c p : planeamiento_BMX)
                if(p.Volume__c != null)
                    totalPlaneamientoBMX += p.Volume__c;
        
        if (planeamiento_DMS != null)    
            for (CRM_Vendas__c p : planeamiento_DMS)
                if(p.Volume__c != null)
                    totalPlaneamientoDMS += p.Volume__c;    
                
        if (planeamiento_sacas_outros != null)    
            for (CRM_Vendas__c p : planeamiento_sacas_outros)
                if(p.Volume__c != null)
                    totalPlaneamientoOutros += p.Volume__c;
                    
        if (planeamiento_sacas_verticaliza != null)    
            for (CRM_Vendas__c p : planeamiento_sacas_verticaliza)
                if(p.Volume__c != null)
                    totalPlaneamientoSacasVerticaliza += p.Volume__c;            
                    
        if (planeamiento_sacas_compra_fora != null)    
            for (CRM_Vendas__c p : planeamiento_sacas_compra_fora)
                if(p.Volume__c != null)
                    totalPlaneamientoSacasCF += p.Volume__c;            
        
        
    }
    */
    
    public void actualizarAreaAtuacion(Id crm, String tipo){
        
        String idCuenta;
        String safra;
        Double ventasT;
        
        for (CRM_Multiplicador__c crm_mult : [Select Id, Cuenta__c, Safra__c, Ventas_Totales__c From CRM_Multiplicador__c Where Id = : crm limit 1]){
            idCuenta = crm_mult.Cuenta__c;
            safra = crm_mult.Safra__c;
            ventasT = crm_mult.Ventas_Totales__c;           
        }
        
        if (ventasT == null)
            ventasT = 0;
        
        if (idCuenta != null && idCuenta != '' && safra != null && safra != ''){
            if (tipo == 'PLANEAMIENTO'){
                sumarizar_planeamiento(crm_mult.Id);
                ventasT = totalPlaneamientoBMX + totalPlaneamientoDMS + totalPlaneamientoOutros + totalPlaneamientoSacasCF;
            }
            List<CRM_Area_de_Atuacion__c> areaA = New List<CRM_Area_de_Atuacion__c>();
            areaA = [Select Id, Porcentaje_Vendas__c, Sacas__c From CRM_Area_de_Atuacion__c Where Cuenta__c = : idCuenta And Safra__c = : safra And Tipo__c = : tipo And Porcentaje_Vendas__c != null];
            if (areaA.size() > 0){
                for (CRM_Area_de_Atuacion__c a : areaA)
                    a.Sacas__c = (a.Porcentaje_Vendas__c * ventasT / 100).divide(1, 0, System.RoundingMode.HALF_UP);
                update areaA;
            }                                           
        }    
                    
    }
        
    public void sumarizar_planeamiento(Id crm){
    
        totalPlaneamientoBMX = 0;
        totalPlaneamientoDMS = 0;
        totalPlaneamientoOutros = 0;
        totalPlaneamientoSacasVerticaliza = 0;
        totalPlaneamientoSacasCF = 0;
        
        for (CRM_Vendas__c crmv : [Select Id, Volume__c, RecordType.Name, Variedad__r.Sociedad__c From CRM_Vendas__c Where CRM_Multiplicador__c = : crm And RecordType.Name In ('F','G', 'H', 'I')]){
            if (crmv.RecordType.Name == 'F' && crmv.Variedad__r.Sociedad__c == 'BRMX' && crmv.Volume__c != null)            
                totalPlaneamientoBMX += crmv.Volume__c;
            if (crmv.RecordType.Name == 'F' && crmv.Variedad__r.Sociedad__c == 'DSEM' && crmv.Volume__c != null)
                totalPlaneamientoDMS += crmv.Volume__c; 
            if (crmv.RecordType.Name == 'G' && crmv.Volume__c != null)
                totalPlaneamientoOutros += crmv.Volume__c;  
            if (crmv.RecordType.Name == 'H' && crmv.Volume__c != null)
                totalPlaneamientoSacasVerticaliza += crmv.Volume__c;    
            if (crmv.RecordType.Name == 'I' && crmv.Volume__c != null)
                totalPlaneamientoSacasCF += crmv.Volume__c; 
        }       
        
    }
    
    public void sumarizar_plan_infr(){
    
        totalPlanInfCapPorUBS = 0;
        totalPlanInfProdPorUBS = 0;
        totalPlanInfCapPorEmpresa = 0;
        totalPlanInfVolTPorEmpresa = 0;
                
        if (plan_infraestructura_A != null)
            for (CRM_Infraestructura__c v : plan_infraestructura_A){
                if(v.Capacidade__c != null)
                    totalPlanInfCapPorUBS += v.Capacidade__c;
                if(v.Produccion_Real_Actual__c != null)
                    totalPlanInfProdPorUBS += v.Produccion_Real_Actual__c;    
            }
        
        if (plan_infraestructura_B != null)    
            for (CRM_Infraestructura__c v : plan_infraestructura_B){
                if(v.Capacidade__c != null)
                    totalPlanInfCapPorEmpresa += v.Capacidade__c;   
                if(v.Volume_Tratado__c != null)
                    totalPlanInfVolTPorEmpresa += v.Volume_Tratado__c;    
            }                         
        
        
    }
    
    public String validacionesEncerrar(){
        
        String qry;
        String retorno = '';
        
        qry = 'Select ';
        for(String s : objectFields_CRM_Mult.keySet())
            qry += ' ' + s + ',';                                                      
        qry = qry.substring(0,qry.length() - 1);
        qry += ' From CRM_Multiplicador__c Where Id = \'' + crm_mult.Id + '\' limit 1';         
               
        CRM_Multiplicador__c crm = New CRM_Multiplicador__c();
        List<CRM_Multiplicador__c> result = New List<CRM_Multiplicador__c>(); 
        result = database.query(qry);
        if (result.size() > 0)
            crm = result[0];
                
        if (crm.Capacidade_x_cidade__c == 0)
            retorno = '<br/><br/>Infraestrutura: Deve ingressar ao menos um dado em Capacidade de Produção por UBS.';
            
        if (crm.Total_Produccion_Real_Actual__c > crm.Capacidade_x_cidade__c)
            retorno = '<br/><br/>Infraestrutura: O total de Produção Real/Produção não deve ser maior que o total de Capacidade de Produção por UBS.';
        
        if (crm.Trat_Sem_x_Empresa_Capac__c > crm.Capacidade_x_cidade__c)                
            retorno += '<br/><br/>Infraestrutura: Capacidade total de Tratamento por Empresa não deve ser maior que o total em Capacidade de Produção por UBS.';
                
        if (crm.Ventas_de_Sem_Tratada__c == null || crm.Vendas_de_Sem_sem_tratar__c == null)
            retorno += '<br/><br/>Infraestrutura: Deve completar Volume de Vendas em %.';
            
        if (crm.Area_multiplic_propia__c == null || crm.area_multiplic_terceirizada__c == null)
            retorno += '<br/><br/>Infraestrutura: Deve completar Campos de Produção de Sementes.';
            
        if (crm.Agronomos__c == null || crm.Agronomos__c == 0 || crm.Tecnicos__c == null || crm.Tecnicos__c == 0)
            retorno += '<br/><br/>Infraestrutura: Deve completar Equipe Comercial vinculada a Semente.';        
        
        /*              
        if (crm.Ventas_BMX__c == 0) 
            retorno += '<br/><br/>Vendas: Variedades BMX não deve estar vazio.';
            
        if (crm.Ventas_DMS__c == 0) 
            retorno += '<br/><br/>Vendas: Variedades DMS não deve estar vazio.';
        */  
            
        /*if (crm.Ventas_BMX__c == 0 && crm.Ventas_DMS__c == 0)
            retorno += '<br/><br/>Vendas: Variedades BMX ou Variedades DMS devem ter dados.';
        */
        Double total_area_a;
        AggregateResult[] area_a = [Select Sum(Sacas__c) Sacas From CRM_Area_de_Atuacion__c Where Cuenta__c = : this.accId And Safra__c = : this.campania And Tipo__c = null];        
        for (AggregateResult ar : area_a) 
            total_area_a = Double.valueof(ar.get('Sacas'));
            
        if (total_area_a == null)
            total_area_a = 0;
                    
        if (total_area_a > crm.Ventas_Totales__c)
            retorno += '<br/><br/>Area de Atuação: O total não deve ser maior que Vendas Totais.';
        
        Decimal agric = 0;
        Decimal coop = 0;
        Decimal corr = 0;
        Decimal mult = 0;
        Decimal pool = 0;
        Decimal rev = 0;
            
        if (crm.CV_Agricultores_Porc__c != null)
            agric = crm.CV_Agricultores_Porc__c;
        if (crm.CV_Cooperadores_Porc__c != null)
            coop = crm.CV_Cooperadores_Porc__c;
        if (crm.CV_Corretoras_Porc__c != null)
            corr = crm.CV_Corretoras_Porc__c;
        if (crm.CV_Multiplicadores_Porc__c != null)
            mult = crm.CV_Multiplicadores_Porc__c;
        if (crm.CV_Pool_de_Compras_Porc__c != null)
            pool = crm.CV_Pool_de_Compras_Porc__c;              
        if (crm.CV_Revendas_Porc__c != null)
            rev = crm.CV_Revendas_Porc__c;
            
        if ((agric + coop + corr + mult + pool + rev) <> 100)       
            retorno += '<br/><br/>Canal de vendas: O porcentagem total deve ser 100.';      
            
        Double total_cap_UBS_plan_infr;
        Double total_prod_UBS_plan_infr;
        AggregateResult[] plan_cap_UBS = [Select Sum(Capacidade__c) Capacidade, Sum(Produccion_Real_Actual__c) Prod From CRM_Infraestructura__c Where CRM_Multiplicador__c = : crm_mult.Id And RecordType.Name = 'P_A'];        
        for (AggregateResult ar : plan_cap_UBS){ 
            total_cap_UBS_plan_infr = Double.valueof(ar.get('Capacidade'));
            total_prod_UBS_plan_infr = Double.valueof(ar.get('Prod'));
        }
            
        if (total_cap_UBS_plan_infr == null)
            total_cap_UBS_plan_infr = 0;
        if (total_prod_UBS_plan_infr == null)
            total_prod_UBS_plan_infr = 0;   
                    
        if (total_cap_UBS_plan_infr == 0)
            retorno += '<br/><br/>Planejamiento de Infraestrutura: Deve ingressar ao menos um dado em Capacidade de Produção por UBS.';
            
        if (total_prod_UBS_plan_infr > total_cap_UBS_plan_infr)
            retorno += '<br/><br/>Planejamiento de Infraestrutura: O total de Produção Real/Produção não deve ser maior que o total de Capacidade de Produção por UBS.';    
            
        Double total_cap_empresa_plan_infr;
        AggregateResult[] plan_cap_empresa = [Select Sum(Capacidade__c) Capacidade From CRM_Infraestructura__c Where CRM_Multiplicador__c = : crm_mult.Id And RecordType.Name = 'P_B'];        
        for (AggregateResult ar : plan_cap_empresa) 
            total_cap_empresa_plan_infr = Double.valueof(ar.get('Capacidade'));
            
        if (total_cap_empresa_plan_infr == null)
            total_cap_empresa_plan_infr = 0;
                    
        if (total_cap_empresa_plan_infr > total_cap_UBS_plan_infr)
            retorno += '<br/><br/>Planejamiento de Infraestrutura: Capacidade total de Tratamento por Empresa não deve ser maior que o total em Capacidade de Produção por UBS.';           
        
        if (crm.Planejamiento_de_Sem_Tratada__c == null || crm.Planejamiento_de_Sem_sem_tratar__c == null)
            retorno += '<br/><br/>Planejamiento de Infraestrutura: Deve completar Volume de Vendas em %.';
            
        if (crm.Plan_Area_multiplic_propia__c == null || crm.plan_area_multiplic_terceirizada__c == null)
            retorno += '<br/><br/>Planejamiento de Infraestrutura: Deve completar Campos de Produção de Sementes.';
            
        if (crm.Planejamiento_Agronomos__c == null || crm.Planejamiento_Agronomos__c == 0 || crm.Planejamiento_Tecnicos__c == null || crm.Planejamiento_Tecnicos__c == 0)
            retorno += '<br/><br/>Planejamiento de Infraestrutura: Deve completar Equipe Comercial vinculada a Semente.';       
                
        sumarizar_planeamiento(crm_mult.Id);
        
        /*
        if (totalPlaneamientoBMX == 0) 
            retorno += '<br/><br/>Planejamiento de Vendas: Variedades BMX não deve estar vazio.';
            
        if (totalPlaneamientoDMS == 0) 
            retorno += '<br/><br/>Planejamiento de Vendas: Variedades DMS não deve estar vazio.';
        */
            
        if (totalPlaneamientoBMX == 0 && totalPlaneamientoDMS == 0)
            retorno += '<br/><br/>Planejamiento de Vendas: Variedades BMX ou Variedades DMS devem ter dados.';          
            
        Double totalPlaneamiento = totalPlaneamientoBMX + totalPlaneamientoDMS + totalPlaneamientoOutros + totalPlaneamientoSacasVerticaliza + totalPlaneamientoSacasCF;    
            
        Double total_plan_area_a;
        AggregateResult[] plan_area_a = [Select Sum(Sacas__c) Sacas From CRM_Area_de_Atuacion__c Where Cuenta__c = : this.accId And Safra__c = : this.campania And Tipo__c = 'PLANEAMIENTO'];        
        for (AggregateResult ar : plan_area_a) 
            total_plan_area_a = Double.valueof(ar.get('Sacas'));
            
        if (total_plan_area_a == null)
            total_plan_area_a = 0;
                    
        if (total_plan_area_a > totalPlaneamiento)
            retorno += '<br/><br/>Planejamiento Area de Atuação: O total não deve ser maior que Vendas Totais.';    
        
        if (retorno != '')
            retorno = retorno.substring(10,retorno.length());
            
        return retorno;
            
    }
    
    public PageReference cerrarDatos(){
        
        String val = validacionesEncerrar();        
        
        try{
        
            if (val == ''){         
                CRM_Multiplicador__c crm = [Select Id, Cerrado__c From CRM_Multiplicador__c Where Id = : crm_mult.Id];
                crm.Cerrado__c = true;
                update crm;
                PageReference pr = new PageReference('/apex/CRM_Infraestructura');
                pr.getParameters().put('id',this.accId);
                pr.getParameters().put('nombre',this.nombre_cuenta);
                return pr;
            }else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, val); 
                ApexPages.addMessage(msg);  
                return null;
            }
            
        }catch (Exception e){
            String mens = e.getMessage();           
            mens = mens.split(',')[mens.split(',').size() - 1];
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, mens); 
            ApexPages.addMessage(msg);  
            return null;                    
        }                   
        
    }
    
    public PageReference nuevoCalendario(){
        PageReference pr = new PageReference('/apex/CRM_Calendario_Nuevo'); 
        return pr;
    }
    
    public PageReference changeEventoNewCalendario(){
        this.nuevo_calendario.Marca__c = null;
        this.nuevo_calendario.Municipio__c = null;
        this.nuevo_calendario.Direccion__c = null;
        this.nuevo_calendario.Evaluacion__c = null;
        this.nuevo_calendario.Custo__c = null;
        this.nuevo_calendario.Numero_de_participantess__c = null;
        
        this.nuevo_calendario.Revenda__c = null;
        this.nuevo_calendario.Participante__c = null;
        this.nuevo_calendario.Latitud__c = null;
        this.nuevo_calendario.Longitud__c = null;
        this.nuevo_calendario.Data_e_horario_inicio__c = null;
        this.nuevo_calendario.Data_e_horario_termino__c = null;
        this.nuevo_calendario.Data__c = null;
        this.nuevo_calendario.Comentarios__c = null;
        this.estadoNewCal = null;
        
        return null;
    }
    
    public PageReference nuevoItemsCalendario(){
        if (nuevo_Calendario.Marca__c == null){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Debe ingresar Marca'); 
            ApexPages.addMessage(msg);  
            return null;
        }
        
        verItemsNewCalendario = true;
        nuevo_calendario_detalles.clear();
        editNewItemEvento = null;
        addNuevoItemEvento = New Product2();
        optionsAddNuevoEvento = new List<SelectOption>();
        //CRM_Detalle_Calendario_de_eventos__c det = New CRM_Detalle_Calendario_de_eventos__c();
        //nuevo_calendario_detalles.add(det);               
        
        nuevo_calendario_detalle = New List<CRM_Detalle_Calendario_de_eventos__c>();
        CRM_Detalle_Calendario_de_eventos__c nuevoDet = New CRM_Detalle_Calendario_de_eventos__c();
        nuevo_calendario_detalle.add(nuevoDet);
        
        nuevo_calendario_attach = New List<Attachment>();
        Attachment att = New Attachment();
        nuevo_calendario_attach.add(att);
        
        return null;
    }
    
    public PageReference cancelNuevoItemsCalendario(){
        verItemsNewCalendario = false;
        nuevo_calendario_detalles.clear();
        nuevo_calendario_detalle = null;
        
        nuevo_calendario_attachs.clear();
        nuevo_calendario_attach = null;
        
        return null;
    }
    
    
    public PageReference addNewItemCalendario(){
        nuevo_calendario_detalle[0].Obtentor__c = addNuevoItemEvento.Obtentor__c;
        nuevo_calendario_detalles.add(nuevo_calendario_detalle[0]);
        addNuevoItemEvento.Obtentor__c = null;
        optionsAddNuevoEvento.clear();
        nuevo_calendario_detalle.clear();
        CRM_Detalle_Calendario_de_eventos__c det = New CRM_Detalle_Calendario_de_eventos__c();
        nuevo_calendario_detalle.add(det);
        
        Integer i = 0;
        for (CRM_Detalle_Calendario_de_eventos__c v : nuevo_calendario_detalles){
            v.Indice__c = i;
            i++;
        }
                
        return null;
    }
    
    public PageReference addNewArchCalendario(){
        if(nuevo_calendario_attach==null)
            return null;
        nuevo_calendario_attachs.add(nuevo_calendario_attach[0]);
        nuevo_calendario_attach.clear();
        Attachment att = New Attachment();
        nuevo_calendario_attach.add(att);
                
        Integer i = 0;
        for (Attachment v : nuevo_calendario_attachs){
            v.Description = String.valueOf(i);
            i++;
        }
                    
        return null;
    }
    
    public PageReference addEditItemCalendario(){
        ver_calendario_detalle[0].Obtentor__c = addNuevoItemEvento.Obtentor__c;
        ver_calendario_detalles.add(ver_calendario_detalle[0]);
        addNuevoItemEvento.Obtentor__c = null;
        optionsAddNuevoEvento.clear();
        ver_calendario_detalle.clear();
        CRM_Detalle_Calendario_de_eventos__c det = New CRM_Detalle_Calendario_de_eventos__c();
        ver_calendario_detalle.add(det);
        
        Integer i = 0;
        for (CRM_Detalle_Calendario_de_eventos__c v : ver_calendario_detalles){
            v.Indice__c = i;
            i++;
        }
                
        return null;
    }
    
    public PageReference addEditArchCalendario(){
        
        if(ver_calendario_attach == null || ver_calendario_attach[0].body==null)
            return null;
            
        Attachment att = New Attachment();                              
        att.ParentId = ver_calendario.Id;                   
        att.Body = ver_calendario_attach[0].Body;
        att.Name = ver_calendario_attach[0].Name;
        insert att; 
        
        /*Decimal contador = ver_calendario.Arquivos_cont__c;
        ver_calendario.Arquivos_cont__c = contador + 1;
        update ver_calendario;*/
        
        PageReference pr = new PageReference('/apex/CRM_Calendario_Ver_Edit');
        pr.getParameters().put('editCal', ver_calendario.Id);
        return pr;              
        
    }
    
    public PageReference delNewArchCalendario(){
        if(ApexPages.currentPage().getParameters().get('elimNewArchCal')==null)
            return null;
        
        Integer linea = Integer.valueOf(ApexPages.currentPage().getParameters().get('elimNewArchCal'));     
        nuevo_calendario_attachs.remove(linea);             
        
        Integer i = 0;
        for (Attachment v : nuevo_calendario_attachs){
            v.Description = String.valueOf(i);
            i++;
        }   
        
        return null;

    }    
    
    public PageReference editarVerCalendario(){
        editVerCalendario = true;
        return null;
    }
    
    public PageReference cancelarEditarVerCalendario(){
        editVerCalendario = false;
        return null;
    }
    
    public PageReference delNewItemCalendario(){
        if(ApexPages.currentPage().getParameters().get('elimNewItemCal')==null)
            return null;
        Integer linea = Integer.valueOf(ApexPages.currentPage().getParameters().get('elimNewItemCal'));     
        nuevo_calendario_detalles.remove(linea);                
        
        Integer i = 0;
        for (CRM_Detalle_Calendario_de_eventos__c v : nuevo_calendario_detalles){
            v.Indice__c = i;
            i++;
        }   
        
        return null;

    }
         
    public PageReference delEditItemCalendario(){
        if(ApexPages.currentPage().getParameters().get('elimEditItemCal')==null)
            return null;
        Integer linea = Integer.valueOf(ApexPages.currentPage().getParameters().get('elimEditItemCal'));        
        CRM_Detalle_Calendario_de_eventos__c det = ver_calendario_detalles.get(linea);
        if (det.id != null)
            delete det;
        
        ver_calendario_detalles.remove(linea);    
        
        Integer i = 0;
        for (CRM_Detalle_Calendario_de_eventos__c v : ver_calendario_detalles){
            v.Indice__c = i;
            i++;
        }       
                
        return null;
    }
    
    public PageReference delEditArchCalendario(){
        if(ApexPages.currentPage().getParameters().get('elimEditArchCal')==null)
            return null;
        Integer linea = Integer.valueOf(ApexPages.currentPage().getParameters().get('elimEditArchCal'));        
        Attachment det = ver_calendario_attachs.get(linea);
        if (det.id != null)
            delete det;
        
        ver_calendario_attachs.remove(linea);    
        
        Integer i = 0;
        for (Attachment a : ver_calendario_attachs){
            a.Description = String.valueOf(i);
            i++;
        }       

/*        Decimal contador = ver_calendario.Arquivos_cont__c;
        ver_calendario.Arquivos_cont__c = contador - 1;
        update ver_calendario;
*/
        return null;
    }    
  
    public static void prueba(){
        Double a = 0;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
    }
}
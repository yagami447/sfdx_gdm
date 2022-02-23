/**
* @name WrapperCRM
* @author Jhonny Peroza
* updated 18-11-2021
*/
public with sharing class WrapperCRM {

    public class Estados {
        public String id {get; set;}
        public String nombre {get; set;}
        public String nombreEstado {get; set;}
        public Decimal porcentaje {get; set;}
    }

    public class Items {
        public String id {get; set;}
        public String nombre {get; set;}
        public String obtentor {get; set;}
        public String producto {get; set;}
    }

    public class Crm {
        public Decimal capacidadUBS {get; set;}
        public Decimal produccionTotalesSafraAnterior {get; set;}
        public Decimal ventasTotalesSafraAnterior {get; set;}
        public Decimal numeroDeVendedores {get; set;}
        public Decimal numeroDeUnidades {get; set;}
        public Decimal proyeccionProduccionSafraAnual {get; set;}
        public Decimal proyeccionVentaSafraAnual {get; set;}
        public Decimal ventaAgricultores {get; set;}
        public String accountId {get; set;}
        public String marca {get; set;}
        public String safra {get; set;}
        public String nombre {get; set;}
    }
}
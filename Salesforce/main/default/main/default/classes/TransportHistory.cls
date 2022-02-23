/**
* 
*/
public class TransportHistory {

    public String numeroPedidoSap {get; set;}
    public String inicioCarreg {get; set;}
    public String inicioTransp {get; set;}
    public String fimTransporte {get; set;}
    public String oppId {get; set;}
    public String oppName {get; set;}
	
    public TransportHistory(String numeroPedidoSap, String inicioCarreg, 
    String inicioTransp, String fimTransporte, Id opportunityId) {
        
        this.numeroPedidoSap = numeroPedidoSap;
        this.inicioCarreg = inicioCarreg;
        this.inicioTransp = inicioTransp;
        this.fimTransporte = fimTransporte;
        this.oppId = opportunityId;
        this.oppName = '';
        
    }
    
    public TransportHistory() {  
        
        this.numeroPedidoSap = '';
        this.inicioCarreg = '';
        this.inicioTransp = '';
        this.fimTransporte = '';
        this.oppId = '';
        this.oppName = '';
    }
    

}
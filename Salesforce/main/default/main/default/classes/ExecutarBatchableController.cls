public class ExecutarBatchableController {
   public String searchKey {get; set;}
   public Account contaSeleccionada {get; set;}
   public List<Account> cuentas {get; set;} 
   public String idContaSeleccionada {get;set;}
    
   public ExecutarBatchableController(){
      this.cuentas = new List<Account>();
   }
    
    public void buscarCuentas(){
        if(this.searchKey != null && this.searchKey != ''){ 
          this.contaSeleccionada  = null;
           this.idContaSeleccionada = null;         
              string searchquery='select Id,Name from account where Name like \'%'+ this.searchKey+'%\'  Limit 10';
           this.cuentas = Database.query(searchquery);
           if(this.cuentas.size() == 1){
              this.contaSeleccionada = this.cuentas.get(0);
           }
        }
    }
     public void borrarCuentas(){
      this.searchKey  = null;
      this.idContaSeleccionada = null;
      this.contaSeleccionada = null;
        this.cuentas.clear();
    }
    
    public void seleccionarCuenta(){
       if(this.idContaSeleccionada != null && this.idContaSeleccionada != ''){
          for(Account cta : this.cuentas){
             if(cta.Id == this.idContaSeleccionada ){
                 this.contaSeleccionada  = cta;
                 break;
             }
          }
       }
    }
    
    public void actualizarResponsable(){
        if(this.contaSeleccionada  == null){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Você deve selecionar uma conta.' ));
        }else{
            Set<Id> idCuenta = new Set<Id>{this.contaSeleccionada.Id};
                if(!Test.isRunningTest()){
                    this.actualizarOportunidades(idCuenta); 
            		this.actualizarCRMEventos(idCuenta); 
            		this.actualizarContratos(idCuenta);  
                }                      
        }
        this.borrarCuentas();
    }   
   
    private void actualizarOportunidades(Set<Id> idCuenta){
        BATCH_Opp_Actualizar_Responsable batchOpp = new BATCH_Opp_Actualizar_Responsable(idCuenta);
        Database.executeBatch(batchOpp);
    }
    
     private void actualizarCRMEventos(Set<Id> idCuenta){
        BATCH_Evento_Actualizar_Responsable batchEvento = new BATCH_Evento_Actualizar_Responsable(idCuenta);
        Database.executeBatch(batchEvento);
    }
    
    private void actualizarContratos(Set<Id> idCuenta){
        BATCH_Contrato_Actualizar_Responsable batchContrato = new BATCH_Contrato_Actualizar_Responsable(idCuenta);
        Database.executeBatch(batchContrato);
    }
    
    
}
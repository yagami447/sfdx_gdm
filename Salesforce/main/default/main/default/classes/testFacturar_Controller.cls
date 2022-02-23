@isTest
private class testFacturar_Controller{
    static testMethod void Inicio(){
    
    Facturar_Controller fc = new Facturar_Controller();
    
    fc.contrato.Tipo_de_Cota_o__c='SOJA';
    fc.contrato.Cotacao_de_soja__c='COAMO';
    
    fc.Buscar();  
    
    fc.contrato.Tipo_de_Cota_o__c='DOLAR';
    
    fc.Buscar();
    
    Opportunity o = new Opportunity(Name='TMP', StageName='Aberta', CloseDate=System.Today());
    
    fc.setFact_Param(o);
    o=fc.getFact_Param();
    fc.setOpp(o);
    o=fc.getOpp();
    insert o;
    Contrato__c c = new Contrato__c();
    fc.setContrato(c);
    c=fc.getContrato();
    
    OpportunityLineItem i = new OpportunityLineItem();
    fc.setItem(i);
    i=fc.getItem();
    
    Account cuenta = new Account();
    fc.setcuenta(cuenta);
    cuenta=fc.getcuenta();
    
    Product2 pro = new Product2();
    fc.setpro(pro);
    pro=fc.getpro();
    
    String a = fc.getVerDetalles(); 
    
    fc.getFacturar();

    boolean bln = fc.getVerDetallesDisabled();
    
    fc.CrearFacturas();
    
    fc.SelectAll();
    fc.QuitarSeleccion();
    
    fc.setMensaje(a);
    a=fc.getMensaje();
            
    Facturar_Controller.Opor op = new Facturar_Controller.Opor();
    op.oport=o;
    op.selected=true;        
    
    fc.listaOpp.add(op);
    
    List<Facturar_Controller.Opor> lop = new List<Facturar_Controller.Opor>();
    
    lop=fc.getlistaopp();
    fc.setlistaopp(lop);
    
    fc = new Facturar_Controller();
    
    c.Tipo_de_Cota_o__c='SOJA';
    c.Cotacao_de_soja__c='COAMO';
    fc.setContrato(c);
    fc.opp.safra__c='08/09';
    fc.pro.variedad__c='APOLO';
    
    Cotizacion_Soja__c cot_soja = new Cotizacion_Soja__c(Cotacao_de_soja__c='COAMO');
    insert cot_soja;
    fc.Buscar();

    fc.selectAll();
    String a1 = fc.getVerDetalles(); 

    fc.Fact_Param.Fecha_fijacion_T_de_cambio__c=System.today();    
    fc.Fact_Param.Amount=1;
    fc.Fact_Param.Sucursal__c='0095 - Londrina';
    fc.Fact_Param.Tipo_de_cambio__c = 2;
    
    fc.listaOpp.add(op);
    
    fc.CrearFacturas();
    
    Account cu = New Account();
    cu.Name = 'prueba';
    insert cu;
    
    Contact con = New Contact();
    con.AccountId = cu.Id;
    con.LastName = 'prueba';
    insert con;
    
    Regiao__c re = New Regiao__c();
    re.Name = 'prueba';
    insert re;
    
    Estado__c est = New Estado__c();
    est.Name = 'prueba';
    insert est;
    
    sapStatusPedido sapstatus = New sapStatusPedido();
    sapStatusPedido.Bapiret2 sapstatusBapiret2 = New sapStatusPedido.Bapiret2();
    
    sapSoapFunctionsAnulMcS.Bapiret2 anul = New sapSoapFunctionsAnulMcS.Bapiret2();
    sapSoapFunctionsMcS.Bapiret2 functionsMcs = New sapSoapFunctionsMcS.Bapiret2();
    
    
    }
    
           
}
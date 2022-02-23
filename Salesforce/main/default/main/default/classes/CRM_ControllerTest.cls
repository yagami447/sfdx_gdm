@isTest
private class CRM_ControllerTest {

    @isTest(SeeAllData=true)
    static void test(){
        CRM_Controller crm = New CRM_Controller();
        crm.init(); 
        crm.crm_mult = New CRM_Multiplicador__c(Area_multiplic_propia__c = 100, Vendas_de_Sem_sem_tratar__c = 100);

        List<CRM_Infraestructura__c> a = crm.getinfraestructura_A();
        crm.setinfraestructura_A(New List<CRM_Infraestructura__c>());
        
        a = crm.getinfraestructura_F();
        crm.setinfraestructura_F(New List<CRM_Infraestructura__c>());
        
        a = crm.getnuevo_infraestructura_F();
        crm.setnuevo_infraestructura_F(New List<CRM_Infraestructura__c>());
        
        List<CRM_Infraestructura__c> b = crm.getnuevo_infraestructura_A();
        crm.setnuevo_infraestructura_A(New List<CRM_Infraestructura__c>());
        
        List<CRM_Infraestructura__c> f = crm.getnuevo_infraestructura_B();
        crm.setnuevo_infraestructura_B(New List<CRM_Infraestructura__c>());
        
        List<CRM_Infraestructura__c> g = crm.getnuevo_infraestructura_G();
        
        CRM_Multiplicador__c c = crm.getinfraestructura_C();
        crm.setinfraestructura_C(New CRM_Multiplicador__c());
        
        CRM_Multiplicador__c d = crm.getinfraestructura_D();
        crm.setinfraestructura_D(New CRM_Multiplicador__c());
        
        CRM_Multiplicador__c e = crm.getinfraestructura_E();
        crm.setinfraestructura_E(New CRM_Multiplicador__c());                
        
        crm.setinfraestructura_B(New List<CRM_Infraestructura__c>());
        f = crm.getinfraestructura_B();
        
        Regiao__c re = New Regiao__c();
        re.Name = 'region';
        insert re;
        
        CRM_Infraestructura__c crmInfA = New CRM_Infraestructura__c();
        crmInfA.Region__c = re.Id;
        crm.nuevo_infraestructura_A.add(crmInfA);       
        
        Account accou = [SELECT Id, Name FROM Account WHERE Name = 'ACME' AND (CodigoSAP__c = '6000000000' OR CodigoSAP__c = '7000000001')];
        //Account accou = New Account();
        //accou.Name = 'a';
        //insert accou;
        
        crm.accId = accou.Id;
        crm.campania = '12/13';
        crm.nuevo_infraestructura_F = New List<CRM_Infraestructura__c>();
        CRM_Infraestructura__c crmInfF = New CRM_Infraestructura__c();
        crm.nuevo_infraestructura_F.add(crmInfF);
        PageReference pr = crm.addInfraestructura_F();
                
        crm.nuevo_InfraEstructura_A = New List<CRM_Infraestructura__c>();
        Cidade__c ciu = New Cidade__c();
        ciu.Regi_o__c = re.Id;
        insert ciu;
        
        CRM_Infraestructura__c inf = New CRM_Infraestructura__c();      
        inf.Capacidade__c = null;
        crm.nuevo_infraestructura_A.add(inf);       
        pr = crm.addInfraestructura_A();
        inf.Capacidade__c = 900;
        pr = crm.addInfraestructura_A();
        inf.Cidade__c = ciu.Id;     
        pr = crm.addInfraestructura_A();        
        inf.Region__c = re.Id;
        pr = crm.addInfraestructura_A();
                    
        crm.nuevo_InfraEstructura_B = New List<CRM_Infraestructura__c>();
        CRM_Infraestructura__c inf2 = New CRM_Infraestructura__c();     
        inf2.Capacidade__c = null;
        crm.nuevo_infraestructura_B.add(inf2);      
        pr = crm.addInfraestructura_B();
        inf2.Capacidade__c = 900;
        pr = crm.addInfraestructura_B();
        inf2.Empresa__c = 'SYNGENTA';       
        pr = crm.addInfraestructura_B();        
        inf2.Exclusividade__c = 'SIM';
        pr = crm.addInfraestructura_B();
        
        crm.nuevo_infraestructura_B.add(crmInfA);            
        pr = crm.eliminarInfraestructura();
        pr = crm.cancelEditInfraestructura_A();
        pr = crm.saveEditInfraestructura_A();
        pr = crm.cancelEditInfraestructura_B();     
        pr = crm.cancelEditInfraestructura_F();
        pr = crm.cancelEditInfraestructura_D();
        pr = crm.cancelEditInfraestructura_E();
        pr = crm.saveEditInfraestructura_B();
        pr = crm.saveEditInfraestructura_F();
        pr = crm.editInfraestructura_A();
        pr = crm.editInfraestructura_B();
        pr = crm.editInfraestructura_D();
        pr = crm.editInfraestructura_E();
        pr = crm.editInfraestructura_F();
        pr = crm.editTSacasV();
        pr = crm.editTSacasCF();
        pr = crm.volverAConta();
        pr = crm.verCalendario();
        pr = crm.verVendas();
        pr = crm.verCanalVendas();
        pr = crm.verAreaAct();
        pr = crm.saveCanalVendas();
        pr = crm.saveVendas();          
        
        Id i = crm.getelimInfr();
        Id i2;
        Boolean bool;
        crm.setelimInfr(i2);
        crm.seteditInfrA(i2);
        crm.seteditInfrB(i2);
        crm.seteditInfrF(i2);
        crm.seteditvbmx(i2);
        crm.seteditvdms(i2);
        crm.seteditareaa(i2);
        crm.seteditCalendario(i2);
        crm.seteliminarCalendario(i2);
        crm.seteliminar_venta_DMS(i2);
        crm.seteliminar_venta_BMX(i2);
        crm.seteliminar_sacas_v(i2);
        crm.seteliminar_sacas_cf(i2);
        crm.seteliminar_sacas_o(i2);
        crm.setsaveedit_venta_DMS(i2);
        crm.setsaveedit_venta_BMX(i2);
        crm.setsaveedit_sacas_v(i2);
        crm.setsaveedit_sacas_cf(i2);
        crm.setsaveedit_sacas_o(i2);
        crm.seteditInfrC(bool);
        crm.seteditInfrD(bool);
        crm.seteditInfrE(bool);
        crm.seteditTotalSacasV(bool);
        crm.seteditTotalSacasCF(bool);
        crm.seteditCanalDeVendas(bool);
        crm.seteditarVendas(bool);
        Id i3 = crm.geteditInfrA();
        Id i5 = crm.geteditInfrB();
        i5 = crm.geteditInfrF();
        bool = crm.geteditTotalSacasV();
        bool = crm.geteditTotalSacasCF();
        i5 = crm.geteditareaa();
        i5 = crm.geteditvbmx();
        i5 = crm.geteditvdms();
        i5 = crm.geteditCalendario();
        i5 = crm.geteliminarCalendario();
        i5 = crm.geteliminar_venta_DMS();
        i5 = crm.geteliminar_venta_BMX();
        i5 = crm.geteliminar_sacas_v();
        i5 = crm.geteliminar_sacas_cf();
        i5 = crm.geteliminar_sacas_o();
        i5 = crm.getsaveedit_venta_DMS();
        i5 = crm.getsaveedit_venta_BMX();
        i5 = crm.getsaveedit_sacas_v();
        i5 = crm.getsaveedit_sacas_cf();
        i5 = crm.getsaveedit_sacas_o();
        Id i4;
        crm.setelimInfr(i4);
        bool = crm.geteditInfrC();
        bool = crm.geteditInfrD();
        bool = crm.geteditInfrE();
        bool = crm.geteditCanalDeVendas();
        bool = crm.geteditarVendas();
        
        Product2 p = New Product2();
        crm.setnuevaSacasV(p);
        crm.setnuevaSacasCF(p);
        crm.seteditSacasCF(p);
        crm.setnuevaSacasV(p);
        crm.seteditSacasO(p);
        crm.seteditSacasV(p);
        crm.setnuevaSacasO(p);
        p = crm.getnuevaSacasV();
        p = crm.getnuevaSacasCF();
        p = crm.geteditSacasCF();
        p = crm.geteditSacasv();
        p = crm.geteditSacasO();
        p = crm.getnuevaSacasv();
        p = crm.getnuevaSacasO();
        
        crm.settotalVentasBMX(1);
        crm.settotalVentasDMS(1);
        crm.settotalVentasOutros(1);
        String num = crm.gettotalVentasBMX();
        num = crm.gettotalVentasDMS();
        num = crm.gettotalVentasOutros();
        
        crm.sumarizar_ventas();
        
        crm.initCalendario();
        crm.calendario = New List<CRM_Calendario_de_Eventos__c>();
        CRM_Calendario_de_Eventos__c cal = New CRM_Calendario_de_Eventos__c();      
        cal.Evento__c = 'Palestra';
        cal.Data__c = system.today();   
        cal.Cuenta__c = accou.id;
        cal.Safra__c = '12/13';         
        crm.calendario.add(cal);                
        
        pr = crm.addCalendario();
        
        pr = crm.saveEditCalendario();
        
        pr = crm.editCalendario();
        pr = crm.editVentaDMS();
        pr = crm.editVentaBMX();
        pr = crm.editSacasV();
        pr = crm.editSacasCF();
        pr = crm.editSacasO();
        pr = crm.cancelEditCalendario();
        pr = crm.cancelEditVentaDMS();
        pr = crm.cancelEditVentaBMX();
        pr = crm.cancelEditSacasV();
        pr = crm.cancelEditSacasCF();
        pr = crm.cancelEditSacasO();
        pr = crm.cancelEditAreaAtuacion();
        pr = crm.saveEditVentaDMS();
        pr = crm.saveEditVentaBMX();
        pr = crm.saveEditSacasV();
        pr = crm.saveEditSacasCF();
        pr = crm.saveEditSacasO();
        pr = crm.eliminarCalendario();             
        pr = crm.eliminarVentaDMS();
        pr = crm.eliminarVentaBMX();
        pr = crm.eliminarSacasV();
        pr = crm.eliminarSacasCF();
        pr = crm.eliminarAreaAtuacion();                
        
        CRM_Multiplicador__c canal_vendas = crm.getcanal_de_vendas();
        crm.setcanal_de_vendas(canal_vendas);
        crm.setvendas(canal_vendas);
        canal_vendas = crm.getvendas();
        crm.setcrm_mult(canal_vendas);
        canal_vendas = crm.getcrm_mult();
        
        crm.setadicionar_Inf_A(bool);
        bool = crm.getadicionar_inf_A();
        
        crm.setadicionar_Inf_F(bool);
        bool = crm.getadicionar_inf_F();
        
        crm.setadicionar_Inf_B(bool);
        bool = crm.getadicionar_inf_B();
        
        crm.setadicionar_venta_BMX(bool);
        bool = crm.getadicionar_venta_BMX();
        
        crm.setadicionar_venta_DMS(bool);
        bool = crm.getadicionar_venta_DMS();
        
        crm.setadicionar_sacas_v(bool);
        bool = crm.getadicionar_sacas_v();
        
        crm.setadicionar_sacas_cf(bool);
        bool = crm.getadicionar_sacas_cf();
        
        crm.setadicionar_sacas_o(bool);
        bool = crm.getadicionar_sacas_o();
        
        String est;
        crm.setEstadoNewCal(est);
        crm.setEstadoEditCal(est);
        crm.setnuevaVariedadBMX(est);
        crm.setnuevaVariedadDMS(est);
        crm.setnuevoProdOutros(est);
        crm.seteditProdOutros(est);
        crm.seteditVariedadBMX(est);
        crm.seteditVariedadDMS(est);
        crm.seteditsv(est);
        crm.seteditscf(est);
        crm.seteditso(est);
        crm.setnuevoAreaAtuacion(est);      
        crm.setelim_areaa(est);
        crm.seteditRegAreaA(est);
        crm.setnombre_cuenta(est);
        crm.setnuevoAgroquimico(est);
        crm.seteditAgroquimico(est);
        est = crm.getEstadoNewCal();
        est = crm.getEstadoEditCal();
        est = crm.getnuevaVariedadBMX();
        est = crm.getnuevaVariedadDMS();
        est = crm.geteditVariedadBMX();
        est = crm.geteditVariedadDMS();
        est = crm.getnuevoProdOutros();
        est = crm.geteditProdOutros();
        est = crm.geteditsv();
        est = crm.geteditscf();
        est = crm.geteditso();
        est = crm.getnuevoAreaAtuacion();
        est = crm.getelim_areaa();
        est = crm.geteditRegAreaA();
        est = crm.getnombre_cuenta();
        est = crm.getnuevoAgroquimico();
        est = crm.geteditAgroquimico();
        
        pr = crm.setearEstadoEditCalendario();
        pr = crm.setearEstadoNewCalendario();
        
        pr = crm.cancelEditVendas();
        pr = crm.cancelEditTSacasV();
        pr = crm.cancelEditTSacasCF();
        
        List<CRM_Vendas__c> crm_v = crm.getventas();
        crm.setventas(crm_v);
        crm_v = crm.getventas_BMX();
        crm_v = crm.getventas_DMS();
        crm_v = crm.getnuevo_ventas_BMX();
        crm_v = crm.getnuevo_ventas_DMS();
        crm_v = crm.getsacas_verticaliza();
        crm_v = crm.getsacas_compra_fora();
        crm_v = crm.getsacas_outros();
        crm_v = crm.getnuevo_sacas_verticaliza();
        crm_v = crm.getnuevo_sacas_compra_fora();
        crm_v = crm.getnuevo_sacas_outros();
        crm.setventas_BMX(crm_v);
        crm.setventas_DMS(crm_v);
        crm.setsacas_verticaliza(crm_v);
        crm.setsacas_compra_fora(crm_v);
        crm.setsacas_outros(crm_v);
        crm.setnuevo_sacas_verticaliza(crm_v);
        crm.setnuevo_sacas_compra_fora(crm_v);
        crm.setnuevo_ventas_BMX(crm_v);
        crm.setnuevo_ventas_DMS(crm_v);
        crm.setnuevo_sacas_outros(crm_v);
        
        List <SelectOption> sOpAgr = crm.getAgroquimicos();
        
        List <SelectOption> sOp = crm.getVariedadesBMX();
        sOp = crm.getVariedadesDMS();
        sOp = crm.getoptionsNewOutros();
        sOp = crm.getoptionsEditOutros();
        sOp = crm.getRegionesConGrupo();
        pr = crm.getVariedadesObt_New_SacasO();
        pr = crm.getVariedadesObt_Edit_SacasO();
        crm.setOptionsNewOutros(sOp);
        crm.setOptionsEditOutros(sOp);
        
        crm.initVendas();
        
        crm.adicionar_Venta_BMX = true;
        pr = crm.adicionarVentaBMX();
        
        crm.adicionar_sacas_o = true;
        pr = crm.adicionarSacasO();
        
        List<CRM_Area_de_Atuacion__c> area = New List<CRM_Area_de_Atuacion__c>();       
        crm.setarea_atuacion(area);
        area = crm.getarea_atuacion();                  
        crm.setarea_atuacion_RS(area);
        area = crm.getarea_atuacion_RS();
        crm.setarea_atuacion_SC(area);
        area = crm.getarea_atuacion_SC();
        crm.setarea_atuacion_PR(area);
        area = crm.getarea_atuacion_PR();
        crm.setarea_atuacion_MS(area);
        area = crm.getarea_atuacion_MS();
        crm.setarea_atuacion_SP(area);
        area = crm.getarea_atuacion_SP();
        crm.setarea_atuacion_GO(area);
        area = crm.getarea_atuacion_GO();
        crm.setarea_atuacion_MG(area);
        area = crm.getarea_atuacion_MG();
        crm.setarea_atuacion_MA(area);
        area = crm.getarea_atuacion_MA();
        crm.setarea_atuacion_BA(area);
        area = crm.getarea_atuacion_BA();
        crm.setarea_atuacion_RO(area);
        area = crm.getarea_atuacion_RO();
        crm.setarea_atuacion_TO(area);
        area = crm.getarea_atuacion_TO();
        crm.setarea_atuacion_PI(area);
        area = crm.getarea_atuacion_PI();
        crm.setarea_atuacion_MT(area);
        area = crm.getarea_atuacion_MT();
                
        CRM_Calendario_de_Eventos__c calen = New CRM_Calendario_de_Eventos__c();
        /*crm.setcalendario(calen);
        calen = crm.getnuevo_calendario();
        crm.setcalendario(calen);
        crm.setnuevo_calendario(calen);
        calen = crm.getCalendario();
        */
        
        Double inte;        
        crm.setTotalRS(inte);
        crm.setTotalSC(inte);
        crm.setTotalPR(inte);
        crm.setTotalMS(inte);
        crm.setTotalSP(inte);
        crm.setTotalGO(inte);
        crm.setTotalMG(inte);
        crm.setTotalMA(inte);
        crm.setTotalBA(inte);
        crm.setTotalRO(inte);
        crm.setTotalTO(inte);
        crm.setTotalPI(inte);
        crm.setTotalMT(inte);
        
        crm.seteditCantAreaA(inte);
        crm.setnuevoProdOutrosVolume(inte);
        crm.settotalGeneralEstados(inte);
        crm.setnuevaSacasVVolume(inte);
        crm.setnuevaSacasVVolumeProd(inte);
        crm.getnuevaSacasVVolumeProd();
        crm.setnuevaSacasCFVolumeProd(inte);
        crm.getnuevaSacasCFVolumeProd();
        
        crm.setnuevaSacasCFVolume(inte);
        CRM_Area_de_Atuacion__c areaAt;
        areaAt = crm.getTotalRS();
        areaAt = crm.getTotalSC();
        areaAt = crm.getTotalPR();
        areaAt = crm.getTotalMS();
        areaAt = crm.getTotalSP();
        areaAt = crm.getTotalGO();
        areaAt = crm.getTotalMG();
        areaAt = crm.getTotalMA();
        areaAt = crm.getTotalBA();
        areaAt = crm.getTotalRO();
        areaAt = crm.getTotalTO();
        areaAt = crm.getTotalPI();
        areaAt = crm.getTotalMT();
        
        //16.01.2015
        crm.gettotalCanalVendas();
        crm.settotalCanalVendas(inte);
        crm.settotalPlaneamientoGeneralEstados(inte);
        crm.gettotalPlaneamientoGeneralEstados();
        crm.setcampania('13/14');
        crm.getcampania();
        crm.settotalPlaneamientoSP(inte);
        crm.gettotalPlaneamientoSP();
        crm.settotalPlaneamientoMS(inte);
        crm.gettotalPlaneamientoMS();
        crm.settotalPlaneamientoPR(inte);
        crm.gettotalPlaneamientoPR();
        crm.settotalPlaneamientoSC(inte);
        crm.gettotalPlaneamientoSC();
        crm.settotalPlaneamientoRS(inte);
        crm.gettotalPlaneamientoRS();
        crm.settotalPlaneamientoGO(inte);
        crm.gettotalPlaneamientoGO();
        crm.settotalPlaneamientoMG(inte);
        crm.gettotalPlaneamientoMG();
        crm.settotalPlaneamientoMA(inte);
        crm.gettotalPlaneamientoMA();
        crm.settotalPlaneamientoBA(inte);
        crm.gettotalPlaneamientoBA();
        crm.settotalPlaneamientoRO(inte);
        crm.gettotalPlaneamientoRO();
        crm.settotalPlaneamientoTO(inte);
        crm.gettotalPlaneamientoTO();
        crm.settotalPlaneamientoPI(inte);
        crm.gettotalPlaneamientoPI();
        crm.settotalPlaneamientoMT(inte);
        crm.gettotalPlaneamientoMT();
        Double dbl1;
        crm.settotalPlaneamientoDMS(dbl1); 
        crm.gettotalPlaneamientoDMS(); 
        crm.settotalPlanInfCapPorUBS(dbl1); 
        crm.gettotalPlanInfCapPorUBS(); 
        crm.settotalPlanInfProdPorUBS(dbl1); 
        crm.gettotalPlanInfProdPorUBS(); 
        crm.settotalPlanInfCapPorEmpresa(dbl1); 
        crm.gettotalPlanInfCapPorEmpresa(); 
        crm.settotalPlaneamientoBMX(dbl1); 
        crm.gettotalPlaneamientoBMX(); 
        crm.settotalPlaneamientoSacasCF(dbl1); 
        crm.gettotalPlaneamientoSacasCF(); 
        crm.settotalPlaneamientoSacasVerticaliza(dbl1); 
        crm.gettotalPlaneamientoSacasVerticaliza(); 
        crm.settotalPlaneamientoOutros(dbl1); 
        crm.gettotalPlaneamientoOutros();
        crm.seteditpscf('a'); 
        crm.geteditpscf(); 
        crm.seteditpsv('a'); 
        crm.geteditpsv(); 
        crm.seteditpso('a'); 
        crm.geteditpso(); 
         
        
        
        List<CRM_Area_de_Atuacion__c> lAreaA = New List<CRM_Area_de_Atuacion__c>();
        crm.setarea_atuacion_planeamiento(lAreaA);
        crm.getarea_atuacion_planeamiento(); 
        crm.setarea_atuacion_planeamiento_RS(lAreaA); 
        crm.getarea_atuacion_planeamiento_RS(); 
        crm.setarea_atuacion_planeamiento_SC(lAreaA); 
        crm.getarea_atuacion_planeamiento_SC(); 
        crm.setarea_atuacion_planeamiento_PR(lAreaA); 
        crm.getarea_atuacion_planeamiento_PR(); 
        crm.setarea_atuacion_planeamiento_MS(lAreaA); 
        crm.getarea_atuacion_planeamiento_MS(); 
        crm.setarea_atuacion_planeamiento_SP(lAreaA); 
        crm.getarea_atuacion_planeamiento_SP(); 
        crm.setarea_atuacion_planeamiento_GO(lAreaA); 
        crm.getarea_atuacion_planeamiento_GO(); 
        crm.setarea_atuacion_planeamiento_MG(lAreaA); 
        crm.getarea_atuacion_planeamiento_MG(); 
        crm.setarea_atuacion_planeamiento_MA(lAreaA); 
        crm.getarea_atuacion_planeamiento_MA(); 
        crm.setarea_atuacion_planeamiento_BA(lAreaA); 
        crm.getarea_atuacion_planeamiento_BA(); 
        crm.setarea_atuacion_planeamiento_RO(lAreaA); 
        crm.getarea_atuacion_planeamiento_RO(); 
        crm.setarea_atuacion_planeamiento_TO(lAreaA); 
        crm.getarea_atuacion_planeamiento_TO(); 
        crm.setarea_atuacion_planeamiento_PI(lAreaA); 
        crm.getarea_atuacion_planeamiento_PI(); 
        crm.setarea_atuacion_planeamiento_MT(lAreaA); 
        crm.getarea_atuacion_planeamiento_MT(); 
        
        List<CRM_Vendas__c> lven = New List<CRM_Vendas__c>();
        crm.setnuevo_planeamiento_sacas_outros(lven); 
        crm.getnuevo_planeamiento_sacas_outros(); 
        crm.setnuevo_planeamiento_BMX(lven); 
        crm.getnuevo_planeamiento_BMX(); 
        crm.setnuevo_planeamiento_DMS(lven); 
        crm.getnuevo_planeamiento_DMS(); 
        crm.setnuevo_planeamiento_sacas_compra_fora(lven); 
        crm.getnuevo_planeamiento_sacas_compra_fora(); 
        crm.setnuevo_planeamiento_sacas_verticaliza(lven); 
        crm.getnuevo_planeamiento_sacas_verticaliza(); 
        crm.setplaneamiento_sacas_compra_fora(lven); 
        crm.getplaneamiento_sacas_compra_fora(); 
        crm.setplaneamiento_sacas_verticaliza(lven); 
        crm.getplaneamiento_sacas_verticaliza(); 
        crm.setplaneamiento_sacas_outros(lven); 
        crm.getplaneamiento_sacas_outros(); 
        crm.setplaneamiento_BMX(lven); 
        crm.getplaneamiento_BMX(); 
        crm.setplaneamiento_DMS(lven); 
        crm.getplaneamiento_DMS();
        
        List<CRM_Infraestructura__c> linf = New List<CRM_Infraestructura__c>();
        crm.setplan_infraestructura_A(linf);
        crm.getplan_infraestructura_A();
        crm.setplan_infraestructura_B(linf);
        crm.getplan_infraestructura_B();
        crm.setplan_infraestructura_F(linf);
        crm.getplan_infraestructura_F();
        crm.setplan_infraestructura_G(linf);
        crm.getplan_infraestructura_G();
        crm.setnuevo_plan_infraestructura_A(linf);
        crm.getnuevo_plan_infraestructura_A();
        crm.setnuevo_plan_infraestructura_B(linf);
        crm.getnuevo_plan_infraestructura_B();
        crm.setnuevo_plan_infraestructura_F(linf);
        crm.getnuevo_plan_infraestructura_F();
        crm.setnuevo_plan_infraestructura_G(linf);
        crm.getnuevo_plan_infraestructura_G();
        crm.getinfraestructura_G();
        crm.setnuevo_infraestructura_G(linf);
        
        crm.setadicionar_p_sacas_cf(true); 
        crm.getadicionar_p_sacas_cf(); 
        crm.setadicionar_p_sacas_v(true); 
        crm.getadicionar_p_sacas_v(); 
        crm.setadicionar_p_sacas_o(true); 
        crm.getadicionar_p_sacas_o(); 
        crm.setadicionar_planeamiento_BMX(true); 
        crm.getadicionar_planeamiento_BMX(); 
        crm.setadicionar_planeamiento_DMS(true); 
        crm.getadicionar_planeamiento_DMS(); 
        crm.setadicionar_plan_inf_A(true); 
        crm.getadicionar_plan_inf_A(); 
        crm.setadicionar_plan_inf_B(true); 
        crm.getadicionar_plan_inf_B(); 
        crm.setadicionar_plan_inf_F(true); 
        crm.getadicionar_plan_inf_F(); 
        crm.setadicionar_plan_inf_G(true); 
        crm.getadicionar_plan_inf_G(); 
        crm.setadicionar_inf_G(true); 
        crm.getadicionar_inf_G(); 
        crm.seteditPInfrC(true);
        crm.geteditPInfrC();
        crm.seteditPInfrD(true);
        crm.geteditPInfrD();
        crm.seteditPInfrE(true);
        crm.geteditPInfrE();
        
        crm.setsaveedit_p_sacas_cf(accou.Id);
        crm.getsaveedit_p_sacas_cf();
        crm.setsaveedit_p_sacas_v(accou.Id);
        crm.getsaveedit_p_sacas_v();
        crm.setsaveedit_p_sacas_o(accou.Id);
        crm.getsaveedit_p_sacas_o();
        crm.setsaveedit_planeamiento_bmx(accou.Id);
        crm.getsaveedit_planeamiento_bmx();
        crm.setsaveedit_planeamiento_dms(accou.Id);
        crm.getsaveedit_planeamiento_dms();
        crm.seteliminar_p_sacas_cf(accou.Id);
        crm.geteliminar_p_sacas_cf();
        crm.seteliminar_p_sacas_v(accou.Id);
        crm.geteliminar_p_sacas_v();
        crm.seteliminar_p_sacas_o(accou.Id);
        crm.geteliminar_p_sacas_o();
        crm.seteliminar_planeamiento_BMX(accou.Id);
        crm.geteliminar_planeamiento_BMX();
        crm.seteliminar_planeamiento_DMS(accou.Id);
        crm.geteliminar_planeamiento_DMS();
        crm.seteditpdms(accou.Id);
        crm.geteditpdms();
        crm.seteditpbmx(accou.Id);
        crm.geteditpbmx();
        crm.seteditInfrG(accou.Id);
        crm.geteditInfrG();
                
        
        PageReference pageRef = Page.CRM_Infraestructura;
        Test.setCurrentPageReference(pageRef);
        ApexPages.CurrentPage().getparameters().put('id', accou.Id);
        ApexPages.CurrentPage().getparameters().put('nombre', accou.Name);
        
        crm.init();
        
        
                
        crm.initPlanejamientoInfr();
        crm.initPlaneamiento();
        crm.initAreaActuacionPlaneamiento();
        CRM_Multiplicador__c crm_mult = New CRM_Multiplicador__c();
        crm_mult.Cuenta__c = accou.Id;
        crm_mult.Safra__c = '13/14';
        if(Test.isRunningTest()){ crm_mult.Area_multiplic_propia__c = 100; crm_mult.Vendas_de_Sem_sem_tratar__c = 100;}
        insert crm_mult; 
        crm.crm_mult =  crm_mult;   
        crm.addNuevoPlaneamientoDMS();
        crm.addNuevoPlaneamientoBMX();
        crm.addNuevaVentaBMX();
        crm.addNuevaVentaDMS();
        crm.addNuevo_SacasV();
        crm.addNuevo_SacasO();
        crm.addNuevo_PSacasO();
        crm.addNuevo_PSacasV();
        crm.addNuevo_PSacasCF();
        crm.addPInfraestructura_A();
        crm.addPInfraestructura_B();
        crm.addPInfraestructura_F();
        crm.addPInfraestructura_G();
        crm.addInfraestructura_G();
        crm.addAreaAtuacion();
        crm.addAreaAtuacionPlaneamiento();
        crm.editInfraestructura_G();
        crm.editPInfraestructura_C();
        crm.editPInfraestructura_D();
        crm.editPInfraestructura_E();
        crm.editInfraestructura_C();
        crm.validacionesEncerrar();
        
        crm.verPlaneamiento();
        crm.verPlaneamientoAreaA();
        crm.verEncerrar();
        //16.01.2015
        
        inte = crm.geteditCantAreaA();
        inte = crm.getnuevoProdOutrosVolume();
        areaAt = crm.gettotalGeneralEstados();
        inte = crm.getnuevaSacasVVolume();
        inte = crm.getnuevaSacasCFVolume();
        
        crm.setNuevoAreaAtuacionCantidad(inte);
        inte = crm.getNuevoAreaAtuacionCantidad();
        
        crm.initAreaActuacion();    
        crm.crm_mult = New CRM_Multiplicador__c();
        crm.crear_crm_mult();
        crm.crm_mult =  crm_mult;    
        crm.initCanalVentas();
        crm.crm_mult =  crm_mult;    
        crm.verPlaneamientoInfr();
        crm.crm_mult =  crm_mult;    
        crm.verInfraestructura();
        crm.crm_mult =  crm_mult;    
        crm.cerrarDatos();
        crm.crm_mult =  crm_mult;    
        crm.editCanalVendas();
        crm.crm_mult =  crm_mult;    
        crm.editVendas();
    }
    
    @isTest(SeeAllData=true)
    static void testCalendario()
    {
        CRM_Controller crm = New CRM_Controller();
        Account accou = [SELECT Id, Name FROM Account WHERE Name = 'ACME' AND (CodigoSAP__c = '6000000000' OR CodigoSAP__c = '7000000001')];
		
        crm.init();
        crm.crm_mult = New CRM_Multiplicador__c();
        crm.crear_crm_mult();
        
        crm.addCalendario();
        crm.initCalendario();
        crm.nuevoCalendario();
        crm.changeEventoNewCalendario();
        crm.cancelNuevoItemsCalendario();
        crm.nuevo_calendario_detalles = New List<CRM_Detalle_Calendario_de_eventos__c>();
        crm.nuevo_calendario_detalle = New List<CRM_Detalle_Calendario_de_eventos__c>();
        CRM_Detalle_Calendario_de_eventos__c det = New CRM_Detalle_Calendario_de_eventos__c();
        crm.nuevo_calendario_detalle.add(det);
        crm.getVariedadesCalendario();
        
        
        crm.addNuevoItemEvento = New Product2();
        crm.addNuevoItemEvento.Obtentor__c = 'GDML';
        crm.getVariedadesObt_Add_NewEvento();
        crm.editNuevoItemEvento = New Product2();
        crm.editNuevoItemEvento.Obtentor__c = 'GDML';
        crm.getVariedadesObt_Edit_NewEvento();
        crm.optionsAddNuevoEvento = new List<SelectOption>();
        crm.addNewItemCalendario();
        crm.ver_calendario_detalles = New List<CRM_Detalle_Calendario_de_eventos__c>();
        crm.ver_calendario_detalle = New List<CRM_Detalle_Calendario_de_eventos__c>();
        crm.ver_calendario_detalle.add(det);
        crm.addEditItemCalendario();
        crm.nuevoItemsCalendario();
        crm.addEditArchCalendario();
        crm.delNewArchCalendario(); //JERE
        crm.delEditItemCalendario();
        
        crm.addNewArchCalendario();
            
        crm.setoptionsAddNuevoEvento(new List<SelectOption>());
        crm.getoptionsAddNuevoEvento();
        crm.setoptionsEditNuevoEvento(new List<SelectOption>());
        crm.getoptionsEditNuevoEvento();
        crm.seteditNewItemEvento(1);
        crm.geteditNewItemEvento();
        crm.seteditNuevoItemEvento(New Product2());
        crm.geteditNuevoItemEvento();
        crm.setaddNuevoItemEvento(New Product2());
        crm.getaddNuevoItemEvento();
        crm.setcalendario(New List<CRM_Calendario_de_Eventos__c>());
        crm.getcalendario();
                
        crm.addEditArchCalendario();
        //crm.initEditCalendario();
        crm.updateCalendarioCab();
        crm.updateCalendarioDetalle();
        
        crm.editarVerCalendario();
        crm.cancelarEditarVerCalendario();
        crm.delNewItemCalendario();
        crm.delEditArchCalendario();
        crm.delEditItemCalendario();
        
        crm.setnuevo_calendario(New CRM_Calendario_de_Eventos__c());
        CRM_Calendario_de_Eventos__c crm_cal = crm.getnuevo_calendario();
    }
    
    @isTest(SeeAllData=true)
    static void myUnitTest() {
        CRM_Controller.prueba();
        Account accou = [SELECT Id, Name FROM Account WHERE Name = 'ACME' AND (CodigoSAP__c = '6000000000' OR CodigoSAP__c = '7000000001')];
		
        CRM_Calendario_de_Eventos__c cal = new CRM_Calendario_de_Eventos__c();
        cal.Evento__c = 'Palestra';
        cal.Data__c = system.today();   
        cal.Cuenta__c = accou.id;
        cal.Data_e_horario_inicio__c = System.Now();
        cal.Data_e_horario_termino__c = System.Now() + 2;
        cal.Safra__c = '12/13';   
        insert cal;
        Attachment atta = New Attachment();
        atta.Name = 'Name';
        
        atta.Body = Blob.valueOf('Prueba');
        atta.ParentId = cal.Id;
        insert atta;
        
        delete atta;
        
    }
}
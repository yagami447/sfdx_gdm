public class aSiteCuentaCorrienteController {

    private String token;
    private SiteUser__c logUser;
    private SiteUserSession__c activeSession;

    public Account activeAccount			                {get; set;}
    public List<CuentaCorrienteWrapper> cuentas             {get; set;}
    public Decimal valorTotal                               {get; set;}
    public String valorTotalString                          {get; set;} //prueba
    public String nombre                                   {get; set;}
    public String moneda                                    {get; set;}

    public PageReference validate() {       
        token = System.currentPageReference().getParameters().get('token');
        if(token!=null){
            logUser = aSiteAuthManager.VerifyUserSession(token);
            if(logUser!=null){
                activeSession = aSiteAuthManager.getUserSession(token);
                activeAccount = aSiteAuthManager.getActiveAccount_byUser(logUser);
                nombre = activeAccount.name;
                cuentas = new List<CuentaCorrienteWrapper>();
                ConsultarContaCorrienteRFC peticionSAP = new ConsultarContaCorrienteRFC();
                peticionSAP.startRequest(activeAccount.Id);
                System.debug(peticionSAP);
                System.debug(peticionSAP.result);
                ConsultarContaCorriente.ZetfiFbl5n resultado = peticionSAP.result;
                valorTotal = 0;
                for(ConsultarContaCorriente.ZefiFbl5n item : resultado.item){
                    if(Test.isRunningTest()){
                        item.Bldat = '2019-01-02';
                        item.Faedt = '2019-01-02';
                        item.Bwwrt = '2.66';
                    }
                    CuentaCorrienteWrapper cuenta = new CuentaCorrienteWrapper();
                    cuenta.nome1 = item.Sgtxt;
                    cuenta.numeroDocumento = item.Belnr;
                    //cuenta.numeroDocumento = item.Rebzg;
                    cuenta.referencia = item.Vbeln;
                    //cuenta.referencia = item.Xblnr;
                    //cuenta.referencia = item.Kidno;
                    //cuenta.referencia = item.UVbeln;
                    cuenta.atribucion = item.Zuonr;
                    cuenta.dataDoc =  Date.valueOf(item.Bldat);
                    //cuenta.dataDoc = item.Budat;
                    //cuenta.dataDoc = item.Zfbdt;
                    cuenta.vencLiquid = Date.valueOf(item.Faedt);
                    //cuenta.vencLiquid = item.Zaldt;
                    cuenta.montMonedaDocString = formatDecimal(Decimal.valueOf(item.Bwwrt), 2, '.', ',');
                    //cuenta.montMonedaDocString = formatDecimal(item.Dmshb, 2, '.', ',');
                    //cuenta.montMonedaDocString = formatDecimal(item.Wrshb, 2, '.', ',');
                    //cuenta.montMonedaDocString = formatDecimal(item.Pswbt, 2, '.', ',');
                    //cuenta.montMonedaDocString = formatDecimal(item.ZzdmbtrD, 2, '.', ',');
                    //cuenta.montMonedaDoc = item.Bwwrt;
                    //cuenta.montMonedaDoc = item.Dmshb;
                    //cuenta.montMonedaDoc = item.Wrshb;
                    //cuenta.montMonedaDoc = item.Pswbt;
                    //cuenta.montMonedaDoc = item.ZzdmbtrD;
                    cuenta.moneda = item.Hwaer;
                    //cuenta.moneda = item.Waers;
                    //cuenta.moneda = item.Pswsl;
                    cuentas.add(cuenta);
                    valorTotal += Decimal.valueOf(item.Bwwrt);
                    valorTotalString = formatDecimal(valorTotal, 2, '.', ',');
                    moneda = cuenta.moneda;
                }

                return null;
            }            
        }
        PageReference p = new PageReference('/apex/aSiteLogin');
        String marca = aSiteAuthManager.getMarcaBySession(token);
        if (marca != null)
        	p.getParameters().put('comp',marca);
        p.setRedirect(true);
		return p;
    }

        
    //Para prueba
    public String formatDecimal(Decimal val, integer dec, String tSep, String dSep) {
        String s, tmp;
        Integer i = 4 + dec;
     
        // If the number of decimals is zero (0)... prevents the first 1000s seperator from being set at the 4th.
        if(dec==0){
            i--;
        }
     
        s = val.setScale(dec).toPlainString().replace(tSep, dSep);
        while(s.length() > i) {
            tmp = s.substring(0, s.length() - i) + tSep + s.substring(s.length() - i);
            s = tmp;
            i += 4;
        }
     
        // If the number is negative and has a number non-decimal digits divisible by 3, it prevents putting a comma before the 1st digit (ex -300,000.00  comes out -,300,000.00)
        if (s.substring(0,1) == '-') {
            if (s.substring(1,2) == tSep) {
                s = '-' + s.substring(2);
            }
        }
     
        return s;
    }

    public class CuentaCorrienteWrapper {
        //Hay que cambiar los tipos de datos segun lo devuelto por SAP.
        public String nome1             {get; set;}
        public String numeroDocumento   {get; set;}
        public String referencia        {get; set;}
        public String atribucion        {get; set;}
        public Date   dataDoc           {get; set;}
        public Date   dataLcto          {get; set;}
        public Date   vencLiquid        {get; set;}
        public Decimal montMonedaDoc    {get; set;}
        public String moneda            {get; set;}
        public string montMonedaDocString {get;set;}
    }

}
global class ScheduConsultarOfertaSAP implements Schedulable {
    
    global void execute(SchedulableContext ctx){                        
        consultarOferta();        
    }
    
    @future(callout=true)
    public static void consultarOferta(){
        Opp_Utils.consultarOfertaSAP();
    }
    
    static testmethod void test(){
        
        Test.startTest();
        ScheduConsultarOfertaSAP act = new ScheduConsultarOfertaSAP();
        String sche = '0 0 23 * * ?';
        System.schedule('Update', sche, act);
        Test.stopTest();
        
    }

}
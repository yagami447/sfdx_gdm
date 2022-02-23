global class SchedulableSapFlujoDoc_caller implements Schedulable {
	global void execute(SchedulableContext sc) {
		consultarFlujoDoc();
	}
	
	public static void consultarFlujoDoc(){
			try{
				String result = sapFlujoDoc_caller.consultarFlujoDoc();
			}catch(Exception e){
				system.debug(e.getMessage());
			}
	}
}
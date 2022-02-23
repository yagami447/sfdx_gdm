global class Bloquear_LiberarController{
	@AuraEnabled
	public static Boolean liberar_bloquear(String recordId){

		Boolean isLocked = Approval.isLocked(recordId);
		if (isLocked){
			Approval.unlock(recordId);
			return true;
		} else{
			Approval.lock(recordId);
			return false;
		}
	}

    webService static Boolean liberar_bloquear_Classic(String recordId){

		Boolean isLocked = Approval.isLocked(recordId);
		if (isLocked){
			Approval.unlock(recordId);
			return true;
		} else{
			Approval.lock(recordId);
			return false;
		}
	}
}
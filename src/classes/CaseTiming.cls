global class CaseTiming {
    public static Case caseTimer {get;set;}
    @RemoteAction
    global static String createCaseTiming(String caseId) {
       Case caseRec = [select status from case where id =:caseId];
       if(caseRec.status.equalsIgnoreCase('Working')){
           //dfgdf
               //caseTimer = new Case(id = caseId);
           //caseTimer.description = String.valueOf(system.now());
           //upsert caseTimer;
           //Added a new comment
           String newChange;
           return caseId;
       }else{
           return null;
       }
       
    }
}

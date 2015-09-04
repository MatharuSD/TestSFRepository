global class CaseTiming {
    public static Case caseTimer {get;set;}
    @RemoteAction
    global static String createCaseTiming(String caseId) {
       Case caseRec = [select status from case where id =:caseId];
       if(caseRec.status.equalsIgnoreCase('Working')){
       	String newStr='samreet';
           return caseId;
       }else{
           return null;
       }
       
    }
}
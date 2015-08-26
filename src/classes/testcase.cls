public class testcase{
    public Case caset{get;set;}
    public String selectedRecType{get;set;}
    public String recordTypeId{get;set;}
    public List<SelectOption> recType {get;set;}
    public testcase(ApexPages.StandardController std){
    
       caset= (Case)std.getRecord();
       recType  = new List<SelectOption>();
       rectype.add(new SelectOption('01290000001A7yW','01290000001A7yW'));
       rectype.add(new SelectOption('01290000001A7yb','01290000001A7yb'));
    }
    
    
    public void fetchRecordTypeName(){
        caset.RecordTypeId = recordTypeId;
        system.debug('-----recordTypeId'+recordTypeId);
    }
}
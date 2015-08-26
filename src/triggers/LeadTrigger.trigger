trigger LeadTrigger on Lead (before insert,after insert) {
	List<PartnerNetworkConnection> pslNtwkConnections = new List<PartnerNetworkConnection>();
	pslNtwkConnections = [select id from PartnerNetworkConnection where ConnectionName='Psl' ];
	if(pslNtwkConnections != null && pslNtwkConnections.size()>0){
		for(Lead lead : trigger.new){
			//Check if the lead is generated from web and sent from psl org
			if(lead.LeadSource.equalsIgnoreCase('Web')&& lead.connectionReceivedId  == pslNtwkConnections[0].id){
				//Get the related dealer code and find the corrosponding account record
				List<Account> account = new List<Account>();
				account = [select id from Account where Dealer_Code__c = :lead.Dealer_Code__c];
				if(trigger.isBefore){
					lead.Dealer__c = account[0].id;
				}
				// Get the related VIN number and find the inventory
				List<Inventory__c> inventoryList = new List<Inventory__c>();
				inventoryList = [select id from Inventory__c where VIN__c=:lead.VIN__c];
				//convert the lead
				if(trigger.isAfter){
					Database.LeadConvert lc = new Database.LeadConvert();
		            lc.setLeadId(lead.id);
		            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		            lc.setConvertedStatus(convertStatus.MasterLabel);
		            Database.LeadConvertResult lcr;
		            lcr= Database.convertLead(lc);
		            String oppId = lcr.getOpportunityId();
		            Test_Drive__c testDrive = new Test_Drive__c();
		            testDrive.Inventory__c = inventoryList[0].id; 
		            testDrive.Drive_Date__c = lead.Test_Drive_Date__c;
		            testDrive.Drive_time__c = lead.Test_Drive_Time__c;
		            testDrive.Opportunity__c = oppId;
		            insert testDrive;		
				}		
			}
		}
	}
}
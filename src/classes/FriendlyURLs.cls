global class FriendlyURLs  implements Site.UrlRewriter {
	
	String CMSFORCE_PAGE = '/cms/';
	String CMSFORCE_VISUALFORCE_PAGE = '/page?pageid=';
	
	global PageReference mapRequestUrl(PageReference friendlyUrl) {
		String url = friendlyUrl.getUrl();	
		if(url.startsWith(CMSFORCE_PAGE)) {
			try {
				String friendly = url.substring(CMSFORCE_PAGE.length(), url.length());
				
				//Select the ID of the (first) page that matches
				//the name from the URL
				Page__c p = [select Id, Name from Page__c where FriendlyUrl__c = :friendly LIMIT 1];
				
				return new PageReference(CMSFORCE_VISUALFORCE_PAGE + p.id);
			}
			catch(Exception ex) {
				return null;
			}
		}
		return null;
	}
	
	//not implemented at this time
	global PageReference[] generateUrlFor(PageReference[] yourSalesforceUrls) {return null;}
	
	
	//TEST METHODS
	private static testMethod void t1() {
		Site site = [select Id from Site limit 1];
		String siteid = site.Id;		
		//set up page and template folders
		CMSFolder__c pagefolder = new CMSFolder__c(Site_Id__c = siteid.substring(0,15),Type__c = 'Page', Name='test');
		insert pagefolder;
		CMSFolder__c templatefolder = new CMSFolder__c(Type__c = 'PageTemplate', Name='test');
		insert templatefolder;
		PageTemplate__c pt = new PageTemplate__c(Name = 'TestTemplatexyz', VisualForce_Page_Name__c = 'TestTemplate', ContentBlockNames__c = 'a,b,c', Folder__c = templatefolder.Id);
		insert pt;
		
		Page__c p = new Page__c(Name = 'testpagexyz', FriendlyUrl__c='testpagexyz', PageTemplate__c = pt.Id, Folder__c = pagefolder.Id);
		insert p;
		
		FriendlyURLs fu = new FriendlyURLs();
		PageReference pr = new Pagereference('/cms/testpagexyz');
		PageReference origurl = fu.mapRequestUrl(pr);
		//System.debug(origurl.getUrl());
		System.assertEquals('/page?pageid='+p.Id, origurl.getUrl());
		
		PageReference pr2 = new Pagereference('thiswontbefoundxyz');
		PageReference origurl2 = fu.mapRequestUrl(pr2);
		System.assertEquals(null, origurl2);
	}
}
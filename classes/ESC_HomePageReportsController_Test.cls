@isTest
private class ESC_HomePageReportsController_Test {

		@IsTest(SeeAllData=false) static  void test() {
		     ESC_HomePageReports__c ehpr = new ESC_HomePageReports__c();
		     ehpr.ESC_CacheAge__c =300;
		     ehpr.ESC_ReportIDS__c= '00O0v000000FW1J';
		     insert ehpr;
		    
		    /* List<ESC_HomePageReportsController.ReportC> rList = new List<ESC_HomePageReportsController.ReportC>();*/
		    
		     ESC_HomePageReportsController.ReportC rep = new ESC_HomePageReportsController.ReportC();
		     rep.cacheAge = 300;
		     rep.reportcID ='ffdfsdgsdf';
		     
		    
		  
		    
		   ESC_HomePageReportsController obj= new ESC_HomePageReportsController();
		 //  obj.initializeReports();
		  

	}

}
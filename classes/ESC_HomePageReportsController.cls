public class ESC_HomePageReportsController {
        public static List<ReportC> reportList{get; set;}
        public static Component.Apex.OutputPanel myPanel{get; set;}
 public static Component.Apex.OutputPanel initializeReports(){
          reportList = new list<ReportC>();
          myPanel = new Component.Apex.OutputPanel();
          Boolean status = false;
           
        try{
         ESC_HomePageReports__c hpr = ESC_HomePageReports__c.getInstance();
         string[] reportIDS = hpr.ESC_ReportIDS__c.split(',');
            for(string reportObj : reportIDS ){
           ReportC rep = new ReportC();
            rep.cacheAge = Integer.valueOf(hpr.ESC_CacheAge__c);
            rep.reportcID = reportObj.trim();
            reportList.add(rep);
            status = true;
           Component.Apex.OutputPanel internalPanel  = new Component.Apex.OutputPanel();
             internalPanel.styleclass ='blockOP';
       
        internalPanel.childComponents.add(new Component.analytics.reportChart(reportid = rep.reportcID,size = 'small',showrefreshbutton = true,cacheAge =  rep.cacheAge));
         myPanel.childComponents.add(internalPanel);
     
            }
           system.debug('reportList '+reportList);
            
        }
        catch (exception ex){
           //myPanel.childComponents.add(new Component.Apex.outputText(value = ex.getMessage()));
        }
        finally{
            if(!status){
                  myPanel.childComponents.add(new Component.Apex.outputText(value = Label.ESC_ZeroReportsMSG));
                   // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.ESC_ZeroReportsMSG));
            }
            
        }
    
        return myPanel;
    }
    
    public ESC_HomePageReportsController(){
        initializeReports();
    }
    public static void getReportsPanel(){
        
    }
      public class ReportC{
        public integer cacheAge{get; set;}
        public string reportcID{get;set;}
    }
   
}
public class ESC_AccountOpenCaseCountController {
  public Integer casCountAcc{get;set;}
  set<String> openCaseStatusExcluded = new set<String>();
   set<String> recordTypeList = new set<String>();     
              
  public ESC_AccountOpenCaseCountController(ApexPages.StandardController controller){
    casCountAcc = 0; 
      Id accountId = ApexPages.currentPage().getParameters().get('id');
      system.debug('AccountId : '+accountId);
      
      for (String temp: Label.ESC_OpenCaseExcludeStatus.split(';'))
            {
                openCaseStatusExcluded.add(temp);
            }
     for (String temp: Label.ESC_OpenCaseRecordType.split(';'))
            {
                recordTypeList.add(temp);
            } 
        list<Case> cas = [Select Status, IsClosed, Id, accountId From Case where accountId =:accountId and IsClosed=false and status NOT IN : openCaseStatusExcluded and  RecordType.Name  IN :recordTypeList];    
        
        if(cas.size()>0){
          casCountAcc = cas.size();
          system.debug('casCountAcc : '+casCountAcc);
        }    
  }
}
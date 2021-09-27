public class ESC_ContactOpenCaseCountController {
  public Integer casCountCont{get;set;}
  set<String> openCaseStatusExcluded = new set<String>();
  set<String> recordTypeList = new set<String>();            
  
  public ESC_ContactOpenCaseCountController(ApexPages.StandardController controller){
    casCountCont = 0; 
      Id contactId = ApexPages.currentPage().getParameters().get('id');
      system.debug('ContactId : '+contactId);
      
      for (String temp: Label.ESC_OpenCaseExcludeStatus.split(';'))
            {
                openCaseStatusExcluded.add(temp);
            } 
    for (String temp: Label.ESC_OpenCaseRecordType.split(';'))
            {
                recordTypeList.add(temp);
            } 
             system.debug(openCaseStatusExcluded);
              system.debug(recordTypeList);
        list<Case> cas = [Select Status, IsClosed, Id, contactId,RecordTypeId From Case where contactId =:contactId and IsClosed=false and status NOT IN : openCaseStatusExcluded and  RecordType.Name IN :recordTypeList];
        if(cas.size()>0){
          casCountCont = cas.size();
          system.debug('casCountCon : '+casCountCont);
        }    
  }

}
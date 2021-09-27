public class LCRMActiviInactiveContactController{
    public string strObjId;
    public boolean isActive = true;
    public PageReference pageDetail;
    public list<Contact> conList;
    private String urlString;
    public string subjectLine;
    public string caseType;
    public LCRMActiviInactiveContactController(){
        String strParams = ApexPages.currentPage().getParameters().get('urlparm');
        Map<String, String> UrlParameterMap = ApexPages.currentPage().getParameters();
        if (UrlParameterMap.containsKey('Id')){
            strObjId = UrlParameterMap.get('Id');
        }
    }
    public PageReference contactActiveInactive(){
        System.debug('@@@@@ Inside contactActiveInactive method');
        if(strObjId != null){
            conList = new List<Contact>([SELECT Account.Name, Account.Id, Name, Id, Contact_Inactive__c FROM Contact WHERE Id =: strObjId LIMIT 1]);
        }
        if(conList != null){
        urlString = '/500/e?cas4=' + conList[0].Account.Name.replace('&', '%26') + 
                    '&cas4_lkid='+ conList[0].Account.Id +
                    '&cas3='+ conList[0].Name +
                    '&cas3_lkid='+ conList[0].Id +
                    '&ent=Case'+
                    '&cas21=1'+
                    '&RecordType='+ FieldId__c.getOrgDefaults().GLI_Archive_Case__c +
                    '&&retURL=/'+ conList[0].Id;
        if(conList[0].Contact_Inactive__c == true){
            caseType = 'Activate%20Contact';
            subjectLine = 'Contact%20Activiation%20Request%20'+  conList[0].Name;
        }
        else{
            caseType = 'Inactivate%20Contact';
            subjectLine = 'Contact%20Inactivation%20Request%20'+  conList[0].Name;
        }
        urlString += '&cas14='+ subjectLine;
        urlString += '&cas5='+ caseType;
        pageDetail = new PageReference(urlString);
        
        }
        System.debug('@@@@@pageDetail: '+pageDetail);
        return pageDetail;
    }
}
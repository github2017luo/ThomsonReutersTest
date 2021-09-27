@RestResource(urlMapping='/download/*')
global with sharing class CaseManagementImplments {
//Downloading the Attachment 
@HttpGet
    global static List<String> doGet() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String attachmentId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    List<ContentVersion> listContentVersion = new list<ContentVersion>();

    List<String> listDownload = new List<String>();
    listContentVersion = [select Id,VersionData,PathOnClient,Title from ContentVersion where Id =: attachmentId];
    system.debug('listContentVersion---'+listContentVersion);
    String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
    String sfdc1 = sfdcBaseURL+ '/services/data/v45.0/sobjects/ContentVersion/';

    if(listContentVersion.size()>0 && listContentVersion!= null ){    
       for(ContentVersion a: listContentVersion){
          system.debug('a----'+a);
          sfdc1 = sfdc1+a.Id+'/VersionData';
          listDownload.add(sfdc1);            
       }
    }

    if(!(listDownload.size()>0 && listDownload !=null)){
      listDownload.add('Invalid Attchment  ID ');
    }   


    return listDownload;
    }
}
/*------------------------------------------------------------------------------------------------------ 
Class to identify code coverage for flows.

Developer --  Preetham
--------------------------------------------------------------------------------------------------------- */
global class FlowCoverageClass {

public static Double totalCoverage{get;set;}
public static String flowVerId{get;set;}
public static Double orgFlowCoverage{get;set;}
public static Double flowsWithCov{get;set;}
public static Double allFlows{get;set;}
public static Double totalLines{get;set;}
public static String className{get;set;}
public static String flowName{get;set;}
public static String flowId{get;set;}
public static String methodName{get;set;}
public static Integer flowCoverage{get;set;}
public static List<String> uncoveredFlows{get;set;}
public static List<String> coveredElements{get;set;}
public static Boolean unCovFlow{get;set;}
public static Boolean flowEleFlag{get;set;}
public static Boolean orgCovFlag{get;set;}


/*---------------------------------------------------------------------------------------------------- 
 Gets the list of flows which doesn't have any coverage. 
Flow Coverage Test would not have records for flows which doesn't have coverage 
------------------------------------------------------------------------------------------------------ */
public static void getUncoveredFlows()
{
unCovFlow=false;
flowEleFlag=false;
orgCovFlag= false;
uncoveredFlows = new List<String>();
try
{
HttpRequest req1 = new HttpRequest();
req1.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); //Get user Session ID
req1.setHeader('Content-Type', 'application/json');
req1.setTimeout(120000);
String SFdomainUrl1= URL.getSalesforceBaseUrl().toExternalForm();
String query1='SELECT+Definition.DeveloperName+FROM+Flow+WHERE+Status=';
  query1+='\'';
  query1+='Active';
  query1+='\'';
  query1+='+AND+(ProcessType=';
  query1+='\'';
  query1+='AutolaunchedFlow';
  query1+='\'';
  query1+='+OR+';
  query1+='ProcessType=';
  query1+='\'';
  query1+='Workflow';
  query1+='\'';
  query1+='+OR+';
  query1+='ProcessType=';
  query1+='\'';
  query1+='CustomEvent';
  query1+='\'';
  query1+='+OR+';
  query1+='ProcessType=';
  query1+='\'';
  query1+='InvocableProcess';
  query1+='\'';
  query1+=')+AND+Id+NOT+IN(SELECT+FlowVersionId+FROM+FlowTestCoverage)'; 
  
 system.debug('query1'+query1);

req1.setEndpoint(SFdomainUrl1+'/services/data/v48.0/tooling/query/?q='+query1);
req1.setMethod('GET');
Http h1 = new Http();
HttpResponse res1 = new HttpResponse();
if(Test.isRunningTest())
{
    //res1 = new HttpResponse();
    res1.setHeader('Content-Type', 'application/json');
    res1.setBody('{"records" : [{"attributes" : {"type" : "Flow","url" : "/services/data/v48.0/tooling/sobjects/Flow/30113000000TZUFAA4"}, "Definition" : {"attributes" : {"type" : "FlowDefinition","url" : "/services/data/v48.0/tooling/sobjects/FlowDefinition/30013000000TSLPAA4"},"DeveloperName" : "Promotion_Process_Account_Field_Update"}} ]}');
    res1.setStatusCode(200);
}
else
{
    res1 = h1.send(req1);
    system.debug('resp1'+res1.getBody());
}
map<string,object> reqData1 = (map<string,object>) json.deserializeUntyped(res1.getBody());
list<object> flowData1 = (list<object>) JSON.deserializeUntyped(JSON.serialize(reqData1.get('records')));  
system.debug('No Cov Flows'+flowData1);


for(object thisObj : flowData1)
   {

      map<string, object> thisFlowData =  (map<string, object>) json.deserializeUntyped(JSON.serialize(thisObj));         
      map<string,object> thisflowDef1 = (map<string,object>) thisFlowData.get('Definition') ;
      flowName = String.ValueOf(thisflowDef1.get('DeveloperName')) ;  
      uncoveredFlows.add(flowName); 
 
    }
    unCovFlow= true;
 }     
 catch(Exception ex)
 
 {
 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
 
 }     
         
}
 
/*--------------------------------------------------------------------------------------- 
 Get the coverage contribution from each testmethod associated with the flow. 
Email with the list will be sent to logged in user 
----------------------------------------------------------------------------------------- */

public static void emailFlowCoverage()
{
unCovFlow=false;
flowEleFlag=false;
orgCovFlag= false;

Double linesCovered=0;
Double linesUnCovered=0;
flowCoverage=0;


if(String.isBlank(flowId))
{
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter FlowId')); 
        
}  

else
{
    try
    {
    
      
    HttpRequest req = new HttpRequest();
    req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); //Get user Session ID
    req.setHeader('Content-Type', 'application/json');
    req.setTimeout(120000);
    String SFdomainUrl=URL.getSalesforceBaseUrl().toExternalForm();
    String query='Select+id,FlowVersionId,FlowVersion.Definition.DeveloperName,FlowVersion.ProcessType,ApexTestClass.Name,NumElementsCovered,NumElementsNotCovered,TestMethodName+from+FlowTestCoverage';
    query+='+WHERE+FlowVersionId=';
    query+='\'';
    query+=flowId;
    query+='\'';    
    query+='+AND+FlowVersion.Status=';
    query+='\'';
    query+='Active';
    query+='\'';
    
    
    req.setEndpoint(SFdomainUrl+'/services/data/v48.0/tooling/query/?q='+query);
    req.setMethod('GET');
    Http h = new Http();
    
    HttpResponse res = new HttpResponse();
    if(Test.isRunningTest())
    {
      res.setStatusCode(200);     
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"records" : [ {"Id" : "3023C000002uwHZQAY","FlowVersionId" : "3011B000000LNBaQAO","FlowVersion" : {"Definition" : {"DeveloperName" : "ODT_relating_Lead_to_Invite_Colleague"},"ProcessType" : "Workflow"},"ApexTestClass" : {"Name" : "ODT_TrialReInitiateTest"}, "NumElementsCovered" : 3, "NumElementsNotCovered" : 0, "TestMethodName" : "testContactListCreation"} ]}');
    }
    else
    {
    
    res = h.send(req);
    system.debug('body'+res.getBody());
    
    }
    map<string,object> reqData = (map<string,object>) json.deserializeUntyped(res.getBody());
    list<object> flowData = (list<object>) JSON.deserializeUntyped(JSON.serialize(reqData.get('records')));  
    string header = 'FlowId, Name, ApexClass, Method, Coverage \n';
    string finalstr = header ;
    string recordString ='';
    for(object thisObj : flowData )
    {
        map<string, object> thisFlowData =  (map<string, object>) json.deserializeUntyped(JSON.serialize(thisObj));       
        map<string,object> thisFlowDetail = (map<string,object>) thisFlowData.get('FlowVersion') ;       
        map<string,object> thisflowDef = (map<string,object>) thisFlowDetail.get('Definition') ;        
        map<string,object> thisClassDetail = (map<string,object>) thisFlowData.get('ApexTestClass') ;
        linesCovered = Double.ValueOf(thisFlowData.get('NumElementsCovered'));
        linesUnCovered = Double.ValueOf(thisFlowData.get('NumElementsNotCovered'));
        totalLines = linesCovered + linesUnCovered;      
        flowVerId = String.ValueOf(thisFlowData.get('FlowVersionId'));
        className = String.ValueOf(thisClassDetail.get('Name')) ;
        flowName = String.ValueOf(thisflowDef.get('DeveloperName')) ;           
        methodName = String.ValueOf(thisFlowData.get('TestMethodName'));
        system.debug('LinesCov-->'+linesCovered +' Total -->'+totalLines);
        flowCoverage = Integer.ValueOf((linesCovered / totalLines) * 100);
        recordString = flowVerId+','+flowName+','+className+','+methodName+','+flowCoverage+'%'+'\n';
        finalstr = finalstr + recordString;              
    }

    sendEmail(finalstr, 'Flow Coverage for '+flowName);
    methodName='';className='';flowName='';flowCoverage=0;finalstr='';
    }
    
    catch(Exception ex)
    {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
    }     
}
         
}


/*--------------------------------------------------------------------------------------- 
 Gets the overall flow coverage for the Org
----------------------------------------------------------------------------------------- 

public static void orgFlowCoverage()
{
unCovFlow=false;
flowEleFlag=false;
orgCovFlag= false;
Double activeFlowCount = 0;
Double coveredFlowCount = 0;
//Get all active flows in the Org
try
{
HttpRequest req2 = new HttpRequest();
req2.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); //Get user Session ID
req2.setHeader('Content-Type', 'application/json');
req2.setTimeout(120000);
String SFdomainUrl2= URL.getSalesforceBaseUrl().toExternalForm();
String query2='SELECT+count_distinct(DefinitionId)+FROM+Flow+WHERE+Status=';
  query2+='\'';
  query2+='Active';
  query2+='\'';
  query2+='+AND+(ProcessType=';
  query2+='\'';
  query2+='AutolaunchedFlow';
  query2+='\'';
  query2+='+OR+';
  query2+='ProcessType=';
  query2+='\'';
  query2+='Workflow';
  query2+='\'';
  query2+='+OR+';
  query2+='ProcessType=';
  query2+='\'';
  query2+='CustomEvent';
  query2+='\'';
  query2+='+OR+';
  query2+='ProcessType=';
  query2+='\'';
  query2+='InvocableProcess';
  query2+='\'';
  query2+=')'; 
  
  
system.debug('query'+query2);
req2.setEndpoint(SFdomainUrl2+'/services/data/v48.0/tooling/query/?q='+query2);
req2.setMethod('GET');
Http h2 = new Http();
HttpResponse res2 = h2.send(req2);

map<string,object> reqData2 = (map<string,object>) json.deserializeUntyped(res2.getBody());
list<object> flowData2 = (list<object>) JSON.deserializeUntyped(JSON.serialize(reqData2.get('records')));  


for(object thisObj : flowData2)
{

    map<string, object> thisFlowData1 =  (map<string, object>) json.deserializeUntyped(JSON.serialize(thisObj));     
    activeFlowCount = Double.ValueOf(thisFlowData1.get('expr0'));
}
system.debug('Active Flow Count'+ activeFlowCount);

// Get all flows with coverage in the Org
HttpRequest req3 = new HttpRequest();
req3.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); //Get user Session ID
req3.setHeader('Content-Type', 'application/json');
req3.setTimeout(120000);
String SFdomainUrl3= URL.getSalesforceBaseUrl().toExternalForm();
String query3='SELECT+count_distinct(FlowVersionId)+FROM+FlowTestCoverage+WHERE+FlowVersion.Status=';
  query3+='\'';
  query3+='Active';
  query3+='\'';
  
  
  
system.debug('query'+query3);
req3.setEndpoint(SFdomainUrl3+'/services/data/v48.0/tooling/query/?q='+query3);
req3.setMethod('GET');
Http h3 = new Http();
HttpResponse res3 = h3.send(req3);

map<string,object> reqData3 = (map<string,object>) json.deserializeUntyped(res3.getBody());
list<object> flowData3 = (list<object>) JSON.deserializeUntyped(JSON.serialize(reqData3.get('records')));  


for(object thisObj : flowData3)
{

    map<string, object> thisFlowData2 =  (map<string, object>) json.deserializeUntyped(JSON.serialize(thisObj));     
    coveredFlowCount= Double.ValueOf(thisFlowData2.get('expr0'));
}

system.debug('Covered Flow Count'+ coveredFlowCount);

orgFlowCoverage = ((coveredFlowCount/activeFlowCount) * 100); // Org coverage calculated based on SF article
orgCovFlag=true;
}
catch(Exception ex)
{
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
} 
} */
 
/*--------------------------------------------------------------------------------------- 
 Gets the coverage for all flows in the Org with coverage. Email will be sent to logged in user 
 with all flows details.
----------------------------------------------------------------------------------------- */
 

public static void emailTotalCoverage()
{
unCovFlow=false;
flowEleFlag=false;
orgCovFlag= false;
uncoveredFlows = new List<String>();
Double linesCovered=0;
Double linesUnCovered=0;
Double covePerct =0;
flowCoverage=0;
Map<string,Double> flowTotalLines= new Map<string,Double>();
Map<string,string> flowNameMap= new Map<string,string>();



//Get all flows with testmethod and apex class.
try
{
HttpRequest req = new HttpRequest();
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); //Get user Session ID
req.setHeader('Content-Type', 'application/json');
req.setTimeout(120000);
String SFdomainUrl=URL.getSalesforceBaseUrl().toExternalForm();
String query='SELECT+FlowVersion.Definition.DeveloperName,FlowVersionId,NumElementsCovered,NumElementsNotCovered+FROM+FlowTestCoverage+WHERE+FlowVersion.Status=';  
query+='\'';     
query+='Active';
query+='\'';  
query+='+GROUP+BY+FlowVersion.Definition.DeveloperName,FlowVersionId,NumElementsCovered,NumElementsNotCovered';
  
req.setEndpoint(SFdomainUrl+'/services/data/v48.0/tooling/query/?q='+query);
req.setMethod('GET');
Http h = new Http();

HttpResponse res = new HttpResponse();
    if(Test.isRunningTest())
    {
      res.setStatusCode(200);     
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"records" : [ {"DeveloperName" : "Update","FlowVersionId" : "3011B000000boc6QAA","NumElementsCovered" : 2,"NumElementsNotCovered" : 1} ]}');
    }
    else
    {
    
    res = h.send(req);
    system.debug('body'+res.getBody());
    
    }



map<string,object> reqData = (map<string,object>) json.deserializeUntyped(res.getBody());
system.debug('reqData'+reqData);

list<object> flowData = (list<object>) JSON.deserializeUntyped(JSON.serialize(reqData.get('records')));  
string header = 'FlowId, Name, Coverage \n';
string finalstr = header ;
Double avgCover=0,totalCover=0,flowSize=0;
for(object thisObj : flowData )
{
        map<string, object> thisFlowData =  (map<string, object>) json.deserializeUntyped(JSON.serialize(thisObj));
        string recordString;
        linesCovered = Double.ValueOf(thisFlowData.get('NumElementsCovered'));
        linesUnCovered = Double.ValueOf(thisFlowData.get('NumElementsNotCovered'));
        totalLines = linesCovered + linesUnCovered;                          
        flowVerId = String.ValueOf(thisFlowData.get('FlowVersionId'));            
        flowName = String.ValueOf(thisFlowData.get('DeveloperName')) ;                             
        system.debug('LinesCov-->'+linesCovered +' Total -->'+totalLines);
        flowTotalLines.put(flowVerId,totalLines);
        flowNameMap.put(flowVerId,flowName);

}


HttpRequest req1 = new HttpRequest();
req1.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); //Get user Session ID
req1.setHeader('Content-Type', 'application/json');
req1.setTimeout(120000);
String SFdomainUrl1=URL.getSalesforceBaseUrl().toExternalForm();
String query1='SELECT+FlowVersionId,count_distinct(ElementName)+FROM+FlowElementTestCoverage+WHERE+FlowVersionId+IN(';
for(string s:flowNameMap.KeySet())
{
query1+='\'';
query1+=s;
query1+='\''; 
query1+=',';
}
query1=query1.removeEnd(',');
query1+=')+GROUP+BY+FlowVersionId';
  
system.debug('query'+query1);
req1.setEndpoint(SFdomainUrl1+'/services/data/v48.0/tooling/query/?q='+query1);
req1.setMethod('GET');
Http h1 = new Http();
HttpResponse res1 = new HttpResponse();
if(Test.isRunningTest())
{
  res1.setStatusCode(200);     
  res1.setHeader('Content-Type', 'application/json');
  res1.setBody('{"records" : [ {"FlowVersionId" : "3011B000000boc6QAA","expr0" : 3} ]}');
}
else
{
  res1 = h1.send(req1);
}
map<string,object> reqData1 = (map<string,object>) json.deserializeUntyped(res1.getBody());
list<object> flowData1 = (list<object>) JSON.deserializeUntyped(JSON.serialize(reqData1.get('records')));  
Integer size=0;
for(object thisObj : flowData1 )
{
map<string, object> thisFlowData1 =  (map<string, object>) json.deserializeUntyped(JSON.serialize(thisObj));
flowVerId=String.ValueOf(thisFlowData1.get('FlowVersionId'));
flowCoverage = Integer.ValueOf((Integer.ValueOf(thisFlowData1.get('expr0'))/flowTotalLines.get(flowVerId))*100);
finalstr = finalstr +flowVerId+','+flowNameMap.get(flowVerId)+','+flowCoverage+'%'+'\n'; 
covePerct=covePerct+ flowCoverage; 
size++;
}

          
system.debug('TotalCover'+totalCover+'FlowSize'+flowSize); 
  
finalstr = finalstr+'\n'+','+'Aggregate Flow Coverage'+','+(Integer.ValueOf(covePerct)/size)+'%'+'\n';
system.debug('Final Str'+finalstr);
sendEmail(finalstr,'All Flows Coverage Details');     

methodName='';className='';flowName='';flowCoverage=0;finalstr='';

}
catch(Exception ex)
{
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
} 
         
}
 

 
 
/*------------------------------------------------------------------------------------------------------ 
Get the details of the Elements that are covered and provide the correct coverage for an Individual flow. 
FlowVersionId has to be provided as input.
--------------------------------------------------------------------------------------------------------- */

public static void getFlowDetail()
{
unCovFlow=false;
flowEleFlag=false;
orgCovFlag= false;
Double linesCovered=0;
Double linesUnCovered=0;
if(String.isBlank(flowId))
{
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter FlowId')); 

}
else
{
    try
    {
    
    HttpRequest req = new HttpRequest();
    req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); //Get user Session ID
    req.setHeader('Content-Type', 'application/json');
    req.setTimeout(120000);
    String SFdomainUrl=URL.getSalesforceBaseUrl().toExternalForm();
    String query='Select+id,FlowVersionId,FlowVersion.Definition.DeveloperName,NumElementsCovered,NumElementsNotCovered+from+FlowTestCoverage';
        query+='+WHERE+FlowVersionId=';
        query+='\'';
        query+=flowId;
        query+='\'';    
        query+='+AND+FlowVersion.Status=';
        query+='\'';
        query+='Active';
        query+='\'';
        query+='+LIMIT+1';
        
    
    req.setEndpoint(SFdomainUrl+'/services/data/v48.0/tooling/query/?q='+query);
    req.setMethod('GET');
    
    Http h = new Http();        
    HttpResponse res = new HttpResponse();
    if(Test.isRunningTest())
    {
      res.setStatusCode(200);     
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"records" : [ {"Id" : "3023C000002uwHZQAY","FlowVersionId" : "3011B000000LNBaQAO","FlowVersion" : {"Definition" : {"DeveloperName" : "ODT_relating_Lead_to_Invite_Colleague"},"ProcessType" : "Workflow"},"ApexTestClass" : {"Name" : "ODT_TrialReInitiateTest"}, "NumElementsCovered" : 3, "NumElementsNotCovered" : 0, "TestMethodName" : "testContactListCreation"} ]}');
    }
    else
    {
    
    res = h.send(req);
    system.debug('body'+res.getBody());
    
    }
            
    map<string,object> reqData = (map<string,object>) json.deserializeUntyped(res.getBody());
    system.debug('reqData'+reqData);
    
    list<object> flowData = (list<object>) JSON.deserializeUntyped(JSON.serialize(reqData.get('records')));  
    for(object thisObj : flowData )
    {
        map<string, object> thisFlowData =  (map<string, object>) json.deserializeUntyped(JSON.serialize(thisObj));
        map<string,object> thisFlowDetail = (map<string,object>) thisFlowData.get('FlowVersion') ;       
        map<string,object> thisflowDef1 = (map<string,object>) thisFlowDetail.get('Definition') ;
        flowName = String.ValueOf(thisflowDef1.get('DeveloperName')) ;
        linesCovered = Double.ValueOf(thisFlowData.get('NumElementsCovered'));
        linesUnCovered = Double.ValueOf(thisFlowData.get('NumElementsNotCovered'));
        totalLines = linesCovered + linesUnCovered;   
            
    }
    
    coveredElements = new List<String>();
    HttpRequest req1 = new HttpRequest();
    req1.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); //Get user Session ID
    req1.setHeader('Content-Type', 'application/json');
    req1.setTimeout(120000);
    String SFdomainUrl1= URL.getSalesforceBaseUrl().toExternalForm();
    String query1='SELECT+ElementName+FROM+FlowElementTestCoverage+WHERE+FlowVersionId=';
      query1+='\'';
      query1+=flowId;
      query1+='\'';
      query1+='+GROUP+BY+ElementName';
       
      
    req1.setEndpoint(SFdomainUrl1+'/services/data/v48.0/tooling/query/?q='+query1);
    req1.setMethod('GET');
    Http h1 = new Http();
    HttpResponse res1 = h1.send(req1);
    map<string,object> reqData1 = (map<string,object>) json.deserializeUntyped(res1.getBody());
    Double coveredSize = Double.ValueOf(reqData1.get('totalSize'));
    list<object> flowData1 = (list<object>) JSON.deserializeUntyped(JSON.serialize(reqData1.get('records')));  
    totalCoverage = ((coveredSize/totalLines) *100);
    string element;
    for(object thisObj : flowData1)
     {    
        map<string, object> thisFlowData =  (map<string, object>) json.deserializeUntyped(JSON.serialize(thisObj));                    
        element = String.ValueOf(thisFlowData.get('ElementName')) ;    
        coveredElements.add(element); 
     }
     flowEleFlag=true;
     
     }
    catch(Exception ex)
    {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
    } 
}   
}


/*-------------------------------------------------------------------------------------------------- 
 Common method to send email to logged in user. Record Details and Subject are inputs.
------------------------------------------------------------------------------------------------------ */


 public static void sendEmail(String finalstr,String Sub)
 { 
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'FlowCoverage.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String usrEmail =  UserInfo.getUserEmail();
        String[] toAddresses = new list<string> {usrEmail};        
        email.setSubject(sub);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Coverage Details of Flows');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
 }
          
}
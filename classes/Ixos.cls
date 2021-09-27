@istest
public with sharing class Ixos {
    //Properties
    Public Account oAccount{get;set;}
    Public List<IXOSServices.IXOSDocument> IXOSDocumentList{get;set;}
    Public Id Accid{get;set;}
    Public String OrderNumber{get;set;}
    Public String AcctSapId{get;set;}
    public string IxosBegindt{get;set;}
    public string IxosEnddt{get;set;}
    
    //Constructor
    public Ixos(ApexPages.StandardController controller) {
        IXOSDocumentList = new List<IXOSServices.IXOSDocument>();
        accid = ApexPages.currentPage().getParameters().get('AccId');
        AcctSapId = ApexPages.currentPage().getParameters().get('AcctSapId');
        OrderNumber = ApexPages.currentPage().getParameters().get('OrderNumber');
       oAccount = [Select Id,Name from Account where Id =:accid];
       //Ixosdt = new CustomDate__c(Begin_date__c=system.today().addMonths(-1),End_date__c= system.today());
       IxosBegindt =system.today().addMonths(-1).format();
       IxosEnddt =system.today().format();
       displayIxosDocument();
     }
    
   
     public void displayIxosDocument(){
        try{
            if(Date.parse(IxosBegindt) != null ||  Date.parse(IxosEnddt) != null){
                if(Date.parse(IxosBegindt) > Date.parse(IxosEnddt))
                    throw new AppUtil.AppException('End Date must not be less than Begin Date');
            }
            IXOSServices.IXOSRequest oRequest = new IXOSServices.IXOSRequest();
            oRequest.SystemId = 'SFDC CORE LEGAL';
            List<IXOSDocumenttype__c> ixosdoc = IXOSDocumenttype__c.getall().values();
            List<String> doclist = new list<string>();
            for(IXOSDocumenttype__c i : ixosdoc){
                doclist.add(i.name);
            }
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('IXOS');       
            oRequest.endpoint= oWebServiceSettings.Endpoint__c;
            oRequest.timeout =(oWebServiceSettings.Timeout__c * 1000).intValue(); //Convert seconds to milliseconds
            oRequest.username=oWebServiceSettings.Username__c;
            oRequest.password= oWebServiceSettings.Password__c;
            IXOSServices.DocumentHeader oDocHeader = new IXOSServices.DocumentHeader();
            oDocHeader.AcctSapId = decimal.valueof(AcctSapId);
            oDocHeader.OrderNumber = OrderNumber;
            oRequest.DocumentHeaderList = new List<IXOSServices.DocumentHeader>();
            oRequest.DocumentHeaderList.add(oDocHeader);
            IXOSCodeMap__c oIXOSCodeMap = IXOSCodeMap__c.getinstance('West Group');
            oRequest.CompanyCode = oIXOSCodeMap.Company_Code__c;
            oRequest.SalesOrgCode = oIXOSCodeMap.Sales_Org_Code__c;
            oRequest.DistChanCode = oIXOSCodeMap.Dist_Chan_Code__c;
            oRequest.DivisionCode = oIXOSCodeMap.Division_Code__c;
            oRequest.IxosDocBegDt = Date.parse(IxosBegindt);
            oRequest.IxosDocEndDt = Date.parse(IxosEnddt);
            oRequest.DocumentTypeList=doclist;      
            IxosServices oIxosServices = new IxosServices();
            //system.debug('***'+oRequest);
            IXOSDocumentList =oIxosServices.GetIXOSDocumentDetails(oRequest);
        } 
        catch(Exception oException){
            ApexPages.addMessages(oException);
        }  
    }
}
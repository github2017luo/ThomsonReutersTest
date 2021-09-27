/*
======================================================================================================================
CLASS NAME:    CoreLibraryController
======================================================================================================================
=
PURPOSE:    LEGACY CODE

CHANGE HISTORY:
======================================================================================================================
DATE              NAME                    DESC
2017-03-31        Meenakshmi Goswami      Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
public with sharing class CoreLibraryController {
    //Protected Members
    private final ApexPages.StandardController oStandardController;
    private Account oAccount;
//Properties
    public string sSelectedOption{get;set;}
    public string Code1{get;set;}    
    public string Desc1{get;set;}
    public string Code2{get;set;}    
    public string Desc2{get;set;}
    public integer intMarketSegment {get;set;}
    public List<CoreLibraryService.CoreLibraryMaterials> DisplayCoreLibraryList{get;set;}
    public list<string> corelibrarycodes {get;set;}
    public List<CoreLibraryService.CoreLibraryMaterials> CoreLibraryMaterials {get;set;}
    public List<CoreLibraryService.CoreLibraries> CoreLibraries {get;set;}
    public list<CorelibraryWS.CoreLibrary> ListCoreLibrary {get;set;}
    public list<selectoption> selectcodes {get;set;}
    public List<SelectOption> SelectLibraries1{
        get { return loadSelectLibraries(Code1); }  
    }
    public List<SelectOption> SelectLibraries2 {
        get { return loadSelectLibraries(Code2); }  
    }
    
    //Constructor
    public CoreLibraryController(ApexPages.StandardController oController){
        try {
            oStandardController = oController;
            if (Test.isRunningTest() == false){
                oController.addFields(new string[]{'Market_Segment__c','MDBID__c','FrozenMarketSegment__c'});
            } //Workaround for unit test bug when using addFields method on controller
            oAccount = (Account) oController.getRecord();
            //desc1='2171';code1='AK'; AllBegindt=system.today().addMonths(-1).format();
           //MarketSegment__c oMarketSegment = MarketSegment__c.getinstance(oAccount.Market_Segment__c);
           MarketSegment__c oMarketSegment = MarketSegment__c.getinstance(oAccount.FrozenMarketSegment__c);
            if (omarketsegment != null && omarketSegment.marketsegmentkey__C != null){
                intMarketSegment = Integer.valueOf(oMarketSegment.MarketSegmentKey__c);
           }
           //intMarketSegment = integer.valueof(oAccount.FrozenMarketSegment__c);
           listcorelibrary = new list<CorelibraryWS.CoreLibrary>();
           corelibrarycodes = new list<string>();
           corelibraries = new list<CoreLibraryService.CoreLibraries>();
           CoreLibrarycodes = GetCoreLibraryCodes();
           //SelectLibraries1 = loadSelectLibraries(Code1); CoreLibraries = getCoreLibraries(); changeDisplayCoreLibraryList(); 
           selectCodes = getCoreLibraryListOptions(CoreLibraryCodes);
        }
        catch (Exception oException){
            ApexPages.addMessages(oException);
        }
    }

    public list<CoreLibraryService.CoreLibraries> GetCoreLibraries(string sCode){
         try{
            CoreLibraryService oCoreLibraryService = new CoreLibraryService();
            CoreLibraryService.CoreLibraryRequest oCoreLibraryRequest = new CoreLibraryService.CoreLibraryRequest();
            CorelibraryWS.CoreLibrary oCoreLibrary = new  CorelibraryWS.CoreLibrary();
            //oCoreLibraryRequest.MarketSegment = 2;
            oCoreLibraryRequest.MarketSegment = intMarketSegment;
            //oCoreLibraryRequest.corelibrarycode = 'AK';
            oCoreLibraryRequest.corelibrarycode = sCode;
/*system.debug('***oCoreLibraryRequest'+oCoreLibraryRequest);-- commented to reduce character for s2e optimization */
            CoreLibraries = CoreLibraryService.GetCoreLibraries(oCoreLibraryRequest); 
/*system.debug('***CoreLibraries'+CoreLibraries);-- commented to reduce character for s2e optimization */
        }
        catch(Exception oException){
            if(oException.getMessage().contains('timed out'))
               // ApexPages.addMessages(new AppUtil.AppException('Webservice timed out. Please filter the orders furthermore and retry')); //Replaced with Custom Label as part of S2E Optimization
               ApexPages.addMessages(new AppUtil.AppException(Label.TimeOutException));
            else    
                ApexPages.addMessages(oException);
        } 
        return CoreLibraries;     
    }

    public list<string> GetCoreLibraryCodes(){
         list<string> oCoderesults = new list<string>();
         try{            
            CoreLibraryService oCoreLibraryService = new CoreLibraryService();
            CoreLibraryService.CodeRequest oCodeRequest = new CoreLibraryService.CodeRequest();
            //oCodeRequest.MarketSegment = 2;
            oCodeRequest.MarketSegment = intMarketSegment;
/*system.debug('***oCodeRequest'+oCodeRequest);-- commented to reduce character for s2e optimization */
            oCoderesults = CoreLibraryService.GetCoreLibraryCodes(oCodeRequest);
/*system.debug('***oCoderesults'+oCoderesults);-- commented to reduce character for s2e optimization */
        }
        catch(Exception oException){
            if(oException.getMessage().contains('timed out'))
               // ApexPages.addMessages(new AppUtil.AppException('Webservice timed out. Please filter the orders furthermore and retry')); //Replaced with Custom Label as part of S2E Optimization
               ApexPages.addMessages(new AppUtil.AppException(Label.TimeOutException));
            else
                ApexPages.addMessages(oException);
        } 
        return oCoderesults;     
    }


public list<CoreLibraryService.CoreLibraryMaterials> getCoreLibraryMaterials(string sdesc1,string sdesc2){
         try{            
            listcorelibrary = new list<CorelibraryWS.CoreLibrary>();
            if(sdesc1 == null){
                 throw new AppUtil.AppException('Code and description must be valued'); 
            }
            CoreLibraryService oCoreLibraryService = new CoreLibraryService();
            CoreLibraryService.CoreLibraryMaterialRequest oCoreLibraryMaterialRequest = new CoreLibraryService.CoreLibraryMaterialRequest();
            CorelibraryWS.CoreLibrary oCoreLibrary = new  CorelibraryWS.CoreLibrary();
            oCorelibrary.CoreLibraryId = '2171';
            oCorelibrary.CoreLibraryId= sdesc1;
            //oCoreLibraryMaterialRequest.MDBId = '471829999999';
            oCoreLibraryMaterialRequest.MDBId = oAccount.MDBID__c;
            //oCoreLibraryMaterialRequest.MarketSegment = 2;
            oCoreLibraryMaterialRequest.MarketSegment = intMarketSegment;
            //oCoreLibraryMaterialRequest.MarketSegment = oAccount.Market_Segment__c;
            //listcorelibrary[0] = ocorelibrary;
            listcoreLibrary.add(ocorelibrary);
            CorelibraryWS.CoreLibrary oCoreLibrary2 = new  CorelibraryWS.CoreLibrary();
            oCorelibrary2.corelibraryID= sdesc2;
            listcoreLibrary.add(ocorelibrary2);
            //listcorelibrary[1] = ocorelibrary;
            //listcoreLibrary.add(ocorelibrary);
/*system.debug('***oCorelibrary'+oCorelibrary);-- commented to reduce character for s2e optimization */
            oCoreLibraryMaterialRequest.CoreLibrary = listCoreLibrary;
/*system.debug('***'+oCoreLibraryMaterialRequest);-- commented to reduce character for s2e optimization */
            CoreLibraryMaterials = CoreLibraryService.GetCoreLibraryMaterial(oCoreLibraryMaterialRequest); 
        }
        catch(Exception oException){
            if(oException.getMessage().contains('timed out'))
               // ApexPages.addMessages(new AppUtil.AppException('Webservice timed out. Please filter the orders furthermore and retry')); //Replaced with Custom Label as part of S2E Optimization
               ApexPages.addMessages(new AppUtil.AppException(Label.TimeOutException));
            else    
                ApexPages.addMessages(oException);
        } 
        return CoreLibraryMaterials;     
    }


    
    // Public Methods
    public void changeDisplayCoreLibraryList(){
        try{
            CoreLibraryMaterials = new List<CoreLibraryService.CoreLibraryMaterials>();
            CoreLibraryMaterials = getCoreLibraryMaterials(desc1,desc2);
        }
        catch (Exception oException){
            ApexPages.addMessages(oException);
        }
    }

    /*
    Returns list of values to be slected in the page
    @return List of selectoption
    */

    public List<selectoption> getCoreLibraryListOptions(List<string> listCodes){
        List<selectoption> listCodeSelectOptions = new List<selectoption>();
        listCodeSelectOptions.add(new SelectOption('','--None--'));
        for (string sCode : listCodes){
            listCodeSelectOptions.add(new SelectOption(sCode, sCode));
        }
        return listCodeSelectOptions; 
    }
    
    private List<SelectOption> loadSelectLibraries(string sCode){
        List<SelectOption> listLibrarySelectOptions = new List<SelectOption>();
        listLibrarySelectOptions.add(new SelectOption('','--None--'));
        if (AppUtil.isEmpty(sCode) == false){
            //TODO: Load this list of libraries 
            //List<string> listLibraries = new List<string>(); //getCoreLibraryList(sCode); //Callout to get Libraries
            List<CoreLibraryService.CoreLibraries> listLibraries = getCoreLibraries(sCode); //Callout to get Libraries
            for (CoreLibraryService.CoreLibraries sLibrary : listLibraries){
                listLibrarySelectOptions.add(new SelectOption(sLibrary.CoreLibraryId, sLibrary.CoreLibraryDesc));
            }
        }
        return listLibrarySelectOptions;
    }
    
    public class CoreLibraries{
        public String CoreLibraryId {get;set;}
        public String CoreLibraryDesc {get;set;}
    }
}
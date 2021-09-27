/**
* Controller for the OnlineContacts.page that extends the 
* Quote/Proposal standard controller
*
* @author  TCS
* @version 2016-07-01
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                    Description
* 2016-07-01   Sreenu D                     Created 
* 2016-11-01   Sreenu D                     Multiple Agreement Location Changes- R2                                                                  
* =============================================================================
*/
/**
 * @description OnlineContactsController
 */
global with sharing class OnlineContactsController {
    
    // Variables
    public List<Apttus_Proposal__Proposal_Line_Item__c> apliUpdList;
    public Set<Id> bandedApliIds;
    public Map<String, List<APLIWrapper>> materialsMap;
    public Map<String, List<APLIWrapper>> rsMaterialsMap;
    public Boolean isBandedValidation = False;
    public transient Map<string, string> bandedProductsMap;
    public Integer olContactsSize = 0;
    public Decimal checkBandedSize = 0;
    public Map<string, Apttus_Proposal__Proposal_Line_Item__c> psCountMap;
    public Map<string, Apttus_Proposal__Proposal_Line_Item__c> odCountMap;
    public List<Online_Contacts__c> ocList ;
    public transient Map<string, List<Online_Contacts__c>> mocMap; // Map to hold Online Contacts without Contact Id
    public transient Map<string, Online_Contacts__c> cmocMap; // Map to Online Contacts with Contact Id
    public transient Map<String, List<APLIWrapper>> bandedMap;
    public Set<Online_Contacts__c> bpListtoDel;
    public Set<Online_Contacts__c> psListtoDel; 
    public Set<Online_Contacts__c> odListtoDel;   
    //public Integer pageSize = 5;
    public string bandedMaterials = '';
    public string perSheetmaterials = '';
    public string odenmaterials = '';
    public transient OnlineContactsSerializeandDeserializeRes.OnlineContactResponse olDataESI;
    public transient OnlineContactsSerializeandDeserializeRes.Notification olNoteESI;
    public transient List<string> lineStatus;
    public Boolean isLiveNoteBandedProduct;
    public Boolean patronFlag = false; //SOC-8413
    public Boolean errorFlag = false; //patron SOC-8413
    public Boolean bandError = false; //SOC-9128
    public Map<Id,Integer> bandedCountMap; //SOC-9128
    public Integer bandedCount = 0; //SOC-9128
    //Added By Poonam Garg for DOC 11616 Pagination
    public List<APLIWrapper> lstbandedSetController;
    public List<APLIWrapper> lstperSeatController;
    private Integer pageSize=100;
    private Integer index;       
    APTS_CustomPaginationCtrl obj;
    private String checkRecInNextChunk;
    private Boolean tabSwitch=false; 
    private Integer countEsiCalls=0;
    public List<String> productlist = new List<String>();
    public Map<String,Integer> prodquanty = new Map<String,Integer>();
    public Map<String,Integer> prdqty = new Map<String,Integer>();
    public List<Integer> qtylist = new List<Integer>();
    public transient List<OnlineContactsSerializeandDeserializeRes.OnlineContactResponse> chunkolDataESI;  
    private Map<Integer, Map<String, List<APLIWrapper>>> totalMaterialsMap;
    string sapNo = '';
    ID quoteAcc = null;
    ID quoteSsd=null;
    private String prevLocation;
    private Boolean checkMinOneContact;
    /**
 * @description proposalId
 */
    public string proposalId {get; set;}  
       /**
 * @description aptProposal
 */
    public Apttus_Proposal__Proposal__c aptProposal {get; set;}
        /**
 * @description apliList
 */
    public transient List<Apttus_Proposal__Proposal_Line_Item__c> apliList {get; set;}
    

          /**
 * @description apliWrapper
 */
    public List<APLIWrapper> apliWrapper {get; set;}
          /**
 * @description perSheetAPLIList
 */
    public List<APLIWrapper> perSheetAPLIList {get; set;}   
          /**
 * @description selectedAPLIs
 */
    public List<APLIWrapper> selectedAPLIs {get; set;}
          /**
 * @description isSelectAll
 */
    public Boolean isSelectAll {get; set;}
          /**
 * @description isBandedOneSelected
 */
    public Boolean isBandedOneSelected {get; set;}
          /**
 * @description isperSheetOneSelected
 */
    public Boolean isperSheetOneSelected {get; set;}
          /**
 * @description isodenOneSelected
 */
    public Boolean isodenOneSelected {get; set;}   
          /**
 * @description isBandedSelectAll
 */ 
    public Boolean isBandedSelectAll {get; set;}
          /**
 * @description isPerSheetSelectAll
 */
    public Boolean isPerSheetSelectAll {get; set;}
          /**
 * @description tabName
 */
    public String tabName{get; set;} 
          /**
 * @description isodenSelectAll
 */
    public Boolean isodenSelectAll {get; set;}  
    
    // dropdown
            /**
 * @description perSeatProducts
 */
    public string perSeatProducts {get; set;}
            /**
 * @description psProductsList
 */
    public List<SelectOption> psProductsList {get; set;}
            /**
 * @description dspMaterials
 */
    public List<APLIWrapper> dspMaterials {get; set;}

            /**
 * @description odenProducts
 */
    public string odenProducts {get; set;}
            /**
 * @description odProductsList
 */
    public List<SelectOption> odProductsList {get; set;}
            /**
 * @description oddspMaterials
 */
    public List<APLIWrapper> oddspMaterials {get; set;}
    
            /**
 * @description maxBandedProdQnt
 */
    public Decimal maxBandedProdQnt {get; set;}
    
            /**
 * @description bandedProducts
 */
    public List<string> bandedProducts {get; set;}
     // to hold the Banded Products Material and product description
            /**
 * @description psMaterial
 */
    public PSMaterials psMaterial {get; set;}
   
            /**
 * @description isAddReq
 */
    Public Boolean isAddReq {get; set;}
            /**
 * @description isodAddReq
 */
    Public Boolean isodAddReq {get; set;}   
            /**
 * @description isExCon
 */
    Public Boolean isExCon {get; set;} // Flag to display Add Online contacts Button in banded materials tab if Sap Contacts exists
            /**
 * @description isExPSCon
 */
    Public Boolean isExPSCon {get; set;} // Flag to display Add Online contacts Button in Per sheetmaterials tab if Sap Contacts exists
    // Location Dropdown
            /**
 * @description location
 */
    public string location {get; set;}
            /**
 * @description locationList
 */
    public List<SelectOption> locationList {get; set;}
            /**
 * @description locationMap
 */
    public Map<Id, APTS_Quote_Agreement_Locations__c> locationMap {get; set;}
            /**
 * @description preLocation
 */
    public string preLocation {get; set;}
    
            /**
 * @description isError
 */
    public Boolean isError {get; set;}
    
            /**
 * @description pageNum
 */
    public Integer pageNum{get;set;}
    
               /**
 * @description 
 */
    public Integer totalRecinAllBatchesPerSeat{get;set;}
    
              /**
 * @description perseatsize
 */
    public Boolean perseatsize {get; set;}
              /**
 * @description totaldspmaterialsList
 */
    public List<APLIWrapper> totaldspmaterialsList{get; set;}
              /**
 * @description totalbandedList
 */
    public List<APLIWrapper> totalbandedList {get; set;}
               /**
 * @description sizeofWrapper
 */
    public Integer sizeofWrapper{get;set;}
              /**
 * @description paramDigit
 */
    public Integer paramDigit{get;set;}
    
    //Added By Poonam Garg DOC 11616
               /**
 * @description next
 */
    public void next(){  
       
       System.debug(LoggingLevel.WARN,'pageNum '+ pageNum);
       if(pageNum ==0){
           pageNum =1;
       }  
       else {
           pageNum =pageNum +1; // Page becomes 10
       }  
        System.debug(LoggingLevel.WARN,obj);
        System.debug(LoggingLevel.WARN,tabName);
         if(tabName=='Banded Products'){
               lstbandedSetController =obj.next();
               sizeofWrapper=totalbandedList.size();
        }
        else if(tabName=='Per Seat Products'){
               lstperSeatController =obj.next();
               sizeofWrapper=totaldspmaterialsList.size();
        }
        System.debug(LoggingLevel.WARN,'sizeofWrapper'+ sizeofWrapper);
        System.debug(LoggingLevel.WARN,'pageNum '+ pageNum );
        system.debug(LoggingLevel.WARN,lstbandedSetController .size() );
        system.debug(LoggingLevel.WARN,lstperSeatController.size() );
    }
    /**
     * @description onClickDigit
     */
    public void onClickDigit(){
     if(paramDigit!=null && paramDigit>0){
         if(tabName=='Banded Products'){
               obj = new APTS_CustomPaginationCtrl (totalBandedList);  
               sizeofWrapper=totalBandedList.size();
               lstbandedSetController =obj.OnclickDigit(paramDigit);
        }
        else if(tabName=='Per Seat Products'){
                obj = new APTS_CustomPaginationCtrl (totaldspmaterialsList); // dspMaterials
                sizeofWrapper=totaldspmaterialsList.size();
               lstperSeatController =obj.OnclickDigit(paramDigit);
        }
        pageNum=paramDigit;
     }
    
    }
    /**
     * @description previous
     */
    public void previous(){ 
        if(pageNum ==0){
           pageNum =1;
       }  
       else{
       pageNum =pageNum -1;
       }  
       if(tabName=='Banded Products'){
               lstbandedSetController =obj.previous(pageNum + 1);
       }
       else if(tabName=='Per Seat Products'){
               lstperSeatController =obj.previous(pageNum + 1);
       }
       System.debug(LoggingLevel.WARN,'pageNum '+ pageNum );
    }
    //Show only when no of rec are more than 900
    /**
     * @description gethasNext 
     * @return gethasNext
     */
    public Boolean gethasNext() {
        if(tabName=='Banded Products'){
                   getlstbandedSetController();
            }
            else if(tabName=='Per Seat Products'){
                   getlstperSeatController();
            }
            return obj.hasNext();
    } 
    //Show only when no of rec are more than 900
    /**
     * @description gethasPrevious
     * @return gethasPrevious
     */
    public Boolean gethasPrevious() {
        if(tabName=='Banded Products'){
                   getlstbandedSetController();
            }
            else if(tabName=='Per Seat Products'){
                   getlstperSeatController();
            }
            return obj.hasPrevious();
    }
    /**
     * @description setBandedTab
     */
    public void setBandedTab() {
        System.debug(LoggingLevel.WARN,'bandedAPLIList------'+totalbandedList.size());
        tabName='Banded Products';
        System.debug(LoggingLevel.WARN,'tabName------'+tabName);
        index=0;
        countEsiCalls=0;
        tabSwitch=true;
        sizeofWrapper=0;
        if(!totalBandedList.isEmpty()){
        sizeofWrapper=totalBandedList.size();}
        paramDigit=0;
        prevlocation='';
        //getlstbandedSetController();
        
    }
   //Added By Poonam Garg DOC 11616
   /**
     * @description setPerseatTab
     */
    public void setPerseatTab() {
        tabName='Per Seat Products';
        System.debug(LoggingLevel.WARN,'tabName------'+tabName);
        index=0;
        countEsiCalls=0;
        tabSwitch=true;
        sizeofWrapper=0;
        if(!totaldspmaterialsList.isEmpty()){
        sizeofWrapper=totaldspmaterialsList.size();}
        paramDigit=0;
        prevlocation='';
        //getlstperSeatController();
    }
    //Added By Poonam Garg DOC 11616
    /**
     * @description getlstbandedSetController
     * @return getlstbandedSetController
     */
    public List<APLIWrapper>  getlstbandedSetController(){
        System.debug(LoggingLevel.WARN,'getlstbandedSetController');
        System.debug(LoggingLevel.WARN,'tabSwitch'+tabSwitch);
        System.debug(LoggingLevel.WARN,'tabName'+tabName);
        System.debug(LoggingLevel.WARN,'sizeofWrapper'+sizeofWrapper);
        if(tabName=='Banded Products'){
            if((tabName=='Banded Products' && tabSwitch) || (tabName=='Banded Products' && checkMinOneContact)){ //&& tabSwitch 
                System.debug(LoggingLevel.WARN,totalbandedList.size());
                obj = new APTS_CustomPaginationCtrl (totalBandedList);
                tabswitch=false;
                pageNum=1;
                lstbandedSetController = obj.next();
                sizeofWrapper=totalBandedList.size();
                System.debug(LoggingLevel.WARN,'sizeofWrapper'+sizeofWrapper);
                checkMinOneContact=false;
            }
            if(pageNum==0){
                pageNum=1;    
            }
            obj.setPageSize = pageSize;
            System.debug(LoggingLevel.WARN,'lstSetController1--'+lstbandedSetController );
        }
        return lstbandedSetController;
    }
    //Added By Poonam Garg DOC 11616
    /**
     * @description getlstperSeatController
     * @return getlstperSeatController
     */
    public List<APLIWrapper>  getlstperSeatController(){
        System.debug(LoggingLevel.WARN,'getlstperSeatController');
        System.debug(LoggingLevel.WARN,'tabSwitch'+tabSwitch);
        System.debug(LoggingLevel.WARN,'tabName'+tabName);
        System.debug(LoggingLevel.WARN,'sizeofWrapper'+sizeofWrapper);
        if(tabName=='Per Seat Products'){
            if((tabName=='Per Seat Products' && tabSwitch) || (tabName=='Per Seat Products' && checkMinOneContact) ){  
               obj = new APTS_CustomPaginationCtrl (totaldspmaterialsList); 
               tabswitch=false;
               pageNum=1;
               lstperSeatController = obj.next();
               sizeofWrapper=totaldspmaterialsList.size();
               System.debug(LoggingLevel.WARN,'sizeofWrapper'+sizeofWrapper);
               checkMinOneContact=false;
            }
            if(pageNum==0){
                pageNum=1;    
            }
            obj.setPageSize = pageSize;
        }
        return lstperSeatController;
    }
    // Constructor 
    /**
     * @description OnlineContactsController
     * @param stdCon
     */
    public OnlineContactsController(ApexPages.StandardController stdCon) {        
        apliList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        aptProposal = new Apttus_Proposal__Proposal__c();
        bandedApliIds = new Set<Id>();
        apliWrapper = new List<APLIWrapper>();        
        selectedAPLIs = new List<APLIWrapper>();        
        isSelectAll = False;
        isBandedOneSelected = False;
        isperSheetOneSelected = False;
        isodenOneSelected = False;  
        isBandedSelectAll = False;
        isPerSheetSelectAll = False;
        isodenSelectAll = False;    
        ocList = new List<Online_Contacts__c>();
        bandedCountMap = new Map<Id,Integer>(); //SOC-9128
        // Location Dropdown
        location = '';
        locationList = new List<SelectOption>();
        locationMap = new Map<Id, APTS_Quote_Agreement_Locations__c>();
        preLocation = '';
        prevLocation='';
        isError = False;
        //Added By Poonam Garg
        totalMaterialsMap=new Map<Integer, Map<String, List<APLIWrapper>>>();
        totaldspmaterialsList=new List<APLIWrapper>();
        totalBandedList=new List<APLIWrapper>();
        pageNum =0;
        index=0;
        paramDigit=0;
        checkRecInNextChunk='true'; 
        lstbandedSetController=new List<APLIWrapper>();
        lstperSeatController=new List<APLIWrapper>();   
        totalRecinAllBatchesPerSeat=0;
        sizeofWrapper=0;   
        tabName='Banded Products';  
        checkMinOneContact=false;
        obj = new APTS_CustomPaginationCtrl (totalbandedList);
        proposalId = ApexPages.CurrentPage().getParameters().get('id').escapeHtml4(); //Added by Kruti Shah to avoid PMD violation
        // get the Quote/Proposal Line Items base on the Quote/Proposal Id
        if(!string.isEmpty(proposalId)) {
            try {                
                if(Schema.sObjectType.Apttus_Proposal__Proposal__c.isAccessible() && Schema.sObjectType.Apttus_Proposal__Proposal__c.isQueryable()){           
                aptProposal = [Select Id, Name, Apttus_Proposal__Account__c, APTS_MLA_Quote__c, Apttus_Proposal__Account__r.Name, 
                               Apttus_Proposal__Account__r.External_Trial_Account_ID__c, APTS_SSD_Sold_To__r.LCRM_Sales_Org__c, //doc-15793  
                               APTS_SSD_Sold_To__r.Source_System_Account_Number__c,APTS_SSD_Sold_To__r.LCRM_External_Trail_Acount_ID__c,APTS_SSD_Sold_To__r.OLC_Account_Number__c,Apttus_Proposal__Approval_Stage__c 
                               ,Apttus_Proposal__Opportunity__r.Active_Trial__c From Apttus_Proposal__Proposal__c Where Id =: proposalId];}
                system.debug(LoggingLevel.WARN,'aptProposal...'+aptProposal);
                //apliList = [Select Id, Name, APTS_Program_ID__c, APTS_Product_Name_Override__c, APTS_Service_Number_Override__c, Apttus_QPConfig__LineType__c, APTS_Number_of_Attorneys__c, Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.Name, Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c, Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c, Apttus_Proposal__Product__r.Apttus_Config2__Uom__c, Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.APTS_Cat_L5__c, Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.Name From Apttus_Proposal__Proposal_Line_Item__c Where (Apttus_Proposal__Proposal__c = :proposalId AND Apttus_QPConfig__LineStatus__c != 'Amended' AND Apttus_QPConfig__LineStatus__c != 'Cancelled' AND Apttus_QPConfig__LineStatus__c != 'Renewed')  Order By Apttus_Proposal__Product__r.ProductCode ASC Nulls Last];
                // get the Account Locations based on the quote
                if(aptProposal.APTS_MLA_Quote__c) {        //doc-15793             
                    for(APTS_Quote_Agreement_Locations__c al : [Select Id, APTS_Subscriber_Location__c,APTS_Subscriber_Location_SSD__c,
                                                                APTS_Subscriber_Location_SSD__r.name,APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c ,
                                                                APTS_Subscriber_Location_SSD__r.LCRM_External_Trail_Acount_ID__c,APTS_Subscriber_Location__r.Name,APTS_Subscriber_Location_SSD__r.OLC_Account_Number__c,APTS_Quote_Proposal__r.Apttus_Proposal__Opportunity__r.Active_Trial__c,//doc-15793
                                                                APTS_Status__c From APTS_Quote_Agreement_Locations__c 
                                                                Where APTS_Quote_Proposal__c = :proposalId AND APTS_Status__c IN ('New', 'Existing')]) {
                                                                    locationMap.put(al.APTS_Subscriber_Location_SSD__c, al); //.APTS_Subscriber_Location__r.SAPAccountNumber__c);
                                                                    locationList.add(new SelectOption(al.APTS_Subscriber_Location_SSD__c, al.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c +' - '+al.APTS_Subscriber_Location_SSD__r.Name));                  
                                                                    // assign the value if dropdown list is blank for first time
                                                                    if(string.isEmpty(location)) {
                                                                        location = al.APTS_Subscriber_Location_SSD__c;
                                                                        preLocation = location;                        
                                                                    }    
                                                                }                    
                }
                
                // call the method to map the Online contacts to display in the page.
                mappingLogic();
                //Added By Poonam Garg.
                
                System.debug(LoggingLevel.WARN,'bandedAPLIList------'+totalbandedList.size());
                system.debug(LoggingLevel.WARN,'tabName..'+tabName);
                system.debug(LoggingLevel.WARN,'totaldspmaterialsList.. '+totaldspmaterialsList.size() );
                if(!totalbandedList.isEmpty() && tabName=='Banded Products'){
                    sizeofWrapper=totalbandedList.size();
                    obj = new APTS_CustomPaginationCtrl (totalbandedList);
                    obj.setPageSize = pageSize;
                    next();
                }
                if(totalBandedList.isEmpty() && !totaldspmaterialsList .isEmpty() ){
                    obj = new APTS_CustomPaginationCtrl (totaldspmaterialsList ); 
                    tabName='Per Seat Products';
                    sizeofWrapper=totaldspmaterialsList.size();
                    obj.setPageSize = pageSize;
                    next();
                }
                
                //Added By Poonam Garg.
            }
            catch(Exception ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage()+ex.getLineNumber()));               
            }
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Invalid Quote/Proposal'));               
        }
        
        
    }
    
    /* -------------------------------------------------------------------------------

Method to perform all the Logics while loading the page/Constructor
--------------------------------------------------------------------------------*/
/**
     * @description mappingLogic
     */
    public void mappingLogic() {
        system.debug(LoggingLevel.WARN,'in Mapping Method...');        
        mocMap = new Map<string, List<Online_Contacts__c>>();
        cmocMap = New Map<string, Online_Contacts__c>();
        bandedMap = new Map<String, List<APLIWrapper>>();
        bpListtoDel = new Set<Online_Contacts__c>();
        psListtoDel = new Set<Online_Contacts__c>();
        odListtoDel = new Set<Online_Contacts__c>();        
        olDataESI = new OnlineContactsSerializeandDeserializeRes.OnlineContactResponse();
        //Added By Poonam Garg.DOC 11616
        chunkolDataESI=new List<OnlineContactsSerializeandDeserializeRes.OnlineContactResponse>(); 
        olNoteESI = new OnlineContactsSerializeandDeserializeRes.Notification();
        perSheetAPLIList = new List<APLIWrapper>();
        totalbandedList=new List<APLIWrapper>();
        totaldspmaterialsList=new List<APLIWrapper>();
        sizeOfWrapper=0;
        olContactsSize = 0;
        bandedMaterials = '';
        perSheetmaterials = '';
        odenmaterials = '';
        // dropdown
        perSeatProducts ='';
        psProductsList = new List<SelectOption>();
        dspMaterials  = new List<APLIWrapper>();
        odenProducts ='';
        odProductsList = new List<SelectOption>();
        oddspMaterials  = new List<APLIWrapper>();
        rsMaterialsMap = new Map<String, List<APLIWrapper>>();
        materialsMap = new Map<String, List<APLIWrapper>>();
        maxBandedProdQnt = null;
        bandedProducts = new List<string>();
        lineStatus = new List<string>();
        psCountMap = new Map<string, Apttus_Proposal__Proposal_Line_Item__c>();
        odCountMap = new Map<string, Apttus_Proposal__Proposal_Line_Item__c>();
        psMaterial   = new PSMaterials();
        isExCon = True;
        isExCon = True; 
        isLiveNoteBandedProduct = False;  
        perseatsize = false;        
        decimal pricedAttorney = 0.0; //LTS-6469   
            //apliList = [Select Id, Name, APTS_Program_ID__c, APTS_Product_Name_Override__c, APTS_Service_Number_Override__c, Apttus_QPConfig__LineType__c, APTS_Number_of_Attorneys__c, Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.Name, Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c, Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c, Apttus_Proposal__Product__r.Apttus_Config2__Uom__c, Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.APTS_Cat_L5__c, Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.Name From Apttus_Proposal__Proposal_Line_Item__c Where (Apttus_Proposal__Proposal__c = :proposalId AND Apttus_QPConfig__LineStatus__c != 'Amended' AND Apttus_QPConfig__LineStatus__c != 'Cancelled' AND Apttus_QPConfig__LineStatus__c != 'Renewed')  Order By Apttus_Proposal__Product__r.ProductCode ASC Nulls Last];
            // call the method to get the online contacts from Missoa
        System.debug(LoggingLevel.WARN,'KS--> location '+location);
        if(!string.isEmpty(location)) {
            //quoteAcc = location;
            quoteSsd = location;
            if(locationMap.get(location).APTS_Quote_Proposal__r.Apttus_Proposal__Opportunity__r.Active_Trial__c==true && !string.isEmpty(locationMap.get(location).APTS_Subscriber_Location_SSD__r.OLC_Account_Number__c)){//doc-15793
                sapNo = locationMap.get(location).APTS_Subscriber_Location_SSD__r.OLC_Account_Number__c;}
            else{
                sapNo = locationMap.get(location).APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c;} //doc-15793
            
            if(locationMap.get(location).APTS_Status__c == 'New') {
                lineStatus.add('New');
                lineStatus.add('Amended');
            }
            else{
                lineStatus.add('New');}     
        }
        else {
            quoteAcc = aptProposal.Apttus_Proposal__Account__c;
            //Added by Priyanka 09/21
            quoteSsd = aptProposal.APTS_SSD_Sold_To__c;
            if(aptProposal.Apttus_Proposal__Opportunity__r.Active_Trial__c == true && !string.isEmpty(aptProposal.APTS_SSD_Sold_To__r.OLC_Account_Number__c)){//doc-15793
                sapNo = aptProposal.APTS_SSD_Sold_To__r.OLC_Account_Number__c;}
            else{
                sapNo = aptProposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c;}//doc-15793
            lineStatus.add('New');          
        }
        System.debug(LoggingLevel.WARN,'location'+locationMap);
        System.debug(LoggingLevel.WARN,location);
        System.debug(LoggingLevel.WARN,locationlist);
        System.debug(LoggingLevel.WARN,sapNo);
        chunkOlDataESI=fetchAccountOnlinePasswords(sapNo);
        system.debug(LoggingLevel.WARN,'chunkOlDataESI'+chunkOlDataESI.size());
        // find the OLC data size nad some time we are getting blank response which giving size as 1 so to avoid that checking the contactid and count the size.
        if(!chunkOlDataESI.isEmpty()){
            for(OnlineContactsSerializeandDeserializeRes.OnlineContactResponse olcData : chunkOlDataESI){
                //system.debug('olcData ..'+olcData);
                olDataESI=olcData;
                if(olDataESI != null && olDataESI.onlineContact!= null && !olDataESI.onlineContact.isEmpty()){
                for(OnlineContactsSerializeandDeserializeRes.onlineContact oContacts :olDataESI.onlineContact) { 
                    //system.debug('oContacts ..'+oContacts );
                    if(!string.isEmpty(oContacts.contactNumber) && validateActiveOLC(oContacts.entitlements) 
                       && (oContacts.onlineContactType != '0997' && oContacts.onlineContactType != '0998' 
                           && oContacts.onlineContactType != '0999')) {
                               olContactsSize += 1;
                           }
                }
            }
            }  
        }
        system.debug(LoggingLevel.WARN,'olContactsSize...'+olContactsSize);
        // get the records from Online Contacts Object to display in Page. These are user added Contacts and assign contacts to Maps baesd on ContactId is empty or not
        //query edited by Priyanka 09/21
        for(Online_Contacts__c onl : [Select Id, APTS_Source_System_Detail__c ,Name, Material__c, ContactID__c,Account__c, 
                                      Is_Banded_Product__c,First_Name__c, Middle_Name__c, Last_Name__c, Email__c, Position__c, Type__c,Sftwr_Admin__c, WLEc_Juris__c,NAIC_Name__c,NAIC_Number__c 
                                      From Online_Contacts__c 
                                      Where APTS_Source_System_Detail__c =: quoteSsd AND QuoteId__c =: proposalId Order By Name]) {
                                          if(string.isEmpty(onl.ContactID__c)) {
                                              if(!mocMap.isEmpty() && mocMap.containsKey(onl.Material__c)) {
                                                  mocMap.get(onl.Material__c).add(onl);    
                                              }
                                              else {
                                                  mocMap.put(onl.Material__c, new List<Online_Contacts__c> {onl});
                                              }
                                          }
                                          else {                
                                              cmocMap.put((onl.Material__c+onl.ContactID__c), onl);                
                                          }
                                          If(onl.Is_Banded_Product__c){ 
                                              bpListtoDel.add(onl);}
                                          else{
                                              if(onl.NAIC_Number__c != null){
                                                  odListtoDel.add(onl);}
                                              else{
                                                  psListtoDel.add(onl);} } 
                                          }        
        // dropdown assign null first
        psProductsList.add(new SelectOption('', '--None--'));
        odProductsList.add(new SelectOption('', '--None--'));   
        system.debug(LoggingLevel.WARN,'BPListtoDel'+bpListtoDel);
        system.debug(LoggingLevel.WARN,'PSListtoDel'+psListtoDel);
        //system.debug('apliList...'+apliList);
    //Added ICG in query for DOC-4018 - Sakshi - Lotus OC Canada
        for(Apttus_Proposal__Proposal_Line_Item__c aplis :[Select Id, Name, APTS_Program_ID__c, APTS_Product_Name_Override__c, 
                           APTS_Service_Number_Override__c, Apttus_QPConfig__LineType__c, Apttus_QPConfig__LineStatus__c, APTS_Number_of_Attorneys__c,
                           Net_Qty_Difference__c, Apttus_Proposal__Product__c, Apttus_Proposal__Product__r.Name, 
                           Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c,
                           Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c, Apttus_Proposal__Product__r.Apttus_Config2__Uom__c, 
                           Apttus_Proposal__Product__r.ProductCode, Apttus_Proposal__Product__r.APTS_Cat_L5__c, Apttus_Proposal__Proposal__c,
                           Apttus_Proposal__Proposal__r.Name,Apttus_QPConfig__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c,
                           Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c,APTPS_Quantity_Display__c,
                           Apttus_Proposal__Product__r.Product_Level_4__c,Apttus_Proposal__Product__r.APTS_Item_Category_Group__c  
                           From Apttus_Proposal__Proposal_Line_Item__c
                           Where (Apttus_Proposal__Proposal__c = :proposalId AND Apttus_QPConfig__LineStatus__c IN :lineStatus)  
                           Order By Apttus_Proposal__Product__r.ProductCode ASC Nulls Last]) {        
                                                               
                                                               //APLIWrapper aw = new APLIWrapper();           
                                                               // add Banded Products to Banded list // Added Priced Attorney and Product Model LTS-6469
                                                               if((!validateProductLLCode((aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c+aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c), System.Label.OCExcludedLowerLevelCodes)) && aplis.Apttus_Proposal__Product__r.APTS_Cat_L5__c != 'L5_L1445_FP') {
                                                                   //SOC-5488
                                                                   System.debug(LoggingLevel.WARN,'bandedhelper'+ aplis);
                                                                   if(aplis.Apttus_QPConfig__LineStatus__c != 'Amended' 
                                                                      && (validateProductLLCode(aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, System.Label.OCBandedLowerLevelCodes) ||                
                      (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'I9')||
                      (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'LW') ||
                      (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'K1') ||
                       (aplis.Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage) && aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06') || 
                      (aplis.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c =='BENEFITGRP'))) {
                                                                              //LTS-6469
                                                                              if(aplis.APTS_Program_ID__c != 'CPRO'  && aplis.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c !='BENEFITGRP') {                    
                                                                                  bandedApliIds.add(aplis.id);
                                                                                  bandedHelper(aplis.Apttus_Proposal__Product__r.ProductCode, aplis.APTS_Number_of_Attorneys__c, aplis.Apttus_Proposal__Product__r.Name);            
                                                                              }
                                                                              else If(aplis.APTS_Program_ID__c == 'CPRO' && aplis.Apttus_QPConfig__LineType__c == 'Product/Service' &&  aplis.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c !='BENEFITGRP') {
                                                                                  bandedApliIds.add(aplis.id);
                                                                                  bandedHelper(aplis.APTS_Service_Number_Override__c, aplis.APTS_Number_of_Attorneys__c, aplis.APTS_Product_Name_Override__c);            
                                                                              }
                                                                              //LTS-6469
                                                                              if (aplis.Apttus_Proposal__Product__r.APTS_Product_Pricing_Model__c =='BENEFITGRP' || (aplis.Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage) && aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06')){    
                                                                                    bandedApliIds.add(aplis.id);
                                                                                  if(aplis.Apttus_QPConfig__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c !=Null){
                                                                                      pricedAttorney = aplis.Apttus_QPConfig__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c*2 ;
                                                                                      bandedHelper(aplis.Apttus_Proposal__Product__r.ProductCode,pricedAttorney , aplis.Apttus_Proposal__Product__r.Name);  
                                                                                  }
                                                                              }
                                                                              
                                                                              if(aplis.Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c == '064') {
                                                                                  isBandedValidation = True;
                                                                              }  
                                                                              //Sreenu Changes SOC-3851
                                                                              if(liveNoteProduct(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c, aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c)){
                                                                                  isLiveNoteBandedProduct = True; }                 
                                                                          }
                                                                   // add per sheet Products to perSheet List
                                                                   //added condition of MHL 05 and MLL E2 to collect password for that product-Pathra
                                                                   else if((aplis.Apttus_QPConfig__LineStatus__c == 'New' 
                                                                            || (aplis.Net_Qty_Difference__c != null && aplis.Net_Qty_Difference__c > 0 && aplis.Apttus_QPConfig__LineStatus__c == 'Amended')) 
                                                                           && (validateProductLLCode(aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, System.Label.OCPerSeatLowerLevelCodes) 
                                                                               || (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21') 
                                                                               || (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'I9')
                                                                               ||(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '05' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'E2')
                                                                               //||(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'TX'))){
                                                                               ||(aplis.Apttus_Proposal__Product__r.APTS_Cat_L5__c== Label.APTS_GSCPW_RP_Product_Family))){
                                                                                   
                                                                                   if(aplis.APTS_Program_ID__c != 'CPRO') { 
                                                                                       perSeatHelper(aplis.Apttus_Proposal__Product__r.ProductCode, aplis.Apttus_Proposal__Product__r.Name, aplis);            
                                                                                   }
                                                                                   else If(aplis.APTS_Program_ID__c == 'CPRO' && aplis.Apttus_QPConfig__LineType__c == 'Product/Service') {                        
                                                                                       perSeatHelper(aplis.APTS_Service_Number_Override__c, aplis.APTS_Product_Name_Override__c, aplis);            
                                                                                   }
                                                                               }                                                                               
                                                                            if((aplis.Apttus_QPConfig__LineStatus__c == 'New' 
                                                                            || aplis.Apttus_QPConfig__LineStatus__c == 'Amended')
                                                                           && (validateProductLLCode(aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c, System.Label.OCOdenLowerLevelCodes) 
                                                                               || (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13'&& aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'NT') 
                                                                               || (aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'NW')
                                                                               ||(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'NX')
                                                                               ||(aplis.Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '05' && aplis.Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'NZ')))
                                                                                {
                                                                                   
                                                                                   if(aplis.APTS_Program_ID__c != 'CPRO') { 
                                                                                       odenHelper(aplis.Apttus_Proposal__Product__r.ProductCode, aplis.Apttus_Proposal__Product__r.Name, aplis);            
                                                                                   }
                                                                                   else If(aplis.APTS_Program_ID__c == 'CPRO' && aplis.Apttus_QPConfig__LineType__c == 'Product/Service') {                        
                                                                                       odenHelper(aplis.APTS_Service_Number_Override__c, aplis.APTS_Product_Name_Override__c, aplis);            
                                                                                   }
                                                                               }
                                                                   system.debug(LoggingLevel.WARN,'psProductsList...'+psProductsList);
                                                                   system.debug(LoggingLevel.WARN,'odProductsList...'+odProductsList);
                                                               }
                                                           }
        
        system.debug(LoggingLevel.WARN,'maxBandedProdQnt...'+maxBandedProdQnt);
        system.debug(LoggingLevel.WARN,'psCountMap...'+psCountMap);  
        system.debug(LoggingLevel.WARN,'odCountMap...'+odCountMap);  
        
        // then check for custom object records which are added newly 
        if(!string.isEmpty(perSheetmaterials) || !string.isEmpty(bandedMaterials) || !string.isEmpty(odenMaterials)) {            
            
            if(!mocMap.isEmpty()) {
                for(List<Online_Contacts__c> ocList :mocMap.values()) {
                    for(Online_Contacts__c olc :ocList){    
                        system.debug(LoggingLevel.WARN,'Online Contact...'+olc);
                        APLIWrapper aw = new APLIWrapper();
                        aw.onlineContact = olc;
                        aw.isNewContact = True;
                        aw.isSelected = True;                        
                        aw.strEmail=olc.email__c;
                        
                        if(olc.Is_Banded_Product__c != True && !string.isEmpty(perSheetmaterials) && perSheetmaterials.contains(olc.Material__c)) {
                            // psListtoDel.add(olc);                       
                            aw.materialNo = perSheetmaterials; 
                            system.debug(LoggingLevel.WARN,'aw...'+aw);
                            //  perSheetAPLIList.add(aw);                            
                            
                            aw.materialNo = olc.Material__c;
                            mappingMaterials(aw, False, False);
                            
                        }
                        
                        else If(!string.isEmpty(bandedMaterials) && olc.Is_Banded_Product__c == True ) {
                            // bpListtoDel.add(olc);
                            aw.MaterialNo = olc.Material__c;
                            mappingMaterials(aw, True, False);
                            // bandedAPLIList.add(aw);    
                        }
                        if(olc.Is_Banded_Product__c != True && !string.isEmpty(odenMaterials) && odenMaterials.contains(olc.Material__c)) {
                            aw.materialNo = odenMaterials; 
                            system.debug(LoggingLevel.WARN,'aw...'+aw);
                            aw.materialNo = olc.Material__c;
                            mappingMaterials(aw, False, True);
                            
                        }
                    }
                }
            }
            system.debug(LoggingLevel.WARN,'materialsMap..'+materialsMap);  
            system.debug(LoggingLevel.WARN,'rsMaterialsMap..'+rsMaterialsMap);  
            
        } 
        // add the max number of rows for Banded Product- maxBandedProdQnt
        Integer bSize = !string.isEmpty(bandedMaterials) ? bandedMaterials.split('\n').size() : 0;
        checkBandedSize = maxBandedProdQnt != null ? maxBandedProdQnt*bSize : 0;
        system.debug(LoggingLevel.WARN,'bSize...'+bSize);
        system.debug(LoggingLevel.WARN,'maxBandedProdQnt...'+maxBandedProdQnt);
        system.debug(LoggingLevel.WARN,'olContactsSize...'+olContactsSize);
        
        system.debug(LoggingLevel.WARN,'perSheetAPLIList...'+perSheetAPLIList);
        if(!bandedMap.isEmpty()) {
            for(string awKey :bandedMap.keyset()) {
                totalBandedList= bandedMap.get(awKey);
                break;    
            }     
        } 
        system.debug(LoggingLevel.WARN,'totalBandedList...'+totalBandedList);
        // added new code line to display empty contacts for Banded Products if Existing(SAP) Contact sare Empty
        if((olContactsSize == null || olContactsSize == 0) && maxBandedProdQnt != null) {
            integer bandedsize = !totalBandedList.isEmpty() ? totalBandedList.Size() : 0;                    
            for(Integer i = bandedsize+1; i <= bandedsize+10; i++) {
                if(totalBandedList.isempty()) { 
                    addOnlineContactsUtil();
                }
                else if(totalBandedList.size() < (Integer.valueof(maxBandedProdQnt)+(olContactsSize))){
                    addOnlineContactsUtil();}
            }
            //  isExCon = False;         
        }
        // If Banded Products are not available then isExCon is False;
        if(string.isEmpty(bandedMaterials)) {
            isExCon = False;    
        }
        if(!String.isEmpty(location) && !String.isEmpty(prevlocation)  && location!=prevlocation){
            obj = new APTS_CustomPaginationCtrl (totalbandedList);
            obj.setPageSize = pageSize;
            pagenum=0;
            next();
            System.debug(LoggingLevel.WARN,'Inside');
        }
        system.debug(LoggingLevel.WARN,'bandedAPLIList...'+totalBandedList);
        // Display the first material contacts in the per seat tab
        sortproductbyquantity();
        displayMaterialContacts();
        if(totaldspmaterialsList!=null && totaldspmaterialsList.size()>0){
            totalRecinAllBatchesPerSeat = totaldspmaterialsList.size();
            system.debug(LoggingLevel.WARN,totalRecinAllBatchesPerSeat);
        }
        system.debug(LoggingLevel.WARN,'no of Queries buc...'+Limits.getQueries());
        system.debug(LoggingLevel.WARN,'no of Queries buc...'+Limits.getLimitQueries());
        
    }
    
    /* -------------------------------------------------------------------------------    
Check the APTS_Media_Lower_Level_Code__c to find out the product is Banded or Per Seat.
--------------------------------------------------------------------------------*/    
/**
     * @description validateProductLLCode
     * @return validateProductLLCode
     * @param llCode
     * @param codes
     */
    
    public static Boolean validateProductLLCode(string llCode, string codes) {
        Boolean isValid = False;
        if(!string.isEmpty(llCode) && !string.isEmpty(codes)) {
            for(string str :codes.split(',')) {
                if(str == llCode) {
                    isValid = True;
                    break;
                }
            }
        }
        system.debug(LoggingLevel.WARN,'isValid...'+isValid);
        return isValid;
    }
    
    /* -------------------------------------------------------------------------------    
method to assign the Online contacts to Banded materials
--------------------------------------------------------------------------------*/ 
/**
     * @description bandedHelper
     * @param productCode
     * @param noa
     * @param pName
     */
    public void bandedHelper(string productCode, decimal noa, string pName) {
        if(string.isEmpty(bandedMaterials)) {
            bandedMaterials = productCode +'\n';
        }
        else {
            bandedMaterials += productCode+'\n';
        }   
        if(maxBandedProdQnt == null) {
            maxBandedProdQnt = noa;
        }
        else if(maxBandedProdQnt < noa) {
            maxBandedProdQnt = noa;
        } 
        bandedProducts.add(productCode + ' '+  pName);
        assignESIContacts(productCode, True);
        
    }
    /* -------------------------------------------------------------------------------    
method to assign perSeat material contacts
--------------------------------------------------------------------------------*/    
/**
     * @description perSeatHelper
     * @param productCode
     * @param productTitle
     * @param aplis
     */
    public void perSeatHelper(string productCode, string productTitle, Apttus_Proposal__Proposal_Line_Item__c aplis) {
        psCountMap.put(productCode, aplis);
        if(string.isEmpty(perSheetmaterials)) {
            perSheetmaterials = productCode +'\n';
        }
        else {
            perSheetmaterials += productCode+'\n';
        }  
        
        // dropdown
        if(!string.isEmpty(productCode) && !string.isEmpty(productTitle)){
            //psProductsList.add(new SelectOption(productCode, productTitle)); 
            productlist.add(productCode);           
        }
        // assign the value if dropdown list is blank for first time
        if(string.isEmpty(perSeatProducts)) {
            perSeatProducts = productCode;
            
        }
        // assign ESI contacts to per Sheet materials.
        assignESIContacts(productCode, False);
    }
    
    /* -------------------------------------------------------------------------------    
method to assign oden material contacts
--------------------------------------------------------------------------------*/   
/**
     * @description odenHelper
     * @param productCode
     * @param productTitle
     * @param aplis
     */ 
    public void odenHelper(string productCode, string productTitle, Apttus_Proposal__Proposal_Line_Item__c aplis) {
        system.debug(LoggingLevel.WARN,'Inside Oden Helper');
        odCountMap.put(productCode, aplis);
        if(string.isEmpty(odenmaterials)) {
            odenmaterials = productCode +'\n';
        }
        else {
            odenmaterials += productCode+'\n';
        }  
        
        // dropdown
        if(!string.isEmpty(productCode) && !string.isEmpty(productTitle)){
            odProductsList.add(new SelectOption(productCode, productTitle)); }
            system.debug(LoggingLevel.WARN,'ODList = '+odProductsList);
        // assign the value if dropdown list is blank for first time
        if(string.isEmpty(odenProducts)) {
            odenProducts = productCode;
            
        }
        // assign ESI contacts to per Sheet materials.
       // assignESIContacts(productCode, False);
    }
    
    /* -------------------------------------------------------------------------------    
validate the olc system(SAP) contacts Status 
--------------------------------------------------------------------------------*/
/**
     * @description validateActiveOLC
     * @return validateActiveOLC
     * @param entitles
     */
    public static boolean validateActiveOLC(List<OnlineContactsSerializeandDeserializeRes.entitlements> entitles) {
        Boolean isActive = False;
        for(OnlineContactsSerializeandDeserializeRes.entitlements entl :entitles) {
            if(entl.status == 'ACTIVE') {
                isActive = True;
                break;    
            }
        }
        return isActive;    
    }
    
    /* -------------------------------------------------------------------------------    
map the Missoa Online Contacts to each material
--------------------------------------------------------------------------------*/
/**
     * @description assignESIContacts
     * @param material
     * @param isBanded
     */
    public void assignESIContacts(string material, Boolean isBanded) {
        system.debug(LoggingLevel.WARN,'material...'+material);
        //Onclick of Page 9 Set Previous batch to the chunk
         System.debug(LoggingLevel.WARN,chunkOlDataESI.size());
         if(!chunkOlDataESI.isEmpty()){
            for(OnlineContactsSerializeandDeserializeRes.OnlineContactResponse olcData : chunkOlDataESI){
                olDataESI=olcData;
                if(olDataESI != null && olDataESI.onlineContact!= null && !olDataESI.onlineContact.isEmpty()){
                for(OnlineContactsSerializeandDeserializeRes.onlineContact oContacts :olDataESI.onlineContact) {            
                //system.debug('oContacts...'+oContacts); //&& !string.isEmpty(oContacts.email)
                if(!string.isEmpty(oContacts.contactNumber) && validateActiveOLC(oContacts.entitlements) && (oContacts.onlineContactType != '0997' && oContacts.onlineContactType != '0998' && oContacts.onlineContactType != '0999')) {
                    Boolean isNoMatch = True;
                    APLIWrapper aw = new APLIWrapper();
                    if(!cmocMap.isEmpty()) {
                        // loop the online contact list and check with missoa contact, if user select the contact
                        // if yes, check the isSelected checkbox else add the contact to map
                        
                        aw = new APLIWrapper();
                        
                        if(cmocMap.containsKey((material+oContacts.contactNumber)) && !cmocMap.get((material+oContacts.contactNumber)).Is_Banded_Product__c) {
                            // psListtoDel.add(cmocMap.get((material+oContacts.contactNumber)));
                            isNoMatch = False;                                
                            // method to assign the materials based on per Seat type
                            mappingMaterials(assignESISelectedContactsUtil(oContacts, material, cmocMap.get((material+oContacts.contactNumber))), False, False);
                            //  system.debug('per seat selected Contacts from Missoa..'+material+'-'+olc.ContactID__c);
                        }
                        else {
                            if(cmocMap.containsKey((material+oContacts.contactNumber)) && cmocMap.get((material+oContacts.contactNumber)).Is_Banded_Product__c && isBanded) {
                                //system.debug('Banded selected Contacts from Missoa..'+material+'-'+olc.ContactID__c);
                                // bpListtoDel.add(cmocMap.get((material+oContacts.contactId)));
                                isNoMatch = False;                                    
                                // method to assign the materials based on Banded type
                                mappingMaterials(assignESISelectedContactsUtil(oContacts, material, cmocMap.get((material+oContacts.contactNumber))), True, False);
                                //  system.debug('Banded selected Contacts from Missoa..'+material+'-'+olc.ContactID__c);
                            }                            
                            
                        }
                        if(isNoMatch == True) {
                            mappingMaterials(assignESIContactsUtil(oContacts, material), isBanded, False);                        
                        }  
                    }
                    // if Online contact list is empty, then add the missoa contacts to map.
                    else {                    
                        mappingMaterials(assignESIContactsUtil(oContacts, material), isBanded, False);
                    }               
                    
                }   
            }
            }
            }   
        }
        
    }
    /* -------------------------------------------------------------------------------    
Util method to assign the values from the Esi response if contact match found in Online Contacts object.
--------------------------------------------------------------------------------*/ 
/**
     * @description assignESISelectedContactsUtil
     * @return assignESISelectedContactsUtil
     * @param oContacts
     * @param material
     * @param olc
     */   
    public APLIWrapper assignESISelectedContactsUtil(OnlineContactsSerializeandDeserializeRes.onlineContact oContacts, string material, Online_Contacts__c olc) {
        APLIWrapper aw = new APLIWrapper();
        aw.isSelected = True;
        aw.onlineContact = olc;
        // map the first name and last name and email from missoa response
        aw.onlineContact.First_Name__c = oContacts.Address.firstName;
        aw.onlineContact.Last_Name__c = oContacts.Address.lastName;
        //aw.onlineContact.Email__c = oContacts.email;
        aw.materialNo = material;
        aw.source = oContacts.sourceId;
        aw.strEmail= olc.email__c;
        return aw;
    }
    /* -------------------------------------------------------------------------------    
Util method to assign the values from the Esi response if contact match not found in Online Contacts object.
--------------------------------------------------------------------------------*/  
/**
     * @description assignESIContactsUtil
     * @return assignESIContactsUtil
     * @param oContacts
     * @param material
     */  
    public APLIWrapper assignESIContactsUtil(OnlineContactsSerializeandDeserializeRes.onlineContact oContacts, string material) {
        APLIWrapper aw = new APLIWrapper();
        aw.onlineContact.Account__c = quoteAcc; //aptProposal.Apttus_Proposal__Account__c;
        //Added by priyanka 09/21
        aw.onlineContact.APTS_Source_System_Detail__c =quoteSsd;
        aw.onlineContact.QuoteId__c = proposalId;
        aw.onlineContact.Material__c = material;
        aw.onlineContact.ContactID__c = oContacts.contactNumber;                                      
        aw.onlineContact.First_Name__c = oContacts.address.firstName;
        aw.onlineContact.Last_Name__c = oContacts.address.LastName;
        aw.strEmail=oContacts.address.emailAddress;
        aw.onlineContact.Position__c = oContacts.onlineContactTypeDescription;                  
        aw.materialNo = material; 
        aw.source = oContacts.sourceId;
        system.debug(LoggingLevel.WARN,'aw...'+aw);
        
        return aw;
    }
    /* -------------------------------------------------------------------------------    
util method for assigning the materials based on Banded or Per Sheet
--------------------------------------------------------------------------------*/    
/**
     * @description mappingMaterials
     * @param aw
     * @param isBandedM
     * @param isOdenM
     */
    public void mappingMaterials(APLIWrapper aw, Boolean isBandedM, Boolean isOdenM) {
        system.debug(LoggingLevel.WARN,'map Materials method..');
        if(isBandedM == False && isOdenM == False) {
            if(materialsMap.containsKey(aw.materialNo)) {
                materialsMap.get(aw.materialNo).add(aw);
            }
            else {
                materialsMap.put(aw.materialNo, new List <APLIWrapper> {aw});
            }
        }
        if(isBandedM == True) {
            
            if(bandedMap.containsKey(aw.materialNo)) {
                bandedMap.get(aw.materialNo).add(aw);
            }
            else {
                bandedMap.put(aw.materialNo, new List <APLIWrapper> {aw});
            }   
            
        }
        if(isOdenM == True) {
            if(rsmaterialsMap.containsKey(aw.materialNo)) {
                rsmaterialsMap.get(aw.materialNo).add(aw);
            }
            else {
                rsmaterialsMap.put(aw.materialNo, new List <APLIWrapper> {aw});
            }
        }
        
        
    }
    /* -------------------------------------------------------------------------------    
get the Online Contacts from ESI-MISSOA
--------------------------------------------------------------------------------*/    
       
       /**
     * @description fetchAccountOnlinePasswords
     * @return fetchAccountOnlinePasswords
     * @param sapNum
     */
    public list<OnlineContactsSerializeandDeserializeRes.OnlineContactResponse> fetchAccountOnlinePasswords(string sapNum){
        try{
            //Added By Poonam Garg DOC 11616
            chunkOlDataESI=new List<OnlineContactsSerializeandDeserializeRes.OnlineContactResponse>();
            Integer counter=0;
            Integer noOfRecordsInCurrentCall=0;
            Integer setBatchsize=900;
            // Adding the remaining records to new wrapper.
            
            System.debug(LoggingLevel.WARN,'checkRecInNextChunk.. '+checkRecInNextChunk );
            System.debug(LoggingLevel.WARN,'pageNum' +pageNum);
            // get the Callout parameters from Custom Setting
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('OnlineContacts');  
            system.debug(LoggingLevel.WARN,'oWebServiceSettings...'+oWebServiceSettings);
            checkRecInNextChunk ='true'; 
            OnlineContactsSerializeandDeserializeReq.OnlineContactsRequest smpReq = new OnlineContactsSerializeandDeserializeReq.OnlineContactsRequest(); 
            smpReq.ESIHeader.applicationId  = KeyValueListStore__c.getInstance('OrderCaptureProductId').TextValue__c;
            smpReq.Account.accountNumber = sapNum; //'1004620772';
            Integer totalloc=locationList.size();
            //Added By Poonam Garg DOC 11616
            while(checkRecInNextChunk == 'true' ){ //&& counter < setBatchsize && setPageNums.contains(pageNum)
                if((counter==0 && totalloc<=1 ) || (counter==0 && totalloc>1 && !String.isEmpty(location ) && location !=prevLocation)){
                    smpReq.beginIndex=0;
                }
                else{
                    smpReq.beginIndex=index + setBatchsize ;
                    index =smpReq.beginIndex; // To set begin Index after every esi call to maintain the state.
                }
                System.debug(LoggingLevel.WARN,smpReq.beginIndex);
                String strBody = JSON.serialize(smpReq);
                system.debug(LoggingLevel.WARN,'strBody...'+strBody);
                HttpResponse resp = new HttpResponse();
                HttpRequest req = new HttpRequest();
                Http http = new Http();
                req.setMethod('POST');
                //String url = 'https://esi-dev.thomsonreuters.com/osb/GetOnlineContacts_InboundService/PS_GOCByAccount_InboundService_REST';
                req.setEndpoint(oWebServiceSettings.Endpoint__c);
                //blob  headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
                //String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
                String authorizationHeader = 'Basic ZXNpZGV2dXNlcjplc2lkZXZ1c2VyMTIz';
                req.setHeader('Authorization', authorizationHeader);            
                req.setHeader('Content-Type',  'application/json'); 
                
                req.setBody(strBody);
                req.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
                system.debug(LoggingLevel.WARN,'request--->'+req);
                if(!Test.isRunningTest()) {
                    resp = http.send(req);
                    countEsiCalls= countEsiCalls+1;
                    System.debug(LoggingLevel.WARN,'countEsiCalls'+countEsiCalls);
                }
                else {
                    resp.setStatusCode(200);
                    resp.setBody('{"onlineContact":[{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744803f0000015d6316e227720851f7","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744d7790000015d6316df57a30250ab","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"lastName":"Deadline Calculator Firm Alert User"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016216427","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0998"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2018-06-20","appUserGuid":"ia744d779000001641e8501e0fa903680","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-06-20","appUserGuid":"ia744803f000001641e84f98a679d377c","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-06-20","appUserGuid":"ia744d779000001641e84f5da216369b1","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Bethany","lastName":"Matherne","emailAddress":"bethany@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0017212835","onlineContactTypeDescription":"Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0100"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-07-19","appUserGuid":"ia744803f0000015d5c75858722440307","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-19","appUserGuid":"ia744d7790000015d5c75878ff3ab5bcf","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-19","appUserGuid":"ia744d7790000015d5c758824e158b1f8","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Glenda","lastName":"Mitchell","emailAddress":"glenda@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016213069","onlineContactTypeDescription":"Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0100"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744803f0000015d60b9d4a94ff26db8","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744803f0000015d60b9cfd99b7cf3c4","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744803d0000015d60b9cdd2a0d1570d","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Aaron","lastName":"Mitchell","emailAddress":"aaron@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016215036","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-08-11","appUserGuid":"ia744803f0000015dd1f2d088b19bd572","accessEndDate":"2017-08-14","applicationId":"COBALT","status":"INACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-08-11","appUserGuid":"ia744803d0000015dd1f2cd56a918ccdb","accessEndDate":"2017-08-14","applicationId":"DATAROOM","status":"INACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-08-11","appUserGuid":"ia744d7790000015dd1f2cb6b7eb3bbfb","accessEndDate":"2017-08-14","applicationId":"SLW","status":"INACTIVE"}],"address":{"firstName":"Assistant","lastName":"Mitchell","emailAddress":"glendamitchelllawfirm@gmail.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016266393","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-11-15","appUserGuid":"ia744803f0000015fbc32dfb044cec15e","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-08-15","appUserGuid":"ia744803f0000015de2d75c466bdbcb58","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-08-15","appUserGuid":"ia744803f0000015de2d759df6bdbcb56","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Assistant","lastName":"Mitchell","emailAddress":"glendamitchelllawfirm@gmail.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016271394","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-11-15","appUserGuid":"ia744803f0000015fc048b5aee1f59661","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-11-15","appUserGuid":"ia744803f0000015fc048b12b90e67d96","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-11-15","appUserGuid":"ia744803f0000015fc048aee491858360","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Amina","lastName":"Mohammed","emailAddress":"amina@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016549291","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744d7790000015d60b9dc44f3ab5c83","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744d7790000015d60b9d98578c5ce3d","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2017-07-20","appUserGuid":"ia744d7790000015d60b9d85f126cad01","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Corrie","lastName":"Schott","emailAddress":"corrie@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016215037","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2018-06-21","appUserGuid":"ia744803f0000016422594f32ec9b7270","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-06-20","appUserGuid":"ia744803f000001641e850e9eba57f0d2","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-06-20","appUserGuid":"ia744d779000001641e850c3b216369b3","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"Savannah","lastName":"Welch","emailAddress":"savannah@glendamitchelllawfirm.com"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0017212837","onlineContactTypeDescription":"Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0100"},{"sourceId":"SAP","entitlements":[{"statusReason":"SAP","accessStartDate":"2018-02-20","appUserGuid":"ia744d77900000161ae304bd7500cb2ce","accessEndDate":"9999-12-31","applicationId":"COBALT","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-02-19","appUserGuid":"ia744d77900000161ae304dd623bb52a1","accessEndDate":"9999-12-31","applicationId":"DATAROOM","status":"ACTIVE"},{"statusReason":"SAP","accessStartDate":"2018-02-20","appUserGuid":"ia744d77900000161ae304eb0944f001d","accessEndDate":"9999-12-31","applicationId":"SLW","status":"ACTIVE"}],"address":{"firstName":"BENJAMIN","lastName":"YASKO","emailAddress":"BEN@GLENDAMITCHELLLAWFIRM.COM"},"endDate":"9999-12-31T00:00:00.000-06:00","contactNumber":"0016762721","onlineContactTypeDescription":"Non-Attorney","allowContactEmails":false,"account":{"companyId":"WEST","accountNumber":"1004986501"},"onlineContactType":"0090"}],"ESIHeader":{"applicationId":"SF04"}}');
                }
                string strRes = resp.getBody();
                system.debug(LoggingLevel.WARN,'strRes..'+strRes);
                system.debug(LoggingLevel.WARN,'strRes..'+resp.getStatusCode());
                if(resp.getStatusCode() == 200 ) {
                    if(!resp.getBody().contains('"onlineContacts" : [ null ]')){ // added this to overcome of deserilize error
                        if(!strRes.contains('Notification')){
                           olDataESI = (OnlineContactsSerializeandDeserializeRes.OnlineContactResponse)JSON.deserialize(resp.getbody(), OnlineContactsSerializeandDeserializeRes.OnlineContactResponse.class);
                           system.debug(LoggingLevel.WARN,'olDataESI...'+olDataESI);
                            
                        }
                        else {
                            olNoteESI = (OnlineContactsSerializeandDeserializeRes.Notification)JSON.deserialize(resp.getbody(), OnlineContactsSerializeandDeserializeRes.Notification.class);
                            system.debug(LoggingLevel.WARN,'olNoteESI..'+olNoteESI);
                        }
                    }
                }
                else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error occured while fetching the Online Contacts from MISSOA'));
                }
                 if(olDataESI !=null && olDataESI.onlineContact!=null){
                    chunkOlDataESI.add(olDataESI );
                    System.debug(LoggingLevel.WARN,'size of chunkoldate' +chunkOlDataESI.size());
                    noOfRecordsInCurrentCall=getCountOfRecords(olDataESI);
                    counter=counter + noOfRecordsInCurrentCall;
                 }
                 //List<OnlineContactsSerializeandDeserializeRes.OnlineContactResponse> tempLs=new List<OnlineContactsSerializeandDeserializeRes.OnlineContactResponse>();
                 //List<OnlineContactsSerializeandDeserializeRes.onlineContact > addContactsToBatchSize=new List<OnlineContactsSerializeandDeserializeRes.onlineContact >();
                 System.debug(LoggingLevel.WARN,'counter' + counter);
                 checkRecInNextChunk=olDataESI.moreResults;
                 System.debug(LoggingLevel.WARN,'checkRecInNextChunk' +checkRecInNextChunk);
            }
            if(olNoteESI != null && !string.isEmpty(olNoteESI.StatusCode) && !string.isEmpty(olNoteESI.StatusDescription)) {
                system.debug(LoggingLevel.WARN,'note...');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,olNoteESI.StatusCode +'-'+olNoteESI.StatusDescription));
            }
        System.debug(LoggingLevel.WARN,'count esi calls'+ countEsiCalls);
        } 
        catch(Exception oException){
            ApexPages.addMessages(oException);
        }
        system.debug(LoggingLevel.WARN,chunkOlDataESI);
        return chunkOlDataESI; 
    } 
    private Integer getCountOfRecords(OnlineContactsSerializeandDeserializeRes.OnlineContactResponse olDataESI){
        Integer count=0;
        for(OnlineContactsSerializeandDeserializeRes.onlineContact oContacts : olDataESI.onlineContact) { 
            count++;
            }
        System.debug(LoggingLevel.WARN,'count of rec'+count);    
        return count;    
    }
    /* -------------------------------------------------------------------------------    
Page load Action method - to Identify the Banded Products from the Proposal Line items and Online Contacts Objects.
If Banded Line item is not avilable and Online contacts are available, delete the Online Contacts.
--------------------------------------------------------------------------------*/    
/**
     * @description validateBandedMaterials
     * @return validateBandedMaterials
     */
    Public PageReference validateBandedMaterials() {
        system.debug(LoggingLevel.WARN,'bandedMaterials...'+bandedMaterials);        
        if(string.isEmpty(bandedMaterials)) {
            List<Online_Contacts__c> ocBandedList = new List<Online_Contacts__c>();
            //Edited query by priyanka 09/21
            if(Schema.sObjectType.Online_Contacts__c.isAccessible() && Schema.sObjectType.Online_Contacts__c.isQueryable()){
            ocBandedList = [Select Id,APTS_Source_System_Detail__c , Name, Material__c, ContactID__c, Is_Banded_Product__c, Account__c, First_Name__c, Middle_Name__c, Last_Name__c, Email__c, Position__c, Type__c, Sftwr_Admin__c, WLEc_Juris__c From Online_Contacts__c Where (APTS_Source_System_Detail__c =: quoteSsd AND QuoteId__c =: proposalId AND Is_Banded_Product__c = True)];}
            system.debug(LoggingLevel.WARN,'ocBandedList...'+ocBandedList);
            if(!ocBandedList.isEmpty() && Schema.sObjectType.Online_Contacts__c.isdeleTable()) {
                delete ocBandedList;
            }
        }        
        return null;
    }
    /**
     * @description getbpSelected
     * @return getbpSelected
     */
    public PageReference getbpSelected()
    {
        selectedAPLIs.clear();
        for(APLIWrapper accwrapper : totalbandedList) {
            if(accwrapper.isSelected != true){ 
                isBandedSelectAll = False;}
            else{ 
                selectedAPLIs.add(accwrapper);}    
        }
        system.debug(LoggingLevel.WARN,'selectedAPLIs...'+selectedAPLIs);
        system.debug(LoggingLevel.WARN,'maxBandedProdQnt..'+maxBandedProdQnt);
        return null;
    }
    /**
     * @description getbpSelected
     * @return getbpSelected
     */
    public PageReference getpspSelected()
    {
        for(APLIWrapper accwrapper : perSheetAPLIList) {
            if(accwrapper.isSelected != true){ 
                isPerSheetSelectAll = False;}
        }
        return null;
    }
    /**
     * @description getbpSelected
     * @return getbpSelected
     */
    public PageReference getBandedSelected()
    {
        selectedAPLIs.clear();
        if(isBandedSelectAll != True) {
            for(APLIWrapper accwrapper : totalbandedList) {               
                accwrapper.isSelected = False;
            }
        }
        
        if(isBandedSelectAll == True) {
            for(APLIWrapper accwrapper : totalbandedList) {
                accwrapper.isSelected = true;
                selectedAPLIs.add(accwrapper);
            }    
        }
        system.debug(LoggingLevel.WARN,'bandedAPLIList...'+totalbandedList);
        return null;
    }
    
    // Add Banded Online Contacts
    /**
     * @description addOnlineContacts
     
     */
    public void addOnlineContacts() {       
        Integer pageNumnew=0;
        Integer addRec=0;
        //List<APLIWrapper> addContactsWrap =new List<APLIWrapper>();
        system.debug(LoggingLevel.WARN,'Banded list size...'+totalbandedList.size());
        system.debug(LoggingLevel.WARN,'bandedMaterials'+bandedMaterials);
        system.debug(LoggingLevel.WARN,'maxBandedProdQnt...'+maxBandedProdQnt);
        If(!string.isEmpty(bandedMaterials) && totalbandedList.size() < (maxBandedProdQnt+olContactsSize)) {
            integer bmSize = totalbandedList.size();
            for(Integer i = bmSize+1; i <= bmSize+10; i++) {
                If(totalbandedList.size() < (Integer.valueof(maxBandedProdQnt)+(olContactsSize))){
                    addOnlineContactsUtil();
                    addRec=addRec+1;
                }
                /*if(i == 1000)
                    break;*/
            }   
        //pageNumnew=bmSize /pageSize;  //1241/100=12  1299
        obj = new APTS_CustomPaginationCtrl (totalBandedList);
        //pageNum=pageNumnew  + 1;
        lstbandedSetController=obj.addOnlineContacts(addRec);
        sizeOfWrapper=totalBandedList.size();
        pageNumnew=sizeOfWrapper/pageSize;
        if(math.mod(sizeOfWrapper, pageSize) > 0){
            pageNum=pageNumnew  + 1;
        }else{
            pageNum=pageNumnew;
        }
        
        }
        system.debug(LoggingLevel.WARN,'Banded list size...'+totalbandedList.size());
        
    }
    // Util method for assign the values to Banded Product List
    /**
     * @description addOnlineContactsUtil
     */
    public void addOnlineContactsUtil() {
        APLIWrapper aw = new APLIWrapper();            
        if(!string.isEmpty(bandedMaterials)) {
            // for(string mater :bandedMaterials.split('\n')) {
            aw.onlineContact.Account__c = quoteAcc; //aptProposal.Apttus_Proposal__Account__c;
            //Added by Priyanka 9/21
            aw.onlineContact.APTS_Source_System_Detail__c =quoteSsd;
            aw.onlineContact.QuoteId__c = proposalId;
            aw.MaterialNo = bandedMaterials;
            aw.isNewContact = True;
            totalbandedList.add(aw);
        }   
    }
    // add perSheet Online Contacts   
    /**
     * @description addPSOnlineContactsPS
     */ 
    
    public void addPSOnlineContactsPS() {
        
        if(!string.isEmpty(perSheetMaterials)) {
            
            APLIWrapper aw = new APLIWrapper();
            aw.onlineContact.Account__c = quoteAcc; //aptProposal.Apttus_Proposal__Account__c;
            //Added by Priyanka 9/21
            aw.onlineContact.APTS_Source_System_Detail__c =quoteSsd;
            aw.onlineContact.QuoteId__c = proposalId;
            aw.materialNo = perSeatProducts;           
            aw.isNewContact = True;
            
            if(!string.isEmpty(perSeatProducts)){
                totaldspmaterialsList.add(aw);}                       
        }      
    }
    //DOC-11572 start 
    /**
     * @description addODOnlineContactsOD
     */
    public void addODOnlineContactsOD() {
        
        if(!string.isEmpty(odenMaterials)) {
            
            APLIWrapper aw = new APLIWrapper();
            aw.onlineContact.Account__c = quoteAcc; //aptProposal.Apttus_Proposal__Account__c;
            aw.onlineContact.APTS_Source_System_Detail__c =quoteSsd;
            aw.onlineContact.QuoteId__c = proposalId;
            aw.materialNo = odenProducts;           
            aw.isNewContact = True;
            aw.isSelected = True;
            aw.evnetIdToAdd = True;
            
            if(!string.isEmpty(odenProducts)){
                oddspMaterials.add(aw);}                       
        }      
    }
    //End
    
    // add 10 Rows on click for legal Hold and Retail Window Products and max - 999
    /**
     * @description addPSContacts
     */
    public void addPSContacts() {
        Integer addrec=0;
        Integer pageNumnew=0;
        //List<APLIWrapper> addContactsWrap =new List<APLIWrapper>();  
        Integer size = totaldspmaterialsList.size();
        Integer maxNOPH =0;
        Integer maxNOPHGPP = 0;   
        
        //Start: GLP-200
        Integer intGPP = 0;
        Boolean blnIsGPP = False;
        //Added as part of DOC-15790 to restrict the Number of allowed password holders to 10000 irrespective of the Quantity entered on the Cart.
         maxNOPH = (totaldspmaterialsList.size()+10) > 10000 ? 10000: (totaldspmaterialsList.size()+10);
        if (!psCountMap.isEmpty() && psCountMap.ContainsKey(perSeatProducts) && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21'
            &&  psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'CQ'
             && psCountMap.get(perSeatProducts).APTPS_Quantity_Display__c != null) {
            System.debug(LoggingLevel.WARN,'Inside addNAPSContact');        
            //Integer startNum=0;
            intGPP = Integer.valueof(psCountMap.get(perSeatProducts).APTPS_Quantity_Display__c);
            blnIsGPP = True;
            maxNOPHGPP = (Integer.valueof(intGPP)+olContactsSize) > 10000 ? 10000 : (Integer.valueof(intGPP)+olContactsSize);
            System.debug(LoggingLevel.WARN,'Inside addNAPSContact'+'maxNOPHGPP ='+maxNOPHGPP); 
             
        } 
        System.debug(LoggingLevel.WARN,totaldspmaterialsList.size()+'maxNOPH = '+maxNOPH);
        System.debug(LoggingLevel.WARN,intGPP  +' -->'+blnIsGPP);
        if(blnIsGPP) {
            system.debug(LoggingLevel.WARN,'psCountMap.get(perSeatProducts)..'+psCountMap.get(perSeatProducts));
            for(Integer i = totaldspmaterialsList.size()+1; i <= maxNOPHGPP; i++) {
                //if(dspMaterials.size() < 999)
                    addPSOnlineContactsPS();
                    addRec=addRec+1;
            }
            isExPSCon = False;
            system.debug(LoggingLevel.WARN,'In If'+' -->'+blnIsGPP);
        }  else {
           system.debug(LoggingLevel.WARN,'in else -->'+blnIsGPP);
           for(Integer i = size+1; i <= maxNOPH; i++) {
                addPSOnlineContactsPS();
                addrec=addrec+1;
            }
            System.debug(LoggingLevel.WARN,totaldspmaterialsList.size());  
        }
        
        obj = new APTS_CustomPaginationCtrl (totaldspmaterialsList);
        lstperSeatController =obj.addOnlineContacts(addRec);
        System.debug(LoggingLevel.WARN,totaldspmaterialsList.size());
        sizeOfWrapper=totaldspmaterialsList.size();
        
        if (blnIsGPP) {
            pageNumnew=(sizeOfWrapper - addrec)/pageSize;  //1774-999=775 /100
        } else {
            pageNumnew=sizeOfWrapper/pageSize;
        }
        if(math.mod(sizeOfWrapper, pageSize) > 0){
            pageNum=pageNumnew  + 1;
        }else{
            pageNum=pageNumnew;
        }
        System.debug(LoggingLevel.WARN,totaldspmaterialsList.size());
         //End-GLP -200
                
    } 
    
    // Add rows based on the No of Attorneys for Persheet Materials
    /**
     * @description addNAPSContact
     */
    public void addNAPSContact() {
        System.debug(LoggingLevel.WARN,'Inside addNAPSContact');        
        Integer pageNumnew=0;
        //Integer startNum=0;
        //List<APLIWrapper> addContactsWrap =new List<APLIWrapper>();     
        Integer addRec=0;
        Integer maxNOP = 0;
        //integer size = totaldspmaterialsList.size();        
        System.debug(LoggingLevel.WARN,totaldspmaterialsList.size());
        if(!psCountMap.isEmpty() && psCountMap.ContainsKey(perSeatProducts) && psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c!= null) {
            //Added as part of DOC-15790 to restrict the Number of allowed password holders to 10000 irrespective of the Quantity entered on the Cart.
            maxNOP = (Integer.valueof(psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c)+olContactsSize) > 10000 ? 10000 : (Integer.valueof(psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c)+olContactsSize);
            system.debug(LoggingLevel.WARN,'psCountMap.get(perSeatProducts)..'+psCountMap.get(perSeatProducts)+'maxNOP = '+maxNOP);
            for(Integer i = totaldspmaterialsList.size()+1; i <= maxNOP; i++) {
                //if(dspMaterials.size() < 999)
                    addPSOnlineContactsPS();
                    addRec=addRec+1;
            }
            isExPSCon = False;
            //pageNumnew=size /pageSize;  //1241/100=12  1299
            //System.debug(pageNumnew + 1);
            obj = new APTS_CustomPaginationCtrl (totaldspmaterialsList);
            //pageNum=pageNumnew  + 1;
            lstperSeatController =obj.addOnlineContacts(addRec);
            System.debug(LoggingLevel.WARN,totaldspmaterialsList.size());
            sizeOfWrapper=totaldspmaterialsList.size();
            pageNumnew=(sizeOfWrapper - addrec)/pageSize;  //1774-999=775 /100
            if(math.mod(sizeOfWrapper, pageSize) > 0){
                pageNum=pageNumnew  + 1;
            }else{
                pageNum=pageNumnew;
            }
        } 
        
        System.debug(LoggingLevel.WARN,lstperSeatController .size());    
    }
    /**
     * @description displayMaterialContacts
     */
    public void displayMaterialContacts() {
        isPerSheetSelectAll = False;
        isodenSelectAll = False;    
        isAddReq = False;
        isodAddReq = False;         
        // Check sap Contacts are exists and set the flag to display the Add Online Contacts buttons in the Per sheet tab
        if(olContactsSize == null || olContactsSize == 0){
            isExPSCon = False;}
        else{
            isExPSCon = True;} 
        string mtrl = '';
        string odmtrl = ''; 
        system.debug(LoggingLevel.WARN,'Value of dspMaterials: '+dspMaterials);
        system.debug(LoggingLevel.WARN,'Value of oddspMaterials: '+oddspMaterials);
       for(APLIWrapper ps : totaldspmaterialsList) {
            mtrl = ps.materialNo;
            break;    
        }
        if(!string.isEmpty(mtrl)) {
            materialsMap.remove(mtrl);
            for(APLIWrapper ps : totaldspmaterialsList) {
                if(materialsMap.containsKey(ps.materialNo)) {
                    materialsMap.get(ps.materialNo).add(ps);
                }
                else {
                    materialsMap.put(ps.materialNo, new  List <APLIWrapper> {ps});
                }  
            } 
            system.debug(LoggingLevel.WARN,'size..'+materialsMap.get(mtrl).size());
        }
        system.debug(LoggingLevel.WARN,'materialsMap...'+materialsMap);
        system.debug(LoggingLevel.WARN,'perSeatProducts...'+perSeatProducts);
        system.debug(LoggingLevel.WARN,materialsMap.containsKey(perSeatProducts));
        If(materialsMap.containsKey(perSeatProducts)) {
            totaldspmaterialsList.clear();
            totaldspmaterialsList= materialsMap.get(perSeatProducts);
        }
        else {
            totaldspmaterialsList.clear();
            addPSOnlineContactsPS();     
        }
        system.debug(LoggingLevel.WARN,'dspMaterials...'+totaldspmaterialsList);
        system.debug(LoggingLevel.WARN,'psCountMap.get(perSeatProducts count..'+psCountMap.get(perSeatProducts));
        for(APLIWrapper ps : oddspMaterials) {
            odmtrl = ps.materialNo;
            break;    
        }
        if(!string.isEmpty(odmtrl)) {
            rsmaterialsMap.remove(odmtrl);
            for(APLIWrapper ps : oddspMaterials) {
                if(rsmaterialsMap.containsKey(ps.materialNo)) {
                    rsmaterialsMap.get(ps.materialNo).add(ps);
                }
                else {
                    rsmaterialsMap.put(ps.materialNo, new  List <APLIWrapper> {ps});
                }  
            } 
            system.debug(LoggingLevel.WARN,'OD size..'+rsmaterialsMap.get(odmtrl).size());
        }
        system.debug(LoggingLevel.WARN,'rsmaterialsMap...'+rsmaterialsMap);
        system.debug(LoggingLevel.WARN,'odenProducts...'+odenProducts);
        system.debug(LoggingLevel.WARN,rsmaterialsMap.containsKey(odenProducts));
        If(rsmaterialsMap.containsKey(odenProducts)) {
            oddspMaterials.clear();
            oddspMaterials = rsmaterialsMap.get(odenProducts);
        }
        else {
            oddspMaterials.clear();
            addODOnlineContactsOD();     
        }
        //End
        
        // assign the records to list based on the line item quantity for Per Seat materials         
        // display 999 rows for Retails window and Legal Hold products
    //Sakshi - DOC-4018 - 21 and zeot - oc canada
    //Sakshi - DOC-2868 - MHL = 21 , MLL = MA , ICG = ZVAU - Lotus OC Canada
    //Sakshi - DOC-4463 - MHL = 21 , MLL = MA , ICG = ZVSU - Lotus OC Canada
     //DOC-6624 - MHL = 21 , NLL = MA , ICG = ZVAM - Bijeta Lotus OC Canada
    if(!psCountMap.isEmpty()){
        if(psCountMap.ContainsKey(perSeatProducts) && (/*psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' ||*/
            (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Cat_L5__c == Label.APTS_GSCPW_RP_Product_Family) || //Added by Kruti Shah for DOC-1472
            psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'LO' ||
            psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == '51' ||
            psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'AR' ||
            //Start: Updated by Kruti Shah for DOC-59
            //psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' || // SOC-3864 Added by Chirag 5/4/17           
            (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' 
                && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'PE')
            //End: Updated by Kruti Shah for DOC-59
      &&  
            (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'PS') ||
            (!String.isEmpty(psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name) &&  psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage) && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21') ||
                        (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21'&& psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZEOT') || (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21'&& psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'MA' && (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAU' || psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVSU' || psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAM')))) {
                if(olContactsSize == null || olContactsSize == 0) {
                    for(Integer i = totaldspmaterialsList.size()+1; i <= 25; i++) {
                        addPSOnlineContactsPS();
                    }
                }
                //  PSMaterial.quantity = 999;
                isAddReq = True;
                
                    
               
            }
            
        else if(psCountMap.ContainsKey(perSeatProducts) && psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c!= null && (olContactsSize == null || olContactsSize == 0)) {
            system.debug(LoggingLevel.WARN,'psCountMap.get(perSeatProducts)..'+psCountMap.get(perSeatProducts));
            for(Integer i = totaldspmaterialsList.size()+1; i <= Integer.valueof(psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c)+olContactsSize; i++) {
                addPSOnlineContactsPS();
            }
            // PSMaterial.quantity = psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c;    
        }
        
        //Start: GLP-200    
        if (psCountMap.ContainsKey(perSeatProducts) && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' &&    
            psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'CQ') {  
            isAddReq = True;    
        }   
        //End GLP-200
        //Added by Dominic Thomas DOC-16850
        if(psCountMap.ContainsKey(perSeatProducts) && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' &&    
            (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'OB'||psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'OA')){
            isAddReq = True; 
            }   
        //DOC-16850 Ends
        }
        if(!totaldspmaterialsList.isEmpty() && tabName !='NAIC' ){
            obj = new APTS_CustomPaginationCtrl (totaldspmaterialsList); // dspMaterials
            pageNum=0;
            lstperSeatController = obj.next();
            sizeOfWrapper=totaldspmaterialsList.size();
            if(totalBandedList.isEmpty()){
            tabName='Per Seat Products';
            }
        }
        
        // get the current Per seat material quantity and Name
        fetchPerSeatMaterial();
    }
    // get the per seat material to display in the page header
    /**
     * @description fetchPerSeatMaterial
     */
    public void fetchPerSeatMaterial() {
        if(psCountMap.ContainsKey(perSeatProducts)) {
            psMaterial  .quantity = psCountMap.get(perSeatProducts).APTS_Number_of_Attorneys__c;
            //Start: Updated by Kruti Shah for DOC-1656
      //DOC-4018 - MHL =21 and ICG =ZEOT - Sakshi Lotus OC Canada
       //DOC-2868 - MHL = 21 , NLL = MA , ICG = ZVAU - Sakshi Lotus OC Canada
        //DOC-4463 - MHL = 21 , NLL = MA , ICG = ZVSU - Sakshi Lotus OC Canada
        //DOC-6624 - MHL = 21 , NLL = MA , ICG = ZVAM - Bijeta Lotus OC Canada
            if((isAddReq && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Cat_L5__c!= Label.APTS_GSCPW_RP_Product_Family)
            ||(isAddReq && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' && !String.isEmpty(psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name) && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage))
            || (isAddReq && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZEOT') || (isAddReq && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' && (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAU' || psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVSU'  || psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAM') && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'MA'))
            {
                psMaterial  .quantity = 999;
            }
            else if(psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Cat_L5__c== Label.APTS_GSCPW_RP_Product_Family){
                psMaterial  .quantity = psCountMap.get(perSeatProducts).APTPS_Quantity_Display__c;
            } 
             //Added by Dominic Thomas DOC-16850 
            if(isAddReq &&psCountMap.ContainsKey(perSeatProducts) && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' &&    
            (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'OB'||psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'OA')){
                psMaterial  .quantity = 999;
            }
            //DOC-16850 Ends
            system.debug(LoggingLevel.WARN,'##### isAddReq '+isAddReq );
            system.debug(LoggingLevel.WARN,'##### 1'+ psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c);
            system.debug(LoggingLevel.WARN,'##### 2'+ psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c );
            //Start: GLP-200
            if (isAddReq && psCountMap.ContainsKey(perSeatProducts) && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' &&
                psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'CQ') {
                   psMaterial.quantity = psCountMap.get(perSeatProducts).APTPS_Quantity_Display__c;
            }
            //End GLP-200
            
            //End: Updated by Kruti Shah for DOC-1656
            if(psCountMap.get(perSeatProducts).APTS_Program_ID__c != 'CPRO'){    
                psMaterial  .productName = perSeatProducts+' - '+psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name; }
            else{
                psMaterial .productName = perSeatProducts+' - '+psCountMap.get(perSeatProducts).APTS_Product_Name_Override__c; }      
            
            //SOC-8413
            if((psMaterial  .productName.containsIgnorecase('patron') || psMaterial .productName.containsIgnorecase('correctional') 
                || psMaterial .productName.containsIgnorecase('corr')) 
            && ((psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '06' 
                && (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'AB' 
                || psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'OR'))) )
                { //patron
                    patronFlag = true; 
                }
        }
        
        system.debug(LoggingLevel.WARN,'psMaterial ...'+psMaterial );
        system.debug(LoggingLevel.WARN,'patronFlag...'+patronFlag); //SOC-8413
    }
    /**
     * @description getperSheetSelectedPS
     */
    public void getperSheetSelectedPS()
    {
        selectedAPLIs .clear();
        if(isPerSheetSelectAll != True) {
            for(APLIWrapper accwrapper : totaldspmaterialsList){
                accwrapper.isSelected = False;}
        }
        
        if(isPerSheetSelectAll) {
            for(APLIWrapper accwrapper : totaldspmaterialsList){
                accwrapper.isSelected = True;}
        }
        //return null;
    }
    /**
     * @description getpspSelectedPS
     * @return getpspSelectedPS
     */
    public PageReference getpspSelectedPS()
    {
        for(APLIWrapper accwrapper : totaldspmaterialsList) {
            if(accwrapper.isSelected != true){ 
                isPerSheetSelectAll = False;}
        }
        return null;
    }
    //DOC-11572
    /**
     * @description getodenSelectedOD
     */
    public void getodenSelectedOD()
    {
        selectedAPLIs .clear();
        if(isodenSelectAll != True) {
            for(APLIWrapper accwrapper : oddspMaterials){
                accwrapper.isSelected = False;}
        }
        
        if(isodenSelectAll) {
            for(APLIWrapper accwrapper : oddspMaterials){
                accwrapper.isSelected = True;}
        }
        system.debug(LoggingLevel.WARN,'Wrapper Size = '+oddspMaterials.size()+'Wrapper values'+oddspMaterials);
        //return null;
    }
    
    // method to call on Location Change from the Page
    /**
     * @description locationEvent
     */
    public void locationEvent() {
        locationChange(False);    
    }
    // method to call on change of Location in the Page
    /**
     * @description locationChange
     * @return locationChange
     * @param isRedirect
     */
    public Boolean locationChange(Boolean isRedirect) {
        ocList = new List<Online_Contacts__c>();
        Boolean isProdValReq = False;
        Boolean isReqInfoFilled = False;
        Boolean isMandatory = True;        
        Boolean isSuccess = True;
        Boolean isEmailEmpty = False;
        isError = False;
        Integer contactsCount = 0;
        bandedCount = 0; //SOC-9128
        String  emailInvalidName='';
        String pageNumbers='';
        String pageNumbersFLP ='';
        Integer getPageNumforError=0;
        Integer countOfRec=0;
        set<String> spageNumbers=new set<String>();
        set<String> spageNumbersFLP =new set<String>();
        checkMinOneContact=false;
        // Banded Products
        // query all Online contacts for all MLA of quote to know the count of Contacts and
        if(aptProposal.APTS_MLA_Quote__c) {         
            contactsCount = [SELECT count() FROM Online_Contacts__c 
                        WHERE (QuoteId__c = :proposalId AND Account__c != null AND APTS_Source_System_Detail__c != :quotessd 
                        AND Is_Banded_Product__c = True)];            
        }
        // assign the Banded Products Material no and product description to bandedProductsMap  
        bandedProductsMap = new Map<string, string>();
        assignBPMap();
        for(APLIWrapper apW : totalBandedList) {
                system.debug(LoggingLevel.WARN,'apW...'+apW);
                countOfRec=countOfRec+1;
                if(apW.isSelected == True) {
                    bandedCount += 1; //SOC-9128
                    isProdValReq = True;
                    if(math.mod(countOfRec, pageSize) > 0){
                        getPageNumforError=(countOfRec/pageSize)+ 1;
                    }else{
                        getPageNumforError=countOfRec/pageSize;
                    }
                    System.debug(LoggingLevel.WARN,getPageNumforError);
                    If(!string.isEmpty(apW.onlineContact.First_Name__c) && !string.isEmpty(apW.onlineContact.Last_Name__c) 
                        &&!string.isEmpty(apW.onlineContact.Position__c)) {
                        isMandatory = False;
                    }
                    else{
                    isMandatory = True;
                    spageNumbersFLP .add(String.valueOf(getPageNumforError));
                    }
                    if(isBandedValidation){
                        If(!string.isEmpty(apW.onlineContact.First_Name__c) && !string.isEmpty(apW.onlineContact.Last_Name__c) 
                            &&!string.isEmpty(apW.onlineContact.Position__c) && apW.onlineContact.Type__c == 'Admin' 
                            && !string.isEmpty(apW.strEmail))  {
                            isReqInfoFilled = True;    
                        } 
                    }
                    //Sreenu changes SOC-3851
                    if(string.isEmpty(apW.strEmail)){
                        isEmailEmpty = True;
                    }
                    else if(!string.isEmpty(apW.strEmail) && (apW.strEmail.length()>80 || !Pattern.matches('[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,81}$', apw.strEmail))){
                        spageNumbers.add(String.valueOf(getPageNumforError));
                        if(String.isBlank(emailInvalidName )){
                        emailInvalidName= apW.onlineContact.First_Name__c +' ' + apW.onlineContact.Last_Name__c;
                        }
                        else{
                        emailInvalidName=emailInvalidName + ', ' +apw.onlineContact.First_Name__c +' ' + apw.onlineContact.Last_Name__c;
                        }
                    }
                    //Sreenu changes End
                    assignOCtoCustomObject(apW, True, False);    
                }
                bandedCountMap.put(apW.onlineContact.APTS_Source_System_Detail__c,bandedCount); //SOC-9128
                system.debug(LoggingLevel.WARN,'bandedCountMap...'+bandedCountMap);
            }
        
        //SOC-9128 starts
        List<Integer> selectedOC = bandedCountMap.values();
        Integer totalSelected = 0;
        for(Integer i =0; i < selectedOC.size(); i++){
            totalSelected += selectedOC[i];
        }
        if(totalSelected > maxBandedProdQnt){
            bandError = true;}
        else if(totalSelected <= maxBandedProdQnt){
            bandError = false;}
        system.debug(LoggingLevel.WARN,'selectedOC ...'+selectedOC );
        system.debug(LoggingLevel.WARN,'totalSelected ...'+totalSelected );
        //SOC-9128 ends
        System.debug(LoggingLevel.WARN,'1+++++++'+ isProdValReq );
        if(!isProdValReq && !totalBandedList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCSelectContact+' '+System.Label.OCBandedProducts));     
            isSuccess = False;
        }
        //DOC-11691: Jinal Bhatt
        if (!totalBandedList.isEmpty() && !spageNumbersFLP.isEmpty()) {
            for(String str: spageNumbersFLP ){
                if(String.isBlank(pageNumbersFLP)){
                    pageNumbersFLP =str;
                }
                else{
                    pageNumbersFLP =pageNumbersFLP + ',' +str;
                }
            }
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCFisrtLastPosMandatory+' '+System.Label.OCBandedProducts +' on Page '+pageNumbersFLP ));
            isSuccess = False;
        }
        //End DOC-11691
        
        If(!isReqInfoFilled && isBandedValidation && isProdValReq) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCFirstLastPosTypeEmailMandatory+' '+System.Label.OCBandedProducts));     
            isSuccess = False;
        }
        if(isLiveNoteBandedProduct && isEmailEmpty) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCLiveNoteEmailRequired+' '+System.Label.OCBandedProducts));     
            isSuccess = False;
        }
        if(!spageNumbers.isEmpty()){ // Email address in in wrong format
            for(String str: spageNumbers){
                if(String.isBlank(pageNumbers )){
                    pageNumbers =str;
                }
                else{
                    pageNumbers =pageNumbers + ',' +str;
                }
            }
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please check Email Address for' + ' ' + emailInvalidName +' for ' + System.Label.OCBandedProducts +' on Page '+pageNumbers));
            isSuccess = False;
        }
        //system.debug('maxBandedProdQnt..'+maxBandedProdQnt);
        system.debug(LoggingLevel.WARN,'ocList...'+ocList);
        // check the selected Banded Product size with Max allowed Contacts
        Boolean isDetailPage = False;
        if(!ocList.isEmpty() && ocList.size() > (checkBandedSize)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCExceededPasswords+' '+System.Label.OCBandedProducts));     
            isSuccess = False;
        }
        else if(!ocList.isEmpty() && bandError){ //SOC-9128             
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'You cannot select more than the allowed number of passwords for all Locations for'+' '+System.Label.OCBandedProducts));     
            isSuccess = False;            
        }
        If(isSuccess){
            system.debug(LoggingLevel.WARN,'bpListtoDel...'+bpListtoDel);
            // call persheet materials Save method.
            isDetailPage = savePSContacts();              
        }
        if(isDetailPage) {
            system.debug(LoggingLevel.WARN,'inside1');
            prevLocation=preLocation ;
            preLocation = Location;
            isSuccess = True;
        }
        else {
            system.debug(LoggingLevel.WARN,'inside2');
            location = preLocation;
            isSuccess = False; 
        }
        if(!isSuccess) {
            system.debug(LoggingLevel.WARN,'inside3');
            isError = True;
            checkMinOneContact=true;
        }
        return isSuccess;       
    } 
    
    // Save the Banded online contacts in Custom Object
    /**
     * @description save
     * @return save
     */
    public PageReference save() {
        try {
            PageReference oPage = null;
            
            if(locationChange(True)) {
                oPage = new PageReference('/'+proposalId);
                return oPage;
            }
            else{ 
                return null;}
        }
        catch(Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage()+ex.getLineNumber()));     
            return null;
        }
    }
    
    // assign the Banded Products Material no and product description to bandedProductsMap. used to assign the Product desc to Online Contacts before insert.
    /**
     * @description assignBPMap
     */
    public void assignBPMap() {
        for(String str :bandedProducts) {
            bandedProductsMap.put(str.substringBefore(' '), str.substringAfter(' ')); 
        }
        system.debug(LoggingLevel.WARN,'bandedProductsMap...'+bandedProductsMap);
    }
    /**
     * @description assignOCtoCustomObject
     * @param apW
     * @param isBanded
     * @param isOden
     */
    public void assignOCtoCustomObject(APLIWrapper apW, Boolean isBanded, Boolean isOden) {
        Online_Contacts__c oc = new Online_Contacts__c();
        oc.Account__c = apW.onlineContact.Account__c;
        //Added by Priyanka
        oc.APTS_Source_System_Detail__c = apW.onlineContact.APTS_Source_System_Detail__c;
        oc.QuoteId__c = proposalId;
        oc.Material__c = apW.materialNo;
        oc.ContactID__c = apW.onlineContact.ContactID__c;                                      
        oc.First_Name__c = apW.onlineContact.First_Name__c;
        oc.Middle_Name__c = apW.onlineContact.Middle_Name__c;
        oc.Last_Name__c = apW.onlineContact.Last_Name__c;
        oc.Email__c = apW.strEmail;
        oc.Position__c = apW.onlineContact.Position__c;
        oc.Type__c = apW.onlineContact.Type__c;
        oc.WLEc_Juris__c = apW.onlineContact.WLEc_Juris__c;
        oc.NAIC_Name__c = apW.onlineContact.NAIC_Name__c;
        oc.NAIC_Number__c = apW.onlineContact.NAIC_Number__c;
        
        //oc = apw.onlineContact;
        if(oc.Type__c == 'Admin'){ 
            oc.Sftwr_Admin__c = True;}
        else{
            oc.Sftwr_Admin__c = False;}
        if(isBanded == True) { 
            oc.Is_Banded_Product__c = True;
            for(string mat :bandedMaterials.split('\n')) {
                Online_Contacts__c onlCon = new Online_Contacts__c(Account__c = oc.Account__c,APTS_Source_System_Detail__c = oc.APTS_Source_System_Detail__c,QuoteId__c = oc.QuoteId__c,Material__c = mat,  
                                               ContactID__c = oc.ContactID__c, First_Name__c = oc.First_Name__c,Middle_Name__c  = oc.Middle_Name__c ,
                                               Last_Name__c  = oc.Last_Name__c , Email__c = oc.Email__c ,Position__c  = oc.Position__c , WLEc_Juris__c = oc.WLEc_Juris__c,
                                               Type__c = oc.Type__c , Is_Banded_Product__c = oc.Is_Banded_Product__c, 
                                               Product_Description__c = (!bandedProductsMap.isEmpty() && bandedProductsMap.containsKey(mat)) ? bandedProductsMap.get(mat) : null);                
                // onlCon.Material__c = mat;
                ocList.add(onlCon);
            }
        }
        else {
            if(isOden == True){
                oc.Product_Description__c = (!odCountMap.isEmpty() && odCountMap.containsKey(oc.Material__c)) ? odCountMap.get(oc.Material__c).Apttus_Proposal__Product__r.Name : null;
                oc.Is_Banded_Product__c = False;        
                ocList.add(oc);}
            else{
            oc.Product_Description__c = (!psCountMap.isEmpty() && psCountMap.containsKey(oc.Material__c)) ? psCountMap.get(oc.Material__c).Apttus_Proposal__Product__r.Name : null;
            oc.Is_Banded_Product__c = False;        
            ocList.add(oc);}
        }
        
    }
    
    // update the proposal line items with APTS_Online_Contacts_Validation__c = True
    /**
     * @description getbpSelected
     */
    public void updateLineItems() {
        apliUpdList = new List<Apttus_Proposal__Proposal_Line_Item__c>(); 
        system.debug(LoggingLevel.WARN,'bandedApliIds...'+bandedApliIds);
        for(Id pId :bandedApliIds) {
            Apttus_Proposal__Proposal_Line_Item__c apliRec = new Apttus_Proposal__Proposal_Line_Item__c(Id = pId, APTS_Online_Contacts_Validation__c = True);
            apliUpdList.add(apliRec);                    
        }
        system.debug(LoggingLevel.WARN,'apliUpdList...'+apliUpdList);
        // skg moved for the location flag to be after
        //if(!apliUpdList.isEmpty()) {
        //    update apliUpdList;
        //}
        // update the aggrement location Validation Flag
        if(!Schema.sObjectType.APTS_Quote_Agreement_Locations__c .isAccessible() && 
        !Schema.sObjectType.APTS_Quote_Agreement_Locations__c .isUpdateable()){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));   
        }
       
        if(aptProposal.APTS_MLA_Quote__c && !string.isEmpty(location)) {
            if(Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isAccessible() 
        && Schema.sObjectType.APTS_Quote_Agreement_Locations__c.isUpdateable()) {
            
            APTS_Quote_Agreement_Locations__c agLoc = new APTS_Quote_Agreement_Locations__c(id = locationMap.get(quotessd).Id, APTS_Online_Contacts_Validation__c = True);
            update agLoc;
        }
    }
        //skg moved update here
        if(!apliUpdList.isEmpty() && 
        Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isAccessible() 
        && Schema.sObjectType.Apttus_Proposal__Proposal_Line_Item__c.isUpdateable()) {
        
            update apliUpdList;
        }
        system.debug(LoggingLevel.WARN,'no of Queries...'+Limits.getQueries());
        system.debug(LoggingLevel.WARN,'no of Queries...'+Limits.getLimitQueries());
    }
    // Method to check if Product is LiveNote
    // Sreenu Changes SOC-3851
    //Check for E-mail products - 21MA, 21MB
    //Sakshi changes DOC-2868, DOC-4463
    /**
     * @description liveNoteProduct
     * @return liveNoteProduct
     * @param hlCode
     * @param llCode
     */
    public static boolean liveNoteProduct(string hlCode, string llCode) {
        boolean isLNProduct = False;
        if(((hlCode == '06') && (llCode == 'L2' || llCode == 'LB' )) 
            || ((hlCode == '13') 
                && (llCode == 'CM' || llCode == 'CR' || llCode == 'LB' || llCode == 'LR' ))
                || ((hlCode == '21') 
                && (llCode == 'MA' || llCode == 'MB')))
        {
            isLNProduct = True;
        }
        return isLNProduct;
    }
    // validation method for Products to fill the required fields
    
    // Save the online contacts in Custom Object
    /**
     * @description savePSContacts
     * @return savePSContacts
     */
    public Boolean savePSContacts() {
        try {
           // PageReference oPage ;
            // ocList = new List<Online_Contacts__c>();            
            Set<Id> psApliIds = new Set<Id>(); 
            Set<Id> odApliIds = new Set<Id>();    
            Boolean isProdValReq = False;
            Boolean isReqInfoFilled = False;
            Boolean isWLECFilled = False;
            Boolean isProductAdded = False;
            Boolean isWLECAdded = False;
            Boolean isReqFilled = False;
            Boolean isMLA = False;
            string validationProduct = '';
            Boolean isLiveNoteProduct = False ;
            Boolean isEmailFilled = False;
            Boolean isEmailValidationForCPW = True;
            Boolean isGLPPosition= false; //GLP-583
            String  emailInvalidName='';            
            String strContacts='';
            Integer countofContacts=0;
            String pageNumbers='';
            String pageNumbersFLP='';
            Map<String, Set<String>> mappageNumbers=new Map<String, Set<String>>();
            Map<String, Set<String>> mappageNumbersFLP=new Map<String, Set<String>>();
            Map<string, Integer> countMap = new Map<string, Integer>();
            Boolean isRSProdValReq = False;
            Boolean isRSReqInfoFilled = False;
            // vall the below method to update the map - materialsMap with latest values of selected per seat material
            displayMaterialContacts();
            system.debug(LoggingLevel.WARN,'materialsMap...'+materialsMap);
            system.debug(LoggingLevel.WARN,'rsmaterialsMap...'+rsmaterialsMap);   
            // query the all online contacts to know the count
            if(aptProposal.APTS_MLA_Quote__c) {
                //Added by Priyanka 9/21
                List<aggregateResult> results = [SELECT Material__c, count(Id) total FROM Online_Contacts__c 
                                WHERE (QuoteId__c = :proposalId AND APTS_Source_System_Detail__c != null 
                                AND APTS_Source_System_Detail__c != :quoteSsd AND Is_Banded_Product__c = False) 
                                Group By Material__c];
                for (AggregateResult ar : results) {
                    // string s = (string)ar.get('Material__c');
                    countMap.put((String)ar.get('Material__c'), (Integer)ar.get('total'));
                }
            }
            
            string materials = '';
            Map<String,Integer> patronMap = new Map<String,Integer>(); // SOC-8413
            Map<String, String> mapEmailFormatInvalid = new Map<String, String>();
            //Set<String> setEmailFormatInvalid = new Set<String>();
            Set<String> setGLPPosition = new Set<String>();
            if(materialsMap != null && materialsMap.size() > 0){    
            system.debug(LoggingLevel.WARN,'########### materialsMap'+materialsMap);
            for(string strKey :materialsMap.keySet()) {
                integer count = 0;
                system.debug(LoggingLevel.WARN,'key..'+strKey);
                system.debug(LoggingLevel.WARN,'materialsMap.get(strKey)...'+materialsMap.get(strKey));
                // Intialize the vaiables because for each per seat product need to verify the validations.
                isProdValReq = False;
                isReqInfoFilled = False;
                isWLECFilled = False;
                isProductAdded = False;
                isWLECAdded = False;
                isReqFilled = False;                
                validationProduct = '';
                isLiveNoteProduct = False;
                isEmailFilled = False;
                isEmailValidationForCPW = True;
                isGLPPosition = false;
                emailInvalidName='';
                Integer getPageNumforError=0;
                Integer countOfRec=0;
                Set<String> setPageNumbers=new Set<String>();
                Set<String> setPageNumbersFLP=new Set<String>();
                //system.debug('Product Name...'+psCountMap.get(strKey).Apttus_Proposal__Product__r.Name);
                for(APLIWrapper wrap :materialsMap.get(strKey)) {
                    System.debug(LoggingLevel.WARN,'wrap'+wrap.isSelected);
                    countOfRec=countOfRec+1;
                      //materialsMap.get(strKey)
                    if(wrap.isSelected == True) {
                        count = count+1;
                        isProdValReq = True; 
                        system.debug(LoggingLevel.WARN,'count...'+count);     
                        if(math.mod(countOfRec, pageSize) > 0){
                            getPageNumforError=(countOfRec/pageSize)+ 1;
                        }else{
                            getPageNumforError=countOfRec/pageSize;
                        }
                        System.debug(LoggingLevel.WARN,'pagenumber'+getPageNumforError);                  
                        if(psCountMap.ContainsKey(strKey) ) {
                            psApliIds.add(psCountMap.get(strKey).Id);                           
                            if(!string.isEmpty(wrap.onlineContact.First_Name__c) 
                                && !string.isEmpty(wrap.onlineContact.Last_Name__c) 
                                &&!string.isEmpty(wrap.onlineContact.Position__c)) {
                                isReqFilled = True;  
                                
                                //Start: Added by Kruti for DOC-1472
                                system.debug(LoggingLevel.WARN,'KS--> Product Level 4 value: '+psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Cat_L5__c);
                                if(psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Cat_L5__c!= null 
                                   && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Cat_L5__c== Label.APTS_GSCPW_RP_Product_Family){
                                        if(string.isEmpty(wrap.strEmail) ){
                                           isEmailValidationForCPW = False;
                                           countofContacts++;                                           
                                           strContacts = +psCountMap.get(strKey).Apttus_Proposal__Product__r.Name;//DOC-11957: Jinal Bhatt                                           
                                       }else{
                                           isEmailValidationForCPW = True;                                        
                                       }
                                   }
                                //End: Added by Kruti for DOC-1472  
                            }
                            else {
                                isReqFilled = False;
                                setPageNumbersFLP.add(String.valueOf(getPageNumforError));
                                validationProduct = psCountMap.get(strKey).Apttus_Proposal__Product__r.Name;
                                mappageNumbersFLP.put(validationProduct ,setPageNumbersFLP);
                            }
                            if(!string.isEmpty(wrap.strEmail)){  
                            isEmailFilled = True;
                            if(wrap.strEmail.length()>80 || !Pattern.matches('[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,80}$', wrap.strEmail)){
                                validationProduct = psCountMap.get(strKey).Apttus_Proposal__Product__r.Name;
                                setPageNumbers.add(String.valueOf(getPageNumforError));
                                mappageNumbers.put(validationProduct  ,setPageNumbers);
                                if(String.isBlank(emailInvalidName)){
                                    emailInvalidName=wrap.onlineContact.First_Name__c +' ' + wrap.onlineContact.Last_Name__c;
                                }
                                else{
                                    emailInvalidName=emailInvalidName + ', ' +wrap.onlineContact.First_Name__c +' ' + wrap.onlineContact.Last_Name__c;
                                }
                                mapEmailFormatInvalid .put(validationProduct , emailInvalidName);
                            }
                            }
                            else {
                                isEmailFilled = False; 
                                validationProduct = psCountMap.get(strKey).Apttus_Proposal__Product__r.Name;    
                            }
                            
                            if(!isReqFilled) {
                                validationProduct = psCountMap.get(strKey).Apttus_Proposal__Product__r.Name;
                            }
                            system.debug(LoggingLevel.WARN,'Brand...'+psCountMap.get(strKey).Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c);
                            system.debug(LoggingLevel.WARN,'###### psCountMap'+psCountMap);
                            //Start:GLP-583
                            if(psCountMap.ContainsKey(strKey) && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21'
                            && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'CQ') {
                                setGLPPosition.add(wrap.onlineContact.Position__c);
                            }
                            //End GLP-583
                            if(psCountMap.get(strKey).Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c == '064') {
                                isProductAdded = True;
                                If(!string.isEmpty(wrap.onlineContact.First_Name__c) && !string.isEmpty(wrap.onlineContact.Last_Name__c) 
                                    &&!string.isEmpty(wrap.onlineContact.Position__c) && wrap.onlineContact.Type__c == 'Admin' 
                                    && !string.isEmpty(wrap.strEmail)) {
                                    isReqInfoFilled = True;    
                                } 
                                if(!isReqInfoFilled){
                                    validationProduct = psCountMap.get(strKey).Apttus_Proposal__Product__r.Name;}
                            }
                            if(psCountMap.get(strKey).Apttus_Proposal__Product__r.Apttus_Filter_Brand_Code__c == '124') {
                                isWLECAdded = True;
                                If(!string.isEmpty(wrap.onlineContact.First_Name__c) && !string.isEmpty(wrap.onlineContact.Last_Name__c)
                                    &&!string.isEmpty(wrap.onlineContact.Position__c) && !string.isEmpty(wrap.onlineContact.WLEc_Juris__c) 
                                    && !string.isEmpty(wrap.strEmail)) {
                                    isWLECFilled = True;    
                                } 
                                if(!isWLECFilled){
                                    validationProduct = psCountMap.get(strKey).Apttus_Proposal__Product__r.Name;}
                            }
                            
                            
                        } 
                        //SOC-8413
                        patronMap.put(wrap.materialNo,count);//patron
                        
                        system.debug(LoggingLevel.WARN,'patronMap...'+patronMap);   
                    }
                }
                system.debug(LoggingLevel.WARN,'##### setGLPPosition '+setGLPPosition );
                System.debug(LoggingLevel.WARN,'KS--> isProdValReq '+isProdValReq);
                if(!isProdValReq && !materialsMap.isEmpty()) {
                    break;
                }
                if(!isReqFilled && isProdValReq) {
                    break;
                } 
                If(!isReqInfoFilled && isProductAdded && isProdValReq) {
                    break;
                }
                system.debug(LoggingLevel.WARN,'isWLECFilled..'+isWLECFilled);
                system.debug(LoggingLevel.WARN,'isWLECAdded...'+isWLECAdded);
                if(!isWLECFilled && isWLECAdded && isProdValReq) {
                    break;
                }
                
                // system.debug('Quantity...'+psCountMap.get(strKey).Apttus_Proposal__Quantity__c);
        //Sakshi added ZEOT and MLL = MA,EC for Lotus OC Canada 
                if((psCountMap.ContainsKey(strKey) && count > Integer.valueOf(psCountMap.get(strKey).APTS_Number_of_Attorneys__c)) && (psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'LO' && !(psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' && !String.isEmpty(psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name) && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage)) && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != '51' && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'AR' && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c != 'ZEOT' && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'MA' && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'EC' && ((psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c + psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c) != '13PS'))) {
                           
                            materials = materials+psCountMap.get(strKey).Apttus_Proposal__Product__r.Name +' ';
                            system.debug(LoggingLevel.WARN,'materials...'+materials);
                       }
               //Sakshi added ZEOT and MLL = MA,MB,EC for Lotus OC Canada 
               else if((psCountMap.ContainsKey(strKey) && !countMap.isEmpty() && countMap.containsKey(strKey) &&  countMap.get(strKey)+count > Integer.valueOf(psCountMap.get(strKey).APTS_Number_of_Attorneys__c)) && (!(psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' && !String.isEmpty(psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name) && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage)) && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'LO' && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != '51' && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'AR' && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c != 'ZEOT' && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'MA' && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'EC'&& ((psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c + psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c) != '13PS'))) {
                                isMLA = True;
                                materials = materials+psCountMap.get(strKey).Apttus_Proposal__Product__r.Name +' ';
                                system.debug(LoggingLevel.WARN,'materials...'+materials);
               }               
               //Added by Poonam Garg for Small Law firm Proview check of 999 passwords
               /* else if( psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' && 
                       !String.isEmpty(psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name) && 
                       psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage) &&
                       (count>999)){
                       materials = materials+psCountMap.get(strKey).Apttus_Proposal__Product__r.Name +' ';
                                // system.debug('lower level Code...'+psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c); 
                       system.debug('materials...'+materials);
                       
                }*/
                else if(psCountMap.ContainsKey(strKey) && psMaterial  !=null && psMaterial .quantity!=null && 
               count > psMaterial .quantity && ((isAddReq && 
               psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Cat_L5__c!= Label.APTS_GSCPW_RP_Product_Family)
               ||(isAddReq && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' 
               && !String.isEmpty(psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name) 
               && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage))
               || (isAddReq && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' 
               && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZEOT') 
               || (isAddReq && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' 
               && (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAU' 
               || psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVSU' 
                || psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAM') 
                && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'MA')))
               {
                materials = materials+psCountMap.get(strKey).Apttus_Proposal__Product__r.Name +' ';
                    system.debug(LoggingLevel.WARN,'materials...'+materials);
               }
               else if(psCountMap.ContainsKey(strKey) && psMaterial  !=null && psMaterial .quantity!=null && ( !countMap.isEmpty() && countMap.containsKey(strKey) &&  
               countMap.get(strKey)+count > psMaterial .quantity)  && ((isAddReq && 
               psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Cat_L5__c!= Label.APTS_GSCPW_RP_Product_Family)
               ||(isAddReq && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' 
               && !String.isEmpty(psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name) 
               && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage))
               || (isAddReq && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' 
               && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZEOT') 
               || (isAddReq && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' 
               && (psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAU' 
               || psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVSU' 
                || psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAM') 
                && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'MA')))
               {
                materials = materials+psCountMap.get(strKey).Apttus_Proposal__Product__r.Name +' ';
                    system.debug(LoggingLevel.WARN,'materials...'+materials);
               }
               else if(psCountMap.ContainsKey(strKey) && psMaterial  !=null && psMaterial .quantity!=null && count > psMaterial .quantity && 
               psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Cat_L5__c== Label.APTS_GSCPW_RP_Product_Family){
                    system.debug(LoggingLevel.WARN,'materials...'+materials);
                    materials = materials+psCountMap.get(strKey).Apttus_Proposal__Product__r.Name +' ';
               }
               else if(psCountMap.ContainsKey(strKey) && psMaterial  !=null && psMaterial .quantity!=null && ( !countMap.isEmpty() && countMap.containsKey(strKey) &&  
               countMap.get(strKey)+count > psMaterial .quantity ) && 
               psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Cat_L5__c== Label.APTS_GSCPW_RP_Product_Family){
                    system.debug(LoggingLevel.WARN,'materials...'+materials);
                    materials = materials+psCountMap.get(strKey).Apttus_Proposal__Product__r.Name +' ';
               }
                //Sreenu Changes SOC-3851
                if(liveNoteProduct(psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c, psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c)){
                    isLiveNoteProduct = True;}
                
                If(isLiveNoteProduct && !isEmailFilled) {
                    break;
                }
                //SOC-8413
                if(patronFlag && patronMap.ContainsKey(strKey) && psCountMap.ContainsKey(strKey) && Integer.ValueOf(patronMap.get(strKey)) > Integer.valueOf(psCountMap.get(strKey).APTS_Number_of_Attorneys__c)){ //patron
                    errorFlag = true;
                    break;
                }else if(patronFlag && patronMap.ContainsKey(strKey) && psCountMap.ContainsKey(strKey) && Integer.ValueOf(patronMap.get(strKey)) == Integer.valueOf(psCountMap.get(strKey).APTS_Number_of_Attorneys__c)){
                    errorFlag = false;
                }
                system.debug(LoggingLevel.WARN,'errorFlag...'+errorFlag);
            }
            }
            System.debug(LoggingLevel.WARN,'KS--> isProdValReq'+isProdValReq);
            System.debug(LoggingLevel.WARN,'KS--> materialsMap.isEmpty() '+materialsMap.isEmpty());
            if(!isProdValReq && !materialsMap.isEmpty()) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCSelectContactPS));     
                return False;
            } 
            
            //Start:GLP-583
            if (setGLPPosition != null && setGLPPosition.size() > 0) {
                system.debug(LoggingLevel.WARN,'##### setGLPPosition '+setGLPPosition );
                if (!setGLPPosition.contains('Proview Ent IP')) {
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.APTS_GLP_Position));     
                    return False;
                }
            }
            //End GLP-583
            
            System.debug(LoggingLevel.WARN,'KS--> isReqFilled '+isReqFilled);
            System.debug(LoggingLevel.WARN,'KS--> isProdValReq '+isProdValReq);
            System.debug(LoggingLevel.WARN,'KS--> isEmailValidationForCPW '+isEmailValidationForCPW);

            //DOC-11691: Jinal Bhatt
            if (!mappageNumbersFLP.isEmpty() ){
            Set<String> spageNumbersFLP=new Set<String>();
            for(String strkey : mappageNumbersFLP.keyset()){
                spageNumbersFLP=new Set<String>();
                spageNumbersFLP=mappageNumbersFLP.get(strkey);
                pageNumbersFLP ='';
                for(String str: spageNumbersFLP){
                    if(String.isBlank(pageNumbersFLP )){
                        pageNumbersFLP =str;
                    }
                    else{
                        pageNumbersFLP =pageNumbersFLP + ',' +str;
                    }
                }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCFisrtLastPosMandatory+' '+ strkey + ' on Page '+pageNumbersFLP ));
            }
            return False;
            }
            //End DOC-11691          
            
            //Start: Added by Kruti for DOC-1472
            //if(!isEmailValidationForCPW){
            if(countofContacts>0){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,system.Label.APTS_EmailValidationCPW+' '+strContacts));
                return False;
            } 
            //End: Added by Kruti for DOC-1472            
            
            If(!isReqInfoFilled && isProductAdded) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCPSTypeEmailMandatory+' '+validationProduct));     
                return False;
            }
            //SOC-3851 Added by Chirag 5/2/2017
            if(isLiveNoteProduct && !isEmailFilled){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, System.Label.OCLiveNoteEmailRequired+' '+validationProduct));     
                return False;
            }
            
            if(!isWLECFilled && isWLECAdded) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCPSWlesEmailMandatory+' '+validationProduct));     
                return False;
            }
            if(!mappageNumbers.isEmpty() ){
            Set<String> spageNumbers=new Set<String>();
            for(String strkey : mappageNumbers.keyset()){
                spageNumbers =new Set<String>();
                spageNumbers=mappageNumbers.get(strkey);
                pageNumbers ='';
                for(String str: spageNumbers ){
                    if(String.isBlank(pageNumbers)){
                        pageNumbers =str;
                    }
                    else{
                        pageNumbers =pageNumbers + ',' +str;
                    }
                }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please check Email Address for'+' '+mapEmailFormatInvalid .get(strkey)+' for ' + strkey + ' on Page '+pageNumbers));
            }
            return False;
            }
            if(!string.isEmpty(materials) && isMLA) {
                system.debug(LoggingLevel.WARN,'errorFlag... '+errorFlag+'patronFlag...'+patronFlag);
                if((patronFlag == false) || (patronFlag == true &&  errorFlag)){ //patron Soc-8413
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You Cannot select more than allowed Passwords for all Locations for'+' '+materials));     
                    return False;
                }
            }
            else if(!string.isEmpty(materials)) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCExceededPasswords+' '+materials));     
                return False;
            }
            if(rsmaterialsMap != null && rsmaterialsMap.size() > 0){    
            for(string strKey :rsmaterialsMap.keySet()) {
                system.debug(LoggingLevel.WARN,'rskey..'+strKey);
                system.debug(LoggingLevel.WARN,'rsmaterialsMap.get(strKey)...'+rsmaterialsMap.get(strKey));
                // Intialize the vaiables because for each oden product need to verify the validations.
                isRSProdValReq = False;
                isRSReqInfoFilled = False;
                                
                for(APLIWrapper wrap :rsmaterialsMap.get(strKey)) {
                    if(wrap.isSelected == True) {
                        isRSProdValReq = True; 
                        system.debug(LoggingLevel.WARN,'NAIC Name: '+wrap.onlineContact.NAIC_Name__c);                        
                        system.debug(LoggingLevel.WARN,'NAIC Number: '+wrap.onlineContact.NAIC_Number__c);
                        if(odCountMap.ContainsKey(strKey) ) {
                           odApliIds.add(odCountMap.get(strKey).Id);
                        if((wrap.onlineContact.NAIC_Number__c != null) && !string.isEmpty(wrap.onlineContact.NAIC_Name__c))
                        {
                            isRSReqInfoFilled = True;  
                            system.debug(LoggingLevel.WARN,'Required Info Flag changed to True for: '+wrap.onlineContact.NAIC_Number__c);
                                               
                        }
                        else{isRSReqInfoFilled = False;}
                    }
                   }
                }
                if(!isRSProdValReq && !rsmaterialsMap.isEmpty()) {
                    break;
                }
                if(!isRSReqInfoFilled && isRSProdValReq) {
                    break;
                } 
            }
        }
        if(!isRSProdValReq && !rsMaterialsMap.isEmpty()) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCSelectContactOD));     
                return False;
            }
        If(!isRSReqInfoFilled && isRSProdValReq) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.OCNAICInfoMandatory/*+' '+validationProduct*/));                         
                return False;   
            }
          //End  
            
            List<APLIWrapper> mapList = new List<APLIWrapper>();
            List<APLIWrapper> odmapList = new List<APLIWrapper>();
            for(List<APLIWrapper> listAWPS :materialsMap.values()) {
                mapList.addAll(listAWPS);
            }
            for(List<APLIWrapper> listAWOD :rsMaterialsMap.values()) {
                odmapList.addAll(listAWOD);
            }
            
            for(APLIWrapper apW : mapList) {
                if(apW.isSelected == True) {
                    
                    assignOCtoCustomObject(apW, False, False);    
                }
            }
            for(APLIWrapper odW : odmapList) {
                if(odW.isSelected == True) {
                    
                    assignOCtoCustomObject(odW, False, True);    
                }
            }
            
            system.debug(LoggingLevel.WARN,'ocList...'+ocList);
            if(!bpListtoDel.isEmpty() || !psListtoDel.isempty() || !odListtoDel.isempty() &&
                Schema.sObjectType.Online_Contacts__c.isAccessible() 
                && Schema.sObjectType.Online_Contacts__c.isDeletable()) {
                List<Online_Contacts__c> ocDelList = new List<Online_Contacts__c>();
                ocDelList.addAll(bpListtoDel);
                ocDelList.addAll(psListtoDel);
                ocDelList.addAll(odListtoDel);    
                system.debug(LoggingLevel.WARN,'FinalList ='+ocDelList);
                delete ocDelList;
            }
            
            if(Schema.sObjectType.Online_Contacts__c.isAccessible() && Schema.sObjectType.Online_Contacts__c.isCreateable()
                && Schema.sObjectType.Online_Contacts__c.isUpdateable() && !ocList.isEmpty() ) {
                upsert ocList;
                // call a method from APTS_OnlineContactsController_Utility to create attachment of OnlineContacts
                APTS_OnlineContactsController_Utility.onlineContactsExcel(proposalId, aptProposal.Name);
            }            
            system.debug(LoggingLevel.WARN,'no of Queries bu...'+Limits.getQueries());
            system.debug(LoggingLevel.WARN,'no of Queries bu...'+Limits.getLimitQueries());
            // method to update the proposal Line items
            bandedApliIds.addAll(psApliIds);
            bandedApliIds.addAll(odApliIds);
            
            updateLineItems();
            // call a method to create attachment of OnlineContacts
            //onlineContactsExcel(proposalId, aptProposal.Name);
            /*oPage = new PageReference('/'+proposalId);
return oPage;*/
            return True;
        }
        catch(Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ex.getMessage()+Ex.getLineNumber()));     
            return False;
        }
    }    
    // Method to create a attachment with all Online Contacts
    /*@Future(callout=true)
    public static void onlineContactsExcel(string proposalId, string qName) {
        PageReference csvData = Page.OnlineContactsExport;        
        csvData.getParameters().put('id',proposalId);    
        Attachment attach = new Attachment();
        attach.ContentType = 'application/pdf';
        if(!Test.isRunningTest()){ 
            attach.Body = csvData.getContent();}
        else{
            attach.Body = Blob.ValueOf('123');}    
        system.debug('attach...'+attach);
        if( Schema.sObjectType.Attachment.isAccessible() 
                && Schema.sObjectType.Attachment.isQueryable() ){
        List<Attachment> attachList = [Select Id, Body From Attachment Where ParentId =:proposalId AND Name = :(qName+' '+System.Label.OCFileName) Limit 1];
        if( Schema.sObjectType.Attachment.isAccessible() 
                && Schema.sObjectType.Attachment.isCreateable() && attachList.isEmpty() ){
            attach.Name = qName +' '+System.Label.OCFileName;        
            attach.ParentId = proposalId;
            insert attach; 
        }  
        else {
            for(Attachment att :attachList){
                att.Body = attach.Body;
            }
            if(Schema.sObjectType.Attachment.isAccessible() 
                && Schema.sObjectType.Attachment.isUpdateable()){
                update attachList;
            }
        }
        }
        
    }*/
    // Cancel Method to navigate to Proposal.
    /**
     * @description cancel
     * @return cancel
     */
    public PageReference cancel() {
        PageReference pr = new PageReference('/'+proposalId);
        return pr;
    }
    
//DOC-11842 : Method to copy the contacts of PerSeat products
/**
     * @description getbpSelected
     */
    public void copypscontacts() {
        List<APLIWrapper> awlist = new List<APLIWrapper>();
        List<APLIWrapper> existcon = new List<APLIWrapper>();
        for(APLIWrapper aw : totaldspmaterialsList){
            if(aw.isSelected == true && aw.materialNo == perSeatProducts && aw.isNewContact == true && aw.onlineContact.First_Name__c != null && aw.onlineContact.Last_Name__c != null && aw.onlineContact.Position__c != null) {
                awlist.add(aw);
            }else if(aw.isSelected == true && aw.materialNo == perSeatProducts && aw.isNewContact == false) {
                existcon.add(aw);
            }
        }
        for(string strKey : materialsMap.keySet()){
            if(strKey != perSeatProducts){
                for(APLIWrapper wrap :materialsMap.get(strKey)){
                    if(wrap.isNewContact == true){
                        wrap.onlineContact.First_Name__c = '';
                        wrap.onlineContact.Middle_Name__c = '';
                        wrap.onlineContact.Last_Name__c = '';
                        wrap.strEmail = '';
                        wrap.onlineContact.Position__c = '';
                        wrap.onlineContact.Type__c = '';
                        wrap.onlineContact.WLEc_Juris__c = '';  
                        wrap.isSelected = false;
                    }else if(wrap.isNewContact == false && wrap.isSelected == true){
                        wrap.isSelected = false;
                    }
                    materialsMap.get(strKey).set(materialsMap.get(strKey).indexof(wrap),wrap);
                }
            }
        }
        for(string strKey :productlist){
            if(strKey != perSeatProducts){
                Integer quantity = 0;
                Integer count = 0;
                Integer minindex = -1;
                Integer maxindex = -1;
                quantity = prdqty.get(strKey);
                if(!materialsMap.isEmpty()){
                    if(materialsMap.containsKey(strKey)){
                        for(APLIWrapper wrap :materialsMap.get(strKey)){
                            if(wrap.isNewContact == false){
                                if(count<=existcon.size()){
                                    Integer tempindex = materialsMap.get(strKey).indexof(wrap);
                                    if(count>=quantity){
                                        break;
                                    }else if( !materialsMap.isEmpty() && materialsMap.get(perSeatProducts)!=null && materialsMap.get(perSeatProducts).get(tempindex)!=null && materialsMap.get(perSeatProducts).get(tempindex).isSelected == true && materialsMap.get(perSeatProducts).get(tempindex).onlineContact.First_Name__c == wrap.onlineContact.First_Name__c){
                                        wrap.strEmail = materialsMap.get(perSeatProducts).get(tempindex).strEmail;
                                        wrap.onlineContact.Type__c = materialsMap.get(perSeatProducts).get(tempindex).onlineContact.Type__c;
                                        wrap.onlineContact.WLEc_Juris__c = materialsMap.get(perSeatProducts).get(tempindex).onlineContact.WLEc_Juris__c;
                                        wrap.onlineContact.Position__c = materialsMap.get(perSeatProducts).get(tempindex).onlineContact.Position__c;
                                        wrap.isSelected = true;
                                        materialsMap.get(strKey).set(materialsMap.get(strKey).indexof(wrap),wrap);
                                        count = count+1;
                                    }
                                }
                            }else{
                                minindex = materialsMap.get(strKey).indexof(wrap);
                                maxindex = materialsMap.get(strKey).size()-1;
                                break;
                            }
                        }
                    }
                }           
                for(APLIWrapper aw :awlist) {
                    if(count<=(awlist.size()+existcon.size())){
                        if(count>=quantity){
                            break;
                        }else{
                            APLIWrapper awnew = new APLIWrapper();
                            awnew.onlineContact.Account__c = aw.onlineContact.Account__c; 
                            awnew.onlineContact.APTS_Source_System_Detail__c = aw.onlineContact.APTS_Source_System_Detail__c;
                            awnew.onlineContact.QuoteId__c = proposalId;
                            awnew.materialNo = strKey;           
                            awnew.isNewContact = true;
                            awnew.isSelected = true;
                            awnew.onlineContact.First_Name__c = aw.onlineContact.First_Name__c;
                            awnew.onlineContact.Middle_Name__c = aw.onlineContact.Middle_Name__c;
                            awnew.onlineContact.Last_Name__c = aw.onlineContact.Last_Name__c;
                            awnew.strEmail = aw.strEmail;
                            awnew.onlineContact.Position__c = aw.onlineContact.Position__c;
                            awnew.onlineContact.Type__c = aw.onlineContact.Type__c;
                            awnew.onlineContact.WLEc_Juris__c = aw.onlineContact.WLEc_Juris__c;  
                            if(materialsMap.containsKey(strKey)){
                                if(minindex>=0 && count-1<=maxindex && minindex<=maxindex){
                                    materialsMap.get(strKey).set(minindex,awnew);          
                                    count = count+1;
                                    minindex = minindex+1;
                                }else{
                                    materialsMap.get(strKey).add(awnew);
                                    count = count+1;
                                }   
                            }else{
                                materialsMap.put(strKey, new  List <APLIWrapper> {awnew});
                                count = count+1;
                            }
                        }
                    }
                }
            } 
        }      
    }

    //DOC-11842 : Method to sort PerSeat products in descending order
    /**
     * @description getbpSelected
     */
    public void sortproductbyquantity(){
        if(productlist.size()>1){
            perseatsize = true;
        }
        System.debug(LoggingLevel.WARN,productlist);
        for(String strKey : productlist){
            Integer quantity = 0;
            if(psCountMap.ContainsKey(strKey)) {
                if(psCountMap.ContainsKey(strKey) && ((psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Cat_L5__c== Label.APTS_GSCPW_RP_Product_Family) || psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'LO' || psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == '51' || psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'AR' ||(psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '13' && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c != 'PE') && (psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'PS') ||(!String.isEmpty(psCountMap.get(strKey).Apttus_Proposal__Product__r.Name) &&  psCountMap.get(strKey).Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage) && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21') ||(psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21'&& psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZEOT') || (psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21'&& psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'MA' && (psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAU' || psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVSU' || psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAM')))){
                    isAddReq = true;
                }else{
                    isAddReq = false;
                }
               
                quantity = integer.valueOf(psCountMap.get(strKey).APTS_Number_of_Attorneys__c);
                if((isAddReq && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Cat_L5__c!= Label.APTS_GSCPW_RP_Product_Family)||(isAddReq && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' && !String.isEmpty(psCountMap.get(strKey).Apttus_Proposal__Product__r.Name) && psCountMap.get(strKey).Apttus_Proposal__Product__r.Name.Contains(System.Label.APTS_CARS_SmallFirmPackage))|| (isAddReq && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZEOT') || (isAddReq && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' && (psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAU' || psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVSU'  || psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Item_Category_Group__c == 'ZVAM') && psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'MA')){
                    quantity = 999;
                }else if(psCountMap.get(strKey).Apttus_Proposal__Product__r.APTS_Cat_L5__c== Label.APTS_GSCPW_RP_Product_Family){
                    quantity = integer.valueOf(psCountMap.get(strKey).APTPS_Quantity_Display__c);
                }
                 //Start: GLP-200
                if (psCountMap.ContainsKey(perSeatProducts) && psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c == '21' && 
                    psCountMap.get(perSeatProducts).Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c == 'CQ') {
                    isAddReq = True;
                    quantity = integer.valueOf(psCountMap.get(strKey).APTPS_Quantity_Display__c);
                }
                //End GLP-200
            }
            prodquanty.put(strKey,quantity);
            qtylist.add(quantity);
        }
        prdqty = prodquanty.clone();
        qtylist.sort();
        System.debug(LoggingLevel.WARN,prodquanty);
        System.debug(LoggingLevel.WARN,qtylist);
        for(Integer i=qtylist.size()-1;i>=0;i--){
            for(String strkey : prodquanty.keyset()){
                System.debug(LoggingLevel.WARN,'strkey' +strkey);
                if(!psCountMap.isEmpty() && psCountMap.ContainsKey(strKey)) {
                    if(prodquanty.get(strkey) == qtylist[i]){
                        if(i==qtylist.size()-1){
                            perSeatProducts = strkey;
                            psMaterial .quantity = prodquanty.get(strkey);
                            if(!psCountMap.isEmpty() && psCountMap.get(strkey)!=null && psCountMap.get(strkey).APTS_Program_ID__c != 'CPRO'){    
                                psMaterial .productName = strkey+' - '+psCountMap.get(strkey).Apttus_Proposal__Product__r.Name; 
                            }else{
                                psMaterial .productName = strkey+' - '+psCountMap.get(strkey).APTS_Product_Name_Override__c;
                            }
                        }
                        if(!psCountMap.isEmpty() && psCountMap.get(strkey)!=null && psCountMap.get(strkey).APTS_Program_ID__c != 'CPRO'){
                        System.debug(LoggingLevel.WARN,'psCountMap'+psCountMap.get(strkey));
                            psProductsList.add(new SelectOption(strkey, psCountMap.get(strkey).Apttus_Proposal__Product__r.Name));
                        }else if(!psCountMap.isEmpty() && psCountMap.get(strkey)!=null && psCountMap.get(strkey).APTS_Program_ID__c == 'CPRO' && psCountMap.get(strkey).Apttus_QPConfig__LineType__c == 'Product/Service'){
                            psProductsList.add(new SelectOption(strkey, psCountMap.get(strkey).APTS_Product_Name_Override__c));
                        }
                    prodquanty.remove(strkey);
                    break;
                    }
                }
            }
        }       
    }
    /**
     * @description getbpSelected
     */
    public void setNAICTab() {
        tabName='NAIC';
    }
   /**
     * @description addRows
     * @return addRows
     */
    //DOC-11572
    public PageReference addRows() {
        system.debug(LoggingLevel.WARN,'Add Row: OdenProducts:'+odenProducts);
        system.debug(LoggingLevel.WARN,'Add Row: oddspMaterials:'+oddspMaterials);
        system.debug(LoggingLevel.WARN,'Add Row: materialsMap:'+materialsMap);
        if(string.isEmpty(odenProducts)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,/*Label.Latam_Product_Validaiton*/'Please select a product before adding new contact'));
            return null;
        }
        for(integer i=0;i<1 ;i++){
          addODOnlineContactsOD();
        }
        //totalpagesize = 1;
        return null;
     }
    
    // Wrapper Class
    /**
     * @description getbpSelected
     */
    public class APLIWrapper {
        /**
     * @description 
     */
        public Boolean isSelected {get; set;}   
          /**
     * @description 
     */     
        public string materialNo {get; set;}
          /**
     * @description 
     */
        public Online_Contacts__c onlineContact {get; set;}      
          /**
     * @description 
     */   
        public Boolean isNewContact {get; set;}
          /**
     * @description 
     */
        public string source {get; set;}  
          /**
     * @description 
     */
        public Boolean evnetIdToAdd {get; set;} 
          /**
     * @description 
     */
        public string strEmail {get; set;}
          /**
     * @description 
     */
        public APLIWrapper() {
            isSelected = False;            
            materialNo = '';
            onlineContact = new Online_Contacts__c();             
            isNewContact = False;  
            source = ''; 
            evnetIdToAdd = False;
            strEmail ='';  
        }          
        
    }  
    
    // per Sheet materials wrapper
      /**
     * @description 
     */
    public class PSMaterials { 
         /**
        * @description 
        */
        public Decimal quantity {get; set;}
          /**
     * @description 
     */
        public string productName {get; set;}
          /**
     * @description 
     */
        
        public PSMaterials() {
            quantity = null;
            productName = '';
        } 
    }   
    
    
    
}
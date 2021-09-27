/**
 * CHANGE HISTORY
 * =============================================================================
 * Date         Name                    Description
 * 2018-09-14   Poorva                     Created                                                                   
 * =============================================================================
 */
public with sharing class Tax_APTS_OnlineContactsController{

    public Apttus_Proposal__Proposal__c aptsProposal {get; set;}
    public List<SelectOption> psProductsList {get; set;}
    public string productsdropdown {get; set;}
    public List<oncWrapper> displayMaterials {get;set;}
    public Apttus_Proposal__Proposal_Line_Item__c currentPLI{get;set;} 
    
    public List<Online_Contacts__c> onlineCon {get; set;} 
    public list<Online_Contacts__c> conToDisplay {get; set;}
    public list<oncWrapper> listoncWrapper = new List<oncWrapper>();
    public list<oncWrapper> listToUpdate = new list<oncWrapper>();
    public Map<String,Online_Contacts__c> onlineContactMap = new Map<String,Online_Contacts__c>();
    public Map<String,Online_Contacts__c> newOCEmailMap = new Map<String,Online_Contacts__c>();
    private Map<String,Apttus_Proposal__Proposal_Line_Item__c> mapPropLineItemId;
    
    CustomIterable obj;
    
    public static integer inc=0;  
    public string searchString {get;set;}
    public String sortBy { get; set; }
    public String sortDir { get; set; }
    public string sortStr {get;set;}
    public String previousSortField{ get; set; }
    public Integer totalpagesize {get;set;}
    public Integer currentPage {get;set;}
    
    private Boolean isexception=false;
    public Boolean isContactDisplayFromAccount{get;set;}
    public Boolean isFromSearchMethod{get;set;}
    private Boolean isAccountlevelSearch;
    
    public Integer rowToRemove {get;set;}
    
    public integer intProductQuantiy;
    public integer total_online_contacts_tfms{get;set;}
    public integer remain_count_of_users {get;set;}
    public Boolean isConcurrent {get;set;}
    
    // Constructor 
    public Tax_APTS_OnlineContactsController(ApexPages.StandardController stdCon) { 
        obj = new CustomIterable(new List<oncWrapper>());
        currentPLI = null;
        totalpagesize = 0;
        intProductQuantiy = 0;
        remain_count_of_users = 0;
        isContactDisplayFromAccount = True;
        isConcurrent = false;
        psProductsList = new List<SelectOption>(); // Used to store product name in dropdown shown in vf page
        mapPropLineItemId = new Map<String, Apttus_Proposal__Proposal_Line_Item__c>();      
        
        system.debug('$$$$constructor starts'+productsdropdown);
        String proposalId = ApexPages.CurrentPage().getParameters().get('id').escapeHtml4();
        aptsProposal = new Apttus_Proposal__Proposal__c();        
        aptsProposal = [Select id,APTS_SSD_Sold_To__r.Source_System_Account_Number__c,
                APTS_Quote_Type__c,Apttus_Proposal__Approval_Stage__c,APTS_SSD_Sold_To__c,
                APTS_SSD_Sold_To__r.APTS_Is_Customer__c,
                APTS_Proposal_Business_Unit__c from Apttus_Proposal__Proposal__c where id =: proposalId];
        system.debug('quoteStatus ----quoteAccepted --------->'+aptsProposal.Apttus_Proposal__Approval_Stage__c)  ;
        system.debug('Label.Apttus_Config2.Generate'+Label.Apttus_Config2.Generate);
        
        //Fetch all New Sales/Renewals/Amended Line items which are not print and are of line Type 'Product/Service'
        list<Apttus_Proposal__Proposal_Line_Item__c> propLIs = [ Select Id, Name,APTPS_Quantity_Display__c, 
        APTS_Service_Number_Override__c,APTS_Product_Name_Override__c,Apttus_Proposal__Product__r.Name,
        Apttus_Proposal__Product__r.Service_Number__c, Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c, 
        Apttus_Proposal__Product__r.APTS_Media_Lower_Level_Code__c,Apttus_QPConfig__LineStatus__c, 
        Apttus_Proposal__Product__r.APTS_Media_High_Level_Code__c,Apttus_Proposal__Product__r.Id,Apttus_QPConfig__PriceUom__c,Apttus_product_variant__c,
        APTS_Is_Print_TP__c, IP_Address_Check__c,Apttus_QPConfig__LineType__c,  APTS_CUAS1__c, Apttus_Proposal__Product__c  
        From Apttus_Proposal__Proposal_Line_Item__c Where Apttus_Proposal__Proposal__c = :aptsProposal.Id
        AND Apttus_QPConfig__LineStatus__c != 'Cancelled' AND Apttus_QPConfig__LineStatus__c != 'Changed Configuration'
        AND  APTS_Is_Print_TP__c != true AND Apttus_QPConfig__LineType__c = 'Product/Service'];
        system.debug('$$$$propLIs'+propLIs+'@@@'+propLIs);
        
        psProductsList.add(new SelectOption('', '--None--'));
        
         for(Apttus_Proposal__Proposal_Line_Item__c pli : propLIs){
            // dropdown
            if(!string.isEmpty(pli.Apttus_Proposal__Product__r.Name)){
                 psProductsList.add(new SelectOption(pli.ID, pli.Apttus_Proposal__Product__r.Name)); 
                 /*if(pli.Apttus_QPConfig__PriceUom__c == 'Concurrent'){
                      concurrencyMap.put(pli.ID,true);
                 }else{
                      concurrencyMap.put(pli.ID,false);
                 }*/    
                 mapPropLineItemId.put(pli.ID,pli);
            }
        }
        mappingLogic();                 
        system.debug('$$$$constructor ends');
    }
    
    /* -------------------------------------------------------------------------------
    Method to perform all the Logics while loading the page/Constructor
    --------------------------------------------------------------------------------*/
    public void mappingLogic() {
        
        system.debug('$$$$mappingLogic starts'+productsdropdown);
        currentPLI = null;
        displayMaterials  = new List<oncWrapper>();
        conToDisplay = new list<Online_Contacts__c>();  
        if(productsdropdown != null && productsdropdown != '' && mapPropLineItemId!=null && mapPropLineItemId.get(productsdropdown)!=null){
            currentPLI = mapPropLineItemId.get(productsdropdown);
            // dropdown assign none first        
        }
        if(currentPLI!=null){
            system.debug('asset No : '+currentPLI.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c);
            intProductQuantiy = Integer.Valueof(currentPLI.APTPS_Quantity_Display__c);
            system.debug('inside intProductQuantiy  1: '+currentPLI);
            //Changes for CUAS + 1 
            if(currentPLI.APTS_CUAS1__c){
                intProductQuantiy++;   
                system.debug('inside intProductQuantiy  2');
            }
            //Changes End
            if(currentPLI.Apttus_QPConfig__PriceUom__c == 'Concurrent'){
                isConcurrent = true;
            }else{
                isConcurrent = false;
            }
            system.debug('Quote type ' + currentPLI.Apttus_QPConfig__LineStatus__c);
        }
        system.debug('$$$$product111'+onlineCon);
        system.debug('$$$$product4444'+productsdropdown);
       
        currentPage =0;
        system.debug('intProductQuantiy ------ '+intProductQuantiy );
        if(isFromSearchMethod == True || isAccountlevelSearch == True){
            isContactDisplayFromAccount = False;
            isFromSearchMethod = false;
            isAccountlevelSearch = false;
        }else{
            isContactDisplayFromAccount=TRUE;
            isFromSearchMethod= false;
            isAccountlevelSearch =false;
        }
        assignESIContacts(); //Alternate development need to change
        
        system.debug('Contact to display grid hardik' + conToDisplay);
        system.debug('display materials' + displayMaterials);
        system.debug('Called from mapping logic' );     
        CountUsersAdded(false);
        system.debug('$$$$$Mapping logic ends');
    }
    
    public void CountUsersAdded(Boolean isCalledAfterSave){
        system.debug('$$$$CountUsersAdded starts'+isCalledAfterSave+'-'+isContactDisplayFromAccount);
        List<oncWrapper> displayMaterialsinside = displayMaterials;
        
        if(currentPLI != null){            
            if(currentPLI.Apttus_QPConfig__PriceUom__c == 'Concurrent' ){
                remain_count_of_users = 0;
            }else{
                remain_count_of_users = 0;
                for(oncWrapper wrpcon : displayMaterialsinside){
                    system.debug('$$$$CountUsersAsses -> selected' + wrpcon.isSelected);
                    if(isContactDisplayFromAccount == false && wrpcon.isSelected == false && isCalledAfterSave)
                        continue;
                    if(wrpcon.isNewContact==true && wrpcon.isSelected==false)
                        continue;
                    System.debug('wrpcon.onlineContact.Tax_Type__c : '+wrpcon.onlineContact.Tax_Type__c);
                    if(wrpcon.onlineContact.Tax_Type__c!=null && wrpcon.onlineContact.Tax_Type__c.equalsIgnoreCase('Admin')){
                        continue;
                    }
                    if(String.isBlank(wrpcon.onlineContact.Latam_Action__c) || wrpcon.onlineContact.Latam_Action__c.equalsIgnoreCase('Add') || wrpcon.onlineContact.Latam_Action__c.equalsIgnoreCase('Update')){
                            remain_count_of_users = remain_count_of_users + 1;
                    }else if (wrpcon.onlineContact.Latam_Action__c.equalsIgnoreCase('Delete')){
                        remain_count_of_users = remain_count_of_users - 1;
                    }
                }
                system.debug('$$$$conflict of users ' +remain_count_of_users + ' : ' + intProductQuantiy );
                remain_count_of_users = intProductQuantiy - remain_count_of_users;
            }
        }
        system.debug('$$$$CountUsersAdded stops');
    }
    
    /* -------------------------------------------------------------------------------    
    map the TFMS(ESI) Online Contacts to each material 
    --------------------------------------------------------------------------------*/
    
    public void assignESIContacts(){
        system.debug('$$$$assignESIContact starts');
        if(!onlineContactMap.IsEmpty())
        {
            onlineContactMap.clear();
            displayMaterials.Clear();
        }
        total_online_contacts_tfms = 0;
        onlineContactsSerialDeserial olDataESI = null;
        system.debug('currentPLI : ' + currentPLI);
        String quoteType = (currentPLI!=null)?currentPLI.Apttus_QPConfig__LineStatus__c:'';
        String assetNumber = (currentPLI!=null)?currentPLI.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c:'';
        String pLIId = (currentPLI!=null)?currentPLI.ID:null;
        system.debug('quoteType : ' + quoteType+' : assetNumber : ' +assetNumber+' : pLIId : '+pLIId+' : proposalId : '+aptsProposal.Id);
        if(isContactDisplayFromAccount == False ||  quoteType == 'Amended' || quoteType == 'Renewed'){
            olDataESI = fetchAccountOnlinePasswords(aptsProposal.APTS_SSD_Sold_To__r.Source_System_Account_Number__c);
        }
        onlineCon = new List<Online_Contacts__c>();
        if(pLIId!=null && pLIId!='' && aptsProposal!=null){
            onlineCon = [Select id,First_Name__c,Last_Name__c,QuoteId__c,Email__c,Tax_Type__c,Is_TFMS__c ,ProductId__c,Material__c,
                        Latam_Action__c,ContactID__c, APTS_Source_System_Detail__c,ProductId__r.Name,Latam_APTS_Asset_Number__c,
                        QuoteLineItem__r.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c,
                        Tax_Position__c, Tax_Username__c, QuoteLineItem__c 
                        from Online_Contacts__c where (QuoteLineItem__c = :pLIId  AND QuoteId__c = :aptsProposal.Id)];
        }
        system.debug('Online Contacts : ' + onlineCon);
        system.debug(' olDataESI : ' + olDataESI);
        if(olDataESI != null){
            system.debug('$$Poorva on line 244 insidel null check');
            If(olDataESI.onlineContact != null) {
                for(onlineContactsSerialDeserial.onlineContact oContacts :olDataESI.onlineContact) {            
                    if(!string.isEmpty(oContacts.contactNumber) ) {
                        Boolean isNoMatch = True;
                        system.debug('@@@@assign'+oContacts);
                        oncWrapper aw = new oncWrapper();                
                        oncWrapper aw1 = assignESIContactsUtil(oContacts, assetNumber, pLIId);
                        system.debug('Eachonlinecntact Hardik'+ aw1.onlineContact);
                        if(aw1.onlineContact != Null){
                            system.debug('Hardikkkkkkkkkkkkkkkkk');
                            if(aw1.assetNo == assetNumber){
                                system.debug('Hardik TFMS Test ' + aw1.onlinecontact);
                                conToDisplay.add(aw1.onlineContact);
                                newOCEmailMap.put(aw1.onlineContact.Email__c.toLowercase(),aw1.onlineContact);
                                onlineContactMap.put(aw1.onlineContact.ContactID__c,aw1.onlineContact);
                                total_online_contacts_tfms = total_online_contacts_tfms + 1;
                            }
                            listoncWrapper.add(existingContacts(aw1.onlineContact));
                        }
                    }
                    system.debug('333333onlineContactMap'+onlineContactMap);
                    system.debug('!!!!!!conToDisplay'+conToDisplay);
                    system.debug('!!!!!!displayMaterials'+displayMaterials);
                } 
            }
        }
        system.debug('!!!!!!!!!!!!!!!!!!!!'+onlineCon);
        for(Online_Contacts__c oc : onlineCon) {
            system.debug('oc.ContactID__c'+oc.ContactID__c);
            system.debug('onlineContactMap'+onlineContactMap.values());
            system.debug('oc.QuoteLineItem__c ' + oc.QuoteLineItem__c);
            system.debug('pLIId hkkkk' + pLIId);
            if(oc.QuoteLineItem__c == pLIId){
                conToDisplay.add(oc);
                system.debug('-----------onlineContactMap.containsKey(oc.ContactID__c )'+onlineContactMap.containsKey(oc.ContactID__c ));
                if(oc.ContactID__c ==null ||oc.ContactID__c =='0'){
                 oc.ContactID__c=String.valueof(inc++);
                }
                if(onlineContactMap.containsKey(oc.ContactID__c )){  
                    onlineContactMap.remove(oc.ContactID__c);
                }
                newOCEmailMap.put(oc.Email__c,oc);
                onlineContactMap.put(oc.ContactID__c,oc);                    
                //code ends here
            }
        }
        system.debug('$$Poorva on line 302 onlineContactMap' + onlineContactMap);
        for(Online_Contacts__c oc :onlineContactMap.values()){
            displayMaterials.add(existingContacts(oc));
        }
        system.debug('$$Poorva on line 309 displayMaterials' + displayMaterials);
        if (math.mod(onlineContactMap.size(), Integer.Valueof(Label.Latam_Page_Size)) > 0) {
            totalpagesize = onlineContactMap.size()/Integer.Valueof(Label.Latam_Page_Size) + 1;
        } else {
            totalpagesize = (onlineContactMap.size()/Integer.Valueof(Label.Latam_Page_Size));
        }
        if(onlineContactMap.size()>0)
            currentPage =0;
        else 
            currentPage =0;
        oncWrapper.sortBy = oncWrapper.SORT_BY.FirstName;
        displayMaterials.sort();
        if(string.isblank(sortStr) && String.isblank(previousSortField)) {
            sortStr='First Name';
            sortDir ='ASC';
        }
        obj = new CustomIterable (displayMaterials); 
        obj.setPageSize = Integer.Valueof(Label.Latam_Page_Size);
        next();
        system.debug('333333onlineContactMap'+onlineContactMap);
        system.debug('222222displayMaterials'+displayMaterials);
        system.debug('$$$$assignESIContact stops'); 
    }   
    
    /* -------------------------------------------------------------------------------    
    Util method to assign the values from the Esi response if contact match found in Online Contacts object.
    --------------------------------------------------------------------------------*/    
    public oncWrapper assignESISelectedContactsUtil(onlineContactsSerialDeserial.onlineContact oContacts, string assetno, Online_Contacts__c olc) {
        oncWrapper aw = new oncWrapper();
        aw.isSelected = True;
        aw.onlineContact = olc; 
        // map the first name and last name and email from missoa response
        aw.onlineContact.First_Name__c = oContacts.address.firstName;
        aw.onlineContact.Last_Name__c = oContacts.address.lastName;
        aw.onlineContact.Email__c = oContacts.address.emailAddress;
        aw.assetNo = assetno;       
        return aw;
    }
       
    /* -------------------------------------------------------------------------------    
    Util method to assign the values from the Dell response if contact match not found in Online Contacts object.
    --------------------------------------------------------------------------------*/    
    public oncWrapper assignESIContactsUtil(onlineContactsSerialDeserial.onlineContact oContacts, string assetnumber, String pLIId) {
        oncWrapper aw = new oncWrapper();
      
        aw.onlineContact.APTS_Source_System_Detail__c = aptsProposal.APTS_SSD_Sold_To__c;
        aw.onlineContact.QuoteId__c = aptsProposal.Id;
        if(oContacts.entitlements != null && oContacts.entitlements[0].subscriptions != null && oContacts.entitlements[0].subscriptions[0].assets != null){    
            aw.assetNo = oContacts.entitlements[0].subscriptions[0].assets[0].assetId;
            aw.onlineContact.Latam_APTS_Asset_Number__c = aw.assetNo;                                      
        }    
        aw.onlineContact.ContactID__c = oContacts.contactNumber;                                      
        aw.onlineContact.First_Name__c = oContacts.address.firstName;
        aw.onlineContact.Last_Name__c = oContacts.address.lastName;
        aw.onlineContact.Email__c = oContacts.address.emailAddress;
        aw.onlineContact.Tax_Position__c = oContacts.jobRole;
        aw.onlineContact.Tax_Type__c = oContacts.contactType;
        aw.onlineContact.Tax_Username__c = oContacts.userName;
        aw.onlineContact.QuoteLineItem__c = pLIId;
        aw.onlineContact.Is_TFMS__c  = true;
        system.debug('aw...'+aw);
        return aw;
    }
    
  
    //Adding existing Onlinecontacts to Wrapper class
    public oncWrapper existingContacts(Online_Contacts__c oc){
        oncWrapper aw = new oncWrapper();
        aw.onlineContact.APTS_Source_System_Detail__c = oc.APTS_Source_System_Detail__c;
        aw.onlineContact.QuoteId__c = oc.QuoteId__c;
        aw.onlineContact.ProductId__c = oc.ProductId__c;
        aw.onlineContact.First_Name__c = oc.First_Name__c;
        aw.onlineContact.Last_Name__c = oc.Last_Name__c;        
        aw.onlineContact.id= oc.id;
        aw.onlineContact.Email__c = oc.Email__c;
        aw.onlineContact.Tax_Type__c = oc.Tax_Type__c;
        aw.onlineContact.Latam_Action__c= oc.Latam_Action__c;
        aw.assetNo = (oc.Latam_APTS_Asset_Number__c !=null)?oc.Latam_APTS_Asset_Number__c :oc.QuoteLineItem__r.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c;
        aw.onlineContact.Latam_APTS_Asset_Number__c = aw.assetNo;            
        aw.onlineContact.ContactID__c =oc.ContactID__c ;
        aw.onlineContact.Is_TFMS__c =oc.Is_TFMS__c ;
        aw.onlineContact.Tax_Position__c = oc.Tax_Position__c;
        aw.onlineContact.Tax_Username__c = oc.Tax_Username__c;
        aw.onlineContact.QuoteLineItem__c = oc.QuoteLineItem__c;
        return aw;
    }
    
    public PageReference add_rows() {
        if(String.isblank(productsdropdown)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Latam_Product_Validaiton));
            return null;
        }
        for(integer i=0;i<1 ;i++){
          addNewOnlineContacts();
        }
        totalpagesize = 1;
        return null;
     }
     
    // Util method to add new contacts in VF page
    public void addNewOnlineContacts() {
        //List to display Onlinecontacts in VF page
        Online_Contacts__c aw = new Online_Contacts__c();
        aw.APTS_Source_System_Detail__c = aptsProposal.APTS_SSD_Sold_To__c;
        aw.QuoteId__c = aptsProposal.Id;
        aw.ProductId__c = currentPLI.Apttus_Proposal__Product__r.Id;        
        aw.QuoteLineItem__c = currentPLI.ID;
        aw.Latam_Action__c ='Add';        
        oncWrapper aw1 = new oncWrapper();
        aw1.onlineContact = aw;
        aw1.evnetIdToAdd=True;
        aw1.isNewContact = True;
        aw1.isSelected = True;
        displayMaterials.add(aw1);
        system.debug('%%%%%%%%'+displayMaterials);
    }
    
    // Save Method to navigate to Proposal.
    public Boolean save_close(){
        isexception = false;
        Integer oldremain_count_of_users = remain_count_of_users;
        Integer noOfUserAdded =  0 ;
        System.debug('Conflict Of User'+remain_count_of_users+'-'+intProductQuantiy);
        // Added By poorva as, when the conflict is zero, users shud not be able to save more online contacts from TFMS.
        if(remain_count_of_users != intProductQuantiy  && isContactDisplayFromAccount == false && !isConcurrent){               // CountUsersAdded();
            System.debug('$$Number of USer :- '+ noOfUserAdded + '&& Conflict Of User'+remain_count_of_users);
            noOfUserAdded =  intProductQuantiy - remain_count_of_users;            
            
        }   
      
        List<Online_Contacts__c> newOnCon = New List<Online_Contacts__c>();
        List<Online_Contacts__c> onlineContactList = New List<Online_Contacts__c>();
        List<Online_Contacts__c > removeOLContact= new List<Online_Contacts__c >();
        Boolean IsSameCotactFound = false;
        system.debug('%%%%%%%%1111'+displayMaterials);
        Boolean b1 = False;
        Boolean b2 = False;            
        integer recinsertcount=0;
           
        String assetNumber = (currentPLI!=null)?currentPLI.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c:''; 
        List<oncWrapper> displayMaterialstemp = new List<oncWrapper>(); 
        for(oncWrapper oc1 : displayMaterials){
            system.debug('oc1.isSelected'+oc1.isSelected);
            if(mapPropLineItemId.get(oc1.assetNo) != null){
                oc1.onlineContact.QuoteLineItem__c = mapPropLineItemId.get(oc1.assetNo).Id ;
            }
            
            if(oc1.eventIdToEdit == True && oc1.isSelected == True){
                //if(String.ISBLANK(oc1.onlineContact.ContactID__c) || oc1.onlineContact.ContactID__c == '0'){
                if(oc1.onlineContact.Is_TFMS__c == false){
                    oc1.onlineContact.Latam_Action__c='Add';  
                }else 
                    oc1.onlineContact.Latam_Action__c='Update';
                if(String.isBlank(oc1.onlineContact.ProductId__c)){
                    oc1.onlineContact.ProductId__c = currentPLI.Apttus_Proposal__Product__r.Id;
                    oc1.assetNo = assetNumber;                   
                }
                newOnCon.add(oc1.onlineContact);
                system.debug('Hardik Edit Old email' + newOCEmailMap);
                system.debug('Hardik Edit new email' + oc1.onlineContact.Email__c);
                if(newOCEmailMap.containsKey(oc1.onlineContact.Email__c)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,Label.Latam_Email_Validaton));                    
                }                    
                System.debug('######Test Edit '+oc1.onlineContact);  
            }
            else if(oc1.eventIdToDelete == True && oc1.isSelected == True){                    
                oc1.onlineContact.Latam_Action__c='Remove';
                if(String.isBlank(oc1.onlineContact.ProductId__c)){
                    oc1.onlineContact.ProductId__c = currentPLI.Apttus_Proposal__Product__r.Id;
                    oc1.assetNo = assetNumber;                   
                }
                if(oc1.onlineContact.Is_TFMS__c == False  || (oc1.onlineContact.Is_TFMS__c == True && oc1.assetNo != currentPLI.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c)){
                    removeOLContact.add(oc1.onlineContact);
                }
                else
                newOnCon.add(oc1.onlineContact);                     
                System.debug('######Test Delete'+oc1.onlineContact);  
            }
            else if(oc1.isSelected == True){
                system.debug('-------------------------------'+productsdropdown+'-----'+mapPropLineItemId.get(productsdropdown).APTPS_Quantity_Display__c);
                String str = '';
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema = schemaMap.get('Online_Contacts__c');
                Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                if(String.IsBlank(oc1.onlineContact.First_Name__c)){
                    String fNameLabel = fieldMap.get('First_Name__c').getDescribe().getLabel();
                    str = (str==null || str=='')?fNameLabel:str+', '+fNameLabel;
                }
                if(String.IsBlank(oc1.onlineContact.Last_Name__c)){
                    String fNameLabel = fieldMap.get('Last_Name__c').getDescribe().getLabel();
                    str = (str==null || str=='')?fNameLabel:str+', '+fNameLabel;
                }
                if(String.IsBlank(oc1.onlineContact.Tax_Type__c)){
                    String fNameLabel = fieldMap.get('Tax_Type__c').getDescribe().getLabel();
                    str = (str==null || str=='')?fNameLabel:str+', '+fNameLabel;
                }
                if(String.IsBlank(oc1.onlineContact.Email__c)){
                    String fNameLabel = fieldMap.get('Email__c').getDescribe().getLabel();
                    str = (str==null || str=='')?fNameLabel:str+', '+fNameLabel;
                }
                if(str!=null && str!=''){
                    isexception=true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Latam_FN_LN_Email_MandatoryValidation+' '+str));
                    return null;
                }
                  
                system.debug('Hardikkkkkkkkkkkk newOCEmailMap ' + newOCEmailMap);
                system.debug('Hardikkkkkkkkkkkk newOnCon ' + newOnCon);
                system.debug('Online COntact add' + oc1.onlineContact);
                system.debug('Contact to display' + conToDisplay);
                
                for(Online_Contacts__c con1 : conToDisplay){
                    if(con1.ContactID__c == oc1.onlineContact.ContactID__c){
                        IsSameCotactFound = true;
                    }
                }
                         
                if(IsSameCotactFound){
                    isexception=true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error ,'Same user is already exists.'));
                }else{                    
                    if(isContactDisplayFromAccount == False) {
                        oc1.onlineContact.Latam_Action__c='Add';
                        oc1.onlineContact.ProductId__c = currentPLI.Apttus_Proposal__Product__r.Id;
                        oc1.assetNo = assetNumber;                   
                        if(mapPropLineItemId.get(oc1.assetNo) != null){
                            oc1.onlineContact.QuoteLineItem__c = mapPropLineItemId.get(oc1.assetNo).Id ;
                        }
                    }
                    newOnCon.add(oc1.onlineContact);
                    system.debug('Hardik add Old email' + newOCEmailMap);
                    system.debug('Hardik add new email' + oc1.onlineContact.Email__c);
                    if(newOCEmailMap.containsKey(oc1.onlineContact.Email__c)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,Label.Latam_Email_Validaton));
                    }else{
                        newOCEmailMap.put(oc1.onlineContact.Email__c.toLowercase(),oc1.onlineContact);                        
                    }
                }
                System.debug('######Test insertion'+oc1.onlineContact+'@@@@'+ oc1.isSelected);  
                recinsertcount ++;                     
            }
        }
        
        system.debug('Contact to display grid hardik' + conToDisplay);
        system.debug('Online Contacts hardik' + onlineCon);
        system.debug('New Online Contact hardik' + newOnCon);
        system.debug('Called from sav_close logic' ); 
        CountUsersAdded(true);
        system.debug('CountUsersAdded after : ' +remain_count_of_users  + ' : '+noOfUserAdded); 
        remain_count_of_users  = remain_count_of_users  - noOfUserAdded ;
        system.debug('isContactDisplayFromAccount hardik' + isContactDisplayFromAccount);
        
        if(remain_count_of_users < 0  && !isConcurrent){
            system.debug('inside count excep : ' +remain_count_of_users + ' : '+isConcurrent); 
            remain_count_of_users = oldremain_count_of_users;
            isexception=true;
            removeduplicateemails(newOnCon);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Latam_Quantiy_Validaion));
            return null;
        }      
        System.debug('newOnCon : '+newOnCon);     
        System.debug('remain_count_of_users : '+remain_count_of_users);     
        If(!newOnCon.isEmpty() && remain_count_of_users >= 0){ 
            upsert newOnCon;    
            System.debug('inserted : '+newOnCon);          
        }
        System.debug('removeOLContact : ' + removeOLContact);
        if(!removeOLContact.isempty()){
            removeduplicateemails(removeOLContact);
            delete removeOLContact;               
        }
            
        System.debug('@@@@Contact insertion' + newOnCon);
            
        refresh();
        return null;
    }
   
    public void removeduplicateemails(List<Online_Contacts__c> newOnCon){
        if(newOnCon != null){
            for(Online_Contacts__c oc5: newOnCon){
                newOCEmailMap.remove(oc5.Email__c);
            }
        }
    }
   
    // Cancel Method to navigate to Proposal.
    public PageReference cancel() {
        updatePropLineItems();
        PageReference prop = new PageReference('/'+aptsProposal.Id);
        return prop;
       
    }
   
    
    public onlineContactsSerialDeserial fetchAccountOnlinePasswords(string sapNum){
        onlineContactsSerialDeserial olDataESI = null;
        system.debug('callFromRefresh : '+callFromRefresh);
        if(callFromRefresh==true)return olDataESI;
        WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('TaxProfessional_OnlineContact');  
        system.debug('oWebServiceSettings...'+oWebServiceSettings);
        
        Http http = new Http();
        HttpResponse resp = new HttpResponse();
        HttpRequest req = new HttpRequest();
        
        try{
            //OAutth Code
            String grantType = 'client_credentials';
            String contentType= 'application/x-www-form-urlencoded';
            String accessToken = ' ';
            if(!Test.isRunningTest()){
                accessToken = DellBoomiTokenGeneration.getAuthToken();
            }
            
            OnlineContactsSerializeandDeserialize.GetOCBySAPAccountRequest_Tax smpReq = new OnlineContactsSerializeandDeserialize.GetOCBySAPAccountRequest_Tax(); 
            smpReq.BOOMIHeader.applicationId  = 'SF12';
            smpReq.account.accountNumber = sapNum;         
            string strBody = JSON.serialize(smpReq);
            system.debug('strBody...'+strBody);
                
            req.setMethod('POST');
            req.setEndpoint(oWebServiceSettings.Endpoint__c);
            req.setHeader('Authorization','Bearer '+accessToken);                
            req.setHeader('Content-Type', contentType);
            req.setHeader('grant_type', grantType);
            req.setBody(strBody);
            req.setTimeout((oWebServiceSettings.Timeout__c * 1000).intValue());
            
            if(!Test.isRunningTest()) {
                resp = http.send(req);
            }
            else {
                resp.setStatusCode(200);
                resp.setBody('{"onlineContact":[{"contactNumber":"322","contactType":"User","address":{"firstName":"HI","lastName":"HELLO","emailAddress":"HI.HELLO17@THOMSONREUTERS.COM"},"account":{"accountNumber":"2000012090"},"entitlements":[{"applicationId":"WLAR","status":"ACTIVE","appUserGuid":"i0acea6010000016817a1c3610f00654d","accessStartDate":"2019-01-04 06:51:47","accessEndDate":"2019-12-31 00:00:00","subscriptions":[{"material":[{"materialNumber":"14544"}], "assets": [{"assetId": "A-4978375"}]}]}],"userStatus":["ACTIVE"],"onlineContactType":"110"}]}');
            }
        }catch(Exception e){
            System.debug('EXcpetion : '+e.getStackTraceString());
            System.debug('EXcpetion : '+e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error occured while fetching the Online Contacts from TFMS'));
        }
        string strRes = resp.getBody();
        system.debug('strRes..'+strRes);    
        system.debug('strRes..'+resp.getStatusCode());   
        if(resp.getStatusCode() == 200) {              
            olDataESI = (onlineContactsSerialDeserial) System.JSON.deserialize(resp.getbody(), onlineContactsSerialDeserial.class);
            if(olDataESI==null || olDataESI.onlineContact==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'No Online Contacts found in TFMS'));
               system.debug('inside blank respone');
            }
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error occured while fetching the Online Contacts from TFMS'));
        }
        system.debug('olDataESI...'+olDataESI);
        return olDataESI;
    }
    
    // Save Method to navigate to Proposal.
    public PageReference undo_close(){
           
        system.debug('%%%%%%%%1111'+displayMaterials);
        List<oncWrapper> displayMaterials1= new List<oncWrapper>();
        system.debug('%%%%%%%%11113'+displayMaterials);
        for(oncWrapper oc1 : displayMaterials){
            if(oc1.eventIdToUndo == True){
                if(oc1.eventIdToDelete == True){
                    oc1.eventIdToDelete = False;
                    oc1.eventIdToUndo = False;
                    oc1.isSelected = false;
                    system.debug('-------------------------------'+oc1.PrevAction+'--'+oc1.onlineContact.Latam_Action__c+'--'+oc1.onlineContact.First_Name__c);
                    oc1.onlineContact.Latam_Action__c=oc1.PrevAction;
                }
                if(oc1.eventIdToEdit == True){
                    oc1.eventIdToEdit = False;
                    oc1.eventIdToUndo = False;
                    oc1.isSelected = false;
                    system.debug('-------------------------------'+oc1.prevEmail+'-----------'+oc1.PrevAction+'--'+oc1.onlineContact.Latam_Action__c+'--'+oc1.onlineContact.First_Name__c);
                    oc1.onlineContact.Latam_Action__c=oc1.PrevAction;
                    oc1.onlineContact.Email__c=oc1.prevEmail;
                }
            }
            if(oc1.eventIdToDelete == True){
                system.debug('-------------------------------'+oc1.PrevAction+'--'+oc1.onlineContact.Latam_Action__c+'--'+oc1.onlineContact.First_Name__c);
                system.debug('oc1.onlineContact.Is_TFMS__c : '+oc1.onlineContact.Is_TFMS__c+' : oc1.assetNo : '+oc1.assetNo+' : currentPLI.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c : '+currentPLI.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c);
                oc1.PrevAction = oc1.onlineContact.Latam_Action__c;
                oc1.isSelected = true;
                if(oc1.onlineContact.Is_TFMS__c == False || (oc1.onlineContact.Is_TFMS__c == True && oc1.assetNo != currentPLI.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c)){
                    oc1.onlineContact.Latam_Action__c='';
                }else{
                    oc1.onlineContact.Latam_Action__c='Remove';
                }    
                system.debug('-------------------------------'+oc1.PrevAction+'--'+oc1.onlineContact.Latam_Action__c+'--'+oc1.onlineContact.First_Name__c);
            }
            if(oc1.eventIdToEdit == True){
                system.debug('-------------------------------'+oc1.prevEmail+'---'+oc1.PrevAction+'--'+oc1.onlineContact.Latam_Action__c+'--'+oc1.onlineContact.First_Name__c);
                oc1.PrevAction = oc1.onlineContact.Latam_Action__c;
                oc1.prevEmail=oc1.onlineContact.Email__c;
                oc1.isSelected = true;
                //if(String.ISBLANK(oc1.onlineContact.ContactID__c) || oc1.onlineContact.ContactID__c == '0'){
                if(oc1.onlineContact.Is_TFMS__c == false){
                    oc1.onlineContact.Latam_Action__c='Add';  
                }else 
                    oc1.onlineContact.Latam_Action__c='Update'; 
                system.debug('-------------------------------'+oc1.prevEmail+'---'+oc1.PrevAction+'--'+oc1.onlineContact.Latam_Action__c+'--'+oc1.onlineContact.First_Name__c);
            }
            //eventIdToUndo
        }
        displayMaterials1 = displayMaterials.clone();
        for ( Integer i = displayMaterials.size() - 1; i >= 0; --i )
        { 
            displayMaterials.remove(i);
        }
        displayMaterials.addall(displayMaterials1);
        return null;
    }
   
    

    //    ===================================================
    public Boolean hasNext {
        get{
            return obj.hasNext();
        }
        set;
    }
        
    public Boolean hasPrevious {
        get{
            return obj.hasPrevious();
        }
        set;
    }
        
       
    public void next(){
        displayMaterials= obj.next();
        currentPage +=1;
    }
        
    public void previous(){
        currentPage -=1;
        displayMaterials = obj.previous();
    }
        
  
    //=============================================================

    public List<oncWrapper> sortByNameList(){      
        List<String>FNList = new List<String>();
        List<String>LNList = new List<String>();
        List<String>EmailNList = new List<String>();
        List<Online_Contacts__c>firstNameONCList=new List<Online_Contacts__c>();
        map<String,Online_Contacts__c> emailMap= new Map<String,Online_Contacts__c>();
        List<String> orderingList = new List<String>();    
        system.debug('sortStr'+sortStr);

        if(previousSortField == sortStr){
            sortDir= 'DESC';
            previousSortField = null;
        }else{
            previousSortField = sortStr;
            sortDir = 'ASC';
        }
                      
        system.debug('karthik------'+sortStr+'-------------'+sortDir);
         
        if(listoncWrapper.isEmpty()){
            mappinglogic();
        }
            
        List<oncWrapper> cloneContactList = new List<oncWrapper>();
        if(isContactDisplayFromAccount==False && !listoncWrapper.isEmpty() && isAccountlevelSearch == True )
            cloneContactList = listoncWrapper;
        else 
            cloneContactList = displayMaterials;
        system.debug('displayMaterials'+displayMaterials.size());
        if(FNList.size()>0)FNList.clear();
        if(firstNameONCList.size()>0)  firstNameONCList.clear();
        if(displayMaterials.size()>0){
            for(oncWrapper oc : cloneContactList){
                FNList.add(oc.onlinecontact.First_Name__c);
                LNList.add(oc.onlinecontact.Last_Name__c);
                EmailNList.add(oc.onlinecontact.Email__c);
                firstNameONCList.add(oc.onlineContact);
            } 
        }
        if(orderingList.size()>0) 
            orderingList.clear();
        system.debug('FNList.size()'+FNList.size());
        if(sortStr =='First Name')
            orderingList.addAll(FNList);   
        else if(sortStr =='Last Name')        
            orderingList.addAll(LNList);    
        else if(sortStr =='Email')       
            orderingList.addAll(EmailNList);    
        orderingList.sort();
        system.debug('orderingList----------------'+orderingList);
        if(displayMaterials.size()>0)
            displayMaterials.clear();
        system.debug('firstNameONCList'+firstNameONCList.size());
        if(sortDir == 'ASC') {
            emailMap.clear();
            for (Integer i =0; i<= orderingList.size()-1;  i++) 
            {
              for (Online_Contacts__c  oc2 : firstNameONCList)
                {
                    if( sortStr =='First Name' && oc2.First_Name__c==orderingList[i]  &&!emailMap.ContainsKey(oc2.email__C) ){
                        emailMap.put(oc2.email__C,oc2);
                        displayMaterials.add(existingContacts(oc2)); 
                    }else if( sortStr =='Last Name' && oc2.Last_Name__c==orderingList[i]  &&!emailMap.ContainsKey(oc2.email__C)){
                        emailMap.put(oc2.email__C,oc2);
                        displayMaterials.add(existingContacts(oc2) ); 
                    } else if( sortStr =='Email' && oc2.Email__c==orderingList[i] &&!emailMap.ContainsKey(oc2.email__C)){
                        emailMap.put(oc2.email__C,oc2);
                        displayMaterials.add(existingContacts(oc2)); 
                    }
                }
            }
        }else {
            emailMap.clear();
            for (Integer i = orderingList.size()-1; i >= 0; i--) {
                for (Online_Contacts__c  oc2 : firstNameONCList)
                {
                    if( sortStr =='First Name' && oc2.First_Name__c==orderingList[i]  &&!emailMap.ContainsKey(oc2.email__C) ){
                     system.debug('4');
                     emailMap.put(oc2.email__C,oc2);
                     emailMap.put(oc2.email__C,oc2);
                       displayMaterials.add(existingContacts(oc2)); 
                    }else if( sortStr =='Last Name' && oc2.Last_Name__c==orderingList[i]  &&!emailMap.ContainsKey(oc2.email__C)){
                     system.debug('5');
                     emailMap.put(oc2.email__C,oc2);
                     displayMaterials.add(existingContacts(oc2) ); 
                    } else if( sortStr =='Email' && oc2.Email__c==orderingList[i] &&!emailMap.ContainsKey(oc2.email__C)){
                     system.debug('6');
                     emailMap.put(oc2.email__C,oc2);
                      displayMaterials.add(existingContacts(oc2)); 
                    }
                }
            }
        }
        system.debug('displayMaterials'+displayMaterials);

        if (math.mod(orderingList.size(), Integer.Valueof(Label.Latam_Page_Size)) > 0) {
            totalpagesize = orderingList.size()/Integer.Valueof(Label.Latam_Page_Size) + 1;
        } else {
            totalpagesize = (orderingList.size()/Integer.Valueof(Label.Latam_Page_Size));
        }
        if(orderingList.size()>0)
            currentPage =0;
        else 
            currentPage =0;
        obj = new CustomIterable (displayMaterials); 
        obj.setPageSize = Integer.Valueof(Label.Latam_Page_Size);
        next();
        return null;
    }
    //=============================================================

    public PageReference displayAccountContacts(){
            
        List<oncWrapper> displayMaterials1= new List<oncWrapper>();
        listoncWrapper = new List<oncWrapper>();
        system.debug('isContactDisplayFromAccount '+isContactDisplayFromAccount );
        system.debug('%%%%%%%%1111 yes it is at 888'+listoncWrapper.size());

        if(String.isblank(productsdropdown)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Latam_Product_Validaiton));
            return null;
        } 
        isAccountlevelSearch=True;
        if(listoncWrapper.isEmpty())
        {
            mappinglogic();
            if(displayMaterials.size() >0)   {
                displayMaterials.clear();
            }                 
        }
        else {
            isContactDisplayFromAccount =False;
        }
        system.debug('%%%%%%%%1111 yes it is at 903'+listoncWrapper.size());
        if(displayMaterials1.size()>0) displayMaterials1.clear();
        for(oncWrapper oc1 : listoncWrapper  ){
            oc1.eventIdToEdit =False;
            oc1.evnetIdToAdd=False;
            oc1.eventIdToDelete=False;
            displayMaterials1.add(oc1);
        }  
             
        if(displayMaterials1.size()>0)
        {   
            system.debug('Size'+displayMaterials1.size());
            system.debug('Size------'+displayMaterials.size());
             displaySortList(displayMaterials1);
        }
             
        return null;
    }
   
    public PageReference searchOnlineContacts(){
        List<oncWrapper> displayMaterials1= new List<oncWrapper>();
        List<oncWrapper> listoncWrapper1 = new List<oncWrapper>();
        isFromSearchMethod = TRUE;

        if(String.isblank(productsdropdown)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Latam_Product_Validaiton));
            return null;
        }
        if(String.isblank(searchString)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Latam_Search_Validation));
            return null;
        }
        if(listoncWrapper.isEmpty())
        {
            mappinglogic();
        }
        if (isAccountlevelSearch == true)
            isAccountlevelSearch=false;
        system.debug('%%%%%%%%1111'+listoncWrapper);
        system.debug('listoncWrapper'+listoncWrapper.size());
        system.debug('displayMaterials'+displayMaterials.size());
        if(displayMaterials1.size()>0) 
            displayMaterials1.clear();
        system.debug('displayMaterials'+displayMaterials);
      
        for(Online_Contacts__c oc : onlineCon) 
        {
            listoncWrapper1.add(existingContacts(oc));
        }
        system.debug('onlineCon'+onlineCon);
        for(oncWrapper oc1 : listoncWrapper){
           listoncWrapper1.add(oc1);
        }
        system.debug('listoncWrapper1'+listoncWrapper1);
        for(oncWrapper oc1 : listoncWrapper1){
            if(!String.isBlank(oc1.onlineContact.First_Name__c) && !String.isBlank(oc1.onlineContact.Email__c) && !String.isBlank(oc1.onlineContact.Last_Name__c)){
                system.debug('oc1.onlineContact.First_Name__c'+oc1.onlineContact.First_Name__c +''+searchString+'--------------'+oc1.MaterialNo);
                if(oc1.onlineContact.First_Name__c.toLowercase().Contains(searchString.toLowercase())
                 || oc1.onlineContact.Email__c.toLowercase().Contains(searchString.toLowercase()) 
                 || oc1.onlineContact.Last_Name__c.toLowercase().Contains(searchString.toLowercase()))
                { 
                   system.debug('oc1.onlineContact.First_Name__c11111'+oc1.onlineContact.First_Name__c +''+searchString);
                   system.debug('Sriranga'+oc1.MaterialNo);
                   displayMaterials1.add(oc1);
                }
            }
        }
                   
        if(displayMaterials1.size()>0)
        {   
            displaySortList(displayMaterials1);
        }else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Latam_OC_NoMatch_Validation));
            if(displayMaterials.size()>0) displaymaterials.clear();
                return null;
        }
        return null;
    }
   
    //Method used to save the record and redirect back to Quote page.
    public PageReference saveRecordAndExit(){
        save_close();          
        if(isexception == true || !validateMinOCPresent()){ 
            return null;  
        }else{
            updatePropLineItems();
            PageReference proposalPage= new PageReference('/'+aptsProposal.Id);
            proposalPage.setRedirect(true);
            isexception=false;                           
            return proposalPage;
        }
    }
    
    public PageReference  resetOnlineContacts(){  
        List<Online_Contacts__c > removeOLContact= new List<Online_Contacts__c >();
        try{
            removeOLContact=[Select id,First_Name__c,Last_Name__c,QuoteId__c,Email__c,Tax_Type__c,Is_TFMS__c ,ProductId__c,
                            Material__c,Latam_Action__c,ContactID__c,APTS_Source_System_Detail__c,ProductId__r.Name,
                            QuoteLineItem__r.Apttus_QPConfig__AssetLineItemId__r.Asset_Auto_Number__c,
                            Tax_Position__c, Tax_Username__c 
                            from Online_Contacts__c 
                            where (ProductId__c =: currentPLI.Apttus_Proposal__Product__r.Id AND QuoteId__c =: aptsProposal.Id) ];
        }catch(Exception e){
            System.debug('Exception : '+e.getStackTraceString());
        }
        if(!removeOLContact.isEmpty()){ 
            removeduplicateemails(removeOLContact);
            delete removeOLContact;
        }           
        displayMaterials.clear();
        refresh();
        return null;
    }
    
    public PageReference removeOnlineContactRowFromDisplayList(){ 
        system.debug('rowToRemove-------------'+rowToRemove);
        system.debug('display materials'+displayMaterials.size());
        if(displayMaterials.size() >0){
            if(displayMaterials.size()==rowToRemove)
                displayMaterials.remove(rowToRemove-1);
            else 
                displayMaterials.remove(rowToRemove);
            system.debug('inside');
            --rowToRemove;
        }
        system.debug('rowToRemove-------------'+rowToRemove);
        system.debug('display materials'+displayMaterials.size());
        return null;
    }
    
    public boolean callFromRefresh = false;
    public void refresh(){
        if(displayMaterials.size()>0)
            displayMaterials.clear();
        
        conToDisplay = new list<Online_Contacts__c>();
        callFromRefresh = true;
        assignESIContacts(); 
        callFromRefresh = false;
        if(isContactDisplayFromAccount == False)
            isContactDisplayFromAccount = True;
        displaySortList(new List<oncWrapper>());
        system.debug('Called from refresh logic' ); 
        CountUsersAdded(false);
    }  
      
    public void displaySortList(List<oncWrapper> onlineContactDisplayList){
        if(onlineContactDisplayList.size()>0)
        {   
            system.debug('Size'+displayMaterials.size());
            system.debug('Size------'+onlineContactDisplayList.size());
            system.debug('displayMaterials'+displayMaterials);
            displayMaterials.clear();
            displayMaterials.addall(onlineContactDisplayList);
            system.debug('onlineContactDisplayList'+onlineContactDisplayList);
            if (math.mod(onlineContactDisplayList.size(), Integer.Valueof(Label.Latam_Page_Size)) > 0) {
                totalpagesize = onlineContactDisplayList.size()/Integer.Valueof(Label.Latam_Page_Size) + 1;
            } else {
                totalpagesize = (onlineContactDisplayList.size()/Integer.Valueof(Label.Latam_Page_Size));
            }                
            currentPage =0;
            oncWrapper.sortBy = oncWrapper.SORT_BY.FirstName;
            system.debug('displayMaterials FIrst'+displayMaterials);
            displayMaterials.sort();
            system.debug('displayMaterials Second'+displayMaterials);
            obj = new CustomIterable (displayMaterials); 
            obj.setPageSize = Integer.Valueof(Label.Latam_Page_Size);
            system.debug('111111');
            next();
        }
    }
   
    //Method to validate that every pli is having online contacts
    private Boolean validateMinOCPresent(){                      
        System.debug('validateMinOCPresent : proposalId : '+aptsProposal.Id);
        Map<String, AggregateResult> pidToOlcCount;
        Boolean minAdmin = false;
        Boolean maxAdmin = false;
        Boolean returnFlag = true;
        try{
            Delete [select Id from Online_Contacts__c where QuoteId__c =: aptsProposal.Id AND QuoteLineItem__c=NULL];
        }catch(Exception e){}
        try{
            pidToOlcCount = new Map<String, AggregateResult>([select QuoteLineItem__c Id, count(id) total from Online_Contacts__c where Tax_Type__c <> 'Admin' AND QuoteId__c =: aptsProposal.Id group by QuoteLineItem__c]);
            List<Online_Contacts__c> olcList = [select Id from Online_Contacts__c where Tax_Type__c INCLUDES('Admin') AND QuoteId__c =: aptsProposal.Id limit 100];
            if(olcList != null && olcList.size()>0){
                minAdmin = true;
            }
            if(olcList != null && olcList.size()>1){
                maxAdmin = true;
            }
        }catch(Exception e){
            System.debug('validateMinOCPresent : Exception : '+e.getMessage()+e.getStackTraceString());
            pidToOlcCount = new Map<String, AggregateResult>();
        }
        Boolean check = false;
        System.debug('validateMinOCPresent : pidToOlcCount : '+pidToOlcCount);
        String productNameErr = '';
        for(String pliID : mapPropLineItemId.KeySet()){
            Apttus_Proposal__Proposal_Line_Item__c tempPLI = mapPropLineItemId.get(pliID);
            System.debug('validateMinOCPresent : tempPLI : '+tempPLI);
            if(tempPLI.Apttus_QPConfig__LineStatus__c == 'Renewed'){
               continue;
            }
            check = false;
            if(pidToOlcCount!=null && pidToOlcCount.get(pliID)!=null && pidToOlcCount.get(pliID).get('Id') == pliID){
                check = true;
            } 
            if(check == false && !tempPLI.IP_Address_Check__c){                    
                productNameErr  = productNameErr + mapPropLineItemId.get(pliID).Apttus_Proposal__Product__r.Name+ ', '; 
            }
            System.debug('validateMinOCPresent : pliID : '+pliID+' : productNameErr : '+productNameErr);
        }          
        System.debug('validateMinOCPresent : productNameErr : '+productNameErr);
        if(!productNameErr.equals('')){
            productNameErr = productNameErr.substring(0, productNameErr.length()-2);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.OnlineContact_Validation_Min1_All+productNameErr +'.'));
            returnFlag = false;
        }
        if(minAdmin == false && aptsProposal.APTS_SSD_Sold_To__r.APTS_Is_Customer__c!=true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.OnlineContact_Validation_MinAdminError));
            returnFlag = false;
        }
        if(maxAdmin == true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.OnlineContact_Validation_MaxAdminError));
            returnFlag = false;
        }
        return returnFlag;
    }
    
    private void updatePropLineItems(){        
        Map<Id,Boolean> oliValidation = new Map<Id,Boolean>();
        Apttus_Proposal__Proposal_Line_Item__c pliObj;
        List<Apttus_Proposal__Proposal_Line_Item__c> pliObjList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        for(Online_Contacts__c olc : [select id, QuoteLineItem__c from Online_Contacts__c where QuoteId__c =: aptsProposal.Id]){
            oliValidation.put(olc.QuoteLineItem__c,True);              
        }
        Boolean ipFlag ;
        for(String pliID : mapPropLineItemId.KeySet()){
            Apttus_Proposal__Proposal_Line_Item__c tempPLI = mapPropLineItemId.get(pliID);
            ipFlag = false;
            if(tempPLI != null){
                ipFlag = tempPLI.IP_Address_Check__c;
            }
            if(oliValidation.containsKey(pliID )){
                pliObj = new Apttus_Proposal__Proposal_Line_Item__c(id = pliId,APTS_Online_Contacts_Validation__c = True,IP_Address_Check__c= ipFlag);
            }else{
                pliObj = new Apttus_Proposal__Proposal_Line_Item__c(id = pliId,APTS_Online_Contacts_Validation__c = False,IP_Address_Check__c= ipFlag);
            }    
            pliObjList.add(pliObj);
        }
        if(!pliObjList.isEmpty()){
            update pliObjList;
        }
    }
    
    public String getTableFacet(){
        String facet = (totalpagesize==null || totalpagesize==0)?'No Records to Display':'Showing Page # '+ currentPage+ ' of ' +totalpagesize;
        return facet;
    }
    
     /******************************************************************************************
    Method Name: taxUpdateAssetLineAfterPLIInsert
    Created By: Poorva Sinha
    Created Date: 17-July-2019
    Purpose: LOC-17382 : update asset auto number after Cart Refinalization.
    *******************************************************************************************/ 
    
    public static void taxUpdateAssetLineAfterPLIInsert(List<Apttus_Proposal__Proposal_Line_Item__c> pliList){
        //Variable Declaration
        Set<ID> olcID = new Set<Id>();
        List<ID> proposalList  = new List<ID>();
        List<Online_Contacts__c> updateOcList=new List<Online_Contacts__c>();
        List<Online_Contacts__c> onlineContactList=new List<Online_Contacts__c>();
        Map<String, List<Online_Contacts__c>> olcMap = new Map<String, List<Online_Contacts__c>>();
        List<Apttus_Proposal__Proposal_Line_Item__c> pliObjList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
            
        for(Apttus_Proposal__Proposal_Line_Item__c pli : pliList){
            if(pli.APTS_Proposal_Business_Unit__c == 'Tax Professional')
                proposalList.add(pli.Apttus_Proposal__Proposal__c);
        }
        System.debug('@@@test prod query--'+proposalList);
        if(proposalList.size()>0) {
            onlineContactList=[Select id, name,ProductId__c from Online_Contacts__c where QuoteId__c in :proposalList];
            for(Online_Contacts__c olc : onlineContactList){
                List<Online_Contacts__c> olcList = new List<Online_Contacts__c>();
                if(olcMap.get(olc.ProductId__c) != null){
                    olcList = olcMap.get(olc.ProductId__c);
                }
                olcList.add(olc);
                olcMap.put(olc.ProductId__c, olcList);
            }
        } 
        System.debug('@@@onlineContactList--'+onlineContactList);
        System.debug('@@@olcMap--'+olcMap);
        if(onlineContactList!=null && onlineContactList.size()>0){
            System.debug('@@@ size onlineContactList.size()--'+onlineContactList.size());
            for(Apttus_Proposal__Proposal_Line_Item__c pli : pliList){
                Boolean flag = false;
                /*if(olcMap.get(pli.Apttus_Proposal__Product__c) != null && pli.Apttus_QPConfig__OptionId__c == null){
                    for(Online_Contacts__c onC : olcMap.get(pli.Apttus_Proposal__Product__c)){
                        onC.Latam_APTS_Asset_Number__c = pli.Asset_Auto_Number__c;
                        onc.QuoteLineItem__c = pli.Id;
                        updateOcList.add(onC);
                    }
                    flag = true;
                }
                if(olcMap.get(pli.Apttus_Proposal__Product__c) != null && pli.Apttus_QPConfig__OptionId__c != null){
                    flag = true;
                }
                if(flag = true){
                */
                if(olcMap.get(pli.Apttus_Proposal__Product__c) != null){
                    for(Online_Contacts__c onC : olcMap.get(pli.Apttus_Proposal__Product__c)){
                        if(!olcID.contains(onC.Id)){
                            onc.QuoteLineItem__c = pli.Id;
                            updateOcList.add(onC);
                            olcID.add(onC.Id);
                        }
                    }
                    Apttus_Proposal__Proposal_Line_Item__c pliObj = new Apttus_Proposal__Proposal_Line_Item__c(id = pli.Id,APTS_Online_Contacts_Validation__c = True);
                    pliObjList.add(pliObj);
                } 
            }
            if(updateOcList.size()>0){
                update updateOcList;
            }
            if(!pliObjList.isEmpty()){
                update pliObjList;
            }
            System.debug('@@@ size updateOcList----'+updateOcList);
        }
    }//End of Method
 
}
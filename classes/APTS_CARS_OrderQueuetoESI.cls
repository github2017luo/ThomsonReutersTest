/**
 * @description APTS_CARS_OrderQueuetoESI
 */
public without sharing class APTS_CARS_OrderQueuetoESI  {
    /**
     * @description orderNo
     * @return orderNo
     */
     public static CreateOrderRequest.orderLines ordline;
    static Map<string, string> materialBrandCodeMap;
    static Map<string, Decimal> materialMap;
    static Map<string, string> bundlematerialMap;
    static CreateOrderRequest ordreq;
    static CreateOrderRequest.UserDetails userDetails;
    static List<CreateOrderRequest.UserDetails> userDetailsinfo;
    public static string orderNo {get; set;}
    
    //SOC-3625
    static Boolean wNproduct=false;
    
    
    // method to execute and callout to ESI
    /**
     * @description orderSubmissionToESICARS
     * @return orderSubmissionToESICARS
     * @param orderNum
     */
    public static  APTS_Ordersubmissionwrapper orderSubmissionToESICARS(Id orderId) {
        // Variables
       // orderNo = orderNum;
        ordline = new CreateOrderRequest.orderLines();
        Boolean isOnline = false;
        Integer lineNumber=1;
        Integer fillupLineNumber=1; // To Count the Fillup LineItems
        Integer plNum = 0; // Primary Line Nymber for Fillup line items.
        Boolean isModeA = false;
        Boolean isModeW = false;
        Boolean isFillup = False; // To Identify if order line is Fillup
        Boolean isSubFee = False; // To Identify if Order line is Fillup and charge type is Subscription Fee
        Boolean isSubFeeOrder = False; //  To Identify if Order line is Fillup and assign to tempory order variable to rearrange the sequence of Fillups
        Boolean isFillupOption = False; // To Identify if Order line is Fillup and LineType is option
        Boolean isFillupOnly = False;
        Boolean isProflexBLI = False; // DOC-12198
        Boolean isProflex=false;
        Decimal periodicValue=0;
        Boolean blnIsCaseLine=false; //DOC-15023
    //SOC 5107
        Decimal oneTimeValue=0;
        materialMap = new Map<string, Decimal>();
        bundlematerialMap = new Map<string, string>();
        Map<string, Integer> countMap = new Map<string, Integer>();
        //Map<Id,Sobject> ownerMap = new Map<Id,Sobject>();
        List<Id> ownerId = new List<Id>();
        materialBrandCodeMap = new Map<string, string>();
        Apttus_Config2__OrderLineItem__c oli = new Apttus_Config2__OrderLineItem__c();
        CreateOrderRequest.orderLines subFeeOrder = new CreateOrderRequest.orderLines();
        CreateOrderRequest.MLAInfo multiLoc= new CreateOrderRequest.MLAInfo();
        CreateOrderRequest.MLAHeader mlaHeader;// = new CreateOrderRequest.MLAHeader(); //DOC-9689 
        List<CreateOrderRequest.MLAHeader> mlaHeaderinfo = new List<CreateOrderRequest.MLAHeader>();
        CreateOrderRequest.CustomerGroup customerGroup = new CreateOrderRequest.CustomerGroup();
        List<CreateOrderRequest.CustomerGroup> customerGroupinfo= new List<CreateOrderRequest.CustomerGroup>();
        CreateOrderRequest.CustomerDetails  customerDetails= new CreateOrderRequest.CustomerDetails ();
        List<CreateOrderRequest.CustomerDetails> customerDetailsinfo= new List<CreateOrderRequest.CustomerDetails>();
        CreateOrderRequest.ContentMaterials contentMaterials = new CreateOrderRequest.ContentMaterials();
        List<CreateOrderRequest.ContentMaterials> contentMaterialsinfo= new List<CreateOrderRequest.ContentMaterials>();
        UserDetails= new CreateOrderRequest.UserDetails();
        UserDetailsinfo = new List<CreateOrderRequest.UserDetails>();
        CreateOrderRequest.adjustments fillupadjustment= new CreateOrderRequest.adjustments();
        //Boolean isBundleAdded = False;
        //string curBundlGroup = '';
        string mlAcc = '';
        Boolean isMLAModify=false;
        Boolean isnotMLAModify = False;
        Boolean isMLAReplace = False; // Soc- 3465
        Boolean isReplaceMode = false; //DOC-9689
        String numberOfAttorneys =''; //DOC-9689
        Boolean qtyChange;//Soc-3835 && SOC-3839
        Boolean edltproduct;//Soc-3835 && SOC-3839
        string flEmail = '';
        Integer dealSerialNumber = 0; //SOC-5358
        //Integer dealLineNumber = 0; //SOC-5358
        //Integer cprolinenumber = 0; //SOC-7059
        Apttus_Config2__Order__c order;
        String vCARSPrintPrimary;
        String vCARSEDLTproduct;
        String vCARSMLAAgreementNumber;
        String vCARSMLAAgreement;
        String vRiskRIProfessionalServices = '';
        String vCLValidProflex; //DOC-14661
        Boolean blnIsContactRequired = false; //DOC-11983: Jinal Bhatt
        String bundlePrimMaterial='';
            
        if(!Schema.sObjectType.APTS_Integration_Variables__mdt.isAccessible()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
        }
        List<APTS_Integration_Variables__mdt> orderSubmissionEsiList=[Select MasterLabel,Value__c from APTS_Integration_Variables__mdt];
        for(APTS_Integration_Variables__mdt var : orderSubmissionEsiList){
            if(var.masterlabel=='CARS_Print_Primary') {
                vCARSPrintPrimary=var.Value__c;
            }
            if(var.masterlabel=='CARS_EDLTproduct') {
                vCARSEDLTproduct=var.Value__c;
            }
            if(var.masterlabel=='CARS_MLAAgreementNumber') {
                vCARSMLAAgreementNumber=var.Value__c;
            }
            if(var.masterlabel=='CARS_MLAAgreement') {
                vCARSMLAAgreement=var.Value__c;
            }
            if(var.masterlabel.contains('Risk RI Professional Services')) {              
                 vRiskRIProfessionalServices = vRiskRIProfessionalServices + var.Value__c;
            }
            // DOC-14661
            if(var.masterlabel.contains('Caseline Valid Proflex')){
                vCLValidProflex = var.Value__c;
            }
        }
        List<String> materialNumberList = new List<String>();
        materialNumberList=vCARSMLAAgreementNumber.split(',');
        List<String> materialNumberList1 = new List<String>();
        materialNumberList1=vCARSMLAAgreement.split(',');
        Boolean runOldOrderProcess = false;
        KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
        if(keyValueListRec !=NULL){
            runOldOrderProcess = TRUE;
        }
        APTS_Ordersubmissionwrapper ordersubwrap = new APTS_Ordersubmissionwrapper();
        String loggerId;
        List<Integration_Logger__c> intLogList = new List<Integration_Logger__c>();
        try {
            isOnline = False;
            List<Apttus_Config2__OrderLineItem__c> orderLineItems=new List<Apttus_Config2__OrderLineItem__c>();
            User proposalOwner ;
            List<Online_Contacts__c> onlinecon = new List<Online_Contacts__c>();
            List<Customer_Master_Contacts__c> mastercon = new List<Customer_Master_Contacts__c>();
            list<APTS_Additional_Subscription_Actions__c> additionalSublist= new list<APTS_Additional_Subscription_Actions__c>();
            List<APTS_Quote_Agreement_Locations__c> multiLocAccount = new List<APTS_Quote_Agreement_Locations__c>();
            list<APTS_Dynamic_Bundle__c> dynamicbundlelist = new list<APTS_Dynamic_Bundle__c>();
            List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
            List<AggregateResult> results = new List<AggregateResult>();
            //List<Attachment> attachList = new  List<Attachment>();
            //Added Standard Bundle and Corporate Select to the Query SOC-5819 //SOC-4320 FEB release By Bijeta
            //SOC-5358 - Added CreatedDate field to the below query
            //SOC-6753 - Added APTS_Payer__c,APTS_Payer__r.Source_System_Account_Number__c to the below query //SOC-5991 Plan Type //SOC-4827 RiskCategory Field
            //SOC-4222 Nov release
            order = APTS_OrderSubmissionUtilityExt.queryOrders(orderId);
            if(order != null){
                orderLineItems = APTS_OrderSubmissionUtilityExt.queryOrderLineItems(order.id);
                proposalOwner = APTS_OrderSubmissionUtilityExt.queryUser(order.Apttus_QPConfig__ProposalId__r.OwnerId);
                onlinecon = APTS_OrderSubmissionUtilityExt.queryonlinecontacts(order.Apttus_QPConfig__ProposalId__c);
                mastercon = APTS_OrderSubmissionUtilityExt.querymastercontacts(order.Apttus_QPConfig__ProposalId__c);
                additionalSublist = APTS_OrderSubmissionUtilityExt.querysubscriptionlist(order.Apttus_QPConfig__ProposalId__c);
                multiLocAccount = APTS_OrderSubmissionUtilityExt.queryagreementlocations(order.Apttus_QPConfig__ProposalId__c);
                dynamicbundlelist = APTS_OrderSubmissionUtilityExt.querydynamicbundles(order.Apttus_QPConfig__ProposalId__c);
                lineItemList = APTS_OrderSubmissionUtilityExt.querylineitems(order.Apttus_QPConfig__ProposalId__c);
                results = APTS_OrderSubmissionUtilityExt.queryaggregateresults(order.Apttus_QPConfig__ProposalId__c);
            }

            List<Apttus_Approval__Approval_Request__c> approvalNumberlst=new list<Apttus_Approval__Approval_Request__c>();
            String approvalNumber='';
      
            system.debug(LoggingLevel.DEBUG,[SELECT id,Name,APTS_Related_Quote_Number__c,Apttus_QPApprov__ProposalId__c FROM Apttus_Approval__Approval_Request__c where Apttus_QPApprov__ProposalId__c=:order.Apttus_QPConfig__ProposalId__r.Id]);
            if(!Schema.sObjectType.Apttus_Approval__Approval_Request__c.isAccessible()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Insufficient Access'));
            }
            if([SELECT id,Name,APTS_Related_Quote_Number__c,Apttus_QPApprov__ProposalId__c,Apttus_Approval__Approval_Status__c FROM Apttus_Approval__Approval_Request__c where Apttus_QPApprov__ProposalId__c=:order.Apttus_QPConfig__ProposalId__r.Id]!=null
      &&[SELECT id,Name,Apttus_QPApprov__ProposalId__c FROM Apttus_Approval__Approval_Request__c where Apttus_QPApprov__ProposalId__c=:order.Apttus_QPConfig__ProposalId__r.Id].size()!=0){            
         if(Schema.sObjectType.Apttus_Approval__Approval_Request__c.isAccessible() && Schema.sObjectType.Apttus_Approval__Approval_Request__c.isQueryable()){ 
        ApprovalNumberlst= [SELECT id,Name,APTS_Related_Quote_Number__c,Apttus_Approval__Approval_Status__c,Apttus_QPApprov__ProposalId__c FROM Apttus_Approval__Approval_Request__c where Apttus_QPApprov__ProposalId__c=:order.Apttus_QPConfig__ProposalId__r.Id];
        }
        for(Apttus_Approval__Approval_Request__c temp: ApprovalNumberlst) {
          if(temp.Apttus_Approval__Approval_Status__c=='Approved') {
            ApprovalNumber= temp.APTS_Related_Quote_Number__c;
           } else {
            ApprovalNumber=Null;
            system.debug(LoggingLevel.DEBUG,'###'+ApprovalNumber);
           }
        }
      }else{
        ApprovalNumber= null; 
        system.debug(LoggingLevel.DEBUG,'###'+ApprovalNumber);
      }

        ordreq = new CreateOrderRequest ();
        Integer relLineNumber = dynamicbundlelist.size() + 1;
            //SOC-5358 ends
            
        for (AggregateResult ar : results) {                   
            countMap.put((String)ar.get('Material__c')+(String)ar.get('APTS_Source_System_Detail__c'), (Integer)ar.get('total'));                    
        }

            //Roma Starts
            Map<String, List<Online_Contacts__c>> olcNAICMap = new Map<String, List<Online_Contacts__c>>();
            for(Online_Contacts__c onlineconDetails : onlinecon) 
            { 
                List<Online_Contacts__c> tempOLCList = new List<Online_Contacts__c>();
                if(olcNAICMap.get(onlineconDetails.Material__c)!=null){
                    tempOLCList = olcNAICMap.get(onlineconDetails.Material__c);
                }
                if(onlineconDetails.NAIC_Name__c != null && onlineconDetails.NAIC_Number__c !=null){
                    tempOLCList.add(onlineconDetails);
                    olcNAICMap.put(onlineconDetails.Material__c, tempOLCList);
                }
            }
            //Roma Ends     
              Boolean hasDynamicBundle = order.Apttus_QPConfig__ProposalId__r.APTS_HAS_DYNAMIC_BUNDLE__c;
              if(!dynamicbundlelist.isEmpty() && !hasDynamicBundle){  

                        APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                        system.debug('setOAMode-->'+ordreq.CreateOrderRequest.OrderHeader.oaMode);
                        //Dynamic bundling Primary line item creation
                        for(APTS_Dynamic_Bundle__c dynamicbundle :dynamicbundlelist) 
                        {
                            System.debug(LoggingLevel.DEBUG,'has new bundle record');
                            if(dynamicbundle.APTS_Bundle_Primary_Material__c != null )    //DOC-12198
                            {
                ordline = new CreateOrderRequest.orderLines();
                bundlePrimMaterial=dynamicbundle.APTS_Bundle_Primary_Material__c;
                ordline.material.materialId=dynamicbundle.APTS_Bundle_Primary_Material__c;
                ordline.material.description=dynamicbundle.Name;
                ordline.lineNumber=String.valueOf(lineNumber);
                //skg added the following line for JIRA-3395
                ordline.billOfMaterialsType='SON';
                if(dynamicbundle.APTS_Net_Price__c!=null && dynamicbundle.APTS_Billing_Frequency__c=='Yearly'){
                    ordline.listAmount=dynamicbundle.APTS_Net_Price__c!=null ? (dynamicbundle.APTS_Net_Price__c/12).setscale(5) : null;
                    ordline.netAmount=dynamicbundle.APTS_Net_Price__c!=null ? (dynamicbundle.APTS_Net_Price__c/12).setscale(5) : null;
                }    
                else{
                    ordline.listAmount= dynamicbundle.APTS_Net_Price__c!=null ? dynamicbundle.APTS_Net_Price__c.setscale(5): null;
                    ordline.netAmount= dynamicbundle.APTS_Net_Price__c!=null ? dynamicbundle.APTS_Net_Price__c.setscale(5): null;
                }
                ordline.quantity=1;
                ordline.unitOfMeasure='EA'; 
                ordline.keepTerms=dynamicbundle.APTS_Keep_Terms__c; 
        //SOC-4367 Nov Changes
          if(order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=''){
            ordline.saID=order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c.substringAfter('(').remove(')');  
                    }
                // call method to assign the terms to order
//skg                  orderTerms(dynamicbundle.APTS_Contract_Terms__c, null, dynamicbundle.APTS_YoY_2_Plus__c,dynamicbundle.APTS_YoY_1_Renewal__c,'');
                  //BF= Yearly , DOC-6356 Added by Sakshi
            if(dynamicbundle.APTS_Billing_Frequency__c=='Yearly' && dynamicbundle.APTS_Net_Price__c!=null){
               // Decimal baseValueDynamic = (dynamicbundle.APTS_Net_Price__c/12).setscale(2);
                orderTerms(dynamicbundle.APTS_Contract_Terms__c, 0, dynamicbundle.APTS_YoY_2_Plus__c,dynamicbundle.APTS_YoY_1_Renewal__c,'','',0.00,0.00,0.00,0.00,0.00,0.00,false,0.00,0.00,0.00,0.00,true);
            }
            else{
                orderTerms(dynamicbundle.APTS_Contract_Terms__c, 0, dynamicbundle.APTS_YoY_2_Plus__c,dynamicbundle.APTS_YoY_1_Renewal__c,'','',0.00,0.00,0.00,0.00,0.00,0.00,false,0.00,0.00,0.00,0.00,true);
            }
                //Bridge Details
                if(dynamicbundle.APTS_Bridge_Discount_Number__c != null){
                    CreateOrderRequest.adjustments adjustment1 = new CreateOrderRequest.adjustments();
                    adjustment1.type ='PERCENT';
                    adjustment1.discountType='BridgeDiscount';//SOC-6755 May Bijeta
                    if(dynamicbundle.APTS_Bridge_Discount_Number__c!=null){
                        adjustment1.amount=dynamicbundle.APTS_Bridge_Discount_Number__c.setscale(9);
                    }
                    ordline.adjustments.add(adjustment1); 
                }
                //Added by Poonam Garg DOC-1113
                if(dynamicbundle.APTS_Program_ID__c!='WCMP' && dynamicbundle.APTS_Billing_Frequency__c=='Monthly'){
                    ordline.billPlanType='Monthly';
                }
                //Added by Poonam Garg DOC 800 
                if(dynamicbundle.APTS_Program_ID__c!='WCMP' && dynamicbundle.APTS_Billing_Frequency__c=='Yearly'){
                    ordline.billPlanType='Yearly';
                }
                //SOC-3878
                if(dynamicbundle.APTS_Program_ID__c=='WCMP'){
                    //SOC-3962       
                       ordline.programId = dynamicbundle.APTS_Program_ID__c;
                    if(dynamicbundle.APTS_Keep_Terms__c==true && dynamicbundle.APTS_Deal_Number__c!=null){
                        //For WCMP modification scenario
                       ordline.keepTerms=true;
                       ordline.amendmentFlag=true;
                       CreateOrderRequest.orderNotes bundlenote= new CreateOrderRequest.orderNotes();
                        bundlenote.notes='Program Id: '+dynamicbundle.APTS_Program_ID__c+' Deal Number: '+dynamicbundle.APTS_Deal_Number__c+' Modify';
                        ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(bundlenote); 
                        //SOC-5819
                        //isModeA=true; 
                        //Soc-5990
                        //Commented and moved to APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                        //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                        //isModeW=true;
                       
                    }/*else if(dynamicbundle.APTS_Keep_Terms__c!=true && dynamicbundle.APTS_Deal_Number__c==null){
                        //For WCMP new scenario:Send in ordernotes – “New”
                        CreateOrderRequest.orderNotes bundlenote= new CreateOrderRequest.orderNotes();
                        bundlenote.notes='New';
                        ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(bundlenote); 
                        //SOC-5819
                        ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                        isModeW=true; 
                    }
                    //SOC-5990
                    else if(dynamicbundle.APTS_Keep_Terms__c!=true && dynamicbundle.APTS_Deal_Number__c!=null){
                             ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                             isModeW=true; 
                    }*/
                }
                //SOC-5358                 
                
                //SOC-5358 ends
                //if(dynamicbundle.APTS_Bundle_Adjustment_Type__c == '% Discount' && dynamicbundle.APTS_Program_ID__c=='WCMP')            
                // SOC-3369
                //SOC-3878 commented the code as No ZPER (percent) conditions are to be sent to SAP-Pathra
                    /*CreateOrderRequest.adjustments adjustment2 = new CreateOrderRequest.adjustments();
                    //adjustment2.type =dynamicbundle.APTS_Bundle_Adjustment_Type__c;
                    adjustment2.type ='PERCENT';
                    adjustment2.amount=dynamicbundle.APTS_Bundle_Adjustment_Amount__c;
                    ordline.adjustments.add(adjustment2); */

                //}
                 //Soc-6446 June Bijeta
                if(dynamicbundle.APTS_Bridge__c=='7 Days'){
                 ordline.billPlanUpdateRule='7D';
                  }
                Else if(dynamicbundle.APTS_Bridge__c=='14 Days'){
                 ordline.billPlanUpdateRule='14D';
                  }
                Else if(dynamicbundle.APTS_Bridge__c=='28 Days'){
                 ordline.billPlanUpdateRule='28D';
                 }
                else{
                ordline.billPlanUpdateRule=string.valueof(dynamicbundle.APTS_Bridge_Length__c);  
                }
                //New parameter added
                if(ordline.billPlanUpdateRule!=null){
                    ordline.adjRnwlBaseValue=String.valueOf(dynamicbundle.APTS_Net_Price__c);
                }  
                if(dynamicbundle.APTS_Bridge_Discount_Number__c!=null && dynamicbundle.APTS_Bridge_Length__c!=null)   
                {
                //
                ordline.netAmount=dynamicbundle.APTS_Bridge_Monthly_Charges__c!=null ? dynamicbundle.APTS_Bridge_Monthly_Charges__c.setscale(5) : null;
                }                                            
                
                // Bridge Details ends                                       
                ordreq.CreateOrderRequest.orderLines.add(ordline);                
                CreateOrderRequest.orderNotes bundlenote= new CreateOrderRequest.orderNotes();
                bundlenote.notes='Group:'+dynamicbundle.APTS_Group__c+'. Bundle Adjustment '+dynamicbundle.APTS_Bundle_Adjustment_Type__c+' : '+dynamicbundle.APTS_Bundle_Adjustment_Amount__c+'.';                
                ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(bundlenote);
                //SOC-5819  

                if(dynamicbundle.APTS_Keep_Terms__c==true && dynamicbundle.APTS_MLA_Agreement_Number__c!=null){
                    isMLAModify = true;
               //SOC-5991
               // Commented and moved to APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                    //isModeW=true;                        
                    }
                if(!dynamicbundle.APTS_Keep_Terms__c && string.isEmpty(dynamicbundle.APTS_MLA_Agreement_Number__c)) {
                    isnotMLAModify = True;  
                }
                    // SOC-5991
                    //Commented nd moved to APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                    //isModeW=true; 
                lineNumber+=1;
               
            }
            }
        }
            
        
            //DOC-12198 ends
      
            // Enhanced aspart of TRStore DLT-19075
             if(order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c=='Canada'){
                
                //Added Aspart of DLT-19075 -  new application ID for TRStore 
                Set<string> trstoresourceSet = new Set<string>();
                string trstorebusinessUnitsStr = 'trstorebusinessUnits';
                  
                if( Static_Values__c.getAll().containsKey(trstorebusinessUnitsStr)) {
                    trstoresourceSet.addAll( Static_Values__c.getAll().get(trstorebusinessUnitsStr).Value__c.split(','));
                }
                
                 if(order.Apttus_QPConfig__ProposalId__r.TR_Store_Source__c != null) {
                 
                     if(trstoresourceSet.contains(order.Apttus_QPConfig__ProposalId__r.TR_Store_Source__c)) {
                         string trStoreAppID = 'TRSTR';
                         string trstorebusinessAppId = 'trstoreBusinessUnitAppId';
                         if( Static_Values__c.getAll().containsKey(trstorebusinessAppId)) {
                             trStoreAppID = Static_Values__c.getAll().get(trstorebusinessAppId).Value__c;
                         }   
                         ordreq.CreateOrderRequest.ESIHeader.applicationId= trStoreAppID;
                    } else {
                         ordreq.CreateOrderRequest.ESIHeader.applicationId='SF09';  
                    }
                 
                  //End of DLT-19075 -  new application ID for TRStore        
                 }else{
                    ordreq.CreateOrderRequest.ESIHeader.applicationId='SF09';
                 }   
            }
            
            
            ordreq.CreateOrderRequest.ESIHeader.transactionId='CARS';
             //Online Deals - May Release - SOC-5982
             CreateOrderRequest.orderDeal oDealCorp = new CreateOrderRequest.orderDeal();
              //List<CreateOrderRequest.orderDeal> oDealList = new List<CreateOrderRequest.orderDeal>();
              Boolean isCorp = false;
              relLineNumber = dynamicbundlelist.size() + 1;
              
              
               for(Apttus_Config2__LineItem__c lineItem : lineItemList){
                   //Configured Deal
                   // June release SOC-7987 - Added primaryindigo
                   
                   if((lineItem.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c == 'Primary' || lineItem.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c == 'Primary Essentials' || lineItem.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c == 'PrimaryIndigo') && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.Apttus_Config2__OptionId__c == null){
                        //Send Primary
                         
                        dealSerialNumber += 1;
                        oDealCorp.programId = 'SEAT';
                        oDealCorp.dealId = (lineItem.APTS_Deal_Number__c != 0 ? string.valueOf(lineItem.APTS_Deal_Number__c) : '');
                        oDealCorp.startDate = Order.CreatedDate.format('yyyyMMdd');
                        oDealCorp.endDate = DateTime.newInstance(9999, 12, 31).format('yyyyMMdd');
                        Map<Decimal,Decimal> mapDecimalValues =new Map<Decimal,Decimal>();
                        mapDecimalValues = APTS_OrderSubmissionUtilityExt1.returnDecimalMap(0,0,0);
                        //oDealCorp.lineItems.add(assignDealLines(relLineNumber,'PRI',0,0,0));
                        oDealCorp.lineItems.add(APTS_OrderSubmissionUtilityExt1.assignDealLines(relLineNumber,'PRI',mapDecimalValues)); 
                        oDealCorp.dealSerialNumber = String.valueOf(dealSerialNumber);
                        oDealCorp.actionCode = 'NEW';
                        isCorp  = true;
                        relLineNumber += 1;
                        }else if(lineItem.Apttus_Config2__OptionId__r.APTS_Corporate_Select__c == 'Module' && lineItem.Apttus_Config2__LineStatus__c == 'New'){       
                            Map<Decimal,Decimal> mapDecimalValues =new Map<Decimal,Decimal>();
                            mapDecimalValues = APTS_OrderSubmissionUtilityExt1.returnDecimalMap(0,0,0);
                            //oDealCorp.lineItems.add(assignDealLines(relLineNumber,'SEC',0,0,0));
                            oDealCorp.lineItems.add(APTS_OrderSubmissionUtilityExt1.assignDealLines(relLineNumber,'SEC',mapDecimalValues));
                             relLineNumber += 1;
                              isCorp  = true; 
                              }
                              //Added PBU!=Canada for DOC-4021
                              else if(lineItem.Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c && lineItem.Apttus_Config2__LineStatus__c == 'New'){ //Standard Bundle
                                  system.debug(LoggingLevel.DEBUG,'RK --> Std Bundle Block');
                                  CreateOrderRequest.orderDeal oDealStd = new CreateOrderRequest.orderDeal();
                                  dealSerialNumber += 1;
                                  oDealStd.dealId = (lineItem.APTS_Deal_Number__c != 0 ? string.valueOf(lineItem.APTS_Deal_Number__c) : '');
                                  oDealStd.startDate = Order.CreatedDate.format('yyyyMMdd');
                                  oDealStd.endDate = DateTime.newInstance(9999, 12, 31).format('yyyyMMdd');
                                  Map<Decimal,Decimal> mapDecimalValues =new Map<Decimal,Decimal>();
                                  mapDecimalValues = APTS_OrderSubmissionUtilityExt1.returnDecimalMap(0,0,0);
                                  //oDealStd.lineItems.add(assignDealLines(relLineNumber,'PRI',0,0,0));                                  
                                  oDealStd.lineItems.add(APTS_OrderSubmissionUtilityExt1.assignDealLines(relLineNumber,'PRI',mapDecimalValues));
                                  oDealStd.dealSerialNumber = String.valueOf(dealSerialNumber);
                                  oDealStd.actionCode = 'NEW';
                                  relLineNumber +=1;
                                  
                                  //Send Program Id
                                  if( (lineItem.APTS_Media_High_Level_Code__c == '06' && (lineItem.APTS_Media_Lower_Level_Code__c == 'I9' || lineItem.APTS_Media_Lower_Level_Code__c == 'LW')) || APTS_OrderSubmissionUtilityExt2.validateMLLCode(lineItem.APTS_Media_Lower_Level_Code__c , System.Label.APTS_MLLCodes_CPRO) ){
                                      oDealStd.programId = 'CPRO';
                                  }else if( (lineItem.APTS_Media_High_Level_Code__c == '06' && APTS_OrderSubmissionUtilityExt2.validateMLLCode(lineItem.APTS_Media_Lower_Level_Code__c,System.Label.APTS_MLLCodes_06SEAT)) || (lineItem.APTS_Media_High_Level_Code__c == '13' && APTS_OrderSubmissionUtilityExt2.validateMLLCode(lineItem.APTS_Media_Lower_Level_Code__c,System.Label.APTS_MLLCodes_13SEAT)) || (lineItem.APTS_Media_High_Level_Code__c == '05' && lineItem.APTS_Media_Lower_Level_Code__c == 'E2') ){
                                      oDealStd.programId = 'SEAT';
                                  }
                                  
                                  //GLP-788
                                  else if(lineItem.APTS_Media_High_Level_Code__c == '21' && lineItem.APTS_Media_Lower_Level_Code__c == 'EC'){
                                      oDealStd.programId = 'CARELL';
                                  }
                                  //GLP-788
                                  system.debug(LoggingLevel.DEBUG,'RK --> Std Bundle Block pgm Id ='+oDealStd.programId);
                                  ordreq.CreateOrderRequest.OrderHeader.orderDeal.add(oDealStd); //add only standard bundle
                                   }else if(lineItem.Apttus_Config2__LineStatus__c != 'Amended' && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled'){
                                       relLineNumber +=1; //if wcmp line item
                                   }
                                   }
                                   if(isCorp) {
                                       ordreq.CreateOrderRequest.OrderHeader.orderDeal.add(oDealCorp);// add only Corp Select bundles  
                                   }
                                   //may release Online Bundle ends   - SOC-5982 
                                   //SOC-4827
            ordreq.CreateOrderRequest.OrderHeader.creditApproval=order.Apttus_QPConfig__ProposalId__r.APTS_Account_Credit_Risk_Category__c;
            ordreq.CreateOrderRequest.OrderHeader.numberOfAttorneys='0';
            numberOfAttorneys = '0'; //DOC-9689
            //SOC-3959 Pathra-Added to send owners Email to SAP
            ordreq.CreateOrderRequest.OrderHeader.orderRep.email = proposalOwner.email;
             //SOC-4222 Nov Release
             if(ApprovalNumber!=null) {
                ordreq.CreateOrderRequest.OrderHeader.approvalNumber= ApprovalNumber;
             }
            //SOC-3963 Pathra-Added cost center value to esi field
            ordreq.CreateOrderRequest.OrderHeader.costCenter=order.Apttus_QPConfig__ProposalId__r.APTS_Cost_Center__c;
            if(order.APTS_Periodic_Value__c!=null){
            PeriodicValue=order.APTS_Periodic_Value__c; 
            } 
            //DOC-12198
            Boolean isKeepTermscheck=false;
            //Boolean isProflex=false;
            Integer countBundleList=0;
            Apttus_Config2__OrderLineItem__c proflexOrderLineItem=new Apttus_Config2__OrderLineItem__c();
            Map<String,List<Apttus_Config2__OrderLineItem__c>> mapBundleLineItems=new Map<String,List<Apttus_Config2__OrderLineItem__c>>();
            string grpName='';      
            For(Apttus_Config2__OrderLineItem__c ordeline :orderlineitems)
            {
                //SOC-3783 Sreenu changes Start
                ordline = new CreateOrderRequest.orderLines();
                //grpName=ordeline.APTS_Group__c; //Commented by Tanmay
                APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                system.debug('setOAMode-->'+ordreq.CreateOrderRequest.OrderHeader.oaMode); 
                if(ordeline.Apttus_Config2__ProductId__r.ProductCode != null && System.Label.APTS_Proflex_Materials.contains(ordeline.Apttus_Config2__ProductId__r.ProductCode) 
                && hasDynamicBundle && ordeline.Apttus_Config2__LineStatus__c!='Renewed' && ordeline.Apttus_Config2__LineStatus__c!='Cancelled'){
                isProflexBLI = True;
                isProflex=true; 
                proflexOrderLineItem=ordeline;
                countBundleList=countBundleList + 1;
                grpName=ordeline.APTS_Group__c;
                ordline.material.materialId=ordeline.Apttus_Config2__ProductId__r.ProductCode;
                ordline.material.description=ordeline.Apttus_Config2__Description__c;
                ordline.lineNumber=String.valueOf(lineNumber);
                system.debug(LoggingLevel.DEBUG,'lineNumber assigned : '+ordeline.Name+' : '+lineNumber);
                //skg added the following line for JIRA-3395
                ordline.billOfMaterialsType='SON';
                /*if(ordeline.Apttus_Config2__NetPrice__c!=null && ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                    ordline.listAmount=(ordeline.Apttus_Config2__NetPrice__c/12).setscale(5);
                    ordline.netAmount=(ordeline.Apttus_Config2__NetPrice__c/12).setscale(5);
                }    
                else{
                    ordline.listAmount=ordeline.Apttus_Config2__NetPrice__c.setscale(5);
                    ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c.setscale(5);
                }*/
                //Changed on 29th Jan
                if( ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                   if(ordeline.Apttus_Config2__NetPrice__c!=null){
                    ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) :null;}
                   if(ordeline.Apttus_Config2__NetPrice__c!=null){
                    ordline.listAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;}
                }    
                else{
                    ordline.listAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? ordeline.Apttus_Config2__NetPrice__c.setscale(5) : null;
                    ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? ordeline.Apttus_Config2__NetPrice__c.setscale(5) : null;
                }
                
                ordline.quantity=1;
                ordline.unitOfMeasure='EA'; 
                ordline.keepTerms=ordeline.APTS_Keep_Terms__c; 
                isKeepTermscheck=ordeline.APTS_Keep_Terms__c;
        //SOC-4367 Nov Changes
          if(order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=''){
            ordline.saID=order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c.substringAfter('(').remove(')');  
                }
                
                //Bridge Details
                if(ordeline.APTS_New_Bridge_Discount__c != null){
                    CreateOrderRequest.adjustments adjustment1 = new CreateOrderRequest.adjustments();
                    adjustment1.type ='PERCENT';
                    adjustment1.discountType='BridgeDiscount';//SOC-6755 May Bijeta
                    if(ordeline.APTS_New_Bridge_Discount__c!=null){
                        adjustment1.amount=ordeline.APTS_New_Bridge_Discount__c.setscale(9);
                    }
                    ordline.adjustments.add(adjustment1); 
                }
                //Added by Poonam Garg DOC-1113
                if(ordeline.APTS_Program_ID__c!='WCMP' && ordeline.Apttus_Config2__BillingFrequency__c=='Monthly'){
                    ordline.billPlanType='Monthly';
                }
                //Added by Poonam Garg DOC 800 
                if(ordeline.APTS_Program_ID__c!='WCMP' && ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                    ordline.billPlanType='Yearly';
                }
                //SOC-3878
                if(ordeline.APTS_Program_ID__c=='WCMP'){
                    //SOC-3962       
                       ordline.programId = ordeline.APTS_Program_ID__c;
                    if(ordeline.APTS_Keep_Terms__c==true && ordeline.APTS_Deal_Number__c!=null){
                        //For WCMP modification scenario
                       ordline.keepTerms=true;
                       ordline.amendmentFlag=true;
                       CreateOrderRequest.orderNotes bundlenote= new CreateOrderRequest.orderNotes();
                        bundlenote.notes='Program Id: '+ordeline.APTS_Program_ID__c+' Deal Number: '+ordeline.APTS_Deal_Number__c+' Modify';
                        ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(bundlenote); 
                        //SOC-5819
                        //isModeA=true; 
                        //Soc-5990
                        //Commented and moved to APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                        //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                        //isModeW=true;
                       
                    }else if(ordeline.APTS_Keep_Terms__c!=true && ordeline.APTS_Deal_Number__c==null){
                        //For WCMP new scenario:Send in ordernotes – “New”
                        CreateOrderRequest.orderNotes bundlenote= new CreateOrderRequest.orderNotes();
                        bundlenote.notes='New';
                        ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(bundlenote); 
                        //SOC-5819
                        //Commented and moved to APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                        //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                        //isModeW=true; 
                    }
                    //SOC-5990
                    /*else if(ordeline.APTS_Keep_Terms__c!=true && ordeline.APTS_Deal_Number__c!=null){
                            //Commented and moved to APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                             //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                             //isModeW=true; 
                    }*/
                }
                //SOC-5358                 
                
                
                if(ordeline.APTS_Bridge__c=='7 Days'){
                 ordline.billPlanUpdateRule='7D';
                  }
                Else if(ordeline.APTS_Bridge__c=='14 Days'){
                 ordline.billPlanUpdateRule='14D';
                  }
                Else if(ordeline.APTS_Bridge__c=='28 Days'){
                 ordline.billPlanUpdateRule='28D';
                 }
                else{
                ordline.billPlanUpdateRule=string.valueof(ordeline.Apttus_QPConfig__ProposalLineItemId__r.APTS_Bridge_Length__c);   
                }
                if(ordline.billPlanUpdateRule!=null){
                    //ordline.adjRnwlBaseValue=String.valueOf(ordeline.APTS_Calculated_Year_1__c);
                    //DOC-15584 Changes.
                    if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly' && ordeline.Apttus_Config2__BillingFrequency__c !=null){
                    ordline.adjRnwlBaseValue= ordeline.APTS_Calculated_Year_1__c !=null ? String.valueOf((ordeline.APTS_Calculated_Year_1__c/12).setscale(2)) : null;
                    }
                    else{
                    ordline.adjRnwlBaseValue= ordeline.APTS_Calculated_Year_1__c !=null ? String.valueOf((ordeline.APTS_Calculated_Year_1__c).setscale(2)) : null;}
                }
                System.debug(LoggingLevel.DEBUG, ordeline.APTS_New_Bridge_Discount__c !=null);
                System.debug(LoggingLevel.DEBUG, ordeline.APTS_Bridge__c !=null); 
                System.debug(LoggingLevel.DEBUG, ordline.netAmount);
                if(ordeline.APTS_New_Bridge_Discount__c !=null && ordeline.APTS_Bridge__c!=null)   
                {   //DOC-15584 Changes
                    if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly' && ordeline.Apttus_Config2__BillingFrequency__c!=null){
                    ordline.listAmount= ordeline.APTS_Calculated_Year_1__c!=null ? (ordeline.APTS_Calculated_Year_1__c/12).setscale(5) : null;
                    ordline.netAmount= ordeline.APTS_Bridge_Monthly_Charge__c!=null ? (ordeline.APTS_Bridge_Monthly_Charge__c/12).setscale(5): null;}
                    else{
                        ordline.listAmount= ordeline.APTS_Calculated_Year_1__c!=null ? ordeline.APTS_Calculated_Year_1__c.setscale(5) : null;
                        ordline.netAmount= ordeline.APTS_Bridge_Monthly_Charge__c!=null ? ordeline.APTS_Bridge_Monthly_Charge__c.setscale(5): null;
                    }
                    System.debug(LoggingLevel.DEBUG,'ordline.netAmount : '+ordline.netAmount); 
                    System.debug(LoggingLevel.DEBUG,'ordline.listAmount : '+ordline.listAmount); 
                }
                System.debug(LoggingLevel.DEBUG,ordeline.APTS_New_Bridge_Discount__c);    
                System.debug(LoggingLevel.DEBUG,ordeline.APTS_Proposal_Business_Unit__c); 
                System.debug(LoggingLevel.DEBUG,ordeline.Apttus_Config2__BillingFrequency__c);    
                System.debug(LoggingLevel.DEBUG,ordeline.Apttus_Config2__BasePrice__c);                                    
                /*if(ordeline.APTS_Proposal_Business_Unit__c=='Canada' && ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                if(ordeline.APTS_New_Bridge_Discount__c!=null && ordeline.Apttus_Config2__BasePrice__c!=null){
                ordline.netamount=ordeline.Apttus_Config2__BasePrice__c/12 - (ordeline.Apttus_Config2__BasePrice__c/12 * (ordeline.APTS_New_Bridge_Discount__c/100)); 
                }
                }
                else{
                if(ordeline.APTS_New_Bridge_Discount__c!=null && ordeline.Apttus_Config2__BasePrice__c!=null){
                ordline.netamount=ordeline.Apttus_Config2__BasePrice__c- (ordeline.Apttus_Config2__BasePrice__c* (ordeline.APTS_New_Bridge_Discount__c/100)); 
                }
                }*/
                
                System.debug(LoggingLevel.DEBUG,'+++++++++++++'+ordline.netAmount);
                // Bridge Details ends 
                                                      
                CreateOrderRequest.orderNotes bundlenote= new CreateOrderRequest.orderNotes();
                bundlenote.notes='Group:'+ordeline.APTS_Group__c+'. Bundle Adjustment '+ordeline.Apttus_Config2__AdjustmentType__c+' : '+ordeline.Apttus_Config2__AdjustmentAmount__c+'.';                
                ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(bundlenote);
                //SOC-5819  

                if(ordeline.APTS_Keep_Terms__c==true && ordeline.APTS_SAP_MLA_Agreement_Number__c!=null){
                    isMLAModify = true;
               //SOC-5991
               //Commented and moved to APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                    //isModeW=true;                        
                    }
                if(!ordeline.APTS_Keep_Terms__c && string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c)) {
                    isnotMLAModify = True;  
                }
                    // SOC-5991
                    //Commented and moved to APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                    //isModeW=true; 
                lineNumber+=1;
                system.debug(LoggingLevel.DEBUG,'lineNumber assigned : +1 done '+ordeline.Name+' : '+lineNumber);
            }
            else{
                if (!string.isEmpty(grpName)){
                     if(!mapBundleLineItems.isEmpty() && mapBundleLineItems.containsKey(grpName)) {
                                                  mapBundleLineItems.get(grpName).add(ordeline);    
                                              }
                                              else {
                                                  mapBundleLineItems.put(grpName, new List<Apttus_Config2__OrderLineItem__c> {ordeline});
                                              }
                }
            }
            //DOC-12198 ends
                //Added by Poonam Garg DOC-3019
                if(ordeline.Apttus_Config2__LineStatus__c =='Cancelled' && isnotMLAModify && !string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c)
                    && materialNumberList.contains(ordeline.APTS_Service_Number__c) ){
                    isMLAReplace = True;
                }
                system.debug(LoggingLevel.DEBUG,'isMLAReplace...'+isMLAReplace);
                //SOC-3783 Sreenu changes End
                //SOC 5107
                 if(ordeline.APTS_Cars_One_time_value_c__c!=null){
                    oneTimeValue=oneTimeValue+ordeline.APTS_Cars_One_time_value_c__c; 
                }   
                //SOC-3835 && SOC-3839 start--
                if(ordeline.APTS_Service_Number__c==vCARSEDLTproduct && ordeline.Apttus_Config2__LineStatus__c=='Amended' ){
                    EDLTproduct = false;
                }else{
                EDLTproduct = true;
                }
                if(isMLAModify == true && ordeline.Apttus_Config2__LineStatus__c=='Amended' && ordeline.Apttus_QPConfig__ProposalLineItemId__r.Net_Qty_Difference__c <=0 && !ordeline.APTS_is_Primary_in_Bundle__c){
                QTYChange = false;
                }else{
                QTYChange = true;
                }
                //end--
                //added OR condition for SOC-3494
                System.debug(LoggingLevel.DEBUG,'isMLAModify'+isMLAModify+ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c+ordeline.Apttus_Config2__LineStatus__c+ordeline.APTS_Group__c);
                system.debug(LoggingLevel.DEBUG,EDLTproduct+''+QTYChange);
                if((ordeline.Apttus_Config2__LineStatus__c!='Cancelled' && ordeline.Apttus_Config2__LineStatus__c!='Existing' && ordeline.Apttus_Config2__LineStatus__c!='Amended' && !(isMLAModify && ordeline.Apttus_Config2__LineStatus__c=='Renewed')) || 
                (isMLAModify && ordeline.Apttus_Config2__LineStatus__c=='Amended' && !string.isEmpty(ordeline.APTS_Group__c) && (ordeline.APTS_is_Primary_in_Bundle__c || (ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c!=null && ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c== 'BENEFITGRP') || OnlineContactsController.validateProductLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, System.Label.OCPerSeatLowerLevelCodes) || 
                    (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '21') ||
                    (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'I9')))&& QTYChange == true && EDLTproduct == true){
                 System.debug(LoggingLevel.DEBUG,'isMLAModify'+isMLAModify);
                if(ordeline.APTS_Program_ID__c=='CPRO' && ordeline.Apttus_QPConfig__ProposalLineItemId__c!=null && ordeline.Apttus_QPConfig__ProposalLineItemId__r.APTS_Service_Number_Override__c!=null ){
                    materialMap.put(ordeline.Apttus_QPConfig__ProposalLineItemId__r.APTS_Service_Number_Override__c, lineNumber);
                    }
                else{
                    if(ordeline.Apttus_Config2__ProductId__c!=null && ordeline.Apttus_Config2__ProductId__r.ProductCode!=null){
                    
                    materialMap.put(ordeline.Apttus_Config2__ProductId__r.ProductCode, lineNumber);}
                    }
                materialBrandCodeMap.put(ordeline.Apttus_Config2__ProductId__r.ProductCode, ordeline.Apttus_Config2__ProductId__r.Apttus_Filter_Brand_Code__c);                
                //roma start
                List<CreateOrderRequest.naicData> naicDataList = new List<CreateOrderRequest.naicData>();
                system.debug(LoggingLevel.DEBUG,'olcNAICMap : ' + olcNAICMap);
                system.debug(LoggingLevel.DEBUG,'ordeline.Apttus_Config2__ProductId__r.ProductCode : ' + ordeline.Apttus_Config2__ProductId__r.ProductCode);
                if(olcNAICMap.size()>0 && ordeline.Apttus_Config2__ProductId__r.ProductCode!=null && ordeline.Apttus_Config2__ProductId__r.ProductCode!='' && olcNAICMap.get(ordeline.Apttus_Config2__ProductId__r.ProductCode)!=null){
                    for(Online_Contacts__c onlineconDetails : olcNAICMap.get(ordeline.Apttus_Config2__ProductId__r.ProductCode)){ 
                        CreateOrderRequest.naicData naicData = new CreateOrderRequest.naicData();
                        naicData.naicNumber = onlineconDetails.NAIC_Number__c ; 
                        naicData.naicName= onlineconDetails.NAIC_Name__c;
                        naicDataList.add(naicData); 
                    }
                    if(naicDataList.size()>0){
                        ordline.naicData = naicDataList;
                    }
                }
                //roma end
                    ordline.referenceNumber = ordeline.Apttus_QPConfig__ProposalLineItemId__r.Name;
                  
                    ordline.subscriptionDetail.subscriptionType=ordeline.Apttus_Config2__Type__c;
                      
                      //SOC 3961
                  
                    if(ordeline.Apttus_Config2__LineStatus__c=='New'){                 
                    ordline.outClause= ordeline.Apttus_QPConfig__ProposalId__r.APTS_Renewal_Opt_out__c;    
                    } 
                    if(!dynamicbundlelist.isEmpty() || isProflex){
                    ordline.keepTerms=isKeepTermscheck;
                    }
                    //SOC-3962
                    if(!string.isEmpty(ordeline.APTS_Group__c) && ordeline.APTS_Program_ID__c == 'WCMP'){
                    ordline.programId = 'WCMP';
                    }          
                    //Renewals
                    if(ordeline.Apttus_Config2__LineStatus__c=='Renewed'){
                    ordline.subscriptionDetail.contractLineNumber=string.valueof(ordeline.APTS_Contract_Line_Number__c);
                    ordline.subscriptionDetail.contractNumber=String.valueOf(ordeline.APTS_Contract_Number__c);
                    }
                    // call orderTerms method to assign the terms to order
                    // skg added the or statement in the following to include cpro pseudo item SOC-3407
                    if((ordeline.Apttus_Config2__LineType__c!='Option' && ordeline.APTS_Program_ID__c!='CPRO') || (ordeline.Apttus_Config2__LineType__c=='Product/Service' && ordeline.APTS_Program_ID__c=='CPRO')){
                            Decimal baseValueAnnual;
                            Decimal baseValueAnnual1;
                            Decimal baseValueAnnual2;
                            Decimal baseValueAnnual3;
                            Decimal baseValueAnnual4;
                            Decimal baseValueAnnual5;
                            if(ordeline.Base_Value__c !=null){baseValueAnnual = (ordeline.Base_Value__c/12).setscale(2);}
                            if(ordeline.APTS_Calculated_Year_1__c !=null){baseValueAnnual1 = (ordeline.APTS_Calculated_Year_1__c/12).setscale(2);}      
                            if(ordeline.APTS_Calculated_Year_2__c != null){baseValueAnnual2 = (ordeline.APTS_Calculated_Year_2__c/12).setscale(2);}
                            if(ordeline.APTS_Calculated_Year_3__c != null){baseValueAnnual3 = (ordeline.APTS_Calculated_Year_3__c/12).setscale(2);}
                            if(ordeline.APTS_Calculated_Year_4__c != null){baseValueAnnual4 = (ordeline.APTS_Calculated_Year_4__c/12).setscale(2);}
                            if(ordeline.APTS_Calculated_Year_5__c != null){baseValueAnnual5 = (ordeline.APTS_Calculated_Year_5__c/12).setscale(2);}
                                                        
                        
                            
                             if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
    // Proflex Renewed or New or Amended Proflex        
                                if(ordeline.Apttus_Config2__ProductId__r.ProductCode != null && System.Label.APTS_Proflex_Materials.contains(ordeline.Apttus_Config2__ProductId__r.ProductCode)){
                                    // Renewed Proflex
                                    if(ordeline.Apttus_Config2__LineStatus__c=='Renewed'){
                                        orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,
                                        ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,
                                        0.00,0,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c,isProflex);}
                                        //For New or Amended Proflex
                                    else if(ordeline.Apttus_Config2__LineStatus__c=='New'){
                                        orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,
                                        ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,
                                        0.00,0.00,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c,isProflex);        
                                        }
                                    else if(ordeline.Apttus_Config2__LineStatus__c=='Amended'){
                                        orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,
                                        ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,
                                        0.00,0.00,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,0,0,0,0,isProflex);        
                                       }
                                   
                                } // For Components in a proflex
                                else if(ordeline.APTS_GROUP__c!=null ) {
                                    orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,0.00,0.00,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c,isProflex);                                
                                }//DOF-4731
                                else if(ordeline.Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c == True ) {
                                    orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,0.00,0.00,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c,true);                                
                                }
                                //For standalone Products
                                else {
                                    orderTerms(ordeline.APTS_Contract_Term__c, baseValueAnnual, ordeline.APTS_Years_2_Plus_Adjustment__c,ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,ordeline.APTS_Prorate_base_Value__c,baseValueAnnual1,baseValueAnnual2,baseValueAnnual3,baseValueAnnual4,baseValueAnnual5,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c,isProflex);                                
                                }
                            } // Billing frequency =Monthly
                            else{
                                if(ordeline.Apttus_Config2__ProductId__r.ProductCode != null && System.Label.APTS_Proflex_Materials.contains(ordeline.Apttus_Config2__ProductId__r.ProductCode)){
                                        if(ordeline.Apttus_Config2__LineStatus__c=='Renewed'){
                                            orderTerms(ordeline.APTS_Contract_Term__c,0, ordeline.APTS_Years_2_Plus_Adjustment__c,
                                            ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,
                                            0.00,0,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c,isProflex);}
                                        else if(ordeline.Apttus_Config2__LineStatus__c=='New'){
                                            orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,
                                            ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,
                                            0.00,0.00,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c,isProflex);        
                                        } 
                                        else if(ordeline.Apttus_Config2__LineStatus__c=='Amended'){
                                            orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,
                                            ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,
                                            0.00,0.00,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,0,0,0,0,isProflex);        
                                        }              
                                }
                                // For Components in a proflex
                                else if(ordeline.APTS_GROUP__c!=null){
                                    orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,0.00,0.00,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c,isProflex);
                                }//DOF-4731
                                else if(ordeline.Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c == True ) {
                                    orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,0.00,0.00,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c,true);                                
                                }                                
                                //For standalone Products
                                else{
                                    orderTerms(ordeline.APTS_Contract_Term__c, ordeline.Base_Value__c, ordeline.APTS_Years_2_Plus_Adjustment__c,ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,ordeline.APTS_Prorate_base_Value__c,ordeline.APTS_Calculated_Year_1__c,ordeline.APTS_Calculated_Year_2__c,ordeline.APTS_Calculated_Year_3__c,ordeline.APTS_Calculated_Year_4__c,ordeline.APTS_Calculated_Year_5__c,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c,isProflex);
                                }
                            }
                    }
                    ordreq.CreateOrderRequest.ESIHeader.transactionId='CARS';
                    ordline.material.description=ordeline.Apttus_Config2__Description__c;
                    ordline.material.materialId=ordeline.Apttus_Config2__ProductId__r.ProductCode;
                        //CPRO
                    //skg for CPRO fix if(ordeline.Apttus_Config2__LineType__c == 'Product/Service' && ordeline.APTS_Program_ID__c!=null){
                    if(ordeline.Apttus_Config2__LineType__c == 'Product/Service' && ordeline.APTS_Program_ID__c=='CPRO'){
                     ordline.programId='SEAT'; //SOC-5992
                     ordline.material.materialId=ordeline.Apttus_QPConfig__ProposalLineItemId__r.APTS_Service_Number_Override__c;
                     ordline.material.description=ordeline.Apttus_QPConfig__ProposalLineItemId__r.APTS_Product_Name_Override__c;
                     }                        
                     else if(ordeline.APTS_Program_ID__c!=null && ordeline.Apttus_Config2__LineType__c == 'Option') {
                            ordline.material.materialId=ordeline.Apttus_Config2__OptionId__r.ProductCode ;
                            }    
                    //Renewals
                    if(ordeline.Apttus_Config2__LineStatus__c=='Renewed'){
                        //skg JIRA 3463 including cpro renewals.
                         if(ordeline.Apttus_Config2__LineType__c == 'Product/Service' && ordeline.APTS_Program_ID__c=='CPRO'){
                             ordline.material.materialId=ordeline.Apttus_QPConfig__ProposalLineItemId__r.APTS_Subscription_Number_Override__c;
                            }
                            else
                            {
                            ordline.material.materialId=ordeline.APTS_Subscription_Number__c;
                            }
                            }
                        
                if((!dynamicbundlelist.isEmpty() && !string.isEmpty(ordeline.Apttus_Config2__ProductId__r.ProductCode)) || isProflex){
                        if(!ordeline.APTS_is_Primary_in_Bundle__c){
                        ordline.lineNumber=String.valueOf(lineNumber);}
                        system.debug(LoggingLevel.DEBUG,'lineNumber assigned : '+ordeline.Name+' : '+lineNumber);
                        if(ordeline.APTS_Program_ID__c=='CPRO' && ordeline.Apttus_QPConfig__ProposalLineItemId__c!=null && ordeline.Apttus_QPConfig__ProposalLineItemId__r.APTS_Service_Number_Override__c!=null ){
                        bundlematerialMap.put(ordeline.Apttus_QPConfig__ProposalLineItemId__r.APTS_Service_Number_Override__c, ordline.lineNumber);
                        }
                        else{
                        if(ordeline.Apttus_Config2__ProductId__c!=null && ordeline.Apttus_Config2__ProductId__r.ProductCode!=null){
                        bundlematerialMap.put(ordeline.Apttus_Config2__ProductId__r.ProductCode, ordline.lineNumber);}
                        }
                    //SOC-7059      
                }
                else{
                        ordline.lineNumber=string.valueOf(lineNumber);
                        system.debug(LoggingLevel.DEBUG,'lineNumber assigned : '+ordeline.Name+' : '+lineNumber);
                }
                        ordline.quantity=ordeline.Apttus_Config2__Quantity__c != null ? ordeline.Apttus_Config2__Quantity__c.setscale(3) : null;                        
                    //Added by Sakshi DOC-4715 - To send # of Attorneys at header level for Annual Products with Scaled pricing
                    if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='QU' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='MB'){                
                        ordreq.CreateOrderRequest.OrderHeader.numberOfAttorneys=string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                        numberOfAttorneys =string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0)); //DOC-9689
                        ordline.quantity=1;
                    }          
                    if(OnlineContactsController.validateProductLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, System.Label.OCBandedLowerLevelCodes) == true){                
                        ordreq.CreateOrderRequest.OrderHeader.numberOfAttorneys=string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                        numberOfAttorneys =string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0)); //DOC-9689
                        ordline.quantity=1;
                        
                    }
                  if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='06' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='OA'){
                        ordline.quantity=1;
                        ordline.priceQuantity =string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                    }
                    if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9'){
                        ordreq.CreateOrderRequest.OrderHeader.numberOfAttorneys=null;
                        numberOfAttorneys =''; //DOC-9689
                        ordline.quantity=ordeline.Apttus_Config2__Quantity__c.setscale(0);
                    }
                     if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='06' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9'){
                        ordreq.CreateOrderRequest.OrderHeader.numberOfAttorneys=string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                        numberOfAttorneys =string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0)); //DOC-9689
                        ordline.quantity=1;
                    }
                    //LTS-6468 
                    if(ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c !=null && ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c =='BENEFITGRP'){
                        //if(OnlineContactsController.validateProductLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, System.Label.CARSBenefittinggroup) == true){
                        ordline.priceQuantity =string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                        if(ordeline.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c != null){
                            ordreq.CreateOrderRequest.OrderHeader.numberOfAttorneys=string.valueof(ordeline.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c.setscale(0));
                            numberOfAttorneys = string.valueof(ordeline.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c.setscale(0)); //DOC-9689
                        }
                        ordline.quantity=1;
                       // }
                    }
                    if(ordeline.Apttus_Config2__AttributeValueId__r.APTS_Pricing_Quantity__c!=null && ((ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && (ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='NZ' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='NX' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='NT' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='NW')) || (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='05' && (ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='NZ' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='E9' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='')) || (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='06' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='AB'))){
                        ordline.priceQuantity =string.valueof(ordeline.Apttus_Config2__AttributeValueId__r.APTS_Pricing_Quantity__c);
                    }
               
                      if(ordline!=null && !String.isEmpty(ordeline.Apttus_Config2__BillingFrequency__c) && ordeline.Apttus_Config2__BillingFrequency__c=='Monthly'){
                          ordline.billPlanType='Monthly';
                      }
                      if(ordline!=null && !String.isEmpty(ordeline.Apttus_Config2__BillingFrequency__c) && ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                          ordline.billPlanType='Yearly';
                      }
                        
                        // Added by Chintan - billOfMaterialsType should be blank for HighQ 'One Time' products
                        if(ordeline.Apttus_Config2__ProductId__r.APTS_Cat_L2__c != null &&
                           ordeline.Apttus_Config2__ProductId__r.APTS_Cat_L2__c.equalsIgnoreCase(System.Label.APTS_HighQ_Product_Family)) {
                            if(ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c.equalsIgnoreCase('HighQ SubPrice Quantity'))
                            {
                                ordline.priceQuantity = String.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                                ordline.quantity=1;
                            }
                        }
                        
                        system.debug(LoggingLevel.DEBUG,'##### ordeline.Apttus_Config2__AttributeValueId__r'+ordeline.Apttus_Config2__AttributeValueId__c);
                        system.debug(LoggingLevel.DEBUG,'##### ordeline.Apttus_Config2__AttributeValueId__r'+ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c );
                        //GLP-183
                        if(ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c !=null 
                            && ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c !='') {
                            if (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '21' 
                                  && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'F4' 
                                  && ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZVSU') {
                                  if (ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Ship & Entitle Sub') {
                                      ordline.billOfMaterialsType = 'SES';
                                  } else if (ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Sub Only') {
                                      ordline.billOfMaterialsType = 'SON';
                                  } else if (ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Ship & Entitle Only') {
                                      ordline.billOfMaterialsType = 'SHO';
                                  }
                                  ordline.itemCategory='';
                                  ordline.programId = 'CAPR2';
                                  ordline.bundleType = True;
                              }
                        }
                        //GLP-183
                        //GLP-788
                        if (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '21' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'EC') {
                              ordline.itemCategory='';
                              ordline.programId = 'CARELL';
                              ordline.bundleType = True;
                        }
                        //End GLP-788
                        
                    //billOfMaterialsType based on purchase option                    
                  if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!=null && ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!='' && !isProflexBLI){                        
                    if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship & Enter Sub'){                 
                        //SOC-4845
                        //as per Ravali
                        if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR')) {
                            ordline.billPlanType='Monthly';
                        }   
                        //Lotus OC Canada added 'ZVAU'- Added by Sakshi for DOC-3722 - 5/3/2019
                        //Added by Poonam Garg DOC-1113
                        if(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZVAU' && ordeline.APTS_Proposal_Business_Unit__c=='Canada') {
                            ordline.billPlanType='Yearly';  
                        }
                    
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            //New
                                if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0) {
                                    ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;
                                }
                            }
                        ordline.billOfMaterialsType='SES';
                        //Sreenu Changes SOC-3371
                        //assignOrderLineitemCategory(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, ordeline.Apttus_Config2__BillingFrequency__c, ordeline.APTS_Program_ID__c);      
                        APTS_OrderSubmissionUtilityExt2.assignOrderLineitemCategory(new Map<String, String>{'icGroup'=>ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c,'billFrequency'=>ordeline.Apttus_Config2__BillingFrequency__c,'programId'=>ordeline.APTS_Program_ID__c},ordline);
                    }
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Sub Only'){
                        //SOC-4845
                        //as per ravali
                        if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR')) {
                            ordline.billPlanType='Monthly';
                        }
                        //Lotus OC Canada added 'ZVAU'- Added by Sakshi for DOC-3722 - 5/3/2019
                        //Added by Poonam Garg DOC-3016
                        if(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZVAU' && ordeline.APTS_Proposal_Business_Unit__c=='Canada') {
                            ordline.billPlanType='Yearly';  
                        }
                        if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            //New
                            if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0) {
                               ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;
                            }
                        }
                        ordline.billOfMaterialsType='SON';
                        //Sreenu Changes SOC-3371
                        //assignOrderLineitemCategory(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, ordeline.Apttus_Config2__BillingFrequency__c, ordeline.APTS_Program_ID__c);
                        APTS_OrderSubmissionUtilityExt2.assignOrderLineitemCategory(new Map<String, String>{'icGroup'=>ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c,'billFrequency'=>ordeline.Apttus_Config2__BillingFrequency__c,'programId'=>ordeline.APTS_Program_ID__c},ordline);
                    }
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship Only'){
                        //Lotus OC Canada added 'ZVAU'- Added by Sakshi for DOC-3722 - 5/3/2019
                        //Added by Poonam Garg DOC-3016
                        if(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZVAU' && ordeline.APTS_Proposal_Business_Unit__c=='Canada'){
                            ordline.billPlanType='Yearly';
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            //New
                                if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0) {
                                    ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;
                                }
                            }
                        }   
                        ordline.billOfMaterialsType='SHO';
                        }
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up'){
                        ordline.billOfMaterialsType='FUP';      
                        }
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship & Enter Sub APP'){
                        //SOC-4845
                        //ordline.billPlanType='Monthly';  - as per ravali 
                        //Added by Poonam Garg DOC-3016
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            //New
                                if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0) {
                                    ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;
                                }
                            }
                        ordline.billOfMaterialsType='SES';
                        ordline.itemCategory='ZGR2';
                        //Sreenu Changes SOC-3371
                        //assignOrderLineitemCategory(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, ordeline.Apttus_Config2__BillingFrequency__c, ordeline.APTS_Program_ID__c);
                        APTS_OrderSubmissionUtilityExt2.assignOrderLineitemCategory(new Map<String, String>{'icGroup'=>ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c,'billFrequency'=>ordeline.Apttus_Config2__BillingFrequency__c,'programId'=>ordeline.APTS_Program_ID__c},ordline);
                    }
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Sub Only APP'){
                        //SOC-4845
                        //ordline.billPlanType='Monthly'; //as per Ravali comment
                        //Added by Poonam Garg DOC-3016
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                                //New
                                if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0) {
                                    ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;
                                }
                            }
                        ordline.billOfMaterialsType='SON';
                        ordline.itemCategory='ZGR2';
                        //Sreenu Changes SOC-3371
                        //assignOrderLineitemCategory(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, ordeline.Apttus_Config2__BillingFrequency__c, ordeline.APTS_Program_ID__c);
                        APTS_OrderSubmissionUtilityExt2.assignOrderLineitemCategory(new Map<String, String>{'icGroup'=>ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c,'billFrequency'=>ordeline.Apttus_Config2__BillingFrequency__c,'programId'=>ordeline.APTS_Program_ID__c},ordline);
                    }                        
                  }                        
                  if(ordeline.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c!=null && ordeline.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c!='' && !isProflexBLI){                        
                    if(ordeline.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c=='APP'){
                         ordline.itemCategory='ZGR2';
                         ordline.billOfMaterialsType='SON';
                    }                 
                    
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c=='Entitle and Charge'){
                         ordline.billOfMaterialsType='SES';
                            }
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c=='Sub Only'){                       
                         ordline.billOfMaterialsType='SON';
                    }                       
                     else if(ordeline.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c=='Ship Only'){                       
                         ordline.billOfMaterialsType='SHO';
                    }
                      if(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c=='ZPMT')
                      {
                        ordline.itemCategory='ZGRP';
                      }
                      
                    }
          //Added by Bijeta DOC-5386 Small Law Cluster : To default the ICG for OLI to ZGRP and ZWL
                    if((!String.isEmpty(ordeline.Apttus_Config2__ProductId__r.Name)  && ordeline.Apttus_Config2__ProductId__r.Name.containsIgnoreCase(System.Label.APTS_CARS_SmallFirmPackage)) && ordeline.APTS_Proposal_Business_Unit__c==System.Label.SALESORGCAN){
                         System.debug(LoggingLevel.DEBUG,'RK --> Pgm Id Assigning block');
                         if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='21'){
                            ordline.itemCategory=System.Label.CARS_ItemCategorySLC;
                        if(ordeline.Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c && ordeline.Apttus_Config2__LineStatus__c == 'New') {
                            ordline.programId=System.Label.CARS_ProgramId;
                        }
                        system.debug(LoggingLevel.DEBUG,'RK --> Prgm Id for CATD'+ordline.programId);
                    }
                  else if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='06'){
                    ordline.itemCategory=System.Label.CARS_ItemCategorySLC1;
                        if(ordeline.Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c && ordeline.Apttus_Config2__LineStatus__c == 'New') {
                            ordline.programId=System.Label.CARS_ProgramId1;
                        }
                        system.debug(LoggingLevel.DEBUG,'RK --> Prgm Id for CCPRO'+ordline.programId);
                    }
                    } 
               
                    //Commented for SOC-5107
                   /* if(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c=='ZPMT' && ordeline.Apttus_Config2__SellingFrequency__c=='One Time')
                      {                        
                        PeriodicValue=(PeriodicValue+ordeline.Apttus_Config2__AdjustedPrice__c).setscale(2);
                      }*/
                    //skg soc-3454 ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c;    
                    //if(dynamicbundlelist.isEmpty() || (!dynamicbundlelist.isEmpty() && dynamicbundlelist[0].APTS_Bundle_Primary_Material__c==null)){  
                      //SOC-3454
                       if(ordeline.APTS_Group_Primary_Material__c==null) {
                       //skg soc-3454
                       //SOC-4845
                       //if((ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!='Ship & Enter Sub')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Sub Only')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship & Enter Sub APP')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Sub Only APP')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub APP'))
                        //SOC-7179 Adding Group equals null  
                        //Added by Poonam Garg DOC-3016                               
                           if(ordeline.Apttus_Config2__BillingFrequency__c!='Yearly'&& ordeline.APTS_Group__c==null){
                               ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? ordeline.Apttus_Config2__NetPrice__c.setscale(5) : null;
                           }
                        ordline.priceDate=null;
                        ordline.noBomExplosion=null;
                        ordline.storageLocation=null;
                        ordline.material.serviceMaterialId=ordeline.APTS_SAP_Deal_Primary_Material__c;
                        ordline.priceDate=date.valueof(ordeline.Apttus_Config2__PricingDate__c);
                        
                    //Renewals
                    if(ordeline.Apttus_Config2__LineStatus__c=='Renewed'){
                        ordline.itemCategory='ZRNW';
                         
                    }
                       // Fill up & Enter Sub Validations
                        isFillup = False;
                        isFillupOption = False;
                        isFillupOnly = False;                        
                        if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub'){
                        //SOC-4845 - as per Ravali
                        //ordline.billPlanType='Monthly';
                        isFillup = True;
                        if(ordeline.Apttus_Config2__ChargeType__c == 'Subscription Fee' && ordeline.Apttus_Config2__PriceType__c == 'One Time') {
                            ordline.material.materialId=ordeline.APTS_Subscription_Number__c ;                    
                            ordline.netAmount=null;
                            //SOC-4845
                            if(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR'){
                            ordline.billPlanType='Monthly'; // as per Ravali                            
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c).setscale(5) : null;
                            }
                            fillupadjustment= new CreateOrderRequest.adjustments();
                            fillupadjustment.type='PERCENT';
                            if(ordeline.Apttus_Config2__AdjustmentAmount__c!=null){
                                fillupadjustment.amount=ordeline.Apttus_Config2__AdjustmentAmount__c.setscale(9);
                            }ordline.adjustments.add(fillupadjustment); 
                            //Added by Poonam Garg DOC-3016
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                                //New
                                if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0) {
                                    ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;
                                }
                            }
                            //} - as per Ravali
                            
                            oli = ordeline;
                            isSubFee = True; 
                            if(lineNumber != 1) {
                                lineNumber+=1;
                                system.debug(LoggingLevel.DEBUG,'lineNumber assigned : +1 '+ordeline.Name+' : '+lineNumber);
                            }
                            if(fillupLineNumber != 1) {
                                fillupLineNumber += 1;
                            }
                        }
                        else if(ordeline.Apttus_Config2__ChargeType__c == 'Standard Price' && ordeline.Apttus_Config2__PriceType__c == 'One Time' && ordeline.Apttus_Config2__LineType__c == 'Option') {
                            /*if(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR'){
                            //SOC-4845
                            ordline.listAmount=0;
                            }else { Removed as per Ravali comment*/

                                ordline.adjustments.add(fillupadjustment);     
                                 //}
                            ordline.material.materialId=ordeline.Apttus_Config2__OptionId__r.ProductCode ;                    
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? ordeline.Apttus_Config2__NetPrice__c.setscale(5) : null;     
                            lineNumber+=1;
                            system.debug(LoggingLevel.DEBUG,'lineNumber assigned : +1 '+ordeline.Name+' : '+lineNumber);
                            fillupLineNumber +=1;
                            isSubFee = False;
                        }
                        else if(ordeline.Apttus_Config2__ChargeType__c == 'Standard Price' && ordeline.Apttus_Config2__PriceType__c == 'One Time' && ordeline.Apttus_Config2__LineType__c == 'Product/Service') {
      
                            fillupadjustment= new CreateOrderRequest.adjustments();
                            fillupadjustment.type='PERCENT';
                            if(ordeline.Apttus_Config2__AdjustmentAmount__c!=null){
                                fillupadjustment.amount=ordeline.Apttus_Config2__AdjustmentAmount__c.setscale(9);
                            }ordline.material.materialId=ordeline.Apttus_Config2__ProductId__r.ProductCode ;                    
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? ordeline.Apttus_Config2__NetPrice__c.setscale(5) : null;
                            //SOC-4845 need to verify fill & entersub scenario
                           /* if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            ordline.netAmount=(ordeline.Apttus_Config2__NetPrice__c/12).setscale(5);
                            }*/
                            ordline.noBomExplosion = 'X';
                            lineNumber+=1;
                            system.debug(LoggingLevel.DEBUG,'lineNumber assigned : +1 '+ordeline.Name+' : '+lineNumber);
                            fillupLineNumber +=1;
                            isSubFee = False;
                            //Sreenu Changes SOC-3371
                            //assignOrderLineitemCategory(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, ordeline.Apttus_Config2__BillingFrequency__c, ordeline.APTS_Program_ID__c);
                            APTS_OrderSubmissionUtilityExt2.assignOrderLineitemCategory(new Map<String, String>{'icGroup'=>ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c,'billFrequency'=>ordeline.Apttus_Config2__BillingFrequency__c,'programId'=>ordeline.APTS_Program_ID__c},ordline);
                        }
                    }
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub APP'){
                        isFillup = True; 
                        //SOC-4845
                        //ordline.billPlanType='Monthly'; //removed as per ravali
                            
                        if(ordeline.Apttus_Config2__ChargeType__c == 'Subscription Fee' && ordeline.Apttus_Config2__PriceType__c == 'Recurring' ) {
                            ordline.material.materialId=ordeline.APTS_Subscription_Number__c ;                    
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? ordeline.Apttus_Config2__NetPrice__c.setscale(5) : null;
                            //SOC-4845
                            //Added by Poonam Garg DOC-1113
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                                //New
                                if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0) {
                                    ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;
                                }
                            }
                            fillupadjustment= new CreateOrderRequest.adjustments();
                            fillupadjustment.type='PERCENT';
                            if(ordeline.Apttus_Config2__AdjustmentAmount__c!=null){
                                fillupadjustment.amount=ordeline.Apttus_Config2__AdjustmentAmount__c.setscale(9);
                            }ordline.adjustments.add(fillupadjustment); 
                            if(lineNumber != 1) {
                            lineNumber+=1;
                            system.debug(LoggingLevel.DEBUG,'lineNumber assigned : +1 '+ordeline.Name+' : '+lineNumber);
                            }
                            if(fillupLineNumber != 1) {
                             fillupLineNumber += 1;
                            }
                            isSubFee = True;
                        }
                        else if(ordeline.Apttus_Config2__ChargeType__c == 'Standard Price' && ordeline.Apttus_Config2__PriceType__c == 'One Time' && ordeline.Apttus_Config2__LineType__c == 'Product/Service') {
                            ordline.material.materialId=ordeline.Apttus_Config2__ProductId__r.ProductCode ;                    
                            ordline.netAmount=null;
                            lineNumber+=1;
                            system.debug(LoggingLevel.DEBUG,'lineNumber assigned : +1 '+ordeline.Name+' : '+lineNumber);
                            fillupLineNumber +=1;
                            ordline.noBomExplosion = 'X';
                            isSubFee = False;
                            //******
                            ordline.itemCategory='ZGR2';
                            //*****
                            //Sreenu Changes SOC-3371
                            //assignOrderLineitemCategory(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, ordeline.Apttus_Config2__BillingFrequency__c, ordeline.APTS_Program_ID__c);
                            APTS_OrderSubmissionUtilityExt2.assignOrderLineitemCategory(new Map<String, String>{'icGroup'=>ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c,'billFrequency'=>ordeline.Apttus_Config2__BillingFrequency__c,'programId'=>ordeline.APTS_Program_ID__c},ordline);
                        }
                        else if(ordeline.Apttus_Config2__ChargeType__c == 'Standard Price' && ordeline.Apttus_Config2__PriceType__c == 'One Time' && ordeline.Apttus_Config2__LineType__c == 'Option') {
                            ordline.material.materialId=ordeline.Apttus_Config2__OptionId__r.ProductCode ;                    
                            ordline.netAmount=null;      
                            lineNumber+=1;
                            fillupLineNumber +=1;
                            isSubFee = False;
                            system.debug(LoggingLevel.DEBUG,'lineNumber assigned : +1 '+ordeline.Name+' : '+lineNumber);
                        }
                    
                    }
                    // Fill-Up Validations
                    
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up'){
                        isFillupOnly = True;
                        if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up' && ordeline.Apttus_Config2__ChargeType__c == 'Standard Price' && ordeline.Apttus_Config2__PriceType__c == 'One Time' && ordeline.Apttus_Config2__LineType__c == 'Product/Service') {
                            fillupadjustment= new CreateOrderRequest.adjustments();
                            fillupadjustment.type='PERCENT';
                            if(ordeline.Apttus_Config2__AdjustmentAmount__c!=null){
                                fillupadjustment.amount=ordeline.Apttus_Config2__AdjustmentAmount__c.setscale(9);
                            }//ordline.adjustments.add(fillupadjustment);
                        }
                        if(ordeline.Apttus_Config2__ChargeType__c == 'Standard Price' && ordeline.Apttus_Config2__PriceType__c == 'One Time' && ordeline.Apttus_Config2__LineType__c == 'Option') {
                            ordline.material.materialId=ordeline.Apttus_Config2__OptionId__r.ProductCode ;                    
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? ordeline.Apttus_Config2__NetPrice__c.setscale(5) : null;
                            ordline.adjustments.add(fillupadjustment);                             
                            isFillupOption = True;                            
                            /*if(lineNumber != 1) {
                                lineNumber+=1;
                            } */  

                        }
                    }

                    //Bridge details
                    if(ordeline.APTS_New_Bridge_Discount__c!=null){
                        ordline.netAmount=ordeline.bridge_net_price__c!=null ? ordeline.bridge_net_price__c.setscale(5) : null;
                        }  
                        //SOC-4845
                        //Ravali
                    if(vRiskRIProfessionalServices!=null && vRiskRIProfessionalServices!='' && 
                        ordline.material.materialId!=null && ordline.material.materialId!='' && 
                        vRiskRIProfessionalServices.contains(ordline.material.materialId)){
                        ordline.netAmount=0;
                    }
                       //if((ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!='Ship & Enter Sub')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Sub Only')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship & Enter Sub APP')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Sub Only APP')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub APP'))                 
                        //Added ZVAU by Sakshi DOC-3722
                    if(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c != 'ZPMT' && ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c !='ZPAV' && ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c !='ZBAR' && ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c !='ZVAU'){
                        if(ordline!=null && !String.isEmpty(ordeline.Apttus_Config2__BillingFrequency__c) && ordeline.Apttus_Config2__BillingFrequency__c=='Monthly'){
                          ordline.billPlanType='Monthly';
                        }
                        //Added by Poonam Garg DOC-3016
                        if(ordline!=null && !String.isEmpty(ordeline.Apttus_Config2__BillingFrequency__c) && ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                          ordline.billPlanType='Yearly';
                        }
                    }   
                        //ordline.billPlanType=ordeline.Apttus_Config2__SellingFrequency__c;
                    if(ordeline.APTS_Bridge__c=='N/a'){
                        ordline.billPlanUpdateRule='0';
                        }
                    else if(ordeline.APTS_Bridge__c=='1 Month'){
                        ordline.billPlanUpdateRule='1';
                        }
                    else if(ordeline.APTS_Bridge__c=='2 Months'){
                        ordline.billPlanUpdateRule='2';
                        }
                    else if(ordeline.APTS_Bridge__c=='3 Months'){
                        ordline.billPlanUpdateRule='3';
                        }
                    else if(ordeline.APTS_Bridge__c=='4 Months'){
                        ordline.billPlanUpdateRule='4';
                        }
                    else if(ordeline.APTS_Bridge__c=='5 Months'){
                        ordline.billPlanUpdateRule='5';
                        }
                    else if(ordeline.APTS_Bridge__c=='6 Months'){
                        ordline.billPlanUpdateRule='6';
                        }
                    else if(ordeline.APTS_Bridge__c=='7 Months'){
                        ordline.billPlanUpdateRule='7';
                        }
                    else if(ordeline.APTS_Bridge__c=='8 Months'){
                        ordline.billPlanUpdateRule='8';
                        }
                    else if(ordeline.APTS_Bridge__c=='9 Months'){
                        ordline.billPlanUpdateRule='9';
                        }
                    else if(ordeline.APTS_Bridge__c=='10 Months'){
                        ordline.billPlanUpdateRule='10';
                        }
                    else if(ordeline.APTS_Bridge__c=='11 Months'){
                        ordline.billPlanUpdateRule='11';
                        }
                    //SOC-6446 Bijeta May
                    else if(ordeline.APTS_Bridge__c=='7 Days'){
                        ordline.billPlanUpdateRule='7D';
                        }
                   else if(ordeline.APTS_Bridge__c=='14 Days'){
                        ordline.billPlanUpdateRule='14D';
                        }
                    else if(ordeline.APTS_Bridge__c=='28 Days'){
                        ordline.billPlanUpdateRule='28D';
                        }
                    if(ordline.billPlanUpdateRule!=null){
                        //ordline.adjRnwlBaseValue=String.valueOf(ordeline.APTS_Calculated_Year_1__c);
                        //DOC-15584 Changes.
                        if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly' && ordeline.Apttus_Config2__BillingFrequency__c!=null){
                            ordline.adjRnwlBaseValue= ordeline.APTS_Calculated_Year_1__c !=null ? String.valueOf((ordeline.APTS_Calculated_Year_1__c/12).setscale(2)) : null;
                        }
                        else{
                            ordline.adjRnwlBaseValue= ordeline.APTS_Calculated_Year_1__c !=null ? String.valueOf((ordeline.APTS_Calculated_Year_1__c).setscale(2)) : null;}
                    }
                }
                //SOC-5992                
                if(ordeline.Apttus_Config2__LineStatus__c=='New'){
                   if(ordeline.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c !=null){
                       ordline.programId = 'SEAT';                       
                     }       
                   else if (ordeline.Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c ==True ){
                           ordline.bundleType=true;                       
                       if((ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='06' &&(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='I9' ||ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='LW'))||
                           (APTS_OrderSubmissionUtilityExt2.validateMLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, System.Label.APTS_MLLCodes_CPRO))) {                          
                            ordline.programId = 'CPRO';
                        }
                                
                       else if ((ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='06' && (APTS_OrderSubmissionUtilityExt2.validateMLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c,System.Label.APTS_MLLCodes_06SEAT)))|| 
                           (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='13' && (APTS_OrderSubmissionUtilityExt2.validateMLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c,System.Label.APTS_MLLCodes_13SEAT)))||
                           (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='05' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='E2')) {
                            ordline.programId = 'SEAT';                    
                        }
                       
                          } 
                     }
                
                    //Renewals
                if(ordeline.Apttus_Config2__LineStatus__c=='Renewed'){
                        ordline.itemCategory='ZRNW';
                         
                    }                   
                ordline.unitOfMeasure='EA';
                if(ordeline.APTS_Group__c==null){
                    //SOC-5909 ELS Fix
                    //MCL-1976
                    //Added by Sakshi - Lotus OC Canada - list price for non-billing products
                    if(ordeline.Apttus_Config2__BillingFrequency__c==null && ordeline.APTS_Proposal_Business_Unit__c=='Canada'){
                        ordline.listAmount=ordeline.Apttus_Config2__ListPrice__c != null ? ordeline.Apttus_Config2__ListPrice__c.setscale(5) : null;        
                    }

                    if(ordeline.Apttus_Config2__BillingFrequency__c=='Monthly'){
                        if(ordeline.Apttus_Config2__PriceMethod__c == 'Per Unit'){ //DOC-15436
                            ordline.listAmount = ordeline.Apttus_Config2__ListPrice__c != null ? (ordeline.Apttus_Config2__ListPrice__c * ordeline.Apttus_Config2__Quantity__c).setscale(5) : null;
                        }else{
                            ordline.listAmount=ordeline.Apttus_Config2__ListPrice__c != null ? ordeline.Apttus_Config2__ListPrice__c.setscale(5) : null;   
                        }     
                    } 
                    //Added by Poonam Garg DOC-3016
                    if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                        if(ordeline.Apttus_Config2__PriceMethod__c == 'Per Unit'){ //DOC-15436
                            ordline.listAmount=ordeline.Apttus_Config2__ListPrice__c != null ? (((ordeline.Apttus_Config2__ListPrice__c * ordeline.Apttus_Config2__Quantity__c)/12).setscale(5)) : null;        
                        }else{
                            ordline.listAmount=ordeline.Apttus_Config2__ListPrice__c != null ? ((ordeline.Apttus_Config2__ListPrice__c/12).setscale(5)) : null;        
                        }
                    }                  
                    //ordline.listAmount=ordeline.Apttus_Config2__ListPrice__c.setscale(5); 
                      //SOC-4845
                      /*if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR') && ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub' && ordeline.Apttus_Config2__LineType__c == 'Option'){
                               ordline.listAmount=0;
                               }*///as per ravali
                               //Added ZVAU and PBU = CANADA for DOC-3722 - Sakshi - 5/3/2019
                               //Added by Poonam Garg DOC-3016
                               if(((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPAL') || (ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZVAU' && ordeline.APTS_Proposal_Business_Unit__c=='Canada')) &&(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly')){
                                //New
                            if(ordeline.Apttus_Config2__ListPrice__c!=null&&ordeline.Apttus_Config2__ListPrice__c!=0){
                            
                            ordline.listAmount= ordeline.Apttus_Config2__ListPrice__c!=null ? (ordeline.Apttus_Config2__ListPrice__c/12).setscale(5) : null;
                            
                            }
                             } //as per Ravali - SOC-4845
                             //Added by Poonam Garg DOC-3016
                            if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR') && ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub' && ordeline.Apttus_Config2__LineType__c == 'Product/Service' &&(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly')){
                               if(ordeline.Apttus_Config2__ListPrice__c!=null&&ordeline.Apttus_Config2__ListPrice__c!=0){
                            
                            ordline.listAmount= ordeline.Apttus_Config2__ListPrice__c!=null ? (ordeline.Apttus_Config2__ListPrice__c/12).setscale(5) : null;
                            
                            }
                               }
                               //Added by Poonam Garg DOC-3016
                            if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR') && ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!='Fill-Up & Enter Sub'&&(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly')){
                               if(ordeline.Apttus_Config2__ListPrice__c!=null&&ordeline.Apttus_Config2__ListPrice__c!=0){
                            
                            ordline.listAmount=ordeline.Apttus_Config2__ListPrice__c!=null ? (ordeline.Apttus_Config2__ListPrice__c/12).setscale(5) : null;
                            
                            }
                               }
                            /*if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPAL'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR')&&(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly')){
                                //New
                            if(ordeline.Apttus_Config2__ListPrice__c!=null&&ordeline.Apttus_Config2__ListPrice__c!=0){
                            
                            ordline.listAmount=(ordeline.Apttus_Config2__ListPrice__c/12).setscale(5);
                            
                            }
                            //SOC-4845 End
                             } */
                             //SOC-4845 End
                             //DOC-15023
                             if (ordeline.Apttus_Config2__ProductId__r.Family != null && ordeline.Apttus_Config2__ProductId__r.Family.equalsIgnoreCase(System.Label.Caseline_Product_Family)) {
                                blnIsCaseLine = True;
                            }
                            //DOC-15637
                            if (blnIsCaseLine && ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'PQ'&& ordeline.APTS_Term_Type__c == 'Future Start Date' && String.isBlank(ordeline.APTS_Group_Primary_Material__c)) {    
                                ordline.subscriptionDetail.contractStartDate=ordeline.APTS_Start_Date__c; 
                            } 
                            if (blnIsCaseLine && (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='26' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13') && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='') {
                                ordline.billOfMaterialsType='';
                            }
                            //End 15023
                            //Added as part of DOC-13773
                            if((ordline.billPlanType == 'One Time' || ordline.billPlanType == '') && (ordreq.CreateOrderRequest.ESIHeader.applicationId != 'TRSTR')){ //DOC-15023
                                if(ordeline.Apttus_Config2__PriceMethod__c == 'Per Unit'){ //DOC-15023
                                    ordline.listAmount = ordeline.Apttus_Config2__ListPrice__c != null ? (ordeline.Apttus_Config2__ListPrice__c * ordeline.Apttus_Config2__Quantity__c).setscale(5) : null;
                                }else if(ordeline.Apttus_Config2__PriceMethod__c == 'Flat Price'){
                                    ordline.listAmount = ordeline.Apttus_Config2__ListPrice__c != null ? ordeline.Apttus_Config2__ListPrice__c.setscale(5) : null;
                                }
                            }
                            //Ended as part of DOC-13773
                 }
                 //DOC-14696
                 if(vRiskRIProfessionalServices!=null && vRiskRIProfessionalServices!='' && 
                        ordline.material.materialId!=null && ordline.material.materialId!='' && 
                        vRiskRIProfessionalServices.contains(ordline.material.materialId)){
                            ordline.listAmount = 0;
                    }           
                 //SOC-8352
                 CreateOrderRequest.adjustments adjustment= new CreateOrderRequest.adjustments();
                if(ordeline.APTS_Group__c==null&&ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!='Fill-Up'&&ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!='Fill-Up & Enter Sub'&&ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!='Fill-Up & Enter Sub APP'){
                    //ordline.listAmount=ordeline.Apttus_Config2__ListPrice__c;
                    //Adjustmemnt amount
                    
                    if(ordeline.Apttus_Config2__AdjustmentType__c=='% Discount')
                    {
                        adjustment.type='PERCENT';
                        adjustment.discountType='NormalDiscount';//SOC-6755 May Bijeta
                           //DOC-14696
                        if(vRiskRIProfessionalServices != null && vRiskRIProfessionalServices != '' && ordline.material.materialId != null && ordline.material.materialId != '' && vRiskRIProfessionalServices.contains(ordline.material.materialId)){
                            adjustment.amount = 0;
                         }
                         else if(ordeline.Apttus_Config2__AdjustmentAmount__c!=null) {
                            adjustment.amount=ordeline.Apttus_Config2__AdjustmentAmount__c.setscale(9);
                         }
                    }
                    
                     else if(ordeline.Apttus_Config2__AdjustmentType__c=='% Markup' || ordeline.Apttus_Config2__AdjustmentType__c=='Price Override')
                    {
                          adjustment.type='FIXED_MARKUP';
                          adjustment.discountType='NormalSurcharge';//SOC-6755 May Bijeta
                          //Sakshi DOC-4357 Lotus OC CANADA Sending Surcharge divided by 12 for DOC-3722
                          if(vRiskRIProfessionalServices != null && vRiskRIProfessionalServices != '' && ordline.material.materialId != null && ordline.material.materialId != '' && vRiskRIProfessionalServices.contains(ordline.material.materialId)){
                            adjustment.amount = 0;
                        }else{
                          adjustment.amount=ordeline.Apttus_Config2__AdjustedPrice__c-ordeline.Apttus_Config2__BaseExtendedPrice__c;
                          if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly' && ordeline.APTS_Proposal_Business_Unit__c=='Canada'){
                            adjustment.amount=(adjustment.amount/12);  
                          }
                          if(adjustment.amount!=null){
                            adjustment.amount=adjustment.amount.setscale(9);
                          }
                          }
                        }
                    if(ordeline.APTS_New_Bridge_Discount__c!=null){
                        // value is overiding so created new instance of adjustments
                        CreateOrderRequest.adjustments adjustment1 = new CreateOrderRequest.adjustments();
                        //SOC-3691 SKG
                        //adjustment1.type = adjustment.type;
                        adjustment1.type='PERCENT';
                        adjustment1.discountType='BridgeDiscount';//SOC-6755 May Bijeta
                        if(ordeline.APTS_New_Bridge_Discount__c!=null){
                                adjustment1.amount=ordeline.APTS_New_Bridge_Discount__c.setscale(9);
                        }ordline.adjustments.add(adjustment1);                                          
                    }
                    
                }
                //SOC-8352
                    adjustment.promotionCode=ordeline.Apttus_Config2__IncentiveCode__c;
                    ordline.adjustments.add(adjustment);                    
                //SOC-5819 comment mode A
                //ordreq.CreateOrderRequest.OrderHeader.oaMode='A';
                //Soc3464 Included If condition for LMA products
                 /*List<String> lsCARSPrintPrimary = new List<String>();
                 lsCARSPrintPrimary =vCARSPrintPrimary.split(',');
                 //Commented oaMode A as a part of DOC-15125
                 if(lsCARSPrintPrimary.contains(ordeline.Apttus_Config2__ProductId__r.ProductCode)){
                     //Commented oaMode A as a part of DOC-15125
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='A';
                    //isModeA=true;
                }*/
                //Soc-3625 start---
               
                //soc-3625 end---    
                //SOC-3958 removing condition to check dollar value from if condition ordeline.Apttus_Config2__OrderId__r.APTS_Order_Value__c<2000                  
                //SOC-5819 Adding OR condition starting with ordeline.APTS_Group__c ==Null//SOC-5990 Removing Line Status New
                //Modifying Else if SOC-5991
                //Added Media High Level Code = 02 for Lotus OC Canada - Sakshi - DOC-3510 on 5/3/2019
                //Commented as a part of DOC-15125
                /*else if((ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='07' || 
                ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='02' || 
                ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='21' ||
                (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='08'&& 
                ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='73') || 
                (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='08'&& 
                ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='75') ||
                (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='08'&& 
                ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='38'))
                || ordeline.APTS_Program_ID__c=='WCMP'||
                (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='05' ||
                 ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='06' ||
                 ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='13' ||
                 (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='26' &&
                  (ordeline.Apttus_Config2__ProductId__r.Family == 'RISK SOLUTIONS' || 
                  ordeline.Apttus_Config2__ProductId__r.Family == 'ACRITAS' || blnIsCaseLine )))){ //DOC-15023
                    System.debug(LoggingLevel.DEBUG,'%%%%oamodew'+ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c);
                   ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                        isModeW=true;
                         System.debug(LoggingLevel.DEBUG,'%%%%oamodew12'+ordeline.Id);
                }
                else{
                    isModeA=true; 
                }*/
                // Soc-3465 Changes               
                //SOC-3783 - Sreenu moved this condition before 166 line
                /*if(ordeline.Apttus_Config2__LineStatus__c =='Cancelled' && isnotMLAModify && !string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c)
                    && (ordeline.APTS_Service_Number__c == '40757482' || ordeline.APTS_Service_Number__c == '41308780' || ordeline.APTS_Service_Number__c == '41841981' || ordeline.APTS_Service_Number__c == '41841759'))
                    isMLAReplace = True; */
                if(ordeline.APTS_Bridge__c!=null){
                    CreateOrderRequest.orderNotes orderNote1= new CreateOrderRequest.orderNotes();
                    orderNote1.notes='Short term contract';
                    ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(orderNote1);
                } //SOC-6561 - added a check for option line type
                else if(ordeline.APTS_Group__c==null && ((!dynamicbundlelist.isEmpty() && !string.isEmpty(ordeline.Apttus_Config2__ProductId__r.ProductCode)) || isProflex)  && ordeline.Apttus_Config2__LineType__c != 'Option' ){
                    CreateOrderRequest.orderNotes orderNote2= new CreateOrderRequest.orderNotes();
                    orderNote2.notes='stand alone Material:'+ordeline.Apttus_Config2__ProductId__r.ProductCode+'.';
                    ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(orderNote2);
                
                }
                System.debug(LoggingLevel.DEBUG,ordline.referenceNumber);
                System.debug(LoggingLevel.DEBUG,isFillup +' ' + isFillupOnly);
                if(isFillup){
                    //isFillup= False;                    
                    if(isSubFee) {                        
                        subFeeOrder = ordline;
                        isSubFeeOrder = True;
                        // isSubFee = False;
                    } 
                    If(isSubFeeOrder && !isSubFee) {                    
                        plNum = lineNumber - 1;                        
                        ordline.lineNumber= string.valueOf(plNum);
                        ordline.relatedLine = '';
                        ordreq.CreateOrderRequest.orderLines.add(ordline);                       
                        subFeeOrder.lineNumber= String.valueOf(lineNumber);
                        system.debug(LoggingLevel.DEBUG,'lineNumber assigned : '+ordeline.Name+' : '+lineNumber);
                        subFeeOrder.relatedLine = string.valueOf(plNum);
                        subFeeOrder.noBomExplosion = '';
                        ordreq.CreateOrderRequest.orderLines.add(subFeeOrder);                        
                        isSubFeeOrder = False;
                        oli = new Apttus_Config2__OrderLineItem__c();
                    }
                    else if(!isSubFeeOrder && !isSubFee) {                        
                        ordline.lineNumber= string.valueof(lineNumber);
                        ordline.relatedLine = string.valueOf(plNum);
                        ordreq.CreateOrderRequest.orderLines.add(ordline);  
                        system.debug(LoggingLevel.DEBUG,'lineNumber assigned : '+ordeline.Name+' : '+lineNumber);                      
                    }
                }
                 else If(isFillupOnly && isFillupOption) {                    
                    ordline.lineNumber= string.valueof(lineNumber);
                    ordreq.CreateOrderRequest.orderLines.add(ordline);                    
                    if(!ordeline.APTS_is_Primary_in_Bundle__c){                     
                    lineNumber+=1;}    
                    system.debug(LoggingLevel.DEBUG,'lineNumber assigned : +1 '+ordeline.Name+' : '+lineNumber);
                }
                
                else If(!isFillupOnly && !isFillup){    
                    ordreq.CreateOrderRequest.orderLines.add(ordline);            
                   if(!ordeline.APTS_is_Primary_in_Bundle__c){                     
                    lineNumber+=1;}
                    system.debug(LoggingLevel.DEBUG,'lineNumber assigned : +1 '+ordeline.Name+' : '+lineNumber);
                }
            }
              //SOC-4367 Nov Changes
            if(order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=''){
                    ordline.saID=order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c.substringAfter('(').remove(')');  
                    }
            }
                //}DOC-12198  
            //Commented oaMode A as a part of DOC-15125
            /*if(((isModeA && isModeW) || isModeA) && ordreq.CreateOrderRequest.OrderHeader.oaMode !='E_SO' && ordreq.CreateOrderRequest.OrderHeader.oaMode !='E'){
              ordreq.CreateOrderRequest.OrderHeader.oaMode='A';
            }*/
            
            For(Apttus_Config2__OrderLineItem__c dealitem :orderLineItems)
            {   
                if(dealitem.Apttus_Config2__LineStatus__c=='Existing' || dealitem.Apttus_Config2__LineStatus__c=='Amended'){
                    CreateOrderRequest.orderNotes dealnote= new CreateOrderRequest.orderNotes();                    
                    dealnote.notes='Existing subs: '+dealitem.APTS_Group__c+':'+dealitem .APTS_Subscription_Number__c+'; SUB: '+String.valueOf(dealitem.APTS_Contract_Number__c)+' ' +String.valueOf(dealitem.APTS_Contract_Line_Number__c)+'.';
                    ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(dealnote);
                
                }
                 if(isMLAModify && dealitem.Apttus_Config2__LineStatus__c=='Renewed'){
                    CreateOrderRequest.orderNotes renewalNote= new CreateOrderRequest.orderNotes();                    
                    renewalNote.notes='Quote Contains a Renewal. Please refer to Contract Document. Quote Line: '+dealitem.Apttus_Config2__LineNumber__c+'.';
                    ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(renewalNote);
                    //SOC-5991 //SOC-7834 Changing to ModeW
                    //isModeW=true;  //DOC-15125 
                    System.debug(LoggingLevel.DEBUG,'***Proflex Renewal + Mod***'+dealitem.id);                  
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='W'; //Commented and moved to APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                    
                }
            }      
            //LAPSE ORDER
            For(Apttus_Config2__OrderLineItem__c lapse:orderLineItems)
            {      
                if(lapse.Apttus_Config2__LineStatus__c=='Cancelled'){
                    isOnline =true;
                    CreateOrderRequest.orderLapseLines laps = new CreateOrderRequest.orderLapseLines();
                    laps.materialId=lapse.APTS_Subscription_Number__c;
                    laps.contractNumber=string.valueOf(lapse.APTS_Contract_Number__c);
                    laps.dealType=lapse.APTS_Deal_Type__c ;
                    laps.contractLineNumber= string.valueOf(lapse.APTS_Contract_Line_Number__c);
                    //laps.description=lapse.Apttus_Config2__Description__c;
                    laps.reasonCode='OL';
                    laps.dealNumber=string.valueOf(lapse.APTS_Deal_Number__c);
                    laps.agreementNumber=string.valueOf(lapse.APTS_SAP_MLA_Agreement_Number__c);//Bijeta May SOC-5984                    
                     //Start:DOC-14661
                    if ((blnIsCaseLine && lapse.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '13' && lapse.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'PQ')
                    || (lapse.Apttus_Config2__ProductId__r.Productcode != null && vCLValidProflex.contains(lapse.Apttus_Config2__ProductId__r.Productcode))) {
                        laps.lapseDate = APTS_OrderSubmissionUtilityExt3.updateLapseDate(lapse);
                    } //End:DOC-14661
                     else  {
                      laps.lapseDate=null;
                    }
                    laps.lapseCode='OL';
                    laps.lapseQuantity=null;
                    
                    if(isnotMLAModify && !string.isEmpty(lapse.APTS_SAP_MLA_Agreement_Number__c) && materialNumberList1.contains(lapse.APTS_Service_Number__c)){
                    CreateOrderRequest.orderNotes mlaagrement= new CreateOrderRequest.orderNotes();
                    MLAagrement.notes='Replace MLA Agreement Number: '+lapse.Apttus_QPConfig__ProposalLineItemId__r.APTS_SAP_MLA_Agreement_Number__c+'.';
                    ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(MLAagrement);                      
                    }  
                    //ordreq.CreateOrderRequest.orderLapseLines.add(laps);    
                    //SOC-5819
                    //SOC-5991 //7834 Changing to ModeW
                    if (lapse.APTS_Info_PlanType__c =='S00'){
                    isModeW=true; 
                    System.debug(LoggingLevel.DEBUG,'***Lapsed ModeA AssetLineItem***'+lapse.id);
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='W'; //Commented and moved to APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                    laps.specialOfferLapseFlag='True';                    
                    }                
                    ordreq.CreateOrderRequest.orderLapseLines.add(laps);             
                }
            }
            
             //Bijeta May SOC-6439
            For(APTS_Additional_Subscription_Actions__c add:additionalSublist)
            {      
                if(add.APTS_Line_Status__c =='Cancelled'){
                    isOnline =true;
                    CreateOrderRequest.orderLapseLines laps1 = new CreateOrderRequest.orderLapseLines();
                    laps1.materialId=add.APTS_Subscription_Number__c;
                    laps1.contractNumber=string.valueOf(add.APTS_Contract_Number__c);
                    laps1.contractLineNumber= string.valueOf(add.APTS_Contract_Line_Number__c);
                     
                    ordreq.CreateOrderRequest.orderLapseLines.add(laps1); 
                    
                              
                }
            }
            system.debug(LoggingLevel.DEBUG,'###### materialMap'+materialMap+'##### bundlematerialMap'+bundlematerialMap);
            //online contacts
            For(Online_Contacts__c onlinecon1 : onlinecon) 
            {                  
                if((!materialMap.isEmpty() && materialMap.containsKey(onlinecon1.Material__c)) || (!bundlematerialMap.isEmpty() && bundlematerialMap.containsKey(onlinecon1.Material__c))){                
                    CreateOrderRequest.onlineContacts onlineContact = new CreateOrderRequest.onlineContacts();
                    onlineContact.firstName=onlinecon1.First_Name__c;
                    onlineContact.lastName=onlinecon1.Last_Name__c;
                    onlineContact.emailAddress=onlinecon1.Email__c;
                    //SOC-7060                   
                    onlineContact.locationAccountNumber=onlinecon1.APTS_Source_System_Detail__r.Source_System_Account_Number__c;                                                                              
                    // send 0230 contact if Product brand code is 064
                    if(onlinecon1.Type__c=='Admin' && !materialBrandCodeMap.isEmpty() && materialBrandCodeMap.containsKey(onlinecon1.Material__c) && materialBrandCodeMap.get(onlinecon1.Material__c) == '064'){
                       onlineContact.onlineContactType='0230';
                    }  
                    else if(onlinecon1.Position__c == 'Attorney'){  
                       onlineContact.onlineContactType='0100';
                        }
                    else if(onlinecon1.Position__c=='Clerk'){
                       onlineContact.onlineContactType='0050';
                        }
                    else if(onlinecon1.Position__c=='Judge'){
                       onlineContact.onlineContactType='0080';
                        }
                    else if(onlinecon1.Position__c=='Librarian'){
                       onlineContact.onlineContactType='0060';
                        }
                    else if(onlinecon1.Position__c=='Non-Attorney'){
                        onlineContact.onlineContactType='0090';
                        }
                    else if(onlinecon1.Position__c=='Paralegal'){
                       onlineContact.onlineContactType='0030';
                        }
                    else if(onlinecon1.Position__c=='Administrator'){
                         onlineContact.onlineContactType='0290';
                        }                    
                    else if(onlinecon1.Position__c=='Analyst'){
                        onlineContact.onlineContactType='0310';
                        }
                     else if(onlinecon1.Position__c=='Supervisor'){
                       onlineContact.onlineContactType='0280';
                        }                      
                        else if(onlinecon1.Position__c=='Clear Administrator'){
                        onlineContact.onlineContactType='0290';
                        }
                    else if(onlinecon1.Position__c=='Clear Analyst'){
                        onlineContact.onlineContactType='0310';
                        }
                    else if(onlinecon1.Position__c=='Clear Investigator'){
                     onlineContact.onlineContactType='0300';
                      }
                    else if(onlinecon1.Position__c=='Clear Supervisor'){
                      onlineContact.onlineContactType='0280';
                       }
                         
                    else if(onlinecon1.Position__c=='Clear Technical'){
                        onlineContact.onlineContactType='0270';
                        }
                     else if(onlinecon1.Position__c=='Summer Associates'){
                        onlineContact.onlineContactType='0270';
                        }
                     else if(onlinecon1.Position__c  =='Tax Professional'){  //DOC 8094 Added By Poonam Garg. 
                        onlineContact.onlineContactType= '0095';
                     }             
                    onlineContact.phone=null;
                    onlineContact.phoneExtension=null;
                    onlineContact.contactNumber=onlinecon1.ContactID__c;
                     if(!dynamicbundlelist.isEmpty() || isProflex){                       
                    onlineContact.lineNumberLink.lineNumber=String.valueof(bundlematerialMap.get(onlinecon1.Material__c));                    
                    }
                    else{
                    onlineContact.lineNumberLink.lineNumber=String.valueof(materialMap.get(onlinecon1.Material__c));
                    }
                    onlineContact.externalContactNumber=null;
                    if(!string.isEmpty(onlineContact.onlineContactType)) {
                        blnIsContactRequired = True; //DOC-11983: Jinal Bhatt
                        ordreq.CreateOrderRequest.OrderHeader.onlineContacts.add(onlineContact);
                    }
                       
                }
            }
            ordreq.CreateOrderRequest.OrderHeader.originatingOrderNumber=order.Apttus_QPConfig__ProposalId__r.name;
            if(order.Apttus_Config2__Type__c!= null && order.Apttus_Config2__Type__c!='')
            {
                    ordreq.CreateOrderRequest.OrderHeader.type='ZNEW';
            }            
            ordreq.CreateOrderRequest.OrderHeader.description=order.Apttus_Config2__Description__c;
            ordreq.CreateOrderRequest.OrderHeader.orderTimestamp=order.Apttus_Config2__OrderDate__c;
            ordreq.CreateOrderRequest.OrderHeader.quoteNumber=order.Apttus_QPConfig__ProposalId__r.name;
            ordreq.CreateOrderRequest.OrderHeader.orderCurrency=order.CurrencyIsoCode;
            ordreq.CreateOrderRequest.OrderHeader.esignDate=order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Proposal_Name__c;
            ordreq.CreateOrderRequest.OrderHeader.completeDelivery=null;
            ordreq.CreateOrderRequest.OrderHeader.NoCombine=null;
            ordreq.CreateOrderRequest.OrderHeader.salesOffice='';
            ordreq.CreateOrderRequest.OrderHeader.paymentMethod=null;
            ordreq.CreateOrderRequest.OrderHeader.poNumber=order.Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__PONumber__c;
            ordreq.CreateOrderRequest.OrderHeader.revenueChannel=proposalOwner.Apts_Revenue_Channel__c;
            //ordreq.CreateOrderRequest.OrderHeader.ebillingExempt=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_exempt__c;
            
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c!=''){
            ordreq.CreateOrderRequest.OrderHeader.revenueChannel=order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c;
            }
            //skg soc-3450
            else if(order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c==null && proposalOwner.Apts_Revenue_Channel__c ==null && proposalOwner.Market_Segment_Description__c=='Inside'){
            ordreq.CreateOrderRequest.OrderHeader.revenueChannel='05';
            }
             //SOC-5452
            else if(order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c==null && proposalOwner.Apts_Revenue_Channel__c ==null && proposalOwner.Sales_Force_Description__c=='Home Office' && proposalOwner.Market_Segment_Description__c == 'Full Territory'){
            ordreq.CreateOrderRequest.OrderHeader.revenueChannel='01';
            }
            else if(order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c==null && proposalOwner.Apts_Revenue_Channel__c ==null && proposalOwner.Sales_Force_Description__c=='Home Office'){
            ordreq.CreateOrderRequest.OrderHeader.revenueChannel='06';
            }
            else if(order.Apttus_QPConfig__ProposalId__r.APTS_Revenue_Channel_Override__c==null && proposalOwner.Apts_Revenue_Channel__c ==null && proposalOwner.Sales_Force_Description__c!='Home Office'){
            ordreq.CreateOrderRequest.OrderHeader.revenueChannel='01';
            }
            //SOC-5031 pathra changed-Order Source from 03 to 27
            ordreq.CreateOrderRequest.OrderHeader.orderSource='03';
            ordreq.CreateOrderRequest.orderHeader.orderRep.repNumber=proposalOwner.Rep_Employee_Number__c;
            //SOC-5467
            ordreq.CreateOrderRequest.orderHeader.orderPeriodicValue=String.valueof(PeriodicValue.setscale(2)); 
            //SOC-5107 SOC-5467
            ordreq.CreateOrderRequest.orderHeader.oneTimeValue=String.valueof(oneTimeValue.setscale(2));
           
            // send the attchment id to Sap in the order header attachements node
            //skg List<Attachment> attachList = [SELECT Id FROM Attachment WHERE (ParentId =:order.Apttus_QPConfig__ProposalId__c AND Name LIKE '%signed%' AND Name LIKE '%CVMS Offer Sheet%' AND Name LIKE '%Order Form%') ORDER BY LastModifiedDate ASC NULLS LAST];
           //SOC-5462 removed LIMIT 1 from query
           /*if(Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Attachment.isQueryable()){
            attachList = [SELECT Id FROM Attachment WHERE (ParentId =:order.Apttus_QPConfig__ProposalId__c AND Name LIKE '%signed%') ORDER BY LastModifiedDate ASC NULLS LAST];
            }
            if(!attachList.isEmpty()) {
                For(Attachment att: attachList) 
               {
                CreateOrderRequest.attachments attachment = new CreateOrderRequest.attachments();
                attachment.path = att.Id;
                attachment.type= 'OR';
                attachment.status= 'E'; 
                ordreq.CreateOrderRequest.OrderHeader.attachments.add(attachment);
                }   
            }
             // changes for SOC-2719
              else{
                List<Attachment> attachListOF = [SELECT Id FROM Attachment WHERE (ParentId =:order.Apttus_QPConfig__ProposalId__c AND Name LIKE '%Order Form%') ORDER BY LastModifiedDate ASC NULLS LAST LIMIT 1];
                if(!attachListOF.isEmpty()) {
                    CreateOrderRequest.attachments attachment = new CreateOrderRequest.attachments();                    
                    attachment.path = attachListOF[0].Id;
                    attachment.type= 'OR';
                    attachment.status= 'E'; 
                    ordreq.CreateOrderRequest.OrderHeader.attachments.add(attachment);
                   }
                   //SOC-5793
                   OrderheaderAttachment('Order Form' , False,order.Apttus_QPConfig__ProposalId__c);
                } */
           // skg code for special offer attachment
           /* List<Attachment> attachListSO = [SELECT Id FROM Attachment WHERE (ParentId =:order.Apttus_QPConfig__ProposalId__c AND Name LIKE '%CVMS Offer Sheet%') ORDER BY LastModifiedDate ASC NULLS LAST LIMIT 1];
            if(!attachListSO.isEmpty()) {
                For(Attachment att: attachListSO) 
               {
                CreateOrderRequest.attachments attachment = new CreateOrderRequest.attachments();
                attachment.path = att.Id;
                attachment.type= 'OR';
                attachment.status= 'E'; 
                ordreq.CreateOrderRequest.OrderHeader.attachments.add(attachment);
                }   
            } 
            //code for product user detail attachment
             List<Attachment> attachListPO = [SELECT Id FROM Attachment WHERE (ParentId =:order.Apttus_QPConfig__ProposalId__c AND Name LIKE '%Product User Detail%') ORDER BY LastModifiedDate ASC NULLS LAST LIMIT 1];
            if(!attachListPO.isEmpty()) {
                For(Attachment att: attachListPO) 
               {
                CreateOrderRequest.attachments attachment = new CreateOrderRequest.attachments();
                attachment.path = att.Id;
                attachment.type= 'OR';
                attachment.status= 'E'; 
                ordreq.CreateOrderRequest.OrderHeader.attachments.add(attachment);
                }   
            }   */  
         //SOC-5793
            //OrderheaderAttachment('CVMS Offer Sheet' , False,order.Apttus_QPConfig__ProposalId__c);
            //OrderheaderAttachment('Product User Detail', False,order.Apttus_QPConfig__ProposalId__c);
             //OrderheaderAttachment('Digital Signature Detail', False,order.Apttus_QPConfig__ProposalId__c);
             
             //orderheaderAttachment Method Moved to APTS_OrderSubmissionUtility Class for Content Version(Files)
                APTS_OrderSubmissionUtility.orderheaderAttachment(order.Apttus_QPConfig__ProposalId__c, ordreq);   
           //Bijeta DOC-6912 Canada OC
             if(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c=='Ground Shipping - U.S. Only' || order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c=='Fex Ex International' || order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c=='International best Rate' || order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c==null || order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c==''){
                ordreq.CreateOrderRequest.OrderHeader.incoTerms='FOB';
                }
            else if(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c=='International Expedited Rate' && order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c!=null){
                ordreq.CreateOrderRequest.OrderHeader.incoTerms='ZCH';
                }
           //SOC-3963 sending incoterm of FOB if Cost center value is valid
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Cost_Center__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_Cost_Center__c != ''){
                ordreq.CreateOrderRequest.OrderHeader.incoTerms='FOB';
            }
            //credit card details
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Credit Card'){
                If(order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c != null) {
                    Datetime expDate= order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c;
                    ordreq.CreateOrderRequest.orderHeader.creditCardPayment.expiration = expDate.format('yyyyMMdd');
                    }
                ordreq.CreateOrderRequest.orderHeader.creditCardPayment.authorizationNumber=order.Apttus_QPConfig__ProposalId__r.APTS_Authorization_Number__c;
                ordreq.CreateOrderRequest.orderHeader.creditCardPayment.authorizationTransaction=order.Apttus_QPConfig__ProposalId__r.APTS_Authorization_Transaction__c;
                ordreq.CreateOrderRequest.orderHeader.creditCardPayment.amount=string.valueof(order.Apttus_QPConfig__ProposalId__r.APTS_amount__c);
                ordreq.CreateOrderRequest.orderHeader.creditCardPayment.cardType=order.Apttus_QPConfig__ProposalId__r.APTS_Card_Type__c;
                ordreq.CreateOrderRequest.orderHeader.creditCardPayment.cardNumber=order.Apttus_QPConfig__ProposalId__r.APTS_Credit_Card_Token__c;
            }
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Bill to Account'){
                ordreq.CreateOrderRequest.orderHeader.accountPayment.accountNumber=order.APTS_SSD_bill_to__r.Source_System_Account_Number__c;
                }
            //SOC-3626            
           /* if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Payment Express Auto EFT/Auto Charge'){
                //SOC-3882 Net 1
                ordreq.CreateOrderRequest.orderHeader.accountPayment.paymentTerm='0001';
                CreateOrderRequest.orderNotes POordernotes= new CreateOrderRequest.orderNotes();
                POordernotes.notes= 'Payment Option: '+order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c; 
                ordreq.CreateOrderRequest.orderHeader.orderNotes.add(POordernotes);
                }*/
            //SoldTo Account
            if(order.APTS_SSD_Sold_To__c!=null)
            {
                CreateOrderRequest.orderAddress ordaddress = new CreateOrderRequest.orderAddress();
                ordaddress.partnerType='soldTo';
                ordaddress.shippingAmount=null;
                if(!string.isEmpty(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c)) {
                    ordaddress.shippingMethod=Shipping_Method__c.getInstance(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c).Value__c;
                }
                ordaddress.account.accountNumber=order.APTS_SSD_Sold_To__r.Source_System_Account_Number__c;                
                ordreq.CreateOrderRequest.orderHeader.orderAddress.add(ordaddress);
            }
             //BillTo Account
            if(order.APTS_SSD_bill_to__c!=null)
            {
                CreateOrderRequest.orderAddress ordaddress1 = new CreateOrderRequest.orderAddress();
                ordaddress1.partnerType='billTo';
                ordaddress1.shippingAmount=null;
                ordaddress1.shippingMethod=Shipping_Method__c.getInstance(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c).Value__c;
                ordaddress1.account.accountNumber=order.APTS_SSD_bill_to__r.Source_System_Account_Number__c;                
                ordreq.CreateOrderRequest.orderHeader.orderAddress.add(ordaddress1);
            }
            //ShipTo Account
            if(order.APTS_SSD_Ship_To__c!=null)
            {
                CreateOrderRequest.orderAddress ordaddress2 = new CreateOrderRequest.orderAddress();
                ordaddress2.partnerType='shipTo';
                ordaddress2.shippingAmount=null;
                ordaddress2.shippingMethod=Shipping_Method__c.getInstance(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c).Value__c;
                ordaddress2.account.accountNumber=order.APTS_SSD_Ship_To__r.Source_System_Account_Number__c;
                if(order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__c!=null || order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__c!=''){
                ordaddress2.street1=order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Street__c;
                ordaddress2.name2=String.valueof(order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To_Attention__c);
                ordaddress2.country=order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Country__c;
                ordaddress2.city=order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.City__c;
                ordaddress2.region=order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.State__c;
                ordaddress2.name1=order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Name;
                ordaddress2.postal=order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Zipcode__c;
        if(order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Phone__c !=null) {
                    ordaddress2.phone=order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Phone__c;
                  }
                if(order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Street_Address_3__c !=null) {
                    ordaddress2.street2=order.Apttus_QPConfig__ProposalId__r.APTS_One_Time_Ship_To__r.Street_Address_3__c;
                  }
                }                
                ordreq.CreateOrderRequest.orderHeader.orderAddress.add(ordaddress2);
            }
            //SOC-6753 - Payer SSD
            if(order.APTS_Payer__c!=null)
            {
                CreateOrderRequest.orderAddress ordaddress3 = new CreateOrderRequest.orderAddress();
                ordaddress3.partnerType='payer';
                ordaddress3.account.accountNumber=order.APTS_Payer__r.Source_System_Account_Number__c;
                ordreq.CreateOrderRequest.orderHeader.orderAddress.add(ordaddress3);
            }//SOC-6753 ends
            
            //Order contact
            CreateOrderRequest.orderContact ordcontact = new CreateOrderRequest.orderContact();
            ordcontact.firstName= order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName;
            ordcontact.lastName=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.LastName; 
            ordcontact.phone=null;
            ordcontact.phoneExtension=null;
            ordcontact.emailAddress=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Email;
            ordcontact.contactNumber=null;
            //ordcontact.department=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Department;
            ordcontact.department=null;
            ordcontact.fax=null;
            ordcontact.function=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Contact_Type__c;
            ordcontact.building=null;
            ordcontact.floor=null;
            ordcontact.room=null;
            ordcontact.ContactType= '28';
            ordreq.CreateOrderRequest.OrderHeader.orderContact.add(ordcontact);
        //SOC-4320 FEB release By Bijeta
            //Ebilling contact
            
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.LCRM_eOutput_Eligibility__c != 'NEL' && order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.LCRM_eOutput_Eligibility__c != 'USG'){ 
            CreateOrderRequest.orderContact ebcontact = new CreateOrderRequest.orderContact();
            
            ebcontact.firstName= order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.FirstName;
            ebcontact.lastName=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.LastName; 
            ebcontact.emailAddress=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Email;
            ebcontact.phone=null;
            ebcontact.phoneExtension=null;
            ebcontact.contactNumber=null;
            ebcontact.department=null;
            ebcontact.fax=null;
            ebcontact.function=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__r.Contact_Type__c;
            ebcontact.building=null;
            ebcontact.floor=null;
            ebcontact.room=null;
            ebcontact.ContactType= '30';
            
            ordreq.CreateOrderRequest.OrderHeader.orderContact.add(ebcontact);
            }
            For(Customer_Master_Contacts__c mastercon1 : mastercon) 
            {
                CreateOrderRequest.orderContact ordcontact1 = new CreateOrderRequest.orderContact();
                ordcontact1.firstName=mastercon1.First_Name__c;
                ordcontact1.lastName=mastercon1.Last_Name__c;
                ordcontact1.emailAddress=mastercon1.Email_Address__c;
                if(mastercon1.Customer_Type_Description__c=='CLEAR PRIMARY CONT'){  
                    ordcontact1.ContactType= '46';
                    }
                else if(mastercon1.Customer_Type_Description__c=='PATRON ACC TECH CONT'){
                    ordcontact1.ContactType='59';
                    }
                else if(mastercon1.Customer_Type_Description__c=='TECHNICAL CONTACT'){
                    ordcontact1.ContactType='03';
                    }
                else if(mastercon1.Customer_Type_Description__c=='EML PSWD CONTACT'){
                    ordcontact1.ContactType='24';
                    }
                else if(mastercon1.Customer_Type_Description__c=='ADMINISTRATOR'){
                    ordcontact1.ContactType='60';
                    }
                //start : Risk Spree
                else if(mastercon1.Customer_Type_Description__c=='SRR MEDIA CONTACT'){
                    ordcontact1.ContactType='36';
                    }
                else if(mastercon1.Customer_Type_Description__c=='PT INTER MEDIA CONT'){
                    ordcontact1.ContactType='32';
                    }
                else if(mastercon1.Customer_Type_Description__c=='PT INTRA MEDIA CONT'){
                    ordcontact1.ContactType='33';
                    }
                else if(mastercon1.Customer_Type_Description__c=='PT SENTRY MEDIA CONT'){
                    ordcontact1.ContactType='35';
                    }
                else if(mastercon1.Customer_Type_Description__c=='COMPLIANCE LEARNING'){
                    ordcontact1.ContactType='40';
                    }
                else if(mastercon1.Customer_Type_Description__c=='Filing Contact'){
                    ordcontact1.ContactType='34';
                    }
                //End : Risk Spree
                ordcontact1.phone=mastercon1.Phone__c;
                if(mastercon1.Customer_Type_Description__c=='PATRON ACC TECH CONT' || mastercon1.Customer_Type_Description__c=='CLEAR PRIMARY CONT' || mastercon1.Customer_Type_Description__c=='PATRON ACC TECH CONT' && mastercon1.To_IP_Address__c!=null){
                    
                    if(mastercon1.From_IP_Address__c!=null && mastercon1.To_IP_Address__c!=null) { 
                    CreateOrderRequest.orderNotes ipAddress = new CreateOrderRequest.orderNotes();                 
                    ipAddress.notes='IP Address FROM:'+mastercon1.From_IP_Address__c+'- IP Address TO: '+mastercon1.To_IP_Address__c+'.';
                    ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(ipAddress);
                    }
                    
                    
                    if(mastercon1.From_IP_Address1__c!=null && mastercon1.To_IP_Address1__c!=null) { 
                    CreateOrderRequest.orderNotes ipAddress1 = new CreateOrderRequest.orderNotes();                 
                    ipAddress1.notes='IP Address FROM:'+mastercon1.From_IP_Address1__c+'- IP Address TO: '+mastercon1.To_IP_Address1__c+'.';
                    ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(ipAddress1);
                    }
                    
                    if(mastercon1.From_IP_Address2__c!=null && mastercon1.To_IP_Address2__c!=null) {
                    CreateOrderRequest.orderNotes ipAddress2 = new CreateOrderRequest.orderNotes();                  
                    ipAddress2.notes='IP Address FROM:'+mastercon1.From_IP_Address2__c+'- IP Address TO: '+mastercon1.To_IP_Address2__c+'.';
                    ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(ipAddress2);
                    }
                    
                    
                }
                ordreq.CreateOrderRequest.OrderHeader.orderContact.add(ordcontact1);
            }
            //branding
            // SOC 3961
           /* CreateOrderRequest.orderNotes orderNote= new CreateOrderRequest.orderNotes();
           orderNote.notes=order.Apttus_QPConfig__ProposalId__r.APTS_Print_Branding__c;*/
            ordreq.CreateOrderRequest.OrderHeader.brandingName = order.Apttus_QPConfig__ProposalId__r.APTS_Print_Branding__c;
            //Assent
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Assent_DateTime__c!=null || order.Apttus_QPConfig__ProposalId__r.APTS_Assent_Customer_Name__c!=null  || order.Apttus_QPConfig__ProposalId__r.APTS_Assent_Name_of_Rep__r.FirstName!=null){
                CreateOrderRequest.orderNotes orderNote1= new CreateOrderRequest.orderNotes();
                orderNote1.notes='Date & Time: '+String.valueOf(order.Apttus_QPConfig__ProposalId__r.APTS_Assent_DateTime__c)+'. Customer: '+String.valueOf(order.Apttus_QPConfig__ProposalId__r.APTS_Assent_Customer_Name__c)+'. Rep Name: '+String.valueOf(order.Apttus_QPConfig__ProposalId__r.APTS_Assent_Name_of_Rep__r.FirstName)+' '+String.valueOf(order.Apttus_QPConfig__ProposalId__r.APTS_Assent_Name_of_Rep__r.LastName)+'.';
                ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(orderNote1);                           
            }
            
                  //MLA Details Phase 2
            //MLA header details
            system.debug('HDB ='+hasDynamicBundle+'PFO = '+proflexOrderLineItem);
            if(!multiLocAccount.isEmpty() ){
                //SOC-4852
                System.debug('Inside If--->');
                System.debug('MLA IS TRUE ->' +proflexOrderLineItem.APTS_MLA__c);
                if(hasDynamicBundle && proflexOrderLineItem!=null && proflexOrderLineItem.APTS_MLA__c==true ){   
                        //Start: DOC-10143 : Poonam Garg, Jinal Bhatt
                        System.debug('Inside 2nd IF---->');   
                        if(proflexOrderLineItem.APTS_Keep_Terms__c==true && proflexOrderLineItem.APTS_SAP_MLA_Agreement_Number__c!=null){
                            System.debug('ProflexorderLineitem-->'+proflexOrderLineItem);
                            MLAHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeader(order, proflexOrderLineItem, 'Modify');    
                            MLAHeader.agreementNum= proflexOrderLineItem.APTS_SAP_MLA_Agreement_Number__c; 
                            System.debug('Modify MLA ='+MLAHeader);                    
                        }                       
                        //Soc- 3465 changes, Start: DOC-9689 - Jinal Bhatt  
                        else if(isMLAReplace &&!mapBundleLineItems.isEmpty() && grpName!=null && mapBundleLineItems.get(grpName)!=null) { //MLAbundle.APTS_Keep_Terms__c==false && MLAbundle.APTS_MLA_Agreement_Number__c!=null   
                           for (Apttus_Config2__OrderLineItem__c ordeline : mapBundleLineItems.get(grpName)) {  
                                if (!string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c)) {   
                  system.debug(LoggingLevel.DEBUG,'##### ordeline.APTS_SAP_MLA_Agreement_Number__c'+ordeline.APTS_SAP_MLA_Agreement_Number__c+ 
                  ordeline.Apttus_Config2__LineStatus__c + isnotMLAModify+ ordeline.APTS_Service_Number__c);    
                                    if(ordeline.Apttus_Config2__LineStatus__c =='Cancelled' && isnotMLAModify && !string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c) 
                                        && materialNumberList.contains(ordeline.APTS_Service_Number__c) ) {
                                        System.debug('isNotMLAMODIFY-->'+isnotMLAModify );
                                        MLAHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeader(order, proflexOrderLineItem, 'Replace');       
                                        MLAHeader.agreementNum = ordeline.APTS_SAP_MLA_Agreement_Number__c; 
                                        MLAHeader.noOfAttorneys = numberOfAttorneys;    
                                        MLAHeader.discountPercent= '';  
                                        MLAHeader.discountValue= '';    
                                        MLAHeader.surcharge= '';                        
                                        MLAHeader.pricingOption='Y';    
                                        MLAHeaderinfo.add(MLAHeader);                       
                                        isReplaceMode = True;
                                        System.debug('MLAHeaderrrr--->'+MLAHeaderinfo);   
                                    }   
                                }   
                            }  system.debug('Cancell MLA ='+MLAHeaderinfo); 
                        } else {    
                            MLAHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeader(order, proflexOrderLineItem, 'New');       
                            MLAHeader.agreementNum= proflexOrderLineItem.APTS_SAP_MLA_Agreement_Number__c;
                          system.debug('New MLA = '+MLAHeader);  
                        }   
                        
                        //End: DOC-10143    
                    }   
                //}           
                    
              //noOfAttorneys for MLA
                  system.debug('hasDynamicBundle --> '+hasDynamicBundle+' MLAHeader -->'+MLAHeader+'isReplaceMode-->'+isReplaceMode+'mapBundleLineItems-->'+mapBundleLineItems+' grpName-->'+grpName +' mapBundleLineItems.get(grpName)-->'+mapBundleLineItems.get(grpName));   
                if (hasDynamicBundle && MLAHeader!=null && !isReplaceMode &&!mapBundleLineItems.isEmpty() && grpName!=null && mapBundleLineItems.get(grpName)!=null) {   
                    system.debug('Attorney block');
                    MLAHeader.noOfAttorneys='0';    
                    For(Apttus_Config2__OrderLineItem__c ordeline :mapBundleLineItems.get(grpName)) {   //Changed to OLIItems
                        If(ordeline.Apttus_Config2__LineStatus__c != 'Cancelled') {
                            if(ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c !=null && ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c =='BENEFITGRP' && ordeline.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c!=null){                             
                                MLAHeader.noOfAttorneys=string.valueof(ordeline.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c.setscale(0));    
                            }   
                            if(ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c !='BENEFITGRP' && OnlineContactsController.validateProductLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, System.Label.OCBandedLowerLevelCodes) == true 
                            || (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='06' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9')){                  
                                MLAHeader.noOfAttorneys=string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));                               
                            }                       
                            if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9'){    
                                MLAHeader.noOfAttorneys=null;   
                            }   
                        }   
                    }   
                    MLAHeader.discountPercent= '';  
                    MLAHeader.discountValue= '';    
                    MLAHeader.surcharge= '';                        
                    MLAHeader.pricingOption='Y';    
                    MLAHeaderinfo.add(MLAHeader); 
                    System.debug('ATT MLA='+MLAHeaderinfo);  
                }   
                //}
                //}
                //End DOC-9689: Jinal Bhatt
                
                //MLA CustomerGroup details
              if(!hasDynamicBundle){
                     for(APTS_Dynamic_Bundle__c mlabundle :dynamicbundlelist){
                //SOC-4852
                if(MLAbundle.APTS_MLA__c==true){    
                        //Start: DOC-10143 : Poonam Garg, Jinal Bhatt   
                        if(MLAbundle.APTS_Keep_Terms__c==true && MLAbundle.APTS_MLA_Agreement_Number__c!=null){ 
                            MLAHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeaderDB(order, MLAbundle, 'Modify');    
                            MLAHeader.agreementNum= MLAbundle.APTS_MLA_Agreement_Number__c;                     
                        }                       
                        //Soc- 3465 changes, Start: DOC-9689 - Jinal Bhatt  
                        else if(isMLAReplace) { //MLAbundle.APTS_Keep_Terms__c==false && MLAbundle.APTS_MLA_Agreement_Number__c!=null   
                            for (Apttus_Config2__OrderLineItem__c ordeline :orderLineItems) {  
                                if (!string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c)) {   
                  system.debug(LoggingLevel.DEBUG,'##### ordeline.APTS_SAP_MLA_Agreement_Number__c'+ordeline.APTS_SAP_MLA_Agreement_Number__c+ 
                  ordeline.Apttus_Config2__LineStatus__c + isnotMLAModify+ ordeline.APTS_Service_Number__c);    
                                    if(ordeline.Apttus_Config2__LineStatus__c =='Cancelled' && isnotMLAModify && !string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c) 
                                        && materialNumberList.contains(ordeline.APTS_Service_Number__c) ) {  
                                        MLAHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeaderDB(order, MLAbundle, 'Replace');       
                                        MLAHeader.agreementNum = ordeline.APTS_SAP_MLA_Agreement_Number__c; 
                                        MLAHeader.noOfAttorneys = numberOfAttorneys;    
                                        MLAHeader.discountPercent= '';  
                                        MLAHeader.discountValue= '';    
                                        MLAHeader.surcharge= '';                        
                                        MLAHeader.pricingOption='Y';    
                                        MLAHeaderinfo.add(MLAHeader);                       
                                        isReplaceMode = True;   
                                    }   
                                }   
                            }   
                        } else {    
                            MLAHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeaderDB(order, MLAbundle, 'New');       
                            MLAHeader.agreementNum= MLAbundle.APTS_MLA_Agreement_Number__c; 
                        }   
                        //End: DOC-10143    
                    }   
                }           
                    
              //noOfAttorneys for MLA   
                if (!isReplaceMode && MLAHeader!=null) {   
                    MLAHeader.noOfAttorneys='0';    
                    For(Apttus_Config2__OrderLineItem__c ordeline :orderLineItems) {   
                        If(ordeline.Apttus_Config2__LineStatus__c != 'Cancelled') { 
                            if(ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c !=null && ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c =='BENEFITGRP'){   
                                MLAHeader.noOfAttorneys=string.valueof(ordeline.Apttus_Config2__AttributeValueId__r.APTS_Priced_Number_of_Attorneys__c.setscale(0));    
                            }   
                            if(ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c !='BENEFITGRP' && OnlineContactsController.validateProductLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, System.Label.OCBandedLowerLevelCodes) == true 
                            || (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='06' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9')){                  
                                MLAHeader.noOfAttorneys=string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));                               
                            }                       
                            if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9'){    
                                MLAHeader.noOfAttorneys=null;   
                            }   
                        }   
                    }   
                    MLAHeader.discountPercent= '';  
                    MLAHeader.discountValue= '';    
                    MLAHeader.surcharge= '';                        
                    MLAHeader.pricingOption='Y';    
                    MLAHeaderinfo.add(MLAHeader);
                    System.debug('MLAHeader-->'+MLAHeader);   
                }    
            }  
                //skg moved from above
              for(APTS_Quote_Agreement_Locations__c multiAcc :multiLocAccount){              
              if  (multiAcc.APTS_Status__c!='Cancelled'){
                CustomerGroup = new CreateOrderRequest.CustomerGroup(); 
                //ContentMaterials = new CreateOrderRequest.ContentMaterials();
                CustomerDetails= new CreateOrderRequest.CustomerDetails ();
                UserDetails= new CreateOrderRequest.UserDetails();                
                CustomerGroup.locationAcc= multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c;                        
                CustomerGroup.validFrom= '';
                CustomerGroup.validTo='';
                CustomerGroup.allocationPerc='';
                
                if(MLAHeader!=null &&MLAHeader.determineBillPayer=='D' && MLAHeader.mlaOption!='Modify'){
                       CustomerGroup.billPayer=multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c; 
                       CustomerGroup.billTo= multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c;
                }
                else if(MLAHeader!=null && MLAHeader.determineBillPayer=='C' && MLAHeader.mlaOption!='Modify')
                {
                CustomerGroup.billPayer=multiAcc.APTS_Quote_Proposal__r.APTS_Sold_To_SAP_Account_Number__c; 
                CustomerGroup.billTo= multiAcc.APTS_Quote_Proposal__r.APTS_Sold_To_SAP_Account_Number__c;
                }
                CustomerGroupinfo.add(CustomerGroup);
                //MLA ContentMaterials details  
                //SOC-3729 added or condition
                if ((multiAcc.APTS_Status__c=='New')||(multiAcc.APTS_Status__c=='Existing')){ 
                For(Apttus_Config2__OrderLineItem__c ordeline :orderLineItems)    //Changed to OLIItems
                    {   
                        If(ordeline.Apttus_Config2__LineStatus__c == 'New' || ordeline.Apttus_Config2__LineStatus__c == 'Existing') {  
                            ContentMaterials = new CreateOrderRequest.ContentMaterials();
                            for(MLAMediaLevelCode__c mediaLevel: MLAMediaLevelCode__c.getAll().values()) 
                            {                    
                            if(mediaLevel.MLA_Media_High_Level_Code__c == ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c &&  mediaLevel.MLA_Media_Lower_Level_Code__c==ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c ){                         
                                ContentMaterials.lineNumber = String.valueOf(ordeline.Apttus_Config2__LineNumber__c);
                                ContentMaterials.material= ordeline.Apttus_Config2__ProductId__r.ProductCode;
                                ContentMaterials.locationAcc= multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c;  
                                //SOC-3900- Sreenu D added if else condition to assign no.of allocations                     
                                if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='ST') {
                                    ContentMaterials.noOfAllocations = '1';
                                } else {
                                    ContentMaterials.noOfAllocations= !countMap.isEmpty() && countMap.containsKey(ordeline.Apttus_Config2__ProductId__r.ProductCode+multiAcc.APTS_Subscriber_Location_SSD__c) ? string.valueOf(countMap.get(ordeline.Apttus_Config2__ProductId__r.ProductCode+multiAcc.APTS_Subscriber_Location_SSD__c)) : null   ;                    
                                }
                                ContentMaterials.validFrom= '';
                                ContentMaterials.validTo='';
                        
                             }
                           }
                        ContentMaterialsinfo.add(ContentMaterials);
                    }
                }
                }
                
                
                //MLA CustomerDetails details
                CustomerDetails.custNumber= multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c;              
                
                        if(multiAcc.APTS_Quote_Proposal__r.APTS_Sold_To_SAP_Account_Number__c==multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c){
                        CustomerDetails.isPrimary='X';
                        }
                        CustomerDetailsinfo.add(CustomerDetails);
                        
                //User Details
                if(multiAcc.APTS_Status__c=='New' || multiAcc.APTS_Status__c=='Existing'){
                    For(Online_Contacts__c multiAcccon: onlinecon) 
                    {                    
                        if(multiAcccon.APTS_Source_System_Detail__c==multiAcc.APTS_Subscriber_Location_SSD__c && blnIsContactRequired){ //DOC-11983: Jinal Bhatt                      
                            if(multiAcccon.Is_Banded_Product__c){
                                if(string.isEmpty(mlAcc) && string.isEmpty(flEmail)) {
                                    flEmail = (multiAcccon.First_Name__c+multiAcccon.Last_Name__c+multiAcccon.Email__c);
                                    mlAcc = multiAcccon.APTS_Source_System_Detail__c;
                                    //onlineContactAssign(multiAcccon, multiAcc);
                                    userDetails = new CreateOrderRequest.UserDetails();
                                    userDetails = APTS_OrderSubmissionUtilityExt2.onlineContactAssign(multiAcccon, multiAcc, materialBrandCodeMap);
                                    System.debug('############### userDetails'+userDetails);
                                    userDetailsinfo.add(UserDetails);    
                                 }
                                else{
                                if(mlAcc != multiAcccon.APTS_Source_System_Detail__c && flEmail != (multiAcccon.First_Name__c+multiAcccon.Last_Name__c+multiAcccon.Email__c)){
                                    flEmail = (multiAcccon.First_Name__c+multiAcccon.Last_Name__c+multiAcccon.Email__c);
                                    mlAcc = multiAcccon.APTS_Source_System_Detail__c;
                                    //onlineContactAssign(multiAcccon, multiAcc);  
                                    userDetails = new CreateOrderRequest.UserDetails();
                                    userDetails = APTS_OrderSubmissionUtilityExt2.onlineContactAssign(multiAcccon, multiAcc, materialBrandCodeMap);
                                    System.debug('############### userDetails'+userDetails);
                                    userDetailsinfo.add(UserDetails);  
                                }
                                else {
                                    if(mlAcc != multiAcccon.APTS_Source_System_Detail__c || flEmail != (multiAcccon.First_Name__c+multiAcccon.Last_Name__c+multiAcccon.Email__c)){
                                    flEmail = (multiAcccon.First_Name__c+multiAcccon.Last_Name__c+multiAcccon.Email__c);
                                    mlAcc = multiAcccon.APTS_Source_System_Detail__c;
                                    //onlineContactAssign(multiAcccon, multiAcc);   
                                    userDetails = new CreateOrderRequest.UserDetails();
                                    userDetails = APTS_OrderSubmissionUtilityExt2.onlineContactAssign(multiAcccon, multiAcc, materialBrandCodeMap);
                                    System.debug('############### userDetails'+userDetails);
                                    userDetailsinfo.add(UserDetails); 
                                    }
                                }
                            }                    
                        }
                        else {
                            //onlineContactAssign(multiAcccon, multiAcc);    
                             userDetails = new CreateOrderRequest.UserDetails();
                             userDetails = APTS_OrderSubmissionUtilityExt2.onlineContactAssign(multiAcccon, multiAcc, materialBrandCodeMap);
                             System.debug('############### userDetails'+userDetails);
                             userDetailsinfo.add(UserDetails);
                        }
                       }
                    }                  
                }
                }
               else{
                CreateOrderRequest.orderNotes multiAccnote= new CreateOrderRequest.orderNotes();
                multiAccnote.notes='Remove Location: '+multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c+' from Agreement: '+multiAcc.APTS_Agreement_Number__c+'.';            
                ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(multiAccnote);                 
                }                
            }
            system.debug('Add MLA'+MLAHeaderinfo);
            multiLoc.MLAHeader.addAll(MLAHeaderinfo);
            multiLoc.CustomerGroup.addAll(CustomerGroupinfo);
            multiLoc.ContentMaterials.addAll(ContentMaterialsinfo);
            multiLoc.CustomerDetails.addAll(CustomerDetailsinfo);
            multiLoc.UserDetails.addAll(UserDetailsinfo);
            ordreq.CreateOrderRequest.OrderHeader.MLAInfo.add(multiLoc);
            } 
            if(!additionalSublist.isEmpty()){
                For(APTS_Additional_Subscription_Actions__c additionalSubs :additionalSublist)
                    {                     
                    CreateOrderRequest.orderNotes additionalSub1 = new CreateOrderRequest.orderNotes();
                    additionalSub1.notes='Status:'+additionalSubs.APTS_Line_Status__c+';SUB No: '+additionalSubs.APTS_Subscription_Number__c+';ConNo:'+additionalSubs.APTS_Contract_Number__c+'; ConLNo: '+additionalSubs.APTS_Contract_Line_Number__c+';Product:'+additionalSubs.APTS_Product__c+'.';                   
                    if(additionalSub1.notes.length() >= 132){
                    additionalSub1.notes=additionalSub1.notes.substring(0,131);
                    }                    
                    ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(additionalSub1);
                } 
             } 
            ordreq.CreateOrderRequest.orderHeader.holdForReview='';
            ordreq.CreateOrderRequest.orderHeader.renewalValue='';
            ordreq.CreateOrderRequest.orderHeader.profileId='';
            ordreq.CreateOrderRequest.orderHeader.WLDID='';
            //MLA Ends
            //Callout to ESI
            String strBody = JSON.serialize(ordreq);
            System.debug(LoggingLevel.DEBUG,'%%%%%%%%%'+strBody);
            WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('OrdersubmissionESI');  
            if(runOldOrderProcess){
                Httprequest req=new httprequest();
                //req.setEndpoint(oWebServiceSettings.Endpoint__c);
                req.setEndpoint('Callout:OrdersubmissionESI'); 
                req.setHeader('Content-Type','application/json');
                req.setBody(strBody);
                req.setmethod('POST');
                blob  headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
                String authorizationHeader = 'BASIC'+ EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization',authorizationHeader);
                Http http = new Http();
                HTTPResponse res = new HTTPResponse ();
                System.debug(LoggingLevel.WARN,'@@@Request@@'+ req);
                if(!test.isrunningtest()) {
                    res = http.send(req);
                    }
                else{
                    res=OrderSubmissionMocKCallout.respond(req);
                    //res.setbody('{ "CreateOrderResponse":{"Status" :{"Code" :"200","Description" :"Successfully received the order request" }}}');
                }   
                // String response=res.getbody();
                System.debug(LoggingLevel.WARN,'****************res.getStatusCode();'+res.getStatusCode());
                System.debug(LoggingLevel.WARN,'****************res.getbody();'+res.getbody());
                if(res.getStatusCode()!=200)
                {
                    // call method to log the request
                    //APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Quote/Proposal ESI Call Failed : '+res.getStatusCode()+' : '+res.getbody()},order.Id,order.Retry_Count__c);
                    //logException(strBody,'Quote/Proposal ESI Call Failed : '+res.getStatusCode()+' : '+res.getbody(),order.Id,order.Retry_Count__c);
                    List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(new List<String>{'prabhu.issac@thomsonreuters.com'});
                    emailToSend.setPlainTextBody('Order Not got processed Sucessfully for the order:'+order.Name+'');
                    emailToSend.setSubject('Order Failed');
                    lstMsgsToSend.add(emailToSend);                
                    Messaging.sendEmail(lstMsgsToSend);
                    System.debug(LoggingLevel.WARN,'@@@Response@@'+ res);
                    loggerId = APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Old Process :  Quote/Proposal ESI Call Failed : '+res.getStatusCode()+' : '+res.getbody()},order.Id,order.Retry_Count__c);         
                    ordersubwrap.isSuccess = false;
                    ordersubwrap.applicationId = '';
                    ordersubwrap.companyId = '';
                    return ordersubwrap;
                }else if(res.getStatusCode()==200){ 
                    //APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Quote/Proposal ESI success : '+res.getStatusCode()+' : '+res.getbody()},order.Id,order.Retry_Count__c);
                    //logException(strBody,'Quote/Proposal ESI success : '+res.getStatusCode()+' : '+res.getbody(),order.Id,order.Retry_Count__c);
                    loggerId = APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Old Process : Quote/Proposal ESI success : '+res.getStatusCode()+' : '+res.getbody()},order.Id,order.Retry_Count__c);         
                    ordersubwrap.isSuccess = true;
                    ordersubwrap.applicationId = '';
                    ordersubwrap.companyId = '';
                    return ordersubwrap;
                }
                System.debug(LoggingLevel.WARN,'#############res.getbody();'+res.getbody());
                
                System.debug(LoggingLevel.WARN,'@@@Response@@'+ res);
                //loggerId = APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Old Process : Quote/Proposal ESI success : '+res.getStatusCode()+' : '+res.getbody()},order.Id,order.Retry_Count__c);         
                ordersubwrap.isSuccess = false;
                ordersubwrap.applicationId = '';
                ordersubwrap.companyId = '';
                return ordersubwrap;
            }else{
                /*if(Schema.sObjectType.Integration_Logger__c.isAccessible()){       
                    intLogList=[Select Id from Integration_Logger__c where Order__c =: orderId];
                }
                if(intLogList!=null && intLogList.size()==1){
                    IntegrationLogger.TaxupdateMessage(intLogList[0].Id, true,'',strBody);
                    loggerId = intLogList[0].Id;
                }else{
                    loggerId = IntegrationLogger.OCAddMessage('','', 'Order', strBody, 'Outbound','OrderSubmission',true,orderId);         
                }
                ordersubwrap.orderId = orderId;
                ordersubwrap.orderNo = ordreq.CreateOrderRequest.OrderHeader.originatingOrderNumber;
                ordersubwrap.applicationId = ordreq.CreateOrderRequest.ESIHeader.applicationId;
                ordersubwrap.isSuccess = true;
                ordersubwrap.loggerrecordId = loggerId;*/
                APTS_OrderSubmissionUtilityExt4.createLoggerforPE(orderId, ordreq, ordersubwrap);
                return ordersubwrap;
            } 
            
        }
        catch(Exception ex){    
            System.debug(LoggingLevel.WARN,'Something went wrong'+ex.getMessage()+' : '+ex.getLineNumber()+' : '+ex.getStackTraceString()); 
            System.debug(LoggingLevel.WARN,'Something went wrong'+ex.getMessage()+' : '+ex.getLineNumber()+' : '+ex.getStackTraceString()); 
            /*logException(ex.getMessage()+' : '+ex.getLineNumber()+' : '+ex.getStackTraceString(),'Quote/Proposal ESI call SFDC Error',order.Id,order.Retry_Count__c); 
            return false;*/
            /*if(Schema.sObjectType.Integration_Logger__c.isAccessible()){       
                intLogList=[Select Id from Integration_Logger__c where Order__c =: orderId AND Service_Name__c='OrderSubmission'];
            }
            if(intLogList!=null && intLogList.size()==1){
                IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false,ex.getMessage()+ex.getLineNumber(),'');
                loggerId = intLogList[0].Id;
            }else{
                loggerId = IntegrationLogger.OCAddMessage(ex.getMessage()+ex.getLineNumber(),'', 'Order', '', 'Outbound','OrderSubmission',false,orderId);         
            }
            ordersubwrap.orderId = orderId;
            ordersubwrap.applicationId = '';
            ordersubwrap.isSuccess = false;
            ordersubwrap.loggerrecordId = loggerId;*/
            APTS_OrderSubmissionUtilityExt4.handleException(orderId, ex, ordersubwrap);
            return ordersubwrap;
            // APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>ex.getMessage()+' : '+ex.getLineNumber()+' : '+ex.getStackTraceString(), 'error'=>'Quote/Proposal ESI call SFDC Error'},order.Id,order.Retry_Count__c);
            //logException(ex.getMessage()+' : '+ex.getLineNumber()+' : '+ex.getStackTraceString(),'Quote/Proposal ESI call SFDC Error',order.Id,order.Retry_Count__c); 
            //return false;
        }
    } 
    
        /*=================================================================================
    Method to set MYR Terms details
    Added new parameters like Calcualted Year 1, 2,3 and 4 in the signature as part of DOC-11617
    ===================================================================================*/
    /**
     * @description orderTermsUtil
     * @param contractTerm 
     * @param baseValue 
     * @param adjustment
     * @param renewal
     * @param isRenewel
     * @param status
     * @param period
     * @param proratevalue
     * @param termtype
     * @param ismultitier
     * @param year1
     * @param year2
     * @param year3
     * @param year4
     * @param year5
     * @param percIncyr12
     * @param percIncyr23
     * @param percIncyr34
     * @param percIncyr45
     * @param isProflex
     */
    public static void orderTermsUtil(string contractTerm, Decimal baseValue, string adjustment,String renewal,Boolean isRenewel,String status, Integer period, Decimal proratevalue,String termtype,boolean ismultitier,Decimal year1,Decimal year2,Decimal year3,Decimal year4,Decimal year5, Decimal percIncyr12, Decimal percIncyr23, Decimal percIncyr34, Decimal percIncyr45, boolean isProflex) {
    //integer count = null;
        
          if(period==0){//SOC-6437 May Bijeta For short term
          
            if(isRenewel) {
                 Map<String,String> strMap = new Map<String,String>();
                 strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(0),renewal);
                 //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(0),renewal,baseValue,0));
                 ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,baseValue,0));
            }
            // If it is not renewel and First term then send Adjustment as 0
            else if(!isRenewel) {
                 Map<String,String> strMap = new Map<String,String>();
                 strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(0),'0');
                 //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(0),'0',baseValue,0));
                 ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, baseValue,0));
            }
            else {
                 Map<String,String> strMap = new Map<String,String>();
                 strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(0),adjustment);
                 //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(0),adjustment,baseValue,0));
                 ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, baseValue,0));
            }  
            
        }
        else{//SOC-6437 May Bijeta For short term   
                for(Integer i=1; i <= period; i++) 
                {
                    if(i == 1 && isRenewel) {
                    Map<String,String> strMap = new Map<String,String>();
                    strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),renewal);
                    //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),renewal,year1,0));
                    ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year1,0));
                    }
                // If it is not renewel and First term then send Adjustment as 0
                    else if(i == 1 && !isRenewel && (termtype == 'ProRate' || termtype == 'Co-Term and ProRate') && !ismultitier){
                    Map<String,String> strMap = new Map<String,String>();
                    strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                    //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,proratevalue,0));
                    ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, proratevalue,0));
                    }
                //DOC-3883 starts 
                    else if(i == 1 && (termtype == 'ProRate' || termtype == 'Co-Term and ProRate') && ismultitier){
                        Map<String,String> strMap = new Map<String,String>();
                        strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),'4');
                        //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),'4',proratevalue,0));
                        ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,proratevalue,0));
                    }
                    else if(ismultitier){
                        if(i == 1 && (!(termtype == 'ProRate' || termtype == 'Co-Term and ProRate'))){
                            if(!isProflex){     //DOC-14238
                                Map<String,String> strMap = new Map<String,String>();
                                strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                                //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,basevalue,0));
                                ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, basevalue,0));}
                            else{
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),'0');
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),'0',basevalue,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, basevalue,0));}
                        }//End
                        if(i == 2){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),string.ValueOf(percIncyr12));
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),string.ValueOf(percIncyr12),year2,0));    
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year2,0));} //DOC-4992
                        if(i == 3){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),string.ValueOf(percIncyr23));
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),string.ValueOf(percIncyr23),year3,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year3,0)); }//DOC-4992
                        if(i == 4){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),string.ValueOf(percIncyr34));
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),string.ValueOf(percIncyr34),year4,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,year4,0));} //DOC-4992
                        if(i == 5){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),string.ValueOf(percIncyr45));
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),string.ValueOf(percIncyr45),year5,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year5,0));} //DOC-4992                   
                    } 
                    else if(!ismultitier && !isRenewel){
                        if(i == 1 && (!(termtype == 'ProRate' || termtype == 'Co-Term and ProRate'))){
                        if(!isProflex){
                                Map<String,String> strMap = new Map<String,String>();
                                strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                                //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,basevalue,0));
                                ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, basevalue,0));}
                            else{
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),'0');
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),'0',basevalue,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,basevalue,0));}
                        }//End
                        if(i == 2){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year2,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year2,0));} //DOC-4992
                        if(i == 3){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year3,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year3,0));} //DOC-4992
                        if(i == 4){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year4,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year4,0));} //DOC-4992
                        if(i == 5){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year5,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year5,0));} //DOC-4992           
                    } 
                    else if(!ismultitier && isRenewel){
                        if(i == 1 && (!(termtype == 'ProRate' || termtype == 'Co-Term and ProRate'))){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                           //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,baseValue,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, baseValue,0));}
                        if(i == 2){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year2,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,year2,0));} //DOC-4992
                        if(i == 3){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year3,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,year3,0));} //DOC-4992
                        if(i == 4){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year4,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,year4,0));} //DOC-4992
                        if(i == 5){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year5,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,year5,0));} //DOC-4992           
                    }
                    else {
                        Map<String,String> strMap = new Map<String,String>();
                        strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                        //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,baseValue,0));
                        ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, baseValue,0));
                    }            
           
                }
            } 
    } 
    /*=================================================================================
    Method to set MYR Terms details for renewals
    Added new parameters like Calculated Year 1, 2,3 and 4 in the signature as part of DOC-11617
    ===================================================================================*/
    //public static void orderTerms(string contractTerm, Decimal baseValue, string adjustment,String renewal, string status) {

        /**
     * @description orderTerms
     * @param contractTerm 
     * @param baseValue 
     * @param adjustment
     * @param renewal
     * @param status
     * @param termtype
     * @param proratevalue
     * @param year1
     * @param year2
     * @param year3
     * @param year4
     * @param year5
     * @param ismultitier
     * @param percIncyr12
     * @param percIncyr23
     * @param percIncyr34
     * @param percIncyr45
     * @param isProflex
     */
    public static void orderTerms(string contractTerm, Decimal baseValue, string adjustment, String renewal, string status,String termtype ,Decimal proratevalue, Decimal year1,Decimal year2,Decimal year3,Decimal year4,Decimal year5, boolean ismultitier,Decimal percIncyr12, Decimal percIncyr23, Decimal percIncyr34, Decimal percIncyr45, boolean isProflex) {    
        //Contract Term =0 //SOC-6437 May Bijeta For short term
        if(string.valueof(contractTerm)=='Short Term Trial')
        {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            //Added following parameters as part of MTP status, Integer period, Decimal proratevalue,String termtype,boolean ismultitier,Decimal year1,Decimal year2,Decimal year3,Decimal year4,Decimal year5
            if(status=='Renewed'){            
            orderTermsUtil('0',baseValue,adjustment,renewal,true,status,0,proratevalue, termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
            else{
            orderTermsUtil('0',baseValue,adjustment,'0',false, status,0,proratevalue, termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
        }
        
        
        //Contract Term =1
        if(string.valueof(contractTerm)=='1 Year')
        {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            if(status=='Renewed'){            
            orderTermsUtil('1',baseValue,adjustment,renewal,true,status,1,proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
            else if(status == 'New' && (termtype == 'ProRate' || termtype == 'Co-Term and ProRate')){
                orderTermsUtil('1',proratevalue,adjustment,'0',false, status,1, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
            else {
                orderTermsUtil('1',baseValue,adjustment,'0',false,status,1, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
        }
        
         
        //Contract Term =2  
        if(string.valueof(contractTerm)=='2 Years')
        {  // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
           if(status=='Renewed'){            
            orderTermsUtil('2',baseValue,adjustment,renewal,true,status,2, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
            else{
            orderTermsUtil('2',baseValue,adjustment,'0',false,status,2, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
        }
        //Contract Term =3
        if(string.valueof(contractTerm)=='3 Years')
        {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
           if(status=='Renewed'){            
            orderTermsUtil('3',baseValue,adjustment,renewal,true,status,3, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
            else{
            orderTermsUtil('3',baseValue,adjustment,'0',false,status,3, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);         
            }
        }
        //Contract Term =4
        if(string.valueof(contractTerm)=='4 Years')
        {  // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            if(status=='Renewed'){            
            orderTermsUtil('4',baseValue,adjustment,renewal,true,status,4,proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
            else{
            orderTermsUtil('4',baseValue,adjustment,'0',false,status,4,proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
        }
        //Contract Term =5
        if(string.valueof(contractTerm)=='5 Years')
        {  
            // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            if(status=='Renewed'){            
            orderTermsUtil('5',baseValue,adjustment,renewal,true,status,5,proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
            else{
            orderTermsUtil('5',baseValue,adjustment,'0',false,status,5,proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5, percIncyr12,  percIncyr23, percIncyr34, percIncyr45,isProflex);
            }
        }
        //Contract Term =10
        /*Commented as part of DOC-12762
        if(string.valueof(contractTerm)=='10 Years')
        {
            // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            if(status=='Renewed'){            
            orderTermsUtil('10',baseValue,adjustment,renewal,true,10);
            }
            else{
            orderTermsUtil('10',baseValue,adjustment,'0',false,10);
            }
        }*/
        }


    
     //SOC-5793
    
     //SOC-5793
     /*public static void orderheaderAttachment(String propName,boolean check,string propId){
     String attName = '%'+propName+'%';
     List<Attachment> attachList = new List<Attachment>();
         if(Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Attachment.isQueryable()){
                if(check == false) {
                    attachList = [SELECT Id FROM Attachment WHERE (ParentId =:propId AND Name LIKE :attName) ORDER BY LastModifiedDate ASC NULLS LAST LIMIT 1];
                } else {
                    attachList = [SELECT Id FROM Attachment WHERE (ParentId =:propId AND Name LIKE :attName) ORDER BY LastModifiedDate ASC NULLS LAST];
                }
            }
            if(!attachList.isEmpty()) {
                For(Attachment att: attachList) 
               {
                CreateOrderRequest.attachments attachment = new CreateOrderRequest.attachments();
                attachment.path = att.Id;
                attachment.type= 'OR';
                attachment.status= 'E'; 
                ordreq.CreateOrderRequest.OrderHeader.attachments.add(attachment);
                }   
            } 
             
        }*/
        
                /*=================================================================================
    Method to logException details
    ===================================================================================*/   
    /**
     * @description logException
     * @param strBody 
     * @param error 
     * @param orderId
     * @param retryCount
     */
    /* public static void logException(string strBody, string error,Id orderId,Decimal retryCount) {
        List<Integration_Logger__c> intLogList = new List<Integration_Logger__c>();
            //if(retryCount>=1){
          system.debug(LoggingLevel.WARN,'Order Queue ESI LogException Retry COunt ::'+retryCount);
          if(Schema.sObjectType.Integration_Logger__c.isAccessible() && Schema.sObjectType.Integration_Logger__c.isQueryable()){
              intLogList=[Select Id from Integration_Logger__c where Order__c=:orderId];
              system.debug(LoggingLevel.WARN,'intLogList :: '+intLogList);
          }
          if(intLogList!=null && intLogList.size()==1){
            IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false,error,strBody);
          //}
        }else{
          system.debug(LoggingLevel.WARN,'else part of LogException Retry COunt :: '+retryCount);
          IntegrationLogger.OCAddMessage(error,'', 'Quote/Proposal', strBody, 'Outbound','OrderSubmission',false,orderId);
             
        } 
      } */
      
      /*=================================================================================
    Method For MYR details
    ===================================================================================*/   
    /**
     * @description termUtil
     * @return termUtil
     * @param tLen 
     * @param period 
     * @param percInc
     * @param bValue
     * @param uRate
     */ 
   /*public static CreateOrderRequest.terms termUtil(string tLen, string period, string percInc, Decimal bValue, Decimal uRate) {
        CreateOrderRequest.terms term = new CreateOrderRequest.terms();
        term.termLength= tLen;
        term.period= period;
        term.percentIncrease= percInc;
        term.baseValue= bValue;
        term.userRate= uRate;
        return term;
    }*/
    

    
     /*=================================================================================
    SOC-5358 Assign Line Items - Pratheeksha
    ===================================================================================*/
    //Added Quantity - may release
    /**
     * @description assignDealLines
     * @return assignDealLines
     * @param lNo 
     * @param recType 
     * @param cno
     * @param cln
     * @param quantity
     */
   /* public static CreateOrderRequest.lineItems assignDealLines(integer lNo,string recType,decimal cno,decimal cln,decimal quantity) {
        CreateOrderRequest.lineItems ln = new CreateOrderRequest.lineItems();         
        ln.recordType = recType;
        ln.lineNumber = (lNo != 0? string.valueof(lNo) : '');
        ln.existingSub = (cno != 0? string.valueof(cno) : '');
        ln.existingSubLine = (cln != 0? string.valueof(cln) : '');
        ln.quanity = (quantity != 0? string.valueOf(quantity).substringBefore('.') : '');
        return ln;
    }*/
    
         //Sreenu changes SOC-3371
     /**
       * @description assignOrderLineitemCategory
       * @param icGroup
       * @param billFrequency
       * @param programId
     */
   /*public static void assignOrderLineitemCategory(string icGroup, string billFrequency, string programId) {
        //if(programId != 'WCMP') { -  SOC-5965
            if(icGroup =='ZPMT') {
                if(billFrequency =='Yearly'){
                ordline.itemCategory='ZGR5';}
                else if(billFrequency =='Monthly'){ 
                ordline.itemCategory='ZGRP';}
            }
            else if(icGroup =='ZPAL') {
            if(billFrequency =='Yearly'){
            ordline.itemCategory='ZGR3';}
                else if(billFrequency =='Monthly') {
                ordline.itemCategory='ZGR2';}
            } 
        //} - SOC-5965
    }
    // Sreenu changes End 
    */
    
           /*=================================================================================
        Online Contacts Mapping Method for MLA User Details
        ===================================================================================*/ 
        /**
       * @description onlineContactAssign
       * @param multiAcccon
       * @param multiAcc
       */
     /* public static void onlineContactAssign(Online_Contacts__c multiAcccon, APTS_Quote_Agreement_Locations__c multiAcc) {
        userDetails= new CreateOrderRequest.UserDetails();
       // system.debug(LoggingLevel.WARN,'#### multiAcccon'+multiAcccon+'##### multiAcc'+multiAcc);
        if(multiAcccon.APTS_Source_System_Detail__c==multiAcc.APTS_Subscriber_Location_SSD__c){
            userDetails.locationAcc=multiAcccon.APTS_Source_System_Detail__r.Source_System_Account_Number__c;
            if(multiAcccon.Type__c=='Admin' && !materialBrandCodeMap.isEmpty() && materialBrandCodeMap.containsKey(multiAcccon.Material__c) && materialBrandCodeMap.get(multiAcccon.Material__c) == '064'){
                userDetails.contactType='0230';
            }  
            else if(multiAcccon.Position__c == 'Attorney'){  
               userDetails.contactType='0100';
                }
            else if(multiAcccon.Position__c=='Clerk'){
               userDetails.contactType='0050';
                }
            else if(multiAcccon.Position__c=='Judge'){
               userDetails.contactType='0080';
                }
            else if(multiAcccon.Position__c=='Librarian'){
               userDetails.contactType='0060';
                }
            else if(multiAcccon.Position__c=='Non-Attorney'){
                userDetails.contactType='0090';
                }
            else if(multiAcccon.Position__c=='Paralegal'){
               userDetails.contactType='0030';
                }
            else if(multiAcccon.Position__c=='Administrator'){
                 userDetails.contactType='0290';
                }            
            else if(multiAcccon.Position__c=='Analyst'){
                userDetails.contactType='0310';
                }
             else if(multiAcccon.Position__c=='Supervisor'){
               userDetails.contactType='0280';
                }
              else if(multiAcccon.Position__c=='Clear Administrator'){
                    userDetails.contactType='0290';
                    }
                else if(multiAcccon.Position__c=='Clear Analyst'){
                    userDetails.contactType='0310';
                    }
                else if(multiAcccon.Position__c=='Clear Investigator'){
                 userDetails.contactType='0300';
                  }
                else if(multiAcccon.Position__c=='Clear Supervisor'){
                  userDetails.contactType='0280';
                   }
                     
                else if(multiAcccon.Position__c=='Clear Technical'){
                    userDetails.contactType='0270';
                    }
                    else if(multiAcccon.Position__c=='Summer Associates'){
                    userDetails.contactType='0270';
                    }
            userDetails.contactNum=multiAcccon.ContactID__c;
            userDetails.firstName=multiAcccon.First_Name__c;
            userDetails.lastName=multiAcccon.Last_Name__c;                        
            userDetails.email=multiAcccon.Email__c;
            userDetailsinfo.add(UserDetails);
        }
    }*/
  
}
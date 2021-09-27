/**
* Interface to send the order details to ESI 
* Order Details
*
* @author  TCS
* @version 2016-09-22
*/

/**
* CHANGE HISTORY
* =============================================================================
* Date         Name                            Description
* 2016-09-22   Prabhu Issac/ Sreenu              Created 
* 2017-12-12   Tejaswi Nissankula                Modified(CRM-9456)
* 2018-11-12   Shiva Sri Arun Koralla            Modified(DLT - 13620) 
* 2019-18-01   Shiva Sri Arun Koralla            Modified(DLT - 14642)
* 2019-17-04   Shiva Sri Arun Koralla          Modified(DLT - 16201)
* =============================================================================
* As part CRM-9456 ::replaced Bill to,Ship to,Sold to related fields of account 
*                     with Bill to SSD,Ship to SSD,Sold to SSD  related fields of SSD in whole class
*                   ::all account lookup related fields wrt to objects queried in the class are replaced with ssd related fields
*                   ::removed Queueable and AllowCallouts interface
*  DLT - 13620 :: [IE] Setup new originating system SF08 in SFDC 
*  DLT - 14642 :: Send credit card details from all proposals when the payment option is "Payment Express Auto EFT/Auto Charge"
*/
// this class is calling from OrdersubmissionESI class
  /**
     * @description APTS_OrderQueuetoESI
   */
  public with sharing class APTS_OrderQueuetoESI  {
   
    public static CreateOrderRequest.orderLines ordline;
    static Map<string, string> materialBrandCodeMap;
    static Map<string, Decimal> materialMap;
    static Map<string, string> bundlematerialMap;
    static CreateOrderRequest ordreq;
    static CreateOrderRequest.UserDetails userDetails;
    static List<CreateOrderRequest.UserDetails> userDetailsinfo;
    //SOC-3625
    static Boolean wnProduct=false;
    /**
       * @description orderNo
       * @return string
     */
    public static string orderNo {get; set;}
   
    
    
    // method to execute and callout to ESI
     /**
       * @description orderSubmissionToESI
       * @param orderId
       * @return APTS_Ordersubmissionwrapper
     */
    public static  APTS_Ordersubmissionwrapper  orderSubmissionToESI(Id orderId) {
        // Variables
      //  orderNo = orderNum;
        ordline = new CreateOrderRequest.orderLines();
        Boolean isOnline = false;
        Integer lineNumber=1;
        Integer fillupLineNumber=1; // To Count the Fillup LineItems
        Integer plNum = 0; // Primary Line Nymber for Fillup line items.
        //Boolean isModeA = false; Pmd fix for unused variable
        //Boolean isModeW = false; Pmd fix for unused variable
        Boolean isFillup = False; // To Identify if order line is Fillup
        Boolean isSubFee = False; // To Identify if Order line is Fillup and charge type is Subscription Fee
        Boolean isSubFeeOrder = False; //  To Identify if Order line is Fillup and assign to tempory order variable to rearrange the sequence of Fillups
        Boolean isFillupOption = False; // To Identify if Order line is Fillup and LineType is option
        Boolean isFillupOnly = False;
        Decimal periodicValue=0;
        Boolean blnIsCaseLine = false; //DOC-15023
        Boolean blnIsPondera = false;
    //SOC 5107
        Decimal oneTimeValue=0;
        materialMap = new Map<string, Decimal>();
        bundlematerialMap = new Map<string, string>();
        Map<string, Integer> countMap = new Map<string, Integer>();
       // Map<Id,Sobject> ownerMap = new Map<Id,Sobject>();
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
        userDetails= new CreateOrderRequest.UserDetails();
        userDetailsinfo = new List<CreateOrderRequest.UserDetails>();
        CreateOrderRequest.adjustments fillupadjustment= new CreateOrderRequest.adjustments();
       // Boolean isBundleAdded = False;
       // string curBundlGroup = '';
        string mlAcc = '';
        Boolean isMLAModify=false;
        Boolean isnotMLAModify = False;
        Boolean isMLAReplace = False; // Soc- 3465
        Boolean isProflexBLI = False; // DOC-12198
        //String MLAAgreementNumber = '';//SOC-3465
        Boolean isReplaceMode = false; //DOC-9689 : Jinal Bhatt
        String numberOfAttorneys = ''; //DOC-9689
        Boolean qtyChange;//Soc-3835 && SOC-3839
        Boolean edltProduct;//Soc-3835 && SOC-3839
    Boolean isProflex=false;    
        string flEmail = '';
    Integer dealSerialNumber = 0; //SOC-5358
        Integer dealLineNumber = 0; //SOC-5358
      //  Integer cprolinenumber = 0; //SOC-7059
        Apttus_Config2__Order__c order;
        String vSCSPrintPrimary;
        String vSCSSpecialOffer1;
        String vSCSSpecialOffer2;
        String vSCSMLAAgreementNumber;
        String vRiskRIProfessionalServices = '';
        Boolean blnIsContactRequired = false; //DOC-11983: Jinal Bhatt
        String vCLValidProflex; //DOC-14661
        Boolean isGLPProduct = false; //GLP -230
        String bundlePrimMaterial='';
        List<APTS_Integration_Variables__mdt> orderSubmissionEsiList= new List<APTS_Integration_Variables__mdt>();
        if(Schema.sObjectType.APTS_Integration_Variables__mdt.isAccessible() && Schema.sObjectType.APTS_Integration_Variables__mdt.isQueryable()){
           /* return null;
        }
  
        List<APTS_Integration_Variables__mdt>*/ orderSubmissionEsiList=[Select MasterLabel,Value__c from APTS_Integration_Variables__mdt];}
        for(APTS_Integration_Variables__mdt var : orderSubmissionEsiList){
           if(var.masterlabel=='SCS Print Primary'){
           vSCSPrintPrimary=var.Value__c;}
            if(var.masterlabel=='SCS Special Offer1'){
            vSCSSpecialOffer1=var.Value__c;}
            if(var.masterlabel=='SCS Special Offer2'){
            vSCSSpecialOffer2=var.Value__c;}
            if(var.masterlabel=='SCSMLAAgreementNumber'){
            vSCSMLAAgreementNumber=var.Value__c;}
            if(var.masterlabel.contains('Risk RI Professional Services')){
                vRiskRIProfessionalServices = vRiskRIProfessionalServices + var.Value__c;
            }
           // DOC-14661
            if(var.masterlabel.contains('Caseline Valid Proflex')){
                vCLValidProflex = var.Value__c;
            }
        }
        List<String> materialNumberList = new List<String>();
        materialNumberList=vSCSMLAAgreementNumber.split(',');
        APTS_Ordersubmissionwrapper ordersubwrap = new APTS_Ordersubmissionwrapper();
        String loggerId;
        //List<Integration_Logger__c> intLogList = new List<Integration_Logger__c>();pmd fix for unused variable
        try {
            isOnline = False;   
            List<Online_Contacts__c> onlinecon = new List<Online_Contacts__c>();
            List<Customer_Master_Contacts__c> mastercon = new List<Customer_Master_Contacts__c>();
            List<APTS_Quote_Agreement_Locations__c> multiLocAccount = new List<APTS_Quote_Agreement_Locations__c>();
            
            //Added Standard Bundle and Corporate Select to the Query SOC-5819 //SOC-4320 FEB release By Bijeta
            //SOC-5358 - Added CreatedDate field to the below query
            //SOC-6753 - Added APTS_Payer__c,APTS_Payer__r.Source_System_Account_Number__c to the below query //SOC-5991 Plan Type //SOC-4827 RiskCategory Field
            order = APTS_OrderSubmissionUtilityExt.queryOrders(orderId);
            //Doc-15792
            List<Ent_Trial__c> trialslist = new List<Ent_Trial__c>(); //trials change
            List<Apttus_Config2__OrderLineItem__c> orderLineItems = new List<Apttus_Config2__OrderLineItem__c>();
            List<Apttus_Approval__Approval_Request__c> approvalNumberlst=new list<Apttus_Approval__Approval_Request__c>();
            List<APTS_Additional_Subscription_Actions__c> additionalSublist= new List<APTS_Additional_Subscription_Actions__c>();
            List<APTS_Dynamic_Bundle__c> dynamicbundlelist = new List<APTS_Dynamic_Bundle__c>();
            List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
            List<AggregateResult> results = new List<AggregateResult>();
            User proposalOwner = new User();
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
           if(order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Opportunity__r.Active_Trial__c==true){//doc-15792
               trialslist = APTS_OrderQueuetoESIUtility.queryoftrialslist(order.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Opportunity__c);
            }
            }                 
            //SOC-4222 Nov release
            String approvalNumber='';
      
            if(!Schema.sObjectType.Apttus_Approval__Approval_Request__c.isAccessible() && !Schema.sObjectType.Apttus_Approval__Approval_Request__c.isQueryable()){return null;
            }
      
            if([SELECT id,Name,APTS_Related_Quote_Number__c,Apttus_QPApprov__ProposalId__c,Apttus_Approval__Approval_Status__c FROM Apttus_Approval__Approval_Request__c where Apttus_QPApprov__ProposalId__c=:order.Apttus_QPConfig__ProposalId__r.Id]!=null
      &&[SELECT id,Name,Apttus_QPApprov__ProposalId__c FROM Apttus_Approval__Approval_Request__c where Apttus_QPApprov__ProposalId__c=:order.Apttus_QPConfig__ProposalId__r.Id].size()!=0){            
        approvalNumberlst= [SELECT id,Name,APTS_Related_Quote_Number__c,Apttus_Approval__Approval_Status__c,Apttus_QPApprov__ProposalId__c FROM Apttus_Approval__Approval_Request__c where Apttus_QPApprov__ProposalId__c=:order.Apttus_QPConfig__ProposalId__r.Id];
        for(Apttus_Approval__Approval_Request__c temp: approvalNumberlst){
              if(temp.Apttus_Approval__Approval_Status__c=='Approved'){
                  approvalNumber= temp.APTS_Related_Quote_Number__c;}
              else{
                  approvalNumber=Null;}
          }
      }else{
        approvalNumber= null; 
      }
            ordreq = new CreateOrderRequest ();   
            //Doc-15792
         
      
       if(trialslist!=null)  //trials change
           {
             for(Ent_Trial__c e:trialslist)
               {
                 CreateOrderRequest.OfferWrapper offerwrapper = new CreateOrderRequest.OfferWrapper();
                 offerwrapper.offerId = e.Id;
                 ordreq.CreateOrderRequest.orderHeader.offerData.add(offerwrapper);
                }
            } 
            ordreq.CreateOrderRequest.orderHeader.trialId=order.APTS_SSD_Sold_To__r.OLC_Account_Number__c;//Doc-15792  
           
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
            //DOC 13835 Poonam Garg
            Boolean hasDynamicBundle = order.Apttus_QPConfig__ProposalId__r.APTS_HAS_DYNAMIC_BUNDLE__c;
            //Roma Ends    
                  if(!dynamicbundlelist.isEmpty() && !hasDynamicBundle){
                    APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                  //Dynamic bundling Primary line item creation
                      for(APTS_Dynamic_Bundle__c dynamicbundle :dynamicbundlelist) 
                      {
                        //System.debug('has bundle rec');
                        if(dynamicbundle.APTS_Bundle_Primary_Material__c != null )
                        {
                ordline = new CreateOrderRequest.orderLines();
                bundlePrimMaterial=dynamicbundle.APTS_Bundle_Primary_Material__c;
                ordline.material.materialId=dynamicbundle.APTS_Bundle_Primary_Material__c;
                ordline.material.description=dynamicbundle.Name;
                ordline.lineNumber=String.valueOf(lineNumber);
                //skg added the following line for JIRA-3395
                ordline.billOfMaterialsType='SON';
                ordline.netAmount= dynamicbundle.APTS_Net_Price__c!=null ? dynamicbundle.APTS_Net_Price__c.setscale(5) : null;
                ordline.listAmount= dynamicbundle.APTS_Net_Price__c!=null ? dynamicbundle.APTS_Net_Price__c.setscale(5) : null;
                ordline.quantity=1;
                ordline.unitOfMeasure='EA'; 
                ordline.keepTerms=dynamicbundle.APTS_Keep_Terms__c; 
        //SOC-4367 Nov Changes
          if(order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=''){
            ordline.saID=order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c.substringAfter('(').remove(')');  
                    }
                // call method to assign the terms to order
  
                //Added 
                orderTerms(dynamicbundle.APTS_Contract_Terms__c, 0, dynamicbundle.APTS_YoY_2_Plus__c,dynamicbundle.APTS_YoY_1_Renewal__c,'','',0.00,0.00,0.00,0.00,0.00,0.00,false,0.00,0.00,0.00,0.00,true);
                //Bridge Details
                if(dynamicbundle.APTS_Bridge_Discount_Number__c != null){
                    CreateOrderRequest.adjustments adjustment1 = new CreateOrderRequest.adjustments();
                    adjustment1.type ='PERCENT';
                    adjustment1.discountType='BridgeDiscount';//SOC-6755 May Bijeta
                    adjustment1.amount=dynamicbundle.APTS_Bridge_Discount_Number__c;
                    ordline.adjustments.add(adjustment1); 
                }
                //skg SOC-3454 program id
                if(dynamicbundle.APTS_Program_ID__c!='WCMP')
                {              
                ordline.billPlanType='Monthly';
                //system.debug(LoggingLevel.WARN,'########### 1');
                //SOC-5819 //SOC-5991
                }
                
                //Start: Added by Kruti Shah DOC-11650 
                                              
                if(dynamicbundle.APTS_Quote_Proposal__r.APTS_Is_HighQ_Quote__c != null && 
                    dynamicbundle.APTS_Quote_Proposal__r.APTS_Is_HighQ_Quote__c>0){
                    if(dynamicbundle.APTS_Billing_Frequency__c=='Yearly'){
                         ordline.billPlanType='Yearly';
                    }else{
                        ordline.billPlanType='Monthly';
                    }                    
                }     //Commented on 6th Nov            
                //End: Added by Kruti Shah DOC-11650
  
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
                        //ordreq.CreateOrderRequest.OrderHeader.oaMode='W'; //Commented as a part of DOC-15125
                        //isModeW=true;
                       
                    }else if(dynamicbundle.APTS_Keep_Terms__c!=true && dynamicbundle.APTS_Deal_Number__c==null){
                        //For WCMP new scenario:Send in ordernotes – “New”
                        CreateOrderRequest.orderNotes bundlenote= new CreateOrderRequest.orderNotes();
                        bundlenote.notes='New';
                        ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(bundlenote); 
                        //SOC-5819
                        //ordreq.CreateOrderRequest.OrderHeader.oaMode='W'; //Commented as a part of DOC-15125
                        //isModeW=true; 
                    } //Commented 6th Nov
                    //SOC-5990
                    //DOC-15125
                    /*else if(dynamicbundle.APTS_Keep_Terms__c!=true && dynamicbundle.APTS_Deal_Number__c!=null){
                             //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                             //isModeW=true; 
                    }*/
                }
                //SOC-5358                 
                if(dynamicbundle.APTS_Program_ID__c == 'WCMP'){                    
                    CreateOrderRequest.orderDeal oDeal = new CreateOrderRequest.orderDeal();
                    Boolean primaryDeal = true;
                    relLineNumber = dynamicbundlelist.size() + 1;
                    oDeal.dealId = ''; //SOC-5910
                    for(Apttus_Config2__LineItem__c lineItem : lineItemList){                                                                       
                            if(lineItem.APTS_Group__c == dynamicbundle.APTS_Group__c && primaryDeal && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' && lineItem.APTS_Program_ID__c == 'WCMP'){
                                dealSerialNumber += 1;
                                dealLineNumber += 1;                                
                                oDeal.programId = 'WCMP';
                                //oDeal.dealId = string.valueOf(dynamicbundle.APTS_Deal_Number__c); - SOC-5910
                                oDeal.startDate = Order.CreatedDate.format('yyyyMMdd');
                                oDeal.endDate = DateTime.newInstance(9999, 12, 31).format('yyyyMMdd');
                                Map<Decimal,Decimal> mapDecimalValues =new Map<Decimal,Decimal>();
                                mapDecimalValues = APTS_OrderSubmissionUtilityExt1.returnDecimalMap(0,0,0);
                                //oDeal.lineItems.add(assignDealLines(dealLineNumber,'PRI',0,0,0));
                                oDeal.lineItems.add(APTS_OrderSubmissionUtilityExt1.assignDealLines(dealLineNumber,'PRI',mapDecimalValues));
                                oDeal.dealSerialNumber = String.valueOf(dealSerialNumber);                                
                                primaryDeal = false; 
                                //May release - actionCode SOC-5982
                                if(lineItem.APTS_Deal_Type__c != 'WCMP' && lineItem.APTS_Deal_Type__c != null){
                                    if(dynamicbundle.APTS_Keep_Terms__c == false && dynamicbundle.APTS_Deal_Number__c != null){
                                        oDeal.actionCode = 'NEW';
                                        }
                                }else if(lineItem.APTS_Deal_Type__c == 'WCMP' || lineItem.APTS_Deal_Type__c == null){
                                    if(dynamicbundle.APTS_Keep_Terms__c == false && dynamicbundle.APTS_Deal_Number__c == null ){
                                        oDeal.actionCode = 'NEW';
                                }else if(dynamicbundle.APTS_Keep_Terms__c == true && dynamicbundle.APTS_Deal_Number__c != null){
                                    oDeal.actionCode = 'MODIFY';
                                }else if(dynamicbundle.APTS_Keep_Terms__c == false && dynamicbundle.APTS_Deal_Number__c != null){
                                    oDeal.actionCode = 'REPLACE';
                                }    //Commented on 6th Nov
                                }//May release - actionCode - ends SOC-5982 
                            }
                            if(lineItem.APTS_Group__c == dynamicbundle.APTS_Group__c && primaryDeal==false && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Program_ID__c == 'WCMP' ){
                                Map<Decimal,Decimal> mapDecimalValues =new Map<Decimal,Decimal>();
                                mapDecimalValues = APTS_OrderSubmissionUtilityExt1.returnDecimalMap(lineItem.APTS_Contract_Number__c,lineItem.APTS_Contract_Line_Number__c,0); 
                                //oDeal.lineItems.add(assignDealLines(relLineNumber,'SEC',lineItem.APTS_Contract_Number__c,lineItem.APTS_Contract_Line_Number__c,0));
                                 oDeal.lineItems.add(APTS_OrderSubmissionUtilityExt1.assignDealLines(relLineNumber,'SEC',mapDecimalValues));                                   
                                relLineNumber += 1; 
                                //SOC-5910
                                if(lineItem.APTS_Deal_Type__c == 'WCMP') {
                                oDeal.dealId = string.valueOf(dynamicbundle.APTS_Deal_Number__c); }                              
                            }else if(lineItem.APTS_Group__c == dynamicbundle.APTS_Group__c && lineItem.Apttus_Config2__LineStatus__c == 'Amended' && lineItem.APTS_Program_ID__c == 'WCMP'){
                                Map<Decimal,Decimal> mapDecimalValues =new Map<Decimal,Decimal>();
                                mapDecimalValues = APTS_OrderSubmissionUtilityExt1.returnDecimalMap(lineItem.APTS_Contract_Number__c,lineItem.APTS_Contract_Line_Number__c,lineItem.Apttus_Config2__Quantity__c);
                                //oDeal.lineItems.add(assignDealLines(0,'SEC',lineItem.APTS_Contract_Number__c,lineItem.APTS_Contract_Line_Number__c,lineItem.Apttus_Config2__Quantity__c));
                                oDeal.lineItems.add(APTS_OrderSubmissionUtilityExt1.assignDealLines(0,'SEC',mapDecimalValues));
                                //SOC-5910
                                if(lineItem.APTS_Deal_Type__c == 'WCMP'){ 
                                oDeal.dealId = string.valueOf(dynamicbundle.APTS_Deal_Number__c);} 
                            } else if(lineItem.APTS_Program_ID__c != 'WCMP' && lineItem.Apttus_Config2__LineStatus__c != 'Amended' && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled'){
                                relLineNumber += 1;
                            } else if (lineItem.APTS_Group__c != dynamicbundle.APTS_Group__c && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Program_ID__c == 'WCMP') { 
                                  relLineNumber +=1;    
                                }             
                     }  
                     ordreq.CreateOrderRequest.OrderHeader.orderDeal.add(oDeal);                       
                 } else{
                     //the counters should be incremented
                     dealLineNumber += 1;
                 }
                //SOC-5358 ends
                //Commented below for PMD fix Empty Block
                //if(dynamicbundle.APTS_Bundle_Adjustment_Type__c == '% Discount' && dynamicbundle.APTS_Program_ID__c=='WCMP'){              
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
                Else if(dynamicbundle.APTS_Bridge__c=='14 Days'){ordline.billPlanUpdateRule='14D';
                  }
                Else if(dynamicbundle.APTS_Bridge__c=='28 Days'){ordline.billPlanUpdateRule='28D';
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
                //skg CreateOrderRequest.terms term = new CreateOrderRequest.terms();
                //skg term.baseValue=dynamicbundle.APTS_Net_Price__c;
                //skg ordline.subscriptionDetail.terms.add(term);
                //skg ordline.netAmount=dynamicbundle.APTS_Net_Price__c - ((dynamicbundle.APTS_Net_Price__c * dynamicbundle.APTS_Bridge_Discount_Number__c/100));
                ordline.netAmount= dynamicbundle.APTS_Bridge_Monthly_Charges__c!=null ? (dynamicbundle.APTS_Bridge_Monthly_Charges__c).setScale(5) : null;
                }                                            
                
                // Bridge Details ends                                       
                ordreq.CreateOrderRequest.orderLines.add(ordline);                
                
                CreateOrderRequest.orderNotes bundlenote= new CreateOrderRequest.orderNotes();
                bundlenote.notes='Group:'+dynamicbundle.APTS_Group__c+'. Bundle Adjustment '+dynamicbundle.APTS_Bundle_Adjustment_Type__c+' : '+dynamicbundle.APTS_Bundle_Adjustment_Amount__c+'.';                
                ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(bundlenote);
                //SOC-5819  
                //ordreq.CreateOrderRequest.OrderHeader.oaMode='A';
                //isModeA=true;  
                if(dynamicbundle.APTS_Keep_Terms__c==true && dynamicbundle.APTS_MLA_Agreement_Number__c!=null){
                    isMLAModify = true;
               //SOC-5991
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='W'; //Commented as a part of DOC-15125
                    //isModeW=true;                        
                    }
                if(!dynamicbundle.APTS_Keep_Terms__c && string.isEmpty(dynamicbundle.APTS_MLA_Agreement_Number__c)){
                isnotMLAModify = True;}             
                    // SOC-5991
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='W'; //Commented as a part of DOC-15125
                    //isModeW=true; 
                lineNumber+=1;
               
            }}}//}}  //DOC-12198 added } here
             //Online Deals - May Release - SOC-5982
             // only Corp Select bundles  
                                   //may release Online Bundle ends   - SOC-5982 
                                   //SOC-4827
            CreateOrderRequest.orderDeal oDealCorp = new CreateOrderRequest.orderDeal();
             // List<CreateOrderRequest.orderDeal> oDealList = new List<CreateOrderRequest.orderDeal>();
              Boolean isCorp = false;
              relLineNumber = dynamicbundlelist.size()>0 ? dynamicbundlelist.size() + 1 : 1;
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
                        //System.debug('oDealCorp1'+ oDealCorp);
                        isCorp  = true;
                        relLineNumber += 1;
                        }else if(lineItem.Apttus_Config2__OptionId__r.APTS_Corporate_Select__c == 'Module' && lineItem.Apttus_Config2__LineStatus__c == 'New'){       
                            Map<Decimal,Decimal> mapDecimalValues =new Map<Decimal,Decimal>();
                            mapDecimalValues = APTS_OrderSubmissionUtilityExt1.returnDecimalMap(0,0,0);
                            //oDealCorp.lineItems.add(assignDealLines(relLineNumber,'SEC',0,0,0));
                            oDealCorp.lineItems.add(APTS_OrderSubmissionUtilityExt1.assignDealLines(relLineNumber,'SEC',mapDecimalValues));
                             relLineNumber += 1;
                              isCorp  = true; 
                             // System.debug('oDealCorp1'+ oDealCorp);
                        
                              } else if((lineItem.Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c || lineItem.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Ship & Entitle - APP' || lineItem.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Sub Only APP' || lineItem.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Ship & Entitle Sub' || lineItem.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Sub Only' || lineItem.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Ship & Entitle Only') && lineItem.Apttus_Config2__LineStatus__c == 'New') { 
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
                                 // System.debug('oDealCorp1'+ oDealStd);
                        
                                  //Send Program Id
                                  if( (lineItem.APTS_Media_High_Level_Code__c == '06' && (lineItem.APTS_Media_Lower_Level_Code__c == 'I9' || lineItem.APTS_Media_Lower_Level_Code__c == 'LW')) || APTS_OrderSubmissionUtilityExt2.validateMLLCode(lineItem.APTS_Media_Lower_Level_Code__c , System.Label.APTS_MLLCodes_CPRO) ){
                                      oDealStd.programId = 'CPRO';
                                      //System.debug('oDealCorp1'+ oDealStd);
                                  }else if( (lineItem.APTS_Media_High_Level_Code__c == '06' && APTS_OrderSubmissionUtilityExt2.validateMLLCode(lineItem.APTS_Media_Lower_Level_Code__c,System.Label.APTS_MLLCodes_06SEAT)) || (lineItem.APTS_Media_High_Level_Code__c == '13' && APTS_OrderSubmissionUtilityExt2.validateMLLCode(lineItem.APTS_Media_Lower_Level_Code__c,System.Label.APTS_MLLCodes_13SEAT)) || (lineItem.APTS_Media_High_Level_Code__c == '05' && lineItem.APTS_Media_Lower_Level_Code__c == 'E2') ){
                                      oDealStd.programId = 'SEAT';
                                      //System.debug('oDealCorp1'+ oDealStd);
                                  } //Start:GLP-183 
                                   else if (lineItem.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Ship & Entitle - APP'
                                    || lineItem.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Sub Only APP') {
                                    oDealStd.programId = 'WSTPRM';
                                     } else if (lineItem.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Ship & Entitle Sub'|| lineItem.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Sub Only'|| lineItem.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Ship & Entitle Only') {
                                        oDealStd.programId = 'WSTPR';
                                     }
                                     //End:GLP-183
                                  ordreq.CreateOrderRequest.OrderHeader.orderDeal.add(oDealStd); //add only standard bundle
                                   }else if(lineItem.Apttus_Config2__LineStatus__c != 'Amended' && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled'){
                                       relLineNumber +=1; //if wcmp line item
                                   }
                                   
                                   }
                                   if(isCorp){
                                   ordreq.CreateOrderRequest.OrderHeader.orderDeal.add(oDealCorp);
                                   }// add                       
            ordreq.CreateOrderRequest.OrderHeader.creditApproval=order.Apttus_QPConfig__ProposalId__r.APTS_Account_Credit_Risk_Category__c;
            ordreq.CreateOrderRequest.OrderHeader.numberOfAttorneys='0';
            numberOfAttorneys = '0'; //DOC-9689
            //SOC-3959 Pathra-Added to send owners Email to SAP
            ordreq.CreateOrderRequest.OrderHeader.orderRep.email = proposalOwner.email;
             //SOC-4222 Nov Release
             if(approvalNumber!=null){
             ordreq.CreateOrderRequest.OrderHeader.approvalNumber= approvalNumber;}
            //SOC-3963 Pathra-Added cost center value to esi field
            ordreq.CreateOrderRequest.OrderHeader.costCenter=order.Apttus_QPConfig__ProposalId__r.APTS_Cost_Center__c;
            if(order.APTS_Periodic_Value__c!=null){
            periodicValue=order.APTS_Periodic_Value__c; 
            }    
            List<SAP_Originating_System_Mapping__mdt> sapMapQuery = new List<SAP_Originating_System_Mapping__mdt>();
            //DLT-16201
            if(Schema.sObjectType.SAP_Originating_System_Mapping__mdt.isAccessible() && Schema.sObjectType.SAP_Originating_System_Mapping__mdt.isQueryable()){
           /* return null;
            }
            List<SAP_Originating_System_Mapping__mdt>*/ sapMapQuery = [SELECT Id,QuoteType__c,SAP_Originating_System__c,BusinessUnit__c from SAP_Originating_System_Mapping__mdt WHERE QuoteType__c =: order.Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c AND BusinessUnit__c =: order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c LIMIT 1];}
      
            //DOC-12198
            Boolean isKeepTermscheck=false;
            //Boolean isProflex=false;
            
            Integer countBundleList=0;
            Apttus_Config2__OrderLineItem__c proflexOrderLineItem=new Apttus_Config2__OrderLineItem__c();
            Map<String,List<Apttus_Config2__OrderLineItem__c>> mapBundleLineItems=new Map<String,List<Apttus_Config2__OrderLineItem__c>>();
            string grpName='';
           for(Apttus_Config2__OrderLineItem__c ordeline :orderLineItems)
            {
                APTS_OrderSubmissionUtility.setOAModeW(ordreq); //DOC-15125
                ordline = new CreateOrderRequest.orderLines();
                //grpName=ordeline.APTS_Group__c; 
                //Adding Bundle Changes
                //Add Dynamic Bundle code here, DOC-12198 header line item
                if(ordeline.Apttus_Config2__ProductId__r.ProductCode != null && System.Label.APTS_Proflex_Materials.contains(ordeline.Apttus_Config2__ProductId__r.ProductCode) 
                && hasDynamicBundle && ordeline.Apttus_Config2__LineStatus__c!='Renewed' && ordeline.Apttus_Config2__LineStatus__c!='Cancelled'){

                    
                //System.debug(LoggingLevel.WARN,'This has a bundle Line Item');
                isProflex=true; 
                proflexOrderLineItem=ordeline;
                countBundleList=countBundleList + 1;
                grpName=ordeline.APTS_Group__c;
                ordline.material.materialId=ordeline.Apttus_Config2__ProductId__r.ProductCode;
                    ordline.material.description=ordeline.Apttus_Config2__Description__c;
                    ordline.lineNumber=String.valueOf(lineNumber);
                    //skg added the following line for JIRA-3395
                    ordline.billOfMaterialsType='SON';
                    ordline.netAmount= ordeline.Apttus_Config2__NetPrice__c!=null ? ordeline.Apttus_Config2__NetPrice__c.setscale(5) : null;
                    ordline.listAmount= ordeline.Apttus_Config2__NetPrice__c != null ? ordeline.Apttus_Config2__NetPrice__c.setscale(5) : null;
                    ordline.quantity=1;
                    ordline.unitOfMeasure='EA'; 
                    ordline.keepTerms=ordeline.APTS_Keep_Terms__c; 
                    isKeepTermscheck=ordeline.APTS_Keep_Terms__c;
                    bundlePrimMaterial=ordeline.Apttus_Config2__ProductId__r.Productcode;
        //SOC-4367 Nov Changes
          if(order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=''){
            ordline.saID=order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c.substringAfter('(').remove(')');  
                    }
                // call method to assign the terms to order
  //skg                  orderTerms(dynamicbundle.APTS_Contract_Terms__c, null, dynamicbundle.APTS_YoY_2_Plus__c,dynamicbundle.APTS_YoY_1_Renewal__c,'');
                if(ordeline.Apttus_Config2__LineStatus__c=='Renewed'){
                        orderTerms(ordeline.APTS_Contract_Term__c, ordeline.Base_Value__c, ordeline.APTS_Years_2_Plus_Adjustment__c,
                            ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,
                        0.00,0,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c, isproflex);
                        
                }
                else if(ordeline.Apttus_Config2__LineStatus__c=='New'){
                    orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,
                    ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,
                    0.00,0.00,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c, isProflex);
                }
                else if(ordeline.Apttus_Config2__LineStatus__c=='Amended'){
                    orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,
                    ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,
                    0.00,0.00,0.00,0.00,0.00,0.00,ordeline.APTS_Is_Multi_Tiered_Pricing__c,0,0,0,0, isProflex);
                }
                //Bridge Details
                if(ordeline.APTS_New_Bridge_Discount__c  != null){
                        CreateOrderRequest.adjustments adjustment1 = new CreateOrderRequest.adjustments();
                        adjustment1.type ='PERCENT';
                        adjustment1.discountType='BridgeDiscount';//SOC-6755 May Bijeta
                        adjustment1.amount=ordeline.APTS_New_Bridge_Discount__c;
                        ordline.adjustments.add(adjustment1); 
                }
                //skg SOC-3454 program id
                 if(ordeline.APTS_Program_ID__c!='WCMP')
                {              
                        ordline.billPlanType='Monthly';
                        //system.debug(LoggingLevel.WARN,'########### 2');
                        
                }
                
                
                
                //Start: Added by Kruti Shah DOC-11650                                
                 if(ordeline.Apttus_QPConfig__ProposalId__r.APTS_Is_HighQ_Quote__c != null && 
                        ordeline.Apttus_QPConfig__ProposalId__r.APTS_Is_HighQ_Quote__c >0)
                {
                        if(ordeline.Apttus_Config2__BillingFrequency__c =='Yearly')
                        {
                             ordline.billPlanType='Yearly';
                        }
                        else
                        {
                            ordline.billPlanType='Monthly';
                        }       
                        //system.debug(LoggingLevel.WARN,'########### 3');             
                }                    
                //End: Added by Kruti Shah DOC-11650
  
                //SOC-3878
                if(ordeline.APTS_Program_ID__c=='WCMP'){
                    
                    //SOC-3962       
                       ordline.programId = ordeline.APTS_Program_ID__c;
                    if(ordeline.APTS_Keep_Terms__c==true && ordeline.APTS_Deal_Number__c!=null)
                        {
                            //For WCMP modification scenario
                           ordline.keepTerms=true;
                           ordline.amendmentFlag=true;
                           CreateOrderRequest.orderNotes bundlenote= new CreateOrderRequest.orderNotes();
                            bundlenote.notes='Program Id: '+ordeline.APTS_Program_ID__c+' Deal Number: '+ordeline.APTS_Deal_Number__c+' Modify';
                            ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(bundlenote); 
                            //SOC-5819
                            //isModeA=true; 
                            //Soc-5990
                            //ordreq.CreateOrderRequest.OrderHeader.oaMode='W'; //Commented as a part of DOC-15125
                            //isModeW=true;
                       
                        }
                        else if(ordeline.APTS_Keep_Terms__c!=true && ordeline.APTS_Deal_Number__c==null)
                        {
                            //For WCMP new scenario:Send in ordernotes – “New”
                            CreateOrderRequest.orderNotes bundlenote= new CreateOrderRequest.orderNotes();
                            bundlenote.notes='New';
                            ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(bundlenote); 
                            //SOC-5819
                            //ordreq.CreateOrderRequest.OrderHeader.oaMode='W'; //Commented as a part of DOC-15125
                            //isModeW=true; 
                        }
                    //SOC-5990
                    //Commented as a part of DOC-15125
                    /*else if(ordeline.APTS_Keep_Terms__c!=true && ordeline.APTS_Deal_Number__c!=null)
                    {
                                 //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                                 //isModeW=true; 
                    }*/
                }
                //SOC-5358                 
                if(ordeline.APTS_Program_ID__c == 'WCMP'){                    
                    //System.debug(LoggingLevel.WARN,'Inside');
                    CreateOrderRequest.orderDeal oDeal = new CreateOrderRequest.orderDeal();
                    Boolean primaryDeal = true;
                    relLineNumber = 2;// dynamicbundlelist.size() + 1;
                    oDeal.dealId = ''; //SOC-5910
                    Set<String> orderLineIds=new Set<String>();
                    for(Apttus_Config2__LineItem__c lineItem : lineItemList)
                        {                                                                       
                                if(lineItem.APTS_Group__c == ordeline.APTS_Group__c && primaryDeal && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled' &&                      
                                    lineItem.APTS_Program_ID__c == 'WCMP')
                                {
                                    dealSerialNumber += 1;
                                    dealLineNumber += 1;                                
                                    oDeal.programId = 'WCMP';
                                    //oDeal.dealId = string.valueOf(dynamicbundle.APTS_Deal_Number__c); - SOC-5910
                                    oDeal.startDate = Order.CreatedDate.format('yyyyMMdd');
                                    oDeal.endDate = DateTime.newInstance(9999, 12, 31).format('yyyyMMdd');
                                    if(orderLineIds.isEmpty()){
                                        Map<Decimal,Decimal> mapDecimalValues =new Map<Decimal,Decimal>();
                                        mapDecimalValues = APTS_OrderSubmissionUtilityExt1.returnDecimalMap(0,0,0);
                                        //oDeal.lineItems.add(assignDealLines(dealLineNumber,'PRI',0,0,0));
                                        oDeal.lineItems.add(APTS_OrderSubmissionUtilityExt1.assignDealLines(dealLineNumber,'PRI',mapDecimalValues));
                                        orderLineIds.add(lineItem .id);
                                    }oDeal.dealSerialNumber = String.valueOf(dealSerialNumber);                                
                                    primaryDeal = false; 
                                    //May release - actionCode SOC-5982
                                    if(lineItem.APTS_Deal_Type__c != 'WCMP' && lineItem.APTS_Deal_Type__c != null)
                                    {
                                        if(ordeline.APTS_Keep_Terms__c == false && ordeline.APTS_Deal_Number__c != null){
                                            oDeal.actionCode = 'NEW';}
                                    }else if(lineItem.APTS_Deal_Type__c == 'WCMP' || lineItem.APTS_Deal_Type__c == null){
                                        if(ordeline.APTS_Keep_Terms__c == false && ordeline.APTS_Deal_Number__c == null ){
                                            oDeal.actionCode = 'NEW';
                                    }else if(ordeline.APTS_Keep_Terms__c == true && ordeline.APTS_Deal_Number__c != null){
                                        oDeal.actionCode = 'MODIFY';
                                    }else if(ordeline.APTS_Keep_Terms__c == false && ordeline.APTS_Deal_Number__c != null){
                                        oDeal.actionCode = 'REPLACE';
                                    }
                                    }//May release - actionCode - ends SOC-5982 
                                }
                                if(lineItem.APTS_Group__c == ordeline.APTS_Group__c && primaryDeal==false && lineItem.Apttus_Config2__LineStatus__c == 'New' && 
                                    lineItem.APTS_Program_ID__c == 'WCMP' )
                                {
                                      if(!orderLineIds.contains(lineItem .id)) {
                                         Map<Decimal,Decimal> mapDecimalValues =new Map<Decimal,Decimal>();
                                       mapDecimalValues = APTS_OrderSubmissionUtilityExt1.returnDecimalMap(lineItem.APTS_Contract_Number__c,lineItem.APTS_Contract_Line_Number__c,0);
                                       //oDeal.lineItems.add(assignDealLines(relLineNumber,'SEC',lineItem.APTS_Contract_Number__c,lineItem.APTS_Contract_Line_Number__c,0)); 
                                       oDeal.lineItems.add(APTS_OrderSubmissionUtilityExt1.assignDealLines(relLineNumber,'SEC',mapDecimalValues));
                                       orderLineIds.add(lineItem.id); 
                                       relLineNumber += 1;
                                    } 
                                    //SOC-5910
                                    if(lineItem.APTS_Deal_Type__c == 'WCMP') {
                                    oDeal.dealId = string.valueOf(ordeline.APTS_Deal_Number__c); }                              
                                }
                                else if(lineItem.APTS_Group__c == ordeline.APTS_Group__c && lineItem.Apttus_Config2__LineStatus__c == 'Amended' && 
                                        lineItem.APTS_Program_ID__c == 'WCMP')
                                {    if(!orderLineIds.contains(lineItem .id)) {
                                        Map<Decimal,Decimal> mapDecimalValues =new Map<Decimal,Decimal>();
                                        mapDecimalValues = APTS_OrderSubmissionUtilityExt1.returnDecimalMap(lineItem.APTS_Contract_Number__c,lineItem.APTS_Contract_Line_Number__c,lineItem.Apttus_Config2__Quantity__c);
                                        //oDeal.lineItems.add(assignDealLines(0,'SEC',lineItem.APTS_Contract_Number__c,lineItem.APTS_Contract_Line_Number__c,lineItem.Apttus_Config2__Quantity__c));
                                        oDeal.lineItems.add(APTS_OrderSubmissionUtilityExt1.assignDealLines(0,'SEC',mapDecimalValues));
                                        orderLineIds.add(lineItem.id); 
                                    }
                                    //SOC-5910
                                    if(lineItem.APTS_Deal_Type__c == 'WCMP'){ 
                                    oDeal.dealId = string.valueOf(ordeline.APTS_Deal_Number__c);} 
                                } else if(lineItem.APTS_Program_ID__c != 'WCMP' && lineItem.Apttus_Config2__LineStatus__c != 'Amended' && lineItem.Apttus_Config2__LineStatus__c != 'Cancelled'){
                                    relLineNumber += 1;
                                } else if (lineItem.APTS_Group__c != ordeline.APTS_Group__c && lineItem.Apttus_Config2__LineStatus__c == 'New' && lineItem.APTS_Program_ID__c == 'WCMP') { 
                                      relLineNumber +=1;    
                                    }  
                                //System.debug(LoggingLevel.WARN,'Deal Size++'+oDeal.lineItems.size()) ;  
                        }   
                     ordreq.CreateOrderRequest.OrderHeader.orderDeal.add(oDeal);                       
                 } else{
                     //the counters should be incremented
                     dealLineNumber += 1;
                 }
                
                 //Soc-6446 June Bijeta
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
                    ordline.adjRnwlBaseValue= ordeline.APTS_Calculated_Year_1__c !=null ? String.valueOf((ordeline.APTS_Calculated_Year_1__c).setscale(2)) : null;
                }
                if(ordeline.APTS_New_Bridge_Discount__c!=null && ordeline.APTS_Bridge__c!=null)   
                {
                    ordline.listAmount= ordeline.APTS_Calculated_Year_1__c!=null ? ordeline.APTS_Calculated_Year_1__c.setscale(5) : null;
                    ordline.netAmount= ordeline.APTS_Bridge_Monthly_Charge__c!=null ? ordeline.APTS_Bridge_Monthly_Charge__c.setscale(5) : null;
                    //System.debug('ordline.netAmount : '+ordline.netAmount); 
                    //System.debug('ordline.listAmount : '+ordline.listAmount); 
                //skg CreateOrderRequest.terms term = new CreateOrderRequest.terms();
                //skg term.baseValue=dynamicbundle.APTS_Net_Price__c;
                //skg ordline.subscriptionDetail.terms.add(term);
                //skg ordline.netAmount=dynamicbundle.APTS_Net_Price__c - ((dynamicbundle.APTS_Net_Price__c * dynamicbundle.APTS_Bridge_Discount_Number__c/100));
                //ordline.netAmount=ordeline.APTS_Bridge_Monthly_Charge__c.setscale(5);
                }                                            
                //if(ordeline.APTS_New_Bridge_Discount__c!=null){
                //ordline.netamount=ordeline.Apttus_Config2__BasePrice__c- (ordeline.Apttus_Config2__BasePrice__c* (ordeline.APTS_New_Bridge_Discount__c/100)); 
                //}
                // Bridge Details ends                                       
                ordreq.CreateOrderRequest.orderLines.add(ordline);                
                CreateOrderRequest.orderNotes bundlenote= new CreateOrderRequest.orderNotes();
               bundlenote.notes='Group:'+ordeline.APTS_Group__c+'. Bundle Adjustment '+ordeline.Apttus_Config2__AdjustmentType__c+' : '+ordeline.Apttus_Config2__AdjustmentAmount__c+'.';                
                ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(bundlenote);
                //SOC-5819  
                //ordreq.CreateOrderRequest.OrderHeader.oaMode='A';
                //isModeA=true;  
                if(ordeline.APTS_Keep_Terms__c==true && ordeline.APTS_SAP_MLA_Agreement_Number__c!=null){
                    isMLAModify = true;
                     //ordreq.CreateOrderRequest.OrderHeader.oaMode='W'; //Commented as a part of DOC-15125
                    //isModeW=true;                        
                    }
                if(!ordeline.APTS_Keep_Terms__c && string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c)){
                isnotMLAModify = True;}             
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='W'; //Commented as a part of DOC-15125
                    //isModeW=true; 
                lineNumber+=1;
                ordline.referenceNumber = ordeline.Apttus_QPConfig__ProposalLineItemId__r.Name;
                //ordline.subscriptionDetail.contractStartDate=ordeline.Apttus_Config2__StartDate__c; DOC-15637
                ordline.subscriptionDetail.contractEndDate=ordeline.Apttus_Config2__EndDate__c;
                ordline.subscriptionDetail.subscriptionType=ordeline.Apttus_Config2__Type__c;
                }
                   
                //End of DOC-12198 changes FOR NEW AND AMENDED PROFLEX
                else{
                    
                if (!string.isEmpty(grpName)){
                     if(!mapBundleLineItems.isEmpty() && mapBundleLineItems.containsKey(grpName)) {
                                                  mapBundleLineItems.get(grpName).add(ordeline);    
                                              }
                                              else {
                                                  mapBundleLineItems.put(grpName, new List<Apttus_Config2__OrderLineItem__c> {ordeline});
                                              }
                }        
                //DOC-15023 
                if (ordeline.Apttus_Config2__ProductId__r.Family != null && ordeline.Apttus_Config2__ProductId__r.Family.equalsIgnoreCase(System.Label.Caseline_Product_Family)) {  
                    blnIsCaseLine = True;   
                }
                //System.debug('################# blnIsCaseLine '+blnIsCaseLine);
                //System.debug('################# APTS_Media_High_Level_Code__c '+ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c); 
                //System.debug('################# APTS_Media_Lower_Level_Code__c'+ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c);
                
                if (ordeline.Apttus_Config2__ProductId__r.Family != null && ordeline.Apttus_Config2__ProductId__r.Family.equalsIgnoreCase(System.Label.Pondera_Product_Family)) {  
                    blnIsPondera = True;   
                }
                    
                //SOC-3783 Sreenu changes Start
                if(ordeline.Apttus_Config2__LineStatus__c =='Cancelled' && isnotMLAModify && !string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c)
                    && materialNumberList.contains(ordeline.APTS_Service_Number__c)){
                    isMLAReplace = True;
                    //MLAAgreementNumber = ordeline.APTS_SAP_MLA_Agreement_Number__c;
                }
                //system.debug(LoggingLevel.WARN,'isMLAReplace...'+isMLAReplace);
                //SOC-3783 Sreenu changes End
                //SOC 5107
                 if(ordeline.APTS_One_time_value__c!=null){
                    oneTimeValue=oneTimeValue+ordeline.APTS_One_time_value__c; 
                }   
                //SOC-3835 && SOC-3839 start--
                if(ordeline.APTS_Service_Number__c=='41841757' && ordeline.Apttus_Config2__LineStatus__c=='Amended' ){
                edltProduct = false;
                }else{
                edltProduct = true;
                }
                if(isMLAModify == true && ordeline.Apttus_Config2__LineStatus__c=='Amended' && ordeline.Apttus_QPConfig__ProposalLineItemId__r.Net_Qty_Difference__c <=0 && !ordeline.APTS_is_Primary_in_Bundle__c){
                qtyChange = false;
                }else{
                qtyChange = true;
                }
                //end--
                //added OR condition for SOC-3494
                /*system.debug(LoggingLevel.WARN,'#### ordeline.Apttus_Config2__LineStatus__c'+ordeline.Apttus_Config2__LineStatus__c);
                system.debug(LoggingLevel.WARN,'#### isMLAModify '+isMLAModify );
                system.debug(LoggingLevel.WARN,'#### ordeline.APTS_Group__c '+ordeline.APTS_Group__c );
                system.debug(LoggingLevel.WARN,'#### QTYChange '+qtyChange );
                system.debug(LoggingLevel.WARN,'#### EDLTproduct '+edltProduct );
                System.debug(LoggingLevel.WARN,'### line Number'+lineNumber);*/
                if((ordeline.Apttus_Config2__LineStatus__c!='Cancelled' && ordeline.Apttus_Config2__LineStatus__c!='Existing' && ordeline.Apttus_Config2__LineStatus__c!='Amended' && !(isMLAModify && ordeline.Apttus_Config2__LineStatus__c=='Renewed')) || 
                (isMLAModify && ordeline.Apttus_Config2__LineStatus__c=='Amended' && !string.isEmpty(ordeline.APTS_Group__c) && ( ordeline.APTS_is_Primary_in_Bundle__c || OnlineContactsController.validateProductLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, System.Label.OCPerSeatLowerLevelCodes) || 
                    (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '21') ||
                    (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'I9')))&& qtyChange == true && edltProduct == true){      
                //MYR
                if(ordeline.APTS_Program_ID__c=='CPRO' && ordeline.Apttus_QPConfig__ProposalLineItemId__c!=null && ordeline.Apttus_QPConfig__ProposalLineItemId__r.APTS_Service_Number_Override__c!=null ){
                    materialMap.put(ordeline.Apttus_QPConfig__ProposalLineItemId__r.APTS_Service_Number_Override__c, lineNumber);
                    }
                else{
                    if(ordeline.Apttus_Config2__ProductId__c!=null && ordeline.Apttus_Config2__ProductId__r.ProductCode!=null){
                    materialMap.put(ordeline.Apttus_Config2__ProductId__r.ProductCode, lineNumber);}
                    }
                materialBrandCodeMap.put(ordeline.Apttus_Config2__ProductId__r.ProductCode, ordeline.Apttus_Config2__ProductId__r.Apttus_Filter_Brand_Code__c);                
                //ordline = new CreateOrderRequest.orderLines();
                //roma start
                List<CreateOrderRequest.naicData> naicDataList = new List<CreateOrderRequest.naicData>();
                //system.debug(LoggingLevel.WARN,'olcNAICMap : ' + olcNAICMap);
                //system.debug(LoggingLevel.WARN,'ordeline.Apttus_Config2__ProductId__r.ProductCode : ' + ordeline.Apttus_Config2__ProductId__r.ProductCode);
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
                    //ordline.subscriptionDetail.contractStartDate=ordeline.Apttus_Config2__StartDate__c; DOC-15637
                    ordline.subscriptionDetail.contractEndDate=ordeline.Apttus_Config2__EndDate__c;
                    ordline.subscriptionDetail.subscriptionType=ordeline.Apttus_Config2__Type__c;
                      
                      //SOC 3961
                    /*ordline.brandName=order.Apttus_QPConfig__ProposalId__r.APTS_Print_Branding__c; */
                    //commented for SOC 4367
                    /*if(order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=''){
                    ordline.saID=order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c.substringAfter('(').remove(')');  
                    }*/
                    //DOC-15637
                    if (blnIsCaseLine && ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'PQ' && ordeline.APTS_Term_Type__c == 'Future Start Date' && String.isBlank(ordeline.APTS_Group_Primary_Material__c)) {    
                        ordline.subscriptionDetail.contractStartDate=ordeline.APTS_Start_Date__c; 
                    }       
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
                    if((ordeline.APTS_GROUP__c!=null || (ordeline.APTS_GROUP__c==null && ordeline.Apttus_Config2__ProductId__r.ProductCode != null && System.Label.APTS_Proflex_Materials.contains(ordeline.Apttus_Config2__ProductId__r.ProductCode)) || ordeline.Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c == True)&& (ordeline.Apttus_Config2__LineType__c!='Option' && ordeline.APTS_Program_ID__c!='CPRO') || (ordeline.Apttus_Config2__LineType__c=='Product/Service' && ordeline.APTS_Program_ID__c=='CPRO')){  
                        if(ordeline.Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c == True|| (ordeline.Apttus_Config2__LineType__c=='Product/Service' && ordeline.APTS_Program_ID__c=='CPRO'))    //DOC-1526
                        {orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,ordeline.APTS_Prorate_base_Value__c,0,0,0,0,0,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c, true);}  
                    else{orderTerms(ordeline.APTS_Contract_Term__c, 0, ordeline.APTS_Years_2_Plus_Adjustment__c,ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,ordeline.APTS_Prorate_base_Value__c,0,0,0,0,0,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c, isProflex);}
                    }
                    // skg added the or statement in the following to include cpro pseudo item SOC-3407
                    else if(ordeline.APTS_GROUP__c==null && !(ordeline.Apttus_Config2__ProductId__r.ProductCode != null && System.Label.APTS_Proflex_Materials.contains(ordeline.Apttus_Config2__ProductId__r.ProductCode)) && (ordeline.Apttus_Config2__LineType__c!='Option' && ordeline.APTS_Program_ID__c!='CPRO') || (ordeline.Apttus_Config2__LineType__c=='Product/Service' && ordeline.APTS_Program_ID__c=='CPRO')){
                    orderTerms(ordeline.APTS_Contract_Term__c, ordeline.Base_Value__c, ordeline.APTS_Years_2_Plus_Adjustment__c,ordeline.APTS_Yr_1_Renewal_Adjustment__c,ordeline.Apttus_Config2__LineStatus__c, ordeline.APTS_Term_Type__c,ordeline.APTS_Prorate_base_Value__c,ordeline.APTS_Calculated_Year_1__c,ordeline.APTS_Calculated_Year_2__c,ordeline.APTS_Calculated_Year_3__c,ordeline.APTS_Calculated_Year_4__c,ordeline.APTS_Calculated_Year_5__c,ordeline.APTS_Is_Multi_Tiered_Pricing__c,ordeline.APTS_Increase_Yr1_Yr2__c,ordeline.APTS_Increase_Yr2_Yr3__c,ordeline.APTS_Increase_Yr3_Yr4__c,ordeline.APTS_Increase_Yr4_Yr5__c,isProflex);
                    }
                   
                    if(order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'FindLaw')
                    {
                        ordreq.CreateOrderRequest.ESIHeader.applicationId='SF05';
                    }
                    else
                    {
                        ordreq.CreateOrderRequest.ESIHeader.applicationId='SF04';
                    }
                                       
                    // DLT-13620 and DLT-16201
                    if( !sapMapQuery.isEmpty() && order.Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c == 'New Sales')
                    {                               
                       ordreq.CreateOrderRequest.ESIHeader.applicationId = sapMapQuery[0].SAP_Originating_System__c;
                    } 
                    else if((!sapMapQuery.isEmpty() && order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'FindLaw' && order.Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c == 'New Sales')||(!sapMapQuery.isEmpty() && order.Apttus_QPConfig__ProposalId__r.APTS_Proposal_Business_Unit__c == 'Corp OneOTC US' && order.Apttus_QPConfig__ProposalId__r.Digital_Quote_Type__c == 'New Sales'))
                    {
                      ordreq.CreateOrderRequest.ESIHeader.applicationId = sapMapQuery[0].SAP_Originating_System__c;
                    }
                    
                    //SOC-8627 - PATRON,CORRECTIONAL Info
                    String prodName = ordeline.Apttus_Config2__ProductId__r.Name;
                    if(!String.isEmpty(prodName) && prodName.containsIgnoreCase('patron')){
                        ordline.material.productAccessType = 'PATRON';
                    }else if(!String.isEmpty(prodName) && (prodName.containsIgnoreCase('correctional') || prodName.containsIgnoreCase('corr'))){
                        ordline.material.productAccessType = 'CORRECTIONAL';
                    }
                        ordreq.CreateOrderRequest.ESIHeader.transactionId='WEST';
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
                        
                if((!dynamicbundlelist.isEmpty() || isProflex) && !string.isEmpty(bundlePrimMaterial)){
                       if(!ordeline.APTS_is_Primary_in_Bundle__c){
                        ordline.lineNumber=String.valueOf(lineNumber);}
                        if(ordeline.APTS_Program_ID__c=='CPRO' && ordeline.Apttus_QPConfig__ProposalLineItemId__c!=null && ordeline.Apttus_QPConfig__ProposalLineItemId__r.APTS_Service_Number_Override__c!=null){
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
                }
                        ordline.quantity=ordeline.Apttus_Config2__Quantity__c != null ? ordeline.Apttus_Config2__Quantity__c.setscale(3) : null;                        
                              
                    if(OnlineContactsController.validateProductLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, System.Label.OCBandedLowerLevelCodes) == true){                
                        ordreq.CreateOrderRequest.OrderHeader.numberOfAttorneys=string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                        numberOfAttorneys = string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0)); //DOC-9689
                        ordline.quantity=1;
                        
                    }
                    if((ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='06' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='OA') || (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='LO')){ //SOC-8627
                        ordline.quantity=1;
                        ordline.priceQuantity =string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                    }
                    if(ordeline.Apttus_Config2__AttributeValueId__r.APTS_Pricing_Quantity__c!=null && ((ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && (ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='NZ' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='NX' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='NT' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='NW')) || (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='05' && (ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='NZ' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='E9' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='')) || (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='06' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='AB'))){
                        ordline.priceQuantity =string.valueof(ordeline.Apttus_Config2__AttributeValueId__r.APTS_Pricing_Quantity__c);
                    }
                    
                    System.debug('Media Codes '+ordeline.Apttus_Config2__ProductId__r.APTS_Cat_L2__c+' '+ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c+' '+ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c);
                    if(ordeline.Apttus_Config2__ProductId__r.Family == 'PONDERA' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='PQ' && (ordeline.Apttus_Config2__ProductId__r.Apttus_Config2__Uom__c=='INPUTS' || ordeline.Apttus_Config2__ProductId__r.Apttus_Config2__Uom__c== 'Users')){
                        ordline.priceQuantity =string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                        ordline.quantity=1;
                    }
                    
                    if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9'){
                        ordreq.CreateOrderRequest.OrderHeader.numberOfAttorneys=null;
                        numberOfAttorneys = ''; //DOC-9689
                        ordline.quantity=ordeline.Apttus_Config2__Quantity__c.setscale(0);
                    }
                     if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='06' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9'){
                        ordreq.CreateOrderRequest.OrderHeader.numberOfAttorneys=string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                        numberOfAttorneys = string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0)); //DOC-9689
                        ordline.quantity=1;
                    }

                    
                    //billOfMaterialsType based on Media code
                    if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c!=null && ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c!=''){
                        if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='07' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='F4'){
                            ordline.billOfMaterialsType='SON';
                        }
                        
                         else if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='05' && (ordeline.Apttus_Config2__ProductId__r.Family != 'RISK SOLUTIONS' || (ordeline.Apttus_Config2__ProductId__r.Family == 'RISK SOLUTIONS' && ordeline.Apttus_Config2__PriceType__c != 'One Time'))){
                            ordline.billOfMaterialsType='SON';
                        }
                         else if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='06'){
                            ordline.billOfMaterialsType='SON';
                        }
                        else if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ((!blnIsCaseLine || (blnIsCaseLine && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'PQ')) && (!blnIsPondera || (blnIsPondera && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'PQ')))
                         && (ordeline.Apttus_Config2__ProductId__r.Family != 'ACRITAS' || (ordeline.Apttus_Config2__ProductId__r.Family == 'ACRITAS' && ordeline.Apttus_Config2__PriceType__c != 'One Time'))){ //DOC-15023
                            ordline.billOfMaterialsType='SON';
                        }
                        //DOC-15023
                        if ((blnIsCaseLine || blnIsPondera)&& (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='26' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13') && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='') {
                            ordline.billOfMaterialsType='';
                        }
                        //Start: GLP -230 Jinal Bhatt
                        if (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '21' 
                            && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'CQ') {
                            ordline.itemCategory='ZGR2';
                            ordline.quantity=1;
                            ordline.priceQuantity =string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                            ordline.unitOfMeasure='EA'; 
                            isGLPProduct = True; //GLP -230
                        }
                        //End
                        
                      }
                      //system.debug('#########33blnIsCaseLine'+blnIsCaseLine);
                      ordline.billPlanType=ordeline.Apttus_Config2__SellingFrequency__c; 
                       //system.debug(LoggingLevel.Warn,'attribute value in orderqueue'+ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c);
                    //billOfMaterialsType based on purchase option                    
                  if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!=null && ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!='' && !isProflexBLI){                        
                    if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship & Enter Sub'){                 
                        //SOC-4845
                        //as per Ravali
                        if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR')){
                        ordline.billPlanType='Monthly';
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            //New
                            if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0){
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c !=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;}
                            }
                        ordline.billOfMaterialsType='SES';
                        //Sreenu Changes SOC-3371
                        //assignOrderLineitemCategory(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, ordeline.Apttus_Config2__BillingFrequency__c, ordeline.APTS_Program_ID__c);      
                        APTS_OrderSubmissionUtilityExt2.assignOrderLineitemCategory(new Map<String, String>{'icGroup'=>ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c,'billFrequency'=>ordeline.Apttus_Config2__BillingFrequency__c,'programId'=>ordeline.APTS_Program_ID__c},ordline);
                        }
                    }
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Sub Only'){
                        //SOC-4845
                        //as per ravali
                        //ZPAL , ZPSC and ZSHP conditions are included by priyanka
                        if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPAL'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPSC'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZSHP'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR')){                         
                        ordline.billPlanType='Monthly';
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            //New
                            if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0){
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;}
                            }
                        ordline.billOfMaterialsType='SON';
                        //Sreenu Changes SOC-3371
                        //assignOrderLineitemCategory(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c, ordeline.Apttus_Config2__BillingFrequency__c, ordeline.APTS_Program_ID__c);
                        APTS_OrderSubmissionUtilityExt2.assignOrderLineitemCategory(new Map<String, String>{'icGroup'=>ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c,'billFrequency'=>ordeline.Apttus_Config2__BillingFrequency__c,'programId'=>ordeline.APTS_Program_ID__c},ordline);
                    }    
                    }
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship Only'){
                        ordline.billOfMaterialsType='SHO';
                        }
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up'){
                        ordline.billOfMaterialsType='FUP';      
                        }
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship & Enter Sub APP'){
                        //SOC-4845
                        //ordline.billPlanType='Monthly';  - as per ravali 
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            //New
                            if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0){
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ?(ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;}
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
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            //New
                            if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0){
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;}
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
                         ordline.billOfMaterialsType='SES';
                         //GLP-913
                    }                 
                    
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.eBook_Purchase_Options__c=='Entitle and Charge'){                       
                         ordline.billOfMaterialsType='SES';
                         //GLP-913
                    }
                      if(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c=='ZPMT')
                      {
                        ordline.itemCategory='ZGRP';
                      }
                      
                    }
                    //GLP-183
                    if  (ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'F4' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '21' &&
                        ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPR2' && ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c !=null) {
                        if (ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Ship & Entitle - APP') {
                            if (ordeline.Apttus_Config2__BillingFrequency__c != null && ordeline.Apttus_Config2__BillingFrequency__c == 'Monthly') {
                                ordline.itemCategory='ZGR2';
                                ordline.programId = 'WSTPRM';
                            } else {
                                ordline.itemCategory='';
                                ordline.programId = 'WSTPR';
                            } 
                            ordline.billOfMaterialsType = 'SES';
                            ordline.bundleType = True;
                        } else if (ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Ship & Entitle Sub') {
                            ordline.itemCategory='';
                            ordline.billOfMaterialsType = 'SES';
                            ordline.programId = 'WSTPR';
                            ordline.bundleType = True;
                        } else if (ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Sub Only APP') {
                            if (ordeline.Apttus_Config2__BillingFrequency__c != null && ordeline.Apttus_Config2__BillingFrequency__c == 'Monthly') {
                                ordline.itemCategory='ZGR2';
                                ordline.programId = 'WSTPRM';
                            } else {
                                ordline.itemCategory='';
                                ordline.programId = 'WSTPR';
                            } 
                            ordline.billOfMaterialsType = 'SON';
                            ordline.bundleType = True;
                        } else if (ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Sub Only') {
                            ordline.itemCategory='';
                            ordline.billOfMaterialsType = 'SON';
                            ordline.programId = 'WSTPR';
                            ordline.bundleType = True;
                        } else if (ordeline.Apttus_Config2__AttributeValueId__r.Purchase_Option_Bundle_Print__c == 'Ship & Entitle Only') {
                            ordline.itemCategory='';
                            ordline.billOfMaterialsType = 'SHO';
                            ordline.programId = 'WSTPR';
                            ordline.bundleType = True;
                        }
                    }
                    //End GLP-183
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
                            //system.debug('############## in');                          
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c).setscale(5) : null;
                            }
                            fillupadjustment= new CreateOrderRequest.adjustments();
                            fillupadjustment.type='PERCENT';
                            fillupadjustment.amount=ordeline.Apttus_Config2__AdjustmentAmount__c != null ? 
                                                    (ordeline.Apttus_Config2__AdjustmentAmount__c).setScale(9)
                                                    :ordeline.Apttus_Config2__AdjustmentAmount__c ; //DOC-5742
                            ordline.adjustments.add(fillupadjustment); 
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            //New
                            if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0){
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;}
                            }
                            //} - as per Ravali
                            
                            oli = ordeline;
                            isSubFee = True; 
                            if(lineNumber != 1) {
                                lineNumber+=1;
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
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c).setscale(5) : null ;     
                            lineNumber+=1;
                            fillupLineNumber +=1;
                            isSubFee = False;
                        }
                        else if(ordeline.Apttus_Config2__ChargeType__c == 'Standard Price' && ordeline.Apttus_Config2__PriceType__c == 'One Time' && ordeline.Apttus_Config2__LineType__c == 'Product/Service') {
      
                            fillupadjustment= new CreateOrderRequest.adjustments();
                            fillupadjustment.type='PERCENT';
                            fillupadjustment.amount=ordeline.Apttus_Config2__AdjustmentAmount__c != null ? 
                                                    (ordeline.Apttus_Config2__AdjustmentAmount__c).setScale(9)
                                                    :ordeline.Apttus_Config2__AdjustmentAmount__c ; //DOC-5742
                            ordline.material.materialId=ordeline.Apttus_Config2__ProductId__r.ProductCode ;                    
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c).setscale(5) : null;
                            //SOC-4845 need to verify fill & entersub scenario
                           /* if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            ordline.netAmount=(ordeline.Apttus_Config2__NetPrice__c/12).setscale(5);
                            }*/
                            ordline.noBomExplosion = 'X';
                            lineNumber+=1;
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
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c).setscale(5) : null;
                            //SOC-4845
                            if(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly'){
                            //New
                            if(ordeline.Apttus_Config2__NetPrice__c!=null&&ordeline.Apttus_Config2__NetPrice__c!=0){
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c/12).setscale(5) : null;}
                            }
                            fillupadjustment= new CreateOrderRequest.adjustments();
                            fillupadjustment.type='PERCENT';
                            fillupadjustment.amount=ordeline.Apttus_Config2__AdjustmentAmount__c != null ? 
                                                    (ordeline.Apttus_Config2__AdjustmentAmount__c).setScale(9)
                                                    :ordeline.Apttus_Config2__AdjustmentAmount__c ; //DOC-5742
                            ordline.adjustments.add(fillupadjustment); 
                            if(lineNumber != 1) {
                            lineNumber+=1;
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
                        }
                    
                    }
                    // Fill-Up Validations
                    
                    else if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up'){
                        isFillupOnly = True;
                        if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up' && ordeline.Apttus_Config2__ChargeType__c == 'Standard Price' && ordeline.Apttus_Config2__PriceType__c == 'One Time' && ordeline.Apttus_Config2__LineType__c == 'Product/Service') {
                            fillupadjustment= new CreateOrderRequest.adjustments();
                            fillupadjustment.type='PERCENT';
                            fillupadjustment.amount=ordeline.Apttus_Config2__AdjustmentAmount__c != null ? 
                                                    (ordeline.Apttus_Config2__AdjustmentAmount__c).setScale(9)
                                                    :ordeline.Apttus_Config2__AdjustmentAmount__c ; //DOC-5742
                                                    
                            //ordline.adjustments.add(fillupadjustment);
                        }
                        if(ordeline.Apttus_Config2__ChargeType__c == 'Standard Price' && ordeline.Apttus_Config2__PriceType__c == 'One Time' && ordeline.Apttus_Config2__LineType__c == 'Option') {
                            ordline.material.materialId=ordeline.Apttus_Config2__OptionId__r.ProductCode ;                    
                            ordline.netAmount=ordeline.Apttus_Config2__NetPrice__c!=null ? (ordeline.Apttus_Config2__NetPrice__c).setscale(5) : null;
                            ordline.adjustments.add(fillupadjustment);                             
                            isFillupOption = True;                            
                            /*if(lineNumber != 1) {
                                lineNumber+=1;
                            } */  
  
                        }
                    }
  
                    //Bridge details
                    if(ordeline.APTS_New_Bridge_Discount__c!=null){
                        //ordline.netAmount=ordeline.bridge_net_price__c;
                        ordline.netAmount=ordeline.APTS_Bridge_Monthly_Charge__c!=null ? ordeline.APTS_Bridge_Monthly_Charge__c.setscale(5) : null; //DOC-15134, 15135
                    }  
                        //SOC-4845
                        //Ravali
                    if(vRiskRIProfessionalServices!=null && vRiskRIProfessionalServices!='' && 
                        ordline.material.materialId!=null && ordline.material.materialId!='' && 
                        vRiskRIProfessionalServices.contains(ordline.material.materialId)){
                        ordline.netAmount=0;
                    }
                       //if((ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!='Ship & Enter Sub')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Sub Only')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship & Enter Sub APP')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Sub Only APP')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub')&&(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub APP'))                 
                        if(ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c != 'ZPMT' && ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c !='ZPAV' && ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c !='ZBAR' && !blnIsCaseline){
                        ordline.billPlanType=ordeline.Apttus_Config2__SellingFrequency__c;
                        //system.debug('########### 1');
                        }
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
                    //Changed
                    if(ordline.billPlanUpdateRule!=null){
                        //ordline.adjRnwlBaseValue=String.valueOf(ordeline.APTS_Calculated_Year_1__c);
                        ordline.adjRnwlBaseValue= ordeline.APTS_Calculated_Year_1__c !=null ? String.valueOf((ordeline.APTS_Calculated_Year_1__c).setscale(2)) : null;
                    }
                }
                 //SOC-5992                
                if(ordeline.Apttus_Config2__LineStatus__c=='New'){
                   if(ordeline.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c !=null)
                    {
                       ordline.programId = 'SEAT';                       
                    }       
                   else if (ordeline.Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c ==True ){
                           ordline.bundleType=true;                       
                       if((ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='06' &&(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='I9' ||ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='LW'))||
                           (APTS_OrderSubmissionUtilityExt2.validateMLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, System.Label.APTS_MLLCodes_CPRO))){                           
                           ordline.programId = 'CPRO';}
                                
                       else if ((ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='06' && (APTS_OrderSubmissionUtilityExt2.validateMLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c,System.Label.APTS_MLLCodes_06SEAT)))|| 
                           (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='13' && (APTS_OrderSubmissionUtilityExt2.validateMLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c,System.Label.APTS_MLLCodes_13SEAT)))||
                           (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='05' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c =='E2')){
                           ordline.programId = 'SEAT';   }                 
                       
                          } 
                     }
                
                    //Renewals
                if(ordeline.Apttus_Config2__LineStatus__c=='Renewed'){
                        ordline.itemCategory='ZRNW';
                         
                    }                   
                 //FTE changes - SOC-8627                 
                    if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '06' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'LW'){
                        ordline.unitOfMeasure='FTE';
                    }else{
                        ordline.unitOfMeasure='EA';
                    } //FTE ends
                    
                if(ordeline.APTS_Group__c==null){
                    //SOC-5909 ELS Fix
                    //MCL-1976
                    ordline.listAmount=ordeline.Apttus_Config2__ListPrice__c != null ? ordeline.Apttus_Config2__ListPrice__c.setscale(5) : null;                        
                    //ordline.listAmount=ordeline.Apttus_Config2__ListPrice__c.setscale(5); 
                      //SOC-4845
                      /*if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR') && ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub' && ordeline.Apttus_Config2__LineType__c == 'Option'){
                               ordline.listAmount=0;
                               }*///as per ravali
                               if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPAL')&&(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly')){
                                //New
                            if(ordeline.Apttus_Config2__ListPrice__c!=null&&ordeline.Apttus_Config2__ListPrice__c!=0){
                            
                            ordline.listAmount=ordeline.Apttus_Config2__ListPrice__c!=null ? (ordeline.Apttus_Config2__ListPrice__c/12).setscale(5) : null;
                            
                            }
                             } //as per Ravali - SOC-4845
                            if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR') && ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub' && ordeline.Apttus_Config2__LineType__c == 'Product/Service' &&(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly')){
                               if(ordeline.Apttus_Config2__ListPrice__c!=null&&ordeline.Apttus_Config2__ListPrice__c!=0){
                            
                            ordline.listAmount=ordeline.Apttus_Config2__ListPrice__c!=null ? (ordeline.Apttus_Config2__ListPrice__c/12).setscale(5) : null;
                            
                            }
                               }
                            if((ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c == 'ZPMT'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZPAV'||ordeline.Apttus_Config2__ProductId__r.APTS_Item_Category_Group__c =='ZBAR') && ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c!='Fill-Up & Enter Sub'&&(ordeline.Apttus_Config2__BillingFrequency__c=='Yearly')){
                               if(ordeline.Apttus_Config2__ListPrice__c!=null&&ordeline.Apttus_Config2__ListPrice__c!=0){
                            
                            ordline.listAmount= ordeline.Apttus_Config2__ListPrice__c!=null ? (ordeline.Apttus_Config2__ListPrice__c/12).setscale(5) : null;
                            
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
                            //Added as part of DOC-13773
                            if(ordline.billPlanType == 'One Time' || ordline.billPlanType == '' || (blnIsCaseLine || blnIsPondera)){
                                if(ordeline.Apttus_Config2__PriceMethod__c == 'Per Unit' || blnIsCaseLine){
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
                        vRiskRIProfessionalServices.contains(ordline.material.materialId)) {
                        ordline.listAmount=0;
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
                        else{
                                adjustment.amount=ordeline.Apttus_Config2__AdjustmentAmount__c != null ? 
                                (ordeline.Apttus_Config2__AdjustmentAmount__c).setScale(9)
                                :ordeline.Apttus_Config2__AdjustmentAmount__c ; //DOC-5742
                            }
                    }
                    
                    else if(ordeline.Apttus_Config2__AdjustmentType__c=='% Markup' || ordeline.Apttus_Config2__AdjustmentType__c=='Price Override')
                    {
                          adjustment.type='FIXED_MARKUP';
                          adjustment.discountType='NormalSurcharge';//SOC-6755 May Bijeta
                          //Soc- 3559 changes//SOC-4238
                        if(vRiskRIProfessionalServices != null && vRiskRIProfessionalServices != '' && ordline.material.materialId != null && ordline.material.materialId != '' && vRiskRIProfessionalServices.contains(ordline.material.materialId)){
                            adjustment.amount = 0;
                        }else{
                          adjustment.amount=((ordeline.Apttus_Config2__AdjustedPrice__c-ordeline.Apttus_Config2__BaseExtendedPrice__c)).setScale(2);
                        }
                        }
                    if(ordeline.APTS_New_Bridge_Discount__c!=null){
                        // value is overiding so created new instance of adjustments
                        CreateOrderRequest.adjustments adjustment1 = new CreateOrderRequest.adjustments();
                        //SOC-3691 SKG
                        //adjustment1.type = adjustment.type;
                        adjustment1.type='PERCENT';
                        adjustment1.discountType='BridgeDiscount';//SOC-6755 May Bijeta
                        adjustment1.amount=ordeline.APTS_New_Bridge_Discount__c;
                        ordline.adjustments.add(adjustment1);                                          
                    }
                    
                }
                //SOC-8352
                    adjustment.promotionCode=ordeline.Apttus_Config2__IncentiveCode__c;
                    ordline.adjustments.add(adjustment);                    
                //SOC-5819 comment mode A
                //ordreq.CreateOrderRequest.OrderHeader.oaMode='A';
                //Soc3464 Included If condition for LMA products
                //Commented as a part of DOC-15125
                /*List<String> lsSCSPrintPrimary = new List<String>();
                lsSCSPrintPrimary =vSCSPrintPrimary.split(',');
                 if(lsSCSPrintPrimary .contains(ordeline.Apttus_Config2__ProductId__r.ProductCode)){
                    ordreq.CreateOrderRequest.OrderHeader.oaMode='A';
                    isModeA=true;
                }*/
                //Soc-3625 start---
                if(order.APTS_SSD_Sold_To__r.LCRM_Customer_Group__c=='FEDERAL GOVERNMENT' && ordeline.APTS_Group__c==null){
                     if(ordreq.CreateOrderRequest.OrderHeader.oaMode!='E_SO'){
                         ordreq.CreateOrderRequest.OrderHeader.oaMode='E';
                     }
                     if(ordeline.Apttus_Config2__ProductId__r.ProductCode==vSCSSpecialOffer1){
                       //system.debug(LoggingLevel.WARN,'WN loop');
                       ordreq.CreateOrderRequest.OrderHeader.oaMode='E';
                       wnProduct=true;
                       
                    }
                    else if(ordeline.Apttus_Config2__ProductId__r.ProductCode==vSCSSpecialOffer2){
                       ordreq.CreateOrderRequest.OrderHeader.oaMode='E_SO';
                       //system.debug(LoggingLevel.WARN,'spl loop');
                       if(wnProduct==true){
                       //system.debug(LoggingLevel.WARN,'both');
                        ordreq.CreateOrderRequest.OrderHeader.oaMode='E';
                       }
                    } 
                } 
                //soc-3625 end---    
                //SOC-3958 removing condition to check dollar value from if condition ordeline.Apttus_Config2__OrderId__r.APTS_Order_Value__c<2000                  
                //SOC-5819 Adding OR condition starting with ordeline.APTS_Group__c ==Null//SOC-5990 Removing Line Status New
                //Modifying Else if SOC-5991, DOC-15023
                /*else if(((ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='07' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='21' ||(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='08'&& 
                ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='73') || (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='08'&& ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='75') ||(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='08'&& ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='38'))&& 
                ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c!='06' && ordeline.Apttus_Config2__LineStatus__c!='Cancelled' && ordeline.APTS_Group__c==null)||ordeline.APTS_Program_ID__c =='WCMP' ||
                ((ordeline.APTS_Group__c ==Null &&(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='05' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='06' ||ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='13')) && ordeline.Apttus_Config2__ProductId__r.APTS_Standard_Bundle__c ==False && ordeline.Apttus_Config2__ProductId__r.APTS_Corporate_Select__c ==null)){ */
                  /*else if((ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='07' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='21' ||(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='08'&& ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='73') || (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='08'&& ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='75') ||(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='08'&& ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='38'))
                || ordeline.APTS_Program_ID__c=='WCMP'||
                (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='05' || ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='06' ||ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='13' ||(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c =='26' && (ordeline.Apttus_Config2__ProductId__r.Family == 'RISK SOLUTIONS' || ordeline.Apttus_Config2__ProductId__r.Family == 'ACRITAS' || 
                blnIsCaseLine)))){ */ //Commented as a part of DOC-15125
                    //System.debug(LoggingLevel.WARN,'%%%%oamodew'+ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c);
                    //SOC-3958 commented the if condition-Pathra
                    /*If( 
                    ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship & Enter Sub' || ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Sub Only' || ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship Only' || ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up & Enter Sub' || ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Fill-Up'){*/
                        //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';
                        //isModeW=true;
                         //System.debug(LoggingLevel.WARN,'%%%%oamodew12'+ordeline.Id);
                    
                   /* if(ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Ship & Enter Sub APP' ||ordeline.Apttus_Config2__AttributeValueId__r.SCS_Print_Purchase_Options__c=='Sub Only APP'){
                        //System.debug('%%%%oamodew12'+ordeline.Id);
                        isModeA=true;                          
                    }*/      
                /*}
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
                else if(ordeline.APTS_Group__c==null && ((!dynamicbundlelist.isEmpty() && !string.isEmpty(dynamicbundlelist[0].APTS_Bundle_Primary_Material__c)) || isProflex)   && ordeline.Apttus_Config2__LineType__c != 'Option' ){
                    CreateOrderRequest.orderNotes orderNote2= new CreateOrderRequest.orderNotes();
                    orderNote2.notes='stand alone Material:'+ordeline.Apttus_Config2__ProductId__r.ProductCode+'.';
                    ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(orderNote2);
                
                }
                
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
                    }
                }
                 else If(isFillupOnly && isFillupOption) {                    
                    ordline.lineNumber= string.valueof(lineNumber);
                    ordreq.CreateOrderRequest.orderLines.add(ordline);                    
                    if(!ordeline.APTS_is_Primary_in_Bundle__c){                         
                    lineNumber+=1;}     
                }
                
                else If(!isFillupOnly && !isFillup){                
                    ordreq.CreateOrderRequest.orderLines.add(ordline);                    
                     if(!ordeline.APTS_is_Primary_in_Bundle__c){                        
                    lineNumber+=1;}
                }
                        
                        // Added by Chintan - billOfMaterialsType should be blank for HighQ 'One Time' products
                        //Added Cat L2 field By Poonam garg DOC 12648
                        if(ordeline.Apttus_Config2__ProductId__c != null && 
                           ordeline.Apttus_Config2__ProductId__r.APTS_Cat_L2__c!= null && 
                           ordeline.Apttus_Config2__ProductId__r.APTS_Cat_L2__c.equalsIgnoreCase(Label.APTS_HighQ_Product_Family))
                        {
                            ordline.billPlanType = ordeline.Apttus_Config2__BillingFrequency__c;
                            if(ordeline.Apttus_Config2__PriceType__c.equalsIgnoreCase('One Time'))
                            {
                                ordline.billOfMaterialsType='';
                            }
                            if(ordeline.Apttus_Config2__ProductId__r.APTS_Product_Pricing_Model__c.equalsIgnoreCase('HighQ SubPrice Quantity'))
                            {
                                ordline.priceQuantity = String.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));
                                ordline.quantity=1;
                            }
                        }
                        //DOC-15633
                        if (blnIsCaseLine && ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'PQ') {
                            ordline.billPlanType = ordeline.Apttus_Config2__BillingFrequency__c;
                            //system.debug('########### 1');
                        }
                }
                
                                   
                
                //SOC-4367 Nov Changes
                if(order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c!=''){
                    ordline.saID=order.Apttus_QPConfig__ProposalId__r.APTS_SA_ID__c.substringAfter('(').remove(')');  
                }
            }//DOC-12198
            }  
            //Commented oaMode A - DOC-15125 
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
                    //isModeW=true;   
                    //System.debug(LoggingLevel.WARN,'***Proflex Renewal + Mod***'+dealitem.id);                  
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';  //Commented as a part of DOC-15125
                }
            }      
            //LAPSE ORDER
            For(Apttus_Config2__OrderLineItem__c lapse:orderLineItems)
            {      
                if(lapse.Apttus_Config2__LineStatus__c=='Cancelled')
                {
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
                    laps.lapseCode='OL';
                    laps.lapseQuantity=null;
                    //DOC-14661
                    if ((blnIsCaseLine && lapse.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c == '13' && lapse.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c == 'PQ') 
                    || (lapse.Apttus_Config2__ProductId__r.Productcode != null && vCLValidProflex.contains(lapse.Apttus_Config2__ProductId__r.Productcode))) {
                        laps.lapseDate = APTS_OrderSubmissionUtilityExt3.updateLapseDate(lapse);
                    } //DOC-14661
                    else {
                        laps.lapseDate=null;
                    }
                    if(isnotMLAModify && !string.isEmpty(lapse.APTS_SAP_MLA_Agreement_Number__c) && materialNumberList.contains(lapse.APTS_Service_Number__c)){
                    CreateOrderRequest.orderNotes mlaAgrement= new CreateOrderRequest.orderNotes();
                    mlaAgrement.notes='Replace MLA Agreement Number: '+lapse.Apttus_QPConfig__ProposalLineItemId__r.APTS_SAP_MLA_Agreement_Number__c+'.';
                    ordreq.CreateOrderRequest.OrderHeader.orderNotes.add(mlaAgrement);                      
                    }  
                    //ordreq.CreateOrderRequest.orderLapseLines.add(laps);    
                    //SOC-5819
                    //SOC-5991 //7834 Changing to ModeW
                    if (lapse.APTS_Info_PlanType__c =='S00'){
                    //isModeW=true; 
                    //System.debug(LoggingLevel.WARN,'***Lapsed ModeA AssetLineItem***'+lapse.id);
                    //ordreq.CreateOrderRequest.OrderHeader.oaMode='W';  //Commented as a part of DOC-15125
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
            
            //online contacts
            For(Online_Contacts__c onlinecon1 : onlinecon) 
            {                  
                //system.debug(LoggingLevel.WARN,'###### onlinecon'+onlinecon);
                //system.debug(LoggingLevel.WARN,'###### materialMap'+materialMap);
                //system.debug(LoggingLevel.WARN,'###### bundlematerialMap'+bundlematerialMap);
                if((!materialMap.isEmpty() && materialMap.containsKey(onlinecon1.Material__c)) || (!bundlematerialMap.isEmpty() && bundlematerialMap.containsKey(onlinecon1.Material__c))){                
                    //system.debug(LoggingLevel.WARN,'###### materialMap'+materialMap);
                    CreateOrderRequest.onlineContacts onlineContact = new CreateOrderRequest.onlineContacts();
                    onlineContact.firstName=onlinecon1.First_Name__c;
                    onlineContact.lastName=onlinecon1.Last_Name__c;
                    onlineContact.emailAddress=onlinecon1.Email__c;
                    //SOC-7060                   
                    onlineContact.locationAccountNumber=onlinecon1.APTS_Source_System_Detail__r.Source_System_Account_Number__c;                                                                              
                    // send 0230 contact if Product brand code is 064
                    onlineContact = APTS_OrderSubmissionUtilityExt5.assignOnlineContactType(onlinecon1,materialBrandCodeMap,onlineContact); //Added by RG for Compile Size Error
                    
                    /*RG:if(onlinecon1.Type__c=='Admin' && !materialBrandCodeMap.isEmpty() && materialBrandCodeMap.containsKey(onlinecon1.Material__c) && materialBrandCodeMap.get(onlinecon1.Material__c) == '064'){
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
                     //Start:GLP-583
                     else if(onlinecon1.Position__c=='Proview Ent IP'){
                        onlineContact.onlineContactType='0900';
                     }  
                     //End- GLP-583 
                                  
                    onlineContact.phone=null;
                    onlineContact.phoneExtension=null;
                    onlineContact.contactNumber=onlinecon1.ContactID__c; :RG */
                     if(!dynamicbundlelist.isEmpty() || isProflex){                       
                    onlineContact.lineNumberLink.lineNumber=String.valueof(bundlematerialMap.get(onlinecon1.Material__c));                    
                    }
                    else{
                    onlineContact.lineNumberLink.lineNumber=String.valueof(materialMap.get(onlinecon1.Material__c));
                    }
                    onlineContact.externalContactNumber=null;
                    //system.debug(LoggingLevel.WARN,'###### onlineContact'+onlineContact+'---> onlineContact.onlineContactType'+onlineContact.onlineContactType);
                    if(!string.isEmpty(onlineContact.onlineContactType)) {
                        //system.debug(LoggingLevel.WARN,'####### in');
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
            ordreq.CreateOrderRequest.OrderHeader.eBillExempt=order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_exempt__c;
            
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
            ordreq.CreateOrderRequest.orderHeader.orderPeriodicValue=String.valueof(periodicValue.setscale(2)); 
            //SOC-5107 SOC-5467
            ordreq.CreateOrderRequest.orderHeader.oneTimeValue=String.valueof(oneTimeValue.setscale(2));
           
            // send the attchment id to Sap in the order header attachements node
            //skg List<Attachment> attachList = [SELECT Id FROM Attachment WHERE (ParentId =:order.Apttus_QPConfig__ProposalId__c AND Name LIKE '%signed%' AND Name LIKE '%CVMS Offer Sheet%' AND Name LIKE '%Order Form%') ORDER BY LastModifiedDate ASC NULLS LAST];
           //SOC-5462 removed LIMIT 1 from query
           /*List<Attachment> attachList = new List<Attachment>(); 
           if(Schema.sObjectType.Attachment.isAccessible() && Schema.sObjectType.Attachment.isQueryable()){
            /*return null;
            }
            List<Attachment>*/ //attachList = [SELECT Id FROM Attachment WHERE (ParentId =:order.Apttus_QPConfig__ProposalId__c AND Name LIKE '%signed%') ORDER BY LastModifiedDate ASC NULLS LAST];}
            /*if(!attachList.isEmpty()) {
                For(Attachment att: attachList) 
               {
                CreateOrderRequest.attachments attachment = new CreateOrderRequest.attachments();
                attachment.path = att.Id;
                attachment.type= 'OR';
                attachment.status= 'E'; 
                ordreq.CreateOrderRequest.OrderHeader.attachments.add(attachment);
                }   
            }*/
             // changes for SOC-2719
              //else{
               /* List<Attachment> attachListOF = [SELECT Id FROM Attachment WHERE (ParentId =:order.Apttus_QPConfig__ProposalId__c AND Name LIKE '%Order Form%') ORDER BY LastModifiedDate ASC NULLS LAST LIMIT 1];
                if(!attachListOF.isEmpty()) {
                    CreateOrderRequest.attachments attachment = new CreateOrderRequest.attachments();                    
                    attachment.path = attachListOF[0].Id;
                    attachment.type= 'OR';
                    attachment.status= 'E'; 
                    ordreq.CreateOrderRequest.OrderHeader.attachments.add(attachment);
                   }*/
                   //SOC-5793
                  // OrderheaderAttachment('Order Form' , False,order.Apttus_QPConfig__ProposalId__c);
                //}
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
             
            //OrderHeaderAttachment method is called from APTS_OrderSubmissionUtility for Content Version (Files Object)
             APTS_OrderSubmissionUtility.orderheaderAttachment(order.Apttus_QPConfig__ProposalId__c, ordreq);
           
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c=='Ground Shipping - U.S. Only' || order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c==null || order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c==''){
                ordreq.CreateOrderRequest.OrderHeader.incoTerms='FOB';
                }
            else{
                ordreq.CreateOrderRequest.OrderHeader.incoTerms='ZCH';
                }
           //SOC-3963 sending incoterm of FOB if Cost center value is valid
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Cost_Center__c!=null && order.Apttus_QPConfig__ProposalId__r.APTS_Cost_Center__c != ''){
                ordreq.CreateOrderRequest.OrderHeader.incoTerms='FOB';
            }
            //DLT-14642
            //credit card details
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Credit Card' || order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Payment Express Auto EFT/Auto Charge' || order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Autopay'){
                If(order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c != null) {
                    Datetime expDate= order.Apttus_QPConfig__ProposalId__r.APTS_Card_Expiration_Date__c;
                    ordreq.CreateOrderRequest.orderHeader.creditCardPayment.expiration = expDate.format('yyyyMMdd');
                    }
                ordreq.CreateOrderRequest.orderHeader.creditCardPayment.authorizationNumber=order.Apttus_QPConfig__ProposalId__r.APTS_Authorization_Number__c;
                ordreq.CreateOrderRequest.orderHeader.creditCardPayment.authorizationTransaction=order.Apttus_QPConfig__ProposalId__r.APTS_Authorization_Transaction__c;
                ordreq.CreateOrderRequest.orderHeader.creditCardPayment.amount=string.valueof(order.Apttus_QPConfig__ProposalId__r.APTS_amount__c);
                ordreq.CreateOrderRequest.orderHeader.creditCardPayment.cardType=order.Apttus_QPConfig__ProposalId__r.APTS_Card_Type__c;
                ordreq.CreateOrderRequest.orderHeader.creditCardPayment.cardNumber=order.Apttus_QPConfig__ProposalId__r.APTS_Credit_Card_Token__c;
                CreateOrderRequest.properties prop1 = new CreateOrderRequest.properties();
                  prop1.key = 'ccVendorTransactId';
                  prop1.value = order.Apttus_QPConfig__ProposalId__r.APTS_VisaTransNumber__c;
                  ordreq.CreateOrderRequest.orderHeader.creditCardPayment.properties.add(prop1);
  
                  prop1 = new CreateOrderRequest.properties();
                  prop1.key = 'transactionMessageType';   
                  prop1.value = order.Apttus_QPConfig__ProposalId__r.APTS_VisaMessageType__c;
                  ordreq.CreateOrderRequest.orderHeader.creditCardPayment.properties.add(prop1);
            }
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Bill to Account'){
                ordreq.CreateOrderRequest.orderHeader.accountPayment.accountNumber=order.APTS_SSD_bill_to__r.Source_System_Account_Number__c;
                }
            //SOC-3626            
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Payment Express Auto EFT/Auto Charge'){
                //SOC-3882 Net 1
                ordreq.CreateOrderRequest.orderHeader.accountPayment.paymentTerm=System.label.APTS_Payment_Term;
            }//Digital D030 Payment Term Requirement By Roma
            if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c=='Autopay'){
                ordreq.CreateOrderRequest.orderHeader.accountPayment.paymentTerm='D030';
            }if(order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c != null){
                CreateOrderRequest.orderNotes poOrdernotes= new CreateOrderRequest.orderNotes();
                poOrdernotes.notes= 'Payment Option: '+order.Apttus_QPConfig__ProposalId__r.APTS_Payment_Option__c; 
                ordreq.CreateOrderRequest.orderHeader.orderNotes.add(poOrdernotes);
                }
            //SoldTo Account
            if(order.APTS_SSD_Sold_To__c!=null)
            {
                CreateOrderRequest.orderAddress ordaddress = new CreateOrderRequest.orderAddress();
                ordaddress.partnerType='soldTo';
                ordaddress.shippingAmount=null;
                if(!string.isEmpty(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c)){
                ordaddress.shippingMethod=Shipping_Method__c.getInstance(order.Apttus_QPConfig__ProposalId__r.APTS_Ground_Shipping__c).Value__c;}
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
            else if(order.Apttus_QPConfig__ProposalId__r.APTS_Ebilling_contact__c==null && order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.LCRM_eOutput_Eligibility__c != 'NEL' && order.Apttus_QPConfig__ProposalId__r.APTS_SSD_Sold_To__r.LCRM_eOutput_Eligibility__c != 'USG'){ 
            CreateOrderRequest.orderContact ebcontact = new CreateOrderRequest.orderContact();
            
            ebcontact.firstName= order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.FirstName;
            ebcontact.lastName=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.LastName; 
            ebcontact.emailAddress=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Email;
            ebcontact.phone=null;
            ebcontact.phoneExtension=null;
            ebcontact.contactNumber=null;
            ebcontact.department=null;
            ebcontact.fax=null;
            ebcontact.function=order.Apttus_QPConfig__ProposalId__r.APTS_Order_Confirmation_Contact__r.Contact_Type__c;
            ebcontact.building=null;
            ebcontact.floor=null;
            ebcontact.room=null;
            ebcontact.ContactType= '30';
            
            ordreq.CreateOrderRequest.OrderHeader.orderContact.add(ebcontact);
            }
            For(Customer_Master_Contacts__c mastercon1 : mastercon) 
            {
                CreateOrderRequest.orderContact ordcontact1 = new CreateOrderRequest.orderContact();
                /*ordcontact1.firstName=mastercon1.First_Name__c;
                ordcontact1.lastName=mastercon1.Last_Name__c;
                ordcontact1.emailAddress=mastercon1.Email_Address__c;*/
                /*if(mastercon1.Customer_Type_Description__c=='CLEAR PRIMARY CONT'){  
                    ordcontact1.ContactType= '46';
                    }
                else if(mastercon1.Customer_Type_Description__c=='PATRON ACC TECH CONT'){
                    ordcontact1.ContactType='59';
                    }
                else if(mastercon1.Customer_Type_Description__c=='TECHNICAL CONTACT'){
                    ordcontact1.ContactType='03';
                    }
                else if(mastercon1.Customer_Type_Description__c=='EML PSWD CONTACT' || mastercon1.Customer_Type_Description__c=='EML PSWD CONTACT1'){
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
                else if(mastercon1.Customer_Type_Description__c=='AUTO PAYMENT PROCESS'){
                    ordcontact1.ContactType='26';
                    }*/
                ordcontact1   = APTS_OrderSubmissionUtilityExt4.returnOrdContact1(mastercon1,ordcontact1);
                /*if(mastercon1.Customer_Type_Description__c=='EML PSWD CONTACT' || mastercon1.Customer_Type_Description__c=='EML PSWD CONTACT1'){
                    ordcontact1.ContactType='24';
                }
                else {
                    switch on mastercon1.Customer_Type_Description__c{
                        when 'CLEAR PRIMARY CONT'{
                            ordcontact1.ContactType= '46';
                        }
                        when 'PATRON ACC TECH CONT'{
                            ordcontact1.ContactType='59';
                        }
                        when 'TECHNICAL CONTACT'{
                            ordcontact1.ContactType='03';
                        }
                        when 'ADMINISTRATOR'{
                            ordcontact1.ContactType='60';
                        }
                        when 'SRR MEDIA CONTACT'{
                            ordcontact1.ContactType='36';
                        }
                        when 'PT INTER MEDIA CONT'{
                            ordcontact1.ContactType='32';
                        }
                        when 'PT INTRA MEDIA CONT'{
                            ordcontact1.ContactType='33';
                        }
                        when 'PT SENTRY MEDIA CONT'{
                            ordcontact1.ContactType='35';
                        }
                        when 'COMPLIANCE LEARNING'{
                            ordcontact1.ContactType='40';
                        }
                        when 'Filing Contact'{
                            ordcontact1.ContactType='34';
                        }
                        when 'AUTO PAYMENT PROCESS'{
                            ordcontact1.ContactType='26';
                        }
                    }
                }*/
                //End : Risk Spree
                ordcontact1.phone=mastercon1.Phone__c;
                if((mastercon1.Customer_Type_Description__c=='PATRON ACC TECH CONT' || mastercon1.Customer_Type_Description__c=='CLEAR PRIMARY CONT' 
                    || mastercon1.Customer_Type_Description__c=='PATRON ACC TECH CONT' || isGLPProduct == True) //GLP-230
                    && mastercon1.To_IP_Address__c!=null){
                    
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
            //System.debug(LoggingLevel.WARN,proflexOrderLineItem.APTS_MLA__c);
            if(!multiLocAccount.isEmpty()  ){
                
                //System.debug(LoggingLevel.WARN,isMLAReplace );
                //System.debug(LoggingLevel.WARN,grpName);
                //System.debug(LoggingLevel.WARN,isnotMLAModify); 
                  //SOC-4852
                if(hasDynamicBundle && proflexOrderLineItem!=null && proflexOrderLineItem.APTS_MLA__c==true ){
                //Start DOC-9689: Jinal Bhatt
                        //System.debug(LoggingLevel.WARN,proflexOrderLineItem.APTS_MLA__c);
                        //System.debug(LoggingLevel.WARN,proflexOrderLineItem.APTS_Keep_Terms__c);
                        //System.debug(LoggingLevel.WARN,proflexOrderLineItem.APTS_SAP_MLA_Agreement_Number__c);
                        //System.debug(LoggingLevel.WARN,mapBundleLineItems.size());
                        //System.debug(LoggingLevel.WARN,mapBundleLineItems.get(grpName)!=null);                
                        if (proflexOrderLineItem.APTS_Keep_Terms__c==true && proflexOrderLineItem.APTS_SAP_MLA_Agreement_Number__c!=null) {
                            mlaHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeader(order, proflexOrderLineItem, 'Modify');
                            mlaHeader.agreementNum= proflexOrderLineItem.APTS_SAP_MLA_Agreement_Number__c;                   
                        } else if (isMLAReplace &&!mapBundleLineItems.isEmpty() && grpName!=null && mapBundleLineItems.get(grpName)!=null) {  //mlaBundle.APTS_Keep_Terms__c==false && mlaBundle.APTS_MLA_Agreement_Number__c!=null, Soc- 3465 changes               
                            for(Apttus_Config2__OrderLineItem__c ordeline :mapBundleLineItems.get(grpName)){
                               // System.debug(LoggingLevel.WARN,ordeline.Apttus_Config2__LineStatus__c);    //Commented
                
                                if (!string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c)) {
                                    if(ordeline.Apttus_Config2__LineStatus__c =='Cancelled' && isnotMLAModify && !string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c)
                                        && materialNumberList.contains(ordeline.APTS_Service_Number__c)) {
                                        mlaHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeader(order, proflexOrderLineItem, 'Replace');
                                        mlaHeader.agreementNum = ordeline.APTS_SAP_MLA_Agreement_Number__c;
                                        mlaHeader.noOfAttorneys = numberOfAttorneys; //DOC-9689
                                        mlaHeader.discountPercent= '';
                                        mlaHeader.discountValue= '';
                                        mlaHeader.surcharge= '';                    
                                        mlaHeader.pricingOption='Y';
                                        mlaHeaderinfo.add(mlaHeader);
                                        isReplaceMode = True;
                                    }
                                }     
                            }
                        } else {
                            mlaHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeader(order, proflexOrderLineItem, 'New');    
                            mlaHeader.agreementNum= proflexOrderLineItem.APTS_SAP_MLA_Agreement_Number__c;
                        }
                        //End DOC-10174
                    }
                          
              //System.debug(LoggingLevel.WARN,mlaHeader+':'+isReplaceMode+':'+mapBundleLineItems); 
              //noOfAttorneys for MLA
                  if (hasDynamicBundle && mlaHeader!=null && !isReplaceMode &&!mapBundleLineItems.isEmpty() && grpName!=null && mapBundleLineItems.get(grpName)!=null) {
                    mlaHeader.noOfAttorneys='0';
                    for(Apttus_Config2__OrderLineItem__c ordeline :mapBundleLineItems.get(grpName)){
                        If(ordeline.Apttus_Config2__LineStatus__c != 'Cancelled') {
                            if(OnlineContactsController.validateProductLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, System.Label.OCBandedLowerLevelCodes) == true
                                || (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='06' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9')){                
                                mlaHeader.noOfAttorneys=string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));                            
                            }                    
  
                            if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9'){
                                mlaHeader.noOfAttorneys=null;
                            
                            }
                        }
                    } 
                    
                    mlaHeader.discountPercent= '';
                    mlaHeader.discountValue= '';
                    mlaHeader.surcharge= '';                    
                    mlaHeader.pricingOption='Y';
                    mlaHeaderinfo.add(mlaHeader);
                
                }
                //End DOC-9689: Jinal Bhatt
                if(!hasDynamicBundle){
                    for(APTS_Dynamic_Bundle__c mlaBundle :dynamicbundlelist){
                  //SOC-4852
                if(mlaBundle.APTS_MLA__c==true){
                //Start DOC-9689: Jinal Bhatt
                        if (mlaBundle.APTS_Keep_Terms__c==true && mlaBundle.APTS_MLA_Agreement_Number__c!=null) {
                            mlaHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeaderDB(order, mlaBundle, 'Modify');
                            mlaHeader.agreementNum= mlaBundle.APTS_MLA_Agreement_Number__c;                   
                        } else if (isMLAReplace) {  //mlaBundle.APTS_Keep_Terms__c==false && mlaBundle.APTS_MLA_Agreement_Number__c!=null, Soc- 3465 changes               
                            For (Apttus_Config2__OrderLineItem__c ordeline :orderLineItems) {
                                if (!string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c)) {
                                    if(ordeline.Apttus_Config2__LineStatus__c =='Cancelled' && isnotMLAModify && !string.isEmpty(ordeline.APTS_SAP_MLA_Agreement_Number__c)
                                        && materialNumberList.contains(ordeline.APTS_Service_Number__c)) {
                                        mlaHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeaderDB(order, mlaBundle, 'Replace');
                                        mlaHeader.agreementNum = ordeline.APTS_SAP_MLA_Agreement_Number__c;
                                        mlaHeader.noOfAttorneys = numberOfAttorneys; //DOC-9689
                                        mlaHeader.discountPercent= '';
                                        mlaHeader.discountValue= '';
                                        mlaHeader.surcharge= '';                    
                                        mlaHeader.pricingOption='Y';
                                        mlaHeaderinfo.add(mlaHeader);
                                        isReplaceMode = True;
                                    }
                                }     
                            }
                        } else {
                            mlaHeader = APTS_OrderSubmissionUtilityExt1.createMLAHeaderDB(order, mlaBundle, 'New');    
                            mlaHeader.agreementNum= mlaBundle.APTS_MLA_Agreement_Number__c;
                        }
                        //End DOC-10174
                    }
                  }         
                
              //noOfAttorneys for MLA
                  if (!isReplaceMode && mlaHeader!=null) {
                    mlaHeader.noOfAttorneys='0';
                    For(Apttus_Config2__OrderLineItem__c ordeline :orderLineItems) {
                        If(ordeline.Apttus_Config2__LineStatus__c != 'Cancelled') {
                            if(OnlineContactsController.validateProductLLCode(ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c, System.Label.OCBandedLowerLevelCodes) == true
                                || (ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='06' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9')){                
                                mlaHeader.noOfAttorneys=string.valueof(ordeline.Apttus_Config2__Quantity__c.setscale(0));                            
                            }                    
  
                            if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='I9'){
                                mlaHeader.noOfAttorneys=null;
                            
                            }
                        }
                    } 
                  
                    mlaHeader.discountPercent= '';
                    mlaHeader.discountValue= '';
                    mlaHeader.surcharge= '';                    
                    mlaHeader.pricingOption='Y';
                    mlaHeaderinfo.add(mlaHeader);
                }
                }
                //MLA CustomerGroup details
                //skg moved from above
              for(APTS_Quote_Agreement_Locations__c multiAcc :multiLocAccount){              
              if  (multiAcc.APTS_Status__c!='Cancelled'){
                customerGroup = new CreateOrderRequest.CustomerGroup(); 
                //ContentMaterials = new CreateOrderRequest.ContentMaterials();
                customerDetails= new CreateOrderRequest.CustomerDetails ();
                userDetails= new CreateOrderRequest.UserDetails();                
                customerGroup.locationAcc= multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c;                        
                customerGroup.validFrom= '';
                customerGroup.validTo='';
                customerGroup.allocationPerc='';
                
                if(mlaHeader!=null && mlaHeader.determineBillPayer=='D' && mlaHeader.mlaOption!='Modify'){
                       customerGroup.billPayer=multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c; 
                       customerGroup.billTo= multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c;
                }
                else if(mlaHeader!=null && mlaHeader.determineBillPayer=='C' && mlaHeader.mlaOption!='Modify')
                {
                customerGroup.billPayer=multiAcc.APTS_Quote_Proposal__r.APTS_Sold_To_SAP_Account_Number__c; 
                customerGroup.billTo= multiAcc.APTS_Quote_Proposal__r.APTS_Sold_To_SAP_Account_Number__c;
                }
                CustomerGroupinfo.add(customerGroup);
                //MLA ContentMaterials details  
                //SOC-3729 added or condition
                if ((multiAcc.APTS_Status__c=='New')||(multiAcc.APTS_Status__c=='Existing')){ 
                For(Apttus_Config2__OrderLineItem__c ordeline :orderLineItems)
                    {   
                        If(ordeline.Apttus_Config2__LineStatus__c == 'New' || ordeline.Apttus_Config2__LineStatus__c == 'Existing' || ordeline.Apttus_Config2__LineStatus__c == 'Amended') {  
                            contentMaterials = new CreateOrderRequest.ContentMaterials();
                            for(MLAMediaLevelCode__c mediaLevel: MLAMediaLevelCode__c.getAll().values()) 
                            {                    
                            if(mediaLevel.MLA_Media_High_Level_Code__c == ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c &&  mediaLevel.MLA_Media_Lower_Level_Code__c==ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c ){                         
                                contentMaterials.lineNumber = String.valueOf(ordeline.Apttus_Config2__LineNumber__c);
                                contentMaterials.material= ordeline.Apttus_Config2__ProductId__r.ProductCode;
                                contentMaterials.locationAcc= multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c;  
                                //SOC-3900- Sreenu D added if else condition to assign no.of allocations                     
                                if(ordeline.Apttus_Config2__ProductId__r.APTS_Media_High_Level_Code__c=='13' && ordeline.Apttus_Config2__ProductId__r.APTS_Media_Lower_Level_Code__c=='ST'){
                                contentMaterials.noOfAllocations = '1';}
                                else{
                                contentMaterials.noOfAllocations= !countMap.isEmpty() && countMap.containsKey(ordeline.Apttus_Config2__ProductId__r.ProductCode+multiAcc.APTS_Subscriber_Location_SSD__c) ? string.valueOf(countMap.get(ordeline.Apttus_Config2__ProductId__r.ProductCode+multiAcc.APTS_Subscriber_Location_SSD__c)) : null   ; }                   
                                contentMaterials.validFrom= '';
                                contentMaterials.validTo='';
                        
                             }
                           }
                        contentMaterialsinfo.add(contentMaterials);
                    }
                }
                }
                
                
                //MLA CustomerDetails details
                customerDetails.custNumber= multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c;              
                
                        if(multiAcc.APTS_Quote_Proposal__r.APTS_Sold_To_SAP_Account_Number__c==multiAcc.APTS_Subscriber_Location_SSD__r.Source_System_Account_Number__c){
                        customerDetails.isPrimary='X';
                        }
                        CustomerDetailsinfo.add(customerDetails);
                        
                //User Details
                if(multiAcc.APTS_Status__c=='New' || multiAcc.APTS_Status__c=='Existing'){
                    For(Online_Contacts__c multiAcccon: onlinecon) 
                    {     
                    //System.debug('###########blnIsContactRequired'+ blnIsContactRequired);           
                        if(multiAcccon.APTS_Source_System_Detail__c==multiAcc.APTS_Subscriber_Location_SSD__c && blnIsContactRequired){  //DOC-11983: Jinal Bhatt                           
                            
                            if(multiAcccon.Is_Banded_Product__c){
                                if(string.isEmpty(mlAcc) && string.isEmpty(flEmail)) {
                                    flEmail = (multiAcccon.First_Name__c+multiAcccon.Last_Name__c+multiAcccon.Email__c);
                                    mlAcc = multiAcccon.APTS_Source_System_Detail__c;
                                    //onlineContactAssign(multiAcccon, multiAcc);    
                                    userDetails = new CreateOrderRequest.UserDetails();
                                    userDetails = APTS_OrderSubmissionUtilityExt2.onlineContactAssign(multiAcccon, multiAcc, materialBrandCodeMap);
                                    //System.debug('############### userDetails'+userDetails);
                                    userDetailsinfo.add(UserDetails);
                                 }
                                else{
                                if(mlAcc != multiAcccon.APTS_Source_System_Detail__c && flEmail != (multiAcccon.First_Name__c+multiAcccon.Last_Name__c+multiAcccon.Email__c)){
                                    flEmail = (multiAcccon.First_Name__c+multiAcccon.Last_Name__c+multiAcccon.Email__c);
                                    mlAcc = multiAcccon.APTS_Source_System_Detail__c;
                                    //onlineContactAssign(multiAcccon, multiAcc);    
                                    userDetails = new CreateOrderRequest.UserDetails();
                                    userDetails = APTS_OrderSubmissionUtilityExt2.onlineContactAssign(multiAcccon, multiAcc, materialBrandCodeMap);
                                    //System.debug('############### userDetails'+userDetails);
                                    userDetailsinfo.add(UserDetails);
                                }
                                else {
                                    if(mlAcc != multiAcccon.APTS_Source_System_Detail__c || flEmail != (multiAcccon.First_Name__c+multiAcccon.Last_Name__c+multiAcccon.Email__c)){
                                    flEmail = (multiAcccon.First_Name__c+multiAcccon.Last_Name__c+multiAcccon.Email__c);
                                    mlAcc = multiAcccon.APTS_Source_System_Detail__c;
                                    //onlineContactAssign(multiAcccon, multiAcc);    
                                    userDetails = new CreateOrderRequest.UserDetails();
                                    userDetails = APTS_OrderSubmissionUtilityExt2.onlineContactAssign(multiAcccon, multiAcc, materialBrandCodeMap);
                                    //System.debug('############### userDetails'+userDetails);
                                    userDetailsinfo.add(UserDetails);
                                    }
                                }
                            }                    
                        }
                        else {
                            //onlineContactAssign(multiAcccon, multiAcc);    
                            userDetails = new CreateOrderRequest.UserDetails();
                            userDetails = APTS_OrderSubmissionUtilityExt2.onlineContactAssign(multiAcccon, multiAcc, materialBrandCodeMap);
                            //System.debug('############### userDetails'+userDetails);
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
            multiLoc.mlaHeader.addAll(mlaHeaderinfo);
            multiLoc.CustomerGroup.addAll(customerGroupinfo);
            multiLoc.ContentMaterials.addAll(contentMaterialsinfo);
            multiLoc.CustomerDetails.addAll(customerDetailsinfo);
            multiLoc.UserDetails.addAll(userDetailsinfo);
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
            //System.debug(LoggingLevel.WARN,'%%%%%%%%%'+strBody);
            Boolean runOldOrderProcess = false;
            KeyValueListStore__c keyValueListRec = KeyValueListStore__c.getValues('APTS_OldOrderProcess');
            if(keyValueListRec !=NULL){
                runOldOrderProcess = TRUE;
            }
            if(runOldOrderProcess){
                WebServiceSettings__c oWebServiceSettings = AppUtil.getWebServiceSettings('OrdersubmissionESI');  
                Httprequest req=new httprequest();
                req.setEndpoint('Callout:OrdersubmissionESI'); //PMD changes to avoid violation
                req.setHeader('Content-Type','application/json');
                req.setBody(strBody);
                req.setmethod('POST');
                blob  headerValue = Blob.valueOf(oWebServiceSettings.Username__c + ':' + oWebServiceSettings.Password__c);
                String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                Http http = new Http();
                HTTPResponse res = new HTTPResponse ();
                //system.debug(LoggingLevel.WARN,'###### strBody'+strBody);
                if(!test.isrunningtest()) {
                    res = http.send(req);
                    }
                else{
                    res=OrderSubmissionMocKCallout.respond(req);                
                    //res.setbody('{ "CreateOrderResponse":{"Status" :{"Code" :"200","Description" :"Successfully received the order request" }}}');
                }   
                //String response=res.getbody();
                //System.debug(LoggingLevel.WARN,'****************res.getStatusCode();'+res.getStatusCode());
                //System.debug(LoggingLevel.WARN,'****************res.getbody();'+res.getbody());
                if(res.getStatusCode()!=200)
                {
                    // call method to log the request
                    //APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Quote/Proposal ESI Call Failed : '+res.getStatusCode()+' : '+res.getbody()},order.Id,order.Retry_Count__c);
                    List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(new List<String>{'prabhu.issac@thomsonreuters.com'});
                    emailToSend.setPlainTextBody('Order Not got processed Sucessfully for the order:'+order.Name+'');
                    emailToSend.setSubject('Order Failed');
                    lstMsgsToSend.add(emailToSend);                
                    Messaging.sendEmail(lstMsgsToSend);
                    //loggerId = IntegrationLogger.OCAddMessage('Old Order Process','', 'Order', '', 'Outbound','OrderSubmission',false,orderId);         
                    loggerId = APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Old Process : Quote/Proposal ESI Call Failed : '+res.getStatusCode()+' : '+res.getbody()},order.Id,order.Retry_Count__c);
                    ordersubwrap.isSuccess = false;
                    //ordersubwrap.applicationId = '';
                    //ordersubwrap.companyId = '';
                    return ordersubwrap;
                }else if(res.getStatusCode()==200){ 
                    loggerId = APTS_OrderSubmissionUtility.logException(new Map<String, String>{'strBody'=>strBody, 'error'=>'Old Process : Quote/Proposal ESI success : '+res.getStatusCode()+' : '+res.getbody()},order.Id,order.Retry_Count__c);
                    //loggerId = IntegrationLogger.OCAddMessage('Old Order Process','', 'Order', '', 'Outbound','OrderSubmission',false,orderId);         
                    ordersubwrap.isSuccess = true;
                    //ordersubwrap.applicationId = '';
                    //ordersubwrap.companyId = '';
                    return ordersubwrap;
                }
                //System.debug(LoggingLevel.WARN,'#############res.getbody();'+res.getbody());
                
                ordersubwrap.isSuccess = false;
                //ordersubwrap.applicationId = '';
                //ordersubwrap.companyId = '';
                return ordersubwrap;
            }else{
                APTS_OrderSubmissionUtilityExt4.createLoggerforPE(orderId, ordreq, ordersubwrap);
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
                return ordersubwrap;
            }
            
            /*return false;*/
        }
        catch(Exception ex){    
            //System.debug(LoggingLevel.WARN,'Something went wrong'+ex.getMessage()+ex.getLineNumber()); 
            //logException(ex.getMessage()+' : '+ex.getLineNumber()+' : '+ex.getStackTraceString(),'Quote/Proposal ESI call SFDC Error',order.Id,order.Retry_Count__c); 
            /*if(Schema.sObjectType.Integration_Logger__c.isAccessible()){       
                intLogList=[Select Id from Integration_Logger__c where Order__c =: orderId and Service_Name__c='OrderSubmission'];
            }
            if(intLogList!=null && intLogList.size()==1){
                IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false,ex.getMessage()+'\n'+ex.getStackTraceString(),'');
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
        }
    }
        
     
        /*=================================================================================
    Method to set MYR Terms details
    ===================================================================================*/
    //public static void orderTermsUtil(string contractTerm, Decimal baseValue, string adjustment,String renewal,Boolean isRenewel, Integer period) {
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
       * @param perIncy12
       * @param perIncy23
       * @param perIncy34
       * @param perIncy45
       * @param isProflex
       */
      public static void orderTermsUtil(string contractTerm, Decimal baseValue, string adjustment,String renewal,Boolean isRenewel,String status, Integer period, Decimal proratevalue,String termtype,boolean ismultitier,Decimal year1,Decimal year2,Decimal year3,Decimal year4,Decimal year5,Decimal perIncy12,Decimal perIncy23,Decimal perIncy34,Decimal perIncy45, boolean isProflex) {    //Added last parameter as part of DOC-14238
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
                 ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,baseValue,0));
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
                {   //system.debug(LoggingLevel.WARN,'ismultitier ='+ismultitier+'i = '+i);
                    //system.debug(LoggingLevel.WARN,'For Loop i value = '+i+'Period = '+period);
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
                                ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, basevalue,0));
                            }
                            else{
                                Map<String,String> strMap = new Map<String,String>();
                                strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),'0');
                                //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),'0',basevalue,0));
                                ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, basevalue,0));
                            }
                        }//End
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,basevalue,0));}
                        if(i == 2){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),string.ValueOf(perIncy12));
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),string.ValueOf(perIncy12),year2,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year2,0));
                        } 
                        if(i == 3){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),string.ValueOf(perIncy23));
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),string.ValueOf(perIncy23),year3,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year3,0));}
                        if(i == 4){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),string.ValueOf(perIncy34));
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),string.ValueOf(perIncy34),year4,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,year4,0));} //DOC-4992
                        if(i == 5){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),string.ValueOf(perIncy45));
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),string.ValueOf(perIncy45),year5,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year5,0));} //DOC-4992                   
                    } 
                    else if(!ismultitier && !isRenewel){
                        if(i == 1 && (!(termtype == 'ProRate' || termtype == 'Co-Term and ProRate'))){  //DOC-14238
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
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,year3,0));} //DOC-4992
                        if(i == 4){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year4,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil( strMap, year4,0));} //DOC-4992
                        if(i == 5){
                             Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year5,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year5,0));} //DOC-4992           
                    } //DOC-3883 Ends                   ) {
                    else if(!ismultitier && isRenewel){
                        if(i == 1 && (!(termtype == 'ProRate' || termtype == 'Co-Term and ProRate'))){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year1,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year1,0));}
                        if(i == 2){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year2,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year2,0));} 
                        if(i == 3){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year3,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,year3,0));} 
                        if(i == 4){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year4,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap,year4,0));} 
                        if(i == 5){
                            Map<String,String> strMap = new Map<String,String>();
                            strMap= APTS_OrderSubmissionUtilityExt1.returnStringMap(contractTerm,string.ValueOf(i),adjustment);
                            //ordline.subscriptionDetail.terms.add(termUtil(contractTerm,string.ValueOf(i),adjustment,year5,0));
                            ordline.subscriptionDetail.terms.add(APTS_OrderSubmissionUtilityExt1.termUtil(strMap, year5,0));}            
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
       * @param perIncyr12
       * @param perIncyr23
       * @param perIncyr34
       * @param perIncyr45
       * @param isProflex
       */
      public static void orderTerms(string contractTerm, Decimal baseValue, string adjustment, String renewal, string status,String termtype ,Decimal proratevalue, Decimal year1,Decimal year2,Decimal year3,Decimal year4,Decimal year5, boolean ismultitier, Decimal perIncyr12, Decimal perIncyr23, Decimal perIncyr34, Decimal perIncyr45, boolean isProflex) {    //Added last parameter as part of DOC-14238
        //Contract Term =0 //SOC-6437 May Bijeta For short term
        if(string.valueof(contractTerm)=='Short Term Trial')
        {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            //Added following parameters as part of MTP status, Integer period, Decimal proratevalue,String termtype,boolean ismultitier,Decimal year1,Decimal year2,Decimal year3,Decimal year4,Decimal year5
            if(status=='Renewed'){            
            orderTermsUtil('0',baseValue,adjustment,renewal,true,status,0,proratevalue, termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
            }
            else{
            orderTermsUtil('0',baseValue,adjustment,'0',false, status,0,proratevalue, termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
            }
        }
        
        
        //Contract Term =1
        if(string.valueof(contractTerm)=='1 Year')
        {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            //system.debug(LoggingLevel.WARN,'Inside 1 Year = '+'Year1 = '+year1);
            if(status=='Renewed'){            
            orderTermsUtil('1',baseValue,adjustment,renewal,true,status,1,proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
            }
            else if(status == 'New' && (termtype == 'ProRate' || termtype == 'Co-Term and ProRate')){
                orderTermsUtil('1',proratevalue,adjustment,'0',false, status,1, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
            }
            else {
                orderTermsUtil('1',baseValue,adjustment,'0',false,status,1, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
            }
        }
        
         
        //Contract Term =2  
        if(string.valueof(contractTerm)=='2 Years')
        {  // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            //system.debug(LoggingLevel.WARN,'Inside 2 Years = '+'Year1 = '+year1+'Year2 f'= '+year2);
           if(status=='Renewed'){            
            orderTermsUtil('2',baseValue,adjustment,renewal,true,status,2, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
            }
            else{
            orderTermsUtil('2',baseValue,adjustment,'0',false,status,2, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
            }
        }
        //Contract Term =3
        if(string.valueof(contractTerm)=='3 Years')
        {   // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
           //system.debug(LoggingLevel.WARN,'Inside 3 Years = '+'Year1 = '+year1+'Year2 = '+year2+'Year3 = '+year3);
           if(status=='Renewed'){            
            orderTermsUtil('3',baseValue,adjustment,renewal,true,status,3, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
            }
            else{
            orderTermsUtil('3',baseValue,adjustment,'0',false,status,3, proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);         
            }
        }
        //Contract Term =4
        if(string.valueof(contractTerm)=='4 Years')
        {  // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            if(status=='Renewed'){            
            orderTermsUtil('4',baseValue,adjustment,renewal,true,status,4,proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
            }
            else{
            orderTermsUtil('4',baseValue,adjustment,'0',false,status,4,proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
            }
        }
        //Contract Term =5
        if(string.valueof(contractTerm)=='5 Years')
        {  
            // call termUtil method with termLength, Period, percentIncrease,Base Value, User Rate 
            if(status=='Renewed'){            
            orderTermsUtil('5',baseValue,adjustment,renewal,true,status,5,proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
            }
            else{
            orderTermsUtil('5',baseValue,adjustment,'0',false,status,5,proratevalue,termtype,ismultitier, year1, year2, year3, year4, year5,perIncyr12, perIncyr23, perIncyr34, perIncyr45,isProflex);
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
        
            /*=================================================================================
    SOC-5358 Assign Line Items - Pratheeksha
    ===================================================================================*/
    //Added Quantity - may release
       /**
       * @description assignDealLines
       * @param lNo
       * @param recType
       * @param cno
       * @param cln
       * @param quantity
       * @return CreateOrderRequest.lineItems
       */
      /*public static CreateOrderRequest.lineItems assignDealLines(integer lNo,string recType,decimal cno,decimal cln,decimal quantity) {
        CreateOrderRequest.lineItems ln = new CreateOrderRequest.lineItems();         
        ln.recordType = recType;
        ln.lineNumber = (lNo != 0? string.valueof(lNo) : '');
        ln.existingSub = (cno != 0? string.valueof(cno) : '');
        ln.existingSubLine = (cln != 0? string.valueof(cln) : '');
        ln.quanity = (quantity != 0? string.valueOf(quantity).substringBefore('.') : '');
        return ln;
    } */   
    
    /*=================================================================================
    Method For MYR details
    ===================================================================================*/    
     /**
       * @description termUtil
       * @param tLen
       * @param period
       * @param percInc
       * @param bValue
       * @param uRate
       * @return CreateOrderRequest.terms
       */
    /*public static CreateOrderRequest.terms termUtil(string tLen, string period, string percInc, Decimal bValue, Decimal uRate) {
        CreateOrderRequest.terms term = new CreateOrderRequest.terms();
       // system.debug(LoggingLevel.WARN,'period = '+period+'percInc = '+percInc+'bValue ='+bValue);
        term.termLength= tLen;
        term.period= period;
        term.percentIncrease= percInc;
        term.baseValue= bValue;
        term.userRate= uRate;
        return term;
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
      /*public static void logException(string strBody, string error,Id orderId,Decimal retryCount) {
        //if(retryCount>=1){
      //system.debug(LoggingLevel.WARN,'Order Queue ESI LogException Retry COunt ::'+retryCount);
      if(Schema.sObjectType.Integration_Logger__c.isAccessible() && Schema.sObjectType.Integration_Logger__c.isQueryable()){
        
      List<Integration_Logger__c> intLogList=[Select Id from Integration_Logger__c where Order__c=:orderId];
      //system.debug(LoggingLevel.WARN,'intLogList :: '+intLogList);
      if(intLogList!=null && intLogList.size()==1){
        IntegrationLogger.TaxupdateMessage(intLogList[0].Id, false,error,strBody);
      //}
    }else{
      //system.debug(LoggingLevel.WARN,'else part of LogException Retry COunt :: '+retryCount);
      IntegrationLogger.OCAddMessage(error,'', 'Quote/Proposal', strBody, 'Outbound','OrderSubmission',false,orderId);
         
    } 
    }
  }*/
  
  /*=================================================================================
     Online Contacts Mapping Method for MLA User Details
  ===================================================================================*/ 
        /**
       * @description onlineContactAssign
       * @param multiAcccon
       * @param multiAcc
       */
      /*public static void onlineContactAssign(Online_Contacts__c multiAcccon, APTS_Quote_Agreement_Locations__c multiAcc) {
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
          
  }
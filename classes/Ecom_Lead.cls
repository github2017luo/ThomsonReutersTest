/*
* CHANGE HISTORY
* ==================================================================================================================================
* Date             Name                           Description
* 31-07-2018      Prashob           DLT-10892[NEW CUSTOMER - Buy Plan SL/CP] Additional Lead Details to be added to Existing Customer Leads
* 08-07-2018     Shiva Sri Arun     DLT-10835 LEAD CONVERSION //Mandatory GLI FIELDS and recordtype 
* 2018-08-20     Shiva Sri Arun     DLT-10835 [NEW CUSTOMER - Buy Plan SL/CP] Convert Lead to Account,Contact,Opportunity
* 2018-08-28     Shiva/Ramesh       DLT-11546 [TECH STORY- SFDC] - Update calls as per new UI for checkout
* 2018-08-28     Shiva Sri Arun     DLT-11729 [Tech story] [Code Scan] Fix Ecom_lead
* 2018-10-12     Shiva Sri Arun     DLT-12914 [NSE] Update Sub-BU field on Leads with 'USL'
* 2018-10-23     Ramesh Reddy       DLT-12909 [NSE ALL] Map Extension # to GLI Contact Object
* 2018-11-20     Ramesh Reddy       DLT-12983 [NSE ALL] Create Lead for Customers Not Allowed to Purchase (From Log In)
* 2018-12-24     Samreen Ali        DLT-10332 [NSE ALL] Populate Current Customer Information on Existing Lead
* 2019-02-04     Samreen Ali        DLT-14651 [NSE ALL] Add Activity on Lead of the Email Addresses cart was forwarded too 
* 2019-02-14     Samreen Ali        DLT-15254 [NSE ALL] Add '<Cart Forwarded>' to Lead Description field 
* 2019-03-12     Samreen Al         DLT-15097 [NSE SL] Add 'Custom' to Lead/Opportunity Description field for Custom plan
* 2019-03-18     Samreen Ali        DLT-15574 [NSE ALL] NewSales_Lead not getting update with updated plan name
* 2019-03-18     Samreen Ali        DLT-15379 [NSE ALL] Add Successful emails and updates to Lead when Cart Forwarded
* 2019-03-27     Samreen Ali        DLT-15332 [NSE FL] Create/Assign Campaign ID's to SFDC Objects
* 2019-03-27     Samreen Ali        DLT-15525 Update Campaign ID on Lead
* 2019-11-14    David Hoel          DLT-18470 Assign Tracking Code and CampaignId from Eloqua cookie.
* 2020-02-18	Rahul Natarajan 	DLT-19503 [NSE] Update Lead source description field
* 2020-03-06    Rahul Natarajan     DLT-19602 [NSE][SFDC][ALL] Is Marketing checkbox to be checked for NSE lead	
* 2020-05-08	Rahul Natarajan		DLT-20038	INC3335286 | [NSE] | Post state and country value to SFDC create lead in FL cob page
==================================================================================================================================
*/
public with sharing class Ecom_Lead{  
    
    private static final string LEADNAME_UNKNOWN = 'Unknown';
    private static final string TASKSTATUS_COMPLETED = 'Completed';
    private static final string CART_FORWARDED_BY_CUSTOMER = 'Cart Forwarded';
    public static String plan_name_old='';
    public static String plan_name_new='';
    public static String campaignId= '';
	public static String leadsourcedesc='LGL_Rep_LGL_NSE-Digital-New-Sales';
	public static String leadsddate='';
	public static String leadsdsegment='';
	public static String leadsdexisting='';
	public static String leadsdproductfamily='';
	public static String productfamily='';
	
	
	
    public static Lead createLead(Ecom_OrderRequest.cls_storeOrder storeOrder, String orderId, APTSECOM_Store__c str, Ecom_OrderRequest.cls_References ref)
    {
        Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('GLI').getRecordTypeId();
        Integer quantity = storeOrder.selectedProducts[0].quantity;
		
        Ecom_OrderRequest.cls_customerDetails leadInfo = storeOrder.customerDetails;
        
        Lead lead = new Lead();
        
        //Splitting into multiple queries because custom metadata have some limitation when it comes to SOQL(Disjunctions not supported)
        //Making Business field values Configurable

        String description = '';
        String queueId = Label.Ecom_Lead_OwnerId;
        Id campaign_Id;
        
        List<Campaign> camp;
              
        lead.RecordTypeId = recordTypeId;
        lead.Is_GLI__c = true; 
        lead.firstname = leadInfo.firstName;
        lead.lastname = leadInfo.lastName;
        lead.company = leadInfo.organizationName;
        lead.Email = leadInfo.businessEmail;
        lead.Phone = leadInfo.phoneNumber;
        lead.APTSECOM_Order__c = orderId;
        lead.Billing_Street__c = leadInfo.address.addressLine1;
        lead.Billing_City__c = leadInfo.address.city;
        lead.Billing_State__c = leadInfo.address.state;
        lead.Billing_Country__c = leadInfo.address.country;
        lead.Billing_Zip__c = leadInfo.address.zipCode;
        lead.street = leadInfo.address.addressLine1;
        lead.city = leadInfo.address.city;
        lead.state = leadInfo.address.state;
        lead.country = leadInfo.address.country;
		lead.Is_Marketing__c = true ;    // DLT-19602
        lead.postalcode = leadInfo.address.zipCode;
        plan_name_old=storeOrder.plan;
        
        List<Group> qs;
        if(Schema.sObjectType.Group.isQueryable())
        qs = [Select Id, Name, Email from Group  where Type = 'Queue' And Id =: queueId LIMIT 1];
        System.debug('====check ownerid==='+qs);
        if(!qs.isEmpty())
        {
            lead.OwnerId = queueId;
        }

        List<Ecom_OrderService_Mappings__mdt> lstOrderServiceMapping;
        if(Schema.sObjectType.Ecom_OrderService_Mappings__mdt.isAccessible())
        {
            lstOrderServiceMapping = [SELECT Id, DeveloperName,Customer_Pricing_Segment__c,APTSECOM_Is_Abandoned__c,Ecom_StoreName__c,Ecom_Object__c,Ecom_MinAttorney__c,Ecom_MaxAttorney__c,Ecom_Field_API__c,Ecom_Field_Value__c FROM Ecom_OrderService_Mappings__mdt WHERE Ecom_Object__c = 'Lead' AND Ecom_StoreName__c = :str.Name AND Ecom_MaxAttorney__c >= :quantity AND Ecom_MinAttorney__c <= :quantity];
            lstOrderServiceMapping.addAll([SELECT Id,DeveloperName,Customer_Pricing_Segment__c,APTSECOM_Is_Abandoned__c,Ecom_StoreName__c,Ecom_Object__c,Ecom_MinAttorney__c,Ecom_MaxAttorney__c,Ecom_Field_API__c,Ecom_Field_Value__c  FROM Ecom_OrderService_Mappings__mdt WHERE Ecom_Object__c = 'Lead' AND Ecom_StoreName__c = Null]);
            lstOrderServiceMapping.addAll([SELECT Id, DeveloperName,Customer_Pricing_Segment__c,APTSECOM_Is_Abandoned__c,Ecom_StoreName__c,Ecom_Object__c,Ecom_MinAttorney__c,Ecom_MaxAttorney__c,Ecom_Field_API__c,Ecom_Field_Value__c  FROM Ecom_OrderService_Mappings__mdt WHERE Ecom_Object__c = 'Lead' AND Ecom_StoreName__c = :str.Name AND APTSECOM_Is_Abandoned__c = false AND Ecom_MaxAttorney__c >= :NULL AND Ecom_MinAttorney__c <= :NULL]);
            lstOrderServiceMapping.addAll([SELECT Id, DeveloperName,Customer_Pricing_Segment__c,APTSECOM_Is_Abandoned__c,Ecom_StoreName__c,Ecom_Object__c,Ecom_MinAttorney__c,Ecom_MaxAttorney__c,Ecom_Field_API__c,Ecom_Field_Value__c  FROM Ecom_OrderService_Mappings__mdt WHERE Ecom_Object__c = 'Lead' AND Ecom_StoreName__c = Null AND APTSECOM_Is_Abandoned__c = :storeOrder.isAbandonedLead]);
            if(storeOrder.isAbandonedLead == true)
            {
              lstOrderServiceMapping.addAll([SELECT Id, DeveloperName,Customer_Pricing_Segment__c,APTSECOM_Is_Abandoned__c,Ecom_StoreName__c,Ecom_Object__c,Ecom_MinAttorney__c,Ecom_MaxAttorney__c,Ecom_Field_API__c,Ecom_Field_Value__c  FROM Ecom_OrderService_Mappings__mdt WHERE Ecom_Object__c = 'Lead' AND Ecom_StoreName__c = :str.Name  AND APTSECOM_Is_Abandoned__c = :storeOrder.isAbandonedLead AND Ecom_MaxAttorney__c >= :NULL AND Ecom_MinAttorney__c <= :NULL]);
            }
            System.debug('==lstOrderServiceMapping=='+lstOrderServiceMapping );
        }   
        for(Ecom_OrderService_Mappings__mdt ordSerMap : lstOrderServiceMapping)
        {            
            lead.put(ordSerMap.Ecom_Field_API__c, ordSerMap.Ecom_Field_Value__c);
        }
           //String campaignId = abandonedLeadUpdate(lead, storeOrder.isAbandonedLead, str.name); 
         
		//DLT-19503 - Stars here
		if((storeOrder.isAbandonedLead == false) && (storeOrder.isExistingCustomer == true))
		{
			leadsdexisting='-Existing';
			leadsourcedesc+=leadsdexisting;
		}
		leadsddate = Datetime.now().format('_MMyyyy_');
		leadsourcedesc+=leadsddate;
		if(storeOrder.storeName=='Corporate')
		{
			leadsdsegment='CORP';
		}
		else if (storeOrder.storeName=='Corporate Westlaw')
		{
			leadsdsegment='CORPWL';
		}
		else if(storeOrder.storeName=='FindLaw')
		{
			leadsdsegment='FL';
		}
		else if(storeOrder.storeName=='Government')
		{
			leadsdsegment='GOVT';
		}
		else if(storeOrder.storeName=='Small Law')
		{
			leadsdsegment='SLF';
		}
		else if(storeOrder.storeName=='Small Law Practical Law')
		{
			leadsdsegment='PLSLF';
		}
		leadsourcedesc+=leadsdsegment;
		Id pId=storeOrder.selectedProducts[0].productId;
		if(Schema.sObjectType.Product2.isQueryable())
		{
			Product2 p2=new Product2();
			
			p2=[SELECT Family from Product2 where id =:pId];
			if(p2.Family!='')
			{
				productfamily=p2.Family;
        if(productfamily.contains('WEST'))
				{
					leadsdproductfamily='_WL';
				}
				else if(productfamily.contains('PRACTICAL'))
				{
					leadsdproductfamily='_PL';
				}
				leadsourcedesc=leadsourcedesc+leadsdproductfamily;
			}
		}
		lead.Source_Desc__c=leadsourcedesc;
	//DLT-19503 - Ends  here
        
        
        if(storeOrder.additionalInfo.trackingCodeCID != null)
        {
          lead.Tracking_Code__c = storeOrder.additionalInfo.trackingCodeCID; 
          System.debug('====Cxd bug Tracking_Code__c ==='+lead.Tracking_Code__c); //DLT-17697
        } 
        
        if(storeOrder.additionalInfo.campaignId != null)
        {
          campaignId = storeOrder.additionalInfo.campaignId;  
            // DLT-18470: gather from eloqua cookie
        System.debug('====Cxd bug campaignId -I==='+campaignId); //DLT-17697
        }        
        if(storeOrder.isJourneyEnded!= null && storeOrder.isJourneyEnded)
        {
            campaignId = storeOrder.additionalInfo.campaignId;
        }
            
        if(storeOrder.isHouseDetaineesOrg!= null && storeOrder.isHouseDetaineesOrg)
        {
            campaignId = Label.Ecom_House_Detainee_CampaignCode;
            System.debug('====Cxd bug campaignId -II==='+campaignId); //DLT-17697
        }
        if((storeOrder.additionalInfo.campaignId==null)||(storeOrder.additionalInfo.trackingCodeCID==null) ||(storeOrder.additionalInfo.campaignId=='')||(storeOrder.additionalInfo.trackingCodeCID=='') )  //Negative sceanrio for eloqua cookie    //DLT-17697     
        {
            List<APTSECOM_New_Sales_Lead_Values__mdt> leadValues;
        if(Schema.sObjectType.APTSECOM_New_Sales_Lead_Values__mdt.isAccessible())
        leadValues = [Select Id,Ecom_Campaign_Cell__c,ECOM_Tracking_Code__c,Ecom_Campaign_ID__c,APTSECOM_Is_Abandoned__c,APTSECOM_Store__c  
                                                                from APTSECOM_New_Sales_Lead_Values__mdt where APTSECOM_Is_Abandoned__c =: storeOrder.isAbandonedLead  and APTSECOM_Store__c =: str.name AND End_Journey_Reason__c = Null ]; 
            
                if((storeOrder.additionalInfo.campaignId==null)||(storeOrder.additionalInfo.campaignId==''))
                {
                    campaignId=leadValues[0].Ecom_Campaign_ID__c;
                }
                if((storeOrder.additionalInfo.trackingCodeCID==null)||(storeOrder.additionalInfo.trackingCodeCID==''))
                {
                    lead.Tracking_Code__c=leadValues[0].ECOM_Tracking_Code__c;
                }
                
        
        }
        camp = [Select id from Campaign where id =: campaignId];        
        System.debug('====Cxd bug camp==='+camp); //DLT-17697
        if(!camp.isempty())
        {
          lead.Primary_Campaign_Source__c = campaignId;
          System.debug('====Cxd bug Primary_Campaign_Source__c==='+lead.Primary_Campaign_Source__c); //DLT-17697
           System.debug('===check campaign==='+lead);
        }
        
        String leadDescMethod;      
         
        if(storeOrder.additionalInfo.leadDescription != null || storeOrder.additionalInfo.leadDescription != '')
        {
           leadDescMethod = getLeadDescription(storeOrder);
           if(leadDescMethod != null)
           {
             lead.Description = storeOrder.additionalInfo.leadDescription + ' ; ' + leadDescMethod;
           }
           else
           {
              lead.Description = storeOrder.additionalInfo.leadDescription;
           }            
        }
        else
        {           
          lead.Description = getLeadDescription(storeOrder);
        }
               
        if(storeOrder.isExistingCustomer){
            lead.Account__c = ref.accountId;
        }
        
        if( (storeOrder.isExistingCustomer && storeOrder.isJourneyEnded) || (String.isBlank(lead.firstname) && String.isBlank(lead.lastname)) ||  (lead.firstname == LEADNAME_UNKNOWN && lead.lastname == LEADNAME_UNKNOWN) ){
            lead.firstname = Label.ECOM_LEAD_UNKNOWN_FIRSTNAME;
            lead.lastname =  Label.ECOM_LEAD_UNKNOWN_LASTNAME;
        }
        
        // Check if the user has create access on the Lead object
        if(Schema.sObjectType.Lead.isCreateable()) 
        {
           insert lead;
        }
    
        System.debug('===check fields in lead==='+lead);
        
        // Lead and Campaign are not directly related to each other
        if((campaignId !='' || campaignId!=null) && (!camp.isempty()))
        {
            try{
                campaign_Id=Id.valueOf(campaignId);
                CampaignMember member = new CampaignMember (campaignid=campaign_Id, leadid=lead.Id);
                if(Schema.sObjectType.CampaignMember.isCreateable())
                insert member;
                System.debug('====Cxd bug CampaignMember==='+member); //DLT-17697
            }catch(Exception ex){
                DCUtils.trackLog(ex,'Ecom_lead','createLead -CampaignMember ');
            }
        }
        
        if(storeOrder.additionalInfo.forwardCart && leadInfo.recipients.mail1!=null)
        {
         addactivity(lead, leadInfo,storeOrder.additionalInfo.activityDesc);
        }
        
        return lead;
    }
    
     
    public static String abandonedLeadUpdate(Lead lead, boolean isAbandoned, String store)
    {
        List<APTSECOM_New_Sales_Lead_Values__mdt> leadValues;
        if(Schema.sObjectType.APTSECOM_New_Sales_Lead_Values__mdt.isAccessible())
        leadValues = [Select Id,Ecom_Campaign_Cell__c,Ecom_Campaign_ID__c,APTSECOM_Is_Abandoned__c,APTSECOM_Store__c  
                                                                from APTSECOM_New_Sales_Lead_Values__mdt where APTSECOM_Is_Abandoned__c =: isAbandoned  and APTSECOM_Store__c =: store AND End_Journey_Reason__c = Null ];
     
        if( leadValues.isEmpty() )
        {
            return null;
        }

        return leadValues[0].Ecom_Campaign_ID__c;
    }
    
    //set ownerid on lead while converting lead- ecom_orderservice call
    public static String updateConvertLead(String leadId, APTSECOM_Store__c store)
    {
        
        Lead lead = new Lead();
        lead.Id = leadId;
        
        List<Ecom_OrderService_Mappings__mdt> lstOrderServiceMapping;
        if(Schema.sObjectType.Ecom_OrderService_Mappings__mdt.isQueryable())
        lstOrderServiceMapping = [SELECT Id,Ecom_StoreName__c,Ecom_Owner__c FROM Ecom_OrderService_Mappings__mdt WHERE Ecom_StoreName__c =: store.Name AND Ecom_Owner__c != null LIMIT 1];
        String getleadOwnerName = lstOrderServiceMapping[0].Ecom_Owner__c; 

        return [SELECT Id FROM User WHERE Name =: getleadOwnerName AND IsActive = true LIMIT 1].Id;

    }
    
    
    //Method to update values on lead when leadId in Session - ecom_orderservice call
    public static void updateLead(String leadId, Ecom_OrderRequest.cls_customerDetails customerDetails,Ecom_OrderRequest.cls_storeOrder storeOrder){
        Lead leadrec = [Select Id,Description from Lead where id =: leadId];
        List<Campaign> camp;
         List<Ecom_OrderService_Mappings__mdt> lstOrderServiceMapping;
        Lead lead = new Lead();
        lead.Id = leadId;
        lead.firstname = customerDetails.firstName;
        lead.lastname = customerDetails.lastName;
        lead.company = customerDetails.organizationName;
        lead.Email = customerDetails.businessEmail;
        lead.Phone = customerDetails.phoneNumber;
        lead.street = customerDetails.address.addressLine1;
        lead.city = customerDetails.address.city;
		// Added Null Check - DLT-20038
		if(customerDetails.address.state!='' && customerDetails.address.state!=null){
        lead.state = customerDetails.address.state;
		}
        lead.country = customerDetails.address.country;
        lead.postalcode = customerDetails.address.zipCode;
        lead.Billing_Street__c = lead.street;
        lead.Billing_City__c = lead.city;
        lead.Billing_State__c = lead.state;
        lead.Billing_Country__c = lead.country;
        lead.Billing_Zip__c = lead.postalcode;
        Boolean result = false;
        
        
        if(storeOrder.additionalInfo.forwardCart== true)
        {
         Task ld_task = [Select Id, Subject, Description from Task where whoid=:leadId];
         if (ld_task!=null)
          {            
             ld_task.Subject = storeOrder.additionalInfo.activityDesc;             
          }
         update ld_task;
        }
	
     if(storeOrder.storeName == 'FindLaw' && storeOrder.isAbandonedLead == false && storeOrder.isExistingCustomer == true)
        {          
            
            lead.Campaign_Cell__c = 'Existing';      
            
            //String campaignId = abandonedLeadUpdate(lead, storeOrder.isAbandonedLead, 'FindLaw');
             campaignId = storeOrder.additionalInfo.campaignId;   // DLT-18470: gather from eloqua cookie          
            camp = [Select id from Campaign where id =: campaignId];         
                           
            if(!camp.isempty())
            {
              lead.Primary_Campaign_Source__c = campaignId;
              //System.debug('===check campaign in update==='+lead);
            }                        
        }
        Boolean duplicatedesc = false;
        
        if(leadrec.Description != null)
        {
          duplicatedesc = (leadrec.description.contains('See Activity for details'));
        }
        
        String leadDescMethod;
         
        if(storeOrder.additionalInfo.leadDescription != null || storeOrder.additionalInfo.leadDescription != '')
        {
          leadDescMethod = getLeadDescription(storeOrder);
        }
                                        
        if(leadrec.Description != null && storeOrder.storeName == 'FindLaw' && storeOrder.additionalInfo.leadDescription != null && duplicatedesc == false)
        {
          if(leadDescMethod != null)
          {
            lead.Description = leadrec.Description + ' ; ' + storeOrder.additionalInfo.leadDescription + ' ; ' + leadDescMethod;
          }
          else
          {
            lead.Description = leadrec.Description + ' ; ' + storeOrder.additionalInfo.leadDescription;
          }
        }
        else if(leadrec.Description != null && storeOrder.storeName == 'FindLaw' && duplicatedesc == false && (String.isBlank(storeOrder.additionalInfo.leadDescription)) )
        {
          lead.Description = leadrec.Description + ' ; ' + getLeadDescription(storeOrder);
        }
        else if(leadrec.Description != null && storeOrder.storeName == 'FindLaw' && storeOrder.additionalInfo.leadDescription != null && duplicatedesc == true)
        {
         
          lead.Description = leadrec.Description.substringBefore('Plan:');
          lead.Description = lead.Description + ' ; ' + storeOrder.additionalInfo.leadDescription;
          
        }
        else if((storeOrder.additionalInfo.leadDescription != null || storeOrder.additionalInfo.leadDescription != '') && duplicatedesc == true && storeOrder.storeName != 'FindLaw')
        {
           lead.Description = storeOrder.additionalInfo.leadDescription;
        }
        else
        {
           lead.Description = getLeadDescription(storeOrder);
        }
        
         System.debug('===check lead fields on update==='+lead);
          
        if(Schema.sObjectType.Lead.isUpdateable()) 
        {
          update lead;
        }    
         
         
    }   
    
    public static void addactivity(Lead ld, Ecom_OrderRequest.cls_customerDetails customerDetails, String adddesc)
         {
         Task task = new Task();
         task.Subject=Label.Ecom_Cart_Forwarded;
         task.Status=TASKSTATUS_COMPLETED;
         task.Status__c=TASKSTATUS_COMPLETED;
        
         task.Description= customerDetails.recipients.mail1 +'\n';
         if(customerDetails.recipients.mail2!=null)
           task.Description=task.Description + customerDetails.recipients.mail2 +'\n';
         if(customerDetails.recipients.mail3!=null)
           task.Description=task.Description + customerDetails.recipients.mail3 +'\n';
         if(customerDetails.recipients.mail4!=null)
           task.Description=task.Description + customerDetails.recipients.mail4 +'\n';
         if(customerDetails.recipients.mail5!=null)
           task.Description=task.Description + customerDetails.recipients.mail5;
         
         task.whoid=ld.Id;
         task.ActivityDate=System.today();
         if(Schema.sObjectType.Task.isCreateable())
         insert task;
         
         }
      
    public static String getLeadDescription(Ecom_OrderRequest.cls_storeOrder storeOrder ) {
        
        String separator = '; ';
        String description = ' '; 
       
        if(String.isBlank(storeOrder.additionalInfo.leadDescription))
        {
          description = storeOrder.plan + separator;
        }
        
        if(String.isNotBlank(storeOrder.customerDetails.phoneExtension))
        {
           description += 'Extn: '+ storeOrder.customerDetails.phoneExtension + separator;
        }
        
        if(storeOrder.isJourneyEnded == true )
        {
            description += storeOrder.additionalInfo.reasonToEndJourney + separator ;
        }
        
        if(storeOrder.additionalInfo.isGetQuoteClicked== true)
        {
            description += Label.Ecom_GetQuote_Clicked + separator;
        }
        
        if(storeOrder.additionalInfo.forwardCart== true && (String.isBlank(storeOrder.additionalInfo.leadDescription)))
        {
            description += storeOrder.additionalInfo.activityDesc + separator; 
        }
        
        System.debug('===check description string ==='+description );
        return description;
    }
      
}
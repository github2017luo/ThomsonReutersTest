/*
======================================================================================================================
TEST CLASS NAME: SubscriptionServices_Test
======================================================================================================================
PURPOSE: Validates the functionality provided by the SubscriptionServices class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@istest
public with sharing class SubscriptionServices_Test{
    Private static testMethod Void testSubItem(){
        
       // map<string,SubscriptionServices.Subitem> SubitemList = new map<string,SubscriptionServices.Subitem>();
         List<SubscriptionServices.Subitem> SubitemList = new List<SubscriptionServices.Subitem>();
        decimal[] accountSapIdList = new decimal[]{decimal.valueof('1')}; 
        SubscriptionServices.SubsRequest oRequest = new SubscriptionServices.SubsRequest();  
        oRequest.AcctSapId = accountSapIdList;
        oRequest.SubType = 'Test';
        oRequest.IncludeActiveSubs=true;
        oRequest.IncludeLapsedSubs=false;
        SubitemList= SubscriptionServices.getSubItems(oRequest);  
       
    }
        Private static testMethod Void testCalculatePDA(){
            SubscriptionServices.PdaItem oPdaItem = new SubscriptionServices.PdaItem(); 
            SubscriptionServices.CalculatePDARequest oRequest = new SubscriptionServices.CalculatePDARequest();  
        oRequest.SystemId = 'Test';
        oRequest.SubKey =  new String[]{'Test'};
        oRequest.DiscountPercent = decimal.valueof('10');
        oRequest.MinimumIncrementalValue = decimal.valueof('10');
        oPdaItem = SubscriptionServices.CalculatePda(oRequest);
        }
    
  /*  Private static testMethod Void testSubLine(){
        SubscriptionServices oTestServices = new SubscriptionServices();
        List<SubscriptionServices.SubLineitem> oSubLineitem= new List<SubscriptionServices.SubLineitem>();
        SubscriptionServices.SubLineRequest oRequest = new SubscriptionServices.SubLineRequest();                       
        oRequest.AcctSAPId = decimal.valueof('1');
        oRequest.ContractNumber='test';                            
        oSubLineItem =oTestServices.GetSubLineItem(oRequest);
        
    }*/
    
    Private static testMethod Void testSubUser(){
        SubscriptionServices oTestServices = new SubscriptionServices();
        list<SubscriptionServices.SubUseritem> oSubUseritem= new list<SubscriptionServices.SubUseritem>();
        SubscriptionServices.SubUserRequest oRequest = new SubscriptionServices.SubUserRequest();                                           
        oRequest.AcctSAPId = decimal.valueof('1');                       
        oRequest.ContractNumber='test'; 
        oRequest.OrderItem='test';                      
        oSubUseritem=oTestServices.GetSubUserItem(oRequest);  
        
        SubscriptionServices.Request a = new SubscriptionServices.Request();
        a.Username='hello';
        a.Password='hello';
        a.accessToken ='hello';
        a.CompanyCode ='hello';
        a.SalesOrgCode ='hello';
        a.DistChanCode = 'hello';
        a.DivisionCode = 'hello';
    }
}
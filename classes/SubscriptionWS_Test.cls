/*
======================================================================================================================
TEST CLASS NAME: SubscriptionWS_Test
======================================================================================================================
PURPOSE: Validates the functionality provided by the SubscriptionWS class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@ istest
public class SubscriptionWS_Test{
  public static testMethod void testWebServiceSchema() {
    SubscriptionsWS testobj = new SubscriptionsWS();
    //SubscriptionsWS.GetSubLineItem_element testobj1= new SubscriptionsWS.GetSubLineItem_element();
    SubscriptionsWS.Subs_v4_0Port testobj2= new SubscriptionsWS.Subs_v4_0Port();
    Test.setMock(WebServiceMock.class, new WebServiceMockGetSubsResponse_element());//Added as part of s2eOptimisation project [Rajashree]
    SubscriptionsWS.GetSubUserItemResponse_element testobj3= new SubscriptionsWS.GetSubUserItemResponse_element();
    SubscriptionsWS.GetSubsResponse_element testobj4= new SubscriptionsWS.GetSubsResponse_element();
    SubscriptionsWS.CalculatePdaResponse_element testobj5= new SubscriptionsWS.CalculatePdaResponse_element();
    //SubscriptionsWS.GetSubLineItemResponse_element testobj6= new SubscriptionsWS.GetSubLineItemResponse_element();
    SubscriptionsWS.GetSubUserItem_element testobj7= new SubscriptionsWS.GetSubUserItem_element();
    SubscriptionsWS.GetSubs_element testobj8= new SubscriptionsWS.GetSubs_element();
 
        
    List<SubscriptionsWSObject.SortParm> SortParms = new SubscriptionsWSObject.SortParm[]{};
    SortParms.add(new SubscriptionsWSObject.SortParm());
    SortParms[0].ParmName= 'SubscriptionStatus';
    SortParms[0].SortDirection ='ASC';
    SortParms.add(new SubscriptionsWSObject.SortParm());
    SortParms[1].ParmName =  'MaterialDesc';
    SortParms[1].SortDirection ='ASC';

    SubscriptionsWS.CalculatePda_element testobj9= new SubscriptionsWS.CalculatePda_element();
    testobj2.GetSubs('test',new Decimal[]{0},'test','test','test','test','test',true,true,1,500,SortParms );
    testobj2.GetSubUserItem('test',decimal.valueof('0'),'test','test','test','test','test','test'); 
    testobj2.CalculatePda('test',new String[]{'test'},0,0);
    //testobj2.GetSubLineItem('test',0,'test','test','test','test','test');
       
  }
 }
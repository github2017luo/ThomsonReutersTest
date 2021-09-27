/*
======================================================================================================================
TEST CLASS NAME: SubscriptionWSObject_Test
======================================================================================================================
PURPOSE: Validates the functionality provided by the SubscriptionWSObject class.

CHANGE HISTORY:
======================================================================================================================
DATE             NAME           DESC
31/03/2017       Gunaseelan K   Optimized the code as per JIRA STORY: PS0-1
======================================================================================================================
*/
@istest
public with sharing class SubscriptionWSObject_Test{
    public static testmethod void testController(){   
        SubscriptionsWSObject testobj1 = new SubscriptionsWSObject();
        SubscriptionsWSObject.SubItem testobj2 = new SubscriptionsWSObject.SubItem(); 
      //  SubscriptionsWSObject.SubLineItem testobj3 = new SubscriptionsWSObject.SubLineItem();
        SubscriptionsWSObject.SubUserItem testobj4  =new SubscriptionsWSObject.SubUserItem();
        SubscriptionsWSObject.PdaItem testobj5 = new SubscriptionsWSObject.PdaItem();
        SubscriptionsWSObject.PdaLineItem testobj6  =new SubscriptionsWSObject.PdaLineItem();    
    } 
}
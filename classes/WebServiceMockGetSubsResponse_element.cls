//Created this class as part of s2eOptimisation project to be called from SubscriptionWS_Test [Rajashree]
@isTest
global class WebServiceMockGetSubsResponse_element implements WebServiceMock{
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
       SubscriptionsWS.GetSubsResponse_element respElement = 
           new SubscriptionsWS.GetSubsResponse_element();
       SubscriptionsWSObject.Sub ss = new SubscriptionsWSObject.Sub();
       respElement.Sub = ss;
       Map<String, SubscriptionsWS.GetSubsResponse_element> response_map_x = new Map<String, SubscriptionsWS.GetSubsResponse_element>();
       response_map_x.put('response_x', respElement); 
   }
}
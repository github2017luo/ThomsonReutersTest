@isTest

public class ContentOptimizerServiceWS_Test{

    public static testmethod void testContentOptimizerServiceWS(){
        ContentOptimizerServiceWS.Customer oCustomer = new ContentOptimizerServiceWS.Customer();
        ContentOptimizerServiceWS.CalculateMatchResponse_element oCalculateMatchResponse_element = new ContentOptimizerServiceWS.CalculateMatchResponse_element();
        ContentOptimizerServiceWS.GetDatabases_element otestobj = new ContentOptimizerServiceWS.GetDatabases_element();
        ContentOptimizerServiceWS.PlanContent otestobj1 = new ContentOptimizerServiceWS.PlanContent();
        ContentOptimizerServiceWS.GetCustomerResponse_element otestobj2 = new ContentOptimizerServiceWS.GetCustomerResponse_element();
        ContentOptimizerServiceWS.DatabaseItem otestobj3 = new ContentOptimizerServiceWS.DatabaseItem();
        ContentOptimizerServiceWS.DatabaseContent otestobj4 = new ContentOptimizerServiceWS.DatabaseContent();
        ContentOptimizerServiceWS.ContentOptimizer_v1_0Port testPort = new ContentOptimizerServiceWS.ContentOptimizer_v1_0Port();
        testPort.GetDatabases('0001','test','test',001,2,true,true,new Long[] {0});
        testPort.GetCustomer('001',0,true);
        testPort.CalculateMatch('001','test',001,'test',1,true,true);
        ContentOptimizerServiceWS.CalculateMatch_element otestobj0 = new ContentOptimizerServiceWS.CalculateMatch_element();
        ContentOptimizerServiceWS.CalculatePlanResponse_element otestobj5 = new ContentOptimizerServiceWS.CalculatePlanResponse_element();
        ContentOptimizerServiceWS.CalculatePlan_element otestObj6 = new ContentOptimizerServiceWS.CalculatePlan_element();
        ContentOptimizerServiceWS.GetDatabasesResponse_element otestObj7 = new ContentOptimizerServiceWS.GetDatabasesResponse_element();
        ContentOptimizerServiceWS.MaterialItem otestObj8 = new ContentOptimizerServiceWS.MaterialItem();
        ContentOptimizerServiceWS.MaterialContent otestObj9 = new ContentOptimizerServiceWS.MaterialContent(); 
        ContentOptimizerServiceWS.GetCustomer_element otestObj10 = new ContentOptimizerServiceWS.GetCustomer_element();
        
        
        
    }
}
@isTest
public class FlowCoverageTest {
    
    public static testMethod void runFlowCoverageMthods() 
    {
    
    Test.startTest();
    FlowCoverageClass.getUncoveredFlows();
    //FlowCoverageClass.orgFlowCoverage();
    FlowCoverageClass.emailTotalCoverage();
    FlowCoverageClass.flowId = FlowCoverageClass.flowVerId;
    system.debug('FlowId'+FlowCoverageClass.flowId);
    FlowCoverageClass.getFlowDetail();
    FlowCoverageClass.emailFlowCoverage();
           
    Test.stopTest();
    
    
    }
    
    }
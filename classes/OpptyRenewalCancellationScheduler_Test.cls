@isTest
public class OpptyRenewalCancellationScheduler_Test{
    
    @isTest static  void OpptyRenewalCancellationBatch_Schedulertest() {
        
        
        Test.startTest();
      
        OpptyRenewalCancellationBatch_Scheduler  renewaloppty = new OpptyRenewalCancellationBatch_Scheduler ();       
        String sch = '0 00 00 * * ?';
        String jobId = System.schedule('Sample_Heading', sch, renewaloppty);   
        Test.stopTest();
        System.assert(jobId != null); 
    } 
    
    
    
}
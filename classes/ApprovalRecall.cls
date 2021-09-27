global class ApprovalRecall
{
    webservice static void recallApproval(Id id)    
    {        
        try{
            Quote oquote = new quote ();
            List<Quote> quoteList = new List<Quote>();
            List<ProcessInstanceWorkitem> listaAprobacionPendiente = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: id];
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            
                if(listaAprobacionPendiente.size()>0){
                    req.setWorkitemId(listaAprobacionPendiente[0].Id);  
                    req.setAction('Removed');        
                    Approval.ProcessResult result = Approval.process(req,false);
                }
            
                if(id!=null){
                    oquote.id = id ;
                    oquote.Pricing_Approval_Complete__c = false;
                    oquote.Approval_Status__c = null;
                    oquote.Status = 'In Review';
                    update oquote;
                }
           
        }catch(DmlException e){
            system.debug('$$Exception'+e);
        }
       
    }    
    
}
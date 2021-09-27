/** 
 * @description : This is the class to handle the general queue class for handling all docusign activity 
 * @Author : Avudaiappan A
 */
public without sharing class DCPDocusignDelayProcess implements Queueable{
	private string quoteId;
    private string funcName;
    public Static String supportEmail = Static_Values__c.getValues('OrderProcessSupportEmail').Value__c; // Email address of support team member

	 /** 
 * @description : This is the constructor method
 * @param quoteId - String of Id
 * @param funcName - String of function
 */
    public DCPDocusignDelayProcess(string quoteId, string funcName){
         this.quoteId = quoteId;
         this.funcName = funcName;
    }
    /** 
 * @description : This is the execute method
 * @param context - Queueable Context
 */ 
    public void execute(QueueableContext context) {
    string timeframeToProcessOrder = String.isNotBlank(Static_Values__c.getValues('DocusignDelayTimer').Value__c)?Static_Values__c.getValues('DocusignDelayTimer').Value__c:'3';  
       //string timeframeToProcessOrder = '3'; 
        integer schMin = 10;
        
        if(timeframeToProcessOrder.isNumeric()){
            schmin = integer.valueOf(timeframeToProcessOrder);
        }
        
        DCPDocusignBatchController os = new DCPDocusignBatchController(this.quoteId);
        DCPNewSaleCompleteEnvQueue comJob = new DCPNewSaleCompleteEnvQueue(this.quoteId);
        DCPNewSaleCreateEnvQueue createJob = new DCPNewSaleCreateEnvQueue(this.quoteId);
        dateTime dt = system.now();
        dt = dt.addMinutes(schmin);
        
        
        
        String day = string.valueOf(dt.day());
        String month = string.valueOf(dt.month());
        String hour = string.valueOf(dt.hour());
        String minute = string.valueOf(dt.minute() );
        String second = string.valueOf(dt.second());
        String year = string.valueOf(dt.year());
        
        String strJobName = 'UEStore-'+quoteId+'-'+DateTime.now()+'-'+second;
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
        
        
        if(funcName == 'sendDoc'){
        	system.schedule(strJobName , strSchedule, os);
        }else if(funcName =='createEnv'){
            system.schedule(strJobName+'1', strSchedule, createJob);
        }else if(funcName =='completeEnv'){
            system.schedule(strJobName+'1', strSchedule, comJob);
        }
    }

    
        
}
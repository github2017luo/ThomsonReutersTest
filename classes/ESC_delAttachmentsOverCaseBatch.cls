/*   ***** Code for Executing below Batch*****
*   ESC_delAttachmentsOverCaseBatch batchClas = new ESC_delAttachmentsOverCaseBatch();
*   Database.executeBatch(batchClas, 50);
* 
* */
 
global class ESC_delAttachmentsOverCaseBatch implements Database.Batchable<sObject> {
    

    global Database.QueryLocator start(Database.BatchableContext BC) {
        
         string subbu = 'UKI';
            string origin = 'Web';
            string direct = 'DirectDebit';
            string time1 = Label.GLI_W2C_Datetime;
            string query = 'select id,casenumber,createdbyid,ClosedDate,(select id,name,createdbyid from attachments) from case where Is_ESC_Case__c = true and LCRM_Sub_BU__c =\'' +subbu+'\' and Origin = \'' + origin + '\' and isClosed = true and ESC_Migrated_to_Sharepoint__c = true and ESC_Origin_Name__c like ' + '\'%'+ direct + '%\' and ClosedDate = ' + time1;
           
        if(!test.isRunningTest()){
            return Database.getQueryLocator(query);
         }
        return Database.getQueryLocator([select id,
                                                casenumber,createdbyid,
                                                    (select id,
                                                            name,createdbyid
                                                                 from attachments)
                                                     from case 
                                                         where LCRM_Sub_BU__c = 'UKI' 
                                                                   and 
                                                               Origin = 'Web' 
                                                                   and
                                                               ESC_Migrated_to_Sharepoint__c = true
                                                                   and
                                                               ESC_Origin_Name__c like '%DirectDebit%']);
                                                              
    }
    
    global void execute(Database.BatchableContext BC, list<sObject> scope){
        List<Case> lstCases = (List<Case>) scope;
        List<attachment> lstdelattch = new List<attachment>();
        System.debug('lstCases ::'+lstCases);
        //List for Updating records
        for(Case cs : lstCases ){
            if(cs.attachments.size()>0){
                for(Attachment a:cs.attachments){
                    if(a.createdbyid == cs.createdbyid){
                        lstdelattch.add(a);
                    }
                }
            }
            
        }
        
        if(lstdelattch.size() > 0){
            try{
                Database.DeleteResult[] srList = Database.delete(lstdelattch);
                system.debug('srList***'+srList);
                //delete lstdelattch;
            } catch(Exception ex){
                System.debug('Exception while updating ::'+ex);
            }
        }
    }
 
    global void finish(Database.BatchableContext BC){
        
    }

}
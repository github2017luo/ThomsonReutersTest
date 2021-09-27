/**
 * ODT_OnePassSchedulable Description
 *  DLT-20639 - 18-09-202 - Refactored Code ,Solved PMD violations
 */
public without sharing class ODT_OnePassSchedulable implements Schedulable  {

    public void execute(SchedulableContext sc){
        DataBase.executeBatch(new ODT_OnePassQueueable (), 1);
    }
    
}